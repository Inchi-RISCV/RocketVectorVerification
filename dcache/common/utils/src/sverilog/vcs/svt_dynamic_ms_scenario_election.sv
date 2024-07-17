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

`ifndef GUARD_SVT_DYNAMIC_MS_SCENARIO_ELECTION_SV
`define GUARD_SVT_DYNAMIC_MS_SCENARIO_ELECTION_SV

// =============================================================================
/**
 * This class implements a multi-stream scenario election class which avoids
 * disabled scenarios. It is designed to be used with svt_dynamic_ms_scenario
 * instances.
 */
`ifdef SVT_PRE_VMM_11
class svt_dynamic_ms_scenario_election;
`else
class svt_dynamic_ms_scenario_election extends vmm_ms_scenario_election;
`endif

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * Flags indicating whether the scenario_sets have been enabled/disabled, populated
   * in pre_randomize().
   */
  bit scenario_set_enabled[$];

  // ****************************************************************************
  // Constraints
  // ****************************************************************************

  /**
   * Constraint that causes select to be chosen randomly while insuring that
   * the selected scenario is enabled.
   */
  constraint random_next
  {
    foreach (scenario_set_enabled[scen_ix]) {
`ifndef SVT_PRE_VMM_11
      (scen_ix != select) ||
`endif
      (scenario_set_enabled[scen_ix] != 0);
    }
  }

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: In addition to constructing the objects, controls whether
   * the randomization relies on the VMM 'round_robin' constraint to choose
   * the next scenario, or if it simply picks a random next scenario.
   *
   * @param use_round_robin Indicates whether the next scenario should be chosen
   * via round_robin (1) or purely via randomization (0). Defaults to 1 since that
   * is the VMM default.
   */
  extern function new(bit use_round_robin = 1);

  // ---------------------------------------------------------------------------
  /** Setup scenario_set_enabled for use by randomization and post_randomize. */
  extern function void pre_randomize();

  // ---------------------------------------------------------------------------
  /** Watch out for disabled scenarios. Move forward to an enabled one. */
  extern function void post_randomize();

  // ---------------------------------------------------------------------------
endclass
  
// =============================================================================

//svt_vcs_lic_vip_protect
`protected
F=DZNXH]8e=E67FC&?#(_fa;OCCY<216^9I]_J&O_JGW->3J:55&((=+HQScPQQ[
^>TYW9R1e,E5#B<dY^]\K\eZT2ZA]S#E5cHbLM-,/PPYELg8c\(a;bR>.g^fFUM5
C+14;D.)QHD?_4O->3SfA5cS1ASM6^BTD?LFB@b+H+W^O9^1[WB9aN-YGTCT_S.O
X-_S&(/I_X4B6F7#d(,/VfdM4,S>2XYC;+_YJ?D:.d?Q;CB=eTCY?&cfX9L9O,bc
M\e]B>3?:K#,IfH_[c8BVJ>UL2DHYTdL4L6APGC+YO6N>T=Q<(VCX<:M8&2MeSJ?
9C>:14Q-gdJ^FK0^6MBc#Hg^S3f@HJ/fJ#gPVMEIOL,W):Ifd-XRa5(#F7NC2WK-
0gC@T9R@#1-JBD\>=N,GGC?SP01b]3JeVCfSIBZTV6e\OPLIV77d#J<AH7/f6CC.
;FS5aRAK(T<6/]O7LY5F\?#5M8EE,:@[1_&d5dgWS[M<c37\XGaMCB:RB]2fGMfa
aNMF1^RYA<&ABH=X)?2-9+OSg\6Z?:E-FC983RJ7N0-]OH.bOUJS-Q.^^@C]ESc-
SLYD\&FJ^0GQ)9Da@CZ2HA\\)Z6Mb/+)_@QE?T4A?XKZSQ#d;:>]+5+HgfZSg13W
95:\=L^_3A?ETG<06AXBb0O(^cHbISYHZfR,D@98T;,0)1L#/#_9JB2EV/?0.QB]
3:4&aSbH[@G_OR=JQ02c_,8:D:Q3UZS-NB#GE-<<WcMNK]Y&VBgG+^8(S=9G[^6)
aQZ96<XDfAPS8A5=NP&NcB,A#1WRg.J/I</51fXM=V>ID9_OJ(S[aZFXU08)e7SW
TO<e1F2_.(0[/dTIaf,W;U^TGF@\Zf@[7X5M+?<Q_-U^O[;?66BQY9Vd?;X]E.VK
ISGE(Y;Z&T(&_4LRWAL3e7b;&G2QIT\([YZWc&VaIE.#5<T&LDOG3FVR<=aU9gF:
;()=#A=4+d<F.S9UHCfb]a7?4O&eIa[EI^,X1=[b+Y<KKI=CdXZ>/YFBU;OKOKV?
-G=W>20<aV,;]#:HG_6N5Xg^GM.b)C2O]&2>H(8_CgUU3+c;EW.+2>eKI3c[Jeg(
RFJe2.]3b&O]_Na/a#AUC75#QaJYE.;CH:WaU3C;d;1UB#FO],4Xc1>_7MWa[0RV
f36?a77,EfH03cR2S^&C,#TTAUdKS8QJbO)S1a^7F4g&AL?6cDI\aRA4OL<f7A_I
A=f/a1+?9[@UXH+VH<EXA\0:;L@>JL3POALOUSEfIM2K;0F]L2FC^fI4Z52GR\ED
=Ka<W@JOXUQ:R;JFE0\YF9B3RUd5+-3J>L8BQ5BAX)7Z,5G(/6eOH.8Jb]&e[MA/
b,GJ@V;7?E/-X9KCGA4186XcV93:UFJ:fOZO(Q#B4eYf[)-60b5,J]^67</\Q0T3
fQ&C@P^E&NX&c-+Y[4IbO/>EYb+&b\Ge[d_)=,Ld/T]Pb&HD^PMPPaC@3S#G/ER^
AZ]<_W5Ke9Nf>Z<EL_?V/U+V:+A;e0HVPbM=8(C[WSVX]1](CJ=dbMKRS1^UA&.N
0];AH+:8c7CK3GB3?LF-K>(:dW)\<=1bO^63JM6<7Y5>GCRUEe3F^E[0P+H6B/[<
1B&(A[e_OEfAQHMB0E;c,;QaIYE=>Q^QcMI,8D;gROWZ6?#1Z?F=&E(?S?Dd[b(<
.TRO]?f1\-3AG@_5C=agJ[f\(?2L2\.)g5<Rb\Hb+\fCd^P_004b>6]Sc]([[49.
1,.=?f#CL>LA;C7X6SIC-GZGYPW39H?Z;A7Dga1e2)6-O69=_(=GDUT2Y6#N&KK<
dDYZ?/TV//FGeW\,U2D0Mf/<b2:QX#9G8ETNZA&<&S4U_925L1Q>7;T6--P<&/Q]
DdNAcHZc<>U@N2^0;;bUg8L&;3@+WVC,g38XWIV2ZZ1#eU3;a?0/6P14XeBA5\PL
KdB>N\#K8.8IQ;?Q9&Z1+L^BI\3[<E6FN958PR=)-VK&(GLgE2XZ^L^M&24/7b+3
KcY@B7W07fF&(_(YaTD^DY5FeKf=-V;QW+SP0GC^I]9-W.(#][Tbc^PZ<I7OgHR#
eE-MM^BH7VQccLdIP^K_dC6,BHY^7O:Z4([9\f/0W/E@FM-SC)GPZT0XM<.74<f#
,d[+K95&=5_)_^6:eaTK/;gQ]c<#F>:D?Ab4FKg[\OW4^[7f,+;OVT<>J?3]@CW&
1C1H6AP\<Be,Y>?1VR.1L+K?.ZeB@CR8[8:W[/0\Y<>91IJF^/9D51J@_LHCF4_-
07^KTe8>P7OWM3a0DS&0YKS7V(Z?4PYdZS3bf@bTS?(Rf\O-/5XOPZgCGG;gX53@
gC9cRG,d]&K46;\\K+5RHV6T#.T]]58CTN0P/>]Q1#53&d&.>?&DSK84g\HJILf:
f_Y8^2Y?OD/8Q.0eF;.0R^/0I#W]a;\X_=78ebd=;-cSJSU8]2]/O/(ORS;Q5/#]
;=G:&NBSCNc#C,H7D)(LOC=W,XSa8+9A.5V<;LA-R-M(P;=LOYM,?O&Ec6@T6>K8
D@d28FZB+J1A)c3XD0^98XcU]7J(WTB+X1@Se1e#NHEHeE.PY^;:ca?C1&0LE#)&
N1Y^Ze)=Z/.,X5,>LK:H9LFaZ?U3F5QAD_HdEb-Z?JaXEBW1[J8-6)P+T&X:[#HJ
d>?^<SX3MOEf=ReW:d_#UL\C3(Y^g-b,W(&\W^_8,)C<1+A@A<0#I[(?9\@/UKQg
</;;0+6I)FX5a=0Tg-eSJ/:.Z5H^_X?GFY<Y&B09Z8FBb@-fCC[6T;-#K6\SccX3
(FZ#Da.YSZL;LOXC=[aAcVdRJ#fEY1Vb\)gU6-(B@K0NeF[=RTbLS?N[:59X4+R@
dG0\NdGE829,RP6C_.&YU?^2HT#1Q(O;UdOTeZGUAI]G<_a\W3=67;?>@99?Ag_0
?\^9d3&<WM#26K4c9eCMJ[4.G8=eRMgSEa:fag1:c.b/V@+KMg8PE[S/8g0@RGZg
0b,4;P_(KAU0VD_)E//K6X3Hda0G_)<^HKG2,K1VNfBB\JAA]KW)ITLZeDSI9T,O
J[FWeAcQ60RY;TS7E_)8WNB&K0>KB\Va#X9f5UHS\8d+(2APO;@D_SH28W.e8H>9
f@aKb0MGdZ)e>d3(:(Vc-dA=YCUfK-cLX.QKdOc_/BM7c1]8./E4B4R?G\(4^cgW
-5UO(fA:fcY]:J@30UHaC<=5cC&.\<NR7?G5GZbbZ9Lb_]CfD1d:>PPY+#1Y;CH>
>6:8R/Q#T3Mc)7X_HPaSI)_)9@,a7gEYHZA^Ab#6d)-1FAPI4\fL2be)624_&P?,
G4R#?\UcJF483PNJ/_P)(UH.E6-5K]Wedad?RA;21,GZ\;S9^657UQ^&]IS56SM6
YX0@:e:@[4+#U9.9F@UP^fU+A@GPKM>Aa..?IEMb[_cGCCVeBZ=>BJ5dM]]bfN7c
25D#cZBZKPegTIe-Dcad5)]\4cZ:M@5#7#0aLA0M-ZN,_[bV,8=V:d?1.O^JgZf?
B/CB2K:QAUEJS+1QKaOQGB7g9R;FD;IR@QYJIVFcDfD58213V@W<eBaL0#a+Z^,Q
OATRUKW4P?&a;,&g29/,gfF)>,<]Z+L;8&A5>M)0c[^g@KG&O<4+>B<6:@b2ZT(M
3RfB+e64F,>N[RV)<C#=I@)-2)]AN<#b-U@&eWS8E6c\VfPbDA\DAWMJ(cga5>RI
[Jb4798_[9D=f7T3;LU39+K,NJ5XDIT@L]Bd2Kg(bb,E-8QO53L@S.6-YfHDL1(4
3HO#,097J]fVcJ\-7aX.IC@,P,FEE<K_0RQ)0P(2.TeX86<;IbGBX?bB)ZNcfTR:
JPKXTIMW3K/@,5A3:@4X-.YM[>@.C,E/H.(PV<aPR-8?WZe4EB0]g^fgU](/V1IK
]gFYFC\:9AcF82)._-gOM#OgdFMH>EW>/V+@K/UW_+g@7:]S]bHgB[HN1>>[WY9[
()1dL#LHJRYD^\2]20e_A9Z[SU4V6\(Dg\IT5ULFB6+>4NZQgSU[SPF>C7:eO4NI
Xb4)fO?\:@dX1.SQS@4=\VJdbK3()c6\274Q>VEX1U3J2KZa+2]YG\K-^^=>FJU>
B5]^QSOH67CRW>c9;\C;^O^I]AP(e.NS_>5U?2,A6L97HGVE3AK1H.PNd?DI]N+K
CB6Q_.\UGS):EbeUT<3[LQ]#?OfU3ZR6&C#7g99JI:^XaG\4eD9aNdL:\4RK_V]-
-V9IC:Yd_#V@:VK4eI+MfRb2RP4Q>Z=P:$
`endprotected


`endif // GUARD_SVT_DYNAMIC_MS_SCENARIO_ELECTION_SV
