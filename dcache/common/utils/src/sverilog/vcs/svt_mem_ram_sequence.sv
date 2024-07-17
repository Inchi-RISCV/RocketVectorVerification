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

`ifndef GUARD_SVT_MEM_RAM_SEQUENCE_SV
`define GUARD_SVT_MEM_RAM_SEQUENCE_SV

`ifndef SVT_VMM_TECHNOLOGY

typedef class svt_mem_ram_sequence;

// =============================================================================
/**
 * Base class for all SVT mem ram sequences. 
 * It is extended from svt_mem_sequence which is a reactive sequence.
 */
class svt_mem_ram_sequence extends svt_mem_sequence;
  `svt_xvm_object_utils(svt_mem_ram_sequence)
  /** 
   * Parent Sequencer Declaration.
   */
  `svt_xvm_declare_p_sequencer(svt_mem_sequencer)

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  /** CONSTRUCTOR: Create a new SVT sequence object */
  extern function new (string name = "svt_mem_ram_sequence", string suite_spec = "");

  // =============================================================================
  /** body()
   *  Response to request from mem driver by performing read/write to memory core.
   */
  extern virtual task body ();

endclass

//svt_vcs_lic_vip_protect
`protected
5a\OG=Y9#H:e,d]Mc(We;)ZH953>M2]X3P.JLG78OY\M++8fEB(D)(TUfTTC9RU5
XR?AYS6b_VHQLZ^T69aMcX;&]b#T>S64)E<-3H.R/QJRe.;PRG6I3/>2V9MR\2XL
_FT_/O58.)bg(a6:S]Ce2<252EB/Ne>PBX9),51N_GB07cCd4dRU-+_P887[BFFg
3_2YSY\@ZX>,fPc#N/8/afT,,J0\01Za>8BeKd?LF#M1)HMYAUJRFaOC.YU62??^
>We.eGN[Fd\b.;ESc#S_KWaQD(]\5:I59R@WYEagNCc\]=7(C0Y[Z]):PY.4VfH+
O<KM<7Ee;KZ4;(Zgeg?XDRV/EJL0(E_&4\XG3MB+^\9Y&;>^@8UR^<.Z)H/-g/Ng
L7<3.V.FN-fg)8<^MW8HCcZdX>7[G>QPBMLLXLa-Q1U\3+[dSE@Jd:V/=d>\\.(+
+VgYD<28/36cIY4a.,74SdW<P\IL\3)0c^:>^V&&cXC-c<UVTEU:)8R89JY(CeUF
^B4SfMPBQd^<(SMZb9DSI3[-__B/YB3,W[-/42\.DUT)Ta;]e.7U.a<5_J(-V5:K
=@]J#+Ff2K,G-R1NAb>EGF+eA&fTGeV1MXd>[M^&U6P\5^+1XIC\HXeYQBeeM59a
Y^V1GSQG.((Cb=])7_#(2S]D-I3,3dR:M;YMC1LOXQce[-Zc2V6^IEV]4\O1H+>9
cA@=22R>^NGBXKaeV+I9+7d9S,MB:WEW3C1PEY9GD7)Z/J#&8-D><T?LOb=caO=6
>]E?R6>fG4P^8\UVD(9FL9ADDZY,Y[N4R8d8_3T9A+aVSbGO=W26Ba,/1IXUCDW?
X.:J[POHc[[;[b6AU9b0C:f:[\X[?>7Ddb?X)YT@TCc4W=QSf^c]ZW.&@]0HSLY7
)L^I?R/eH#N60[[@\_FDUB9O2F/H6\8-Y1d/?V&N\T.1;N:&6DB\22cW\O[LN6a)
fY883<1+3[X^W-8eKN[Q]0Ba.=8<0,BVC.fTT71V^5K6,I&fUH-65eWN?M@T+f0,
^8N5Y^GNGQg[?aHXM;273SGKSNe94g-]f(B3Pe4\Kg7WR6D.IL8P,(4c4WL(^e6a
@eL4U[([ZQ7fdc>4fX+aPC[P?Pg593QNA.A_Y2D:Q24LR4#+EQ.:&;1D]fab+>R<
a/IL/YGZ\3(?HL=C5Lf#.^19HCFP)@QdgaF2-(8MJ^f=EGM+-bT)D=<+>\WB..[,
VJ<3&f@0M>?:DJ1;=ZUJXXO[^aUMeKF.f[#FUN3-?C&XZfQH[C:-O]UK5LXP/Y;U
.PTA9MF.K7[,Yd,f]IAd-S^7]9MXPQRE0(:-WV+:+??-1#LQTD472UE;,P4E?8a:
H0G#SV<D570H(QIU#V>Yd:/XcY1-@;7.6JNN,e^1\YQcaVVWT]E/60T<SLfJ/Df]
M3\T@QH)])+6dA1O]_<K4\/X5$
`endprotected


`endif // !SVT_VMM_TECHNOLOGY
//    
`endif // GUARD_SVT_MEM_RAM_SEQUENCE_SV
