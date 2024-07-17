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

`ifndef GUARD_SVT_GPIO_DRIVER_CALLBACK_SV
`define GUARD_SVT_GPIO_DRIVER_CALLBACK_SV

typedef class svt_gpio_driver;

/**
 *  Additional protocol-specific callbacks
 */
class svt_gpio_driver_callback extends svt_callback;

  //----------------------------------------------------------------------------
  /** CONSTUCTOR: Create a new callback instance */
`ifdef SVT_VMM_TECHNOLOGY
  extern function new();
`else
  extern function new(string name = "svt_gpio_driver_callback");
`endif

  /** 
   * Called after the traaction has been received from the sequencer, before its execution
   * begins.
   * 
   * @param driver A reference to the svt_gpio_driver component that is 
   * issuing this callback.  The user's callback implementation can use this to
   * access the public data and/or methods of the component.
   * 
   * @param xact A reference to the descriptor for the transaction that is about to start.
   *             Modifying the transaction descriptor will modify the transaction that will be executed.
   * 
   * @param drop If set, the transaction will not be executed.
   */
  virtual task post_input_in_get(svt_gpio_driver       driver,
                                 svt_gpio_transaction  xact,
                                 ref bit               drop);
  endtask

  //----------------------------------------------------------------------------
  /**
   * Callback issued by the component after completing a transaction or detecting an interrupt condition,
   * just prior to placing the transaction in the analysis port.
   *
   * @param driver A reference to the component object issuing this callback.
   * @param xact   A reference to the complete svt_gpio_transaction descriptor or interrupt
   *               The transaction must not be modified.
   */
  virtual function void pre_observed_out_put(svt_gpio_driver driver,
                                             svt_gpio_transaction xact);
  endfunction

  //----------------------------------------------------------------------------
  /** 
   * Coverage callback method called after a transaction has completed or interrupt condition detected.
   * 
   * @param driver A reference to the svt_gpio_driver component that is 
   * issuing this callback.  The user's callback implementation can use this to
   * access the public data and/or methods of the component.
   * 
   * @param xact A reference to the descriptor for the completed transaction or interrupt.
   *             The transaction must not be modified.
   */
  virtual function void observed_out_cov(svt_gpio_driver driver,
                                         svt_gpio_transaction xact);
  endfunction
endclass

//svt_vcs_lic_vip_protect
`protected
N:A.<MNc(J/Lf,6:d]S+V?V4>EFE,PVIV/:>.+V8&DJP1@fRdU9<((f7cg[bU&2P
Ta-&[b==aT#CccV#CVMJ>.^<UfQ^dP<GGNfM#PX/FUW4Ug[5ADZ]Q,)1dA0J-W/#
@NR+S3A@e7C0CSQV8O]G3aUg-)S=SX3_c_=YfV8DH:.G/L@Cf(<?:B^9=eMFTXT9
fS;@:)fM^?1O;g]gA.9U<dMLd71X8-58NKG<V+M:Gf@1.KTe[^JS8P8H&)((-)RZ
6P&69CAbL.@JV?aZ0Z+Tf):+N<BCQO_L5[\I?]^PTYCFBK.T412<VVWe,W>feN[8
Ec3K;#R3+?T7Z>M&NQTX@[g4eH9H1,._N1,J_@aI<\JTecJ4?L/fZ/[GZC,L-&@1
6IMXC5T[Zc>K42-SG10>a;X[1CT_?fXc/3<5?.^E5K\R)<e]/LMUE&;0PY)8H)9@
8X?&@d)33M=SY#/GI4=2DU^cN@@C1(P\aFbLD5D_(9HSA7.^LFfDgJKIg;Td;/,5
#[A_V:=BFdXf2BHHSc27D[^c4$
`endprotected


`endif // GUARD_SVT_GPIO_DRIVER_CALLBACK_SV
