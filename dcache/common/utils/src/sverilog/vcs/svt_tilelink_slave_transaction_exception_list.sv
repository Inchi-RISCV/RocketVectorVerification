//-----------------------------------------------------------------------------
// COPYRIGHT (C) 2016 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------

`ifndef GUARD_SVT_TILELINK_SLAVE_TRANSACTION_EXCEPTION_LIST_SV
`define GUARD_SVT_TILELINK_SLAVE_TRANSACTION_EXCEPTION_LIST_SV

typedef class svt_tilelink_slave_transaction;
typedef class svt_tilelink_slave_transaction_exception;

//----------------------------------------------------------------------------
// Local Constants
//----------------------------------------------------------------------------

`ifndef SVT_TILELINK_SLAVE_TRANSACTION_EXCEPTION_LIST_MAX_NUM_EXCEPTIONS
/**
 * This value is used by the svt_tilelink_slave_transaction_exception_list constructor
 * to define the initial value for svt_exception_list::max_num_exceptions.
 * This field is used by the exception list to define the maximum number of
 * exceptions which can be generated for a single transaction. The user
 * testbench can override this constant value to define a different maximum
 * value for use by all svt_tilelink_slave_transaction_exception_list instances or
 * can change the value of the svt_exception_list::max_num_exceptions field
 * directly to define a different maximum value for use by that
 * svt_tilelink_slave_transaction_exception_list instance.
 */
`define SVT_TILELINK_SLAVE_TRANSACTION_EXCEPTION_LIST_MAX_NUM_EXCEPTIONS   1
`endif

// =============================================================================
/**
 * This class contains details about the Tilelink svt_tilelink_slave_transaction_exception_list exception list.
 */
class svt_tilelink_slave_transaction_exception_list extends svt_exception_list#(svt_tilelink_slave_transaction_exception);

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_tilelink_slave_transaction_exception_list)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception list instance, passing the appropriate argument
   * values to the <b>svt_exception_list</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   * @param randomized_exception Sets the randomized exception used to generate exceptions during randomization.
   */
  extern function new(vmm_log log = null, svt_tilelink_slave_transaction_exception randomized_exception = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception list instance, passing the appropriate argument
   * values to the <b>svt_exception_list</b> parent class.
   *
   * @param name Instance name of the instance
   */
  extern function new(string name = "svt_tilelink_slave_transaction_exception_list", svt_tilelink_slave_transaction_exception randomized_exception = null);
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_slave_transaction_exception_list)
  `svt_data_member_end(svt_tilelink_slave_transaction_exception_list)

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object.
   */
  extern virtual function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_slave_transaction_exception_list.
   */
  extern virtual function vmm_data do_allocate();
`endif

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Compares the object with to. Differences are placed in diff. Only
   * supported kind values are -1 and `SVT_DATA_TYPE::COMPLETE. Both values result
   * in a COMPLETE compare.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Does basic validation of the object contents. Only supported kind values are -1 and
   * `SVT_DATA_TYPE::COMPLETE. Both values result in a COMPLETE validity check.
   */
  extern virtual function bit do_is_valid(bit silent = 1, int kind = -1);

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation. Only supports
   * COMPLETE pack so kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned byte_size(int kind = -1);
  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset. Only supports COMPLETE pack so
   * kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned do_byte_pack(ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1);
  //----------------------------------------------------------------------------
  /**
   * Unpacks the object from the bytes buffer, beginning at offset. Only supports COMPLETE unpack so
   * kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);
`endif

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>write</i> access to public data members of this class.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);

  //----------------------------------------------------------------------------
  /**
   * Pushes the configuration and transaction into the randomized exception object.
   */
  extern virtual function void setup_randomized_exception(svt_tilelink_slave_agent_configuration cfg, svt_tilelink_slave_transaction xact);

  // ---------------------------------------------------------------------------
  /** 
   * The svt_proto_transaction_exception class contains a reference, xact, to the transaction the exception is for.  The
   * exception_list copy leaves xact pointing to the 'original' data, not the copied into data.  This function
   * adjusts the xact reference in any data exceptions present. 
   *  
   * @param new_inst The svt_proto_transaction that this exception is associated with.
   */ 
  extern function void adjust_xact_reference(svt_tilelink_slave_transaction new_inst);
  
  // ---------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_slave_transaction_exception_list)
  `vmm_class_factory(svt_tilelink_slave_transaction_exception_list)
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
?ZG_,?eKF#N\&-Z:?c,6[CSJDDW-(8IA#;GMSFABZ-]\1PA[S2HD7)2-NB-0ZPI[
Wc46T7NA08^T),Tg(])\88L=J2fCY^gNLAS1C0/.#5W(F7:&WIDbJ\/^\;:V&?LF
^d/gY1)d[/RYgM:GDJJBLA](F-J/1f>=E=P#a+EG=NP>?:V/&AMDcfJ(=.R\G-.P
WCeaY6]N;[-X)/R</AS_&N4dSa@\1F5O5RUb@f:aT24\4ZAVCS1WPN?Zf7c7:(/G
KHWB[VNWfK+KFD4)Q>&DQ1OO)^5\5;EC;5WGN:XP63-0J&NI,+\>Of48-9TGWTRQ
+(;AJUO\<E<21DL^R.Z25;JFYTOFR(,g/1=;JdSCG[EO&/,HaJMda1Qa>)g9ee[_
:.QOKDg2PAI0S2MNO9D0F+_#JJ;&_)([]Q8c>GO+SF>7KT6P4M4]I3QL@,S>P\;_
EZWI..7a3J-S>eH.0D=_TX]U2dG73N-(J.@a2VXP93IO8L&K@\d2?6ZfSIQN9QBQ
W)[[;_X9FVXYC5U_TdD\C,8UQP4Z(J^[NA<H5Ld6CC+2+GfJc-:C@NRSD7/I)Q_0
1ggcN-/I80/HO#Hc&7V2eLW0Cf6Uc:T&.(0BYR\cDK1@<K]-QCb4W7;b<eDfcV9g
()YQ3DfOPH==Z;g:V3DO]>b\B,;7923LVMO/J/K#4B_cJa#AHeOe#VB#+;fJXNP)
F8[/+SFdb1]W<5ZNO@RIY@-B_gC^@GSN]cC8=aZ738>BN,:.[D?O0#c^(1UJ<,UC
fWYF.YH&g1:=,CO(GMK/[&#OH]]=a,U@>0R;#a(LBRVC^I8\8IAZ7N5=U?J9?]>W
\YTKFLHSTTcg3M9>XOKG;eTBQ^MT(2Ba1A8O<U[C-T9=-ZVMb-4O7&Q,Lc14f)HW
IIVd1A[N/7gTFXgD&0)QX=-gd9EBL6+gKUF(\>7O[4dUW.@>(M3C5N(GP,dd)4)e
<I;POB:3@9I_acZ:a9?^SbfP]/LI55cc(K)[0F#3^d:eN1^IY&E@LU>C0(J,DPKN
/GM/=AD_5Y7^-Q]2Q.S<CR[fcYHD0BIG-2f-[&@<Q^XFSeQa(0J9M9SBa?Cf@(W_
3:=H[MDII-IO_8#G;cY&.aM=EG1U0-26g7Ee^<.-fTB\a\F21<CVB[JE-6.G..GU
=+JPWE_IIH(1.<1QZEI\(C@-;M5Mf.2IJ=J^T80OV<6QD7K_IbM<4\1d/LKVI#TA
=+#[7+N3db]7eG9PZTS,K\SLDP_g[baSeW#2IPNXK+JgM2]LTKe1-#aKD5dE4T11
:6W)DRC1bb3_e\:4P>gSCX,_+04Cb)2JP7f<4=dQg[7[F/;SZ:L3-9aKL$
`endprotected


//vcs_vip_protect
`protected
dBF/eJKcAKII74eaEN+^@JeK+=:P&QCZ;V\_b^D@VQ[P:MXS2a;=1(OeAO5(EDVe
T/5Q-fAC92RcR807=0/D2JeKDFB+;&BcO68\/->[5cDR^+)8_G9PJ(V=E_)MOIVR
9K@G_N94UF]WCSB=2^VK_SQ6cRXDd,#;76c8+L)OfgaYGS:3OF,?7e.c(I/5EQ:<
2a0aB&7C>?Cg_^1_dRM0FGVXN0TJ?Xg4,X3;U@L9IV;g[&]1=.<E&K+H)0V\Q-[O
YZOD=./Z:4#8fK45eYUa>2&7R^LA.)Fa,[f&R423-+]#N1><N<4fJ&SS;gS<QC=C
]2>QGg=b6eWX7Y,X9]&)TL0X/>_[#L[\.@d^\U+F/KS9-]4I_35?cOQbUX#5BZdB
+7HUQXM56>X634c5#cW36PC<M_ECTQ6L:<G@OCeWXERTNS^4.TX\Q8C94RfIM7-6
dWLS6HWV-=)5V<X7Z+W-,2^F<@BL/BWTcHV17,P36I5c0V]_#EaHH(HQc#=7e0Yf
fCgaZ[3cA\=#2,6D6ea?PF-+VRRF/_NB40Gf\H_0WW2aA>FI2^fG&CABE.&9a6BE
N+[?[MVdaN0NL:81=I5f>9A_Z(NFIXB>ZK_e.CII#79>aeJY7AVa-9..-B2\Q,/d
0b2ZU-5#,2Wc3D[L3[CKIL]L;bDY)5OX?WDd@fU#-.NQLI6CgBO8[a,U=X>A]0OK
>EJW,>&VBPNK<gH@/B.X5NF:E-Q#LJeecYAWX^X4TF2.+?1cN)@98Yf/U_\F84)N
g06=3P>/c7>+MO)9M)PQH?U6W96>)?BTUFSB7g^Ge@a7NTF;9+96(N;>/OIMC&AZ
NSN)_TNFAR>a:KbefQI_US4.:.H=RK=PBf4Uca./T#/HO9a.<98FZJ5E9X>HGgW_
C,XceQLR]<:\H41Z]GYObS7Z#:P>fTVC.gIP@9FXF/;LS>f/?M0SE<7>0\>MD@gV
b>dPA6E0gITNYf0EfY,5X?.@Ed>Z[bb0IXIX)P2LaDXC&0[MG:UV^D_Od.J:S1Z]
VL\?[7?]+d:+ZNU#[#K\_=:C+C6F];1K3fS\YN#TSdb0<\C<_3JSV32Wf#PBE9(A
Odc#,R:#(_a14G/(0[02X=O>/fH>11cCG9?(Y.4I=[^=:VaJ)UGc\a?9.88ZL2=@
\]JF?JZTO2YEGD^<17+(4Jg;;QQ.5GaPI81KRe4E3GLMXL:=_ZHbD)YeX?+5EFW9
gZC2Fad9f06RFRTRWeEdf9e>5dE8^XKHO_5U+Md-U9-[@e,Q;6CM3H^^b=9MB?:G
=]<,B_T1SbGSVP@2KGF3U+N9BJ#=DRRQJ_@#_C(_.c2_ce0,GO\OV3[W;8K-F^?[
VdT&]V^:K;E@HGJQD\:<MUC7Q;@QgHN(#E[C804C&EDbIFRESCeNRVJR?VZ?[7MB
>7/LA.O4:&BDIf:0+I.-ZC7=Z_-.,D/\9R)gXg4A&@>E?G<Ygdg(]\H\HA;#32_B
]fF4C9H3Z3+CYZOGD3,RffId#2EML_+]SFKeB&.&cY,WVYE-DCLE[Y0#4=JI.VN^
KU)6-SL]&e-OMc.DE66+bf[U5L>a4._V^:2b_A#)c9/WU&D2Pb\K+/;7Y6(+VeQ@
;ITaP.+f_7)1_a)U391@3gRD\Cce.K/O?5AKE3Q\d-FIA1X:C/W4MDOAGZT#1J+-
TdOUY9Wea_c3#9\a:-.Ta+d9Je>IHGTUZTDWQHd[K4=Q8#E2PX>ZK01G]XeXb+)=
].2A3X3/G1Q)f=01Y6HAg7e-XQ_5DDY[G1<,B2a\ZR1eNbX[#HT@JJE45=,-f<(\
,>CdO)HA&g5fVDN>g-]][)Y#BbYBMN-C.6+?97WM)&D8GEH.M2cXfBgAVF4gWLIG
E=W(J+_H^Lf@BX3LB=3b?efZR#B[=e2g8VIbXM=)5)1+NY7.MC^]QEQXQ/e2;(BN
JW;dH>f?82&<PXKf[-_A40S@TNDK]1VGOTQN7H:&=TJM@M35-UQ864H<K5V)KNQ1
_RbXe_1f3;>)dXF=-IW-5-V\9-N[a_,?^CP2YHK]//6:</;D^e.;F:V.5[ZI?(FO
PT=S,GUM),MIEe&_RDU/f]FA&I&E4#YL>B0)S[aM1YF6A2T4N>d/PHDY#5:UC_B7
&93)-6M(9E6#04S.CN/>gfc[G97Zbc,U3O:QQ.4SW.4IF:@T4DcL[E>FfHaTQ61^
b:>GZH<KFZWF>_F;UUV@fc[7E#-SLaMH/E:Cg+aOYKTBa9a^&:^L(YB&\6&TV4?W
[N[3;K5.C;]P\;HC]F67bPUYPeU7)a&\25da?V<^9ABUCWJ:U-ZC+f/R8[X+b/U/
M#N<7G#3^J.49KXAB@W473XcWeGa9<5ON6cQ8,W;2_FTgHWOO+RN[OcU[JW_ME+_
g/X9-0AP#;QT4MX6C\+3V#4PMaGS>,CS4f&[0]0X3&KB3Bfg.#O-H34.#M/fDg-Z
=aXe_25gdEdbKDX,34VU>gN^I]WAISR<\<TEH.RaBE]Ndf_SJ#U9&;73YCU#WOeI
HS:@I55aDCC7FKa?A)E@N4X#HE:SCWR2U=/OXA==P>42451<T^72PB]&Z@-6(?<_
-I6>F/Ka\=#6@6M+;B97_YX_c+FJZ_LWR.>-;eP&b@QcA^HKZ+PAf?Y-ZO]gKY<1
fSDBQ4f87__=EPU>OHZ&V^TCcc8C^ZFP4]/a]IPLe[SRJAHU3I29K])])6bNOXHU
(U;02L#2f5BR>ELF&F)3G#1^F)gEOF]U22AYYM>d^:eBKK=N-M@HY>(+O)I.0L4>
EC&>V]56Oc_X&9:_DY7]\)(YAT98?[_U,U3a#A8&<C9>XM83YA_]K4EWL&PGZG]3
/Y]Fc5U(B7.X0_I_S_/c&RDW,\,.<>+LX)ce7(>^g#\@-O(3;]=GRQ)6=]b(ad6T
FZ^OTM0A)^@UR>4_>4(X,);Fe^D]=bG7.8\HH3QMd2X9-(K-F([-6)agDKd5gW]/
Y]52\71M/ggVF28ZTB;74C0JU(279BMd1dUAL@_ZJ1)#B8=?I<T#:]V5=bRc)_/Q
X/3#GFRW[RX:/M^g[Ode#-4]AKNRPaYM1F)L\9Y\VT,EC:(+M>(M>gbYN8V2X^XR
(W:dg:>FND:-Z3=<A/&Q;aX7@<#aS:H7TZSg8HHWKX.(f[;@V@f0XF>Ag:?-FSbS
/C,QZ()O[4\8?85^/7\,YeR8(R))>30I7.@=e:>IGBBZ\G5^N6W_aQCb+]_\A/9Q
K0Q,H6.1IN9GADC\bN),5IMGN\#IN?49NdG5BH4@YcdUKTa,1PRd)VMV8B.THf)+
5+40,_:A4Lf+a>W:;cR(W9F0[T&J@T.AI:aS+b[gb8dFX>VP8+Q:0[2O@PcFASH,
2)AHa22cU+<3_;C.Q^1\.7AQXE(cB2NJN;N0LHPT1=cg#>8N-_]QVQA(UM<cINe[
Ef8DJ<JG0C5,_FRX/MOZ6K8M,SV.3C:]A_B0^-]WYI#aAK;@@dA8NM175Y/#99c\
(>7W1GL@cWY<Q(A4MG51bQU?4=7bJ7_<+cac[V9aKCf8;/ge@c<fUT+g\/U<7I@V
WL=G0=JKON6V3BQUDC9F<+J:@/[#cV\+@05[8#2/[6KRRYb@)C]J.T2?ddYg1@)C
gPcdG0PWf(E)P94.OLNAQ><87,SfM9\R;YSN_@T=)ES941+d5a>CJHc[S1Y0]APR
]O,aCVI4BN9@aE(\#,g5eU7F=b)0Zf=F=R)3?Hd_T(D<_I-#Cg<6V3/,U).VEV_L
VE9TJ6ON3<Y6+8=:HWU;G0>D[,PZNKdfI,;R8/F,fW<]HEUK<Z59[X+D]6?N7POC
=5:/D&C=]=Wf,GFE8aRRI?f1UQG-JE#]fSTA-e&__MP,;62W3QI336(/U[B>90cI
-#_-O0^_FQAbOaTI?LYT\(5P,/>8YGR7>E?D.:bM3=#/B&X(?:OO2<QUYEJ64g\d
[,9cPV8Y]U-K^GT7=57A.\DN;HK5+9,3ACZ8CCYb2dU#9:&=_C2YD#\MGPg<P.bD
M>4_&JFQ;&7K(/A^IQbVYeIF5W;L2_Z.7QC179N/@c2RKcLBB8-)TSG4#BS.ZRHB
NKPV9+Ecf:HgXP)bS1@7H#E2&U-LGPL6<O3I0Te0-ZeZ[^A\&XgG1]Yb7dG/XHR7
?=YHMA,Hb,@AYA6-Y:bY&IO/fTacCa7Z66OX3)T:]7(S5(5<G(J?&1g8JQ&-2@;A
RE7@BU,aZJ<H:?0TA^,2Q=W<JIJ/GJ7d_[\\_3Z85<T].?^=:I+?9Sb1@ZO)adN+
XZ\RY6U@FY5_93U+R-&PEf2W77_2.E?^FVaYX@2[/_@YfZ/[B]#YSYSX5U\RcdCb
X_2N?V462FL9&Wa57PTe_K&&8[7;?HRJ-dUg\=C;cPN(MFeAA4VfcA5>U(c6Z:MT
cQE#C_+Ig[)B?VOCa2WV5MTZ31g(ZD.9[gUe=MDQ^>BWc031ON:B[gHf6IdE#^EZ
5R;HXH1CaI6?XS4OR(>T4)G5=)5,7\@@WJ:<28M\EVea6cdHS45c@_#,_BJ_@L9O
RLE/+eN(&FgL^CJgg17>^g88&\:KX)I?8TSX-eM<Q:GL,SCN73,=bL9:;/F?b[8^
31<KT7BJaKc0,492+SRN(bXRXJc0?[4GYV130/bC[NB/W_HM3AIU6e^[G_)gR+;f
47TJM&A+Y0+G;HfY+]4EAG1dePFQEGKAI0P]/KgS.b0VI_cH<=;+HaL#eW;P6M6Z
B[8P;RL/4AR<f)2-_QV37_BJ)gc8M<B&-:747Qc72WPdB0TQ6+(FZGd-S46N>)K.
O9;/a\.fVgXLIC56^=0eY\^g(g2Q@5F+;F1]ZY:J?V?XDL7.\DX_VT8TY@+SSb;c
E\O8Z0#UB,A,[8gNSZZ\[=1N67LUC;.@)B.K1D7ENgZ\c#cWP\\#.dDYE;QN2=D;
GDNOWQ&FWAd^FJ^MF5QDJV::II#+#OVEQM5@DPd#:+(IM9V.</KI;>?E6./5gYO,
1bEEa,[MeCVI>-0/C79ceS1T4f-YB]YA0P9fLO;M/XbR&g2_C2W:ERXEZ)cUIJ3W
\S<#g/BC=_TU\V]N]SId,O9,00P+QJTWF^0eG=L^#[J8O,?<I4)<_-E2G]^bCa&N
OR3;Q>6f?c<VRC?a=3.2R+Ze.&56HOaY,f(#+5]cU^H<;R>ISG+Y]Zg->e#NP#4R
>fe4XM4/R,Cac\)95KQJGAKgP^X[+Ba2PNUd#+Cc9_ET2CC_&8\^.8&@:+U<cJ(B
-c_IY)S8?+=^U3Dg,C^7+V@1Je4LZ6G.F@@dGF#D#YIaDGC=+KX8IT3,6Sa+UAG4
KU,a(M+E9:_I:_YZIN60C@1M,ERY.(I[_Ca^_5?>7\#]Z1]NQf6@I?1T(;FAc&]Q
[e<&a5^7[S.>(@O-T783(LFY:9[#Y.?dXDS#VMdW@)HOT-D?9F=g5&+8=_NgR6=3
7K^ODL_F?AZEUb;#bQD1N1546;U&C^=\JQ.&I9RCN_CVIB-;g8\-D5B7K>TbJCMT
^1?#P;+YAg6V^I&\(][8BD,#>V0.G=Aa9X)E2RUbZJ>B_X-E]L/6ReP.MZ\e+P8#
+[XFcad8)g>AVHW.f@e@cX7d69<4K6#f7f[@,,SWTAN(UF46N5UD:\M>317_D^=4
LY=AF^IY<6U6a7J1@K:#1IDM9fa=.CG6:;[Z@[a\eN>H_X:;@[W.5&bUFO@PCO[2
M2L,D132GaGe8;+PRg[L#Q(>[Cb#MfJFWD@=+a7MY4acg9[\.KIFV6/aW7?29<Bg
4?7Rd-/)#L0T<I079\@SH1?W?[2g.S2g^3T@VV&UdJa89eaJU&3LJTa[M.0CV:&+
d7IS]-A#gIY);(P&EO]#0HV[L#(5Yd5S(21UZQ+-GV]=C6FIb>O0Y:&5QSNaP?<P
E@<Z3A]+1)6XLFKg_]ae+YF^&f.6&_8ED53H11d^ffZWO)\0YP;Kf_a,[2^]e><J
<cQVJ7f6+@-MD1/P9/]MFDUTN[aD_N,J>@4C#SY^3KRHNM732eDe1/B/aPNH0DX.
]-A]R=BDA(_<V6W^VGL7]a_,N9X2\:3b-M&dF@S)0_N55^W[/g-<\Q@c7A>2@>_A
S77X?Bd>U38eM#\T1fTd6P6#9\?]?+[2,B&@\RCTNLZ=dT2O?^^ZJ>1M/0XI,\/S
ec^RUX2=\77M2MHaQV,YabbHGG6][Uf\Bg-DbM7RSVO[2Y/.P/GeOU@HG1>:RAP8
(aeO6,2;Z\O/aVe:9bYBDK:&>YFfN,cC1cHSfG8Uf=<;>HRY95=SC\=fMZ?^C8FS
G(^8+/NeC0,QaGV/S&U6??&ZN@QfBcg]\I6T-BJ?5fH..AT(\_T_Y3@<R-4?BG^8
&1aQ5XSB#JVF=d_C1EG.cQf4.747]RK@8Y8X0GVXTI9ESR4gUee&+--HN0,L#&G8
@=,/EYOEY_5._58/ae6DD2]+LL4[Z2d4a8B;:RdACA0A+=/-Q985L,O8EX)IZ<XP
&S3M-+ePRD9Gc]&:X:^2I^g334S;0G17gcM)L^?#gPUc&Mb,0Qa.-_NA?/,77(I)
XJNV90YQG1ZGDQaDBWDFfZQ@LS\[b=G@c.OV]T?:SEVI^?]NZ+,UI;UePF.&L:BX
=R?[2AD2P8^_L(^PG&[<Z&@6PG1ONJN17ED2@_1XR97K[H=:2(g0YP1>c3IH9=@=
gK=4@+?edX_9DB5_H0VBB^9/S_gYSJL6c)BL@RY)9FC;b.</_0,-_c0Y64Q1T:M[
;X;0\V>>^2?_4>2QP\#gF<JeL,H5.2<5:I]-=9.ZDRX;COQ)cVgLI,S;Kb9X0_36
P6<[1?J,WK>JCgf.@IW2_&E>=f&,eDNCJMR_<?54W&7BJATD(f[+a9HdTfgO;,aW
FH9?,<>AO;C?WM[=RaJ;]SABCV4#]VHV9Q=N^T[<.H)GY(2dO:CY-:8RUZ/_3,@,
#09JPf9\U^EG;>=@>>CG\=gL]L<TI8:4X.29]2_,81Ae3N<e/c@)+717JK6Z.RRY
)NH]TP,PARYGF+E()J7fb98c+(ODW,Ia-X3],OVD>bg^5Y7/?Q:P9S5;YeW65+(.
@B1,V[K#G#1+eg@?+D2EKeJfT_VBV^G>dKSX];7LAH)0_I(+?A:PT:3#WI+KX@ab
?PZ8E1KH2[42eIYD;67-D;Lg&4,TVBK^a3VIMeV2V(dNHN9UaVeNIK4M1=UV,F-_
G10[B?6WXWAWCPYAUJH:Q6(7VWf@LG2H9+f0ZE-,H+SYMA<;[1S(LELT>9O:+7cC
/f8ZW=LFH7dM8VgI:bT]fE,?a:f]fEgQf[?L3=.);N6;PY_F8AKQCEecc@]fX,X/
(GJ.[[L,)80P0(VOVC,G)+f89B?D8^R5N7AXg)V:[J8fU-CXCF_-7GN.b.+\XV&2
PU0;b2/>.5[bH7Oc322&eX5c&2&DXZK#9K[AdX_C4&MZQ8J1JaA<UCUJCbS+)7L0
3)_(?Q7YL>,9(LSe+Z7e,0TB^3@^d1JEY9@0#.8]e(Z>L4/-_1UX.NA92-8R>:X7
32g&PKBLg1S]UGV,d>^MP/I:#_7WOT+Bc:X(5]EO7.N8TgY=aSdKJ?;E8/?Ue2(A
dA^+S88GSMUFfLXLFE<G\I:0EKReH2cKK_c7N]U2@)GVF+Lb_@[9XRfKQ=?7QT2,
0Y^cPS.NG.Td@\^+;?;4#aP?O40U0HXAZJg694&SP>^^]8[&\Yc#MB_9,:M-74Ye
90=7WI1S)gaIJZ]B84feHE=(D8?2,W?R8ca[EcU6VI28MZD9B0/5?2+4BS9aW]ec
GY;d,fI+XXI8O_a1^)1\eL_I.;3E<X6+M@5a(VMXeH;g4d(_GL\KSeY(5.7I_ZR6
V@9-/HPVSd^=RX)UeRB^/[9gVeGd92Q9/_4dV(?0M:_.TR7^1Sf\]IfPJR=(8&1&
9^V^48O=>_W?I<cX8?G)SKD7>)C]b>S(::/659JXJR:Y>T9BF(X9#2/c^HIeNSQC
EA\_P@^:aaH4=(c)S&B^7Q8LDbFQ[CLLbK&^N^<b#b^K3YD=e,:5e:DI2NK:#]GU
(0QMC+b7)2V\+823U8]][/:-2.f0\d]Q<;/C+@dTC+L/RaQadIT0D(5/H(WVX;&N
:f?gT7WeP]7f55Jg<A,/caN9e9gfJ&AI_(=G3R3QIeBf37>E^9G2;?[bE08LY>FD
H;\&>V#Z0+A:XUL6cTKJLUI1RdAVW8Q\T?7H/OOc>N7aV-MT-PHfB+?0?A,W_OZ<
:@GLJgAT>RV[c8ATBdE6Fg(94-3<Y=]eU)F2b_/HIgUYFf_5RQU(cE/MG<Nf,?RU
G&4Ud+<>^?:A7D7;,@/#OS,_73&<3Mb68<-MF/X&B-J.S3YT3(I99fF_HA-)Z@6U
#KZbTF0g:HC@JXZ/MD:Z4W8YbgE<N),_47LA^Nc#+G,JU8dc8G)0dH:b/IDCGJM0
+B7cF[e]2/:Vc.T-16c#_b5bfV2O-NRYI&D0-.3.X;7[)/^6H?QOE#J\6?]c67HK
4VG4L/#:LOE9g8#IR=\agaU0V=>MVgOS.GaL<\QHRgTLQa_H4-\I-[c?G8fcOYI?
cB.UYS/[AH.O,0O>E)=<ad/-D,6)g[VD^TY_VcI.]A=g\CG\>8\f/90+MW/)(#5J
,X\+&eP7SdLE&^UG?.70d/@Z_d.Z-X[[Ca/<+KC68KLVS:Fb2M:)WbZ<dZ4=WgV:
gQ2VS.^B-7,a4\7QPA^eXU#P4W0b6>aAW1Q[RA=cdGPLeFB[L9eT[g;.R9T[d6A1
f?Y670ZeJ<J_#7f6H^FFL-9(BYJ/B2?DL.[#WP2F_+(^.P\-aB^^JK=SX+A(\WeN
HGaMM3BLKX6NEIVUEKF.9;TJ&&-AF9bKSGG\8R3c):8Te(&?HQVS;6RX4PU50F/7
CG1C0]@55+=aAC-WAAT75;g7A5SNU7>,C#8VSc2b3DVHBf.e&)6SJff;TVG=(;,\
QgI;d<+FWb&GMS^2YFM,CL?Nf>)4@Z#]0/C3XZF);J\LgC[T/5)>fRM6,aaD=/SP
a8c]OLI7Od\?PJfa-bMWVQQ/+,fN5.bXPYT/BE&?]6IV1G+.[>P->=F9I?0LWWd2
ea)YXcE?GH9b;--W&7@_12,.5UN\.&3LKL>4O\+F6<fabKa<G/<B7K+-,G:GcYX.
eBOSRJ=Xg7Y+SF1+H7J45BYNQIS;]9_g9C4A-U@A0dT>.U3J]AE_^+=TCFb];GFD
X__+)26TV-UUH7SfE_&H6B_4;;1S-[JAENbb6L5]6X<)+J45WTe1D-M;6=B[V7<4
P[0XP.5Re=3&H.^08^@caUHCE4+\4\/[R&O3=__]X5/JGM@<5Q,e&A4QadGFO>AA
&K62R@ePHI^MI.6:6K34<YAFJT1FW9^PfRcBBc[d7==P_HUeW&HA\B1:8:>&YGYA
[HJ@3G#_DF]c??.BU3-UQ?@T2da-_&JS7&aW@0=JS,Xc?B3bO1/e8X+ZVf,.BEN/
_)/PX2,bQ+fFIN39dB()FP.3]GX,-R[CDY>cPdZ,AXT>;W11/VFZdUB@BKJgR-9D
IgMMH>fWa]K8bMZHJTE\0.+++d,WJOL86V+,I]W==ffAGB5T_))?2bacD-[g3>()
Qa,Ec=(&3f;N-V[b#a>?0U2U3:3J&P-X5)H@_>)2WZNB2,3.<M@W.Ua9CK;\9=PX
/:X<7b>P9BKNF_:A:?Q[.RQMR)DGHX7]?8HYB(EZO:5V4A=917K=Y>E>MMdW)2Jc
gLZJXM@)K4Sa7=\V\e4FWB8?gMQ;5L-b;YKZKDe0-#R^3YXc1eBP);e9/F?JZZcZ
#Y4:3,A6ATXOgMIQEJcI2Y;0>;>[B0becA6>[R]:B&)RD5EH81C^D];_2JF@a=^f
C0LfD,a/#IB_]Q#IBLJ#]O9Ea6D#=;7@]Z^d,MZ49NH4:)1FO<=cXQ&He,#)&[a8
6<(A?HfYFg&68EBF[DS7FbHd)-YS#0,8HKIN^MS=I.b-H])H32D4[VT&[WS_JY7X
NVWU,A84OAY3/N4#bDYa_9c:NU(2^+/S,F+gOS5B\,L8E.U_2ZcW4N=\,E92YB?X
a8-We6TE?_7G3#T)WR_Ye.IIUc]Ug-KW1O8O:CO8CFK(cV,Bf/(EHgf@D)VP0/0.
(.QQaT9LV[c_Zc^b<#3CLH\&[Z[G<Og7>F_=+bH_c+L<;[9C@VA46P5Wc,a6g5/S
/&0B4?fU;bH_0b_.=X[SO4_;gP/(#d24W_YNU6;+>cLbg<EKLfQ]eVO4UIF8TC:B
S]\UNMZX]G_8.A@(H;[QPd]8eT?AC@A&]0H]BK)8]WLd]KUY\SHd\L<[6B?.6;.&
W(aC058ZQH<L+Z1,.XS5g,+GM[83&2I,IdE&bfMb#I2fKG3U@eO<)e6\eOCRFPE0
-ef0bY2RFF]Q:Ce-cTT\>04C1WQa6bbZF.Hd>V,>SDd0YR1?HPT;L8:0_9&G0@F,
f&?cg8c)2IbeZdR&MB#NULY(([@9#[X,?B#C6N>W&C>gC[f]..XN[H4,X_XeT\+W
>=\.644W522DM.>GQ4@==U6H8c/<d18X)=&1.8A8I81Y0T8GeOX4OAQ\@\cTJL/V
O:&WD.gCTF([B_OR+c6LA:H[ea1e1WQfHH9CHc=(LP[BQH56Z/ac\dV3gV:5e(DcV$
`endprotected


`endif // GUARD_SVT_TILELINK_SLAVE_TRANSACTION_EXCEPTION_LIST_SV
