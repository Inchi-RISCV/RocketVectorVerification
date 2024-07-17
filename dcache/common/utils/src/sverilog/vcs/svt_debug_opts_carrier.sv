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

`ifndef GUARD_SVT_DEBUG_OPTS_CARRIER_SV
`define GUARD_SVT_DEBUG_OPTS_CARRIER_SV

// SVDOC unable to refer to class scoped structs
`ifndef __SVDOC__
/**
 * This macro needs to be called within the cb_exec method for each
 * callback supported by the VIP to support 'before' callback
 * execution logging.  The macro should be called before the callback
 * methods are executed.
 * 
 * All arguments except for cbname are optional.
 * 
 * cbname -- Name of the callback method
 * fields -- Queue of svt_pattern_data::create_struct elements
 * objtypes -- Queue of object type names which must be presented in the argument order
 * objvals -- Queue of object references which must be presented in the argument order
 * primvals - Queue of primitive values which must be presented in the argument order
 */
`define SVT_DEBUG_OPTS_CARRIER_PRE_CB(cbname,fields='{},objtypes='{},objvals='{},primvals='{}) \
  svt_debug_opts_carrier pdc = null; \
  svt_debug_opts_carrier post_cb_pdc = null; \
  bit debug_enabled_w_user_cb = 0; \
  if(current_method_triggered_counter.exists(`SVT_DATA_UTIL_ARG_TO_STRING(cbname))) \
    current_method_triggered_counter[`SVT_DATA_UTIL_ARG_TO_STRING(cbname)] = (current_method_triggered_counter[`SVT_DATA_UTIL_ARG_TO_STRING(cbname)])+1; \
  else \
    current_method_triggered_counter[`SVT_DATA_UTIL_ARG_TO_STRING(cbname)] = 1; \
  if (is_debug_enabled() \
`ifdef SVT_DEBUG_OPTS_ENABLE_CALLBACK_PLAYBACK \
    || svt_debug_opts::get_enable_callback_playback() \
`endif \
  ) begin \
    debug_enabled_w_user_cb = has_user_cb(); \
    if (debug_enabled_w_user_cb || svt_debug_opts::has_force_cb_save_to_fsdb_type(`SVT_DATA_UTIL_ARG_TO_STRING(cbname), objtypes) || svt_debug_opts::get_enable_callback_playback()) begin \
`ifdef SVT_VMM_TECHNOLOGY \
      pdc = new(null, get_debug_opts_full_name(), fields, objtypes, objvals, primvals); \
`else \
      pdc = new(`SVT_DATA_UTIL_ARG_TO_STRING(cbname), get_debug_opts_full_name(), fields, objtypes, objvals, primvals); \
      pdc.add_prop("uid_count",current_method_triggered_counter[`SVT_DATA_UTIL_ARG_TO_STRING(cbname)],0, svt_pattern_data::INT); \
`endif \
      if (!svt_debug_opts::get_enable_callback_playback()) begin \
        void'(pdc.update_save_prop_vals_to_fsdb({get_debug_opts_full_name(), ".", `SVT_DATA_UTIL_ARG_TO_STRING(cbname), ".before"})); \
      end \
    end \
  end

/**
 * This macro needs to be called within the cb_exec method for each
 * callback supported by the VIP to support 'after' callback
 * execution logging.  The macro should be called after the callback
 * methods are executed.
 * 
 * All arguments except for cbname are optional.
 * 
 * cbname -- Name of the callback method
 * primprops -- Queue of svt_pattern_data::get_set_struct elements
 * primvals -- Concatenation of every ref argument of the callback
 */
`define SVT_DEBUG_OPTS_CARRIER_POST_CB(cbname,primprops='{},primvals=default_lhs) \
`ifdef SVT_DEBUG_OPTS_ENABLE_CALLBACK_PLAYBACK \
  if (svt_debug_opts::get_enable_callback_playback()) begin \
    if (pdc != null) begin \
      post_cb_pdc = pdc.update_object_prop_vals({get_debug_opts_full_name(), ".", `SVT_DATA_UTIL_ARG_TO_STRING(cbname)}, current_method_triggered_counter[`SVT_DATA_UTIL_ARG_TO_STRING(cbname)]); \
      if (post_cb_pdc != null) begin \
        bit[1023:0] val; \
        if (post_cb_pdc.get_primitive_vals(pdc, primprops, val)) begin \
          bit[1023:0] default_lhs; \
          primvals = val; \
        end \
      end \
    end \
  end \
  else if (debug_enabled_w_user_cb) \
`else \
  if (debug_enabled_w_user_cb) \
`endif \
    void'(pdc.update_save_prop_vals_to_fsdb({get_debug_opts_full_name(), ".", `SVT_DATA_UTIL_ARG_TO_STRING(cbname), ".after"}, ,primprops));

/**
 * This macro can be used by internal cb_exec methods to resolve some design issues
 * that block logging and playback.  This macro can be used to record internal events
 * that the VIP recognizes, but which aren't made available to the testbench through
 * an existing callback.
 * 
 * All arguments except for cbname are optional.
 * 
 * cbname -- Name of the callback method
 * fields -- Queue of svt_pattern_data::create_struct elements
 * objtypes -- Queue of object type names which must be presented in the argument order
 * objvals -- Queue of object references which must be presented in the argument order
 * primvals_pre - Queue of primitive values which must be presented in the argument order
 * primprops -- Queue of svt_pattern_data::get_set_struct elements
 * primvals_post -- Concatenation of every ref argument of the callback
 */
`define SVT_DEBUG_OPTS_CARRIER_INTERNAL_EVENT(cbname,fields='{},objtypes='{},objvals='{},primvals_pre='{},primprops='{},primvals_post=default_lhs) \
 `SVT_DEBUG_OPTS_CARRIER_PRE_CB(cbname,fields,objtypes,objvals,primvals_pre); \
 `SVT_DEBUG_OPTS_CARRIER_POST_CB(cbname,primprops,primvals_post)
`endif

/**
 * This macro needs to be called by all classes that do callback
 * logging in order to support logging. It should be called within
 * the class declaration, so that the method is available
 * to all cb_exec methods which are implemented within the class.
 *
 * T -- The component type that the callbacks are registered with.
 * CB -- The callback type that is registered with the component.
 * compinst -- The component instance which the callbacks will be
 * directed through, and which contains a valid 'is_user_cb' (i.e.,
 * typically inherited from the SVT component classes) implementation.
 */
`define SVT_DEBUG_OPTS_CARRIER_CB_UTIL(T,CB,compinst) \
  int current_method_triggered_counter[string]; \
 \
  function bit has_user_cb(); \
`ifdef SVT_VMM_TECHNOLOGY \
    for (int i = 0; (!has_user_cb && (i < compinst.callbacks.size())); i++) begin \
      svt_xactor_callback svt_cb; \
      if ($cast(svt_cb, compinst.callbacks[i])) \
        has_user_cb = compinst.is_user_cb(svt_cb.get_name()); \
      else \
        /* Its not a SNPS callback, so must be a user callback. */ \
        has_user_cb = 1; \
    end \
`elsif SVT_UVM_TECHNOLOGY \
    uvm_callback_iter#(T, CB) cb_iter = new(compinst); \
    CB cb = cb_iter.first(); \
    has_user_cb = 0; \
    while (!has_user_cb && (cb != null)) begin \
      has_user_cb = compinst.is_user_cb(cb.get_type_name()); \
      cb = cb_iter.next(); \
    end \
`elsif SVT_OVM_TECHNOLOGY \
    ovm_callbacks#(T, CB) cbs = ovm_callbacks #(T,CB)::get_global_cbs(); \
    ovm_queue#(CB) cbq = cbs.get(compinst); \
    has_user_cb = 0; \
    for (int i = 0; !has_user_cb && (cbq != null) && (i < cbq.size()); i++) begin \
      CB cb = cbq.get(i); \
      has_user_cb = compinst.is_user_cb(cb.get_type_name()); \
    end \
`endif \
  endfunction \
 \
  function string get_debug_opts_full_name(); \
    get_debug_opts_full_name = compinst.`SVT_DATA_GET_OBJECT_HIERNAME(); \
  endfunction \
 \
  function bit is_debug_enabled(); \
    is_debug_enabled = compinst.get_is_debug_enabled(); \
  endfunction

/** @cond SV_ONLY */
// =============================================================================
/**
 * The svt_debug_opts_carrier is used to intercept and manage whether the baseline
 * pattern data carrier functionality is actually utilized. 
 */
class svt_debug_opts_carrier extends svt_pattern_data_carrier;

  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_data)
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_debug_opts_carrier class.
   *              This should only ever be called if debug_opts have been enabled.
   *              This is enforced by the SVT_DEBUG_OPTS_CARRIER_PRE_CB macro,
   *              so clients are strongly advised to use that macro to create
   *              instances of this object.
   *
   * @param log A vmm_log object reference used to replace the default internal logger.
   * @param host_inst_name Instance name to check against
   * @param field_desc Shorthand description of the fields to be created in the carrier.
   * @param obj_class_type Class type values which must be provided (in order) for all of the object fields
   * provided in the field_desc.
   */
  extern function new(vmm_log log = null, string host_inst_name = "",
                      svt_pattern_data::create_struct field_desc[$] = '{}, string obj_class_type[$] = '{},
                      `SVT_DATA_TYPE prop_obj[$] = '{}, bit [1023:0] prop_val[$] = '{});
`else
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_debug_opts_carrier class.
   *              This should only ever be called if debug_opts have been enabled.
   *              This is enforced by the SVT_DEBUG_OPTS_CARRIER_PRE_CB macro,
   *              so clients are strongly advised to use that macro to create
   *              instances of this object.
   *
   * @param name Instance name for this object
   * @param host_inst_name Instance name to check against
   * @param field_desc Shorthand description of the fields to be created in the carrier.
   * @param prop_obj Object to assign to the OBJECT properties, expressed as `SVT_DATA_TYPE instances.
   * @param prop_val Values to assign to the primitive property, expressed as a 1024 bit quantities.
   */
  extern function new(string name = "svt_debug_opts_carrier_inst", string host_inst_name = "",
                      svt_pattern_data::create_struct field_desc[$] = '{}, string obj_class_type[$] = '{},
                      `SVT_DATA_TYPE prop_obj[$] = '{}, bit [1023:0] prop_val[$] = '{});
`endif

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_debug_opts_carrier)
  `svt_data_member_end(svt_debug_opts_carrier)

  // ---------------------------------------------------------------------------
  /** Returns the name of this class, or a class derived from this class. */
  extern virtual function string get_class_name();
  
  // ---------------------------------------------------------------------------
  /**
   * Method to assign multiple values to the corresponding named properties included
   * in the carrier.
   *
   * @param prop_desc Shorthand description of the fields to be modified.
   * @return A single bit representing whether or not the indicated properties were set successfully.
   */
   extern virtual function bit set_multiple_prop_vals(svt_pattern_data::get_set_struct prop_desc[$]);

  // ---------------------------------------------------------------------------
  /**
   * This method modifies the object with the provided updates and then writes
   * the resulting property values associated with the data object to an
   * FSDB file. This implementation is mainly here to intercept the request and
   * pass it along or discard it, depending on whether debug opts are enabled.
   * 
   * @param inst_name The full instance path of the component that is writing the object to FSDB
   * @param parent_object_uid Unique ID of the parent object
   * @param update_desc Shorthand description of the primitive fields to be updated in the carrier.
   *
   * @return Indicates success (1) or failure (0) of the save.
   */
  extern virtual function bit update_save_prop_vals_to_fsdb(string inst_name,
                                                     string parent_object_uid = "",
                                                     svt_pattern_data::get_set_struct update_desc[$] = '{});

  // ****************************************************************************
  // Pattern/Prop Utilities
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Method to add a new name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   *
   * @param value Value portion of the new name/value pair.
   *
   * @param array_ix Index associated with the value when the value is in an array.
   *
   * @param typ Type portion of the new name/value pair.
   */
  extern virtual function void add_prop(string name, bit [1023:0] value = 0, int array_ix = 0,
                                        svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

`ifdef SVT_DEBUG_OPTS_ENABLE_CALLBACK_PLAYBACK
  // ---------------------------------------------------------------------------
  /**
   * Used during playback, this method is used to update any object references
   * with the data that is recorded after a callback executes.  The callback is
   * uniquely identified using the full hiearchical path.
   *
   * @param cb_name Full path to the callback that is being played back.
   * @param counter_playback Count of <cb_name><_cb_exec> task triggered in playback
   */
  extern function svt_debug_opts_carrier update_object_prop_vals(string cb_name, int counter_playback);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Used during playback, this method is used to update ref arguments on callbacks.
   * The pattern data carrier object that is recorded prior to callback execution
   * must be supplied because the pattern data carrier object that is obtained
   * post-callback execution are string values, and so the original property type
   * is not available in the post-execution pattern data carrier object.
   * 
   * @param pdc Pattern data carrier object recorded prior to callback execution
   * @param name Property name to be obtained
   * @param size Number of bits needed to encode the return value
   */
  extern function bit[1023:0] get_primitive_val(svt_debug_opts_carrier pdc, string name, output int size);

  /**
   * Returns a queue of prop_val elements 
   */
  extern function bit get_primitive_vals(svt_debug_opts_carrier pdc, svt_pattern_data::get_set_struct prim_props[$] = '{}, output bit[1023:0] prim_vals);

  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

`protected
U1ZcK>c9&LSAW(MU,KN=R59N@#c.R>FA0:MHb&D1+OR1FedGceF@5)\TS??:3SKJ
:dWff4ZSJU5DM,/<E+HM\1L+1O?\_)@3b@+eCc36:(,58,G9H1E<>1P&2F&1&]X5
LCCVCZY(]:2f-EeY(?CTSDb<VY3@&>RL&;C4[P?Hd[bNQH\G9&8GL_=fBPCCJb.V
>ADG_:_F&.R.&V92N\J(5f1;YBIQRK)dET&1:=NX/-T/Ae#F;_=AUg-ca@1-#:\F
X?)?<2(Xd.-#B1KQTe(4NW.eF]Wc^QU7<<BMPEg#(cO]/\T703B/OEJVC(E?TGG/
IIc0^.PEa\Z0:OP/_-U=[^d/L=2WP^0OcOf.+f43=[&F<,H/=VTI;8_dGBR22^H5
Jd.dP&7b-FD]g1RHVXF^8eC)Mf7A]2GTL-N&]09OLUQU(f?9=X[J->I#SQ<?(#Xe
N1^=,8CTHN6Q1+Y_8G)1AO,(<F9dV8P3ZTBD6;U:U;TK<]_P=@6eX33:f01@M]1Y
-^d5=Z0_f-I#:Z&C-P/?:_/\N?DL^(F)>20YOFX6R1eUVSAMC_#1UO&OOB]78+eI
6@)CdT9KW.ZFAe8FO4Z)+cLg2eQefKBSM\fMSVI#8,cg\;g\eg#2dUaY.,U33DB2
EIZ?&U2bILRA&WeZ_OW,>3U0C51_Wca5R8O9NbPP6bZC<+)aaX1]GP3#(6N62gfa
^fXQFM6@__JPEP?Q,O[b1J)M)6WF3BU1L_YX>A#03),[ESL02>Y6TF0PXG\;Nc=c
ED.YA](;03O&;ac[#XJ:ad1;e@:\]<F[a>E^:_8A1[T3fY<5H+EJ\,]E[FcEKOYM
9eFOE[O(e\FbP?@PSTZJQ.-S6B,RKJS94I<62BG)8C_&2)U&S4Q#fcW@@K=<;>BZ
e_OUe,.O<gLe\fVB.J00X;B/JCW3]AY^A^-dG[?-;N9e6>fQ2.QUUW_(NIMTK:M^
UE36(cHBO.C>UDgY<SC#7N6DG^99I=VLCJE6EK5Kf4B+@FS0MIK.R#0B\7,_=SAd
Qeb&EKd]B#.+WTfU>,LQ23()3Q[+1YS0QMN)=VX_)e>gJQ\X)?A&6V.^B3Ea4U6+
f3N&?5RIQ^XWf7;R+KW&2]b^/1R)=C-TdQK::;[.-PX#^gG/VSRfUUI.E>/<\B4[
B]JP5=@9[a,\R7e0RPa\;\K?4PGQ<I3O&F8(/BOZPI;9/fALdF-9Z-fKK4FUH&(]
J;NBOQ3JOE>G,GXJ/CY^_HRbg,Y-eRPId<CeQM&I5B1a),QfLK0OIIV#W]I7H@6,
8J_DQDSM>DZQ?5+dKOc+&+YGUVSF[&4G:CW9H.ee7SJa918J5g]]AEH=>Dc?[16;
<Aa-]E\X3XUMQSKK+A[E]^^1<4L-C]F>0#^Y)49aeE1;/U3JK)#NL-RV<5_C(-SB
P<b,--IV1g<&,=.U.6/FbA]\b)V[<LWWO@T+B3I;^F7C,KN1:YU=d@XWSUG,aR62
A4;N?b+4-\EU03J0_5;1QZCUL4D8&=R\YBML2XDaSQf\<OHPf\dW\G4Y66D2d3TR
A[Hf5,#,.Y-2K:^BHfO0I;e,04>J?\^4-T--PT0.#f<]OA_Z/ceFAB6U?)\4TW15
_M0Id?g^aD;W\]g5^N.G2,7,+e9(0YDUW;gR>.VJ?[4Ob]K]/-c)2R)\X+BD3>/^
7.X@fAS>g0<X7:<PHI6-+99>74g<;FK+8^G-.L7#gUN7_(QeBK:gC(KDTPQX,#-\
&Y^-=8&@ZRB:4&53PV;8/)VHLK_096O^/_beC@R:QKNb0Z60gJINI/C)K[\,XaCL
SU[[00^.eeZFM/WMaF^+F,](:\3VSG(a01-]^-=>27)_L/a?aF>RKL7&+K28KL3L
9@-(0BKJ;T<gJ8FH</D;Wg89eKfI@0ZcbNfF>_9KeQXAY&[6)1e)CZ02/^IT([\9
JdKM.JV]J\@#(Ge7TNGIf_/J[PN]M3F,]@W2)gNe>EdVdC2YRJc^@Q+G88A/&M@a
a7MW[SRUXg\YV8U1MRG(6]1]IVf@--F<dU4)Q0S1(2PR_:&)AdALIcO(0Q1PZB5P
RHUG]0-KZTTaBX0^-ca\_gV#(=PdDOPf(&S(]5#:G,M+?CfXN-YU4:SQD>bA>_D=
J=d9F(D=SGYVT1&]6SP^[VP8?3g-1-0TPaJFI[UA4:6M0B;ReD>(<PbQ^/8)a^(C
+URN[EFK4UEF+e7AT+?(g1e:-&NWB@EVH<bMFY(fK53XT_-bWU9V[27BFga2(Q9H
BBBB?HF10cfgT6E=4Z.:[9bAL&V53gQ&#8CAXdPd6S<)d8O413L@WL;DLZ2AZ4+Y
Ob9RM,_U,H?++HeMc=(YJ[FFV-SER:a,O.c4P92TTVRKHDZ+Wb.4(OY<3cLd(N0J
/+K5HfK],U&O]NRaK[P4W)+5&^/4G@Z2U)IG[N-[ONB<53FTeN+b5VAGLSWWT5#6
2_)X6<cL?NVFa?N#E(HC1@\[bd2.cQB)M(L;UBe\54<?UQ#LCN66[/D.8;U^+-]&
0XWE_WJJf\55)<:?c-BQ70?,S2AZ<a0b9;0=[KA6WTf&aL^bYI.LSVf1T_2R8Y(Q
-<=d)[c/f]_2>110fG?cC+\;B2>96,=H,5+0DIAB>8Z_6/5a@.9RY^SI2Q#L112U
&G0\34E4.6U0GB50I6=D,F8e98:CY8?6X=YR?_;ROCf>cHP;246I9=F.0<R7U_8,
83H=a@UOGEf71=NB>TF5,C(\Red6Tc2C0GKF#WM3ga;@-(XTd1V\I0d-NP<.5Y2U
L36-10B-YScg1S,[_B3JgUW<>O+E#-7P@fgOBb6ECN)&=JZ=7K=Ha,;V\IG46,M]
3:e(@E&0PQ^b&P[aD^S@##cUFMHGCSS?2>)788=/D(MT9Caef7T/9L05;PLa_D:0
9)(/=,V(fXCXK@9#g#I?;a^M.LWGaJV(T=Y26:NPY>XM\ZUTLQX>Y^5OTBP65Y[_
UQ32E?IN90=(#UQQE-5MeN[?69/0&K@QSTb82:M]Qf:@O2gTCcBEd,@4>L>.)?H<
G^S-,D;@)]-E3SAd?BgTK[.2FO_4gEX]_;P_3C5>]Vb;PZ03a6,V3>:\cTWD&_2C
.N4YFLQ_C(&?[A8.dE0)BaLY,\ZKO^IOc][Rg?eP0)W?HL>6CT)-.Z>3(<dU^72d
&16b^?T[AV9e,J_gZ^.M]5dOON=)ITZ1HS5I.,)f(dd#F679H,\=c6I(=62D8YeH
H1+5\W?:VE9eO[J)#.C0CN[GDG5bN9d[K9T>W[ZdH_Q0H@DMDMY042@f4^PdU)CJ
CTP4KA??T)E=UddIJ9\b-^N-YYRD]D>DZ6W&0,aG0B&S+=7;<Q8+f@40fF(K<-@]
E?R>.([Ob->KX>4-[=?LVL]8N[6Gg?WJ(,U[NYOU5.96WX?>c/1QY?\cJc=CPNCU
KLL<RE7Re9eWEe&FQT_e)BHN,[B.#@?MfLH[bL7F9)Ve.(&8I&&-SXO#7-1fTX59
gWZW&:+RSF)LWF:#Lg-#K#JY-S\caQ/]6+QNcJ)cI5\dE-7@aMCC^:BUg<FOS1+J
M)QKdV=,P_-B5:9ES3U]U7=D\.E.1CJ1<0HH2#]Q3+F/g?^QPg3?T&T_gKfT1_IJ
bfO#2#])UP3Zf+X&:(F#UXb:M7D#?MSV=2(c5]BC#(^b/_09=IB3CQ-:[f#:J5eR
98&5]SD8R-LWd0Ta>?]g7F;Y,4fWb:H+)&)cKbS>AMGFG;N[AbdJ\CJ77@G..GWB
KAE)3HT[V\70,B@ZY](?QUTK5PcB5>KV8Y1=[OR.XCPD<C/\98/QFF&994QH6[=.
S_[;XTfW,,S>928SSM5Cc8H^dS>e_FM9a=L:&X3)A.YA>gTD=I.@Kd&(\\XMHeN3
d[23d:7MYe_DE&+^V-FgE(eE86ec_&c:S&#(?15(1QKM-6E[Of80#PHJXZ4>N#1U
f8g6N1^e)P>:bLGXBR/:S88+PWV;@IaE]ULF@NGRc23#XUX]27&M:S#c;X#K7aA;
.S7FfXCR)-?-+]g<+W2P;1R-[?\YCL20:3XN.)g2\SY(5)1KbRHc4CA7CAOS9-7,
bcHOO/eQ/cBME8,&Q2f\fUQ)&fUd#K@ML\5C^&N+/6ND&RBfY.f8OP\U;_+G-gO2
O+LLY/1.7Q_fEX2B9C&6)O2A,W[4+7C\YRCf9G;O6A870TOQF9W9+cDS>[G20^-a
KPF&-Y+#@S7/cV+06?_b2Ub+;O?U5d3a:>\.C3?b-Kf1F#g@a<58=1g@?EM?\S(4
YEgE(_R?,D2W1]D:0a7,>UFJ6U@HA<+4B<+Bg::PO^THOD-&bUMR7#[2QUUUG5gg
K(QK7AWUcSSeU3(5U/9=X6P432(TEQG+:,E6#^WIZN@[+_:<\\QMDLG;;9[EBPG.
3+f\Bb>/H[_#P7)G)gPF;Ic>I/SfT68d5SdK,Z6R;6:f25N?&D<7b.4WJLL4WEMb
:gX\U#,+D4#fIKdSF\#cI-,(3XNVD(B)FTI:&:CaTB.FP7CX3/A6[CW2;<>[L[8R
gUJ,N^)?PHW[6;T_D\/(CG-]ZK70L#^eKHdd40O^L.HgbBZ#H/U9S(,6=+PRELe.
9T@3dTLP#W=b?Pcb4]X<R<EA:gM:--]E;-_IUMZ]5RZ2/2g/39\N^74\):=a;-)J
9P07_e=BE6@#Q@^+(T,:4-B^QC>#E?b.WK(H]Fe=^4_#/@TI]5e)R7K@]WGU>8UF
V<3L02f#SS.W:0f=JTUKLQ\U?G&KM>>#+d(HWTdOY8.g/O?I0P9@I&7QL36W\PAX
eKR;D/BC@=R&M;:Q#)/cYN-4TQ/\8N\D>gDgF1QQLE[M@2&?@>N#+F=<=7UEC1eA
N]8a8,Y.(bELFW6UKQK+F1O1,a3Z-X@LM2R(_:75M?NQ8/_D4VBbA36,9UBaF4Ic
C0CXS8S2VAL??PPP-(NRK5RbL[@?1LM^Ec5[0;65(e\OJ:_CB;>]FVbfM&d>ZVWK
f>2?6@@M#6?&QR;6#;?QT#L5@?/XAc>WY=QcDUAA]a?GQ+WVeUJ):8AAFH)&?/R<
WfBb6d476CQI<4f0:d,@EO6B122LKL:;;25R.&(KR[A<6N;>H\8Cc9FUJHd4cPF=
U;e@.4#M-9dXR3H<1g)B8IfEQ0NKVc;,[\>S,?[DZ8GB3IU]PS8<W\^S^X-6ICM)
&e4dDZ]RNb,-SK3BOT\G#6LAN=6]6RP&-9LK(5VU\IO@1/O0+<IB/&\e\;O.RE7P
2d/XBL-ZD_S<CbXKGQS4#a5c#&/:\:d>:OZfGWSXS&R_faaD:)/9.PUTaF0&e>>#
WN[(_^B75X8;MIJKc&FJg=?Y(8/BP2eFO3/WQ2USX1/;,OaPHdP-8Pc5e>P-X5=7
+B,\cS@Rd8_+@UW5A&cL2]a,cJ&B:YA0VK9I6K?(9-RP3-F0cHOLW,VbDa+M?3(G
@J_^eA;PEEg_1.^H6^13d#/1FfK1Y;2N-;Kbg9<V7CJ?(?:RH@6gQ4SE?I+]?<ET
#2Z3V?FCCb]YZJ@LJ(K88?S0cZS[/2,U^9<:/)7)QDQ,<ST>SFBc=,/]B1N:]J)6
&SKEc1\[G;J=E(,W>fI[&N6<AOINOK\X^7dgV_e&;LT4g.9-O&e659eT>52=(dBQ
/4d4fAQ1X6CY9Q-[MWR?+/W,1@()@@6/P0/ccgT+Q[E=METXPU0_.Y.,CC7bDTSX
5,V/X_GaXCa?\&@+KFb]MLJJOg?GUa545(_M,bRD#:+B3)/<fPBdR]fg(Q>\KCQT
7cYI#g]-gO.b0eeZFVQEQ^LKcZO\YDZ)0[\/X0Wfg#1Rb.KB2@UO,;[O^??AVe-\
eeU@27OQ#\B3Ce<;bC,YEG@>8)gVCOS:^@>E&(4<=^P4_FJfF:FZ&O1f4a+XUI4F
D]dcYgGY_OQUVebX/A)H5Pe]07-KT=0-:b/7:bVVG1>dcdN;b_V-W^+_dB.9<#_;
@H7)8MKJ3f-a]KQ;AMgJ0#AaASEcCA#=-&<NVF)ad>)da_=8+be_,]&DbB)(Z:5;
4XF>3DNN8Z).^Wb7J)1ID3bF\Y>c-CJc&.=]ORV@F?0X_4a8B9PI?AP+P^90,\8R
1V-[O5dNc.,2XaHBVAJLYVSf?2IYc(a_M_aMQ6YN]8N)<=9N8YV2d7>.\MB.7Y>L
D99+=AR9\&&]Xc;[Y.b\;,NY971<8NIR:\VcSYaL8H]3f\CJ^TV]^+,4F@)[X>c1
8,2d@(X@>7,9N]0#>T/fHQWF(e_79&\#53;&^b]W.QNW,VWbbGbD50QMV10W]E4T
&+P2&cDGU\X=GcWLQR1VaH1W.cc.8;7YS<?OS_,RcLTFZ<&2+7@NS0XMNPJQcDB0
4A-A-e:K_QK4bNg,WB6;>>6\OD9#8+N^^R?XPP(a1@LD5<^I?QfR@^dZZ@;A6\.>
9eKXN64gecGVLK;T&S\2Q^RCgHM-75H@/bR-#\VONKSJBBdHRF@L=OKBX.,>\EK4
016]M@0ENZg0#Q&Y^+D/>(XUZ.[/.1MA]OU#,9#BNY@VS^U^9RN_XV_J+-dK9Xa.
9#010=)b6SM@MB^TW1@P1=-Uc0T@g@RNZWFI:fG32E699&dg?(UKIbNFQTDe>c[E
JCU52A8&.R.^c=&f4g]/)\V\=?+[Qf=#8.29I2AF^F>:?<fgN7.CM,L\S1-K/S+8
S,14@RNA;[\g)/AZA=+0L==]PH(]3.<CL=4Z#gA+,aeB[fE3[O2BLN+,.]-)/afL
6Y&-KE;?^@e2=7W&XHe[CY#7MCH]#@Of)PcA>&fHM5H#+F]VX)H&..X;+Y0VbA0;
.=GdEAHUQ/76\XWD9XLU>ed-3d^KE>#N06W^I8cL.BV@NXS8L]KB>PN4(A5c,&NN
8U[fHDX(\<7<TU1O+g]MV4Ig]F0<CUM+S9Z5b.797#3VD52M[IJT3G_(=+:a,D8K
:P]e@?=]A^ZL7^2?83b\_A87370BOe8<bHRL@(a@#KP#VU=YEG,PS@:d]0(I-)_V
>>g<5CU5,,<U4J?@,4L3c[=/]I:D2a[,L,P4f>ORY.^gEg)L?)_87?6,)01Z49-1
M(]eH8g@K,CfO/>M:MfKNNM#YF,?d1ACAa/aL7.O0Z(OH,DaFR865BLO;d0BXQ8<
MH_SW.g9J?--RX&,d\8@_Y=PNY:,MgJA6\R=R:<Z+>0RW(C(Y/2#>H^;aQSM-gR/
f@S]WB,9J)NA^_Y-5I17M0&f>:WgIXX:6<EZE=I9#SZbS;1SF_efBEbF>IE&.51[
=SHG1CQ9XO?:?/)B[PJ(33M4=&)V]4/8e<]b2[U#4835B1F+UZC.:Q.S)E)OBc1<
)TJ++.I@/g,9U#1XdZ4_d=aU^BQ>T^XUc-0X]aC_TP?S:0V)J.?9J2H57/WQ\C)I
ZIb3cf8@,XK9&8Q^M^5,SJF/W2;KRP31?6WVg;EeOF^DZ17dF8NNVbE7+_J101=]
JWIf(2)K>JRI[??CIfCfc:G.8XI&=W]HId1D\[dTWg7G]Z]_^-Od0;_)B0=/L4GP
O[A(+SKbQ.PH05;0a?RQge)-64P&I-fd.7[P0RIUTB</;2=;GeR\].@PIGW9<)0.
I@SIUP]_cG;:9aXLP78=A-fAGJZ?A9U/6g5OB7)W@CZMdDL+?^BFW)Q^cR0_2E5,
Y,ae<^Y(U?+>97:e?+F4V#.5I-W:Z#_WLM^-DP5CN;+F):L/QHA8=1,gEGGG375Z
Z_3RJWJK?]-dI17dV>Q3ZU:OQPX6ABD#-c#&;-DJ1c=U/ULCVY4RHU5H\MfDDGRa
Ja9J1?gZE(#T7D2:cI9#O1?(K1W1<0C97OE>Y8[U>GBNRH.#]&3dQ,_4&MEYaaVb
e)<H>:V=:U,^I?&[&#U.&#H&IZf\I,gbH_INR[7?:X5Ia4fY/=A-//g6B3)TLQ1T
3dABT62QLScOS#Q_3If<ACMX706KDOUKNR9VgA@@PH.>KIE\XD33/fI<3\&K;b#(
L65X1:T.gN<XA#d0_QV)I3AE><M5\Y/0E=HbG(/>7LYEQP#M>8&E9cXBB068XAQ1
OH4;05>RO_#8AT3)ZIF&&g+-]8L9?:e^#7AWBV:Q0P3([J<gT3>1M]>gO[^7_ce&
_GP=9If_X4,?OZ2<P)0[B^^a+N7a28fE,5a3[@3WDE^4G.2>9:M4(fOaP/J38b4&
H.U:gRcR.)\dY?@H5cQ9[Zef97,HSe\f-=Lg?NcC\-aD772VSW8[.R9:5X?V#@/7
R-:&X^C(,4cHEaOMC;)MOP+,DC^AE76cUDNdW+=.@O/&:US)BK5_6GNII2E5T3::
/3-+#Ie,fYBe)Z0.B449;5?\^TB/Xf5+_7.^TJL51c\VU9:B9Vc[_Y<;:?6]?Q<D
g0[Q#/(ZW)OBI1+>#RV;)#P9F-eJJ85::d;2L+?5L@/I\?e)SE5_>/.;<BKD:8U3
_QaM)(1L.eCZO@Ec?#b>H>X3#JN5;,<(N8adAQ^g[9O\R<(U:d[(].0AW,aZVN?)
NRZ3,9B88baP+9S]20+R:1P;KJ^0#DMbO00,;<51a?M80+#PPW45,[UU&=+eMTIE
W>DLC])>+6,EG1\+ATN/N2ZV9J0b/T&7MD17XPV_>dV#VZ1:.bWRTCa79O:S_D-,
,S8RT(_DRCU5#V;L#;_RCATOJVNAdS/WY\Y_a#0Ag1H3Q\_:.6X;BZ+3GTLFW9&_
:.EN^6X1NJFOPQJ,=;c);ABJCETIL18>6fa-@;#K4Z1K\BC9K4,G;agK9C;W8FcG
4G.A^/M4AZZg.cI8FXNY0-cb4,bO;NV\.CGD(e#H@>6S\GTEYd42U39Y81N?:ZJ-
XTA>(c@TP,TS6Ge<D]C?Q\R21_ZgFee]_-d1]Pa8(H>-W/3/X.,^UMb<#[B)&e9?
;V3L)d4H^Z@PP4Ua)317^,#4TY^K9PTQfKIR6,+Egg#O\C@d1JVdA>g#1bbS/:d<
,WSAK7g)Ec6(WOI[N.d,D@[Y/BZL#\3;N5AXAgBfAVG3@7-N,4[@[ND3546(^BS_
Ye4\0D5&M_&daOf-M,XgBGMBAXX6XW4=fS:#D<D6W/0dN,\QE==-,ebFW>_8K2OL
[cb=K2[\\_<8B\Z^I347MJ?>GIOW=Y>C0J:RabI;\<-3d@/[:@O;eQ(<O[;7f(KI
bKf9.@3+;=FffY,G[I?=&GR^]UCeMEK5@=KMC6ZH+GZ(H-@871>OSWdPBPZ5,X6T
11Y&G9Tba8,8Yf#0J1?,_NG?EA0)5X)cg2d-a3N.[.O]7^.]@fI:4TB)E-?W(eJ4
e<?W7](XY#[IPLg2JJ#0.QbcZ2E7H1]W.]TP1-/I),FJA4HI_FH#IB@EX.O:<.6f
B)MV_LX>^WNKf4SMR-+<PJ;F7gaZG?D@a2,,]X9HQX822PT=Z=JB3fOO<WA0,,@(
[#-E<5KB6KB?,WQdd5TXg[K)4U@G@JXY;20VRC?XO\XZ3&ZE]JX#>_&;FY[g1c=:
]?=C?=g8/_X=?Kc=)6<RZ/Dg;HQPB]X#2/Mgb<g0X383+/b//0:<L9^Hf,a4AOA6
]Y?^I;A;K)JCVe0=41YeE#C7e1?SQR&-.cfc/Se)RG<(&><ZdFeg?d&#:+2,Fe_4
,+>AKC1ULVHB\?9..6[NF8]_C;KLdD^bF<XL2bEOC,ZYbd?>=W,Ne40(ZScXa?I9
Bd2&B@:?2a20\d;G@=DUWg?43?O]0Y_1I30Tge,&KIA0ZYLG1E6_Z[Q<XT+9)_6D
M=aF<^cIbS&1SJANQ^R]SXB)f9,dLe6WY<E9-.D/R>#PL\ZP9f3O52RC8,HB_34J
-Q+6Y33VGUU)_D5EL)-&AX#.M>[_6Q<7J#b23)_#:X^N9QHLagOG3LDKFX^7B9QK
S1@O:=ZL23\8SLg4R0,<OS[DA]=_WgL27=C/(=O#7<I+QQ_T6)26Q_0HQe&UEU>,
Z=->W+F=2F(eP/K#+e_T2C<^M65#>S0T5gWKH]:45@W>AH1^^.X09fZ99&_bNa[T
P.B,5,18/VONB6COE9.U3D=7HQ4.W\/4\@ba.Z^16-(e]X,(GEBTLLa>N>WgJ0>R
\VPWO]8\d#e^?)gRQ1eSJg-g05]&M6eW:^8F&bg61cUNM\L5Z/XB]G6eAM/7=IB;
L=TgFP?-CFa+JWY9g;V?G\?\+A56M[cI3a_7#H;4J[J-7a),&2#2(\NbLYb3]NUe
SA+dLdVM\9>[VLXQ;3[B3Xb99X9BIJYc:,?=/S-YNJddT)LOD5c><0-24Y4A@)[X
.Z_3+U120?bS@08/KK6/XAL(@FdC)AKVe)6Q1e0+\ARe)G)MTG=\0PE)CeRCVCL<
-V<=1UU=FA1_De9+5bH[JC1N341a33=<KCXI;(^Pa-EaIfF92QAYfJLXNQBCZD&c
8<=>]-W+,-,BTZHQg9=MR/A?bP.f7f^=)/b[5.g=S+^;+[IR89?7O<KW76+CK+9?
7Be?AC@<7]&T,HW&Z^[\?TeLQ\,#ZcQGa0Cf(2T]>&E<#dP6WFG>Z6c6/I+65TZO
UQ2M^JELcW,5SZB)9ZgZaI9C[(S34M1MbGW..N#/Q3E)^2[d86gScX7R?O+KYC,Y
]g5.&H[M^fM>acF#c]P6--GIJ_[#FAU5JO_[I\;PMa=8W@:7E4B^_f7-b[GXB.2G
a&3W>+G;J5Bda9V<<AIaW(E6a.S?a.dXSWZ)).Vg8b>g:.ONAHQTg]MdU<)H@A/0
8G2C<c1gNQ=OHI.F8;;fSM]M#+9B>@W3Z0bEf]JDX]3GU_^=aNK5KCK[cGf=]VeJ
eDHDO&O?MR;+RJFAE:Ye=ND-7S8>DQ616&0_3-<0(aZJ]--3N9#^+^F5<MYCRTF-
0Q@6<CO\8BdZdB^CWTXdccFOea(Bb0N2JV[1,#POc2bME^LP/RFJENHc@CPW_V&U
UYddgdd20P;_R=QeX-X>g0gMC39c\0?3>#NJ[1^:dM\(ed2//33RDbG2KK?HL?bL
#V8C^9C4<5)>Z1abW_3H+<4d5_f129Ea44):gD3+9V^Z0.-(7gP=0>C460f:VfA5
)\UJ[;[cV04cLT6FfI=ec5<g79\HL-4M3f.BY)=MP8]L>0B/g_Ta]XW08Wc/0]0>
=BI+b9?E^WN/EfZ>@U<RNcFFWV\/S:)P>_SRd5I[U=GWHP\8H?;=d?;.>_5b<0NJ
4g+T3Bb58g:3Q-_Kb36)X6)^32bD)P)^=_H4c=6-KaP^CVGGTOZ3PF#^:@fM0(<X
Lb8+d6HW-ZH\5c#b7H6L;HBDG7e8D3ROS(#-aa\&^B14FZM7:3CKT47dRI8dXSDP
E+#,MRdTR^WegL:D.E73APK.46J.BNAAa]&gL3+/8\_^aSU-ge9SV@9_:S3D5J^=
.>F5b(H(O4=D2I=M(7/G51@IA?\cgWa4T[=fdL5,cb3?LHD=ZSOOg]VaFJ8SecVK
bX/=R5eG,@M7&:6NJ9NLYYW6-\]f@<VQPdL9R/E8N[UC\[D,abbS&Wb+WK_8IIc5
.E@?@5KIJIW,<2PCSU7ZMU4J0DYZBBMbIU,c/FK/EM?4ISA.f\+gMVKdKZbJIQJN
Y=-KUdHD[5M(5(G=BPE4>bG/U&J+b/;eb/RXSB/E^_^D-D)9S3OUZ9=)ZKXU&#PQ
N_)I0&2A^7E)Qab5I,R_RCG/H9b>1>_;:MZEO:UDF\_^/Sa7,0eQ&5=)P$
`endprotected


`endif // GUARD_SVT_DEBUG_OPTS_CARRIER_SV
