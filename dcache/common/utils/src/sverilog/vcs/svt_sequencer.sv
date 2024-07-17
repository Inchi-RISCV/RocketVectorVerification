//=======================================================================
// COPYRIGHT (C) 2010-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_SEQUENCER_SV
`define GUARD_SVT_SEQUENCER_SV

/**
 Macro used to implement a sequencer for the supplied transaction.
 */
`define SVT_SEQUENCER_DECL(ITEM, CFG_TYPE) \
/** \
 * This class is Sequencer that provides stimulus for the \
 * #ITEM``_driver class. The #ITEM``_agent class is responsible \
 * for connecting this `SVT_XVM(sequencer) to the driver if the agent is configured as \
 * `SVT_XVM_UC(ACTIVE). \
 */ \
class ITEM``_sequencer extends svt_sequencer#(ITEM); \
 \
  /** @cond PRIVATE */ \
  /** Configuration object for this sequencer. */ \
  local CFG_TYPE cfg; \
  /** @endcond */ \
 \
`ifdef SVT_UVM_TECHNOLOGY \
  `uvm_component_utils(ITEM``_sequencer) \
`else \
  `ovm_sequencer_utils(ITEM``_sequencer) \
`endif \
 \
  /** \
   * CONSTRUCTOR: Create a new agent instance \
   *  \
   * @param name The name of this instance.  Used to construct the hierarchy. \
   *  \
   * @param parent The component that contains this intance.  Used to construct \
   * the hierarchy. \
   */ \
  extern function new (string name = `SVT_DATA_UTIL_ARG_TO_STRING(ITEM``_sequencer), `SVT_XVM(component) parent = null); \
 \
  /** Build phase */ \
`ifdef SVT_UVM_TECHNOLOGY \
  extern virtual function void build_phase(uvm_phase phase); \
`else \
  extern virtual function void build(); \
`endif \
 \
  /** \
   * Updates the sequencer's configuration with data from the supplied object. \
   * NOTE: \
   * This operation is different than the reconfigure() methods for svt_driver and \
   * svt_monitor classes.  This method sets a reference to the original \
   * rather than making a copy. \
   */ \
  extern virtual function void reconfigure(svt_configuration cfg); \
 \
  /** \
   * Returns a reference of the sequencer's configuration object. \
   * NOTE: \
   * This operation is different than the get_cfg() methods for svt_driver and \
   * svt_monitor classes.  This method returns a reference to the configuration \
   * rather than a copy. \
   */ \
  extern virtual function void get_cfg(ref svt_configuration cfg); \
 \
endclass

/**
 * Base macro used to implement a sequencer for the supplied transaction.
 * This macro should be called from an encrypted portion of the extended file,
 * and only if the client needs to provide a 'string' suite name. Clients should
 * normally use the SVT_SEQUENCER_IMP macro instead.
 */
`define SVT_SEQUENCER_IMP_BASE(ITEM, SUITE_STRING, CFG_TYPE) \
 function ITEM``_sequencer::new(string name = `SVT_DATA_UTIL_ARG_TO_STRING(ITEM``_sequencer), `SVT_XVM(component) parent = null); \
   super.new(name, parent, SUITE_STRING); \
 endfunction: new \
 \
`ifdef SVT_UVM_TECHNOLOGY \
function void ITEM``_sequencer::build_phase(uvm_phase phase); \
  string method_name = "build_phase"; \
  super.build_phase(phase); \
`elsif SVT_OVM_TECHNOLOGY \
function void ITEM``_sequencer::build(); \
  string method_name = "build"; \
  super.build(); \
`endif \
  begin \
    if (cfg == null) begin \
      if (svt_config_object_db#(CFG_TYPE)::get(this, "", "cfg", cfg) && (cfg != null)) begin \
        /* If we got it from the config_db, then make a copy of it for use with the internally generated objects */ \
        if(!($cast(this.cfg, cfg.clone()))) begin \
          `svt_fatal(method_name, $sformatf("Failed when attempting to cast '%0s'", `SVT_DATA_UTIL_ARG_TO_STRING(CFG_TYPE))); \
        end \
      end else begin \
        `svt_fatal(method_name, $sformatf("'cfg' is null. An '%0s' object or derivative object must be set using the configuration infrastructure or via reconfigure.", \
                                       `SVT_DATA_UTIL_ARG_TO_STRING(CFG_TYPE))); \
      end \
    end \
  end \
endfunction \
 \
function void ITEM``_sequencer::reconfigure(svt_configuration cfg); \
  if (!$cast(this.cfg, cfg)) begin \
    `svt_error("reconfigure", "Failed attempting to assign 'cfg' argument to sequencer 'cfg' field."); \
  end \
endfunction \
 \
function void ITEM``_sequencer::get_cfg(ref svt_configuration cfg); \
  cfg = this.cfg; \
endfunction

/**
 * Macro used to implement a sequencer for the supplied transaction.
 * This macro should be called from an encrypted portion of the extended file.
 */
`define SVT_SEQUENCER_IMP(ITEM, SUITE_NAME, CFG_TYPE) \
  `SVT_SEQUENCER_IMP_BASE(ITEM, `SVT_DATA_UTIL_ARG_TO_STRING(SUITE_NAME), CFG_TYPE)

// =============================================================================
/**
 * This report catcher is provided to intercept and filter out the following message,
 * which is generated by UVM/OVM whenever a sequencer generates a sequence item and
 * exits but there is a subsequent put of a 'response' for the sequence.
 *
 *   "Dropping response for sequence <seq_id>, sequence not found.  Probable cause: sequence
 *    exited or has been killed"
 *
 * This message has resulted in a great deal of confusion on the part of SVT users, so
 * by default this message is removed for all svt_sequencer instances. It can be re-enabled
 * simply by setting the static data field, svt_configuration::enable_dropping_response_message,
 * to '1'. This will enable the message across all svt_sequencer instances.
 */
class svt_dropping_response_report_catcher extends svt_report_catcher;

  function new(string name="svt_dropping_response_report_catcher");
    super.new(name);
  endfunction

  function action_e catch();
    if (!svt_configuration::enable_dropping_response_message) begin
`ifdef SVT_UVM_TECHNOLOGY
      // NOTE: In UVM wildcard is '.*' and match is negative...
      if (!uvm_re_match("Dropping response for sequence .*, sequence not found.  Probable cause: sequence exited or has been killed", get_message())) begin
`else
      // NOTE: In OVM wildcard is '*' and match is positive...
      if (ovm_is_match("Dropping response for sequence *, sequence not found.  Probable cause: sequence exited or has been killed", get_message())) begin
`endif
        set_action(`SVT_XVM_UC(NO_ACTION));
      end
    end

    return THROW;
  endfunction

endclass: svt_dropping_response_report_catcher

// =============================================================================
/**
 * Base class for all SVT model sequencers. As functionality commonly needed for
 * sequencers for SVT models is defined, it will be implemented (or at least
 * prototyped) in this class.
 */
virtual class svt_sequencer #(type REQ=`SVT_XVM(sequence_item),
                              type RSP=REQ) extends `SVT_XVM(sequencer)#(REQ, RSP);

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /**
   * A flag that enables automatic objection management.  If this is set to 1 in
   * an extended sequencer class then an objection will be raised when the
   * Run phase is started and dropped when the Run phase is ended.
   * It can be set explicitly or via a bit-type configuration entry on the
   * sequencer named "manage_objection".
   *
   * If the VIP or testbench provides an override value of '0' then this setting
   * will also be propagated to the contained svt_sequence sequences via the
   * configuration.
   */
  bit manage_objection = 1;

  /** SVT message macros route messages through this reference */
  `SVT_XVM(report_object) reporter = this;

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  /** 
   * Flag that indicates the driver has entered the run() phase.
   */
  protected bit is_running;

`ifdef SVT_OVM_TECHNOLOGY
  /**
   * Objection for the current SVT run-time phase
   */
   ovm_objection current_phase_objection;
`endif
   
  /** UVM/OVM report catcher used to filter the 'Dropping response...sequence not found' message. */
  static protected svt_dropping_response_report_catcher dropping_response_catcher;

//svt_vcs_lic_vip_protect
`protected
+SG>5O:YAJb^)QL)E6&0A6O=cB6,NdDMS0M0c71T4D4e.F)UYPK]5(.A8H=C7OI&
Db8eIQY,e:KSS_8^B(XYA+T2XB#(^aeH;.,3NRJXP(<?2^fJ0S]fR&9/a],Z+/O/
<(I?,3LgKWW1U-dSb7QK6T#P)5/X9dD=MVU@+LF&&CAGT6DMHR9[P^9>B.0B&2bU
QG1.<?\DGZ>6aZca]PS\BG@.(ADg]d5T0HWKc9BJ9#E0D?WOXd/Na/YN,CB]G<;G
.2T327V;5cNKL\(9;)>,:@WZW_>L(d([f/Ve:Q?=L),_(LQBfUI2),;a;gDgEZ4X
-L.FKW(()V2#_2ZN</QQ,Y6W[(U600eg9.beZQV+]Y.7c4[-<&32L@<?QHU4Ef1g
==<J[EQ;?^AF^&#7N5@I41>1_^)J/H2>:-B,a6D^#.AR]FIU#936D7WQLTObgR7R
KUfGO;0:e/O>IGdE?Y-+>C?[GSY<PfZ(+NY/F1:SU=Y]WB8_?-MQA-@a_:@M_SK)
ZJ77?Z?0OMB-e,U4U3V1UKU(9.T7P;Y+\NCb18=-gPDC1gRT]D+)S9[^eaY6I:0V
c29M.9F-eObY<cDKKgPXg6\g0Y#?B&@]T\IGZ06gKVf+:MJEPd]:\21g]cIZ@T4_
<O7VgG0RbB0Gd83WHQ#;eG4W-T2DAQUKg_\11^f_IX=I/UEE3[JSXEfgY>I:d0T1
,_7SI]g4_?;MVW@&FMdK7B,,24HJcO/EZ(F4^(+D6@W=;)QUJ4Fb0bbYg/Z6D49WT$
`endprotected


`protected
E=1Y76EXA5/9/T6AO@Q>HfB?V_&\]TIb<.)6=IOWRJ=6#8V<24:3))YT].0=KE/U
5HYESX&5B5E.A9=@/f3JW\:7XeXB?5[=L,I,e#<9>dX/HV5fde3?KO9>b3HE1QV,
($
`endprotected


//svt_vcs_lic_vip_protect
`protected
?R8J+EeYCOZ8^V8^DFZAV/Kb2P(g?.UWRZ[_./8fA[UU3@4TYIeB1(bMI^A?b7Hb
7\c1G:NR4N.UbP@IaM_1].9a7T?<8>5L])g=UJf^:CZ1GD758>8=0K9JB14Mg0\3
XRUVLI#b;\)RB\CHfKd=AM(7JCYDRII,+<0U8_&#A?N+T7^C:7:EE6WQR+g=)aeM
P@6a7:-(7\/gd-SYDMR=/4,:#FHT^-FGV8H&<bQ95^KPcX&DG[F\bdE<IR9S(Q1@
>W#JZ?28H+6cN[g:2T-?La1cTCJPR_Pa+dd8)7(JQ_5ce4ODJQ-a?M?,+&aWc[8-
/BO@+:Hcbf/2:UGd0JNU2G4:3<0QDB)5U8T/H9V(C1S/IDO_B]O++XDKN[A\5FF9
ObI^=,C\4QC1GM#LKE<\UU1S1^]JTG<b;dX,K)\_aQ[_>G,+7;W1cTUV(Q99E+7K
2Y[(]74SCENg37dQ]WN:1EK70HfW/\:#Fc6F59TA].ABX?6XG6>AIB;G&Ug-<P=+
#<5c>SUO3Z;g-$
`endprotected


  /** Class name of the transaction that this channel is customized with */
  local string xact_type;

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new sequencer instance, passing the appropriate argument
   * values to the `SVT_XVM(sequencer) parent class.
   *
   * @param name Instance name
   * 
   * @param parent Handle to the hierarchical parent
   * 
   * @param suite_name Identifies the product suite to which the sequencer object belongs.
   */
  extern function new(string name, `SVT_XVM(component) parent, string suite_name = "");

  // ---------------------------------------------------------------------------
  /** Build phase */
`ifdef SVT_UVM_TECHNOLOGY
  extern virtual function void build_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern virtual function void build();
`endif

  // ---------------------------------------------------------------------------
  /** Run phase */
`ifdef SVT_UVM_TECHNOLOGY
  extern virtual task run_phase(uvm_phase phase);
`else
  extern virtual task run();
`endif

`ifdef SVT_OVM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  extern task m_run_phase_sequence(string name, svt_phase phase, bit sync = 1);
`endif

//svt_vcs_lic_vip_protect
`protected
-#)OQU423ZJAfV,P(U_T6P@=a51I8I1Db.g\IE6<e><e34U^#73\2(,S1#YJ<KAb
3LF/63TV6@f_5_5P;/,_0-Z^4NCba8&M]O9GC@g8QRTMJE3<KRO^<LF@F,g.?He2
[fS[.@J0NX+)^/_E/;6bDZP9MCZBL?PQ/Y]UafJeDUI1&:&SH)5aE9HR1S1Oe1JX
DS<eUT_2\OJe:NZ,;SF<4;IOA)C)?d_17IJ87gM[4:N,/;1J-\-b[@,Qb#Y0LWfF
E((1b;#M85JIbF102_;[LM2L)1bA?:BPSdOK=]9_If:NT6X_EL6D.1ba?JS,bI->
20:g[\#-\dL(GN93X9#fJASbQE<(6#?@/TAJ2)S:=X;4\L4/@ae/3E\/D9ad974W
WTHUb]3BSF@I^P4fG&?+B8X:BKSHX3e=C770H,c9T249H&Z@S/gQFDTY)&LZ_)=K
OTaJA3?1B?XJ<?R2b>/fJJ8XV2H<8P3dV_\O.(MKB#/^a0dUHN6R6>TYI$
`endprotected


  // ---------------------------------------------------------------------------
  /** Returns the model suite name associated with an object. */
  extern virtual function string get_suite_name();

`protected
UGfTX)<bDHe24QP@ZcgVT>65&f-J2L<NE73?RXUW>QDM5-Ne93+a&)C7+@?58-TD
Q?PI[>2:d7HT^RcU;0=++g=8973GIPGJQM+LR0-Qcbe@3b._fHL:<&F:Z;UP<,-F
0U(ICPVc3H\4HeWG/=X-[E=81$
`endprotected

  
  //----------------------------------------------------------------------------
  /**
   * Updates the sequencer's configuration with data from the supplied object.
   * This method always results in a call to change_dynamic_cfg(). If the sequencer
   * has not been started calling this method also results in a call to
   * change_static_cfg().
   */
  extern virtual function void reconfigure(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns a reference of the sequencer's configuration object.
   * NOTE:
   * This operation is different than the get_cfg() methods for svt_driver and
   * svt_monitor classes.  This method returns a reference to the configuration
   * rather than a copy.
   */
  extern virtual function void get_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the argument
   * into the configuration object stored in the sequencer. Used internally
   * by reconfigure; not to be called directly.
   */
  extern virtual protected function void change_static_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the argument
   * into the configuration object stored in the sequencer. Used internally
   * by reconfigure; not to be called directly.
   */
  extern virtual protected function void change_dynamic_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the configuration
   * object stored in the agent into the argument. If cfg is null,
   * creates config object of appropriate type. Used internally by get_cfg;
   * not to be called directly.
   */
  virtual protected function void get_static_cfg(ref svt_configuration cfg);
`ifdef SVT_MULTI_SIM_EMPTY_METHOD_FLAGGED_AS_UNIMP
    int dummy = 0;
`endif
  endfunction

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the configuration
   * object stored in the agent into the argument. If cfg is null,
   * creates configuration object of appropriate type. Used internally by get_cfg;
   * not to be called directly.
   */
  virtual protected function void get_dynamic_cfg(ref svt_configuration cfg);
`ifdef SVT_MULTI_SIM_EMPTY_METHOD_FLAGGED_AS_UNIMP
    int dummy = 0;
`endif
  endfunction

  //----------------------------------------------------------------------------
  /**
   * Expected to return a 1 if the supplied configuration object is of the correct
   * type for the sequencer. Extended classes implementing specific sequencers
   * will provide an extended version of this method and call it directly.
   */
  extern virtual protected function bit is_valid_cfg_type(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns the current setting of #is_running, indicating whether the sequencer has
   * been entered the run() phase.
   *
   * @return 1 indicates that the sequencer has been started, 0 indicates it has not.
   */
  extern virtual function bit get_is_running();

  //----------------------------------------------------------------------------
  /**
   * Finds the first sequencer that has a `SVT_XVM(agent) for its parent.
   * If p_sequencer parent is a `SVT_XVM(agent), returns that `SVT_XVM(agent). Otherwise
   * continues looking up the sequence's parent sequence chain looking for a
   * p_sequencer which has a `SVT_XVM(agent) as its parent.
   * @param seq The sequence that needs to find its agent.
   * @return The first agent found by looking through the parent sequence chain.
   */
  extern virtual function `SVT_XVM(agent) find_first_agent(`SVT_XVM(sequence_item) seq);

  //----------------------------------------------------------------------------
  /**
   * Implementation of port method declared in the `SVT_XVM(seq_item_pull_imp) class.
   * This method is extended in order to write sequence items to FSDB.
   * 
   * @param t Sequence item supplied by this sequencer
   */
  extern virtual task get_next_item (output REQ t);

  //----------------------------------------------------------------------------
  /**
   * Function looks up whether debug is enabled for this component. This mainly acts
   * as a front for svt_debug_opts, caching and reusing the information after the first
   * lookup.
   */
  extern virtual function bit get_is_debug_enabled();

endclass

// =============================================================================

`protected
cNH8#=8,MZ(f8W3S7G[7[ZG4:5=g;[=AQ)SWf6XCdQ1M(N8>,O89))c]eKAQ,[3/
W;3&\CSAAU.b5_XA.,D9EN0R?QG02;A/VO4.\<6C-6R0W5]VaA@[HS:2^<-.f+XR
),RA+GC(Q5MEY^[PM<5KQON;]T^3f3<-VRKKVgL4A;(dUL<HNZAH.]R(b)JWG0O:
86cAP;\U/ATUI@]]0TW3>(GDbf6dUJ1N?E#)bW83g9aWbE&HAK5HU5:b2&\GY(a[
YI+XPI1\=/@S>UXS,SADIQK26bH,cOW14KG0LLI)IMHO@/Z_#OYR8?#WX2Eb4U\S
^#XEK<TW1d1QT(?\@ZVYf[59]8O?a2?JTd:cddQTF.=.Y2T1[LA2#VBC/RfA=>-P
N\eTX4VZY1+@+UOeEAQ;=>d0gT+Mf(ZI4.0MAS?SA;NVP&3#e1;.gXEc+.e<B?19
^H4OZL77<?5)g?5:F-M?O+SG[G3]SZ<Tg\S&[&NddY.2G,WB)1@AF(2[1_A/4LeL
T:#29V?&L61I9VL##B:2g,ED]=bcfP2Y9U.;1_)<-T)O>bO_WO<b=_#NR^R<JI>.
a2^Me9OMdPC(_Se:&+._)bf\#=Id9DM>E^-8G_Sd5f_L0>&I@-0]33+RZT939^6Y
=22F_O2+,2HV8X\H6+:,BWf^[&,95,=?)>NY>JE&.;Y+-TcWS(/KERb,5<\bGOfQ
-/;U1fY])1KNfDP@+7Y>T]=VHAFFcT^4V=1]#]6_8.00CQ^]T-J_GEKb:8)L<OOA
:gd1Oc_JTGXJ@ZD[#AFZW(F.76eWfK4ML1;]F<ff/C(F]OCbM[UI#MBMa(VARJ@K
9E:(8[XDMeH?VR#CR>6[Nd7QKV4A.GMIO;X(K,=>D)9NC9<6)3,d?_;GQgO[^Wg>
5@cP8XXCK>.;M@GV\WC@J^;Q>(CB8SK+?&aTaS-:Y;/,A-f@K7;]EAaY8GRb;bC)
JO=4R,91FQcB96V,:F^Cb;64QYR(N2AXgSM1C@MWM>5SQQO1@M=0R.3:Q8bJO91T
_TZRIZf=6gLZ1Q6ZC6[+&AZ&PeX3WYMRG>PK&ZTXdK&>aPUb36ObZ[@M@1bPMPPe
TB&TGC05decX[Ka,8f6<W8)>#J+GL0N:FS\aXK#EdPYF7S7IWaICPIKac7b03D?X
JLE[,U.8+C0WfQW^+4M;\8g@0c46C:Q(1VVgW2EaB>Ig:VCMe9f0SQMRgV[Y/g[c
N9SOdbKBCD/\GS_>0Y_g;\5EUB\f/=H.D5Q9@e8>O>cUK(#-.?8W>6BHP=CZ/99]
FA6<T_6HG(Ne?.AEd9Pc25]A>f13/cLfcUL6Sd.ETJ=<^ODI,E=NPZ](W,6W.)&^
bNC6EU1Q3D),?)Tb3-3#ZfDJ3<PXY2T3f(9L;X-T#3NDb=.:S<TKGOPUS1+F1EQ\
@g;O1TYUWLF)B#XaU;K<R,LL0NDcDH\dg(5ePPccW-VUA-=^TgLLFPZ\DPUQ/RS1
Dg&;JL7a[cQDcVcA<6+B3RYB:,c;D;UbQ7bS3fRL,@AE-YSb4^E=[^=#57?O_K7b
1/(Le1#M6@bHNJ-_2)f68D7<K07;5ZE[<IJ0.AO7P;bD/Uc&_O.^GWE/?b>BcTXW
LM>#M@.c[@[Z3e^Y5V;5FCUeU>A+c95):IW.]9_DfQ;T[2<?D,7.FbTd[CF/D.4_
g,IdEG.]aB]aI5\[F;V6,9?X(3_#Gd&gIIJ)F(S8T1,MUPE1V;,W+@J9YE6N3DeV
HJ[@-E@EL)X(GZg+JX,^I4D<V\Z7dGD^?\.1c&O4.P+c=WB9NGUeSd59JG&bJ3<&
FNJ:1;XZJRcgF-VEMgCYd;K?a1e/>=3ZN,NJC&63&2QWH<cVfHP\@C-PY]K#;4Rg
GR]<F>M_D\N_Z]<@/2W2.bI+IAa^=a9>RS0<23NX+(dWff0cc,^B.>1DaZ9/cEO5
==VH4#Jd8?>?W9KL7H-d;IE#6GH.UD#-F&U]:0R?U9QKPV4=R8RZ3[SKg/])aXL&
)[<].I&g9D@.SG1L^\3/Pe^/P-TfM/&\f/?8SK1808MU9;/.BOZB9,#(KJC\\V-L
aV+APW>9;U#M?aK,F>CV0I[F;KBO=Qb-6PXU6]P778T).3L@]2TZA6=+FCYA0&5\
5BY:B15PZ,2ST?e;M47d:O[]6e_S7JE[EJgD4c<0OU0);a(GXH@8QY3>-2YUC;Wg
+)=E7-H4cQ.P7_4OJ+&JD,#5,B7SXF-BKP):#:;(D=?IDP9PY_]fAYfC[V<eU/eL
c2\T^ZVP5d2MWTK[2@2IL#M)Ga(388N#W8bGL9<d=-P[R>Wa\b(,O-(18NVQKQWN
,>AddNdU14^T&K#f+PK1&g>0\)M0K=F_#-V?0F\W05AQ_)UK?[XI;9QQ9GE4EM_Q
L5R0>.[b+S>4=.,U&6<WFggf]?M-6K5Eg@S58^=]AJ.-;BV4WG&AE6M9H-Q=:.:-
S1aT#OIY6KDVJS;#=/K#YQfFB//5\=:YZ8A3BAHRH;2M=_B_/.TF-]8=5[b?:RV0
Z[Bf4\AV#<ZIH2K_d(N;2G_0,YJ,PH_@dTG4[;GRTPFU)J>b1c73EAaPb-U##]KM
5OOAQO:5S99&;,:X0(366VWOX9K\]I\#VIL)F57B=N?4[N<7e,(.2GU)7L^?F#UT
+FIMBEFP;D2gJgV+?NdQEV89dA1KC=^TZY8(>997N@5cY[]Cg6N28EIb4?QYX>/K
A:FWAP>>H()IV8WLg^F=-<^X?O6._Z9fJITQ#b?LbTRQMG6B3I8#7]\,@>H:QC<_
KI2b,e;(<84c>1^2)9X&4;U3A(L6SAX/KQFL7&1>D=T(/W,=#fWPgE1bE1YPDRT[
agU#H1+Cf8QVN:8dJQ\KgRXd8H8^N\3GQPQMDQ>gRF8JO58gS.7a2M/=85>-;E^S
;d&3T2W/e/M-I6&bBT8.N+d<8fEOcbF&GKXT=/RL:(M>fg)T@D<Q,1FE,bfC1<R[
gScDdFR[;09Z,,e64((VC\\;;?d@A:>E0^=X+@ER&2LMP4RS1ZR0&V[[0gGEFLbM
.CP3/EP80@N_J;W7Z^VaFGB1ZNg>/\Fg1ODfUW,:=<1cgbU<a(?:P\4E6@cB7=UX
MTbe/N,0,4(UT]=SSZ1>K:b>;#CW_W.UEJ,[8#\d-U?a1<>bd<8P9E/UAa#(+c3B
d+<?8\4#0Q+fMOSb<UB-)Y5[KB)28DV\<JBTY\BG>[I[&a-W?c)K21F[=f77O6;(
VDRT?QIE<:8G9VNGc1<2A:H79E_4a+>_5/2V+YBfaUSc[NX#,AM(GH+:QY,f<D2e
5?P<07@L3?#\H05A^3^gF;0bUSM0Q#]L-+\KVMVY\=J]HZ3OMa],PZ<MSB08HY.^
@P#@<Xa>_&GIe_6fJfZ;SA,.41H]OI[N?R;]<V;5+VW@D)e<VbY^PU2ZIV(<?4N+
_FgCb87?02#(<EDEYA9X9#Ae91<fYMD?WgcfTI=88NB8F/dUZ6EcU<<G<YTfW?EW
R,I?RZQ<JL-FI--4gO^bEU@AG>A/S;3ORH>c&SAf?6P9-Sc;@L^F9P,SB2GQ</;P
FYN4Kd+GH?BBO__C7L>TaU:>T=-2IJ>+BSU&<FH5V@S0COe@3128G8H[\E.0Yc-P
XPJ^a7b^.:_#/V\6;3S68-A;C.Q:IUa\PF@/Pc6=T>F689GB=U8HY++QXJ@B-G[:
(6f&Gc/]=2a8R3,abB->L2/Zg-]MV0B0GeRUN2:G-1IF#)D7LafT#@A_P[4a4:ZY
61RX&HO2Yb<KOgRe4Q2ES\cXK;9E/Wb^E;G02[ZHJWIZ-JR-\4[E#MO_<T&^(ZXS
BO]WCG1A._U>FHR>YY(4:.;P\4CLSWe/V)2SJ=5<.];WC8LgN94#9J7SJ\[0N=K5
Sd)H_Y?cd04T9-H#KBBDdI4e?H+Q)=7QYX\U7b6c3Pa?#?8Y3(NB=]T>&-g)HQOO
--;QcK[MB2(DB7+J\e&bQ80g/FOYC[:/+G:AVg?;S9X?fgb,:I6H/\<LBd[9AQJ;
LFFKbZg6_e)]^0,F46a8fIZ/QW.9b):C6Z0,)/AOP>[(aM(I7.M3Y:CE>?dF8CER
&VR7+_,M(3aXR;UZcd<aX_aRJ5MF2])J>--0.bggRbM6Q^]1P2@M10&Z+F=^DOgG
QO_VLR^YQ..cU](OPCEO/b456bF6S?N-)8^eaFTOE=PdCRKNY?TM82^]g2U^OZ@W
fEKNU>D]@47:gd\(^7<DbRbc/cT\b,(4J1:.Q7POAXHFdJL5H2P5bBO,cNJCV?F1
:<CP;ac4BAH?d.a4^(#0K@G<4V=UM5_M;IaRA3XF-@L3>P_M,&JfJ^9:d<J@W2Ug
[]WHg(>HRHFUaX8IV5EXB.6\4.(LA61,>I0Ja(:YRDc#X/dFS#.24H-6f8.>;T[G
D9M<<QW7K+AEJ4:A,L2IJ?0&VYYZ[Ba2^M@C&#<P/=X+HfXgI63/<+PS2:LB2@N8
5:D,f9MUAM>cFV5eVC5^C?#M,&T#eKd7eSK_#3aOe88YY4XC1=E/:3ZEbf2,]GC8
VEM,6.UMBfEf4R_fU<feecH[[,DMK&N3=MHPVAc_7)>[cBbI9XS[+Ob(c(HdM<-[
9RXZQgGccCQ/IMbScNE-LB\\@JTOd=49fUf;-8A:fWBMDYdS6BBJ()8=)[g=U]aE
adZ/T2VaNF7/ED??A<S,?;CWNV-QB[?c=e<eeMbQMe@06]N>:P1df7HD[HO0S8?b
?#BdHWIgJHe.Z2>dP4^&FD.cPe6;B:)NTdYSc>NKK>S7eRE_HKV&^7&TE#/^&f;.
._4a(2EE8PU7Og=)b.)b;#,E&[I+I.GOB3_AP^I@O(3@J:QZDD9b]D^g;G4Z#&Ra
==@0T1J_A,N@P2fDFd8XNeBeVTab7ALJCS,4fR>g7JHBDGJ3P0+/-R(Z3UeT/)+_
)EJ6((CSY(JD^FI=UZ,&1JXF]_L0@1YW[dLa=IO?/D<P<58Y(Ree^dM&T^WKW^cW
WD(&U([:4#K:2.gDO[P2#:ZaJ^(X\9eK]@M+X:=#K;1^/^Ze1Ud(3H_WD_gaD0\K
a06#gB59Ya]ZZ]=ZU[WLJb.ANaJL<_g21?I4-[]EMOH?:e;:=@]B4bSSMeDgB(-e
Y9e07,?g,?4([=c:6^PDO=0;T-f/I7U,5;0\cKQ?[9;fdB#/R>cN[\U&A&>=7(+:
>,[))5Ce]YALE_8OAMPQe:HO/53;ZI2[Q7,QS]]N(ZU3^9UZ6U).dT(BcJUC(A/#
;NcERU](c8e+BJRWfPbg,2XHcJ&?.AOMQ;1=_][eJ9@V<Cadb@I19KJWW7K0N]<L
:EfKGSSOV^E4)g;^fUNT^LK[XB&7C[HW;Of1BTU8L3^Q2TE17[+U+;Z3)P\YV+^W
<TLWLf4?R]f&g;^9-?#E>bO3UF-,\ZfWKFB:K^_F/a.g#=6F6S0\RgK/_\AUg[8G
BD9(SRMe?Y-G+NEMP.e9DK;APY:=BdJ;Ef[[KK@GOGQ^]1/G93_7<Ic9^I.HF5TD
[#.#,-/_BAF4(fK<7.5<CN;-PAdaEG/8<-Hgf\&)CW@Bd?DCRIP)V>1aHOV:f9S5
2Jbf=H7dL?O7:dYPbKF.U5B8.d>dKC5<FV;+ZE2Y>&/Z192ULbW<a0aIQ=I/.\b-
7.@IX,;5DNfI^U#)bCX&c^EfeU?Jc@\;aCA);@)fFETCV)9IVEZX^JG-)17ES<.Y
)O\Y2CeKO[OKe;UGDP1;R.4A8Z,9T-^2A(MV)L2d63#_:/+C>#)GI<_.?[#Z\V3b
/0RHP1_@^21g)V]KcC)SYQY7F7?,M4_WAcd6<WE>4;PW@@N]A)ZN(V[Y]XYcUcf9
KTbR&[FHXAd.[gFRZ;^fB#f-TQ-P^>7UTF::EX@Q##0>F4@H5U&J=3_6=04<6V^:
9UO:_>g@EE5Yg047YP31g&PB+HD7fd9f_4AcgIG+Gff)PAM&Q)/,9bWYP#=-]<MZ
:8]aA:9UHS5HgF_6OHRYJY.:32bY1R,T/4#O,)3U;E\F\8WG?>b.R+U3Y-9=BD2Y
-9VPF;[XYF;)NI4M_S_[P1_1H+_CZV0,He,#S6C0+D7\^\Sdg(QX0QH+OSSgH=^>
5bSbXC@#5dP[K#Z\:FNW/@<Ve.P3E==97a[B/N=44-2I-@QDQg4JHTMC29f6bXAR
TLc^;C+6I]7<O/b<^RdYJ:3#4KI893bS8dd1PFJH6-]beQ+V4J)R>b9d:Ha&H6O8
+0(.Y7SSG=R]=)I>d=0B=V(KM+IO?:T(=f-I5b#2ZR9U(M&Z3MX5=_YK+SYQcR4E
&,4)>fJNIc?K,a>6UVS?S#-3K,0\)BUDP>+@>-0RIeIW<K23N+ZI@,:1K0M,()OG
9OP<[VCJUA_8&+E7EW65Rd,6a^2&.LZGHVTB(I00+7d_(@(fLdFGgHLMO9J6X?b7
QRXXYg6[Q2EKZ6/Uc^P6F4fLG=E5-<RU?@EMPC8UP6gTAa6LLUBNM(MT_?/.KA2E
4@<H1:-4c#4^@4Y6+Z]3FLO\DVRVPV:3BXJ8O(>564FE_K1(2:&f#<1c:&-ZQLTT
)SPE7+9L.ZG[,cR_93_>VP-84VF0N6D-K54Ofd4S9)Ja2_A6;OF<PL:D.:G<B#KR
&(CX)TVB7=gNSZY_(Y+8-(XREQ<_SR90X-].ITB\IPC8H?9#&D?<S2P\V172WP7M
9K_DNWW&:X128Lf/;A)LK<Z:Xe:]-REBI]L3PZS2eC52OfM(bH-QMf<FFQZ>IE>/
WF,2])27M+(&:<B.A,#OBFA--@82MXIR:7Yf=J?/8-Ka]f_YcPPdCf1M+2T^(PeL
T]KK;8:QW,5IeK[cK[IW(4_RCcYVFMG]7IVbO1+C];dPHT8,RD.BR;=92B_Q2eWL
L:C:A6U:Xe,E14S\bE=,));G6QS7<e#?G^PPbVaaL:GTD7F/S\8[05CS@TNB2#:5
X)D:IU9dc@&P-XAa7M:4,GY.#W\G0R.M1F#0Y/d6=;GJJ:A7Ea<>M\I1_5Y-8.XS
,>/:IO;bc.-N_D[:3U?c\(:^]c96OA--PS5P^^-Wa?UfMWG+?^:d@<@XdWZ+:<,d
IEJ06SNEYB7Z3YFAQ+9]YAF]^^0WS@[B.(V^NBg@HNVFR=CKCMcAO&dW)/>fe-^A
NFI)/)>;cN:dAd<S;U92KCV=V=ULSYJL<HS2K@?Q82b1<MWS37LHUO+UF:6HMb^L
MRASK5edgd-WJ&?ef2/?]OJ/#_fFZ<efM,_)<eCV[N,K#+:5e9?9ZA^/WS_L_:ZA
7_/b1;Hb4GU+b>QW+>=/g>5I,<W+0)8A@/MC6EJ\=WUA]1ae+5d<-]L;D?//@.OZ
AKf@?=9J4+^e&8XIH#0?e^ESb)bRS2[22KY,dF,&WaA5DS]7,1U>;_V:#KXS6Ocg
QMX_OT\?;:?dMVg+.(+PMSS.#R^EWV[8-B.]VacX?.&cSZ<5X[QQLU@c(UM(cSWe
>P51_](D[:bQ4:A&Z^R0P2[QXZ-)gV/c@Zd^((-M\3?#M.DMbaRJ@U/ENX+A5Q+]
Q#7a@#DdRR_b]D&PJ?1b_WAT>2F#KLXS6+^.-c\aL;,fT]SMCbLG?5bPUBRN+6@F
4NQLf,I2@c)&3,fc]TQUE3;/F8_:77AOT+GS^W8J=-NaBTJZE>;ZMGaYG6K/cBf>
NCIePIda1EY0903^\F(LVeCd?^=P9:e.2(/UT^U0-@UC>MWa>YaaRbL-AW9^J5Nf
+#NYLV7]S;9J&?7Y\g,_:EB_eM\/LPJ,Kf#UDTd&R[7cc76#\.U-O:3f,5e0IB;@
O+&X4_W;WRTV[J_JRK.O\3eQdFP\:.>MI^;IRJDCW]_53bQVTIW\;\=3E@[:RZ^L
]20_?))9)=9b?G+I;K\cG:.TW@4)0-X[g=&\b(J0<Z&KB(K7[[XT19I5A[1;D1,N
DEbCc=^B[:OL&G#63E@LaOD+f/,@B>g^J#-S61&-^]LZ/:PLS3;=(OO]WXZR5>CU
V+_BJ-PP_T?#PT@3BQ-@VU?Y#M(3[^E5TU\YV#3SN(ITeDT\;,/6TDaJ/SXTW=EZ
b.@2VF_;U>F5bX2N=D5.\HFI.UF_OK<Y,_R5C+CfYZSP[5;)B(@R85Z6\NYJ118I
--DggW8YOKIS0O:Q5]Y0S\[a8&.0C^gbG[;bZ-a@f9)]3)GLTH4g,;^A?ZK[.;@3
<)/_U\(Q)aA,ea(\]5ETJCSG1RB=;:M49(G7[d_g&gZSQPUBgg5:Bgc#F\&E6Z6F
&K?[(45@[d2F)E8NHgWG?I^Jg[K9IIM-(LZ2S(T,U<_NMF[2]2T@B..L_B>;g\;f
F\VBBS>##=D\UXa2@6Y5&I_6G</J(?L,^;TVfT7E>2>5.^cNS+TOXIW8e49O?Fg6
aQ)/,_H_IUf(AOW>:M4g-Rc-WL]d(b-EVI[MVaPI=U[(^dD-T@[]+^RTdTO_HDNc
&?681:a7@DM<&FMf/WR;6[BIegO0Lb?Wf^:\+/NYYb,fQ\5V.NK^e6eJ/cP>(QP4
91#7:R<+NKTSV.ePKXA7dLW6>;+L+M+d+AT@73FCZ?VW4W@NOQ853(Ag)L6Gd^XC
:bYZP:d(M8c;9&3e9,^LSDXH\fd@^.\C)eDAJcBF:dUGSW@6YF1g?cN4ScZ-B?V\
>.d/C;G&9T6cE?K9TAN@CLg&+e1:eeA(#Q+KbG+QLf\.LE\BPeG1U_T66XS&.\3_
9a+_P;D)eAMG63ZF^:96R<7;7UM(3f_QDTWHGN-;8d@CNb1-]BUd]dccESc^[,Xe
0DYCT34P_[/-TZ[Cg2W-T-=<5QZWJ=0:HPIVdZacEDZV=+be&_a/9:G<b[I?03B@
WTFXQbBg4O@8[W3F=>/9^Mc(@Pe&GW+,/[/\BZRM<8<d0C=-fH28K/fE1UYFXZH,
eNb2SH^3B2(fbZR<WVdD^4c4Q@b[dY-VC/ZJSd&CA7VHN?,C3F;]K[JYC>+PXG/U
(?+[9E4W^Ef9[Le6<4P>?=V\OdNK^0A08.6.f:b2^TF8CRMJ-cB5EQU_HDTLW>)4
\])Zd5g[IR-(>:7=LFL8aJ)DYDB&HL?1XU>/2@/B^G;8)V<9c9ebC3;7)G7I[D]Q
P-..=W>=bRa^RcGW[-Te)Z:2Yfbf5B;)gL)[JYSeTAP3<NVPD3X_\U>,.G<.04YM
-0)-]^eC?S8G3=-XL+=HZIWKXW([]LJL3fZ4DK[632X-C(2TW3H)(5eXg^RH@?9K
<cg7cN=FaS^KFR\;ID6M9VV_JUYY2abIFVM[<U:Q1d_@NO30<Wg[D;e#S#GN=?g=
MT])+XM7f9B/:#C(g@-#BQ\@c,/29TY/QH5?2KC8)(-;51].R11<@>1ZB,U=L/9e
9CgQgdTA(B&4<aQd0-/Lg-M>L<Q=<D@D=PGRJRC\D-I&+])BdZ-@8f<][T^MSK:9
:g6#93B()K;?(Rf+3)5d&fZDPAVTFPe.2._Y:P(,5>Y9PXFK=IMB)G5FG_gI8VUK
(<HY[UDdAFV5T>dfJecDeEH+8_>S[Fbf&/2O5F@O6AAfAU6cgL<TdX>-A?HR.>\R
_P-/G9FcCK6A5(LE,)QEfDf(THY@\>b:S47RI3/IdOEQ5)C_f,L;7&2+fLDA#_)K
cY)HL]Y4G4&a/a:\(JEW;QV3KSY?:Gce7+M?B,,e23-33^JYDcWZ[c\^,6gRNBLI
S@VBS8.Y03#VfO8M,]^PK+IU_@Z0cDgS8K:F8_g6W(M,(JV=?457T21O,;;CF;1X
OQ-.KHH^=:TH:EGV^_UVgT1NVGFPBZQ&386#SN^;3f@EN:/(OJ#6f1._O].R38_0
Se^=D;ZEd?ZJC;4;U8O-[I#[>e6+8U=>IfB76&@OL1:]gX3EXSKG<R;3>ID-7B8E
\e4,\6<U2)c)BWf_&FJM3#=IT[dGZJ:PBZ8GWc<Ha@fS1(-UeE[3KP.31V)P/g]\
T+@_Td+,RUPK+K82EcV82e0:g1/\b;CY]X_5d#IVbB_.BWETH^Q#H..\CcC[ZKRN
MW,M=<=9\]4)(c/+-8VRaO#A<KDg5SMO5&<C+b4E&U]F-(H?3L0>g]C.98AJeTDZ
S643I].ad(I9:O-?1]9RU0a2)P5Jd0a4N:JF)DF5#BP\:C@<g?TV?44R63X<JDN-
bHX)BQJ;R::5JE@bf(POcW/:=/bQ4W,URg4PRO6OW]</Q/Z0JKR9T&&Z(H9F=4)^
&Y549J+HBL#8g#-UDf-M(=CX3[6A)-#ELd.NN&c=3cPHY;3-\,M#&0\\4?D\0TZ&
SG2D3AO#7Uc-3_8<acT6FY8OSaW3]6eY(KJ;D).@OCgQ,J7)]94K6R5?LYFQ:10)
N;.;83GeG,N]F<5TGEN>(I[_8^/RATCX2ZRX?R2FYQ9UB3fb++FMGPD,3:(U],SK
T(/-D+aG)8;2Zg@O>QL+0.]fILYO>[MO>:1X17U1B;96YdY&Q+F>/M@E#eX.1H++
Cd(YaZ0dX&WUI7Cc;gN/&-@c\7@Z<Q#SQA3;?#6J=CZ1&9N\+O/?<NN>IYZ_e&fN
3TD&[MF1P<+U*$
`endprotected


//svt_vcs_lic_vip_protect
`protected
V0ZfN==Y_a&BM/B3VI&3.N3gP].3+Ig,(>JEee<P6,E7ZBP4LPSJ1(VW\Y8Ygd\c
>/W\\60)E/V6#Ke>+0b<&7c<(&dC^9H;+I,bVH:Q^6&Kc7fC,D(^87;K:_f5gf8+
:0X?ba:0cdJ55\</+NgH]>PN/W@,CE.afFY]W0#J/8BC)6M:?:79/;#(K7WV-+H(
>S6=[?/:a@L.=NCGePFVX=Z1DUTDOB?>)^HfZML\1Z8J[c/\H52?+IHc?)G-cXXF
cKQNQHGW-5,#5gc-S.?^@@0XR1Z@XTI;FRA;JL_<LPFQ&6BO7GS3IR]\MAId-0UR
H5@C1=]+RSe1Fa):0aJU36:dX.V&>VP1=:>RWUOSf-N1+:)8g:B9YF.W:4>290_C
^@dS<J6-J:_C1dI#2B)P]AKeV-4\<Z-4LWGg?cdSIdU?S2?W=IZ<64.<70)C:+4]
U72.,JAO<ZgeQ;(Pb4dcW>6b=:PDg<GI.)\-#>0/WFWUc=EHg0]TY?<>,09aY,U_
1EYc(_TaLV>>5cTQ\YW)C@OgSK0JOE.)ca[?RNEN2OZ?1^,Bb[<.,[H.0MC#:?7]
MBa(B/:&>GLGVaJ>A)bB+:MPYf5afCV@;Z<J>JNX4PEPF7W7T+K+=[N;1P4bJDR^
H.;,LQ,g&CI5_Q4Na)Fc()A&PDaO#))ecV:0cEb;LQUY,J0=>Q,UL1MCF&VaQ340
FG;d=:SW#P7Z\1XG4aU.,-^;7@QD,22C1RJO,S0daI9DH,XP)XHd6@D&GT(\AV[H
1U20>dd^SF6/bO=g5F981M=_XH^,:TBL)R&/XH[\G93M9(egc&X5Bee7GAWN#F_c
NL[V>+-BB<&6#[D<9(5FcYAMO-DFgS,G,Y^R&&bL/7K[c];d9fJ&2Y>g#P#c\I_D
-7/Y.;3?#-\a;S/^)_].1YMF>C_\:S.@LYYE#-SJe2A\<C-=R7MJ9HAJC70fB]FA
,9N9?E,R.2+bdG:=Y<2[VdcQ.-.NR8Y9W&\H3<,DaLFGENJL5eBWeZ@E]D_dLE,D
e[M9g-/ZH9TQ&38FcV/M+^=0Df&7Se)0g;F9g]5>VdMR:&C5A/b?C9eK=#?];GD@
R6PCAE[N&=>&GfaRS&gV)M9>T?C\50_^f#<We;&cMaW5<:-+^=XW#STXICF\QJPW
=J67G>L53DW@-B=#\@8NK,7Q7HYZ1NfFYcR2ca8WVC4-WH6/<aH#2,STe]b[@&3;
5O<052KR3(QFKBXDJE)8XG586aLV]HQ89K?38^cL\F@F?A(9\+L_;fPM19G8?__3
P?0Ya\DG:\cOK2;LQ]J.&>9MBH\<.UY5aITN(J^KU#Ug07>bJL=Hc(0cf_/=/Ua8
D1N?671OKRGO(?>2)Xd)PQYOg]#cPSZ+g<SOICgb^PT]^A@,([9&??ff&g7Z:G\2
//J@c9(;+T?\VBM]6FOSKYR??T]EVdcUP)D+&HKKV9^7_8C3=BHN_G+4FfGW\4BK
0b73#H<fB]4QV?[.N--_HXIN4#H=,?98==1NW>2QH[OX+D7<TATWXc,&FS[@PCMa
f3eS9O)QZ+?W)(&W3dgJNec_?PE[g.RL/7<7f^d7>+_NKLW,DWM=)#LPCeDN]aRG
d09;/GSc+Z5_K0T0/3IC^269I2RT?#@\I>BK:3OU8HVE7Aa)?PSU;_gdL<R\S;g^
[6g1QP0GG_KEY38L22Se.7c(XgLM@2-=9aE[=gNK155:]H,C54\46I3\Q..JJgD3
eaRA)UDE_eQAP2WR,GHgF2LNFF<gC\^?W\B>?dY<a,K?Y(]b_28/CTaTZ3?V-+F)
JF:f,?8F\HOI<28^368N</YcJQZ4S)Og,&AAc9Q:SE[F<@(L]DRP>0F5/,,+\CX;
6Fb]@AK\_^^GbT,0eC_+VcUbcMY&8]P^N#VH&:DgOALKYJ[#M(Q:@7B_GFJDLXR1
-dGO,8Z(G]3c=Fb4LB^-98HV;O+=#5&,9V+X(9fKP7P/DCMGDfTJ;6Y2I,V&0+EG
9FU<KP6_9gWM<J#52@E56=VK:(IY;W/G[.D?3)-Z,^1.#5Z4YHPcY_D9/;4:VYM?
g;8I]0@GCZO427J,0?H+]M#TRD(\Z;@=aL43L4Zba;ICC<S.7)GLSTZY?,K#,d]N
../aDf2cWSI9=>7Ge1C^BHTXQDbLYN8:/,5a&9>Xf\@B0I>eGYEMO;b:)[U#<R1g
[F&NB+D</17-]#_b[I4[?be+0R./2HM[-^G^e<(^gA>HLKBV9U5MGDc;N4+N3P\R
5EI4JfTEATE)EX2K4aT@B3OGUgLY<U/#b,QP:AA\Ye,EL0eF\Ng&cU#[[E=gC2g0
DS.8\0c&gbd]X0Z#2E?JK#7=aTG\bHKfP1+29+e(SMD(:0,N(1SNca,FB4JO;))\
&;=.#Y[Z>NOVT4(E#J9X2Ea[N?US6^GKO;3L2O^N>&5.DPQVWNJJd_bTUa)#RH@,
PS;aED2+FC5Z\6?,ed5@SDPLF_B50^)O,:gJDZH.Ua/2,eOQeeU7F5,2AOV,>5#B
A=4CM@/AZcZ80CA@1_)JA1W8P?7])Jg1_T1OC]FXCD-9]M7]+JCIQ/PTO+f?L<1H
Q3^-O[e,9A#dDc@D_cMS9N->TE2.X4bZ,IKV-ZN+BNc@eP&b&\0HSG.,dG/S(R2H
WG/I)A@aV/>\).]+F64O8@+E/#8P^.GB3Abd0CN[9354aE0^3\FF8;3^/LKHRDaD
aNbZ3<bgL1RXOD;5MT6:ZN9H_eI6ZAG06g#HK5.MN#T,b/g@Ra&M7VD(c#7G5QR.
@__>\7X[HB-B6>GM9\>Hec4YAW+7??&\I.-MPV256>R4)>FFe2<Ff]f4#\=@FODT
ca<2SHEV]4(XG<LE=O:QI>YBWG,\gVge38<ZNLS-RH@a,2)>R;W-SNG-Se@H487b
g/@V_1GLASZ7G_)(BJ<A[?2[7=>?3B9/&fY3RdP[6.#@EF@W?##O>S#HaGGJ-G^a
Z=g(R<^]-AG[QPP[PQQ88P]3-AHX0_G?aN.:FbH[g8Q(GG()M4]9:Cfc8U5?,c/O
ddA;IAER[UR>ELI>+(e:O97[F-;TP]/TT7g9H:T7FLLJJ^aOGE0]dB,:IB:S8bfJ
[5bT4E/;M;5;f/HJL0_?/MBI/7P[aP^8#(P,ba[YQ&8CE9]2GOaVXYcEA=JfZ;.S
5BB@eW#&=CT\.5@N6VK8J2(Qd-ZdIIPS#D:]/)=9?7_529<C1g^T=I2Ff\/?@U86
J4-e^Mf=W-+bQ0[RLIge>)8)IB:^<S1b76cD3g185&W-IU/Id1G_,RCE^O3H7L9P
]\C:=V4AMbZ5a>BW;f.G>6E/g>BP2Q\RTL,9\5\+gML.,T/]A^e7<CZJQ42JfFOg
[.K:4f583Y&SZOCD.0#W32\;4XM=]N=9QAU)JgZRGA&08.Z<;]dG[dI6Gb<>\,WN
5?CV0S)C<?g_eE]7-++:a;5@B[Xb4_KK&QHDNV-:[YF4[QE5b.bB/D4JQ+GR_&61
S\+?LDc&3S->?VM.OF+Og^X8.I8G[V0R675TY<\D^:d\aFPQ4T<c+O:,2DNcPH(Z
6Q-M/,9\-@YbBD:/A3_bYMK;&f:6[ABad8VH2.BVT6,HAdL[)S8V#Z])H&1ST.Y^
:PfDKV:SN9I&VFG(HV01-a?b+IMPQ3),CCYZN4Y9N,Mb/X+GO]LVD+V.Q_H;fS;/
51EF:g9K-L4XM4?E#JZ=M#\SJO8@UdC.(3gL7IAIaZOdK2VM#?HNFfe/@PSCWdF(
e7R8QWSOQX(<_CMM>S@M#?.KQY/4]6dbU(=CA:a[>XeQPH\3-G#.Fg=@H6.XPW:5
>&gO08bRcE^J+86E;5-BRHF0+ZA&:1c[-W/=M]-MbLB/V7g2DH7Z3B##\ccOU05=
d;Z]:g0aIb5589.Ug>Z,2])SI#]&Y/EYEBNJ\WL(G#d\&NGL9F3<67S(?@DS]>+L
eR;K_]7e9T.,+W&Z,6dAWU3QT^3#Q)f^fQGMYYQOgMPg-AYP)PIN8P/DYOeHJJ2/
5]Yf.G\P4/KG06\]=GTEGW4c0BQ?)bdB3WWMR+3ZXaYR>&fe68RMYXJ=E:XX07N0
\cJgXORGHAAfcW/1^WZ\AB1N4XTEZQ2_2ef@[LNGa&9ZfG[@dfU@M@FR96F+;);7
0eUOZ<Q)?eYP]YAANb;?G,/N+V)-0LPU1S0Y9fa(EZ.D.)T^^0;&bZ=MH-O,:\X[
/&:UM[)ReY9c_1N8S5U:>D7G8M4C=BO^:>V2:XWX59P-Q.f]<P84,+KgKUD1V0ZO
?C#_5(TA:]JL5:;Y#R7,\I<,e=B]QQ];GTfN4P4EY(50B9aV<D:6X_FCU(Fed;?0
+IBGWLP-H8IP_\5CR_+MZHQ)bF.N.ZAfP&4QNYA=VZ8BeLIMQX)O>0D1aPY_=SR_
6Wa\c,(AX4WDM25#,eI2^X/d,?d.[#Y(M\35\(/N>+35)Yf+FfDFbRX6[O?aXe\O
d7e7Z9BO5cJ^E@_5)1AP_P8.TE\]bc7H5H)#V0:9TP^JF?DI#I14>HJ&[>HE?ZOA
7[ZGZ(X5W<60b+Q(b-)\[c1=#OTRa#((G^cbT&cSMb,YH^;)C[W](4+QgROCcIB^
_D65>WZg(Tc?P305TcTKC.2F2=b;E:.S1L/?e_)&2XM>.HV4UaJKJXC+F4<B+)?:
?SgA)XbB9?EW0F/B\dICcdA;4Y/eKdg2b&5>fSRA30W33[OVg<5O(gZRgI&F>)LT
^N+?#&EE26P]#fZWPQ^ZWSY:LL[LMCfM/]+3Q0b3GDY+=S7dbDX^e&RQLX&XFFIf
CA.?L4#&R2Tf)QF@<,J@:S;UQABC(8d4[=-1Y-;3C?g#?f;)Y@5Yg]G4DVVf_/GU
R0N5M;KLabR;Z89a#]ESSI>EWc;f]Y-NI)/Rc]_EH^?_8_UbFOFcT?#/>3/]61f@
.9f_EBdaRGX;:f^?<;aU8S3(L1O=3g\LAcI7Hd(?]0S3:,W[ZDAE?[ZSI4IDWBVb
>55;(W>PTK[&_DJba[+\71Pf,WKeRXHQ;Ob\VTZPD6dF:/ZJLIUTDJ<GfHSdW)<Q
^8f3BJR#&XG;HV:D.c#:L(K&E2,Q4]L8+AZ\fZXDYeEXRNGgD)4@Yg.-dZNJGNPW
/#acgGA+=eVNC[>B\A(BE_]<SbMK@NVZ7,:0D.@LGXZJ8_PB9+^HL<ZIMB]+^\5@
;ER1A#9,IE[QFKI=a?8OSUL+Y[C5R>7bbGb0]:KTZA)&Sb.0,B;R1ZMJ]_WY.TT7
2?BCe2T\K[[&\Sa]<XJABgg(R<-a6@UbJN:,DPVe>J98OZ[)0^/f_[A(4cTO9WW6
Cd:>O6\3+]F]Z6++(;5@8YUOX.2..WLIXZT.^0X4O8G+5d7OI@J#de^-E/,5;\:a
F;).bf@4F_F]BAJg0)0<eZ7?F,\2aTE+3D?C9@&gY3D3IHcOKM^S?IHVf-c-W#PH
B>71/YIf;4EJ=5_Xa:?-@f_cJM+<0ZdafZ&J4UH\e<S]RaW_4cUM]F[UO6+&],AK
08Ud,6dQ_G[03,H<?@B]G-S62X=ZD:])?MZ@ERR;Vge1D6TEM#Sa\EKRf>-/BH2^
Mb2V<6LE+Yc6#3GdKLfd7W9\cf9C/<FQg]f\02g\K)@V8>PWRdW.c#92IWD<S>Z)
:(K^PWQaKeK?I59a_>.:<DFI9)_G&)G)I16AC,)L\-cMd,e>#3(BVb35FE[#<[^\
M;7eP2Z?9V)B&6_1&UBQXH/C-1-9VII1HaL3?UBVAJ.Z]aEWgc+:cL-^/H1_/E#@
^S+PDC;TOdOEe@+Q=SU#@7^,V:L]L?S<14db@KUO9aLba\15d2=GF(MG<ReH0#91
V5W5B3/T-Y7&@KJR.LYW]?L;^A_&T2?15H^OQOLBVZZKgWLAF:H>)cMMMD?QB3>f
BP#/7O,<ZS2U5X=B8.J7@gGADMZYW<.=5;;e8O3K:GEa6eAf-TV3O2]6FM2VeaFX
;d/LYHgDg5g(;Beda/12P=EB8NKIMEV]c(-&Ng\Y8B1PHgWXaP]6[-=RfIe0M=1]
f3_<>1[11H4\Xf^/3g^[#JEB5$
`endprotected


`endif // GUARD_SVT_SEQUENCER_SV
