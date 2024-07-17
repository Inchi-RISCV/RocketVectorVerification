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

`ifndef GUARD_SVT_ERR_CHECK_STATS_COV_SV
`define GUARD_SVT_ERR_CHECK_STATS_COV_SV

/**
 * This macro declares a class by the name <suiteprefix>_err_check_stats_cov_<statsname>.
 * 'suiteprefix' should be the suite prefix (e.g., 'svt_pcie') or a more specific component
 * prefix (e.g., 'svt_pcie_tl'). 'statsname' should to the check_id_str value assigned to
 * the stats instance by the developer.
 *
 * The resulting class is extended from the svt_err_check_stats_cov.sv class.
 *
 * This class includes its own base class covergroup definition, as well as "allocate",
 * "copy", "sample_status", and "set_unique_id" methods, which pertain to the "status" covergroup.
 *
 * It relies on an additional "override" strategy which involves a call to
 * svt_err_check_stats::register_cov_override. This call establishes an object wrapper for the 
 * svt_err_check_stats_cov class extension so that it can be used to create the new class type
 * coverage is added to the svt_err_check_stats instance.
 * 
 * Usage of the "override" method:
 *
 * 1. User creates the svt_err_check_stats class instance. 
 * 2. Calls the "register_check" method for the check.
 * 3. Call the svt_err_check_stats::register_cov_override method with an object wrapper for the svt_err_check_stats_cov class
 *    instance which provides the overide.
 *
 * Note that the override should normally be done by using the SVT_ERR_CHECK_STATS_COV_PREFIX_EXTENDED_CLASS_OVERRIDE
 * macro. 
 */
`define SVT_ERR_CHECK_STATS_COV_PREFIX_EXTENDED_CLASS_DECL(suiteprefix,statsname) \
    /** Class declaration of error check stats coverage instance for the protocol check statsname */ \
    class suiteprefix``_err_check_stats_cov_``statsname extends svt_err_check_stats_cov; \
`ifdef SVT_VMM_TECHNOLOGY \
`ifndef SVT_PRE_VMM_12 \
    `vmm_typename(suiteprefix``_err_check_stats_cov_``statsname) \
`endif \
`endif \
  \
`ifndef SVT_ERR_CHECK_STATS_COV_EXCLUDE_STATUS_CG \
    covergroup status; \
      option.per_instance = 1; \
      option.goal = 100; \
      pass : coverpoint status_bit iff (enable_pass_cov) { \
        bins pass = {1}; \
`ifdef SVT_MULTI_SIM_IGNORE_BINS \
`ifndef SVT_ERR_CHECK_STATS_COV_DISABLE_IGNORE_BINS \
        ignore_bins pass_i = {(enable_pass_cov == 1'b0) ? 1'b1 : 1'b0}; \
`endif \
`else \
        ignore_bins pass_i = {1} iff (!enable_pass_cov); \
`endif \
      } \
      fail : coverpoint !status_bit iff (enable_fail_cov) { \
        bins fail = {1}; \
`ifdef SVT_MULTI_SIM_IGNORE_BINS \
`ifndef SVT_ERR_CHECK_STATS_COV_DISABLE_IGNORE_BINS \
        ignore_bins fail_i = {(enable_fail_cov == 1'b0) ? 1'b1 : 1'b0}; \
`endif \
`else \
        ignore_bins fail_i = {1} iff (!enable_fail_cov); \
`endif \
      } \
    endgroup \
`endif \
  \
    extern function new(string name = ""); \
`ifndef SVT_VMM_TECHNOLOGY \
    `svt_xvm_object_utils(suiteprefix``_err_check_stats_cov_``statsname) \
`endif \
  \
`ifdef SVT_VMM_TECHNOLOGY \
`ifndef SVT_PRE_VMM_12 \
    extern virtual function suiteprefix``_err_check_stats_cov_``statsname allocate(); \
  \
    extern virtual function suiteprefix``_err_check_stats_cov_``statsname copy(); \
`endif \
`endif \
  \
    extern virtual function void sample_status(bit status_bit, string message = ""); \
  \
    extern virtual function void set_unique_id(string unique_id); \
  \
    extern static function void override(string inst_path); \
  \
    extern static function void direct_override(svt_err_check_stats stats); \
`ifdef SVT_VMM_TECHNOLOGY \
`ifndef SVT_PRE_VMM_12 \
    `vmm_class_factory(suiteprefix``_err_check_stats_cov_``statsname) \
`endif \
`endif \
  endclass \
  \
  function suiteprefix``_err_check_stats_cov_``statsname::new(string name = ""); \
    super.new(name, 0); \
    /* If client has disabled pass/fail coverage, then don't create the covergroup */ \
    if ((svt_err_check_stats_cov::initial_enable_pass_cov != 0) || (svt_err_check_stats_cov::initial_enable_fail_cov != 0)) begin \
`ifndef SVT_ERR_CHECK_STATS_COV_EXCLUDE_STATUS_CG \
      status = new(); \
`ifdef SVT_ERR_CHECK_STATS_COV_DISABLE_IGNORE_BINS \
      /* NOTE: Some older versions of Incisive (i.e., prior to 12.10.005) require the goal to */ \
      /*       be a constant if it is set in the covergroup definition. So set it here instead. */ \
      status.option.goal = 50*(enable_pass_cov+enable_fail_cov); \
`endif \
`endif \
`ifndef SVT_MULTI_SIM_COVERAGE_IFF_SHAPING \
      shape_cov(); \
`endif \
    end \
  \
  endfunction \
  \
`ifdef SVT_VMM_TECHNOLOGY \
`ifndef SVT_PRE_VMM_12 \
  function suiteprefix``_err_check_stats_cov_``statsname suiteprefix``_err_check_stats_cov_``statsname::allocate(); \
    allocate = new(this.get_object_name()); \
  endfunction \
  \
  function suiteprefix``_err_check_stats_cov_``statsname suiteprefix``_err_check_stats_cov_``statsname::copy(); \
    copy = new(this.get_object_name()); \
    copy.set_enable_pass_cov(this.enable_pass_cov); \
    copy.set_enable_fail_cov(this.enable_fail_cov); \
  endfunction \
  \
`endif \
`endif \
  \
  function void suiteprefix``_err_check_stats_cov_``statsname::sample_status(bit status_bit, string message = ""); \
    this.status_bit = status_bit; \
`ifndef SVT_ERR_CHECK_STATS_COV_EXCLUDE_STATUS_CG \
    status.sample(); \
`endif \
  endfunction \
  \
  function void suiteprefix``_err_check_stats_cov_``statsname::set_unique_id(string unique_id); \
`ifndef SVT_ERR_CHECK_STATS_COV_EXCLUDE_STATUS_CG \
    /* Make sure the unique_id doesn't have any spaces in it -- otherwise get warnings */ \
    `SVT_DATA_UTIL_REPLACE_PATTERN(unique_id," ", "_"); \
    status.set_inst_name({unique_id,"_status"}); \
`endif \
  endfunction \
  \
  function void suiteprefix``_err_check_stats_cov_``statsname::override(string inst_path); \
`ifdef SVT_VMM_TECHNOLOGY \
`ifndef SVT_PRE_VMM_12 \
    /* Set initial pass/fail cov values to 0, since VMM is going to create a dummy instance and we don't want a dummy covergroup */ \
    svt_err_check_stats_cov::initial_enable_pass_cov = 0; \
    svt_err_check_stats_cov::initial_enable_fail_cov = 0; \
    svt_err_check_stats_cov::override_with_new(inst_path, suiteprefix``_err_check_stats_cov_``statsname::this_type(),shared_log); \
    svt_err_check_stats_cov::override_with_copy(inst_path, suiteprefix``_err_check_stats_cov_``statsname::this_type(),shared_log); \
    /* Restore the initial pass/fail cov values to their favored defaults */ \
    svt_err_check_stats_cov::initial_enable_pass_cov = 0; \
    svt_err_check_stats_cov::initial_enable_fail_cov = 1; \
`endif \
`else \
    svt_err_check_stats_cov::type_id::set_inst_override(suiteprefix``_err_check_stats_cov_``statsname::get_type(),inst_path); \
`endif \
  endfunction \
  \
  function void suiteprefix``_err_check_stats_cov_``statsname::direct_override(svt_err_check_stats stats); \
`ifdef SVT_VMM_TECHNOLOGY \
`ifndef SVT_PRE_VMM_12 \
    suiteprefix``_err_check_stats_cov_``statsname factory = null; \
    /* Set initial pass/fail cov values to 0, since VMM is going to create a dummy instance and we don't want a dummy covergroup */ \
    svt_err_check_stats_cov::initial_enable_pass_cov = 0; \
    svt_err_check_stats_cov::initial_enable_fail_cov = 0; \
    factory = new(); \
    stats.register_cov_override(factory); \
    /* Restore the initial pass/fail cov values to their favored defaults */ \
    svt_err_check_stats_cov::initial_enable_pass_cov = 0; \
    svt_err_check_stats_cov::initial_enable_fail_cov = 1; \
`endif \
`else \
    stats.register_cov_override(suiteprefix``_err_check_stats_cov_``statsname::get_type()); \
`endif \
  endfunction

/**
 * This macro is provided for backwards compatibility. Clients should now use the
 * SVT_ERR_CHECK_STATS_COV_PREFIX_EXTENDED_CLASS_DECL macro to avoid class name conflicts.
 */
`define SVT_ERR_CHECK_STATS_COV_EXTENDED_CLASS_DECL(statsname) \
  `SVT_ERR_CHECK_STATS_COV_PREFIX_EXTENDED_CLASS_DECL(svt,statsname)

/**
 * Macro that can be used to setup the class override for a specific svt_err_check_stats
 * class instance, identified by statsname, to use the corredponding coverage class defined
 * using the SVT_ERR_CHECK_STATS_COV_PREFIX_EXTENDED_CLASS_DECL macro. Note that this macro
 * relies on the statsname being used for both the 'check_id_str' provided to the original
 * svt_err_check_stats constructor, as well as the name given to the svt_err_check_stats
 * instance in the local scope.
 */
`define SVT_ERR_CHECK_STATS_COV_PREFIX_EXTENDED_CLASS_OVERRIDE(suiteprefix,statsname) \
  suiteprefix``_err_check_stats_cov_``statsname::direct_override(statsname);

/**
 * This macro is provided for backwards compatibility. Clients should now use the
 * SVT_ERR_CHECK_STATS_COV_PREFIX_EXTENDED_CLASS_OVERRIDE macro to avoid class name conflicts.
 */
`define SVT_ERR_CHECK_STATS_COV_EXTENDED_CLASS_OVERRIDE(statsname) \
  `SVT_ERR_CHECK_STATS_COV_PREFIX_EXTENDED_CLASS_OVERRIDE(svt,statsname)

/** @cond SV_ONLY */
// =============================================================================

/**
 * This class defines the covergroup for the svt_err_check_stats instance. 
 */

`ifdef SVT_VMM_TECHNOLOGY
`ifdef SVT_PRE_VMM_12
class svt_err_check_stats_cov;
`else
class svt_err_check_stats_cov extends vmm_object;
`endif
`else
class svt_err_check_stats_cov extends `SVT_XVM(object);
`endif

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /** Value used to initialize the enable_fail_cov field when the next cov instance is created. */
  static bit initial_enable_fail_cov = 1;

  /** Value used to initialize the enable_pass_cov field when the next cov instance is created. */
  static bit initial_enable_pass_cov = 0;

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  /** The value being covered */
  protected bit status_bit;

  /** Enables the "fail" bins of the status covergroup */
  protected bit enable_fail_cov = svt_err_check_stats_cov::initial_enable_fail_cov;

  /** Enables the "pass" bins of the status covergroup */
  protected bit enable_pass_cov = svt_err_check_stats_cov::initial_enable_pass_cov;

`ifdef SVT_VMM_TECHNOLOGY
`ifndef SVT_PRE_VMM_12
  /** Shared log for use across all svt_err_check_stats_cov classes. */
  static vmm_log shared_log = new("svt_err_check_stats_cov", "class");
`endif
`endif

  // ****************************************************************************
  // Local Data Properties
  // ****************************************************************************

`ifdef SVT_MULTI_SIM_COVERGROUP_NULL_CHECK
  /** Indicates whether the status covergroup was created */
  local bit status_created = 0;
`endif

  // ****************************************************************************
  // Coverage Groups
  // ****************************************************************************

  /** 
   * Covergroup which would indicate the pass and fail hits for a particular svt_err_check_stats.
   */
  covergroup status;
    option.per_instance = 1;
    option.goal = 100;
    pass : coverpoint status_bit iff (enable_pass_cov) {
      bins pass = {1};
`ifdef SVT_MULTI_SIM_IGNORE_BINS
`ifndef SVT_ERR_CHECK_STATS_COV_DISABLE_IGNORE_BINS
      ignore_bins pass_i = {(enable_pass_cov == 1'b0) ? 1'b1 : 1'b0};
`endif
`else
      ignore_bins pass_i = {1} iff (!enable_pass_cov);
`endif
    }
    fail : coverpoint !status_bit iff (enable_fail_cov) {
      bins fail = {1};
`ifdef SVT_MULTI_SIM_IGNORE_BINS
`ifndef SVT_ERR_CHECK_STATS_COV_DISABLE_IGNORE_BINS
      ignore_bins fail_i = {(enable_fail_cov == 1'b0) ? 1'b1 : 1'b0};
`endif
`else
      ignore_bins fail_i = {1} iff (!enable_fail_cov);
`endif
    }
  endgroup

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_err_check_stats_cov class.
   *
   * @param name name given to this instance.
   * @param enable_covergroup Qualifier whether to create the covergroup or not.
   */
  extern function new(string name = "", bit enable_covergroup = 1);

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************

`ifndef SVT_VMM_TECHNOLOGY
  `svt_xvm_object_utils(svt_err_check_stats_cov)
`endif

`ifdef SVT_VMM_TECHNOLOGY
`ifndef SVT_PRE_VMM_12
  // ---------------------------------------------------------------------------
  /**
   * Method to allocate a new svt_err_check_stats_cov instance.
   * Needed to support the vmm_object factory subsystem.
   */
  extern virtual function svt_err_check_stats_cov allocate();

  // ---------------------------------------------------------------------------
  /**
   * Method to allocate a new svt_err_check_stats_cov instance.
   * Needed to support the vmm_object factory subsystem.
   */
  extern virtual function svt_err_check_stats_cov copy();
`endif
`endif

  // ---------------------------------------------------------------------------
  /**
   * Method to update the sample value for the covergroup.
   *
   * It sets the "status_bit" field. 
   * It calls the sample method for the "status" covergroup if the "status" covergroup 
   * has been created. 
   *
   * @param status_bit Sampling bit for the covergroup.
   * @param message Optional string which may be used in extended classes to differentiate
   * 'fail' cases. Ignored by the base class implementation.
   */
  extern virtual function void sample_status(bit status_bit, string message = "");  

  // ---------------------------------------------------------------------------
  /**
   * Sets the "enable_pass_cov" bit for the "status" covergroup. 
   *
   * @param enable_pass_cov Bit indicating to enable "pass" bins  
   * 
   */
  extern virtual function void set_enable_pass_cov(bit enable_pass_cov);

  // ---------------------------------------------------------------------------
  /**
   * Sets the "enable_fail_cov" bit for the "status" covergroup. 
   *
   * @param enable_fail_cov Bit indicating to enable "fail" bins  
   * 
   */
  extern virtual function void set_enable_fail_cov(bit enable_fail_cov);

`ifndef SVT_MULTI_SIM_COVERAGE_IFF_SHAPING
  extern virtual function void shape_cov();
`endif

  // ---------------------------------------------------------------------------
  /**
   * Method to set the instance name for any covergroup contained in this class, 
   * based on the unique_id provided as a representation of the associated check. 
   *
   * It sets the instance of the "status" covergroup to {unique_id,"_status"} if the 
   * "status" covergroup has been created.
   *
   * @param unique_id Unique identifier for the covergroup.
   */
  extern virtual function void set_unique_id(string unique_id);  

`ifdef SVT_VMM_TECHNOLOGY 
`ifndef SVT_PRE_VMM_12
  `vmm_class_factory(svt_err_check_stats_cov)
`endif
`endif

endclass

/** @endcond */
//svt_vcs_lic_vip_protect
`protected
KU)@#>-B8fGF)I+FED]+^K<GefD219PWR\&dY18bG&b-JL.a;H]D((L^2A(RGCKf
E74e2(5a4JX0H?\CEUKP8N_BM:Z+]OVNV@W964:7QgQ2)[Gb<7,,Z;>LS_]gPXB#
F;.5\NNadFUZG2bDF2(aC7eR2b,dX7C-T;ED+/)UT-X9bQE@_N(HQDe7QJ/GB0@,
/CL)gCP(c&[AII-6b,P6Y-.@OVaSIXQ>_0R.^V(_\g=IMfJ;WMEEf&N<[Sb;ZAaa
=M;\AU,/MR=P9R,FXF-#-aY.4Fe4aGd<V7,OG,MO4VgRER:KE-=eMbc_3]3JW<I&
AC^OIf-T14\LXb&DTK9P&e@@R?)g+MJ2KRYSW:7a;;.YVfaH6CfaT.Q5+R\8,9EQ
4a[4#LW:JBc#?9ZF.;bQ:A^@IKHBBYSSKVDY9J1MOA<2LE,dD0@?>J+\^b7G,3P:
e-6Rfc6CcQE<+]gd;>8C++UF:DX9b9/;LP&W7-F030.9C.+,&V6)Oe6d;KZ0N]f,
^C4gWPO1:aF-[a6JKBDQcC7cQ\YdMK>FbHR>&[WKL8D=\EH^+HL,(PIA7+EUcH;R
dL=<E-R.7??df_+61^3NL;^^U/;/CQQa[-[NJ^JUOMK:&UaFUNJaWKZDdB#?PMTe
,BFcNfRU;1PG?e8,YFKKDHY;K(XE5b:2PGQALSa?2?W;9(5>?e3BaCI9;bUZE=/H
;KU&6W^>EVSLfFCU\L8;YMW;<IcTcWg-<[4cgW\E\f:Ia)AO4>OdC?;?b73bfXeH
8BG&4T;1eB&V&UfVY+9L+=g53W1?4WBg1JA8+bCNdOXYHR+QeHFQ&fDY/8^(R75D
/dWZb>?JFPZ&[(JAdaa0^#/Bd?T;=Q0eYd#<P/g5S_K&bTU4,WPe7HLIV5N9eDBD
[?:4adUbW=&Jb)38ebWeDYO41,PES7>2C?HY[K>?CK,e0O,/M)d:GCfK8A6EASfT
<B+CAOfSU_/f,bbX^]TM_D8W+F2O.Fc6:?<W18KT2f-=@#6c.IV]#ML?\;;G7ZH8
ZAWJV^EDW9A]d^LfLdYcQa;&JW^A/5(8UIXD[(WYZbN1XETb73FUH<3b>aS8(LU9
g>XBXSb.R]?-9(TW^\cO@aM/(>-f8&]a=E@Q?8K;DaaF>ES<H4D9V+J//f;H/gT#
S,<1_eU4e#/W>1]9L4,>;dH-KOC?[RfgL&B-[N\:B+S3IB?C8B_2MN&7Z2UN7;].
X;+K5@S[7\<HV4R:_FF<ABE;50Q@DXLVXYRa_NT+T;V6@]\aYYD5>c]>G0SaF#/f
;F7K11/)3?^.O(d,Z:b\_gb:e?<.-1L^D@_2NGTM?ac-bUCV)<&/F>72?4E584LM
EPObE4&B]JcB:Kfc,HLNf,/-=8X_7XV<=GBgQ^JEe;I-O=G>2BP]Y8]5I1Q5+=N=
5IKQd&L&g/[HaE5849HdLR^PKL48U&@V,BfXEZ^J1Bf]PG-\.GCC>=8U62XFa\O-
&P#L#YMBH>#J7CDQgWL\8R\0Z,WBfI.D:eS3\L0g2Mbg3g#FUSM7=\\;D?6TIP1d
6F?Ma;U39],4VTVTg57JM@KGW>D5S>O>=/TK9BJ)I5dC/=TORG[d\a-^L.T(J7?Y
KCXdXE+]Y\I0J=,H/cb9ZK_=C+]0a<c.Ff1,fP0YIPMBQBJCU@OM,N,>_Xd]AR#<
Wg:9+BBZf]NDfB9&BHXZd:8]X:E[(O3G?cdW+&CTQDD&5FTU-bR#UCT0]]LDg6.,
9>_Te8;e8N(e9F&V5X:@>#D+Q1<=c;I64]<:/&]CMMMH\1E#KQJ^PPacMCCOGU]\
0603_7=9:V>ZN,G1+F9dJY]>H@:,4</Vg?UZeC=@;,7Z(TY&<Z=O1e<YM<bcWJ/e
Z#JO9WdU;Zc#_ET#McG+IBQ?^JKD?Z=ZG-]^aGJ[-4CGXI.]@+#AeF.:67eW\+JO
gS8L5U(XOc>4ZSacZ2Z7P9Yf,f\0/P?-J>TUV@SbVC3-/a@FL?Z?(,YIEB7;7OGA
MGR[:R(X(K<-(F<d1d9-4R0>L-cgJQ7BNBLAQU3];;1IF/OVR)S/F?9EA0:_DCI0
77MIU)I25Bg>e=I</1#=>[cHQg^X<X=2_<))g;4Y)0?F,B^EXeQ/>:DQ:,?aDE0D
(2gC25#XL,\:KEN<R#(2L778F^^MNB7^(MVaMI#)\NASJF5cR4OFKM<2&/SHLY>^
AZW@^BL8:&B<VC0?b2<Va@).B(0a+UPVfITWPSISSF6Z+Fc[97F6_:](gQ>Y-L,K
Q?/g8)F8C9LPXM;c07=P_AVe5bgId@?JC4R_X51_:A=_@>OXXCJSXVZ]C<6Uc#;R
KW4\1e[<aV(9Ic+eQ?<(GcJNKE0BYR3MaA8L=;:5/EQ8gR5&G7UWV<MS#>d6U8dX
N)0H@V-_JV<)ATW03>54GE8E^ISKA\IDa1V,Q[30I:O:IS^6=LXQfRG/IEN_eRcW
eTaM@A;E2HY#+9a2?c=bEEP19gMEH&ScS3;e1)Y.314W&E>UY9V8I,7J,NS3\e+8
(cJU,FQd[a2CYA_^be3I;Y50bXH#J\4YZN8>>dUXX<_U334YgBa^;_<.?5UX_H.6
<?1TPOU\dbCg8Q1UeUgC^ffY^A/]#=f.c,RE:K;>.WKWI@H(.=,I;b[f)F?:;+#0
HGH9Vc.^3fVT4TE,BEY.T&Q<feG(\:&PBO+/<E^@\Z\]V7O62^YgMSMK1Zf]EBg8
77a>D-#.JcSdDH[4D,W2]A40#[IfJAdT-dN]]2PAQ5TH.Fb2P[))0Nd@9aOe];:=
TMeE?ETEAC:#d0?(R_B731N##33@L-D0EC>5WM>d-+C,:c-\E+Yd5:/g/U-(3dJ@
--HW,OF(\+/G/F;.AA<;/AXQVBb^77)3M&&NBRU7/RC8&O;c_VOg9+L.<_)X1;:5
XR,2[3]Y^DT(PeHd6I6ZY8^J;=P2CG8CBZ;SM>=8#=c5A)XTZ_)RO2_Ue<T#EEH8
7[9-44GG3baRQ+ST??X_=@54<_]/,D,L.)/0U/>.<Z/#K2J_d84_=;BNY]f#=cP-
R:EC/>f5L.7[>\-^Yf7fb0G_-Pe@5GDD0+M#L:6GTY<X<B>V\4IE-E0U5b+g.MG1
+U>F<3U-7ZdQ;3&/1N@0^gK[PX9W+8:Nc:55[J1#ccN-(9Rb_D0S^W&K(bZ,4+_8
H5N0B-0KSaP@<>V=R1X)I8D8WD.:P_79T/HgK8EdFNM98(?1,3RNd.#6f8U)97&C
IN.,>gYUPU]C)gd7RV7\^6TZUS=T74[_B)bBB1UaFeEEFRJ^A_)3SO6+-9^),4Q4
TDDHDX+8^#T&.]Z1M07Z>(J@CKA[+/d>fNO=AAA2(-a=<#39K.O6(C[OR;d8H[5I
J:c2\JI15U0H)K+fU.@I+E9OKdH>D\_YY08CABPMUV6GI>U\1FScIGHg9I[#BGD]
Z)CZYcC4A][>SKUU[FgZO@((,E)ebeYPD,g2a8SeIP7AX7]#dYY\GAYN3XPFQ>^T
#XdA<B,<T1f.E(_F+4+U0a8:LCPR885^CQ?ASR@aD>^9S]bX.:#;NWV,g1;@YX;H
CUU:O=)+HbP6?cD&83P>dRc8P1S#=,9cFP.XJ2PgS0)Zd,B^6Y:eDe_f([:PBSV@
B(b;KB-P&41=[+U++fB]7?,@SIIe>L6L2SbMc0DZGIWRB>;2&))^fM+EP?EI,_4C
eG>W\\4AZ(_g7W,DL/6eOOPT]Q8CBaRL<)E8)8A&_^#FF+Hgd2LeWf1<&EL@2)T>
aL9ZbgD,GTZ68G45=(E@:0J/)SKcRPL2\JL==_@d/]9XIC&I1.+7Cf.-SN\CQ;9c
E^Qg^#NZ:U\Hd5]H,6a=K1cPDIIH^3L3;WJVXMf0\DdU]D8R+B;=9BG-7)g&26T.
f]T]>6PUd9^RcFcR(R[/J>/&WA4UbJM/dRA07O7&3)g5C0e9PZd@KHP@0@.X>3Wd
F3,PY/3c-VQ7P:0V98D5Z(Y0TRAY+A4U:D2E@;-V^W49:F-fL)?aW-d.IG&/#)F?
+c#RJ):X:^).KgW/dUX_X,#D\[^bWd+_af_WKCPN3=]cd8SdQ^\a><)NaSQ\@CCG
X3cDPBKfNB+KXOa/WK8MG+97H[]daB7ADOT4N]Z@NJ;)BG7;R9]C>6##gY+Id3[K
.7.UgWIP0#/OS_(4c@94SI,(=HF@AGZ<9J]_#J-CVCAMBWa?&d2HN/;VC?I6>YDf
A8fFE\DC3Of]60Q\4?[2\5Y_cG)47Zc6ZcJ;]@D/8N(c/g,#S5>=I<.>&:X0068;
)SNKObDQ8VDA-c3[(TQWZW#2bT?DBMf(Q4)IS[AKRE[R7^6]=\aR4@=^a\>NQ-Fe
SWI1Y.dZLa\c.THPZ?d_<T1cBC0H7dX-eN)2Z>/P@>O-]C-O_;Y=(YfA<UX^ZG^0
=>AU,]\7aSEP4CD/D/>+C#F,?S02/;R;gZASaI76J]&e/:_U8Q@a0LQDX2D6V@gR
>HH8AUVe8OObE\KMM;04CeF,5$
`endprotected

`endif // GUARD_SVT_ERR_CHECK_STATS_COV_SV
