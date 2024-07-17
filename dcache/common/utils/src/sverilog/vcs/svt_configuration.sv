//=======================================================================
// COPYRIGHT (C) 2007-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_CONFIGURATION_SV
`define GUARD_SVT_CONFIGURATION_SV

`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_data_util)

// =============================================================================
/**
 * Base class for all SVT model configuration data descriptor objects. As functionality
 * commonly needed for configuration of SVT models is defined, it will be implemented
 * (or at least prototyped) in this class.
 */
class svt_configuration extends `SVT_DATA_TYPE;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************
`ifdef SVT_VMM_TECHNOLOGY
  /**
   * Used to define the Instance Name of a component to whose constructor this
   * configuration object is passed. Since all SVT VIP components require that a
   * valid configuration object (derived from this class) be passed to their
   * constructor, this value is passed to the call to that constructor's call to
   * <i>super.new()</i> (i.e. as the <b>inst</b> argument to vmm_xactor::new()).<br>
   * Similarly, the <b>stream_id</b> property (which is inherited from vmm_data)
   * of a derived config object is used as the <b>stream_id</b> argument of
   * vmm_xactor::new(), to define the Stream ID of the component being created.
   *
   * <b>Note:</b> After a configuration object (derived from this class) is used to
   * constuct a new SVT component, the values of the <b>inst</b> and <b>stream_id</b>
   * properties must not be changed in the configuration object in use by that component.
   * 
   * @verification_attr
   */
  string inst = `SVT_UNSET_INST_NAME;
`else
  /**
   * Used to in some situations to define the Instance Name of a component
   * prior to its construction. Mainly used in situations where the creating
   * component is creating multiple sub-components where those sub-components
   * do not have obvious names. E.g., an env creating multiple masters could 
   * name them master[0], master[1], etc. But the user may want to name them
   * CPU, CTRLR, etc. Some components therefore use this to support a
   * mechanism for overriding the default names (e.g., master[0], etc.) with
   * more useful testbench provided names (e.g., CPU, etc.).
   * 
   * @verification_attr
   */
  string inst = `SVT_UNSET_INST_NAME;
`endif
  
/** @cond PRIVATE */
  /**
   * Used by all svt_configuration derived 'copy' and 'compare' methods to determine
   * whether contained configuration objects are not copied or compared (NULL), the
   * reference is copied and compared (SHALLOW), or whether the object is copied and
   * compared (DEEP).
   * Since not owned by an individual instance, not copied, compared, etc.,
   * like other svt_transaction properties.
   * 
   * @verification_attr
   */
  static recursive_op_enum contained_cfg_opts = DEEP;
/** @endcond */

/** @cond PRIVATE */
  /**
   * The VIP components provide support for the development of testbenches
   * independent of the availability of the DUT. This is enabled via the
   * 'No DUT' options available on the component. When used, these options
   * result in the random recognition of non-existent input bus traffic. This
   * in turn results in the random completion of transactions initiated by the
   * component, as well as the arrival of random transactions initiated via the
   * bus.
   *
   * The input bus traffic includes randomized values as well as randomized
   * drive and hold delays to demonstrate random legal bus traffic.
   *
   * (Default = 0) When 1, enables the 'No DUT' option to have the component
   * randomly recognize non-existent input bus traffic.
   *
   * This feature can be set directly or via the command line, using the
   * 'no_dut' plusarg (e.g., '+no_dut=1').
   * 
   * @verification_attr
   */
  bit no_dut = 0;

  /**
   * (Default = 100) When the 'No DUT' option is enabled (no_dut == 1), and the
   * component supports transactions arriving via the bus (i.e., as opposed to
   * via an input channel) this number is used to insure that the component
   * limits the number of transactions it auto-generates. If the component
   * can auto-generates multiple types of transactions (e.g., for different data
   * flows), this limit applies to each type of auto-generated transaction.
   *
   * This feature can be set directly or via the command line, using the
   * 'no_dut_xact_limit' plusarg (e.g., '+no_dut_xact_limit=200').
   * 
   * @verification_attr
   */
  int no_dut_xact_limit = 100;
/** @endcond */

  /**
   * (Default = 0) When 1 the model will enable callbacks associated with signal
   * changes (pre_*_drive_cb_exec and post_*_sample_cb_exec).
   *
   * This feature can be set directly or via the command line, using the
   * '+define' plusarg (e.g., '+define+SVT_<model>_ENABLE_SIGNAL_CB').
   * 
   * @verification_attr
   */
  bit enable_signal_callbacks = 0;

  /** 
   * Determines if MERCURY(SLED) dumping is to enabled or not.  <br/>
   * <b>type:</b> Static
   */
  bit enable_sled = 0;

  /** 
   * Determines if runtime trace recording is to be enabled or not. By default the data is dumped at end of simulation into trace file <br/>
   * <b>type:</b> Static
   */
  bit enable_runtime_trace_recording = 0;

/** @cond PRIVATE */
`ifndef SVT_VMM_TECHNOLOGY
  /**
   * Used by all svt_sequencer instances to decide if they should report 'Dropping
   * response...sequence not found' messages for exited sequences. Disabled by default.
   * 
   * @verification_attr
   */
  static bit enable_dropping_response_message = 0;
`endif
/** @endcond */

/** @cond PRIVATE */
  /**
   * Field which reflects whether PA features are to be auto-enabled. This field, along
   * with the #pa_format_type field, is set based on processing the 'svt_enable_pa' plusarg.
   *
   * The initial value is '-1', indicating that the VIP has not checked for the plusarg.
   * Once the check has occurred, the value is set to either 0 (plusarg not found) or
   * 1 (plusarg found).
   *
   * @verification_attr
   */
  static int enable_pa = -1;

  /**
   * Field which reflects the output type to be used when the PA output is auto-enabled.
   *
   * This field, along with the #enable_pa field, is set based on processing the
   * 'svt_enable_pa' plusarg.
   *
   * This field is not initialized resulting in the default being the
   * svt_xml_writer::format_type_enum element which has a value of '0' will be. If the
   * svt_enable_pa plusarg is provided with no argument, this default will be used.
   *
   * The svt_enable_pa plusarg should only be provided with valid svt_xml_writer::format_type_enum
   * values (e.g., '+svt_enable_pa=FSDB'). If an invalid value is provided then the
   * default value is retained.
   * 
   * @verification_attr
   */
  static svt_xml_writer::format_type_enum enable_pa_format_type;

  /**
   * Field which reflects whether coverage features are to be auto-enabled. This field
   * is set based on processing the 'svt_enable_cov' plusarg.
   *
   * The initial value is '-1', indicating that the VIP has not checked for the plusarg.
   * Once the check has occurred, the value is set to either 0 (plusarg not found) or
   * 1 (plusarg found).
   *
   * @verification_attr
   */
  static int enable_cov = -1;
/** @endcond */

  /**
   * Field to store psdisplay_short display/trace-file fields to be removed.
  * User need to input Field Header name in this field.
   * 
   */
  string filter_psdisplay_short[$];

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_configuration)
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_configuration class.
   *
   * @param log An vmm_log object reference used to replace the default internal
   * logger. The class extension that calls super.new() should pass a reference
   * to its own <i>static</i> log instance.
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(vmm_log log=null, string suite_name="");
`else
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_configuration class.
   *
   * @param name Instance name of this object.
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(string name="svt_configuration_inst", string suite_name="");
`endif

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_configuration)
  `svt_data_member_end(svt_configuration)

  //----------------------------------------------------------------------------
  /* Method to turn static config param randomization on/off as a block.
   * This method is <b>not implemented</b> in this virtual class.
   */
  extern virtual function int static_rand_mode ( bit on_off );

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the static data members of the object.
   */
  extern virtual function void copy_static_data (`SVT_DATA_BASE_TYPE to );

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_dynamic_data ( `SVT_DATA_BASE_TYPE to );

  // ****************************************************************************
  // UVM/OVM/VMM Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Copies the object into to, allocating if necessay.
   * 
   * @param to Destination class for the copy operation
   */
  extern virtual function `SVT_DATA_BASE_TYPE do_copy(`SVT_DATA_BASE_TYPE to = null);
`else
  // ---------------------------------------------------------------------------
  /** Extend the UVM copy routine to copy via copy_static_data/copy_dynamic_data */
  extern virtual function void do_copy(`SVT_XVM(object) rhs);
`endif

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation based on the
   * requested byte_size kind.
   *
   * @param kind This int indicates the type of byte_size being requested.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

  // ---------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset, based on the
   * requested byte_pack kind.
   *
   * @param bytes Buffer that will contain the packed bytes at the end of the operation.
   * @param offset Offset into bytes where the packing is to begin.
   * @param kind This int indicates the type of byte_pack being requested.
   */
  extern virtual function int unsigned do_byte_pack(ref logic[7:0] bytes[], input int unsigned offset = 0, input int kind   = -1);
  
  // ---------------------------------------------------------------------------
  /**
   * Unpacks len bytes of the object from the bytes buffer, beginning at offset, based on
   * the requested byte_unpack kind.
   *
   * @param bytes Buffer containing the bytes to be unpacked.
   * @param offset Offset into bytes where the unpacking is to begin.
   * @param len Number of bytes to be unpacked.
   * @param kind This int indicates the type of byte_unpack being requested.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind   = -1);
`else
  //----------------------------------------------------------------------------
  /**
   * Pack the fields in the configuration base class.
   */
  extern virtual function void do_pack(`SVT_XVM(packer) packer);

  //----------------------------------------------------------------------------
  /**
   * Unpack the fields in the configuration base class.
   */
  extern virtual function void do_unpack(`SVT_XVM(packer) packer);
`endif

  // ****************************************************************************
  // Command Support Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command
   * code to retrieve the value of a single named property of a data class derived from this
   * class. If the <b>prop_name</b> argument does not match a property of the class, or if the
   * <b>array_ix</b> argument is not zero and does not point to a valid array element,
   * this function returns '0'. Otherwise it returns '1', with the value of the <b>prop_val</b>
   * argument assigned to the value of the specified property. However, If the property is a
   * sub-object, a reference to it is assigned to the <b>data_obj</b> (ref) argument.
   * In that case, the <b>prop_val</b> argument is meaningless. The component will then
   * store the data object reference in its temporary data object array,
   * and return a handle to its location as the <b>prop_val</b> argument of the <b>get_data_prop</b>
   * task of the component. The command testbench code must then use <i>that</i>
   * handle to access the properties of the sub-object.
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

  // ---------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow
   * command code to set the value of a single named property of a data class derived from
   * this class. This method cannot be used to set the value of a sub-object, since sub-object
   * consruction is taken care of automatically by the command interface. If the <b>prop_name</b>
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

  // ---------------------------------------------------------------------------
  /**
   * Provide string values for contained_cfg_opts.
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
   * This method allocates the same pattern as allocate_pattern(), minus the
   * elements which include the `SVT_DATA_UTIL_DYNAMIC_KEYWORD keyword.
   *
   * @return An svt_pattern instance containing entries for the data fields which
   * do not include the `SVT_DATA_UTIL_DYNAMIC_KEYWORD keyword.
   */
  extern virtual function svt_pattern allocate_static_pattern();

  // ---------------------------------------------------------------------------
  /**
   * This method allocates the same pattern as allocate_pattern(), minus the
   * elements which do not include the `SVT_DATA_UTIL_DYNAMIC_KEYWORD keyword.
   *
   * @return An svt_pattern instance containing entries for the data fields which
   * include the `SVT_DATA_UTIL_DYNAMIC_KEYWORD keyword.
   */
  extern virtual function svt_pattern allocate_dynamic_pattern();

  // ---------------------------------------------------------------------------
  /**
   * This method scans the sub-object hierarchy looking for sub-configurations.
   * It returns an associative array of the objects, indexed by the paths to the
   * sub-objects.
   * 
   * @param sub_cfgs An svt_configuration associative array with entries for all
   * of the svt_configration sub-objects, indexed by the sub-object field names.
   */
  extern virtual function void find_sub_configurations(ref svt_configuration sub_cfgs[string]);

  // ---------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the data fields in the object that are related to debug.
   * 
   * Regular expressions are used to identify debug features that will be enabled.
   * If these expressions identify properties that should not be enabled for debug,
   * or if there are properties that are missed by these expressions then this method
   * can be extended and the pattern can be altered.
   * 
   * @return An svt_pattern instance containing entries for all of the fields
   * related to debug
   */
  extern virtual function svt_pattern allocate_debug_feature_pattern();

  // ---------------------------------------------------------------------------
  /**
   * Parses the configuration object using patterns and enables debug options.
   * 
   * This method should be called by the top level component in extended suites,
   * immediately after the configuration is received for the first time.  It is also
   * called automatically when the reconfigure method is called.
   * 
   * @param inst Instance name of the component that is enabled for debug
   * @param path Optional argument to provide the hierarchical path to this object
   */
  extern function void enable_debug_options(string inst, string path = "");

  // ---------------------------------------------------------------------------
  /**
   * This method sets up the fields indicating whether PA support should be enabled automatically.
   */
  extern virtual function void setup_pa_plusarg();

  // ---------------------------------------------------------------------------
  /**
   * This method sets up the field indicating whether coverage support should be enabled automatically.
   */
  extern virtual function void setup_cov_plusarg();

  // ---------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the data fields in the object that are related to PA.
   * 
   * Regular expressions are used to identify PA features that will be enabled.
   * If these expressions identify properties that should not be enabled for PA,
   * or if there are properties that are missed by these expressions then this method
   * can be extended and the pattern can be altered.
   * 
   * @return An svt_pattern instance containing entries for all of the fields
   * related to PA.
   */
  extern virtual function svt_pattern allocate_pa_feature_pattern();

  // ---------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the data fields in the object that are related to enabling coverage.
   * 
   * Regular expressions are used to identify coverage which will be enabled.
   * If these expressions identify properties that should not be enabled for coverage,
   * or if there are properties that are missed by these expressions then this method
   * can be extended and the pattern can be altered.
   * 
   * @return An svt_pattern instance containing entries for all of the fields
   * related to enabling coverage.
   */
  extern virtual function svt_pattern allocate_cov_enable_pattern();


  // ---------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the data fields in the object that are related to enabling coverage.
   * 
   * Regular expressions are used to identify checks which will be enabled.
   * If these expressions identify properties that should not be enabled for checks,
   * or if there are properties that are missed by these expressions then this method
   * can be extended and the pattern can be altered.
   * 
   * @return An svt_pattern instance containing entries for all of the fields
   * related to enabling coverage.
   */
  extern virtual function svt_pattern allocate_check_enable_pattern();
  
  // ---------------------------------------------------------------------------
  /**
   * Parses the configuration object using patterns and automatically enables PA options
   * if #enable_pa set to '1' based on the svt_enable_pa plusarg.
   * 
   * This method is called automatically when the reconfigure or enable_debug_opts method
   * is called on any of the top level components.
   
   */
  extern function void enable_pa_options(bit enable_debug_opts = 0);

  // ---------------------------------------------------------------------------
  /**
   * Parses the configuration object using patterns and automatically enables coverage
   * if #enable_cov set to '1' based on the svt_enable_cov plusarg.
   * 
   * This method is called automatically when the reconfigure method is called on any of
   * the top level components.
   */
  extern function void enable_cov_options();

  // ---------------------------------------------------------------------------
  /**
   * Parses the configuration object using patterns to see if coverage has been enabled
   * on any of the layers or protocol as a whole.
   * 
   */
  extern function bit get_cov_prop_val();

  // ---------------------------------------------------------------------------
  /**
   * Parses the configuration object using patterns to see if checks has been enabled on
   * any of the layers or protocol as a whole.
   * 
   */
  extern function bit get_check_prop_val();

  // ---------------------------------------------------------------------------
  /**
   * Checks the PA related flags 'enable_xml_gen' and returns '1'
   * if any of the 'enable_.*xml_gen' is set.
   * 
   * Clients can override this function if requeried to be.
   */
  extern virtual function bit is_pa_enabled();

  // -----------------------------------------------------------------------------
  /**
   * Record the configuration information inside FSDB if writer is available, if the writer
   * is not available at this time then register the data, when the writer is created the
   * data can be written out into FSDB.
   *
   * @param inst_name Instance name of the component that is enabled for debug
   */
  extern function void record_cfg_info(string inst_name);

`ifndef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * This method returns the maximum packer bytes value required by the suite. This is
   * checked against `SVT_XVM_UC(MAX_PACKER_BYTES) when the configuration class is
   * constructed to make sure the provied value is sufficient for the extended suite.
   *
   * The default implementation just returns `SVT_XVM_UC(MAX_PACKER_BYTES) value.
   * Individual suites extend this method to indicate any specific requirements they
   * may have.
   * 
   * Note:
   * This method should only be implemented by suites that require packing/unpacking
   * operations for normal operation, and if the default size defined in the UVM/OVM
   * base class library is not sufficient.  In this situation the VIP developer knows
   * that the user must provide a larger value on the command line through the use of of
   * the `SVT_XVM_UC(MAX_PACKER_BYTES) macro, and so this check should be performed in
   * the constructor of the configuration object.
   * 
   * Not all suites require packing/unpacking operations for normal operation.  If a VIP
   * developer determines that packing/unpacking is not required for normal operation of
   * the VIP then this method should not be implemented (and the check should not be
   * performed).  However, if a larger value for `SVT_XVM_UC(MAX_PACKER_BYTES) is
   * required to complete pack/unpack operations for specific transactions then these
   * operations will fail if the user attempts this.  In this situation the VIP developer
   * should determine what minimum `SVT_XVM_UC(MAX_PACKER_BYTES) is required and should
   * implement the get_packer_max_bytes_required() method in the extended transaction
   * class instead.  This will cause the check to only be performed if the user attempts
   * to pack or unpack the transaction class, and so the user will only need to provide
   * `SVT_XVM_UC(MAX_PACKER_BYTES) value on the command line if they need to perform the
   * pack/unpack operations.
   */
  extern virtual function int get_packer_max_bytes_required();

  // -----------------------------------------------------------------------------
  /**
   * This method checks the packer max bytes value required by the suite. This
   * involves checking the value provided by get_packer_max_bytes_required() against
   * `SVT_XVM_UC(MAX_PACKER_BYTES). It also includes checking `SVT_XVM_UC(MAX_PACKER_BYTES)
   * against the `SVT_XVM(pack_bitstream_t) size to make sure that the define
   * is consistent with the buffer storage which has been allocated.
   * 
   * If the user is using multi-step compilation and has failed to specify
   * `SVT_XVM_UC(PACKER_MAX_BYTES) on the command line then it can lead to a
   * compile time failure about an unrecognized macro. This method isprovided
   * in unencrypted form to simplify the recognition of this situation. This
   * situation can be resolved by adding an appropriate `SVT_XVM_UC(MAX_PACKER_BYTES)
   * value on the appropriate command line.
   */
  extern function void check_packer_max_bytes();
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
5#QO^6O/XIVTJM;b&J^FgYg3H\P;(-a>3?DM8-<[bBR658=RB\g>)(MV6D.LPb_K
NYG0OT+7_)-L_YQCR(GK34TD.;Ya1S/;.9H>W,aOC_2=(RCF2VIVXF;XbND3G9FT
]BP<+78IJLe[gg^BC78ZX#9a-^XDUgEDQF[4(gTeQLD+eQa:BT[7/d1?3A]7WEEI
ba<Zc+5C[_+VcRKRWC92ae]J3QYf&d3aa/<-e_2[F)[Q4aRP<FX=L06NDdKDP[(C
S-YB;Tg?D?6]AJG]^K8>/XRe331:B5Sa?47CK.],)fO#]P?RVF7/7dV2=WcYd<S8
a&G^[GGBM.3+9Y-aQ&T>ROR3:c.;F6H2NI,+#@OX_,+YUU;(dFE4)8D8I>bGC\XN
8C?C4.HH1b:/3-D,f6Z7:OXDS<NM[^E=f4:9+EMK\Hd^ZJgX,\1YV^Y23&(><U,-
=e>fPL-YJ#O0)W)UK:_bVZ5VMZ352FT<I-,#NHd6BdbZ2J9DL,1<1Qd2;S8QL#YD
EOZ;.1DJ/fg]3f,/BFW65VRVXLbV\G9K/&R&9Y>/KFPA@@-M4c).G+51FQg5;^-3
gF-;EE;IU[-.:Y5/T66EOQYJ31e(a=NI0=:]FX:LEE>\XH9<6PCDXGa,=278+bA)
2/D8;+403JI([X/.\VLA.Sf,/E,W3SJXLDSU>4;2bcK3B>;ZXT@H6,9aNE\EBF,+
4aQ0//ZB)fBYV@PJ<(F^eRVF))U/aUg/ab><(7CZ>MMV\DP@W?D886N8KfXUbA:(
bOgVYNfF#798]&a-Mc#GRb+]02.W@:D(W#c/>a#NMU-[+6/Q..7\?ZC=d>9c)O3T
dHAeNVU2\-8)KdF?\@EU(ZYZ8dH91P>,D](;(MQ5VUFU2Re;.9#4=ZZJ?7JTfXUW
9a?F@FgE^FNAVXW.G&QCa##.^A?BSZJZ0]>c#0_/UR21O?T0)4EfcA6HcW(_eRg[
?F:I?0aV.XKMbLFYXP7Bgb9_NFaRKTFOZ2_,N/544I8@F#FK)=<Zc?]Zb[T7[C2U
5JS><[UH(UL_5REDOdIO+aX;-+=TX9dD7EWeg>889a>8[/-b0YF_[<1+9USZ=CY9
.[R[RJIG=M,DLc&PScHb3[6.LRZJX30B=FN7M8O@9MOBHTF(A[?PQB2Q42\7C&8/
8#K+6>:D6fUS//Gd.Y;23F<9YP?73?_^X[X.;)+9[e?eQ]V+KD6.H[DfU1\VP&fG
\.:;[M+;_4DQ,d[VF9QT(D+4APbV/MN<c^L)Ee4)-cW(VV8&6eL]3J,gCAH#;44H
,9#836BT=)(fb0\EMaIW.C@AK1O)DMOD3HTC95[(A-5LX10EK5AFM=/;+Y,,T+LP
8BB2I0+4)c^aV@&/1gb62be-g>;==]e7]6+9D=ZaWV,#:R^+&-AbL1)MW9-egbB<
DK\)(0NdUG2eA(].,4cf@_20dfR6E((XOJMd<K>AQDKI#UTLG:LTAFfS--<0)Hb4
_L3=Z,=,-@Y&8&CL825c]7Z:=.+@H)=]DDXAQDYG7gI@I>EG.P:KWf#\;I++)FH1
]U>/O]fZ^-NKSI\F797.b6D21UaCF4XEO8(-OFgE]JWFEFf:S:&69<Q7ARL[Rc<b
VA([>1B8TYW(3BHY[ZEIOF3LS^TC_D^=N3-fGR?+[b?1]:^AVO/@+U;e)f;+8Fg]
\gOWUF[<OQ+UOXE7bK><K?,-?1X<5MS&]&_3d/OFg:R2[>68fT;(QY(1+^TQfO=<
HDdF@cU,A+-1/5E_&bF@cgW=GDXXHE4Ae8PaBX9]Z>e?OCg-Xe>Bf,7B9QT492AW
DEU,+O5=R.c+&Q-C#Ab1Fc@<R#H,c.\/K^1AV-10@].4VK,+R(>]#0+e2>c(5gAN
\+L,?cE[a9/9;B).0@g\A\J(PbUTcN@P#9QP54;AR8bD+XgA;P7e[SGHY#;bRee>
;ABfUPC^[)Uc3<3@<OcaO/?PSa0(X/.d8VE&H37@9K^dT.Ug>.\A#aR4#0#B1XU5
V<J&:NdC7[71c2]ZKcM+O</YS0QAK_@HJHX7P\\G-M_&1]FQ5(&NcDb5+^VOc1_e
N3WKD+eR\D[N[FKRRL^X6]IOJYUaggD2\PX1Z;:\SgdPS\)NH:67=@F7Z_AG4X&#
A[[C(dLQ/N1RB3=EJAT6f]Ie^ME+_D?Y_?)UZF\]fD3@(W0#CA[7-+V3ZI4FFN>F
J&QM]5N39]7N@<__BOSO>964B,DaAAc;Se+c&+b)fB(;1@P+1-3>/d4=.VU9E:Rg
3:D1a\/2?HECee[SP/f7O8>O^=ca8fM=_<X#4=0+:M@;C$
`endprotected


//vcs_vip_protect
`protected
_0D5IcFJ(S_GV93ZB+ME9,TcgFJc6b,HOOGMX2BEbU_9G.&LEHOT5(Y011[T6N_?
?CccWU\GVM3FC^FWZXf2/9HHC-Ma.13F2^XGO0b=OQ<&S4YGN@-PO;FK6+SCN)CB
CZB#AaJ)/Z-5;@.A_S-)M.F>^@eIP5?HQef^_bS<SGOeM<#_<RWdA8a?AG.X0?FU
]2#&/@<=?+0\?WfeXId41I[=b/+X1\P=8/9W.deK+5@JBFC@JXcB.e\d8b\Q[P(X
ZQ49:)O;>0OJX,a_MOC/>IIc/>Bg3NB&9de831QU6.4GBbSGf3K^JKPU3P[[>JP+
CT.O<7UIGWS9.).a4K+6==WIf(@ENS>+T3YT3S:OCENKb-#4,d\Z(f-H,d<?3#b-
0,06G&aY6#BYWMY,;PK>?OHfg+6IfF6Da0B=)144_,M\1RVX&5aH#4,a(40d-^+V
@6[O3_]W3\<T0D<W@\McZ.V+gX0P1##Z7ZbRJ93HQ&98,+=A<&:ac1BY1@aTCVfX
7/&8#W3FY<NT3?T,>H1DDd>+Y]>#+(eV#dcg.RF6cC^F30<S#\[R>;=77fg,Z,gO
N[A^&;-+1LX(eUM<[I=VZ?3Yg@8J7a:OREGQ\.379.GHAD3XNY5</EU^Q4L?gJ8M
dSSNF@6/cZFAf;L)ae>1T93J0NgTb#NgX;ObcX;d[6FML[EJeG7K;#-T]NBC<>0=
\9.,DJLW]NT9KP]#2F4_,U,>5C[6\AGX#feb3BNeUe^&@-4=e@==[MBBJ(FYHA?E
Z]099,SO79dL.aA.Q@F-XFJC=b_eIT69WWAKe:&;0:+,RFeT]-^Kcb^fGd5@]=M^
HPHCEd^5AQY9FW;eAD6=gY9Tb.OXNeA]]0/B:BT:11B3#AIG1&933fLKa)P:QJGg
KEL8.;XS]6)F;BS4<6NCICWC13d>_5T:OM=D+]6Cd7;JOU^80/5GGE78ESP._W4Z
>LL;NWSO1D<0SG6&EJ88eNW0Q=@^_M9.PH2)IW.68?5d;g1^8XX9PY]QHe0#KY97
(#+>:UPZN(FVWMQ<1E:FRQ9W&/J)UN8#Aa9>=FAA>4=2[V=OEGLGRURJC6_ga7^I
N_6)YcEa[=V.E@0f^GQZJ)eJaST1C<>/5g-8AQ==-#_cUY-[7S:S-SMF.dHT+deI
,c3CZ2L);V##D<@TX/OFfELKMgA<)J0c5K#e.PSLcYS.>9\NEP.b&F<Od#DYXJ<b
8IF08)7GA;]0P2^X[_4.b)F;a=KJ<#<^=G[V@N<UMd<(e.B;7--0_b,L/?F/a,Dc
Kd;a]_,N9\/gS?IAS&NQ1+3--?9L<[cU&3;_#;89-9b4ZEg@5.dPAJF)g>#,6HZ1
+Q:31@,?,QI3>S>@>,OGF2>^<S7,=QF34T/X8;^F#NDY2M\8>N1dafP\(]b?>Y]B
SDE8LP(<aL02eVEC=TLeDCgV0TS+ND=12IEHMX74BQE2Uf(MIf9YSbC7A-0I#]Df
GS/b+<#9&Z\d8[,+?8.^6<bI0BPWfB.7@N5S@(JDC=&eda;N[TI34D.GBSK[)N#W
\Q;M2Y+9Y9-\E@W;fJe,SP6BCf^#MU&G-.X9Ng62b_[DG)G:RFCG?<)7);E@.dcC
=3ZA^N=[e[O)LVQ.e94YS>c+H(c1:HO103@N97A^Y@E8_ZVELeBFR.cOAEW#<f]C
H3\YY.?g@fNSDIIW&)BgH[a?3-[eU9LRC_RXMPWL#_HeIgb)93W<2(GK:M=T,+3V
_XMRV.DBOIGEJ=KSQ/5aN,S-2^.0f;=JQNC\7QFf<R,E0;dGN&T7Ub/8RgAN(5;g
H?;UZE:[<]?=S(2P_5O<X24>ebRQ+d(AG7=^f0GYC)@QHB&,F00@)5T0)CXd5f+2
5O@>.>V/SecQe1QO+6BaLc2]05J9c_5V:a3#D@CXT[_/;d7NQ@DZ24e+T-XCD_XK
bPgLYFKI^?2163b([ZTEA238KXL\:-ZIX#f-&^3GGe1MdgAFO<]Xd<gE[ZI=Fc_P
4d4BZ5E2;bSOg]^M19>(YOSL1?AJE@1g<EdQRA;6I1>/,.LQg+B7Zd:-6B^2f&)0
=J=B.NN?37fP=SG\7MO2I7)7@[1d(LZSaN20M#>fab4d;(bHR9Q94(A<IP6XTJ0E
MQ)cIC=CUT@f)V8//7>-7Wd04)e,E4@?9Z?JJ^S+?d55cT2]9S<=F27S>DN#cL3B
;/<X].601I]3YADW6:5YWf/0IDdUF])B>78:-0fAHDEN_&]IS+9[A./AHcCEP;ND
8e?)SVT[\#-@4MU-8e/3?=WR:80)9GYg46@0a],7_EDMH^]@P194Z2WZE0,B19g]
,:)S675+_J4J#7DJB,/^,)OJCagJB,=7855KS?.4]QXdb6UYJMaWJAF&-dN-BX)d
E5=Y@YUA=L)g,7;^PEH:4BU]>A0.I@eF<cV[]6(#cf/IP.W_O=Z.UI;=eE6#dS1R
7-M#f>RMOFS)LC2U>+T_g>+f\#VL>+&g+_H=C53S)]D@PE.DWHM,P,YZ(\PZCg^A
(?aA\WAYSLEQS749=BXdYW+_eVNXa0[/Bb,L+3[ZMEX:-8<Z5D65\FW0[1O]-I[g
L)fZ)(XcM[D)>V7Q3VL0[KdZKXQ?PV0,&&=IbA5KHcd0T>We(^NYaIBL]CYNUNBT
aC[+D>?0EPcT@J\OS=;W?;e9010]RJP_MffS;=+,]#YWCJ-&fJRF7=248c>@/NNJ
4&VDe68;4_<a0WTZ,:]2d>(c@H@WG@DdAPW1?^U)FBK0]^:QGH2-X1D<OV6dVfDU
;>\d)D+8EMU>bJOOICcP>c-5/AVfX<1+AL<fa]3(5XI#YDB<Kf_f>5,_8H[P[0HT
/Of,GPVLW2+&-0g]d.7MgdI.=D(fE.V0J@T=>+5)TO/:FR0,e)-ZN^d^=E:,Ab-1
H9?P1/c<4bPb749<CL\6<4\Ve]VOF:M>WZ<cWSS^@KWC4a:[HTV-T#g.C:8aZ]R>
Y-#:FZ>cEeBGZ,HdJ&,6&M.Fe=E7:TL;O2,-3Eag^@L0-6)MXZ=e5;<R9J7E]<\Z
R;H0O.5ES[Q)g9+BaVaM6e]]a4[=Cg#=W\:bCEU[/L4UCS15;Be/8.b8QZd5)13(
-ZGfg(]A6SH?8PG2eB9DP]C:[(OC6\K?</YU\,6NV4717^+]1cL7Qg_N/36C.E:G
H6O2L\6AQ3Z6^J4D4?U@(M5]Qa5;JGCfR_OB<W63YPc/70W,D#Dg?e2fP?L0,0JL
9=P,B&2138^#RPD0Fd\HXH@(1Dd>PWWfC.8(>F]OVE=:TLZeW-<?[YG.6T5#1B?=
;K-#_+.AUT1R1A2S=Y0S9dT]EJ_]M303Ue4\]&Wd@e.@C8;[1F@LTJ-f#3:_0&8>
C8MXWaYFU8A#5]ZP7IeeT?0gOM0AaE5)(FZB/?8Y.aCN>_EAVJM5.+:X;Z_LBRIP
>,;fVgSV?7gF_@&KE:fD+8fEg3X]T]7<?A>c1M@<OEG^<Y2UZ][NI=<cFRG<QZT+
FaWH:FTA#.-aK0HD;4M&&^7F^-M1I6@db/f5D83OeB3I@bA_DOJY4CW>96M^)K8V
eA65OHOWRN;W1==UM+aR[T=KgDG,O/IgW?A12@]+=7cbJ,KIb)Rba:@)+AL#?J[1
F0UX=OR]]0g7.KO9Pe,VC7/DL)=Z0K3&[K=F7]_WF]N\_GZHbQ/I:dE:?F;H(4-&
0P.)]U+2F;4f-8(7A\BP(@_/X,d.45^(Ye^Pf1#N\a:4X&GROE&8UD>M.(/d+dY,
2NFU,,5R(DCb?:C(UU;RR]/ZFa[ORBQbZVaUe0]M?PZ+=U/_[L/L&Y.[2@ART_bR
IV8-TU7+=+AgM-5X>V+#3KaK)H)8Ra@;b4A0b.<(3VW;_QM\.Q6^2LMd72JJdGJ;
S_5@VL[GN[MG5B>CN>@7O6D8QE70[bH]d?RWgX4:E[.2D1^_EfAaP-Ra,:)WHJ]6
\DB8U0>cPYU:8/-XI6&S6AW&CN\2BS<8\Cb[Oe/-70>&0A3@_<A?DNLUg+c=P1)X
KP<>Y@V63CR>]4Xe927O#/<Y](7;=O3RETLR&Rb>QQU#ZE@BKD&UM_AP[/?E>bG]
KeCE-);g.>1D]+=g)NR:TgS[ggJ0)CMDFSG]RY@Kce_+X2SB1IT-K6S2^#6,48=-
;I=3:f01@C+QJKYCZ9;dV.\>+a7+GbN)3A+KE13T;-^/FOHe2.-LOD6_T[FYIN3,
4bZ_>:+ITS1UB#AJT:<O@9Kb\B<8c8Z4CTKF3^T^EZ>X\)FR8;E22AVXFSK:9W]A
P]<M9_J65\^G1-0&VbF2/MQ3[=&JfY#L<Z0g038^0;0E.B+FJ4PHfUdMAg(67.G9
@EV=/&F^:bF2JN4\29]@,dfC1&?US]\QXMCdd1M=VWU(4]VZf9gf,L(5P>@?R-a0
1FL^Y:07.83;+,MNLa=@1OME<(3LVQX60]OIAg9We8H475eTeH:J#0HW7UORUY^2
IDI5PMGX_GRXL;d\Fa3BeM/@)T>7-f&N,?cZaC2&]e/^c)@S\Xd#FW3X8fD_WY(S
.Ba3=OLT3=#9b3^3UaQ/bfLeSATRGE4)TUbM74JA#@c.PY\-+SLITgcAegK-,b;.
MHT^cdIPCa,1[G4QZ>UV^IA](3L52@JM>).)07<9ZXVR6,1C<XV#bQ^DD34_L_73
XXFXX[[5)cJS,Z63E5e5dc)ODTW3-]#;:fS)80\0cMUY+-B2&A#N/Z(D4b>cF),Z
Sc8SRHfU+?A5])@&PAB9QZg)gY#gP4egOeRREHQg4U532WZMUL_H,=9XG\O9N2;9
_#[Hf1Hc-Qf+&8aZ)=(EQ9?c/?H=W?aMFK^2QC>1:Z,@.T:Eb_>V370b#/D6C?EA
S=/NG>f8&QFM47.aARf3e6c1a+-Q8Cd(b=GOZ4+,F<0L3CT@2H8-P#b,Me5HQER9
VIG0d7]<2O0V1RH>-^E2T\aG^7_:/K?b(H4),:A>1cH\=+e8NJ[+b7+GV5I4P6IS
@#cAD+2e4bMf_aB8XV):2Z#PX1bB<KT]VeR4.OCN_L0[YdLI=P3UJJ+ga[EdF@2A
@.?ME_O.A/Y_(91D#fTF.TcT?4KQ&d(#e4]3/9ON^KX[WYT=;0_Cg@-:E.8d_T)I
B<V5MC:KLM-Nd(VS(1S?8aGQGID,5K-\;D5f)dM4M;+?dSYP;1C@N9T7=?a7(5Mb
/cK9<2:_g0@IGU_1O@+]C&4YUVI9^8?O4?aVK:<0;\Y3TK,LX>GJHQ4Y^_JRa3(b
)0ZRXXJ4^D:&TG.aXP_gC/J1fLf5UPaWa@=.XRPXB.3=F+5_J\B>D=3LY0#dO8<8
:4;Q4YVTb6))4@_B.\,=3+bF[1-=77=Lb#(T\_=F.f+]W[14>:KZf@Q)?PXO]&\O
JdcE\=Ab0C7b[]AdCGJZBG:P/[82WSeJ[EW-Ad<L31JG:/V#C_F;23+\8O0f/(TA
PD[BcG81fQD/0DdB[0WG\9OFUZ7NJB(8^646-+>3##_Mf44VX:EK^>1bJH10EVF)
GWK=F@g05.gB+.IcH\>^d>A:9086Da71eIW_#H,+a+342g7<.eSG7?KXEI9G;=P=
N/+\9^acLO3MZN&(ZbUSK/JBD5(-_1<,9<=6=HG.1_,CK)A7)#VVR:&4<SC#(7IR
)1fegG1^LCZdWY)+c#<1DHbBYK0DK0<2&.2MA,:bd/E2#W-03E[fP88\\G(gX4\G
.<3[cWBY,\KdZV->d-NaP,9H40@C7g5e=-aF=A(.gYP&aIB[_WKX()5^?4^4T<;F
QEURLN^=aHGUK8&,[_<L^R=Qg>ZP])HAWPeEN>ODJ[]fNCfVA_J]c5.W@W/VAQ11
8.JNL<.;5@OJ;fPC<(WRS6JCSg=a7A?b;1BS<WEb(G?^a#K7/N>X_.b@XA6LPL23
0RDVC(,DX\;BS\:E<bVd#^T?f;4W2Y8YY3F?=Q1-]FFJM=MU949-B2^CW]P:8>bV
K3eXT:g>>CM,L-2eU^dC#09)eBcNZG,PcQ?2bD)V/N<4O2.:gXL;ZIGI.6AT,c\U
>,NYd<XG,2(>UO-SWA:g)YII-L?/Z]RMTd^e?ACZVf.\T^A(<afNd59.N3F^B0S/
V3\BM;U.gEMJ(/XVMWG.ZZ?L<JcYABZ(G/c;.E@a@/e8H^^cVAP^.3(fcDM4d3a/
6BCHC5Wf00<6E&@JWb;M5_R#9.I,K81H(Ee44MN3MLe_=WN=.W[Le\XfOcLc#\KP
M?b^(GeRX+dO#^0OfO_^4Wa:Z:fTYC=Q)bId^@A,Q-Z^7(QFU>&0:::8dO<L[D87
XL+^+E61W:KdLT_A,4UfJO,&?\]F_=SfHNP[[g>(:-V>],6FSb(I9<cHWQ[484=<
/2^cZSCO8c6_PNV6d/PYW=gUW3egCZS5(5K(=@8&9N3D0=141&ae48ZADVa.#^g>
TI\TH1H7PHR<V>-T2\d2aVd?#[4K&5/a6W2M&P^GJ)0G2ADX[0#8H>(O#&)L)^;U
0;YM,XL2cQUCXbH1[,6&gPDY:,?>81Rf_3#-/+Gb]P4HPSeB6ITU?_G@)f1ONX5Z
Q+_Dd9EQ/f#<]g@0-[S7J;eC&b_V_XXO47XL&Ha\,d9LI)9WU\UQN\E;,e,@ZW8)
^4Ig9,e1VTA@G[CUNR3:D.d2UV?WTSg>fF<ZZ).8e5f0FO9:]bJ7fMZN-F@N.V+\
#<B/#U>)N3LDaXQ,\O-Ve@XK297O8)GC==AYY-dCUdH4MP6b7(96#ZF;I5XXe[IV
@SG+(/J\fC&bY=0I-/BA>Q]_73+XIS]Ef6]52XSC\_PKWeNRG;Y6]J15b<R__]LT
OGI4@IbM9BHeXCPdHB80W9PYeDgaL\<-S4(J;G<NKV8D[A537FRH=,0gT=9N0I\#
HIKD+UcYT:.VU0UKc(12XMH:3\Z]cYT>DBYf#GS7HK-QXaeDZMfFe8gFAg.+0;Oe
D?[e=&Y+X(JdL/U:L]cc#aT?3<4_e+NR>&C-V;fD]G)(O+VL7N>27fa[K);#]e4T
bZ>M,&NM<3#,#?IX<Ea/NV6.[]NIPH9f8=)8G9-QaI_[HeJIW?QPD<8_CV06MeYQ
>0WX<2(?CM84DS99M-F8G/8DH8-ZS5bd5RW/f&/[>9>-Q0cP+QZ]d5CIc7#]U?Ug
D4A[g5RHLG?&\G<0OU@b+UQ,Z[aY)<e32M&e5ff9S2O_?T=&<\fR:1=S@6_g>3VI
;M7SePGD&;WWJ,):@F9.5.@O,+IK+QZM?PWVCN79CY/X2\:D.@QdUR5D71>;ccd,
2AS.&T8gCIMgb6cF+UFc,_^(MXOd.d.79(^@(NA^[FO(K[^]8W(&UcC0+ceAN.A#
V29a(;2UX4NA(F5fd[1Ed]B,>UJfJ[#M1(NEa+dO>J#W(Y2^?5Bbb^/5\&1VLeJ@
/;A;><B[0P:Sfb\^MF;dMS.1I6B4.AF+b&N(]P6)b#E#GW\#B6<0a;(SRZQe,NR;
dOcfE=(M2c8S9/F6B79c;_XI;7=(CK6KCI8Pf-Y-Cb.P3K:]R9cR<_fEW17?U9RO
X/DNM\,/YN7:;9D3A8,EJFga&MY:Z;/O/K2cOV=)a>LU#Vd=KN5&B=&UMH+7R,K/
1eF-#T/]JD=f.Ng+.GY;MYK1TN=1^4d_CUEM_OL2#^M)bE:Tc_.F]FX[XY[g5fBV
N3fS<Cf-M8:d(8)1K7\6-/\(1@>PXTLR/NE?DA(=_0?;+dcJW>0OX6CJ5JYX^]b,
)5,Fc:fT(#8E;:;_gIP7Zcd6;1QL#JefA#7:.=9(^158PKWF26bH<]MddW^SC<eS
WJaHa?^5fDXIW^5JGN-?J8ANHb:,J[^=)09WLA4dQJV[Y@JBFAg_(Be7@b1EYLB=
PTXZK&?4A,OUC#0H0DL,4+T1V[K;.JCR:3SJf..Ybf1LAXbIZHCF-eX1&SbA>W8?
JJ=U;fX7LSC_7TAd&CY.M;Bd]EBV<L+#6#3=P9VI6T_,7](6?\@C7)fGN3FNEg#A
E;@S>HEDRAaAgI].]+0:E_PQ?U[_5b@PSKf2FMKgPNQ[cKS>MB9?3A=Ya_SUUPAc
UfdFdMBccFTaJdV-e<CcId7Dg(,->?YW;f&&OD.9XB_44<P_C4[J[9X]GFK,YS9Y
FdTW@IA7X4fKSMbZOESZ=,DK5_K@^SWZ3AI3XD52?P\)9+9\9Y_RD931c4)&HL/1
;cc>>JB#[4&0J&P3R,_K-?B;;D1ACPY^C[5?,6\B(LQO5;DWU3D1FY5I+)gCS1f=
1</TM\c[JWfY>5N+H8?ALJ4N?CSJf#)36ICDgU-H7AIc8V&IBW8Lf>7N#TI5OZ&:
b(>+5/)HI=0/95E@M@#eMH2O3,R@^1MeTcSN0eT=ICZ;WB]RA1FVf8b>&QS59e\C
1L5_JPP_g<R)=e9:adV<TUCTMbL)S.R_ag,WdE=9+H?S>+N^Rg;0U3EF3U7L;VdQ
&=7?8+f>;=1,af&-^K5NUYcI2)A_<Lba\Hd1KHgfMgLc)G?-JB(_b+?=@^_OdIFT
,2@>/BGJgS+?66@=R]a0P56^[gd,9,)9BA#=]e#\:S0]M>&#N1Y7bOZ60gOH>DHG
&Y,7+#^g@)OM9&EZ3]VEKTB-IKKMMW&Xg?,XU)7QQ0JbGe(]aR;KAEE0/Q1E<c&6
FR#da;6U)2,3<baG9fVgY+:O]U1YC\YR#W:dD._NJbBgU.58?FCXU:DeADf>S<X9
\HKA0P_DLOFRgbD9?4g4P-QGD[2F,\@bF,QEBab-?IaR1^a1aZT=(#<:>Q&&OO;d
7(,IN>[A#bXgN34,@2e?(2gKA8B6&_aD22/(E2;acb\90+_QeLMSf#JX#X+g:KC^
3:XK_+)G:?A<Gf6c^H/-V)>UV#K@Tf5=gC;-^eK]-K+^dR7be#0_g0eFYRe6DY>M
?LY7PadXPdM:X:_,COccJ3K].Q]dP<=2:=LA,K?GZ-4:?0&FTY,;A>XT5[/C2SG4
]0>,E=V=@0g49HZ80S;Oc6[f[&E&N\S)MX\MSP:GR^MHCJSJYH#\8ATb<+8Zg#<A
A9Nf3C947g<X7C?5_)f>355;]YA.IS/a^FBD-0^Y6;&W[SI1;L4R-PfJ7CDg=b_.
^KZ/E8RKUXQ53^]0Hg<\LNX1Tc4=C/J,MV#/:B3<M\c;\Rcb<Ce1QN0)95fK9]gY
6Na1CDVS74-NP[M@4@B<P_B8ZHU&D#Ja@WT#7(:RRD;3SLd<N1IUIWe0:#+\.\K3
\1VIeVg#I@(JAD1@c6@](_(1+_-(IG_2K_^8bJ\.4Z[7V-adUCZDAN[BJ,<KG#Ib
K7][C][RX7EN[8G74418&E4MSYAA#Y\<E51gRHYa[\@<dZBXMZS2=28d-AT@)M5W
dS]XW^D5,M9;)PaZ5+b62gF^M]Oa+VeNbIX=U81,Y/Z):5:gcBNHS_b65/:5U9;M
HFHE[#aDOXg<GM/W(c4c9M7TaU^N4U6\8Lg7dGK5LI0O[&(:W]XQA5S/QRG[^8gR
Ra+(X35)faK[L?T&>_W@OW4U_Z;bCC]E(ae4WZWf?:(\5Y;O9HI&C(S5X4I8)?F:
YJDMbL\,JG))2caPa:e_Z54>Y_:=g)7f0YcBgLSMH+AXCQbcEg_,51-U43fL1Z0d
ODfS7<3NYg#[DeT##4(8EXR^-I8eE@IET5/1Q9E;V#_F.^JZMZQ<8TOK7L=Uc+CB
Ze9(2LITTB]Yf7/VS.?7M2KdV9((:\d#W6(A&=RGBDA;fNQGB6Ig8=)M=>)@BbQg
5ZH\E^;U8D:TKaCHL+AC/;>1N>I)Vf4=I-.QU)IEZ4Nb(/BD;N?_ED=c6OTFfA?9
R:4)K6=K+J/N@+1(fCG0ZM]_>XI^g+e8gOL\^Hg4f,I0,2SH:?R(6X#?aH\R<c+0
2&E_(>?K1D6AN<#F8@VB#:XcYeUeg8E]8A89A]#=B5Efg7aI,de@V.2TCbN(P60<
fI_Yf.COUJMHTLO#BFZVdTFW484T/\/Z5LN,>3+Jd3WDTVBdQeVSYK<CXF1d1[=,
5AH<)Uc@/4EaN4\3eFcfb/0<H..&R[B]?\5f_^?8A=P:W2H4VXa:eYKe0Q-TZ,1Y
DcBUONWR&J6<9#CK0U0>-758dVS/+WM:CU#\d)/.KG<Td5#^/7CSFU-Z;-FTg0#B
:C&VaA4]MXDJfg((YWWcP3Z?,AfV(S)?O8X.Q1)gIN+-KV[>I:cGHbdHgY?#BcG/
9AcVZWRQ:#8&N^&K5J^JYUV.SafRBB78#YC9PO/&J[T@PG7I1:EAg72RfaB?@fXT
SVe3@&[Ke7BGQCAbf8AG9CO^CTSBaL,EH6Q>E,dXM<AZ.+b<YPE@:\IcW4L^CbT,
BZNP6)Yb=N3(?S0I,QFEDU-DeS?S<g1&X7Z1XRXF[1RMdL/+DTI8<GD;O5+(@D3.
.bV<G/0AG:_VU0UcLP9Pf[M=(eL_:IOZ.dfWG52FITge#d8+BL./(09JFc_C<fBT
2X;/T.N)C;DYT3KR:&47/>+Z(9L3PKQQ3S/NEZ_OG52GMeVSOg[[\Pe1Eb@5KVXV
HSa=@TgX&^U4Vf+G9QQDT)@dfTQISg54/Y)8KGITeXbTJ=UGb)YIWgVJ+@KUHBMD
JY^;dUNLVT876T_@Ae#J\[0^Q0(a-AG+ZY2+B+<#.(><7L[?7/1T#),ED,GdIcX=
:e?\]+)#YXVW#e4f+AF9WDbF@CRa\MDJ,8D76=LFEPVKRa,T#^Z[4WHKGLS?ZNNa
[F.)+f3-AYeeXAF)cI^ad:8ZL=PaG/ba^Z0SS7],XeOQcBRD[_==6&^90RKN+>T]
71BRc<4D(KC2:#300eJgLOg-/VL5C=MRV(bFc4aU[)Z+)g,Q,<Ac1]MZIe4<dV/3
c)^[P5Eg^+>>FQN1fDJE<G7HY:XZGFR9G#G&OMf5]8Fe0WIbTZ,\AC_)NYBR0?g7
<,LdVb,I?:I0c)4Cee-?e6>BM6YaYfPYcY+6,S,-H;RB5JXLCf.F#ZcS)2c&XFS#
ZYd6O7([5g;&.,EJO;#81-UGO@QRUdM#Jd;eO:L7;VY6S:9V>09:J+=MFb5f9Q<,
)/R+=R;A&OZebN30ZAd57,4cMUV2NCeS-\ZMb85)]>d722M[>N+LJDQ@A3<<X2P^
Qd&@dd02VOF=.LH&5).9TZ&P&cW630JH6VA<[9]E:0079[9ag_aR.](^3be(M^0=
<g2WG0cU)M+T==B/CU&PdVJAB^8BF<INI9\R3HUXd;BG\>F/cNV\0.6FZ^;VPZ\X
(:]&/c]M5P=8/=GUK+c>a[8;KUe7TMa#F/g(Cf4U><ZF8?NY)I3)MY&([bW@#d=J
9^#CJY8OaE=SK&^)KH,f\T[\VDAaJF5B]X\W4>M^32KGX)S[DbL@D1dOR/V<5WD1
JPF+XER]UR_5M8JTFF,,<A+0,;TC]CSX/37A7CT>.LOC/<GO]IOSLFKZO\Z03;/1
cN2JAG(dLNUZVGf^B&QWR<7.HYX5_,V=/=VG@<JS]77>6f\FF4#8Qa@9]TFIA7QB
[BV?I[[eJb62V&ZJ&5;c5ZCK;6@@\L,LP.aAW(+<]+O]CL^=2QED#8(9R^Y26^UX
FS(+KRLZ4BE.31I<&^DR(/B<H[X4JPMQ/V8&@#6<@W-7McJT]ePgWZg#QVOQ89Y?
;5\^+@UCHef8,L#f52A2],76QP<P_VLZ=;>Mf2WAOc[0#_2)[@0HgDY338Jg5fQC
ZfSGTb&^Z.5E#RS?7fdA3JVGM@D?:?6JJ.d7#e33d=NWQ1WIELdaZN\MB4f;WP;K
7RHLEF95O3a\3QGAV,V#/7BG_XRKB.O@g4=Q.3C)]S=\?#Q)VLZT7YKKeVT\ADRD
??8<9#WH2\TB2EC@8^_=e(ESa4dKcMS4L2?W^R-b.X9ZVSDbNC^eZcDK0/6,T8?;
>Bb?_\bF<L5bX/1S>DICQf;d.()I:-H#dbgaSF]&V&eF;DdW#S:QT^BSG1Y5QaKR
T:dMREb@&P=IXgbO2Y(Waf5DC.SGLZM#;2F[V^S-08R?,\Z8)Z@PcL,:F-Z;)dWD
>S6KCH.eDD4GW:Y..;\dD\1)XC.fJ7AOW,<;<+S01(8(ae3?=:\cG#1c8G.C<,,L
XPYT-H#7HH7eNF)L]U\P4E5+.cN/F12P[SLKI9d6MfQWf?R4ESDU@9GK6ZGUAJ#4
VbWSL69M_E#-D/&F0M@<8^=@MH,I5d7ENEFUC+BW?=RL-ZQdc&N4?)2\:f<EDVC,
R:79+PEDBF7&-_:7?\;KCRPK[fX8];a66/\,7QIPaa\L0JNMRf@+<1aZ/4c8]c>f
<^D)=AVdd(^H15C-0RC\?O@\\CRN9X]8:61[GB)fFgX3d+XeUHI&>79CX,DLK=C;
UOP]+3C84&PdEJeNU^>9dFGZICYT/6JP,)I+F3]-.[dTPROb&6P1>g#PX9MP<=5#
@NYF:)Jf7?4OEE,dae)fgT3Z/g(E,H[Wb[RX.KK-d7U_[),.c#;g81X[EN\>.+3J
GXC(&\EOgWAZ1JFTIF46R).&@45MK<VfI7SK-OH]:W?:M=>(YN)A&BE9<H]g9Ie8
/[[?>L6bQ))]N,0B+b8cVO5@2_+(,-ZD)351;#\770D#K85K^Df0^]A(TROBWa<-
JKeZ8(KF5P?GJ].TdWR/].,H<5K-HaDaa/c1]<-?[3dgUOC[#<A6^GgVf\>NAW/;
&TGaW,(PN4WZ1/C&YB/7_=QQT],3d)S9a)G]2]f\[@P.AE#6D1:2R\H]KgdQIdB\
L4.67#M8QZbJY92/,.>=@I;N=UQ4]U7W=@cQT9cB/6618.4\OTD##3@;>=AN6W.4
BFJbZ-\gJ,KZ->bVWXRV#5[^UbRMHEEW?,TcF^1JOYfLB#eeJc8^EDWDIMQbW,3T
DN5(aWTLS++TDb6(;/S:_>-EFG@LG]5>2HLC^c-X2+GQ/B.TK/f&<:XeOF6ZgUSW
AP/LaaC7T_bZ@Y.cYCFNNQ6:BPe<H<LY<CN,3;>99;G]U<1+GRPJ>?5[OLY>44C+
^JV][X&F1D;S+AC9_:D5^UM^\N;P-VP4[W[a^CB]V15_@1<AgI\aP9b9:Hc>@I+H
Q8)9NIK_/SADVXb4JdX039;dHO2(1&c=PAeMN_fI(PG2/25OF1-#Ab7FDBR\RJ1T
KXB9H:6J-RML#QW8I#8/,K.aH\@GgYN=?3VWJ9YG@f;,,YYLQ,K0[K];A@a:(a>A
U48#@B3C2YS9(TaRFDP<Y/XGaIF9T+O&+\2dN[J+&,GaI,@E9I?\6D<U2_f17U-8
:E=Ka,.)2MfYgKK\SBe:6GHKaO]7;&5GaV=5<.:F:@:cSSB9d96LM4I((S>C@c4;
ff+f+>\.XMARecb\<]CgKSe/M2dgAD/(EV[:IGQA;+_I#IO&P]PC2)Ac3b+cCKE3
HHZda#&0XF6.d^P\OBYTX#EZfE<5V=B(AI+.aeU6R^..,C#0fC_]NaD)(5LM3dbX
[=(]OXfJ<a[cNTO3RFOR[S1fDQ]NYJ#8EW0[fYIG;O>.HM_=XgU9dIZ<&9M.KK2d
L;eNd.a_f^[D,bL])JDI/HPQM2Sd2=YRGVae>5,g9c3Z)6/OWAV<3\+cQ[8;JM5;
(;dEKFKEC-&=7g>S@<F?)+T/K9OIKaB2<=0KDN=O^Z2)Fbe:2+MaS5C-66IR?1Af
MfW.:9X_deW9aVf+U7^\T9dC2Ef8LbTL[2_Hb8L?Pdf;I2[g]O,OQB[aRHC/+&g>
</(/C1=7UHO624^-5^3D&@0Q4Fg&@XCF39Xf9CAN-P)LY_NT1>4Sgafg<bDfRQ/O
fMG?AON[K4AcD7WZb\KMMH?1ebP62MD)\7Yg+,+F.FHR@-X-K;U;SfF,JSfRQJP9
5DE-X=TfScY:_LA1\E.?J4[=b5?Y+MX0\DF>^],/JV<]00^7(N]PBPFFMJ=Zf<PO
@,Z\5E+/NA&2492COZ&42<KLcTE]45L7X#&+JI6RfgY(_.8\0W:cVcMGWTfWZa)M
,6>V-7FTG3I)a.1<g^T>?F7a?6M0c7Zc7@?f;/1E.BX@4,VY]=M8-F[>YU=H4fS7
0[BE;=R6#/aKA_)OIX?X7E(.;a:?L0+bI)8+9,7,0e;DgF+1NFf.VD<9XcUfWTB6
FE0BOX3?a,)B#)5@]S<_++^H^-^)BR]a?9MN2[ESee\Q@@>Fg3O-X:S]AP38X+\X
gIN9QONSSDP:&/(P#^feNPPgD_d^X=(JVJHK2E40GIER[VMJW&V>e3+1a.=??(HW
OEdb^?D?30Z)Af@]Ba=.+.4@<23KH\afNGdO(MM>gcS3O,8:aaA;,-8E:U4)^TeE
;XHK3=a[QcMV&1:W7@8PSK>SDG4gI8:^C?Q&SIIcJVSb&Z(&&T,3Gf[;J-Ca[1C/
B?-^RZ=Z8Ncd[02Sa,;(RGE&]YW(gR_NV6S(RaA2e2?g8@D38D5<e#YS?9D3SSd#
CLHRZ7ZQ.=/BD7>g@C&[GOB^8?DUPWI8_e;cCQe^ZS\/K#^I?OS\+[Qa?dP?4(1g
JdPNF##G;7g8HIgY?B:<4&YJ,bOgWAOf(P73_9(XB:CI^T+Z+0_fJGeJf[UA^2V0
dO5,:A.3&&XfCJ:K;@8B&/+/dFD[.J<CZ])[9:Y6gcJN:GePHLeKKI>3E-dGPdV.
=L#.[YY8[4@egJ<;RAWEP(Mf.ZHabPK[9D2+V?e?4;e7Y]8)1YG=.H5/,bB=+],=
)6U4<7D&M-R,X,2J;611:F-Y0.A63Ed&B#PNQ7]9R^-9#68?5&\EfedQ.3&,bNRO
)-D1Y;+)XE_R_MKe5d+5JR9JZ._4]MVF82ea=BY6M,fcX_R68MK<IMNQ&>;@WB)2
,FL7e2V^Z-ZW+4S]3Ja5d8DGIK[K42#<[ea#L\8]Df^_Gg658\\ZB].B)V9H5&+J
P_UFX88>H;S=9D#M30@\@E=GK+MN])X;&XaX84^<NE^A1X&4P=cI=.ABDVZ]AD1G
ZZAc8g3Ea9,;#DJXP9@1<3;\cGgU7P:M@;TgQ;JL=DY5@+S-J7ge7METD#/]+c()
7Z,@XV1GM#N);ZYT,e:#90fTTRK(H=?EcVK2)U^9e;b#=cI=[O5GY<ZK\81^&e;f
/9db3?(>HG]ZVRdR5>CXVMNB,;g&E@TeM)bSECEC_BeQYJ#_eB0Y7/M8MEbRUOO.
II/FAR4Cf&6Rb5.dE49XK08>[U]RQP,fTdMP1@WN?(?HJ_K#H??MR7.cdS5+gb.]
+-+;)aB-fFT+N140.XR^^3^=-E:DGB4Yd,WN8LA<^(QC/CHML[+3QA;g:AFSLE,M
ef=Yd#^@bJ[@7ORYO[0.9P/4@X[J>eX_;;e9cc@d/KTVQePA]C4OXT&8=1Fe#^cH
E<P#ZS-5Zf03LY;XfXOW6S&5/V8@Z9[aR7cU<_,)4)3M7V<HK?J^CdSXI]MOTdDO
]W^_F1FP08_]PQ4@[D7KaAE[Q\TDAgd&Z\A5P;;B?5(0QK@U)K(MagPg\Qg6TaCZ
&R0X/<?XC:@cCH:32FB@R6>JC_M<N->?8OQR<EY9KbL]44=#T4EAbcVAD:L>J]S+
\Kf.1C8GK3S]]2UU8&[Y,<2Ye9R_dD<.33P,ME_>40=I[b^9-L6)8b75T86-02/V
)7_0LKE0V48_WW+A/?]+>QU[Y[<>/9cRY>[W\E;82,@d.(-a](38d]3e]T[.a?IR
^I[P#(7<_8c5[W+VMeag?UE4V>^&8\?KL3JZFP4P;E+dH#P0]S3Z/=W[[,R;<L;G
2T2c/SL1.GFC:8cPE&CSD(3\)6@_[?F@Wg2ACI(_WbYa)Zec,BYRPecAE0I6=+[0
@>X6]Z(XMW0:cZG2C:;b3MP3)1TT/]&5FF)J1H49JMM5>7:HE11(EL#f_0RfH;@d
7e3.QJ-3G[7=&_6R@WDL&U.G_?e5\F]>@W6YUdE.L5MK_D1#=Zc17RI&TRQ<[Ad4
eCdQXf.)+?+#L/EI0<).WN2;TVXMSg5CZ;c-I;[W^XR.RW9X98YN?(fU=P[OBJ40
76E>4,6,E(<?PFPEGZUTgT;(H:TS-I(8JT@.V63+2C#_E_DHYFQf:L)<Wf3O)M+#
Y7C1((8XGGc8>abA5V:?V7[aH:IQ?b.,<P^Qb&9K4b@M9RL[DA0Hb996?WK1B^FZ
#69_fZ;>TgM;QOM2_TdO_)-OJZ)(N=SC=&3A,B(OW(;)7cW?1A\C0b6T_^D1d#G8
P+]C416)&-g.\DgV(Z=GMJU@^J>IcHPN9K\W@TN<L?JJc((16+14\cF1;RA3)X[8
1BC&+,,Y64VK5P;/9\;g(f7gSI&Ze4:[NEQ/&WZ]GK_MNRT,@J.EH77Y=FJ_AZ?g
OIDLGASLNA:Hc2N60[-M_\;aaY523L,K]Z8]8LZIaNMMU&1@5^UZ-TD,dIfO6.^C
G_d>bB_K9OSAAJWR-c^/MYINN3V-f0g:cLHGF/O.P]g4CPCF:_0P^L;2H#5_<D7_
Sbe/NBNHJ?#R;(Q1N,UIIV^eVfC#&GBb=]1(a;5^0a:g6R:8@:D3acM<FZ3]Y^Tf
XY(289&QcNR#Q_(gEJe-IN56V?;8ZJ;V@D]HNc+I:bTPFT@BF]^EHgKdUf.#aRO7
(Y<U0E2&5:GA11&05KUX==IV>JDW3Z=/\0+K8&/Z4^<?)O6TNfX_J)8e)Vg;6b:Y
;Vg519VgBaXGP5d4\/\>be8V.YQQFeafV-GFFC+=&6+[JRH6JN;E5,E;__/H(^L[
NA333fSe?67C<S&YC.V/FV6]X40)I6c7bKa[^U1^O&;I4=9S<BUZGB>W\<=RAS9d
&0a4b?XQTd&S)IQ@V9;]5_T[MA41P@YZ)f0(ZUMA.M2UWc#J.,^7I]gALBe=NVd.
X2&QT,-+3a^K[Ufb_LS8fDPFNU5WF9f9f[g>]3EA5A.HXVO,B/)?+_C316g1XJW3
D<K@J9_5^NccANWU[/>S\O>H3<F<(gNW5[^KSU@I6C=14gJK:bF9CXd4<2-VJg).
^^f,MeD:Xg9Z/@-3:>2TGKD5O;5IU6d=>c\KUP&7I^fadN9))fT&B^f7D)XV\ZR3
DG>[EbP1<RM[gK>#)D)X1f#K9,6Q[Z&_a9/=;O1[#WGC1QKM_.=<L::4.>A@9eL)
fVPMdcW-8)@8Yf,?/ZF7G^Q<V8M)8eB=PF-LQ+2aXSBDM+5#4?FJ<(Y&K[-@9WbC
&JQAbaX61fVBS8V>N+<<VL>UZTV&8FbWe&U[/6fP-0GQ6\,egg-fS86I#4UP-=AJ
]cY](W+c3QWG>CRaeWV8Y\+bg6>OKHM7c=O3])gc^)3U:_G/Q#I35DJ=Cf0b,X&4
)H#\=@NILN0<P8QDX/46:WP]0E]GKB5dbR(2(DIC/9S9)XAb,V@06@67+N2U+D\Z
GX/SF1+ILQ]DZdMT:faTDCO?,Vdd?a-#g4eA?=>4gW4^Mc_a0MRCW>]a2=OV):>#
GP6^5g@/#b:7M2UdZ<C5Rb,6E19T#3\?f35Ed6;9XY2JNQ;+\T(88e1acAeA49C1
<,a)W5?dR]STW9c=6aYG0?NPZ)E;K8(J.WL1Z:_:TQH?RI)b65^]>G9)1Q1&d,L5
2WA^L5?/Cg2FG&f@)7L7f1)a=14[6>4[_DP)=,6O&:G&cLKKcC>E07H4AU@<.c-/
EI#K-8QE68BdOKH:C+#?c(Oe#U;HT&(_^;F=.#Z1ONXOT5HRO7e:^.[G9G9<?7c-
/D/a7@/<ZP0ALXE-)RHHP.+8.5HW6RT(WP1@W#U64E]eRU:6EJ.1./NNN@L7cS;(
BL1-SU?b>?OaZF=-KIR2T91VJ8_+UN?7,9@c4C@,\=)bafTV[2B1-EA@54BZ.E-J
P1+2b;XMSZB9AN^4HL<UN6W+b0UU(4V>V,U:bL@6]>+[PX-JV\4?0NA,0bK;>5(=
:_>L\A&M3b?C/ADZ_3@A0Q<@7WC9[9MT/-:X+FA@IAZS#/ZT8+aV5QD\>HN3RNZN
7a;^46MJ(NP<>9/\VgG6M:.5+BHJ>V+D[=BT7ZfN?=R;4RM5>Ng5>I2<OcM]bXAX
UC7g4O7LEL.dG0@Y2BYM0Sg<>+gYK[c1F#5#eCM?_R3gc7Y_RQ78WgcC-1E21@.#
^]>3?5Uddg,S);;8V9CLPXB6S7R3]8YWc5CG;@XV]3b>TP(/4eCF-+1KA@GPC_KL
c=dTf)S,\PI]B?3+?F#.9+E:=.&FbSeCW_afLKN2(8aFR@BA\MgT[M_C?A0I0)aF
L9EX])(?U()B24BKg\)_c?TW[^L,6.;SB&5J13EF=44[OR3+E/U849XAB#@O:;L9
[-3=?SNgbQ/+YaWeHGD/B8Q2fF-=2RNAM@SR68-Gf\#]XP\G.+Q)c<bY=3S=M0BN
>_a.T4\2:W0Dd4);&REe8Q&0FO4<-@MgMK#B6X^[+X\d.K/D@5N+>UaB36GMNWZ;
Z6)GeU\9Z=]gN;&ECd.IQ:<VB97TC_R\EY[[=/=M;5^Ig/faIDJe=<;NF>2C4]U6
YaFPPHLKaI8gNcfJ#K0QV]e:7Ic^AW[DU=OMYS&^W@LT;)O=CBTC^MTN_13-(bM0
WWLXYI<b1eN8J4F)S2W@5),TILfBYJZCD/,9Qf-c3G5IR>K+ANgSDZE2N+8PSMX3
CAR;9NPda;MLf=W^QRK[/Ub,V/@=I<ONBHccJg&8fX7V&(:MID;W88.ZGV?a_V)]
X95))6Ye\D@=3c1[:X/RQCNb<0YPAVZT&_+dLTA8b1d<(NURO:ZVDR8eSL<@fNA,
7MY5HB.HG+&1IG5[1,NKP,[Yc;DI.fI)]/R:3I;Za,6GA/d<,P?1)^UYA@,KNM1)
INY0O]JAJE@D08Q<cF1S>.]W@d0;YC.eBGNV\0,8bWHf0aK^MC1M3H@bUd2Id=2.
4-e@SF&SJA0IE<G=U5T._YQ75KaDKB(#KHF6H7YHcb&2WYNUB<VJ9)\9L1#Q5TG[
U\BJ[)[U;33]K/E8L,SAN)@6.?D8#I/1MG>V8>+A))/P3K4\cR<;O(-c,^KFXZU&
FQZeP;G.;-\3G&(dM1W[(@<0.ZCXUZ7KQ>L^4,OE0O:5ZC#D5fgX:B(^c@c@>L\Y
+0&7AT;\HI)c&5@GHN0L#.J9[C8A9VgYDV_GXeKP,N0VB1DeBPS.+NC9bbaIdL4_
,>]GQ[ZaYWU1:JN^TCA)KU^-.YP(N:+IK_@(@M>ZZ#+T4fccdS3_V12FXdFB[Z&9
;>Xa)4(_.?P4\9Z[#)g_b21IXL8b^R-KR9.Y##<[78.PR(.4DF1gYM0T/2(,.aLR
Wb48/P^>>#D(Te1,ZX71VI8g<:5/1&#d]2-3,HG):-&94-,/a@=,0:9HRSZREV4\
F.NF@GC:]HdE^7^:>;RY@T^;caJ#S=K(RR[OeM&;AJ>a-UT\49J?Dde/\e3(J^cQ
1],<.[;3I_ePCL,bEQF>/OL=1416GM&\XXXE:2AXU;62<fO&FA2&4CG::5:9_Yf0
4PZ^S46@K3.aR0Pb[;=-5PM-GeOYP37XfWUN1I&8gbRO5WT]d7D2/O[G2BMP(I=E
8<BLU^:\PI2:>^dT;eVXB8H1GcXMNM&eTPaKAdQ^Bc3_G)7\K-C^F(RKC_1Zf,AK
?T7Fa/KD:LUJOW?)Wd=T@1A_1aTaI_2b=7X:X+QgE75\?0OA9MG1+bZMNIRNO&\7
X[dU;X6WL_SXYR42^MLXG:W;.+UL@+7>,0F3IQWU0BK-YG,,?+8EV[[LgF00]P?7
3GQ;9K>Q@E)]dK[G,V[cHfLg@2=T#6U8_=:1?.:P2g[b,/RIgVZcd9I3F^@SD7Z>
T=DSRF,F1TgA6MD.Q6&K)Y+MP5.B2BD8aQC/^H[8N&5IZ61f#;\8G^H-J9DBI).C
R;31:,XPU?BJ(+Af<6,\aD3bMc(8B@Ka=404cc5FN+)M6UWP:HM[4K0R\J.2(2Vc
,XRYg)MY&9NYIKHebFe<0[#9VQ9D3RF>d0RQMD:YY[,c\QdW[P>20PIZ\Ie/JH1;
cDcXWQOYUOO4AP5U0D,UM+H.5-6,&C^aE<b?S8W24+,CSbVXaB7HE>6JQAed3+2J
ZU0O^XXXL<_KHP^Y&S.)3AD\f[U=;-=])cK9V1e//B^]eHM0>YK5;bO?H9W=IPT/
/]2e57Q-CPVB7A=^E72g#>YLYFH7W65a19I<e/2HB;]07f<UT?_87_Q673@CbCV2
=JI#2Q)@[0#[6LT,83@,:ZP,JWY^)Y1Q17;\NI2:SffKD6YX<]WeDYeQJ]GOFEfa
GPE_3A=4QXP2BC:\Kgc?P5f[IDa#JAY9C47.;XANX_?A>?c:S?RV8;,1adY3+)KZ
0+?KOH7W].Y;31;SBTT:B2>3=gaHZ.^/X_6C3JZV/ZgbIP^NV2g.PJ9-7U-Q&>A;
=8D3\U7:3=Z_0eVTc,E\d1IV#0=FfgFH3g&.EM=4WZ4UdO01]7b)L,IgZ1R?YH+3
9EV>DDdCNF91,,=3/T=;[d1;Wc?Q3Sc-T([B]1I?:O7?D3YFJ:Ufc1C4QO\JNS\]
DXJLPb5G,1V=b(L^5e5K@M,2TbUD.cJJcK28@=.Y,BA_&\b(d+JL-[^Z,5@gR2,8
UfO]6SFCYdW)78[-GRW0aeVbTB?3ST]@<WBbDPIJAT]_;J84S<a>VZI#XMB<V6S<
?.1P4(gUW/1L=(OUFALS&=7AJH1^Y0_Ac3,&b6Y0)+VO(eM&\;eD3dA3.[<;b3_a
CKb#L+4#6TW,P@=?--==_^:A:#fD4/OLB6(;+3DMJbQ]&@cG^O#)4>5eXE[7_:B+
dcGM67K:]F^Y[C1/SDKDCg<EVW-g+9E9fQ1]QB8>ZFFVFEb^>]^Efc.KK:;^K\7N
&1_,&,DU4TW@c5\>FEQb<E&9V1KCa,NaV@<YA0:>c2/G1)9),XA@IfZQUfY+T=^P
PFgd(f7+F68T+>\ZdNU0aRU_U--_>NC6&dC+/E:JMNZc[DT-&SK20A.I#P.<P?a-
JB;0,eDE,ZTTecG#9g^;e@P<CPJ]L[E<LU#eEBGTN:^]f9<<cb&VaCS<b,V<6ICP
+-^D^1KI/96>0K1EZ-NFbDC<B3::_U_J--C<4b<6Ab<DTX6/,(V2\PBfR1/.A&1W
)LGBKDM<7+8c#8M8ZDUZ.,O4Q@1=]=PHRK_V)@3A6S9>cH0cR7Q>5fCG&8(/S;RW
S2<08JNTaT11ZUZfdQ1124:fSO/eW2e30AT#KY2GSS812O&_]\^IW3KM]^9ROY3A
gXd8Ee&ECbDNSC3HV\W53<@WNJI1=((KBMgM/>e?_<#\8;.R?(7F(QY>&8MNZQ5>
\M8&B0GXQ:=Z9dH+K;Ab?g&0P@F\N_+I=GcF3W,P/MS(SWL,?AY?LQ^WIAW+#Ibd
I6EOQ-0?:c_8EcU=UC/[+]/4\\V=D][WXT:Fg:J9J#N6[2PX^0a8E1.NcXS6F#83
aFg#W;NG,4YAgd+Z&L?<>cW;FHCQD]&P8K6NYTE<MCH@>&dP=([C)BL0>A#?PbQR
JD&)?RCN:PII9TI>Q.Lee8V4<L:a9[]JNF7@)ZOe11UJ(C1&1QF+]MabG]&PJBQ2
?Wd&2^a(.V56;C<R6;&JH&11V2G,)[MMN^=XP<IYOfK^D@KZ.(g4dVKAY(FO[T9.
>;ZaLJGSTHQ)BT=VDT5FHW,QK.KP&Cag/N8;#X7K.2c\g3CcZUCWYLd5[E]LYa<Q
gPXCb/5+3M^&N[>6+)L(<a/O[PgM&JY1+0.@,Te5<^:fI,EZ>M@D&^0FDQH14:B6
d@+Cd_1/I>][:?_&[AMMF_:?</.AF5c,^aVNA\WZ84:5:/N7:2P.[Q^3I-[HNQ\#
KR813Yb+1cB(PS^JW\41/.=^MLX@7N.=HJIge=f40?e0UE@ePY<T30QEa;.De,Y+
KI/PGcEWFC]1?,@PC]SZ3SeKc>+R&R9XV<?&9;F::gUW,DZ&86R(6-AGMQ/H:_:>
RAfL(ST4F;58YV,U5f;:bWJ-0RE@#.(gXZg/DOXVGQ_d;LK0EAPM+R+#CK)CH]&d
4S]WZfO2&85f\L(@=>J,[eZ573Q\/7O(&;/]E)-NR>AbX_<?J-X5a+RQ,0_@:.g9
+.[3Q:50?GaUPKb3=U48\(VEEM?ZE76]3L/V)dHRPL;5\GgNBXMc9@3b3.8f#VVD
M841=ND,^eTd,Ub6;N7Y05a9Yf)&M^3Kf[GR^+8HM=5/9fg@Y^[dcb:P1B>>FEX>
.g<Odd@BPEO6?8&;^9gc.5RIe1?A=H;,RKI?2;S[YKPMb48+FA-02VD>0cY-.V37
:CB(J9NV#c@T3/T?I#&]9AcG0-\99?_-Zb>dg;1?AN.>BcE4<.)HV=6E/]+O#gOR
Y5F1ceK6I4[4a570;-B<aFeQ\=4V=E68X>QTW56W]]c]:V1N:PVbQ70M(VI.)YYg
)GX#>DJ#K0)<V:&&B^@)NOT_);:,DOQ)Ab=)Z3TI9\??F0KPF7/.>VXgHBM6S8-T
bgJEg<Z9B&X^J\a6Uf<T49FBRNDU-6:>VO)Fg6G\K]=FJEL)+U9>?2bB0VXMgAZ\
U:;gDDSBd[[?0fUE3TRT/4IO^CLeB@1.f_GP=S1W+Q^K_;=b+f__;:I\)SJMB&)1
0dM9[B=4HaQAHBPdb&O0MUa0N]c1T^0a,Z_c]1;N=K_LH[3TQcaCR[IU6\03#]Z/
=#EVOIAgYK]Q?XcNA_(0_.9OU(PJ/HAX5N,[fI]1I;<cb2G2S>NLM7\:Oc/;=<>R
M?81X,cXRcaNW1D)2:^CKb75,XdFdGNZZ\KGc0fZ/I)AO#EOD1]UITIVKE/5MXU[
AG+c\b3A=;8U]3c(e-&ILP-G;EZK2(gg\XXC\=1_MHO--4W8I1+:BHGZ6+?f-.(E
Z)[GZ[f3L&D-_bEH]6;E861XY:4JO+f_&bbba2=.26QG[QceNLK1VLc,6-QaBQRL
_)5f3^\NO+:;)).TP0[J<E@7b+fcg1^fM2]K3>XVW8M4&[aG<&5_=9Ng<-=\0HX2
?3_IPD-KF9[W9=V11Q+^/<E-&7)]+C_5T@R??UB61=PA(=ge(VgCTcE0(+e7O3JI
TX>cBKF+IZ/=2@AGGN?0+I50/6GU5g2/b5/]RZS29.Ff1\RA2\)d8:N:NX6)2,5g
ZF>P7L1R25XC26LRb6f8.V=I#fGXI88K\CKTY[=U0M51WJFRbJHLZRS)\7ZC=UU)
R?Mg1[&ag3AOB2OHZ51C#D24EY?GP^-800<CF_L@[ROO/M\O]ZR2/Tc+\EN?JRdX
E3H?4AXL\C1M?YFD)N?&M=PG/4(SBX[F#110^If6S0MC//H>);2^bc4HMfAS)WK1
1J]c=#1ZEJX)^)PA(<E^R7N=S9Q;7T3ZNHGb(g9S(4]XaWQ<&.+<,Pa\JT^NbV6=
<0:aZYfFY:V7D[T?8Q6<WPI7ZB</d5QGRc-,,f-c?>73dU7b1V.HNd80J2.H?Ec9
g\_4J_?fYM/LO>98_Y7R<QWF7@9WEZOe_@LfRI8D#40ADUWM4F:?g64G&AT#CA?K
DEAGT6WWY\S62/7PYM+P;QTI6EgfeB;Pf/>+Y6IQ?2I^f[IgUeg--Ze@Q)Qc&&/-
S>NHN_C64.G#EJ(+^J@Ec7^(a)b+Oa0AJV,<gVf2[J)5TOcX81)g)WHZOLgYY@),
5HW6RY3+BF^3(IOe=_NU(f1ZMb8\V+W6H&/&D[50T?J#;6MJLe-:9JJ_HDM=2#N6
G#Q_H._R[:1b:NgIY58Y60,^dP9G0N:P(,OeHQEAVEJPcNXC7H;R5DXa8:g;O=D-
eYE[7HU(.ANUO-1Qdd+g[01)V#LK38fT#:82X?R2M8&+;W+TI:0Z;Z>2.?ME4:Ae
BT&IMO9]b#a];RHKKAe_[^H;Y@I)00]X#8]b.c^_YW3/\VXX5^YS_;T&^cI\B-c[
V2#W[[g2YR:03NPb\NPP.a7-/CJZ1JR1K+8>JIL-4cYL#\\.-F1GM.BDaB/9+:7_
fH2aJM9P/#A+A)H<9-WCX,MEP<e?.KO7\B5:GIZ3+U:MXN3C5ZH^Y6S1OBRAS_HC
TFLAg)dc6b5&M-]<I+AF5,L=#^[d16=-<&37X<Ud(&ZCA(UC3#a.(@_SaV;LQ?QY
H3K<.;5QP-BQIE]QLJTGLgJ9=<R=NHI<NNgM:\M0,e/AC@I@F=:?IZU#FcQa3dR)
JIMN&0a[3<;DSD3BaL\EKIg,5Hd-AX<2[6/^CQIcR05f@Z8Rf.3EN@:4(a(BG./Y
BRW#HP.&E65c:E>-dO^b1?)K8;><G/CN-X8Y\?f#;\45<T,TYd]_T57)#H6O,NRd
/=>=M_5Ud,B_832dAB:COM+4HaV7483A/X,1)6CFYdDf9Gf9#Gf=IMG@Z_QF#\ZU
G)Q8_FQK]c]f\.(B[CDQT7JK#,<RfY@UMQ?;5\SWf^/S(WU&=K6ODMO<TFY7d+F/
P#=2WG]&8Tf8O69.?aL.J6S-P\PUcb#R\6g@)cJ==-?.&PWPQI+0g<O(Rc<BX_J[
@K[:@g5I2UN#S.0]<XH+f1BT1S5WcV9b(73\;TI-XF6XDD8eED&(PB_4A5N->XY,
>5RId1/,_gZfNUbUS6<CYDP1KH-NT>\=-f.gZ9WSJVg0]f:FO+7B-E(J<XYNJCL1
/05S?VFP4,:[cR)CcZ]QaPY9Y)d3gd?RY81+<\7RP;.H#=MJ]KK/;bR0Q]WOT0/P
=F[OIXO?GKYYF>9f#07K:(ZLaQ8ZVeXJ[J?^3:Q@T<WR+>CKJP0/#d21;Rc2#f89
G;[,g37HAe:&+QLZbG@dX@KK:4CHJI.>;3;B0>\RQ92]#;\G@OV0HAU)1c/4[Cad
,S3VLIS2WF+/?QdDZ[,FSeBaWF_Lf@H07b>9L\dUG;\f>&Dc-LgaMO,ZU#8K0FZC
+J2LETQaJQ2(PeMFO0b)<#-]QTBcJ/>J>E=/DVQZ9)OSP\O8dOB_N0D5<(IXMZWQ
;HI/R(V.7O;B4372&O>3[.FeHUG@U.He\A:]:@JMgITUb_:MNH<0&=+fOPa7YLQZ
A<1W,-[D:d6C/f\/L\O/=+RCD-L)W8+:G]E.+LOX.PEgO/OdCACW</@]/>V-MXNX
NC_V6cW(Q4\e1BT6J@Y(U:[:cR;;JC(AQ4KUJBG_^X/Mbc\3->2aQ]076I5ISeG>
fXAOP-c66=9L75>@;c?2f4Q&T4UELa#;@1LXA?.Jd7]?eILPNcF7+0T19bBAGRJY
(T:P)Yg;U])0NVML[c(K0B5<(B9Oa<,eQOVD/U8_:CZBCg1K[(#HSaCEc.=BER60
U-UPeHY/P,+FeJD](a:88JKeS/ECN0GP\/MST>,1&\>UZN0+4UMI#)LTd?,F[D^f
)Jb9:f4C1&SVJIV:.Q[Q:IgW0+&45^<GS&d>(2UV08g8Ga+Ma2^Ecbe[[P\dN)\R
O;Q?[:C:P3+,OdfUM?Jc34UQI+,BUQ-=gc1b)^CA9#2AED6RUJ<gC>ePc9e;T4[.
@IYT4S;IGgOT[1SU?\2aHRJ#YVd)I@]fM2eRd]^@]#cK(5P<\^JeA+/HTITP(1[\
XRC_BCd-bCP9+3V^P:,2PJY_0:\EfX7C?SP04ID59G5-eJYZ7H=?F&GEO&XUJ+-F
PZ_f;^HSCRRf)cR)R33O(f=N=65Y2?g6.<a0.#5HfYg^++RgM#^ee/IF;e\fTSc[
F8.)04V3778[NJ:bS)(AWH7K^:I>Vb:8O2PbNK,GFdAW?dUT.O@#cG+6?,=[;#Q@
aJQVEF9)O;Y95);3@Q0gL6Z^X;WN(fS?1a<X[I5.[ZB/57EXVO<QAYR>5dHOMZa-
U]S?P=2.E4;NdI^#f=9WGQ40X+_Fc^b,5>95F0a,3bNAD\2Xg&f>_9:)9T>QK-;R
8ga7&S4DW/I2+KEegD]1<a:4=3ePUa]>?.^9JcEK+S?69O^6]G>2M.\]^.WPa-KO
.U6PL(34I75aE=&PW?cCTG6OKF3VJ+Y3:Z?P,/:T5M/ABYb,/UB8(?eWI83?,A@F
)^He2]e]+<\JW,F)0DM?_[J5YXH8KK1c;\gA5^^C0M?_cICXHXBYN7\E6#1YL\<E
:Ig5UbL>3Z#1#UYT[DB0_(WcAX)#;.Dd33:NaF=5d(:bB^M&>1&8\a<_dS7]ALR1
-4D@Jd8H==AWY3g=eJ]I7=JV?M#_-SLEGVVLY0LgS7X?EY1T#4WTB6bba4Nf(VIV
d.FJ?(K+a)PS4KM-40L^1dJ]P#,JPeHMe#NFLNP/DVOVF92;VUIY@QX9:+\f<fU2
O&FGLI7f-VOV;[,E:X1)W.R<1PC.M>DT<Z,Z1FVa\PQT#6<I;#;EDN92:>7X.,\4
Z\?2C+gLPP^Rf.,BO)P0E_F?NJS8Ag=AHO7fbc^-C<5HJVVZa9+g+>-Kge^d))Y\
/H:_L?HDD]H]S,fc4DY4[^?;Lf\c?SOCJ.-R5C0UM9=2<0ca#/YL+0T8CO4-0C<5
g_7T-QG\[=R4\5+cT+3NQFC,&]#/3V0J/6OA&13F<f>+3K]]P&^52SV8SdH2<(^Q
;ZN8F;ZH^V:G9KD?FK\R>Sd@2V35)DMX24A7E-/g+Y7\:N-@SbLUI2BR+W7accCN
A\1>eb;\ZcH5HEVU6edac\>P>dTY0WMU.&2Y1QNUF6f>OKcC5;(H/O/..&(#GXWK
ECf&NYcK_([CXW9+_20b\T0K4@R\O[d<3WH?=&>?cDZ:JV6+BM3&N2+g-1aU/dM,
H;HOD;H&0_6:E@K-bH;Q2I>C?^T^+W,bSE2SeI/_6Y3SADK[=>eII(f6>be_fb4E
M.<+]dOY1cY.8[Q<B?YM,>3Q<RH8S.g=B=c2d0g:+L/I,,;/N?/=+MCOd>FOZ&dd
;eGX1)^.\9J07A^(-HdHZO_cZ[]K)WgK?#RRcSKa2V0P0?JM&/0A?[fQVL[0B@]V
(K+S1^e_,HT0G_GO3R^9@@<HAHQ<3J#<90BQ,-F9K+NBK/G3=.\7#MbSYNfGS7FL
-aZ<Y9@e@73(M9c]H<8;O0M?dX+JH)e5EKUE8@FR7+D;PVc=,d21aB0RSb=HODdS
G99/8VYbcV>]2,+--9VfC#/ETV+ege2BY(#HGQJaFc+1+O=4GB40NW9]8A.Z8CXA
V2:-I>V;OK(2G4M49FV8U<--?6BH5gMB?Bg#L&<+J,;0Z-3JH;X)M]=-:3W3F=\Z
;<H:T[)fEgDdA/5D-,]8:A54UU?)VHfeUL1\IWcZge)[A-7SXBM?#3S(&3]6c>LZ
F]@.ge:;#J>]AJZLWKN_W-<gN1:]IIf@g@Ib:+7P2[fb&+LLNa23[;OfB-+SM:HV
QA[EPL+YNV@KOEU+2e@D/eHbJNK1[DF-YD.XY_d_<+B9@f1cUXH;15aT3,)e05SL
O^KLX5K2W(6[L>N=FXR[7bF3c96:YFTX7@&E;8fRW5,2b<004:&AD+&1\]V(A?S8
48\6=./X9Wa]):=ZC9]?g_C,YYg<O)[QE63Z_8QKgdXU-@(R[6M>VRH-e-[fBI>J
Z](IZb.d^4S2KI8bF^L[XF_g==2,@RY>LK7FO,)@[TG24:?CQ&efG<+OB0+NOZU_
_/X.cg;/9#6a>&F[T-#+^V8eT>-AR;TVFN/=H^2VF]^G<ea&RcR2X./;=]PR)SUY
f[eMdOS^H;UP5\LO>G6E-XG[MD1:HMA&f4/+9U#4ICIM^,/cAFg9^7Ced[RE(;G)
Q]CP+g&WVG9YZ@GR)=\=AaT#8\1).A.K5A=Ke+68cF.A,/B(/:gPF[.d@WRSP+[(
U#PUaP,7V#I78R:>C^U:8aYS=8H[2^5W&QN_KR7O9@ENQ--H+-L\6-G1-[(A?M6/
3(O#_BL35eb(Y9d3NF7RPKfaBX26_GQ(_9<E4c+c(CIU8.-PbSV=5),,+Q-<AY=K
\C18PJB?<2FgFfKeTLSgd8-7IWG;:aQd_LBV)5GP_Z(AVd?7NA@WR:>X#VV41H^4
;5,M)=:30C6?LYMS#[4Y\\GgKM=ROF[BZF3;G<^6QG5c8,-A?BMOT[TD##-P)DV]
Y))S^E7,_dFcAC7/X4Kb/H&PG5XZ9Q?^:PVS0RREYU_ETEcZN\PeC)3P,/[;dYQ0
)^J)T6D<N@ITZ9g_:2IAFKdOO+A)3a,(&?GJC=D:TRA,I>^aTD@@.g[-g.8e6NOV
#3;.+PbC#TO<e[V3E=MVb^[L9L54?@T=DQ;,LYa:0;#(g@4DHB,&e.a4X@S1B/gW
4.-L,52HF5+GQA&Z6Nb(V3C/]CZR<K-^/8b#Ve449?HT_5@ENHBcOZ?NZ>W40D:;
BIdJ+\S1P#g>)E+VYUHe-Y:M^;gb9V50f?T^I1[<aX)G=6[UJG\X,IcGLZS)^5B7
8XHPL.+aHPP:AXg41&OVf7AV4HGF@PgUf/5C##?\YXQ=?cXJ4c3B#ZXBQOEA^PB_
(aL?\g>C,EWb4Z6^3;QI8Eb:P1CU?6.C.S\\?^_N@I>^BU8C(=&>I;GYF;^KTWXX
#18K^7+(7gX/OOWLVg=Q;SGe=T1ZbHT&7>P9PNO,.gAOgK[dB545Ge,3[3TEJRC^
f@5.3-BMWe/?U20J>R-E[5:)O9/W[3<3N(c^/^A+5&\YZ-,_0V9b<)7,^M)XP=F:
KT0Ic+5>H_W8O&A[4)6>4>1]:1?e=))T+8V/K-B#4VB-Pb[,\Xc/<OA:E2_YLcF2
dPfHBJ2EdO]&#YOJ7JE=</PYdI?:IW)/2&Ac3:a1b2BC&)DM\0Yca0/K4>IUZ5OL
&fDOMAYN5a35:94?]-,J.,W7;PT5;gKd:dFgMGL^d=.G-gRgCd,Z;[SIa@:Se36d
EJ.M:&d(E6/C\]7O>R\a.):GOA,f_DTNaCA?YTN+C0MP;c3aJbIU)g,>(VFTb1?.
4^]N\GT/cga_=3Z^e6<Yc;X_U/-I?-K::MG.N0CbSP=]57LA^RDZd3;CB&AI\#,)
Pdb;_EYN#+gFP#H413/DCPd)\1g)>Ab,BAYLOXD:YEWU0\BcO;.(79PdbHG7MH]g
0-2:XP24f1:=1#D]TCT_IN&aJ>H^AHLgSdV_PXbPC,CZ@R:]D.d-g-P?8Y?<WaC3
eA^.OSeMaEadWdBg?Y4BX,Y\G<f]5WPLM7>/ATZ5N>4^>>(H,)<FP6f)g?(=MU2K
-A-W_e5Fb3,@-K;I.Q@(#>b<Z,?U4C@f_@.)a[V4[LHI#\Q:<DH]^Q6A4W:^cW\H
1J3(e:&7V1(5<T-^XT#WJ/B_N=0#OTLHC0a_TQ=]XL/Z>,:=RMbM(-gO+gf,3U#?
Fc)#TMMNV&4>&N]E\^B@]c0[7X77R[UBaI&?FT6OH/7,Ycc=SKG:a1=C7,[?YW5W
4F8TRZRJ)45H[0#I9T56--XDW?C;d5T\V>JC)1<Q=e.22cHWK1>eWc0Q]H\V[E@@
UIX6U4;?:2B_Q;YU:a9LM0Q)R5Q:7MeMXQFRKUFZL;Q\80HN-8Jdb):E+-.+fW.T
FUW<b+X2E^P3OX=;Y^e&<P,@O_PEW1=/\.L>b/#61IDK?DBfc^<#C)XK7fSJ96d8
>MYfDc=ISL&:1.-:O&ZT#OOUDJB_&G_F,9S<.Cf0>f4O0c)FQ)[R-K_<cOYBLQ7K
U_>gba#HQcg(#KP6MDG@HF(4E7M[V>?Q\H(gMMJ[ME5EgN&UKZ/:[,RO-M:@b6?<
+[PAY0.\<eIf0XU-3EVENeGZ:c-&R_JNe@W0?FV^0O0:V]7;=:319BQ1V<4^4PbA
HSA)H7f@a]e.V#H1cW6?a.^0K1D_8278-.T)OI3XU#dT#BPZOGcZX)2Wf1C+E9O@
EA1YM-3MdCFQ_W)AU@72+^TULC]Gcb9R)UD)><T1(OK2Vb_1&W)6^VULL4:21eTg
NXZS9?cXFJF0)^@&F1Q2+(H)54=EI_=MZZ#e_)(/FNG(?f=LQSRcFH&^3:;4>8Z&
),[JEHIc_LCO/DaQaZ8VO33#W_gW+>/Q>QMW-Q[&aV7\J.W[f8L_CJ.WBG^X1g&T
5Md/,;,F?VKI_5Q(C=/(b?f(7YGGaH+3;6AZ>5I-QU2]M)R7D9IVS]:)_?e;d>D>
EHL3].:5F:0cLNO+:dF).f(]MY+)a^7_c.Cb:>c(0,REQBL\G,?HY32#>+6QQ#Se
MFHcLM@^1b^a_0[_XY6.B\W5CgU+L7.=)0S8FF>7>Lb?DRTg-3#32]K8=P7RBC=0
)Le-Uf]5g#:4W6efZ0WT7e#>YNX49LWfNf&Db0R9K;2&)JO(#a-O+,#H775]01.W
V_BTA[cZKc9(0Q&7fL=Fe?B@M663Wd(OeCYJ8=,=_Nc^Aa-4D@,FAC7GBP@_bc8^
RZ\H:/?JGe+K=S^NV??^L.-O+ZKe3?#VUcM9-c86G/[9ZS1[Gg>a(DRLS:PAYHK5
X@N0A1D<L:K+(2&&-OU\L57J8D]G@UggM+Pg=^/JeXdTS682=X]J:0;797>FU<F)
.g@,fA:?b7OCB#OAg>,L/Z^59(FXb=(YXeI^D,TT;:>RSL9:HB97^F+JdV9b_ZXO
fZ_0YWLG&caUA&8KEaRI)2;(^WMD:FFfc:dH]WGDWOX_2YE#(c]-::6FYV6O30F=
f-&]W;8g4#.(Z;VIY81aRRUH)8EOd((T[R,cVTHgKA)]7.^7#Y2GC.[FK?G+Od>/
+G<EbIE)W@Vf,02MG6MU@8_WdB9][+(V<^)<]PIXQ?,@2=9>@K;46J3>&8;)+ZKO
+;_=b/)Ab(cRcS99N=BSdH<:K_C[-@2,f(0=;RY.7-PaC9>a,e<Fg<0gV-.b\eW;
KaJ-1K05P451c]UR<FEe/MPKW4?W#6e];]72>I-GF2;+RK7^;TGfOQ42(USBJJLZ
S--A6BYc#G2Hd#PED2[cZ7f0-I7\5-@CeGHM-)+c83bdSdU.C>(=J;+6S=_Uf3@6
/.QbIAEH+O1@9]<N0++U41[bG8+4P<RTJZT3B2^8MK0TL@(Z<_3<M>AGWgT>>ADI
@Fb:6>C5_2X:DBPSO)?]3LN5)_c,cFGf4F_-.9I:NL950#)I7(#dV^@MV]-4(+=M
::A>DU,18<,U>>&9);cA-WV=VL_U\cA=B_X3Q/-#]Lc(37=1#;14a^]J&WN+)Wg1
cBWbRS84<[YN85,-XBAS^[fO]FMUaTTbR;88=c_--FTdNM55LBf48@602-7MK5Ga
,5+Z-fSLB+J5T)E?(E^Og?W:Mg+4KQMU_5Z5;9AT_.I7I<K<#-d+./5&dFGZ._T_
>]-8>M)<;H\J0<N5fI=>AJLg5;eP8G7@3O4H)dIAXB-83ZFP53R>MN#^-N^XC;T<
HEQ>,8X-BGSI<GEfJFDJf-)J8_FXQfXAGcGc8@M^WCCP1EY#S3-Z9[1KZe&8eg>a
DGPAWBgR@B+@E?SG>c0@:ON1K<ccF_R#4.\V_+DJb-PQ6;R.L9H1-[,)MV/5L:W?
XTM,af-Q_<P+@A+[OD?+Q[dRg7_;9UagGS<#7\L9LBJ5;AB;)R/<XH/&/\S2&a((
M-ZV(]QDDIL3>MPD-V,8<:#Y2R9c3IJO=8SOWe58.;c05H]L^\PC?BR_13-H@5/E
VfKX(6V_E87)UdVVGg8c[ScEIMBeN,@Z6Ge(&4\fKCP5XGS3&2@H9=+1/MI1V<4D
J\cBY&==+:&V(2@;N[K#.8K,IQJ]YEQOQ+BSITJOb5LAY]2FKVX4M)\4>G8a9@X>
==RF[OCe2S:Q72@OZQ_e1KX#g-IV\[C]f8+7fU&+LSF^dV-/QN:S=(QLZ[T0:dIH
>f19>PRZ)7aS5K:aHM,)I\,)0HL3ba:TYPYJ?ORXBWIe5/\E@M#CY/@>Y/(PCMDC
fFIWL;fUK;UO=7:YI&&Y:fJ<cQW:^3&+K6T=f17R)]SeY/O.\[I^)SAC8Y1WBbRR
Y9b8DG5_PL.,6aH9M#WDJF9>E7J8EUWTg^/AcE1AB+)P:9)3O5M];N#Z66U+]H[<
e1^FdaFGeIRIg&XCIg7U&0BC#P2e+TSN#)J.4fW:=S,/_@I8)=,UbP#gR712X2Y0
>(/=]5\U[7#^a&,&D[@#+IPAOFdH>?^Z(A0W[g>H\:B#L,JBX.:RA^3fIT:8QM/(
8V<UZ9G8FA;cfK>VCNV;U5<[ANGUg(Na(J)QY[KTHcT^ZF00ML4G7g33BK<)6C=^
7N/W;6AGc8.<@MIa+6-]EJ[TRGU3.@CUa\O4RcL_X^/F/S\:476gZI5.OCX#73&]
HYb2LgBbMI[2d@FVc5Z,^1_A([F6,2Wb\2(XPKLK,S:/_P@Rfd)Z99QH&MW.TOC;
,9A)KMa;,3UY-&LQNFP-6<_f_DJ<=#WDb,Od:Y5//N\db](<+IB87LJV??A,TJe3
>T6f=TVgS&/<NU(YUfF[AScdS0]eAHSgJc0.9bAME3E,VICa.g7J@Sfe<C1[f6bf
[)ANQ7&[g@R?X\Z5HK&,7B<BF(>^8>[gP[UN9=;HE?0/DL#cXUOdK,.@]Q\;K6:Y
.;L+XdBcA^?Y@=7X8(,NT>G2gAe2&?4BQCAE:RI,IQ\RG(Wa6cT61bS0XUOQ[C:9
A/AQ6+HP=XNB/SPUTc,,:49=SC3>+?eC&UTcfE6aF7<NedZ-A&GPUXKBb8_2P@SV
TZ9HA@Z5g]+SD:F,_.LG?a>Y:ZZRfS\8S)9(F/BQ:SQ/&GU1X8YFC-]JBg#g1^LL
eRaF1EbD,Q#b3FCSM6d_;[0cY<AdV<#e/:VX7GE=<W][ge#.#941BJc.8BA+W[HQ
8bf:\AG7@NS_WL/cR[NDP^?PI]&TH78dW[ZM12<2EYK]W:&F/6CSbK.8W9d<47Y3
J-^OY+-CKUPf.X0&+KWAb[8GF/\Z^Nf?/Gc/+6)McgT@QX9<[&gF=4T8MJL#S<-/
S7HOM,,XBW68R.I3J.c0]Y>6APBK?2Dd0,<R]7\D)+>L:&MJF,Dfd+^+PEbdDf.e
MAa9K/@G/DOJD)\C,a0&XgLRa&C[Y(X=[41K?H^#[I0ag8D_XYC>D8=-N<=:.SK?
.VabE4/-^_X1cGg2T>7D4VKPF&bE)7eHB(/1@-)\B6?JG40;KVF[A3(-E1c]^b1_
D@RZYg:N8N?.Kf[H?X?XeH<d(3=GGBNcFH7DWD7fEeP5)BFY^[]4;d0&2_L;cSW<
@QJ2IEV9ML>PSSCU)O[S-F.f<dR@(3SB2D1Aa\Q&H3/D)3Jf0X(a5>2N.fWGI]_P
EWHTU)JP[1,]B0S\aL1B#S;O;;ECNIM),(L4;?#3KZ(]4)>J,4E0]-cR/:^Q)6:L
RT<UFC63DMAAbeJ6)2YDZ3AI<L^\##P5NVf9Y4Md-0INMMTE3Eb9;<LRW-^U9J6,
=9BCA.B):S?Ue4\W>4J:^c^H=TT]&,I;.&/>HQ:C:@PQOW[CYIWS(B\M4bfGMHW#
25ULAQ3HCASJ?FW)22YX8G;.DEYBc+FK\5dFHNJN?87.7=/)6T(d:#ZMW\cC?L-g
:,D2HAY0Z_G;D+#e\<_&2:&^FGK3bJCD69RJ1K;;\ab[0J9cO0P+S-NL[PUH);\0
-.Bc8[Y(Q>AH0RQYTg>OO][4HQde&bO52<f809LIN+0E)/W+.&fGQa4#K/?b&QJL
,(A0E-fB?U#bfEaUQB@IA+@cV[5WBW&=:eR.H)e9J\1>@:a+edJ?8NA(H]-1EF&H
>6TK3):4-cPXY5-7+2&=be?58ZJYbB-2N9N#)fdf1^<I@XbH-BL[I9HT9]Fb5/:e
B>36eE?D<[.I.)e<Ve/8^I/04X=P40,:^E@=F6L@K85DRaXSB/D[.-@=MEGAVFcb
_=S3bfK#51aD?]AY&DZ@/c:[8TM4,c=XV_Td9gVFYgE;O=,Y9OM,F7/c9N=TeI^a
YRFYKF#1WJV.bT999/c4>6CXPAI:5+@T9\N6MfH<Ie\>1G@QZdAJN/7FQAQTK^G8
g51+8AF=_++aa]3[:F3G20=A]E[1KLgN^OKY+SgL:60U2>E#(XD5N-E-0d-4fH(P
4dK>&1g3_IQ]aW.R5=NL.EJ,/3c.dKW=:4?eIaW\]6@gLHI/[#9g6Yb80K6C7P5F
&f&9Lge>55>Q,=c=+,f[adVTV41ED2cePBJI1ZQ.-]cH:55S@?]5E/\_dLOg+,5&
:.>TI2&]V;g[U>F]9aBb2R3CgIbd2/B8,?Q2^\7dAW,0Pf:&#6F.bXaWC0\3^G6<
\NO0UfRfA+9Y)/f-1)0XVJLVdHb_R7ZE7#B3<e[fC90.7##8S@Se6R8<abQO+bOI
f&N1=->)\^,Wf(X5KY##Ad[;D];8NEC4]8GIE#LDFZ39]L(O6_0GW=93G8NSYMd#
AR7=cIU4_K4CKa5C&G[@>NF[Qg)I?/A0)BeY83F/9cdB_(FR)__IHJ>eBQ/?T6?D
WGSJ?R+-Ce<F[_/H.DG^R0>2X(,;S-Vg88^a([]SddRZH_DM<D3dF1\&:_P55:,d
CfVHeV-dJGHM(KU@]65=I3e==)PIKf4+b.g]5(?2UY\?QH:/Q^ESWU[(I,>@1])-
M>K^c5_NE(Sc7gK+#>/gTDY,<DKL-.ZSNV[J:L07Y+<IXGC3K9f2TN<e,WB[@VLL
J?(+#7ffI-aFg](?DBL1AfEB)HV:PJ(:@(2.5J[BFH745\c;M7dWKfC1Vc2O#^O6
[AI20+[e9NK5_O,MKL&CK[O=6=.L6O-9O&?b[G#Q?YLU)eZ[<CZ.J,Q+&>BcRNC0
ENP1IOXGPd.TfXRBMIEM2H-e6N+<WH97#KA^55U,KKEfUGAUI#^(INDSDE-DJCEX
9+Z>W)J#ZZ2:C)]MF2cf^8IE^@_HV1;K6cg_b9J<g./[-C=]+TJW&cNGeSWT+4,]
b6(&3-B,I&=HWZUNPWLRXaO7;H5fa7OTA(b>Z?\_5C0AYe50ce^S<K+&XC\UeI8Z
?75Wf7RZQ^L[@]1DT@EUD=30KCE5NALKXO8@5e&=L+:VE-[9fHE/b@[PG6_a3HB0
f?QQ@N62e(<4G2YHTU\RGb..8U=eE5ffSBA.?+L5GX:MXPEO4I.;V_&0ZSKR>#C+
TScXb)4dI/edR]F/,c,B=5[ZQ::#>96>:AU<SM?Y8gC2fQR4?]bC.MSQPOUXg4DS
a.@GAIZZ5TV-)Xg[-\XCYBg5RdP,SN)Z@?g#[AWF0@2[&(^Y3SC\D;6_44e:a&K5
>3HY=^.4ZF1)8a?\dLB(1b=;cJBFFLUP+_>\3&f5-ITO&ATg=f+OAeU2.eE&).(d
:4L9RUPN)=D>F.4\-OQ7VODGN[K2,PNY.40_9^T@a-&OYbM+K;gJ2R#NUFdgUX3[
SWTQS,e_\GgE?9UZGL(0MB.;G2D1LSLOWb\M>Xf+-fS6[d92:SMDDVgAcHHX/\)g
;/N,/SCNg3Mc9b_-A1S(\LR5&;7&&1-LUP>T2@#R9-;aUHbFJge_6W?ef/?9ZO9O
P-d[Vc;KL3DaJ,DcaC_cf3c(Z56dKCVFC,6J/IKOAUC:0RVKd\7?=g+?K/1;N1EV
ccO?8/ZK.;<.1C@G0e_6=PP88QFB2/=\Q)\30#0LgbGEKJbW]^G=+I>((W9..@e1
NEO,T:>LNSWIe>UXX:bbL0_,d=R2@WN(6>@N/XbJA=dHAQYZEdNeS2AX1_?9]7J9
0FHV;73LAJIM]0BYfJ+OCSUFC;Ad(9)/AX)<S.ESB/ZG,#0QG/EQeCBL6;aWA61V
:;]a//cKKOVNPD;R?IEZW-.56LA/S]eecX7?FH1.[d@95Z)APN&\[7GL>F5[?G=7
gCPd)GKLDFIR@9/Z4JRJN>^.Y<:NX5@7#_A33JdZMTVTT&ZXUQ;KJW_#L&&6QdH8
d5@B_J,@(PP-aS&N^,4N3PDdefR8O,3S,T:DBQ#12>R;.JFQ:G)>X]FN4GF.;\3I
VB,c,DaA/7#V&c;8Y=+X70)X/2S):@QAM=1?SZC>A@T;B91>@:FD>X_V)S>0J_E.
fO+GYdK9P0NgAb&U?\NAQU<OOPU-TYY#GGf,WU6aU+82.\X?GWUcLKL?b<M9fX5W
A_T?X44G9,Zf;86bEMdTZJM_8FCBE\/@HQP_+3:1eW-)E_=7L08bFP(aVcNX\7a;
>1g84(d+EVG_&(\/]P69/<.D9fR2ScfOX/L1L^,Uc6Z&(:[2BX,?6[dbXg9)4.R[
9L0QK[N6QXH4/SWTMa?(.;#FM^#J=@d3/BG(Wf2EW@?&<8ba_AL;SOLP@K4N,8gF
1I(HB9H3UDY_VIE)@P2B-(e4JdM[L.^KfK8b(J:3BMX;ZF780K1UZ(eSXdb8;b#V
1A0+^/gVNX;O#^>a8eYcgS5=))XN>@2RFfNH@f<cc_4M_g^E<5(@8AU@WdE\Q4HO
=E(@&#5Y5/?;;H_aCO4^UW\fZ1#NW9cJ\fVL6+3#[(+cVB9(:77f^bRY_4cO/a?I
I9-E9D^&]2e3O5HNCH>4c;PI)O755U<X;?MYC4/W_UD6d7DOZf\H/S)Z@YG.;CQF
E49[33dM^7?H,;O:&eQPMcYb9IEV4A-W-(R\?]P<FKc_0ae54eK+Ud5WReEQP.^;
VCTXa)-UHWR;e/A^Wg@.Mf#SP/3L2SR.379YXC8M00A8ENTQcD-GgM-]UA/R1E)5
gNIO:NfWf^A2X<.4K1E,UHb(OIb-N[g@/O?2S5VVSVeTRTX_TbJSd8[;=UT,JUA\
JHVU.-0FLPP^4SRS#c<+_4IOVOMI#K/gJI^cIHdM?>/74ge#/c9B&C2EdF+N#<7N
cG1fa4[)+g2+=\c[Of>H-(=CD:/3?&b@^;:RC_;dcQ@I))_,9eK#AXCd-5cJFV[M
L,F#b\,R(X@:N.)2?9Wf9HCNgSU[Z[=0:ZY)b9f-X1[B9,a9:Ya8AX\_4+=O.4g^
Y_D@MK62K.C2:bX84W+BXOdS#6\1/8g]^2,653d<DF]=]]FKV<YI4/HE1J_4?GS_
?JaUNWH3K1KIUf@OC1KA+N,O@gQMZ-1O4TSZI\SG@SLIL3>Y2BP8Z/HJEU?)d43K
KC:3OE\)K[84/7@9[92MbGQ?8<855C#d84US27@?2IM4_\EW_#LBcf0ZJ^JQ7WRP
FX70K,NI67.GV/Z=._IQN_Xb>Db]1dGFGU)W(MgSe#4_R>M5:/,AV=f<P;0T(g#[
W-K+NNV)9Y9@SLd6@.R-J4XS/ZFdU^H>AVY4L)XLG0\2OMbGQQVY6d@HbDC7;BB1
FM^2OEg8#LN>Bg3+ZaC0PLM809#URc8P5bIScg9@-cG>?P\J)/B4-JW\BX2]>:NT
]N.4FOBSHUAdLK1V/d5>\T5NB\Xd)-_#RUU?0g0;,+C1gJ;65TNVc,;)76OeF#f,
(eWVf-0a,gEbB<@^GVV#)5FO-#^T&g7.[WH18J7=/b@ga)0X)gX)G^E&[(-\@^3g
B7b4#_6L_QPHYeMC]&>Jd6bX,>Jbe<[UVH/.E#C^._5)QEA9GXfFd-gPX[dYS/_0
S;)W_S86OT:RfW(fRL5Z].D/R<SPE[3/IU36WD2_OI1MO1\O(3,.HG8Hca5[0=S.
;=GKPM1JaZZV:Z5T7[A@Y\NRY(39M<cD=?1S\>[FaBEd;D:#3f,&&4A94;A9gT@M
@I_Z1:9c1Ef8PA6KddB<G?5NHO/T6L(PIBEId.F\44<F2ATC:&;gP+-_6^5-6:B0
[@_dK&O]N]fCQ9&+]TEUgM/US_:[gTCMU+QR@?c#;VLT\XQ_Q^-+S\NG7bA/<7d@
V=]M3c_O17:O)RCbSQ>:2\I_(=YF&>J)?_Oe62F/2bHLQ\C2X=5cYNb](=JB/?D#
XN\CD;&=>6QXV@3dQ3I0a4L3IY=Q#V4[c1WV/9HH52H7-TQIZXEQfMAN.g6FNX#(
/PXaX7f7a/9\\_E4;02V+,bc3?<\&=F^JA.:)05Z34Y6N5ZVg[Y;E1cb_XbF[S+/
5Y)3;Oge@QDbWOKe9GY._-\UM=ZCfJ=+)U62?L+1@)\ZEbb-G02=^\6,aFZ81.V+
VQ;IXaE?#&8MDW3,C@e=S^?_c+TV<)g9aLL;E;EEK0E\3N3-9F<1-3Dg2#Z8R>a,
?9MOdJXL?H\HWBH8/AM?HHcJ&R8:.N7d9.3HeA6.HKOd&Da\I8K@;=HC<ca?,0/-
G)PWUg7<;f<S8&d>0G,DJ#(L@g>U&df6H_7N&^T=7OB.OG0>-#_O4C:a8S2WdFPa
K4c)3<\d63W?[D2@1BHF0W5<a-&TC6@]3N9&FRSBg8::8Z>.P4<W99>-0TRQYg[@
I-WAF^:LbaXSgf[DGTR>]XD2_&:Q>8[Z=gI@3+FK<Y]T7PV8UX8ZK]&-d\(DFd//
4?)Ngc5^L[82J1^]Q:\R4Wf/N-feS-5OO8X^FO[90T5<+0_P8Ic#.^_0S.HS.V#+
#02BY6?@/63B>c:J^dLEc?T?E3#G@FSZ5S>\>E-DOOK1E4,I]SWBI5X]UK?SKa)V
::f2^dARFYI&71K#3JSX.)]6:8J&,-5d@1We,,J88H9ccNM)1Z.OgEVL;@CA_2K_
SJ947_L0DN3V);:&23AJW:D1g[5e7]g[NB#ZANdCcfKNJ(Kce8^62gS8-_-;?fP@
EMfZ8+4X<[S5>^DVcE-7#(a=(4>[3\UCIfD5H&@KNI0EZIXQ;g6^N-dEEP)CIV-,
Rc;&c03AW/@2=D\#&20_+M;.9(V2_4>BTE&#=D?I?>M_g)A(9Af08L0I<N>-O_1@
@<]J\Y[4^./6;](VL,7fR3BOcdV4T9M.M+eX<CLNJK-JVfS5Re+W@PZa5ZMU_f@=
X=7VD2=RI()Z;>V;1;G]((@T#X/0<JGeX5Xg\YNN6Yc&NH,;E?RC;;Y(V5b;d]]-
Q3;5GV#?H[dWDY.aBV4:dO(d7D>D8M(BcTM+NT/EM.CVcHCN3IU^)[dTX3?bOdX9
:E54.ZE,Y4^eeK=6S@=9:6:>)BQ)J\2+5A8U+3-TH[DfUC-23&Rd(RW>Z/7B;S9Q
HAMX5PJ]H7>9b7DX0^d)>bdgTegfHNNT[PX(Fb><G>Za)3W_4/30DUg>N9^Z9J9\
,L5QH,9:4A3(0;[&AT?VbD,XR,E+]T/:<.f>S]_eF38&@O.Y3\+S;1E-8=U:+Sf_
?JG^-:<RZP3H7+U<Ob;@?cK,B6@ZQ,^9cd8B]9^W<Hc9W2;LT^VC6//gSB,<6KeX
)RP#OS@a-N6BKfMBI;GI[?C[SIRXR0V_b2/ML\K2B[bE<FgbF^05\&I>42/=JT#H
&R09S.X6+124JBYMN?>\A,<MVE.9G-;OSR+cT0YTM#]F<4,0\,9E91PJ(:GNWW2F
^HWDO=VKISWFX/=[Q^_?YeO:4QJ:#6efSg5-J(4eZ3M>JEL_e5IO0f)JRDdYgY4)
gHU4)+6J?OT0#1-<CX)41)\<_2g0Y4BZO[76L7KdV,DZA0NDMW2:7580A\+I63#8
)d>+3;7?V5H8M(.38Ka-L@2\R.:g3SH#-+1+NLaA^\YTNNcIc@4bQOO]N<g3B6=]
FWNJ,?12Q;]HT;H01O.O5gGND9D9E@?+OT(IXMAdA>59Heg\D00KDc_bL?X;)41D
_2Z+UQ+/b/:MQEH/7&b6R>D2VG;ea5,CaDZ/M)DB9KD)f?5:Y#TETU;(2>V[T5T7
EEEBU8X2983YF<_5CA<d?(@]P#5GO1[O:M+a&9f6S8X=Ba/>>K;1R@NF<GK:<JcM
6FF-/>;?O=cG1^BC=V>L[HQdC.BdUP0RF(_e;2357/2>TY(GHBHc8/JV7?2SaK:J
+DK9#e:e.3Wc38+dNOc[4bfL=2&45b^d?)Y(<]OF?g&b6N#fV4=DMATU9CFMFLPI
)2NP958,M@69e2V.SC:.]F3[bC^&IM4f/?_:+ffVA;0#b^Q0aZ)[^]g@NRXLWaf4
KLeINaCCaI@gI1d8f.e)JeFUJJ_5^AaWXY,-Cg1)X+)cR.C3GC-KJN]-LQ+NcKUO
+^];/_OX+?W<Ue5dPF:_K;F;S4_PcEL@<\>I]2(I^70ge6T,g/3G3)LFFB@V=fW:
>YD5#MC=L/adLQENM>43g[Vff^L+@B47FE0PgT=.90FAGKH.^H08.SK7/b3-PDJ<
=#b,^DI/K+0XbGBA)=>.C;448fVLE?;,IUbPY2[N]2/[>If9f7,Nf9>5,TT[5bA6
DEM.BU7;RG&HZ?JZ-)]+[C7W7W\^\_GY,9HY7B9/QYaBKEe,)A3=CP5,NbN@b=;X
\RNVLVV-,#/Z0RJ>SIUGJ\@fTH,00F^)BW@.WTOX)GU?3AgZaKHQDc<FB_P(T2-(
De/X]GF44:WVbZJ>QVD6\aP0D4F<;E6cXF3ZgR&@NB@Fbd[M8)-(R>,7VB#7cbF9
7LFfBN_W,FKL;TL,RbM8aX@T-C8=eYI_:ET]Q#EEX>/A7=fB6[,JITLbL:;6(e-8
#Vd[,]GULXBCDC=^KE,0CKV]0H+Z4#V7?T+.W3bd\34d#\Y4/1FR?=1;(N]Qd+gV
\GC&@8d1>)5CbeI<M-OT(2SA^M1R[Y]8]&R6.Q@X(5#E:W[bTY9K/HB,^g-g>=3F
W5UT3PZI4aP#NFbFOPEAIZ8066XTgEa5\(R4fMY(XF-W_QB6LXK=cYU,Z6)aCaVg
>+.ebg+_IUPY0\2Q+Z]5I,\HC[gIbG.cbgaS(#ZI:KO>=EW##QO.PV^#H:SD/BOd
PZR(T(2S=[3L>^0H9Q\KNE)D2CMJ76V58b(#g3b(BeGf45O]g4cUJQD60f<PcPaa
5^+<3NZXSLI8Ca=G?<;-dfXUO;F&T0K[C^NEe.\#]]+0)@S#0PI=?FFE4IA_,><J
O-<IUd?B)KW6]&)Z,2\T0TD&MYBL#=\H6J(DH4W2:=Z34^L<T.&^P;E+Q/@aCCQN
97J^]03dR(9U@OC1F6/]4SNQ1VQ9>?)G&T#FJ[BS>7[W^1-^&0(?TD_22(ETgBWQ
bLQV<BF/<R9QK<Z7db>-9W@FXBNPS#c,H0VJd)(KA\YG)MVX[b<66]8?f?-2>9.B
R^BfJVH6Ac^L^GdXPQGZZW?ff4^I976Vc#DYQ#a^KHA+/N82NVOIM^&@7GN4SWGZ
:Q+^dd7I@&EPB]Zd2,P8NYQFUFG^Cg-C0Q]Y\D+3>&[/^1A/BMeYE86T-J5Tb#Y&
&(MDcUM77fL,OE,0S@W-cF83)4)>G]A0A66(=^&aIWP&;#LN]dXI,X0AOad=6^&>
F.3(f=JLI/=VQ=)Y\AN7&\-HS([Q-#,^C1C)Y;OgA3M&A$
`endprotected


`ifndef SVT_VMM_TECHNOLOGY
//------------------------------------------------------------------------------
/**
 * NOTE: This method is left unprotected in order to expose the PACKER_MAX_BYTES macro.
 *       This ensures that the proper macro name is identified when the macro has
 *       not been specified in a multi-step compile situation.
 */
function void svt_configuration::check_packer_max_bytes();
  if (`SVT_PACKER_MAX_BYTES < get_packer_max_bytes_required())
    `svt_fatal("check_packer_max_bytes", $sformatf("%0s_PACKER_MAX_BYTES set to %0d, but %0d bytes required by the %0s suite. Unable to continue.",
                                `SVT_DATA_UTIL_ARG_TO_STRING(`SVT_DATA_METHODOLOGY_KEYWORD_UC), `SVT_PACKER_MAX_BYTES, get_packer_max_bytes_required(), get_suite_name()));
  else begin
    `SVT_XVM(pack_bitstream_t) bitstream;
    int bitstream_bytes = $bits(bitstream)/`SVT_DATA_UTIL_BITS_PER_BYTE;
    if (bitstream_bytes != `SVT_PACKER_MAX_BYTES)
      `svt_fatal("check_packer_max_bytes", $sformatf("%0s_PACKER_MAX_BYTES set to %0d but %0s_pack_bitstream_t only contains %0d bytes. This indicates the %0s package was not compiled with the same %0s_PACKER_MAX_BYTES setting as the %0s suite. Unable to continue.",
                                  `SVT_DATA_UTIL_ARG_TO_STRING(`SVT_DATA_METHODOLOGY_KEYWORD_UC), `SVT_PACKER_MAX_BYTES,
                                  `SVT_DATA_UTIL_ARG_TO_STRING(`SVT_DATA_METHODOLOGY_KEYWORD), bitstream_bytes,
                                  `SVT_DATA_UTIL_ARG_TO_STRING(`SVT_DATA_METHODOLOGY_KEYWORD_UC),
                                  `SVT_DATA_UTIL_ARG_TO_STRING(`SVT_DATA_METHODOLOGY_KEYWORD_UC), get_suite_name()));
  end
endfunction
`endif

// =============================================================================

`endif // GUARD_SVT_CONFIGURATION_SV
