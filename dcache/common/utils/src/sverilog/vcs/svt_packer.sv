//=======================================================================
// COPYRIGHT (C) 2010-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_PACKER_SV
`define GUARD_SVT_PACKER_SV

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_defines)

// =============================================================================
/**
 * Used to extend the basic `SVT_XVM(packer) abilities for use with SVT based VIP.
 */
class svt_packer extends `SVT_XVM(packer);
   
  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * Special kind which can be used by clients to convey kind information beyond
   * that provided by the base `SVT_XVM(packer)::physical and `SVT_XVM(packer)::abstract
   * flags. Setting to -1 (the default) results in the compare type being
   * completely defined by `SVT_XVM(packer)::physical and `SVT_XVM(packer)::abstract.
   */
  int special_kind = -1;

`ifdef SVT_UVM_1800_2_2017_OR_HIGHER
  /**
   * Added property which was removed in the IEEE 1800.2 release
   */
  bit physical = 1;

  /**
   * Added property which was removed in the IEEE 1800.2 release
   */
  bit abstract = 1;
`endif

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_packer class.
   *
   * @param special_kind Initial value for the special_kind field.
   */
  extern function new(int special_kind);

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Method to obtain a calculated kind value based on the special_kind setting
   * as well as the `SVT_XVM(packer)::physical and `SVT_XVM(packer)::abstract settings.
   *
   * @return Calculated kind value.
   */
  extern virtual function int get_kind();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
T14dGf\,8?fFCHB(OI[<EIZJb>)CE.@NZS9@CE>ENZNOZU>KA3HM((Z\>X:NZ,[@
5A#5ZO.-T#=:]QP.:@c/5G+)8YB[b6eDd98Z7bVBL21O:=N5EV(&>^0N6.R(<bNW
CU(H]e#@_/f]8_(2CL02YG/)C<0/d\#(DMV2OaO;J6>g&E^?IC)Y3.TD8,Oe[:7&
9cb[LX@E0Tg_=D4/a-TZ3\_E#D>MRW/^:&_E>^7W&YM+AQZJX.&YH_UeeMI_9I>L
NDc)@?Z>,e?cM19=/dc)HKMO(=Ag>JV3f0D=BeS,LNU3D\1A:cX7JM^K#9PM[,H@
X(2Lcc8.:UUJPQ?<#4B\0GV:CBJ@5^c&Tf<0a)W+eK7(L=)ES-G=>B1(5Q9W3:<]
_-[&)L\PF>?W+JB1BZ[)();9=N&T3JLW;-A./24;LCKKTR9SWAU7+Ja.]);B7SUG
,4</I=>2S@:/agc<8_cCaQD6gJV\aMFbK,R?@T>.K0JXL;RSD?IgDDZ=^8[?L#YE
3BX=IY31WK9?g;W<dg9?)f1T-Gf9d+]Z<::3ME+F6\:NIa,f-1#O/gH-]&P-JT)4
^=SG;bDKJ6I1.YS1F=6WKM\3U+f4;.V4AP679R5J?9;S[V3(4JfF#Q3KW5&H]GY3
a83?KG@=,aAHP9fI8<c=;KLL9PA7CY9WPE<]->1dBL;<H7&B2;V)4?Q5HXKLE.;#
EVTK,2_5;3@/_Q+K)BI&\<RUeJ0e2T2H;PfWP@\c^3=1.aX+Ag<f-]UcWJX>0N)6
1?0S#(JD=NBFT]LRadCaaa?fRR^9TV0W.60e&O^/:R^Vf5cV-6C4+0(N\#X9Y2X/
)ScC(9D7JWIR2?UeQW=72b1LS#_5f8?;]:@A,2<;V]_gE,O6,1:R^L1G4]:J,+g/
L./aXVD[2f10<2J5.J@:gNaX^,)(P/NWg,V^f:16df<]dbO&]2C(54XN\L-PB:<?
<Dad[3g[QM2@@?#U?T=37aT7XdZUP0??Tg(Wc_\C^^J/U4PV4;8/:IA/Y8;.T96F
^bN@Q3/MCbFH)LWZ4#A&WJT74$
`endprotected


`endif // GUARD_SVT_PACKER_SV
