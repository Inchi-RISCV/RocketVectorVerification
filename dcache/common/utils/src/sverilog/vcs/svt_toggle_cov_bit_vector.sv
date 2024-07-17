//=======================================================================
// COPYRIGHT (C) 2015-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_TOGGLE_COV_BIT_VECTOR_SV
`define GUARD_SVT_TOGGLE_COV_BIT_VECTOR_SV

/** @cond SV_ONLY */
// =============================================================================
/**
 * Class used to support toggle coverage for multi-bit buses. Provides this
 * support by bundling together multiple individual svt_toggle_cov_bit instances.
 */
class svt_toggle_cov_bit_vector#(int SIZE = 64);

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /** Coverage instances for the individual bits. */
  svt_toggle_cov_bit cov_bit[SIZE]; 

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
/** @cond SV_ONLY */
  /** Built-in shared log instance that will be used to report issues. */
  static vmm_log log = new("svt_toggle_cov_bit_vector", "Common log for svt_toggle_cov_bit_vector");
/** @endcond */
`else
  /** Route all messages originating from toggle cov objects through `SVT_XVM(top). */
  static `SVT_XVM(report_object) reporter = `SVT_XVM(root)::get();
`endif

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_toggle_cov_bit_vector class.
   *
   * @param name The name for the cover bit vector, used as the prefix for the cov_bit covergroups.
   * @param actual_size The actual number of bits that are to be covered.
   */
  extern function new(string name, int unsigned actual_size = SIZE);

  //----------------------------------------------------------------------------
  /**
   * Provide a new bit_val to be recognized and sampled.
   *
   * @param bit_val The new value associated with the bit.
   * @param ix The index of the bit to be covered.
   */
  extern function void bit_cov(bit bit_val, int ix = 0);

  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
VSRMVFW_)A#,TMB[1K2Gb1<NF4:0]@G0e(5c2=Y:U5cY/gN&KB?@,(c70<E@>[OS
D[M98DAdcBc1VX;7U3a79))V7e6]1YCAa[TY7.aXg[e]D/Y(?LB=f<8:HVNJK-,Z
#&]EHgWD2ZR\.c&O-fK1CNG^O\_V(-<4X,QWA.Y6ZXA0M,Q>8(,8\d2TVK)G4/SL
fcR27<R4CGV3>QGRZZ&@ba\BN_fJ;7d?^1\f75<fKUZa_+4D#a;&J(MO(@D4f;2&
UQ]WL@SL;:cLO;JcK]\KI&W)8#R<#C0R8f;[;=,_SMJ2X6(A>M+HZegd+#@dWRPR
VMARZORVaf#.U1C2b7b,,ZdBP&BIAdfE,EHeJQ\:8a+7V<BM1e\TbNGZ7YRD?6Ug
L^bHg14==8He0-b/H]-2(ZOZ[-cgRD[MQdF1R.^]0<F1^2&X0:J_/JHPfWJdK#;\
1g)]TK7A?KU:X4B:1V-/]0+_+-C:@M,+B;/),O&caWD#7.&cF+TD#+];G<)c=4Y.
P@N6^3RGR7cVHVC-C5Rf7\WfJ:2MeG.7UI#\bO9B,=D27UgA584:]d=?DYF?<NM6
X</@C@7,S@:9N2(GT-9=DKY\32ZdX^Dd5dG24PNMWSMF^C\M=eCAL3b#c#fYLXTS
J>cb<-bQ?3A,_SP^=33+eL.D/<HL@XSe0IEOfZGa9f,_+84Lg^=N/V2#V2:+=<3+
BNg#5^M9X()@fQ9<a=?1T7ZgALdc4MX5#(9A6-_0YCX:R(WS,^+.)bg45AJFT;Y3
gVG1]6<M;ELIPKRW-O?@Wa6Y-a=Ubdd@3=0\SRSaCEc<]BfTggWE-c7<VEQG-0R]
BN0WMLVeYX\d@d4CJ\88KSE[))8f-IQa9YB71)X]C&I:)KRO67.WJ&2g3-S98N.N
6-T5b5FBPDgP1/3Z6;cJ]U;4I9.Kd2cdY+C6A+1@d3>;e[3>Icc6;;HTI?>ADGFQ
],V;@Q:@5P>c2D=g>=Y:F^De/SXA:>90E_BY9Q?0]dFC9Z[TPdR[ISOU-7-Ee2:&
g0:38:,5_;9KPYGHC.0/B1B62e,A0J8Ab)[QA^CTG))[a4D>JK?>_,LYCfbCbDZT
4]4S#\9Bc^#Q,b#cEb_RVT\.d4JDD+A1F,/P2X>J#?W5e3PG0?Rdc90/@4T/PKXO
6+#g?UI5]ZFHSV]^R:d&K0M8PL#^]B-7Y?16bAK?ZG+Z/D&7Ge8(,eMcZ3<?52A<
C9OgBCU6b],#):0b01?(-6(V&JTJG8L>.E9LTL(CW1Q6UODFOT6#d1=STE1K#<L8
&8B?01TUdZI/2;OULFAH#/O3Z@BDRKfdA?&YR=g6+&MG9Hg-(;1K.ASGJ/(:^1)c
>JJ>Q]d6A][GPYd+,@\N[3B[[c8V.D8)H>P0?R2D^OISD/;HFX?/b#FKZY5&EdZ2
@@FQd,9A;Y578-<bd9T.RIa]()D+VHU05&+6g0\Q+e5CLU?->0gR;g\THBP#G):G
cDWF8?\A/MQA@(;_4J(^SQB)5RM&O?4@/06I/,S\=g_M<QF@0RYIfI](#<N<.+VZ
Qd+O-AGEa@TOUZ17e&OA\c9#=ETOCUBH5BYB6UfJ0U<4dfHW&Q?9^D,#O-JFD3PU
\V;aWI@9bH\5E3JDBEN)40C>T/4V\P6B0]FPR8Y.5<4;8=X,]HVNG<Y1N?IY>;6?
aH(VSC:H0?a3EfUb+=_IdH(Q^1WUI/78>4FeG&A&@eRH(2R;D^I+\HF4EI6T/Efb
I>N@Z=&60feM385EDe92f,&,?MYd/53VI3OM2/N&MJB?.M&FVF:b0a8V@IGYaYc_
.Fe-4L/KM</V7]BL7cK_3K/DQ&L/Q,>g[09?UDORUTDO>9P/Na.aN/5,I-6[)(\^
3T6_US]_Pdc;G)^^dFd9^))AK(=\6CLb)]<3P]&FUK3V7NI(XX6<<>HHe=Y-_YK#
ccd,WBHg?gGS7W8UX.S:C/H>\#.]I?DfU>CPIO_?F+&[<3YC8^88P.FACSO)U1?9
Oc5VJQR(I5RJ2:S(3R/]dC=(&_=bYES.G/#bSM4SS-&+5H3-U#G3FTG>Q3/1]VO#
NW0+XJHRM;83Ib/8e-c.SJ:]_,dO5/d@#2b7,FdT&?f]ZC#-HLYL)\b/Z(,KAg2E
@O)4(S#gbe3V>Oe-?X9,eb</E1Bgd=#;bDDMCC_OJ+:#?^HHD<R.bQ-8:&TSY3aQ
d&PY@]YPUT?c;a_Q/DLaafB6YHd+N.72[V#;;bZ6<FP6gc^)G&#]d/:eIMVR>SeX
acP?2a+D46#_A&#,AY=4Q0N@d@Q4VC9cBFe\dbLA[PfcEg4J:QF>R34ZDRT>e:L+
8;]MBZ,]U<aDAR@:W7>_YI@TfT^U88a@dHQ1L&Re0N^:W?ff+9GXg=]Z[M<_bb.J
N]YQJ9>fJZ\D:B/+;LQf,V5bg[[[.dg73OO3@P]]4CH2\/9K((H3IbfeI5NdV5X0
C#YCd0GWF93Za.(VF,#V7\9fT;ZGK-@F:=D1NAF?c0W6gMZ,H&/+]d5CUDNCWFfa
;CJBIf8]<+RaR9=NVIc@#d&6E6P:Gb_>f(O;CHJAcd.>@c@dY3ZJ^WY;2A1V-dGB
;_1Z/SOHDgQ8(:.8IURc,c8PE<.:Q)cTe(caOEU>Ae#;\>0cE?c@=6IX1d;3)D-/
QFd+;F8b7Sgc9P+VLcS8=&ceTZ(YN,d#CX[]CCQX\5>cL17eFGGFV:YADP>#KTFP
,,(_;?b=42bE@R2HYI12:WDZ94VBJ8G)Y);C)Ed=JS,J/3RCe^Q+00bcSCcV1Fc4
<]VJbJbFPVM8/P4GBXJ?XZ7TP/bD-&O]44V3^0dQ5.GVY:PMZ.KeM5_3&g(CRe(]
(7J-);VJ0cG8.$
`endprotected


`endif // GUARD_SVT_TOGGLE_COV_BIT_VECTOR_SV
