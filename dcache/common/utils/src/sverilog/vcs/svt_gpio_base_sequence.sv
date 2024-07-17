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

`ifndef GUARD_SVT_GPIO_BASE_SEQUENCE_SV
`define GUARD_SVT_GPIO_BASE_SEQUENCE_SV

typedef class svt_gpio_sequencer;

// =============================================================================
class svt_gpio_base_sequence extends svt_sequence#(svt_gpio_transaction);

  `svt_xvm_declare_p_sequencer(svt_gpio_sequencer)

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
  `svt_xvm_object_utils(svt_gpio_base_sequence)

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  /**
   * Called if the sequence is executing when an INTERRUPT is received
   * on the sequencer's analysis port
   */
  virtual function void write(svt_gpio_transaction interrupts);
  endfunction

  /** Register this sequencer as running so it can get notified of interrupts */
  extern task pre_start();
  extern task post_start();

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new sequence instance
   * 
   * @param name The name of this instance.
   */
  extern function new(string name = "svt_gpio_base_sequence");

endclass

//svt_vcs_lic_vip_protect
`protected
fX9>=,9\2)8]LY]WBS-;@(eE:C>@V^I[A<M5fL;)MC8bK@2UbTUJ.(GZLN1#Q#1\
-)YGNLN+3?#8[G,&1>\fCgG_b(dXA/M)^Yb]a;E]C--TP#&KgNC\/0.C:0:aaU5c
B@edaD(F8g<?R(QMbL#fGSf+^AQ2RIX8@Z?a+N1aP]9PYgI9@8LGN_7#8T-\J?XN
8;X?CMEgEefXCcg^P6CbDb(=_37MDD\eCQPMEGB4ZW2=4OG?WQ=Y6();A(+\aX1R
8XI+#482[F0S1V7:H__<\Zc[ZeU&\A6LLb-ZEI?RY:@>YPO2Q&K=IR4BU]#NgJMB
U+eX/>a\=dHKYMSS#I+EJ3ETN:<W(7dH,1VT<P-S=U9bcT1J855?B:HBaXeI((=T
[VTA/_)GCO@edO1J[g3fgg^:#70K;7BIT(Pd^I^56>Dd&YPa:/5K(A=(B2E=W9J6
2=LI#3E203e#.d/PEATE77W-MNbR[e]bF0@(bcZS>LIEMBJDU#EPJ6H8TcLY_RHS
Xb<[OD6=dQ_4BOJ/J@ECSaGDI0eIT0>@aF.?POV1_aJOK(:b1c,SZ[.GSd-#B(W-
8Q;9[7KU[WeR+3-g:>g<6BDOZ2?OU-a2=RPN;HH<WKXH:gT.VBa6cQQ9WeS6>@Sf
F\179cCUD4-ET&JKN<Q>)+2PZ@TNdQaQQB,14@;1Ie&Lb?7a8D4LN[eNcEL8XW:Y
@G4fI_D,9?/(+JXa.P2^3&2;><XW#0LEOX.OCSBHeKAHH,=S+\>)c5:-\_H[f.#:
FL&Ob)_I.:WSUY:@#b/R@#U.D<-SXB@UVbQT7fF/J/6@f(CXL:)#9.Dd0#f41/Wc
DJa?3g6E0ARLY-R^<]7G3;@/7dD(6MBW<;YN&d&KI4PZ/P9D_@TU-EaD&IG4f#S=
,<MZRLY\:CW+TA[fI@6P/cYP/[I-4+B7g>G4BF9D<IIB5[8485I2BMQIT>2dG+C;
H2M@bQ@8X(UZT8SCBQ0WBHA[#b_2<[+-MQW;?K5TCaAc]366<,TYB8QIO$
`endprotected


`endif // GUARD_SVT_GPIO_BASE_SEQUENCE_SV

