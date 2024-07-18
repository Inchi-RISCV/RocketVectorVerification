#!usr/bin/python
# -*- coding: utf-8 -*-

import re
import sys
import os
import random
import getopt
import time
import glob

def usage():
    print('------------------------------------------------------------------')
    print("      USAGE: python regress.py -help/h (print this message)       ")
    print("      submit jobs        : python regress.py -r    tc_list        ")
    print("      get regress result : python regress.py --rpt tc_list        ")
    print("      resubmit fail jobs : python regress.py --rerun              ")
    print("------------------------------------------------------------------")

def get_list_argv(ar_list):
    regr_para_dict = {}
    for i in ar_list:
        tmp_list = []
        tmp_list = i.split('=')
        regr_para_dict[tmp_list[0]] = tmp_list[1]
    return regr_para_dict

def analy_tclist(list_path):
    dict_list = []
    with open(list_path, 'r') as f:
        for line in f.readlines():
            if '#'== line[0] or line[0] == '//' :
                continue
            else:
                line = line.replace(' ','')
                line = line.replace('{','')
                line = line.replace('}','')
                line = line.replace('"','')
                line = line.strip('\n')
                line_arr = line.split(',')
                para_dict = {}
                para_dict = get_list_argv(line_arr)
                dict_list.append(para_dict)
                # print line, para_dict
    return dict_list


def get_list_path(list_path):
    if not (os.path.exists(list_path)):
       print("Error! ! ! tc list not found,maybe path error")
       sys.exit()
    regr_list_path = os.path.realpath(list_path)
    return regr_list_path

def run_sim(dict_list):
    jobs_cnt = 0
    regr_num = 0
    all_regr_list = []
    # deal comp, sim log
    #print dict_list
    for p_idx in dict_list:
        tmp_mode_name = p_idx['mode']
        tmp_cov_en    = p_idx['cov']
        tmp_mode_dir  = os.path.abspath(tmp_mode_name)
        if not (os.path.exists(tmp_mode_dir + '/exec')):
            os.system('make comp cov=%s mode=%s'%(tmp_cov_en, tmp_mode_name))
        if not (os.path.exists(tmp_mode_dir + '/logs')):
            os.mkdir(tmp_mode_name + '/logs')
        else:
            for i in os.listdir(tmp_mode_dir + '/logs'):
                pth_fi = tmp_mode_dir + '/logs/' + i
                #if i != 'vcs_compiler.log':
                    #os.remove(pth_fi)
    # submit regression jobs
    for para in dict_list:
        mode_name  = para['mode']
        tc_name    = para['tc']
        cov_en     = para['cov']
        re_num_str = para['num']
        re_num_int = int(re_num_str)
        del para['mode']
        del para['num']
        del para['tc']
        cmd_str = ''
        for key,value in para.items():
            cmd_str = cmd_str + key + '=' + value + ' '
        re_num_int = int(re_num_str)
        regr_num   = regr_num + re_num_int
        for j in range(0, re_num_int):
            new_str = ("make ncrun mode=%s tc=%s %s" %(mode_name,tc_name,cmd_str))
            all_regr_list.append(new_str)
            # seed = random .randint (10000000,99999999)
            # os.system ("bsub -J 'regression' make run mode=%s seed=%s %s" %(mode_ name,seed,cmd_str))
            # #jobs_cnt = jobs_cnt + 1
    seed_list = random.sample(range(10000000, 99999999), regr_num)
    if len(seed_list) != len(all_regr_list):
        print("ERROR! seed list len not equal all_regr_list len")
    for seed,run_cmd in zip(seed_list, all_regr_list):
        tmp_str = run_cmd + ' seed=%s'%(seed)
        regression = write_bash_script(tmp_str,seed)
        print('sbatch %s' %regression)
        os.system('sbatch %s' %regression)
        jobs_cnt = jobs_cnt + 1
    print("%d jobs were submitted" %jobs_cnt)

def write_bash_script(write_options,number):
    num = number
    regression_path = ("/datahdd/slurm_data/slurm%d.sh" %num)
    with open(regression_path,'w+') as fs:
        fs.write("#!/bin/bash\n")
        fs.write("#SBATCH -J %d\n" %num)
        #fs.write("#SBATCH -w ictest2\n")
        fs.write("#SBATCH --mem-per-cpu=1000\n")
        fs.write("#SBATCH --nodes=1\n")
        #fs.write("#SBATCH --ntasks-per-node=1\n")
        fs.write("#SBATCH --cpus-per-task=1\n")
        #fs.write("#SBATCH --oversubscribe\n")
        fs.write("#SBATCH -t 6:0:0\n")
        fs.write("#SBATCH -o /datahdd/slurm_data/result%d\n" %num)
        fs.write("\n")
        fs.write("\n")
        fs.write("\n")
        fs.write("echo ${SLURM_JOB_NODELIST}\n")
        fs.write("%s" %write_options)
    return regression_path

def judge_cfg(input_file,cfg_str):
    cfg_match = 0
    with open(input_file,'r') as f:
        line = f.readline()
        for i in cfg_str:
            if i in line:
                cfg_match = 1
                return cfg_match
            else:
                cfg_match = 0
                #break
    #return cfg_match

def get_last_nline(input_file):
    filesize = os.path.getsize(input_file)
    if filesize == 0:
        return None
    else:
        with open(input_file,'rb') as fp:
            offset = -40
            while -offset < filesize:
                fp.seek(offset,2)
                lines = fp.readlines()
                if len(lines) >= 40:
                    return lines
                else:
                    offset *= 2
            fp.seek(0)
            lines = fp.readlines()
            return lines

def get_sim_result(last_nline_list):
    sim_result      = ''
    pass_ftl_flag   = 0
    pass_err_flag   = 0
    for line in last_nline_list:
        if 'UVM_FATAL' in line and '(' not in line:
                new_line = line.replace(' ', '')
                new_line =new_line.replace('\n','')
                line_lst =new_line.split(':')
                if line_lst[-1] == '0':
                    pass_ftl_flag = 1
        if 'UVM_ERROR' in line and '(' not in line:
                new_line = line.replace(' ','')
                new_line = new_line.replace('\n','')
                line_lst = new_line.split(':')
                if line_lst[-1] == '0':
                    pass_err_flag = 1
    if ((pass_err_flag== 1) and (pass_ftl_flag == 1)):
        sim_result = 'PASS'
    else:
        sim_result = 'FAIL'
    return sim_result


def deal_log(in_dict_list):
    all_log_list    = []
    total_res_list  = []
    total_pass_num  = 0
    total_fail_num  = 0
    total_tc_num    = 0
    for para in in_dict_list:
        mode_name    = para['mode']
        mode_dir     = os.path.abspath(mode_name)
        log_dir      = mode_dir + '/logs'
        tc_name      = para['tc']
        tc_num       = para['num']
        num_int      = int(tc_num)
        fsdb_sw      = para['fsdb']
        tc_cfg       = para['cfg']
        log_list     = os.listdir(log_dir)
        tmp_dict     = {}
        test_num     = 0
        fail_num     = 0
        pass_num     = 0
        rm_elem      = []
        cmd_list     = []
        # new_cfg_str  = para['cfg'] + '.cfg'
        del para['mode']
        del para['tc']
        # del para[ 'cfg']
        del para['num']
        del para['fsdb']
        total_tc_num = total_tc_num + num_int
        for t_key,t_value in para.items():
            if t_key == 'cfg':
                new_str       = t_value
                #new_str       = t_value + '.cfg'
                cmd_list.append(new_str)
        for lp_log in log_list:
            if tc_name in lp_log:
                log_path     =log_dir + '/' +lp_log
                cfg_exist    =judge_cfg(log_path,cmd_list)
                if cfg_exist == 1:
                    test_num        = test_num + 1
                    seed            = ''
                    sim_result      = ''
                    tmp_log         = lp_log.replace('.log','')
                    tmp_log         = tmp_log.replace(tc_name,'')
                    seed            = tmp_log.replace('_','')
                    log_last_nline  = get_last_nline(log_path)
                    #print("deal log")
                    sim_result      = get_sim_result(log_last_nline)
                    if (sim_result == 'PASS'):
                        pass_num = pass_num + 1
                    else:
                        fail_num = fail_num + 1
                    wr_str_dict         =       {}
                    #wr_str_dict = 'make run mode=ss tces cfg=s fsdb=ks seed=ks cov=ss %(para['mode'],tc name,paral ['cfg'] ,fsdb _sw.seed,paral ['cov'])
                    wr_str_dict['mode'] = 'make ncrun mode=' + mode_name
                    wr_str_dict['tc']   = 'tc=' + tc_name
                    wr_str_dict['cfg']  = 'cfg=' + tc_cfg
                    wr_str_dict['fsdb'] = 'fsdb=' + fsdb_sw
                    wr_str_dict['seed'] = 'seed=' + seed
                    # wr_str_dict[ ' cov ' ] = 'cov=' + para[ ' cov ' ]
                    wr_str_dict['log'] = log_path
                    wr_str_dict['sim'] = sim_result
                    for key,value in para.items():
                        wr_str_dict[key] = key + '=' + value
                    all_log_list.append(wr_str_dict)
                    rm_elem.append(lp_log)
                    if (test_num == tc_num):
                        break
        # remove have deal log
        for rm_log in rm_elem:
            log_list.remove(rm_log)
        tmp_dict['pass'] = pass_num
        tmp_dict['fail'] = fail_num
        tmp_dict['all']  = test_num
        tmp_dict['cfg']  = tc_cfg
        tmp_dict['test'] = tc_name
        total_pass_num = pass_num + total_pass_num
        total_fail_num = fail_num + total_fail_num
        total_res_list.append(tmp_dict)
    re_log_path = './regress.log'
    with open(re_log_path,'w') as log_f:
        log_f.write('------------------------------------------------------------------------------------------------------------------------------\n')
        log_f.write('total_num'+ ' ' * 50 + 'pass_num' + ' '*50 + 'fail_num\n')
        log_f.write('------------------------------------------------------------------------------------------------------------------------------\n')
        log_f.write('%-59s %-59s %-15s \n' %(total_tc_num, total_pass_num, total_fail_num))
        log_f.write('\n')
        for n in all_log_list:
            dict_len = len(n)
            if dict_len == 8:
                log_f.write('%-25s %-30s %-25s %-8s %-16s %-8s %-60s %-5s\n' %(n['mode'], n['tc'], n['cfg'],n['fsdb'],n['seed'],n['cov'],n['log'],n['sim']))
            elif dict_len > 8:
                log_f.write('%-25s %-30s %-8s %-16s %-8s %-80s %-30s' %(n['mode'], n['tc'], n['fsdb'], n['seed'],n['cov'],n['cfg'],n['cfg_dir']))
                tmp_nlog = n['log']
                tmp_nsim = n['sim']
                del n['mode']
                del n['tc']
                del n['fsdb']
                del n['seed']
                del n['cov']
                del n['log']
                del n['sim']
                del n['cfg']
                del n['cfg_dir']
                for ad_value in n.values():
                    log_f.write('%-25s'%ad_value)
                log_f.write(' %-60s %-5s\n'%(tmp_nlog,tmp_nsim))
    # rm  slurnm log
    for file in glob.glob("/datahdd/slurm_data/result*"):
        os.remove(file)


def rerun_proc(re_log_path):
    re_sub_cnt = 0
    with open(re_log_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if 'FAIL' in line and 'make' in line:
                new_line = line.replace('FAIL', '')
                new_line = new_line.rstrip('\n')
                new_line = new_line.rstrip(' ')
                #new_line = new_line.replace('fsdb=on','fsdb=off')
                tmp_list = new_line.split(' ')
                del tmp_list[-1]
                sub_str = ' '.join(tmp_list)
                sub_str = sub_str.rstrip(' ')
                pattern = r'\d{8}'
                rerun_seed=re.findall(pattern,sub_str)
                #print('seed=%s' %rerun_seed)
                seed = rerun_seed[0]
                #print(type(seed))
                #print(seed)
                rerun_regression = write_bash_script(sub_str,int(seed))
                print('sbatch %s' %rerun_regression)
                os.system('sbatch %s' %rerun_regression)                
                re_sub_cnt = re_sub_cnt + 1
                #os.system("bsub -J 'regression' %s" % sub_str)
                #print('sbatch %s' %sub_str)
    print('%d fail jobs were resubmitted' %re_sub_cnt)

# main
if __name__ == "__main__":
    try:
        opts,args = getopt.getopt(sys.argv[1:], "hr:", ["help", "rpt=", "rerun"])
    except getopt.GetoptError:
        print("Error! ! ! pls input argvs")
        usage()
        sys.exit(2)
    rerun_flag = 0
    rpt_flag   = 0
    list_flag  = 0
    list_path  = ""
    for opt,arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ("-r"):
            list_path = arg
            list_flag = 1
        elif opt in ("--rpt"):
            list_path = arg
            rpt_flag = 1
            #list_path = args.pop()
        elif opt in ("--rerun"):
            rerun_flag = 1

    if(list_flag):
        all_para_list = []
        list_realpath = get_list_path(list_path)
        all_para_list = analy_tclist(list_realpath)
        run_sim(all_para_list)
    elif(rpt_flag):
        all_para_list = []
        list_realpath = get_list_path(list_path)
        all_para_list = analy_tclist(list_realpath)
        deal_log(all_para_list)
    elif (rerun_flag):
        regr_log_path = './regress.log'
        rerun_proc(regr_log_path)









