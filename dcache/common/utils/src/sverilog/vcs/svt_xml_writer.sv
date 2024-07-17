//=======================================================================
// COPYRIGHT (C) 2012-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_XML_WRITER_SV
`define GUARD_SVT_XML_WRITER_SV

`ifndef SVT_VMM_TECHNOLOGY
typedef class svt_non_abstract_report_object;
`endif

/** @cond SV_ONLY */
// =============================================================================
/**
 * Class which can be used to open and manage the interaction with an XML file
 * for use with the Protocol Analyzer.
 */
class svt_xml_writer;

  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************
  
  typedef enum {
    FSDB = `SVT_WRITER_FORMAT_FSDB,
    FSDB_PERF_ANALYSIS = `SVT_WRITER_FORMAT_FSDB_PERF_ANALYSIS,
    XML  = `SVT_WRITER_FORMAT_XML,
    BOTH = `SVT_WRITER_FORMAT_XML_N_FSDB
  } format_type_enum;

`ifdef SVT_VMM_TECHNOLOGY
  /** Built-in shared log instance that will be used by the XML writer instance. */
  vmm_log log;
`else
  /** Built-in shared reporter instance that will be used by the XML writer instance. */
  `SVT_XVM(report_object) reporter;
`endif

  // ****************************************************************************
  // Protected Data
  // ****************************************************************************

  /** VIP Writer instance to create FSDB or XML */
  protected svt_vip_writer vip_writer;   

  /** Handle to the file that is being written to. */
  protected int file;

  /** Flag to indicate whether we have executed the 'begin' for the xml. */
  protected bit begin_pa_xml_done = 0;

  /** Flag to indicate whether we have executed the 'begin' for the xml. */
  protected bit end_pa_xml_done = 0;

  /** Additional controls that clients can register and access during generation. */
  protected int client_control[string];

  /** Holds the uid for the current object.
   * Added to support backward compatibility.
   */
  string object_uid;

  /**
   * Register active writer when created, the string value is the 
   * component the writer is associated.
   */
  static svt_xml_writer active_writers[string];

  /**
   * Register active configuration, provides a way to cache cfg handles when the request 
   * to save a cfg occurs before the creation of the writer. The writer creation then accesses 
   * this cache to obtain a handle to the cfg and insure it is written into XML/FSDB.
   */
  static `SVT_DATA_TYPE active_cfgs[string];

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_xml_writer class.
   *
   * @param prot_name The protocol associated with the object.  
   * @param inst_name The instance identifier for the object initiating the write.
   * @param version The version for the object, typically the suite version.
   * @param file_ext Optional file extension.  Only required for suites that support
   * PA with multiple sub-protocols.
   * @param suite_name Optional string associated with suite name of the protocol. For
   * suites with multiple sub protocol this value indentifies the suite_name for the
   * protocol. For single suite protocol this field should be empty.
   * For example in case of ddr family of protocol where the protocol name is ddr3_svt
   * the suite_name field value should carry "ddr_svt" and the prot_name filed value
   * should be ddr3_svt.
   * @param format_type Optional file dump format. 'FSDB' (the default) writes out data
   * in FSDB format, 'FSDB_PERF_ANALYSIS' writes out data in FSDB format optimized for
   * Performance Analyzer, 'XML' writes out data in XML format, 'BOTH' writes out data
   * in both XML and FSDB format.
   */
  extern function new(string prot_name, string inst_name, string version = "", string file_ext = "", string suite_name = "", format_type_enum format_type = FSDB);

  // ****************************************************************************
  // Access Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /** Get a handle to the file that is being written to. */
  extern function int get_file();

  // ---------------------------------------------------------------------------
  /**
   * Registers a client control with the XML writer.
   *
   * @param name The control being registered.
   * @param value The value being registered with the control. Must be >= 0.
   */
  extern function void register_client_control(string name, int value);

  // ---------------------------------------------------------------------------
  /**
   * Retrieves a client control value from the XML writer.
   *
   * @param name The control being retrieved.
   * @return The value associated with the control. If control not found, returns -1.
   */
  extern function int get_client_control(string name);

  // ****************************************************************************
  // Protocol Analyzer Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * This method opens the file and writes out the XML header.
   *
   * @param prot_name The protocol associated with the object.
   * @param inst_name The instance identifier for the object initiating the write.
   * @param version The version for the object, typically the suite version.
   *
   * @return Indicates success (1) or failure (0) of the request.
   */
  extern virtual function bit begin_pa_xml(string prot_name, string inst_name, string version = "");

  // ---------------------------------------------------------------------------
  /**
   * This method writes out the XML trailer and closes the file.
   *
   * @return Indicates success (1) or failure (0) of the request.
   */
  extern virtual function bit end_pa_xml();
 
  // ---------------------------------------------------------------------------
  /**
   * This method writes the XML header to the file.
   *
   * @param block_name The name of the block being opened.
   * @param block_text Text to be inserted as part of the block 'open' statement.
   * @param prefix String to be placed at the beginning of the output.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_block_open(string block_name, string block_text = "", string prefix = "");

  // ---------------------------------------------------------------------------
  /**
   * This method writes the XML trailer to the indicated XML file.
   *
   * @param block_name The name of the block being closed.
   * @param prefix String to be placed at the beginning of the output.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_block_close(string block_name, string prefix = "");

  // ---------------------------------------------------------------------------
  /**
   * This method writes the object begin information to the file.
   *
   * @param object_type The object type.
   * @param object_uid The unique indentification value required for relationship handling.
   * @param parent_object_uid The parent unique indentification value required for parent child relation.
   * @param channel The channel of object. 
   * @param start_time The start time of the object.
   * @param end_time The end time of the object. Added to support backward compatibility. 
   * @param status The object status.
   * @param time_unit The time unit used during the simulation.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_object_begin( string object_type, string object_uid, string parent_object_uid, string channel, realtime start_time, realtime end_time, string status, string time_unit = "" );

  // ---------------------------------------------------------------------------
  /**
   * This method writes the object end information to the file.
   *
   * @param object_uid The unique identification value of the object.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_object_close(string object_uid);

  // ---------------------------------------------------------------------------
  /**
   * This method writes child references to the file.
   *
   * @param object_uid The current object uid.
   * @param child_object_uid Child object uid.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_child_reference(string object_uid, string child_object_uid);

  // ---------------------------------------------------------------------------
  /**
   * This method writes a one field record out to the indicated XML file.
   *
   * @param record_name The name given to the record.
   * @param field_name The name of the one field in the record.
   * @param field_value The value of the one field of the record.
   * @param prefix String to be placed at the beginning of the output.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_one_field_record(string record_name, string field_name, string field_value, string prefix);

  // ---------------------------------------------------------------------------
  /**
   * This method calls the 'svt_vip_writer' API to add the interface path into FSDB.
   *
   * @param if_paths String array contains all the interface path.
   *
   */
  extern function void add_if_paths(string if_paths[]);

  // ---------------------------------------------------------------------------
  /**
   * This method writes a name/value pair to the indicated XML file.
   * This method is added to set the filed name and field value to the
   * current object to be written to XML. This method is used only for backward
   * compatibility where some clients directly called the field value writing.
   * This methods needs to be removed once all the clients moved to new writer methods.
   *
   * @param name Name to be saved for the property.
   * @param value Value to be saved for the property.
   * @param prefix String to be placed at the beginning of the output.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_name_value(string name, string value, string prefix = "");

  // ---------------------------------------------------------------------------
  /**
   * This method writes field name/value pair to XML/FSDB, the value will always be in bit vector
   * converted to right data type and written out to XML/FSDB accordingly.
   *
   * @param object_uid The unique identification of the object.
   * @param name The name of the field to be written out.
   * @param value The value to be written out.
   * @param expected_value The expected value of the field
   * @param typ The data type of the field value
   * @param is_expected The bit indicates expected value is present or not
   * @param bit_width Width of the field, in bits. Only applicable to fields with
   *        typ svt_pattern_data::BITVEC. 0 indicates "not set".
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_field_name_value(string object_uid, string name, bit [1023:0] value, bit [1023:0] expected_value, input svt_pattern_data::type_enum typ, bit is_expected=0, int unsigned bit_width = 0);

  // ---------------------------------------------------------------------------
  /**
   * This method writes field name and an a string representation of associated value to the indicated XML/FSDB file.
   *
   * @param object_uid Unique id of the object for which the name value to be written.
   * @param name Name of the filed.
   * @param arr_val The filed value.
   * @param arr_exp_val The expected value of the field.
   * @param is_expected The bit indicates expected value present or not.
   * @param prefix The prefix to be written in the begining
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_field_name_string_value(string object_uid, string name, string arr_val, string arr_exp_val, bit is_expected=0, string prefix);

  // --------------------------------------------------------------------------------
  /**
   * This method is added to retrieve the uid from the PA XML header string.
   * This should be used only for backward compatibility and not to be used by any 
   * new VIPs adding PA support or any update made by the existing VIPs.
   *
   * @param object_block_desc PA XML header block.
   *
   * @return The string which is unique ID of the object.
   */  
  extern local function string get_uid_from_object_block_desc(string object_block_desc);

  // ---------------------------------------------------------------------------
  /**
   * This method writes object begin block to XML file.
   * This method is added only to support backward compatibility for existing
   * VIPs, shouldn't be used by any new VIPs tor existing VIPs updatingPA XML support.
   *
   * @param object_uid Unique id of the object for which the name value to be written.
   * @param object_block_desc String holds the PA object begin XML data.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_object_begin_block(string object_uid, string object_block_desc);

  // ---------------------------------------------------------------------------
  /**
   * This method writes a comment to the indicated XML file.
   * This method is deprecated shouldn't be used in new implementation.
   * Added to support backward compatibiltiy.
   *
   * @param comment Comment to be saved to the file.
   * @param prefix String to be placed at the beginning of the output.
   *
   * @return Indicates success (1) or failure (0) of the write.
   */
  extern virtual function bit write_pa_comment(string comment, string prefix = "");

  // ---------------------------------------------------------------------------
  /**
   * Utility function for getting the #begin_pa_xml_done value.
   *
   * @return Indicates current #begin_pa_xml_done value.
   */
  extern function bit get_begin_pa_xml_done();

  // ---------------------------------------------------------------------------
  /**
   * Utility function for getting the #end_pa_xml_done value.
   *
   * @return Indicates current #end_pa_xml_done value.
   */
  extern function bit get_end_pa_xml_done();

  // ----------------------------------------------------------------------------
  /**
   * This is a wrapper API provided for clients to capture the predecessor object 
   * information inside XML/FSDB.
   *
   * This method calls the 'svt_vip_writer' method to write out the predecessor data 
   * to indicated XML/FSDB. 
   *
   * @param object_uid
   *          The uid of the object whose predecessor object is to be specified.
   * @param predecessor_object_uid
   *          The uid of the predecessor object.
   * @param predecessor_writer
   *          The "svt_xml_writer" instance with which the predecessor object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_predecessor( string object_uid,
                                                      string predecessor_object_uid, 
                                                      svt_xml_writer predecessor_writer = null );


  // ----------------------------------------------------------------------------
  /** 
   * This is a wrapper API provided for clients to capture the successor object 
   * information inside XML/FSDB.
   *
   * This method calls the 'svt_vip_writer' method to write out the successor data 
   * to indicated XML/FSDB. 
   *
   * @param object_uid
   *          The uid of the object to which a successor object is to be added.
   * @param successor_object_uid
   *          The uid of the successor object.
   * @param successor_writer
   *          The "svt_xml_writer" writer with which the successor object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit add_object_successor( string object_uid,
                                                    string successor_object_uid,
                                                    svt_xml_writer successor_writer = null );

  // ----------------------------------------------------------------------------
  /** 
   * This is a wrapper API provided for clients to capture the set of successor object's
   * information inside XML/FSDB.
   *
   * This method calls the 'svt_vip_writer' method to write out the set of successor data 
   * to indicated XML/FSDB.
   * @param object_uid
   *          The uid of the object to which a successor objects are to be added.
   * @param successor_object_uids
   *          The uids of the successor objects.
   * @param successor_writer
   *          The "svt_xml_writer" writer with which the successor object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit add_object_successors( string object_uid,
                                                     string successor_object_uids[], 
                                                     svt_xml_writer successor_writer = null );

 // ----------------------------------------------------------------------------
  /**
   * This is a wrapper API provided for clients to capture the custom object 
   * relation inside FSDB.
   *
   * This method calls the 'svt_vip_writer' method to write out the identical relation 
   * into indicated FSDB. 
   *
   * @param source_object_uid
   *          The uid of the object whose custom relation object is to be specified.
   * @param target_object_uid
   *          The uid of the custom relation object.
   * @param relation_type
   *          The custom relation type which needs to associated, eg: if the two transactions
   *          are identical then the relation type value should 'identical'.
   * @param target_writer
   *          The "svt_xml_writer" instance with which the identical object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_custom_relation( string source_object_uid,
                                                      string target_object_uid,
                                                      string relation_type, 
                                                      svt_xml_writer target_writer = null );

// ----------------------------------------------------------------------------
  /**
   * This is a wrapper API provided for clients to capture the custom object 
   * relation inside FSDB.
   *
   * This method calls the 'svt_vip_writer' method to write out the identical relation 
   * into indicated FSDB. 
   *
   * @param source_object_uid
   *          The uid of the object whose custom relation object is to be specified.
   * @param target_object_uids
   *          Set of uids of the custom relation objects.
   * @param relation_type
   *          The custom relation type which needs to associated, eg: if the two transactions
   *          are identical then the relation type value should 'identical'.
   * @param target_writer
   *          The "svt_xml_writer" instance with which the identical object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_custom_relations( string source_object_uid,
                                                       string target_object_uids[],
                                                       string relation_type, 
                                                       svt_xml_writer target_writer = null );


  // ----------------------------------------------------------------------------
  /** 
   * Retrive 'writer' instance for the given full hierarchical name. If the writer not found for
   * given full hierarchical name try if any 'writer' associated for 'parent hierarchical name', 
   * if found retrive writer and register 'parent' writer to given full hierarchical name 
   * to enahance performance for subsequent retrivals.
   *
   * @param inst_name
   *          The full hierarchical name for the required 'writer'.
   * @return The associated writer, if writer not found returns null.
   */
  extern function svt_xml_writer get_active_writer( string inst_name );

  // ----------------------------------------------------------------------------
  /**
   * Method used to get the format type of the writer.
   *
   * @return The format type associated with the writer.
   */ 
  extern function format_type_enum get_format_type();
  
  // ----------------------------------------------------------------------------
  /**
   * Utility function used to add a scope attribute.
   * 
   * @param attr_name The name of the attribute to be added.
   * @param attr_value The value associated with the attribute
   * @param scope_name The name of the stream for which the attribute needs to be added.
   *                    If the stream name is empty then the scope attribute will be added to the 
   *                    'parent' scope. The defalut stream name will be empty.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern function bit add_scope_attribute(string attr_name, string attr_value, string scope_name = "");

  // ----------------------------------------------------------------------------
  /**
   * Utility function used to add a stream attribute.
   * 
   * @param attr_name The name of the attribute to be added.
   * @param attr_value The value associated with the attribute
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern function bit add_stream_attribute(string attr_name, string attr_value);

endclass
/** @endcond */

// =============================================================================

`protected
NH>L(7QGLZN11@31,aRV[=/GRO6T1^KI_YVbOK^I#b.UYCM1#He[,)Q1ATJZ7B_#
KB(9&S&Qc#9[4]4[G\,7<VVae;GX;J]cW>cegJW;4^cWR4\T<J2C(#X/IVE&d-8A
0=^.=dD5aP5^&&KFTD(gS^&#8PbAW>45c8UXgdf+8V8K<Sg,Qae;IG9LP:\SPY@^
F9EDUE;TJVV&&S=PX_SV0<X4G^ZV=X<[DeSgHE7M+K_VJd12cPM,.MFP/I#EgMEB
aa@Vb/EDP@8\MZB51f7W0H2](6?FSRaW0X+9LAL6T-=6MMa4QKe[+Ve.Y8b_4<3-
>af><F3Rc<G+Xg5I:?56^7Q?_W^AIaI,25g^9MRU[M=3dg-DWKE[0MKJ,+LTXT1Y
2-B\DDGabg@VC7ZXB36NPXTD#I4cTQ3=@eHQW#5e^0IST?UG03L(IR^TY31PBY?I
BVRg),P5X5M7\B6=eM6dEZXL]ZL-fT]MEUU\=<GN;(BQ/0;)3P\O]>1HF\Pb,CET
Y4QVA&_fG19J4&W3Gdbg36+g0Ee21f:&a__V+>P-WHNgKT(ce#^<b]DMY&3,QS2L
Y01]Ka+,FYEGCdH>6#5_8f&+efU(+,6P)^49[^+/QWYdZfB2(6dG.IOQKfA41PcH
d1f>cRRQ?4&:?=M(<VZR#bOR&QK\gSFP0=K>X.QPK?S8^@]&A61X0^7C(/TIL?11
M5QIL3<cZ28=PaBIC]J]OC\IO7+,F./[QYI7\&^ee0abQcBH?N2TDPK_+eReOJ=0
/C\4[5:[CVJ,SD=)V>.>5#]/;IcN8Mc=#PNCPKX4^3Y#6_QS>aE-_NJWBEe/J85H
SY9M/.\(DQe1HNC5=VbV42E3<AKI\0D?V_]1B)I6SE08bfZYU2gcH^LcR91S=,FU
c,0J[<L-A)08Sg@3+7F;,P&=<0\Ka0NI-?I6?1?W,1FJ;0=UJBQbVD8\[2Gac)O5
8G&O6@R_UWgQD6&]CZG4d&BM<_L9gXM(]LNI[)#(^3TE3E)/VOL?TLL5+<\NG]eC
+FGNZV2F@RR-^P7BQHDfZ7[7e\a@&@RD>D/Xg^(<M7&f;B1M@3be2&(+FL+4&RVN
],=9EZ,G?E/.WgP)8I5R,6PGKC+7JdWM<#/KD^64ObY7FMB;24L?1M\\d-CZ^T1S
3&WCO7Y[IGa6TPP&SVRb^61&I?I+\CHYC1.W:)=VWT68FI;PX[W:\8:WR\bCS.FN
Y:/GWI?52QHb9MOWWPB3C7?N)YRSZ//C@g/DX37>NMY10g^D82:eX1_HDG5)U]E]
[>JL#(N_C@P/DVS;/Q750RaEa=>^^F]bPB9P[/fJCXTF#[1fW=2Y0PYW3gLUAU)/
9IK9_Q7J1eXU1F;<BX]:.9JVN6)gBAUbKY&K<_/R+U^)[YZUL1]W5GFIKAAKCJ87
U@:S_;^+W-_D2gaFM7K:/(5_FANXDL3RcMO63,=J(EQ(Za^Q?OA3DP157_IED(F#
,&3MV1KV-?C=?8QU)_COJ;\W=.+-]Sa.IOW5Nf9gF/<_D9B@;bE/3,RZKN;GS\+c
N-[[N<V74&Q.-b-7U)[??H,?\b_C+(.0NF]12d.-<HE)Q@2Rc]If7S7De5#HG5.L
L5-T5LP]V>EV8RB1>TYK(KV22<D4f/>63/3@V;;_bMZ&G>F:fDAT:9:ET^B;H)8&
N#-TQ#]@@S;HPR=170AcND(A.I41945F?5\P#R=a8dB5&VadNL&XPe4+KP1c\Cgb
Q4D\7C12CXFW>\1EfHCa-_+U0K]9-B&^;eN_V>;(I\_X2EJ#=R8_?M:/VL66T(a;
3S/H]ULB;ZXa]9GIJOSD&Gf64&)BG1P@3M>V?2f1,N0\^SL/.]+J0.6?(a4AT.8&
K20[(EC[[PATHIOK352\K\6[TX1P7R.K[6.E,.&>K_a70+XNX4g&6#263S6K:(8]
&:gEMS]0affE@#N7ABW]A4^6@c\CRHa6J3LWK<@.,=^=B,5\c_Y3F@09b#@>2#/T
^4S:,6]d\4GV4D:>V6)C&6EQeGSOK75_9<1aSA<<1FILfZXb]P^JF3]/WCbZ[1Od
E;J/(4R?^P4TMJJ?4fS[UXEVP3W@g6Q9XBP@<O=^JgNZg:K_5Z^E.PV>1d^PSLd.
F<)DRdT1N/-^.#gX7gB@0dYOQ6?2+L_0=PAMWD4Ha;FF^8G2;-_Zd7O(/3I&E=,M
+=J))L1UV3#&SR1L[QMXM6+,HTK]dDG,=^d0)QF]b<-+A5LU&c2?a=<e>@d&;ZY;
6/7I,Hc#(H)PXSD4=@H:Z)0ZC4G6X6G5+F5X?W]2ad9245;[d=&Q@X:/N15+RLb_
I^0UY0C<Xf?JXZ#)W@&NTd+S.NDQ0TRXMY9e6b1W)a<6KH.FQS7&G:#;0Q&W/YdE
3;\1NOdWM=^5dUILR)b&641V+6R3T(YLS1TKRZcfV<0;]D6<FA@VM>(aFfZ@ZH,\
1\FWKU>,fY2J:BPF+3DJHfDg@.>VB79[\WaJZ1AKO[dZZ:C.;c#1_dE>\WP,OK0V
Q>4H8VDI0f3_YGbGP1,,,CT74a/^g).H2A8:0@^B_,DR?&L^D^UTYOAf@+YAF<AP
ITdXQdYaFUT7/?I2#6A0Pf>C#Jd\X8aSDE8^#YcfeQAa.3GcUY5d2;:QX0&OgK;A
?+d:BQ_+HV[0ZJ_OEJd_SaU:eLE:,&Y]fd?/[E8^TLB-6<NUD&6<8a.5EQ_U;8Wf
JJ6D]/R@Y8?)+gH5,2QIDS]F<X_dV;a8;R;IVVDIJa?LeQPagd[OfO<DEWD<2bfR
LVF4X>599(Rg26(5,?9IOF.4,B4OA>BRIO(02OOQ#I6P2C,I)A18O.Y>U&J>Md_\
3LcCN4Y1C3NWJfTHZR]5&>.@[\PJf9c-CMK_AUJYcI(+_O-2A0T/7+Y:[?1VR[X=
?9GF,WcK;?&^S=QKc81UGUS<D,E6.YAU8J>ZWOD]D<?681(/Y5JM-_PR^2GP3Zd8
GQ_#^:/-3JXLMeT;:D]T4HF/Wg8DPV+TN-e.U@HdH(-g;W4OF;N9+K61,.GLgVVL
..5[M5C.fa#9\bS5cRONE&E:NfKNODdKNE^@b:HEV:ZS:<#18-f>cYOVXI:7VB0P
,>:6W6^[2HM33A#MeK.W7.bPQb<;0Q(Y+O:VU::ROgb@#+GEG3W=cg?ecGRUH8=X
MG<<T_7JHOffg24Y1GWGO^(7=^aR84K+e/\PF3BI;L,Pa):.Gf=5^VOCZ@J\<IdV
QeH9,NCVUU#bRRY2^UDV&X9(7:VC@3DADX1)=gGc+La[TP]6C6G(<JAg+9\?ea9F
(=BV)O[O@)H\EKL6](/3WHB=1[WQ;,8/>e?@T=]>?O)NM6(@-X#V.R2#0WKCU)8#
VH(g;c_:Q\\(=^BScG6?Ea(eO;TBRXI>&gXOO0.Tfb=f/PLN\cNM33T@>36FDO>^
cBNacLdcP>_K<K0>QVFN0cJYe.GeaP(M?RG=CS5+g9J;.KCPR8]VBS_53fbNVUEa
_SS(@e-.X[<bg-[3)=dAPNf&X?PAA<I+85b(OV4V]F6d05Yd0&OSA<S:2ZRTV&bH
10;9D#aJG9.Q.\fZQYC&9,RX/#(J/^>RKG4C?63eE#14g:7WZ77(0H0LX6<SW_8#
A@dgV4dP9=-<PZ/0L)N_6P:_b5Y.g&f[)b8DBS@#<37:c;HFNOK+:>.,(6Oa4CII
5Xf<A8fDcO4BXGWS]KfK(9?XbYdgW^a7Kf83+F&#HF??&&^)M?K@1G&&LJBcD2ML
3/gA(/PSgQdZ_X<>0S[2^H;3BNIDMCVTeYW;@:M;1[6.d,2_H>2->HZ4?XMR;8R,
45YS9GN#1+K1#+N[XR@U-ZF9N2YJXG^M4EV2C5]S:QB,CBb;T\7cCY[Kd?-F<=K\
-)<M:M2N2C82R3c0/Y;E^OF7WR;geg)#^f#;+EF<5bc=Q\J3OW;[UQ5@A2&f:E]X
G+.QX^RV<Ed^dM9:/5-9@#f^<XUA2\Xb9Y/5E^V9\@eYEe+/JE)PbTRAQ[Ef4NY<
M^6^<6F<(MFTD^a[c\J0b]fEIM6]F1KW;N@?,K:[K>S?HY\R3<M8)9VVGH]?E=a4
B//^:=3OLH=RV;O[HEGdaE_6Lg_<@UB2HOd@00#VBc6L>2ECDXZ1]/_fO-3ZSCc,
R.affSG6Q0GOg)6QA/ga8[E3E37RY@D/8:7F=+5R8KB15G\G(K1/H:g(?Y4\e[2<
+_Ueb&]20UEcb^O#8,M<ZC)FcCS;fcFTTA,EO>1NC#Y7L:a608&cd1fH.Ba8P\?C
E?>dS<H0L^29Z,:I2&,:JTZf@O.@FAFN8<HBZccG#C/AK/&([I&Yf42/[7Ec/DJT
U4,6N;54acGMF?_/-29ZGA\TgYXIVG@518Lc^D7A7W-5QE^_bHcM97gZU0e80.3/
]YI?JF=_^F?b[16&]:?_B8#Bc]f#/NgS&H4YSL\@\PO_OT^0D+6#_Gd67Q\3L<I/
.XI<::H:&HLX0+GP>))U1]aZ#2ONOb/(2DLa;O)/K=QDX:JU&7J)?Ge_PXE;QMNA
;C9NfBA@I1@CF#AQBREc99@>4<af]=2-fX[YcI?F9US#U>+DJ,C,ZCHVcSF=SS=^
6+Ad5PAf8fLZ?]Pg6G=,(<E?49,_TYd5.M><X>@\V[Xe7SV-U+a5IGIOVd>&c/9O
9.],;R5\LWYZ+4H\M@]2>12DUZU4Nd]S4D3/bLb(CfSR=\&9=QG-KP3(1);WF5/5
5<+.)G<a&?1J[O<YDT,7F]R=-?/L525OSaE?.(Z04He?&)T:Y-f;2J(bAPZU[J#)
_3P8#Z3<FDEg#MBHWJ:-)J&f?QQK@DX)G5Db\[fV?3gX:e12V=8)V[Z<#&9;\?Ia
QJb2G65ZSeW?^_;LcNe[8JM-GT>I:QP,-MP9)e2U3HReOf0->A>#ag=]ecgR&HG0
TD^+?4dPPdR/BI-Q9Y=aa10c.&D^<M=L##]S-2bfB/b?4<XTKOL_g&4<\I<VW=.c
@)8(==Sa^K?8SJbU_ZWWMH?6OJ@R=69(^7C#egZ&OQf;R&-Y^gb1&L-8AdL_QDQ7
-V8R<JPCF4T0_XL7S+IVO_>Bb2(^QgCPHdc2P;(HC_)7PWQg-3@:ICZB/VLO957<
>3fRMP?LO2S4R4=acMM6Fa1CYR3.6XDX@FIP9_T.fa5a?AJ>Q1;dSSF\E_g6fKc[
2SC?#YN=,4#fUGe0[:a&)Z=>9f4OQVER\bWd-g7Q2_d#@WSa&9_A@^e[?c/2-ITC
?EBaINEMSQ)>\LGTQ/7cT/^[FDW37P7ZJ,G13e=FTDbSW]f6>YNX6dDcOc>O]S1P
.FJTGb<SG&fB3C(R9^=IMAHKf2U2^>5)CV9?g69#+DPYL][0:0Z>_^<I6gB2)X5)
PdIXYa-A.bM:&D-V==I,=@2+N7g<R9JR,J(T:WA./eC@L&BRWTVKV,;/6JBV[EdR
Rd1WGE(0cU;4X^0R#Xb\72@aD-[N5f[gb3MRO/N[[/OD,7@Ue.D4\/K)Z4\0bKX<
;S_.LROTQV;\3dRS4bf3?cJ<e&YPH5-4&SC;77)SA98fca=44Pg,@de>dBG0>\&>
MFMd-/9,cH(L:bDO8OI;OI=9;N[D:=gT2L6_dREN&&,9-8:7K]-f,-D\g/-63IgQ
BC__B;>IcQ,3Q4db&=+c3H6\;E5+GfLEfSeB2Ie\:T#-9<Y,:NDPVB;IP.gPR60P
a]2;U^Cc:M:@Fa&c5ON<C4OWU#E(W:d9bYV?;bOFEVQMM8.^T7,TORgP6SD1V/V.
/TJ>d-P=#&0(<6F&90#UHX,P6EgA?[GZE(W8P8I9&8(d;dbX+/(8OTeBP.L[M93M
^Ca6<&;S<WCYSYK_KL,JM8PP&aS9&PC@YF:d:<X2]IgQ]S;/DL^6dTEUO<X_H;Zd
8]Gee(e+e7#N&,AL9c]9KfB^:K6]_)JDU/)YW@+gG]b=ZNE_96K0d\_Ff]3:ddT3
R;+D>R2QI2Z?Se5UI71246\6\&,#Dd/a@FN#GKBUKa=1[-G4NYJXZ=J6,#0)^[Ea
,^X1K<LQ,)]AX_)fKL/=M==IP[IVQI9QBE.BG/#[cU;+VI17?)MW2g+@5BFAXZRE
WFXad[_;e(J#8TcFFCFbLPO.,RN,5:4C@R\@E=M8N@&UQD@M+O&<N(Jg;^Qe_W1K
B74^>)_Jb1@e6d&3KIIMVS)>,\TY^CX3[R4Y7N[(LXHG5@OFgG\f[bTD@&eFGUDW
AY52I#A)Q2XAUa7T+5:=O)..d7@,3PIV>65Q)AWF=39g-:5U>cBEXL8D>5XO(\^/
/8O9\S=40_FTb9MEF;QICO7J.+e@XHb_]@)LEdWdLG8Y2@W,95dfFg=&gUB#@EC2
2U5O8(b6&]5AEMb[-7a.#HPYN4SMJ<fI,VDg^Cg]KN2G>eX^PD[EN8#YgA/L3((f
#[Y0ZbC_(YJ6UO\UHB)JX7dS/Cf&+0B9+J>Ye3d:3G17LT+O\QVY\d6]bD02]a]J
NfO^[7[9@0[W]JHf/^<Ta@0[?UE/<XbEL682LN;M6<M_@,L=)PR\]OLF+8@K<G.)
I<M++6&H?E-3deS,D(EE<JG5P3^#Y\<++:2U4FPDGC<:<,e_W[7&P+Of)OS=\0cc
_[6BIC<YWKQ;b&[L(S.KH;\b3#C^F>aa56H7RLG-cJ/MfE:B^3LHGJEK8BSR3;b<
734>2U;^I3Ubd4KK-4BgH1C:+@7Y1@22Z.1CRDQHNHd+b[TRG@-W,UDW^:G7Pd_B
&?ZR&dQUZ=EO2cF70F(/#PXC4K7SC&[dJ-8_.Y&_\23aU>.KGaX@g63_T5H#8R6Y
PcK;Q7]TYY]_:^\OMD5AG3>\B.K&3dBMZ?X]<6(Bf:H@U@7B[aV\0f1BLMO,,7(7
2IC9a_I&IHNg5?J\+)d\dV)(Yba87W,\/NG<]&J9Z^YVb8K0a)bYCF>d0(<VYZG\
+49RM/R^/FPC8Je9Y+,-T^c6@KQ2aJGGI8=.89&/<TG-G[-RcOBJ>_VL.7>eH)_&
S5:a-:^.>0?DJ0OO<Q7J50\b,AD.e33];0CFgEVCg_[Q&aAB(=a_^D]dGf[,W+\<
^4a=e7A/X_DNI)T8HAS)+:6S(\1:OQaO?VPd^-,Q](#d>(Y:UWR-]6;;G4J/WaD(
VO>X(#CQ17T8b(7B[YXAYd/AM0WA98=Vf.)VX&L:.g2aD:T9L:Q.+bV;6TJA,C#<
TH(U&U[UOg>7Na_F4)@_TCH8H90X[RYQLGI.+?9@J-V0=F(X;V7/cW:N9PEeSMb&
[Bf.bO?+,A;H\gg,A64E)WA#F#B5EO]2;NcC;dJGFAQf]_MC:.E,T[6[[6?eUcHa
&Z;[;(;&O+?M_6.?-5P71ILaP&MBf0>0\eFOT=D&N&EI\T1NBIK-NGGNQK4I6TXI
QWJ<+^59f/AVVM_Q(ZV&V+b91T6db91be@>\CQ^:C7L?;[3TYYH<fFJ4g_R9f]\g
(X;[Tc>5ef6DOBg#?d\VT?ZdMQ/@,:6?aK^AVCU:]a-W_[P??\=-^4\BR0692>Fc
+MVe8:g#.(J>D7?Y7V(CE67_MM=+9=M?MSG_6N[#H:)[P7PE2=P_PFgI.g,00@&_
?@\#29UU;KY6cOE=K)E<e8&e#Ke\BBMfQ_>&9(NMBdbFC,fC<X3N;9CX.BR4M^0C
IcND)4e3^?@0.;]E5)M>4W9?[#GZ6B(Q;\/bCN:bYV\AgRX0+.I4c.0\Y=dO-TIS
@)6PCfP7,Q#@D5P(KaQ_0S)@_?T,I;3F1^Q2MR4D-7NA(E>>.B4M4S1AbN+7UdCL
6YfOV3V1e]3MHAM^>#;/R_[VEbHQ=)SH39eZ>4e0FF(>HVP1fd(SH4]W:AV]HQNL
_Te8>5b=M/C]@KH9MCNS@<>cRBHN,M?L5<)5DOd3\[_5&HS1c.ce^-4GD>263d4f
-4,2&fU)bK1G^&S2dJ#6\UKd]56[+7@UYD[C..>361X90fY&+0;CWCVUVg[GW0;0
NdSR+@;<5FQ6UR1fN/>>T:56FD)8[)4.dN<G<Eb#7F=]YHB9#@4M:8Y>R.OOdeX@
aaP_=D^[C,Z2I<E4HJ\43)b.P1@ffA\ZK0#S083c.a>BSTQFP9VHTeX7GZR_6TC_
AHT_)=IOTgL71aE=O\])TK@XSIbF[Z&&(LVNF7R4-g[Z3MDO@MdB5#O6[T5],[d2
I&+/.Y393OX\/Qa;0AXP<b8(ZfOb9JT3AbF<,b<f8e^4gfTI>Y_\DBMf3)K0[2A-
f?dQbYSGIN4#LB00.^0b7<INDR349/MDM:M6Z[KK6aT]L/Bb4]:355S1G.ENBP[.
WcFZ2+0;7FCgZ,Y5I#ZA;cH/B0=[(-]@@L=816EVN@]GTPTD@TS?L.Q84C7(gZ^)
^bD4:2gY8@M-a.aRb]2C1T_&HPC.N]D2(.D+9QC^QH88#_G];(7A^G)b())=9_fW
IS_W:(Y2BSO+.3]+Z:c[.8A:I/E8d+KUe2QZS0#ZDY7b[P8Y[<(@2@.7BfV96>O9
O^]CBKF2)9=fW-<,QKP@W2CX+=/KWeE\@7>N8Ja/3S-[+.X?,O:>&a8PO45+K3+]
HeEH\Hb14NV]\_YT^_Dc<L.T1X4/JfO&H&,cXP>M37Wd#[H?(+^R)c)b/GV=2:L_
#/I?e\dUcNIPRZa,W_R<a>051BJ01CbM@OK/2WN.138-0UJ39XGg\a:\NI(>,7eK
R,04<B4K1RIKEf]O9f4OLNMaU?DLfR&G>/0g=Kf#H#&QK3&,b7YJFEKd[@gc9D<U
_X(fUWT:L>/e]8OJ4@ZR#/^2N,NJT7bTXJA]VQYE]-ZK^G@TBfg<?g0OHDS-+#JU
FNaX,H?^9&@DN>Y/[B^_LCXOM/CA,LT3:^M>5^X#;a:fd@-S](D+gOWbA#M@:^[\
D[>;B&:A9RM.,E<PHFRM6cfL\^b[@)@aAB/@QNP2W:TcV1PBYMQ(I.,CbE6caCgc
A2;=cYAPEVK7GNLe6.R0O/cLfY.0U#QP5IM]]W9X-@^7F6[g-:?OcWZQ05[f>WNH
P+6b6STQe)JAE]7Q_[->F^]&39Of#e3?Q327R[O[f[DW.f;.B92;#JO]AG_+a3E?
]eH3YL_>R)\,43f,,?V6e:ZLQ&LOg;^F<+fc#A6W1J#=B/6[7RUF1?GJBL4a&X6X
cPCcS_3F3@JD7.A_\d@0H3-#?_eC8L=a6Hg&\RM,5=X[=I\-ZOEd=:#QGf)[)X+6
B+d3:E[05AF/W:0KI0FPQ[)#&-eWYZSR=NR(0;1HRK4faKI#3g>HPA7&SPA6H:@0
7,1bS,@+F6#D]:Q))MX.4;25fW7\HA,N:=<P9A^c@<PV:@DJZQ#bAHJ&HN)Fd_U)
.3ZA]T1&1@:O[#f6O[NN?VDfG,:^5J9+A97,^.];V.^([-W4.GPc<C+7[Y-ceT5b
[A6CJ2\I9GLRG<\DJZ2J,R1TFeDK2gBK(U\Qb9>)9^+0;7bd70ZWNH,LU,d8>-Ia
R,W<XWZD^GWAE,UQ>I5NME]_P)O&Re7aVc_ERSS[L-@Dcf=2N-EgVTXQ16^):2db
-9dNK:FBS-J0WE3R,,\:41(5^8Q:de1JZ#1:EbKUR/P+8/S5)]K^/1R5Y0ed4_f?
JG@(SYa[^cJK7]5(=UXfeb50/1,5W_9702L#Rf.^.TZL^_HbSOQ<;N<B72TFL2&b
(aV8fA..W=ZAW\XC)^+ec+(DF.&9Qa5gWXSV2Tdb[PF<HT2+3:@bY#6\EfYR8G:E
/.<7U[\bRU_,+>H@I]f1IFCLP))6;5fZ3#X#+6ZQ=:QL<QF8PBM,\3MWL?SBcYab
@Y3)WY8FeD7XY;YG4-^J&93#c1?KgB8gX^P;Q1IL\K35>Y),<YdECGFO/Bg3g==8
c,bMEFb.K7e[,GEa<;H<YEb#,4bM]a[U#gD4\Y;6/37;R2<+d(/0fKF)DR(3O>E2
^H#WGBI^0#4Q==583MUagLPPU7I3F9\&8E:A4P7,..gOH?AfQ0SO3SURJU@B]D[B
;[H[A&,T\3a959_FO-.D9_\T:]a?O)O?C_bO3JdG&?KV5+VNc6O:U5UNJ@WT(LZZ
B9d;/\HLVE3gKGUf=\.)1<,<=?e91NAAMH;6.\X@WHO):PMac>.58;b)_>HD:Mf;
]M5Aa07D,(H[D31956:2J,&^/2\5cJ/D]7<4Ue@F8BOG/E7(W9Qf5AQ(@Z[@,COZ
(]C.eHM0R;U;QGLbgTPNbZ\90:b(E<#a;Y=Dc(T+/D4&HY_TSS]>+<e<c>:F?_.b
J..0W6K/f\H#c.GfAP+5B/AVQT5YY#[K7M\ZbB/4aad&/2.S2-He83=I4O)BLdQC
.87V,R#T9Lg7<WJ]@(S7^^6)A8Z0Waa?XPJ;9_2<O-,OD^IgZXN50Nc5UPI+&bU]
S:e5^YZd5VK?IYVL1WSU95eXA;5EY+N1G8c(RMBXNa6XHePDWXG1,>T[X&S4I7=X
:e[YX#N[I(++9ZP]g70c)\2J=@b#Z@SO5e[?a[Q+WSIJY?gf;IdW:@]g_b@OO6OV
#g21#1NS17C,7d.VWK,XgJ#cM5dYFHT38A7CZR-DH=/Y<C2DR/P8G/-7CO8#RKaV
FgJ/=)Zg,NcJ;HDOYX2>X0]H8O<(>Y/+QPI60MA4FeM,]d4Tf@;AIafQgG^T;M7T
Cf-4X](&PNbbEX4fM3TDS>KV?K+ITH\d?e@_G.70THd9eE(?b#L??,5(E-0HMK5Z
,RNMMPES>,Lb?G@8@JO(CD1_IDL?M^O984FL&G.\E<U,_(^HbeeKNJB>1/D12.PC
H36I?(e>,I4d4;-VQZ[UbC<Z4d8CVWW00-DIZ6QIP=7170GfA3FJeUSG-;8OR=4J
6LB;S\:[SP3\(H^>4e)dcKKg?[,4LQ/.7#-f,\=X=[S8c,7T;W^FJ@c,#?7]^1-K
)B6;#.Z,1@/d08QSS1#.S;DJ4g)gc9Z?04A9;EREH9?7+b2)c3O6ceB62fR;3I2X
68=0\_)>U#MD/5-,QSA&GG7VY1a]/61fQa3?_6S?U5NOIbB>d7RQZ<M65IBE=7#5
COOH9U2SVX;_=1Y7-,+D&d=OCfRPfFAf9>@@b3(bZ>\3a<^3e/MaQcb<:cQ]9.:0
=O71_KC6?4QQ/aA5+;FSEBM=a8;E?I7:DJ]J@QO:I#/e5[ff?0104Qb(FA.fYM/W
Db?DXXQBA83\BX&8MAS@geeRL5>QN#A1U=3JPROI#c^dU@&W;5IJS33+6]#)a67W
)/#0e(_c;EX_7ZT;M0bbRTV81Yc.b?XZQS_>R0,+YdI3),@L8^g>#NMDOTU>H<Z_
\]DF[>(T5XVN4>H^ZBIB8-_:B76[;S-OX,@F_)_ATUTKAaNK=\BeRF:e&889-HUf
P#NF,Q18_9HAadM<50)44H<7G&.=O<2e:N-b_e,29UY):KIK#Z(P=\]JU(AQ/>M#
/V9.6d4fd>[1;#43c,#V.J(^,TK)B8K43WD:KQMLG)/OIHQ;OB]=-(1^S>I:@VRM
>U+;D@d+gU]NG[BO6@?FNV=&-ELY+ZAE9BfZ+/X3&QI.gR9U(\HaH/70R/X3gHdJ
OUHI1^M=@^c@-Zb1SOH>[_NdIABFE57356.,,P;M.;V<W)O0R(4M[:[IeGY?P4H?
LYO(f>]=56Jc0<<6L1TA&VXQA(R0I\&&FLCC#gPEOI)JIHIQbOb4QP9/GP.3=W/(
NTFPZ7/cbO=XT:^b@Z#)R6<3(=a?&^NG=J9J;Y&\3Q[).<]ZC5YA2@(W0BPQGC<C
<:b+E_7b.VYSf9?)1#CG@bb-QAMMEUXX;01+C.B>]6;Va#,a^\Z#]+L,+e<aED\3
#VZI[FQ#IWRR#-F>^TJ78X&N#f>S\Hd)H@a;0ITF77AE]LL]BOSCBQ1;,(,aCEHC
FbN.CYWPZ3eE-b:(:I:^Hd>5+9W@91>f0C56_#3Z8b16eD](d^WXJ=NT,A\-H[[)
Z//SCWb>g7LH7<]gAI<@c9PP&T/<BW:I47_&^9F:Wd/P,X=bAGf\A:KP,D[C<d)8
+XeeN5K);?eT/ANMFAWc>AZ;LBL\>[Te492H^>>1YBd>fW:<M#a1PZPe;@/_>Q;M
ATbgZMb7;:GV>2,&PVDG>DaFQF\>)da.T0/OG?IA#)2U/:FXe34J7;P;AR<(4:@f
8d8e:0_-/WY-IdA4&Ia_8BM&Hc05\[OU,MP\fJa^D^:V[eT5&eBNN<@\UPbfK4[H
DY[;DgK9Nb7_b-7:5KM?c2<;Q8,/2PUDMZR,UY0?&]&_>^:QSUDI/:>AP&[S)?\7
Cfb\NP@d7<WN,^c[?.be_fN7c3f?KV:(GPT<gWD@=-JcDW7)RI-:]\,=2Z_bIH54
f<N^AYNM@f&cFN&7L/&4fK&5\&&BRdWgdF@Y?5cf3a&A@T:2=+(Z0RYBCeI1[\f[
)0=I(ND>.&HV1dfaCX)_4L7I>H[f\<2&DcYED.cDbLJ2\[fPc_TT=FPa)WLLB]9#
R;OR\8KOa9I8[73N6:)5^<>?WU,LMTOd^ZIF5CKHEH^cO@<@=LR^46[X9RRg2Ib0
[6=A0>8\#+]]:1SNd@3_4II)/<3,/XK[38DA-[[SEUC43MA+INEebfJgYC2BCP^C
/]Z3IbFfV8T&Wb>d?CQ6@#c=[Ye/[aKIUW3cWLUd.SJdW+g24<D=EYGK?ae<(CGG
1;1X_-Bg=b:/.e?YC63V1=M6&8Y(9+#1Tea,eC@9Z1)I@;XW+75HgKP0G-Y3c;WY
gM>CN7?0/6J8b8)L33>b>Je,T\W\S6KC<ec3C^7>Fg:-AaOGV89_F3@B)I(>A?40
&<:MI710W\X[;58[U9.5IHe#B[E1M(47aL7YXc8\,M<C>e.g?;A4R?:bW)4#WOP:
^.5O3H&Q^a2f58VOd?fb7,+).LDACJUU^:]bK&5E@GL49dLf:Z3AM;Y:UfeY5E#_
]Z:Y)70D:.b@@LA[7>;^33P=>?eMS[8GbELEF#fH8K;>26H.Cdb&G2J4;=@4,<36
).45L>M4(4/Z[8U6Q-B/NI\Q)?@b>TeIGSI.UM)7^I38S&L7_S4JTPDG/dQfeNOS
=4\GO1@e?d9ECPN0UQG0L0E9:g=RQgZ[<PX5MQC9JVJ4(IXOG(6G/\QLZQU[[4]U
:CeRQd(OQO/fTP;bcUHe9FT/2]N\gA@]NeR,f8^1H2#VVG)D]<abC@Jc&<6a/53S
,?UgE<OK:]J]MKKeM45^8ga(URe_WgJ-.4QRDY/>W?)Ne6--OL70M1dDcdV0\K(S
bZ?JC/&&#&N7;G:[b<Z>Zb^K)W=[;[CQA>9TL-bUC:fK7Z>?7/C4:6.C;U(9b7T]
?X?N4g.MEc7ageV#Wb9(_Kg#:?012;D5eF5]JgBMX(g86MCcBa&c<P&bM7.PAOVV
R?+.&6dW0IG,^QDMWQO+HJFS,?.&=YT3cO.V@NQX.MGfO_9b(+P&>KLRO,RY\J4a
56QK[AT^DQ6A.[FLW3J0g/fI5X2+S78M97dFMD8V@cY\SI#FK=_bY5aQf0+?)9S&
CT(+2;P2AR=X.5ZD(&<G\KO8b4)@Hb3&SS(VD.D<XC5_)@QQ7ZNG=M@IB(c39NYa
FI2C2ZeW:cOC6FJWGO0([0Ee1Va(;WC1G0]b#+e;+f7c[6/.RFJ<C]f\.^e/SYe\
P)_\7agHA_g&K;-O)eF]<XeMCS<+]4Me3\A.5YR2\FPI>F>\<.5V[Zd7Y0ZHCdB3
M:M06TRgE?QLb,=cKaQ(.NcZI^Fd68fWa@]8g\(X]:<]<?XWd\6e]K17<CBG)K2N
Y6b^LQHHPZ\dc/=I)@<cf=5+,2:A]>HADDLVO&\KRPVg<7fZQT:gKb2O--=g\+-g
&+W)0&C,+MQLLU:VBOCGa]_^S/7Y=7-OeNV#]_&OW9;QG-BEg2V+<g^1dcAI(.M\
?(CH0gK]Z^72RP>S7cJL7X>B&4^1:AG[2/._QN<G)UWD.gba2TRHB8N??fHY)gZ9
MH9<APG>92RI^Jg4\6eddAd,Y4M6;-4[HBfBGG((gg+c+[;):XfZR]R:3U>-;G=N
Oe-,Q1e<H>3=^SM0INS+-CLa/EYedK)<KgX6_T7W5KJZF]8He?:,CBN/FI+42<I4
)LOa=a<bEEZbJSOGRXX@OD2ZeW_IP>G3)]Je70dR#84=Kd.S6.bTBW(a?/6N=;^a
ESF/BJ]:FO;G5++9fD7g?UEJ7TWMSEI(WE?H;3;bba&W/S].Q7\RE+6@^<PbUUF#
@]>5+_UJ+8C)P6T#U9/[R8VFcW/8(4SVG7[6(@>(acdU1IFR22Q8FX9c3#1R0JgS
U.YZJ7S&OQ8]K7J^SJT-U<C8_4B5,CAX+GB,<RF8GJE]X3\F0(+W3CM&[-OFV(_6
?&&@_J5=]F0(>(\>cG;a#Ma?]FSHAXMT=9>C33Q1]P;MH,=^ZOV/I#&];FA[dg#>
S:YAA2eWfDUEQZ=8(cB<4dg^A=1b?QBO>1cS#F2c;VS8RdPO2(fe@C@;(cW+?@3D
9[Dd.B?Y9Z-LP6V]@YHO.-F\9)b9L=9gM=1(H8KNT/..(=E3EIE[Y6YgK?QT:EC4
a(Zb,2e)NOe)95GE9/RC=E:TS/VQ_8D6LbPaQ(8D8ZW<NHK+Y9=ZG,K>MfW_H(C^
3.2W(^BEa6T7_)0B[-@7:5PBD?>&^T:_>W&N8OAJN7THF__cBKMQ3U9.8E)U\,,2
aJ/,V7]4BbFVC-1-M8U(>T:K\?EL6W01K7QPL[5\HQ4VVJCZ9[Z_VX(a.<(^8-F-
cEWFMK->1IWJ^DT9W]X1@YOHU0:-A8.e=:3BdTO(WVZVFY5:2V,bdV0/<1Y>a/O9
C\If0[\4IfI;I.N8J;19+IM1D=Y_+7[6XeBM]EKcg]MC\bJ&bH#K[W#^JD3]7IT4
DHFXNV0Df\,c]+BD@6T.TQ/F+-Sad(Z;QKC,[RP/,VFaPBK_VJ_:Y)=9,GO9WRB#
PKb3^^0^?,a;2VGV?DUSb_BQ0^6#./^bEP\M]bZ&S>Gg.\IB7[C@IcB?AX;PH4P7
&@,HBH]=c=G<GJ1Q76V&AK95U5UeOHR-RA(QV0]FN>>5):?eKK)IQ6WX__dWL1K<
_]Va;)DgHQ0^G-LbMcFV7+d0fXF@>Z-T0/-YUA3[cV+Z_A3K=4ZS7,H)U.77OfIJ
=C=T+5<=W=cK,A-@6K+OC>86RZ>)KgM2a\Bb(22XG9;(DKO1B/=[9Pf:@PUO4?XG
Y5[/YM&c=YV.gg]/8E(:K,eVC^g;BFbSM/I1AJJ6BA:01EgLDW]VddS-,6aET[R:
P2H4^A7GPS,+IHI]f_W\G)#OW3.XW/0<RAPP4C(X^E\=6]C3KHH>FA+L[:&P(2D[
V=&fg#^QZRfXB7fCKP@9IRH=K&I@1)3-O]R1)+E?7J^[9E/&GP2WdM70A0]bQVgY
2RDBe7@QbJf(76?Z]fb+7MBdMQ8,[L;>T_cQA<;X?3R>@#T)OPc&9?[6]/_TMBX[
3K7LJ(-LL\T9T(JV6\,dGdHc@<C6E8:A:58E_6H\OF;/V8P)O,Y5^(M05:)_2@\&
/7BLAZX^^8U2R-&BI25?dRT@NXc#UCRWfHWP;T+WbN#Ze&g^f0B]F#N.R-0dW3a#
BMK,7Z05=6TG&+]-AV-=19></95?AYB7=@8)eR^Xf(60Y>f5/(1gMN5S?,>LQI,a
3YcCbI+I\+\ADQ;c-V5V/Xf0;C][F2,FQ[=1^]Ig,?W(F,MYA6S7R9Y(;C/[9c7/
C6Q7F[B6b=G@M44@ANKe,KC&8/UNLgK6?G&0\0b.CHc\W?9KIT+>Uf74MbE>eUFE
g/5g3TWW8K^WV+^8QD]=]_L)S<#B&D;afO33dMfX=>_LL1B3e,@1?,MNRcZCYfGL
NE\]UY+-aZ=M:\T<@^R@,<Y6VA(:97]TJH)T=?;gI6&93_g87W\K?@<fAfTe;A8U
L-dYHT72ab@eAcVU0?,Q1JJeTB3X9,dagTe3CL7f&0P9OgS1+Be@#[>CZCX@SI(8
B\eC8@2.bH)^>-W43-;C>f7PGS4L93#QA.4N<6@,R1C(B@a<e=5aN_MJ2TL4L5V&
1acHSJE#A\<II9+=fM;L]:6QH6Hf->MDN\?gL?@]f^Y\3:ZT:AD@DVN3;XT:GDQV
6D)]/66Wc?_?O>Z)EN-R_9@3T3K];I<f;N^R?aGF]Z0Z]f[:2JeX,,G-DeJg@81M
MP+6-2##N>gN#DSd)1#)a5KW9GU]5Wa.U9NVP577(]=9@8[LEDdDHDHF=P5N]XO2
@d.I.JKTZe?1?1K2T/_.dQe98aMPcUL[b^P,8RagUZd:+WT,::8&Tb2TQQagX3YZ
XSI\63^97e[e_3/IaEZ7,9a4R8;?E@^9?&Q:WU>AfK27]9>(8P([^a;g>+MTFZd^
K_1?L@+ZVR3^S^=IXgEG\UEBJ3.e#>S(:RT336Dg\SI]NG/O=H\RG;N:#>cTQ?A>
/J@.0bB.Q9&NdTD?3+^SPc)cJ.F_bFLgF&UBcJ>+=2?4/Rg_IX,cQf2[,IE]eCKT
2>R6K0;+cC]AWJeE/UZV4^>1Lc>,.N)&209ER,KX.CH6eg4MG(H?KM?KHBf,Ra?=
F=W9<)L8_QME>QG]bb01e_f>NSD_C?];6B9bS=0[\7=/U(H_EH:FQQ8:g)#YfIJ+
IIcS;E#+5F4[YK,;_<[AO<#(2EVK\N&>F4ZCNAJAM;N<SfI#;Xe&6NU13?>0=6gD
9#d4gNT9eLXWBd:Wd@e[dCH:W9.7&I7UGRD?F&L&+3/;UP<-N&g@-dGc;7WE@F>b
-=E;_),#]@4.V>6/5G3#f&Z;0KU9)PD[fcWW<1@=0J\Q<7/HZG+g;eWM#OdAA#)0
/868,4TCb-IL46&B2PIA7@Af)Hb>_AN[P>R1:AGOLL57_1bccPec2H59=)^E1ID1
?5Fe1;9G&ecINUI<=F8VY#bga51SaOS#()=9X11T+N)fVCORQKCCedP;M>9BOBB1
3IL2@X-#1[#5>N&)REf)0MYF;\H\Y)<SgV>8&N^2HD]GWUECLV,fH?FH?gKd]2U>
P#).E>7b4MQI)/Td;@0F3Q=](B4:Y/dAScONH]P3ELc+\Rd=/?([A4=YV:S<-@PZ
.Jg^<^0cAb3K)e0\F?d/Tbd>+U;>F4()E_fS&:MGM72.(R?6D2X=M0?d7F#f[R<6
VRG]M5d6;gX@.XXK5[N&aBJYc+648F.ePZ->8L?-;AP-U:eNE,-\7BXeX8-EL2:)
C?,=-c\bg=FFQS9RGP^aB7GVf3MJ;T@46HH2NCd-..gU6_3O;_35\;;R_bdRLI7G
C1I59ed;T4A0WZ(7+1Ug@>=eVR8U+gRgAX_1AJDD+B5fB0KT+JPdHPXM3G7eZVT@
=#B+4a8>7[11LJ>]>5,MB\2>.W/KQb5HXdR66FCB,TbG[[N8R\7NW8_59+HX[bd_
]\N><>MXJ1TSLN8c.C-,Ta&Qg1ZP.VT7[S[.-Vd.G&T6[eN7,Ab&+c094dd0\=Ud
e-fP[W,Rd1&/MTW2ceCYWX6_\NCBTK[N>dYD\a9FKaFWAB4C0;AUD5(8<[>_&4@5
R,TQ3KUAa4\4?)7gaa1?X,8)?_3[Z;Q#bUA_3EBO(B&5Y60=T1.7\E?f5B\Q)0bI
8U@:ZPB&UCW4,$
`endprotected


`endif // GUARD_SVT_XML_WRITER_SV




