//=======================================================================
// COPYRIGHT (C) 2011-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_GROUP_SV
`define GUARD_SVT_GROUP_SV

// Only compile the svt_group if VMM 1.2 features are enabled
`ifndef SVT_PRE_VMM_12

//svt_vcs_lic_vip_protect
`protected
8eI[,[?AZf?-.0I5g3>g&+V8_&4&JY9O(_Nb?a\bNQWVb\BdgS>T&(_C1#&Y0#,G
SaH<70>DW)<eKR+GF0WN#M?CXD[/L^0N(HFTKE1_(-g^\RHg7C/eORR:N634/DU6
ATZC;ITF1(99-[&EfJN#MG7:8MT\+O1AKR6<@GD?C>3</RQ7GAQK-JQ<OFZH\\)O
:-8#g?Lf]=5,5T0?&UFXb3VGB#N4d[-V:\M0]&7C<&FORQS&&I1JDdP=R^69;1g&
&0TgeaIc]ZKdT^,X5E7T2:VG8$
`endprotected


// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT groups which
 * are based on vmm_group.
 */
virtual class svt_group extends vmm_group;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /**
   * Shared log instance used for internally generated data objects.
   */
  vmm_log data_log;

  /**
   * DUT Error Check infrastructure object <b>shared</b> by the group transactors.
   */
  svt_err_check err_check = null;

  /**
   * Determines if a transaction summary should be generated in the report_ph() task.
   */
  int intermediate_report = 1;

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

//svt_vcs_lic_vip_protect
`protected
DQ_LP8MA@B4H@QO;_J8]#f\b]7CQ&2.HJMfIT>\NN\TRGQ33X<E7,(C_:3f/Z(db
(N?M)UeXPM)_#]N>.Q+U6##BXUJN2<#FWAUU0&V61=CTJ-C4NeH+bYdX6f-f//Wg
QJ>#fZRA:P:_@Q[a8B^&<?PJ_(Sf>8I/WEfge]Q(:)U^(AD5gVgVM:YH5PKAI,QB
gMgeb(/T6.08^.ZQfcY&aE\)_3c/WUM_[8@D0#NQf[T#/XLU<;d:CN\8JX=Z/>ec
cLSD0aQIEXfGZ,5/E3O06(II[?KJG=GB(1Z:R8#=]agb#PM/9dX<R7(RIOM-/82c
K<Q?LWQNaBY+)B9P=/ZJC0>Ob2D33S9@E,e#>c[#fQ(Y#2J^d#Y--TW27?)E\71@
CK>V4Y^L^RMe+TM7/WB[LFPHAKC]>a.RI6)NQB8[U]Z(QX6XEbD@N8[MA&PP0^_P
)603)P_3>=^a3.92O)UGb&O(8HY<)SDG;8KT)3TaG@bMKdG9#MAE42U4gO280\TI
4GE8RC]a0UL(aId,=80eaJMJWB8,Q<0P=:7I/[/Y]Zf5220JHSUeZGU^+U_2M/ZG
.Kf@V:^]A/788_fE&,-]c;FBF/91dY6&):Q@eZ,/Z^eXFS4([_#8WW#JG.DD=L&;
af2N3KaXDVS87eO:S?CUD_<fJKB)CUB,:#-(E9FUQPJ,AEM#e\b.2F^W)[@N]HV6
>T)Y=HD)H8N<[@4<b.7T:BX_LTHaZ5K0\#]S\U+Lc^Cd)=e5OSG?N[g([\c&4,(>
.eM0g;]#IEYKXWL)I#8(/2\eJ>E]&AWNQ]?@4/SeY4/8&=(cENV.F5F+gR<M#LP]
NG4#A_gW;=W+9HFZ(3HXZS62SBa/EZ?5T=FFcaKAF^_XWOZAM()6H8Z27VY8Y96Q
:#5)X+@T768Ub01;.#31GaL2@-JM=H&Y=eZ9+^Tb6A+2B#2X@6=./MX+H23V4g84
EA/FEfd(VI9)U@6f8a;ZT>&P2X\1cB:3E/S-OGW.DQ4aMJ4/@Wd4XNd^9Bg@SK+8
:^FT__,90MdZH#Fb1T;cO;4Q[\6/eQGUcZZ>=#8-B/H:Ub>?A45LHN#^D9BG=2[c
5_UgGKU.\B7e[8\6UISD96)<>5K-65[=@/Rc-bI]X3O1KQ)Yb^FWSbWV9X1Pb7f5
1=XVFfXJ95/H&M-BF<2^8^+,dYO(>Gf_.YgAL3ZGabAJ.IXUS)=MFYZXgUD]FE+C
;:a(SgE&<c,>J4Z0V@-):IL>889EH&K.Sg=.6<.>&^^IcJ@&eU6X@N:T1IAb:QbP
PdCb^^U06+E>U,JZd,8cJ0?=,6,F<)A]^Z?]+)@?];?R#MK<@HQ(R<aLWg#7f:1^
d>6W(_PO=62[f[-HUf,+>[H)f<]d6&)6PA9Y#<e?GQ@465?(<A]M/e(1DGLQ=_gN
:4&N1a[gQ=K^J0aQf9HVC1RZXA^QCbeF^(C5N6;J#GWM]DX4/F1UR864;<JJ;;&S
9QOH<-4eO_<CN+D>NIb@cBRZ4$
`endprotected


  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new group instance, passing the appropriate argument
   * values to the vmm_group parent class.
   *
   * @param suite_name Identifies the product suite to which the group object belongs.
   *
   * @param name Name assigned to this group.
   *
   * @param inst Name assigned to this group instance.
   *
   * @param parent Parent class of this group.
   */
  extern function new(string suite_name,
                      string name = "", 
                      string inst = "",
                      vmm_object parent = null);

  // ---------------------------------------------------------------------------
  /** Returns the name associated with this group. */
  extern virtual function string get_name();

  // ---------------------------------------------------------------------------
  /** Returns the instance name associated with this group. */
  extern virtual function string get_instance();

  // ---------------------------------------------------------------------------
  /**
   * Sets the instance name associated with this group.
   *
   * @param inst The new instance name to be associated with this group.
   */
  extern virtual function void set_instance(string inst);

`ifdef SVT_VMM_TECHNOLOGY
`ifndef SVT_PRE_VMM_12
  // ---------------------------------------------------------------------------
  /**
   * Sets the parent object for this group.
   *
   * @param parent The new parent for the group.
   */
  extern virtual function void set_parent_object(vmm_object parent);
`endif
`endif

//svt_vcs_lic_vip_protect
`protected
VNd4^2FXSR5?OL84:1-/+\K2&>de4M[@CCf=>If90D1D0d_&Pa/T2()bFU1f]\eI
]9J\Rd9;(N=>6Zb?/N<#C=/OId@\YWEK-a^[];DG?T/31?9gb:<I\a\Q=\33HD#(
:I#DW+8@1XbIXPX@^8SSb<&&RTEab;V9&X/[F4,QMeOT3H4cO8./T691D45A)(T\
TSYLUZfKaQc@JA^FY412U]6;<b#GN[aO]6UC/<0P@.16Z>-ON:VO\__S_IeG\K7>
5=W]T/V58PU7,Gc5(8:+aa4?FO@:&D1S&+5,4UR)>E9_,c8B-RRe_0682-9L]_Ce
e7Wf2739_=#]:NXD+WQ/AN7KP@_e+O6@6OAK-CDG;3Rg&40&LK>KDg:.FcTYQ<P>
KX03_8293,PTQQ#,8BQYDE]33K]PS)32;T[1LFJF/Y9PU)YO.:^TF_<-G9(KMJNe
\c,_A1\3)3(,HFEE#5,EP_I09A>/]b7.3<=cC?X4_;)[K&,_BZ,\VP<-I$
`endprotected


  // ---------------------------------------------------------------------------
  /** Returns the model suite name associated with an object. */
  extern virtual function string get_suite_name();

`protected
96I5gAGfIQU5=QY2[a4)R>cC;.._QXN#;S<(HP1eQ19,)3a,M1202)f,Z2#8W353
XagF)APXR9BBKH8bQV-A=N0JXZI+7SZ3U8>>>)<HV+P\Z5+B-?2.Q2aD.:I>fUX=
MG9DY[L(:_WB/$
`endprotected

  
  //----------------------------------------------------------------------------
  /**
   * Updates the group configuration with data from the supplied object.
   * This method always results in a call to reconfigure() for the transactors.
   */
  extern virtual function void reconfigure(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns a copy of the group's configuration object, including the
   * current configuration settings. If cfg is null, creates configuration object
   * of appropriate type.
   */
  extern virtual function void get_group_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the argument
   * into the configuration object stored in the group. Used internally
   * by reconfigure; not to be called directly.
   */
  extern virtual protected function void change_static_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the argument
   * into the configuration object stored in the group. Used internally
   * by reconfigure; not to be called directly.
   */
  extern virtual protected function void change_dynamic_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the configuration
   * object stored in the group into the argument. If cfg is null,
   * creates config object of appropriate type. Used internally by get_group_cfg;
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
   * object stored in the group into the argument. If cfg is null,
   * creates configuration object of appropriate type. Used internally by get_group_cfg;
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
   * type for the group. Extended classes implementing specific groups
   * will provide an extended version of this method and call it directly.
   */
  extern virtual protected function bit is_valid_cfg_type(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Used to identify whether the group has been started. Based on whether the
   * transactors in the group have been started.
   *
   * @return 1 indicates that the group has been started, 0 indicates it has not.
   */
  virtual function bit get_is_started();
    get_is_started = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * This is not part of the defined VMM GROUP run-flow; this method is added to
   * support a reset in the run-flow so the group can support test loops.  It resets
   * the objects contained in the group. It also clears out transaction
   * summaries and drives signals to hi-Z. If this is a HARD reset this method
   * can also result in the destruction of all of the transactors and channels
   * managed by the group. This is basically used to destroy the group and
   * start fresh in subsequent test loops.
   */
  extern virtual task reset(vmm_env::restart_e kind = vmm_env::FIRM);

  // ---------------------------------------------------------------------------
  /**
   * This is not part of the defined VMM GROUP run-flow; this method is added to
   * destroy the GROUP contents so that it can operate in a test loop.  The main
   * action is to kill the contained component and scenario generator transactors.
   */
  extern virtual function void kill();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual function void gen_config_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Enable automated debug
   */
  extern virtual function void build_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Route transcripts to file and print the header for automated debug
   */
  extern virtual function void configure_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual function void connect_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual function void configure_test_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual function void start_of_sim_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual task disabled_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual task reset_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual task training_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual task config_dut_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual task start_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual function void start_of_test_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual task run_ph();

  // ---------------------------------------------------------------------------
  /** Displays the license features that were used to authorize this suite */
  extern function void display_checked_out_features();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual task shutdown_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual task cleanup_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: If final report (i.e., #intermediate_report = 0) this method calls
   * report_ph() on the #check object.
   */
  extern virtual function void report_ph();

  // ---------------------------------------------------------------------------
  /**
   * VMM Run Flow: Phase tracing for automated debug
   */
  extern virtual function void final_ph();

`protected
1ZVK1RfK<Z43D<=;/9G@#F+B9J_WB]^TG#gKP02Y9;+J)=Q3UTaH2)Z1-_&OS6HQ
G52B)X7gL[=bIUD<eR_<1-C_#Z5A9#e:/>e/;NYa4=5>V#d]=Jf^=KDd;2bUUZK]
[F]f?ec<4M&Q).>?WFb6=]4cHR41\adVCU)?-BEV4<cC[Se1[<f90U2:>:Sg#MbM
dZ^_?5E24\SCAWIQfA22e(]<V=##,R<2OCXdKIYG\,^6XceO59TE&J]Sb900=@K)
J@OS@<,a)<7A627<K3Y\84Ra#4ffd?Q]80-T[PMA[T63E@;A#N=)=<EB#26.3cJ&W$
`endprotected


  //----------------------------------------------------------------------------
  /**
   * If this component is enabled for debug then this method will record the 
   * supplied timeunit and enable the configuration properties that correspond
   * to debug features.
   * 
   * @param pkg_prefix String prepended to the methodology extension
   * @param timeunit_str String identifying the timeunit for the supplied package
   * @param cfg Configuration object to enable debug features on
   * @param save_cfg Configuration that is to be saved. If 'null', then 'cfg' is saved.
   */
  extern protected function void enable_debug_opts(string pkg_prefix, string timeunit_str, svt_configuration cfg, svt_configuration save_cfg = null);

  //----------------------------------------------------------------------------
  /**
   * Function looks up whether debug is enabled for this component. This mainly acts
   * as a front for svt_debug_opts, caching and reusing the information after the first
   * lookup.
   */
  extern virtual function bit get_is_debug_enabled();

  //----------------------------------------------------------------------------
  /**
   * Function to get the configuration that should be stored for this component
   * when debug_opts have been enabled.
   *
   * @param cfg The configuration that has been supplied to reconfigure.
   * @return The configuration that is to be stored.
   */
  extern virtual function svt_configuration get_debug_opts_cfg(svt_configuration cfg);

endclass

`protected
d:N.ICU(M]T=5P]FD@057CS?2I.]C<QO<DGR_&U1SSH4U+[8?E-H0)?J?:WRcF1>
g.A4Y?fHN)IEa.7ZTaKb6.Y0>,6+15C:Qea/Da0=_GUJ5GOa,K/JDUX2;I4JLe20
#;TC3X.4cA;NAe+<013fQUDAeO@=2GYT:L]+\0Y(:\Fa6RQ0[69a[6g5M^;S\,K2
OEEYP18VQ;K9)1H+P(5&gQR0Q>R4N?8Q<b80&R;8]M,a3=/66<daE.g=1NK/<VWc
c?Z0)9Z-(KaFWR<3H,X?2/dL@QH5KC1T,U7/&1N@TSFI&(3#YK/XE7eg2==)];;6
+J#^-6Ce[\fFd6FEXWDG#3Y-HfY+Z3#\2Nf66cKH+D/1:HUDQGb8XF(FX^3^O5CO
F5O)8,VU7[C_5eFcNYb@a56D)-W5D2@3UcAPS;>GB2-@D#Q_FA>?)MB^+4K22_f>
FM:dM10C+5PK\7#?F@;.Z;&8ZA&,9R7PJ<7LZ^bWW7g;3W+.B+(D9#&)RJ/CBcdP
PB-^>H(UW:AQ30/c/Z4,_H@eKMKH.5F.^X1ggc7I&3\-<@099&NWLO\fW,2fFRa/
ScCY,IZVM[H32N&CA/<>S&1S2IOQI2M-EQ2CW252X\(/g[W,TbUG\9-4X^-[_b4,
UZ5VeOOLS:Z4?U82U:18)M+\JBWA32?E/J(gf2g]deR:)BUA9F:/\cE?eR,#QccD
&@:#JgEI/8:+bC+Mc]M\4H\I(L=DOO,B?R>1.dB)I&10M2b9M;JO6_L=T&KYg#SI
_=\9,>.EKb)eScY^;OLMYa^XL4dC+QN_0SB]N.N.4AQ+ON>V@H75\6IX&M>+6J-&
93)cc@^MCQN^;EE.<NN_Y;L(S28[[OY<TEOWCLK>^[Z:]RgP+J-76aN,(M5,X-D[
EA]I<G9#5,C-?FEe)PDHg7JAP_HRQe84[T6>6.cZA(D91QecSfY<@=@8SH__0C1\
M(0LF5fPU_)BfR7:SPSU&,[7-<]^YJ<P:>U.d_,fU1e>(Ne]OU(@W.WIUFY;AcPd
\.gOXPSD8,/\E=&VSHYaC9K7#QCb0cc&-Q_9W++eV+/D6@Hca_;]bHYV2C/;#[26
7&/1^S:.TL8/80;c@&+ARC9\,C)X^^[:g#P)Ra(aP.\b9d7Dc&FFS;-9UZ37SCXW
(-9A5Q05+L#:3c[F^Y](1A83.G[)Y;G61,\Z7.0,)R>a4>FcTGB5C>Z^^P2ZTeg#
4IOA2cc7/F?c2f/9L[e/OF:(&Z,NCP5/AU?(8^3#-^@,I/:,DKF)</J1EbS:IRUX
;@3Vb3bH9:XXNMQ5NQ[MfD+I9bLBOKOb5S^SWN?-(dZZ/N2Z7A5]P0DBeQ\gY(R^
9:X<8M7A)>S.?^_T/YKX2NNRO?[/b;H)K-8+:KD&@AKgDHfR<//RJKY-,CF+325]
VZc@CO562F]3M78:,U_)2[NR4$
`endprotected


//------------------------------------------------------------------------------
//svt_vcs_lic_vip_protect
`protected
R+SZ<-2fUPYK[bB8E,-M2689#4W)@aK@.C]...;7FC2GD:H,^8D82(fOCT)Tc87d
&5TR:-89KTSg>LL62ITBC7@[:O:KK7SRBf[gVNUd?J&<,dg939<^e4d_^F3;L>ES
KR]>N#UUg\X?W5<:.(AUPEA06,4CCSQR04ZS/N)dKYY#KDRBSBd8?:a0:P0HD-FB
>cD_A3>\B/QbKTf(TCK-HZOZ6RW?W\E\5_@DS<S:3K.eS:DXXC6FV_Y6Se.0CC7O
cS;7TXM+>[b<.E[YQZE&DG5[(DA4BAZ;1DZ[Sfe^Q=^J4A=#<..dEg#]Z?,>3c2C
,JcUZZ@L&RJgdG?^5D.)KP]1KMLB&bf^9XAYKKcKWB?YJ_X#?V(G)(\(5:<?.KC=
\5]19b4dVb;L^SQMg3LS3\;4-S7aL+XS:G_TYB2GJG&SWXI[8bf26G2YH<-Jg5_Q
F7ggf2M_1HM05+]0TfM.U(<.Gg@d_f=B6GPQ&_-e331PNC>PP)BBRL<49@9LQc:J
a)/_)/U4=A8)<a6fHc.13AN72=&RKRV@QdD<WJH_)Y?FIO;[+aBc@XU1[Yb\K>Yb
Z7>Y,I+E0:1@\8#fb9I]^MYM_R[>L&&;Q#G&ZAa>^R(#^29=T[We]^HF4S\K:AC3
EQU(5))O</X<_]X5OMVg_)A\IG.T8XE?GIA^5KN<2^BH\Eb;VF,VCOY_gXTdV>bL
74eU^f&Y+MeA^W8MOWQ?Z<N3OZ1FY7F6K.I@.=[EUeP/(&QV(7g4MUT.O7L(PP^D
L@FaC]e-99=V;&Z_&?5_fB+Dd0^P4aV)S+0@NDU8A)5Q59#=&.)1@ZB(=,SHceRe
^Me[<f/U64)YdcJO.3.G[_2/Dc8I6#64aN9Ac>b,g#NVZ=17+;D3/R@/[XLJFT.g
ENDOFT)bCe;I<:fE8^JL/^+V?8ZgQ#0T>OE-XDfGS9<11(9cFE?=P9WC2:F\45>_
g)R8VaN6>V_FGUT&,?ge7\;MSSN\-,?GN1HAD/b[:&CMT)?+6dHH@)JOF@2TYgX@
V:R3<S\R<ZbL/3)cFTEH00XII#aACd[/9c_(K?FJJPYW=C1+[@L(f+3aAb.#I5f9
;8__ag@L@e=?B+]]+[(6.B3]^(?2[^HW\PDJV-BfJ&P<bc>dAE5=^,EFbaFTTQHD
P965(9X(e>L(=V1G.?5aK8W#/.C;P1&agH#^S0J<,P#W&,8AI+Q)f<9MM&a5\g:M
bU-XOOK2+De.^W.5;F)A-;I0KbH?.6c:K)8eTc,NS&<H?HE4C.\GbV68VVdW)WO9
-fGQ\7I,TEDLAaK6T:W\W3S<[=+D-T4KVa2S&FO:a913)3@Leg1&GU&H51>f7,WQ
>TcAE[Tb1F5NZ)V;f@&4CY)G)QX&X72=JG26M=+[g5X+ggV/V1\LR(:-/X?M2\VU
0LRXQ).cRNg.O.GIbg;9&M.2_cC=PVb>.[>9eRR&5fMR456];;(XbR^a_.b5D35e
IW:_5I1;HG6C)ZdeC+WW8];S^8?Y@=DeTLH?5WMAD&<?Q)D<X^,&OXFOZ,\J9a.=
V8EH,#TJZ<?:g,Y)6af]\J(NJ\GFA<M&:BeDCC&H4Zg<E2+()OQ^FM54;AU<#SRg
EREI)/7<K4._36=MI?]-H<1-Z=d?7H,,[TEQ<P/4D\]LbV:DPe(dGO=UO)HH/@#?
THJ@e;aUOOba+(GQ6&DCGY9bE7-0cC1VgI-VG,.?&OfY@HN)X3B&GS,D)^X@Z=C(
G8Y^Z&FRH9P&f9:e&LY([&8)^RO4c>C>>OU3WG2U+c-547]7ae)Y2#b4LZ.J1\3@
[33/c[K/ITGP<>RIX4HPZ:5fZ9.5bBPD:FRE9V75(2\0+9;_6)3)7(GO]fU_S=Z2
/MJ150@/6YY>\/E;D(cIc]gG3-E+M5BURUH>?Qf/7PTTV:<5g=(RKRU#Zf51b.X2
5PA;LNM1H5WaO0JY_/;O^NK+(#e5QZN8725^,B3Hg.J,^<SO?fV?_)]WJRN^#WgF
d?A;242&C-^&7@f2TK\.a>#6a5IEB?1R/2UFdPDHF\W#eOD[fa[a?R&D^Z_C.#K@
KXR[K3MG6^\G<1WWZO+]7Jb54V4B-]V@/L)J2b\8(aU.>U9S4f,+5XG\&gC/9>gO
?>-[LHC&=F6_G.I#;P:4g^9NE-\9MW)2#,b.1BgL3Z&#I:cCEg-<<CfLJ8fRd3/3
;c4])429(6J1@OW7,O(PEgCTP\^56C;TQC-4<T<IU.,@WRKR)b+-R5>LfC/MK>dX
c>:17/=,CP1&K=]GbUH0P<bXC<4JcSaYY3,(,^b_-8b5AK5Ha](.]&-X4F0R.M-M
U>Y92)5BABIF@7W8+2D^<+VS/I^>C]bLX\W5d1/d,MP7c6FN.=DV8__9/+A]5g[:
HGf[e[DSd26;-TGH;6HRd<a41bB\D+UC&IXda:d+\QE61S9_VU@=DQgUdP,AR63+
eJgMW18N7_gWe)^AMO0U5C7IDN<B^0ZGR<<dT6#SDR]2@+GT16aQD@8g[?URC]+c
]>\KC=a4Cc##+Y<g-S0E(N,0:#fLGDSG[5g>##QRWcWN=>98JeY]P4QaXIQ-^O@_
cYNA45.TRH+K3Q6UFdI._<WA:NPd8R.#.3C00I,-;ZY>ceE4^fY#\GE&ULg>.9#&
+T)H+K#PDHeQOZ_VGRNN9N],M3L_;I&[[a::ag4.1^.TU.dAMRDJec/EF-E<>.eN
N>M8_H^2A17f.J=HR&EDUXc@Z>Kc<0S:F^DU,VL7;P/e5>8Z4:#JK9VDbRLeF+Q5
;[:>0)7&M;1b#EKYR.<g7-I34#Y&](R<S\U3@BBWJc^9[;WCRL2E&_#D5&O4W8CH
a/Ra[>S(LW>P>6\0ga/B-_\4LHM\KX>JQRbb;7]F[PRW5(T7,7/<92BY],[ACN6c
8<e?6\G(Uc@88>bKHeaYWa5NPDdgDQ&4LT1\,QN8VO@MV)<MVUS\VOE21,NgF6OR
PNLG(PJ3e_/Z(8<3:YT:dS&QK1W\O^R@]BW061>#0YKI,Q2FC?]WE?d=?(cQM,OB
4MLI#YX:@-RXcAD-NURHb_g0QgJJc?(f?Zf)f[I0<Q=P\dK5<(3DGK6[PK[.V1>Q
YMM#^g+WZ]<C8:=RF;UWWdbSe=Y&F+O=^_GZEM5S<[X+&XSW+=#f-J?K4R>2UEAN
[-RK@WEIU/XcH/?b&>UWEbGDT=EXANBe]J,<Cd;bc><9A.UObb)dR+,7<UL5F88D
<^f;ceg?X:2A@BUS#DJ6#d22<=Z2_GXU5(5\3U+31-gSHZ+II1)[b57;aY?=3Z=c
R(,[\[[5M5RS]M8O=CYLI:C.OD>[Q)/7R6b^P.90L/]eE97WO+(MA^T9;8K]RE5G
Rd/ZWcC@46Dd_40#aX]<c5EgS,(,R=5:Q^1RXW39a)Lc_LU2K[THb(5f)c,.@&@3
01X(Y-?4_\CT0MO9NTZ\,8S=LBa.CUG=D-KGL<&0eL&Qd+[=R0Ra23:\6A3E43_P
(VBBJ;0OYT^Q&U>T9Ob;^\?(/d1ES1<VB;76^^L_&BRNJO@d&87ee2X[d:1S.ZD>
EFSW@L2Z5+^Z=&XfaKDVR3;@>D=f/VF_7SKc]7DTDQ:]ZJ@I:4][]+?LW7E-F(]I
V6M[,;a60N03=/JCQ<+_>E3bG#5I#FW_gP?A7F_OG]g:B5NT[0YJ@J#-3);2MARC
<RQ)(7T/_PWe^9B5C@UVCXDEgE\T?8e79_A<LEJFbN/:(NW?59Vb^38e#_._6T3+
=gFOXJ5ebPd<#/3F^=11cPHCR6OG1HXMd-g9:O:RT/<I;\E.A:U]L1Y\9\4#T^C7
@T8A+>[&7Cd]b;AP\-Q86g^dgY>)VPabF^JW>C8efK([CcMJG4UX:V;6/aMPZ,ZF
U)MSMC]B1Y>H:Q<H3ee=;bUACXW#6YWe71F]/)S-I/IYVe^5ZB)4@3GM:7,>b3?O
W,Q9:A_0MY,;26\c>2-b0VG>3TPC+1fP7Of\8CBZ<C_P+P+g54>D=)XgWCcL@.KU
6H9BUZ3W..+90XD2M,PQQ+,?d+IR@R#1;cPEN_NQKI=;SS)]I<F0/;JdfQ(.?Q]4
c.C#UPF7#+=c4Y3[W;D\KbYCTU?1(64HIS47UdH.RNYB@Hd.J9GdS_c,)1:D^IV(
:5M?<KAN#f@;(W1S?_5G7E&1_0fgA3@YLMMTUO.=ZAY&&UGS6JfIBW<J1KNIEG.^
<[-PMG=fGc)/@af:dLL4:9])-K/Z(^1RT7YK+C,gQ4IdI,f_>G#;?fb&I=P3S-_e
PXD/W&:edeF0EPE/>b(K&AYP?WBIVd&:&gPU:a?O4[;(g,]W+VVQ8[X&J3cQESS4
bIfdO\O_3?(1])aW20_<H#[)T>g:8BU+YMEN]X)6IU.2@J#V&QDOMbc^106Ka^cg
HYL;9>8P/U9<VRSOA,8>cL_4ND,a,P#e>#60MH-N9IB@9:JFTK)DIS(VR:Q(RH,C
,@G=[O5;dO0&Y88c5NA?FUBT1UeBH4c2>2[D9B(gBV/LRG]d&;1TN,4LaZ+1aM:9
VL5FFcc.H]LBe;#32UeMce5@8a+7A\eg8#GRV=5UI@F?N?2@72Cc8O#eZW@-3Xc>
TV77,80bbc+[FNI:E)W[57V3N[aC;9)a;Q2-DJ@#[e(aa4+]4<VQ9I1T904B[018
?4X,1;\O\M)\Ue0T0[YdaNY6f.Xb@Z#HbO=AdU0cKRML:-2@)8H5bG<K#)gA8H>.
N/RLTcX2PdJ/@Rbb61EV6CZH,GB@:5dHP[4BR&#MHWHQ4(6RH;8.)G;C?;DMHQ5.
bLe::AAFBRgd]A-INd<ge#C1]2:IP2#_\A?cd&6?I751D71>/IMI3GKOZf61b_AZ
1[]0e4>MD1a^@4[VC48;JdPXI-^7aIbF@TW/Q<f21(M&-2367]b:4R8E3_/HL@-#
1dB6\_NKE\F3HS34EI6M]8OZPb,P-EE<_?/RZ;N#V<#KX9gGO1W)=E^]=F6IZYNd
7=dFS3+](JFe6H1#?Q:TZUS]I:f=aXHHA[8fcbAd=+VS_f[eH=^U#6H3V-&a=]\d
YL0Q:/.GP#&b<;GM;H8aJL8bXF)PGA@U,EG<92><:Da(,8Ld,66E+46&.KQ;WT^)
BODDcD:KS9fUIDR8U;1#RM[E+F[@>P=CE6(bOAbO.d96>S6VQI(-11V</3WK066e
YPNMOB7Y]J.(5364NB5W;-271>[CBST(d-W?=?0BP2eEUgQZaO_OMb/[UH]-0Paf
Y147]^+&@a4.4^U11/&e5G2=(N5].d..B?PdFGH&##6XFH=YP<02D6G=d@7P[,CM
+/EO0UHU&18OZ#Jf3R4aOX@OM&NE+])U@.P#YA_E?1g8Q,,2/?EV[NHABZPC\_Z>
P]^H#5U3H-=-S.4:I,:4=H43U[2/?ASDU+7RH]WJY@])BA:Z<Ug,GAbg/)=^RF-S
B/RYFRd7ZU92E0>S-cN-37.fHe],IOK9aP^3<gL,a:\BA@Y(1a3S+VEH_b#VDDVJ
S[-0)#DcP=SG3dK)QY>47/.WG\Z:dIQ-C^1(F\d;(U0,5+)E1YK8DCf_E4>I3ea#
/FF^gZOcXZOgY34::JI;^=Vc3OfM;/O0J(XGU+EG5.]^7N)^Nb(Bd))HA)DgFC#-
U2c_HT+ND;Se\aTAW?:3>WEXMDV6f_AM/cDc@C6af/N6[#CYKBF26O#VA&S9a_c0
M9;^7PRGC3JCI/g?SCYJY2NV=(?>dZGEU\/KLFZIDP8.ScUG/8RWO(HQ9B.84+Gd
BX.4?#NeKKTV7F&cfA5dXD]UXb=Gd6]X<G8F1/\W3GWL;:54(/5?d6g(b)?A0QWM
J43[E1TF+25bJ]7S@@MVLd\LcD1E:OX/>7Tg.8g-\\H582L,/:H#PUS2+=c.4U-)
_,6/O@9/HdIf&VFN22LT0C@CgG(?AD&7AWcO)S:-d;)::+E]:bZ4LZ_>Y/WN7]_7
+C6;_AY+CP1^.B#5RNPCGb@B.DWLO0L=@BIdM-:T>J[5+ZaNGc.cNa=UU:#Q[/WC
50QMgQVC9bDSGg7CTJS\;BUgU/d+T)QNC;VeK=LX\7S1K_+A24b(BX,-M.XIZ]9B
V;_aQ7_][E:B6?6-^]5b0/=OYDPR>&P7?/QJgV;1JS;6SeX41TO&]<bUDX1ACLOT
^eX_CA87@Qge@K+<XI<C>3Ea6bBQM[M4&b]\+LK;JNT5bbdT016;7GUWS/S.KQ8\
11\W=gIB9_Te=;Q4T-E4+#Z^]34/AOJNJ6JfTR65:B1fAcDCP&(P;;Z2ba6c+Me#
&)EG6?KS::\IDa4]gD^gBdfK[8P[bT38D03W[5C9<WBEG.+NT1CQ^0)=D>FRW\fD
]aX0c).LJ]UXM9;QfEU)c:VUO2>1b#GX3afF(BV20B/U2HJ:&).@0=+.-MN._3Ve
c)8^<Udg\O+TG&;-]#)SY2^\eO8[:PcN,be;620-IR/K9\=(TSWFc9eZa2J(^a2Y
UB>Yg(eMVU,?/T(56ZZa?)_\]ZV/NWV3<<]BBCE[1SdU=JKCEQe)T?COMg?T2cNM
Lb376W&a-TWg<3B=\W08W6C+RZ/bD#32[OKf:G52YUKJJQ-4bF8;E6ANaK9gS:N/
NJK4Z&Qc+H;G;X#F[G_83+8A0:d[6IN.KUG<UE8Q?A0EW<2_.:T(&9C(6Q/?2g7e
06VZdgXN3fZE)6d&9V6LgQ^Jc#O)BL6U1#d7]^7+684AV,C+DTaSCPX64(#@;A8B
e\><d1(ZV9Z5CGgH@/EMHA5X_f_8W>S3K4fA=.TY7OS,,CLg&N#20?IF67cVM4J=
0^>R(IXJ)YKgTB&CWFMGD?;VV=gMD@_-=B=OXH#I>+97].J#JV6e6DRfeF@AN5L7
8XJBCaW&D-XL_UNX#)WLM/Tb4=0YAJHQ=c=F\7BIUCf&S#;D\CdKaD@DC]]&N;Q&
3bfPWg.d_@7@^eaK(&RGfA7<W1M3Lc3^K)?F=1.I(cf3X<Y1<(g5B5bUTNeeKa\f
(T^P[]Y,06.S5?>RY\2(BGT+P9L9QWQ4R,ESg87(NC#/0:M@>7-(+9,#d0/.4=J_
K<C2a_\CMUeDP;fAT4;KPdF3>,9Z5(Q\F)cC6LQ[eP[g(XMF,JVSEYP&@0@K<9BR
=Q0>9Y]^g6dA48.6eQf+96TZ)8+@70=cb#fT&[)NMHR;2d>UF)>)+BNC6W=&^[WC
aH)bE6/@##M_,/8-5IB=PI5/7a#/:D6L:;=Hf=JcT6bD0:gQfJ(BT\Y-FbK3)]2H
(e_-Lb1K@&@>GSU,)9.9M-O7LD,&]9WIE2Ob?>]F67OUJ.P1?XDUeBS9^FJ=^c=O
0:E5LD7@c=EL((NBQ&76R,9LdTKDRI0AUE1]9W\Y2)e#43W1<A5LA(>bN3b:6C4A
T\:QV^CP3D1P9437B=)9;=/b00gGB/F<\2,P\@#36\P[=B0CJS4B\8I_WVS#aa4#
2[G6M@YYG_+a=HE8_&HI4;[Lg#:67eY=2XR;5P#Hg+b+;9d=/5_U>8O8>/LWd2S2
@K;Kf+E6;&+LR\]F\eIEbAg?OG^Ga+3g.?&#_B^?Zf2/J]M_K_;c<cC??WMX?0Z7
8?=FI4#0>(#SLPPQ529\U<A#TaB91cH,DJ4+,VOdA;K?E\c:cI8c4RLA/8(NZAQ3
XU\F0H<A8@^cd8H_(fe@9M7&RRXeeM&S>dG(D#@/)_>#XSggOH\^#de7d_a63Y:<
4Yb1)V4cd)P,?O/e@^@SOG8@C>9?U7[8-FWO7PS&\gMf&(5e8[c)ed->g@8\A-Z<
/b1U8CQ.BR]MQa\,G94^YI;-&.Pbc,D:1WE(>(NY?XHYTUVE+-dZZIC&F^Pb#Q9H
6)//ZM?)TO]bc>>\PP/OG>JEU;4U;781:9V@bYLe5T3@J8,,I3L_c6YPZZY;=4H&
&JM)&?EA>Ub(@^JFV3Y1FRKC3J\;c</V:Yg,GOJ.Y:AbaZ9)O6C0cV[)+Y/+5dTE
AL?^FbRe#K&/^&L<M1U?UC<I\,-YSR:V<I)\S\UEIeT\XRG76f\PU@>6&Q2?NOF<
66961cIXKUCJA/<.AJZY68EGQ]EN.XRCXH-OFB7KfCLVTXBgEQ>30>:cQZU]GI)7
Dg=4XBE4dE?4OI5ML,EO9Gd=[=/a3V3d24:[&M-Sa>1FTe?P--U\WP3R#J/BK_NC
C6-ZI8NAFFP(<IYS++PfI/TMF/.Q0FJSYa^++c+Gc6Za7C(?VC8R>V8?-)c&5+U^
_^G/+G@67\1#b-<ZAU9NKM1;G=F<f7f?-O7f8X.]=[&\<e_<g_#:81#&&/\1).=D
TAY=b=[D+IWG>bRWd)+bLLBB8K9XZf8=^d:?e/J7;2==YH;_dOTP1L:DB3=MP?JW
aL.D0fSY)E55<<cfO:_A&<ec&6.T@CYZ[@B9EXSZSBgRJ5#RCagE,&T[eK=@U+J+
:YLXe.1C&KC:9f1J3fU,b&XTN,0GQg6315S2dW7W/g;cEb?dG3Wa2/8LgJ;EgIed
4L5e<?02GC2PK(MB+-5[PW/@dAdA11^R4>L^,FbONdCEeU=d3g3(,]?IU5TQQQ5;
8MRE\)R1U;c>+OWU@[@#C6055cCfdG1V8X4TT31gLc6PISfT1S,5/]=\Xd]>/G+,
8_95=I_+SD?K1fg_8-9[O;^@C=TaKXDE&H&W1=30DVL6_VM\7Y@Z/-@e&RBEG/^&
X&Q?O8]g)(3a8=7K\6FJ6K4QUU\ScKFBeJVcGTDM^GKDFH)YB&:,fOcF:\93XF76
cP6\MZ3=7D=>=KT:3/VSc/WX5^]\C.CPc^94@@M7@[JEbUg18NUT9W]0<41b/1U>
b1;8gQ<WLb;4_X9L=eO.-fC/ZVE,1PRGRaX#:KTF:Q,<56&dGaJ<U)Mg29HZT=M@
g?8>dD+T1gSH#0QbBYNHB[e\HFN=XA452g;L)Sb5/QK4bJ<03B#e=UfX7WEBXD^V
^+V<YB<\3c:=\F5G:/=_C]FDYO>3/NR3V9T4T&_XH-F6?IYgOg.E=5/Y?8T;.Ucc
O)1MH5#^R[H4HGd:c13K]TR&E#P<(DCV<GgF6?X8E>HE_HE@]Q@aR_1KVSb&7J),
A0L,K4&3A-agOaII](5UJ3X8L^YGLRD_UYG0\Pg]LC4J#c4ZU6WY;[9=?bV3Rc,f
bCQcdc/#_F?>UfeCG&dcg?IgP/+@4fL555Af-gAV7a\:6YI>dX(14b_Q6+674+K@
?g_JWf2H>C[D&=R9.]:+0.5V^g8QXQ(VPMX^5EE,Yb>B8,WM3dO#C1cbeA/b6e[8
^/;(N-6O[VOX72b0\EC-EYWKgG1dgdB757Y2)?I)W@B^L5f?IA@X&NX?(B_:4@>I
M<c)NO;#:OafaXW;Q9VI.8+>SLEG=f,)LRUQcAbPY,f5YWT\MV:E.OG0XG5UW30E
ZdPc1W;MY-1)c;I)7RQ->g<J9d#.8UJ+bZ6Q;b/Z3;CP,V5B=FNbTR2Q\FWTdGM,
S)X7bAQ,?V3P>gT>G#^b/3d82[1S^H+O^IVd/dZe#;I[+ZY7;@.<D\PXA2,MPT:)
A?]IeO=P49bIKA.^ab[5F4-Xef:.-1XO@=6RB[g\e<009;)QaT&&ad#N.#/?g9fa
^=KeF[8IB,e6N1PGDT8GgYNdB_g-30bBWF/LF5]==KPD1SQ@^H:J,=QP7G4T.RUc
d#0;Y[B^a15(8K@)_5c9&I5\f\9MA;J2,Z-6JV(0SC@BX3,(7](Q:fPW)SC^3388
M8[a&4<\5ZD3FbbK0E;_(M_N^&gc9&N#+V;fXSN3aC@2VR-T.&_C44RB6aAVS+?B
3&G5d#I\4L&aPNC);]D&LMUJ3V(fK0)TPC<SDfX&Gc1LRBDAM1.B8YVg,YNXPH\8
:bNae<T>Z;)_[NG)bU,-UV#J\2a(X=McU/8_F(Z]N5BgU@]AeRP1BRZJ5+/46G;R
U\?aUcCHOddZDK&?QbZ0dQDOY?M:E6g(GZQ^,^c4;5RXHS#cQN0]<^(-)<K83=(f
.X6QcYG^?@dU>gR-V#+@-6YcdALXM>e?T)=OX,OY]fJe#IQ6R)YI-;ffg#@c?)+C
0L+c#:dO(VRcd>P6VYTK29a]XUEgCJH]00<ddG0>&IJL;SJ9.QBG]bHQMWZ9]Rg#
)#ULBLLRA^&cZD[db#+K(WVP^&7bGHfCI4&IS<5gP_AO@c/U-2Va4?R8,]3P+=V1
T3GWC6LB8/Dg4Wa8/7M(O_.ZRIQ+eeV55WX#A>(_g@/_BM@/G0MYNOE0PP9@-bCd
<4cW-JE<d&>MTfe<Hd)<H\W2Ud0&/N,3/:V>-GUY=;bEc1aF,K\[::.2@7H<UY3)
C:3M)>fQ\aGA-b;HEVMK)>=1Q-4Z[#VOL/0TH>=_L?&&O@R6LAK0>UR679MQAX[R
IJbU?C4(0N>KXM0WM_f4BMDYY^N-E>P[ER\bHR.B6ebdLW\I-1.02S-Af/&eP?K1
O(=B3_GgG&d/#PVedQ[C/RE<-68QT]+ae4<(1;?S7f8:9^Z+\-cg4aCVQ8d8OAFH
YVYfMGb;HVU^^?>YA14&&#1QC#--J-X.LA^SS\>?>_HP3U1a&#e_+1bWgf\b9\S0
?bJe0f3HT_cG;#0:eQKRW[.CEXe>F0+Q(89U:,e6YbG5/,4HNDgAgA2C5M\Ka=Dg
Q(bg=PgS>97<1H>=L(e<;UT1?92@g0Ee0^aW>U0.>ANTD@:6Z4.2cf34<0TAUKOa
V]B:TAQ5\5VLDO[=4-:Nc2E.SD,faKC^;f)9[L8;Y_.LeSH<D>CA?W+/DF-/g-MV
]>[dd\?dU(1eV^SD:TYLMd<\IFBNL,0Sa_AEWCeGBX-:L-^#\PA9FR#X[]7\Ig=d
aWc_a)#7:(KOUbT:JI#??4#?[&SSI,97EKQCfAG4I+<I7?:B8?cd:-I3dQ[W9#A>
?8bN;7G5\6(,=E3#P:?EJOB3Q1GY/Zb(_O,cQW(KUX#S8<NPE[329CLAJZ1>>dg)
]gCZ&FAVbNR@e7.F6XCGNc^RJHX7C(d.#bcTID,C)<S\e2bf0[7+WIc4?]Mg(_MJ
BZPDaG6#(P12_QUgOUTdM&a6/G7\2:_6DVaZc@#J(9LTD0d-8EgGUYK3=Q(b;BQS
?7QSQ[PKZ;#)\G]=8d_#@\Ja4]?&,M]W7A0RJ:@C4+&:(_MI5R/&-KJF@5FU2e?d
+B?2)/e]0)AN&c\eB0S7Y)IC?\dQMPKF@P41=+@MfgCOV]?6FAF#ALS_44L.:?=U
3SOIMDa7TM9:FL<[L6IV-e/,B7#\&LFGgd1P1-Y&G>c#>V5VK/)0^XEcQH@B:>^E
.b7Q,S1C<VS4?N=^)9_4]A5B1@gI,D(EU&bd/FX@_K&38Q401f#J02Z-16cg.-CA
/A+EQR^ON1^.WgQ#Q=EW@8cP7cSUPS:b5Gc#DY:P8bU/Y?SP)P36=6R9TBF5X0^L
<.GKGLNYCdWg0&&0ELXD]Xd:[(+WbG++2XB(DO8L0,=F3A[f?BdC#[6]GXHOJbE-
a(3ZQKSbQ.Ob]/=I9><#GE[1PNTN9eO<1-&U26-<6^g>Z9U3HVT.gB8:5c1=#PX9
UdMV^DS2=J&\>&K-Q8Udb+ELGeRM/L#f,c/Ua/V+;U;&@-]X33HF:_TJ5[T[0HO:
?51J#/U\;H_NGU;Y>Z0a7H6G5f&))\6gY8\\f-;Z.M0GaNf#^DBZ^0a>eHKF)NNI
D_W=0+d8]\@DUd^F>G7Y#GO+R>Ne09HT.+>B;0/#^Eba18,M8O-OM1[/U#Z>3V=7
DMQe<EL\@fV-9M[UF29V^-UV)P.a,6+9U\<#P&dIf(T&8e=YYR7:b)LPKTKF77=2
Bg0QG\19AaBc7G4_eX5YT+,&_0D8;<[@@0D4L-P(bT+c&ZJ>8fdJ-&CNKWXY[B60
d8gbH<&EV=<eg2^6+e@]9cH]XM3U1_8TBS]HbLdQfJ)+8Lg8ZD-Z>c;M>P2-Ed(R
M#DOQDQ\]R50C;,A&U8E=@,g.H\?GW^8<:0bFN7.537KgBaJ7\^H5]>U0PK4-E+4
C;8.WSSG<1_c0N(4MZZ-/&F2aHbXdWO,fdc25;Z]D3,78K(X]=WJ+Fb/42.&e=]J
fH)aH6MfQ^dBVHCI(AG#BMK@#Qc+/I=T>=?B[-R&X266]W_PecGPQ6e)-71&(6G/
eCc;E0>(#H[;TUd]01bb=)SG9/5B9=Vg+Ke81bbUKWSA\Za[eXYK5<<Zc/(1++UD
(-^2Sd]6P@YC:@:4PK)NZPKQ82gQ^:[7fEF93a44JH87+G2g0,1DXG+c[]:F&[A@
NE6JB(.4Z#QEOWd2=d&/(0[3CE=O(\K>dE&C9S1Q,^=)068W\<:\AHYBL>J@.]WI
TO,Df>_4bR[P8O>)ZZDVBcTFF&>2?JJW:5JHX98VHGOD#RN4WJN)Bg=,9NLb([TX
bUF:HLPG8NY+9fN2E(V07c&KSf4BY@O8VY;2/HC>C6PSeHGBWQ:#C_FV_&-WgS9<
eJWF//bX2_BB/e62^+76T/K[Q4UPTP=-#]-fK^SJIZ37W6LZ,2Xf/JDR,U6H8H1N
GV1L5236D-U)=6Kc2??(BOQ4ZFKF++?9NdCST];B/Y4A>=P?NX9Db@8(I=+FE4S4
P6SN(4Z@H9ReX1dddV7&.5ALJGBA6;g^.Z_T.ME,/P[HQ(X_G7U7SA5-bNd:9W4b
12:1^/6NbJ[-d[DN/KcP:U&c.8_aCdT;ae>K]c2T>e6.<OM84M\g^AC)-&cVDH:U
FN-9a4N_DJZO\([3;ZTf:4BZ@N-f=8W\0<4b.;1aS1]4URfSEE?S6fKY#SJ;O#))
V55-F4PV?\V_eQeF-@a(&=#U)a+Ha7(I<Pe:-@d3K/,#+QH\;2,.U[SU5I@Rf>G[
R_E4_6WK]gZTY=FDNgW4[96WBFI>Z++LGg=#fY;b:FBcPQJ?R/J&C)f+Z:VCK,(#
,4>D0\FWJ?Vb5&R72c[I50UAO79+SJ)FG]UMS;^M3BGQ]=Y+<X+Cc#4P/(<J]PTd
^JTaf>]1TNeG)e0)ME;8aCAM50LR2KD@KAGecJP\P9M(8@H[Qc\9bH0D:\b0UE.H
=H6M0J><BVMUHN1V=WR\^)N?GE:ZS5GKFF;O1+TPJ;\:Y[TF;\WBWO?=_B[;#Ua3
9^50GS=.\&(),;0N(c(DaZ>W(M6eX#WWJe&Nf6N)#+dgMM&fGMg4H3P[=EDY<0KM
Sc7YJ(VK.WHTI,E\(eLaN4S7\TDQ)>7^LSgAWROfe:0(6T,-32K>UV68:)V8\HSA
b;B;/RDXGVJRaV@>Ab3EcTLAY(TN_BUW7])>0VPM_5F81@YMZIKD89bPLf&^9<dg
@Z:/1PP;+Ye]9RYWb(VUK7/9PE4I\@2_URHYcJaDOJdME5+8<8dVK2B^83#;Q&(G
AL7][IQ]?Z7V[N40V,30bP^;C,?2/6_L&X/8I#0NEJXF@B_RQB0][8AKgEFVAc(f
2:Ga\N^XB=B3?Ec&^EP>P=;6U8^bXS>G44_c>c0fdYGCZK645DMI;5<c^T@J7,H>
&Q-[9J7O,>Za>]1F1PD-Se2OQR5\IY+,Y)=<-V\SdNHa>3/>UT/RB@\.X?5f;ABF
+0@U9V=A5]#WXbVKY/O5.\>GaF4^AC6gE,5/W_H+M1SBf#J<IG^bN9EC)HD(C6._
GM[\;gTYO-VACg\IN6E-[67V;Kd/bVA[\E6ZU;YH<>C,_[(-T_=UMJ#g4^AWf_1^
8:&J8=.dB8V6))CZ&^3VEZ:=3NE3:X_(f[[[^ZZbNNN&c7D7>J45_JE&UB@?-3&>
-TW(?MT9:MT]W3RP6a_A8_6QGTf62PC(NB@,FG^-Hd>F#.2U[O+G,15,aXF_KaM&
](8e;CDSEJRG;M-SF[5,FU,D/3E4:[9))JW(I5>gT2KP:gUa;a>QBLf;9f.J&7DK
O=8)eN7-59P=R6L6&S@UVBI0C:U/CX&\BN\dc/@SCI]@0aL/QEb5a-Y-<>/dG1L;
c6VOU=EPN>7W#Q&:)C2/Hfd]3WA+)GO9W8LONV06DI#VBWE]gLg_PZS&\EC)WJU0
PS7&Q<4;18BBBL8dV;<PdF;;#C,#5PV=?]d;A8fG@T#XKa7;YB/2T-MDMAgLBDV_
-T@XEa<SG6aH?b@,&#>LF^L10B8/3P(_=Z5Ka@#26(Q]ER5V9(/KO#\E>WDabea[
(H]K#0(cOQHZ060\K8(&L,(HG##GL^9QWNQGC?8BS2]R[5K[AL]560,2JRY;PG;f
#g5UR&&)Te3GWY7GVS7gee5NWRNdfOQc[#(ERg9=O,BWT]EC+BeY>^]I>FRcW0Eb
Y>Z:6R830#BbFa.CD\(5Y(\FCB@TPS(7MC1Y;XUQ;]YeS&GbD-,JR47D442-;3(4
[]2J[EZQ24DA0]C(L/Y(E=TScX7aXJ4=JJAE0M9]#P5L#<<Q_G39U?D+:N\0[(_R
0JV#D;0D\Q]\WKH:3]EN[H[.,YP9E)d7bD(_\0VdePf<B+PY&1>P6,7(95:@GWAY
FC.\)Z@@M<9^MaAQ^1]1LJH^7A5<7Y-E+0KBc=/SFaZDFTQO1CQX/^-0OB3La[&K
F:eVaUKZF]4?W1g>@B@)\9/[X#]-(8=1>];=I+\5T9@>5C5&FeS9fNQecbNEED<7
=b^6fS>\7YOSdCW/&I#=Q+O4(TL2Y/32eL/@1CfMRUS3L;U\#;f/@@F#()>2VI6a
G.cO4DDLOC2Pb)]]e(T)C(DD9:LXR5(8Fb.0A:Y27QC&/.AGgA]CVAF^.D_B)]E\
bQ?7fP7SAEJR(FbGOIIAO?d^)W#USWF_0:H_T,B96FZ/2=Q.5D7e?+DcIbaaf98g
@/G<>ZfSfd1DXBO;/,Og&Ia@X.g2O=3048MC@fV;QBE\1Q0<74=]-e<]AX-aE79f
Q)7+S4M\5KWM^(/@0(f;P0@Ne16>G#Y^IL[_[32XC,aEJJ+?Pd.V^332ERe?d>DK
KO:C)RAZCVSJI_>(8OEI#EL?b/2D(FeRAN<?B2]e2(&/LgAcS;a2@N/KP;P-+R.C
P)3<b@7O:WIO<T8FWW+AM:3a:)3UUCT:e_Y;PD8:\]^=5/gd+BaZ#@;+C8Z/5)(;
P]EYPJVOY@QQa?E/XbWXJ4[NdSN<JcX=91B:gUcQ6GK>V,O^@b\2ECWQ^#V]>@Z1
\V&)Q692LAfJ)geM@->_3Z(]XP]E]+<J8M&IW)b7_JFG-?@8J56P>b3;&[C(G4dT
^f=_]C@95e^.da\5D@=QI\S^b0dP[VaXG1SbSS_F3;,@@YUZ?XV@3=DSME+F=8_4
_.62E))WTM0P>.P.SF^N:RLa>HYN<-cEEMN=Se.Sd5ID^ZG.EM2;/<A/cF(bD9EA
;OUSSbBf+3c-3N&/USaG//LQAI^(fLRROeQ-@E+T:Sb/dfb0.#(5]?JMc0Va/]8a
<-9#0eVOO,ZJG/)V=KfFGF_RO)F^;]E#bQ-dM:gI@0^8DfbJ0aC4<Gd4;JG;Hb+)
g<,g.fQ_R1cZB>cHIaZ?T=STb>+XDH3J=e0D5V5b(G=FNf9d=EaT4L<YTAE-G/O8
KF82;+cN9XU<T:W/[R0V-[_6B)H?5cX@522aFJ:0R8]1[&9&,L?N6\^):15=^V\^
fTZE[J:I4-DLGBHP?F7(#5BR4@FT6T\Y2VS9R&HOS<1@TP#^#b0RNU3\T;?P7/e5
GA22P(=\J?#-?C>WI9=c?HS-B4RYcb1<6LaFC/GfWZ&e+0X>.5.TVd@CAG&L-LAC
C]VUV\N:Y?eZLWGb73a/N\8HFOG^B2f<7,9V]MMUHgABZDaaK+Haf]?c#&X)c_U/
^RM>7XQbFeC.?77-CU6PI5bcSW/&WMPVZRWILE79Oc<73#,Y_V-,0A-eX2O;OFEN
7/]-)+SN=V:eQ3J]gR3[-P[bED=SP,.^>?]/Rb&>D\V]JS<US6;]S@SN9F:Fd2-V
GH5d_a5OU2LHb]:Fg[a;[&U7649P?N..JI?8Cc.MK3JK0T@J(/;&d+C=S/O5BNY3
X7=NF85ePJB-54QUUTHW;3,gG0DU=HcAg?\/O)>EFW:)(RHe\BN;-E^(TL8;J#BC
gWF9GBOVC^@YZ07WJL>3WIgV87]0fY3QS(O^A9Y\RX#g9EdM<&g/-99:Ygd+&#8:
W[3(/#M)Q+JM9XdcPMXBY>5P/F]R=ZT<e;f/)YI^9/b7ZgV>-f=PC4PKJ,f(FH&A
O:E3a>0<9O3@E;+:L-g9D4HGK?I(M:T>,>/92VSZ>0f8.H>I3NE.9NPUeXR-N4L4
K79G>/]7eM><SE1-02:=EfOYYf,f?J0.N0M>NbO=K(cXHJ(_ZdDFf-#G.Ve?^0BJ
?-.\B&A@3/\1Gf6>b^0-(X7V?OPddcPg7a;TDE_>UMC,(+Y&BXfHDeGg878IZDJ9
V0LdEP2H99LBf+XeWT_0fYY]GG53F0+Q5;?FE+J?<K_NEF]8-WaE/N-bfU<)^Feb
K/?52I.XB0\Z/7VULOE1bOdLWV-f]4-O\N.=OA[8BI&M@P3U=/8@&MaT[.@+K,[Q
M,.BKK;;SZbM)T8EabbQMgX,ACg)NXbTC-8<:UQ(<L>3=^eDE(O?-Ff-:g.T3NMd
:e+F_(1F0FEI4fAZT-Lb\LS2#+,7V#A(_FE#C6,AB6E/6c;d5.fUWfDPM_7A=KDJ
80,R-Q-@=Z2:EH=@HZIgW(+#Z+M18X+fe_MgNCf;a9<<FF0/ZAXB1CH00,a&4e,d
e:8<d;/EUgH]VS)_(8H-06KV(?S2d/c24caSeL@>aQU4:bb1SJW3R\8I;Y3YSXZB
?]NHcHe2Q;H.)HaTZUGe&P#?.V>1/][bJWQ+1/e=EGZCQga21F>c<?Q.@_AA(U75
:84SZ9@W6CXF2SaZfd+?0G6e0e0aI8WKDBDUb/RU.QK^8>H\G<3+6^FeIZ>eQ+[.
S(MO9[G77S?HNb/\1X^VgIOKA;EE396(eI&#bW3\;E(ac60P(;a:#O_7JTgHg:VP
eSRT@<a_OO)@XMMaYb2D(MH30^YUY^&#3FANHB6.B\c^6c=FfQG3XUX\O\JJ<SZV
Vd46(P<dV9YU+J+M2fCXeIH\BNe1RcH76UT+19@FbKBa#?g@+Y+H#g.c=CLOUKM:
8=EJ+\&WC2-,H+0]Ob>O]MX13?^0.G-e\@[.2?g8BML-U1.<;bXS5V6U1RbUPPS+
/Q[99M6DGMT]_Oe5.b##f)<@^[_/f]TMKgG&M-HSMKbV\FW[-JRHN+_A<c6L=X4L
-FPfg8a]9/RP;=PMF:Ha9:GYJ0IZ<e,KGR^b3eeDa6=E_2F?G]5b419bbbO3\OXW
UKM.3cL2^:-Q\46J/:NE/=;_-R+J3fG@&P\F;R,82Vbb](1[=N/PULb&Gb-gc&<:
eMWPZf//XcW&2_YI)RNSO@L1I7/[CbS&/(HJdS2FXKf7a37(+[&10[PKXMSQH//a
b6<SJS5^@5Q+C(-aC(DM2)?Q,?aBL;I1M6BQRVE4a5(cE3-+g?JN4cI4E,(2+.MJ
5Sc<I>4GTYMO<[dEeAY12Je,=Q^P5F&P,W3\(I,Pb3abT8F-f^e9(FZ.AI>]^=]J
&ED.-C?a4F6@I,=^5cE\=NMg#V4gH,#ETeKHU1=g1[d_fZ,LS-<bb\6e+:^0YW]5
,)?W>?ZO@1fYX=e_Z99a[10e=/M53T\C0)9W\YGaWMR,_T,N(B<N]INSWN/SZ=A]
P.G^:Pb./DB2Q&EV_>d\71>H01-:_V/ffNZ:US;[-][^:cCLD[HP_gNWYgD\=1SU
@UeJK<N6W7g2-$
`endprotected


`protected
Q)^cd<IKAaa+dg[>V65E@/+8[cd;41?96X&:HC;JK?=B3XYbXAW?6)7[^PF)J.L+
^b=I[I749,K3;RL4&NJ8BRcQ(N++CVZT5EY<_E=AU(C0+]IY#T\U-;b]:-+)2bQX
6ARX?/5?OdF?#JcUXHS-TS4;D\0DBe];QgaLTUI3VRMF@6A>eJQY]DJ.3#,E+S.[
A5?J:Sa7WLE^=7QKDg<+3F>7,JZI>L-c/6cf&I=FO/IL:H[^LU@aXTBZWW)@3<N2
R7.\S9/^Y0ZNE0E@bF3f6O-L2Ae^DeKGEgY>dD_e_4>f\P##S#=&<MHd^6eDZFa\
&LW5.UWU(T\38Kg_OQ]X4>CVRD)=OF>(Ze6L0W\205Ab9&c[OQH&c]]Y59aXQ;U1
3E:X+NTePd.e^RK3?V1^7f^P5cA]F8?TF?Y;bT^QZN>RU]Fa8>E1gAT@#XF[X?&+
+/XEIdeHeQP7Z,72-U91/C<2YFD+cK_8cb(a@FT@J03ReXZ]ZJcF/H+5=aZ\,E(:
+eH:?HLRJM>QbXZ&SgZc(I5bX@)P[c:H0K>?@TBZRK.[ab0<NMb-\O[3BK9/[L2a
RTZ]efKD)>\AKC4U1Q@/c6?3E>?.Z4IG=,Hdg1R0b1.W5WcON3R)?e1Q#L/f+DSV
0bB5S,ELbRYC12E/9\G@Gd?@4O/50O&/(PJ(+Yd@.X-1\gHZ48>Kc+@/@+Q,W#>e
1bX7RG:8eFFPSd86e.?cgP-Z9AM?,=TV,X;)eB9SJT0T-DR<S<1I^55)#+NU;T]:
<9/be?:XHQ8H=YAI>9W&>:S)UBLEDe)T5/ebaA86E]]?+@-:]+IC&Y:?b+&(\#.L
J;N.LZce8E^Z;gS6X-#/)/P-W<e:1XVL)INKRN+AEAKTZ:G]RNVS03B^JeML8cYX
XcJ]G<)M;bZP(3C_=0QTGS4d\KERQ,GVGg^b5@SN1a[TC$
`endprotected


//svt_vcs_lic_vip_protect
`protected
)e]?J0Fe;0f?W2ZQ)S2E.P4[^#E&K_X9#R@W[RF:8UG8RP76[5bM)(CJ_g.S<DU#
K5E)\f@8/,_C2/DN]TJdgg9H8JRS)G:WKC8e[B<JEEFZ9)[/\(4b[<&G,M5[C_W<
=#T=69@[-C?,]T[Qc8Y_MIU:Vbb@[?;#aE/2fQR-G015@5Y@^/>C_=WURDcZ8Sc,
TD5.H.cXe8]b=+gf]</IX+OCYX@:F(>a)0\I0;BDL\23-OPHR\&,0;U-.&V[M2U2
f(H9c3WEEW3-5FGILcI.(7Og(P(^gUGMO]e,J4#DG@-[(\?&NX@Q6E7e06[ZRcfI
XbZHPWFb2F-/e&9B(:4G=&7ZX8(dRTQ\>DeI5S+TXX2>9fPWbb@/a)0FJd=_66^W
LM)S>U4,EM^J)cTCUdbXf5D0a)aW#g6)6CD.XYG7N9<Z,M+^1)UL3e8XZ5U/276)
XC</Vb(a0gOTD0bb[@=+CEPPfQ1MZ5M=Q?&#3KG#3HB=5:5K9a&XU0,[QGFXCZVD
4&R\F?Bf?X>LOR9@8Q6RJ1cWSb0;NO3&57^aLJe7<@UKYH+,JWSHLK3d.6<837f1
1;?G3-+D98/IO-dT+Ka^LTb2gG\WIHKD@@+2WKYBXU?FUG(c80g+;FAVPJFd[=Q5
N7d]?SXT/8eI1L#<O@\f4>CCXeWdU?CC.7&)Q_ccZ>@[IO<QSR;:Wea>W/4G2&^,
aVQC/DWbaa&84N,5D1+8^DI)_^-Qc@8_)([2U9C:DA@YT:9XTS@2/Vd(G<.8ZRIQ
;Y0[dI#.f1KGUU_g6-]<\USZ+2044U+d\,)U(9D07P3#B6X-Wg-BC)O<)7O0d(U=
Z)/6(4J-T0<8.Y_OLb\OXBBC@#^H1-gIV)Hg0];f7VV[>QXST>O,\Z+d-32PObHe
MZ^0^SB1LdBVZTR5-A/L?-21U[86J-D];c)7@Wc(N9&DceVQ#+5&\P:XIJWFgDO^
2;O..]\TOD(eT[4=L4Wg#D#d;C7@#,@EOe5a8)\/9We(d]8V5Je\A;N@,NA6@cWX
ZN;6]]5,(]b.VDbXY/Pe(1.I5LSbfS.R0cfbT<>9RgQ5#\f<:&e3EYfFc<0-+TEJ
/)Q,WSX+K04UE5,L,0/94[Na^;+:QN4_a6L&:N=b?5,#=LX]D.^PZ2I\U.\G\88F
5T+#S+5bC:4+#_M]Da?]9K/<]cYeaBM0Ng^8CI\0\/((-eI7W/RcG^63N])06/&=
XL1eA87b:IcJ[\K^:-KeMW=N>5OO-47((FYA4e8@>D2[a?I9;b2OWLg.2SL?Q<(^
C#69LVU^.G;V&Lc4>FL@b2V[b]U5:_CYUC5@8A)e^-b5c5](<EYObXcQ5R@6D,04
/XD]W^IK^)QD1AQ@JW\ec-0g]^]Wf;L/WS)3L],06TV\,,[f\::PJbV#W.KGd;4=
>;JH#_BQGL3\[N?.TI,6-1026(&ZE;BKV?)69+V6L3ZK2#[e23/,<]a579,V[MSX
RbLCEF1T7@cH0V+@f932eY(9.(KP&J0XJ_PP+6=?QR[VJNL]T(MM)Z8\&:WL-C)S
.A3AK>GGA8U+DPNR8>]d_(ae?93c-]a>U[I>HELKP@9&W6CS)WgI31gLE@=,4YgU
cY9a-G&dQKNQ1(KV(egNG1774B^HM;W[,>5[f695HULFC,,F+E>1DNJQeZX]PA[M
FU]92_.SG6J<4PX9^[FRZXTE_/aTeKMRG=:(H)LbTL\TV:82J^WeGM>#]#Q,Q.eF
S1D0>ZL3T,S0Ic7_L/d^->8HYL(/ZK-1Q>=bD\,)0B_OJeFc/U7U_;?-J\,>,eC4
596dE-gc1Bg&D7:9eC3.ML/2c@geT34#9@@K2dE^1cE?U4B)b/=EfAA:1H:?-24@
XcYGH/9HFG=/3(C[N.PB0IA>b.;&bNO(D.2,5Qc-A:@?B$
`endprotected


`protected
P:1[]^1Y=)JC/8X#^IDRC;/&ET.;EDDU.fC[&R^HeH8G]PdL@K)=,)-<12NX/[a^
9?930<cD,1M>/^,-eb4ba0\@&Oc[OaRCVS=)5\Q7UZN95;H]D-(_B=J0\3D2cEN&
XW\@70G3(A7BJY4d3@fg9(aY-MaH/4+,Kf7e/0N@PKPB:E:WN\X22gLD\>G[8U[,
9(9MQ/BU6AC8e^0/fU_EQCFF3F0Mb<Ha;<@N?#eIFf(=Of#eF5WPc/aB\,e0-^],
;\25geK+NM5QcSB\JceU2aUU]+^KB#CE=cKG\O#SON^H/,DEXfP_O+g8G[2[>f)S
\DRW3gg\Y(OZIaHUA1_UR#/1XC[4?0;BFD\FS7dZ2KTA/7C8Qb_W.Y7<5N#A>_VQ
Tb_9=?#?D8Oa]>/O2@/eHAG,;b68,5cYfDc71K;UXM@/+EN;aP0C-SK(-+,[5gZP
G&2,&3+Cf>?-TD,ae&d2@T?3QL.JFa1N7<ILH<J==(>GA)C6K03)Ja<BSeCLS@]:
5>-@RL)UZ/3(NCG9YP@<9WZ;X2bA+8T=,QP??^@>+A(24<WA5,UH3NP:,HUZ^/:N
ZAgW7^;[;0=(f_c;_(;=[4;gA_9Se.Z4[D^,1Kc6](d=TY(=+K>:@gfHL)+LP)9=
I#2E>NMg)RK&PE;..6\/T]Q(Y8;J?8/f5fA@Z^RDg9G)a^>&Zd<Y)\-JOK=:&g:C
D3dJC5#K6ECbEHX2..a-;F-,N?BcA/6b4;JOO9]NRg21Xb[YJ9/Z;D./<Q3G\T=#
_fg+,(<UP1X[?fI:ABO,>EeB&H@P=<-&NH57\X)\.VW3EE6<;UD>X;9[,AXG)QaH
,SY9Q^Q-<?PTNZHH_?DcLLOO.<3eU<5YMWQ;6#\Te2eX#9^1eJF,(/LCBN3L2<^M
8+M,+/K.A]-_-aQbTFbS19dR4BHL(7/+R\X\37ZR:5<NEGPCXX6@JDKb;+3K5e@W
@&d]&]^)XT(f[Y=21887D40dH0K<,<+,&W::K+]N>B]4UOdT0+,>BD85R[BOL[2&
Hc@R;IcS&B90+?V.F[W0DB<R)2&GZMNDXWR6MdP01:L6Je<LIJS/S=70d:66F#M>
,_7@1<WS=T&1Kf3J;]4V=fAY(]7Q/OX9@I(bXY9H0W(YUN#5N^NG@K,?:\:bN,<L
:R^Y3&.NS9M5;NAD)OS)+bZBf-JIRIZ8OaLV&XI34:Ib^P;7)AE;AW;0NG7=PZTVS$
`endprotected


//svt_vcs_lic_vip_protect
`protected
GXBLTLWZ7\\Z@OPQ1/0UM2d&)RZ#d6+egJ4J_9gCg0DQ2G6eObc[.(=O6aCWLNMS
;OGWV&GKe7C<^CN6/EC,8cAB256YKCE)Ec7BZ4#1(7a5NcM_g;K\TSd/MLW3gfPX
&&Y:(GC)6,B_>[3^P2Vd2I17IVB\ZdX;5-=-NN2]>a+3?CNKE>GCM[V2E(2eJ&N@
9:71H)\f0#,DBRbZX9D=BFOWNE:T>D-3Y]d:DbQA]#N@_ME]LC/TH&/2LUBdPXd/
LUgTJ:e>Z_XI8_TR)D?g;;L8\,/:@)RG;BD.OKQ9V&fC/RJ^_-TZ5>dd&B5J_QYH
J]J1Mc1@#22(0OD]U=A&V-g>U=d([3_388Q4QESF4\0N9N;a^2/G@0(2/1&PX3a.
-Te:NCfE)/Eb+QL3OP+4I^VNK[3[CUg)bN;aT/J\0&cHDDISUb^01D619Z-7=>0H
PR[/EHe&\WfCg)0M#760K^>MfWfEVMM.C<\8EXGVN2]6Q?Fgb<Q9VfeQc8.8>)C\
ddBfVK@V.=MSX4L@/bQ7fN=\Q1AB[N.T39>\O4>5F_?5X,-\d0eR4(A<^W/d<5(L
2(d,=]G[=KcK8PK?Y.+L&.7IU&?V8,5Fd>JQ=fBgY^Tg-Z<IUL<cJ[9:]1V#TEMf
6>La]P(QO0O]e6bZII8\4V.2IPK=M=a4S&ZFPA&2;:2IF])a8F7WMeXDA_LA[ND2
H8?[V/Mg3DK:5=ED(DX80Y21Yb)9F#6;2Z?;2K@SgLQ1aJUZDgIVPSP[PG),?42+
]VD)K8F\G8OC<Q17:@E?#ROTN1[Q[4QVR>^R\QH1BS<6YMg0W?F&\Y31g3R._>@@
aTP59?IX-[]^D1+T3Me3H=4Oc:QU1J_X#_3.EL[);^eCD4:5YV;_/?S/bK7QEW#G
,AV#/Oa\SFI@L\1,9:OT8ON^@BA&)0ad0:_K4.=E0-=844cI<dBR>-3BTD#c8)Nd
@4/aH]Le2FNXX.<b/RU\dX;O<9-[Bd/3?TWfS6EXcHQ11D<#>JTK(&CL1,bG2UPD
:6D\CUI6AcdaJTQJdXa9X#V46@-a\YX,E<I25)HR&a@RC))#[7,dU8?.8AK+W@2=
+fV/2;5+Od@DaSYe,_#G2(6KfC2Of?I:c4e.2R54f]BCa[fN:[3H@[b83=Ua&e4-
Z#g6ARSTS-G]/UEB(B9I<30?a+PeG^[2@UAb^3[^O3RVeIJe0SdHc_QYFAQDJ2Wa
\MUSAH\S=Y128Q=-/)HVf(=d\,,ZV2b7X\F;AE,b6>&f,/WGST,I-eS:SZF+QHg(
bX)?\W)f.>ILYgSZU[b3,^:S9<b.07B@80?T\&IEZ?U[PWd^KO.d/>1T4K>LOQ/)
8^fJ#7<3CY_/Sf1Y)?CSUHQH+aJ?COD\OPLa])M(D\L8fbGCBeI3NP]]I(4EES(E
_AK[/H&,.MD(@<+6@(g7)->2aOeJEecDV8&8QR@1eSQDP,XgB^TZOL>D:U=&&C>g
^8XGT1X3;Z<fgH@3<SYc=>Q/aGQ,/E/_5FUfDG[P.E.(1XW_SI[#>,YHC?-O&1eF
S@H+[EG1/aeF9<C@;]SEA7-3BT&\4+-X8T<^B)@bK3VY;(SN]eHJ4dWXXR:Od;2D
[98cSGX4TD)bVB]_?>X&ND9#WJJB#4L:E3I>LU>-E603XM(8#<eE)&dGK:3N+(@Z
bYS4C]SRQ^Ff<.e<[:E<<b37b0RMX[,G5M;-2@AI/#A\B5R\:N_&#(JYbQd(.gI]
@9fKBI72b5W6Ed#+0L#M7.CTKHg6IT5Qa)HK?N]EN\:_FFDdU6P1R>XR.>)+=_a^
WX-M3TeP#a:1A+4W@C3H0@d_7dUJKMAL>La:48S>#1Yfb@W+V&YU/2O[KO9^cGE]
87FX@(,\X@^b>>aR8R7/G(#D_10Y/3V6d,<ULMB/g9C)T^dfZXI/(EU07VH2N\dP
CC=]Da.<R8PDgTb>=8NWbQ.a1FXG17=QG.b1Ic-UeVU(TW#]c).V?dT[>LBJU>[^
gIce#&RI]a,M141Ua;)VLTb=BUV&UE]/U.J?Aa(Y/^(cg=Y^Z[Ef#eA(1+=,1eB7
6gBX#:f=;6N#7L,RaK8?:?eY/AF14U^d<+?NFc:O6OXM+<NH,#L&>aaON_OWaUG4
cXT)C=B9.L;X>CHA9ec3-I/9KBW95Q.Ya<T?/9IJ@/&4,fWAV>K@QK-(&ReBfH<B
NaBO-d3POX[T9M3WK-TTcB=[C&fS#FDQX=Q+/^[G#^]NBDU^bPSEQ>K<e/MGL37+
D@-<?.K+2/,W:BXT3=IdeELUXf+:WZ_\^c_LXc\3X^Q0-UZ+3CWC_#Q/M)8S^5FW
78L;MGcg^=L0JX,dXfDc_.RE6,P]0&X<IZ=+g78cAL79eU&bY+TP;:9[)ML:cD#K
1;,2&UY?-d]>JKc>Q&CL.K-CG?3B\2E7<fII9:A;1O-8+#f0VJ1V4U3Dg35,+--O
1\K9aM&DB?@<SK5WNA7CL2#T_H-4Ue5CFdTceK8H[H](2RF0U1cPIN48:J8S[[H5
6^E?e,K)D1e#OK0f<46Q4I/FQ<S+eS/6N)V.K[DI<a[ZPZD;<)a@-bEC;2M=/7?\
H0Pd1]8M<DKZ(]f=fHXb0Vgd9@\6(3T_&6E),.N93=>W=WeFM?+C1:;=f(1]-2WW
[F3,<1C9@MZAN^9NLN+3#6NM4QVa),B9J-@@\U:@2C/(/bQDD^G=EaECM:E2+DZc
Y([G#-#dEBE9N,1_FO@)Q6:,Ced..CT8RCUTJ1CG;/3\[J3YLTS][g2\XYe?6M>b
FE5bg1@,[BOMd]TdU?;4OUE@:O/E(9.2Qc_LEcScM2XVJA^=f,V6U+QTG&:W\Hg\
KFOd:65=;L5]RCFd>aY;?df2eN:5P]OK&c6<VfY)QA:@f;.5:Z8KXF2QR2MSAUgU
WFL.44a@#I.Z2A2e]b8OO(5+=gT:B;bNLc40W.4ZK/C9=U1A.OPdXJ/7[BEIBDQ2
IAUPT:2P?:YO:\Of+Zbd?(6YLHBXN9DDOC50>=KMGgWA0WCQ&:WQ(eNKBfK:NaV&
-/,,UT7)\F]W_#eIE#]XeF2UcJS\(AfR:.L2ABS6;4R_.5W#Z?,XXMUOR(:\5O5(
Oa?b(E2ERS</c19;BQXbK/VQe>;4&6_-RC^d(,O5A^X(SG2]L[\X2<:;:2T/gMK@
eMMT_<Q6a;]TP:D4S54C<15e[AEU(a\25[D71]L.1RX(D$
`endprotected


`endif // SVT_PRE_VMM_12

`endif // GUARD_SVT_GROUP_SV
