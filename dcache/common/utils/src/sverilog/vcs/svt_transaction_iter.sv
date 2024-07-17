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
g-\/Yg/aZ48;T5_PR;c_\e].VO+UG)ZaX-;cHJ-]=<Ud81C)QVQX2(W9]?+4O7))
gVb+B.O0,(XVW(bdK#E7N.fM8A0P-IJ0UYY)\Y2OIY#-1RK81]@1BU_6Z@Hg2\2K
g623#.@+=:SR^0,+e]+<8DMEI]>HH7eX8].ECF9+>.:3\MF#c?;YcSQ7Q&ORCW7J
N]77[-EW-.6<YY+:\agR=Q0[ZWU9TF1T>7SSV<f9(DNW@#L0cYKZ2E&UGe]gT,eQ
211CW4Q6CY01bDeK;7^R>He][_gXf/_0R,bM7DQG(S4HW?=O?fL_\_:.F0EBMIg9
E]C))ZFB8BY&E-VW:f6WMJK=1^/fU0)-@29Q&C9g0Oa^_:FgNgdgDBXLCK#P/@\4
;88<B@.O:eM/393:>aA031A9&I[DN+2Rc>EX=1UcG^U5?bW^O6=T5:H&E6HDL]1J
/^B=<93_=R:B0fY::<L+JJBO-(VaL,W3WcJ_83F_?Y93eK4;8@)&cDfVNR[VB[aL
K<Q?-A)Xd/HO#UU4=BSH#)e.M67]P[<DdQ+WE]TUUPFP^3aN;>]PEDV)<@]=#44;
^0>e1Z/OcB<N:CRRWaQ\O2ZYA252c:fD.>X+e[a#2@JY4B\eR/g.2/8^R_Z>+3c+
<Z-F#HUCQ:gQN/ZC;Q(M,_4=b51JJKfc):#e_Zbd;_6GDXKOUM=UNdDSce#>[#1c
CcM\-39K0b,/IbA^]:a.[:O&OOKg]7_=&dUV&A^PXKM[QNY4O0[U7T\O]fbdT/R5
7^a]8\DPbHL#ME8FB/U8N@HU6+b+4b:RRNLUW]]Xc+,,KNOa,>-A7\YUJefP:g<9
2@:5#MC0O9Z=(KZ?-SC?F>C?6J9?[-30;PIXY7LMZ^6]4P(aNT.SS.P(fbN]g^WQ
0ZYI@,a+g#A-a@3@bT2@D.?\J71g5bc8bQAW0bT6)(_aWd)BC>=H3P#ag^@JOB7Q
XB90RLfTN-,.-0:1+;QW[QTM=L^+Yd.aSAQ+?MdMH)\5(B;Zb5IWTX[dUF&KX=Z,
PY,6TDVeagD.SP1bdYS7<12M9_+N65;J:VFVf9E/+bX41<6+&^L.5dQ]COWVR.dg
b#g&62,0g?(f5L\7IC2D?^VDbBRB2@c(&f\Ve=bCPJ,C>.c3H@@#5^:GB:3R846[
BPIB(GK\]32E=(+f27[K5L^5_#+L/Ofa_@>=H-?Y)1-B@.VRDF._D.-#e:J)6<gY
gNNf1Fb,Y^Y(:;P#eINRO/ae8EB>0.;^-F4]6+F^/BMa#CK_>XARTUNa4YfS3N9X
381d7LT4a16cT=1\T][+=#\ASDL)V)gD0SBZgYUUD@Cg(R1=Rb1KIdD1T?_FF.?7
A\+da^?IS]NPLP=+Y8H7I.PZ)Y9&.Sb8L2f8<?IP:WF+?:IH@[WTUgSXUg[XYfU@
,-[[bKQdI92fbL^-=HYfc5[KXL>(+S^g3D^3eI#M/+AQ;BPfAFT+K-+2HeX.O5V,
E=KeE>GB;g#\B0S,2;US297]3+8EH+4Pc/(aDB7,S]C#39A8/fM4M-:6XLU>-;VQ
>WREfOLMQ>Z+,B;/DY>)GbB8(]3_PaJ&a;=c7?WP\3BSJ9NEHK#;HN]aOc7]U841
;K3EH0gF[=e&>]UIfc7BY_/4\8IM@/+<+KMKPBfINa;>/ZaU:Ndc&TMLG1YOTMT9
E3/;g\5S&W@V)S5+>f:<bX4(T8-c7P:gIYZ1)e1]e4IeCFc[-NRI<bdWaN,IX.UX
UXQ[\[+)J-U1Z3V_VaI7TF[QD2[J\+[-4b?gcDMWCJOP/5P^D51NVB1QD\&fDR7Q
VMKJ0P3\]b,b5QYE?BW(HNP3[fI[\3=(CM[E>\AZ4E9:QWN8NL;MJCfd8baJGTQf
b7Df(V\BAAVVa92g1aCH,W?QUC/[][HXAf5_b7LS\dZP/CYJD^3.]UV=Y3_HL\T^
QF<.^a@CS\?1<c5gb&T[J_g/1>JZ-=T&JgB@XW/c1TFfN,XeM<VM[ZQb:Y2#:CI2
_6RVf_>9,X>gWO+.(^+Q_\SN1?STfVT/AF41,P;\D>UQ)].fKN^2&I(0@S9^Yf2J
LP&N,JOGg8<JN&WZ1O<JZe0Y[I-]8@Z,g2N>g@Dd5TgIM25+;L]D(47J>&@K1.9B
?V&F&&<EUF5C,f,\XR5&#@K4<C5^7fN,VD_XN#@6W3FMM4J0B2/4L\E9D8EVRLD6
T/+]<5:[.V#aQYMB^cX,Cf37]&#YQ(d)<UaV_Z^Y34HA_VY=6^?EW\NO8VGU<,UE
:A.P3,@\QNB)3/(E[L+GQ@-4a_L4[<1D>C;SRTa0OVUI8/^W9[ARVe<Q4&[aF_0A
Z>Z,ESMXX,a(X-NRIK_P,]V>M-B_^ZC_PfdJ.<,=.gK_(-49PXZ8c#H/<=+6SB[0
_20Jg3Gae._]2L=WU?2bLbDfZcK.UPCOa89+3(d<@LfFK.APP0V(T>]3e_gL,f3D
37VS.UYG.XfGXUPW58JUf<GIg^a;1>#4,/;1)C&,I7=CWO-+X\-d(K6a;K,b]8=Y
<G.&WYQbJY>dE8JGQ[@Q&,CX3VdVP+0;&W@N(BV5NNcP(O&.0Tg+e_GD/YfR:Wb/
4O<:e?\-RA\0MG9F3?(OIB_MB^cMUO1Jc7@8-0,LdId3IJSLRf0HU\b(G7VJ2Ab?
eQ(\+6\9)W^_R8(<F)0g&_:9KaK]094E5:=accI.gZ&.@3J=-X;.43bfRN35N^dE
+cPUCd,dSFTCL:I14b-HgYUG3.W.?1G]TR4N[@d/B3cS1e[J)35TCE=-:dIL[-Z?
N]1AJIbUX6:adRF@^?=E4bCLffgP)aMKJ7EL,cRM<@7?OaS@2_3Z(eHT<?Z7BW]7
2M[ZH3JeI7SCT:O1&?E>NLL>)H]K=.K>@HJTKbV__OIG5/NLB]B213_cP_17I7@1
LS.KI3D_KI#V#PK?^FA9BCA36T[VBgPEWW)4>/Hba(J+EUQD8c]fOC2]9c>>Q&TB
62Ze2O8UWSBLbZ=X9T:D:7E<>d6#9FX.f#gYG?VO-fGK;^4fSTdL7HeW?APL[cJ-
#-S=77M+3@^U]RMQMA#/GK_M,e1Q:+2^@aPM37f=Q\3=6J@QCHbR-\0P7b-6#.b;
#-J-c#NG680c:Ae<gX-@bIgNP,?d.4HOPf3dX6][)F59Sf4YF,(I&@T+0[YgQY8C
LX9::7/Tf(L,5II8MFXA8E+gJ\(FX>5YU0XD@6e&bWeJW?aW5CYFY4f9PV=NfB?P
Yg]=5ZbU07NQ+@a&?YS_1Ga>;ZB4N.MOJYNDD4ZG0d5/D?4,MSV1gZ].eeb([(eY
2>;&f_X>bU)eJ-=H?_/Y8=FW?58;WHfDFW#6;.W-^370A2R^#@PV8I]BZCL][N<K
?++Z7+51L=d>a292F]IG^VE-;5M[Ag5HMCQ@_\R<a:EDbC/JPQ].eNV0HWDE9X;&
UKZ?DO+c;fGLF6fQ&.S\&^AD6HU,0K+g(NcBN._@>@D_556FWO^fS#0[)81&?1c;
&HOPY4[A(3#6_/_MD:=V9R\0aT+[S,>JUBK=EE61UH#<fRWg0>H\cMY,T7#g4c[F
aJ6eJSWf7?g,NA9>Hc[e>,1J/7RKVY2HYLT5e50\)WHQF7Y0/:H^,]S4>N2aVYc=
S2a,99J_-3A\0e1E/BF\_=Q-F=@;Y-XGRQb=d[A/Z-CLW[RQ;>HRX:GPEV,F0UBF
KGR-/KCJ#:]V[dWFa;aT>;?UKPZ_W5QK@+2]MOKL2VdUW,0G2cUB=gAM2A+NV0_a
OL)g(PSeVY&7B_4PO(7:G)VJDWFI^a#RY3#06F2&cZ&2eTU]9S++;IfR:b<d=<N0
3^8PR&(JO\:)G)bZ^;:1eR20g[H@F_&RCQ=.#GY.eF6gX&#@7CJU[,80,QEQQ+VK
ZBg+,</;91O]:]Q<cLT])B-9R1P(/,+8:;J:N&6GCfB9Q<^()>^dKYNORAF9R5&4
=d,&VFc>QD[>)Q+P&^U>605Q@,Ie)S1J0KT]b@MTZ2.8ED+7N:MC,gMYd<GZMRMR
=)P6;PQTBf8OQNgZR4>C90O2:B3T[N-8EcVN3U/_P(-B<TNU.CTD>B72XeXTL+Z[
B]_PVDWEUOa([EX3FTB_?3gdL[:;4R]-W#\.P_X8\/R#G9?IPM([cf+YLb/a6S#T
<175)+3_BIB(9.3-:eXUH/PN_-.36(&?;(JY;\fD)DRL3@?Y3TbAe,aH(61.U..L
2J_Gd=b;J>JEBZ)XH=B;YHN]JUGe5HWYW#^2>7&MQg:R,5]E(.,S\(HFA+TL1VFY
_.-0,[JaUgDGHb?OW^H#^D(J]-9<]eg(;NSP/+C4[c?3YL(D6deb2#AMWR]6d\c7
<+?a(N9(FPBLEZf.5>W>9/.,\cXJ90KKdM,W,[,>AJ9HA,dagO:KT=[bXZ],)Z]A
#<&ZL_=7K_=_WNDBX(Q3N]Ac:=L=?G5^L[IR,;5M54_ca,D4\A.4@ObC.+bI;<SG
1B^DH4-Bgg9g[FEU33RV?Uc_A9S&P?bCMP6d??B2=S.g+5L_D>c/McK[:G3LN]L(
WRU2PQda[bdd4=</G+(>H]050PTIK0e,2UV]KELDP5JS2>.6P[eO33672JOK)a])
D1g[7T<Gc5]L9eOB.S^^cTTN)CZ^;)dM27>JbW+f0b)73Ra0c63X9=a+=U6P3I-3
WZ&GVZ3,J4B[e_1+D3VY,Xg4#A4gcIad6K#,PX38A,5Ad^D\:+^f2FP-J7FP:^=F
?:BaM\A_[2MZP,5F4XHJ)8B]<&L+B3Ce2T5?@BIVZJMI]GC6)e:\I/LQb#EI.67(
):/1O;MG#=gYQ<&Q((F7]RG\)a,:)N[cc@#X?9\(=,5H<R3>&/+EFc[dJ)eW<J6&
@N#RG5V?0Q5MQ?,P?]-_1:[KL9VWJ(P0gN]]V3]6.@)D+0R7AM9IG@2IXHEIE[[C
@ONDLdF#SaSCL4T_9B(S/8QFW(]UHT2=_QA^9PUZNdT0\f0/&E+Y8Q:WOIeF07SJ
Va3M_+E&bWX?bCRW8/N,K++,56167/D@MLP^0A@<VG(d4\ace?4N;18V=Q5R1\f_
7L-++J8O34b_0FVJO>R&-S)N?cX\TLFg6K-6_T&eHdafW)Qe(cT&\06[/Zf)PA-[
HggLB),2:+O1[@U]BJJK4#+Df,28g(MAfRW,&TQfF2UFMKJXf)[eYf7?38/;QV=R
Z6I5[1XMJIUWg=0;#8e+RS\K>KG(Y#HD)Hg3[O:dVMPE]<0.(Q0C>-X:P:BJ384D
G2MRBb4MD6MA#].]4BW8aG7b91R-BR0B\QS3e4V\fP1TXF)(4e>)aTVRDff9aNI;
\YT7L>J4F/Ja5HN6\[.=M.Xb,(Mg),\^<4Q[NLeI(dC>f=9F3GM(PdgEVB+=_O4D
],0</fc2X6&&41@VX(&WPQ:07g(O)_V.TZC+Og.C[C&;Y\W6;FVH&HU=Z11e97-Z
dJ.I;ZPRTTN8>_)1B.-?S)^R=T:JAdOD0L@,[0A2.U7B>TPY@Z^f(37VRLFE4BU.
:\#B,FKT8a#-;DXRK8_e&Le85=LE-8cgAU=#&D=9VOP3YC_[3:)(g@C65L6,Q.;@
9+6I0[:WW2<KMT4+UE8?JYO&cJceY?F3_LES6XB8>+SYU\\8=Dg6AE4QNSIbBY,+
U&E:3ED/@^V:fOdBLH[T3_Hb2Y42F@C0HVZ2gKQ\.>a145VC^g]7?2,30U+GgYe-
AH@VPc:J<TNE6_CZ3f/M>D/=9a\3XfR3J->I^H07;S+FYHAX:46,D2dN_a56TCEc
-&PF3fE#@);fB?L7>aP8G.Ef_MJA^2LXQU;bEc-A>9+R0@d_FdC4<+6HV&F\UF&1
<<Z,K\FWc\0F@3A&aZS^(gba#0/?BKW=cD;2YE.\I?<^(79:JdMR\?VF0<=4ER@D
5H7E8)S2@7_H<HFES;Z5E9<[ea/aQV(CL&]7)fd9+<0eN=W_&#[C8_2/&dPK(CFG
4S1e1;SEfZ5?C8P)70/:B^M_2XA)0A=]-@a#J6Kc[8?A1)H[CFO+/)Kg>+UL>M+=
N[33Wfe#VAgc0I5;X=R:4gg6P2a]bA#dNP#bbE#PU+X/AOb+P]526DTcLI<AJW.2
a?IZ2NN?A_>;(aT=0Q3\^>)eVIP7cC>;G3c#b[]a5=NK=[8LY[.:?7)SfScAB@G4
,BU&WP.JG?U8ZM]dBgF0/YI<?S:I/MP#c+P>58FFSWZ;099PU;SHbO8A_QNX0L:a
TT)N<\c;gf@^VEc@KfO(f.)CK&I/D,8dQXF0Y<_#G/_B,E6/>L23eA:\GF(^#F6K
SEc[S)+5aS;ea=DXW9LVQ9H9DS.[/>R+WZ4)\PYf\D,Y5FH^N(H-97^N[_3g?eWD
X2FGX>0<0Vd\_SQ;65-eOWH>H<De#f2bVJ@:N#AIE.P8-L:3/MO/GdA/bDXQ+I^T
e2-1):V323YV#SS+B?H6DfQQ;gBT8@g\]XYM7Ga?=D,BFF=M^-(9Ag_(-80[NCcW
W0/FB1V8Y><IeVF3:Y>CEF&/#3YTY)C>/_[^dZ4-V8J7]9?LL69(6\g&:,[Q:MX&
47SW_4JPBb4SC#7_V4LF??>d3]?>KI2/N1S7]fgYTS>DA0IIS\,?HW:0/1MB^L>c
WDKQX.J-V;YMA0[>QYg-e=^-DNX&5&I9U;\bU2.T\;)QRY3d2K6EC#Tf;CL0eW3)
#N;91+DS8]</]X_N+aaK6-bg5>4F:eAU,Q5P4,^d5:dHC?S&II]I&\4,3YHC+J]9
)A4V2(=bcM<U#)TJ^UZA^KTH#?PgBF?:ed)@:PIaBT;^X\FXG<Ad(=4V3-OffU^W
YNU388CQdM>K_TK(ZNQ&Qa64<(Y]eWIVa9_bX@6><3#1G8\Z_5)8?4/?/f^3\6I_
NIS.,dfFBYZSX24^-0J?e<F/+][QL-GgBF36?W=4\FJJ,[889ZaWB:7=:0]c(d,O
BHc^\dLGHb6Wg[c)-QQGGIc1QLY_IT3X]?3G03=P&Rgbc9YD,74\4KRVK+JWNb+f
WegOUg^CHT#73K^)A64bW?(_IfCeIaA7LB10FTNDRb]ZMfc#RXD>[5PGF@&.]JJb
/#T)P,O=&ZUcFL&c9Mc@Q7XRA,2[)5XcI9IJ^ZgBagR([\7c)@24UUc,S&\\<0G-
2.:0F+aCW74=W]WUEbd6>PNeB+K9BOfZ#T:+\22/+bYZWCFY87?PJ#NG^CO^,G0g
GH/2+=^@W-KO2QJWCITLbD.(E8F=R:VKOI6R8<4[)M2F/V/L(;c35RLfQCg@OX,T
SG-bW97V@/gXd5.[aYX&I:UGB(4SaX]N>J,4TS]2OAY&BIP:/>0RF/d(V<T,WE)K
.S;>8:P+?4LTNL:B,CLB]+SRLcM[Kd2-WL/\d:[U2Q1-5TdJ.;F?[IJbAHC@QaR>
RL#U/Tb^PNJI>@\J5LaR^4G\7?ZUB)1dK65)c6]\QgV1K-<Ue;:ORZT]D-\Z)B6:
1b/->6J,SS-N4G.,<?-D:IaRJ.VeV#]3gM/g\9[aI;b=R[^cR6D)<Cd2T9;X:O)c
=2RDGb/5Z-,^5bC#C8(ZHU>/2KUFK0aJ+,B7[JZ\0ZGC^KGg-RJB,F[c-E^-WPS_
CW)]KEAe.6B^:X1/(eK,_8Q(UWc1II<c,40>cI2Y9HDIR@RRZYT3\6NcRB+]E8bF
9E-/:X+0YbB;^Ed7E:Mc:>#f1c)H7Dc/_D7?BVK)=fW\bEZGbW3YTZb?E2@WJ4O4
Y6/PDcFTS>MF>E(865Ugb2W7+<Y.8?F1UNO5HJ\A6=S-<OSIde4:KLEHDU#F0HA&
RGQf\c-?U+cG0LCR@;b0[/ZQaM&2]bSe0TP@a2N9d()Ff7,b?2XO.P7BPO=N&@WW
F9E8.Ce\AQ?E]0IIMf-J<)PQYbO&]_?-:>3M3^)f?[&-@:DfYa7&3XK;aX[1/N1Z
Cd&N_Ze-^N0e&c1d;dG4)d?_&27O16.AeFAG6b9&fOV[L(-8D-LP:8-cOEM10GbZ
]]cfNV4M>215#TL[.79WRSG;P..gRZ-H]>Y)6#>.T)&JW_fN8JUR22J#F<IgVg6&
7XdL8Z[@]JQ>PQDQ0FLf;f-:2W)d=2F:]841UC^B@TN<UD>Q.^G]\E&Q(8_Y0Z]9
N\;R40/ATA+_83[Hc-G+bEZQ+B.Pb.)7S)Q?WL]:B/\-bC7?3T7b)8R(3JET;6WB
Q<Zb]@>?#V-EWP804G\a;GY2:-YZNe,95QW@T2MA/@DRC8EF,Y=N(=CYHdW<1?XS
]@HK)P0E&LHcDT\5\>5M]O5YEUUfa9F1bP.-f.[6BaGd&UGOBSVFS/_G7AZ=:S)H
(H)Q@H#TG)H]d5H9bI+bNKdXBD@8XPGO]A2&f7:BQGDg5Ead.HA2W;6YNTJT3b(K
HN\TQK=]^((E5bJN78c?K9A&a>EJ3WaM/+5\a;A\dP4&G/<IL=bF#R#<6;+=:BB4
/V(D<G1HIfUY4(4UV9bIg32GaeK-.ZB#JfL4cFNbYO_.(#<YDUI,D>]U&ROd=Q0^
BQ1W+e2NGBc[W@.XLW12<WLf6)[A=26ODQ^)W#1Y10F],c/e)DY#R([d[B;AW3f6
=;4)4K+7Z1+]88/dLF.AX?;&&aUGb6ZEN_DG2,GJULQ7.YES&E?QWV=_0X:/e;<-
BLLO#W&Hb_g.KL/Q[3CEg+#c7)O+dO6U&Ve9\Z+K>?IKCTN9f&F+5HR9)D8CW2C3
DUL(<8Tc:7=X/?/7)aPUV6.WaS8dGFSCXC&H^ORObW93?eFe[@._AN::45df,Qgd
_ZgP;8#[&O8-&.+gYP2HVg6Lc.\GF^bE[7eR+C(S5XYONCAQ]N2LZ842NL4Fbf.G
bWFEY^ROUAK?R2)ZGdBQ^^Bb3#__VA=>CBMIED[:/H1[<DYOaH2]c1V_#Ld0U5_U
3<K+4G4U0&#(YA6W[QO3G5Zf80Od8^/&[5R0ATJV6ZS0dRX^7@;RXB<:QG<&\YOR
98e6TX[J;HgFBO=3&4H\BL<<G8dUYQM?ZH;OH@;M2.IQ[F24.W]Z-VNZdDD,^AN<
9J4TCUQ:_Z6Ncb1[g<CQBIIf0_9cQg\;D8bGI=W0LN@Hd(Y^19:J&^&<dUNEZXbM
/BHd5f3L=LfB-;-L5^fdbG39bC1&B@WH#fRebbc(8Z5FSDLG===&Y:+1ZcX<bg]5
[.25S8-J:M^L]X87FQ]f(WHPb^XbT7J?/0MJaOHVgR(S^.^G57+ZI^W]?NPYZ[K6
CT,U9CH-+fR8Y7SE]46[bZXGMb=^XK;+RCE(TB+6V\Cc?EI4c:H1J2MC7=RGILRX
F[=.g<:ee8T&#07C2?2N6)P3A/3;,K,>=]55cU\GVK7_0U^&b7-8fY)=<@^2(S(J
MXP79P9Y0<=Y)4(d&2+68?(b7.D&E/(T6XT775#(M?-=T=\>&[]6a.]cR6Q6P5KS
C5a+?Q#52c^5CJOGI5,<0NKL,MO>_[:-^g2>A&@[;OYaa/)7b;_YA(V;8NB]JL.M
ZR5@:E0g&9@<L^Ue0PBKCDdS\D4C>T[;V/](Y(2J?[,G&4@2U7-+b#\^(LP;[G48
__\RD@0M&F,bVDZXeN223=dXMSN4b30D3-3d#-&SC&fL?#0?bc@^ZS@NVcZMCK>=
<dF8O5/Z6:SOaQ7-K>Ae.W,4(ZSVG_)51QJY7AZW6EM.;@\H-KCBfJE+K1c@91.I
L(P(?M8V:U;ASdGe,O/c\L][^M@K3L@(#V@#EVWZM:Q5^?,_P\GGFL+PP1(ddg.=
9U_75ZW8,Y<VYR<I-9E6D2PL4bYdXBAfFS<3++LU?fd6]XY8\KE[dMXZSP/#Z5QT
C?9IK0;.&IE)&7aL43If&Q-;gJ6=B+A:U(7R/NXR_BC\[_8IKT2KEP9HaK#@P=Sg
6G613XM(#gA2AXI?DJS+=P&U42<]1M06;==(DLbVe6&EUedAV<ML4P@3U#ZOgRF.
+Z[aEZTQe/O#O1F2Ga3eA3,0Y&M9B[M[NcL+L\U)G2?:.LD)2GWCCe-Og<K./W>]
L-9c:@HOZN924VU6X)4@0?UCH_-C)5f#816S,+IQLY#.@2Ha>@MZVD+ZV(^e-UI1
B:G&(HBN3TaFeOU9/W(,9Nf3I619(0--F^.-1XNZ<KG8,+OdX.M.;e>B_Cf=?TaA
IE_I_<Ra,M>DLQf=LIAbd#?5A3Y4<24_gVYL^@SK-aN[K]gaR<>#204T<;9?)[)C
aZWY^(gL_gZeeFB_@.9J#ID/f^M?9d&=1?DU-LJ3Rd95^Ob)BKSSDAU/:g9XUe_]
K9OOK9c<=&Ke(\[M+]AWM=PP#>FV(PcCME7.@^#8+.Q8bOd1IT0PZ8@,H,KeRAGN
3ga3@A0eC-Z:YGW#LO;/_dZ&#ESDY&>>YCY<-c,#Td4[^NZ.a(<PfaK@&73g)N_W
3Ibd-dTcIG?[[4O9=35Z(#=2^=ed^KX_-]efM86b#+;\IF56=0YCc7)Q,61P5_P5
,82=&.WXaTCAGEB9f:MAFR>SN7)d>d-B#=T\YN#C6M6.:?78UV_61eXdA9X)LWY0
R40Aa-UOeaeGCa0TF:FA@,gB,bUf:&W)7\O5P]4YW8@;gCG929^6,YedTa\(ZLEf
J@LH9S5<cFU/a:K073AG\Fc#fb?L&c]e/[d2e\B?VeJO<KWf=AK&6S:0U)JI:=;D
L?7?_^?A+:DJ?.HZA.bW66&?_:-O/LZQSAb8H](X8EYdFF;b1-cBR69Ed,_aHH0/
:54-NJ_b]B(_4fW@-BJ)KD(:OTFd+^ES_[H<<?U&3-#cR#4eBA\73:aSYYPTOLK?
ZL>)W)E5ZH\]&b^RT(SE^^+(]&F83H,W\5VZQ=78VR563S<]T^CV0C[=^)C&&-/9
?@/2M(UI<ON:WR9JKJ@Xd0/(0bQ=c[.5IMVE(L)DaAE.#Tb;C@,:5^0B\ZHXDFLI
^VL]T]L78.V^>.14G^\\9-0&e_W;]_#]+M<GS3fLY)bKP=&T\_8[eGS5,\@U<\f^
f>6aY9F[,OfdGO5AU;CgaeJ3ICI37&X=.W6/YSR+V)HgU.cSFY1B8d&3e?RLaHDW
b.LK_@I=:&]IN(-67&[YFT:dUA>PE/W9V)N3UaD(]S:eB1F51+SXM474L^6XN>d2
cIL-5&Jf,2-@Z7R+?bUP[_L)8-:HeabY.X6TU#M)cTGJL8;RDRN6<\?H1_482?b(
38:_7VNP&Rc#V6C8TR;GCcYF:L3(A9acN-8d+WGBQ8AH&^c5MO8R#@,(UFK2&Cd(
.3E11I_fE]#?HXQ6.[Hf9P5A0,X/8,OCB(VJYaHDXSRF),U-\g1YL,=PMaK7[827
e3;,YH>f=TZY#-N)Z8H.<aO@(+&/g=1fF6SJO5AQ9(ba[CJM4FJ(Y@/_P8[QA.-:
&dQa3:>OUXg/#;bJD=cMD1d\UJG,W.#::_JZ,fg+<HTY:^19+RFR)]BcW81G.4gI
5GG1e[&T-UcXT>R/YW/UMRH.&;,:&1c2&IW&Saa#?LP8ab@PLCefZI5[23]X_b-a
[4E3OWL3@.J/QWAD=D7c&8d>3MTD>^P)W36OAON[Ab7#@1B1\ag#GP@4>.VNc\(=
VG+0Hgf:/d0ZJJbD<6)3D[-RUc65,?+3;,,QAg?JY73T2B?eACABN(;aZJ?D&2a/
;X38D>eZ=R:GHaN<IGOG.B_)9\,P7W2g;#RAGNG6#.XN.MF#PF5]Z]cMMV#20Bc>
=]daZ1DR0.FI-;OfdEAd[>bg.N\^aOWgU8M5K)I<MRO<:dOMK#6;63f/X;F+QR)M
LA4@A;<)Wg]-d9@aDDN;]ab\QeR/c6B?@fORNdWWL;##[c:O/7Hc,NH]T-+f0WSY
d]_f_(Ud655[P1FZdO]ADeZM1Le;A.88b+AH&=;efAP3cB0gZU8CAY+D1Y(V6;P(
OLZ.#^&B]TM5eP_DRSf.:(9)WfT\4XG2NR.Oc;]4#0\F]N6b>D72g79/H6#1,<R?
IY=<8d[2W;-1@?2)B:_F0/8^^4)[EQ8?aeO\CMYaB\FP4eR3<gJX/VPI8TVaHYS0
MHb)]AP+WUI.V/\8[D-TEZ])_&<9c5B9Xb#&E9W)TfDEb_#LAfBO8?N8=ZK&2<=a
d#/PCb5e59Nbe7K+\5Y-;;S\7+aI1^8JU>YY3K)3Oa/8=QK(bgTMf?aYLIePcd5d
P_CL5P@GT]Vea5(B9W6U8J3C__DIB^P8AE6QZb+\BG3FZ.3dG(E9#d7?CP#3A&5U
2XLO2(^,J7ZISD+aHaI79]K+,Y\8N)eW=1-e-/UfDb<[-eJ6@]2:TcUA/\B:4eJ[
QSA;02YQc11ZE:M-->L94f_@SN#a6R=9=g8bL@V:<[MVa&0<G@2DV4R45+?_f)CR
1WGKc]=e(#<OeEcV0ZZ(&g5e<bNCfZIBEHa(6EeJ[UaY]MSFU7M.Ca(K=^6VN<[R
QCJ9#>:-5B7#NJ^(FPeeOaNf@;SI&=G8_QG2]E9_@>Y.]L>B=3;\BSfN,-JS9K63
e^eG+=;UR&<a\ZTTK3VCRYA?T6LHIRgb?_>>0TfdU+0?IX2SK<VI,4SF;;KHL=(A
F2ES:F/aX8T4.c^0#W(3JRS\d?,H#OG]bbE6Z?9H>DC#@6GW4XdTAg/GYC(R.beE
3EN[Kb6AW>_LR0RVTPT7#0aSAANR(P3/ae@)Q<a//CXeaX4VY-=/1fJ.99)<\&fd
=X8QEL7Q&N&\<]485Q6aIU35JB?R?Y)fMNg:=[4Zd=^eN/UAY0Qb7+&TeS&-eR;F
N\S@H8gAH,/RCccefd_ZK6L0N.&[fCWdcKY^9N28e7E3&5Z#1KB4@1?\C_0;8?V>
f^:J>V]:IX6G[MCX]J:U=:6L-7HRY_@_,.88)g&JU8<CJAFGM)CHMMA3ARD:/V@8
0EKV@.M/7K3DdbVXSD8\>2Td>G4[&>C+;]0(b.&HJP6OJR--D_D[:<eQG-R)\-2d
A+WF^>IQXIeJO(IXMbNeQVRKQE=bZTg?;2Y/LT]<2H)2^6cMR:7I]4_JdU<D,g<a
KH1\/U-&a&0-9SUeJ=:E3>GCPG3TXR-(e)Q/F^]^dZ-Vc0dAaCIHf=dF2fb9<0U;
M^5eRW3N0g?.Gg07/.S[WJ2Wa2.fN?)6@CG)5B5[G@A-1XSBeR@KN?)PYedKQ>/E
A@R_:WMDDeIWbL6I)6A84N2_)(GbdZNRK&XF5XgeE,D4-a2^gMJ+(Y/@5U=\(+=)
\&#]E7@H:1WN-30>ZJ[6\a1-/KZ:TSJF<FY@++H8=1Vf&GE&6N;6^UG@C)Y>c9Q9
R9:9JBV:\;1/8.5Q8#dH,a\=TCW8K/)8G_H0]Te1aOe9c:MfE-(@Agd.aRVOJH0V
;W6b_9I^DVc890KG15)#eCYA2/R&O#M^g5aCW/=d,A4g51=5-5,,3=V[9FOUNDAW
E8B,JK,@^XDe;#^=D-.d44ZFaE^\dDTDL#L1ZNbAbHNRQ97UbJ;f2J.-R-))_^gB
)Z8ecDK?X=LfOO=1]dWTfScf^5FTD1N>IMK(R#Yg-N7BBD,6@e2S#37NP(I<bL^e
7SI#<YQ\49&CJ)ZB&;WR(>P&XD8GP1SBZ=7E1-]d38]15QZ(+B71TO?^>cd\_5]K
f2.B\,:M;cAV(5fJB<V7RLI21WX)G+I23NSG&K\/cV6(\KD(KVSU/OI7b=5Ib+I.
.@S.69R[JBG,LU9#Ic.TD(>DLGcV-M_TE,QVL[>H?P-E.S6.#C2BZ7[CU^-gTJ]9
HB4PHE9IU]4LOYG_RFKM2Ka<<JE0.]H_/<2I48S=e)FGTM-HG7/HO\RNM5XWQA.X
PFQ/:e;KM9\R?Q(-J:dNVO77202WP:B&e/[Z-9A(2=\H)&7BDfQ<(.=2XB<6;3OR
7[ELe)AM4;B4eFd279g?K:Q800GQ5g7I5<.#FX20HNSPAb/=g700<N/]SFd5(S0W
=FJfK61EdB4VM==a3f4L&7&#Gg)&C)-_=000VIOcLR<#LT=7,D3fS_Yb2X9P?AP;
]?T87YO&,.ZVO0,1Z7RB26\@eY8A=Y<YbU3G6G#\HJa-).\+UeCMIbRgT.A46G1,
&JCef4Tf>H;W#WaSBD[g5..^L/&JXNR&<_g3@T[VFY>/B)e&bJ<d36TUNYJ4^<&Z
bb.EY9BM=;W1CWU?EHb.=4d67&ZVI;PC&[9,SGY?;VIaP5B@R<=K:WcYQ<C0>2<]
dRe2A4?_QZfKaQT\Z<R+NL\8WKC\)8+LfIS(.68D55+:-ZII?0;ELLV^2^eXS8JE
fCHL5Yg:UBLJB]((IR4@S>a93RaJbO;)E<.Z;gXU5@JU8(F/:GDEDCBXK<cC<=3^
2-=K]&gJ=0W_8_&J7L&[.K14#I#bd6J9>_1DfLdL:;@F^Ne9N.e271<_9?f<::KR
8F,NY\&=_^+(2@=/F3A(3)1Ka?RR:0>;;^FP=S&3BG2FJP=2/N_PZbc0C/C1(dF4
0SELJ]QK9ZA\^1YR>f0<5_<cHG8b5(A.K3fD@A1/2fYFG$
`endprotected


`endif // GUARD_SVT_TRANSACTION_ITER_SV
