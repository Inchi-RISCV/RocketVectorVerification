//=======================================================================
// COPYRIGHT (C) 2010-2016 SYNOPSYS INC.
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

`ifndef GUARD_SVT_COMPONENT_BFM_SV
`define GUARD_SVT_COMPONENT_BFM_SV

`include "VmtDefines.inc"

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_xactor_bfm_if_util)
`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_bfm_util)

// Kind used for byte_size, byte_pack, byte_unpack, and compare
`define DW_VIP_VMT_LOGICAL  9        

// is_valid return value which indicates "ok" or "valid"
`define DW_VIP_XACT_OK 0

`protected
ML#1MYM,B463R/6F_5b&=BGQ?;DKD,]eac[Y/5)3b.J9NFSLBQ.F0)VG,AdA=C=#
+X<,SFV&?<gT3-SQ518eI52@@7>>;J?D0-GIKfc=BJ]SSU=)VB7^?,@&7#FHc(?L
@&S#ETUgL2G3OBB+.IBW&g_)>USW\+ZRHMVGS:P#33I1g]^7+_60K64MXE5-_UIN
&762]0+e(6G3-$
`endprotected


// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT agents.
 */
class svt_component_bfm extends `SVT_XVM(component);

  // Declare all of the properties and methods for this component
  `SVT_BFM_UTIL_DECL(svt_component_bfm)

  // Declare all of the virtual methods which allow access to the base VMT commands
  `SVT_XACTOR_BFM_VMT_CMD_METHODS_DECL

endclass

`protected
R_V-Z,<G1J(c><[dQFabJX#UC+P=#;K+cZdf33>;&&.cO1JfD()S&)^gE9<#Z3,X
HJVFC=0BU)+,.FHa#a8af3?9]=XDbEdFK@U:UBQ_82e;[8WB,6b9<84c3McIJ4f8
YI3EQVJ)Z:aE^C9,ABD=Tg+\F[@Z9/E.H-2NbM#XY7#]]&L>d2_Qb4IEK)#67:W3
_]#=>2J6T)/a+^/-_&0LDf+\2$
`endprotected


`SVT_BFM_UTIL_REPORT_CATCHER_NO_PARAM_DECL(svt_component_bfm)

`protected
4Yb?UH9P>]H^Y6>4(I?M4DRM0&-/b6CdV6T8R-_;.]7Z#01V#^\/&)A<H0bR.U=<
]1R[<feOYL>[^F6=?0JgJE1L&A&&eAcD))3dLc5[+MW8L3]N,S>>Q7.cQL-^FDLN
2-05M>NE(^4[LcS)<7J5ZL1L6$
`endprotected


// For backwards compatibility
`ifdef SVT_UVM_TECHNOLOGY
class svt_uvm_component_bfm extends svt_component_bfm;
  `uvm_component_utils(svt_uvm_component_bfm)

  function new(string name = "", uvm_component parent = null, string suite_name = "");
    super.new(name, parent, suite_name);
  endfunction
endclass
`endif

`endif // GUARD_SVT_COMPONENT_BFM_SV
