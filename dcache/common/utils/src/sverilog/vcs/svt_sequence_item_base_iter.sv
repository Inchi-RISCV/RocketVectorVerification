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

`ifndef GUARD_SVT_DATA_ITER_SV
`define GUARD_SVT_DATA_ITER_SV

`ifdef SVT_VMM_TECHNOLOGY
 `define SVT_DATA_ITER_TYPE svt_data_iter
`else
 `define SVT_DATA_ITER_TYPE svt_sequence_item_base_iter
`endif

typedef class `SVT_DATA_TYPE;
typedef class `SVT_DATA_ITER_TYPE;

// =============================================================================
/**
 * Virtual base class which defines the iterator interface for iterating over
 * data collectoins.
 */
virtual class `SVT_DATA_ITER_TYPE;

  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Internal Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Log used by this class. */
  vmm_log log;
`else
  /** Reporter used by this class. */
  `SVT_XVM(report_object) reporter;
`endif

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the `SVT_DATA_ITER_TYPE class.
   */
`ifdef SVT_VMM_TECHNOLOGY
  extern function new(vmm_log log);
`else
  extern function new(`SVT_XVM(report_object) reporter);
`endif

  // ---------------------------------------------------------------------------
  /** Check and load verbosity */
  `SVT_UVM_FGP_LOCK
  extern function void svt_check_and_load_verbosity();

  // ---------------------------------------------------------------------------
  /** Reset the iterator. */
  virtual function void reset();
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * Allocate a new instance of the iterator, setting it up to iterate on the
   * same object in the same fashion. This should be used to create a duplicate
   * iterator on the same object, in the 'reset' position. The copy() method
   * should be used to get a duplicate iterator setup at the exact same iterator
   * position.
   */
  virtual function `SVT_DATA_ITER_TYPE allocate();
    allocate = null;
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * Copy the iterator, putting the new iterator at the same position. The
   * default implementation uses the 'get_data()' method on the original
   * iterator along with the 'find()' method on the new iterator to align
   * the two iterators. As such it could be a costly operation. This may,
   * however, be the only reasonable option for some iterators.
   */
  extern virtual function `SVT_DATA_ITER_TYPE copy();

  // ---------------------------------------------------------------------------
  /** Move to the first element in the collection. */
  virtual function bit first();
    first = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /** Evaluate whether the iterator is positioned on an element. */
  virtual function bit is_ok();
    is_ok = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /** Move to the next element. */
  virtual function bit next();
    next = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * Move to the next element, but only if there is a next element. If no next
   * element exists (e.g., because the iterator is already on the last element)
   * then the iterator will wait here until a new element is placed at the end
   * of the list. The default implementation generates a fatal error as some
   * iterators may not implement this method.
   */
  extern virtual task wait_for_next();

  // ---------------------------------------------------------------------------
  /** Move to the last element. */
  virtual function bit last();
    last = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /** Move to the previous element. */
  virtual function bit prev();
    prev = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * Move to the previous element, but only if there is a previous element. If no
   * previous element exists (e.g., because the iterator is already on the first
   * element)  then the iterator will wait here until a new element is placed at
   * the front of the list. The default implementation generates a fatal error as
   * some iterators may not implement this method.
   */
  extern virtual task wait_for_prev();

  // ---------------------------------------------------------------------------
  /**
   * Get the number of elements. The default implementation does a full scan
   * in order to get the overall length. As such it could be a costly operation.
   * This may, however, be the only reasonable option for some iterators.
   */
  extern virtual function int length();

  // ---------------------------------------------------------------------------
  /**
   * Get the current postion within the overall length. The default implementation
   * scans from the start to the current position in order to calculate the
   * position. As such it could be a costly operation. This may, however, be the
   * only reasonable option for some iterators.
   */
  extern virtual function int pos();

  // ---------------------------------------------------------------------------
  /**
   * Move the iterator forward (using 'next') or backward (using 'prev') to find
   * the indicated data object. If it moves to the end without finding the
   * data object then the iterator is left in the invalid state.
   *
   * @param data The data to move to.
   *
   * @param find_forward If set to 0 uses prev to find the data object. If set
   * to 1 uses next to find the data object.
   *
   * @return Indicates success (1) or failure (0) of the find.
   */
  extern virtual function bit find(`SVT_DATA_TYPE data, bit find_forward = 1);

  // ---------------------------------------------------------------------------
  /** Access the `SVT_DATA_TYPE object at the current position. */
  virtual function `SVT_DATA_TYPE get_data();
    get_data = null;
  endfunction

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

`ifndef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /** Returns this class' name as a string. */
  extern virtual function string get_type_name();
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
P>JC^4W:2EMN9E:_^SGG0;;QJ/Nd;5)E\U4.9TTfNO<KOIAH5A45)(W?(IC^A(T1
bR)#-1J@F0T,Xf]Q&;J5:S<BHf40AJ&O.)9XF8PPeWU,C?@aSJ;cN8NfBfBG,UUE
H4,[QV48N@K6L1I2d,B6WV=:TL6@=P<WJXL8debRPDaeFaA_UG?2RccMR172.7LI
eQ5+PVVbLDQ[&JG7=[gC16,E9+g1a^Y)=aZ=7).[JS_=a&,,8OIYMO3b0[V=bMB8
Og>IK)A1dXAe^b=/3&FXDcN8EE)e=PGFY/.RSLg>92;f,dQ@e>KYGgJ<_MW>388^
D=6-e.RQH0K#9?V:WY=+;>\]KQ,,[M4fUe-L6b14Z+/3M&-D7K7GgI1@XJLA_7#[
IB>HSf=Gb76;SOOaV6X<[M^[NaQB\RJ[@Z\F-PfJL0@H_7X1>XHSKDG#GP)Q_#Ze
A@eF2R_bK-YgDHf4dUeGY;>aBTe9a4F<[V01:c74&V)6c<&F-6-+M<V(X195TU31
5,<[Y6O,U]^P_J^;X.GF<-.&/LWN@V0N1g)X&FfMA.B5A2/(HAO\F0YO>>NKQ6:S
0:^:SIIg]JI^MHgGHdK7-BDLG\=/D4?(0UL2OA8^c8IPJ#g5E1bRLWJ^TYTJM;Xg
U\JE4#B>7D5D16L<+d3EFJ]9gNLePZ-cC&dP7CG:Lf_d=DU;P?]/c?F)Je)QODS9
>[MWG(Pg3BA]g:SLA+U.ZSBN2LQ+]Z,F1(Z4IIM>(ZfbPE\A-5WYAMbK3S/X0WY>
-9FE>g(7\Z[G//K=.YVO8Xc>:ebBR>,VXCO4[eaH/WKL.9&&f;/R7cOI[&b)_0bD
JB[e,CHa/O[K2[9\Ee-V_QZc&KVT>;4/IE,BI@_PdF/TOP?P(,J\\WY#USgIg1;g
A\8=<2?AcXOb6#4cPc(?GTLJYfL/R(]K[.0X&OQ5?=^@&&:]<F8=GfI^0>G:U&YC
N6&2)^Q1:<+I]4b_J_RDa.#GW?WR\Y#X574&^.M=>I6ABS4&/UHd295;\Q/fN?W,
=/[)P@J\<:^8]FOV7C^0<F7eBL[P/(fc6_ScdESM6E/AR+Z.[?)NFbZZYf[fU+\0
^+Ma+[K#CI^RU<IQcLSR7H#<Z=?MXe\A;_GE]UPX<,#2ZY.W/@GPYT5E,e<@AL00
YZ=Y@^UZGQ7a7K-;2e#YN_1CZJgeCADa;B41#XMaBO+[O/+VRSa2&9FG0Bf5I6Y+
Pd65dcUSTVTLFdDAT.8[O>B3^6)RW/B:7e#G/W=Q@/a\5<(3aRZXfd2E&gHF\81T
PR)7^;Ae1K@1W-aa_VZQQRe7.MOVG4&.bOX,4VCdDbHLgN7A8;WBG;2a)FXGW8X_
[b#.H7N#_BLDKCTJ>TXO/d_#\N&YLP4O_(G]&S&Q@c+85a?ZBCS4N/fa@DH.Q+cH
)DX/7UcW[:B3Z2+T4PY3d5\J@CZ<<1<9[TK?\=F^2W<GfM0@(/<),@1=f6CK^b5N
cb9,gU3T_^KJ+UCRTHab:4,[UJ.0R5TGAffK[fg)@cea_2\VL-FYU^2Y1N1\fK3V
Yg2EPgB1V?[-RD,)+E#D9_c<(LM?K,=H9D^eeI1V72ZZ487E55)Q/R([]2>,?:P.
H@S(V;F_,O+VL61W1EUA[0gZebf[+(7WcT#YQa)O>7X,7@DZ5CGX0&.R(Q48T&Od
X8PcGHTbd/<,#J8]a]S;(]eR<FH[.Fa5I8_._[621eVMcf8M1[@(W@:(7X4;dYTS
e3L90_B&EUQaG(C1#FfPM+/Z7c@Q>=a[^KR1_C]0E^[H>g)C,]D^8ePfb,aC/OGB
R8cQ>C7TWNKa[\?>f]2WU&Y/];W._.8I^aET1<=,E7ebHN194D5^=UE\T^L;/:;G
PJ,.]#-](>-g4b#HTg.T5RQT191T+Qa7VHOdKMJ]VPESF_HILN<9?&;W,/EYX5Jc
N8??O6@)GRTO&C3//QPRGI0Q-^+YK,?.^.Rg,A[L4B0?5fbY--&_OeVVC(OW6Rd&
4PJ_2B[gML264EB4Q=DR@KIY19YI3N:fHD@<=:#2-WGGCZ?OQ&W(/_(-K?:I@&WJ
bC\=0e^=NS7:8A@QXJLXNTQU=#1[a5/CbS+/:LdAC/S:08.,^8Uc5egU.SG,W1B)
VX=\OO<-/H.M:Y^EIc/9MIT4be7432+R@_gGD.Tb@a](BDA>dIbUc]:US+BY?ZI(
LX@gD()V1fa\XJ+E.IbU^K>+ND^)V([BR69bdD>>C1JC^YgF&+C6HBDe@QbgX6Q0
5BeYe6-Fb<V&e8C@RIHMg.R3/U9UAG_5NJSP8a6M+1SYY))I3)A9-8O1bPIE/E_g
BAH5KUd5cc;=N]@cIb_b/2Td>I:Ye&O_/(_/#Kc6X)MZ?OaS]1TFJ18EY(b(H??^
&+C#NC5#/@DfD:5QFF7[c2e#FCZ=\GJKTS<O=DcDJW:M3Mg\cQB/1I9^,8R;f0#O
7LOYYC_<.=4M_cJaG##IEe@eb8ENVR6<PKR<[C+f:.@I_36]dPV9:NI)#P4\^4b1
2U7I4LI5D;W(DU]eW2::f?#;e4+.R&T6T[Y&\P\DJc\[69&S<KJ2(QFPb]8+?<^D
LS7\+f0dG]DV2KW_UW.S09&0GeOBU.[1_\J:T+\X9>I,-6AL07([K?Vd:A3GEMBY
A<1?E4:ZG(Y_HMT0a50VT7QC7GOQL>(dF>:J[?FDU]MQSP0F<@9CD:82)1cgfLM8
_ZG(+3=AVL:,d9<b0U_])eXeFeB2CB29[9\@^V:K\8(VJ[5E5C+,31PO\^eB]I(.
Q#2078:VPX960XaS_7\eTe7\_3eH)gE3D3P0E#C]@E-T\R;YEG1<4W)RI1b]Pc.\
;A_A&B#?664@(9A(GfU#Wg>#gV8<S;Og@(B?857<>VAMV8Ig<e&:-2P+,S+#G:\7
\X5:[,eT,8J#O)QTaJC3F:IN1MVV.aA\+X4DN#JUa;5N@KRL/X#;[@DU@=CGQMU3
Lf2(f2:aZ=76NW5F6Q;34MFLB5g..)NI<.RZMM-G;c6.YG)FCcWaC(;+c(XV)N8<
H4/)U77[J@R9Vc;J_LXeI/(77;aJU/aKG;G+<X<7e4a);d),.H6.LU@O)2.GL>M\
G>IYUG&C?C/.>a;,>II?M5eRHCCa]QI>FQ82e9YOHBWV;]W1D6BV2Q<HL\5,GVI8
f(6,7bg1W-a2^(R@Ha&L2&>a::F98R-63TJN<KD/>OUW^fGdJQ9aW1PTNHS8#dP2
\LP()02E)/NYT11E[SC?-gaa4OB0?7aGE0N?VU#bLaC]EG)5@1_K:H)4\M3/FT3\
dXADR5?M>1)6,Sg:-;a_)?e1.WKCfAOD(29LbED/)Q\\5C.E#7T]X+.R-eU)QfZb
>LZ\_\K;JXSf(G?4.X5:J.]7GS(EV&Xg>+VM67db\\(/4&F/2c&FYSSEVa<])HA-
HW_2E/Nf9UbfNU]_a+GaB3(:X=b62c9LW[<3>\6A6,OW@;7\2MI@]TC7GORXS:-=
GeS5;d\]@P,?Ud_LP:dOW:C&RM^<GAF^(,=gPdJYUNZ1\S]S+?+N3&E=3[_C=DDZ
bQb;7HT9cA@3N(9)a8HXK2-@,O+7SVR(19Ma;J29b]6#CdUZCQW<[(U^+L_=dR\Y
J)O.QX>[0L7&1+GEDKg9aB3],I\H<ZOEEgQWdb[K>-?8IT/HebBcOJ08VP(MO1eA
CZBc;WSMaY6eA6RCN6&#:IaRAY8g9;a89>fEVNe-DIS3CO7MJ.fVVfAL\EB@4V2<
+,X@M9^dH=Ab10-OENfL[JSGPc5+EC^KX3>7OU)_>2T@3ZV\.^:SG_]1+K:FK=IB
[20YF0])cAH0V<e27?B9H[190CCRFUCe[]RYBM1YZ8SFT>F>Y075&I;9NZ:.eEH3
,4P7U:X.1c9/]-.6aeK.&@f?_?e75)5OVDfd+PHE8;4&<+gB94>.M@FP7b0J)C59
CPBM;Dc9^O8L;&[<5EK8gNOY?4[P5/</D7Z:#G0IQ#cg=aI74O.J&D=-AId\=IcB
L3Ff0Sg9]EEBZ:c3ZX(TQHP_K7X_Aa5(V?]WVcS)1.-OH6+CPF/Ib&V+)>@]UM1H
2-4S(A47/DBD,A)G\g.K@VX42B<^__cBV-R6f4HD@g/Vd#ISY+^G+MY?Xf.gA+HR
aR8?QGOUZL[3=.D,4K4;9H&>+a(Ma(BP/Y<W]+-7ZK-3aNXBWJb^AF/VE,I>UBA&
UX-M38f+6RL.4EZ0f)#aW0Z:b@.IRUQA@4g3&@@YV\]4<&@S5KLPEYZMFCPLAZ+C
\7KVPQ\]1/1Z(ZL@,e=DAd4]8^/W)e@/Ne+4#+G(O7#J1;PWWU0[.W2<5K.KV]0\
460_eC.5C&9&:G&fC9ZB1d9N>,\U_62W(D2He7Z\eX)=/,2OQXB1?a]Xb+A,#VXf
/a-33^b:+CQ>PJO3BW+149?]@,(b&=2OfS>gWeQE^O[M+9F=2K);0ME#;^3VFMb1
DG-g8ZO9H[VXSD:2V#P8HVTRWb[L,D9>9\UPb[&Wfb)R.B;6Q1;18CeYba836\:9
43,[FeOJZZZ<ScNCNCe:-YeCLZ+)C_3XOL26R?+_\Y5ZPTM+7X5deUB8NR>D@4RN
Q)&\SYb^7DZeIP2\JFa\D1)C9>=QfY/LC7KJYg@8Z/C-IJ:fI344_9+Z/+gg/T2&
Qc7I[T0d]T\6=WMA)04PJWe\R3&4:/1<7W6eUX0DZ(J9VIcG79d6_,?K[e;da44)
6)V<H)?5@)L>(-Xg_;FR-4ec.C3TG(1HC77WW1Ka1(?3@\<6Gb4C[IZNY[&&F]DB
?f^AfASf;F1[T^JIK:1<5JJB(LB9I<0WdFSA/9cRB0^@0_;cL^O>g[)1=SG.<7+;
bIYcfLFade]-f)X;,=8:,Ad>Kf#[A[4Ne1[4H9ED:2^0BNc4)ZSDV,fRSVGQE]f6
MOH>)2=69a]WA9C;IZd5>]C_C17BA3K2DDefZMV,9(=[U_-YB4-P,NCG;-dSP\L)
+K3eVOeR=([L@G8dWP(S<#1BeAZHO@>TE7F<HOdX-)PAN9.c^PG5OY8-HI8#EC13
KgdB#\.WaL0c/:A>B]eJQ\FfGPXGU5&<<ScK^Z_=)A)RN8Y<[cQPa]M;UQ(OJ;1S
:]g.X2@\T\:=FAaP)AB0J-&C+f2]YJ;I)f8N<\BZ]E;J2MTd.F#H[IEdR;c[TcJ?
3MPY>]PW#\W9K\7>#\PSVUTHfVOA<\A,PA+8NF]PZRNUT:9(-5.e[&EdL$
`endprotected


`endif // GUARD_SVT_DATA_ITER_SV
