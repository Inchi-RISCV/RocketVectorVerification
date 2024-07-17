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

`ifndef GUARD_SVT_GPIO_SEQUENCER_SV
`define GUARD_SVT_GPIO_SEQUENCER_SV

// =============================================================================
class svt_gpio_sequencer extends svt_sequencer#(svt_gpio_transaction);

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

/** @cond PRIVATE */

  // ****************************************************************************
  // Local Data Properties
  // ****************************************************************************

/** @endcond */

  // ****************************************************************************
  // Field Macros
  // ****************************************************************************
  `svt_xvm_component_utils(svt_gpio_sequencer)

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

//svt_vcs_lic_vip_protect
`protected
I0)P=Fb)M:6B9g?b@HECe5@9ZB/Ha9NTQ=&[f,R>I^_\6N[V@b-Z((^>HD=[.^J3
<.&.?^_4GR\TN,.Y)f=COX&WBXeEPBX[6T70<HS?L0UUJH-)L7;,3dgCW_SX+1#S
c3)BEbe_UU:GbI?FQ@^]=cLdaRNa+D<PZf:eS>Y:V8N^P6)Xcg#9^;:O,:?[4J#Y
V.J9,P6+KbKW<1?TfZ@f/;XZT6d0O+&Dg(4V[LU^K32,&(=S0/UYU-Z(0^8&V\36
K[:[I4+M;;D9[N/eEP&>\IA5:&FeA;_W:A>Q/37-c@#+0&4T:F=I&@O:JEARFJGN
g@.9b:^M)fXCI]Ee23[Le]geW?\A0<0UQe32./L5_J7^N0LcH.:/6J,4Q((7C0C[
B0[]5Q3I7HM\>#?GYE+7Na-KK7fD)1&ga8R6:=CS)P@_)TC7(F3:KK0dRDVE3X(L
A;f)5BDRPcb9;^7R)]0M#YZcEJ<N;+dSQI[FX1,VV4YaT7-(Y0bA@</c/M]BGHVa
\<A7U@fdBOa3Y(Y?U&L?>RQ(WG8-@WYM2\A=&A8[0,VKN>Q[X8<XB(,(.\50_R\b
KZ<J(SNJRe6F^.?]T1:)OF2e:4??@?gQ(PEYWQ;_ARAJWCC\fg4/_&L/),;M@)c>
@_B<39J2a?bZ]CXD=2(?K?A7/E4-ME57gQX,F#dE43XgL-N>VLQ)7Q??FBbHQU89
=Y?)LI(g]3:S2>+VU:c.(/;#dU:69=>_I[G)>^=SYO[\?[YFSX<Xgc??N$
`endprotected


  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new sequencer instance
   * 
   * @param name The name of this instance.  Used to construct the hierarchy.
   * 
   * @param parent The component that contains this instance.  Used to construct
   * the hierarchy.
   */
  extern function new(string name = "svt_gpio_sequencer", `SVT_XVM(component) parent = null);

endclass

//svt_vcs_lic_vip_protect
`protected
WPO3<CE?PN=aV-MK(DCA(.Y2^fagaeC]P;^1e-TSC8:6\IJ)0[aI((Z#gZ4:64:&
PX>b)aUK^M87c+M_JN<4,<S#C>@V<2aJP/F/F1fP,8]PNV<,XIA#XH9aT]Zaef>)
)8WPb[e<,9b>GPER&A83V.:.8e)1[CPO<0DA^@S@:KROD\6@DW(?)RT2aI/T9YJQ
S2_8[-DI)0S#0?L8cTKB.M/6/W\ENFR=I1,(456T@/HYZ:IQ6RW0P]f/@7LWU85a
94O7fcI8M9,cI1X0OPf;MD:L()3+C9\5941DZPg>&_@8PY[[[L<g/b2F^U)8#+(.
7U_:bM4\K,\eG(_#W9U4-=17gH>_=#,<>gbM?PAX/>2c[Q6(RT7R25b([TY^BM4T
YG^QKIM&[7f+aaF;=X)R2F@1)N+c#06^R0bJ\NKf_[WABP:Y/EdY?JGGV;A_Ff)^
:[0@,O]FgR#BV@6=GZ/L4?NDC:/6C1BZW14-2UaJL4HJ2c?WGO(+6G(R\M>B31e]
Q4W=:LRY:1-PS3-ZX(.b39HRb@(_eV?PS^3WB\;V4XIRe3TbXIG_I,L7R4>9gB/^
5Z6]?;&WV;HF.)6B?Mc5J(E7H5-cF1E:7EQa>Q:Ag=&g..M\W9(@B7[/7[B;JfZJ
B>Y>O9C/L]_IZTN0a6;=FYNcST0&_5dXReE]V3N_J?WEM\988(A><LLPQZ)Y>;6d
AQ5BF4AO]b=#@SV<DX\1bA08Uf,=^-UC.K;V):P4,(\B29^DYNfH9]U+<aSY\3.(
90O5U;?aaTW)YU\=a0-H4Ad^]TVf@6C6NJF9-)I)1<c,)0^MIRXGQ;V+#L3\+4O=
-HgE#(WXS\MU0YCSB04<3O2f>FW9[7.H_LT[aUeNHcM?+->/?RERR.^_>\VG0(Xc
VN9V#C]4SdLMgQ,I0/54M0c6;:6;_3\Z^Sc[Z1c3+J1CBE9VSbLM:5LgR2Bf6B,Y
YV1+.TS6;f6M0$
`endprotected


`endif // GUARD_SVT_GPIO_SEQUENCER_SV

