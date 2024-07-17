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

`ifndef GUARD_SVT_REACTIVE_SEQUENCER_SV
`define GUARD_SVT_REACTIVE_SEQUENCER_SV

/** Determine if set_item_context is implemented in ths version of OVM/UVM */
// // 1.1b
// `define UVM_MAJOR_VERSION_1_1
// `define UVM_FIX_VERSION_1_1_b
// `define UVM_MAJOR_REV_1
// `define UVM_MINOR_REV_1
// `define UVM_FIX_REV_b

/* We are using OVM so we must use the workaround. */
`ifdef SVT_OVM_TECHNOLOGY
 `define USE_SET_ITEM_CONTEXT_WORKAROUND
`endif

/* We are using any version 0 */
`ifdef UVM_MAJOR_REV_0
 `define USE_SET_ITEM_CONTEXT_WORKAROUND
`endif

/* We are using any version 1. */
`ifdef UVM_MAJOR_REV_1
/* version 1.0 */
 `ifdef UVM_MINOR_REV_0
  `define USE_SET_ITEM_CONTEXT_WORKAROUND
/* version 1.1 */
 `elsif UVM_MINOR_REV_1
/* version 1.1, no fix, so it's the very first release */
  `ifndef UVM_FIX_REV
   `define USE_SET_ITEM_CONTEXT_WORKAROUND
  `endif
/* Version 1.1a does not have a specific define called UVM_FIX_REV_a, so there is no way to distinguish it. *
 Therefore we need to just look for the subsequent UVM_FIX_REV_b/c/d/.... */
  `ifndef UVM_FIX_REV_b
   `ifndef UVM_FIX_REV_c
    `ifndef UVM_FIX_REV_d
     `ifndef UVM_FIX_REV_e
      `ifndef UVM_FIX_REV_f
       `define USE_SET_ITEM_CONTEXT_WORKAROUND
      `endif
     `endif
    `endif
   `endif
  `endif
 `endif
`endif


// =============================================================================
/**
 * Base class for all SVT reactive sequencers. Because of the reactive nature of the
 * protocol, the direction of requests (REQ) and responses (RSP) is reversed from the
 * usual sequencer/driver flow.
 */
`ifdef SVT_VMM_TECHNOLOGY
virtual class svt_reactive_sequencer#(type REQ=svt_data,
                                      type RSP=REQ,
                                      type RSLT=RSP) extends svt_xactor;
`else
virtual class svt_reactive_sequencer#(type REQ=`SVT_XVM(sequence_item),
                                      type RSP=REQ,
                                      type RSLT=RSP) extends svt_sequencer#(RSP, RSLT);
`endif
  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Request channel, transporting REQ-type instances. */
  vmm_channel_typed #(REQ) req_chan;
   
  /** Response channel, transporting RSP-type instances. */
  vmm_channel_typed #(RSP) rsp_chan;
`else

  /** Blocking get port, transporting REQ-type instances. It is named with the _export suffix to match the seq_item_export inherited from the base class. */
  `SVT_XVM(blocking_get_port) #(REQ) req_item_export;
   
  /** Analysis port that published RSP instances. */
  svt_debug_opts_analysis_port#(RSP) rsp_ap;
`endif
   
  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
  bit wait_for_req_called = 0;

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new sequencer instance, passing the appropriate argument
   * values to the `SVT_XVM(sequencer) parent class.
   *
   * @param name Class name
   * 
   * @param inst Instance name
   * 
   * @param cfg Configuration descriptor
   * 
   * @param suite_name Identifies the product suite to which the sequencer object belongs.
   */
  extern function new(string name,
                      string inst,
                      svt_configuration cfg,
                      vmm_object parent,
                      string suite_name);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new sequencer instance, passing the appropriate argument
   * values to the `SVT_XVM(sequencer) parent class.
   *
   * @param name Instance name
   * 
   * @param parent Handle to the hierarchical parent
   * 
   * @param suite_name Identifies the product suite to which the sequencer object belongs.
   */
  extern function new(string name, `SVT_XVM(component) parent, string suite_name);
`endif

`ifndef SVT_VMM_TECHNOLOGY

   /** Generate an error if called. */
   extern task execute_item(`SVT_XVM(sequence_item) item);
   
   /** Wait for a request from the reactive driver. Returns a REQ instance. */
   extern task wait_for_req(output REQ req, input `SVT_XVM(sequence_base) seq);
   
   /** Send the response to the driver using a RSP instance. */
   extern task send_rsp(input RSP rsp, input `SVT_XVM(sequence_base) seq);
`else

   /** Wait for a request from the reactive driver. Returns a REQ instance. */
   extern task wait_for_req(output REQ req);

   /** Send the response to the driver using a RSP instance. */
   extern task send_rsp(input RSP rsp);

   /** Continusously wait for requests, calls fulfill_request()
    * then forward the response back to the reactive driver */
   extern virtual task main();

   /** Fulfill a request and returns an appropriate response.
    * This method MUST be implemented in derived classes
    * and must not be called via super.fulfill_request(). */
   extern virtual local task fulfill_request(input REQ req,
                                             output RSP rsp);
   
`endif
   
   
`ifdef USE_SET_ITEM_CONTEXT_WORKAROUND
  extern function void reactive_sequencer_set_item_context(`SVT_XVM(sequence_item) seq,
                                                           `SVT_XVM(sequence_base) parent_seq,
                                                           `SVT_XVM(sequencer_base) sequencer = null);
`endif
   
endclass

// =============================================================================

`protected
6EG_52c6[?11HaO&Q[><c5Sf\abB(]OEB2^Md+1e<[(ZgZ>_&?<>,)32>9eG-L33
3\5eE2c8+FTfFRQH)IOIe];:M90:V,CH4af,;[/\&&>MWB3F];]?5)LCH#<@5dF=
85QEU38@\EcHdWd3e1\1Ob8CR;,[\\-Q+T.Gef:Nb4TFV(G<MR)XEK9Z]QI7R+[>
Q;/ASa:J<XJT.P]J\(?aM[&ERULI,Q>fS)#WC;9.N;d]dRT5+5N7\6<DD\];(2Xc
SY;(V#=O/_^)B)>:;^SLYYG^bDC92OB=O,cZO9,P=VZ\QgTM&e:e/a_UcZXZ:QOJ
a@&C@RVG097U&.O?WFMX>f43DdZO#T9?@H>a0Jd=f8O:SXXX5fR#<,>-d_MO.AU\
HMV5]Wd4WgH-aSVC):8&?K,[@<ReKU.a(2I/e34D.<R&31ISH0)-cWIf)@O,?>2A
,+QNJGg-GVWdKJSN0Z2]:8<JAe7M;W=HMf2bR/c#2SU+5FX>(?H/9Z&bc;(UM#5(
83b7XK)L2]:]V^U2(@NLX<fcN13FO6OF[EbdA17:<CN)CH+aR+I=\JVe-QD==d&R
;OH4]C)Hbe@HOCYG4:7I[F1X@D+aGC:->1L[AV-]&X/J^R/)Je(GI26DEQR,HPSU
CY4bQ,EU0)\,OC1Z?;fTK#a(3AH\OJEY[Le\5RVaE4L,:,.MSK1V.5Oe#5#>;#K+
U,6=-IMSD,M40Ka;4Z\:/7RA5WTP^+_^BVI[UESKR)@ce8P?AOO)6H?M].bC=K#&
Qc]#gPe2&HfK9YJ?B^-HHb4V\:cZ;K7AI-#/X/D,c6F(\-:-Bg)_@GG?L-XU,THd
(FILgRY^PB:66:#=c^7+4GCYF[J6HTDMeEC2L[&D)CJ8AZ(1U3G:\b6OXJJ-8.37
;[&?XRWRC4U-QNXQW519<SQ[fQd0S05K1YKCHEIQN<G?T]A3&3Xa>ZZ;N9aQM;M0
gd&TZY&<H;2[)3W?.PIJ5b?5H6[\eSdR^VWBAdJR\9D^]A,BEDdBc=V#<_NQ.TZ#
_Ebg1.+EDDM&&572YQDXSLMU&fYN21GV]=fLOA--cd^P[GfP2N>)ff1P.X,=_cY.
bcb2=SFQ3[X&VdeOcfIg7.4aa/@_Q@O>(FWdBMLMK]Y9#\B;e]c<G29/ANNO2#5e
>fHY_W0bT\/DFB;SAcP?I^cC.Db?TNI+IAKX/-[]bbJe_W<_E&L^H<IDS2b)B(B7
+AH>]BBSU?/2J3dJc6O:Eb.5:]D1Yf[W+U<@C,6FKUa^]2RHQ_9&1M__?GG8UY3d
E@,;G.DeQ_GJgB:B_#LRFFg)P-fM5G9T3a7c)/)468^LI[+R;(D;580E/)<GdE)8
0\^O,_3EPb0);:HeX#J3_bD.,Y,9OOB++KSI<.9S3:<a55fKH:&>@b2MGQd7:_CX
5cJ?eWO:8[#T--Q=I:W&]=EA;RTB&R8Q;Cc1HcV4/^Z?LU39^SW,0IY73)b8R:E;
bbePTB&c/L9M/07e8,BS>@=(>^B+6WTBUOM]2:>E4EX#R;ZV\aH^?(]4ARe-+I&=
D@@P]Z(5B[]L\^WgNc,GSR#XDS,#H-&&:Ac8-W/JG;6SI>F?Y;N<=CVWZ.\+94P6
B(>Re<I>Re5c5I5U(Q-<H=V9e#:EZ&dH=fT^+J/I#?4&^6BHVP#8\EE3@K,Qd3de
,_\8.,:R-@B>S)06(0I\9SET=(W.3SAT7aZ4^G9FA27O?>E1L[&G@?)2/6D_9_Ye
3_=J:QW-J<M56eV-5E(AEK_>&Y-#c-\NKL>>A+GK-8.LO[E1-^_DAFO(+Ad1Gb@T
+2UT6X[/5b98MfX#BVM+eI_>2$
`endprotected


//svt_vcs_lic_vip_protect
`protected
>:N\?Y3HZQBHad.R7a#egHI0?XPAB:#K@D0IcbTR#-Hg0GOHQ,#75(DYcd=Q?b]2
V/2d&#NW6B##(8Nc+H(KFdKd?7UZeZ7+)-SZ,71/\BUT#&5>LSfI=245.Z0(G>ER
7a)H((#+P^-MDQd-Y7c</Q1d>(\Oc,2V&eA)A+J-dFDa,N9?@CA.\L41Y)fN&^-9
UW)?f3^HfY1A::058gA3?_@D6<P;\;:@H2YC=E+,HHEgJAHFHdeWV#HHFEYV_IB\
agBag8W[^V0aTRK0Mg6TaTPXK+;.Sa-,XU3W<e6]9\4^_AMd,f]8],bSPDfQ#R,5
^\8NCL.>bQS)O<&2D<RgYSe#GcLF;fbeSXV@9P<03RHKRHM;\CdP>O91Me\NgO@2
b(Te8Ud2BIBM-.G,GeR7Y+=HU.:&+Ud@gJXNg6V.#ePA7Ta&Sec<5J7OJc^LN/^I
\Z>>LF=?WON/90O&Y(T.VXI-1?2Y90X//Bbd\J<9;.?TK8\==e&GUbN;^PU(#>::
QaP.)W<0\S,FN3K0eP=Y.)7&KOB?=UR_)bQJ+CA3_(Z3=.b>V2B807a1H3P?^RF,
VP@@1:(c1HS/M(1(/_fHM(SSHdeP/;A?>aFV)Sg<ZcTGe.6Je-J8FBI+C1[YQZ#g
41fPRC<7<O\a]7VIB0(dB.19>T6UL+aeG.:\3I1>.aGMe6#PQ3A]A4,7_/WBK):R
+U#^3Y4UG@JA7YL5,EJ>,>PdFa=8NNZ1g?6F1K9c[/X3G5#IBD:Kf>QAdG;8d4M_
WW&Jb3J,3H9_K:<]BFJb-5<-+:97V9YeJ;61L(QFdKOegYcc3X]86Z@@3^S#UffL
eM(>T=g7NN@LDLOf1F0@[eY+Mf<4Fb&1Ifa/P:XP:A^d/LWT[A0XVPZL6a/+\E<Q
Z]gYR]:,LF2af2[CXEHN,BOUS(9G>)aO&O:I&E:[5DGX#K;ZC-c?2.c[SMIS#ULI
2#CEGM-Pa8gEbfS)51=#6SESd1&-=@<bKE14)fC3ZE5:DS9W4[B8Tc1@8;B_5H@C
N=ES[_7]e]HdJ6e#adHcNBIH@_dWV951e-?-a\\J[UEa<bfJb1M=4[dNGV_7Qfc_
A7UDG[g=?]T2)cSMC4+F:eU>f<Ib(UNcD_9@/2<GX8)e[AcW8D,b7Nc7I&b(IERb
=\0[;8XXc[(TQZ[fWB49eTZ2Z@J,EV6e)]ML.YJ<BM<_0.aa/I1U+M2(0VLLbIVX
;Oc)JK[\(?N(M&+[S+d?DV2?aZ1.[fdN96,>I/_B1?2L^U?ag1A:c&;&S/EY8G>L
,S7^URW5.#()3Ra-?f,[X[Y8WRf]3,6_<^(L.TPbIW[>c0QX4[5<2g8C47+K6f(U
\?<&6X(O=U+=]-F]EL1S\eQ=9V_\Fd\>4V>5ZHcM?8dGQJ&]XI)&Z8ADKS:&F4Id
cX+Hc]A(=+@\&YDSaZ;(fPAR5>&31DJAdD22L9[V-M.]B3P&O)]UB2#EMe;K#U_Y
NYCT>FM&?/TS94aY760^H6/1b>QAUF]J[>C;<.25aB^HIG,-N)U5R--3PJSR1Gc#
DMeU,02<Hf^b7YW5b?&WeC50VS-P1RP:,-5eD[MT79C\U8>0N80WRdV#+XZR>=M:
@^B+)I-VYBd(E\2;]TS+[#GbX8OHcOH:WG:T(TPY0CKW#ZU:&CI/=K-SB\DL&X4>
#9@DWQD<B,2DZ;b:77<WPK_0K?:/a6N8/1/AJ-42dNDa4(R38K>9]&N>F[/ae>SE
&OXHQJKDYTS6]:3?Ac(;=;W?3Z5=5KZ:MA48Z;[,RT?Od.CZREe(I@SZS_P@>6C,
2FOO,b>C9Sf/A06.TNE_CPZ#H;HeB7SLQ).P4&8b+T,@;e45L92(@#G6e]4P#E^C
5D:WRWEdSC??ZQfDQ8@]g,-3NKd)S,J/_Q)RW+QVM::49aS?/?)[993bI.@=CT=K
P+d;?<CZgKT:X[Vf#&/6+6[(..(g/FDc\(OFR]eEAW73>e,73)8O.,&faQT^.Mf(
;K1GRFS#H0,[H-QGQQD77VBXDM2[HURC_=a/FWRd2J(?<g6,RbNJ<[)AAK:bg>B\
^Z[fd=aSLKV:0.c?>IB6VG[gW5NUg:bRcMJA)VDHLCc^Ud5@<+7cG[PK_^HJOFIa
b))6=EP(:BSPI;CcNHH9GgWPM^TIFQF_S\c\MG2E98d;DV<_)6VH>97c7cVYMa2?
YVVYd_6AD)Z-/0\GG5cFD#)4YTKN&&.HU@?9g)V^P3aeF[L>Z#Y<<c];-+]0&V[]
g[8J/PYTB>0@W<3\F;22NO8T-JKg=<R#K8569fP_A)+0&/CW6K\>Ig[#O_ES<&@1
2#>K<eR9YF:Q+8#-e_7a=</@+=cafV2LZbA:6K\5dNYWNAMf&K00YLKf78c&K^C9
fU#cWL.VQJ--HWZ^T06G^(J-<J\-G@+6cEL9&M-9Bd6<OD7#9SG&L?+7B94@I-_J
a8#b4V?[@>G#<Wc?+Ba-3<MCRPJX,K41I6?@0/9,P>HEA92+ACS+FVb;&\)LEeL7
(I7e?IcP3(K3Rdd)8806;^W7Kga;5ga[74D&NU[)ZK..\aKGN7;eg.S;\bBU7T&O
3QOV0;KX4D[QffT>d<FP8;)_59;LO++Ic4-E_N?#&e,[_U^g3^;XCFPU9fC,?6fL
^B,<98/KJF&c)(:bI<C==4XOF6UEFV-^:TF^M@\[DH5&D[W@d5=CUAW;3YLLN^:\
P,<,9[a9-g7f>USQ47C:T9N&e^EE9^>5UbYNNU;FINI:RN#.-?6BCY6I<gMZ=&<D
3b(b?NRN>HT1B<-):(f15P4PNN&e&O.2N(P@TI]Q_H;:W.PY93#KV>4QbBJgM\3Y
Y\NP]6b^\Y@/c46aRYZVZVce1d]fDb5<F_OKb@LBXM(ACUMW/S>5I@MAdZBVR)d/
\=fZKa)-4Gge=H\8=b5T2T]?:7H?gPbB?/7B3\AA9(@TNf;&V3;;N>C^bN4IO2SJ
eAgTfBI3?0F4Na<b4#(JQHc4C\9^6H;3&N_<+9+&,;/6JRA-RXC7@_4]XS97\#H_
7AQ4S=HeB4D\Nd3LT]_S8\LA85aP<:?^]fY98W#Z^6DXS4#.B-:PIQ\9#DU3Q^^M
U;;O).VJMb358Fc&?XGS,Z6ZcS.S7)J+&b/d0=Ba5g\>[b@5P245EP)DFd0R16T/
M5>5D0U([ZaCEUS,1#QX4X2cdX,^.8^bHVBVK6Xc[bXZ84e?44KYeC5b+LODc&eY
0dNgSbYcG?X8RBB@SEKQ]\DaWc8(de(7WXP-8-Xaf\^T2)>RS+BfcS;5V=KSNH2&
<<-WCf0DPL7@]0J/R?PZ]IMNAaeY7\8-CI=AJDK\61EAfX@I^GKFPfPO@g;K)K\[
Bd1KGLE,G?61Z\2>E4LJ#.f\;S2#.9Da-(#[_=F(BB&Ib.SR9/#7X9DNP.eSZOG&
T&e&.X0H1--eQ7J^GFLJHEe1(]fQY=\P>+82cdOBBbX@WMN4cJ41VN^IJ4TWWJUN
PBA.X-^WX#0]FN\d]16\8O2Z?a(UfZ_8PQG9;g9;cXA/1R@-a^0\PITKJ3KgeP<\
:Q#HF65F:\0&_;DANE(HM+8DJN6(fL8J]RTDN-VB?&:RccAOOA>-6<5dZY.MG#N;
bEe:U#O]8Y:OO@E<3gAH6+UYE4TN2A1cUJ)R#8;&VZ<P#.IHKO=,Z?Dg]:NL6_8_
<B<0S#);HB,2OF-bd&7\b\b&GZ]If\=),O:eJT^POXBTSWad6,T/AgX)-S07(M/?
[;9LK?96Lb_C)U8;g5Ge\e<EHK@/>]V:85IPEAL[T_fR37W7CQEfFLPV[LWF^I<1
IP>0<KW5fdFY=<>L3LR8(YK;KH1:+8\2)VGWIeAa9eVR8Q^I@^G]Z\2.:Q@f^2ca
/)3R.H3BR++#dJe88\?:3,#G]gK21-V,(Ua7E2gD5f<&E<LY3&QEOWW+>I,c.d[U
8PZWQ(gXN4X(e2/S>?E@S.OD@I&)=L7-E#5LS+I<c1adGK=)>L8bW3/bda2faSN:
0.-.8_]U?_JfG=X[_?A=VgJ3<H[Z4,INUP?:U]E).HO:R);:RGM6NO7Yd@c22_9^
W8+E3UD=U/83>DNg7&,XD7>X2aR_f_/f#@V(,;F]@>@cVSce#_0>6PFE@bY1gdE<
=]0O(BL9?[:&D,,YSOaa\g\<]_FN;_[eO#+b6>FQ#]GYMaU05e>df:FEJ$
`endprotected


`endif // GUARD_SVT_REACTIVE_SEQUENCER_SV
