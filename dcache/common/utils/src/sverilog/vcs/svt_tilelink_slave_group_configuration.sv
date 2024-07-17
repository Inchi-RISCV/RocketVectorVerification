//-----------------------------------------------------------------------------
// COPYRIGHT (C) 2016 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------

`ifndef GUARD_SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_SV
`define GUARD_SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_SV 

`include "svt_tilelink_defines.svi"

`ifdef SVT_VMM_TECHNOLOGY
`define SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE svt_tilelink_slave_group_configuration
`else
`define SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE svt_tilelink_slave_agent_configuration
`endif

// =============================================================================
/**
 * This class contains details about the Tilelink `SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE configuration.
 */
class `SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE extends svt_tilelink_configuration;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  /** Used to set the buffer size of a_channel buffer in slave. */
  int tl_a_chnl_buffer_depth = `SVT_TILELINK_A_CHNL_BUFFER_DEPTH;

  /** Used to set the buffer size of d_channel buffer in slave. */
  int tl_d_chnl_buffer_depth = `SVT_TILELINK_D_CHNL_BUFFER_DEPTH;

  /** Specifies the address width for an agent. */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] addr_width;

  /** Specifies the data width for an agent. */
  bit[`SVT_TILELINK_DATA_WIDTH-1:0] data_width;

  /** Sets the memory base address. */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] mem_base_address;

  /** Sets the memory address range. */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] mem_address_range;

  /** Sets the base address of the FIFO memory. */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] mem_fifo_base_address;

  /** Sets the range of the FIFO memory from the fifo base. */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] mem_fifo_range;

  /**
   * 0: disables all kind of slave side delays. Slave a_ready and d_valid will be always asserted for any transaction. 
   *           1: enables following slave side delays:
   *           All types of a_ready assertion and deassertion delays, d_valid assertion and deassertion delays
   *           slv_vld_rdy_delay_en & slv_cross_chnl_delay_en  shall be considered.
   */
  bit slv_delay_en = 0;

  /**
   * 0 : valid-ready based delays disabled. a_rdy_2_a_rdy_assert_delay[]  to be considered.
   *           1 :  enables all valid-ready based delays enabled: a_vld_2_a_rdy_assert_delay[].
   */
  bit slv_vld_rdy_delay_en = 0;

  /**
   * 0: disables cross channel delays.
   *           1: enables cross channel a_vld_2_d_vld_delay.
   */
  bit slv_cross_chnl_delay_en = 0;

  /** minimum value of a_ready to a_ready assertion delay configured for any transaction on a_channel. */
  int min_a_rdy_a_rdy_assert_delay = 0;

  /** maximum value of a_ready to a_ready assertion delay configured for any transaction on a_channel. */
  int max_a_rdy_a_rdy_assert_delay = 0;

  /** minimum value of d_valid to d_valid assertion delay configured for any transaction on d_channel. */
  int min_d_vld_d_vld_assert_delay = 0;

  /** maximum value of d_valid to d_valid assertion delay configured for any transaction on d_channel. */
  int max_d_vld_d_vld_assert_delay = 0;

  /** minimum value of a_ready to a_ready de-assertion delay configured for any transaction on a_channel. */
  int min_a_rdy_deassert_delay = 0;

  /** maximum value of a_ready to a_ready de-assertion delay configured for any transaction on a_channel. */
  int max_a_rdy_deassert_delay = 0;

  /** minimum value of d_valid to d_valid de-assertion delay configured for any transaction on d_channel. */
  int min_d_vld_deassert_delay = 0;

  /** maximum value of d_valid to d_valid de-assertion delay configured for any transaction on d_channel. */
  int max_d_vld_deassert_delay = 0;

  /** minimum value of a_valid to d_valid cross channel assertion delay configured for any transaction on d_channel. */
  int min_a_vld_d_vld_cross_chnl_delay = 0;

  /** maximum value of a_valid to d_valid cross channel assertion delay configured for any transaction on d_channel. */
  int max_a_vld_d_vld_cross_chnl_delay = 0;

  /** minimum value of a_valid to a_ready assertion delay configured for any transaction on a_channel. */
  int min_a_vld_a_rdy_assert_delay = 0;

  /** maximum value of a_valid to a_ready assertion delay configured for any transaction on a_channel. */
  int max_a_vld_a_rdy_assert_delay = 0;

  /** The outstanding txn is the number of txn that the slave can receive without sending out any valid response. */
  int num_outstanding_txn = 0;

  /** enables same cycle response. */
  bit same_cycle_resp_en = 0;

  /**
   * minimum value of a_valid to d_valid cross channel assertion delay 
   * 	  configured for any transaction, against specific memory region based delays. 
   * 	  Corresponds to range indices of proprties resp_delay_base_address[] and resp_delay_address_range[].
   */
  int min_address_range_a_vld_d_vld_cross_chnl_delay[];

  /**
   * maximum value of a_valid to d_valid cross channel assertion delay 
   * 	  configured for any transaction, against specific memory region based delays. 
   * 	  Corresponds to range indices of proprties resp_delay_base_address[] and resp_delay_address_range[].
   */
  int max_address_range_a_vld_d_vld_cross_chnl_delay[];

  /**
   * minimum value of d_valid to d_valid assertion delay configured for any transaction, 
   * 	  against specific memory region based delays. Corresponds to range indices 
   * 	  of proprties resp_delay_base_address[] and resp_delay_address_range[].
   */
  int min_address_range_d_vld_d_vld_delay[];

  /**
   * maximum value of d_valid to d_valid assertion delay configured for any transaction, 
   * 	  against specific memory region based delays. Corresponds to range indices 
   * 	  of proprties resp_delay_base_address[] and resp_delay_address_range[].
   */
  int max_address_range_d_vld_d_vld_delay[];

  /** Base address for memory region specific base address for dvalid repsonse delay. */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] resp_delay_base_address[];

  /** Address range calculated from memory region specific base address for dvalid repsonse delay, corresponds tresp_delay_base_address[] indices. */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] resp_delay_address_range[];

  /**
   * Base address specifiying address spec that wil allow ONLY TL-UL type transactions.
   * 	  Corresponds to respective indices of ul_only_address_range[].
   */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] ul_only_base_address[];

  /**
   * Range of address specifiying address spec that wil allow ONLY TL-UL type transactions. 
   * 	  Corresponds and adds to respective indices of ul_only_base_address[] for range of address.
   */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] ul_only_address_range[];

  /** Base address for memory region specific base address for denied access/executability on d_channel. */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] d_denied_resp_base_address[];

  /**
   * Address range calculated from memory region specific base address for denied access/executability 
   * 	  on d_channel, corresponds to d_denied_resp_base_addres[] indices.
   */
  bit[`SVT_TILELINK_ADDR_WIDTH-1:0] d_denied_resp_address_range[];

  //----------------------------------------------------------------------------
  // Random Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Protected Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Local Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(`SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate 
   * argument values to the parent class.
   *
   * @param log VMM log instance used for reporting.
   */
  extern function new(vmm_log log = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate
   * argument values to the parent class.
   *
   * @param name Instance name of the configuration.
   */
  extern function new(string name = `SVT_DATA_UTIL_ARG_TO_STRING(`SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE));
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(`SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE)
    `svt_field_int(tl_a_chnl_buffer_depth, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(tl_d_chnl_buffer_depth, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(addr_width, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(data_width, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(mem_base_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(mem_address_range, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(mem_fifo_base_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(mem_fifo_range, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(slv_delay_en, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(slv_vld_rdy_delay_en, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(slv_cross_chnl_delay_en, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(min_a_rdy_a_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(max_a_rdy_a_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(min_d_vld_d_vld_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(max_d_vld_d_vld_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(min_a_rdy_deassert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(max_a_rdy_deassert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(min_d_vld_deassert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(max_d_vld_deassert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(min_a_vld_d_vld_cross_chnl_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(max_a_vld_d_vld_cross_chnl_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(min_a_vld_a_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(max_a_vld_a_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(num_outstanding_txn, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(same_cycle_resp_en, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_array_int(min_address_range_a_vld_d_vld_cross_chnl_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_array_int(max_address_range_a_vld_d_vld_cross_chnl_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_array_int(min_address_range_d_vld_d_vld_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_array_int(max_address_range_d_vld_d_vld_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_array_int(resp_delay_base_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(resp_delay_address_range, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(ul_only_base_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(ul_only_address_range, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(d_denied_resp_base_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(d_denied_resp_address_range, `SVT_ALL_ON|`SVT_BIN)
  `svt_data_member_end(`SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE)
   
  //----------------------------------------------------------------------------
  /**
   * Returns the name of this class, or a class derived from this class.
   */
  extern virtual function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type `SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE.
   */
  extern virtual function vmm_data do_allocate();
`endif

  //----------------------------------------------------------------------------
  /** Used to limit a copy to the static configuration members of the object. */
  extern virtual function void copy_static_data(`SVT_DATA_BASE_TYPE to);

  //----------------------------------------------------------------------------
  /** Used to limit a copy to the dynamic configuration members of the object.*/
  extern virtual function void copy_dynamic_data(`SVT_DATA_BASE_TYPE to);

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Compares the object with to, based on the requested compare kind.
   * Differences are placed in diff.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted. Only supported
   * kind value is svt_data::COMPLETE, which results in comparisons of the non-static
   * data members. All other kind values result in a return value of 1.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);
`endif

  //----------------------------------------------------------------------------
  /**
   * Does a basic validation of this configuration object.
   *
   * @param silent bit indicating whether failures should result in warning messages.
   * @param kind This int indicates the type of is_avalid check to attempt. 
   */ 
  extern virtual function bit do_is_valid(bit silent = 1, int kind = RELEVANT);

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation.
   *
   * @param kind This int indicates the type of byte_size being requested. Only supported
   * kind value is svt_data::COMPLETE, which results in a size calculation based on the
   * non-static fields. All other kind values result in a return value of 0.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

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
  extern virtual function int unsigned do_byte_pack(ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1);

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
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);
`endif

  //----------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command
   * code to retrieve the value of a single named property of a data class derived from this
   * class. If the <b>prop_name</b> argument does not match a property of the class, or if the
   * <b>array_ix</b> argument is not zero and does not point to a valid array element,
   * this function returns '0'. Otherwise it returns '1', with the value of the <b>prop_val</b>
   * argument assigned to the value of the specified property. However, If the property is a
   * sub-object, a reference to it is assigned to the <b>data_obj</b> (ref) argument.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * @param prop_val A <i>ref</i> argument used to return the current value of the property,
   * expressed as a 1024 bit quantity. When returning a string value each character
   * requires 8 bits so returned strings must be 128 characters or less.
   * @param array_ix If the property is an array, this argument specifies the index being
   * accessed. If the property is not an array, it should be set to 0.
   * @param data_obj If the property is not a sub-object, this argument is assigned to
   * <i>null</i>. If the property is a sub-object, a reference to it is assigned to
   * this (ref) argument. In that case, the <b>prop_val</b> argument is meaningless.
   * The component will then store the data object reference in its temporary data object array,
   * and return a handle to its location as the <b>prop_val</b> argument of the <b>get_data_prop</b>
   * task of the component. The command testbench code must then use <i>that</i>
   * handle to access the properties of the sub-object.
   * @return A single bit representing whether or not a valid property was retrieved.
   */
  extern virtual function bit get_prop_val(string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);

  //----------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow
   * command code to set the value of a single named property of a data class derived from
   * this class. This method cannot be used to set the value of a sub-object, since sub-object
   * construction is taken care of automatically by the command interface. If the <b>prop_name</b>
   * argument does not match a property of the class, or it matches a sub-object of the class,
   * or if the <b>array_ix</b> argument is not zero and does not point to a valid array element,
   * this function returns '0'. Otherwise it returns '1'.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * @param prop_val The value to assign to the property, expressed as a 1024 bit quantity.
   * When assigning a string value each character requires 8 bits so assigned strings must
   * be 128 characters or less.
   * @param array_ix If the property is an array, this argument specifies the index being
   * accessed. If the property is not an array, it should be set to 0.
   * @return A single bit representing whether or not a valid property was set.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);

  //----------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the primitive data fields in the object. The svt_pattern_data::name
   * is set to the corresponding field name, the svt_pattern_data::value is set
   * to 0.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern allocate_pattern();

`ifndef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * This method returns the maximum packer bytes value required by Tilelink. This is
   * checked against `SVT_XVM(MAX_PACKER_BYTES) to make sure the specified setting is
   * sufficient for Tilelink.
   */
  extern virtual function int get_packer_max_bytes_required();
`endif

  // ---------------------------------------------------------------------------
`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(`SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE)
  `vmm_class_factory(`SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_TYPE)
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
.Kg;8d=6&-<;XC&6NTbV8.R5R__Jf+ACZNR967[O6dbQG60,B@Z(.)N52C9/D1>Y
>_Y0E;90O3d(H&#Vb#W5LP>gPWL/G,F-9:F@ca@AdL,I).M>OCBRa_<]]OR;[J>_
)[P(1JP0KbQ_aDc_&cJd\F]/#04,UKgX4ZOQLe06>C(NC8N,]JU(ILXBD3+-7))E
[##9A\LD@I5g::9G3@C)]a^ZeB0&(^bK9O,BBdf+UEgISO(P]6)_deF].e[+KRT;
50U6-@;1ENPgT,^(;J=Q6QePSW;?[I<7SSOf_2U?N:Uc(KJ+RCULM9MWeAb+cV+,
MM_B;TR:0UK6WSOOb>WO<QK/G:A5Q,F0ZdR]BBRfbZ/J&=D\#>#0\1?SAY)^O,V)
e5THH]-]0I-VH+H0/Jf[N&MT)bBP0d7H1AFK)F&L?9@-S-.Sc30>CS1UDcQdUVP&
T3B+G1C)f1f,#aJ.<T63cI)3Q<2X(L\HZ.][MG]-.CSeP?ffMLg#g5Bfa&2J4=f)
O0([YYL#G^^g@8YXd0TW?M#?=F.F(S<G4)XIeV59\Cg]bI=<Rd#3f3NY]WKe@e8,
/6VY19#P717G3(72Z=K9J3;cUBd42QO+P>cRJ6F_8KKeVKQ67[d/?HCX2CHEg7b4
7f?cce]->VTW&JA523H3^GZ])N_T]JbA;>XY>YFc4D;eF$
`endprotected


//vcs_vip_protect
`protected
#=YG?6HTW/NRUK-Fa2):/.eVEc^aS.,FS;GV7BO-e2<2EWUcX,_e4(NFP#XFR2]B
c3I6Z6HEb8]5g6#)+IQ:b:_DGBR(S)H2#CWW7;?IHZEU.FM7gB4TQQJPfg/J@?+<
M0FHgS=M(T/]VLP6D=Y.8BX0:S#L[:4aP[B@)C7^(/=DV8VL4H]);=b-^gcf4gDA
EEI9#S<:/[[5^NbRG]4J]B>3>AG7YP5EaQ2=4c23FN/OF]Lf=C;[CfVeXGSWE82S
T4<LEH4EQ41K<dHdLbNW@.P3GggC(PDK]-1?cVJXQHS?8I>dG218&BDVHSYQ^PbZ
H,#_XdK@aUA+7=.&SS7>AEgHU<+^_CBdZ1:(d(&Mg2A7,:ITCLJ.,YTHGa[]Y[SJ
6deTeeZV4I=D;&:Q<A#S_Tg)Q2=CK6M^[OYf,XE[5eO28N,7-I55;ZbdQ#IU@g=X
2XN8=#O/(aW(gF3:OH+503]Nd4N8/:]HcAOMRgNg[X,?F\@[^2Q7+-F#e()g#N+9
PVX6\dW0QcE89H[c>B9;B39WYJ_4#-D98I+d<:W74UR=OJJ;KTBUWT1(V0W;)1O+
[?]D_)+ODgf8bN[H1&/BTHMd]4=d=gD7IAf1-:;(??U;):J7&FW1e3KLKH>GdTB0
(I=S\QV9Y&)92a,Q4WJF4[,(S(/]b5,\F@^57_5ff7a^ZA=SCNSV+S&QNLWR[=Qc
F&7e#6\G/9EUL?GT(]D?aVa:;I0XS+Q:=YF8RK=01M6A8>J&S[M<d]XY\49Xd.f@
;R,f.;/5@A0BGC.Wfb>&B#.78EdT9C_;>Z0H3\SL7NaH_-W;)C;Z5+XLH?+@(J]6
=9La3^XOXKY>0BO.P8R^fD_HI>K_NZ]\bQH?WDZ=#CVag@LBD^a^cE<A9\.RF,^1
/OTTPORR:-]=SCOG@DEZC0;78#?V<,C<[CV>46/_4PSN-Hg#f67S425ES-PTB\94
(YF9DD:0cL^?NR8X?UJC)[DO^eeUIfC@^MBb[79c-e\,^F=@I:<FT9[-)e&;:aVE
ZP3ZN8,&FE_@1A@XY\]J(2L08CWF>_/[1;3V9fM=AQ4^cMJS1A/7Ef\K,GJ-4SP_
V30VC[AAZ=)7F_OH-#:(1I>B^cf@ed#I>ID8VGGNaFa\EPW\V7aRS1VJ4?6F8f3d
(?OaJU^GU))+549+>_a&4^-c97/YSfUc[VC4#IT1YPLT4YO4UCNaU3Pb,D4:>TO8
L-)5V[Vg1H0gSA]3TIZ#RVP1Zc1PZXLHM<bLF>=BGT\]c=cc]U]ZgVU[P=BSOaFC
.ZD_QTDf#ODV6bO@R\9-3YZFgRRVDMRV@b_=>ORMT@5Y<b4R34I^HK>-?NU&O7-2
/_O.1NgM[?fF^dHZcD9HWC27)H=F):=R[T\4;fKE:?eUMC,68CPMYe[8Z05M9<&c
9b,4RaOI9XS<;c^55.2VbPCF,@9\[U.4<RUF=O.Hgb(DIR\f0f)N1e(4]QEeOT#3
Fae):K_aBaPO_IG,+:G8bJb:VLUgZ#;43dN+M/g(AR?N&M5WAPedH_9R:#:B52-A
IBP3.YHDI+TLXLC@0K2,<K[gTGQA<1I_E(c7b=[f#&9,L7N[@b]LC#A&8[&@T(f[
-V<HSc5HFEP5K:0EY9-TH\-00Q=S(2P;S9UMJX+VYW:,CK;f+5&K7da:A5[K/+?H
0^(+IGW(e5aIYS->X:A.L8YcF^gC7;K^gcYKO;H4QG#_FO-F)20=4ZT]Va=Z]RCG
8V6c4/aFY?YI&NJP(GeOO@P+f+@4D3(0TC(YUM+U+OX[7@fePJRS2TDI#?2^\P>[
V1bP?2,Ibc0bUDgV?E[7?=&6)_MH=V^;e8eWB(1\JB8_#Q2-O83U#2#VBM\.IL9V
CaR9.4TV+>+?QdDH>4KN=E/=)Z<EK-[:M,d4f0cK#cUR@=<[1\]J.LEf_R-3<-YC
R/072dXF0NH=9;S&bJ.E1e^UI0fONZ6),T:5<G.65LM+cbWN<Q+LKaLOUM&9[MK4
Ic93Y6J\AWF5<LE<=+-EQD(eEMBEG-eVQ7d_VfDE+O,_B4?6]3MN1[.U([>RKRLQ
RPY/P]bDC;ITV2J:]c&[cJ^.GgL=2/O[#0a.2X9_1_UE]/+9eXX_Y6?2HPP:Gd1N
U(]E4X6ZKQ_X7Q_TC,=eV_dC<a&_;=M_<&IQ+<gC=:9@dF6>Ne@e=<TI#YEAI_@(
@8.QAK<Q+8&M?U(c1+/]MdCf#OXe]462+AZI9_R(15[.;(aDF5-:KD;3/cT.fH+9
Jc_d5d(/)8[g3e+_UXHcPHHWaNDf9W^gd:MK>FEES=BECbK/78H@(U&-OSO.GbaU
.PJeU@><2:9NbJO[N(NBG1YC0.@[Z_+RA9\3<WCVf7Z]U:=OG-2S=V1aC8O=T5f3
Fd<IHcGPg#dHMTM_RU=?0O?f-NKZ=ABVV#9c>_6Yd7N[Z+APcC2f&Iec7,O=EIed
+CG\Yge+2DWV@D)0[(L1>7fQC3e@78</4&(URA#8_^2+A\W(&9U5TC6&T/((5>[O
bN#M=1@NG;Fd4,S\2eF?Y7=#;/D2)aPf)F;_-e?bMP8EMZK^Z=7Xe.bHH2><K6+[
c,aEF@:TZL9b<LLg\B[b?].P<.42S4[FHS#J8W/X]XdgSdSCS25UK1CXHX;T(@aA
B::FcEdHM51-J).ZG\A2]B)\6ZZ?)a\gYC8@CfedCba,IKW9&F_:K4<R-K/HLI]2
O,a@CLYT1T]aYNgHGJ[)<U<e\NOVLQGbJ0ZedH(F\?Z99aeQ<@W6_^f:74#X8:W4
/R\bM9a?)I/<W82A)OOdbEZFTMQbD75H08F?IC[>[2(\cYXY(&BA9)M@J&aW;5K3
\?\^VQW-[LU9TF=97WPg/NPIeFC+[3N7Yc(KIgN9U)^?5WAIHZg.<9S-[MGWD^8A
1H5fZ,b?cV(FT5<_/3HH+8<1XW@BU7UD24H=ZK8f#0MNcHKTcCW/ade(W@bFSV)A
>>W\:Wf>L]6;fdJKADOfZd>_JfY+OCeVELbOIaBVU_#a7&a,4Qc1&+#)J>-)]6#<
6>QCAR7@M.-59IC^?_U-Y0TP]V_<^4MNUd5+?f+W:#BAFSSLc,CLDUFMJUKgd@gK
>9MW1WL]O?G3WNa^&>Dg)#^(NVJ]X<(6UB8:d&d=>[>S_bf(fU[A+3R4KAJ[6V@=
/T:TAef>)7<3F^>>KK90,3[#LLQU1EM?eN5&XQ36C5@Z^S#7XK=.RDRVOSKPDW(R
LHW&SK@)Ra9N?WP4DEGKM5(3daL_VdZ(LSQdfMcC9:&4Z(GQ^HQ(B:WfZDNP+[_)
3H)+JN640b0HT72;Xb0;5)<gC01^&)3FSY^:(A<LTZ\)Y8E,=X&aL1;g<&)Kb)K^
MdG_7e1V<..7QEW_D<G?0HaESO\\)0KKG9c[EL3fTd]6Sd4Qf?@.CAM.RW2\c0)B
GW3HHBE<6QZTUAZNfLZQNG6J,<H8VXdU+Q[D&WMW:<7;fJA,HQ8Xd#3&fd7D<UOc
a.QW)63]=L;QXf3:U9)d29.)a]1GJ[6S&UgHC.4:5eG_O&/,2b5Q5-7MJcN12X>.
4aCGd=H:bSXASZ7M9X)b]-PI]fXB,^V9EGQ<6\YR0.<XZ?ff\f;D6aHLXa]>H&Xf
+&A[2C=05R@R(BH^=2gH)3UY#BHW3CQ\2\FS_KQ[JcLg.Z)bLdc9CB59+Faab(\0
/G(A@ISQg_T_#aQU(7C02&Bb:UU\?2Q2&<K@J8_^OP8-cgC0XO3=54,ZF?cMfW(d
b0.eY&80T+A:Lb.N=U6]5;WUVE,<)>6bMMJ@DY;WFY_feJSREDB,7C]/SSC^+b2P
EI,=H24X.X;cKDOND^JQKANKH+DgD]SJ/6XFW@#B=eP/5;7\1G7:R+F9WA.0FGAg
OE?CeB7\8ME2B3).AK-7C^QV?.K5dg@=f0UbX)9ZXMR@\=gB(M#g;+2TA)gUJG(S
J#FS]GAeH&BDL4&M<OD?./T[_+0JHS05B)4^F1;ZcJT0,DO2+BZB:<F3,/b,g4;5
=a(SM>QDO]K90.Q-WF-J<:<9JdOC;EA)W;&f[(]<,:1aDLZcW2Zg5b]]E^c0PeGZ
4RKcU1^@<f6@AafBQT2MeC]b/FB_2[3E:(g^BV1+N;Y>L\NW4P84aE=?Q6&KZF[V
I;NL;X#;7Sg-^ZW/Rd(AGCa9^?3Q3[5,8H],YG5#YC](;(XRK/1RFNK(Z4<T?&:[
UfB?:I+W_Y4F>MO#F4DLGgP7@g82bJe5A)gE#A>Y^-WH\3EWP9-2-+4//6DF/2f;
SE+^)Z^QUWC/TL2dPU#78D_4f77Hg-QTGCO-]\MJ8f(AdW)6eSR1K;VLLb>2=4Ue
Mfb;7V>cJ:3JBc,aJ.WD8GNH;DR]?AA[Ua/MC=N_fc2I^;a/J2?X;ce)Z<d(DAOP
O1GdEcL#TW=<MN0agPaAB=?X+\W1fT,^GY1SG@NCSU9Y0.I1Z&/Lf7dgX3)fUcdg
2cM[J22<7C#.H:R+B7gJ>fEKFYC7c_Q,1\?IaX9-^<B5:LKJb>B:M@.T/^IXH[Be
f0SFX+85eS&3PGEXcdA06:?)#^(_3UD#DNFf><fgWQ;YXYQ;&GJcN\(MCCScW@MR
Td@H)gMQWZd#E?N#c352H@621I@c7]E9SX3I7A<7E?L9c>=a0;4,dXc8K>c)_-0N
KbIPXN:IQ^_4Eg1D>HRIY+acUUP(,T8AAK_,B#TSQNJG_HZdGcK0fCg..RaNZB(?
Y05)eXCFVAKPgfJ/SACX/TV=HNA[CKQ+X8&@1DGC<]]HQUK,[PLDATG#.:UdQ,S,
Ib3,-McMYOA4-XWSBLU1f<6#bV#ZZ^8Kgb@63ZDM)dT^I[#bH(0XNTPb^B86:+F_
;2J(2Vg+Y8=VfE.YVA)c(Z9K8J37AL(HSF5=/(>KO;.-Je97b#LfbDLV>E8]NK@[
Id#+fBS(G7:/^8.7ISaNVf=:_KC:8]F;UP^^7\FAD:5-WTRdP?dadYVcNER_e.\d
I\AfP6TO3G=^W/4=>42#^f73TECe5:>QZR4CV87a6P.cd3aK^09C+H2<L.G^3=^4
GK(8E?0BRWR+U^VZXd\NMVW,F00d/@M@3+R4T)8#2V5Yc_&A:_6L]b5B3K\cKg#1
BL0S=[ecH.+cA/&0N+D,fB5B#-F@6[:]:bVAU+8GYGEZPEMF(1@bM2Y&#6O_7^Mb
W3[,+L+6bC9Y3,_-V&?KY;]QX9+J,LfbW:f53Od7ZA.9f#\LS4H\Ud:-I11ACD(L
RR_=V8;I6-5/35O93T>]bTWABDfPV;?)-?LG60Y660?ZA+6ER?RYM]@G;c;e>2TF
/80]8_2d]8C_+fCMJ[f-NUA(PD&F1UbM[YHLcPS/,A;L)@-_80D>V(;,V7[1S&(=
1+B,?7dTBXH:e.g<FAc-6-W[DKLDU->I(<R_N)E7F)(?<Tb:M/I;B<AS<<ZQ>RL7
Z(5)D#2<A(U>Cf<Y;5#eR^]FU?Kg+>eI07HVF:+Uc:]6+?,:JRD-[7Ad.5A1]1BZ
c)L)7IZ.DdeDX(A(--AKSLS?IJ8.(&LHc<TGW@J[-<MHNR?JF;M[&RO4AOWg+\)M
[)WVX)/bcB@F=?MN;.TWOGI#Y(F[:fD&Q-&?BY(3a9,7e7CP,=9^)G6V,V^Zb2b@
>2VgL.@+J,gCB#A&O(<1&=5-32[eEeL79>a#1,<cDa-/C,S)3/HU?)b\@]fDQ(5Y
DKZQ/U)OP@6?\D35OI_E^?#7Nf=GM_cYa_LPE^dSeW]GBZZ/M8-KeUELgD:>1ZT[
Uf\#.\T4&AMeT2TaJY0>.T:Ncb<=\8L#A[R0IfD.Q0[^3AB7g+NC@gQ8_af\I-T/
0J4dY6_^?],6\6)@OOSRg^ALf9]?ec,)7P_OEdWC6O3;QBF\0QGPVN6(c&6\[:bb
Xf5JP:-WP/T-LO.gLTf2BeP]Yd4P[Q[J&:U(Kd@TQ]gWaU5S)4>.KGWZCNO]O]T1
O=<SG8V+.V:3,6Od>:c-g,f3e1f,M:2?f]Ae,9N3CJb73]O:>9bWSb[U7:.5[YQS
3f\G[&fHaS]TW&+fQa@VM=G_UFf_S,NNgT::d]_A0&JRFPT_PC-.d+DQ1IZ;]7[(
Q<;I5@T]S1R9/CffV/)LbX?:f@P&)1D,[dE0)PH#.0+.g)/M_>U:gE.Y8BE)CdT@
<:@EX4+)#N71[6-4D/5d<77WA8UQE+7I@c=X(6VG@@[GI>aNZ/Y7gb^X:JISUHWF
#X-CC0.1OVJ#N#K&,MY:R/PV7,B]c5(dS:gIGCGHSLD_VW@NHY/M3=C3]/AERM2]
R8BC&X5NX2_+I:Pc=/XZ933][II,].M<KRB#ebO]b3Z@X#<DSbQSX:J+BSMG3@:H
A(QeBeJ+0?T,cF_J;ddQ4\1>bL)?N,W,V@5+\Q#[RgUY\IB:4NRZGg1.gN#<dXH[
,9TP(ZEI]E75.V^gP4fVM.2V_-03VE60Ze?VGB.00K?fFd_dL53Z\cKDZQ2,aPM=
eUP6dE]4_bPb>;NRf2aZK7&-UPZG=_\,19H@-J+)J()4D;R:(#V2N;#.W6U<TRQG
2EL>WP-H-[7SeLbR0Eb1&F1[J0RT.cD2Fa8)d@gK37LHdTH7f(P^Z33V67+^N(#P
L8Yf^Neb3.1>L@DDI;2ES:-E+f0RBS2U8261CU+<UZ-?2bLfTM4?#fCE5cQQA)ec
gg,04-5V]1>VJcHBDJ9:&NdI\+b?E.ENcYeg]&FIbbfE]P#^cZQg4T_S0V:072b&
>^cg#f=XbRZ?2O+#:)>E&]HY7NecBef.@^R.5>Q-B9)M67@O_-?3[2<C:cQBT+&#
\>eO^;(6]gR^T>X7Y<a#-a9X8JS;6fK+&POV_YQ0E55K-#G?@eMcL30J\?/#LEIK
T41G-38C[<+Dg+/AF<:+DO=G0F@e/@A1VC#9f(<<FT-I7b8O:25dTE6UCRgcL>g&
fDc+>02@1@L0YcgU^MF??gY:ZQe(95a0-UbKW]I^K7\b=DVB0)a^]KbM.X#JN<;@
^<9g:P3A(:CYRFg79=dKG+L)f(\22B[:,Q=eA^fS^2]#O)XTY,1&QZ7,&7ZO2b[R
KcN:#cF1D=C6CH\;gdWJc^b.S9Ndg^#KUOXKTQCfg,>1@d_50[AF89I&3&U1-b;Q
U0-.D7D-eW:;<SR32\V7O+Z@NJYG95X79O^];VGg+1ee?RU_#B.1J8e>;=<RM;EV
f;BU^]74KcgB;O[WYYU&MS7<5,(G45O517=,IIVN#QEYZ9T_FMARV3?D?VNTd/,O
^(Rb9&^INS1YH>Sf=d<NPE4M.I59g\/&A)M(WD6D4D&JOc170@E;0fV007c;=\Fe
[]Oe3Z)6>\>eH5.SJ]Vae5c4FMX]L#3Rc-F]KDfgBgFH.EI9DeJQF4J_&LVgN30V
9:+d0IIcD1TM?Fd(Z7KbaJP:6SPI<+?)1\d5,\/T8aMO?bTO>@SMRgG5ALD/DA<X
9646gPf7&0(+->P?;#IdG<G\?_6g=R29]S^#4JW#8/;#6+A>I70a]VW>O@0N;J<7
0^CS3fMa)YET#BH]V5>Ad7f,bfcLTKLS-X3T9#^;<[YeeTIB2JbHPd;YS4<2WP@U
J7?VQg4AF#Yc7O8Of=3BZ6DN?UV_=7Z]CA4(/K:))#ICZW1fA&3AF_&1AV6H3gPM
&))K+(K<e9YC[:W/0/e_?A[ZK_AEP@L?XYc_MV<bdG)3K@_]RNZZ(E45:J1(&a0,
?2:NYT[7B9)g3+<gI8[FJMAf-R>aFfFb07DP2f5[eB1M.NA2OL]7NL<PAB=aDH:V
ISg+#U&-/9RKA,.?W:E=W1J@NF4KB<(D<T\D3#9+9YM-Jf29gE1cP.d\^@L\+/L7
L)7>[ZQIZ9)&5SU4HJ9[S[IMc)(V[>@)6CBg3a6#D_QX@bOC7?^=O\:R<_Z?W:aX
/5(BB)5^^?Ca60GLI=e=]NVd(+VCQ,d9EZWQ7H-W)>@:g30)LHMTBOO?3g>_/OO:
c8&;+A.L&K1KK]G\e^,38_8=-^]IT-_;<N]K89K<Z?RZ5Yc7]O1ag?&0L;L_ULOH
K]?_1Y(;#1H6)d.KbK//MM337=W7]>GW@,9O..1@gU8f&U.J?DSUS&<<887G6@=O
JJQ,(cRO(8c+K9)4P#>DF_J9VE+<d5P40bW63QeEWHIA2UWR2YS^b(/B^0;+SY4b
QO#+XS0Lg4K8A.f8;>5fbT)C7D[B_:LNU<fRdag>GPM6R4PMWJTHAe=_b]ODeS7C
V-.[^L2dge?<.M9_M,+A3?FR_.&.<(U,gM-)bD[gQOKP79e,#XIQT=M0BKfSGFeR
]#E0I;=Z,_X@HGQQK^Sf+0KGIHD)L(8M_-Z7fODMeV/bF5=@EXM2+)\NR2FO>\H)
,[8?U.G]U:Z\-_M(<5-?+:SNM^)).D>C#+Z(Fb5)N=JdH74ED[b3#,B75UJZg.-B
(C&;,,Z1CW2c^^Z;F[=<Z9(W]^^c-4e,?L,Kf;bb4?_[/7/H/5&LP?;1B^8TPX+f
4NBP)<;J@B_dFg:9FBS8]>\6_\KTQ/9>C4,^]8W[_SX0,>XC,(aBM3:fcEEC,=>g
B8QG3Q]>04U=-\7K>Ab^Ua4G8M&9N?P>cM-KH>0:@4adV\;#/CcU?S=PD0d9A>EP
C@))JHYH:A,Eg=3&EMN/]&WXR>G)WR,c0T);#:0@54^Ha=.F6HbWe5H8\ZGHDR+3
@c_>-.0;3aU[,37TXS\8TF,:d[/I=)B4MfLa<^(\@:Q</S7>CPMCe1)/1.#Ie);3
#e&P06ge(;\&?RM]<)SeW,,&6@,_,L0=1Kf<4:U^)&(b/e?CI@(SK&_<,J,.D4[Y
+<BMUY.bEd:.@ABK70JNGR3=P[=JH4X?60JR26YA7/AKF(W_@e1Q(8@>GOIX7&e@
=)DL2@7:FcQf6&Vg#\GD0A9Y]SZ@ISIBW/4Y43(,8PR_QOCQ7U(X<R<=X0-50IPL
5+0HFbZH(TfRBUBf_L^4^GYKEg+g&-Y<caV.;E\e7Le2&]CX<+/QffS<8ISGe)+N
d?=-XTD3Jg8&2T7N&)+1f1\F2_Ia@@;[]\VMWV^a4_2b(LD,L9&_CG,CFEH#-d\F
H)ZB3e^PF>)d,FRPU2_I81.9]6L5U.)SZ>),-O>9e@]9:WR:^fSWKUWO[(gSM#53
;:>[RLfADLcYGWZVA0]Vf?gPYGd_?9KG[8,?.KZES1]3Q:&G3>g<74NM0_Z[;<RN
C#7NB<bX=gYU=E+PG&M)9c]IL8eXb9VB4bG,N5:S;FC-a@aRN<^?f[cSJ^Xe&T?@
=:G>Q+PG#T<>251QPTDa@Z(L93PMC3:8b/K9?C@ACHB>(H9F3X?).@ZN2[^[,7ac
59MO.#CN3:0V\3Q5HcH27+R,DF3^@\.8Q,]_[^:e^DT+5:FVf+9HE6G759e_8b,C
cK(V&(RgYMUQV^b?L>B9IfBOY)O9+Rc<?e)43+U)f_3LN>4OY0aDS+?7]FS_MTOO
0:P_.d6CWR3FUB8UVQbK>4C?[3/&;NB,X+()L>P>)]#JQd5_]S>_?3D[]]^g5+M]
&CWB8XPIQZ]C-g1[C<AgQWN3WX:JXOF^e/(G:V#X/&Y,(b\NYdOLMd+.X)P,4c@4
MAD)cWOfaa3_CV/]3R@[(UX@+#&6Gc2FA>5IFbRd)UH3W3PcIDMQ#+UQKP]DeJ#O
??ST>4)Peb-?ef#fNI]0H)MaO),27>AB78\c?<U8eFZ]LEgGF)&3AcLNU[aDaPA7
M;8FPS(\^VCSLC1DL&&S&3+1J7F]CGdHX)\L7J)J\7XYHd>O&@U1]gW19QL?MI;M
\=;<&X>BQWDbK&^O-aJ]-1,SHYSa.e:VBV1)Y.cK8N;PHc_(O17IZZ-4469.UOK_
eO<O/5ZU)]_eVdGNY)4-WBBN<_dUS[2/R(<N9L\Q4PD)IVX8I8/PBJ<Y_]DTSEFR
N\:T:_.A\GAP#0_b]_[.)bR62.E+-\TLc<>55JfWVGAO?^BE[>[(b8]/?#DZbR,=
5:OBR23(-+USM;E,MUd(XF;X.\QYdb1.]/S793UJMDb.2C)@&fMHR+?SFg7QQ6fO
X)O6YD9XcV6e1ENL&?GS(I)@6H/HgJS=&60eAR?R&SFI:Q5)S/QT[SF9I>S<=/39
.KdY;-ZQF-VN@QdcDgc44Zf8H+3K9J-9@MNe^fR#;>e:#HTbSc.ZYOI[<Z<32c)M
HX:9Bc5>[UU>DKLg?@E-2R=eZ:YU=gT@C@Y+[>U9T2@VPRD\5-CU76#Y[^N\GUf5
A3WM+RKa1;e3BT=#2Qf1-TH8<#7b/==H]b8TALK=Z.M8a>/O_>[B+E^^LcJY?Rg4
^X>9Bcf.0<HF4\CTDS2A&TX8RH-=9GH@\W?><I85GPZXXPR<#<g[DWF4V5-4WC?)
D^Z<\O0K^<[5b)g=Z.NDUN,)W]+O_LCCN<-0UVJ6-9PFO4eOIbA(]:dM3FB12M,J
_M0)A[c)27KNEQS/JJYT-/)B+O7XIV-LC8U:BY6FD0JIBXNSJf)S^S3[.DO1#b:M
<,@GHADD,Y8,;D^Y[:TX6VK\PZCZ4KPSGCMg180>T[8eFd5>@dBB\O5]2&PE@G=0
Fe:F6V^.<.8/0SfcD74H04&/L+,1Cd>RHeCdHgWG;^/U<3PePf6e:0)<OFA,Af.?
03W@0PdaL0gD.M9HAI&3RM_aXT.(\bLV.1:FKK,@50H8)dK(H07S6PAc2B;a1Z[V
<3/=-C17N-V=^#1LaPQAI+R,.Xf:O<+aeS.9?K;1Cb^K-^Y6-G/&#BTCd0F-UMN+
Mg6)@QCgdT&LJ\QK51XXBU-Qa^+?;V8FZb#T-B,)Z3NMWgUB.\26L&T71S/68O;.
G5b02DT2K1QDS+Sf=OPKRQ&G=XGV_JXd2^T&>]6ZP?>]+Y-)U1a;CYLB].EPKTXH
=?/8ag8UB10^6+1X:AJV,We0C-Ga\F>T1S:RUe8Q3UeZ\E#JCd&fDQ4[F.VC3SUc
FJJS(>>GQHZC,2E8cfgO=M+RAY79.;=/AW=Id/XP94K.)g,2[M]U620C\6KU:.&^
4]eeR<G7ZUQ#Ac-8H77dT=(QIb_I,4aV[/G<LXd[T6\/K8X-Z-71#;0ZdK596=gK
G<E(/-Hf=E6R:&Ee#_W95Ed\\A6fBNEM&@;1QW^Kd=GWN6I<<[f0Gd=,T<U#VPFQ
KG(PSaC=b_;aG,9H\U5c4A3=GDP_&eG6b0g73H>[]4ScR9KV3H+KS>@3#0SGd<84
MZU&S=a<eCS/87#<fNF67=Z[\O,K6O;W)>:+(#^S?O;KTR&:072#+DFONfC^>L3+
DDMUQ:UJbG<9&1T^.MTY4I9I17JL69Z5<[6XRDf/JJMSV.0+=X=,/F9CY04(abLJ
,Y67&3-Sf6<K@dNb(caHd>E]&CF)@fK&LN4KCIRZCEW>Y=agPg4)9S,I-9M8^c?R
&B[:#/9ROT.d9VC<fK[NY?/]XfbM<?d+9^;8X&La^:6X-H=E6TD.]Kf0:KeP=P4I
Y1T&A[9-@/HRHf#b=5L\UO=aM:[bHW\_AC-.N/AIPH8<R.AYV-.]We(NUe=PSe0N
^9=c5#a.GI4gNNRf)IN67dR/MV.XJbL7-9AfOZY?)2+P=Ug/Y)M<+OX@K_B7@=Z0
Re1R_HDeF(P+R)_6/YF(+G0N.E;:LNOA:B-4c_:cT6&4]R99_K82e60O,04HHU.+
O7]_6QVQO>(NBX5DHe1,KTDW7W2,[PGAH^b-G6O)[5Q.U.6]d0]4U@J8)9d3<OU-
0P;A+JY?.4EbDP81HEQ[S6aFZIe/A.d:JYVbKT^(>\2FU\2><T+^22:6;fe-fW.D
a>.)JESHKf9d;MCHP3+_9:2a0S:D/g/c2(HH>95&LXaQ1E=47)Q-Fg>XTUFAYGd2
>IX#IX[b-\3L9G0RFN[dBTg10gV90_/T?H>dP0VH&?g[.(I4:<b6D-Nc03C<7/f8
HD.:8;//-g0\WVcfN(JK8/;C1A+&^(/Nca?W;7?5K_9A??5?g(JL)RK[H(U-PWJ4
T3LUE7^=G4L^N]A+,2TCR8bYYff.,N[[<We./cGG\7d)\CQ+O(_;H6+Z_23><_Ea
e\QHANe(^G6U-QE+E3EH<\--W\Za\V03;>KW(OP5a2HGX@LF60R6P<W&&OU[e^I-
[cTC+F4A=+6f^af@TbWe/EG-8VPHad5@T=fL&g=YH,e16f5;b#>2/IMd?4\^28.G
XM7/_;G(]:W;EKg<#Yeg-4bMf:X6bLB3+WYdc+,TF#E,Hea7P1c8(IgRD4Y-#\PH
O?PdU919-f#W^59171G:RCNdDLb>;QS/NH1WAU:B^5^2RD6+gQ/(98I.[]4e2GZX
)d5-AX;efgYQN1VcO2_02]L<E&EKUM14>>J-fKXb;;:VTNdXfCTXUf.XdJ16VF#/
BN0;4#=V8bDWZL((0#P+;RJKWJ9:KAV/6[51@?7RLN_@HB>>aQW3?P8DbT.L30BE
+JHJ_cJ[W7cD9>[WdMY;;G+#Y]1f/H,7U9XDOLNXZeK18+[a7Jc:;>\>ID&[48W+
3G3fbcUfJgOOG)Cb;;=N:2MM_96<:a,GY^K4@SMaXd&(_:(,7,_(;QE@C>JA40c(
Ncb<\(0&BD6T3??-GNU[gR<P<bM>aJY\cR[OIL-FKLI=021Ee_f>/-[[)<I&1X[@
_0X<HLHR=AGPEKg82EPP:?K(De@Tba7V@-Z8^1](b<=ZX3eUI2Ic_Y)<-AKgO@18
VJ#^9L6@Be=K0a8/00B35TNgcOCJ,4Bebe6ecIKB:0+;>>g;fY1<W<O9-6O0H->Q
U(:<6Q&.9,Ka,a4J,a4KP^fZS?>3L0[IMgMbQVQ@7Q.fJPSRJ;KP(\e,bI5b0/VM
bQ/4@3L4-J7Z,I0B0VIZ8QKWBUePXEDC&:BT[V-7E4g]DY>1.Q-1RAD;DQ9&/FX&
Y#A99/V^<?ca^f?;+4-E^:c5YT5WEY-).YD\T5WZ73HCSXPQ:BMd1-R,&M>9f;OJ
=-H@==F_g7_HC8c1X;:2Xg+FDcI.4BJO3..O#]99V/JK(_S1#K\[G]Bd)>6AFCcM
(&LgHNTFPA38#B^2V&L70(@c6eMgdH0M\NARD,[M(UeOdXJX5,/Q4a]_Wc_d:MO6
BW^dMR:-2(4T2SgT]#E+N^-E@790IB=_NJ&4V5aJ-AEf1S4UDDG]gB7CCT7FX6<1
O&W?5BR@,N/BbMY[g^B?N?(0MKAaBAfAE10+)KPcc8f9./LZW=5_5A\7KD+(EY4U
K?>X1B6:DYT<ZML-XZ1AdeV<N[PJ0\S[+WHZ?Uf-eg35I5=]X+]GU&(I?/]W=.47
_.H3bM?:::8N>DUIMG8W9(@EWOC2J\I,=)36H-;8[^\bYe(D3&8E.)J^&cd\Xcgf
I;e>Idf[V:4c-58\=D-e-6ZM;IZ^c9IZJE0CG[RZQ-QJHI>78bB6UB]9e&A=O8(H
Z[8LX,MV_@_(T,/]-KP@Q@J_];D[IZ:DLO,J.<,g2gSZg),(?fgP=1gDG99].g(g
HRU=():_YVO]AN/BJ6#BVADOB5Z(4Z#C&6Y/?XY&T/IXGRT\a0Hg_<6A5>fIM#f9
A\3/bCJQ.-c6?U.YN/8JW\d]8],H^59NVQe1OO2)?^0ORL4[8_N>[H0)<HY=BJ1_
_RKUKfJQW]]5cc0<L@dIH4bT45_Ae<0f:aUB+6eF#2F2KD+#418\Pa3VZBSbZc-<
7=cWg@#g3],EKfJ_d=5)<?GUHC>1f&c#PJCIPHd]@-=7PcIC(P1:>3+?RXL?8Y-B
>eA>:S](7YTdTJ5)+5\:V=aA103/0Rd^JP#AadCA_LFN9OLIPV>&B)ED16,OE#A;
P2FgFa/X;\=>+ZL(3\A_0e+JJH1TOALGU]]&^#?=gH.aBRdIS6:6XAe.d)gCRBRF
Z#B@ZN&b@L3(GX655;/Q<&D&<G;(-\aeXT3]>_??KLOIaaeN\2]?)/CAMXFg:LS5
4[GeWJI)P7=+>;E;VTU^3-763eB;D.b3dN2FX#5D^7-ZF.Yf1&HUgA+3ed-?d+3e
b/XNL<QaV;U\I>&7YD8=KBU45Z,YZHUd318R#>_H353XNgcKZYd31-\NM,aFRKL_
19<N]_J?4eXYE-/;)C?g[GY^,81D0^WCb2ZVSHO.I0J#F3)SQdX9:@R85&IN[#]<
=ZNA/e3g>M:0Q,?J\a(f]4]IC(V1PCXcW+>/:J&NQCN[\0GCA#RRQ_RCM\-)X5#R
TQb\?gVb?)0a)\OJ)A<VRbSg>O48;gUM&#G+8&#fQ/QC1Ig[4Rd[:3(&(O;#Mb_,
48QJ3=19JA&;80LC#4b7>^:#RG+INM9<R.:3f:I\^Sf:N^?5W+ZW]0W_b[T0\F,)
3]6N51_7P?e7(U->,-)DBC93NC?R1V8ZYgK83\&de\cWCA5R696e)3fQ]S:2<Z,\
;3L+-MZ+HgUP^=D<]^bV<D)8P.II3D7[GI:-Kgf?f+U6_&V0a&]L:(1a:<d3-<GV
3N6WW:edBJa.FX_bE8;G(BOO70M+Td7AY-<VW(+PT@[UM^eCOV(7D^HfFfB7]D#4
LSL47>gRBNW\LSO5MBg.\P)HN@_#BA1.;a=-0bE46Z+g4RDZNKM4YZRYf-0F@&:C
]XW[c:4#WMK=F;gc.=F5(,=<T]EW^Ta9aV.BGV8W25LAfde8Y1_S+:I(&7Qggf4N
K?^;549UUUMCW^d0>d]\e^I(\<>F=HgDR,?g[gW.T(Q2D.<:224I:e(Le=(7g22.
R627,CU@aQ3WHN],5QM+E3fR,6#9Ce1&?2G8?Q36O,gAF1238>OTcWY\gWTL5]L[
]:3DY_JQZa1UT<09<_S<YgG0,&aVK[;;ffQ&,V4&>=AD/<2GKeA.##<T[?9Y1QT0
\-[aR[/<4V(RML0NcVaN;d3b_NCe1dOY[/&29?-1(bS:9b&[cSRIFMTaRAf::H@O
Ca<&Q&W4:94)3(CC?HabV[YG^A1]H/ETSKY^#J2@UQW970-.2VYDJ.<><QVTVMa2
5.?7\S1,B:3&)8b7;)(-JET=B.5D,ZKBAUKW]D1;5F=f6QOD.&ZIT.#8Y]&_43SL
2@#0\31SOW/4bcR3>5dcKKQ?dJ<TE07DfR5WbI6XUG;ca,&&gSc_Uf;L3G@&G8/6
_)N8)-S,_dQH/,e_-Tg71R-<@)FJ-+c?(0^]Z(<?G38=)CQQC^P?=TER6+,UMg=1
98IFJ#=B:8BLe1XJNSdD><d:_DSKR6Q#0MeZMaJ9FT/IdR[b=<f78E;[3XQHdJ-f
+P\L-,-T+Ja8B,^KPg>/39D\\X;3CM,C.B6LXc<9;MOaPMGCLXT@eL973bH0P9gJ
LB3N,I_:f[6]>Z2g;4?,)&ZBP#NV;?<7NX55Z+C(;MD5-Z7<Y/dcReeX5FK;_@Vb
(_9#fZ6Ia0.)f_>>LXB_9,^DVYD<<W<AC6;P?K/&_+)/:fS(1#^We+c7\WRaYU9a
c,NPB+Z:8c(:<LYbD+E;PeR6;#f0Y<TR]Zc(C(Pa-fA\JX>=9,NaFC0cC+3L3+IJ
ZZ0eLSWHCQ_&[;Ae1&SPeaN_.+RCAI1M^fH<Hd]Hc;ePT)-]8:C3E]VYe^BHIP]G
Vf,,I\JDH^V?]C#CbJ)N-A;<2[JUeO/:ES.FG)825?(#dQ(Va6/W>EXIBZ_G.5)K
g:STF7@EOAf=f]2KUgLb4Rf8;4(N.d[M,1dN7#cG-P<TF#N@-d_5H&H>d>:)VO6f
C,R8@49S:+S0+DNVBV\A\OV>:]c]R8)dW1ca<5?T\>ND:^B21<.3e8LY?[,.e5Z#
dcbU&O,4@#KC2JR5:fQ6(-38g8P.DK/MEDA>JOSDab4H\F\L^O3O&6[[KKV^HXcP
SCKSIS7Q-&<aU85N<b\]US[SWTED5C7f)&#cIX(A+b.K=G7=BYCeOH>ad0;@XMD9
NRVD)b7PU8&O-Y5RN_DP><4WaS8?dW[__cDQZ?Z5bd&C37f+1IFN^dB,MUUNFb11
7QKO@GF(]FMMWaPCS\^AS\4<1S(VE149UQe>\,-O(D+RGU8/=NeCLCb-_P\J4F1[
MS29,5[(]DHTDS0YOU/FgY8X3/;<,CK4F0D,__]eY0V_N1LYRM89#)9c@B6a6)+2
B+Q6;.JQWZI6V#L2EVQ;MQ:1fUQ6A;8WUa@-,1PFJ5E#I&DRY.XdND,KABIME)IE
_+=W?+GIPWLb&,>4+Y/>LKB@R-J_4@N=We?IP^b/BO9eE-&F=@<3>VS7>,4gL:?[
.PUbB3QNcN9dW,[CY)DgDO/GU@&+0&e_MK#7>KaCP/NN@Y<[)-)6:FdCdZ_F5.I:
GK_\2?N2b9d:Sf<&T+[ZcJQLcTAV2MFA=C&&46[?Y(#fY\.DOdS)@VF;L;\OU>_9
/&AT3LVN8?f:,=B2M9&BAWV_..-M_Z5a=9P@]&)8ID&#Z#PSX<)YHERKM/,HL)b,
CY:RHS?HMJ+J4:?TNLg/=<VFW^:MM7cS9;W2+,^>HZ=/C_P:#b-GMRN;LY<?\b;1
L;A\cI65AX)TRdABD(S9Z7&\GC(RW\E>@:SbEN=Z6).PT]C22&3c+0b5;V?<.C_O
[@,ddP5SC=UgOdZdWLe1[9>C@J(;O[P:EV;]WP7?)TP#,3XRE[#[J_4ZUZ>]=DXK
gO7FV@>5/6gNNE\g>0;d@Hff63FX[,abDJ,MCKM,=GgTMDA&2XVQDUCUMC)K9<WZ
7OfCba7]O=-3DO:P2?]935^TU;Y/C9;U&6/C[T3^aB.-WP&_]-]WOM_\DgFK0^B\
LOc2aXgQ(^GX=eMMRRI36c+5#U&_e-KI<K<KNF;Wec-V2TK+AS>#:0QBEAd85.4&
XI?C(J#<033b/,0EB&QSA&bFKW4<0E:OLZJI,4(e:)@@8R<b36<F?U&3I3J:#WN,
6P)Y,N8)@&PI.ddSTG(.SVbUIDP7R)LPXTMf.6KScB6Y^NF@[=Hg+PD_M1EaM+A<
c8<3]B]Z7FJA>(fL)RRVb,a][f+Ca+JG&GCH-Z+H2#D5]]TGSB(eGS[MH(.=bb5Y
M/83?:+.8]V./UY@JI#U=VI?>,:dP<S\)2&22N@7-d15Z<347M&KS275#9V:F>^&
=,d]AE<NDVI5]&?cV-7+WHLCgbHTA;a-X&K2U6d#AE4W1.;>bT,QGQ4g#GfbN0TG
\;CNZ<f(UU)(O;;7?7[bIX./gRJaN:AV02O@Ae.QQ-KSM&E8J23K6-1\@-//#W]G
JVYZ=#Pb[;d9g3X9^D&DK=DNc?K?I&W03^M:DEKG::C]bV9cBRcD,@H/T&-7V;1(
L95g7KV:Og^=1_@3VVV_<8)VS]).NWNG9BU&[HN9P@g@LAPdJ:(cDNdg+-LUF4VQ
2L]]EZ8^XCa<?8OWVQZ.-fGV0g:#J,7XYe\(?((U,PSG+FP9;H?9;.9Le/(OW9Hf
(_:,[,LTW:(deLDC&8IN(J3NC4+;fc,2:.H_\^eAM3(84OI0;SF9(:0&0IF&.NK,
>D7M4LU2B-)?T6\c/KeE8FWDEZ2T.-)H^&?#1#E46e)J+[fDH[bUZ8U)O.We];_.
NQ),3Q)V4AF(;#,_)V7JBJdaREbHbK)g5c)M#C3G1<XWA_b,N_GcCK5^+J]R0bD4
KaeZ\OKd_GG-8@aZ5#_8>0,d)IT,A95;=^J9==O^;R[?_R2_2F9A:F/.F_XF)VF^
8::Qd\F(L?8.[26PK+e5:DKg]#E_S(]eGW4Y?KJV)7bE@?A1V;aB9Qd6JbLAF?IA
c#SML8??gf-GG9\1c5NUTXF(OJaLA<9XK;^\1P;2L:7X;]23(87=RA00F-4]&3=.
9.fH&.GW[(U:bD9FdW\<gI#FfI8?^7^MD(/57H&J=1773V4fZJ9[BW#T7cP5_Bg,
UAeUf7BD802X_MbBQ620AI[=gMII_8]SE.9LZA/H\D?CL]Ud(:08W<\5N+a1<X+E
(2@J3C4<SM5H9U/fg9,B?&/e0g0fH90D[6TVg[#b<ddfeJ7&F2/E;?UaXMCFGDT(
5b:0,;>PUSZUfL5f12,W:S_GL=;24H89)e_3Q+;>(@1#@<(c1(L?0;2O1MfF=\2]
-H<c8;W5a[2F9/7O1T)T3G1^NO^Pc8WfKN<4P^R6^]-HJ;C=X9=BD-;]0cU/U)4C
=P)SNDcXUKRDgESKZMT=7C_F)MEF17MRc[<9P2&R)D?)AW\3f/D)T@27NQ70,[<V
,<G[AbG3Z1G#9RKY0;0C_<cV-WDFe@_6J1:.QB>TP9>;:X5=A7<(QBW1D/]V9+H8
QQ6dBJOPD<K5Za+fI?]FXG+9(A@6#XF\Ma#(X&2FQd]>Mc<OU;B+9]bJId_]84?@
gTH&X/MbKa_+<<(Zd/A^Idb7U0+HV4RR@O)RfE473<3/cGG61&c=VD\LQ]\5?>A@
Q=T:??<1H,?6JA/>&Y1.AEVAg\B1dfUU&A9#e.;7GM[HS7:ga#ZBC4eA6_UIO)V;
\76^E7IO^_,f=UNR410[@:&Y4<(?bNPO+_4acdO&9a/ZK#?0F5X2\0#5#[f]+#TU
5]Kc,=#bg.E985Yec./[OCF00K13_0A5S+eF76\20E48gS5#LY9[Y3JC2UW4=K2S
aGa4QeV9KI+]&K<1Ee4)Q[/?9^d.Q^f6f#@+F8=EF2WX9GB)(0[R]C8DXB/<E[(\
O3/2EUeYZcHVRR&eU@aW#MI._.G45\C1\3V;^&df;9@RJ2OIgNMG3]6SN:/WfL:H
8+eZ6@S2H2Q>C(L+Y\<?f):=b8_A.c4I,AWZcB/.6)IL=CB[edK5f&;E=cK7E4+V
7FM74_dE_58Eb9beS^M3R]]VbVZS\(PRSO[=S.eBAKWD>@?G(a]J6#H3F@P([fDR
XQGPbE/>5Q4OFfQV.1[L,?ODQJc]_7fT;S2gZUTK28WcA:ZY4:2_KWa(,N;TJgg8
<NW_:WB)-5P):+b6.^Sa[@/,]-)RM^OBf+,>B.#F>(F,.D5-C3TgU&&ANcYS9I(-
ZAK]5//<\[F0&5K;BL;KQX7>;(TL^Af->V4Cd8&:=LDe[]_<#Sd--O,>Z^/(:9C]
NYNA;W[.G>A-G^,35WSM0GDB.R6)&<7-Y1_3Ub;VOTc3?4EgW#2KbTX8He@dfYEa
3MM]GMZ.4K8YU+UB:\YgY&/Ca@YWdJ[.gFDT1aU;ZLE-O-J4CfHY_3E4.VeeYbK7
8[FHd_M\b.GC11W0Y8:)bUd?[817>Iea+0#U3KeG<)#-^F&B78(-.X_YS.Ua-QL6
=OS9WCa<NUJ@9I#I^_;M8FRH?^FYSag#CUAgUX,F6@EAgbY:-U:]=S/7KA_RdSc7
V(S)FL7AL?:9&^Z(_7M91L5AT@&g_fYeY_:2\2PQKW&A54RL?]:59>^]XCD?W;Ye
Q5da)X3CGSd,g7(UIJY-VZ2YT0Y5d#^Q58KVSZ)+RgU^@7-gb[12?(P@Dd0.^cFd
dfD,TF\1LbT[EQW/W:P,CI,:Y9&@C-HXMJY1c/WdFg[?27,,^3ZN8W@@f3LJBg@>
9D&BSAE_.VHAeH+d<(?=>S9#+\ZV-)LA/,=3O7BEA9]?C]Q/R)XVf:X;[d_4&+]O
Q<CGP4D;dF198EP:,1/Z^Rb9CEYCF?N.5+IJ4S1edFF@7)=36S8PCe<48PP5cBGK
X+.56>T<d>YEg2U79c?WF94fbKTT;,1I@W;H[/)#-/D)ZR.,\:PZf2#FL]9Md)[[
&_BfHD0c:[TCaM[d\W:H(/XE&[YLRb-@-/LU>Z,-?\Q2EP=?TQ/5S4bc&(7O-/L,
LE=f.Q[R_aO(f^db^@L<0W7.ge^WTHa/@[F1I41_TG<JK]];A\Z#\K_,9c[@db\0
-DX]LQG=#J?eCQZ:]R>IK>=@Z<gaW,]&&8a)eNaaWBXcC.YZ>c1Y)26OLT9RdPBE
5YXg[K\A#YJ]^\95^3)A3YE,)5BQKfMN9=&]8C..HT1\3:8Me)E;A=I<<U+=WR<P
Vc8;SK)8ae=IaYPb\f>9,T/#Sf;/=<R?P2EWeLY\C;RZ;e>f<)XDR##4?<?1/2;<
LSdD/1acC4cK/]PL5V]S[RTQV0F4B&F\[5Mb6d4<4c?BR&[]H203D#SCb0,.c:Hb
Q+Pf;FM36@8,6.O@9K\f#9KA9P5O5cR/faVBcFLRQ=G14ScXF)BgFFePC>(\:3>f
6L^Gg)8;a?fc=B@OGZ?<R:H>4WB0YNNM@T>cgRF(?AS3bR:8AX17?ZW>.]g0B+-J
aO3Z+HeBW5Dd.dYFCagR-#VCeDcL4NPOM^2(6eBI;3=A6_AX/>?Z7TBgBCR<:>fd
:^dW7gf-T\5][:S&EID9:e1W^,bY+R-#GQ/7\K#K()@P4QEH?]2N=1UYe_7.)4-d
.;Y[/_N;[QB,,K6[R&?I&S-4f##T:NFO[4R-H(B.:R&P)K>NW7IcH0SgMPbgIJV4
C+,Yc]:Z#GU\;Y2EWI80/Z)b]1-DcfNa2gg0C4?1]_dOE=4O,KeO3NgK1_5T-gW7
EPF8(:^;cQ3Q?7Eb6g=GL4_K?b38CV#O^ce/>;Q\J8E2</-=<\[O-a99f]E3MWe1
BC9&M5MD/-I-gdB79dBd_dRQ_9L:V,L^2AMI.M/eWRUJa6edPPPRf;I8M^R52bB^
gJDAYX64S&RD?AV1f/eg7B)KVFU-X;?QEO>gBAf5=\W&\QLZF?fOQ4(-J]R7O,@5
&0U[3dBSL]EPfR_@AZ3gcA(RX[TWA#@dfbP^(_#_O4g,3Jf8FWLT[]2LQ?eRZf4-
E]:\W7T?N0-VWHAMDgO8L4S^8P^.0YZ4gV2:G?-;T9_#:B5>I:V;9=82K+Y,1P3f
()HfBb[FJ>9TZY9;ZfeMfMS2H+aQg7Z&S3A#8@-bJ:4BEX_?+AM0Td#Of#B&^B]I
BRX);Ce+.:ULB<.fGXW/<Y(;Fe(fNgb70?J^6K2YdF->^f>L>.Od_U?&JFN08R)3
1B/fD2&2bHY4W#8S@2P97EE2;aa[B6HTa=[cP=NGP2^?55BQfMB.+3)UX4;b:cMW
>ZX3P>1aM\@C\WB[O5UL.8fRf8Z8A<BY)V]J-88MHK(_&Ja[ee9B_I;\_SWHA/AG
_/2gF=XbS@9^4[-aM>X[JXN=IY]#b(<.&e@);Y09TCUYObJQe.-352Yf(#73J4(2
=#+L@Jg34<,^?HLB&=/5MWQRA:3;(]<AK>ZcFZ,+RAaX\Z9b2#1e.@ZGQP.1?7U,
(G;^FT0H_YQ8M@MG0_(N((/[D-NUb6]^Yf>B9E15O57;HQ/g#d^#Z+VdfMPR_DUg
Q]45I6^C\@R].Ee,?8XE&OSe6>AMNW4ZWSQM<Fg??f8(=+c_I8Kdc9a&3_[gSU0H
ARH-<:Gg@O(UJCYCSY83@WJ84RXJ/B(9-87FQQLIH9(\LZ-JBdI+>eBG6&0EG02Y
F@RHTHS18II/I=4HQGAA,^BCC_YOO;TRV\XI^gV9bS;\;(:=T@7QeM):K<>bb]BO
Y8d@_g:9P.MdJLJNf5]L525Q@KVD+RW]36-HECWPf/=D)Q8M(6XMg#dX>(3A,EPX
E,8L_A+L^JaJT_=PdEJMP=?F&8>LK/H7fJFKQbQfB>c-]:R:;)FMHQV3-bO-W-W)
E]OZG0(,V)?]+3-\9eZL@[AP\dK,B]]5]d.@ERf&A(FHWRQ/9U)TLOHP\X/D4L_@
Y?=N.b]#)8GP103aWe(JG0L5DC0I)IQ,^L89\36\BJ:\6=+Z;PR\/Eg0SR#D+]gD
^D,Q/<0DJY29WTF3(AF&Ta[dfG>G=[()[.?Y\XB>T;<&>YX=IY(1SEK_KG/.H,0>
SeY)WAf&<,,A12RV^Ke@FIK.aPf1RE-4D<A4&YCO,V^>LQHX?e;bdE9BOZ(GY\M2
Y[[+dZ/DHagLHG1CHXLB,CH^Gd(=7M;I]>D6dgTC?<Sb>D]@GRI^IPV;HZ+[gae;
M-(UXWMHZE98Uaf-6J\VY2(#7TOQL>RM6fMDC7.A-:EM_VUf59FW)bQL@B^?T2Rg
JVI,UeZW@M9Nfa81@>0F0)H:JJ-/OS#:eDbN<gW9OVfHN_RR[^T=e+Ae#>a?].a/
&K+ZU&6V]G.RA>+#H,Z;>\c335)=^e>WfKR.-OF^=E#B+CBQ@/Q6+.6UU.(5J]VF
K3V1>EXR_gdca;=ggXG=NEVc=eBaLMS9JU+#6K.7#T8cfH2WDKK+YNcWQ#)CO_Q+
CDdLa_?>GWB,fM6QFHNP)ND>D7#):M&?fWeTJb>EZcSW4G?2)M.@Aega;+8L3XIA
GgD/UIM\[U<6(\O._H:,]NA4PQO#4)Z<9\R#BEYA63KT-.=b+=c6NXO@YCIHc-E6
7eE)[bKf-a9?J49gHXKd-CVFY,5N^X^9CRM7L2dR#[B]+N\#(YNJWE>gM))GbXf7
R#;5<gZd5A,BQLb_/2X<dM_P&gd;S;61,I,A7[]^[Ze@CG&2YM/SPC/(DLeBAPgB
=+cEL,_&>VAE>2W([#=+JUCT9=F.CU_.O,gb5RKK)afM?[JUd])fG+X?Y;PCRf<R
[@Nc)&3)XFH?E;C@bWI@QaL4D)N4CP25X?9SFFPc2X]aBOYK5Z)E\]7?8dYbVf9e
E3aZC]^-cf;OM57U9L@6]+U51#,aP)N(LgE-\0QVNMd)ZN3YeG1.a^]2DAP-VQJZ
[D&eN=#g6/R.([B.GRV1W6+UD8I(I8Xf2/K#1A0?_=:Oba<bC65L/X628-BQW;+2
d2Cfa4S@),/XHCZOF,Z:[/Z,]16,,,gf>HM,EJ^C2PfZK:O69+ffE(>FIC<>Ne?_
gVWUD(OTFKOV(?JeF-,C/FEY(c\-1\B^/X2WaD=10G3Zg(B2SaL1P[5]U@Q<T^/Z
-U>_UI(G9OQaO.?)\/L:FCYeQ::c7DMbCW&N\4H-f>f-,b^UTKL&^3XY:0^QQ+)X
4UW\WSV/0a[c3LE6]3V:M?81-:-^L&/T46@>beHD2bYEfb96])DdA>eX8;@1_]KE
]S-#3X,_Z3Zf5WMgFNOCUMW848UQGT.0/O,DPY(S=VYCLXR0:3GdNX(dVbZ=9R>T
YE62bZ\^84bbPLWeI[Z+[T/-g=:2AdZAPFZ3OdD5M]@V-QD?WY]Mg4-@R.HQM9Qa
+K=\O(JcWED8Kf7S8+WQ4G.)1E[MX^6?c7Q-DJ>b+=N.IK2(UZAY(V\P)-<ZMPB[
,TU2NXSga.H&:cLR6YM^.UA,;3=N4Q@#D;?@@S98N#;[:(3AV/@WE1W[3SA-TX/L
.\eNQPb@1Aaa=3IaW?[&=P9&2c+_CT6;P0f//b=XFSe+Z+R9,;L:KST]-A=GYS,G
MVO;>K@K;bKPS>3S/b1CEJZ-C2Ie,X>GSC6N=N,V86B4LPV<c4@0e[#//TQ2+UD.
SD1GEaX@(5^65Ic]^cHW?BF+])]C=#P0eUeE39S:Z=MMeR6eQ^_]][?EE-,eE@#2
L#UDP^AZI]1]A^X02g+-.B?Q&Pd^3NPOKeO_MXI/gI:7a?Gg]YBf,Je?/Lb^2;:?
NYdHdf8\XS6L8R^&Oc4MVO]RZNTMAWB(C7&@,/E#V-RJ0ZOMKI?U=>CCcc5g:cP4
^[(2?>U90X96M(E2H6&6UMEK(EM(B?ScBLJG=LbBD/WT,DcUTbA:7,U>Y:_+4>>V
3R]-L2VRKL[b)4f4afFZL8&QP7ZcMJ^XS+QL;B):>#4A?eUUX0_(N#=XE[6c5(K,
BIXM3=/O.TMV;6QLH(X&=EHA[FVOGGdP;T\OdQWT37=LfB<,1JC]5M@R8078AHM5
E-#B]XYTB^)D8&aP##N(b+/eZ0CF.1-WYg4.RV7g(82_L3C&8eCBRZd?,)<4@3>W
?2Gg8N#2b9DcAM&IXQ)fJaT21SJHA<.7Ff323MeOG/0+,;0&.Ba;2S:1)<cHSeVU
\\K,?NM9\O-bKEINHCT/DF?5\aC/XK:U9U#<^2--&a3FH9=:-F]SC)GRbZN0Qf^P
7@2HIa.B]&[RQfX-Y0I)Q[R\eX:XKM^Z0+FVI8V/[GF;>cXQ5>]a(Oc]-LAF?eg3
=0;NY?]+1J_R+1X6Ud:4=BDGIgWIOeB8#T0X4^8:1S4PF4QQCZE1-09J7LG5PgAX
aM90TcKWU25QBQeL]LZWG_U<LKVFE]Q-==PJGDW<#-R.B8I[<=eUYIYX=S<@CH/H
MCBPaMfb[H:D:CT7M03Y;DX\f]d5@UbfOKVG&d>ZS,B<8+Q\(AA./6]GbX2>WJg-
2ZJUf6RSFNM_&\>B;@P\)Z@M1PO7UG(cE;E(;&e(QG7Y\[Q3EOQ\7ZPK\,7=LM3^
@._5gAZa6fDN?6.dL&.fCYS;1\SST@g<FaX<3#&[.J/RG]FF0]\W99<)#7PU4?@B
,ZMLAfaU&)cf#Rg0F+dW^-,#f6)H(e_,E7^acWS9IY)\T.#:VX+\9aFOKJX_+c-1
_FQ#G2&S,dNbbL#DYLVg^5N.5,(C\DN9^]g#deE=GA/V).[ZWd3ME)bFgN^8?PV7
K<HD&&:I>+DadTFU^=.<e^,WMJL2W&6MUE(g_T4TKg:CGXaFF\TfT_](88VHX_+f
36V._P(&443,Q(S(\KXc)T1(GM+\6>L<fH_D<):FB4(TG_4X-<X,];<M0d.dRe1F
aaQ7HK#c)R95GKOf-_>f&6a0@(TY1))g)(P>&=<YO#GME2:EFP-GJS9O21\N@J)+
gXVF/f#;a4#2=fJ4,VT#c/B#0UFYV8V.1KaAC\2\bAU(\gQLX(e4OZcEEC#Xf<\U
&2+U)KFQ,),e)GCNbL]+]E(7b8)eT=IAOfL?MgV.V^aFF#&e@HYfdV0=MR..HYW)
X5&HJ#<8M=^ceYA0eRa#GEIU6WgBZ.gP&U00K::W.IZF=;--cFUC3H++bJPQ,^Db
]_b8gU:[.N5VU]D=8.Kd-YJTZaV/6f3Sg3<=>L3fIU89-edX>T_W,3Oe^J6Pf]#a
aI_-&Ob>3YW)2)Sc.;&e?MY@-Cg:ZbR.-6?_\M)c@IV:Db??=fNRcC2aB:C[SdaW
Ec.d9G9bQaR(WR^IdAEI>A=Q8;ST4.76@[6WA?WB=3\/<S<VLe/#=QY\WH8GC\d[
\?D\4F\_EX]A7AN:aZg,Ib_dIb^\)1P-aX(9VYYSa5FQAQ;6DfPA]U_&6RVTK]A[
-VM4?]?Af8+>1,OP;W0gb)[QL,dd[3O&g3L=K]M_;5Uf?<bL4-++\aQ80.QY3P=<
+dU+:M8OTcZ_?6EaS9);SKR-J[/MeA9O9gfag(V+G@^K)]0bFg;cgS8dE[OC=b[0
]WJff^(aH(UFb6aIT1IG7ZK5]g@Y/-.Q<bfLgUcWOcUBK8&b3>A,>C/.Ycf&;Sb\
\)O3CR,F^FI;^Fg1R@I+B:Ie_P)3MZ,HNaTGMLO@GcVGMAD11dJJ492:E4H,/FIa
f+1?D#D@Xe>E=_?N(QTY8AWbHYVD-7.=,)TFOT4+S#/_WDXP=\\bW\+8X)MfB<AA
V<6#/c?DIeUEf/1fL,#ITI>0&4e2b]2;X=Y/+R8^geHDV:C5K>=ddD8#XY)&FP@D
eK,/KJ6f18ZC5B,PGeM<A58FL5g.f/1W&\d,T-ggR:JLZcKc<O_O:Z^\D/A8NVB>
#:7-96aUWS+>U[(\08gE6V)TZGB;-GS-/H<CW5FTON0/4.ML1RcWd6MKI9Eag+bQ
EaJ13[cDW5DB0b,0/@BM^?:&dB_EaPd4c2#Be:?E[Kf.PJ#9RdL)ZWXaB\D3/D;f
8TK6/4=F?=_J\B9FASN^^]ZJ@DXAF?_ULRC-FKg1=ZHU&bA?NE3K3Y_H5,3[WXHG
;KDU+b#:[B@N9JTg&D^[3>#b/C1C=/C^)ZHbP&J,&a?+Y7RHU&EE;JC9URBg[;P2
W7OYe[#07g-^e\PU8L-E^V\WOFW\NA-QK\UURfHD4-@5BEd++Q2KU09WL>()WVI6
GA1VFO?-_K#K?T<0Y,8GcH@X?\P3V6OR+.=aV4J^9=;5J2\f?Ib[VR9[1^YbfCfK
JM?BdLCXPXQ@<&W6MQ^f_YcOW#@[)AFQS5^]L&5FaF/_6(ATA0-d&5[df823T6Mc
Xa7QOFJ2#.7.&B:5.d\c2&:Hc<?6VO^<5KMF.U;=gJ+<6K@QBEaR\3_YJBY?73c+
FDVR^dbQ+R.W@NQd,M0\D\.&f@,];\)/#P<3)S;,Y\J5aYI2+CTOV3M7GgO>CS,E
MN;]c2HYdY7\]8dKGb4K336S?^CK(dc,=/JA/P0ZT1c(GU0=Nb/VZFcBMH4E7\\&
P?ODZO-BKQY;?0GX]@DHf9-aJf>.Z/8/A6=1#VK[Z_A&e,(,M\AV37?dXd(@YEH;
E[;/#[5=Vb<C1PH]e4RDe?O8.Nf+9?b@@ESP12GXY/S]SEDM#V/F@LH@/[&DVCJb
6C@><AWDD.Bb1+9a+OT(;2P]I)IJJ=Ug-(UCJ8dP&-[I/b&_A2=a#8P;ISHO8C8;
Z7<M\#/M,]36<R9GE&Z?,aIC&?f=T#M\D5<P8BT@f;?S2A,[>Kb0OH^1G^)3N29P
dB5_]R@O#=S<GN<#W/LHUUXDXG0E0?)d?D>EA\6?;&3=:E\;?]R.^9<EFLN\K:OS
5Va20?L?c40cP[++<C].eTP?[]c9<GddeW.NDKIKK3G\U4OO2?J>gT2Z2V.YG]#]
#2gQ+_O_e<X+bg;fGVgVg.O]YH(Sc^X[NU2BYA2AC)6:=8CH>FQT=60?I(_HFFbI
NHMgMU[/YLa\b>9Z,;?6C-OS,/AF):0B456@.I@BV&(c#1AJN62)ZQEP]QRU?Y+I
JeB.Y[B8[ZUCeFf;3#8cgH;4LaIFR#b<=b2#_S.&GGg@9T&N?;F9b/[Ma&\OaBFA
C-A);TgaF)S?F;^@.6FD_U27S>4RIIgUQU/aPB^2#-I#CD,^ZUKB<@g7&8L6)g)@
+6@X)>a#TL8ZE[]QQ(H\Aa(2KA4S.?(VDca?A;@[]5V3V^e7[H[Q)Ba-_><E5d-[
_.3e.d9KcGdSf=g5Y@bHT[X/RLFN+BQ>BO@E3)&P4YS6_Q<R#aFTd.@9W@6:Y=dR
]ef?KTcL6=P561LB;4X4V(WW&?-=63LIM.@dRB[IH)eXDY1JWf6GbX7(+c0A6&[9
A93G_c-<W:BJCgALb#?bO3MaB>VGQdS@)1ZMAZeD]7N(O+)=O):_PAXR]1[Q3\Bf
/EZVG2H]LG_49QaJ66M,JHJKN(W-See&a3P2B@^8CBGVb-AP2XT24A/_W6B#gaGT
CI/dOVA(^;Z[EO:AfeFXCDMXN8/F]I#Q#JRFOS.Q#]>aYX5BZ(SJ\dN(6R@K;eJO
3S>_?(6;1YLZM739dTKcB)IRZb_,0>MJQ9P_13G/XT0[_A&D(338ebU?/8L.H:/2
dM91RVU5a;GEAWf67^3&=V@GB>4]YSe:1Y:LGZ88U>J<L/#EfGa08-L(4.<Dag)Y
S./B#L@S_g[R8(5UT4edNJC,A-4YUeDWBTe=WYT6;HJWZf<DOeD14OQ>c+CbYU]9
Re27(JICL^2.,B7;0TU(_JPA88aQF_)>@Nc\[)Z7RM6-:gLLQdD8W4Z(&RW9C=2g
6b9NSJ>A@S6RMQd[M-56_4-PXJHF??eY8TX20)=8V>D0=_]W),cd@M^ZUC=5E(3S
dD_V;P5a9dab629]VMUXVZ8f=5@eLE9B[K47]<CKRg,>YS(/2.K]?^5.SSGYT4NQ
VJb?a=X-D/e_FW)792Q=cD[U91eV5#74\b2F.>aDE\GI/V#6d??KV1-;(520IZ2_
f)f^dRMV.QE229&I7SP9ffDB#&WAYQT-O8)FQCI>+W11YBQ?gT]I/[BP4g-]7;SK
K+,X9)eC(_cGg:-#/KTHJ/JC;8;SSKMT5(,(W87J--M8D^dSQK+/MB8:>#UL8,2.
N51DMW3(S6Ca\;J\_L(4JO]PfA/S0\=a#G&.=\f4PC&^CDg]H?dVFLIHb@bdf+@0
8W1=gEbK6]ZO)R7IaD=PdK>+_R1P?I@B7X><3M(LA,cKE;6Y+=:MEI?R&G)<4dJO
.gM&6UG1>3Z+W+>IA^PJX_?(667<=J1]6>A_&W3HW6J_?V#=MD(2?2dZY8S@SKX6
&-;X;Q__BQ[L3PU<5b\egE\Q[K_76]KHRXO(b#7O0BL#SW-BA6E5&E<4Z_<#VBLd
1Ya:c>S1OL[YV\(YQLN\>,A@YH9HY-#d4(DdN25U9eF[d==X2;G1GAc5QIY.6K?]
(0BK:/6<#-]I]LLZ;@,9X>?VaP(W#cE=F9U)I4IN0NJ#>A9:#OK&IE#9[A>R6G:3
?;T2,-O(V)R+ee&5F[^CdY@\W3gX]P2^[#[F#;\SBKOYFa:6RJ)IPX:;CVMR#=Ra
?U/I2IaeNCCO]@d9&;4g,D::8gAeX)VI9Gd>bFe\GGH;U^1GBGXSX6I7A-6>C;\R
f^-S@Ue^POXMa:DeaYYZ8^([\f+-cH(34O34OD3GU\]e27RX0VBOCFL3U&Q[geVG
;-eF[Ug\5aHF_#DNJFCaAZVY(D+fDB8KBX?/cSD24J+DH]e^\A=ZY8W#bF(6R9R8
WIA-:&]__DRc1H<F0:6CR9eKQ4_L3b>LXQ>\7bH]=Xb>=/]X3S,:2_gB8_\RI/7I
4BYL5c_2^FL,,7GB?OO<E&eA8J0a5eD(_G@X+FNd@Pdd+6[9.bOA;9cBa,6=K#6V
ULb31/)_ggI#CYfeJ9I5>;[@XOc8Lb\^WTN2[1:K_TPL.ONOTbd,Sf_5T,T]^4L-
OScX5e1W=ZEeJ(HC.\)6eD^/W9I@#f9VO<,;OVe_X04<E7OHF&WZ6E@)@\HG_L,6
(fASfaf@)^b3BZf9-,-.91NMCOY:?0:ZG.Y9;)O[6bMJMZ#f^WWLN[N33F7TgJUN
#LDB2H)1;ANag=]>J(dS,BQTbMJ[Q5C:[8E_OP]f:CP5&4#PP3dOO6E_T.Y\6e(A
6H&fY@8)=Rc-E2?WPB_HD0OfE3E&:9?)(D:DHEg-[=a_TYE,L_>V:]+;&]9/bC?2
T2>8>STE&E[1JX/,<R;c\9-T[1(<HPgc=BI1M&CZEUP(XSOOb9FLb?6)C]4L,&YX
/Td&2=N>V\O/O4NMgg@U^+a)0UKUfe[EM?d]8e8,gb?>Tf=S/GfUY1@#&gAQJ;J4
1ORBXWJ\NLQ^LUQTT4X^86f0NaU9:/QV^6.LT3=HBOUT0ebQdJY3Q42,bdE\I\ND
AWCE;.];D#:)+d;O??&Ta7\)PS,e;50Uc<B/@d73->T:A.V39DU/P8<4TC;1,VPg
OR6&(BR@HE8L.:FPFO,8Z?#6OM/K,)/\fT=UdcWR(@#K@X.I-ELWA)S8M82:=Z2=
_SPP)@V?OOMS]T\L+9Vg6BcS/&X:70ZJV[g-Q=23f]4,#TG_b)Re/XMX=aSN/[YQ
b?8\H[[_Y8)ZUKW#e@fR8Ga/e+/AWd+<&./D29-+fP#:V^75U>3+]XQI;@e\.;AH
dVDEZ5LOWeLe;B^9W7-<OH4>F2b2VFZ)6\UDdIN([8U53Ec3DbKd)3AC(R9\Qg8X
^=7=:?.c77L;Ud+HgAN-aVOcQV[_cO,>;=SN2=66RXM\d^WXB+>[P0P5.C7V@0=]
B\efH6X?F&4WT)\Yfb]^QL/+\F3=TYd4;Q#5D\Qe[>5ZYB/cQ7HN29M[J3R)PM8c
01;EaaD.Bg<]Z7QXXGIO3QLWR)=SQQ58J<a,aNZ,<NV;H=@58.@<\HG(DG0GZD?b
3C:eAf44ONZagHXBD76Kg&I0X9<CX##;K^63b=@8[PUbOb\?0Yg8)Z07fPF12;&I
E,(;)6TfL59G)R<S6U]:_)SR#bL0J)M5PHLVg_a_O&5R\7<T)ePEBHd&<U11V<FZ
5>@CL&@OSLRV\E4G1?AUO\b[/7eJ6#46&OLH,[[A1c0WG-S3DXHf_FFJ.I&\-d=7
#G_M+d]HLQ0,La&a-\^eeUB6\a<^-7eXM667_92@g?_S6X6<VI;#;Z>DN(=7Z0@A
P<.3@cT^,8T-V^O_[8-gAY]=cCC.a:WHB)K,EgK=+N(7=FT?7DWWT9_<1DPVJMU5
f;&ACTJ:L?TKSGRX8bbB8PXgC\;8ZC2_Z-#CD5TEM4,cVBZTDD]b)49TODP6]Y1^
+R&X96KF^5,,T+6DVXG@ROFg[&J3cEfZGCF8dSETD#-HZ)gA-QPJOUbVZXZQ&P5H
+a=1YRW+8PZ+F>079GR-8?MG>UC@+F24M:L^JTB:0_#BD5:f,T@6+G:\9>@BN^eS
2A-);2?K/0c;&-?.3HFdQ_LLQPLf^=a(^Q@Z/6VYX01LGWWMCF.1]f8[([[I^@K-
(N/^-d96^Y67^d?ME_&W.#YBEX@3HZP<-#?P1=dO1PV7#YMfMT[d=&)U(A30;&^B
5#//6D.BCWSb/]I.+FZLB?>FYfUJZKd9KB-@-7.dc+XG.]c)EfMG:+eH;<Q-V?XT
PDA5D^[I4O?YO:B-eS(1S?7b&Y[KeJ]HTUXSZb/MO5[AZV^D[13HJ7._;4Vf]7M#
GF3BRF0OUUB&6NGVJBAQ<Ec:P@\[]RgRR2VF4#F\-\ORS:1bG>NQSd4-fXTYHeL0
_Z6M(1MJdf?+TdRbY13bY=@VYd@fKI/^NSG4?CdMcKOMc\9Oa3)9RFSc1_@RJf=Y
-7WPA;BY;aXTbESEB[WO^aD<[;YaCN&/?,19Z8Rb0UD2Gfb-18Q:>.3@Te];SXR3
I4?60S0?.]aDEF^2_aSY^<(G\;I20B1GLE.Z.bUE2DUJ8SD.JD]JQQf)C)-<XR3e
?2T:JUJ6+_>YGXOMX7\8XV@#cH<#A[K+T+APRF91IgAQaZOS>2H,5T_&KA:73\Wf
GO-ONEDJ52)=>&L+IN2[J\X:XQOZW;B#PWC+Q7,MG_+-)[AUdb.;7<D2O0]56#1M
60JcXG.1SX55H7X5RaR<7bH]&[AH65ZCfL-]_+KX^2U0)C(.fVJVY:Rdf].)K:Xf
+^N.P4Ng1NPR.XXfY@:4GLU.U0Q,V]OV;&EFF2)F&3UeP^38Be\X(g03+_g0P_)Q
0OJC\BMbEVd.?Tg-H(\D;@Qb_N?/S42<T5fA_c\(bWJJL+C?d;B_=L)H,2(U3dY4
IT6O+c^,^d&;4WM4Z5GP69d[958g>)<^X(#dfA0_,@S&N;C(\IFT3c=_\NeBC(JW
dHbL)+cXK.B#V?1b#0D;67d[6$
`endprotected


`endif // GUARD_SVT_TILELINK_SLAVE_AGENT_CONFIGURATION_SV

