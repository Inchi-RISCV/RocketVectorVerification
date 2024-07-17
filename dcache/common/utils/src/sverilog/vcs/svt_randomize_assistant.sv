//=======================================================================
// COPYRIGHT (C) 2012-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_RANDOMIZE_ASSISTANT_SV
`define GUARD_SVT_RANDOMIZE_ASSISTANT_SV

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_defines)

// =============================================================================
/**
 * This class provides randomization capabilities for properties that the
 * SystemVerilog language does not currently support.
 * 
 * This class currently supports the following properties:
 * 
 * - real values distributed within a provided range.  The value returned
 *   from the call to get_rand_range_real() is controlled by the 
 * .
 */
class svt_randomize_assistant;

  /** Singleton instance */
  local static svt_randomize_assistant singleton;

`ifdef SVT_VMM_TECHNOLOGY
  /** VMM log instance */
  static vmm_log log = new("svt_randomize_assistant", "VMM Log Object");
`else
  /** UVM Reporter instance */
  static `SVT_XVM(report_object) reporter = `SVT_XVM(root)::get();
`endif

//svt_vcs_lic_vip_protect
`protected
UHXP7UDLHf8J]Kc3VfHZb?c>e1Db[O-YfWQ?0>\e>)37UO\&>ZbN1(.fU/,FR#CA
[GLGQ:eXgPIZbMYJ-330Q3^d,b[,>I>V]OdVJ&bH3c4H4/d2KfE?T6LbEZA,L;0U
#2)DcV[+\Z>3Y>:W(2f?,&#egYA).SCOVI4I;]-N^@@4=)b3GS:F@E)>X1<F?,WT
))\OHeVb2YC.EG/aX8e3DI\Q+V)<;CUeaa6@E&Y=1dJM=;LM@\Rca^?,,[Y677fX
OYSDERC_=@-?Ce5bY9;NXD3.#.KOF8^BbQ?W^G@24;[CE[0#>,W)K^>NK=3\@B3O
@HdB]4b/3(LP1NQe]CT6S(7CE0F^EeRD:#7INOTfTHYK/,<./>a].\+B<=a^F?DK
3KB9-Ae_g\3@,d?:Kg[>4FMY&1G06,>CVRD:]d?<3]2-XE0:d6G3.Q0=3\)^gF#e
)cWZ>5C5Q]MVT?,A;FOcRV[\8cW=&3Y_FcJgVH,NBBUQEW.EC6\>)]aNI9B+eGgF
S]]IePD.0UI3VM:>RFIOARQAbHE.(PN8^::.T\+e\C#=)X=_-CaNDTd)49S+0H)C
_a9D3ee14L8RB+ceWY@g:EY@(E]=23^RB6TA-&3@:64bGZ;^>1POO<@W.#Sa^[XO
?I#Z/HSC<&J#05b?Y@LDcC(HW^bTT/cCG;#1Q4PL0b;6Zdd3CH63JF[DNT,)O^b?
W)WH6aSH]Ya[1Gd[Y?Y-XE[9FVIM4D88&;(14(U_f6K0/<OW]:O0&<F,Qf^a?YL0
90OO8[Z352ZC>4:0G2?Q0@a_4R3AV,3<Q\FD9&PCR:#Q#WFdI<MdW2FF-.9VK][4
>\R1X,C/UB+.AMf,I:LVdIGIMRP6Gbb65^fJWbT6[1V79H]@Pd=@Lb)@YTL3BNZU
X-dgS=e@AR(QMB):J)T_)KPd:-:A#WaCCLW[A6QKX>E1M:@:@=;;X^+[;R)X?0@^U$
`endprotected


  // ****************************************************************************
  // Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /** Constructor */
  extern /** local **/ function new();

  /** Singleton accessor method */
  extern static function svt_randomize_assistant get();

  //----------------------------------------------------------------------------
  /**
   * Sets the distribution control for this class.  These values are used by the
   * get_rand_range_real() method.
   * 
   * @param max Percent chance that the returned value will result in the maximum value
   * 
   * @param min Percent chance that the returned value will result in the minimum value
   * 
   * @param mid Percent chance that the returned value will result in a value that is
   * in the approximate midpoint between the min and max value.
   */
  extern function void set_range_weight(int unsigned max = 33, int unsigned min = 33, int unsigned mid = 25);

  //----------------------------------------------------------------------------
  /**
   * Returns a 'real' value that falls between the provided values.  The weightings
   * applied to the returned value can be set using set_range_weight().
   * 
   * @param min_value Lower bound for the range
   * 
   * @param max_value Upper bound for the range
   */
  extern function real get_rand_range_real(real min_value, real max_value);

endclass: svt_randomize_assistant

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
R>0P3&e\a^dJd87?H59C+\X3E51V;8-\Z54#WS+;#+OgI^M\@?>[6(K4LPXD[+L2
^#Y/65)>8WVN[Ka0GZdEHA(PY9&Z?Jg+KN)1?#K;+)20KdbJaK3)6Yf;)?eE?DMM
>08#15cQ(][#YE0Wd0/S2&(+gRHLC]6@d-9O?)[5,_V>dXWI^7YcAMB->,gMFS)X
[B2,++HS=T<Zb9e,Ob@G]2a+b2La7g=.cZ/>OLBBe1GHWc1^b8MM_IY/R97#e:IN
f>4,)0H5d\[0QfF(C4I??B=<8(;^?A+&F+HJDCVf+Qe]SI2Qa@f+WU0>(.M,-^(3
Xa^ZGF#=f#2d/EcKCPV1I;V9/&78gB.CI-D\Y,GRb7H5^.YA)X.583PbY=09E>:;
W+BMUN,=dRd/HO<6Te3E9f<S@?#/+35567N0=HNTWJL<DRX)3@_[,^?Hf-<MP2VH
6(XPRG8>?((Lf0B,DQ,4]Z80cBNQBQf)E8VRe&?F2K^0VbQ?.FKDQ:K]dX#fP_>0
^5b?eaA@8/;J7+,INR;Y&:/EKOU/22P3MVHQJ=Xc8AZ;f6/a:H9NSNH3I>H<O;JH
\(@XN5+7<#]8CP<dJ_J8M9/X,<9^8,>84CN#Ta/A6=G394OgWA<8T(dT7[3+F&3R
>0]6<O&SK9NSCHF\7+JadSbY1f&22))O9),^B\B2:H<WWP[_8S-H2SDgA<g1Ca\4
GKM-5;d>#&J[aD#XBO<<&@:WDNPe&TFF@YXYbQJWQ&g=@;)HXc9\))\Xc(PWKE,\
8[\_N5@bATO#]JR99#aW9dV(1OF.V-(La.5cdSd>2Kf,&F05A7\>7^F;GR9T/1gV
IE7SP(M)SA)\XL_I4#bQ5&LD+>E/L/0f<R8<gbS=\JWVUXIe[/2&9=K8Jb.g.ceR
PF?IaE,H<\TZEQ4CL(?I,KeKV7JPV9S07EKF,Rb5+DcJ=V2,V:>0Q5M/M8g-M)PG
L@F<^ZfHZ5GfJ?GQ+R;;^:;c]c8I>E2RBZgIP6^#88VZ<NVHQA[R[0#1[OOd-Z8\
X,8cIEZ]2;9gTA@IHB_JQKP(HX=/Y;(+=+ID-R[9ACR##C@Q^>NJ5-=Gf,IFdLQa
d\5?O105&6=:_b/e4<OQb3e5D/GPDY)XLJ:/(bX=JcRG0]5L3eW;I.3QIEMV^HSQ
F@&8bPGa6a7WM+>)[1#)N3:TE6,2d,cS,TG4\D;#9.)>7SgGUEF-eI2W+EU:fd)8
3HY,Z:@ENP=.FRBY-0[MS]?-B)Wg>KRXBHV_a3eZ[45;XNF>b>@D#ZLVePe\CbK6
H\6#6E)Pd9J-/6F^7NCVZG,WJgGQE,-eHf&3N.]H^2\L[e4O-cGYB/BLZO;8XA,(
T;)gU>OU-0IIdNIM)8UKTVL;GX72ZJ)f7.V4X8NXeDVQBX;>UO7e>[[L-A?E@_eB
RY+P5;EFZ<[I@e#4_87&53<,2WBS16PGa/d=PR&[;TQA&U+NW0X56ZNd[GLAMGX(
@YD3E>D,1B]=-HF[8K>F+#,+-G;_YD1^<Z>[3>g&1;X5PXZ_8?>13PUT6\])0d6C
K;+59.fXBbOB,DDe2aa)U01-71JfW4/]&][9T-W@1Xd91RQ)G[RJ68A#Q&>#C.:T
Yc_K8HP?>_57+^NQQMQ2@7S3A9J&866;]K)XUKDF\;Z(IB[f>ZAUC>Oa^11>TN3b
UdY=bE3/,eEYXNSOI>.[S^>^U_a;U2d++_<0[N[A;1&Lb61baD4\SS86cD9MDB1=
BPVTgPdM_L+0JgZ=YeL5/8/J_YNcE)6GgM(^L4?Z0/U^6Pc-4SWDg)J^HEHGTLc@
13]IF@RH]MXGc>CMK<e<&[4&YL,D,&G;g@_MEg?&ZBcV=\_0N<g1D#SP]U7Z<#.Q
?9NED_HUa3,8&0^#1]^EN&A^_C0(a-6G]@[[dWVNW=.Q9CG>g,H4,4R)ZEf\2BT4
J#YD]]^TJ(.A.Y(3-aP,AMcRgEZ,W_-Y=1ZDVQRW7_0QD$
`endprotected


`endif // GUARD_SVT_RANDOMIZE_ASSISTANT_SV
