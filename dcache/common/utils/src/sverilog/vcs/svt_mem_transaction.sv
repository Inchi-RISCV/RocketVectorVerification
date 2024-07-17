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

`ifndef GUARD_SVT_MEM_TRANSACTION_SV
`define GUARD_SVT_MEM_TRANSACTION_SV

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_mem_sa_defs)

// =============================================================================
/**
 * This memory access transaction class is used as the request and response type
 * between a memory driver and a memory sequencer.
 */
class svt_mem_transaction extends `SVT_TRANSACTION_TYPE;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /** Randomizable variables */
  // ---------------------------------------------------------------------------

  /**
   * Indicates if the memory transaction is a READ or WRITE operation.
   * When set, indicates a READ operation.
   */
  rand bit is_read;

  /**
   * The base address of the memory burst operation,
   * using byte-level granularity.
   * How that base address is interpreted for the remainder of the data burst
   * depends on the component or transactor fulfilling the transaction.
   */
  rand svt_mem_addr_t addr;
 
  /**
   * Burst of data to be written or that has been read.
   * The length of the array specifies the length of the burst.
   * The bits that are valid in each array element is indicated
   * by the corresponding element in the 'valid' array
   */
  rand svt_mem_data_t data[];

  /**
   * Indicates which bits in corresponding 'data' array element are valid.
   * The size of this array must be either 0 or equal to the size of the 'data' array.
   * A size of 0 implies all data bits are valid. Defaults to size == 0.
   */
  rand svt_mem_data_t valid[];

  /**
   * Values representing the base physical address for the transaction.  These values
   * must be assigned in order to enable recording of the physical address.
   *
   * Actual production of physical addresses for communication with the memory
   * are done through the get_phys_addr() method.
   */
  int unsigned phys_addr [`SVT_MEM_SA_CORE_PHYSICAL_DIMENSIONS_MAX];

  // ****************************************************************************
  // Constraints
  // ****************************************************************************
   
  constraint mem_transaction_valid_ranges {
    data.size() == valid.size();
  }
   
  constraint reasonable_data_size {
    data.size() <= `SVT_MEM_MAX_DATA_SIZE;
    data.size() > 0;
  }
   
  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_mem_transaction)
`endif
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new transaction instance, passing the appropriate argument
   * values to the <b>vmm_data</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   *
   * @param suite_name A String that identifies the product suite to which the
   * transaction object belongs.
   */
  extern function new(vmm_log log = null, string suite_name="");
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new transaction instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name of the transaction
   * 
   * @param suite_name A String that identifies the product suite to which the
   * transaction object belongs.
   */
  extern function new(string name = "svt_mem_transaction", string suite_name="");
`endif // !`ifdef SVT_VMM_TECHNOLOGY

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************

  `svt_data_member_begin(svt_mem_transaction)
  `svt_data_member_end(svt_mem_transaction)

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

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_mem_transaction.
   */
  extern virtual function vmm_data do_allocate();

  // ---------------------------------------------------------------------------
  /**
   * Compares the object with to. Differences are placed in diff. Only
   * supported kind values are -1 and `SVT_DATA_TYPE::COMPLETE. If protocol
   * defines physical representation for transaction then -1 does RELEVANT
   * compare. If not, -1 does COMPLETE (i.e., all fields checked) compare.
   * `SVT_DATA_TYPE::COMPLETE always results in COMPLETE compare.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in comparisons of the non-static
   * data members. All other kind values result in a return value of 1.

   * The basic comparison function is implemented as follows:
   * For a given bit position, 
   *     If both sides have the corresponding valid bit set, the corresponding data bits are compared
   *     If both sides exist and only one side has valid bit set, it is considered a mismatch
   *     If both sides exist and no side has the valid bit set, it is considered a match
   *     If only one side exists, and if the valid bit is set, it is considered a mismatch
   *     If only one side exists, and if the valid bit is not set, it is considered a match
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
`endif // !`ifdef SVT_VMM_TECHNOLOGY
   

  //----------------------------------------------------------------------------
  /**
   * Checks to see that the data field values are valid, focusing mainly on checking/enforcing
   * valid_ranges constraint. Only supported kind values are -1 and `SVT_DATA_TYPE::COMPLETE.
   * If protocol defines physical representation for transaction then -1 does RELEVANT
   * is_valid. If not, -1 does COMPLETE (i.e., all fields checked) is_valid.
   * `SVT_DATA_TYPE::COMPLETE always results in COMPLETE is_valid.
   */
  extern function bit do_is_valid(bit silent = 1, int kind = RELEVANT);


`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation. If protocol
   * defines physical representation for transaction then -1 kind does RELEVANT
   * byte_size calculation. If not, -1 kind results in an error.
   * `SVT_DATA_TYPE::COMPLETE always results in COMPLETE byte_size calculation.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset. If protocol
   * defines physical representation for transaction then -1 kind does RELEVANT
   * byte_pack. If not, -1 kind results in an error. `SVT_DATA_TYPE::COMPLETE
   * always results in COMPLETE byte_pack.
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
   * Unpacks the object from the bytes buffer, beginning at offset. If protocol
   * defines physical representation for transaction then -1 kind does RELEVANT
   * byte_unpack. If not, -1 kind results in an error. `SVT_DATA_TYPE::COMPLETE
   * always results in COMPLETE byte_unpack.
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
   * HDL Support: This method allocates a pattern containing svt_pattern_data
   * instances for all of the primitive data fields in the object. The
   * svt_pattern_data::name is set to the corresponding field name, the
   * svt_pattern_data::value is set to 0.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern do_allocate_pattern();

  // ---------------------------------------------------------------------------
  /**
   * Method used to obtain the physical address for a specific beat within a burst.
   *
   * @param burst_ix Desired beat within the burst.
   *
   * @return The physical address for the indicated burst_ix.
   */
  extern virtual function void get_phys_addr(int burst_ix, ref int unsigned phys_addr [`SVT_MEM_SA_CORE_PHYSICAL_DIMENSIONS_MAX]);

  // ---------------------------------------------------------------------------
endclass:svt_mem_transaction


`ifdef SVT_VMM_TECHNOLOGY
`vmm_channel(svt_mem_transaction)
`vmm_atomic_gen(svt_mem_transaction, "VMM (Atomic) Generator for svt_mem_transaction data objects")
`vmm_scenario_gen(svt_mem_transaction, "VMM (Scenario) Generator for svt_mem_transaction data objects")
`endif

//svt_vcs_lic_vip_protect
`protected
;9,X7;@GT(KPge;5X]\1gI/[?I@dH2P&2475L]N@EO@Wg>-WUV)-&(@NIP6ATXVI
0)N\57=J4XaQ?QON7d@KGBBb<HAC0,Z@94d[.ScMcc__83DQ8cD2N==(N28QS(C1
YUH8W:Q.3L::<WE-aC?_7>bc#_,D+(M5OLR.\SMG4^KZc_1MV2FM-#+6I/A9deW+
IJ#G\cWD)agZK.&CDMKWW;LRI_(15YS7#^#T:HF-WJF(,,[@N@XPN8Y,RD9Q/T<-
Z+YSA^7E5:KgEOS4G;__F3);>>++HE<I(KVL.)X6d;6:)KTeXIZ6fO:Y#RO.@=d.
,=78K/_43:Eac\))+L;5E:We>R(S.,0)1P=\_DP-F/U1=B\>W:TQgCLd#9^>?AeO
;H8/F6YYeB5bF0-P]]XPbR1#RXR^]MFc,gQ0J;YR-6SVJf:#WH_&S?MJB\1c\ERA
HHM8;\NG\fV)KTS78#-I+Q)K]/3LLN7028Q57>T?D1LcT>Lg3V^7/D,D]3:3W86<
3GYP:NEE8UI>0L-b.@Q85#:L46.8-c])\;&?#EYENE59C0bI-e==bXRcH1XE3F#Y
X&:fe)2CFBHIZFQEG)LR)VdDN<L7T&cC):0>>C50+eB[#g_6Q1:]bUW]Xf?Ag;Dc
B)\0X+Ug(Y9OJdYd(A(/0=fNECV+8aU9ffbJdX2@BA7MBNF36&JC>73RZD.Q?USQ
LRZL/9S44#RNPA?>eJFCaMO71BeGQB(^6DKE#Z??gX<EZ=O^H^3&07?PgBTB;/33
,/-8BO(M/^2IJL<HA(NPQ,DS4aC?Z[JdIc8JFP-M.YccWKK31>^)fDP/cbT@GVGU
=f)7A)GJGFZ[4dfVdf\(?bgKg(cH5f8I(X02dIA_@[V\EGIJN.(\\8Q[GMbU:YE4
C;,/4B(EW_-,_FP6V@L>RA+gXP](R/-JKQMaUAREW[?;QAbY^Q6^M4eIVREd\H2e
^=:gSRc/&)KD9JgbVB]C(6gFW;4EHK>B9$
`endprotected


//vcs_vip_protect
`protected
=I@@4+G<f^AV&VB<c-)YF]JA2/?[_A[3I(C@gA2.EaFagNP1HIE8/(DTC:HT;+>7
=g<KEg)c>O\3@8GHF9Qc_(3O=D>3,^++?b3=YM4g_Q3O91S6_ISO=&9@X[>8Y_:@
FR]2JeCIISgLB]Ycf(T>;KfWH[2Q/UP?Vg>?2R0:8NeY/H@=RZ.C73gQbgK>9c>;
0(D_H=eJcd1=LEOKc?[gR)E7(f824TfbJ\7GQ#+gA-HbQQW6e/#a8Z2bMT^-11JG
?^5bRM\LI#F\[0/7@R@dgVIVVdeJ6ZV;-S0EIBT2>G)WBKRWMVCX=c)OUPa21#JB
6HI8.\g-95TM?N;Q]A]A9e[M1W0S-WC9b-M&4AQ>gDeAM-2\:Z;(@ObEIL.)940D
_?e0+6O.TY>@PL2VXXL7&KL&I3gCc1V2Z-R]#0DCC+Fb77NQUYe5b>Q,D#;4[ZV>
a)cP[?Sd>SMReFA])#JON/.FD8PX=2>29@TIK1WIYG/65QfJbF^+[MH6O48EcgR2
C\H&,N,(\YINFDYN,RC@AB:aX>U-^NS=U^0Y5+@OK:6W3N@SM0O33EbH6b[MSAc9
+?&+=]5>)\F7KVWIT-_:_IR7U@H2f3c0e=B_Q08[Cc-^,Y]0;\:&])RE9c/^T9;5
5]_HUV:aBDca@9e@&f5QS><<HC16^EdC/:JG@,(J?Ja5d[#=-d,9a6VP84E^?/]9
_ea).\T9Q]_S),dgbYb@IBIK@^eDD\8<UOQ4:0J]K=XYOg(_;+RJ[Dc8PZ-VE)Ad
GTA]Q\1bHB2^DAB>-eGXHcAJ6W-27R;G6=CQ336(6MO3;cD1O^0H<MV3.Ng=Je0]
;)aZd>]P:<^ZB6)c:T38C(YeKe40E@fXVG?,27aLDX;^TH[Fb&?QZL][DU7BXK]K
W/^1WZA4U?HYA&\fI7WI;UMKZI9ZH?[Y#6a(CX,F+/<7&5^gBeST^fE0&0++fEY+
XDKH79;C)K0MB@9[,R2+X]I\&9>YQG0ST@F=TA9\1Ie2O][^87b3ec4.MFUaIaIR
I[I99=(,^aI8H_6c7aM,_c);[\fB3^,]0P3(UFaX+c9>R4a47M<]U4gHcNV=9H^F
6KI)=&ZJ?PB(TXL2/Z+]9Da8g3,1_2X],2dE^BS](M>NGH/.0ENCHJ>#Q,7G6##K
8];3:eX=gQ+RCd)_c0A@J)cYb+4/fT_56e+6Y?OaG4PKBCCM(N@3+e.HN8W&L)3B
;-1GPd7J7A#1HbcL/@,3c=[826\PPEN7f>b\[+?<d0d7f],MN#7FJ3#F<WbG8QDX
,T33VNGR61CaX4IPO9#cS#.1Q/IC=QL#Wb3EcZ8;5OMEX5dC;bL/DEbZ,?b->aaN
>VUIB5Z7Me<:77#X@+EbXaSY83117U)QIeESKWK[TE&)4NTLJKU@)&0KAb#&,,&V
(ORW-\8>#NA::9=UIWM\\J80a=Y2[QIX9_PHICS.Ac57Y@LAR4d?=DC?>F4(3OPN
[@31dY,?B8VU1S=1:5.f3dVI7AL05I]=FbJZEIQKPTUJD>QAIQ&<,?+FGWM712L@
?:/B^F[X1Y0TOb:IaV75JM(,3BWbJX>4@OQI?dH=?,+e<ZD.]QT3..;eC[JSWD4X
0ZY11>//6A6R?/D;UG_8TU8GCCe\3acKTU)D(:7A5I>=d7^R[&CY@A?:-2OL:LZ/
.Ca]5J/-,Y-e3Je->,@SaVY<He;R_1:3B<\XbN4_CQ(EJ&#JBK65gc/49OJ_:L64
RG_(<>V@_N]-(>f:,N3RaOLN45BIHWc_b^:J(d5-ISULeBU6BVP@)+TK/ggIEN(H
JSPbP=VKJ<+(-)fe7eKb]VTJ0:4LJU0K^14@ceHJ,cB0cIRL[C0ON_(8SA@dXU?=
_#f-=T6]9[>T4O&.&+fE8:f-JY>cBR92c0L]7M[D]7g]P7FU2IcR;QLfG(URTEEN
_S5a(?)L0G;R6W7(O:A-9XC1O^/)8^e\MdYDXL2EWMP52W#>&>Db?WOHg.<^C>AT
\PRZGH#,Ze,);gc(KSbeQKcY;V)[HGfFfeJa5Ka1I7(-5g#?eLF&12GaVLbMg93G
.)Y)A5WK@:;?9G=R22ZC(@gXL>Yf;;MENf?Z;&\9JJAKVB>W\I@69Y]:5S=I+9X+
07]=d^M&3]^5@gC\U#S>L]+;^_>[L(8&G>K=^I,,F0DSZ;/cOYeC.cCNQ?6S<d>]
]<=)BRZN#//LZ4_gY[8HN8cOaA&CR0Ub[AaK)]/(-a)e6.>.2M-/0EHPVe?C6WM#
4P/a1C]7&YENZ\8^@a/<&\I.8<F&/,^(BN#GfM52FB5VL@LRa:IJ;B4FR^_a>c+<
Z8F6__?<Ue)3&(L#B]POJJPU6OU\T+2WCOCR8>20db&2C\e:UGRPB[_U90]Q^;]N
NdK[+K\b);8>-KTNT0HL(T[_(8\K5F.MMEZM)_YLUG@:JC,YG<bI#+.JH&^E,R]]
Z_f#GaA,T2C:RQc6425^0A2gAKdA?15.764^[adMKU#156=LR9TXXDdZ[=H[HBG(
)afe&37M;H@0DOM/9,bOC-IL5,<9XW6>-L9DO&BFAd+D8cQ;D=G1c92N/CObZ(d.
YIXUI+DG;a-XA9[0Q.ccGH2a@#C#?U?(;B@;5TVA-5.D5.d8&50F?X)Q82N]e-J+
&#JAc&(05#TD;)g0L&.?d[L_HHa&fUICOM)28L?.>b::,.LC04OXeY>[a<a746]0
XSLRe)8G>ITf+H4-#1>dacAB7OBR35P61RB;R/Q(e_FS]=\XUR\Oa#A)=9>4Q^=Q
HS,LP,aMO3g0:/4(fIf?Y;[N\^@,</3=>G3f945M#<7M)7f?]4-OV(9029aGHa_@
W#,>f;X?PJ+&;@4QRRRdT98?\CN<OSO0AT3_3]IMPC.WN[XW,J(5+XPG@HY/]/f4
5d1YQR6=_.1Yb?IEC]DBKP&-K:a<Z<a07UBF(@2bFNDc:(?0cE?T1CHGY<f/Bc:S
IL7@Z]#dYZg\<Y0.a]TLA0=f=6L(e&cL.F>3G1E9+V:N(3D2\O&M_+/Gcc]@1S=0
gHZ_D<XOLKaHJ?Z&f_[fPM?aS;\CDU>c#A8]?2Z?QS+LJG76#\VEf\K6;#W8E&S4
KXWT.E/DFH>];,C3Y?0X8Qf0cO:3=_cbaPC#ZO@K\3Y>P@cLO3D?5_6>\L/8GN/&
2;HI9J#aZ[(7+][+BCR)J^/L+RXLV9--[MJ?HFf]V;KQbGK2Vf#Q,;79[e/D0UG:
C@WcX],6Y:BOSBB343&RJV\.3DLb@\6+&b(2J^KP8Bg2L,@a@GA7(/BZBbNNZ,Mb
Q6dX,P4(>g>^5I;V.JUYaFFTD7Qb,;g[1PU9d:a8e,Mae9RPaC4/#3R-H93WAb>:
2g=c;YRO;g^AE.W.61F1FZ#,d2/0W^+)f;8=LGYI(NBIDO;.4dT^QID-YZ,6ZB0:
V\)0.+G1B<\He\:GITfKDb?\a#BQBU+>-VcO22HaXYR]HE-4@N[bDIDW1TRZ&QG5
DKX>E;)LS:C3:Y,S(f471(2EfKF0g&f<=28?=HCE^Hc.[4\VO:;<=bE@T2&c9/WL
<1=&DROa)VR6KeG]Pc?X&W&/dIHeNE>-S]-W_,?4#^:Y-#SYI6=(H<DPV[JM7R>^
D)b&)GV)<Z3;g4/cP5RW91V7Z/X=IU&YN8gLf\96CT3CV>7Hc)SVc][:Y:VcAPTf
aR=:U,3AUg2U)dfN[YJ1#WdCK42YaC>D=6,6G\5&3TWI=MH(HB^Y.P:VLN>ee=bU
)6^e7cCXU[[URZf<AdFC/Y#+7WSS6R:aO4/4<C4?]b?;dF/GYVN>:E;5)agBgaJ:
Z[M3AQL3Nc5U=>--IR@8@eB.B,4+Q5b+W#D[F[DE1OJQN[SW=1]e\B9-e15\<?KX
:?/KN88e&ZIQM,dX:AP,7QO1#]=1>6I=Z<4GFBAUJTE@,F/>8JBUEf^VRc0@53cK
P]/@19O\J63Uc2M]&FNefM]RcRcUgXD#2Ua-08XDJY?cKJ+eYSbKc&cdF8bR]X](
bOWZM.H2.NA@(,#))/)<<..RUPKI2.Fb^e+C:Of/d3KW,L[_Qd&=ZeWL_^I;J5)>
E^T/:=ULK6#A/6),Vd(V#0&@7cJ,MRaPZD<dabEW.]8\cW+bPS[^&>EaYeTLeK8;
O^2E;9d-39_6H/M?7TWEC[H]<4H;AGZ(4U,g@dcV2[(BT_[e]I[Z\Q#/J3V_(F\5
L./3=C-1\&#2I,.KXH7DV(?fX4#UCa+FM@D,1C+I=N=aQcX<7@U&+=MKJ;_-=F4a
U3c+.HE&GC9^+eRgM0Ga])L[XJ69?dDIN_-5/YZ)4K?4fDA7J6TE9\O2FM1-G9<;
Rc._:cAHV.2?C0@K\ULTLAWA8=eT.&CY(Y1P(^_YBHDc)&C7IOUMPLIQKdWD@-)c
CKLZK=HAI7JU>Wc5L+GF+3f)ORY#HD8dL[M6?\AFg=2WFd8QCX\AT.^e?6BA5MO\
?(9XG#fZ(\[/66>&cB^BI^UK_TeIX^MZ/AR,CHS(LS7_(3JdNI(R_76&e[L^8K@)
S:D+XJ9e9WWAR-T98)5PNH)^F06J-[5\J-\L7PO/N]W_KLaI-8SL_S?eJcN_G:G+
bT5Pb<C2D0bVBcYN\<+0FAB>2gA59E9C/;NRO.<Wg1U+@XaaIP.b.GY&3ES#23>c
^V:aCa.-f[\GgG;d:+18#C]+<Z+PN20<0Ra[P/S?>BBQE>Z&3X/(UaPX>,OT4TeU
PXg+_2gG&&@:6[B_ES=a0XF)a&>cBZUR/ZEg)I-.0c5J1SgG+X)J+b[34I[ISTTK
L-gd]E6aS?Y]0fK@8L=Fg9\J?P?-5Oad=>GP7GAV5TN1X,B5][HBDXMBXP-F>01O
Dce1#KUXJ1\6UCL6HOV/Z1?T2LF5ZeO17TG25C^0R1P[T][9M\J859Eg/=9f?,NA
<Og;Zg)=?DR-JB+/XG6H\7_R?>9@\QA\T^Db=ESPYF#C>Y9dXD]()0F-)N;P76H^
7R-8a/L/(-@.QEgTRCC5ND0R]F<[A&I_@Z&Y6.J+E0;30Y[U:Q6E.8BTcM\D3YP_
dTJ5U;>4MT_Nf4]MZ:LRA(fcU8M,dF(8E]I/cK3e21ZVC[0K@QTBV\J(U34@/.B6
)4:6;/a#a9(7@4dPQU&MBBI9UF<3HI.YLIL:.URI;4MY=,3(f6JLHYGb)B_=LK+B
J<=_ZS1F=53b@@QTbb(]Q18L=_fZDUW50C_+M=7R5/L4\583cKI49]_5g5&C1&MN
?@L=J]MC,JW/E[c0H@CdU]8.8^ALQ7e7eCSdZS#b,?B&]SE3;,E;fN2&3CaW)@L\
G-#7GL(P3U6L_g#_UMgYg?OeQ=:5^+Mb)f?ATRJD9)OKZ=JL)3R/#dI67aJO5F,X
X05c.b=,dV3B>LgPUH.\]I?I:89Q&[#K(?[Qd4<LP)NO5]G&T0&c?^G\PWEV&D1I
U88eFKOT8(<[)Jd>J](UH)6f^IR&ed?\8ZR]I@);<#cT.-cWU>(;.2f^Y9[38T^4
@#)D,82/UF)d>EM434.]RV7A9&W>+C#\ZBP25^.FWA7TB[XPK>?^<D#J<A=?8/(^
^b2VSFd2W._fQ[da-a3)X58f_Lca;QS_,W4.FB5#J30M[QQ/8<.YP^EeKD]c0Mcg
9eeD?H,P?cBEO(6N?fL8O\\[(FN6AJ43)#OeVLJ-7AS(;GS#gaF8A,>,R1b6R=N^
2E5YZ2=/D9/4\ITN1Ee-\U2\JDV#fMdE>DXb/X35AdeV\T\O)74fcAZM8^;\F:H_
Ib&Zb2W8b?UD>LW[]b2O2;#a;2\A:1Q@.QO5RS/Y-O33SP#De=,F,7UZg84:>W;Q
EDOX@F22YV@F75N=#&dX.c_>;eXO1a0XOI=^AH,2><4\_=K^gZ<6W4MW31SaPeMS
Cc-EYW8b@YJNVGa,<7DIbRDJ8B,;JV7OfAQd>LeP;_Y(c]>GSGKggL9d--?S5^9>
?d@5MEbX4aV4J),Ze.DL_XTaV3WN_f&[M0OJMD,8U_G_\S+,(1W5R54e8+G.fbUH
)e>E:7ET7..E\>E7N[eXZ29\=Q9bX_0b7Z&,;=#1e/EXBZ3Uc_Cg96PV1Nc/^P\P
F9[SU?[DZT\Z0U-[YN+9+^.]A0@,6_16TgN4?D>Y5&&OSU_&GJQX&4YNFR8J<,<4
g-?1?AOD)\^bUBT.37R,O:(DAU9f.C?1>\?9CWa2Y>&>T?+M1WWOV&,FW-YcdK5e
73d(FUCG,K@B<NdW62#QL8E\(_A[(V47@W@72JL?Gg=?SOFWQ.07I;)_>/C3P+PN
PgU=>8A8</J>b)JNdN/-&@U9#(/FR15d?]Yb5=^#[+Hd1LBQ^+XQU/<[T>AT5N=_
7HG@bFJ8FeELU/b@T.QZ77EGB8)5AY^fc0:S+-8N5SYE=+\>;QGJL2[E^,bc6>Z<
A6JY]DL=d&eJY7aM-@FaA5g/YTMZ_Z6&,a[GM8/Q#fI)<U)E4fC6>KdT)+<7Mg_P
)d9Y8C/[]/&fG5b:TE\Y[7e9AQG.\[O3f<KAP(9VLYCg.67a#AeJ[,bA0T1[[GF>
YL?We^?\HfO;?EZQ9Z(NDF\+\CG]MGHIcb=JBP:126\V:EU-&CbePB2Tg?Y.<4OA
)NPLJOH:S8XWfgQ9Y(;G-#:6=+,bNZfA,^Le\J3BacUBgL7N7_+WTQ.3QG:NJdeQ
YBK;7-SDM<cE<L6d,D(+c1:e)_8?AaSaQdNf/CYd@OW[15ZO,WXY;7NR=^)_?VAU
-@5a0[,9Vdc=-O5,b1a8_\a]R17Qb.;K3352NFN+T#;2[Q,KFXgD&P8a+\fD2G7B
TbQB,89?.YM6LK;1+gT2Z_]693R[Kf:9a58NKI.ELNS:EfB250bSKXT[8cf5JSJA
^+OXaYLTXFXc(PD5]_cd=-.>Cd-UR?A2?66Q7+6&G?e;WC=_=/3#?ZO0c3.K1AF6
D<<X.SJ7_M8\5++5ZWEfaC1/VL,^W:a7fOL6d:BE-Z54._H(F+^C:@K\TLL+,7CB
f9-a>PKRdba;Ef,G&T@6_JB#XU?UW[[PQU;AK;WG?U&IQPVK2FdFg.G,EKRRW)Sd
aMVR(=[+NE0+d.<O9ea(<f&0K+O?&/LF<221\PbF7N,1PW#^8(N;G>afW5]WU/7f
F^7B?/E#S&LSV]J046SEd[+_.GQ/;:)OB]+V8JPWNWDDVP31f-5Pa3+:QRgaF,X/
)J1A-+S<EXSWb9V@LV/TJHd@O=47gRCg@;JHS-DS^;I:Uc3NJB5&b334;F(Z&cKM
_.AR:3SBT^@O9L@b9X-8N4\8-D3.MfOK2(,.MV@4=.PV#/Y^,EDeRQG4f5(Ig_.D
K>?KV0,P8dSZd(N5M&YVI7e8(O682I1(7V8@9NWBcMe8_,?7VZ(JTeFIb9/S4\C_
/KY.;>b(21-<2<J.Rb@/^_Fb^;@#Cf]cZN/<fRReE[2BHfT:GETQ_.7&=8,D?0#f
1:X-:U9<6];5M)-b_W).J+gU&XXJ@G[ENG,;\ASg^Q^[PXSRQ^K60cR-\H]ULPJS
D-0\FZK+VHcTPeGQ8d+/;.8Nb]FU5egBU[P&L/f.e7_b221+-+N=T>g/bQeZZ15d
X;^_\85Q\15[-IPL<<TEf2FHQHRa02WJ1MX3H13C+>KMW9bF_\TB:K]A5bL(eBL;
4+SBZggH7H=6HO#-M-@:Z^4Cd<2]PAWZ)#XHWO;M+&VXg^</+\VO#PfAKTR;@M6?
DH+aC;6,(I,)XAB+2,e@/G,bZ,)8&NAWDV3J>5=.@;=(A-UNH]A@cR@M;<<M&Y-0
,:bK-^#eIRV5DQK+]6W+A\cK+/<T/fBJ+M[Y,J/HRCULQRPM9M.^,9QRR6W+?@@a
B@I-CI3]MDa-ZBcD0^60&/ZE]VF2>?A-J1+EdfA3_/c;+)PW,.I7VP<9\O8[)bR1
.2?T[aJYUU&JOUOA>Ig9[];J?YI7M;g]gdYR.=Q9.96+-=JMffN1Ce4^4H]\(Q&c
FMZ)H.</&>N]&L5e5=e9gURF:>KD\Yb559[<2G(SL#P--UeQ,OH3Q,^=9bH,6IK/
X>X??eF&#6:V>_6>9bX3?H,&+9O^W>C:@FBS<]3X60>W7\]aXb)>@Z[Le/69)/B)
>F&.9RD+)78_<ASaI8a<C^>YTQ4^<-)(;U9S+O@)g.2/VSeU4>\<@EG69@c9[/8A
:&;(FK\=+?TQ<b).MP?eX_e8K6CddMJO&c=N&XOUGD4_0T>]2:<+YcJKOd\I3;>N
0I^,AUEeG&g2V9MH3Q(92b#^[DZZB5<@0\G;N_IRFf73/9IGOVC7D-5@7_W9?fN7
,Y&PB:E=cOIEK)7?YIL67Z^U0F^HR>X<E+47#dJWG)fPIJ\3#(5.7I#S7++R6-H?
XG<#>;;ALEGKW9\KO\JQLQL2B.dF+N7>^+_S77bc9B;I]DCE/Y5I>S7b?52ce)RD
D64DF1gG#O?=<8HUdJK(3BeG^fZFNgNROALS)Ac^X;42d@=(>WMJTJad4U6b:CfM
=fVYI)cd0^,.^1YIb^6?]GN4SVZ.a]d2NOP4&9YTX6IXcR4I3>>[\RDI5CC9]0.@
A,64@g0#4UP6YZOa?O\Mb#U>-S=37[.@-VT54[6aK5P;.fbX(ATaFY/M7@6Vd5OL
WdR.S6EH\W5ReB+;5DaEP#?P-M8#M2gNa,WYT&4<3[J\D5H0O:[=HFCL?TIQN_BS
X]9bbHA39&5X9a:#8YM.3SYY>ZQK(L.gEC<R?Ub\fN?5=c>3+SOHJZ7)=g#;9<U4
[E&KdgGR>R<D?G;MYXB(.DU6IT=I[;(,RO7#]#C]./M#.90V^E7^(->Q,#,;_/NU
8D5b2d5^L3Gc8gUaVTNf_8.;[LFMeZ-:J;C]0HKL<X6I3)8M=ZM&@.4K1D&BOEH[
bb@B#R@1HFg)X2;]\M-(XHcJ?6-PMg6KdB8E3QL>H:=DYN1S&;OV?NHMLAR#::;X
=a(VTDeNaPPfGA^79TcI>/5W5.118g<_JYDe2+:Y1eED4.1b-PZDHd;\\FL],\56
&IIM7e?dYY8Y;N>P]a;/^V[G65F4-0+5>)dVCA\e&W8/c]=X)^SOIH5#>1TcEe2R
\b_0(JA2XWaILX_cZSUB/C&X;=_3#YaUPL9dK<2>,[^SC46e:,fAVS56DEMQ&TE-
A9A_&V42/EUYXSML]1\?E,Q5N+7#H.GaaRLPP4YF,a.II#/YP,2V^Ib3?[c=cbX=
8@/77MbRTYKV9ZM=-4>I1T(GD&UYaaUc)0.Meb.]bUe7/C1Z,c]&46QR5UTW4+?a
EB5?LgK)2G08;>:L6F\-0?6KC<X^)U9[b6U]P<V7PE#6J_&2KbW4-0DELY)U>.NN
45/6<6=aZO+EUZZD7Y<A.60E2[Id-UU&XV28&NM[LNKEfD=A#@<P<f>d5ZW2TU(H
.8&OS.6d)b+,,SA_=>#N[8)?/XaPH]gOXA9g.,-6P?e<_Y#__.Q:B=b5T)EPI^1U
NL=b7SG/)5.E]YK5C,aEP]P5#I.2C?(acV]0;M38/SZMU6(U+Q>@VGIgM@E<4JFT
aDe68=PLEDAb<S@=2F,LTH4R,G8(FLf<[9b5\b;DD&T@M34:?bDVS5EM_]@73^(A
/\[a&5@1K@K.SYT[KK(_Ob=9Q9LM>dPE[A-NDL=&8)IP[\C:KaA2Y=4K41@Y3M@P
)=U<,SccgV1[QW6[J?4X&-8Ze-=>=>^4G<93?+FI:=8]2Lb,ACMP^/?.C^N,4eUc
\Q\TfULW-+T498BC@Ca2#+-N)\I@&KD9XC/S2J:L=?[f2b9g-V#,<H&@BZd+aWG>
K\L=WXdG=]CT[B@@Pf2,@Z#RTE5K>CWDKY.Dc\4F-.dJ\Q_F^<B[;ZA4ABBTPY@G
0[(S:OC+]+.-B3+#ObV&O>D;;/]:dDGJY(R.a411(VYD8[#>4gKY)#5U.T-c\ITP
J]JE3e6KRdKD0=3,:Ff[;48([SO0:)PAGQ?]Eb0UeE.YE9DOgB3eNPZB#+4P]NSe
DUADL^#,J<,CXS?J#(eP0:a>P.Y::NL.>&_1ePGGb1SL2_:8d[QRCD\bR0=(;e^@
Uaad8gE;566]YF]>5I>S6:WGJ<TfL88QY8VB;,9BF7AUW#CXbC<^]C-7TRfJXVLW
N>A<#OC<-\O)_KS:bVU@RR\&J/d;G.0dTgCMKVCG#:,ebV=@613CJR1U>&AM#eIc
8YVc=)>\D<_]WGe:)J^1g64]Z;@;6ZDY]XIE&7X1AT8>B4D8+8Z]0W/ecUXWZfcP
92X9&O:=#J-g-[-S5HU2YYENBb[G+\9[Df]6)7V(GJL[:&W:+G:T])XTR-U6[,Q5
65(4,.&4K6d5^D614\16I[-fYQ/g47VD]_HTZ,<X4?9Y2?Qce/SMg6e)EIO9^-M[
cEaV^])3Q.+eSO3R]Gb\=eG^QXIJ.3YA>d3:Y5C]b>><O>c,K^6Ld_Qb;8(26OA0
MR\Z+CWQggK3_LV+DG:4PACReY@S\G.d2=Tf_2;FXXf>@87\(31PQBd=b;9.++P@
Jgd/F;>AJKLCD9Y=Vgc&L;4eO=;_7-N,\6OBM]dIIX\URfa,9DS5<?>CeKd91B+L
+1Z#E7LgL4JS9X.C17LVNe^G&\D&aagA,^NU\;@=]=TP:T=N0F(>G0V#,aCX,&\L
/g<#DLa&V9(4)I0VSB(/S1Q,11\Z]aX-YXA_g<.d43YS6;60YM(8g74+8;_O;dE8
BdAH_L\I?7D,>Z&S.K5+YNc>FEd,/ES+X:2)=(&1.<V;6;.[DSDVf.b^7+#MGYBP
We[VQP+=cF[_g(?L__HGJ-Lc^I8J>M6.F8,0]WQg0=gUUO4MPX\@F=9H[G4&]ZCf
[/8&>a^:([Z>-aL(><J&2CVE3U<K6QVK_GPB)OSfHa^ZZD#a=2Jd?SZLB-(8^3+e
H[3:6V>BUH)HGcMW8+IFd(J6f&&[GTFVD&R/\THCFd.dZ3X;L;e-8ON/\<KBX6YE
8.H@DSN:_Gg/EDcH#=GPPI]\P:2;T=FS?F/93Q?^D1>Y30-35R#EQ@^K=QVD)M7X
Nc-+^e<7#:F&(XM<4]-8^M,&YUY2SIc>BSF2-)2fXFYGLS2Ib,JY@]=Mbf)[K^Z(
YO+#@_]8XB<Q,C)-G3J0OEF@2fEZI<W^J1a0&MICBEKa\0L28e&_9OSPQMYL-:R;
[cFZb1da6:W\.A&_SMQ4(&WI^UUgW2E#/?4[=DA@SA.Q)XSd+G3&;49e6399T8)J
EL4V4-Q7A,8]6)C<+a/Pa)>eMDfQ-NG<BMb_a9<C7]TWe]#&\@1,[BAPNaMI1@B<
]991WR#Ig5ebM5GZO?c-LQO,XZ/2#LGN5#B3N14RBKNH<a3T4dB85ec7(=V1:3#Z
AQXM#D_-1X(I<-b;\A/PEQAK3I(dP7R,>]=\f3?D1++d5D+O3/;C,\5A+/bN?Df7
>NBKf0P8TT:1AJ;=\8c0_]XUM6=@?cD35^J:ZS+UgZATHbGF(gaEHY/;#c>-c\\?
SH(@J^6YQ2@1&S(5;b9Od=_BMANU_Zb28\G1(VXfB@N2Q12\_.aBW&I8\QAQG2_.
&IGLT9fBO/A5N,\aE^T=^3#&7cYT:HD?[Q+HBaKJ7CIXEJ,H9fc,4M&)F/(:/4gX
O_L7Yg##0b;EJed2KTXedg5A;UY4\(.F<_dWJ6DCB7HgGaa@#\6J@7&VdIbBX&:M
;QE=WIF_@V7IMdaP2=DaUR:/9L4HJHeOP1MC_IM;4gPGf8@N]+Z55VN./NA-QK(-
H#3MB(QdDCP>+C_@#&2C[c_bWe?8^(Of4P:g0d._IR](H>U-Ae-e@Y;3?:0+IQF5
>E^C?d&Sa;+&9+=)TFIB6<bJ0\NXZRVZ=c_f-T.PV,g<GEG<K^(7a1[=XV8QMVO5
TaT_A,X=/[,Z]5\)@WI4fN7__L&(efAS=YT46f)Y)>g#RYZXKE+c^F7P=<=GRaS(
#?_16)&.?c_bMUI:Z&G<.d\,^,0J/Baf7+6?c7D,UP+K&BN;e:FM^W<2fQgD4G46
Eg_DF>7R.NAHL9&8K76RGZW=E<N73bC(N6Q\[C-F=(a1a3FSAM=,\aE2QSc_^GFK
[=O6_@#79T[fM^];_\Y0dg4<4@Xa0.I.5bBUH#SWFP&/cc<FXI\W:)NTgL-E#8b1
(S,UN@X3RC-H2/<5dBX&fKFUS^[adZF]70]Zge:M5CT;0N1dX#.c;NCQH=-X0T,]
I:FZOC)<LQ3NIg<J1?35[QF+YJZP7Y6a.)ZC;L_f5;[LO#OUAC5:E)[@7G<JBMUd
R]E0<^PQIKX1_[KfCEPL?fOWNRd\Z-Q,L#Iaac;D=:^R37HFEF<HEc8b>:7ZQ9S)
bRMXGXB5.,.8X@H<L+?.Q0EgcA;^Y:[7YNJ2]5Q5Ug.)26S-<.TX+eDY6]]M)M(U
M2GBOE@5<QKXPgVIdIW4D5.SddVM&#Rf-^f>Q9G=Y>SfFZ7:L.4W9Pcc7?43XdD8
BN0Me/8KW13EGICBd21)F,^S25XT)CF;NCP9W8SDTc(OMC:=38EE<]Y6/Q6gS5=e
FAYO9\P,K;AXNf?W-[_<#,ECEMGcT<)#[AB?R/LVRK6C,O[gc3[Ce::W7^OELM:W
XXe,6#8:Og>+:J4GA^):[YORZKe[,>.I)6IZABQYDKHT,fU66;X+IS/KB63dGM\8
K&bHUHQ7).1<E/9SFOg0@Rg6Xb0]B@CTZ];_g3#8WGA]Ag3P3P[78;5fW[9J>d(J
EP#UBQ_C0HCBd&BTaBCDWKN\.5U^&P11B+a,F(4f/DNZ&\)8IeY)L)a^;#+R_Q]F
)6Q=][I,Z\NXXU+e(YT8VOK<9/S]M02DWD51,2+:fgb1VYMc7aC<GS>HSc=[FL/d
_PSbBd&T?1V>V2P55X-<fH@+=#4+:Re:4.8Xf&d^]ML&:_Nc;E+_T\EG:QeMKPAa
G3-AHdBfGJb6/GAK:B#RLaZa:Q?A)21+F9J#5ANPK)RE+PJL<eF<eRFJ6.\g?7@]
a-Kb^<J?-E5C:f:cB:gBYQDC\17VOG0S_+2C^+Z\X=8HVcNGN&IN8e#PTGR)5FNg
V:L9c0:]HGN1dQCEB)#6G0+\&,aM7VbKO>-#)YX\#,75;.G4M3WY?aB:6#F4&(NG
]@0_KVb&PYEKcg,KbA]\Y<#XAVV1;W5BJG.0)=@?<_O4Z9^=Q@L47Bb(abNBDDEK
c/D,]9@]SO6RLHYV+^_&888XZ4,>Gd@G.:HYVaH)R@SH5?0,?TANWWc<;8UD4M.K
Ig9QLVW]_8KF+Y1RX;JQgbYZ-K?5J(O/(;eHV6(.ZQ0T)XTb#\W>@eXQ0A7HD4_a
H\+BU]ZgP[,a>I)=7>C(&N3K4621.]]](0=V>8^HFXK)1.4=bY6LWB?Y\E+H21bM
JHF\L:3bbf#G\5-_,XVV;7DZ[FWQ#[P:_T:PCJQ8M]0gOH)N>=bQbZUTA:7Dd>^2
04.5[AP4^5<VERK,BS>cFd&0V4ZSV(V;I&[GAD;_fTPSJ_d<=;7ZcXV;^YC)#IAT
SF37TXDX,E)12I7O_[9H@Vd0<]8D3GVSa;UaAG1?f18CdSH1I;KTW80SWRJ[dD7c
[??_O,c[\(c+SMdB?7PX-ZN=\>f9&Eac0I&TbcM;35,CbdWB__65^5OaH_a8@H)&
+&LNOf;QF]Q_ADWaJAAe^U)^BNR#CdX#d78d?..Kbg4RV2B^]3]I\-)^0^L^c?aH
Y^?S+EL)YZV<bJ?T4(Kb_.5,bf.8@>-46G0Kc?ON/Z+_E2#:T;c52:FBb2MGGR/Y
T=:86E[QSc8PbG2^GCG;=[,@6AK=K?X6cY+Q[,d<X-\b12O5R#g+43H>#:?&.?NB
O<OLa(CP][8#gK@RWM;\7,MXZ.I(N)^SBF;aC1W?A0C=IEQ1f?.,^BXVYf-a6/PQ
Y:ebcNb.MPE/=[^3gX<M8A9bK0HD&S>.<4(108NDNUX_PB2Ac)XDFOP5IOPKQ\A#
YHU[27@L6&F\D66eQA+e=65=SJM)<>aK@CC2Z:S(62XF#@f=>XXO(@Gfd;C#X5),
a_,bJ&J+0VUK:0:XEdD9fFV=?I#H<HCJE&):e@cEJW2Fe._^7#ag.-G-8FR6QVaH
QW.b]9OS<#b4LF;g^0?H@7@<CIN+AEdEaHe&L2T<)bJ\IcRJ4bP(5e\3P?95@MEH
7ce-O3E\;fJ4[KPgKa1DKdBAe=H@LNg>2b@96^TGb<eK3dCEBZ4QKF9RW+-]Y:#0
L#+6:OEA^L1&BA6VI:GSO9d8Z[E2>A]<96Y#=e,;-4.abR5^UU[>0]69/H3.4OM0
A4\cbIea9;;+NCabSI\T?&U?5:&e3Y\W.3S;64LG7B<KQM;a8XCV5^V3\1G6EJVX
K)VMSA0M+H9Aa=g3;ZF:J(;W<6bBPVL85@5N)L@eQQ-TC5I4CR4aSU;e,9TVC1dL
1M)d0=/:1+@T77I>LB1]ZDR.<[H0_6U?UbXO,^RP\Qd&_1D]?HVU??AB_Y]?))T?
YOa;fG+,]6L6[EgbLU3[X4=Y7g)#>^1GY+EVRWBO40^^35Z67,YBS4^G=_PFS96Z
X>S5M8+8MKS+Y1>HE?ERZ+:Sa&?-2JCKKO+T?+M8#+>F_A#eK0PeRTYE@P^N@?:5
@4ScAG139?)AQQPP?251G27V[6\ce=5+3W\;g#[&5RR4c3;PE6EW^\YG,<MY#7:A
_eJ@T2gQeU1;77EY/YJe^ME2(<TBF6F/LXD1ZfW[)NA[T9:^#NE\@Q#JPH?eD_8V
e_YQYG3fC(,;-PNDdM)E9Zb@GRgN^Za#9W,KST7;FDE2UW58TCX\(7_?E>5cZ2P\
E4/WN\W@+Nc9G\9a),?fc90N/@&:U3>,AaT72>02.54E-+J+1ec;.gfDVHSD8Zc9
:=VVBPg&f8BaA]W4d004/.&d&D&9;W;IbDYIP\-?cH4V4HPXV0/W)7FRg8dQf=2D
H79H,MPC66WVKP7\;H2MIGQFCJb[K[(:4,0/RMRMDc:=eLNe\:1La8b>GS2](b<V
N:).2EM[SaLU(UQ@O(fKMLcXddQ]M(_0-IT/^C;MCV/@,66GYED\MD(6.D_c-QU+
#J1WY<4f3-HRef4UaZQb7,F6<TQ5.#>.6T7)1510Z+U2[QHXa7P^PP8fd<.cIgCW
Q1(RNLFb?-&V&J,gX(EM+46=Fb#C1B<BJaMc8M1+S_,&b9&7K?+V\cV60ABS\,X<
-(/aG#SPW#:,_@).D1>80+8.Q.7.U&F6W@64\I.-NLZN1,DD]Ic1[:NT0;FK&95O
[QB:Xc\75Y<1_)19MS^5-OgKK?VT(2B\\@B\\/A.J&O,01ReU>[g<LUBcd[_a,VL
:Vf^cU],d.4eH#c-YKUU5aKW7H01HBW^gR=c/KZP11Y46YJMRF]aVO;AB6-F+TVA
==DRTZ=>1N#DBdP?;3B]_N55fSOL,\Q+Q)Sf9La-d.b3LL#.3ZU+WWHbg1EKI1<.
R]J_EK]__.?M5c.1RCO);1e:Y_>9L)cZK[+JS&S,\A(K5_+0F\NO^W1D6U84XLH=
:A4O>d3c#@)\\.65SRYKI,CV;OI0U/H4BF9Ue_>P)]B<)F6aR&>D)[7L5/XENO4b
L3(NLGIY&WRT=\BJMYS?^MWCM]OQa#_F:8.fe_.Of\e_],.e3=HcALO=06M?]@2L
ON?WB0CLdN,F>0VS3=Q;8g(cb-LKN8,DY&.<RE[gKYe;0(157f2YMRb70gBEG^8J
3C5D&-T:Dd0WSKg(F&.&LeY^CS_+SQUZeGSO#A4\I.EYTMGK@IRF67GG/3/Lc52Q
M6MSGbL^-OdV6Q4M6Ee4N@33QCMLYg4^Z)0V9T)gYG])C@<1[\_?@Ee&>6],X,2J
1PcbE52\.;./;G3]A0@^L@8aZO;)PN6&ICG-4gTW,5L9]&YC+M8W?3_I[f5WIfWI
P0=MFG@OT.A,3-MA>E;UC1OFWDHD:)4)6IV#C[SQ3TSH;c\ZP>f:g]AFG@8<TXa@
=-A1KG>0J+ILaD2XXZb&WNYYJ_K4gOXB\6AP+_Y>GLQC=:gcX&M>Q;I9cSZLR:H7
-<b9KcYK)=T]R:>&+P+B<?4d[M/I/e6D>&;f2MUHVC3.cQH/ZQQ#EAfP3Wb<NL_2
;:\IKB(IVGF/3eA@AN1.WTZ[QG_?gT^9N8MU>6#[K2O=R4T)R(a^ZeeNJB=]bfCE
IIZSW23<T:<0,;IY/(XeB_HA8:CK\FCU@W#/ZNEVUWg+@44Rcg=/b/)W<]b(BCSg
@+Y>UW7\c>D-D+8Jd#)_4Na/\P9Cb9-4I5#J]Z6EP4E86@,3Lb6>XfU_/=Q3BDZG
:+\Z4)@03M1A/_U;#ZH(TOf#(^-J,\<6)WJ]c<IYXXD?3AO,NL]#FOeT5@b+TV@H
daSS@L9-cCL&?C=XGKeJ?VX)OgAI]M0eGV2e540[:0LZZ(EDgYb<3_/3&JQZ@Z[5
.-Ued]U,dC0Y:2d^-W+MeTNOSK>TFF<e78dd1?#[ZUcKA:9W<AdY]3GVOEAF+bc[
,,gEe2=Y>:F\V&(LRLABTJRSVSH[YC@@+?c;4J_YN2HPG9>6[R<J5O0M-a6?1eJP
)#(C/)P#gP&A\#eO+\BgD_I+H>OC30C3Tf_34X1\Kd.Ag\DQ,g]d#gIMI:Y?^S<Q
TPe<V)<[=>_)\L-;-RbS8-WM2&c>3_-<ZGEX:]I03EdXG8NKBN[f@C&M-Q5BZ+HB
/R)-V^Y:^fFGg@<D>H,+4KHDIe0KNL(_YST\Waa,/#=[SEA+L,ZF2_C3-ebWR.-<
XF/I@O6MCR\S2LF@UJZC/-Lf&#AKLb/A(H;RbE^OdFWDf?>@35TDPQcP@e7>X4CQ
8MfS9+\&J=G#<_\F_\\e2,ZIWH@RJ_D=-fG+c:A7YIRLR?[ZIR2V7Y.Z_2T71#W7
0)W,:EbK2@=].&gG2_(.fef=;.#@BG,=Od2J=a.ZSFeJXaLABY)?a_IE=/Y=>,(F
O[B._2OIS,HX=7d9IFa?a9L#g4.cgWY?_QOPG-RSd/8M&+A;Z]=BI<LbDJF:QPPV
H&@>Jg[5E66)N0JP<HR8b:^8WOd51AO[4PfFWX9adcE4IPW#C/7W^G[b=<G:UZW-
HJ5SN;[]9T]KA8;>8Ug[+(8>]^IfCXEWUa<dB/^JJ<:NV:V.e;fHT-IG[=@OXH<f
((b;,dWID)&J6B>R/S68)[EP^T/cc/K&\\bK7B?7F>?J_ZK(>CQ_SB;IC2OM<]3+
G#O^0G7dAG8g(8?GB7^@eba_N+T#O1_U6&/E-Y7NYT]P##K#C\WT1\46JY8+Ea@K
+<S>N&_N:WEINTTNF+>D>X(HG&V=R2a0AA[,?aF&XS.fH#,OFcc\@HYL]S&2\I-R
-b7e72Y#_VV9L3)-^S<E^E2&XeEB;)G/S[X9D65O7-RFH@?eO?>,;Pd=YNd>H,.4
a3IQGH3Q1W^099_6QJ-IL(\09OeVba^I=b[/&:A1J&.SfR[?5e@<368d5_UQ]W+g
B=ObfUN#EH]0Ed@,2#^#CBf1dVdRIKH>5.O::cX?D,HGK]dL=5+gWP-P<AXd?-,b
bHVW)ETc&77b#G/;^.\,9gPa.[bHGK7D,[#2[d4@#,QeG(BL[?R800UQYATR\AYg
538CXV0\fIJG@#g;[3J5,WbTLC:(X5;44#&,>I2^GgG=2<F6Fa?ggg/.]ERdOGe/
BYO.7SFG(F0I,7TL-#M9DS)]SUb8FQ@/O/EX@9-b=VV)f\#CK<g493<?-YHef1TX
eT6d)G/H?YbgIGE&>La>@8-gGLL0XK[;,LB;2UR(:+Z8DL>LfT\N9J:3GSKH@#.V
S694g4X3Dd.c@1,F&L>Q#Y#2KG;X.a@#2M9@13]-C8QOJZCa+Y;c=Y-:KF)?N;.Z
KPK=XZQDeLZRM+?O@I._0X+[c/]+GaI<#CM<@6[PbS06HQV9Y4)E7DKGAI5CaFaQ
f?05174[DZ@5I(Z>0.(\&@J\M+gN7M4@Z];VQ5E.?:EM8DCU[JHS-)[bE8ad=-ZD
G@Q,#DZ?VXDLRGeF@KT@Nc,fMc9JYDIGUOSM]cSIL;?Pe_4(Sf-0.[R<#9)7PdEO
_YM@=V]QfHcK^9-PC7EacF1@]eEZS)@FBV(+54c=BP[?TIQH>.8)e54>[?D?).^?
;66+WI.#>V;Ca/XebZ(Zf#T^[OdZ1f:^<67E)156JT@6eXMg1ZW_Ja\FG#I._+)C
+fRS=E7^Z/cU[DO[&E>3Q3eRE4Z5<VMAgOa<O#L+,eeEBT4fWX)-bCT2c,PL&LB]
_+P/T/=RSAW;aA;G<HY]MX\)3G)B0<_@b.Q;[4Pb_eT^P9ZJ9IN6g\3.W5>C@I3X
9d3);KD/eH@NT.X.2Y:PI45/#;5bM0@3b&_\3FK\5?/^fY,U>O4,Z=3@3O,9WM:1
X3\=:c(G5BDggV(2fJ;3_IKNVe/9c7OVa&f?+0E0BOMSHA3;.,2(AQ<dP@MN;7EY
UNO?>+a71-25A45D^.W(2GEYQYSPP>ZbTJE=40OIgDK24JL[]5(C&0YFU30E4S2W
B-8@RT8eBQP4)2_3IH1HI;5+@XO]-WVaTQ&95A#UQ+V5XQ3O_L_P?IWY4<@;WVG#
V9-W2EAV&bVb)7GX@XT[K3JGgACY::,Zf,J_&KM-5?;5@0K_6NCDAD2D?ae@E._&
)#KT._@C5TPI(Gcd1YK@LCc8WP9C3;gT01L?D&0WFXMcPVPIJ/9FL=>SQ8f<5YYg
T0LMZ59ESN6KQ7Nc3JG.4=+(MS@4D3KV:S:E2X[&P^D^PZQZ-XUcBC9FERURfH;W
g,7DJEPW>4SQAX#GN=U5TH8&[_KDP479U;e64S?T;X=TT.gK8H7<@;KU)]C,7L]c
QC>TG_D<60b:g>9I#6BZF6g28J;D9eR9?BJ^>>+SbBN]OV55c[7.O2T-L.-5XL=Q
C80+UTL0FcD0:S4fUfH,9AS[]+Sf\,4b?A?0JfF<I8ZS2L0Me)PfDQMPXZT)HRdY
H]LJVX=PD+ZSN;5SNBX:3PY(f_N5.:\@\S])W=&TT\5=M1OY6&LgRK>Q5T>QSWU\
c9W]a#.(#,?GC(FSg\H-]EZ>(?/&OcfU:H.]+#1B/P.9R]\MU]N7=^,dVTb#8RMG
AU\VR\J_Sad76fY4F>E@CU-RR(SdJO0RCH?;.;gQ/.@NI4ZPX3WG[\2P18:.B#N,
/CB;VV(Tg4gfE@_QJ7UW--#?;.+PD?#GVQK[WEC_f3;I;f4F@ZRLb[,C+/Oe3XbA
b7J1N-CCP/TWE#N/<HC75&6Q3C5,A-cEV+P^_QbX:[A4@AF/gV-P)2-?(28ff4,a
4-U9Ye1@O7d-.6+>K;\SgQeXc9YL4DKHA2CV\A]Jb,7?ac446)_0XOFV_WMZ[GNX
GA,YYBI.@16d(c]ZE-Wcg])QcNRb:SNIbc1BH+=H11Sd=f7#Rd[V5fJ9U#4DS,-V
f,+VJ=#2a+(A/)J-QI^K>KQMWW]e06aU8A\+Fca-L_?)1cbZ/Yg&:KG2#PVb2DL]
MI-L+-QSUH]X.Z=XYEY+Y[gP()8XQ7Lgf>?KA-/g,:QRE4D^eZC6(Qd<b(KA89T]
)GW_N-4(=3fQO/^2>.JcC90\/VQ@e3K>Z_c4-:1<\.9Xbd6K]T;X2Q-:T&+2+U9R
:a1L,7R>H\6_L+U:C5>[(c_W>S=KO-A7UJZgHI4:C03(a3MT_<g&A@[6ET4WPURC
+L<U[AIJ#>7Ma,S+a04RTd8M<,65QWYEMFL262(Gf5UAeE4+e2F)UM]8BgE),U]K
>c#b/)28O.OL@>8@B,FP9XR@EDA\3O:1T=ZO<Z?7RJcb=T(+F)MXXR^11Xf:(Xdc
bJ-/PQIFMQWbH@F_8a_P(G-/=b4bXB:M\2O(F^K6LNCSIVB=EGNVafa3R29/YHYT
;MEe[R3CJ,[^6L)8&FFXU4)OQ6)cLdS34,2f7?6TP:PP(OGg7MUGA9+b]8b,+JAb
]9JU0F-MYdEg6V4JV4fD7e?W)SbAdcGMAX_9<YaG+#>4A7E_f9L^cC\#=aR0]f5>
M\81DJCVX-,]DG#3=:YcWQB=E<fc0LcK>@.9BFQdD#B\#fV_]eUR,/gY]0AbA)F4
\4\-,64-YQeD([:L_S^&+U07dBSFY(I(&e1WYaTcHZUQB-04HXSNC)H+GB9A>&)8
U64Kc,G-PXHc;gaRb&F_:2A<5E:HfdX0Ig+KdQV.).=7^9,8a^:L8N)16670)bK6
g1O[W-aBH(/-gW]-e9Jd&eH:e\07<_g=cgO#/RN<<N7e?aC?31),.K:[R>@)5.T2
J2G>@[^&JfNFOR)ecK-@/.L+D#M4J,+bEO#];bY9b+Z4MPRcg_9+0-03MX0[WBg^
B-3XT&H6\6[/>O,>JO[?0ZUYeEZ[#HS>QVD>eN/JfF_G4?#S1YT,]SA,9\PaD#A2
eB)LHbCO\[T2K=#@2T8<fdKcVVWCV2L4?>VE#Z&G@VA942B=Z?NREP\7@\9PWNHY
UE[XUF]OOB?NQKPB#S]XF>>]bFc:0H;)[_ZbHaT.J.V0C8@IfBX:K?JJA2FF_?.J
BBfNG[FWcJ(GGB@EL5;#</^a.6.g)A)[T1ZQ\N>&IZ)QCYHN(ILd2@K^?P.?bgPW
/7//2ZY&]09<c>094+6Ma],N)FK8KRMOB?H+8d>d18-D64QW2FL.I.L[Df8bN+G8
HA;6J#F<A85W9F6TA@fXX)LGK?F_S,[;VG=0e,5D,F&PLWC&[+QJOGVWHNEc+&<Q
+0KU&YCPO<eU+^EfQCeE>]][R38Z>C9G(&6NC.QK4,6-H71]0eDXaP;4\?YV,;SZ
W^>G@L_&=ZLHKA>&dD9)eU94GI1PDG0HQWfc1W[)RNgXOQL3B^eE\)7CbD9J@WE^
D@YM+?@E@(,;7L#TYUGM^4=^H,T22+CCc8g.L:(?,\B9-.d-337.0c9)-WU,#+<7
64O=76Ubg_:9CRcA+<:/c__[:JP5NVDa&O1F?>(;b<J+FO?K&1U=)S72@efVdY,#
--@(D2AIS,3]U(<JP;gB[D&\fNMY]K[I)Y/)/<[INKY:.X+C7MZ5Yfd;/_G\BT)O
]S=(T&NG.eW>X#9gM&-.DgRM0N)EceK0H@A41aR128>IOCfXc-DAA<GF@_A:EJW-
d<8GM#;SRQ<_O2]N]6?-QL3#TVa<ON<^/aW,29XEIM&Y:BGR(551dF8c4-J/>D-?
1dZPP)9J:KVc@<MMWS.Z6V-65,g,63GcKdf+FIQA9B4/Y[(PG[+/4:G?5UQggdB0
YFO_3_#VD4[(+M&Zb&Y07ML8]1?6SaD.,5-VP<A>(@;M2G;2S.SfdZIC],]M.8_X
W#bg<3XL)C:;cfHFY82L&8=Qfg+FXb?TL(.MGLY]7@?S(#S68B:dHc[TI<3=b[R>
3.fK+AUZBV(.C?HR:,OW=]):)/UWHV>JV/6^AKW]-D3_NXENO@18+YUY<(,a;93e
0)QgXe5KCf,C1I=>\JK\&0Z\#g9c&+_5BDNV?J>\g/Hf&bcC1:(>^0;Se4<c.E41
QP<04^e<G<?[d<+fF2O8AZe7)_FMRPf&H:==b@M3EEZ+Q,523RSZB@VVW=cIaD8G
UWKHZ?:\b?U:QU44d9YAF8F>KN(2RWWZ]C2561cEfg,a[B&T>@8.Kg0<:=/FQX[d
GeF-C=\[9K(2JIJ&BY#3U=79_DTZ&/+aW]Q_<ZNI1IZ2f8X[O:KGAd)7+CbL[(Z2
9TN8PP;M7O03;eaI\,XPZ#Wd]2X[JK#3V<bMb1HQGI7SL5-,V;H.TGM+A,&?Jf.B
)RRAR4?X@M\#TVVaA[81+EH6@+MS^2Q(=ZEWReIP1\[^>)2]eTR#<bM=23.Bc)JH
=@/=YC^Wb._G#?D7;Fg^f3ZQO7EJJ>&=C(KC8bL\d?F:7/38gZ[0,NM=O$
`endprotected


`endif //  `ifndef GUARD_SVT_MEM_TRANSACTION_SV
   
   
