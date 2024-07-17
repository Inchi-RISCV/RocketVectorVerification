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

`ifndef GUARD_SVT_TILELINK_MASTER_STATUS_SV
`define GUARD_SVT_TILELINK_MASTER_STATUS_SV 

`include "svt_tilelink_defines.svi"

// =============================================================================
/**
 * Tilelink Master Status class. This class contains gettable, settable
 * Common Attributes, as well as any other basic status attributes.
 */
class svt_tilelink_master_status extends svt_status;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------

  /** 
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * Enum corresponding to the Tilelink Transaction type on Channel-B. 
   */
  typedef enum bit[`SVT_TILELINK_B_OPCODE_WIDTH-1:0] {
    CH_B_PUT_FULL_DATA      = `SVT_TILELINK_CMD_PUT_FULL_DATA_TYPE,    /**< Enum Value 0 - CH_B_PUT_FULL_DATA     - Opcode 0 >**/
    CH_B_PUT_PARTIAL_DATA   = `SVT_TILELINK_CMD_PUT_PARTIAL_DATA_TYPE, /**< Enum Value 1 - CH_B_PUT_PARTIAL_DATA  - Opcode 1 >**/
    CH_B_ARITHMETIC_DATA    = `SVT_TILELINK_CMD_ARITHMETIC_DATA_TYPE,  /**< Enum Value 2 - CH_B_ARITHMETIC_DATA   - Opcode 2 >**/
    CH_B_LOGICAL_DATA       = `SVT_TILELINK_CMD_LOGICAL_DATA_TYPE,     /**< Enum Value 3 - CH_B_LOGICAL_DATA      - Opcode 3 >**/
    CH_B_GET                = `SVT_TILELINK_CMD_GET_TYPE,              /**< Enum Value 4 - CH_B_GET               - Opcode 4 >**/
    CH_B_INTENT             = `SVT_TILELINK_CMD_INTENT_TYPE,           /**< Enum Value 5 - CH_B_INTENT            - Opcode 5 >**/
    CH_B_PROBE_BLOCK        = `SVT_TILELINK_CMD_PROBE_BLOCK_TYPE,      /**< Enum Value 6 - CH_B_PROBE_BLOCK       - Opcode 6 >**/
    CH_B_PROBE_PERM         = `SVT_TILELINK_CMD_PROBE_PERM_TYPE        /**< Enum Value 7 - CH_B_PROBE_PERM        - Opcode 7 >**/
  } tl_slave_ch_b_msg_type_enum;

  /**
   * Enum corresponding to the Tilelink Transaction type on Channel-D. */
  typedef enum bit[`SVT_TILELINK_D_OPCODE_WIDTH-1:0] {
    CH_D_ACCESS_ACK         = `SVT_TILELINK_CMD_ACCESS_ACK_TYPE,       /**< Enum Value 0 - CH_D_ACCESS_ACK        - Opcode 0 >**/
    CH_D_ACCESS_ACK_DATA    = `SVT_TILELINK_CMD_ACCESS_ACK_DATA_TYPE,  /**< Enum Value 1 - CH_D_ACCESS_ACK_DATA   - Opcode 1 >**/
    CH_D_HINT_ACK           = `SVT_TILELINK_CMD_HINT_ACK_TYPE,         /**< Enum Value 2 - CH_D_HINT_ACK          - Opcode 2 >**/
    CH_D_GRANT              = `SVT_TILELINK_CMD_GRANT_TYPE,            /**< Enum Value 4 - CH_D_GRANT             - Opcode 4 >**/
    CH_D_GRANT_DATA         = `SVT_TILELINK_CMD_GRANT_DATA_TYPE,       /**< Enum Value 5 - CH_D_GRANT_DATA        - Opcode 5 >**/
    CH_D_RELEASE_ACK        = `SVT_TILELINK_CMD_RELEASE_ACK_TYPE       /**< Enum Value 6 - CH_D_RELEASE_ACK       - Opcode 6 >**/
  } tl_slave_ch_d_msg_type_enum;

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  /**
   * This array field contains the config read data value of tile link for master class. */
  bit [7:0] tl_config_data[255];

  /**
   * This field contains the contents of master class Status Register. */
  bit [7:0] status_register = 8'h00;

  // Random Data Properties
  //----------------------------------------------------------------------------


  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * Defines the type of command which is received in a transaction on channel-B.
   */
  rand tl_slave_ch_b_msg_type_enum ch_b_msg_type = CH_B_PUT_FULL_DATA;

  /**
   * Defines the type of command which is received in a transaction on channel-D. */
  rand tl_slave_ch_d_msg_type_enum ch_d_msg_type = CH_D_ACCESS_ACK;
  
  /** 
   * This attribute is meant for collection of d_param for monitoring purpose. */
  rand bit [`SVT_TILELINK_D_PARAM_WIDTH-1:0] b_param;

  /** 
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the Logarithm of the operation size: 2**n bytes.
   */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] b_size;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the per-link master source identifier which is unique.
   */
  rand bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] b_source;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the target byte address of the operation. Must be aligned to b_size. 
   */
  rand bit [`SVT_TILELINK_ADDR_WIDTH-1:0] b_address;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the byte lane select for messages with data. */
  rand bit [`SVT_TILELINK_DATA_WIDTH/8-1:0] b_mask[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the data payload for messages with data. */
  rand bit [`SVT_TILELINK_DATA_WIDTH-1:0] b_data[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field specifies the data in this beat is corrupt. */
  rand bit b_corrupt[];

  /** 
   * This attribute is meant for collection of d_param for monitoring purpose. */
  rand bit [`SVT_TILELINK_D_PARAM_WIDTH-1:0] d_param;

  /** 
   * This attribute is meant for collection of d_size for monitoring purpose.<br>
   * This field contains the Logarithm of the operation size: 2**n bytes. */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] d_size;

  /** 
   * This attribute is meant for collection of d_source for monitoring purpose.<br>
   * This field contains the slave source identifier which is unique for an in-flight transfer. */
  rand bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] d_source;

  /** 
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This attribute is meant for collection of d_sink for monitoring purpose.<br>
   * This field contains the slave sink identifier which is unique for an in-flight transfer. */
  rand bit [`SVT_TILELINK_SINK_WIDTH-1:0] d_sink;

  /** 
   * This attribute is meant for collection of d_denied for monitoring purpose.<br>
   * This field specifies that the slave was unable to service the request. */
  rand bit d_denied;

  /** 
   * This attribute is meant for collection of d_data[] for monitoring purpose.<br>
   * This field contains the data payload for messages with response data. */
  rand bit [7:0] d_data[];

  /** 
   * This attribute is meant for collection of d_corrupt for monitoring purpose.<br>
   * This field specifies the data in this beat is corrupt. */
  rand bit d_corrupt[];

  /** 
   * <b>NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This attribute monitors delay between immediate previous a_valid assertion to a_ready assertion to enable handshake.<br>
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=1.
   */
  rand int a_vld_a_rdy_assert_delay;

  /** 
   * <b>NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This attribute monitors delay between immediate previous a_ready assertion to next a_ready de-assertion.<br>
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=0.
   */
  rand int a_rdy_deassert_delay[];

  /** 
   * <b>NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This attribute monitors delay between immediate previous d_valid de-assertion to next d_valid assertion.<br>
   * It works ONLY if configuration class properties slv_delay_en=1.
   */
  rand int d_vld_2_d_vld_assert_delay[];

  ///** 
  // * This variable Configures previous d_ready assertion to current d_ready de-assertion delay. */
  //rand int d_vld_deassert_delay[];

  /** 
   * <b>NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This attribute monitors delay between immediate previous a_ready e-assertion to next a_ready assertion.<br>
   * It works ONLY if configuration class properties slv_delay_en=1.
   */
  rand int a_rdy_2_a_rdy_assert_delay;

  /** 
   * <b>NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This attribute monitors delay between a transaction's a_valid-a_ready handshake to corresponding response assertion.<br>
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_cross_chnl_delay_en=1.
   */
  rand int a_vld_d_vld_cross_channel_delay;

  ///** This variable Enables same cycle response for a transaction. */
  //rand bit en_same_cycle_resp;
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
  `svt_vmm_data_new(svt_tilelink_master_status)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new status instance, passing the appropriate 
   * argument values to the parent class.
   *
   * @param log VMM log instance used for reporting.
   */
  extern function new(vmm_log log = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new status instance, passing the appropriate
   * argument values to the parent class.
   *
   * @param name Instance name of the status.
   */
  extern function new(string name = "svt_tilelink_master_status");
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_master_status)
    `svt_field_int(status_register, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_enum(tl_slave_ch_b_msg_type_enum, ch_b_msg_type, `SVT_ALL_ON)
    `svt_field_enum(tl_slave_ch_d_msg_type_enum, ch_d_msg_type, `SVT_ALL_ON)
    `svt_field_int(b_size, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_int(b_source, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(b_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(b_param, `SVT_ALL_ON|`SVT_BIN)
    //`svt_field_int(b_mask, `SVT_ALL_ON|`SVT_BIN)
    //`svt_field_array_int(b_data, `SVT_ALL_ON|`SVT_BIN|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(b_corrupt, `SVT_ALL_ON|`SVT_BIN|`SVT_NOPACK|`SVT_NOCOMPARE)
    `svt_field_int(d_size, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_int(d_param, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(d_source, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(d_sink, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(d_denied, `SVT_ALL_ON|`SVT_BIN)
    //`svt_field_array_int(d_data, `SVT_ALL_ON|`SVT_HEX|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_corrupt, `SVT_ALL_ON|`SVT_BIN|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(a_rdy_deassert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_vld_2_d_vld_assert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_vld_deassert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOPACK|`SVT_NOCOMPARE)
    `svt_field_int(a_vld_d_vld_cross_channel_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(a_vld_a_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(a_rdy_2_a_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    //`svt_field_int(en_same_cycle_resp, `SVT_ALL_ON|`SVT_BIN|`SVT_NOPACK|`SVT_NOCOMPARE)
  `svt_data_member_end(svt_tilelink_master_status)

  //----------------------------------------------------------------------------
  /**
   * Returns the name of this class, or a class derived from this class.
   */
  extern virtual function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_master_status.
   */
  extern virtual function vmm_data do_allocate();
`endif

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
`else
  // ---------------------------------------------------------------------------
  /**
   * Compares the object with rhs.
   *
   * @param rhs Object to be compared against.
   * @param comparer `SVT_XVM(comparer) instance used to accomplish the compare.
   */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);
`endif

  //----------------------------------------------------------------------------
  /**
   * Method to make sure that all of the notifications have been configured properly
   */
  extern function bit check_configure();

  //----------------------------------------------------------------------------
  /**
   * Does a basic validation of this status object.
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

`else
  // ----------------------------------------------------------------------------
  /**
   * Packs object into the bytes buffer, based on the `SVT_XVM(packer) class policy.
   *
   * @param packer `SVT_XVM(packer)
   */ 
  extern virtual function void do_pack (`SVT_XVM(packer) packer);

  // ----------------------------------------------------------------------------
  /**
   * Unpacks object into the bytes buffer, based on the `SVT_XVM(packer) class policy.
   *
   * @param packer `SVT_XVM(packer)
   */ 
  extern virtual function void do_unpack (`SVT_XVM(packer) packer);

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
  extern virtual function svt_pattern do_allocate_pattern();

  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_master_status)
  `vmm_class_factory(svt_tilelink_master_status)
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
L#O5,f-G^R^EdeP79-F1Y._Bd.F)K[,UJGL9O\Y>#A3?)@#NKWV/1)(TDF,11N3(
^X^UE&PY;GQB1[VJSV4P9_;A6AJe6S6GCdYfcaJL0C:+.>PX@EB8/KOW1G=gG=5@
7BF]O-ebD\4+3/19D(N14IcHa?->fC<@6B=K]_RQe7bP).X=2FdRgF3c,W.Wfa16
ATE+WJLV0#egGHRcc,gCZP0(A]SR(C]ffe&YJQN,JTEd1>c7WP/2F60]N&2?N<;G
EaB>9O?&Td^+ZV]TV4P_MAFQ4_&9f1J22a&0f&L[g@L#ZBP_U8D\5AcSIXfE/?#c
KAC+R?e0+Wg\IH01)4H6Q9Sg1YHQgDYJ?/<Y9PgWJeF);S.Mb(Q]D;YcI<]3EL8a
6cI]d6#=AFS8#5dH.,U^>NcJ[R2PA_T;?T>bCW9EP\QdQ=5?J]Xg=(@S#:VK?;Cg
E/52-VIfaY0V0WC.W53VXG41ZUJ)6QVD>fQ[?NNYNZSYN5,&Q++G#1-Vc=]^(OaC
1C_Z[IeR45BYG4L)Z0AeG:e,9d)0ZE74^d\7g<W)1b(eLI\@EDTD(B(YFZa9@C5S
)-(3IRLTUKUDASOILP8:bMSC\P?9ZR)=\@T+4VXa8U3b&X,Z4Sf;E[a^9/a?FRKSV$
`endprotected

   
//vcs_vip_protect
`protected
;0KBgZ.HEUc,>e?]a:W3bW@(LX3&&[B&7F^.+OE8ENgXO@IGWQ>1((+H7D=6gN-N
C,8VGDgb-=_:_KeZ^b^^=7gcHbHb@e:E)#MUgdN7B6GeOf>;Z=52M_+8U\eIcOP2
f3+XWY&J130QLaH&<[PWM[7TKTJI_CN(Y7[1E-?4\/&]^a)7UD[XKP<gWOOX3J\I
0^NgE5=01AZ-7H?aI0a>?T(d([fCLe@?,,@.>V5J/(:O>1adTS&:30/@R9fc]bZN
+Hf50aRFW+==I=L3?2U0NFQT?QC=D3:Y<^9J;^T7g=E@X[@-WQ1@E_6-]<a/dI;Y
]#\GSa09Bc9Ue2?Z\Bb?_)f]BDV7\(QAXgG7<PI;;DZX\&ePK?[FYcRUNQ0+Tg84
M\JCC.DEfYRQSP^)+-c<B/\A,c5aP6CU>,E=aCcIUF/T:SP=fQ(O@Cg)+8ZaRK6@
PKbUR(?0/cWc)B>UaBAAf:/ac<Q1&Z-,&_Vf?#8[\0K3XR45M#Q^YFO6Cf&]:P>6
CY#O6WY)BL22TIcfJ+d3S.I]=U[,RS0;YTM@3J1C=a?8/2-+LW<,;WgPW;+GI5_E
I7/EH^/T6[MOMRU-,QO0]7T-_9-bP1-EM/5f&^H_8C_3[5M5dX2@FHVA]b[^Zd:^
,TKb;L3M@E3+IFW++[)5>aO+2BIX5AXTU9:6MBEW\1[OSefJ\7V?NZcUa8BFEN7/
faN^/2G#)V6P2\<BQTD(6&\&8S-JN-^:61dTG3/E..fT+:([;V5<M[93F1[A\8XZ
LfSZWA(a9\c4AEg=E>@9Y7ND?@S.#A4YN;RE2bF,0:UUIEDPI1P;WB-T\]Q@QaRM
V]E),4CRLg#:c/4+.dPdW#JI:;=,YKIUW)1Ja(J@QePKaBNQDY5KRCVQ;d)]6G.U
UEM?g/_H.Q8O/:5c)>K+V[B;Fd/a^PKI[S?\gVIK-0?Y>1EN-TT?Md-N[3(EP.IN
06<0#IVWO6dgD-TJ2M+9MMd[gEQ&d).f5)0)WM<<H3b?[)0\;_g).Fd\W(\I,4/g
_ZWDT#N;bf0,2[GW<&7#.,>aG.)&48?>RPT76I2C3T1Ba@TeCQ<b-)7:T<SK/VYH
6A=60/,SRRBHRFFOU7Z2eSZc=3V[dP90I)WPgXKd5,=<9OW3OH)(e8\L]<EBEB]5
.4+\PLNdAG07[B?>M30D&BV92DQB3RY,33?T17gC\37D/De.gZVL9d?AS2FW_2=\
RXT./G]7N_E::ZEP9KNgK35\60DN[J3#1];aRHY,U5BS4UWX.KJ4Y;)H3,J&>9)Y
2VC7IUF\#(,KU[M^H#3:WDQ>ZJRd(3D>EC#Z3bKP<O,/BGAZ]S(H:P0WP]5/>+V\
eQZ6>W.E74VcVE8P6,AB,#9d1UW:e]BM/&O^>_fB1[EC</.NVXd,b@^^PI?,WZHN
60XH\[74Z>U4L,@BPYPYbHUd?^f+A4DN;BP7M=AIB>aC5VU[B?0&X^ZVXPbdRU3f
]GAP#Y3eI]#YEVF;TTI=)(&/EJ,W?H/6LcE,R+R6>/gN;OD>?X1NT:bAeGJ4aDb@
dfI_EXGC05FV[?H.f,0fP.+[[/C0<D\cgMAT;QW0>Tcgcd-(9DKCd+CD-,B_;E&=
#KKQ(cJe0VR=^_UKbaF\1+N]><<Qg<JU^YDTC+_6_N@(<V4D/540a?E^2C:TLEN1
a[Ne[KCcL8#/-&T.+QI<a057STTJEW@I6AUAC,:WL6a71f?@?<-3QN#]=Y9OZM3S
FdH>WF<03V99XH/+VRUUE\N.9/GZPDc&c3\c]>\3GI.JfDKc0WF8a7^aKV8XS0<-
JQ4A)=]4T;aba7HQHH#\90b>6<)agZG&HMDDJ\3NB&>P?CWc_YW7=T48a:BJ#DG/
3RH6HgR]C6KU]M//8BJT:HK<S&A7(,-dD@T(<D29I.Dg]3(<J]CadeZXLWcJZ)e]
FY+C,3Z<Z+cF(X:IWG-Z\-T.>WU;P@=8?Ze/)b+;ZJ8+W4X&)6?N/T<75O,5)WB:
D>5^,#I+9]cNFf;MX8CfA\:R-XbYX6:38?1M)>U)/M^9E)87[a(O_(>,+U--=E77
>]agR<6^<)[dY&ULgf_:Pd]e2</gD35dOL8b2^IJ91<>F?0;O@].f.4?KRW0##g\
f1&P\R5\IF489@B7]K4]IVPfPcST/K+WW=abQ;:5=U[4)bCdT07Qa68+3N8>O;:@
UP>-D?D2DL@L/Y_6:HI+:L<WfD@D(77#=_F=4?8fF&FFD6I9>N?OS9=.e-YZ4W<4
R?2239AO7VN5+L9?6FR)O+MH6:U:<83K>&&+&6cA-CFS/27C/gZVB@ASLa,b)ODF
\R0dR2H;a-e;<LK\/(1Y/UP)GOaW;N.O/1F:^C9NQ?L_gWN4TPV#U;]RGa)))-De
3&CC:\<c<[51PA=3c79.#:G.:>BRbBUDQ8PeB0+(UDR\d9Q0.E6+QL^#I/6eM<N@
CBNU@d8SRf[Q0#ZgD36S)8-#J-5FJA?P[]/?\?8_dJ+#fIVXU1.gb.SaOa5/,#>5
)Y)T9BeKH,KU1JR-CfA=[E2]<FdU;EB^9C4)&G.fMZ2\>@919-+#F::3fc4fB-A#
S)3,1^G]gTW)C:INLEL2JVPVD(?ZR=,\X?CZIW4e78J:UGSJccB3>CR]8)d+(@3c
]\X>P&DBcSg==)H/QMJWdLfQ)APbX+:d>#]9S+_70[KQQPA0E&cf9US)fEZY\<^N
D9Q2CNgGJeDGW8LA,R;U,Ibbd-X=4;+Ce_H2V5VYcI,QD(6\X8AP4[[_Z.^L:C.c
HL6#^,9E+bKEW6EbeO<O],G(_2A3^:^()8IU##-G@SE\eGUCKdITdYYLZLA2cefC
fa#Ke@dIYGST<))<#<,@[&5Y6,]M6HbMKY>55CCYa\#PK[AI,0;>;a9OOGa6f769
?BQ=9^=5F?9fDMbfH.5P;R(07f[IOO-)JIgfT9\^bQ0UGK_+eJcL#L+;bNXc\TK5
HcX0f/e9P1C750KGLPCcePMc]MS8?W_LF9THDI1.#PO9I+])g:ac[6>?3BO-8f.S
T#B[?>eObB/1<Z@0O);QYP-6WfOe)ND35[f6d?@g=J]^HDU<@RgPB3ZL?8(B:;Qb
cH&:<>B,b#>G;XTS]7^eT/UW0REEe.Mcb&MX[R-^-9X3639bFAaF&PH)?LCM#FLa
Df;E.GAT,)H_@6#E#7JC:9E5=+8APaZc8FPHO@I9_b@DaPe?a/MLFNAbR#/&BJ37
Q.GF)Q+QN-24;b2M]3-DY,\]<[#?D4eP/@#-Pa84T?(3(.:?fgFW=SU7.1YUK:L<
<^(8V;WN.g],FZ[S0.M+4.L7/BKQ)-UW1cND=6X96&AZSa00=f:5AA>6/-^UY::8
1d91IGfVM4<^=Q;UL=eYB#;B)BT6Z[KMD&[3fH/.<EYL5J??a0\J)DE#&R/_ab;3
\GDAV7:bcQPH_aCJLbX07=)D2,GJQ,dQ34e1,CKWf7>;3]@^F^K?#,)FA@IGE\@H
^E?O>,G8]/deX5b9>.G_aZN64E=9REFUc8)b-4H&gG^NP>f4&MfI5#>HT1-;9dKO
_OBOd#T^C_RYP-B4Z;?UJe^#WCU/QD0QPFV8<A-^?)#+H#JXYV)Z<+2^\ES]0EK6
\09^<G2JDc+aXB8L?MH6f;)Q&PCb-c1K?F.VF(83YCJ=6=3&>dNKT@NNHBZ_HI9R
T)eSALeZK2G_dK\B4L^&FL2HL-:CK6UO(OX)a=0TLV.B[HS3I903F.BT>GMW)AZc
A<f3RL(9#T^,_5OVRWd9G/>R((WE9M<:Q?<O+S?cN=?bR3(^DS=eM81:X=Kf23-[
NW52QaK5FQDec^;G@#?MLVOZ<0FL,(+8#:b7#VUf,a&e;N?G[YeJFK<H?N:E,eM-
47Xb#R3OcFBK3)D/Q29:K]eO]b[QV:)R9cYUKf.T)UC\1NDOL(0EHB=2K]NM&Hc?
A:S#//>-b)?gK@#IH/AHdIJ1cOUe+&];O?g?O10g+NJb?1QW^7#>Y5M4-a/KGNOY
)?VGUX;,AGMM^)3bdM3G=Ic3+N=[P=ME)N\4=);SCN1G.4/C,fM56,33Q_BF/Le@
DfY?:QMITA\2]K<IZ<MUMbZd+KZ)fRX6,1<2BgT./g:X.f;<[O6K@I&cT5/D5:0;
.N&]O06aXS-IXL4T;0P.(DN7RAf4,JNY4?7?FVF>LaI6>,]MO9\Z<C-JJIGF<AKV
<Dbd0fZV/ga,BRgf#DG3[]+c2PNZEbLOdEJJfbVG[D\L_e3-V&/;L5gaQ)?>KZA0
:^=I[-5<1f^&gY;UF2]39Z9)Z@gOND2-5fM/Mf?+K#@e8WR6X+AAV2YUc9<;:BgH
FMPQ93dFKT8>/?Z\1H?W>^cD0b@L-TAA8#b=7217gC3]+7U]Kag(DR7+S)FPAB/-
OJDL@IE(4[AQFUOQ,a@]\388(,AODIH=g:XA))CO44\dV^F-d@XbP,a-:-Jf8(b>
I4JL<@MM-:a5;:<0EYCdAeD+:_5D#<]&;Z-))EI)PJNd;=bP=J)>YF=d<>5HXTH4
fP<IQdYLf]#=\\\#++G#0Z_PSBU8=9A[D9JCGAg\^b;L:=:H8?2X8U0-eY:0:8gS
VMSdH;6A^XV6Fe+VJCV+NJ>Vf(fXAZ.>^aeNe8D^)0fOVHc.FOUC8]>OYEHI6(&:
AW>SQ<3d?-HU0d,&3>RUNU5M,gReUYg\ZVC2^0Q1N]aR/&NU6PK@GNg37,8@_aa:
-^CdNNY6e;f_SLJC5]\XZK(05egX]eC;33@TG44:,b\4\22KJ8J:g86?.I(A9?GV
5Q(RSX305GV#L&#g4gfXFcKG4)F;A^(1SX)-,a_./3/10+fHJPMS+A5N=3gTA1LJ
3^PM0eS=V^(6/B0\HgDe)H>b.=Oa[CC-#RGH:?f;X_^7Y1UbEY>f/aBcRWSd&XO)
+A\>fBC:Z_B-WXM)>c?-=<;a(XB4E^)Ke9CCM4C>PWJQF#g11Of=;HCD,+:]<cG8
]^\ULG];bT6]EDE8=N4LD82\,>K[:US7US1[JP/.aT/f\e;1I+Y?Id9)_bCITHGf
G?>LT(H\J[&J\5<Z<=\OZ@N=+,YbdXLQ^O7IN<ON:P_.P>4&Z&@8,KX02M7XW>d)
)\Qc,]U7;#0]/b:.S-W6CL7H;^DPK@J5?\&,7]O9+869#<2<04K##:O/bEIE0_BX
GQ7)B8LJ#(C/+U8]E6WESGE=6U9+VAPHd.+XWGb8]EEFTdf::&2E2VH[^OL[,(3Z
DJ0M66SQP7Va=;]->\9K5Zf5H1dSY?(f3JUC;SB?-97OCS[=;)g6cc<48>52_).>
C9<HHbad1X<?\PL;BDH/FRVP9)bJ0J709R<=g[<TTbL5H4&6J;3;]?P\5/(g=d/<
>\GG#>(,H9:_U=B;?D3J;e8QW;>^bE?gK.1.V8;N+4>A[8#SET:>L>+(4GN?5JAA
8AFfdDb_TPY<BYY5>W43TP(Y>6f&6Cf0(5=+TG[3^O9V:)O>XDgaO)+V-UcVQC)#
;3XSTOcAdcRfZWZGdV4.JZP30I-MQfOD#D-SGeDdBE8-;Yc+@&9TV0W>+#_D;/4^
d5&6[9L^OYP&T5>YN0a#B#V3P/WG)[-bNVW8:YcG2-L1P2W4K(I11HHQY<Ib@)<]
\U<O8(2&e)V-@N8]a+A+/_^6\/0VZST]FMJe59N+@T;&R(E<d@R+U\;G&ga/:[[>
aHLI:c9I0@E3+JHVD_I@Cf<a[F<?;X0DE[4_aM@4]BC^N\D9+U@[M@eLN<<We(4_
D^eP-<L>RV_KMd3GebG3S>VVB9#8]J),PX,G,c;b;CIV<Q>YI=0eJOZ4efY_[PMO
67O#;9?(\(dAD8#\G#^gFYWC])Q77Z+f(ff99A((<9B5UTN6c0gAG1A,P(7XZ-4&
N8=#E69_[_7I<b)e:S=NgJEU_#PZ4&N:\9<XQ<],YcKR@/_2QI31d9H_#IGCXHbF
GUG5>#@IVRQLBJPeA?UI=I#9g5a>,=@^;5Y>76WE>bC@L?W)>I0L#5^f[D&fKW\F
e.GJC4&Va6?[RV786#]Y84RZ\?)HFHTR6MQGa\>/Y#=d(#dD)27G>UHC456[AgRX
[[H<^J(T1P,M=-\\gR[\MNdEf4#C#Z5gSd(<?cHK@U\].\Y/-C7FWU>?3TTbS:+8
+62<H=:VH)YZEHf&f.C0O1Lce9@@?^5=[;f(L1#H9Ed6/TU?:J4:-L^=R:0Ke^45
>eI9.]=F2ZS@:-LYX#)0B1V;0Z^8^Wb7b<O_7<ba8c,]+J4Dg3+_UOOK(8A4TL]F
(>KaSd\\F)7?3ZQBbb_9FP_0V4LgEM69;>G\2I+=A)UG/OQEUL+e0[KO@AR7IGE3
T(bK+>RU=?WZ-Z4GV=CO1G8<M,V9.AN?=;gHWdVDZLIM7C@@PG1>.W0=5YT(b@S@
WOAIW0:_>8-XPR:\P:20/5;g57C<-a/+:J;@+6EM#&(P(6=V;Wcc2V[+eXF@Uc48
^8AL,([VBAC?>__I081(>1@T5436::1&f#[B]5(==F2,6PSZV:@aIPN;=4,4gVeE
:FRYa)&SGLNJO_DVU=@_d#O\_T7)E].(;<gCD>)fJCDC/8,]43gDgVIL&af;e]K4
9)FS_)J0HV-=Wc>8C)VeHA9H\U8Q0>=[,[#JK/\4cG;@Z11JfEAf&3e6+::6K)P;
bcTY)0DNg(,@&6IC=I75:H6FP(A,))-c?(L2&#NaPWGYSD6YE>8KC+)69c)RYSba
d[^9&UV4T6X#F][]<fNTg9bWBDeaGK+TXRb:Q#))<P]3N+(bJXR(X-EdFU73::@#
_a_d./-@YNg^N,.G9<&2,/OeBW<]Y@Z@U^1LaRFTFF\.@35U&R<ZYF0=f^^)3,DL
7&IO\4;caE&+I2VD]P=O4[,B]?=Z/AO;Q2-Y+]>bKFXWZ#]g@JB5S0[=V46d[N+A
-C[0b-:W<YSbPIZRg:2\(8&_QYXK,>ECJ-]MT9^9?P+Ae8\6d12&[AV]Zd(:GHeC
F2\gB?]9FY<9DLD,F_dDGR99YR6/=L\YeN@FO6B=W>[T,>D3\U;dX+78)N4>He+0
HM1G_.aBV6UVK7+_^JIBN^+&G)#3?W[Zca@@?/D>^QG9O>AdbO,07I2;ABY50\^2
,/4F.K+A<e0;a(e=gL#O45AQP0#0a2c;b0Q/15Y@dO)<W);XB[gFI_L^W/&H#)5W
[5H&egZf]+[+UR1-\Y3N;M_-07<]4)C[YKV>eGNHBPKJZ6<cbJU[^=eVa?A(4NR+
\_X?O]79H5BTT7HG3];#EO]QC/P^N8#Je1#dFN1<F1T+)5K<YVJ&e/33f@KMXKf2
/\U#K^OL2Me[BG3a=NgOK:,MMJN:A/IbGK0QS](Q72>?f4SLcNd6YL^RP3&g1C0+
A=Zg78?2,(PYaP1VZ0<OBU]Pd\Q2f5&K=]3a&H5WH1YNB^;YMB6F+G,ggPLBAZK]
gIPF2+AHcf]XH^4Z7Xe]ATdENF9?g>:.cZ8,29A\.[8084b7:c)AMe6ME&6FPKU_
^CDT2/_#b_#c&R);9+7b@5d(8>SV^AeMPH=00cN]]b)/LEK8+TPE1;-M(GW,VYK<
UV?BJF_Sf2.0W\15NSb&@HFRFK;,&3^\R=e7/CFIO;5BJg0,BQZ9B<IS9?+#cW&T
e\^Q^:gC3P3^DF1[JcAfMIe@5bT^_[\ZI[EYP-=:YC)S2HeUIIRR2\-Xd@2)<E42
RbYe?-3<(?_T,a[A)Td,)XGE&b]0AHAdW4<B>LD:[9KC//AM(6NWE^I#+#2g=T4R
=L?XKJ(0b<:-gTN73X4:#S5;E_:F(U,&(Q6=a&QZ-PQMg,Rd+aM9b36U-:MS@SX)
Ke33/c5#3gYC5@_;DA@Gb0GYQbY[U9)C0<)[PYF<2R\b\70795#CJ\SXO,d5.E,@
BP;/B1KQHF^?-)9R:(N625[6a8Wa?\HVg\:R_M_EY1]c.7f7ARW&PBDeAO/cVaZ#
CabI.3A)g_.Z+K8P>/#(AK+7\bS,3K9Z0-YeH02g?+3;/gRWC;/KX/aRF>d\AMM8
7:.9.-G\C[NUGHK6@<TOK<\gVOUG&]?9]?Ie8ZG2BO=YS,6^B+3L0>Z-YG.1;K7]
B9Pga#1a)8WRdOQ>NPG3=5APOWT=_5KK&I&3A[48aB3V>d<AV2GN14KPgETUg\a1
>=#828(/-NZ,..6b1f+P4K:F++f0)4C0/GPKP4^X-\E5[A?)G5;BNT1#8(4>T?T4
KX4@SZU2\aU@Q2#=)DG,[OQ.GW4;@,87RR=T.Xgd_K\_O_YERD&M4ZFe\5_H]>#C
B-,KVA:U(#U)>X<Q<KPF&EE++HMRXXdV\=+_[;J/R03GYD(L<:CM&a[G8@;P<NJ#
;f/51LH5cQ_fP-QUaV<M.T+0FV-+5C]-#Pf:)TLE<)Q6NN+JfRS:Md2W^ZL+O/=K
gK=P<JQ40aP\5VgXL_dDM<+,TS:=#O78P00>._^TT<B6<4/ZP&fV<_N+Bc6-)19G
4O+&KZK/&f(fA].S;@1fe@f<,\Z74@<.W-V/3B6[1^K>UY&OcC3^f_BPaeBOaO[3
LJ7R0,(#/L>4_T3Y]7,aF_)0>dW>T>^&-M-H1+:<0_R>(2FCG+?)RXVaefG76#K/
[^K-Td@dWNR6:eGCe78W3+Y3g0LIQ.&9f<KTI.LPfQAR-HD/M:P^(^8@N5B,+^@X
[)YM+WP4VL(cA5TZNEVQ+K9Y_T/D#RbKLGN4_TPVF(b[[+LJW4K43N,6+9UaRQQ)
e9R3/E_T-0HagZHg<g0H6Q[55d0fL7#AK25P\bCI+S>G(Z-X>WOgZXa([6-eZ0HG
#,[F>;0)KY1^fL6)T<Lg0/8f,=9;#T5-PXK1JO8J;eX3LbB6LB.MLB-.+&f_?DC1
5\):R=Z?ba0/(9I-(g^A,,=/:6Gc_=b=XH,K+de1U:;D,89-\R<.]8-)Z:=R<?2:
ZM@eZ0f84+/Ma8A>YC(\:P+GA;R?_Ye7\^4S5#U@PgSD+,E;a\[S@GcBB#^ROS@?
U-5K/HDFL@HOF227NL./?)B_G_/HOVdDIaA[80>0\/=cI+<-0/0)@6=/[@KQ#aD_
,>-7M\ZgKT/G+&W-54?KA33d[L;-0IY1F<GQeG3?BJfA<b577M1YMJ<c_>RD53g>
V(T4EOLDcW+8-5\TB=cHBVC0BbS,c=ATbDNB].K\.f=OU@Kc-GRQPTT3]BG>e;2I
\5Hc5f_dL>A(g19UOM?Z.ZFBC=0fCPG_#.Z56)&22Xe9,&.5M5GO43)\JCEDa#Fg
2dd1:/ZWETX8439J92H;GJA3e.EN4a>b<1&5SKbC142IEN+?0()\L2OIgQ;^80A[
d-S?a3#RLCba]>=J/TC:L:4@(>AN]E6EGD_J;Y/K&9NFX6<F(H</;8C1V7g=XUX2
L8K;VTbeeG,c1=<5c4dB1):.NV@B[>?L_>^QGb<]9BPHBO&25A#CCVEf,B.<TI7D
]4NKfK\I^0D2,RI2\RI@HLJ9PXYU3bX+3]?)A/VBR?86a;4SRa\6SCfAJK;G-K\C
YaK4Oe&CP3IY9bLR_5^:aRbX;V^^dfCcXcfcRY;FE_<;NUW@)?7.cBGX)[2\eVMV
X(;TeE2bM;D>,?1JJf6CN0=E5e7<@&=Ug8@.C:[T[/:2J<LHJE:VH;4:BN09V3YT
PXA#?__9CA@O&,9+K,L_YD^1VXeIZL77Q;P87^1aaPNS&)#Wg/V3>>DQ#b:QU.5)
53+,T^C:_T5;]d/@W0+\[,<;+WKN,8gdTFO@72TeV23DaDNfNf(:1I,09IU\^W\I
A.XA2ddS_E69N10A(EcRRGJDgS:0SL7^@3P6V6^+c:eH8ED5+G5#ENDQNR<BL+La
HZf=Id;I^:e?F#,&[J6_A1FaA<2V&QN[9U0N_Y[.-PES:DO_.MY3Z)G8ED9036fF
.440:M):g.S?.M12UZ28-</Q@@_2L8?M<-;]CK[?XS;:F5(2T/eTLK?Q)f:?LN?C
3^ZdF3+c)[EQ4d<4)J[c@4gb:NO_VC?bJ,)=0BdT-DF7BY3OY[+c5;2SF<JE4.AE
JX762.bd?:H^J#<b,I^P]TCQP#5N1Y^+=G?H@0e\VM[UI0dcE55B_S<QH6I&EfEN
1b)-Z5>NUQ^ZF;U&.9+.1fU/3HUe91Y_6=0Jcf;@6B.]b;&NKPbYBT;>=9Z51bT-
\7<^HU8M+c0^R(<W:OZO&RD51=<M?(X0bVYC(@N#BMZ<E-3O6&N6UOJY0LU9XM_4
U+#)R4@W&[].3GGbC^cHV-^\QSMQfW_:RZB;;26<(LKEU[A6f:JQDN-EB692WJ67
^+g+X9/,9XLY0-e<:)4<QEDF9P]aa6)-PTX5#(H([,S45Q;9dT0f>.2;/EcZF,Sb
R2<bgHO6@;:A9=O^R4C5f4&G93Z:Q_W^S[Q5cf[.8U,8J(7U;gS=aIO,B]XTDX93
U12b:]FX=9H&Nf4)f+-R;WR;,;_P>I[G&-<C[U=66Sa.GC1FUdS(#[.B=BL-3Y.G
H4EKTa6..D9^N;daU>S&gU1&)51I@dfF4.[]M-D6EIK&.Rg4DfeYI0RKARH:DVcG
?[cf0EW?4C1I8FOY3E:=YY&4EdUENcJ)MU(CN.NLU.&4YMgg-,9KfH0>&<(2&CWF
R:TeA7[K6^fNGG]TH=UA^4S,>),I9a60@]aJ#Bb=3CB#5RWKRFFJ96;1E0&9g[5/
TDZ80QH#a?T9a#C47<6W#W2L8:)S0PL>f>[?e6C22KFNXDD4LO8@]U8((6e4Y]EX
\VPCeS?E8VfHTL&Ta^J[25U5R#\(Eab[3a2.8^Q+MYV3:cW--/RHA]YO7JPd9CW_
<KC>6>+IE,I\W>HEE1e35,5B46[+R_1gG3@X)[ZO+]&=/.>Y(b+#9(+?8fQ6e28d
bV4R[e40UD7Ea^8J3+W,C#_\+)=&RgD1?[#L[JYaU;\UYb=]QaKP52N=Z=M#(&U[
B^HPY0X)XE9?+RdP4HYcDX,Y^ZOQ/UNA\bV8(N9EJ<_gN(.8JT\)X+^YAKG8bEUf
)S&RB863M(FDTf3QD]?d9_[]@EbB/4E7((#?FPS\GO2S)/73f4[>9C8^]1ID:304
fR\>7Eb=e,G-2H>H)^2gA6-G7eK<1)E>A7.WVa>J073cX\@3\(8AX\Eac[+.96#E
#S]_[f?SW>_SA,#Tc/WM9X[M?SM7a/(B/^71a1A:gDD)E54a^:6a1^P-=S4-N[GB
=)4[:8#DJB[502:eR:A5/;cE4#T.cTa3^&a?-bfeP0B?2#1)MC\+Z?dWJZ?4@1JG
b8#\);H,/IN[fc#a^G5aQO6Gb1dQ)0W<QZLgdcX:B&^XG0>CE_U1=R[RL<Wc\7#U
\Z#)@Y,6H+>:3];=W&#/8J?(C>LG#^9/,>&(3/9gc3Q3_e^75O;G76TgSO+D>RKd
/;EG@^=7\=B2c:XPIgUgCBJP,8ZL_(P-9)[f0BZ\P2-5N-^:9WGNM-.+T8OA_&9c
?3\3a)Y^DbX/Z3/d(LI]HaJaDgDRI\(La9d#_[.3X;/<CW_,bKZ,4)cH<ML0bDQ[
_Vf[@CO5\:SO]G;b-[J;4^I#EO9S08(TU;N9NT.-R(dc,80.)P9EZBf)1OFU)A)?
)LcER45A7TJ=:>MX51<V1?XG.49FS<-WFKb.=e2(b4HEU/2;ba2F[M<QL11)RWX)
c>(#=)<a+31-caa=.7;PU1C-#P)^B,9NgI&1&b5gbb0-G/@D<1FZ-/O3B;BHP5(&
P6>f.CTI,XE>Uf56@+UWVQe1YYKcSUb.^]3SF<g7F]@a+2#8#])F\.)U)B]+H=;.
bQa2IaTA2Y-VNDMAFV@I#<^C.Y9WLed,#U:4gLWP\GbNIXLT3IT?+];fA,c#2M]&
fM\FS[_L[4fM#OF+9aA.,+1ZdfAR<OJ>,dbU&[\)HQ3_d.Q=W\RVXP5Ha];OdgCA
b=F_/5<DA14][_9/QeY(BdHdff^5GJ#;^+5g5F.GCC@SWK]M@H/;U2-3XS&Df.0<
Z16bf-RIOac[EJ+WSLfO62KNDFCGP\TUa7XaA#g9Z&C+B&J21&HP>d?9O](e66ef
0^):Bc2:8SN1-WUOb:Q>f?Ud##cBWO00AH3a3#c@72Db&])c[9QJ2//&ffPOdU<)
>FE[b;aWK:3FcCU@U+:(F>U=&\\<dMQ9N,FT:UaYU3RdfRH[JDRB1;L=^>B@dLP2
SNQCC2W))?fG#1[&+X:(8-HDPI+IDN4g\0<P8RKbg3G,I6QNRGB?Q;9+KE;]GJY<
dg;9,:_OSPCDc6C52FNWJ5gZdTXV>D43EAQV(a_:TL6^Q.R>cH=G(\B3?94c>>@8
]_,]YM_La6E,?BS?/I>C+2-J,)4E(2UHPV^_&f.]YcdVUg:>W^b):H6>XgD+AN6D
(4J/=P.7\<5ZYe+SM@aQ4(X^;Y)bSeD]E\ZgG-]Pg##/@,.b9@E1;RK-6+YB)JOE
NMcH?_@eB,RNMBV(Dea5?K.2d@Rd92=1^K3-<7S@AC]MafTWTKOQ/0I(1RUT+?Cc
^cH24X_,R3S&gA_BZ3Y-c+G->-GPL&Lf,6?d2[:WM5IbR#W^Y_/7@@-:;]gSd)Sf
Oa/81a@6K6g_#?ZW09JM5&O]J7TE4@L5#Y@17=7;J3EW#()EC=69+XS(DL@>H]GC
8fI4d]RWA(3RHPOBFD-2Y=G?<X#^d^=+[0g@I.G]3N-O#ULHfMbcMSB^CBbD)5BM
C57.[QT@0cbIYQ(.HR_F(O)ZL2)cEL0D&8Z3Q7;3,T+D((IBCb+#@@D2(#C0/26_
0:b#^SX\X<eI)8S2NU>SIKYB4<[MF:N)<>T76@\N(>Yc[g6=WY2):E4[4e;A1>;P
W3OOH\1c&4;YW>JC+_RGgB-\N0NI:?#P,]9A<3Y<#AHA]d>-GB3=(:-X7[^LPBgG
V=g5.GH8)\R7B;Td:7=gA0S68eLHF0(.-.(8B^W6FeMN+V__1O2&44^.25Cb@/+e
<\)2L@.D,),D6K<Y(H#2ISZC,#RS3/&]2O;+eM70K9&\5_#<P<E&Cf082g&<=W3H
MF9@)fXd(CL=M3PE=02aUR1Y3Af#0?\X^CGH/>1>0RQQJaXgQR9L-_LJB/0Seebc
;JJ.e<P]#eX4edd<@L<@9F+>G;1QK084^V@)[LX<EL7[Hg&;9?0g-7\[RZ\E8EfF
;=^T+eZe.R@#QbS)aVZ+]6HXR+60:#Qeb/?_;Xa1T0f7?R4IB>OBCEIJ0E1W#(aQ
g4bKMZ^.^d8/OPG6>W0+11++ODUcW:0N__[6XV1[EHE.>4X/NB1C;)>Pb,5O3CXY
.SM(9OF\V(>-?54f<RH_,\4=c[NdX,I_)M.5__)e4:]W:VTNgMCOBVP9VD:W<;U-
IINHB.:X9=aT49cL]+1[&YgUJfM&/b;,TABD]G)K)Q^5UbdLbUWdYE.L7^X:8&WJ
H>2+d]PTB41GU)e2NEP/^]]OVgAWXV/#29[\(;_)@H6VBJ,8Zc1,02@RCP:KXG+]
CA5CARV)P#M9b[&C7L/[fWV4]D1dXJD);d/DR[6RZC<e6+2,#?C6[-VHa/:2RRI6
<8S0QL)SND-T>9<Te#+e,\8(@:\Q>5Eb<22dQa3H_-.K<<R8KebQN]ZVMaU@Xa2E
Za#X?_F^IF864b9:_QBIFITDP[6BbK-CP4^E8O,.fH6JNZ_-]MI<ZCA^#M+1W(70
?7L2+U.GMHX7fdURH#N?Y6ZG(-/6=I5,M0SKHTa:@_Z[e588<BB[7gbSfB_G;gW9
^EON4>=BIK:8HJJ/D).C?=[N,EZeYC)6R.PZZN(b&,#ga1S,L>MTN(2,B\]9EY+5
+<)U64<K.aG:N)cY\A[&&5K<?8>f^A@[DA\?^RG]SWC;=FE\\_g^J;L&Q)Z<<(Lc
C,de7FHGgc&7&KBRAG7-Y55J_0,fa5Uda6YSGCMMX[X-+_g2^6A^>L&_J48(AOcR
XB\>YPH=Y18@+1MMb13SCU/gdW?X6@#05@US?9N@f))3H9&59;[Ec+T83@)5]32F
5b7YTJaN#V2TVUT9-Sa5@H/JdOb[+fLLG\^We5QA0Mf;bVD6J^1.+CFP_IC36E7N
.?(f^Uc7ZgM/54SbcGQY3,XK-^5IRU^e;LI@7FT-@OZgV0D+cQBKaM#14?2.(Z)<
\(0[.6(NBfEDEGX/GT<H[RDB+[3O3R>+H^[<XMN+YLJ:E;7]G0#5@-H;/Z3E5?]P
OfIDUaT3F@3Xd^1,/JN:]4)1&b5WCHDRFJ+68&4\07\?H8;MXGU\KWU?=d>1\g36
?Z:@[O(#)#OMb=SJWK29]7;(aY9I,8ag#-VTXddUWPfdcU>0ATHG\3TVe-VOQ0aA
8H_MZ7^^ZJIdMJJ9([e>.HQ52-)Ha,eTU-.bL#M7T59g?JT64,&B2BY.WPfKY(IN
R19&5[a?DTYSJEXQ//YJMB16/N\8WF^g(5NJRHf(-+f>NG=LSdc1.<L(M4&+V0@N
PA.5(#<41Sd++VQ<(8Y9-\P(/2?D1O6[2?D86/--0],ea1+\dXTaAG]JCdAfUJ3/
D9D<OM0O>D(PEDZ[7;N2Ue<0<FJ@#f.H5Y<A?<.LR_e?I&X]R+,<=\FP>5?8E:aB
=(;AY]aUA58g9J=3NLWUQf9ZV5)]@<9=GLJ^U;#2J76)74BCX/\@Ae65a]a_QGNZ
\WN--Q1T21,bc#_M\3df7&[2SM>O>eFBIVL8W@B=b9SV)&HE:DHX4bP&3@+0[Rd7
a-16K\[A/dFA.8\O(8O8X4:S)e0@S:cK^JfW8R/A=-f3=.eaUNXQ,EO,7:O6N@HQ
M^,\EeR>c4U]KeKZKE8D0-.5&b:ZR.C@5F<Y=YBcVE4.2&g@UE)S,/71IaVgf>JP
LIS>SBED2QI#W5-3BO:Ue[TE75>:8_RT0D81Z>Y;deVI)@PV:CgFIH?TR0++>I;,
O^M5(#4b@I80C9.6BV)c,&Kd\VJ&)eX:J@_@I5]>5:-9.UD0;X?F0:XFLSR?f=6E
[4<>&K^UU>:DL8EGN-\ZG/@Z93,^ZP6(_F?3N8),36IO6)4Z/I:./T])2&Y?T\=S
-1#U&/JQ\WgN=9O]g?02dZ#N&EFVA>?gZ,[H3UPH2IAEcW]+3eA6;LHHe>RW.<<X
51aHa6gA+J@AaCE:E_f.COI<;#I63GAA<?faTPaMA5Agg+g0&XXPCLH;I)#EMc:I
/I0)?P1[Q]?fe<#gY>C=C4P+EV(H[Z)+Y6eB<Qg9\8?4g=c2PGD672)8<R6BEPZ3
CQ\6JfLQOQ65)4\N&BP(WF_LS;,U:9(#PNG:37fK\[L?;/M#9X8C/,)bVDT>K9>Y
JTG3H+ZAA-\<.Y#B)Q:N3RKE_B^U)E7D0S9WPXDIBRKO2WedP4.KfTcU<Og6:SI[
aB]:d+:ZQL50X\(@M4@gXI4_96UcFJYVALJL[A.:b+0C7[E=TT,^/QL+#EEM8[CX
Fb3&7)]D,#/f--P9CB.f-3^UcT9UUD<<e-<278.6fUC0bGYJFfPe=X+B])W)^D:_
N=9aA>&QCY/8bbF^M4AG6.#eUFf(B:eKPX]XHgA#__GU4510IQDK-3gd>X\6<2cZ
C?,F;f@@G&9D.+&U.1.SM--b+A#OSZ8-ZR2UY=2I5a_LOQXe@X6?Z=fBWIWPCIVW
\X&7JLY\\.36K5@.\cXWHD#d3G?cdTFH(L/NLS\\TIKXUE+,K_=IIN4=@(LF][+Q
UGd6U;>N/RZ5#<5f:@<G/6DNMU+FG35f79.0(UVZ](S8R0/:6(_Q2[)7#NQCT@6@
d[;J2&?GQd?)gVeZRfOaEe9B;(7?H,L\d=NG6]O<cQI4P1T@;9=gV<5K9FLK/AE1
b(?;<0NKKV.9_BG)\FG&.\g-\LFa_P4?\MMa7a&X->M8#+QB):1L&_&+/d)P(DW&
TZJ5)G:8,F\KTgOD(<T]2]Q_52_bQ[fb3Pg<[[NI#59NE^KCPc-cbVYJ&\YJ#IFa
EfL_e_-cH#<TgR>)-R7Y2@@2S3H86ILB]W]c,TfN>_GLca(Q-:5(_bHZEC5IA#f;
C&#H5g-T9X9J98cXg^KUe4TL/Y.D[A^33H4&&08)@7=3+TaAJGZKGD1;#,-/(-GF
&8+4aEP#YKTFC_c-JNKGS7G#25,P=IH#IKBLPW3?;+Z?DT?adY.L0NI4E@5b2VMI
YZAK\=H:K-:,S\eFDb\SJ]Y-RJbOHEO=<(MLFNA;4[]=K^3\H8=,af(4fMS6GBRO
e^?PG/,d;c8EaYeOeK4.&+=Xc:4V2GJg)^HEbDJFKTJ9IE6=-[e)H)K].8VVK]Wc
B8O;8a3B(fbV/<[@gaLF>GHb[^GM3O,cEO03S:UHL,AO1TFF[a/>C&b):Q3(>2B6
MfGS4JUbe<CLR<[M0T,(LNN&2aR4BHU3I30PC\6J-;66_7;aEN@OGM,(K;O,N\fF
N1IV[W[\QOd;1O(BEZ4:WATW@6g^>bH-_^b4+3]07Pb>^1I+QQRKbg[H9-OL=A8Z
;a0>M;WFGS7\EAWQKR<<9JHQG]S7]&#G:U(32J@CRH0V95P(9M.8^f\1aa&)a?-f
?Kf_6XBb&0&)F8c@>_;K8,aTPd3(5;I/;2W5gdJ0d)1XcDMKdUOBcDd6IW_MNcTJ
)JdfYL&[NC:F>^]c<;I31)g-A:;R6:I+_:QZQ8^gHG=D?4:\K6>-7I3DFc:d[,MW
M5RR7V7S9d,4R.^d/+KXS/f&a@KaK?KCCITVaM1H2d1W+<N5FaG-Q.X#Ca4_^cTS
,MKTJ-ZD3-(Ug,Y^#H,.fXf+_1/;E9b8C=<K3D/.<+@\/DU##IXYIMe2cagH@U]P
+c,==725UbE-4.<Z,=&Db4-/OW6aI<ge,;6e54fPR[,PN-.gD](VS:N]/(X.LTg8
O@H8G)MaWI&\1;](aVI(.?TU=bNEZ8_@V9#FcER&.DLHHG^<7B2KL-HbSeR(53?.
<:6bNIT#54TXK)\HSWN__.N)M>g1Ad+RL_,?2GD#62:YXUVZ+E#^;5=NL)85JXV^
e8<Yg_&;G&Df6?4RDIe2gNP58B^dZ5&5,:Y5@W,FUNXa5WB8A_B8+:4Q8/c=>YZ.
ZOf=05M8,BRc5(E[Y75aa(_;L]WdYW,NfW49TU\[1&A0cN_g=H+LQNLa4T7:Qc>3
ABOA4C7G5^.d.g8b.WU]&ABd]K?5+QO<=7//(GI0<HN8MXL2b-OdL=3VGc.:(P3R
Q<?<5c5;-cP(dE.FCe;@4ZXS.@10+O\+DQAdPZYI5KHDXVaJaE\F,5e&3WePZHb-
[&=c.4CJY>^Y=H]e>:;Xb8f,&IG[QC&+TTCNf0&N,LZBXC[88GIN9.7F#<O9AP33
e:N[UB[YXLL,,95^WS/H_+ec#X&Ob_K32,J8T;9?7@92[#4fL1UT9]]adV99E_<d
<23g:E^P7e>7)#4Hd\X<FP,/7:9GO?2NV9/^\8=2DBGC[gQ.3IG#7HHF49K]c)0e
;C3#?GWLA8K)3_L-9U8W=,5fIbT#]RdMLGg4aF&Jg1^EA7I7dT#AOc-SR6O;cWV^
&NH=#4OI)WN(g:)NMcab)Ca#?TVC2DF<KN3Wc:J>ERB34U:d(_ZCUg?O42=df<#g
R<7YK>WSe&?Ce?DT3)\b]-83?B\O0CSQDJ\c0V?4CM6V33c?VM7_0[3<0TeK<.4^
(FYP\<+N=D5^<D]^47)J>H9eNPe6#PVKACRgQN89]6c]:Q@Se/O69J):K[J<PZY>
2ebQSg,KfMI:a9?RZ>=<(1PfWJC9>RP6GAUgE/CE76<FZA-7(X0BX?@1Rd-OPda4
7@/W[2=a@\OceER]NLJX\TgP8V@2c>4/@<8UC<D?INWcJd#KHX7UNR+O,19Ld6/U
3ZBC47;)I>&,dTdI#7^=4?GI4BX]+LBW.^<H2d.5V_Q.#cW5BJV)P&eF9=8&@7U+
CSM/3/fMAfP(b,d\FP^f8#H.2&3bY4T6b:WN@7=,g>>F1+HC-Wd&VBed?44\ACR6
3B:GA>-ESag@.H>PO^271J>0>-a)(93^3,b]b3BW7[A:[MRb1R?[J^[0>C#Z9X]4
A>IU-BGJ>[ZRZEEL)NH1,7B&9[3)(<VKSKKA@25A/.QJ9]KORPAL:B?@^:VCE<V.
17dY7)JBYR81IOeKM]?\8&T+\dW;01#+d?FgKB8P,bR72)PNTK[e5K3U4XN_;?G2
3+N:F.U7_.2c:EA<[cG6<[5RN)&:f^^0Jg7KJZc_0S/^_B:XF79WTE]aN4>2V\b?
K\+_K9g[A33\W)-?5E9EReNRQM4EIX;.EW[)Z[982(YdSfVWCS7QE-3I/>c=1&9E
SZ7-IGG=92UV.IY<LAMfJJ&^CIT]NY-_:\Ee158;1N;;Yg)7/Z/\N]g\/HMVNWOc
,c:VQce)2>WMGTY:J&L@OUVZO1Z2E-]ZGMF@0MJ[=[\<YM_9[/9g#F95.9?5:)6T
C=_2EI4DaB/#QD<(,35K(]a)-JA,8@HDBK\2f1)a\Q0TQ7O71/@0T/6X&Rd0a3B#
dSOU3^D502K]G25c^WUR-fC3NY]V0gYO=R)N:XRXD1aQCUG=L_7f0)U<g:1<84A[
W_U0\/aI/[^,@@>a0(aB-</DO/FK(EK5SD5XE,Z_dCaE]LaVEHIZEN#]:IQJ\3e+
Q@GZQ-0\=Z;UcCRC@->HaX/0H)T>a(gZ:CM/G7aC<+dc)]QbE(M[7;>b)>N:9Q/[
+/VE+8CeUde^G5+&A7B07;J-5W-8YWTfJgNQ=JVNA1JgK=C;dW&K;X6O+42Xe_EG
Q2?#D+f>@SQKb99gZ1.-4KG:C8RR>]d<a;D?a51KW@;f^5-f(B;_B?WCI#HHI2N=
>GS1+@JHTF1.9;VLaX(QEIU7GJ6&S(EUgHEeXQAGc2]g_][F0T^+(aV47cXYR-WE
\#H^[V9AOad)W@YfcZbdY13\CV#;[bbRK;;89>3.[;IG\,Zf<7bY0ge\dI<Q0B@]
BH2Y[)BE77\)\)1b4]^:0RcN<8/=>eK@Z[&,:AeYfE&-JLLYU8a#c\/(1YZ6MG&_
6JXI@^5g/6^[N,8F13@)K1Dd<2&YV2/4A@Pe3J(#YJOg19=K(9ZSX,\RP6#EDBK?
OgZAF5?D_\X@g0=gcF,#U5,]@X<?V:+IQMSQ.SfY3@8aH5\:\9::CFLEX/>=P\MG
=56@^f2Pge6]JMCB\M?DY<IY:,6/C/<--UT^A9:1D,MaWFH#VafC7)E__\2c:KfB
@95RE(,W2??])]MD]C?U(^HGO6eX30(\NMO-QXEY0TE4#2[Q_W7LS.;U4SA.ZLUd
\eK/PQ6,2L9IH\0HZea:ALOMAZIWAC1BHZ&1d>]a:\+02+4U6c)8^0(I-/0S8aDN
74E-&CR5bKL0IP1HRF@NO:IBKK0AOY^I8B]I0^H8TBQA;L1])Q;H4]P1[+)&PB)Z
B)Kd:CCO=<,6X82Z&C_XdGOJ1/;ZNU+75Kfe2a]7L1BK>8DB+F:dH<dK@AEHd<+K
Fb@H3B3bPDX,4+A6HQB4g<S7<\bRQIKZcb^a.gR0gDI+\1dcCe5#W5?#EgJWJ^;<
H43^VRN<8ZdLTgY[d(<ETJZdfHc/NCeR);&-T4>GKYY7X8^-(O.813f(,bI#BAV#
8&_c]<W<)O@J/7._7D-\Hf=VJaK&e.gM5gE6&f^_9T^e/[EY4W=]SN[ea,_K442S
acG(R^A(F:aP[T.R5+))T/V995:H8PUBg-\^_\./9C9@E>b;>;CARd0Y0^@V0JZG
bXT6L4T.<#8SU#&HL_SL+^C)aL4(<=.G#(&BSd24Y?-L]4/1O32aZM(6A:RE,8P3
PCKd3FJCRU@^8FTbeYDBe(M,=F/AUUE#(d;8AaI04DG9dcLM0H1:8cWOeH4D?R?B
/?.-@8OTE(@ebC5d,]4X&W^ZJ.5NW-RB2S@\Yd7d:]^<R+[8K?=[f=g7&(5MF\3L
,8DK/?^1:82X]3]^#]@8IYUX:bBKWe\EM6SNH8c(DE,&g-PQ2#-Y=f3[-T(&-7^>
N[F>6ZC^=P#Nc.#?V1W),)WNg3I&Og^RL=UDC]5AUe^SSN:_R;aS=fcUcW^2e;J4
KZ(#4T33#UEeIDB)>C9f9ZbY_e?UEE=65[6>f@LOIaW.D_&L)9M[+Y9EHKb@-DcE
FY/K_?3Sf_&7:-:.f0/?H9KT();VM[dEP,eO_&7R^(>^ZC6V]cQ9[_DNV^3NIGeH
Q^b].eA3?AOUcR&bF=G,e#^R5_^;6_+4LM&cAX/B&XYdE\JRAD0^-+d#?_S^cQ4T
[(YG2UCQP;(>WR:-=G]Lf&bN;Se;S[@ee71:B-:KG/X?G1)+LfT[a_aG&I/W5;O6
eMOATB[X5KPROP#FO0A.,Z72Y:8;NNRA:)5)0[->fg?VS/<@VN+,HKJfN6>7dW).
[O(0?\c[A:8^aXT>(L:F;egE#O(1<0\O<4<P_AZ+I-N;CYJ]PD[eXE3@bMJVZ?gU
0Ra4R;;gdAL>>9gg#1_83fO[K;4N:-,GW[C7K,#[U8=?7Z0A6RYU/d_:;H>,cVO,
+K8OKO^9f5@d^L)SV=K8)0c>45GYM5RK<J[3]1CMM7D2T^f\FQfaP>O,KI]gcQ3P
bO:L>6NJZ;Eg+;]1Q7MVBLG^VP3b?Za9.UU,8+aOC7Re2I&8C#;/L:_<C#UL0C;D
N,bVBA+Y2-HTXOA5D&[J?5>N<Y1Bb2-;MKA;OQ;f72T3(Pe)E+7e+XMD76e?O5AE
G6fPQd4ZZ5fQ];8e=;&@-E_?Z];0b7@/#/Nf#:0;O92/UDH^A#MRJ&ec+5M6;,HL
)Y8JI9ff;5aO-TEOT<Y4gD;UNV4HN8]47S;L3UXd\VK5KFA\<C#O[@0-9e>TQ=N,
PbUI:N_I80ZOMBZ0_JVNKdYfCaG6-6.N3(54J.(1R]?)]6P])>4M@[</f[\W0C7B
[2=EQXYcaE9H2)CA=4VKK\2<5Z_fRc^a4PHE<90AObfaKE0g7Qe:UVC+dO-.L)E?
I+FS^J(-[&;Q<V[H[#/:5G8,_NdIPI3;##8@SC/1<4MA<BFV<^bFNf[8Meb/M]^g
P@Gcee^61;_<K]5-^V-CJQ:<ZZ2>;BC5^&f0Nd7H0H7e#AgfH+&)M.Q,WO]-[IV)
_AQ]FcMU#N^3049T?]\R7dgF.4I(F0gJIX-@A5d58BfEU7UDaU^c.[4]7P8(:Jda
)NV\?g4[UaX0SG9TK^]fAL_LWK8NWA+7W8O.I9U(#Y)YD:E49_UNOMGRNK;_bf<Q
:GHb\]f12O]U:&3OBDeC?dN4FNgO>P6\1A2dF(498,#_dA7JfOJI860R:6_e;d^P
7:E88QRI<RU.Q/LJUVTGg:9#^S64FD36f.Q#+A2WSG&S8K=NT]Z\)_Vg/&-/^_Qf
R,DM7K@FO.;BA\I8(YB.^==Ra+3Z:3+534S48DB<I3A6X&KXQQ]dUUUbJWbM-9]:
CD._NWfZL0EQJZ=aQM)UCL2V9OBDGK_=KH&N#c(5L-5Mg]ZTSF5Q[)21>T0J]8ML
fGP]7)f7YG88Y&(9I:<#A@>;8NEW7&,H3?M_5H1OR,4RLQDK162@Aa<-^]YT,6XQ
N&PUMg9ga7QReA&S=0BQKXFG2LgQC@9DU3T.,;EI@-ZdKV38X?NRXd?>JY&gfYE7
f7GM=?/WUP;22(?:d7eTO?8Z-fg\Mb-9]##RA@:(a7ORU-5Wbc/V52-ga_UdP8dU
?+NdTLE2_KdN<g8&;;DO_3ca]KAMBC=,S5.D5XS9&ZH&(+1UD9HCG_(_FaPKd2SY
Z5Y](W5?ECg6ZZFKfBH&33b,9JU/>dH0^=;P-5QLA_eKE^T;.3JHgI@AT9&2C.Y+
/ZZA@U@5A4Z>WRB3Y:1([CWB:EI93-gLA>0;MQ:CSZ^GHTC-=6,a^Q?<3W1)U4<T
\Vg<N:7fVc@5O5JXcX/LCU_80#8LH.HF5:>a,<W0+7K<F/egeg,=LRE_[IZX,4.#
SRQgK>\Kc\Pef=:e712;Ig+FS=8N=SIagd?7<Qb0CA1<W+U/6/,XB>Z/6GPNe?Ad
VMGS?O7/>08.)_^HTcW1DaA_;F@C+.M1G.7,d&T534VWdE+](CSV>)VQ+^+#Id:/
.9EH#fW;;1FGgNB(/+d7R-Z+(R6O.NeE.)+].\Rb#7A<Acc5e42N<M0Df.G8<E82
VECK-.GA6C9H:f19b\\Q7GT&TNKZ3IT\G\8.587I_cbQ@Bg>5?</Y:#7@>>Za=0V
G01R6(G<#b;gH6@fN9EGCLYaN\Z--cD,C/1UM-FY^#(bVLK<CT-TZT1a7.(79+OY
\>QHaJFC,#(D\e1N5gaHY^6S]R;4<f(N-WA#\(D#>],Q4WP8]N^_c/0L2KDg75JN
_2T\\IJ)SfW1@aU)PM,S?QbJbW=f&e#8<cN34,W=BD^[+T,Y22a5VJg9UFH1[T@L
I<@6/D@+Re:Ja?;,QRSKe<AfHS?:K1=4,LLAL/K#CC=YIP25c&:4^98bMAF@fceK
G;1VEYL7+G2I55W.O)+B.EJ?8?TO<<XVIM2I4#WcbV=NQ7:I\Cb4D24RfLg>;dQM
Y-(eCe,THM9LDZB(T]4;GL&6cfU;,@NKKVCPU^/Q-g]8WRK6[F=(O3@]/=Z8fg;J
./_(J?<fSC7gbR^_53:^0C7]<>0D9QTc;OMZIe>S:I0c<_:JI]Tac6Z70^GAHM(E
]56<f>])<(PVBX2V]/77&.9VA>C(SO0<05)^3E[g&?M?.H86<K5gJ]HHXcW<H/QE
2WeI0;C/</1Ib(<N\,Z/Ud/=W;:L+f^E-P21Hb&;c=I6GX>Y[CL6-WOSBZGY5X97
b0<53[e\VK=V=L>=Ge_Z\4U]2B5=A5J(:1-XA0+?,Y,W?R+P]G07H\L^_/C-7Y:G
:QHT7eL]O#2FJ;bbf(W\58#3MIH=T&<+AVFLX<1?9aMB<)e^/4S/]NaaEXFK&C.[
?I&S0<6>M/f)2PV9DffMMO&6N#NG^9;8J)3=H?8),:>RA(6HY7PART2.^U[-7Ae2
1eI]6ab3@EOS&@9K@4)VAU[_4WV@]YFE(fbK=+DfAHDb/a4LXU3MeRc?<dS95TZT
TYW/a(33;?\>0V:^MC#d0-;Mc?V]>^HIX[L#I2A#RO;1M?YgaV:bI2F1,)+7KOe7
;eIa)99c4cOGeAW>B7XLR+T#A4W8KA/\=DPC3+&X/\^]?;Pg81;2Sg:U#<VL5B)J
HF;7I:e29cPg4F_/MB)BHa3)>Z>,2-NUAD.FA>5#0gFWcg^QfQ^CbEO[d6D1LC:U
T4I7cS,/207;E2/T_b\F_@)]Z1IH-+L;?O=V^D#3f<dO3388)2R9SJ2\LDD^^>]&
YaK+JSc;AI3R5cW1H97&JGB18Vc\;ADD7TE1R--=d7USJ#OWB<=g+EU757.[O;Q;
AN1XWK9gGEVYEgZa.b_F_)65B<c>\,bN[A)]3JFF@1e7CfIP9f@464M3a2C-d0GF
f2032,;XcHaK[T3[&AD)&G=f\KF#.5XRAPg023?3U(.#]\(]Ug8N3Qg3<&RR7eO_
eHg.9d];8V;].SHc.,UUQS/#^^=0WMCUV6U2PY7-&fI=7N]PddY.Z0/DS;43b26\
a?&a),(aN69dE=<-aDF&bc.\-TOA<7:-@-5+A9WOF.g5O;&I&I2GVG_?fH#&EI[S
Y^VPf^g,La8E:&2<aVZd6H-&e\YW\e-(WfS#2ceA_<V_SKP&EaY=#1+e\<P@..9S
SJKRLQ^gb7L>^RG51SZT<L,XeVbEA6eXAaHUb[c=Q;,#@-CFZMdF#S\5-?9HN4@2
JZDS8)7<bdL+)FCH93ARUV(e\Nf64OVH5JVeAG).RI+9(W=+8QCTa4NY3bE6F[&A
T[dDUQVG<-XNdEdc^&W@IPLYc,0PJO.?CF24-&9]T>P5)FeW0K(.D<dL3U@V=U80
@dfQ]&;#WWF4^CNJH8?^[V3OEP+[EL9.MZ:/1[<[8VgAPb@QHRX&H32TS5e3W^L>
]2FafEAdcFCU5)H:;ZV6\Afe]MD<M+[HM7Ia6C-P:I2?P\ZI]:c28DU:ZY(bU9N[
G;TWaH8D@-;P^cY+0VW#4eTT&fH#A[3_-OOH/_VUNCLX9MR.<OP7?Z5dVKK#G].K
KYb;cA9J[g5@Q1VIF2QU:IS(d]9I7_7<NUc=F+,_H[RKd.UV5,AD>V?NN9/c.#^L
OS_IZN&<K4]Md<5CM]CKIe8^3<QU+T<KgDXN;#_1.bZg;JE.a)FUIaHSN7_F.gJP
Y_T@CYbV<1\[#;R[YH84)<U/8:UbJ6-Obd.XSVO16Z+?UX]F7BA8E1W\ad53@VGX
a=-<Xb.^_9d@W7WO071S#D<1G1K@M<[CNe35\,8g6\YC5DddeX_f_G&E1>K_fT:S
Bf</(1g3SL2)-TdV#HaV\8?A=D<UD7/+@T[H=96(RKR=+O(V16>7>H=KX56?W4,8
J<?EV7eZ>M>e/afYO41c)@fR6#L0:eKH2BJI<K@b@Ke@@:I<?D1YA]YK6@2H8;P&
8.K@KS9X)6,,5V7M?1&3:Pfb5TOT9H0d2adUW0bX4a):(+bV<B08g=JKTR)d3a6K
b:Ag2OV+&f(Yb.G@#8.<e>_\4gE@dNJILPO)_fPY_:bGG&TJ6SE]#?N1?eO;=LGS
_C:+ec;]cO7>C1Y]/5)3NV0N6^@5()aVaW2UZCYD+)5d8.L6O@O2@ZB()]0A8R67
@?2WfX;V@R<-)a_WGUTL&45)Mb8<1V#/]aHF_?H1gD0F/aM;=T/<]>4-\R_8cLUS
Q8ANFI-)B7U8E\^7IX6>;IEUH9/V\GFY?<bf=O#2;&9H+P>=OK4S#.75c?0cR;WH
<@]VM<I?I#@1db]5XOZ\-IV_fVYLU=]abdcb@B,43VV;C8,6Z>.<(6;>fI8/ECg>
8fb\4AVQVLP6<:cf0TJ6HG:Y4cG(.R5XL\BPf<6/)&Tb[710#9VB<GgbHSSH4c.F
J_#,bLcc9L0-V8NV:2>4K1:S7JH_eJF8D,:gWX6ZgC)3_D+09)Fe;=O6(@AacR<e
^ALF[?8[?9[78Ac]90gN)gcdZUZFR#13O?2W5ecdAG_-bAFDFKCR^,aOTcTT;]?1
-&1+STP,Q>KDX\N\T\_J+2CL1(8b5,0L+gV+8C^0LWX0KGbC6M+??<^49\3#E\QP
6YWI<X520VJ3CN0(K#Aaf.XcHa3+/Xd(=&=a8[+V<<I+_PAFfH::\A&H2<VBba8;
Q4R1Qc,?gGV?.2,IS7HXEBM>6a<HIfZ9V3.Y40,XdMPEKI;c80)+c8V269]6#-)0
EIJI5@@2XB;4c9OI?6K,f&0/bMICa<?S+4O16f]ZdZ[=Xg6^V6B0E7W3Q#F=c3M^
-#)-Q\BfE6M@b(?f@G-3+@0)D+Ia:Fe#dDTg^<PcM@\bL]:R[DC4;f8M;3N-VBfY
EMBX^GFT>ZB#9,H+==2MLGVY]<c.GQb:aCNABBL,A\RC&Oa[O,49Uc,U;DATbA3X
P6ZA9C(9aeX_[6[L]Y9a#T<A5U>,YD9;,P2=;HbA9S(0CQ(0_g+0J,e#32)S_g&9
&-3EBKA#[];)c<#=U5P>bB2-ZLFCY_L(PXdgf-QL8D\MSJ+6&0EAJ=9H+<;-e5Of
]ELf,7HRBaWa(&E2NCU[f/I/9CA7^]+/9+3?]FbfeBE\7WUFF1C7&[B7Fb#-S544
F0a_NH#X&0eYH1]J03>:,/8D;K^DFC:L^d;5a[eBJT@/1XZV2C[7<LBDL0WK]A0A
T\FC(U?.X>gdU:.U.dfb8=EX8A?7)]G;eF@BDL4db11a#&eXeBB(2COdJ827TMb:
__53T_ZEH7]dQ]L3?M_#./_<ZNcB/?/3,2e:?DV@@XTS>GV/V2##8EJL__4B1b,2
XA,fDbVPO(13E.DONMO#.4M1.QXCR[aP>AM2A^/F7eM=#.^I2.AVM#gU];94>=]S
cAfLUdQ5P?RTIO)WNRIcKC4#83F.L18>2gA7\YR_-/5bfV7A[.f@KeE]NXDUN?Sb
KO6)2X>POGJ0=+&[Y\YN6+=4eE/RTeQ]X7.&c?,F\H8c98Y.=JJ@0&#DENKGCNdG
GV=^;U?971JNY6<3:/Ia>GE7A,eBOBJ,A).JRTMH/@b<4<^&;=AHY(^I^)MHNPHa
gD?3;XX:RN#@.8e:6>]ZD608#E>X\^VY&Q+&d6O)S3HF>;3gKAcN+NC+FCS9O/L0
:=F<,DLf#^&&UMBa.4YKRXOA,<8c3^L1=KB/)R09I<^C7VSD+,c@4=C3GU^cV?Xf
37f#JJcG+)bZ]#;,E7(4?(AU8\ZF/?B,Xc#VSY.?(Q[6GSMVKb5]VKY\M)W&+e.-
-S=7F6U[-eT_^I?I)KB>XfFZ[<OR@)SH,W&-7fJ4DB1ERRE5Ig&02EDb08ZQQZG\
dW+AL+C_X2gC>TT)BL5S8Q:/=bg^SW5HJ=VEKc]N3R/JbcT,>Hd62c/51ZO4<PAE
K?K-U0L)L-2Z&03/+S/9Z,9G(US/?J9[6BS3E;0]KJ)MZS0]D:?M?c-NX]g45VfI
gYW[<\E5;:<>7aM^+_B87QX7LBGC)Sdf\RC@9[=M_B;,+6:>.G80&3f:7;AC0+_[
H,^&_;VB>]:Q2BSO@]8:2NEVO9T:\QPVa:\]gN6WO:G8CeVdJO1:M8\3\L_Y55QP
a\Y_7)RW-+eF_M[<^7\.@OF&XA5Q]M_K9@MLC@Va7NTR&e(.MP9C9/43\W,fb:7P
#a+a_TNCQgf:MC>F/gFHP=X)25#:X^FX5=T;C^>-b0,>(eD]EGWC&1H=H__4G,WU
&;S,PYJCbe8\-MWT[+3?/N81C5L>&7_#Fa(S,f>V,D4#BA.AN;34+[ZW.Ib6R,AJ
7KcFLD6)b3[GH\3ZFB@b2gL5?S/cNE@VU#VXQE/V1:IDQU+)9Dc0]3245FgV<RNE
\<V-^7QN(V8&</0IWDeUIE8_(-OAK9&E,f/Y,YEO>\O8Y/e4R1BfLU2[gc8<AT;8
[dFUY6-a)&>-KdWNIA&6A_CI)I@X.WPaF=CZXAO)gV4D?HS)JK:WYDF,J)Ke_VXH
5K+cfgQA;D9Q#ccO7JNG9,2A,?\d,_@_gFG\NO_.fR:\S\7=@_2Z9c7520c3+.,[
S<NGM7W-^/aAA@<:M??cEDd-6,7,Og^B#f/K<TU&_]&F7P(TA[:@/)0N7<EKK#0@
3\]5YW=UEXMRHRI)LB.#Gf4?_C8.T1JC6.1&d.IR9U_RC)2dH@=UY]9=6=NO&fNe
H1(+b;5XI@,2(N#MR\.\<F6Q59-IR[\+NUB2YfAC5:1DZ)40<82X))2e#f1a=\?M
JQDKaYZKPL4#D+/Y]9NZT+&DA)Y,VV]cG<cK,,VIce?F@W@H5VH1E:7b:C@Be&c5
,IgB2A-NHT^\Y@&baC&e>4DO,=D^(70EZ,QR+CL^Zd7fb7OE2<K=MPN4J,R,ZVR=
SALW/W.WBYV93L#R3W)+ORD4#E+GWGLSG)0Gg(6a439A>_?0Z3A+d7[[\H.WLW2F
=D1fFNUCg>cM6^N]?(J>9f,F&=-8./E2.FD67OeQN)6HW8@=BM,U,]J4fI]>\46.
GIOb8035aN1Cgg9H.W7RZX65NH,NLbG7RG8K9(=02(]gd=g98(\:_-9fc];3F+/O
H]^AFU.-=M#OaF+KHO&<1J>aAe3A]M1OVKFPCeLO#&d>-f#DM?5JfSK+NZVBgN_<
J9HbV7B7:17&L6gFW5J35NUTW>.9&.B56eHKX7OHNP]+?FeB7:;0I@_^f84PH/c8
RAd0:^E1D)N,)fE4O/47cS^9QKR.4?EKO#DG&9d^8,.9CH))\B,]:/S@3,Q#Z27-
2--(C0]JDBT8Rf][IbCTKREHM(?Wb-M<^:O947C;:B80]f,9F4;?,6+&>&aTN056
gU9-D;E7cAG.eC/;#&@;39;bdBB3]E#.JYE=3W@)QC8L04KN-I_@ZMc=&#e@<S:F
)YLg8+Z78E;S:RC#SWL6Ld0(U)O38S+cQW(]]W9Ge>?40gHJRL\KGT.9d#IC<(KD
_^0a2Q4W4^\b0c<[W6=OM1Q+&[g6;RKECQ<T4H/KD@?J4-QJ7ZK-g^b>G0;_#0ZB
1:=Z3K,9+V&&M9f=EDHU[LgB&]O@0#;.c-FK8/&2BIB?S<5[&#OebNUTWB[]gV:7
?&-CC/f@/2GaWEa@=G(]>N,E;55XOP&D#),:Z9?G(0J1U\L(@9Z,S.0JbPZN[a:A
WXD59#&FY2D^@C@A9eAcC9(U_ZcSRbSF^)4G93#e(3R/PA](XA.HQSP,-82R+fEY
)CeZM/U3/^V[..9.1]X1CKQ-<Le)H+X]O)DcMfN#c+U<W-DU4ZEd\Y[=325(92a^
fGa#,Q3R;Q,bQTcQ:b(GG5ZTD5;NHN43FO[3[O+9C]&_=?Vd?U#)UK\D;@_:YLRZ
.I=;fG,CZ\+T@3d?-R^aY?\C@[:&]SefPYCe><[)Y[UWF/Ve.R7A54GVC+0BP:FA
Q6J&3)c:,Y=J=?8^MW]HC9;RfB)/N7HX9YB<X7g3\X1QQ]cL4GZOba1AT+TBZ=Y/
>/2aY46^I->_.FF35Idb4TN.<HV=DE_]>HC(._SAX]3X\;LBN;g0[VI#:?B0a5XR
OKQ.TTdTY?a7F)4BZf7dF1CR4G^D;-<0GU.E3PIQWR]<>-GPM8,3[6VX/,b)4M2L
+,8V_QESHP&;D661F\4PUHOBC3\=@4,-]AbC,E_^M\Q4&a[Z2JF58;=#c#0ZD^#?
cVa_2[C#g(dS^T:F#GOC3@e:-4L6JMcf:a6<#HM);S2#^2CEcTQ2.)TdcFB46gRK
<1=R:&=@?H\4C\_]c>WF_D8_-Z#Te8M;aeUO5WY/ZZC;6R__#L=H#M=)GJRR>/I+
CR&3b)\\e>M-YW7f6X(A)33aZVa7Lc2GXHdY:-DREL.f@9>f1[1+APL2HS<g=<8?
NC\;O+JHE<D\\^3MVeB/D.U<:6I+(S;BCf>8[:7/0aT=7#I28&54eFZ6EN&ZTNQ]
2?+9QcWDXII]+F=H@O^e2MZ4A>(3I)g-+M/bY:WUafUDX#I,c-7e^Q-@?KEK9a;Z
3>/]P]-f#9<Z3Lde47/H]2@_NdSM\GA0J/\bYKALc6BPe@f@T&;?PBb,bg=Mc/@2
NG+PF-5L/59b<4@\PQ]Z\/bJLdWBESE4WG+6EN5><a-?dU=/^\D+1DP,4-U,;b\B
?W0-0dE)aU#ZHJ+>W+KQ2+>.gY4L\MWZ?[PX-BfRSVUd2AaIXUJ5<L7FD\0dgYHF
QZP]8>5N?=GEH6Z^]=fT8gdFg.FL=V9_KaaScSgL#Rg@]D\3H,G0bT6EC.UZRNYW
=@:M0=W3Yb(N<Y^[1/C)aD5\6EF=(gcdD#D>:KeUPQ3+65:OA+9S6>Xg5]K[L#Q\
cJ7Rf+W#e##EY0=BRCeb3@cW0a\\[U)7WS6UfXIP2L#,\ONN^>6EQJL-g^X2IdDZ
+6[8Mdc.=6-gURaG58aO[3_&Y4E,b:,b&[YC;8HVb(K34^J7;O^N)IK<?c:I_He<
H,7f:KR)ID1668f85c+A=:Od9WY_Y(_#E0B(I2IH[a<::dP_-Q._0KUc@KIbIO^\
DE<8B>U#aS3(\&8EOf::O74?#5B\CV8Q?;BeFZ\_5),&N5aRA3:HY;c;6MT(TKSC
@7;,)Wb[64K@F>8^)S5KF^I,WT@L&A<=PfcaHF]3@+_XEVMZ^_.SDcT7A_gV^JDY
RTL6ZP^eNRKXb1Ra#+RZVD-\Mb_,-O_Q#VXCfHAT7bO/C6>O:QV]c/:.<@2cK4H5
/DNTU]_@#ICGI7#\^BR+]R8T\QT5E9YXNXVQTW->d::E)[d_&Jcb)dQ:3=EG>A,@
c.RL8,TGc+Nc@(+.QF7X[e\NV)97aBfd.@LcMTf-7UES<a@EHZ2T+_9E&6U,\&Jg
cY1;)d,JMN9IF1_;cg_E\)<F[6.CJHWFaNGB;B.<]DV\=6NBTgdWPF@S<=BK(bQ2
-MVfgR?UYdU7+FBT8:;G\<\)@CWW5YOJG=?YSXXV<,MZF2(g;Hc,/d[8e=+R>b+(
g#6&MZEA^G>&QK##C()]d?L+U1W#322Lb#/AD-J+;bY,f+F]gM8=Y=g\8#CU6f#B
:I57\&\DQ@AFVWe7/FR-.X<R-[.8PU=&__N^7^+Qa/3DgA.HAUgF=E/b-&3.NSMP
MW\-Zd&X?4E6J@>/<KM,eSRQ\:VJJWNN,W=GKH]+e+gQ[:75IASD\VA[85RKO-A[
AB@SP;RNKZC\HbWF9[=^eKP3EYHW>fNNf)O5@#7@<1,ZDAV[K7a0R8gWJdL,Dc-@
[HLIKCdI/E-f1d]3[/&)@CTF-[b>(9FY//6<aOXUAV8>QN<+@^bU(TFE\8&L;+aR
<7&[KOQI.Xe32d-T;G>RaE^S,U90LQPO.Z;(1>EF_A4acUI9bA?+6@N1)[aH-C>G
_J-EgCO7-8?g\VfI6=f^RW2??g#J]_<A_N27eM:H&2[a1,D[IE^X<P_(f\4c,F/;
9Y>+(B)3)X\9HLY(O29+U_0Jc]Z4#[8\9E0(JA4M=JX_\=)87J4(5+S9)(=T7B?@
;b1TVG)717#KeBYF^[@K;V@5\I(:0S2Wfb&gNQfg&;bIC^MG6aU(=.\[OfIK^\==
KR)[c+#V0Nb<UN0,+PX2HI0P8QG8CUb\5\;EP_1.>[81MOAVLUC0W0]/L@9aQE<Z
g,fG78]REI]SL^f3Nd&/CRL@&_B&W9ZUMbA9+GdIC2N9Vf[.+N7)SfYbc>:/dbU9
N(OQB(4d/_?=@?2RgWUM-J<P6P,),.>5@]e?,PH>-7;;DbaFdc@JN(-4M>R7,ZVP
B@./==FC&OVD@)S)Z4U8RL]=X?S/SY\W/V\N2^0O(STOE1=/D./4C,O(G?e[GHa=
,3)@gg9bdaf6ZO:ZY39#>-ZV3cTM_<;Y]F]HN@:.gQ[FKH@a5BVe-L.fV3],aY6(
[#O=93-geU&0QO7F7Zc-(KYKeQb/Q&FIZC-IT/4fg<aVKFMYbfJ.TY8GJeg^R5fF
PY#dJ0=\;2XGdFKB#5IHXSY]<d,YUVL]5PM6/7W9b#5?WRe1B6#9AW6MC\ORAD)<
aJFE;E13BL<9_&PcZB:I<=([6_N^CDQe<-JN5J5][ROA,Q=.O=PQJP0beU/5I?6d
WFKS?QU:E1#BcN-:FJ:DS^4092;M9]=>[M5+^TI564+2V6A-^=G8DcK/cE?V#F6Q
H\=6S.P07^dId;?.aG_<D#>J[C1N38=M2QESL:I(2)YVO8UL?1@:=B7G8+gV0W5a
SYM7E@QE9@;Q7#)bN6a^E8aeX8)2/RANE^6,eL]f(UO=R>SYdcWNICW<bM721c[6
QP;G3TC52XeD]JN(2@1X7#A>5eaLX72:2#E-H1CAd0@ZHA_EE(TFg[0ZbVJ3U&T^
^MDHWVIZHg(&gX>90J@6]A-=\V=S=(4Rd:/^Z=@R]@6F8#P]=F#:H0LP=/;;cP[V
K/[b]8>]M4I\R;2TL#)/ddPZIOVMXMT<gLOHMa;a>BJ2\&#>#ORGTQ)6V/;R316M
36bC_R]O+46#P1f6IAEDH9:;c8^&P/Y7S^J1E^beD-^,-349@PER+8,W8AOXEbe2
SW=WY6a?ETDc)8+=]RAOFPObD6KVLXQD2L]2T\(c-JaV>:6da5TDXE.ZgN#+TEOR
;.,:@A&;?<1#=0P[;?>1X=gGa;9cPWT.08LMD^f3U;A&7@ZRN/<[>VYfb69Z3cd:
7Fa2O)6VK@4D:9EFR88)E(JL3N&V.V#.]>H+H_(+b7-@c#GZ,QO[/]JHY;F>P:CE
dH6Rg:;5&2K9L12(Y^-:L,<6^)cLO(GML4eDR;S646--)1f?#^+G,FM>\/<+X,fS
\^EDV/fg6?b@#X<S,b3UaU9/9N]BL/]0H0.:@?e0_;=DG,<:VU?6.:>3\[/PD;,L
M17<a8]#R,1Zc[Y</,N/@P0+gX>5Ag:+.=0X[N6.8=.ZdV>ZPDYMTON+[O#/V0Z.
g6T.#d.e199Y),XBd&)/CWTHS./^WL4c-ZV\2ZfZe^=+:8?0K+MOKVVY/)EfLL5Q
_?[.^+6,Q=GV];6Xg^64d-E_U[R>O\O[S5/U^:EP>;&f4G#e6PcCJ0E)(<SZ8&gZ
K9XRLQf+][+/ReP):-2\+W25XY:3?-#5X62#W7RA>1>]f1II\JQBA,_;]F/GCNY;
@1R0RZ[Z,Y5NF5IeG60WGcFPQ3L0_IcLTY;T5A\CH6(Y8\WD,S,^V:/5OI)LQAT3
M]&/Zb0Q#B@+d?D/>Z6_G.#B.G\I?RK^^9Ic2]A^TYFW+aUWde.[ab<B,7EDBN-,
LLN\abf52>gI\T0+?SfdYd+0c9D_/\I^&aF9;D+^Se&(3-e(-JNMOS;b825&G(1/
96Q:LMbg_NHf8D[B3F;1>g2]C.O[Sfc)/&&CW]3ASST4S7NC0T[Z..<APXVH+SHL
H87BBOe_?69.ETR.b+;H\^:1Y,QR[68?#]0X<L/bN@V5f23.;e\4FJF^QH^:3((1
]MMGK0?]G+/aX>Y8a<,c]AdNX^H>6XW)\WU+f9\,E][(OJ=W]GOY,(a-4e3GW?WT
P>C1Bg?#cD^(8Pf9Se[e7KV]QVF5WLKQ_=L^>2Ted>+4280?[D&[#1&?1TF<QO,A
5@IYa+R>UXJ>Z&9#bBK21>U+>=+WUQQK7T.)<DOF.ZN5[W<?,HJaC2cO<RX/^a&c
619N9ZYFHJF7_6XCLV-MfMTLa[/&>Ob7M#+=>6;g8;C.P=]6FEG[)O<,K[/<M9UA
PE?/HMMfW(+78;HX_dN:fJ]O/dDJ\B,,EEV8P;V23WfJ??+.-4;)2=NPT#=E21W7
B7gTW4-C8L[2e-0QFc_9/cgc..+S4eF0gNU).=Q5&B?c.D]dPZ,;OAA9d^Y[C^YZ
.EEV3,\G6^_[_56#8Hc[g&=?W5R)&CUCCCfKdDY6-WYca54eVUF&<fR304bAJHgX
D?&Q@g&3)dfL\7/9@Y?64D@_U4A546P<HQN+b3\[T;TT##[UZ;@NJY?g<Z=c3D_V
@F6YJ=4=P/O.be5)(048_#a0VT\deKZSUIN@5(LSL)TKQAVPJ4UE:3S#P0#U7d[_
f?M==+UI/[1?ES2EDYOLb8T^K[>.X^P\0F>-5D/4^8&VcP,IR:_NeKQ,3cc.T,T>
0@K[NgIG?[1Fc/R.gF<=BcT^1$
`endprotected


`endif // GUARD_SVT_TILELINK_MASTER_STATUS_SV

