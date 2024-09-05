  wire          clock;	// @[<stdin>:7603:11]
  wire          reset;	// @[<stdin>:7604:11]
  wire          auto_out_a_ready;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          auto_out_b_valid;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [2:0]   auto_out_b_bits_opcode;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [1:0]   auto_out_b_bits_param;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [2:0]   auto_out_b_bits_size;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [1:0]   auto_out_b_bits_source;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [38:0]  auto_out_b_bits_address;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [63:0]  auto_out_b_bits_mask;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [511:0] auto_out_b_bits_data;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          auto_out_b_bits_corrupt;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          auto_out_c_ready;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          auto_out_d_valid;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [2:0]   auto_out_d_bits_opcode;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [1:0]   auto_out_d_bits_param;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [2:0]   auto_out_d_bits_size;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [1:0]   auto_out_d_bits_source;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          auto_out_d_bits_sink;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          auto_out_d_bits_denied;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire  [511:0] auto_out_d_bits_data;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          auto_out_d_bits_corrupt;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          auto_out_e_ready;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire          io_req_valid;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire  [7:0]   io_req_bits_source;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire  [38:0]  io_req_bits_paddr;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire  [4:0]   io_req_bits_cmd;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire  [2:0]   io_req_bits_size;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire          io_req_bits_signed;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire  [511:0] io_req_bits_wdata;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire  [63:0]  io_req_bits_wmask;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire          io_req_bits_noAlloc;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire  [4:0]   io_req_bits_dest;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire          io_req_bits_isRefill;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire  [1:0]   io_req_bits_refillWay;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire          io_req_bits_refillCoh;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
//  wire          io_s0_kill;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire          io_s1_kill;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire         auto_out_a_valid;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [2:0]   auto_out_a_bits_opcode;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_a_bits_param;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_a_bits_size;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [1:0]   auto_out_a_bits_source;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [38:0]  auto_out_a_bits_address;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [63:0]  auto_out_a_bits_mask;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [511:0] auto_out_a_bits_data;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_a_bits_corrupt;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_b_ready;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_c_valid;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [2:0]   auto_out_c_bits_opcode;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_c_bits_param;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_c_bits_size;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [1:0]   auto_out_c_bits_source;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [38:0]  auto_out_c_bits_address;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [511:0] auto_out_c_bits_data;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_c_bits_corrupt;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_d_ready;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         auto_out_e_valid;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire [1:0]   auto_out_e_bits_sink;	// @[rocket-chip/src/main/scala/diplomacy/LazyModule.scala:366:18]
  wire         io_req_ready;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire         io_resp_valid;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire [7:0]   io_resp_bits_source;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire [4:0]   io_resp_bits_dest;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire [1:0]   io_resp_bits_status;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire         io_resp_bits_hasData;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire [511:0] io_resp_bits_data;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14]
  wire         io_nextCycleWb;	// @[src/main/scala/coincreekDCache/BaseDCache.scala:44:14];

//////////////////////////////////
GPCDCache	U_GPCDCache(
	.clock	(clock),
	.reset	(reset),
	.auto_out_a_ready     	  (tilelink_slave_if[0].a_ready),
	.auto_out_b_valid	        (tilelink_slave_if[0].b_valid),
	.auto_out_b_bits_opcode	  (tilelink_slave_if[0].b_opcode),
	.auto_out_b_bits_param	  (tilelink_slave_if[0].b_param),
	.auto_out_b_bits_size  	  (tilelink_slave_if[0].b_size),
	.auto_out_b_bits_source	  (tilelink_slave_if[0].b_source),
	.auto_out_b_bits_address  (tilelink_slave_if[0].b_address),
	.auto_out_b_bits_mask	    (tilelink_slave_if[0].b_mask),
	.auto_out_b_bits_data	    (tilelink_slave_if[0].b_data),
	.auto_out_b_bits_corrupt	(tilelink_slave_if[0].b_corrupt),
	.auto_out_c_ready	        (tilelink_slave_if[0].c_ready),
	.auto_out_d_valid	        (tilelink_slave_if[0].d_valid),
	.auto_out_d_bits_opcode	  (tilelink_slave_if[0].d_opcode),
	.auto_out_d_bits_param	  (tilelink_slave_if[0].d_param),
	.auto_out_d_bits_size   	(tilelink_slave_if[0].d_size),
	.auto_out_d_bits_source	  (tilelink_slave_if[0].d_source),
	.auto_out_d_bits_sink	    (tilelink_slave_if[0].d_sink),
	.auto_out_d_bits_denied	  (tilelink_slave_if[0].d_denied),
	.auto_out_d_bits_data	    (tilelink_slave_if[0].d_data),
	.auto_out_d_bits_corrupt	(tilelink_slave_if[0].d_corrupt),
	.auto_out_e_ready	        (tilelink_slave_if[0].e_ready),
	.io_req_valid	            (m_lsu_if.io_req_valid),
	.io_req_bits_source	      (m_lsu_if.io_req_bits_source),
	.io_req_bits_paddr	      (m_lsu_if.io_req_bits_paddr),
	.io_req_bits_cmd	        (m_lsu_if.io_req_bits_cmd),
	.io_req_bits_size	        (m_lsu_if.io_req_bits_size),
	.io_req_bits_signed	      (m_lsu_if.io_req_bits_signed),
	.io_req_bits_wdata      	(m_lsu_if.io_req_bits_wdata),
	.io_req_bits_wmask	      (m_lsu_if.io_req_bits_wmask),
	.io_req_bits_noAlloc	    (m_lsu_if.io_req_bits_noAlloc),
	.io_req_bits_dest	        (m_lsu_if.io_req_bits_dest),
	.io_req_bits_isRefill   	(m_lsu_if.io_req_bits_isRefill),
	.io_req_bits_refillWay  	(m_lsu_if.io_req_bits_refillWay),
	.io_req_bits_refillCoh	  (m_lsu_if.io_req_bits_refillCoh),
//	.io_s0_kill	              (m_lsu_if.io_s0_kill),
	.io_s1_kill	              (m_lsu_if.io_s1_kill),
	.auto_out_a_valid        	(tilelink_slave_if[0].a_valid),
	.auto_out_a_bits_opcode  	(tilelink_slave_if[0].a_opcode),
	.auto_out_a_bits_param	  (tilelink_slave_if[0].a_param),
	.auto_out_a_bits_size	    (tilelink_slave_if[0].a_size),
	.auto_out_a_bits_source	  (tilelink_slave_if[0].a_source),
	.auto_out_a_bits_address	(tilelink_slave_if[0].a_address),
	.auto_out_a_bits_mask	    (tilelink_slave_if[0].a_mask),
	.auto_out_a_bits_data	    (tilelink_slave_if[0].a_data),
	.auto_out_a_bits_corrupt	(tilelink_slave_if[0].a_corrupt),
	.auto_out_b_ready       	(tilelink_slave_if[0].b_ready),
	.auto_out_c_valid	        (tilelink_slave_if[0].c_valid),
	.auto_out_c_bits_opcode	  (tilelink_slave_if[0].c_opcode),
	.auto_out_c_bits_param	  (tilelink_slave_if[0].c_param),
	.auto_out_c_bits_size	    (tilelink_slave_if[0].c_size),
	.auto_out_c_bits_source  	(tilelink_slave_if[0].c_source),
	.auto_out_c_bits_address	(tilelink_slave_if[0].c_address),
	.auto_out_c_bits_data	    (tilelink_slave_if[0].c_data),
	.auto_out_c_bits_corrupt	(tilelink_slave_if[0].c_corrupt),
	.auto_out_d_ready	        (tilelink_slave_if[0].d_ready),
	.auto_out_e_valid	        (tilelink_slave_if[0].e_valid),
	.auto_out_e_bits_sink	    (tilelink_slave_if[0].e_sink),
	.io_req_ready	            (m_lsu_if.io_req_ready),
	.io_resp_valid	          (m_lsu_if.io_resp_valid),
	.io_resp_bits_source	    (m_lsu_if.io_resp_bits_source),
	.io_resp_bits_dest	      (m_lsu_if.io_resp_bits_dest),
	.io_resp_bits_status    	(m_lsu_if.io_resp_bits_status),
	.io_resp_bits_hasData	    (m_lsu_if.io_resp_bits_hasData),
	.io_resp_bits_data	      (m_lsu_if.io_resp_bits_data),
	.io_nextCycleWb           (m_lsu_if.io_nextCycleWb)
);
