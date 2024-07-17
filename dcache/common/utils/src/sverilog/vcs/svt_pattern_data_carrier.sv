//=======================================================================
// COPYRIGHT (C) 2015-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_PATTERN_DATA_CARRIER_SV
`define GUARD_SVT_PATTERN_DATA_CARRIER_SV

/** @cond SV_ONLY */
// =============================================================================
/**
 * The svt_pattern_data carrier is used to gather up properties so that they can
 * be acted upon as a group. 
 */
class svt_pattern_data_carrier extends `SVT_DATA_TYPE;

  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /** The properties which have been stored in the carrier. */
  svt_pattern_data contents[$];

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_data)
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_pattern_data_carrier class.
   *
   * @param log A vmm_log object reference used to replace the default internal logger.
   * @param field_desc Shorthand description of the fields to be created in the carrier.
   */
  extern function new(vmm_log log = null, svt_pattern_data::create_struct field_desc[$] = '{});
`else
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_pattern_data_carrier class.
   *
   * @param name Instance name for this object
   * @param field_desc Shorthand description of the fields to be created in the carrier.
   */
  extern function new(string name = "svt_pattern_data_carrier_inst", svt_pattern_data::create_struct field_desc[$] = '{});
`endif

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_pattern_data_carrier)
  `svt_data_member_end(svt_pattern_data_carrier)

  // ---------------------------------------------------------------------------
  /** Returns the name of this class, or a class derived from this class. */
  extern virtual function string get_class_name();
  
  // ---------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command
   * code to retrieve the value of a single named property of a data class derived from this
   * class. If the <b>prop_name</b> argument does not match a property of the class, or if the
   * <b>array_ix</b> argument is not zero and does not point to a valid array element,
   * this function returns '0'. Otherwise it returns '1', with the value of the <b>prop_val</b>
   * argument assigned to the value of the specified property. However, If the property is a
   * sub-object, a reference to it is assigned to the <b>data_obj</b> (ref) argument.
   * In that case, the <b>prop_val</b> argument is meaningless. The component will then
   * store the data object reference in its temporary data object array,
   * and return a handle to its location as the <b>prop_val</b> argument of the <b>get_data_prop</b>
   * task of the component. The command testbench code must then use <i>that</i>
   * handle to access the properties of the sub-object.
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

  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  /**
   * Method to assign multiple values to the corresponding named properties included
   * in the carrier.
   *
   * @param prop_desc Shorthand description of the fields to be modified.
   * @return A single bit representing whether or not the indicated properties were set successfully.
   */
   extern virtual function bit set_multiple_prop_vals(svt_pattern_data::get_set_struct prop_desc[$]);

  // ---------------------------------------------------------------------------
  /**
   * This method allows clients to assign an object to a single named property included
   * in the carrier's contents.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * @param prop_obj The object to assign to the property, expressed as `SVT_DATA_TYPE instance.
   * @param array_ix If the property is an array, this argument specifies the index being
   * accessed. If the property is not an array, it should be set to 0.
   * @return A single bit representing whether or not a valid property was set.
   */
  extern virtual function bit set_prop_object(string prop_name, `SVT_DATA_TYPE prop_obj, int array_ix);

  // ---------------------------------------------------------------------------
  /**
   * Since for do_allocate_pattern this class simply returns its own contents
   * field the expectation is that this will be processing a pattern made up of the
   * original carrier contents. Implying that it already has the values.
   *
   * If a simple check validates this to be the case, this method basically just
   * returns as the values are already contained in contents.
   *
   * If the check indicates there are differences with contents then this
   * implementation simply calls the super to let it load up the values.
   *
   * @param pttrn Pattern to be loaded from the data object.
   *
   * @return Success (1) or failure (0) of the get operation.
   */
  extern virtual function bit get_prop_val_via_pattern(ref svt_pattern pttrn);

  // ---------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the primitive data fields in the object.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern do_allocate_pattern();

  // ---------------------------------------------------------------------------
  /**
   * This method modifies the object with the provided updates and then writes
   * the resulting property values associated with the data object to an
   * FSDB file.
   * 
   * @param inst_name The full instance path of the component that is writing the object to FSDB
   * @param parent_object_uid Unique ID of the parent object
   * @param update_desc Shorthand description of the primitive fields to be updated in the carrier.
   *
   * @return Indicates success (1) or failure (0) of the save.
   */
  extern virtual function bit update_save_prop_vals_to_fsdb(string inst_name,
                                                     string parent_object_uid = "",
                                                     svt_pattern_data::get_set_struct update_desc[$] = '{});

  // ****************************************************************************
  // Pattern/Prop Utilities
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Method to add a new name/value pair to the current set of name/value pairs
   * included in the pattern.
   *
   * @param name Name portion of the new name/value pair.
   *
   * @param value Value portion of the new name/value pair.
   *
   * @param array_ix Index associated with the value when the value is in an array.
   *
   * @param typ Type portion of the new name/value pair.
   */
  extern virtual function void add_prop(string name, bit [1023:0] value = 0, int array_ix = 0,
                                        svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * Method to add multiple new name/value pairs to the current set of name/value pairs
   * included in the pattern.
   *
   * @param field_desc Shorthand description of the fields to be created in the carrier.
   */
  extern virtual function void add_multiple_props(svt_pattern_data::create_struct field_desc[$]);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for adding simple supplemental data to an individual property.
   *
   * @param prop_name Name of the property that is to get the supplemental data.
   * @param name Name portion of the new name/value pair.
   * @param value Value portion of the new name/value pair.
   * @param typ Type portion of the new name/value pair.
   */
  extern virtual function void add_supp_data(string prop_name, string name, bit [1023:0] value, svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for accessing supplemental data on an individual property.
   *
   * @param prop_name Name of the property to be accessed.
   * @param name Name of the supplemental data whose value is to be retrieved.
   * @param value Retrieved value.
   * @return Indicates whether the named supplemental data was found (1) or not found (0). This also indicates whether the 'value' is valid.
   */
  extern virtual function bit get_supp_data_value(string prop_name, string name, ref bit [1023:0] value);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for adding string supplemental data to an individual property.
   *
   * @param prop_name Name of the property that is to get the supplemental data.
   * @param name Name portion of the new name/value pair.
   * @param value Supplemental string value.
   */
  extern virtual function void add_supp_string(string prop_name, string name, string value);

  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
DC5E]#&5-<Y.R7RPD=cPO-2AggKM#^F3a0CNZa@9PRVG6-.#=;f51(-[?dBU4LF#
?MV?1T0SLZPYTe:]Ff)9ECKGfYXbB4YYbT;Pa/->ZUAX/aU7-_[+73?Q#O_O4/e4
^-Tg&:CVRTV.>cIJ,;eX9+FfWBJ?I+QWG7SdJX0f_;8<&B18[LgJ0,+/;b1[S12O
dDW.@c6E\J5Af^4(AbNO)J0B+1,>^B=PE:4Z@MeVH@Bf1dWA8\T2<4MN<98PU;E2
_F/ZP;5eC)b<EWYIc&&L-[J<GB)Q[YR6.??EXLa1#WQPT7_Y/S,Z(/1IR,7#g?_B
,JKL54M=+?Bg?FJ4geY=b<-<PgQfG;Y2,@W<.J#X#RBaTTJ7(0M;(=:6)&<+fZ-W
HC:2F]?I2)X:_-QBKb=HCGTPH5UE9UNSZb5\1N3XI-3PD88KSBM,RI;5O1,@6@Ea
N>I8^ITZO7WL<KZCO1_c0Ag39(,V]3@g@V1M84HFH65R,PWRL]\8ZUXA_2FAHU10
N)R\D2#AP.]HV.L)R>PDR0>^HXP9b00YN6](.O8J1:e1Fb,\>1K+=ZXMBK1FP:_b
O^TT.^NW^[&GDF??0,GNP&PR@8-.]b:A#_SLF26P_0.;)Z2,S&?cTRVXU>IE6T0&
MbcJ(XfNXH+\\^DHFYDE:,a2&e1FKYIf_HS(e\-6R,UH5>YN?gg)8-Q.a7>Z)W)c
9XfQR(T5\N6gRe-/49Q9+P0A(7/Z)9g##?G\=Aa?Z)egN._X#TOSB9JQa7AV9fAC
+dK5F;I8+d+-8#DWQ^EZf0DZFUR;;#M].ODJ()]OM>FM?fK[WFcH/1WC?@PZ6ZGU
F4PP)c^G7MPP1+\Z[QaF(V1-Qc)F\71J;I]bO.S<WZOee\.R_8ZU?K#S@)]V]OV5
EZV_;39JZ6>?fR]]CXKM0RLN6,b^17&d^U)>N,6(66#(HUQ7A9;QW/,b,JY,L(eJ
G]PWZ9C7U,>8;\N8\[[U(/>OX4>BR</]YXE[.&VKbPf5K084G:N3?Z63EcI=C@LO
^@BZ]LI)eZ^7g5&[DS@KQ[S[@FZ&K?JS^54_R2#V>;.<M6+c]KNKd4&df@60C;/:
.b0Sad>LHB0dJRfRS>E0>PMZ]F__B@Df79-PYVBC0JW7d6fNdQ06=_@=W4dU:QeZ
eKW3QHCe[_-5TDEP->BcPaYQ5a9+N=2T-@P=R&>Me6,6]aG<^<@PLBBAABfaf5e1
ZIUN(G]2,419dWW:Dd5f0DS;T;C[?ee2(\U3g\U1J_+J0.41&?b<fe/\5:c_9:[T
T(BceAXf=e]?B>E=_)FEcD5:Re4@D^IdS#&dUa;A11X(.e9JL#=Z=1d6TD8=.2^&
W;I7J;I@Q8,#5fIQ=&VDdV,<6-:EQ[VSI@0FPLSbA(OM>4]L(dJ[Q2K\A[\Eb&Y_
g?aV.+IYa;&OKWQK5^PfaMNcZN.=e+ZI(c8]BKc^9/BETHGC#c/]LLC>cEOZ6cL>
Ze:.O?aWc-_OL:CRXgN#KM/>)JQR5Q,\NQ)Z\8E.624?V_YRZX:H(1XKRW=.T@0\
@FBH\B<RaJ/Y@1KB[LMMg<@MOXGA>NW=0WH,U:6de]ggF8ab#fM=cc+(aI5ST,SE
\KO#ITgg1Sb-WX10=]G7Cb<[X:2He&S=;+(7T_21BeUYS:ZFcJ&eU?<1CGHeP(2<
5#>eDZ-B_JVfe7GYJC^DS#6)?2ECOD.f9LP6G/KDX?M?(8#CT4f/\PJK5M_WX9bF
39@90_WT&f;gbaN2.g,Y0)fOEPgO)^Ha:M=D&4(SX[YaJVWM,+6(KQgBTSZA.9<N
E3Tc(/CKJ7BY@89(M_/JeTc[(@@-6NKLN\edQ-29G0<a5#.EA.SS.EF7JF?8M@+B
4VMDA+&ad7=bI(O>WbSS,Q?4G#I.LAeP0U<ZdBbG^K\cYJ/F&USTa?_eT5cDR:,:
4(W=UC/A9L,.4b&.&[8K+<d0G4R.Y[f::UWgM.-;,S@AOS,68e.PLT:X-Z_JR3+a
\5=^(=eZ1g4ZYD11&MX]AU]#dG]a2YJ-]3]Y-W<fS4;T4=]/fP,P1KZ^R:,S&H;=
Y5:?I[,cF/7<)M#U8+N0OHO9Z#N3EW=/6))UQ5M@G@T5.7D5+LSa<)T8<PSKILZ2
IXP@ff#aHS)+3OcW3_SLO;M9cUISZ@^L?EdP>O3O,091;0IHeO@)H?MG0#W;2)\c
ZQ_=WG?b_J(X_PL-_FPgKEV8\/?_,:8Q>MYB/KAGN3&L;OXUfOL^IL:ABe(,4a>9
M;\H7^H5b/eD/SLDT&d+LW?2G6g(3F3)ZCR-beH^JUfXdTR7P9Zd52Gbc<8FA[C&
[3V><B1=0X/O^<-f,O1FX17bFR^FOW9L=^=;32)e>c/ZTdZ5P^OAW@g9][?geL&]
)fP?gSDY4+He34Y)7<=Z/ZPDNZSQ_MG.(W1?7?9MM;2TGQ_8Za>O?Y?.K]&B<]K#
HR_bb4&IbV0L@aeYXTOD:=+6RD[]Bb-d1cRG0GXFKgCY\YUHA?R9@WY=g=57Q]J9
//]/_1gQMV0b.)_B>P;e4&f=e=Zg&(8HgN9Q]A^eUDc03RH]8@c#[2?8JgE#JM__
<RI^&JF[YV\HOLAZ:ZY)PIb6UKVZS=b.\F4MRcMdSaEU.M;<?&S6bgOCaR^dgU^R
SR[^INA>]3JOF(6Q2S4L?31LG:Id,3Nd\+=+1C>[S(UYgaLGN3/P(4d-B;K=[.Id
0&]=NLFEN3gDfGN,TNXD@>K&7^XD,<>Hf1[20:=\eT7b2^9TNL?:dZ5)D=JeVX(5
e0KCMV,HCM@/V-YBbNY4AY]&Eb.:>&E9KbQA\=9T+@27V3<E71^.FAHMB,VW+]Wf
)LX0?A(1TR=6(eZbeVY=ME8A9J,WZ+dH9Uc3Bc-0K??a[V6D?JL]RLDe?\Q61+@N
Fc/?A<d#+\^C=8IO7/)N^Ec;3eGb?_L@e:6J6.3;E9DU,06V,X1Hf4JXQ);gUVBX
cW&=SPA2C21CNE1,:)3V^CQ@YH=_W.E4^\,gc?8GCW-DQecCXHNV41,[0<8.J24)
f<_HMHdP[<:P:T#3KUI-Q/>Cf3]3W_We]a)ReC)0C+U0U;V.@KSUU4F)=-2L88O(
?e:S#4W&Z@2>[_Q.@\5B7[WTC[dOfG14^<O1bI[E@OL/SI@cKKQC^RfL55^DQK@,
R+5Hb?<ZfO@WPJ1cedJa#9KeWLO5(e=C^LWfB&R#b_M[K.U7dRO:@Tf;+0bW?N#,
>E3c?PHgM.g90#Z_D#>NE_6S_eA7./_EQ^RMCNNOS:[G5Y;BH-J(GDPZ/)L+D<[.
:\;WTgIaMcW<Q&AeQ]eCGK5W_-[3JUb?8Fg3[gO^2]734I\5:_81\O\RS45ZgYC1
;<))SY[,U[[,2_;@B7/ab3B@#8:aOaDB?ecP#SGN4DY-;?K19N?cKK_J]c)LF@VA
(11dfWS_]F)+;6?4f087+X.,e+ITaYaFQHg+Y)@S29JAVF-2)fH_ST]E+5_O2:JG
#0+N=4,0eUC3(b-.+8G9QR?<L6(O<B5d05OYIaX#-/_b&?XEASS7ORL,LUU<b23?
O@6DR@]:[2N2LaH^6_:JYZS^?\.AY1>bM0^5U\@^(0LA1H/=M3ae(WJf+T3b/NE-
aCH37+ZS^?]5V\CJB-3DY_\^YBZ1c@KTRHJEJGWG-&Z;LGc2M1._@J-/?^YY.67@
DL4VL7H9a=LCJ?;M>Z>^478>>2A-V7+?1Xa/I)/R7BaXG3W#eaG21;-3bfBc-8G#
dbe3+5@ffdfQS9f)9/=2)U:V@MOg)0-L6@gINQ+D8Z.bf_U<_M0QTGO+BBAAWC?7
F0I<F\<BS)/;6==NK9dC8_YbF<fGV]PI4;BE(7S42E4@cg]MeP5/124:g5/3f)6H
W=d</9O.-eI[-++?V,_EfXM9KL7.W^gQ;b1:B6AdcSBDd-D&:_9=6)#_-Y]dK90E
J57bD=7;,>RD_/M]I/0fINRbA3:dEgdM;L4-bYE=SJTRf@L:5R3PI+adYf4V3=Z_
1,gA\G6PBURJOY7SIa^S]d-F9(S.Z+fS-Sc[P3&1K.+7]:+7b,V?53SR;gg\4=6P
C?D6bFYMT:?U4(4=M^#EgWID7^b8_N8F/-f?0\JL?KXR7F?WRe2fXVf;YCM4TP-.
O;4aANe].)I_T@(O<@Eb2^]T(aEDHC/\6LXKH5d\;;.QcHJS2;SWWIS5N7O3@BcL
4G[CZN\?]FB;2+BDVHE&DNO+M478ER(.)8ZGf@8X8N]JTA+[>1G[[Z_/7Ac)ZZ<R
8)=QJg<:&BYVLCAL[S2>M\+IS5HU/GZc<>T1-2X/@@e]QE17]Z\_9V6..;05Q53]
9NY#c-:7MU\QJe0^6c/,3-EV[PU7_:6^X.+L+>S2>.bG(==DDK_XVHJ(@=?#K66F
SDT=Z=0ZJd4_VA;7XA38TT@3T/Ic(-Z.?,c.DX(gV(TWJZ;7?5,HL_.@QeR<3FG[
I6QBRK\5f2N<\=d;6c;ST&GOWK9>R[QS@5eM;=8^/(]VdJ0,MNBZ)TgG;]SJ,T>I
:c\=,6H)e_aUHSFKfW#KeK5>0Y/T\.N\\S\3N?_)CJO8D(>HO/B2U]+e]fQ->(HQ
bSaF78EW2GTL2AfWGHGXKEf[g^2]P:\6D6_-Y=(BPf&Q9C0XKRAM0Z-3Y[9D1.AJ
K5D]H3BPAQT,OE0MGaX\b=eIZ?+#fd,X<QN\bd=0,35E]PKH5=U1Heb>8C/H5C_[
A@RcPc4&,E]N08D;UIMe,2VRGUa7MS8)GV]CE7V3.FP:_#5ILEFF[?V/]N/?Va>G
S8PMbe]\M<f6cf:4CT45gJ9C?>(L[8^P].O=0B?:#>L6]W2E?U2AXO)K,Fa-[K6U
,>B/V1@VA(CNFJDXIW[A#a_6@PHG:)/&)BJV<.SHQb:bI2-IP5NL/KJYV)6a#R#L
UU+4)3Q;VJH3\G.+[VA-\bDb;/F9?AS+YI\L4<3MZ9JfD:/+9ad.LCd))HUd<5?Q
-X,_#O_AZBT/+W&:b\=EEOJ0,c);^KPJ,Z]X43X76^8Y5@U9B]?/dBED@)A9?&gF
WA)G0ETKS)T]Gc<F@_V@8N95F:T]bJ9#c[bY;>Tg(OGTgXFWd&>NaH7CNdJ?CM8;
WE>;R1E;G2+\TG1W:?MJB-D2/89aY=.FM])/OJU3X(3?7G=b^R/:\6FQ,.TcV2F<
9;cd[(db71F.2?6#]^+1c=bF#ccVBTBFD(0WFfWg,e.<JKDY]W_Q6+CBc@DdW8Gf
WI&P:dc4)WZ&W;V9JXHeEg-WHf;bN)L,M0a]22&Y00UCU7Dc7U?Gfg0PcaS?[@M8
f0=2eT7A25e<eUNT+0f<2EW#;UIZA+2_I0E43AJ2Z)D5Q22gD-+CGIZNH>AYf859
2/F3FQP0/+#9e)c^C=BS?G9&[P.5_gY7Q7@1CK-?A)EfTG<7K-.P6C12[4+)M./1
g2NUS.c\d_)TeS;\-DFT+XR[M&Z&U2+gd9:O(QF^fJ1)#5)U@?O5Q=]?]XQ7bAZ)
(7c_OS8&eBLd7.00SO0F6I7?DRA>8R?GD4g#]]0b0bUWGOP8]_0?:L2SN;Gc:IH@
5gT]8+LL<\ONY0UIJ-XcI,@RE2?5@YOOG.F_(,)DQQ)#,DZYc+[C<C[bK;W-<),-
0[I)1,IZJ;Q;CTD&\8cGPSSV#5SIRJR>S-^W32Q=))\fDT)\TU#2]gU&W3LdFe/#
5Sg.eJe:(MS7V#dcg#GZfJZ,4;KYc01OTH;6GF1g3AXMX?KGIL._3@AAJ45?fHA6
+V,c/IM?;Jc0b>ce/:#-#77IOa6FZ]cSFQS58V.)KTffM)G(O)[/^gCH6>dEgB0L
O7F7F-(,&LAd>eQ<GTWYdWJ0T_cN=SECOMX^X@6[EXgS#11@;cT,#Y/(g+12M_7H
eOG#>27[R<)2;H#>E.R.WYU&&=RU;5:,)6]-63YcbNU<@cO[UIZU88Zg[ZK7;(KJ
L0KMWGKX0J4G\N29NfP7<+gIU@4NAN:4EbR)[R:MTfO5b=EI^?W5+Z(4^aMfUYYe
)-]35e]9D-F>9X4?XF<?=Mae(QT5OC/8(.B;9C,+]&)==XBH845\8eUZAfIg;N0=
<//IfSE-T+MW)DAE&P/_I7?S-S,YJJQ7cBaP0&f@DBQc)<?fY9[aIfBUf2)PJc54
?,QHMbNGZ=,+.Da[KVI)_^.&b/E.PZ26[KE0CO,E-d8IY#?Y&\:T6CKDW-N]+G>,
5B#/.aHM<^:?7K_D+KW1H4R:/-@[O:9fE:(_?O[TIN&g2.RUWcVUC0SSIN)V(^W2
b:7S3D[>.[bBAe&J:.:W6E_Q5g[^TMED=e3@g([AT]WQPABEJBVHFFV0X-MZQ+HZ
W3e=_[@/-Q#)R^5FJD^+D[V_RCFSL92UPS.@d?SG;5KCZ&?Fg878UR8[CTKHbZW@
eb-0<MH-3EYVWC1UF^TK1C+6T(3MW@\g];@VYP4PQLded:J_gcYdU-WA\91Ub##7
R,ZgXGD5W?-+b>\HT?.c^;2@@0I6CESe]8Y.c1Z2VX?NS?If2a6\U6Kf]UOYY+Ng
]KZ]_KCSUYf,O\]^(^_6cHKJOE12YN87]KB6.KQIN.7:5DR618>;;[4U1H]3:8N>
H2g2N@H3[K8gN6eS0KfM]FJ0#aR=W@HEeXZ5g9,7fHHO>HGP5a3;<X?1B&E3+KQM
eOZ0dQ_7X)?5]BC39<BT.?EILAKM3,:^H^[8FV@^;F3LPg97&&S_@6<C^S^VW1G-
4)(<VNb1NK@?A/<Q4OJ<(c(.b,b#bJCH2dFdP?6,dWE6S>X^([8&5B>SX-48.cW<
@:@-ZK7,d03Q:)>JGZNTN/T6BWV33H6BZOO0MW+FIeUVbB2.<;D[;E_M>V+)UE-G
WTP0^.@T.d0gKN]NZ+X(=8GKAAURGV\+B-X<WV:@J0f;/CA:eRZHX/C+S\ZA]U[c
aG^HN<d+#DX+01+.JK_EGacPbST4.22K+<N+@fbRHYW=N(<=)S/IT<fO4ODBI:9(
cQ1SYe3&&94DPa#ETUJA86UeXSa9d66e[fcIAA>-N@8_VV;c]LX#-@]YZ5493DO_
,<]A_-ZD2WN<2K5NA2g^M(-SFaQP)#54LPc7a-//C8OPPee?27XL7M_L:g3X3W7.
8/3X\;:]5ERa.H&Zf0<fFfW,[](::3OSU6>b(ANB+d3=,4^X:3<Rf.AM9=H^WZ/g
Q0Z#cL]fTSb\#.?8aJ92?[QE[2B\faD7X4RC\Z:H_/LUY,MG:14cZ[]FUH+YZNG<
RK(S57af7e6B_5E<EULULg5[I\>OcO=_0g&R]77_dA9aGgW>Bae2,A5CYX76)d&.
LH7Mg[BPI,P^=JBLE,J+YN3E\U)(7?/,d+\2d4YRVH-(V;#YHaQ])MgPR&UEQ(,0
Q/1e;[K7L?+VU:.J+/)K1?.7O9b\<<K&AQVT5GV[/3+X+S7:B&fV^fO:]<.BcLZf
b.ANRQ(aZ2XCYNE-WL\bM9A9:>=?->Cf+E72#5B4U,C#(S@/8^66+#bK1637(9J1
=PR;7#,X#9;=9/e<;JP0BEOcE\0\J9TF2bER/S;f7JE0;\dM.EN>[GBMA?O,=3MH
>#F,aaaH+O/K4b^gJFP?XKK;X7F2W\B5_CEQOP9FBZAOF@0@^+eCP5-)4e]fO?1G
PPb0S:]:WY7CbD:+KI1=d_<)c4)//V5(f(=>3Gd()47Z<0L14ZXHYXQ(+X^>1-3b
^4:[[[8(^-Z=_7]BL)K\FIc^)CI5@)gSJ@@N=G[V)MEe44>.IEeMZD.S[S=4/=.F
PaFO6QD@A;gDaHSY7W#J<b@8T^,g/09L^<TE2Q[P?U(bbO.<&cW4_[+Jc@XNHIW=
/5Q6IR?;\M^@[Z-J^5#ARgf;2aGPc1BWX)<16YA.X98.CdCO#O:_JOJKEMC>N.&b
VTeC5G[<EKXP0FO&_bPN5bBIU@_Pe;D42^1c#/)+V2VZ(aP-0cEC3-2Qd3)K&b[d
gAJ(.A@\0,BSO3Hg^GYF_+X=>dA+:b)(-#W<KUf+UGY(YACc8bB]5K#[\A?L9MU^
fZXGb<1?c<P@]-Y=U6ff/BWd_YY3NEbfM<+MQbFHV;9/5)3:P2#OG<=WX,36P:V<
=YIS0(&Wc7>c6?8.)(8eV;cI\0?QIVKCZP@;L[FaQcU1L@YBbG+#)Z?,f&/.b\G[
)?bLD2H+Ma-gB&]FYYc;UW(LHR&/c@+c9^KU6L8=Z_edO/YIM/fOfD\NV/CZPW&2
7^9Fa3]#BScEdI860YZ71BY4WRW86K)#JV:Z7?#E3T3C,7E1J]XRIBEaNZKa6P<^
NUDF^HJX:VQDSYgQeD+MS0.P[aa5/6gOd6.PW6S2GA/8YFfG9==#&fY^&+J)]5X+
EOE2BKC15e15)W;,ZNR]YIWNbR-(1WH84A:fWC-HQ7-\Xe(SAX-JBS#^F=AZ8HG9
D)H[NBO)EY_M&BJ6\82HCF?b-BI]VHeTP\I8-?5gGe(b^\0eZ;fM?)^/HRCe]-BW
D?9:df(=A,,ZD+ga]278XgS[KP7>4c]1N:/CQ=9]6dL<^L\@_bE-K?;[O=ZP-,0b
CP4cFG#bM^3R&5Z5c)YgKLId/<.Z,MPb&339(R7,SC&Z5E>>\WbKaDL#Nc9/U)F&
ALHf:X85@<__c^YD063DJR(2/2&<Y>Q^a,EaV4,Z=10Q-@Q[f[(_5WdRAO#A[X24
3f4O/>W42MeGCAQ?Q,SX\HWUBY8H[?Y&D@[T<e&I1<b]&d/;](O#^-34Z/c9bLF(
GKHE:MP88Peg?[d5?VYPa&0LKONg^3M<a8M6(.F#UC)AX?E&\J_QU<V3NO8P=aP5
&#d<^ggef4K;g4PF&K&0\Q1&cC\\Kbd_M&N^5=511UW4@=LJbJ-)(9)IT,I4,cJ]
-B4C],BC24_I^BMAODd9GaC[LNVg[GD.b_?[/=I&ZC.^+bR&.g@:9>3EM.^3.IEb
=R[Y(WX+\aFF#J<>N5[=bFJT=b30KgPbR/H1)fOE,RK;76G8\O+P3Mgd[d,])G=<
+.,[>#a_^Q)_gf70T3S3ZKXgeMa8Wfd#@;@>D^+Y];U?ZJRbbaDd@(XeX(<6RQG3
]R[6A+D<TUC-\PUTWG.\FY>5TWG4^VIQZ9/=\?1a&cC#Xa_-_WL>^2D0UA5:+M4E
W,AY_YHS<STX11:=KNebcA0>a96BGBV#TfO/0S-)5QOV1/+eQ@0EHN,c49A^3:DK
&G\V;_&g:O:K^U<+OH#gOAY=V<#,=B(UF793\e01X[AJ#QOUZ.K77P:dL^BQNH05
E79/?c6IfJd8]YE^54c4R8(Vb&CbBEV&E<d=)D@RTf>7YcdSg&dEd5+NUAF.LACZ
L/.5)3N@UfC=..?I1F8QfY[7Y-3aPKfU&&OA@A?U2L=NT1J;Nf&:,[b)d?L;]b[P
:9?]cg,M+(WR3(RJ_OSS:/(DH&3YJZ3BGa;=;MMX9JB&^>c^-<#;791SY=7RNBEJ
T=8YGXO:]+^G+URMb4gHJ7g=&Ie?e?Q5_YJA]F&?+F(J:>G8ACf.fX&[XJed-&_V
077X@5IaLJe9\1)QO5.LLU,1<.=de,g(#]S2e?#bT;^1S(=ABVKNT6&;b>#M/FYZ
J]PGUJg1Sa6@2RXR<G]eB-M66OVaK]?_P/<NQc4DQQ_J^M.,M#Pb#J(Z.6eL5?K@
gJT3(VT9faZb9b3D8Z//]F@-9VLdb,JKAI5<QFG@;;]I(5+DE#U=-5ZfURW7R.Uc
ZWb73-()OER?X(H)B07f(\Z>&(AHDAMdJTg0TC>9TEC877Vf_BL@AV-&5G01bKg?
F([V327gBV:4_TcVf_MQ4XB:QRgUC_,g_9@@dL@+O)=)c[gF@2f0Vb\:GS,NcX+-
T\93]12CeMZ)GT]DebX)G))bFZFGIXa5\H448U5[?9G88aEHX37fQ6028\)C-<Hb
NbX16;gC\<TL^4];(3H@Lf@H9:7>ZgR,MO@<PgDZYC>5FcV_1YZ4MO4fM8aU;dDJ
aL;#;+]W:Z?+[E)@/Y/@&gQe>H+5I6RNb49dSQ^c,DWGI455XO3Q^_\J;-e/>WLC
LCWe5f^ET[I,_FKc_dbPeE4cf\^E7O]^JONXKOVf]WO.6c3)2\96AbN-YBe^F59C
34;1N0Aa5/F2O[X>#[8GbZ&5B6CTCZA4;GXFBXUAa;Z\g69LSZ:KLLBKB<>9d2L3
.RWXa-g5@(R^;DAMS8\4+Kaag\WK+-?94A4ZcJ>OH;O3RN8#(VKg075e(FVAPOX.
GSfYIe74K<g,Fg>g-=,+2cQNPS_(]N-_XDgBEc@5MSX@-B)9(,N4b4&^WT>^IGR3
GG^H@:5<\(S#dNJdY]Fc2E5fVTcY</J1La:S-4<TWWgJ>>LX=1SF;(UT;D=Y;QF+
R]DddBB[2]8.b;F//&(Ycgc(,BFdZZ7TT2C3I]R4>6,Mc.W8UX5AS&BDT\e08:7D
ZL>Dd__TaN5E2<<VL7W2LGIR1CRZM43\H:?D(VN3@EaFecTF+6EIG(3P3\-E1U#,
e@C]NHPc_PO4aLf7O8/O&Y\LK&@Y5d0EAZd/NJN#5d8:NS:I?_a\8/P;V(FB0F.M
7=:)J@aTe_g9]B1#\+NJbUN6K&1U,?C7I9J(O6=GE@H(7&g0\@S.+ZU1WY,YZF;b
)L_L2E^&J_IN(X<A.U4e1=bK/WWg5F3[gC<574:84/D]8)5I/?2DG1\)2019e#T)
(_SU\]L-15F?N#XF\7WU()d(&a.R31f#LS(B+NN6KTa8DOd[dJWG-a7;N,e/G<Y.
dN8NH-@EP4)RU(XG+QC5VY<6(RCPK4Q7\/,92Zd7CK=gMK>1S51f7E7;#Q-,)L2G
A+W6__bNK9A155D3(0;H3:SQ#(X\DC6;3UaER<_RC:gRG&_YI#9PI<a;Zd#Sg,_(
ZZ,0I.<d+;bLV6V&QQG]MH7VD-_0>[=U+gIDO\Ea#R-004^#_NW]gX1cDU^B\1F@
W[8,AS@+d0>=TBK>YIb+4a4,G:&1P>]D:&2Z1MP&KD5CF1U8RZf\9H3:OdaTSRAJ
_/G/2BbT3\VZ0a@,aTS6O^)#H0R#<[6U3760@7G7RX?T#H4JUU/(DE^YbQAW3JGH
DJ)2T?E)X0GIKIH_JBBQC.7A7f+<g;PG(^=\Bb4S3:S:WKUU==\]g,9](_U7GP()
YgE=dZVFD)L0DV:aAe\8^P@;BF;/5+<fEMMVD0DLLfVR&<16@N1+W/VRHYQT1CKO
)J(FY\-FgD;995\N04@>4J+AG6AdI+L107-eV5P9CJ,(d#:;6B0@XLO0;F<.3P=D
.C@:9V6US)Y_c,/9+1bA4M[eH10>PQ5YUSB[#)3G=eOX?TCc.RTcH?@-I@.1Vb[B
A,He-^bgUZ7N@B.NW??R>:1gF2?)&D53e7-gL\SCf<(S_(cN&O)M&Z@b[8Tb-OQ:
DL_9eX:HK7,Y-R2Cd=^TDfX#+BUHG,B4CO,GAOH\OT?JMK,R^2L[?DG:WP99FdFO
OJ6LJZ?+EJ<:c,McHA)_F>N#9fbGePVPFG0Vd[:JUB8#F9ZALX4LNg,@RgET/9&I
SO>7DC1FVZVBf<X4SS0QMSNPC]3Q=PDR=F]GDB?LAZ3.g<;/3d.G_9&SF/N>IB1O
b[[Xf./4K7ZeN//1;\4fP<B#EYW@D=WcD#,-<B?6R1\A5X?71TXbLPSe(=O/PA&M
dFcFCKbQ=CQWCMdE+]1GU6N@GU4,?YY9V)dK)G&D07N^,,B;ZgXfU(eAV7<WJO8C
gPZfG8CSA_M#e\=0dL[JcU@IGH3^:.R7T<)((b7?c\;M<;K.G;DBU:V&TU@_(+FE
X/^;F:\&3(I[MVS6F;V-=P@-L.GHRG2EGK@X>(;f@f^Z&V<)RKNC^BOR@D.)_1)O
KVH#b;1N4a)Q8A)^/S\Z[?)cNSDEEZ39ZO0VG2S,b\#EFI(OS1MDZ)cT2NXXY7Nb
fTdJZJXB=aYNYOEO/b1::YG6VWEMGRGI.4f<WTJ(M,R[)e_POUGNH1fEY?[^>Y1V
bB9QWF?eP\cSEG?,3S7[).HXXEg6<\QP#&B[#gaLbK(AJ5IVTZEU(a6&&U,7)]0U
gT0+1b.^;Bf[)7S-?SI\c\6\+bOEV-+SKTc^O1a<g^Q4fa->@bgd48R28W&8c.Xd
CPVO^N(C?>Z+[N<ZfI7+2X.0D@RY]>^EXF>Q_MJW&7A>?2[HDJeSfZ7G@Y0DF@Nc
J6:0KG\NdYZdVD?NFA\V716&7XFK[?3:\A,f[JdgGN.c7fQ&bLQPQ;@eP[Y6N):H
B^H6^E0.G,SYW3\CdWVU#-g5-X(Vc8I7HB_59WB+9IL=KWR&F[H+N_=c[7e?))T1
MRb9A<7XV/Sc^BPOQ?-_bDD:63PA2QeN?W20J3-5?CNCefHK14P:)(>OZI5Gf;bG
;OY98LGHf(]-0DNaCR48VWFPgU?V]J+;_S9KT)3ZW<3JP/#IPg#_8,4Z>gMMKVK&
gR1AadaD_O6)3,6.=@]6[(DG^IL5,[f8SV_\2SP<3\.YW+[,<UP=D>;g+<E\@GFZ
=&+MT+SE<[,;U(_5Y&(9+5KeJcH2e43VFEB_Ba8J-5WQ3HRW]EVd6)1L_a,UW-f/
0#U<T@DX@^W_[1F..X)&K(F_cF=<3V>(=A88CabWV@^JG(4[(B\cUO\/A[RO>WKd
F9R/(Z.;HC[GIM5D9MgI]+.E1GCWP9LAQL>I?&2A6:WCI_8&APY2WXABEN\g)4Ea
8b=LVX1/6&=7]\;OE-)gYN/Z=UL=;[K<.K6^7X5X?5g<,LPA8L<S4A-8^e)MKKBK
N>);^[7:AK.0@TYEI=F#8f(5S-CQPd@@eB^f]bBLa@)^^Z(#-YI(>O,O4().Qf)G
E924>&S91<=FfgO19)Y@<0Q[5g-DDCc.3U#@FDCI8[.E)_U1,dAJ1NffLO.^P,[J
5@gA^VbTTHE_I8V2J4]73Y3))JQBR0CXMdLQSD@5R&=)\QL<\H<.>Ob5H+TN[EY;
7@<c_EZC;5F6\dSVS:#a&gK=A--RM(O&Z65d>V?2CC&X?V_3(^,c/H?N#0GGR0?\
g0e5^I^6N,Uf?/eXX9:246:&-(/VPE;./+LXZ3JE_3P^AT@3c+eRW&0g)<dOXTZK
8OXT7dH4&L9gAWVBEK>S=NUf+MHd3T^ON#0U^47d/QCM7;&[a[57M-7Q]VDAUUC-
Q7&/IS(6/c-\.V8(65(VJ94U6WVWHN/(6g;YK-KHg[(F3,d9P&X8=LFEVD=C75=(
&YFJ4AO/8U;g<P,,871T,YH6@>8VY91P)=d1>G.LYS<18TKFfOa&[&Q\A/XTR0bA
87fN1]C_:RPVS@JR?bKX^H9V?QTf&VbK1X=/2?NNaS4F@W)GccOVR41g99O[DDV:
9Zb80Y(FBEMW8V\P5d5Cc\aOW+>4PR@1OZ8@d,[@5(3LN[1,+XJP;,BVK6bgAQ0N
\]7DS>EEOcTZgRV3b6YF]VT?MfY;FfAYF3OFKb.Z-@8g)[bZG0U#)K@8,U^F(6a+
_fUQ3JJGO=,FQadc@E.AcZ593,=Qb@2#SYM/K[/)HP\6W>GEQ@#F^2Q@/597H(6R
3&]GaGeZ5f<c04(]6,XB/&[9e.>#2_(YEB@PU6Q59@BXK4G@6/M)-::X^6.UTYSb
EUMPA=Z10ZSb+/C7[BYF5/0#^K3Y>YO<Bbf1#O\SXSA\&55F+:#9e\dO=)19S=:\
e+VN[YD[X8f[Cc?Y)/DRDOEa=<[Za-;-LXb8KH-bYBSS,SM<?NeM/M:Sg&SV)UX[
-JL]_8&MYg[Jb8YMPbbB4;>5.8XN#O#ZQ5J,V7(L)JQgTB=RgHL&H9R9/a[U&,+N
4f\;TX,Gg<9WN[4?PDJE88g@9+#3f+QBL&8BMf\c,T;cEd/2g3R&/a>?;1_AFP(>
[Yf;P]-DW:<?9.Q=3[)R+=d&9LC7?HAFD?^RBe\CKB01<d7QgT-R+]5]e,afc/?K
bJG867+[VUKJL)C?,&D0Ea-/ZQE.1VGRC:5XUXdO#c4c5KEYb4=7XH.T8IdYJF/]
I?<E\R8\&]RLZ40(6J4U5EcJ/G@6DN&./E0SR-[Je)/TN]@X_PAe+RBZ^.Wa:(?F
\Y8_2RRKW)33W+g:aFe,ADP3CB\7LK1Rd7#>BH/Ia-F<CX]M(d\D2:7-+^96e7+9
Q][#BTd^J=]M&39L\&D_^7L6F;0/93Ce9OU,EZ5NLZYDD1+CY<C\KfWCb&WdOG&e
^>FNAe=9_G+O:SPL/c&;\^?U(D67fdPI=;@G4;SM_]-fKFg_;Xc<:C8aK[8W;c^W
F^H\7+UV>K(7J:5/W4>QOdVMSQ]Z5H^23?(252Hd-T=(X&0TS1>-e#d.R>f\3612
SHbS-ZPVE&e508GWCH/aSBY5E)X6Red)b]>(]-<AHHXeG#1gePF&72?Rc,F_G::H
78bQ3dT6P]M./F0aP#VgF)MCSSg@;^E\[aW&/O4-/e=])7R];)CN()+ZXR6417))
e&Ub9g#XBE_TT9(CN3#BaNYB8#Sg?1a7:&BLV(Ue#QUPKAfcbF33Z=3I/O7b0;:#
(ZW,J1@P_Z#F^cAd2S,SD8F:L^RVe8,?4=>;a-R=Ra0;c>beU?dV6J@b@TC=4d0@
/?HMVYU0dZT57WW(EU&OW-T7K9/&eaCX20Bf/9_K]/PY\UX3dF@(I&O-B^4VPUP8
H#J_Y8(?C]C8QDZOcI.8^S(WCLX@5AHZgb>LHgPg5C2K::GK>&3M&87II@1+/W,?
0O@O8[bfa?3M@IeTFV&B/]T:,df\M)@e2]9Be@U[UE&=.^aS3D_\4V<67fW-U<]-
=J7,]N]7.41H+[IX2Y/TYT:+)=PZ0dG=3(.AB4eT46N;ASC)cA-F_/@Mg1/f4Z11
S536^JK2T52]5^Xa=->Oe@5.YULc6[]T3]19ac8A,T7/cD9dVB<H^b57;MYETVV.
G]#f6@g5SW+E@E(A\8IPaA<1;bP9^M&UEX?Xgg;d2)&2Y[cc]NTQA\)C>,-cKU3K
]EB81M5S,_P_R^]RV.)1aAWQ-@)E.8ZVGAe1EBU[L2,+aMD/]=10cd_P(R=],8@e
@/[6@#7_[Y99>)1P.BE)W07DJ\56FJ7<RcM>U5[O-@48dN-T]JO1a=^JL5[3/TUe
PVEH8A0-#cN=e2YN)7[c/T5.5-\HDR,Z/gbeHA&Ec=60\MSR.aESD&faJU7+4SL4
>GNdTL8Vg,Kf5?C8X>]Ud-X.0dAc#;+VcRSeTW_b5OHP)e2PIZ;?C<]2cXe+D.7S
.YQ#^bFNQZe]7S11LED1-bHdD,c57M\]OGX?A-;7)Be6TWN)0^bfH38beQ-H21?Y
7+Z[,c0@TVgFg/,&N\57>@?\GC]F]3:RH>@X,3#)#?;+Tg+4L^F>99XgX=_X]M01
f9T:M>AJ(F(NIYF<ZZ]?c&@a>8)a2PX6&@T>JNJf^,g:S73,DM)3@;>14e=L&G=0
UOJ[[0H(FD,XfS0S4Z0=g,(#[K5^aO+9MMO<3NX5>DEc#Z/aVbY,gK[dHaJ/H=Be
ZfX6d7bCN@Z,SYT3)e?E2c5T@aZEfeMR4a4C)ZCTI>7H+C\H>7OB@9KNW,H_b3BZ
?0e>c>UN1c6D5=5?dM6e_5+3_6SY:M<7ATSLD@D+^:)b-#DP3<gHXF><6T(,BTA2
M@b[8LA[#EE?;ME&<S@_M^4=eXX,6M?O=(8]&#LdcCWd&^[#7+g&6,U49HC;GK\6
S5ROQK25EgfJD;b@fJAFMJ4=7$
`endprotected


`endif // GUARD_SVT_PATTERN_DATA_CARRIER_SV
