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

`ifndef GUARD_SVT_MEM_CONFIGURATION_SV
`define GUARD_SVT_MEM_CONFIGURATION_SV

// =============================================================================
/**
 * This memory configuration class encapsulates the configuration information for
 * a single memory core instance.
 */
class svt_mem_configuration extends svt_configuration;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************
  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * Indicates whether XML generation is included for memcore operations. The resulting
   * file can be loaded in Protocol Analyzer to obtain a graphical presenation of the
   * memcore activity. Set the value to 1 to enable the memcore XML generation.
   * Set the value to 0 to disable the memcore XML generation.
   * 
   * @verification_attr
   */
  bit enable_memcore_xml_gen = 0;

  /**
   * Determines in which format the file should write the transaction data.
   * A value 0 indicates XML format, 1 indicates FSDB and 2 indicates both XML and FSDB.
   * 
   * @verification_attr
   */
  svt_xml_writer::format_type_enum pa_format_type;

  //----------------------------------------------------------------------------
  /** Randomizable variables - Static. */
  // ---------------------------------------------------------------------------

  /** Defines the number of data bits.
   *
   * Must be less than or equal to `SVT_MAX_MEM_DATA_WIDTH.
   */
  rand int data_width = 32;

  /** Defines the number of address bits.
   *
   * Must be less than or equal to `SVT_MAX_MEM_ADDR_WIDTH.
   */
  rand int addr_width = 32;

  /** Defines the number of user-defined attribute bits.
   *
   * Must be less than or equal to `SVT_MAX_MEM_ATTR_WIDTH.
   */
  rand int attr_width = 8;

  /** Memory is read-only if TRUE(1). */
  rand bit is_ro = 0;

  /**
   * Memory is 4state if TRUE(1).
   * 
   * @verification_attr
   */
  rand bit is_4state = 0;

  /** Name of the file used to initialize the memory content.
   *
   * If the value is "", then no file initialization will happen.
   * 
   * @verification_attr
   */
  string fname = "";
 
  /**
   * Name of the mem_core used in C sparse array.
   * 
   * @verification_attr
   */
  string core_name = "MEMSERVER";

/** @cond PRIVATE */
  /** Physical characteristic descriptor
   *
   * Defines the number of dimensions that the physical address is composed of.
   * This value is used when constructing the memcore instance.
   */
  int unsigned core_phys_num_dimension = 0;

  /** Physical characteristic descriptor
   *
   * This value is passed in to the first argument to the 
   * define_physical_dimension method in svt_mem_core.  This represents the
   * transaction attribute field name for the dimension (Ex: rank_addr).
   */
  string core_phys_attribute_name[$];

  /** Physical characteristic descriptor
   *
   * This value is passed in to the second argument to the 
   * define_physical_dimension method in svt_mem_core. This represents the
   * user-friendly name for the dimension as it appears in PA (Ex: RANK).
   */
  string core_phys_dimension_name[$];

  /** Physical characteristic descriptor
   *
   * This value is passed in to the third argument to the 
   * define_physical_dimension method in svt_mem_core.  This represents the
   * dimension size (Ex: 8 rows, will have a dimension size of 8).
   */
  int unsigned core_phys_dimension_size[$];

  /** This flag is used to enable or disable log base 2 data width aligned address, default is disabled */
  bit enable_aligned_address = 0;

/** @endcond */

  //----------------------------------------------------------------------------
  /** Randomizable variables - Dynamic. */
  // ---------------------------------------------------------------------------


  // ****************************************************************************
  // Constraints
  // ****************************************************************************
  /** Keeps the randomized width from being zero */
  constraint mem_configuration_valid_ranges {
    // Should be at least one bit of data width and should never exceed the SVT MAX.
    data_width inside { [1:`SVT_MEM_MAX_DATA_WIDTH] };

    // Should be at least four bits of address width (memserver restriction) and should never exceed the SVT MAX.
    addr_width inside { [4:`SVT_MEM_MAX_ADDR_WIDTH] };

    // May be zero in case there are no attributes used but should never exceed the SVT MAX.
    attr_width inside { [0:`SVT_MEM_MAX_ATTR_WIDTH] };
  }

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_mem_configuration)
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
  extern function new(string name = "svt_mem_configuration", string suite_name="");
`endif // !`ifdef SVT_VMM_TECHNOLOGY
   

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
`ifndef __SVDOC__
  `svt_data_member_begin(svt_mem_configuration)
  `svt_data_member_end(svt_mem_configuration)
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
  extern virtual function int reasonable_constraint_mode(bit on_off);

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

/** @cond PRIVATE */
  // ---------------------------------------------------------------------------
  /**
   * Update the physical dimensions based on the configured memory size.  These
   * values are used when configuring the memory core.
   */
  extern virtual function void update_physical_dimensions();

  /**
   * Clears the physical dimensions dynamic queue. This method must be called before #update_physical_dimensions.
   */
  extern virtual function void clear_physical_dimensions();

  /**
   * Verify the physical dimensions queue size matches with the number of physical dimension
   * report an error if there is a mismatch. This method must be called after #update_physical_dimensions.
   */
  extern virtual function void check_physical_dimensions();
/** @endcond */

  //---------------------------------------------------------------------------
  /**
   * Walk through the part catalog to select the proper part number and returns the
   * path to the configuration file.
   * 
   * @param catalog The vendor part catalog that is to be used to find the part.
   *
   * @param mem_package Determines which package category to select the part number from.
   * 
   * @param mem_vendor Determines which vendor category to selct the part number from.
   * 
   * @param part_name Specifies the part name to load.
   *
   * @return Indicates whether the load was a success.
   */
  extern function bit load_cfg_from_catalog(svt_mem_vendor_catalog_base catalog, string mem_package, string mem_vendor, string part_name);

  // ---------------------------------------------------------------------------
endclass:svt_mem_configuration


//svt_vcs_lic_vip_protect
`protected
F),aYgZNWcP<<0[[ZQI0XKQ&>SMcXf[=5HQ&LN]\9)XG#Nd_fgDN2(8ROda3e,D[
HUHOH]^KULA<3TdP:HMF1GZgNLFgC19=Y8aH4e()1BZe+34@Y6I:B@0MP\7=&\8N
;;2gH_(=.19G8U;3gIWOL9Mc\N+D(W)]SM2^eALQB46K.-Ga4MQ&3bLD)0,FT5^2
KY[PBKWN;c1&f-a8-J+LW4:L?b],P0?+[:MJ4[>F=U\\<@X>-.^2G>Ga8b0P_/3;
#EPI9=OVgcDdF#^VR)TMXZ2E,=LW0[=HDFBPf#_GC;<-C?QdaHQE(/F)JLg98\.V
_dC;TFG+FO9NOYCee+fG4O9_f5BU?>=+X,MH1DKX0E6IY,=#=)Yb1>\QOe8.IH:S
Mb?5P\>Q+0P)<b.>EDW22?]-aGKGDeU;9OUdg5^H7C(C&-U&LM\Q@_B_NVU>\>E8
C3PSaN)>S)Q=O]1>#RQ@DEOUN7C^2>N_X,M@YBAIA>#^Zff(661NN.@H0)gA<J@:
1:UU=^)Sb^-->f&7MA^:9a\UN,,T>-=1LgMKMeL.J1#GPce[^,&6,COJ06+XdL_<
/Od\V<.PY04g=eaBJ7>-fdS9+R>BZ#_4Te,[<(HD/_OR\5[?642SfB\R1fDM^RdW
U1GL;JfA7_XX;TcIDN2OWb;SNNYD-R4\O>dL4@?g_d>g.@4/Y05[)XDBX+F)dU;/
-O:F98>G7V#/-c^Rd\LUAD,b=T^(3?RTF3Ig.Z5:TTZN5F:1gYVGd+W^Ef,G3SgY
ARB2a4JH>cNdR8WJ<,S.P@7eCY1M-3<G25F(.Z@\.M^KDP(VN+8f&Xad8@\_EHgf
9GM,:I_39MS1UUBA0gPd#Q7e7$
`endprotected


//vcs_vip_protect
`protected
S?1-T4PJA0U\Y>3P.332g+/16Sd;@I.KT3&D[=._\/I?Y[P7fM7:+([YR-dd.8g+
HQ4C&ZJQB[Le69>?^:=HR>G/0W#KF>X@=7?)S4EZ8f<)/WC_;Z4M@U@=.GdFJfV7
;3.JdZgD@0PDO[?/,&4ZMb2b6gT,]bQF-[1^K=cX16b8TbU-#S(MNQH&N2<8OYSG
(,SAD)UE#cWN1UZ]X3R7K8W\d>\N78KdM2eRDb0,IS,&e6?9/9WJ,J@ZeTG\;W9J
L8(4UOYM9NNMTSP0P:\M3/R\<XY?:N<f2LKQ45/K]^<(0(02^ZI9,DS?XV4=<7HQ
Pga9<\UKIJWA5[0@\F\5^<NH=B0+-T3JHFGK2a29II\d/0^f=,Z\N3G&LB79T3H@
XNPe(_+^1S6)A1BAO,&F-3G5AA6(,S[YM,AX/[SF474d.1P)XP6+S^cBBEC#/76]
/9(V-S:EH129C5P\U^4&Z@LS&FWX=S7FDF^Z0H4&?\GaYD;^9D,Wga&IEWS8AEE<
>P.FPHd;=Z0?A;e-W21OHCI#JaO=--bM>U-FSW84]_]=I1EK30ZOG6<6e]#?S-N(
,ZG)GU&\#X\b32&FUN[TeGg:gW7.:3ba+-LZE#ZR8O>SeIO1.OeOQ-#V4Mf=PD/:
eL&?>.F7_70Tbg@^,U;.>fO4NSgGC/R>:TFOQ+9)^XUD;A#Y)>bA@YYP:>^=,PW[
4]6J.FcBU>KW((@:,fOGfa9e)P_\W&0H1a4d/e4H=C:9M:^a^Td+<^D7KBSIX\NO
0@]73).Z#[R6a>R30gf^X1EBVRbT3CLGKD1GAf]VJ+b1C0DI+?;H\^g2.(QDJTA_
7-TLCgPEX-[7F]fLCVU4VFMaO;\YN,=18H:.#DT1^08C(G4]KA^2ca>cK4):eZB(
)A-(1PNJL[I+<dU5-^bU_Q_;e32@13YaPW83Y(NP,44Z\c&MKP/A]fg/Z=K^eI/^
D/1WD9Y^IU.<5cC.TcQ??KM4f;@GfU^E8Q2UQg.Pb0,fY4=cO<3c]@J&X^<R]e)I
<]=S-=/b8[)NU#S&g1#C=MeZDUY9VLCa<9H//.3B)[PUWdE7ZXA\/4NaBc;1X-a:
bT=Q_d417Dg>,Pc1fVa_K9Y;O]M3U;C.-7S5+2GV/aPdbb&R6?\/_ZNT@YX7\^VU
RP(S]Q_eg<\/55TEIU^89fJ5f&XfaNgH;<34MGD(F#<7;.Z3S+)&/O[49T6#Ud^(
H+(JLO.M4)^#718f0Zc,2KQ41725^TO5Ff4Y[KRKX[3EecN:UM7b:cD>fBV0cA/V
^SeHMRG^eC5C@IH;4@MZEfT.IHaa6551N>,daZVH8/>,5OG_Y>C=ANQ1I(fY97/;
W,\7HI\;&NTWc&(U5]Id0/GU^J,5J;a8(S@;Z\O.R#HfUUVO:Zc.+\X]_TOQ<Qa:
9Jg0P^DY(&+g5KSd?5&E+HcI-_gKVbROF[4LdX=^d\BJDUQ92T_&W0O]@O4Lb?29
22\2Z8#OE=dgZD+faC.J#@[?V#EYg.MgD/3=0E\[U\X,@)H_?9_//JfS..47O<X?
OAD1P1_YQ5>>9QC-U[F>/-56H:HUU,BeXd[BX9E&d#XPOL(:7M&QFdROcN]B<CT-
)bfUP^A+8C6D\]-KYUP)aCCdTZ;F&L[@S[aVb(L]:J0Z(3[#]I43.(O&38VM4YFN
8&NdRcO.b,2ACT\8PWAL=;?4KSdI-#GaK,Y\;RD]6dB(aEZOY7YNP_&W)\P>5J4#
b-2[\/d<GHNXG2;8KQ)D9[G^]QDVffC<:]E9)#Q?;A9XL)gIT1)aX:E=LX?TUMb?
7>:)>4Y-UHb]M\_Q<1B4BS^-F6AY]W40:78cR:LgZLT?feXM89+VWGWL^e1-E&:J
NXRb-MKgE6e.LT2DF)=9Q8CSfg,\5<a@,/HAC4eB,<A9OgUXK\HSBOF+XdDK#/=>
GN+/#c)O;]CQ?aLgMFY9=@FgT_/._B)8ecU,\:CU>O&V0TFX,]XLQ09;>DYa<:PU
X]Q#?N;7cT:/,aPD9UP@AEYE?0/S.aJ]?(2f_E3IgY6daUPAd?E/A.+CA5)5c6@)
)^/EN9adYaBXe^e-IK\9F7Z@X([D(RNIA/KV:>_<^KE4B8N2R6QPH@1L(efT<J4c
OK^66bZCWO<(Z/3Z^eR/=4g=W4\?/V-ZTefAb4<f^<f@Q;4+3[0UQeX&Pb>7+NT:
Fg_Jbb=FD8\X_C6+=Vb#S]Q3=VbOXB58\UaC9_cQQ&B6P\2=/gI)]0M4@>NNV?9=
^S##AAe]U;<gN-Z2W@O^B<Ia^BdGO@f6I?HHN@I[GGW[+AIe44Q91_@0(U(@J+bZ
J0.#7=Z3V\C0&\PT^e3e:B\#-GBJ0?\E&-^<eHcIZPE38Xe]BQPM=_CfbC8]<T.D
V3M@+6S3K#DaEe]S35WM174R2I0ULBOQ;ZdCNOd[H2EAI[],g8cB<@ZFY;IS?R[P
BZ-\M:#fXe#fX-0^4>f&=BFd4J,E)PSKG[QJb6b[e8AJggJA40[]+WcVNMGQX=)S
(5&^(bZ.:=ZVJ(MM12_,Id^D]Id-a;;WcGWT\<BKgc:eI^QcXP,/C1E)Lffd[[+a
@4IQ4;/@Y70[c>Of?S_4<J]PP,1-Y,DV.##7X_Y&4bM_=MKFgU+RTS)YL^=/YDRM
EMHXfH5:/+?f]JFOQUQ7XIebQRH#N;1Tg3(+>ddY+2gF7;cT[WEE?f_,6SffG^O#
dNg+G1LdR^_d]Z5GO6A#Zd0#W-K_[QL6EcY,P=016:Pa-DOP7IQca,R430V7BUdM
T<^KA9Y&f5T&[W](7YDJ@WZ+XfWW)MR0W>?S:4S2CFdK29TZA&J,a)3XM0F=8+>Z
<RdZ^YK&g0:ZK>ZG1PLg5DT(fMMRS<C;G=_Y1)&[WbbC+3d?]9O=]5,)RJ(dKS<O
a/>6T/R0eXa=BGa4KB@bGQ/R/64[S:N;/[7/4(;)=;68SKWdPeKPgZ<MI-Nd0<N+
2[@@<@F#@KRcU3eR]83a]S-PY7&K\Ug]T]Aa,)R/+SDW>FGX-MT@)[S6bJ]=.QDI
S3-;a0S\/4OJM5aX/GXa)CEHb-cKX9@^(XbU4+ZEJTK2WdW&#GRPD@+59L9:,REH
fDZMc_/,^[DEHX;Y@;H8Y[.fZa8@U_S8A9M(ea8D[_.XfW+D3ZH(V4V-V5WB]H98
>,Q@BMBdDK]GM+54g([RWO1Of2H28ePQ5QS5c-M3B,YAE@H;9YU&;8#2_GU<,0.B
Mg5gT-+g0Yd/5DN4MNaR_-;X:H]#JS+3MAAWYE4^-USFMO\cYC0_2@,OH[Nb.bU=
O/_5&X[7d(eYDg7F7MVbfU\LQ&gCdb49eYc:AcQ(L@I/E5Kd^Q&.RLb2.Yf&QZA,
CFcGVG=Y&c=;FGDW2D;]BfQRE2:&UHP=\=4:\O[QgUf#WUT]&:71<Y0JXJH94d1M
XXM?<geGbRC\Z@54cOTJ5AadY=E6B-^M4<YdBHXT.VA4d47g^QU)&>H0ZJ<^eMC.
/?<8),8#eQ:<6+7PYUV4+@E37Y,&-B)gN3)UU,ZJ-2D<6d.1KTKgBU___9=B]]/(
D;IOZeBWB,RHD/W6N],)5HE#c[BR\f;\<B=B4WdMbE7_V^deBGGP5H>I\-RM-G>@
R)<N\eQU-&Q8OcL2J(_H)L[NW^gfd^&ZgK9FYQX0]=76K^2d_F:Q:@CFCT],6\fX
W+fA9FS1[NUF/H8b/M=)Q-6@HAWJ\11]QK./5P\HMd6?_)9A+V[:DW[O[15_ABVE
12M_@MLN35-=BESKd>/f[bKBBHKeJ213GfBP@==S10[&UDc:SF5QI#VT#(7R=]aF
QBH=IRV\,:P=?=4;\1S;;C8Y2L=IA9gfW#]D,DYAUVA/ZCX9_^I81R9AK@GD8#-)
#=80>O@F=\\1Q;?P:;.,H@4/^1f^.NXSTSBY?M/;E2cY)[d2PEQRZ+OB>Qd(/(Rd
=H>YEAGf1RTNa^@[UDc&a&)[5^Da\f=TJ5;YZUJHg,I7,Jb/FX:&-O4SS5&2I)_1
K:\,HF4d-L_;J1g:G?O>=A/Z/V@)/8Y3U[Y9FX9TG.0H(0DTIN5];;,4(&BY(9M>
;DDZ5;g^SUc55.I(00gB+T#BfgTN+=8;V)W<#Aee,b@RO(U^>KQKf2c7HaTHDXfJ
WL3Z[7M,7]ebULd0R.S3R6eY5Y3J6X3([e(BC(g5eeCb+:_JS>d)\=>9?fCMH?d\
V@MB:=>V1SD2A4QZ[0E5822=-0][P?ABQg+RE2#DWW>VH/\A+aBYc^+.S07KY(f#
;/M5ZKTPMFQ^+(&BeMZeebJJP+-DW\gF6B5H<RCbda6&,&K\NMg:VM:0\ff3(4.F
8G?9^_.,73V.MdU.<4:3?9eRBe3D^6Z&MaO.f0ge,<ZI[19UOQc,VF=95]GY^:QI
=3F.N4EU3/.abf?H3N=S@]0F1eWbA/aK.cX7P\2bWSBHOg>aI^C-,B(D^YaFHZLE
FSP0MXSXZ[fHI,X=5Se_S+4dWVUL:\UB[gOW?Pe&7H;[;\eVH;C@I1[2=,1EW17(
0[:.0-48Xa&=TC>8[E;12(MgXC74.-Q[Y4>M5BT-<)#0bW1dUH>LUH;Q5&G+c#7U
E30aaH\L8^#VcB2La0;U@dCNB[?RfB?-YW<JXK;D;;aB,KNH<?/JCR>X+d(a\I#[
-Q83dJbd&U70/K,c?+U#/LOD&IYT-]JHDX(4.-)RSH]4P?gb&)3:7L8Y[P]_73R8
,U2Z1SdVHfR)F\-6WY&f(+S-]a_9KfOZPF4b=,KUM2bG;eT:Zb79O]6fF-d288XV
2>CON7N:@WX(_;]>PK#8_1WAQ34U0)TER#W\d.(EF/3LD1aHHJPC\Q[)1USc#,bb
Y1<[Z@eQeH;F<\8-Y]Bf_2]CaRGfU2+UN?J11cJO_A[)]Rd=A.UU2OY5Je:d0\QE
:gTGI^E4GR8M68Xg<9E;SBG[g2Ug=[V2O(a-Oa;d1R)<R9&QbgX,5Y8Bd,.Q:fUX
+:640Rb=,22b^Q&eS0J#/YHV8DU#.BH:MR7>N_Y7?;)-JcHC6M]BVQX68A:H@N87
BKa5TRDLT]&\]E3_ZIQ.]?8;YRNN8RTS,bc>c;Ic+A>7(:Rc\;Y??L.N3Z1P\U/=
;Z1@bS=C&]@/^CfcT-ENBMTGF+\MZDR^)ZX>^T.LefMgA&=\U\9^6.]I6\Y.gM+f
^G^[,SLUO_3_eU\E1f8A(SXA4UGaWMMgEA\^D)3,WUZN#d1c<<<#bDeEJfO:5[5c
8X-ZNeN?L9WJfZEJQf2:.11)FHS:+W(7>dL4\V+/VY5:42:=.[W;-[8/F(;H[5#f
ETG:MM]/0)9Ea?/OMMaJP?2ESg]>^V/JB8:&WS<F/GM:L<<86G95Ofbg[U_S^21d
Q-JI]bL297_454>0(3L-[]7f:=GQP<6[88Ab/Fg-GG[aG_a/E=MT3TIU0]QC:WfZ
)Q_DXLB9)G0);)O6_QHT2fT(T-/C0e+@gBUD+V=@336V^GH525eWMN]-gHJ=1(3e
_DD3U4(6J4<G>:\5P/,,(/YdZcbD(,;K+b]QKWT,_T32G&H>C(&A71Bad60L:G(X
B0+<M18&]FM3UO,e0VNWQfAc(KJU;2&C76I#0D62VV&@2M-8B[:/GU+c;_]d]DgH
IKF_5-/=^.WYP^geA[g<BI,MNCLW-4Ube2CZ-G06,/+O2(M+IG#>,/I;M__9PVKf
dZJ<=^YJgIKXC?5XN>3,f@AE5G1[-3VC0P_X,D,8Tc+e0P]7CYM]V,aYOg4Q7KQA
MY?W3Y?C19a+FKB\E5#HKK2A9]QDfI8X;=5(\AVYT)3OC0-E#bU9Pb3;^PTRFV/.
3->MJA^MHU5:7Q#@QR\P\C+O-g);MB4X,CQeVT(]XQ&\;aSKI\/@]GMOfW4JL9)8
BCLNf@H1Q=W?(Z.1c2U#[;R.bSK5;ZQZM]:IO7YG,D=2L_.Eb2LF#3PZT:c7TTb_
1.L^QCEa6B6/;CDC,Hf(F^=O=e#NS>d\EOa7+K)EK)GE_E.IKfZ0A7U[0/:,>\bO
WbHI[4G3J))6eM_O?d\ZP8_@BE/R942=ZY-dU&M&-;Sa]7W/D4;JK=L)?Hc^MVZQ
-b4YMQ#8+K5#PQB^B_47)J<:LQFO]T(FB=)[^VQda-gY-V)N4f1.?g,)8R9S\6Ib
Y^IR&>,UR75(gHd>\C2L6]W6.,=GOc=S/<1WG<C=:^NK\C>UNC+e9(=Xf?9d+DGf
(cX/E02+C&dgR+<e)&e1.d4K>.b.fP4a7a1;#c9]7J(R.5.+T]VZ>[bL\WfH5>\1
0R48[9O4,I2aNbW-Z0De7=\G#Q(T#32BJedS743/JgR1H7e17+O-IIfg.G+[US?9
V05(L/B8SKa7?<,LWb2RYU]D5eDO3OBF\EaJDV((5DT0f(<4;.BMIN4=H#USI5H3
Ra3FWF.42TLC,QNAd[19@)N3JB[S_E0ARG..4/H6a-(>RA[<14#MEYLEZOf\LZ,(
D^]g3bV,2G2^]?AY=AZMLJXGA[(W_ZF[e(cK#87Y2(7+GV/^67XU5Vd([)]LVf.=
I6C-5&:>O@e<[fND=;\/==THa+\(LR:(O9#:8]IYgH,X^I2O8.@8;.G^=HeD9-7,
W:dRCg;KedHPQ3WUd7JMbGf]=dX#&WE.=R7BEH)XN,SE44GMHDA#)K/d]&59Gc@?
8d.EKJ-Q5fa8ZHSW/.&5PD1e>;^8(@H4(WA6OLU:>fD=PQC5MPbH[WF@7(1fEcMc
2c+1S/:S]]@-M;8&fg8_I##91V,+0Ag+Ob)-N>N:cX]:N,^McCLPPa@S.DgWXK_#
\K)<GA>g85P-AN(MG?Ac\7d\26FE))-Z2G+ff2[X0Q(P(0+YHVa+-8_FC=-@4MRN
d2=FV,XX1#_E0087UAVJE@]+>(^38JV9dR-;LD(c&2;#&e9Rd6:+5+R],-Q5TPT5
N-IKN21[N:[23[/0W.2--\;/e+XWgbDc:eY@e?c.=[8@1:?@KEH4?GR(>T=QW125
OH4J@W=ZD/-Q8?U\=J?Vb<H^f6IV3CJf#<cdP6_J3dA;:+?VN)A?(H7fbDT?+/7?
L=gW-XI/JJd49dMPgc.KGFZQ2ZC)6&-^84VBZBEfS0,^,?bB\Ng@G#W]/&?_TJMX
^JD^e;FG;@Agc(TF:UM)c&@d]).\;5V>):9#^+T.Xa[(dBR?.&HPEQTHeUBa<,Sb
L>AaJ3Ja9e2De.Y-^O^TNcMM67NS8VF^aB>]R<7KZH[_;J(e<>JZQT?9:Y,55gJA
XYfc-VP(Ee1cLWI+YQ[7&5@3Ua+P1-]4IIe0CI7VB@24+^34Y4)-YEg<H8^.W]YG
A4IMRWN2R:?4)6Rd@e=^FUb3->D9A+_&FQU[,DUSS8FOT5QQB1TL5c-[fO&Df:G;
g;RLL[L^38Q?F+GW41E#S9HJ)Oc,eYL7@6L3,,H@M9cdX.@^GSgP1\NSJb7^V:9P
3+7(WR9/SCJM4_DRWR7E[L-0#Q,-O1gTG66bB(LRQ;_>(ND?3C=S:/,A+U:ZWE0I
+A)-JfZ9YMCBFN[??O,1=&?8-D9ReR7RO?gLaf:cE;d-]6VB20;?19M2c;FZK8B(
5<9[ZF)Z)(NCSV1EX<BSU+\F/UM2M7TDRG#1;R3cRGR/gQEa:[Vg\D];/PaJ^b,W
#f:cN:_Z6/FfL8dAXLT(Pd?PBS;<C\:eK?-]^:0-&4W58f&[/gJ<Q[82=[DZNR+@
>Hd(BS:KVN1Ie7]FITIg<Z3Y7819WMS/.84g5567a<7J-&POe+8>GLd=KNH1W\XZ
L?)R9VK]L2?<P5b3:AG0:aUf7B-]N^-GDgGHV]Q#=Y1__^H?5&8DF26Mdad(PBXS
bJaQP8=ZeUc#B4]\VP&dMfT5&LG+W+LQH+2^CN8HE8]G/J?f.P.GXIQ3,KX/?+;D
=JTf?_YU[fX\6R[D2aHI0^0-6Je#6.A,8K8&@,;+T->5@TT,[bVNU[F^B)EfdJSQ
2>b)]30+GSfNI5.c:Aa7#;Jc-SV=WfV[K_23cO8f\77/.I\8fd-8T&IaGPNJ^QWE
?CG)Yb^Y:#O9FDWIMVYgG>)B<Fe8bLRD-SS>;J#\B>G^X.P=#<:;X(?G6[RKN:#;
3fSK8XUb#ef0BJ2;)#c1J,f,1D3QX;6N44bROd)M7;fbNC]<]f(7&>]/_S<CS^3@
>[7^#d[&eUMIbP]KFZbOab^F((>Z6M8d;JaKbId-]I1g(f;.R.I+BI0/JN>S]DL)
I2?La]-6]88.g@5EUZWF#H>BJP-=b;J-B&(&ceg&;96fe.JPZLU4e?H6DDg6B@6+
PYR;eA-//^g)W)TO,OB3XK6>-4+&d:,P^b6:?7b/YU2N[:2?gC]T&]D.Wgg_C>^)
b#(CS+7/A3;L147X4e;(H#E.-JIafN&NZ^a/#-=Xe9K:0L;U(4C+;QV<7[Sg1dKE
>CJ/4>_5]]L&;IR&>S3RIMCGE(C,BdI[[=O#4_]D]8W>\2HJC^#FbBRf;;NU9]VY
,7DU.#aF9+O?S.EYLO7(\+/M\Cd#??eA1+9GN8U:VEMVBTW?K-=V)0a;L[AcDg4:
UOaO<C1E\&)VN?gOdcZE>(+aK44U_77WUHXd9P^H\)g5.4EASPP?2#Y7SBM)\?W:
&D)=8LY<D02SY6DCY?3[H0b_DN/:6IDHEe6;@_bQY./2b,G&._<:W0T.^aeMC(52
;_;M23f##-=K)g[8WH3D?D<M7d<(K@a8:gY<gHMW;N\,A)G/KeA^3J)#2EdXgW+c
69+2W@#;2T<JCaH6EL?>X\:aJIb[AZQ3BZ0&G>e,_5\,VPQ5NgR5/?/LC^L4E8)[
JVF,@S\(C1>5,]+UQf#NE0#]2LdM7S(PgL5aS<TSGVK]&7?4_ZQD@2O<SAK=68Ic
FL7+&BY)]K@A@JB3-]f559=a)<FeV]Z#_2GT^:_ccB]NEEbX=.fW]=2<T[NC_a,G
4<8TJ0E2,#/@?Q31-^A0)A>(,SK7e]8#bT:]Z(f2@IBV52dSHO&(A>-RL[d9?1@B
:SN^GBW1FS<=AUgHN+CgeS5bRd7NA((\^L?DIAYaM0Y>PYde<.0+7e4E/#FedG@S
+4f\NW:39JQ>eCg68eIZAZd75LLEJ<FAaPI(AG86Zb\@5\W;Ba=e\VA>5L4RE=2Z
8g9(C-LTO]IeRT8_:7PE2//;P^eXI2)NAaWb0NQ9_2/_A_JSa#KGHF:@D[F46_I.
8g]@Ec[<PK9N6S.5P8),<SV+EIGaaOT;egXQVVRMZLCK#4-1Qe)WFIV1V:dfYYRd
T=CQ[KG=<Y7cg[R2>KIK9SZbW]B1feLQa-95,Z5C)JF96]09L4L+E<fcF8K(V0C9
Z.1)R33=)Y[ZTO.\eRY=#D6&4Qa7>.gV,&&:^OO8Yb8,L.T1McU7_<MBA#.N.NEg
C1J)\T@D2PcZV_JS_4HI2K8A[.cgO@ETYLX^U@C7fe/7;=N&g]V3&FK9d.^9<eV>
-A9da]=TN5QYMF>Y8M+&2IVH6fX;e^(CZMVPg,&Q,T4-FGLXPG6&.Y#,Q3HKPF(@
4B?V?)<D\+#=>^1CO653815Y_Xba?g_4GYOK[\7ALfM+K5b/)),R(,\WGVXM6MPO
Y\W>cW(8d,5R@ENHEZLMf\)ZHcM(_Rb&;5QN1=/8HS6O_:>MZ<CB630(RL&Sa[a&
<GY.TF;M_&aSKb?bb<c8,FQJC_5IZR4cfK())K_XGN(gA9:U]Ke@&[EBV-2QD<12
;#f^2)GH4-]+QJRM>:D?9A92#=F^0G3Z42Ta1[T:<faZRFdOP>2V8bRN][C^f4eM
=._3>P3>W9C^Ncc?E0X=ASG>#IRFX4P4ScJXT..Md)Eb9(KA>2Z/YWf>@&aCBZKI
J2SdU4)gcdgLd+gC4G\9B[f(CW89(3<IVQ8U:&P-0?aVR,C/]/T4YO34<2,&Gf/G
=\;\&;gA78K7<=[G_]8KF<-A1FBMQH(^c>d\?H>+V7+0dB]fX&7EWJ7XS.Q-O>D3
GF#RTS=P_a<VM-gXN0L/<J^FbL-\S1a>5(.d6UW(WEc/=N^>](eQg/[C087O@NBg
WJcET-9#O[_<T,FP^1+H60L:T-FJIZYdaM>Sf[A)AbD=L/HId92=b/D]_>HX](2W
_V6#+7V+L>&5),65eY\5ANGETOcc#K9KS5&2X66-3;)>>Q8=C/g<V;++):b.)BeG
Wf&D<,d9CJV8SbAJFK3F[P#_(K:1HRW\JO+1@\J7I(;b<V<A4JfFE,Id-99G0-0+
M+CMcQa;/CbaZ>J^&CGEe_:)g3D<c+-HER<]G<J8]W.]cIgHEQ]dC(cE.Yf0TgM#
#\8OgKTF7Q1K3N?f9HL:+KC:BR5@ME1ZO6fcEeS[XFRae/-:Kd_9EbJT.dM2T>B0
,24CL0#S6W^d7;/Wb:LF9dFQ\ZXZMAMI3_C+&c8KVBB1_HA(8>F:MNU8fb-dW@RB
10;>dT8E\?BdR56\c<SI0+RdH?>&?:^-?F/-L(cL7.(_&C,KXGfZUQ7G+2:RK#FO
_4\NC7d&[NZGTZ7Pg++23K<QLbRG(TfEJ9a/aMGH6(TDa/8ZS88/OEP/M)HI9<a0
7:,<3\T#BKdI_YJXfGaGA#0+ID84[&P0NLXPcXO3]^W?/4(>IS_&YLg()30bQ>ET
gW/BIcN9NUVKUB7_O;dJ=(P8Z0AN][/F;M/N+,/GF#YU_VcQ_1G\6(CGBWP-:P:5
c4]<c5/2B[29SE\&U)dN18:cO\[-3a?4CBZ;a.HHLZbZVTY2/B4A_1O-cGRU97)P
IBG1DI(ec2a]0MRI?+T)NH,3UgC.UC9-SVO^BVGU2LeZ.O)\PO5_W-(-75^^Ng0#
Y:XXaPd^NXW<.D,SW4&GKFcX8.d5)Q@Gb^(Wg<G=DLW>ZIJ]LA1<(3)D<(W\,/(<
1V^?Fd]8^#+bK44U/J#Z;-R,1EfOD^>bS-P1Nf>R:KG[AXG+U;_TG8.N_6S_O;2-
Z]E#--P.a(>dg1_cU6Tf10YM,>3FER\VCR)<_8KL=\Q&]Md>.BgfHVK_&&f^X9b/
b;d30>)_UGZe[&be=#(bS4;;:Q2Xg[#Q&D<BZ6GS-2W^\2S/E5BK4_XGb4-]Z<dX
[IMHQ1&:.c#(,+H2:TJ+_[T@JW/&@-/BB9AbYE5N6[M_aS[=]E=LdYfG176K[8F)
d8c1UgI?-\+Q>4<GVLaJc>I>>/0^7<FC]J9W42cCC>;N>0HdWU#1)>dTNDPUM-]U
aT3c2OR-b(SBb-<R9(>CV#DXW&0#9W_Na;2T-SQe)W+8]gAg_NLLO_ccWJJ.3_X_
IWI-1QIcL^Q70WB6./]+--VEY5eeK)B?5ZF[>])2JY3-<E:>:;;1CC+2JafMDFA,
C+E/TSagSZH7HE@&EZEK,7H,NSYGNcT..-YgW&[.<c&<&O#[#+W@H]RbHZ5=FUON
:E3A^L-^^GD9O-EI+N+G5WDAMVRc>8FM84a)](#6@<^>HS)GgBTAg?4f7(RA[beR
4116AP\P?TCT1d,W.b]=XH6:_dVWg&2bO^=(Y/Dg#6[H+H8Z@SZ4:>[^FYN(9U83
7G6?QG.6?E,S@N)+9?b_H&88TH>F(DK>UTUL7gX?D^;R\ADH4,NP=9I^&UC;<d&E
FY9f=Bb;@^fEfZ)10#DJ2=<RFR5bFZYeJFFOgQXX>+\#W;JIJ)(^>;M^aGP48E8O
_IL-.A4AJ>:#]bA&;F?(.^6UK=@:+X:X)</GT@>TfO6K[;]:]6FaegD93ffY0g;?
cZ=C,1<DDBWc\a0,WCH3+UBCHDHb040a]#9DBN_HPD+WEV1>_77&Z@WN5L+Z2#MT
b0Q74Z5d,T\FeTRcKe&RE#H5QO4#5[EF<;bQFC,fMNf>GSP+S#,1T<gCAJ32SEH7
dO,]18D&^g@WOL3&KZ.7&^G[<VD+UY<fQ=C+@9)5&,H\:+PK]XVM#\YHc1Y3(_d6
E(MF)E6>cD=_2gW6(<B9_8c;=BQM?c]\T_F^<1.U\N@,3OW+&M_IJ9ea+e9V?XY@
VeREWa3JEQXR-Ue8B@GXC=A7WENGNXceK&5\7V:D@K,,#-#PP9F)0;\(>X,BeXR(
FCLVS:20_Na[D\bU0R-C8(baAK]d0&>/Y1ULV230-:bBOR)W/[KPRfab,,L</TJ=
;<?RCIdY0W#<E[Ab8D:M,M:]9#:UBNB7-DXYD&Pf@0Of?(=70&d)d?13W1S9(O)J
@K:QB:5,@V(7V:;.6/KeVCQ4>9F:</d5<G,6H^@N?&ZV(+H/6\e[a(]P1+1GDZ[S
;+]R2K#DG046?=NO9g9+R_.SH0c&K,&362HagJ4bI&[dNCDb0>J>;g@I:>BB+.6-
^962AF0Q5JeA<DNeCG&\d^bI[ee-?99<.dMdd.c[E[b+gF_[B8ISf;bTN&=S&7)1
^<,<aE;gAdeGZfEf,9(79E^;7=#6QDCd_[O.D.Xb,Jd#_VgS[UQXZDSfI<Oe0C:-
,3G&E^XR++NY0+[TFHgYU_<5a/J#DIF0c4?=-SYd019cZR0JY4ZcN+6K9=b,TgJ(
L1:BE]IL-(T@F0IZJM=-1gRI80TeY04e-RP/bZ5D1LOD(g7]^<RbIFA7eb;I)9)[
[OLUA@=/VF_adB9bDIY^\8JRA22,;HUFR.1FP6[5G,NKfE_2PME7=V+c,&(G@GfX
10f^9AO>XD8GdX5YQW&;,RX\@DO9>g/7TM^:)?4V9480f)]dU107g>C@d--7W_4f
51JT,X)f1B:RH-7(?UaJ=[E/CH]8/YUCVE-7<##TbUZ.1]0LPZa.2URIPVM_EMQ.
f#4ZC0<WY;?XPOb^gE:]::e/]#/QW13/O?+g1O/UKXe4(&G:3R9>TWQ]7d1;N@_S
V[4LCF=bO8-5^4EZd9&=d[_5T97#=-J1^:891^J19^JTPb-^AMEAM38UY1G#QWU@
I[IU[1E_d/.AaPf7,,YMFYGN/P3-\@<56?bZ0&,(gW4G1A@@eHa+&/4A1G3QP8BS
W-5?XAY)XM,SM0M4Le^b^P_RC/Hf[E8gJF5&W6?Z,S3I5>:Vb0If972<CA+U:d=W
Cf.[D_5:30b^:PO@7?Ze)\OZWC3&g/?\OZ+FB-LA;@Ud]^VL<D)f.=KYI_:9,W1H
J[e/?2^+dQ7Rb7B+ZIbaKV.55c/#cAKB=<83:8GZHTPM1#E,0Dg_J^O3JbX3GP8[
<^>C=PD(\\P26U<b]EIbUH&ETNBfD0<#d<Bf,d<f)@<600RLUa9b50OYYKSc_EW]
@0)aL.+2#<==E,6b3\eE.&4-A1^c8@[(04-MBUX(Bbd).TC)^==Z_2N=UOf?P+\3
&fb&>J7]3T,VI/8gg2;c.T32:\:>1dY-FXNC5>#ONBL]C2d5(+].0GNE>Cf1><<P
XR4db[]4edS-0J5NJ#IcHD3EU;R#dWD&LQ\G9E(+XJfDQRJXKK6J8HF#NQX;-X<3
:;_++F.>g:.CaR+0RYX7#S1cH,K5KLcKa]KH.IOg6&bCNL2U2KG\8.>^2C:=]>c=
e[8_NGZ;?+0gDD?JOMf;/5^](c=P\@a:]QHCF5[R?1)=JAJ+D3,X[M36V19-]<Wg
MA3&<DO3&N5O<\dZJ4N=0e&N19:d;<A6;A[A_,##D].1\17_>&d&_.R211KY7PK[
)\C>DJL)3LZ^86SeE;QUR]@=HV,4IMOHWMS9<a+/YOPBHKWM[+P_=6>IV^H)A:NH
R:EVcVMV_G\@G&;AJ\6G2DZ2Lb4_YTRH36.,N3/F^fMU<BE^e_3)L11RMK3CD6)J
+)c#35DOYZ&L6+#J:8<g8)#;0@=ZfVa3J(3fIMe+c7ZV&?f9OR=3:S)(a^Y9QZV&
7#6UAHS<X=eD.[9T/PDF@;+X5U?49a:1(cJHT>M=SO\4:H,Z;A:30>DO04=KENX5
bH,ROg=?=?.93ILMJ7&-^OFIQ]B1aeH_+.FPJdCRFRVXcRHb2QW]E9?:?[^C^gg#
Q4[81]C@1YLa#EQ.2WZ6X_)(]2@f7J<F8\^24KN4a@L@TT5]N=:Kg.FD03bT6ZLM
@YX^T)YC)c&P_9DcAALDV[0L3&,.1>3>PZN66bLEb5T\V?4.JUYO[e]LM(>,&AL0
1Q-d<4JR\9IDC10H#59,c=^JE9HH(K0__R1<Q,-S2J5;VgaI6=bZZC\PaJE#MA>K
E&Q,L4?Z4+O/.KJT]2_-?;@RBcP2fg.FTJ7>S[)GHF-&;Y#;:W;a4^a0eX_5@G)8
8/d;Ia8823fL=>]G4Z^1?e-<\?Wb_5G9:gT:U9UC=G4.Cc\XB1Fg.((84b^Ga65a
FXDMN_#-6dYcDXe^f.^AE2be3_5_M=6J+[fX9E?M_[@Z?X&UWB[c:K\61D;MY+20
AIRQJ.+8e5UO#c7O1fC<JEL[(A)GN,KeJP>19+U8D5]PKfb]KW<(aANdNW>O>LBV
<L-I7PP6O9.e,<ONI&DSbL&H=JTJGUZf_QA-9EcbJOG].,ZC+FX=aY[=+,D]1/D@
a&;ZVO?EM#WS-dB)#4XdF#C#QJSL6UR.c)H.M,J-W:GcTfVVORXEfCRZT9&[VSC[
[Y8LEJf&83J^2DcTY-OdZGcOgWUX#904]BM[QRg5>T,@R@\7-+T#Tc];ecN+I23)
>:3-HLOXIS(#.fUUcRa,0Oc\NZ\]5Ug+?&V+[e514=?FHB18bEDZY?BCO[]P\EGd
.eR8cBJ-U:4NQK+T#2;+V&4O.Q>_O/2A=6C/>3JVHIaf7IF^KU6fc0O:=KDT=K[Y
MO)cK1W5/.^X^.+0cJ(V;SP^>,;&J-C\:7HbPCea5Ac2RI,O@aSJFYc&c=FECFIU
@g1IO?TcTcL6(.,-IW[AAF@CA(Y>)Xb7>]70DCM.Pe]O&:=>9M0O;[cS_(RQ],QX
@f05_]c^IE@,SdIaD-?3ZCKI94bG11ad>LLW4.IT(ZS#SIf;g7ANGG+C[JaXPQ+e
W(ZI\3-17Q([<=c>b1RKd[W\e+7X]FJ7)XNc:(.6YeDL&HS-49NV+YK(YGVUT2\)
&&:MbO5QeV?G8K8;T6/W-cf@c48>FcBC;<N@#COc_9F5?HP;HA2)2VL=&;K\7g1W
O.TB>:7;FbTgVE,L7e-:8c>5+gO89LAI8RORVa-Y1XIG,IJQ;E)WXVH6<V,RU)Pd
ZPEdXWdLY3>QM_TgOX0\#S8V4&M?=V_gXY5ga]M.g/M@WA(O2N^@U(\/TX-@9Y@V
-,#Ccg#GG?V?3U^]f84FNa1?ASWP)S^3)D:e-Q=c?b=K6,gN[F)Wgb@=K2.&_Veb
d,0C>=fAHRM<bGM_42e<A_X/I^c;bb^5C:cc<F04KF&4:Lg@fR>+D9M@:MDM]bWZ
L7HG0^O5aaa>8:Sc?,e[2/IIb,]2/6GMaT4>3038<H\]G3=:2UES^J[M28G<8X[L
WOL=_:ETAc,Oe&4P@XP+CSA-@XQ=Sf>]J/[:@@UKS-BD.1_B=YB4[+05Db>>8N4E
/7_f+SgV,^=Z&[eaE8\ZQGFd5QH1?3^f@_-dQ\4Fg:L#]PAM<]V3WfHd[53>]f]H
Z#N&?;S3eAVJg@.,3+W>Z=E0A)3.c2E=Ta?[#dQ/-7P1&feA01VI0f4=L&MD0>U[
2S.-LZ5@VRLROe2EJ?c5Z8:8]U&7P/Z7.(__ZOe<FbJCJFU-7G1.]<SEJ_PBJfNY
#@2\b6;+DF\.32EVAUA>_Z9@Mg_Cd#a=gf?,d7\.G8g;>eY2GL<XDegOV(<=K8G\
cUd+3Oa;V),Hg;JFDdQ<-SZ7CHB^TSc9e_@KJK2;/_)SW=)LK+_6a:2Y4-O2Y7HF
XBIYN8R;[7C+KWKQ67Q5XNO9^e6A37KSaKc@dVY=f#H=:J]3WNH9/_5[eRc^5>2W
YU&;3S=R@Q0-]KMAG4aEDXXRB0,K[176&YfZRWYc97S\6G#]A3EJd6CSa]CfeYFU
1@2b7V[3C\?eC@YV[@Yc<@f:P]S:31CBC;dJDc):0IMaLZ=(HM-=K>;4/NdYQ\T0
J6MYQF+A/Cc:2dd&KX_K+,T#Q8673f9BS\L(F?N:Mc>)4]MMYZH.,/1=KNV-6==\
:YB:O)0/4W:IHcS<_F^=;acMF>9@)0R.LCdZ7M,-_d(Z]I6f7I?1P)VKN\(f##0,
6>d\Y.1_&?N.&S9#fCgEa1])M7=GRD5V/_^V6CST@;9@d]KK7AT.K_(5.^(aR5f.
<;>&VXG&J.B@HF?UF0\+K7-MF_J0])X3dUY&\ZU[gAEeI>;KLe<D<#e0dc,C>18S
^<f>NQH)G5MD=@.0@6_+S4<2:VcMREDLcDMQOX;^W8>AS<0CbJQe6Z:3SKNC2S_Z
F?8>#709:ER[461T;LPKd-62#-dXMYUgbC0LKb6E?eA0H5#aV/K1f-W]QG#b,&HQ
MXU&US8OPg#@,9/Q=9;fF\P:NL&#-#8bOOAIcC0K17SC=/G^4MfH^3M;TR#f,BQd
A>GJ<b3>.G<L1@(N>2MGaS70]cR:T(AZ)O1=H,ZMX=LW7SG8d]aNSY=JD-19O89#
AY9WO[^-YJ[+a2c+b19);.\5>&KM1;.,\+H5Z&[5Kc:bLc4_#QHfH7Jef+\(J1K9
/:90_:8/T:Daf4.MQbW?Jfbb.-MfI9+YJ=VYKPdAR)T)AS(Q\\P[.-X=26f\277R
WB>QTeD8JIN?=@;/Z[R==;6DDOQ5DE,=a#QZB03;bR8eR04L_KU-P]_0f0&CHCZ?
R)L7+fYO4_fIVf\?e=K3I70_E>RV]C(62?c_E)4d6Vd-ZNB^a.a/c0BQY<((<P,D
?57\X[?W2)__@+RI;e]7#X_F0-&CYF9-5E<9D6g&&^&#bR-&9]FSb5NR]>=SZRX1
IL9H\E.F7\1\Vd,][:K4bFH,ZJW>=HL;YKLBKZ<3-U\^4X]]XT:,HX&6Y4/C(3/>
1G/,g@cVgJ7+]]c,C6SH9(0CII1(+1[=TaZX:JB-_KV5(QDOX(6L5Z87</,JK&&.
9dR.EZ,X^EO&&^8.6a8SDC9EJc-K@ZcL8WD<#H1D6JEE-#W)MHU/F3>8:fFgf=#9
FDTV+T5(^Q?/ZEHb#fIdg3J49_GP40)W6O?UQ24#;-@L-Z#GUb^2[R<VDA^e;8fD
)]GgZf-3f8J@J(C(^(WcPN)/WV@YJ7GJ73)+LU7@-M(e@f[-K2[])[B=-8KQaAg4
\-2/N(24g84d<AF5AAbL&E@f>2;\4Of>5-0M(J;:<CY(TKKJY=OV1]3dV[@d:K5,
bD:E5;,+MS)eS;a_]P#3]LUBaW(<I:+O/NedV?>+7S\Sa&>.592L.8BedgeDU-5B
:8gMdMHg\8,.A[e6>N\S((F1MZG2N@((Ie2B(Z/IXTMI.c[/[.CWQf[1N)CS[M2O
@J=3d7Z0I20J7>PFY(7T53ERfeMEDIGa5FdT6<,@5A[IF))H:V\:P8E#1\:2ed6?
C;<cJ&c8@Gd^?F(QQ,-g\)d4N&W4:H,BXLLd4UXB.(-3X02.@DK](AM/T9V9N1R[
/dK2W73fRJ]-&bXY,d3O28NQRW/H2YH2)L,MZS@A@ZCK3WU\DUJ-;[HJK.#Da6.O
8/1N#IT,YP3e@<F@g^0>cMSDF.<@/bdSMS@+aGMAc5d5#X1Q?Wa&0&C^@D_G2+dg
G3H,U,=&f)GLFR_9BW/BBDA]8c<.<B=eGTbJ=?4<X3<[_67/<[G_gGG1KOP&HD75
2a5g=Kb3Y2@_91.Y-dH+MC]MO1KCaH;5217DfV-UcY#7K18V0O\>C@_-UTF7+=^J
a(.19Eg77N:H=23=43^9B_aT+OPVSFa@6>JZ@aUY:Vf=S)==9?)1ZTPf63-,@A[C
S[D?OEYg>OGeg1QBZ9WDA8M)2Af^@3/HX330^849W.I2Zf>?(0;P;g(R_)afUETH
E>3O#[9AR1;I533_/+Z];=\<L)3RdNVRM?53Q6eZ-&C.40.UZ@OLWLE-44F2]b#L
&#=7b?2HU4_a4/8EfR4H:-VU1=Z_OSCJb1=97A_a@6M@dC4-b=FC(Mc]7VH.5a.4
fK30d,EgFfVPE_dcRT^a6;6W]R9B&O\QfV<EbW,BF<;,>)E,6<666f@I3Z(FH&Ca
]Z4;9TS0\;M<U;:7eL&MU/3dg\GG,A(;+I6X/g^[#=SDS-<f^I-#Ve:GAUeP96RJ
eL9--4B+FN=QGSHgB>:f/E?#10WRFT2N=cfZB^G>_H0=U[9,,MI9C+QTR3FYe==W
)g:10CR+(46(WbA1BeDM/b(\ZGX:@G([.??PfXdd)EY83?SAS5J+Vd8\PX9>ZD^9
V6eNQ_V7CE2]7WBB^8X;a:SXOA^.1WH9DU?DZ:4S9Z>]P:W+,15(()b<C9,eACQb
1PgAZ8@>Yce\#ac^=^];EZ]>0@Qb&?J.)c1\H@]H@#^F[_&0RW[O:bZ^0U)#XHO=
9+4c;@.eI:17]e,aH?dKRB:/F[XWO&(6TbDDAG3]-U<.G9Af3(+@Dff1T2f>:&MC
bd;bWNS;-(>:;-e&0];_UXK?Y_^_H:6fGfGc@a35.1(g,6/;T;R2(8IBO37T^)MS
(P^(6g\:;3RfX;=TQRdQRJB3XdN8G&:NKT=Y.;X.PG,S<Ef^N3S[c:b9808#1LV/
(d<Je;;A?[d/2K?CM.XB9.BEBd_]0g,1K>2e]QZZE(4:JKZ=I_Tg7=T/IZ/1P@0)
9/6E6_16\>)e#FG[:NEb9LKRN=7cLY7J5.?JF_1LKX[f;CM/5CfRQV-,^J9(.Z<_
_M>)b[dY008I)7)48SRC6]Pc+HR4.EaD,+003V>,_R.L[>=H:7fgQ3Q5c;&C:cRc
-:@g+KSI6[__+YI3_2Y6>g:O^&6C_J8c-@<2IM:G=N<MU(S(J3^eg(NJ@P:3ZG.[
FL8?&CWFQbY1)4gC_>\1AdMMI&^&3JCVH/JGJO<)73^M)J2Pga&@\13af;7Xc[L^
5EJeK>a.,Y6A:W\K4O\Q)RJSPX0YeW+VD,W<(CF=)-LE@N8bN-#fX)OADg/21\D@
-WAH,\I?Xd<gMAX;=]<MJB/2\Q-P?F7g0#_LCWF5.JA/#HBBL>B?cA=8B^0.+.B?
B:fO>QM4DIPP43CdgIV-N0,DHT2aXPREWUaG>,J^1EdN??g/g9d5G1&dgBH+9+?;
DHH[J0^4J)e6cMR7U\_ULZQS^BZUW\7S1522?MKbg6D&G6JL/XZYA&>e6Z,1[98-
3XAO38ZMc-.PRZ9&>YBeb=(IaE17.ef#<7HI;_FCT);+S&/O@PMYBFQY\)(gecO\
]e8L5eD]+EbVNV?F\X+>CV#Z?)I&0CH(aX95g&.NH(DY2fMK)]ER7GXOH/>EC3(D
gLNE9,M2a0a\=P0_8^E8_8FG6WHTaZ+QbIDeHQCgdJ?A_EENXES_#\&KL(gR_/QD
GHZ[EO#AfXgO8+gS6YVYHSE_W+[XNY;Q)=_=Z4WBeW)d8H7FC/RZ6OP1?Nc2&P@)
;R+V,WARL2Z>@8H19a3PHW<8+ZBQf[[GW31V?>ZB[=>^V<X77IRXdcC)+?-.@/8&
b;[.B([Z9dOgc:MBD[=-BJ\2d0H(]]\+4QP9ILP21P5KA(V(R-I>78VEDRIZJW9X
2W9IOc>4,K(f^T8;<7c\K[=@+deSKQFR\6-?I566b+<dRT?V#4.GX/:ZV=BIVBFJ
6+,KAO(X\SK&5d76FCFe@5_&:6<^\D@M7J_ZE,9RFMJd84bX)L?A_aaYN/>?02__
7+gX)McCIPV[)(WD\06=L3VM4AGHY.\[@cK;U)#GG?-<b_4F.L+P<>\Gg(M^HA8E
C<4ff5]0YTAeTQbYc^<eE>Y3ee_XKDK/7&:W;^QH2gANe/M,/<eG[YI/_=]FEF,H
X5^2/\GX[K8QK[I86^+^aRfW?IRI?-2?,+?WdbZR&1#F3b7),4b?CC8d,-K<fTbH
fF;NVRg\cU83@dD9;?09I#^<E4C#&L)[3c<0;;6gJLG;PLFTdV=\UTL[]>\?7<JA
fSPAPdX45FWM3J<M6_/@8P@6^+<G7[1)9JBNc[OL-\Od,MLNa-E,^9cFJ7R,_IgT
/cAD(52YV^YG2Y_)]<6146],A@+_VfL4XM@L3+(U(CaU3FAP)KM^>7g8E<HEe3Og
U,W-V6^K].C#97JLO9/<&(L61YSW#dC<@K^T-H0fTIF3L<\L=gG1IZB,T>c^f2L<
8[J_YQNV>bHNId+K]HLg_OHRVH1M96-aD?R,D^[(g;d(Z1aW@=MFeA1d@(#1OX[+
71c7S6[LQTMf7&=KXaFAJZC(\N>S5\I_ISPIF(db>=O^^G_KK<:.aJb,6Y@JaSRB
I\WJSD-De>^2#gX8S4([_SXa)\R1Gd6eC&^Q/2RL=</B^Ua69fW^dH/gLHQ>#I0g
TXcJKc.Db5NHT(..HVgF>:GBD74fW]a37e1.X][/#NED\f12[VHDU,6W(3PF3:&3
Ug#<G5AKJcXB==c[.X_^UJJP&XUGQKXcE39^6_dRMd/<-K)bR<AK[H5><GQ,bKS2
V6gA:e+E>TY-Pg9]CMF]:E#9)&OW\V(U.S&5=C^UcBc=H]C(ff[f\X+-4P\,:8c]
4H2#0Q=,\J<7(G^f0/VF3+^G/Yf_b+0T0MM#,9MJUTJ^P9eP=2V4@+7_4[30;AE#
ag:I6><V5>eB2-CF^#OcPF&AWZ:6?e=58C<f])ZCT2UB3<1fbH3]]W=f0?@BbMZ3
>5df<UU4=48RZQ23e^b^M+-T\SNb/MMcLB7E(?eK1HX,_/CbRF1]C5?)WHf#T&8^
VCa90BGgIOWM0BDUW8Nc,M_TO28;^,<L_f+E<R/<,B4c]/8()gaW^_dOO[#..f6d
=cfC^87ER0d16]CVNDM:[6[gBIYDQaWMY\T9D/E]YB](aX2g7II3D8-/L4UaMKIa
+44<[#.7)T@[T[aaD8[a(dTEUT6#Yf,&-(c9Vb/ddI1L3CC?5UC=Y[Gd2;UR4XF+
,_a,(H63cUZd_BZ-ERH7HT<40<4TS=4A^>XYa)UM-a?(7f&=&,N-2gUafOHF@LAM
I3EGPSc9X\(7CbS;0BV[)dU.]FED1CWEXB71),5:P8cMD?\<df.@g#Z&gG8;&]4c
B0dER^cNI,e>4&TCTY>,6_(P)]DBeYY?Z(:Y#cQAbF[5JM2<WQ(EPTL<g3@f29.J
S;]INb,^>Fb-e>8J-+4c43;,Q[DG/:A]\KEPId<<TDK/26+V+aR[<3\IDCNP^UF@
#a_HeeE.,28?(39S>d,fAFKU8/I1)J:S(78eNO8LNT]1N6a\_+5beK)]eB[e5@B3
_Jad[]2^K4[<+9O.LG&UZC0TYNc#G]PfG^J5^MbS<#3O#P9DVaB_-E3&HN@L3-H&
=3)Gc;+>KH0JQcY3_e[:</2NL>[L^.e6(7f?3?5c7G(4^.D<O.475B8;1&SBFLU>
>SbFNYH[,)ROYY@T.8Q(,>MSS?>2F0GTcM#O1=W,P33e(OQM:Yf+B702N0^g9-4Q
XJ(a4@_LL@T?V\E]N5P.f?fN9Y/Q],^N43QOGg2\C9a9^OdbDe2e+fHA4K5:\V::
.51U]KOBH(8eMWD4DUafQ)Z1/5;c=3FIB004QLJ=KcMLMFNfZ:Y#G+#;>11FYUCI
V&>;Z=_(SeVZD,)/.d<F#g:bPO_,Q8-S0/5KF6DVeC/BW@6XJN<^=71(?6@A)F>f
e:Y/DI=:,O-.d3)>CYD3dfG#5^GCdE(8B[L>F67]UJLHf7+KbEg;dDGf)cLS(]&)
O)(b69HZFf3D)BJ\.8R;@&b@aK)&2A]SdYYc\VOJAPfcb8.J435I-6Va7W]H1)dZ
L#6cVLHVNX0NXG9+.K[Lc@?aI\,A:\)5:UZWGY<DICWWLK2>a<W<6W?>1.e/[WB2
JJB<U6(,881RKN+]Y<P<QF<L8@18fe1B;0PJ4BD;,fB6/:DIUDff;JLFgSF;d;RZ
U#3aZE)7)P)PRQ#O]P\&[dN]F4^.0NO8_b,c_-P1GBKQfUV(;eXUFG+KU]_/YUET
PJ;+C1QOAcHg;M2)gfPPE?[3FC@OYP,P?b=O?B@54N-gdUA<__BTJfFW2B3g#4RD
QE2S9P:&cS+T.\>#cZ&S?(O()CAAC(KTE0YUAg_VN3g.bQgX.(;5XgZ/PHF)/U)#
-\VOC/_(H+daRQBO9b5d3<#?QZ](1ABbdeJg<74b]O&PH]1,7-1gOVIQa#F56^(4
73S\cd0FQ_dY4(4K6@3-1D+M/<,ggGHDWUMF68W2Jgf38\8S0f[\-((Ka3-\V\OH
,F<dEVSWge85GAg4078HYXCJ\2W-)4.#^[VDGCd38PAMFQ@ZbDX;17RKJ9&8(U7K
P+](Ub2XF#U89#X-.4EQM@)W?+<L@YW+1Y77.#/PO0<X4aLD_+9AP(Q5A/S.fH#Y
g0?\<g>Ha@U4L)c^Oc<?_MGTc;AG4(0ST.\?C)/f7KB7QM0Td1V4+#C_@f1.4+g)
<S,W\aN<?U5C(gAf>3fE,?G5Mc0cJ6T)[CI0(/WM.)H[U^FHLO;7QHd#[RM/72e7
)Ce[=c@ATCb7;;5g=HFXR1Q8K9Y6(TEYD^NRNE/DXHU;AQ?KVD<8W4Fg7>G7N3-:
f@&?g78D4)&33>B@(_gC9abXXMg#<X#eX4Y4aJ^H,I7GGEVc1NfeD_82=LSU24R9
@d(3LJU#ag<0D657PZ,1a.9@Tb0G76?(9_0136ADG^./Fd##We8))C[3c7\F3g4M
I(cW7;75PBdY7H@C6aFN7\<FRG0M=/3YZXI:A@#(VOd=^_1f2B,SY6T39QNaDW2]
X]?YMP?@ZU)a7.RQ&HV:N16^LFFE;gL4c(LNS.XOO6^#BQb.V^R,,/0Y)E<6,AJC
85-7?NbUG,@-CNV,-+9g&-S3RON;F=0(ZF^_MT:?8<f\A.B927A7XXX7/F5cQD<H
)/J967(NM/_?P:N<CAKb?7SccW=_)87FH;7QOQX43UKPDUFeLe+<M,^Hbe0b4/(W
g2QTNQLS[\d[L=5RY)ZT+IBM>eG8LE&,<,27MIe_H-J(KLf/E&)(MNgRfEgIe4K_
;D=#PZMW4W-C,WaF,,O^_0^6[K&<>XD=U,L?CJ0Bef@+bGOa7DM[S;P]/\_bIJ@F
<fG75P?cKGQQ.@Z/(RdV;72/ZBX;ZKD,6N&3@+?MQTMV7C,f)=Mfd(0/V48cF0&g
/)H;V<F:5-RKDRR-)I99b,6AC0:_@)?^-/)FN73437_RP+8c-;GP?>AO8,3@>V>-
YPVc9eQG3#/N9,R@;Na^:CFgGb;6WY]0D?GXFbQC]>eCVaK,>[^bM82_0DSPN>&d
OYU\@6(eC?05#7[-CLO+gC[SI1O>3,dCD^+Pf[HdWVL7W^F^7c[/Q[[2<F1Ig+MB
V_aDAOD-1@Ka&[9/R(LQS(VLE3G#6#-N2N=(R_H^<JQC2U@;cRg&^P_>=6d<WfE3
/#=VRX4&4TT4):IX?c-E7.GC32RVg&Y0WDX,&9IO^CS/fU53BXVJ64MKB8(=9:GX
4LD:P];1?Y[Z:YI>+;V2R./0M(-P0+C,ZG@@<O];#EW6>H(RA;>MH65-[08RbUR)
=7M/IL3;.N93#6B@EOf55:_^NLWC-3MT/+_]Y#9KCPT>+_b\N/#@308WO13LU?+b
<>Z)>LM@-UU:@D0JK:aLT[S>#+R(4KW-c7:OL--H?KDD2#6Z2P-g<[16,E\EN^E-
KP(WTJ3-(M4FZ@Yc&aeEB=X=+g>]K8(YS>I?Gab@M[Q,Q)U?.JV76,,CBK7H5E&4
f0#\D3ZM9_+2/6UcVB5QI6TeL9?GX?A5-]:.)F,)W0SPP3d-UTIc,Q_gQ+479K1E
UJ+:\1.f7<.8Q3fX<A+HW^c=_JUaRNf,GM,XWL2+4;ZAH1P&=EATYYQ#JMG4Wd9.
N6dB@P@?aWga<5F]gI19UTHFK;cJWgf.FWGUSN3BLS&O=T0V5DRVE#O;6\CKN5=0
J2L:.G[<Ec71P[;;P:E[AH2JK=:<[HAPLUL2ZdE\I##0.95THG2RZ3>:e6<).IFQ
C:E_&J?.;3ACZ-06#6eS7<BP.b648^XPN8Z=Yd_;/;#QSM+1UcG#7Q.&;FUNS6>R
YO;M##9QDK@M;&C)YUS&fX@M/5E@3@&DCb.G[PPU)[2TZY)J:VA=J9=bGXUf1ff_
6+T-b#P=]^:+>gJ,B8bMbB#C0g060/6XO?&_dGaX<aS-ae9dZ3#U7^I(6ecI1\M)
:0D\BP_<ea:L33V^JcG,SZ?U[\CUg<)M86QcCB02,eRO=,&B.\Y[_c..?cTCITS8
KZB)6;QYDY.ME.;AM3+X#H2TVdWfZg[UbNB(K/Q6#+,53>RTT?S#&9=gTRUedMWH
@Iee(H&DLP+YXIUE:M@+O?R[OVQ9G2/NK=T7PZ7,DUeHWKc\Y:34C8<20#@I0N7f
_@UZP_::P[D8.J/0X^+2&-?:YdbDe]gYWGK]g&H#N.ZM(?SW,Y2JZ4J68F[+.^]?
7.gR)aFX0c;P=RB<:YXgO[0.7;&HOY8]e>VgURGO0#?YWF0EI#g7C16/7TA@OA)I
3<Zgc:,Y-DD=O[\VYIO6>4RR0,=2BVN[X3VBB3SgUQ/Q^_>E#^.:c\dbXbSJ^Q70
]<f^[JAgPQf-\2)&-6CMYI\;+P[N?Oa#S&D@7[aTHe8O18c_N(Ig=^.#;5+3f<eb
;2=0SUe@Lb&Re1.bO:E^:_8dD[R^@&&g;BC1T4:Vf_YYH-]?[<>DZADRKJ:Q/JPg
HaK.BWJ+@4Q](]O2PDQG.2[b778&TJS/&:g]J1L4G_;L/OCZHL#U<T0(?0F2\E5;
gaa6HM:(9VYQVOO[M<^,:c=E:<1A\Vb?#NPc&--gQ8ZdM(#67V;5+)+4P/>A/dJg
IZag^\<+2;<1DXJXbE9[_T7\6.1ad/7UaW8C]RP/\)-W=5?JHW0#XKJA-;c94K/d
9TM2V^acd->Lg9XFWfBS<2B0[YKPVUH5([Tc9H&Q>P#N<];V_aDJ=D1=)@E#OM@2
60e@.Qb-:<R].D_@55X_Z18D-?_e(:R[FY2UZ(<8fB\RbSc?>_^C-HT8-E/VVV\9
TCIJ90PSaBa7.8&7)?Led:[H=g(d61GS25g-NebB4dYT^L.65N0^^2^0UR&UG&?S
XEC;P6TU+^8b>X6LIJ<OBGZ[TCKYYR\\ESYMD,57O0gW&_4U]8C4:\M#8aKFRA?:
=H<ASPbcI<PdKY-V:LH68ab#SLT=8,1H8Le1S=TBV7H&V;PfD-K6Xb_&)TST/<K&
^DV3H;9LGcXRcXTQgLF?7..^>1^JCda91S7XgZK[7Ba3FO1g1aO[bJ-FU^8FYM?X
1[6YXDG<5^5&Y&;X[aRJc9^.5G^S)U+53X]R.56DZ:]2U9Sd\1B#^be1L>^YKeL-
9AWcbDYD0^:RGC<[RZGU+F>9L2EU<bUHZJ)0I=R#>VYMV9D8:[O].T:9fEf[.fFA
U+gT+e3XE:gT4T>?+TcbaL\KOc:,LE15?7.B^,CLd@e=>;E<;MDXBYQgQ]&?,Ec9
7OHQ-56;\])5NT3db&\KG_>9&_QV7>J.@dTR)Q8Yf_>?CHI[_\O@?)F1eRQc96dY
LbFYH=Ig#/7+Z>8G7WgJ/-H,dgd5</?6WLUZIe)7P]N>?eGda2.XVJ/SC=A=aLL=
P^S]H4RQ(-L\=;,2O:?CCI?]:NF[<7##_>:Y-4=4^^^=aI7K&dNgJ#1fUgWf:daX
EA^5E_:Y:5[SL)dFRVO_9b5GN52)Kb_UOb\-@PACMccVMe/PA)5@B020SUJ;PcGY
DO\.gfeF>Z8LW.-/0/J8c+H&e1#N?-YK=I5O.JN04VC_gZ:#/<BTR_G^NP<,UG/(
;X1-T5ZJBF=FD=9GAT;Xf/)HPaVC>bZa</4MDT)[c]SU[\(#WM:H[++G&/_)&P[b
[L2M87D,CR?W7F+4\g-/.;:b6W2:O^<PE^OCfIR.&DK#+eOE+#SMbY0#3O;/#)EK
LCL.Xd0I4(BZdV/Q1K[XS.5].Ka\PbIV>(a[Q>d.e6,,,4BgD#5U?<:J2^ZU6-T#
dcFNHH+Jg+;U\bfS0EGX^CIF=W:D+=U/SQ]e]1](S75EB4_@ICBfRSZEdaWG1.Eg
PL(PBdZ\IKP;26<J/]OXM,7<d5VPB,c930Y?Z#?aAHcUOTIJHbH><b<BAe394#<2
=2RUZT,aOHC.+#MXCc?;^8bW(U^8JDU@R(Q-5>G-OB-Y]FNgDM@:[6AV[1?+GLca
V@I_<4PMfX7.WZLQFRT:c6P95/-FGA)O[QE?YM2G8P[KX(dcf-5J,-V:X@LCR>RH
T@)<>Y&))X^0[MCMd1eD,@FZ-gN^IO6eIb<I@BXPXDFd5<M.f,3[^=)KBQP>=.#=
12U8S@f@4T(D[B^Xa@(.dSe)=NNL],.K(9&RBBWOGAMP(09^W47TT=>43H@d[O5DS$
`endprotected

   
`endif //  `ifndef GUARD_SVT_MEM_CONFIGURATION_SV
   
