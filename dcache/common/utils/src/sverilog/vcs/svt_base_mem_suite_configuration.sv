//=======================================================================
// COPYRIGHT (C) 2015-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_BASE_MEM_SUITE_CONFIGURATION_SV
`define GUARD_SVT_BASE_MEM_SUITE_CONFIGURATION_SV

// =============================================================================
/**
 * This memory configuration class encapsulates the base configuration 
 * information required by memory VIPs. This class includes the common 
 * attributes required by top level configuration class of all memory VIPs 
 * (both DRAM & FLASH). </br>
 * 
 * For DRAM based memory VIPs class #svt_mem_suite_configuration is available 
 * which is extended from this class and can be used as base class by VIP suite
 * configuration class. </br>
 * 
 * For FLASH based memory VIPs this class can be used as base class by VIP suite 
 * configuration class. </br>
 * 
 * The current version of this class includes : </br>
 * - configurations required to add catalog support
 * - configurations required for xml generation 
 * .
 */
class svt_base_mem_suite_configuration extends svt_mem_configuration;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * This property reflects the memory class which is a property of the catalog
   * infrastructure.
   */
  string catalog_class = `SVT_DATA_UTIL_UNSPECIFIED;

  /**
   * This property reflects the memory package which is a property of the catalog
   * infrastructure.
   */
  string catalog_package = `SVT_DATA_UTIL_UNSPECIFIED;

  /**
   * This property reflects the memory vendor which is a property of the catalog
   * infrastructure.
   */
  string catalog_vendor = `SVT_DATA_UTIL_UNSPECIFIED;

  /**
   * This property reflects the memory part number which is a property of the catalog
   * infrastructure.
   */
  string catalog_part_number = `SVT_DATA_UTIL_UNSPECIFIED;

  /**
   * Indicates whether XML generation is included for memory transactions. The resulting
   * file can be loaded in Protocol Analyzer to obtain a graphical presenation of the
   * transactions on the bus. Set the value to 1 to enable the transaction XML generation.
   * Set the value to 0 to disable the transaction XML generation.
   * 
   * @verification_attr
   */
  bit enable_xact_xml_gen = 0;

  /**
   * Indicates whether XML generation is included for state transitions. The resulting
   * file can be loaded in Protocol Analyzer to obtain a graphical presenation of the
   * component FSM activity. Set the value to 1 to enable the FSM XML generation.
   * Set the value to 0 to disable the FSM XML generation.
   * 
   * @verification_attr
   */
  bit enable_fsm_xml_gen = 0;

  /**
   * Indicates whether the configuration information is included in the generated XML.
   * The resulting file can be loaded in Protocol Analyzer to view the configuration
   * contents along with any other recorded information. Set the value to 1 to enable
   * the configuration XML generation. Set the value to 0 to disable the configuration
   * XML generation.
   * 
   * @verification_attr
   */
  bit enable_cfg_xml_gen = 0;

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_base_mem_suite_configuration)
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
  extern function new(string name = "svt_base_mem_suite_configuration", string suite_name="");
`endif // !`ifdef SVT_VMM_TECHNOLOGY
   

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
`ifndef __SVDOC__
  `svt_data_member_begin(svt_base_mem_suite_configuration)
  `svt_data_member_end(svt_base_mem_suite_configuration)
`endif

  //----------------------------------------------------------------------------
  /**
   * Method to turn static config param randomization on/off as a block.
   */
  extern virtual function int static_rand_mode(bit on_off);

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

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_static_data(`SVT_DATA_BASE_TYPE to);

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_dynamic_data(`SVT_DATA_BASE_TYPE to);

`ifdef SVT_VMM_TECHNOLOGY
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
`else // !`ifdef SVT_VMM_TECHNOLOGY
   // ---------------------------------------------------------------------------
   /**
   * Compares the object with rhs..
   *
   * @param rhs Object to be compared against.
   * @param comparer TBD
   */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);

`endif //  `ifdef SVT_VMM_TECHNOLOGY

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation. Only supports
   * COMPLETE pack so kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

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

  /** Constructs the sub-configuration classes. */
  extern virtual function void create_sub_configurations();

  // ---------------------------------------------------------------------------
endclass:svt_base_mem_suite_configuration


//svt_vcs_lic_vip_protect
`protected
YQF6Q<a2R&bW5cN4P-(6GAO.KQR;<(BTL>H#J[4Lc+;CKUeDD6)41(93I0?3,>XZ
FOEQRae1;T)H0>QB7g:]gE\_6.@8ZgT?^N(#,XP/LSQ][\H2#SC^[Yb):H43:.HY
:D#N3X7ZSZc<Wa2O]GcdcI?eECgX)>3M.a>bZU:A#0N/8H\JXZLD^#7add9]R?E&
)K4=_a55QD>C^RSbX6B)?PFC[40+;<UaKOPK-N2D[X,S[NQOc<\=J[,YKZA9:A5]
dPH4HE5^EFTT?A3N(/A&9+LI@[601dD>E_0J7>F8E(]D4bEgO95O3S38K/.J-^2:
>(WACMa8G^+IbGC@a<H:7-WEZ/G=c9HQ_HX6XI23/GgQ=A-HH0NIK7M0CeLA]N#5
5RRQ(>O2UJX[K/1L^agS620?SH>^Z8_93LdY[#[2E/EM\RZN+QCD;:_NaQUU5X7]
L^ST,2e)1ZDHG=&93N9EV,PX(&a7L4[,;G:/gYW=_,9>N#X++aBI6MBcN_Uf^Ngb
5,U\5033,[N?VIeH9.V76QUDb;[+Zb)5g?PET;F]9<:KYZ1QIM[7BI9Tbbb4B7Ge
0LU9.(?ga:)#/U3Tb>:=4fV68b&6PMWX:FEV1G,Z;T7&K-I7K3DFFM].90GSBT8g
Z5Z2;]FT>4gGKdU,;85\Pa/3Y\(7FJ,>YZLN-0<UXL0BJ0S0X_=#e/Da#S:T9([Q
7M2R;f68aQL/,^D3#@/a09HKQ&Fa&>_gfLT-+S-S[#?:+&#C69AXfDTBG)1\g7O(
0cR0gN28gF6fTc/db,L6?K2[1a)b<]]&&1J-SN_Dd2&G.W)7BK&Jd><QPJY>-XFd
MO/-RR5-\(K+6348b6e3I,fJNB3(3VVc:0H0&?F?7?C?XPX\90I?JZf=;V.[7@YB
0?V?M8X:+;&51WM#TWM3O0QOF9G>T?>a>)M1OIcU,U(6;P;X^I_E:64L/dU1_B?S
fP5HJIYcJ0&ab5SD?HNW)12&eT@)979P2G@XI781)WR(GeT2F54(dTWCHY+2CQ&f
T+8;)?8+.fIeGgd+><QBfg_3NL]I\>_#S[.5K&J^&W?GX-F.U-0L=8/51@PTA3N\
KYYgNdA\Vc<?<Cf??gc4PfXNH[d,^;ME3U.ALK0M9J&1?NA>+=df>ORU..Z-\bfQ
;4a0fF?8^V.SG93aB3Rd[.&#R_EYc;:X+]F=UZN<_GPB=0O0C\HW<Hg@?&U[>B2;
e9g8O?e90HWB[+aV&4c/LXa6A,EefE7Oe4[R#JEC<2(1-:5L8D:PL<8:R#eN286=
>7PRLfDLULWO;\.@)OQ;aad/R]<f0Wg,5#?:))HI;16FSc^H/KL,aS47UeJDR8c2
HI<?&+<V)<ASZ:\9NLC607QgLGbdMd[ET:/Z?;d&=5^\NVL/<WS:M]?QPVPb)CXQ
N0;7]P(.W&HZ;/d\2gd<[AVWddYTbBdWJ/VL7/)-2ZZ->cS/c]Ud6##O\N:-,G/8
(&O+6RC,(MYWe#I7-4G/-AN4[.cV1K,6e>d8YNaeR^WdQb2]3G^_&UZScF[0a18R
^/aY[47YT0JJ_CVVVGM61)W;\XeMg)W?0S;_^>a27U5R.I.McAbNXfCFg]gVV5A)
C.0GDCUNDFL)0W:]2]B4;FS:a\&5:\3gfT)OORY5X\UMI<W_UF5>=>LLSaE>BLN#
1:9AY\S\-995/L+D/9&8L;4E1T>&MB29bfL)bdAge3/R@>7f@)=O#(.CJ798e8(7
R4a+OVE(bAX#_b5(;.5LBBQC;#XU0<-=VZ:;CC_=CN0,IA=5BE@QV.O@V^+CQg9A
[(15PIBJWY1ee6&0FPXFW<V_0N)TKH/EQYebb?;3-K3a,f;>JASOa=Yf++OT;H?T
^PS[19IQK,(c&>^K=_>FE.WDB,PQ0S<f&8J)^+\af_LF1S_F[\fg_JFg#@,67KVa
GYc\C>9)4<F8Uc[DVeFM>[.@>+TX/6gJ[/H1R:5-/(AMVIXcR0GT.Q1\A&IWf@BR
aY2^(cO1&K5P1Y;=3W(Q4L7>Z9;J^2&d)YI&3aY33JQNMDQP-P;3Y>/T,:B1?#/#
[O,0EY+1B96V?+@gT2b2+R)=9RKT@J-_^6)cg^5Z/6&HM&-D02Z7HR(QQfgB49+X
K)D:Vf#gMMY)^M.N=(@.85N/gY8aRa\8A>ENY2Of>0UQDa?C5BMMgg^2)S>bVgE[
1XLfFVPc4gRUHf4K#<7D&cGaP&82?#DQFA+)&V>@-<)Z@47Hca,3R?<V5W1Me>YD
3R5&;6\^1d;&GB.<=T+F5a7GOBF1Z=FLE]6-d64FL4C#e?D8QDeD3L/NfU6#]1&Y
/3f6S(B]g#=TJN2RQ3eVXBeP#Ie3B(1=[6Q&SX4)JKMY?D_6.-+8PdNW6[4MX&gM
+DCIfga07\:I1]@,?3JF:acEF8Lf3BKX]Jd@]TWM4d[4=<(Y?4.,Ee=S&O\_6P&H
0:3KN)_QL,b#B?[NbEOV?N)A-1RK.+/YQ3CYF.;(O3B0H0f9gd>E4>P7];a(I/\^
DS<c^-P?&VQMG)E(=3WY3Pa;L>H4[-,fO1_2a:L@PR.0S<W1Q_F3]cc20;#5RHCa
+??]5Q?,&(X:-C^O-?)8&d@-J#d+CZE@8^V(.B=,1:fHZN@U?7/gB8;?Ze\RTHR1
N14aQM9=M2T4ZM3Q.(Z)2?gW6H[67VLWGWZHSUIe^))R4GdE^2^B\X37,NbXC1Wc
-_),15EG/9::\C#;eZX+@LZ?,>:#2ePZJ^@b9S,7N/0UR)NOeQ3I7GL6+)5]EF\0
S.K\VbY<P7@E+=Cd]757V3G8#5^;@>-QHW8cNX>HTf&YH\]b1CM?+&0MAIgXQ@J9
:R88+PL_Q/UcR]D=M_Kc]^_-8=I;2QS3]+8[4Gbd:cg6g2bS1H8c/4Pc4W9WR9<W
VeX[NBf[65ER.Z)P:VHBaGUb7=@MEgdX.+UJDL+3Q4>B/;]1[XAA)O\A+@UTYdA(
fHW@G_O_Z^2C/F86F(egP:ZSPWGRK53BTG5RQ8BPdD;cT/586C=#+7+#<-dJ/4^J
-)=]5,<QfV_:IXEXRH:WK6B1OZJ)Hg(eE/Wf3JU67T_QffW#QH.Y76P&e1LT9WAf
<R5.6NI?f?L\4EEVb90Za[D=5,,USB@3]AaID=d3=<>bD+.)7,7AKWSO+#N/f+^[
fR25dX0JE)K&Ybc62&QP:[K0:Zb9D,VSgB7[T>QZ>:EO2P@@GFa4)IV#c57PI]@N
)eH[4CM>)/@.X):I>dCY[KF]&8-]_GDMDF2H^UN-O>gGQee#N8Hf=SfTa98\1LRe
Qa@VBWK]dZPOK0aYdOFg#CC:A)09E#]26a:FL_f6UbMAeJ5YE=^T=?gG7Pc;)Zd7
DK=)<])JQT\/S1<3D^/=JIg@8=>dUBD8f05WY/d<5_/6P+6Fb2=@ZO9CE?;V0HOV
<;,bUQ#Fc^:g\5fFJ@c_9A5eB#XE@MMTV)(Lc,(VZEcU.OB70J-WIeCHIMJD+b?6
<a?f+g@BMCXDTBdE//]B6Ac1>+I818#-IT,19Z2AMKSGA;&Yb><+@Y,Q<REZJb]A
J[QC3IK>D1df[LbAY>P^H7S(]9_)0SBgQ<)eQ_X<09W:NDBU_[V-K#W&TTc.4d[b
5bfOH:9OY^:NMYGIU:-B4N#X]WDO1W?FQW.[=ZT&Lf0C,+4UK)X&F]]@L=#7AGTe
QT:W]#9c).Z,d5CC0OTG&28>U5S;5=@=FEO[3F==7Y,K=[B(UJW?(LKDe>HH]GR?
SVZ0YK)Z?)MZGDQa^FTI+8DM+ZGWS0X./@RaW>=NE:UAKbO=VJ,E[K+2H/:9-)/H
BQ(]K[TR>-8^A@+P/gd<9S2K6H#CPb9dE>?adSAHe<+)M((IX=+T9(YEC8V-F/&&
V5c[IG&?9NW)M#AN_eL^R1VLf\18g(.[NJ1g3RSL]G\],\HCX^M+HMaZN6He#+.Z
][<B_3Fa_B]5<GB]a8^;d+5\_cNC,T^.JQ?Y&B,N6)H?77XJOM)=7T9aD5@]/[Xg
+eCA<=J>\),G8;A>Ubc1bBYL2V6=bRHF8L+E5__T2C9X#9^Af-LQJPO-LfdCEZHC
:P/bR^?7R5AZLQ=OLGcZAF&/8REGc)HRLg(=U,T41I=]7bX:UC8TdM>7/\3Xa&e<
.:ZP5E:#Gb></]54=:V7d6?@bH7P05b^>Q>H]?Pf+(5O[JF?7[YBOB6V81@NYO?2
)-e,7LW@[ANd.2O7DUL?31P);YDGc8MX:@;THOdfOCM/SV9ed\^;_345[-g)L?H7
V]\I<GM&&L2A1CLG>\fcWadXRG3=11<\YCCfETc]?g>eO,PQJ9aXED06CK:A^RaS
)GO9.3<O;0C#-.>>0K027PZ@_@f.?P&7Nab)(WE\aP9:1//Ye;Q=2Ac,7@CEbbEY
Nb+KE-U/RWNA?J10YCIJaT4fPF68e&<?E\4+:L8HN65,+V>WV(]^fX[?f\;(K,/:
K-e3\#W4a1]&(RI&0E-8Dc2-J_9[HC2\->S:R4cbF^^ac?F(?)e/DJXeITWX<Y=a
64bNb9G20f9f\FZQIK1017Ida<CD.5b;8+K)W06(\0OFZB(MKFC.E+]Db6;503M9
E_=8,MKL6[=4(.Cg&5S,@aZS@>U^:(I@@_1?0/,Q7-/?B9IVLd6YAXZKDa<58N)<
6g7-e/TW4(;:&<6LAIggEA:3A#51e5)\e#.gY#:QRB[3ddCf),B00aD+7Z9Q>O_8
/F4e]&8P_BI5=+7Xd]XOegJ2)RUT6VY3cJ;,=X:,,[\Z;R2KY6-Y,C2;H2O#Xg[.
,.[^6499QIFR7ESDVAGV);_X&GMH5PU<YVbVUUYZ0TB=g>+HWBf4:51?/36BHLT5
V[^#/BJ@K(8FBc/)[485YCcMd=EC?MP4:/@M&3R5_P+VJL/&eJ?>_C47.N#GaCAd
S_+AB;Q@+>fcN.+?&=a>,Q(<e)[0,CKERQ;EJ,3H-6FM^;[IARPKGXX#,5Wd97bG
]b(LOPVgA;6,@HKcYN9?)6-6:N.MS.@9\@GM7QYYLRMD3C;V-^M3MO8^N8O\c9=E
:fc^4O#X#T#/-=(C)05\-E:,f=P)63_a9FJa0B3gP<YC9[O6Z1WZ8MN&DU1RbdPb
&HY(7T5&;8ER>(;7F/U7)JL0777ddP@Mf,+6BgJP=9@MfP&fg4<+X;2LX:TC60,_
.);0.[3;Hg[HLB^AdSWC60CW4BQ8FO94T.\Te]C.UPMWg7R(,>Kgbg@NJ==N=<-a
=<dda39a1Y]c_KBS2+SUFGe)KDR/YO,.&(KJJ/4K[_UHQ<D+VT3\/SQ7_8QY_(,1
9BO<HDU/dIN#B(6HNAEA0+XTS:@7NPCOS78P#KTMHA-<F?G7V&Z9B@N6:<K4:TE1
9;L?NQR=E_0dL\4c)f<R2L^-2_HT^08M2I&>#03f,d(Z+=[IRDa1NaU#Mg[ed(HR
bFGT)\;EP@fId2baER#_)UeLR/^K2,>0S#N_Z9R>3XQ\<QAW0</KgR27&3a7;2?_
6BM-UQCa.ZC6843#?0INU+f0X=./@?U+;W\.)^#CY0f^=a=e1TL+AP(.gF/KD\E9
a#V,]#Q(Q8[KFH:#>5:e^&PP3?WXCRZ5:=+.5aEa3C&VQ6&3NWJ=(a/AP3aD@ZOe
)5)4A8SNY;Y:8V\>MSF\])P;UK99V@V(d<8bJaOMR4YeM;ID<-2LB+d/;K/Lf/5=
#DJ@5e>G8Y7^#8K&dSeMRA([7@B&+D.<HR+706ZeaB4PZ28DL^cGYb6bGUa?Oe_a
\5;)]0F(X<Pa=+SNO5U8Ab@cd/+&[)UD#>0[ZCWYY?E\D[PE(&O)ME@)72d/L4GT
K=Y2Ud\XF>X7I4cAg&1DO4ZfOXFB2+<)8LGLFEETV6fNCaAHUff4f(Z]0DRHK#A)
SfY1bGP[N3fL#<<^V>5?:QQ,AF;eI:K[E\>MA4[X4DKIJH)Y.e3^8;QVWJJ:eP5W
9Ab\@[U2Y=4C/&We+6B-ZU-0Q-MD]MBeg)S_9K^QVJX4XLQ[JJ^Z<]a6?+d\d\+a
SGG3.#6c_c;Ga7;I=GHSY^EPg;IB)R\FG.8P6XV?C)DQd#N=@fQBS<X2f>V?XHC)
UU)fN]:)LBe42A;F4:=,N69J1+]Z5aIb]@7PY-#4OEZ6BO13&[/VOEN,7MT3D.5\
_&U-R)CEEJXaSM/bFD7>FBL#)G[;Uc,[a_R^(P5U-)b]Vc-L6aE\[AL(^+K@C)^X
EHV^NYFE\B96=MQa&2#4]Cd\-I8#F]-96A.Q[L]-ZNZ.7:[L)b9f].T8M/L:G<96
LZ=4Z:89_^=>)A85R8BBGH:A0VH>.9E:N.4?aYcL-L\/COIH4#F^a2I1[.Y[&[S]
R-)2G:IRN=0([g\-Rd^EL3?(7E..57G36O,VV;:<]Q#NHYE[DG(_HN2W]B9)N,+N
C3I/:)WR,cT81D@P]b#D\dVYW@UeVT095e-GY&E@LC,DAf3H+B>,9U0V2@JB[=TP
Yd6A\F2a2_IX0=[dDCc,7g8A4:7(SE8KGX7^+F5E>d])E8?,^^CfGcNbN+;]W[fY
C<4@_d6,YCGUBQ>C:WSJ@2\ObV)^2X9A#8b\7ME9)e^DK^7J4Y+1>_9P9DP+cI^J
2A_OZJ[^M8f<g2RSE]X.9+G\4&KE(V241=fDa?2&AD,)@Ke2Z--0PV&Y2ZHH7ZPB
X9=W)9OX>[/C3)^RG&NU<;M\DY(;ZIA#Z^Z^K<UC:c>ARe>YSEAb5Ab4K:ATZP;H
#4U(9KBX2G-04RQ?RGC^+B::>)e^DL#FC0<+#WB\.E)=SGRDRg35#VY\QN(#WF=X
RM1Wa.\8_-]L]@U:::UKceT[AUfYSPG]\QAF;)8F?E(#B+Y\51DBgXZ)FB)a]=YM
@@^-MXbXD.[(AfaY@59JaU7CdQ<#[M[[56V5GQ_R>\6^2cJQ_<&-9VSFbTH96Y?8
TNc]^_?Wb)VCXC,c?;S^-M[4M0(]JK9==aO[3<>S8-Cae=1I\V&dOMKd6VJHBH<;
E=)C-KMe+0#N]SS6@OBR=)ZH\HV3EW&8?CE:Y9a>g,X+TJ]8O?Mc4IIU,Y]D:ZQY
Y83C[M>W5>;_/7Y-_7Tb&;,EE)&+TA4LVD]FZ,8TSbXBW1Nf^^;922EbS\,cf\Zb
=6Qf7N8N/NP5==J4g677cBa1GW64LV#G[?#]f+X4:T^4BL<HQBO8XF^L34,fD0C,
@@c9IO0L512#6.@2cE1B?),K&<&=#fWd(A<3fg5-(&+;:IRPC2aXC^0[Yae--5D?
)Q;8RcbW,VAQe>Vb+GH45bY3.+0K,1&#b=#52>EZ,QI(9E)aATO=0WG4e,6de(TE
c:=@<XXB&5J8)</;&MJ,3LQEb4MPbc,D8[O+G)4RFUP-T3dM].g41aO>81QADZ<\
]A^d[&#c-1R@3./PM=Z0X6NL.c;e7[<LP0E;Yb6cB6U7[[[g/=eYN\_f@>\OIF^Q
88_3?S6SXKSA0<CSVcCdG_Z493,G\S1E0Naaf-7g=OZa#b-&b.8b)+ZW_CS3S>Jc
<>2VgdQb7g\JXO0/]5]&HZ>Qc/Q_#03021J0ONe\[dB[]R#NI?2EMe#:QK3JN5Tf
)3=Q>..@]5&X?\-^+9927ATZJdN<gX9-Z8<B/E+U1Q>H.@+2L98d:\F;,90.PBGJ
+.>fP:DedC+P2D/C5)XM8PSXU)9W3O0W,:SO_Z@XSNd+]>dW]UOZ.R+Tc_LY<EQ,
6AbF#V(^O/20##3;a>0bQ[(G-e)40eYRV_WI8M,VL#Tc4V3b<[N3gVV9SbM(8MfZ
/EFQM14aa1FG>ZVS21KYOVBJY\>0c>.JNXX-X.WSe[YaGTUNfI3GY;GI/N262KDQ
eNRKR&1OV<TfJaIe9[DeEW[EOHY6R;HF+.)3B/.O..F<S[JG8;=9Z7aKSXD?#.M,
.+Y]2[<2NdDCPd_?8F0KQS;Q\?V:EW#)@JK/)/P?6fDg8/=Y6XJ)AeL5C9aUd)(D
FX.D,4E^H,=>1aSa91K6LJ.(Ob((eDO5g]]\PcR?_?#UN=E8,.g(9Z]TPTd2>AdB
:LEZX1V.7&HY@cB0OIUA721Y_^UbEJY9G2L<<V[De;H,?Eg[M@?L0-(IU-HBb6&6
Bd-N<]4W7P-.fg#&;AEX[/0#J;JSg,IB6LZ8^:a,SWAFIgJY^f5fe2dbJ6PX/J1C
3X.5e6#(6R[YEa?5]e5]\,OIL3HE?(:L@(JB<@AKUf@g953a[RE9[Zb)^U.KV+;0
O1g<b6J\B5ZT0Kaf>1R(C-]BTUTUe_XJ(GC/Ne7edCL8Wf7//Z9TF&HW.3#;:Wff
S/.X>)SgPHH)NQ:QN79:V@HM@83\U6P[:X(Z4fE?0G@]#,CTc#,<)YKR2PEQ2BP?
2,I\Fa5cbT-KA_2A+/-;d)ZH;SIJb:1#&A>HBc2_T\;4Z-ZE73J?\S]J+gP&e@#F
4SeV?S^I:FHR?A<CS[68Wg8CRL]>fL#MaXO.I(=)aJ<>1cdIc57MLGW5E<B&QCgW
@/=&)K41XH9g;G]5O-)WU(4^1A<B6N:XUCS4M+[eW@ED)+C_Q;9/D31Z<[)-.;S#
ZU6#ZR.d713e9UNc@ZY9HCKb#E-e><2JN;Q&0?2;>5/;XWC^LT#WK>C^81aF>&A<
)N;63D:=#?5?UI_d^R=K@R)HH6:BdZ,)1+39dPf:>P#B;0Y-P+d__K/g<YPIR(Pg
;:O3REgbOK?72fX382?RKR:NfN_<[;<87,C.a.SIOZKg2L.8GEHM85Q9#=.@Ka(a
KJV<G5<:@gW88P,RT1+aBaW<,eEG#R?,@ffQYX^Ie:EC-K4.:QNQb-R=>38I#7:U
^b-:aMf^R\J6VdNIN.8Y;O#PW6_?B:+6cEdR;<P#EJ218UHcWW3&CW0Z)9_EWaAX
9c6IMPFCSCaY\KB-@Y_e&](MaFQc1C)P>I^6#A4GFR_ecS^gPgg6#gAAR4S1fdbS
SA5[/8a(BUZU(YA./cY60,BY0<Oe>\B?-&1_)6PU;H-33Z)/40eBLP_@8-:E4aVB
f)[6^64RDNN\P[.>K<7_fC0.9TH[6L2X)P)A&IaDMf(9>:&I)0c)9]3<D>.#c-BS
(\BCT3Y4.1(AaK.K.D3Hd5;+b_\:AgB3R/+YPNb6WB#;9CW+4@)#9O6B7^_<E95=
H2X=3G#.Cc\@dRg98]7SegZV,^)V:4Qc:?SM[(YgL(N3JNM]JD1=Y,-DDQ2VcB38
g9VFRE:3@0-LeS#.V8eZ8LS:7ASS867e;R)MY<?2X56Y.O./J_\/O5,P_CWMbL],
MQ2,&KDGdT6(Y;B7:CM\-FbE8?)58MTV#0NPA>HIOBC@WP56dIE#JS;O,#1\?.<I
7f/FV;eb]bgKK.ZXE8E;Za&ed2?4gEC=-K2/_/6^M5T(WYaXRb3O)-2D[:c4SE+Y
a??OL54PG+c.]EP@/1dFFR?TdA\L]>L:(B[#0@_bIO?dGf1=_X6g5\/(DFS?1cMC
<_\XZ+<GA:I>Dd#4e@GW.94XKE[KWV9c1Q7\@&;VUU\C_-A(,7FV#9CU?HZ_L+?Q
N:A(&A\RLKLMUe9&3=BX]XD1<b#JJK-Y(9E8dBY#EdX641ce;Z[4cU&A_c6dMY_8
FcV.(#OX2[Q9R082a(XA)F^II_<fO7R&=@S.^,[V@R(d#W(0R^;<;#/]O6<4DT;Y
1G:g13d4+7d3V<ZS_:^<fFbeLUbDbU]C,6.^[\UL3)5ZaU4SAb9fLF?#Zc\.e6g9
UH?J<N]2),9+SH\=A/3KVI4U6/L5eHf(;7-(3?G>IJa(VaN=ag=P>:cK9KJ)f@T&
7J;234^)V<XTYK3UUAZJOWW+fK?DSMA?e#^.DZB,PW(W\U^?6+WZ[[B2g-S0,Fe1
9OG/R3R=a=-\f0=M=UHPG(H_>^FTC=8bBE,=NHJ>V#3HOeJI-IXW4(U]:5>P-6a[
^W&ET^V,^/d-AH1\3ce&EP:OQ-IAFPP^>-O2[f?M;9#3P5R;:=Td<44@)?+XD.4@
-L)@@#4/Z=f_4JUTWM60A[,HR#.:ZT_PcId<N\dKU->P_4J0EEM>dgGUDPf)-^1L
-I_CWZ<C/DP<QYRY:?c_.8(]]aOEQ:&GG;LCRf+ORg.G)GLZd_/E.:Ua]>U6@IF\
6ES^#1C.P(Ha3Pg_e,:)0E)V5YKLCE[:\R6_8d=8\4S<\SX7#XNbNQ2LEb&Y8HDV
b;1>,P4A&XUX60eLT;c#-f.68b46bbaZ/(ZfIbPIMD,7F^=2I,Hd-TGL><ca2La[
QOC_9dJ(<eYd9YYbgP^KJ\=8Z0[(M@2@HbX;B=cD;bc,de.ZfJ2R[UYSA-5=4c4d
3Q<&OFW;5Q@&3f@bU2(.g-69ZPWOQ=0D?Bce^RYIR#8FP=NbH/5d&+)<_;Z)-5S@
0:DTP=O[?3+-<CL4C>_J(gDZL90=+dYHY=)0=>/@)KWg2DcR92agfQ_.&]/QD-3H
P<@[.AZNJdT3Q5Ce]^K7;]ZdK1g6VX_F057.GS3Y:FP[AJbF8YRD]8\I[0f;U?,W
ZCHaHR\FS8S6X;C-c;/Rf@&FfQF(V4Xc.bKL/WAM7X[IU\AHQT+.#ePD.dJZ+,e7
_gOV+5Z,c2aY,Y1=D]1XM/15[d2[>WR,WB995SIR@WPQ8&I-@O08E8.KeE8?N_g&
gF&9=d4E;c.B<dM]c6M82D_6c_XWL/W>XMK,Q)7UY,;SeEU2:W<7KQFRTN=P5W0P
TGNH)X>(=JL-0G@c?#LH94[;SZX]&:#<dQ1@IX@C1WXc<W6NbKUBQ>LBeWN/:GAU
QD5@1L,G\03b:\&>T.:7@b@NA&-><Cd@V1bRCMSWTRQ7K88;_d-6:Yd7#QEJH#0Z
Y;>g9&aT)42#.)HM078=AV?Q^A>>4]b[Y^X[B@U/MVLgBHWLS8WQ?:;TSPa)?8aX
-RO+JZfJ04_[.-SdXa5]cYd/P=WR3_cTgWdV95K6b6GTAa0>]]@\C]K4,A6L@Odf
a.(73,KS\W2/0CA&7E7J=Qe9V:Q=]e<.T0]P_f@LHFeaQYEQJ;F(b)3Pa#0MKVTH
ABJ&[3Rd)fO)BE@4L[X1<0LW?F=U]JMGT4M,cf\-5CGYGJ:?T6FZ#K&B<c1d;:8D
J99E^5DHPI)-.fF:D_D??eQ+I?6]7JcQHD\bgG\\M)HDLCN@O<7Xg15HZ5e2WD5c
FK^W#,aM^/\fR5,b52X_Z^J0\5Y,/GfX<4L.@2).c;S?+)=2,=e:a4:;E9>GO2ed
NXP-8g_&CAcO&2F]P6eLDE/eO<35BgMR+0AW^EA).8Y.[b8N=DI.b2X0H>=Gc.,B
Va;1G?&&Z_?M3X4]I-,bTP@RK(YG;40ae2bMA_@LP66RE>#69UXKe?X5&90W2,&J
,@ROe?D28fCV(G:]@1Qb5RGVH;5#1;b)Q+&=S&?=3#U=g1b<Id[XYGDeTPU3]M4,
fA1<d4@D&QUc3NRHIP+^\Y5;JF<d_G([c3M-B^[U^7-;eJ3L;8SQ3KFb4YgPfD_7
VZ_[+aC.DIP\8d\WL8/&ZE/FBI9E1d7W&A3OY2+L@KDb.YFHb5.ANR_1+6g3T2dU
+;T,>)MA&O;H.W.3.1Db5d_PBB(Pa7fd2E&X8.UV@Q]7P,0L8Ufe;B&gA4Cf@_[D
N3[de+U?4:Kd\CfBZQU\M\@@FCRK9V06O:bZ0?BeA,=MBC0IZ.Q82WF2PSQe.6d&
WR0+:GdQWOM-YL?(Bf>YLOHIFPY@KXG8/CW3UEbYb^X(ZG7]PGQW#9O:H4_(f13Q
Lfg2;5=A6^BQG8G2-5\1N\(BWRbOZa3_L[[P.d(]-<]b2\\JAaa10,MfMeVM(Z1e
#\12R3I(&NBD_1A_RSBOKTgBH,L<-+fH-dcJ;4IHGZOB3Z1bNQK#dNa-9]2]+b\G
C&J)E6^AcNBE5dY(EGI^J]_T>(&//b6[->8ceMA=aX\R-OO@bFfU??RC8\/>5@P(
.]WU+V;8EQ\BP8Bb/,?/YL=C97_DaC1&V@VXOgY)#<[4YPMLT+GM@,>S@[2ceMHZ
#0Hc4?OZeP,&E=EL;HUda#Q&)S8Me&LGH^3AeL]K^_,]e9G>2S._cEECGL9I9T-b
96S)_LQL?f0;^[^]Df+\O6S_\#3^DM7EH7/=JTe.WWKdKIQROZSFOGL&fcPQ&S;,
c:,B-G+4?_cG-M^P7NQT86714D-R[Ua8#;DOWbTWZX?,+)f?V\=Gf[-XKX30LTH6
M<(8]9=><gGe=43K)c^_M9F&J6b)#NKW&(HZ(WB#</5P;c<0cPB+XY25P9YG(5Ja
X32I[KZB?HJWYW[+@(?e@)/U1f[e5f1\_.\I(>(VeU>-Ig(ScB)@GIC;PR-2W+]e
)[e/JC\KQ:]daM>QGEZT6e7NZSE=eV;,ME-N#eT(Bf-QC>0<T[F>1C0S3K,Gb,C?
):K=DZ?7LCL/?>C])\>&H)NDSC2-V<8\W\=NA.f18-aZK]Z@b]9f998@/4Bf/+#D
^ALN:@,eF>/[d@_NLE+#5^De3[DOPHfJ,>Cee2RR&d+0/4.3:QJK9a.5eRF)eT7K
c&C03.@Z\Tb(+?NN^K3(^K5?D0N:3QI&-3DfFZA-a?.5S2&52BcZU5HN<b\/+SUW
3Bc7F8ROdb&F@K6F-X[IC82\HOXa]@Y470\&M&=f+e-+2fG[;\J:V7U-bB3cK0T:
.O6UA\I+1HaDM+O1,CKdQN@JMF=#VXN5@PV&52C9&TGf(VR5HK)9IFCWLHL-L(XQ
)bV8D8L[)3c--cAGEU2//68Sf#/Z^9]](T[L>8bGWFdDE/J#SD+OW^P&SfeN>.,G
33]D?X/JG.\)6_16I0(]Ya/E;#NY]+665aSCU4GPTC@8#NaE5GP]J,U4AgAL2JCJ
>Gb]3E(;0FZ-VCTV[eO</DHQ&NEO74DT(RIK;ULXf:FIYX3Z2AYX1AMd,f_Q0>cb
010<cF7:/XKff@FEP?;I&dHV6#MJQVJ?Q@fJ\=JUBKDNSZdWCJ@]D(-L;_LUS91.
[PX3EK(8NQ_;7(.A?E/;fWRT6N,D.86.4I#@3=UHZdB_^<5AO#Sca(b2d71B>PNB
7S7Ic-^IF3E#>WX<C>8:c7J(]6ZRN0AB6+cX)39B2HPRR]6.S?:+979(B<-XSU:U
fBPSec[8K=.Vf=eG\5>J-QQR8_-DY:S4Kb^(KWQ#?0,_dRQ_&&M;d92X3GO5UJb=
TE?dDTY#J3(M4>HQ>T.9D0990P10I-S:WJ&W\,X,L?F(bcCcV0J+1<H87H)ZJ,Ge
49FZ;d2Me=6_e)E>O2U1/e]GSQ>IJH44MeN>e1Vb,Vd-40D+<E(RSdF&eIJ/4/R0
XTP&#[g9V\#eIWaU).]?RdKW=[</f_]Z\d/&LDIIF^W8FHDW3#L+CX_=J/fBA?(N
W8Q4Kd;&7WMBe9-c80OFFCgfF2>GbC&IY8&=Q_f5G]?JG;O#[0GGAdeVTC@M;>d8
&.,Md0=IL7#@)OPc6;KOPU9Ab7.a6IBPJ;c:=8VIJcQ6(^]O\+PX<d+_<5M8FT.T
4/#BObL[b#+NO/B9&a]Ie]&V?V:)F:&)=<S1/CCPV1CJ;7=>BAT=LYIK>^K?,&6L
KEBGf3HUf,G//CdT@FV@g7P\C1c5TIEfXURGX;BWLR41^\H=GLO&D.G;Z=8W5#WP
O9<,;fQ1WSW51.DJW&4TO><Wd#H-:X5a7S(A>TdP.A)e^cY(R[V:O6a7UPZ1MIXK
@03e4N_Q4>DLa7(Tc>,]JKA1//[fSG4de3=T>)_c>Ud?OJ],6D.L^-V,,0fRP+6^
-A&7LdC1&:X#f+Z(:f_WU,N_)13FF1g94.@SINg-1^R845:.<)D11C<WV^aOb.>,
O+Ac]g841?YP;X_0Z+H+@b7T2d>?6a+bX^aY,1a_)OZ)CIa-CGY6^C-[G_#6a,?@
;VUJ]+WRWb0][,VS^^ZL+]L]SeLZ]TE#cd/7T4I^(/7K^;V7F1JPV18GVRN/L/8f
fgQC>&_KZ;:P7fM[+7L6P&G:._GS,K&J0#,aDQF-V,8+NVc:&H204dFRD5S?1Wb@
N)c]^J?<=:6&4?#\JdX+aD_c+=IXE1YN_LR@.04H8_ANaBA7[=<f2e,=\D(@ZEI8
?DX?J0R5&cCEG;/dBW/,=M]M@LT&,TGV[\ABHTB4U=3;:3aAQT,M?OUb(62beR38
M:W]I1H67ZF],NMLIJ4A,JB8LCV:Bg:U+]aC.E/3C\N?b/(^/A),gf9FIH5+[[[N
H]7b1#&#08AfV9]#NO4]RZNRZ)JNQMS?M19g49,F]R0bf&V9N^fZQO]]MH)T,\e(
4aWZ#R?V^\_5R.)H.D3[?;K]dP_VHYM18dWc8O_-Y#D=Oa7(D+N,aM82ceD2]/XR
EW,DUBJ/D;(;3\;Y6S,F74@O+gRRLK@TECA+=UIf:TJ_B,R<_\Kb3UdXLCMP??eG
XSAVSQ+:80,O^),O19WA)8\W8/QAQEWO5+gHfS21fAFCDXM);J=R1=ZDM9+IYCAX
XMYR2T6TDW[)fZPcO@K+N]9#O9NE(-HO4O-(N;RR0-E9XQgJ_\PXM<,-7Y3G=^Ve
gNGE5f8>Af\EY-;\B8T4:A6\77C.@8H?>S(fQd:84Ecd,K6DODYUI_MT_OF/baZ;
/>MC0\)Z_&Q_9aDafR)W>^0K7+UK\#D;G:gX\>(66TDSK65eY[;BP=JN=96I5IE=
4B+MX4K?HYg<EV6VB56f]dL5M>&:IB#dBgIec?ZbOFIg(D5cg#9KH/TeHTg1#gQO
a4XK<2=?>V>U,Y(4G5(MWUC)M>adJ<(-(#AGUf6geL;KVY4NKQ[MB<><a21?\[^2
VJS(ZfD0JT20)].H?/VVUUbP^/^fd/AY\=H7DZ;AZMZX?H1-@@Lf0FYL(P]BDUV8
(>;CQdDIM;5E,#:Ad5+W5?+]Y4f),8b8<I/+\DVZ-\+.I5#D4QZ_8<:E7@4BVF/1
@D9<1^d=,\4GJ(#2b1LXa_92XOB&^JUE:+;WMB(\a.K#06Q:^\</28POSYe=-L8W
R&,/6VCAe5SfWXZI_(VGF_/=_R>G9+aL^C_+3E0=7C(L?BE4c=)5NN]U7M^RFf>c
6Z9cQa:UW)@]4e8@adJbaL=)30>I(/7\19:Te-ZVVPXQP)R;@,=+ZO1D#PWFb1_G
<,&5-96If&NODH-#bZ\\D;NG&EcTYPc09FYIeEF=)O3bV2fP:D2CD=1cM8T>>&U>
-eV72TeA&+50=P=54JYe<)VK_J0M<4=G._B2;8?)0;0T2Z;gM>X&XY?;#0XbX_9\
Je8QX?be4<6:-Gd>7\Ee6\7T&=PBEKG:#LS:Y#SVCNOQ,QgSF3SP&>7AJS5gF7E^
67F_&dT7..54,:&;Q,A?9_]N]^VP@Z0668?Z5C>ZO)]=N1c&&Y,&)X6aSQ,WIR(B
5FRP=\(gPO3S\:>?C2+C@]^0=)J2GZ]aE<3MV._2>2?UY+F^bA/@FJI8_#Ue&SZ:
<aP/LD_P<3gGB:aC:I=,Dfc6@JV.L@?@g5bT.HA5IWKLK#@3A2f4a?.Og/;c^BG6
>19HW_T6B[+R&Mf7]W7::SCU^SY<MBa7dc]&+P9_)3<4BEP[?@)Ff/dZY3#H<JDM
>R[cGXX]9)\4(8f.;DE>D0AgA]]@JUe)9NH)/W\)9],SK;AS0(02gG+W]AE>0&]B
(=C-85)[Y-24,$
`endprotected

   

`endif //  `ifndef GUARD_SVT_BASE_MEM_SUITE_CONFIGURATION_SV
