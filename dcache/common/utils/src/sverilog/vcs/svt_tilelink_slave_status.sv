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

`ifndef GUARD_SVT_TILELINK_SLAVE_STATUS_SV
`define GUARD_SVT_TILELINK_SLAVE_STATUS_SV 

`include "svt_tilelink_defines.svi"

// =============================================================================
/**
 * Tilelink Slave Status class. This class contains gettable, settable
 * Common Attributes, as well as any other basic status attributes.
 */
class svt_tilelink_slave_status extends svt_status;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------

  /**
   * Enum corresponding to the Tilelink Transaction type on Channel-A. */
  typedef enum bit[`SVT_TILELINK_A_OPCODE_WIDTH-1:0] {
    CH_A_PUT_FULL_DATA      = `SVT_TILELINK_CMD_PUT_FULL_DATA_TYPE,    /**< Enum Value 0 - CH_A_PUT_FULL_DATA     - Opcode 0 >**/
    CH_A_PUT_PARTIAL_DATA   = `SVT_TILELINK_CMD_PUT_PARTIAL_DATA_TYPE, /**< Enum Value 1 - CH_A_PUT_PARTIAL_DATA  - Opcode 1 >**/
    CH_A_ARITHMETIC_DATA    = `SVT_TILELINK_CMD_ARITHMETIC_DATA_TYPE,  /**< Enum Value 2 - CH_A_ARITHMETIC_DATA   - Opcode 2 >**/
    CH_A_LOGICAL_DATA       = `SVT_TILELINK_CMD_LOGICAL_DATA_TYPE,     /**< Enum Value 3 - CH_A_LOGICAL_DATA      - Opcode 3 >**/
    CH_A_GET                = `SVT_TILELINK_CMD_GET_TYPE,              /**< Enum Value 4 - CH_A_GET               - Opcode 4 >**/
    CH_A_INTENT             = `SVT_TILELINK_CMD_INTENT_TYPE,           /**< Enum Value 5 - CH_A_INTENT            - Opcode 5 >**/
    CH_A_ACQUIRE_BLOCK      = `SVT_TILELINK_CMD_AQUIRE_BLOCK_TYPE,     /**< Enum Value 6 - CH_A_ACQUIRE_BLOCK     - Opcode 6 >**/
    CH_A_ACQUIRE_PERM       = `SVT_TILELINK_CMD_AQUIRE_PERM_TYPE       /**< Enum Value 7 - CH_A_ACQUIRE_PERM      - Opcode 7 >**/
  } tl_slave_ch_a_msg_type_enum;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * Enum corresponding to the Tilelink Transaction type on Channel-C. */
  typedef enum bit[`SVT_TILELINK_C_OPCODE_WIDTH-1:0] {
    CH_C_ACCESS_ACK         = `SVT_TILELINK_CMD_ACCESS_ACK_TYPE,       /**< Enum Value 0 - CH_C_ACCESS_ACK        - Opcode 0 >**/
    CH_C_ACCESS_ACK_DATA    = `SVT_TILELINK_CMD_ACCESS_ACK_DATA_TYPE,  /**< Enum Value 1 - CH_C_ACCESS_ACK_DATA   - Opcode 1 >**/
    CH_C_HINT_ACK           = `SVT_TILELINK_CMD_HINT_ACK_TYPE,         /**< Enum Value 2 - CH_C_HINT_ACK          - Opcode 2 >**/
    CH_C_PROBE_ACK          = `SVT_TILELINK_CMD_PROBE_ACK_TYPE,        /**< Enum Value 3 - CH_C_PROBE_ACK         - Opcode 3 >**/
    CH_C_PROBE_ACK_DATA     = `SVT_TILELINK_CMD_PROBE_ACK_DATA_TYPE,   /**< Enum Value 4 - CH_C_PROBE_ACK_DATA    - Opcode 4 >**/
    CH_C_RELEASE            = `SVT_TILELINK_CMD_RELEASE_TYPE,          /**< Enum Value 5 - CH_C_RELEASE           - Opcode 5 >**/
    CH_C_RELEASE_DATA       = `SVT_TILELINK_CMD_RELEASE_DATA_TYPE      /**< Enum Value 6 - CH_C_RELEASE_DATA      - Opcode 7 >**/
  } tl_slave_ch_c_msg_type_enum;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * Enum corresponding to the Tilelink Transaction type on Channel-E. */
  typedef enum bit {
    CH_E_GRANT_ACK         = `SVT_TILELINK_CMD_GRANT_ACK_TYPE,        /**< Enum Value 0 - CH_E_GRANT_ACK        - Opcode NA >**/
    CH_E_NO_OPCODE         = `SVT_TILELINK_CMD_NO_OPCODE              /**< Enum Value 1 - CH_E_NO_OPCODE        - Opcode NA >**/
  } tl_slave_ch_e_msg_type_enum;

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  /**
   * Defines the type of command which is received in a transaction on channel-A. */
  rand tl_slave_ch_a_msg_type_enum ch_a_msg_type = CH_A_PUT_FULL_DATA;

  /** 
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * Defines the type of command which is received in a transaction on channel-C. */
  rand tl_slave_ch_c_msg_type_enum ch_c_msg_type = CH_C_ACCESS_ACK;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * Defines the type of command which is received in a transaction on channel-E. */
  rand tl_slave_ch_e_msg_type_enum ch_e_msg_type = CH_E_GRANT_ACK;

  /**
   * This field contains the Logarithm of the operation size: 2**n bytes, used for monitoring of received a_size on bus. */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] a_size;

  /**
   * This field contains the per-link master source identifier which is unique for an in-flight transfer, used for monitoring of received a_source on bus. */
  rand bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] a_source;

  /**
   * This field contains the target byte address of the operation. Must be aligned to a_size, used for monitoring of received a_address on bus. */
  rand bit [`SVT_TILELINK_ADDR_WIDTH-1:0] a_address;

  /**
   * This field contains the byte lane select for messages with data, used for monitoring of received a_mask[] on bus. */
  rand bit [`SVT_TILELINK_DATA_WIDTH/8-1:0] a_mask[];

  /**
   * This field contains the data payload for messages with data, used for monitoring of received a_data[] on bus. */
  rand bit [`SVT_TILELINK_DATA_WIDTH-1:0] a_data[];

  /**
   * This field specifies the data in this beat is corrupt, used for monitoring of received a_corrupt[] on bus. */
  rand bit a_corrupt[];

  ///** This will discard the request if not accepted by slave*/
  //rand bit en_msg_discard;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
     This attribute specifies the parameter associated with opcode received on a_channel, used for monitoring of received a_param on bus */
  rand bit [`SVT_TILELINK_A_PARAM_WIDTH-1:0] a_param;

  /**
   * This attribute specifies the parameter associated with opcode received on c_channel, used for monitoring of received c_param on bus */
  rand bit [`SVT_TILELINK_A_PARAM_WIDTH-1:0] c_param;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the Logarithm of the operation size: 2**n bytes. */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] c_size;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the per-link master source identifier which is unique. */
  rand bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] c_source;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the target byte address of the operation. Must be aligned to c_size. */
  rand bit [`SVT_TILELINK_ADDR_WIDTH-1:0] c_address;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the data payload for messages with data. */
  rand bit [`SVT_TILELINK_DATA_WIDTH-1:0] c_data[];

  /**
   * This field specifies the data in this beat is corrupt, used for monitoring of received c_corrupt[] on bus. */
  rand bit c_corrupt[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the per-link slave sink identifier which is unique. */
  rand bit [`SVT_TILELINK_SINK_WIDTH-1:0] e_sink;

  /**
   * This field specifies which channel to be driven by Master.<br>
   *  0 : Drive channel A<br>
   *  1 : Drive channel C*/
  rand bit drive_chnl_A_or_C;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * A bus monitored dynamic array of size of number of beats to be transferred in the burst. <br>
   * 	This array will keep values of the delay cycles to be added before asserting a_valid for each beat of the burst. <br>
   * 	This delay will be incorporated only if mst_delay_en is set to 1.
   */
  int a_vld_2_a_vld_assert_delay[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * A bus monitored dynamic array of size of number of beats to be transferred in the burst.<br>
   *         This array will keep values of the num of cycles to be waited upon before deasserting a_valid for each beat of the burst. <br>
   *         This delay will be incorporated only if mst_delay_en is set to 1.
   */
  int a_vld_deassert_delay[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * A bus monitored dynamic array of size of number of beats to be transferred in the burst.<br>
   *         This array will keep values of the delay cycles to be added before asserting dready  for each beat of the burst.<br>
   *         This delay will be incorporated only if mst_vld_rdy_delay_en is set to 0.
   */
  int d_rdy_2_d_rdy_assert_delay[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * A bus monitored dynamic array of size of number of beats to be transferred in the burst.<br>
   *         This array will keep values of the number of clock cycles to be waited upon before deasserting dready  for each beat of the burst.<br> 
   *         The number of clock cycles will be counted from clock-edge of d_ready deassertion if mst_vld_rdy_delay_en is set to 0 and 
   * 	if mst_vld_rdy_delay_en is set to 1, the number of clock cycles to be waited upon will be counted from the clock edge of d_valid assertion.
   */
  int d_rdy_deassert_delay[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * A bus monitored dynamic array of size of number of beats to be transferred in the burst.<br>
   *         This array will keep values of the delay cycles to be added before asserting dready  for each beat of the burst.<br>
   *         This delay will be incorporated only if mst_vld_rdy_delay_en is set to 0.
   */
  int d_vld_2_d_rdy_assert_delay[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This bus monitored variable will tell the number of delay cycles to be added after a_valid-a_ready handshake and before asserting dready.<br>
   *         This delay will be incorporated only if mst_cross_chnl_delay_en is set to 0.
   */
  int a_vld_2_d_rdy_delay;

  /**
   * This bus monitored variable identifies a transaction and its response on bus with a unique integral number.<br>
   */
  int object_num;

  //----------------------------------------------------------------------------
  // Random Data Properties
  //----------------------------------------------------------------------------

  /** This array field contains the config read data value of tile link for slave class. */
  bit [7:0] tl_config_data[255];

  /** This field contains the contents of slave class Status Register. */
  bit [7:0] status_register = 8'h00;

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
  `svt_vmm_data_new(svt_tilelink_slave_status)
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
  extern function new(string name = "svt_tilelink_slave_status");
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_slave_status)
    `svt_field_enum(tl_slave_ch_a_msg_type_enum, ch_a_msg_type, `SVT_ALL_ON)
    `svt_field_enum(tl_slave_ch_c_msg_type_enum, ch_c_msg_type, `SVT_ALL_ON)
    `svt_field_enum(tl_slave_ch_e_msg_type_enum, ch_e_msg_type, `SVT_ALL_ON)
    `svt_field_int(a_size, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_int(a_source, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(a_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(a_mask, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(a_param, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(a_data, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_array_int(a_corrupt, `SVT_ALL_ON|`SVT_BIN)
    //`svt_field_int(en_msg_discard, `SVT_ALL_ON|`SVT_BIN|`SVT_NOPACK|`SVT_NOCOMPARE)
    `svt_field_int(c_size, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_int(c_source, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(c_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(c_param, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(c_data, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_array_int(c_corrupt, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(e_sink, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(a_param, `SVT_ALL_ON|`SVT_BIN)
    //`svt_field_array_int(a_vld_2_a_vld_assert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(a_vld_deassert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_rdy_2_d_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_rdy_deassert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOPACK|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_vld_2_d_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOPACK|`SVT_NOCOMPARE)
    `svt_field_int(a_vld_2_d_rdy_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(object_num, `SVT_ALL_ON|`SVT_DEC)
    //`svt_field_sarray_int(tl_config_data, `SVT_ALL_ON|`SVT_HEX|`SVT_NOCOMPARE)
    `svt_field_int(status_register, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(drive_chnl_A_or_C, `SVT_ALL_ON|`SVT_BIN)
  `svt_data_member_end(svt_tilelink_slave_status)

  //----------------------------------------------------------------------------
  /**
   * Returns the name of this class, or a class derived from this class.
   */
  extern virtual function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_slave_status.
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
  extern virtual function bit encode_prop_val(string prop_name, string prop_val_string, ref bit [1023:0] prop_val, input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

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
`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_slave_status)
  `vmm_class_factory(svt_tilelink_slave_status)
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
C\FW@LX9IHSYAdZL[RQ]^KF=VWcaQf<1]b3WFF0aV#XEa];-VIa64)c;NLMcTA0A
AO+J;GQ-.=Mg213eB42=N8;TKN,6NFMUb&S=L7.dSbL)<.:c[7)-\KZeSH-.)aIK
-H3Q45Q5V>(8_/_H(f],0LH=#aEAd23FfaI&]2c,f]T9=<fQP??MIEMXaHSQT]5a
;.gXeUJb,(<e^(f?IA._3g\T1-[4-5\OW9>-4f,N7[7WW>_#g)=D4Q>ER7ANXUg/
e3OW<9N_V\P^ODA_aD(FRBCaE6<[.-[F9XHGQISUfKY9]3;Qd^P3R_S9+5C07)8Q
YNU:AK1EKb0#O7fIL-fgY25CJa>@O/CfYH:f>c1^6]fQJ[VJDL[U/H5+HQXY[NcR
TD8L^@^>2_=W(CWPcX0Xc[]O4<PZ7N5T)QIQU3J.Rd_5/2G6@6CFM/>SBX5F1Fdc
Y[S66Xf,GgOgU5LAW);K=9PC?8YCO[>[,-DQL1E=G;^d23M&VU>R033[NbSGL]BL
O97eTJDe\5GR>ZeK\e=0MAXM4[D.5@FY]RNK-6_VEH,<<c+VU.-=.=7(^g-,C^AD
K:+IWYgJ,]YS,L5=dc9NR/1K=2V,<P>b]QDJ\S7UD?4=Q/\SaeGU&HIA(-YMC]#\R$
`endprotected

   
//vcs_vip_protect
`protected
IO@GP7Vg-^3Z0G6cG@.&4dbH.I3F()4AI;XfE61.XN,X-&^<f?/B&(TY;6,_+8gY
LIbc+3=D16aD.VULgDe7WVD2g)=bX5&;X73g,E1Z(+3Fa5L9[#L.3I_gTUZNeXZT
V+]XXOf>05^a/UQMMdIU)Y1XJG\+=b1BNQ.eC&,\J5__PMVgY#OD0(:4N<R+?HOe
9aAe7X6,2dFXJW8c=1XREcUUc+GXZcMUP^53#[<;8eHEI1/(R[(&OA>=gV?O#YI<
dOS.SO7(^=ZGeNIebD)<JI>.@[#6d\W4&_(\NROX(;dO+M1YZ=KR.;GVP@YQTU2V
?<JcQ1N@/g?72.&1T@?=NgA<^6>aOabS32NI/4FRe;RH@XSH7,/LE2J(<cRR#70B
aAW^<DS[0;SC\GVf1K#b8F)dLHA(GDM3b5B][#I8B>2A>80CT=Y,g#]&@Z1A1>cC
#6WU30A+.4[0VL<5fOJ+AM<2<CAE0EQN]44[Z0H9fDB5#5JF(K7\c><<=:a.fOGD
bcSbe6)eM7KJRI@b;M\>L)1Oa</C8Yc.BXe8ZD3I;2Z>J^E,\.[0:@LELbf.bID_
+>,Z8;_):Dc?K77&=aL0ISHOdNaV+Z&.DL&RM7WDGIO^>:2\S8-O-4Ocff6[3&J[
9X&S+_TW8<>JCSf1X0=XeaegRf#@)^B(c5P5@\8WP)9.63aN?bfR<BKT_E5cWIFU
DZ^f[5+d-W;74RQMM1HPeZ93)]\HQd\[:3;>LCCNCGSMV9)/OQ7B#8SD)c<02RL=
.&e-gZ(3I<H_CZGX;&c)8J@7S>[eX8e^@SN_P3f.Z[D^,E<FMBZ6T5Xc6ORWB>XW
P>J4Gc;)_C;<)0c8KfJI.+@cR<Zg/6]YUHfZ?8,+[20fNC_\UZL,K]gCQ7TC_eM6
:e0,UF.\LGf@-Z5/R-E?;7>(/Kf9P8_.G_]b_[(N,&?OebD?/Od>@:/8Rc(JfXfP
NZbR+DUI3PX&OF>XdQT[I2eJW-D][^5LHD9?J(S\<fbL\4_QA9TM:Sg,#>E#=L=O
P)SSL1ZP7IPEC)O5[4>FED5/PRb&^Zc]Q/ATQS#HL4:cO48I4?OR\2Y3^a3_(WCb
YDQDe7;10TIdH?E5dbUR@62Q(WEe_dRR;XVRC.\>QY4OK@5THZ#J11P[E8JW?SQ#
WACG1NX6#9M8Y8cCY@e[=A@e8M>4&V7,VgVI^KJc]P#>E_QJ#\^6eP#3G?4/;K49
_2B#VT3(EfO:9cK^;<TOGb^g6Ya+2Q4>LeLQ&XNRE3/UeA[46Q[9JaS0?G0F83\b
5f2436bK>7b+O5KM;@Zg;4NB76JYWZM.<G4eI:I2&]G;efQc+01,98\OQDB#K@KE
Y4KSGRD0<CM&N(R3PY(OHJQ.dGOPJZ1G_D23L\@U=O;C(+Y=gW(fED#&bAEHK=Bg
X\S<6ME?@,H]-BFSW(E#^N,;eH0Ab?>^4Z=NH>UCRT>8WV??B4E]_#:WH2=ae,(d
.W[36)R);=bZ@O>3aPN5@2-2P.NgFaBCA<<6N,I,>dX-6-7X-Bg;H@@1+AG\c<H>
ROcC1A?B\OF@T8,0E+W_b;XUQK#PQTT0?3MDLO5NL[GGF#-?:K^[AZB-BE+eU&33
Z9=?4T-W4;=NfT<-8+=(6PD<ZY>8CdfSNL+PV@_.#:Adc()=:YR]&B<E7T:9>UF)
IQ]a@/1548[01<K;0;>B]8O9J@/XCHTK1I,77GfN:<e(A5QS,YF?@7B>_@;XAI&2
]cDB,)&/9YaT7-e^2A+I?;FRWRT7<a;D)P^+MG<dc&M[0;,I:f#f.>+gL(e9bST3
fMT.PP^,OE7ACL4Z(5>0665LQB7fFMRPITVI[EaP?418M(M7X/f);8+NZ-ga.E#4
E?^b7/MR_9P[b53:4TR5baQbTe>W:^WeK,<G.[a?N<;VSacCb_85?8gb0eFa6Jg]
Z(Z4IdFa2G.\2J@^JG3QN8TI>]_gCBHK+:g&T6(RMb^,ZN\U7gCRQDDO[7PO5WO?
?9E<:3He>-ZK,=Hc1U)b9a(;agAOJ?#S:2+#bGG1KRM3Xd&L6KEC6Qc+dMCB563P
\b-eg>8<84K6JS]d6HQ@A;IZTU,N]6\?R@_8/<g:)gBE_0GdS=.TO_P]-2NP&4D>
LJV^B:4Ya\F)E-e2AbJQ<))4R;MM:fF;RQBX:G[QK=+OUHWA/>P8S6Ub+WA_5cYd
;P-P2^D>g1=C7<ZDV:_GS:#1:V6]846gR.^?&^>VSSVKKWV6D=[;\^Cg\?0OO;#A
5WV18UQg<gUHJVD48VXCEG5(S>B;\EG;ZR38/+c3fS#SAc,9/0DU)HJN0A;ZP0Jf
_X/ZDc[?#UGf1D)ZI5.Y9<[HLG:I-c-GVPbR^f]\2@QGK\@VYPO2SKX2IAIHBD\H
1Q.+PQ(+(>-E_,\aRP9:V_JLJ[P-CO?5WI>LX?IGT&VTb+>0<69Y]PI1SFeP+R_A
GKZ@JLI@V5AE4b4EY?bI2C(?4FSWe5C5eZJ\NBeK/c3CJST>>6F(FO-\X3=-NAL7
B41eK+1=3G7[;K.Kb9CK?[OEU1d9@IgZ]FT:7/dI^06?f5gDI=U)dV/K^22YfHB6
=VRb\T5DV6dW4W<g2S;D\adUa88cA\AV2UK497B(X7b\]4&MMRTN9ZgbAD3D@T#.
=JDNSV7gFJ_P@1IM3EE+(V3O1H;QYZcE+A_+,4^@47(.D7N9(K+ZT\(f67eXb?MM
c6537B8:#&.&:2LUIVbZQ^>OVNR+e8:PedNdf4B#4:\QFbZ5C2T6?1e?0FPHGaE-
:E2DH@)Mef1<(1.+46XN-.B=(F60);MEBIg/Xg@3HFdEH)UG=A2:9/,>f]K-4Q+]
R.+9+T6WCHRP&IOZ/LD#N_&#R1g1@HVO+4XE;1<E=:eQRU&6O1,F(@1YZeLcFU+?
[SM>JBF_?7ZX2Q)^AL:=c@49WX(V[cVYIc<^f9G4X>NDG1;KTNb?55H;N\()]6&F
]MJ3)^1LB)W@SS]X)d_^QB<B_M,BMPT2K\&AE_NG]@@DYW-H5/c=/N-J@3F,KG9+
EGV(HA#D\C8f3#FIBB+a.?+B?C7YfT6P3S^^IDIM9K1RfGI8-(Ca3LdLG_c@TOKN
M?EKCPE-\0J_@6Y52_LQ8dSPfMd2Z#EK(C<?A4fUR,)1b7<K++&L_IGga08:fOZ+
&MN7e)U3:e0[2SP\0[.Aa@&aOD33-1DAgS^,Y#2^/&-2ZD_V+.6..A>U)JIRPU4f
R;,]cZ(cf/HI_Z@-H)6M:22D,BHV@cd4#45,064(a&\^5/EeBV?^NKJO-(aW=?@.
FI?O,d8Z7RM_=Q?D&Q5AT<eE<3X:_::ZX66g(7/^8^)ZCKf9c[<YHKR?]AY3]+V:
b)CJgQUY,ZY?AF.B]J^3D6<.=aX<@fYGRd(,HN+Y7TeYP6Q=9X=L9-7KS^I7R6O?
C4#LcK+<L7J7.Z9P:WO44gDeQd3[@&4?&]97+>NGLa<964A2c)E\#]4S._Y:4e)W
#XXYABFL:<G;#/>.24@1W9>P:MF478>&:X);fd2&@74>1(;87<?+N,-2.(NE\)P#
+:Zf?Q3:[EJ9BPfZ+9T17^2BPa=VPa_<0D;:?>L>,IUFRZE.PeJX1YQ6M-ZLHP3Q
Sg;+f;H1g[B16;<\P9cXTE2cHbc>GdA]M5=A?X&40b-WKcS4e_01#..K5PQ]Fa4Q
M^A49\Q,3W38@>N-\19YI;eX9,Y4Pc0f)UV^_)2E+^e,W,0N)ID<^)/]T-?Ld<RO
Q-_M5MAd5KdP[dfITKU@3R[/A<e[]PG/+]A/7Xc>\940CJ&_\EUTc6VQe615Jg=R
(?1XF<[68,OJ5;5Q/P2d#8].[BL2WRYT-A,LKg8->7TQaO+/O76RGeA4OQUYfC_X
f^3;dPW<BR\,UM[a=R<>KCK>?(4P>OaO]O]R1<Oc-J)>TU=POQGUNg<+<@Kce>R/
f3KX;0Sb2IZe+,WaEW37IW,SK[UM)O#O+>LIcSQ+@-OL4G2\@daW_<\0R5+d9NT+
=eCB/XR-?Q9&b:_J)d&C3^I83N\9_F:^86O6BP]<#3D_<&BB.I6TfE6AE4\-7B.&
a_O:KN0SM85IM47DFaJ\g=X[VRb<=XY5a+gF7S4-\N&DN90LLX9^6P7T;Fce_L\A
F)XAId><P]5(+<Ke@99R,9+-/5[9[0NYXJ&-C:G7]KXA800>U/>g2Cg+T^.,,8OZ
EbOBN)]XX0FC,[.TLKg\H)Bg@RQ\FB(;77,LF\)X=1Y79,)R#NA2E-HW4[ReBD7c
8c58^[S:G:.E4I0;MC]7<D3XVgIe(;,5+U[39RT:AA_1ZeCOM2AIe3Q>2<e)EZCa
QeQL&P<V2R</V_ONWFVI@C@K@gP2/6QKCg8aHW([Se5/5MMO((IBS&)G^e&>\G?;
[^a8@=S#1S35QTUR<5YDR=QDgD[9dJf43KEI;4#>Hg9GZ?)]^8#4g5O3GMB&/&K@
I1^&Mcg1HL#@.4bE<(C<3R?YdSDe:\^a81-1^Q2X.J4K<<Y/cf]&;S@gFD>O0GR\
N0EK&XeV=N_YW^7AXEZ+OCA6:HF0.W<B-I3O5BW=Qa5M+4]LUfBVJK?]S]</IcT2
8]AO,?1+QI:fM#ZM^F>eg40([;MWS?LV<-MJ(KX;]YUY224?;2(d29#6T-/\U^J&
_C,;3HGWAL-4C1K;GeSCA17Y.6@0V]:=c&-Y:E)X0]EX&C,42cQ<=/dQ9O+P:#;f
+6=._6?QU2#>(CIL]+g1>:^c2P.2KLJ@5=U2>XbK5Y,:fJS[5TRC7US05^?T,bSE
KEULcEWW46gg-MO=#cUF^^=M#3]eK&NP?+&U?eRb:8F6H-Vg>1PN+[4&2feTQ447
W/,_,\BFdJ,3&:KV41)(W,\;[XG3CRI.SS[V/@CK@T>BG>2WOSLeQ^FCQL7+KbII
Y/J+2._:7df[-e?LFLIHU\D8C?+H(gM)[K-/^P98bDNEFNR8:7&54F;N?.SV6f-E
[JbQSNMc(0b6-1F8Zb:/(4C75M3A=,B&579([HT:J,@3H:@]BFH2^OZ[gJ+(K^@[
XO_F/2[-UE1d^8BVd,Y(g?R?.@Ee4:NHU+beXc&Wg[e2>>5/4<;9e^>ZK5T7U8??
]Q_&Ac1(]U([5BW7,G4=SN95bQBCHO69M)7(T::+S+W.85-[J.5ZXP?[#,X0-\9-
&+=d:<S[\6?V0dfH.HfbS:13W\[QZE+c[g<SY5/N+C&/Q90a/DI\0C/E@AK(\+_]
IJ7-;5,X46b/5TGJPP1,bLFQd]W4:AQT5^/AZPO#+T/L\R?S>5gGN_9KARMHQUf_
0_RS&^_FR\Ybcg^YIeFNSSRfO?(.X8UMGZRHM2Cf>FPF(RLK1@)2N5>0>JA;e]?,
c?=)3Y@:d7(Hg+1,b\GAI<^+6K<eH#/QSA43)\QQ&U/bNfdNgAad>G):KI/BF=SH
MUfe#968)Tb&[.-P]X83^=MX]47N>/3P#\bN>#eT1g&V#^F66cJ;BEW:=\09(OG6
g7T<Q:I1;_J@@@;G;QdX9K(Y<?\4J/:dP+4I5_^)8ZS2U,5<WF.gO]UHM+:A](>+
2.8I8>WU]S:MX5?[dC1PD#D4[FH89AH3P)#CL52_OZ,-f3X-,a+FId2#7:;4S_:[
/#U6XZ5Q871HIJ+W&Rf?eO8VF0H^3-NHBX)\@QFP2GbcDZB\eOP<YXM9&T]T)ec-
dbdC6KdE?a11;&bNa+V#U=37-JEb9-[cDOLdWQ7fIIY\_/KDd=OeI1g&E\6b6]#b
XK595Z34/A+].Q7_/13V99gC3gY).3/SH8WLMNcFgcUL/]aL?CXN8>&)PPJNT5,P
Y&LS[&\P^)AbEQ6Nf&R.:]3/FLP[@)McGCQW_Q330S(BWL:KYK?eVfRM56Z2RYX0
:;WD65C\dE;d^:\OH,6cHX;,1_<ad0._4?_:E>:41Y@XC#(QAg&>BSC_+Z75E[RT
)#,,a^M_?&AA>P;Ne(QTIWT:8OK,L5NMX(ADg:@M5OU>Z93X\EW1QT8ACD8ZQ\6Z
/OZXQ7T2:Ob;c]^f]>C_6E32(O8^e9^PbfJWbP:^_B._FL3_Gg2?U6XOPMc88UC(
8SBAN;58PZ\LVX?Y+7-AKO^)]c72C[2CZ^Q0N&/?4g8gdR45S.+3Je:UUJ_T[\/;
82YJ93HF>.M\((#1D+cGCZb(@L78A])UJ5:@WI>S@GG/?>#OJFL6FN7.R>K[^S2)
WbQ6ScB)(C1f9,_^?J#gK47dSFFXQY6C3e76HFb00I8PbL4KO9-T=]<ee8:COB_X
VJ18L0H+TQ3,TZ1X,P/XMZH:bPd^31N)8G7#-AB5&9I83^H)TM=J84R:bE]=P?T/
)feKQZ@bXUUKeFA:48UE3f<8W)_RL+]LWRMQ-Y+?_U[Z,=GV(aDR]QA\?3Y-.FcR
,/KGFI/UB5X,c^D0QPdAS/^=A0b=]Y:B_>dS9K6a9[@;1IM>3^&K4B7(^A@Ed0M(
QCLBZL^6R.Ag:W>32AV0a\_gE?JCIGP-5K]^Q2J+VMAV4.,KT(c\=&O02#>EF\/_
.U8(NH4(MW+c\5X4Q&^T#]c67R=L6db:2T/#4VIO1-W]P(O?]X3(USM50=SSIJ^1
G]0LT^-82L4,64/U^.#HNFRS_eT]@I-(a@+)/Y/5eHAT8,=cF^3U59[Kd-6WX]+Q
6G8#S.9AIA8cfNa&NPE8E501Vd]3D]1XYV1acZ&6U_350P3E9OI)?Le?f#ZE(C@H
(,LI>Qe9/MXJKXG_Bd1HZcDF:gS\FeGZS<c<@YT<YWa+&NO9KG)60P.][/UG+=^#
.P8&8T;RS8X1LU]=56,0;<KP>N7.)WPIEW0CAJ.^_OQ.H/Ac-PbN?C1#aYYZ;3KR
gQRM5gWDCB[67R.C4\TEB^6GJcFBMT\GIcM,=T>P68_V5^]C8@7,N?.?WW1fWI7R
E8_U/5D.c3M@Ib/6d>;g9=ONIB&OaaOS9A;UYCFX^7:bM9JUdK17cQY:^cgZV/YG
-KYXcg6G\4O(F@_7V/@:_2b0J-AUS)Y-CNaQ)c__]YUP99fRE3a-UJ<W)G\7/+B=
W>;1/.5><eeE>]SE_4>eD(G.LCG2;V+XJ;b=/<bVEaC:QfB:DQPX7^I?T;;M8F-K
DW[9MbMQR1dWdT2d.BI\^,fLV5.f@b/Z[:0ZY8YcHbIId95PbLYJXd?J;J@gIV(3
gJXZ3C^\O+U=:Gcd0,XgOYWB7K1CM].8bB[R64P:Z=;KU?+1IM?SM3S<VKJLRMY.
JP9RH<GN(CH/GVdX?WV4bAe(;SR0R>J0&]8Z>cd5YV)QP-1R/K7L:7//?YVc):G&
\.Pg&GaKS&<BVF,+fb[b?@B-VKPDT#ZM:PdL/CRDH/KL7PMZO/&5-CQK>>RCX^SQ
++VK&DW7^TFO(3MJG3fO=.(U@3<PV9N4e#0E_AP@W,X(3L&7&V)cN;;33N9NdY.8
<P&P>6<(H)Uf<dN6]EEL/#P6J.#f-^e8.Z:N:<5[bQYG-7d;.D&=&SZfDF<a];e=
W83>ND:).<RNR]Hed^S\379?:C@][aQf#P.g^7&J+/WGcf1a,Y\>PQ@C/@O,4(OC
f@Qc9@\&FK>5d^J^&-V)1>_LR^;9bJ;H[R[>f>@#OU:=()S77VfRFXXBa)),/;CR
.0Z13_PbTD^YeNTOXB6<1)^1^geS:Bd@e>1BSaT9-8SNH<&FCfRGGSH>3.T>GDCQ
4b29YOV5E?6/N_3P:]gX7M&7Wd@eQPVYQ6-RgS=WHGaW[_DNCdB\&W^Be<L1eUga
a;T+]:O]M[8/2fE=,G7g=MT]=;_OEY<9[-YVK[1NQ#X#3P(?VdfN4a,g\J1VG\&0
/1V/eG<Yb[[UK\^_V]I.5GNE4WBG#LfM[#^P,(8B#b@-:+?9,-GPP#R,dc6;-?Nb
W[W-\C5]c^8YM^=Z3=@XPgE;db/f>;Y_IPRV_-&a&=M6P800#2]f3@=<P;.DI6P=
(.Sc>GV;WRUU:VQ_K=_KRcQGB@SFgE?\O?9_,^F/#eZC59(,eRbYR4_]fWI9DgF6
8N#0dQD]V\U:(4M)2/DD?_e&A?&b/D4K33/JUSCIY(ZJ&F]XW\]ORbEg/]8T@0_+
)ZLT3_)b>UD_YC_A9#e(.F>?D(IN]^+fA7845L.DG#ZR\69/]7b(f_.X5&-;KK=O
@=;1L>[N(,9WLSJ=\L-W=_S<E,XP9=(b+-.),0g^J-14EWS7)MRH,+B43L\?MPM5
U/;O0b6OU(_M:,^-8]gf_Y=(#=_?dZFGeIIG9BX()Qfd_S/Ag1N)AC9TJM;\QT.C
[U]BV=L).-]4_GOEZ/N<a.@E>\8G+)&4gD++)FPC^H;g#8YO/e_NQLPT+SW;ZDD&
L_Y1/(3C0SAKN6d-0<0/:G^@6Bc?GI^B5B4c@OQacK3DF30Q6D#F+B&0:?c\-WQV
6NY_b.=8-K&:,Ed>R#JaDU->OR=P9(/&V.ANEGW7C\aE))SBE5fVPM<KF.,dMK::
=EE>5IBOfZS/@]Y7Q6)H;0FIfc85K5e_897G/F]7f326TJV))@_/OXA,\II:I1^7
3)^D238)TM,1&>GG9S\\/Q-gJPF&G(18PEES3[H3Y30ZZKff>CY>\cK>JJGAP0GF
eeXEA@#-3@_4+C8WEB^V0C&M<I9-eQ#5NXU+f?eNSN]I&P?=Gf5Db\;MTBY8IcYZ
(XK:H<>_AU),fDJQZbSR\V6T&UXKC3YF2GP>c_#VT_(=.06<UcA8VWP4^,4b.MKB
eT.gQ?6^GP>&&<4JcC/.=Q@9_N&#U)VR5V>PM[FNIG?>a>8J7Z-_c)/BEdY2H3fd
:-5FRd]A;785gS^]d@+S.IUUc>Cb2I5>7]6/7O:JcPd0L4fN4#=)4P]>6S8&S/N3
TRYTN30_DB/W_3F=fC92T4D,+);FWWZJE5SDUX/a#(Oe5X+VZ1a<+S4gOQbaJ#H7
\X:8fXIHGR08:EXdfI2JIT,WYATI1.?E.>4<Cd:=OKX8Sf?L,4OT:-70I#4Eb=W&
:KJ-/N6fRVa7_?)GgR6&73KfMNKfZ3e&,Mc_=[7f(c(FbF06A(2#B()C+L>>c1WG
7E1&EPVYJULT4&bLP=;CcON/(EV0?2DJGW2&-U3L6<=)]Y(e,-09=C13QDLD@I@(
]S1\N7=g>2-a#?;Ve(>JeDUA]X0#G5C0-W+BYSLDP]dRBGgBdXXYPFdQ-,KX.?>>
.#AO1FYef491SKJ0:e#bRC^PX\/1:ND98bUa)9dX-(5+DMa7&=SUTKZ2XTKLE32a
O38\UDJWH;E0bPYK:\H.<5W3.Ke-gZ[I053,;A:b7(,bA;=BLDb<HNPEFELHT6:O
&Ac>@0]6(?XVH9^7NCL66bM3cE<=Ga2G3(YHXIKD\1cT3O7:VXVDFgG/G<I5413K
)&P&SL\?5LYK>T/U+/FKM<2M2XG=\Q93#?WO,49G)Fg)4bgZbGUK,gBUT7U;RYS3
-_-5W(H/>8M&1:e#9\6<U?#+3\<5VQeOX<b\P\V3,GXLKdARH7RW^G1KI;>M-Yb\
,5)a@Zdb:cd6/MHgeNgaCf@?)[LeZ]S>Aa>b#4<\4M.KQ5KB&\IXSKIedVIW(7=6
=fdY16<F@(a=#(\EQ^,Af,)[;g=?QWe@VM(E0BNd-;0Bd<8K6d>aHQJQG,R#]^,H
HRKT+9Gf[@D<BD]UA@MBVPYWDUM]<)[<&ZaNPYRXM_MHS;B0MYU@\1)796.O+(T(
Yf,9H+\7P.XNT+:WVXL:4R+d?N^<P9/F).G^.T:EFRLfJ-KbGKS&N.SBB+T1\:<K
E&+K/WBI)KWTH1M,RT(C&BE6P?DJZ2F-_/OQU:c/L^9KOV8+WLeWH/#KF1_A;127
8V4,G9<3>Eb#UDL5/-Nc;XGK)b4Tb&408]?;M28/a4H0P32(\fe#eU[[S7eFAS-<
EUSZLQJ3(/Z1<-&YI3eC7[B8+_7O;+IAgA8,R=&YBLC<UR^A0(-P>OW_(V(<[89E
bC[#UJ9Ug7>_dR8>02ZJI;K1d2P4)1,^gVY.fWPQ/f4,;=T9C_2?P/\<GQ4\(;<#
KJ/fY2K,8CJLU65<I,V4B?EaV1]J(6=&KWK,_WF,<@CCBc-O\^_.CJ^=;\dZg@(W
&^GbXe#eZ3O(HHG=6?c0=KJ;3AgYDTb+WLb@?CCFePe)9&1#24d,&6-21VYEZ-HA
&]/(H[:cEbE.,P2ba=7A2):[([O72O9cAP)5L^OBLc>@LdYY=Z_&TG\B0U9RMJA[
[\VL-L)GK.S7_cJaEUD/B#R5ZL++IY(G-(4A91Q>gFYTATMc6Y<AG11Fcc]<Z:5G
+_6OOS.UT5fIGP?[fQdR15/XJ?PVUg]HL_6FZe]cOXKT^G]Y(<+8A5b>D:6:\9H?
eGDL9UWQ@aTKGA:R[@J(N5.H3(]&&dCM-_64?f[+I#?Ha;)Ufd)@Q>?gQ8DKTa->
P#)-JeG+OG+]GW2A-C^0;ZHcB=FSGI6^3VcS9XW+FWS-ON5)+J3fAcD=,+>;WDQD
?CP4MZ]g9R-I626PKBBbB?XZ)&?ZRN/J7:VL0gHU#2<L),TXbUdeb(T5<+_#P3;#
MW>Jbg+)-__X#;7.U#Pcb>SD7(,2VZDgXcD#RI6ZcKBP\6@1b9UEE8XBL=/+KQC/
HF:7&]QLC4I#:S[=)Wcb>MggC2A^.FF@:TYdN?a9bUId+?4EA]b>IH\)^MR&_0@N
9d@9=SEa<b;)-=g3Y_Z[7+.Cc9RJcE1aS^TY28OC3B>_32<5_gFCT6K<-YT34OSA
\I1&K;65^D+P55:fF8ceY?YaB0?,@6cR/L+#SP:3SFE0MH>;G&fOO(O@0&G)(5#F
R6#cd)]\\Z/4]_P0>K\F@RRE:,?F#f=W0UX;b_8(3RDXTG2KG)7@]\5>LIIBY9_V
Z?GD^6)BfA4@+N=20gJ9F0)ZJD2B_EJeBDdVGA)/E^<M-FcIe([CbBNXR\Y9GU^M
HP#]BFcS29)L>21=.2B^g3A]Hg?@[#M/Z+K=>Q>0.=0eN@9=0@]Ae5JAf3ZU#_PB
.O2VOQ]?/E\LI-G/ZbIY^FU:R-C-DA#Q;b#f(fVf0AYGB7F+IC<17OE[I/@L24QU
&[/BIHeW:1O@2BZ[_gS)-WJab.YERVZ??A:fQg5<eP(G_TF::S5bC&Q#::9J8bg\
3-/#WO_V2[_LKRBf0H19-RXa\3(UW@33+0Ad#NCI>eaf5#gY:Ac2Q?XbFLNM?CK=
D,da3[Ag5;MTDM4<AR,f@8&Wg3JS)[1=EegGWVTE,S^>FPW_ZY6EXF(<.ad56b;;
=QP8),C-7J-M0;>]S,JaN]L7V;EVHXY_M8=1_eK-LC-5E^KgGO&F_L5+Q[TO6We)
_/__g+gHH14<B3#[H[MTI)0S[dVVN;X,2XOZSW3-)6GM.9.LZYc.QP;HW/=#_@KB
H6Y_P4_..RadID^C04K3IR>,_V<:7U):N2CILNPWd_=7fWDI+=;^9T=gD[CN&#:G
e5D<8N#LPg6Tf:NIEU4D^2aHEH1C0,cM.,9HKIgFG;Ed&PHW1YX<bAN,1_I_+J9d
N(/GM0,]\;YIYa017+&)-:8Zce.^)SQ6LLL(c7H;)SR[c8=<Mdb(EP4cM_)NPd3Q
@9S>0.-Q5[^JL_YRYI&=:H&=EAU5SSNQSTO8eQ@E_(Ra]g&CDFU1CERdH0A31,MQ
.DIc)TEHX#+8+X4=,#.C3C98J6-a)DD].YSaS?gT.cO-/0fbc(0=TJ&YRb3MQ]\B
4DF<b9#Aa3.-+<c,U(L-Q(DWV3]JaWVK+Td>><5ND,P0aCHbd(/>./[<GHcf,7GJ
1:+ag,9,1X5V+NdPHO1a=4@FcPd@>#Qga@DCa^^27:P_32,IQ+7+FIe6<93EDEE0
ND[.7^aIT48JZWY7GR;](Y;E^RKSM3BS/fB=DaDW9M,aeKA?Q#O,__#4NLGEdBId
YX.S5@QEWM?P,B#(KTV@6HFFS96IaE\6.M_WWWNYE;Y8XZ&1BI][,.a7?-X919-g
-N04FX([53_:[X3#)]-O&]&/B><9g+N@MT:F.O.ZACSA\X?U5MgIH=#bT^I0Q<IU
WD1&EF>(cL<.<aK/O8fD1cEBP-G7CW)L8C/N#38E#.T<SI;N&XT3HR(\?5Ld197b
aPa7JC)?]H6DB(?S0+X3GH5#Y1T+2aQ[F[11^X&SIB/b+IB[]]T0AG-P25D#@dJ:
=--^G.IT0<MQ[PZP-(GP9B0c>_32ObG4\WO\ISFVbda024WgKO8B6L(^94BIZY(K
\4DU>@8e4YTTf8[aGf+#S5DJ7aF.Q(BIR0G#cIXM?aFL>=Uc9PQ0__S=NI1Kg^a.
-+fJKD0]:5Q__#(+7YXXgbbe;1O,_G[JJ4_cUT?)6KTXaf1W:O199C.OJCLZ(IHW
KYBa/#H35bIP(BX[62FE4\T&OH.]7f=,)WeC)W6b;\QYbbDK&;<TF,KN=a@]?FY7
C/S3=[)g7\\f;WHBT8XLDbUc#]CQ,gZW##g36L.LfYCcR&&]9cPd3IB45[1=N:PS
^^WN6Z&c33FLFC;@<YL;>Nd)K)cO3E]]<YOT1Y3E,S02Q+X=,:52OZfd@:5Pd#CH
4TVbQJJJ46E(OV?(JSLQ8E3H9.-#?c26W.gdY&J2J=+BZTeOM]#V&HD8EN=Z:a?P
\EA-X5(6C,g1[>X6A[S?B.DAMK.d;<@^0^N6T_\2LQbN>D.HWCQ=2D7)E\NACS56
-[-\&.N0]@W6Lag8H3g2C:Kf1AD3bZ[_6_)2aOW2OYN:?E4[48A\V#,&,DYGYgG5
2L<:HX:,3NdL(J>RZ6?=(8N#Xb<c;=f>3,7E+D9MY8=7LVgJPa#H]><Z9&?&M@32
D)MX)F,(;Ud?:&QO/?cF6W@)6c,(+#&T23CCG4^HPMR[J:BP.X^]Bd9B2GVdJ4+^
.G/D-(Z8;1P,Z_X0BCg2\G]3fOLY_8GZIf1;<834;1RfG?&T^;OVQ:-D_Mc:)84b
D50cMf->d^M+9d->SSbPT.d_01RKRFK&Q,d\ECe/.BDP^XfF6baa]:XN5XFfXQ7F
0(QY[7JFHIcf(LQR@/-C18g;M[KdTBW9UbC-cH:(QO->UKWNZAGR&3BN-)YK87NU
fUM=)b)Q7e)2C\aW2MO=QQ3KD78?LaUaYS-EgINcNL54)aEAM7R_F1c2,<;6)M&d
KN1]H(WBC]A;#74K9-.;\b).OF[4G.SO78)d3[(N;_1P,K9T6M:5?E#@]N(P0IS_
+\;)6M42+4.8Fd&N2SEFV\ab.O[c@LQ8L0ZT8fVgRMO-J[f-=fUO;AF\N?;#]#=b
6e9#R;6GY==GdW;TA=Z-^>U<784L)Ge<X@I)\,^B\;b0RVaOC\:+W(M;>Q9I\Z-U
J&;HR^+SE9[5SU9(:S10Z1adHIY:1ISPDTb8?7\:>[M&W<aAF(:,PQFd)MGdFg8R
BJaRQDT7<E^J1\M[<^S<XaS^>@LPbDBF-#J>\NAR##<M@GESb;R=WgWO3/KFg9EH
3@]]OY[+@0M[[OB7;C0gW@cOd\aD1F2dXfDdW7dP,;T8QgcPEEB4T]=1RIb[KQF>
&B@7BgVNA4:G?.BUeQBH5aWY8R^d-7H7E>&P1:PfNc0:8P[Te6C9;A@]?>[:I2=c
eWe40+BO?#>624.O9T[eN;fFdS(EfBG4eM/MP:/^e^18Kd(E&P=Y&05:g,bf:ZS=
2^AWUNZTG@aW?e\b;Z8ADAF.cJEg9M+FGL9c\fWb1=W.CKPL,;X76f3=-XZ1CAgE
DJ).N)CF(Cf+T8C,2NSbZK\GGdSS,U#_WZ8T#^d+<cR>R&J-/-TR7a75S6\H=VBB
T_W:^FSEbRdXPdSQ^N/aZbF&ZNG-O=?B,6?V/GD9cFR_48JI-1V;2<WTeXM^SZML
&Y@[V+f@CX688#LbMV0AQVb?#QND#\GZ3NJcF93GMTN.7H[Sf3(gVdJ7g#b75Qg?
@\H,V]ZQ0T\)MDS0LP<4UH#J]ZLTFI3Gc>/5EAET2O[=GdKL2D7bNH#AE\E0N9F;
[/6C[_,FTQ9fF,HN3CR7@QI_I]aD;^3Hb4R9\;/JTcd)6_ZeI9#TLU\gAM9J,^_E
Ie\1M96(PeXUC(QfYJ,B#Q3-ZX\eS?QCVO)8C^CR=]IBV(A#K\::J;bb\6L7\6,e
L(JfS#ZTM5:PRLNE^];GAeM-018#B?@D<?QHU4JX5g9RH/]NBL3<V-C=U>>cD:<,
SM99_^,<]M(55@E+TZ7db?-e6F\4H<cI2.#:G_3e??1F333OPMKdOHb/SU,)9KQd
\;MbY&TWL0&Qg:,P>A)+RL\#G29_Y<7S:JI>eW<-,.>PRF/Q[90;#_L<#36&9,RO
9M?_a08fJXgPN&H5a.BgaYNM1;PeU^DX+>,V?d@#B=@QJ[HT(geLCP]VgF?fOE7=
YUAS#DXNWU<fG6]bP^JD/.dR78JcR(e2[V^SZ-]W+,(4D/RU<-cV6X[fd<H,N3Y0
cbbUGQgPSHI),N.)_8ba^#I]T[c2_@6++FL[V2.?1J+R(3L,=KSA<18ZMU3\^g_V
]SAW?@=&B^1JH>ZHZ),Ldb+>HJ<LGe,VO,d<fYXPU)PU5#)AU>1/J;?:d?_.?KFQ
NJ)M?FLe@X<g[R&F:=23gO^DB9WU5EKMA#BX;M&8IQ_2G[N+g>JXdFP1bW.C7b-b
g0,f15;:(5MDUN@J_A#SH+Hf7F&<3@#g9)PMf6]F9H4@/0/3P24Mf86Rg?:&3,&+
UYX_IOI]/(:K:fcL+)_>GFXYO(D,XJaVbH-LM:LI8Za;^[5,2J_C>:S2WJeT/fW/
-?&&LgQB^e?HF)\B+C&VY[Ya8&)[;Sg6(4=FgE+bG<6Ie?J^C7gE\><E5dDH9T0E
_bVUO051GCX4d]9O^cGO(B[8]??^HeO20/37(J7U@FCA0beU,-]E]eBV.gR^eTGH
a)TIV+6Y.;-g=Tf8TT2O=^fWWEWDJ8>[7a/S0;W?bO0\;P92^(H&(77>?YNGcAB,
HEP1FL\(c6<JQ1;e)EAg#7UQEAJ(>=IeQ:N;Z/62(2g6aQEK>:PZ>cVc-1[eMDCI
,Q]E0+^9+dGWOgeD7C:X]^:]6e\79(S_^AKW7SY&+X@MPT-e/.KHMZIK@.JX_G))
MZ:>/?bg_C)XY;a0IEeKUP4@P[(@(D<8T;KY]RD(,\?e2)+X<O\LBOJ>B98ISVK8
;.NWBMW3WS5N<,;WLH#OK9A-<EJU4-<?J@_7<gFF7+-RaC^S;)60>5<MSVX#)PSP
Lf3W-Q;.BU;HQIE2_]b<,VGH&a@#3dFK>5#&DIFOSVb[ROB+R8SdHM00/4,N(=RF
A=OUTF5I/LLG,=1W.D7UDE8dR>W?2YRW+03>1PJM0[ecY.6,.<8&d:GCC:1GRe\=
Z+<WX+\<0MebZ^[+JLCUO1DRK1^1L[)aBOIDMVFLW3M5JCJZR:afNGDK3,92,L>C
S:,48g8gI)-21fYKgb<.#XIT?&+bg55+U8cM&e[26>D[V0T>4>CW?8d615IYK?L)
\OHN>1<Z.dB38Q>E\7CMT/&.;a.Z7>G2]9WKY<;/:QF9INWU.],Z22R4[-#W+Q49
6JV@:a1J[R1^UfK^6Y@#8:)6T.05-R-7?P[?:,1a<TTIOH?.7dA0\Vc(g]40ed_X
JZa>T@@ERUPcX0##=2[9.B#;HBI8LQT.0-=aQFWA4YMa8M6.KT8)K=f1g:M?LZ&(
d,W#0])J4.IVQ_K#Hb,(1==2(U>AU8CUPcDU:+.g;T<@/8HTX#QLU?(a9JOd;U4G
S@f:4RPd4TZ@515S^(Qcc1CVJ&I^d-8=<BJ&WOdGP2ZCK/>(MA^8AWVdEXXVe?)_
bf-IBU;e(XW)PS,]Gb&3(BZP)K(Q\;IL6V]_U]bAeEW?0eE@)#gQ:Uc]gMRNRK+Y
;ZD<V:aLdF1]N#aPB^B)816L]FeP^2G,O.dOAMHg9?D80e#e;VG2G#PUE1FB7bVL
INN6eE<=-W;M@f@]J369b8=@a6QfXD\P_8OR8))7,C\C;JKY#4LFdD17?P<(.)ET
=[feeF#.?ePS+]g6=:T.([b=8(d;6F.YA0K,VKCC.aOOgMB\IeXSK@Y15Ma2=b:J
R)#5&bDWA2&\X9^a-Mc(4XeN[<b=;S)2Lg4L^95R6PFe_f(=O):gfWNT#DOgA2fC
1[5ND6@fHT[SLB#HbPH[Q>[>@2dD=2&Ge_c=6#6L9C5IG,CNTP#FM]FNd#HAba-2
Z^ac?R(0;I9^XN,13J2@#QY>3Y2e>7F=5I?2Je#U1]-/eVTQ^g_Vd1&&>7)EcR-G
XF)./)36CD\I\e9)RP_VCSB1:#B3N&dT^<\]3;6Y0dB)3@^X<BAc?PGT.d/6>UDL
G-+14K+/0Z-eI8F1LMB-K]&]EUW0AR50P^f4TEZ>C0Q138Uc;/dN,QC8aX::c0JL
-g=,PXbC,^LIA336[^4-aPc)_DTbFVN0I85C[;,A_Xa_GLMP@:3[U;@?QBMPN5:b
+Q[3PE87e,+4CM847ON5L9Y;^X4;&Bd/W<9eS[10OTFAN\D[]P5Y)MY-I3FHF+OW
]2+WCPH4/F?6aHV;1eG&<_W[/cR:-F2^-eG,2;Z<U=OI>BUf3\L]5O7DX/-MV6_2
Ua\d+\Z>5^X?RC>1Id<QQQ,A&&&T#f-H5S#?.2gZF7TOg>PPL&N>P6?FcTLdL+Z-
@2BQK7/C60R_C3f@Z0.)3&Y;?PY+4YV_YDB9,]Vb\CNP:P^1BS3c6??5]G/C4fSf
IaGLXO5O86M\4O0gOePPU]C^U92+PPgJJ@,AP.SLK6I:1eb:^N949G>c-/B;J.gR
PE+S7)S:g9^?,XWUfIdQ>;1IW#W2WR_Je.R+9,aZ1/a-<((^Te/:K.\J(>RJI=OA
[MV47Cd#/BeJ8)WK_CS/<A?b-&c5TB>,.K.&PZef=N&_g(?b:H-6LddU>8@@0E+Y
B51_g7)[L/AfO93R@CA5O),NgO-Z;FIa:eKN@.O1F_4bHgMbZ5G5dEPJg:8g=[B]
fcR-R7/N6=^.#C9Q3-1E+>\[AgUGTCdcb8+9VH/>PBQAc(8SI3T]73-S2eFU<I=\
YT6@WO:UaYB).C0E[_QZ\WB5W2bEbfHbZgZS5#@FXDgefZH,Q]:CFc46gF91c(^[
.T/e1A<#66QDgB]c^+g=A8(7f?.^YL.QQD9[:dS#7?<8(;3NWCg.?7PA?4>1A576
L;5=VJg9Pa>0Sc#AI^7LQ?_SY]A?.0(f>S&VNgM6>GDg<@G0RdCbLT#/(5bL77K+
KN\9dN-,PFf2^+@R?6]7>4.[>A@Dg_1b8=C.gP]c/T,^N,#eG0VI-5D8JHU6W?ST
>4dE4UN_/#5HA+128BHP)&2+875P<7W5P0489S#]CW8gHJQ1IA,XM4\31ScY&P[#
9P@8fVc/cZGL?P.[Tg4bQOdf4TC,fK(_C+ObKf_SXD^I3_(V6M#-dd>P,ZVH7?9J
1<fE/K/[fSN#61SX7_L=^\[5GKE\]Dg>8bPIE:O:UT??>4GHBN&D,;#?ZB;?PY@K
KKQ58UO4cb^MYb?@a.I>&g@AbK83e73)MW86_Xe?,H;[N@1B(IEEC3J8af-S&AXQ
^=M2N)PX=HbWQ(Z@,I@G\[\+\2N6,]NcD]7R=L0YOQP)b[3P7FFJJeAYf0>eeOB^
IdT)&8TN<<a.ATOO]MAW<c26Z&Y)WR&YQ9_KZIMZQKU=QRZBU@>UFPbN@O)54aE8
:Y+QX1X0W#NU3_8DK4Q+YDa<5:/IJgT]JUR?DQSf]P]\[>\8O_^7R&Ne0e]AVP-H
WeR^R/_.+;BJ6GJT)1N3g3ZMD13=V7>-,(eS0MA.T.YAD2&7&]VZ:KZ0b-CfSA07
]C3\X<Q68.N;?BYdZ#9:P9?c]=F?S<S]\9O/BLL,&@c7H;@VbJ/3N?g.?2#1YLSH
F/CG-fFXRGU@?H(5C&3&UCEKbQeBcD+(d^M3Lb3GP/EXeE5B0:A2c=3[?S<dA>0:
WL1I3a2We48g<Z.B6_(NfS2Mc=NFf:Z3N;2I@LUKI/HG^#bE_QRGaRU_/3ZKa6aJ
^a14FP.+g(<VVd0[?JAF8O-B/eK0IU)Egb4NL:GK91I<5FHNLX[09B8g]:0DE9(<
8Y4LY=DXZ[8EI&O9ZgB1F5-Qa6&cYU[::2A8a+TcEG2#CL-aeAI:RK16R09K@-M4
c>^82GIAQ[E0S_0S;19_-LYXgS-g<53b4HE/:A^(g@VRU@T94.WaFd[Y;FFeg\:D
0,EI0(c;3bIN./1S&eHe\M:RWKfH&X:5-[DX,+V\&,&=d_@UFM5d4ZY/Ze0Lf(I;
ICSedaK?1#C6HJ[B&O^XX:B\:55E)AQ2+(<Bb-EC<]bV_/MBTTbbS-\PCC4N7DDR
b<;\^BRdL-8W#eO2f3:.eb7/4W-J>=XR56UL8Y;SBMS(H^Db[5L+1,Uf<Y=RHCbf
=BSS&:+=GI92DK@b9g0YFF[C#OR=_SKGC2=23e_0T4X)-N>W:g34P9SX>8>T=\;.
QUY^f\=I#a;2MJ,6@:U-?ZW,MVSI6Z4HeAdJ6,/[RNULZ++]cOKEDBcYJ?5bW(a1
<LVP<68TJHF,9HdM&^AH=;^AbAM:Mg(E:,AAf,+V^&?\3C7:+b8_SeM^c[N]?GH[
/&dDIH,G>eKEWGS5E-.[)?URO06dA=NCCH^2(R-]&3?I<-90fLIIaJJLQeKLA8U8
QKN+)#21(7P7@7[+/UCQD)]1>UJQ+^OU;T-T>O\4#-V8>/+>Uf+9Ob/dYLMIL/FW
83ZcR:)9;1]K1>d<D,4QHASSS@)X2]FIc5,44CdYacE+Tg1cZ,c1_>ISP\VNSUSZ
=+gJ,P8+Z1aY?T@:-)O<d>Y]ARNDG47L2^C3E#5GJXFfLCV&aL^U7S/Qb+-,^FT1
43E72;e3GFa(?#_R3+N3J[cDDD>AFK+D+PQH4S]-;YB@T1aT>234YffLFWJ\&c(5
TFR2M0PRE53X&:8],+F]MVd[_))Q,0_TG[1b0>bC,X1T//bJJC(cBcBBV4O-6HZ.
RX]D?2dF)@-\f]L6;D=H]X,A,]+LWG@/L=M/5A^dBQ1E#HdQ/+5/+GVFJF0?+:GK
;/7c01X=UGYVG744A^FQJ@Ce4([Ba2(]9f9<E?RK(I4?;c&WX\YC\H;@0/OT0cd_
XK-?#N9.Z=1Z>bEM9E=NVRNK178Z.P:@P[YgY9ee5N&<dd2)B6gbS59Y()H#0:/X
DecBG7d^8U_#aLY2a+T7#@H3ZfS6_#-[3/F<f[Ue&YU>&&N./b,+>YYX.f47E#7)
e2V^Q[1RFT1N)BD1<6.Ta;&S5Xg5;YPg=K8,.,K=USYg\U175fEa1..BJ4Fga63)
N<@fR@-2E=A)HHgQ7g6VH<Y?Qe@c6G4),Hb-&_N[(?I:aG5UY:))<KXf7&c<,#L7
BIHAC#_3b,E@7fg8<UB+/;YIeJ@d_>2CXAQ?_Z:5g3aUVFg:UHK_OYDMRV0JTb]U
I;WG#I2^@=UD.cMHeD(\ea&C,c,8,X]R]I@1R/-9bJB=BAfI>7aR-Y)Ae;RVNC#V
<V;b,LRRN--Pf;Qe-3+XB,M<(.)3_bK6[_ag2eB3+[/MND@?#,YT]^P_H\YK4L,A
6(d8V\1&++c9Y\@6WWd^\L\/S58gg>_0a-^dE<7G84J<>,1U>Jd]@c?,7J<H#6UY
@\I\QZFKWHOK0)=a?S2OUNae5BPF;a?NE0YDL_@.O)+.P1+A(5.VHb7NOeA(<NRL
8[Y#MO)<]+B+6XJ@a>3d#0R3.\INC^D1/[097BXJ2VaE7ZWc-YY&,aF)B@C2=Rag
2Z4d?:AF#,MQcS.>A=&M.+,5g5^[O5[0QGRZSN1-ETWE)KZO5Xa#VSW>&XZ9^,PC
#ANf?P16JHULICIVL.4g\7WgAcUd/PaJR<#7U?G&,NO[WWPA44@X?X6UVH/9S6AN
RX]a&ZM_cDNE+g<468KS0/:U5L.fUD\#X&.Y.d[>U8R)[?<>-1FT060AJbU=7O;#
4DAbV9PW6WBAe.D\-UCJHW;]D[\C>M0RN@\ZT1_K&>[-6M1;GM?A.(SG.\=@BM1D
WM,<f?4MB9T&1S67g#7]?T.b+K_W+aMTCJZ&8KRYY]RgFKXCEd:g#Eb=B]=J)QM_
LSJC+)BB&J4RGeG=061A,]-P?O<NE^_]DR+,SI-9#,FOP\B23,\]D48?K4IY^?D3
(.A\^/;Z?9MMLHLWFB9Xg[1A70<4\<33)32V<Z:;LQS5feTBX-_5A#@\cQOK149K
2C.DV>_ETX@,A@>AR<6IAF-E7E6HKW#YY,(A[3d3+R]VQONd=EDV1^O1H@5HFH5d
;&+g\K,b,45@:@JI;\b=)53HB_O,I^RKF1@.d/+0@WO;)ZTG2/bDLa1-2b_JNJQ-
/3B;X27S#5F@>RB9DKR6=bgJRf1WRJ^SSK3.7cN)9D>)VTQW.eF<b3)ME&F/]OHG
_Y5+O-27H-#Ua3.N]D+<dV@@GBS/@#MF\G6?POcZDO0GYI5K8(8Z89+LVY_PDHe.
S&69G80C_4?,b#W+6-/G(Ec\)NVf92>;Y8ETL^/A7O[_FN7_XDHD=&D6PBYKaC)(
@[6E7V,Y,@QQ_W.4&2^2K&ROJ@gAA@9MgP\O=<PLJV_/Z,II2GgZ4Y_OOb@^cOPG
7/C>5)QdZ1GSUN>T2?>L7/TEd[N\JY&H>8[LSg,5?G8N6-?-9S[1W\F<If>5+]c8
F7PX-/ZdS#c7g^7W_\>4@Aa3,M;&eI<]4gc;Ofd+QQ1>)ObA>CZ4=HPK6+FT4D8W
f1_VEY;M+]@c#3<_N]4O);=Y#O<\TWJ<;WI3eEP6\1CC9X2,>D<AXdJM3f6.S7C9
aR[D[EI<KVg;-PB1.7-?>_-GJ#e;e]eJ0J:V0.@NM:L:UN.-DBU+8C1fS\dSJJ5f
4^L00E0e4=?,4X;Db,UELN4OU4E28EBB+//\F#FZ+Z\P#RMT+[UY2U?#dU?^J0/C
MbIYMYS?L]D9C.I0=5B+T2<#S@ad23JT\S0BC;];H<BW/aC<G>A+<9RHJcX_0?F)
@?dQ#)B+Y1)TPB<@>?K&N;:\5KFW1UGgJH?TdQ<3+:JG71K;I#D,ZK_6F[,cg<-+
#2<I\6[XHKMAON7TQb(Id3Y^K6_&)X.AMQdd7U1@E&CGA[2I[L:]^>gI8ZH[KP/0
:K3^.C>f^HW76<@_b0,9I?[b?L^DE6\MX7)U9f)W+D-PT\W,d1[fI,<?_U7.#=M)
F<d)RQG#-Rda\1M?5=\MJbaS4E[\7C@M96]cDO7WG0&Y7669fRF.>MN@_63YI2,-
5L=S?B&BdNXD8H8a@1/34QKLL2^M+;@K;@C@#,]SILNg;MS##1f,K.7.-;IBU6a]
YFBLX_SK08HJ&UH7(GEKb\)@N=D,fC@[(SZ(V;Z\]AW1&PX)NTE-PYcL=L-Y2&dd
A=KH487DfW+5P3D1^,76>)c&</BObJTT#ZDVGM250L97/+9Lc#BbTZ@<?;X2+^6K
XJ8SUfR^JG,^PdOc]gLObTZeEWWCI_)JD9;;4gcgV#>LHUYE_[H8J1T<M#gUX[28
U<QM^A+MD0L=9ZVKRF83M,39G@4e#T#0;HQ@EJ_Y6>Rd6(6P_7:RK8I]a8&:AZTc
P5cIa>KZ/Vc&\=42I/PR]IDUTI.;T?L@+DXJ-+bKb3.WOJZ7J<@O/FP+N+8EZH^-
9IM+_M[>bS6b)eQ(f<LEC.(OD#aKF)5DLL1?3:_b9=3Q7SU/3b;_(WA_XV2e&[+,
>QL3/c0,ASOJ&W&M4.MD##?J_>-TX?^\-_.M;#H1]Pf)#41Pb3OaQJH[T81CCRQP
V]ZFV.ab#ALWW@,1#&.Db0CCf2J4VFWYT_J#(Q,1Q8TPOZ2(#0TP)5.A=79W+3(4
SL?H+:^.K^.FS8N/X1_L;Q9cXFM.EHCER,KdB[0=&5C#YC[0=e/ae2217[4]@-I>
NOGK=,c6OT?OYTY);e1-b/c<H;89QcHNZ)fO>F\?DWT4PFbH67;2[Ba3#>58]P_0
CWd-R.S7gIE=J3P:0@Aadf=;(?#ZeUfE#5\>EYU0(b_XcEINW,4ZKCNY)/QYD@FX
5[db>H38C#244dJLD@VFg]T@eN/0]/&2]-CTR</:A82g<2190+5I#b_EMC8c6Pc=
bM&c)9;>EL9/aGaGQMDA;gIVG3O3,O#&\dMSLOT[,73TK,2<Y/A+YD3\>I\2G\.,
#W25gNf)>?&<Ma,GFfSAMO\NI)EKZPEN?e]FFOL=1G]IeL:XE/46J.V4REMf/_T=
8\7&CY6H.HADEY7)V+5OKeE+EHAEOM_eT.1;FQY;BANJH6LRaBSJHaDZRe.__89e
=S^bL:?V3L8-?6)IYeYE^aI>S16bQ>^T\&SM^T-7+UXHDLZ7HD>fW5.Rf994R9;b
Qd8AB&)>AKbE01Y<A;6F.T4AG+^[KJeCWHdP&f8V/MV/Y0^W-gF(,_77,edd:-Y;
0^6DG]:<(Y(B>4&dKZ(2URcaPA?-_#D2-(^a_:ZWEA4>g/I7F?&e:U,M;BgHb@RE
_e/I2&A4P=RG9Q8+XXVHe.\Q4122/0de-cNfYaP,N-M<H=5,++,/fK@N+.J+?#5d
F03HL@YD9IgJdXOaW215:eg&1=_[+VCSJ#Zb=\E:_.HED2SOCJ#:L-X^]CA0]c?#
>&If_RGMBGY;V)HYLTQ2aIc<YR0Z<QecQ5>c^23818bN6_bTae?V>BOB;;d60XHL
[f373Vb5e\3.;,([IYF4HT)&cHOOda1BI^,R54/4;fO?/?.#KE6Z/Y;#Dc<U6V]Y
00;]S,BZ/].R\&1;^Rg?MK3N/XfM@ebd3MYGV,6V5W&J7.gR5NHA)8Ya+eAK6NI\
5?8SH-Y(1g(Q#bbKd/9(LI^dIYZ8Q.PcXLN:5&B4a0H?39b+XYQ)C2R=BI-ZdN#5
\ZQCTFLP2\6(LG>)HQTFgDO9OHD+d0\^,g^,W^M2HU>MUf:EQGABRBJ8D43[Z6J2
HE8&I6b#>3YUZg=Bc?(Bd^,#/dJ(SPM?VDBG.^f7+]7bK.,,Ud@+7dcEd8J?B80G
9EJJa(bR.>cC1-Z8\ge7W:77Y+>)5LQQ)VV)^-OY?d-\^4VJE7VR-Qd6V5MGgJJ)
fR=>MVDT2+VQ?VM(#CFNPA@;Q_K.E:;B?C-,I^g3R[f);I@IL?Ob3L3ZI_g_^O^W
7Hde^_(_&e6EMMXYX<E+f<RNWFL78JOQUed.(f#[KbTI-7G==(BV3-+,/7bN^_:+
L7GV/]:N>E@=F:\Nada5;7F0.f#ce>IZO;D3F_,B>dNL1&.\U(Q?C@3<Q[L6C><J
)=Id4<VJDT>6;RF)gVZ/RW7?ZegROKK&@gd>ZL4IKR6.fWN=UM+FU/IbY)0d2IEH
gd20\G0fGZgD9A6:(B2J@02dLPP&A)=W#G0Kg7=U&8fd]3;XIYGZMI04ON+5.5a3
N,:;:DV8PJRe/e(C/SIZR/.eLB8,V<d)UQB-XcCFNAS7_2^H;,@L7VdLAg?Z2cKD
I/\B8K&K6;YQJa[O/;PJB?:>KPVIFU5MS889J\[IFaa+#67;N>C,RF9^4K]:^-WP
DS=;(ebDe/;LffH./>=)GCT1eXJ\(B<Y>e)a@SG-0P+X5a5@c3J2HYPE@AdFf.;A
3.@H[HOOA.X\)7\&=P<0I?9[d\=cbQe.LeNL3SFdYPd-BKbW#?2E.aUWfKZU.G59
+NTU8fJ3_Y;D\MRd9DWdN[IX4,DCSec[D0g,VVNO()C+C.a^D./J.@2J_dQ+@BB6
A52.H2B;17IH/9c-_B@U(X<&F]Q27;MV50fDOfeV:9CK-V51/AJ3eS2[9[GFA>,0
R84SBaC=3:Mg@TWE5cZRL&<f?MICG(?I:3C6E(QV3F=GZYZ(E+<=KZJ\:>W<He?A
N>L:d>UN4Y;P=XY0&<(1]9AS)8;-R74#O;^;EH6@OFa7\&<AZf-W:L.L@H,b65Gd
Q]VFMJ9=/=HF37/D4J+Ud40S;(cZWK96[TK:.3.\eeDH2Y.#:WY?0A+_A+U1W@EJ
B6_(?27X0Xa+(bGK.<1ZdW50-M2;=4H\-[J#JXRGZeU\?7ed8<^9g4W)6@DPR3H4
;X_dgPg#EgPE3Y1TfGR-F>(PW()<C8e2EZ_0BXT2R>]PL)^>2dV1R.,99\;gg]P0
5Q2U19DDXD<SDD;,.0JK];<9L=acSM6&S&LQcCSC)DB7>L0:gHK@5ag3XS=F:d+@
O8f;dF7+F0Xd7>9T#UPBFA9)@9P2R.HfeW-cdRSI+R_ObJ]>c<(A9[6a>K3:0FW=
I>000J3]&Ce:VWI[bMC2=:Md)3N<D^X>BNTf1P=.-ZCW_R7P&AUbKZaIUW8_[5c@
Hf>Xg^<6&-,KWK8J6A9AEQG6-2^g[F:=ZEJ?DH;a9.eSF8H\-7cLERZ&H1=UD>Wg
Oa)aS@E;:83^/F2FR(QRNfB\YaR(#V7_]H^]#,-M0>BMJOL[IgWHE4L7P.?&<CU(
e))eSf&?^d>Y2R\_Pe.RXZ>(5U^\a2J#aT9a=]58LZ5fI@&L=64=Wd-g?AcLHR7+
JU:>3Mb4)[>6L[/+B5B-#^3#U[.,&H0=-=\?@R=+/59]1=)MR/,J=&>#-Id5]/<[
ORBV?23=4IL+I#.^>#IgN83ceYDR\WMG>9+,TF7AXILfa&=f_XPR?#L&a9C7Oa\(
;dXG-]W,/(e0P)(P_/95SLTGZ-:O.=g@OH8d\ZP-(D5LQd0GGNM\97NIF>>JVdd>
MEPUUY8eEH.;T5OJPQ7MHV8(K^.5(YYga5)e-/eYR,3-T19ZX>6<J=9K\>W<,d=#
\43&aS-=/f-C7(:9U]D&Q4<UU285EYb6=K54eO3<77-e>+F]f;[\D+CTD?+,c6.+
G16cTbO1V[O6</bADSLM.LH=(/Ud78#]=P#FTGR7bS]SGPXBC,e:)U2?0K8:?XPg
N2\RST>+CG;CBU6TJ);ga:YQ#KQd5L(=[^GMg))&XXceI=_8(?[3O06f2c(_#:@K
YT\[6;@Ld:[UKF0=,Uf]OOD[QA@K=5?5J-:)Z>_HH:4a)Ke_PL9:;a@fRY-^QfQ5
Z:XM8<BPNB6NYN;8BEXbN;J/DSA9_F0IWO,)Sc2f\&QDRegD4T(/,[IGeBAN;+c^
TfOF4Q?3^8N(a-:OECf:@X/+Y#U:e0#+ZN,J#T;?+]D=eX7<SA1RU?g6W^_>=H1;
QPRdedN@e^>6b>LRY?4\HDDHJb(#eLEHTa5DgbTeT_:)3g.ORG[6))+d]V\U>P),
3Y&(:15XPOR>-D^Ddd4H2>XRRI7^(3eEE]_^RDOaQ:bQU.0c1\;&:^<=Y1>[D6T8
MdX#Y,4:ZbR=[eY_TRf0d58W6_2:J-<V7,MFJ=A9/_5Da3f](_:CT@C</2UD3R8#
FG\cIN1b_?3L#;+.JV=^CV,.IP&3EB0G/b:fS7I1\g>FR<F_.#I@U?UD&6?;THG(
(AA^RGX?d@T2,dX]>79>0HV27#])^0]+La26MTa2Hfd5E3a7g(9EfLZ5<R7)]fXN
-P?N0N>f.V[M9,HY3RYXf)1=G_P-5OLg216FSa[W>8NT8/8)2HPSHR)gNI/3P:U;
I3HX9,[ICO9&(fG?Yga8X)WP^?Z2/-b\?9U7ag)QW-OD6->>MdP&eW#^CcY-+@6B
-B,Zd]a6N0Ug.JFgg?._>e5QI/IRa^.TU&75Z4e;ZUR\5a)S#G[/D)#K:TZ=Jc>#
.YN;EQBR5Ad/\.dS^CYF4I]U5gM)G+([,)DD\\M\AL-81C(0Xe^YB4K+Qe>:>7AA
gZ>HBWY[Ab41cKWg^-P+#@5;KD)YI/+c)+c+bU(K(RA.]dXFcK-^8BQ4)=7CaK7:
OF_PBH2-.W)GWaNbPFNV/#aFU0>-B80Zd9UO7;LZ0Df\GAYOVaGSK[VE4XU02-#g
FJIWPA:+BNb@)TIZYgINQDVITcEG)Q:5[^>DS=_NOS7b5/#TZ7d&G3c43d5A9<Q=
S:gJ[OQ(\ME+^X^f1cGf:=+Me?=:G.f-3#UFTf/TL\+_c&1L?=G)a5HE=?#&TYK^
c5,+e7X,8,;R<[,]8_)G&;Tf=HH;U)9]L4?f@:90)F7@L-cF#CJF#Uc/,M8=Q.8D
HfKggAZcA5+IIY+R#aAHBd:8W_d/Q0M4Qb/\^FO@CRE4d\E=O>e?KI(Ff_CAG[<W
6-1(I:eNQ/>^M0S>f@DfUG:.:FW<dQ;I@7aN957>Q\AW>\62QY408N3COc@Nb&FO
aKLGR.JV+U05aXOF?EbFN[+)=><4[@;+2N;.;dZODPg5g0_@H3HG,b(#:-60RS<9
X_,5T..;VE8c6cS\7MU\JBHb;H^O++5^3:Rf0#HWXK4:=Mc]Z=ROZ#D76F5DVV]3
6;=G>4I&##<_FQF>8;/MG.6#B]TZWN@?c+fcg;;[B=[7_Hb=,^H6YR4HR_=^(:NR
;:TMSY+V8+4Pge9GD^O;QYH\.,HcWT46#c2M2>.7YC)PI[.TXM)Y4QX+-OeW&+eD
T\Y-4f,O_6U.MBOc6;EaXZI6JFAAAga19CE-e,R]Y&=.gACL\YM9E@2K273MUX_^
FA3S<U0dD42-fE8I3E@<T\f2/IP.=><K:O=[ZATJ]cDOC:Q3I.+S,&>>9BA2T,@^
IG=K+OFV[HD,VF8R>\X3>Cg?T8X\b50X@1b2,IRO;aI(]WL(SgDU0SF+77GdcQ<S
Q:]bDD?GNF726R7?W&F97=[I9A8OMfP:DG#fK@,4(2H2R4AfUNeJ5=ZRTfYMT8SY
VRLYHOd[X4:Y,D0dE/<?W.LE\K5H.?78f<FCWK/EJ@,Ta.[[;3?8._;Z>d2WJV+F
(.V58QET<0;A++b6Va>O<9>FSgaOZS:MTSM)UY7F(1P6RB^3aH<.P7:Q6.f]JJUK
-)S^RULLe=^MB3^)CccAB<&c>[)&[]YLH]^cN\cg;H9K_/7Mb/bK28,EAR+5A>:^
:JNQYRKNF39W#?TW]EEYR>BVUDK:K7UJdV;FFF):8GLFS=[RK/8-_E-eUL9/De;,
G[B[B=dbJ1]5]D.G@/FEEb7+)c.=DM[NeK;E7OPKIB99b:KB/3NdL>XgDMH>e6EM
cT0.cUH31<>2DRd7V]/Y]L)#UZWcWHI_TM-)_75KbfVg.V3+L;E//>WO8b]Bc#MJ
=Z2T#gaJe\E[IAKNeVFHHOS57,A2&b.eaMEC_ga.?N&\2Y4c57.C:beT[AeJSZO8
J1dRR9eXJJ(X:[P\d;NOT2K]B@fd3YGX2HB3R81gPC4(T3\Y<8Q6.U>X?6<W]BO:
]0,K5R,c(S7<7;6/9cTSf[TUKHb[,21IO6]9;S96(1MU9Q^-?<4,04S:>E[WdHf\
4-8fV+=9W4W]b#6:SZJIf6a)G>S_X&02?X^c^)CCOTT8YW7UU4V\QY496(MR+2?,
Q7[>>NeISVf^N=]@JP_KYC..UN76(G?=FFF^@e0?,c:+AeBd_-)cXf7EaP[;b/1(
M>OX&<=,TE-ASX/&g;?Y1(7TP6X+RB>J^<S^)KT=^d9(-Kf=8U7_TTS;=C5A_Ac5
J?fCMGaJ\5D.\eR9N))#66fXLd?J33bSeTZ1/S8P^c;\L>a\I8IWRMeUIbTO+a;^
:T2+C(S;H_gDgP\_gf7E^B+I]-DGGDVYB;1?UMcY=N.SAW.P4dN@,e]Z0;W,?(5J
=0YIJOQUcO?bVEIKXd<0I>Q6H[(H7;OB3aV8c;W?f\<CNE^c5W_ecfeb&5J@;EE:
IC)Q[R^,;LdS-c>@=WKCF.M@UGA6A;RE3SIQWMgK1gUVeM-eHK-H)NG6d81,K1Va
+WS)&:Q5G5X:Y(SgGE[Y0\3Y;9.N):<1]HfNL\<9@)?IM&^^.;:Ec9/c>(&+WVEb
FRd>J+E;1/:_IfYPSA6/N8gRF.fT[R9WR_X[-06]3T@:KB?C28/Q@VgJWcM,0G)+
LTT5LL?6885SXVaG3;C-)?Q8>+@-Wf8#Q#^4,1_F9EN//Z,/C8&JF&L.IX&;O+)E
:0g+^?,4)O[K?/ZN+)gUVF@_,bPeR5?.JCbL/4@^7,X][:;8,P9)F&2b@XM7<#H(
K^<+SW.Z_36QbbOf,17.3/+3YY4YGbQBO)IRg5_(4?[=MLb.+DC7QLI[Ne1MGc5I
I\<_L4@ON(aINf;\Hbc.&/GG?_YQ8I#_G^b2LbYS=0MNUQ7f8U5YPH)-AeSZJ[F<
HO:d8/\UMA2=)48E=d<,-F^L__7>SQR1DPIWg]OgY.^K)J2dW-AJ\&6-=J:LNV0=
\(?YZJH,b;)_7:QKCOgP]UBS:-8+4aA&W<G=fZY6EX+_;0D4F4D1)eJ]0N8?Ed+)
EY3(VL@I&30P6J])K[53JR0#,7Ga^>>?^T5KT/DKG,Z(<?E-M+2/M9]DSb+^\&EP
5-JUNS/A@gCZ(PP0a2dIF.UEHLT4N+^#baV.TS9=[DfQc2eWCW)?53\V0#-B?/>g
PUH+=\@W[67gfXDEe1beU\F1U2gPC8\5<1g&UF?f^11ZVdMWdEGSNPE,DMXO+_5D
d>TL_&I>6C\2/dXWD#RSI38J@C7_R^5BYZ;K9>SS3L/^ECgN3JR@4)XIH.(NR(Uf
=3+/EE4MLG+?3<],-@6=c9@8b:E/@^I)0fYJA+Q:=]-.cI3d],fH-:4Rg?0P8#<4
[]]-K/DB=I=-,/B+g/O/0a0HSSbPO#/LfKQPY;:c;96[V/OHEST;f21#YDbO^[)]
Y?I^Rg_\JW>T2R7L<<HD(WbcUI5C+U7V8DaIG7IR3K<HaL+;:IBJ;A.g?=;(Ncce
3cFB3N1K)#R#>Ce7C;=c23/cFdFWa/]9<ZDEUT./](ef&?O^=)W&-&U3+_([WdHT
CE,-TF+M5YfS&Z4N(V&+NUF,]^)+c<,2L><KY-,d_bH1TFNEA[3ae^87SCa]5g:)
3>F?+O-D_>/T(0.0/&-:-81U3/AfEMQ<NHXM/,A4bL2BFDGY]>G8KXRLFQOMWVSd
#<G/<RQcdaV]6DB?H/#N3V0RcVQdJLU/\]7=>g7VTBH>1VFLaP<B=H,JL:A;f-0)
QD1G?-<-M5TAEZ)5SHY1]c;.)N0&8UQ3Q/W7126OG7c_EdPTc+Q&R.B-1?g9GIEg
Ma&X56f1S13b&?7Qe,9D9C;RfbFR04ebLAaRGbHg,e=2.,X3d;2).LbLeDXI]HS3
AgQ(K8M,?CYNL&[&=c0QYB/-BRa0eLd>,g>)<D1>T9\2A29S6SA&^b<Q/W_>3Y7O
G12ROQ_E-?](3aeSJ51:L4g)Q^5,b8(ZJC/[MaYPfI2)]./?-1(Ue0PdN2M=@)6]
;?T[aW5gAc2>+OOd)Sf+?^gXPF367ZbRR4]+L;/Q:#+9G\bMTXZ9UgV<fET6RXJ-
(E=JAaaKgO)[T<V.8_?63?T0ZbP00LPY_f88U0CMM)YBbJ,g9Q4c19]W:Q-K20PJ
F\XKR/C4)(eZ-]..Y)E@+=aXT70,=Ed#<LMZM7PQ+6BHT<B6SFAVE_fH<Q:dg26b
1#c]<+K\eb][^>6UWS4]Z+126XQ)e/IfCG&VTM1S#DNc324JRb<P898ACc@1FNR:
U.8RU&=dN#4UB&>\]WVL/C[0^3?)ML<2(-<5U:U?0)ASI<0TdPbbP\JVWBB:eZT5
=U;5#dU3>eQfL.A.]:T-H]5PbJgBeNC57#+QWL->VUP^B2AWXVK.:DZN-U:R.&)=
21/ee-R?,&41&[E?R7BZNYWJI_D7)TU-([;2fJ-@SZcH5[UN@,LLGXO0d=+72D[=
NR)4_7Cd,g/CRQ,=@4a\c89)9d)T<P:R,0--L83MO=2FCWc]a.?E6bfS[U]6Q][U
e5[0\\MB.Y>S<@)V/+gacX4-S1g>gF?S)[Zd2DNf1DO0-bN+UZ]1aRea^YLO7I>P
TgR:V&[>3ODAWeL#2:S(ZSZWL6U.A=2fONMJQT.NLJ54K4]4N/O^.A1CF8?Y?XDR
/A\.V:@P,a[U?-IDQ2X(cVB2Pf\9/Z_6?Je;dH_(<VZB@1&3TS)S1e,-1&]:NTK:
?)H(365B<77I5d0Y=V]d1CfX+CbJb]/S..W>DQSbB[B7J<TZT+[;?Eg,QQ.\[e#(
a)0;FeT0QWE429E5@,Ia>8HcY+RV.Qb/;84GNISCSgDE]+#3?@H7<1V,_>MFa.Cg
RJCJSU<Z[@&@#W[HJ\#e-[g@-a<M&(.TA00:61,]6>TE6#E.^2d=[IX#VN[LL0&(
SBV(g,a]_>((a:A?EO?=:D78LX&7,K#E>^fbL-O71HY/RP[5@Ef\-0A?5GLbJ/PJ
YS<E;N11f__QIW[Y^K\a^c#EZ4@B>?(J:SQfY6UfP8:g_-V/HY=A:>H<06IO-/E(
7.EXc\HUD/b\K\K4L@KGE),Z(\a/Y;B&bd8aA.JUY594/@EKQ@+R+)>JX>[-FVD9
E]]bKC^SafOFQ@,J@RYcMEHO5OXFeWLK_J+L,1L;Q<,7P7BH4RXeK.R2<_X6H1>d
5fF:]U^K?U<C4(4YaT0,J9+FYDRWS9(@;d<_;Xg<QC,X3#9E95FS=OV^A+a_=Q(6
I<LB+,+C0)/<bJDKNfSTGFHW/Pc5:9b5,6OS9@_J\>1Z_\\22>(,(&Ag7ZH^GUX@
=.C(?U/VM>RRd18>?><[_F:V9bdUN,2/1J:#E_G5DKO+)6]G8Sa@#H+GKa,2/P_A
cT<7V+0N@gTP5+?W3MSPc?<aND557.J,Q?cDPYLF4O4;S6;U7G;(Fa(XNgNE.50(
ecCK=fU@<EgQXTP/XT6;gXgbaQ)R8SYH[;>;_.PI@2R.8M-fb2RTT-5ff@8YFP\U
>F<GI]P:b;>KUbBf;10H5GVD=0L7?F4W&LQJ)c4YQBB_cDNU&30P:/[R:Nf)Y+8L
g?\FeP-/XT<(.-4MAdPTVA)KeI6acI_#75)\4G\gfO#gCA_+H\cF4,H+H]MTZM]a
K[bV]B7)WK>.SZ@&(4U7VM0TeR):SN+cSb9\3U68I(0[D=e+ZRee&>C7e(Q5/b2P
:JY3-KeaVFU0</dXJ#eJ1VZ1J7[eS+A9+dJ+a>94+C]D^UT\RFMO66-G-F/LCcQU
=<U-&KCAO#;d_CPB:-WaA.[+AfKaNX4Gbd=:;2#:>NPR5FY?<(&X/>:Yf9GaLQQ0
T_e(KaSKF#LdVE71_5Y+D_;FHW-abFg>K<P/GI(3T+Wg3PP)5KQJbWV>+W+-f#(_
L52K=(AW>8@0Jc2N3OGE2X3A^\TMC0C=QR)WWF;e-.9)E92_2e]0eWPdRcYX-SE7
c<.L)>DYObUegKQ=;&]L(TOP))^_[+A7K=W6/OZe?L^4#V:7_^BXHPU>Z;fT;]B?
^=LW?fB-E.dcB0IDTP;FW5(H1fAC]f\UE_fQ]S=._>WORMN3X>PEBN-:cHRDLL3E
egJ:)E^+=gX1->gcRE4,<K#eR.HSN3LfW1dY5@+;A1IE:9KbI--P(DCB&CVA#/e(
=Q8CM+TIC97WM&]OCBU)5022-O;e=C?)FHg=2ZPZ0SP+4FYAD4_?.eBMQGH/^2F:
;-T<I8.-SAF_3LX0\f9R/(#-Hb:fWaaVg^>_@<T?&DQO[YQ^f.?b_e4_:3A-KGBG
A3)&CgHVM7H[;7a7)DF5VIf;/H75#U+_B?_]=bKR3<AZ>MA2NX>TYC63EBgaI,a,
EWVgD^9\WM(JaBD0f5)T3^J,;(,]4>_T@X]S028S,A]LA@0(a+Ld-]77A^+]RFRS
2#+MeQ3BO\<46,5(FE5=cEEHCH4>5bg[Z\.7@b=[ed2Hg?PcW497:=IDV_+^F>aQ
P5UKU054W^4^?C3cE\fYH1D^LdfRd;N?.8,HOcZ^Yg9eCg89N8@R.@GIf2<Z)\1[
g@Ra4YQEHAHHH1RW#JT,+dZ&7M>7,]NL;bY0S6KTaFb(8E)/ccf,e0)Q@eWFZP8^
?QaDT\5.9a&>WZ](=,QWG:U(ID>9=cAKgf5=[EKV2]:JODfI6@N-[CaJcg>^a\d9
R/\.TLWH_5]2MV;)_?SZc]c@DU=b5P8)ENgd,b=<gII#2+.D,KB;ITcV9R2&#(NU
S5XFU+6a,1BI56--J;@V>..CNYL/3e10)4DUB8W3fQVQaJUQIFK/3-GIKXR?EBfe
(./W8>H/eB1UQ6==fEXPXX_87[B0-UT,QHT?W<M52XRLB<W]DAbMC=/[W;Wb\92D
;4ac&U^?]Q/ZV41_0G,56TeC/HCO<:_K&aNBcc<T#5g[beU@bZ0,fPYY:GKc>XDF
UX;=9TQO0cD6ITdV7GZRX?27)ebA/XcSJKT+N^^_/4^1BC\5=^LdXQ=V.\#T_9#f
2)JgJdQO3T0@eLQ5\JY&=_G=R6_deF;f#Tc4LV)(8V4;ZO+&O].WLFN9/=H-1N/T
MOW(DK,d8^6?7YP4.6&a\6+7_be[)PY?-3NXUfV50\I\YS;54<1]IG3=O6eL[>0+
^F^#2Hb:9b7^GWd)<;/2:IRFe9_MX<>:SMf(25OJ3#[0S<SGaKGB2;>BgcM.8FU9
BJBZ+XND@>5V6>L>A,Y^R/f:YM320g-)=2OA=Qe1?7LFXY@(V4ZGUZ&aZ5VO3^T[
CH=]?3:.-d>B2)aK[72dXfS?;c[LD@b#/dJCZ9A=G-6((/@8AVEZ7/<5A<BbJRS\
Vf6DF)fVcU6,e?Vg@O)1^d7N&4d]g.PW=e<YU:<=Q@U?]CP&ca>W=A0K#GGOQZLP
O?OZ<0NFKGFe@].H-D^BA:.<.-B;[9Lga:6#4)LC.B]ZPIeHZH5&[:ZVd<IPD8c4
/=QGA8?TX?GL,9OeY^?E;B<?CC2^EE/Y/O8]E@;EF:&VU01KcANfBe:.QCNDc=28
YGfSCZ4bQZ1PgaL,&B,D[gXMM@RUL=-=UMMRB\?Ob&fH,@M7[#c3aEMUE.aNN2^?
[ccZ<3;dd)20:AB&bFdVK?&7MbP/0>KBKC&6E59BT=0TWQL?0d3Ce^NCZ)P?SA/3
:YERWFOePeUa/]R\.A;,M5F;MC8dZa<>7WR5XdQ5:OBYFU.@WV]I8g,3&PVaST?L
@1;;=-BI5;HX70BE;1F7Q2)@:]/g25S8L4HD[]_\?9QB]#.M7U6S4fIE3U1FJ[G?
HdG1&&5U(9&-NZF9+.bTWaDL+F>81UR^HX5>3(EUTU>U>AB552:eca;FA0(SP#BI
LeC]c\E/c1B15J5;C>f)L+[#_X(2\&4ce[A7/SWdSbc?dVH(_)b7>7N9Rb=X4&VW
7?@LAIVE/JN8PU/QDDabdXg_eMG1#YNU7#ce:.G[B-WO8U2ID?<Y,dQEQ[V\T&7;
IB]XRXOO]+;@O.4)[[^G\OXW;bCYbbMH89aB+YP0dILX?3a&V;:+[GJ_bSWb/D3<
-\KJ/G]QR0T@\7^X]9J(]J.b.X9DWQD4@MF_7UEEQG)6XR_g-H=P3_4JC]Y8EO^:
)8O@aIJ;8I>EBTU>SeK\a7bX]@+WG#[(a0+eP)7a_B(),]a8T2HJ(?08-P8GD8(e
+-KW[::0()gQa6EO\a>9E1K1Rd:\#>VZ98Q4^2a(WJRL1_MHSI-&8+6C75QO:7Re
J&&<E-2NbVe]9@,NbQ1<)TEQ)EY56RB;,V:<QIT\JD4810JbYZ@ISJEa867a@Y&X
Sg[Q<5GA,K)3gXY/7+)9EIQ7d+VO8J>1S<^1Lf;OS3d7V>.bS3/2\TNf#+(_/U+E
.(##5^b2eA_@.OJTB](62/P?=<eB&GL:AW#=PDB/(,]8]VV298C@d9#&,<<\5^3f
8^YLORBFH0f]^J9VV@d@7&SK&W/QHK9\NO.:f<\#X#WCC,GZ;g0B<eM1?Q]#[@Y&
3NQ;FdV\2;F]-<bFHf#XHQB#4d/>B7.^]]T-8#U^\@U@BUEOSSKe/(PUS/J+8/KP
S_O:NY?SWgH2/^K\g2/3dQ@S3AK6(V(2Nf324-BRTc=bOf0T7QW_dQXE^[-ZENe=
O>&FU;dLb+FK:?H6,E#)bM)7EP7g7cba.W#6?Y\#GT1HHf<d^,#ffV29VQ4_A()=
V09IbN>Y1[O\JS^9/Kd;M]]_>_J4UQED4-dE>Pb0CU(_C]9;J3PH@YU4:;]9?>b=
7+ZfU4QN3P(Q?4Sb/BdB1>DTaL(5^^S-f14SP3I>8<D[_X=Q,Jb3]>7N=329#ZJU
WFL(E4(KTXKa,Zb/^K,GBGBK3(8e(\W)U43KCF.\ggEd/.-DQ[UYaXYE\^;392T/
X37PV?eWg/>&baYAFR:D&BRIc)C77<4TL5D[9B,KS8PDX@6SFBZ_f^S#D5]OD@>#
:d3I8)N@P-d)Q\gF3I<@bdeUFE;]2SK<fD0CM>).]O2OHL8HU32CgU9/GT@eZDRF
GP+NXMa^BMNP+FKTb.MJRdCLPYV4>DdFK(Be^MGHW/d+2gI7NH1?BM7\D@NO#SXO
d)P6:,4_.M1KUONI0X=7:QVgb>Q+W=ZW24+HY+=.XZe>]Z@.T(B5:PCYLQ,.0&@V
CN=c<?TVf9K6Z5(F@71WPP,DPg.8._gD<>&EW(DD(Q.ag+MeIDc2AVV:/A[Q0WP2
?\Gd<;(bM?=)1E^7SS,E]+UK:N81)1aD/.UY&^D0N?&TK#G6A04J;>c1+.Cg2Y]_
9O<aJdg=CX;@&EH_PgE0;Mg/^J_7S3WbSgIS[;7TgG=XM&:IB.-T-Odf8T@F0808
?(67YM&eX(C/BP.SC:K9?&\AA1(c;M5-Y?.baUa[8RL/;=e06d+#E+WDJ>DQ^)L=
]UFFG&+@g>STP?Ea^M9NbLHT7d9-/8BPWPg:U80E._ADHdR5R=M&Z94:RJ-W\Z\Q
3e@<>024LNL6SRR<;c#eLfgGEcSD7EeRLU[eFOD>WGB;(bCW;SZ.#;dFNZ10\ZB+
_:/B-&#aLc]KOU5K50XM^=8FScaO>Id?ZKQ=baM(:&c+N3JN<R-.fNXe,gTNSd8d
.0\9cFZ6A+)BV]<Y8b/C?W1K3O/R>62I,A2,R21c^2aI9R?M_UX?-[@A3Z_&EZP)
QM\5b(3W9?Hf:MGac1(XRNYK0D(IS6FDf_D_@gMQ@3cS41[FSNYR?D^VN<--KJA[
5D>;/Z_]^4J<8LJff:[7[Z?AA6&NDMT7KSBYcJbDeVL4B#6S3<P]]@Bc6S;]YA2@
O=ZL#8[g-.D0O[MF)=Te]24IJcB;XI-C>e?@0DZ7[;Z9O)V1[E_H)UEa[Z?YF_+4
(1:W+YAVCgG_g/IK@S^IN=3@6K1eTQV&6,.U(5TFWUS,/4^g4B-_H-&d8=HQ.+[2
g^G4#&IdPY</A-HMMT)V[BP34-AFV-b4MI]N&QX_Df;=OR:g-[N[EHEJ9T)@^(Vf
10]Kg4B9ddWf#SKggXQe=Caa3H5\+(D&&S[@Nd(\Oa_@2(:,+42MeQBQbaN/d>8)
NA)C=XOR#P@+=<XCL^,W[,58+P,27]X#5NOIQOVZM^FO1XE2RWUA1,6E8__?b_<c
e>Z/]3]XDKBb@-Q.6:-=6<,:AD4<I:X0&,]=CGZFQ+?HfFa+P=ZO=4.;-0^YY4NQ
1_Q6F(f\Y#/9PDPC1C)T<dIHd2/&;UPV-_US1ff9Va36DbSEZX?^bX.;_.CV1W7H
]#^-<-,QCd/8XeeBdA<N#UYQ>daK_>,I5eY_GIXNY5)g9=8O<HI&;TV3b#&(O91\
Ie2a;ONL1b&0Afc>[<(PU3QKb1H[X]R;3:7Y6>S&9+VBV>,2-4[94)?3&BM8_XHL
]OKQL;VYTe+;OJ]DAPX5K6/.<1H0M_bDd[ORBY#K[R)VE.,-(ULYO.0)6ZZ>8,0A
WL^I>bKA,QVZNKe@P8[F<>+]#@.?8IL-C:C)N:3a0>gS7H)e@^R7-)]E_+3dV8&1
GJb-@7b#2113])BQ&UaS;a3?<3IBc^O)?PFPVS]O0)XM;?I5D;B6(S<F6e7XE.-#
21J2aRE11P^c,233gYSVWbCK/ccM_7I7b[bP7JO.e]=@DF#E+d\^ce@:g0B?ECS#
MLS^gZ)C#([7V;edK@<AQJA91UA3>,L.?SdW6O(<)K202-GIEG0AJ.I-EGA+J+L\
<=ZJ9DL&[.<5K,W=N.@J+bS=BK7[e[W;ESRXN0SH-:PUHH^F71[]IMaN2D?Ee?J,
0DFV(HX&1ZE@GTOIJ[)</:<K8(^.f#ZWH\?=MVeA-FJ1B@E7K^C(edbd77^-@LM@
=0J/B>+G(D9=Y(>CLgOa1U3e@5)8](c0#H[>gfK.9g/1B$
`endprotected


`endif // GUARD_SVT_TILELINK_SLAVE_STATUS_SV


