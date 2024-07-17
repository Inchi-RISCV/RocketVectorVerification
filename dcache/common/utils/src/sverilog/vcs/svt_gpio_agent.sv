//=======================================================================
// COPYRIGHT (C) 2016-2017 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------

`ifndef GUARD_SVT_GPIO_AGENT_SV
`define GUARD_SVT_GPIO_AGENT_SV

// =============================================================================
/** The svt_gpio_agent operates in active mode *ONLY*.
 * The svt_gpio_agent is configured using the
 * #svt_gpio_configuration.  The configuration should be provided to the
 * agent in the build phase of the test using the configuration database, under
 * the name "cfg". 
 * After transactions are completed, the completed
 * sequence item is provided to the #item_observed_port of the agent.
 */
class svt_gpio_agent extends svt_agent;

  // ***************************************************************************
  // Type Definitions
  // ***************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /** Proto Driver */
  svt_gpio_driver driver;

  /** Sequencer */
  svt_gpio_sequencer sequencer;

  /** Analysis ports for executed transactions and interrupt requests */
  `SVT_XVM(analysis_port)#(svt_gpio_transaction) item_observed_port;

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
/** @cond PRIVATE */
  /** Configuration object copy to be used in set/get operations. */
  protected svt_gpio_configuration cfg_snapshot;
/** @endcond */

  // ****************************************************************************
  // Local Data Properties
  // ****************************************************************************
  /** Configuration object for this agent */
  local svt_gpio_configuration cfg;

//svt_vcs_lic_vip_protect
`protected
4aD:<5d?^QJNUDKZPEUYa@Mcb?#00F,^;5BSOS#[/?];);(KJR2#4([?SD8+G4PP
;OC1MHd+QJFZE3QS2UB]35\^L9(I0e_;6(d6BGb1[MZcL\&E;T/cU2d]K:6#PdRK
O.8P7&I89#&T_gL[N/K\,U4+,G;RQK_4LHM-K)=d?XNXT<]P&NMEOL-7C_@,SF+g
3,Q.K@0\cg742PJPc@bd^P6MI2bHN)bXK;6/5b0>(9Q--P1<,L&a/b-7M$
`endprotected


  // ****************************************************************************
  // Field Macros
  // ****************************************************************************
  `svt_xvm_component_utils_begin(svt_gpio_agent)
  `svt_xvm_component_utils_end

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************
  /**
   * CONSTRUCTOR: Create a new agent instance
   * 
   * @param name The name of this instance.  Used to construct the hierarchy.
   * 
   * @param parent The component that contains this intance.  Used to construct
   * the hierarchy.
   */
  extern function new (string name = "svt_gpio_agent", `SVT_XVM(component) parent = null);

  // ---------------------------------------------------------------------------
  /**
   * Build Phase
   * Constructs the #driver and #sequencer components
   */
`ifdef SVT_UVM_TECHNOLOGY
  extern function void build_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern function void build();
`endif

  // ---------------------------------------------------------------------------
  /**
   * Connect Phase
   * Connects the #driver and #sequencer components.
   */
`ifdef SVT_UVM_TECHNOLOGY
  extern function void connect_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern function void connect();
`endif

  // ---------------------------------------------------------------------------
  /**
   * Run phase
   */
`ifdef SVT_UVM_TECHNOLOGY
  extern virtual task run_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern virtual task run();
`endif

  // ---------------------------------------------------------------------------
  /** INHERITED METHODS Implemented in this class. */
  // ---------------------------------------------------------------------------
  /**
   * Updates the agent configuration with data from the supplied object.
   * This method always results in a call to reconfigure() for contained components.
   */
  extern virtual function void reconfigure(svt_configuration cfg);

  // ---------------------------------------------------------------------------
  /** Convenience API */
  // ---------------------------------------------------------------------------

  /** Execute a WRITE transaction on this agent */
  extern virtual task write(svt_gpio_data_t data);

  /** Execute a READ transaction on this agent */
  extern virtual task read(output svt_gpio_data_t rdat);

/** @cond PRIVATE */
  extern function void configure_interface();
  // ---------------------------------------------------------------------------
  extern virtual protected function void change_static_cfg(svt_configuration cfg);
  // ---------------------------------------------------------------------------
  extern virtual protected function void change_dynamic_cfg(svt_configuration cfg);
  // ---------------------------------------------------------------------------
  extern virtual protected function void  get_static_cfg(ref svt_configuration cfg);
  // ---------------------------------------------------------------------------
  extern virtual protected function void  get_dynamic_cfg(ref svt_configuration cfg);
/** @endcond */

endclass

//svt_vcs_lic_vip_protect
`protected
10dg4K_e,I#e>V=\DJR:Sc[B#H_ZL;IMLQe]dT0EA<(=0)YUgP/M6(5]0/VGO?Q:
3OUDYN.I1+b]I3:>UD1ZR]<;GW,F-@8TQLfA40-8A5MaX9?S37D+cPa9_>\+Rg8=
=7\aK,D2CI[[RO:S&8)N_)7+]\0dK.Cf5MBb8I0fA)24;>d5ABC<0(Ue7ceKB,][
UBf)^3SPW>S2I)V6bgX^.&@<5>f-R6_5@+6G2cKPB&Hb0>e7#YC/QL6Qa5KLZ.<)
0,ZIA67Na0,2Xg(^_S@A4NCPT5fM1FAWL3K?bXPR,MRJJQ-\7W#IYK2Z?6;DPSb)
a9LNeg8\3&#@\#[ZDe6.@+AAE=-SaXGb>[4RP77.,FNQ[JA\^SbHRQ?\UGW^=a[&
;?TQGS5^,V,MJZL9B^S6>e+b7TO+ZT5O/Ef5I@/<_1a>H25S#S=R[/17GS-W-fNZ
BHORILSV64F.[42;07\M[Z:1Z;@b6\=SB#c5cZ4;]RaS+\9H\@\DSM?0UE-0]HF]
D:[A3aeL_=XLSa>TfHA=[MEB:.FNQfEa9;>J<L&Te2eZMd&.M=BBR[HK^=M#.=]a
/53aBg6Vc9F.+BT9FEgA8HKdaW8-9L9M2gc^>=(=^I[K\/X\cZ^QHWcBK(J)>))@
5NcY[?:X=0S>7g4F406D,>6H3cKN>OaXMb>8^]D2PXZ9JC<28;Hc>V(#[L2GSX]M
[5,B0\A@e9>V:b69d\bfCATR/A7F:WYIBX<eaE]fR7R7cS^LB4b,A@06P7@)60Nd
)b5@8XeS5SF[/6dQ)[QV]>\ED16B#AEIc-==a@9RNF12Ra&d+)=Nb@L)&e,_NG,7
7YG/I7->5DBJUIFD:&S1A:&aZc;E1\,XJ)(KHC<X]MO0GI13-C:-Dd0J^8R5?U5\
TB(M3c5\NSG[ZVg<8fQ.gVR6B]IZ6Z72BcRY<dXb7O(Bb\<@MdI7<I:9^Oe9^ZEc
d#KeDJYfMeG1E&:g:-VCTgdC4L)GD@;=?L2Z-OR0V6?@[.&L652H8d2UZeS,#RT/
W?1ATbYY_cYD(W;LMDY8>VX]3V6]53#9Zg>Y:9F:eC/.7:WV3LJ;FZ\_gYaaG2a1
B1M[Z/E5<37DEQ;>D(P6,?T&+dT,\c=G?0gdN1A-/V[cf(K=P9A:_;6)U^^U,CP3
YO>>6C>3T32Z:@#J9YDUBf:U\a,e_C63b@4aPe[&<><Fa0UHWIS,JY0738g(H^.E
.4V^TJBPW3eY]&#&)AT54b:4a0Af\DG-Qa0/N&/L(d(83#aAD&=PH]MUGV?aAaf0
A[=R0R0P2fB\d=0/WDR[?I^?]+.,C:<)FJegeHT(a(ELUAOB/TOaYDEe=7RQG=9H
\4-U-^@?J2d&d2I-4N,]58[OKG,<7#e-89/0LSSR7LJ,Oc?;CK:I?\La+0d=)]>R
?@/D+<>A<JJb@<dc5SDX:/PFT=P,6f6A20682++CNe+@Zg7AZ?(9BcOO[f14RT:e
0D:^[P(,1&&J3EPO]EEJG0C9#<N4&U-O\+SR77BQEW]Md(73BEg>GL=a]7<a9QT_
^f((GJaA#L6E1:RSbFAfGN(c7BS8R94#VL\R;RA&1b2\1aX-.:LW_gM]YCA@B>4P
2:L;V9NLXAU91CF5gW2Obe?J(QDX3@=T2&[8\-P:(H,NAHA2M1JI?6>UQ/g)C8g]
<U:(>9AefLdQ2\E;Z>&G,^F^9^+c(XIa1DO9@R,8gMK,N0&<<8W4bGK/J^0E)&B/
F(]FRcb4edXS@ITIY=g0T8AKM1<;6b=X(f#PPKNPdPeNYAV5YRR7gWA404>GO^1W
JHDd/TGFD#ZKE[(50RW6-]a&9gRI0N#Z^_C;\_Wc:Rf;QA+U^4aM;7aJTf(^ce\(
.Y^73&VBSB.SW8L51Ic=Od2c2Y?B>OQMJFA6]7C11(,EL=<HXPFFgLNGYGIZf)<>
g;(8@ME.DFIV(LV7D>&7@d,J[<eP0cAI7/>=Z+^08LaN5C2U3LD^2QF@ZDJSe2UX
V18,:P=.IS673&D[+I\K.BJ60U/IBI\3g)P1K4a9_gB4.\]E<<&-@Z:AM,VK7IOZ
0U^(U7M=G5#:@=+3.I9GY8E,_4+Y7[J5#SE0T;YK)HQWWTDE36#&/AM,Z(dT3d=D
#VWLH.+?I\.AeeA2E&4b(6;)ZV2_^cVF/NDM+=\e@146>EDP1Q]&\G/gS-3\K>8a
#Uc-_g\+NNGZ/aAYC.:9#_c>LZG#2:e2XEU8(S4K&:8(be\PMSYG1-R9IYUaXaV[
VT_MPPV4.Xd<RTG&aLEH4,A/S)?:_>U8L@056;\bC2-.X(+-7::6g0)Te.]0661K
fZ:_CM]#IHa\W+V+/]eM):@/3QY>^N7Z,^R=Y1QgZgc&PKK/KfcOST/1C:cg/b(a
gS,I-T,3b8XCM?W1H=#8I/_FY6ZZ2+\S4;3QP#I-cXY;+E9c>&JLX[B31KH5K9I;
IY7Hag=@_0Z778JFOSU^?0MV.efC9afO+cZXGME0M:.2SZ+T6]1<:G954RDHLMeP
-6DW1W[GVTN=9[0/&XXE&H7?Tb5[LU2N(#Q;J+<&8,P:Z&IZJNS?PZ^<&3aD;EZN
?KBAQQAP11BV=e<48aU2b\I/g+If0/TR3_.41<&(R7&R+AbD<@49b0DE_]:M+GMK
d7/_0IW+6D;1;-Z5Q<F#26bK#bc8@3Ta2\40=g<K2#JJR(=O&L5?)#d#RUXcd&)P
-f&?>-I9;aRbE^J2A;Z+C5_<,eEJG&HDU3Id:(e#\J<(ga?C9=2TJ/W;JGQI#;C0
N[Z?fFL79)GOa70/Q\Q]Z,C?0:+JV<I-fa_WI.K3N\&OA,4_^XSg(W;/;U85fT/b
F:Ke>XNaF/GN31b25]QXacSR-]NJE)1e[]H5e\MH>7241/ECTf-6)+a#c&<\(NSM
0S@RU6HdfO/gER-?.EG;[U[6IHELVGMX6_XgV=;ADY;a?,B7.,.&/4>(#&5R._Rc
-d_0+WaXMV?[6BPS:<EGP)4_+_CeN0;M;I,V4B7@R>2N5@[eVUb>5V)WaWGHV:2,
R,_gLR7cP:TBe3A#dA)DW8=),@VPbNQ-g+JXd60S.M6YCZP\Kg3I3,<-48>dAa5f
#WaFaQ?@A=\XaK6=;/eU+RM;DgB7Z=&Pa8/QQ>.35<&F]a+?,EJc;@.b,baG4<7W
2W9d&E<WdK>01WN<,Ka>NKZOZ6FQ.TeN\Xa/OM;3Q2>C,1A7PF&G\e)Z?0C\Q4FO
5MKJ]R&U;./#0)g(J=XIUE6&NfZS.#@A7J?#gDE63?Q-I2<,UE8dY>Ob0C4A3Jg?
-Z3FQY4[NI#\+GX6PXML6H:BdOSC,?U\IQ+;5(LY6LUTI-Wd:.#dVg5?H[6PM+>Z
;X0&LNDK^>OgXMHXX/eOPDJ/C8bAQB:9E^8:?;?feR19K3^T/75_@2[(-V:3[IcL
Yf#)BHfM2<RJ5Vb<D1?Z]P3KH)+Q.-Ec-DPCI;[@EQMJIF2AFZX6P^F+;>Q.4^;8
F(^aCd6VcffCFAU9<c.f<_4W;b=,;cW2?E;aI=FR6Q08A7e0@S(fY_,;\P^_AW+<
=5=aM.EDA;JfGbA:WDN@eUM(X3@F#eFM)^W]_\9BM160<48,.O[0@a2SJ^LL1I5P
-36QcU6^-1,AK^&E:8c\O9d:H2K,Fb8+d,2\cIF65>2BU;P+OO-KB6AU&TKLB1\G
8.4GNW^ROSX32>>A#G.;R.-7BDIC4J0dIMbdG>1[;E#_VKC6eCG3]UBef9/XIOA3
.NPZ\R.G77#F=9/Z=I0_6RYL&W<?Q^>g/,f/fD>09AG:A0S^R]0R\BX,F):b\D\&
I;J/gg)605H34LYHN@.;fU0VPRK78W@7OR>[b?ESg+E3+TSJS@.<D9EK&/a7+L<G
5YV3)X&+DR-9aDF\Kf9&Id.c#WIE9f\/_]C=3c_ecfK&4Z)95)0OZ3N&GEEQ(=WE
b&28XRKE6_d/aX?J?8[KU:Y91KbCJ0)I5;+a^PF(gNE4\#[Ua/WcUIXZ@Q++F:7g
K+FTNUESK[XK1M0dNadG?QRgTZHCNN-(Lc=@#Jg62)91)DgA1X1cLKSa+1-EZc:J
NCY6&C5>;cc)PZ?(Y5T&KK:b8C#P5I6Mdg.(Cd;MOWZfYg:YP.4+J;GVH,<+\YO.
.(G9R?aNQ,JSR4?4O-f<OYBT,#)A8?J&N0c,.5^6H\X(dfHeV;ZD_f9GY6a+K71Q
4f<)1:R=g8;7N/4<gAQF=ENN3>d)Q@MT2#JNIM^#I7,FWIUdcWS]#LbVP=Afd:,C
>?KRI,T5SL?EbCDBP31,c;Ib?ETMEV]_#?M[#@bB=<DTS<CW01P-g-&6f#\dX0TD
Z<QG8=N^gBcfMV)^/(@\#b-6M-RD<Cf_O-R>#@_XAM64=^>U0gd7T=UDL-[MK_Yd
C]SbBIcBW7=?J7bVWBO5^VY)ZbXS^;[c(eA6O7M07f?R6-R7;<-_8aG^G,EbHRe2
IW[UG8PT?\g+Mg:a\#I\f)7;><9([71a?39O?<>UCg#)@-V7CI\=/=?fWaEM3;ca
^XT-^=[=+8L=,Eg[9gAFQPI26Ha?]g^[,6T?2?HYcf-VU5CaX2&X&N1S4VW9I99b
^4:,IVd.360X>S56<YJ9@[?3ZHIJgLQVD5BT0KP-+fL(V2+ZY40K#-BbB+5^+2UK
c\JRHc++Ce-^Rb)5(>]4^WTbE8?7,5_\d)/UU::?,JW&NEB8b1WcGZ@<2V:T3g59
8KN<7a#)P&4=2Q(2^cH)-BZMTL).Y+W@]#-e-c))M6/;B-3aZ<\(J=OM/OX,N@e@
XXK2M9G+VZS2EB+MNY8GF?F&>-F,.US6P795TdN3>]\@9Hb;&cFN8XC)\ceHT0&X
OfRC9a51(2S[2bbDXAEB/5;Q<2Y3LABXCeT.2>@Xe:_D]2,.T6E[1ISgNNZ/1,XQ
#X(\g2Q,a=EM)OXB5_^0(_U:H>EKcNA#CJ^4fZ_SC^dO2J@.:e+B:7ZR^I=N_Z=@
K+=I^NCe;YTTGHQ?Z]a+FN>UP,MFAIETE<c)1S-ET)-K0Rg,TL&[9S;SIDPHUC2c
\7Z3QI?)F/]_9T0TJ(TF<7N(;G].GK=.1H<_2.,[>#O1/dLTXVB&?ZWNM8D])P.Y
3;6Fc5(YGV^,RDU1+\-g8GJEW?Te\d=MFHL93\Tebd[NUQO7N9<N]2T39fNH-)L[
?aN]QR->b2L:UWB\aLRa?:7P[e:-SNZ,C6>XR=3Be-66R+=_-[EW.B@.>[26LWcX
QAK-]@GKFZY?4DH>,7XI_XcQO#(^A44\9Oa?AHEIT_7^+82bDM68XG5USfIB.H84
d4DQ^S(V8C:KZVa\:+F57BaDN4:71[POI\g)bVF^?4<[JWX4(<dJc>#I1aMf^3=b
aTGc=+.HPeQ(2RR6HD0#N]].A^LRcC[eT.Ic]=/.+)bAPU7]7T.S0N4Z0GcOG6VM
92OFHZA46QG/PEd0+/T?IO?dc6#M;&B;6S],]H46?b)5VGA+S\W\2P)_F_03BQ21
#UDdCPM57(T?O17@5I@][U#C0NCPVb8S-WRU4=#KCA=^WSRD<=3#+1AXA07A;^R\
/d)^X?--].+0ca3I#aL9ZG1Y+&RMVcPUA8@bCNcWYeFbfSW__=O+#4#17]Z\B-B)
5a]C;NC6)V,-cW+CH01Y/2:AdFHKG9FcUL6G9?V]<2aBW8-RP72)1;c7K=^#/_-(
LB3]-9D?d?=AV-+Jf+e82A:eEfNWUP/#(1(22YIVcE5B1:Z.P>5K;\V:>).@DA6)
;[IL7Fd\JcTB[_K@SL:O=&B[^=2G5+Ta5PYBUA02G)V)Kg.VK<FXfC;HZ56<PAX(
)&WGQ2E0<7@S?b&b^,/f@JW;e+cA;X(T#BR?:dSB-,6[NZM52O(72@PIe3\7[eXL
eA/MKfYD8[fK_-LKX&RH@.c&2Gg]>71Fd+V-I:g?J:gZA\7JMSg&H_&/a<X(=Qc:
JdHK#7O;_Fg^V[(WMJ9H+9Q2J-1HZ+c(&G8eJ>e7GK+-;8>B4:Q4BY]X&H9);1)9
1ZdULbVPN[>(FRI.cODe=aUF).KML:YeGFfX6KF)>&[:T;VPQ>5]Ng1G>V+>VfSC
^>b[A<dCEWF6)9F11<U<YVG)SSM@MH2)VLH0SAK(Q-)_-X@<Q7g<^_SA<2ePA)b<
ZTN_Z9JWS#8[K3Z?-TKS1QF=Jb;/8,XOFde5Ta148g)-LOU+J2Pd^FM=?3D:V\LJ
4aIf7D2b_(6\&H=&=[\O5gD]EWIB5#_^Z4G+D<UZ8Z\ZG(/>aT]2:)F3?MX_-5ZS
OI^Ra@bSLJM3.^XP](U7<bM+]>YbFgD+X3KU^1=?3Z_:a=I2)XF^EaV[>/7;KQ9C
XX_)(Y6cDCE#[-E4X1ff0fKG_K#;g#7S>^GIOM+2Haa0L-fMf)M2+&1,4=\UH6[Z
NKS4_E4a9LUB,2#d<S<5^M5BOSc#@9Z9YeMb-::=DAPT<JQKTJ);(,0:NYG=c;=N
[cKd\NTdXg&0gF#4b6>:5@C+KaIJ,1Q,Q0@/E5+S-c:RH+Q>#0e5dXMfF+\HXR@L
2_f\#b:>OJSK2BKIVZNaF.Ue#[FE)Ee2^^PfLII1P#(&JNW-&VL;B8<^06\=T2Q\
HI52Tb+@0-d9)aH3\CFNJ-?+[L<=VSA2VS@[,]4WYRG:dMf^LPT+<+CXK.GCg[cG
8-^=cWVDDc12=(=>M=If+b]F@+KJ,QKXe.U;)<?d^6(7W899C66F#\]0:KN34\M_
AJK/^[Md])^eX=W?2eeA.5OU)&N>;OF9EfC5#29Bb?[67&X5H3V^L1ZfIU=@WFYO
LKVfB3JXV2eRM4.&-a<E++fS]0W[X\#HJN_&b=H_Wac=?]7G,>XW:g=O,)[@,Xf9
eIeNg<866NQLDda;7DJ1_\[N1S-8BA:OGF(2<;G_?PV,,YVK37?]&N,0RKe/ZJg;
(]?NRC9S1GKW/6gC(/(LH<0dL-Z>a7((->-_D:U=WDJ@Z1fbB\#IF5dYO74J3E=O
bJT6X7O=9&+@D@\=:1\\JR<:e6<NIMFMc[Da#;K^T&@J3MB,:FbL&LIIF[T(1F6(
&34H,RBS0DT3IHFSI.-/IH7O+D/PJNH[VU#20bd-\,O8d>KJ.<I.61SWBN33(+7d
>,QO)fY0e[Le;VLf@BdfW5;0MF2Td51@X3FTTZ+])LO5QMMDCUJS,aLJ)g+d-b/A
.E-8[NVed;)ZeZTASESd=Wff8HaVF0O^VBeEILbCZV4)9+Y\aHfG/[\V^RJ<]ScF
&>)YQG)1C^AdZXZ2NMU/e@d)S-Cf+-2R2PgQ/F6F@VUb1-+.R6(TB25ZMXNFg7PG
E)fJ4E/-[dMZN[SH(KdZ<Y97IYZ#=N&.Qg(eJX+&LGBKT,M4Sd+9N@_HT75TRfF?
4FCX_(HCGeCaL;5-HLJQ]W6JU&:7GO0/;/K2XY8-@#9P2aL5Y(W_W/[MgScV_FI6
6W_)aB4_E9ff<A)K2,65EfJ7,FUW<235V=c33^f?E:?Y;D.9LbIS6e0cIE7X6H:-
0fJ:QVb#&SXM\BY7,bMEeR@HD-;cF@86YABA)g[A.?87,cfG[2\@=@#4C#8c(,R?
L=]?,O4b82(E9a?:SV6=:8N<9QBCJ&#Bea+3)ebAN[gSFdLX8>6b6AgB71OIQ_AA
,-_#G5G3bf_#K)7((1XfYYS5IH]H&N>;Bd;-Q)H3:@6.48I#WLRVP_&g[gEV0N5f
\5PQcQ2a6+KTRbW@@JK=Q/aG)Ze<Q99@H)<<<PUW_,+MITZ_][4E<)0EYKBX]>N8
V3B+&:bR=GE=KWX5fg+ZZ5YB&^PK4f&QbP7_e9PZRCdE-#:IKa6K]K4-7(>:49]H
9U+c;8/BJd6_B7;4<1TWDc3U,AC9U(]1ggMESC9O>Q,S+,2C5cfS,K(LL0aJ>;6e
9FbW<JLXTf3SbKRC;?2_,PM]HD9C>EN3Cf7\SJULZJJZf7eC8G=<^N0]KULJI;aB
(ZAbDg_\VBZTGRb8__^T==:,a?<7FaI-DUF4MEDAa(-CQ#WQd?Q_6dA@YKe#K3MW
>[I=R-P(T;H>ZAV,OaUdO/\T[b8[,fIdED^JScKW?]HK@Y]ccKRDB21E.WG5F,88
FKGc2;;=M)0=3:I_(Y_(^dd7AYTcMY9VUU,)9I;<Q#Cd,]_GRS1Y(5eU^c)S3HEb
.\-N6\_Z7?/2gFU(.3ZSXX4Y=J>g_OT:I:b0;VILRb/EDYB/;a1T]+]UEH[DPT-F
50L\Le=5HMYfR6+=_d>\YV&H(C#VT:e:e/.>VUPCf0dM[C9>99fbT/5P3BXJNeV<
^EeGIS((XWLECfRH\_f5cC&.E-&<#ZAD&HXSFS.gP(2\bSgSa:3E<LL#_&?_W4J)
=QA-e?6c4-M_Z@LI2/OQOf@gAC=G72L)H74FNU[#@R_8P(L5\82N#;P#(37\>/XQ
]JG/:IKV+WK1HE9F+Md_3<,>O]fU+DWY>W-.EUM,5-3QWPd2GU])U9[B6BJ#Q-R2
R?bI9)-d-ESOPL:cKU5^\<ICGd&ZN>+.\NLZ4=^[VOO6?;W=BFg[ReJEa_ISLQ&/
<FCc\.g=f0-#c9YVEQCeG+f=:P#9@-XG]BI[99.\eYAFfRH\Uda3DO.JZ4g^R009
eePJgC=H1U)Fg_+7^Cc4aWIV1d)2@b+MW=.,?QF&_8CZ36dI6a;8W;):H34W1CTZ
<<HL6BV/@&:#bH^dI+.]&R1MP\>+(V(HB0-YJ>7H::O?O5L^L3Na[G7ZaP;:IK_[
FJW>JT;IE[F-YI9@(),0d_&9]a_R-B[J8=Q&Z;1425eG<K#-A;TEIPL4S1FG1Xg/
&ONZ4TXc6Ra3,T/+gC2&eOB2[)e>SU2ILO\^Y^Q>&G?^HbX\_/8##R^,.-dO\\b=
gS]G2[CNU>E#QAB,5_.JM3KD_XQ?,SN+[(ZS[d<O43TYU&a8SH\5HTD.6YG2U94C
Sa9=:4/BMb#7OcMETR^)c8WZ\[->+\e594PY<eFJ)6S8aa8&dI\TDgJ0U&56cUF\
XV(S]P^d0.X(fJb(6LbR?)X0_9(?F0<(=D#g#8]Ta8__&;Gc9.]6(V59NT;PHA(=
7S4,4&<VWC&8Ue70f-Z13Nd,(JRXA39VGGE:f,Tb/IdGLb/1[OV8=.R2PC=5N8U4
@@ga_IO@bH(_^eJS1Z#QO_X\45UJM9V=LUg1gLB_OE9IOJS&,.gROA3F]2,CB_ab
3/C;Fb>MCad^8(JA9fV.XMbfQMGA>a@HU=9_F<X3HFKWY4SNd)MG6_N@TF^#)bYS
IV1^R#(>L?aKP,?Gb5>PD#GB]f2NcK8e5Rc6b7_)B4PgN-8>^6>9Mg;6_AF4_5;F
8M.&6MUEM\.YE>b>+RE(E4Y;b[MMaMI?]V,,=YW^P4E]RW\?EMRMHcWU3V8T<31V
ZBc^)?@bO0.b[<c_Ra6>b&W^3B<3N9Y_&N2KL7.dc)eY0#fUV740A(<=X;;5f+60
^c#?2&__D#cfJLUV3>#8FcL1PRG(:Y_VVE@A^J\gM,Zb/H-P[5B&UdA:DEUR,Q-#
aVggCc9Sa1M.M>aQPR_5:dEBVgMU;Af7)9AM&FeY77TQ;2=(8Rg+R/DD)^I0S]>]
W39L2F&I(1&QX-fQWe\EB5]FW#M.-DF4R.gL.bE6Je&c+Z\R4Q<U[<F;JQBSW6Se
4ZcfGdAf7UC41#&JXNgfc7cC(DEd?a-Fe<T&V69&_86S?UAd.K.[A?/#GWOf0/]J
L@7S78;@e51Ya3JNRLGdR^;a^H/.,W\DHX8b(.03F/26-)VB]eJ<[\LWW;B&G?L\
JI?=(,(M0A=<BJ&VLF\@<M(cY?dL9R@8BJCK+:J#@d=QBG@>f&.@3b6]Vb6UAa\2
2c2N]T)RU/;+:CX5MWggG=0@G>9S)1/<c7=K>#&E4<3aNJ-SE?Y\F#:ZZ3>K#7+H
9415aJ4a].bTH:N6:_&Q[5TGU([c@STATF_&=cdXLR4@f2/_BD<_2bIGN[>Z(+Be
,eB+<aPR(5GeAV:a=.DbH51(UC)+.d(\(H+T5)PcWdG_f-@Oa.S#a1RSO@QL6:2I
VSI\T+1L.d_TI1N)+(IQcFV>d\-Ab:CZ,#f>,0e3:+N10&-D6[A&0SG1]TU7<d-1
C2aQ@R,Z4NX.IWH:2^7DJUI2U/F&^Q/(=LNL..[(#-UJO8+2US_&f#;4+Mde6>Z0
RPB_:5G>DX??4c6,=YGA30f]M(B=3]U7[YD4f?@W.?&>-UCQ\Y[LPN4(@0C3SQ=T
7KS[Da>2c<D1VZ+8\>g\;;R,;_d]QJY4\TSZ\?32J7._FID/I;RY4+NcW8bKB8f]
/[[^S^#2;/@:GA?LNQO38_c7<J3L(=1,??F1Z^e]UG]9S710U+c,7#2;G-^I_C&K
89@A5TCO\1#W>B/W@L&FQgM9QKHaVW5CBM>DN2:C_5X+;fB6C]Y+MFUW(VeLaD-/
@J[04>(5O9e.NVFI_dLgGGfQ;Y62]+HLf.:1K3Fc-g[-+QLCSXO0S)M@<=RDe8K^
VWCBMQXeCa6JAH_07Q?V)g70&G7UP#.>@e6PdS;e[c+L9d#)<I?Cd@BVPBDAeQT:
?c]A?:/4XDf[@>WgEaTBbZ972))AS6V[7b+[_201CJd?I-419(c&I;ISe?2S0+AN
LBLUUT_B[?E8-eWHe0a/RVY9g)[\8KQ&IAUJM[H0^/U+PebD^FS360A,9VI\[PDX
Qd]6ELNVDVDDKID,#34_0[5S84DDV,eQ<a1N\RD,:./.fRR?aaaMI]9ZO4@T@g2?
.1/7_ReQ:Zf[IXNJacB=)-&=aPP-<WR+#f<+3/:2P<1&<Z(UO/O5EBFPf[[fENGD
P5_N+0B+9.H;9?SK?/RB@,V[N2fg9#eL59(L:L_[0;b]1[S_](3M>:HX631]T/\C
<^L:SA;Q7BP.20;A^^3X9Q>e[d\\RSH(cCK<(<aQPVKP;aSQZeDCM0@\8dgXF9)[
-FKYKZ0G>A??5S>S@X?.6=&@fG;JHEFUHNL./J=Sa5SgKB+M(GN5J:66MVC4;EE@
\62&Y=c=N&+J>:/<SgfLHcY+N?/gQ<NUK.fDJJD1T@g_1CV.aQcJU8+<>WbSdQ:0
=T6[eO(&51#_E2(g>/R[+8=,1Qe/X:TF;=Gf+&gcI7>_C:4;]d]E?J06bR7PG+P/
</[+/61O\=b(<9-@HP,.8\c&=&[cAVd^O^.K94&E_C.0.f0HPTC5]\ZS8H0PU39X
2eCMR;8E.4D61.2)9I]L;=dd)/\V4ZNb)L^MZbT@;X1G[])7/=1HDM7IC8B@Z<bd
;fK<+V>F>WBQc7#4TC1:(H:JBWL1[N0=+,)PJ/(7;,\g9ZF5/[6A]ZbQQ(+L</]T
?/2VR?GRXZ@b2f4K_<1_eeII8H^C4@Ig6ad5c8f#ZC]]?E/T6K_M8RX.A6UN9/D?
&A1NVf#.P]3Eg8bL?KNBR&E;ERX\JgJHgFZ7[G]S<DD+QFLdF(L>b(W_]WfI5D<g
Da/QK;U52Y2,)W+/.34[;7ZA-HWggU;@W^gPK49g-18#N0][^g9WDG/0JPcQ7\^U
)8\P[a2_d8>ON,b;])W&fE)3B@[@SH++Z(eg9K):(A8XS<UF].1IIb2X)+cQ/g2_
14C?\S0gEg<F:Ubf@6O\;.;VLAIgMOFK0]/;D?(1dBU,@H[+[H@G:fDDFa#GB&].
(),&OVZK,N7,L4^G@4QVO4MSJJaX4OJZdB(JXG+49][?C&&g1g_0.D1-]:dC+4)A
5+Q[#BN6:6(6/@gEbWB9&]5@bdFJ^T^,Y]F<#,:fb)M;=NQMBW<WB05\)M7;&3E)
6V1=^BD?de)=[J^6e,YZ6?b(XRCX>]Z/0#9M)+gCFG01.1KTaXJ<2U55@^V4_2];
N.d7O#ZG^[4V-]Y>g)Q1P;9D2=]aD5+B?UBS&>>95Gd2Cd5Y6N^>6M,>@bLbc62;
]WBg3B<c^9c8MA-+RP9E+6Be@@2M@5Y)Vg+HEEQgNK1T_gJ/a0KSN9W=YYD9#5cJ
VNW#Q2g8eF0H&>X08NQb[C<OF>aDNg?K5T3A/J\DYGPSR[A/6W1A-B\.226^5C9Y
a+EFH7EJ\PaVJ30A;H,X.WU(,9W\WKI&P3H)[:2=I26HJd#1^3Md,3VGFIQ;/P-I
5-Z?+(MKHeTd=;V99-^RRf+<K(0fB]87]f6A&6@g+4\_Of3M\;Wb6T[\,CGA&.=A
Sa8b6]&Vge6.,V[e+7=-Z86ZFF:C1cDE(D0^OXBb(-@XNX44:Y?&]:#P9,>32;5]
JM>\B#CDE:SLU)8];9G/&NZeF0<N\,X^Z;I&XJY+/HE1?N(.[1P94+F7I(\E5S,A
M_,3gR.S0fV-N9P_V#092XKDG4(]E-7RK^&05ULQ5?L/V#98Oeg14g0GIHJgZ9b5
&a-9;<9YIJV&M,d<>V0;]<57EQ5C=VW1<ObW3M+b;0M=.7-U97PMJYL,/.9[RaGN
>d_:,4=-OK\;,P1KJ=[XTef2>g,bOD^bA<0>0g#@g&7DbKL[@D1D,PM446UC;F+W
gd<VbQ4S-F,^P/bKf)JOZ0f-a4RAQ5EG=/cM=CaZO9X/(P=\W=c_U#9bT73YN9UW
NcBYbZ7EGU)69@/D=D5fOQS.3ZC_80YEe^aRG]J@_\MMZT3ZTFSG(1FgC:a7C??0
#\2\A=[>d^,@W7;==H3=87MGR6@6P\EaO7Qag_Z.7LL74+47E]8g.2Z)/^?QTB1+
.4>0>MVA(FV-SE>(XT3,_F]I7EN-c_e-RC-@B).[W436DM0U@VJ<D(STce?@(NB(
.O<,c1,V8GKWZ0>_\&>IG8U9ZOd\Q\=g9G8fMVGY+[WbDR;.1AJ/KUA,STG,M:E-
,I;CS>b]g@.5-65\NZ/aF\geW#9=ZD;<ca-SaBH\1+=OHUFY[I2aL450?L-45Bc;
9S?QcfT-ZXKQ-]LBRUR&QS0DbIKPBB2DDLE(P21+7aB>KH,WW4)D.)1bCEX]GK1S
;I+-fLI,_F\R5K1?<\6(eb24H]VX(>B^14Pf#ZE09JU=WZ93S(0XZ=TSGVY;[M[T
]bVHT^S3e:=JYg1YdH^:HE;4g_&+0@O]:g7#A^cQ@dLQS:V10YCAV#P-75^;F#1T
b>bSA=5YX^O_94@>gBV+72L5K-dZ;gU(03XI_D:U61<&M\8\4]\ZcZ4I4\b74)BC
3I[--fD[ZQ31=##&9.(&K;90;ZKX\d-e<JT.95b_T_K+#1XP)WPfA]eR?]A-gVT=
]9I.(Gd5Q0(+Y\:=c3R[40^=aPO2,35fg5NDf24ESf;4YMQ/#eZ?U#;WL?IaXaO.
Ue[/;,0R8KR]/;RHWdC-FeG20QPM<e/C3.;Db5WKYBf7-[#cOMDC[g&,?a+SFK]J
EDO?56&(ffX]:7PU^bQ9X&LZQ#OPQLTV/Pbb6CKY;g<3,M2CR\FD=5gDXJ[Sf0P]
;<^[JK(N]P0,:A;EYV9CB:\]S4(JH1L<Z:<Z(A=@JQ_@XBFd1F6^aY,L._W1/<cV
S&FNX=K;S1B:Pb-<)6(;#05fVQ,H+J5d(@X5BGB,AN<O?RKX>Aa939:IeVQ?C-FS
N\dX[;N3GF3Y?NPIQ9&]S79g6\[?:BHTV0J5<I06VG>8;94eRJfX##-bC[b5VATH
/CPaZ@fd9>D/&-B4PISH;JU15dLR]])H?L50bF3@TI];^GFFJbE1\3d-8;3R+GV0
)P21MeJa^>;4eE^@1ZUM=c^e3EK)b-Z(ESX&X-)aM8@UKSde[cE,E<KQKgW@JQDG
N(ZI(T2]/e_SSLZ147feH?-\d(LUad#J90XN6a30[&LOS-SKJG(V\3dSCaZ(-)^Y
f7I6.#:/?L\OHK4A2KNR.6CO@.Y/,IMe@$
`endprotected


`endif // GUARD_SVT_GPIO_AGENT_SV

