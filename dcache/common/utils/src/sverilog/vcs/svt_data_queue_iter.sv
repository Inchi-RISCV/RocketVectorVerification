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
=ROSX4[CG1M-c2.1P=<VFC:)T&CBCF7E_/-AI3/<Gf(FV;,QE)UQ0(WE4_+Y@LF+
YTIYQ[/fEXWdWEI?0ADB/;WJ77)e=b?@/A83bd>^e,SVaL&F1Z)/-JNC=+cMK&eg
T_c4-<][H[T9ECAAN<Ne-CYGV,BAc=/>8&^ZP)CM2&[d/@9]W7APgH4;Wa]?.IFX
0[&F+:QMe4@a/[gGPGf<VcT#TT/aH>fB9^@U?#a[#(>&[RF4J10YT.?FYfB<?Y3S
L>bX\1g@8:?cc5C6^02>aYeX&0&,&C9dceSgA<SI-B/UG[3c45NW=S375CF@:>20
Ef53(/2@ESJS>LR1#f#(_&GI##93c^/NBc+D)LaTdB&b)V:^(O6fXMb=D+C@;5,E
6)dNP)d/ba2+_g3>ITPX6&KI\LN2:Y?ebHA9.,+4LABMQC^:9PY/OScg)<+^6Uf-
&92=+/)M/<[MYOS3ZHYBAAA\\b_^[B;,a4B>2^Q[2PJN1S6.W-bYEAQNCLVZZ86,
?M_:gC+TY)G0]eOdKOW]]6J0JWH8APBbOc?3R@Q4#A2^;H#\gQ&(:BAUO&,YN?LQ
S9:=Y2d;SX^Da.[-R8TBWH&.=5IMd2A+S+SePHJQCC(K5@W;]\;ALA9Uf\cG0NX:
bM/_Z8_0B@SXbR]fbGO><CWPbYG,^YTBZ_=\NC5,KFGcNW&QGW0a+10+(>b:PD8E
>TddAJ\YJ.T^MB6ILL[GPGb)#c&7IC@Id46g+5QRLZ^ac=PGS?;Y;J.KXVgQ7@<\
1N-5LY@D@\P\JRJ20DHB0CFP(AcVLa9UO.02;O,O0_Y?QWaSB.ENQ&+:VVNK;S8f
0=F@[XYZH[(@#2EI3e&E;JSZOK0S&&@R4@B?GA87[(Z0Pf^[Y&bSR+7-8M^<6&4N
/3#&bGV=0E_:7A9UA(43,;)N>J:9MP)F#g@GL(O9OE8[Yd003DQ,;8U:/\8(?T6Q
1OEM?QH=dLYL:ROQHOP]KPWW,L.U&^]INf6[#:>H_c(5Da@N<cN95ENPO\d,)V^=
a(86eW5<6J.ENAL:2/<W=WKOB.K;b08EG1NX8bAPIc(I6Te<-);2IDXdTHaD8ZJ9
NPJ3TNHJ#NKE(B,g.#]6VJ[QTTI?FXQ&>CDWGAgIUSU<);8]V47@.M;0-I+Oa\O2
>>HIaL=9G4g&V;dOZ@6dE^&<]CRS-a)Re_L[D3]FZV\2<0;G4JP?7;1,MaCY65NX
ERb?0QL#S_cAbK.U^:3FTG9#D^(#J:M9)P8gK=@=f]Z_Lf)?a\[f\?f@df.:>(F-
D^SRF&J1.L3+2AgQa@>C#gS.=4747,b2V0\LI,4E;])NJ&-O[1>C>>HR6O1I98EX
(2.ATcC[0\;]9e)F#[AL:/>2b\90b=\DF?6C(^YXMd+#(e\1K1,/ag2K7fN5MP-V
[OFFVRMa-0d..L0/+/Kc(.U7LR>0&,bLV]_LP[LQ9S@3Z4Ge\.F+G#)dZM[=\J4+
9O:e@)YY<<9IaJ-UL5SG);HW\).SX=#2-?J^JF4,.><e+<(beLD6_PK.0N@Y8bRa
<H7+XXROd>#b&.WTU<>ML\9T^[^e[XQKU5?D@9b1FY,.g#V:+2U^^=U<.R;2+a:2
4<D&;V>eT?Z4&LKc>E0ef@18EML6T7de3&.&e,,XE#Q&8R-.#@VR>gXI>DZ/;SC.
.)LAWCA;?[-[J;bEFBF=[0EAX98EV(<NXQE0dCA1[F,.@)I9A\f3M=TU/A\PfAaJ
bVC13]GdS+FZbHfQ=M1B-2G.7/1&LW1:&(])774=,JeYaVV2?YSfN6aSHL+&;FU/
+2G.;f^^bAH(#5CUa:<RX+>@)BJd__WfcN,FJC>I@;ET\1>[+47UA#:HMK#F0-64
]-DTR\>R>S.QcW+<IA#Mf(>_;+K7bJN,VI/=:T>FVLW\P<G:B\8.=fcT\W4X0I;I
F8F=43/W4;:#>eEc&S5RH1&G^)b-OLZMQASa3gI:6VNSGUBGK#Z7/Y^8&+F8BOa@
?K0V@PMU^bYb4bQgceY42KZ73(YSYK0V&?X7+4LVHI)3V309#8EC0W&Y:3VG;,7#
Xg59_?Ba<_Y>bC^XL(,_:POD;Q/3\]E].60AFX1[/#@+6LS2.gEKY1gbaK:1V?SQ
;.T6BUIH,XW/AZ<.C5<dd?&UR\1_U\H<@Sa=86?7-T#UJRdNd+Xc\Q^^[6@FdaAT
=ET(\NK&]I[P)b0&M<<OT-,f@64OF64b8R[CRZO>4Q,c/XG3>WfF9[;]2ZI:f].W
@8Vb.M3MaHKID[eg7f<b0eUDNF/Ha>:B0IZ5TS2/Sa2KPN7R5EZ1Ca])EM5&Y7KA
HN[e@2DeBM]11A&P9SY0GMP;EdIOFf0+MDd:EWD=FX=8@QJ9<FV?VMO/\2W&5e&1
<XI+TVg]?d.)RF8Z(A74(_<04(QF5IZ#E+?a<]OYLK3JD[YGZ5#-[_gSGc?AHZPd
25>&)0QH+K]BMXL7ELfCS(EL\FQgdFQV:b&]:&4KX_\dSdE+c97_7ZTQb@Fb]BBN
U9+TB?+)>#G4#+@^3^&8Y<IA>HM9Z@CHb<SZD3,d(NC.>2XS]-#Y/84:]Na=068R
2LFX<-e6R^L8E9LU-Q]Da/8Z[-Q\0W3L^2eG/LU)WGdB8@:fM[^>T.D)(EN+1>-R
cJ=Wd7g1[]^H-Df3H6aZ+e[;TdPb#3HT<0(41Qg32/H8@4<HUK2R4VG=[>QBB328
+6V=<\S<9MSe7P:?QJeNCUEA0QEg_W=-@O]3?_2:0?-(gH\/WL^2P_g<MRb_GPF(
(,bOf=;Z7VG75G&W3C&PZUB:1A-/H0\0=agDRVOD\:NS\ecfDH_0?R.U:F\LC8NR
Z[aX1DD9\D=(Pg\,7IUC.=62\;fVJ<aVWZ1=XCR]O)b;_8I2H6BND0/>6,d5[^-7
CcGD^fHSG\L(R(?G2G1_C4+0MUEMfOX8--QbOK[)C=cBEPF+&:Z_aM#<a8QcTD_\
>Y?H7@dQ_<KIfYY9+Pa?(M38GJ3]((3<=KP3T<HRN=[J9RLP?Og-?R,=<\6EfZ9]
7DQ\=<0g6,EC.UVJSN55cRG82#RWNWHW&&=^YWZZMFf[8X3]Nc7QD07#374d7JJ>
bK-/F.=AQ(2;O-^D<3\@4]e;5&fg@4ZF#_^cKb=#I;40HY/;K/3BV>6b]/+(P]g7
A#>Q2YFA2cSQQdMLU6E1Na,=d]Z[8:QMY+OKEf^eM;.ETEb1UDY0>4X78dMEMgJX
..+FR<M^^>+=X[IV0DUP@Y2-[RIQS-W26g3FgO)U6b,B9W\_MVRdfNN8^=bH3cH&
XYH7d)LE;-/B8]Q9^-BGOeBY1TOHZbLBA&2NZ5N9<T@+;73]1TN3KUeeY_+\U=Rc
VZZCa?ee:.I&baPNM+=HOOCffb2?H4_;0]eX7dVX+Md>)-GI6[+>(bGaX1[,Ta[X
MAM#;35-@]APUQf@7.71I5N9#>XUK@eb9?8;MGg0I3U09)/;-.\\Zg)LI7XX<:fQ
[&R_U1bbKT/</.M_)VC:?+U^[C)2aG5\f&->cHgYbIbdB_[F5V=R/BI:&S1X(c1D
Wc5Ed-a0P_^/;LX.RSSGVS;9gRWgK-/bAGDd4W_U)<SEge\#.SAG5@,g&e27@XVQ
0)B6KK(@=cbQFORF@dYF6)N:bbS,g+3::6b)+L]P.W1/.<IfJOT<)M[68W^H23[Y
L/[),=)/Na2JXcXT6_R\\AIG4R771g6W:Z_Ab2ae?3\gd979.;c[=dAM-Jgc4JAA
VeRXcgB&5<5:/Y082W6U#Of-CcMV#+DIS/)7>STYLcF7A_d,>ZR]I^T7f@#C7I6]
QI=5Kd&\?e.X90HF0SO0LMb1>F&Q[\IZSC@]84VX]F.P.J)_K;<21Q^XU)HQ6R)I
0.^aOQBGCC/751^C=B;WQDI(g#C;A,94_f3#g:_bC(g1CcP,8Hag01Ogd2U#\@^9
6f+LS5UK(Ea)-:>]\e#UFAdWW+<aKY0./@N&a_Z9?D,<L5JIJJ/4<aH=N>bAP8D+
07WEXAL]T9VMI_6gKJF?01D47=>]X.)HQ:;JZR&CV;+UV4_V<\3<1I)Y:?^MbM\3
#e?9G?VHfQggRR:G&\-Y.@38A-X(Q0H1e,OVLO-G9b+T1X;CU]QES/7.Kd2+JE(0
Nb3X=aSSH8+<Y=Q(O=G;A/3@T=Cc;dFYT.DNS^@LF;0?P_9PN=OGJ__GXf<C?VIP
89MgaH:&@LcS0IPAc3HVF-<]b1\/,GT-Y^YN]->#<F=;BI0RTb>KDS\JV5G\cf:S
TSZB#?\44?/H3,?N)4WZc=]F0W+><3P0HPg^MAK3;b0I0CGQ,@aaQ8JcA]_=AMR2
L-Qa8O/#O(@M)IR^DD6Dd_JB(9^3E&ZNP/B.)?YBaT.A.+;V64J3Q]c=Q^S4]#7B
8KV9b/L\XX/c\V3Uf:_/OX6&37Cd[&Y<;\ZZ?GO(O,]?AX&bO[FUU+GGS\^Z#L.F
4?275).;Z7S^INA\2WO66IF(7eSEYVRa@]4)9#NA[ZV.^77_W0BM+bgFB3X_;;9=
OWca9QIZHDE:a3b))c&F5b,1SaA4PN\Nb#e&gFBSUB0&-g=fed)OXVd_TT:I.^Q.
&6O:V/WVGA,:U+O3<VK=7b[T;+S2T;V1/HZ&#gBE(5>PC_RC&B_)JB#W59YM]<9a
RDK,d)Y.RA5EF@.fK03X?dER_RI76:A0d]-<Q+<2RaE7+Acd=S\Jd4\842+0dLAI
\OKI\>=ZcFg7INNAA8A2(]dD7NJIJ7;Z5;Nf3P,H<WM]W-L(3OLCK?)WSANeB+<L
d(3E1.eQ-L[J9,1G81>IF8+X;J+JS]TcPc8V>/OE;4TH:HK]#\AN5K]\Y+Z&@d5\
9;E_2:+K[B1aI+LS@,=DL9Pd=+e1GB:X):]?89\FRR1Q#?f#T3?X1=_JE-ScTJ6g
>K.feQ+E#T=8Abb-cWK9G+2O\1_FOB8gLd_@6YKGT4XUOB_/E4YEDW&UX.E7<+@]
]>5M?>A^1=+a1D7]f3,\;cCWK941EF4684,//;EC@e)5L\Ac1G1ES[>9)J/5;bAd
_HgGEAe(8.4.)7gIY9L[Q5QAZX^:Kg^HT/:S-^<b_Y\F-3QcbDX.D^3[5\:EO0OR
61d:eR-d<AX&:E?[FBIH1AF6XRc^AD.cN[OQ6L](f_)3CE5?,S&([+)IV+\&[Z@D
\DNUcVIB-JBAab/D81=:/LXL@O0I&I=N?GXEdLEGPEPb@J;:E5EEV?KHS,.C;fIb
PH9<?dfLBIVD+O70gW-:D7;S<8P[)3f9XB]E5B/B(Y[c:[0UHSD=)FUF.c69),@S
0#dQa,\^:JYa<7a0g,H0AcLFT2TX)0+QT<##9:\NLL/G?QJEZJ)L^U[fb_WB;019
&#=f/Je;T-:(0V2X_P260S)A;D3f@Nd,-\SZZNcRZ[:Da+VZ;&D1=T\/QbO-,Z<B
]A)BKaa&9Q[PM/0N(TZ<(MHGC>;.=aS&OQe@]7)PZFUB.#;H4F:6d;eCc.aCVcbe
JfZa6S5dQ-[&<-45Z6?dJaX^GC@\VBJ)GH2O1:ca=Q2A;K1:f.Z^IM,aV5,gOaW-
Ja.SL3,L3c:6+X/]7G,-U5K5-b(f28L98XB4d^cHN)?XR4Q5Vb)CeFZ=S1O)745c
AS;?X3Z<9BO[G8IBP=#DF#Y..+NX<BF#G7HMdcV^O=FWDRT<LN6=dOU64TZ6::-g
M-843bXDVYA:KCUYX9H]Z#Q:FKK>VNgfIZ0-,(K_gdGY&)J<.D8GY)JCR]@abT.F
D]3;?:C3N<Z=/>:@Q,MZKLI7BCEX&edY?N?_0N^R8YO3bLY_IR\T=f0c)ZddG(EY
a8VWb38bcN@g.W?.NPVOCU=U:[RC-SXbBc(UOO8P;&3c&/D/46<^2FY+CN.aH246
&>&8Z)5N>=]c-^^51.cF<<=a:5K]<O0)H^;^.cB8T(I&S?1)V>LE_eW._E)37Z2c
SQ9^gPIN6gdP?>#FLU6_I]NN6<=\M5?6,5dH66RaF=JULW<]3Zb-CL8f\K^HSd63
[Ve>BaWObX#dOL8dcD.#N9)93EFUZ.,BaB2b<^gY]LBMUd_Y-gJL4;V5\:T)+KX.
P\gfN0ODPF(UB;a7)M/_f#O2HHJV-J@D2;IH]fg)L0Y1;ag?YV4GH=\cZ=Y14)G2
?B(,/^\>R6Y.ee09.TP\2Ea?LcM#0U59/:\Xe]O].<Pd#5N(4P?H[=Fe>MU]\XO-
<JABAL#a:0O]a)eWKGGE[XZ2K(?<(<5d@bO?1_6f&=)H0fSIa1PV]\a@>+?0e?VE
EAPT=YBRg+0#VGIZ+CfDEB=;(S1?[SH6EIP-<F)^TD[O2=?N=ZDKD[ZFR;JR,BGV
2G^E\]3^OcIFe^QJAK+2cHJ.C-&9C?K8>9HDe+[QdUDV+1__,aSbOVWg/_=CK7d1
K?CN[gN[OL[:G1CW^BW?CR5]b70AH/9[+O6bX6a];;X>e)&?(V>NOM,feNc<f@NM
S--7(TC\8;#RWI5QF@:\)TdHA4d710]F\_^XB;<BK4+3]3^2gO7LA78N._>3MTXE
e7Y^E&d7bM+]d@D73#c0_IbBfZ(>&JOGd7GSE,GN/YaMH;O(]]V)^B5Ocfa4\5ec
]aH>:b/?M[R:ec5G:;:)>d1G>I#]\1X4Zd2bAT(]gaTc][6<eZ=]aXT#I:>I@HNE
G1a_K5=(]B/Z/A7GFUK1?=CLU4cDcPZM9;5_?JG7LV[.IN-C:d6Y4#?Z_\.8Q:24
.XO:Va#f<U?g?7WP3?=QLa>JbU<O)Q]TZ^WP[/UH.3I^L>VD/)-fa6\]CBHD-&N#
dg[D+)L(#O@,ff@a&J2Cea45.OCP+<3TF.2NKON,79+@=&:b51M3IRDE=f?=gP0Z
Dd;(P@Y.RN^V.#H3?WFW[/7QZJ5,NL\d2/3bS68U4P>=ROEKQI^EQ4,bU.9eRS-a
/bG2W-g3I(T0_L7<C&X7[c=>U8#NfVc])XH5L4X1-d=c-1H_VgHDS@TVbU2FNVe:
+HNUZ@b(@O7)bZJb8g7dU91[/V#O^9U@A^8Y-4VA8..,2C_.UO=Q;TaeQ025,?B5
Y<CF@_]ONCT,YK3HD_@6E241QPPNb4ZG_W1K1@T_?J+38G#)fN-Z&@0=c-MOc@Q8
U-_cOJJXB(df@=8d5MY(77I4afRUZb(:a\FcWU5,+-TDHZ(5SSe4c?YKg-5[3R(O
.,WJf^@L,gH#3GZ.&e@=3M;<PDV<9F72EcRNdJXQc4LE=H4,-X[,P/dQE>[XE\F.
+P,9d3K<ZA^eO?c()58M;P8>;D_C.D]d=Z36Q]:BSNfM@b>?c&#UJL(;1JX8&S/Q
=9\<d?X(W+R_:Nc[MI5+&2+#J.A]N[N</c-CBg:(=VVcbHLMQ-<=6OX_1D?95+?5
2,a[V_Ea(OF/3RFUSd9Z#bU=<PY430SEcT0VJP\Q4e4W8PN[(;@QQ?>e),2DW)2)
;XOJXJ=UO1&4&CG(C6,E[1R)&ER5b4=fGI-(X(J.Zg6/37(QUf5U>R\,#FaLZ/?G
;3?Z3.HXM)INJ;V)^N>62#,HBaaE5552d#A:;2LQN9KT^DY,g<8(2J.\]X115E;A
dRST^D5KBUP>/_4C0P&@O&2MZAB/e&e3a0/_;_\]_U&d\D+5Q&Z&\._>\M+RZ^7X
5]OJWC)98MC,JdO8YG3>2^PZ4OE[U3,5WQY+K;4O:H@Q9FVNBVfV)>OJ)8;a@gK@
=G<E6EY0<Ia>^aITQ4T;4N,Q3M/9DZ^?^E?:ZWH5ME71S.9^)LH4BDg+B<&;Q&^C
<<F4N@D7W0,@I]cfRbG0,,U?1,,.4NY]-QKbPVI]AHOR3-,]P(I,COd)&Q&DH(6@
f>E/>bLb-:4a[<a\(<B/LB@O8e0P;;Y2c\b4[S72@5aF8?;^UMXc8F+=#PIIJ\-N
;B#EK+>c5>8/<G2[0DK;fGLHc9Y6Z0J/>_/5>:c)RCBGcCUd::11+]ZL=+\F_RcV
Ba-aaHeS4X^0aV?T\GW:.UG<Eg8db4-?A\_5VXg,9Cd\2TJQ?P;ESYGN]RF]0G)K
3>UaDWT-K5d<P61P&H5WTd::<?Sc_gDfO7X_L5_)E:ZDAW6\>ABW?#_Q<2bUP1d3
Y.F:b[cgT@1-1CC+)>??7//&G=7USZ4&bg7+H0@WeW3_c6[.8e6DP;=>ON\YL+XY
Q(3E+N4TKL:BE5X[N_)O>RDOA2RR38+FfJ1Y.ZBed=Y2BP]\5M0\.f_X/:gO#V_C
6Z_G9IUBK&I:@@G(67.?J-RYUH8]BX&E>O4@E2:FZ<IGJ8.Hd.TAFVFL6BN4#<VH
/M8A[gG=Qe-DQ]@N]>?&P4Sce^Q+ea>0I\DN]&WKf4e<8<#Q<f5DY)(+Zb7Ee+g_
DJ+a6PJMPg6f4&=83CdRBaa0g\P\f70??T?CaMf3#8+AI)R,,,M)SFICH6KYI@KH
\[H<78#P(eV61@,=/SIb=^6U9A]A+dS\63Wg[FQ[WU&@:4PAIW(gLZ/\[U4@=7SO
-dB3Y0\\BBHQ@0J/P@Uc9#4[f7K4L3g@P7-2\/&AI/=:.):&cQHcC#&65I0C8H^H
AW6(T.-13P1#TZLe##O_?\e.XP1O[GL&6BEQB=G)OFa6Pg/V6GG^[c0XFd1LPN/H
#e_WACO,5,VOH@041>09;1=FLg_,@]&730>R/-YB(=\BJYEgA#2)YHK[Y7.MF#XH
Z&4Te\DWOR#,+bQbPac,G8@L?4Q8;WQaS,^0@O#FYR+8S;53c210EgS#V0dM<9RM
/QKZ,^JcfW][==N_HI/gONY=b3D]^;UJ-7N()/WZYX=G=f(<&P=CMC2Q_Y5]B^[Y
/IC:KPH^L?,Y0:UWB88)+[?>U\OO>C]Ga1L[dcDc/b@KG2)9U?D+>IKYRfVJ)R1f
e&SYcEN1b2PP,E78(Uc?P:2EdB>=G>RP5gPYAL3_.=Q:7RZ\93.(M/T;AN+T5c6-
GUU\Vd(60;G9VTSQH,W,6BD6XOE1GDZ[^\&E8JTQ00daDLSd_,f/QO29C(5PYP=L
NN>W_U,XES]Y-ZG:=&8UPd.)b59WPHF@-0Z.<L.[b?S6Zg/8RcBdJ#J2PK(_(N.R
V&dC(gA7_T_01Q-:6+;M/I+AAg3Ifg)a3.@RALC)N9V^,Yf@f(5gPUaf/e,AD^-L
DW:>=HON(Pg1R_K5@C)=9_ER+:K/g2)CIIB9R#==V,,T[TP2H\gf=;1f@#V<+Y84
,8eRIX1,JSDL1aJ?<effL78.KXLY[gW#ULeNJ&YVL_Y3>f9RYIUg60U6C&GJX3U>
V]2IaF=5<1HG-7QE;ecT53@JG,8-bZRTWH\7HfZ:-H0Qa6KG3,B+aGAf1BWHVW5,
JUZ.f4J-Od&VS(_L?<G1e,G8S3.cVBUF>?Tf58@e:eVaRfJX+/\[#YZ10I@BH([_
?@SHZ;,C8M_P-[RdG.&fSP<E(S>N,a4RHZgH@8)K^6)#a:CRJ^F3/,[<=9/8b2(.
&aeR0gJO><7_M:&M(Y<;E1f#BCDCQfB?T<7Z0Qc5#-3PNQZ(,29AF#:G+E>ZGMd+
?&Pb8F/e^H9:3QC0(NfU@R/PYWK(N[,[cG<-M<D=J>9[DS#B0>1]2YY;D4NQ(C7O
?e&=/?C[>CB8/O05Q=\BAAN2^HLH5c1&1-JO)SIJV9JYLLH+\a&f+-G1HdHcRO89
ba>)E>;aRS&fAP^&(<F.H<Y9R7c(,2+UEPAPG<49_(f3LW(-,V=BY+16dVE;_Jb_
3[a0+;<cW&.M-0g88b#-42(]cN47J&dCAPFZ,c]AH4EUS)_aYdP_J1Pga,>\=QPb
G2]a^<YOg0=dI3G/L&6JA2FKHgJ]f=P5bJEI_]@O2f+S@<NI>eZgDB-_/_?)ZaM]
(DB3_/>2cDBM=L(2S)S<+0eT3(7GQOR;DW(b9BA\[JCVWQ2=Z\FE6)F4=gB9?cPB
<BHQ+]A7.g>:LA#;JBRY@WQ9G)Y=JK3PIDZ<]P83ZE-ZE8#_M^c:UJ_Cab[Ke&6e
WDPZ.7PM-TbfSDB4G.f/g(9dR56Y?>R)YGCTMP#c[^QRMFd,=/9?7^U(]R@H7Ff(
R^4&NKYG_cVCI[0KRRcZRD7(4>M>TZYHJH(1)18IfU^3#IKL;E10216aFEg(T-d@
G0f[ZcOQ_+CPfB9F1YYW-U6g>;3X9K>+MS\-[3-XdXgP/D85@1@O?#92-58F_gG9
6bL&SE[ZVLMA/H[6T:e&-?/Z8HbJ[#IfNHV\ZW\R[3;U>O@HaU9(]<5XYHAL;U/D
-#[W;]T4TQ^24D,<Z(U4C/G8)+3LS\>5MeMZPECH>6^NWVK:D)H]VU1,KMXb>@CY
d6]&P.M9K33>H#,7YC(M_2a/U7KV/M+2D#5Y8&R78QE\F.W5Q3S#U,\ZE3@+L77T
8ZA&)-K0.M7e+KMT.\3a]_L1da^D>KN,U?=bd>Y8Yg]&1ODUf^1R#YD)OIIOWcc#
ZPg,Z7e4.2.M:>(:\b/\;171KX_[=\f6&0P/69BNKIgV]T0-LBNT-@;O)]fB/VLf
W^5--Y?H?XR(TH79Zd\_]:<.H)IHR[M7g#\D5O9BW5=LaY>\=]J_e[8g][a(^(G<
VMMB5>S0R&EL9aRa>NY1V1QbA\_V/8SP6:9e9<C[&b4e_,KHb;W[8_1gM:740S,@
B-B.W,X/2G>d+HVMO21(JN-Q],a7LD^J_MWC@UF5>-CSfM8LZ8N<M&1KGU\R-eBX
:>05KUZ8K=+a7VD7ROCW>67b7f[1@X=7ZQ0TNA>O6T-^1VH-;eeR/6O4f7[7:<T:
;6b)g1^TM1E]82b#)]5&gfY4VNP:\5RHLF)4&MC@gEL+:W/DFWP#H\<RRKI#0QID
cPOD2E^8L>5[gG:L\]>g/eUMKg04]D95:Ob1UQAW&-B#Z;/?QONOB>8MAA>/Wg(V
K)EL.5/,STIcbdAW[T1UfX0WGFCO@+6.KYD<#Y#H[T4Y:\e\>=eY0UaRXXVP(3)D
G8CT12EGSI(4]R]O2XH+.\GJ&9#MY&V40_=ONHdKJ=JA:2_:Y^c\R5e=98WYEaV0
?2N0Af1;7EG-W/)#^[KXeQ[G#9)V51I><,2]G=b=CM3+O?#7][]NYCZ@U1_V:e1c
Q^1#W:9,B;KHV\95B5(CD#HC;B,XI\O@<YbC26#:7SQ(9)d3e5.a<@(LMPW@E-9Z
5K4Y\_W9>/@/LS.YDe(+)F+fTVM,W2abD#OZXLaf\^N,]CU;28J9<6D,9BeW\D(/
dXXD2\1:^Gf6e9M?=??&WC3=Y3AF5MWHUGEFWgQb/N&Q:+;4)/.,U/EDC8I+J5X<
ScRZGMRHV0K?KIL;WI-a_H]3Tb=LY=<8I<8R9M77I_FR>0?@19MMb^Q.4SFb9e^c
_46g8G@dV[=ZP(gb5e[7]RSP9FR)G^,2a1bf7Ya1UAcM[3PAK47KEVO,\eU\6Zc2
OeFM0Z9YWP>D(SE1ZaCE_?W0^]WK3]T[@:._9C#FGKUBZK,4VCcKc&]]#]Y>.VW0
_Z8EBPZ]#VLJg]8;=J8KJHM(Z>Bb:XWZ-9?0DJd/XR55V:<bB@7_]J4T&1\cN-E;
Z<4L5eHB,5&R0BE]c)>ZfMW?7dR0.)EFU]VV0+MF;Z0=d0f-#/8:?A;faKDa2HA7
5Oe@@;VbA3(QfUg^f65MHCXBQ,Y,Q[QcBd]^Zg;/EW..F9PR+<fR^cGZJ5D>+^OF
#@4PIUag:4;:Z;B0gg17W4,e>Q+ZSK2[\=ca,0eMQBE9[_/bSDEL^66XLe7HH)48
RU06/UPL8BB.X&8AaD8Y1_13#VW0(^]P9C.=1]BXK_ZMH@cMXVeT10O5-Xe//]L0
,)=A\S]ZK89dI)QN[=1E>ed>V.Q+8^D[_/19eDPF^CCN-=Mg3JFWMK&0V66@/Z8L
X_BR9FLMG/bRQYSWfW>;,],71Z)/DC]4cKY3fJCU\W[5EOLCOSgCXGcO4ZfLZAH[
G:Zd<E:?#I7PHCTfB0C5GJAH+^;:8UF[+Q/M]J)0)cd3T)Eg/TaaKK&E]ZQIWe_#
F(KJRdI8e<g5Se:@4@=0?3^gT==O8N.aNDEG=DJ=e.d>3T)B4M6M;.?[<=((W5Q+
_b5YI?2caNA.7SGP7g8&Yf9Y&eONd-eWRcD;87=cP^L/[4)Id@2]#d:MHe.68[Y4
D-/42_bDdJVcR/cJ5[K];BC9_e._OSH:,\D.J21-+e6,64#Fbc_c((ef>6\D@9M#
:2c9/Eb+,)MW(e+?7=bO6S\]ZXA,FH38@KA6+2650B9YMO-QB>6AILQFG^)N>M^S
Z;LNNDH(TFc2\-fc#OJJ8BQZ_(P;SD2CAg=3G=&F[5PIZD&,CT3=GYDM@J4Q\FX9
6d)SW8XEfP-QCE<8NHP<Z#G:NM_^]aU<UY-fR+3O>3Sa0LT3Q5Wc,=&c,KbZI_XI
-7L;ZGDB(SHFN&Y9LH\=O&3aaZ+QQeMG0=;(70(52&<C@Y=aXY+9BTXG&?I;E,P#
d\U/F:S7KVS([M+SI\c:)#/Q6,;;1cAIYSbFT#gU)1fB.:f<#8+EVF[6JP\)ecVO
)f/ZeeH\B@]O_Y>K?O/M=2f_V)bA/X?F?dF:)@7-/@L5eF#F;2/a(WTMC7H6Y.<E
T8)3KTN)MQT)3ZW@R-)XU#Tc5Z6BC[U/2ZCHUYNc_<1YK5X#ZGNH4fa^RROG@NF#
KY5[69FIg\g7,4-fY[#L>2&M71/[Iga],Q;#806Q4>-5\aN0gW)])/RKbHC4a_^G
9N)GIOgD[J]QH\<TbNJM>dA=@7@D5G)P6FGQT6_H6ULRf?9B\;(6D=HW3G[@/@d(
FKbH=8S\DG95cFDOVJ6Q9DC8+g0[0fMcbY#(?0NgIT3\caJ4VJR2Y9g<S-K4;#]2
bOLYO3(AA;2)E?7Bef>HV:ZATT(GJC,JbS2-d]]7@I;E;0<^7^<-1T9I9N]3Sd<S
BFa#=-U&^]9B;I84_eV9YVQ2PF32\,EO_ba:T<.\PK(Q?H,aP_OF=H7eITBQ:[fL
@PABQ)G>4)T=Z1c?c2aV06Bd)b#(IQ7aOVB<bE0XfBFZOfgHS>2b@cIb<dO__#5J
eRdLIX=I.UNVZM9YO)RZ18:cNCN7:bEa,4?Z19WB@fVH9?J59W)RcL6Ag;cIN.:]
[LUDQ/WJ-T12K/f79\3da&U2+F@ZW(//O+dUbXFdW8a\#SOI&+3LB<@40Z0e>())
LA]Eab>+&3T45KP8JfW8d7X,aa(X0A]I^Z#0./9fO/:23L&W9\gL2#>QbON]V^]/
4>\7#C^\YNIb+Q1Ma=>F[,60#^\_?H?#>H-R3)R>XMcT1\8T3FH83;R]1G19Ca[E
PMIIgS?SF98TUH_.#e+[:PP\]J:;#;7+03QXMZ^?&P#_aOE-QM+V:-6(24:3N_K/
]-A_IMA(gdB.c:Q=gZNTK-.S@[Ub0S#ELP_]2Z,Se;\+;GIL6cVbcD-2B5b(N/=3
D-P6DY0&XK/-MCXEG@#KaeC)JeL&KTE+;&=(>DJ>U;-V)MMP0[\SbFJBMXX9>a]E
KM,KZ)R[3g@_JUV,9HTZZfG6#dM#61DPME.c/+c<N2+>(@a<KBBf8ZXC2P1LEc6;
O,@U_1X_[4=-e4RZ6KBN9&==;9CI,IV[0)_OC_Yeg_OY#O]8EMZEK-AX]G:#7G3=
UcIT#DK2MH1UUT)fK_MN1T2:a;(JdDJc>28JGc?d_NNaT\c3_[37Xe@1BBB>^-;X
],>7?)Y=V;O4U/FB=4\GB/&HGa/e7?:&Ne<#L+2?,EA948bd^1(@DE2KBB1YP\d]
ePP/aYZ@.=6RaS7a7N[+c>UCX?N8SdE.e,]e)FQeTBMGYNFWK:Z3eO,Fc4H)7FH[
g9(A8;XfQ/VZW[4S5=S89dX\deX1RW._db[7@-g:@f__XBf79?[6F-XCKM;Dd60a
9,I9^KY7^QV;e.<XK?T3AJ?;+>G[M8G\ID_^LL5g)QTDbXYQ^23C?5#<4_@>Q1Fd
G99O6^O]L.[O1J_JI&IZUA\E^=P77]>OU-)UW.98<d.BI;OLBHcPd9B[+g;d_0-5
RdZ([5#+TX75GS]05F^Y66\HIWJ?c?N.T>+/>^RD7U..b[J2##cRB3\Ic[RJ)B2-
95<59+eAW9(9B_3==/RgKbC&:M@\3J#GeN;b0\QGOeSe+aZYETZM,?Zc9MTZXZEX
aa0:9:=(N[:=2c@V6>>cJRSR6dNgO:=2A300BVU<Kg2<&[c^9D2I;F6Af>M7X\<]
JMBQf_WR2,TMI^DS.CZWgaf)F,EIdM8>1/3.:@RF[LX;O1M8VWE4)00ZN8TB6JL#
U&^MZM+Q]bWJ&FI>86<BQ]V1U;X^Q\g=)(TVI((d@--Ad-)/P09dZP5+BN<\SA)F
@]T4JRD;]GT6>EbXOU1#B8RV2<5cCZQ#N7[:>46+25X&S2Q2Q.cVfS)\Q>+aa6,0
4bL=HV/MQ<g_4R[[]>RX=6IH[PY8]##8E229bM]82cKb5O&Y9YDLWXMQ=CE\KA3,
5gGDD,ag]L?E^<&XB/J,67N\g49,#M5e,7LO4WL8X<1]ARI146/F_)_M+8-;:]eQ
(CJ8(\[+>;,^/0FMYJ>H-W@1#<:aY(@:R+OEYFQAA(4+6<DXWPX[c3@-<ee<aT1P
_ACUK0FQJHab\#ZQ8THA@-9eZJ?:.G/@N>I/-&/G//YYf(]_WBf),OOW^UaaVZ[]
=\XL(EJV.]CG9=1S37WU9CYfW\E^[-=]9d^+c1>BD?g6M\ZB#YZD5EP(/Pc6E\(O
4ZQZQ_^AQg85:\2\IBE<?>9R0cESYPS?]VQ2N]I#N9Z^YF(E0RO>[\<J]>UO#J8S
R4L(4[;QOQ+?Y4aWgPQ.>(;V3^e&/Y]<_04Y621e_>Q3=G;3XI]HD<5g_:/69Z<X
UGQ.A?>\/bC:F2K3W?EbD-1BU68)L-WPFGI(::Qc89&_T(3d?BQg^G-B,SKT^ELP
.eTeNGae\DI^IOVSBAP)ReC#d?FTB9#NQ./2cgIL<F^Q;cc5WS1=c;J6G/\FXDg+
2IUM5@fMCJ<:?K.RcP2d;bKU=\IB0Tb)>@9\(1)EW)L5\(fS(:KCC7@-83KKP(e+
.D^bE/a1[0-LYgR.Y.AL=bNTQ5BB#c#XI#4e2bW,.4-Z0L;<d0.<KVE0^0B[[?d(
He<WedDEYS;D,P6TNXFF@d>H._\Z6PRYMbH(N[_A:(BSD-)6LW?JZ?HPa/b8Z4[X
R>/#\aQ?Y?=GaI,?g]<(I5Cd&+S>>7U^TV1@R<Z6K#6U4EEP-C\DCc+<P2-2:L+e
QDQ8)BK4,OU:@J:UWTN(L@;]cU2WMZ.RUR_=[WRSKA,#VS5^C?NZY@K@OCUg_=B9
)Y(MgHeV2VC#aI&)H7IZY/#S>WHR,[eY#;2:_G5;G^H:FURc_3E;e(.K18LVO82c
2bZT@_Qg6V;:?^,J9[N+).6JXK&3SK?MET<&\7RWNJGNYB?:RT99\4-R[N]2,4P5
KXEN-6\)Q?M;46B\1E7ZIa2;8)f.IRR2GVZNKT&<XHHK?[(D0E;6]PK>AS+b]fJ9
9_WU:f-Cf@ZRb7FMeA:L[#;06c:GQ=Ea889OB.1GR8@HRL[R5DWXDZSfaCUTKJAB
:TO:3AT[N[.@;LaILDg:EWK8+YHcHcT^6B,V9+c)&g2^2EZJac<F#aO@eB+^RS1Q
X_f)c7_>[-COY5]JU4DK9[.L+I]LYE5g_;/PDc50Z:Z4>-/T]FZ(Z)<gL8E3g79/
D]<>Gd.,/Z(+ED)bMbH[IPPR[&S@2MHE8dJb&W\ZO_;cQ>BLLITM\PQ[5a]:#P/d
I==5Z\YV@=_P:+\,(,:e9QU3[,W3dB2:?+2IB^-8e.:gPIbS9.8HJgKIIWZI38T1
;<(M3cG9LYgTTdWQc2/bM.1&dJQZ1]@YG&UB[@]5]#BaA;=O^gLO>]@7N\7S^dLZ
bA-,5@I1Y#^9DFNAWIZ=aZQ0\^/81O?8;2VZ2aZ.&0J,Q7#(B5a[6UOUF;C117aE
A7RTc@/)_aG@[)cfe<bDEHMCbBb^ZOS\9EYHV_=]gQC9X/HO;Wd0D]3I6.T=OPB(
]R5c6K/IBHf333P5]N,.@9Z/V]BKU]H5egTTFOZ1UZ).:g839aWb4aM=a0G&5a[9
O77Ug_H,001\<HJO_Q0AB<9f8N+I[;),\0I8.PP#2SS,=baaH>GK/^Y662e_M;:I
P91>]4QLPZHZ=91E@VIc<UdAZNS@^YWedcE@@>&2Q#9RZ0#QW69@NHKO?94V)?Ee
Zd5&EdD0Vg-7]O@ZCY+YcWU5<883-))f&\7(d:ZYH\5+1K;f@(NTd&E@(MDe,,3J
[@9dZOe3E:J759<TgOeYQ9)ZO9?2_M8Lc1D(8,,KUAJH<9CWQg94:6ZB4]:DPH<f
ATK#OVZHXfK5Bd=3FY.LVZ02PZS8D6Kc_F_=DQZ+0<OFZKG_Q\#VG]f<AF#a=gR\
Vd+]<PgaF??H_AQ#a1Fg2Q&PXQ-ADX(e21L470.SOa0a-=6,RRKA<Q#@e+EJU)0-
;&fU]/S5,=RU3JaWMFLOJX9F#Jf&W?,S7Q]0A=[MbaUc0)0.,/2)292/33L<Q4\L
AVD>8D@7@H@A=?f2g#af=LT=,#ddeC?(9RP0GeO-IRX0(U7]_^2(R2(_U0cU/GCR
0_?]8Y?b>a2_JKMNWN9IT,T?2ELTVdTNOO[?UdKFMg47cUU=13b:L7AB;?SQM^U&
O<903V=)Z6A<^E0P.)2HN1@1[.HXa]T19W8\6/X@=/I>(Z]dMKRXbd#K)8X;HU[T
QOFL.19_?+9F[AJF1/7^@c;Y8WCI2[\?:G_Sb@SSO)Kc4](+Ig\&(B66Yc5=0]40
X8DYG8eJe+WCf(1)g-d9MJg5W9L5MO[D\_a5CWF4a0c<19bg4,QgZ@Z=ZdDb_@c#
/#d])>9^2LQRSIKeLf.H[cYeWQ1T<UX8Y[1BZD#R\5;@XXWUDG@PZ^eO4=6d)3;H
(52[UHSbEa07NaTR#F55ACV1XA6,&e6)OFYP2J[fY-eg1/_>WGaa&Jf/0FK:d#IY
M4:-#/bAG9/M9_?Y=^W=,S>&=@O/N,ER;G)e,/;8I4]D)]RDVZI:5\@.cC2Q@5I5
&dNOgT_ZJLBZb63FY8fE<H?Fda;3-KgYZO=OJ0[Q(#JI;<:YL;3g1R8D3D&Qe4-3
^I<&.&9YAA(NQZP&0T_7M_a[<Oe;_@14a2HeR:8](1d3T>fR76R]/A_I8>S8M?IP
>Cd;b_9E_4V1G;:d<+DaS1Vcbg+_3,#g,P59Y6@D);,Kg^dL,7Y2CWQ@US;G1UWQ
b@2RT#gF;]LP7_]FBdZ>#d7aM^Q:KXE/bSDE35-37Z;fe>.CgR3RDB.7.[cKWR:&
1CM/G4Z.&=3AM8P0?-bUAFLe5a(NcZGT&-D_[4C0)\AY]8e8YM[(Wc,dc30=5a#;
Ba>TUO\A3G^V_#_U]9cIMg:SC8CW.I,\=U^)KY1Q_cH?9@G_Q<RXWa#/EG+8(TeM
eYe@Sg=cVX2]M[VV:#[CagQCB^D08g&ZNH;<]DSXe(5-/)3g<D]M[VMWA8NHY0S6
^LEC8CDP:R[46eXg-cTfGD1XGLcO@/C]=KU=RRDCWMLM;,\?[eeVQTXaB:.^2BD7
cY1SA)\eS]^5BDcF+J(?DZ[F29T1ATAgIaC;U9Z5.TeO:LAUH;,dB-19#IAbIT-O
1^)A/a16Cd8Y.LN].I32L=-b+L01NA+YIK0MOI31dH:J7<;YCCDB1GWI/HB9<[W\
-K,-FL)J3P,R.P[>.YXEbb5f+(>(IHR<Q>-FM[IBK)deXS1&/M]IXYGRX#IN5B)L
3A9cX?>Od@.1E;C)(E?QG)<PS=0E3T9&CS&NLY/O:;J2+T@e(]V>cKcKZ@Y8.M>c
4ZD3MBCZb.BAC\<.<X5GQC7P[bAYfD7[RZJYN+DYB^QN][[#WM?93OCUMN7;(VZ_
cJAPR:C19[Kf[Wa2I79L_K,9ecPdN6gX8RI07,d8DGfVX.]E-]&]>MC0IJcS?b53
-9U8;XL1PV\9;6cD_0Q,67TRPZ@C)1B[<K^N:;N/I5\T]F]XY9aF_CdWa==90+cc
bL;><P9^,CH.aVDP[?C&d^N/b<WP>YgMfBTb4XLdCQUT63a6N.U6+HL.f:C4^=YD
2E]^I=Db1F;fb1F@7G)cbcQaO4B4V)+Y>+5.cFe9d:]VR)K5-Sg#,UQ1<T<<A(#>
\E.(.2XUV-XEe1PUOa\WM6R<XQNYG]L[b,Y@,=]5N)Z]M-C_<YD_DI5H5c/[Q[>A
X<f&8IcQF1g.SUK7)0KGOM/:+:CW@6-SQ\f[(f]WS&I--69b_]KIAA+Bg7O.5IU5
BE1c2]UM6ORH5c,WC+4]&BXF,XSa?g5-8PU7LHW(b#3/;XbA#\2Y;XMgU5=Rg0R_
a)0Z#FL3I9L+FAZ;K2+\I^g-6PFMGTG#<Z[&LG4,8G4\^Wg7O43U7/Q());R;9N1
M=-1beR#F;c5\5\@WNGV3VV1A&@GCL3f3B<[B8,R=Z&E)5aaNH:GV?DE-=++9M:<
69&.gLJeMaQUUG\9@d=8/f:AIV\ON-IT@7,H>UG@9X;eR[d&LF(?+H:c+_X.\a6c
,?PZ99XI>FG&H,L[B1202DH[SH0<^XIHX=C\;S7JA#cS1(-#R.WK)WU/CI9N7TZB
K_QN]2c(1>G;gaF71=0A=MBMM@WX,RBP><&RI(&>K&/_U+;4Cb;YMc3N)HS/#DEF
=f/7KQgP5b(E#R..f>8)3VNA7G(WedeRX([=3S&#<fU-<ILB8eTc,H1eMKc]X&A9
O4Ha.D72N4S?VE(C^cZSb3?5_5_V>=8eBI56SRXROec6PXK^;e.S2QD.?[XZRIcY
M=1#ZHaGX^70JNdK)^gFZV\Q1g2HMT43R;9)gLXb1YWIX@FHIce[U8-9N^YU,<c3
daS4E^NbANAg;]/0dePFKC-IH;a8\V2GJ4E;1)5QFbggO[-,[M&_g?0FWJN4edI1
#=[MJD2M&eBR?OJbCLR-/SCET+e;DfUT56d)L-)X>JBd:6eD@N&QDe=AM7H7[[?E
NZ/5,1<7H5EDT]:.5UR]L5g(4)Z4:OZQc@9(RKNZ=YY/:D=W(HQ<aP?RJWc;7QOH
dS>#ON)(//G5c;O>M/UMQE+WWcGNf<KK[:\9YW0#LYa/d^VYL3#^XWIBc(E89K^]
PM1KR-QW^2_1<WIa(0f;JFDC6PHH\b]e+ZWH3(Z/CCT-5Y=f-\X5XVNaD=17>9)A
g+<7,IXX169O=aK/7[SYL-d2dA3,-(S7c9cJJ<.f76aA2^Pf,T@cP>\>8D6LFYg6
Se<F[LT<(PE1U-RG8,cXQ(X_=-FL:23dRYL6g0=@IVBTeJ(A4O-aDT[OZd:Xb.([
:6Y/+LeJ81,@^FM2>2QD#IB.8/,F4&G1-F7.P7?R-7FfL7.=3UW39YK>Pe6/\Fdg
3(B0OKPdYK>66?SCOP&9.bHX&U[V:>IQNHe)I.@A5<D41Mc^4>P_C#;.O;U?a3Z0
HWGa81HNJP29f6fK?d9N@ZbQAYRE@7XA=b8W+)/QgWX-T_B\f.e-c72,Z7OIg^Y:
@;K)AJGX=QaBI1c>>+I#:>SfVgZBcKA5V[M:VJab1FCIc6FG<gaDe@B_59R&#-IK
,bW.C6eQ?(CfQV5S5eY549aVY2:@f5e<@L8_4G=3CUEJ0K\&/=)78BFU31CUA41R
_@\)=BY)La/[^NUPS<>bKaW-GdC/DRRAQ50(B8V]K]I?[#:2JJe0FSUM8Z_H>4(#
De&S;IZZcL\C_NW3]cL8D06UXBSJJc=4&1Rb.8/\,O;Cb=9V1gbFB#b&#\eKN.^g
?YL&G]gg#7_D^d)Wa[2)YQZN@^(78dLSQa#2ZZA4#1TCH$
`endprotected


`endif // GUARD_SVT_DATA_QUEUE_ITER_SV
