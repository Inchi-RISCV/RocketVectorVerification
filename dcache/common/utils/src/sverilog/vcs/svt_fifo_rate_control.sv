//=======================================================================
// COPYRIGHT (C) 2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_FIFO_RATE_CONTROL
`define GUARD_SVT_FIFO_RATE_CONTROL
/**
  * Utility class which may be used by agents to model a FIFO based
  * resource class to control the rate at which transactions are sent
  * from a component
  */
class svt_fifo_rate_control extends `SVT_DATA_TYPE;
  
   // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************
  typedef enum bit {
    FIFO_ADD_TO_ACTIVE = `SVT_FIFO_ADD_TO_ACTIVE,
    FIFO_REMOVE_FROM_ACTIVE = `SVT_FIFO_REMOVE_FROM_ACTIVE
  } fifo_mode_enum;


  // ****************************************************************************
  // Local Data
  // ****************************************************************************
   /** Semaphore used to access the FIFO */
   protected semaphore fifo_sema;

`ifdef SVT_VMM_TECHNOLOGY
  /** Shared log object if user does not pass log object -- only used in the call to the super constructor. */
  local static vmm_log shared_log = new ( "svt_fifo_rate_control", "class" );
`else
  /**
   * SVT message macros route messages through this reference. This overrides the shared
   * svt_sequence_item_base reporter.
   */
  protected `SVT_XVM(report_object) reporter;
`endif


  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /** FIFO rate control configuration corresponding to this class */
  svt_fifo_rate_control_configuration fifo_cfg;

  /** The current fill level of the FIFO */
  int fifo_curr_fill_level = 0;

  /** The total expected fill level */
  int total_expected_fill_level = 0;


  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_fifo_rate_control)
`endif
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate argument
   * values to the <b>vmm_data</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   *
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(vmm_log log = null, string suite_name="");
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name of the configuration
   *
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(string name = "svt_fifo_rate_control", string suite_name="");
`endif // !`ifdef SVT_VMM_TECHNOLOGY
   

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
`ifndef __SVDOC__
  `svt_data_member_begin(svt_fifo_rate_control)
  `svt_field_object(fifo_cfg, `SVT_ALL_ON|`SVT_REFERENCE|`SVT_UVM_NOPACK|`SVT_NOCOMPARE, `SVT_HOW_REFCOPY) 
  `svt_data_member_end(svt_fifo_rate_control)
`endif

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
   * Extend the copy method to copy the transaction class fields.
   * 
   * @param to Destination class for the copy operation
   */
  extern virtual function `SVT_DATA_BASE_TYPE do_copy(`SVT_DATA_BASE_TYPE to = null);

 `else
  //---------------------------------------------------------------------------
  /**
   * Extend the copy method to take care of the transaction fields and cleanup the exception xact pointers.
   *
   * @param rhs Source object to be copied.
   */
  extern virtual function void do_copy(`SVT_XVM(object) rhs);
`endif
 //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
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
   * Decrements FIFO levels by num_bytes
   * @param xact Handle to the transaction based on which the update is made.
   * @param num_bytes Number of bytes to be decremented from the current FIFO level.
   */
  extern virtual task update_fifo_levels_on_data_xmit(`SVT_TRANSACTION_TYPE xact, int num_bytes);

  // ---------------------------------------------------------------------------
  /**
   * Updates FIFO levels every clock. Must be implemented in an extended class
   */
  extern function void update_fifo_levels_every_clock();

  // ---------------------------------------------------------------------------
  /**
   * Updates #total_expected_fill_level based on num_bytes
   * @param xact Handle to the transaction based on which the update is made.
   * @param mode Indicates the mode in which this task is called. If the value passed
   *             is 'add_to_active', num_bytes are added to the #total_expected_fill_level.
   *             If the value passed is 'remove_from_active', num_bytes are decremented from
   *             #total_expected_fill_level.
   * @param num_bytes Number of bytes to be incremented or decremented from the #total_expected_fill_level. 
   */
  extern virtual task update_total_expected_fill_levels(`SVT_TRANSACTION_TYPE xact, fifo_mode_enum mode = svt_fifo_rate_control::FIFO_ADD_TO_ACTIVE, int num_bytes);

  // ---------------------------------------------------------------------------
  extern virtual function bit check_fifo_fill_level(`SVT_TRANSACTION_TYPE xact, 
                                                    int num_bytes
                                                    );

  // ---------------------------------------------------------------------------
  /**
   * Waits for the FIFO to be full after taking num_bytes into account
   * @param num_bytes The number of bytes to be added to the current fifo level 
            before checking whether FIFO is full or not.
   */
  extern virtual task wait_for_fifo_full(int num_bytes);

  // ---------------------------------------------------------------------------
  /** Resets the current fill level */
  extern function void reset_curr_fill_level();

  // ---------------------------------------------------------------------------
  /** Resets the semaphore */
  extern function void reset_sema();

  // ---------------------------------------------------------------------------
  /** Resets current and expected fill level and semaphore*/
  extern function void reset_all();

  // ---------------------------------------------------------------------------
endclass
// =============================================================================

`protected
c>J):/Fg;LOcQT+:gWGEQ(P9BY]g.COS/]f,.;9=ePGTfW0gPQ:e1)eF#IUf1fUM
fCFIg7T@>>6\OV<D:TY0U8BJET,@8L;Ff6);.e\DHP1W3G?W1[K.Cc3XCRa,[)2:
d?(6fL_OB<>>?g+1eM4e4;GMgS621VQXcH\9VRgOc&ge@)_S[&O^^f;HZNC^G6PF
_VH(O^4_PV00D_Eb=RYU\(RFMfPBYFGK7)8X7:-UTT0(1Y6RJ,B)U/e\^96/=T:4
B;08M)cJFCXC0C-BP?K2>A[;LQ_Ka7]K4IC.PA\X>J]E#D/E\+WHZ8?2XBgU9L:_
E[A_OIG:Y0P_OI^<JHfN?^OJg)SS1[gV?()GLg(F3SU#G?S,;DNO.F./aEUOd3Wd
>bdHPIN<Mg=Mb52JE>J(6#L\I@J27(WO9=]2V/#74N^T12_8bc7BNFdBf>cT+&AJ
bI(U#CfB:\.\b5f-CMOH?\(;VJJJ2/O4JK^R=?](:^PY/-H6J6#^..-Sb]K:3U=_
087OKHg3;=_b\a>I;#Zb(GJR.baR^dTJ\>I1;fFHe#@<L6YML]IXTAVR#\W3^Z]K
G:).E0W-K11@1e:D[HO6MBX,8\X+\(AV+HE#cbF#XO3IX5d[bXMG0LPH,A[8ce9\
($
`endprotected


 //svt_vcs_lic_vip_protect
`protected
S]1<LE));#>f/ff6\:Nf)XBWI?Vg#Yfe98GQ,6E>8[<=-6[FO8Mc/(X=dA)d-@Y>
R0OaBVPdC&[MT&(G;@B.T4bHX8Jag\]#1QS9e.f,9eU)@&DFMMQO:Y6H6Jg7A7_/
;<ZF,dM_^;5:Od22A3&NYCP;g9aI<Z_RHbQ\JQ=;WPSR-D-D58].9_7MR-_#;#X0
S=G5\(6CKJf\91+<)W.]e=19^<J\I+MTN6Y1:WA9]8gCYO4c@3;WN>##eWK1L(]f
#3G@^AGe&,-LaG4eRK(cB=6CA-GP9=UScPPe)-A+6,N^(##g)69c?LJAa_-_?H.S
OAI(&)0YBS=21O;f75Vg]/5Vb5^<HIU1CV.YS[\M#DPM35VA;-253@M^&SQTbTW[
WHeW_)=TC=S].0Y-K6dUAP-86#SU6Y?A-4BTH95=T(,(,3fW+DN)KENRX7)QHIDL
.e&;/7]4B2632H.>.&K8&gR4g:8cQ1F>Zg5L;eF<Z0XGb]4a[#I_JGVNIbfDb4#B
VgA^N9gD:a()9;_:EX&F37OO8a_8PQS+00F8>bgeBfd>;c&cdGGJZO6K.GA#OAK?
)3J\d<GQ/6?X3=g;RUcf=AJ]KW,.BBf7bgWVPLS0Vc7#D(5^1<>O6.gWQgb5ff6e
M6U5DFWI,@&4JIc[bN)EEbU7:/BFBJSR;/K=:g@eYdB-:N4L6RfS/^XBY>2-8\NS
&fd(]@<T9<6[3\O6RK-:5X[B;-=GF_8_K+47c,Uf@7,UKJc;18[?B9E@K8BaE&SG
5B1Cd_4O:V;:/@HV<\(MXfP&3eTG&[\4276+5&1FD_T##\P1^WS5BB0E5U]NI..X
0g2/W>Q/9e.N>662^E9LET&g+7,:QNFdP4J>Y0^:/I^CUe)HXZS2JL.c1\;_5P^&
[fa2)JE.BMEJ?&),_UP.1_]PMWHQQYPDD#HD+0&Q>CC5^\Q0,0e.9dC6E)8\2Q=3
bGBbge6=DgWf3);-G&=2a\2I.WeRZF#O-U_\_G+JQ[;DgPW5]<:0T)6?RQVbHFGW
2K2TFe&XS8GURH=+;4Nc/<SNH8.;FCBM;Z51]<,OMg#6gM>H>^2>.I-)@7FSd958
,bU5E810;.\2]d:3e30X40c541VQa7ZHEMEE)15KXSc;&bWVT7aQ7PCAA>:,)66)
fb)<@cUXB2X=Q]EX3Y\a4g20E3D<EWJ]/V[&;.GDA[U#)17#0L4gKGYUAY\GI?Ac
)=E(_63<Y=MLV)R/:(e9RBJ;R>(68bN\R8^2c>-H1F_0AU45TVE6;SF\A8<(OH26
TZ6>a0g1,X/>,2d38HP\GRb.K&Ye(>B2<_TdQTCP4W5U02K#L>;1)?e_LR-@L@0F
W31KSWVJ6/,BZcIKBH6W0X4;_/0_bY<;8-]SP@QC6X93M<ae(.Te.V7DW,+I3ON5
(cXY,#[,.[19E;2U@<.(?)7XJ7Y(L4>T\L9+NN](HLNGWc4cDGOBW<#,D-[QGTX1
8ADTTQF>>WT&UT?&:CBC&6I+3F6/G;/G.;P?W<+L-CbH(4.ZCHKT=42WXW9H?JAb
US-Q]1Y4&J;^C-[O[?-)-IS@0U]NCB+_JUXXM6AG?(;6<@>.96MBGW0UG<=\Y?F/
HZ@LG#L7_?F?gWOaFPfTVC]L\@OC#<EKc4F/2L/-1+\A.WNF3E##Ab02gRR&@+#4
533F(W/Y9;LSg\B7\++D5,)^RNfb,O[a;:VU\ZXaGT7#4I^0#\KH/(<5[TV4L[6f
O4KENS(@E+IR+SL=(;2X:ZXg_[4>\9JFWY+[Q?@#NSU>\IAJEF14#DfEM+X^41R3
KBZ;[T(1IQ)YSdL6We:O@&?5DAQM??e(H^RZU0FA+0E[<ZCeYOe#D6Z-C]O)Q=/Y
OTa(be65>;HEMCT1IYDWVQ>f\&<2X_PF@fP]D>EaJg9,(KA4<+Dc<Gd8)DM8(2\7
,J[/P<&70VBAJdHE9@&Y4W.e/_CD>=>PeF6Hb-fKZ@^#^0MXEF@G,X;f\)Z0#Ic?
b/Ia;I.CdZeD/BE(d?\:GDN??0H+Tc,66\H[T;4?A@]L]Y^WgJIg=9@C0D?+b1.5
UKGWN4Zb.cO;[]D(9@/>JdPIUC>/..cOXO>Ca_P;FNdD)KO_P08<4-NU;?-=(=Le
:a/XBf2QH-1bK.V1<YDMLQTL6AE0]&J/2_57D++^&Z,<DdI.[D6LgcD)S357J4AZ
7U>6S[Z4)C>?#T,8=.H^63E/?fH/E/]c8D3)dSc=<+64_g[7,_(N60eD0^83Je#8
bM2_2K6HELYL_+7<b<2AFNT,eP[4SZPH+I[I@aCSB-B:,4QGe?8[/&=3f>]SW&GC
EO[5C76BN&@]bJa<gC-24:Y1A/[J)<\OAf-[2)@HEc(^EdT\=?)bE6XDE5PEUUUB
N-a3]Kdd1<,0@YLg0SK0X#>;Z@VeW>gX^;I-BYW9<AQ5&5OCc]dPD2ICbe>HIEIC
95#.=#:1MQ.B/QU6&1,f_,ISOW(&_1[T[K;R/<CES,)[PI=B4FH2?_X_O<^S0>A6
6>?VcP/ANZHUcB2V6e^CX28=0Z)+.MdPZQ?3\,bY<0OF(VM&,dE08J(SBB0=XOYF
&fYWFR67@>IaD>?5YZ4Pe/D?J#=#3V5&a9cb+/\L-9Ga;C=f826OH;DXaVHK@CZW
GF_=6@QJOKAZ:TC_3:IWf>@X33B_;c9<P6=.8+&)M9ESDGIGMN=?0^4dZ+EDff9^
Y8O:15E-;eY:/ND?^G>V<,ObN-;:BLR26P,C:3[OU0,2g]=a0]6=0Q&A;PeY.g.Y
Qf8UM>V382++NcXKR]DGFR^+3T\1\\]^HFZEI3]H?=cA(K;[2dW.>Q3E\X7?^UNa
1_E#WKgf_;ZCS;5Q9\FP,5:ZgW>ce4]b#3D?@ERU1CDMVHc;b<J+T/2(a^SgNePB
U>(;,O1NOTYc>F?g9f+\&R/Da>26/c&cBHL\O:7F/>^7ZfA,TH5IbGXKE]C:0:MW
QRJ?V22J5_J89T:?.-adf&1A-Pg1PPQ\We@BP@\)[ZSC==O<PJ,_XMO76KTbC.0D
2BcTL-bVOO&5ZA5O6+\6GQJH,eV7b)X6?VX+3L=TQ7&c,JNYHZ5-.5O#7/a#9JGO
1ePM2>LTSZ&O-&<[A8Y^/O:GF4gZ@e#-WFS_0L,IcF?8d5Y,O=SL289:BXQKa^??
0=&LP?N0V[^=DU[2DNJ<VKLa:,9(-?/=S&FfM^>9gEaf2KaeSD>VQ+C3L&#T#5g&
a=d2(SHNdCee-T&)8B>QBJQJIXZPVZe4cT:18Z&&E4@T6\OH^+#NK?=J0FHS]&C-
:b9UUKZGZBJYD_aCH+b>?>:2G>F49>]HYD@+g0^c2&Z4VFS38PO+)-N-1gfQXVeb
4R?N6NC&I0NR+,PU/R&FgBMeIQ\TMP4/(H#5D73Mb@e)L/<E)bLQ:Ea:>JL/X_g;
=?D@]YaH>]:b3e1E\1]2QgT\KQ;-:G+K8Q#,5aCXR^g\LEL][LUA_FK3T?2X?\T1
ZPX.N&g+AC&^QZ^e0=(/9AaaTQ09N,XNgBd9:;a)7FKRUYS@V\BBd<\&cDM30Y@1
D[P@49A^.b,I-AFLO0SK?S@A5?1;UFGA-97[C9Fa7TT4TQEg@Y#BB-5E\_;&?ARb
05./83&>WOdfLV?^(dIgBgMJ/V&=W\2<<M78+746K^0Y>1M=U]>C\e-b[PR58P\c
D)A4A2671G\.eBF[G3TYARU/6Q=FDT#a:#;acQ#dC,f4)fdf-5bc/EI3g5(KLKF)
W0ReX^B=;WC;f_)\CObFHVYBb8fKY=@>@S71I25U;+#A-]AfKcFK4-J(2b.[;>Y(
cA9,L)::X,MX4[7#RE0]bT.:eJBZ,&WG8#Z\O84+M<>],6#2;9F=[gdf3a]+B2-J
,8PMW6S,Xb)8H]4Q\IGE<OS^WR:)92VV55#g#>D@_b:fME\<W7GX;c7Cd_#-^MZ<
-Sa2Db1O&]:(=Xg8F36dI(3d=GMQG3fY3d:?KLN1S_]B1<cIX5&4R(2B:I,]EP,A
TPH9X8MH&QQ/U9-598Ge;Xa5<EeEcMZ6E[+K?WIL@9V(@&BP<d7UGb<#3NeQ0cH2
a9FN=W/aXU?59;#dAU\WEP#SK^5Jde:;C7);0-4@c+eN67R.E[56O3c,dC6e#.RC
>/&XZ[dFV3:E]eEeW\bD##]YGP&CMB_E8CT9_D>SZ2g6E,I&dAM<&3A&W/3>1L,2
+LB8)fgF02dIeXYZ?+gfY?;IeNH)YV,)-L,^1LY].>5#\ZRVb^f&4_ZR?58JRFYf
>^a?8CQ);,TRYDTJ]RWfC:>JIHLN(#cJHgcS+@A@;:gBEBN]^a<Q-_\Xb45\ebIL
BQY.FePI,,/UI0KWQgNT-@1[e9FD?5)6Fc9Jd#4MC.ZP&X\KQQ.Na;XG5=H8+)P_
=NZO/:=H5PdFd4IgW4G-U0[@cRKXgJX7)Vb84W?ZQ;X+^VJ?I59:D<&)T(P,3aKf
GD=4R<H]BbMcBP<f]K9.AbMT^U<0TRb5/]XcV-U=&&9@T0L/CLfO:A]<3^WY4XHE
L#FQWI1IfL2(E8D3EAEC[(c5.W\aTZ&>F5a9/;A[\;_8fA]#NcaQX\9URE>=W6.4
NQ@C:S<.2I/+5G0,J9e7&[;e(1BDLZ#,c8PC7E3]1RH#E5&R7<&b&e><IXG8J6#_
78.58:aQWf9328LISQS28\)JVG<8R:Z2:WF&;T22)]:=]D9E0/gbX;I<27.b5EM=
gF?Y3X1AY7ON<(EJOI^6e21e4V]S6>Qd3<OGG>BM?1CR04#a;ePb-MGD-7@SVCH3
O-&.e##I=2RZIfNN&>-3fDX7\^U9&3>LKZA+R,JgK#K6L\BT?>M+[<O&4YV&d;CX
GFB<]\EgNc^gaRIX3Vf^LVa]0K8>UWB+aM.+OT-;76V8HK2YUSA[b/CEdK]S_,8R
?]dF&#23L#K-LB,2#Dbb4ID6(QJ^FLeZP\Kc#PP.8Sg9P#_4V7)\cO))F[f)g>2,
,X@Mc8XMCcM\;/1]#-8(<c:PN::+aL3.EF//cMba4O13H+cG.:>fc-Jf5FMJ)\CA
>cYNaYW>,GX/D?FOUXc2c3PZLS00/XL)KaV[gB&6F);g?d2#(51cB[e#_PU.>80@
(/KJIA&31,8b1F&K:T4TaFTHJ?VeIf[)J?=UFCGIDL9(JX1M0+T,#dT_ZS,?_26/
=3):6Pg;(XCgTd(X#.01^CW@VTd/GI\GE=EZ?=1=_FZ]d33O9;UQ>]0;?K.GBS.a
;Z>b^58=^TN&SUAe<[/#UN1WbCAe548L=G8f/62bGG=GS(=88M-9Fe(NZ5G&/ZCf
PQdI8;WC:dZJ>U037W7)23bUC71N_;d-MW(QT-0UafYP7JJA^<,0-YS2BW7WI2f)
5]JXI=,Lc&4g,>3KK?Ye8=Y(G.C\gTVLYW@EA4E6e5LDfS&)69L690[_Z((LNfH,
0&?5E.GP._RGYT(/Z/J2eR2VM5DLFH=MI8DA\gXV<Hc\JfW>-IAPYKg:Z=S/9E8Q
K6>3d6&T,X(O+)YP=UWP#I)4>EYRV/LJ?_+GJ-UbZCASP7DM2+W7)>(>/J32>-PX
DVY>E;W7K?^4YD7M\KX1Z#60#V0e<0f\@\5HR_^N7>I>2-LF^:Gc)_;8f\.dUf?A
(7F&M?Q.G0,_R>.^fgW.)UHR?#RP7/]AZ--S</Z=F+]5TP\AU;c5gR,9W\:d4eQX
[KCb8E&C_4C)9Z\=X#a1HECBS]MfGH>2^F+YBW;JUFO\6)@O-0DU5;>\_#dF7G=a
X>?\69HJ=P6MCQVgB.<M-V(T?/XX=AVBYQ3Me^dVRbe>?c;R>Ae81TT35eaC[(8B
bf7cRN:.N\3U@:K5X#EK5HcSJBPf/)50gdfc[((CV0(66H6^-HLWOVY0X#TMO6_N
ZE1LTGUT>IUgH&C5&A=:7>3Rf\)(V1-0D7V/J#1R,ZOO.2)C3g.3],PcMH]594\[
G:ea+]V]S:<F2\W?a.?F5]<g5d=3d]GId4MK<A0W/:9efb,W2Z:9&eYE7/)3E/1_
X&eC/F/1IFTZ]92ebe2DF(P,8E2fa@77LX:V5]Q>F:aH:8c]KA2\-&g/JDfdgG7>
f(>UD2\Xbc1f0]C>=).NgebQ;S3dGg)c+C;-KQ#S^L-B5\d>NH[C)2J-cC/aNfa7
-_;#3<3O1Bd1YX6)-:6CU28H^g^4PR9H80L:2-JM4G2<bI\@#87PA6Y:V\dc?G;a
FZ7.URIPCG4H3GD7I43e4=QQ2>0a?I;FKXa)L8bb>TZK1a0(\;R_fXFP>&OK>B5I
Y]@I3Z]C1DeA_FKDKYIAW(D)6eYbS^9.V@Y;II&Jbf^GEcK])(W+OWd6O_V]4>P]
F5B#V>2V45SB)dH1#;TPF&(RX.LM:]FGg4AfeEf.J^Q,_)Rb&&8Z3g81A-MH&9VH
@7gc99=H>PC0FPIL8G>1,>5T.Y&aU]M;B?S/:7<]I3,0fVOYDW7&IOFY=N]G]Df7
LEA?QZVGX,-5QFMgF:QcdWY-EB>/I(DE8XPI2EGgFA0UK\f(+4bCK1fQ#f;R?NY\
6D#=c/8bM(9bE0UccRRUU?cV,#OP\:&3QDHA7UCSHgAXe--,dg5?[V\/7J3/2/Y=
7g9-]Aa]@EV@gOX;X=/QV)=OH;7dZRJ5&7I4?;((&-@UXD)?Q.7gT.+DO(;H2SZ;
c605<61KF)@K\\,]TfH);_>;-LTdX-bY+>9G-8TQ9U4F\[EV+&2APbMESPfd8=83
)>IS/]F3^BW4S#.KedBH5<KMBS<3egCU5:T6Q=YG6W0+G]/4(]+\bFBbQN]1+T]+
#S4RGN&DB(:;.?(]>MX8_JP\<<XH8>][Y&FF0RVc3GT-VddR@).d?VHdX43H^_)Y
e@\^:G]G_Sac6V[F5_2<YIB=XI:Y\H99Ig)1+:9<8&+5\T.ZD=#09PDK.M#JB3b7
5#QI96]e0/G5_;:,0SH3-Z9VBb\=WE62AM63=fCHa+CX9DID(19@)2Mfb]))F/-f
a+[96JZBPfU;XA^ZfG&3.P^OR;GOJI;LN.b[;8]F@:OL>FLGSJ9862?NO5c[YYHg
@]R.^8CIBU#RVb^\e6.#CVgKX5_M<5gYUdI6&OD/]]LDeO5f#YN(>0[1eE4[QH<c
SF5@:PY6VGD.Dd/VP3c\MQXRPbb?>Q\CZ6+MgPM8LELRIS\c][@7G#E^WZ8&09Z/
@NW^:>8=_e<ZD(SCP4Ya.<9b9[<,QOYGLWG>3K7_JNb00VDMPPg@5>F\>@fL(X,H
\aY6aVfI\H(8.cKQ?0aQ/6=UYHX?;S.KUP0=/D0_:=+[W5NSK4A+gb(J+g?XYZCT
[+2&]1>-g,KZTHSg61b_W&&=cA++_G)X.Va;L<CX#K9?L)J_\8ZAGN97.0]6#_#S
/7-YDF;9TaH4Ta-SRDe..O)]GFFdWe&>P5Z(JP2g,bJ;[@G0B?87G^(DO^E)CMXH
)bSHCeXP(1cd&=\<[T/a(I,UQe_1;-^EN<FJJ>W3(P_Ef9\C6_;L8/<(?/J[A\S]
@</8C5-T._GEYf)fEQ7;H1-L.@,F[IT-7-51>CI8C4;4R:<VF>3M),=.PRO1VeZ>
d>&XKI,E]gKJW.9C[/+3<4+@I:V>INX8/<aFJ\G_V8YVbY+XHJP&6fafXV_RgL/0
[N=H^4b=.C3>W9(2OGN9SUO<CIDE=>U80VdQ=33>=57&-2AK>GP<0TLG>.T&,-C3
WND_A2P6+c5EV-[;96MWE./\G;;bH,KKdV8<f,4)WHO?<562XLg:)0V-e52]F_Zg
^^KQJ:bXRG>P?I(./Ef7^JGZ5D-(7>.?&1+(3c;1O@:NB(eQ4Z\Y^3-(>TeA>b>P
G.;&/QbK6aEdT3.ZMM=47_@@,&LGCK)IF614b@?2LL(/2KR2gO;NSMAG]HT1RSZ.
/?F\:C\fNC&\T0H;CG+6AaUQe[[L2=fND/f,.C6>e+CM-0Y99,#)1RXX61?299M>
I6T1VMA.348g?QCd4dTHHa8/+H5cK.&0:L)OTQ-V)IdB#4_3<)BP\YOe28gS19e]
Fc2?=XcGEEKdFec0GZ]-<JH,.bLM;DEG):+B=X1(4S7MafQCU.1:\&<#AB3DI4\-
DTD1<;@g7JcYMK(g3?^/>-?R;1@4/fMfJH7ZR?PBT]:J8]+Z,DBQ(24NC5>6Rf#^
8_1?;G5_P193:3#6/AMX&7\.:TP9L&Vc6ePPC5f]?]A?U[g,V-HQ/-6[U4AEXNMJ
C:#56<QcQG80EW4:&@,2Y=K\>\:=_g3e)23F9a#Ybf(/6=g><^3OTBQ&MT+I8R3D
)?c-U.9M@dG@3Q1,2K_)8(7)S+ZH?_X1.B?V8@E\HZR5aK,S;EY>D=D6#GG#)NW&
FO04^8Y0^dXa]FWaTK;/_#1)&g7L\b5W:M\HZ6e#eUY[<dR#Hb)^M^Z1<F9WIUDO
]8Z)CACSST_e>)T:OUb(S2MU#^6K3ecOI6gC0_:7G7@X,6HN,-QW-,O&XKb=CK#V
,L+Q3.0)8dAW8,f72UU?+?(^PNIPUCMUgC&551ffTZXa[2\<6:DRa90Fd1@4WXe8
1\IHI4b^]b</d?C1b@c#1,GWKA[[6&:0e7GOAFVV(K(c1<MP8gc9Cac?TIa9Hf_^
abQeE&-.YPaUV7UR(0+MbcW#17S[(XETFU78A6YZFNSUS]I3S=@TYf:PH@7C._0g
KES[]G?RUQ-2fAK(JBPRJWbfX.:D&0D37_CeS//gLaU.X#c:4>L:TKZSd]5D9;;-
L\Z^^);;9WDZCe6>f&B7J)f(S_GRRF-TW#/O.G4Vg]\.DD0;&1b>NLP#.S;E,AbH
[C,fN,SfP#DYI&O3K#M1:5g,Me<PD(8YYT:8HYb29&)a3@&fDUOH_:ILN9JE9e.P
D[&I:NJ(#E[fX246,@J+Q-e):]ge>bUKeS9W@]Q04CZ7S83J[GDPNPVd3/9]RQW4
J&24W])H?T,9YR>_(J6?aWeASMBP-S/gfN+;0.?4/[Je-8>QTTW+<+\O@<_[@PCJ
],4OBXN3b(N#[6U/dC+/e7B\0(]+LCdb,_&UGbQ7P-;Le_YD\G79aUYUUO9Wg^;.
@ZR@6]IUO=<>7(:F@[c@8YCWD=@<&XZ_ZC4O&C+N>UTf6[PP]&Pa]C;K&88Ra\SN
R+P82NM@A5O87I/0d7#6WYU+4,D7DH04I/8&MWI#Qgd2>f#5IGCT;)WN7_YED>T@
B7a6)G5]YHZ;XEOJeH4KgX6f(\d#SH#<XfdZK;5eHU+>PP/_J2PX#;_HaONfT5^e
@N#(#VcSd=GD+g[#J1/ba5S+T2HbB&SIH,Of]<fIa43;)Y)Pd]#aZcUUM8(GR&0>
W,:1f-PT85?CeI5/+SAL\V^:#DadMT0)+5O.OaZaBEMeaL?0I+;K]TCK,I\<bWFW
I6J>IBFO?Y6NQAL[YVJ]=TR<JFX,;OfGGSbJH5+OW?Pfd:_3KIFYCg)g>YMMc8G8
ZXFOSG4A9AY(^I9JMbgIW:FSKN@SOdB8\_+Tc(gIf/BAV7D4B(?&H:D)WEcgd/MQ
4J#IHbVgX,^O3Q5M>QW)M<@&@T\]+>fTNYF#T4W8)]&9FLNXa+;8ALQeQ&34f-@>
]1Y\QgfGVB43CFUT]:P&L0/(_RTGM5RT;F_@KAALD>2bf0F9P,B=5ORHW8)6\O,]
C<@U8H),SaGV@<P)E<E?6M(Q[5S,1#(93F)K9OQ9;=N=C5-AO&+UO#36J\I,68W2
6K]/c)e3eZHJ3\.fIY>5R\>TW3A_XP9]UK/&=2>=G4R?5HD8ZJK7VCgX5:;QW>(b
.F#4cHYP1]TVPLVPLO32V(E<gN@3?O]F&cXaX],)M?RdG+=R-;/@W7J8/SXN02#>
1\-f;\Z^-P2W_M-aDaB?QL;gU+0E5:R0;0#OHBRI0751\(=S><JLU38L70&SMN63
C.T;CU;DCM;RLDPL?R)ggT@5/?;_e3PPe8QT73R:gT_X,BC,.fgA>Ac(Y3NFMOR4
4(611dLH;I?^3g>/dGZARSgV,PO<3_,Lf.d_5\;AC/[U.F+=@^01fM5D#M7E2ZH(
?-BW/&1:;5JO1d>g,b74AYQO>5FDC,SGfcN:QJJ__C^KPe,LOD5P@:>QC@)geIWB
,^@92;P.ANWL1D1&WKZ]PA8B)7QTf3D>ORHNd9X9Fb=C?8NL3R-25Aa<3P<Rc\WS
d(6<_(8)L2_+^BSA&6Y9^;b,QL5<=D5E8Q9#G6<A.e8EQF88TP=L#K(4]bUO-e=\
A3TK&.T^550.PI_]2:V+.XQ(LTaO\S3WGBDL;I+a8BS<42V]O-)5)GGI7UF.,_LX
@8(5ZUY05C(eQT6LGBH(g?4F1@8C9+KY1=e&JE7d5P.U]1V;E.2<C;eL(5D]1NHU
)5&aE7B<7Be-OEAXRWU(]e]eGK@_2->0AaUEg-Gb4X^39W^G(I;QF9RE(HWHQ9O5
_d\TKIJ1)UX7I<<b@VE:@=8A_#AU:#^]g5OG/XPAX]UVdA?.L+^DCKQb6J5\6dLc
Q>;B88]Y0S<ed0cB\gU+V3XSJRXW/QK.3acFAZG6&<I.>PI3FDWAFG@I_-[:_&SE
4b@?0.c8KDFd6AZ:,fQ]&OCeX^_&[ZOC.dLKRP?23+HJG@ac,9c50X&U,P><c>g>
,DHgPFA4.R;3#6cVHX:UV79fV=e@^ggGGcEU8AU:8&&7]\&Q_AO/ME/bDc>bW#b0
=KI?2?._BS=H:CMPIg_3^FI-=9\<:=KQ&L+X08^bBb&F)J1ADeVdMOfK+Y<H#>XS
R.R1<NTGf)TYOJ0VI&S^V@<,(VT;:E5]IK?^Y;\WDFffVBO/1&YA6Y6C-5WYCW27
\;+^Z[bA1.K.V,^MbaCUA-8&P>R/.N&I=^)RF(N\&4YO+X9Q/+8]N3^>BLFD[.EJ
<US32?KA1&NVbMUf82c75].ZZYc6T>>49]&RZ6VS>.RJ@2@FeRR:b/&4TM1_SM1c
.:d]W1:ac6P3eU<B3/7N2-60U<DO/OB[Of,bT;A168C+<]@]9S0Q7@:59YBe\=Dd
T,MZ##YZLT1,ZVC:W_QW^L^O;;N:T\HG>^=8d)[K7J<NORT[4>dC9A)V.#bK_a2R
P,LYg2&,RaAAQ9cYZT^-7dN>_WEEUJB/@):3<^AQS+:[d0>_\SU+07=4cU3VS8VZ
)&K:]eS42[=AJbe4W/2g3J9gK#D:_eJ2FDP-(D/A?KBX;g43E52=?_<=<8fF/bCD
33HAXS#R::83.6)bI;0@6TZ91AHWZ/WMBLUUQU_K]K/Q]35[--FG\_J>[DFN4A^A
@797H+;NEV#SY0,\+4QVWI-QR3#23_)Z)Y,1@Jbc,c,8#00e,2]VgAS;ZW:J_E]N
Z(N2H^7HF.^4_f9O8eXGM17T1Q@D0V\.;F[6<1X80QTKe9g\]IR<WVORM/bdBgVG
0YH+0(d,U:&J<J:<S4.\:[-S05\V565I9-]FR0PfN<<-.9F,AJeX&WN<T_gb,W\b
b]ddN:10[F>H)C:gIc?P)LS6R_aYeB)e\=9AU8H\gNdFg95@^2a,@dX(]]5=JZGV
M)_gJUQ@7Tg,2/b:(MYIB+,/1g>aK.2bd@-JBL>J:dabPYTWNe(>?F^G\FUa>EY\
7R+(TL-XYQC&d7\W>fH/V-MSCfTJDg^2bJN<#4c4fJJ>M/_KEO;[eJ<N)8#3(;-:
SRIAOaMU=ZV/bDXfZ=)d+#(8XK(dA5&ea[.Rc,ZVKRXd@b&.eJW;#S6KEbD@J7MQ
?;(0>8E.2UFM@DGA5N)ZW;d2Y[:G3G&5WSIN0&&A0IHcUf#N1L\4;X&V<6N15E:R
bfK)Yf?_e?6=Cd9^HA<4OTXcRQ((QN(L5<CA7IJIAWW2,-a;O.c#KVXB]=J&&X@J
bg0CTXX?cf4QTI99D(82XF7]1O/Q8aM3JZ=795#?bc2(H?2:A6X]]55288D,-cQW
<WI?/c\ZL7eAQ8P2T_fL<KYP+JR7Bf7N.3-#=,OC\2b9TM6<&;R^:+g^)>9R\J53
H29/gU.O-FfVKd:P,D@fHFK;LQ8O4()0>J\X]3@@C5?MN.ZaABGXc(YRR(TK-16<
W5TV?8[D]V<+M1I3)KF:Re8A0c5N-K@7d<KWIS]/HReOM80B&eeT7Xd^?+?KD2/N
E)b&eS&^BYL&RJ/TV+.OGZAG)0aZ7>Je+0BH9DXH^(3VKQZU.@.T3Z6#?ET4S>F0
d,PM4MCPPD:cL]8C#:86ZXJ.0D)ZeNF;0SQX90@(#@)7ZBN:>J>d;@G2XY=5HVZZ
/eR;^:W67F:+&bA05;U51(a>b#]eNVHIVUQP\B?fB@SQW9\:5e;[1+LgB^R_AHH.
U0+PG<?Vg;H:Y=,6GR#U#,K0N?,/[41[W\cDNSeBS:\J7-4(@FfCJ:\//.QJ^H6]
\bGgbI@g=N;&L\Ocfb),>9#R=)cfU4)LZX\eQ&RH;+/&Da[^J&TH+f>DEG9]B9(U
.?aA3R)8EFD=61(,IAda3[+0(gW109]U]S^PR/QH0S_#I7L_F2Za5Mf[:?N&=-J)
17FXD-=[_?M5?Z]3g<K7<TUJKFEcS_0[@K)7-]J<;LC7a>bKW^^UDfWUZO=BREJD
+cZ-F#;bX-ObF1[7DQ(+;7CNd@R#6WPEB+_EI.=Z#,GV+94_D?+eE=GKO[0&ee5<
FXW8FS;OI6^.II):BIKY.P69[+0Mb_O9]X6@\R8@/L:/HA3\PJ?M^Z[5aOVPf&8F
H&g#??>08LB-cNa]0D&MMa8)#VR_eKF(TE@g&;a_=7a&F#:T?HI@0b;JTG+Ja@=X
,0-BRB<dLXH(bM,/dT5E\[JVW:Y6KUEHR\#ITaRA[.ggMZEWQ)4Z\IJ]CA9\2]-g
9a5)R&\SOI2-_#=e9/HUQ@:Z7OR5QS05g@<J3CC[L+?J6Kg7H61B_FY>2U?YXK:Y
=FU?NeRK0G/]V0P1&X&0e+[GD7e&?=A\B9+e+>:d4G_]Ca[^R0Nd)C176JZ[#/Ha
-G#7&2]U7TbVP+0e6GCU94[&CaHf/EV.7[a4d[d[/A;X#M7]@YH:QD-[WaT2N;PE
FFC4GM[Fe@VaYK(-^A^52R:g?J^H_.RN5aW[:7Rg31C\.Tg_g&O3eB&NIb@8O70.
]V_JV)Lf_P73(4dNf1g;4>[b4G_4_eV][I&ZIP>=c7K0^(&U);A0FcI5g.TgNVXe
\NcOHDab=V<NVG)#FP#,IR^8]URZ>9NO-?<7T4/=>2Vb,XTf;I:FBQWbL0<BFTK@
6bCOW<_^NY?=]]8,A1PMcD&MUcN9QEG0\DcPeW_]=O5&HBX>;:D-?7dJZ&BDc.9/
Sd,MX]J<KfgKB>S_>\4[\T<8GP,Ic5#7,OOe[BC\EM5=&[XHW78eUG2BTMK9512\
>)4-dO(-W7)N/8Sddg[^5Y0<(M+72\+JZe#-g&;5J40<e;\SdAag]33^UV+)KL5f
&I7(;)PVK/Ne^6>KbR-J5ZaCF.XD,NYOcKXQF0T7([400a)cYgQXM.5e3G?XVU:<
;E;]bH<gZ316g1X>Pd6c9_DGG4UF0g.KY3EN@4P97>&KPg,9JNES_Q-\bGC66/.,
P0f70g6J-aM;bfHPZ,]T[Sf8B8.+Ia.DaWd&(.RfbXQCaAc>c.1Z(W@FcRH/gTL3
C2?>ZgUg&R=J&3H-QQTV_VY?4E3dTM&(T&1aIbW_-?PF]#Y:bUBBQQFfB8[Ma#;Y
K<MNTd/6Z0TZ?1W5f273Y-6S/C&22&_Ug7)\=]1V/LF0ZW7?+5JLZQ0WcU_aC8b:
RJVTT5e+=N[).>b/dN>X(1SECI>^.GdW#:,QYD[cI4ROP3VZMMQKeOKeM9aM6c:W
H4GIR<5Pa-b4\#/3[ARB5#bSKR&,T@232K#Z,U1Wb/aLMIZ+-K/^F]Q_N6bZeR>D
&c_(AVN>9]DMcUfC;F7:6Wf(bUIEdC#&RGLU929<98#X-\D#NN-U]4X-:UUSDH=N
3/-0>?UK,RePVc<B&GL-J[H\,a8f>@X#CYfAQRb5RZ2&D==b<MUV)b=gH35ZN0&Y
5aIbC^f-N/(8HZV,N9EQ56WM3E8>\DJHFfS@FT93QYc;94L^,J5dcQC<>F4<9O<(
fdP4cMSfbbT+34=E]9)N(PO37,P.8@M\U\VO[gFf&_+J@G[0L+[dM<JWI#6EQ=4L
JVE5XV]:7TP_C=&?\+g)WL<5Q?+&dMD1e,F7.=@A+H=-SI70SPJSBY&TXGe-W=KM
f<D.\;2EU+;O,QQ_T6W[&BU.3+feF;W7R;+NX-\FCV&VU;T,.Y\R\W\(e#Sd60T/
\5a8E-6G7=0>:H57T[CVDeZ[(H<JJJ_B#e_B8N]AYB[MCK@,=N3bGWd3;DH\Z0B8
#eF7.U9<5-^374Z=YPDXXdWE+J?/1NI]E26L7AbH#=R6P-&LQ2,gMP8C\9bPP8I\
STeNJ#^?4SF@Ja7=B<->Z#[67G4TR2W[Pd5J8-<ed3:UJ2QX0;g@NXA\Pef-HO96
^MA1>FSW-;U64BeSX(fTVUf:YOE7P53/-O5IB9Pg^Kd\^DT5.M]09LARL4N]SWMQ
,@f_X_F0dfU95#V]9H5,9AfEIDI34cF4aHf-6>dC+KOcF#)DA7g39H204g1KYG2,
dF+:1B/T:;H9CLQ\DA:Y_XSK1)G;-[+WJYF5<A/8E_ZW_WIY[B=R+E6FbUbR<b&N
RKYWFaR#H;5^&=_GYY?MD+(]K=,#cC&APd@/0[Ya@GMV_Z,R/[cYW-RCMJA(.YNI
=KC,P0O=Hca(C([2Scb]#cM43b7-A>JYf7Cg=.MXLd-S\1TY?)]P/WR-+/V=^NB#
+&C/gc[(WVL_.BM<Ib._T^Sg1Z0FBPV;MN]aA&)X1SLO.F7D=/)?H]I;eRXQ(>U8
E_NWB^)_^@BD=\_V)OT6JRC-8R;\MgUX>(a@fH9ZS^e0.FQ[aJX=7C56JCL#S22E
V-BcXDD]G_7Z0DMV/fW?M8\0N7UDJ54gLGX?GEAd247Z)#()Uc4Q9)?L?H@16N[@
GFPNab1MBHI.@4B\I0cfa^KSMJ7g:D)L?6YA)OS1>VDNU:B:[=b^Eg3C2V^1>Y-M
#-10gg\9@FTH\BK,(-HR8WA,QP5VGD.<I/#P594)VL_9@<3C&RU&@G#<+;gW1]bO
,,U9;1.S+#eCM:R0a_D>U\E0Ua]87..2(R86L]P(=0<(B]NZKE]e&Se96L:aKE-<
I3\&4PW;fO9(#JKNI\X?Zd/YD0VCcKCaU4Ae+FE;7X374L,XAb?G53=P:T2;6;eM
KX@Id;^RL,IQ<BTZAG]>Q^,4R&aDVIJN6<_M==CH/N(TC6M8Q>:A[Q.gR0EV9g^]
/0\P.^Bf-QGFDfMR\Mc.f)TN.=9Y<YE2_P;(W88I9=YTK(+Yce23e<0=8e(e2L:J
>Q.1H(g^RX@e]9\DYW;:&gM3S]I#Z&6NgaeeJ/b/?Mg2J=?7J\4HBHA:JUFT,DKC
]JA+YXW,C_gF@ecB]^eGX:g2]C+aCZ(>JM\W90-b,7V=<\G;@28d<O@=Q^/O0/gc
20?]KL_R4O>Ke_YQF_[YNX<_ab@E\K3<JS7\<2=J#9f.XA2g[Zf3>>WTT@&4:5R9
./EJ5:<I?7F^P2D:WC4@(gHAGGZc9^A^Q4<66HO88M9O8QV/5,DRbG,IR>cEVJZ[
Y0/g(5PG,FLPf-Rf<@[;Xa(VQa@<4>TaVb.N]-g9D;?=A&>gIF&5..AFZ&cEEfeZ
bX_D8_FK]0M7YY^./BG24fU9G&BC.RZ8WVef_,()\&;3:8=e5)O7KWOg9Yd20^e:
4S^Qc_,9D([7-D^@X@GI+ICU,WRXW1fa(M3ag0IJCf1\2<8165BNfIb?6@>9WZ/F
aaL@Q252UL,&@e<)3>95[:,V8\b&3?4]=OGLg;(KVf_B6b\Z(P1ZRg/a>(b]e)-W
KCdMFN_(T235N7U+c&,\E_Dd\\Q8S=g7H)9+W/RX-HHFf.Ca]Hd^#fC(B-+N:.J(
@UYRIQ9QSA>ZHQ\M:4U/\&c^V;Ycf:YO0e2)&3c]gIGB3F,K;F7W7#\[],K7G.JH
);,7]E>L=,;S?c,17,;<927I_Ib2?FbfL1:_\MKST27UX5W3P)7#@U&+_aH-BOG\
P4&=;M#+8\/@#a\cB].f=8IV3F0O(]Y,>I8bf1AfQXW473V=L0HH27FCA+aONe3F
:41-2EdPB\AN]3^;R8Ud#I;O:KEJV5.D32ZBAW89&P;@:[/YUQTIR4:5(MQ0&PH.
6<<+Q]/VCZ^)BfCUN8LAR.,aCe?+EXXGA/6&Pe<IWf#cH3Ve-5J>U5R5H0Id:CLU
R^C\JWe:)<Uf)GAUP]2F\&5d#?g9I@>K5[>KD3^de=):5]JQWNN4[Yf;>5aS(:T>
D9NN:.1)1;ZFB+MQCCOD],A<RP[=d-Q^/BBKgT/DbU:COL\J6_XfW\+g4KRL5/:K
(4U?ATg.)eYffK?(&Ta[,RH?8=@1K=D>Y;T^RdaZ;:[&F<[<?[W,WUP^BTJ<#]N+
<8K>Z\e>G,TRAbMAg9ZKW3ggc.(T(:f,;G2\3eJKI<..2Z\G\A9D_O0Z?G>#LDQc
V5:#\\@T./a=QN3(N7=]P@UL1AB@\E.,P_?GD8?TD&g-a4HFe;a:M@5WCPadS@4J
L#FL+=LYGU\@8f<<d&EK>)D/H?27[K-2^REQFc]1V<PEFHKPC\U\aV@8fGIYGI\]
XX_]HdM\6Mf[N45K82AEZ@dfR#44G3U\e_Q4.<0AEXc8]C]IU^^,YJeS?KR.HcIf
E_=Q#R_V4B).O3Maf,MNX)KG,-:7(=[.Y)G#X+,ZI-Y36CK--HFMAQ9Z(P9c@M\P
6HK6g;264,V&X6)3/USf_=-_a+KWS.3VC7]-V_03\eI&B]5bbP0LXbbK>EQCT+HO
G_[UV?V#7&Bgb9(He765I5?U7-#d1S0d;L]d&RfN\LGV.((2I9JA]#3YL1PAe+XS
>05a#=[^1O]N[>\WYc-0[-CA^A,(]+YD3I-2,D#3fa=?@AS,<BOGE\QdEA2/+-+e
<AJCW,)LN(K5#;/_U@HMaV6Dd3>EgG&QdK(H\.f9Hf(=]IS#-+Ha]&TBQ:SSCRN[
:5WK?8+PfY[+O<KY;)7O1]@M0WSI^4V1>$
`endprotected


`endif //GUARD_SVT_FIFO_RATE_CONTROL
