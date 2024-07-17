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

`ifndef GUARD_SVT_REACTIVE_SEQUENCE_SV
 `define GUARD_SVT_REACTIVE_SEQUENCE_SV

`ifndef SVT_VMM_TECHNOLOGY

typedef class svt_reactive_sequence;

/** Determine which prototype the UVM start_item task has *
 * UVM 1.0ea was the first to use the new prototype */

`ifdef UVM_MAJOR_VERSION_1_0
 `ifndef UVM_FIX_REV_EA
  `define START_ITEM_SEQ item_or_seq
 `else
  `define START_ITEM_SEQ item
 `endif
`else
  `define START_ITEM_SEQ item
`endif

   
// =============================================================================
/**
 * Base class for all SVT reactive sequences. Because of the reactive nature of the
 * protocol, the direction of requests (REQ) and responses (RSP) is reversed from the
 * usual sequencer/driver flow.
 */
virtual class svt_reactive_sequence #(type REQ=`SVT_XVM(sequence_item),
                                      type RSP=REQ,
                                      type RSLT=RSP) extends svt_sequence#(RSP,RSLT);

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

   /** Calls sequencer.wait_for_req() */
   extern task wait_for_req(output REQ req);

   /** Calls sequencer.send_rsp() */
   extern task send_rsp(input RSP rsp);

   /** Called by wait_for_req() just before returning. Includes a reference to the request instance. */
   extern virtual function void post_req(REQ req);

   /** Called by send_rsp() just before sending the response to the driver. Includes a reference to the response instance. */
   extern virtual function void pre_rsp(RSP rsp);

   /** Generate an error message if called. */
`ifdef SVT_UVM_TECHNOLOGY
   extern task start_item (uvm_sequence_item `START_ITEM_SEQ,
                           int set_priority = -1,
                           uvm_sequencer_base sequencer=null);
   
`endif
`ifdef SVT_OVM_TECHNOLOGY
   extern task start_item (ovm_sequence_item item,
                           int set_priority = -1);
`endif

   /** These functions exist so that we don't call super.* to avoid raising/dropping objections. */
   extern virtual task pre_start();
   extern virtual task pre_body();
   extern virtual task post_body();
   extern virtual task post_start();

   
  /** CONSTRUCTOR: Create a new SVT sequence object */
  extern function new (string name = "svt_reactive_sequence", string suite_spec = "");

  // =============================================================================

endclass
   
//svt_vcs_lic_vip_protect
`protected
(g\DSdbU2CeQ_e(dbT4AM)0B8=\<.B_LS/ScD)=d^CA42DZZLJDT2(1dgU]0T/^8
MP(@:8,5(N(X0EcG]H)&7g;(YNQaS-DU/KE8X^6FY\.GIDF=a1WC5B0Ka::9bWQE
e[;f0c#9IXPT1,[Bb;FSa8WFXSVSW#[>.a\BVPBGYC((c+fD57,ZM>)Qd07S5AF=
P-Qc;ODCPKGC,U(_W92bDR9<NgXJ<>,.QR<3GJ##K\/\)?I(J\C:ATJ@@ZJF8BK;
U1T[[:H@@+WB19@OUL.BQWf^FY0/Q4BPJ,/.C(9U5_63RWD)6b@ULT<OVe3bL079
-HE3?fLE3Y^:VdXKWZNaVMS=/J#S][D6bU4QT8RNc15Q:;e?=cI^>K7]/H4=M8QJ
_,0RNgG@9E??f5^-S/,L=[W3_S3J0PZR_eX:#-?ZV\R.)^IU@8ANIAQ_T5c)e4Cf
Ba,IK4g1g<B\4aPP)?_>#+F@ODUMJGPN4<W4#>W:O][;VVg;7VAg\1@0g3@+EB?E
4RYF210KV?M9ENC&4J8_YD69)?=G#@MSeI><&V_>VS17-]6M)EH_)>6(17,K#FAE
&0Y]VH.G=Y\Y59TK1<GWOL-c?U>e(e:#Q#7W?RF.bKfPSVCT7V[0e^WCd8KO50X#
Q:gZK;<>#ZO88fE7J]S+-B\bQ,+LFTLXH)IBe]K86F\QQeYBN3fNU3fN(gA<5ZR<
5aU=Ec^HA8?\)2#+ae)adMQHL;dDC8H1)Bg?344&L#/_IJ5V@>a6JE#[U1JZ37]]
[F@NMf_AXgVIP4^VZ7fT@YBG;#U_e,6@W7)O_P<]#cXD+^:V0S&N2==U@K/QX5VF
dBVB(/HBKG?>+fOU]B&;Te=D-@KZeT6/BO[0Q+NJOe5c)P.ZMW3/ce>^O<6.NWe3
?-8\>UT=1#S@/(/Oe(OWCQNddXb1=,A_fcIgN&=(#@EEBfS3/LU7L>31):Zf)5B.
Z:6Cg7GgF\d3./O^6O#1I15E)g(WW]cG8;F+6G<US4.V=dCC&ObSW?=;#5e4/Le2
JZWgW-115#V<R+ZGLT1.8>:X.9DGD_DI6Ud3CE;f-bF8)3+b^[>F3<#N4Y\?=KW<
=CQ>A3D/BeC38]gJcGe53\2aJ<E[\A@,U/LfeH]OV[S7?1b#__XbJ89^QO#(:EP@
<SW8dbWZ[JNKHKX:g.cgTARTG<;VC6H_XgJ2J\]:?9]H]>_TPfNg);FM+VF:f_.T
?3E,TA45N;:5>Y[8,cK&AI+WCZYSHAG7WX0EA[Zbf?@:S:,DMS;X8IVB<,[Bg#\]
7Qb5[,9&5dDF0+R0L+GO&OR],C+7<DeJZ&aJI-:;WL)N]aSUKUe?XTe81BR=R.@3
X[/P:ILZ7H1VI4QZ++g[6PO/Z=^4:;gaJPC&J9TeRca3Vg,KT,\&P@fUbZ8MG\HP
_&P-8:_:SS7FW>)6Y.ff9\Og[5_]I-0dAQKd,6WO/&4<#^BOI4IMPB5.:bW,\1Sd
_^Cc0XJ&,Wd,PZZX#B7:a-69dR7[bBN(,.S<F3cfKA<073e(e_SU9AWZ:?6g6Y/,
=E5)CaIH>^>2GFa#ZJ?J[E-W7)b-HC&fNMa/,;=]g5c)4P2.4C<\4WL;>QP7T)05
(SE=O/V\e<:C;SNN6>OcB8H+)FJY&QONa=6KXW2]I.&J/AI^;J+]a680_cC\Y;4e
1IHcFD9-HKZ:WMgN[]\Y8WP6Jb)daNaGc-6<486H@Jff>]+5:02;[5>[,Gb[He:U
eOJW9\TV9X4MGGZ,)1<O(W4A8M=VL5B_(-C-PU3;]AKSSXe\/=P\f<_,g#@/8M(_
C/@BDg#/RB<K_[cL^@EA9^AOW=Q^0Y1W<.;)14U5P=SIV]2I-gB:3aD&8QQS1e^B
SWb9S=Q7=Q7MKU99E+HREggVf((gb(c75^Y[W;G(Kc^KH-/J_7=./3)4LX9/OB>B
Df9bME0<Dd=OdS87>V4?5Vc)V,<FEV#L+F\-MbM9Cf^deeT4JaB);6g#HR(&]M)[
)bYY_UB,<;P?9@K2f9RDLM\QQ>J#(Y0YX9J1J1(<G>>NSKJ246VL;Cb6-L)Q3@,e
<@AS5^9FQ]3IK_G_aY8gdWWdIIc/M4NcJMI]#gQI0B^@4X(<)VKUD>G#2^R4/:6>
IdM>=e8O&,_]RfR.AF[9Le(.gK??[_K+:626)3UA/B)91[S+_(:.3_.(,FYZ=3cS
UV]7)APBJ0B;[+?;d2ZU78GV);8_g3L&\I^MGLI,9O8/J#GgTe#E?[3G4+deJT8Y
aA&1ESJ02e\4F)P_)TCBGd++]PNeaU#eT<9_88L1>OW1US#.f&;^(?b#_-dE;Ag\
U,cWW8QGWAB)a2-@:L.:S18#G8FIH5P^66Z4UcQ@+D+D94g_34&1/9a64#5e6(B7
3P7EV<.a5/-YM641=)YW+<L.B?U-A6?4cSLE\>IJLNV[L);e79Ic/B)IZ96.I##J
>J4VH@c^QA)J>Re#]^W]Z_\M3_7\1&A6&Jd1e1EYTF,:49JKfDc2(VZ&d>A-S)9+
OGMZ_HHbFUbW.]C]^OO1]:b@M?2M48K--C\DbRf]1\ZZ+WD<HBD(I0&C;=.c-O]3
>T.SE8ZJVd6f>FO3eE26DJc[>:.9[C&3Y\\W0(LE2CX]@WN^SCJdXN\&E;I]PQ:X
]NWe-G4FDVC/VX-/&Z(JPa4BagceAJb3GXV]T>KG7G,F<^^@f=Pc8Z8O8PgX=SYD
46gg\.&]MD>9A_^I7WRXgV[UK@9VDa+OD.^;cTBN>[:@/#P61[LVFU0?[[P@[gWF
,<VOB5Y1.&(-VN+)YQ&FeST:bbb2#Q9LNDeP\SN8KYKO#GeMM>=HX^4:b(2eO6gL
-KX6F0D?eN5f:GT.>eIC8141H)6<d^1R-M]]\C@21g.QgM9#-aWd-,R)eeV\8f,^
9E(3O.ec=PL/5PJ-cS4[LcJ)6(\/TG03F[I78Y\E=CCX/NO?^_T:7HbB&[O+c2?Q
:[82&g[.HEK8b<e^5@c;]R.:Q:7F>IQHa)\aCQYY8[]=?H4f_C9O/_Y_f@dUJ4C3
G52-UEG5#,)-eG2R-f:(4.8@eQPQf2_=+ZD7K:2#b;R8?-eJ2VKO3eE(BX&2Uc7,
A<2_OaIOPg8970(&AT[US:(Ng+bQbIPNgEVXG\W7K=;gM+J31846SR_M5\H;ZL4Z
/V9&e)7BLb0=)+9/\4Y6;2[K>^49;,Z1e-\_E<PWa7:??[KA.g=C9_/+VPY=_,+#
=YYFaZa4IHC@>A]AW,e164(6LI?@(cI/\HOZ:5Z@^E&Bc944S#V-S[cE#WfFCQB0
-6@LR6\[gNa]OgA+T6W2K[4_UJ7eM#[KN0V#=[5PXI@JJ/SN8\a+G_0T=9,1]@[N
DafBGd&49Jc]FE6>:gEa>&7A-(&.?.<YH9V/T?DWUD3;d7=7LHAV-S9SNf3bTc0d
2OYMdZg/^]2QgC9JB[?;5,c<e.W,X61>RK>)5K\XE[@-LL,GOFI\fX2\GX7+L,@,
Aa&#339;29GeG<9F++5@?:f3FCM_[aV5L#<RUZ=]OF:A;A#0,P)B.D6_dQ.I/;(e
0GT#Bg/JNa/Z&81PU&-_d=+Y^\0Y/XL++aT&&^3L.H&Hd77-&,=P;Lf[eM;,DU0W
MQKFEf\IU:S-N1,7,TQ:ANE55MY?GeCS6)=7cJTEX16W6.4fW(P>^+;VM_W=DI&Z
D<C&TD3+g/SXAAbWdDQXQ]VQU[bL&)V\b[CYIB7gUB[>V+:7CH]+8&N[QW\edWWg
G[Q:Ob3(@<a5V:G2^\#LG)Fe.H4R+Dccb1H9Z+I/+PO4L.GTc[M4\Ob.100@<.;W
a-JTFTX;/2AVXIZ-C<K,aNF.Rd1G?OLH5(&L0.218G5O]\#[O3[>0[0&6d7eWB]C
B]HYTU[-9<XT4QCOI#Z&909?Bd;cJ6A(?&H6S6.<JT.WW:0H32-?,6+55ZY6CN=N
d+H1618ddWXQL+.D;W?U&XEb/F&V1TE--@fI-:S69VF.W:]O^3X7@VGPc<[?<A]_
F.R:<?A47UZ(S?S^;PI6T210J3KB\PD3Od-E<5^fZB?>\F-^fCKPP,T/e0Y,T<=_
T^c,I>2LR\SCf6D33W,^H_^Q+?c8C&Ob>-./-),U)0YH,6[RG4.@.,5;(6b;_OW(
fQe5RZ&Ig\#+01Z2Za:8eV<I5NG6K?Nf+]D>@,SORK=:7M/Xf9NQ^Y[EY&H73T6c
OENQI5+^.eMQP95N5W&_@_O=GK-2X^^4IRTSOb&-<OGG<-c&)c8C.NW1aBaDFP17
U4Z>.GU:3RFa=YWOZ93M@/O=4$
`endprotected


`endif // !SVT_VMM_TECHNOLOGY
  
`endif // GUARD_SVT_REACTIVE_SEQUENCE_SV
