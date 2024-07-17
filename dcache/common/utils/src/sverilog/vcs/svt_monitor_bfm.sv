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

`ifndef GUARD_SVT_MONITOR_BFM_SV
`define GUARD_SVT_MONITOR_BFM_SV

`include "VmtDefines.inc"

`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_xactor_bfm_if_util)
`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_bfm_util)

// Kind used for byte_size, byte_pack, byte_unpack, and compare
`define DW_VIP_VMT_LOGICAL  9        

// is_valid return value which indicates "ok" or "valid"
`define DW_VIP_XACT_OK 0

`protected
I;(<FJBS,BQ]g92B0=V^B;Cc=)Z9T2/B_FHSK=?GR8f\5CJU=Z0_6)JS7X^A_M1\
SRYOS@6c-NN>+V(]I#)==Q#42N?.Q_.:;7T/U[LHM2WAH:?HgGDPFcRQ.ICfgEc4
fGD/U0Vd-G=KS\V[U?^Y2)]KgIYG7BYF:1O10<^^Ld7@<I[8>NOSI,HY&Qd.M\;0
5R&9Mg4?aLgK+$
`endprotected


// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT agents.
 */
class svt_monitor_bfm extends `SVT_XVM(monitor);

  // Declare all of the properties and methods for this monitor
  `SVT_BFM_UTIL_DECL(svt_monitor_bfm)

  // Declare all of the virtual methods which allow access to the base VMT commands
  `SVT_XACTOR_BFM_VMT_CMD_METHODS_DECL

endclass

`protected
(QSea#HgX6A6#^.L@>=Y@BY2L;<CC]QdUHA[b#fddUHg2Q:f[KZ_-):6QXPK@I)=
LXL9K2CdG+&Sb^@1^ag7b81aH<6gTbgU/I7QBT)_.443AG:C#UaA6&OQ2188KIDf
5B,9X6NL7A6R=)VH78A;[GdcMe&8<aMWgV-8IY4;0-fM&\UeO7:/a0+3[IGf5[1G
G=U4;/g^cPgR.$
`endprotected


`SVT_BFM_UTIL_REPORT_CATCHER_NO_PARAM_DECL(svt_monitor_bfm)

`protected
Zda4[07d9+5SZ[HP2W5/?\H?>3HZ4<T,8IET<,eT<@5T\/66W=?^,)F6bJ5BaQ(a
J#I\OJN6g]ZOOMeQ\Z5W-T?FgOKb;JU#X5C@\49(68Ja2RbX=2LL4NdVF6QAM=.B
ED)H9<Y/<-caeBeSAO/Q]H?F4$
`endprotected


// For backwards compatibility
`ifdef SVT_UVM_TECHNOLOGY
class svt_uvm_monitor_bfm extends svt_monitor_bfm;
  `uvm_component_utils(svt_uvm_monitor_bfm)

  function new(string name = "", uvm_component parent = null, string suite_name = "");
     super.new(name, parent, suite_name);
  endfunction
endclass
`endif

`endif // GUARD_SVT_MONITOR_BFM_SV
