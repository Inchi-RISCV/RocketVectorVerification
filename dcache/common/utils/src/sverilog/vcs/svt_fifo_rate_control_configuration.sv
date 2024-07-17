//=======================================================================
// COPYRIGHT (C) 2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_FIFO_RATE_CONTROL_CONFIGURATION_SV
`define GUARD_SVT_FIFO_RATE_CONTROL_CONFIGURATION_SV
`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_defines)
// =============================================================================
/**
 * This FIFO rate control configuration class encapsulates the configuration information for
 * the rate control parameters modeled in a FIFO.
 */
class svt_fifo_rate_control_configuration extends svt_configuration;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************
  typedef enum bit {
    FIFO_EMPTY_ON_START = `SVT_FIFO_EMPTY_ON_START,
    FIFO_FULL_ON_START = `SVT_FIFO_FULL_ON_START 
  } fifo_start_up_level_enum;

  typedef enum bit {
    WRITE_TYPE_FIFO = `SVT_FIFO_WRITE,
    READ_TYPE_FIFO = `SVT_FIFO_READ
  } fifo_type_enum;

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************
  /**
   * The sequence number of the group in the traffic profile corresponding to this configuration
   */
  int group_seq_number;

  /**
   * The name of the group in the traffic profile corresponding to this configuration
   */
  string group_name;

  /**
   * The full name of the sequencer to which this configuration applies 
   */
  string seqr_full_name;

  /**
   * Indicates if this is a FIFO for read type transactions or a FIFO
   * for WRITE type transactions
   */
  rand fifo_type_enum fifo_type = WRITE_TYPE_FIFO;

  //----------------------------------------------------------------------------
  /** Randomizable variables - Dynamic. */
  // ---------------------------------------------------------------------------
  /** 
   * The rate in bytes/cycle of the FIFO into which data from READ
   * transactions is dumped or data for WRITE transactions is taken. 
   */
  rand int rate = `SVT_FIFO_MAX_RATE;

  /** 
   * The full level in bytes of the READ FIFO into which data from READ transactions
   * is dumped or the WRITE FIFO from which data for WRITE transactions is taken.
   */
  rand int full_level = `SVT_FIFO_MAX_FULL_LEVEL;

  /**
   * Indicates if the start up level of the FIFO is empty or full
   */
  rand fifo_start_up_level_enum start_up_level = FIFO_EMPTY_ON_START;

  // ****************************************************************************
  // Constraints
  // ****************************************************************************
  constraint valid_ranges {
    rate > 0; 
    full_level > 0;
  }

  constraint reasonable_rate { 
    rate <= `SVT_FIFO_MAX_RATE;  
  }

  constraint reasonable_full_level { 
    full_level <= `SVT_FIFO_MAX_FULL_LEVEL;
  }
  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_fifo_rate_control_configuration)
`endif
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate argument
   * values to the <b>vmm_data</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   *
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(vmm_log log = null, string suite_name="");
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name of the configuration
   *
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(string name = "svt_fifo_rate_control_configuration", string suite_name="");
`endif // !`ifdef SVT_VMM_TECHNOLOGY
   

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
`ifndef __SVDOC__
  `svt_data_member_begin(svt_fifo_rate_control_configuration)
  `svt_data_member_end(svt_fifo_rate_control_configuration)
`endif

  //----------------------------------------------------------------------------
  /**
   * Method to turn static config param randomization on/off as a block.
   */
  extern virtual function int static_rand_mode(bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Method to turn reasonable constraints on/off as a block.
   */
  extern virtual function int reasonable_constraint_mode (bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object used for logging.
   */
  extern function string get_mcd_class_name();

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_static_data ( `SVT_DATA_BASE_TYPE to );

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_dynamic_data ( `SVT_DATA_BASE_TYPE to );

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Compares the object with to. Differences are placed in diff. Only
   * supported kind values are -1 and `SVT_DATA_TYPE::COMPLETE. Both values result
   * in a COMPLETE compare.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in comparisons of the non-static
   * data members. All other kind values result in a return value of 1.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);
`else // !`ifdef SVT_VMM_TECHNOLOGY
   // ---------------------------------------------------------------------------
  /**
   * Compares the object with rhs..
   *
   * @param rhs Object to be compared against.
   * @param comparer TBD
   */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);

`endif //  `ifdef SVT_VMM_TECHNOLOGY

  //----------------------------------------------------------------------------
  /**
   * Checks to see that the data field values are valid, focusing mainly on
   * checking/enforcing valid_ranges constraint. Only supported kind values are -1 and
   * `SVT_DATA_TYPE::COMPLETE. Both values result in the same check of the fields.
   */
  extern function bit do_is_valid(bit silent = 1, int kind = RELEVANT);

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation. Only supports
   * COMPLETE pack so kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset. Only supports COMPLETE
   * pack so kind must be `SVT_DATA_TYPE::COMPLETE.
   *
   * @param bytes Buffer that will contain the packed bytes at the end of the operation.
   * @param offset Offset into bytes where the packing is to begin.
   * @param kind This int indicates the type of byte_pack being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * fields being packed and the return of an integer indicating the number of
   * packed bytes. All other kind values result in no change to the buffer contents, and a
   * return value of 0.
   */
  extern virtual function int unsigned do_byte_pack(ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Unpacks the object from the bytes buffer, beginning at offset. Only supports COMPLETE
   * unpack so kind must be `SVT_DATA_TYPE::COMPLETE.
   *
   * @param bytes Buffer containing the bytes to be unpacked.
   * @param offset Offset into bytes where the unpacking is to begin.
   * @param len Number of bytes to be unpacked.
   * @param kind This int indicates the type of byte_unpack being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * fields being unpacked and the return of an integer indicating the number of
   * unpacked bytes. All other kind values result in no change to the buffer contents,
   * and a return value of 0.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);
`endif //  `ifdef SVT_VMM_TECHNOLOGY
   

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>read</i> access to public data members of this class.
   */
  extern virtual function bit get_prop_val(string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>write</i> access to public data members of this class.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);

  // ---------------------------------------------------------------------------
  /**
   * Simple utility used to convert string property value representation into its
   * equivalent 'bit [1023:0]' property value representation. Extended to support
   * encoding of enum values.
   *
   * @param prop_name The name of the property being encoded.
   * @param prop_val_string The string describing the value to be encoded.
   * @param prop_val The bit vector encoding of prop_val_string.
   * @param typ Optional field type used to help in the encode effort. 
   *
   * @return The enum value corresponding to the desc.
   */
  extern virtual function bit encode_prop_val( string prop_name,
                                               string prop_val_string,
                                               ref bit [1023:0] prop_val,
                                               input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * Simple utility used to convert 'bit [1023:0]' property value representation
   * into its equivalent string property value representation. Extended to support
   * decoding of enum values.
   *
   * @param prop_name The name of the property being encoded.
   * @param prop_val_string The string describing the value to be encoded.
   * @param prop_val The bit vector encoding of prop_val_string.
   * @param typ Optional field type used to help in the encode effort. 
   *
   * @return The enum value corresponding to the desc.
   */
  extern virtual function bit decode_prop_val( string prop_name,
                                               bit [1023:0] prop_val,
                                               ref string prop_val_string,
                                               input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: This method allocates a pattern containing svt_pattern_data
   * instances for all of the primitive data fields in the object. The
   * svt_pattern_data::name is set to the corresponding field name, the
   * svt_pattern_data::value is set to 0.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern do_allocate_pattern();

  // ---------------------------------------------------------------------------
endclass:svt_fifo_rate_control_configuration


`protected
\7#=5P&2@9eeJgg]SU[bE6T;Y9)1=;62-HG3,g@&X(PM^PI\E<eP4)7aEgdS?b3?
G>DSYG0IQV8g02Y&(+17NgN>2W_@(Jg\8^=6B/G165P,91#bGB^cR-BaK1ZVWXV6
^:RMB34+CL91@8J;B]80)#51?)VEI+f:e&ZP9P^22faEY@2KL@b_;eO.;fC>W[:+
-])1HL5^/_9A,WJ2I>VCX+0g<]ZOb&dOKf,B(9]\(K+NP0BV.=Z\G&/UbU4A#ZH,
RPWHED\76Le(Z/RF-9CX8eV>1&YK;&aZX5VH/U</2/-(Nb\;0A,B<D(Iag6>;fL1
GbWH.aB<GETJ.Q-23>,BS_4a<2C-30Y_7/MHI./A;U7KL2RGF=G<T/#]1eQ(NN[[
FK5C-G.g^Of:JUc#Dc&:_3B(0W0gS3Of6.K5e<EbfA1?Fe4CYO,N#@e7a^-<LVXY
M2A\XG:BA8U[JYFWIM[f^/3DfQH)bUa?MRA2d=MfF]>5ee.e;>a6^?/3-=O0-O1W
\,QK62:g1dZ?J5SH;08E<@J9SI;Lba?QEbgfN:0A47N?24gTVb5HYTWa/RYG]=-P
dFZAH2JfQ4\.?36L_:f>I9#MTaD9a/;d_,.<OYB7E8HIY>.\O:Vf48(,=0Q3\eb\
=K;<:aYDL6.DOQ^UAAa_Y-#M6$
`endprotected


//svt_vcs_lic_vip_protect
`protected
2W)+H8,Z,>S-UR4D&T5GXA53H>BCW8KR?0KON[DY22+L\G;_H6cR,(0>^L[JV,4V
cPQ8<MYN3L_(3#ED,K744?TR7-cTLFPJU=K_XCV]J96KeVFY3FTS-79WG@E-ZCQ_
DFHQBV\A;eGTLId\;Q0#:H,28]T7:^TV<=d?PVd(eA5J[<D.cYV&A&_\[.\O=(-R
F\f6?-+=cX0[KC7fQPLV72)L&[5d&_3Y(:T2AV_3O/7D1Z0Q)&=^#?CaIH^;@2?R
,DRVN<GgL93+,c0-CdE&F#_fO;YG+QK68a9EHVE9Hf.,[PJ@;cNa7?-J8a)fgN-F
9Rb[X>Z-FJ\5.Z>A._W(=,JKPXW#XU&gB5+\:g0S#,X5GJ--UU8B&T0IB8XW6cPA
0X.FHQA(NcU9QQ[#VT/)Q):+SQYC?,P?@C&cecXZ/g6\KAU1Q^N2<2N9-.K[C9Y7
#c&ZN0#1FM+&##JU3/ANG#4JMZd1(_1=4C;NOBY3KeQYQEP+3DX>?TXPQZ?7-DOd
/Z5U@YDSCb9>8(S^WM7dN?4]<f6VNF6PL9aNaH[IJWQ4NHYCUNH(H+5C6ZN7ffE4
U_d;_FSVFK&B^0H(D)@A:RJTS;B#&7VLP?3M>:1Q+;cB:1bgIeKGV[:WA6M=AB(,
S&HgBfa_B9:EM:>I>=Z5W#_VVO:c4cN^STH]-0D+ZNfK^Na/CccUZVcD/P38CBF=
;3NS)X57E;[]P=X,9M>\#_bf..AS@HXAY\C8>3a-,b4aJ3L(1.G68,M@)U>:2-?1
CIH[FMBfDCYGYURYHFg/#V<F=TYGfH8d3@gF@fZFABe5Nc-Q<V@ZYd2RIOAVX1Mb
-]ac8>1;(Q7YG=#BDa_;(&aXLbS\dLVQa^R>K8^FZ@=YGG10VcUVPK5d4(]ER5>c
_-.?D-:gY9566:cK;@?BV1]IWEDKZMd[9MOH6A(eaLD8M?H8d3OEL@8+&O,/4VTC
ef,;SKMODER4,Q[eL(f;G0-R9Q-fM7P=M^GE1&O\S>NE90JBOKX/;[ZT22.O.C,M
^1U>3S.g&]ccgK.bb?=V>+B;G<AIFX??U?_\Q#WVXe^^e]@BRD^@E:c^?</YM-)8
KHQd\1,_N9]gLZ)9DIb_QO[J1CY]4>L)?YL0<IZ72VJP?D&M)@=GQJ(<>@++&QGS
#-U6EUEf,CV&>OD;BR-N8D\PS]P?NQ1.=S>?8@HV<I(\K_Q(bd8/<2f^5:\/b2O0
,7XQJaX+aTLNb?OZUa76;IM7bf(FO-3;56E)YFJ<@bH2:H(R#M5cVgV,<P+(7S.H
F:)AHT.22B/ODRQB2BZ54O\7864<c84\0gWY#FC9A1.Vbd;:1^KE1^ZCEFU64J0c
KXIH>]^Q9/:,<FRE]_G.a&Qbb0F<2e585;S_6]>=ZJ:Aa&<VXQ2Sgf+dY.fQXT)2
L8TI&?CgM>TY_H\d7:2<&MJXH77IUg-JF1ERgE5?QeD^&C/IE>:8M1RQ>)OA<?ED
N+F1SeGUULC@LFI]<g#dV4Ta30EgJWJR;^;5[M^V#_O8g<#bQPY0(>J90X7bEL-1
)@RgJTMT5H_T7(1X6^G1T+T8dNWBf4:dMZ;Jge-4[#R5]aCP;[T&#<<_OP70]UFX
^c>EB?Sg^F\P4DgN0::WB0gEBC-Q-,0YEW?TO5OFLUbC2?.f.I[/SG90&dA+ZNT)
/.5L]AM.&)0)\D:?18)I#.d;BE:I<E8\cQ-Wc77#(7=>BYBX8@:<P4A[5Q9\@]cR
-^<::Fd\/?.2e9ZcB,0DbY4R2DFQ4eVE_^R9T:eH\EK10Y8WRb)gW1NSAA&_D=7X
FC5U=;ECH96\XJ_Y48[Q&WEF6MgJPPJRdSYZ\5#g+6=H&YK;B<N;V/QH9=UYVRcC
6K>97Z8LA&a>4#3O6S>b[O#_bBK\5(PQ2)/(L:A-U:3A)A]0073,/>+D/?[NX57^
5CVIU;E9?.M:M8#7X)Tbe9=PH3[0O0[LAf6,)]@)YD5B<d/+&:eJcMGU4QRY7SJB
,EebR[7\)]2L_Z8X4QSSYOS,H3>5S[V[_+<UY#AH)D:]27&?LdJ4MW?KNUQ)dNfP
FVM=A1e#cc(e1HFO:(1f30W?IO&_,LF-#G^aQXbLZff,\=f,;_f@4JdWE(g;2]AV
\U)DeFR8BF#@>3-<ARE(,4DCKgf\@C^c6B0NHfAHDMA@A55QR;>DUG_/&AQc\=aK
FHd-D-_R+I:/E:_7++@)CEO-EUA=BN=RD61PO#(@T,0;Ha0TNV65<ALcDTOC/CM<
^&F]R8>>1-?=/b#NKMY@#T\&Me=C7]CZ+4/bdO17[RL_O)<9&L0Xe2+=?0K37:&=
7O=0<M6VW5(.B/U3/Fc0#Z9)UJNb:A6f1-2K2.aCT/cDD],6Jb;#R@;4C;,C?:\P
dO.g?DRJ27N)g_^8XZ8W3&M8D\X#[MT)G4efGbfW0H8,XZa(&H7K09]&fM&OV<M=
aQQdb;/4GQ>Z#_Pg>AJ>a0I8O:#TKN-TH<B^9[8FV6U-U]=8Za15<0/H)5&\OSUL
-YcZ4G9(c<d=U?U#cRGQ(<[g8&NVeNGSH>],FE[cg=>>[;.L3VG0YZRdGJOKX8DE
3<BC:]HgHb[]M-Q_gL2MD,:a0O<9KFF6-b)Nb&EGU9FDHCL24Le:HOQW6aA<]]J=
GM>bL)5G6(-@3NTf=egQ:NNQf@N:DB=QB44CEW03V8I9);<C&M,0FWPQ;CYGTXDN
bY2f-NaHVHH5<=/GQd)QV8C^BdRcW)UJG-\Agg@BE@4_?MCfWWU29-/R.\gGR6cZ
:&Na>_R4JWbC])#[cN@c&>_f03]C<@C<H.SQ+V/EFGIW@>\B]AR1YT#bU7?eX9#+
@SL>+@P[+MU4)+<1)_NLER-0SWU1[],8&/+?7^KWFXNf@DPBU8A+\0:LZfMSSebF
eER](FFf#Ne[_:9:8M6.MZA]\L)82(T@B_df5JMaEb<._O9?PSYIaXb?73P.7?#F
XT#.;G[Fg?6A7LN1?HJN;9Ug8>JG.O299[,e>B5aS;b[F<3\g5@^R9O2(b2&3f@@
5(Me1@(8]OQ4MZU_6[?R?e/YS^HF01J-D#3>a_-.QCeYD1fWgI(L5)/cK4fBG,8M
?NRAKX.8ZEW^b]eK7^STIa;\]BaN>[_-CM-0dR<(aD]:_SSZ4<;b/I[3f,1>EPM\
8H3BQ<bO/c7?-LB^UNNXZ8BLWN><QDCHGGHZB@]Mc4d2PTP<PJ,[d?RJIKQb:298
eEJ?HeU)f08,gddXTFI7V[)b/Lfd>X]9<e:PSVL&L6XFVR\&R;d--]Bdg3)PU\J>
.gW9Q0KTcH+g:Df8V8Q/>[<O&^aIN3^,27#GcW.L23K8e+/<b[+Ug-ULKRdfL9KN
Z@-0dT#?E@J@++@RI\L3BF47?L6;)cX-LKXd7[GN6^3;2(::gFMD-D(-CeF)4JGM
6SG+HN#fB61d0=USOME,[F,T+3PEOM+LRV2L3F))B4G7F>:(D?]VH3c8-I1];I+_
2Kb-ZR]S2S7-4)HQ)e7KV9T]bP&NDHGD[5R-(Q7Eb9^T9P#_PW4f[T)JBX-;/OE>
_F6B\=Eeg/7U2]<a>-WL1,M-b1^^a&_eC@dZP-:0cI6I]HfVfS(BG)+OX<P=cJ[#
[(c9aGE:)76/V_b7)>Y2H[,]H,L)GHMC8.P-+-/,Mg<1^\#6)]7E;EVN+Lf@7M>>
X\O9TJB&-^Acc_HVS0EV2<8\&[NXX@.[-,9U3:6V;G0+>aQ+U6>FPfLU)6HW3eLJ
T45_,G4WPbdSRA[E-VIdX=f6@E]&HceKKHWa9WOc_g@>7UA.<GK/;-eKT<H\AgHT
eX5TdVD62&#[B::4<HPQc(:MZJY-\=Z<D(?DI8e2:4U.GWC:,@&Ag9YP8,/PL](8
VdT4^F0(95]cME=>9fa\X+R:]G9VDX,6?<3(QI99EEHH>PR-+9T?T-;<>H=>_8[#
)b)KaX>dHaBRM32U+LUG[JAb+Z^AgPUY>U0BO?GLBF3,K<>L5#FBJXY0MQIT<P9:
X\fXe.U:]>50#G+[_5??R7-9VQ&UWUSZdMB45Q-37fAW?1\FXc^_6?<2#ORFG(=G
I1JVZ>.A8ZVIIM\/\G&&0GA;SKfdKa-Mf/?a:]+;VF^S5/,B5M).Z\R#d12\JB[b
]@>//_)V)(Z]O+(1W/4]+_J6faYN.GH-A.1SQUeEf0T.#U+3A]Y&Z)3T=V:4>KfG
Pa?1#]-J(AUNY>[F#&M31_g<M:+0Uc7)W#Md4VQ9_Q7DgZ^gFc,@C5V5L>V^+1fc
.L80PJQ#BWaJI&2fJ>gB\LHCDM&6/;LL7)_P19+4^Ue-b;#2K5e7PWKS9CP3N)]4
L<X#\?9CBDB<)cL[[_LO#C2@/1@U4VB=e.?((CVgJR<KdJ/YALKQ#X82->=&A-)Z
TU15O;8.4EdFCaIg7S]#LR_:Y5:fZA0-H4]<21T-W\gbeG=>b2[1M;4/6O.AVa0Z
=\MRX8JTU?C=N,^f[F+DA(6CSPNKLg=66PJ:2?>E,gKb6-7f<79H7@fXB_)BQ7-E
OJ37&2C(4.VFY>L2K?=:fec)TH;R)#Xca#U]&d+<:gfe[SgS6X>^;_<&1J[cdY_:
O/[\P^bF=EX1Pdg+Uf3I<10D4M^G3<NB>+AGXA+)Ce(U<-]H8=3N&d?9MG:d-V=)
3M(SLf=X683U&&T3XGd#V[]/MFXK:1,7]8SKUZL?4?)R_fSJe#]dP=47,X[FL[2d
U]b@+T3g>C&^MaC&gDNQMU@>gD?7\--V?fb,.7f9\D#OI13(=?AK)>[Wd@7CVSGK
04+&RYOL>8@ZV=a0K3e/HX_(f[>0b:YH-9a13)1\P^\H+?-HY7<5L^H\EcZMO/:?
>OE0KFaNMY\UbK28SK.D\\b9#c7(QGCMdJEbST5GdEOcL)P-_J3X9QY5;)6#W[]J
#X37,A+]+37=+g,,)QC^0=@+68cVH+aK:@BKT>H-M;Z.AY0O-e;<]:.GbL6Vf2WO
OW_5FbFgeYB3^@QJ\],#/b[GebYZ:4Og;RbdA<2E>+S_^a+O9N2SK)CSV2XPUXGe
?G.TFP\&B)TBYTOPV,\[;Q+=,H:0aLQ\a+Obg?9AZL<S0E)POgb8IAEE[,G>0XOe
\Z7CG-E,-+7F2>/73:?).]]GJc4_U]+P/S<e>aX#PTb=,/ZXZ4VC&DO5Z?bL]/.D
72f+RLJ=D7Rdf=-_M[6QaW-5CY>LH<J3Gd1b\e9L64ZG9T+U?R6U0ST][(g]=2-V
b_gW#>)?V,.<_SA6;-8WQRH>fJ>](^4g47?6SOJ/W3<V:U+]f3_@T7<-V2G?.@@M
F/WJ;d1JbVZ3&b^AQ[IeV)E7_ae7e;bR^4#CaGH@T9>3V/AAL&eW(Z[6Y0+6=##a
7<E@VC4;ALfH2<6Z7_Aa3U8^=a&f<a;d674&5S832O5>Sb.E\@@Y;Z763I?gAA=T
6VI^6ddY3^O:UFUNYCBMI7g_P^?FU>e;/UTEF+GC+F2Q)-WHOX+7-^f/Q&[gTBb&
&=;/PLC.T.AL@@dPRU9)/^:^O2Y30.4;IFF@a-DUFX,L:BLObF0Q63L;D>-JPa?4
V-cF7W_W183\fWAb:BZA,S6QVdEOL68c)^9B(+,9\T]1J2/;P_B4_WHA6KUJ2]M/
_B)/D^VfZ(WIWR@a@EL8&g@Z]S6B3_&U&,ACXE9(gN]T#d)MCAQO&F)D4P=J1&?S
<)60N,F/M4D47J8g1:A4VT?;,KPRGIFB7Z,U7<R-9K#Ve[Z>RH?9EJV_0[+-227U
)OfG\gXSGd<4MgF4&g#bVPc8N,;FBE9]X#^5J>1(Dd]R9^M8X>V5(^FT/gPT3SM?
20JbO:S5#8e5#J4C<#7/H2f4XLB3Df^4:b3(\3V\RBY_UAQJ8_d??ANd1a>>S5_0
MH6@YM>59YcA@HfVY@9Gf4/S\F9DT_(PCGSG3U2Uf>#.6?#^AJ#3DE>QV_<H1g]X
F9@Pa9Z;7/.H#<F-0GEZ,>4W/EDT-Q8^4;b;1CKS)g-/0-.#;(+GT)+E-W)Y=ZK.
[VE,Ng8D^>\>Xc44T0AcBBBT-Vd/Ef,EM-O[[AD-XB=c4;e@3]\4:=b]U<AX[0F<
YOQ+5<06UZ[+;7-T@;3@9<0c(&c,_e6f5T(e+M1\ec8&[65XWBK8[G-(;GW@&XKP
HK3bK[cECO,JbfA)(0_Ad4+23bF@OU5<\d5OQaPNg+8II[[FOLFZ4Cf+8.<0A(VH
a8f1,(N3GfC=?Ag+\H7:ESbOWIT8&42WXD3123[E#E7O\:JC7LL^Y#KaBIE>/\0:
5J=5\,BL-V.G<4NY[4STP&;KaODb8;G2T;DD[8G,?,KJA?#LX=WD5&ZJeg>0e)(;
A3RW;8_=>^NT^?.:Hb\cCZF[=[.#SB(.H]6(J+Z>/?ga,a5[)4BG9c[T=KK:c>?G
TR>6=:fV_dLKDK>_819>4.1-[3FB]JLFC#>fc)Md6?Mb(UGIWD.O)Jb,/R975+]S
.,_SN1Zdd<MATB_-AJ,cag-&P^8cW_8A#4(MIQ,PR7-.<Q?(,G4^H:>g)+[HL&Ic
fJCa=H7_MZ>P[c@M)6HQP/(MLSg53f,.ab9E7WE^G6@T-&9_6Q\#4+N<cS542UK9
18eMIHaP16LGOM_>K][:D6XD9,6(=-<f#S8)_?;E2H(G<b5.30P(L##N?O[LVBaL
,[=f.1FEKGgLI\>2Wg00)Ofg7_3G249B[4?R[WGW&aF<<C^cXK,>4O9QRJ:WA&WP
G&;[6eO=QFNc5LO;BBT^?&>FXY9:Ye\W]4UEId[E9eF=?HZI:<MZD1.cTZI4TUST
K31P0R9D9F&6Tg.]3f@+IV,1R[H.[6-[M3fGV-8ZHF\<<+XVgdDL\3IeZD,.-\-b
UO_97VC=X/9]FY;aB\9Y(Y^_3f8d@T@XaPN;Y\FE]-3L^AX-YU32b@JR^VN4GL/9
#FODZ>:0;WINT5++,a[,PcBe+6MA_dRTSH5?eV=PZU?BX:HUc^ccYAR?7D8f+9H6
]@A7fKa8W+Bb&@be[=AD.@/a+UI&O3SA4;OWF=/N@S?\.d^9&>KC27:^;>D6HW^6
CIGWeTZ&^;d.)VV+?<H3LBdOHG2E/bZd)a:D-eK&?)CQd5_)E36a>?@:7(CEO>:H
8<8@e-_KQVA]LP)>CM]K#gcg4MD;g76)?MWAT=9Id+A\M:W[#g]d/[ZW^_RJST-V
2>BfRR&3OVB70LY<]VO1g>8WPZ1P_DIOA/6FCU&W08[U-cX,R0O^VVW..b;8[f9a
]cTC374?E53Q1b(0+1^=S?&>]1_&LK.8TNREV:24^L\GafXRBU:(+gca/=T+d,;f
J.IPTCL97.3;H4MT(A[d@(=)/#,bb,>D/(/BE^S@cE8]3E40J)N94+2^_?KZ&_&E
KB]6BbHCV=397NN^<,;f05R9&,;cCc=IBM8@&=NA]YNKQ5_dbQd,#09N,Y\eA4,,
Kb)[cOD2U/0>7@L^c@Q-#d0f8V[EJg^2Q<0)9#@79[EY>=b#ceK_.<F\Waf5>A-D
@Y/>:>a#Hc-[H]P0aW+JSU-L080-<_:@8-,@d-e6[2[(\B8Ae-)fdR)^2<[</I>R
AAeJBEV71^d/O5aS_C&1b;VgRIOcF=eVKTOCIA+O7c3?b5cE=T0F11X,#QafQ8gC
RZe_b&WP,,9FJYc>><,5,7@a?,]e)KJ6SSYNK98,a[-1&RMC<+8.g^6CA\0T18gQ
E^@J#O88M:YGP:B@81b9-O_</PO,1QgAQX\CKO-EGO4Q6-=4gCN)ZO_ZDSOS.;f<
K+/=\e@VNQZIZMY7TCZgIE&UOY&FWXM0SdWM-dO&4J-/RW(41;+LKRF<RWZbR53O
J@_;:?:Z9QSf#QVgS@@dM;,S0D@:/Q@)98@85MGI\]ZD]CMEP6:I]Z:d3F(D=/@,
89&+X>RDa&B+E^1&3U5?0Q5R>;=[K)&6(aGVAegQcg&7_5P1=)?UE<D(F>C2]<IX
Qe@]LSMgD:4<3BF6]7/:]QA4>IXcO)S;W(LSB01?EUb#g8b)<UbbRf:\We.3HPV8
.g&@>>Fb,7;ICZ)9f^5AMO]g_XB:Me&UZ>=.J6^CMN8I-fX9J719_@/UD8a#cV><
RYX<>EU^+.e^,)GE_-FQIOO>VeZ1Y;9Mb>_,JB2,bF..fBMdO1A(S)(^0=V05](:
H4=g@0a(=#5cWDR:V<F0Q:6Y4:L)RD37TD#K[;4[P0LS/WK3+#MWeH9ULG/&JQ_J
O.N1fWbDA4ZUDa)08F3>2d/Z,^(c.=][BM,9IKSOS>X#aa>_7[([Xc5C46]+AgUT
,_.[adc)M(+-@aO:SENHFNM/614_NT/2:7ScMTaO45\eRVFf9LO?T).W&gc[(,ZU
.8Z--E[CO.9?2L)Ab\34+S2CH.f8_<P)<;J5AeV<eCg?3OR9GEO)+/WWcXIM29P4
J_8fYM-Ig-#GeX?,K,+]TDf2TN4b-0)YW]T@U1@^&+cY.P7QI4D0/?NKEA3.TfKe
e&MEFWaV)6dJdMafC(;a5U=W2[##/X@PV@3c#G0>OO&SW]U#)P13_RI/];XRQFE7
Pd/]6YBcWOb2)6Cg_/K=J0;a;)4K-(-5HBUD?f;Q(XUZILB8FF=SPN1d_Q+?H,49
0LA7&E[H5Q3=>D.2#_E&@V3->9gG0fW(HAM>]:TLg_Y<?(T;VQBL260e?YeRHb(U
P6F]K;_]A[)aE[]-0Q,A\P=(DYW1)L?8\8AHBAYS1,M(e&9dB<:UI/NJ/Pe2GH((
:QNf?,@HUX4=fD9\gfNYJ4+CRG?=5a:3-,7S>^6N9Q_DEDY-R5T-g?878JaIH#4,
Z)XE@0T/8TSTV/O?8?K37BUTE.cg8fc]EdRI&Wc\SYfD\Me^\bAIL=G#&8J\A+KW
Ag)]+O_Dc1GDB64,)Ya<BCT&.-IEQDAc_+,XZ]7F\?8b:2]+73:WA4U?A8#(,A)f
RA?[[?AM=\D0bfK^)K<,?1P_./6R6gO7X4I=.9>(M1<+(_7;XJ[0TD:KX8_;0EKO
\KZMERP/I/(D(0R^;+NQ4:ND(?OK,\^)GFG<Hb#Y\&?TJ[^;.ZS(OG94g1I@cc;B
WX>3FLBHATT^&a5XZfHd4B#EHBL6V]]<^]S^<I6;K2X#^3J,->KD3L@;9HNIf2#+
<KOH#0g1VcDW^@fZ?N9<[@dPQ]S;@@8)R_[J#\@fa2Ag:K)-g]=aB\Me3,)-,>\5
78IK_-XfaCRAa#2g/-BL/a[W33U+])>D/^28X4I4?&HWZ=5[VLNY_T=UM;=0[V7Z
LeDZ6VL4-F.#G-N4FbVLF)^DMP0=L-0U7)(^e#ZgAOJ#5M)b?523,)B61gAYVSZe
ZQ:/-VW;P+XUFOGHDg<6-24,3()fINR+7;dQc0&U04:#a(Q;W_WB+/QY9DRR/Gb^
87LCM+XRT4BQJ&X&Y:_VQb_fYe;+7Zf4,.UBZIVfHNOV:20@2Ua?3(Lf=(_&/4G^
CU1[IUf@(8KJ]4LfI3:;2])\Lc-J[8T]<af6<(U_6Y&2^Z708SVGfH>>N4aJ9^Ub
Z&@V),1A&+9c:OW8/L^U585C]9C/@g)K2>Q7-OG9&eLZH8&P^VH>SXD0;^1>GSR]
[@6816[V/?^8MJcZ-D#YNg)fN5,>5E^e<4C5+O-OU\QcIf?&=#\ZOJAD0]>[+XHD
UQDQ03WE<BQL=R^JA-,4TdEdXVYX4cc=Q\SR=+O;:?6d+e#OROG\NVd.=</0#1dU
VZT&9J^=f&_B#fO(#>ba5Y=MeEIQMHY7EL1TQQg>OabP#_&0MM/#5#XL^5M-3Y_G
5g&YVF2_c=cSTZ;-BNJC7C11gTPHJL1S&<BB\F590eA8_PdST4Y;2MS3KOQ2[gM^
IW:7KCB48X&Cd@cT\C=_Sg\XEf@O8aDDc85f<M8]GTE];GI;SQ^3M)/G)]>;WUG#
)M+0^9Q]GYb.b]+HZ+I[_I./7]F_cPG_a^[?>T@GR+P=OPZ0/#@R:Nf:]bWW7-1N
FLf_I)^XY6>#-G7[eL\+EP:N&-_f6I6]3>X,@/<bMGS5LJ9=O-/6([R[&61,OCd&
Z/CVK3AP8:MYPLgQUV6SL9YT>YK@GYeU<.Za-N7dZO+E9<_SP-3AVbID@A\0Ue.P
APeG()N]TdEPcA[(QJ(0fK-S-W+Ae9&Bb-B&K>4[(YF^^UGR4>XIOAUFZ]ISO;+K
E(,3FVAcDRU(/O,Se@S+ea,64]4I;K6;Z7fDS+G?AW:=]+LROO^B\@07AC_b,2,G
<a)f6S+LWCVF-(f8IXTN,<0Z9.&;,I-GZF@=BRXd<Nb7MB(#0M]\3P-78)CBFE3(
g[RAE:7>99P&\2LW>f6\=e54^/EG,GM]\)^._f@9527)D)I)KA@2VW?c6<75.TS0
\>/\7NP6-8aQ+PcgB,?+QI6Qb5/\8b&7I+0cbUBE9+6B2Y38S+6dA04LMd?)1eP^
E:KYSNC1b-Bc_;Cc:\#\G3/-?XDL.dQYGfUH^/P]?([c=cS-aFDN5\#4GG#7,JJ2
G-0R1@\f7LFf404XRE.7EISTF@5T@c-302:c>9?f1-=1XcP>0(HA?^\5(S>(EEF^
c-\:\+(T:?7JV,^._3.2_&ZK.Q]O+?g7=KA\5/=^NXC6HWC&@X4g5:,U>Kf+N&0:
&2[N,O,J<LHF:_WeJ?YMV8&C]GZ)5ATfTG/=Q5G:U@X#[cA@+S2QK&+MfGgZabX8
,UI=,ONNF=aHEZ@GJ-0BAN#I,EM?E@ZE(7+e75G]5CX[G@J)Q6-dJ>&J7TA6Be3K
Tfb3/8UXD-6K-Y8)Fe?3YZ85[AZEb;S72S_Z=.X20X3]C2&<D>]YICQ_8R;EM4I-
Y_cDGIf-@+>aG+dCOAb/41CL:XA]b]S]QEHQgd..8\f6_f=VY0@[X?]RaK+97:@8
AD4IBK;I?W^I][])N7]H@UR7G/PL#@N9_1,THe<IR)MPV]J:9&TH6X03+#H]=LZO
N:IY^Y58L>-Mag4>9cD+,gRRYgN.^+1\ePMPIUYG3CIU;-26DFYA^@77_0SE.?-9
LI.7[RL\UdKV>#Ka6YH72N[9Q3K=7-D,=[7\)IL?c>;1@,FN&-97WXASFCSZ7941
3TM:d;IIWHS8dfF;).-U22I@ZN\e.P?,.Fa&<DBReg4+3.Yf#Re-5/_FQ^ZC4e-Z
6_OI1LG?F7.W>RIcNaIU0gW]4;DLOLLE=3fX2=bC]-MQ7Yc[6fF-MCEa_UNB.d-/
IN9G6]E4]@;6EGF0I;45)g&K^QKF_VDJ0>8Y4KCbJIL3+6/YAcI_c#(\TCHBIR(f
QRON-.5gf5#W(BGX?V,B@.9K<?QG&JBgE4LAWWYf(KC^T_5.5deW058OUbL>AA)L
>O>T])5@ZN\=b\gc->,_a4B2<5W[V_<e30;N<#P@/(VGOc@-V-TD:(ZaEfV(gJ6-
HL-3^.:UCIKF&c/7ZdFI^&)G)]63f8c7@6#M<VCXCXX)W)_72E=HaC<9:<.)5_DJ
IVcU(K].K-2RM[PN=WF6@(6f-WAa&E\,7TX:Ya\3[N6?bMR^BKCf(EN8ZK>K9F^3
HD8;,Cg2Q+7Q&8AC:#L8<BSR=fK@XG/?FC#;ZTfgK\N@[ZQ#&M:K1,OMV\d:7Sfa
,Ya:<E@dY^PWVE]DGO3afG51(O.F]\DS/5X,,_c2BM/,1M(V0PT/]Zc?2>ca#Z2a
34WT>FFJ#(8c=Ae:bLC=5A>N_G3?9/L-7ggD+50)Z:&7IIPJZAGB&]Q8.ULMVJ:c
H6Lb+B5gT5QS-]PD[ATZLFL]C.R4QBO6&W;@>CZO\3B3.)LcO+](BWE:8YBXOSE]
95SWZG.IEA=AWf@/>-4QNY+eR;JP//:&SH4QLQCS,&VH.;1b>7C7c@D)#UegR(&X
ZP]0dS:OZ4V;42)9IEe?-ZD#76,fACdQg)6J(E?R^/3M.>>KKC1Q+SFY&_W/?T6c
L\I/[d.KaLBfdV?bd9a90,WNV?U0DZK[fGD7S3#TS>M\K_1S[)NO_P5g:#]M7>P^
:=g?d=_JJNRDOSR_&8X<.NXQ(C8EKGS^cFPV3[8+5\SMHV4Rbg,#eL2&;@?BQ3OM
.U:ERf@?LAM?U]JU.VZ-L(8cM=^e<ec.6>#2fCe>XR)e^(->((U5CI[\]bUKcA^:
=U)C;Y+UNC.5-W86=ffROR8@\66\W)3J?:^AM-a.BM]@?24/(TeULdQD&O&/f)FK
8OLE/=V9U(HI2eU5?UfCJY7O:fN-)F?:D5eI]d;=eD)1+@[Nd:PEBe/S(_BL(K81
->[6?RR)dN,8(23cJ[TZ8#[UZT-K:#2[;+(1]]<:F/6](J,7D7]@Z:XZ1<Q?dTNC
4<,LK:Pa5+SL9EP666;,6_7ZD+c]Y@[++O>e.)X0A6<F8b(O1:c\JVR]@@_ZVc.+
YV9)C3KD/2b+RI(,ZFUWcOVLC4deR4?69\V&RJA6/(D/6e,-aINf8-]?(6c7/P5>
=>725-<N(F+/SVKD1C+#5Z2Y>PH+/c<.\WM]I3NH^AR5/8\&>8=bE@KENP4gD>VZ
&6Q\ZA+f/I,(1Y>BL+.75_^QGd3IYUO_d+.(EdC==S?]g]24/5UN;IMURQ,V&B4K
S;G;RF:J<P_4.N?FZLb<N8C0[>ZAg=-Q7T6QeO:FQZI;YY0,Y\+P)02)g<#<b0H3
-9NV3WE?CCIG:U]OX1[Gc9(Z9ceE5agCG1S<aZCH>,#Teb9UgKZP>IeD=3gVT5&6
@dE(YG<4];c8\M<?#87/>V;<&RK0,\_cK^e\0Tef\NU3PbMUbCedd&77b&.IfNc5
a_Y6Lg7:,M0NL+:H02U3cPUH#HN4bQ:(0&PV@KQ3N/3Se32VGFOWEK5D)fVU@HBB
R5&dUG+4fK+YaV/7Z?0#<TFM8TVFHC@G6>gZ9^F#-<^CFU4M&TI?/U,g)d9+c\R1
EG>7+,#UA[\#\X2&_35P[DNddC93IINBa-,9+WE(=Z.J]cSHOUGUL,585GIc#3YJ
H8.OBW;P+>+e2^a[MPYG;JKXS\VE1=;QW6NTQO\(;#-L,?C7b1X_E01BCYLO;(^U
@)K1)I4M_NM[C4>b(^5IJ<T\IGKZAZLO>58UW94gGB_E(TRac^Nbf4KQL>d5-.G#
]6M8JVCD]Of)a._3R?LNFZ(GX=1:/BB][_J]#f5Q9]9YgX^231X#QLgI@R_203AI
Ic/JWc)\IXDO#2]GZ:^?R4+51R#\;R65?S=8R++1Y[]9OQ<d\FD<W-LbXIF@ZOdb
0^HGM@Af^66I1PH@V]7CK_74SV/:EU^8TPY=1MJ_c13V#T85B>d>P9+RHUF@[Ifb
04?++.G0a05CFE+31<O[_VC<c<(9:>\.d?<@97;gbP)GMJe[b9#T[2T4M>)HE#LA
W4[)?X_[ESb/R4Ue<>&D);GSAd..@)=^E9dgfEd6IUTaT0Pga@>6_Q7S.0eV4bT<
cQEa_O]Q)S(c,g/@GgDFA;Hdc33?Ie[;6.a>C:?cLfNc;,87fNA8cbd9c7YR#gEF
>(>R^7L,_8LESb_6SG=-UEN@fFBO]8eTbEXJ=8@eaPLa#5MOa6_+BD2/Md=1:T2Z
J&1L02A<F>dBU?\A_QG>K2ESH->cEO,M/,XKG@@M8aYC4A0E.^aZ_GF?0^a)KI#(
WCMDGRdFCW5]gUeY+O\MHW+-6THFbcM2_M-OX7R,]/4>[V_HWgX/bT[@DaKB0f)[
G;1U#R/X^BH=cPa#ITL/dG\K8:W:XfgFaJ\7)7C;OA#,I1Z;ZE()aM,bXgAY7N5W
6(@LP#.\Q604K<&SMRKaUQNG6IQ3JJ9VETX>W+d]ee1W<UDU,4#?(6KT?)88G/6W
Wd=EOBY66Y/@D<#JaJeF4F@^>R<8SZT3CHIM#6?)Z&H3:eS9Q\K_2+7)Lf;3+Z.B
;G2VNbf-09V83FX[CEN;.SSXM&Q5I#2F+c:^[4A03?,IR](O8F^XGa&^[f;:eBR[
/BEDG7aH9c3RA.be;B/]WMWA.V?Pc?T9A&@fe_N12b.2Y3g(2+JJ=UNG(SDc0/VB
=Z;+B@(WWD;D4_DCX<TB1>dO:.&7-\8R.L?&\:N_72#K6,=eG-<(J6GG3Y/#A[_J
J4:&5=8^@O21Wa.XRI.OG)TH7c09YH&CPM>^B,1WHOGH^Y>41XV2Ba#(;2(9\>fB
/8+)+gaeDNW\d[DN,]<KLd##feQC4Mb1a_Yf#:@]3Z.fG])^C7f6H)e4QX4dF#93
E>^-f14.;cTBP@?H2bUHM:J;C:</Z+N:?I&[A@]R)=P?N,+@CBM7Qf6?0Fg>-,PT
ggX.[64V1X+)H\PUZ1[W(U1/[)72)ZDKG17M3.EfX.Yg5B0)Y;:4HU5>=[SdBV<>
J9JBFcc.=G^CdZXMZ]G/;-603N<Z4K2^VfY6C4gB,DS-?XPGQ3QBX/PZ3J5EbCaK
9147>7aHM_>,5M=9Y2U?fA<+;K58VVU++IKONTPPLBGGC-5FI/c:PJ_.S6[/G:9H
7,eTZIIM-Q9B&=F)&ff#:U.VO9:8Od.T0)gD@].DZT8<S#2[Rg@-VY]H&&,eRYP/
XA?;VL>[=:@?aeNOGf8&<I#BTbM0]F_AgcK08?SNWY=Y(ZOL(N#?/B[V28O1dfSZ
Z=<f(2VIZ@W#Kb2HAO:G5U_>>F]O/FR.FE5B@HOVZg40UE&R1b2aYKNC90bB\9X>
_TfIV(DggJM=HCJCL;(H0Q2>5cKM<<D#FG^#O0+60OeZTX-UGfF)d7]/Ha#ZUV6@
QRCQa<^NB;^X-6/=QU@O(,NF:G,=>[[QK1[Xg@2DK@IJDe/gU-AG+f58U68<76?/
T>EE+QA6fRe-6P7Ae0]Id5\I9,@@FT(daQS\8Y2&TJ:+N]+JFFB;gZ-D4NeBKcFL
cEe4\2Vb1BDPBd^SeC:\bVXHZ;N[(R]K.4/FL&+VLTR=4[#?7;0-4UF0aR_4aT:4
?J4ag(&W2\eO\(bLIcF_Z]>Y3Z]^R6.Y3b:O>@J;+_G(+eGSDe8e.,KL[32,;-\_
C10<(Q?++C4A?-cXf+(\J>1f^M9;\OEUXaBBN5Oa(J7WV@dQTF+ZPRY==RX\b(b.
427(,0-X8ccH;Oc,7.XM+d,4Q@XS,,R5_)W5I_b/b,8LbI,+W0R+FW\I-I7<c;f8
@DYAX<@1T+?cE6AEc7)_8F5IX0]T@gcEa&A/KT/-a@7HA7[(?7^BFba(ac3\X^MZ
L>bO,=PC<NHD5bZ,MdX,>OJ,0C,(A6O/PV32U).[bLXTY<I_aaL(\4B_R38aC3e1
7X8EC]^NS4<=UK-FKg0R5-?=D.Z9<1H^\Z,U.Ua0Q\DNgHP+EV9^B?#R=#d(\DXY
-e4BE4^U#N3A8,EV[c8?eI+8U-ADc3Dd9:=JY9WHQE#:7?=Z5#X84d]&2=D;==]V
JOA^f@-]NNfCA@)6K&>1UXM::DO^8LD]7GSZ1J3^c[4EcX4POK5GGAaba[AB[(X9
F-XT_3:Y&d4ODe9;?a?[W^==/D,UXCdD0=>GFd6Q@+EA2B.W_?GK1_f<^JQDO.,2
>:1/f,MI2DBG_E5XM3P?WgP2#,O8@U:_4RGD.;>>)Gc6R1f&MJ6JV3KEH]Tc-F#2
PE_79K^8D7Fb_[20#?^_(Y0N/^[(;V2P]G)D,K4=M,b>1J)3CA4HQQZ//NW76;=-
70VI[/+&@@P&LM@3S]^\M]:(C.6[JA47@?L3CA&C^.OI]-/0W\UQ;MZ;:<=A&a4f
0B:bVIFJ[(cc5^MU)(EfC3)gGD4F2#B_8(?f06B&11fY#F;5RZ-<a3J<QA0faQgY
EbKa3#ALe:+8<6FT^4CUH&1[4#[S3<4ZE.B5HL#R/W>8g2_fA[K(GJ44#dRSC1J0
)CGL[N?MHU[MFW-D(fP88O8cTfU.d9_4@2=(BH6<_B0>4_d=#,>>/EG)Q)#9fM8P
YaFZFC72dcYPF7,YTGf6XY+^8C?BH^#1B&T_Ha4?-D,23O8\,cbeI6d^XJf)V=fb
Je(^DR7>_[F;FASRE&PH1OJ>KVOW3Vde#dULIE3[b:a]JZY[RP7\(;7PH,:Kg;KA
;bYY.&).U3cJ=:b8L2RW3G/.X#+CMIbYdPaT&Q#X]HDN^;F#KXN>,E8V=S_50WQ+
JM>9:FO2)PH6V3E<266\NZeE,18@]eV,LCVFR;0?5<gB?gFBY/17+1Q:-NR34T/?
J7@(SQaeZ?=DQ9PVQ6,+cTeGBd;ABMDKW(__WLN3@M[&MWGGN>aX=4=LV\IbgV,D
7>;5_b(<^C7GAPP+KO)UeVB5TJ,7I020e7;U/NZ3bTYEc^LQ9-LeecZ3f+4O2@YV
O)bLF7?>51)0>A?>C0SCc,\1&CDP41T4Z\@g>RY/?NI;J9e?bASY<A4a,78EfC&\
KR2E8Y5[SHWF[FHLVHY,0U7GM^=O6H^SDW3)IJ\C9)c-6[K3DY0gA(4bX6][e^_7
f>aFLH5_Q-CUEDA?8D^DOc,B+aKM4EFEcPW#.F))Q,Vag\7KGRY54fg5N5AT.X)<
YL.\7]1Q&8ad\M?>=\>M;+NG6I.HPBd5SaL&YfK0.W>J@12SIWW\89I-,Q0G&fa/
VF.=<_,L^@XKR?RX80P_/Cd..?Wce+e.KKP_Vf:X08W3dc)9dO:@SX(&BCd6CX?E
]-H8BANU.\MU5Re#\JLMQ41g)S36]fL#X2E5(-;N(<OY5SP3/I]YbJcFL#00K7#g
8B^/M>eT-[T^BY08[9PKG@==gMKQDcOWXd)9K+>DG<X:9I5_2:,3V=6#]b:g2Y[Q
)NGDFf_DE-AC4=g9NGJAL7]<eF81K?J_X5b/_Sa8[J3HUVJEa,J\,;+7DB@dU,fc
5=1BS4BZ)^0)1I?J.FIWXb.TE0(4:D=C27ZX7VTJ..Ac&^Ld@_R(APKBbB4Y3-b:
cLD,7;\-V&=5GOQ]YBZ(KQ3G<=&_L[eM3+HOaLW3\2R@CN9&fR(cfWUf(4).0dQ>
,IQ)I;gdE7N-Ce7IeTKA;J=#,-S312WEf#7cC0<-U76D9?ZW?9SSK459IQ>P:H_c
g\R--1RaMffP,G@JHd1dIg2=G2<DAM?>GN-/6-7YM/Y4[a8e1RG2cV?Q3Q3g-W9U
13NP5;;QLU11K3(cVYXK&F6K<IX#-AT7LQVH[M-8@8ege8bFE>BFMH\M:C,HMNac
V61T5N#+^Qc98=.>bU3RAA[Qf&+W+H<I+]PP/5NWG]D+SSG+2>b.JW7T[[LPBa1A
0a.-NKcOV9>XVS.7WgZONU=OdF84WRV-/.J1&.Jd38?2#XLB<eY-/GU+3\8;IQ.^
)I2_QgcL,d#a0JdPS-c9TB.Q=O3.R(GU.E5<\Z1IQ&4F^^2JW#<eN4bLL]5+M[OU
C:5CSE7FA0O&#_LUgU2GF()=2c1_Ca<DTXQ^R>:3_dB+Ga^J1M>:@UPKX@/aDL;Q
PdTE(S5H?#OBT;);5+V<&)OQU6fBRH\E((>[=FX+K7e)e;?c.(;4;[3DJb[a?XbX
SUP10gT^\<c90>]QI3c/U27XS/<gHDS?/,a]TXX].J:9fJ.B.-)/6)+ff]W\\]::
IE]_Z3dM#TZB1WPP/Q9WF23).3?U,eW<M5VO068-)_]0W4/C2-B=4VD1f6A2&&S[
Jg6806EX4TF@R\(;ER#M)N@4#RaUH\&.(5RT]fd#F8\W@DVP:_/S::PQ8J_(XKcb
g,ZXYH#8:(e5a]:9#N94Q[ZLEc=67eR8>2MGES)0?33Z:S]d)T>(GCV?SIH-2KD^
VVT6PBegfSIFE/J<-[I[85JCg:]3UM=RS.AZZJ+V]VIR,>f06#7)+Z,Yb-DTI=E&
;0cOJ[LXSBc>:MF0PN]T+AS=:8VR)HaBHA3cdPI>4A9.CAaHVG>-4Z1A>LU+@+WO
b?[Tf@X/Qe=5UAY(TWTN.Kb,WI]Q,VO9Z7=UB=RI(3/g4V-C/[M;=._4b3Y8^0/=
]U?^)SA/G^g?FDDI_CG+-S_YL\<#4_7T1-OaVZ)Q<VPQ#7fG9GC.dCJ[a@>;=C\X
b0\Y;YM&Ja?\>3T6^0+@BR?FODa&WLX5OAf;DB]QCD8-Ef(Q9+g?c,MGb71d,_-;
QBO=\P3@0^I@OcP1+>gT4Z?6]<<aX@<gedg3CYY>>F)@.A[\_HW<5XKA_ZY[[c+L
DA62GCL0]IV=7S;=73bfe]LVFP#UEE\+3<KgVaI);3?LYD7(BbQgUBYN:bWcS.?-
J1/ffLQ4(.:_LcW]-5gS:UB_S?^4Ge-&5?M&7:MO+J6\=&.^eY/3623aC>M]?SZ/
-N/^8-@acPf/aaSIHSbA](-e8gO[fO3V#JNg(V4=PA^1)#DYY=G]9Jg)):cU\L:0
0YGV+9--@QcPO]A?HfK,(K>1aD)/,F=@V;Y3g\9=Sc@#9-f0dg0;E#4E>UE_B7BD
06+VN9B3^<SDO_]L4VgL,GMSF=>9A<A]IEPT3gV+KG(&1N=E@3K)](EJ@TSHFT?0
6XPOKcB-W3?B6(\=13Hf7XMOFG7T^OSMY/9;)]&Q&M9MV<W+ec+@^J,IAFccNe_<
3L]K/bZ?/7WJS10.?Q(N>07S[c[GYN4,N8O,2<^XB2EK<=#WHD8Y\/c>ebDL&DZC
R3.6(+>2.;FN=</Y#46[Uf2T\9UMUCYegSN294F)FH96[//c\^>:J@D@6N3be2SW
YN-H>P:=W)@==O3(OGCf2bQM])RVa9\+4)_]M3EQgJa5;F&@beR5GH-VZ>73WYYP
S3.N,1FNI>bK/d\,A6I#G@[54:;@(C550O?AbP)+BF-D?:PQZOI.TU@&Z]9IPEEI
D6RB<.WefO/BIBZ-fYW95JcH)S=\.N&V[_H3TB#^;7/A-D3ACI-Q]&_Q\F&3TF^=
07Q3FIcL8.#c@I)0ORXEPgeKXK^B1GLGC&S;V^c1@f,5V4P=)4e9K87HA^2S8H,)
D71A0b:FW@bP1H^O4dNHZ.81De-dFK7O:c<4@4/CP:7LDYf5b^:>:9e4OaG+RL7Y
NA13]afgc:I,4=_GBV_S-.DW@+>H_C]_A7-(Rd<W=c4B<)>c;7fYRSW6PZ:,^/6E
_:8GB9#)4N1OIJX3(;T52DgZP4dY,5]]@9YJ:e6][f;aDG^=fTPA29[IU+7=K8E7
K1KK&00QE0V2Vb?/X94Z\+2<@H@01]:)3MZ:H0ZYWVeHCLI:[Cg3Z=YH#2FUc,)E
;JL#cVLJGWPB/>3<b=ga/ZYH1>/)21I2B8)cQOF56M>72d9PTFB\G5++eF==#.K\
M::TG66(K/VAK,6OOT./R>H<J/=a._+=@b/?NSeI]9L73U;VGBQ]P=,#dLVBb,,N
e2OUB=eXV==PF]Q)42;,aQ.,(D8;X<WZNe(E3-&_N\>_8G);]ASJf(SJZPD2,WF9
_8E6a;RW^b^XGM&WM.9O_)U<[Z4U>CJAWI5]M^A)-(,0T4Z1C<_d/Ud(6?4M).F=
7(Z77KN3]7-<RV8>&/^<F(,e3Xg@.]^@>-)Q;Vd3>Obg[&KFU#f0B5-S^/C0J8LA
QccP0O;.I948ETTf&_7[@4()CULOeP_)a[c]H<S98JJ_FSIM7);c0>^Y(.bE[MaA
)af(,#<7CSEIX?8ZS>N_@:;1AAfJ?]eS^\+H0[8Ec65fNBSYPEUX\C[FMGU0cccH
6b9-7J7e+G9GKPJUf/=&6,5S6McR2[dL2BaTfU&VD+<O-^FG)_D3<,2cKK5YWWfQ
#7YG5;#L3YdX?7-[QNL4E>_-_C\O#H6ZU-fM(CT4Sg-a]#:/)Q\6\G^_,R,@<EVb
]YVcU_3,e[gTG><S6+A(/,E))&Icg#T,OQceU?PU8G,a^NVG0=AAaTPcXPWRAQ=Y
<YCag^J>(07D_RCPeRW=/fFQcT@gO&^ecfS?:H>0W8>0&Q-,LLBa6TDZ-a&RZ/@#
ff>T9@4?Kb>-8:1eP@ceg1QK6,bSf389c9Kd_PH3A0]Kceb-OTg0d8V67GJR+Tb<
a>^I?OGN-]@UP-4Tfb^[9KNTba40D-TU05-(CXe4b^84VBGH6ANWL53B2GdJXPDH
9:H^;58cgbG/f&;<UTC+-77?K(L7<#=LYM9SSP]I_b:F:fSBf+e3>DBGB8fN=d0+
B_=d&S2+1FcSP7;LgH7DE;S?1?Oc>BLfD<[Z]gLJ18E3JY+>M+/<HQIaU386(&8M
]LX79UR&7]g7)]>)E-D:-W:]-G=]DcDI>R4].dcA@L&F,TELG-)2,M_BEPH_KQdF
)Kd0##&,JPGO>9=E3OCR+[1@QD>gQXecg-CX?LJR,&0OgNW<,4TPa@])J=bc&,=1
F0RRF/;WD6US?1./HZ,6f[0<]C2)4>EB&O:O3M@:-@_ddY&gZ)(QNN4[B,bN..:3
,Lg^cd0-U:+JMB-_M[Q\cQ-3>,[(AU/cb\;4-/>4UX>e;/Y)H6>D^eR,-\#9L\>M
M6JgJW,RCdSc(c#&RIZ4&1XGS&&#eeSOZ7c\;c,6dY)UM[A9QVQF7X.H>F7JX-6<
W?_ZMYLD<1?.dQ<F4WMZcO/9:),LLRMQAL@7]@Q9SST+beI+QLC++d]CbR4EK#fQ
<SN#<6N#>)Q>6?W_3@CdZ-Eca#IMTg=6=7HW,cb0KTE=M2@OEQ/RDcZWEK,5+gL?
-f^d;WdcHM,(<eFEe35H9d,23SFeR)9]BfRH:>X#[f(+EQ:H)8/WA<F7Q;@<MRBN
LbRVb2,Cb<+CE5R\60O(W/^baC\>0:=8HfO9[be?Rc?O/LPb.X6MM+f/cJ7[K>OI
)ZUG)=]c-Bf4HMWQFOZ#]e,G[-(?#L/\&9:CX25B>1UC;)fG^0/WLN>MV#17RR;T
7c&/8T6(2)^ZL^[_U#cb#9f/<GIaR)OFA4NUONg(BKOOd]fLI[L9>CPgCUg,YBIY
9F#841D1?]=5OIR-33ABgEOL7W;eK,E<_KK7d_67Fg1O5[Y?\ECS1(bI9OGW-eW5
I?e#,L@GO^YQ];>:S>PO)9.ZZ?[3.6K(B3^W@6B#KR\G#KB?K17WeG^N8S4?0C=W
Z:QDWF&:(GI5PP+8Jf[XeW0,eFEe.d\PNZY28/:22Bf+@>Jdbd99E?aY;1eGHJ5X
XX/b4(1XC)?L.cTMOg19FM^B&X(DI;V;,67]2#UHMF16BIJV5;2,1]5MZ3L)efEL
_?U].d_d].;+U/QN3a5_X2YfR?gLZ+/9JD4_5]&AH>f=2<F?0QL2KUJDMIeLcK&+
]6HGV;PbXYS@0J89QFXOC)BDMJ_fCD)cDYK^.gM0fK23Nf+S(JQX&;_<.P6gbR.4
UR\Y-P2)&XJ6MNP^e_6V,OBE0U65-K>3NMTWYTX46RN7:UV4HX@U<YWI^]cgA@I-
^#N6(N-^WS)QBT>#)P#)3TS\K(X_/NU4(?N=@MP)^Q&,-YA_;8f5L+WIM$
`endprotected

   
`endif //  `ifndef GUARD_SVT_FIFO_RATE_CONTROL_CONFIGURATION_SV
   
