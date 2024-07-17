//=======================================================================
// COPYRIGHT (C) 2011-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_SEQUENCE_LIBRARY_SV
`define GUARD_SVT_SEQUENCE_LIBRARY_SV

/**
 * THIS MACRO IS BEING DEPRECATED !!!
 *
 * Clients should instead create sequence libraries manually, using the
 * SVT_SEQUENCE_LIBRARY_SAFE_ADD_SEQUENCE macro to populate the library.
 */
`define SVT_SEQUENCE_LIBRARY_DECL(ITEM) \
/** Sequence library for ITEM transaction. */ \
class ITEM``_sequence_library extends svt_sequence_library#(ITEM); \
`ifdef SVT_UVM_TECHNOLOGY \
  `uvm_object_utils(ITEM``_sequence_library) \
  `uvm_sequence_library_utils(ITEM``_sequence_library) \
`else \
  `ovm_object_utils(ITEM``_sequence_library) \
`endif \
  extern function new (string name = `SVT_DATA_UTIL_ARG_TO_STRING(ITEM``_sequence_library)); \
endclass

/**
 * THIS MACRO IS BEING DEPRECATED !!!
 *
 * Clients should instead create sequence libraries manually, using the
 * SVT_SEQUENCE_LIBRARY_SAFE_ADD_SEQUENCE macro to populate the library.
 */
`define SVT_SEQUENCE_LIBRARY_IMP(ITEM, SUITE) \
function ITEM``_sequence_library::new(string name = `SVT_DATA_UTIL_ARG_TO_STRING(ITEM``_sequence_library)); \
  super.new(name, `SVT_DATA_UTIL_ARG_TO_STRING(SUITE)); \
`ifdef SVT_UVM_TECHNOLOGY \
  init_sequence_library(); \
`endif \
endfunction

/**
 * Macro which can be used to add a sequence to a sequence library, after
 * checking to make sure the sequence is valid relative to the sequence
 * library cfg. When a sequence is added successfully the count variable
 * provided by the caller is incremented to indicate the successful
 * addition.
 */
`define SVT_SEQUENCE_LIBRARY_SAFE_ADD_SEQUENCE(seqtype,count) \
begin \
  seqtype seq = new(); \
  if (seq.is_applicable(cfg)) begin \
    this.add_sequence(seqtype::get_type()); \
    count++; \
  end \
end

`ifdef SVT_UVM_TECHNOLOGY

 `define svt_sequence_library_utils(TYPE) \
    `uvm_sequence_library_utils(TYPE)
        
 `define svt_add_to_seq_lib(TYPE,LIBTYPE) \
    `uvm_add_to_seq_lib(TYPE,LIBTYPE)

`elsif SVT_OVM_TECHNOLOGY

`define svt_sequence_library_utils(TYPE) \
\
   static protected ovm_object_wrapper m_typewide_sequences[$]; \
   \
   function void init_sequence_library(); \
     foreach (TYPE::m_typewide_sequences[i]) \
       sequences.push_back(TYPE::m_typewide_sequences[i]); \
   endfunction \
   \
   static function void add_typewide_sequence(ovm_object_wrapper seq_type); \
     if (m_static_check(seq_type)) \
       TYPE::m_typewide_sequences.push_back(seq_type); \
   endfunction \
   \
   static function bit m_add_typewide_sequence(ovm_object_wrapper seq_type); \
     TYPE::add_typewide_sequence(seq_type); \
     return 1; \
   endfunction

`define svt_add_to_seq_lib(TYPE,LIBTYPE) \
   static bit add_``TYPE``_to_seq_lib_``LIBTYPE =\
      LIBTYPE::m_add_typewide_sequence(TYPE::get_type());

`endif


// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT sequences.
 */
`ifdef SVT_UVM_TECHNOLOGY
class svt_sequence_library#(type REQ=uvm_sequence_item,
                            type RSP=REQ) extends uvm_sequence_library#(REQ,RSP);
`elsif SVT_OVM_TECHNOLOGY
class svt_sequence_library#(type REQ=ovm_sequence_item,
                            type RSP=REQ) extends svt_ovm_sequence_library#(REQ,RSP);
`endif
   
  /**
   Counter used internally to the select_sequence() method.
   */
  int unsigned select_sequence_counter = 0;
  
  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  /**
   * Identifies the product suite with which a derivative class is associated. Can be
   * accessed through 'get_suite_name()', but cannot be altered after object creation.
   */
/** @cond SV_ONLY */
  protected string  suite_name = "";
/** @endcond */

`protected
+6e^=UZU:G-KDb7)KSQQ]bV6FH6LW;+fSW)>17#:)=O)Q.,?@g5\1)cOF8M85aGf
\(+H:6dG9f^MVd6LbAaWAbOdD@L@eD.C]3U4BGL4+W@_D5-e.b&LA+cOM$
`endprotected


  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  /** CONSTRUCTOR: Create a new SVT sequence library object */
  extern function new (string name = "svt_sequence_library", string suite_name="");

//svt_vcs_lic_vip_protect
`protected
Gf7b&.O:,Vd8[f8/b7K-WFO6PX;8G1I2HXZXTgQ87e2GO]8P2N5^((fW9U69XZSa
96c?GNfEG8-P>ef8UV3c#WB==WW;+NJ<G]NR5:DXP/WWRP,/EK0DQ^YX,9C:[HSQ
]TV9Wg>W_Z^K[.@6=Dc\^#^F7=UbOJ8dQ<UBe,V?DaFd[f90Dd_H:VT8T#&a1>/0
F+OG#2Z(KN\DN]C]=YbQWZYE#RHeHC2T=;RW[(S5CdZB_WK/T&(^?He\ISJ_8(5^
V>ULAI_V=Q3Qa565R>/\E[[F.GL]eBd&Y13FM.Wff+,f\cPZ]ecQ;1N1#18M&<cb
4Eg@&E0]ZcDIf/(7E2062F1aCNW5MN3A/dZJ>X-;/7LOIVU]dV=>3^;Wb0#5^W=0
ZUTE#>X-39L87@O>M^(2=5HU+_e)GO9eM8U(ZLX+P?&FHHJ6M/g1&Z7E/(81fT93
X<^R3@ZS?1643O/D@=OI,L>M0U(3JK@_4?9BDK:CT<LE)6d/=fHZP.V_b-M-HB5c
TeC>,#VPHW&NH0P?3&>+FH\-8d8I-W=#:](O/g_C.aL1F[L#VdSR=-AeSJ0FQSg5
_E.:Eg[dK(?;K48\GZeLX=5EC\RLA(1=)@2,+[>eXO&\AN?>?I.A\3OAE;4S-gT/
a+\>IR3#&X1)9FAJ/]C?CKf6MIXMA\+F>K5^\RSV22:+W]gf]>R@\OOAI$
`endprotected


  // ---------------------------------------------------------------------------
  /** Returns the model suite name associated with an object. */
  extern virtual function string get_suite_name();

`protected
)#C\9FGe-Y&G[1;/<@8^7O?5\-U5aM;3S;(@dLY+0F8ZA@=6LH:-/)MO2ce_>XK6
8bA5QgLUHa7=Cb6]cA^JLB5PebXI)CA1abbf/CP/^/)YDI9/?Ec[NG3IVL3L\ST5
39;DXVbP#M7=/$
`endprotected


  // ---------------------------------------------------------------------------
  /**
   * Populates the library with all of the desired sequences. This method registers
   * all applicable sequences to an instance of this class.  Expectation is to call
   * this method after creating an instance of this library.
   *
   * Base class currently implemented to generate an error and return '0'. The
   * implication of this is that extended classes must implement the method and
   * must not call the base class.
   *
   * @param cfg The configuration to validate against.
   * @return Returns the number of sequences added to the library.
   */
  extern function int unsigned populate_library(svt_configuration cfg);

  // ---------------------------------------------------------------------------
  /**
   * Generates an index used to select the next sequence to execute.  Overrides must return a value between 0 and max,
   * inclusive.  Used only for UVM_SEQ_LIB_USER selection mode. The default implementation returns 0, incrementing on
   * successive calls, wrapping back to 0 when reaching max.
   *
   * @param max The maximum index value to select, typically the number of sequences registered with the library 1.
   * @return The selected index value.
   */
   extern function int unsigned select_sequence(int unsigned max);


  // =============================================================================
endclass


`protected
/<_]=N@B,]L6AT,gbVIYZ43[A6H6(K=[/38We)(:Y7=9L;_:Q2Hc4)/RaL]33>&=
cVg<S9dDD.,WaA+B\?ZNU@<_9:2e7B^=LJ#U7[RG<eP+/7MPQW4E[DZH&P:cH^a4
51BK3J^N[\4e]=A(;,NUE;:G(VCUYd8<2NFc3P(^T,bECDNGT:e;c\(A8E3;)M_B
LGK\A758ILM1RZL6+C@_;d=N))OPCgD7Ke#Z&3RcS;A?S/H<<K^?6Y&TUcg6TZV:
9.>)JPF/T2&AT:Lb+7cF>)<aKb+XA:IKDX<-ccLCdXBD+_cFQX9N2dQcfI8,RSWa
BM,d>O;/H:5SKDgB>F6f>[R\dfd^F0>/]c],<&N7/])@L<>:46Ng6GL7S[7Pc_Z[
;6GF246R1QM27dT^e:H#ONaFA&A7<T,aCU<FF.P:=KKgC;XK@G=U6@;0b[gMK=6S
40_U>L?<cUa&4R,c2?Z180-;R]8)_/)+K&YC6=a,g7@+IXA-^Ce/D(de26_-e>9e
J(a)\)[g/D(>H<FBZ2][;)d#=ZTA#7;(F8B4g(eCAR/J\C_:cIL]589G<Re.Lgb(
8aCZD](UW1>]#7GVE_b#4E<J/[c0YT9VBgI<+8c-F?>J>YSL,.gWP3U8&CY)+(-a
V8+OLN96&V_0a3MOec_CDC05d0V2,MH:Y4>=ZG(@O^&Q]T_D^g\:<:ES2EZN_WG2
?8Y?EZ3T6FD#eF:TaUcY#^OJ[5aK@(.Z8DBSJ=)R5EBc[JdOJ5&(cNcDc\WE32K?
\C<G?GT-JQ4PB(a7GcRNML7W6H5<?5e2>YS[.[P6Iee#60MWZ9ZM)BMOFN.gUZ/Z
V-:8+bdY@DTaJ>:0],,(-A7W2$
`endprotected


//svt_vcs_lic_vip_protect
`protected
Xg:3L.HgI]cB&_dAR12>5+<DJ0T_IU9fF?][RJ3\Z^BN7HC[L@2<,(PS^OX]DeZ2
08/P-<?^1#62W3.&T&f<Xb0@.YY.JXIE2;29?RI:=:@-Ya(^(-WHLc<2gAAeP1DO
\07A1gAP]O#17BW?2f/aP<0^a[C7@59c55E?EfPM?_DQ4e]VY,fc8Q>#eW5NR_/K
KK&Z8c4#/193(<1P0>^C>GSUeYG1=F^[0X_+2>-+-dNYf]9#7N-4^-@-SaV,(=<8
B4B\()10&-FH9W]aLNLJBcOf9==55Q&\CCUEDbYI=UFKNMODaWAF<.3NX3&g;.T=
a]_fR=[BSJO)f)/UT\,A@9Ha4d7#G.5-W?5@E2f_FbVH[4O9CZ46WY>;E1CZeW=\
HU.#?)O8_X>C,L(U1#@X[Fd>9+NE-_bW4ZR79B,VGZbUC846Ac,(\7A&AO#CfPec
YITD-A0fZW[C7Ja58UK,\XUGV]:c<LgdN\>G3UOWa6/09\Fd].Wb44\;R-I9=+<T
f&M83Rf7#Q-W1?:X)0]+aS=&I2QK,TMcFE4U2GN#QJ>=cgcdY3)Q[]H&bLAYI^E9
X12BNaEVKH1YLL[gaERE3@IZF0@A4U46?4.CK248:\G.5feJX><+e[-B^ZfX;K4H
BFU.a/VZcRI>d(2U?d&WK8_X+(+2K(VG:NI7D)fVN57WYXK&NY[=HMGDBC4R3E[Q
H#PD/1T<3D+8#_fW[]JAE+&Z>E#YTVQBY@AE9:?ZC3,CaXF4[E)6M9K@K:VcVG3>
P>&aR(48\@;:U]^F.S3USVQ#N2]D2/EQC[4E<[QNE,]P7eZ&5<fD3YF[<B(acY<.
BD)/aUPf:,4F:\FfS<MQQXO#O,dJH1XJ<fNH1(UZ44PU^>2G=1W&WL_F8+MNbWc4
0;HSW\PK&-0XQF-MdS_BQ2g0g9I]G\E\dMBgNU,)MTQK/BI9ZIN&D/7;,6VSPRM?
)C3OU:GTF./P.+8NMFU+B7;d)K&;c6@F5_5D]AF[(P3I1T=N.K[GTP(S&:G7)dU)
=DOCVK66.^@UW1M<Z/F=+L@fO@JH\cEGJgP_9fNXfVdFU(@=&-_ZUEDH4EM2X:0P
VU4ScCLF7K5,W9:#@fL0=;;#W7[].a<WQ?3bLd.fT,K1PaB<+O)^7?bCe)14GI2@
I.C;HHZ#D5543gc:>30g(7+P;f/0:TU0\a-NP=9NP^K\0Q@,>IY,YE8&2f]HV9+\
-OH-T1_gVMe6X<0(L<JdJIBHIg7[5D]ILUQI@@]8[DH^fNB7/UeGRD;2U0PIK>GJ
[B^Ma55M3aJdAdZVF6bb_1JK+^_UD5T]2AW6YWKQ:?UbKV9Q[:cKUG\_AE&3Q^a8
^VSK=)NQ9.+_b;&SB)P+>KN>/?NYa:TSScED-:C>Bd3WR;,cdJ<>/25P=G03\\-#
\I6fMe-<@[5Y(T(/ONH02#M9cBI.4XZCG61C2bbFB8ec601&20=dVNV\\2dRGTbA
1ZG+:faI/&_^HO5G:2//?\B7+PH&fZ#KSW1E5]QEDHDJ5[[@B&:=P?ZP+40ZWbJJU$
`endprotected


`endif // GUARD_SVT_SEQUENCE_LIBRARY_SV
