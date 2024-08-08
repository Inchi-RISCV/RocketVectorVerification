//============================================================================
// Copyright(c) 2022 , Inchi Technology Inc, All right reserved
// Company           : Inchi Technology .Inc
//============================================================================
// Project           :dcache
// File Name         :dcache_sanity_sequence.sv
// Author            :huangxiaogang
// Email             :huangxiaogang@inchitech.com
// Called by         :
// Reversion History :2024-07-01 16:31:41
// Reversion:        1.0
//============================================================================
// Description       :
//============================================================================

`ifndef _DCACHE_SANITY_SEQUENCE_SV_
`define _DCACHE_SANITY_SEQUENCE_SV_

class dcache_sanity_sequence extends dcache_base_sequence;
  `uvm_object_utils(dcache_sanity_sequence)
	`uvm_declare_p_sequencer(dcache_vsqr)


  function new(string name = "dcache_sanity_sequence");
    super.new(name);
  endfunction


  virtual task body();
	  
	  bit [31:0] addr,addr_1;
		bit [7:0] data_byte;
    bit [511:0] data;

    `uvm_info(get_type_name(), "dcache sanity sequence starting", UVM_NONE)
		super.body(); 
    addr = 'h8000_0000;
	 	addr_1 = 'h8000_0800;

	  for(int i=0;i<10;i++)begin
			backdoor_put_data(addr+'h40*i,6,{16{'h76543210}}+i);
	  end

	  for(int i=0;i<10;i++)begin
			backdoor_put_data(addr_1+'h40*i,6,{16{'h76543210}}+i);
	  end


		//load hit: BtoB

	  for(int i=0;i<10;i++)begin
			dcache_load(lsu_trans::SCALAR_INT,addr+'h40*i);
	  end

		//store miss: BtoT

		for(int i=0;i<10;i++)begin 
      for(int i=0;i<256;i++)begin
				data_byte = $urandom_range(0,8'hff);
        data[i*8+:8] = data_byte;
			end

			dcache_store(lsu_trans::SCALAR_INT,addr_1+'h40*i,data);
		end

				

  endtask


endclass : dcache_sanity_sequence


//-------------------------------------------------------------------------

`endif
