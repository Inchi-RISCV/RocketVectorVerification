//=======================================================================
// COPYRIGHT (C) 2007-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_DYNAMIC_MS_SCENARIO_SV
`define GUARD_SVT_DYNAMIC_MS_SCENARIO_SV

// =============================================================================
/**
 * This class defines a set of basic capabilities which can be used to implement
 * simple scenarios for distinct transaction types which can be enabled, disabled,
 * and in general controlled dynamically.
 */
`ifdef SVT_PRE_VMM_11
virtual class svt_dynamic_ms_scenario;
`else
virtual class svt_dynamic_ms_scenario extends vmm_ms_scenario;
`endif

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new dynamic multi-stream scenario.
   */
`ifdef SVT_PRE_VMM_11
  extern function new();
`else
  extern function new(`VMM_SCENARIO parent = null);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Function used to check whether the scenario is supported in the current
   * situation. This may be based on the configuration, the status, or even
   * possibly just an enabled/disabled bit. Weights, etc., to enable/disable
   * randomization must be modified within this call.
   *
   * @return Indicates whether the scenario is enabled (1) or disabled (0).
   */
  virtual function bit adjust_weights_per_cfg();
    adjust_weights_per_cfg = 0;
  endfunction

  // ---------------------------------------------------------------------------
endclass
  
// =============================================================================

//svt_vcs_lic_vip_protect
`protected
(22ERVBCFQ.Eed[+@-]T=+^eA=[@8aMYA&.#=EQDa36]a/g^d8W>7(Y(Sc^\EN#R
F<,7@H>Xf5Y[4XGb]A1;=cIJ4PYAd]@:DPgW)]ZN8=4.FNIe0Fc8J&<?)3W&?/TG
Rc?)S@RN;Uf/P1O2,&^-+?LFI5TJd@-_c9;WDM66?&E=(Q[I[]QSPJ9cKB+SQ-/N
XFe/PRNMbgV<Z&/.):SONA/_:=397K?K)NRa^ZIHY2=HRdRL<^^FHCA7-5I5T,SL
PM2[>87L;9A.,DT=/@&\IJ&.Z6f6ITM^F\TTbT\,bX7M.b(U#S718b?@&AV]H--X
+(gag\-]G/1>dAE#)\(Ld5@E>L@Z]L+PX8#I]P?Z<3L7e,a3+^>6)NIWEMLUQA:4
Fe_>+?[U&Lb/G5XIT.aaW7/MZ&01a[4T^6F5cT:1V<I8H^&\gE(a)fUPS5_+4Y?7
)?DSV\Y^)>MWB9Kd7#D_-,E?@C)3B,+SE24L5gMQNUZO5ZJJ4CY,c</:@?CF]C>)
;Ad;+&6.)/#-F8gWVU5f<QZ49<@90E+U)XA.Qb,1ZZY6aS)681:H[-Z5\:D?^8?\
7f,.L6&_?c;b0,,)#2K-L&Z46$
`endprotected


`endif // GUARD_SVT_DYNAMIC_MS_SCENARIO_SV
