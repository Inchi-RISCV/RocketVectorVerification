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

`ifndef GUARD_SVT_DISPATCH_SEQUENCE_SV
`define GUARD_SVT_DISPATCH_SEQUENCE_SV

// =============================================================================
/**
 * Sequence used to queue up and dispatch seqeunce items. This sequence supports
 * two basic use models, controlled by the #continuous_dispatch field.
 *
 * - continuous dispatch -- This basically loads the sequence into the provided
 *   sequencer, where it runs for the entire session. The client simply keeps a
 *   handle to the svt_dispatch_sequence, and calls dispatch() whenever they
 *   wish to send a transaction.
 * - non-continuous dispatch -- In this mode the sequence must be loaded and
 *   run on the sequencer with every use. This can be rather laborious, so
 *   the continuous dispatch is strongly recommended. 
 * .
 *
 * The client can initially create a 'non-continuous' svt_dispatch_sequence, but
 * once continuous_dispatch gets set to '1', the svt_dispatch_sequence will
 * continue to be a continuous sequence until it is deleted. It is not possible
 * move back and forth between continuous and non-continuous dispatch with an
 * individual svt_dispatch_sequence instance. 
 *
 *
 * If Sequence dispatched in continuous, it also supports multiple transactions to be
 * dispatched concurrently, without blocking, controlled by enable_multiple_tr_dispatch() method.
 */
class svt_dispatch_sequence#(type REQ=`SVT_XVM(sequence_item),
                             type RSP=REQ) extends `SVT_XVM(sequence)#(REQ,RSP);

  /**
   * Factory Registration. 
   */
  `svt_xvm_object_param_utils(svt_dispatch_sequence#(REQ,RSP))

  // ---------------------------------------------------------------------------
  // Public Data
  // ---------------------------------------------------------------------------

  /** 
   * Parent Sequencer Declaration.
   */
  `svt_xvm_declare_p_sequencer(`SVT_XVM(sequencer)#(REQ))

  /** All messages originating from data objects are routed through `SVT_XVM(root) */
  static `SVT_XVM(report_object) reporter = `SVT_XVM(root)::get();

  // ---------------------------------------------------------------------------
  // Local Data
  // ---------------------------------------------------------------------------

  /** Sequencer the continuous dispatch uses to send requests. */
  local `SVT_XVM(sequencer)#(REQ) continuous_seqr = null;

  /** Next transaction to be dispatched. */
  local REQ req = null;
  local REQ reqs[$];
   
  /** Indicates whether the dispatch process is continuous. */
  local bit continuous_dispatch = 0;

  /** Indicates whether the multiple transactions to be dispatched concurrently. */
  local bit multiple_tr_dispatch = 0;

  // ---------------------------------------------------------------------------
  // Methods
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_dispatch_sequence class.
   *
   * @param name The sequence name.
   */
  extern function new(string name = "svt_dispatch_sequence");

  // ---------------------------------------------------------------------------
  /**
   * Method used to dispatch the request on the sequencer. The dispatch sequence
   * can move from 'single' dispatch to 'continuous' dispatch between calls.
   * It can also move between sequencers between calls while using 'single'
   * dispatch, or when moving from 'single' dispatch to 'continuous' dispatch.
   * But once 'continuous' dispatch is established, attempting to move back to
   * 'single' dispatch, or changing the sequencer, will result in a fatal error.
   *
   * @param seqr Sequencer the request is to be dispatched on.
   * @param req Request that is to be dispatched.
   * @param continuous_dispatch Indicates whether the dispatch process should be continuous.
   */
  extern virtual task dispatch(`SVT_XVM(sequencer)#(REQ) seqr, REQ req, bit continuous_dispatch = 1);

  // ---------------------------------------------------------------------------
  //
  // NOTE: This sequence should not raise/drop objections. So pre/post not
  //       implemented "by design".
  //
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Sequence body() implemeentation, basically sends 'req' on the sequencer.
   */
  extern virtual task body();

  // ---------------------------------------------------------------------------
  /**
   * Method used to create a forever loop to take care of the dispatch.
   */
  extern virtual task send_forever();

  // ---------------------------------------------------------------------------
  /**
   * Method used to do a single dispatch.
   */
  extern virtual task send_one();

  // ---------------------------------------------------------------------------
  /**
   * Method used to remove all the elements from the queue which are pushed for dispatch.
   */
  extern virtual function void delete_reqs();

  // ---------------------------------------------------------------------------
  /**
   * No-op which can be used to avoid clogging things up with responses and response messages.
   */
  extern virtual function void response_handler(`SVT_XVM(sequence_item) response);
  
  // ---------------------------------------------------------------------------
  /**
   * Method used to enable dispatch of multiple non blocking concurrent transactions.
   *
   */
  extern virtual function void enable_multiple_tr_dispatch();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
EFfVB(Q1Gb9C1#a8eH_3L0M=6J9A(NDI<?:CW?4QgPF?I+@C=4_Q,(c1_NDg-ZLL
fB]VDO1ZV]S_Fa^GdIeMX?SN>Z8<3BNKA@PE@Q_G3ZL,Y]gc4?b_L=DZ((ALcL(Q
\g;SZ]@:@>VL>e]F1<UK,<#5&e3AJ2cM+A05fAU-9Of=@XN,;cZFV52QOD9:_H;5
DOAX)0#K4\@S3_PTR2W0aVR(R8bGI3YS@YB_e6Z:=J&4/HOUN2Yc9b<f]6]+e8Z]
?#Ge)ObI&9YO/e+\+/(AP7b4:@\8#f0\2KL;KX>Q[HHE\Dg6TI6U0)56+^P[APKU
KUR0LR3T]Y^6V?M2I0@[\+fQa>_KJe@J/YPX+>ZHXgMIcN)7CUfICf/YQfeebSH7
_XRVKN9K5(_C[8b.TF))5AG-3<\MJ5SLdaG>P2LQ:M>&V67J9cT@:4H]].R92c>^
b\1-;87DT&;#]<E[(0[@FS>EEWB9[>;]1U+OXaf8ZfeJ?R/Z/,]LGaa7E.N)QeX:
SKRH/HQ3AGR5HFJUf-U/+8WI0[N=&Fd<>:CaOFd_GBW\Xe0MT,90#]G=cYCJN=&H
\D8]P?T=U=1=(agV+QLWCQ&9/K1A1LVJ1[A?TM(c9,\96II5OM4+5&XNfRdLeV76
AH,X(4b6I>N3N+59f:BHEO,Fg=S8Dg?_\D/Kf/;@=?f=GYH5WU9;&f\ON>^+ZSL9
E?;=M2GB8)U&MZD@DgFD5aF2QdD\WIVQ=04ae/4bB7#O?;KT6dQQ4HJD003aKg54
C=I\:3J5[MQ0U.MV+6MecQZaQa6U\a(EeZ5?+,?][bU-ZN0gcIW&Z@])[4/-[1,S
K_>=Y@FTg1bY:HFINY\M-M\RKZ^cZC2?X8<QU4Oe1XdcD8?6@2+g3V=&E(O&gD[Z
O5D.QJ@RVPJ#;H;aYFNZI+H86:]-d=VCC9f<B>ee[JV4TQ6HdUW5DXad^/1TfN-:
@S8<;Ng,,BC6=38/7Zd.N]/^#Vf:#/Vb9WEb\XQ[MXgWAb^-22RL7L1>;@1X-ga(
3caG9/0OUB_?S7f3;2J:74VG>HF;1a5^V1LVdW@aQV-cdDG7+-d68-D;3V=M4(,7
0_2[I1H]Hce]g5GR+(@gKYG3B>@.=3f.RY>9IBOb,QZ4_=f/+&e9cQCPF[5/aWU?
b0O\^_/?GH>,J[Z91#JFI5KD4cbYJ:79\7FSBV88&1X^<GCP=L3C,DCg:^JWAO@d
91SZ0?NU@(X>?M8V=a-:a(KRGg?-fcW-:,+[V0@20a#^S,.TTc=,R8)5X?^^-;E-
_]+6_:AS7\0a.H?Z4D_I0G^/2O<)/_@IT-AHZJ\3FNR#GA?6(6H+c,ed/dGUZ1&Y
PR&91F8R&Z?67BO<F-.QZ)J2H.V4C=V]G7=P5,1I(3#;/+.;]>>Y2Nb,N(#M[?FZ
O_\LG]&:+XeD)4cF1dZ^DN;N92#H,CgZf]G44UYC9+b8<;N-<TR,A5E\g463;f@[
5QAF?[/\@P<W,B2>R8(9XW53U-WFNFI5]I.F9+;e22\K>AEc2HZbZGW?Y9gH,dVa
.I#bN7]L/:->]T1]POJ#GO]^H.IOc9T/Y;C;M-eUWH8f7g+Ia<QA9[]P/&,2MS#6
ST6(CbAT,/>M7:3e/J8cO\33agUDdMWC^aUfIIOP2_KKVZ_4<2BXf8(U)S/dLJ[4
N76RR)H0?Q5+5b?cE3T>f6Z^1^D_]a?SaZgVc):@WO7)4VE7>P;_J2Q1FTB:@[fZ
SB>YZ+&@JNdG7^JT31gHADCaPA;,6WJR=LXA2SK1;5Y/9_[+9Wf,cP8f+,_>WA:_
N9:OMUG2EB(M4:,FP:9F)ceeE,@I:a0>=UXH08(\96N5>b)d7Z<.W\ZQg0Y]6U9O
>2)BO:0HfJ=eJ:Y+OVGb<3/&WaQ<Z_PFCZ\.GdQ3.YUc9E&UIYHM5X:(>?//?_d3
bQb,@]T3M1YLf>K@e]UO_f_f:V-G-D;1]2KQ;6=SEg)\H&)CRUgR/a/aVA]V^aQ7
eJCVK[cJ<)Pf>>;d-AfY_A[&O/)F?&--FBSU_)^0&-eQ1RFbM0BBJM5)?dUZfQ00
>]97_-<g,Y>7]bV=&d_a7--GVSc.QK79+61BTS?:MPYPb9^W[f8g8g2f^L.OdAGa
IT=OPQUXJbA]MG[WHbYE9d#LSTd1fM]H44WLBFILfR)H5&4d+egFWFG6]J6X8;H^
_]AXZ][&IM(I#TIAg8^[FVefRQfTd@^bQJDTF^c]SIYSFWX4\AbKbU1>L6b;W:?<
#:VCV-fBX\VTf<QV(_49aKdM?9bdWb7:QGgQPg,NFI0:dA=\RLeTYEBR,gOQe=YH
_6QN3PI>-0H(RUBNW=;4gQ^58fE+CNF]&,]\#5,bc9:SQRN58Q-UHV(HUSA,H;=]
Y+(VQ99FF-.3A&baXCB]B6)4\C;?5/I/:N]6_D5O:ARXPT4g4U983D])F[V&:N2;
S+G.F]3IUW)-fCgP<5<_\76O79I\C+]05XEMBRUWbA5S4=,Y+M^J0_=S\6C;_eWE
XCD3;JYTO&BLX:8Ng^I^6::>?(Da6dA4)/gdF-]F2_EYS@F&Pc<c@BCc<XN2<9Yd
2(+C#Qf^4O^G0PPR/()+:NOLMb31[M1A\CU1R>)-cA1<f;O4LPeL+=?>^c7C6a9R
3B-M3b_ZMM-=AEaU/[_47[&M&LMaZffHZ^PaC77b2W,Zg]5NWI5<9UW-7?g1HADB
3@C#7[d)9]]LS0\Q&G&NVRG>9H6:,:aYLS\^)cTBRDd7B=eY]Y;>eQ;-)gAAKcS2
VKW394g)6:]2_B:?7S]X^9E5I;[;\Oa;CRT9(LCXW+3G-6^^_QX^GAM0(F]?&<\I
N:Qg?8.=#egUX81a]:RF=^O9]58#Gda74bJ0\E5SB@:XJ?Y&aC(?12J^2dA7^[<U
AX/GR,Z-=/^YbF\FY[H4aWe[^]XMJc8a>AL@L66/Z=FbK9gO>-g]K5YWJUSBN0Wa
fe>,H(XE@AG<c-eV]A^#YB7L#g)eD0I)0\0#NJ98[K[K@O:K&OLWAU>Qg@RC;4d.
S;<#0IdeZ/VA8OL,2,:=,XZg.eGQO_UK7dD.]>(D_4<U[W668IdXA3&OaMS)QGH@
be@c](NK4JaGZU+7,92-&HC3?)=A]R,(QFaVXCbY#03Ja=1C__U#I#C0Rc/W28K+
;&)E&(E2Z(H0gO)ZC7U_C<K[_]FGb9_P>\D00RHR^C0IB[:f_T15AR>3c^-V5Y)4
(=37Y\IHS>A@3</(KUK?G_1b0_]_;9Z+0]FFC5^@EUI[BP)D/P\&0Y+08T(X==_,
A:ZcJ9^?Hf+V18c\eLOD.OZ;Q1V>GCf=2K.7A/&++8[a_#GBNI1?EDT60<E=Be-[
FCM;YJcBYAR/;M1Q?R.7AR(YZ^<=/M8?//>3C-9g5-0<=5M6a:_<+B8bH)WI>:g&
ZXed.4JW^7W]R7LaWOM^R/)_;-.#(_Bg]Hd\f\I9;T=OT^Y_ZFH=3A8)eAN5MB\?
@S<K&d@0OQJg=+\+D0cSTcMKZ12A,Ob_?@R=gY9@TXCd^f]H/;?@Y9<AJX8-YVGA
0c/B5=E(23JOZXb3Sb4@J+gNVE7B+Z_T(2BR9I4J^-F>R4]bN74f_5P05\EX]b8:
++,.7U_gB&F-QL:1406KYE=4R8?L7HVLd.M2U.IH7=+@)QTHC-&>VY0ZS>f;C@ab
YN]AYQC8-3Hc[Y-C;)<E@<UcBDRO\P-&O#RWCY-cG5?R#dH8eR-HO<QFQDHaIT&I
8^TTCN@#7[Z;([UY?d0ZUa9LES+U?C+Q0-+FC,KXJf-3aYdeCg#f31;\VSBAf?T4
Y+W)=PZ0Md\>I)acf/EA,=95d;4O(9_aPF@9PW)1E0-CX5BAXB=cO\A>B8)17aEQ
HZ?W<6;<LF,79U[EK@S?B)9Q(BcYZ[g15K2MGa#BdOF2]7OeCJ@E]TN6]28-PK^7
Y<[\R+(70=Q#Sf=d:VYcJY@ZR+R2)J4\SBOA7I21\2>aZW#@aJSAF:K:cd_O.CXc
a+_,QgGT?N>g_Y,R^gS0_(F9+H=BHDI&;5QO@=RGJO@V__DX0?Q=WI4D5gLe,XSG
O1<9fZ6\7O_3AV(4GPH+[KEdBWWVa+B>KEN;)>Q<X4<Af-c@],Y8C[E.VbNFdGMO
U]dZ^D_:<dT&2CV:f1(RFcV)?BbZ3WT_U:=.^BK/3H<K+[XL::T)8Y4CY2e15dVS
d@L&fLV@c>&9SV&\@N2&?62+TA-@4ZBY0E(T-^[OXN>b5=B_DfK7CR<Q59@HAfa4
N;<4.DB1ZD<KM]JE)<1>VfS:a_,)D^KBDIE(WQIF>M^R>C\0)J>B5dcff8T0WJad
Mg4@@XI6f?X&XS.>36-^&(0d#(/)GdRLT=F95aY2@[W3;<A?4D[FP27E/S>Qcg6N
E:94DPb\QH<HU4d_d5MFF)54DMAR73eJb8]5YP;:@](#](_C)]:/L59B@+b^)PM=
Kd@<H])T[^?CM;7fTF;\7DWWYfK;\828=:66Q@S?fS>L:;TO1=3^6+++U><RDc&+
8X^<LB9gf-G[W_>3R)+[EXYe#7\eKTA,)7a^.<3(^VX;dZ#F;IVDX]3J#]aV<aNH
LIZ01_EVe;0(&.--Wdb9Vc/#2>G.FgHV1(O[J]AWCM<+Q+6SDXe<S)Z#[a@7KF,X
PBLQ:HJ\8;:YCX=C[@=TG[VY_^[]AJSUb8-Y;+TP+IO9E;TJE]9M5T-A?cg;,gF8
:GPNO/JY.[>.MfD]DUDZ)S1+B3[GD0/&RBRAeAd:VXd8IC0#+K6.>5cE3943&(gV
gLM/IAF)-U4H>UM]\Ce(f@^QJ3P(Y8P7RdL[g^cD;KcMOB\BNX?PWW(RYc0Q:L^:
K/^K7H=6\V\Q(G^8&UN(Y3fMaF[^f6ZWeAa_&W,J=//4R\WC<a7:f0CB2I31)JE5
?Y[Af.10T/G3V;R.O</W#a)4_?TV1[WGF;@DE)af-Z)IU:<VSF_aDe:V-&-#&/BS
<DQS7=HaF2]/CD5_L\5Jg#YEa\+)<c8M;\JDZ?=(5ENNFC_>KeU)H><JW&IgSJ7a
Q5K9(c4e,c5gDR>)^\3O-6L#OLaB.M_FaS<<c;MCcGNE)+B=J-@.F_<2#PJ<SO=?
fC#L=3X#QRJ[EfG7C+WPZCMM-CNH&N&6LK^F[3/5d)WQb\:Bf\\#9CCX^473C/W5
fXOZC2<G^:1\bU.gZOf6L_=?6IIVOGDH\&M]SG5aL5.NGFXB>1[NZ(7N;>:_#eJV
W]H=EI2UfE.BGgGdL_Fc32]NKA[gKDAUe^P.a6ddEV:BeVH68c-_98,1H7bd?4[6
#>1=+Y(AQ+e?9Q9D(#UK)4NbVA_a:<(K[b5AIe=#RCMJ/))8&/+H#ZUJH^PJS;J>
TW?(#d>;V(.,44TM@@HfQ4>BYdLEXbbg\OK@]W.-W/2K?T5Q?^ZY;Z/,)A987TaP
+5#,Z-7)^I#,+$
`endprotected


`endif // GUARD_SVT_DISPATCH_SEQUENCE_SV
