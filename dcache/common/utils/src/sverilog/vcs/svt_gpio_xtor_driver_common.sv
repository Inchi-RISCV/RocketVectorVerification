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

`ifndef GUARD_SVT_GPIO_XTOR_DRIVER_COMMON_SV
`define GUARD_SVT_GPIO_XTOR_DRIVER_COMMON_SV

import "DPI-C" context function chandle svt_reset_gpio__get(string path);

import "DPI-C" context task svt_reset_gpio__configure(input chandle           api,
                                                      input byte    unsigned  min_iclk_dut_reset,
                                                      input byte    unsigned  min_iclk_reset_to_reset,
                                                      input longint unsigned  enable_GPi_interrupt_on_fall,
                                                      input longint unsigned  enable_GPi_interrupt_on_rise);
  
import "DPI-C" context task svt_reset_gpio__drive_xact(input chandle          api,
                                                       input byte    unsigned cmd,
                                                       inout longint unsigned data,
                                                       input longint unsigned enabled,
                                                       input int     unsigned delay);
  
class svt_gpio_xtor_driver_common extends svt_gpio_driver_common;

  // ***************************************************************************
  // TYPE DEFINITIONS FOR THIS CLASS
  // ***************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
  /** Reference to the C API if using the synthesizable VIP */
  protected chandle m_C_api;

  /** 
   * Static associative array of references to instances of this driver 
   * class, where each reference is a back-reference from the associated C++ API 
   * instance for the corresponding synthesizable BFM module instance.
   */
  static svt_gpio_xtor_driver_common back_reference [chandle];

  // ****************************************************************************
  // TIMERS
  // ****************************************************************************

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  /**
   * CONSTRUCTOR: Create a new transactor instance
   * 
   * @param cfg Required argument used to set (copy data into) cfg.
   *
   * @param reporter UVM report object used for messaging
   */
  extern function new (svt_gpio_configuration cfg, svt_gpio_driver driver);

  /** Called when a new configuration is applied to the VIP */
  extern virtual function void reconfigure(svt_configuration cfg);

  /** Main thread */
  extern virtual task run_phase();

  /** Initialize output signals */
  extern virtual task initialize();

  /** Drive the specified transaction on the interface */
  extern virtual task drive_xact(svt_gpio_transaction tr);

  /** Eventually called by the C API::interrupt() callback */
  extern static function void route_interrupt(chandle          Capi,
                                              longint unsigned data,
                                              longint unsigned enabled,
                                              int     unsigned delay);

  extern virtual function void interrupt(longint unsigned data,
                                         longint unsigned enabled,
                                         int     unsigned delay);


endclass
/** @endcond */

// -----------------------------------------------------------------------------
//svt_vcs_lic_vip_protect
`protected
/GUU8(fPU]-ZG5(6S42/5##fQ=<,C0Fae6_6CdAASO/LK3Da(A665(_8YW+BQ^b:
2V8&&=a:0J(VO(?A(IX.(0UZ:\4@M\2#Ag\IRPJIQ21.\A@)AC57MUW05N?36SWR
Z:,(@(e\700S@cL-O=0/HVVcZbB?4Gc5LaL1W:;[a<PEW.#fC?^AYCVD>c0=fL@5
V#M(?FgWY0QC)\8&;F?@,>##UaKNOQ=CS^F<=W#<QcfdH)9BHQZED47(VdE?J_eH
c5JgGWHb(.BYYc@022_URN#O:eT4MU3O>N;,)]\7g&Kf>QSNN&/IZ1X^(C@_GZ(H
:/RMDXQ&&G.2UJ?).e\E@Q,F7^ELD5_BcJZ2MWJ2LLD:^b>)PLQdS\]Q6YLSZb9,
GLVFR):7\C&\<bQSRL<FI0&fDS1OV7D&abRRPBQK)EY#IF+3<14#X0Z^,G_>8ZR^
H+?)VZK<?2MH<e57Md-MN0I&JUaZRcB^b/+F65R[?12bPb:F>eV>-dC>T3AO033M
(VcVeFTD=e1-A0+FVUA@HKcJUF3ZOcC857>;[V5#>&CGadd85F4>f6=LCY]O9^5#
NA#7\]H_5XDU\MCe0?<G:PdLWZN5+0#&MPb7b.=/R-:FO>H&@/::_b]S/554K-5@
&:K6>MZV:Mf4FDW4fb9Wc&]g,e[PM9K49FG;HfLO@6T#@[-SH+E^Q98ELB?3fZA8
4#[3b1[fBQ.87,cSYRV(&FCXH(43=[AN5(eH@L,CSdTDg_5/G/(I19+Rf8ET0-.G
S4?Le#]]a/c#WO8T#5)Q+Fd(;Z6\1\X&2YFLZZe#JRfC/70JT74HKX>53c])Eg.N
/(ggb;8aS2S,9gZCLYHcDZ)[1]CTd+=Sg.aPf@49@8Lf[P]b\&4I@7YcK5KeN/G)
Q)(Df0aJ:HVV^QP^)gSIRPY[X-[ZJ8\>:(Sf<PH)dQW,3UBF)/0S:SQN(#^cX8)F
0@F6&G#06YI\/T#@<F4dYKEF[/@-.M^J=ARKI38@B<R3OO5?K4GOf]X6DNR9E2FL
1#1XUB054Q;ZQY;3SZ+A>:\90;/b8g_1ebfWC+#&.GX<N5W+O3,N0/a<.?AY87;G
AFX?8=T&FDJ>Rg/^I6LM:N\04g>S&7ET]QPV#J[1<2&(\2(6BZDd)DN]+1=XJfcG
#SRPMa)=69aPOH&R2dLVZZWZ,S5KOPgTgW_KWG\L>S]VJ.PSOc,]6f\Rc))]A(BE
0_668SaT87@c=ZAB5;JYdW[3)4EF[T8A.?gV5-H5S[[BeBA)=70cV:Q50bDHA+aJ
\R5GRe9CFJ9U;b\?XD9RS>4O+Y&9?+(#aP3^>S9a1ONfM.H7-gWe_X.R&7HV)aVZ
cZ.>HOVC^,H3b<HaMR-@\VEP-ELe2ALI.2O3fPHK:2QSb;(AWABU6&3g[QfRbeY,
51D3QY[6R1=]/>fV2B[Hf9;0H,b<cBGCT0\[XP;:P:@AC>+L#PTR>W_e6B>a[c1L
V\C-gVIXD6Qg7R2BSS5\P?YR>H(@g?d8MQ=ES\5MTb\F=P2=SKg\R_&9#6dC24C^
Hbf2UKHB_aP3ZZ[UTKf(2G=WS06U]2:TH<3+:<]0:]gI==LA2MBSgAeJcf@C@g]:
6.4+VNbQYYY5\.Q?PV;/,V2d2&7;;J:-cEJ(+PQ:0Jf7?OKZL5;c/.=.C-ZK0#\(
B8YNSKPEFL-LdWc\2?;I=L5>\ISDX4B0Q:TXIHT83<(e0PSIaI]]:16/[W0BB9-M
\R4SVe]EHTD.#ZL_JRT^>b+SL1QSLaYPWbKBJ,]Ha[\JACB]8B3GNGaPEFZ^Q#(Y
?cL1@CW-O^BO7CaR?TDDf/G([<BDdJ8.J]7\T(OA]>CSI?Heg1C&&?Sd>a9Ne?/-
H\(&3#[<Qb&J3_fQ=eH?Ec51(M;,ML9/Z7Q2HP,Z=77QC,5IgE74-P-1+J<DB:-O
]9-eM?E7W5;dMQ6MA5E_?<(S.E\a?.4g&]A&/X1<WQ26IR)^\(1;cHUF^)#-D?+H
6E5=dRM.RI/_U/,a0O8e.-+2K=,>JS,_7UB/TUK#=U7;2T3gI63X4ND3EF5.1@fg
Bac2-If5Z\&VKbG[L<JI^L6CX.9_:EP/,Gg9TPfBACaJWc4,=T[PBDV^Y3AWc9@<
DEe?^P+QQ=ccX9_R(Y?cC,I(4Q_\L\Gd9T]X:WUYCe0<gIdPB;F/@bM?6\YQ7700
;>4KSF6X;H(YST#aV(G>/IbMU#_.gUdN5-&A(?3(_XE@?>DcL5L8OWR>J.1AH^_a
X^Y^^GO/CA0]6cQ7>Cf8HCZXA-&&+=,@bE74OdUL-d<7R)e-Rd5FZPCDe<B3NE\K
+#RGP9<[FF-,(1Y3-CTf6,Z3-6g=&IX]_#W71.Bg)W<,G#Pd:\</&WG1U>901/ad
J^G&W&9[)6ggF-?+_UWcB/)D@d+BgR#\5HZ?aI](?9&HUT#3T6MVE(c:^\COe;^X
IIP@)KT&:Q.VU)/T,)fU@EXda0,3\2OAHC\67C^71=E=YEKHHE1)cMWZNGG^/UC(
8=&E.W+9ce:&3FZXLW_FBI34TC&A_cGS4[ZfCZ;<H@bWUXF6.#:AZa;91BY34/bO
]Q)QR[A>)d3683\WUR(0E93+ZC2]IQfEYORT15)^J,__=A>ERc[?C7Ke2F.d5XdP
f>e4&NM,30^R;a05CC8M(_#I:],^02BK;[1)[\^2DIO+A43,>?T?4fL0W>)PgJI@
Oa0@.D7b\HI&G>B5/E8XYg?BFf?IXZ,IBeF)<^><C6N1T=+4c,dK2R4\QX+0EU,8
d-K._-[b\L7M)N_]1/9E4Y>HS1-HaTeX>&8<FIeYGTNb&+RY]L8Z;fQG/<B]Ma7+
?-VE(V]Q.<TI<5<)Ac7:^.2Y.#gJ7<bSMd<>9JBO8[J[(@7W=))D.+bT9BK5JP1c
e?QN)67ZKL[WP^[ADZFX9/EP/ZO6B)&?CUf]YLIaP7V/DN4P(IFSJ?JT.ZY+[KI]
\[#;2eE-2Q)I/,d.:cG^RYaTX-U.GT<a0]cg,Rg1.+LB2)bU>UO^LOVVW[@.BbUI
AEdS8W(XD5XX_<W1ZY-D@/LO3M=\,Pcc/-D@&I>J&5[9a5([B5<69I-P1W)BJ+3#
3P@+8^?1b;T+8E];@KFHbS81+WG99S.LgS@I+K_0<Mcd,\.-2c#IeY(O6:?6Jd,M
JX[fYZ]2a1fBW#G@M__E1@M2AbX1b]VA&MGd?@BX;//O(B.#a^:/^=-</5LY8cT;
d917bKL]HFR2SA.J(V3Ae,M+69JSROX\)TE8Q4+>##Ua1-O#,X4AegK&-1D;WMDC
G[Z\d=\LGB=6DVP#_J+Vf>64aZJdc5g[6YeZ]bdWV1a#:<S6?+67#)H[#AN5>L>=
Y]YED>5]6(W&-M+G[_0[S=[]-=I3N>c-5&^5X/#OREV[,SGe:KOTMaGbF9OI#/cV
2g+:0CfdcJ,&O6<Q.HJ@0gW2)g956.;<bQ22/Mf40gLMOXOFgMIQf<LY8c;_/&Y;
KA=S8NZPDZ5b];J8>&2\:6U[J00IW4:Q/D8F2H#JeCCJ[@/c]^LKgYeDG<e-@C2>
2]([+HT4MV[QCKe_Ob9A55]9VC7KW5?^28C^d7=.H[fS,YFefGNf4M0V8cPNaG<\
DEWbTbQ@PD)S,b[gB[,Q27_dOZ\)&0&VJ;C5OgDPVK99S(R5HR5FH+S:PHg;,NV]
GDaLEEC<E5K<V:;R(=UeH^@,3AYJV5J@JaHW,K.AVZVAd0A1-?2c7\\<4aO5:IPf
W3KfV51VCR92JV4W?F+U_a:,aeFI\WLcH^JgdG#@Yb,6X<)=1N@5XD0XLSMg;-.c
V;Y3YXb+PT@X6W^I(6E<ML9a)TPVWV#IEO73A03]L^,TR@Dd)CQ_bcX8eJa>Q2VC
5MA+A_?c].5.aZP179Q/be6XQ-N<:A+;W61H/2UD.47f#5T0D^9J2V.b_EJKMKH[
7UT8J9<e3fa101]D@gAb&<RQ[L;8<B#49gO6(JW@O,U9D9dOHTY=KI,8\0@M-=65
4^IcDLH0GO@J@Q\48+;/),PL-VIY8I(B>_596T)>2TL2&IH#7HGXGD/[2XQ.;E3Y
UYO5.43^C)e:CeaXe3A=:ZXc6(]:fC@Yfgg_.)98^,>X@_\c\B3)&K3L_R:2g)@6
G(W]5ITV8ES9I(e-F.Q9F08daYW\AJF-5Mf=,ACcI>BD@XK..B)2=_RV0G]C/5KZ
;?A^<8Pg.Gd._76+OC_6eF+SZA0EP[FZ)@JH&B:)4[Q9EV#e8(FPQ]WG]W0+&W(c
P>BVJ=8=0YS6[BPPBg3:J+/DG/);Q[aQ;YJ9LGO&1AOMU2TE_db&:@>?e_I2GHdV
W>fT0=+51V:],];DYBg?TV>=aFb2C\^cH]eQ(0K84Y\D6[IBX,43IbSQe&86abe+
d;^a9?X:7:QOdK=>3<UecF?dJDO9?\9.O6P6R\]9D=]H8SU],5W0Pcg,(MC>d;gR
&e:fJd;S@6O#aZKa^15P_>;O3DV3[2=#g^QVOH-O/<9U>&5#36;C]?UEU,+8)G=L
UV+1>(>8+cbf#e+\[g6;4c_[fBK-3I=X.;L]=_+g#VW0A_B9(-E9(d7G,4FJTEN1
]b.EVb=+K^]LS[@C\Ig37J@<T;ZKI7fDOA4(,Aa--?</+M6eMdWL#LT]aV5/?O,d
0>^>D8KF7,fHgC?_2[,R-[15d00D@aTfZ=XB<VRQ0W96,B^UXB5Z2T-GF560Dd+2
cEG7:f-RE&;5g9K5>&2><2PPE^b&)IE#;8>C5fW:AAMS\dNA9KY;&4LHJe:@BV+J
-YZP]H=#ZQ(&IC?B:);<D61I7Ac^]9H;K.V\McF(FZMCAf[<SbdN)Q[<K.a28aeA
?+2+24FaB[QXE56P)6\>I[3:gTP^;8UHFJ5=UMDV^VeA<^8WSOSJ9)S50GEG]6;R
OVYFX+4/?W]e59JOL&6HL1/cYWJ4aQ5\VS9T52:#JY7(_bFWe-7?EIg8P,g9-8BG
E3/bb(\3YgG?,ZD)e^T)^fKPV@F@)JT@2W64)GZ]/^#B]:fO1dZHW<O(HaGY0+7a
Rg,9fK(0D=.@9VQ7+93SRV,4FGAbX@&:6R,T(dWG6?DER@e2+b8K=HYE3f,0:N<L
M-B@80Ig=\L\C<.BUOM3R^>e,I8af^+(_&&_J0aPaXZ3DW>KP@Y8\T\X>bEd_/_#
6/\&Q2PFL0>)>G0+[b77bOEX7c2Cb0E7-V;,M/N?W2#(e8Rg9?g@(IC4f;De1IP7
/JCU1#MZGW,.(4X7JMS5I^8?)SL<dTK666b7=5MP:LD_X:AS:RHT8SgOGG,U9KKU
?V:Q2R0UJ[Z>a6RGMIEBMbV.T<\U]b1/B[MbZ/^Q=ffA+Q8TB;H5;[:V#P7Hf^GJ
,8-.QA4)H&D=JSQ/gc>#Q;U9+bL+@>CP.JQ<@S.[(C9+.)F#>.,Q[QHg:HZ\UBAD
)cae^(#Q,ZS[LX_cL^BZ#XTE^;?E8#AVNee,V;OVUFc<0EC+?e+=JJUL[a<]K.EJ
4U:FV[d@#_92M9=e+:3L1B?@AIVXGgAc>VN.?995J9,Bf;V\R9@H1]TR=N:ZNB@C
&f+>gYI/fdPQT,T1:3=O7LW:<X_N4aP7dUQOgF#B@g6-I2.;V,)?)GAK\1F:(.A)
d@5,Hc3X=[^^U]3+XbE0R4T+OFKLda^JIPX/0K<ZN5=PI_IaQ.]?>D2:=A(^+KAH
#(]Vc1J[F14.?+39gS(_HN1D30f\YQ8:>X09@J/I:Q_:4g1gT2#^GO(56>be34J.
DSJMNHS_@e)IO98,g8)J?BWF-IJHS[B>\..fO<N&;[&@4T53N^L:KS(dFUGOA,fB
JPB42D;2;X09[C8BMO-24f6,?YTe\G<@RLRFeWB_[cD,P^e^eGAY&a>ZBeO>&8<]
3P9X#CH<AYb+PE1Mg[W&X7L9K/]?a\<F&41:+9;+\&Q/7NRQ/V^?\WM+MF)\P&)a
J;DZ[?PLd0ZOG.6@3F?.GgN4OL)XY?QKa_/f+H_FSBSV+1D#^:T(KX(FbXF(ZVgXV$
`endprotected


`endif
