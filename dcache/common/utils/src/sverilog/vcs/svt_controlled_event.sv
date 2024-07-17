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

`ifndef GUARD_SVT_CONTROLLED_EVENT_SV
`define GUARD_SVT_CONTROLLED_EVENT_SV

typedef class svt_non_abstract_report_object;

// =============================================================================
/**
 * Extended event class that allows an event to be designed to be automatically
 * triggered based on external conditions.  This class must be paired with a
 * helper class named svt_event_controller.
 */
class svt_controlled_event extends `SVT_XVM(event);

/** @cond PRIVATE */

  local svt_event_controller controller;

/** @endcond */

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new monitor instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name
   */
  extern function new(string name="", svt_event_controller controller=null);

  /** uvm_event method that is used to trigger the suite specific trigger */
  extern virtual task wait_on(bit delta=0);

  /** uvm_event method that is used to trigger the suite specific trigger */
  extern virtual task wait_off (bit delta=0);

  /** uvm_event method that is used to trigger the suite specific trigger */
  extern virtual task wait_trigger();

  /** uvm_event method that is used to trigger the suite specific trigger */
  extern virtual task wait_ptrigger();

/** @cond PRIVATE */

  /**
   * Method to implement a conditional check to ensure that the suite specific logic
   * which is used to trigger the event is only initiated once.
   */
  extern local function void activate_controller_condition();

/** @endcond */

endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
Z25?J?:(^TF7g13+0UII8EP)@2_U]UXfFf+5,PO&W]/C3\WXcVfG7(I-1T5Od3R7
_a[WW5HJ2(B2fY@CI,DK-ME[BV/c@a2GTBNV@BRDIOa.EHKN)X_8Te0)7P^RaKA+
Aa>)W+E)-PM/YOJNQ_:#4d2R[ORLd_2?TENaRVd\SdM@L@/,(B=c9fd#MAQ,4UVE
U?8>Ed#Lb4#5\2-S//-QF60^?aNY&S:]SZ<;51T+;2<-X86W\BB7H;TZ_)eS&+Ja
L1@K.;@3F:KZ(/O3)LbBR/Y1TUWQGV.()gDb/]R^4-B^J.Jg/Y-b@A92/&cf,ILe
1e,Q0fL]?P3AU-;6Hf<X#\T<EVG[R96_,L1@1U-<gQ.Jd42dMb]MZ)2X-.LC^S:d
CR[]Rc?Z15\T;^d].]51Fb^\(6BC2E@fb\MSE&@L)<DIU#V3)ce#9I&-MH1a)9d&
OL+D@Q(UOI<6/FPI;4V3H>R[TTg#6@>B9fE7e^K^gCXG:,PMS+F>HJ7JO_,QMg\J
V&PLN+ZBJVFeDSRK-a5G=>4c>GNY:4JF@D)?0;=T^]97@fb:)^ESPNC[F&3NA^)O
7;JO;9fVc8T4WM52V9.QMc&a+@_V3L1/F:Vd9=DFW>I_QBRTNQ4L,X>a^RNBE6Gg
fCI:2G(#6#W=c:Mg8R.98Q6HV&OA03UHC5@C9L+9#:Y)<MAc42Q+6?II\#\,-DC7
2D2##,D7?>RD^P?/?@FY;8_)?Z6YH@N;T\CI+9=FDK&.bb0Vc3>VaXJR\K]aVJUa
LRV,g@5FN7FG4fMg4]LGad(DE<cRNd#BPKbfFL=GQS-DJ=Q\^;5T\.A7NJB;f6MR
V^(gCFT#7U.35B2#IM^LB<7MV[B7U]c#^&[89U3^E7WO(W9>Q6L.WSK9EU:=+MGU
H,-8T>#E7g>IN&dgGKf^RV.,L6V0@?[=6H,\C3?TaZ_.\ZI>W-A2:,MTQU]6PC.W
DD_]=D&A+R6MKg4)(HT_f)+S0_[/,+TIM#RIJ/@4eDZ53NCM&=/Pe)]U2fL^V\>f
9]HEOVCA2NBLY4\HLI]]?-WKK5O/81XA=C.?.,55Tb;V1WP.^R-P^MKXBDUOM5-_
3abK)YYIfbc[0>Q1I(:c)/->:(>Mc]PQ03;66,aI4/?W.RfFLC;KK30b0&Lb)^P0
G:S1EJ+;+2E?SeM=S?2+L3.JZFA<7)/[\/aV(bAPedO2A#N][]W>Oa7aTEG)L@MB
,?bMGD]+;?I21(g2L&ge#D6;f;=IFdb<gHA07DF__dJ/;F3QY#(MV_BM_gMTB/=:
1^\ZI#>6&g@ELY=O;F0Z:WPWbb#)(=f?<]=D1FR#+,b,K#.K,=\GgGV?@LP&CZWX
MH63=/[c3W]GQ79(K8K_)]40#5;fPdKED/O;+\=cf6.:O4KYI>(X:++dM2d8/]2Y
Wa^Z4R>MT)b+b=?87C2Pb,?)M[GBce.F<+-MF&A?X7f-)-HLOYK0?+-SMT9IC^O7
YSMfE8f7[M#]KT^a#=?-4.3HQae8_:1GL_0:I\#DPT-P)c9\gWUaE<Z/+U\X&#\=
,S<V>JFKTJeEA3LS^IA9#T32>]_2cN@4IS]G@L3(K&&ce).RdK-O62G1-8;O1Y,M
5MX:,X8DA#ZaVGA6>J1aHa_6YDKE:=#_):CD]AO.fX:A^VL4MUfFeVGWXaGRIO;X
5Z6]7:[P#@X:TJ_(>F\37&N-VUO62:dV2->8S]UK]PRMe_?Z,Ne2e_UN,5VObcZ8
8MIWE)b9/HO-BCBRE-\+V(3;BI:1C6)J--e8[UB4d&A.SNL</D?,O05858OOH<60
MaZN;g?J_(gVb37D1KYf,=^:82_M(aNC>Bf)Z.AKAD)<SM,^SE03Zd<HX#g;c20U
80bK84#9f#V>95EI;a\0edCHXZ2KS<AgKT^aFCdC2-O2_eOH(L:Jc_E]:@\(-gIK
DUVY46ScS9U5N+;@TcS8UB/Q<F8X^Xc9HUI8((Bbe()F3/U0/1Q5ZW\H&T_PSP^?
K=D)S^+,QOXVB9ZgLC)53>TdD^;TU91N70;5VME8^]R147C/8CK<.gQR;@V[L,X>
3HAQ/G=+-Y&=+S)IY48H>@^Od5DT3>>-;;W/3bQ=71DV=g\_\be^M\HGa_bJK@ca
][fRf:\OT69:Y5?_;UR@_VEQA0RCOL8c#VAb1YgZBO6]/gQ(I>Na9MQZ7BL[g#8C
VTYdeT]db2>L27RJSX5\-PTSeeOEP68GA<N)\OHI;_P+H\5NN(\g6P&J,ZK38W8?
ZQH]fI5Z[=-70&&\M)(2;R31LJ;W11:BL.fKJg;?U5@VZ8C[:RD+@bH9]BP5E&]]
^3W/Mf6QX5bYDOM@5_X6RS)M@Q[T]M2/G7LEL-Y=g)P?O_If9#84I^OGM-&YH2Q#
F8IM4WO@Ha9TY6,@2e0;=@e.:E&N;N9bG>+GR];DN;C)G5f#bY:6^X(M73d5IEYX
R\b#IV<RK7H33396I&IMBQbKJO&P1PgP>$
`endprotected


`endif // GUARD_SVT_CONTROLLED_EVENT_SV

