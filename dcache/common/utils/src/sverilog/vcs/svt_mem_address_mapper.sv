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

`ifndef GUARD_SVT_MEM_ADDRESS_MAPPER_SV
`define GUARD_SVT_MEM_ADDRESS_MAPPER_SV

/** @cond SV_ONLY */
// =============================================================================
/**
 * This is a container class used by the System Memory Manager for storing source and
 * destination address range information and providing access to methods converting
 * between the two address ranges.
 */
class svt_mem_address_mapper;

  // ****************************************************************************
  // Type Definitions
  // ****************************************************************************

  /**
   * Size type definition which is large enough to facilitate calculations involving
   * maximum sized memory ranges.
   */
  typedef bit [`SVT_MEM_MAX_ADDR_WIDTH:0] size_t;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Log instance Used to report messages. */
  vmm_log log;
`else
  /** Reporter instance Used to report messages. */
  `SVT_XVM(report_object) reporter;
`endif

  // ****************************************************************************
  // Protected Data
  // ****************************************************************************

  /** Name given to the mapper. Used to identify the mapper in any reported messages. */
  protected string name = "";

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  /** Low address in the source address range. */
  local svt_mem_addr_t src_addr_lo = 0;

  /** High address in the source address range. */
  local svt_mem_addr_t src_addr_hi = 0;

  /** Low address in the destination address range. */
  local svt_mem_addr_t dest_addr_lo = 0;

  /** High address in the destination address range. */
  local svt_mem_addr_t dest_addr_hi = 0;

  /** The size of the ranges defined in terms of addressable locations within the range. */
  local size_t size = 0;

  /** Delta between the source and destination address ranges, used to convert between the two. */
  local svt_mem_addr_t src_dest_delta = 0;

  /**
   * Bit indicating whether the address range defined for this mapper can overlap the address
   * range defined for other mappers. Defaults to '0' to indicate no overlaps allowed.
   */
  local bit allow_addr_range_overlap = 0;

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_mem_address_mapper class. Uses 'src_addr_lo',
   * 'dest_addr_lo', and  'size' (i.e., number of addressable locations) to calculate the
   * src_addr_hi (=src_addr_lo + size - 1) and dest_addr_hi (=dest_addr_lo + size - 1) values.
   *
   * @param src_addr_lo Low address in the source address range.
   *
   * @param dest_addr_lo Low address in the destination address range.
   *
   * @param size The size of the ranges defined in terms of addressable locations within the range.
   * Used in combination with the src_addr_lo and dest_addr_lo arguments to identify the src_addr_hi
   * and dest_addr_hi values.  The mimimum value accepted is 1, and the maximum value accepted must
   * not result in src_addr_hi or dest_addr_hi to be larger than the maximum addressable location.
   *
   * @param log||reporter Used to report messages.
   *
   * @param name (optional) Used to identify the mapper in any reported messages.
   */
`ifdef SVT_VMM_TECHNOLOGY
  extern function new(
    svt_mem_addr_t src_addr_lo, svt_mem_addr_t dest_addr_lo,
    size_t size, vmm_log log, string name = "");
`else
  extern function new(
    svt_mem_addr_t src_addr_lo, svt_mem_addr_t dest_addr_lo,
    size_t size, `SVT_XVM(report_object) reporter, string name = "");
`endif

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Generates short description of the address mapping represented by this object.
   *
   * @return The generated description.
   */
  extern virtual function string psdisplay(string prefix = "");
  
  // ---------------------------------------------------------------------------
  /**
   * Used to convert a source address into a destination address.
   *
   * @param src_addr The original source address to be converted.
   *
   * @return The destination address based on conversion of the source address.
   */
  extern virtual function svt_mem_addr_t get_dest_addr(svt_mem_addr_t src_addr);
  
  // ---------------------------------------------------------------------------
  /**
   * Used to convert a destination address into a source address.
   *
   * @param dest_addr The original destination address to be converted.
   *
   * @return The source address based on conversion of the destination address.
   */
  extern virtual function svt_mem_addr_t get_src_addr(svt_mem_addr_t dest_addr);
  
  // ---------------------------------------------------------------------------
  /**
   * Used to check whether 'src_addr' is included in the source address range
   * covered by this address map.
   *
   * @param src_addr The source address for inclusion in the source address range.
   *
   * @return Indicates if the src_addr is within the source address range (1) or not (0).
   */
  extern virtual function bit contains_src_addr(svt_mem_addr_t src_addr);
  
  // ---------------------------------------------------------------------------
  /**
   * Used to check whether 'dest_addr' is included in the destination address range
   * covered by this address map.
   *
   * @param dest_addr The destination address for inclusion in the destination address range.
   *
   * @return Indicates if the dest_addr is within the destination address range (1) or not (0).
   */
  extern virtual function bit contains_dest_addr(svt_mem_addr_t dest_addr);
  
  // ---------------------------------------------------------------------------
  /**
   * Used to check to see if there is an overlap between the provided source address range and
   * the source address range defined for the svt_mem_address_mapper instance. Returns an
   * indication of the overlap while also providing the range of the overlap.
   *
   * @param src_addr_lo The low end of the address range to be checked for a source range overlap.
   * @param src_addr_hi The high end of the address range to be checked for a source range overlap.
   * @param src_addr_overlap_lo The low end of the address overlap if one exists.
   * @param src_addr_overlap_hi The high end of the address overlap if one exists.
   *
   * @return Indicates if there is an overlap (1) or not (0).
   */
  extern virtual function bit get_src_overlap(
                       svt_mem_addr_t src_addr_lo, svt_mem_addr_t src_addr_hi,
                       output svt_mem_addr_t src_addr_overlap_lo, output svt_mem_addr_t src_addr_overlap_hi);
  
  // ---------------------------------------------------------------------------
  /**
   * Used to check to see if there is an overlap between the provided destination address range and
   * the destination address range defined for the svt_mem_address_mapper instance. Returns an
   * indication of the overlap while also providing the range of the overlap.
   *
   * @param dest_addr_lo The low end of the address range to be checked for a destination range overlap.
   * @param dest_addr_hi The high end of the address range to be checked for a destination range overlap.
   * @param dest_addr_overlap_lo The low end of the address overlap if one exists.
   * @param dest_addr_overlap_hi The high end of the address overlap if one exists.
   *
   * @return Indicates if there is an overlap (1) or not (0).
   */
  extern virtual function bit get_dest_overlap(
                       svt_mem_addr_t dest_addr_lo, svt_mem_addr_t dest_addr_hi,
                       output svt_mem_addr_t dest_addr_overlap_lo, output svt_mem_addr_t dest_addr_overlap_hi);
  
  // ---------------------------------------------------------------------------
  /**
   * Utility function for getting the low address in the source address range.
   *
   * @return Low address value.
   */
  extern virtual function svt_mem_addr_t get_src_addr_lo();

  // ---------------------------------------------------------------------------
  /**
   * Utility function for getting the high address in the source address range.
   *
   * @return High address value.
   */
  extern virtual function svt_mem_addr_t get_src_addr_hi();

  // ---------------------------------------------------------------------------
  /**
   * Utility function for getting the low address in the destination address range.
   *
   * @return Low address value.
   */
  extern virtual function svt_mem_addr_t get_dest_addr_lo();

  // ---------------------------------------------------------------------------
  /**
   * Utility function for getting the high address in the destination address range.
   *
   * @return High address value.
   */
  extern virtual function svt_mem_addr_t get_dest_addr_hi();

  // ---------------------------------------------------------------------------
  /**
   * Used to get the mapper name.
   *
   * @return Name assigned to this mapper.
   */
  extern virtual function string get_name();

  // ---------------------------------------------------------------------------
  /**
   * Used to set the mapper name.
   *
   * @param name New name to be assigned to this mapper
   */
  extern virtual function void set_name(string name);

  // ---------------------------------------------------------------------------
  /**
   * Used to get the mapper name in a form that can easily be added to a message.
   *
   * @return Name assigned to this mapper formatted for inclusion in a message.
   */
  extern virtual function string get_formatted_name();
  
  // ---------------------------------------------------------------------------
  /**
   * Used to get the allow_addr_range_overlap value.
   *
   * @return Current setting of the allow_addr_range_overlap field.
   */
  extern virtual function bit get_allow_addr_range_overlap();

  // ---------------------------------------------------------------------------
  /**
   * Used to set the allow_addr_range_overlap value.
   *
   * @param allow_addr_range_overlap New setting for the allow_addr_range_overlap field.
   */
  extern virtual function void set_allow_addr_range_overlap(bit allow_addr_range_overlap);

  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
YL>DW8WLS(?L@;C\gIIeV:?O/bf2A<TY_,A.(]==/E43#V3^5R\J2(8/7:YOP7+f
9\TMC9.ESB&bEGSKWK=INb<60g78N:L.ZdUVD^J;_?W5##3AGc4GX0+5fU/9PD;K
a\5@4dO0d]T.c_-_1[]>[]+2,Uc0Q_BQBA7bE5_D4AV-3d&.X3F0[c2D796M>N(/
LKG]3Q[/KL=HZG#E:GX+#XS=K9HVUIAT1C>SR?g6b[N_1E;]/X\DU94:Sg5[c>9R
OH,fecO7JBKeH_E>1_RMEdKgW7/Xe##3Cb4;X;^DRaVM[DgPTTXCDe0+J^Nc6)#8
I3JZK<#dAf@(XJa8KTC-=5ZD0S2)WcZ&Pb_eOTB=f:NdJfFO/gOTe;3+2LbJ]de9
^DZ\NT6(6]SMPcD7&1\Q[=E[YeMeOePRMP].&9&+Ke]Y45AeTT7G(aW0X8B82-V8
9:)NE67.e0bNQ#KHR1V3_ff.]5T=W)M3A99MUP1HgFN/^:\Vg8D7d=g[>35IgC^X
FSRB:#LdD5RdF;::>E+Y,,&BF^[,6H0ZA,98_=O2HeO+Z@N;X#V0F\27\cP/c@b9
4^dg:@:JMad,D5CI526f#K^:=TQ-N+###79+a;VGJ4gY2);>1\+I[P.5NSS.YMM_
#YQ+.bF]9Ie9>;af(X+.?;8X_Q6;DcZV2J+#C\4Z_)cTaMWDKG6OdF3IYX(XKJ8f
gd;KB>b&^c#P-1#e^BMf+H;e[6RdgYg37Vc7=-/e77Tg,5SI2Q<84)F(56QfLK?:
gZ10[>7dHEG;@#)4MX94g0R79?&60J(E_;EZOR_DcNL_32T7FZA6)0HaBPDgAX&J
V/YI+4.bVe)-:UZ)fbQ]9>>UK<2Z,@<R,JXO-bR35Q\>_a.:V\6_DO3d?W#>9Z5-
7T)Yb=DVS]SB4bX,&BFN?c#T@\8C8O3gN\S[CZ6-HT8bHO]@_0\(5dV-C@5B1/RP
H0(,X:Dd@[CASB7@5JP_VL]TZ6C4\6@dF[<QWFedIEfX_#;SC,P7#EB.X>INUDf[
B;-P,DUI]DHI3WKc+?-P&&3&X]?KHU6&X.=<.RT.fD8a&@cY@XK8E:0dU&JA;^cR
edMHC9HENbS-P6HHKe3+;=85W-L]#UT,-e9A(+_H#2RYCGRE&+JBPQ9^->8;a10,
B+g9Ie)Xg@0Fg1Q7[]=J(bJ.d?>&GAI0^81G7JT.<OfZ9DS?R)H+TR9G#P_.E/?Y
MCBU:D:5AK[-6H?07-@1[R[YZdDSOCgA8fLg0I94E:e>I_^3A<Z-]LR<Q&Q&&&^E
:C;D8DH<JKIA>QUYgKcN@0+SV.2IHPcKOJeb)+[G9>f.a)d;RALT);HGDK7DTgT+
NN4f);C=P)Y=/>X754a>YX9SBYO&;,WdW[EcSbIBF;R&?ef_=]^Mg1V(5SgCUT(<
b9Y.=.=-[d[BL9Mf.c[;6H)]T5G0TM,7B0,EI\R-<Y[ecQB9G#d4,C9IL]Me.6>d
@fT1HQFPHa6g)L],MC(3Fc6Ub[:N^:KWU\,[f\:Ge&Cag>9DBd77)-YW]K0B,0T<
\#C+Q2gX-;]E]93(&S2:R0=,K,;SE=E^1f,L7cfA.&=W/Y3)Ya&?f^95]259H(0Z
6F?9G>G-8QQW0YG)Y&=P69d\FRU:FJ)DgT>[80W3;@3/6CU8g9<)3b;\OW,:8BXH
.a,V4)8fOBdM.5G_b]KH,QNF<6>HP;AG&XBa6<=OKZ2R?9<DbI]F/+2=#\^HVAR(
BDXU#Z(3RUZ.WX]Z-+V_3V?YS56X+6G8eC[0P6JWY6SGXN9W;WbP@OM^0RO>@<cP
5@]1G<;V7bM;S>^?cE<7J4cf.(@.@cQF(g@EXEd^PE1Tbg1)^-4#g#bP^2gTd^e/
VIf2cBF(O_HH4F]Rd69,+eX2H;?FW;03XdECMK^GC,Q.)-X#&J\G5ER-dJ-7MHcG
@=1I6[-4_^M>C?7OG5bQ@W0cYT)M/6R[^=#H\J&#4LJb^8,Z\VP^@V\(?F301?[V
?a2TQL0_-;f8BA;gaGNYgF]+b,KE@f(gBC?G]S+(A;<MC?d62D[AWNKFG&5I9Yf8
A&L+H_8M]=g1e+dO]4U?>)DMJAQROUNG;IO?/DWYHcJS?/.fH,;cK\J;9HP=6K2-
:M=e[eJBT7GT_M@S>CW_A1SP,2A#,_I#0?BE8:T06)-]5b@FQ1ASAGR1&4W52fO3
PYJL?KV[A&/X^V1L\fSR024LW+R8^VJ01JUIX.>CH7?B+)BX6U@5T@#Z8FK1AB^-
8-;e?[A,?M,3()8X7]<EYYZ7(,^A7YAacee\66)F=-XSf44.b4XfaVeJdO7OWGK[
64PA>OBR8,N/)&fEg#GFBb;Z,GB_:_</8Y6(XD6?@C]S_.9bLTS4[KI?ZJLAIDeV
e(-8(-W[-(B7RRUUW>N;2_Of&eFOJL&^T_?6(a]K]G#^8)(AEa@^NR-)>RP?O(0H
)J(9(8?;1gNQ[,^9@WJ+:FM(1Q7&\F@UBJe^:\O3PYL:?V)F\S_J)^1-B<SEBe?=
Lf2/W6VQ&58e@G@f?140>NWBgf_88QHZSNB1-D&I2D\>X@#LP;U;N_IK7C7F1<_]
,Pb7eD,X&/=B5VX/93&Y6^8=2&6Ca2-U4O:8<(Y9F06NHVPc4?dYFY&#G,,[,+f+
HUY:\bRF9K[(bBW;(VfH0V,(6A66&+aPd.(G?242;I[)2S=GJ9W10f_L8H0a#UJ[
>A=DS/L7WN[c_beNV9,YRRAcQAVeR1J(<(Qe9N+UFK:2[aH&EA?(>,YS0\:X#9DH
d1-:U;8=NO#7>])M\?>8^P6.+,=NJZU2OZ=^AO[cfQHXMQP\HQe;e^)KcRAffg=4
K^)Q#5XU9ZZ659_/I9)_&[=N31@;?0Q[[e+1Mc6Ec?\ccC6S4/O8QZK_N:X&:B^:
4#B>B9eBL)3L-ZGSOdD(SgQe2?#]MD&FTA&fN5;)b>N0F@CZ^cWYI&^=[>[+Hg=6
1(@SJ??g@=bZUW(,-U,)ONAdN9G:RdV5UVR9?Y80O64Q&RI#1e=4Sg0Ic5-UT.LN
&61/e4bWaW[De-]UUX?JELQbbdK[#eeS-T?DOBIBMR7GETLK8>AcA:PENNg[ZGNZ
N0:<N7Nc0V-ZX?IDW?J6]B)da+cK?HeDcEEZdOQR3I[#&dad05-b)+I#]eO:A-QN
&;(5)RD2QZS;\=]]ZW_f[;?TQ/g#\27IY:UGB#[/c2C)Oab5<A895/Q:KZb&dYK^
0Y:[>A=[N)LS2=K.g(_S9QW(-\L]HfZ=f\7gZ_9_T]>Q)>@=8]N]&#NQIcG9]4&6
A9:]<@:GD7c/TK(5Uc_LRX^5L6Q37)N72,IKV/c\.JVAXJD[MeYcA5FMMP]ZV>91
_.]MD4?g(U4F[#G5^?@OBP=@5I&f#+(?7e;a<WIAVQY+&J]N2M4G[-1&=UUe[253
J)8I6:Qe\=U[83,<P6(M5@1,ZA=I>8?8[K/T+X#(,MY7:HBV_H9P<&#0&TGdI:U?
ZHV7.<HWSINPP.cT[FPTF2/Kb@NGfWPD5957T2c6Q+Ye?_&\RQ87)8ad@E4WFd>?
VI-6gV@YU[X_B>FQ:_-LOC<g&ZO<VWET4EN@C@^:7_dW48^9^N0B/[RZ=I7(O_VB
#E9WeT0UU:,40MW^QJ&NA?\(]DFc:E2\EIb4d,UJEb5;La^+AHMf7,/&gU&1+d[V
U?PPN)QV@P5LSV\LZFf4K_=TDFUX<)-fce11PRB)BDd]Fd6IQDaOM17Z6RAbZ_AZ
VA_Y:A9C#??/-PUG,;>f3<#e^eL#-6N>9TWd-+WONBecgc4Z/@Z9U,M7(f6N0d[V
b7-)S\e_P@@Qe.,L+DVXbX>=Mf&&XO>2)BH<I(2ABG/N(H.Lg?0&5YTd3:/G_V\(
,^=P(2a.RER+\f#d-3MW,,Ug<(cZU4,FDbcXAFd8\6XMQMP#eQ;^c1>?@F0-)V.C
Y1b3Fc7,+DDDQY\aL-2Z;b&DOR06ecB=U6X1,T]-[5I\E(5X@e:6H\O_#ULSL\DJ
IJN>B#3+0L:If.HaCCVJXa]6^HY\<8X)e?^@OQ9CF9MGca0?1Na,Q7=?9e/8ZF@]
c>W2S#T7YKD13bA]BKOA.4QY+FaQQ[,C[Kd4RMQ&C_841CgV]H?JHDIR6c26S#c_
/3GA-;(c2F-+6Lg\<<Yd[YLMB<X\ND7][XT1bF_:YaVAMP81]N&UVD/#].E)d\e@
]fcbVeNR5e&>KOWB/>+:KHE^T<P1:/3H8K_aM2Q;ZWX8E-g)=K_eW>31)&@fL76J
3HDW@B;C59EF&g^FH<[dIT959YCF\5-[a:23RR/ET9E()YXc,5ccH1ggYA1;^+P8
Z2gQ]F@53MdXM7D0?3;]a)JZ[&[[./58JN_gF[^4dN(ES1U&[E,[0dBI&Kb\(7(N
/IWJe7^X,22N-9_6=>CUQ3D<>&#-O?DFGSLeP;+LaHa:\LeV(EV]1aaC-,=0+4N(
;+DK2+9I#LaJBZSHO.L\K&WELgR;4_Nf@DG5]AFbV)[c7LKgI-SW/YH4A<MTT6Y_
:a[3?)c<NB+Q.[H>D?A8KKe@1IMI5QZWOT8W.U:_F(^YT7?86R9;F/:B=.4F3ggE
Y.&fXHJ8MbQ\PH?>:CL6BGT-5#KZPLFO?=9(NXFY5@aY.Ud(?^D5],0G^:F?;;fX
bY?fDC9++c=;=:9T#PUc4/S2?6/c-[G\B8AA1W=DNc1?NLM_846OgcaYP>LV7(_#
<4CSAN+ENW74MQ^QY=SgY81/JPC[gHT0C9L4dYe57IP=e\9[)#eH5If1S/T>/3F@
3f8M:R9e1:-5f_K;0M7=5JD=L?)g.K.C0bWL]2Z[Fc]4bDR[R)^<8M1Y9/aJ,XJC
7KgE1851D7?VS)Q]9:S#d</O:.B;M7]YGO^U-G6NSWJCaQ;d)MC&C7<dTF1+.eEa
TFMaY>+a>@GRaRb1<=UAJBf\K#V3REV_0867</=NQ5<#F]@7U+EXbN&N@Q@H&9SU
JLQ)W-74fWM[?g>]Ra1IMM=2O+7P;;ag)OU(-.=/fR1Yg/PBf[HJ#[dbH5(:QN/>
\V-ZXKM:-fUb[0J[073#g26/G+F0g[.V4+c2C=D0B43S#J@:[6XZKgJ-c1C&8.V=
eJU(M3=1?MFEWL_X\NXIEXP;a8K-CA?a#IM0.EC]NIF:RC-9<EU)F90bJfPP^e0(
1<CE^I-3O,@L?H^MX;O2.9VM/V&I_)).M.N7M>)8\SbgA)>>21Nf9Na_\gZ;b[V5
+YP#R<\dP0DP]3YOB6cagZ+Xb0\U]ff,MXI_X/7HZ^0ZXKXQ\3<eTUQ<&dAg>AG]
,A(LVc2+KORKHXBSg@&DFJ(-S5Y7UYG<I^-0Ue+,G(,OK3EBe#NNfKgHZQE/IKJ.
/X.X40aI+MLe6C_FYCDV.F:](fUDSLAdWcXO=^6a2d9^KVFC^0fHF/?,bRP\#IQQ
4ZFTb;6V_GfSTJK6-&c:HGT,M94SD[HC8IQ^QJEU]OM9+3d;YFX?dPc6+,O#]?W<
R^N33:.1b[3\__A:c]bOZ>C#/O^I3O_G.>bYP/a@XPEU_QLV>2N8Y]gK2aK&#1U@
GSK:OZ[H.R4=K-CZQ/]bK-85OZ;45]]J<JSFe)[IaLe-)UB+06eY]^QE^9J:=;P/
;e?5TOLd.I523J3gR<H0E0-SLTf^f7OLHF&,Z=D[@(V[/)&4A-KJYE1;W_/[a\-&
c):+Og^27M]<_5R(^3-#(TN7Q+6Md<;\CZ><6GBMVZAC=^#)8ge7JJRgfcK^<(g-
17ZA#1aJPg2-Q?V?b1I-Z0Lc<CXE6a08:JT07F-T/HQW1/MHHB:]5>1Z8(&.f,/#
^S/K#?,)]MI[+KaO8(7]LE1PgO&-c];P?2g;/<IASR^B_cGLYL&(5_H9S/c]I<.C
RQ=W07XH,F+<L?\N1BC.\6dD_@3(J,DG=9UOQRU4W4(CbNNV_M;PfI=<;3Lf-?_^
AGT8+2DVbD\.Q6[;L<3>=]?GN)J5\[Z:JPUX;>W?XU9?/UHLbL2[DM)Q)YSX6E>K
V7XKKc(g.>4IQ:ZbJ3TN]MUg?(DN,32g[+Ib<9QY.c7X(C>,_^?2[JHbd&3d(fRX
[)KZVN1KDRYEGF[X<.=bg.:2,LD=Pf\[8>cOcH8/Bg-L&E[(aB[2Pc>U==Ig]8W2
ea0[T8b(\R4aDOWd)#7\P7G@#T<3WV_K#3a_QL3]bTFI@MeKIDR>5_-,V7Bb2Ic?
[f#L5U#OJD4F+?OW=\4Z;72.A.?e@.=]=DRRDWVRVc=Y^P@Q(bG6&C<K3.L,fI(V
]:LM,)1I(;@TADfMR//cD-K_.J;W7V1:RW+]9LG^<aK6]/_/:LB56AWM/J2\=31F
^GP/PF?4]6:aQe??_3J_/#@Ce/bX-I</XJ4Y@6a1^8BKUL5Z1RV#6]Yda4FQF#cD
E\c6a-0O@IfDY2Y/0Z<@&&78#KK^BdG6cU)G5EKT)c5IDf2JFJS=/&(=<Fca,U\C
50<N@^CIB?aH0@X&,8=W/PG.?SE/>=2RQ4aQ<U=C(#YH)D[CSEB.K.#Q(K/@,:cg
CUWf[=0\U.7J2>Y<7PU],cg\N^):+.0S^3)?]3]XCK5<[YaV(;AA,9EXIXJQVU2]
&Occ,&HVVQ7M7JERK3g7)X3=J4<-F13fL(3ZZN,E=^?aH?:QP\X+ZWA&BVEUSg72
BHFa7>-#T1J-eG[[-]Y9ce>cSLHG[0;Nb@@Y/:_-8,FHZbA/?gcFbg3aM&eESEd;
R:J_;-3(UW.NFDYf-\X7R[DTYN:CXRTSOf=eD>K#W5&A&b51cGE0+&F6b7egO63O
aV^UJL7fW7GV^VA.=b/P5c9GYeN)Q1g#[X2@0ccG9O+g1G6gYdOZegFDM_gR;XKP
@[O:(\a4QGW/S0E:DT?fcV3XJ@:DRUY#7CTZOM.3NQWPT1PQeg151N-#@[TA_;R7
1,0OcG3=WFQ0G3f(Vf;]1-g8Y1I,9?FMWZ64_UG+f=M.bLTSHELY-4AK#L<Q&fe<
>DU,3/]5f<:a_U32@D=f:\<LRD9E_]EB)AI@MF;PBf&J)B07+W0U_[+.\JO=F_]?
FR(4,),N-04fXGaOVJ#-)W:->O3WIPT0A)M/DT_dSFgYW#0/R/(#Q1^9XedO#G2b
bVI-O4T2M\7Ob8OFdLS<N;eKC9[/O??aJ&;;=-L6G,30ZZ-<\P1P,O4XEC-,.X_M
OC8&&aR+gCggWC+L-fePcG8UOL7XP,=DNf1FTR\-@d]e[#KZ5@A/=X(V\8Zb+Y;Z
V88-f5\JMc/]Rf>3R-()X&GC\_W)0#6f7g?fP^Z#PWV4e7#b,/Af,AYA@_?Ra:4]
+_38^T;OUV):)MC?,]O.]><b5/FNd4C;TA)C1-gf85b;2?;9Ld-Q.VLgff[G9\A:
EVSX\?M54Q)VNdQRLS2I<g,<^#/9XF0K+5aCJQXbF+4H/Q4SKb[\,EGA4VRE1gQC
Md=_Y9.,P@I1=b13#SH>2Cd=_>UQ4gCg@b9QW\eO8)?+O87c2&5e&+870g/f@W4N
P-MJ-E_bIW<>cC=R,GSL#8U)STD3eY&NF@#AAb9NS/1H<(&?ISEU_OL7&@L[>A=7
=9.3W:.=Z.5HU1ZaEC@;X>S];JEdC]H^e[T)NUX\ARG^VHacFF<\>B9,#VNeXN1T
gFJ&RI:K2/Y+e-:+4225>QE:J6+Z_&QJO]0Q/a&K..&,.(-:590M-7^(&9P+J,e#
PSa.//?U2&(eVAEbH750Q8#2N/GASdW#+Y982H.H#7NF6#JAZ0\cQS-6.<##+WgO
1CXJdV_@TO+6&I8b_#F3IA@L+5:-/8)CUOc8=bYRF?+HF2-)=N6MN3[O4=6@7@eZ
5[-X@[DE\A(G32+Re+9:-4fBI?^@K#E)>T67KXECAg)XL-0g55PTMR#=:D/6#H/H
c@eBJK,V921Q2OZLT61JQDaGB3)[Q\7f>1;0CJdP)#.ACJ]BHRM5@+Wb_(ZHSX;Q
7g>4cFO#9eQ(dM+Pa7/ILfE4(C8NOXG]][)QJWe(DS:[d-397gaJM#])a=fE+YGI
[T#:>QNE5VWUd\.LPcQPe],/dd]906cYG0HRGEK&-IZ34?J88f2=^9&:0E(MF4gM
6QUH.4YL=,MD:G;e]ZXb0[;)).5N4VF=g.Ge^\S;PaH-&84b.c=Kg-C72##\8]2>
fad?N=PX?3YQ2cVf0^&-SG(0;a&aWIQ@9@e(A=Z_FPD?ZK&e8;C^V@MF0dYX5B1)
M)+^A_A=GM5;&0-X6@7(_W3O-Z0UOLZ)0150Ff>UI(fI&]GM#6JN;CI]QVV);3dO
eD^J\J/+aWbGF<<U3TFcHE#8/g6)D<PP4^bMf5W3g&;7=:=2VA&[0^#Ccf<aV]0a
.#S[QYI7U-XRQ0:Ra60G[NeEAL,#O#7M6+G6a@EC4B;WEQ>-WVJGJU0MK21IgdQQ
Wd;g=KPG#OQe:?KB@9\8=4R0:@YKdfKVED?KS/Q6OR3NOUCfUTNb6f8#cSRV[MLe
^/H?=+J)MK0Y0^e7F6<J,4@&#Y<RcGb\.B#E)Z][VeP<.1HO?M1TSA?R3g8[:)9b
f2MKR0J=]a-fOS>_)5f;KU-QS<1(eM\\;fe?WRC.caJ;SXQ:I2f?]VNEf9aaBFdU
27YOQVS].;DU^6HJ#)VFHc\(@WFJXg0[:dXAS2U^4YPfa\feKcA_]QUW0e;\<#U8
_L^c2\5>:^LNTH^09gbI=_+d:@6E.1ZZJ76../QVGV6NYEO-a-T=Q429/g5bKF4N
^gdO-V\C8OI97a=._\^gZ]VH^,E@T_WH@BX7L\GWX\:-9I)7g8+_XC?+1/ZS:<^e
OaA@QBOf_\8H,C]f^\_?,##.LB=/a(O2&S4aYPN)d8+JD.YQ2R<X+MNJ4^#e.GF5
IK3\bY6,H[^/Y2NNAXR9@H<63AHRNPQ\PaG[3FXD;]+W?16=7JIUM2X_7:+P;)Ka
eG4>b\cP@Gc/e8gGc(KBNLPX.gBJ,VVA<G[NC^VNN-PaR0IG<]9\>JZ5dZ]]&L=<
X_HEVf)C&.?6W^G4F@E@.@HYDE2M@+SbIB5H_+B=R4RBJ4FRG4QK4ZF.]Uc\BW_5
69JgcDALT:URQOO)ISW,a,,7B@3bF<I9&7&9;7G;=6^>:JG8II8bGg;3MH^EHAIf
&:630W0:[>>;85;+R:HNRVWWVG67#U&M@e),:\3#aBF/BI9^G3bX_I<5?=.X[1X7
1-.Hc@G=d9;Y)L-Wd4Z\[3I21SM#_<N]\>B]FK_22/2@9N4GV=FD2aRORc<DDEcC
3(LFQ#b[:NHOFCaU<)SC,)<QJdf)bA#cDGa91ECdJ7I-R.f8dK;HSFZUEML-_W70
eK2/MJegQC[5YC;;e]4S,a8=Z^J@H;6-_J@M&SKM@2]7ZXT^)IAbZBM@SXeG0bb2
C-&R]K=J3X9&+FY;e<N9\g4dL322TQ>FG5bHOUWDVc<[M8]<IIfUP&[]#EU##.Jg
0+E.QB5@\=M_EUaOTg_<FU>a>R<3DRX\]X@]@eWXA,QNM<05+3XXc0&JHa14;=13
A8cCU)9>X+1XG(3&_XI=P<cC_f-5S>a;1?D)KbVBc&@83GMR5.2dGNO,2L5;W+8<
JIZeY0?cE/NIT(SR/;TDe.I=;OEF-BJ.C7<=Q>TAL1R0RdD8HJX;+=]]FZ<YAbXV
CD3H60f&XUPIGUKgbdcCEWWfG77)WP4Na3U12@HTN,>A;Tg/[2,10dZ6Ke-gZ0PK
@?(10;J874[0Od/XC\Q;N,CBB3f_T3;4.1+[8?O;#N]_]]9>&VODV(\_[RD@A,[.
^AF7_<HZ79e=(bM0K\BW_564abdQ],aDVD[J4Y5ZPJMgCc-/Q,&]?5IV>fBY=TAA
ET9Q2C7L=aVO27@UZT..NV;]<G5;A6Q0QJ)A#E)ILT.[XOO?NN7d@2]C_P=X_#-^
@7(KOQ7]09RGeg]#P,5^-#(\eceOc_N#3F<A.Q6[bSgP6;=-66>9C/N=AN_]Q(>;
Wa7dK(4#3D>AV[[?=)8&Ta\\OYY<C(B-JNUA(]0CHD:Q]HRNUJTENbde565We/d_
]Y4_TRA>V/:.^EcXIN9)QS2_fbc--L[-)7.V+C,S7)2dbW64^FWe6A<_U<UKbR@M
Z#MU)IQ9/?>T7SZ19:F7]5X13EBFW;N@_c:Mfbf&I.2X>5gfB=ETNb)<ZS;e/bW5
LWWLBV7Z:+d^gM8L]5.T<QcI;6#CN1W5;WdcG@N^9g?QN0#\=Fa-0OAMT_BHT5KZ
YgH->C>#>)Rf]bY>M2&J0Q^bDK+T:8FUS,#^9[E7YZgD8-AdR_OSY#ePTdF2I4B=
e6Q[c&7)46?b@GdgGd@IO9^L/bFF>61XQ,,F4U@1=7e)50JMA1-Y7ga#VB]I^2e<
0F,\[>TQP4VPecOJ=LYRD&g(94;I=V_#AB(7>gb[XWBN4ZY?L^X_(ZU;NfY/[G&&
4@B-/>WN^1=Id:6f_8HX\fLNXOUZ=))T(dB-2.R-bECG<&1Rf2YVE#Z,OO@1P=>,
9N7?G?+c-_UT>Fc,.dJ25<dW-Z.W_BgLVc6c-(<RS-b;Y.b/E<Z+f=g6N-9aX8<U
4=WaZ^<GU)TT/$
`endprotected


`endif // GUARD_SVT_MEM_ADDRESS_MAPPER_SV
