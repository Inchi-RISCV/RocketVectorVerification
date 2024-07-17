//--------------------------------------------------------------------------
// COPYRIGHT (C) 2013 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//--------------------------------------------------------------------------

`ifndef GUARD_SVT_DISPATCH_SV
`define GUARD_SVT_DISPATCH_SV 

// =============================================================================
/**
 * This class defines a methodology independent dispatch technology for sending
 * transactions to downstream components.
 */
class svt_dispatch#(type T=`SVT_TRANSACTION_TYPE);

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  /**
   * Shared vmm_log used for internal messaging.
   */
  vmm_log log;

  /** Channel used to dispatch the transaction to the downstream component. */ 
  vmm_channel chan;
`else
  /**
   * Shared `SVT_XVM(report_object) used for internal messaging.
   */
  `SVT_XVM(report_object) reporter;

  /** (Optional) Sequencer used to dispatch the transaction to the downstream component. */ 
  svt_sequencer#(T) seqr;

  /** (Optional) Analysis Port used to dispatch the transaction to the downstream component. */ 
  `SVT_XVM(analysis_port)#(T) analysis_port;

`endif

  //----------------------------------------------------------------------------
  // Protected Data Properties
  //----------------------------------------------------------------------------

`ifndef SVT_VMM_TECHNOLOGY
  /** Sequence used to dispatch the transaction to the downstream component via a downstream sequencer. */ 
  protected svt_dispatch_sequence#(T) dispatch_seq;
`endif

  /** Semaphore to make sure only one transaction displatch occurs at a time */
  protected semaphore dispatch_semaphore = new(1);

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  /**
   * CONSTRUCTOR: Create a new svt_dispatch instance.
   * 
   * @param log vmm_log instance used for messaging.
   */
  extern function new(vmm_log log);
`else
  /**
   * CONSTRUCTOR: Create a new svt_dispatch instance.
   * 
   * @param reporter `SVT_XVM(report_object) instance used for messaging.
   */
  extern function new(`SVT_XVM(report_object) reporter);
`endif

  //----------------------------------------------------------------------------
  /**
   * Dispatch the transaction downstream.
   *
   * @param xact Transaction to be sent.
   */
  extern virtual task send_xact(T xact);

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//vcs_vip_protect
`protected
6f]=gZ:<CV-=H?dPBP)ACHVCXD)1EL>6g8\abR6RNNDgL>1OdKg#4(_/\OH/&)g]
E1Zg3XKO-g7V1?(a:^B@0V]P8>IL\fFT45L/V#VI:6deM(:WU2RJe7.[A2N3[Ce.
H@/3\da^f=2[^RP1F?,:/P#&?eCa^71GZ8cWcF/0]QCgU?Q8K,e[5Ia?e/)F^D(e
DOQ(f@;O9W]7@-/2aI?&7;/ag24e&LdZQB^L/^e6(;3A.#-QUYP4ZA/W[g6:,+2)
@J<LI<(JJdSIdUAO>1?E.5?gR=3D551&(#[S2K8MRaSO5459f2)4+#L5N?VW_JAI
f1V,B]9@:TaS-]7VV<KT)B6K:B^MSaS_A3@7CF2W,+MUS(0F()=_QVM:1d6FbfU&
.d44SL(RPd?-f12a1HE0DPQY,R/@,3_WXe,=G7;OZB01,^=Y=)<G^QPf8M/F2HBX
PA/-E43#\gBEPb#^-MadT\Z.9?d>0d[c,K7?_Y[CUZ=CM.LE926K9:T<4,_Je2RG
^2(Pe:8K;A32^FUPUBD-&D8@a.WW3=fLg)RO=I3F9@3d1H0?REK<R^K2c4.)C1_K
XESV_QV,2U)99aF_[RLg,C,?Ma6OTX[C)8DG5]f8@Se]HQffA^=^00#gB(H69TTJ
,NP/=TV0)I_^7+C^H)H;,f8#O\L5AVON^ORF3E;3PLc1A@>/bJ<CV+;>]I.-0&I^
]-dR8ZcC(TN@__b>\H>@>UBH(\[.C4d5PJD/XRV6?WP5=P-T1cS71Va)KAQ2/8TO
\eMN(E78U:I.GB[Wc@GT-&T0L=<@X#;.0;BOTa_+02(FC0R.AGR[fDc07?^;E#)2
KVZb60?UY8D,CJ<Z-E.B<)S^3gAGX1I]/(P=UWD7HBS1[UIG.e3:X?NM^P52VIVb
]IFANR-]M:,g;30f)OM2JX.?R^R6B__>&c>WRLZ-3.<+:7@>(129F5[4C:C3Ne]L
0KeBPBK.P5GVY(g\GZ25bRFBOe]K2&V>R3g3Y,aMTZGHM#ZJ1(2[/)9;,QM+-aKB
>T,N^bg>_f97-_V@7<&AE5-a>Bg/[TAA88RN<?8]Z4+O)1[1.4AKW17N-G5a;&1X
6DF8NA[/8V_=X&9COCbg=^R,[A#.eE]bHO9;N9,aRMAWK3G\JYLg=]TMLPc?4\=>
K9-(e>UJB-6eZ&@/+OG7.5G(SKN0#-#d4ORSb?O7a7CeROARP6Eg2]TbN1R?<_4\
3=,+0OLcK1/>64RXOS<.+]eASDIVXfa@&PB1;8cSZd0,e1I9])+GY04(51]_&\ZK
026b<)5RQ0bOYH@&&W;Y)E,AIH:NO<g_<1D)B)@b6e0)X1159Z<58W9YON+;QXB:
_2,g3(V^+ZaV,,Cf=_>@@8E;&29>V,<K\H]fWL3_^6Q7WLf+g,[_c/+RQH04R-)I
J+?d+=/b/G3f;,HgMEO#C19:+;?A2190NJR0+FJ0=Y===4VOeAa1@#9S?;F^a:]=
/AEVc]&cV#.8c1]f,1dbNRD^G;2P(<<RX&Y6T-X8J^GP7/,W._>(&Q2AN+D=aC_S
#Z;QR5OU,L27Y\-JT@4LE+g6?JPA_FD37fHW5OIR/(eVNA?/deXgJ@])(;:GSAPR
?.:>Ia?J6gQgT81P>0fbD<:KKWM=C4M8-RGT493VcPX^0Y<S2VGJ/OZZJ.K=^b&K
dU&.DVRX]B7CF-,HR57P[0(f+]d&GO;eD_R)#]H[&E=B[1bN^A+CNC#;f:b^[7c<
9J8f<IO0R\03Ff&g_5\/DP/9SbI01A5e0FZSf_@9W?P8?HJ+)E-@FQC;H+833)7Z
]TZ4HJF=LKEPfb)UZ+FX#M[[D6G&)5A/OV6B6#_\0RRVd^#>7>OKBDeS,&+;B]0+
U2^4@LC3cEP:,<=E)8Tcd^VbgB@XATQISgQ3e3,:DdS8d:N&<E)a0KdZG#,)(=OH
0+HV^U4L8EF)YQJfKKWLPM;3&ZaQ;,&G=J0,+V8OC):c#W&6FS1FP\6_?Pg1O7?C
6C0<\MLH<=4DH=+d#.KC+7D,Cg@TN:A<7Nce>2NOQc59cFW7]f6a)Oa8W>@Q?)8X
>.Ka1#IUbDLX2cS/cA;;]2@9ZbDGY0^(e5DRJT)d>[9O3RcLMc;IWd<TKI[?X]PL
YZIM[TX7--I/F^A;;;,<ZEObfS1HF?,0=/YY>L;9OdHB^>IUFQUFA1^];GMQW+,&
@KJBPfd>HSKWWC8WEN=QQb+K_S(a^c&Z=B<PH[S=BT/?aXcG>&BG\?DLT)gR3P-E
8;^1P_X:a07\VI7=S0U(8>Kf15KQQ:ZZI/+)I>L0+)157A#fRe3/_?:d&NQfVA>L
^f7B86ZL3G+F@7FfHK<+>75dWZ;U#36<30CJANg?-6K69WC<[gYX)b4.P.NdM;[R
3-=(+T?(F()=PRD>6&6LJ:>8J2X;WB+X9$
`endprotected


`endif // GUARD_SVT_DISPATCH_SV
