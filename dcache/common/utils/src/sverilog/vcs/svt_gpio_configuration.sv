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

`ifndef GUARD_SVT_GPIO_CONFIGURATION_SV
`define GUARD_SVT_GPIO_CONFIGURATION_SV

// =============================================================================
/**
 * Configuration descriptor for the DUT reset and General-Purpose I/O VIP.
 */
class svt_gpio_configuration extends svt_configuration;

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /**
   * Specifies if the agent is an active or passive component.
   * 
   * Note:
   * The GPIO agent currently only supports active functionality.
   */
  bit is_active = 1;

  /**
   * Minimum duration of the reset assertion, in number of iClk cycles 
   * The default value is 10 clock cycles.
   */
  rand int unsigned min_iclk_dut_reset = 10;

  /**
   * Minimum number of iClk cycles before the DUT reset can be re-asserted.
   * The default value is 1 clock cycle.
   */
  rand int unsigned min_iclk_reset_to_reset = 1;

  /**
   * Report an "interrupt" when the corresponding bit on the 'iGPi' input signal rises
   * The default value is 0 (no interrupt enabled).
   */
  svt_gpio_data_t enable_GPi_interrupt_on_rise = 0;

  /**
   * Report an "interrupt" when the corresponding bit on the 'iGPi' input signal falls.
   * Can be combined with enable_GPi_interrupt_on_rise to report an interrupt on change.
   * The default value is 0 (no interrupt enabled).
   */
  svt_gpio_data_t enable_GPi_interrupt_on_fall = 0;

//svt_vcs_lic_vip_protect
`protected
&I>0C/Fe:XOIG@dZ/?YgJ>9_-M53?)?IG+W08-=@\6aJfJG437N@3(NI9Od;GO:J
gDR+7<7BDJ+;UJS>^8K-bf(+R:8.b5;+4f5O8Ec>-N((2Ka5K?dIAL>#6YZ74;.2
fK7GLEAPAS@[5CL_N^)YaJ[5X+GG+N47^;MN;Z-1B8)=I#PX0SY^d#IYCU#\6bX4
[D?fbXY8B;,O&].=<P1C#eMb@@J,]3=OVHJ,?B&<++C.&b&=>ZI1TE/#0?P?MV9-
]g(a^Bf78>S9-T:N]Y2,X;O]QY=8>LFOI[WM8V4\V0J]]3:R+B0Xd]/#M$
`endprotected


`ifdef GUARD_SVT_VIP_GPIO_IF_SVI
  /**
   * Virtual interface to use for a VIP.
   * Valid only if 'hw_xtor_cfg' is null.
   */
  svt_gpio_vif vif;
`endif

// TODO:
// Need some constraints here

`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_gpio_configuration)
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
  extern function new(string name = "svt_gpio_configuration");
`endif // !`ifdef SVT_VMM_TECHNOLOGY

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_gpio_configuration)
//svt_vcs_lic_vip_protect
`protected
aOWOYF405?F]J9g1RQ59gb^;<S2IY9g.JZN&I-4<;P1Y?UD^@5fM,(T_KA=+2R6a
Of6C@#JM._:H#+JFJWNTed02[<a=.Q<I/aFQF-)U].101eI1-A36G&J:&,:29G82
OF+]F0DAH)<;Sb221U+X<53SNT7+<Z?FYbICF3L]3RS)/SC6>[+_<?V);0(_AUB^
11TLgG5.4YH;.OFUgbKRKHL&TH.FRV2#_3A1R)9aTP@X_Q-RQAJ5LUHW:=ONdgNN
IIZfbB#-O<)<,GC^;#HJ[VL&8$
`endprotected

  `svt_data_member_end(svt_gpio_configuration)

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
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_static_data(`SVT_DATA_BASE_TYPE to);

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_dynamic_data(`SVT_DATA_BASE_TYPE to);

`ifndef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Pack the dynamic objects and object queues as the default uvm_packer/ovm_packer
   * cannot create objects dynamically on the unpack.
   */
  extern virtual function void do_pack(`SVT_XVM(packer) packer);

  //----------------------------------------------------------------------------
  /**
   * Unpack the dynamic objects and object queues as the default uvm_packer/ovm_packer
   * cannot create objects dynamically on the unpack.
   */
  extern virtual function void do_unpack(`SVT_XVM(packer) packer);
`endif

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

endclass

//svt_vcs_lic_vip_protect
`protected
B]S_8LC?GAWO;M)Z4#OCT)fUP)A/YaRZ4Y+/>[U<7U<:;.JX7<()7(4:Z2-a#M._
G])6Q:cIM+B&W+0J&a,EHgB-6d)CP5/QZ&^7aCAD39<1c-ZM=+I_FRAMR=I79Z)&
()+=5\#;,Sd=/.4]?OY9N\#g8Zg@]X.[c>cLZG8BXURSgY7#U,0&@5G=&K,f=4c4
L#<\UC.^gcMPESL)XBG^]([R&76/9B?QOBJff^eQ_bL8\OC7R://<ID_/(A>Z7IL
QZ+a+KaD@MaPeC;b()a8b^7D[>E[<FN+R5(.LCNM^]E+/A;21/F#5C[U?_C]/Y;c
1M[I_QJ/;0KBcO:e:SZY_OEM=NWU647MG)2<RY3][HLT@H_4KJFOK#Y@Z4@95f)_
>,Tb,@MWV5a,AEb)4ae[1O^E2B<N_J83WP7S00;3>#g<[8P-[.O(/20E[dGP=-_#
Nb[1;dL9[\[<@?f0RH4@1CGIS&7/g1),C[6Z^+=GW9-PQHPULddaX57--F<>aa><
e,#4#KJ##RH](Oa:KJ2-@>D<&@\?[?O-dMGH_PU_9]#c>O^60H;,?/&[Y8SOdM,@
U/CH>f--QC&g;T\fO><SK8_@-[)#Nc6S1a2JD3(R_BG<]UU\<=-UYE/Y053I8&1\
W=>dI/:M)Y2aUb[Y0XU^FW?&Y83gK#>f\EF[HH<VK-W8]:0/C70VUU+/5/OKbNBT
=L<eCa)gA1QF3C#;6FST#SXLYFNJ#=c<Xc:R/SS6XP\<]aFXI:8/W)La1&TeUGK=
(W5e7;5D]])D;J6JM:Vg;b>8[?3B=6)R/?gGKYbd)gdR\T73_4B<e+8G)fd9=X(I
M90:7KVZb)-ERY>\QGCI)7e;_VC5Y:g@GGM&PfU@UI<PZ)F(3269QK/=3I;AV?@g
TW,1@7a?R:5dC0-6Tf^.e,G(C,E-O:SaCA1=O-gRPJbP),f5,aYR844,S3G^1.A>
4F\J8[Jcdf\VCgcD8FNBJKFaYb]c24H-4eRY=ZE^3f-.H^R2H;C9F+/[VTDdXET=
18Xd/]TDY3\,IdM6;WKV2ZbY7Df&TV5Q&EG^KcLCe95/MK-[S<f^0RO6[\-bYgG)
9=YJ/WEFYD#^g01ZZOQ_.#@T50Ra3geV5?-2_/C^/D>JS8P(eI7<3J9]?L:=9GXT
aV_9CeNR6/5UAR>PKDK/_2S@8M;e#@.B]Bb+UbSQX0+Fc&P30A&F3YAH2A3QP\=R
WgETEUQVWD/<)\aA5gR]Y3_&bG5KN\,TQ[YC1dEI8/c<VIZCb[E95>Z]=b4@dZI9
R82+-Oe/T,f1IO^Ue9^_V0>/Ca-;BCT@ZccW6LD?f&FGJ^GaaN9_S6:a?ZGUO?^M
R]?d(56>D4Q6&M:E#?047U#9+CUPX/;S.d==cRCTSJT^Mbc91?]XV-(-,X@9-TMH
HJNFE+b[Y^B^J]ATA6dFJ5=_d]\X\AWPH_E++60H:gC[5]:NYI^+0fNQU-bIeYUW
2IVTdFWa81Le^][=9/OAUS]1f]EFM#@G,cgUaXX/;,C,A8J,85[:g]@EeX55TRd+
E5c@AF91J4=@<30.+4+d@:A:26C=0=1=Eg73SY,/L(SS<]=_+8#]e##b.N=U&N]J
McRWJ\_VF\VRGA>_)))cXU5cM<DMNf[G>8::+fR?;P\3ERac=F.W,K+72=&OPW+D
\dUKN^1c1^=4f)F6M_3G+WHK]8b3:]9PK&G9/QAggN;.4[P-bf8PSdF(?NPK7fDF
B:BX/IHafD#Qd.4FBeV^U@0/NO>DeNNXA[[C6UZ(aB4DdI,RL:e?;,e4<4.VAdRg
67K8;\NZ930(3,76;X6;DS]0&?0?&CL?TfU=GB2Se?F-(ILDAfHW(8II>-([NbF+
R2DDA,_HX_65J^29b]=:Z]Pa(\[Y9OT+00eKH<ePNL1;M=>_YMdO4@+a-^+bcJN7
fVAU9BIZ67KDVd&1?X66TRaOW+.(d;YB(N9GD]^3G\CYZKHc)>Fb:PEZ+=.5Xbc)
662C2K8?CN:8PEH@OV[QRJ)AF7?@Xe/cgJ/X6DcZ6HU)>A@?6YgD5]IK,AX;_4P.
9WU4b^>NaO>REgHA-a44XL3\[5?@?;WNR^Y(=W]BA>9?>T+Kb<ZfdF2B>.+H8@/,
7F=<<>3g8gIDaZ@ScV7Y82OBKU[/G0DNFc1)2/-V4,O:dK]A)(2fKH2[G/d:54)3
5H8#P;(T?/cHI<&ZYC:Ie2UY)JU6:6e&J-:#2\6aDWCU;QE)01cHW@,HAJ&;3ga<
3.QHeUf[J]GZ.R<fEJDU<JT3?f[@]/K?-@E3gOV]DHGZ1PYW<NK&80c(]8@ID\?7
5@Pe.0U4_=da@&)aM2JXK0_2>0+-CI#Yd3,(_GVI9G]SI.Ve<)b[4:#+Nf<Xg>0g
RVQM\a@,/U(EV:P5W(]e<Ld;\95)_.GST0<B[.>N(GOA:]aN/WSG@85M7dRSY6g0
T^Z+YH(f-7#8I]fZc,@XT-Ge:g.F5.;3JR[7I.4bcO+<FIJfM?W?;f#;^(f5787D
WJ(>eS,PGYR<DC?g#MOV7TL/+5<CSC?fY2.SFP6W5+@<#=^\3+L\36eC\?.6.PD2
6_#AF;(bVTRQW8egFB4J:4U[07YIENbJB0[A^SXd?8eW,?V:8cOD2Og)d#D,VJ9G
#(+Z?EW8::E29[JE0dV#:^a,C+E6T0HF2\=&O,.0DA=Q=(e_6+fALEbJ//6QHT6X
1NLWP^YJUH/V075U327Y6ed5ZVF;=6)/N\431H/f4d&S2L7]-3eGMR-OSVda.&P]
7S^4T9X>&1]R?XE&HXT&,JL@Cc^)II_?Wf+Ka+:9JQ_GAFf/(PC4VO4RS_71<.SC
X_2ZWG@AS>JNJ6;LV#<W6C5GL7b@e)e1WWK1)bFLM4D=UKA/LM;e1F<1c7X;U?PM
EG5SNb?5./S4WOJf<-bBHRQC+;]([Qc]U-M#@f:3M:J(VWI>?/,U&_RdG_=W=)O-
<2LL@I#0f=&PB5JGF^(DV:e9g\1/Oe2E6N+b;V.=e0&H1\O/8NZ3G.7W;_4X[(Pd
fBOXJ57I^Sc#5Aa.78R/)XYWLJKd=04eJOY>N-BdE88=][G_2<MM@(])Z0d56EEK
>eR#OON+>7=#-Q;#]f=fXU=RA6e@,Q)@9Yd+bKRMC4[6U+.8U&e(])->9:?P57[.
HD7=b6UdccKc;45L0/8_/<6/R)HeLE;&D[_Z6U]_;SQE;RA467FL)LUEX,(X^b_P
/)G[U]OaYceb[0WGTHe@(#H\5AE[PJb;C/@^DCdbT6#Z(F^U[(POA6Q0&/V<gVJW
.fPg@=NR8GM3^65L,&(4J&::Y1(QZQH)SgD-8?(BL0^]Z]?8<YMZJ?3M,UM3+++[
=P/>2d+1N=^@b[(_W2W0T-A/Yfc\N_)aX5gBRd39=EWNL_R>T+eCQZJ(c7(geL/&
LcLB26cC>80]Yc0&JU+a1?b#(V[8DE0G;7<\AOSPV^[R<WMbN0^d3JeYdeYE#a3+
H]c(P6?X5c:)8TLYRc_YEH4[>_@125V_f6fMH[G2/a+=&B_YTb\D=2R2&LVd@91@
L:59C#)HY]I<)TL1109Ha-JG-[Sf)9P34&A>:e&E,#A3&4f&I^D;CF(b[JS(GZ\E
P1OB#@Ib:G9/fZN[L>(MC=e,Re):NG>/Fg7fQ<IXAMgVP2Rbf_VNN5M9UG(DOWWY
XK3?OJ9QRVFXa>GQ#0,4=+LMN7cV78^T:]M<_6&[S(89??^A0aI#U?/S<XdA/&->
D)?G&W<N(N7VWHJ\)gGH4,4+fUdSDVVe&?LQX8?URf@@SNMLMS7:Z8\R9\.W>JE-
A.Q+FT\C;[ZHR/S@_93WR39TYQf5V,d7=agL]0W)-?5:2^8;:fBB:g9X-RXL7HdP
fdKRZ)EQ).Y>L=0:6_cF#]1WC+._G+Mc#R5R--]R.4:]X,#XL.OFZf,X(0C/CWUS
+9ZGE]E8&)+R7853::/a2EYG..e^.D7&b\0/:JP<Sba.0W?#+57D1O__;P^0;M_W
(JD7P0eC.-eNYE1D-[B#7CV?U:5WDQPP>&,;M,0T.S>-E0KGYL;fE=;Z?S&+U7.S
9>7fUFQ5^FJ(dY?PYf1Yf=6Q8e-Y<^<8eJf\CX3D]4FM(C@+PK7Gfa]eQ-=K<GgF
3^R,4E?41VK@YR.5Fad;8ef=PQ2\Y[[a[JM/e-\RNGI+9(CB4Rf[<Ae32g(DUBI<
K\XYGd[P+M:-4e.>8&9&7WYU?,EP-VV=L&H2X&GC/VZgdM_2?dY<@IDL/GUfR@5J
b)4?N_?..#BL46]INNHeW[<A:a-F+X/#96=+,8(6:D0,4<I.65TbNdec^Y];PF8/
J)gfPd39(Q(&]RdLa\#WC=D&D2\4O83#1g].T<[I[V9>&SJP:Bc?PXbRJ+]a.8O0
6:H-d&0DR/HSTS>CFA>445FeUC+.,)/+>IO2,(WCIgU)6SO#Y)5E2#276EB[JLa+
QGYG2W=RDaS&?[C,((D?&-\LH(4M_3-_E?Ha/)I-LRdBS76/NE)&,g8f85/c.RDb
.BFJEB6a^dQ(DS?L7Q\?AZZI@H()IeL8>cFF3cG?bbbL)^9/GAY;,4DV5,K:b=EZ
gGgIW[.[[EbK=6;cN,8Se=#,YDCdV-Nd3:RV-^eccAJf_cMJ(+1JYDg7(gZ)GO(6
DYY;a<E;RWVEU\F9GN1fK&91E217Y(.4(0-5\R.V/_;G4JeT;W9)&U1<1AHEb_D0
^3^UH2->4bONf,LFWT07\6Jg(J6,dcUBMI+/fNFA:><AW:>N9ROTKRD_\-G@/\/O
DW0W9N-L3efT[eB9ITTe90>Q;RZS<^W2V2X=9Q]1=P>KA:Wf)[TL2ACd-2/17J8K
WDE/L=I?@&I0?B91N;;W\dfY-D39OR&EC=+AUB3BJ;.RO61][>;5R6^).HB?O3c)
X-W@2T&BeMXJ]DEX(2LH@R?=@Q,\DS3d+MX&aUE&@9S#<:3CVEM?&8F\aX@-B6.c
#XYF-QL]YE0TAM)+ddX#Yg?EDb]_e)B4^;B[QXOL6()Z7?A(Ff_JCUF,E8JSQ9,4
B=+V=D#M^(NA6?8dN.3)JW2^BOd1Q)>4HX8EU-NV(45I;>;SV4<@[5Z_[PY:?Z3:
S-B&+[W_H-4QbL@IH[>@_K7_aZDXJJ9eY#ECULcURd/7N_<6(]A#G76a:U9aRd\[
LXLV5_GaN?:/>2P8(>1d@]VaEM&:@K:SSc?)OL;;gQAB6TU:N80;78XM8AT6CCcB
U[:#D;1]Y?d[4XLZK^HBOgW8ET<LMe^E6VRA>Q9VF&JN(1HKe;/1F8F+d.cNZYG)
;&,[Mc?HW#EC2#(@eD6C]2.;HKXdbN1S<0BP#5LJQ/.3-N<cOWg]&EDI?_ZF]g#e
][0Nf8<e/<.5R87M,60V81DMW^7fT30+HIIO9_M>10f[&&WEOdCcY0]:C3EM,J&G
<GY?-5U4FGKM2BSZee_5>8+(eVTJE2WFBKfTYbB7VPI[G79;:PB(]P]7=2g/:QIW
g=AE_N+JHG;=7GIIF)C3N8OCaRT;YQ[\WVfVbIa<\Cg4Q9^EAA@EVU2&G)00;N-4
5M9]7IJ#6R+:A&\]-gR6-W8=e-9R@Z7Q8\3cZcX.VD:11-Ja,T\#5REC8T6;HCbF
WJE?+3NaKQ=)5>U>MQGTFePZC7JIIO+<^=+Gfd(^_A8D->>gG1>CXZ-eMWUBV^6<
9)PE-P4I/.3DV.KMGL058aLP55\ELb.fQ[DU\)#APe9EI]PY+eMMXbY@6I?#DUCE
U&a/C)1N;UXc/GGH&>g-FUX0U43<981VK98<M1N,WZ/PE@^#>F/7;3KeA435CDa3
fUOHT/6?]LZ6\?MObU:]:@.=?[AWcS-]2AT-J7fF?Md#F>4FQ.8^M\9)GDLVM#]\
5Q1Q[-P236?744T1Eg.Y.0?Kb07D]&UUB.I#+g9Yb\,#2L1Q,QbAb8P@S3TV-PS8
Ca,B[D9WM,FDXJI/^HaeP5>aRZ3)TOMf6c\eRJMC0-LKA51d+SdFI+4NAD.Be\?3
8>]X9;7.(UdIN<c1aG;WD8+YOR?ZTfMN?d7[W>b.)@0)c?0f_&F.W]Z7[->=:<^\
FeUPd;BdI[eN]bfUba7\G@XGa)ge,OFSeGC0SGSBb+NdX.._#.&fV.eZVSQ?KM76
/1H=C63g,@dD]5+W[0P\^a9Q[QO>@X+^>0Y1eT.FCRKH;:9;XIH^JcL)\7TX)[;Y
YP>eF@-+MO8-2-^XSH_?4>Gb7]-&3,XGJJcD/-#YT&#;P=L++a&IT)@.+EbV[WeD
DKd+Y^R(H/3YR4L82S<>L&3L:KD?B7AYR):Y6<&R>AR9/D3U8W,AW_W1GLS9PRUF
g-J[[-SV+,;)O?1M&7-ZJXNae<O+3R5X@BBgTc0T\WC8XJ]]Z/Q(,^O>I]L5/-O2
JX#:OP<I\@Z>RD#DWKOG4A5&_27>[3:GYMBH,1?#KDc0@\W(3XN3(Y/W(B&W38M]
TMKZ)(,acHaHG4]?JVZ..ddV6<.R@#539Y5BLTNFBS57,K.BGe7XQ2GTC:QM,]0\
/e)JOSH/G\DQeED44aCed&8OY&A1]TF<D=J3F2\Q4AY[G)\[(LYX<ATH_;AXE]+<
dEN7(S34V+4=8Z#P?:eOBZ/GO40K(Q+@RB&e[_H&QR9850_=_GM,MS+KMaHF(HI,
#@].gRRN@)]LHFbI/V3MQ#.09OLa/Ld/(<P77fPKMK7F&L=CaA]T6I5Y;c(_/5BP
GC1g,]9WQe^#EZ@3^TXE>K1[b]Z.K(.(N&>LS6[cMcA[F7)cW.3ZQQ9/fL@?);UQ
(8#c,B-016M?I(6M0_B.90EebNgR+4aBE+T8;97FL6aI@AP^^KXY9(D]egJ,c6;M
fdEWDG7agIXNNUD2,?R5^6OCP7b,VM6\=[K2YZXMff_0#:_0H7(;Fb.]Yf]CZUD#
YV97(A(1J3AgV41YCY98F/;Y00_G[fV2&OJ]@C)7DXM<7N0(J&>HcKCE[#M=@GW1
:)IWZ6LPf=Sg\CYQ?7<G]:1M(227d(7Rc+S)0V]f=GH:PBTZW-NI;@0P?[N>5\UZ
F5eG1HA/Ie?efJ8]UPD#]4H/WX4U9&1>VdR,e+cR--TeUWEJ86b,(5((1.FARKSQ
)XT6cQVSIW/H,ge8W]<O\fgX0ef.DE2B8)C)N7HB]11CQ=fJd8Qd8fUa9F>/Q->4
)BHCRTOYNF(R+f(>P3(KYFOIEZNa&@GbXf1^.]3c\12>S3R>#C#PYM.YQ\SSK33^
OGAT?afF<]WCH2>9H4:EXH,g]Z\M,[59,N45^e[g/g\EE?X<=J8H>>@5EP]BJc.3
5CCR>+^PQ)U1Kd_+3],a[U?3TIDMPP3ENP/A)@_YUVeB598]\[6/W.eCJ@4:0,fb
eHd3</eUQ6d[[V>MG_Nff@TX&5;ME:_<0VW4CM&)gP0+\S)GSbBJU)O/ZfKM#]L+
C6..fIQ@66U]>@JTOgQ,M=Ud51K_-X@ZACG-UP3.A@YL3V88bSL],bEc(WH65>He
,XC8R/<2]D7cDW_.M+6>9aWF0]ca4I)X5OB1Qa+c)8X9f>)FT.2cB&,XeM9RSgG(
Z^IUA#N8IX6e<bNKG1GF(M\?R.FM6>70eSaQV=\&:EV^E>:\c7I(@N1?,ReYF^>8
S:[?D5_/S)Mc6QGNFR_9THJWTA03d/;f@8,M+.O:e#,GOBCXLb(>Ff,,]E87G8=7
:S+LSSNgN?+_C;YRE#USe&?Q=HJGUSM]A<4,H-Y[<H)d;2,W<OH#Mg5Xc/Ue-DeB
-.RV<dDWQ3V)>QDfIKVa@S>S>PP./D]UP)9V?^1BfEM3[L6_4H&V.^865P/L.;f?
+g.1PaU8g+LggCU-SN2[aET<-U+4eNg8S&dV?fQ8_,cb/,SA)KH>9J-5].6&GR2@
e1.HXY;c:gEKJE<X)Y,De8F+&1<71cQ@W4GVI7d02;)1PX,?(<1JJ4g=B2TX@\](
VPWUYAELHZa6X:OD\?Jb2OYae(@-cbcV1H+&Y--2JI-SQ+BWIWS-->aW^)LEd\IH
,Q/a]^L,&Xe?6GZ569-XbV[Fd#d=D7A)Bc7&:<Y36b4^&1:O#Y7#3:@30d42,T37
ac?1]4aZ=_G_aB^^+SK528B3gGTTbUVEYL_(]L0AB=@Cc607NA#I2^MKK&Y#;K@T
ZB6g4+Y/6a^Gf0@LggG&A7+Q3/de(RbZ_>+&M3?4b+1/A]E-=1DP;Q[3PY\C/=XV
G)>&3Xf-G[b-]UU4XDZ+0(Yf/9L/Kf[QW.1]166G?X?AC8#R)RTGd;a:NH/Q:EK4
<eS8S0M[P1c\82E32#>U(,UN@YN7CWg&6#@GNC&8T/]e#34S;8JC+YBMZ/^+.aQX
O&f)&5JB.Mfg^?5FQ6725XJ5C_T5fO1-a4\gJ8)6D?>I@dd]AK>^FPHD(:@7gKDf
8I7]/Vcc8&?92QLP#A1L\@M5LTM6MHf_)?dgB>JcG(7-YY_+]@]EW2O.\e4/6>-d
IbJ8TZb.BDP]]&@6?<E9K6c5geCKX:]>GeZS5QCEZ)\\SL^\A]OB>N-dO>T66g/V
H-=XE-\]S+2H<D\F?KLL?eSfDKY0>KRcN(C[d-^YT9eWR]^D\=bQ7+5_@)f1,6&8
BgZ6<B?1VRI[QFVK9:G3dce<eL24MB0#S.5//KC\XEd6B/F#(_>/JCVa1[C8D+ff
6J4;_DYe952^F@/(6LgXfGLLU&UO_UWBC3RT(YgIFX\OT_@f[-E+eFd.=HS/-?Q=
/?Z?Y^I3P0a,#4bYdAdVN))20e>43CE]&],=N7Ogd0D+eCCZ=/g,O=dH>cD+M@AQ
V4S9A_2^D8]H2BVHLTQV>D_.6\>-#<O=]3&QFfAT0LM2Sdf2<a?b::Q4^\^Q2=CI
4Z6L_.DX^HH[<-=c]&OSCf0KI[Y6D1C4S&,IeS>XHdY^3?g#>]5PU?,ef5H])]/.
g<^K=@GcbHQJ(7FW6\Z\#<&&^C#2((K8SffN?0f(@RN(^#=^Id-QR.EI;?Mc::#E
;NeXL[WQMA45)0IJSD1,+<\,IJ[gcGGg=YF^>DXa4GHH.+e;MM\XZLY<E\G\H_)F
?J;d6]O012;<4geVV>WK>5bW^O&CYMY5DXdPe.@6QLJW^Z=ZDbgJ=GNIDE(35Ge.
(90NJ7)M6;T9^UP[A8OANC>b6940YW7G,_I,6.:QZ>S=_>0/W:f\KR@W5<JF?7Kf
9/LR02;/\QATCH4Ud)YQE6-0]39;5AN:KgI+JM7f^aZ&Fd<7YH-6MV+13?T6&Q&d
O;?UD.5=#<UbaeY9;_&Jd8HAFL#F^P[5d56NR9d8Se1T@I74;S97[<7\7,XTdV7c
gJ7PD0cVY8X]8YX2;B)O:H_gB2[PH,S^O@Dcag_7f^[]M2WI?V1.Y/e8RM[\W^E4
Vg(XYV^]SgVg)W[\.8,Ze>RVEQ0>+Y2EQ\]a3#1D+:_K=G9U,]7?Ud1L9,Mdd@UC
:;K.I0P@)-SQTK8AHV5C:PYK.;M,\DabJA=T3\7HZ0Mb)@T[)9OOLMH=&PGcUMY;
9UXB<CW9E7MRG?+Z_G90YRMY7Z=&#bPK4)6IZ(DED+fa.[FB@W-CeA7)GbE:[&C6
RMfeXWEeC(Tdbfd-R4>)H@<IM06[e]B(J0ZgY]JT-G&0]g79/.=-d[?(6)1:cB8O
c\)G/HOQ^cgacZSE-FOTHC8>#Ra/A=5SHF<>+VH&YT&G,YIKJ7@aV[GZXT-d:UY5
.F#:39;a-64+=WG#H_U;4Y?:0DKQQ&@9Y&W&2\170a@\K.&G:D.4gA6^:[(<\TLd
1<\@&8ONH2R^d/Y@LU:=BDS.]PH.1g^XX;4,&UJbd&7L2BC#K5Y1QH\Vd2M&G(\S
c-7GS&d>:=dXRW[,Z-KT2;=LfPPI0bc(5M8=CC?ebC<2c>;(UU@aGQ+9\W)XK>RM
IA:L,TeZ?VgL#_D=LKOc;09dYcB0GD=]cH]1T,ZT1P(YKY:a:S(.B(AKc6^QY5IG
>O6EKU^;QBUN:0TAL&bBQ?6-:N&2(SdX4+^5.M]H5E#@VaL0#3/4LW/,;/;U)dfU
JC;-[\+3BgJ:R(0O5,BA]6?J9^WPU;^/-3=?#cN2Q0V:W:L0<NZfZJZfKJH_09V1
dMC@WA:+4]<;M+,;afDO.GH8VDC.;1_a3-T)Y1+f_9);VD?45AAPAE7R)NE8;\Q[
]FHNZX^;X&.2J=5ZXTU-())/+9GDI?>9D7:G5Z?3;)E6cF[QW[N@,,STD\M7B6Y?
58VU6eTU?H/,:KWU,&Z9WV6V6_4,HC0>RJW^94QeY2\0Lf+6YX]+3T0cT.Q;fU8^
d+^Ia5Q5.f>AME-^=BYM4GQ>dCg:MB.\C03[N:6@fTE<^72,TH2aY<0]bJ9Z3e)a
,>H_:a,D4B.+@g(TX=EGaVW/^I(EZ#/6-K\Z=0_\.<Y_Tc;VZ\R<SS5\.69J8@A8
+^O(<>S^?;1[g7=^PcFKKGMUXEM>.WZKRZ;g^B\SMKO:EHN]<41<S/]WP6@1XZOU
_eQ-K3;+A&[OaB=W;T9-I@Lc<#(ZL;3VHG=[;\=+OQ[MON9C:#B<U<f:3/:V;Y8Q
_:f6T>+<&U)M3G<Y(+E_D<(XL@ZZRLdL3]aEAbIU^&g#_+;7M58&R8d/#2&FMZNe
VTPd#fd2WNX15P\NbNZ6@L#fTKWga@O/9^HVa<1L4@<JaKSBG->J?2,/^Ca411]f
P:L9;9]+]f5C>Rb1-2W]bcJ#<WYf13DI36HRf=?9e&O;gSO7eMZ]OQ.+8G]f9gVU
7#]e4=Ta1-eL.L2.GUUXgJT>Yd8NC7Y1VL^XcWC,P[,eBN=JQdD,Bc>aV7>VKVZD
DJ5H5^d+B7&91W)?+IIGe;<#NF]c.WV4GGE)L76FSGO<#5-[#THbWG-&f-U];\:+
>>D.>9JF]K<RVSLdPDQR03=<G=g6#G;TScVH00GC8DP/R:8gZOL=Nc-:9JP?/a\^
=.TZVR]#-g>dUILgQ.KMdKcZJbV#-gHMa4&/-L9@.T+VMOK9g.G8YYd>R.>4Xc04
-3QJIbZ.&d,<&a&@REOZN;:V/SBI&5IZ+]F#18>gY:+&BUES;c=\>e(5]DEQI\cb
;]+EC=JN#ed/V=R]))YaO5b=NUf4.I,[2b6DdF3dRUEYX]JU)3=N(IOc5R44;7Xb
<GXa/:B:NCC^-F(U@](De+9L8VW:@[>X4G1=Y?F[2La<P^>9)_&AdT+&b.H/-S1P
c)eI:N:WbJ)ggV(;2UM,.+GXO&#>XRYWU7<&SH^;4P;1A1R?0VEY<VaCg(1Y-MG,
]W5N([<RRK2RW>?.-NCM?=cX08_YICc.>27_Y9c0g.Ie8&b#)IJ3&&NfS2eacCA_
Ee138VZC(=.9_e5USI91N):(T)\_4b2c^[ZTK9PN/GLZd6K-4^CO\eg,X2dgAH_E
LN./7=&_Mg6]60R&[M&Sf;5Mb74f+6F71YKP@(L?]e\KZ2HZY-g\(==UeOZXIYEF
/d0,-JC[\S]_0#A8Vc(F]9?)APA82?^gZKfYBcYU9+P:KE<L1\6SUXVBN6c.S&:)
>5PJ_e<1K9A^bGcJGU#>GW2D689CDULQ0DYCW(RDF8cDWTHW3:_GO^^=<U\NHNVf
\[fe:0J^6[25CBQU4OM/1JDT-aEbE8eQe&eE-b?7W,J1C\55@0fd(BQZ)8(.AJaX
B&d;L\+6U]T(PO15PSSe8_),@FZ+R(]^(.X[&C4a.)9N/LcOB/T>K#ScNGH2e\](
KRR.:C0Bc-g.:2>b(a,-3^:JaK[&7dDL5-0GZV.YP)RR:49)+#DY82ATGAc)4g?V
ZbcS)3G)&G4=4Wd129_3GK,?fQ#LYW()+POX1(K#7<e52APJVD]3gR)cQ3g6.PP>
+c7.\>A1KNUA42Hca^H4LU6;.c[)a<XC:Q\UC,VN;eP[N595D#++I@9?4M[NHK0P
+<aC)NHaO+&@+&KdP^):(eWA1gb@@8?-9BV[.VZK#6T);6F<3Naa.Z:5<Df>8edU
L_ba+f0J_+bO(Le/R/2Q+2D3_a<3W)C2_C^<M4,5A\eMC#96W.QRZ\N?+NAe&A38
H-c/g>bfH<M,@]B&0gT1Y>TNeadIQ;Y::]3)(V,;WebJZ+I<G\[0dKaX768V8A@b
QH#[/<15J-^=[(-e5PVJ\FUKN/EOG7#QT1@R,d+0C0W<b;A6+AbH6Gg+:U.:Fa^3
dcBX.5?1EI,W/H#Y/54CP.O<3)NR^K)Wc7(@KPQ8@IP3P?B+([A5:a@&gO:d<^67
De9g[VGJW;g:J?@a_DTdVU?3Od-\T=cedBD?N,;\,EL\DLN<+/,=@^<W?\(Zb@K]
I?+a9QWegPIC/]&65Hd9-I55HCV0e/I2AMG=<JHcI4N83?JN56K.<GM]AZ^b9GW#
.;CGA:2411@cJ.#-&3@d_)?4@bPJRcI^B?2953X9]=VbHaW3agRYRHCE1]T?[4;Y
V;VHc<,AgH\(Ta<C+_8_KebZ7g+/0V0EeCPI/C:A1X]SP;Ta\B?#U>\PTbe,0Fe1
c1VCK9KADM-Vg;C3BN/cYBJD@EPX2]f,M_?I]_);2eGW(#/8a5.Z0S1+9^Y8Hd#U
^#?)=ZH:ZEU+88/9>I(N.[#<PLJW]>Y#9;[aP\(:gML>:V#W/Bfc@Q0MTG@C-S(U
U7&1YX[[9C4XY^V)R_\e0M;4OcR=TI31ZNIS:O=R+\WPXa\]OT8=^4]=C=/)HA[:
<.G4L0GZ(A5HJ?VQ]6.C_UbO8>cB4Qb+_?g?MedKM[+MUdN7@_]]&ANbPMTS;4<C
2EC#V;73,@MI5I<A#Q7Q,R0b4G&bSPWTJIIV0+5,AH2&M#;_W_DN.FG[@TaMG(ZU
5R<Q)JD86(2BC=H9?_-XH->&34(=+e@DLH?ZUQW-/?>gU#C7[]5gJ=5dGR6WO49Q
[MW^C4c&P;R5ENfb=;49RJI.RW2[\G.YWcKT4<4.K9dOGaY_Q15Z;+W@@E(TQ..V
L/<\1V>KI1E;LP;BFGB(#)eB)Dc:AdBH9_e2cJ]ZQ1ML0ZEfBf?R:a>[c&=4DV:<
@^P6Eg5<J;_fE;I93S=ObAH[9F0MF/c7M[#U_^BQTeY_=&:7E<D.:F+eM_<X_2LL
.@W/M#25RRI<Z>?53,aJA#4R;6K;R?\MUS>&_RH+K^6?=[U&YN(b#C4VN-e,M)B0
?-^^A9_3b.7G[AK]=&.4:AJK-B7IRMFV9TPfa>R7OV2E6L]b6STPICNW>/]/g2IB
UGR(H[/-C&&\KgSg5-.-WBA95QM+Y3cE+I^NJB2RQWNR6bG1GMG&-X=9WKI]HgHE
ZZ>CbUeG,/f4C#4BF:KWCgTE@3E;,OMBOAcMKf=U))-=</4TB_b;<&G/IQ1XQS+F
=VS(=+NL2X,__:[4>MZ\AO@>@)cF1;AZS)J6VM,;#842A&bI6#0gbR,4I#MXdf[Z
SJFYbaJJc9YS176NS;US,R4g;a1L[KRRZ:[Rdbe@,e.3;fb]),,=OINQ@Rf-OFd>
Y]b9X5W/VONIg]f2YdNaI4c7L;XCT\/C&WP??.O4RgY/F+g9FLLURc0(bVPDY.Y2
0Y@8ObOg[Td_NTb4cV<_M,/d4+SJ)R9<#H9@6ZCD-O,15V)2c>B:Pb+/^#aN>53U
4.a_bTOBZ;4LU_/<>^4A65K1+_E0KI-B2DG);BN]fDZI&KY@1QVCa;OS.^P+)db=
3c0^U0;J)HF[&UOXZCFGN\\C3c]1f-3CN<,KROHL]C)A0,G;9(H>#[_1(,.c_A/O
^gNc/R>R])4D95+SZL.T@4DF;RBIUI0(:<@/[bN,BNC<]gSZKU,0NU)eH?1K^RVM
Y:b1&dY08Fa.@V;c+,1b=Q,)QV,Zf-YD7\6+Q9R1E3<NP\KNMGMYd0<M;;Sg>7:;
6<J-c=2X9UaLcW;3>g-FN3++-Y_@#[G&T[YB\<Hb.AP_1&^\H&Z<7eQ<@#)3Hc+Z
N5V]TEMd@U4X(J.OZZAd5-Z)WU[=d_E,7#XJ7V;@#@C1=beBX>:]AQN)MV+XUK?<
HU0cJ&^A/<E4+FfdWb&-UfEQ<&@)/W1G8A+:8,cMccBD-:MPOY:]QN[EYZ,^E0>,
/+AbS[L?#ULKa9-[dK@KWIK-J5^V]Z#eHc;(;+(Tc]VN+&LOP)6,c]fS/J=g60;M
6MU>N2X#4D,H)\+#b)Q?8N[VPQ[W_X2R6XI>(/d&XCe)<@M[ZZ#[(^XE,Zf48-#F
[3IZ1F).]XGQa8fHE7_QFd/bPDH[Y7:I>f&1-;aMT.CDYSWc-T<XDE,AID<];)\8
_a^eZE@J0@->5IDMZ798VYG\2#<TA57=If(]QRB#I@5FB0?+R<P2E+EGZP3E4X(3
b47ZMTH#2B4[__;fD<YV4ELGH#MMMYN.>G8f<C&N^BOIfN6,d/2=/>>C51f^/E.X
K[BY2MeT7FJJ+8EC8g8MB?_b7fQFA+(_39S.MB6a7&[QJYQ=fBBQ<V/;P5WT^/a5
0JL9@b[J1&ScJME\eK?8SZ>]+RP^[=7+a4^RfYK/?-HL3&)OW,fCff]Q]0G.NGO-
b>1)4.8WfT4g.V>2+\[K_f&EH?D(gD1W-3J9PLG@[>F2:fH:GYHXI<-;@_J)(gVa
0.V2:?H.0,ZJEQ,TSaK-fK/@KNTTDYP>0:N2^4L#5(.2#,M^(9GMJV81a7+AOV?X
9M_-,1W4GAH1CKTLTd3NBD5E(1#VF.Ee<#J1DR,#P,44A9[X+Y^\?O(ZU.,g&;F]
6Jb)R5^UX#b2\f.8-JYR,-KH^5.M/NNZ1X?0:(;H9NWQZK&]IEXOE=XG31X40LB&
?eWd?8QI_cECN[<2QaGU0S6OT5S_IR4Z+bEEfY9/&fE?K7b?Q,fbc?>dU(WNc;V[
I1N-Z>:b5V(#9?-(+f7Je=_5A_H.3EbaQ69UDg5\+=O-,:7F1XP<e8?a8NA[/f02
M4-:HFL6W\06?[C,S/K=SO)MLQ&3^_ELL?>&?+Bg^=Z_/TWC[1H<8OAGb-09c5:N
-J?1d&V[I2]KC[66C>\D(_,d)5_7Ab-M46783de9XR[17,Q?S>&O5E>-,:,e)bDV
BA]TXWSPS8F;A01Q]3R?^Y>/]ec)H,B&/?M<L?JC,@;?W+AG3D)6PCYMH<_Q^E:Q
eAXZJ5_TV0E<<<CB0^#cBg]g9>Ac\gbRJG);PUYO)-2MXP]\Eg/4WIIPF15Y\0QU
<E&YAIEbI:8gZ41+^U<f6dNY\e;e-IO8B:=,,NcM2#64ba=eXVOWX(X?<TNLH.9<
3<fJYNe/e=a,CO)&&;4gJL785@_ePATec;+e[+(W^d;]Q=;]JZ\Wb>e@\g2BW._X
#Db@<.:CD.<M[YB4/E1@VQ6Rb@#dTf@J6:C)_-P_Z,fTA?UO.CffEWGdC0@G=P9b
Db&X-(M\@cJK[+c16U4H(36[]6D?Z9&R/fKEJ53V]/P),F9c+YW)cS8>)14F@G/e
SK5/T=Fc9b(]TBF26@^V]89XeZ&TE]0J<Q&eL.BB#8\0S#P\BH/I6N#7dPMN6.dS
VDg[;SE9U#^g_?@F\eL@b\/08)XfNKe^E9,f@=dWBHC:5MR42b+Q9T3::J1gVH?+
]=3eDBTGQc00=2;7[)BTIa/3-a^50,Te1<A3PL_TCR.LL+W(79VPAf;.6>VP7CUS
cZ_,LIa.ZRcHe&e)bVZ4=G77LOZ,>I>f;b8/3e+Z+=Q8/FHV/[6.UA24\OEgd5g0
;LAD5]GKL]6gT)7E[8dYSJ_VESOM?.NP@&O-+\c,f<\ALCeEYWZ7@L3I.0_W>75T
Ocd6/8&BZe\WeOR8XeMC4UF.UV5S(L)/7;fYR\5FQd6cgWaKN>NTce-&9?Q3NMOA
(f6<?a3^2Q;,O[,WOL=^/VQZ+/a(c-5c)>X#]d2PXB0AHP+R\:F5ZNENWE5X_5aE
_F(?DKVZ].c153aPIL(fQO?P^/@N^e6c+?XTW.1e+PLd,+L4#?8g7Ogd@d(g[+FL
5_2M:+Wcf5QBBg>g?3ACfbC8<Ya2\>JN7-LT^:EY1RfY)U2OW2I/0+_B\E/AWI,:
KYg6)_]GbV\ac/Q/Q+F-6TeG(a<?.U:5Q.0/g#Y64(.L\6e=]G6=>gLX1#,[a8fV
5b8PIJ=La<JT@f(2Yd(D+VdK1@b#:6Z:&66E0DgP8&@8fUK\1dcE\#1KFd/7A:2E
e3Wa6]MQ_GbGb^+W@=9M:XT0Hdf]E3UI.2bR2V.L+-)7>=SY^T_X6:YC>UCJR)L&
##/Z&[X[@OFKS7].(Z8H5(@I13&F]OJ3@Y;5>XI<FW[E<JOb(>(I1d.f#A#eGXc#
@]IML\4O:G]UUC]6#?5C^X20+aQ(((1(^0YR/GM]E&:V2B\2OSfLPEX[,(S:@6Fb
GFC6dQ[\9Cb9PA?NRS.b^79[1O\fb(>NcZE2)=f4PaIYK,RTM:BdX@8]B=8HZ.;_
Q(I34SERQRN225Q+WU70cL7Q8L2V_d?(D>eP#OgYBFCQUUTdW-J+QaRIH.U-PJ?M
3SgH;SM[eKBM6f3C.DIb?bQDG0W,;0R@E:;80.D_(ZJcU+aV]Y\7NgO^8RBIF1^[
X?GdbGC0:?(<7#G#B)KHa,E\612S12b44fV:Z3;IE1VP9=JLTVEf8X.ZDV>da1^B
&e2;D,K[R_e0Sf7936>aJ)</fcY,L6F.6T4ST\67afaWYX[Nbe@ONV0]:O+Y,&2D
;^L6-3FEDfEFO<M_V1[^PUU1EW/N.K^gdO60FP5Jc-#BVFX4f\T&U/EI7H4U>,M=
FAVWdBNXU+=LLc#c-d9W#?LET,#d9/F7AH8=2PR1>/[Y26;(fA/Q&#99BF4QYa/4
CAAU6JH_f=#E\=@R[Ac]A4C[N_N=I:4(2agWLF]_K>[VH&,G00<(OF^f7X[bJJ40
KS+VgTL4fPVE7V__FM3C<Y#5@^3c4O9ZCTS7<&MMgHgGPA6Qd_0cW0Z-+g3U]F)X
^e4Z86E+Y3O-O2V7;\M64VI?&,<Kd^U,B+(@1eSEUB5QeRQ(7CG5c9CO:cAfcW,-
K>S?ebgXSfUe^JBcNY4KSU??,V?)9+Ie+7:0VGT-4,-UbJgSfFN2()/<Ag=-Z4Le
>g35+<cRFV+/5&Z,fNMC0MZXS#4=M370C/RRS57+aFR_cO^JOINU;E37.O\48^6G
Dc:.7L\)d\8B.-,&,1L)F_H415?J86gI3F,#Uf1G#\O:=c:59=J\?N.-;f#Ta/dg
J_<Fd?3W\ESB8/e#-;&2EM0)DHE_^WNg6V^LgE#X_()X5U^X:\Y38.,S\J,;dZN:
U@IS=VPZR/aQ=_9Z0eONgQ.[fL_X?T^1+Q>:=.8d]QS-@_S0HV>E>P<;Jd.?)4<+
W-McXNN0O0;5B07U4NaV(.7MX9:8fAeD2e5ff9fHU?28LZ69-23+L<3/Q\W)UPJH
)/VfXTPd2a;_e>PWB-YA7(#66N\S.M3L1NE(FWUeOJ3MXf.&>aGB8+O(M9HIe8[b
G@CC-D_gD/aKH0a.T[,7UdJX3cV+2b1@U;5F;a:()S37ODDeU_acd;d4.c/V=/KJ
D/=@PDG_+<.<M9;GX,?N248a&^\Za6?Z]>N;WG_PTU]VI9GHU)1aeFH&6/-)6:VO
eb]@b2N<0&J5)H0:?8>V>P2MG6V)5KKPH9XKPFJ&A#\RBS)8S>0>MW?,X]8\0A;X
ACb#W883>X8:L6T^?ELK[VS9XKE#[#&b:S46NFXX?W(\L;QDDdN86^V9L9(G+=IC
X5?]F-E_YNJ&D<3/PP<Q>BQ.4AHf&FXdQX<LLTWA7HeJaO4@D,@9cA9EDS0GK-CQ
SG&L<XK9#R.MT.Ue]g2+>>6B1M\P]RC76E6RGN;8V<0cHX9#8T:0MBZ_6PC4Q@Y?
M4bBD,8>>XKEcdXC-^)Y04#f,[6Q5](g,?49?W:8??5ZK4a4c5?AVad^7BX@F,b6
PBW;T8>Q/;SJ^9dWKG-T,3T@[5FTOE2;61>:;>VQV>X]RPf,B.;/8d<NgLFCK<#4
Kd1Y.C6[gN/3(-_C(/#,GB2L1/YI:2RA^=RR2JA4(V7YH\RHeQX=a&81VW,9Yd,D
FXG-_YMFPLHe<B7T5f<U)4e?.P=e#b\KF8,9L:UNR6VJ\V#\)CNPM_GQ7E=(JEF5
TKH>FATU/.DDK<OgF_8D9>IO@M>H3]Qc0H5IQ8OG@U_-=AW\=G5[8&2H6g@=]2_d
0JH95IQ<[[PX_g05TBP^HU1Uf<F+@>P+:[>BF5ZF4Q[6A?eM&XA]Zf=S\(:B.GM/
e(F8L<fZS(;)f0(]EP=geS:WJFUb>\A^S>?RHX]_#W6=LaJE7e+G^0Nb@8a?Y=9Y
P\e-=H</7L+\b\RCNZf([2OUMFdQ@de9b6<eL)\]4R(eSSV@8]-#HHfZR_>NM09R
7Ia+_/)-(R7?M44#bB6P\IWBUILI3-8aEG,Z)1X-^([B?daNfVE9]?L0a+J60RU8
A#JBc&&06Y,6AQ)fMB&d-07MQTEBY\fKO=fS8g3:)eNL:O7_68-D(M-&@BL0\].L
&9.T?8U(a^<1YJR<&_IO5E(4XD?a,L;3]G.3_b].d^:P1&(14#f4N)ZX3I\NB75)
-SWC/4=d5^I4OV-?#^,+MI?DEe?\aJ6gVJ7&2(CTR>N<.CWH&\<)K;M]gR\fOAb9
W[+Y&ecgMeN3HXKWV-70dfYOQ6^V9bg=4>Z7OF)Uda;X5LT:L=\32@H,+JOdRI3V
6096\:MH@(f23VN+5R^fF2^0^#b]95@<49=5MMCVR6#.(GbS2Z?g&bJMKF:9LCZ-
SSQKe+_Q+YYZ\8=eS[2_MBW4SM1P]\#fYIVI/Eb&VGQ+]Ug7R.^\(7/)U+G[8/T]
c9[Ce7[T.F97E\Y+7P<LVPBQ0J:/]cT@=12:Aef5VU0TA5a_(MPVGbO=H]_;MRQa
C+C.H;OVY+@eSS,\@A1O.\WIJG#7CaWMDWGT,7/&aZD1a3>PUSM]3,>V=W5URAU2
b<(D,P5/A>e.+e4I+S[Q&\E_VFBPMLcPOOb@0&fH5cUBa?Ic9eZSWP0U1bO)ONX-
VI7.@?UO>Sd_G<(3>U987)V(AGg??AI<6Mf(5P@J4\1FUag^WMJSUW[?Gg65#>G=
LL_::)>8GF]=0OO2be,^RN;gG&=e/_-H3M(E:.Q0f/EYEB4-FeBgQ,[#FY]d_8a,
I?P_1P^W[,XB0_.SG>?;/PdHKOD=B[0W(bBfH+-WE6O6PKeD5&dRJ]9O&;RH^EVI
GQ@>F.<QTOL.Wd1<8Z];XJ19-eQF,-/d3U+YL3@[.6a9^:4+dS>E9S?)EHg1_&:L
^e&DDV<c77KdW_/Z92e@Tca/\20RbcG-JeZ2]LDa2POB>-->d5\g#[cIG5@;S0HX
d@B?O.(;@DId>=3HR1#+D7K@3@6X_24G=gU)eF>W1GWP?^+]OG_:E,ZFNHF2Q,__
H)g.LJG-)b>@O04>#^,Q_F#)eU7F^??(_//>/1cTT9SM.1aP:F-Z(;4NUcFb?VDJ
^WX<ad)P:e)&IZg?Q7.gL>K[=f@3BD=d-4^Qf_/8eGG7=WOXfLZ\/a#LGMadF&f9
F=._?[-d&gEG+:CV@J0O->;ZE4)gPF(ScRD,Sc+-X<)O?afMWUSbQb#>8S3YWJ3]
VA/b4\M55PM[JTa,3MVS_D84I:XN^b93.b?6g.W44+,OA$
`endprotected


`endif // GUARD_SVT_GPIO_CONFIGURATION_SV
