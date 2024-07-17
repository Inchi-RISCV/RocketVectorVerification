#_*_    coding: utf-8 _*_
####### readme########
#cmdline python dut_instance.py top_path/top.v
#dut_instance_py.sv will generated

import sys

#read top.v and instance it
def Dut_Instance(filepath):
    lines =[]
    filename = open(filepath,'r')
    flag = False
    lines = filename.readlines()
    wr_file = open("dut_instance_py.sv",'w+')
    signal_list =[]
    signal = ""
    module_name = ""
    module = ""
    for line in lines:
        if("module" in line and flag==False):
            #module name = line.strip().split("")[1]
            line=line.replace("\r","")
            line=line.replace("\n","")
            module_name = line.replace(' ','')
            module=module_name.replace('module','')
            module=module.replace('(','')
            flag =True
            continue
        elif(flag):
            line=line.replace("wire","")
            line=line.replace("reg","")
            line=line.replace("\r","")
            tmpl=line.lstrip()
            #line = line.replace("\n","")
            if(tmpl.startswith("//")):
                continue
            if("," not in line):
                line=line.replace("\n","")+",\n"
            #print line
            if("input" in line):
                wr_file.writelines((line.replace("input","wire")).replace(",",";"))
            elif("output" in line):
                wr_file.writelines((line.replace("output","wire")).replace(",",";"))
            elif("inout" in line):
                wr_file.writelines((line.replace("inout","wire")).replace(",",";"))
            #signal = line.replace(",",") .strip().split("")[-1]
            #line = line.replace(" r"
            line = line.replace("\n","")
            if("input" in line or "output" in line or "inout" in line):
                line_st = line.split(",")
                line_st.pop()
                line = " ".join(line_st)
                line = line.rstrip()
                # line = line.replace(" n",")
                line_lst = line.split(' ')
                signal = line_lst[-1]
                signal_list.append(signal)
        if (");" in line):
            break

    # instance module name
    wr_file.write("\n//////////////////////////////////\n")
    wr_file.write(module + " \tu_"+ module + "(\n")
    #print signal list
    for i in range(len(signal_list)-1):
        name = signal_list[i]
        wr_file.write('\t.{name:<{len}}\t({name:<{len}}),\n'.format(name=name,len=len(name)))
        if i == len(signal_list)-2:
            last_signal = signal_list[len(signal_list)-1]
            wr_file.write('\t.{name:<{len}}\t({name:<{len}})\n'.format(name=last_signal,len=len(last_signal)))
            wr_file.write(");\n")
    wr_file.close()
    filename.close()

if __name__ == '__main__':
    Dut_Instance(sys.argv[1])
