//=======================================================================
// COPYRIGHT (C) 2007-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_MEM_MONITOR_SV
`define GUARD_SVT_MEM_MONITOR_SV

//typedef class svt_mem_monitor_callback;

// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT MEM UVM/OVM monitors.
 */
virtual class svt_mem_monitor#(type REQ=svt_mem_transaction) extends svt_monitor#(REQ);

  //`svt_xvm_register_cb(svt_mem_monitor#(REQ), svt_mem_monitor_callback)

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
/** @cond PRIVATE */
  /** Monitor Configuration */
  local svt_mem_configuration cfg = null;

 /** Monitor Configuration snapshot */
  protected svt_mem_configuration cfg_snapshot = null;

/** @endcond */

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new monitor instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name
   * 
   * @param parent Handle to the hierarchical parent
   * 
   * @param suite_name Identifies the product suite to which the monitor object belongs.
   */
  extern function new(string name, `SVT_XVM(component) parent, string suite_name="svt_mem_monitor");

  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
`ifdef SVT_UVM_TECHNOLOGY
  /** UVM build phase */
  extern virtual function void build_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern virtual function void build();
`endif

`ifdef SVT_UVM_TECHNOLOGY
  /** UVM run phase */
  extern virtual task run_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  /** OVM run phase */
  extern virtual task run();
`endif

  //----------------------------------------------------------------------------
  /**
   * Updates the monitor's configuration with data from the supplied object.
   * This method always results in a call to change_dynamic_cfg(). If the monitor
   * has not been started calling this method also results in a call to
   * change_static_cfg().
   */
  extern virtual function void reconfigure(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns a copy of the monitor's configuration object, including the
   * current configuration settings. If cfg is null, creates configuration object
   * of appropriate type.
   */
  extern virtual function void get_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the argument
   * into the configuration object stored in the monitor. Used internally
   * by reconfigure; not to be called directly.
   */
  extern virtual protected function void change_static_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the argument
   * into the configuration object stored in the monitor. Used internally
   * by reconfigure; not to be called directly.
   */
  extern virtual protected function void change_dynamic_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the configuration
   * object stored in the monitor into the argument. If cfg is null,
   * creates config object of appropriate type. Used internally by get_cfg;
   * not to be called directly.
   */
  virtual protected function void get_static_cfg(ref svt_configuration cfg);
`ifdef SVT_MULTI_SIM_EMPTY_METHOD_FLAGGED_AS_UNIMP
    int dummy = 0;
`endif
  endfunction : get_static_cfg

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the configuration
   * object stored in the monitor into the argument. If cfg is null,
   * creates configuration object of appropriate type. Used internally by get_cfg;
   * not to be called directly.
   */
  virtual protected function void get_dynamic_cfg(ref svt_configuration cfg);
`ifdef SVT_MULTI_SIM_EMPTY_METHOD_FLAGGED_AS_UNIMP
    int dummy = 0;
`endif
  endfunction : get_dynamic_cfg

`protected
DT\21P)4EU)IF-V_Z:\NM@\@^?QO&LBFFMUe2V(6FS1ROV85],V-+)1>dDC27+Zd
+0?TLEWRe0<I0$
`endprotected


  // ---------------------------------------------------------------------------
endclass


// =============================================================================

`protected
[<Sg0b&6193S_BgR<QRM(88+7C;.-&a7^?=Q<H?D=ENI])6cQ\A@2)PJ2>94(bHC
DW<V54>1BFDFabVG<:GI6)bbD^A@19H]HIH9>(D35+#=a>IgcD>YX=YX?_=9#aN:
9^7;=e_@/NK\cK+#gO6_&&NL,4)?&(4T7>DHW=a(c;8:.<Y,R[W&+5-0\;XT].#X
A33Mc.@@8W=g>XXd_=#b]^b<F1fWG7J;aT3MB\E)CeA3Xc42Sc;GIR,5FGDeAYC:
0VEQG,Y^XKgg/$
`endprotected

// -----------------------------------------------------------------------------

//svt_vcs_lic_vip_protect
`protected
U@=DD,Xc8@\cdaY:5=5&Cb7YD47gEWbOS87#6D1?1_<L-D.[\;K4,(93e>M@7@FO
QOc8cKPC?7RR&B>=P,\CSF[e?R50+b/03_@8D^.FZJ0C[:XL108^VgFOa=H;KT(N
2aI)bdU;9(>8\4/T4J&;YLX/CBOJDXA6WfZ]KRe#1MA2^WA\\PLga:a_K1;\SWT1
]?DJ6Rd;?[QXG(.gB=TR+LEQ@O&,ELdb0U1C(Jf<R].L:]<4(9IK1-6JdQF]Y8.^
0EW[^4>V#_/JP7]Bb8XI,ca4PEBF1@7IK&Oaceg>B\(S8)^-0W>Cb?&<Cg6N>]G:
8NU8=>20=.gGZdXF.(/Z]Ba94a9EaHX0KR.A/5)a]530ZG3E-fHEF1L\[A(7:0H;
MeW+JLbN.YX(LTgP0eL9(S.A+WDSKB-=g&3MHTU>>ABEQY>\F]CSC<a[+;B+Y4^g
:6]#G0fV\;\3FcC5XL5RIGKID-VZa+)(CL6MP^:[3_T7Tb:eI\#(T6ANJK/=92LO
QT#cUc=Y9E/-8[0LZFNI5FIHKQ]QBM(J.R3S?,Q(N6@^g]aYgX(e8c[WN=H2IM33
@MQUM8][5>PQ7G=4FCSU]V.G^1&6]HBgJc.ZgV(aeIe]<KITU<.-.C_Jbc3>HUP-
^5]6F4@XQ54:c</8Z<cTELJ[dI]S42Fa#]H5M7IeIE45/NCOGAMDIO\FB;><6>b^
O/KgK?F/F=JB-&dES4#G@Y8E@2>Q@]Z]_0<K7FaJT>,:BUY2E(:P1FF)@K?\BU3F
X<=O[#])f,L96#XJ/1<E-L=TA\#G#:gOg<D+GIg(HgLa@f#NDSF)A;6P3Z,)f?.V
328,^>ggcA#3<VIB]bH[6X/fM_bJ@])aL9-E>Q(14\OJee6YNPX]9L8Ib8a;:9B-
Qg^2f;#+2884e+;2L80\@ZDR;,+K8<N=9fBNRCN=EM].(_a?W8([#,JV6gV&3(77
T/c;V.=eIQ^Q)24V&29a(gSU<12fLUa5H_[DORJ=I8Z[U;L\VLQ9#g-3gI/P\-O2
0Y949C7WC^UU8Z>P/F)A+bYL,9e\OPUT-g(C1Ieb<9XG<C#S#c>@#gQ4c[6\5L;7
.<-SSW3fDE&J8KaSWc1T#03RV>?/42<:?O.SM?>VG4MO7[VB2QR@+YeBAa4B<54g
(a&+g5)D2Qc&9,1\YU0PT\@PW;N/^f,<=gZ(;8R;M0G7DDTM&(Wb\#Yg1N+g[>UT
<7a)gfMNXgY7:WU?XMJIBT,3C3_<S@:]Z+J9I,8^dFWA85L#&:YQRG+6=[&TB=5f
B?-<Y?-HZgFQ>>B3=E/Ha>Zf_8_1#=3[:RYW#WY0G30>I(Y\,Wd];(K^+;?da&Kg
D+_K[ZfgOXST&>J._<;/a6(=-@7DE^Q[RDTK-<Z5G(;I+aA4\M)d.cDS1L)I->aL
UX\WA:;_f1J3XKYKZ,a9NMI0+FH5.c\<YK@TJJaXOd-Wc?8FW9fS;BWaDE7\WbQ/
D9G?#Q2+3gBWPLf7ED;=H-LLdX_\gO\FYJW[<U]Z6VEL5^3=50MbZ_eKZ1Z\/d+K
YDE,2(EGC;>EM#e3\NOdVT(WUfLe;=Y9#GC]?X+2?B0M#6QAY#;=g9,[Mf#Y1LLa
,0PH=&HYQ]I#4TMB=SB0MTKADTf1b_f;>ESFac&V-?f&I@\G3RRXV2SEPg-&C2cc
aB.7#<E8>\KdV:3-A1XCBFYggMd>AE2T[;d/Y3>Z-BSgSI1d[SgUeM>^ZKS31HWC
JTQC?I6g,CLU4Q)1#1V1\)aW3gg1;;:87TH#=?X&b&e[7\\_EW^+RNKg3E<3BP=1
?(:QV)NfJg;_7b/+E=KYEDO(T@>MXCcd+f-,Xff(P:CBDAaK.?K]HTI=HVT[:G,U
F=MWM]CZ_]-9&VA-R5[<X(T3]9FL&+#9#_e+Q[dR8)c.;;1(.6(-,RO0+B8eS3AX
(1.X^I3g>F7ecR]c4PET;e8+\SV.JPAUb_GdWGg50GLL0&NALP:>8-YbDY3I=76/
Db,J)d;S?BG0=X@KX4K8#bKW7EWb33FY[]+cK)WD.A0f^DaUIcO#@<MdZgR.R.Jg
FUSRQ-O+E.[]S=CQ24R>2PEeg&4<1<)MD-X:Qc6D1[+aDWUY:#6,1#If38^88)<0
)YUJC)GU#F3I(#dAEBDSQ+C<X#XU]6.PX:7TUP7./^08^KE=UA7KgeZF.\/M=)ce
2@>c5._JQO:RbT0f3>0I1?R0Z5#;S?6bQC2Ef^D,#((bTc<:P::2GKRDDR?ZO@J,
beg(0f,^cR]6TQ_QQ;1&]=JE1)C?g2cPe8:WS28+3X7^>:0N]ebB1d0dP>GA(9b\
-5_ETZ.)c:gEgRe/;K?/eSeHS_S1HSeNbfIRP&EFMcECPQg8S5_:)_\IL+7(U;7M
XWe;12451-f?AD\MKFX),;GV<KAc+ONUNR1]MDgcIQUX#C]PW-gcKG#YSO/Oc>99
b<F]EACEMfR2@7TdRLfcXO:?BG;aD66c4S=8fJ93B406L/Z6#&NBcOYLY_W2&1N+
fZ,&a5-E4?:<#dAWP@:IfU.DUEINYC+H]C=2?5g&YRe_7<Fe,SC_/3I7d)\@4,T7
b\Y(A6<Rb(M17XC&/HBI2\N0g(;UBFETN4CZA.=@MWgX/gFEDCTLYVWECPOL?+FI
,R8@^[2W-+S6X3L4FU67dO:EUVZ.BMBc[1IX)4],L((K,G?Z07>Ef?E#:E+LBC/-
>3a30N.b_+U2SOFO6V?)K@=V\3U@\][Z#;_QRQOFYV4#0ObJU4;NB7JW\0a;L7+(
@RA8Mc6,/eQH_)d-7QHSWH59JZR1fAS.R4&F<@KE\AQ?@+e#V[,g\.D3-:IKGf5N
EReLU7MRaZL8d=V[a_\GTB8b0a3d8+DJH>#cS-/&dF#U#]b#9@:[IQ\=ERA6/ICB
e&Q=ATOJ3=LgP4.eR[;).\ZEWcCS=&J6+=/2F[dBMVV6?4CCP^Ld,fQ=ddMBM#EP
^]SEPXF_Je6MW0aN8=8:WI6J^&OK)R@XY\J;Lg-0F5[F\3?Z4gKY(N9QO<P9UAe,
]\JT149DH8@@GZ?_EWPEONRA-]D4cB2H\da&SaS/eIQ9:J1PG)RVSBD4-9A6+RIH
B3L4aYWH/N4Z[3[940e?fSX>E<O,7QOF>T<;.81dd:MKQb;c/>/;@>b?O5U#VCR9
TY?dOJ-TeSQ.BH,RP+>>#Y?LUEW3:O&HBJ@)e:\L[VKKIXW/)Y_W^AZ2Z_UcB>;D
:adZ4.MQR@\B780C(gaPCeV<QN)2aO#QN85[Q[4EP^gZcfHWRfYg<]O&>F[A:L7>
B)0BCR(LFg^f<.=g]gDdV(TRXB76Z(g,\.gQEDDd(dH--?=5AfI36T[Y=@YJI,/B
J\e<;f/>YfUT>?<G,?W5b22f;@e>M[QKT4\+9e2b3WP#\IP<Gb]J6T]5&bYPa6>&
bCVY.9^F?5RQ>1BabL^5KeNVH<Q50eRCbU9(fWF=L(EXH-T809Cf8,=7M&6a76,N
.0ZC&SO-NdD:K(S&2D_[\e9aIa5&-Z[7Y#&dD,^PT30P;e@4>S6)HLAUR4cP0L<&
DfWLZ&]>SWB5aNT7[^0Cf+(F,NR^JMG/[)8g+YEUXYAPB$
`endprotected


`endif // GUARD_SVT_MEM_MONITOR_SV
