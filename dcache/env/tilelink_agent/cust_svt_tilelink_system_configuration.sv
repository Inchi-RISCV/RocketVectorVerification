

`ifndef GUARD_CUST_SVT_TILELINK_SYSTEM_CONFIGURATION_SV
`define GUARD_CUST_SVT_TILELINK_SYSTEM_CONFIGURATION_SV

//-----------------------------------------------------------------------------
/**
 * Abstract:
 * Class cust_svt_tilelink_system_configuration is basically used to encapsulate all
 * the configuration information.  It extends system configuration and set the
 * appropriate fields like number of master/slaves, create master/slave
 * configurations etc..., which are required by System Env.
 */
`include "svt_tilelink.uvm.pkg"
import svt_tilelink_uvm_pkg::*;

class cust_svt_tilelink_system_configuration extends svt_tilelink_system_configuration;

  // Utility macro
  `svt_xvm_object_utils (cust_svt_tilelink_system_configuration)

  //---------------------------------------------------------------------------
  /** Class construct. */
  function new (string name="cust_svt_tilelink_system_configuration");
    super.new(name);
	endfunction 

	extern virtual function void set_tilelink_cfg();

endclass : cust_svt_tilelink_system_configuration

function void cust_svt_tilelink_system_configuration::set_tilelink_cfg();
		bit slv_a_delay_en, slv_a_d_delay_en, slv_b_delay_en, slv_c_delay_en, slv_d_delay_en;
		int selector;
    
		num_slave = 1;
    num_master = 1;
    create_sub_cfgs(num_master, num_slave);

		slv_a_delay_en = vmm_opts::get_int("slv_a_delay_en", 0, "slv_a_delay_en");
		slv_a_d_delay_en = vmm_opts::get_int("slv_a_d_delay_en", 0, "slv_a_d_delay_en");
		slv_b_delay_en = vmm_opts::get_int("slv_b_delay_en", 0, "slv_b_delay_en");
		slv_c_delay_en = vmm_opts::get_int("slv_c_delay_en", 0, "slv_c_delay_en");
		slv_d_delay_en = vmm_opts::get_int("slv_d_delay_en", 0, "slv_d_delay_en");

    foreach(this.master_cfg[i]) begin
		  this.master_cfg[i].is_active = 0;
		  this.master_cfg[i].mst_delay_en = 0;
      this.master_cfg[i].num_outstanding_txn = $urandom_range(10,100);
		  this.master_cfg[i].addr_width = 39;
      this.master_cfg[i].data_width = 512;			
    end

    foreach(this.slave_cfg[i]) begin
			this.slave_cfg[i].is_active = 1;
			this.slave_cfg[i].slv_delay_en = 1;
			this.slave_cfg[i].slv_vld_rdy_delay_en = 1;
			this.slave_cfg[i].slv_cross_chnl_delay_en = 1;
      this.slave_cfg[i].addr_width = 39;
      this.slave_cfg[i].data_width = 512;   

			if(slv_a_delay_en) begin
      	this.slave_cfg[i].min_a_vld_a_rdy_assert_delay = 1000;
      	this.slave_cfg[i].max_a_vld_a_rdy_assert_delay = 2000;
			end 
			else begin
				this.slave_cfg[i].min_a_vld_a_rdy_assert_delay = 0;
      	this.slave_cfg[i].max_a_vld_a_rdy_assert_delay = 0;
			end
			if(slv_a_d_delay_en) begin
				this.slave_cfg[i].min_a_vld_d_vld_cross_chnl_delay = 1000;
      	this.slave_cfg[i].max_a_vld_d_vld_cross_chnl_delay = 2000;
			end
			else begin
				this.slave_cfg[i].min_a_vld_d_vld_cross_chnl_delay = 0;
      	this.slave_cfg[i].max_a_vld_d_vld_cross_chnl_delay = 0;
			end
			if(slv_b_delay_en) begin
      	this.slave_cfg[i].min_b_vld_b_vld_assert_delay = 1000;
      	this.slave_cfg[i].max_b_vld_b_vld_assert_delay = 2000;
			end
			else begin
				this.slave_cfg[i].min_b_vld_b_vld_assert_delay = 0;
      	this.slave_cfg[i].max_b_vld_b_vld_assert_delay = 0;
			end
			if(slv_c_delay_en) begin
      	this.slave_cfg[i].min_c_vld_c_rdy_assert_delay = 1000;
      	this.slave_cfg[i].max_c_vld_c_rdy_assert_delay = 2000;
			end
			else begin
				this.slave_cfg[i].min_c_vld_c_rdy_assert_delay = 0;
      	this.slave_cfg[i].max_c_vld_c_rdy_assert_delay = 0;
			end
			if(slv_d_delay_en) begin
				this.slave_cfg[i].min_d_vld_d_vld_assert_delay = 1000;
      	this.slave_cfg[i].max_d_vld_d_vld_assert_delay = 2000;
			end
			else begin
				this.slave_cfg[i].min_d_vld_d_vld_assert_delay = 0;
      	this.slave_cfg[i].max_d_vld_d_vld_assert_delay = 0;
			end
			this.slave_cfg[i].min_e_vld_e_rdy_assert_delay = 0;
      this.slave_cfg[i].max_e_vld_e_rdy_assert_delay = 0; 	//TODO: vip not support, monitor delay
			
			this.slave_cfg[i].enable_tracing = 1;
      this.slave_cfg[i].enable_chk_fail_cov= 1;
      this.slave_cfg[i].enable_chk_pass_cov= 1;
      this.slave_cfg[i].enable_cov= 1;
		  this.slave_cfg[i].enable_xml_gen= 1;
		  this.slave_cfg[i].enable_pa_writer= 1;
			//this.slave_cfg[i].pa_format_type= 2;
	    this.slave_cfg[i].same_cycle_resp_en= 0;
	    this.slave_cfg[i].mem_address_range = 'h7f_ffff_ffff;
			//this.slave_cfg[i].enable_reporting=1;
    end
endfunction

`endif // GUARD_CUST_SVT_TILELINK_SYSTEM_CONFIGURATION_SV

