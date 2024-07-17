//=======================================================================
// COPYRIGHT (C) 2016-2017 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------

`ifndef GUARD_SVT_GPIO_TRANSACTION_SV
`define GUARD_SVT_GPIO_TRANSACTION_SV

/** Class defining a GPIO transaction */
class svt_gpio_transaction extends `SVT_TRANSACTION_TYPE;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  /** Transaction command values.
   *
   * - READ       Read the current GPIO inputs
   * - WRITE      Set the GPIO outputs
   * - INTERRUPT  An interrupt condition was detected
   * - PULSE      Toggle the GPIO outputs for 1 cycle
   * .
   */
  typedef enum {
    READ      = `SVT_GPIO_CMD_READ,
    WRITE     = `SVT_GPIO_CMD_WRITE,
    PULSE     = `SVT_GPIO_CMD_PULSE,
    INTERRUPT = `SVT_GPIO_CMD_INTERRUPT
  } cmd_enum;

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /** Randomizable variables */
  // ---------------------------------------------------------------------------

  /** Transaction command */
  rand cmd_enum cmd = READ;

  /** Data portion of transaction.
   *
   *  For READ and INTERRUPT transactions, it contains the current GPIO inputs value.
   */
  rand svt_gpio_data_t data  = '0;

  /** Data bit enable
   *
   * GPIO output is affected by WRITE or PULSE operations only if the corresponding bit
   * is 1. For INTERRUPT transactions, indicates which GPIO input(s) triggered the
   * interrupt.  Ignored for all other transactions.
   */
  rand svt_gpio_data_t enable  = '0;

  /** Number of clock cycles to wait after the command has been executed
   *
   *  Default is 0.
   *  For a pure-delay, use a WRITE command with no enabled bits.
   *  For INTERRUPT , the property specifies the number of clock cycles since the
   * previous reported interrupt. The first interrupt is reported with a delay of
   * 'hFFFFFFFF.
   */
  rand int unsigned delay;

  // ****************************************************************************
  // Constraints
  // ****************************************************************************

  /** Do not generate INTERRUPT commands as they are used solely to report interrupts */
  constraint valid_cmd {
    cmd != INTERRUPT;
  }

  /** Limit the post-command delay to 16 cycles */
  constraint reasonable_delay {
    delay <= 16;
  }

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_gpio_transaction)
`endif
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new transaction instance, passing the appropriate argument
   * values to the <b>vmm_data</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   */
  extern function new(vmm_log log = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name of the configuration
   */
  extern function new(string name = "svt_gpio_transaction");
`endif // !`ifdef SVT_VMM_TECHNOLOGY

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_gpio_transaction)
  `svt_data_member_end(svt_gpio_transaction)

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object used for logging.
   */
  extern function string get_mcd_class_name();

  //----------------------------------------------------------------------------
  /**
   * Method to turn reasonable constraints on/off as a block.
   */
  extern virtual function int reasonable_constraint_mode(bit on_off);

`ifndef SVT_VMM_TECHNOLOGY
   // ---------------------------------------------------------------------------
   /**
   * Compares the object with rhs..
   *
   * @param rhs Object to be compared against.
   * @param comparer TBD
   */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);
  //---------------------------------------------------------------------------
  /**
   * Extend the copy method to take care of the transaction fields and cleanup the exception xact pointers.
   *
   * @param rhs Source object to be copied.
   */
  extern virtual function void do_copy(`SVT_XVM(object) rhs);

`else

  // ---------------------------------------------------------------------------
  /**
   * Compares the object with to. Differences are placed in diff. Only
   * supported kind values are -1 and `SVT_DATA_TYPE::COMPLETE. Both values result
   * in a COMPLETE compare.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in comparisons of the non-static
   * data members. All other kind values result in a return value of 1.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Extend the copy method to copy the transaction class fields.
   * 
   * @param to Destination class for the copy operation
   */
  extern virtual function `SVT_DATA_BASE_TYPE do_copy(`SVT_DATA_BASE_TYPE to = null);

  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation. Only supports
   * COMPLETE pack so kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset. Only supports COMPLETE
   * pack so kind must be `SVT_DATA_TYPE::COMPLETE.
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
   * Unpacks the object from the bytes buffer, beginning at offset. Only supports COMPLETE
   * unpack so kind must be `SVT_DATA_TYPE::COMPLETE.
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

`endif // !`ifndef SVT_VMM_TECHNOLOGY

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
   * Simple utility used to convert string property value representation into its
   * equivalent 'bit [1023:0]' property value representation. Extended to support
   * encoding of enum values.
   *
   * @param prop_name The name of the property being encoded.
   * @param prop_val_string The string describing the value to be encoded.
   * @param prop_val The bit vector encoding of prop_val_string.
   * @param typ Optional field type used to help in the encode effort. 
   *
   * @return The enum value corresponding to the desc.
   */
  extern virtual function bit encode_prop_val( string prop_name,
                                               string prop_val_string,
                                               ref bit [1023:0] prop_val,
                                               input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * Simple utility used to convert 'bit [1023:0]' property value representation
   * into its equivalent string property value representation. Extended to support
   * decoding of enum values.
   *
   * @param prop_name The name of the property being encoded.
   * @param prop_val_string The string describing the value to be encoded.
   * @param prop_val The bit vector encoding of prop_val_string.
   * @param typ Optional field type used to help in the encode effort. 
   *
   * @return The enum value corresponding to the desc.
   */
  extern virtual function bit decode_prop_val( string prop_name,
                                               bit [1023:0] prop_val,
                                               ref string prop_val_string,
                                               input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

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

endclass

//svt_vcs_lic_vip_protect
`protected
(g5UK\C,]S&M&\APUYg?D>bEZI6Ofbf,(EHgWIe():=C:AJ#:]4E,(<\:b-[f8BV
BBW#4\dV0D1)F@8U,TTIb(@Q:fI^<]S(.2LM.S/fOAZ+CBYO)W=L\X4J.c&Y3N#P
AfS-JF6T#/UD,Y[/L9b2f=-U\?TRUY/ffM^D<?K@Q;g&b4cb9ec8O?BD._YC0&E5
Ca(+KZ=^</+CG(WOUN3a6.AY,:2dX9T;L0AP[W]SG0T]T>bH/DCQWI[QV5(d(WG\
g5TWWI38_(3a^6&<1IY09]MP?g3]/ZD\_dX5+FTNWfa3BUFKQBYQSV(F:_T:ESMK
C&QX=KH1<96ZeV;3BV\,OD_4ecf,?X&MY1,IE&[cC=a7]@DBGC3e-U60[F9ZA;D(
Z:b27]B7OTS.<Qb=,/TC6-f8+2IA5[E-e3a<T&Q;:5QS3_M3<RQAB69([OU6eNM/
5(N-^,T>U<3De,,]-2MO\OBK>)dgEOPG:3<&#(5dd=0U?+RfH6[Xc1a(2^><P+1.
QC15A_?_OLK@4H&9;bF2XKZ#g_9eRWH_f,\PN>A0=ON>3QNN.C^,LW@c_g;==B^(
WAWYgIEKa;Zc2WMWTg#MO]C>eKN0TIR<7M_LELg[-\@P_Cg>HcEVcYC1Od5cRH#(
WXe,1(;X16+Uea#U+#F;T73_,)]9M\X@NSZWfIB>bP?VX&7Y]P6,9BE5Q9JOc(#2
f#2I^7bC2FZGE>eMYO8]>FS@6V+ZXJV-Rf@?W/325JdBA2gYZ=X:dSgPNH]6)/@K
5eJG2QbEE;GJ(6.eaJeV,;-MaAC>@B++=XF7,=CPRgEI_\;43;.XBHHSc<.H)NQd
7=M(Z_1AJ:JB6#F-KYfe#(FAZM2LKc4c\4?#d?7N2BfPLCKR+MD;E_PWB,Ka05AO
Ye(Q=VX3a3a<C/c3=PO/V;P2:,D.&:WY1UTRLQ7(HdM.;\Z2b7:<=11H4MZ.e,Od
YLRef8@Z(&1H^MV(+4CeL(f<ZK9ZaL6=]CUeFL5fLWNYSW1a9BWe)ZHNO5>H-8d_
fISdN7<C@@F62[^>&[??X)R#=@>O:8.F9^@JX0A)9Me@ef8A)Z]c7?d]LcN(2I5>
J)UNd+Aa<D^]N(51UW-@CfMG,+g@])6BZ8XKfJ.4BR41.(,cU61DNH:Gb.3^,<]7
fB(C,ZTb78P/M;)\JS47-dI4P:5#R0D[\>B:Ad2]C?HYd_f(3ZVS]+JR1WU9L@RN
,=O=36F45T,/?O[&(bV&;eR[I>,E3U<)<DB.\=(;cd>T);\B_OGg/XVL6T,Xg#0]
Y,^Z=e<P>CX89YA:<R/03Q3C>f+#K^e,/P9VdKFW-YCCG]1TO@H?g/\GM;7S(8D,
/d>/OUKDA/0L@_XS5@bB5f;FGMG2M39GAb?ag1-UG[e>eS+S87J^J=e_ZW>/EBMd
QC=05V^&Q<OP(:KXD.8_fb@4+Xe/b0H1d_d+CC5WA=Uf5gBf-K;,R;2M,:c[(3?/
)[&G,4TBOR.R69X319UcgQ-8,?H2?<BI7-=+T_ZGN<5WbP5AIQSP^>5+&J_Q=&E4
JBe2?:8XQ32+6Z:\6^#-Uf=@(X>a_24U;.U][KK)V@JEE(S+H-Y+\=ES//gfdDYc
EIY@_XcZKGg]SYFWOH9C\7XJS;>G-SDQd8D30&W_dVAX>.]6DGX7MFZ]LD)M2HLO
=KG5b_NL81E>dA;BWR@;b^M&=BX_Je9E(8JF4-PL1&06.FfW#dcI&R47dGM:^.dA
.2<N.-(@M3,FEF+2?IUXV#L)dK);f9I19aMQ/)WaP7gEXBbG+_g;P?aR\d^:-N=;
<H>Vg6C-/HbFDL6;^U(G6;/(?:QPC9d90)O@N]LaO-FY?(4H@/>I+X=T:cQ^fJP)
c^^[9/L8FdOS=[c)EF^SNZJ0Y88X3@/LBRVY,fgaQ<T1U,E3^<W-I5eg,aR&[OL;
-:W>.,M&@5F/IWV\Ic2^cgA(P?@QFN.K?F8F\M;R3D;0>\062,NBX:]H]J.g@PU8
W_QVPcY)QK((?8_BcGAg>)+=G&]\J,b-9_F>MA1S=;9a3J<N#0KaUYTb>?2#3V1T
4cQ[b\7MO(2SO8Ee2PReT:1e/I<85Gd9ObbW4gF#3&#,SQ6K@<QKFP@GXK;-cA&L
^2EeV8#b0__H.>_0M44(5\U=WMAGfBI?0_-F^M47^\IO0]e\>^#eP-PV&7ZE5ga0
fL\6T0=a>F>EMFK?Z7\LZM-NDf]Y+R#;Tf)?6)&7DeM@Fe[7.,?B5QSJ4d2X-&KW
F1a2Q(<AX28S?=9::Tg9NFN\[g+A(C(c[bQKKN_UA+7)2:?F4N3D[;AL?O-bRdeO
O_\7<.1VFVS4;/<9+U);#aYAO<CZQVN,SBQ6SYQS:3E&/e5H>+P7Idd:4RBZ3;Z,
5bQJ^,a_WE56VG=JBN;^528+)0_>^XFX4])Y,IC>X-Id0HM0+XRI#D6DD+MBK?Ab
cJKaUTcLYG[e7B<^<FFY46M32aBg3G2VB-1H_D\<V=XCB310NeRR/M5-/(b^>MB/
_;[P,BDE_--cH)WD:=QIAGJOF/B[U?<(D9L@bKbNRJ?MW8fK_JVdNKA.T-AR((Sc
P]1J8;ZP>#^2aN,VgAS0?5UI=#._1/gB@eN3LR;d5UZ+V>NVMe&f02X.H33d?ARb
-?.&RbW<JO?E8KTe6I/:<#^W@g<YDCG5<R1R-=Db)TEGP.)[W<92QH&9RT]7D@Cf
8bG5YBaT\4<[N)IN/&[>Y273Q]a_TcXUaI0YH7VQOc48L8R#E+<:&>BRG?G7g#Ra
/Nc+23ICJP.X_P/Qd+b#7MO=YG8Kb7<X]3S/K:faV?<=7Z2BdJ=fKUF^Tb4,@:XB
3dB#@)4>XMC>cI+W,62f@\=/5eZ87\aeA<X65;Z\6X5P0:]HdfKR:Y\Y?#,1+d2#
MNcH[K<b1+\,C9&,Q1]_PV^9C37cC+dN;<,#427)&6Hg.<(6EK4=KfIJ<cKKR_YN
T4Q8AMaKO01<[Z5a?Z=_[:5(D_W+_Z49XMH/HUTJ@aYLW]I>SLbf4&&P\VgH.[/4
?SV4<YD_eFU;.bLNL#263GbE[JF?/a/QD.)53^:>W?H4V.G3;6gQ3WH.248A>3,-
0YaOMFX_<^&Je9c4<OgC,V(4<b[7b53I@(Y[D]TI^(8?FANcGKbE.,W]/[C+NGO4
Q3OSYV4BE4?Zf5V(c2+3]gZMAM\XM<3[JZ29#^4&BbJ6;,BW<@B&3TG,0#80(fbI
U98ELP)9KBdV+T><R1/g&b5.?HU>G=D_eaOD)P_D(/B7?JUU?1P0H4#@:9c;3^:8
aK+D-:B(H<e(<BHgV>9H.//+]Zc-?a<BGg8BK[e>.QQ^[gKfJ&7=(/6TL5^N8=3+
+F2BZNY84K&E]\(X)Q_-d#JSHQ#?FI+?.dT<cP^=TO40^[L(+I(M:;\P1d3/)G\L
6FNG19<EH.(@OL_.RS7:5AJ7);4_FO5H\HT=/CA&EZ:.[;f8KHe9Jf0<(F@_FeIS
PdURScaFe=HT.]NLUb/1fT7>;]cdJ(+&KNGO-#M)AKa.4,SDSKQ4[<.CbHJ&,P(4
AKB2]_\6gAEY,P9GD<VQ5;\a@O?[SALS@0UCX2ffK(\+2G<+)\0>6@cY]/;?BW\<
cRI2cK+EYB;G+9D/,SI,f(J;7T\7-2Q8:ae)9GVaaeRBC#<=(_3b@#,4S(UXEg3C
B8KXNVTURAM#A^F98/c=-T4>;4.f1>(>ERW:?,=)gHBPJH\>.)7B,#?[?W/-:?#6
Ceg1AN8gU,gaJSF]b)b8KIFZVL2D\VK1TE@VdOGN+dK8D>gJA?92[C2\GD]<B6:A
&=UYa#/<+-8=[5BGHe^U#]+/\@NA=@.EaC^AZXSJ48(;X-SgfV=@d=X6>GV2gd:.
Kf;&.3FS/G_H=A_H8U.)U?&H01,BS+[P4g?Z7-]F>ScEAJSWJC+W)f&FL[.M\S7=
&9:NN^:TFZBU=<IK1>=IaUD.=D5#X)1P#//WV(cMXc7?1A6&2b5F@C]3,P?#d-YI
.E.,N51cg28aC[RWMeR(:#4\ZT@-@@@Ed9?dWd/:KC+G9#FK9ZB=cV_c@;>]7]D,
c:g1dR2>L(-^#KZ61F?:106cQZPRg:J,N,)DY:V#KARfV\DdUI4A@.PNSNU6.@fg
KKU[X,9bI\d9<M(N57Bd__RUFHEOMU,QJ@&>\P;G\Y1)c;M7THcJ,e[HA81<DL6N
FENF)G.dI5+\+efgC&B?)ZV/?f#^&d&6Tec6+]]=-[gb:4LN_?Z)NRO+Q8f8S/K0
=TXK)Ia7(a<XBF#F=[2\;F7YYOK;8?73FWX@c:I)S5PAFIQZ]9b:.--.S4.<@Pd/
e.Hd4JIQ&dB]LDWYaEOT0/<^V4F@K&\X?FHcMJ_0@,P=C(D&CJd@4[X^a(P)fB4C
dH?DKF\RQT6PXVU5/.Y/ENVfB9Uf\N>4#9V9.gDfA8L-:1?Ie3;.I&FVIN#EG#I:
P22WEW7C@3<P=MQ\&/HQ9fS.+UKO=;#7GBHa[XUQ<7TR^=cNe-V3LSPKO]J;Q#PP
<4.\fdIOb_LN:KX?(QF8W;=#1(Q-D#6Gd75]?07fKH-FTV+ge1E1fTH;Y7CH,;8d
H?ZX49&V2QNRbLANRgS7.15.+.7-f55^f,LV^7/b//J_]MLCA-PRf8.4<J+9+\GK
\+/.RXWR9_(bAU#_20Tfg7dUIFaNde-1I@?D568?a:gGRJ4ff[MXAWe7(>HH2db/
_f5_:/a^J@NZ0U;VBV1=IIE#(T8Y?VKT(9XUQJLN[ga416_^Wd4/R^L)1UR6bR/c
V3B7-CW+M,]:)OeEEB^gQL@a:MIK5bN@J^g5X/]7;/[\2\DaPR(PfV9&,?MVB,]Z
<b.DV[2g1M;gQ._62UB2:W@J\EeA&\U(<(\446Z,1d5-7L;)5Ma4]V9UVENFO7TI
fZ5XRJZfc4UH]R#D&O)SXGSE1L_L0SYZCH?X03c.D;:?TT0U5LW=S;Ld)QR#NTY6
E8FE[c=H7MA((4DRRd;E@ON5#eCc8aHT=9a,EX)2eb]K)RL.a\CSMRJ(>HD7K^/1
0GaOK)WSbf&+F84(aL3GT3BKLWQbRWWbfD==GJDb>DI&a&;WBW[<IJ_1-JBMADg(
8YNQc;],2?2V4Z-:7e<W<X5B/FC;=86;]4KVTKWJ0RR9IQ(.JI0,K8F9UP:VJ<=1
:H9fY)2H?2gN9Q[2MB<MXU0QE-e)]P;dW:72.Y/[6P8@S6,[7-]Zace_KQ)egZaA
BW]M??7HUH&9eD:)c)8QW.6YN[)eD<>4M.4E[d37+8[Y:A2R5gJVE.1@@-GeGf4X
eN@Y3.E\W6<b[ZRWI-VJ\Z?@.DLg=/X-)]H6Q,a:S+X1HI9G8df+WU5(A,cg(69E
<(F@LTS6KW.??;?+D:,aQ8,\@1+USW^E<:1&8^;25A+BgY_[/=)Q&0fQ.[XaVLIB
H(&bV>-,TZ6S5O1K_<ZgQ+Y]P0JPeZ\XFN6Y9N-[IcWRL2E/TPNNPS.?&Y9W/;]O
2@>1\-ReSI]@NBU>Q;I>?0PBKP<Q=cK)LFBJ;VWS;Y;HLP\+HX30d^.eA_4g#V]Z
[[:6DD:R5SK6[eO4I>5N:a=UU&CS:^]0[3(L#aaUfDCD<9)&P1#N#ZbR.e>B.Od@
QXbMT\VK=]Ne?7,C4:_cOS8(gJ8gJ@2X\C7QCEW(2?(/fI<9.B?<(==9c[4LI/@=
O6T;MeHVGc-RKc<(/O47OR9Y^Sc[<Te0/a8\-POVPV,3eWe/b2Ib@MD<,M8TDQ:a
TZB#a\=LUa/ZMN9LHU,\(G_=>IB?6eg2f()99I8eM&f2P2/;J3cHT[5<8d/.2AJ=
<;a.:dP<(6I#:M_;McRG^[.MNZ5BQ/5)=[Ze^/@>N&_5c&&gN9aID-R@+g;bUX8:
>>OTRWUaAb[aGY[.a62Ee+UZ1f.e),V8Z+GL[EX3HDXa_f=ZB^Ec^0B#C\O.C6DL
W(;cR+AbIgeIWO_/PM666Z2K)L-+##1E,6]J-JG\SJb[[JCS]5d;)F4aZg^gQ+;D
?LOe@))JV4=-/BEIgg0WZ:#2VRC3R@1\ATVF14Q+^#\KV/F<K>;g46IEK^c8SKE(
L1dN5#\6aFF&BV^bZ?.35ICN;XC^A[LYK(O.Ja75/bC;Z7;PaXa,1;fG66+^Z&MQ
:Q2B_Q5/I5EB.cP<dT71WT_b=@eF2,gZ#)+4SM#\U_f(QA)1#EFb&H4&_9P[,(OS
^Zf^+C?/AZa5EM0X#H;g\,EG/0,;;1QDae@;Z4-_V43e3GSN^B<^92IdQ/K:X&.T
b.73[A\LD4/L]+e9+/950X_CG#HB+&P/B@77bY5eA-TO)G:=;8MIML4RMQGTcUU3
bR[06KGW2K5<N0K&47:E@8DO+17X?INeH5D=gcF_?S?/U<SCQ;f[H2GTW+K4K^LJ
?d+7847gN7)28bZS-]\MXDS?\X8DBOJ?1<IJSb/e\-QC,I>R/HbTMG_6e.1&9ZYV
L)4VZ+b5E=.<@Ld3()I--D-Z)_W&cN<cXB\;T?+3]@Y.f[6IIQ6P8:[8ITb/(;&b
<,STL[EMFI(BST&0\RJ3^>GTP798JPd#a^,H:625-SEge]BEH^,ZNA[Se7]c]OP\
a26<^0IG&U(#+DE0<V;:15BF[?,]J=Q;R_\.(c8?d6Nb3NVC0B@I8:5_UN[[WH_V
g4#.A+A62Jb_=S5c#_LP9deC,.JS]>a31,A3Y=^I]URc9.VKSF-acFU/K6A\+<>D
);\21,:ScXL&^H5EB1XW?V5LX_f1>E]T@H+Z\]dHW.IN7H4WFGLDO+[R(XI>HBb[
T2_Y_QMZXa0.:W0@8eJEPI5O[c:F_8@(W3d^/S^A<FI-R<bJ<(]4KHc#71JdHQO:
6HX_,AQbHI&UZb4539BC6^PWGWB_]#H.P,91PG(_/5)F(I9HYN\KQ@,+c/Q-.L;]
-a&2cZ++dO71ZO9AXeHRTQ27FG^+F_1+[>_4=;E[M(M_/PO-CU;R91feOK5-:b(K
2&-<f^2P(J:OZ-EFTEL4#4=W).D1847:L<#\?HQK4##:9TTOeS4Z;W:UW-_2W,(C
69NAM:.N=#d+_YJV<<<=,1/EY<G&AgTf7BUc1MN)=\eN\S)CB>-FS=8O9K\He<()
F#@32FQ^?+3YaN.(>MN#^P?WK)7g@Yb8aA0.[c&S)?/PK8HDJX8e5aAe_QbI1G)3
8C1X;ZW@\FAWM.9[4;TNXbBLOX:-=),-2>IcCdVB-:)KG7F]QKI2<d#T5#4XNT:L
CN<GT@RI,6IG_926EJD=^c:0E?5Td8.SPFN-M]Q+YUHFHcM+Q]gY5<M?)YMgOg>U
Gc#g4Q]d#9RVcV#CB<C_Z_>/R+AQ(&?+(Lb7);F/O<c4La^.B6_ZBfI?\==_gT2:
BPI=1eV:a<fIH+:<)XBN)3.cW8Jf,-[g=/WV_<E<Cf/R_e/+S-;NO4W4OI)[?gdE
&\DI1C>D-ef<S,2&\?KP.43R9;6FSa#HM+\0>#\6d5+>E4_8,^D47^=6Ta8G0Cb#
LZ:-<IVHA(>CAYUNM?I&#/K9K96)G:[_c3]V6beNJ/&g;(I-RYIb;a.V]<K-3W=9
<^^5P.Z7@OO2PeDgO/<4)OW3L4)JX.@UDI(_e50gY-Nb_0GKH6CA0&e:g2AgFTON
T0&70Y1c#LMaVScXW(C?;G/2T4cfc,XWL3BLI]C4=/J?EQS.EA#/CQ6O1QO8J&NN
I+V,,]9B3=_<RFf,C7K==&F8FM3/)]?80&V4M#aT.4UTcLbIb>R]&0Ed5Z(:0:?X
K:U.R=0dA=B<BW=U?UG&)bUQL7GC:B^]S7+#N8(bgK>3V(Ta,VNSFWUJ)<=8BD/f
/@9=;8RDUC#gaf/NPRS\=>45L1Z/C#\@LHMO#?O80+3g,Q8[I&UKB@M^3&V02^E5
gH/\EU_e[FE8WAEMC-1c[NKVd:&a_fRLb2e^QY0B,Z(CVOM1J.@(;WR-4M9g^T]W
R^8YSEWDYFTMJ-\CS/FebW4NA67,^^&6JcH.Y;?3;GEEDV-DOASD0_7TJ/egJ^HS
3/=2R]+cA+]eYR_Za1@?A,Gc+5DWNJTFNF;eRLBfbOE2H&6;g;EI&F<(96\4Y2PC
GY>c(]Eg2();NGIEbLbdOKK5)abUPH-S;,_B4_c7[]Q/\A^)>FD&V/.X681VdL?b
;\UW1-5H3\35PZVJ(#0<W4cAUYAO2G&ZAg8ca)OgD?3N1Vf&TZ<aZ816C290@CX#
OW4eg42UA+8&WCZcN]0G5ZYg?QO@79>47T8<4;SQWLYeJ?QNbJNHQJ798]-a#d;R
a89N>M^cMd5b<8LBBMC5FRF]0.-;SWG-Z7TBZ(>LLY]2B;_<TJV6c7<UKN=27N_#
D/SJV(.VJKggISBO97@0@L2M5];_&H2&VS5F\b2UO?M#B_Z#0]3V,E=U62I:bJD?
_Y;5HQ\^>\,+g1a52(6^V_CNW8dQZQe&=\f#L^+T]g(f;19L[#LUbG))X(+L=AGL
]PSEg.-&0IN]d)0ZdP[Ie@8_X/_JV17]3<,f@e8NR^6@;7E+=??@)cM1e(\(\Oc0
e#=e[M0@P8^?MLce>E7GGDPef6JWXGE2FMCMVJ#AEMG^A+Y]ZP3,6:C:.6?W0342
SSKSfb@[e>O;b?(JW68(D8cKAFQEgXF52-W@:;b);XOZ,RL0N=W^S0aXKCXKKAH&
E9ab].gcN:19.\P^VZ?\?PQaFOSQ8MP?<HVHG((I>#2+g(\HTg4@(90QZV8]B-AT
HQNe)O#^5F^#a3O7_\6B6g.]8RNXIM99=5&SKPJ3X-g<>.:e3@Oc#1-Ab##=A+#R
1beUb]g7#gIEF2FMJI=3M,DT#9Bf]P(2TCH)O0@?O28NW&0&W?^,#JR,Qg<L>f25
-#W\D-V?A/=5VFD;a.LcA4M(]?]=)X8__&e8ATKBR-U.0,_CGH1T1741:B@N;>XO
GZR+WFED>X>M@6ZVaDfT2C\BT\L5S&XfH:7Y1HZ6N-Y3QL08G+Ce1F([69YeEN#-
Q=\\?TT.efD0PgND)VGJVdU<[SI(<fC1-6)XA<7/8JAZ);f9>[_6SZ#9:1\Wg1;C
Ca&\I6SaJb#)gGc,-Fa40R+82K)(DaZP>]cd72bF)M8CY[5ZE]c-4S1S,Y8<^Zd[
@T(LT=O5104L?<9ZVP#B^ASF/4eEH8JWD(-FAdZH<RG2>N8ON9J)\d5eCI<g6TY,
^,ES\Z&S^1];a7W&P:.\X)FB#9.2T;dNYW>fL/UdQ&a(WFReB/.7DPRd-B;D7BGg
L1bI0G[-(\K_WKWcc?9L&>79E.da(;7->JTa@dZ#,gbA+\KMeI>W>?G:5aD&1fZK
;)BN.K&:ebACKgU:9.&3?(e@K9@2M4f,fWA43SPBN2&(Q)a8VbG2D28[V<G4]AHD
90WHe0)PC0&F51OV,fcU\I_S+KCX[O^LDd->A599:_#Xe-E2G&V(V@OS&9U;aE16
4e8aIaa1^8DYN_O&E5MK\V^GGEUN\+YgEf2H<\^=FYbgCNE4Wd=Y#[WCTPSFG[2;
WP8X<b=PH)SUI&.(#F.XH;_KHX##F-J#OTH<ER?P=>d)UN8G=VbW4N(6e+D9RBJ+
b1ZR,c=(#WAQ,?BXd:3?HI;Ige82BDSJL8N15deOK@L,I5::17IZ87MgcALXaGFX
PVE5a;P/MF(DPf=DZ;E+aS<0LL_::&d<d9VfL7X+NKgQDcL1T)f#UY/d?XRW);QC
:KCaLf_e3f8LT_TRG+9U1]-J86-FK#6Qd1QNU;JEA)W<Q3?e2_XQNW>:Fg_KFTB;
2U(W0/b&9\ZV/50&,e<A@L+A8N)>A74Ke+7\]SV</S3bY5;TJIBQM&O:8TG)-eU3
+\FJJ-N[P)+D\NF)0R^9WcO/YFC9I[JI/RS1[(]Pb#TG1&e@M2SB-Q,5L<^,+@.G
K6JG;f4e/Q+;\fW>ga>7.,K4?1FN1GQ&(g\RLG75[UfH/cOa[Ee]1NKA79^B7>dB
0BWQ:,.C8O=:8[?W5,7C+H)fDHG/16e]5VGM&K#4^KT^F0QXKX8a97H.HSY1<6/M
&AQdK@b=d[3O2&bMc8QP/B-+M60-.<#D[c9b^+QV^Hg<[_P3X_cPXCgTL);Z/>YE
S7;2[<_1_XBN^XWVNF1;TVK>H(55[d>\7Sf:6WNJ/M64@6B9-CDRIY3T0T]53CX.
V)g(cd:O?<[XA.bABH?E@f-O59EY?@/:4]K+F&N1]a4,])V+GdcSM_DeI=YY?#/:
?4/D2cP?6YC\,NA<e6G<K/.GW8<_eD/6I_8-47A+Xd,P_d1&aLZKCW<HZC.;>++c
ULF9+)QfE,aOUS#gVc1WVE-(.LHgF7CFgSJEBL2JC_VaKFB@Pfe5P3K2-GIa^E_L
3HHf@F[d8[0=6SMUM>O)/.U:\[=a>e]I5VH5eUJ<M(M_bR/HI+04(=YL8P1&e)f6
P<-G^,RX,9[^R/TBe2H+a2Q4NY;X6CY<Z/A^;9QLTVYCE2fc+#SV?#3MUMDF<J7N
Ad09>1AELA:aCgTQ+cR4<IYLKKQ3U^,b^B#TgJ^X#94aWWHLW],]Gg7fcH_UI+8/
@PQE.+AdWZUL1WN#X8AA80DT-U?4.Hf@V+]L7+]FF_GW.)e^82.32L4I\,K+826P
=@V9(?OL5bVJGT#V2B(/Z1D4IB\L]74M9?f@[X,L:U#Y152XfBcI?\\F2TV0/Y<f
/>ACC.?1M,V8<BP97E_#9JY2RY(QJ-NEZW)e2eD5_ZWa#T6TK_-32+<,I0ccLVPg
<E\UPHH.W2H0C3.F#[VCB:2:PL<MLWJV68,&YHe>MQC)1X8[2?9K,\7/L\ZcbD6[
\b_L2KY9c^(dCWJMQJ][+W2I13R^?XPCXQHdDAKY#4Leg&2/c6Z,>:HZW]3FH+5U
eaX\Q][)LCHP#bSJ2IF_:;2IfeJVQ]G9b-eGFO1gfg_+4B\];c&3V2R9Z]Y(RFW.
QZT7?H3MV>/9<@_WH#X/@L@04WGf&Z.XC]aa#d@AK2<I)S;#B^-3+(AC/;d;X//]
357KgVdG+#bS-KD(2[E<[Q3&,OLc]4/Vg.],:-Q5VJb78ERf#Xe@dHZW3Z:@N_:b
>V,LXC_HNOMM]O_#?C^_\U?ac6TGK]b&W#1(YVJ1_.RPVQX<G-c[H7&QYf#G&B&-
_TXF&&VU:=YY3-@K^f,LY:1X.D-a)\\QFgW7,1+J4Sce0R3\7F7@]?aU<U<C5E6@
W]+gXW7R86Y7(X+H+9^#B,\9,]aIR1dL@G;XJDf(U4A3RL]#DN&RA0CV--<QQO5V
7?aBg9W7N#&5A7B,cW==J)<L>fOL\f/I1VTB:[K+D8@Z;.?9dTZHF18/3O_0)I?E
Xb)@Ve/CY=>@U<DaP/CQFOOYJTYfV3QR7eJRIEg_0I:(+O2OHC[gDWB81Sa\9L4C
BUS(@8PP^UQ4)9T)0c\\&aKQC1cVESA@WMdRc8:(@/LS^4@aM9]2Pd:.1fgVBC=6
X?A-L@+?,Pb[9<eRY8O#+(+MOeFQ(;MO^66g]H\1@AFeG@I\@-F7T7<Vc?L[#/A9
^@@UQH23=-<<-9X)?GPJ(e9ACOZ:L06:Z9S?<Fe((?M^HVS@(DV#:II+[+3Y]5+J
,9_E5IVYE6aRE7&PN6ZZJPDB^:34#O:&,64,b/YIM;1W[]-Z.f0RdA=e5[2Va].7
I^gVFP8Q+3a=2H5Fg<NQQGUL1]/82S[UAUb8d)ZdY6T(U6_1T95X3NEF<IEHBBa#
bNeC[SKg3?I-RPG:\ZLH,:3T&1Jg;C:+YND)LFZKOCZ/H>VbPNH,/I:,&1=&fE\I
\0+#_BWPQ(dBBbdM);LZ\EA:LE?NV.I8LP=^<THNNTU_3S/:/F3GAH5-_RdCD@69
8;]7BL[CP#FNR,We#&8NPNPg8cTG815J8OI#Eb+e4Cd4A7ZXb8?6J2;97K=M_J/.
5_,<++cRFB?H_:N,LC5DF6b9A6,5KMaO9-V-UJ5<0JfaORS0;3[T@.>)R>T#MXV6
5(5aEMYV6A1CcDL\6;L19gd-P5NDf;[TgUC3M25C0+N]7H^BOWJ>0I3S(WHTeVX2
K;S-BO8D+NT[f/TZW\R6GUO+e^Je-1JC>+&7LJEPdH3_D8N56+1A8X2d2D=]G\.O
3EJNH8\YZ,?(K50S(DVf?^3@/7T@HeB>\GO3/AF\A2V)b-MgIHA^KR?g<VDQ4Dc?
-N??]UJ;,7Z].g,^HeB1]+T(AL3^:L8OJfZS>5^M]=3Z=CL1]E^[e/:c;EROAWOE
MaF+_eb4;-g0?F]USSDSJOcBW^_/;[dDZW<6H6#&@4CRUTHF30T94+8FYOZY4d,a
.,O^.(S6.AeF#fc^37V5]=H?TE-(NP)TZ:8((HJJcWLR^Bcf.^Kbe/<703S(\5@b
BS0]&I5)SPdSIU3;b9IU2@NW&e9[HXf>7+=JHa&N[PaJ15T6AH3N-a&8/_4?)K/]
:@-^?<5>,O3T)V3>7f2Z1YAKdM4Q-f.OSUVYT_WL]6BIa3J-2JUSgE7(M(;GCDd9
M0FXM##7&920R_<?ELZ?=5X5(4(7^49M?G?G>4Za+(bO^UbXNPI1CNARO4U:#W+>
MA:AVKdaF<+08\E7P:cfE2?Y^/VZXTe&>IZ/=)agI4YDe&fe8DHEH//8>GE+K9;4
7;VgCPF._\8#&VV<K-g-KAcA+-NH<(W:7QBa3>UMbR#a#18cO+PJK82XA2]6LNXM
70Qa&EdU9S.-LM-D4G5OOc7L/V<UNEe@.6MLQK>bL027c^_=0C4SQ[<E<.<AH1N.
<cZ9LKCRC:]JGI=g)?ZU870G/D[KR(G5;Ye[,-.9BAI&Q3Se&>=?A.HF+S0e0gII
C9[ST#]9eD[BT\/a(fEK[2V1]S+HL(C]aOU18NfAAHMW_MGRbLNYJC+]gFEd-9D_
=\=,L?X]Lg&-fC[36Nca+C+-gPNM??W,5Bd#LCOd_/62LE;I4X)9EKeJPeKQaV4U
\JX.>A8YT.bfG(\FK^eB)2+N22Z8F7WNO^KeTM&&d=T6FI=,\P0Seg7_RVH9FV@W
+0b0FSZLL[.@Ac4>EcCcJF;;TWM3C7/D>Vf-TADVG=NNA/6OO9?L\#<IZ-\^9_N-
:A+7G;)^]]LK_=,FA=+UA/:RBEGcL<cSYP.MbF<1GI/W_eZ]:#[WR+]URXf7D,(K
4Y?GG5T)JS#NP[?8VA]T;C]G)(J&Jed?XF3?;9/(NCeT^e]RdNLeObN=459_@aGb
?CU/,?X\2]^3c]:3SI2gH95]CgCD0fG.5eg2=c_e#7@>ES<)MWM7BUOd?dDeKag[
CP8CXL\O)+F>F]\TP4RgHIc.-#^.f4CB1a\DZN,gFN=5<VEQ(d;L:^&b6bW(1XgU
7-NcU2MLa37d)ffE5274G5_>(g87GfW+fAJECf79^M-Q;DD\:;39AHYBKB?Ba@IB
LdW135cdV5[-5.D&Pb0J9RSM2D(I4IMXB,(#O1b)_4^]2e20?dSeG_.&G@C.g4YA
G;T?K?8BdS8<M9J]b4KVN4V?GD5UA8eb4(_.8de(5VcNAfC>[RfPPV3?d\Hf3S\=
L)OB_/=dg./13S#Q._dZ+NE7-<5A&(,0(Y3NO.Jb+GQgNbcBbM;]U2.f[DYW+Q:7
N(&7aHdSgeS+B(_gSKS-LE+AJQ9;Ga@C-B<TFVN3c8?Da>U(O:WS,S_-+C\OWC7H
=]We#Q6O\Wc)IPFD\+2Ge[0Y&Y1><E/8]Z+06/RM+YLd4cM\AIA@?[_6Y0(IW21+
DN\J0<0\_.:SJ)_IDFVZaK;ZOCCaK2b#XAPcU[)Z:XTHXf7LHXMHV1^^FH^RGT0F
e[bd=I@W2fYbE(7CU)^N3f2<-CAK/JA)D&Q:86Kcg6Xe56/#^#)?Ve/LQ?Rf#eL0
]8-JD24?#8(9b\\?A0.ZH2-OJGK<3DZ8M=&gOId[8AE@.E;D+2:&.e-L:9d:.=B0
@JbfRZJ)FSe=\Y9]F1@5,VFY@1VIQ]<E.IFMI)(#?^/W?:d[b9:4K4/-_=UdbP(N
[\A9-X\7]6Y#(e9^F2[2]JXV^Z()@<>K:2[J(R3@-78N(0EGB,dTBXXQ?4:UJgg>
.SA>JUZRPe-;.M9+c?(BL#PJd@72==YI0=VE+OKT6,;DS3>__5FT2[af)B0H.&]T
-PT:[&bJ7a_gTA-g\J.L=])ZK)aC.^OBO0R5E94__P<A(DFdL]I/g/;(,ZW[gCeS
,HS6=I1cKF6U=:OS=DU#V^D?cD(WZ1>M80RI1[&N@VPJOJ1;;A7I7J,O<ERF)?^]
XR#18Vg>(K3,=@&.cXf_1TcOG^_Fc]R134HPL?Og^(W^c6R(LM104CO@\F4Cf3)J
G]IX&1<B7J>67CYdQc-.F[7\6;E;.15KdG?EY]NcdbNLbMf(MXd.[,a\]OUD_:dF
CBIL>?ELI,;;Qa]/D/B8d.2d,(R=9JAK?eSEKf?(g9B]3;<^FYU,]C8GGA=#b)O-
f8888g4A5E1GeJ,XH;+/CUeBVKZ6\-1d.0#95P&HO=#?506B89_^:].UGcJ:W\Q3
0S8HJA1=S_S&YN>8>#cC7FWG)7+^=>N#W.-0T&BA?BW7KL\S@OT=dPHfZZ<M6(WP
gWUDCN/^=ZXEOc\0c,OO:e+\d-JZ\M_;OgGW>;[JA&?KPe,?GX).08O5+>cLS=SP
e&WcK>FO#ZY[@WgcQS1>G390@Wg,4Hd@@DLKAdS_PFVUP.,,UK6Q/cJgP7]ILf08
5HQcT#>?XM[)\^FfB37-;0JDLIF0e&Z)_:1cE8O79K>;NQTN)ACWgg/BRe56D^;V
SgW#)E/fJ>[7K_9F)1NH4C)[Z4+T2dY/ZdHcU6BA5e2;^:)+X+D^Z189T,;]3CYQ
Y-2S^]>NLMZ<)@-755b[#.<M7\)SRRZD<14\1d8ZN8?WHM:e7C78UH/HO6J.1SM4
C@@JS;;V@ZA.9/^V.5?7RTFT;MYEP.N465JDO&7HN-H>PFd>eS\(7(3C[gL94KbC
]2JHB^&()D[1<.eAMV(MW85NGfFCd1Yb,P>,;>a/F@#H(.X25QWNFW.A_.6X\g,S
;)ZP\cWgZF+[979-d8]XP=<ZT]BWK+ee6>DcP(42L;EE<2V2bQ9>b65WgB/CRF/[
HPA+A,OWE1VcdE3A3^AOTRQIH+),\-Z]\\?_.61RD<ae2HYXT4aBV/.+\c9S6IG5
2T<Y(g[^<Y\[4^K;a0JTc>3RgUO<SH:#GXWYL,PaRc_M^QR4\CE/MMO?6-WOVY5C
Z:72D@+fE]bU?>^8F:;V<3ebWJHe61H,gB)Q<(F4D>K5#R=a8@/TY(MF]1-IFcdD
O-92C7a<]c,KaMRTWOGWXaWeCELddg9>Zcb,8acMdL<?V>LC4\RCJ?]^WX8?UZMK
9dNT9(+0-_cE?;Q[Q+DCV?2?:LMTLH&>WG+-C(E65X8,1C<E6Q]b9=F3R1&Z72Ma
AaS>R#2DYbZ7G;fMH/Y29eBHR[FL\L>CE?X7>74S#6C;<B5?JM?XE?L32c+5)01d
[6;5J2cSLELR(6:[^97:X]/<A;b-.E0<bWXB6g,_&f0JK\&H2T098H(_,E<Z7XB:
QA@Y/ea&F/M7?W=cVHH-F-fFJ])OQ&O9537:JX9@2U>bZ<_(<_-Q<)]>I)Bd<T;G
.I81MT=?1K2>d2>b3.>T^d[:&<G8UR:LH32fT:5-SXPYQ73D5N8EXE]::QA,.&Z5
:Y=\K:YHgPX&ZE&Y<RDTN_)e6fDWaSQPYQZPJe9GR>(<K0gf3BEN2MN)WHfTEb.S
^V.S3Z@3#0L?g,U=;aTM.,;Q5JB@?De[Ce^,5c6TS?GeaVA+e@T<;e;78-.E7RYC
R<b[=V-:QC,W1Yf7H]2JV/V@P\X,4B;6QY;ZN(&T?Z7>:cW^4J0PXCT.eMP0;YD3
Zc:Z+=N(+2KESF\,BB:BCc)g9V8(f474\@4SEV/db@Qf[Ff01\19cOS_AfO6;c;U
?K6.;FaQQ8\@fL7&9Z.+JN2IB0^A4A:YIOR]ad8(Pg&H3e#X@FH:eN4S^Ef<Y(]b
S\HRK(eD\Xb)4cFgG-dg08,+V/R>1R72GCF0CE272[(&=ESVIV^XV[_Q#E:8D2DO
B/:gGRB+AcRYSO4#4D]I;EcH[^5GeNTB.4>,=FcaF3-@>9^[7=8;G5LaZ[?5C<7/
NNN7Z@ED<4Z\dSZF?#bTd\/7:7;FHA&(@Qd@,X4EA.HUQHLUfeP.(9O[U\X<>[4/
9bJ34,21eBXU^^9V,.4.D@<98E&Pa.9b^bK9BVKP@8HfQ=J?T=J;:PZLD(-O4He2
X&X19A9T,VNIKA7\K5_OW2\+/8&4UB9\<=>TRU87<7CfV@&_NeNE52:>5b[_MH..
:L+S(DQ0?b5K76CS.=X:gIa:>8b8G8e_9<:9Oa=(@QLY+#f0gF9@4ISMS?\Nb<d3
V@GP;fZ&<W0)5#5Ib9Jag.HT8&IOZKBH:$
`endprotected


`endif // GUARD_SVT_GPIO_TRANSACTION_SV
