
`ifndef NEW_SVT_TILELINK_SYSTEM_CONFIGURATION_SV
`define NEW_SVT_TILELINK_SYSTEM_CONFIGURATION_SV

`include "svt_tilelink.uvm.pkg"
import svt_tilelink_uvm_pkg::*;

class new_tilelink_system_configuration extends cust_svt_tilelink_system_configuration;

  `svt_xvm_object_utils (new_tilelink_system_configuration)

  function new (string name="new_tilelink_system_configuration");
    super.new(name);
	endfunction 

	extern virtual function void set_tilelink_cfg();

endclass : new_tilelink_system_configuration

function void new_tilelink_system_configuration::set_tilelink_cfg();
    int selector;
    
		num_slave = 1;
    num_master = 1;
    create_sub_cfgs(num_master, num_slave);

    foreach(this.master_cfg[i]) begin
		  this.master_cfg[i].is_active = 0;
		  this.master_cfg[i].mst_delay_en = 0;
      this.master_cfg[i].num_outstanding_txn = $urandom_range(10,100);
		  this.master_cfg[i].addr_width = 39;
      this.master_cfg[i].data_width = 512;			
      this.master_cfg[i].min_d_rdy_deassert_delay = $urandom_range(0,3);
      this.master_cfg[i].max_d_rdy_deassert_delay = $urandom_range(this.master_cfg[i].min_d_rdy_deassert_delay,7);
    end

    foreach(this.slave_cfg[i]) begin
			this.slave_cfg[i].is_active = 1;
			this.slave_cfg[i].slv_delay_en = 1;
			this.slave_cfg[i].slv_vld_rdy_delay_en = 0;
			this.slave_cfg[i].slv_cross_chnl_delay_en = 1;
      this.slave_cfg[i].addr_width = 39;
      this.slave_cfg[i].data_width = 512;   

      this.slave_cfg[i].min_a_vld_a_rdy_assert_delay = 60;
      this.slave_cfg[i].max_a_vld_a_rdy_assert_delay = 200;
			this.slave_cfg[i].min_a_rdy_a_rdy_assert_delay = 0;
      this.slave_cfg[i].max_a_rdy_a_rdy_assert_delay = 0;
			this.slave_cfg[i].min_a_rdy_deassert_delay = 0;
      this.slave_cfg[i].max_a_rdy_deassert_delay = 0;
      this.slave_cfg[i].min_a_vld_d_vld_cross_chnl_delay = 1000; 	//TODO: to be confirmed
      this.slave_cfg[i].max_a_vld_d_vld_cross_chnl_delay = 2000; 	//TODO: to be confirmed
			this.slave_cfg[i].min_d_vld_d_vld_assert_delay = 0;
      this.slave_cfg[i].max_d_vld_d_vld_assert_delay = 0;
      
			this.slave_cfg[i].enable_tracing = 1;
      this.slave_cfg[i].enable_chk_fail_cov= 1;
      this.slave_cfg[i].enable_chk_pass_cov= 1;
      this.slave_cfg[i].enable_cov= 1;
		  this.slave_cfg[i].enable_xml_gen= 1;
		  this.slave_cfg[i].enable_pa_writer= 1;
	    this.slave_cfg[i].same_cycle_resp_en= 0;
    end
endfunction

`endif // NEW_SVT_TILELINK_SYSTEM_CONFIGURATION_SV

