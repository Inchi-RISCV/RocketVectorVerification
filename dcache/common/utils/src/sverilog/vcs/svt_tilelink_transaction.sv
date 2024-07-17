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

`ifndef GUARD_SVT_TILELINK_TRANSACTION_SV
`define GUARD_SVT_TILELINK_TRANSACTION_SV 

`include "svt_tilelink_defines.svi"


// =============================================================================
/**
 * Tilelink Transaction class.
 */
class svt_tilelink_transaction extends `SVT_TRANSACTION_TYPE;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  /**
   * Handle to configuration, available for use by constraints. */ 
  svt_tilelink_configuration cfg = null;

  /**
   * Processing status for the transaction. */ 
  status_enum status = INITIAL;

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
   * Valid ranges constraints insure that the transaction settings are supported
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
  `svt_vmm_data_new(svt_tilelink_transaction)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new transaction instance, passing the appropriate 
   * argument values to the parent class.
   *
   * @param log VMM log instance used for reporting.
   */
  extern function new(vmm_log log = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new transaction instance, passing the appropriate
   * argument values to the parent class.
   *
   * @param name Instance name of the transaction.
   */
  extern function new(string name = "svt_tilelink_transaction");
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_transaction)
    `svt_field_object(cfg, `SVT_ALL_ON|`SVT_NOPACK|`SVT_NOCOMPARE|`SVT_REFERENCE, `SVT_HOW_REF)
    `svt_field_enum(status_enum, status, `SVT_ALL_ON)
  `svt_data_member_end(svt_tilelink_transaction)

  //----------------------------------------------------------------------------
  /**
   * Performs setup actions required before randomization of the class.
   */
  extern function void pre_randomize();

  //----------------------------------------------------------------------------
  /**
   * Method to turn reasonable constraints on/off as a block.
   *
   * @param on_off Indicates whether constraint_mode for reasonable constraints
   * should be enabled (1) or disabled (0).
   */
  extern virtual function int reasonable_constraint_mode(bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Returns the name of this class, or a class derived from this class.
   */
  extern virtual function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_transaction.
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

  //----------------------------------------------------------------------------
  /**
   * Does a basic validation of this transaction object.
   *
   * @param silent bit indicating whether failures should result in warning messages.
   * @param kind This int indicates the type of is_avalid check to attempt. 
   */ 
  extern virtual function bit do_is_valid(bit silent = 1, int kind = RELEVANT);

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation.
   *
   * @param kind This int indicates the type of byte_size being requested. Only supported
   * kind value is svt_data::COMPLETE, which results in a size calculation based on the
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
   * kind value is svt_data::COMPLETE, which results in all of the
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
   * kind value is svt_data::COMPLETE, which results in all of the
   * non-static fields being unpacked and the return of an integer indicating the number of
   * unpacked bytes. All other kind values result in no change to the exception contents,
   * and a return value of 0.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);

`else
  // ----------------------------------------------------------------------------
  /**
   * Packs object into the bytes buffer, based on the `SVT_XVM(packer) class policy.
   *
   * @param packer `SVT_XVM(packer)
   */ 
  extern virtual function void do_pack (`SVT_XVM(packer) packer);

  // ----------------------------------------------------------------------------
  /**
   * Unpacks object into the bytes buffer, based on the `SVT_XVM(packer) class policy.
   *
   * @param packer `SVT_XVM(packer)
   */ 
  extern virtual function void do_unpack (`SVT_XVM(packer) packer);

`endif

  //----------------------------------------------------------------------------
  /**
   * Returns a string (with no line feeds) that reports the essential contents
   * of the transaction generally necessary to uniquely identify that transaction.
   *
   * @param prefix (Optional: default = "") The string given in this argument
   * becomes the first item listed in the value returned. It is intended to be
   * used to identify the component (or other source) that requested this string.
   * This argument should be limited to 32 characters or less (to accommodate the
   * fixed column widths in the returned string). If more than 32 characters are
   * supplied, only the first 32 characters are used.
   * @param hdr_only (Optional: default = 0) If this argument is supplied, and
   * is '1', the function returns a 3-line table header string, which indicates
   * which transaction data appears in the subsequent columns. If this argument is
   * '1', the <b>prefix</b> argument becomes the column label for the first header
   * column (still subject to the 32 character limit).
   */
  extern virtual function string psdisplay_short(string prefix = "", bit hdr_only = 0);

  //----------------------------------------------------------------------------
  /**
   * Returns a concise string (32 characters or less) that gives a concise
   * description of the data transaction. Can be used to represent the currently
   * processed data transaction via a signal.
   */
  extern virtual function string psdisplay_concise();

  //----------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command
   * code to retrieve the value of a single named property of a data class derived from this
   * class. If the <b>prop_name</b> argument does not match a property of the class, or if the
   * <b>array_ix</b> argument is not zero and does not point to a valid array element,
   * this function returns '0'. Otherwise it returns '1', with the value of the <b>prop_val</b>
   * argument assigned to the value of the specified property. However, If the property is a
   * sub-object, a reference to it is assigned to the <b>data_obj</b> (ref) argument.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * @param prop_val A <i>ref</i> argument used to return the current value of the property,
   * expressed as a 1024 bit quantity. When returning a string value each character
   * requires 8 bits so returned strings must be 128 characters or less.
   * @param array_ix If the property is an array, this argument specifies the index being
   * accessed. If the property is not an array, it should be set to 0.
   * @param data_obj If the property is not a sub-object, this argument is assigned to
   * <i>null</i>. If the property is a sub-object, a reference to it is assigned to
   * this (ref) argument. In that case, the <b>prop_val</b> argument is meaningless.
   * The component will then store the data object reference in its temporary data object array,
   * and return a handle to its location as the <b>prop_val</b> argument of the <b>get_data_prop</b>
   * task of the component. The command testbench code must then use <i>that</i>
   * handle to access the properties of the sub-object.
   * @return A single bit representing whether or not a valid property was retrieved.
   */
  extern virtual function bit get_prop_val(string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);

  //----------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow
   * command code to set the value of a single named property of a data class derived from
   * this class. This method cannot be used to set the value of a sub-object, since sub-object
   * construction is taken care of automatically by the command interface. If the <b>prop_name</b>
   * argument does not match a property of the class, or it matches a sub-object of the class,
   * or if the <b>array_ix</b> argument is not zero and does not point to a valid array element,
   * this function returns '0'. Otherwise it returns '1'.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * @param prop_val The value to assign to the property, expressed as a 1024 bit quantity.
   * When assigning a string value each character requires 8 bits so assigned strings must
   * be 128 characters or less.
   * @param array_ix If the property is an array, this argument specifies the index being
   * accessed. If the property is not an array, it should be set to 0.
   * @return A single bit representing whether or not a valid property was set.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);

  //----------------------------------------------------------------------------
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

  //----------------------------------------------------------------------------
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

`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_transaction)
  `vmm_class_factory(svt_tilelink_transaction)
`endif

  // ---------------------------------------------------------------------------
endclass

//------------------------------------------------------------------------------
`ifdef SVT_VMM_TECHNOLOGY
`vmm_channel(svt_tilelink_transaction)
`vmm_atomic_gen(svt_tilelink_transaction, "VMM (Atomic) Generator for svt_tilelink_transaction data objects")
`vmm_scenario_gen(svt_tilelink_transaction, "VMM (Scenario) Generator for svt_tilelink_transaction data objects")
`SVT_TRANSACTION_MS_SCENARIO(svt_tilelink_transaction)   
`else

// Declare a sequencer for this transaction
`SVT_SEQUENCER_DECL(svt_tilelink_transaction, svt_tilelink_configuration)

`endif

// =============================================================================

`protected
GVccG/Y921DeSbVb3&eRR89YYCJeaD70#]:]V..f9-+I(Ed/?N#7,)#Mg?aJC&2Z
..P3:#E(Kdf)+[<ZU7cdd)-;)LF?ZN_F?<1Fd[M<ea_,Q?,E)K2\<P-\\4YFHXE=
IK^6?P/4/0;XTBceIg4VSMJYD.aH@XcIf&V#fPdJWNLFMB@&3N5QTHZbY?,I=+S#
-)AFFHAUP/V.\7]\.W\efK>@eN(RV@M\dY@N-aED7?31:R:@:I^PFe3XWYK_fAdH
54&GQ(#a((-a3-VW@1aO3VTM998B3_Ta,U,5S\L1(Bg([gU0)[0W>OMeZ/=INeO^
c1\94HT:G^Y_NI4SN<#I&S.^U4UIdRGU21&TCfVVYTOKPMB^J&OA,ZVIQE_MTb0c
,8/U&J?Qd#aPUabW/2P>ec5N1(#?X4>bD)/V84OB<H;7f>fR)2>[fAEfLY[[/XYK
3?.ENH>\b?dCf^W?b-X\8R+71f:4)g(b>7ac8cODd.XW+6E^8/-\(<3c1H5+GdJ\
.?6g7TNRG-b?0C1BEZF^S@3ZHB,egX)f8Kg1+F,DT]FMH/Ca;Od/S2X;ZH4U+9]3
ISCQQOeR#caNJW>DPZ:g3Q@N6?@_=UI(,N[3HgM-QL<X4W-A?\N:c)^OV\(X8a#O
X4QV5TaGLaXR9g[J:Lc^3&e<S4B)G7]E/BHK2]^JX/3FFYa:cPTD&6\Y#[=Q9g&1
9B9F=(9OVU]S/(XFO=Da.#0:V2ZR,=,);QJ<KH8>-^_#3.NEFf+TEQ:67/^F83a7
[7G4#W9LCW_?]#P871L;.A.b3]G<X5XDLd&_40+;M,&(RN)G.\6Jb#dfE+0_S4UA
[(@BE[8WLN6;U=KUIg\1G[/c<f7J\C??9ZBDIN[2Y<9S0P@VK65+cb4/g^IcXIN#
9L,K;eS3[N9UI;aNQVVAc#E3Q).9<O,:g,?E8?DGb+c482PgD\@^0I)7#eK:P0eZU$
`endprotected


//vcs_vip_protect
`protected
+bc_M0SIbT/\cReb3P)T^dXLCQ9IgGVAW,.;AN/F@@dCR-/F-5BP)(2#3dY#SPVP
1K0gH\I5aZR:;+,S<gW@;2O.OTNI\4/I:+\E9+Xc&bDZ5_FbdUgH#X1T.<)33dQS
I292WA?.,e7_/89eWb7bU7O)^(B,c[1P\?@.O0I(Y?:<gQe?38RP[#E(bT.@Y,0H
R?9bU=W8UBF2-9QO9_6XO16R9:-?:+f13Fd2-#dQ&1J++:C,Oa;JA.WE14b302\;
]e@[+)RDNgb&#TLL,c5ALa)172J?+7Y=@IF,KJB2a8&Af7e\bUX<ES:gg\#RTC62
91))M1D0KJY-<[#HI]_MA#_?gG6eO1^G#+J?^8\ag1?@8VR3MT7,E[HV)[N<cN0N
TT2H;),6gW&d+#WVQ:7Zf_eFdNP>).=<D7a+=UTQa-ZKCBEcMM_/G(I1Gb08;>NM
MZ^A+CZ6^#d#4>K,[N)<&@PQ[c\=Ya-LHIO+<eGfDT?X])X/3Y,.g[^33#I8O:5E
C7<Je0gI0FR;E,A5KEaZ\YG7-)/\WD7g-edU9&/NPdf0&/9<:U8AH<M1+@VBO:>>
=:)K/^S@_+7=^[c=+#=N69f[_>8#+_JR1F60\;AF/=AZ7cHS[;9N?<gN_+OdO@+<
WIcJR^--KOE]JG[U+Bb6JP.2_&E.?:BQgOV.+OT)_9D1A0+R7aQdWPH>BLc@YP36
,FQBCL^70\MQ<,2)/[@8BK7UI([]<TL8M32(BEId,,NIXFP4d9M.&FL7a#\?c9P;
8=gP,aJfQ2&;.]Fd,7+^+g0RMaP,T-<A(fCdB8/geff?7a3,c[dN,[0KdA7c3_P;
(1=0W3I.]0M#[:4\&\3S77#;>gf?VQ<(ZNP+[@1g/Q:+BW@#McU)649\;K[SN[_U
T].(;ZO?LK89UcGcDTI_\:@-EP3=PdYcNb50[;6FR>CDMA^=L6CA8A-OBVfC+Ef?
S?Y=(R:ge#VLN?=SDOS_d#X8(G0(ZdVH#eQCX60VE9<T3MLGATUg)+N?+cTKLY\)
7H&WDe;=U.@XLTXD=/RG.YBDQ5C)AD9/W3)Z?OX-UTKA/35@C5I\O:A<Ra(Q)4QR
E_bGUS,Kf0V:7BKaIdOIfM61JcZXOXD8=VTADc5BbY(VE2Y?5(/I;NDX\Va8Ld/c
HDF;1fcLCK+KWP)^fV]KYKb&c1J@_#,a-I7E@/6G1\T(L2f/P=77QIS28M.2>?-@
Wg]#[TZU\2(J&aRG<##Ja^T+=UI9,-T#[1ZU;1DW(b1D#b].A;9ZYbC6U<KLX]I:
Ndc;HL<4eVgDPU4C=R)/DeeBJ/V-TR^W\^;5LWf>\73LRbBA\?8b76ASV.3Aa]a:
-dF<YA;\MAI)G:.J9^)>TSM)UVa>;f:WUI/&EP?85Y#;c;D0/@;KId76)J?W5U0b
D7D?/CgZQWB1E[0V2N2Zf.fP[>P1/fSMA_d\e]Z-712gg9WLI6c2D]Za29PEa-c3
HQJ7dTBL?<TQQY;E8--^MQ_&N&]/@/d_e,TAE0\.A=G5M\_>LCNANc0_(Ybb=CCL
6I<QZCWbKBXVfV?Jb@^c<cJ897_8<X5K5dZ:@3VLeHJ^5)Y4V6,b.gOY)M#O[L.e
KO>cPNa>)F9&29\@Zd8,Q?+:D+YBN<@>\[5c@\JM_R(@cLKMJW:AQ>9W>9FA?>aA
CaBUc50D6Wa1Hd,PBgI_1C\A<-1PK+@cFFNVOPd+8QGeHE4B=\g)IJb?:VS(G66H
0\]#YgAgeC.fJ_&^M)3</\B\)(?K0&#@,Ed)7N78G/=1AL)8_/5R5C2(\=cJ8B#E
OCX(9@Q#U.bC3@V112Ra+f^84HDL1^@KOSf3d1^31?7?4SEMP>S<0S@WHQT;,&ZL
7I,03=B^BBOb?>XDZ@P/#1[MA<//WVQ5@YSUYP+I35^AUWX\\&@,A8dU-/bJ&W-C
,:^c2aM5GYg<#IC5C)\Ig3RS49?0gb/IVX/BfG8J0cff.b>::CT(FI0KJZ]6_:W@
QDPHGDTO@2\-Q/R+(AK(FG12MRHYML+9S7#>?N+DG/K/,)5-gF<I&c+LCFGX3EY.
AQ[8/ZU1GL.R#++62]&fK&bbSP=a5D(WQ&?V)6HONS?gK;S##bFF&06gNO@]U3M&
[3HBHA[0X<+XdK^g_V5YfV=[UG48BGPI<N-D?A/QNW&-\):>IG:K\7?LEKT?g]8#
&g0ORFc_7_B9RN9TN9G214eZKV<RTFeP1#TNZYN=YHc+E#T@f3VWD<@(?0?YVF#(
.AG_6\62O38\YHIGVDDf=L;\d(\b-,eVL._+RRG1VJYA1#082H2=g:[:>&OOB94/
&]e8&PHG8R-E^DcG,#4.63Wf_<B\c_XG,2AE:3[B]L@Jg=N\7QZKGB\dROPW6J#@
2/Qc;A&.^Z=D6SWGZ67A@D?>e\F_ba5A(P4851e3f7>-QW),K\8MAS[;J4>/F=9\
X?/PDT@dHE1VU,W9;J1SQRdIL[7ffL@AYO4UZY207M_b\3dSDY++:LA4.d>J,Y\+
_5.5Ebf:MdN8L),gGD31#aBGR;C.,4DBB_X[f/bb2IH;/X,/Y1,3FYB:-+d&)WXT
gTX2;3.C3_)H^\:QJ]bae735QAXI1EUWVbGHb1-+b;]DMWdaf#IbKC7>KIQ@6T^;
^UHN@G9M]#D#P1<NCIO\F(N;-S.G^#X.3)PH5<DRD,B?+1ga3/B?P<F3A:G>.Lbd
0U4e[)C[Z9/\T-8ANH4H=aHbC687VJCDSgf,Y94L:4)Df=X>:1W107#:[g&21fdS
?.,V^GVDRMWfAd6F>NXO6Y48Lg63caWI91b;6&;.3Q9d9c<MT(YO2d&5=V3d#dP:
@B+P]cJS&NH7QT8N@IZ[EgZMO(:5ET?ad6TWPN0M^4I7a8Ea#CFVW7UVB,eB:fMW
[S4V;6<DSADa_IL,PAZ\[be>>JD6,gHV3(<D:L\)?RT1:P(^K7MQGUfM_bQc<6T1
5D(:;#3:25;NaM@V#J@,a7eC^UR?)3Z\5#9VTa5.0aGJ<BI,HI]<O/3TT09\<C=K
;L?XG8O^,LRDVg/M?J:PI5C6)V[)+S1IZ?WMB9:8^a;R+,TbV-XKC@>]>-/=^(/+
GRN#C<IUeQV<]0\,FOHW-ZZ7<@I52>XV=36&JVX6?##3)).LMU@BHY5_EHfUY@V/
99IU_.XI)G@^NEaJT;IU&c#B@f@+H[&Y.a#CE&YU68PN#/NXQ>+^MHc+8QXN[/MK
\^&4.,XGWWKXCO-):f-3IBfE[_MC<c&DHINXN^R\R/1&[a&Vf9WFZ_a#:OVC/X)6
+=OK\6/F?YW;O.[ES&L-).bfK]C7;ceIF,-RTK#J58^cf17g-/R^N]1_X]-.:+MD
>)UJV36#c[L[N^Q=PM6_dN5]4[C]+,6<GD5]TS)_EE9NF4<0+@):6897SGPU1/b@
6X5\;<D&6QGC+MSQ6_>\9;@UI+3T)1_+_d:DW/@T)8LY\V5]\EVaeQ[_O,+?Va#3
N5WfGd8KI/DRRO;YC#J86@@a6JD[:4C;TKH@UXc&d/=R)Y5@R@\cLZX05AA[C7ZS
6+fC/B]GPH=>S?C#<Y2VN?+BScg#1W>\8#W85/__<UE4Jb9/Z,IW8];&\)DNcGHS
FI7[gB>]L8K,?F:,3YPH2[<4)>/@93PYO>d)_?#>+9AEF6A,07X]H1V9(@82=T+b
(ID>\6H1Z>?OR:M73bHE</=WRV,IF;N_VZJKLL5>PfE(\LZDEAE:-Y#\9U\@,;A@
N(.<c.<W(D;g(&#gXW[W>41N_e(2/IIY__>,C@,6SJJA6[0cEcR=38G>@Ff+]SUN
4,d6>+Kd&(+YaI=O+Q_^H2OcF]8P\381=1fU1dEDA\G;VB>-L4QIBKZ;2,\c\@Q2
<FPJ-__eC,\09>N)VL:X289F@(A.dJ:V,[bb<(A5<<(GILc7W&^2TFag\L>-6V/-
bMR@].b]EaARcO01<ENIJ&d]dUKFECf1]F_>JVBEB\QgZaQ:0#+7.&)1IGHO<&+T
5b);R5MG?_PVD6(fD\6I:BdT5Q;(CM]\U4NffY01a:?2OQB,NJ6>-&<I7H=[:7c]
ZU/HCH<Xa<gdCIDFRB1_A@1bL_3A?2e#.6@?<1?V[PO4\:)ZgX3\B8M;bcNZ@/=2
gW@9/;#G^I,?UYaW+g(SUfI;28LR_/-QN&BHX+bB9XALA0J)OP3gV_U#W5]5:gZF
#I.BY/\FgY2E8J:<HX[;WdN<\aZ]QZGOGUb>>-M\LTMKFH1GJ2[X^DU@a2P5((.,
\YEW[eV;49Z+<C-JI(-_e5W=1AID1E,gC@?XPH.OZ+0>6>#E#&b/gg7NgX\J]8eT
Y\+^<E;A(daC]6R&3b6/d<&/#TAIPXdBSf;4]e=XY3@JP-cFb?E70UASCGB1;cLD
3TfL)U\<9RbTN9XWF2<GPU[fReMY.Y?N#f\&C44b<Ld21D;;HY)]YTK\@5F&>(YU
H>7T;=AY56C_gAFQY37BQf-^;Ieb_5OU=[M\+5_8\\T#>)ga^E4_H]KK?SeZ94Dc
SQ9S4dH7Z;]:F[YE-^+:Bd_&AAZW\+RX^_?>0.a>Tb=P#>VD]W?,#=:T1<<eb9[<
UHGBg(<H&I.HPE53&c;[&WeC;C.:eb4U#GMae2R^bJQ(4/8&DC-:+H6N8S^bCQA2
G<65P&\8HN5VedWI:\GW/gS<Q./1&Y083)<1KUWeDcDC2[F[9>Nf+--ZW:d\@3T-
XUDL>)V+(XP]a=02=YZ+-Ng7?/;GW)g79fZJNT:5g3/VH<G9#MLI>^]?ML/,3V:D
;-ePUJHCX(2:>WXCN81N=G@6cG8BZ@B8AAJW8+Y.CEP(gZCQ21-@fa=MF=N=?2PR
;J/YQfH+<K@13QRfJ4K&OSgECWZfAL?6?&cD(=K.O@Cg1=\;?0<#T=,)H4e)39fY
3H?<DE\.L[K?OKQ@T9J:0bI4,X+JK]Hd,bA#Ga&Y.>3bJLVK>P74Q6I5.2J)S0+Q
2KJ6a.=E-K#30a:X:e472Y@QA\fJM24b)BFFJF?I.&RMcFMEEY/.;5#eP:7Of>c2
AAKKg=B,d..9fB)C;<EeRYVA@6IO[8Y.22Kg(T1gC64M:B-I/\/J[L^P>ZC1:6<#
D8KIP3afD0XSH8N[[WC=OdZ.LI5A0K+K2_c]T:62J16W(H&HV_L384,bKg,c?S3N
)MIIeL(&D9aPeK21+;T9I]E&C?_=W@Q\BKD3YGfJIAVg?Lf\+a#(CB^N1@F\_eBJ
]G2]0D_Jf;RSBDeK,<MR@Y=cHcGHc6))6O@D9\JF5T,5bP8+a0S9)?X0eWf;3Zb@
F[JdDL,ZX15gL\;[eA-_T?(Y\N#agI.^=JKSVHB7B3,6MD::9\?:,5<[MEbKNCNJ
_/J6cfZ@I6S+J27#Lg+D,R+;,U0f(g.IT2VX=)_5AV<#904T+4TW)._bGOH4g<03
_-&4:/+:LL]HB2(UW[D7@>d)#7#0;ReWKC2ET?;-(+JBeXWeZ-;K_4L4F-VGX^[.
,75CPF=5HfTCV]E[:=O9\6KYeUCb8E4TXI9f>.H:AL5O69F16]S[Gd^UPb3TRHH\
WM+a5Z=aeQ32a43,_\-baK7SZ.9_CUHDD1.#W?H-^#+PJG1gbCcceg(.5-?c<cCF
H(dLHLH#8f&P7/gbc7WeW@TA/HL2cRc/d,f-Kd9AX)f3D68b4SR,A9KFK/&LagF)
+YV03&Ub6I<VNEcK9-Z<3F,,:c#KUO9dgFB)D<.FQ@/M-e)58/W9d;^FfS0RQB\a
L_eHZ#Eb2Ig#e+K+Va;LbPUN0b,IL9cGY8PAU4807bA)O##F#GO8(3:][:F@;E;@
@MU[J#ZT/5a^g@I5(f#5.bgJ>edZ/I@fOU>.]b8X;A7@AJK<\8\W9JK8/>6+S6?[
>dKF;dI:@FC3J=M[1.Xd85)A#ZW4MMgdB/ZYa-O#[+78K/,&.<Y/cc=A<5JYMBYO
g783,4eT/7#&==UTA5MaD4,=QO/I/]JTGLT43<Z834.=5;3OeH-VeHK@eS=5QM9?
?E0_6D(b[(.&]bf?@2F;HY_>RgH/LVH_aXd5d@^>6(V+#8OHXHEE^UcZRb45]J0_
cXbfQ@B^DJ/,I@dGN2Z1J:I[WY_\./];&A^fH3VGMJ<+W9.76?M&UcI:4(:]R7[4
bB48#FS\^[gMB5+FZ?G[A,VfY+SYI_UR6MZIf__H3EARQLB/[Za9K4.JVae-T0.J
^>,[UN6<I8:e2,&J9SSO5(0F<0D0eLGK[NfEagE^>0-GX_cTgQ.b\O,;Gdf<D02f
9AeeUUQGS<PPI?7.aeZPQ^:[QB9FU)Z/^(3d2IJ/RT64]^_ARX)<bdge(GNX5\\E
[5@XL@^bHV4+2O4G__f=eW^28a4;D7LCfO4bBO,+C5;YRf>\;7Z(f,Me2eXWf<7O
]#JF^PUY;]ddR/g<\;A8LEa[>:F(TLXeQbPWG1R&RUOWY<7YG2O?/<S]@9)A2ME+
UZ?Yb(7Q3e8-OK[>2OY=^.W&dfU/7TV,6&496_E^YQI_XL4-Q4c\>V-N[).>.4O8
.&3TR\=3+T-g>=E6P-?<.+H=-B5Td.;Y&6^Df8d[N=BA5M0;f2H)9dEaGaEK8^+.
LFd<6Y-UOBO35L/.5YP#=D8-8Uf7FgS[X2+a_.V0YV=3KZ0EA?SHC\242)B&6Z^Q
3[;RE4SD&5=JafRYA)GO#g_F>1LB)e)V[X(;73I30,aNF[C)(#c6M:/QTN&_UPTN
C8K#a,[6#HG;bR=XI7_19DLZA(?+C_+6e-IIU@F_g,J\OORY)LOda.<_9Cc3EI)0
=Z&R1CRIER7?IWP6ME0B8:f2eU3ega)&f99H0^cId2KFF#^TZ5;GXI&FV.Ld##<+
M-;#CR(XVQ2+^eO5N1#OYJM<2UH9MSb6/2fDFO3;bW_?9QI5cC//HCA<3TYeVf23
L;.ZNUf]<M:G)N^YQYJb000JAV9BG^9&^g3BSfO=I9I/9WB[7\Uf2O8AZR21UP0g
_B3Y[eM@+>C\;/D(V)/:A0SWb6DE<Oa^&7,Vc)\Cc<E2?5RdR06/fTcT_d:S8)GE
KgW8TQ5JKfH31RE-a9,a7AS>5SgS/(O6a>.d4g<1TTX9T]@AGC^SLO(MW1##a^8f
9<647;L3Q?8f[S[cQ8#.L5GD369Y2#U6]=gBL0U9G)8bO\XZQ_ZQ4L_(SMcF.J91
[4YUNVZdGF4Q&5;/#M1d\:P^MMUNW\/>1F/S#/;&>)@2J.OHRE;S4)<77X#ccR4e
J-8c?U^</[1=aS@@9P[CG)EEU0U]&JI)+5ACO=(N?e+Y2+;PJV0QDEa2:GWVMF#A
L-D1W?Qgbf^DE@/dRf/XVG9g\^H.e&61R89S+;GcLBf./ETR&3X)/(K5B)B2P@-_
,CSeR7(,ND3FG(@2=KO_UT_?/?><V,[#9N5+4HYXXB2IUBXC@C/SAf[KAe#ZD7B/
fH0D]a+6<]K7KE-&.MXOXd8M_;FCZB,LMNCU>-ICI#8<OA=VF,?Y^5e]a8+C;2/B
bfX+JS&g8d/LU;Y6KR11[O#D6W\=f,HT#<ZKPKO1E:W>SC@2)ANZL?B&JA?bc8[O
Ia5N+Ce6fYg?2AN4:YA)OH5\I(eV>14<VSC,GbB+@+78W7V9DBB.La;IbA7&^LPe
C^6NLY?W)^1aX9_,WLQA9eZ7^HV<D/=]X5;_0f(JRNf<EK0<CV8ebPf2MK@MHBDT
Y^WLZeM-AdcZTS@f]AAI4SCK&d)PG+e(VAX9^8-8K]@WN?,X#QGC#@V&9-7,H@,F
HNG6DC#L,dg\U^ZKd9[B5a540D@V9-_<8L5ZJeAG52&CJHMHa<^/DHZ_&N[8\b8Y
?dL7b5W4RUBZOH]-cbE>D>bJ]O)<JL5-U@;aOV/SR&3F1,X(QK@=/Tc.]T&JIU?@
R4d@(8WXT_SJaO&?dH9^H62=DA<6_9_J=6G+SGBU[&-UP=7c5QL#P6O1ccUO(=1Q
(;-<-,M12B&N<N6Tb)/2c,;:8H-P]AYE<OT,=S\.d/UL5NgG4MWHd=41_USF?I^F
OG3<e&3EN>,KX8#FZ72PR;KPf^;T#eCPNE21W.8TL.#g:J>#YUI6TNE,E9_#W0g)
U&)B\?+2HAcV4Lf72VNH_T/INJ\5(D&MRC7[OE/b182VX[;J8M(Cdb5DaFU5Q[c7
=7:ReAPGPY:4ZIJ0V)6]),)L@F.[AS8H-G(:IUJ5[#10(EO&T9V+#7e^N?IMRXf@
fWG:b#E.4<UT2W3TG7.\;7YAVY\b5?_88H:b?WF;=CcWAT<7W_[]5R/0SG<5>HC2
IXCM4>+c101XY<T^2U_+9D/^4B>6/P/4AOI93fMYaaK,PA5&5+g2_D,@aYN4AD9@
?/]0FLdO4^#1;R1]_M\9W5EJTe&DSATYcY8[[KOF]bP_W]VF8?/?A8,-2FU0UIfd
:0,=M717?4,f2[Y4P^=1,=ga1:7XN94MIJ5DODRPPcf:7PA+b:J1GPZC#IPK?4Y0
1OQ>:CZZH&d.(N)c@:M.[R>S=MC\-7,8VY(5I-U-.THH-C2G,3IO6]]&N\L[J<W3
bDaYY.R#E&3:O<,\aRP0^XeW-DcFA,@Mf[WWQ4#_)bXAR57<4_\Z(9DO+B7XT9<F
NT1V?3T)4=4P#7F^I7FF-U>fFB=6F6J;Z^LG)//JNcF8MLSWg^0=,FU[_Q<<<1:-
(9cEfF_cTg\]_S8-J,+4a8#<M[B5JQ@51WE0-[^@^J5ce>C6b.YC,7\+?>Xc5CHO
LI2eY9Bfc;TCK^TA72::S^4X-+b?JccN^Q(5b:1CgLQ4@NDf/bW3IX1cc+cY>N43
PDN&@:;^Z+?f6TCL<1dJ+\_B\c,fCU;44F3JH=#b^OQ1:O-)_Qf7DM<GOYPDeYY(
46-MFd4@38O)[-bWGQU.UAN]>?UN^/#-eFZG?fPf-<8/Q3a-(6U9P(f3.bQ[(#A3
VPUe1O=((\Z+XFVDZ>3cLO&+@SQEFgaELI4a-^G?)a583EWJ8B3g.QE[Q(;&.?CR
18^^WQFKN@;?=7I2&#KAaeg8;#780;LaJVg._F7d374/eXFZ-SGeMf211OD\cB=e
N&,=AcLXfaO;103.D-a.=0BN^cENT>Z(d?4<A.A3fY-Q+=WENJ:PG:&ZHB3KL8d/
59d>,RNd@@<S@[<&0(96?e5<GNRCg1a-62<LI)e_<4He3d++,<1Tf^7?4]_86Og)
)7/6,Tg,DI\gZ8)fIF_T(H,)STgg7I_.5Zf3.)8WMU##W_]-fE7IP6M1d,U3J&H0
.MORU8ZBa:78G[T:9KC@#U:F_</_]b)FB_SJIKX[aR1\MFBM=1].ZNW@&EbT.V6Z
2UC]K,BB9a6QPJR[<@&^7CVS<UcJBKLDQKWXPXRHb6DEFHfgGO4a-6Y_:ME@84Y[
/69MVJ)3L)c;XbLc^-;6T.PYNP[41U2UJ7QB[5IM]&1D>3Ug;(2ZOKZ4\-^RfLS>
DI[C30/EIIB;ca1]9+X)[W=d3AE1+(WC4G>UC[>L3a_0IP@b.JUMZfM;HP:-^c.A
88&1a,TS+/MV.bA8;UaNX\[Q.S[_O<53[YB6[=fV1/&/0,6O=Z4Vc7L)II,L=WH]
/T#&^[Z_X5Ab#ge.GZB?B^DP+AebV0U;8/PEVC6+C>H.Re7/5=f^Q7FI;TQ@)4-+
;R#e_BGEC+,e+.cc<[-A60XSB5)9@];c#C8a1/G5A?;b-dL@+(:8fIcF<a0)]Q1]
_)G2144R&XUV3cXZ=\R-WJ47IGN#2#GG;ggI>d=cFfO_;b4VM=R0QD[E^I\Ae(KB
B2HeE476Z^FQ9feGBR#)_/6bZU^1QcWXd[\V.4F>@4aU)[@?Ud2ENL]86NOS.Y=M
)6+XR98Pa;?1?^0(1LVd-J#dg4c^2c&/19OQ?_,KI=[V+1bRBX,V<?V3ec[Y^OU2
FUVIN<bG31E^f,FFEB6]0Y9Y:H7WQ,f/9SHOQ9<HCIALc4d4)]+H7+Z(,B69MD3F
#9;NY583KT=Y\DOK5&7M7@27(5USHRf62<9^Z1-6[G7R16FdAH4^d:0WTH:18^GL
6#0[bYPH+8=&-=>?09Q(Q3+51/K#9_eZM1D@#1L)YXFMfA=#4C35H=[e=c1S^^.H
(A4F[RLKK3HZMJ8E/9=Y:EePGa]X@geG\4_^FFe^^#1PGU>5=2U-+7-I]f.g3a?A
C+Ff1@d6YYA7)M>^YE9-V?\/,[b]RC98YKJBEFc80VXeQ4M6>+[AAQ7/R2[Hcc&.
0N_NG3_\445:[^EUZ6AA6WT(VJDJN(]\L^D(M<8C7L#RaE0.]9OgaU4d9;@c9[c5
2d0^^ZLFKI;((e1d_Z\I:UXGQS3HXKcO^aT54##5EYW8:P3RaLG@Q[@FK/OL])=8
8&5QBPPT;Md3g\Hb:WFa&I=FL/-F@>4R&@VH,Ig#:+J3=.OQXG(1\b]fI+,6Z(H0
d0DH9\S[GY24+1IgC2P,RXe:<JO[O7)5(Pe0(7H-<d^FP)M=U8R2>.f#=OD[D4Gg
ZLU)VIR\b#B-JH3^XKA<UB5[:JI+DR64SeeOIQb^>Q8T[FO^A)VG6^X.bONJ9-Eg
,18BC).Z595BfKKb\0B=cf1:]Q.SW5=O1WQ:T28<[5A1:)?]B.CO=DE>eI<fb>-P
9]Q;5@H@g>e2AE63=bA0AV.?\H28e6C87:+W0;Q[?H,cE2E<;DT^?Mb=Vc#eOUJJ
HR[a0#EOe(@VP^@8/XeBdeRQ@<T>SG9N2/I&)0TEa;))@G(<A<D7MP/Fe<D>_#I]
OTSRF:A]>+S<:1?G#\;(gYHFSPYbQ.V(RaE4H2KAY+Q&X)=MS(2FgJEKb/)4ZPY2
P+JT=WE(2TL5FJX;8\.ME#^ESU8/-4Y56,./>,2NNML3VWJ1I2]75Cc@W\-=;U/B
01VS[=1;DQ3a,bOYG2+BKMbXFBU7_NNd=],;8J#VQ4U@K3>d;Oe>RM#Q>GI@Uf^6
+(TZA;NJHE\dUa5HW@D<6;;8NWHUaKQ(1W[1<:6]E1bEFS\YVS7:SRgKD\)=QLKb
T5D0NE:(R;SN>U)a;4#FJ[5LRgdK7H1CXL?F_?,YW8]g=C==:TaOMec_GT/U4^14
5(&0LP(Cd\EI&_)e_+TG#>X.GQgIb<+_0EDTEZa--BP]<\T89C=2P;a8g)ASPJ9]
a4.bgYQ.XPKMLF&J=[?9_TT;Q\VaFfP2>eSC2WUe;eW->G&_<6f<bVB1R6@ZWNDD
fLCId70>09bG_8bSPP(Hg5L^+I]VO(-G<:(:ER=4Z[\4Y&(W;bP7P=.GbB.MMa[[
P^W[;+6[(MW8\<<74d9)b76=^&-&dDL[e6#CgART[Ta=OUH9/aOH9@H[RJ1;5L<:
G\7g/5RF&[;WV5JML&L=a57A+H]WbNfEdgR/b#a2^:9c:H<UUa/J.bfXX8\\S(:2
11@.Zg5a8A?>fK_CZBc[Sb)Lb,OY;c=EF[K8(H+TgfRJ-/3+H+F@4gMb+EFe[1c6
H99\?2,5(X0OQX2g369Z39U\a//+E81FZ^YZWY39TM:/I66-\(FX01]7VK6EReXD
<NA>+(?(Z#fKRQ+0R/Cb_2J0SKOT\MGe:0d7B/O6Uc<=9&5]aHcMA;T7A^_[AcgO
MdATX?Dgd/]S\=Z)Pb8>,f\0O429(DA#?].@Dg4N2FX&DIM:-8YDO#aLYE1^,2:/
MHPa(,6S4ZH08E@SZYS/Taaf-L//dD?90c<Y97P1;CJ+^)D,,B/H>(0V6fRB[1XB
/XR;^7FgD5SB;3=.YVAdJb&:Z64.TIV?TO9TA;5/BSAQKD^NBH;K/[K:R:P:>B79
MG6OcWO)JBDJ2HVe\KdP+R;-JLV/g6/GNY/-6^6/P1G]#bPSYJ>&2ZK_UfV(/K^)
CM=LE37B[TC[33P)E_JEC5TeG[0<--6H9CITdBVgaW#76ZS_^HH0#Ag;cc;V]\Q#
dHP32JUHK9_5+YZKY;P-9>]^&V]:e=A>)bCgbJU9_Xb#-:/?0D)NgYQ3Vf7,:G\]
I2A_gP1))TVaJfc4K_IDOI2UJQefA)MeCY,Va0K;S=3W@3;71C+8G#ZE@/)1gV\,
0cW7D;L7deg?gL.cUKcEXB6V(8#I6])N?OFNeRN;c.[^6GVH#F=f5DSKGfDM&4V#
-bfKfBS5<X,JB8DDeb;XW&R[5Y+bDZ2F>9,S+FGFc>62De3=ZV;0]TWBZ_)7dP7;
W;E&bIZKNM7WM=;Y>]+5gQBGJ);T>1e8OZ_2d98C5BI=cV-L)BZdS3,2EGUYJ2-S
_f]MPJ_IVI5WW&SDU6I8Seb6_UA9O??Q?Ue35JF9AIgCTW6F]<#+:.Z+f7I6b/CQ
Ec#g4EG#T4]S)U_c<NP9=I4\9LP6[KJ\D;]LS@W>\\+(F\Y=\Tda:>cJI0H1/eFT
S.Q/Y@/g#_?2adTdd]Q4-ZfQ2>OQJ]QaE0.K74KI_AAGVdMDDSLB@I?S<6[8[dVb
(TI.:W3&F?:TBGS-.KMN>d=b&3N(O<9AF@PA\,+eeT/FCMKPQNYU+@+1\PBHS,gV
K1?&P5)^PX_aPI:N9\aCMNI7UV)gS.&NDb8PK2AW_addZ82KE;C#D)^bO20]#2[-
,>2bZ<02KaP]IFAI\PFKK:Dc;-HSgc)H5DX(S@=-[[d<W6J+b6GOUV>VHdVDaDY:
5dI[CA8:LHA#;^AP+f?(aQQ:O/=MU?#B<:[F3NM#W-2QgUfbeWCg6CP9&24D4YBc
/8WH3XcV:+f1KK.SX&LIbQ.5)0[9OTLLgg<(-R>E-FG/(9_PLA,f5>aTXI7#HD,)
^^W<HU5=d^d^7e.CI0ae2e0VWD0D4O?E4SC.8&Z]Z=YEYC))5GcUU7)G9?aQE68g
a7?-3&>0O&1TIC)2.4K,U&K)bY)+(.?\CNK/F3BPfMKK81G#[9/0?CC?^WeTc<-X
BY:E1<AefE]_\LY0840eOF(G:&c;QAT=Zg=+\].Y.-72<K(@[TQJBeZ4^VDH5fc/
H9&M3O/K8S2=F\Zf6a]NPg)_R\;+aeH<&>CQ7A9]OJ[=+f?HaL6NA2G=IZSR^\@0
gNa>f/)WU4cO)PTGI)B<8&/ITY^1FZde^e<d])]=YO;>D0-I],e)F3aS1CW880-a
R[BT\/UHYN<0a)^+BfS,)AbJ65]-EL3AGM-V:FFcLMXN,A[/dO\f[fV_=1^O=P-1
#Kd&=AK,Ed]7+W+7[^(NMIQ_KJP((AK@U8aEK6IOSD=3&>B]N-OQ9.I(3D/8DSg2
a)&d9VR_e30XV\g)&OSg##Od>P7O@b6Ie+0:QYV2/^\,G2<I21OJ+9:):LSaV=7+
eKDI[Q4^;7<VN+FM9N\eD@YX0J/&3:cQ/5<;)+G]7ES@-)e=5)a5cQ&MIRFOd0e;
6gOYZ@17c7NU1^6L7PW.XN0AY6W>=J<OW:N6X2O2[OfeaZ84O8E9&D8bN0d=GS<a
5B@S]cFVZAK3/4ULLeaAaT6V1>Q\6@I?CUd0/&\(93#;I9.RPE_gagGL[=<]_W1#
/Z>H6P??EO;4O2PM))HOO>()&B=6gK(0_OaRX<Oa#3?4<WLe7V.70]316g,56_e[
]LH:M19ITefY\Q?BZQV[cP&X?&\eVB29B(b=2<O7g#OV03dRF;8Kf@)+<7VF-XJI
JgfG?FAH4ND71CJ_W3I-XOb@E)#T<4@YIfY:O>:3LKT3O;GO>+MQ<+L,XGMdWaW:
JJ]3K5@GZVF>[435X3:(1>Y7<(QU#7A1#ZJ)R4\+d+@XF.(PL1eL<3-,&f\a?3U4
-YYQ7/EEUf5cF3daTOKW.dOMdae@--=)?Sd0L#6:C)+RB)4GIU;/-.9;6HQ]39;+
-NXg@&]L0];>RM38OIW;-f,3g@fBT4=<aIa4DWJB+ANSJe2Q8)/?:f.)bSfRNbAB
5422OHSG(XdHN?)TSaBB@B43d@?48J;.F\fOAT9@=/Q,;M3IVC?B+\RM8)Tc>,21
S&W5)(Z,AbS?XSMY)]/+LMEA)KW=..<,K&4MbPIQ#IRY8C]XV@-8X4W-WG@<La?I
0YD1<#gO=4?RdJH>PH#3b?ZKY+7WD,53Hf;/eIfP\JUA[2cEM0#(V3\D5A@b\6U<
b^_3F/,[&\B2/S0#X@>6JU3D+.U?P<UEB^c_Da7IagafJB]Xd?VWgWI-V)HSYd.g
Ve(Z_I#X4RXSE)bPB6U2_WR_)_:NZZBe(]Z9P,=2-V2T/#+Vb.gP[OLK=F#XG=V1
7ba/FLMgT2VHde]X(,,-^JIAGTL7gL44JXHId(38BP^XGU@-&?S#M4<Lb=JdESUa
<.EBBVSQJN)T5gQc:GP,Te+;,aLS0.Yc5GN__f((2Mc-H\([?].Yb;Z<,O+],\KH
BZ&H@)KW:Z-+M)LcQb1C)5E=M<ScY#B<1-c^B0OIZJ,7GTE1-WQ:6]bL/L;4KQCd
TcKA+e6SJ<)=G/+]Z,NS3T<.L^dDKdP9+5,cUCCXP:V6TCYN-IM8O[?VZdD>&.E4
FSZ1TffR3;YY?>JgCSTJ\MGBUQg[;C[6[Wc_/dY4;A;FL)+.[Q5bHM7:FR];>X:@
,\2gJ\dY-SP8/3X<T^9N2A;_=RP7?V(4Ff5C1OOS9JA@9>>=J;F\gMZS6)5R8VGK
GF5Z^KJ=FJX]LBa/a;+L7gJQ2UL+TcWgVG?D30J(GNeIMPK9=-,;-W@TL?8GSI,7
J=;N33C<VJ6Y5KeUAB9S@e8S&Q4_>b;f_F;Xa,F&GcL0ZDXZ==^fTE0N5eXJO0]W
Q^16F7(L4,6Cc?U?-b2MH?B[:)?b&J^5?SY/g2&(G_DL+e=Vd_;VM2TQ8gfPeX02
8b>:3,#_N.Qe]NF,Ze#a]V^<cd]<>2Y++:@WJ[9I@a(O35B[Y>)>7,4VJ(F@QgB7
:RRBHa1?/-3AL@,)),,4=L8[BB9,b4Bcc#?(&9E4gFAP95GG)(D2SY>8+DMP.4WD
:]V;I<=S>.LW+AEaK6V)Y<.?;YC:MI8)P2D6/]:ULXE8c6B9dWK)1Uc_?[>U3\c\
H@]Je\K?a#8TM-KX8Ob;=.QS1?gTMNbJC_6LEETU/#JHT<N5c+/aL8Ea+G+BQH2P
[\PX2a3b<#[&G808.Q?H.OTg/a7/UR8^4/dA5>EbPM_gW=;(>.(_ML#M>W;6_SMd
b0_R[66gU9L]?9)>GVf?4.V/SF4>(F@b=Yd@<<BZ\5;;GMgUb9&_N-LSSKP0D5CZ
ZY,G+c+^ROe?MC7^.QH<Z9@D+4P:X9KR[R>AXVLK-@6.16eT/^U0UNNeXNRB^bC\
MD&fB>e(b5f&^ARFSD8_XD<J9:0b)^c6\FFc<^8I]E[a@Ig72C_3D]&]WX/)+N.;
3+)T--e1S[QMSa=892A>FK8a?7&P[-.UU[9fTfDZgX?VO^K?<EQQ#RB4\4#G>XE1
SOaB\_^FLK#OFd,2;gg+.NDXMG1:R6;)0MSJ2^(1FP..5DL=cKWc?(?Y8O#M99<6
R<L.-2Q>JDfCLCUVHT]9\Ed\7TZRZ/bD9)XS]]]CT7K))>[HI;1-f>6T;3TUKTLG
TO:E=cP^9?^^\7XTc9\RO#OICB^[5\RR(4V?N^a?N>?2TX0CcZ4NSeda:03b2200
6Z+/K-GYXgG7&9)Za</=dWfIPC5E:dGLNKLbTQ>EXQ)I[-R>P1G7:e/^^(gJRKXJ
TaHV-6-)ZA&U7C,A@^fGHGKH-N#MTaI@O073+VBS/NIb:Q2)MMF)]DF;e+f2;_ZM
Wg9#Lb02.#?HF=<<f)N_@I5FWHA0-;I9Z=8a(\V4Wb>G/5EE3VI+I@S\,gQU@@g5
G\UVe>g6;XS0061ZPb;^K;AZ52D,,84X7E0UD(RIZAUf/7@-5W_\V48;PP-B3g])
\-(HX>PVgN+:b;^2ZHSfV\Wa&-fM&NKg&WD_2[46J_AR,R4b?>^R[9+<KQ+fEY7>
R0Y,b4TUd.@g3bB.@O34+XH\83BL6PCB@M]B65W]C]065@DS\Q.3B]]>G@-G[edC
f7Ug&8\2)389:/YGNOBUE[H:,(X^FVAUf(O14YXFDV3U@bV^A.bGEZ3TaAP(G3_#
1F&-MJ.L/A-,I<H64>RKU,RRe[3G:RCcOZc9>)T>E5=U>Q_2<g]LHg@NeN>>;#1E
(9g1@+8T\\6NfL-X^fOe#+:5DX06K,?=T\aUO_X^&347--@DTR+JeeZD/7VB4d.0
MA<_gELU]eYO575e&C\EN:dQP3,e_WZe&08C9b3EDM9_Xf)c8S5W4[3@A[K2cYJZ
<Q;Pe+V9OG?X&cI.#WZ3SfGAg4ASKTKfZ+Ag.-JIA?Sc-X<)[9eJ+gPQK<6/BWV1
/WE6J._:Y#1d()OO.YeXc,5-Ed0cV[R/I>cI#(D\X??OLJ3S:2UZT6eLGOcKc,^N
7RAg.D(A2/.bR+b,1f7&;P0#6?7(eW=DFOMINU96NgHUV@I2d.&:AKgeP9+@#>fS
6+PY164&C;BBFJZF?+&DX]&3/W[927Z+H9]^&VQ]:ScS>WRO8FeMY>J]+IXV<)</
[60P,AWR#+Yd<F\YXc2?\bKS^EBQ>4:^PE1dKaC,e.R+CZY8CB^53N[3>eBdf+=:
FUR/a&[:ER+6::8TdcdDK7W_O^3NC()UO3f,C\ZaMS@f@=c6HBI75F/U:7B8:.4E
[fcQCP1gV]gHDW:bI;0<]2.#W50:Y-1.?Y6^WC/B6@Pf#;NE6Kb^HfL8VN,HVT,e
G^Z)7+;Q>UO1J-)@+Y?MCg[62:)-HUF=[T:ce03gN[BEULB9H5gSNd7R/.XL#]_Y
Q4I2+GW@FdI;#eM)FX,JEG7CbaKN-X?JY(GCI6-2ZX#2=TI8YbcYOLV5J6&3U&6V
CE;g#/08JA&H)f>2=B+/K\=T2DKA8S3##K4KB?H05dg]P8:9=^.CH8a7dCC=SA5S
(9<4)aOfT.7=2J&fa:Z)?2J^a_ca4JCJJ>^bTU16D^@L2gN(T01)0fKI5MY3ge8,
T^&e(FNKP-1)D<:ZV=+:]P.=P3&)QaPB9dT_0//HK91b3?3\@S1&<Bg5WLKO<:/M
\5#e:#L1c@MF(/8MQ11_/(1.Q<Q=ef-egAB)OdL.[<BK,S(2(HD,<e.G0bCS2(95
@?<?A3WV-ZfgQ9,91A2f[L9f;_LT&ce)3JW=53c27(fb1C(I/KD+fI@(K_&7.KeR
HQB?U>4N-cFNW(e018fOZ,VRV:,EZbSCd32&aeHM<U;eLW31,f>G0YV5=[2f@G3b
V@g40f_.7PVeIUI4Y(f=KN;Z-ZPI8(G,3<M>E1-,g)+7QaT:,YIDAI25bZ8Y^?)Q
?c5>MU/Ed@HFc3+ZcI2O#JDZ:b[LLV[4?>g2\aS+N5YcX]?WG=T7PX\T+ZICbM]3
97-:@+=2?1a<-f6Vc,:KRG#:_L)<\4&KCPU&L1L<Nf@PMbKc79#GG4TED<0?/VFI
QAS+c6\gN^/0&F\P&6M+DJS+]e0:VP<6gQd4TcOR#N39U>d?J9MM[@0d-PaKAIEe
HFJYTX6L(H)E5O7;J9g7X#7EK<(dB#+9C5<937I,U<XK0=ETacR\fbHW8f5015QL
\6B,Of5@PX845;]<]K4DFd;V\4,gZWO3T/S1;&I1T#eK.\E3g@R+49XF\QI<CU0O
;Y:1FK[1T+T5[gE<5=c31J-L;d:KE:e:HcGGMT635VO1RZ6c=FCN)6.VS1a;fPU4
51YeB=gd/16+YaB&/\8b2eQ.=TN3.0[1,.@.=W93GB/H1A/RY(:(^W64_]EVf-J6
JPRF-@>18,H6WadDD]G2)eH2RQ64RJ1ID<&O3ef1cKMB9F\/2HebX\?\LUK;_N8d
=K^]VBLe-e[aO10[CGYWeCML=_G2S.+E7+2NGc.YE9>:,X?(-C_D)X(-dZB&cdfM
)#_,;B#GP+PXJD3aY52_IB,L6b0cYQI_T:[L,TAL\9E+7)Z?c6dM@.[,&UC>\N4F
+7ZdMT^2W\H44H4W]54Z_/N/bQ6LK1/SP>T?CgBYS[R@(-O&dLP_(V_Df18PSZ<6
@T?Qc6Q;Y^&cKe7W3/2Be0a04WK7Q0QP#__OXW&HISL:#.Q7KX\AB=[R[1:fY,cT
]BVN.S?):=Q^@=Q4-X^KgcWZV#R_HPBH&K:-C9<)TBJV(WE,6HXO7eTX]Td[X8VR
U5g944E/(7/VW+aS=:N>4EeW^M>^AF#6N]?V@+=c5VeVRfVfAURBSE89A;3f/SB4
G(XSVgg3C=RHDV&,LQe-U>:^cAUEW#9P19UV?6SVFZW9D-QD>()5<>^8^cA)@APc
+#8CRdXI-T7A=O@Afa32=9)#^6dIeE;aAd-;-QJ69W]QG#[^(WM,fR\MO&CGP&Va
5J8888D=DDg^L&,eUZILa#UOGa?[7fO9.N+A0[PRF#^?F-@@Z7]_)T>KU:2NM3Q3
3,Sf?NXC_;bG/;G.QSC[^0&Uf_<AY4gdQZd;cbTM+OLW4U)&+B&<\g>)dUV4OYLa
,+f>O/8?RZcHdHB000D5+aZ>I2^-Ida/[..@38G-d<TUI(BgCIE#@:XB+M22fS2A
;MU;O(D<>ULG/:5gWM=3eUFg9,dRLL(=#E)>/8fL8eZ2BUM24H\C:04,If^D<3NP
-I<V\,:@V9QQ7V>?&D@D-G[[NRDCC#JAQ9efDd[_TN^:1b)QeD662^@8IG3>g8R/
5b\(3\5-++E+],M/DdOKN@b^;_a4],.MH2\X^8N>1#+ADa<@EB3>9e((S70X/(4)
c2bY3Z;R^N(,a8#Fg@4CC21W&dHHTM68_V1A68cMHZCg8K,a+dH>SU59+E]/R#1@
:&WdS73T9D>4^+0&XeVNJ5S8ZP&5NdE:\61,;?:/I2[#KOL/.#F.S_(^=YX&5N(#
=9<^\17cGUJ_Bd5ZIET;)J1&Icb:[/^]Rfg=A6^Y6@=7JTA:ZH\4[b?._Ea=XTHO
AcPP7FJE45L9:2_\C6&b[Ee]>IA@9C723[9g:>BACK-X>P)fV>?<U-5FKED]IO^;
fC00YKbY^49F4Q_587^G>=L8O4O/6d/a3c_cZF5:8PU3+-&NgY_gKW(\+O08^JZD
2>ZQA]+Q-6,?S[.P7_fA>Q:<c[9[cc8edQ^IOeNO>HX:F92c?f@;?<N^Mg?=JA_=
F?B-L1@7FRI>,]OH@,P8T>?+6ZDI.cJ[D)<JaS1B#XUDb,^V>A5F_N^]?Je)6UK=
G.VbD_55a1P2c@#.RNC+NR5P5(b_#K-UH>F<&ZYbb@DG),8IB;N/#^O;2&7X-a=N
c&Ccc;/@cLJ+X>P6^GK/1:+TU<IA7FdD&FHd;Xb.YBeEfS;\6HgCV:NUMH0[Vg/U
S7UDeCV.:0QYX9PN-FJ\\E=&]7(0d(68VBK/AGDYbP]Oc/<)9>=C[7K>@/\=)<J3
+M-Q6eHe]c8d)SUM\DE6-<L]/F4)aWC2bb8gJfPcFYQV]G_@&fU7E4JVG;S6#W;f
W+?\ba5C[Z@:DKY02V#22+17DR?0U[=]FD[aO(9W<EX)E\1;;4:aVI8^;db;c>^U
VDT;MPR>#VcM.D99(3I;5Y72e.Yg1:@2<H6HgY:RI]YaN>-@LdAe2S,F/8U;5&[f
UZ_[dQfF\Q537da:]d1aEC^4(LXb]B8SD.2=bFdJ.U2T+IEf+TA6dK(F/<Q4+B44
,g=P.HeY]-c-P6=KO./>B=;UO3LYU1O]5Wd1-KHK]^N^A)KZ1eY[[@gLg2<H3&53
.G\^b@=R]SQWT;FccN;,AOI^\O_X)SP>:4[AF&UMD4(U83<Z&a;QDb,2<E6W[X81
-SJ^VR5MdFPGO:,ML22VG.:VHP&\F(DGUOB4@IF]CVJ86.?PX4I9Y6,T=]eRc_?0
He^--HSQE^U5^66ZW\/NePO&#-f^fggG@K/KN1RK\;16\AFPH2g?@[(TK.R9,EU?
4IcMEa[;6>Z5+3b-FRf[>-0<Y>639B:;HQ3+e+Ef1M5R^#O0PX,62-<..a;M68)#
(4A+@=;+aEBN,DZ-1[/:g#^_;M8d@/ROP_,b]>CU-gN]+6U-,T6H++_bdC/Z:1gS
bbS^9FegM?\cK;#F\O(a9&DDO5ASL?6P5NfW.2<ON&U-]Yg6):9Y3,9K6cB>\XFN
7>fUbQEB14X;71R,O:\)f)We7L-<1bZKEf;bP(CBZI#_67Q_/LT=,+.a1,YcAfLc
H#\6O@e3U-bMVYXf;eE(PXXWP23\S#fF+H0:N;N+_N:PgC([BGN[G46T0b8L1Q\X
?fO@8YOcZ2bAO8aIJCQ86@UaP[M8\8@2eaA6ZDCJY_;5G[#H50D4S6TOFfdUO>eI
b\Q7<eJU23MVN+FYP:9B&c&IJ?Rb3QBgb(&PJKAKC([@H?c3e#La\WSC^Gf^.Y))
L^d6U/Y/&B,6.]I]H5XR[ZXg[G4YKX:.]@>3/^V^#J4DVP.0?2>@R;DdAH=<=&H)
fb,LL@\A@RW5M,;OgLIQYN6VHJe>.M&Lc95<MHZ]RRY1H?217X&0Fa_P^(Z?O_G6
B]d<>MccFP2gE40VUgV,1)-/YRODC[]T7_J-;cf9:^5]O83Z:49=AZN38,N2\70f
TK2>H&G:UU1\ZF^UQ3SfHD/3+g3K3N>NJE28ZRa-7IOKVDJ>&RK]5cfZV^VOL(4b
4Fa^J\d7;]=a<1EQ-<?]GF>ISC8&b=4Z=D8>8H3GAK)fO-<#ANM?)G/NU8AN=#?2
O8;&--Cg;4RQde8>Z<I\g>;6Y>cd>3OPMZX2H[_[>77=8a8Y;:SQBbNCS/&1decG
I\e#3BEX7#P[CILf0B5O]cb#P9W.J3R.aA6IJ9U\bSTU57?H5W#N,bOYXLC)\#DW
\A8e#f[4#R@MYN7\)BBCTf-)I6I=AR)961[R9-L&L.L-TU7WD\?=UCC@+b<a:7R[
WbH9KC,&cCUF)b-9VU0^3AIHbVY10+6[HF0+_M-5QFO:A(AS21feDWA]).P&LRb?
J82_.M7T>.+N+/LJ&7UB/Od@NT,OHB]OXU^R&6Q#aSH]=c20(G6;RIaO#+\8QdBc
&^W#+AY#7Eg>XZDCG:.L:X6\7M#L-3b_-6L/O(K1RYVXc_,bca4GUb9LR=-:T,MM
TC&YNc6:7.@2I>04USYf7>P22-2DLIf2:,\U?)Tb&))137IMa2HPGff\cR6;+B73
VR-_NWZf_<Y243)&=Ha\<cZ(ZJ9O;AXWBg[\ga40XX;GEOS&-/10?6UN3f:RC1UB
5c?9LXBCef.43QYQ:32G-,+\@2U-egU1H-G1KD(A:JDg[I;UETZ7B;O64#X\P7?9
UPaa\CE.D6K\F1,+gc^c#G1_6bPHCWMXdWEY[\b-Z62IgM50TR_JDL[,)-F,^HQe
AE?G^F_;XeT2cQd7N[Tgb/9N#UNUa=K_^2WZ:K.<^Fb:#6aX.48:&6Ae^O[F8?M8
#Z[R/BHfT97T&@e#VfGHa(8).8<_V3]F>&>:&[X#IZg0^TPb9d0/PJ6Q?Y@Fb-0<
Q;D.MX^MHYQcAM&g-<S[g;(4:2aF^KWFgBR8B]H;K/?EH+?M.<E\c.:bU>AYB[IU
:0T[3G#f,YI,/@TJP3[3S_gKf(K.b\_#P6OI;5XOLgV9V&#V7J)R1)2X.SX1CV2a
c_RY#3Uc05K<B,d>.CKHW>M_ED>9J_\^6):>BV6>NYf#H+bMCI^IOQ?\KWL]aKcQ
VeB)#.4T),MAHM59CPB+:W_033FZ<b4c.@+S/\\6:6FBb+U^FRUXQK17c=PPM]6^
LIA<+A+:7/XB>I=;-(0/e04HHAR7SA5XL++)_e5eDUC1cBH1^Y\S=bae)#CB5CKM
NM/Q&KH_gL2237IC-K8^T4YJQWE0\<=8HgLbXHd6gMLWc6_ITC0\(dg>_BN-G>?J
8D?5E^<>9-bMAd75+cCgfLGC>XOZLS7^UHZ_b90GIT2;J4.6J<#[9D=M8A<[^068
e@2<R_;=40I<0c5H+ZD/9LLH.CSRV^CXZWg[D]R,RBBaVWJLd630dLI^ZK,-]@Nd
0QQLS/6.-=.4P<@O)PSLg3W]\Qd^3Yc>8>>ANNKVR^1df(=:?8?-71KFHdEOg<FH
PL^bQP7/X=P<7e2S2)T,\H9R5EPFNR1<MbI/^[-\>.]e+27&QY0T^^<5N-<E<R-^
6(E:b<HdB_9,Na)2D^>JLSQe,PT+,[+912A5>?aa^E=3[Wc;(A,7(bca=Oc1GMcC
SF?6#Ua1E#9d07>GBKS4VE5>UQEIF@&IGABE?\<@UZ&@)T[G0&#gRbR>XUQ<3f)8
=2KLQ[@1,^SAdH-+E-aB0N\aF^;,dU.EQ[?a_60@.6?1)UFR?JADE&^:]8b4=R=O
:g>#5Z9IA@.TaGROA59dAK-RGD?N&W:1_c^^eQbJ4aK4#XN+E-[](0EB\e;5,.E6
8\TTc/Z=U\A41W@96-H@[=,;^g\F@3S1dbL<-;E8Ha6@0;MR?#bHZ_6CHK/N0QI,
5,YfK9_J+=RHE[BINWVBC3#Y/J@B@@M([86a>CM:VS4C@H6f_(>657XT+ZT=&66(
R6QaU0=\f_M66bd)VBK,:=AN<4^97DL/OSTC<O#,Z>;:05FbY(W5,QKQ8)(QDbYg
#g:.^.N8@CQ+W3cZ.Ze.+5eZG]Wf1D=0Uf13[dRM:H1M2@4c?B;]O?L:Qf>Z4?UV
eHM/A<M+WQA?[Z#&K.[H^g^cc.(,3[1e(2RYAW:A5dg20#H83-g6P:PU3JO,gO^G
:9.8:\]S/XJc:0f)[KUS?:&&^FLZ&=H+H0#FbgL^>0&Cg+M@/?F:?QO)U3Jafg]/
IG=@21VIQSRS]Jc&TL8TT3&7MC_69I2WBdL06:5dePaEe1Q/))[VXK52a&aH:.dX
YUN3@@-R2)/g_U.T4^6YI-/@];#UP]M>AS1de0XL<PF-4Qb:?gPCFN^X,&fU-M3d
(;Z]30OYT9Na9[@_(^_f;38T#]UU474AZU)9\:YCFCHTWIA]\cKLaT2Sac]WUP6f
fPae++ZM93\9]V;Ta:CW)F/>0THO0.(,\,Q?QZVJK0PMMI)@1;?M(5/4?F,S-e@L
F\eIBb#6HdPc[(N/FH67.?2/U\S<afJ=9^EL6&2U[,K8c1\Ud.75cD#+gW?3,N0O
WU.\WQ(8/UUH0QW2(JV-H9@1#0L2HU.94a5T[S]GBH-Y2>B/IN?>F+I.YT?ed@0X
X.Ae(+\dHF@4-5L\:Z5AUE?7)^@SN@8(])I([F5cagY3b+#bF70J1V2<8N<@HJK\
ZLDc541?bC<TW=C6S\)X^SF;:(\9ge9RX]6/2K=,IfMH9]4V]LS-N3fEX&=)8@JI
\Od3?QQ5UGUW>E1#?3A]:K[Sd(&7B:.^9[)Q(4aU9E.9#8(.QG;?JLGR8bY/^?X<
H)Tg2b_JHK0WZ.0Z?=8A(.^=G.Sb)+?Kd6-\_2fBcP,-H,=;/IJ>eIZI+^M;1&&Y
bL]-V?SUK2W]08Q49(,U662F8.+@>[#ggeac]e&>_Z]I@,TQ4aWa(;9d-bPMI29W
KBT@?\B<bV#I&(CV/:^IGc2ad=Wc5W);GIcC6VcA(Xg,AIP7)LdU?cWRWZd4I252
geFS]^[M+/EF2BLYR13R;QY<,aHTO\-[,P5QEY?L2WJA=P;[ZcPC+dgdJ.Z>DL(3
&Zb2PLg+W3NFA&]((de(RTX4M]g+:aY^Z/P5TQFK1E63MM4aJaSPFbW#A?F^D6)<
+5V(N[LEHbA.7L\1X/(&9)RT[9JR.MDb^M@H=6XVD+LP]H3]gdRK:=D;<Q8CdH0+
/UQd1Gc;=6gG:/2>g,.K8395D7>76/A\2)70&B&<S??0N+H5B.QDH7JYC9-JK5@d
4a^CgE7SGYTY@8)Of0I?QZR^244@KJ<:ge_5J^H,MPO&IO@4Vf@^[VK7F82e9.d9
^c&AA?MePPLY2@:>DLOU&22XHdS+]d8:S[FTe003b/J,XEeeB/1/_]3U>Q<e1O<=
)b2X#M<@:(F;5PA>:bSC+6+(M(H_0LA[LN]I5G2a9[^_7.6N>WC>8:RCcDGU62f@
C8MVH>(5JGPeMIBHFJ<dV7MBg20@QZSLD+:HN)O[e4MbW_3e/_a;V?af.g(:I7R9
VU9fYE:#XX<FKfJ+D2T0YbEGE1T0.RAHIdMeL0(-\&0f<-8RI.Z./b)[<4>=cVcg
LOQBLSN#EUQOFPXC9CWJ38)_T917MA.VSZJCDZbDPW/e0NRVCO^H&X:7UMZ\8[QG
IV:).\@+@.d@g]MA0eNdgL6^2?FN9G\N^.+8EC5ORU.CXaFN#E[KD>M@GD_:g-Wc
a8d4BH3a?M6WEdD\9\QM5;[.8CH3Sc?>8](BT<bbIH+_SaTO-.EWP-4]S]7M2.?P
]1-8B3Z?AS1Oa9g]5d0;;PH95S/R689WVV5.:f->fSIA56D)Vd.IQ?N#6,B1=_YW
/F9b3Dc4c2-ee1-)[g>8QE4]/XG#P[8,,AOD:8VWJ,7H16CL_U74I?c@&ALHKK?P
WZ(;cK]R3NAZ7HJ>I+_LFA#M)bZ@g^@aJ=X+MX80(OSMe]?1c)N&K/V;-^9_27->
UGR>?4N5=?1&FRBY?U;#TXX5gEFI#&)+U-Gc?K1ea:]7O?OE&78f6KB_MUNO-6TG
QK8F,TK6@WMAE^>a9:eg#9:f<AHgQcR@;XR(IA0e5=9-N[F)3.1#GL2=AWE1+\\T
TX:50N3^M:(]EDXQET3P[F<TPT&#&>\F0)S<NTWP<)QVEIQ4a--bW#A^28dT@04[
g]4=84@G.#.RO1B:XO:QG0;;^@E1Z8B8&]1E??\-V@3cb1I(R9K^H=P(4;;LP(f\
9I+^D@&F3T#g-c8ZMY&EAX2fFg)AL+GFLHEQGQ.1L>FebMHM[JU_2aEIY,6HRV1W
]L&cU&Ug+RDJT3X5(S=_6+Z<TRYZ6]T:eZS5\9-HD2?@1-cOb3]aZ>#e<bHSgK]7
2J]D,B7KQVEAe3P+U-[P>@,0>IQ.X)bLK[AOd@M\cJPQ^E)8Ya_T:HXUNeTH;,).
E2=B:\KE)N\T2^:\QW#_@f71MP(K\+QG<>1\_XcXVS+@1B1FSW^4LPcU0D;R?H;a
cJ1S63;GN;STEe3GZ3XU]\df2)M8.]3CaT/[,T>:7-Q(deI,I<:Y#F(>8C//N[aG
S>5K-,)8#K,Ib[#;Zb0fD=KNbWYX^ZI#\(KON1KOET4KAZ_EUTN=dL3NdeL6T5DA
[GNTb26F._LBTXZ3=WMHF#N#f.K4)c0KVP_LWI/E5M?gMJYT#:\fBBUfeD#HRaFT
3(-c69K<R3QRa3<fWC5&)BCTI&V42NY>dP359?\V(LE]Zg.3#&(2Tbef.cM/VKfT
((ZPNaLIbeTRF;&&Af1@)T>-;EOgWI2J_WLUS69[BNGCJde1b8WI)JaWOeZ\(L6U
C(MYGP/+:MPS:713H1c,Y4>-7$
`endprotected


`endif // GUARD_SVT_TILELINK_TRANSACTION_SV

