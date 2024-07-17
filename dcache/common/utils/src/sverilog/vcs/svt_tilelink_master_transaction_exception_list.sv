//-----------------------------------------------------------------------------
// COPYRIGHT (C) 2016 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------

`ifndef GUARD_SVT_TILELINK_MASTER_TRANSACTION_EXCEPTION_LIST_SV
`define GUARD_SVT_TILELINK_MASTER_TRANSACTION_EXCEPTION_LIST_SV

typedef class svt_tilelink_master_transaction;
typedef class svt_tilelink_master_transaction_exception;

//----------------------------------------------------------------------------
// Local Constants
//----------------------------------------------------------------------------

`ifndef SVT_TILELINK_MASTER_TRANSACTION_EXCEPTION_LIST_MAX_NUM_EXCEPTIONS
/**
 * This value is used by the svt_tilelink_master_transaction_exception_list constructor
 * to define the initial value for svt_exception_list::max_num_exceptions.
 * This field is used by the exception list to define the maximum number of
 * exceptions which can be generated for a single transaction. The user
 * testbench can override this constant value to define a different maximum
 * value for use by all svt_tilelink_master_transaction_exception_list instances or
 * can change the value of the svt_exception_list::max_num_exceptions field
 * directly to define a different maximum value for use by that
 * svt_tilelink_master_transaction_exception_list instance.
 */
`define SVT_TILELINK_MASTER_TRANSACTION_EXCEPTION_LIST_MAX_NUM_EXCEPTIONS   1
`endif

// =============================================================================
/**
 * This class contains details about the Tilelink svt_tilelink_master_transaction_exception_list exception list.
 */
class svt_tilelink_master_transaction_exception_list extends svt_exception_list#(svt_tilelink_master_transaction_exception);

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_tilelink_master_transaction_exception_list)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception list instance, passing the appropriate argument
   * values to the <b>svt_exception_list</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   * @param randomized_exception Sets the randomized exception used to generate exceptions during randomization.
   */
  extern function new(vmm_log log = null, svt_tilelink_master_transaction_exception randomized_exception = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception list instance, passing the appropriate argument
   * values to the <b>svt_exception_list</b> parent class.
   *
   * @param name Instance name of the instance
   */
  extern function new(string name = "svt_tilelink_master_transaction_exception_list", svt_tilelink_master_transaction_exception randomized_exception = null);
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_master_transaction_exception_list)
  `svt_data_member_end(svt_tilelink_master_transaction_exception_list)

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object.
   */
  extern virtual function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_master_transaction_exception_list.
   */
  extern virtual function vmm_data do_allocate();
`endif

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Compares the object with to. Differences are placed in diff. Only
   * supported kind values are -1 and `SVT_DATA_TYPE::COMPLETE. Both values result
   * in a COMPLETE compare.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Does basic validation of the object contents. Only supported kind values are -1 and
   * `SVT_DATA_TYPE::COMPLETE. Both values result in a COMPLETE validity check.
   */
  extern virtual function bit do_is_valid(bit silent = 1, int kind = -1);

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation. Only supports
   * COMPLETE pack so kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned byte_size(int kind = -1);
  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset. Only supports COMPLETE pack so
   * kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned do_byte_pack(ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1);
  //----------------------------------------------------------------------------
  /**
   * Unpacks the object from the bytes buffer, beginning at offset. Only supports COMPLETE unpack so
   * kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);
`endif

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>write</i> access to public data members of this class.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);

  //----------------------------------------------------------------------------
  /**
   * Pushes the configuration and transaction into the randomized exception object.
   */
  extern virtual function void setup_randomized_exception(svt_tilelink_master_agent_configuration cfg, svt_tilelink_master_transaction xact);

  // ---------------------------------------------------------------------------
  /** 
   * The svt_proto_transaction_exception class contains a reference, xact, to the transaction the exception is for.  The
   * exception_list copy leaves xact pointing to the 'original' data, not the copied into data.  This function
   * adjusts the xact reference in any data exceptions present. 
   *  
   * @param new_inst The svt_proto_transaction that this exception is associated with.
   */ 
  extern function void adjust_xact_reference(svt_tilelink_master_transaction new_inst);
  
  // ---------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_master_transaction_exception_list)
  `vmm_class_factory(svt_tilelink_master_transaction_exception_list)
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
TgS<)e9VfcbVe_V,-:(.PV@B+RF3^+V)OR4(IU5(C>,(?CV<de#X5)e62U66ZYeM
Xe?NI6#XHD6,Z@fZPdC01@BV(4VGWAAV)/LXNSMSQ)XWANKNeJU5Z@LCeG,[],Ha
>A(@g^dLV^V-P9e_8[X/dL.RP<)K]?.HJ5eL4C.KaPNBB>R?T@(8MMb,+\Q7+/5V
>TJ^\YCZ1)g)#85e<I19R:g@<-R1&JC&&//bZ;IJ]Z@/7N,B05@7B?b9--1X9A?0
M1f,gM)cc,fAB]JV,<=bf)QW0]RFOFV7/>/AO8.B(c,6W-eR1?R@<[M:c;JEb4gD
;8,^0])D\#PC,/4_2RVX)1+WdY\W/QMW/+O<)Kf->O[.5:?3K_ONSfPT(=U@-[H5
Pa60THJ7WAcQ/CW_.EW_3d6BL:#2^86.XF9.)1(PD<8]KNYIYXY5<_NMR4:3Fg+X
fJ[fWXQH>)#<MA1&9&AX0-IY[d7Z9M1L)/0[B1,bW7==cd;df]gc7_cI,D?,PR)-
O/9TITgbNdCCd8-T[=;/J<Je743d/2@40+AK++Wa71H@F]1J5/1f?7-d\26<?+]R
TGfe1?e&Q>7Zf.6>5[g(/A9N;CO2XXGMWWa,/9+g^7#+c\=dHSI>UJU+]Y_8>\GI
K+Ad]adUd9,:d3^Q#5f(C?0\V9Rb-8AQ=_5d6eJ@\H8:)H:Og,ALaE1.b03^eDFO
N@bL:+b0Y5?-NKISMeYNZ:D:8K@K)4c77TeA.T#^&&NR^&=PQ+78S9J<>:U[7M4P
Me=EbQgdYeTC4J\#N7+HRLS:UeZ+Wg.TeL.O035dD13LQYB2[IgLdZX/f+>I+7=V
H+cF<EW]b&I2abL5:0LP8cPYP4GB,B9S[\J19Me1b(9F,-F(-W>ZCHFBd6DO#]FU
8G\=>Y-=^0UU_<eHZSQ9)7f-/X\3dV8KBUcZ/JIb7G38e63J/YY=f\Z4G\E46PNB
G@85DLI-_Ma0Ob=XY/E<_FAQX^J=;]eL,H;E-JSY/C@?UR;a_>:-&BY&0ce3P=f(
(#T1JPTYAL6f0]QW[(XGJ9/+OFD.FNE&I)QUDL&b5DQUN@:JCHd7dC3QL?:3W@G.
#&/P<NPLG1ZNH)EJL(XdJ>fW:gG4@.B&8].6Z-PcKIYW&C@(_f[-95fW:&cbX@CN
.LI]e=4[-TV2[)\c:EYC+ON?Ue7T1:X(3XM_g6-N4JgTRUMIHa&X5N>LB\f+,ED1
b,J7?ZQe&J)a:[9RC,]RddZY>YG2Q.cTGgc0FLVc:YHXT2aRgaDJX9HZ5(9]-3dE
VFQ,g#cI9AGS0U;SaeE9XJ-KP0]&VU6#S2A2F>fML[Pb&P66faH<)O[UT5;HXQVIT$
`endprotected


//vcs_vip_protect
`protected
2_f.L?PHcM4eJ>)1_=?S,)>^#@9d,#caI.O/J;A+O#@>8^]L@\[I7(NM2[dd0Gd:
KH/#7VJGAM2[I/0<_IK5I0AC5-)93<@Eab(NW_NbFd1?@R>/Kb,8LfIRVV>a8A6;
g?>d1ZK3X8K9F\F#=PF_U)dRgaA<-&gZ7N_TdC@6/JXUOE=/<NSOV(YJ(bT0FZ0b
4&V#VZRe@5OBdN+bL235_K,c[?B1+)J2JZg<)GF/26daY]1=J1?R8XdLWdg0?aG)
^@67\U]+>Y&dI80cOc=@UH/(-bG8R?OVQ]3AeHL_/WO96.:D.;D:R3OgSE7T&XX4
g=;<WH=38-G3a=^a6?Y#+NUG?9f5HF5/>N?BQ^Q2TJFa[JD[7R.O&([FF7M,N?S8
=A#T&F(IH8PRFX<QQ8OLFQaV.eQ02IE<EZ,HK,bV6Xa3:]db\.S3G#&aFEaRg@Y4
159dKQUBL\)3?[YN:(eMZY(#HR2BAA/C>OUUE(^E)2=],KNc<0gX?JEPLI3Y&fZ/
(FV1NE9)UE]BNMH6<EGcd)OGU3aM98afHUS+.X)-6_?gP09_<cXS?FJd1fW0b4OK
RV4C(X_C>G.V\>SK[],4L-cGEA8WNPQ@cE^dWH0AZ.XVSceZY@N@-]A3F)4/f13,
QJ=Ng+Q68SY3#@OBH\+ad4@+JC.B=8VNBfG\+g]LH//a2bJ+0Vf-.?Ng0\]J[&SM
g)HBJ3&J6)K#1eOED6U(T5Mg=4D9763cK]FP4J#cM[()+Ha<?(4GI:^GS7C=KT=S
G9E)?</5IM<\aVI#)8a)-E&#-c.,W)HF;OLN_>QRdW5Y8K1e&#A(5@#CU1V>IHMg
(I#C.Q>1.6ZF16b^8E_9R,2)3b?geN5VFT99KdE/3eX=W1805=5L7Xff+O[X3O_5
?--.QdZTa#XLdFD+E&a9;JfeL^&@AI&2EfZT0a&?d2-6;TT_\Z2IY+K)0FT_OdZM
.FGL\U4#VEZ]5<<R\/a@<+[Bg+F5\KL-6JCdJ5F;R>Tg2GQ1T=M?1g0&,+4<M58;
K@a?-P8RDD@YXaN/&M_:D>fQY;Oe)OTJ.fEfTJa^0=YO0;1HeQ<@.UNNT#2(/>C#
/P,;_B<\Lfcc1e&7L>N#T[^g&/cdQ3AQSc-?Y>?^f<YSX(88NL>:aE5.16/EXP4/
O_0?+J0HTK)\WTFd8TQNU=SY2XDag&+\<C#5&:&Z?Wb@_#/Hd0)-K;3,K[#94EO&
2HMbU24^2Y45dV^@@ac,4JdQ-#7_f,()(FXC4gS]1+Mg0//,b7O0+NV3\\4B=6W[
b1WY<LI?4gTAU\d(E,F42AI\ZBbA?8AC?a\gBN5daW>#(P@4bVe?cKDI/ZLF#.[_
Y[a^J_J/R4\>R2Dg1F>XG>]6UU1Ze^,[V>A]+1UQ))1Y;B3d6/]?@8D8^4#_;^8D
aKSZQ8^#eU=U?&(9QS0;M1Fg>1FG9.fZMO_POcW1](/ge+0_W(94;<,E_(d9f1@C
ZXOX\=3K3<XH@)Q)U_E:I7^M?]c;41/X;0N[=/7M#_,SV>5S1UWfZ;XGYa]a&2I;
7U0dD.#4UF+U9Q[C,5_#Sa1V4&4K;\+0Fga-^DA.5E7fL.bB5;YceeSMOa]g3>(H
N4aMcG<F^AWC2_G_#LB-Q@bd>(JDCJKX8Q]EU<;8+GJ[TQT>Od25Y:87TM0CJ:Ue
cLY;U-1H5&]2dd,/<LJC4EZgC9[K@1#g)YI2Bf19aD[8#@H^bIWR6LND-S8O4B\f
^1FIf1E.Y@/+6)A7OYMRF=Y[J7]Cf&1L\Bg:K16bF;Q/b[8Uda7XO&HDVCT<6R5:
X7R7d97+E8<9L2FEFOdOa57^1S.8J1Y:]D9BcK>3946b10GBN@=]Q6SFND=ZQ:HT
E^WX5U/;M,d#+4+?W=>#FF=##6gT)DN:PB80>IfKe:GH(eR/1U9S;3BgE+;-bY6,
3:;OR&2b0b2\IO</_dL509EZR+J&BFE(4JD6@EZ.>P\g0G5=P(Vf/#J0PR38#R(2
A.NGY_fGd:38>Z7S;C8V?H0;.;_2dLcH]@VUQ39S;=@-CNYI5+bZK]&D?)8K)^3?
;?/BE.c4dR4)O.8Kc?=VPY:.6XU,TD<&egbDa7:NHbC-K9;_)aB4_E24d-e)D2VH
f]LGB+&bZ7b@-\\E99?2ZMH5=RNYFbAT0;]C\e?W]PQH(a9LMZcPMd@M_Q]2&J&G
T+GRb>,N]=9T2/:K^d3,5.B(bV2^:b&B#>Ee2TeHQ;aA0D;>bTS&e_.VFJ1)f\DB
2T5@]412E3;@GKC<N,@DY;_Gdg2]K/MM[@I/GZ=@-d_2=d\5>Hc+RebTQ&[dU+MC
+3>:bc37_-7L/\N#UVEX@f7IecJ4@[L+Z0NO^:[DO1<>)4]TI)P/Q&f=P^BZK0/Y
\6/Bd\c1RB:Z5^&\LZ),KR=F8c6.0/Y8L>edWfM]LHF<Z3d0NHARYET6EZV3(e,S
g@b1O1YD-H<3E50_&EJ96.57NacM1RZUHHJP8Y/d#](.N-4.X&:;g0CH-O<3DO^-
GR?-)4^,ce&6O(6e<A2Q7WKT\2)MU[c\P;gV2Z1dGeL6Vb>^GZY)gUUS+Cd=NPMe
9WL\a7[3^9g->:@AJ=H:EI_.fUEP3;OX?=QA>AG]FYXQ1+@6_HBgL:;\5PP6ETFf
+&Ceg;HT(FfUI7<&=AZII8QOS@UbKQGV8P2)#8I6-Q07;?+3D2W\=cNX/&<-7EfJ
R>S7Kg<;B2PVJWR./X3185T-TDSa62eRdPM;@^6Z\XF=J:,IWY:BZ<89>a[RXXeW
0F)S]CYORfO.=9:#E2CM4:9_:W<@bAbCQ3TH]WQVVPWCd3feYHF_N)VP--;=(H+g
(+GAY=T/YV7T88IF?E_Z:M?2)M&6D[^?D3K:7f,K/2c_>N)>5e-THbV1^L?4.XMA
(gEJYNJ5Y?HgE>0#f[cQ1_]F_eUBT_f2/cU6SbD.d,NbW?CGd_.(^#O0+78&Z89N
A92]FYN8d4H_4:)JW\D,#f/3(#EHc:,a#U+JZ.TG3Mb-8O8&;CQJFN]3PL=^R4<d
UX;CGXOJ4DdUR74EV?UM^/S1#FcTb3[)8Td+BHLa&+S&e<W0gZE40O9U,DYZ6/cE
Zb@5>:9\a=4U=_KZUT5]H;LS(8H4]&:D#IHbY+<L?,>K6M[DVdQ3NfI1KG^T0N=F
6]GY;/3VVYD&94YK+V96[c@MQJ1>NCD&PC7S3,6-ARZ(EB4\,5O^M/UP0;K\0[@5
?CXS2O-P)=d3#Y\KS2aXD7gJ<KAD-LX>[VSKaURLQ.#3eJa/N^O)F+-KgYdMF_a-
b=T=)eIgCS8.EG+8A+B9D#XcYIGMX+#AS9AL<&CLPYIc.^XaH:F1BX<0c3SM#T]@
A-ZU9Y^&VRKP,&3A:\Fcg9dITDgR=9E)5^@JQGGIM83)YHbb9@)[;]U]ACdKg0f>
?;:G3Tf##])(E3&X=OcbMN;^_gZ1_\;.LJ;=M2e5.D4)\&=PL-:a&3QC;<GD_:;0
W]&fX900=b&]R=[,Q@@Y3;IIHGAf2Q?W>?SQ,+O\a^LI9TO<:L6cT+QHdZ#f>g<f
M3Y,.+BB;4E-Cf.0a=540A@cX]eP<NZ9IKWUg8@6_>aC4TIcY/&=aM3<5\^/F3Y(
D1G<KJGQGT^5FJUg[+bGXgW\ZRbK)8V5WS<5bBS^bY\A>^=6O5F#)b[??(;)+3YX
U\@H^E=M1QEAGA.HW7TT/Y_\8?WD\R6@9^1QPe-Q:M.:Bg===Y/C1[E2f^0C(IIN
@b,DA6d:4\TJ;HHN-2fg1CO[OeDQ>J-8)AUBW,FLKK0,(#94^Sa+XI00-;.D7RMO
SOV.bUU?G-/SFDcF\#_<DUJaZ5Vg.e7cIc\4H)@:=X^YP:S.7_#5.8XVUcI6/QKZ
5LcPS5R0bNOd.fTA<?T<4KPZHIa.4WG+IM3O8R>BAL=Y[Xg-+?W4FZ4I1Y8;)0>E
e6SG@08,g,aV=gC-?<4Eb-,)F))&eg1eeRf5.#c3R\#N(1J^8-?93LQUW8fS8Z,F
HQb<5XbFU9a..N^#SI+\^:4A&SJc7>+]Jc?V2R+c)/eDB7_UJ#WePU]&.>#&+,f7
1gCD.R&]T-Q&N;?eCbL9gc.D[cA7O-fMg#O?U\:RH_WJN\:7019dRJ/>e;OZF@A6
]f]A_J),733??d<^+18P?G=P2A2(96HJ.\cJY76+C9K#JX)J<ZT4SI,6DHHW84AR
MHGf^;LNWYB1Pd@00C>@7YH58^O8aKd#E2KRDT\J#_9=\U>MU<W]I?GbBa,6Z#5P
CF1(Z(+&^/MO8F@6LTgY3<Z6b[0EbKb5Dc;5Wfae)=Z_)G4(1KfUYg-@Y/QQH/47
e+e_BK+U=9e&FbNIe/&OH<)g/WJ3/3Y-He?afEFeCYa@fRPXXP>S\@IL7&KDab?U
EL/7<3?JNC,NdYO6]?1QP04:[UaG)(==CbXZYQAe54N@6HN^b/b&351,Fgb8[V.A
]Z5^6(,Y2W;B1]^TefLTGFU-?g#+c1Q&=&6(-D6G+KVSQg:c5HZ4K6G9W2DR8(NH
+,./:2?:_:#4G_+L_GdW.8cRb3b;c0HcbB4PC-Se5=aCIE@Nc?=Q;F6&(8PV_E<;
,UTS#,\GQ)F?7?A0CY]@EP\Z^-@cfUS\R2.]+Z:1,]8a:B\-50.2TALV)3Z<.2QD
fc.+LYK@J#ICM;-)U#Sg;]Pg@D-feO1VSZd,?3S:Le]c_SZPFS:\2^b.c(RXgLLW
EbeJ@e+VK;?OYJ<]7eNQ9f,:OY<K/LRgD)+XYdO\];=)HCFgf0^\MdHHR]8SaV?#
<Md#X(2Gg&KD#aUMHQD.@=bY->I0H>XB@6UWZa=(Y),,VU<YED\S,b.<@?8I\?FK
HYXT-F9E&SD?[\G8,UX>Z>MC=0)g@FA<<Z5Hb1JTEF9ca;0[S6\[&H@Y.V=@bEg-
C(^VI^Q\&&UBC6LKKdC;9cOJ)CQ\P@\c1Sb>IB5Q^S82^8bOc9H)BWZS=I_FfU2(
-ML9(,Z/4,[-PRdb^d6g_4@LR;eBJQ523L(0[7-LT.K(_0-[O86F?F^&]HTd7/V)
RWT,?.66<3M;TWG_8=?03H<1007=@\<f)39Y9Gga7#:+N7:5c&(2FeE^Kd>AAgZ5
_f26SHMQZ7eB/7Xd\.Qb3@SYX,&7G[>Q=O+M0CJPU=P,MDXJ_&>_IWb_+^b(?]3a
?e,-beT0Y2HY)Q1S,BY^\[CYS6f;DU9._/&bZ@8C<1-[VPgVYCg3>UTE]D]#(C22
8.M.M?4aCEC]CQG/JVFVfgTgQf8]U\EZKbZA12.]5/\N<[Qb#c]8J[=f_.5,&H)#
)Z<X&;S=SUfI[-.C;EZ4>[USHLc0f][S&3DK0Q8]cIT&UaDYH&8.<1OA@e(Ma2Z[
:35UgS3d?+K0f-Fc3+28-F3RJAU3dV/^(]/W<YDF;(@];&F5<X+UFA(>_&5b(O(L
P#QUU-5IG5HY;\#M/)gE1Y;OI3=>2S9DT-fPFgV^3,B7SJS_\_\B[\.U,,^+=H?<
F=&T.^U@N=]SPc25OW&78f-?Z4,6]29AZ5S(aYJbfF7\X#ZSc^MDBRS7)>:G)LU-
U(;W2GXJ.YXSJbPUbdOJV.BbffB[.RG.<(Rc1GKf2Uc0OSHNNd?-_9NdQFQbBU=5
AV12Q_#79&FV?MR8[OMY1&@KAdgF:;7F@9^-T5T/<PGJEgLIQY.C:<-A,XHJ_V,\
Wf0_a-&>NU:BA69NR)1#,W\4E/5#F@-EOGCbOJES^ISfc1-7H6,e_bAQJBP-Z9]6
H(2&1GdRVgW/WP1XITQ/#+P<&?9\Ef1Dc3c;/J^8GQ_4XQ3ZM(&YeWANS=.ISS.I
E0\d<e1)E,/J\RL#cC8@0SC3e+fJ\IF8&GfdL0a=PU6)TcUbBI0W\TbACQ+P&ORP
TfS26D3-g/P3&V2;^;1RQSGb4cZ,]/5F@6dY91HE_7L,;XB+Cg8-W_Nf-dSP:,(C
S>A6;IFH5f]/bT[&@DN:(-(D-()]CMAeLGM(^>\=?,4W=16I:9=H^af1CCQMW.Ve
M0@.Ga<TV3JU)+fFL5b?0?01WQX\D](EM=&Hg5bEO+O=gW()2[\J^&5ZL;?(\MC.
F01^,aNR6(X=6Dc-X+)gMf5N,Za\/+g[#VSba:@bgCV;HS>g&eF3YJBQNg5L.\9)
J@C5M5\0LX25OD:VM(1K5S/:L80/#O]SGg.-8V6-a&DONC^.eWJGJPD_J3_/W#b=
1AaOLc/B@<BD,N;8#+dEB?@>g,B4>I9G,]d\c5R<GCI^<&[NBSJ;R8?]d._9WULZ
9c^IK/^A;XM<f58E:f0KZ5bebG+GW,^KT=_WS1THBYH8dfXfR+8ED6Y_Hd=DA>^b
f<\6).9<]eg#2FR[9Wb,E2;:fGNgg_F@,L>/[98+2aJ&6UQH>T#1f_W]J?g7f:bR
a@QMT1eFZG>8UDf4+a@Sg071T,_WHS/LPZC(:e<P)4^]:5UI6g2D0KEEQX<_&YV#
PMcdfb@a&Q3>b+W+JMce-#F^f_@,6I@BWb^]\g3.fA^@(+?2+QJe0F=+7BS83GZ,
3QHgJ,8d8]/D@M:V?2dc_\a2TKOe?D)\83QB@D>OB/5TURCN^TeQ]3>:D]Q<5.J@
RC25gUe73::4N3]F(RV@O?BU[IRAG.(7=DVca[O[^<HY4^.:.(;[&/64gS3Qa=dJ
B\O1:EW+C8(/EEHf-P2a/:#@FefVN0\fD70H(<\FgdUOETGFcLc?HV8#^+bZQS4H
Z+/.[N)9UX??Mb\N<<\ZP;7)ST5CL5SIBI:SW=MK(2L0[@_OF^f]Xbg8VTA_8b5T
9+D(/Igb=[9:TFI=9GeJ]c<B9_^cY4/;-/gSW0YfF-=O+.R][K^#)E?SOdIgFS,/
.-U/6RBJMd5(VXR[f(bJK2:>YDA+W-KcL@QPXLR.^A.F@IY<I>80#TP>eafL@]GL
KAVVWXG2ZS[_4M^-;:00RM4?7(2B2T1S^IJdf3?a&Va@=9afL,4Ua+D_C@]X1Ma/
?X2KCEbL.fVWJTX-Jb1J&]46L8@TNPO/X)J_+2MH,+JGT=(#gY9\3SeW<NE4S+?Z
fUXCP]dV;.FJd4N)Ib]gF=>d^8FH1VY#5U7W8Pf3PY/+Md7G_.bbD-6a++_Ig:T6
G-8FL)C_/cVLJa[/=K=+)_BKd4P4NZVB(KVIGgCaMMHff#>PM0(KH>QDSO(D>G5=
W@X=QO?_/F5Dg>/30H+gM-QXJ1[Zf<bO<7VW_8EE#&TEM>eWM8R>M\&=T@c)<XQC
:_/g<L3PbJPY=e]DJ0YQ?7?W?>I]2E\BJDcG5d>bI8cC(W4U?8Z<4H_/V0OV_\97
7S?[:](Z@NLZSR>1d)1Cc=44\(Qa9&QI@ZN;IF8aN>-.VDWZM\F)aaBIAHc@bfS2
CAH8@_H,Qe02WGR=,=1S6@EA=07TL...3KZ/J;4<P,Y&aXKTQ44T0_?)CI3g13J@
)0^4GB,3:_.^PFbVdT<6Y+#O=HJ4,7>6U.H55[7[T^,KH\]aEb?BL_eH7I4/2S-J
g9/AM&MQ3\QF^3TGI<V9KIPHJ;0M/a]eDe/1\/de=N@,4ADI5=,3TTIZgH4c0g#4
9/M32;<JW6=b,R;_XEf[9C.,J^C]^]ZCJR6.F5)bS6<XL.J25I.ORbCGdQLX8]@g
G@4N/RbgW#eP0]gg^;?RF5EZ;JEO2P=82(+DHd<dZb/3b?8E\A\bbgZ0&0,C5XE-
6F]06dD?0(ZJ2?ef0+2WG=V:K7C9\dUCIG:A6?S>[T;N,>U_#V.PN?N?YR2[EQD(
V7OY\/d]0L&d,L=X8M.b-Q)2L0U@]X(N&.Be3c)#1b>5aJ&GeSK_KE0>S6(gJ,EI
?1@LF72V<K#b@Y)&cR-]MXDT0gIHbPPDA5_c<@0,V=;2VZe)]MRY8bb0/YZPL?EQ
M+KH0PUIf&bT3]c87OK<J(IL8\2XI(P80[;G>.O4Mf9.OM(=0P99e?=&Ge8A1Ie@
,>AH=9ZeSd;.SLAS:W?bR<IUKBS4NKEV<VBNPGUUR:_AMD\L]-CGYS2<791D(S^N
?X1LgdIT<\Q_aabW,P;/3G/G1;=,dF3d6^A(A<XD#()_d8c:WBT8QOG)A2TXG.I:
JW7?#)_</V@I.?,g;6Q9aSU\S&:fb@UNGX:HB,.e@IaZ]L7c/AN<0O#.OeTY-bT>
E(\c-.^TWHdAN0=1]8[g4161#,BW_76@?ceFBd64>U/;(Og:00TW5PW,&c(&BeT>
MY4HOe_Rg+bINS-T9[F4fVa>N#S;3gZ]9]dG,AAMcC5\/d,:/aMA1Z^gVF80]a-2
SM/)TDT)4^e&KC=MKG<cGM:c^B2BJWW-?XM3>3BHP&?:geGOK?-cCU)J#:DH3(F9
e\05bYCT=/<ReP2W&:=_PLU7?.TC)<X,XZA:Q9.5NC:_#gEZb4?(@F5;TYg#A8-A
.Z1eZHU].1:]b/P>9&HbHXACgZPb:.JEbEg=fg\GHf>65)YC1<(O<ICISZ3RDU21
W@[ILZc0CDS#IX/9AJ7dP0?6gDUUV8D6Vd\Z87JDXD^CBceTT[2Rb63b-P_ZP)D@
fFU72gU]:dO65#M5,^9X>([-XO.F/=F=>c2+S+><_M1J^6)]SX7b@J2SNVU0)dab
I0I0[fN>2N=-XKVU:6F_D;g0f@L5.>+]e@?.8db]+-BeS4da\GM]a^/T:G-O-N(b
&&fLC9(2YO&)fBBW:eEO1f/;<\(Z#?6/605:?RN7K^X,=]dFK)#_J^VgA<M\;Q7V
[=FG&:&#OFD:0O0^G-Z3WGK:&Uf]^<b0A#TI;H6CgU:YF&T2U5@J[\RE&N7?_\.F
6G)82<W7<8)ATY>[GW_gN3b^4>M<XY8bb[9D)7.9B.#_CV#-]<g9/WgTO[JaCZ70
MB\D14]-K6:<g+_C7a];E9^cdH;aN-F#;aG;F0QHS2-D6g?R0ZW]CN3RP&R8M#NW
@=/c<4:EHS]]E81&YSg-1HX;;16b#APXK20]U->X1e\^4N9S<R__Q4K46Paca\PN
0>ATb0(_eYgG-cG/B#cV=ECV,M<)C(HGG(Y;_@Q>SUQ7@5CBZHPbK&9=4R(I4D5D
Y;+TTK7.EQVN;ZT,+0)H5gGN[<^FS/[-HU/4V0SJZgS\B99S?B8TX3/dbR6B?-)b
23NIg#AEY2A4++DM2&1bH@f[_?D-;Q5=</XXSgd9-2G=5C.;/Q:V1HLVU:5=V:.B
dgeNe^3PUa-&SVGR#=W,g#V4XSbY5YP/-e7/KN)[0=<O[53JZ@c5(8Uc#I.X/Z_G
0L<\fg.E3G]Pf>]aLa+,9f2TK165eWeXZSI?C2@ag^<(d#BBcbN:?\4-8TcY4Wb@
U<fL@]\EUWN\21B6@,M8Z6RU)/O\V307fVXaa=41\,e3?4/(5<E.J)2EEP;/2e;A
8-Z5V6>fd;VaJ\]:eK?]5CS:R4Bf-UA9A_5c00NL57=7R<&&)0g>@REg;23GM.,-
-AA+O^>Bc2:g51MPZ?(ZK32+g:9)JF>-VP_G/RLU:&TdNRLC#CYY4N>;6T\6:D;8
XMcb[PgX_4F+&Z#ObC9]1(8W=-S0-4FY1eSe<K4M/4>+_H=-HF4.+4\dLIO?C(6@
4dfPAf]PL(JMUMWZ_dLQ:7Z:>?M;0#7PFR7ce75&HT02)]JR57g^9XF.97/cQR0J
3)]1]^#:-P<.(AU6VRAF:Y-VW/&H\GM/](Mb[R5#5>4bE,b@0D@PZCcU=MJ@&Z+C
][7W9([3ZM4P\gU2--CJ<<O6:WINL]4-MN^b6ZTG39;O^:Rb6+0<0B#6/FXK1A=V
F44e?KaRC.d)U..];NGH<Zg&C^+=A::><Od)C7I06@P29[g@IcBTBTT-C#<J;(ef
[[/fKF1,<Ddg@_a^-[H9#g+X+<dEJ@F3E9TE[5QKKBB<,:FOK0<D6@R^46:&.^9L
ZS(-9[F^JP@b[dJ<\?R+Y;UJ.PZ6P1OO@>7O6[eP]>OUCA+f1HPI<]bg+_IP2Ucg
f)[4?[1MS]1a15]/R7,d:d[V8K^L?S>HBR^B_J@71BY8FG>J.#)X8EZG/8B_a7[<
HR/ARP<E472&cEb_P;2-Oe2,;5BQ--O[LK:3\<(;7.6:#fbJfdb((J?B5=+8:2fT
d20[=Y7Rg_--Wf,bS<GB;C6TPeXf[.9U/UgLDF\T\XAIN3UeDE/2NUSLecOO@D#O
M]5U+f20[c+0L5+\M9AFe0[041XEU#.DSe.Z3\aS@AB+\,S+.=c8#g[Z?dK][6^?
67SJb_LNROGE2QM,<74WH^F8VRZ)6Mg,AYN9gF0;QL136;84,(eJ90I-eQbfBB\&
=efc5A-d_ZCSBAS1=,NE4P](@/:YDK:,=^F&P::R@MS>@E/c:D+^[27X-R[?M&fS
^d4^P@2=dJYag/VB)g6<URV]&SHW\MP#_N9]Z;_=#Q822JO4+^aP5VdVC4Nc1RPM
QZ#WGEf^Nb5OLYEZIOW.7)?C1JJcI2OE,bS3P)0BN3\E;.-C/=RZ<^_.[H)[A3&7
B+P\5R9aB@CeF=dcY/Jg@#AO_BJWY8N)D-BL,A:->5?-I63F<#eP9,0.@7\[<T\;
^bI-,U?W==.SDL4]Z>[&0Wg3=Odg,J8B-5d=2=g#SZW<##^MaKL+:5@\/F&EG1)^
<F#0N:8g]gUbfBB.VdQ2M(?ZI>.AEXK)=$
`endprotected


`endif // GUARD_SVT_TILELINK_MASTER_TRANSACTION_EXCEPTION_LIST_SV
