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

`ifndef GUARD_SVT_PATTERN_SEQUENCE_SV
`define GUARD_SVT_PATTERN_SEQUENCE_SV

`ifndef SVT_VMM_TECHNOLOGY
typedef class svt_non_abstract_report_object;
`endif

/** @cond SV_ONLY */
// =============================================================================
/**
 * Simple data object that stores a pattern sequence as an array of patterns. This object also provides
 * basic methods for using these array patterns to find pattern sequences in `SVT_DATA_TYPE lists.
 *
 * The match_sequence() and wait_for_match() methods supported by svt_pattern_sequence
 * can be used to match the pattern against any set of `SVT_DATA_TYPE instances, simply by providing an iterator
 * which can scan the set of `SVT_DATA_TYPE instances.
 */
class svt_pattern_sequence;

  // ****************************************************************************
  // Private Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Shared log used if no log is provided to class constructor. */
  local static vmm_log shared_log = new ( "svt_pattern_sequence", "class" );
`else
  /** Shared reporter used if no reporter is provided to class constructor. */
  local static `SVT_XVM(report_object) shared_reporter = svt_non_abstract_report_object::create_non_abstract_report_object("svt_pattern_sequence.class");
`endif

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * Log||Reporter instance may be passed in via constructor. 
   */
`ifdef SVT_VMM_TECHNOLOGY
  vmm_log log;
`else
  `SVT_XVM(report_object) reporter;
`endif

  /**
   * Patterns which make up the pattern sequence. Each pattern consists of multiple
   * name/value pairs.
   */
  svt_pattern pttrn[];

  /** Identifier associated with this pattern sequence */
  int pttrn_seq_id = -1;

  /** Name associated with this pattern sequence */
  string pttrn_name = "";

  /**
   * Indicates if the svt_pattern_sequence is a subsequence and that the
   * match_sequence() and wait_for_match() calls should therefore limit their actions
   * based on being a subsequence. This includs skipping the detail_match. External
   * clients should set this to 0 to insure normal match_sequence execution.
   */
  bit is_subsequence = 0;

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_pattern_sequence class.
   *
   * @param pttrn_seq_id Identifier associated with this pattern sequence.
   *
   * @param pttrn_cnt Number of patterns that will be placed in the pattern sequence.
   *
   * @param pttrn_name Name associated with this pattern sequence.
   *
   * @param log||reporter Used to replace the default message report object.
   */
`ifdef SVT_VMM_TECHNOLOGY
  extern function new(int pttrn_seq_id = -1, int pttrn_cnt = 0, string pttrn_name = "", vmm_log log = null);
`else
  extern function new(int pttrn_seq_id = -1, int pttrn_cnt = 0, string pttrn_name = "", `SVT_XVM(report_object) reporter = null);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Displays the contents of the object to a string. Each line of the
   * generated output is preceded by <i>prefix</i>.
   *
   * @param prefix String which specifies a prefix to put at the beginning of
   * each line of output.
   */
  extern virtual function string psdisplay(string prefix = "");
  
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of same type.
   *
   * @return Returns a newly allocated svt_pattern_sequence instance.
   */
  extern virtual function svt_pattern_sequence allocate ();

  // ---------------------------------------------------------------------------
  /**
   * Copies the object into to, allocating if necessay.
   *
   * @param to svt_pattern_sequence object is the destination of the copy. If not provided,
   * copy method will use the allocate() method to create an object of the
   * necessary type.
   */
  extern virtual function svt_pattern_sequence copy(svt_pattern_sequence to = null);
  
  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Resizes the pattern array as indicated, loading up the pattern array with
   * svt_pattern instances.
   *
   * @param new_size Number of patterns to include in the array.
   */
  extern virtual function void safe_resize(int new_size);

  // ---------------------------------------------------------------------------
  /**
   * Copies the sequence of patterns into the provided svt_pattern_sequence.
   *
   * @param to svt_pattern_sequence that the pttrn is copied to.
   *
   * @param first_ix The index at which the copy is to start. Defaults to 0
   * indicating that the copy should start with the first pttrn array element.
   *
   * @param limit_ix The first index AFTER the last element to be copied. Defaults
   * to -1 indicating that the copy should go from first_ix to the end of the
   * current pttrn array.
   */
  extern virtual function void copy_patterns(svt_pattern_sequence to, int first_ix = 0, int limit_ix = -1);
  
  // ---------------------------------------------------------------------------
  /**
   * Method to add a new name/value pair to the indicated pattern.
   *
   * @param pttrn_ix Pattern which is to get the new name/value pair.
   *
   * @param name Name portion of the new name/value pair.
   *
   * @param value Value portion of the new name/value pair.
   *
   * @param array_ix Index into value when value is an array.
   *
   * @param positive_match Indicates whether match (positive_match == 1) or
   * mismatch (positive_match == 0) is desired.
   */
  extern virtual function void add_prop(int pttrn_ix, string name, bit [1023:0] value, int array_ix = 0, bit positive_match = 1);

  // ---------------------------------------------------------------------------
  /**
   * Method to see if this pattern sequence can be matched against the provided
   * queue of `SVT_DATA_TYPE objects. This method assumes that the data is complete
   * and that it can be fully accessed via the iterator `SVT_DATA_ITER_TYPE::next() method.
   *
   * Does a basic pattern match before calling detail_match() to do a final detailed
   * validation of the match. This method will also return if it makes a match or
   * completely fails based on starting at the current position. The client is responsible
   * for setting up and initiating the next match_sequence() request.
   *
   * @param data_iter Iterator that will be scanned in search of the pattern sequence.
   *
   * @param data_match If a match was made, this queue includes the data objects that made up the pattern match.
   * If the data_match queue is empty, it indicates the match failed.
   */
  extern virtual function void match_sequence(`SVT_DATA_ITER_TYPE data_iter, ref `SVT_DATA_TYPE data_match[$]);

  // ---------------------------------------------------------------------------
  /**
   * Method to see if this pattern sequence can be matched against the provided
   * queue of `SVT_DATA_TYPE objects. This method assumes that the data is still being 
   * generated and that it must rely on the `SVT_DATA_ITER_TYPE::wait_for_next() method
   * to recognize when additional data is available to continue the match.
   *
   * Does a basic pattern match before calling detail_match() to do a final detailed
   * validation of the match. This method will also return if it makes a match or
   * completely fails based on starting at the current position. The client is responsible
   * for setting up and initiating the next wait_for_match() request.
   *
   * @param data_iter Iterator that will be scanned in search of the pattern sequence.
   *
   * @param data_match If a match was made, this queue includes the data objects that made up the pattern match.
   * If the data_match queue is empty, it indicates the match failed.
   */
  extern virtual task wait_for_match(`SVT_DATA_ITER_TYPE data_iter, ref `SVT_DATA_TYPE data_match[$]);

  // ---------------------------------------------------------------------------
  /**
   * Method called at the end of the match_sequence() and wait_for_match() pattern match
   * to do additional checks of the original data_match. Can be used by an extended class
   * to impose additional requirements above and beyond the basic pattern match requirements. 
   *
   * @param data_match Queue which includes the data objects that made up the pattern match.
   */
  extern virtual function bit detail_match(`SVT_DATA_TYPE data_match[$]);

  // ---------------------------------------------------------------------------
  /**
   * Utility method for creating a pattern sub-sequence.
   *
   * @param first_pttrn_ix Position where the sub-sequence is to start.
   */
  extern virtual protected function svt_pattern_sequence setup_pattern_sub_sequence(int first_pttrn_ix);

  // ---------------------------------------------------------------------------
  /**
   * Utility method to check for a full sequence match.
   *
   * @param data_match The current matching data.
   * @param pttrn_ix The position of the current match.
   * @param match Indication of the current match.
   * @param restart_match Indication of whether a the match is to be restarted.
   */
  extern virtual protected function void check_full_match(`SVT_DATA_TYPE data_match[$], int pttrn_ix, ref bit match, ref bit restart_match);

  // ---------------------------------------------------------------------------
  /**
   * Utility method to evaluate whether the previous match against a sub-sequence was successful.
   *
   * @param data_match The current matching data.
   * @param curr_data The current data we are reviewing for a match.
   * @param data_sub_match The data matched within the sub-sequence.
   * @param pttrn_ix The position of the current match.
   */
  extern virtual protected function void process_sub_match(ref `SVT_DATA_TYPE data_match[$], ref int pttrn_ix, input `SVT_DATA_TYPE curr_data, input `SVT_DATA_TYPE data_sub_match[$]); 

  // ---------------------------------------------------------------------------
  /**
   * Utility method to set things up for a match restart.
   *
   * @param data_iter Iterator that is being used to do the overall scan in search of the pattern sequence.
   * @param data_match The current matching data.
   * @param pttrn_ix The position of the current match.
   * @param pttrn_match_cnt The patterns within the pattern sequence that have been matched thus far.
   * @param match Indication of the current match.
   * @param restart_match Indication of whether a the match is to be restarted.
   */
  extern virtual protected function void setup_match_restart(`SVT_DATA_ITER_TYPE data_iter, ref `SVT_DATA_TYPE data_match[$], ref int pttrn_ix, ref int pttrn_match_cnt, ref bit match, ref bit restart_match);

  // ---------------------------------------------------------------------------
  /**
   * Utility method used to get a unique identifier string for the pattern sequence.
   */
  extern virtual protected function string get_pttrn_seq_uniq_id();

`ifndef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /** Returns this class' name as a string. */
  extern virtual function string get_type_name();
`endif

  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
+4<#DSD=2,f1A3AEHId:H+6L\T+K;0DKN(6(c3,,[0B,<ST+.#>^7(dMBRFHbbHV
D63+^>E9TFYDae8:2UUI&V5e/-<Bf&d)MI/Y&EUGROG-,]-WA60EGB\f_/XVX2OI
#287-O)1;_W+L8T\d&D/T43M0\N#_@33E(ab&YJS]66O?YZ_f(22+b>U#M84HW+)
eJ2,KYOX^Y2G+Yfd>;RD0g#&RXSFGXc\F?],4K<H&W8XKA<^dA=J]=M+?U8;K.dL
&PW9H^/\Bc4fMF<7CXa6DLTD7M9U[IIVZaO\Uc_\>WbWPS1/0+.fHc#2TPV1AN:C
RDXQ\fM:^ec5V?4Kb#4gA+N#ST<.dY\\RHO:GCa6YfBKV73+#e=UK8A,Q)e@X/Wb
H736d2LGNO1Vf93BQ9(15AN2VAQR]1_#4<-H]=6-Z:[QfN[#K=8:5Q=TOB@(T1)G
TSGW2BFVZ,LJ7X2F37E#9MU,_JUAI6W)C8SHN1G\>5VIT+>1TU:[6(-B#]YER2P6
S,aLLG7KP)eE7G@fb7H>;Y^Ob2-aT9EZIc>F,BV]?:d\HPDV(\C&)-J&KT>_fU:+
O2&^bJd(+@+e<1<d=G;?D[?B]&7T)MZDSOFULK#CXD_KHG86Z]9Z<)Q<7W;V)C2b
JU\gC2X7cg;=\L/.W8TH86V]3Xa:[BQSRIZDK,IURD8N?b<>_D+K+#;J5ZC.f7@W
C5)3e<I&#9(,Z]&d4f]4cT[EKbDVeBC+dMCOI9?LZ5M\8ZFYWWd;AGc7--OW&6Q>
US2GL:YGcAVZ&\cH(KGT^5J&M/]1dEOH)Z36bSe7/bX7T(U-[A<U,-NRD-[g3M+8
IF<Sd5WX]GY>5)3V9YeJ1af1OL<8L1-?F1/U6+VTO9^B^=N:S0fJ,O+A_4_bIWWK
_V@61#X6GR@(V>\LOQ,.=;VWebGOB[RE[9?fDa.I:AN5e>S=/2/CCL^.Qd]7SeHV
>e_P)+TZ+FNW\-S7FTVc+S.[#X\Qa/;BJe\7:9[VZ#7DJU=:aF]JQ-eHY]f7[]Eg
gUWQ4@MO1Z;QT)IcMFH03ZJK^38?)2[93a<VFTS7_McV&WCF,E+23A&deO[]JAE,
D>@M>@58B>b]2VX4SX1\QYNHO1S=T^XZ052gb.6)Uc#HT2M/)=.:(;./;:,.GOT>
J]UD;;CIb)^/#6c[IK)>#KIV&E2D+\FQ<VNW4?R2+2A+3ZS,YH&<CdbIc-X,_e2)
6FB1-C\V3(N>FKHVHW(/K2]U20,PY;X(f3H+VKI/fNSY<6#&E]ZbfN/IYID_0Jf5
9d-5[0A=IVIGNH6S9NW?@<CU7?GC69VYZ6YL[B]=c0+5W#7[65C#\2RE<&97a0+Q
@DeZ6+Z94PX9)P=:#=5ISbJ@^G(YMI4f.8Q3<cdHAO<BINZ344ATVD>9g4KDK5be
PPSG)5(]-E2<6bdD02QN3D]SaI]-#WB:4DR_fUG#CG.HB)CPAZG+\D(]LM\U?>TV
^GAN^J(;.#.OYeQ_&Sg6RV/G3JP]T7=EO/W0^4:OMFeTYV(:Z;LCbfS,=fAIATCE
g6/K6BV<.R\2G\3]IJR=V=&8.T?NNSM:#ZF6:7;Q^G2-&ACf7E[f;GNT:gC[FD=]
;#;^8c:1)7/e1N4XY0EW\)@<f]W\V#)Y(13fe\TaV#V\QD0/F;f#eBD0&g<J<C^_
@,GV\gbDV]=Lg5M8D]9+F(-BMQU_?H41@;/aL96F2H0#e,#a=,gQOVJ]X#-<(89/
A9/W@V/;Q1]E0&M]_Y__]YR-(8b#aU2OEKWHd7[;U.^EHcFWQ@3/AQ,RTOd;N6B\
a^P^^91D<a>;KZOdMDbSVTZ;\=PdZIe/7Ag=&4.;><]Xa.3NCLf)=;)H3Q.O.B@K
;g6gV)EOW/PR\\eIW9Lc+=;171APUABNWZ7Df:G_A_/P5#f9LVCQMc=_S18;T2.c
aS_XN6a2+]],45))]JW[)(.G4ISZ>[[83XI0(L,V,g((&?<1@YdEXfKX-=V/aU[1
Rf<b+\WX2UN1#E5VL9e?0<NX&VG6AY2ECASaTfZ/3);HR-90+1d:I\L1L3W+cF58
.T5&#T;C6JgF<gU.?^:8U.\R>>N_S^YVR@X11?0a<8>O3gEN9\[Z?>g>G;N\ABPg
X_?U1WKI9ebTN_R/EJ1A58L[:@;bcKW9c2+Oa54D??]5BXC,Y,.D5(d#7L/Y1.K4
XHU/?UY18:CcaVA:>1]+A;G_/)Ie>_<DQI=cHRH2ATD0&15_.cSX@WS\B.Ug/1AD
JX.3W-34<V5a7=(L#/NC/9Z/2e<SNgT?#[VJE;6N/P;;:@?13]=CMe0\,W=FSO5&
3_1.&@0[0C0;<>(OSVCA8Gfb/99+MU/E@\TSJQ#_@U/:_7@.J>2B0;NTQ-<::d+g
[78[e+&>>/Z2>)d]=]0DF[2.G/XQec\b)fON@^63F#-Z.DDPCZ5OG&a9H_O6,\.J
XW^Z_VHKe49gfH,:Q+Kb)8(2_Q#2^_Y>9_G^,_a]1:+E-1;VDG9f,A-9^K]^B&c_
]CPCcd94aH@gL^bS@T)03+\8G9E7EA?,4Q^KH&J,,HC8TCe)eQ#aa)F_cKY-,6@5
&XO+(d0#&E.KAc,B-J84BTTF(4aV>[\/=?_WZ;P-C_&060b\VDO^/R2O)/aXd?,_
.CL9]=)3P7Q\+(X1I78)6>fL<I8Pg.Bg>UCf^<<9VR8(B=Z7f=/LQ:fI,>>14d6.
0H95AcXDCDK7=M?4GHH;]-I^UTd/=\[UfQN8:.dRa3RUT97H6N>?+[>A@L(<L/?a
JMe_6P\:M8MDA8a.>P(&VO)3EDH7>CT@45VD&SeLe@e(03ICLS;+c;]d>MA1<M_>
f02&3/YJ@c1]ZL;^=>GdaLNcECQ>L55^/X:6OI+CbUB((_GC8?AfOKY;I[-bGYH#
T\6E+P:&.P@f^bY?]1B#FXHgYS?@2ERS6ATP&D6K61_E0XO9Df_F8U8AB,S#CX1F
&QQ=P+HI2=HGRNbLe5XE]B.-)[ZE8bLdWC\V@(gBAJ]?Q^dZRWP9Z?d7_ILW#g1^
RcCRfOa0eb.7OcW.=F;Mf5U57<V3V>([:&#(;Y@Fd]YH/8fFT3[7Nf2d0GW((cD,
OLQ.^ad]<Wg+NX0cLZ#HY[2?72a6D0))T?WRaB:IW9b?5T#T&F#8[17@^P&VeJd[
]VB58E9dY5.+VR&2\VgYTIA_CUW0UPP(3aa?X=A3b3ZYc,WB<.d1BEf7e,AXUgaV
e?_)ggZc=9M.&NIbV^&eT1/9@I6XA4<KFA9bV2P[1L?c>>H<.\Af.e5B>P.Gbf&Q
J\cb3G]7JEQY,J:b&/g4WX9NG];<b3:ZHU:^]S??FcFOWa.\#4[1D[LY2_C@XQ0L
K,AG;<\]L1MD7.S8^G0U3fbM[;<#&c,DMe8=F&[:F7H=S/>J-4R/?:7T7U0U&B#4
X@NLPGU&,ZW4c7U^?We>(B&Wf2T:;/)eF_e--5[1PLFE4O_Pf9aCc;/@<dcdc3,C
7D/,T<91I>,K0A<9Ugg[Y0D_E>61T7&(GM7-SC]J-S^]T;M)J7:>LbDHJd8URIG>
&/+IYVUL?b:-FUE1e-]2.VO_^JbD5]#,2I8>c3Kd;<.+/F2ebLKg+e0IVG]3LRI3
5E(F&=Yb(.<13VeV-#&a/GB:>7OU/5-HQ=+3C+E.0b1O[_;<[7=:O.=Q_NV4SSO[
J=GQ_R42ZF^g@@a?)bFLdcL6U5G<YB+BW6X4:aeFDb+1#FU]Z@K\>\VB(LKf>.e[
P.YI4]B^5MC_7,FY@J#@c49g+ZYG)/&g.G9,Yd-+P685[)PGY/(6)8]HG-\HHfF/
c8;LbQ?<U2.(LB(+GK;,/f\fcKe6B9E:OBCVaRP3UW_;?9S^LgaL[#\cP,&9OT45
U,cG^HY;G:H5,R[&Df</;FN?YLaE^VK_>&G_KN/]eL8fb,T/aA:</9XM8#XGdPL?
GS0V]Y^XIdd6bg)=X.;\WQ_fG42#)Ed._J?[d]UCgM2X(\7.J.8@POVcI.)+?Xff
/0-<Y6Vg-63C5b.ZJ+40(4BGYXff13N;4]5eeB\=b4>\CW1HUA-]>RSSf:@UYXgE
#230G#+7<C3,?FKDaNV^YAY7WPM&3I#g7K84.M1]Mf60ZT\)+W;SW),2;@5#QY=O
[G(5d+R)&?./8=^[[MGHPDY,QD#2Bb^Qa-3J:CY/7/WJL[e#/PFb+4EdG;&Fbc0d
B^/(\BK__A;eIG(CC+4VHGW29;8NA:aRCX5<>##J.W[-HL>[?[fF6HUCC\87+@f1
,IFeSE/L>A0/S85KJDcB):N-#1HGeG7)_G1QQ,JRX\CL6MQe-U_EUZ1VNUY,SgdI
B9U[,R78d._AE/8d;MVHQeD-5XSM&2A?5Qe0EI,H0]V(e6J_1]^ZGJXSD:QWaF.M
QVI7f\C/U2LM6J0T?D]0)WSR&C7^\HI9a2f4C9O[f;gPB2cW8aY#,.2g5(YFD8+R
<&_D>SZ<Fc]&X]H=8f@YA4;V[.Ca2KX0W2=a54\EA)>/ZS0G@_c)W_fV\GN39+<9
G#HZ,@.0BTHJ7@^(<N_OEDS525#EP2I3/\FA\\FF9)(\3Y+<1[NPQeWa]Z80#:56
AW2(I>:[e1ZB5bHZWNQS,Z_W:Q,PTFD.>Cf/Na=]a#(WN:WeB(W=UXJb-e\c1d5f
R-g[JeC&B6fd,7GIL4ZQZc+G]UPFc3,SH)9<NV\b@(3MeGH;8K\@&^e<9CI0FPRc
4/H/U@6/D4^F,HWcK@O8F4>Q3=3<De9,,MgLTc7[FJd[Cb<,M;C+M@26DTP)dHYc
>314V:UA?\3302]dLAVFMO.8(C=</LV?g,GQN5PUV)R0_,#1645<EFGZ]SHQRL6f
b4^8(DD5;JA[caN=Kd8f<8=Mf]5[dgcE;a_bC&f#J^=/KVW1232J=@#4@B0X54E/
+:+X)a3+cZ0,S8IV235-;F<@[ZTWR3MZ:_]f1+cH)I..2f5eH2?41/>)/<GB?,6X
9?Ae)fRd;1-E7fFMIFTC5O6J,J;;9bLc7_E^Y1_R1[+U,+:L8?@8LdU(2b5/P7N6
U.XE@ea^7H)15/-,eU;<GI=8W3JJ.(1\W,B\4?Ea/^1Y2=:;;]&7:N.G8#V^2U.E
_R]c@O1/TUI;8c(<UICZNMa;a.UR.f&CCR03F,?60WD/>G=gRa+-&.&D(]9C=TZ(
^eg=Fc=8O/V?G=<SJ)TO/BgUD)2C(.e8?bE&0(VQXXbU^(M^gd)\ABN0W-AQeA>Q
_f^-<Hc8#E#F-:?AbagK4K,/#7(D2BbWV+FE/GO5M.G>2Uf]S&.,PV0DGK([cegM
Z>RgNDf];e+YSRRXWLW@JP,Ac]9(UP[eW6TbT?S;-HDdWS=C4_4N]O38a&[F&+@.
&6E:g,34EI1H;14:Z1;?+AKHFbAEHgGA0GYOQc=H^+Ta9Gb7eVXHb2+K(I0RQW5A
H)f21#gZ05)S-B:WT<e6T6Eg+6Se79E9VfQ=XBR/W+1LB34f>dU.&+R[XCQ<\_=C
<+>36&KZRTRb:g.9IYY3W:.bX=P&?2;G07:.^FgSR(eR6cI[BfR_BOP(eS>ALDM0
&<@fd<ZWOWK_A\G^A,NY4D+H^#JZ#V?_MgP6,?<cHa23.;8TH054]dP8-.C:.4cU
)J82[)3JXX,gD>&[.<XM:d?8c601C.=ZNSH&865K&Bg?Y8OSVINT.R@-Jb@T.gS@
(?7/9CCR7\8S/SD=9AF88@1VM7TL)#YHE(T4]ffZX=>4Q56IC+NZ^S_@_J9[1>=P
CT8/4@;-&O51e#Yd/(L5OA3Af_+c2<&@JIYKLS:.\Gg\7C?UJJ^e(-HdgV+V8eSW
JK]^g78fPDC1>f0T,-._:FYG&GK@GPVGBMR3,a37^CRNG-,2&eY]f/D:0=IUG\1M
SMHX]AJcQ:)+2feb+LHOIUUJ8NO]-)A>+(&aQ/WGT4Y.]B)<)ZY2dbBA7>-:AdEO
TEQA1J3Of_egH0,M@L=+F5725:D1XOQ.FC5_+(fdDAcLN4O-AYbH76:6QgP&HQ_2
5V6dS65^RG_2dRD>XHVT-.Q@L>+/;e@+89)HG[:\(<cXWV8W]]W#&0@b@/)S\4TK
\9G>QK8g1)8fS+9:8:LK2N[d[8G/5\f:^MQC/PZV&YeSJa4ZeMHU#3LWFfQ@edGB
I2)cO,bLWRICf8=eB;&]80GeA\+IG>a8T_GRd6THK,Df>)X.>.)Gc#dE-31/.341
)DaS@B/K;(Xb.5M^FF6J\QN4f(H)-@>)L6LK4\.)L_:I0]W.4BP4Cd_MSEG:A_<c
G2.O9T>ENb)-RRUCGY/[?WVbPc+]@JR1NXVF[B=DY.;O?9-E\,/EMDB2YQ<J_VKA
Y_Xf1<dEW>_#,V?K^bLE06WF-7b:NefE^Z)G]ZUYFdV6_9AXQ:eX;7e\fX0+<.3?
]:M-9<K<^EK0J6L,N2a7)-f)H:C+,c@a2CC<2,,Y_Z;/]0J]Uba10c685-E5Fa9c
K5J^H\,F<cU?.bIIb:UFFYC54Ac5,Y#VJbB9]QC3>69K=BH:TMSfDCG5X+EK]TDg
E3G0D<02)?-ZP.Q0WR(TE0G=aXX(L[CNH,\Va3H7(ER1fV<^HNFP<BZ:_^UNLW4C
&eP6@<LYO.V(b=6RSV,N(4(85a=E\aXe<^Q#9XMC8PQ^Dd)5;c?)N]Y);b.46bNX
0MK/K8^]IS44a/[-GPZ(;SXPVPbQB<Ea_WCL,BN:+R9_/c)g8:=^D/-2)/0H]TR@
L\]4+=7X7WHZ@D1WXGcgee)gP&;,=-7&Z5f6,eW/de<B)ULGAgAR6[@G8Lc.f=U=
@gN7K]&ILMf#)<W(DJ5#Y]<8gLad\HMGd()RD60Kd\F(BJ>LXV+>9.UWHE,@[GH0
=Z,P4NaeP8[VGBVP[7+C^#AOGIZ<IK2P,@VNRU;1E<[J-Y?dIJIHGdgR>efN)LP1
cD;Z^9UVF::GH>A)RDS38F4b7RE5eGg)=8RBFXJbP,,=+>3:RbAK\f<=]QMU2/V+
cIS\9#b8I&0T61[CIgVOKD_M[EMX,&<NPTA(8fG174Tf(]XC6YCgHYF2@b6@].SD
6A_#a&@(>Z7([U)[dFAR2KdJPbUQ0T@JfB58SHRg,^(8DP+fDTc^H(4V@5I/Q)&8
c8V_DHJf\dL?T]a6,]6U,?fU;=_+\g(NB6,#]ZU_fH1I7,I@&PdW>N9P/6-0WE6V
)P?X:4L.d1O(@Q_&R+T9U-6d7UH:+G,HFFdRdG6eQ[>MgB9D>;Ce4:O1JLgQ(-a4
@IaMc.HG[Y+aX^5fFa=5V^E:55RN4CPfP)TL0FW=5_82QHL0?VA36ab:>@9FE4E(
OfVcL+=3=RT+2f.U.,S5?S_Y@Dae+/A=0]]A)\:N>AEKO/+M=Kd=C;CN:S@M\e:0
VR+VDR5T,PTA[F3L-IXDCO]Jf]0;CQZd\WW0BNC^(RdAf/9=8NfZIOIJ+E^:?DB1
].&B&O6Q0]V3g3e>0VD<LcbL8T?]S<VZ6HH+76CcF2b[3Dg[g=TTSAMKM8U+,Y,]
<A6T.4A:<UN+V15Q68OdT.<=cA\7(3>]X,13M5:8@7XKR)cVH^LM_L(2,bB2;M?f
f6]OFDfAD-TE].)FGe<<g;Z[4>/]1(@_6C1-f5;@.)cC+C7Q0fGcd4GK8KcGW9?(
Y&(7Wb-,]R;?G7P,3M;RO;-4[4,&NR(b?;S8f3fOL86CRAA\(UcZ7YUX3d+GIHYK
Cg(e@@-Z8.I4+-[H/+8U<AT=c.(JBU,3SbVCSe@4S?<ON(E0T>L3f&F_Z0LWH1<_
MT]B=K&dZ<:V]4#&QYM,S:/1,8:?NW_Nb,3+L,[;4BL-^e26@8D,H(V0c>GQc[E^
;5/:DA<LNA9AJ3Q=e.J>CLX/[JNC6C0?(;P_f#0RWW=[SE-?3.I>5X\])75fRfAb
AH+_eN45g=EOC08GE\)_fELTST+DU+,^#6&[BA9:3XM^K-TCHJN)(SbO+g7(.ce-
bc8381AK,1K?IM@c5Yd6],[QGTZ(LMaWJMV4A\a-F=:0M.M0;Q;874^c5TS2,</:
&c\Tb0Ua><\1MCEc-.\S#4/+UI8bPAKWfSUbaI=H#P<@4]b5I<\)&D:eCd\\<F0#
=HEM<2IMRPN[KD-?.f8-g56JG2656#aQ]fV]3K0&A3A?410We=I4&0X+,)LGEbC&
cZ^-KJMUJGD#FE@OT]B>FTN/c1M]F;Q/FKDb:1b(6&]5;>R+bJX@9,;.MV&W^<-Z
3MF>b_KPDd8&:K0Z7R3N?TfbVRI+8?Kc2/[=/,CDSU2LU^d4I9]RK0D;#C7)QQG)
Nc+E)\?/[4&#LBGQ,?3CA:(09ECa\FXRbW)(ZSNH(<Vf+Z?:Bd?N3U-&JaIOF,1_
cC/<#2_e^Ja6OUS<F#b,5WeJb,VG+=\J5DDMLGJ?#5.6B1NE6K+.AFGMR3)IebP[
+Ge3#[cD3PZEHINC6:=P.OCQG<gJgWGZd@@(6QK8a->b#4@.B=^G.#0KNSaI&660
fe^6JgO[)#,H6Q)-ebX\^46Iff::fQ-FJ?Q=-9B-FZcc5LU/g@&R.^()(<9,=G78
fAXgWeNT5G@:QHHTV#afVU6I@\L0WY^3U#7&UZ956HG:;5a\>;ZRW7L.W1KUWMIG
L/YC<J:03DKb1<R/:/=8NZ?Y;aNc:-dQ,=EZ+-[I6HM(1bc6R18a5-_c3?3R(9@b
a+/4eEVcUZFF09=E^EC.:;T+&4\LL/Y,7bV^PVZdQE;;#S(0Qe0S^MObS)gL4.Uf
,KXJ(0HM-^Z<=a)Q:S&fOLXAcIL3ZgU=F+0F3&^XD)B.6KJK<;afa\]W5e=+Bb:?
0=2aXLXX8\39dKQC]e-)&G>T(;#,8-5\2,=R6C^;8cXA8FZG&&PX,^H.ZV2He.W>
;:>^UG&IFc+VFU+ed[N^Uf-8_B0Ra)(#)NEDa9.(,?\#(J&<W]_^][JW)=AgTI9O
:?^Q3KZ+3)Fd,Wa,WO8XW/<6\+#@Fc7@?/dO0F&b071bccP\MU.(,cQg(LO+Kace
OP_2d,P+K4>2d99N#_4#b:X9<I]P2b#3RUd]O-QE]X_=b2]9(Q<:EO\ZFF-KgNLJ
WXSSf1c9Db4T@?+#YBVY/<e6RK_:eM(&aT7SIIM7Q45]\+95Wc7)_:A3];VfIZ?0
\VB5.:V][f&I0L#gXKT^Q\PX:?/T.5G]@5X1PA(9TSUA)DKGb#VdM[A55OO&Yf<H
KeRZ1&U>E6V07g0L3LfHB0)D(+AS&dOaU-WeW@5E].)2d=-@0&0/:aNAg1D?Z77B
J1-_c@M6BOIJCP?>D/:HW5XY/GK7@:+Z09)OHTQI5^Zb>(aJ,[6OYXQ:JUC]P<K1
0?)V\>8.:&5R?:J&G9SBgf^HO:T(5@_CY<#Mc4/c\e)O+5R]VA_(4Z+R:MLVU/._
G2Za7X+dX4a>(HRP=9_4cM;07<W?fZ2?V=,<GV+L6\8S]:OJL:fGKBRLX>ZG8ZS@
4ME<&fc<<b/SB-(SNTca4,=N;>1S37\:UTT5F0.8SZU&>+LG7Y5Qb(SBZUX\8Ba=
KE93O/<5a->B^C]XH0#ASM88^db=4NTAf]JgZ7/VU>SF41^_1J9^1V:#XVXOdLRA
2Ag0>C208<@N)UMa2X[9BP),)K<4&[:O4J_7+L.IX0WS7B,PL+]O^]A)=#Sa/H&N
9eOE@S&<dM>6143#N_#dUP97#K^[EH15TP)H..dQ6#Z86R?QBUM4TT\<[NQFDaPD
7bEN(gBC_[IFF+ON6JJ(EBN.QYMN./FL2[_4)K#g#?e5Z,T.-aCLZ:a=3G9S2F11
DBB@U]\L/Y0[PbPO/=Jd68^7A(C1#T<1[?Q_\NS<O?A&7QU/=)bVbPTL0AZ1XES0
\[64Y[+dO25Y445f^)E&78gdcB(J8.A;13W/OT64N/407Gf+@E#1Vd7+a[cV(^Xe
BYeLH-S=5bBI)_5@J;X?JK<DEDVML-ae\]Hb+CE/A5N(aeP8cd>7aP^Gfa39d;HP
^U>R&4\)Ga#de0g6Y+f=WXOXEWH>062.1E96]@Q:;A6WAL2DAJWF4.]Ob^9N,+4\
:^^-f#T#N(/QYNF?B5ZbVD#VUH:AEMGaN2XE\BA\,Ib@P:d0@-?:M8I\JN8YA<5B
,):?+DD(?aV_/+aX\<3+dd6)PR5,-gW&YgF&AGAZ7WW>_93g<,JPfS-fR^U=[0c0
2?c>D][18/(,I)==8.9O+DSM,0d4[,4>0TDV,d09LS:AOXYfAR,;^]XZH0Ae];P<
Pd3-BgYUaWDG@R2JSaWb\]56)LMV+5@G;;VA(G0Ae(RaUD,F7.,=A=Ka5gP/KV1=
Mb?RUJZ@\?X\KHOFD;/(<H)W:CEbUgGNFKED;B9>AR<dL?_SG(0L<?UX-Q/&89)H
OWfA6_6P&G>8VJ+HcTR1Q3E+AA38+C0B^6DZ+a792I.\HJ1\3<N2b\O;-TM/1Ied
86&EaF0\?R-I./CaB-HV(LCRCe=d;:X<@;a,Zeaf_d;QXD,-\LB<PYV>ea)AK3=Z
.3NB-^QQVUDg+LfD:UD.S.^#Ff249d=fPFLD(.[60fTYfc1)=#[EE;cFX\ZTUVT4
][B9ELAD>[)+V2aARRWR&XM66JGCL9U\af<D@:.Y(]4-=>5?-+_J_5A42<ALFGA)
(3R[OcS\+1J./6a:O<@\P]J1@PZc,;ad3EBNKe&fcEe,f8Q-V/9/@Y>X+@\Z9f8E
UcWZVTB->OT@f6GTcH?OPPZO9R(17@XQ1PFYYb5=K?DN6U.;1&=Kc(;6f<;^@L)8
FV6JHd.@4W&3T,1@#91)b<faJS>g,[E4c[ST[U>+6K8S?QLF:OF3b<BSOL)9a(-)
aLBLd6aOc,1Y^@_@PZ)(MY&Na\W2]_#DS]3LC.YGOLe@(a>/Nd#L_?)d(PZYMFb#
[NH4ZXTdGQ<U8fSRZLQ;;^^80>A?JF8Ze6-acg#6647a(/fBH#9X:&V3/J?Df(R7
=XC^VGMR=HegQC^5f2F6N8KWa8c-T:@<X-K#bfggWH_Y93,C^:/Ga<3NQU>-c&\2
/+\1PX(+]L\#5L2=WH4-DER&]&]d0L_,d888N?+\W1#M;P=>KgUZDGX?V;bSQ.Z[
gXM.\D=:B_+18E:,]O03?;/Tc]YVNC0NfOL;_VPCYaCe>ZZ7OEeA2I0aT\c\5JO8
f^/Q-G1+2-0DJ3]_M^XK7,I_]&eA=R]d?7&=226-1JSP@S+-(.#g]<:F6gIeO(@,
RM=C\5/_#NJMdT7,^fY)V^GTbZVKFA0HgX+P-G,3cZ:_T?aCdS\V\[G<)\gF>bD\
a?]9#bG0a6.#TWac7b_QSFVJCVN5]:4?c5LYDd41EAXY9U:2Y^&QN8_..RZYQ)Cd
aOaH2FF&XXE97?6PEXKXG6[^T[E>e(Ac]+#Q<,XeE_8O;R-)c_];gb0G2X]>e8JZ
B1aXZ/2QdMV3=H^&9HGgVB4#C@9g3V\G<Q:S.4></(\g16]6[Y,F=NG^,eIY5:5Z
I77LA2Zf\GfC7NGKWN+]J4WS^X&6KZ,CJ\K^GIYK\ISc-G#c,[Y/XT7Dg[0&:N8R
1B7Mb().M7?A[a;I&7:X/+,e7CCAU0A1-Z:b8/T?cV1QH4ed^)><XdDMAfOA/TbI
<L6G?+/(A#)cOMX8Y[GWE(a>^GRGgFFCR?:2/WJSe4^0HAO#WMKbA,O/W(Ya+.&B
)@2^4-3?/EAdg2gD/?Q-Q<E+0)@dI926TdSFE815#A2;-&Oa);6B_7RA>#AaHF,[
D/5ODLgfH(8G0_#Ke<]a<T:20?bO/TI.T.?DG(MM[E4F>@/S3XR+^]G0\?#\cVW.
P+3-Y0a?^2<S8]aR#&?F)\OTH^+Ig8@+H:,&@7=G82U(J#PO2,EZSBLb:X\D=ed_
99))4J_D(3I5_>Q@U1X\S_>/\f_T\G<e8J]U(64>f)6a=88gCd16WU5b(4b8e&9K
U_2PQS)CX-=O<X8=VC@;R;K/NX9OE\TKL[5B<OVg;6&(F.V)M?[Sf;Tg_)=e+]F7
]Be,U\Y8c6B>R4^G[Cf#:Y.bR1a4&#g=FY<?GA8:6R=]:;EQ0KbOX^<K<eXC1\&+
;b^1d@GVIcH+g)3CVe.1UV53G5D?9+E2ZZ6CIGLfPTbJS=9KG_a?C@Ob2Ee66-JF
8DX?^+8SY3@6]T[:V81F^^50GeHA6+c@gF@1[4X7RQa9f+P#5T.B6?;G2##,=FK2
[bSW5(W-N16X^RONZ4XZ/MLR(X_1VX3UM^^_.b#ESQ)+<ce28^;BL2c=7?JIJT^7
[gVXBXW@,gS1YLH/SL,U1,X_[,bfN[6C&b3B,Y\HBKT(\#BdA7RgHW1Bd>N491I2
==42,JY=F(PLVe#[cQZ;RU(b.VBM3g\e)NU)fT)c&dIe4;f=KS>;C;&I+b.O3O\#
ZF^VS494H2CUbcR1<HN&E)ba<U7b=)FYF^PPZPJ#;5]40a,eSP]b\6TdE+?#]4K[
_>(IdXZcJ3e1XEN(P6E/J+_X\2/.DcP<fcN0<NAU@FF^X#3+=2Z_C[#^dJYL/-I[
g=;E=.DGBNA[,])0bRCf#BHf+N0\a,FMDR=b<VFW,VH7I84]J]4UK9<f1=E)@(K&
#BE0QX3-affXO__(;]N20+SSM/e-,@4LXV.a.XO(dKHAEND5:1_0,<8<d>5Z\/1b
;J=g02@^2DKZY21e1L0L@Wb-61C]TY4>;b])ACV1.;8YEMCJ[>M?cP9HSDP-K#+2
N7?>(N=N8cR<X;GDH7O:J[[I:+MZT9eZ?>?7dU\5ZeBQ5QV3V;Fg9-E0.=2;>YYb
F-2H4723()H_4\Q=4M.[g=HfL,M_.6R]TS=Og3YKQXM/H18\R=a[1S(OS^1A9:/6
45cRH;9&5(OPLKW6@YNV-M^P54.TYXVdJ_DR7IF(/_MH;3<>VT6b-a.)dE@T_]OI
GcA,?[QZV,F7I-63+4AaOC^+1TfC47#24C3C@^8BV6(Nc;<XHPZ?+b[@)M1.7(=g
6fZ-.96;:0]WUO((MF^AK-adRF/g),OZU<0/PDN/S4712H<b_K&R9#GCE+3UFR++
6=8GVYBPG[.@L_<E&7-92B;4fa2N.83OH8CRKP=WGFQ_IO\IP1C64?DM\WD3A\1;
K18I+BZKAB+)]-3_Fg_5VL5:B253,(<SZT<?ZVg^@5>AS:YO62LN4RZ<V&VSeLP7
f\+YH]TUc1ScA&11VF1-Lg&.M?K9O_#(2RTYZE/Bbe9W&U94TefUE+T(P1;\.<:&
)LLL=32dD-=UVa;Q/+P=_3I-A3D>N79U=(UQba7IB<EY;:^XYVL.L#=d[E7-&9HV
PMcI4B9JQ?O:SbBLL,SY+V+1G^YA)FSRC0M/SNHJF^?Q5RK;d,.&;L1&B>]AJGVJ
X8ICZBDKM:A@.<[cdU&+b&(^f^:DEdSd(_RVT^dgEJ@b=-FeCMO\Y>PTY>RX>c>[
/,>E21L/YWX9OC<Q4fZgcXGX/Q(GUBg^c-d3Je5.3W?XZE/a2.#/5LGA6B@8.fO[
#FI[4]faM,M8HY?4)V2,TFKc[/)[_L]2.ICSHV7JJdRV/Rc3fVdYXQf/JE9U<CH:
TOO_UF&0dW8_^B8S43(O(/URJg.4E&eHJY\]WUO<//+_D8<NPNV?TeY3bS-#^G+Q
BW;B+H,(ZIY\NQT(Sa[JG1Q2.G]PHHE5\:LGgM[Nc;5Y2E<<F/1HAcFCF8S70^\.
2E/FR4MNA82D^ZAKEP]N:YF=HS[BA8KD76&4RIF:Y4\LE(<3^(#9&RH_SeffM5LC
0]31g4]B^R1TID0RBTFa>@N1f&?/F#CL#b=/E1K9e:3((AK>1GS>RGd=]QFB>@,B
9#4ZVLK6&Y<:&F9)#OW+5^4.VF):19<GLNgBW3XHQ>DBN+bP@9&KIf@^2CU#0VOD
>aF-]T,(8dAT==G:bc53gFI,8/.cT06IFefE,6-Gc6FGRT6GMJPD+78=T>?J)c#B
WFefM/b.P>Cg:+TZ>dEBWF4Q\UB2g6_GP\8:bL)O:e.?<DC(ZZ)URIVdV9bPEK\0
(DdKOS.NPK[>7O<>+HA]PN)@,@>FOXM4Wfd8bXQ,_9MB)?I?-gCIQI#VFH]D[MLd
_=W695:40)6UGb-N8a<84J=#++SbLcW9N+M_8J1+4c1.UQUcV8Y^0bT&C/&ZDJ\A
;C\c[(FWV(UGS9SI#MgZ>3NCAD\/#4SUJ?XVg_0<P&>I?:DR?T;A/1aDLYI4R=d9
VR&7.ZI--N[2HQ]+gd:OLP4\3Y?BHTEFL(O<&(Z88E6UPY._c9MFbQ3=<RNFJ)]L
(S/X7aKK02>O2A-Z57J1g>:K6F6V21=RPQ63I/]RZ<W23]Q#gS/eMMfa3N.;&c@U
g5Hc9><T/+-:V#UTW#E=O40HB5Wa\_?_2#>YFIIOdWb.CU4L&3?O[&Yc7ASHF.:I
N65M13HaYT<ELNJJ>N4=8H?0-Td9\C(CMKWC>C9BD.a(:c@9WAM<TLK[D#T6:N[D
c32+1E6a315QL/>5;?f/Yf#Ng<e=^.DC;>XZ.B6J.R<86d6O_IZd&3U.I=B.&9P[
F<EB1G\]:M;f_GK@9dU5GD-Ec^X0T2fdFZad&Yg>MEBQ#I&ZT(+QL3Q\B-K&PL)+
,D2e<56?;MK,Ge.Y\RZH2^M6_9@H&g7OICbAO&8F]2>T#-eHF>\(=+85=4N@FOUH
NY4M4/Bc+MK-P0(?>1GUI[#1/&>OYR10fASQ+/B9S:?Cc,A/XL9d-,>]M;1La.JE
^XZJGO+gRW91SF5Q.M;6)]IF>,\a/8OYV.H.YFFS=f16:LUMcT>JG;EK6#>NJ3(#
MK->W?&TcQ+2g)a8^9R,+3MJB2Bf4(M9D_-dOFNFNJCI8EGE<@IfJVSTDbNd3^8=
JU(?a4cTVJ_7OU)EAT@R;9WC.eBLEVO/,YG7>D5L:=U[+.[ZDKE@1[PfU4.^PYDa
H,N:<G<JB:ae:9BQd^/7QaL-G?WGF3R2V4dLK7+XZ/CfS2IL^6A8=#69.g54UBb@
.SA0XYV).I]LKGeNBGOC...Rb3;(<3UaN&Hbb5J97fD346-P>ODQGd0\L^\2C2+c
eQJ2,A#JXe#F#Y^]51dC&OBW-X9;bR#;XB,c&Pd=3AX>)gJVOW>L_(X<U4Ge.aA=
E4^TS?H40-?E\RT-E?\f@Tg42+>(#f)W6AAQAfg9^<f82ZVJ+P?2<XecKcL\@PI1
8\bIT_>O,J,gK^JG>A9@6R_60I,MbEd\e=&_a8c?&AMT8PCA7;4_C:M7eQI&&(dA
@e#Bb&,NZ#+@,A_S:.9X18bF#b^&\>+LW#18>B\)A-P7WdfTJ1ZP72H4IRS3;:9;
5dCOYI@MdS,@2-IT+:X1)<bMFTfV3?=/b8/gM[d=VfPPb7a^02]K_2[f#\:I&3OI
E\5T9,7E=D@R;L6Q#PV^BUaU[Kf7BeU+:S1.L0I4a5+YQ8(\.,WE3CHYBA#-,beR
WHS?c79SN9V]#;F2B/e^K25S<M[VLdC?G/f@gD8Q<,RP<WU[700[I?BIN\57M(JB
<)RcD@I6B^f8AW0fOec==dM&/V/0.<T-_]@:WAM5@LW:.-T-J&C:>J&G48(Z<+gd
H++6(.U&=)@L&I/R@R&6D1Nb,Q;;MI^/&&>MbD<2)R?1&NAUBb7+Y_=43gaOeP>-
H9UB;#AJ1<5Q]^-KN4C&e_a<+#>:FX+MJYITG>-+QU->;VMdI)J,,\2<6;1;/1>S
KL-@N5&R^Y_eNT&N-US3c1fO?+[Af4#XgU)WY0DR24_.46M+NVUNg4OC:#ZRE2PJ
+U6ED0Mdf+V]=Xg[,CdJ>MQGgCNIS@ZT>W>gTU__YI)F.E&IR:Z)e7:+=3?PIWGa
IWF7+1-(Oe.UTR5gM_15.;-X@(=<9/Ec#:b>?.8@3:H@1aV/aOe=WD.8UggR,[.0
Y[O3JcEb@Z>JAS0:.,9f-+0QVgBT<#6E+RN@\Vc&@bN/g?U=31:dC_P01@PHfc=]
ECL1[P2@W)5CX/=;ERS4^3HI1?19IAL:D>N4L^(7,#-OP-:4L=^)#\3\1H>bD:TE
F;a(8)H\&,Y0GHTF2D@N8M88]AV-=R_OACZ8]15VNa;=/A;fAC+,\JSKXe2SV6NS
<TNDHNGFQ:XVH?ZSe8GH?_Q=f(g6<Q,Ne9+fF-VRVIdMU-32ZW&K=K[F<W8SFRNU
Ab4<WHB978V2J)<0^1a<ZHTb8@@+dJM<P3Wge=+F7TB;dFT&OGF^UUDf4?&eCPcA
+4TNP5VWUFLc=:DK@,IPIVJTdP=NR5aEJEdgUFMcV;,_Q&M6E4,0,Y:cNKCY]GB^
>1F)5UXDBZ4gIf5TQ?_A(6#?X4J\\J=T-A-YY@8(cLfCV)CS7Ce=34YULfAM1F&d
dOb<[M+\Pd>U+e7P#AX0G)A)3W[,PFT2(YQ4=@[T[E=WF\9JXZ358df>+25MVPD(
:@<M?RT,:0_g3K=R;^>#CEF;,54T\6_4Vce/=_7eTAX?JU#BP9LBbA#<5;&17&aW
<GR6@Q3\<<cJBe^8KCZ99]AKF&b7E4]__c8T&OB5S91IX>eVb\4_1887<BZ>X4#7
TDHB#-.aQK935B\<+;PbBUDcg/ZGWBSECPD2TdVB1UW_)-D=TdND/eF,03PY?@\N
XT)XY3c5fEODTXGMPd^1.T[/a[>KA6R&&;Ya(fTFI\gK_&=[?7=LC(&BRY,)@g+^
F#G94cF2A+g&&GfWGIJRLJL-CDLI_V(J__M?TCT9,4dS62QDLOY@IOZ4A)BOZO\D
@2O[0R=cPD:AF?],,eX.DE@D>R@(,,9.V=;@[0)KI_&>3(H1e/3Yb-P1ZQ6@O5J9
G4eFIdVVFW(3A5f:\dWCcK7FULRD\Fe:GN>cd>-3G3@>PX<)<@_cJDPa.(5G-/(W
LeLHID/4ZG;BA&F[OTA6:47C.TQ<&c0I&/P2_e_/F3\c)B,MBeK&N#b8N];:]IXI
bAFOC;=7LX/N;NS.7E4B0OF#0.DK/,?#2,10LgI+])S_ISW5^O9\NSCCLf(BRQ4c
.LKXT_NO83N#,XWV\S;CT1c^EHDE,;/gA?A+.6.+e&.&#e7H?E7?67fBS5=I&AA?
U;270?]b>I,I2.-[cL^TQ[1?#K22R6U\=bN_9S5-<?/eY@&HA(GbD0^)-XJ3Q@<5
CeK;MVKCd(FJHdVF1?]<+ZU=39(BOR#L]8>9T=WEDEEQb0cZ(_fa5YcNYNR]0O3F
0:\Bda9#c:(Z3J@W-W_EALU?EY(@XKM.&Gb:31Cg@=DKED3VM>2G;)8OTKNcQI+Q
JGI+He-L]#fUJF)S=)S,PZaNV0=LdD[O1NP.UTgadS4J,JRdSe&g9I)+=V]DWA3>
RZC,Q;OV[N5P_9R;aCQKW:TfEeNGA^++V\+Q5#^@]^?XD1V40_P<_aT(8eLYO@f_
RG\U/TQ&)PV84dUM^,Y+3ZLT,N+-+)/)ea_SINNZfbI[^Se90AA48-.A4_H-6F6,
KWIT:dWKP,EPA+7[eDcI,JS6G1>&P8e44O[?_aG0,MDV#;A#>,I0WR[I\@cZe<AS
5EZII5Z2&.7@.>5+O//b+c;>#?TWUN_dD@,1T#,MQLC5#UBBCP9^.)QURJ9K3)X(
SA:OCf;6.8ODE+\We?BCF&/)+ZAQ;^]E5bQP3?W)fG:=>B0/0Y&)&@caF&7GMO+e
E7=fX.0S/0PPM1:JDGW:,:9:2QeBM4]G[NO(+\)<.L0RZcD>9S+ZQafG@S9SPWFR
#J5A(++8UZ3UYA5QOUd4aFHcERb:^0JYE4D(K]bZ+_6g)c(,J34gI61JRa+Da-:#
@R1gW/bZ7B>ETaAGC1Gc\a/-H5b6.+D,[2aLDb)YKIOE[PaQ0F-GSC95aYFeZFP+
;,^CYAaHJW>Y=X+/]feXVKe;&QK:U2RCGA@;HW;<5R4N^F;>17;AQ8W^-G/a;[:/
S.3I9N^71H4IZH+<ZRNY@_?[X1f9G1;0],5CS)JR>8aM\3/GR#??>Z3:H([d8bL=
1]8Pb/Y._UgMDbYW/B7Z<GL<(+<1[JJa:9X0YEJ+f^:>L]H]1[VU)\Z62;)F-]VA
\M[ee0M;-S,eBG/dL??Y:35Je[J+gHY:SLU?_@U^8TUOR\TEE63Mf1DX(<B)?E3X
BCbJ@C4]-LQ&6SdaDAB9f=(\<(:Fb94,ccKW1e(AOS2Xb?TIe64R8Yg]2_3X\?Qg
38=K([18T2JU#C5c?35VDX_I=f4dPZOM058AO)JNa>^18f/)b\,f9A#dK0d3::)[
\N,7PR[e:L+BNBVL4aFfR.^_4d4Cc:Rc8=AYQ)E,B?fV_CUH1DF=[AdFLG22bN?e
:+XWDISWMbJVB6b<g/8?eVK?:PX68<M1,=KQPB+DGIeObWP\0eP>GR50FZK.HN/E
a)7+Q&Q)f]?T=4)51#\KWZ+DIXDc50/KE20L5:RRF<EEL(F<2D]gBDR.9;2<>eBC
6aH:].5.[PB2J7fW>e^8O8XHY2)D9IACAHZ?P.I8RVN4MA,1a6ZTM]d=JbP:g_ZX
1CZ28d.3H,98W25Z:U3_XC]Z?4DV->QZcf9If(aN_URf&6+)FM>_0O]F/Y.WZ[Q(
.#&9^Q/-,>1&HL/VaHBI^:I7.&2.R<71&6O-(],F?X0WeAK4DJ\dR<Rb#3232(&<
^IF1K&VN,-S)WKNBWc/,&^=F,\N&cB@-f56^4P9eACB9;7c7ADUR151Wb6:QWeI[
M9L&Z/&SAf9;_cT5De9g)C3ZIZJ52^-^gE;16<CK77NHXK7E8HM5-K?N+Z?A]DBQ
@<c7;gPEF63#);WF\6:b15?+O9MKWIAZF+T08+2KF>AfLZ?,&:6VM_UQT+d(Y4]-
aV=E=7BO\0/T,2IdN7(?7J>-779Q3.2J55PC0D;;6W/#&X2/LP.?Q;JZ?OS+2^Y<
[2Sf;9YG05YdM@K7>;QJSALdXSG/Z0@-@J:NDW]HE&[&cbL[+S^C1Z@66NX0/H.H
aY\Sf_2UF6,T#:AP,3T(1N@HK7(T/A=ROSc[;/,8W:_.3MAbC-JCBC_SN-8N.(8b
cH2f@8.^FLBD;PNSC#^BAC_I6aRC,18>>8-OI3R19N<]E@49#<<9,EZHFZ159WSI
BO@ZC8=@?>)]0FQ6)H772e2b^<cW2N8\(8_JTXd[)JM=0#6T5Z:#a,NSUU287ZCd
T/_+RG9-_NOX7g:=MHGa)>&.5Y2D-2LKdUYOQ[E(deZ=Q?=4^3aF8c?L7DA,J-,[
&/JdLI=R4:\X^Q<eACEDID#(:YI]^,N,_R<N0MTTJ+HeLS2&\>M-.C.?-&H45D2V
cC[2018C&Nf<P_&3ca;^OI.F0-;):R1G5I,]J=ZJ0\DO(V1HY6;>(QTYFNVCO]=N
K46()<F#,5(8/F>;L3_>@X.?DXN/BS[+gVdPP92SB65[\Y-C._EEUAaf]QXR=eL3
E?+7A]904d-f5d&NS17/=MV)7RLX:^D-@>d&7Bg(2MC=bf7<KJU6fZa9]+[==4&0
VN=(JPFeIb<4K[P2]c6=_)6Ka/KKXfQa)I5fU=OSccaAMD)f^ecA#:;-fO=:Y>+C
_bV]2>T5IegIK6BP&7U4IJdXFS#/b,L5J8BZD05;LXV__,<B[P@Hb71B4e-e(1[>
A-O=[O6@Y_aa],.#U[f&;c\2BXA.0M53L[FF_e8OK_dM/T:OFDDXYPR>1C[cF(BN
NWdXO06A\_4+4;??,MXL[9DgDB;ZUO+c;#dATY/M?R;[PcD82H2=-D]C&,fBWD#D
-^<;]7Y3RS518N91?d-5faFY(<-M0L2)/G9M\4T)H9_OPC;M#::.P9+-@1:YOHPL
M:RdD9_M/a6Fa4#YL&IO&+7O?5DUXe&@VZY2LK>9V=VA=dHVQ#BZBIJaZbgI5M-]
OU?BS&KF1_G,gfR3eNT.F.P:N6b2T[@D9/RL6Ra28EJHg4:3JL20Y\G89?>?^PdK
-@_57UL[_H]adMSPWULR_?[F.C^(OBbHE_O(e@PcNIfO[:;=@(Q:M;aJQN@bE1>Y
b)NXWS^]cg+0_#(J3A.&SLHL:\,XBLQN+BFL68Y&D[[.c6YY-XYC/ZfZTU,?^?SF
)McL9a2<<aD\\XdDaUGMeFM?USR\a>26^)GU<+aIYP>[NH7J<SAC#9Z&,1b(84J9
]GUNR>H<JOFD<@1\+G_?D>]@?)Kc8#)TdC_.2^bXVNJ[XMdeSES\;Q8#J.K>UH<=
UV@MWZFeZ0-.[9@6[U[&,^Q>Jd)SZYRM3MU_K<EW:U]NH9dUD>E:M_S2c>a:])U/
,Z+f,65J+IR6IH(_C\)c]dF:N&.K<c:95M:N;E;513&cU3AAeM:,M5/PPfHI6#D2
PHK?1\57M@afKZO+]JMI1@OSIg^EYI;Y=QYUV_-E6AWG/48OD9N1NaAY0CfbOYCR
&[#c<.-VD_87JQS(LgeN1QfLT-U2E&_WSZe)<PLGf2c?7DDaV8gbMFM#_DPOF/4Z
KD9eS9C72O0IKO(TVZGd0T5I3>GLXd\7#D?-(I24;^\^2P&.C0]5@UK]2UJ.4bVU
dC=YHI6#&1GUQOQT?Z=3AHS6WMGL5)CRM3\-+L[PJU@]E]@K25RCQ;,eA7[VdAK+
)C3(g(XP1;>MSOU9JBcQZa#S,f&P.;<+EN_.38N@a=-Ad4J_WcAdgBe3/?SPXA&(
F[8-3_(Z#XTKZ2b2WAEA?;[=@>DM6BU+OOY&D@?;@K#21JT#H-dA(A\7f6?g_.L\
](W6d+IL]UEF@;+g<EX_Pe0ELHJNRZ+Z]J/-eXN<<g;0(g.U067J(0W,>WAP7DQ)
0P?HQH2O_7SJV-Y&BAH[:=dYF;_VHM:SV<RYP<aKD?B86_=8Ba#4+7L&..\&:@>(
K1Y;I11=&eUN=XZCW]]S^Xa[]9OAKOb7@?C<9KXBVIKdNQH[D)ZWO^e9/2Mc1LGH
0>K4R]_+R5-XCKBDY7J>)F4ROR/G1d^>D:4L@?P4edd5fII@c_HQH@SS_IU^0\]:
L<@UAOHa/;W-T#GX>aebRcOPJPW@^DIM84^S&g2>R)R]RN<C9?ffSB=O1^X]WO#M
A_gH2,cXX_Y/bB1a[(WC\C><AE=T;)0P(O3ILM3c.;f)Fg.,U5@#D_VPb#=<RLB7
F-<gJPb9L4KZG(70g?AG0Zd./;a.?J2adH^QF@UV0<9UOKXEUb-VKU>=,N^IV+8F
8VbKG3].-,eD_X9_<b9Ee43]?Bc)4HLJ;N6H_^a&:M(N5Ie/L#9?1P@6WU0=<,F:
fa,T;bMD]PR;YSM8>@8J(g=W?cWKB<]QFHMC+J&#Tgg9ObP=M6)T[YX\Ga?DfPgQ
>B2^@3I[9Q(.[c]_\/S>f@e7BbX]BI,3N,FSQOUGUKF^NOP#GW]D9MDfRQ-8GR.8
5NdY8SOc<ZRXO)B8;=Y_6FB2];/-V#Og_ggE5D]cF^)@D)D_B,2==\G29cXQET)L
_/7;6RQN;9RP:_63K.K]?C:83.X,#_Z)/18</T_O^Nb;TH9CXH2L@S=C.,T(O?N7
fM&9831^XRC2[@8H#=MK2_R9YMg[&H=KdS6^FE<#R>8R#Gb)Beg<-e1GM;39M7[e
4bW/e=1Z/Oe9_&]E.5X3<#O@/=?XN7P?ONg_#N&eJ5P3X4-C(B14@f>_,U[=T_XN
HdTE+52AFaO<+]SO2Q_;;&cK#8HDbb.6b;NgVccCOHQ3U)EC(UX9(E\1:4M(N8E3
U-ac4WK[e/N>N^IR1SQf6:QP-,GeN0U?-c[;?5.)<Y=O=b(fS&]I7[d0=/gbbQ\d
,a@2Ab17caKCL0[XV7)]I;[K=-Xc<8GHHM53)2.RZ)APA=HTF<UGJFW855&b,<-8
QE(EIW61Jd=g_50Dab6YP8HQ(3Kc5<A2#V7f[87,(b;/\;3TTT)K(TE7O>IY6CL-
\V)bdX;dSI\)._gBbGfDMSH22GH<2/<R?@6.ASF&FOgae)/CZS2RO9F;PP4UQO3F
M#P\4O6:N70Ab4g7^G:]-<_P5bM@N+E+D.4/17O:^29Qa_Za]Lf>\DE):I1b0,N7
W_.]Ve;]]AKE9DTC?fS-#D_>O&OGBTa#]L(gFScW7QF(bXI^<;:@V?W(&1MM+DM5
N-,^]T:fNaA(,\5[E@A<=G)YV&KZF#J5HI9[U(W11<f4:DISN=L0(_;?8(:()C9M
@DLObQ.KX-dM?+cW)WEGOQeD+FfXBOH&GR0^)ID(+H1(QQ7?Fb@Df921=B9I:WX<
IG.Mg#fD.@F@?NY+Y>&@A9f^WUWU[g:fPea=,MJa^KN<f@IQFPB&fb2ZOdH[OZ70
C1OUZ?ACYE55eM)@bX#YF>B>O(OeG5605+/CY3e.K-[9gUeYKfeJd>MN7YdM&#2>
gg=:__@97Y(#&RS6[J,@Je#X(W?TPVWGV7c7^ff,+EP1T1e^36^,WM=,Q3?1BEBV
A+G@.&Cg5aGMM</0M0B/T7HC2<;5FXfgT@HH&6@Z./=f^1e22GXId:7ZXL^T,3>T
U.93UCMLS^dF+(@\fS@0_=bAe?TS<B3Y4)B(-WY[_>cZ^7a#PTBQ7VV4NH#_aFbW
3ObFC\XX@Y]1,]G(W0R33)Ud\VP0DI<&5UPT0H1.]ad,d^d#c-4AbA5:8Pe8CU1(
<DUEI07H_@\be+4/I+bE@LNEVOe+c<#Jd_R#S<8>J;b=]17?=9@,O5NKE9[ZJAB)
dQdB1J^bL;.b=F)TKdD3d-7+[DbX<PeIDO:G:D>G.#&></GA-29K4&Z#G@;D/]5Y
g+>-)dN,8&QA-Q\JQ2/U-E[OT)/FA5+2L;YEfYX7=4F9@SO,edg6,&6egeJ@](ZU
deZ(]]&+4:a<Jf16S(ITYc9E70MgELSFO;HO)b@F0d<.G)afI#=E0&Qe-&c]&5A1
a,N7SF)VO]?Edg@9>X@f6Uf&YKOSD9P\N^=a5LOI]<dW,Q(V6KHL1DNTVg1/T730
)1W<cSH6Za8=-J>X:RK,2]2b&B#eWGY08#@)^NNKG+T1)XSMWK;&D2H.dfFJ<^(b
>;O72Ed;@E^-6ddcC+-DTM:97[D2Na-]<=8OP0F^=]g+MAYU\\/TbJ@R)R[JTZTc
f+L<EY[O^2>ffS+;UcT;4P1=NWK9#6PEZ]4B/f15EF_?Uf;Q.OGWPDOA?P4]]gB0
YcXK95S4ZeZ@#82(OUAde?J3J+VKY?MX94FZS1[MEcE>f5/D//((R.TaN;^K/3^@
Y84/6L76M[E8dDS^&U;fG<Q+79TW=f#;d/?S@4&/_P57=ER#GX]HI:BJ()dDQ-Q+
0V<]eO_SW,K2</3MW9QeVDR^#O)Z[S[H3.U(>SC[V-J>];^JV[3H_S-E)G?^NA.B
=De[.Z-T_;Q-26\Z@,DV>;[;]=&NUNY-e29Y<(/>>(aR51XI9)]FK-eB,-b^f;;)
]52-;X<EN-(-K7Da=]M:LE#,:#8e=BU?P+X@WMUPdU,71b]KX<fQM(J7L7YgVe@.
c,LWDO#W>+JZTA8\@8K_1[6RYS^34F<UX;^.D=PAN1+D57K(DFGH1(_><L\2N#=I
^9-QA,0Q(G/HPbA(e;+#EPFK.3c^&g96dWV.##/Tc=(\:F8SRF\VH7N4cOFBBTcd
:35VBY2HO&S2M67BESQ2ZR1/=UU18(\^d6+QH)0F7T16bAH+>-F(T]Jc_&+:g\V5
MSec.R@Z=U.D?2GIYfLFKIL)&9b())N:Z@JcIH8-Q@\/1)?PTVY.25;@B7A9gDIH
FIc_[M]V=6S4K0AR8Lf>/-dd=caAVXX7+P-XFU&4WDZ]ZM3XH>)ULKMCZP+5=4gG
FX)Y#E<-#4A#-La32]DRQ2gLEVXR\RDM5R1VSP#NgV3Mb47^]6;/cTRe>@(/;M&7
_(A_5?^U)\R)GWERQb;6NK&@QeE-e)XC1QN&gdQ##5d#;V;ePR48?f;0-9M;c41c
J?fF>R\6<TO8S5]<9&N+g@(60f5X+3fDA)D)[+f&1[9d3,D4Y=^XRW)7E5UE>&<Y
V80:QL_7Z-C8^,47Lgc^f?[T8deJEg_0?P)K4B=G/15,5a+[+J:IS6]ZETSd-1AD
LS\^PJ7GX)7#GJWcT7+9CFO(7R9RdTNBWYPD.U8B76INPY\RS\1.L=GF4.&ZS8@a
E9)#D29BNc&1OKfBC))1,Y3SVLUUT&[d)30Y8\+B0@[,\W\WB_OQEK;1TSW]\T5H
QNP-2^P;BVGB0SD&[&R-G988G9V-EB9R&9U#=gS_1_E9(?V<a?1K6K(EJ_FOA:(c
@MU&9.66U?4M0-TUHDUg_Qe8.A>NLVZI+F6P7cOB?6^(9c;MZUHHdF#ONf?B8VGT
c9]+^0e-\MYf5dIXOJgY59LV;ES(9c<),V<GULT\<]89#gQ(?aG;-,b(gU7IFO/I
VWY1KT1V/0V39NS:Ca#8Y?9ET;J^=(K-R8;^R/,0d.&P:A)]gZcQaA-,NQ36dX5[
#ZHH&QT2<EP/TdfBF;W\[1:Y=G_@CJ[P3+;B<(,J=\0KGfEUEgOBSPJd9e6Y[fMG
a+[J&)_Wc#bU0[f]LP-V5=0-[c.fFF#WO.R/S>-ZT8Ba-4X0,XUHCG<LOMR^^Ab.
6??IU8.?V)&U>CAY&P7VKQ9A)0LB9V<OgB<\7N8]O[,79+S(]8fN.Hb?#X?F4;?E
4YEU=_C9-4GGX)&?4RCJJ97Y:g[[D(O@AEUN&b5U;gg?feSO7(+D[8bcC48,Ic37
ZTe1[)MF4+52dSffNIT46aD<6Y^W73_LV1)_28<56)NR0^VD(>2\;QSXEcDE3EBP
)/_bb^Mb,JN9Y0Ve]?2(Z9450-1#.::HX>VBNKg,^E+R+:>T0IBEP9?WZ7K[ga;2
Y)He_S0cAR9(Z_Egg=?2#e,P768dbA1H1+0dBD8-ZFJV^FO3PZTNMBH/=K51@f:a
eTbPO?CUIF;ZYDgV9-K-R:_g#bf;D[HDE0eD@-J+099Yc::1_>g<;?;S])?bEVPK
9#Y-:V=cH)0,,-f1cD+0:JH](;2VTReU(AHG[MH?X5bdDV_W=b_]8P^gJ9L[ODG_
g]@=aZLG9eR[-57YY4FBeB9(TUfZC3=N0g@\1<6bLM#F][E]@#GaXJ+?Y;+Y;:+J
#F21bJFBc9dGHfO9_d=(+RMRF:Vb2NB9O^Q-\,c=O;NL:KFUM_P<+:3]EKYJVgCF
^J=SY4G#84F;6e,EO7Tc#95L-PHWM^5Y#GfS:Zf_[c\W+KQ6NR-PB&S_[eK2R_5+
F>FIR7V2Nf\3(=&,3V;6b@AXAU04B_FT3UEE2:7DVO+-#)L6294_FV[<8T6Y[6D1
TZA[E4?HIJ(&V>R?0K>_[dO:/>Ig[>g&W?<O^<Z\O>T,O?5,EBP8TG)-fIC4(=<<
),[@GNTCPd<:5_I>F=M9Q4B+<NHF[CBKd=)N<1EAa&\eGKT(7&OMB^>UgC^594W6
L\c_K+_&HRBA0>#:D]-e+JVG_>5CNT[^d3\>VWYdIdMg4P:BSb&S&H,XF0J#5fM9
bYY+YJOc1:=S-TZ.8cA-XP7I=0d^UJ::V>cG-C5(X^RS/5e=R1,VCb01F578U>KE
J^:.-^K/(C):M@TZZ=K-0RPJCM;6JYIXF.D[P=e<?7K9PXaNUH41OF;[X,b(W?-d
_DPA;>YE03dG<&Lg[L-be#gWT9(>FR/4IMRIIX1F5ccB5\C<V&;=5WUK3;8>P/_H
\^9[^D5Z8GZReYgFd&3A88bUJ#1CJ8Q;\HN/XA=6J&.&L<T7dR2JF\\g[Qg:I)WC
eJ<RRB@R[X/P)7L+cP5cV3PcOYc5EU-^95RgUZFOPLSG9/_LRGScRSTV#(XDb@:g
P5E,/;T7]H-0&3dE(F-:-DSEU.;\,CX&dN.9C\YBG5J/c=cMUd@N/5+URc<gIb?=
H4(F0.63\.P6B]Vd\S7]\PED46VE8VB:QO)-d_D+NTLC5MN0<UfM4@)NOcI(@HF2
OaQcNJ#^bH3.+I,4Gg28M]0gA_M68Hb&e;IFL&_X0[P^:#1LFSH\1H<f7c\;7ZI@
7LOANT,fT<b.bX#9AB8(7(#eJWD3F(YFK#B+09[+=eMJ:53YN)fB=6E(+e&,@(OH
RQcM-];7&U-WPKX.O>BAR/LM,O)/,<@+A^_3Xa)T_2X;dd=Y5-VVRH@1.<<JD@4d
FA)f5P+E),FD/3AUJ#ZA4MRf?QZIZT1?;NRGB0KL+b<C4d7BEeH<9,G6YQI(.HW3
Qa5TDa,a8?R6:g>>1/C\-2NA-BM4=TeSZB:KcC[I#.()(aSBVVQT.YC#&,^A5b<A
SXUBOO1X>AUMQS2BYOM&LEQG9([+A:<JU]L865V\?\R//8<8T@G/a<4E5>S>,bfW
1@)3)OUT3f,D[Nf-YcCa+[6E,EPD^WcMA;0/MWY8[ebQBNH(2eba:]NbP5VL#/SF
7&VKXb-#.37&#;#X]\@<_DC2^c+Fb\_A:cXa]>)F@3AN6;+@()-E9-(^@;UbJ_SS
M,2dcQFQV-DGR1Mb3+fb,EF1O^;/;N:bJ2)WWK5#P_XN.TT43?T14KKKL7gY07&-
):d3:(HbFgL6IeVWXA+:48#TFL64](3]?OFZ3.\]NJC(D_16]c644ID2GTBG3^NJ
W_(7T+>aFD8F8b]EV5N],e4ef^:ZgQJH)c&g0a(B30A22+d+;>3VE:R<L4)3SHTe
[/IggKUR[7ACX42_c1AOHVd@(US426bBTZR;@2FgKU7M0EWE_9F,AWFO),]:7A6[
7dMQ,=#b=:AW;cN+8;FHa#)f8X\FM@;\9g,]69M&D).70aW2GH9>PJHHSK9M;YTA
Z/(-K7T\\5A6eU:C0f9Y0b\+)#)/)25Q5I^2:9-@3A+\+ab-X#2WPDNVVQ5-3M15
Sd8c2=RBG3g]P8cZY36D0DM=IO3(.K=+CW2HAH&53L;-3g20+E&E-AX([>,N=YI1
=65SLS-B^9I0JeD\_]b]J7PdJUN_+K5..B2(f15F]\9@J9?&gfE=K?aKZcV8M.]Q
G4RNNIe(bC8SgJ/=bJcLI7S:VHdN#[dRQUAI8O=A?CGDUP>5Xg5=BW<;KHGLd63V
a;?6(:OTd;cV(GL^_(QIW;>3A(OV\RBA:?M?=Mdd_MTF+H[+aN.eZ7.3ZP)Q=Yd3
)M6>XAVgVb(^8U?/)3K#&KS_XX(f:^#GE=QI/Z2(E),=aQ)&GIS]+)H@:8&G\?e1
EbUFUCE4aW4\39bUT285a-RL+GQSPS\SAT#]5=E.L/T0Z@E\df9F?Qa8&L?U4^_+
6^a8g&CP/@M-],IB)[1\S0G,S4Ra(J:H_<R\=I7/J;F/(T;DAeXH=R7NHV8_9:0P
81_BFWY?@BYN:LXZFSDS_P3V(GUG?cQB<S97:J<BP;<]F#IH3_JgBLL=0+#d+&LK
e5PX653BggJ+Z3(BK)eFLK8UE?(bCA.ERE3I9DP&-?TQSOT=Q,KV4W\IWb)6@e=C
26LY=7ec//<N9Ie_Y,Fg418]&6</d3Z:#HM1NO=8S2>f-:MQXN/=)aAH#XBX<]BK
RBA=D3LK]@b>Z@W\#:L<GZK;.bLRTaJR9\:IG\.&3]\fF$
`endprotected


`endif // GUARD_SVT_PATTERN_SEQUENCE_SV
