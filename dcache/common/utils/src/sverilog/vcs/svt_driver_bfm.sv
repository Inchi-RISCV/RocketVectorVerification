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

`ifndef GUARD_SVT_DRIVER_BFM_SV
`define GUARD_SVT_DRIVER_BFM_SV

`include "VmtDefines.inc"

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_xactor_bfm_if_util)
`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_bfm_util)

// Kind used for byte_size, byte_pack, byte_unpack, and compare
`define DW_VIP_VMT_LOGICAL  9        

// is_valid return value which indicates "ok" or "valid"
`define DW_VIP_XACT_OK 0

`protected
B2[9V-YT]XLF-:>,dIfC4,NPM:=f?H;?MN?HZ:HC#_YN/[^I6V#+0)NG800EZI3&
b9QZ[.R3/(CUeQ[>GS]_-_L?4<3:fYDfF-C9B<]D8/#QM+f?C/gPOS\CO;3c#N^(
NRc;4aB=6c4_#dAJC&H#5VAW;.#ZEAg&?&A8WNQYI9#F5Wd]3aRAD;7[(FgR[Oe4
UVaT@=gKffJ_*$
`endprotected


// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT agents.
 */
class svt_driver_bfm#(type REQ=`SVT_XVM(sequence_item),
                      type RSP=REQ) extends `SVT_XVM(driver)#(REQ,RSP);

  // Declare all of the properties and methods for this driver
  `SVT_BFM_UTIL_DECL(svt_driver_bfm)

  // Declare all of the virtual methods which allow access to the base VMT commands
  `SVT_XACTOR_BFM_VMT_CMD_METHODS_DECL

endclass

`protected
#DY:b=WFE1dgTd[GE?SY.6.)<aT=d(VcaF]&Cc?4;e#aVW?R1Z(b))f_3B=JP3JP
Y]S2IGa@4J:1,KZ(J;;W>;e\BY#:M2WM.4=c>5/=@L>gJ8:P)S&3a#a/PA7Af@:4
WEdMdbLE<84_/fOEB^BY>^SN-;(+#(6;8U9.]):C7a.cZ^CT)VS&8f&[eB;Me>f_
f]Ce)BKN(J(_,$
`endprotected


`SVT_BFM_UTIL_REPORT_CATCHER_PARAM_DECL(svt_driver_bfm)

`protected
MSC(/cG[DZ#_)E\5APYT:8,94Zg:W]c71U<L&7G-Q];_JW-g>L;Q7)(O83Q@T^_D
DPBQWEaVc#MZY4?0#a]3T5Y8N/f3aDXC1@,6b&cL,,d.>Z-BIDbN8H2^[d@+e4eU
[#K>HC-@+4gZ0$
`endprotected


// For backwards compatibility
`ifdef SVT_UVM_TECHNOLOGY
class svt_uvm_driver_bfm#(type REQ=uvm_sequence_item,
                          type RSP=REQ) extends svt_driver_bfm#(REQ,RSP);
  `uvm_component_utils(svt_uvm_driver_bfm)

  function new(string name = "", uvm_component parent = null, string suite_name = "");
     super.new(name, parent, suite_name);
  endfunction
endclass
`endif

`endif // GUARD_SVT_DRIVER_BFM_SV
