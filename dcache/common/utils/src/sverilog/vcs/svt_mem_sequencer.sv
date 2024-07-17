//--------------------------------------------------------------------------
// COPYRIGHT (C) 2012-2021 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//--------------------------------------------------------------------------

`ifndef GUARD_SVT_MEM_SEQUENCER_SV
`define GUARD_SVT_MEM_SEQUENCER_SV

typedef class svt_mem_sequence;
typedef class svt_mem_ram_sequence;

typedef class svt_mem_backdoor;

// ============================================================================================
/**
 * This base class will drive the memory sequences in to driver.
 *
 * This object contains handles to memory backdoor and memory configuration, sequences can access
 * backdoor handle to do read/write operations and can access memory configuration from 'cfg' handle.
 */
class svt_mem_sequencer extends svt_reactive_sequencer#(svt_mem_transaction);

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /**
   * Memory backdoor 
  */
  svt_mem_backdoor backdoor;

  /**
   * Memory configuration
  */  
  svt_mem_configuration cfg = null;

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Local Data Properties
  // ****************************************************************************

//svt_vcs_lic_vip_protect
`protected
6_?]de3LgYIGeE8(2/=Y48G+]AOL6]bY+7W24@K87N^0XEMU,Q_(&(.fKX5:@ICZ
g^J?]gY7VAQ6EAMXD@I3g3e=>=LQb,5d/:_WO8A1;4-JP7ZbdcNf:D.Q^O(LBb7P
O8.0G@B7Ha,NeG\L>,Q;^eA]JVZ2ADeCaDZ\TYH1]/Z/Ke/TQF/:1aR@MaV-d5H4
3-&05Z_6QEgG[E=fbMQE+RggO929]#W.BWLS,cg,QeR/F$
`endprotected


  // ****************************************************************************
  // Field Macros
  // ****************************************************************************
  `svt_xvm_component_utils_begin(svt_mem_sequencer)
    `svt_xvm_field_object(cfg, `SVT_XVM_ALL_ON|`SVT_XVM_REFERENCE)
  `svt_xvm_component_utils_end

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new sequencer instance
   * 
   * @param name The name of this instance.  Used to construct the hierarchy.
   * 
   * @param parent The component that contains this instance.  Used to construct
   * the hierarchy.
   */
  extern function new(string name = "svt_mem_sequencer",
                      `SVT_XVM(component) parent = null,
                      string suite_name = "");

  //----------------------------------------------------------------------------
  /** Build Phase to build and configure sub-components */
`ifdef SVT_UVM_TECHNOLOGY
  extern virtual function void build_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern virtual function void build();
`endif

  //----------------------------------------------------------------------------
  /** Extract Phase to close out the XML file if it is open */
`ifdef SVT_UVM_TECHNOLOGY
  extern virtual function void extract_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern virtual function void extract();
`endif

  // ---------------------------------------------------------------------------
  /** INHERITED METHODS Implemented in this class. */
  // ---------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  /**
   * Return a reference to a backdoor API for the memory core in this sequencer.
   */
  extern virtual function svt_mem_backdoor get_backdoor();

/** @cond PRIVATE */
  //----------------------------------------------------------------------------
  /**
   * Return a reference to svt_mem_core.
   * 
   * IMPORTANT: This class is intended for internal use and should not be used
   *            by VIP users.
   */
  extern virtual function svt_mem_core m_get_core();
/** @endcond */

/** @cond PRIVATE */
  //----------------------------------------------------------------------------
  /**
   * Sets the svt_mem_core instance.
   *
   * IMPORTANT: This class is intended for internal use and should not be used
   *            by VIP users.
   *
   * @param mem_core Instance of svt_mem_core class
   *
   */
  extern virtual function void m_set_core(svt_mem_core mem_core);
/** @endcond */

  //----------------------------------------------------------------------------
  /**
   * Returns a reference of the sequencer's configuration object.
   * NOTE:
   * This operation is different than the get_cfg() methods for svt_driver and
   * svt_uvm_monitor classes.  This method returns a reference to the configuration
   * rather than a copy.
   */
  extern virtual function void get_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Reconfigure sequencer's memory instance with the new memory configuration object.
   * @param cfg - configuration object
   */
  extern virtual function void reconfigure(svt_configuration cfg);

endclass

//svt_vcs_lic_vip_protect
`protected
:9+<YXdW+#D(<+6L_:\B/L&&5R;SO@+XG>[dVP;?EA:+X)M^0\R52(a##N3U;(VU
CdML);SPf#f#3X)E]e_O>]DF7-0N_EIZ5(<<850Sb8T^I,O22H(Ug]=R++C4TPd3
U(ZYXfEIO,OFe+&2eO3S[F\<Q3D\-6>2U@G@IDT7LDHK[-.]F&f([Q</bR:b7,4@
OTR_M;YN;J_G52R1F+IR^/8>WSd<dDe+W@7TT:@gX4L^JC66e:C)^ZOI?<-<ccDB
)6-^(6UCZ6E)M>D@X37YcfLULFUSKQ+KIDIMf5:J;;9>FFLVP)5E\Z??<.DC&H-F
OF26[g^Z#X/^.17#d0@Wf[)IWS8/\IDELY9VLJ=@=ScG?FWUMg2)83=P_BGOa2PE
a1a&ONbXGK:.Y:aPY337&O=#VcP5O)FGR/&1T6V<Ug\1?&XM(ad@fBAfI\cKP=Oe
&5@cgKbdgTK(4Ib-;fH\Bgb+g0AB^BQ:Z&AOK-ZP.62XUNB3&cAeNTC))T1e9QZ^
1AE#:L=0F0K=ZG:-&?^c5]#)],UY4>,/I:Z\_\H/GY;SGJJ>)G[d2c.-;]6LL9K4
7fCDE6_3D@1GG=;Df6<,N0ZZ(b3Cc\9LDF[5YS5,D&6:R]>HO/_RLVWD:^R0KC3J
2c;XOa>EI7X3?(\9eHPcC#C.#CLM[28c:R=^;FQ2gL^ZSaG8D-6ZSFXP^DI9YQ;P
+X+MXA&1+45Y,5F8/D/BN/<97^8-/C:G0\O,I5F</&C+5#U3O1SJ(9RGJgTV^^72
?,8e\DO#D2be03g#g9IEG40)EgU=5Yc1+I;XFN;9W5Z:J8T&aU^]1MJcCg)JK0cR
A):,X+f/VV5b&&\82b7^/CAZ<8AJLXb)OaI.dS-8](]cSSA2:+dG&=SK;1]@+_0P
c/0g]?;T8X&DC[8NP]6A<10-cd#L1>RS4W/]K.M=Tag@)6LHGYMN=0d6:c0<I5P3
RL8JI9+b@D_WB:e#S7b3E>RXg@@[c,/CY0#OcI=V:K_.2Ja&KTAf.4GaMY9,e-L_
b]Y5a+8R^WX82NH^#U+/FWE5Z<7P<HC+?f0^<:34TXg<Mc/.cZ2,a9.IS&-d)<MM
_U=DS&R,FdF_AG]3UcK7>Q0NIBgCJ)4b&MP#A[LAKF9,?\Tfg/\4e7KPG.N9;-P<
:Ve;U7dG;_V]MIa+H#2;6&6I4-JK([/=ONadO[=V_Z4UZ[f19G5K/:=SD3-f3fG6
;/J9B=#(5?^;TS9a-_.Q,]Ga0KQCaO8g6^+<>Kc<JG_bK60>-gB/OQ^]^A#5:L+F
d:dRNc\()d@LL^ca<JF1<<<IbXbPVf:,Bg(\O,CMST?[1O9e0I&T4_;fa)[MXTZ)
g3,eNegP;^U._P=ZCC&YWS<<6&=[>g=Kbc_gHQ)D0&#.B?#IY@H8K+8\bA=UL11Z
P&>B/b.G^=W1a&/\_c.H3_a9PdQbFFU0<b?JbH2VBJ:0ZQddG.-[@@D:JCV0#>E#
ePGf+R((cHg>&><@QNV7.gKfKCLBRQc_TR_=YA[8W-HBIQ9[SQ;dObg;I)V.+c9#
_f66#2OaV]DfJ0d3[ENbFFS:)9;BLQ^)=G@Sc\&UDA]8f_V\.KEdX5QeP5JVeFER
fP@G-7N:Ed7T,2GEB<M>gcG=/XF-cQ)Q21TS,O_&T7.?QJD4F-U@J)TScCgdM1FG
5S@V?XL5DgdI(?1?O;:5-(eFWXKDHRSO^RS,d?1Ca:#:AHPVLU?_RI-CQ_II\]P\
9?\Jc_g(1J.cO^GZE74MGG0PHM5=2;Og-(?e.F\&O):(PRD31ONYOcf?_dM,#0SP
eCc&J;e;WD8W)W@YQWgR0(UV5#7?BUJ8X:=DUd=\.WFMGJW96CE8R&)C:FXVH:)/
68R(eO-QCdZ)Z0-[\B3BGP4:fBG/e_gA0C4@S]X8J6HdeGRPH8ORNB..:-B4T4SH
8[@=O=)C^\XO(B,G=1DBD@IU+H-:0BRf#J75Oe##14b0aUX+;b#EObRX>F00PMg4
JbYaL;9b1DOgB3dE\9XEf,<<05]]PdJJJUU26>)4X_ag[K:4e3gPCAY@M-2J-#.(
N4eMR?@;ePaNdWJ,L&bY_TgGZET(YW<.TJI#@44L4c^Q26#)I^VRE_5aU1CWeE[g
^)LEPc^L)(UCHgPf_c2V;IZ<QCNbf>BbM&S:P@1Q[D219S6Mg0#9-ULUP0^]CF#2
+EeUQL[]Ub)8Xd\@^W]Y2Q3,[0K4Sg&<IM.-PPV5c]#Z)]\ANGf+>PIc:HBUFGN9
2EEJ+6R/[XI:6MR<d[[PZ<(_QC90+T1>:>GPa4W1fYI[R=9/04[8+)G#<U\DV3ge
4B>5:K0@BI]Mf20S11T0&,65DVH1K#RV@[2VT@@JI]O;AR&;SUQ2d3EaTR[4dFf@
\_LOU1OI5:V@XI\8R2cMI+7F?-PgfMS,ONS84S?M[8=>A(:Ze_-1PX6X:95GANa[
Ac@<Ta+:BeYCFgFSL7J(KZE6>0UDIbZL]4UT(BWP2^gCGJf//Z#&_Ae=;F3LeO(O
)S1E5F^[KU;<@(&U/2RE@B(0da7TF3_\3,E,dYL.@A#(E=]U(>]KJJS#_;d;6,.b
V4B+R(^<-=>#VS@_M#bXB/C9)F<^?YCZ^eaGK/P[MCdZb9\a9^V#Q:1;MEBJBHS0
>K4/gFUc0J],NJ/[=+,5G<[ge1DeI[RP<W3Z&=I^]7[_e@M=(]?B2faUD]/1Xb/A
2H7JRJEPR\81N1H9&c3RHU&A&G??b\7?:9UG^36<GY,?TP30aH?3\FA.-G305XY.
\]Kg-,(]0[0QWG84_bg?,c&?g.b0H+-b4cYE&.:++Q,:XFd</\D4F&?MN-IW8g,_
UT7O.]WG-2C9cS?6UGB]c]X3((aO\C1@J7a-@&:f16&AMJDb/H7)<?KDCMB/-[.A
fI)BHS#(.<.,+[f^7:JYWJCb6GC@1#c4)>&L71Pg/),M+<_]]Jd\]bR-O&cMY>D#
B\dbDR.2H<GcDTSMI:Q+5ZO2HB,:MKTWIaGK+e=>2XB2(W2+6D@761)A52X)-/=<
;&dMbQC,c;CAX[/O767BMW>(b>G:Q.GY1WPd@3U)>+LG&K8F#eN42&_/329C-=<D
J(<Z#4:+cF7\PEcc394_+K6f5WN+3]Fg3N=PUf>/U2.3C2E4=.QaRN[PLdU1e+J8
IE<[5VJTN&(G\W.d#:N9Ib47cSQ(&f/Y(0:V)(C;#VIQ<0ZNX9XC1[eHPd_66C#J
PX),E(aN2b8F-?aSg^GM05-EU-5@Q,X=Ha^dDQSD+a9;WVH4@f?@SI+JF,:WBR&_
^W(\cF#QJF.F8.(>aY:?[)=5a>M/XagTC3O7C0:@aJA1&_)DS?IVB&O#4-d15.3B
a388g-S<4fREHL7<DU+6(#-=Y30KSQaIM1CP]U;(><X[1ccIG^71M<e)V?a\e@F>
#VgJ[\Ub1F?8;)Le-OKC\:_PY;E8-=+U+<:R4d>UcQN=TR--3;+=4A<,6@Gf@=;-
=[g=X28THd<6PS/C5(4L^)D@C#<RRAW#.^K8^g>53>WMLH2c#QeYe.4S86H<P@V[
<JI@AR3KPOS_B0&1F\Uf4TM823e-T.ZN,(?R_dAQOP5><A;f3RZ&G=Y:d#I<J^G=
/^2KQcRW7L8OZ><BB:^fBIbRZf;G=O31,@5QSQ/D1D2)VG]B[U4<[LaS1<CQ,I[1
cQCG@gfUOVcWZHF26Ug=2G&dJB_.IaY,FK(fb@JS)5-K;/_D&V>ZLF3M+gUD=aWP
>Rc6)HTXHB=[V=>G6VcD2#&;1QCQ<T1b;B=:.3g/[.6?TW@J:KQM#<S0\;4WSRb=
-Cgd.?N+a.8U^R[O0VX&Z,B83@(?.-D8IFM41/aE?Y;+OL(D<HJD_[@e_28Ic,AF
]=-X1;+;gVEf3QIZ[cXb?/,ET],BTPdNCJeIM&.)&8)WE)^aRO_Rb[ZM-FR[a(FM
)c?K[-_7U[&>]a-<RW;FMf>4<XGgK29[.L>d\S=L/DV9UX-J&0ZQOJS::)J4\3g-
WcEN]F7KEXfTDS0YG:0K[MD)NE]4bI6a\1]HfY+1c>UY1[[-(25QYafg[:aT;8ZT
9b31.[_NG#L91c[\QYg:<0B>KZ[G/2gdLRHH9cQ5+0EELB[e4HZCgNeAM<CWQ-@S
RS?a;aD=(_SeDPA#H<.1\aUXQ>FaW0DXI+TN:QSVDQg)6(#6-/8L1PY491Ze_F2<
AeBVcC,B.Rf5/8?:SVd4+._X:[X__3+Q_4RSeX\I_+4Yc;>@R>52e7>eL,d+0;;\
=MW:Je\f:g(N11GZ6MV>#)CcNRQ]LBM50Jgg0FU1e=01[/)BQ-GdB,H\JKL)/EDg
4R6(e#c@#2Ze\#9K=?G0(JB>S7g/[E5F[-ZLJQN9U(97;d#,:D2\:?c#)dHL)G1]
=aE3P3#TJ(\+:,DH>O)HYcb\]B]3365MNFH)>G-T3)Eb>;O^<+XcbKURb.L0W7)\
HN?9G1V5H\WS]MePFFC7X_X3U?S0.5S&@J5c]QE0.>[GZ1Kb8V7B.f8>-cCD)REI
S,;#<O@G((bE6-_R]0aKP@;]TGVL1E5c)e)&PP^f?GT9.S1YZOFTNC[[GB7E5b>>
K6Kc:S:Z[WV<5)E91_Q_Z<.=0b[9[I+4N8#_0(5?5;IRF(_[eTTgD/]OBR@]ZQE8
1J>D2#4>TZaaa_H]<E8)\2+.2@5MU[Hf0g:4X&-HgCZ(EIfG3[]).+FC46XbZMNK
,#FYeUJT1,Z_Ce(fU#Me)C#/BNR/09fS/U,[(10.U4S<-6SeReFG\F0U/fVe6B-]
Pg1-S3?&#F1HJJ#TLC(9TBI?;=<bD&cTU/E?-.KRU5<MQE/WF,S,?bgA6H5eUU\7
3]IadS6A.I[9UZR<P)G@SS:8B;=,@(][GFd0^L<Ve_deD.=R7V9Na+EDfPY#/XCJ
O7]9S)L@3IB:H@>J92TNKDD@&-dNB]J51)F&(BV5SBdN7P-W#C+dV@I##Z8L&MJL
L-QgCgHE24]8F[MeSYc.3e4UW&8(;&K\2>\SAOb=c]:+MSOSe<AB6KQ>,[8X.ZT_
N,FV#);E9dQ1g3Af)N/J=ad]AHC-.@IF[T4TL..1d(1TRFE6K@JM_a2BQ29JA0TJ
GN/3O)J5a,#,?)U[.,4/D+H-4YVK6W@P:Af@B324\Z2PIY+JU,dH2\[OEQ[7>?8>
IbUA>QTT=<e6:eCYf,[F-2>?&I&+=]Od\,K[./QUFaO)1[R#Y&H+584(6I,WDZfP
24;1LQDQQ:^,PIf0V1:&H+_TMMEIJ1g.gE<IH[ETR<,S7f+]7)1K(<?>P_0@AGO>
5[XTK2g7<\WA.12]FRGgaL7ROXDI,9P(X?M(1+,g>[D5]H\J._PPB(BB.J><OSb]
DY)c7b=&PM>T97;:<=/d_8>)CSfW<Z.VMG^IQ[W^2#TF@U8ee)E]AfUe49-WD]L<
BXP;K8?3G_Ga6CK>2[\T-d\JGHJY[AN\(TSEG1#1fDf0T1gN+H&>e9/NKAQ3]<__
W_aN5,,X9V5+J=OR#bFY5Wee5B^f?15d2&-7HU8/fSd)M(6U/)(8^K)5Mg]FJ^(/
1?Jc[V:1,6]:RX_Q70[&WN@-Q7VW=KGVLRJUU<2;GTH/A9@[9cba]2_UQa.eV/MC
8T]>QA8#-:?1?Lg5AEe7b]ZbLH2Dd@R(NDSS-H+7V/gWf^/^bdA0934,LSTg#?a]
d##42,0d]-\1/$
`endprotected


`endif // GUARD_SVT_MEM_SEQUENCER_SV

