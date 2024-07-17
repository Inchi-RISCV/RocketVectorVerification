//=======================================================================
// COPYRIGHT (C) 2011-2022 SYNOPSYS INC.
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

`ifndef GUARD_SVT_SEQUENCE_SV
`define GUARD_SVT_SEQUENCE_SV

typedef class svt_sequence;

// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT sequences.
 */
virtual class svt_sequence #(type REQ=`SVT_XVM(sequence_item),
                             type RSP=REQ) extends `SVT_XVM(sequence)#(REQ,RSP);

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /**
   * A flag that enables automatic objection management.  If this is set to 1 in
   * an extended sequence class then an objection will be raised when the
   * pre_body() is called and dropped when the post_body() method is called.
   * Can be set explicitley or via a bit-type configuration entry named
   * "<seq-type-name>.manage_objection" or implicitly by setting the sequencer
   * manage_objection value to something other than the sequencer default value
   * of 1.
   *
   * For backwards compatibility reasons the sequence default value is '0' while
   * the sequencer default value is '1'. So by default the sequencer will manage
   * objections, but the sequence will not.
   *
   * This does not, however, reflect what happens if any client VIP or testbench
   * sets the manage_objection value on the sequence or the sequencer.
   *
   * If the manage_objection value is set locally, then it replaces the default.
   * It can, however, be overridden by configuration settings.
   *
   * If a manage_objection value is provided for the sequence in the configuration
   * then it will replace the locally specified value.
   *
   * If a manage_objection value is provided for the sequencer in the configuration
   * and there was not a manage_objection value provided for the sequence in the
   * configuration then the sequencer setting will replace the locally specified
   * value. 
   *
   * If a non-default value (i.e., 0) is set on the sequencer, it will be propagated
   * into the configuration to be accessed by the sequence. This will force the
   * manage_objection value of '0' for all svt_sequence sequences on the sequencer.
   * This will have no impact on sequences which have a manage_objection value
   * provided for them in the configuration, but should override the manage_objection
   * value in all other situations.
   */
  bit manage_objection = 0;

  /** All messages originating from data objects are routed through this reporter  */
  static `SVT_XVM(report_object) reporter = `SVT_XVM(root)::get();

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
  /**
   * Identifies the product suite with which a derivative class is associated. Can be
   * accessed through 'get_suite_name()', but cannot be altered after object creation.
   */
/** @cond SV_ONLY */
  protected string  suite_name = "";
/** @endcond */

`protected
DE(/(0.+(XIPL1+a5>f19I]1cI>3S=FWN)?6,7U,7FWZ=O&Wa&7.&)G0(L\.ZT=a
O&edAC+-/HV,](?7G:7=3SD[/MRI6+H:dM49fe:J.@J\8Y?MJO9T:OG0O$
`endprotected


  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /** CONSTRUCTOR: Create a new SVT sequence object */
  extern function new (string name = "svt_sequence", string suite_name="");

//svt_vcs_lic_vip_protect
`protected
5[\QgM.<?OR+8fAXI)^Q.Y<dag?:;.+W:5NKb::_S4E+)4[78b-K3(Z?&c\5WLKI
6E(UR:V>NW6?9R>JG=?2.5^ZU3RD?RdDY<Affa&8OMf2<0F^0daWSdg>_6Le<,6K
bHa#daYMMdW?9&00JLbUc+O^#GdM.H2fK4aLQHGg<T08SI.+e55b8OK<W5@#:8EU
_Z9ED)5Ec&2c9_E_PT:fMJ<\3a/VM&>]U_A5O(<6AK5>=J/c+c0NEbW6GG]>B.Z]
gF,K&9Q65W4)?d.)&(Fc7)-L[,Hf4?f?.Le[bcZSR1)g(>@.Le;de>/FRS@aMf2?
b6>,cOXecG[/]2WQ;NW]cUG]E;(bR);Nb?:&G]^?S1X_T/R>??]:7W3W^0g\2RgB
PX8<<<[D5-VUUP93WM1K)]?ZfR9b8/b9M8J5T?5;Z+;[JBZP2,])FL6AQ#Z3-)8W
C:1JFNK5_\3RU:4[T:+QG+9#(V/KWFcfR3R>:1\^:.(AWOSC/-C7fL6AI$
`endprotected


  // ---------------------------------------------------------------------------
  /** Returns the model suite name associated with an object. */
  extern virtual function string get_suite_name();

`protected
=W)67RN.b8MH<+0ZEb<#RMWe=C_Z0B)MCYd?ffGcDG.T]GHK?E396);-/M5@6EZ0
>PE7-W<.]@O>N1Ze)7NLR9Xg2Q@R\G)Kc#c+K@D27PX1bISKP><^:b^bR#J(?b]V
Y&WJ3/&B.Z/RTJKRFFO\BKXg1$
`endprotected

  
  // ---------------------------------------------------------------------------
  /**
   * Returns the phase name that this sequence is executing in. If the sequence
   * is not configured as the default sequence for a phase then this method
   * returns a null string.  This can be used to retrieve information from the
   * configuration database like this:
   * 
   * void'(`SVT_XVM(config_db) #(int unsigned)::get(m_sequencer, 
   *                                          get_phase_name(),
   *                                          "default_sequence.sequence_length",
   *                                          sequence_length));
   * 
   */
  extern function string get_phase_name();

  // ---------------------------------------------------------------------------
  /**
   * Raise the objection for the current run-time phase
   */
  extern function void raise_phase_objection();

  // ---------------------------------------------------------------------------
  /**
   * Drop the previously-raised objection for the run-time phase
   */
  extern function void drop_phase_objection();

  // ---------------------------------------------------------------------------
  /** callback implementation to raise an objection */
  extern virtual task pre_body();

  // ---------------------------------------------------------------------------
  /** callback implementation to drop an objection */
  extern virtual task post_body();

//svt_vipdk_exclude
/** @cond PRIVATE */
  // ---------------------------------------------------------------------------
  /**
   * DEPRECATED METHOD - Clients should implement/utilize 'is_supported'.
   * Determines if this sequence can reasonably be expected to function correctly
   * on the supplied cfg object.
   * 
   * @param cfg The svt_configuration to examine for applicability.
   * @return Returns '1' if sequence is applicable, '0' otherwise.
   */
  extern virtual function bit is_applicable(svt_configuration cfg);
/** @endcond */
//svt_vipdk_end_exclude

`ifdef SVT_UVM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Obtains the starting_phase property from the uvm_sequence_base class.
   */
  extern function uvm_phase svt_get_starting_phase();
`endif
    
  // ---------------------------------------------------------------------------
  /**
   * Determines if this sequence can reasonably be expected to function correctly
   * on the supplied cfg object.
   * 
   * @param cfg The svt_configuration to examine for supportability.
   * @param silent Indicates whether issues with the configuration should be reported.
   *
   * @return Returns '1' if sequence is supported by the configuration, '0' otherwise.
   */
  extern virtual function bit is_supported(svt_configuration cfg, bit silent = 0);

`ifdef SVT_UVM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Utility method to get the do_not_randomize value for the sequence.
   *
   * @return The current do_not_randomize setting.
   */
  extern virtual function bit get_do_not_randomize();
`endif

`ifndef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Utility method used to start a sequence based on the provided priority.
   *
   * @param parent_sequence Containing sequence which is executing this sequence.
   * @param set_priority The priority provided to the sequencer for this sequence.
   */
  extern virtual task priority_start(`SVT_XVM(sequence_base) parent_sequence = null, int set_priority = -1);

  // ---------------------------------------------------------------------------
  /**
   * Utility method used to finish a sequence based on the provided priority.
   *
   * @param parent_sequence Containing sequence which is executing this sequence.
   * @param set_priority The priority provided to the sequencer for this sequence.
   */
  extern virtual task priority_finish(`SVT_XVM(sequence_base) parent_sequence = null, int set_priority = -1);
`endif

  // =============================================================================

`ifdef SVT_OVM_TECHNOLOGY
  local ovm_objection m_raised;
`endif
endclass


`protected
AVXU[#48L>Ac>/=BQ&\A)I41=OFBVL7TWP\aS)8SS0?C__[01;3Z-)S3=@TfRY42
V0O#=VbY8?dJTcY\>\f^eeaGeM\G>G2?Z7XY&CI4EK).gQB-Q3BPae:daFOc0G=[
:VBN]_O>dQ]1M\1f4EHKK;9J12e<T0V_b^66>/@HGPCAVABL-47c1&;3WV++O+;>
Ze]EOcG?L6Pf1G9KJR5D5ID53#f9?@28Y3F7N7b;c\J,&_TL1)#@Qecf(:PD/K14
1VIA]Nf,U34(IJQ?_XeKV]NWeVNVdJKe2gCT3/9Lg+#E2>^C<gQCW&^cQ0D^V]I\
bde@G3H9aML^_O:?4FRU2#C[VM0Z9PFV9&\UN^=\Y]QgU#E#Id1QD&KQ/E=6W.6\
3=:N=D<\@:?:<)[.KFRZD8S_?+?<_G5QT>L9Be/=e#=RFE>Q.d;T0DXMQU;QRS[.
UM74-8AE9=SO;H4?-OF<7CZR)YV&aQa)=II&.E?VT:#@367V-+&AJ)0I&A5M04NC
F]cK8&^AXO=7A0TcMAe16\PG>XAV/g>1bBNI>G>;SV&ZZ@<7gGSL=^V4EfdeSdKL
E=C\OVY,W0DAVS3T0#G5L^fa.eMZTXV;MOIdc.aC2RN+O39PRZGU2-Kcb3K+g_:3
fCN]&-Sg/G[=Y:0+?3[Kg7dX+W@F5YAGYS4B>/K5/B\0WENcGNWD:gJ4QdE42FM;
>SdOK.G@76XKa3S[\97K6ASf4D:NKHL)PC?K2]]IYYGQ;(/>\dX<Le^S_5:Ha<c4
JW.VWV_E,.8JYYPROJMO>(.\EJRDDG6LUGX6^B9:+[VZ]g2CT=34I,#BId&QCXFE
d9ADCWXKgfXGKU#JN(&Ia5JCY@b]XJS@&9BW3SZ#dfe#S7GJ-4c^[_2M(:c#^-T+
##H0Q#dCJ@QZR_@,a>e,,J;6VRcFBCJ@<$
`endprotected


//svt_vcs_lic_vip_protect
`protected
571c^;,_RW)R#_gcFK/LMC5AWa8dSV6NEaN;;^@GW(ZGJIfZ,\Q)/(ANR&dVON@b
/4ZK4=69DcQ1BT#\=e5)]YDgd==?@)dIC&-P?\/e:88I.3KE6W\gRQ&eD9,AE._K
KC@AbC;J=6M;>,5,a2:@REC=ZPa,?GfD95K1TK;d([V(C_M\UG,^AfJ,)G/G4(:.
?Y8XD.3bC<[1NQ194(JU\>+gD,70I4R5[_C#2I&aE=X:;a#0^HER;]KU[fcG2ICV
+BDf.4,MgYPfeKOFR+COZ:]TP#A<:7dPcPV8&.-PWP1FcGGLUH:I9<-O50T_<4&P
7d9_)&E=aLA]JV[I,MAb&SYJ6PMa.RVNaBCGWJb-G&3=8bJSJG@-Y.H<?1GaMX<5
(P+@@b@I+9O#316I(M,#eN/(C;f+Q\KY#-aB4?W[W@,AB4LLVK90JA1JbBM20G;V
Z65cF2Cb@U.WJ9C&?#=W\DaLS3&SZPDc.H4.OD[1GLGK^cc2&2V2XW_a2YUXfQEI
LBZYH2\UXa]XQ3>R=?U98d[^XU\QY=:IE1:9MT.W^<,7^U0+d5#Qg5>IQH;86gE=
[bHE(P@<B>?)b1a]NaB5OP-,6#V/WGMU(1=_f;FV+Lg3UcG-0fHc>-3QN0NVLD^7
e8NKQWCCeQ2@O8V6Ac=RX7L19#Ia(,5Ne050@\c<;<)QgbPSKHa55VXWTVA-BX3W
A5/F^@gLQAH6b6K^ZH5)ZBc,B:2f_e6_d-)(@W,d_BZ^,W<Mecb@Z1,3#\M8)[.+
<,NH/g_VXUN(?^:Pa(b83=EN6YZ0-WHW;3e+/W]BO-+&NK+Z>UA30e2VdE57W9H\
^T4WC48O9-BW8ICQXT)<JA+8U(g;J_^N/U;#Z8I;O0=@<<I8L&O<_1A8F?b^1e-O
VI\YF,R)>=QeJfVd?3>XTEY)Ncbd:G,LG?.&28X5?8Q?>]K4.f[cH/bS,:9MI08K
)T=B5MZ9BPEbb#b@>&gH6:Y)gaTD76^V#J\HPcW<6g(U^g/e[UWbg5N]VMd+>?Pe
.9W6B4K?N;NO-<=G-55MOLABM)Ib^HOb@Y&F-;QP36V)aYC^ZCL20;d]+9;6\<CG
MA9+5S/Z;P8L=NDR9WL\>RTCR6.(_4Y^L<#:(c6/H2TXNJ@]b]c&1PMFWRN]c7R&
PY244UG8AaO1KGG7[)4CM)5=c:F/]3M#/aR37TG(,VO649T=JOR\.M?C@@A-&g8[
8Z2ed2e1+ZUNg-D1cfN[fcB,5ZHKUS/^fY[(b-AGV52NW.EKT_4\.(URVD=]MEWF
M>[6VI9#L/FX1G0;^>CR3F2cJI#M8VBG->3\6bGB8+9A1bO.7G,XC]/B1ef95Kf+
Tc?F0=/3AOJS>&.W:LbJT@2?5e)D(T7+Te_@#8/8#TMP+JgS/bMYGRZS[AbMZ46^
ce??aJ&Q,YFf2aQJAX70S90&&8Q(.;d?I.aeS@<2fC:2a,UEEJHQ_PDSQ9]#16)Z
:(E^,DbJ68H/P[6U^]=(;3aR-;ABPR4KYYU_1C-:?SQJ-T,648.VDNM<4N?@GFRg
,#Y2Rab(;VR2:CQ0Q[2,b3-53KI&80;HWK?]&E8WbB=NX\U]K5(+@W(=^Ce_;Ka2
]/6ILO=,J&#g(NAVJ,c;-M?6>NIYNQBXdU5f[B-B_NFe/C.NO7;#=M@<f_J>bVZ(
Q/B6&4XF.3&#QFcg+KK>[GYZ-F@C&[;IF#@2_HNcd(?_aNZ\Z/\>Q<IP:Z4A-DP3
A8PC3DX4gLS#eIK=(IKU1FY\75]HUd>87&2)R^5O-H9XS(Q<eVL6e3&6JPE]Q)7P
J-^+W<[5E9fW1\,W^(U:T?:GX9_DGWT#P+^aA&/?P:WY7O.N-8M41d^P76Eg1T2K
UQ4c9&YKc(BgI[,#G(ReDZN6<[7T&9K33DB#\cbgXAaX4DgHJ=Z[aT+M[+I_\/X\
8RWCCRHIE(PUA0CYe\Ua?-DAQ>IG]1)R]->cT]#EIO>>D3B52<O]VJ@[_)c@X3cW
:N,,QH--0MNIUXMCKWe5H4[+Z7&23,.YC)]<f6[W,S[>EFLM(6LMEbN8=YeK-8:3
69YEW212=9bQU?B#OF>b2;C-5fS;)ESK_@N[BeSe-IXRA6-4T86)g#dZ44Yc+(5S
4Df^ZEG(T]FU(#4,1P52YLGfA6GfY9@#K?c[AG(5IdBFFWC\Q/SF3]5<\4CK8.d3
cgeQSGJU8(L]9e3.g<,=.3OMPcOaaJ?,(=L@[6cVY,]M97C^Xa,A2A9:5)CY5HOV
JRb>TT:F,\>1HNUgW&2f&7]M,aOQKa(1+],gG\N5?Ne,X#0ZQ9bKP[I).-@[4\<W
]RAPg0X>3YU=18_WcF-SVI[=T(LZ,XN#,CTcXU.P2cM3F/\V.S8[J1[#RbO9B:QX
G4]2-ASS1O@])Zeb2P7FJKdKNHTL022BN<#\Z4:^XG10\e9.g68d99G]HGP]B_Da
(N>H.D^4V6ZdRHQ6R;3V/\)_6L9V()OV)V@6e-9LN^7\g?C]:8XY=B=GZXJO^,I?
a\UZWU]<.MJb=(ceI5HXJWSc,+<7X5AWM/=D;TKP>feM;S-=S7SQM_TM-c>XK695
:^>b1(-QULYJ>C\a)6eTg2[E;1d95aN=;0/a<G2N_(Tfg9eC9QJK_;5-d/@7Rg8c
(&]==^[PBa@[WDW+\SPc&9SeeK)#4GX4FXO4O:[U\dE[@0[UBJ-TWbP:FbCeJ#4>
3TCSg.W[/eUdVZX/-?GG=8:gIS@SfDO,+b&TfMAc,)0^9O\9]T1:WX/aGKMI9;)]
Nb,]/4+WMRPTTZ0SM;H_:O[&0;W8fe)aABAd2@^V2QI,UaCC<)]Y&gd7b^&T:V+5
b+PE)R\P1_-Ie@Kd/1X73Pc@1XXZE5DccT./06FUOJ^90:^Ie^,8U4b/6X-G5cJa
@MT\Qd^WOb:d@F;HK\IIf&dUR&QN+H;JYAI\>[DPUU2+F/.D+59)J(PH\43&3;+3
J9GMGcQW[FS(E@YII?#W:#67A]4FQ;A3+5LS2?2HMg\4WaLPf>G1a9_^fZbEN<62
7Va65Q6/+:5O<@T#^\N2]b]C_XV+D[U=)3SB30Rad23VG4V(#MJ<.>0\T1I6a,+4
?7GW]IR;,<KgCbT[<Ic9^G9L9:U>^Y4[D=Y,Q8J_>a\N=BV8gX.J@2G]W&?N-8eN
T[<85Qf=X7?N^+R.:>&(W>8T&D<.N_-S\:SBB5E2^b<S-Q91BgUJ(d<.VFM7BSb4
f&YR2\eVS_GYFF8b=5&b<HGX5<N;-W58Q,EO?+L,O>Ve2(b?Qc:RTC;I/EHaaZb[
]8b+O3/fN+eUTE:L;T-\Y;<A=dGC5PX&=N<<W_.b/<c?86d.NF:b;EKL1SRX.MRS
5C2->UB/1H+U7f=Z;C@\M^.ZU@4C6B?Hf=F5JI.#(29fcI)/=(^&EE8XC8G9#b3A
T\?E;O&d28=)DM_1WCF5=7L.eNB,71^UQK4E=B\:]1dS^a^-^,^aeM=[4c9c?,]f
8-+L[6KfXb8T?Qf^T8\e^))g)fM6>17RWBJWVd3^-;?C(][82H-MdG=/c8^(:F^6
77PH:U5UERH>WAaKFf2WF9a)-42CIeL8e:]38Ea@9[5L7C,LdOBXC5&3cG(E#daK
R55>KULO+@S<c>EFA>P@g:B4(V7QZ:K4@W9,a[ZCJ.184AM_#W+ZI<dOE-2<3/Qb
&eb2-/YMAO3=+]fa&EW+.^;=U?ID9gQ5UY<U72d7Y;9NbFCYL;Bcge:),[[?N&_7
>@89b6Q[P-[;bO&WM@GM7-L77=<H@5>B#CAGg,T&C&Fce7[=D(A:dWGZfOH2,6QX
KFY=7ZWUPHV^SFD@6H-RM7(WJ>V5ER>c):[HF#/=T>,[LT(HD&B\#;X=@S5YgCSD
KD<?=8F)c3<=VMe3fQX6HU@X3a-3gVTa\OdAK)2<;V7UI8P#aSQ]aY++&Z?S3TT(
F^:ITR)De&OD61GA/:H:^=-Q+0)Ed,QMRD5V.7EUL(2H5(@WM?=J7A2gc#VcY.-1
6eB)9N3b3^1aV=9NMB1=Of.NA.2ZQSAINV9?A3J79[]\U[.B>)b7Vb;60BY)[fXV
-S\/IAfB(/8&\RUB]dJRN/I@@]>,7?IeZ>GC/O(&6BY)7XWZJ15_Dd1/TN(VZ2RV
^R8EKFQTPYQ\UO04;fPZT>FO=-.);TBbT-50F^BB([YCb6/GR04Ae)F?P7.6K<LM
b?,RMQWBBeRWd^(?+[Da2]aM+M=cGgI_78^]W)]aA9ND_NIJZB1C=N7Y&F1G8^^=
N7@[Y2,?+]^KWbGZ.T2>?ZRFB8+N(@f\9Va)aLE.BF+eM5>.T+JGL+RC@VS)])eT
\5\f3>AaA?dKO9(2]9HOAV^4(NeVBKV;GKf=FFgA20D0/OAOBY?<;fU9d2C:SA1X
>&FF_)]H12Pc6c-]BJ0YT<d#\6?\VGBI;8;_IM#.aHK^QgaQLG2KZ?7RAR4@RXQ1
5PJZPOX[5]KUd7bXA^541f\>3RKKIX/V(K3S85(J49EaX+Z^K0M5VU(-B((R3188
UOO+^P.Y<Gc(>H9FJAA0>9KD@<A-+N4BH<^WLE4@d5NbH5--&Qc\cJTH-?QLb(Lc
OUBK28IX_2f6SKb42IC:Y+cS<A<==?651/3M7QHITBCQe5HEJHWYVX]]WP.CTgdP
BC4JCH#982WQS.;/#0F14?L/e2<I_Ge;-HUK)M^3bW9cF7)#[OQ,TS(Nbg(&aL#)
=#dQPABX1MbECHZOHZM8]KY&-?T]95J^M(-.-<e35ZN4VG<a8#5ce.8bg/WR&I&+
3.>^d>G935&4cYM>U,KQG][dbbc:abMaP.XOKdW:93)M@Q+-[TcfQ^W+Y6/^)JVH
,<-<_>,[,g4XK-=6BHFQXXQ+=,eC;YH(EB]X&Y[^:CPV<RR#WFd@HCIDUb1/6(.O
Gg/_YA80c@(4J,Z-?<c<-B#(2J6&:HU=8.2X\@8>a+8_&&#[]88E6:16G&6&=M;L
[1Kde&aQ\SbQ=Te-H4BSNH9T.-VaPf#(>OD0,C.6-C9UU/\16OR3-0e0_),<[4c^
K>^^[a\Q]7-Y8\RTL/NWJ/NN\H_K_)-_7bW+MAZ,8.8[:H3_cXH:V/@g(^N/(;4#
6V.RRAB:KcOWY@YE1E0)S.aZ,JfSM&.0V?SROg;]g4;\4?D^fPc9[ga?E?9Z=V)a
->^Eg8,OeF>9&669L+S.L-#=J_\_MVM[M?Ig8OU;TZ[?+O^B;GIg8>d3=Wc:93SZ
4C7D-Y.)?J^,d/JDg=T;#W6#9f>S20O^F^aRHC79\;I0bGO^;,I>:KX0\MTa,JaT
QLWUR7Of.&3PgSGUdOVfW\AOdCR^7:4PS8B>P2(@gWHJQZ\@V^/+ZN_;X=I1AO:&
9cED00JdTT&#SP(HRg.(g:KUY#BI3SD[gc#3JUYJEM>)Kg._b5b2FGVM1KOeGH]P
?=dX73f7S0O3<4T<QUKSSR9e)/TVVbZ_:;[b7a^H7L\?A6+c&4b2=eZbFB_P]H_N
NLdbd,P]0d(]\cbSN0Lc6_U99AaXF,OGI27A-0#K8MMO2:.[PK)JV#9+BeML(F35
_K^,aQ\Q?R&&MaS7PZ90_1LV0NOOQNHW?QPL)a+:TcP/Ra:3&SR7]4X][X44gT(3
dOEB4TWgHET>#1gP5bba^DGIQ^O5/1X_6[]^KM=0../(S/V3f0:U?JZN=<8ZPVD<
;N#Ef\Ng3B>O,Wd^^6FP2:Sc7UcdK:UYW=&#&.\1XB]UCAOA^23Lb=(152D8-.B\
&@U0PNQ8N]OG=6&X-]OGD/N<(FUA+E^KR4QLb#=O/P?U-?:@)@HVgDc6O5(YP9Q^
E4,/=,.?]M98AWEOZ>)H7c>?&fgc0]H&KbX8bcT32g2=;a=8</.<Mg,N0baQI#>/
6<KeN?D_7gD<U)I.)3LKGJQd5[ZII23UOS\.D^e82>WCg,].HJ@[c-TT:LA4RR)S
<K]MWe4eE81KS1Xc-]f3PGD9#Q>E&6^)W5M(bYXT9;\2YP8[NZ[5:X[:F(a<7B;:
F/;FV#De+.SC3_-6#bM)c/11-Z+b7M>:XBBK<\7L3.U-V0::MAG@(SAa/gA,XCX^
#&3.gZ1APIO_C0<?<Xb9=,YO@.ZKB/Ie25;XO1E\POI71W9d3c^Xe=]5:>[<;@HR
>b[6(^[+g\aDe@aS8QA^Yb57eRN3BEMZCfRUP=JFd>_C6>D.DW8_<(W#f^I:KUT3
0A(Id1X#\)b.;QR6O<X)Z1<0R6G,MM_+\-#M\[G5fDM9aV,?Se,[\c/>D<^\S2QD
G-GXC,B@XC\V3(X=,<Pef&dSVK2g;DPFSZ]?>4J1P<#5f^1&TS08\>aMKOS_ZJ_5
;]7Sg_IJLNeC:+0Nd+C7f,T8027+)WZHbI#68>S.\H\D+&=DS_b6?ba2?V<TG9\(
DSLg04\B]0[7A^5B8Y3.AP,->[0bY<?aUVHPYg\e&8959KFN-N\N]]&#60M0:&+I
Q/HKRGeJSK2-+cS8WeVRQWB^Z3/ZYbPfI]RdM;bRc0^VRV,8M-1U++G@T#JW4/ad
F#1EF=;ZM)B67V4PLFBGb6SYJ,NI#_J^AF&8L32)_F#@WQEJP59?W+V-[:0,0F?a
e+J^TP9\/0&2I>HYVgIb=<7[1Vf\A1dXGVWbV;]0]TB^+Z>2J9RU8(0OY3bIFH+9
K4:#[d^3B)O<A(&eE062RPY^RWVW;gVJTde6ECIRHOHJS1G&a:U-W)dD_fQX\8:\
O[\;99M+7?^F&?_B2LX+bY1_GG((R79F=$
`endprotected


`endif // GUARD_SVT_SEQUENCE_SV
