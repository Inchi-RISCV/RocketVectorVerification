//-----------------------------------------------------------------------------
// COPYRIGHT (C) 2016 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------

`ifndef GUARD_SVT_TILELINK_TRANSACTION_EXCEPTION_SV
`define GUARD_SVT_TILELINK_TRANSACTION_EXCEPTION_SV

typedef class svt_tilelink_transaction;

// =============================================================================
/**
 * svt_tilelink_transaction Exception
 */
class svt_tilelink_transaction_exception extends svt_exception;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  /** Handle to configuration, available for use by constraints. */ 
  svt_tilelink_configuration cfg = null;

  /** Handle to the transaction to which this exception applies, available for use by constraints. */ 
  svt_tilelink_transaction xact = null;

  //----------------------------------------------------------------------------
  // Random Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Protected Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Local Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Constraints
  //----------------------------------------------------------------------------

  /**
   * Valid ranges constraints insure that the exception settings are supported
   * by the Tilelink components.
   */
  constraint valid_ranges {
  // vb_preserve TMPL_TAG1
  // Add user constraints here
  // vb_preserve end
  }

  // vb_preserve TMPL_TAG2
  // Please add all the reasonable block in this preserve section.
  //  - Reasonable constraints should be per field.
  //  - Reasonable constraints nomenclature should be 'reasonable_<fieldname>'.
  // vb_preserve end

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_tilelink_transaction_exception)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception instance, passing the appropriate argument
   * values to the <b>svt_exception</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   */
  extern function new(vmm_log log = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception instance, passing the appropriate argument
   * values to the <b>svt_exception</b> parent class.
   *
   * @param name Instance name of the exception.
   */
  extern function new(string name = "svt_tilelink_transaction_exception");
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_transaction_exception)
    `svt_field_object(cfg, `SVT_ALL_ON|`SVT_NOPACK|`SVT_NOCOMPARE|`SVT_REFERENCE, `SVT_HOW_REF)
    `svt_field_object(xact, `SVT_ALL_ON|`SVT_NOPACK|`SVT_NOCOMPARE|`SVT_REFERENCE, `SVT_HOW_REF)
  `svt_data_member_end(svt_tilelink_transaction_exception)

  //----------------------------------------------------------------------------
  /**
   * Method to turn reasonable constraints on/off as a block.
   */
  extern virtual function int reasonable_constraint_mode(bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object used for logging.
   */
  extern function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_transaction_exception.
   */
  extern virtual function vmm_data do_allocate();
`endif

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Compares the object with to, based on the requested compare kind.
   * Differences are placed in diff.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted. Only supported
   * kind value is svt_data::COMPLETE, which results in comparisons of the non-static
   * data members. All other kind values result in a return value of 1.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);
`else
  // ---------------------------------------------------------------------------
  /**
   * Compares the object with rhs.
   *
   * @param rhs Object to be compared against.
   * @param comparer `SVT_XVM(comparer) instance used to accomplish the compare.
   */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Does basic validation of the object contents. Only supported kind values are -1 and
   * `SVT_DATA_TYPE::COMPLETE. Both values result in a COMPLETE compare.
   */
  extern virtual function bit do_is_valid(bit silent = 1, int kind = -1);

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation.
   *
   * @param kind This int indicates the type of byte_size being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in a size calculation based on the
   * non-static fields. All other kind values result in a return value of 0.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset, based on the
   * requested byte_pack kind.
   *
   * @param bytes Buffer that will contain the packed bytes at the end of the operation.
   * @param offset Offset into bytes where the packing is to begin.
   * @param kind This int indicates the type of byte_pack being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * non-static fields being packed and the return of an integer indicating the number of
   * packed bytes. All other kind values result in no change to the buffer contents, and a
   * return value of 0.
   */
  extern virtual function int unsigned do_byte_pack(ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Unpacks the object from the bytes buffer, beginning at offset, based on
   * the requested byte_unpack kind.
   *
   * @param bytes Buffer containing the bytes to be unpacked.
   * @param offset Offset into bytes where the unpacking is to begin.
   * @param len Number of bytes to be unpacked.
   * @param kind This int indicates the type of byte_unpack being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * non-static fields being unpacked and the return of an integer indicating the number of
   * unpacked bytes. All other kind values result in no change to the exception contents,
   * and a return value of 0.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);
`endif

  //----------------------------------------------------------------------------
  /**
   * Checks whether this exception collides with another exception, test_exception.
   */
  extern virtual function int collision(svt_exception test_exception);

  // ---------------------------------------------------------------------------
  /** Returns a string which provides a description of the exception. */
  extern virtual function string get_description();

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
  extern virtual function bit encode_prop_val(string prop_name, string prop_val_string, ref bit [1023:0] prop_val,
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
  extern virtual function bit decode_prop_val(string prop_name, bit [1023:0] prop_val, ref string prop_val_string,
                                              input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the primitive data fields in the object. The svt_pattern_data::name
   * is set to the corresponding field name, the svt_pattern_data::value is set
   * to 0.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern do_allocate_pattern();

  // ---------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_transaction_exception)
  `vmm_class_factory(svt_tilelink_transaction_exception)
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
[G<,g]3^EZ0^0@[G-D(>DI6JO[CAO3.O2CF>>T-R#84Y:WO-J/DS))J7Pde61:EC
N9b?b&=XD539@e1&H0&A;:REJ0_AZ_C(c)=G1e^?;8^NbI5HQEATa<BTV@\5K7K8
Z?P7]D;<eT_DDXO,cI46S;K?5&:#^(,]RQ)8DII(/c1<)7MeB6&?UW=D/IW7Ug;<
QbEO=LM6RIW145d7;_TF[B)JY<f-8.6R0?gD:)H3C(Z7Q-\gX\IY1DZEHY3A1JA&
(ge<)=HU#64_UAF>)W]B_P4RGT#8(V+NgXBcKd)#H0cfJO:Wg_LYdI(#H41]cgI:
?OLg8;F3ZX<@VeM-QNVV>g.Lb&&53OI\T5PT0[0GXEA\+=VNNb0:^A>c#S1bC6S0
aAMg_T0[CSO_B;^Y<#W_7^=8,KR_>V3@=18WWCc9Nd3[J4>\PEb<JRRWWa)9F&bP
F6^8@,\Z53A@3\@Zd^?L(^DH;AHA]/1CT?YdK)gH7dYUN2.O-Ng7,+R0eD1;[g9d
)4AfV2>N:H[ZJADUA6WA<3IBX_OEY[7+S:=Eggg=XVe@</WBSAW4-JSW6==S9C=Q
<CeHZ\JU5^F-fF_.E<M0>WZ0F?K^dDc,6D28J?IM#1RA\TbfQ1V4=BIdB-I6/T)4
4#=f?X^Nc]NYV\&ddgEVGJ#/Rd/K&]PM:$
`endprotected


//vcs_vip_protect
`protected
H]RbS7>;VXOC-3JG)]Z-&B-?JEUI-a4&1//fP;AD]V881YK:OI2T,(@HSA58AFN=
/Xb69-15HZ_IG79;YJgE#[ECXD[H.Oe3@=]>V;@Te3E^/,]LXW.(aF6;1e#6E?6R
N0NT]I,9b6R@^?fNO#Ge6Fg;(VQ:K2OV5g/>@ea5_^@9-aKc=5e1:72&=0R\X&29
P];F8[)a4gTUbL/SFO-?FNe.-&?Se:#/<;:5NdC6fWK-C6=I(>78VHQa[,&1TGZJ
g?R^:X6:G0Q.X3XJU.M9:UV>39b6&?(50\OfVN[QK./0f:Y6T-C;44C(T9[gV4/T
[f.9ICBZJG,=IH,E9[(.;_#6cI]6V8DHF@fI3QU7;fYa=D6I/ec_H^0;;3g]WdeR
&CQE-3DMC0gV[9@?[/405#CO:UaRC[-0VL@^HFURN<)]B.Ee]JQ]U/CU6M<af1g=
E[+g@T7QRWbULdY-=T8>5S/YR^RE_P/C/E\-&FUUQ(P:Yb,e8c:AZTc->PU8&?aX
##/E4^-8[9aaFa@HdA#GJ#VEX98NE??A3#^7+BH]MH1H6RDWaTBSf@DS)Y(X3R^P
WQ;PML+::(M9PeEa;=ATJ2dYDABH(V0#M?)\cG)1[2(E&_?Sd3<6^g?G4UPA<O#4
b_.JR=aI2D.D[WN=/QK9ZU?=0.fW=H0G)bKY-S,.84--JO](Ff^Z#L.:.G/YFE9Q
HKBH68IX\JI61D<S/aUaEC-4]+[-2(ccC95QcI#-cIg1Pf_8BLET#X&;&0G3L8B=
5dI>K_]@9aQ3/8@<G?5ZA;(_?H=F<O@YPHD;D[R2QD]YDK>J^e\8/?G.M]O6YY/b
>4J[1QWTP+(,5Ha0:VEbRV-XB=RG&bUOJ=]b(CA=UBKaO8(:a[H>8We#QDJa9TS\
.8A/THCUJc8SeWD[RT=dC(e#P^XZ78QMg;&@,EL]XKU],XD7R#U1c-#;/]Q[W.8X
(K(JX5I)Jf&)W3cLGQ6SH2?].ME^d6Sd^R^bWX(QJ<H8^3]SC5WKO<fbPIQ_(R+4
TeB;W._@L4f&.JbXNBd15I^89,eN:9AEgXLELI8F#4d=+D2bcZ2E_X@7,)<9?@G3
Z<=V\EQ9JT16ca>L2;Q6N.(\IM[CB@RF;Z\aVCc+V0LY&M:4g4J,GEec/K:M11)Z
01FdGg<R>(@Y/MMEVZDWLL&SaN:>-X58(0e-9LJ4Te17B3ZVb^MFH^V:ND,\IU\g
XbM@aG]FJ4YR]-2L6LBU#KbG53bE3RPT5R_13[1<Oc#ZJgYQ6g=fbY6=07T@M7LD
CL;U[M<0:SN-[Z+3K4@0cP,L](0[cSM@.Ib4>PI/g;c14UZHGDa?&)^7ZT\[DZ)e
B8,;4E5(@7A7a7,P=[_,Q47TG=RYUY(9O3=GW)P6Rb58G\F@M)2eF<G#c46\9(6(
).\3=#Y_8RS5+\I?F?)9d<W7:7Z)[8F9,e:B7L^a^a2(@0UWS?RIgeO@6PSbY5dX
Rg7-EXM#Z&6<gf+c:DQ+@/&3?aR@,W+75^b6673V,If;M+5V5I97.B]W2,#LX3^N
T1)9d(B2I5:2XgG965>EOT7(5@51E8B_ED5[d#_+c)GYV^Mf?eD_@4&(9C.)M\HF
Pfg7GbY[\6;X/f)AI1D+92WGH9=GaNZE?,]DL?1>f<33g>V1LdU;#0R#F>3VC?Mc
@N.=\T0(g1ba68?^[#O[bbeGIKb+QH&QVS\6R3XU35;Z^g.)^gRb&(GP0/Jg(.A2
P+888F3A)JLZ,c9JBgTSL4<1:GK@XN[0[X^:\UbO>f^-=<de&C8453T;[2YEK#Zg
dOgR><RPg+1@D&F]-0eC\@dVM/J]2]?f)=US_bEb[8[,S/_G15)9<:(d,EN29^-Q
V7D(1^Gfaeg9c/9bEOF+#^RF>>L:SG9)4&=H+YLc_/>4K0Tb5f+EN5&946PRWdII
;NB)H(?XSf:Y^I5W[d1MG;DXcKC]@#<9C]AQ1a@J&90@d0E+XA&L?^VYCM0E_L.6
K3\4d::f9<LSbWdY=RdC(HDIe@BYbW^?F+,^8A\J\5?L.F1.X?;ASf0@>&D8F^RO
SYYfQT^8#e_8fdfCJ1>#>7M#DD&F7ENA8Pg_>df<7b02PcE8_>A[LQf@@7O<9U^X
7P(X-@M:^cSL?.9^KaS_3QBXef_F(VY(LE672.6:==S)N[6#J(G[Gg-5NO8,f#BU
eONA\QcLe675gT&^RLad\MaOVd;5RTPAd7,C8PB::S95AN0JY_D@B.7b8A[fDD:6
D-eAS&+^(X[O[YNE1@U,AGT+6dgb[=UQAS2(;B#9#68;YS:8Of^@QV9W2GgTR9)/
bJb0\)_afgR8[QSC[4J:P^312CWYOe#<?g;Y)T0]dCfe=-N&:)/I2>:;4MQMK[54
=M5)V6+<XF#Y2E8LZc9K^ZRX7.Bf4-FUdL09Z+>^(:JD7M#AecE#f@1af;,fX-.&
ZJ:>c3M?e:OT\X,<0Y?H5@P4,P1C_6_MJ@4]NU=/-&fALOH6YY24Wc1RDG5=3c4A
LT]1JDZ[7/10bN[@D2[I37>(NW=7C5^DI2/;0;PE0FVe?U-9N,7)eUP@+S>^X-Cf
bQXOIfOV-].cX.eJc)UZg\A]68fLGg+M&O+]fNV5:?RgBK=CeT\UIcd6CEZ^A;-H
VD#?eUgU\H?YX-NJO^cZ[;B9d8X.TA@GW>4Q0<_9R6R6[a6C5=I&VHYW0IBWW.GM
V,f6X5HSS1Bg.HN>+BX[gZZ?_X4,4>AY-0+a.&<I89F9aZE0;+Q8,PcOUaCK2F4;
(WT^#LMQe5+]K+FF,SbIOa=,U/fJYcZ]Y=e=,&;.FGDVZO74(#.<d.6Y#(GCHNF)
:6(EJ+[2[<gB41U0+];9K3]B<]1<-\37Fb7\C56Y@ZA7f>,ab.D@&dJB097(dBDd
XRJOW)=3d+.Y[ZIMCQ1M_Ga/V))Ga<3DDG&+G4KE.\JdfIfL7KRR=D4UM0?dZTAE
L7]?M#-I<0c)^g)LOc)Q1,Y8EA=.cL@M@=9E?ATFZb#LH>/(#FPd(K2]U#AVGO4]
_WV/7Cb&S8WO+LRUH:Ic;?7S5LR,FOH]?Z>/18E^b[WY#UY?bG/LC+X-UJA=0@6^
U-TJJbRa\<<OfS79W_K=ffVN5JP[IJ4)#H^2P.D2f@?/7[f60I(_O4[D,]LO9VGX
VWc+\Jb)Mcd?&0FZPV+.X.1dc>03Y;b6JMd;PH,RU4/HNfNI1&C=aJ2MAFA53PdY
Z+.Mb+0>^bH(:PYQe:&ES?[VR3E23.DN5A4[0_=/1G]Pd]_(@BS,N\BRFO@TY_[)
J.7-b@([RXB,SfRQ6WFaVB-U)T=[&<Jg=P3&NZJQ9a0WSf-D/V1B<F??,6Z\>Y>L
V=2G.5/90DQ++@ZL[Lg)BHRPHe9Ug<LgXJ+SV:daM_9dV7/#;b0g8S2M9gJUAV?/
V&N\YP;C4\2HTeZUNf[P\:ZB:WRXAb#Z/HLX+>XId/MR_M#2ggI-Z3IKbWVV(U83
PFb7>PMQ@ed_F_/1[7QIZa5:a6:AdM^1:DEDQ0D=TM&?F7E64Y[99^.87GfV85QK
05gc6=M-TU3S^]?IBT&;@1,OX\KNR:I_#LLUW#Z@b7fSb;1[;g#ZCZa4A5.RJIe>
<SET\][6eUGOZ04&D;[&EXMSJOIf2P2OcbWf;71D4=9f[gZNL8>gH]G&&c3[0(9/
dc&Xd^+/Mf-U]E02+B;^DB\X2,J:RCE8AN-M0bM=:CGA:W^N=XG]Y4B1[6B787LV
PaHD2]UJ=PNPROgB;2AcDg(6,N0MEFCD5Q^V.1OSUK6)cfU\eV41Q/HLUg)Z_<UZ
Z>+BZfJIdIVY/HY6N/3aXL6D)JQ5I&dI_IG7^-f<;,TMc#,:(EJb46GE6>O8O7&a
^?a3gd?,;cW9GbFWX<]O#/HVM>M#5G>V8)IH7G:X@gY_-b?(aF+5A]3>59P30V.W
NdR61/V&2&V2Ve:H/</P[J59(VV16-MH\8[7aLbV&aF>SFL)YJW)^(-K:WTY3,?J
ecKF7_[?G9#&E_I26M@B9E>57Nd+e9Z\Ib_d14VOT4+.Y6OEg3^cWaMR03/)Ba6J
Ya>@W??:>E<E9TV.MPJc<[_\78;)CCFZ8bgPU=Z-<3:._Ve;C.Y;FS__2YMZ@5[e
YQdD#+Jf4<?@dFF?+-G2(ZC=1fRZCLReQJ,^\Q]gM])S23U+TXWNRbNJFWKfYHd6
R)2gE\VS:.15]d5@4]D^cIf)ATd)2SN@0Vd8VA9W5R&)CBd\RD[9c:DQ[6).@4dL
J9ESBF#2NK@(QN?Q&]\DYG18ZZ[(R5X[@eXMT9T_9L&]&\G_BBgSUF6EU.\XgTCa
:e>:61A,Ie[N9c9??=294+TQff40_Z?[Z8MQ4CX;C0/B@cDKNNW_Cg]Z[FWbGY>8
I;(WC].,ZfT#=)WgY:3aJa]TICA?_d_^[5SO;e380C6eGfeFY.aV[ILK/GgK)<<[
6b6HJ7+,92C29:)Bf69E7ITFa4CFC0#)4aTJdAO44gK<+?UGR).48V7\(O\bODGP
eaNA-,ZVOO.94T5P^H<W#cY(_86&.S:FQZ?a)>)e2;?-9JVBR.HJI]Q6W@_J8-K+
eZJdG\8=6,&YfXc3QQf6SO?EV,8Gg5/8b30TQNN,b#fMA[8(2VIe\4XRd+g7+SXS
f[c8S&V9IBLHZ8>2,V94?KJ,FY<(127H0Yac:F_>e^?daXFgV3-V]Yd(KTP[A)TD
d0:<.:U/^CRbMN/1DN,?0=>IE8QDdW>CB\Y8LW+UY5V-1VNHT3CgCc<J==5X)PID
,(IRZQa-=Qa:49+>XC-],/cM2[QQfL-CF,g-NTe_.67^&FaWZc1HNM)2gOf+75.#
JMbKJ:fM+Gg@Y(U7Y[F6QV[>5==IOOe#AM7+E-dg4ZcIbeCPTTBCTeDVb^bY:>P;
DX?;;]JV)-#)5\<e,e7(3Z>J:(bN.a6>DF5/0f4-6E)F1G2bJf@Ke3P(0#Z21f#>
.Lc:9#[c0EGVY-L-JFLYaA=bZ;:K0V0^V(8W0K?(dH9.W#aP)7-WY8cC,]=M]0=[
-U1/.)aC2&?Ga>:359,HU3e8VR)21NdY\<ZAc4I.)&M3LbJbJ(QUU1_LfZ8\EIWE
f080B_cN8Q;ag022>H#YcQCY@)K:H#J)?_(5J7e870ZPG<+[.;YdU_<)8/274[ZH
DAN0K-0Hc.eDN/8bM/QV&0-&S&EGSWPc-#W^[Z7ZdPSfRS1N[BD@4G\Z+YdZZC_Y
X1N^\gNXS9f(@9)F?W1>D^AHL,[Xe17,H1e?R#-J6)fH#?3b#.e3(+]SC5U)f>@]
#I6B.]>Pb4JJ&KH\.F.5W/KX(F42QGFGE<QV:Re:GXDKBJSB]F[YEY2M@A)+P334
5\#1)R-&K,[dfXY=X:\HY?\H3E,.A)BdK8[^\fHJ8]PY6cZYSD5Ta.3A58P]A.fa
EY+QBTL4ZNLKZVgb3^N8O1g;OPC[,Sc8,L],c<-V/7L=a+&BQLUC/,fL[g#LQK:V
G/T[UD^Of6de=S1629J3G_TI5[??5JA@#BfDOV\=0eES[<.&ZF)N?-<gE;3TDVFg
;>aD+]@7PRRf9)X0ecOV((M1^<^:D[6)]ZRV7>Y+@:FY:+.N8g54H+2MENL8IQ](
D[,P-,:#K(V_J2.Rb?\fLUYCK/Nece=-HO]:RKA-4HJNK//2/4@VVOY]L&gOTJ&B
\R=RNWJ^a/J2G.OWUHb@_O(c/8EK,XbYE?WfLUVbeaSY?cd##Vc:ZgE\E-75Qg?V
^^W9A7[2WWJZFYV.:1dg^LW+eE@;[cW2CQE=Y#[O9?,aL@^&2;_(M<DI8D,GRG&6
4I2T-1[C+4fHL2/<dN0Sf<>f0A4Q>]0:JQB[N2KW]GBJ_f[AbPQ)((UQ5/g2B#WQ
X3#3F>K3ZA1-Ec[a^Ad^c@G9;/Q8<^&8N.fG#Q\#3=0U15&MEB1Bf>QYf=-SS@SO
AAKDSe1.aG2>36(KGLPdPg-?6dZYe>10&^U#U0CBJ\,(C<&4\8@#9A,-OF5&B.c1
;+.M(U,UdDb\.58XJgB[]dR#2XK2JLe/C4gB(#],Q@+#03deg4b]05(_WPDc^YQb
N@;_G.K4ZG,+;f(>UD9.TI=#6?XZM6#CIcB?g\CbX\I)d)1AUc\3AQOMQRLAB8E>
f4P#GZMD>)S65fE^Ga#I=&_H[WP1.b#f3Ycf9S]#HCFS27_[:/gY=2LHJILP46V2
ODBYM63^0)1I9N&MgSMeYXGJeLUVLX49RYP:R0A#<JKI#PCP4>^+R9L\#fB=N6T0
NEXHW>Y]E7P31bG>\C1M@M[NM.(0;(XC9L,aaaI5XLZ9/G^BLNB^_X=eLaT4\bPN
eK16Y5_,gC]1)_EV/7L(.,R6bJ/EVfP7XU=/E\-QT[ecHXVa35J]U<_+R0_B/cE+
_W&T6R.TK,e7(;Y_<8VdR+c5F52[E5&O7=Qb:R1578WU7209&T]?Cga0.\,I#,^X
Z0dJXOW,;WF3bf9DKRZY&>_BR;a;VfMUUg(K@DI>9MY;g&IJF\W^QCV@bEa-dbOP
8V:g_#g,XM3Tg<9>Z)&,-)<SEJ<1HEDPJcT&@A/Yd_VEaG4fF0_HLH2b70IFQ(>D
eNYCM@>FX6R8EWJ]6+(AFCTY07+^+b3IBX+=>N;G);N51Z&&JNY7NbBL1NP@0YQ7
b.EU[f-WQBQJ03g:-1E_&ZE&+Eg/(GPd>W=C8PK5T.?W]:7IWUP(Z3#CW/YHb5M2
d3Ia0-40:4ID[cQM)C2g@E)eVVBYMDcONa4A#/YZMPJ8(P>2aPJ;7]?#0BAYNUQP
-[M>9PN1DWCIAa4g064@HX,bI6AVO5KcJY](gF(g_)XP,R\;OKb&431V_5>Zc,6:
<fcgK/M6(?N]35[Xa35\V8;Ld+54EeF-D<E/AfZeT6d\Na7K:7UX0JR[RB(P25Q/
fZ>^3LPTPM=6]BAa.T^65RKY[Q\W7fN/Jbf_[[#JHYZ31HUB[:-=fI>B5C/8(^G<
Ie^A4+c:U(:Lg9ND#=T6/G,g&7/Z]f79/\QTM-4X/;R,1R;1b083K3]M(KSYgT^_
B]c63Y_gAM-Q9A98_WAC1D_cI5NXRR#L+f]dJKJYf3+]3.VSd?BfUR[,LMQ9<OI3
W#9E@TAf5=M7T/c94I9PM/K0P]#I95,4J9d)(O4[LY2C7NgE&2[c-E\;QX4=,^56
C+U2NKHDeM]0K?68ZdB,5YW?M;SW\1H;ce_)6>LMd#2\(0A_(Nea3/ePBX?f0&fK
=]K/T#SE,K&ge)F:G^XK6c4UKANb^@3>NL802Y;=&:]3[LUaNfY++4GXNeMSJAN:
5GD2bO3_\eZfQc4]/Q)Y)2R@-8\1bN9-KLBM_?@W&3d-OIfQ<ZVXS.LPIJGa)+NF
g6:6=IEH-Ra<f<E;V6PIB^H75&J-OIg661+GWHGE57_DRHAAW#9AaZ8TWHL#^].G
@,E-OO5_<P;,c[12Z9MF/79Bg(5FEa=9T:K-IgJVFd@:g<OQD9YZ/.)],S(1]cUT
VDI7WV,gg01F8XZIZ;b7YHNR1TH[#MYF5+D&eY5#KK41GBW_FX;PI,H(Z9a.Q(eP
-:VI?]A6=a/]0)HUg&6T>:<2/f22AQ=ZNJ.+[;e@-7);cHCVT#W#PM@_@+7>)X+T
+Q5^3aeLBa7ACSX/34g?Q;ZYgU#QX:0c/Ga-NQb\8?>:(0@Z;F]/2W:&<C]9VYL?
)ZTc2cSL(8?KH;/aD3Cg.dDXW1dYb@^9;P,PE@+J_/XHd0YXN(:M3?dbX^K^gbC?
e[&:5g[5b<]a/\Y?&B0?#HB+5WOdC.M2dN#;\dO]##)d^A2WB?-;#^3ELK@:LL][
^,&-?#dD,76S5aNd8Z19^;.^OQ7aS[Agc97T4R\g?[M,F@VM8-H?K&+aT#e^a(WN
WP@,cC[I88_J;K_DMJ.bAY;4e4(\RFb[[(4aC2)K/]8I(b^835aIU;09)XT?@NM)
=YedJE1bNP1+^M8KGLTO_8[6TFY)833A:M0[?_?gF\@Hg8M_E7?(,_Q5XU50Qe,e
P4B1gH0N@GRGfEBN@D6TZdIWVAUX7GSJ7H1^Z\S#)ABA2\X@.PZ,GOcWW<TCC;@a
;-R,5E2aeFOUQ<[WGPY:?CE:8HaU7L;bKfa)dbX?UNF>D-936F=b?U:)9(Y,8R;P
X+g\&gZ&0;?7AIR<#^3VNBPBY:6=[F8#M[XM-R568KfY]LN?A14#N0:08/7X9TYX
R>ZEBdXBO<9MVf0.B+d;<OI#_^A#Wg2/+\D2=DI,)aG8;7ff<(4-bJ<(,69d&+<2
4/>2@2:UA+]7=DZ\4+f)TZ:FdVVC9G&MM:f8XCgV@:V=_>FU8G0B:a4:ETbI,VUP
Q+A&2COYIRUO6YG,7b_WYTV),YA5cPM9R\N<0KZX0_CMHa#2JJ1fg,H<Dad&B6L?
\:/ZX[6f(VOCf645J@YVa;@[FbE;7OSJ)Fcc3JX?1):\/&3S0bT-D_-g_<2)B_SS
972O,3B&5ee^_U/U^OON:AXRRURK2HD<W,8_e+4e4LXM)NR?M2[V/)\Ne>VW([E0
,eH<+_OXb=JCY,9P3J.4>S#5bJALc>DOHT]<Ve)4WI5g6[P^WX92C4X8#ASB/gG(
V1UAISFI4]d6@J^_2@geBeKI)B.GBTKN-X95<)a=Wa)<L4aKPY^DP+[<\:CVM@X>
GJ9?2-g?P[<68;8H/aH3dJ4.)#U,6U42?H8&Z((G,@P[O(.=ea15\g^)32I(,_R_
&.gg9TFMg_.eS,(NL_VKX..913_G&[WHG8g\#Tc]+O<ZfDV@..0A^dNQ2g/M6&CO
(^1.\4NEV_b<8SG;M3VNAU:NAf]ba9-d06?B51)G+@(X4cUV@79R60FdM4.gb;T>
IYJTe13g@Qff)7cP.N[Jd9^9;R8#?J,KAV=9X<(U)c,?78,08bMEX6GWT@O4H:B\
OD+I\P50f0H1T2O->GCNZ^ZH[@2eJN3DbOFe51\8GUSJf]WHS2JdV[fZEba+C2&@
cgO22eA_-R(1@QHH,XJg[PM4DQ-Y;UQ_FO]<]I[Ya;gW4]Ub/64[:M-?Od(DC-B_
]?+-S^>_D;^dK(,\:N,Ac8&8L0IA11[eX>7g-R5^RBQ7>D^c=WE1T_4c>eD@Y;O[
2VNO5@d4DE_WY3I+_cf6<fH+#3B,:FU<3._I_>#/<T=6/0A@+R(Zce[5XYYH+01R
XP6I@OC739CeeV7QX@#C;e^c0PF/ITAMZA0XQLcASa[F)\1UX?R?C=YaEWT&R7Dc
9Da_]T#ag5UbQ_(O,F^edBaE0/7UR(K#OfF5A=\baVD3>:ORE,gB.c^L39NVTU?\
;7E#PId269H=PF[,7TA-g7#\EZHQ7?;.VA9#WSMdV4-=5bgd;[>=\7OYPSObgOf>
_Ba@V<[0K+c#:)01Q_FF1Y];@OgQ-5JI:?61X^+S5QL40,d+7I.MSEHL;:)4fCK:
+#dFUJ@M-A.N,-CEC_&5?(<+H5.+3I-KW0.N+^048_5C)WC^KB;Ab:V:DKbF141T
Q=O4f4QeKU4>ARF#>Rd+Y45AbQ#eKC)A3>gM;_F1-LA5U&cg7e.[=9T(/3=D]59L
VA.CQL9];_/S>(fe.D+),]QH/@cI:R_F4Lc6)T(]A^-]D8.S)Z_UB6YYeZB[=JT#
^4,?fRN-2W]OEeDB6G-93[0.1bebFG2-@WKQ>+dfHT;67NY4L22W^3KG)FZSOR+5
(1H6L(@OF7F)_RNE3Q9W,8L^aAG>(47c/CV?,58(.fb5Q4;1K+M5,,A_V@1=I+;9
7CZSXPVF^A6>^2G>W8NMY8#<72DS0]0Te^&YODDYVCcLU6g@UXAdCA2.7TGa=A8N
AAcG6[2c_VC/VYCc4(5IQLUb;UW3PUY?L,^^,B]@X0RG#6I?^@+N>Q2:F(9_).+I
TT62ORO4PHZ+:MT/>?Y25;MPZWSSWfN0;O<4W\,V7=VKN@eHTY#?U\FfVBD+e\5E
,2bFXPHbAZ_^:A=aJc8I;TAI@KXg9e+CZEI8._TVK5)HTQCdW0;C?aD?E4&;][(&
+7bgI#AR1)KBIL\IQ,&;\AFa@X6/P\+TJ59ROARI</843B#]LUE6f,PU#.W;3UaA
GHU0OgR=].0[ETc7C\V#>1U;dTK_-9#aHc<S=K=NDYHM242VgJ@)CXD<b1gEK[e@
YC&ADEHT0H<[]U]I;6;M&CE\S1C@N.J(bU4H5W\V6DeXd>,WHD,N6SREU/-L:HL:
8GH8a;#F][F2@3dDUCAZ/<8J]03C\T56)<TeeBCX2R.41+?#e?a07ILM(74=W\+<
N,Q?H&6\?-EZYM.8.07cMXGa)J2&R(=2b7:^0N<5?U0C&RM8cdc^Dcc]SKB<<S>A
/ZH##-]-<LLg.be]O+NcP>H&+456TM&C#OX]/34>2c57dI494RF<B,_W#L?63#@L
6W7TU)OP,U#S8c:_+:gMWSH72,YYeTXV.&cP4&TD+PAX6<eV1;H>6W?6b#@[MP:+
+OEB_aW^\QK>2K(PV]](MW31C[/=.Ge0_b<T+.((2JI(PPY5_2KB:G:XG>0-@1,2
IF+7C3,B?fe+2I[P<H8=QYZgQA6eWf[6PYU\9eRF@dN4#\U5<JS27[_F,B\;L<Tg
?eK3R<49SgC6g6?U[_#<7<:HN+50=S891^J,A8144Y4d??O1[NE572:X@FJFJ[CG
W9V:@daGS_]3PBG[(9KP?DNDFYMXY&0C&SW5@<?PAV_fR8S/\SS(aPFK5geeC(CJ
NGISdCf\ba9G]C580<b/O@aEJP/L0f8-DQF]ZYO@J59YT2:PW2<\>JX:K.6g(_R>
163J\J,eW+V;8D_]Z;ZT687:Vcd+gbc2.5bdW>W-)2[bX8KfYOO[(QgdKJMA#AP=
3QVc..&NOLYgUa&bHB&9ONN-Q6A4.GeSd\\ZRg[#f?Q#dKWb2:4e;^GRW4:?4IB^
KW-/80Bf3f#JbB6\]]+Z<+T-=?]Sd8P1;b1N<EfQ]8WZ2#@QM,#\M/eT,]XLg\.3
QCB^5OLK^A:=QPW7=J-Ng45X+SSQXEHJ=C_X0:.:##<([)+BNOg<[>XH;<J:A37A
Y5@:g<HP^<Z-J-A=KV_P:SSSSYM_cDYZ(?1gc=8S-g&3YLWVTSPYT]FT,;:W)&B5
)/91UK)>&\Iefe#_3[,.I2^6H/JN]H87(7aNF##2Z.Y];<_J(EVBX-10G,83ZH?Z
0(B0+:E8I(](a.EBM(0?Vf(S)4[QB=aOP<B6g1L:d@[OF[Zd#19>:]ZIV1&+M]./
LK5fG^-Ue/JO[+3#;00?<(G>g/XW6_/f<=GIKbBKD&J-=44MeD:J8.798M#]R8,[
P#MOAfJK@Y],,LJI42>4ZW?]A\.2L6-?TEY8C0^]1/AVT76OK&M-8N&a\J>LF61a
9ada<e#^RFA;I<4;SB@JV6=a=GQ[\#KO:05g6ATOH&698,@V[MfI8dB<>6D):@ae
P:H8:XU>&\#-#/_3[cNTP@B;e0F\J@O1K0R+AMO^4T8<>,)<>IQ-0T,ETE@3@D.U
Ub6g;;;?\B.,Ug8,c51WbSA+&YKW\D5.d]&?f(TaA];T/9+8.bW7/9eF[YF3FK_B
Oc/R\UdFM2)W.0Z<cFX;UcUMdQQQYGa&^/V(2\<I4O@MYDKU.^XEbJ;(6bTc4?8G
6UM)11,aH&Z(^YEK\3[=,54(3@/dc^H\G;Xg(.8-0\feXH_FT-ZV(Zd(H3FJ&gE=
\,(=,+La?4?;+C2@T(c3X^>6#-b.#S+^cU>(6aJ[ZGRaOZV]71O5g0K\&JV]-BUU
Y3&@^@C\#KQd9?6+^ZWPIFbLMCC_NJ8ADPaUTASN?]d]H7&YcP.M9^0BTW#MEM;6
\fCP;F?-/QOA<2eb[ecK6db]OTXLNVFaN>0cJ.UWGeN>]d>V_e?F8EY/d)2OQfg/
f+@;_47VYP<)/MN?g5aA[NL._g9&7H.L_6I;NPDJa8a(>H8.c/;^R+fR2MYgQ/F<
RI:Xda#4KJ66=NX>AC-=_0W\:P2V>^PBe/C6Df43VZZQD.2Og:BcMC3&A8d5@D3B
.N3VX)g8X&_9E,Ob=)8>baWX<J@BBdT<^P&JB@-e@HX6:;EW0S1LG.4AK0>W2Df0
fCF.8.6Jgda2)RZ(^[:NP=-I-e0:+KS^206R.?<?f,e-f0J:b9:YH,ZGVVWY#^Lc
P\&COA=O@8-+K&N>N0A?BZG;\#54==I]?4.\95]W7_/8V\7[IWC8JP&fH30D,MbY
c(KBD6B>4+RQ:;@\V#IeE0OM)eNcDB.F<]Z@Xa_1a[,KU&5aEOGA/9#:+^7?<I,.
GOd9Q_:WSYX/^V.g>CFTJZ=PEVH&H=ODS&_2J4J2#UR7Yf-_5+ZLXcK.(SG(VDaV
@FCVZ/=)XgI2fgZO:2VS=M5<TOe?_AR)fZZHaTf&?Gc1O<K[B:E8\THKE4ST[I//
<4K[Eda/?A2:ENPLKU&3#43.O)a,2^AcR.V2TH0:R0Af16(>4>-ZQUe_R[ZCc0[7
P?#eCRD&,,_c_2Y+;Q\HN;64QXTY>GFPaH4TT/T;Dc&;WP1_TQ6IZ>Tf5L@)S-4C
6H)]]4.PMH&F&2L#:U6aF01DfLCc)OH]#f&Uc+19/Be/LZ:-&][dQ+3L@RK^CaBQ
2)7L)LNEYW-RQ&)?.)\:=G@Q0\a&[5]DTV#6&9[T#FBXHcV]UV0fEF)^6(FE#AK:
K14+RBEd[PbV(6DZA5g&AW-aA=#DV=_O@68.X+6JY<1]fKf?P)POMb31??e/Z#JA
<NR-b4=Kg>QZQV,AQDW,9.4a6_=EV5HO+_+Y(7VcOTM.X:F[2P(KQA>>AEc,d;@<
Kb,57>g&3FN3>3VLI.M_F<C/<&;)VXWA=I2bO(db)aK+)6[T4ZCYTfD;a1UYV+HL
PGFdP?WM8a>DIH1;84aC#W>TXcace?K^/(?Z:X:680D7;^b?-LPQ=(g0;3Ma40+O
M6][WIZPASJQ4eS\fT,9D=@QY.PF3SOdDOVS8,KW\F+[Kb0FQ/317+bcaK=_4G\#
\7R=6=1U(0H-BF#C?==;gM-e+Vd\c1K2D7&3_AA7#9eYJ.DY0D/DaSM^\]F_^4.-
SF=g/6?UNE1FEVLE0]7T95W=,SBbf[KY^g1:5V_]_ZBC&-&EfM)[eZ#-XdbS+-^4
_8[.EI#U\[TN\-X&Z&cCT9PVbP<?)GYD@ODZ,WT._9cM])CHPe^f5_:#KAQ1;-S8
c2>bUD2A+\I?L3J.,9:R88CZ#>cFN(:7@AE:AQe13XS:c_(AF5+3ANG.6XC9\(NA
J.6?bFO&(QNZ1/Y>H^Tb>XdX?\M2?f^9OL,e;,/<?:8_,2U:Q\=P)6<,dVLLC?/6
E1\J8_]H^R6WL.:DK]C##0>C33YP=07:V8dU.g#IM7dgNB3PQg[dVf]1,]Z&Df+A
1dM\aANY^.bV5U&OF,dGR@R8\<(Ic9C=BDA-Z:6BQ1T+L=^\GaU\4a/7=4MH_+M\
;eH15@OL.NI+5M_:<>/G^0<PTOd-KeK-T]+2AA46L/-?OS-a?)8R)>46SbPY5_A?
.3G^Af_/gdC2,GcD^9?#gI3&HO?6.CB0Le+:RC1EUPPCeJ[@;-5FM]UJIb>6D_0C
^,I@JP?]1=^BVB86@[c>RAN/0GDLVOdP46([a-DETTGB\QQ8SU_+cU^>P97P\CR]
2MD-W\D1HLS,)=Q53QZSb3FR:/f<DfUHB9BA<K03HcH;#52E;c+A)A/g:4UX9XfX
0T@0CD;BRLa)+HO47/+PRB-WDa9]_KGbRRY@GUNEG4gb27KC\7ZXHGdfY3ba35DI
&=XI3&>?D.@>T,g.C1J+Y[-XO?H7^d3PV2M&C_.a\5::Q_:A>A.9(,3<Uf/20H4O
g38>56Gd5D#:,1MYW37J\#fISOX9FV9WL?#-d^Q0-0S;U0V8KE1WbB\)2BH1cS1X
WSa4B58bI?gcd(/4>:[?#OZ9cZ0ZE3GZOd4,E731\E.0.+U1/=K.Z+DOK>eL4.Yd
A</,f-gRRA=/6/D\70_^7BE\S)I?d,/O=&9+0e81)KQTP]Rf^QgU&cf7:Wc6_S__
:I+UV<6VZJX4U_T5Pd9GL1ANOPbA^Z4&.0[-S>/cTTM:&IAJg-(f<U#EINR)]\Z?
Ya:;6eN39:_W>-&]+(;ESf];J(C_AG9M0aQeQD3FRW@FeW:S==J(<La7N.LfWC?#
+RE><[/4RVeF9eHKb+U&ERb939f&@IZ]HR#/97Y5Zd#^UGR7>6d?VR:@bBV(R14a
9g.DHc)]7LY9UQY2],PP0L24>D(?W0R-HFS)8W[ZETbJ]U:SREI(f,M/_6R9[0<W
>6g7;b<+5O[5&(__&5eF_#DFJ8cGO):aa,L#f9Ie3@;B5\fbKR3?2?E)eRJ,PEET
[8?UP_\+)GBD]X2LUb:=#?JRY/83=G1,VcbY8IGc[YH+.bgTCE17.H:Q#cX?]@-/
Y2eDAH\J.#Ob##QU5ZRgH3<C&>e]If0bF2QAa;+_T(PSQW?Z:?CSNH&a.HW-<RaX
U.UYdaI^3_,.9(V\=]IB_.<_G6f6eTFd+P\5C(dY=RX;/cMe:ZEaKU31\.N88Y]I
O-X<2#_AGD06T:+/e;PYP-27fYRW,gW6B?e1^JU7b2BY>]TOW37=K@MA=X8@9),1
0Oc9&T,B=3c9WV@5Z_4F9.U&BV/#Y(K9cE.HY1AMMX-N/R)B30:\bWYE5Q57G<:;
cWHS;<O&Z499g1Z6daQ5_eXIVY-24.G,W@O>aZKHR,@^.D&2gAFL;Ca<6dGdeI;M
J-9L\TGM?Mb02+A>SC,Y^__S>F@e@MNEe?^3@aF7I[5&C6QA.MT)W:42=E32P0eD
I<KC)O8B6EQ6;W6GG&S\U>NY15+2L1[]bTJ]-7c,XOQ)]LWe[eYCIHdH0W+E+^9T
T<28PG]RY:VR>1J+>@QO2U=)@Mb:72_&E=MNDXPN>VXU_4VJ:MIaDD]\O30#M^Y.
7KI_1\);:?\1]U0M;b28gFU6_TDaF]a+&HMP?W0:]Q>;W-<Y?_+=fDS4ZR(@0J]Z
QW\Ab+\:81Ae)[X[Q0_&8ZR>FdcCL&Z^X<F7RP&QKF/Td,?a_9e?N]L^X.&VOK0g
XFU:[G<X.JZHKLHG24VdUa#+@\-X9f>eG?(,Q/Rb(<\eX/#c#4#b<;=f99gH,6CJ
/M[)BH#gI^3dgTK9X]4;Z4\X3K621d.GF/OU&J3d9eN7@RcfCc_V8X&9,ZUDdJ57
=X#CDg2BS@N.M1JVH>,5+4He7PPVMQ2&O#@T;6@^N-,D:+GZSV?BJNaB36)B]/2S
E.@L/>=K;+Q^C/A?&2eT#W4#c+-1;W;1g3ggd16_TX,TU1L<c\J\S]a0/K2e]U/,
(,Z&Ka-)TK[b^8REK_12Y/3EgWR80ZA^R>e])HBZUEgZeQ^PLfBdK,;\7<B;6AVe
fI]ZD8SIVf1N=1R5bLAd[UAf[-@IbC)Nb)7L7YDOB0;-0/86R[[1+R?.WX[0HTGa
1eBaZ(Qc&]DHS4dg(D=,F&be^5cM96f_5?ZG:,;8fQ&Z<,QSCZfLb6G<-gcA-FVF
,ZD2V=NXggT/fg/\g.8U^XMQKRP#HXeH.QAIP?(H]1cKH>.C#15]9)6#@CA_8TTN
E?X:RH>BO3G)8Wfb,G.4A9GMZGR3B&12S:99)),.VPb/AIFK64cgIL?KcYX-(R\?
51^AW):K8&-OOcW.5R]]^;0,-JJ)\/O=/>6?<06^Q+\<:])6PNd(&5]5R1Z1/2cc
ABYSZT.4CK0LCf;cF;b;cd+EdTME1#)=5.G]]6<J:;]/\S2>f(+d+[HRY\6OZCU4
&].IX8a??)B)bd,;ZYNM_MVJ;dJdH5Yf1dWfBPF0JRa9\ad8fH[;(;Z5T6,;2/KJ
W7WeBRASeb8c>K@Yf]ZBeV[VG9\WJ0a=^>4b3)FaSQRC)geK[.ZHY(24HgX:AdD>
HE1.IWGf(G]41MU4&K<PcT@-6R<?W2#\e-Heg1F.+X/B91[cMf^\X^\X7=[d#O?d
FcRL.B@B_?EUD<.3UPgO^+F;9E\E<TNA=KV?d?b&/XT3C;d.<g_^28Qb+QT[4MJM
.FJ928P<P?K:<OBEBFIcD^R3R,1;&ZXbg]3PT)5,WBEX:I:QP\^f\&\a;G=:YM3.
^Ib#)/+F7;G5(9SG;5[ZfWY48J8W7M:O+7.ef@9-3,Za+Z_/4N#0:YMZ]?_Fc0dW
=Ee<PJBZ3A<>Pe&2@&-IJO05OO&EI-O.5BUK+/,\S[UbL0;?U3U<Be(H64A2JXb<
?:[HD^JUdAX>^bV]b;=V4R@K8[7,faQgSdR#\DU849>H++B3UFc727E\ZE?LS18W
6SZ<6+;UD=Z?_e<&8=7;(gb/IR9+D_/XO:bK[fMPG.97B(<QT08ICT-:>JN@A7Z+
H2Id)2&)[53d8FOcRO_;?J)BMB4d.7fR91)(2MEG5aCFbLcT7;dCD?D8ZH8I7G,9
0-Q[W^:,[^),,e;gf/DEO>a3YG_WZ#?MdgW>/^#0K[ZIHF:?F4J68g/:dLA]1c[N
c9&SX<0F@DC9N0U\aX>)f/XI@])LNL[E#3gL)T#f-]ZFRQZd2FGC]OaKT>1Z@S=Y
^-S2J])PQTFQB=]G2)W3b7OLGZ[7YU:8FNBf9N28+>>I>-g(UQeL6FEI29_2N<,M
I4b(U/9geW_bbJ\M3Q::f>O4_#>06GYY+=Yb<aMT?gNCY,T_WP@PRY^cM<YRAg[Z
WKGR>2/U@YbN6QUDXJc^-]H0PG8O,5\XP::+^3Rc+2FTF+8(#RSgX:fT.9K+8G7J
&+J1H:@^/Dbd_VRZN1JM/EbTb18G9HZJ2ee:eLSPKM2[a);MTQf>[<9g<T4<7Q1-
NN\Wc/<g>H0&5Q[;YI7GJ#)=f^=d8@+g;gcEU@f5ZWRAeEaUG#@;3SO4.(cBA8:]
L\.#N>&dJGA/ZU8O8dI^&>\69V:DbT+&0f#GG/(7&8dTPS?D_<dWHVg2b9Y)XfU4
=5.4g-0I]#J.2fM/RI9Gf/C&XeEO?]&+:=3,TK7IIH#.+3@N&.EX]16>#&@B;54[
WFP9A@&(ON]:7S9P(c;b90O@Y<S#W7Z/WSZ+.WeReFVWB5H[VaVX>dXWcJ1I8H.f
G3BA[.7:^[Ia[)<LfU^5(6)]_.=0\dL+\L&e5=?>Wb9HVN)e1Sd?5f);Y,J@2^8?
2IOe^WKB;8eR5T<2RO-?D(BHA&\J6D#.#P-IZe@_U2JID]V]K>P6LO]cO3G7,_&8
@b>;#EST^a#R^UQ7-K[g3H_a,?9.54a<99T[]T5YRGR+G1;a[6UZY5bB\W_U;ZCD
2F>gX1&]+Z8M1NL7+P.)MW[8/S<K&[E@;G.+2#7b;BZaA#H,c?D-NJO:4XLBKCff
6A7#3_KEa_XQ6Ba^CKVcb?F:EJITY^Gg5X@0E?<aWd,\SJH,THM8QF969-12#3U2
C\>8-;^e0WRZ3B<;\4LJV2](6@^d)N#^(;EeQ0]\7&L\-dA:)3#4>0f^=9]RJL[E
TRea7<6\G^VTHB/=M:-:+OHZP)L&[GIF.+\Ia5#0Z6,IM[GQc?:5<G)05X-\SUKe
H6NSX(0-@WG>RDNSN?J,,KC-bFL.JOLYP8WS3ZH(F)dOW56IY1N_F3H9cP7WCQYP
(RHJ04=V\bNZ]M?8=IF=B=(f@1/dWI<5eH;JK+)a[/UOB8<0D<M7W7()@N(^4b)=
+GKc3QdO8@_1Ve#0DaNF1BD+EVG3ULOef:a&W/4J1\()B+8c-5.NMWb@8fb[W0HC
(^MLMfaB4+\GY6X3#9bF1+G=cJ\B=fBKQ0E-?NJK#ZL8g4deD-0@.b@[PM)dO)WP
0<#YUXJN5R7^G>[cKOfK2+P?=C<.IS8bc,ZVGcTR0;#U6I?1BI&d<^:NQ)L&aWEb
#.Q5(T1+9S_FCKKQ3)ddT_b:1=H]^[N?E<H#fA4#.@bBBLQQ&GP);RGS7-S>KEgN
+\e39f4\9B_Z5e#139,P4Y<&)WT&:[ggBeZJBPP89bF^:(&&[[FFW&>f\8Y[PUUQ
GaK(cd&-/F4&0JCeMJ&/DJDN=./\#c(6@WbZKH.,3@LZQ9.YQ:9OH1E[TNZfJTNI
&7X]WW?U.Q3C<2#;aXOO@-?N\?W#_SN=@HZ0)J@^E(SZH1^dD?:M2\@^NS\2&QJa
R6;gYGCb5KY37+/f#F_3\=;OZgJ?NM6#L^#0,G.+Q01L7LKZ[LQ/D=CGOTcLI;Y0
6..(b0?bZ-]g/<JG7g46G.KIfPEQKeE_^(YC1L50e)UA8<NXC5;e=?=WT0,B9QZ#
43>f79fY4<&(WOJVEc0XD#^-G-Pf2+<P7f504-[aE\1O<^/=b\aRJWVdP#,B#H#@
V.MYM>&;[,R\DGAf]Ja^0=HDGbb:eC+9X\H-F=MN9.\M<P=4T@fb1S2AS<GRBTTg
65J^))+J\@E2/H\J<aDFJ.676Pa-EB5F[#d2eIW>]>.Wb^3LGcDD@AaEJJX08-[B
@[ZDUYQZVV;;##g6IGbYSRcY.(JfH#e^RebA3^\dMe^W:U)_-D(3NCA&[KgV535A
2<PU+:TOaLE)^dC]U3^XTMGB)bG7Y2DYR>H<)cFRB]=OP]9<G]TO6gCc3DG59&f&
a?/1J+AJC64cdOEacLI)RYP/0dI<gYP54aLTOF_P0)&K32.]+KeJBY-KZWSTcFZ0
Udb4W:4<(fbYTHE)QLC38S8FOP7\JfMNE]=>]UIGQc,TKB-H<VA:8b/.e:MFB-:R
E_@Gb7RX^b@[WN8,2/S<O/W:\35<;e]0?feA4Kb\/29bF6e2(#+=@MC2(a?=3#]Y
&7+2g]LZDRbN^H+Te7VGcU2F0c<gMgY&H/DZ9[-LEdfAZG52ZbZMS&GRJ-&1-#]5
Z3>eG=?#0OL>/5Nc)Pg]&4P48O&OGg>N=L<)c^/##IHbH]QMbZ+3I#.IF<S.-Lf_
#48_;cUZ0.&+#Yfce6FX(?QEVEX\84PN,ICX.@H<A2,R?DC)RgYM>9&af)L8Q_Z#
^^aCHB]:<1L+,$
`endprotected


`endif // GUARD_SVT_TILELINK_TRANSACTION_EXCEPTION_SV
