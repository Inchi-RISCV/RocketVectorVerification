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

`ifndef GUARD_SVT_DATA_ITER_SV
`define GUARD_SVT_DATA_ITER_SV

`ifdef SVT_VMM_TECHNOLOGY
 `define SVT_DATA_ITER_TYPE svt_data_iter
`else
 `define SVT_DATA_ITER_TYPE svt_sequence_item_base_iter
`endif

typedef class `SVT_DATA_TYPE;
typedef class `SVT_DATA_ITER_TYPE;

// =============================================================================
/**
 * Virtual base class which defines the iterator interface for iterating over
 * data collectoins.
 */
virtual class `SVT_DATA_ITER_TYPE;

  // ****************************************************************************
  // GeneralTypes
  // ****************************************************************************

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Internal Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Log used by this class. */
  vmm_log log;
`else
  /** Reporter used by this class. */
  `SVT_XVM(report_object) reporter;
`endif

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the `SVT_DATA_ITER_TYPE class.
   */
`ifdef SVT_VMM_TECHNOLOGY
  extern function new(vmm_log log);
`else
  extern function new(`SVT_XVM(report_object) reporter);
`endif

  // ---------------------------------------------------------------------------
  /** Check and load verbosity */
  `SVT_UVM_FGP_LOCK
  extern function void svt_check_and_load_verbosity();

  // ---------------------------------------------------------------------------
  /** Reset the iterator. */
  virtual function void reset();
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * Allocate a new instance of the iterator, setting it up to iterate on the
   * same object in the same fashion. This should be used to create a duplicate
   * iterator on the same object, in the 'reset' position. The copy() method
   * should be used to get a duplicate iterator setup at the exact same iterator
   * position.
   */
  virtual function `SVT_DATA_ITER_TYPE allocate();
    allocate = null;
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * Copy the iterator, putting the new iterator at the same position. The
   * default implementation uses the 'get_data()' method on the original
   * iterator along with the 'find()' method on the new iterator to align
   * the two iterators. As such it could be a costly operation. This may,
   * however, be the only reasonable option for some iterators.
   */
  extern virtual function `SVT_DATA_ITER_TYPE copy();

  // ---------------------------------------------------------------------------
  /** Move to the first element in the collection. */
  virtual function bit first();
    first = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /** Evaluate whether the iterator is positioned on an element. */
  virtual function bit is_ok();
    is_ok = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /** Move to the next element. */
  virtual function bit next();
    next = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * Move to the next element, but only if there is a next element. If no next
   * element exists (e.g., because the iterator is already on the last element)
   * then the iterator will wait here until a new element is placed at the end
   * of the list. The default implementation generates a fatal error as some
   * iterators may not implement this method.
   */
  extern virtual task wait_for_next();

  // ---------------------------------------------------------------------------
  /** Move to the last element. */
  virtual function bit last();
    last = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /** Move to the previous element. */
  virtual function bit prev();
    prev = 0;
  endfunction

  // ---------------------------------------------------------------------------
  /**
   * Move to the previous element, but only if there is a previous element. If no
   * previous element exists (e.g., because the iterator is already on the first
   * element)  then the iterator will wait here until a new element is placed at
   * the front of the list. The default implementation generates a fatal error as
   * some iterators may not implement this method.
   */
  extern virtual task wait_for_prev();

  // ---------------------------------------------------------------------------
  /**
   * Get the number of elements. The default implementation does a full scan
   * in order to get the overall length. As such it could be a costly operation.
   * This may, however, be the only reasonable option for some iterators.
   */
  extern virtual function int length();

  // ---------------------------------------------------------------------------
  /**
   * Get the current postion within the overall length. The default implementation
   * scans from the start to the current position in order to calculate the
   * position. As such it could be a costly operation. This may, however, be the
   * only reasonable option for some iterators.
   */
  extern virtual function int pos();

  // ---------------------------------------------------------------------------
  /**
   * Move the iterator forward (using 'next') or backward (using 'prev') to find
   * the indicated data object. If it moves to the end without finding the
   * data object then the iterator is left in the invalid state.
   *
   * @param data The data to move to.
   *
   * @param find_forward If set to 0 uses prev to find the data object. If set
   * to 1 uses next to find the data object.
   *
   * @return Indicates success (1) or failure (0) of the find.
   */
  extern virtual function bit find(`SVT_DATA_TYPE data, bit find_forward = 1);

  // ---------------------------------------------------------------------------
  /** Access the `SVT_DATA_TYPE object at the current position. */
  virtual function `SVT_DATA_TYPE get_data();
    get_data = null;
  endfunction

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

`ifndef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /** Returns this class' name as a string. */
  extern virtual function string get_type_name();
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
EI(7fKaM45N\c[M3d=87@bI<..fU-J=+N-416/,K@GOaNCaY5BSX/(;DBBPTYPJ6
:((PG<VXL5YRGd<\AZ;ULJRbgY8PM)AAU=U_FO#T,8bU=2S<VXY_]-&D:CHWW]9G
e7;+3HLG.SY,@Q7N+8]<1LA>PK:)aK_.Y1GIFK+947>,L\Ve&G]91;&.(4KZK_=b
-[K>#/YT2[M96TJGgAI-C+7CZ^;37g;G9)^526TETAS[;.@JRDZgJE=82OdHHEHN
/eIaea)4J)I&\51&\9FN#9+]N8IIF-(CdcE\X_/J#(QdB-<f\9LI15>V#f3GW=4]
Lf[-IQ=4J/6;F:3_]cE/a6(EX@S^-I53()Wf9<;Z;X5c+U^9cgC[1\RBZ(\?6U91
7;ed896,C,?9:NZ#A^1TZC4^?\VU2+.ER/9\&OeJ52+]APOWg>_S=X1(O+c,CSXZ
G,AXS6KF#@&gK2[dVNI23=_eQ2fcO=8=6J9T0[NbD^H]@:>+PU_^BV(-5IaY_^Ka
S=/ZXZE#geV45@;FJBQ?ASHGRV\8)VNV@:JbC/]OMMa@b(\HXB,Bbd5D.Z)LXXb)
AR>aH-[J?f1fTCa)Q?fW#]IU;bO#4=7,HME;_.caMN9I3K#;YOL+bF^/U>Z-f/4c
:WY^c3]Z;PF387)&?@2A?AEJ:^7gIXKL4Q6D[_fAS8RB62U3Q#(7Q4a^YAeNI;,F
B2bcNF\M_TY>.+e6Q]682B7W6C<8fE=BU2NHS,g_>_Gb=PDQOa?ZHT=8?R[bWHg(
4@:@[g)2G:4_8KOgEKZb;ZZIgF9P#cVD618M0RbCHf[XgG28ANR\<XdY7Me,U<MN
</G6C;93US9PLgg99RL^,aI8&7IE1L<dW6O]8=Ig0^U/(B>W?<]>&O3_Z?S>fO=b
AHZPL3&XR<3E&QaT&0Ta3+9F,19&(YU=T8=1[gbT<FC0QB?PQ@b[]?#+bfWCIEAV
G[K.Q@K?9;GH0C#E>g?E#:&cdTNaVSbeB&b/R1^I+CJ?FQ4WQ5?-O.MF]_?U2YXf
&MgfU4OS89=D>0\^fNIXNB&=;A;SMZ5+U7N;2XFKVW>c9;fYc5]V+^A74\1J-W@4
A+Ye^20L1SDS41:GHZ(97;cM?@61,ZSfXWBGK[F1INJSaMRW;A/XT#TI(]2FA/7[
-BCb7Z5-PMU;FaC7B)7,-5RGdZH<TFPCU2TW<bI7#OdAR#dVg\:&[462W]KC(d+?
O[d#H?HTU?,9H1Y&FMe>PaOM\Z/+DQ-)QO>gXG/04f::fF(gQ]fb#e@FaJ:6Pe+D
COI817//\DWLcKcbFW[1.J]Vb>f9LDY8fZHMIfe-Q3ZFZF4H-9GUWW,RB+M5);8d
c,U]GL,3LD@Y?G(<O@RAX+=gaF9M2C.K>a6_9=Y28P=Za76KP,<8O]cBDB,5.gPf
T1^\GN_)BX,4#0d1)B#]>KXaT:UXEZ(>X4cD6_05b:<bJE=(<HG.g>@Kf)eLLZ).
8\N\aL[HYQe)LY=9FJ@a)fAT@1e-Z+,4E_LH0a40.@^PKFS(HLXd.BZ=FdW8bOWB
M0TM7bRgc/>d[gUXEQEc=HCFGa+DZNRER-D)-RfJJBPO29/;OQRD3B:48OTe,ZM+
@P,58-d]2S7^#_9OTPfQ/QF_&IDURGf4-#?5HFZAGa7C]Td:N79GF[-^=YRY@T<L
@L@e[95&e&3DR<3-aNVAFMef\)E,CD_X+_S/Z9VT;.RTZ9-f2]SR#D-bdT]:\&V.
=I]1fFcfV8KCHQEB:9[.27>fOZEZ8TA.J2+ZX\YEg0_C/:,2K1VeADBO-4S26Q9L
LK4^JUQW,KA@].6#88X^^4,M)XG_VSe0E=UOgP21KbFO2AH6CFB>1Mb57?+]d4^a
MLHd2dJ6L&MXH1LYHZM06&ELPE#.;+aD^bdR6C@3X9;CF0CTGBG7\B2+J=K7T5#H
b9_KJ_UM^L&UC4A/3RD5,bLTT#)ARd/,/Mb4U_0AT,,#+DFQdQ_aeaPOQP5(]dD#
FQ@&V-@,EeB9+@-ST;>#:=F@U1&4]]S(N0Z-]EAN&543)gT;aT@MG<E9X>&Q3>&P
7?C8J+4S3XCL5XL9#\J\[/0I#<N\#PR7>)K_-<;PNFHCJ3)O\WZ-3affWc+Gae>5
,42=8+T+NQ>g?:?)KfY?fTK.JWF]N#XV6e+=]TRZd,>)IR+1O5/S@56a@LAWW+ES
G+cVdd0^XP_ZDXDX2)(1IJN6/F=]-.cb+SBA=Q:)#VO1>e/dE+N]DaC48eZO[AXP
:\=/QB<3\KFH,>JY=7.W?>GBCGa7.)FX;\8B,We_e]+AKPH+]HM6CP(ZS.G,DD:W
W#b+gYa-\?bA0KCI/-:XYe[ae)#-8e24V&1G^N2QE6.I8\\,S2/QW8PPG0aV_Ld9
X;Z-H#?f<+cd#JR7[U_gJMbaGA-N=.T4U<ZedC:_Z4_JF1[><aYE3bDQ=WTSKg=@
.2=X?)@=IdZOXEeW+POTIIIQ^/&Xe9NgT8#f@Y>7+]UPKPL+BAID71Ya8RQD3c4W
<dH_OU=;89eH?HRB<e2)eeQ4S#LB7>E/F;0K@I?SCIH>JJN)#C(WOCX5.e\HS-A5
Sc;[Z+I8DIIW9:&<B&R\E:^WL:8WSY8SdH(Ra9/GJ(9_T8Z1YTV>eE[7R]J+@Ha5
;],+7ILVZI]DT.^IH);B_#OgdNEW2ff?R^b88&8a<S#dCceQ>CCA_7Q.LVcWO_VR
eY(.OL-_TM9S.,f++@8-:eZ(gU@;,A::^M)=:XEFU]5::]C+0.RIPTFC:IMD27Ba
B;gaIMWD@K\L=+;VdPF(T,\A2e9^C=I_R6VNbY;f\OZ;CPX[KFJI5OQMH@Vf+_d?
Z(9@UWWN:Na/DS&RIJC@Ag..Tc7_-?Y5RJbUOVU;;YK4b8/FYJ5FcROIgTXVODSS
3N=EH3W;T=_d..\S+1HQ@--94SX]ED5&eLcO>#c&Y,-\/\cN1,#>)Vd;DKYP9MS[
0+#D&QZ42&]c-&36)39.QFF:OgAF4?+HXL8@f=5UZLIL7Me7FR6Z0#d8M[<\P;\8
A(W>_@N4HbHTN&bU.<a\(/c;A)W=@I\MWTf?\XL3/MVZV:2@-[?Z&aQ@^(&P-&,-
dbMK)bX[dAS;0I@7Fb.@/+NG8D81OD\<0@M1_;<LYBCUZTe[6VUD(800L?KZ?W4B
dbfTJODGOQ/R.78aFQK]KNb,TX<=>3NL-G\#JIS:eT[&BI#AG]0,(.g?Uc60cZ+@
YRUMa3a6.=[U1G_/ODZEIE.,\:YGD[A8Cd5>=W&A0L6,fK_6<T4RIcCeOF_:1Z(<
0PU=9N:FQ1&G<2W](1<,YaI2DX=\T]]0,0.D#V@O0[APUgUIE=T(B82,IE5-07H;
)KI7A]JCcMcWJ+5@A(Ieb8fcA<c=,L?HWMf/78;I;B(9L2HIY]R3K@F7,5K]++L?
1<LB1J12_X@M5AV_Z2)fFJcT&aQ79E(>5@b]LLJJI7ED-]T&S-61YM3]1d))3g&T
JL9[(W9Tc?E(<E1V4_..A@[9Q2E2<L=-E(WHG:Fba5_BPB=g(#T>N=b60K@A+P);
V@E5-WG;FI</15V\VNN3W#HW4#d>6)<E:Z2dM^5M_D^S:&8A6<FQ.W=eI][A^f7^
71(1W5ZM]gd,2d]W\2&=Y^0g(AX<+Od2RaAaU-=H;M]#)d&>;L/#Zb\62]Q,<ffB
9#PXI+90.78_=Z1@E5H0OCIT[MRYPO]I<?)E^7PR0eG;^1J)ZG,6DR/>R=_d_?F;
gWS/1bI(MBY&/5\P)H@_TA&8dKd>^g:(2+4;88R,.MN9Jb44AIe/OIWFIRc9,X:b
I:\DS?a5AKMQI()]VQZ+.2eCMc?G080+GA@e?,e,F#Z[^)7VaXJN:6W@6dHJL9_)
,R#@0=6->E1\3>>VBaeDVHfP>+cPOF;WN?E5W@@g)4H.>5Td6/H99ZW;K1[4_6BB
-3#d.B\fZd4Te2c4:\d-MOSC((:3V(Y7O#Y-/QHd6&)7]09+U&6J5VODDJ+aG_Jd
[(O:6.,X).Tc:-DU8P?9K58d,#U66GB4]d1D1?LSNV)aCQ7:WL6<9f:#&UVA@Gd&
.K?d]d1bFM(9OR.9-02=ge<6M)48;./)<<;-bOf/>C7WK(5=)bf/;T7BE[6Z[XS?
RYV(?=<P/RNDWS^dK1fI-]7SQZU4H3?1U1;-;2-T^WWN8W7[_+IUd_c^75AKJAc,
B.Uf3V=T17eX8A+dODYHMD4VF8B)O^f]A1cY7<aMd6Z8;;&1&+E3IB#.ZM+1SB3@
dI,G^^L6e7U-(WP#6OJfA1IXA^Y=c0?Q]L_(Te[@QfBO)EVg,EaNJ:(J+(J#J7Q.
R6\\DXO:BK\/Q>-fcN6eEaUBPQ-P]2<239?][<Ue<^F1OHX>D:[1<(E;/FRQ8G+&
6,/[BC5K=1gU#<<bK_e7?1I7+HQ+e608DOHbU^Lf?+;WC>LgP>_6a;G4JFH80E,&
6I=SI31VN.,FU\e&Z];3LS94fP+^Qg&?DWN9O)g:?^,9&cIXYfQEU>Y1GLaQJR91
UOFEIHDbD4a.8C4d,cJ\9>HRNECa-=1N27AKH#=TgS[F@^e_VT7edXX9730^#Q3Y
I]51=P#3N0T?NNF7BGgB9M1M5<g-MY>-:/ZEY?0PT,PZ(L8PFU:?@R11.4+JKc_L
P=f+&M]Sg2?PHUaN5JG#_-\6)8VZ<dH.LA[Oe_I5]VSK8+Sb9Z]^W:2f4^E@EeH:
Z,U:1:BKOZG]eD\Z-<JYRN4347UHe;b(LdYI=7>\=_3&^\?7MNV/,&EAd_Z]>?&O
KfCUKMBBWc]WOZNdW7R)^4.7^,FA;+0+Q/_8g5g:)/(8@7[BT3;ec)g2/AQ?[JH0
55^WBSJ=TEZ]B<PPZ0^4KD:Xf&P\YB)HaAbG@Z/=?T>IS(TPf?)>,4/<;,7RFSKC
]Z][_#cR\SV4aW10=^./L\YE_1>G_SASXA&.FLZ]c76a&AH[@81696QXNX6(#CU[
c=XIKK#5;.853?b5/b;9Y(?dadc2.7IM=>:JVIFfP5.L,4_(+)AB(fdZ>WPTNG/B
,D5-><20=f+Q+EJNU58(PZU&LP6VTVX73<Y&F3dGcZ0/_Dc,LYI.@?b(E5e;U3eK
e,M;MT00JCB>;]#OQ/;WZ\-N9S9+?K=VP[b-4;I-6QDRU?=W3<4?ZAe0AGB]EH_f
:L&UGMNSAZ1QeY/X[c79\C[=\&.-JWQHUN+K(c2@CSS_=Y9>Q8eD:,e0L$
`endprotected


`endif // GUARD_SVT_DATA_ITER_SV
