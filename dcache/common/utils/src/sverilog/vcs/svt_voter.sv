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

`ifndef GUARD_SVT_VOTER_SV
`define GUARD_SVT_VOTER_SV

`ifdef SVT_VMM_TECHNOLOGY

// Use vmm_voter for the basic voter definition
`define SVT_VOTER_BASE_TYPE vmm_voter

`else // SVT_O/UVM_TECHNOLOGY

// If not using VMM technology then create equivalent voter functionality, relying on uvm_objection
`define SVT_VOTER_BASE_TYPE svt_voter

//svt_vcs_lic_vip_protect
`protected
JQggA9/T=X_)\D7>@_fW)AI>XQJ:5DV,O2#4Peb=APY\?/Xb1YZb)(D?Hb:>:QS]
BGKdb_8#ILaR)X0)d(752Ne?F<5.HK2KD&.XO2<P:S4J(/;=_STSP>,_,)O<gR7U
@.5e7T]gXRc/?_dP09P++FQdNTMb\5Q2.^9@dVcNfDG5>)P:VFEJ__.fHbBZ&cB0
0=CBD:FUFG,bAJXa7JS#;SQd4$
`endprotected


//---------------------------------------------------------------------
// svt_voter
//

class svt_voter;

//svt_vcs_lic_vip_protect
`protected
>.bTaHEfR]Je_F__F[F_2^[)1g>(a/bDUF\VL[E@BQGST6_@YQQc4(A3M#4P:X&C
2#CPX.,fA&Y;DXJL:+2XUIKAV<O4KF:X<;X/A\gA9e+)2g+8>&])I[L;TFdEA?dT
8bBBN)XAE4;CDFU=)EYNCH7_E+R\M;eIdD3eb7JMJ@fA/F#MCc9#;&M:@[L=[@KC
,b:V>S2-/,MeL[L,FaC6G@>9EXX(QN^4=F+b3RPbVCYCA(OI+b<.2Pa9#W&]@)6U
4BcKa49O;XFKJfTMK15O>e<^R^J6e;(L)008PZQPB8_]Ac7/5K1T]Ef#N-Y35?&E
&YMD:5R==Ka7[ZC;9C_@:,OH<@GTI4OX6RLeMbf=WBf8WVFP:=N)H<]EV6?:N,:M
R[TJOK7fT4M+D,4JTUQDdeR.T.ge/VJgM5)RLFaKPXe+TD:ILAa&BZ9&7(MCC,PB
O7TH9=R?,:UO=)[H45S;X>.9)H/L+P-SFR+?d#PPGD0BR.WY+]UJS)7GZAf&,aAG
==4#),CQF^/#RDecO,>YX17[JWfdag6A:K=+9NBW8g\S@9(gT(GX>gg##RdP9e\G
F0+2VSY)0Q]]O]4X@0,,PWa<DU@X+E)W85TTP0EIdYaS5d:;Y+-,7>A=&4]GFUU^
gIbF)F+1c61GNZfOL=dGgLCW_+&7)@W\fWE-67BQF\_I3Z#)5;71E=9NR+(ZI@P&
62?LP6BM.\+0S(F[21;X=.f5c^@,7>eYO[?HZD?06HATDKG067I6(UEYYZJ0BW,_
,IILJ<;)V:MfIegZ)C2X]@G#JUObTf,32(]STGDd9b5,N[MYcb0_[&6?CZ);fY,(
a7?Og?QKTD@LfW]SgWHT?_897T@SA.3G,E:>>^b.2Z;->Y?Z=LWAe>Tb<FCdX);^
D0<N8d3EUS?=WJ2U^@DZ^F&C>KT]GKRbQZN2JB=<Q#8?M9,E^Wg4K>f<<+V:1BEV
c#ZDgJ.Ka?Q@@3BDMG8gS?=:+\,K];8WV,2fAZdS8Aa@?.>Kb(D4E<7X9E7Vb:/\
C_/3P/0CYD#O;aV03Wa+E_Fa=GTZQ#^5VM:Z@6^_0XH0dHIdKcR+T]-Fe<bM#ee/
FH-g\34[e/>86;;,Df?=2,B#R2RW0=^=2ELdR3_>2_P<;UX&48AFQd4RE427R,>HS$
`endprotected


endclass

//svt_vcs_lic_vip_protect
`protected
aLS<WI5=9,WG<a@d59)>(c)f0=-a,P.:7[fE7CVGS]PD&XMK1P?c((<KYSLL=)FL
K4)Ef[08+I:_)BE(D>A1YQ<X#UbMJJW2:_N_Q206.R1Kf;DfQWS8-eAgD-^G?:H1
J]QPUb@Y\-1Z-BJFAg.&g91VgXI9^.c.GP8>UJIM9\WP.V\,P?(#d=/X\-L\Cg-C
#,X6R&1RX2C3aDAA]5c]VVAWI&[5:d\O5]GW/f=b?3,U<PcH=<NW^&SY9DH,3MLE
5?TPA&1]21FUda&(U<g&/6&HaB,#f,I]7cTTU=11XS,C8CR7V9/>ZHJ;eE-;N@PF
#+PYZVK@#A:BeKGM9&&7RE<O7g]Q<?2c&6PURK>457[E);Ef<;[eO[K(gZ<5_?d+
eePEf)Ga4S)+NYUZM6UZ.+URHYB/7_=RJ^0bD,2a05DFI.9b::)#/Y<S;][<GU.2
46HPEN+B])bb=A7Kb@APc2+DS@Y1=Z-/5MD6USQd)E6<&H/P/Q\7KLD9GRSHT^<a
D<^f360=5WaRE+XgR2CdTWQ^8@aLcJ@EHgI_NN6SL^GLEG<Z5<ac&(f8P_(^Ia9Y
3?)B&+PIM,Z\M;?15E(Tgb0ec568D2<#b)<Hb[<eFeeY:R6VGGeQTK3>M3T_<_MF
Q@fN&DUKO4GJ9#+O9&3F_FD<MP):_MKBH#J@@32Hcf&O6\,JZ\UaJTL8WcVL:@\)
Le-A:(NMC&26Y/&c@C^QUQg2)C06QC^RE@B6WEB;J9XN;6:SNR5O9L-FZ9;/4_R=
3BgE;c]1d]IHUKP7Y_S(/]82)YY.E]R3U65[)&Hd\SY_(-/-dHa+e[D#PA+P3\/_
^7fGL<Q_(P)N2LT0;1;[6g#<,bAFFH0aC(<:IbQ-a1dB0E_08^B[eG1R+L7;R\DJ
652eW];e]b1[K11&,B&IUSADP,18=IRJ,f^N8W.S=X8=((U^c:Ra6^V_L&YLG^N=
7BJ_d:L4WBfZD.:g1<H3aG3NSK2S//.A&R.79+)1BGWR3NSR(dc);@.:98S(/_BV
S9UH@F<<)]acUWMeT@OFQ5^bS_AS\K2PBC)W5bSB^;8;CM)[Ib=EFR>C^^aT^(4@
1TTFA>NZV9\GUNSH(fe]Oe0=8Q:\#&W^3Z=/2A:>bV5D69OQ2?>;KPVL&\^W_X>V
<cM(]F_V1(KZ&VOZJ[@V(<SC3e8ZM4/3UR01E-gaBbYeN.QOe#3):G/GA/+?6]:5
<CQ;,>662ZFF@=97:@;#\N#[J=8eD([8,4@H3+/Z/1W_;L[8;XF6@:0T^XJ+g]X_
H#\BMD0M(^5-aZMI8KWQ?63cSe(Fa#M)4#X@OfC[6_D6a6Y#34IWM@7fM17e;Z\+
Uc;d8+)M3+?KW\eLKQ\UQQYaI,CYL@1f6/#X>8D[W\eP=?B3.<Z;L>,70MR/I@_/
JOXN.5H/8/@de7V8EeB64#;/?Le+J^cH#488^BO\Z7d4O=+dc?eZV[Y0eLI_a\<4
+3S;g]Q8AH\@H.UeD?\/@VfBSaE+(AYUaGa96</J<:K^>:_ONX28_S?Q4MC3^\P]
J57?eMa;_:[)I:EHa/3)N\FV2:KMG10^7/GQ1R6eY-g6^CGV&PU>Df-PJDX?P>\E
BGf(BQ:NXA@(g)Qe6BPT5&,.>ARI?>7=DSE1;Q:/Rd7RKELC.M@>QBA0GIJ?2R1F
fd0+g)010E)b\OIP^@_@]1>2FbKH;YQZZg1_gR&3_#]1Q@/9CfHdeCc?#WN&#E81
#4+_a\Q)&/ece_@gZ[0QBaJ(/D7f<O:[<20#5MS1NO85FO43EU1O7,cYd[XdF[Hb
5W95\<9N]^1LCN61JZ8/:MM7@O4g;I;f>1b1XH8Z[=5Gd[4.WBPV0J?IU/IFNeU:
Td/SaV=:EeYO&.XRf3(GD2gB@1E.QFQ1;)\^V-Y(8(&)SM4P6bV#/Vf8ATI7OLdH
6JH_d\ceG+T=4]EP/d7T_)D+2dTH?Q;+/G2I:F/4-_)<SH5RS]8]gQ9f4<F\TRSC
db<-EQD7HTLGBgFL3TH5CBP<,<E\H<b?.^-ObSN-ORN.C+4F/TR]HbdALJV=;E9g
I:8G+#d)GM8UTJQ9>-)T3SM^ODWZfeRUS:DVMd;_G5J0;K?ILGU8Cc(>.+&+4\3V
[g;b#6f^U5C+C7&#JJ/;FgI4\E1C@^)?gFWI1#=7FOO6.J#QTWI2/JL05?4Cg;VU
4;&LN3X@X?_?-UfC<RX3Fdba,c3]3M-@A69fQ+?_1ME_)f^?Y,7QReR-#JWCCZ_9
XI[9:NX>82WUA:6#>g5<V@)6La;A,4;VQ7a&SK>)d>c^_aVQ+=]e[M-0QXI@J=GO
DVFT605RC/57KgG)&7]51HY9AcP_]#DR5[WAUdGE#3Og?AU0PG^UHC[(Bf/=)_+E
];IYbQ?(^<3>.:e(JNeFg5g([U1c+&cU\(3Y5>SF(BVSA7..Q)<O+(>9&1aF97JK
Fd:(Ga#;3B[C\ce#/2fTWY.LB?-:FB4ePLaF)B(RQfF4f]L[Y3(g>SIfS3-W[Ea.
QZ7&&;U.f\&)04,DQ,Ug<MbTIYb6RKB_2/a[K2Z;OJO3c_R=OIf/2.BAIU^fKV,.
#b7Y+-,;Ha0]ILVV^90dfFb9e(,Be6e0))0ZYeGg\.dQTL4eS;UU#12+)8a4ZDR&
\N@_R#_1Ue,NYCR08)0X:R5/TFK-QaPWPW_9b=#X)A<HC^5_]SPC6eUY]Df4R0;#
W=G,=34Z,M3UY^DgDG&=</@X^[(5:_(^7:NY/gXR@YcQ3P8GH)YN2+VU:Z)&3,eJ
XKOC8e1-PH85XVOaB>&<MHT#.2+BF;T,[UZb>dWNIL5Bg4^NVBJ<(M-?MQ1[Z-eS
[.,10<gMbc:gH3.U&b<45SJK-+N46G566G):Sd]5J+bPJ;Y0Jg@1#D^fTSS7Fg?W
+N-g7,d_08ObVe\@U?VDVX?gMJS=4D?(TI:HX?ZIdL-9H/^7>SRVGYAQY^74749Z
+F^I\)WS\(H#,<&SDZ7H1T4PDSIJ]^]aVAeRJE9()4]S4UF>J619>B-CY4Ff04@;
35:F.Gb44__#0$
`endprotected


`endif // SVT_O/UVM_TECHNOLOGY

`endif // GUARD_SVT_VOTER_SV
