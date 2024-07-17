//=======================================================================
// COPYRIGHT (C) 2021 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
//-----------------------------------------------------------------------

`ifndef GUARD_SVT_TRAFFIC_PROFILE_TRANSACTION_SV
`define GUARD_SVT_TRAFFIC_PROFILE_TRANSACTION_SV
`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_defines)

/**
  * Generic class that models a traffic profile. Only parameters which are
  * generic across all protocols are encapsulated here. Protocol specific
  * parameters must be specified in an extended class. 
  */
class svt_traffic_profile_transaction extends `SVT_TRANSACTION_TYPE;

  typedef enum bit[1:0] {
    FIXED = `SVT_TRAFFIC_PROFILE_FIXED,
    RANDOM = `SVT_TRAFFIC_PROFILE_RANDOM,
    CYCLE = `SVT_TRAFFIC_PROFILE_CYCLE,
    UNIQUE = `SVT_TRAFFIC_PROFILE_UNIQUE
  } attr_val_type_enum; 

  typedef enum bit[1:0] {
    SEQUENTIAL = `SVT_TRAFFIC_PROFILE_SEQUENTIAL,
    TWODIM = `SVT_TRAFFIC_PROFILE_TWODIM,
    RANDOM_ADDR = `SVT_TRAFFIC_PROFILE_RANDOM_ADDR 
  } addr_val_type_enum;

  typedef enum bit[1:0] {
    END_OF_PROFILE = `SVT_TRAFFIC_PROFILE_END_OF_PROFILE,
    FRAME_TIME = `SVT_TRAFFIC_PROFILE_END_OF_FRAME_TIME,    
    FRAME_SIZE = `SVT_TRAFFIC_PROFILE_END_OF_FRAME_SIZE   
  } output_event_type_enum;

  typedef enum int {
    XACT_SIZE_8BIT = 8,
    XACT_SIZE_16BIT = 16,
    XACT_SIZE_32BIT = 32,
    XACT_SIZE_64BIT = 64,
    XACT_SIZE_128BIT = 128,
    XACT_SIZE_256BIT = 256,
    XACT_SIZE_512BIT = 512,
    XACT_SIZE_1024BIT = 1024
  } xact_size_enum;

  /** Configuration for rate control in WRITE FIFO. */ 
  svt_fifo_rate_control_configuration write_fifo_cfg;

  /** Configuration for rate control in READ FIFO. */
  svt_fifo_rate_control_configuration read_fifo_cfg;

  /** Utility class for performing FIFO based rate control for WRITE transactions */
  svt_fifo_rate_control write_fifo_rate_control;

  /** Utility class for performing FIFO based rate control for READ transactions */
  svt_fifo_rate_control read_fifo_rate_control;

  /**
    * The sequence number of the group in the traffic profile corresponding to this configuration
    */
  int group_seq_number;

  /**
    * The name of the group in the traffic profile corresponding to this configuration
    */
  string group_name;

  /**
   * Full Name of the sequencer instance on which this profile is to run
   * This name must match the full hierarchical name of the sequencer
   */
  string seqr_full_name;

  /**
   * Name of the sequencer on which this profile is to run
   * This can be a proxy name and need not match the actual name of the sequencer
   */
  string seqr_name;

  /**
   * Name of the profile 
   */
  string profile_name;

 /** Number of Transactions in a sequence. */
  rand int unsigned total_num_bytes = `SVT_TRAFFIC_MAX_TOTAL_NUM_BYTES;

  /** The total number of bytes transferred in each transaction 
   * Applicable only for non-cache line size transactions. For
   * cache-line size transactions, it is defined by the protocol 
   * and corresponding VIP constraints 
   */
  rand xact_size_enum xact_size = XACT_SIZE_64BIT;

  /** Indicates the type of address generation 
   * If set to sequential, a sequential range of address value starting from
   * base_addr will be used.  
   * If set to twomin, a two dimensional address
   * pattern is used. Check description of properties below for details.  
   * If set to random, random values between base_addr and
   * base_addr+addr_xrange-1 is used. Values will be chosen such that all
   * the valid paths to slaves from this master are covered.
   */
  rand addr_val_type_enum addr_gen_type = SEQUENTIAL;
  
  /** The base address to be used for address generation */
  rand bit[63:0] base_addr = 0;

  /** Address range to be used for various address patterns. If addr is
   * sequential, sequential addressing is used from base_addr until it
   * reaches base_addr + addr_xrange - 1, upon which the next transaction
   * will use base_addr as the address. If addr is twodim, after a
   * transaction uses address specified by (base_addr + addr_xrange - 1),
   * the next transaction uses address specified by (base_addr +
   * addr_twodim_stride). This pattern continues until addr_twodim_yrange is
   * reached. If addr is random, base_addr + addr_xrange  1 indicates the
   * maximum address that can be generated 
   */
  rand bit[63:0] addr_xrange = (1 << 64) - 1;

  /** Valid if addr is twodim. This determines the offset of each new row */
  rand bit[63:0] addr_twodim_stride;

  /** Valid if addr is twodim. After a transaction uses address specified by
   * (base_addr + addr_twodim_yrange  - addr_twodim_stride +
   * addr_twodim_xrange  1), the next transaction uses address specified by
   * base_addr. 
   */
  rand bit[63:0] addr_twodim_yrange;


  /** Indicates whether fixed, cycle or random data is to be used for
   * transactions. If set to fixed, a fixed data value as indicated in
   * data_min is used.  If set to cycle, a range of data values is cycled
   * through from data_min to data_max. If set to random, a random
   * data value is used between data_min and data_max.
   */
  rand attr_val_type_enum data_gen_type = RANDOM;

  /**
   * The lower bound of data value to be used.
   * Valid if data is set to cycle
   */
  rand bit[1023:0] data_min;

  /**
   * The upper bound of data value to be used.
   * Valid if data is set to cycle
   */
  rand bit[1023:0] data_max;

  /** 
   * Name of input events based on which this traffic profile will 
   * will start. The traffic profile will start if any of the input events are triggered.
   * The names given in this variable should be associated with the output event of some
   * other profile, so that this traffic profile
   * will start based on when the output event is triggered. 
   */
  string input_events[];

  /** 
   * Name of output events triggered from this traffic profile at pre-defined
   * points which are specified in output_event_type. The names given in this
   * variable should be associated with the input event of some other profile,
   * which will will start based on when the output event is triggered. 
   */
  string output_events[];

  /**
   * Indicates the pre-defined points at which the output events given in output_event
   * must be triggered
   * If set to END_OF_PROFILE, the output event is triggered when the last transaction from the profile is complete
   * If set to END_OF_FRAME_TIME, the output event is triggered every frame_time number of cycles
   * If set to END_OF_FRAME_SIZE, the output event is triggered after every frame_size number of bytes are transmitted
   */
  output_event_type_enum output_event_type[];

`ifndef SVT_VMM_TECHNOLOGY
  /** Event pool for input events */
  svt_event_pool input_event_pool;

  /** Event pool for output events */
  svt_event_pool output_event_pool;
`endif

`ifndef SVT_ENABLE_VCAP_MULTI_OUPUT_EVENT
  /**
   * Applicable if any of the output_event_type is FRAME_TIME.
   * Indicates the number of cycles after which the corresponding output_event
   * must be triggered. The event is triggered after every frame_time number
   * of cycles
   */
  rand int frame_time = `SVT_TRAFFIC_MAX_FRAME_TIME;

  /**
   * Applicable if any of the output_event_type is FRAME_SIZE.
   * Indicates the number of bytes after which the corresponding output_event
   * must be triggered. The event is triggered after every frame_size number
   * of bytes are transmitted. 
   */
  rand int frame_size = `SVT_TRAFFIC_MAX_FRAME_SIZE;
`else
  /**
   * Indicates the value of FRAME_SIZE or FRAME_TIME from the output event of traffic profile.  
   * Applicable if any of the output_event_type is FRAME_SIZE or FRAME_TIME.
   * FRAME_SIZE indicates the number of bytes after which the corresponding output_event
   * must be triggered. The event is triggered after every frame_size number of bytes are transmitted.
   * FRAME_TIME indicates the number of cycles after which the corresponding output_event
   * must be triggered. The event is triggered after every frame_time number of cycles
   */
  int output_event_value[];

`endif

  constraint valid_ranges {
`ifdef SVT_ENABLE_VCAP_MULTI_OUPUT_EVENT
    output_event_value.size() == output_event_type.size();
`else
    frame_time > 0;
    frame_time < `SVT_TRAFFIC_MAX_FRAME_TIME;
    frame_size >= xact_size; // Transaction size for one transaction
    frame_size <= `SVT_TRAFFIC_MAX_FRAME_SIZE;
`endif
    total_num_bytes > 0;
    total_num_bytes <= `SVT_TRAFFIC_MAX_TOTAL_NUM_BYTES;
  }

  constraint reasonable_data_val {
    data_max >= data_min;
  }


  
`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_traffic_profile_transaction)
`endif
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new traffic profile instance, passing the appropriate argument
   * values to the <b>vmm_data</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   *
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(vmm_log log = null, string suite_name="");
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new traffic profile instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name of the configuration
   *
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(string name = "svt_traffic_profile_transaction", string suite_name="");
`endif // !`ifdef SVT_VMM_TECHNOLOGY

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_traffic_profile_transaction)
  `svt_field_object(write_fifo_cfg, `SVT_ALL_ON|`SVT_REFERENCE|`SVT_UVM_NOPACK|`SVT_NOCOMPARE, `SVT_HOW_REFCOPY)  
  `svt_field_object(read_fifo_cfg, `SVT_ALL_ON|`SVT_REFERENCE|`SVT_UVM_NOPACK|`SVT_NOCOMPARE, `SVT_HOW_REFCOPY)  
  `svt_field_object(write_fifo_rate_control, `SVT_ALL_ON|`SVT_REFERENCE|`SVT_UVM_NOPACK|`SVT_NOCOMPARE, `SVT_HOW_REFCOPY)  
  `svt_field_object(read_fifo_rate_control, `SVT_ALL_ON|`SVT_REFERENCE|`SVT_UVM_NOPACK|`SVT_NOCOMPARE, `SVT_HOW_REFCOPY)  
  `svt_data_member_end(svt_traffic_profile_transaction)


  /**
   * Method to turn reasonable constraints on/off as a block.
   */
  extern virtual function int reasonable_constraint_mode (bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object used for logging.
   */
  extern function string get_mcd_class_name ();
  //----------------------------------------------------------------------------

`ifndef SVT_VMM_TECHNOLOGY
  /**
   * Extend the copy method to take care of the transaction fields and cleanup the exception xact pointers.
   *
   * @param rhs Source object to be copied.
   */
  extern virtual function void do_copy(`SVT_XVM(object) rhs);

  //----------------------------------------------------------------------------
  /**
   * Compares the object with rhs..
   *
   * @param rhs Object to be compared against.
   * @param comparer TBD
   */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);
`else
  /**
   * Extend the copy method to copy the transaction class fields.
   * 
   * @param to Destination class for the copy operation
   */
  extern virtual function `SVT_DATA_BASE_TYPE do_copy(`SVT_DATA_BASE_TYPE to = null);

  // ---------------------------------------------------------------------------
  /**
   * Compares the object with to, based on the requested compare kind. Differences are
   * placed in diff.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted. Only supported
   * kind value is svt_data::COMPLETE, which results in comparisons of the non-static
   * data members. All other kind values result in a return value of 1.
   */
  extern virtual function bit do_compare (vmm_data to, output string diff, input int kind = -1);

  //----------------------------------------------------------------------------
  /**                         
   * Returns the size (in bytes) required by the byte_pack operation.
   *
   * @param kind This int indicates the type of byte_size being requested. Only supported
   * kind value is svt_data::COMPLETE, which results in a size calculation based on the
   * non-static fields. All other kind values result in a return value of 0.
   */
  extern virtual function int unsigned byte_size (int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset, based on the
   * requested byte_pack kind.
   *
   * @param bytes Buffer that will contain the packed bytes at the end of the operation.
   * @param offset Offset into bytes where the packing is to begin.
   * @param kind This int indicates the type of byte_pack being requested. Only supported
   * kind value is svt_data::COMPLETE, which results in all of the
   * non-static fields being packed and the return of an integer indicating the number of
   * packed bytes. All other kind values result in no change to the buffer contents, and a
   * return value of 0.
   */
  extern virtual function int unsigned do_byte_pack (ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Unpacks the object from the bytes buffer, beginning at offset, based on
   * the requested byte_unpack kind.
   *
   * @param bytes Buffer containing the bytes to be unpacked.
   * @param offset Offset into bytes where the unpacking is to begin.
   * @param len Number of bytes to be unpacked.
   * @param kind This int indicates the type of byte_unpack being requested. Only supported
   * kind value is svt_data::COMPLETE, which results in all of the
   * non-static fields being unpacked and the return of an integer indicating the number of
   * unpacked bytes. All other kind values result in no change to the exception contents,
   * and a return value of 0.
   */
  extern virtual function int unsigned do_byte_unpack (const ref logic [7:0]
  bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);

`endif
  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>read</i> access to public data members of this class.
   */
  extern virtual function bit get_prop_val (string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);
  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>write</i> access to public data members of this class.
   */
  extern virtual function bit set_prop_val (string prop_name, bit [1023:0] prop_val, int array_ix);
  // ---------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the primitive data fields in the object. The svt_pattern_data::name
   * is set to the corresponding field name, the svt_pattern_data::value is set
   * to 0.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern do_allocate_pattern ();

  // ---------------------------------------------------------------------------
   /**
   * allocate_xml_pattern() method collects all the fields which are primitive data fields of the transaction and
   * filters the fields to get only the fields to be displayed in the PA. 
   *
   * @return An svt_pattern instance containing entries for required fields to be dispalyed in PA
   */
   extern virtual function svt_pattern allocate_xml_pattern();
 // ----------------------------------------------------------------------------
  /**
   * Simple utility used to convert string property value representation into its
   * equivalent 'bit [1023:0]' property value representation. Extended to support
   * encoding of enum values.
   *
   * @param prop_name The name of the property being encoded.
   * @param prop_val_string The string describing the value to be encoded.
   * @param prop_val The bit vector encoding of prop_val_string.
   * @param typ Optional field type used to help in the encode effort.
   *
   * @return The enum value corresponding to the desc.
   */
  extern virtual function bit encode_prop_val(string prop_name, string prop_val_string, ref bit [1023:0] prop_val,
                                              input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  /**
   * Simple utility used to convert 'bit [1023:0]' property value representation
   * into its equivalent string property value representation. Extended to support
   * decoding of enum values.
   *
   * @param prop_name The name of the property being encoded.
   * @param prop_val_string The string describing the value to be encoded.
   * @param prop_val The bit vector encoding of prop_val_string.
   * @param typ Optional field type used to help in the encode effort.
   *
   * @return The enum value corresponding to the desc.
   */
  extern virtual function bit decode_prop_val(string prop_name, bit [1023:0] prop_val, ref string prop_val_string,
                                              input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

 // ----------------------------------------------------------------------------
   /**
   * Checks to see that the data field values are valid, focusing mainly on
   * checking/enforcing valid_ranges constraint. Only supported kind values are -1 and
   * `SVT_DATA_TYPE::COMPLETE. Both values result in the same check of the fields.
   */
  extern function bit do_is_valid(bit silent = 1, int kind = RELEVANT);
//-----------------------------------------------------------------------------------

  /**
   * This method returns PA object which contains the PA header information for XML or FSDB.
   *
   * @param uid Optional string indicating the unique identification value for object. If not 
   * provided uses the 'get_uid()' method  to retrieve the value. 
   * @param typ Optional string indicating the 'type' of the object. If not provided
   * uses the type name for the class.
   * @param parent_uid Optional string indicating the UID of the object's parent. If not provided
   * the method assumes there is no parent.
   * @param channel Optional string indicating an object channel. If not provided
   * the method assumes there is no channel.
   *
   * @return The requested object block description.
   */
   //extern virtual function svt_pa_object_data get_pa_obj_data(string uid = "", string typ = "", string parent_uid = "", string channel = "" );

//-----------------------------------------------------------------------------------
/**
  * This method is used to set object_type for bus_activity when
  * bus_activity is getting started on the bus .
  * This method is used by pa writer class in generating XML/FSDB 
  */
   // TBD: Add when PA is supported
  //extern function void  set_pa_data(string typ = "" ,string channel  ="");
 
//-----------------------------------------------------------------------------------
  /**
  * This method is used to  delate  object_type for bus_activity when bus _activity 
  * ends on the bus .
  * This methid is used by pa writer class  in generating XML/FSDB 
  */
   // TBD: Add when PA is supported
  //extern function void clear_pa_data();
  
//------------------------------------------------------------------------------------
  /** This method is used in setting the unique identification id for the
  * objects of bus activity
  * This method returns  a  string which holds uid of bus activity object
  * This is used by pa writer class in generating XML/FSDB
  */
   // TBD: Add when PA is supported
  //extern virtual function string get_uid();

endclass

`protected
-6U=)=[9](Gfb1R.@&334I->gZ@+eaQ]QHQ@,aY5D=NgU^>#XCC.1)4Beg5MV1VQ
=EF@ZgY0?\<7\cG>)HeD&OM9c5OZ0X+-?JVQb7B-Y.R<K4<V8;DNB3Jf0@(0^PVL
UD;+1)eM:>;5\d7M<?,T&ET4g1AY?+5-[+F@EGBgME[+NdJ\H^TI.:87FHHRSBPJ
GD7Fadf>^g0;H^Xb5+#Z#7.L&&4J?]&Wc;ID<NK=dUKT:-T&Zc[.I04J]PSdIf\.
F>F3aX=/C3g-+B/)gJID;E/7[W8e;1ZCNOg#EHB2DBPTKJC6TR,C(FXFJ&e3[Xc8
T=)Ga-C4CMJIe&^IOHG/?]M:Z.-RFRZ-(g=T0]\K?9Z8HY_RQ.(M]=/0a=GRE9]9
9Bg1>I/X\X6AEE]5K;aMA@I_JX/.N]D0=Q,O59+I^>bQX=^A4cY#ESYZ_7(459;E
@]1@[KdR[L+Q1387,fJ((HFGe+IU2d,,;B7^(5LK#GcJGg9>SPdd;/9O?c98<_W?
:d[V9YTD0]@f2/Z.HTc7fa=+M?)JGYO<W#@DB^JXe-Q.1&-,QGd:IJH4(_1V,]KY
J(F,<=GI2MV_dcQ&FTg<c(QJ:QOB6K\JH?-OMQgSD=T-K0;EHOc\\(,;=G#E3+&)
B\0J.Hg:C<f/NS\BCgG1P@:0_=,3IFJDB+5Q27X.:>F6BJWe.DP6;PV5RYgC=4K9
\DP@Ic_&QWRON@_D^E;&+I6<D38T6.bb<&]aFe8;g\Ncee+,S;YF<,X.5&W4_]\:
LG:?1CCQEcEEU,&P#HOK78(V8P:D3(U-DT38.94E<_2Y_<\;7ba_;0VI+9#[#9B@
N<4\dNJAe45UDW6#&8dg\f\T?/3SG5gBHK,_J?^,.aN,XR9@3<Y5WMQYVHVVHOSH
?#QTYX(_eMKbgS<6CW_Ca\bAdDND()E27-VJ0)[-\CG:[ELJf_SDVG>,=:Y^S&ZK
dKf[2LS;ReS\;-0c?+)C<MZU^g=FUORQQBI?XZ4T;TgM[HR>)EO=e/REW7e_LJd<
Ca#]fYK.e-@cF5K5XY0-NVIRXTf_N-6=HZL<&3Q4XUg)]2fQRaQ_U0cfeS9gYU0S
a[eW75gd:^U,Z/Ufc+M&C&0PD_ZP\4^74KM[fa.D)_B#]SX:M0dgG]Q^?<.03S38
G;@T;YG7,Wee];]M+4^]28[Q;/A:LbCD>4g\c3FZSFK;Je2WP74WT=&de:#e,?W:
6O/VCa3dXJFW6B<U:Z\Z4[8,Zd(D?)^ULd>K,Lc);fLY;bY^@1SUbP_SJY4MbCPO
PdN/I0)R45V+]&)P:&M]895a15LX@+g),7d1WD)3W&5)5<:QdR1?Wf\(-[#=T]dZ
E:NP)]TQ;AJ>VHe#f#ZfgC[1O1NUBf_G/ZPaK[][YFc2I5U#IUe^GVG]A[XK,W38
+7<e0SC3ZBR/GcceU2eD-N[@REdT@I-Z+_\79DE/#L-4POA4MOMWF=Mg24,6b(.C
abYG7F&.WH3F]NI5@13-M(/>a&:))[\+cWcE=LOS6Qf5[2];U2G4b?b&5BX?\09P
-U=2UO5KY61e\9+6JPR&d4^&\ZaZ4ab>/^RZ7.+=5<M_&;I2Z2@8L]f#W8gPFDN:
HS&64#N],EO#G9B61_c8&XSH6K0:Q\<B25E_7;Hb1Eg]@cX8EDS;VOK,./63D)ZF
1EGd4-GNcCQIW^9e2W6#5[-A;BYBd=cOCdK]T:Y>TY7PFg;U+fW]S?MGcNZOH.4=
5B.1FGFMK&DHEZHU85(_Jc-751(UbAYH#-<_NH5b7PD]9@4+gg/c=;R/M3L:e_fH
#+CMGPMgV+Dga6d5\>001I9P4XFS4Of@R>ZW91:9\KOJb,KNAEO;PE\G^Mg(B[b(
^0;UGVY5-4c9G6a6g<JD>JaBG2Td-OgJ>=[,Y(/Ted:dCP8C&K+UgJIWXSHS1Fb=
#IJ]C6@&2dK=IXDYK5e?W<-bMG:[[2g\8OXD,eJ:K(W=+_UMWf65S8EKC_WfW-?&
-R.cc8f=9c4cUJY82A191>:<T_<&(+(f03=1[fHDa\+eQ6>eNHC.;.@b_V4&@0a]
:@5SBXV7;PTC7F+H<I3>.SPS-[+YYDA<=7K\6:>+fQ^;cN9:gCaQ+H,8J=4U]^Q1
(ePB\O]9N;TcSR6R96<KQWT<?&&L[;45&2gBPAGA1dceV()FG=7T1FC3O>CQ\[-<
b4W0&R6O0dVN>)=^X?P7c&5;QA:\1Ec3=K[7A#FaJF-(L>C3A/Z;dEH;3#Q4N05T
G,C4T7HXH[^(>^f1\G&>037G?KJXY/)7Qc4GY8,T,g99dRb^B1Tb0S=3<M:+N3L]
XL@f@ZN3(OFPCV(0Qf/Yd<RbC/aAKeRc8^=><eQM>WU[IZVPNU:bN&[D1T;,Tg=\
S1YIL7[gD-/GMV]FAVIV2?]FW(UfB+NC\Le,@D2<Ga[Y7.22[)Y@EMOMUcd/6[_&
/?<f^c4B1eMLQ6S-dDRIJT-IbWe+KK>VA+g]3bLMK^3bJD3BW1g#@QH6[f^LG+O^
>&e^&V]G9Q4X37D8?:^_B>A;D<\N6f)5KGgRbX:+S:b7<\g7#Nd<.@J>Gae10@)&
<bRc+R4CfdLWT>,R0g:_N9VEN:bA8EZ)0),ZJg(W9R)7&5?M_c1.Zgd>M-IF>1<-
.=X(7QZ[)PBc[,-UFH94JgAUSe1UGJaE\9^E8=KV^4+a^\[M0GDP#eV9HHR;/AGM
2R7+TS7-#[PM.R^<[B#cH\TD3ILCN]?X.<=[8.fL>#+ENJ4Z1+PXDZT8Ua(6?cbE
P9G#;BC,;#BDJcY)WR=]7>TAPYUTE@aANOL,@CS582]eQ[E]8UU9=\7#DF;&;J;#
[cG=J^[IJ/(M/;2M1Y/J5Fb]eD5>M0=;e/-/DIa)^1BeC:D>=&;U2KZ7],Q#4E@^
g,=&-f#Q;_?5fHX1[P)6B/2eJH?EbI#9R#cO(e1?,b6PMTA49cL:O0VXVMg@5#[V
eKaL@dXSIafZ97B68c6f[=5d2/0Q@_#7]Zg)\S6\cQdO[OT90JC&W:];K?+@0J>e
;IFS:,fXORK:a#SSNFM=c0,;_QSST2eM._0V^>JB-a7e#[Raa4_^#=,L)Bg;5]8-
Wc_b<B_+K.:R5>H9P[;Jf]V<NN5+C-Z[B,E4,4,E@cV,#S4d(0eXYaUDJ80+SWa=
2AfB6C;aW>WP(U/X7@fgKQXN[.;K?dA65Q>Wdg2@+;a=I\gIQ-c)Dd[39L[R?4HF
YV7/R[@(4f_L@=;\FS#NK/#Q2>I==aNe9<FI6fV7SL,bGgGQfbS0.T_<&,.<.a0X
f)S_gZ^_Z9NZcd])F45Z_1DW><Q\ZBcCWO)NSU+c8OBd_e:O><AG-c@WXcB/D_Vg
+M/]SCL4B)cB.=2Q>,[J],A_UK>SC0/2,93<:IfDgd051<Y->f[,a>:WI,P;M,A6
8#KU;Df618fdb@\EN\EgYeN-95_NQ3[)D9,W.I\fZcW2&-_\>ee7,0((#NGMCHZ=
BgOINcBc+\BF@d7L?+GTHJPUYF].@H7O4Nf+_,LDd<_/T&43&;UOE^a#K3E9_#)#
.=6(P4GS\X?Y#CTZLX-2L2QEO&_B09BIg/>LLbO@E7V_^1eIf4UR_&\;eYP\HMH=
)V:DOgN?5J;6#(90Ae8OJGDLWMX>@\TK[Q-P&(CP8QK6@#S;II=,bPPW\P\&a18[
0I=22:YW)2B_RecOO<S3?D]]_DW,+XY7daaXSM9C:TFQX=/dA+_XQ_L;(M5]Sg]W
8,>O(c=H^7^g5BJFM<:VDGMDGeBR;]V8J2#I0;)/94^:&X4)<O?7IP[0.Z+N^[<_
adeKdHLcCK_8BVT(dVg:e0GP2P>&[W:DcD8+_1=,#,N.[,3=RT5)IW,H/LTFRMPL
3Z,W^)DE3H9CbUYFZCd]e[aL1SO<\MXM0GT09ba#=(TReGX?gRGH.X\cS6:e<]1.
6]Y9-9U&93,03Rf/(Ee9CDd7]D3,+3LSAcgN:KJ[I)g;PF.f\4YR6L@]3K1?/G\J
9A\d/<CBP@IV?VF(Cg++-8BQS]KGP\B<bN(])gG>96bfLbZ2G\PRAH7ad\a+aB#D
XU?EWNH7+&/A4;#>f&EP081dOM+#]^gC2UFbRMMd,84f]F)K@cb96;KG-PPFPV=9
e42ZMW?,f\M0DD)LaC\?L5.L+bOeSeAfGJ5bC,(O7P4286eYU>8-[J2#LQ+dRZ-:
E^BJ.cU#bC,FQJ2:8deE<d0aHN6F([\UBL;@O6^^6/Ge3F0<#UC(T[=PL.-/NMEO
UIN,CYbWZN>,)7:\;)OS0d_>;S@-XK=F9HQ^1=Gd/d7O[5If4SV/g^T+IL(f-Y]Q
(a:5ZH(-FB]UY/K03RZ2N[)DH.;4<JJ,2VJE@X\YSQ;VXJNHG/DT3fX.99;(I2YA
eP79M=K>B&9LfGe71UW50D:@8H9O-3[?]&b#7J[OAL)SW0K>?.a006>.Ob/UGEdO
0ZD++RT6DJC3[.R)+0U8-e(&6F,MAR8<VK80@dVGH(OP=^UR2<JG/4]&A^IV1I-9
Y&F8LU[148dF&LN^=T-^+7__PM4GMF8J2)Y/+)-X0?0+L?9&<cX;<D>Va2,Q6G,L
/:d,P:gWTMfA^2b/ASR&CJdbSB.81Dg4T,S,RQ[LKL\FGDgV.gDAJCNBX9g)4YZ-
B+eC>aDV3aH8Q>(Q6Ab;@>7=@Rg9gD9@bG3@ZN9)Sc&4Q+NKX=2G;)?GcaS2UZ;N
JfQ/QV#O4Fg)_F^CVZJd[QN8<eXb3]1THVCf2Gf)4>XO)?4-_CTEXE>Y.[A6WWV1
Ud];PfY(=gPG&L]GbHLecJeSS0XcNF99#ER2F0M<MQ,59L1EG<V#Z(D67<[V@4JA
\-360^acD7^c_34.C.-F+T.Y6I0^UQ^@][.d/91II&E0<T/@6f::-.3fdf^7b2HU
MPFY<O6I[.fH=6aL,X+P/:ZX<WFV8S.^\]:QJ[2VJZ.1]0POaRd7[H-NWAWB.Y3#
SedbV&:_2T:OcfDOL(L6.@=Q+<>Of=\3WK_EDe8cDGP.Cdg;U25_>H;BY^aM6[V+
U_cEK(:R&JBV3.07c_,X3=/EOC>7-SXO^;S,SS?\:RE#=X8MQ>IPR<QWC8F=>5#V
2HO]G65]\=+GZMed-\+d2)KD/++4bWK:_E,eOKK4eJ/M@b6aTTT\[2&9^.bE?;A4
-KXd=c(#43[BQLOeW:]5M&234L>TQB\O4/B^-646[8?ec3G&dGV4K;eV:>&deDc7
9/R\EJ95b9Wb7;TNQfHfEYVJ:c>J)^SO<&WM9;Y^BQRDHKN.9;NPLAL).A[3M=Xa
5T8?<]8d60W6_@ZM+R/5ILOEbZ(^.,N-K@)?F1f<1WcB=[O0a\=Vb(;X8d7X4A03
Od,D;Hc4&6f@MTgCLb<T:RHWF#]O;?b,>cM+cNJ<@_P4H:1R@,K-C]Qf5XX4M.45
4gH\P20+]W./UV_^]#Bg?5a60B>2Q&GHU[QR.BUM)QS@TE1FZ+EI8^/?-)9K@Hd/
D0)ZLOX)T,fOF[;5aLcXTD8N/7dG(+Ug1?39G+b7PJY??aUfBbIMbQM>_P(\LZR-
0Xd]DI,>=NfHY<V?fSEf:ZRJS1aHO2.TaSPbQH1K^D3f9;OK2SaG(&a^FJ5dQ\.)
7Qb:;XMf7W7Z9Md,E6]6JA]TdA-e&LcLH^b1@Q\2XI.E_N;Vc>a0=EZ3SbP)OH/[
AL/ZS1&#PA@HV=dgEKb2A]F\gc(C3IXE[I-gDPJ.dWS#ed^N/d,(&V/Q^<G3@KN]
3V7_B&;=b3<(TeJOcbG9,[YeH&Y92YLMHVQ+@H5f/)6+EWcb,d6Ie.eZX;HaTH&0
B(<9TZ0DP<e-\^&Vf#KZb&<Mg^J:@8:,5C1FS)?Qb\A\^EI8cI,b:/.5c:c6ga_#
(g0AbJ;>b;@&?(WIZH]&+>08Z4gf6+Q_#ZMNf_<P_F,US>Ua+>IgJ-WZ0:-KGT(9
G8e@c99IA\=^SK0(ZdD:Hc8_Lbd6BT4@UCUPW6)H1[XXN1;1_9OS9LGB<,U#S.9@
]>JPQYc65O8bc@CA-ODTV?85=dF>Sf\UZV&HTL5W9&;]fb?N-S&^aVMGJ.&^f.N1
IQFS:LA4^U?dbc-1+b<;#bR(QC[ISec:VJO7=O0=R(Cb/S]G+?(QUN)@&&]<5W,A
GV:@.F.g4NJf/HX;)US79>#/<bLHJ3?Q(MA,b(V@7;Ab5NZVQJ,@Y0dL8^H\K/>I
9PL^THEG42,U#6>[^@;.[YJC?,8?^^dc+\;VN+/.>D^-9e@,5DC9NI4^;,A)BP;&
6CHN@c,K?COOcW/Q[]HX^W1B79:=HH+C;M8DAN[DH:Te34<\M-\dRfGe>gZ[UZ9-
.g6ZVUdV4.-0Nb4R^J?/<dF/NT]>gRE==+_TT;dM>]d,&[#>?;bDK6Z8/eI2W)X2
^T5NH7b-DMAD=/Yb1Tff>P8CQC6UQW4,8;;gTCZ3N6@d[_e&RZ88&b_<_f0LDb\\
aJGAE-C9):(e2<7+&4FNO/]^,>#>8_G_8L0-@79>b35@G?Z85FG;DL<Z_d4&7Z;@
QT51<_>8eZ?__9+7S/aFEcc#<Q2B7V,e&CcILKSI[J_S-&+3XcIYX4,b\(]&YKF9
WU]HN<TeX_NDdIRG\Wg\1C\UW@BeQ;3KRU\\-KSg86^:7>d\O5cLU9NM]:=4-SN-
FCUP-PNPK4DV\U4HcgZ81C<[-PCDFLGG#D[=YHIcE&bQG@P8J[B<QJ:d,c875\dP
Qf:.N?^^X68a2d.,2Ta:C7=D+f/3]++CS^YH#F3WI-X@=e1Q\DWMTNfW((&d-)ZL
fT,5=J7TPF+9&NY2d=429\K&)5B+I=GOX2TR,cPP6-cR)1c0a81E:c]^]f:Q?&Y+
]93e]g\UgT09F^EJ=^3U]6Q6e80M:T#KAT6g679?[+E#6JaDU;XH:6?E#fS,g-b-
:/AXfJ(&e0S@8ICZa_G]RLCTcCX/WG6@8.7(.YNSdF[E,#786+fgU5&ER2S<8=7U
PAC8;c\DJYN-:8X\cEPf,#[2;B0)(]H=TWa,X[JTXB&UX0[,K1P@SAODO_[RYdMW
R[YHKN\1g8XD6)F\)_8FaT#Z1a=KI;T.D\[ENIEFX;@fYPfdO^?Q8(O787I@>F33
c?JXF)g=/V?Xf>RQP_/F,fFSSPIWBdIEABEID9b82UFO)d][3R0.d<Ya]L#LQe^,
N&,AQ-;VNE3)eJBbI0J/N,._/TQ(\E>4#)<;G?\bW9F8(d]R=+0(e((C3N2N+9T,
PFbA,45=bD2W@T_V/#ZgR.2-)=Q?]FgaW:VG#^R9c80W<^e4Jf[2FA.:@8[4)AFL
NA]@g707<K#I;NP@VHY??a=AID.Q+:Ma=6\H]X)-A)WY-<9CeKJJ:BP=^.?L^LRS
#[DOfAQSeSYf_TP#-[\>CZN8#ZIT-2@FR/EaYdP.:Le;ed\FA^7I4G_F^bLF^RJ2
]Q@0K+6Y\eFRd5_I&4#&RTH>,dI2EG:22d9318,e#,)Z1KFC.0&<^?+(GE+.D<_\
V.CYAc<UZMFB^>CZ?aR-AX+/?6P=@?+SC.;Y-K,>-X@>XL1fdM#\?HHR76dge3XM
Ie+Y(,#:,DP-@X3\39DO<9J/+>Nf41:(^5;fZCGebd+KUX<KN4V?XUaU-=IZ#JFf
N8/T&7.)5EOb4/;0a6.RBf?.=49^eT#2F-cdcOBP?Q_XT-.YJa(XVUC#;5U-]UT&
(fVY+?QW22G9_ID0ef2\aSH#AF)PS3)S&cWZF3N:Ub2G__IOA/F-Ua1V[^bC>W/S
G#3@:2,fQH2Ua^Yge8T8L(MH>#FZSK=J5T/SWK1.A@1G14QT^0,U9g4-U49,Z,UR
3AX(:6:>K^a0/-UbON052N&A@AE46eK&a33&2f,eEA,/=(8.,?]EP-?M7N_cc)M2
T4ZQVM?HKP0;<30,5,R.Nc5,LVQSOb,Yb=JA_)c+Vd#&IZN#VYO6.a-)2F<6W-F#
A0ZJLH:6dDX[YNDb+SB)@]\?CA5>4)c=U&N7Y,8_NB-E7,B,0XCH,AIgX:WLL.7^
P#eBLe4.gQ78GBNGg/GZUBNX<6LH[bTZQ)W8Ve@a76]@([(MKT,+(W:7YZ3E=)&T
S>NZcS906N9P5K9T[S+dd(8[1+)/SHB[Y>#VAT/9T#IgSaaf)[<VE]0cGOWbF@O8
;)]>.\;5LHK@A=Q2#Zg]:LFIO:TW&a]Y^Z,aQA+_K3a63.VdC91JP=@8B.<RB/[9
2UTEH]#I[?BM?,0?N,,Z[KXS>Z3.,7SdHKSAaVM#5?&;3@JJ(3KX\Qc@=;Mf<cO4
7&cc[TLZOd)=07UZFN]e0&:Kd0g_^N=Qa>F6RZ-aK,A@e_:Y7Cg-Bf3-7_EH,d;9
3&^Q9=gI=O)5gDI+;4LE]KeFRJc;=8bM7@c;R#fggL^;)W/Ya?QYSCZd.@R<\+1e
7W4913W0A>C6CQILVO0a8?#/6Wa:98.?c#]@;J53A&a6&TR\+H/I\FYRU;Nc9J21
)326UE]D@aU&&bMLNAIW]Y+<89:Z/9Z3[2;N9KV\__^L\RU]PcZZ14aIfN&X&\G1
ROQ5RfWL<Ng1CRCIFU.(Y<2I5I<)83dc+14Hf7=CAYSL^Y6NJeQ_JV9caW>VM0O+
A:16c4O3UJ8;RJ]bCe@GC\>]JW@9EaDH_;J]?US1;b;fNee:)F4DA/S()(TA+eO<
NUP.J-f^c_1ScC,26:;V3J2K/0U7:E)QX]ca#VQgJIBaYSZPE::[4Y[c52))9N&-
R[;G=KTNWX9;3[C8?WHf>Gc]QLGc9II<9QMfQUW9c?4<],>G]d)?Lb=c<@:0e&S5
gR_3J)Y<<^dWK4I.J.9=45e[O+gac\8I@\-OA56>KJLZTVXWad<_5B<AG/_Y0LE_
+aE?6U+fFMBDLIB3Z&#Ka\X03dC@VK:RWQHG_fSUC@GI:[G2?a>)E/)7T5XSb1-;
<.0c-<;)MEF:X;09(24A]0dfJ:OVXF&K?bJeD4FF,PRG/=337P0KB/;/H47:+T1;
eW&;&6F)6XEcAFXZ1/a]MB1(cK5+[^)eC^BD_3AD_NCVN+gLZ&&>f_GMVG&@RYRc
TM&da=P&\XGTOcf6;dDb7+CUC)PBJ=\,;(Ag/HfHZL)e?7?T3FNBG23\H@>F>E4b
U^EK-SR,OX#bL5M=ge9T5>AGX;DKL5Y]baN.K36gW1ccaN_3S-8U?eAEf@7EY&eQ
VC(F)e1CP3FKUS#<#))0LOY3XR/RG+f+K>FMc??>U<A9?]:X,ga##&QMfeB/J<;b
&#U]<LLaW@[I2C\W+PN+OF4M4-T+M45P=bg#1[A26DBSV?YcbTcQ=XQ)b#0Oa/@E
fCEJaNXF:fPU?FV5Bf[5Q.&4O;XLP2=dZJcRf3/YK+Gc2c8RT)JGX5&GcC&3g1/V
A;\=N</@A47+B:ONEZSK297>L=ZD)OIAJ50DIV=Jb;2]::Z<S7W)4MR:MP-Q)dNf
V/8WK<SMO]3>RS/FWRIaSaK8ge1aGGc278F7G:cYQ0)@/)-]8Pb^Z659)>BJ?Y_b
:^)AR@A3,4#>Kg5>1ZKC/N\&-K,91S59XJ&[^8Xe1Z\HfH@M56GDa</08-eg:\PT
HN6A^_2@QD->7M-6c2H-SNe=;FW\QEUXBPXOVfb6&/ZaX:XfGF4Xe0\I]]GFd?F>
O_J+UH1.g=Z5E:Z)8()_^IA4>BG[T:^10)8A]&4@_2KN?0U^S^42MIeG-^F<53f8
JVW)#^Z-E[S/&,Nc/>[Ldd@6gW8[4[_>9A2]#A_EV7KT]X>fG4:3.2N80\E;?2X2
1ga:Ze).-/V?5=^cA#?XUDV<d]_,MD>)\[1^N=,8(&#;-OW-8[Y(R249Cea3XG4>
T4ceFa2A7B)8Qe6-3-)GC)Y<HdB:]T+g/7WZ30AQXQ#WBd3FZ\P+WYAGZ<-aHVgG
64U[>=^.=8I4[aEbY5g^RE7GafE6RFVB=?5>2ULA?R[0B0FfLSW.4MPL^^QYE#(N
G@Q+>0^CfG_&4ML,^bDC4Z<<5Z3^ZgUJ,a@6+5>+FT1QHZ[/5UGE34:#I(IE)Mf/
WW()(31>F#E[d1>#;HNIV,X/aZ35+1g4:4d)Nf2;W,+cMgBZ/8\f7_ML5fe(D(<I
A(OP.@;a2>=X,J<3N7I=JO&Z41<5;CN(I6D^8U6UgV#VD1VF:?,PVJde.HB?]d),
R+01[Dcd#+P._TKJCZ:I<9=TGZ3L]H8Hd4,(T#<Md7_2FZ+LH0cbc95a]<Zd</)9
P-P+\/HJb]aB]Z)9/eV+;)HQ9[g+@6:S<;5/2Q;2:1eKQOJ\P62Ua7D;4=+T)-3/
7,a=+R(NOEaHE7?L3;C=93.1b](TYYc6cS^fJd#WL)TKAd-_8d[8A,[CQ90BXCUT
W<FVb>0D-C1?bO:aD,;?MC46c/aS4)8JC?CL@<BYHeKES40C+=)@#b0RBRS]G+A8
4Q7Q/7A=3@fD8>9+,.42cS<M#Q?>@GbW/(&Hd:+;XS6/=YDYD_]G0@UGLfTW9Q-9
=J=V,G8ZPJU1;2GX/CeNVN2FDKEU=K>=EJAGNM\5U_HJ7bdV\W:TPbeNgZGH?97K
H[GRaQFD0O74e,H2:]c/?H]:)FJAH>#^X9#bKVS>QbR:9;<H_Lf)b?<OIZFb+b#_
U>>E@f)Mg?&Hb?J.:NM@B9JGW<).VQU_?cS<.f1MR754a5W];)KeN@F__S2C7UV5
^4I@-D&89=0P+9[#C5H#,#H,JN^>?BC(DZLIUDD9HBR^A[Q#7TOJI_G)G#@XP,+@
ENF<8aBW_B-PY+GE@&7#b=@^K_gY\\)EJNc5/&#_c?:aZSHXK:_)g7<JXN&#&:+a
eB.8>EGJCaL-fbfQOT_@U^5\?U54BU(5&N.I=]6OS&^<FA<R<ZfR-EW,bGS]]<>7
)-5VN8_3bKQ@OGM-N>(d?XR46F;9^F?^TKBPg:fN5Ne_D7/2;+g7DgH#R2MYPQ=C
+&]M1KD?>G5R]WP2S]=XEOXT^g@CK3F)>aM+3A9J230.8-[g>Ab[)/2+U#LU-0/f
TUPYPICHLaM)^\Q<gc+[K@NV_N=IB_2IU2<a1CcF/XE-(M8S0:<fZ<L=NX>JBf(?
.Ic=9/EgXeDSg3HY79<9GCe-dA69?GfVc7[IGJ(#X-_a8.Y6_b),TV,;]&c1KI3,
\a&MZKPK;?fC?@,&&fMSMZ8JG011:UeOa.2b1QG7DOB932?BeRU5\N]XN;BU>(TB
gA)ENW=PBdE_8[,D>_/gMN1b(WI7/8I5EIdIE&ZG+J-4bX,JOS</?NI.?cTS_4.]
#\Vb6_?40U[H\Gea6Bf<HI^[;O3W3((eDG1&ea8K&VQTQ.7;6VO6Z3@BH:&^@<N+
bY^L2;L97RJB/OU97SN.ScUT6\&UZd+YdSMaI\)#EO&OQ:B+T:<YJH8I-G4@dK9T
@A7)R,/HNK]MCA]:1+S7Lf>#O]?MX465L5G-U-44ME+D&W\IL3_fZ0W6QT2@6X4f
C6g3Z&M?/\B3ZcRF>+-[>FaBO-+=IOZg@&4U4Wg2&BO6MB<ZCOW4bQ(07BdWNYJ2
U[:OU;b5B3NgbOUVg6bWZ^Q?[01VZIQCcC->?2:-M#L(R)d=8PL@4>Y,\df7LK);
A&L/7-0PAD\SJ[1[&7E6/APLJ?2aSe&21#^a\&9=?/A]9Gg&91;7OeR&?8Q<<ZQ;
fJ)PFPFW\IXQ8Z:L<]Y^UWA1@V/(LV&:O5ANWX7YEOV/4.U>&/SIW_+7BWf[e8eL
B-a10ZO-=DJSf6;HTX&T@&T0:]_B=67,UJfB][4[fZ>(0GccYaO+Q)a1D5_O&dbg
,Kb3,LH^?_[:.<Z73f,McEBcI/8@T.3X3;B0RdB_beJB[;)E9DT8bI]9OT^([>79
:J:7eQ(0Ed>>+7L)/.+N(+g\a5B@_/K3MH?FAM:.@Zgc15/46G5GA7ec/(,.=\/@
FU4Fg=+S@M;JA?53>K_b/\/D46013QD><P0<)4RIdJMNG\X(C__XUEWQP[RU>\3d
eUL,H@gcQ8:-[,dG)[&XOTP[&.3_2W2Q5M33<?.BGNM6>cQ]B^PK[6a3dE-^1,D2
#-Fed4,U1e^9SL2b7M0g;,6U\O2D4.,;B#CZPdQEI6Q8V_d)2)LDS=CU^\RD][PZ
4:Z.7+8E#3;)PT_I,@:PCW)@E,<\,)_S0d2X4YMKf<XG[NE-L<LJ?GL=UO0A[.<.
Z2(RTabTYf[43PFY&0fK._W7cd-\QIR0CP3Q]PJF8c\^_>@<:8Za>;7S7E3aLcJ+
cQQ1UWHa+c6UM9&R,1Q.,AU8[Q\/^><YdVH0FT3?M^B^?LPZ;XMfb8E8?Qa0A5[J
1MVVNO)de2:YH4,9SGdT;\5CS7bd0&g\M4XO2P9AQ2ffP>]3@.fISDa32MPBTd5_
QW+^4_S7#beZS1(ZL7EDa2(R1#9X(4?3edXW=1Ce49K?==SLHR-S@\aO5)+AV^,E
2V;?CEg-a9SG/Q)-O)bXAF;L)_#B8ESMRWN;/c-(>ZNYPF[-be7ZH[UQ]]Z7D7+[
DL1VLF+8?a7[&IQT0dGOE66\L)V1Y0KT@(V5fIFVQ4,?M6;eLe2<L\cZ+::X6BMe
B=2eV5@0#DH+M,2O^ISN6R>ZOG0Z@CB/,XEA<[_eIXf,O2K,X1;]TJZ[(FPN0/^G
R2W8]KY&UH40NNO9]<)YI<Z3\:^O@g.I/aVC6G[Wf]LdQ31S+>XZ77<:T[;BPO1O
H/39:C2/^KgA6^ELBb3>,CHMcA9IG;I?ef5Q-:#KQa6Xg5J5ATXL;TEc(F&;3(gI
>I9@Z[ILe?YfW@>ET4OR,K3dF>K=R:TM@R4AbDVKYSG+JCb>JD>;<4Y/A:C7LT4:
7I86XJBg4MR=R,e>DSU6e@f:Ccc_SR)Z;&Q1YX?3IDT4(Meg]I;22dUc-.;ae3AJ
51=aae7?C>.)aQK\IH,T@+P4T@)N4D\AV,ZU3WUJ_1:I63D1D;]A0W4^:F5R9:(8
-3D#S2Z#EI2;#P56GRd94CD2Y>X(XI2L91+SCJ=9d)Td21Z;O6d[<#V.Sg3I7D3D
)WXXR44814A)Zd]SZ\^Hd/E<8JX[g42#=L0\O+_e=];7+F/JTD+L@TNX:CL@dRZ_
AKe5=R>Y[/H/8XS+fg@W/JGQ8W[QE0]T)_eeg4eB^B?;A/G\BBPYNI6A)GJ2/a5J
7Sb,Q(9RL/?P]1>WERSGY+f:1VgSEeQ,dQ89\S6,#HZf1Mb)?CN;(_=d=,>KTJW@
/3/,f>:7fC&?]K2+:Y-:^<_H@O\BXa;TJ[&fV.7.dHC-gY;aVD]2_YR,c<>#DR.O
(ZCU)?82T21@FVCORXcY@IXB^A,#LO:7&e>JVD?G.<;5SWK<8::][54LbL9OHT1Z
(UcS0;d,Ua<40H:&5C/-7JWbLf?>#D)VR;SB>C[b/V3PB@(+G+DXR]^ELL;gT+YB
&FJDI.,T1_9N+N[]TUY^cK,]A3[UN8R6<AeAJEDIVFYNG:7]+?)7V^Z&6_bGg\.&
0YN8ee]Ld,99[;b\?EQ;/7b-5GQ_=fS?EMGT#LbJW;NUacAOI;S3<[b;FBFZH2B)
TW7UUTYX(X9M;#FT=Y=70Cg2.4>EC/N)#IR90Q_#=a)F)8<#T/QHEddD=S][58PK
HCU:Rc5).LEDY>P.1SS1Gf:UT6U\AZa3=-Q,]G@LeH;[T9IC5AB[0\XM2Y7X>bfM
g6?:/Ef-cH.O&XTL<K,R8U,<&\QMI7c#S(?&I/I/.UcQ&I/2/OaAU\A[^#VF(8>c
V8[4ffV2YXUUSK->#19RZ#[+fI7,=^R,_FffFfB<?&c9Vf/D]@EXJN2gQ:U_LRU\
:\SdS_g,LX63G,6TC@3-/a92A_NId##9Eb[PHgC23deH[HB,OS?;)?I,WEU26<=6
Q#b.4<g2QXbG]E+L,DZ6#ZUTcCGD/LCIT=..1-?-#fMYWUd6@L>/U96V5?S/0@:Y
b(;7#f0I8E>;.2V/0^X=)\#8Ic3&27B+-EgL5X26MUc\.CEfc:cg3[dgY_YFFbG=
7E+19YNfSO.,;33-^3LX\8\c=ZBLa_cS7A[>(MXC/24U+FP>K.GHe]N+T>KbBf#f
AK,>E/;E@V]d?NLXdN=eJG17^^gEJG8;_3;67/G^,Y\gSFSaQCggd@Q_7]c09<Y]
&2+\QVbQ(LP6/=dZ&-M9N?HO3^RG=A_Z=LSQQ-F]>@Dc)ZOPCF^3Y0,Ce40#D<45
F1RYePP:Qa6f[:VTd?\6FQ&V7;fB5@J-YSPON)@fMRB5;\Ce5OJU9+[BM?(c#Nb0
0RE,eD_(f(/;S?&2)#/JPR+Rb:Sg[Sd:K04Q.e86PG^<45P-FGd_&dH5b1OA8/+J
P(_[C0N/T[Q:.E;;OSL:d+<<6_bPD;,/_.]^2ZFV.E@cLIe@&Zbd,_L>X(g8,79Y
d;,=(A^(6R4Vb_,SL3Q7Md4G]4+>NPJ;2G=9a)J[JN_:E2:/g)_5g\7)GMdAbX2C
B9=DBX9=He:9E^_bXMJ?X5ec;Y-6K6OGg),0c]Q]F[/EPH0GJ4?c;d.HG=@?d^E9
\VPG>,I#PR9T::3\@9-Y,NA@<=#PD.H_B=:4:T8>[_g82QS#PN]Za9>F2^DP,1Fd
<&OQDbX/J8?N/20DSAB<X_EeDV-??V:37^T[8P5XO_+=0T6a_5]?cIBH8(?eVX0^
WE06Z83YaM[1&Z5F\MFN.?EaX/_[)+:-[[SV)eHVUeF#RJeP3G.XQ[Tc:Q-T]UK#
eWKSJ=N+WaWR2>6QCK&/D#ID^b4T>#+:Jf#.F2I9@-I[-b9YZ=08[G8H6c#Z=K>J
8)@\IS3=OKB\DebFYGWD-U@-_RaKCf>Q82c9&c@2VF5-ebYQ+bP&CAUf6,DSTg.4
?Wb]2QC6[OfF13<J@Ec7[^26,H,]SV<b[9=?eFgOP=Q5\@F,;49DPYfJ:K44VA#S
.X,&cN<G<E/90A,d2P;ce_\?K1c]&G6aJ-#:6aTIK.[KYe(a5T29Y)1LEG-QWQE-
4dWVA\@XU\]LQK/M^&.:CV\Zb(Y89-5W_8ZMY_J+2T=Z\Lc\=<UO8,;>a\@,3eIA
,;;SU9;K:F&HM@g7LX)5#ZUZA-0PA&21f(Wd(dM]T-(aCI:6]WFJOZdAb]6dWK-9
BZ)\N7B[T5J)Cc);->5<J(3F;ff>0XO0,Db\+);@-;1-97Tag8?[[ADQcc+\<)6U
OIU,?)aCT8OB,BOE8M7UK^R>B^Qa_^K:<\ECEEPWdG8L&dFRKeH-SU>NG7cZgI-d
Wb2WZXGZEUSJ5KPDTgd492H)3]LM0)50F:NOXX-AWEK^C1]a285=KD[/9:\5d]O0
[9:;e3497S/S[P7>-OI@4.c1I271/\AC&:0f<P\2dS=GQd3G4OV3;Dd_1I&[\@U;
#fO:@Dd&IDZ0eWZ/H.7=Ve(ZBL;1)08,+ZSQTT++e?7N#Z;CB[c0QbDS2)S#0U^:
?-=P/RY6@XeR67IL)cW4[4I+CXF;DD1_edRFDDB7C_N^8Z&XGaT=d[8?/6OUHNfe
/(WS)QcS9#C65e/TdVP=e5E#dI(R]QODM-4]YCUJ,D1W,6f;RY@73fe>;FN+db3c
ET79CQAbJ1b:KI_Y1DBDD[gYQF+A5e_Y28B9,H=XP1C,_YaO=JSf(F+^IV1K#E5W
L@UJRD.CPY>&[>eV_<=X+=?(N:#;)f:S>>XeCIMI>PI8CS=8G6c2:)&>Y:Z5HE_>
1-Fd+>SC-WVN+EHI^<g5:ZVE>P_AM-J<;L]HMETb?aa>5D/0JdUN_R9:+g-TU71Q
QA4:FLZ_4@a_8RgO.aK/XVVU/.-fC#_9bVB3Y(/]:4Je0E?0;=e@42=^aC#2A6a;
f:Z\=c/C\bDLc0Y5P._Vb?]QEP,K=3_W)ZKfFIbfK[PH/E,g6X.=KM29f_RO<M7g
J<Oe-FcWZa53:eH7;7+2B9+B)Ra0\4JWHII,(BSVXZ^.-617T5>G.(U:4^&L,&dI
R7JV3=gC1b+G#IE8QNUaV&#5&Z;O_deN(d.bcK9OfK:Tg.^LC80cH)=GC15(5,O0
VNgY,P3_W-.2QA:[)5O.gJR9bE_@57?T^1O,:>g2c;8?]A_f7D7ICEG49>&UTRY6
cHRP?/GFZZaH&6N/b[X]3K<;#Y8(;WM=@#[_K==J?8dAQ:6#P(50IRKaV\G;gJg\
eWKTc+RIOB&.2JX1CX#D20g8)fBgCB?SU:MD^QFF-JJG#P69QOL,dfGQdL2_F]?S
a>9;RN1fU1==PHQG^?BV3#\3^.0J^D^1QSH5DG1EA+dZ.<(BF\+eW;#FgRPH<?2>
/QaeG9>&\I^/0RWK#Me<3WZ^Sd?ZOW8AbNFgZ@YYC6c\aF:Sd[+0L::O[J,HbIXP
R@-.7LE]+;]W9a:SP<\1(LU3SXJRbA>a5CZMJUB/(?Z&)JI^8_87ZKb^^RfP)B2.
V5J+30,./(b.Yg/]^3K7HI=dCCSGEd]JOF1ZNU#LI;9JGN.+T2g7D(1^G,(JX,.J
XQ6#T^6?HY)QP,8D9EU=PY&2+Y4R.=395:YC]M6KW;>b)+NVe8SF@8#<W:LXD#aX
,0&EZ+TQ^1J+2?^aSMLT&DY_abM9W8FH[\&D^CJ4A>JMK?8XJW>.&6Q6O^&Y>He9
UPeXU4Z0R#?M\\2A6SXZ#>g[P\:SW00_1YAdHU61(W7]OGN_G0:&.K4/SMC10(W<
<LQ#AQ\K,Qe]f#6+FV6O^M_8&MHHGW2G/1+^/+)#f:/.X[\1A+BP3aK)7IW@XQD<
0f8PKTLCPa2cHcV58BP/]>Y^K@T0?Y&QD/F&:#AX\A[>>S(@b9\D.b2T1:2R#c4(
TBM)K&;WeWM2E=45.bCV[M(X[8ga5ID?^JV;I6^RgB\S0]C?-T/^TO6&CJN?e@BD
V^OWUUe\.C4Z@YZ)61\Q6FfN-YDQ0SZ9&B9\@EFe=Z+MCg1?>?#K:6b[9/cYL^1L
K@XH#R_b2].RAd:8Pe^@I8DMZ+)VKYOe[T09[T_V9S:V5e1_Da-(#dF_4E/gH(:2
ICHD->N;XE+N(1=2bM&,F/TZ5.dT.FHLe8N,\e8eK?^V&AJ9CRC1^9ROG.GXOfb]
1E(=UB?MSVD<0>a:^XXLf57G<&5IC]NGG\d59LP.VQU</T^/P:?/:AX,S(Ng)OQ\
:Ta&9LEVg\XASeNL=3C?6R):M^^P7,SA89g]fG>=Z/>Tf1PV]N^K=QQ0(4@C5Jdd
Z@@Ze7b?+O25HSAc8c0Wf578PQgXPDQ/RP5_dI_I4@f2gKfWV:>@F]5c4_B8IMe=
bXd;[3e^QQHNdWW]?aG#QK#2#8eC4VP>2ef2fT90Q.C3Pg8:=ZU]KWB[fG>O@fId
?,decc7MO-g0\X@Ab<+U]-;gMY.Iee@T)X\=5T&X^WaFS#J@W\5)4@64Z?FFQ7bX
/3?ZXWgJU14S=03CK?&?KWf832/ATT&T5LFE.g)W//<\g?,9<__e\BI@RVC>[@QI
XZ#CfeY+g,+E1IH2GN,;agIUCZ8G(7U[]/0Y9IXcDNB]<dC_@eW]X0NN,W8@W6?/
/10BfGfB(M/KCa<QX/8b2>45d]FQ>P\U&fEgcI2VAFDY>13VF=?O+ARA9RO473<E
)\HD8d9HL5ADFO[L8U+-#0:4/Wa-(g?\TFR;[2#9JH)GAL22R]G8_(E+2/MR>@Y,
UfgSA8Cg(+BMK4K()8G925=]TGXX6\WbO;3\_OXG<>cE4FF+Q>1LZ+2OSKaD4WJL
RQPa-0W5:e5KAA(M]B-W,/TMQE9#WO4FU;J6<K8\PJB-)B,\;4AJ1FKaUV-=C[R.
KS0E4L>XXgbI=Z(,7MNI]@L&GXB,M9U(a;01&KFFdW/JgCO5\d]EPU(?4_U-.d\)
PUfNSe/&_7&:C5S@#U2f\8L<@ZQ^<>KX-W->EE/#9ZWFP(X4B:J]DD.3de/B#Y#@
+Z0KJK0[O#J2;bU,Id.f:WSadEPS-E+_5C/]/R9#NTdH)efWTANcFLF5\cf;#Of^
[&7ZQ6QfLXBO:/H)SR#-<-&d)4W+#g8b;PT:7F6cHB-Bf4K:-bS)UP3J0@Qa8:)J
LSQ07Xf@=GN;5L?EOFE7HeQ,2QAb9R>HHEe-VZeQD/(-1P;^eT0,g_C.5e(9O,],
8KK^PeTB88_6<<S685#TUE1RC@9A/^3WMK;Ib.PA-+[>?cW-9?80aTRYDT,BC&V.
Hbd67@)V-g._bB<_).A2^@PeE\J:Ya(;IU-aT\#b\+Fe13)QRP9Qe0Rc(b8J7T\<
S4_H);,65J\JeL57@W_)g316[fRD+7/Kg_THgRG0Ca:cDV.I?O3)41WO#C7R]aI(
T13d3=4]_N9Z-,C(]^)cH@:/N)YY0IVLHL4GCM@MPBV]K\6daU,/cX7?8fYb\/&9
_3-ZaMQ>U?5<Q4(7HK+6@N[+06GB-a/V=\&51G8[=ST.2K@&S82.1AV?0[?OY7c6
?WBD^:\L.2PY\W>[GXH(N9)5#81F=REd;K2N3_N6ac>.6=.K3b[EYW)@HTQHKTTF
Me-<+^Z[>-=cP-A,D,8bE#4^]K)Ad6X>X]E-I=Q+@Rd]UH;N]5.L_995F_EN@VE+
)NdG@K0@beZVZ.W4)ZI@E=-bV;]:(L=aWAEQ84,a_CUBZ;+^]CZ2[8GQRF06M>Xf
AJWJ6FA&b@,d]5MB)6)O]3/e7[.5GJ&YT:B<89\=)J]KK1ScR5AM:DAALBcS[\6\
EKK>I07\30:YFcX7)3MZ)X/JBb3G,A__Mae:,JLgX>CB+(/N/0eFb:\BB5@&VSWZ
]R1-Sd0J7VH.<:d[TDO,6;,eVEC_MUXY3RWG[-e\^bKLI+@]&fdY=X8D[.<\ASPO
b#]25DBe8G)HYPR^0)R40RW<SB\NUKHM5Id0FA3J<K^2F/cRFf(;Z>g3gED-?@-L
/1I1?)XQQTV\W9e3K1/+b=UVgE-KNe(X28(4GagL<=5NG(?#8)\>?U58;HZTQeGB
PPGUeS.@VJ/d@4K#(4G.g5gCU>9XAa^6#f&gJeRc;=a?OFNObObHAT7(+U@:C6NZ
#>?dN6NI69X),-@R2,#/V_f/g+2J2^\LFS[+-]b;^/ZM^+(OL[#O><2@84PX2=0S
VAaY_-MYW6@^BV<PgP?N.;d/^SQC0fO:)9(8FJX>7DEe,E>:aR3GVT],+:9PF.Jf
c\BLPRc3LIc2W)49L@2dFf[,fTY5NIH<agfDA]Y6MOYB<@(INK2^gO9GUU/,B))c
8,1Y;;_V]MYP>;Yg[?@LZ,][0XN\-c\NN\D(<0EOg(:@eLd>S>-Z;cc1Q@BgI?IX
IP0#8UJC>FMb]gQ0&JPK?98-cd2a8=0JI.E&DUI<SD=VY(+(/RGad_:R1BAa\dP\
c7KgAIJ-E>.5\E7YG-]+Y?gN8.XO,P7;7@bRR<-+41A16[0Xc7V+H-V3F2(P<c2J
8V\V#=R^D5G7]E0Yg+^]VGT=DKS#BM.C?[#<7]aGAYI8G7[[P;N+]UCHVO:_(1-4
HG3bbL(<3A84:]FgRB/eQ[JAJ]Kdca(CcEQPP;:b>J(H>ZN5gH=Hc,Mb)]I1gJ,3
TP<LQ#e2UL\[.8Oe2A7)/B+Taa(P#QFR;,cPPOQb(;8&10)e4UfLFG+#V2Xg)B6)
?>HOENd6/RZR2e>]O1#a8UZR0(.\RY5&PF[;N=M<<=N:)gBGO5F_?WGO#TDf4-3N
HAP;).=2]5(XQ)9g)3#J\69IO-I8[HMfW-,b-Z3]_C9P-F8D>+15S@Bb7\:bbW@F
gU;NWd[cEZ?\/YL71FN2-O>gK5P1/6&)/H+.9C[E/L/0>c0a/M_ca/UT<e0U-d+-
//^=-G6YH7H@S\F/8D,g[G5Qf83MDW),-AJZ/_0^\((KM4PZCJ)1A4W?6/6S(8,1
<<0dDGU0QK=_X[+;XL./=]U:]F=41#F)5(D9O.gQ).CKJV#9R&8R/P,M20_+F=S0
C8O7L;g.T02[)H829=Mf&PEP]\e:/\&BddN,G?N;2/HNRaH;WN+KBd?dDd.CD3M@
N0/3DSV9+E&(^^e3P<bf[P847?7ReG3/1W)W>Q3B.4XH@a5,=O=dTMPBb7SWB?S#
?F;L3cZM:1();GSfXD-L^_S-:_@:CGO42:ZU@MFO&?X-WYFZSa2A,D;WZ_B&dOBE
F20K3+=S8#9)<](/Q[D&B7HU6WG,dCKJPF=;<Fb>1Q5?1eQFZaV;O1L<]f+_Haea
a@HPBaW,NO[(D:>1&4d&B_S((FA7L.gQT-Q^7(#O8?/9>Za,FWD[]<GHf,g5N:4I
da^KZ+e9-S]X?FFPX=1ZU<U@4A+SJgTg/:SLSgJY?GZ9C3>MgJ8_52NN)]&-;^f/
DLC^7583Ef@\T3U16(dNSQ6ML^594,XWHX/4._;J&aeSfFEP^C@+g.ZQ=DPH?VBR
CDN[K;O369aW?B+A>dSZWH^GOQG.Ra8T5O\F5R4@EHc:L<M:ZDO=Nf8FMQ7FfWCI
^-@&[-fEQ\58Q:Q+7cWg26XT.eWCa<f8dKdRW>C2_A8dBOZVEc?HQG/^9?TY5QN=
?3\&e@8.2aA>5c._-8e0G4T(;W4GZ/G;PgD0,GK3FQPa,dRf[2]?3A<78R(O56f[
5IX,.\H-.9c?594FUL:I,A,f-.)_#f#C8=HgJUc:RFF,\2ZL]:91X,:F5];F_8,2
\d@\SF0BDBD-)QUK?+#]7DQU/R-gQ;ObT)OQJ?AL]/ZYDWGXI,?TIDWe-Q^]88U1
2F9273(+<YV>)K\cAe,9g),2:JF/c.PRSZcM,\D;?#;0.a=1/=,>8J]5L#b/2Xc@
^^;(]UB8SD9;Xgc?gSZ8#_gOc=3#/^/-4#GO0=A>ET4:S.0[eRI/63^DWSMQb<ZU
H>)8P,YM2Rdd]HZ>@#_+FKaX9;cN&UQ9)US8-B-[dN-e2TbJY]G80#f[[3TAFMR+
gR4UIGU4bIOLfQRMAKVU.[WH^MaF#^XV&5A4DLGC11^R&<RMG8=D6AQ[T&DFJc3e
L0S?15<PZ\DHDVgUU4=:]DgD)Z=f:7M>,Z2U\I\Ya_H7AX8(1LY/&Y6D-_0gK:bc
DE<8QS[4+17>3aQZf&O07gEOJBZ?A#84a9Z5>4/FO3FgBN-EUEGA8T9NNHR?cV(I
ZaLX;B2cRc5G4;2.]M(>RV<:+Cg5(;9f_DdBSfK?/FPCNa#MNZ>I[[QQ?2&\Y(Q)
DW>8@(JZdg2af9)cDOTY=#<&:Q[1_>Xe7M0.7-1\2S34M]JQ.K+R=FVN7&JY:WD;
A[e/Lc@42gAg6K[5/e7@@0e4J\W0]CU(FR(>;G61LX_9Z34d)80A#REZ^BXW0<&.
Eb?#-BJT]HD@D,GXJ(abC2?Gd@dI:]WU<2^Ma^H:PdB=]4IE9&KWXaBa;dDNIA-7
=E&cQ)]<CcYf>3(<M@J.U9(H.Z;gM@VL0118Ce2[#<F;d[ZD>=VG^81>DI&g34:a
=a<F\[eV/RaG(D?UbU.?TR:QL7Q^ZC;.=_efW:ad1^@SA5dLGgIZfAfUT6R+8UVU
4cP(,d<=^O&:N.0c)OYJQVCM_X:J>V5MHGf>>REAfJM=:P1<ZLE)e;G,Pf9f@T0/
fD-6/014]9:)BU#b>FREU1Oa^ITg5AK75A0(B3AL>?\+#8U8,B2AI#_OVVAABQ+&
I&>]PV8KE91U,e1TC^=OH-\J^Y+deT?W6HS7+75>0_VC\2OB3[]?7D1G61V/&FX3
gP7YQNY]aE8[6c9>Y:2/YXR.C)694+WV;/?)3a#FV+S][J-W(MC=Z\Q[Xe\Q/PU_
NB)(S,BT@Paa3OZ<V.M@BARB<>]f9<Ce0C,UREBQJ:T=4Z-#c38T/FT9+[L-DGXS
8eHX)a7J?34,86b(_ON-F:gMUa>\WDDM^K&>^3\eb/@NGV5c-_7a/Jg2[D#R^:?E
db[:O\&2/^\@C@N33]BBBJM=[\[]PfR17R@/Q0MH(1U_;5a86:+Z#e./7)ZbU-&-
:K2F]Z3KV[LDaAOLD8?eXD1B>QE<@@I3ZU#^0F;E-4aef9_J)-6)(+d180aAVg<A
0S9e,()=>D503DK08S^6?S_LQK3BFWHO@=?>AKNE@I9IZNPa1afaR8b]KD(=U\\E
48ERXRSV<\SRKaHGBN;^Oa]<?>5V36OKU7S@IRQ#[F]Y-98M70U[FZRTQcWRNXb^
?WM\?(Se:9WTO/Jb4@>8Z\bg2NT1>K.;2ZNBTe-\2f8PX1Ve.bLP@BJQRPO(0TAR
R4B=gfKHDBG(:1Jg/>/7gb28T_fHFc\U]CD)NX4HCMg@_S>JD<UdID9:YX6._(-E
Q,+25C07G&&E+\^XD;VT#PAa1NBeIgc7T[[WZ=cXF=)OG&,<R]#\#P;M)R58YQ6-
MbVPR[,2cX,f]:LGB#3f088:V6d3M/I+^SbcQ)@,8b_5Vg1-VUZV56W>M]6GY[[>
E1&P&afE5E57/\1=Y#=41H;)ZLV]9^:O3IO+7MM,M&3Q^A&=E</>B+\d)8(3a-/[
EUc=L0C/T)-^\G3U.<e1GUOWN:@SMH3c#c6[W[,>MC&C:C:X0aYfd@AaRLP3O(I=
&RSCT?RQ\M:IV.]c5=/CF0KE4JgSf1E\F_1If7[-\c/TGa&IQAZNbSU=B,<;:+\N
b)JBJ<HK)IcQZ3^&]:SdT\<eGN&gI.IcTF_TCS(=8f80,V4]a#HPJ7F5T?Ladb@F
MD5D7Dg\J]:K<0I0C5[#]&>XN\IY(;6O2Y^XWPK5IOB9b>K=&K5=3ER>aZI9A37V
K_D<],+ZaMK0,1]g1,0<T3=I7@TE\@T=7;<M4Q-daKG2\NK3^9aJf=;0?FJ)U24F
Fd8PX.P3[(8OU_OH_;B_^VQ(.b/+/DR#IaI]\9L>682_bR-O@eHeW(Ja(PaPJSFW
Z9g\aQV-52Pd.J17DeF]-5;/+@+A8G)I)CXBX\FY[DFE)@IbR6b.0UZ;#b)25Vdd
L_^6+c>TPGO#T=BNe##f)K:e+/A>]c-3/I[IV).=YN#4[G+G_)T1T(?cR^GYAZKX
5-=+0JRJY5@@NBbDN/5.E]Uc\(.D/.T,.g.8ZdHf3,^CD((Ca5=^/2SaALCH=-Zf
>f#RE7b];gReR4J;I4@7:_ed44Zb6O46,,bK@XbAf.X=Wb?ga8?Zg8-C:fc7K,<N
?GgPE]G381HBc=FY_[a>3-TJQRRZ&2RJY&(Oa&W1BK\3LZ<Q;FOZM.X8,DV.f\BD
g#LCRV_>@,gaY^8MH[QATP4bB_R4R?cgXKAH8KJS+[9V(;/+\fSPFHbNEH+^R>0d
_O433L^S7d.529]EcR<L<gJ9?dYMJ=7E0DQBO:X)&&fg4?BZ]\P:H)BD#E1(AR))
)+/-)L[9[4LXL_<U6+.28(17QL@I@@G[dD6_7S^.^4.,<Y8?;11\dV5/Q&=A3Sg<
GH9dFZa+(,AN=;f7gMZYA&#^ga?R:O#SE2Z1.TcQfaO#I#\6XJO:DO]WD9g>B0bI
dJ=K>=CS\M1BW[S]><NFWcXX<[T?Y1\I/=e>JO#a0&HEgL/PPf3G)9F@?#N/+8Zg
B3\+3-YNDQRg8(YCO0OK[T[-cN26/.E&CO6S171g@ZM>?RfE37c/Hgf31fc/R#<)
I#2a;XP1C9-)dSWgIX0C[^R=CC^)11>MeKgSTaXX+,ZJ&81a9LIL5\TfZaN/]^Xb
H?&:J6#94OVTWN2Z2HW,]LXEXPR,-DO(8dG1,O9N21f6_PQC_L9c?YfR6gPNL::+
\C7.JVe?1HJ?#eUJQ^6FVD[8\M8+LN]ZD[_WdQ[-d#+FK^[]9(F?OBFR<W\N;9/Q
.ND,1&5V^G9FSP047RVF[FR&6a0T\>X/28?C.b=g@EBZ_TdKK7Yd/IfQD&Q8FK7M
:GCfO2Z5)C@&e#d/OG(TL2LBGS[>+fT;9K)6gRfU<2>@gE,WQ5R:?YR9N6OKfKG:
1LOUN>F02H2ETN=^A_[RCUR7SHgVLdAN>25Xdgg=_ON#KSN#g.5Ua)cQ<217>-80
A5R9KUAe<.X>O7a1;+V5^XIBO)=#21-CS[^15F3\?>?SA@^U(K.K>_FJSIZ-&+G7
)Je>+7b@L7T438XRO>=5d&-&V9f,B6O?OJMcNf(TQB9a8P0LPGVS,MX.AXeE>M)O
-1B<Le)6;I(#;:L-LX[\4;CEJ5&S78#P7Yg&NIHP\CXZ]<eS]bK<Rc^_S,g7:Vd\
1U:9(3O7E<49VO,gT[U<NQ4DTYBW7_7OKNUU0(UI=Xf.<1,DU_B[\-bE6LMB;OIe
0Va-fSc3/BX@XQB811HaZD/8@=aJ([eU;-0PM[Y9L=Ba2ZFbYK7CP_J\0D4S3M><
[F/T:?BCWP&3KH@LT?+P3&WSTN8d7]KY2E.Qg7ZE6O3[/=Aa7BSdC)-R9Z(8VY(H
T+4FN:Eb<OA04dc<c[KTI<386?&ccQ.6A^[NFKW?=YXT+S4e.EP6Y\C<Rg<Uaca,
d^3F04VCOP;5b,7cP-B2(ZZY]A)Y#(fAAg#>gYZ.J4Pa3GH.)dO8EEJ;?d2e0BY,
gU[4Y,/.39RG\(L5@]4d(BQX;;LDcG2H(_6c,Aa>P(^dV<C5cK.RI=06USV;e0:?
3=HW9,HE5<;:]=,V8e@AC,)#5T32eHd3R^;D<2XL\SAYVEFM/WU:LAJ7(AbeI#d9
0;QU7V5C50>K5S0_^1EF]G.Tf>K-/3>Qe+,3(Q]I97@Z?(DcVb5I]/Of@V\)V),<
C_LEC2C(&1<B/=_a_,LKL]@QUZgW_H00DR8Zgc/?O])Y4F#8Nb6RfE)SAIO9==R8
+d8#cBPWNXH33(KZUS8;&]:Rd=cK+:>@XQf,,C16<4EGd@_H=gHQ^H9I:IWH?AT_
,:+,V_9\+cgH98+e9@B>CM3#ZVScTN0/5P4cSaM246Y24H/:feFC+\C=a9d;If9S
@KC3Q,B8WOYMV=42<\18,gdccB>,UBU1Oc5O&-@8A_0JXS@#)@Q.U@)_NZOD+_6]
I[<?LBTGgW]^_=>-KfgQb1XJFZWdCZ.EU,>7#W[b9gFd_V@B.CR^>_&#SUAgW<&U
0]_1K53J_f&NA;?B?c,LegQWRUSWN6fZOF^->+XeHgH=MaBB/8<.X2f@0IO:L8Gb
;c4CbICeT;1YSS39fVGN,CgB,cIb=RO;[U:ELT3fa_^M8M&6:U(WfL^fZ4_R:U?R
(D1\F7C@#a7^C/Z-81;gYX(S,(aVO&gT?5L^]Z8(=R_Yb2J>JdD]C2ee5bge0;0J
.&#aVdaNU]:C(c2Q5RKTa41-M6.c))EgbQSI[W.g25b(.K@K#;M#(W((JG-I,2MV
^fRW2B9a<7KP2W8-b2OR2GDWU=U-HL1(J4BM)f&Wg6\J#N>&;7\O.TE.&MS+Wf\8
BN;<G(AZQ1H92IeG>AQ8cU<_1CSU4:g-COI]:BS3W95IPWW=8#28Gg;88WWaQ7_W
TMa0R;]^CcLYY<e\T:cLC257fQG3JK@W_.+/Y@:PW2[HWS1N+1GKJcg@4PF3U_-K
/ZJAObC900WZ=T&NgDBYMf:A.<?V[/Q<)\R/0I.a78Z&[7+=NT0FA)F8?6[XbNW1
J(bCd?ZA]cQT(5gafIR_BY0S:#CGdYUX/?>6?_HLZg^-1F0OO^L4B8G3-=)ZBY^6
C1.O5IB)HWUU8;,GSY.a)4E#<Xc7bAFTfeJ-/]OSOINYcSB[,>)C&gQD8XcU)N\8
X8^XGPP7XTG6@L6,TdbRI.gfRU=,B7>YcTT/T6&E2,<AJT&(8c<&?\M]?X5730ZH
UO95cU<];J_W#B@O_6A8#ZP\G#78ZZ3(S3,?d#H[)GZ;9ef2I6Y4=7fR^DDEB6./
#RC[W-e,#JP;))bJ#)aO8ZH2HVfF>IAME8c)01XQ>#13GT6T<&]d&3fCTf1Jc.3F
.C>-1OV_#4N<c8MJ_E2C4T_=SebBaR;/Q0dP48cF^D:U0(;R#UVB14(V)F-Z0V_#
g7VPLH679O=;9G,N_e80,eTGe01PbD^@1[8_Z(>eNL+=J@0=]DCd&A?X1<C1J;</
7-8?;OO6f<aV5=GefcQ^9GNb5]G&LMKM7b6@UgQ+IK2_A8b2#[Sc2D:Q6^C67gGc
3cZLHJN9bZVZ]C0\FB-+3V[C&C:8C3MGLLQ]>gf;4Gce8YF)OOY)-5[MPHb]R2Y\
cZAEK^L/<()d&Dd#WZO=FRR_fFOTKSY)]?Xb,_g?3?/51I&JG@D&K@]OFVLQKRGR
OgDJf>f#51-6g2]1J&^OZE]S>AUA15D1.-\H&2,;Te/N3Q9P0DR^6Md5/3>A:ZLO
5<(S3dO7U>adZ/P0a)JJ;CH]AF,:M?<C8G&cg9gcZ9G9KZNMRRYg>P3+1&dQca2f
a-2BEX&IBDLS4ASYQOQ\4YIFec21>OV:DJd9X+3XCCTfd>;Qg#c@ITf49I/&?f/7
E#-K\IB,G?2N39Kd>#)GEUIQ-E.JJ1^Da,PK5/8F?<>9/.=cPD6RT>c:#GaIS\QJ
C->156I@d3_CJVC19[YVgAfIc-:?-[e2cB6_38DA-F3J\LM(-0I,@?cX)1d9PcQW
:Y^#J2;>5/\<T4U8XP@4./YG&.e/_60Q)a=1(=)0>6^/7[>/7Ca^3:\?CJ>4V#;N
d#&7RL=4+/(Hc5&JSZZR@JHWTF3@>51453eJ<N<#,:T?^SA-=R68EQB[c9:8KPE+
B4#PYNIQ,>/Q9g,g4ad2>^B<YE+Zf+?NZ\2OC=6cDG)JN+RB6)[:)E,43::bAK[L
,ZVf&-&ITAgW&DA8J^@-_8R:^QBS.b\C:7H6LVILR4DJ580<D0/fJ,H8E/KWG+Z9
590aH8N[)=_;>:CEHONCHaf)ZM^Zd,]Pg&RS2G.ETOODaW6RY(5L&;)S_E6,9#6?
V8SE2HE4;L_Q9;)K-P/XS,d],<><;gVI]22D^7a_Y47)KaQ^EDGR/:b<IbER(CNK
RF]6AMd)F8J/^\68^<U?#WU=aGBC;/)B6\S8A7\63a13R8b;f8fZUR9Z,1=Q7,)4
dcUPJNDU@B)CEP]F[>_PH5BcHIeRYY,FJEJIPGTI1Q3Ig3_,ZLf6RH:;X=f22M)Z
OF8^[3NR+XZH6eWOfU-\OeH@fUL[)1I43NB9WJQK.ZBA-C=Mg(;X&N@JVAM=++<K
P6I3YXFFEE\,9G-Y(\K8VWMGBFI2T(gfEM-C1V([/F7S-)254gA0>J9U6H]S6M5C
H168(feST@N/f_g>YUW)Z0_]7E/P#[Q3e@]EWe:R9K0]F>=HSWdPL\?DOW<L,,cf
>(DTEL1(K>81.RW.^RUMca;932B)Kf9?VHM<dZJ\BHGZ6=\gGbTIIBbaYcRW[.X?
+ZEU\:ZD#H1^XBD6:,^fN92e#[###F3868VGCEDH43-T74:D5\_,4=9M#H.>;K3G
-1.(_,_&;(BARe56R]ENX6Q>cI+cb?,>#&9Z_^NR=WW[BB9ZVQ&KL)4CZ7HQ_LB/
[H9A7/1KHe,3L>^[8Y+(@1fRK>_/JK^AR9.3L-L_MF:1^MOT[P?<#1IVLU.-N:D1
CNI=&Q(-A+Va^-e<AYF1?):<K^:>T0;aadC^MgV3A4aJ6XYY1?R3?ZKe)#1<GGEO
B>Kd>5VYcg>08>)&Z5]X9;P.8\_EUXDW]AH.cGI1O8SCf_[6)>)eX;MAM@<>f(DI
@7H;RLT^R(@g_2FB?95W54>Rb5UN#DP>Dg;^Y3G^HWgU&JF],PQOVFKg1^3Zc\Xe
60;_I7bc7?6&PM0Q=2c.XAXaT3O,gN)6IE[.48BfJ7b#dN1;>Y5W7#Vb8KKb#BK+
P]QeQY^4D;gD/X=5gGR;N3__BP/;Hb7-g->7_M0Dc^@D.WZ&#G,R(LcQc8K<\&a\
g9,FO[XGP)&eGE:0f,BS/S;##YWgDBP>H7L]JX(:eW&f7RE)-T#1Z#D@>/ALFM_<
-GLUDRDQ[dB6NA(:C6Ha=@DZ[:>DggG.@-;WWC7a#WS0FJ5>>?ME-0<?#@,/^ba2
a3bP]P]T;.6cNgB#2OH:BAfGgfeW]gL=aCELC62I8eG8D/5C2>Y4bZ1babR^+f7K
bYXRg<@D[F)eA9aOP^S1/_)2fC5]5Y;B=7X>M)S^IF?;IZ^S8HKXT6L^+0/=B<,L
&a>IARbY9gH(V3(0BD]G@d\aTCI?^YXcIaa99X1L-aRb32ILR_Y+Va_/aFAX^0E9
TGfY_.YS<QB7P(5fKBF:3WT/ZZVTF(482=<WHG,Vg=N,2[gIR^_L@S+Wg/_7=8_=
92Z[I6UCGL-0dT6(f,W#;ZW,D?VY#OZK^QD/>PO=,UTLB-.4JB:CcB]E3D7/Wa#E
I8J+#A7F;35FT3,NE+U](/66\Y/Q4Z)R5[^#QHb6c;LAVBXGBJYS#(dBW,cg>C^#
<NR)JH54Q#CAC.ES1ggR/_IYUJ)eC1GJPcJIAZ:Y?K_BIgLMM/AQ=-?d^:VgbBB?
LS6YSE[2(CAf]9AfQIHBf0VVEWL35RadC&P.0/LA:V,8PEA(CPAW2?eQ[34HI6WB
.f^#bU@dN?J67YcN?>W=HE,^W1OY^<4R>f#6+>(TNGQ_eV)FaW+8V.OP(GcU<KOJ
@BF:FD[-X<eRXH+#VMD53XR1@T&2RW-^dGP\WS&@bG)<JXFKQ^IDMD#[?>H0@<N[
?9\.WN22/>W+0NL<Sf5B8;AaJQX+Q]DU#UbMc+2OW+SW?<eH2d8]35Y+Wb])I2VO
-N<cVZ7TF#9A0.eVX8=VbK<Df/79P.g.^:5ILNHUfBc<ZQ[,CRXSZ]EPC(^bB7==
P-bA_]bY@(fQ46F;bJD&-:2G@JAR]77FZK3DO/eUQ90S)>dF:9FUC>__,DD=N0NP
O+ERV]?^PMNTO-V_cHIV>a.M2/dE>H=c[YX&O9RQ@_S__d;?bM>=Q^UGEcZ(>X@2
d/9B@+#FE(<7(&R</H;G)ggYQZ@2Q,L7fJJ0TL-^)I97]Z,/f&8+Heg28GC2>RQV
GFHA>@R)5_BcASG2+C;d1M.:.aMS:(Dd-K?CgPD86Q;d8[&BeG9C5M[^Vd9H.d#H
+:@D+PPY2JXYPV-UX^39K)&Ja.6_#Z>W#I[PL+e3HcWee3]L7+<@YG_&?:(Ra?Oc
U)^<S0[,g[#<C(J#1CDXg.7F.C2Q[9JB1\,)(]g0[gMY)(BeN]#(cVWg>5/eEC(-
fH;<W07(PD]768RBF3<NS9B@0D/[08@V+TABWZ9BE&W49BJ;;Z#TPX?<ATJ#L;QA
:?QPK+T(N+GR@7E;N49MM<LXL4:M01YM-?Je-N,MJ8Y)<LIFb&.:C^.,Y2(#CbG2
&@&Kc+bZ,cI/f?Y^e<^RAH=^#=N5;E,5<(:)M;5XY.8)2\8]f[+#/EKf.39c]0]A
SU6D/9A1IT\N&?73Y\QYO/BOSe,9P5>,Q6WMO-++]O7AUWP_>NJUDY.ccKX1QP+B
O\c?4,[C4O;)KbONd]@\N&Gg_V4K3(SK#0:AdMU,WU96&gY/HH8H&YS0=GR\6/SN
6=^f[?2=N?&(6>MRY8+7CPU[9R47_5NKWV?B7JCMK\@4F,Y<+.NT5(\?Ic<2A<Pd
H7Z)55@_<M)\SDP:QO.D_7P\9Q3PG(73JW]H?K3-,S?:#^g1/L3#-G_526S^=d))
b><H5OPN3N^);5XFK@1P0AE8IZ(Ac7E,:f-HC:S?^>_IXGE<GbY:Y1<e<IJ(909H
;MH3O9X/4_09QRDC]8P;8\A/TDWA(\cH=eHDD:[J>@#>(/T-RC4GfZg[I+U(92LY
WFTdDYS:WXA+aa]M\S.B<M^VJCc[A&f#>:<-^\V&Ze::V-O#???],?IMFD2bU-3K
TZ;\CBEaV)VY8)E=_:89_EOV:#,AYNX8a^g[.TK)<6?-3b=2JK0=QWd/G).(X7d7
,;4,B]5e+#3ZD:.N\#&+M)##e8P]dF4\Q.f&]S.:NRP;4D54OF[=B(/c&K^PfZ8C
/)N?NP2=2fRdaRg,N+]L.LL=9^QB/1GM(&Xg(DD@)Q/GSR8(LP<56CaUO4P90P[K
^ORG:d(J3H_=\M&5(a8a@KP8J3?ddb5+Q61Jc5/K]Z4bf+C+WID5X61/(P-:JYZG
U<f;]D];(.=de?0A0Rf^P)Ue3d>.e,&INMaH7BS1IOX@CTcUK;EGOe581MX_:-E)
)M7QYg=0ET9//(<.F]AA3HYRU:N7)81E@$
`endprotected

`endif //GUARD_SVT_TRAFFIC_PROFILE_TRANSACTION_SV
