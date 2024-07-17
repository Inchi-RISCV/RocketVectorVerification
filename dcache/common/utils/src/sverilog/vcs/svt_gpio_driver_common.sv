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

`ifndef GUARD_SVT_GPIO_DRIVER_COMMON_SV
`define GUARD_SVT_GPIO_DRIVER_COMMON_SV

/** @cond PRIVATE */
typedef class svt_gpio_driver;
typedef class svt_gpio_driver_callback;

class svt_gpio_driver_common;

  svt_gpio_driver driver;
  `SVT_XVM(report_object) reporter;
//svt_vcs_lic_vip_protect
`protected
]5Pe]7Z<^<BAaXEX\:XW1S[GZENV:&@Y2Jg\\[4WKH[aL^)9FI,d-([U]5.EddW8
[[^)\U+b#[][)\2Y1Ze?<d85N0UMJ124?fZc(ALcA7.X>M88+<1aTc9DQ5IEN]SN
(M+d?=B)N2AO.eT+eHH8\aaQG46?]G=6@QBP14K3U=\XE$
`endprotected


  // ***************************************************************************
  // TYPE DEFINITIONS FOR THIS CLASS
  // ***************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
  /** Agent configuration */
  protected svt_gpio_configuration m_cfg;
  
`ifdef GUARD_SVT_VIP_GPIO_IF_SVI
  /** VIP virtual interface */
  protected svt_gpio_vif m_vif;
`endif

  // ****************************************************************************
  // TIMERS
  // ****************************************************************************

  int unsigned n_iclk_since_dut_reset;
  int unsigned n_iclk_since_dut_unreset;
  int unsigned n_iclk_since_last_interrupt;

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /**
   * CONSTRUCTOR: Create a new instance of this class
   * 
   * @param cfg Required argument used to set (copy data into) cfg.
   * @param xactor Transactor instance that encapsulates this common class
   */
  extern function new (svt_gpio_configuration cfg, svt_xactor xactor);
`else
  /**
   * CONSTRUCTOR: Create a new transactor instance
   * 
   * @param cfg Required argument used to set (copy data into) cfg.
   * @param driver that encapsulates this common class
   */
  extern function new (svt_gpio_configuration cfg, svt_gpio_driver driver);
`endif

  /** Called when a new configuration is applied to the VIP */
  extern virtual function void reconfigure(svt_configuration cfg);

  /** Main thread */
  extern virtual task main();

  /** Initialize driver */
  extern virtual task initialize();

  /** Drive the specified transaction on the interface */
  extern virtual task drive_xact(svt_gpio_transaction tr);

  //***************************************************************

endclass
/** @endcond */

// -----------------------------------------------------------------------------
//svt_vcs_lic_vip_protect
`protected
-]M(_G_Q<g=3aTK>NC+gY>=@_4CBIDa6(2.;#M&+;\4<QH8=fEU;&(2VA>MY4>c.
f(VD?3=^P7P?5MVIQ1@X9XJ0A.PNE5c1;S&2R(Y_[e53GN;d8LTD<8L6OfOCJ#;,
<E^Rg1037D\Te&\UG=HN1/FW5F09I8=\I]C:3TDNe6g31)eC>SAg0Aa8\CC#g[0e
d&dE=3g7&-4N/@UH7MH^._XU8Ygf&-91cR?Ec.W:YO\+&Q:/]N2?c17V-VJEJa2]
c\]f8f\^66+<fO8[;J^SY-#d9e8KJC[e&(H)(M79MUZ7W)9QZAgdY1:D6MH19gQ-
60KIG68dAW.HfA@M[ORXDB-MY,4-.YNPI&<,F5[Gd7U7;QVJWGD)5FV.^72VO#a(
B)42QMI]/.dXaBHK&bSTBO?IN)Tc2Y&_c:)B[X6gDKS5(^;(-cZIVEPY+C@>:]ZB
-eNL+6(7[89d=G[^2XQ5?9Zc\=UPD[-AaO)aC_=4\E4FS0gVI3CVa:SdG:-:=9&>
7.>_O:43D]c_:e2M,6DP88BA@EH\6R=,^T\T+aV\d@Lfcf;e)_@5fESfDd1V[Y7<
^CT:?X#DQ[EZ(OFe3_T;a@U:;e]^CafB=OC\F&JOMfH+_X?.=Ld+;79a9IeE[C[F
G[D@H\:\UY9J@U5IG4_JMM/Z7#S.[>6EG665U,VSLH3[]8+KVX()ed2YcTWg0dSM
(;S9g+;-3D,8b3-BgSYD?5X#RIIf&-&B3/1aI<BSbZ]>3H7SPWD?d4E]Q_JKR0&T
)JXCTO<222X9+.K&DBY#:L:cdY@0WSgDBf?C24/PC)8WU].J-8Lc,3#TPZ=6+3g5
CR=#5VbHW[U\2OA3Ff:#PS+fc>V>N\O1]#_Ta0[:#=0M_Q]^:BUfX8F>&::fd6>H
Xb7;0D/;@)bd:[7T/e0dbJJLEIH@7+OY5dO;K^&G#).7F>R,M(^:V7=\1M.-HX36
[#@WWdG-ETGHbZ2@FDa)AE_c41ELNGU&.Y<X3e#54:TKUNN7)fUEC(4@^J>1>[9H
SSb;6DHCB@0NL1:JK52V;IY]SfA;d<5LU+QV6SR(gUXVEWO.7fYKg27DVF,II1VE
H+EQ1])ZV8^3G?gR4MW22^&N:KVgYK8R4fS)Z\W)-LIbg.E=^2<cQ]Q:Lb)Db73,
Z7<)34I3MR2gZ4#YLOYC4GG;cYac3]64g6JgAQQ8@eKb(.E/P0KgE3@9R/e#Z,SH
dJcXV[B(D:/[.0EbfD233=Q/7H)I0\;-Y(c8dHHC9XUWB:S&cB;IC+95A@;68YIU
<Z,T(?):R<ERV8Zc.1D<);ZaY53W/5,^_@^#@(?a.X_5bfAJI?-f^EUL3>G_F^7-
B1LEPU:dQV>c=#LGZ6<AgBNP182AL->T>\&IV.\]YB<VMSZK5;WNHTK2FOX3.M;(
cB#d>e1=.V3cPV00)^;9L@8,fGa595O\ZQ)a)P(;LLQ>][=LX8;B7>VgcB;P/X>4
QFBQ8,@_O)6^S1NP;a232-a4fF2),8XY9@G]e1NK&]_47@<Q>BG-6@.\1&&LXDJ#
5BV80(KE2c&0O7c,36Tg(0)MXS-0V89BZTM[dgJ0c_aFVZc(N^eEg&#8:@N=d.3[
5d#+@)B/?36A74\6MB>4SO<ZQ/6QCe1YOM^T_2b3\cOX+dR.EWR72S07\9;^8H#Z
U_#,T?CORTgg?3@9#Xg6V+4@QcOQbdED<Z_4MWK43gQH-,A=/9UN:C2?Fg/A?.60
4(DQ)(VR=KBSNT9#_#M,X@WRN8d8R#Z\;D,Ba+/<B:WU3(2>C?Z<MR.WT?Q?6@/d
\,d.8B_X^<O]b^=(^6#G3fTf3b]Dgd7;;)NB&(0S7TLPJVdBN2L#CW>Y,Ca-H_CU
<&2c^1d(CI-f+LT.bU3;?.Ie5W?<DWRJe73b_bK@K=gO6c5I29_1@BP#S&eA=:+-
Ud3O^5SZEf,PIA^gM1()SH1,XdP)8C66=9@=fH>5KF]/SMHS9@N6]6,]M5&<fPgI
]A51:2T]4a;9H,8a?,cZ^0#C2)]<(g2HN)fd-XEdOYXK+@MTAH16KVa6>f2==T[F
MCf;;SU^L><EB?044N^W(#SUb@M-TQ+LBJSaC<B@1gDgOgAJ0KS0JV\,J1MK6S;S
WYfK\NHICH^?G>LfGUA\=&WHC9ZT8?a?3UF=@,2;^b&G&9(L<=(W.+=CMAT\^b=3
T[+Y+/gU?M\@NbZRA7f=Kf&#WKME4.O.@bPc3>2NZ^E:2eT<Z4_5e(d(/+)#P+R]
X_,OF)\JC19=5:E]e^#EbR[geKdg2T_M?9QeLFTg><2A(a<N8QcL)0)MVP)XGCUL
9NfHFQWIENAe\IUEN,?7IS8?B0N/ILPOB&Td-V1D0L2M(Ue_]WZJBW[2A/]d6_^S
8+g^84N3N2@P:/D:F6M,JV&.e]g=(5,\W[\-J9#+bAHC=JUbFE:27@[5OI7\HEDS
>?ELJAD].Ef;S;R9UF>F#OUO21-c)d\MTT25GeA@W&+W36YTA[/NQL=S<^FP)EJD
I=9G68VgV#=N2N_Q37_2c8SPgbf<:.@.7X\c@^gC,ZP1,LU:TfDMWTG_UM>\]27g
-:+[T2QE__)/Y1U@^Qd<a]OKSDD_I]G;TgF&,(S01=DD7J?CIc_FfeLMfMeO[+8g
1KM2@D?GJBIQ;;>3-.#3KGbFc;L\P@R>C[2V-7HPKa2LQg1+^C/RXR1?D>O[cC.5
Z[.NQd?UWI>WaeY/FCEBLXbWFNBRVb,f-3I_LeLbK@O#:1K&+]U&&Q=Gd(I.Z=FX
11N885_.?V:1Tb58@I]&9dVG,>KR269SWWWZ[AJTIE7[P@K,/J=Td9C>;/KNfFAR
(@YO86JG.>])?@DU[d.MA)G:L>1WMD)1G7gMMBd&(<N>CSSPLJ<AMX^50aa/MM/.
2:d@=Vb+N1;XgBd#:O5E<B,L3I2BTeNf0\]7[_e[G9KZa)8NHf3@1(dROd7V>35S
^:,PM6>O-ON7\<SEIe@SQIU^SL&7Ra)\d]X.>HB#a,;)OJZ>A[O\T-X\E^K=2fP@
^1URQ[O[4cgeC&#A#ZJTE78MGAG=Q71;JbBBd_86Q@2?J;PNTJ8AeNBJ+NC)7ERZ
81S<2_&QN+UX3APfdbOe8O\W@&<VKgLDQ<(+NGN=L9X&KD5=]4RNWZ]E(I&A8_@Y
Yb\c_^E1dg,QcS=0]O3JQVf9A#JY](,7_V(9W]C8CUM4>)T-IPODV4e=.bP-=?fa
,93SF6X#P;X7E_J(cEQB0[@R)aM1_O,P^Za^?Pf=AHN]VMbPP\A6D=5#&S;d-<be
WbRTI/SM^)B>HSa+^8#P7U3eYRbWe^=_TJ?]MDYBVf>bbX8ICAfX---O+BfNU7bJ
cfPH90d7B^2C@MO^Y=Te]^DDfXO^/<b]D9cg&SEY01TId6YUKGUI35==+\?1Xb72
IgcAW[AUNELXTX[1)[Mg(TIKc_GP7Q&EN^PQ18R<[R/f:(7H9^9O[&Y-LB:eM-5^
E7XYF;]WbUJVb+H-\WP:4V6A)aM17PLYNJL.U@6R37/R89>8]@A<Q&2+VfX4?dT?
fG0:=F\KP5544/c85JQ4U+@Z7B-?b87O[TRO9<AE&_fL5TLB1KEd&TKIg2;NET:0
ZLaN64ecO>2Z-;GF8:;VD@5_BFY:AgQ-J4&ZPL/dUW^ZdHX/KERQ>ME/IUZ,bGV&
@LS3&66Ge/3UZWg;_8FT(.2Ya7?F/88L..N0(G^gWg^ZXAc<710BbV-YeZUWTbH0
LQ&PUB=e:fR,=3UNRC)()H4OC<Gge)SA:a^Y]PNDI^M,U1gN]G\\WK)K;.Q)c@24
=)0AJS@\Kf(+L>D;<?>f=#HTYES^_:EeWD6((SLB_IAc5[?V=@KWO(U1A7@E=RTZ
WFZ1]7_C_B5^]?-#]RQ.(OQF4_,[)\8EOW2U.69YF/ZHBg4Ia6K)9@LN/d#:BB&7
MG?V6g.MeIF[bR7A6[gb7?fD0:XD]XFSWSZEDF@NZ]?0KbHN(ODONY-Kb498AC6e
9A^FBA7MW_;)9KMK[<+-SOaL/=c#E9Z+HZ<d&:8^FF3N:N9c>#K(6[XXWZV/OS7S
F-]>8(YY#9\:>[6>-X?F3+R/;c8ceT;9<4)Sg1<Vdg30/c:&:1)Mb><5[/R;44?B
9O#QTA[]1V\3H]Z-,_,D[^@f4@M<SVEO)2G[.SX^.UeZIQf_X(;Z-V]0bX;@#BX/
YbZ]ZL1>9Y9:Tb3G2?-IUfF=Y4f4\4Dfb25dg)F,,06R\4\,5..-R?&;JP:#RR3H
<3#):M\68--8REf?B4R,aB.5Nc-B;IFRBAC_fY,[6CE66)2M^R-)[1#7WU6Y(8^I
&KK5e@RFWWdG=GWgZfdg7P]R\N]JYNc/)Cg(gf).g;T7QZ[#5GYe>8cG22NCZ.>W
YF40EO7R2Yg2.(YZE=U-6B3OZ6:S7@5SUaJC[GFgX+O;1W7J97@+eEf0)1aQ2H;0
=8TZ4CUZWbY,3EK0CRZaPC4&L7a/3Qd&c6VEd4^Y/V3S+T_/\^a5FN4W#5fPfR_T
AE^ZgI0&NO+]MR=T73JcXT=D3cHS\./>QT=gQcT?Q,\_Gc-Jc?d)9G_e@R9(T@;Q
KU/AS1DYV&-@PfQGZY/UA\X.Ia.3F3]]@bC+fAE8W@+T_IcF<PPb<G-eDE46^^A,
[LM)IX[-X920d10>U7(&0RH;dZ3ME/.G+3S6;Z>dg/]DM/a#Z8DWXU1d-AES++?E
^US\.79;#O3HC^.#8X2RE)#(UD[N0E6W6I#Z\9#G?79T?COGNWWOgcT?V:X_V1F]
A5;9f?YbJDS8HMd5&D5Y.(PG<-a5OP<DB0\@BBcOLW=1&W\M.0_VFcT]^>[=Ked9
TC@fRP6Ce<eg:=WBEIEb(^=8ZG&7G(L._Re.+W/LU2HAW6^b:I[6ALL5W9:,A,,W
_Rc=FF8?Z&Uf4IA<MQUV,D/LKH_D1?g>&VBWF8HRWfH3A4=\9CF\(D;P.6gII<^E
/9ME;PeIHS42D.=A6@HfW#b=6_4(L9>FSK0LF4IY=^,M?86@U3Z@Nba05#2Z5706
f\,T64.aBCFg2D#Q_F.559SS-.bDfRS4[DLf:E0Bgd->2.:)/[)0dZGKOERNcRPY
2B[XM)X(_+]<5gd[.dQ#_VdfI5]-_R,J^38?F>^#4dLcAL^YNH&\)I(CWL+&L\VU
YLf[Z^VW?J[K=f7IRCD;#HHccH8G/V_>-UbGN8^?KGWX3)\SbYO+Q4/P(ddU7F9J
d/AG5N4QGVUeHJN9LG)NG5RdFd47Md+D1Z,Z;b(#Od66:g4/?>F/Z@2-.>:5Ed5C
/:TUC6#H64X=gOMPTK/S?+dK/W4LH#?S&L-N(5(N.;TFUd8IF-GRDO21/g^P>.OT
CO[_KI:?CS_cSg<Z#LEL#\9/7@.#d?-V6\\+R1?4b:=GC[We+2PC2LZ/]b-cdS>N
g\CL8Oc7WEY<fOO7N?:\Rf)c&\\9+c_AZX6&a4\WZRL;-L-UdQLf+>/=\U-.49PH
@R#(Zf074,2-Z02A=G;[E?2V\XCddW;AS7OYTU82:R9fZLYG=We77F8GgN7387.W
MR@KPYQ/gaDI(I49c2?/#e&UF;()&RbJ\L[RE6H#[GMW2VLV&PaHE3#7\M_^OL70
][[]S?=eDX4e:Ec[C(<?7+&DbaGaE\[c-MH\&?F;G>Ee9P=J_46P:dU^?T@d\ZE1
:RMd0V0=E9]WW@bJQaW4b/PF>dDYV<2)#c6FQfe?K9@ND]dcIQa/I-.J,fMU?D:9
A;Z<&^RBJg^XNe><,R<e(dVWd<N/D^9P[XHR[MV(KCJYbR(.T9[6?b(,a-OHO]ZL
0^Z:>8876DS=a)F(;?+\PUbU5SO4Af-)\^Gb.^SSc694W><,g6;)@T:NbHI?)^&L
.+V]@-IL=N6Ac-0-]6G\D8:(K8]JW<F5\,b.fD]#EU:cCOC?I_6\VSJ1M?.K]BeL
(a7<a+OCH6+(P9P6K+-,/:bCOYM^Ba\c7;eDN#5#A<UOVe2>#D5U4R#,&KFP3bW(
KZWb(8<[5H2>H<<MB@0^?W5Ld#TBZ2)&Y?97RTD0ZXBSHYWPG-HQ4N8-HaVc\&B4
Q^3&B;MC_5+]eSJb2CPA]:5]@OO<WS1M,3@,&>+=ba],b(.bV:[25#(\U>#>-MOV
<fR]5>1WT[[]PR758/,]aS&>c-Y/)6(d73Kb\F&8Q:cG0+[X9b8H)-&P_NC+#WVN
OT2.d-2:d/(-Ub9HaeE?cQSDg8FX1-+WR+ebK@,D#J]AZC_F(JE>(TY\>;Q^WUbA
D#2-?4ZeFEX(WR<)[PX_Kg?7TKCQ,J>RDF-3,AB)[QYC(I:0#V,IHR,eW-,6ONe7
]5T>F9YY,(B9K_WYL.N3g?b_ZWY^,2H8B8N@03fW,-eUKYK+]ZDPQGUa]I-)E::(
g9[UQ9@,(JgPJNP87OgK84:ISfbNZ[+^GbNdN75?G/D-.LT_\DNG,c1^^XODU_JN
@N3Pd#F,Z>>G9e9:aW/M.>6]a6Y18]TL@)FRSS/SO=^074P=ge_P-E^9,,I?Z#fA
MaRV5f+^FD\=:(<bD_JP1Fb21:TB>^d+K@:J9UU,;]36VeX#D.aP)@:g\UJV7#OO
Z:IM@R&(02DJbDcSb9)QL7U&1_+5^/)(d2c-2+WXa_TD^L>6?ffFNM(CWV30^BBg
HBR,.[_6E:KZMN)I(-fHZDBTgL0PVa7g[+((Ig^D[;\>@+Fc<7DKI<DAOg@;P(9D
OI]&6c97<@CI06__AOaQB0ZXb>],e0)3:)=9?M^eQ9:ZI31)7[F(Y0DAI$
`endprotected


`endif // GUARD_SVT_GPIO_DRIVER_COMMON_SV
