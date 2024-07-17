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

`ifndef GUARD_SVT_TRANSACTION_ITER_SV
`define GUARD_SVT_TRANSACTION_ITER_SV

`ifdef SVT_VMM_TECHNOLOGY
 `define SVT_TRANSACTION_ITER_TYPE svt_transaction_iter
`else
 `define SVT_TRANSACTION_ITER_TYPE svt_sequence_item_iter
`endif

/** Macro used to pull the data object from the proper collection */
`define SVT_TRANSACTION_ITER_TOP_LEVEL_XACT \
( \
  (iter_type == IMPLEMENTATION) ? this.iter_xact.implementation[top_level_ix] : \
  ((iter_type == TRACE) && (this.iter_xact.trace.size() == 0)) ? this.iter_xact.implementation[top_level_ix] : \
  ((iter_type == TRACE) && ((name_match == null) || scan_name_match_trace)) ? this.iter_xact.trace[top_level_ix] : \
  ((iter_type == TRACE) && (name_match.get_class_name() != iter_xact.get_class_name())) ? this.iter_xact.trace[top_level_ix] : \
  (iter_type == TRACE) ? this.iter_xact.implementation[top_level_ix] : \
  null \
)

/** Macro used to access the queue size for the proper collection */
`define SVT_TRANSACTION_ITER_TOP_LEVEL_QUEUE_SIZE \
( \
  (iter_type == IMPLEMENTATION) ? this.iter_xact.implementation.size() : \
  ((iter_type == TRACE) && (this.iter_xact.trace.size() == 0)) ? this.iter_xact.implementation.size() : \
  ((iter_type == TRACE) && ((name_match == null) || scan_name_match_trace)) ? this.iter_xact.trace.size() : \
  ((iter_type == TRACE) && (name_match.get_class_name() != iter_xact.get_class_name())) ? this.iter_xact.trace.size() : \
  (iter_type == TRACE) ? this.iter_xact.implementation.size() : \
  0 \
)

/** Macro used to figure out the first available index */
`define SVT_TRANSACTION_ITER_FIRST_IX \
( (start_ix == -1) ? 0 : start_ix )

/** Macro used to figure out the last available index */
`define SVT_TRANSACTION_ITER_LAST_IX \
( (end_ix == -1) ? `SVT_TRANSACTION_ITER_TOP_LEVEL_QUEUE_SIZE-1 : end_ix )

// =============================================================================
/**
 * Iterators that can be used to iterate over the implementation and trace
 * collections stored with a transaction.
 */
class `SVT_TRANSACTION_ITER_TYPE extends `SVT_DATA_ITER_TYPE;

  // ****************************************************************************
  // General Types
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  /**
   * This enumeration is used to signify which data collection the client wishes
   * to iterate on. The supported choices correspond to the collections supported
   * by this class.
   */
  typedef enum {
    IMPLEMENTATION,     /**< Indicates iteration should be over the implementation data */
    TRACE               /**< Indicates iteration should be over the trace data */
  } iter_type_enum;

  // ****************************************************************************
  // Internal Data
  // ****************************************************************************

  /** The base transaction the iterator is going to be scanning. */
  protected `SVT_TRANSACTION_TYPE       iter_xact;

  /** Indicates which collection should be iterated over. */
  protected iter_type_enum iter_type = TRACE;

  /**
   * Used to do a name match (using `SVT_DATA_TYPE::get_class_name()) of the scanned
   * objects in order to recognize the object the client is actually interested
   * in.
   */
  protected `SVT_DATA_TYPE              name_match = null;

  /**
   * Used to control whether the scan ends at the name_match (0) or if it
   * includes the 'trace' of the name_match object.
   */
  bit                             scan_name_match_trace = 0;

  /** Index that the iteration starts at. -1 indicates iteration starts on first queue element.  */
  protected int                   start_ix = -1;

  /** Index that the iteration ends at. -1 indicates iteration ends on last queue element. */
  protected int                   end_ix = -1;

  /** Index at the current level, based on single level traversal. */
  protected int                   top_level_ix = -1;

  /**
    * When doing a multi-level traversal, this will be a handle to the
    * iterator which iterates across the objects at the lower levels.
    */
  protected `SVT_TRANSACTION_ITER_TYPE  level_n_iter = null;

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the `SVT_TRANSACTION_ITER_TYPE class.
   *
   * @param iter_xact The base transaction the iterator is going to be
   * scanning.
   *
   * @param iter_type Used to indicate whether the iteration should be over the
   * IMPLEMENTATION queue or the TRACE queue.
   *
   * @param name_match This object, if provided, is used to recognize the
   * proper scan depth as the iterator scans the objects in the specified
   * collection. Whenever it gets a new object, it uses `SVT_DATA_TYPE::get_class_name()
   * to compare the basis for the two objects. If the compare succeeds, it goes
   * no deeper with the scan and considers this the next iterator element. If the
   * compare fails, then the scan moves into the corresponding collection on the
   * object which it was unable to compare against. If this object is not provided
   * the iterator assumes that it should do a one level scan.
   *
   * @param scan_name_match_trace If name_match is non-null and the name_match
   * svt_transaction class has a trace queue then a setting of 1 will cause the
   * iterator to traverse the trace array instead of the object itself. A setting
   * of 0 will cause the iterator to just include the object in the iteration,
   * not its trace. If name_match is null or it does not have a trace queue,
   * then this field has no impact.
   * TODO: This currently defaults to 1, but will likely change to a default of 0 soon.
   *
   * @param start_ix Optional index into the transaction implementation or
   * trace array, used to limit where the iteration starts within the
   * corresponding queue. The default value of -1 indicates that the
   * iteration starts at the first element in the corresponding queue.
   *
   * @param end_ix Optional index into the transaction implementation or
   * trace array, used to limit where the iteration ends within the
   * corresponding queue. The default value of -1 indicates that the
   * iteration ends at the last element in the corresponding queue.
   *
   * @param log An vmm_log object reference used to replace the default internal
   * logger.
   */
  extern function new(
    `SVT_TRANSACTION_TYPE iter_xact, iter_type_enum iter_type = TRACE,
    `SVT_DATA_TYPE name_match = null, bit scan_name_match_trace = 1,
    int start_ix = -1, int end_ix = -1,
    vmm_log log = null);
`else
  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the `SVT_TRANSACTION_ITER_TYPE class.
   *
   * @param iter_xact The base transaction the iterator is going to be
   * scanning.
   *
   * @param iter_type Used to indicate whether the iteration should be over the
   * IMPLEMENTATION queue or the TRACE queue.
   *
   * @param name_match This object, if provided, is used to recognize the
   * proper scan depth as the iterator scans the objects in the specified
   * collection. Whenever it gets a new object, it uses `SVT_DATA_TYPE::get_class_name()
   * to compare the basis for the two objects. If the compare succeeds, it goes
   * no deeper with the scan and considers this the next iterator element. If the
   * compare fails, then the scan moves into the corresponding collection on the
   * object which it was unable to compare against. If this object is not provided
   * the iterator assumes that it should do a one level scan.
   *
   * @param scan_name_match_trace If name_match is non-null and the name_match
   * svt_transaction class has a trace queue then a setting of 1 will cause the
   * iterator to traverse the trace array instead of the object itself. A setting
   * of 0 will cause the iterator to just include the object in the iteration,
   * not its trace. If name_match is null or it does not have a trace queue,
   * then this field has no impact.
   * TODO: This currently defaults to 1, but will likely change to a default of 0 soon.
   *
   * @param start_ix Optional index into the transaction implementation or
   * trace array, used to limit where the iteration starts within the
   * corresponding queue. The default value of -1 indicates that the
   * iteration starts at the first element in the corresponding queue.
   *
   * @param end_ix Optional index into the transaction implementation or
   * trace array, used to limit where the iteration ends within the
   * corresponding queue. The default value of -1 indicates that the
   * iteration ends at the last element in the corresponding queue.
   *
   * @param reporter A report object object reference used to replace the default internal
   * reporter.
   */
  extern function new(
    `SVT_TRANSACTION_TYPE iter_xact, iter_type_enum iter_type = TRACE,
    `SVT_DATA_TYPE name_match = null, bit scan_name_match_trace = 1,
    int start_ix = -1, int end_ix = -1,
    `SVT_XVM(report_object) reporter = null);
`endif

  // ---------------------------------------------------------------------------
  /** Reset the iterator. */
  extern virtual function void reset();

  // ---------------------------------------------------------------------------
  /**
   * Allocate a new instance of the iterator, setting it up to iterate on the
   * same object in the same fashion. This creates a duplicate iterator on the
   * same object, in the 'reset' position.
   */
  extern virtual function `SVT_DATA_ITER_TYPE allocate();

  // ---------------------------------------------------------------------------
  /**
   * Copy the iterator, putting the new iterator at the same position.
   */
  extern virtual function `SVT_DATA_ITER_TYPE copy();

  // ---------------------------------------------------------------------------
  /** Move to the first element in the collection. */
  extern virtual function bit first();

  // ---------------------------------------------------------------------------
  /** Evaluate whether the iterator is positioned on an element. */
  extern virtual function bit is_ok();

  // ---------------------------------------------------------------------------
  /** Move to the next element. */
  extern virtual function bit next();

  // ---------------------------------------------------------------------------
  /** Move to the last element. */
  extern virtual function bit last();

  // ---------------------------------------------------------------------------
  /** Move to the previous element. */
  extern virtual function bit prev();

  // ---------------------------------------------------------------------------
  /** Access the svt_data object at the current position. */
  extern virtual function `SVT_DATA_TYPE get_data();

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Initializes the iterator using the provided information.
   *
   * @param iter_xact The base transaction the iterator is going to be
   * scanning.
   *
   * @param iter_type Used to indicate whether the iteration should be over the
   * IMPLEMENTATION queue or the TRACE queue.
   *
   * @param name_match This object, if provided, is used to recognize the
   * proper scan depth as the iterator scans the objects in the specified
   * collection. Whenever it gets a new object, it uses `SVT_DATA_TYPE::get_class_name()
   * to compare the basis for the two objects. If the compare succeeds, it goes
   * no deeper with the scan and considers this the next iterator element. If the
   * compare fails, then the scan moves into the corresponding collection on the
   * object which it was unable to compare against. If this object is not provided
   * the iterator assumes that it should do a one level scan.
   *
   * @param scan_name_match_trace If name_match is non-null and the name_match
   * svt_transaction class has a trace queue then a setting of 1 will cause the
   * iterator to traverse the trace array instead of the object itself. A setting
   * of 0 will cause the iterator to just include the object in the iteration,
   * not its trace. If name_match is null or it does not have a trace queue,
   * then this field has no impact.
   *
   * @param start_ix Optional index into the transaction implementation or
   * trace array, used to limit where the iteration starts within the
   * corresponding queue. The default value of -1 indicates that the
   * iteration starts at the first element in the corresponding queue.
   *
   * @param end_ix Optional index into the transaction implementation or
   * trace array, used to limit where the iteration ends within the
   * corresponding queue. The default value of -1 indicates that the
   * iteration ends at the last element in the corresponding queue.
   *
   * @param top_level_ix This positions the top level iterator at this position.
   *
   * @param level_n_iter This sets this up as the internal iterator which is
   * working on the internal object in support of the top level iterator.
   */
  extern function void initialize(
    `SVT_TRANSACTION_TYPE iter_xact, iter_type_enum iter_type = TRACE,
    `SVT_DATA_TYPE name_match = null, bit scan_name_match_trace = 0,
    int start_ix = -1, int end_ix = -1,
    int top_level_ix = -1, `SVT_TRANSACTION_ITER_TYPE level_n_iter = null);

  // ---------------------------------------------------------------------------
  /** Checks to see if the iterator is properly positioned on a data object. */
  extern virtual function bit check_iter_level();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
\3B/gNT]=@&,->CY=9\6\M#dE:HIV^Kfb-a8e>/;<S2HR2YQgZ)M2(faBV7U.d\L
HdI<N+d)V&HfHB?7G_48LKe19b:R^2U>:H8ICEU:#JePMJO=9a>9>ET?c,_MdM<D
+6bf/B]8G9Sd6:5Fg/YJ92dYW^O0\.8C3bc>aJ,)]IW]d\8_IZPP]NXITaf\=@(c
dH\7=,:Y&YRW90C@+g):Ca+G=LKU(LG2EDHbbHHSfUU#Y+8N.aDN?S_bYYTBV=N+
>1MQ)gg2&#,;fJ?_Q=/:]SBO+E<WVfHf25REJAeL&C@=-2@cg,)2d:Q1]-(Lb]9H
R7]>.)d+(.=ABGPHXe?3-)_#L.?^Bdgg5:gf>b:6(3B&(/Re\Rf5S+9MgK.32QQP
b1;\GPe1V+gWQ/7S)?MU#03ZXUf[8Qc(Yg(BS8?1&N=P4cP^bL)8N7EfQ-XTg+E#
L6aeCDd,V0?SK,/N@4Gb2#a9TP]LS42V)NJ77QCL;eDGR02.84IF/Y^fPCC#_7^F
eY]_R@7eN[8b[-cc79eA44.e/WQE@TWC6VE>FZ:ZZ@CXRG/S0R;#+.[;bE\>Tb4f
gPE+7Gg[->R-d=KU3]DT9FUe76;FXRfVJOB2)W(7.Abe^RW2O(/dB>65_8DP5>RL
bN5>,<B;;F9SfIde\R:edgg/=[Z0.E^.7.<@bYTS(fNW8>+C#:53.eKN?>@FOYdT
F?PJ4,)=;g\<9e@.:KPZ6_4N97N?OP#.;2D+L[=Hg))J\&9_W-B[Y3,dY8S(0dOB
GF@<];M(a=H6L0VRb]_@Ia.N/gc[1>bZ((_M65\V/>^KSO;NJFTb\@\/W2E&51bU
+PT/S70ACR;;BS7@9IQDZQPBC?QGWeIE1^(W42:U94)d.[O=?M]/).dD?UM6c:M.
ZR^eZM@)HGTUPa0(U1A[C\b[?@CIX5L&O)NY=Sd92(BYg],_&8-+:EgW-77-\AK>
A.<M]^S\MK:#)MdUJB14K/=_1Q8ZOU^>3^dTOg3@NEVGOTf2C@L?4O0]I?S9VfB:
1gfH5?g29N.A2SBaOB8(>D4Qe4WLS?26GARX2,,gG+4Q4BX.dPZSA7LHGJCR7UYQ
We&RYYdT51eD@^,baHP>3e(g>/(+K:Yagf7D(N^fSZ5fYbQT-F>XZP=N?->bD6Sd
fPPRb88?cfQL8_095ICeF0?d)IB9A#)FPEM>A-0#R\3g81.80#Id0BER[+1UD:Bg
)Hf&<-V&G68O+a/^UO)BQfR7-L.,-G9L/>:\d/OP73Bb8-_HQW55c?KD;]R)-J>g
^#W+:2H^TfB&d7J>[QTF8gM_DW&]SD-6LF6<F_/g^=686FRZ[.&0_dZI5/KX@@[/
T3=8Zc4<aeADG&Dc5B4W\:8,:(3&1C18fODD</2@=0I4J[X961V^-H[1JIS7,^7d
]B61MJIFLH+c&LE4@LO=6;JE++P;D2OZ;2MIg6M-I51HMBAH+X=NG0W&5]8>b6M)
_Re)_<_?ZE[TbE^,6c-KQ^<2PLI7PICNO.V>GVbHQN1e0cEfW4/VY4T0-_>/+\^B
#&d.)\=JPd#E710<(4PKXLg_[J3/CI=2Z=3-N:B;_,B&S>V(D)9ga(Z,\)cdEG?T
.@3^J?-d(I^;#Nc8S20BQUR?V#^cFSA24gP:=1,5L83_.aY0g>YG]GJ5I/TIf4a-
NY/FZR)2NKOXR0H-:\03NA\Aa:TE[AC-Q0TUA[]7-+.;:Z7NU:PQHN(\2J2c31ec
SS7,INg;9NC;55@F\PVVEC=\,58aJK>9K_2fE?[;RKK&Q6g7:5XL6G(,[.K^dQW1
BPQVRg4/d:]2fTQ+L1F)6W+N5:N/5&9N.)?cX?CYc0d(3BX]dKcb#W7=6DEQMKaB
ZcgM-?U\VNYZF+7#<=I)@/K?UUeH[QfBR+1HbeN_Kb.[BQ/M[?6T>JNX(9X,XM@R
@cF]]2a578C2==H(a8<^Q&aa,AGHTdZRFH87W</WUUgM4a0)Y<f@;Y-XbNf[9RHf
5J>NET(?d_E\2NZA=eXW1B?6W>egVf)#7AgEHTFD0K/\/>_TIDDJWa4KIRN9Xe/_
bWc;M>>GfT4<JA-bYC6C1(3;GNd[0aLVbH&\NBgQ7.^FYPg.ZR;\T(OJ969(1R&G
AEQGc8N::dPW__KIG7=H&40gO5)K?Z0[6dYA-e<FC8EfZ?6JEXGO@c.8<6VFOWdO
^4+G5?e74c53c?Ug9bCTC53&#7ND\QJ@/S,OQGR5?5K6T6S@aPae@+,+^M#9MOMK
@C3)HFE<4d+bJ4[61g=@bF;f,_N]=Kg\KK.2[CAE/BA2Z_A-55D/fb5BgH;#2WIB
W.d./LJ\6?]D\eZB1V^FMeFd-AH-L(15QC<aJ5I_FO.b+-BJaagHQQ[4X,>Kd3,9
E#Be_L7<RZ4X>>DPH^R_[T)X^OF+TVM\K6#DFA39K9O#-c1J>U2cC[E<e06#a+1Y
X3D9WQc4J-JAC8/Z:RTEdRUX>^W0-]b40-b6Qf6\M.BN35gcBEJAJE:VB_20?WMO
,CRcT0],F<RF7d[\2?4G86U(_FVaK.@MM9RgVY]QH[\X.2\UdXOMMa:CBS_d.NDO
HYGZ1fT]0UHcXF;[d&Z)Q6,d(JVZV(?adCd.1AM?54#3X0A/0VH_f&Db#?^1Sd1E
(UWB]B);)bB1gGfZ,]CEWa8=^<.FHaP&>fV&gNMGJV8e&@cJd[0ROKXb=JC+Zg[g
6)7OWYI/)-:CSASQK_4<DcHT/KaZ[#719QDG.N,VO49H-)O;P_ETP\Qa:fFKCWEO
/:SSGAO3P<ee7>(<3NGZF9;/\b20FO_/,.G3(.C31d[D71CQ6e@31PGW_gC@E3H/
1ZMg\XJ__/933B.X4F]NVPVS2T_V_G1/g(26WaY4D:8ecM-?>MH)0X>aCYYQJ6/O
^?)LCb_@@0f?D5)5IFPVgOIIaJR&-B5e]MVQdIDI321X93;_2fWKJ#T_gV4=Y9N<
L+?INYEJ__fF:>98K^@,+d:-0gKE_4.P^Q(4OOO,;HBF]D<e82:W,OEPP(:/AXaW
2(W22b2H0L#-MW<?M&g&g[78>C;)]HTQ9b<,_AJe?C0>cC;.4a\O[PP(Q<NeS0\6
5:1dGY#0WK1&H-[[W^[F#gEV.&JB&GA(P2#+4I6(_6CJ.2N+Ua(8>Z<XK):<XYAa
&2K(-K@L1d8dT&Z(1;^EK,^7M<4W5=G34>JA(&^3O^K;D<fH9IU[Xb287XMb37-]
U(79K1J)ZW&^Ag>_O2>DdNGT9QYT2E@V]ZGG1\616KT#2ca93(#7SY^J983[42;=
20UN:BWA3QI+V2);(5YVDXdP-5-2N;]T&RA<1,DOJcMT]87<cd(L/(,._D61,ELN
XTHf\<<(EEIRW=/IV_73T<=VEW+L=Q9cbZP5-2,5.(L?5&\&;KM:60;.)_-L;Ke2
M(T(GZ^/bPI+?&UdI\)e65dNSN^14;C1T^9)5M0H(WO4TX4c;Z^9]:(.U1W9?4_H
IdXB-V,ZaJ=[#FO9I/7O+eSPXG^U&+^@06Ye#LLFDMB_2_@Te,^V\1K;[89K2W7g
/LGJ6G3^L7+<1P:\,5Uf@e3&(&>XC[V.;B.;INEDOJYbZ9PR:B=-QC,^3:Q\?fI/
2&EBVc19#FA>e4JW;2;SaOA:.C7@R6f+eMH1JFNWTFAUX3,S]UN#T1E,27_&,Q>:
Z:W(L=L&O9\7S+DNU,ZC=OB=cV<aH.I9NM5=0)YQb4V^2d+8[0eEY.+U4C++RZ(@
RB;2/a(PN[WfRdB0?g#QRg4,<3FI>f2<D^LH,T_>4FS9Z?EFYXFMNU3_,__(gQgY
gb91;[Cb2&V1bH(IRA][HBN4EX#=[5):QT>SG<DTeUYM91=g-_8AJ^Q4[_@)H2Of
OS/>[,4cb7d/<.8XOPGJTRPYCeJ^>b[+>U9@X,Y?ZA[><5e;H,XC39ORSb-0PJUE
94+T^VT6G4?aA/3=G9\V5J/A3\]Sf?IfR2+2)=K<FfV#N9RC\6>e<Q)E2J1=)NVB
&@&F;&6M;0Cb=.H&A\([Kgg?\7GZ]c?J36>M5J#:aUADgQPKN0B5>OL<^T__4&3:
FI0a(:^5,,YJP3Ed-f\,-;/:N9aJfed+]eJ4[[U>IQJ8K[6]DT4E(9S^&^MDBWG\
a&\#R5\]cUMZ#YDa:L[)9CN];Y</.R;^?X:fX78MK>[)UONHed?.30;;(DHg5(Y5
.:e)BR/5=_]8JYZU#H9I(>ea6=AAR0E<[>P.;JHZNO/)-1bP-=9E&/&ZZAd4@-Qd
9C+OJ<a[G3)6fGK3VRBFNI)CdV_GIDLFAG_T\Q;b2.&dRI7F,LdUJW5.Cb:)E8N:
g3cUQ.FC).S#1[L&@S6M+1\T^OVCed9<(,ScT+B\RL2#09K3d22W)=^5@J[R+[d]
\]cL0C]&c&)7[e1:,#?43bVWP80Fd=1+Jb)b)f+5_HaD,SF.fdFSOX&<V_c>cLcE
-]84>?OTY/LZ>U\U9b(fRC?EdR(LU]NGPJ]XVHC-?R>Y^,U5Yc:<#UTab5=V^8A6
0VSd(QVB=L/7ec4,]V<H/#IS04M5WQBd5XXP57dB7bR&_/6B&[]S=VY_gK.B97&\
A6TTdg(ZT36:f^3XeU;XEG.5cdFe6#970A.)7SV^OdE^f)=+?dMQZE8DDCRF2?#a
3Y,Q_PU2,V]AKXMFfV9S)6Y-#2a?AJ6^;+,gL#(=VFR/HU]]XW=X=^=ZY>GQCD.M
3L>dJFUU<C:/_:cHOG)+a0-BX_W4M&2ZeX5@:&:9#PcO29U\eU9R(Fe7_S-eEdSW
&13F<000-D>PP4f9F1&SY2:M/3J7\UVbGaO_9S/?IXQ+LgQ+(IEeIGR3B?Z<+g:c
UGUP(c@64G29O2P#c;9.W,7G\.^XAfF3)=[0feT]\K-RT=3/]+5eK/3PT@^ALS#a
\PG,_BSdPb1R=B.?@R3H,,:I?+19W+60?\4#.4=R@eA&D8SRU&I9cWPELW+R<0c@
WO,C62&EVcVK@D[XgJ_2P6_W.Y7.DU@AH[6aIW@ga51dOM&T/\LS8XCOR;OeEGNe
>Fg-CU2\0ENFIXS9NHD9Z,]e3U.&K_NBHCO8b2^XF:_B:a(3e:3A^M&XD]7G\OW<
H#+^0XGXW-2HeM/ISO(G1g71?QQMF1:O&Hb\a6Reg8E&I.NMD>O=B)U4;4B#J>b5
;=IVO4Z?U@fCFE;B>MVGg<WLR,\F3)Z0+TL=(T>2QGUJLRQ5N[f<FM1FAE1Me:NJ
;.0d9GdTN/g]3OG;13Q4/G[;b@&e&8^P.)&V,b82KE)dUVgIaA@6Ke4[3)7a4dR?
WG8@3cdH#>1L76SI3:Q,c-B>:=-P;2Z@[HX09/8:R@92gBWEM#TFSBPLZH(,a@,+
KbLB+B:UE]CcJLAaHM>2a_YdHMIdDZ^[S90;F.eK1I+X3FI^b=2Xfae7ZId8^6C>
NLdL9PLS1+0N:GD2NJg=WW=E#f.,)U<(Zd.WOTf[Z>dR)GVd,U]JcUgBg#?-=T^Y
)<=XD;Q\3N\XR;aged:C^J.R0OE1PP#CaA7D+<IO=AMaTRHK;FbT_AV=,e&090[N
#?3fO.Z/1EK2NA+GL7;_fJQ:E5>eGc+4??^H,ZFe\;R#ad^fZNM1^YH#9c,I1DA+
>)GHWC3E38,V-/(Z.^6)31&];WC;\I,D?4T082R^:QDPVC53LMf.OV/D1)RFIgOJ
]G@&XH&)<(fHH+ZQ.QK(2>5/9.5<aIIZ9RF5b=<b0d(CYDILe6L&IZNPf/;5Mc:M
,),)C<@2_D0g5XX;ce@H;U=P,GaZPK[,^D;+/-A^+H/C-U1_Ca7)M+9+GRASE7P6
\;+X(?8b^YM-KdfgFP&->c>Q..P,86OFT0&0O7N@IQWTEe9#VI#gM->gE>NcT@JU
F+_S]cZJ114aWFX_>;,BPIUf;W7@,BY_f[<>I<aDB2FQRXfcAH)5^H=VCaI@Z>a]
T^4GM@\JRG;^g<=&=&QDfFBgNNeV=SM/GM3)]TKP?@G#5/b^/)Ya^ZM2Tf3GO??R
Oe4XINbK^_6d-S#IC8,7&c@,GaF6M?aEM,Qa3ITBF9<Cdf.c/6L/_#8YPM15/3]]
N96gSM4Dcd_FQbYF@cI&[2bI6+ZOg(658@BC>HcdHEDN_.U-_@T\G[X(GR9_>-2d
)>/1E8;gE/d]fK8W5;Q92HR#CBVX.V1)/_36NeMABF4bK(DY#R8\QKN4M9E;>N;^
KCWBN9X12-,3(4@4:]US6O\5XZ)\1J/BEH/41B?Ha;<Jdfd<.377K&R^23g\^RPN
CJ)&R#GLC0#&#3d:><#]gE\L_5_6IWC:g=(\Lg,(9N1cB3^(57(bG^AIEA8[^:/?
+Ic3:b01J4Wce2#RGIa5./^39\GD9#L7a?Z16>_;9Z:)&)bc&^CAe(Cf^>eaDZ50
25V@)X?ZT/-D.eT)_dDL3:4=+/3eTR1/IgVD?0PB+FQ+A3I(+a(6LQ_]W;?PacKE
A6\_#HP21PXA06/G#g[B6fFEZQ/V#P:?XS5QdLC0;?Pc@HU:J6,+fdDT3YDH.,be
Q9f;X[M15=]g9@-CQEB4bOU2c0P#:M,Te\DHPC&R7:(/+H7S_1UJbPOEMR7?Z3F(
MOPMf&LJ07:4+J,#)CM_S(F0:WCU)YNP7]ST4)=9I4FV\)a(ReQ;F0MgGSg-9f3W
5G]NTH-O+;=b<1?a07W=,L0@=5JYS:PX<PB_=()f=N)@Q+_BZ2X8HfW;HbN];;Wg
Mg,(NFV2RFbdcX_03X@cFWQW3e#BU#4=R9M-#aCNC(X-NdD.>dUB=YY,IDBdFLH?
+IUAcU:QGb7O-eC+XZ;9g,SFTDK7>22?0(86a_6MVML:V\e,>3Se.^EEI#?GH=:K
F)FC;?HY+d<_ZBX#J#@1fVE.S]HSb?A->@2=55GD:-GYN?U##6Z]20#[5D@fFWDb
A0X3e9/5JJGI0.,BF=PA=HdQWaQe_L1L<CL0O#e\BLM;GA,a>&+,@&M8>&[8G0&P
Z1dLEHbNX#eMg-^Le\(WC.K<[dU3/EZB^;@(82:U?b[B]SL3#.aM#f1I#@W6X&L6
[Y@X>d3K\_H6QD9/H#I.GaF)7/[C\dgD.<fE4&X+D-EEN3D@KN_.bcdeeA>:P3W^
91\[E#OR<YdW^^N9_3E2SF,-EebG71ZDNcHOg;_B4KTTPKdg@>K]W8[G4.2[Od@f
.<EEQ/V+_GA5cZP[OYJJ?RMLF#Hb_6D;dR)&VHSLR9V)cUAa8(I[GEYaHZ3OdY1Y
5=:3[LB25F34ND;5K@<4?VW0\V5IOg35<TD=NRRaX):,AdFHb.b+CMZ)DDJ_GLcY
:,&N)8#D?_ZD:FLJFJ_\]4Ca_6[?ABd2=/;Ic]1BWT^=]L.9P6.B@WR4QCL#)LCG
IgWa]2g(WSK^I_Y4g_c0YI98Q69:SSB(d)]O+9R;Q@T@6<^2+YP+TM^QV6d<460Q
83>8^WbN9,45Tg3G[^cbJTVB-)0YP.88=Bf_A,BReNDA,TcA=8VPZ\aBSa+b@_(A
_3/RPT7Tg[\H(@3D+G#aIG.775KH2WHE/;F#C8E\/R^c,BV[gP_?)BLK/45A,KH)
+]_:Q:GKL=?gV=W6JV8>_\HTU4E020Ma+1SCSGL</MG&g\0L]3U:ZaC\84^V<P5U
b@8U]G9^<W2P6YS+6/]/.TcX3#?KJXV,<dT(1^&@2EPc7SS-<)X/2VPG>/(?2PY=
HB2WE\=cTbP5KG>=K0;OLVed@6RD_ecVJ75OBA2-\gK_H;6bf=H/HF;WLO>\9,.3
+5OI>?eU<fJ>JS]O:g)_=K;U:cJFG@f7ce[E/8?(]IP[KEgRW?dJLV,U[OAMY:#W
\Y;&S=(@W:MM[>BK9<.b>Ccb109<-c]@Wc::Rfa101c=+@N&B7?&:68IMN_H39dF
aCSgM=URI2-52e];::(4AH/6+GBQg3^7dQRZ6+L4f07)Tf>:,4]S1/N6CFWH<XG?
,UWRK=A:,.POFc5D_X<#3=<SDaC[?1>P)()3Q/.JJ@>eXL1E+eNOJG:5N3g@O;4)
T]R8H,9GB]:.aM/B=G8RE/#ee1M+AABQXFA:LaPET)3cbY&cUW&&J[;&g@IU==3-
@faa70UJ-,SJVF++d&98(]=JCU3F1aBKJ7cU;S,I]g]O2f2.KU^DfLZ;R:OLb)XT
-97DK4b6J2+W.H)T[669TOS(8HJPJFT4>;c@OI++VZZ<4X[=D>>>H,V7b@&#;GH-
-eSL&Y/3>DKK:I_)c,,N;+Q6e&1NgN=cO[<XUEcbO&]RG_;c7KTD_a)VHZ+aRG,S
T0MAO)PEX1->E)(I0R@K2c6?B]9@XZUa-+(>FIEeM-cPH7:I9&I_U?WU2F:F8R;T
Ag]M^eQ.[R5OK5g&g=A>0>N@U(8SAa6agDE-L#7HfI#/3QA:DFFBO[=De/C,bP(I
:IV(YO7)HgBN#.2VGX&AG-HZIaI/FfB:VTFTd0(JTF>b@KXN2</0U9GdM]<21eP0
<_\Y)GDfB2ZWdP1/)Mef,AP(PU35)DQM@HNVF[e>]3aOG;FPI#7eb90cPg2BZ#g/
Be0&O;F8)Na>HRGYEPN6C<>.OZ^A98/<9VeYZD>,aY.)LG.E>YaaI(KTLA_84WG/
a1]:gbfK_Mg#+5R]ID^M6L1CAY3W5_K/6W:gE>I;4Z.:?R#V<fXCA\IT<9b\;?-5
W(NO?cc_&H+[0@@J(A-@XX8CI02-4YPe,>2Z]_05ZGe#A/L7@IceTDBPGR-;eYVX
J5DO05SV37N,GZQJA_,Db^GV5PPd\=_Z\FP],QYVXc?]B;,@Q<)eRG9BDcO5eM9&
ADc)DPZX6?5<Z&GQa)3f]W4UMa;TFW9(+IaUg;e7\->ORR=>d[:2\N/Rf-;JGE(X
CE5CbcEadbgKJL[P\)?4B&-]=>SIZgK><Q(<]EZQ1F.B]cg7DT:D0&UUEeDW@&7F
1F&_8a2T<E8f=0?F5F(JL=/8Zd+N0HC.^M#[JQ6LII;&84#+T1RBdUN464[?VAG[
K1K;VNNa0T4M&=XP,/_IR-K=MI<:a49)&H1=Eb9R;C;3]QA4HX=)I_XJI6:K=0g;
N#g(_NG]4^^gA/ESPc23-XAYgHH7M-EI8He2_N-Q/3JAZG;@<2T6E54^7=><f^UC
M25:_cJ+^?B@TL\Z7^F.geCQM<aa#^=[T_eLL#7;W.&7X33Ga6[F+1EV=UdMJL2S
)T)N>,d2Q&J:>#bc<8P?8_:T5;GM_A;O8=-GVf[/a:cJ/<>g\_/P,9]QaSYJPADI
dVGG08g/^(0W?LR1O=I\:+b<1=?e\A1QGWQT)E29/b#X&=3^XA)_&R05ObQTf1C<
P1X+.Q\_\#W43-K#CbRagL)=(N]bMd?1=QMR)::.;:gH^\Q),0G]_;J//5S;d)>^
G^d@)&6JGTX5^BY4C7+4b^O;+bgaJ8H:T;MTa4QeVTLN22)9-Z8DCTW^_e#C>7#M
LV1aTebS92&^XIS)Y]2;>UMGXSP-:C&3GaYR/27<U/cVB7454D8-<Z2_]f7)G;/@
<F6@P448<A1K3#<0D,)^\>M#M.M5-2Ae^4ZX=I.U]&<TH24LcTUg:c?NPX+QLN5Q
7H>_8e-+LgD:;J4a-f-\TH;:ZYX_/FW2fRIOURA=GbE+K76S-<QVKU=+@VW09W+K
)8fHR2\+=-FQEcCWBG7(CIKd.@K#,a[F@5d1d0OS&g)S3(5Yd[D93Da:Qe(^2)J1
KJ8-IXdg)V)71UeNRN?G]:4(_.]JcDO1ab4F5CFW1FKA1/N3;R\ZG>6G-T&:KbFG
&VIgO6II;4&W0#L1/W&dKR;A>=U[/]^97e86\08,?c&12?8bX&NOdH5-Z0?<7YA?
9=]Sage)N@L(+(HB(cOMg1.IOP-ZO\1YE#\;-g5b67/NQQBEbXQ^3U&eYHYMQBeg
VQ\QXY13;1/?[?(Wd<W^(((2Vd+BK,QW2>#Q=SC>5?AZPY+eISKY-Z&e;]I0Gd^5
\a/##g+P7CS_KHgSC&F.+gZ=K>B,/Wb_,4fT-?3,?+<8XS=1SdNC70OV-6)H)A(I
N(KXTOAY]^#6cc3HJ]90b=15O:ed,aXX=2^)H^<?.FEZZ(6-R_E,8P_H/9Z<+O7.
I:Q&;bDEa#6cX67J@?A/+@b\RW3e5D,M5/PA3Y^33,V7__F2@@0V+J9F2^//ABIT
C+Y2?HI(K/2?PE?&eQPCT.;e]6=3&1+O0]c6.Y9?)R9G5\54c4R)VG7^UYNc-]#f
1EX<GI9;7a;)8SC+3:dfV(DIL:.-g\b:4;?00<ZQdB[GC8O[e;#3^RR8/MZ9Dc].
L\R]1.E4=20+&YHYG0LF>;2O1NS.(7gUL-cb20AC&3)XebFFC5_gE.RAMO@WRX+e
+.5K[[J5H4O\YH]4<//f0_:_@c,74M,33:]T>PP@_W>fO]b--7Le-?6HMO^@cW(7
gLbK1)?G8.I,QN7KV@Ke6#U7QHYXg:U_TDARE_)OFf,W,X)1S\Z6BE-fcNI5P&45
bTAUH9.D:R&7A7>KFY(I89LTC]Gg.V_)9#XBDVg81.cS:+FVDTZg5eA.?8LG6ZX@
H4_#TR^WU,RG5[6PF-WIfW;,L/,d3##M>cJ^1^+J3W7OgFWG;4&-M6<]N1B9@F#8
VZEV0XdaKZ_C0dbW@afKb7:NYNKD_VBE>U=CM6:(VPLf=^(RWL9KbKaa<+#Kfg#<
2WZS#Vg5.5J(5cZOMGN?RL,X/BD4<LEH<CBXX=8#0#>5DLL6DC1Nb7Ad5fQ542,;
STCYS_.f[?YA7VGb98.1UgQ?2?d+]W4I)LKT6N)?G?/C.0TA)UIP3d+JC?M:YaMU
2N<<>5Y3R+AdH<R0LP?8SdYC/L@^J,]ZG]d^KI?XOQ3DD^g-3EaT&<OR9W_=-B,M
B)Y6:VA[,#XA1Fg#2J)??2<LJVUKUH#\,\e:+W#c-C,_)C:UEg6BU^:/WJDb@:OO
^cK[_e([/;9gPE4Q=ZR:@(7:;P6]CBcUSNcd4;>AcR8AbT^NL_eC,fCF6QZ0B>&]
49K&ZP?E<K,\?\N+X/f&-QEcLBTXAE+T],HaA#VU_b;1K1LYR_@M6[^QU1:;<Id0
8?/K;4H6UgBX,b>G4S+7?SH.=.EKE>+eM^C^Da/,BQeE5Z9dD8[()0>TIH3Ad);7
c1#04=PQ]2OZ\J4(]Kg9IJU>PM1..@=cYBcfb(NT)f#<Sc-O+6M>.E(/?/0g2Y]^
,MH/XQO0GQJNd5YFN:)>HDH=PIRNX@WV)E[(K,aY.Z3+<TgH](C7476;EEdgHR1F
f,@-a.?(RJba@c,_XM^__4be^K\F)/#1D0C4.NV551.H0G:=SfV/SRPQa4M]QL@H
fAN.WG8:aWU<(+\C(eJ5?W2+IX+71K6A?,SSS6N,VZEDTP0>6NNLF8&HQf#fME5O
@[)KA)(/(]52P-4#3LDJ2SaYX9E_RG>N.9:?X4A?XMYEb3=2I2Y>Seg)JQQL:Gc1
=7f)-,4ZZ@HJ/U&.VQ,(ZQ9].N:E.[TG\(dgA]B)LV)T4(1ec#68,BHEe9V.UN]8
JHbdV2TQ?aZ9YL&PL^#(=TeRZbMXE?\bPb5+5eWVZeT?5_@G9aDc-4+]Ped>g78U
3aAU[Re3_,7f#cgI/N?&JT&?J\MBN:9,gca#0NU>O6GHYf59d.7AQ<&E/;U5?@6X
Xg6L7G5[.\a1cBUef6U9DH/PReeY]/CTN84H9CH?/8gdUK+>2>-DB4TUg&_]:S+C
<]_HI:7eIN-g+/g#5aP2TY#QH1-3W7&?;AEg4YJJ<&K;2J4K5F1S^+M.,])3071(
9^.J;G]B_N;14ZQ&URV^8LY<-W8<>Q_0UI\@(VM),[_Ge#5S2?_G8C>L0&@C&Jc_
+2@Q.ZgCf^Z^fK]1_FQX,U#bOL345C3LLFP#e9GS\bW-N<]5S25]O8gYdG4^(3@=
,eM-\^GKL^#f[TgOF<@M3[@FBR^]1X>3><5HPNGbW3&5GC=\TW:YJ8WHXEYBSGW;
/eUGT71:N_HQb1f3KUR4G.-8H;:1@/.#B#?cZ;#,81K)F&R6e,NCbeSb10E#M(1I
DEH#cBU;0#.Ea((MY?^)RcPW>g?>4ISX[HUb#L<d6H(.=4,UBE5Y?8^K/?EGdFTJ
Y_X]dgF^gQ&bZ=aM4[c0&G_@[9Z=S/=S;K[#K,;5>e;bR#5QYB5UfZ^bNa3)2B+E
8EEFcWI48YN].WN8>+H5D:cDJCMNYS_>,d]dC8<GHM?&P7[b>J6#Z<a>F2OS5=B<
(TA+=VTeDaN-NC\-NXP&>=96JG6@ZbO\>8WR/TaL0&1aa@.A?dT98XKWSPE,b:)A
4cOLF::JBZg2S>QZY9#789g&JLH4U=0<\>>F4B-e]SR0<UVWP[6@E4;1]?L2H_<Y
<f\CG>TO_Pd]:2gd_ISdA.H?e=bg]45.B2M)#=Qg?+a).M5TX=<-^aVLJJ^e;.-H
10d=+U[#=0+YgOZPJ-MQ=Ff<deOD[6)TTRg@S?62dVIA4Q5@Q++H&4/1A,EbM]G#
E=bK^d:[Cfg&)B0C]:AW6e9Yf7#0g-?a/5;Ja)GY+2;d\IAH;668,6KJJf0,[(]_
\IPfV8_2F+B51KJMdF7<^MWL#)U#B[HR<N<N6SffT(?)3]^b@^2,We32APS?5;1C
UNUWB#F0,eI#fGfG],QJ@M[]E_?67V)/[4R/18;FQ>[-FQ15=\YITffRF@/HNSa^
YY11MdHLcL?O3(O,R&97IO[99;Q<MK43EJ9097/;O1dD[S&O2+aYR,\[4K<^WA2^
OHb[gT1IfZO>XMCWKWATP,?=a/VQ:Ng.\?:8bY[0XMfCcF<#cT#&d_>#?^PZ0PZe
b1^9bM42,X-JYdb8V(aR7MB\^S_[5Z-A;D?AJ^HIJKJaDBA3JUc;Bf<\d35Kd)?F
Vb_TcbI@.,?-eEO_(;=5.S=X?1,+8]4FR,[5TH]GQ>_9e<_P=Xgf4fF:N=OHa&S.
TAOE#BC#/LRLd9T,b@[K_EZ]<H&.-fcSW7X[Mg.YKg+.<8_)0YCa2@DMUa2UG4AU
PSPbG4)3T&YNAJG[K,BMFT2aF7eAZH:/]/2??X(I>KG+<&0X_RgH)70QeX@6a8E(
gFPN>LCKD@B4gC6B?N]HWNAKKbYCeYX8+b,e,e@EV<WM_QL<<)HAG.PX#dMHK_P[
@J4Q-,81.0MR.K>cG2?IJ[4[=G<\QBDVgW#GW4SK;6D^PTNCfIZ/cd5GW(6A40MG
6gc-G>C/(]PYQDcdbKSG8O0)A&DgWUJcf.RFX=J/0e@\@e;X2g<bYR,#dB]&U8M7
@ZBB\/Y>XFA9_E:8(X]CRfPC9Ib?:@J/CFZD\)Y^;;S:QEOIFR?VMPBRd+TV39H4
)C(B^30Oc>9C(SM8E>WJU[&HIB0g@EFA;99QXFHM[A61BPPSM[(=VI>NPT@97f+-
Y5.DR^8T59Ia3Z?AeTb)IW3,6Q0KS:IV&Lc)P<-X(;#OTfF<F,YdETU;c@M8RJQ3
I^H3#YZ499JG-1F8f)<UIOSga/Yd-+d2Dd;E&F>/a@_)--,)RaG.D\XG1C:.\Y@E
+0FCUN9>&d=>GS6C8b]B9P(&:T.Z\ZU+G,f,G4Q=D8,][RO@W^WIW@#_5J,eRfEG
UN:E5+9=dOL,K0V91)WV>8H+4A,#VME4f;M--(c)LgJ)D\gEI^RP@,5G&O>(]JLd
JI6cQa2VM+b(a,87e@?1FE:@E-I8<aeTQR9Q/G>aCLbcd<4)]KL87O3M@QSYf)VI
:&5:4WU][>)c@MFH;WK^)Y@=a<+MU3(.@7C^THeZ/M3KLed,,<RLIcUPdN9RR1UW
ACf8TNcd?X_]BKGX&4<1HI4(ZUBU&K3V(FgP6bGXFC5ZEWTF99I:g=2MM:M=L__O
/HV70Y.(85(>&bec960(0^gHGI^@R7g[[PQ@4e3f:<KeZR<@^Qb_UR\d=RU:7-QI
HKI+GF.ALBU-c=g0\FdN<4dZNPVD>cVGb5L<Z1P80QJ5V#76Nf(dcAE#ceF]-K<G
)1K=;WIS-Z3F@fPCX<bB_)EDKBUVb+[QMdVNWWH2RRgMc#A(fg@?G\Oe]&VJ126e
<<;W1XUHf(N0JKB6L#6<UX.4BYZ\YAO;89ZQHN1\#LD1Yaf+(SABVJK]+2KL2D9#
G;9F=]&T6:Be@LT,=[7[6SW9X:Z]C2_5-W<SR^J_Y^6[71GWPLD[AV1I<][S_7T0
MY(4J6M_.beI/<92Q;52cf-.Y6eDG()&Ga&W@>4M8[J0Q<0?/IG@_S7Y/S0Z,61G
#2R+3)Pe(aJ<O3QL]\-DbF/CHKdB=Ra:Z.c:_;L6-a5.^SA7X8&a=O@Rc(fD_b=#
3Qe_0#FRX;1Bff#AITCOZO(738)HVUZ1I+(TQ=N4(NA=\c(e5.1U&D4?_\3-&6dF
TTM9]HWV4[2g47TZ4M[cb1S_d4MP-YFUaeQA\4J6H:3=G$
`endprotected


`endif // GUARD_SVT_TRANSACTION_ITER_SV
