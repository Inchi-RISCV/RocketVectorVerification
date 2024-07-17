//=======================================================================
// COPYRIGHT (C) 2010-2015 SYNOPSYS INC.
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

`ifndef GUARD_SVT_SEQUENCER_BFM_SV
`define GUARD_SVT_SEQUENCER_BFM_SV

virtual class svt_sequencer_bfm #(type REQ=`SVT_DATA_BASE_TYPE,
                                      type RSP=REQ) extends svt_sequencer#(REQ, RSP);

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /** SVT message macros route messages through this reference */
  `SVT_XVM(report_object) reporter = this;

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  /** 
   * Flag that indicates the driver has entered the run() phase.
   */
  protected bit is_running;

`ifdef SVT_OVM_TECHNOLOGY
  /**
   * Objection for the current SVT run-time phase
   */
   ovm_objection current_phase_objection;
`endif

`protected
U<a^<_Pa+bI@9Y-X^59X&RS4B,gf)G3XW7Y69?Zc<0T\;R2N0Tb<+)a)BY.:PHWd
]Q^Q/LWcU3A(P[=UCT5.bN_Q,9QX0=T00Ed9-,<I_)>ULBfM60c,O&LfCFf.CSb)
5aLVV-8bKE1D26[LJHVf5<)d#G@[-+DD2&07f\af_E?=]9QJV?[1?JLfO$
`endprotected


  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new sequencer instance, passing the appropriate argument
   * values to the parent sequencer.
   *
   * @param name Instance name
   * 
   * @param parent Handle to the hierarchical parent
   * 
   * @param suite_name Identifies the product suite to which the sequencer object belongs.
   */
  extern function new(string name, `SVT_XVM(component) parent, string suite_name);

  //----------------------------------------------------------------------------
  /** Run phase */
`ifdef SVT_UVM_TECHNOLOGY
  extern virtual task run_phase(uvm_phase phase);
`else
  extern virtual task run();
`endif

`ifdef SVT_OVM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  extern task m_run_phase_sequence(string name, svt_phase phase, bit sync = 1);
`endif

  //----------------------------------------------------------------------------
  /**
   * Updates the sequencer's configuration with data from the supplied object.
   * This method always results in a call to change_dynamic_cfg(). If the sequencer
   * has not been started calling this method also results in a call to
   * change_static_cfg().
   */
  extern virtual function void set_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns a copy of the sequencer's configuration object, including the
   * current configuration settings. If cfg is null, creates configuration object
   * of appropriate type.
   */
  extern virtual function void get_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the argument
   * into the configuration object stored in the sequencer. Used internally
   * by set_cfg; not to be called directly.
   */
  extern virtual protected function void change_static_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the argument
   * into the configuration object stored in the sequencer. Used internally
   * by set_cfg; not to be called directly.
   */
  extern virtual protected function void change_dynamic_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Expected to return a 1 if the supplied configuration object is of the correct
   * type for the sequencer. Extended classes implementing specific sequencers
   * will provide an extended version of this method and call it directly.
   */
  extern virtual protected function bit is_valid_cfg_type(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns the current setting of #is_running, indicating whether the sequencer has
   * been entered the run() phase.
   *
   * @return 1 indicates that the sequencer has been started, 0 indicates it has not.
   */
  extern virtual function bit get_is_running();
endclass

// =============================================================================

`protected
#IU^@a\KaK._,P_P0Kge#Pg0M)P8.fP1<f@849#fE4.Z6WQ8X;ME+)6AXQX@KN@>
NG=79gVe(=_#V0M9MHE5JCOf.HS\.M^>:JHY_+,(YFQdHXfK68)Y9IeaZBA#LWT?
2<S47AcaAMMP?2J#.-86RgG@J7>/B.3(KbUY8_/\7A]HZ\#B#A,F+<dWNRG]JLPa
34C1PAV9MP2QG5E(-TU5?1U6;aY^T?J:PX=D=QT6CN;08VXB-/C1TM2;;_;6,\LL
T.D/=TFE&2Z9b70>)MLYL[+NZA-X7<bZ2a8JGC3M\:19e</DHXg70BB4M92V..:X
+N9?e>RgfPDIJ#<83[=R.I52A,b&BSKFYI:_:DU<eYeL^[&-Qb;JaKeA\#WC(0#C
-fD&/9AOf_;dRa>YFb40eKX<I+]4aUXE)^SB@1_fJcFI2A^9@Be5HO?fYVP>F01;
16G)D+e]@1>]B[RB;aSQdYIAe-3>I@Z;A[B8[K&dDS4]]N_]caNG#1\CB?-?PE1^
45IKeN&43#g+OG<e[?+]7RNDaUEebZ&L^Ra37XDU5//5cd8Z++8ddQ9CNMCK4.2J
40fS+WFO2F][5PMCS+]7XL&6ddLY.H-2T8Q9(_ZY+O;d(3/]Heea1_M:7I/)&--O
1&]]F9+)eYCHCgD<([CVE\677;?2WXOWc<I6aIQMGV,?]:WI1RGYMD<.0YGJE6.R
SF7AKG\)eQG^Q+[N-(.CCRa=1]4dSgO^X.D78c=g06I;;:DFQQ<T4V(fOC8bY6,c
N9Z=)[dU[A<g4A(N)dfDIbRABGFQfQ0<W/O(X_6^\d9(]F^bOd^/Q\gBRTEAR40?
N1OLR>LBVOSNF+5f?^+ge1OLGH^=UQ/KMIB6&2=_&-8N65O#Q>A:&;BXF\ES],=a
P?Y6_YOL3ab]2EEMRF7f_JYP&;[DK5[IGF#H\Z@I)YbBWMWT<+M6f/JNW9(E^)ZH
MaS8XdbIge//:K(DZdZ)+TP79eT?,/N>19.e7<^OY6:EaW1_YKP\(ESLJ)_,0UG9
Q?FSA>/YbFg)?78L+RZ(0K5VJX0AG/MHF6+PVD^eF.(gOXZ[Sd(U,\eAcNV]O2Q/
O@KMagfLI2F&fDT9EV&RIAZdE@^4Z,d1),4K0I+E:2_g&]CWE4OdU;a]TL-CV7\b
M^9O?A#dPPG;3c^cAGFaeUZRV=M;GH::;J-+FGG0X@J:P)Z>Ne,9_VbMF?#N\d@4
&9gD5eZ8C-^7@Nd6P+gPaL.8X_T/N?FB[S.9Lf?F378J8;45Ud(GZ5(bA9Pf_7\E
:MZc?(CP<[;I=@,c#S4>_/&JWNVRe8^Z5\P.UJ[_1@>A(g\?V@E-TbF:#3,)D(;g
95=#VJQ--0b),IR#V3YCRHJQ6dRQfTXH8>8ENQ:I@[1EeA4#/aL;)fYVHQ)PG;\_
cFe+R/c5&bC=OTHBb5JL?9@#<W4V2W^MIL6CAL)Sc+B;XU_e;<7M47@]M@,SI28(
VV#7badT=.fF\U\S(:/aIHG#HE(MCJ26SafBDVM7&T?(Sa]K01E=WZ=Ng<YL[5BL
UTDF\Q.+&fJQ-#TgT^CN:c;eV/c/d\\f^]T>:>I:L[Bc/VK;O;f3Ve<Y?,J7EH/0
O)A&CS7#Q3+3=aT3<Pga]L?NgUZf9HQ)aTB\)+UP-[:&3cL;<g.\(f#8ZB598Td]
a1IOfPeKR#<[bVTT>K[(CVAbZaE&#/FHHDfO>cc,QG[A)SW+_0e+f[PNG@>//439
)YTT,Ue^A<(@&R[2g923ZH>>c&Nf9UF)8[GOaZB9?2AK.T:-GBdH<(G3a<(@PE9=
T_Z;)Y2bf-_b_c>#@P4W?dbYUc8@L(X+:QK0DaN9/X&B?XdD6T_.[\ET4DYcDJa1
LZa9_+T_c4;;9<A9BQ/^Q0Ae^(QW=,N##D1&CH^Gf_>4QN,OCaQDeg<MJaHDIb=[
7aER)?E^7D@N^W;6C(Na@CL\a1Wf3.I]BbIXJ=T(eH>V.0TGG1C+E;[E,@SF.Ib&
IG0=[-7,[TRERd6?V^87:Q2FHWUV>LB0)0V_@.eI17(]1=[.VQ7,=d0]@eENSP;A
_HS_8c-e.;.g@.(/GJ+O?2KS5-cc&be=bRK7(08H_X).6Y+(W3Q[?Qd[XFM:T9eR
7YCb<+#gZc/5c)?IMB6TC,9)a?UVN7VU<I\,>#:U[V]TWg=]0=aS83O_4Z]1;(VU
?:5WDIA4HBAF,M3.-_DY#&.[C+&#)^[K^B.X5ZM73Z:A?X56=F=QE0P;M@HV\DUf
LHM(MJ?Z94#/d7>B95f,,4#@LX3^S>[>)c6_D3fH);VNQ64)41T70Q597gN/C#F2
bRDKJ4OSc;BBZ@5T@ad4#N/ZOIYJe\LWO]\T:(QVIW1YBf<7Ob6E6ODT]U4cZ]><
9:8/GD?QLF=,[3VXSG/8+#EGHA;=XWe&&IRT]e,[\@/?B4f7DCYP3);,?2K_3CcY
WQ.MZ&\;54Nf./NJN.0T;BJ\Cc5(/E>6K2O63\1@</Z/QF6Jg^3#;.FgAebW]:B7
(=Y,+QQB3[cF#IVA(S1XLf3#4WFe/Z^==@^&[DWTQ\F)E7UD]:]Ka2619\:&-3B?
;\2U2V-P&FgAWXNI0;R,@d[K@Fg:_YLE_J3d775RZ:\;Pdb0]OC,/C2EY4ObL<N0
>b1U\SJI;3#93GVaUCeE9K14-H^7H\E1OY2\BT?];2U&(JgD]@8@G+b9:;3,E?VQ
\gKd7#5e:d7T(;(1^@E.6;K9BF:9E[RR;B-_(R=6H[@T(BB.e45IYfB\I:;DbeK:
[./bKUU+Y.RNS4LD:2FKDO#5J0e_2Q(X\/gT9T?,T0#.\)W.=WA&^G92U29M>B3V
7RW83(4Qd/bGC-\(A^bf@@ZXA=/4:[JY=/-_3X+/^DIRfdT+?g8H3EWLCAL?A3)9
_4N^b9L.T2Z@0c9VR-ZgDEaO]97g>/bX/X5H=W^?IMA1C6U6TZ;g>7gCc_I.A#&\
B#+O\QB7KHMeY(>H&HH4Z8D.N#2T3J@?,]E)]3FaHXc3S38:ZMFDF8g,GWD?#GCC
Y;c-@QCd]U1[CX1G.CC5cP_5;DPc1Gc)ACV]#_H[Z9CTY09P\/)G]I,Y\bVKI:dQ
MZYEGU/+L[4f90UJ11D9THe7@1B/bNIME,G[P2I>_M_dBa#ZIM5Be1Md#ZX0@SDZ
a.##]P(A<QDH?_J+@:E;+T?Rg1J5M[@6DT8([KIA>8T<.#I4B+N(L:8_:0)=,(:f
:U8#__?R4NLcYK2IR<,TFVA3Z=R/6He=d3S.JUQ?dM+?2_D<FZgO8;4XT_H^(R27
HN3[3&,PF:M\N?O_[N#g@MO[8f6;+dDZfcQ;aV&E[R/\)E8E;1\0WO(3g4\3fL=L
c.<;53:F59A-)4C6+#1;2@2fe@bB4A@&BNg.<,28NE/b0O^-QAE?[#E.QD++U_-<
U7J:164B/>CZg)37Z\]^0G#MA5)]X;b7.YX;2XVGY5F<>fe[1&\F:/T+][fFI#F.
c2C-TC\&Tc,-P4C\]U1A>&YD1H3cX,9V#cD_WJd0aFf)[fP1^=Y8X[NSU7_W(1gZ
F=1BJ@Y2FXB^:VF@CL.BQ#e:.AS?PNWU9,6IF.02Xef]L71-1OB)e_ZaSQcJ0<UP
=A<XTW]03_JfEG8?FF52EA6/OE\E.)^Y7SF[VH29-A,N-#HLdPZc<U_X[X/a9L].
cUY?7[#T[L1A/Sag(A>I(fdI[]Q&_aM:Cb1R,<U1XIR[?;bJcQVDB:SabWSO=)LD
9AQC/2^D\c0)?5E7KASNK,>QHAZVaJHL5Z7M;&[d)D01>)/ZNOc&DbAF-^C?QgMO
f?Qb[&+0GJ\2/\La8VZX8_=NC=XND_3=3?>QT\KcM92H4_@G@J[=7-K5(2EQ>HP9
+A)g=S5ZC6+M(:Q0.ZUI+QWIQ3Y.52=9^5>?X9F<876a>8S94.0\K_WCU2)D@ROB
GY2dN=?Zb/^2Pc2Y#CMU3g>&gIaT.WG91PdX(W(]J.K_eB6[Z.3?B)4S5T23RU?0
JIaLML5cUNUNLfad>N<Q9DIP(\ST?)__4K#:&AP[>\+39U#KNAKK9FZF86e<aV&6
ZgMBfZ+7?N>)[]=[HAMVL3We>0)g)-W+-GUCI5.,-GM6<^ef??;GX:JV/Rb=0O]G
PN&T,Ze1f]J9]OW7Z3f:J[YC[VUBCEU2CL/T+D3gPF@=@>>UMIL<cB3B&^2CBG7A
)2_Y.Vd3gAV?aD6)_<IE8Zd7&U#\N9N\7FDM6HD4Z,/BcW)GP;6Y>XH,+d,cMg(E
U5d/ST6?>OeAX+d>O7f-\S67EHOP>E23XS:;)VFJ>&:2?2E@B429J163eJF-EMPI
_=_R#?-#^X\TD8]YgHcHV1PC5@?XXB)-f@AFY^,,aHKTe]aEB+CX9A^QXPa=,L4W
+@RCVd1SM&C&RG&c2N+E>^3@X?cEd3g^VLe2&^_>?L87[#^b[>+B5BZIES><g_UK
-5VWg7XaB<MX)R/,R>KI649.@a=X4-N)>DQ0be&L-W+^<a4HZ\KMgg<eC+>7BAY6
45(M)A.3@gA/33=a7Y0Y;O?&GK(.B>LR:,)<1F29M[XERY_Fdd(^J]/bH=ERO.VU
OJC;\bA^bV<<NWU1MMJTWO\SN2BgbB>DbC.BVRW&F_EN6<E/0B5MWH8gbYSB++].
=fd^(XPVZC8:VYC8bfNUU&/5.IV]E/\/@W<KJ7Ef^D(O^@NG>2@X58<;W)C?7,+.
POD5=-B8^<UR4R[BF)7X+d2M-<R3?]6>8F_J=/)V?3Q->L6,+MfeYPV^I]/BbS:P
-EBGNOHFO[Ob5,VCASS9gL@(=D7U0^;]4c;56a3:..<+R&5;e@gT8NWLI\@LF4:@
9;GL^Q+(VVR-;E3JM8d-37/E1B2,5N=2gQ>d&<abD=H5)47M.4M^>Lc,Q0a;\NcD
.c;E=8,8#@>EIW,^GH3<<d;B-P7#76.ge2?^>-_6RI3V:=LH6P<3J]XE#GI:ET]&
G:fI3=D=&;<_(CfAK]G;bZ2N<cWV-)=7X\[]+W();#CYbg>WQT+BLN1>5>4N5ETP
=;(34@MePW.JM38V>:gg]]G.DV2fWSfQ:O1B+^LQLa^?)U.+WK201aB(4Q)_E=EU
2@Ofd@-6NBf1ZFR+IG[H;=FF/+@H1#H8\];5]]XIXa&(XXgL4&24ZV4&_a7_69<,
/#J(_bOXJ6_,H2>5Z7?R>;;-a&.JGEN=^Ga\3HLY+#2QE]._,.U<3+I-CTKJ9d;P
UMN&^2^0]>AVO8GGR=HP8>=bB6HL8eLXWXSA-1TeVK3J3J1\=Mc+2U_>U)&F)CE[
\H]VM+34=+(80?2IDF,&(].,<9K5SB#(DB=P6SH16gUJ9WaHC=41S1,c8]ZC4(Q?
=.e&T=FQ-Q[.J39I&_,,A#YWH9GUJIL@IRO6^RMI?X)d+)a50TZP7aBOX?ef^1&A
K/]F;VCC(8c0I;H)([OT+=gMZ>P^GA#Q)S0RO:K+?LWW32D6,K]F5\\OG2>aG7,:
C:+RF-=TV9[]>bH@_Q@7/>??2Z;cF\d;)MbfYF_?bPAP_INOOJ<25GNVfabCX,3?
FdV,7[I7KIb@e#.VLES]-P1a;)3I:7X(Ee:+;HI9e:SU#AWN/U&5C3>?HRHdHTS[
+F6W7(A]W^JQ@d;-R)]?dA?B7R,;b;d5GA[_Vc)&:bJ_);;8f_#CI,,a3<0)bd+L
&0UHDGME169CcU=g5KZXF;\Y?#):0J-A[B:2RQNO>>Z#W=[0U^&,MUC=Mg@KY7X+
(4T#^1ME2-<C[:O&0gXC#8_H_[c)7XEYa5[ZT>=14]0aS^E^-#:)HS_AS0-HN5,Q
_12+@RB3)OFZKGXKR=NW_&eb^bAdH_H[(ZI7)Hc=a0E+UO-6OVZD062QaEcFW2-f
:].C[P@K<-aS/A-(RIgV:.HS=9-;@=;,Hg#O,XC.#/[DRLQ[Z0D+4UD9=,R.@fX=
)96,YQ4YEJ_@5^8(Z\Tc9a()@.O?PYTL)BH^&M[a3S<[WJ@(e[IG\M:_7=8O:7SN
]Vg7SI^(aEc,)GaQVfZ2#11cCW4e&DeW\OGL]6CS.(Kc<FF>N3F+WVc&#BE0H^S4
<)g/WRN@\3VPV=+S:@FMdKIa2@PA@@?Y8.A)K,)Z\PV9?I/ARKfbMM\T)Ic><IX<
e3Q3S.Q[g6C\H9BQBM)VO:C+>EA8O1G3)D/P>[@d_R=WMO@;EEbVO-\\FL#aH9Sd
6C72B+.[S9fO#OT)Q7(30X.H&@_WMVf=]D)Y:=PPAB&1#MC.<H_Sde)3;,_MBe_D
aZ-d2MZNOFACD[>Y<;fSPeSX[ES=[15,58IX74+E@P>M&BB)beea@QU^^=)?P?@I
ccc>e)PGTb(1TAK@T:DH45R<+9BT[Af1G+8ce7)f.^e:9dN]?=<IME9Z:IG<?adF
<c)C6T,^4PeDd:9,@W=,=EAP?A8a;c@W^^_+3WV,>V-05gTE+GXC:4f@eRS86K1Q
If.Refe?;c#2\Q9Z9SZ(/]=3P&2H2KT+33\IMI0Rfg;_KRF#9_ff]?+Cd_>#T/3:
ReV.HZ0+558BbLcF:BU][B(Y2MeV,JRTfe5.5E.#c6+PQ,:7[7CX@ee^3MX2[)R;
-DeW?/PCT.JQVc4TAD>MU.6gcR]8ag@;OG4g]5HcTbaTf#-VK^3e^-3cW)ZF7:Y<
MKO9(RF>PeTdP0(N.gUg0&PBT6O]<Df@L-BW:NZI?Df+06GW)@F(dKYTC[RL>G(?
4C]N#4fQ#UfIb28eS<DU5C,(<F1C0CSQFX4&g)+UG_UFB5H8P;[P.92.PIH_ECL8
Vd8/-KT?O##e+CM1X@[G)f)Sf...F]f&1]9F7UKJC,+PPYe>O&,6RNcXT:Lg>0#H
1bAZVaOQ;=LJQe>ZL6baG5>cO:f_?H^J0[FQGIW+/)PT3AQ,H]MJQ[c@N.H&U7?K
OdfF_T__eZc[YSEW1O.@(W+gLB4JH\>]MM:<,1GECB=>09]g]=)0(257Lc]MQNf4
_^_[9>aZN8M9+DAGR=f,9]a<?ZW#=7SM0#3E_bV5ME9TS3,CO,fTe:#^E9DcC_(2
,3GW[0J.GP<NAM?LIJIO8g\(2b/ZL]?+V]Xa7Jc5^KQ:2RE08O+7S&HeX5#G/7?J
ETR\d^C1gB\&6NE87bRR89K/eX)1-d28J[C[P5(U(Ng#+ESC0fP>#?=RGE52(ge0
J^6HUaJ-5>>+4?2C-J;<KM0+c_:Rf00@@\UX)/=?eFKB=D,6<DAMZS12N#GWDgA/
L?KBa.Y:4JXJQ@@+\f-^;=KE:T@ec<XJ[OV#FF-MUVdcRVRJAOa,b?&#T@^ILPC/
;Q9E5,WJ(VN/cPZ)YbG.-:9L3C#87dT+-fFP6(^M90/C-J94D?/BGB1W0X-?=\W2
C<\+QF[75Ac7;,E/;W-Y]PVN@M)<bB=bQ\]=/@J-U:DK.0I.DF:3G1ENVcA/8A-a
G4@3IXT^U>JJ^+@)gT+-U0G2-ULGL0#G1SK((E>Y?\WC2GB1TeJF#,..K8[3..Cf
+87^B(#9T+T0=YUG:X>c.F>Geb2(BU^(f/(ZUOE]V>(<BgG?1TTJcM-G,NGNEFgS
+8;SWM#a0(5LH[)0JOTP^Y5>^YfN7#EX_HS\KJ1g][>bFgZMCUa>^CUJKTLZf<F[
]9-dBe5@&MCGQGJ=0B&EEZ/3=0P]<#YKMf&X>F?&dBOYX4CIZdZ4B9X=1b(?83_^
X/25)[/VH&VbM0dZFca35G\R>Jd4;ObXH^1-DWSWVbgCDL\#FGf(28?62gPUA-Q&
Sb^Z1?LNR1-fO8;EXLe0H_a(F[#;G(JGMD@E0CaRV(0X>-5J:_2.3CTbe?36K+H]
C2+F@Dd;bDI),e2WWX&^Y2GHJaF-a,8f8d)e@WC]&<(F\3T]2g;DYb[S]R&gE>[K
8d>KeBGPDBP<&+1:a-a&8RBfKY/7N/5#Z_-?-+bS;K:c/G[^),?/#^E7-\IN5_]C
@+_12<&[KcKgSV#W5/;DKC0TVOXNJg?[L;f9fa++LbFc+Y&G6ff]ATLg,:A;&^#H
D>OLH:\g>,XGc_.8@O\@@XP_JSGXHS2WF>>b0bM.8#K;(AT+0=9,@]/EVY^d63dB
SGIf6=828c_,PW5K[-[3?XW#,SLc\0B:_?8F/K#a4LU)Ea]fZcDDDW)&AB>)U@fW
4X0PRBEN00P^2)IBCY-A=J[#]6IHIAYH&X9;LNTa+)_#UA^c8P<83-+a@J#dfd/d
4c03-<LF#OJ/PP)3+KW^(?Ide30]gF,dOf=GLb\H5OOGA#,XUbc^X0g#=gA4@AU?
1NSTM@=9U]gU+6a.\C_TSCPIRQL5bR)J0BP,AXC2=OV9IHM&ZXf]@UN\WI.\]1JD
&b&IC0LZ>&SOTd\Vga18/LUK7]R5?C(4K=.0;Y,5Q<1<JU@8D^H@BbPRZ/M@4T4(
U?;0MPA-ed0=ELX/fA==?XEZ(S-IE63(BOD&?XZQ?-Oe=Lg>Og;C)\Ya7,M+@Aba
MS]\c>4WP0[J?GQKOIR/Wd@.BVR3SJ3_PDA46?/_B[H:f6K93f,Vg<:Md]VbGa>@
OBZ9]?Y+(f^X83d09fcF&):6L8E>?5g_SZ?J:bdE4cKc-g;&OS^9RNQ:C4caW7^1
OX5,GJ[S#+ZdA6e[K(-McgG2YT;-JfTD8MBY#YZfF#.0NeSTOgB19Hf:L[KbgP.;
_(EM4R+.M=#5g33eO],O8B0)@g0V,?G)5\8FO;F^LQ31^)ZJI<]0XV-YLEE^8\_=
]PSIecb9UTJddXX0F=7Xcg9.Y;]1V\:c<T>E;d=d4T5MI6eLJ)Jd5K(>X30OA4gM
0a/,:OE@,Q)T__P8F+#CG\F/>K,NS)ILC/AJ<:Gd=TI:8&Ef,0>\52(>I$
`endprotected


// For backwards compatibility
`ifdef SVT_UVM_TECHNOLOGY
class svt_uvm_sequencer_bfm#(type REQ=uvm_sequence_item,
                          type RSP=REQ) extends svt_sequencer_bfm#(REQ,RSP);
  `uvm_component_utils(svt_uvm_sequencer_bfm)

  function new(string name = "", uvm_component parent = null, string suite_name = "");
     super.new(name, parent, suite_name);
  endfunction
endclass
`endif

`endif // GUARD_SVT_SEQUENCER_BFM_SV
