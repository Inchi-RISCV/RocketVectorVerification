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

`ifndef GUARD_SVT_REACTIVE_DRIVER_SV
`define GUARD_SVT_REACTIVE_DRIVER_SV

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_cmd_defines)

// =============================================================================
/**
 * Base class for all SVT reactive drivers. Because of the reactive nature of the
 * protocol, the direction of requests (REQ) and responses (RSP) is reversed from the
 * usual sequencer/driver flow.
 */
`ifdef SVT_VMM_TECHNOLOGY
virtual class svt_reactive_driver#(type REQ=svt_data,
                                   type RSP=REQ,
                                   type RSLT=RSP) extends svt_xactor;
`else
virtual class svt_reactive_driver#(type REQ=`SVT_XVM(sequence_item),
                                   type RSP=REQ,
                                   type RSLT=RSP) extends svt_driver#(RSP,RSLT);
`endif
   
  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Request channel, transporting REQ-type instances. */
  vmm_channel_typed #(REQ) req_chan;
   
  /** Response channel, transporting RSP-type instances. */
  vmm_channel_typed #(RSP) rsp_chan;
`else
  typedef svt_reactive_driver #(REQ, RSP, RSLT) this_type_reactive_driver;

  /**
   * Blocking get port implementation, transporting REQ-type instances. It is named with
   * the _port suffix to match the seq_item_port inherited from the base class.
   */
  `SVT_DEBUG_OPTS_IMP_PORT(blocking_get,REQ,this_type_reactive_driver) req_item_port;
`endif   

/** @cond PRIVATE */
  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
   
  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************
  /**
   * Mailbox used to hand request objects received from the item_req method to
   * the get method implementation.
   */
  local mailbox#(REQ) req_mbox;
/** @endcond */

  // ****************************************************************************
  // MCD logging properties
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new driver instance, passing the appropriate argument
   * values to the uvm_driver parent class.
   *
   * @param name Class name
   * 
   * @param inst Instance name
   *
   * @param cfg Configuration descriptor
   * 
   * @param suite_name Identifies the product suite to which the driver object belongs.
   */
  extern function new(string name, string inst, svt_configuration cfg, string suite_name);

`else

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new driver instance, passing the appropriate argument
   * values to the uvm_driver parent class.
   *
   * @param name Instance name
   * 
   * @param parent Handle to the hierarchical parent
   * 
   * @param suite_name Identifies the product suite to which the driver object belongs.
   */
  extern function new(string name, `SVT_XVM(component) parent, string suite_name);

`endif

  /** Send a request to the reactive sequencer */
  extern protected function void item_req(REQ req);

`ifndef SVT_VMM_TECHNOLOGY

  /** Impementation of get port of req_item_port. */
  extern task get(output REQ req);

`endif

endclass

// =============================================================================

`protected
C-O?5Z98QE;08\8XHU-Qgd85e72=8@FdL<c6Ag#6f21W;2?/FcR@5)3WG?#ZEg\+
JCHf0_ICJ>Rce=Y4O:3YAG@/43b.D0F5K>FgZA?MM??JeZ)H:U7[]N>P;6_YY+=:
V^LW-3[P3Y,-?QGM]eTa>S1#I\]c@Y^Lb(2)?BZ#8c[Yc6(_A.;B_SN=:5F:VDbf
NU>TI_BYZgY-<g<A2:NT)C0Be3S^2C?,;WLEW67BLL0:;E8V(WfYTX_gRY8X6.ND
,H\Q^f(,+f,1@GbK/G/_a^>DG:535?6)U&W6T\OP\B@Tg]KN8BV3T1?M\g([MHQ(
,(BF_:IK[>2;DO/]YP@D/,VFLX.DD&JfFEb],Qf7N95/VEXO_62XaQH)BLE17fB.
.]E@93)+VbC.+N>?M>?8+?&967f9\7TGD4BNII7,AbK;M&cUG3eER0SVDRJ1_0V(
8X8(M+b,FeT4^:I>8ZM1DN2Jg04V.+G+.CdC2F(R47S2OE\I@9]6F>XIb.QL4K4E
Y]Z)0Eca;=:#aaHNU1JKRTE4IL[;7=e\];>I2PF;(A?+DbXM,dS59@P=&[PG=\H8
Ya(5Q]YCQ)]Dc2/Q4U^f1UAeZ7SJX;LPBWZE]430?5P@#BCP5)C:,77S:8c7W2M=
@J=E;cZ^\D,2EVfPFN<>,_A^@XaDEGCHH#4[WfVM]VK0=,KY@]b2<X?b,9BEb;O0
b^HVG9T;2KE;+G2A)d:::69Z7)UaX;N=9$
`endprotected


//svt_vcs_lic_vip_protect
`protected
.4Y20DXU4L?McRWE5##V0SW9C?7PP]][HL4T2>3H@AUV2133eD:H+(eD59[<@fE,
?26+ITHY,O&e#:UB)LVBf12W<C:@@aW:Q8:Sg+./]f#a1J447PEBeT-f=C@N\Zeb
;XN08S:+SFSa3#f=5H7M/A-#2H7U8VWR+Y,S.9g2@^O>KdPV4BP^8FVXbPME\_TS
A,b#Nb(VPAN-9^eabI<&>I^d_6aG8E&;Z[V,)g\&TC-NU4#TT_M>Q)BGA.:VLZGb
43<G2MM^>B1gM&Z5NB8^(QDFd&N>6aA&5&#WEc@YBK,LJM1?4TN(-+J/]U@3fE=K
M1?2Vc.KI^&WcIc0#^,951+-ad+eXM#S(;PTH/1H<)3E.g55M)H^EbUd2TPLKN>;
IXUM^4QW3X^ZM/_1YLJJ_&[+_E^ZBbI1OI-?++)I1<VZdFC#_-ETD?Ng+,E&F>]d
<./41S/g_M3U06W(g1-NI0.VQ+QKNK<7M=YK[gPL<=P0J@CHT8M;gb\RSI(3UC4P
f@?gTc74f]1CT6>K&YC8L\WL]PYJ?g^S(eX^2F^.0@Sf38+B]\>aOacZ4DO=O)CW
OH5<#_OV)@[bRYWcUY]B5O,H/Bb(O///8M+cB=32<#&3b<YLFAT@-LC1?H\N_E[9
=SNN0/VF@=0T-a()X=YNdIIGI;]+U8F_e1\_3a@45P?[[932dO0A[96-\,,XJ&)Z
:Ef-4X0/(3cCQ6B]:^_N2KgHb1>[:_cFDCOGc<1FXXb:#+NA.Qd#ZGaE[Y&Cb+Jc
WKbR-:7aQ)dBcA]><Bf-W;/1TG(=BN]Q^Q)OBfE)(aGb2&FO>dE1#R-1b7J55UT<
6-2^?DbRS>3cR#JA8ECQ/0:F.b:Y569H3R/MCK9bMI^Y<Ag#-HV5K?@Gag>gL\HJ
P,W^3XT/-2e>>dK(KB\H-V&0YEX=g9Mf\GL7b+Xd5]9YF$
`endprotected


`endif // GUARD_SVT_REACTIVE_DRIVER_SV
