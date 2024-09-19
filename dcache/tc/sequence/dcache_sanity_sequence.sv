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
    bit [6:0] set_idx;
    bit [18:0] tag;
    bit [2:0] size;
		bit [5:0] addr_align;
		bit [63:0] mask;
	  bit sign;

    `uvm_info(get_type_name(), "dcache sanity sequence starting", UVM_NONE)
		super.body(); 

    
    
    // load miss
		tag = 'h4_0000;
	  for(int i=0;i<20;i++)begin
      set_idx = i;
		  addr = {tag,set_idx,6'h0}; 
			backdoor_put_data(addr,6,{16{'hf0f0f0f0}}+i);
	  end

   	for(int i=0;i<20;i++)begin
			set_idx = i;
			size = $urandom_range(6);
			addr_align = $urandom_range(64);
			sign = $urandom_range(1);



      case (size)
        3'h1 : addr_align[0:0] = 0;
        3'h2 : addr_align[1:0] = 0;
        3'h3 : addr_align[2:0] = 0;
        3'h4 : addr_align[3:0] = 0;
        3'h5 : addr_align[4:0] = 0;
        3'h6 : addr_align[5:0] = 0;
      endcase	
			addr = {tag,set_idx,addr_align}; 
			dcache_load(addr,size,sign);
	  end
    #400ns;

		

		//same addr load
		tag = 'h4_0000;
		set_idx = 21;

 		addr = {tag,set_idx,6'h0}; 
	  backdoor_put_data(addr,6,{16{'ha5a5a5a5a}});

   	for(int i=0;i<20;i++)begin
		  addr = {tag,set_idx,6'h0}; 
			dcache_load(addr);
	  end
    #400ns;

    

		//same index load
    tag = 'h4_0000;
		set_idx = 30;

		for(int i=0;i<20;i++)begin
			tag = 'h4_0000+i; 		
			addr = {tag,set_idx,6'h0};
	    backdoor_put_data(addr,6,{16{'ha5a54321}});
	  end
			
	  for(int i=0;i<20;i++)begin
	  	tag = 'h4_0000+i; 		
	  	addr = {tag,set_idx,6'h0};
	  	dcache_load(addr);
	  end
   #400ns;




	 //way evict
    tag = 'h4_0000;

		for(int i=0;i<10;i++)begin
			set_idx = 40;
			tag = 'h4_0000+i;
			addr = {tag,set_idx,6'h0};
	    backdoor_put_data(addr,6,{16{'ha5a54321}});
	  end

	 for(int i=0;i<4;i++)begin
		 set_idx = 40;
		 tag = 'h4_0000+i;		 
	 	 addr = {tag,set_idx,6'h0};
	 	 dcache_load(addr);
	 end

	 #50ns;

	 for(int i=0;i<2;i++)begin
		 set_idx = 40;
		 tag = 'h4_0000+i;			 
	 	 addr = {tag,set_idx,6'h0};
	 	 dcache_load(addr);
	 end

	 for(int i=0;i<1;i++)begin
		 set_idx = 40;
		 tag = 'h4_0000+i;			 
	 	 addr = {tag,set_idx,6'h0};
	 	 dcache_load(addr);
	 end

	 for(int i=0;i<4;i++)begin
		 set_idx = 40;
		 tag = 'h4_0010+i;	
	 	 addr = {tag,set_idx,6'h0};
	 	 dcache_load(addr);
	 end
	 #400ns;
    
	 


    // store miss + load miss + load hit + store hit + load hit
		tag = 'h4_0000;

	  for(int i=0;i<20;i++)begin
      set_idx = 50+i;
		  addr = {tag,set_idx,6'h0}; 
			backdoor_put_data(addr,6,{16{'hf0f0f0f0}}+i);
	  end

   	for(int i=0;i<20;i++)begin
			set_idx = 50+i;
			size = $urandom_range(6);
			//size=2;
			addr_align = $urandom_range(64);

      case (size)
        3'h1 : addr_align[0:0] = 0;
        3'h2 : addr_align[1:0] = 0;
        3'h3 : addr_align[2:0] = 0;
        3'h4 : addr_align[3:0] = 0;
        3'h5 : addr_align[4:0] = 0;
        3'h6 : addr_align[5:0] = 0;
      endcase	
			addr = {tag,set_idx,addr_align}; 
      for(int i=0;i<256;i++)begin
			  data_byte = $urandom_range(0,8'hff);
        data[i*8+:8] = data_byte;
		  end
			//data = {16{'ha5a5a5a5}}+i;
			dcache_store(addr,data,size);
			dcache_load(addr,size,1);
	  end
    #100ns;
		// load hit
	  for(int i=0;i<20;i++)begin
			set_idx = 50+i;
			//size = $urandom_range(6);
			size=6;
			addr_align = $urandom_range(64);

      case (size)
        3'h1 : addr_align[0:0] = 0;
        3'h2 : addr_align[1:0] = 0;
        3'h3 : addr_align[2:0] = 0;
        3'h4 : addr_align[3:0] = 0;
        3'h5 : addr_align[4:0] = 0;
        3'h6 : addr_align[5:0] = 0;
      endcase	
			addr = {tag,set_idx,addr_align}; 
			dcache_load(addr,size,1);
	  end
    #100ns;

		//store hit & load hit
   	for(int i=0;i<20;i++)begin
			set_idx = 50+i;
			size = $urandom_range(6);
			//size=2;
			addr_align = $urandom_range(64);

      case (size)
        3'h1 : addr_align[0:0] = 0;
        3'h2 : addr_align[1:0] = 0;
        3'h3 : addr_align[2:0] = 0;
        3'h4 : addr_align[3:0] = 0;
        3'h5 : addr_align[4:0] = 0;
        3'h6 : addr_align[5:0] = 0;
      endcase	
			addr = {tag,set_idx,addr_align}; 
      for(int i=0;i<256;i++)begin
			  data_byte = $urandom_range(0,8'hff);
        data[i*8+:8] = data_byte;
		  end
			dcache_store(addr,data,size);
			dcache_load(addr,size,1);
	  end
    #400ns;

    //Partial masked store
		tag = 'h4_0000;

	  for(int i=0;i<20;i++)begin
      set_idx = 70+i;
		  addr = {tag,set_idx,6'h0}; 
			backdoor_put_data(addr,6,{16{'hf0f0f0f0}}+i);
	  end

   	for(int i=0;i<20;i++)begin
			set_idx = 70+i;
			//size = $urandom_range(6);
			size=6;
			addr_align = $urandom_range(64);

      case (size)
        3'h1 : addr_align[0:0] = 0;
        3'h2 : addr_align[1:0] = 0;
        3'h3 : addr_align[2:0] = 0;
        3'h4 : addr_align[3:0] = 0;
        3'h5 : addr_align[4:0] = 0;
        3'h6 : addr_align[5:0] = 0;
      endcase	
			addr = {tag,set_idx,addr_align}; 
      for(int i=0;i<256;i++)begin
			  data_byte = $urandom_range(0,8'hff);
        data[i*8+:8] = data_byte;
		  end

      for(int i=0;i<8;i++)begin
        mask[i*8+:8] = $urandom_range(0,8'hff);
		  end
			
			dcache_partial_mask_store(addr,data,mask);
			dcache_load(addr,size,1);
	  end
     #100ns;
		// load hit
	  for(int i=0;i<20;i++)begin
			set_idx = 70+i;
			//size = $urandom_range(6);
			size=6;
			addr_align = $urandom_range(64);

      case (size)
        3'h1 : addr_align[0:0] = 0;
        3'h2 : addr_align[1:0] = 0;
        3'h3 : addr_align[2:0] = 0;
        3'h4 : addr_align[3:0] = 0;
        3'h5 : addr_align[4:0] = 0;
        3'h6 : addr_align[5:0] = 0;
      endcase	
			addr = {tag,set_idx,addr_align}; 
			dcache_load(addr,size,1);
	  end
		#400ns;

		//same index store
    tag = 'h4_0000;
		set_idx = 90;

		for(int i=0;i<20;i++)begin
			tag = 'h4_0000+i; 		
			addr = {tag,set_idx,6'h0};
	    backdoor_put_data(addr,6,{16{'ha5a54321}});
	  end
			
	  for(int i=0;i<20;i++)begin
	  	tag = 'h4_0000+i; 		
			size=6;
			addr_align = $urandom_range(64);

      case (size)
        3'h1 : addr_align[0:0] = 0;
        3'h2 : addr_align[1:0] = 0;
        3'h3 : addr_align[2:0] = 0;
        3'h4 : addr_align[3:0] = 0;
        3'h5 : addr_align[4:0] = 0;
        3'h6 : addr_align[5:0] = 0;
      endcase	
			addr = {tag,set_idx,addr_align}; 
      for(int i=0;i<256;i++)begin
			  data_byte = $urandom_range(0,8'hff);
        data[i*8+:8] = data_byte;
		  end
			dcache_store(addr,data,size);
	  end
   #400ns;



	endtask



		
endclass : dcache_sanity_sequence


//-------------------------------------------------------------------------

`endif
