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

`ifndef GUARD_SVT_TILELINK_TRANSACTION_EXCEPTION_LIST_SV
`define GUARD_SVT_TILELINK_TRANSACTION_EXCEPTION_LIST_SV

typedef class svt_tilelink_transaction;
typedef class svt_tilelink_transaction_exception;

//----------------------------------------------------------------------------
// Local Constants
//----------------------------------------------------------------------------

`ifndef SVT_TILELINK_TRANSACTION_EXCEPTION_LIST_MAX_NUM_EXCEPTIONS
/**
 * This value is used by the svt_tilelink_transaction_exception_list constructor
 * to define the initial value for svt_exception_list::max_num_exceptions.
 * This field is used by the exception list to define the maximum number of
 * exceptions which can be generated for a single transaction. The user
 * testbench can override this constant value to define a different maximum
 * value for use by all svt_tilelink_transaction_exception_list instances or
 * can change the value of the svt_exception_list::max_num_exceptions field
 * directly to define a different maximum value for use by that
 * svt_tilelink_transaction_exception_list instance.
 */
`define SVT_TILELINK_TRANSACTION_EXCEPTION_LIST_MAX_NUM_EXCEPTIONS   1
`endif

// =============================================================================
/**
 * This class contains details about the Tilelink svt_tilelink_transaction_exception_list exception list.
 */
class svt_tilelink_transaction_exception_list extends svt_exception_list#(svt_tilelink_transaction_exception);

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_tilelink_transaction_exception_list)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception list instance, passing the appropriate argument
   * values to the <b>svt_exception_list</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   * @param randomized_exception Sets the randomized exception used to generate exceptions during randomization.
   */
  extern function new(vmm_log log = null, svt_tilelink_transaction_exception randomized_exception = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception list instance, passing the appropriate argument
   * values to the <b>svt_exception_list</b> parent class.
   *
   * @param name Instance name of the instance
   */
  extern function new(string name = "svt_tilelink_transaction_exception_list", svt_tilelink_transaction_exception randomized_exception = null);
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_transaction_exception_list)
  `svt_data_member_end(svt_tilelink_transaction_exception_list)

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object.
   */
  extern virtual function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_transaction_exception_list.
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
  extern virtual function void setup_randomized_exception(svt_tilelink_configuration cfg, svt_tilelink_transaction xact);

  // ---------------------------------------------------------------------------
  /** 
   * The svt_proto_transaction_exception class contains a reference, xact, to the transaction the exception is for.  The
   * exception_list copy leaves xact pointing to the 'original' data, not the copied into data.  This function
   * adjusts the xact reference in any data exceptions present. 
   *  
   * @param new_inst The svt_proto_transaction that this exception is associated with.
   */ 
  extern function void adjust_xact_reference(svt_tilelink_transaction new_inst);
  
  // ---------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_transaction_exception_list)
  `vmm_class_factory(svt_tilelink_transaction_exception_list)
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
1XF6LcVHg>TL?6e6U8-D^QGfc,/5Y6V1Q,ZQ,gL+f6#2^FbA/F)5-)A:d[Q??7:]
g;5[Z_R.cDb(W1PAc>0Q^AT\-a?>Ta[D8UYAN6\2@IKJ4:.I2TIXZ;873QUBIa+;
D-5eU4O>M[)TK6C&cTbA9Ga(Nd3&L^QG;=,(gCAAYWC^F>5\UN+e7.C-Bf)_WMO+
McNgZgZf7W;23EAH4HA,?7I(8P)&]<1?9EcZeSWGC3g=Qc-N9&11;+@[Z.+PHeR]
@\9IZa#K01IU?_=-3&;]C[J7AL+FGI.X7OF,@7[fQLVF92g?gFLYTWNW6ELCL^:=
;aUPYBJ@L/)@-N6T)NO7&.GAQ0cM1]HZ74;X<RN_TVMT+I,(QK<OUG<464A(:YQV
SOA6bd.gGf?#@[E]bB18G=S6Kfgf^9[@6F@/Ca#W3M;bVGR:QcG/fM1EH6+e)_E\
UC+:]X(Qe<@^fGP2IE+Z>W#<3[;cNa_SP=L5#)PD;P1@S(M/a)G=OB9>@OGKAPN:
?Z+6BEO:9](.YG@H\?<R55a,D3\&AM5^B_MF.5Xe0@,T(V@O]SL5>UVZ(8:eI@Y]
]^,I-UX4@_bIMaXT3MJ?O-^YERXd_G95T>&f:)W)N0EWeS01&^(1I,;YPD1+;d1)
8PT:=d&=[XC<?8,d)T:2,3O7Y9W<G><CTZ^e8NGH#IR=LQ(d@d^A.8S+KRJPDF3Z
f?;K&G.M6VV6acKVFNU5R:/)6FdSgC7W3L6V7RTB1U[OYLO?[(:S.J),,KSP5&1a
1>T@d-eJ;3@U0&&(I];]4gKT.ZC4.Ye=,[G\D?OeQ+SOF3^.?(QJDI;gSSd)VK=d
.X80[N1ZU0bCP7Y-.S;Xg4[NF^^dG1Kf^&@/2,8S=\CI^g/ES:F-^,FE0_=,BNCb
g-ECbQZ6<^.CA[/7PT,O2]NU3/79cURMQeZ<AV92+g#Ub5<>S4CcgJP]a]C]A)(1
XeBIAX]RCA^4:5G6b)+[ZUP&^cb=_gEI#a9BR8\XM[HY_R3D2]9.;Nd10^@aHVaX
4bJ9UAO,Tc@Yg_^69/,G79IaX5@S\9=T<,^&);fC[bEOC@P#+QLH#^3(J=ITJOEH
S@aJ)FKJ#C/?/;Ge-b/c@#GbW;@d2W,PC-:ZIb?U)2LUG3N@_7KR953,O/V3PKcN
BDSFE+c7,OZG2-;,5&.g+T768W)a\U49CHXUU?[FaO-(Q>fS^X4]d9M@/BgWJ:GI
Yf\[7/\^M4ZHQeMCg1X6+[>4-9P:OK,?-/XIT8MB4)Nf=H22LVZRD1M@J$
`endprotected


//vcs_vip_protect
`protected
,+D<:4P6)?HCJ3Og-6\&B<Fd/\G/(1+HFB]0gX,BCM[dO5TV;F24/(@IMKN=[Ma[
=,I;O-Y02/PX+Pc?;@B/B#QOUGBX]e^@.:aP=b#OGH7caTUR,JXfB=<PGYN]YW7[
c@Yb+>_]WB,SG?O?TK<4,WNaZ<@1<-4CcQ7J-S6c?#T.Kf,7NYZ19O4aH#?Yc(MZ
<aN,-7V?&55>RGbL46NZ^^OF)I>]3eW)[4SRPI__R?3VJ]YV(K83]ZG[/bPQ1[5(
6<fS5?JAdYC>Ld)dPHXg]V0KcSdeFW7R1CQFFc/E+f.B^=(T.QdOYG)UcJQRggO=
b@YRT1HD4(ILc#a:4A]baNT2?[GKddOd\:CLCb@T,99WTXHJ@H[;?Bg0FM0KZEZ5
AD;FcD[N]?I1FM]aa^RFR+0G=b22f<GOL/A(/SY^[ZefYFd.SPCU;IO<c32AdM#B
gJE2G@Z52g845<Q_\,D2OU<NJOeD1DD\,<A&0c_V)_HNMAaZcK=/:?e=@TQU?:[9
PREafR/Z2O@?;9d&cM0[<NbYV_bHg6/GUQ?LDC\<g2<Y(0F&?(-&VQ^f7Eg\:B13
YASIS5HG_6KDTPZ2QWV>?(fSI5T8I^V#RbK,-L=[]fE&K7Wfe.N1;MH#@##Ra_(a
J5[=ZYN2SOYYf6QU?MC#80?(H,=>b<<_^3RUQgL]L)@GJ0?):W6X3@14VeG_X.Lb
<8R(ce]D=6A757HA)BK7CZ>RU9AbO3+.OF.3LZ,#E?6fS+@41\QB[=PG1>e3PBAB
3Af@/W(e7.KN3J5:=MZ/R+D>QQ8fRKZ\K9:-5#N/,9.W=KE^ITEF:G4LNORSfO/.
c<OCXGFW(L)9P==UITVW\ReTD(.(8_V^fSDO)6<Xa<G8GZ<K(PKd#;D3SL<)gYZd
F:R3<L9>W2=W#d-cgQJ;[QC[ge_[8\cQQ>S;\P>KT]^We?33PZ<_K^@JEPFT24b<
4_c&,@>+\LOD0KHAEQ<[_^5DDV8BDO2RYZU,bg=/,c3(d2dPd+aMa\:+f;f1/gVc
E\2;[D>9.E=\<)0X<PKKN6;a84KO2,K_K7&K=E,3LQ;\,2,H?M5_EJ;^,eJRC/M5
6Cc#fDJN]>>Ec+(:?2POGZf+N,P2@U_4Q&g7L3VD6,;T)ALRH_(Qg1M,9aX_/&fA
N\?;ZN;O&ObKI&^b@cTaYgT:_F/S8@E3c]^LHae&4Vf+5/R.fdRN],(deWC+-^a?
,_PcYHZ352L+W6\aaZB7e;GK?:A6GEOFG9U<BJf2NB-0+Z\K(Hf09RJF3Z.(DK7L
:<LdR>d/-913_QRA/CU9)OdGLC_[ZFa3C^DZ3[:^<VO>SYZ>OAE]G[Z2Mc-DRTEG
Y7Ha5?Na,YHJJ7DH)9[PPT0g=;#M4B0.>QCc8([4-F-QF:B\.I6EE,@-E\/Cg6Dd
Y<g=0PR2AVWQDQHW=U0Ae(XL6FF@b>K?FNd;.H-@5bXTd9D/50NC1;1a_YL<Y4<W
A6.Bb?UUfFH(5Pcb6>R6.#.dD)O:65TP&c)=WPC=ZT372)RY3;6bc_I9bG8O&?R6
R_W\J>F_0&ZU[.)A4?1YcfbD[S]TDUcX8F)eZN+PEL.5G@8Wb,Z82c@-eG?=FIb1
5F3VWOD(^\::9:A05Q5N9#-JN.b63ONZ]0DVHHB#FR/GPIOe0<JLY?:?+1Db5/Jd
))XcQ1:L:@EO1NF>]WfT5U-<0&2?2B^7.MIfK0WT-])2P?95\T0L8.MVFV:F0O<V
AF?9^/]Kb4c&da0(6KFSeE3B;+Y81Bd<.[e4g+DZ.7g&X6VNddS:<G&LY03QfA9d
>09YX;+5T[BE0RJX9[JJHe+)+3-;13:f[d9#H=.;1&MV8H^Z[6CQ\;PgNFJ:>J:A
d7fUT1SY<6dZ2dCAP+I<AaH]:698T]_7KD\99/J);LYd3T@<a?OdL\\9LZd4SJ^E
SYKQ010Q0BDdWOMc)(DM^ULL0I;Ef_MA2fGO^GI9M:/RJZ2>@W;H4(T1FgDLgge3
eFU.PBF.JD)7E5FT_0W79YP06eBSAK,4RdE1=J@/bUIG,Z<TBZ7H?A,7#eN#U6YR
F+^;#bA<0b(WSP:;GBP6FZ=3eVTdTW,E#0CNQY/93;5VZ8EUc.I)e46G3gI\gH2D
Ud&UDc\G-M^.80L<cM&PW=)1TbA,2)=+8?WZ@F,::+N;,YKS_[g3BL1]H7:4f42(
)FW<Z0>>W.);IKMJM]0^+?FRgd[H7N@A>&F??ZSJ?cI\Z1;.PJJ=]@5EW-,:M3#<
Y5bQGM-AK(;AP[QF1R8EZ,DC-0ANO:e7LSF5&;Z^g4@^OLX>>HPK/G+<G8VX8+9C
a^FB_;4I&WBaWL4WRaS&;FPegVC\?]gd(O#8DQ61)NIHE-]+)+R91=,F#V<P:DFL
7Z>6@?R]1XggG=HH:]SFeU>c/LV[S_^/a>0M9Z&7<SS8/aUQ>fY)GIF<--X5a]I^
N<26OQ:1;_1AZ+0PWITR+e,TMR6P\?d<^bWK6ZZ:F/aAKgMWeNg7dG;QeKDJKIG/
eC^9<^58)KHST5M-O9)Sd=LLCW48_AcM,#G_H0KY2(f;#\0(FF10TB)>E]bg+BDZ
Y6Z@)IHU8Q=1UCb?<)).:HJ5<E972I1bXQ@V44<@<a9X,)E3_NDQ:UT(HVP&#2HJ
BD_Z3U^+//E+K3J+,?_HM:H:&]f]efTcMaHCQ>aW:4542K9#&P].SFX?0,SU(Q9+
)#&P0d[gAE7PA36&62DT>]NPG)O>,DB+S,.E9b)91If;]cP?R(D:QZAf8I^9C3UR
OBV1\P(fN_F<cZ08Z0HE4)(:d#Y8)Zb3BS=a8J^FgM_HZ(>RCA/M9<^JR<MALH#5
LD#RT/UBQYE,I(]1X4\6^CAY3gCN]:-H.3>]=(=2aB]/PG&R87U4?7@:@T(78gAc
HD1a:@_SA0.2S8ZHJeY]/F:8//E)>VfdT7A<c8XEYW90dad_M&]8AG(OW9V&@EA;
=^J:FK(8&QM.[P/?:.C@1cH]AU[.T\[7H:aQ5(MQ-8&H_95LM]^\PG6a(LHc-=;A
Mc:/?>D6PV:gEaK;<e45_->IT-ASBRG,&DG+&J5QHR8J2W9^Zf>G76PeYT1/BV13
0DMGO/AAH)K.^2g6Wb:)Fb#\M8Hg3F32(5BB4PT+2[]VZ::3K,;PBA8E\2)<(##G
c7OScgc)#],&EOV[a6e1(Q;6/J@C3VWA0\CAd)N[?5T^>W7;dRcENZ,#<4G2+dG[
1[NeT,-c9&dP7<_E_Q\YRc#^OWTfV)Jc.e?Q0(@2cNP+DMGTLaH0QG^FgW)>64[G
<0f;61[B8-SRC??20UQHW,+dG//<_Nb:#C@+(L7K@0]_FN_GMW8XIea75a3B)cOJ
ZASQ:Of;V^J6A7W=329_(L6ZLd;Q/Q/Pd60QUYV,cCGb(I.:[A>_g,(7JJ7PVb9M
C6+dK\&Z.Q[+N)6AIJ[TXYNNLg9a=Z3[NY_3:PZWPU95+9fRgCT9<4J?+&.;,b4>
_2F[8W+D?AB1[:O/.@TZ(MDC5GZSI&ON0^QLGFP(9->Id-3eb[3?UY&6D#@;AfGg
7ZTK4BeQPKZHI>D]dcNQ3+WD<7SK-I2F67::c_WY:S\X+UA@8a2#==Uf2^:a?@Rb
EKdPfZgKL[6e+c^N3I<4&@N+88-=<RWa;O\H6T]+Z)JU8(<1gVe?6WJ2fW(X;7U&
PXCT#c4eWKVJ:3IE>]2M.Tf9]D/,WDc8^#Z6S)Oc@W=b.R_R&5]@JK(Kb8aPe_3?
MB^ZQOREeHGTVK/aEJGRW#9d0J5;B;_Ba#A7@[C+]GVI3.DgUOVY+401UQ9-Da,<
YXVH+R3GSaQNO37^aCNHEfI^]6.FT7L6#P3=>R2HLD+XGfIY=U/bHVbaaB23][WM
IcO,YMTXYL<0NcHMcT1<3X51R/FGXa>;K3Xc#+Y\OCS>Mc;EKOY2F<<3V31cMO4\
bOIKfd#9W(UUHGSLUGZ+b8EH[<<;-QV[=O<3G)L99RCFP3M3KXVK08c<?,/]e;eJ
IcgGg3\gd]GCS;KU>&+#1DN4.Z]RPe(B:)0<B8RZY224Y)/2JHULEF?Qa&UQQ_&Y
GL7((8])eC:)Cec4(_Wd+>+)CaS4Q9,:TN\^7d9;3O)dX[\Y/.93ETOYQ@J@9<DJ
B(^;CaccWXIZD<&fE@Fgf:F4Y2gB;FJG</#E#0=26\]2MX;:9VU\X+Ef)^?Y@0.-
eK5M.cXD/MOa),RR=PUS(5<b;NJYF=25G>9S3.8CBWLD1^?E3TO/=&d@X4FHWI[\
f.T[AM/,c&_;H&:2\(:-,GI]eFG1VW)C8[?UXbTA,c:dC\CT,SPC8UO]R@5[&YFe
YC?QddK]a#\A(ac^UAM]3>MN[&(71f&/K;J9fdbZIGWJAI7+)bf],WPG:I]<O3\F
,1gA=4,3IVC1f8<#PB5->7YgYMIdBXSFGQBgIfHJ-TYgR8:@^[(BZ92P7J;=4SRO
g8D,/+9M[,bAcNI0(d+RK/E^+O[C[SAL]Jb2&2_7A&K:=&4:H=A@E#:a.f--e-5f
U:b@@X>Q9eVb95Z2<0E6L8cM,>X\5A[JcQ]P)F[3]G\T;?QLM7IXUe?+H?;^IaeC
U3Fc2__L];O6)-U0dJcXE#<&)STUG:HXS^2E=c7VO+e@LH23HT-564UNX<0F4cC(
)FfK]BUQH(@-0EJ3VbQH#&U>1EH49P1.:(3Y=,(E-Q;3@\]T,86^RK_.2\:CcI#b
J78F6BL(SIY6>72380=O9MK,H1#VS[PU/RW#BGP]b<-Tg:]-9ab+>>\cJ7GD];)?
]cI15E?2/R9)c&])/XQCTD=;S-@\#4b3N]8AB(EMEgO+5gB5^+AcZR\R3W7@)K&-
HF9JfXX:1G,>JRBM<G7^:8SP]H1g\-R_?6a4QN8=JN?B)<>6;SM[4S,J3QU8EH>a
e@Y0X#0?_ZGZTW155U+FFTJ(OZA9,(O5YF_XRR]D]gX:@X^PbK#g,]BU[4IO/[R;
@;J@=JQJW8=,]ZZ@PYb=<FG?H9/(1&[+g^fI3G&WU2\__ZW8,Z3TW>S5;Z&g[T[&
L6+aQ?\BEDcNU-R\G_eAbUP?>+<XXLY)PJJ[>#T2K8KP-M&25,42;J4^E<RR71G9
f=M=EIKUZEKf?7Tc7a:T8D:N[Tbb>EP6f4;__?R2_@U(0ee&>]S:REFB-]f(,P)Z
4]L/7.LIG(2<DM;cI>7+3^29&Y1?cD+7).Z4a^J3b&JI<_>@W^AVDeeO/M56LKI]
GA;fG[C3)H7WX50,U&=HC03+^dU^^e?WWJ?;\W@dM:,ZN:;:-41NVgc4f,,HbBaL
Z48:c5H];KWMAH>Q#=9I>[A1c6a7MOf3HTEObJPVI.gE_VPcUVYeg?GZ7C)aT5?d
Z[#FG&9,fFU/X+]Kf0d0aC@4JLR9MZ7=M_?&,HP@8)5;A<F,/JN=G1H0M-(E(H^c
[K[^PP\b,B^^g4D1Je=;0MD?g4HH1SCS7Hd=&[IMW)GD.HO)-Ve5L4GU4-^0J^e)
/bA0LCXZe4WO9W+I1CF=U,]\6KKOT7+[1QdPR::2P:cQU4H6J7Ugd3PDAI[S\Gc#
&,E6K/F8JYS#2eO#-@ET26;#A/b5X&&bVK0WTdVHb=G9BFDa7:fL5S1L3H;/+g^@
#]L&/ME)KPd@#VF>NbW#N6:IgcR8Q(>c3GP39YZ6@E29HJQ9Xg?H7QPOe\Qbb1V/
1]R>7IR<G](G,3Ef:/K:_4KBgBARdUBeY0U]T9?8T8GP>e&3SFMW?.L^#f_+\C_0
dK8,,1Y2KBNbXP?9NKZa_1.890E@C]?+P.cF/77,+8>G\+eY>UD;T>fXX9\HT#NB
&J<)@A@TUW6Ce2<)<40+#_IWA2(HWK_?,[<X:PFQO=Q/@EQLOF?9AVBNG;_WLg]9
PH,\E:P=E:HdM\K/8^7_[^-af3LI3QVf+NVHE5E5<C-AY(239?[51gb.P^H;dFQ0
.SIKd^B[dO-EOH;INELZSLA@W)1.MRF<7NC92gZR9(=@^>E#5UAa-JY&TF8f)THB
Z[:.2KV=,SH?),TF-1WZHAKG1@163;I\0-C52-F&W?B#+3e1Z/Kb#,LFP<SD9@A#
D9,HL;C6TNc7KQ_RQX4HV2LU),b>#D,^Z(4N7e_T5/3&KHOG=0T;F;;)9OIIY&aI
6,P;<LDG@^PP.&K_QIS^LSbN?P7TW@W,4Q1HUHf82AS?S;NDWMOL>Z:4J_G#0&-_
/gF^].8=944)LVMM)A^<,QXe/gNHA#_KL?N\JR?B(;L9-D2O<O;9PI=#_8)BbJ16
-gg,#d:a,3Q&.2TI&#f\/\&FW3T_R^@d63<RGV[P]I2UKTW@E15>;#N0Rb:(1LS?
B8b&g^38)M[:^1UQ+;W03<17L&EQ&dA?e2(QbB\RA3@.cK3]2OI5b55PD_Oc:.9L
#YNYfP7Q3@&R>12T?-L\\?>_ACVB_faV_>F)6^_e)UFYCX0N7aKS33,T4aKL87bL
Wg+X0<PUbIJ=6??WDG8Q3&6Y4>b&V4VD/@?ZQcL:B5TQgIHafTD./I>:.(RRAML3
9d[ZQ4VgK2YA:D^a\;=DLY0c72.&gN/2>ZS-7Y=^dfK&33.R4,g:19Q;78B&/g=:
bP1cSLTWRF:b,5JOD78dT)PE<_\c45efeW_0^7H8V(E7&)g@,AJM.@f4\+D67gGN
<KAKD.[N4)5/KDD<S0e6E8X\[)Mf((Z\9UW-)?.UgB^dI<AO^L=0TOC9X?8g0Z,O
ZaXNYOYae,EC5P9b)8FP3@]+R3I+LQC/gM>1c4W1GKF\Cf\SIYT6JH)Y+I++N]0Z
^Q:DKB0(T,)KV0_Z4f2VV?PQd=>&dN++7LQX=_c9AH[/K6B6gO+SRXgH-].ZW&dA
afXNB/ENJOY(fF:adAW-aH_W5KC^;)9XeCeVF&?e#C-M&YdY0MGVRK1.d42Q;UR[
>;FRHf^c=&GA7YVE#^B8/AK[Y[:=+Q/I,D3.&8eDOI;7TF.<4cL0Le:)LX?PXBTW
ZgLYAP1A?CZ5GRSZbd6TB&?\JZe[CSc_:d&cAH(J0EJ/e&YC=5##T63d[MBGZ?ZA
\(;-BVK_b<Z(W0#K/aX2_JF4KH&AfFI1_=<N<;J/Z,H3DA=<1T\F9;3<6=\T#H9(
-J4ba&WObb2&Y^bM0K-g\O;+eZ\XD:#<E&USQPUH3dC#@4T?deO[XL@_<JVG<OH_
;,;?^;P;=dHPXYf7YL7-]45HAd=/b45\S==0dG^+9Ib+-b<Qc<8;.F0Xc[>UI8FZ
6\8,)S/[:(5:^&B@9e[P1&YM8YIL;F1COYSd3)^L-/0L^DD)CMVfJK0&1WDC>YDa
(>3C#0aSL1^:+2M7Z#a^I+#TA-1)QdaQ+VOT4W&;SD\SZ8KaK@E1662[.c5V25gQ
>;5WL6c@B(<^LL@YOb&fG^#-RZK)3/\G?f^^XcC#)-E_QO(+g/0Z6#\V8c:-IOBJ
<.eMN1<BAC(@A+g,B;,]C.76c3U7WR08L[I/EFRMREYg:ZM54<cWJGE35\8_LaRI
E(@;OCDYX_05D<[79;]\L94GT6L_32F\AX&+Oa_91Kbb<A,1,QD^MUHJVQ+;VE<b
N4J9G]8KM]FL:5BYY997?;5L\WGM9DVEM0=<WY(3=Z;KEIKc:af126)\RI33.M;B
OSeFVcb-0P+OG)E4JB.(^DfR)f=]?YeZg7d3)SHgGBR&(]a-6L?^:M/NeB+E5S9T
6J#M5-;FgUb0_XTGINC00N30g4DTcb&?e^)97_D6b-W.:5CUC;PR>V(KLE<S3>&g
feWG:/E@SPXX>ACHUDB/SWXKa7^Fg4=(H@G>bH^f=B<TYWL=5_<M..H(>9Z>eG/C
K_3dO/2P5NA@]/?,CFBWA2a#MM2;R989:b9Ke4\:241=TE893DF9f78GS0O+g];/
6^1VM;JSDTc(d0a,)FKD2R)fJ>fNgHHFdXS_Pd2b4+UT@P[OBEdXA(W0D-VW_Vd5
9(-HPFN3Y9bK:C>#=)>]#9&6Pfd[YLEPN\.Vd<U9[.,11YK,,3##eg498G7Gb0<A
YD.F3N1)XI3VX11UL:G2DcPOJ=#Cb30fZTFdU46/RG.O:dVB6NYA#S@2CGg-JIe[
>C+.\AOW^A+_XDe&KfKNXf=UQ2;R+Da>g1gXL7H#\95-NF)+dbFee&I@TY/3ZA2Q
Y])dUJbQ01J=&Ka[3-^NT\(@aOJ8=+T8ETS=OBR=bO5N2552J2E0_O:IMac6D3-9
7<10U[?c;<d>]G_F4M+#bIZA8>D0Y8DFK9HN=Be6edL3G4@5X,R@UOZ]Pd>V(Tg(
=F+=8&H&/B<AT&fA9&N^?3,<#a^.8STPNHY([L<3JBNMM8].Xd#Q/OT848-8W]fL
JHfAg#G6?6^fA1fG.+O[Xf0BZ[F&bI53TDB1BTNGA1-CL-K2XS0PN)2EWCL]9P^@
:<()[:B/JaJ-F0))JBe-VP>@)Bcd.g5^a\^3.#a3P0T?<D994VTV\d]YPM&-J#ON
/V_(cT2-_.e>D?]]>A2<8UR(d191+B28CbIWNE&XXcP[D?Zf?OVKNXY7^WPF.[fL
d<M+:HY8M<dBF_G=1:I&(ZD/g:[B@H7.gK;/)EUG^4@8,gHB])2=7[06XOYKPM5#
-YP7_HBP2L]..4^O=FVE#U7T28Bc;TN#TH273-ZDV2AFMc]3#2egZ#L:_#U(NK9b
90>MQ86cKdCQWY7_Y^AVOO0>HW5c-2@E,GTV)#E^(BPK[NXGd,,]J?,I@VWN9A.W
bUg:96/QI(YYD?9E&g9bc0CRQ;[/a(,<)#g9a4:RJU6d^d#S5X&^Z,/VC;#?0FH^
8C4RRQIN.Q/UA^#7__[II59bOgA;C)^-:g]ca-Q7(&SVd55^73g6PZ/.9YfG=:c7
X(B?R\F8)fEUY.cD\H<DY<\ScM)#FPIS0G#3//,I0U.F3IA3EeXY^JY@DFCd;CF0
7S_XB_6S+0TE[V5O=7a/I\R7VG=O1cA;YZ#-C/QT@5<:dIdY9[\>7A1g9@]9.HaS
c.NE=D9V_6[-41dBfO;T@ESHa2Hf.[L-KTJ6^K:.?]@I<LW2VQZ5,19WL/DM^B\/
3#^4,YEG779b8GINU;#KT/@5@/=DFagK0</_8M<&Y=EL.cV=IFI+#\S98/]-Y[?P
IJ#:B#92)IJ;]C..P2^Qc]J<:,aL]f0CZM.<30b\Dg6a,>1D.=G1ZJY_W+3Q=-:\
f1F^bF)RL0B,3GG]5XgT+HJ:/WP]Idg<]UHE;OH+P5U,ZaX;K1,gg,G0^VaCNb#S
?I9BHVf1X(M6&(g#9f^;?cd25U9Z1gJ.^]P2J@a@ZeED58>9ae7fR>4Yb#^NZM>C
A3PD4aRZSSSFU&U#-AG8&A0M8KT9[G@Z:3Pf-GfO5J?FaK[>TJX\RS5[:e-\)g_0
G-&S=eR;E:EW0RDE(K]TRLBLgb/1VGF/0C_I>&)-++(Y0:)Ka9851JE3@_Ja3B_J
HP(+g;26&/@<:a<W.E]I\=)@L;Z>K3J7\BNCX8eZ:YJX1022HUDb1IEO+,T(J7K1
JWS0P,^@_AL3SQR(KG-3BR(gd?34WTIQaW>UHPb2fU<FSHdUe3]2a5KO(5R@G)WB
ge4B/#Tf1SP,RZJeVF,.]4eU3\W:OV,13@X:VWBZ[;:[_2<Y&Q5<76eOgd,L,^G/
:Wc>9bZ]WAAM8d;BW89-]<(U.(Ba#W&,XA=/BOe2&dDLYf68A1#YXGB)O67-aeHJ
SP0A2.AO]:F/(f)S0-a;;YE32C+&=/;7g)R^Z6OOCE/V[_C+?HRUgVD?;CA8DNK(
+c;ZEBCcR-7CQ+8@+C0=e8XS?TbIBRLb2K\<;R8^?,dM#4deba^6d24P;+(NWD8\
)G;R?Ta7MB9.ZPKTG/?/d<d,KI\L@(0aD0f7I(D.?31@(;+1U-6D#=cW[?V4H]DB
dAgKGaJL_UL\FH]3;)UZK&dg/>7T0I2cP.5X+,W]0N2EV43M9<\D]ILOJ+3&1YbT
RdSYPQO@<5Z<LdWc/NV4@8QbBMD2g=19)Y(-+bU&&LK;3-TYHE>d2fJ07,:[V#ZH
XNG)eE5Zb7HI.a7KeR#gaX&<32W4SFJNO&V<.g5K]W9KHO5@N5G00SCPF)D&)/7(
:M/6@F^=_FPRe0H?bfLaaCaCJSI;^QSR-PZE@HT3d@6a5RNZ]N8[X.4gA1I.db-;
8U99bdda4d4cB22Z1PV1If7g<6S<D+GffH2KaZR2DIRd&^c1<Gdb[0c:R0CbWCLR
DL.>?eQ[e6Z\\#D_7,b)/e)5Jf21XVRKb\OZLa?:X-Na2#bWb;Y=HD>b]HRFZ57#
&CVb>?aXeF#,93/.#.);&cWg3Q6D\3dFg=A7]@2UBGW8G4S?\1S8[>gfd^IK6>UV
J=,=.Y_a5>F3f#@G.dBcAdcIO&5+=geFe,G7/]YQg-X-)9aVEQYK_BTT3B5]DD4BV$
`endprotected


`endif // GUARD_SVT_TILELINK_TRANSACTION_EXCEPTION_LIST_SV
