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

`ifndef GUARD_SVT_COMPARER_SV
`define GUARD_SVT_COMPARER_SV

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_defines)

// =============================================================================
/**
 * Used to extend the basic `SVT_XVM(comparer) abilities for use with SVT based VIP.
 */
class svt_comparer extends `SVT_XVM(comparer);

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
   * that provided by the base `SVT_XVM(comparer)::physical and `SVT_XVM(comparer)::abstract
   * flags. Setting to -1 (the default) results in the compare type being
   * completely defined by `SVT_XVM(comparer)::physical and `SVT_XVM(comparer)::abstract.
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
   * CONSTRUCTOR: Creates a new instance of the svt_comparer class.
   *
   * @param special_kind Initial value for the special_kind field.
   * @param physical Used to initialize the physical field in the comparer.
   * @param abstract Used to initialize the abstract field in the comparer.
   */
  extern function new(int special_kind, bit physical = 1, bit abstract = 0);

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Method to obtain a calculated kind value based on the special_kind setting
   * as well as the `SVT_XVM(comparer)::physical and `SVT_XVM(comparer)::abstract settings.
   *
   * @return Calculated kind value.
   */
  extern virtual function int get_kind();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
Y;I,:(3F0d#fZ^L@^@+W@SN-MXb[_O7:[NC?TUA2=.O,7<ZP1;9&5(,MbYEO3H05
QW>L<A(2-d0(FEBa6[a[EVL7Xa.PX\3_OZFG_#Yb)_4_S72fNSC,64Z=J2c\VXa.
^Ga#?e>17/#^Gd&P\bLd[8^\c/=8C9XVL1F&cH,G6V>Q-7H)A,2=?7M3W@&W()@F
(\:cNAP&+V,2HILF^R324(aPJ=XY),B/M6GeBNFHe38,VT+Ec&aTf7MM-ODdHG\X
Q7V]38?T;PS[KUG71]5/aTK]3FcP-2-YT5O(MZYcHf_MY^-_?N>?9;g^VAU6^9@P
VAH?WQYJ=#,M.W+S[2&#aeN5e^YK15)/]3<X\L,-]82c:ZMA#I__1Y:E?D=;9+,E
gED9\+3\?/LfB=a:GN)I)=W3U8/f+O]g=:g=V<3Ca#a>=IfWHP2I0K_BN88\&^;M
eL6J1BE1b8D]#Sc)fVR9H5]=V#@T1;_df7_Z:K<42:[DJM;g+eU9?N.8d-_=5a7[
N5:<1NV:<EFKUYMZ54:Q]d]M/^X?cUL6UbBI?b08Q9VUN3-[6cUR1_4&@ESZ(;)N
\CM.6=G;NcJcPG48+Y?16]TV(9a6LB^LG3+L(4WZI3WcTT;JOXA1[JU@a_c5g4CX
)_J.cNI>Yf)77aR#f]ES]Kd)\1,W)K8=W&ed:&#J4S<L,.DF<PF-F5ZWeYfKV]GV
LT-J&TRU:4B:,.e>J2IcbN:9,1@f^KK=c[4\W>C/^Dd0@a,T]&9_Q2J@;4N#_b2/
^D<(40K[V1]>P1L-KUdD3P:F^01cT(7DW0&FA#[^U]Db7D\[S:@RI.gX-ZHNaSJO
ALa9/L<OZERCC3]K-310PG74=U;(A;>g#]J[91b0WFWd=?\8H[H=OJOJf#-Oc?/=
F+ZJZTU0_C&&7bGTOVI<=)Q2e.Oe9-;_CGLN->-@gfcYCYbM)-<eX)/7A78)SW[-
ITEW:T4eI@L;89\/G3PC/FNVXP51DR#1EN@OMX)MZ>)6?VQ_A.1TK49XWC8Rb_/e
BSfR<1a30,S9FdU+DF4P&3N_C6OLGJe&ZZ#]Q.LQ(.^__SS;5>?J]aH#S]>Z-0=K
2(;Q,OfPfNbb#LYXDJE]\fHPU&V8840,<ICJT[TWC2N9XDQMe3[4\+2d?aLACO?g
d.8Y_fETF06-BV)]B7,XW?I(,-S#g:.QMB7-F7L+BfA>E)5:P8f0)._#>1SAZ,Ia
[aA40N9I,LX#D#C2XAYYe+[5B@VMAHPF1QAC]=V0A94;MT1JG7bWL:82/QaC)F-\
?cZ=L?JJHP#5?^O-WF^HTRb=G[EP+:@8V+8fg&d\;Q;W>0[B.Ge-/@^O0[U>Y0&N
-K().&O-eaQ<I;\dN2F3T-PVS7L5^XII/R,LgUQdL-cR9H9;-1DY?W:_c&K6W<IY
09:bH)?V9SV?c\2MHW\(&/>0J)+B\5.R:JVgDO@ILaJ-(+Q@X,Td6)dBgB)0a-:S
dDS_[(Ka]:(T+(f[XF7cL2Td89VIBdX3;7P;OF>49LG0S[P;]>Z-BV<RK5=KfO_2
bNb__PSWE2[dO[1:A?(-[>8TWSNc]RHX0B<g3FAP>T<]AA1[GO:C?[;=H2X6f7]V
67.)YCd1_6=57fL5aT):AMBGaDdb??L)KEX[HTPZ[A(C60M5NQc8@@d;[:LJPBAE
f#M0QBW=2]W=2:2,:AUgMZX1W3LaLKOU,B&M;^),UNdF04e3IC0N(1FA=4(6TX9X
E:](?#(98?:7NM5egXOVX)7SAENV+4Q^W7H?[S_DZ4F5>GTUO;>@Y[4/0W47.-_8
RTWJXR1HJKVf&Md:T7].S,fDTZJJ[D8PV1:;/IG4>6PH9R8OB70e4FQ2[2KYc94(
G&;g+]PCT]N].J;\KUebO\HA,DA8a+N,/e5e<&+Dc4DJ<AELM=fY@GXf[&Vga7a&
aBSVJHJDOG=W44MIa.=PT(N^?C4<HP:/&CHcXY@HOUPgZ:(4@M[9=,edVbTM]SdQ
;X/aK[QN+UIP-2cR,29Uc\A]]E8dTAWG?^@+^_ff9[]0+OWT3722]NedN$
`endprotected


`endif // GUARD_SVT_COMPARER_SV
