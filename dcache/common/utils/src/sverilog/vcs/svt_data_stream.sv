//--------------------------------------------------------------------------
// COPYRIGHT (C) 2012-2014 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//--------------------------------------------------------------------------

`ifndef GUARD_SVT_DATA_STREAM_SV
`define GUARD_SVT_DATA_STREAM_SV 

/** @cond PRIVATE */

// =============================================================================
/**
  * This class defines a generic Data Stream representation, for easily managing
  * the access to the transactions flowing through this data stream. The class
  * provides for basic 'passive' and 'active' dataflow, with basic accessor
  * methods for both of these flows.
  */
class svt_data_stream#(type T=`SVT_TRANSACTION_TYPE);

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Protected Data Properties
  //----------------------------------------------------------------------------

  /** Next active transaction recognized in the data stream. */ 
  protected T active_xact = null;

  /** Next passive transaction recognized in the data stream. */ 
  protected T passive_xact = null;

  //----------------------------------------------------------------------------
  // local Data Properties
  //----------------------------------------------------------------------------
   
  /** Semaphore to control simultaneous set_active_xact calls.  */ 
  local semaphore active_xact_semaphore;

  /** Semaphore to control simultaneous set_passive_xact calls.  */ 
  local semaphore passive_xact_semaphore;

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new data stream instance.
   */
  extern function new();

  //----------------------------------------------------------------------------
  /**
   * Method designed to make it easy to wait for the arrival of the 'next' active
   * transaction.
   *
   * @param xact Active transaction delivered upon arrival.
   */
  extern task get_active_xact(ref T xact);

  //----------------------------------------------------------------------------
  /**
   * Method used to set the active transaction.
   *
   * @param xact New active transaction to be associated with the stream.
   */
  extern task set_active_xact(T xact);

  //----------------------------------------------------------------------------
  /**
   * Method to make the active sets blocking. This should be used to avoid overrides on the set.
   */
  extern function void enable_blocking_set_active_xact();

  //----------------------------------------------------------------------------
  /**
   * Method designed to make it easy to wait for the arrival of the 'next' passive
   * transaction.
   *
   * @param xact Passive transaction delivered upon arrival.
   */
  extern task get_passive_xact(ref T xact);

  //----------------------------------------------------------------------------
  /**
   * Method used to set the passive transaction.
   *
   * @param xact New passive transaction to be associated with the stream.
   */
  extern task set_passive_xact(T xact);

  //----------------------------------------------------------------------------
  /**
   * Method to make the passive sets blocking. This should be used to avoid overrides on the set.
   */
  extern function void enable_blocking_set_passive_xact();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//vcs_vip_protect
`protected
+C&C)OB<P01d)aP\(Md\/GbN:7\O.M.M7@[6>c(=>F<98&86TD\Y&(V#GO:[7BYT
1bNebJFN@X9Q#c)]-(d68Y1A#BNE0VLUMJ8QI8M<QBDg/3[<fO)#P(4(a5M[2C#R
4RJGOH2T3gK7SFW8FeANb(bRg>A0>:3>3;4\4.gYF59]_KI9&IXSLJG,4/[7W867
?2/daZ_R\#:ZRWF+\1AQ6YX6ffFW][e7>)Ue]G4A_7.=3@2E0LO^T^6^GZb\Cc>1
J^]@?>dX5W)e>e&PLcJc8M][EF.4W:QD]-0-14#ADH3YHOYOa2#)6/5:GS9;-bJ(
JcH3^-DPTTM7NV10,??BA5ZIg5NVHeM?e81E\?32GQ)=2Be#))&Yb+6CV>?\\b:2
0.ZC>>1K2HDTOc&LR>/K161GJeY?VE(9D;?MaA[4:BH(Z8=gD</K,.7@NB,2_a1-
@G&.VA5,3KV;8(]R0e(fAe+G^1^<&6HUK[56K+aDDdA-BVTg@JQEL9[/>BE;59AV
3aRM0@H)0V^AA1EP;)00&PNN0:D)_e1:79(d[-LZ.eXTb2^P7c89^4KYdaQJC&Sg
L5GEYC+:.:O/#Hff]8>)U46gHLDDFG-)We&HL1S;#Lb/#@V,A[O-]1\fDVZb@V?D
9?=I+]?HIO/M.0PGW#0,;5K-VA#2&W9J;d;U^OOKOJ5I[#4J/Vd#=X#?^K14)ORK
9K1c5#K&a:,geYI6Be<_<\;AW4#52F)F@RBR>/>G5E[/E-2=f(=Zd56UJWFXFMM7
N15PS1-aJET9_UI,\6;36bf_4^;I3\#aOM\2e4B25:#9(7;]RgIA(9NPOX>9\M7=
&^GAIe+J>S5NMPG82.G#)@S79772eX1:FA1A]JRbKP&7RC,PFUKUQT+#FJ?/SI=f
^=PX&@_,3M^=9B[C?17;cadY-;Eg,V[,U4f0[6aU98=[+OI=P2H:T9WMA@(4+LBT
I8I029bL[GcgbHYGZ&M#9JW6JBH_;<0dBD&H_[La#_^LSCc^L8OCdPE>CY.)K+[_
ER/#Tb4fC-&:,(aHc)?ASJ[>[3bR_E-N_UQIB8TPJ)2A24JNKgeU+\g14&TKE)T^
P60?]4>L;M3FR3?bb2,X=D^VC?VE-RS2D:Q25&UZC==I[TCMb:KPRZ&B7HO3cd_2
(X#CJgg02\8SSRG[<&=@AG,WM-S7C;(?(U@Z5UHe9<AVE#EcBT[BHZB&17d00c=;
F)UV4B>6C&@3B&Z8_IR(&>X=W@c</OP=d]V[I;g2AU329,<D4Y/g(\6KGQ<(GgJg
INC(bG9U_Z<4==Q2@K;gP):2^CGC+@<Q^B2U1/;)fY51WRb)8Wf996?\f=56&a<+
ISA.M:,-T,7WT^9>(3.ZZ/\0&ZK=B)g=],a(WQ=_@B/[dL-)dGfO>6WWIgOcg;:=
D1&R@FW_V:3>8ffF>^5Q[NIZCa)EaU4CKgd5TI@HeYbN3(d_UTUA:Ga@LECU\;95
7<F;ZdBPAdYRP3.V.=-HZUDZNZ9-W/C7eE2AE)&A6ABU]MAgA&O#a\^4OV8P@V:X
4[G08;b7AaMO>5OR-?:J06?O2W;b9eNK_@JgDN+TBC=3XX<(fNb0_@FG3fa<K69@
.+7Ua\D@M>>FcT#bC2MDZA\7IDd)A3LL1R>6bV64;bged&5[_(5QBN421W3N?T5.
FU9a)/I9MeAO:^;TS<)>g_,<.FR(W(^YGV;Z1XV>TI/I1E(:NH_Q\@S:FA:_;Y_I
7G1LXEQ?G=g6f0Q.P3(BS&ggNH@7aHYYTG:J-eA+&6\&#MT]SVHAIQCX0)/+af9U
LK-c=VeU3[e:C3#90g3\VCd]I)DJX?AZcgJ+<(#g&[]:K,9e_OK2EAe&838Q>>-V
,1bH&.gdc+P2EO9^fZ@Od3>W@<\>[&6DG#0X<g_O8M08,VcfBWb@H\2+(AW68T&.
#V<L6LfHMQSH#T\>a_f<:M_#W^1W,?]6BV=RPL4RDgL34;L?.B^<@IDC_43X,Rf6
@E@26XELG1-IUIN)]7&841\CS-N#B#5&YSU<eS=JZE#9PF2>W(aQP,B8<INNJ)Ga
J)PZg+R]T/MJJ.XMMa1GVCGUE6+TTIgRfESf#R4=DOMN4:ARKP4adWe&J[dd#2AK
W6BM&2+<-(bMUEW+^c.TJY)-4?I&)cS?@ZYPGb5>BNGAB.98[&8d]S@#@P9g+.1_
MNdf+<OMEf[5a8)-9/-3/T;CC?8GX=Z5EUZ_-HIMPW;DEDdVK4[.4A01>@-><UG1
?f@b)LG)OCF&VK[U#:YJ#AZa@@D0Q&R[#KR9aD,#[C+)^SISab]e^/]]->I8&Q.4
?@=F&5AX/BXMbC67D6ZdG+;UNSQDGQ#eg6KU/,6YBc<DL[Sd]W[/S8.&&.e2L-CO
45A8.,O6C]J#7fV57HZ&gP;U7$
`endprotected


// =============================================================================
/** @endcond */

`endif // GUARD_SVT_DATA_STREAM_SV
