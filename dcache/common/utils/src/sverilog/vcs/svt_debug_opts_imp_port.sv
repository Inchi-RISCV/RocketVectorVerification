//=======================================================================
// COPYRIGHT (C) 2015-2016 SYNOPSYS INC.
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

`ifndef GUARD_SVT_DEBUG_OPTS_IMP_PORT_SV
`define GUARD_SVT_DEBUG_OPTS_IMP_PORT_SV

// =============================================================================
// This file defines ports which are used to help intercept and record sequence
// items as they are going through a publicly accessible component port.
// =============================================================================

/**
 * Macro used to create simple imp ports. Used when there is just one imp port of
 * the given type on a component and suffixes are not necessary.
 */
`define SVT_DEBUG_OPTS_IMP_PORT(PTYPE,T,IMP) \
  svt_debug_opts_``PTYPE``_imp_port#(T, IMP, `SVT_XVM(PTYPE``_imp)#(T, IMP))

/**
 * Macro used to create imp ports for exports with suffixes. Used when there are multiple
 * imp ports of the same type on a component and the suffix is used to differentiate them.
 */
`define SVT_DEBUG_OPTS_IMP_PORT_SFX(PTYPE,SFX,T,IMP) \
  svt_debug_opts_``PTYPE``_imp_port#(T, IMP, `SVT_XVM(PTYPE``_imp``SFX)#(T, IMP))

/**
 * Macro used to define the common fields in the imp port intercept objects.
 */
`define SVT_DEBUG_OPTS_IMP_PORT_INTERCEPT_DECL(PTYPE,IMP,ETYPE) \
  /** Object used to intercept and log sequence items going through the report when enabled. */ \
  local svt_debug_opts_intercept_``PTYPE#(T,IMP,ETYPE) m_intercept;

`protected
_aPSED;c9>gO4/E/=HHMB)4E>[3Uf/GM@EXS[US8SOec?OQ>G;E]7)7#Q1VAgVWL
&)D-de6]8C-aAA^eAXV:bD8<fR..e4W<FK5]K-a^<Se<T<c@V:TM9KA]WZ5.gR8a
HLO727aQg+87aVULHI:A-JPJQe5aaHQFgC_WS7+JZ&aO;OD&=[L6dQ.Ya<V^>P64
P-NL=_F-@=5::eRD?+ZO[[P8Q5X0864(EHb<?8VcWA98K^bCBW>3-]5JC]Mgf5eT
f4<GF4(_22KU8_=2Y(=UA1K-cSIE6\2H@;T]b0(ND>QeD+W:4WUPe3]LB3N-[PKK
f],ZWH003A)gYRU\UZAAK?VWK+VVUaL39$
`endprotected


class svt_debug_opts_blocking_put_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(blocking_put_port)#(T);
`protected
<.bdAXDgZ)geO/[O[>B^+_&Y@JEc:eH1@]Q#:5?OKYKDZSTefA_S2)dQQ9:+501,
;C+FTe>:+[fE,]6T)J>(0<.)+Hd/=EZ;\)fLBPN1Z3cU0:+6RE1L=@AUd;+7A5WF
5GKL^UVBP/Z:2,WW),bf/M+K&;QK1_DB5_AYbK4^SSN//9PA27AA+076C?P)-CD,
I=3WVQ77eF]GS4U5\XPF/(+K3$
`endprotected

endclass

/** This class extends the nonblocking_put port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_nonblocking_put_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(nonblocking_put_port)#(T);
`protected
^.?ca+:+T\,Rg[P(+BAIVJ_b?;LWJ16S([Gf8]N/1aS-03#HaI.W5)fB)+@[ALaR
JgQ##WF3fe2@U7#Z5)aee(ZP)_Mee<E:GE7,7d08?a9bC>CBPSC8Se_d6Wg&SI(#
CAJXd&aGDb7,;M;&E4\+9TZ/SD&;3[7Tg=6;BASA2#[=>AO5E8Ya9f;<\NF/L>KS
401/1/Gcg.:b<,&SB7]Q9DZ/6$
`endprotected

endclass

/** This class extends the put port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_put_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(put_port)#(T);
`protected
RHN\VT=^/O6#:^dEfd[cJU43&,L=F^N<^8PSg&3L(TN7+1\OO&b=2)K-9PH#4K4,
7>bJ[;W7R7NPSFZf>2-4QNQVIAf-C]00dVWKFg[+Q,@ENZe?QLbg6Ae1SG1cI?NM
?]/Kb1,AVa/d?;5CUUZ?))<J7QB)+LEf-dbOB?\/gP4NVUVaf=fK^9PEcS#7YD,U
bIDX>X9#f8Rd*$
`endprotected

endclass

/** This class extends the blocking_get port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_blocking_get_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(blocking_get_port)#(T);
`protected
&7=QL/SD[D/\-)?(bM&Q\=cF=A53)L?V.Qg5+IJA-LQQAI.E;NWW5)N@543BI\H<
(ZVB0]>bK>BgR#D8PKa4?V/<^MfU+)Jc(Bb?1T-9<\A++cNO4A\BX4<P^/6=J+SA
cZ\b-7dR7F#fdOMg[-g5;HZ#f0WAJ+=.d@F::PQUXN.:<eV8S\(D3\;3Z6+R\ZQ<
\J6&QeOMa(493Z5#^]<E[#Z#3$
`endprotected

endclass

/** This class extends the nonblocking_get port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_nonblocking_get_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(nonblocking_get_port)#(T);
`protected
K+)MCU3MF7G]5@K>8X0LL?9\0,PA7-ZfeCf2)]ZRQ0Q/;M+[cESD.))LXQXSU5/d
Z7eJ^62\7M)O0J0IcO,Z^Jc3I.6[EQHHZ-8aNcWeLDA\(:cN;)cfM>W>IT0:(YT8
=a529(:I\_BW@C5H+_U2C2W,8OLgC7-:@-fFQ1D&e81[b@V=Ueb>_[b)?@/g=ab(
YNfEgbb&#^AU3&UF)E^PCXW,6$
`endprotected

endclass

/** This class extends the get port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_get_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(get_port)#(T);
`protected
^)=Q?Z3^0+5<5KF./4O0aT6O>QU7IQ)7]5Rgg_^-b[0:LDTYI9]S3)3MK.>3A6&A
G^X;,=MZFQN7)YUY+QA692=?9=-Y3QSP;2c4F8AfU;0ed+N&=(f(L2UD-#-#S00d
CSG<;N1M0+GYHVd>S0(-dB.:WARV?aU86g+2,7//3Bc#NO@bZITA-.[BgD0KNEI3
-F6H;6>edfcY*$
`endprotected

endclass

/** This class extends the blocking_peek port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_blocking_peek_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(blocking_peek_port)#(T);
`protected
\[.OYd#a8dEW4:@NE>3DENJU[&7=_17G7W<]caJ^_:M[8Q75]C6D()eWSW;b-4#D
dDeJ:D80E/<HBa(S;EF(@JgE[A&fS&+3/5F[FK@Gb>gd&62eI:F;eV.L=FBN&:;Y
-=Zb_A6@S(B,S6[9=8-5c>64H3:a-J<+E<?3SC1=7OQ0#.;\8DN3,=1C<\;&9[eb
5FXLP6_:aKE6<6[M&9;4c>644$
`endprotected

endclass

/** This class extends the nonblocking_peek port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_nonblocking_peek_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(nonblocking_peek_port)#(T);
`protected
[c::^8+?4c45(ISV,@e,Z#<EgVW0<,a.XZQ@:T\8Y/:RbS[21O514)-S6JEO.M=b
P;AOU/0_/Qc+EIQ+5\@J-?I.L7c(++FQ#OX_B&[fMWQVZ<F>/eH\R:f4VO&UGf#e
HH;LSHRUF-AA1KC,U#)=^-6;)+SH;,4=RLCK<ROf8>c&-6Da#]9:BM)5dK4-;fV^
D)F(TKgP+g^;DP29CJf8N&6;7$
`endprotected

endclass

/** This class extends the peek port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_peek_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(peek_port)#(T);
`protected
XfM-VcXSID>37NLe0]TRDgDJ]4-/#3#4e]AQ.EffG>\_#K?P:0D5-)bMBQW8Q:UU
8:QMQ14Z+P/DL#03IB]/,OF7DUPH+Te6XB/C)&BLVH[cVeJ1ge:C3S>G1GIK58Id
=H:)E..3\#+#,<aSQCSL_4:I_+C:N+G4+E8@5TZ&S<4DS(A,4d4;YRe;O1MI18D,
WK_aU.MaXL7#+$
`endprotected

endclass

/** This class extends the blocking_get_peek port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_blocking_get_peek_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(blocking_get_peek_port)#(T);
`protected
R9BX4dFaC??&fV=g+TTe+TS,,[4ARZ^;Q>G&1OYVV;;MFVCEOUE3,);b7WeLJSQ7
#WDXY_e@Ob9b)N39aLN(9U:+C-)_&EPd<4#OcL]E[8YG(dWM]2_D/W]adII<XDUO
Hg,e<B\R^Ub[O>Dd-^@E7<]>H0TK2\(Z&GRM&5<Q?Xg1DbP)65V4;/?O;[\WdUJY
<DG5-_&=2]0LP9#L635^G;]>8$
`endprotected

endclass

/** This class extends the nonblocking_get_peek port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_nonblocking_get_peek_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(nonblocking_get_peek_port)#(T);
`protected
b6\SC(J7R82W=D1I_2D-JYHL^C50+gcBe_Q@bD<(;T&86?49PC4_1)+:\M6VMSf5
2-_?T/&H2/ZA;I#_XAU-CK3b_NVYa<^C\JJ\2W_C;fSEW2CT9+0?WW1f#ad<2B0\
#MRNDO6,ZM)#5GM5YZ2]/L#;-CH-Z5Y^_N78.Md16B(ZcZ.(=(VeD_I^EgXV(#PV
=D\TbOZb#N2(<2X);@?DQA]</ZW1>#_^;$
`endprotected

endclass

/** This class extends the get_peek port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_get_peek_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(get_peek_port)#(T);
`protected
EC1BR[.+P;Le51T9W1?<aJEHD1Z/^:_2OKE?[80<4E:YJ96F/ec:-)O(L?W?dS9\
9Rbe+>a;NG-g57NA\#J&Y0G.;?LU^^5IL[VWbQ4.AAN]a&09DPfF9UM#6K0<BBe@
D#@JcM8Vb@=OgRYHO-TTT]AdUL5:X=5;HL)dgY+d(AAIcH_=eZQTIHY/b<f._^Ja
AV/WF)\PV9RO/$
`endprotected

endclass

/** This class extends the analysis port, providing support for intercepting and logging sequence items. */
class svt_debug_opts_analysis_imp_port#(type T=int, type IMP=int, type ETYPE=int) extends `SVT_XVM(analysis_port)#(T);
`protected
8feD=QZ4aT8bTZF&7/c?J\Z-AacKC5&1J5B_2L,1D?9QJ09V6Cd@+)UbK;\^dROP
>9M3#^ENBJ>F;&IZJaSXUY/g11L)01,\>:3)3-4&;\2WX>LgKfGcWbWd6AEQ31bM
Ec\)M\Gg10=KP3W:D<HU&fgLS?<;I\]Y((3=<Q]dKDLZ>7T2VCK4#N?KU-efABG=
U1F?VdDKI>2A#e>.gTA\.a4AW>RXTE3L(&@^+)P29-)7beDZ_@A=BHbNPB[3H&8K
H:Z@?ZRgf^GQ44N<>1fJd2Q.<[LS0_ZH2#+F^H9E8UW#=4XT:)3A=.X4CQR:HF_7
cR#[O>2C/0f++;A6(ff2<BL&WQ:>Q.-:O@6VS7#^8eT#F$
`endprotected

endclass

`endif // GUARD_SVT_DEBUG_OPTS_IMP_PORT_SV
