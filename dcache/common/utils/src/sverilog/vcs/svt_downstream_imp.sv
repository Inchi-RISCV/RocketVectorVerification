//--------------------------------------------------------------------------
// COPYRIGHT (C) 2014-2015 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//--------------------------------------------------------------------------

`ifndef GUARD_SVT_DOWNSTREAM_IMP_SV
`define GUARD_SVT_DOWNSTREAM_IMP_SV 

// =============================================================================
/**
 * This class defines a component which can be used to translate input
 * from a downstream 'put' or 'analysis' port. 
 */
class svt_downstream_imp#(type T =`SVT_TRANSACTION_TYPE) extends `SVT_XVM(component);

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Protected Data Properties
  //----------------------------------------------------------------------------

  /** Queue for next incoming transaction coming in from the downstream provider. */ 
  protected T next_xact_q[$];

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new downstream implementor instance.
   */
  extern function new(string name = "svt_downstream_imp", `SVT_XVM(component) parent = null);

  //----------------------------------------------------------------------------
  /**
   * Method designed to make it easy to wait for the arrival of the next incoming
   * transaction.
   */
  extern virtual task get_next_xact(ref T next_xact);

  //----------------------------------------------------------------------------
  /**
   * Analysis port 'write' method implementation.
   *
   * @param arg The transaction that is being submitted.
   */
  extern virtual function void write(input T arg); 

  //----------------------------------------------------------------------------
  /**
   * Put port 'put' method implementation. Note that any previous 'put'
   * transaction will not be lost if there has not been an intervening 'get'.
   *
   * @param t The transaction that is being submitted.
   */
  extern virtual task put(T t);

  //----------------------------------------------------------------------------
  /**
   * Put port 'try_put' method implementation.
   *
   * @param t The transaction that is being submitted.
   * @return Indicates whether the put was accomplished (1) or not (0).
   */
  extern virtual function bit try_put(input T t);

  //----------------------------------------------------------------------------
  /**
   * Put port 'can_put' method implementation.
   *
   * @return Indicates whether a put is safe (1) or will result in a loss of
   * previous values (0).
   */
  extern virtual function bit can_put();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//vcs_vip_protect
`protected
#f&]/9B4Q]PC2c?TX?ZI<77dB\#U6^??5F_N.TfWSG/;47aB6\a:,(:c96QUfU_c
BIC\8O,5f<dF=\ReYc/SE:R,WLJHZA>4aGeYd5>5[X^?[K&)CEQM]M0?5)_YE8e5
KXPQIbaLS)FK8K29KE6\)A_E;^GR6TK@M3JK^SLgDT]J3-@=fJ.[aH/,F/\OGJZ>
SN80R1)LTS;R60ZYeE7Pg_6DHSY9CD<KH=X^c)?1DN5PV5P[KZE@0RbP#aQLKA<A
U0O1NK,I@]7F4;A5N\7d->9YcTb<[BdY\0B?MAf=,c8UPga7+GK#:VTIf-/3GWVd
LEQcda,Og@2MG6LeIg?+OFG=_6=SOgPY05a1U[JX7>4FWR9+GgP<5Z3SaWI.J-d=
KI&Ag;QY/I&7T(A8.O=R8VP7&>EM]R1?e\&[RGICA,5(WR#;SgJ.F300]ZG1O/52
Qa_\+^DV\7Z0YbM(1SLLP^R@NdB1&ZMa0FgbX:gS\SQ=Yc<.+TQOFQ];Pa&/gaSF
XZZ.#MC64T9,)eXC4GT,T#9H#+8cV-75Q+^>)6PL8+TI__BB(X>_>WDO^LVBPF6]
R3#A,O=a.Y-QCHFL]RUH6[1^]f(9H^D_V):B22d::&@\N1_SIF8^Ug/<E:\+[3Za
Z#<ZK2LDG-#PS/V9&332/V@CZ,4,cRVe;[[ec(L0#NXa/>0QGOJ22Vc1#ROQ.=1M
_>ceRCG00ReN_I9.@dY,D)f&F9/36:^::FH0PWO?;]XR82@Bb0-W6SL^S&M[AF>B
V8^Bg\JC[&g&##>>RGHH.DPO=1=.a>Y?LDF&X3Q&N\E01QJNe5H2>SE(BA16X/dB
1(]0^6>]78G#L_=K2ba9a^(5ZNdXOd;R=VS0W8V];FDH@]9[;aE)d=4)b[,@&dFI
F=]O+..>E=DKLSJ#Q_R&24Hc(&@b[LN5JJ+aRSP00#W9)TM+R:CPbV,>e[@ZBc8G
PfQ,2,UN,e)H_O5.b^K]6ENHMHN#<?CU]:W&^(9F-R[f1L[HX]L[;\I#Pg^3>_FN
X@5HVAJNY?X5=)^=C5Z#B9&_>g)^MM>;.VL\.0^fa0I>=)2ZPSf@b:Af/[;OZ8?\
e[>,4a\+;HJT<&F+3cbU&/>Q0ZGE7TR<GH_QHTE-a^9HVR;eZ3b3dg&+M_^S7Q,J
7.2Jb4R^MVDTO\Z>+5A4[0d9_PR8ZUc3)44_&>>6Sfeb9W/JbB]cH+9670fOLIZ;
.?&QA5feAJL3A8NE?IC&5a,(/ONC.1]1&beK)aC],I<Za;^?V,gU6:Sc-F8V?6SV
0c[)5VX5:a4;C;(0=<eTJf?8R.dL4VTC3@3&IUJ5>#a^Z@\]SP0D16S=B/^/=MLb
6)023,_e5W<BH:cLG)(W\KJ]K3H<(A]4ZY;#-GXK1RK+>7fR1;;+eLJfa(/^-2=+
^4QNU.fXf_7FC^N,(@fYJ](/gEAJ4\OCe4c#CYX)I/MJJ)gKX2(>Me1<S:YL,5FO
-P+FQ^04^a3N4=99d3eA:S/c->3>&d=JdbXNWMU]-I7U)-CR6G,OE;Q03C4Oe&5V
OY8_Y#KU5bDZ#af2X6aT8?&.HTA3CeMQ=Q5Nf\TQL=2FIP?M.[I9Xa+QP42MM\HP
D?.Yf1TI6<9,a09U3[X2DEQ6SeJ[-,BCCbFcFCR\26]6#KbQ9M;_NO(+C.eDPOPG
06Q&L63#J##G8bU@AYH_>:+C9Q,(6-<#X2N@S3@A/e6RGTMD)LGE]A+=#?H1Q(,T
O_\S4H-CVS(f-M?4C&McK:0cEbMGWY+AgO<eB>L]I(:4VO1W5M2eULMPa[]Q)^#)
B.KPR1:QI393Z\ODBe2E,R6I\#1(f\BW4KIA:W-WIG,fLSIO[U,@AQH/88^abA_S
6]6KERg5cLJ+/6,94QY2Ee>GNWR0Ae7OTPW3e@Y.Ob#<#M8X/(S/0Q>I3_<GTT^L
b]Pff:1_?E(W6H0dLfW;\K(dG:6G9_6T_OVE:R[A.O?SL1(AD3KW[Tg>?_/^^1XT
T\&cEeLJ^P8WBJeR.fZ[8(c2R)9Z+R<Q9;.UP(d1g,aJ)3W[PC(_+P_dg&CI[RF+
GH3(B)dX_P&)eN,5+Z4>(Mc23$
`endprotected


`endif // GUARD_SVT_DOWNSTREAM_IMP_SV
