//=======================================================================
// COPYRIGHT (C) 2009-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_DATA_QUEUE_ITER_SV
`define GUARD_SVT_DATA_QUEUE_ITER_SV

`ifdef SVT_VMM_TECHNOLOGY
 `define SVT_DATA_QUEUE_TYPE svt_data_queue
 `define SVT_DATA_QUEUE_ITER_TYPE svt_data_queue_iter
 `define SVT_DATA_QUEUE_ITER_NOTIFY_TYPE svt_notify
 `define SVT_DATA_QUEUE_ITER_NOTIFY notify
`else
 `define SVT_DATA_QUEUE_TYPE svt_sequence_item_base_queue
 `define SVT_DATA_QUEUE_ITER_TYPE svt_sequence_item_base_queue_iter
 `define SVT_DATA_QUEUE_ITER_NOTIFY_TYPE svt_event_pool
 `define SVT_DATA_QUEUE_ITER_NOTIFY event_pool
`endif

// =============================================================================
/**
 * Container class used to enable queue sharing between iterators.
 */
class `SVT_DATA_QUEUE_TYPE;

  `SVT_DATA_TYPE data[$];

  function int size(); size = data.size(); endfunction
  function void push_back(`SVT_DATA_TYPE new_data); data.push_back(new_data); endfunction

endclass

// =============================================================================
/**
 * Iterators that can be used to iterate over a queue of `SVT_DATA_TYPE instances. This
 * iterator actually includes the queue of objects to be iterated on in addition
 * to the iterator.
 */
class `SVT_DATA_QUEUE_ITER_TYPE extends `SVT_DATA_ITER_TYPE;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  /**
   * This enumeration indicates the type of queue change that has occurred and
   * that must be accounted for.
   */
  typedef enum {
    FRONT_ADD,      /**< Indicates data instances were added to the front */
    FRONT_DELETE,   /**< Indicates data instances were deleted from the front */
    BACK_ADD,       /**< Indicates data instances were added to the back */
    BACK_DELETE     /**< Indicates data instances were deleted from the back */
  } change_type_enum;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /** The queue the iterator is scanning. */
  `SVT_DATA_QUEUE_TYPE                  iter_q;

  /** Event triggered when the Queue is changed. */
`ifdef SVT_VMM_TECHNOLOGY
  int EVENT_Q_CHANGED;
`else
  `SVT_XVM(event) EVENT_Q_CHANGED;
`endif

  // ****************************************************************************
  // Protected Data
  // ****************************************************************************

  /** `SVT_DATA_QUEUE_ITER_NOTIFY_TYPE instance that can be shared between iterators. */
  protected `SVT_DATA_QUEUE_ITER_NOTIFY_TYPE            `SVT_DATA_QUEUE_ITER_NOTIFY;

  /** Current iterator position. */
  protected int                   curr_ix = -1;

  /** Current data instance, used to re-align if there is a change to the queue. */
  protected `SVT_DATA_TYPE              curr_data = null;

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the `SVT_DATA_QUEUE_ITER_TYPE class.
   *
   * @param iter_q The queue to be scanned.
   *
   * @param `SVT_DATA_QUEUE_ITER_NOTIFY `SVT_DATA_QUEUE_ITER_NOTIFY instance used to indicate events such as EVENT_Q_CHANGED.
   *
   * @param log||reporter Used to replace the default message report object.
   */
`ifdef SVT_VMM_TECHNOLOGY
  extern function new(`SVT_DATA_QUEUE_TYPE iter_q = null, `SVT_DATA_QUEUE_ITER_NOTIFY_TYPE `SVT_DATA_QUEUE_ITER_NOTIFY = null, vmm_log log = null);
`else
  extern function new(`SVT_DATA_QUEUE_TYPE iter_q = null, `SVT_DATA_QUEUE_ITER_NOTIFY_TYPE `SVT_DATA_QUEUE_ITER_NOTIFY = null, `SVT_XVM(report_object) reporter = null);
`endif

  // ---------------------------------------------------------------------------
  /** Reset the iterator. */
  extern virtual function void reset();

  // ---------------------------------------------------------------------------
  /**
   * Allocate a new instance of the iterator. The client must use copy to create
   * a duplicate iterator working on the same information initialized to the
   * same position.
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
  /**
   * Move to the next element, but only if there is a next element. If no next
   * element exists (e.g., because the iterator is already on the last element)
   * then the iterator will wait here until a new element is placed at the end
   * of the list.
   */
  extern virtual task wait_for_next();

  // ---------------------------------------------------------------------------
  /** Move to the last element. */
  extern virtual function bit last();

  // ---------------------------------------------------------------------------
  /** Move to the previous element. */
  extern virtual function bit prev();

  // ---------------------------------------------------------------------------
  /**
   * Move to the previous element, but only if there is a previous element. If no
   * previous element exists (e.g., because the iterator is already on the first
   * element)  then the iterator will wait here until a new element is placed at
   * the front of the list.
   */
  extern virtual task wait_for_prev();

  // ---------------------------------------------------------------------------
  /**
   * Get the number of elements.
   */
  extern virtual function int length();

  // ---------------------------------------------------------------------------
  /**
   * Get the current postion within the overall length.
   */
  extern virtual function int pos();

  // ---------------------------------------------------------------------------
  /** Access the `SVT_DATA_TYPE object at the current position. */
  extern virtual function `SVT_DATA_TYPE get_data();

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Initializes the iterator using the provided information.
   *
   * @param iter_q Queue containing the `SVT_DATA_TYPE instances to be
   * iterated upon.
   *
   * @param `SVT_DATA_QUEUE_ITER_NOTIFY `SVT_DATA_QUEUE_ITER_NOTIFY_TYPE instance, possibly shared.
   *
   * @param curr_ix This positions the top level iterator at this index.
   */
  extern virtual function void initialize(`SVT_DATA_QUEUE_TYPE iter_q = null, `SVT_DATA_QUEUE_ITER_NOTIFY_TYPE `SVT_DATA_QUEUE_ITER_NOTIFY = null, int curr_ix = -1);

  // ---------------------------------------------------------------------------
  /**
   * Initializes the `SVT_DATA_QUEUE_ITER_NOTIFY using the provided instance, or creates a new one
   * if possible.
   *
   * @param `SVT_DATA_QUEUE_ITER_NOTIFY `SVT_DATA_QUEUE_ITER_NOTIFY_TYPE instance, possibly shared.
   */
  extern virtual function void initialize_notify(`SVT_DATA_QUEUE_ITER_NOTIFY_TYPE `SVT_DATA_QUEUE_ITER_NOTIFY = null);

  // ---------------------------------------------------------------------------
  /**
   * Called when the queue changes so the iterator can re-align itself
   * and see if any waits can now proceed.
   *
   * @param change_type The type of queue change which occurred.
   */
  extern virtual function void queue_changed(change_type_enum change_type = BACK_ADD);

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
GRJ(.SPE6eI#_+7ffZ^c/>Y;FGE[Ib0DPa;CHFH?S=1X/DFE+-Z?+(bZ;5TQ/0&A
?a\2#8e[JcFQE623NSL7cKHSfaLK,6_aL2;cF?e6(6PB?cFBd@_.H\EO.)@4KPU>
<b7T_KT+-aIWW7b)@9CUc3QD5HM?._e\g#O1dIZa)UP?9\\[236XBK:S&g@J+UEM
:Ua-D34d8YdfIVOS_-OTUJ9T]@B.#Q=cRLK+[4.&X3<)(ON1);K8.S);5/dE8>BP
(VVL=XV8#\_EHR6=2G:;D[COBNAA7JJ[&),E<dJ.+2+N6fSf=67:7^,DH4S+YAE9
QF446.YX06.3EaA21R.38)YGIMFC6I8U.K]Ca3Cc/7\EG2-c2>QPF.6]L:3?Y9V[
-<R-11.8dG>GY5H476b[&g-1X2f\XdSZCXPHQ:]S[(f#JS2/e7Z)@G_;+@37)KET
,8PK46E^d/)P?cLXWR:S.\?#:[US85M=T][U^UK:4C9(;Mg35O,\e[+KV/a0I</?
).U8HS;?56b5gM?V_+HBecf5fSaa#b>UB<YN>F=R\(g>_b9MNPIIb-ED(b(9M-AP
dd7A&PK._AX03/IL]CKO,-N+IJ38IK#2g7;S3Sa@Z&D5R?J843d4B#L/#+4&fOOM
);b_9Z=TWP(>EgE26=EgKPU]_N^1YD+CS78fW^0L2d4?9OO=A9K?>bR^\KJT,7Z&
UW0JGSRC+/A5T5LaZQB>H>Z.((5CO/6E?5E><;gbN75&1O[f?KUBX@206UJEUc[g
C?3U08)D;TT11BAC<K9I<e,g:+\:(85V8b449;2L_I6?6^46HK.=2WN.IDOLEXEO
5eCeJ5&(T-QU;\IA?LKCOP.8XU;R<8DLg?Xca@0G_(:VEX;e<CEaJQ7;N=#decQX
AW,O#e_RFD;E@BPRWe@a5,UC3L5OHZZZ_R#?H2K5R&Ba_5bH.LdBPaBCQ9&)Q]2X
&?eS]=_8A0IMfM]FQ6@&?e8S>Q=T=6@-:.f/^c9.e4fYL_WYb/[HDf?<PJS,L-2]
>a_6A&>>(<gb^GYg_XZ7;,9,<=Z)/7+18WC;M\SUFJ1Q1Yb<P\?.@CH\/2NN>WT6
GEBa@+4GG_X.-AcYc&#3DW/U07N-C:0EZAaF=LI+2T=b&H8R:/Z;TVbA8NIf-aXg
[7M^(ZC<IdQL5,,KH8C=HdK]<\,@[JY[#g]1.ZZM#R.X0AK8?eO>K.d+&RW(?dGJ
f3@1P:^&>T3@&^KDd1:@;O/IeR?1g(OVD&K(-#59#@2TH/,,--R+AdE^#(CI<I+f
dT9F=OA5ZI9L\BWTK)]0T[&\VKYG_H_6#>F@-/T8\B)X(8ZRUE:T]MfQMaW@\NZZ
Db+MV<E1U0E?I9:JT\_8</.d?-D:&4V2KAeEIF0:/\S)gbVB)5ILFa5/IGR=6HE#
dSg:eb.RMX-6,DI<:)L-/J]\dDgWL\a?7DRg9/E2@36_0Kd,^NXf4G6g7-.c8B:a
9><@PX0/EC51/(W-_fF:/6NL9=L/.3WeHO3#6M<,S8eVJ>VM36OEMf>IZS3F5QCO
H[CW:PHf8=c^MId07@VJWPcb7:&,/R.V@6fZT/=:..?L)Ob;Rc5R?dH9V=2aD2#O
HL_Z0.bNHR^+ZP7aXe.SN09Y373FdbTgK2KDF)>O\6<4^>]/X,[Y4:09A_.Df/0]
EJ2(28ZK2d1C_ZRf>>+8;X,d?O^,K26N<GJZ;JYT\?/&0\92<3U_UGa0+V2A;=@G
QIWHWGKSY;/]+cK[+:=]ZRCE>=dTEO>=:KIYH;T99J(JR:6Q8O5[5H9a_]fYDY&0
[fU(?6S6L6V/]V+IdRZ;=e]RZ0FJYfB0=J3a[NEB_3b1N<c;S1NXVF33XYU>bY;+
[Le?9PB=DSaU.\M9R[L7[g3(]F4HS:K8O0:]VOF3V:3[5S(<1,eH,?]T79W/?-)V
PHaf[-?bQ3:8/MGO>E5e6fda2W(dg#/#TAP187b(e7I@@?f#TaTdD&HPZ6I4(WCO
]A(2>?DOdJbc6U^?:YS(Z3fXB[d(?RH]U(6Q&J#S^&fKPTJG4\(D56465R#PG3TE
H1]/FY_2;N1\fCeD?/M9/I(TH(K7<Q(^7).]B_G<-Y,UF\=(FQ0+PPE<f0?9A7V\
2XI.5P&M^)3SZEWAL<\gFYQ@E+NNKYNO>daSD/EZSgYbSV>g?Y)_=8V5-:W#=@a2
-,6QO<e+\JgZf^;/EagHA8b(H[4I1=J]+?J8-WXM45cV#&IScQ3T=JOP7HGLd5NR
V\GEV7:<5^PK\C;XgX5GaD6D5[.B>S=RZ38TFcNI/d9LWe(6D85F3#cTP_8K@<UO
O@(<QaT0@DKETe>V:ZJ]bP^4LJ]V4gRUOJWNU]E6_I-J=aSHU_IYE_23&ed+g+P^
U/[8Y:I+G@,JTQ0Q-8B0fJ.<@/,Z5d?C2bLBGc5DXS4<>aR(N6KWNL5)I>R;HXI9
&ee>R[R^J(OMf--g57X__RHP@d]A=7&?)&P=>fc/=U6)4#/@2a@L.L\aZ@01fR8?
cH:\.U:0V5>c,[=-GRC[2PERS?e0\(+#SSd3#WIMS<A,WXeA0:ce=^[-<TOD)O(J
E:[>e8G/O(PSRH[ASX7([83+_-(#eG;[HD(DIQ@B#fH4&XG52UUET#?&@GW#&=eP
[^ISdCfSIEbJH77A1f+#.+?X4C2S7F[OS_Y@G9]g5:[7I7dO^FYE/^9<dQ./.]&8
F(1d[-]dZJ#7\^a7(eU]JCL0U3JRY+b2d:W:XL++Ja],B#@HJ,^1XY>K0@#<V+7U
&&Y7;S<[&>T>M/)NgEFU2.)V?S>2EJJW3d?5[>_b^]aTJF9]NNK=48G,T09)-Y-U
L&gd7f\?Z3M\N3B0EQeFA(<3HNdLe=P;e/Z[5E>S.)CV69QEG282-,L@7NOHeL]P
6fMcCP.9]:2DJQB05+#6Z04:BJ4Q8UZ;;#&C<V9:0e9f3190[MJ9.M+RPc3eTe5&
Pe]99POV+P/_[(B>J@.L=KZW8.b/\?GIF(TP]4Q0G4?5eG^5fM1/gGJ[?E(Q[R<E
.#H/_K+YdFS-/CfK\NZWL+<IBN2N#QCSQTQ2,[^2:;5K<YL\(M=d7L>Z,OOHB?UE
5WNXU9JNH;27#)DJX4R>WZP#f8]N+CZ_g?F.<5#ISDZ\VaO(2AL#\Pf7;-f&Wa+e
-)+bOFW#H&Y?FV)J1;fS>G@e481F34:OOX-;S#F=U1?78D&3[DA_/^&=S?aUG\dg
^E]deNA1gW&5We?.Gc.a2]8OKE/RB;_aa&K8UW8H1Lb+O<T.a&<A[T>04IfJ2FgH
dS>NP1>T.HdCIPOGQ.7848<1ESP^GVL51B7+Y1(+A+>LFaTG3)^;Qb28a;LOSS(T
LXL7?cS22XT_4]X-3&:.UeQ(E1NM4\]XCT^ZS-U^b.83#93#BLBRGL&\Vbb,]UR<
9-3@A.U+HTH8AZ?bQFHD_5=?J&\=K[C;,)NIVN8Ob9F7N+:L.5>gW?DQO#G?YP#U
eT7WcL9Cf/8],;YcUDe/W<^[;HID=\BL38H=gWEVaN9X0M<gea+C=SO@<fC&GI<X
DR>6d^<@D>]5H+dJ-IOMc[A)7U,X4eD[Z#XdNC#2][@S0SM@,59MNfDa@T:6fD+>
)+dBA[MULVd#92X.K:0VX?3+RG95bUQ<a15Ag^GXaZEC)NBC8TeP_44P4\S2\;Fg
A6+_T,RE;WB:f=ORZO<O]]XSB=#D@3^>;3+cIKW\eP+8:VG6.4<M8bQ.CD5bf9;=
Va[CYFE,EK7eZDBVH=VRJIJRH/NQA76[>G9&1Z3\(KC7YK9ScM?9Bb\+V^\d&59Y
6&e)g5;5g1cKR(]a(_L0;6HV)O(IZbIeN?YYK]UQFWQBQQg>]-]aT&;_C92/I)XU
ZNK(4P1O\JN4JLICC]5/67_cH)3P/>^.Y<2D6gC>bO6?;e\D5,PYE.(O0L6(V?e_
\-/VPgd5R5/]Q&&R+<c6Le85D89I&C0TC&MRJLDV,gf=1N/PP.8P4I:AbZ_fPH^.
XUXgYMgK47_Sd)bB1\U?<cB(A([4U\2[;X86YR>;2L;A;&[WH-bU;+7Qg=NBJBLA
</4X&CJ^E&CT,OdZ#0Be4#cQGN8<84UTD.gB?@K(Z=9?;0.7;72g8D].?K:J[&LN
fOd,EEP\+f_?,I90;_D8J\X[?#21,TTXGY&<g.fe45WX2R/S/F8Jc6Kb>W8e15gd
W+)[)59VY#,.f<IC7MO7QZPf<)_bQdf#4L2Y/_RAXfd1d]M_-6gcMc6)@XK83cI?
7Y3K8?^\VV>X;H1F@EO6b,.:=0LHd@ggM<RgX0_2P:W,:J[.K+)P?IdRQb=;XPM6
OYVc9CJ4O)2C42)Dd^O:bfGW2>B9d#T8?NLZ^O@RZQ\DNZa]S:,.MW:AMZ464&GB
Y&#6LAebBMaLAROH]2&2_BW(=@?LTW?B(eEPN[+?CAaQ8Q;_59WY]SX:d5<d-)K?
YGTU4+^H;1TEX<E=XYd9=J=^d<]JXQ32VQe_Tf]KF9PCPdFNfG+VPBG7#Kf\1WLE
Q]/+MMEUF?(O9C3<O@<DeL36,6f.OI.Q:_:F0.F[&V.P.e=A<B^@RZU8RXYc7++#
@6/c[K=T;BYTF>#6\RaP1aORGF-IXF;:,VgVIe0e>>?R,RA4O\gAS\F(6O9]Lbd6
_8N^99Z-7T/bX)-(I6GQDT@>)3S]+(NMA10e#c\8Vc6/<^70>;E,QeE,=J+[bR8L
D[T(H&X&gJ4843Wf+gB1D2O/K&dD>=;D43@3C>C0&_dc8)L3P,BUaB1.<9OOY^V,
W^;:O+\5>3fJTKRSJ);(;aC4R:O5\9PO>KCcLMU5R3FMB][X1CPNWW\<>9ad0Fgb
VU8e=0#_X0-QRGW>NNb.UQZdJacM4_<FS@BJ/Ge#,R)FY_UeC?<M.PX5WS=8/#N3
<IO?.407B0]-B?08,bW7FeY9/.K\4RH4K^R-AKCg:;H??A8;L3Y6X&F(5-#P,XYT
9B]TL:Ue;S/c7L>c@1PBTIIE=0@7P5J[NW.YX2<D1QXAX(LeZH0dG#LJ./,8aTED
JZ2b<4>W6cadUb1@2/NAP]e^0++F[3P@MDNca4I0&<Ia>;0aaV6EXcO]4V/bcQdD
GbS@ZNK&dB-8?_JaDLOS^O,4/F+.@V9/#X>c/PTB9Uec5TU(M?gW=-P<2]Q0+09P
_H.^1-aB1^]NU?2N?A=ITcOYMgg=T8I&GZ(#CFbIeE4gI]:L&eZ:7>;PWMdcCEfb
<c[S&Cda0>c4O]-W&-_\>Z\+9#:)B&WV]eKXTSSH:Z5O[,>f;@6[B<,)@1>15XX?
W/.Z(#B29L(ZbdeA2VMae60fT0K\RL-b@UIJK/O2VV)E/+e2c5,M?6-6#FN;,6Q(
\:a8O6GQO6a)GD(;STEFJYJ?/SXK>&LeSKRYQB+2Z-,XF5@D-FIg#+3(4@c.aW\2
[cAY-:5U\b:-TH1VNQ&)/^9V+dfgS1NG@c4&=\T-8T6=)G319^WRYBV=5_dX>SAT
9>IT7ER7S.9ZBcWAP,V=fM(L/f(F#:,20[de&RZedKUYMUT?PXD3AF6YEPD8^](A
bCE(,Z.8eaU</gXT2:TV?94)Vg=I&PI0?_g3)G^D+3[8J\a)5B(a-WaQGB[<NJ^>
@d[Z/;,RF=CND()[T4Qa,.1L2MS;Z+L)I01+af)W(/Y15(&f./<?)a,[?b+\Na&A
\Z@b<GFd0WP\)cae2ZJ3F,#5PMZ_1E@cK.635ODYf1+3=6Z7.)SQ0YD13=?NJ+?S
_C&bAUJA^C/3,;9c#?:cGIaE?CNRc6UJOJNUWbg1gHGBb4>2c4ZOQ];:Xf[U5+OM
L,[aBVBb>A)YI?7,A__g3^Y36X\/USb]9a>)g-(#VH]N5A0=aH1G3SDT=MU>&K^S
RWMcacRNc[NBgQGH30]VeHYA?EHX6FP9L.-9d10A/NEM4f25QfJM5eKJACC;\aB]
Y7aI>L]9EDV)#KKSBY,ddBL_G&8.N&/47V3dZcb8QI+-f;(TBUGXdb,A>X-WU#9V
Z0JR,>O^V.de#[V=YA.]A]NX(RKV[,cRVbd]BAX^L@K:2C+K#B+UQC=bG3EgDE97
QP_3HZ8EU=2D(60Q_X]MLde4)[,B/,)2\8\@NZG>[4_8C_>08;fQL=0#+54BT.]E
B7<UMQXW6/YeCL6:Oc6,MT8?Y_[a<=dZ_3S9,U3K4f44^L3gE[G1X]#8@K^KYU^R
.Y;+6c,[eH.Xe/MG,G(RdTWU]6I-fd0I,Y;2Tda>[7R:P+<<3d_SZO.WU]b/G99@
I_S&9FNQ,ad0M[#4]fc^0^gD_IdI^ZPQ6Cg=1dOGUA,g=HR>2;1<3]@5P:1[-LdW
bQTR>_/dB3X+O^=QQ<Pcf3Sd(>E2O)Kc:1&F4\1O+.(&S]Qg22>dVW2WIK7DA_;&
]-gSS>XVDA):bMK-]2dYL(3fP74T5<966HVNcZPOK0a]18LN@YeC_W[B>C/GHSU#
(W<PV)5D4c3)>-Q&1MCC6\TXQfSf:NacCFLWX8_EL<JRBDWNBFE868LLXO2[#E7H
IA)AAJ,U.>FJ-YBD@7bO\>?X_5XWR:aN=S3:MeJUML?ZRGH9Z_@,b_Xg[78_[Rd_
[C=#6_0B<g>(O/:M>Ae+?M?VV4UY;4]7D4HXF1XJ(6)^8)6DLA[8;+HgKfKK5]c(
[Q-<DDRBI:W1[2,IP3;[Y.de6=5:_I#6[DA=#H:Z:geS\4R:V6GNa-@]age&D0fZ
\]geK1_QAf>IAU002_Pd/e0AAO6@1>243NR-E3S1<KbL^8]:MF[.Hd_)G/<@3VD:
-L.UK:5J:-\@^(_b&cOHN^NCY<.\3@f3M8-,MYTWRQPe2,.UU+@K)H4IML(9,QCS
7)fY:9XD#LUg?>McdbNXOL(Y-P8GH+a2f;+5/g1C/d29X<BG=_<=Z?/K:HQVQc79
/,Z<#T&9T[+G&+6K-GWZ4,-:ZRbH:>;<f#9JUU6EU7Y;aK,5]gI4;C-=:ET(G=M]
(cP4]Lb3(E<(aSLS?UYC0J+^2R[SOP5VF2.-@?==GabS=F/HM,0PJXMPP._ZAECZ
/eAK10QAM:&1SUUZC_+Vd8I[1JG-MQW4_6&C+CgaA2A.YE-@@=F1R#GFcW[>N;Ng
-_FKRX+L@>[IISE>89Sc=NaN(c>B8#SgdG1\81;1JH=LP\0.d[5YMS(</)[8,8Lc
,C3,SLWJcP/JK^ZKWL8\Nc/(<G]f^<d+Y=55&L4>]KOBG32)0H-BGbQ(#;7?3G8e
Le534.;6+[<d&.;FdXUR2[.9bBZ[\Q[Oe^\KJGHO#e.Q;+d<@F];Ge)Ra&fNYgVO
#6T(>HC81XTP/bG,-VbPY\cB<,98:WQ3#9TaYUA@74N0a;),Gb6+9-9NYS0T;PQ;
Y.T4+a9bc>=Af-2#BG(_=)Xc0KQ]=1<G]M)6HYY+\9?QK]=NVPUTE1,^?[K&>EaQ
&e?DDDWJ&KSVV^:B].bNQ317f<>a05RHAL.++E42/C4c:SN4@ZKe(,=_)R9X(EEY
f,Qe@UR\bNYUI1]B-;\6bfLUD[.LEU7F.(3]MM81CLf)>0GMVXaE_=9.;^HbXda+
:>?Z(>fS>JR4T6HPZ<(1)Q6e-<aVLDZd_@0+WBC3.8_Qd?+Yd[&edKG(U[TGC]AP
+2fC.1XB^-gZX@6K,9#>d57@Y=d0Qe:\@70ccH7-)A&93PB_HLDDfR;E/]9e3gg[
=)&G@He9VT\Q[OSA8D<JO,66K/GK59(BaBKJQ=J&&]3)M_\B)9aP2UaGD6DQUK83
d7gd,;4JF(,=A;CNOW02CA4#Y,T4X]5[ST)56J&S0C@J=H3]H>c=3OPS>(BF@/>T
Va:bY1[HR273<L.TRYS23.0R9OEVT5D6\0OKIREf/\LO&L#E6RdBHRa:0HX\2_1+
PQ97eF(=IGH/R<<7SY(7JULHca_)]P<,C]^6aT1YRWC>)KLeG1)<4[\-,MK\L],?
=SHO3B3,Agf)4LbV/S7:Z@28C<H2&+N>1T;a_>(fcQ+b-UD(53UKfJ5DC#-A]-QD
Oc3@>dI2gD69?aX]2;HSP6NVTZ_:W5SMg+8;I#4R,9G>-7X1BIU]9WB4]+(+bC_)
O.1JGS)a>XGHG47H+^A0CN@LU_J<ABNMaB5?3fYUA[Q@@b^^OL)e)N(cEW]35-L)
8AcNNec54NaFg1DXVO(](4OWB218_C6(V&Y,;EI.^G)OX+AdO=X#?a+7&II-6TG-
V>:e4:R,VMUM,-J[YYV:\>^HMW&Tg61,TP5E/<^6V\>2S7eeL<8QSKJGX[Z3282C
<4ZB=>\&K>>/B(Cb(&9_OGI_VfG7?8:[LG(G@e5D;Gc:b;V9)YU#d273^>e88I.E
7H(O/@[LP)6Ed^3L/,cU1a\J1O_4\XW\^<FXUa36EdS=))4F29Z9EX20Y^Z1<CU.
F#]3F7MG7V[8e4\@d)&561GcB)U33I_TNf,3^^9VA^\_Ha\22H?S5Pc;]4)Ee(A1
UOJMFOIV@fIB\LKBPeJ-322KS/695;@+OKS;9;9.#>Ka080W7K^0QT_&5gAGB^f-
N5XT/2(,N)/,&+2YJfd0Mb;IE,ZKb]#[YT+?feES)a4>IXTO;8-+-g\HOKfB#XOa
NP58TNMb=GccPWW5A+D)bLcC73^-KJE68#gbT9N4EPCM<68Q#6IKYQVgCcP^FD8F
SeQa-@-,.U_#J)O#E2Z?:JaERCe]Q9ZbbPMK4b=+FW74(,0KHd-XW#(/MY@7PCSC
Y&/XUP>9g9>LW;>@KSWM^\SD#RPeTa&aP^3,.;B=&^JXM6-Ta?Z?-CgA(D(VaQ6A
B):[I1YF+[#=DaA763RRbF/,Z1WQa,P(P=VIQ,;Q-,XT6a2[ZBMTf)0?WE,ee_92
GP7eQ:R=S.C?IKKG,Rc(bTOIR]<<RMR8&>UNH?>_0Ma\g=5Gecb>PXS#I#G1PDWK
^4_?IgNeJ=cIC>P/MTaLK8#U.eL91f-4Q5fA>\S>NR[4.=G3Q0c<B@6bW\a[+798
F@R_UNF3b&J,aHfM@&F7_;9I2_cda+.dd,IK3[R_RK#DXOC235^TFJQ^Zce:GMFG
^M24],@<b9K><N8Q&:OOJ)+efH6U0EWAP2T0b_CC#aK0deZ6>5c/GA)1(FF@)3f)
41)=@+bRJU9#(QaF\QVT(\=8Y(+0fMV(GM,C2QI)dCfSS@/D6FA-GQ/#E<]2QFFK
G?:ZZc9EgXZROZY6G)QZMN26N>ZbK0GJ4f7W7(\I\WL6B&3=#3R]?43>af#;<H)&
gG[:.JA1&EAVg\G3_LAC7.ZGSI?2QVT3\e\X_Cg,)@K,)2HBP3X-AE:&&)+T;J.b
]?c@V0TG.-YTAWe]-FdV#:BVgD:PP::):<&Z[W8T03c78#^H,(I2X+^[=X;Z=1Kf
UAF5@DT^7)O3X(,d&Bg&gQB#74.LUJPX232Q9;\/WCcWFP:(K?DEU@7MV7=;EeF+
>0+IT?G\=g0=&FOPB=5a\&<SUP,GPT2?1a2=;U],:E\7VWW-4NZ5Z&XRPg&ZF?WB
IF4)();,.O?AP1e8dD\2ODE4G\7J[&P/A#\X\YK]fJ3ZM;eH[_QJde4^,B,Y+CUR
=7?)S>^Qa)N?:FLB-XDgKU1[ZLF?f16I^]Q=4,d80c15e:LK?aC&:LUSAWPBCE2+
O3YQI/A=;\<3[f91:-4OAVFW3Cb>DX<)K90f75g@-1X)g7:FN\,gM-(9PGgD4B@>
.#JGDY^O8g\&TH,()WF7fbLDgPZ/9\&X4C)b@FQ_>JF?3PI:(dcB70I/WR7f&e/+
Y@Y9(^W/G0CO/AQ9N0GVA=UaMg])\6NVQd95e^79PZg;]RR]M)eg]R.AJR@)8B^#
(^f&^T2BfVF^]QXJBcC,P+CWd@#Y#1[,M96O@6E^TAPHMgDY??X#/b7:?OKDYcEY
=A8U+M>CZ6[X1.1LPd[I>HcK\V[fT.18O4NbX0G@VAOMa3D@^=+dAAI>POLH2>O)
3HOO[bF4<2J?Y:CLT1>L&JS8/@SS-CB<.9?ed4;8I(^(NIV1H)c2K;-[-2L=P1Kb
.g8WYAV?<fM@&6fRGPbZM8J6Zf\;]W,R8cIeEScB?L;cOX+_EUc^G\fV+R_RU/9#
KP6HX9ORf;gIH23=(3/256>ND2gH=YY;Z=>&/WB&b^^#AW=^H?FY0/B+R@__Q7RL
-2\PNU>[B285MI6^Z/R>6B,6(2Y-0G=e<X931&LY>055-)^;6#Kce7DVPf9[MR\7
?R;)OSXK\STYV_)&RO#aUDgc7a>8?W1eY-^]_J1d[^7eUM->R:I>URe^5K6R))4E
[G+G[+Zc0eFV75\F3ETJdZ#8<&)?4&0+.g9b?GD@MXI=T<,9JIG,0#ZWZTaV5/PW
\<SBU0SRK@YW1WUYa?AF2#6L-FcSG-+=:+6aGd(1XGT/&ILb^SESH\WRO2_daA^M
?^LY-cFILWV-E+61_YWZI19@S#7<PUSNBA4W(MGC)cZ.43,1fXXQ9XTFT9DfGW_\
9Ng+SJ:d:Zf0TJORZ3E/bd34ge&<C>KcQ:TeV;Kf6&?M]CbFM#21JbH<\YIgY2_E
\-&bDFVFbT6_B9NU_J\-)25;J:3-.0_H^:)CS+]:dU:^:?6=,]J5cIb:;=MM>.<0
VY)-Q8E,C@10O2d0(Ja=NYaOVQNVGJRM]ZZQOUB5ME(ZJ>2E@_M]-(aUS6ZaRIS,
;#&PGP>E@(C]:M243//W92A2ULMCdAC=eOKWeO1a-BR)C&bb[D3Ke:.7cGY<&#Hb
-I/&7SL3bRGfS;IRIOZ+<M7[7QPGERM13Q@cZC>HbT)-f.b2P\4+8WGe_F27EFX#
M-\[9?O-:\4R.MF@]B3.VfIGf(B^Wc6JR+@^9C:4NgGEOaE^OQE.)>L>U&K2b;W0
b..VB0gZ^BQ]?fc\?X.K?X<WRgfK&0ZZ7fMR#J]YRGFc#TV6W\e8U]cUNSMO:cZM
,aa_9VRHD\SP+Oe[d<#=^A6]UXcBZXBUBI#;)MHDU(MXAXKZ&AeF;Yg&[L77:g?6
2MFSUbPY&D??(PXL#1d@BQ/Z?0,^=O[L,16DHQ^7b_7NVH_a=2c<&J:2C_&#_(#a
JDQQfDf5;0aQ[K:M71D4]__<5PaA7-V&,[8SD<T-7gZY6G>Rg;;>gM@<^fV/@G9X
I+IW/@+]SDY#\1Y(TK#@(G3\O/g\cFHS-aVITBg^a2(1Pe@FKH[R)4O]R#FcIS_S
.A@78P_YP(dAFK?K?)b]E--(bDRU&<G#@@=)d8K0d3MIMH2JLYB/G_Gc)\PN[D\]
-c?X8AgI8RXAA+:E\9eCIK/L9\G^1G,3>NJGICDO(,Q&^^(&LL3O&/W._[^a38e7
Hc)b8KVL\gKgIM.aR26^SN_<K0XP-J33P(P5RI=EeFV/KXHSSDCg2IM[Z_?,a6O7
\#=g0,_G_\SJ]Q:/d^;<9f-[8I5O#+FgUP,5eA(JD1;N;AFWW#3MD5(&a=2D0Q(<
8Y1I:-O>WM;IX7;K#c2ET[KQfI+X,AaAMT][T]P5H/g<#WM\.:^)F(:1aS33--;4
1>NB+fG7gESQ7ATOdQN1+UESUJ=+VL]2BF/.\N;;=#ST<4RK:[Q^A2OdG])#ON0=
0HI,\3aefF-CMCd,O6gJ<C\&d?=SQD=&;7HdQVLBIIMC_0^F5T4E6+BQc-0+/W/:
>dd?0?MZ8Z&[Q4FVL&\bM3D1>)S<8:F\<+;.V..](QeDZe#g2NTcPS3M+A#GODKS
JJMG.85:OU()E:M<][QK1?e2TQ0Q>:W<3a=^?W/LPHC8Bf-g8^1XV[=CIETZ0&OR
X5b-aCS_I.QRVSg^WC06FU1aV8Y+L++DW08JLWWf(4JTNLHME((I/9<9a(Y16&Nf
W&cBee6N6URUe5W_4+&>T6<Y13-];,TXfVbQ1a<KFKde@bggR_9J822200@ZeaZV
IHT]B+</#/g0#Y9=@.I+=CY7^VE<IW=1fSH,TO@R3J=If;^1KIc7C)\M5AA]IDDN
_2YP/J86LdIU<De<f.d20M7,A<c?dcZce.G@UQ]7K@R?H<O9NU@(+Ad^B)QIWL^3
7(>511?W0UCE<C6#6CC.)1M\f;E8#R[PDQA];AO&>7ND-89B[Va:IV)V+).W_\.C
PCL0.AdeA27f>;NNRYO]R_4^Z&U4OB(XcDaBTT+--468/7;14E_DT4#Na?6T9KS&
SKeYGK<^Ke&?_AVKf)D>4S#T87W6^.0ES4H5:<V7gD[2KBT,gV0N_STJN9M62V0T
LE5S#GNc=@K[geXc[4&ag1L1+UD?VHMP8=9^R0RC:a?eE2I_e(QC._@HQfdGBFNg
g=8Ne3BeX#R_^PM5MZ[OGb=VGO:,/4(F[U>7HZ#7#U<f5g<HBT=5N@Y>]<EN.9U4
X9NE]?^TGb0790<OQHF93=,]\H7Wg)JK0F?-fAg?Z@aJ_.Y;Qdd&F7@8A>XVU+W<
.7dGTaN^I8[.^>eHSMLda(?X0bJCQ&T.<,O>#)^;SS29XD&-[AB<AD\Q:#QE[GI^
3BQJ/bg6H\]@fgIbO93;M(3RL7@M+D43+D2A6P@JbX\EV#6W/XUC7FMJ0.gd;QWO
2_D0dU8=]#01RB]LeC[MZ\0-JT^[fY&?Yg@/Q:aa:PZ4;:2\8Ud_g8d3(DZ4:V.0
<Z0)abcPL1,(B+OTJD0)P25]\C[YM=>6\_-W[ABE.K]&g+TU_T-3(^_3GVBD,8AO
-C>FOL8M]8@MWHS\Q1BI6+g>M21->5QSYIO:+>.4T9b)g=D&@fEcFL&eYGB#Z(L#
>Y&O+@\LfO[GL.1S&C[g#8R\K[+LU9R;(F+Vd<^:(aVfWcb6@ED;_HMXQE,VV;WW
45D:])-YI4Z&Y-9[+;c1gKB]8O1@EUA@\UT707fOO_D#BJ>CU+g;eQX0VC+GX1c(
F3[HBXX;_Wb88AW-0Y\9WE;?@D<bC6]9@_KS:CZM/[8d7cTW\g/Tb+\aUJfPaMD/
ga]?^H[f)bHY(YQV1].Wdd7.Y=,:W18HU\+A?/X>^d@FdA+7WME-7BfN#([P0<FA
-EdI\H&KdX)2^+;6+DCS7<fTNXU(H,(+6\_R+beb-<KWab8[5D1_FR)C45&=eQLf
4;<MKg6321bbHYM@8]TdVS<TceU.I>ZY+^?dUDS4KXV\>:Q@4d#>fO)(UCeT7R5_
YPJVO5P5;HF=8[EFID3K83eTYKL((O\f4ab?1MY/:4:&HU(Y@N,PCK);M=<(@NE]
cQ@V+2^-GWUg+.62P0-=aKDN[BVe9H6C@MO_Xb;([7=&E)>-+Q78KeYL=A3+I30.
fc[C-F,9B(Af7B>9D]5c>(1cWae1Gb2GASHO2ab4-:Y,Kg4G#E.-VF:VBa;b<+]F
-6@F.;B]gR^8WQ2/G#/+EcB:D(XLUAYP+I]>0@MX74dUPX]IWe&.\Y]=AD:UP4De
2UE>2D@ZN7-6G_Hg6=&8^NID+4CCP4+FDE<5GOGS&OT_4c^geJQ^568Qb.EFZ_/H
d&(5)aR(UXQ5gC3=H<MWNME3e^^\-AWXV_?#H\-T2[6XCXR5MGd=ebd6UJ&7@L97
B0:D7QQ\IOXEd/HMK6^:P/]gY50WG5#&QG,+MAAI(^0.VQd1C=;Z0/]H7<KV,MD3
0J(M+&S5O\OgGV2/XJD4B;HZ607_-4;+3d\2#2[g6U3.Tb-,W2,Q6cagUaEaVO\e
G7JD;0#RZ9&FcZRFCF<:C.eUX=0bN8;855EVg)>LdSf<,95XSJNI_+31R;A9+1W@
Z2E:3B&AGf-ZYEfB>/ZRH)((/@XH&D+fRaPfDWK6PbQPbWd#eLOAOegOg[8V.89Z
(-?\B0fRJ:43.^_</<5;UCcfdc[V/I_Z1)G5C^Be7dV?NaRH#fSX>P=Y]H?W1U+R
@FF]e8?O)fYZEE7R6HH\/YOcQ8Oc2UGPD<-Ug:I8UAA\]XF#[K[;4<V(0dL2ATY0
#6-N+)ZSLb+M@@S(&7(EIK-0L^Y?QZ7\?GWV;G=FJLHdEbSg.Qe,^K]9L>9&?:FT
/PeMU4AKd?G_A<ZH6Q-UM_#I]Q8\d@D8SDdJebF)EYZ?Xd9QSA8(M3Gf:BPIN)F6
[3aYKd(5;VI[]8QQ0BN.5R[OC?,)f61=a0WAPCTB+C8^_?&#WPQ]KCB/=NddE<g2
B\g&V1Ta/VbWHL-N=[I:?:\PO,5(E?2adM(KD2OCPC_bFfLW[ZA_#[-G6>)1X-TW
0A^LI8C3<]QGLM7_P4?e@_BK-Jedb)WM\f=M\K^e_GU4P,=2A-;69W@2ZfY._AZ5
T.-/U=&I./U(WgP_612gdW=E]Y,]Y.T/DRfLNL8@KE)2DE&FPKTE]fB:)KIA#G)=
:D/-TJ=CEfB+Vd1[#Q?L#0G_CNaV(4a@>e.C[1CeO[-7\eJ@]TUCX1+9,3GFR6>V
+&Y_D2H.W/8-Y+-2.T=KCDdFVE#_Od>3IV6Qe07b<g>2:U]1JE9PM<a&7=#)c+W6
Q9Q?IAaF8G1R=2L.4c^N[IBD/<,HBGNcD4(BMD.0C9,SgY<LN5PONW;eWQ&__cMX
AfVPDAG<2.8=Kabd2&T&K>X5EOHJA[g^;fg/UKN/<FTYGc_9f&FO=.W=.-QV[_dH
;F#HeQPe7E1#NS:U;CNC)(T3fa-NeOV;C[69ZRL8cSF_V=bU7./YMa;,H@NRgV)0
e#X.J@@=L>(Fb[I^8g(]VL=;3&:2W_ZA_N^\VQaa#6g:5=]E)9E</0]5WJD&0)\[
<Rd]IS0^M&APMKHNM+5Y)Q+:13fe^SS8]CgW[W/H(1B\MDOaOE@>R^bW#H)gG)4(
S?1NA>MO<U<[Xe=R3B=RL2S</^Z+28<<:BbC>LNF#QN00]L&TQE0e9Q=.1K0f;)M
+FR][Q]2G3.@T,->^@dcYgIMNE/4Wc&+#-V+[08eNQG>NbVWb#)K?_BP.LSFPJ=R
:VK]^]HVW-DgSK1XP+,fD^[)Kd7,:H/:I:ZMKQC0)<SC\7@4NeS@&aZcf.MPN/V9
/B0U8fW9YEVd,WU:&2BE4;;/)CDG(L]CPTfcZ2AbX=)0g?+YOUaeK7-R#7G6<\@B
Yb?Fc]HL7\QZON4H9.)_.e0M-W0H-97I>@T)c:Q-K#Z8QHcdIa8[G=HA+<D/4d/^
8:<T,P\-:;Q==/75:C3P?J+a[:1bD80TSW4e(Y#NNEbCRR9OR5e>+B)gL]dI@LC#
7_9)7)\M7\N6QR/>E1?1]60R6M^@UH/LAHfQ\->J^1CQGEa1>(OF),#6Y/C.-_]N
WXN;8fdAcdQS@IBA+UO_MaEaf,f-B-0D4dJ_dHcM9LMQHcU-1(Y=EUdH57ECMR(C
U>#J6TP\gSO@2f_L\R/-OOM8BKDHZ[Ecb]HJ.@\H=V[a80+7_JJ1(B)d>B^39F87
P9H>RdKR>[51X]4ZFBGPK5AEM.+fE/QbZXe+AE51X@]861f(Q)\\D52Q#U8C-AcQ
<C&L\I;e@7)1JIHBOK.904;62VZa+-V6+F:a_EPX>./0EHME=;IWc]_3]Z7LC_G3
<)EF=997EIEH.1+?J8F.D41DQg9MVaYKP+23]?,\@7<bL_2g<)BNf=<6F4RAcP/E
CN:)6>,0&;<LH8#.gNVHS<VT0-XQ6&>(-LH0+A,]@eE<MfA,c+070I3[YOD^d.aL
dcFEeK3^>^+N0=[HT(PL)BIc]JaMU;;I)Ye8&J^RQ>8T&EKC4@?.+:+IQM=,TIN>
G&.fSV+C=Y,d0WN:9OK)+B:L/Y@2J#BN<#=>,TWaMI4Qf],GL89:aDg7,;>MH#H&
51.[PEcQ-(#bESQ5&cM,G=@(6(I=&NB)F[#@\4+)?ORPP9D.g4_LK,@RcP:,FB@e
&7JP?TO]D0[3NI42-B?C4SL8>Cb.?:CN2AGK=7PF?XA.5?\\QEU+4:A(dB:fF_.d
FN@Q[b1eRM>DMJJFS+@F<]FcL_&69Q?A._7C9H#[#bJ&ZUT_2?LEEZ.b?\3+5.ED
34GKd9Z@\9JTb:UBbb68EJC<]FH.g@V<#X;#R@cPZ<8CSN7B2-3^R\e8:fF&;UD,
IJfaEP&PO0gc6\]]CF_R&NNY1\[@G5\8E\R&3>KSJWL+09)5PE//KCe)0+/O/HPe
GBaOC8N)fB[)U.5TJTUNWMI2gN=:(4)gWBKQe5KK#=M++OZREOfc8-e3+#J/A5_^
f1aK>J9UT^NR3M@Lb>#d-D<VC8L;(<AKTTBaF9XH9W7SGe1.[D24+C40[6+R-55]
CLBU\2Y,>-3XJ,-O4TeX&UTO2Y#484.?B[+\aQ6./a1@ZdJ9NcN=?V,eVMW^cY?R
J]_O;JHXCg2,1E(34Z\fa#J3fUQQb\(DCK7eX\V76]-C\b5IOGW,JeRRU9C6eZ>X
U;.PfAbdD=I@UIfR+W1G0-H9/D-eVg)VY&^dK)F21IdLb0LKF\bNbO2S2<;NHG6)
)ebZYT;5G<68U>=D\\EU_@HQ<\IfQ8:JG@5IVT^CZ>D&BR07Uc_X2XcO(R][>Z:[
T,JF/287J#<6?b2P/3@PUG6PT,P&ZLFCJNK_IddeL]F/P9_<&:5FH0>G;6^cO8eD
0(Ka,Yd/HS0aB+U3//>RM,.[F7Vg??<=4J-d#b<>P&U2K#.-&/93b@BE4L<1SbP(
g1dY3.4^D=DGE^@Z/D3)38d<#g^?-55SFX_?Z^@RO/B;?6VR;A:/>/Nf&W7d<aX(
X]FAIZ-(82N;B>0^)I>^N<U+g2-11O09>2NS]]gSJ/[=GK=W9/\M\HTA-g1FUB)3
=EQ\7#RTf3/=^:H7\g58>Of>5a1]c<<[]\[Jc>fQgc82ASG9B&CA7AgI-U15eK#g
U=e#&L3<gF]8+DH(8>=[J#8J>:F;5T19/g6[X/403?7J+/gH#1Ka,^;/^&6)^YF?
Y]Y-Gg/F13)&9BeP0B,TgFNX;7UOgeRLCcYP7.Tfa7<)T#JVZ))aNG#J0eEP6E98
.]&<f)c.C.SfQe\2?<7Z=;K\U]\b@Y/6EV3Z1<=SAY4+_&S=YO5A-8He:bWU:7:;
VD3b\UH)G&G>4+L7KfS=[[d;aG4+C4S&QD]VF&KbaWKR>3WP6:-,cRfSRCg\=dV3
3S#>Xc&f/C6H)/_;(=;P#UDX&2\08g;FBJJ]OSQS;#/EIDY5GFQ<@Z9XTPcR\d,f
#JL=R#KLLUa?\V_^#,)Cg_8IR_/BQbf&^@)O@R^.7UNP(MH9YL5BTQ&dD]7#&=-&
=#^Y#8.]?1fVDH0;F[\TVaUQ/0QF@e;6D^9^/2G_]@-IX9afQXIM0R:]35#TS8P?
,Ig&^E-CZgU264Tg=]QgMT^1;X9R/bFG)BN/ZK_6Q7;2I4e].,e)-/Z1X#+9Q-7Q
N\6ZZJdU=XOK+O5HGCa@9Yab4B08\U;5TU,Bc3&49N-ZZF+@13ETGg:WVXJ\#JJ.
Z;<K?QLEV\;A4XUgM3LfQ.DZ4dN2_AP(F)=?d@(UBW:>#@4eBHKYHcTeM_a[#2bU
G4)@b5KKd0Wf:[gF3?0RA6=M[40EJE>fgN8V.4]@<eIPaI<eXTe,>;:E3,+/)]>&
35U](C+0bQ#IG6F@_L-9,U?H?V4cD0AJ>>b>Z-+:a(LCMU?_#-#\OU5S46cE8^LD
FN7:3d29;599cH-<9F[1V,>TP[IQgg8>\)+dL[I#^HVW9,QX/F4XB_+)e[;=cIV#
DSaeU-C8A?bM3SQeU5RBS5RVTG#LM2YYN+#R^@[C>gBN[4/D&X&]&ORFY6gQE,,M
QN=OKA<I3;UcR\8B))H&Y51fe?1(OAQcJ67B)-BODWg@MXPHF)U<6[D2Y<c]b3#4
)E]I8[2F4VWKN/&a40R(47Xaa7TIYJHIAB&AI&M2^]\b@#gDcY2_N:2C]GV\Y/R#
_,4R-7X.)BPJHQR4Q[BBf)42R8,G@CY#I)?=NMY:cXB/=5IG]?c.CR6##=R<S)BR
6B+cb]fbUC)4c@FVM,KC#5#WKIOLZ8C.e;H0R3DX;9Wa(ML)K:]Q:d8>1<9?d,+&
/=Od_0U,T).6;<aDZSW/=<J2;TB.EX<a_G9c]HXXGSW.g9S-2,#.]DJX\d:\]:bX
KDQC718c;)I?V>B\H;fX2S7c&=A>;+,HYJg[g74[LAJ>Xa82[_I_PEWa#-[#J@98
_NUT.C@]BUY,GMFDP@)JTfLPNR2Na=YRUVa4I#ObVD)TdG(;CdX^TDJTR9F=I+QL
.P>?3=;&,04?0;d7Y);UKgU)Ud(>?2(-9K4,e9gH/,:3^9_+bfZ_>;]V]@>IG9D9
PaX7XMNMW1>0#/;g1,7VDCY8S\BN6X+MVe>_CKdcdCWIfH2eTNf9Y1TGZ?9eOI:U
f/IRQX?V+TNe5MR/VWX[bP:UL+K,.)HG/Q_.1L,#_f,4Y9Y(]LMNH+2:AQG[=[W?
@2\H+:S#L+KeUeA^()B8G8[W=Q8G4EF@(]A),fEPOaQI^\7HX9O&fB@[c/(U:,_+
&>BTUf#,5:ACPd9-308gGU7a-,aV(&_F?]dVba[f,STW&N00b]Fb^JcdN_SZb_/M
<W/2;FG)Y^3^SS0Y8/;G7c?:GgLS6#M:S[<U@AQQ]@D5,QcQfTc3dR0]+([-T1L-
LJU1\7L&cSf#Xg5:X&7geNGeP?Qc8S&XPPc?1^-\CNE:96AR+M,._d;AVM908@LN
=:[2F3bZT>+@bD8GK]a8bN8?/f[+U\be-.MHS7Y2C\_J[=AZC<547V=QX+;V-M=.
(31[#,f&6;-,7E/dO\#]c1c7IJEJCL5B<#]cO\((?T0H<YGL9X&C8KGY+RQK5P<[
1,W_?3]M:S4bd5V-C(/@]4CU)F)?@VD4PF2X0XA@MK6#>EbC\.K;e@@YA;f<IQ7Y
?P0b0LU4Df[OJ1T[aU[T86=,/.414^)4+P/ZS&HEO&Wa=4.N8YEI1AJWK#R5:cO=
Bg[.)Q2d8?-SW>YUf/CI7gJLZ1X8NL@[4RCN@G?1,V854^5NbSZBHN15a0/](7(O
PCag8cAOT[AV/V[D64;P3=0#fD89D&5@]B74)9EaD;^F#Q+Ff)(O_1P29T90:-W[
cLU^W4&]ee&NG&UC<YO^ZZ<L]d.=JD7d[<D+7@8b6;YR1HcNY:,3_A++eWD<[.(N
<Mc_KSU1Uf][@3#_N+dKacG+QVX?@^XAP-+PF45\geMUf(Re,2)GbNEDHIV\De<Q
\5XC\4<Ug?I3)OG/XOQN&Z?6C7LVT.?L9U4K7(8HH/BB_)K1UL@):IKUTO&?DBeY
,ga-5.ZfXR<]EBG\P(2Y4/88SF]&ICaBR7Ne@^F)dTHc>+O[4N45LJ^=?39^?O4-
->?]APeNf<GE[Y@Qf-TY#IH]0TJ]3:QBe?GTT0@&.KET;752g?]JLJL]7ER#+,If
RQL02G8#D;4R-,6gSY,M?FTRMLM\fQ_+(-^)_-=Z-=^+L2WOaN0L?)B+.D[H-1EF
22WEaCe]PA2&JaFPV]Gef.V3H?),B\+b4@@0Oe]6bZHf>GgKXHQS.BU7;4[1?;_8
&b7.-MH1:+T/6\P85&gUGZa5;XHfSD@[=6RN(fBC_=[VZ8+^We=DZ/O@GL):NKX9
>Q2).D9]Cd:f0MJMZ&MLNcbd/&cHUW:4Y]c=f^aTVddEZT=Je:dZ3XY(76/AS=.S
L1UN3Vbe((K.=:[HeGCH_DJ#fcI.<6+QHB8E87)>U(VDB?;^^E&EM_XFONZR4^MZ
D4XSZ5K.I3I8^9?c+OBW68<6Lg#4Ub+BfLdGDU4SPET_eFCcK-?_,d?;1/>\]17:
Ff?IEeRR\NP:Q64_I=9T)C\(.f>\92?/2=/FPdNJKFF+#<00gH8:;^Z#M-07L2(]
<S#MG.T7I/R9)LXL8>d1U?T>+9WLCDW#I#\UV[V+77;+H$
`endprotected


`endif // GUARD_SVT_DATA_QUEUE_ITER_SV
