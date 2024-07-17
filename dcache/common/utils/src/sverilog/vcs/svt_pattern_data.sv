//=======================================================================
// COPYRIGHT (C) 2009-2015 SYNOPSYS INC.
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

`ifndef GUARD_SVT_PATTERN_DATA_SV
`define GUARD_SVT_PATTERN_DATA_SV

/** @cond SV_ONLY */
// =============================================================================
/**
 * Data object that stores an individual name/value pair.
 */
class svt_pattern_data;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  /** Property type lables used when building the pattern data structure. */
  typedef enum {
    UNDEF,      /**< Unknown or undefined data type */
    BIT,        /**< Data corresponds to a bit value */
    BITVEC,     /**< Data corresponds to a bit vector value */
    INT,        /**< Data corresponds to an int value */
    REAL,       /**< Data corresponds to a real value */
    REALTIME,   /**< Data corresponds to a realtime value */
    TIME,       /**< Data corresponds to a time value */
    STRING,     /**< Data corresponds to a string value */
    ENUM,       /**< Data corresponds to an enum value */
    OBJECT,     /**< Data corresponds to an object */
    GRAPHIC     /**< Data corresponds to an graphic element, used for display */
  } type_enum;

  /**
   * Display control used by the automated SVT shorthand display routines
   * to recognize whether an individual field should be displayed as part
   * of the current request.
   */
  typedef enum {
    REL_DISP,  /**< Indicates field display for RELEVANT and COMPLETE display requests */
    COMP_DISP  /**< Indicates field display solely for COMPLETE display requests */
  } display_control_enum;

  /** Depth used for the SVT shorthand routines */
  typedef enum {
    NONE,  /**< Never work with the object reference (e.g., Never display it) */
    REF,   /**< Only work with the object reference (e.g., Only display whether the object is null or not) */
    DEEP   /**< Work with the entire object (e.g., Perform a deep display) or the evaluated (e.g., based on accessing the calculated 'get_<field>_val' value) value */
  } how_enum;

  /** Types of alignment during display */
  typedef enum {
    LEFT,    /**< Left aligned */
    RIGHT,   /**< Right aligned */
    CENTER   /**< Center aligned */
  } align_enum;

  // ****************************************************************************
  // General Types
  // ****************************************************************************

  /**
   * Simple struct that can be used to convey the basic 'create' elements of
   * a pattern_data instance.
   */
  typedef struct {
    string name;
    type_enum typ;
  } create_struct;

  /**
   * Simple struct that can be used to convey the basic 'set' or 'get' elements
   * of a svt_pattern_data instance.
   */
  typedef struct {
    string name;
    bit [1023:0] value;
  } get_set_struct;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /** The pattern data name. */
  string name;

  /** The pattern data value. */
  bit [1023:0] value;

  /** The pattern array_ix. */
  int array_ix;

  /** Property type */
  type_enum typ;

  /** Class name where the property is defined */
  string owner;

  /** Display control */
  display_control_enum display_control;

  /** Display depth */
  how_enum display_how;

  /** Object access depth */
  how_enum ownership_how;

  /** Title used in short display. */
  string title;

  /** Alignment used in short display. */
  align_enum alignment;

  /** Width used in short display. */
  int width;

  /** Field bit width used by common data class operations. 0 indicates "not set". */
  int unsigned field_width = 0;

  /** Type string which can be used in enumerated operrations. Empty string indicates "not set". */
  string enum_type = "";

  /**
   * Flag indicating which common data class operations are to be supported
   * automatically for this field. 0 indicates "not set".
   */
  int unsigned supported_methods_flag = 0;

  /**
   * Indicates whether the name/value pairs should be the same as (positive_match = 1)
   * or different from (positive_match = 0) the actual svt_data values when the
   * pattern match occurs.
   */
  bit positive_match = 1;

  /** Additional situational keywords */
  string keywords[$];

  /** Supplemental data about this pattern_data instance, potentially situational. */
  svt_pattern_data supp_data[$];

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_pattern_data class.
   *
   * @param name The pattern data name.
   *
   * @param value The pattern data value.
   *
   * @param array_ix Index associated with the value when the value is in an array.
   *
   * @param positive_match Indicates whether match (positive_match == 1) or
   * mismatch (positive_match == 0) is desired.
   * 
   * @param typ Type portion of the new name/value pair.
   * 
   * @param owner Class name where the property is defined
   * 
   * @param display_control Controls whether the property should be displayed
   * in all RELEVANT display situations, or if it should only be displayed
   * in COMPLETE display situations.
   * 
   * @param display_how Controls whether this pattern is displayed, and if so
   * whether it should be displayed via reference or deep display.
   * 
   * @param ownership_how Indicates what type of relationship exists between this
   * object and the containing object, and therefore how the various operations
   * should function relative to this contained object.
   */
  extern function new(string name, bit [1023:0] value, int array_ix = 0, int positive_match = 1, type_enum typ = UNDEF, string owner = "", display_control_enum display_control = REL_DISP, how_enum display_how = REF, how_enum ownership_how = DEEP);

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Copies this pattern data instance.
   *
   * @param to Optional copy destination.
   *
   * @return The copy.
   */
  extern virtual function svt_pattern_data copy(svt_pattern_data to = null);
  
  // ---------------------------------------------------------------------------
  /**
   * Method to do the value match, taking into account positive_match.
   *
   * @param match_value The value that should be matched against.
   *
   * @param is_found_value Indicates whether the match_value is real, representing
   * a found value, or if the field could not be found. If is_found_value == 0, then
   * the success of the match relies entirely on whether we are doing a positive
   * or negative match. In this situation a positive match will always return
   * 0, a negative match will always return 1. If is_found_value == 1, then
   * the success of the match relies entirely on whether the match_value compares
   * with this.value.
   *
   * @return Indication of whether the value match passed (1) or failed (0).
   */
  extern virtual function bit match(bit [1023:0] match_value, bit is_found_value);

  // ---------------------------------------------------------------------------
  /**
   * Method to look for a specific keyword in the keyword list.
   *
   * @param keyword The keyword to look for.
   *
   * @return Indication of whether the keyword was found (1) or not (0).
   */
  extern virtual function bit has_keyword(string keyword);

  // ---------------------------------------------------------------------------
  /**
   * Returns a simple string description of the pattern.
   *
   * @return The simple string description.
   */
  extern virtual function string psdisplay(string prefix = "");
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a real. Only valid if the field is of type REAL.
   *
   * @return The real value.
   */
  extern virtual function real get_real_val();
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a realtime. Only valid if the field is of type REALTIME.
   *
   * @return The real value.
   */
  extern virtual function realtime get_realtime_val();

  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a time. Only valid if the field is of type TIME.
   *
   * @return The real value.
   */
  extern virtual function time get_time_val();

  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a string. Only valid if the field is of type STRING.
   *
   * @return The string value.
   */
  extern virtual function string get_string_val();
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for returning value as a bit vector. Valid for fields which are not of
   * type OBJECT or GRAPHIC.
   *
   * @return The bit vector value.
   */
  extern virtual function bit [1023:0] get_any_val();
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a real field value. Only valid if the field is of type REAL.
   *
   * @param value The real value.
   */
  extern virtual function void set_real_val(real value);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a real field value. Only valid if the field is of type REALTIME.
   *
   * @param value The real value.
   */
  extern virtual function void set_realtime_val(realtime value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a string field value. Only valid if the field is of type STRING.
   *
   * @param value The string value.
   */
  extern virtual function void set_string_val(string value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for setting a field value using a bit vector. Only valid if the fields which are not of
   * type OBJECT or GRAPHIC.
   *
   * @param value The bit vector value.
   */
  extern virtual function void set_any_val(bit [1023:0] value);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility method for adding simple supplemental data.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   * @param typ Type portion of the new name/value pair.
   */
  extern virtual function void add_supp_data(string name, bit [1023:0] value, svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for adding string supplemental data to an individual property.
   *
   * @param name Name portion of the new name/value pair.
   * @param value Supplemental string value.
   */
  extern virtual function void add_supp_string(string name, string value);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for accessing supplemental data.
   *
   * @param name Name of the supplemental data whose value is to be retrieved.
   * @param value Retrieved value.
   * @return Indicates whether the named supplemental data was found (1) or not found (0). This also indicates whether the 'value' is valid.
   */
  extern virtual function bit get_supp_data_value(string name, ref bit [1023:0] value);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for accessing supplemental data as a string. Only valid if the supplemental data is of type STRING.
   *
   * @param name Name of the supplemental data whose value is to be retrieved.
   * @param value Retrieved string value.
   * @return Indicates whether named supplemental data of type string was found (1) or not (0).
   */
  extern virtual function bit get_supp_string(string name, ref string value);
  
  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

`protected
=DF0,T,YcWd6X50G:dPN)eC7,T))_Q\?[6O3LPF5OXOaYFYGI@.7.)G<>^CcID?=
-/YRf0LC:N22d==cbgG^?BZTJT<9Wf.a4@HWKW(_9L3bd[TN&66Mb;H&aT/Z2OR[
g62(cCP.<(A]ZbDT8^d&&=H^OXgb](3JH(NZMCNJR.#8R=:>](RGbR1]EL7T2-D[
F_9R&_.X[fRdGc4aZ^1)(c_;d+dAZE<SZ/POa<KTRQY]2fA1??(4#>MaH(ANM+P1
_,dY6Vfd7c<<Sc[-\8-?0C&ZFR[3_;g9:J;X#I_4^c58J[_/be[<OFV?,K[JQ378
Y]A56^)23U4YBDG1[Q=G\:WE-A?AaUC-K]-V9O?J-+011bRSMWgARIJG61KO<F7S
S.B4+/.23HYF4?Yg@8aCKOYBX5+@M\1XFB]C6@]\KG:3>;\@#1IaFa@Q/BT@2\[)
R.T6a=M[R0E:II7R(0@FeRe?O9JQ#cKK5^[]JZ;./IUcKZc6R.LCN60AOW)(W>b^
S<\IMS7DG2Y9Bb9VY-265>K)VIS,@SN#@H-]3,eSR@\g4B;aRUM6>R@1;?OG8X-(
&:5MRRd(e6NLVbY.6R#&RVT3^HWNBI5^PBRLMgf-]L@]dA37)E5cF^SJ.43IVQ37
/BIDQ<b6G&(>5NM(Y7)/P]T/HJA?E@++^>J-_#Q46XIC,b+cEY_0B4ga#J93T25f
0eeFF><4HWOS[4dP&]3Ggdg#V.>-8?MQ>fgX2d&D?2LVd2_gK0ML,\?Hf)ZeT<D-
:#2.0a<63H)eHK;B-SF\4f42JL-MGJB@P:(:5+ga1^b]-RMD2^D93K3e(@1RGWae
8O,?fQbed+aJGCa7UXNU5N6.BIZXGba_dO3V&FVZR/Pfd)]2@N)ZcRL,=b[<RL=1
K2fAL@U@M8_FY=_\#/TMJgdM5MIbZOd+T9ZLK\WISL];f.C0#;5]HSI_>3.>f3gW
DGR:QS@4DbI6>CdUVNQ7BQS;cF&P^,M][J6XV?]9ZC,,N9:R&?e9M4<GFH79M)^(
C_1N<;#5;c.-A:,2abCd[2X?NF>X0,1HR=P\))\e@BHO^N5G<YW6)X&-AWLO&ZH5
L/;6DZb^YdaMJU@4PT@Y=.3EK>RS(,(.=6&1eaD-/fNXa[_@@:Z2/&+GdPW(9QMS
#XIbfC.Z2MP^YLYXEV5fIc@6_#0RTNbN^(>,d>)1.VZMLDD\P<M>.=e)GX<5N)SB
gUb[d/VYZ7VV#9XCK.F\K)Q;4M]6BT=+I\f)>:WB=aD@9fZCH[Ma0\7b?Fc#XG_?
6PAR]E):0,;M8&g(IF.R?Y6CAO_dZ&.^U0]S;W;S@ZOU3_M2gH<UO?7f@Dca>6HC
D.IJ&RXRP&R@K.&]Ua]9X=:NPOacQ35C&g4/&XH-N<E<X)(ZN[OW_T.fF<U32;5/
[ca5e4XS>;d:AafJcA<H#(AVEIe3Pe(PSLd@HU93VV1.7BOLg)B.J8eBG;LCBNNa
^^#7Z>VOP73g?<[gRZY?=(dcUc&B#/@#J?\@:LQ4[F@0A^B?F.Qfa(d@P6UL&;g3
41>A]c2,]dgTT)Z8K__6VbLLKMM8AE01d8Fe0W+/)/HD?(5#g>VKWPc+F=;c&QM[
V142=F/]SLF?1c1VcFWPF@+U#;EIB:AV<]XPRU94.Xf#<6),<aSPZ-a#cFE2#5/c
V7:R9Q-Z&Cd=&Te76_<[JL2BN#=&/&AO:1DceJ:VJKaY>5LP+(8fNWI;4FO_(.8I
:c2;@?P7HPZK:2/4Qe.GE>3RE/SDUKaY,dSETMUIG&,b2P@:,APeG4CZWD)6CP-6
g,0-2E&aD5TaU6K:ILa+XPUTL=30e;-U->MD^@SG6GgP4[):NK\gX^1?b\^9->KK
B.+/W2913R_bQ@Y6,S0P)X6gZ/0b<dc4EA.J6+c<.ST3,#9[00G,V(g(5H?=4I<;
YZXT6W>-dH&,[bD7J3_8X),:MQW58[06_WEN=67aAZ4/FIXaVK&fY=cFeVd(?4dT
Z>S=Y[c\L;EcD?)fD?NgfGE3^18gOY1Zf=,c;NOTWeOWCNbgFb/L=[8f/6g58HY8
3Y+_dT?TSH1MQ)dV2X_aPN>DUGN,]+@-IR/aUFdL=fOKZP&W-UG6CJNZDTR[a\bA
<0+#RHcTI_#4Ge5d1#00YPN(,^/:bEU,Qc_d3EXKb0<86JV5eNc#R[,D=Xa=d+,S
?BQYZOX;7EAb)6E.1WJ[I0HO/I3<dRH:#GKaS=Y4a)^)H<dPZJTD5KJM\R=-7N:c
<6d3c[(5cC70(?D;3RC[3cXgT(].Z]0JbD/,2UJSRM/ZgMQUf\G9+QI\ZgZ^>7=,
_0J25S(gP[OGCJG&]FUDB=e0)gIH1YJd+Nb,,EX,4f9RgN)3NTA6?K?QZaE42\([
?R.+C0U>,:6cMB^)d[SY&QX?22?gFP1+3]@=L,#JB/,2Se,[&UKYYPDe]BTK(?M3
2X\IF1d?;OTF\9#PI0F#N:.>U^KfdeDT]KSR_;GXT<e[WRC5Y#^>[I2g?@#Z(Qa^
N>D3=6:NT@g)<.W+J1:cZc^>;UFdVMIX:_SbCQ&664P-L1#LeQ-9ePK-a_cLJK_/
Bc[fUfE(P&(Gf_<I=EO1K#2;512Z8]&I))KKZ6?/0IXa(EKf3UG/7U78BC3+#D<f
<U)VEcL]10cCaXJ(>)WdS:@AE-==M>A;]:]+TM_aJK(M_#GC[#6?YK.U7N:31(P;
AT/)MZBe\A^)Of&D[51V+UQH9Pg9D_C?.@V]I9FD5<85bN[L=+b[L=9NZ1YP?OW1
)^>PNSI]J8\#-(,#eOKVE-H&UL4=cXWeJ#KU8e85,GfTEc).3X7]#>dbabWX4Nd;
05IeM]XW7BQ#R(c<]_<).+D9[+,L&Tc&\20ZOR/U/R4d?c&NUd9@@Yd:]\+NK]X_
XEVNM)-GYJL8(78IV7.Aa5B_[ZJM98WY()?FD31KgE8I2Ra-=Xe^84ZV/cP6^/H&
=HNN@@-D1VJVC45D_A[4N[.70VW0B_K3D-XcIRZ>ZR\:/U5Z0ZM^?#&L5/(GR.6X
5+4.GIZS(UN=>[)N#?R-K.>UA+AS10ReR2(;,Y22-D\XMGCE8C/)J;,gR78Z@1CZ
B7H0H,BC?eCa011GJd;-Q&M>(Yd@?TfK&JMW_SNe#<K59#aVMK=Y<^<)c2UbN_>K
>([g.B#7NKDCR0aGEV\f/97:S@d\>B0M7+\JVK8;^=d#g\bLcSNCHV7ZY.B@21&F
;;A)EIOfQYD&g.KJC^ESFa=#&E_Z(L9,&M63Uf#5C[6:;?=.Ka5T=3d9P]?#_CDN
[4VB4bK^4Be2SEVgXA/;J&3<>fc.e5]4fKCQW7RT?_CXfT9FJHGR3W)K.-O50^Ug
<QTA9^:BDN0HW7X<UQV[D?5S34fB5R5<PS@].KbH.[=gE<SH6<\CU<2-8K]S[M&a
41)?JYE8W)URYKbg53?&f;[QO.\(&6(U]c/1#TU^R@J,K_&6,).a1760N<MD0)cP
_P>)U0R4TI7cL7K?N:afC=#;+))N?=>bd,1;8R/T^cD.Z@g;EEU]<PGg#^ENN7Ff
>RfXcMe-[Y-T&(6?+47\a>.&=[ENII[]+D11MKJ3UW3?8Bd+TJ6=8>;WGW>TQ-+M
;;H26ODJLbWW.2_>&+E4PWFE8La]SbYSPR_F(I0;F/\a,869;Y8M[,RW3R(BKS@d
[O_H:DWT3@H4/9Y8R\f2[-_-Ef?ODE1ZSeP:E4[.^=W:Q8.3U?E1:WG3/WfWT<7c
4daZ[Nf#.d);I.<7F;>fT=>-MFe,NX?;?2D<O6MGS.Wa6.]=7Y;FCf)b_#=LKb;5
TD6,1&.dQ2EA?NA0V,dgRN6N4A&;A<_+]fgC7eBLGH&)6@P.>X37IdKJZ+;Ob]\J
faOaUa+3>K9+N9g6V4,N39G:b?/aDdR>01(9W&.7XRg3&HE]dK&6).H4@S,,:DMQ
4Vb/=.7c/a>36?9g_(GB;[EKVg,@F[&0ULRI:^e:SeF>.?ccWHP1VG.L#AU#)J)+
HO+.Q76)5GdLL>W#=HVT6>@G+<+>BX]8d->Ud_ZJQV#MW020:;]?E-UQ]-M=D1bb
>#O?<C?KSQM\S4e7.W.P1+ASDFdcX3+.,f;fV.a)2M73b.1EP,GFc^01>2JAC7-/
2JM?6#O=.626f20(,V/S8cEbKUCS_FRU@0dG(TZG>#&.bKG04VL2@0FGR+Z93+(B
be,P#E-9g6U7P3_8^gN<0FeeeMJ&5LK)I6Q]44GIW=[U,8O^1\]aAcf8_:3,d-a?
ZVC+HZ<@>);7eeA<?/d5&\Z[RK.cG@_+2NaJIVb[[]Q5WD_OLFF).2RBbLCbO@0>
+]^QFcE)&:FCX.cb7#B@<X+4GGU=-^N/BV-8O7]^X6:..@geURH5I,)Z?1O)K]9(
F+B,2M3Z,caIIRcF7E5]<0AKG7W+U]/AD0b;6a.ZM-,@D[2F[?c=C_Q&3;F3cZ];
-gY?ddbPJU^WP?HY.<_&2.ce.C:2LRY7=gb#4&<YP]bV8TH\eG^>D?]V8=P&^J=0
TF_<J[+GU];M[.JJ9=+];&&HJNWU@ECK=+QWaC=NWaXW3TGV+.B71A1Z0??#\H22
^44d)WSRWP_af<FF02Id>YHNZ<0Q;L2X[1V\K#+H.caNS+g658DJESTfX0)ZbR2c
]#<7[5Z1a&FO3T]SB9GgEQE.7BKT+5.WT@5TRW6.3H.dB/).gTPG6(=;b^.eaeRS
IP)U.>MeT<(>c7CYSL?g9AXG6^_3>d2Y,^IGV0OSM<JdFg>#aO^^4IBa&ebAXW\I
-RO+^KL8)e<;;YaS-RAfS-P>V)V9I[>65K2Q)_bXL7(U=]cGB#b?GW<<>J+5(1c=
-;>G(GG0,DE#)+:5,MIOfBWUb;gOL9YE]-0Kd)[e45HeaAQS3^cDeFLX2,E&fVR:
+TM6:[e2./]R4bG@I.af2S(KW]/A9fT3?EO\6dAZH^H3U>=4WB/[g=T0MP/85&NH
bMgPH23I?MIXAFA,\@/ba1a6J^:B2OYf,M7J86-f7e/TG9:9AN5;>FcG-^ZDg=?a
SO@T(/^K,3D^/-)3f7=dSJb861@2/6OORU/Q8bC6ZFQB<H5AJE?1Jgd],^[(4W\L
CX<H7[)GNYgI@<_Q^@-\UBa=5b)>QLBd/&6PM@M)KWO@0HJG2^J?=Y-PEdZ#4>Ge
66.D9/8R:3g5VENIe6#23gABI-5/[WMA:S5#fe\_8WSeT/gPRADL-QaMP0Je#UP<
O-^E,5JC[,^^\_K)Hf.?>6Kg:fMXZ2G^VZ^F/LP&)KRg#GTG&),B+Z0eVA\ZYV#^
\)\<F9>5+[)6d4)Uf)DV.T(Z]QNB@KG1S]5[L>0J3#@e([C]X-;Qa.L5H3EIVPUY
-fX@dC+R819dcfD(>LgQL(?1S\RMadSWDAcQ=g]H<P_8OPD4cP<\T)[?ceY&Hc>,
T=-FJ(GCH+079-Y<c>PD.;?N=/9e@?RLTNg_Q&Z:,0ZSU525F2;)Z6U6H.@d<8,F
+4;/&F6N:GA]#?-JM\[dfD^Q([I:4R?>gG_1gPT9P-DBU.#3g_#=7Q:##(94WPV&
OTSB>Za?1)][S+gaUAJA3G3\RJVM3DV9?(Nb<f798U+25AZT;W(QU@XAW;5T^)+;
EU^\D:WJ])#>9ZHD^[8.+[&RdaV\0/_+ZO63-:,AWEdfNHb&#(geHNA-(2NMEeJ-
CU5f:U(VEIRVD;H_=\aK/004W1F>F:KC?7S<A@Y=fD0QO<Z]J[?b1R2<YENOfLP+
^^:NGPHX^N+fYGa086H^Z9NRd6g)ARG>#D?JHI9ZNW;<=P;;QXCUS8;a\F@\=E6M
2#IJG-SRb1aU<^[A^7:7FFH:NUe@D=S.B&B<Kb-Pa]6LEHSdW\e\7YD,BLT4bH[R
VTWA0K:d0:F>C>C];ULc03)(,7DeIR,E.W][+>;>^K###[7QBZ=4bXaY\V@YUY_Y
4R12<,dL<P,OZHVQ(>gA<7NY(DaZ+S#SU/57/7]VRD=6O\gdEc6TL]4&bZSb_H(H
,#\NUQQ9=fE^F7-4YPXg+f#>2(\R9ZC21992(V9S+Z7?f.8_X?3e5N6SUYG/.].V
9CJQe2]SOF0G8/R9_ATX4F&PYJ0O\b3JObVGPdMK+J>)SD>SLPNKH[_WPCHA9-(]
CH_Tg2F<U--bH:dXJ#+&b-g>WP6/\MS\XH[)TZ+ce7#V?G)#Hg,8HgO(&^_V31QA
L)?3E-ZZCN8_)EX\MC\4QB_XY]9)I.1RMH&FDRQa@2<<G04UD(9>bIDA0VL?=Q,H
;^^]C.(b(>bZ]]79E\;;=TQdRD5FKBIRaaC,-&eV-[-?O#UUQ:c@ea-T)^a1XQSK
)2PHCKf_\-T@MVVHU^XUW_8K[J_</W@(<Y72=<eA>I<,P4-.<>^7R\=?E]AG5R5Z
B?Ce8b49aaS;@IY20\@O^RP)CQf:H3XAE-U5]T;]aSK<2(0?F-TZF]J,Y/0NA::D
D2NbZM4e&;H-9_]aL)Xg-Zb:FP5@[>ee0T8VbN,I?_M-J?Q.Q._YMDf9_R+9aHR3
9dOF>HFNdd/RS^:X\8fIb^#]U49bBcb0)aTBC_GLUYG,FSfRWTDd>])FWCc4<b^)
W<1g5^R3d(4A2TO^)72K@P)481TQ\UgJDgL&U-b3C;S=R#(J8SaF)[BMO<+K\5Ga
QD]II?[S2]YD\T@<7:B>Y9]GWGHQ)[X9MHM-LUF+B00D<WZHcW6BB+Q4@1gF@7a0
:HPVB42TMAP(f-70H=7c[6MZ>B^\IV.3VXcB9R#LTa?,2RJVfcAeZ3H/VQXLZY5&
EA)N:gDe4a9<3]TYJ3.1/:G8#M&g=Q)Sd9F:;XXN2\P=@dMF^g]KIcb-..55Q_4S
^bAF,JW/6R.N-G_O@bJ[P>]7V;O-#FE-1K\@A>;fSF4D-JH>\@dO(P<DG=aT?9=Y
Z.:002@;WXZdN,H^d:<@a>)fPXg77=DZQf<GeRV]MNeeF?T[@0A&\MMaO;6WJH:0
+C<b0KQT6&+J<DT+WDUV,fC]^f;832@15T\gVAG1-FIE5E&c90g_I+WL@K__RRCI
GW8N;F.W4HG;2LELZ\O@cIK02&O#(,V(DT<?FcBTY?=.<4g?G#H3L81FH6[;PVMd
c5PH3KHG3#LbJX=J4WZFMYSa1;??Z(Tb(+4?\(e<f1=KW]<&G6<ZW>K6g<E1&O_L
EX#Oc#/PFWF>L7e:J/I,Eb+?/\2NWd3D3:2f,#3Y^K;ZK4.CM][3P(3EdU(fTb/;
-.eSeB)HWV00I_/W0>0=F::58+U-@N7RZb_IDZ=b7[OZYSZg_RUM(aW]0Y&FHYCS
C1PYG_Q12_76WYCJf)V_<4NUR=Z1NO6?0.-VHX5>@7R/aWU(b0Fb[39)eCfTKXR5
<D<0DX>0TUIA[c#)K+cD>K[08?RcMCXVMGJe]@=\XadURRHD28ZAdb.Bf]X1#RB@
C/K@U&LA^&Rbb:#)<ID3HPJT\HR[eU&?9Rc30U>R;O5BPe5WN5FT#?1T[B@;S#(T
bB1WOUR4Bg4S.SaR?&W9K;H_e9=;C1?FS]Q(:EW_G)#JK3-A8DWZ-Ud7-:MS7>Ng
b:(QK_E8:76803.-2Q\CP(_PYW^?/b1a+DUd#884-(KTHAUPUNA7M)M,W/BR.a6R
=?2ITf1IP>a.=BV+ffSG\YFea/c+LeC2R#=2Z+4f2?VL3PH?VOO+,H9;SOE9@X7[
0LU10VT@Q=JG09W<H9F[<JFe3$
`endprotected


`endif // GUARD_SVT_PATTERN_DATA_SV
