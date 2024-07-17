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

`ifndef GUARD_SVT_EVENT_POOL_SV
`define GUARD_SVT_EVENT_POOL_SV

// =============================================================================
/**
 * Base class for a shared event pool resource.  This is used in the design
 * of the Verilog CMD interface.  This may also be used in layered protocols
 * where timing information between the protocol layers needs to be communicated.
 */
class svt_event_pool extends `SVT_XVM(event_pool);
   
  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /** SVT message macros route messages through this reference */
  `SVT_XVM(report_object) reporter;

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  local int event_associated_skip_file[string];
  local int event_skip_next[string];
  local bit event_is_on_off[string];

  local bit add_ev_flag;

  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************

//svt_vcs_lic_vip_protect
`protected
CCdg<HT7>BgRb?OJea-H9M7X(&)LKBcAbJ(8+gbXMd6ce&b4g([S5(#Cd;YH.\?V
:]Z:&3>bdW2Y.A3+^CT#X\5?_=XO3\DB&->L#M;8fM@&N/0IYP-L1TUH,WK;]]FY
0/F0V1Q12XUP##IPB\O>5Ee?-VEXV9X;g:9)5e;aBD7I(>.4e-^/K@I+;?Yg8d0U
0ZVIR0U?V?>Cc)YLfPOJ,8T_&HBY\4g6&60?TD1-6QTN9KNX<dJ\CU6a]&TP]1>3
B0_^EHc8Z6b3#7+X8:ZD)Y#J/WN\ZGV+:;6#F1gcSb40NR#4UF>N1A/KDJa>E2eL
QJ6;(;>:\TSC3ZE5@f7,d=g;CT7b.BJ.L?5Q5XSZ=^POX)ODgH@^ZDKQ^ZX=d<[R
3a,fS_M,V,,_.X6JE#:a4I,<adfIeVO9TbTEDfUF.,;<2D<gX6Og=^72&.PJF=d#
a]BBPEC+98bE3_S9>:]Q@5U=1823e:QTR-bJaFT<WK#;1JZXMZG6g]b#;ZAcW_-P
b<[>>)(M/D1<8K=UZ6,QU:53MVP&7&CR4,9[4NQN5@^-F2/F4G::4c:Z-AD@78MF
2gfT^]_)[,?U;XeD7-b)GF57?[7E0O3?J#7QgQe)]AY/G9W-,?+XC@YC/L8?UT/Q
2=d6V-bV#+L(g.e0:gX5SNbXF1C-Xe?#^5T37W4gf,Hg&M4UKHdc@cHV;_+_5.Q0
P<K6K>-W7<1K(f.<WVDG9UI5GG)C61JNV0A)E:P8b=(22W-;,;:\@.O=4N50MQa0
[2D75Z;8X2/2JI5JQV]2MK@R&AUDLf1SI0&^HZ6:gI&I-37EC<Df=)Ae)=b:K@5a
)\^\6R6#15Ffd#UU7f95?fS@16API05MU\@&_/81E>[<bG)^g6R5I)F3HaQV04P)
.J-f\W]&?&?PcDaC]&?fN5eF7_,-@a2>/]F2L:3fa?#01A&40]-9;8\,8,A9eHJ0
c#(.017.,GVGf^^a)[UW>ODD=7AJWdJH42fC^XMGb_C0#bKaN^5@ON[F^56c<OWc
9ALJ>IUK@IPBCIB]Lb2+]E]cLNEI&I0_W@SDYULObW6cNQ610UP2B\1-:eaW>K?_
<=?]K;+MeXgD_\6&OAP4L,fKJO<B1P@]7S;3)CHBT6J[_UcE>dGBST4=Yc.a#AIM
c<IKJe38\08NX+GX6.KcVC7+dZ75fKK&D3F2(0:Y_<<4gf]-Z7D4FN#M]1CXU)CP
ULGC,J7X>F=aK55;4<LIW4e-<6cW0VYdT@b\>FUgFCG;0AMe_1+d(g/6]d=@](4/
b9)M2,9HEX913B+>W#;HGT=)EHU#eY.O(ec15)K3eN.+6(Q243GDP4Bc^:@[XBU9
A,\g^-X:b9V(6MZ1&DF063V2))HQAg&+D(>7U>[BdTJG]Ya#eOW&ObL.:FWDPG+(
W8c79UK@NCL7&cHFaD?VWH,8>6[#56[e1Ug2(+Ha5SETUb4ZQZWKbTLTgB_3=^e1
\I?aBB4,1A4&CRJ(g.2b.K(F5P@d3D>W0(5NT(7&42J]c.BNH4AcY6:2JO]d>PIX
J?R?M+T)L:eZ5?2cVfG5X#YMJ8K=XMP:(4,?U3M940F#=7]OQ/4JBNc08QA[S\?U
_N?0(5@X(K((0F.I]D.6-c47e.\cF^VQ:3?:aCg=(#,-VQL<?DC+ZOWd(7=492[.
4Ra0;;aG_5.XdYNZ3-]cbZ-c:FeX3g2Hb4CXYP0R\[1X]>aH_Hc[DX+;f_I@88E_
>1d/.HQR#,8]fV-DM<>3D2,/+>V^_K4YK7QEYc0X]I9J1bO2+?gdI9,P)MYF^RC[
,@cFS5\\8M8V=#2#5IXX_C?=268\]B8ZfX5ZGLT/K8Z4Q8,^N7IW_\97<_a^2^_>
DYP#LZ)g@dRV<D0I_3OXB1E11>;7RX)/=b<4;28=/a&N^3G#HGA.9ab&ZRFY97\;
J;gIG([[>#JaV=/ZUI66AbW)Rf<K68?1Z,1T-LN[NDAH\>b][6&88]?SV4(.LYRT
D_,;89EB8-BGc/gAbe#,:VE]]_S?@V3WD^:C5YMbMQ=ZcIf6/GK+.X]7NXPNc@bN
W()RL,M^[0X4@,YGD<MBb3B+OCA/W2+][b_P9ZPU1[.b7BOJ4>TL4,\A#,)6#NV^
bM,K,6Z#FZW:EDB1OeT/>)Q1UV>)4\@>,c=bQWc;13XgL&dB/12KE4ECcH5;eK-.
:/Ia1M^D[U3g=G]<KH.?8Mc:ILI5Y3/=HEd+8bQ1?\-3O&II&]2Tb[/HBS1HLaFT
003MZ5S+HFc+@XH,1OFb96M^,_[W4&e@QYe4?5H#1#AJ&^;[cSX4IN\:/0(c5L?L
,@&FZ(_g,8F2g0W-<T61[Q&a+#DS-<5P@GP86^+]W8]O\E@B1B?E06<R)KB+X7^c
P</34\e6<C)-YK\R,GB=7a)0Z0^C.Z&<E--?5R:QGIagRV)NJReCIJCUDP@OdARV
72&R&O?E-=VE5a+MAIL;K7AS)U984P5+_e:NK[Ge1BDFFKHL/5@dS_bHVRS<Q(c<
Y))I<R3<X7Tf6V3B0.eC<\R?5>Z2@,J3R(2]1P9EDTEg/K-cI^G[e/B/=:g2U1@6
XR5MfXHCKb0YX;]F:;-HL(bGaa@X0G@G>[P.QU0PY3C\W2-I;PH8OfZ/O2P^5H/4
VGe2PIgAf(9?6C-FVV-N@KGI1E&gfYM[Qc3/<W;B^M1Y92M,?BA&#NCV,U(_VWA[
[_:ZQ\0S^L_Q0<H-UHe.(EVUId&_+1ebF[);:.FJ;eYWX]IaSP.:Ze^ceZF,WbDG
,7\Q&RbcO-EG&g[/&B@J/8NO7N&K)U13\/H_]-K>=<D-)]g+\?2\e3cEfUQW)QGV
=+M7C1S4_[\caH1A&g-cX3bbCO:^AM+aZFJ?]+BQbMUDN=K,LK97\5UF]5JSF@&C
B>H?#J8/Y7W,O5M9<ce^<D2.]Y(SG/2)YSTS5YHeCH)>8g>B+Z.<PORQIEGLYX&&
EKTJf)QSEG+212Pb:;_0.OdT9W&-=/-GS\U.:>U6GfO?\ZO,;@GG1T;G1\)cDFJH
NM>Vb0&dDP9LBecZY<fBGLf],eSVSg/JM5)^f\c&cgP1AVE^0@D)?La\B<4S-VVF
?b[@;I(Jf,K[a.aS[d,=@6V2ZG:G4:P6^,/Ma_eUIaO8M[//&&WR&2PA@2J\G7c=
H4)]DgK1gUP8S41<D-:=04C-Q@bRU,e]7;\(\GKF_/K:YTSH.g@I;<H3c=bVDYUL
>\-5B^/>FW85<1A[W<^N;E9CSaD=DOG54X#EB+AV]I<aJ0T?OT_#_bK#@U[EM+(K
fK_1S+bB3d.P]cTGF:_B65,8)<;bX@f84F=KHKG0LS<;^>4>=DD1H?ACASLDSdLf
U13IC+^CX:^<;K5SSf>?4+IRWg3R>,=]#>e7M(g1,8RKcGC7?@Q]9&C+BaSCYWU>
f=J1D0]8LK80DeH_/WJ/&\5]<)BU>J6RE=(aWdFg5DWc=>abSTX?,dXcN+^JIQd;
OT5N6H>\R^ALW#DCMM9Ib1bdEK268XH=15^]9[eg5#F9#&FdgT#Xd?Q;C5;)BHR\
<->[YN+QJS&8bcL^AH\bI>M;,W\M6N,J4(c[&>DMA-bgYg)c,ZeHZ__e2FHD0EF&
&0(5U6-)01d.)<U/LfRbcbU3cfGAcO-JLHU1KQP53(-dHE8)7fC2?gOG:g[b;X(4
YRaI5RT3B5>BdU&GaL@)F4W9UbE#\YJRV&H-FSVH-B69>/R[5(U;7e]ETOQ9+9LL
<)<3.N7&Jc]NgNM3Q.L(@E=.6?5Ug2XBF:b8+WKAGTK:=\:LQAc02JEe@],UWV87
[TZ#61I=E.e)4_:+c8<O,@?-&J-Q@^N;_=>4>]&a4(c6H<N33[+:WH&4HRLKI_fM
S\OXC,Y00A&9EO8cWPE&)G0T/0G@03&I=Y7/_F=2#TTQH=(Q<,_QeNe=V208TNNP
L7M[0THNg-c1U_:][;8bP.?U>Z2#)B.&Td2&Je/-)ZWaXQO:YUI?f9SF4f^8RN+?
))J/3&:FA&A#3_AAG#@VJY@N@79c)1UI]IY1bXU\X373&)=IBFRbeA6K)Ae@1N6B
1A_\-]JIVDA3Ia42HQ6cGa\^=8Zb6YD;PUK9#<1K6DU9IPg;++OD^MI8cA#/)AAC
UC79F425VJ1N&eF-(K)#d;c()ZHXY[?I4aZ4R4HV6g8R_6deU<QFJbS^]5;5e8&P
dS8W8?R3C1BC>:3(G)SF;SWION:U>5N;MK958L_G5YL_=8-SR)R[_9<&ISRM>F-;
g&N)2GQH.9.ZZH-&//dX9S_-1\EA]OSEXG)=g/\N#J3T-d_/;DC3_6\F(8R1MKVZ
dD/UXG^-1KHZ5>XcUNEb</GR#,Pd:Z<S0VMSI=Z>LQ4/+8aBL(I)R0LS:+,Z#&H7
KWWU.9A?ACS[)&FI0@gO?2^@Jc.eGcDTAe,;.-6f#47/8?:[1N&bJ7P6b1.6eH,,
,]\7>V>4:+YP=Y:FP-_]R]+XD:1]Y[8R>B3d1]D\N(\aM]_7Q0^PA3IG+VHO6)GK
(_R-c^a[SM@Va1AB^a)^;6&)U+D?SE&/7^+Z,5YZJK#]Y?L.8FE+,1O63UX#3#dC
SWDB/S,)8&ZD\V:H/OFCV:M6Yg=:XT)634W>6c?@[NaC.FU34FAA\SJ.8.A?bL?8
K2bDA;&@(R6XPZe(b7e)GYH?af)<Ha^&NZAQ1[ZV:Z7+gdd.40=V?Y\f<QD&c_I5
W3=/Z5VQ&8NY#]<O84FBX<?^VWPU6^XAJX=<MOcAC+U]GCOg=PU\P;X^1UO9[UIc
.d5Vf70(,]3DX]N)F&\=We:A[43Q6&5XC]cP#8_d-7DS()Y)Vc1(FCUMeTf[9b6L
;WJH(V=&/g<U;0>?YZe(TCWUVN.-5W0YHW1:L>V7;TN&-b4gISb;VKR+,&U8UDIY
#KEUPD,X)_J4c8^1NY<<:]cQIHc-eFM<2F^KS&R9N,T-F-GL&]9H^95W<e5RdQEZ
JF<1K;CGZ3T5.S]ZCa8.BLAN1QPa/2J/.?KAZVISUbSV+KL(a-61188RTOX=W,ZM
f0)[eaJ[D;R)L>\BE+Ne@a@-ATdF6X;?#>e4X<5@Q0)a+^FC&)7J5_2N<9;Xf<b@
Z\\=2CF9B1c+;_C,V?NdB_<OP-?^Z3/DL5eX&RggFbRNJ?gOYb8fGS<]VfLgT4\:
[OBN-aQ77)8+#@<0_b14>V=6BZ2V]-V1G=^e.B7M5X;;S)5fN05>4,/2R\1O-PPU
G+6W.Gb.=>d0R->a.R-53]/EQ,R=9b_._(PEaH\GJS,39Qd>_613I+O=BH/84YPd
HZ:<9PT6I96NO=+=0K4]Z9F28^]TN3E2A,2cFKNK>B>7N2.Oc^7<X0+Ea=C#.N]c
/;=8g5_;>@_M.D]MY2EgcdbT_5RW_HO_TC/TB?gE#:,J>9FNNa@P_=ZZB7](_VUU
4gDC=\ZE:B6M.$
`endprotected


endclass: svt_event_pool

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
2M[U_<JB)<JQ(X;J/I7a>7gP+[02;Ob+b)5]>I(3T7V(&N:JPEHF.(_#HW@/LPO.
b:]6dJ0dKJBbTJU)AQE[b6,1NUIf=_PR@/I0SF=+W4a<[Z843;5-/J=F[.>_d3<@
)36&H[@f@)DPJ@?NBe=QC-H:Z#&+C,P.A4[C6bI(37<>1V7K]Qd.>MXMaf-/C@F7
QR/W)L^e#ME/\RPP+GX#fI0TA7U5]aaTgJ95R767-+LU0=M#;YC2fT/a>2;[.<,^
Ac=g=JBU^-#KeF)N<&S,3Fc>O5CXT-\[;SJZ4SCRD=6/8#.J4TT>WV5L;I.DZJ+#
Y\)2)b=G3]OR7N-bZE7cI5]R2ZLb(B?+E](bV].,5X41=dJIY;W3Q?<:Fe8a@9a,
]@2e59;+WcGZVNAYQS0<=YFfU_aA<W:)1A^[J.#2^X6^gJ7^6NWbe33gb7,](4&?
9=GAf8bWQEMeW+4F=cP+bGU5ZN_UF?<8g3^6A:X\fGZ)>KH:O+D1B?>8>+7ROC;f
5KJ9LKBP[FD)EA70#fH\\MMPX,MbdP,MPV#bH/=O5,D(<]+/,0>I63^ab)K?0#c#
>IZ+&YUc,Mb)RTIY@58&O40#HbE=1PB&6[=,PR.bZ/,9&3PVT3CfE76M]Zc?R/\T
,]QY_7F@PRHBY_S>7-6JSNY?B4\17^2_Z;JUOTbP_.-T0+b7DIZ.1DW^G0S),,7.
C+@&461)6XI&3O-ZaLG[a\6>PYf7cQ)^/7S>34]</f5g3[C,]Wf8>AYI(f8_9&QR
12ab(N242e]@U3^ebX>(=0g#U<cEJ\.O4[I,H-&/c;G\Fg0NA0Nc^]dO\IbE:@?Q
7f/R]2>D(@FJ55>,Be_8GW36Z;EM[AW1EW9FN7_,A\F1?2U7+8bM15)aZ9>7;Wa=
gV,;(=Q)JF^[g4[OZBaC;J5;_Y6//T1E)&>/B,FZSC<J4DIL&RNZV=:>M4;1>6_2
O/b]E1B.=.-HNPc\_7)0Z:TJc3&5L7SdJ#N_\Ra;-PHV#?;X&CQD__PWN\-9R77@
YOLX?Q4XcW>U,)0.>c_4[G(/.W>ZJ;>[B_M)YUOgP.2M:AFY8f;]Z&4&500g[IKD
HLJGa(1&&=<J+cX4NZI8Z/DV.N6Z2,;V+g:Rb(8R4<8B<Cb2IUW[@:-L2F)5UAGM
aH[WK;W@65R_g11Y(44@D=#9JTCQ:NH5J>-QO[?[=Z/JBK]LN4\BbTSV@eW>:(C:
^HYZ-e4>;4JZB6)a,K5JOG&S1/>,32eB4[HF(@3CSI;,?U:HaC+[1#a)9E.BUVY[
P(LCU3LaNY8QV3E\bKDJ)O#A>:V+(+Jd[^7X\@XM_UT9HB^:&Va@]9.P/?S&M@53
7N9JF(QPQF)[I[P86HZY#_THP.f&/)V()K8afJ1QNT<DZ5)T9NE#1b(A#VFQ+N#d
g/,[<UH<)W.F79@)0Z>WT>S##A(b/+7V9/Lg0c./3>-U4R(A4<NP9MaAJ+C0?-)Q
_@aa+G<>LL4\/T[).]ObS?4/cR.+BO0ZY8d^Kd2M<McRD+9FH7([J7L/E,P,OLBF
dSeF_&.&1UINgcG_+HBc3,79@IF@3R^fe?[@U:a:S()b=-DgVM40.Q:],HG#SXQA
De./93.((SEI@5N&TKXE]c7GS&S&&^]Yc90=Ga9WK+,__QC^]UFD)IM+-LHaU-TI
dJ;JdK]-Gb7bISIPVDg@ZW-dJV1=3]=bX>0+ZW3VZ_X2W4Lga73]A@Y):^R30X0C
-cF/8G933c\@R/818,.GL+3Ua=]9()41.F:XRPL60RP^,]:QLe+?[[GFX<Z1WT<C
Z,E4CD5bU3dd[gEL+&?Z_XVHD1X@Z4G;?X7eeYEZ462cdHf2I#@5V5X.FS-@:L4=
3ccc\/c8@Y;b7[X<<9Ib@(._33GTEe1Od;c?@6/@?GVWU(0R25NI)=HK3eTE?LUQ
F1.&FQ&[7K4745<0X+5)ccR_\YC4TdGgB7Gc@WaPPUR>+PS:U-P^&SF[3bEdDC+G
@VK.&]gOCLe3G&&d]cEH:3a,A5a.M=Md35ReVe9&-P@D1:^.R=HG_H_&PfLT6;WB
C?=YD#F-6?g0+F8gA5F?Tf+JCE5gU@3_?)V:EAC8fSFbCQ..42g1CfI^Q\AaAE0e
RE#\I2E@\/^,ae>I;PdZG5cbP>bXDXD36=Z5e8ZKg68];X8I?H30R+TBW#)<.=,=
c<.(#2U?b+U?;W^TPFO:EeJ>V;&3906=QAKRF\I#RP_DT+R+ZSd=QOd[\])U3Ze\
#4G\\8eBDTL6_TK2@87<<I9QJF[=KOB.Af;/e_+D97]CF\^DedeeET8BNL9YC^Ge
;8@Dc481#7HJX42TDf)ZIR]=(Y9cR9UGDRdNM2,^SOH^IQ5a<A,ffM:ee]Z)@M)3
MGfdA1RT<Q,)1OX6JD^E,-VP;O18XcRO4+>.SN7VFKC^93cG-SCYPPfGBZ\N+]]F
:=;PJ;1N:c-E,G<.R]L7a1B3#+5D]Q[b@\R>C]XEZTSH^E)K8B0VQ2dQT1LW7_8&
cZ=0V)A>5VOH=eP;BMQA\1Q5,/&1[SW:aZD=K^&e8L-3UOU8IRM=??F=b1VSM5Ec
&BA0PA]X,;N5f,;[c1&TJ:(#g@?0P<8:[L5Z/_d7db#7b@P^<UEfK[J&:9TI;(HA
=>/>4SZM@.f4D?dE.<]6]0WU?U=?&5H:MBW)ZLV2I54U.Gb6]FFa[)#c+6815eV[
gY1W#ea7Q?Fc>]+<GNN/ABZRNb.4US8P2O;3;H<5L87bJU^:d^VF;N(HL(TOMQ04
^5CdGE0(<0/e2;/D<4K@eR;&\b1F,FPE;/RWU#9?_DDSP[GN[=PR,=LM@FbVTZLW
,4+-1Y7=&Q@H:&;0aB7aCdZ&P,5Jf66+)K;C9ZfYa?V.0(&(T[R_<8U].C)P3\OA
+=_:YbK@=SI.CRa#G_,LG7/7;<+E3abTL4Y,Z:;&Q4^4Q.3ZR41(&RYY<ODT\Xe4
OG?&a9B^O&B5R\cJE/1]fDX+C[U&F@6bCf[2)Y#,R3E3dD@)3fT+XI[g_4Be:>2C
NYV3,e]7.QAAI5Id^=Ze;,PS)-\XfB&d\>beQAVS3W7fVM>#70797DW7[#O7aO@S
A>3>6ZWMY=SIEP^_a,eSKEK05@7:Fcb,?JFOFDF9W<TfE#QQb:2#[I_.<HE:cWMd
\S+_-6EP#E7@8:/<>H[b1:#]+[A@?;-[Zc5C(57?,1QL_80NM#ATC(;Y^>;8\\8a
KQ,bI4=[dQ<AE2b2?]5aN/EBbM91T-(_);>?Fe>Y]X[K^B=O-T3e1BG[D#gb-WP>
GIf@PdK.(&\J2Fc7<5.]8IG8=M(Kc=C_\G.,7KD4_.K>J[d/6Xe@Z@Q3JGWD0AAZ
;I+#3D-\9XXK[NDG0L;ZeX\[OFcQWDf]2T8C3G6@H;5,KH(2I]D0_ZC=OKAA_7.W
1KBFZK9WZ7<#&#a12eAW2O5Y4:a;O8M;GG6GD7>\2FEIS5-,[Ve&:?]Q)b,1H+D(
J;b.GXK;R0#]ZK7a,@I.QNL3,VX&d>_(DFSGQUU42(NG&E]\Ree.36R_S8:(5LX8
d4<O3/>2LLYY7VfB(L;/1/b(eRUcfT8?&U&E1+gY+NX<?<W8d54)TA7e.&5(c#IM
=dAc5//29_[/(5d&>_&+@#1<dSB>^VL.0ZP>C#)6+C2C__KdP7NYbV(c[]ASB/<\
39T@.d_U]>.8R,T,IFJ71Ubbc#g#IX<Y;@KD]Q3+UN^6+_a.Z,3b.g)T(DO?:QOU
GKNF9FX#M,N@NL58Q&:S^2]HE;HQQ/E4P[]1?&6WCPNAEU;0I27^.&d?AM23@[W7
=+Q@J2f5PW^MF&F/+1aLEYZ3NI_J6+,[ZV4Y.BEV>KJ>JR8;H<O^HLL=Z>63Ke1a
4RLWE^e1#I1V/#-3fP[3NBIU@c1&G@QX+H@cZM_=[#<GI/9).?9+0LIX?57W;f_O
ISUPbV:NNE\DAEeQ+)\Ad_4?WR#TX_ZbMFUS#I)3ALZQ?.)7e:>4f5g^>,I-.>5V
1-O0+,7BTMT,L3Y,UXX=aH\7(7#B_I(HC(N9A.TGCIUfG&M(]Nb(RL+WeSfIT^-c
(J:d0:B^<.FS90G\_/.PUcGS3)FgcEHL7O#X1[S)d^4f/9H09e\D/TOS+PK2X;MQ
5,>OcK[>Ua+a>=DMQ23WMTcU#aLWa-+0[:&;G3/6QCX(,A\SdKA>4H08X[.J:8>c
A\LS<D#]eW>MF#SC;9#582aE;.f[6_Wc0ZMg+\:#C.DW.F4\=)^0<fBA>N>^UXYD
)P[NIOPS9;\LAafde>CO1IF5[_N8F8++b6.UfMS3&\GU0BYV0,D^d7ceEXdK:7FW
G[.U\0M:M2/(&gS)&]C^72M</H5]@L5bS(EW4?MdK&W-1X,g<U:EMR;/f8U,Xb31
bG_;+2eT4[GcV=SI(V@2d&\2@@,J0F&#>aKXIQGgO:eRS;DT]?@5AZJ6fc1.CKIZ
.ZO(Z;GPN@(5D<1V(g@VBEHdU7gK?0b7Y/)N5A32OO_\F+Lf6cNPAN)@bY\HUWW:
U2U09^):Qf]eVgX<^]ZI\XJ<\_1]VK=dEH/QfSMJHV;fU2I:5c;@1WDQ=QRa4;>X
P_\)F#J4>;EU6-(A([+?A6;)/4EQ-aO>X>&ZF;OE]a0:>,X4e\CBS:VDM@9PRaOY
a<+HW3_PFD]?6(1;@6)<bP13YYg_AXYAIc1CPJgPW6#Y[29g<K<a0/aATT&H\)f]
@?/\?D@Y>Zg@/KBZ8-E-W3D>M\eA><3Q8aLHH.gA9Hg#&c2&JBZRXddg6US^O6dD
T3M.^^g;5UV92HJZUEMY]).bbbd3eI-C^QJR/afaB#[M_W]d)^6?,9=d)U&N2&[G
GDeS:Z\=d[4L?B0UWgC=(]NbJ_V[)FL=30XWD3,^#OfReefYUb.Ge-df\71#8ECK
RI_UFLbG>ATGOW\<\O7<VP3,,<U;1dLXLcIcTACbDJNA,7.dPTCQE)M@+:#<[-Kd
fZP8f1>\cCcF2GGWHUFXY54<eXC:6)2O^gKDFSbg,\3@,6ZdZ#W_47/U@\RS((H[
+:VeA<Q;,NG#MIC(7bXVbgNUGf^.TB]g5>M+[Ua7GPdg2LGOf<aW-TY&7]X&f^Zf
IN,&AZB)OD,3Y^2Y6R.WdX/2N_:5RYBC;JSEgA=C60f4g#E+-RT@6?#0@a/U71#F
e-)N-D/L@8)WK4<)XUcW<T^Y57[ER(\RA,M8CZ1@?D<dNYb=C+MJW(X1G(9)<A8^
Lg?HPQ5dWB4PS(fE^b_-#SB,8TS_0D.bB(JfL+UVLSZ2:C#JP(_:YIQ[/^c45]D[
=.b)P#KaU7#<[@7F/dUeZWMECZP4?WR,(a21[NSaQdIGNeK8[LNI032@M&baWFJF
@gUG8<cd49CY)G-P:+3;.d#UP37<IRaDe^5NL(&H1B#XZC3PBJM7]=dUM@6\(Wg,
\dNd9UNA^VR[XO++EADX87O=+&>0]RR2>A:<A9UHg-Ac/fg4&9.9B#W5<-6KN-g.
Xc]4E1CML]ZI:E\Zc7T918V-DNG4./5WV(@<2ZEIbUJ<a:6F3(=Q-T7;0TZ=_C(<
U-X,.4TL&27e>X).@=<?a2M@XI5d1SU/5V5?J6W5cf6^A3c]DKWgI+CJ[331gXKe
Z;CB,8H?/,+?Lf+A9V?@7,EJ1=Z/V/;2WLKc0?bGCeD_69V1K0PZWE>fMOBZ9a+9
WB]ZG:B^)5K[c#S/)6RD^NOSOc7KJ=/O0HMI^LTB_]41/.\&&#3>,4f7AEdGf6[S
cW.S#(+VgY#Cc,eU-L<LS&\OFZ^b,#<EC1YNCAA]IQ74G&fHGL#f.e)_OMXS++&S
TMAE(U6OK[N/..HH)H-.KP=RFG39JND2U.e:e/Z#AeDf4T75gWe(L=S]()IWC0Xc
B:8b]4^EWb5UOEcG..Gd1?OMW_A:H#6)8@=Y:A,CLHTE+C[/>);M)R9AH98U)gW)
.J>Je@984N/SGDVFOb:[JdU&ZLEgYGQL_^;;,1.Y=.X2gLGI#^OY?3bfY,8HGJZ]
g_J)94PB9^W447#D\L#GGXR9KETTg99PHaA00/<>NAGO0&H35K1=YU9&Xe9V_CL:
e6^030<6DPD?<RLf5Pb;K):O\@R2NI:;IE6[G:#@J8F?eY81f<T6RQ_JT/_=19?N
]7.Z[8AbE,J9cFXd4TGb2Q0&6G9g0&]Y8a+7Rfe).J8V05F#/.6^CC.SbS2?Z2TE
0.B7)DEB#cG,,T[9LSORfH24bc6?eQ.3H5GVZM,4S/R+BAFP7RVU)MZ8/9X9fDVJ
<O>R]K_bJ,XOQ1YL@UE/(cPL=B6>[TZ^OXD+.=ee3[W;eC95:=2AO:OM4MZ?DHb&
4E-a3R6/R/[LZ_?E6Q_I(,RA/G;WaE]1)EKEN5eC&MPDD2Tg4,Y]e#;6Sd4@@D=a
D)+V>DPT8)gFL6(]EG_F(J<3A+dB5GG]FfDaBG4Z:-)@N1PF)ZIK8-_\RE^3S\OO
c;)]YAVc2,A/I]7E0)(>F0\MKUEPXX&;.\fK^>CCYeC5LTB]-WfI=f)ZLW+NI\/L
9\eDUW,Taa&[1O9G(c-,1gMU8V/5)G&;6OUSNY0WNa3Y?X=6.W+1BfU?SY-/>GEO
Lb;#<ZHJA:WVV1E5GQ702@aVL>[#bT]H=.U:_E1bQ89K/Kc4A?<[B#^Y:_:[=16O
dLN\5[90&2?<;>)S=X15S(1,KL;1Vf?Z8d+dSE-++)^-??7;d[O):+GQZORGQdCD
C2MVDg)-F]c51\U9@:3-@[GW[T,I).]:K:^Y[6=_L_;;EKA0W.4+-KFS=[XS-/SL
CFW.\750Y\+[:;QO#_><;Y>HTUA<@ADGf1g0C]\^WfPeR]CJJ+ZV,6+?8aCC,<IQ
DW,[>(Xg-[D@66[7R)PBPTSg-+&d?GOP-Md?6:4UY(6&8Y_GHXY(UJBCQ+O,+8T_
+IDZ)7N_[+\GX^R6&E7H#SdXBQH_K?Ic?XBIe?0PLDVZ_6?]<DJZZ]F>1-)daG0_
9O[6G?1:31-LHcR#Z<<BB[Gg08JQO:).;1Q54)XbZPS0cCXe&4GT7IYWZXf-9A[N
C40eHF7YOgfYQJbeBC&V9]#+I]5TDP<1b)0fcBLH[L>JH,,M<fFJIAA\>]fO3J+^
(4C+\g:U0<H20c@_1I7aD,b:0fQ:D6Le#7_VZXHQF)4>&^^HSJE,_<\=ObZ0Ea?7
,U7=ERc>_6L<IdN0X7,M3&:+T<T<aLJ,++9\O8N)cFO6&QOa#fH@^;Ig<>Y->PH_
6ROOYNOVB&[X;a;N65@5168bS1fTB9CU7L()e<^>-;2)B-<B=IJ<YYM5B][0.]SA
;Y[Ze-cbW;/Q_N((Y_:GK_ZM&-?+@,a,eLcV]/W-501aHA-W31W.=AV8YE5#<#F.
d?@Q)7/-d^6SN,?P_=/B4R1NfI-g7?VM647fAFf>=g>/)EW7R+_:eSP(HLTOP^J0
Ed+J#,:L<A;]P&OWQDFQD96,g6eM:I0gNHY+GI&^IY8Cb[+GCPS.VO=2g-MXN;QB
79-A2J@;A_beV,-_272P2cd3#(BHVf6)V1.10-E\HRbdHPVS/D=KUYaaK^)03X>/
P[<-f:)(Mc(-?-a-,62eN&>_JL2_,F=_AZN&GE4VW;D],;/cV(UZS;9XL]g>I?4J
aGKE\DH5?@66+3DAOb1#),XU[_[=Vbdd3]BL4e4TJVgQ8WL-Y39aJc5dQ?AYDS_A
bND><DI+E/g?T_fY4CWAIJ^/\MBbU+[A_PZ5)_6VaN>+3L_VI&+B9>Pa0TJ,&f(]
N>LJ@85IRZaAaF_15cEgG>gF.LK\2[bF7#Q72__BG7]ZB=JRO\#_aLO]EK81+Q6]
\C8<:/&g4H\U;RJ[?-6M&Xfde^U3.#\ICIEUUS?8Z-#d32C644=C]0LV]UX;+gM@
Q9&A+>I3CfcLLLfBF493\bUT,a_X:_A##BB^<]@9:AbR[=Z+^<&^LMPKUTSNcQFE
/15:c4c[;O_7Z\.HK8J).#2f>#N6)Z[gEEa53^Z3&D=X:.D;f^+&Aa/=I6@A8Q8=
?1?NX9/^AC62PV?-W1ISg//g0_V]O);4-(P]/#>V3Ea(.]G0E&7Pa:/=J$
`endprotected


`endif // GUARD_SVT_EVENT_POOL_SV
