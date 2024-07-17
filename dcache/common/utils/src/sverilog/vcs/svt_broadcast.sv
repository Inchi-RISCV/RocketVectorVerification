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

`ifndef GUARD_SVT_BROADCAST_SV
`define GUARD_SVT_BROADCAST_SV

`ifdef SVT_VMM_TECHNOLOGY

// Use vmm_broadcast for the basic broadcast definition
`define SVT_BROADCAST_BASE_TYPE vmm_broadcast

`else

//svt_vcs_lic_vip_protect
`protected
6_/B&ZQC:B#J:^c##_YPM/#Hf4Z3>W7O(2L)Y<C<<KfSa4?8\JK;-(TM4ZK?<AS6
)Kb@Q[MM9S+M,3Q#W.9N[(J;.eA&9R&:B;W1R;/f<VS:CfV<XHL&^&6JLYKO5#E6
6G2MaV1Y7\Y&J5\&#@8UHH#L@<CC=6NJ?33c6GZF1:2^O1_)NLTTCV=U?.cMO4.Z
YX^H3B]5_#P^1UCE_[MUPS<c0IO36e7>P@4#0PI(F-XG,(.?J/N=N@-8?^dRdKG(
G=U[[?YF#U.a.R[gYD?e0,<c5$
`endprotected


/** @cond PRIVATE */

/**
 * This code is based on the vmm_broadcast implementations provided with VCS 2010.06-SP1
 */

/** If using UVM technology then create equivalent broadcast functionality, but assuming sequence_items */
`define SVT_BROADCAST_BASE_TYPE svt_broadcast

/**
 * Broadcast implementation used to provide a basic broadcast capability in UVM.
 */
class svt_broadcast extends svt_xactor;
  
   typedef enum {AFAP = 1,
                 ALAP = 2
                 } bcast_mode_e;

//svt_vcs_lic_vip_protect
`protected
F3?N^)=@g<UZ8R&5WfK[)S;.F7Rd>aLPbF>4?\V^T)9ZW8YEIENf2(e(=6dL[(N]
UISA.@WL/_.a@F3dI=8<^L>P//EM=3Y?NU1:OP8dM5\)cI@WDVWc5B(4Z3e^.gJL
S;UYM91EfFGX9JU(R^T?R::aBMR,M#FA3=aX\CIU2A+&B<SSC<_5GTfVYK3L[<Oa
^M2]XVZY9U./5NF(24YcXV.(AM3=NXNR>T)]RNENWB]/ZCdNg[3\9a:[K).;0-<U
U8C3S4=/6FC0H@8RXFgR4N:??5g4Y?X3cg8I667/PNJAXR>Xd0W407YXJ;2T/a90
fE&3Q-DT6D^HKUcIQ[WE/@4&TWP8IeFQ5XH=\IUI]6S8,,AZHT18-_M-^?N6(:Bc
[2.@:0L14e-F2CZMOJTJW;W^DW#AEM\-?K<766NI_CB+203(#2PW-LM-M$
`endprotected


   extern function new(string      suite_name,
                       string      name,
                       `SVT_XVM(component) parent = null,
                       svt_channel source,
                       bit         use_references = 1,
                       int         mode           = AFAP
                       );

   extern virtual function int get_n_out_chans();

   extern virtual task broadcast_mode(bcast_mode_e mode);
   extern virtual function int new_output(svt_channel channel,
                                          logic use_references = 1'bx);
   extern function void delete_out_chans();
   extern virtual function void bcast_on(int unsigned output_id);
   extern virtual function void bcast_off(int unsigned output_id);
   extern virtual protected function bit add_to_output(int unsigned decision_id,
                                                       int unsigned output_id,
                                                       svt_channel       channel,
                                                       `SVT_TRANSACTION_TYPE    obj);
   extern virtual function void reset_xactor(svt_xactor::reset_e rst_typ = SOFT_RST);
   extern protected virtual task main();

//svt_vcs_lic_vip_protect
`protected
+=D0FNHNG6ABc]f0aTgVSAg?@R7RGP7OcPDJ\3D0\)DdP12V3g?1+(,XN/XWY]1W
1J-E6AL^RS:_YbA#d1E(Pa@U(?U2L??TMWc@.(3PF_3(M432N>d8N^2,&L+Fg+0=
AI\KHYLJ:Qb;)U)\EYC3X<_HO+[bGPQe1[H;OUPOVE4/C44\8C\Ee4\J<5cgYIM-
KF:,OKaQ<]aU3OOL-(PMA1@IFM/-LcF37M>C?\gOEQG<9R(H6d3)b#L[A\G(JJ\;
6JafSJ78:?LG,HQV/I=NQ\@I5$
`endprotected


   extern virtual task bcast_to_output(int channel_id,
                                       int on_off);
//svt_vcs_lic_vip_protect
`protected
<#3[B^KaIc1PSf4,f.4M?)V05P;>9B<B;2C1Y#89YO9TV)Rf5GeG/(TPBCY\^gZJ
H^a;A?=G0=gUG-V6SFN)@BYQV^CP32NX.bI:].[;CQ&G7,]&4:4V<NID85E><T-F
.4XVfS-59g/13LB??5&a:O:L8a[->QS/(#aXe8.17,&,fA+;VRc3W:[=43b=,)ab
Aa/M-].PMU^LY,#&#;CTQd_GL4.@1d/)0>ZV:1>04Y,142?E,:O&-.978<[7CT<M
Ubc=W=>[1d70WJ2\XT?T:DCK)MG?a;TW=$
`endprotected

endclass : svt_broadcast

`protected
U\S?HYMWP]FKB(]Z08D6=:gFZTW3E0-_HXHP:LHBK-LIH[UC?\FL&)d@^>4[:KFZ
+PASc/b.dg]H>b992P6V?\YTEG[HHY?6DJC478VK=@+^=ZIQ.;B?Q&,-+]b2I9JF
Qb#D;;#EII^0;QU(gH-bSgR]2_MaeZQX+\He?#3Fe0OAL<1Q<T7FQXegf:M8T&G6
YA.DM<6I]]Seff(X6f:dZ>I=Aa:^1c4IE9]C20b-O(ae,EPa-KX9_I>a8QecC(Z6
45(2eR4.7C:G+19>d+X-CXWB?KZ8S(6d<D<dAW=IF>G[dND@WT+cJfSH+d6d:@B7
Fg=:2JKYB41M5^6EXB.DJ<C2S+Z9_fE15N#eF6:D^YObALO3CA^1J1-8[(FE4ddV
E:C@OFJ\=Te?9<ge:K.aa@cHNe=IBP7JAB;0OWIG([PD/_gFJD<.1U]NEW8&fI(0
0B6P;=/I;<-D7.M(X^-.^W69G,4fQV[Y/F#QA\&UO)[4@Ag<[+CQ/R=M?D]?Y;8/
;_9A7WGgC\bVeNC1,g/17gLZ4aYZ,Z._E>N+U?/V)B3;eB5GLLVa9OT0^fNV]0R\
7U4^[-6D77.P7b4C>M:>L8Y=+ff:?V;24Te3#gZ7R#H[Le_ff(I@+R;RSBJf34.J
2=g9G07<J_D9<6N#e/]BN9PePUaTfU(ZO>(2:MOA[EHN<TeJ#]ZYMCR=@E6JgG,E
Oc5aASgV?+^)H@fg0I\ZQW6_Q42][,#6T/)-U[YJSF6V)&7PfQ=.WS8.SXc+8?N,
0?#FPNACf//QO.LKDB&#]THGGMKg_1+f@B#U+C?=WD?(N^TNXS[bfb[d@#2YdFe5
PJD-)WSW&4R\7^g^,DS.@5JMV&==35<K2@V9+68>8PXC@K(6L#459[U]KSD29=@<
dg;gNXVS\?(\5?Mg,gMGea-?e;9^9&D8dLH4C_KTaF0G;13:[>RI9]B_1):O63^f
f_4DC7)59V;]<5_ggV>^LIa/P7BWa-C_06Z_BQ0Z9?O#:Cd/F_B;0YaY&7<;3bS;
>X)21A&=aVTGJ:ZPL>R9W/g^.38H)1)6aG@7g(c/:Z\3C)K,UAHIL)N:OG/P7>aF
6H<XPPaLH4K.:2:Y[Oc(f5ZV:T/2=0OY19+]&\UDL>\JMOS+4^&-_Gg;a>VK_JV\
ZbPa9Y^:ZB)[X+U;gW(dT6@a,&AIP\6>ED>D?]:U63BO-Ad24(\_)ZWW@_FKERR[
GC+3fHH602EO(FQM[A@.A,/OcG#[S?4HDVR:41(0d,/ZG1Y/f<?S)e[W7a3VeE5+
Z8G7W?RaI+PCNPAg2;<BKOCPbdbW0QG?a?a^S@MU]EHY>J<ZWY4(#I.]16+@L=BI
&Kg:2DX:R?)/Y:X681bb\fVgK:[]8^PbQND[[,@@5/c6UMBI)H8;.N7EMVJbVS35
efFN?c7O=8Q01ZY>+&Ub4eE<DU)8>3#a6e1WK-5X)X>MVaB23W2RNV@=<?L^CHKg
9e;=87GP)M;.XP5;C.6d0&I@=/FZc;.\^]C<;)4UeV95U1(?\-PEE_H2SN7)D;?\
W:Q#>C&XL&VO.3:\2.4,RV4F#HC=0.X2af8CGY]3Q[,:+O5U<EFQLQB0)L.C5UF4
Y,S[?FQg6+M]W1[[IQ:YeGWK?D8Ufd2[#;(>gI(KO_N6+&2(QAU^cf#R^-Ga>EK#
>JgE176L@#2^JQ,(Kd8aX_SNP8[=IAUb3WAU@OLc]^MD)S27YPgcGP4OOI&;9-9P
+C0CIHe:1c4&2Q&HJ]-/ESI4VeQ=UI.[:G>K#2+a\7c9@V5,W#1+TeUXNX4ea7C+
+,(]O\gOdPf=I4.,U^A#)JIFA5F2T0gU:&2XE((f9H(d[,WKN=e+NZY/>+W-P=R8
)bGMUO4:=2?0M=EN@c8XZ;f]@]A;Ma5SW30@E7OgD-\a\OIeDRXagG=/_aE)X6Pb
PSXP=+.5.Y^,J),U+27];TFV70G^BP4Q[-K^;Z0_GN.SGJ6+LNd/[c7Uf<0+PKJ8
@e&E[a_\X0AP(WC+Lc)TK?[7GL0_8dT;9CK_#JCZ7;S6S<:KSAO0RZH,[GQ/f,&B
_GQ<8E:L-Xg6>+#d9;>L,_>#M>(Q[(U]+89<3,E\[OA[UMYRCKMM,E[ZTYY@N)_K
a>BA[D^8V<G9D=O?AHT&W9Q#WeJ.J9X#P^LK^QI@J,P(8QT2b+UWbD+fN(J#[8(J
bRCA@]N0fZJQDb@(3P,,XE;&5S4:J/0GR1LRe4)5^_E&c078a^X.5B3-W\bU2g3f
(VI-&VPa#fAagE6SX^/B_gE_NF;8@gTM:dGQ7\M4\85Hg+XG3F=1@1@Kc4&:-?]A
ACO?feM[3<U.VeSN4E:O]4L(0G2N-G<=S@:QU\K0YTa)@?OGMCA(DCAFMUR23WIf
cAW6/.8a/N9),+JZCeER)SAA)8J>_N=&K-39c<IT0MCT67Z1UAVQ&E_eFZULJFP)
^e3.W=2&9?<Q]T0Z()U)f-XY^73,KVC48P_K4(&[T/#5MZ+^O(aKdW>_\/W@5>VE
W5<N&6R65,?<bN3#_Pfb592bcA1gW?a&CH;47W4HS?B+@L?,-eZ\A.,31bEDDZET
=;N&+I12&:3e6L+K50T/A,58002b]g<@?Fe3BPZ/f-]KJCdfPfADAM)K^W;XOg-U
NU_OSM0<OM^W)G+?D5VIRc4O\4R;aXDA:<><<1V6)H@07UT7VO38ef6@O_N](:]f
:9?DR2?>+cQAFg;3JLR=Z&Z510cVQ-JKf8Z4A_4HH^Kf5DAgc5;0HH,bUH;CQI@&
N1=0NJU9NDbSf[2Q/CVdXE@CL_0O7O_eFW1R9H\=dDUC&?eN_??A,^LF-dO38?Xa
FF#B8(b^FP@;K4-V/]MU8N=15FR?T)=eA^>b\7RaYDVG\=1B=TENZ1;U_AO:;Q/#
S@L+V@AaDHAB+a?A]b_eO]=-+OQ5Og=;N]+Kbf@;@<Z;GKZa.FT:@.-EHNVSVHWf
52f7\N9ELY):K]Iea8ZD=8+]9bHN3R_4YD;N+^4]4<Xcd7Aae-Z;+cJY[9>RZ@--
M[6N1+0DHCELQ8;XGLOKEFZ/Q1d9:6\egT@b7NZ@=WAPIIc/DKbcbW1A7XN0]=DA
Z2>O;Z3&(NKL0$
`endprotected


//svt_vcs_lic_vip_protect
`protected
7K9CB5_&E4>._RMM5,R5-#M:_EN7B)32E@I>W3,Z)ecQGBM&FRMC4(e[XV)FPc#&
A7_=:(<,A0b_+6?GAE@<>GP+R_)H)>Ie\;T9f48:@feELCR7^&?ce/+S]&=/[&FX
bMHS0O;P@Rd@-P?O2Ga=:<P(cAX4T]F-f\;+;c_9^>\LH5f_UID#Ce.NP]2&L:aP
P?ZT#9=(1W3fXWS3LQRCaHd)Ma0O&C<bZ3UQ30@<aMMF.=(A&I7fE^S4HG&]Z^3P
;G[KCNRUW@R_-U3OCP@8G>A-GF9N_4IX9d.NVa4B030I;]O7TA7T)HGf<d\c/X6A
9WOV@T7U/.._4BK)RY[^XCb94-#T69<S&69QgK.a0;f.Y;N19T\MZ8M?KBO9f);2
]b^R>QUQ-8g9BB8^8B9=B4+/BRecf:V3Ye&?Rd1eV5g,SX3,S#WPHDdRX?@dTJXC
8C5GA+6Z?ZGeSQ9+6^fXJR9F#+];Zb:2I+WULfC]-@,g-W66aIR_#O6O7?E&?Od,
@MNIb_b0,]KDDW<_74L\OMREd-U1TR8gW\I44e]Z_U/WcT(f0M,&5b=X3OXT;]Pf
,6ZBF;\P,LNL1W8[^<b0#gA0,7=/[-Q.GYe8HBNWa@GTMW)6]ALE:3N@[&)43?<]
3C;LXG1O@T1LbSM,_8Z_/PFbTXHDVK;-KYgQIO:8(6#-6(6@8f7:]CI4QL^Wg,GO
D(Z@3;+V\a547Rg;A4XbRfZ+Nd(Q,T#14&+Lc&6\CL1D-UBO7=G#?2O\O;N11I6H
8\DX.[\_-P.=4-JE][Kd1=A:UT6A8[W\L^MI[c4\4;\Je[I0ASE,^eIRKcBcYOf)
../a+=NOV:KS,Q9S.CDbNQEGbePNLN-cT8)E2\H\,COYLM7RNJ/=O@aB9[9^4J6[
>U;]N)4(^-S7S-.F4:,VJ/>?_SF69KIU3?Uc)BI56\3\G(GGBa(HZEYB1]]2N56-
=EC9fd,NbI,WC]WWQg&V_S3L(AO\@0.FV]c)#\a:2?Z-?74gV5,0Na9F[&AVH,#c
:+agf()._Va4/\81HGYWOKTNW,SV2X/OY^KX5#M<4I,]@=?cP?Mf8)cY1K\&24b(
K1RTF@9P9ZJ=[^)6+3[Q9E>UeeG^1MA;I=Z@B/BGf+@/9>38H9M,]I4G,ffKG-6K
c[M55:fP7T-BH;G5Ag+bJ/X4..9A:bJO/.PI]Z:\<MTKb2BR=dU^,?,<a@V,1=d?
^HdaF=KeE@3;Z>U^MHa^<JU@X@3:-(YD<$
`endprotected


`protected
/cWT[;e?G?8;Rc_?LV\D)R9T]^<gg,Dc__2dH=.\/>S/^b\^0Re>2)5&c?b]F[L.
MN6TUf5IPZLg=V7:DE=C/L)f/(],bT,Ha<VcU1fFWd=eUWYKZ,&L0W(f8GPI3D6C
D#&d2:^#NTQ=]_Cbbd;Vb)Q=K8@(&DX\GK#LfHJ?3MZ;SIFV@9>JP3Z7#-A?\_W&
X[0YLT,Ab_MCY#-VY,,K\)E94YE2c3],(W\Je]eAC_/]@[Q?E(/9>AOT9O/RP[\e
\)YYcM@9b1]:b;B)YBf8XGaE&5^]>6W1Y2e+a/YZeWJg/J:ZS2TVL].YA>?_f>]I
TYd0191+MPENSIQJ6^O<X;D[]:V96\(_VDAT9S;]_+1bS.Q.&^QKWcC4U;MXS+2C
7&BVeN0]cR6.5e][;bPX1V\P3M;^(.b_fTI8_K3XfMV+)^eSE?;;Ob?XTQLWS?W@
gLMOY+0K].B]c?ecLJXbU00X>S9cgIP+E01bdR?51JMGJY8OZL+Z2M1,.86]?5?I
P=96O2^bW.AS5+IK2d1+:N_O)4]aKW=5bH#_..W12aS#g;+4;eNH/4,-4g)AV;fb
LbWH;UD>>OSJP4ZD4a0DfMO=fHIQXT2^aCM,@H>KaXY:da^AOUKMJ0V]bQf[PTOF
XRUb7QG07&3Y7)I-@SR((<YQ[(2YM&fa>+DNAYF-f&_I],\gRPNV]+GHYX@3.2WV
R5\=2OJ_KPR&:;8_TaC<_Y(4_\B0.RBY@2XLK)68;gR4]H6@UC&>4O-&2dWTIW>[
@.,LU<RC1c<<),IZNZYD+R9;]QPXM9H;,UaS]A2<J)eUOd^2CRb7M4:U;&d:F:W>
N/3)4f45F;ZH9SGUUaW9(3A);,1ad@_H?HEGKWdc8If7V1MELSd&OLF=J;=bfYE7
NB,P6M0eZ5ZdE0-#)5UePB9R2NLZKY\UEZaQQ3N<Na)_)=?VO8IAKP]RdA8->gO2
a95-I+:\bg#&CJH1dI?I:Je,=Y@H#(SgYPDPK9g:DMI;T;4K\,UMC>cTg>^]W3Cg
1>b>QgN#IQa-@N5M4Y<c6[9(NS/E7@=SB@:.f/UOO^AQH;;Q=:,6\Z.AQ;MRCG[8
abfS7[L;DSM2.fX.c1^g#6.fcI[54d_])#]EYa5)Y_(DG5D:;.O<Kg9+e-<cR&#M
3fF,^#L&MfU<3N9[R3:P0H55JW30.UN7eTbDH;81IO(e31O?YQYT)f+f+,H2/=1(
Z2;2JT9,9@&05(]TLUFdB=8Z)9U26?[e:Ic?2P+J=//9C1WG9V)LM\cf+/Hd1d37
6\g:31Kbe0\00$
`endprotected


//svt_vcs_lic_vip_protect
`protected
T>RB],ecLTX)Z<S-21g?b9d,cWR>WaSKVc+F(X^&+^5X?XLOF(6D&(Fbc1Ma^G^]
HTgA4@#VA,<5Oa2ARN2LgER[ZOUXC(X0T-EVD/:FQ=97K<]F\cV2J#gMRa/91S#C
,dUPL+/+M,=L=+UAMPfI(:SQ&RTY7/)H1,&cQ&3-\Ae=1<XV[\PICT5K(gG^=(,P
(DE_37SQ5URM8)#C>(1a0BQN@CQ.<e4e6Q:Ng:OCS?@[^LZ/fHZJg5H<cbg90cKO
ZfGVF<Z#gb>C3/3Gb\[AA)G;gY>A^+I]]IHJ8)F?1[^.I@F0I.Z&(MI03TK.?g(T
9fQ&9g#]cY]5>G[E>&aQ&QOd<#;Ug8E\7>(g<#3FQ..7cD7M(Y(gfIASS5T[aM<I
NG)Q_FES,#a:HJ:aW<cf7.^68)+NVEaR;^3I-Ig#R[;V4(0@6@L?\V0O;)AId(,;
6bUZ8,6A_&?>/YRCNJC.WPDGC3MH1N2[e9RN=Z0a&0&P,#6aH1^^ZSWIbEPTUeO^
B);4Y:HU83<:TbM0W+2BY]?)LDd,AE;]-9=92Y92Ud&T0@F3W#O[eYG)O()<LSB:
D>?Y&b.dB5GIUc?NVKQgLNCO5FGC5#J[F)V-Ee3+0TB:]SYM49Se(46;?,c0D]YJ
/A9,X>&g2+Z\;TK+#M5P<e<+XQ_A,g:Ba<9L+)T00cFe6R-KHQOe=_.>XYX>GS:+
@+F1:6aOfGEGBH/9F7RI1,,H6[@cTNNL\H0B,)N35SMb?]OGIW:JZL,W<VfC4;2T
&BcMA..TZR([H29KBf(QN&N@e-?IBFLL,cG45V11W:>SaNUcZe_?5Da^:;1@3VDC
WdU1gEa.PY1S@SF(,GR=P[3&/S0F6c7O4Ng@R@191PUII(DaK]IZ=4LObH;?3?)9
-f[F7,/d?/XgLK=KB/#A^I2YVU?egY>-QWWg1<cGMF0[PR4b6R9@9N1W=B]&K_L5
<.>#-K5Od.,DU4=HdMJ;D_674eAA[gg_-XG+V#E+d5C^bdW/)3LBVB2<1)Tc=C8K
H2PJ:[R^>D?7G_KOX0NNd9:/R<&2M2bYP_@(F=/?4P,bP>[3)L8T+@@C(BJEdOdX
-2\JU>DN75K?&YbD_bIY9QJ3(/\H-e#:3D6Wd<BMMfWZCMKJ^eY@\agP=&KDBJde
&X<K4CW=K1UDMRZ7SG,)>7I8F(M92eHC]>cQ,2HQ8V#WERP8[f3RADT<UQU6G]-A
/DQ;RD3@b^7BJ\1,E2):;BYKBW2Q9\+aQ5]Cb<B+2P2AT6EY6@7Y@<F.K&@#9[]#
?d(LRM7,59e>YF<XZ=F0,^Jf9N(L156aNCOM[G6@bBa042LcDS3@LO/@_R#,>Zg5
EAG(W)AD0gD#)GFO4MZP3Wa7TZ:(>+JcPVYI(IFB+BH2]bGgg(aHFG(W3\[+/C-(
98BGAO7[B];5]K.HB96&6gfJ6.fO2eAT>eFG8Y>I8+gL=1E]&fK?L?7?Ke7-_Pa:
0N2,.FM4BCLf99@)7BTf,aSIQN#JI#FT.Ab#XLaWCDQ21d-4Pe@;#047<[QJ].gC
UbZM64Ca,.CVRRW/1<0][WcTN0gDN4EeLC?19KJG[F9VaZ:8^,+O\[^V3Y+\?Q>K
VaI];LRB94U/YJ7<YAC\<;ZI-YD/+a(B)[^O9)D7LQWU:R.MC0OD162BEFM0614L
J9UZIf6S/3K1?^;VC80R;F@T;+M]bGSDcQcH8O:^A@]:6D_(5R:3V>&UaT_>>0Pd
C9R@3CcXGUQ4f?H9,H,OONbOS386N@@WFCHL3Z61I&DBg]SF]I2H[,>SZ;d8c2dI
WKd9&-1&CgH>Cae7:KN8^.M?Y..3>VdI_S,Tg/C]cZ.^WG<_cW,fT&0SJA/f,JW^
\cV(KfZ[T&GCVEAPeA(=L+;JRS2Y?Vca6e[JRV5@@)fE0W2?[W[E#80((8KHW@CX
N0-d(3S/94N/VdA)V3WCNT52>@;V3S+5=723ZU@8\MBKdAJ61=IAWF/L(3f-/[YB
ACGW]RZRX1@GAbHEO8-8\-;);L2O.3H+L[]GZ/G9PYNO+LQMQE-d3BZN]FWV5b.\
>dL:NEe5JCSIB_#8^3[9F^2SF0fJeYEYLPcN.]GNQ;UQg/N1@@&[?C5:N&P>GY38
/J2U2/aUT#UOS7Kdg=]++SUe5Y.AT05L@:K7Y)_+36C[5UT^-dD2PVR[D8/@G#a@
PB#TR(&I:2;6ETe&RZe4HPPTCRH,ff\g+:M>JG3GNdUf3_?T0F0aK,a2[-JQZ>Z?
-+5)[B(Y9]45+DbFIJN(W7@)R@^4@(:F>T(]LV+SVXQOU:0DNPMTg[;QdQ_Y>+eA
)D23)/Tc./<:V/2g:X4?^dVDP;Z4^RU-f4>IE(]75F-DU-\[-;fUM,=\V2BC+^A5
F3PK&8\2FPF_WF\B+J])eW]IDM5fD&GaRHg0cS9QD&X0<3K-#P6GKT1_D364Y9?#
<VcPX?V;cJ)VW2XS<>HQL<Q-aF>X.I:Gd+S3-.;7J^<g-5SC2ZbYSR^PM:?^9,WS
SS;2fZX2aMB>D_1<gMG/^MFA5ZdSDB[1NZ<LV//4E#FQd0L)_2[;7(;.PC5gIH/Q
fRCC_)5YEZ@[&bdXd.fO:R/+6-&CH#>d9[FeX[8:GKO7N^IedB0CHIZD>XW:[VAT
MQ+@Y64L8IAHRW>/6B.K\5Q/MB>NV&3DJ8\Y+3bU):GJbD4(NL#EHb,)Mc;>@:c,
+c\3=W@g9;70Ib,\W4?bG:EB5SNf;C2H[,]Gb=\8@N(^eWa\8E_KV;@6.F1OCAJ6
>AGUL7>4)N(7Y(0bL+E-YdR[JcI?_VK8F8_;LYB6aS_7fc,I5=_EfO?N)Mb70>d:
\d?gF?&&=?C;II-MP3e40eH-</c4;MZ&#CeK1Y1;_7>YK;XS1a4A<UD@1_fOe2+c
eL:.XG->Y^1#2@NF]eENK+/;ebF.2;S--@8Cb=[P/?=-;3g5TIU?02;)#A9Z<Q+N
J>b]94bgC]<e;I>XHKB\9?#FF9BN,G(S//T.)76ZI7FL41\TN^2WQJaVZ93JFEd+
2FP>9,];955C(Xf#J1J&JTR/4dZ;?g+CUPWEEAFU&9\D\JLIR\^4#AUf^MPf^8N#
D;g[]U+Z[N\bH,GQ,[3ZMMJI9,2>V5>E&5,@XOUOWSU=?f?,IX4(D&DS]V2a6S[Y
YFNYZ<^<U[TTW##.WZ=;F6b7>S,1&2E5bT2PT9KW+#eWb@Q])=?X1^DWDCgKf+G#
KG?+_A\J,BMCFOJWfLNC[7R\7R>8;#;->Q^G;)?Y#TCG=ZS=YP#629e?cBMT#,YE
^4]]&cF+c7(QWE55Y_3U(1)5d8->,(3T5aWQ@?@X.KSX^K5W-bKNV>:\KMJ8S?ZD
I[bXPV#9<X:PL?AS659BZR:P#.N(1\IMc;2_fYH[#V?#HQ;c,fZZ-Y[Q&a(S17f9
,V10;[;(f=S2ZUPG:@d.8W0N_.Z>c?b^(_J_e)RBE>FCbBVL=S/)FG=D>cbAb6B8
DXVYeJ-U?>3[2A_R\T+X23,>\06:P[c9>B=IX#6(2)N.^9PF5@3_d_AZHX&VEE@g
F^.Oe,8Y(BP#\IT0a?,PAA(^=O[<W8B/?/D3:7[O=fg#V+d2:I.0=Z88(f\-B(A5
>3DN&dS_)V>205D[Ff/KXX\I/(,3?B;M1Z39dVM,^G.QJg=8;1TKJ9H(=f>+KU6&
\eN[)<,UbT<ZR(F6#7.YDeS.J-^W[M@IF00,R9)XDaA?-]FZW>H81_+<]^S#9[]@
B29-WT#&)XAFE:B<O7c&Bd<.0aDJ:2WP:7L+J8Ef-fUIO0JR.)Y],X:a3NMV7D6.
Q3=(1^HGOTFOA&42+]Wd1K\8^Y;8CM7aZ8[=&]+=I8dLTI8GeI87UL6^/G_X^XYc
c[1B@[/=;4#:a@M,#7(W750(M_f-U1g_b[>(D[UA,bZ.11d@8:6-+[]4@5QD,LZ+
=87_N2Y+@#=eF[>\\KOR30bJPRbOSZ3/K@(GP=:.4_3NfC+Z8A9A_Ggc&.-@5Y@;
8_)+@HLG5L[TQ3-X@A56&]<ZF_3+GUdd2JJGR525>0X325c=G.F;MA/0REc?JQTg
E]gb3]LX1;-)NI+CZO,J\5/g,W+&VI[_,]AR18AaE9=>SaP7HX&RUKA^HU_TZ3(S
Q(DJg4JNH36LO_1gQI][75aO8a9bX4.@T=5>B778H>)ZKXO-ZK)49;8Y2CPEcKDU
/bG#5T3JIYcUS9R=6+#bN_YQE=))(0/Nfg0]OT05VD,C826[,=e\C;_0PY]IT)SJ
Da^_<6>8[Pf9=KVT+QQMaB7SW/OZ/;QZ5,O<GJM^L>D6_3g8Bb<BM]@KVc4UaC66
dLDB;ICc+3#U_<:f^X)S>IX(RP>0R(;J<\))L&J7F4g7aXfK]UcBRQ&XD4E/X7H;
G^aaW\O;&2ZQL/fSeD,Va175UNMeN6]>5+K6T&J\>c9(EP2+6A6)NV<4aFBFJ(cB
:g@b4cM?N;P2XF_.JE8F2DOQ4\G.T(H9-0Z5J4)94^I0MMaJ19)+UBG2;D5I239T
1>;T-)#?7P8TI/B@L](IGM+V@FOfIZLWJ(6N39S^,]YI^B>T(S;4Q?#A-dg8LD[Z
BWUcb:bN=-DdK^_692b,\aNH\)^1aR1>Hg4-/Z67FIHcU=ISd<eUX#&:CC5Ue;+,
dAW9<MMP]QB#\HUN[WYRIdXK7BMVKCX^-ASM^@M+8.5R&Va5b5+&S[Y[Y?W<?&2X
>F8Dc&-eSR/E=/:OYLc2P,>/KgU3JX277NaV]cBT99C[YM2:1)Ad3bC(8<\a=GKI
,M2=/<dRFfDW]1ND#KV?I&c=^a&94CGH(#Aac+HfF[>Vdd22DZ0e+D4T&GX&-L8b
Zb-T>aNS/,OQ:[+bWf<][V5KT2gTQ;MEW,;XM8:aUVc+\,g>2S:NXVONfJA@\D^c
,5H=P@g(cI/FaP8+GQL(NJO73ef+XUP&;<:(f^+F(VT)?DH;:S0YB)Ta8XIQUEH#
][T5fA4[a^+Z[FbYSKFc1O^U#cDa><BT(UHb7/K51J2EH3^&0b+/3KbVU&MC3@c;
fXA-4/GLM/GgU&V[^7P\g2LVAWB;V43eJ>EdR<.4O]fZA1aK)WVAd&8+@.-@QFc^
[YV[G,6P.T-@TO6?0INbRSY0bLYHEZOfPCP<;P&2@g@c0f]U#(.cL4I7I4P>Z>\2
EL@-IRL1Q_Q_J07D?^F&]D24D@BV:F1EKJ:0Y:Zd^Ocf.9(-OGCdS(6c^-\<gKO,
4^0(04S;9\C?6eVO@Ia+eGH8Fg+c4,MR\P-S>KE:]>YXX13K49.15dHFY-JT/]aD
WeV\=g=2]Ob1#O7:?b^[Af0M/=.P402@f\9>)#Dae+(T9J-#^/\aZ;6e10]G/H=1
0T=e@3M5W.@C_>19LJ2NU1WG+e\Q31cJ9d\]V31[H9/C9=MC,&]eTIUMY<+<(c2C
cUC1MP7aQ;e&N]SdH3TX1@_?MM@Mae0G^-,GP.Z;1REUN9LA#2_(^47NV<JT0FLF
&-=..UNY:5(_f7H3:N75gZ)]@QG2+D0=3;COcET60F/Vfag2f:P:_U8fJAT2L,:.
H5X68?)g2C1RI8SGGbX=2#e4499eZP0.(Z>b;3^@b_ec/D+c9?.=T]MK#M19<Ka?
Qa-g@)K6CT.QA]R#RN&YC6BPC58WbUg60?_/(ULIDI2Z)f\Rf/Q)OPJ_OdOd:Z=V
:)c@/-UGWe_Q4gWO=G4\R95]?bKCG#c&bS.)0^:8/KOSb35Y=;BNT2#Ec9GX(b9A
NI\H:cTUJ.DE]OF?:U[)>M0<cWOW-abCHfZX.d^L;.75J/SgGGB@D\L32MV3RE<0
FQdV^T@U;0]R+&+0[I-BV3:RcP_JEcV>77Q70Q#/??M72A[HIc,(e:9]bCfWL.L=
JbUaKP-MKgVOXR,T,cFee?B-R6I.\4(&BO?c-F#W&,N&3aC<IOe#ETgO._+)[1OB
UI4>)Y++,[g<4Z&K4YfWd24F;^7XNfI/_)N^8e1]HcaA[&_RN.H&OBYK]6G?],DD
cU:b9)W(2#L#725ON;IZI)5IHRUFgP1.^UKU:&:ccBAXZ)MAWg.E(b]:(?D-;F/7
ARH1YL@1]4+Jg,^(bT:THV5cQ-I4ZA7#+SL/EA)4/.AXH$
`endprotected

/** @endcond */

`endif // SVT_UVM_TECHNOLOGY

`endif // GUARD_SVT_BROADCAST_SV


