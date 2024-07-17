//=======================================================================
// COPYRIGHT (C) 2015-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_DEBUG_OPTS_SV
`define GUARD_SVT_DEBUG_OPTS_SV

// -------------------------------------------------------------------------
// SVT Debug constants
// -------------------------------------------------------------------------
`define SVT_DEBUG_OPTS_FILENAME "svt_debug.out"
`define SVT_DEBUG_OPTS_TRANSCRIPT_FILENAME "svt_debug.transcript"

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_defines)

`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_data_util)

`ifndef SVT_VMM_TECHNOLOGY
typedef class svt_non_abstract_report_object;
`endif

typedef class svt_debug_opts_carrier;

// =============================================================================
/**
 * The svt_debug_opts class is a singleton class that contains the automated
 * debug options requested by users.  Options are provided through the use of
 * runtime plusarg +svt_debug_opts are used to control the behavior of this feature.
 * 
 * The +svt_debug_opts plusarg accepts a string value with the following format:
 * inst:<string>,type:<string>,feature:<string>,start_time:<longint>,end_time:<longint>,verbosity:<string>
 * 
 * - inst Instance name of the VIP to apply the debug options to.  Regular expressions
 *   can be used to identify multiple VIP instances.  If no value is supplied then the
 *   debug options are applied to all VIP instances.
 * 
 * - type Class type to apply the debug options to.
 * 
 * - feature Sub-feature name to apply the debug options to.  Regular expressions
 *   can be used to identify multiple features.  Suites must define which features to
 *   enable through this option, and implement the controls necessary to honor this.
 * 
 * - start_time Time when the debug verbosity settings are applied.  The time supplied
 *   is in terms of the timescale that the VIP is compiled in.  If no value is supplied
 *   then the debug verbosity is not removed and remains in effect until the end of the
 *   simulation.
 * 
 * - end_time Time when the debug verbosity settings are removed.  The time supplied
 *   is in terms of the timescale that the VIP is compiled in.  If no value is supplied
 *   then the debug verbosity remains in effect until the end of the simulation.
 * 
 * - verbosity Verbosity setting that is applied at the start_time.
 * .
 */
class svt_debug_opts;

  /**
   * Struct to represent debug properties that have been enabled through the auto-debug
   * infrastructure.
   */
  typedef struct {
    string package_name;
    string timeunit_value;
  } package_timeunit_struct;

  /**
   * Struct to represent phase names and start times
   */
  typedef struct {
    string name;
    realtime value;
  } phase_start_time_struct;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Static log instance */
  static vmm_log log = new("svt_debug_opts", "Log for svt_debug_opts");
`else
  /** All messages routed through `SVT_XVM(top) */
  `SVT_XVM(report_object) reporter = svt_non_abstract_report_object::create_non_abstract_report_object("svt_debug_opts_reporter");
`endif

`protected
N[RVY]GWBc/X#B:D-#5P#(WK>G^5B5e_D2G9977IYOUaYe9Jg#:I))5/6O,<36,&
=U0g5?/@c/^C/>H+5Fd0@C8DBL\L1K2XP.I?DDcE^a]d1K\^-[<H3)KT#-LY(fc.
gM8:JBH<+VRC,$
`endprotected


  // ****************************************************************************
  // Internal Data
  // ****************************************************************************

  /** Flag that gets set if the +svt_debug_opts switch is supplied */
  local bit enable_debug = 0;

  /** Singleton handle */
  static local svt_debug_opts m_inst = new();

  /** The string supplied via the +svt_debug_opts runtime switch */
  local string plusarg_value;

  /** The string supplied via the +svt_debug_opts_force_cb_types runtime switch */
  local string force_cb_types_plusarg_value;

  /** Instance name supplied via the +svt_debug_opts runtime switch */
  local string plusarg_inst = `SVT_DATA_UTIL_UNSPECIFIED;

  /** Instance name supplied via the +svt_debug_opts runtime switch */
  local string plusarg_type = `SVT_DATA_UTIL_UNSPECIFIED;

  /** Optional feature name supplied via the +svt_debug_opts runtime switch */
  local string plusarg_feature = `SVT_DATA_UTIL_UNSPECIFIED;

  /** Optional start time supplied via the +svt_debug_opts runtime switch */
  local longint plusarg_start_time = 0;

  /** Optional end time supplied via the +svt_debug_opts runtime switch */
  local longint plusarg_end_time = -1;

  /** Optional verbosity supplied via the +svt_debug_opts runtime switch */
`ifndef SVT_VMM_TECHNOLOGY
  local int plusarg_verbosity = `SVT_XVM_UC(HIGH);
`else
  local int plusarg_verbosity = vmm_log::DEBUG_SEV;
`endif

  /** Verbosity value saved before the auto-debug features modify this. */
  local int original_verbosity = -1;

  /** File handle for logging auto-debug information */
  local int out_fh;

  /**
   * File handle for logging VIP transcript data when auto-debug is enabled.  Each VIP that
   * is enabled for debug will route all messages into this file.
   */
  local int transcript_fh;

  /**
   * Storage array for debug characteristics associated with each SVT VIP in the simulation
   */
  local svt_debug_vip_descriptor vip_descr[string];

  /**
   * Storage queue for pre-formatted header information
   */
  local string header[$];

  /**
   * Storage queue for timeunits associated with each package
   */
  local package_timeunit_struct package_timeunit[$];

  /**
   * Storage queue for the start time for each phase
   */
  local phase_start_time_struct phase_start_time[$];

  /**
   * Flag which indicates that the header has been logged in the
   * `SVT_DEBUG_OPTS_FILENAME.  The header section of the file contains simulator and
   * simulation mode information, VIP version information, and package timeunits.
   */
  local bit log_global_settings_done = 0;

  /**
   * Flag which indicates that VIP instance data has been logged in the
   * `SVT_DEBUG_OPTS_FILENAME file. Each VIP intance is recorded, along with whether
   * it is enabled for debug.  All VIP instances that are enabled for debug also list
   * every configuration property that is modified to enable debug features.
   */
  local bit log_instance_info_done = 0;

  /**
   * Flag which indicates that final information has been logged in the
   * `SVT_DEBUG_OPTS_FILENAME file. This section displays the start time of every phase.
   */
  local bit log_phase_times_done = 0;

  /**
   * List of object types which have been identified as types whose callbacks should
   * be force saved to fsdb when debug_opts enabled.
   */
  static local int force_cb_save_to_fsdb_type[string];

  /**
   * Flag to determine if callback execution should proceed for an individual callback
   */
  local bit is_playback_callback_available[string];

  /**
   * Mailbox to hold pattern data carrier objects associated with callbacks which are
   * used during playback.  The associative array is indexed by a string value
   * representing the callback name.  The callback name supplied is qualified with the
   * full path to the component that owns it, and so it is guaranteed to be unique.
   */
  local mailbox#(svt_debug_opts_carrier) callback_pdc[string];

  /**
   * associative array to hold pattern data carrier objects associated with callbacks
   * which are received from mailbox but values are not updated in the task 
   * update_object_prop_vals in svt_debug_opts_carrier. the associative array is 
   * indexed by a string value representing the callback name.  the callback name 
   * supplied is qualified with the full path to the component that owns it, and so
   * it is guaranteed to be unique.
   */
  svt_debug_opts_carrier playback_callback_intermediate_data_carrier[string];

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the data class.
   * 
   * Note: Should not be called directly.  Clients should instead call the static
   *       get() method to obtain a handle to the singleton.
   */
  extern function new();

  // ---------------------------------------------------------------------------
  /**
   * Obtain a handle to the singleton instance.
   * 
   * @return handle to the svt_debug_opts singleton instance
   */
  extern static function svt_debug_opts get();

  // ---------------------------------------------------------------------------
  /**
   * Obtains the plusarg value supplied via +svt_debug_opts and parses this into
   * internal control properties.
   */
  extern function void parse_plusarg();

  // ---------------------------------------------------------------------------
  /**
   * Obtains the debug_opts plusarg values supplied via keywords other than
   * +svt_debug_opts, as adjuncts to the +svt_debug_opts options. Only executed
   * if debug_opts have been enabled.
   */
  extern function void parse_secondary_plusargs();

  // ---------------------------------------------------------------------------
  /** 
   * Routine that tests whether the supplied instance name or type name matches the
   * values supplied through the +svt_debug_opts plusarg.  This method returns 0
   * if the supplied inst_name is a sub-component of a component that has been enabled
   * for debug.  The #is_parent_debug_enabled() method can be used to determine if
   * this condition was true.
   * 
   * This method also populates the #vip_descr storage array with the status of this
   * VIP instance.
   *
   * If empty inst_name and type_name values are provided this method returns the
   * an indication of whether debug is enabled for anything in the system.
   *
   * @param inst_name Instance name to check against
   * @param type_name Type name to check against
   * @return 1 if the supplied instance name was enabled for debug
   */
  extern function bit is_debug_enabled(string inst_name, string type_name);

  // ---------------------------------------------------------------------------
  /** 
   * Routine that returns true if the supplied instance name refers to a component
   * that is a sub-component of a component that has been enabled for debug.
   * 
   * @param inst_name Instance name to check against
   * @return 1 if the supplied instance name is a sub-component of a debug enabled component
   */
  extern function bit is_parent_debug_enabled(string inst_name);

  // ---------------------------------------------------------------------------
  /** 
   * Splits the leaf path from the top level instance if the component is enabled
   * for debug.
   * 
   * @param leaf_inst Full path name of a sub-component
   * @param top_level_inst Full path of the top-level component is returned
   * @param leaf_path Leaf path from the top level component is returned
   * @return 1 if the component is a sub-component of a debug enabled component.
   */
  extern function bit split_leaf_path_from_top_level(string leaf_inst, output string top_level_inst, output string leaf_path);

  // ---------------------------------------------------------------------------
  /** 
   * Marks the VIP descriptor entry for this instance as a top level component.
   * 
   * @param inst_name Instance name to update
   */
  extern function void set_top_level_component(string inst_name);

`ifdef SVT_FSDB_ENABLE
  // ----------------------------------------------------------------------------
  /**
   * Creates a new svt_vip_writer and sets it up for use by this VIP instance.
   *
   * @param instance_name The name of the instance with which the writer is associated.
   *
   * @param protocol_name The name of the protocol with which the objects being written
   * are associated.
   *
   * @param protocol_version The version of the protocol.
   *
   * @param suite_name The name of the suite with which the protocol is associated.
   * This is only required for suites that support PA-style extension definitions
   * with multiple sub-protocols.
   *
   * @return The svt_vip_writer which has been created and registered with this VIP instance.
   */
  extern function svt_vip_writer create_writer(string instance_name, string protocol_name, string protocol_version, 
                                        string suite_name = "");

  // ---------------------------------------------------------------------------
  /** 
   * Creates an instance of the VIP writer and adds it to the VIP descriptor entry
   * 
   * @param inst_name Instance name to update
   * @param writer Writer class to be set
   */
  extern function void set_writer(string inst_name, svt_vip_writer writer);
`endif

  // ---------------------------------------------------------------------------
  /** 
   * Returns the VIP writer reference for the supplied instance
   * 
   * @param inst_name Instance name to update
   */
  extern function svt_vip_writer get_writer(string inst_name);

  // ---------------------------------------------------------------------------
  /**
   * Routine that tests whether the supplied feature name matches the value
   * supplied through the +svt_debug_opts plusarg.
   * 
   * @param feature Instance name to check against
   * @return 1 if the supplied feature name was matched
   */
  extern function bit is_feature_match(string feature);

  // ---------------------------------------------------------------------------
  /**
   * Obtains the start_time value supplied through the +svt_debug_opts plusarg.
   * 
   * @return Start time value obtained
   */
  extern function longint get_start_time();

  // ---------------------------------------------------------------------------
  /**
   * Obtains the end_time value supplied through the +svt_debug_opts plusarg.
   * 
   * @return End time value obtained
   */
  extern function longint get_end_time();

  // ---------------------------------------------------------------------------
  /**
   * Obtains the verbosity value supplied through the +svt_debug_opts plusarg.
   * 
   * @return Verbosity value obtained
   */
  extern function int get_verbosity();

  /**
   * Obtains the file handle for the transcript file that contains VIP messages.
   * 
   * @return file handle
   */
  extern function int get_transcript_fh();

  // ---------------------------------------------------------------------------
  /**
   * Sets the global reporter to the debug verbosity
   */
  extern function void start_debug_verbosity();

  // ---------------------------------------------------------------------------
  /**
   * Restores the global reporter's original verboisity
   */
  extern function void end_debug_verbosity();

  // ---------------------------------------------------------------------------
  /**
   * Records a line of header information.  The following data is pushed to this method:
   * - Methodology and simulator information
   * - SVT and VIP version information
   * .
   * 
   * @param line Single line of formatted header information
   */
  extern function void record_header_line(string line);

  // ---------------------------------------------------------------------------
  /**
   * Records the timeunits that have been compiled for each package
   * 
   * @param package_name Name of the package for the supplied timeunit value
   * @param timeunit_value Timeunit value for the supplied package name
   */
  extern function void record_package_timeunit(string package_name, string timeunit_value);

  // ---------------------------------------------------------------------------
  /**
   * Stores the debug feature that is enabled through the auto-debug utility
   * 
   * @param inst Instance name that the debug property is associated with
   * @param prop_name Property name being recorded
   * @param prop_val Property value being recorded, expressed as a 1024 bit quantity.
   * @param status Status that indicates whether the feature was succesfully enabled
   */
  extern function void record_debug_property(string inst, string prop_name, bit [1023:0] prop_val, bit status);

  // ---------------------------------------------------------------------------
  /**
   * Records the start time for each phase
   * 
   * @param name Full context for the phase
   */
  extern function void record_phase_start_time(string name);

  // ---------------------------------------------------------------------------
  /** Logs the recorded general header information */
  extern function void log_global_settings();

  // ---------------------------------------------------------------------------
  /** Logs the recorded VIP header information */
  extern function void log_instance_info();

  // ---------------------------------------------------------------------------
  /** Logs the last debug information and closes the file handle */
  extern function void log_phase_times();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * This method can be used in VMM when the main hierarchy has been established and the file handles, etc.,
   * have been propagated, but new log objects are added to the mix. This basically just propagates the settings.
   *
   * @param inst_name Instance name to check against.
   * @param type_name Type name to check against.
   * @param new_log The log object to be updated.
   */
  extern function void propagate_messaging(string inst_name, string type_name, vmm_log new_log);
`else
  //----------------------------------------------------------------------------
  /**
   * Used to update the reporter messaging to go to a log file based on the debug_opts verbosity settings.
   *
   * @param set_reporter The report object to be updated with the new verbosity.
   */
  extern function void set_messaging(`SVT_XVM(report_object) set_reporter);

  //----------------------------------------------------------------------------
  /**
   * Used to restore reporter messaging to its original verbosity, and to redirect it to the display.
   *
   * @param restore_reporter The report object to be updated.
   * @param restore_verbosity The verbosity which is to be restored.
   */
  extern function void restore_messaging(`SVT_XVM(report_object) restore_reporter, int restore_verbosity);

  //----------------------------------------------------------------------------
  /**
   * Used to track the debug_opts start/end settings and update the messaging as needed.
   *
   * @param inst_name Instance name to check against.
   * @param type_name Type name to check against.
   * @param track_reporter The report object to be updated at the start and end times.
   * @param original_verbosity Verbosity value saved prior to modification by the auto-debug features.
   * Ignored if the start time has not occurred yet.
   */
  extern function void track_messaging(string inst_name, string type_name, `SVT_XVM(report_object) track_reporter, int original_verbosity);
`endif

  //----------------------------------------------------------------------------
  /**
   * Records various aspects of the VIP in the FSDB as scope attributes
   * 
   * @param inst Hierarchical name to the VIP instance
   * @param if_path Path to the interface instance
   */
  extern function void record_vip_info(string inst, string if_path);

  //----------------------------------------------------------------------------
  /**
   * Function used to add a callback method name or a list of object types to the
   * list of types identified as types whose callbacks should be force saved to
   * fsdb when debug_opts enabled.
   * 
   * @param add_type Callback method name or object type to be force logged
   */
  extern static function void add_force_cb_save_to_fsdb_type(string add_type);

  //----------------------------------------------------------------------------
  /**
   * Function used to see if any of the specified callback method names or object
   * types as callback arguments that have been identified as being needed to be
   * force saved to fsdb when debug_opts enabled.
   * 
   * @param cb_name Callback method name to force logging for
   * @param obj_type Queue of object types to force logging for
   */
  extern static function bit has_force_cb_save_to_fsdb_type(string cb_name, string obj_type[$] = '{});

  //----------------------------------------------------------------------------
  /**
   * Enables callback playback for the supplied callback name.  When playback for
   * a callback is not enabled the get_playback_callback_data_carrier() method will
   * return in zero time with a null reference for the pattern data carrier.
   * 
   * @param cb_name Full path to the callback in question
   */
  extern function void set_is_playback_callback_available(string cb_name);

  //----------------------------------------------------------------------------
  /**
   * Function used to obtain the patten data carrier object associated with a specific
   * callback name.  During playback these values are supplied via the
   * Playback Testbench after being extracted from the FSDB file.
   * 
   * @param cb_name Full path to the callback in question
   */
  extern function svt_debug_opts_carrier get_playback_callback_data_carrier(string cb_name);

  //----------------------------------------------------------------------------
  /**
   * Task used to push the pattern data carrier associated with a specific callback
   * name to the mailbox.  During playback these are are supplied by the Playback
   * Testbench after being extracted from the FSDB file.
   * 
   * @param cb_name Full path to the callback in question
   * @param pdc Pattern Data Carrier object associated with the latest callback execution
   */
  extern task put_playback_callback_data_carrier(string cb_name, svt_debug_opts_carrier pdc);

`protected
1#-NNf>]=e8<O,0J@MW,LI6B1DP4a8[AL?AE,SOH>U4RO]af8F:?-)2ZX8WIE;7V
?[&I[^5bOB4O/GHef2:-:/RRXK6f=8f,>4Y,cfEW>?8??FN?LE3Qed4@c1R924b,
)eLScR2U6)[=f0>SSQC73L/8GN7XEPe1O-P=9dIK\CJX08#eHWGDZB[+58T-d:Y@
3&O.OC39CB3PdEFbJ)aC.)a#-S3)<>^;M39a@JHP:2gA>\04LKgN#,A[HS91].P=
OBe#1a.H[/>P.$
`endprotected


endclass: svt_debug_opts

`protected
CZLdUH#PP<:ITTc0\4PG985ZP)NaJS<+,EKY3e^g)ScSf][XaZ;O3)=WOYJ?;7YL
I)P?baR7M6:2FU<G]77(L(WPO)A];ANAWC+>[AN?8&5;1R7K+B7,2eX962d-.9X7
JS2;JE/N2L_([L4FO-2@@.X:QB[cQ)P:e#/e?K_ab?bVLM+J/6UEF3G&.FV\&^OA
K@XbMAa5UN^a_:HMWIG?E-Y2#AJ=Jdg3>68(^/T9;18gLJOg(EbXW]+6O4CNJ3D-
D?5d8V1AX7_(DEC;S:Q0P.I,9bZM.QD_W\C:N0EdcS@\I\-4cK=Z\4M9IA#=M[4\
W\-_J:DJMJaEF1L8Meag;+IBg/&?VYEUDXF[eO#N)G1.,\1cCV^IJJG^LYBA&W^;
F;X@L-EVD.>ecaC2R9#fZWNIgROC=c6&_X0H5CG,7(@:,ZPC1U8,Id0FW>M)2(N2
,\-8D+N,YddZ,5[>9U0\LUgNc,a,3Y2R-Q:fWLZC_)U]@_A\]:b.&GU\#&U6aD(H
KAT?_&]-f]fCNYO/UG?V<R2@_I>C()1)gIcP_TE.<FK0Z_HNZW5#W)GCQHdKQ]e?
NEcf^--QS<AXd2-LC4JYNN3a>0Y#5Kc#=f/^#/E>f<0[JAb,7M#eJaN,U#]L3=f3
[+Y.AANb7&_g)MDBf;S:-&/Z@N=Rd-R-9-<QY[Qf_1LfJ-<cUR&3/TF.A0/eW<SU
ZOF8aRKLMMU;GdD8A8b5\bQb?V/IO.g8:#d+\dS[ARX\]^HZS6DSTeJZ<&&1/O&2
T9?J4RVXSZVKVNdJGC#]@@<Xa_e796F,:ALZ9Tc[OKH_AegQ(1LKO9O2?,.G.TMg
3(?@2U\?C5JYR\\B6D1caV;QO3X3RF<c&0@W2#&574g<d.S3F5966@\CdFC07Vf2
<^aDBYAf>E]0,4_J:3:.6-6660QRJ#L(/A6)fd&\4T)e_S-L\:N3G.=E9/-=?T+/
<b9&G:GbNg)04CcKc55LQ>VXa#JLCD^@eG(Qcg3,eSTKEY&3(fO56/DK)+_N4JSc
e.fFCdW(6TX>UFX7.@.@0/)\-V0c=9+1A3DdNc2Y;0#0e\ZUHZaQ70H[[T34;-TZ
QBcNIbD?,MB7V5XDY@2.a+\M+DD9YVQ5g.:#TN5G:>)/L]HMPNR,CF@)Ef?&.b.g
([]IS9F938Mc3:\B7dCAQ-)B-AG:=./\5V1d126.XV@(0?]UD,BL?ZF5bA]cX<f+
8<D[I+RQVOUd0KL3bC0[gT;Kff;;)&V>gF<Uf_2X9D8^-e.S4;157L^AV)V2<);0
:@NX?K6,M^(Cb_E],38HTT1NLc7E4ZP?B#Sd5C#(9YY;][.O4g@=H6+<JGEQ]M<_
\^VNJAYM06<;\7+gZF].O2b>;<QF+#GCF^8,geaaHL7-[)9a&(OXgSJIc.0)G@F:
Z@:=<>Y(GY/c<R]^]N48.=Rb6=DMgdg;>)G.<W+/MQ&fU[WB@&[@YT,?V-eM-<&B
HTVPZZ]?4OYaf-Q8T::,?3TRBX9594Xb.cK;5\J=IQ&\RKL+\#I&#^[eHLF_b(BS
-KRa8FZ-J.84d3</L^V4]MWIU(X/8LH=f.T<f):&YeG3ZAA;4=HOI=1?D2;f/7^I
8f;LI/3]LZ9ATV;ES?K,<9>>QY2Q6T\<TN(51?(\dG6(W\,<,eL_/UVQNNF4N07#
]6;R0,\VDZUF<:,#)O#^;?N<11Z/3?-OR>X/;b^M(<aReR6]L&W3?OEGf.?T[c2P
XZG\<e90GP==J[OFdR-F3VcD,5U5>9ZLW&eSAd2S&aCP=?6(K#J:,ILG3+aR)K\D
BL+JCFWYZPKK[[I:7W,PY;-S:e#<gc7-_M>XR-UXcXJcT&V^;?8Y8agd1GZP)e_=
+JXM18+9S@.VZRSa-E3B:e)Fa6HWdY/>bQG&33HTKD(;IbX\RHFRON/.9(N1E]0N
^ER#\FFg-LUS._)07bNWC>@c9^<3f-1I)JO@fPa1>=0#OO_HEdN,2WSSCSD_VL0R
ObL?ZJXcEd2dB=E9I<U87IX-KJeFHVd+<49FP:H3c:ZH_C-\9VPY)WI^^:bPc?VF
]Ve2LUEdb6@#EK:H82Z_,<-4]TISB4X8(?B1e4J2H1\Q#^?)]ELSVc;/EF<#g0T6
Vc9C3g,JH]g^f#?GO++6Xa3a?A4g.dL:3X0fKDf<8CBLP-M6+F9cK?]3UVBH/XI[
5DDRS>^/V>U214WQ?3\(F#DMSTb@6Uc@>,H[abE,C2U3T&_UC\^-3<1]X((?144=
/XN.gGEADNZ:\gV+R[9-@6f>QgD2b3f;X;d8G<aOVM55\=1JT>3LA:I3/DB:D]M?
[9bSPLZWgU&YVYc(:@\-<.TA_W]7IH_>fKU+X_RacU,;HFGdFfM-6ZRJa;bf1_;Q
e]OHObRY0S:(,/1I[dMN;67Qg7?;g]59?6YKR[BH[[-]3^ad.XA2;ZW.C166f@K(
VK4YB,X0_TJ)YM+80Z[2.\,KYGCLV\4=b/7b5B;GP9JW#^#?_OMcBg=>QFCO(TGB
R\D1^e[S+B,:\fc:KY@O58<a&#.]84S^):a\+=3H\;,<A8c2G6;)F3=\NOK)LRN(
XJZ:>S?KN:e84B=C][E7Kf4b,(_C-QM#T_Z3\/<:YC_3KM+/3YXa6G-a8UK5#E+J
g4[<IOfF7[#FEaS^\&]C=-A4,X[K.#2JeEdcYU3J^SNfD<GVM(-=1U=]Hd8[D7Ea
<I<&F5)KP:;.O8^I-\[<.=#)8Bg:)(;?/(ZH274WW.M-@3AC)cAId9HN<<UBKU=6
++E;L6^A?BF9#UK1-/Wg8BY673:g#-P/QYE8;)N]EJV[AF[V@fgWb=WP\b=5;7H7
QfRK.PGf=F&^NR/SP.b=R@MV(R=aTBE#@L/QKCa\N4C(?S\RTI3Y2b786=Q8K521
9Pfe;N.,>\;UQ,O]R2QV=?OBF5)?W=5YW+>@fX(6HR8<fge3aDb?UH\dP)4+-DbP
U1e0bG=#5Tg..C<V\)0[)FD2LX-bY6J>5G4VNC1G@[/#Gb&_UPA=T\QNSc+7:C;(
I;X[)X3)@WfE[XSdR96&5=RWUQX84)\,0;5XBda>;-ZZOJ=RA<@g#>__;e:51DfE
0=4AP-3ZO@b)g7^NTDE>_XK?/Ne@ae+RGNb^_M2]>WU3V1/#I(KQ6ZWX>R#;?82)
Bb&=EVWON7IZdGT0TC?6I4I6L,YCV#,7bLH>AFH=+TM0N,,+NQ2>+Rb24XSRBE.)
,RIA=FDI;D+?4MX(FX?DAX].U(])@&X(+ER4L^5:g=D#;2V1A5E\,CSdTV0IIgDH
[ef.RN+RS^J)E8+^Z@Q3cU0W8+3\4<1S,QGC8;QT(:,H>[OLOKc+JG?8?08Y;b;_
QT=dS5,bJdE;08?L/\P\49=4+#,N_1B>OD1?&7N)&e(;^D7AOB.6:X<M+2@(=c.^
dLMB(BUdEX6LV>:;KVASVGbOaJZ#2DJLe<>NT&J704C)cX5S&7Qf#+7KR?b\8OP;
N;B.I2@5ZLP1J91X78I5>UdNCA^R26R+/DXHIYRQWK>KDDc6@N)9aER?4]_d:IAD
e418DD:3D)_dRIO6HaS;VI;OcR)<D8@M&,?\XDB64]Wea?-9.H<d&==Z_^8F+I9<
R5I+9O-9.A8U,+,,dOL?5YgS?f_WN=KEFA?;PU;9B;TcILZPRD\PF/MUPS2_b7@]
&ge;@8UbR3I;2NXFRegK1b3[=RJN(aHKb<Y1ODB1[Gb^PQd,KPTA(5R]Xd&GV<6+
OA(U6>\R//MIAENbXUKN6X49ISbEGSLeD4R-\93RP-N_BNVJ=Xe3Kcg,7#LAONC(
/IE:B?[AQ)X-L:&=+X?:JaYH+LLUM>HY<#-JeY=a,\H/]\GWN:3RP0.O>3DMOD9e
]1PEJe[5cI\A[g75MaY80/5US?3;[>5BCN;LL/2Z[0:9B#Z=fg4^;KR6@,5TBE8Z
(eB61d2J]@NZU9+)6.85<5S8NOg]KU0T=^;7GY]4^7,+V\[H9RQe^O.LI3J&;e3Q
7PXg:4P#,Tf&K;?Q[,IR<\\D,dH\F8#HLe5XHI/>QAM_PQb]Y&03&QDbRcL;9-Yb
+T@XA#[2OJQEYGM_+\+PYN/CBWO_4D;_]?0ZdNVJ^?dIb&IKS7).#Hc10)BEI6O4
]UUHH+[C1g7MON((.)FJO&H)YZ1O^-O+K=P?ObH/\U7RFadQXMIK?V<>EVGF.?OS
&\##@IdG&J6R5:WLZ4K^B4SP:^2YA9=eWfg8C>)Dc.T8eZ5T>?</3:[&(FMFQ-3G
V4+VMb.H0JaUWAF.9SdG_;MG@UL4W-W/V,(aEK9I5\O7d>^fgGJTY=X7HTf:PYf[
)0LV2V:UeM:dc2_R6-a6\1Cc-/AUUR&CSEd,4HCCKM]LeBNQ]M)F/C8Q&ED\ON..
JdH>^F4=B<GUG(V-48XYO=UAGZ#Q.L>f8F(T/&IRdAT>(S]\,cS:^VQ-_UW<;HF&
_?>AAS9#<GMS1B9GSDM4EZ^Fa(b<4.a;@[Q2Og?/3GIZ6E0+55S@>=:(;G)1bVCB
7A1FP(V\RCgCJaH>D=F.cM6=;QZY1N#2W#63g3aD9A#[g9bF:2=<fT>.(S51T4a1
)GB7YL?W[,?+He3EC7.<3//HR<^T0e.<f@IUS0))0#)+=<:W<Y_RD[2GcIHJE^IO
F[V+U?G;dfK&NYA(>FA_d]3<\Ig9H72cT]<=73YQP<d7LONFDQG8cfZdaYeN#[_.
7-,)0V-P&)FLSKHGD8C=9c=d-WR>N)WFYBJ2).>abICW#ag#g<[VV(E;+6RNf)X2
)BbcAWKN-^K0@BE0X^V2:DKf+WV@F#>:=f79JB34/32:?5OR<0G,@&^>J>0.FLaG
d[S]P0B:_9((,FcV[g=4f^fb::1dH5D;F-TRK9I:Zd+FfNfId]#H_5E3PBP:0R:+
\\]&X;+8OZ#]06R[4QPgS:&aUE0F2+E:cA^cCG?Sfed>@4OQPKM61+XVH?La0Z_[
?cX6E:](De\9ZCW(02a:4O3dU1/6O8[=;,=+F)ACCI-3+8R]_W(&fD&04_=?GC./
VH^d/c2\@JFM281,<Xe:9\Ie)SEeBLD8:+CVPfc]3\Eg8\TS?50JOW-&;IW2g..?
V5K(GcB@Y:LPF]d,e9Y+:A1_gfC[OMI,06YM?UNF#;WDNO;;<+W\&+Tc(:,S>>K&
,fXP>Ac,GIDNW#WMX5)3H;WOg0^QL0Y_Ig9a+dG>L&dVHDc5Z9/V@13D>C;0)cR/
W<L]c>@<:D,Q8P/4OBMP278BJa\d98VQRW8JdP[Z7HUZ[\V:c5IQ)EL]fZZ;AU38
bB,32CJX)13.?ZO_R7I8aLdW18AR:<R8@GQ@.fST(/e7452[(I4BNY-Za1R_B.\8
7[83;6?e@WL2a5OC#c1X3BAUd1NEN\0Z)P,,fBQM9I;Y2,fWNPO9@.3;T<;7a3^2
^7N5#DW\G4Ve_a0,J8715P&4)cQV)5@(&D=H(KV=Z]bWc.E5YF.G1]MY+[&(]MJ(
OT]Y=0;T.7]\c=VdSYY&GXWFYV^X4d.bbN^.(:+UBR&dXE_O_6_d\IOH_/?466aL
H.N.?WR3+&0YIBW1<@GC/JJF]cIBE.G?-.(2QU90Z&-,XNUU0DILA@?132-0XQcN
&9dY>6ONK:=cLIeL/:FX&J?OX6F?CQH;-)Vc98bG;P>/]NAL7O85E??=.JF?;IJf
>)KR(W5WZGLeAPLRLCIFV,325NW#fZ^90[f>?2(1OM/KYNGBCM+C)2I7c,X<-(3Y
Q>&LaC0N2LXgUH^VfKZ=/20^VK_Y#UPU=,?b-LI;b79=<]ENCd=DK-1GQ7ZcB+C3
X,RCPdFc6W,g\;G(R/V=-#TbG\<XE6=;4XbB(<JF>eIKF6V)e@Y59;IYZ.>R#JSA
+=d+]?[OT9;RXJC;f_ISUED?3(XM/40Wc772@gHF/(e9bOaHc9I(ca2V__,Kg#0G
V_SAFf-0T&c:G_QASB67[866FN/MUVgWPNcMJLQY&fJ3D#&=C2T,EC_4QN&63UT0
U;bT]@adW7(#T+9cVP2\ZK2?&L]IaPY.B9>PR.(BXL?VZV4V@F<Rdg6FMF7N6:<R
B?>C/@cXT^3-[UX(QB@GAaX8aU3(](QV[gA?^Dc31+2,OU])Se(U_66NEaM).@IT
U=:S<C:E4L/FcRFEU.0JAaTDX.3-2/<R9REG#&3O4eM?eSHTOe^D?F0IKS-ZdUF(
KSUK+Y3PC.)<TLbM4Q6e662GG]6NIa#g2_5LE>BGT1O</>FGNVJ4+G)U0G?b6YUA
eGCC#WPR(D-&?OF(VU5.f2RZJ2?\K#6V0:FLRX5.Y8?>\C#5AH;IQ0OdFcc)S5.N
Y40Ge:GW[H5^>/M1O=SYM#Y)T500&LD?HFP;3R?UZX9,Ra4W@W8&JL&&^4],:RDW
b/C/&6=)Uc\O(A/&W8&TW/3I90eC;6U99KXH]M[d7F6a15bVaG3UTAf?L4b-OR3&
2/JSV5Q.8F>0\6CMV>df[QNOV/KC\Y:a@feHPCL2;eR+0:A<ZZZ.>\^<PEc[a[PA
&_:5/bMYf)7.ZOP.RQ,4BSSdf>Z9J91X\QG4+\&?W62SJGZ2Bc(E2e)JgY><79W\
d;Tg.8A_(4gg2IG1VW(bR&fPC;FB1I?dCF.\D<E?M&EH30:+<XI,/.5BHCA[S+1L
NV0([K^9/XL.N;=^c<WS?5TWD;a_.M6gNZ\3C;ETSGSXU2g-/J1Z/9KHeJ&\^T2W
29,-B(.M4K4S9BC:U4:]e8_AX&8_UEd>bLS/CEA#L)\M#M:XZ.TPBYATKK_H0<F0
IMVeWcX32a=&NGB>W=BdAIU=;A:7]K5e,1D-#]T[#U&1ZEM:40:7=WH7IK5ED7HJ
:S4d>IAQRJMFF:K,gFe<[MdWQ^\<XKfcTT[IA+14Oac35/OeI)X-IVa+9=VL1Dac
EV<7V\X>&#[EbW:8_1=\<?K;L9BHX&7b<2QJL9d?R)+]D<KY7F((@3M)\#M:.d\/
]:RT+J5g>]GF)V6a?PS&V>dd@fSSd;9gf+H;4&K60Wc(<-/QC;a:O&OS?]7?I5\:
QZe.X^cEX@;LcY5f):P>]gYG:<AX-0N>T\L<F,>78D)A80)0>7(Q/b\RA+8?<;[^
ESTZ>(-^3e0,D.7E683d0fT4+#]:V;72&@SaH)#?4+F[EELe2,;V2X2_&2@G)gBb
PbD]:_95XIafI8]2cBT-+Ac@_]^XS@M5XLgRYEFa_S>c;>JB5f;JXTe,I,\b4B&V
1NOIN9W\KFFg#04_MB)4+JUEe)BRb27>6PK82C65bHd5.&Nf5ZM663?Pb(0Fg45e
FQ_40G@4Le+DGe7;:+gM6/[.,MTa>=SE[9^EK\0Kd?cE(;<CSFaW[73LZ\MTR\-1
HWP8Z,+c.@b9D2Z8Kcceb)=VY04a)g8Q5LL6AV^@0,Oe6/>X15\29LG^80ER=,Sc
NdF+2#B#[[R#M\g3VX9d)_&1TF(<PMbI?BSdG+:SY^ZaT?[Y&KJ[d]-84bJf]ID2
[G>9R9JG=@DP&EHN6gODH)aZS\<0c:QU\\U6B&,PZOg.D((7a:I6W8Pa_EMX\->I
d.TXXP<;NeMfO>BcXWOZ1VKO^-KW9+QQeG[AgTE,Y(<Kf>\)<<f4#+#VQeK?g@-]
(4Z2,;JgJ+7WS:+LX1HI?XfIe;W(QJDB+H8)PI6M6(76b\SW^XV)X3(J(31+@J+=
]1>K7([2LbZ(.@.VD-)9,fN)T[fXVU>dAJXX:.f/ce>bFK8Ff;KaN1CVLTd6L[5I
J_OW5U4fUEY+Z2S,ZC\ZT34Q,;SJ:.R8YUFHb+L@fKP,3;0>?\;MV2\N@?1+3+3@
\a@:-^M3Vb8_=f1.&dg_1.d,BO)=)&=Y>P4V_>Y)S,?KEY2/1GTRZ-,</D+;49L=
??HNaFMdaI\GX[\ccUF1_0_egW?00Ab;Y@FG89)Ad=X_g1dZ4:ZD]YQY+b#a+T0#
NI+[9PfJdW/,SQ^QP1?SJPV_XC.H&BfRI:+c+XSR228gF3F+e+4dY0+2B((&8Q3D
=V-=S.=,c_U8O^]43/ITVdcG0&C.CYWfJ+Mf5-3X/D[+8+2G(03.3,9NV0RJ?HD#
SK+):T[&@HKN[Ef:B27DM,-OU7T#(B8JNA<D]UP-0E-T2P/;T^D6Gc]G:C62c)=_
0-0;&b89?L0DLd+NAGe&FeF1JgP>fN&O\7Q8TD&MK9GR(T#Q<gOCD1/C8HI,SbE#
K4P5;6-6(O;_W[;+98OK0fDT7baZ3:_O=WXY=..V?&R[@8]HYGg;@05]P5U]d,Y;
C:5DN)a:/[ZN+(VO;1@?BP^D]-2XQO-0N/5>,S<,5L#W-EEQMBUTG+3@<_WQU[5@
ZH66gfHfUTf,=<K.BE]1KJ,2,3gE_g\b)3@<MH^42YN)N+>GD7J,AFM([+MfX1Ia
GL(.Y-A2YMSKDKXJZ.a+Nc1T0>1,K@gK<[\ga?DgU7DH[B^6ef22]&d01Y0J3>Be
JQN_8K6WEYLb-MUg6S6Ve4Z^6VI172Y]2GDf<]/FILN;,FVd2)O]ST2(>S&dUEGF
JH-00QTV;883N)BPP6,5(P.Od.3@N^7E/])@I>d,SV6?5JLPP?(ZA3\--?96b8;e
Q@<1?ZATbJ@HDgFF&=VED\_P&Q3R&M1DS>E6ZbE[9fY>W\e1cXHg7<9MM]Z?_E8C
Wa/(aMM5ED_Q<J^?d>T)decIQ^ggH\O5be>C)Z79&b0e7@CD)9ZdHSCS(a5^_F-9
F^B7IZVC0d9,#RZB?LRW+@H,B48T\()6)=_IZ^6fBT#gbb.C?CN<0)f;7V0B\RD\
8AXQ8GQ>KLR+MJ^C?X_9A#9_?8<9U>7)E&18>+;[T^)aE)<UQ1Q/:N8CVC^Z>cSP
RI+6<PHTfc,cfd:ADd5N\-F\aSeE=3.MRX@fD?ILS^Df32Z)1XP&(J1G?]Y@4^;3
LBK?6Cf^^THM,3:W5TZQU=?7Q3EU.;d\Q\fEXYAFeSF?CD_TUWMNIZb3Te0E]198
Z5YFKA;1&??7:WRFNYaMW]IFFTG@U2UfV^b\YR>.Z,)W-R1H:J:RP=@B@\BEP3OS
@4NRdD0:G@)WR4;_=\H40G_JTU;XM(#6SZ?M#;cAgX8^e06T_HLVJQ]/]dH)c)Gg
CM5fbF-D0O/W=QQ:XN7>K-]KQIO2U4TMG3:/GNSWCX=Q1YPK2:J5+[2]#4,7R:+/
]HF,TIgQCW+0&+Ud;U/CKcTO9Z@@QGUX9#RN<TH?730#-MR57TC,[eHY4U2R1db^
P7QY1DF)[:/NBaH/XOWZC3HN9?/+gIFK)=BE\_LM-@Q9PebE/_WXI;G2W4P=ACbP
a1fKC4WGP:GD#T5AD^0UJO7Z0g\NY/DbE(c6X=#1S2X5DWA&#=1-5JK()G5-I_R=
SU=1075\3gN]E(0)5G?B6F5V#R25CM8DU7IXP>;RCfIR65((V/Xa\)DB3d(CWEOE
<a609;g5fe8M:A=+#U;R&.Dd8TQKNZ7H2D5aX-a/+PT.U]fJ/SOa2.,BDS+YXgJP
c;U5+M=0;JU3(>ZY84I3VY20JE_<_?OJ]KU<8;.5=I>A7(/>,O&[9<=PE5[ZTF5b
I8/HDW<ISQTQ]86)5bA<U:O^f3aUg9-1Xg8Q\F7(VV\4A:N<aQ:(0Q&KYD2V[E3U
L<3gH2a[NEO_W2f1C-c]VN>>CVg8Z(Ha671KbI:+965LP5#dGQ(gDTCSg2c7<gVf
N5_P02CYe]=9=Y3Za=1EYLFUb72:D&LKN4-Q9VedRec>]Q;L.0)HQdcBZBDEXW)(
0cICY4dM)gb4D(?<EOTe@Q-5)JSKa6eOE\VIK44.))K1HHL9J2/^)DgF(=5Bf:Xc
fB:LUcT+VP2K5HET\Z.S_SYJ&Q3QU,I(Q4FYJH)A=-+P#NbOU,9\#L0WDM/)3B3/
-X&.eUU@/S@SS^\a2SR9DWO2aQ-CJ+25O/6cc95Q3f+dcH7Sea;b9Q0&8;X2P.MR
-<fND&<Z0dFGC6?M^J+c01bZTP.V4a10FO<\J/WPB:X36NMQSA0f/XZe;;)W>7^&
P<@f,R:&fdUM@A6O;//FI,2bcL@TecZaCBER)D@,-_1[K@]b61LF0M>JXd>V8S80
<1[R=,P=QU^Ea4MKg[bN-Z7J\N#WHMPfBW[+.8\CNd0O#WZd,2JF5>VXWY4Na6PD
cC&IC2[MUTcW7-6PBT^U<IZ.<V.RbDWB6#JTH=TV_=,g_8^9)&?bOIg>dT<C1F];
Tc&3B6_QN8f:9/Y5D:Z5734aS6/:>Z<)[@@7<Jf8\Gc/\.)dXKIb@GB4L52Q7&gI
?>O=F3M?2GP8O>f>L(aU/CL?CQW+.aMLORd[L)GP=)>Y@6bf\,GB.;ULB???05V<
@fHN#1XZOT1@g=ef<YGXg3R,M-.0KgPTZ[JXC]((\+W21>UKJV]ONd4C[+>AfKfW
>-DgEA)BMV=g@3<WC..cT<;c?Fe9NOg-Y0[OO@#I[=8Jf<>[-\PWEO?&WPgZ-1@<
&<P=?0_YU\M+1g>/W_#<T@]87+C;+V3Y^J8&CD>+a4e@@Jf=UN0DW)P1N-#-WO(,
DF#48DZJ^+C01SXQ2E:(.c[XKM\?6c:8F;:APZW:@[=@1eXGcP:W/;ZZ;/ODKB;P
O#,ZYMJ8AdQB,(QF)14L2XRNRed&B4V5_Bg2A[:FF_(aO,W)Sf18#2^bN:WME6\F
M]I9HFcCOSF63]ED;Q0-N3^D)IA_ZS^U@.FV:<e1FQ9=P<c4USG6FV3(W/ULA8gZ
0;V^TGBeGWCG,FN](8&EaXHAf.>WTW&NZ?#XS<Cgg3:TK7DeX(XfA<?-2Te:92IE
1Z@#SO)ZKYF5L=._XZdDd&4D0MReR?(&.5S#=<A+8/2&.T)/W0TH6,,b^6OMS:(=
LVCB8^A5cYdO,[B,G5c1[F?B822Q8,85C.Q<OLT/.NO&e22/X7_E>@aO>0J3[A6E
QSN#(Z/D+#?[>4A8MB8AG\;/@a(]Q>TW&6K^-;bOU?+f8g:_b2+RHW1\e[QW.Q\E
9L0)IYI>LA6-;AEEHBHRH_Q1^aAbbK_?a7W3\K15_<a:8a+4A[b@Ba7.A-NeF-[b
2N861:\7d/H#OZ8>?GJ240=9Yc>XU#Vd5K85WN]LFfQDBN[MVLU33?PgXBCO1^_E
b7<3Y9CC)PZLU7IH3&_#R_2UB36eBT(XGGGJ#>C;3RAIDH>PY7GR(8bVd5126DO=
,O05ZY4VJ4HZF(+:IH6eaL;07XE.EfH6)Uga33#.^9-Ba(35:6#&\26bW(\3SR(;
UL8_4_826J&BV;Vg&<A,@.9X^)8554CM(+EUeb-[:/N9#8KCQ_AQ4+CS:I\H/VPb
2\=/Q[Z72,W1S8UCE2\MZfJR&M7L\2RcRJ>HC_F19.?J-:83/@dOaM\ZUD_>-](Y
XA.E,5J:0DHaAA4C)E,Q.f_Q6K)RJXDUPcNWQ]gNT?ZEAZ6,5Kb_Xa._0]@F1,ZB
ISH[]/.Bbb7N>B)@(FDT<KXNO->K#_9]Ye?.)bBP&L)0?HVXP)WK]Qg>D[D@IXA<
3FJ]cLH[6Kc,B4/[B)<VON]4U.RH5<-[fb@=N51\_V-F);+Fg/E1L5MP,d^=U9-6
=I<&b4N??C5IEL?2;S0SZWCdTPd\=H]\2#2V&,(]D>-5>0/c9bA(:F;APT@^(d=8
/]#CJ&ZM3fF[@WJ@&C,T^#2-:/B)Ig_PO^9/W+_HJaZT,aD[)=Z[2NUUDQJ88S-(
\5.aNJ06(^;f]HEAWH0O+:U76C+:ReX2]4@K^cX)<^@&P0^&/(95[XF?(D+/4AbD
TaRHJ&3BQ:.?M:3K5])><G_5EFF\a)/A[Q?QKMA8W3AC8,8OIZW?W?aUg,b9,+-3
<E#(82MVZ8UOdX-H(STT+>YebS>F?W7FKN,NXEWZ]_K=-[Ofd595GIQ;HCL^:96F
8O-UOH2K?RgSg7KHH3g&YTCb8)Z[]#X);:RIZYPRR.EY9S+/<cS4OfAPB2J5WM5G
T][X9a0=Z.@@5K/HL_c+_JP)cg0[31:aY38dMa2ObNP:ALZ(g9=YH:HWG0=Ab(AB
NT0AOdPDE[5.9A:1NCUP);&=[AP1?]Zc^5E@6Y-OK_@4b.[]2I3^Pb0.]1#T+8Q/
Q[)aGP3-[7153]I/TgQ(Nb3bYb+)WE_2IPO18B?(8&9T4@b,,g#J-#E/H2-1dDKB
JE5fM1b5?;XBC,]-OX<,2WU&30O(_T:\dAPbgOBCDK\(OD)LZH;_:ecBC;b/dRgX
S^5H>F)Md/D:\\D4H]bBSC:acY^98.AcH0BbV(-:f?\[J+0Yf4\]3@A#72dcF(_>
#B(Z8Y(1UUG,Q<dO9];;[]:Z)dE3.57V2AJ-]g:9b6V5S+ZD>Y\27N+-=,[7D_AD
O_P_7;9C(e_fV.O?X_g]bOD1;<d,-9DZ,2.6KdD@T3.@3+.FOZcL[1I]XG)UVaa1
agHY?OCcEIAV&NUQ1E],MP\EJ7(AePbG_VC&FOZI?5]Rf=M-BY/Z?Zbc;)fBU7><
fY<Db/bMOF]YbWS<HfA.>9BUH[7BNC++6@gRE=MS,_Q-d1Id+:44#P98^;K<FM8T
W+B@1\OLT;WJ2eG7e5JYfQ2YSY.@_0>ZUTd:R=W&4fMXFQ+\YL7c>KZ(=AXF+R#O
O]]I]SSYHV(A]4W?&2K5W.>eOd=QO&T8MTA9ecC/3W?E&8[?_dO(^O36I(^=M:EG
OMG1UT5__H;=K9H/2:J1LMEQ#+fIT-a3G6#([gLO@,B7.6)/QFSfDR)D]>C]f5&/
g<c:ZJK_;/;\7@J#9A1SDC]dFcBX3Y\&7I]LWJbc7S-0HQ_^:+;L?=4U&gY>R7,=
3/=E-)6XfL5\0E2::FccLa,8L=g(\.Ke,/<gIFVT#0M0B71#6O>AP<\_Y/VS#e:L
[XRT5<(QafUcH>ZX3<YU+5Fg<RNfBK;?)\e\,D3FY?8955g,W4?=SW,LW]C#=N+:
#0#=-JDAD7U4Q:IKg>]ROQcdGLEB6/5&Ye7&+/c6I6H_WA96858:&E15d[7)_=@4
[edC3QH_f=W7S^1_fcANg^L_L?5cf7G]^Y0[MfR-JYWR]VXUUc6F6BX_D.A=YOgE
,WQb;?XQK0SSVQ46Pa;e].91HIOfA1SZOA]a[0<,;+]6?,E0GFZ;YZA>XVI[RT+Y
01WPV&3)^5:\IV-E5=K6g13HJ<d3I;KE96\D:9F#+_;3/H<;Uc.YAR<4.-]BN30K
7RU?,=&U)/34=,:1>:J#KP0ZaB[V3<R]K73IJ_92X:#^5W<ef,G4(D\(+_R49&8G
&:bR/?(_IQ&BcXHFKZ@3,[ODJ-TPXAP5_7a,YTULJ:#+Z(=ZCg@1]V0bZ>aa/_Sc
R14NRe4=\Zg\.NGCEB2adW3-H&HLER.4Y@&BNM#P]F54@^?=&+^:[P@]^J/&:a-;
-bMOVI&M_N)8Y=T0]bc=MFNT<a/b[f[_Y:?77CfB+:++R,WaXe^4K0/+AHZM6E^6
KB2[Q:2/YL<)-GG0fX&Q)FdLT8JP?YDW[TE[?QI@1f8NBa540bT(>I97P_cGdT[O
G.f2dUQ.P(YbbH1QTe3N+6fgb:\6[B9AGZ#eVZ<J5@W?US@SGbO)g\4ZRYZ3^BCM
-WE:e][9?GK4DSIKAAR?(4CJW:1UP6JU[I,D,\K9f/Y.HHY\VR@]4D&,f=V)3bT=
@2c[+=L6eg[QL<XUX93A\E2gFZ)K;^\_?K.6_OD3)4fA#Kf:)@[?TDNZ_</AgSAg
RcVHEbSCLK#KVB;SMLN@\88:\IZ;gWZg+[XL)YK6+(FYK6P9P5#^.?X(#@KG+Y7R
W[?[9+_STL_B-_,7&>P-J2ELM#_aE=4X\JaBW/PM]6B<NP4+6#R-RHf,#E1\MbWQ
[&dBW:E/H-(g)e(X6L<[HMED90LM,UJ9XO^g?+_KLS751A=<#1ODH]J.FY61dDKU
/L-a/DdJd)J6C6J[NM.:<Hc&80:9DW?&JGg7H8c)8C[,R-J/L5M83]Scg(RgS89@
05D)+@)E8#bJ5dZ#gcPMX78:2@eSP7Q[T?[?->Q)V5#JJ1&&e3S=VKP<DZZ=>[3;
4(>^JfFL?UA&,@ES5+cLf;5&@&e2fG#5T79:BP&d#()E38<RBRC)[4cJb#=Jd=Og
?N;8O487(NgaZD<HB6]6PS?Z[WFY_fA=ZB+B<)/EZ,,:LTREHf./24>faEcP_FA.
DLN5Wc1a@2Y;EZ2(SI3)[L5cX4,d9Y?aRe7-dY@bS2T4b.G8K+<@0K@36cX1M:[U
/ZEHbRH5G4A4Ha+C?H^9<d<<ZE?+Da_2NN&I6Hg6EEg+X]RK=R,N,>D/R&G7:I3\
,H)5-5f@WF@9AeWbX9HMcK&;&L^EOE2EUa)MY>c[^/F<e-3]_^XS1FYeLfHLRc:P
8D9<@,F3W\(4)DHDHDK>;-Ng];NCF@&ac?BO&Ud3/PD;,+G][4T\<XR)1H^5P,H(
\bJ86;7J]\QDI9LW:8)@+5U9CTeTH<)dUD[B_RL6S)&&RLf,F8;).YHbD=>PJ<E/
MBdL].@@fW;A1e:PB-F0D]Y\O84M,LK5ZA:AW]9LdBYaZ1;H,(6NRZ>)(EZg6).S
;I-YKV^BE+&@7cfa#>O4gTUEPBg?=:c@UfBa,R6K._D:ROV\,Z=RUEDCUWE-U<P:
7JQG3U_O6:X_7U9V874W:WB8c:_PKb85P9L58JC7LTHU45+G9+VLQ-M7Ab8H&1YQ
OC4FEKUBCc,B,NfS+L85X_eX,IG.McF3_\V-H9R3YZ+WeK9LP0B-<f@_09[W8(BK
#8&/?BLdN=0-S&.I+C/WXD.6W/HN2WI_BGP#TYOa#-/NYR\ZV3;==\>X@J,1Y>AC
#\GdXCb8;D^PXNG2\&-;HJ1IL96/4gbSQ9=)>-<:-/J#d&=J)J&HPS\YV0P5Y&JT
0G1HdH?N>-E;^99]YEW2HO.+Rbc4.ET\:<[?HT;cWETI,.QJaeI+I[ZO\L((NV2O
V>9SK>-4?]0>/QQ>5_Z>5,eKT25>H\PL92ZX8YF;1+DCW&7DZD3D8X#&;7OY-JR\
ON,E>V-01,a(9GGJ9,U;Q#YE7Z7EU<Q3>1Zf>DAA]4Nbf0CZfW,M#b7bT/:G-CMB
dD:&fH@:F]d^U4YWF#//0\57aML)c60Gc#b>LJ9@UQa\X9IC.PedPG<@_BeWN<.^
@a^IbfTe2Ob;;^XSL^.,=g][T6?8R7I@<9?.YOY::/W^D<7K2P)VB+BS\C7AY>K2
dE:g/L^Y0?.aDC)4=:5><9K_#C.F9EZ;[W94Y8e^X][J108^WJ^DE:=GHS&4:\ES
f,T&f+N4fD+]_ReZDIUe<(DP/g^aR+4Uc@Ebe0C-bHR\S4@]T)Ca,EHQ8(HR12E?
&N+T/>0FFCT8UVS^-GEAVF.9T-;I]bOdf+^GY-B,R&B8#B^RGOg4#-]>#&5+@O5)
S:bWG#aMY_-1e+T[^bdMaVcP@Je/BVY--]]>]\27e@,K_=O@TRT/XQb=I)W\A@JJ
X&AM>_S\d8^a[.-Y0^F][;=c-LK[Md\>M,LU+J;J4@gH77^P];cTV^e?8FJHG1cH
IM;\U#0SeR)8d,2b1>fadN+W?<=X/5,KfIO)5\U/D[cQH/\-V7RHT&ebc[MAa,GP
d-BfV.QT&L/[KW1eA6?Hb,d\aJI78Q.X)3GPVQ=WHZOEB=[aQZ:0;1&K#T(-=4LF
QBQF+5[#(H^QN=87_b/6IY1Jc:D9;[F0@ZYd0VaDS>\@OfVZ0eGOZW7=e-]7e#WF
_+T(]V221GEBJE?8CZbU5-@\YY-UW[+;.,I;d>L0N]SVC<(Y]3C1>JeBK2>#,=Y/
R_Se@[93]<?NfTW?^(.I&?]PD1Y=TBL_3aI5IG68OH&R6OW]daI0#NW6D2_g7g/d
Tg]=11_O@=aB?fOQV&H12Xe1+1MW?VB]F0^NGPDC,e=:c#6L]1F=d\7Xf+[dL,Uc
[QLcee4bFSYZOH7H+M(5LMH4RG5&K3R:,>3d-W^/)ERXYWZYTUO6B.Z4a5OgMe47
/aeZTdVM9fKe2a>Y+gN=?E8>JAc9<<>:;]/(E=]f=aO;aC[H_WB[bNXC=/bJJ/2W
3(6\S(b\PaLP3Y9#D\OF/1+V@f#+dQ5[@&6Q_=;+YQ5O<B4<P26CL&2<\K&W1RA@
@T,P8E\29cBSGfPHZ;536[:J5Z_243abBNG40XV(]LI9MWR:MKb^F5YNX^PZ=,0c
9R;FO>M>[0a2JQ,X]gEX#^;>KcOGf^YTd4<G9B(ZCBV_fL^eD[J,gXG9&=VcK#,8
(SXC=].fSH^fEWPGC[;#L9K>+^5R&:U3+E:,PDP1908BfSSbER+4LU<DFG\[L>MU
6(2S\LMZ#7a&,C8)1#a>XWXI1f\^K5DSD+R80Y@2^.2,W]b,M@g92+?MIT.KYgTd
5C71BV\YN-<EdC6YV#.XB^X3;0\8NUR&M8]A+4eTCGeDH0Y[:1+PW#LD>cG\ZU93
_86MEWE-MP#RadL0R\W5aI0V2_dgC7F2Z4-TVc]^5&QcP:)2IX\_T33YKERTURHE
Zd-9C@<EbT3cVNdR7fd^&K=bbZQHIHgGL#<b>QB3B39,228B>be/,?f.<-YDO>R4
18?d.L05D7\MZN@B.A6(@#\gCL;#3W5eUKZg)JGDB5RUWWPYK>U6N]#+=^+]eO9a
,U4X&\)4C[7ceD>5bA9bg;^UeDH/+N,+g<aZ4Y.9.)U8?[1[-b^MB98f@2cQ@X^C
ZVd+fU;=QP=MC5<GdT^aIK>dWOY]#Lb;dQDU-[\cP3>K[gNTKY9ecb>AT=cQY8TC
^AaC>TMHLEQ3X(8g]@?)]#dOcJceXcR=D,MCcGc?9T4:[B.aGV>f-2N5e5d^NUa^
FEC-_O?bYWdMY+<_>W=Z\OY,R^O2]IPVDDbFLHL9N4)(^,e2A>-@AS8e9HJ^9GA7
eWF\\=))23_SW4OJ^LHd/H5]/F[/9+Ge>b<f/Lf@>48<);S.dQ/AT,B6+[XEBDCI
G.aNWYWWL(]:0-YJ7fYX;UJcI=a>MR._SW.[gKH+dCR?6e)b,DAJ.[A^-a;_BB]W
H#>-WLG,YF1e>dNP.-=99E-1<G2;&.6.;fbFf<^d,Q47+^gL/-X].0__N^^;3/>R
ATfEI+7F3FYcM.VF=DI./T8R#eJ7^6/Ff=F4=D=a>_A9bOB0GY_<:NZ4Ac0=F?3Y
PY.;Z)N=IP^A+Q:?2c6/[.d-[fY+5+7LYGb^Ad&P#NZea?((f=E>&[<U1RFbBG1I
XXMHDbCCY#@KO6g)G+ZDObaFVSIcGaYMM1;VFQO.GMed6JC,:#G,9e9.e^=NL#9=
UCK67T[4&OQK4;75ZL\D0X>&gJgYbKYcC]K>\/@=-D_QY./&?UQ23baD\]MTDE8R
GJ(T)@B3?(&UY>+DNe/d)ZF]V;.^:))M>d,J-F1TDET8bG7+7[7fAH^bW?g)]KRe
LPI@\CU\B=da(Z6[4cbcW,V/JW.[UN;e=&PZKB+)a8(76+]YKZ@b:RDcGJU>7.(_
YC02H>-PZYG<OWA]7SaOfO>2XH,\ZFE_a;[f:35M-dSd?H(8.-K3MWJ^([<^502T
@.MdD6@J,5f0YDQ5RO]:A):_-2J7](2-OM@D#_4OdN+^c5ZU3GB1E:XZ4I.a>KW:
S&aGBECJFXL=VGD#,R[aPa\D_5SAK,XK>_N]@[D1Ibe(;YC62U^?\5Z=LEc>&#&S
LJ(.;dDD(^?/LU_,E=a@Ng81Jc)#^UG6Y7L?^AMT@]W7+aNEOVP,_Ef5GW<\WaG#
LVCWKUH#Z](8E&VCd\B&V9PBFT+QeGP8@3_\@W?]Ybb3F\ZU+YKADT>b9g8V3]W6
(2#1#HS,OT61Bg>W]:;,S@e3]cOSb73Q^Y2:8VeaQ3U:_Z)HZd9.?a8QV=X@9(?7
;aJ[?^edbZO(UOH7U12PQc#.>;AAE/\B_.W_P9]P\1EN63WG@2MbOJe?8)OI&7+A
>?gddQ-(Q4B70^UK\dcUe8)^]E.>Z;8;P(P_859QMVC\]LH34R4E/W2+_Vc81UM(
+BQB@bD;2J?2-MCV6>I?J_YVOJA9M4DDVWd9F4/)5[9-Sa39/)S#[R?#E)7R#8-a
YNb7.I@A,T2A(QYfYA3YId\2DS]g=>+-2\=.TTfM5:14a4IARVIBWPg8FLDL4UVQ
J+EC;^?I,9?-G]&E^7>/L(Z=J@BW4BW>B>cGI;);J,\eI]\CgQ-,<QUQ,3[B4NPZ
(>WI]\:Y,\8M@P+4T[-NS:UF\F9E:=e@Be0S0fNR[S/V_P-D0X8?+8UAPRJ@BcL]
beSdT7NG+aO:J^GZC_5?#OT:PFMJa:gWHbIR9MeG^V4_+@?T,R7Z:)a7Wga1RM^K
J1V[]C_8M=K?D:(e6W&[dL;Q#Z_9,I:HaWTE^UU=D^04><(b,M3A_/0fMD_N,=Rc
X1bdMa]BgCgL><A3<MU4R=\]3/KGefRZ\\)fRBcd3EH+3A)<e&8aM2#>?gVRSF&7
I7:MbP+dSWAY,V3P@fA_L>ZD&Y(8g&CHX9;@aQOTeK3N-F4(/^YGcH_+2?T/\-82
@492#K3T(,DU&e\0_P(bLC=6?3+M)JAKSdEG[Y3T&L,6fL\J8RY5YeSK7B,N1,:a
adS[f]WJ7g:_E@W(D-Ib--:Lc+(NMQ>S8YLPKd,,N&2^IX](L1e;)<Z/0KgS1\A3
L7.4b4?1WH3?L)#c1c8K:7/V.4OE).7O,8S=2VG..N>7.8X4=.-IO+,YWKbdUHb8
B#H?.5?2d7gI:Q+ZZLC4TN2VJ0)AJK^X2X]V7g^JKTIFAMA;bXH1NA?QIXB5Y#\C
Bd[Hb@V<)VPbZXC]S/YMM@A&NB.d(AQIX0a/JcQ840a>=7)T[F<BGUb@]9F]^F+T
M+e5\EBa@)8(6dgN9IgGQ\\8IT^WcP#=4F3_6Z#V0#\]A5HU=L?3+0D(f8GVL>,S
6aAQ_QS.F6&HR#1L0?edOe#6T8(<bJL4YQQGIMHg-g3VeJGa4WcK.>[0@RV-.DD)
LY=9WTJ))JXOF7G)O0DGd,CR3,)47(#&W<,8(^>?CJOIV&-GYQEe1J@.>&1O5F>J
@8;?XA6=U;^R)>aXN(8AJ.&XS7&S<F(:,/M.NS\FP<C=HgII5bXYQR&:\bXG0g2;
,A.L0TT3P[LMOKSX/G_#.F6@+/OYXG5D--#XQUG5HZXJgF9\CX:JN+@dO;)7]]9d
;7FUe1_90./Q/6LGLD.Q&D\fEdH9b@GI1\AVag75X@.H,c:E+adgLfc;@f(RW84H
BRX4>CVc1=+G)5Rd_aSIaYTc&=[/J[UAT,:U]Mb2@>5SB@f@2O4[^WZ#QI3K.YY:
V?O@:@>GV]1NZ^;_fVdMQ8SeEU_B)@@+a1eK?S;?0M&c(HC6Y].eg]J;1g:YQ5,Y
,eMLQUOUO]M_XAF\A0/&S]>P-e44TQ+1#^f.GZeZbNg(X7&][B//L&/GNZUKE,6T
S8E=.S21fPDKIUIT<SH0C,R1FFQO.]AL[CD3W,YaL1cKEM#DNFc^e_S]39@(B5MN
Qd>c?YUF305:Dg8USFF&J5HYDLPbf;BgbY+U;FELeE^7?cf.I)_1M59>C(^.A@++
FFeaCUA]@&)I76<e8J_T:ACS#d/RVT8\VMT#(L&c_2[]gK)Z-EAbKbe5ODE+#=/1
HINa6:/]CS1??;Y<S.VQXSRgJ,a0:Q<F;42?ED4-P(;VICW0,BK2E0KDAdeXdT+R
)4]@98;d9?eP#U)Hb-L3]3-X\TZFdcQ9)dA,=VZRH)B_AQ-fD/NMg8\/G(R1[MW1
O]#U4M2[1+^?9\1;CU7U<9R.dfH@_/:UHM5._Y;IRCHY;Bb/WU]N\Y9Jgf-eXXO3
XSJC2Q/c/W@AV-.ZK\-W^d-0<3<-N?B;SB\/>ZG&5XQ5KACLZ<B1^-a&2E)P5-.(
M_78CI8<efIF@^(]9TVYWXbI)X\&?1.H7,W>6W[?c)YDO#S0G=\WKP2S7e39REK)
b+5Q9;H=c,I\f#1.Hf(D/\aT6&G9e-IH^FN3M)V6GQ/<N2]<g9NJ<8<;P@5eA1S8
Y1P6a2SaR+Y^5cFI\[EL3H-MQ_D)Y<:eJM4Qb_dOA5_O+eVNN/aS#UL#FMX<IZK-
,DMTJX#A+<O?9ERKf?g(aJgcXQe/_c^5dY)ZL1?#000Ve]LgU1V[cE(H&3]N>X:<
ZeQ[Le2]/[e/QR+<<)K+\\e9XL3\7A[HN-Q,7NJ5W.E^]^]/+aW[UD,JeF0?]RC8
76&Y5QDgcRL7dGB@U+:U(1b0DD^3<:B/P+<#2K_L\4_A\#73/I@#VA?c6PC;.0eB
d<_1:VF^P=GIKSL[ag9>g&@);/)N/U3]Xb2f#5#Y]YV\H)X>ePH6-FY(?V61\TYU
RPXfG&VT_7?3G9NE/-TK,9VA>@4LV<0QT;;AOCcb08A(+[Na(LXW)2.OgK..2;g9
[&<2_A1+6+6(eR>6#U#@>V,C2(eYf5HX0&#5-(&<:g(6V+Z(b^0&><STO>#)NEdd
e+g@\[<U\#IKK19XMFR(=\,bFb/3K9JJb.U\K][W49]QFY93=)Z+M=0ORU4eVI-1
0<_UZ47Q@,S9HE3;^]1YT0GC+I06KHTLW_WUFQ-LPe4e/U#gTRGb#MK;&a7MC79_
2)=VT#4-aK5e8_c3.cdRQHb<3(^B]K#3T9TUAe2/B@Bg+N+_JMaZ6^AA+Y3K1P#M
-D3Ne@FD5Rf,-^D2dRD7X(,-+K:;);BCO>9S&fb4S99M/TgcUX2>aEM/1R@[)3E8
<f21Z[#XY)dGX?/4)FI6F=Y>]D@]7a6&fJHE0bH>F+8bYfaEXe3ac:,=#BQ\6/8g
F\LSU;TSI[/9\BAO,^P[B;0>Oe\AVg73)9U#FV-U.:8c1_>.<WJ&5QC?#>VZ&YDC
<Lb])T#@?8QLL\@bLL@;G_4Z?):#R2_5JSZV0\&4QHFR:&aWd3<>O5#5)FFIN,QW
O2-?.5S.4C:?e@YGSTIU0OTJNS3W3dF([SK0BH\<H8.(NWQC9DL_cD1a/16fDg=M
,8b3d.f7Uc4L[0G:E^J9]NQ8a/4>J2)86RQOJcKe7K9D])_2W(J^ecMZ^F-Hcf[Q
Ocf3/a06bfK81S]//2c0<P>eWcTM4JR+B<UW0\@OM=IVK.(dA\a81)#(BMe2M6J.
ZXfMfY>f5g52f4\7XcB?T7##7dW2+L-?&S(+R@+X@)+@;EM(Z+D^?W8cP?BVR<[8
J6Ag[Y@00FHeL>XC<KOSB^c_)H?ED5J\I_WT5OH9IZ6CTF>CO:SUD(,)7\1&fPaC
S8b)bYLJ\ZS=)@bF>dASGA#E;;gb>\T9TM6J8RaA\<<I<Mf8,>VBH6NaR^Q+WUS(
CY+(;^NV;DY-GR[TG3Y5G_O2QTg]Bfd\b:JDM8Zb27#Y.B4Y+P]YBJaE0CU\X62N
UF16D[a^LEe,KR=fR0X+=SJ3#>FJ?6@ZG2P1cGa[XBJgL[6H:/R=_gfTNf>A>0,+
5TZ)+A7M6V.BR7fcbQ4QF]^5/K-V-@0g7,BY9MG]LVY0d9B9WC9D)VY9>IY_,_T9
&Z-W:Ja:,ca\HYeA@g;;[aB9d-O11ES45gPD9_=J943PK0\bb<S1#7DOROaQ[1d3
HeF<T6OcZN+F>I)C?).E<8J]#3Dc)F_\O@Ab(Pd\S7\HK:,QD\IM20U^])Sc?dI:
d,=P&D+&;+<M#Y^EB>:PM+=VW,N97R0X>T/MA<7_.cNVeWY+aeB9f;2H3[NG.aH^
g^=M(FXbL)Z_/#JP;MJL<U7M5F<Z6)\2/dP&:d7T^)M^3P4RAgD:ScPP+GZOaGMB
<N<:f_H?,Q4<IXNG)A=EMQ<@ECJ0GJB85CUd4B:JdeDCaHVTUSf8PM3\@4AfVCPg
N<>1J3X)(C,PC.(d9@7Dc<,7RGH7R>/WQRES=TF\J:1b9Oa=AOM8dHQO36>UYU=K
.K:J1>GRFaRB,.VVLF<Q81d:XL1Z,OFW;7d2B7TVaa(9:\UbP42@[,CCFA9bac55
&PF_:JMFFRF<<>GS::G:O,?^eBJ:FHgd[\A8]X@Z>JI?>2V8WgX-.gQe^NC.ZC9G
Dea]<OIM\2=G.SNQ[=g=H2Z7/f3]Y@7Z<THG8Q7^9;1L7@<7(RT4MQPQU9+EE1\4
c1?U6gVc\gPP7T)GV/G(@RG,_Zg3W+&Dab<e/aM#L9VF;-QQBWO<_ZA66J&0-7#E
9#1IdUEc@cNF8eG2PSIe+4213a+J1&<GJ--=5#[7=53:gT\U[1DaJY2eY#)?6f4Z
,9K7_:[#K@X:JBbF.[6fI0?GBg&2.>f]KG&[.[PN9N/CPXM/8)45C5Q&Qb/\UIXY
eV7)4\:VP,\YFX[]Z]9-^:4QHf]2-0O,#0#<:(/ag4Xf(J+[B6SU6)/UJL5BEcI-
P0^E6@8VV6[Af8L//cO=VDBN.+g&)]TLE-faf00T4W+^85L\_:]&)^<H>6SdJ-NO
IJ8ZeJ0;+aGO4)(235>.ZCAUKAQC0A6B2N;>]dK<dJc-b^4Z1]WeM-_.7f2Uc/DK
9@LS?.K-UX+Z3@;W[3^AeK0W&WHK5aBOHNIPJX22BY9?OB^4-7/Oc=Q0YN,aXF+M
P-(5O\FQe;c-@<#^eNCf?[8f<Kf+2R>S53d_^Zg9+5).X@7(b-C[]D@,;[5Z.):.
>ON\-_YcHdf&6DD6ER?1FFa=ZDW0OI?LT)Q\U>;_.W0e6Vb1Ab,:HR3?8c<K=78e
Ed5>a[1Hb=PWDO?f;X07^b[GSZadRR&1<>Y3->37+KbO/WZ#23(:S]4/.23Y+#7@
6V=/C;aaHSP/M[J4Ub6GIRI(53VL+gA&>?AD<DVFMWKJ4T#2L;<[.P>FNcd_>SXH
bA53GZ4FW].:]T0LB@THGJWUVAL2.9YU<ST.=PR@bV/;(\6\4-(DEcM_JKI2<G(7
:C[-7YY=^cJHV60HUZ;&M0:^6J9K5Rb#@VN-G<B:XWeO82Q9E:M@adU,4We#5Z@+
\3b^Y?3YD4JEZSTG3VGMA0@EED@];Iace0\GU,/]YdBH3QM:.MfE(_CVZF&bcQZD
U?(:IQUa8[K&E;df6P>(_QG:8?KK@&D(:QZeD@Va<5OF1MCHA;]\?WW\dZ:96W^[
T=\f#2e,];e;4VL9YI>3QME?(2YO1B6D84U&XaF1HU:,<0&F&#Z67;XeKb?G[OJd
@<,;S(6W7KWK;.FV]B7&FDKO\[+?5\\J:Z/J2OE7-5RYU^9O).I@I.6(_1YaVENK
bH)6aQ;]26KgNF1-F3&H7;#,e=U:ZBXV<F]/d=,@g^R<;c,ZUVV8V@,]M-:XQN[9
aK^:5TE&/U<.3J4:#B_X/V8&>M@&[XMG^bH&,5<Eg_#cY8TEKcH8Y+H+V+_bTN6Y
3=C0V\D8Z)UN/.]/b.KH5<LJSP3MCO8U6T+C9=F6F;6>\<>1[NZ>/IQ4+D0.gN8+
3M#cJ+_+F<=4UTT1]N9KZR6<M/LXFNBYAc64E/S23R)OX2G+Z-Z@4[9)]Rc&d62M
9Z.T#;LLdDg8/NZ7[E3SH?,6COIZA#SS&BAP,gCBXNgaKcRT+V1H(D[G>Aae1@>5
0B@4Mdb37[;&&\CI;gY+BJ+VX@U9N\b\+2f^PCVCTIUaG_W;6ZKCGV3JQ@]@4,TV
W#^B/e5A,VMAa#&NJc;98_-ST;e4FU@&K0#UB5[U4g@fOd5YHL&CK3AJ/BW,bAXg
@AG0dDa7<[N9ZESdWF;>gD9<<6:.]JKOe,g>=d8a=7[Ac>#FP&=\L0V0ZbK:);Fe
)9PYAH3BJ[/#2bPIdXM3.:dYeVTY?_,bIbCE>-8]P+ME2C=IAB&f<Ne]J[<0Ma3U
X?6bVcUZ#08W@-<:)RO7.Bb6_P09&RXPGWCC3HQM8FQdd+H<R1c]aF?DK8Je@)?a
LK.=bY-PTYO=<T(&e1B-NeJSC@<LcK]+<18c66TWg4U.DNZ1YQI3:gN\H6WJVHE?
NB)9V;J#2=@&7MLdFU-GH22KRP.(b;&eN>O>=@a&AI[,1ef6X;&S?,:W;VSMAPbW
[TI);JG(I:<7,YA@c[cY_LAGP\;^&2]W.1E,R_X)b#eXHbC6#B(FB<6c=?6J#CH+
1\9#=_U[b[(:B2YdO6.;bB<LL6UW39fDGS<gPT5eND1DZ)=^9T#UU5?(>F>A@C3J
E?ba#dRS0Bb8S\F)g->_,/:7W,3<<MN_;e:F5BC<9&T71#,<2-5MBUO[\,4NYKb3
+:U,=_bg\YY/)C)I\NHQK<)?1IR]Z2.0_4XPJfX5U(O\RA[H6BAB7db]^SbFR13A
e5G&OfV);P>fC(8#=]X#OY\=7H<P(W^G(c_(::20fHT+aJYQ0S:&gLUf2M9XdPP3
<K5ef7g7AJ@()P4>?+3BZLf7IV\Se>UaR\[J9d<JLZX\/eRLR-VA\485EW[7@RYH
OOEMP;>SB;Z;&@(aM_I2=EIG->I[5C?bO5-IU_.A#bbg5J/EL.W>_&.E)EKH4&>b
U^dcJ>)5753<XF+P1KK@6).6<@Ba2B2^<,?d5D3[DJDf8L+(Ig?K-2?YVWgL)QN+
7Kg;c;3UASc41PeF\5LRQWeG:fXDU6B\WZ3O,TWbRSf0-[:3Kf]&J_T-ga<^]1[H
:e:>;QD8c.d+SP9J5Vg=>8SZMAJWPS8LC&9?>VH.aPC2:(^L&FbfeES=^CQS(gR#
DLB2YR_TCdTdZ@39Pc-?<XLY(ZHeQ<XbQ5]V5A?F#6c?dO3\0V5<G[7-CFNJG@Nb
HB2=8e(TX4B]>.R(a\8ODf)^1L/;g?532-ZX5^H6RY82WD_T(.H1[N,XQbTa(UJN
(c,=Q)P:>AL]C9M13DVQ<Z\F)c#]Y9#cQa+V]I&(>75<f0>EWEW7]Z=ELTJc)Kbc
8=CCE)+_WK\H)5;A?V&Q<f26FV/6R0>dKPc3[ODA/.>ND,2G]8FV5dB-#106\c=,
fBWUcI2MMG<,L?-]D5/UTgXDd1TCN7K-P1IN)@<;6KEM;ARFSA?;1QNZ/9#N9:RY
DGMYHfRf95+bBFg]>HR)O8-a#aAWa^g=8W<dPLP;f9;V1[J6;a[aK..55\_H\/O-
8F+Kc+;&f^+VM=\I?NHYAUc0(Df(YOe396IAeeXZG+g0d^[^V2Q<H6P_1]E^B4a[
;[b)Sf_V2[(b)fGd.NYUU=IP#1\fKMVgIbd8>1-]J>M:.YM;V6^@9+<HA9G93M<O
M(aLOLV_X6fCHU>CS.UE?0IEe[K-)(JVPQ3Jc?280AM;^,_>_1Egd5d5R9d2(</<
3[+N\)#-d86fA86d(gP_9fc5A;_V3?\VFU]F&L-,X\\WJ,P2B4^1R5e:</GD[N#e
-64NSS5B-4+LNZS&>(ZfAZ_)&/[X^d+>_4\4b;>8W-]ENeB;B-28,#;)LB9ag]S-
MSQ[I1f9,E#2ef.@V7cI=10I^]a&;fd&3DZO)DZKPbL/Q,F\<f;L2-2D1CJSZ?ND
NFDW,3Mc<Z^FREa)a#_-b^[6KBgD_+cNJd[7geP)5e8.DTANMe]#3<7<QZd(>AQD
cd,XCEE.E1]N;V]\J,PbM?H/]IMIN1J/L0XR(_g@C5d7&@C;WO>BMHWG3Y5PS0Qb
WT.(#H9I-L[WcBd+J\HAFOP;>OU:-4(_9G:C,[,F3^H/N&,G.N=@bJN])E2EaWa)
C:<S=]W8EF(/WVTWUb1QbO)(.WISIVHPaS+-U)20He3JL[7/WV(7A/TX4\]TGKLZ
2FC<&TeA&HaA1KgY#VR6gHYXZN6DBbFX1?ZaT()_A5Q5deS8IZD.f#53RN^dHMdd
<=GC#aa#\Q)\,T\,gC[8dVVX]XVU,#>S.Yb23#.WID5&,-8P+,.HAV^]<29=J#P<
)4fca>&-\8IS_c8#e#UeJ./:eHK5g+<cU+/f<ZWGB)<<LD)>B865D4HK.<XYKaaO
?-]ZF-eFIcZL0[L>RHf^M=(@&6&HGQc:+V5e3aQ4.2.)XNgZ,Y.<.O/LXbeE^LBL
A#TR;<eO_\CD/)9(\OR8&3]VaLBOWZW^<SfPY-Z<c]G)#O_gT2L?ZR0\JEP]M(D(
1d#E_0WF+:UY]3Hd/;R=1F+(OO0^(LOeK^==:afWMWW#ZG\fcMD64GBLOb314U,<
@G8TbARG1.Gf\K>I@3^9H2d52W^JS02QNZ51_SXHA0Q6C#UQ:W7I@5AOMZ-d&)@?
LGS4#OA2K?G;^ERY1@cY1A42g3C5?6KfP3>.G29(OYFG(T&,_Y+ARIYU5K3L?>@g
b0P9TEQ6P1B=&GO],Q16?J:U\IN82<ef(SfR_]a6[NbeLJQH1&BVFQA.1d9.H\fO
P8.?,KFc,HCOeA_^:>Q/;.]DD;Q6.L:<0E.PZ^Tge6U)[VQ<[4c\C;6@W/)^GLS/
d@U5.:Q&H?d<Y?)4,LF5T0\2P-M7ZF.B>(7;e8YC5:Z4cG=;D@SVCb<P2/4K?P;G
ReF<_9VY(-Z:gV&31.C>YT9ceW^JS<E:UI@R>S-.:Cd_Q7PH5#db^CR.CJTLQ2?Z
3^e8ALd(/25RT>]CaLFfDY#>2AL.7]g=;U&E?@Z7I6g-#N6B3X&\PXe++b6NYA2Z
OROS+Vcf)gTdH7Hg:D.F,3(LdY/9AgX1KeDKIY8W@e.#bNMcSRW[)^Aa+Z=7\Y>4
YP^BU4ZNEa7?+G2cdZE&ALb<bHYWI#XA6.\VT>J-1g7WF>2_(9WH[@RN;;KKRU=+
g?C?O@35]4.,Y/JR1KPB6:_AV^]Z.P@=\T..XC4d.V5AMdQAX>I3Ab1LBZWQIa12
L=JZQ54K19c&T?N_/T[>/<(=>4[a,0\7ABeMHC5FT2.HWR62XgbM>.Z/_GQ_]24^
7[@,>QB,b)b-KI4aLDLMgd4H7S-50>_YBS/K9DPJ4[8,6[C/N>OgF=(K.7&(4-^+
MHK5^I\L0MbUeL92d9egTLc@9Y-R4P0T:EOB/6V;WHWYGUJS]99;=AT00-LLPLED
DRLc5U^aT[5c.e;Z?cc;IS\JJ^5D,E?\9/6N57U(=b/Q?>SIU-[J/YY?HdKLB;Eb
de)eMU5SL+ZdX19VI)2/dO6S;b4HV.L?R1<-e+IcZW+)a?>:6G?^6PRX19\XC(84
&cBcdUJ05\H[a7bY_\I[K._<NB@X62CM]Z:#I).2bc9=AC\FOW9:40JPd=-Y/>:E
?Q,aSe+D1(UQ&fX+K,?B9X7]TY18H(0_MV7+4/=@CYMNUQ29+1d.cHH\ER[O9&/c
?f/1?71<d<T@-M@e>HHL4G_.E;aR6g=L#J0+<B=9LVcZL,dZ1dO4a[/L8d:fDK--
76>C:D)-;C9=U>Ab(c:,HVIf[8<0I2B&6[ILf>gS<WD]9Ebg@;ZI;&YCW[Ne)PMg
gSe_TDbSR=>DP.]HL>[@-RH+>cZdI0b8dD2?<UXYR<G[V4<(8aGDV]G&+fS?2/RD
V](Y)?N;1;(M(XVY\1A22S-;I5GJ((EOJ4U>Z4CC+PYFbNa0YHdPMVIK31R&RA)d
8S<(J36FbHC29+g70D_>-TF3Mffa:MMf&WIXYb+bK+.67H:39XG&[Zb#g0FE<\?W
e1>C6VeZN_:#:/9W@RGR^[8#gTB[;,g?)a3&[<FgCYLSH/d31)F^P=dX^^@_H#0D
5B=<[7?Q-\HGPCKJ..3UTg+5INJd^4#X>K8D.WG#@SGG(7aBKJ=G-YKMW08J?cPf
)V<MGea,.aIE2f,O1E]b5SWAd>#)@ND]-HE\gWF<WK19b(?S_@R8&3TU\,]f&C<X
HN;Se^)BRG7+A@fe>:1__R6CV^e3@TI],84,K?3\S;7=B9W]_8[DB)ESLfBKCKI)
CM3e7<e/a-,&ENEIT)5?7c-Xc_f&eC1MQ:5#V>-Cd:/Pf@dA1F<_a,MLO1Z-<2Xf
98R]N)PbDGB@H5g>Q#3aNb/]>9eV0ZQ(0c2=M7:>61GS[7,#:W_P&g0XR&E8-b&1
5<6SOF@YR1(/fW?:BY<?UCHS?)?_(D_,7=5L<63efd3CSH?K5Ue-]UfR9aUNaU2/
4F1b;#aUILg^d17(P>F>g:]S[G38b8&MIVgZ\<&SOIR4N#g-V@@H;&F<=[Nf)YB)
+I<:DZZV:D#/Q:A\9Q5ceB)F)3_@Lc2#_4@I:JabMFQ9DdT,Q?[TC(/XW<U[(Cg&
]5I+R6JQOE,2c1H2@YBKSJN5W?ROWU3^^ECC\Q466gV_UKcK:VI?D&\,FFHfLPUg
T]:.&/-1XM+8V=._VSUK:P(P:(6B)eNg7]I>B.XR6-Y,&U5I#;33KSc^c_R+:>K7
(2d]H_<S=PU9ZM[1bd2M^ecegM1M5WH&P/@I_e_9+g&g[91&#:/5NIK^NS\3c>DC
OYCMXB:P=N0_3KU?Y;_D\8@O,gP#MB.BP^?4J_C=aAg9MW5ZO\KO5>&A-6[A(6U6
SA=#RXGQ4?g^;WggIVDXZ6ZK?F6R=CR(bbaP:M<TWa4D_]f8\E8Ta06U/V>Ka<)R
8=:#0RL;]\SJLa8YH30e?CMH(VWZd8E/+D_1L-2BT.,0&Z.R:=VbD:^a<H0Q\P]3
HeK:>E@bB(6AG5WMY)+WcIAPGD#R^]N+WHX9D+Sc21=VJ,e+g_7d66##F6+Q1(M&
_OY7e7;W>E#cbJV(3KT8Q1Q:N#bLA#6>J+CM-/&LI5[X2-#c^J7fZM8cE?fNfN72
BOPM;&;,]cfQ)=XL:/E;2C@A&.S0V[[SY8Id-Pe=LP]Ec^RgJ]22<7XF?ScU+\e3
F8L)<LEH,WDa;25]J==&9,71(e2<>,NZ28)8<1?Q_d2^/2^^T+L+[a>_+^dQ6W][
,R#PgY^cXG\[FUY(CEb]c]O&@?Y.E)HCa67,O@bFQ=dHN[bJ9:#E8.=3ce7O0Ib]
GF2>N^LJKY.d=)+8g-)T\KZ4AC6<3>;ME4BA4A_a_#GH9bGP1#(LYC_5fc6UH?^:
[)#,&:G0OV6(e?>b\+TH=)_<H)+e.)TU3X7@a)Q]>,/+dHHD5c(+2)3(W_=A73ZK
)eQ/8H>2);MEJ0K)-3<\4YLgf;]T#[<Wd3SB#T=CJ,JX>20c_3U=dP8@V/PcSP:T
g:D/#FfO<#/_/R#-ZUNXZfgf2M&69_?VT)FFT]T3W.DSG/OVgY8FVGQ<ZfBY@<I-
a08\;76gZRBeE)I(]M0GT#D&X2C.)=G6H.\.OJ/(7Z_9)>gZ4+S:EDW_>bgg.<Pf
O<<,ML,A#O#-bJ_-Zf.8O5cKXUE<bF@dT^UWV=JM@2XXN8X(,Dc0fD[G4LME>/AF
15ca6N@XH0Ac7WHVNb0dG5Fc9)8QaO_K[F+f04S29/,A@C+Q03##T#cRZYe1]44e
L.447g^KP6LdLZV>9#,]16a6c>Y(-6#W<87?Nfb)M9HCZ3E8LLc&Hc\LKR#=Tf:=
9_\N^I8?QQ4+>)Ff&L/B]M1@^5[]S8,.e/G1T6X5E]L=P\64HRdS^0&NDK,6DHIe
A^Q_>REU6R&?\9^#]DWRSS47)RPUU,&V8NZ19;A@R@K7P=>@I/QD4(QTPI6F+SLC
8eR0e[G.?L\F:#1=d93dZ7&-8MFCJf=aBWFU85ZQ>0QDf;+-UbF-Vebg#.21XHNU
3^c&<GLaEH=62dQ)8,NW#I0]d#J/Kb44baNR;=_/I);G^OA=U?JgNNAS?)D1^AN_
E0e,>.Tcd0S;)-.f:=>0AHH[IO:fe_Y.Ac24P7]/6@9\ZN5&I_Yg5f1-3#E-HEQV
ZUCN),B]]GJ\,0PU]AY)3#:e9XC=gILcA1U^Be4d]9ML7SfScWH_2#aFFH+f=Dg/
1C/Q\J=PNX&:G6d;I_\CFJX&P?+WHQceN;=G+K(c&]JSbMX4T[NC-HX46Ac[MDWX
7fO)&G?0<=.c1,a^D2[5b+g7C3eDcK8@<V0.d/M2YB>__G1X7<CC672_,QN+_Y<L
U#0+-L^a,E#KJeF0=D)M680V#>271cIc/?GU]IZ=Va.3@OM;1ZH.66GC6<&D_VVU
0H6:R0Ybc;HF1SfIDB][^)O<;)ZO3?bD:f#9CHZ=7;:?,a1I1FT95__36fcAd7G?
8E(=JLPHbLWG<JJ?_/X)Z+A8]T)=IZ6TB?JVJY(/d),;;)[)&U2;VD>37XTLN1:;
P40IeYO=RT8D=0U@gF;ceK.BGDVB=I>SN[4U_1d79-CEf]ea^,\Z)d@0C7DK+HO[
+CM^Ed>f@3D:&U4-QHAX44=Ta0MI_R;;c<8D^61\D0=_S(;>EA2]#,TdM\R<.@-&
\b]gH+_RgVV:f+S53Xc-@/]KLLUTH/deaOGgN0L11_aST)A9HNT/#c33MA;Cd_T8
CY[=e1;c3c?O(5aeA>1UNfEJQVS.b5LZJG6>F:#OFV_EHBC^8g]/C9<X7A;[[J7]
^.DY-0Ga[BX8MFV2/cDL.>@T@Z3P@d\+JcX/<+CSbX6dKQ&fMacXOc2a9U1=:a;c
0aGfJ9MNPAad^G>HL-8g+P/^D^E-,C2)#;Q6552ZI92@8dVbN[>PJP&2.=XD&<L0
SJd8IB<HWaX1,AO\MVQ3a>X;+.+8&@6_D<>2<BHSUa\81&BQJ]2P:Q56Se.?SLTW
B#9Z<;E0.R,OSOP=f@,_[O>F?;gV@+fE+E?YMO7FAJ1O-&YYO7PKLITbS/#d#ZSR
YGQ(]618V>/O4@;UQ&FXY/Q^E-X9>CU?/DTf11_SA#05@fM5\>3>d<X(SZfU[Pa0
APJBc0UI)1;:/Gc1][F@b7::YfC3U(BcIL^IR]1+1C_A=a]E\?THI+/)Oeff4c]Y
=>\9ZM#eM50LG_5^d<AOA,8cGMLIP=&I=5LXZGg-WGNX59TAXDBT&(gAAM#bAef1
EZ&A]>]0cEPKLI#g&2de698Hb7[4\gL(2?Q[Ug,A-1BCJ+Y1,-N5OaRBTKR?c:,:
UaA+[^MN@.F62)W.:b7aLIH?_gZ@,@]JeTH+1HTG5@8F]ZF?/W[Y@&3@P##E23F>
Fb:(LQ8(A#>7/^(3WT1FE[/fc<SO_.NTCOb8_d/Ye,MR=5QJ5W;9\cRd_a^JT#5U
5WF35K62DRa#A#NT/UUa_^<a&QNF=CM:.a-+?53S^]>^YG2^];4TX3.7[FQ\<8PI
)[D9QcA\I^1XHB6U;2/f/JXH2gQC+bbT\+029M@8ENO\>)P_9RR4U^=EC+Y0^41/
D[]?&,,QCd.,B9:=UO-WUH85]CO<:+),:EN+GQ7F6_A8H>1I[I_^dQPeg)^9)5LX
<5W6a9S,f57DUF/Ac1fI6_E)?c43DYFIL<)W^RE+[bbSV>D797PFJFf#B_AJCUL2
MH)>]5\eU9V+\1:-]-V:=0/a8\^=ZCV]#1aRQX<,N34<AK.b0NV_3?DU.2<F9GJ[
LB-&UF0bV8PTCW19ETH&aA+<[D+ZaI1+LO3#2S8X17,<3Pe_f9Y5_]A6?F?<BJR&
N8(106R4&X^[7bMWJMZP(:BC5H(CX\)Z1V4[K6OI@TY<XU6ND#7F+HWVg2T.,2B)
FdM;S2=FDgRU9:H(F-bK=:b:ZNC.5NeLg8S:RR,f6>^&5GJe>B_f493J70Q]:3(U
,]M02ZHDDKf=4^e-)e4/67ec6VHE9(^?-=+9,7S7Hb5Y08TI,\O3QRYJT,29^ZJ2
2?ggQ/c9JZ)=LDaL.PM,:b=5e#7[D6S7,\6NX:-[b?@QgFeW@ae/G<b3-@fPX9XS
0=\PcQI=f-)(+(QE[WgE]]J77WY-EN>&80LLN115M,D(Z8]2B@-\BB;_9+=F)_R=
\O[]a3?)_GI\>4+K7?b<1:-;]TM8FC3:PZJ/]4.>V@C@RQ[C.V#aM_&CE@495TT7
.TO?[0NSF4Mcc8SYYag;a78H[KeBGXQK9EQaa01_F1N-fM:F]KT0d8(d)O9S4R3>
\#,aSM@?;UZIGLG>a?[W#(Y]BWebYcM]O#cXZdO7c8D57W8@C.]Z6J:LBeAB82:O
]16XOVGPIB6YV&?Na,WNAR1IF_7GJT<J(_KX5I.(b@]R]Z4LA1#[WXI<FfR][gSE
e<L/=XRW8e,FR@=W:>LQ0(0,Eg;;/=NK&N?/XaW1L:(/SccE(S:RUg@2(Y[a.MZM
.N<VGVUF(].F/$
`endprotected


`endif // GUARD_SVT_DEBUG_OPTS_SV
