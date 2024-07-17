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

`ifndef GUARD_SVT_GPIO_DRIVER_SV
`define GUARD_SVT_GPIO_DRIVER_SV

`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_event_util)

// =============================================================================
/** Driver for a master component */
class svt_gpio_driver extends svt_driver#(svt_gpio_transaction);

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /**
   * Event triggers when driver consumes the transaction object. 
   * At this point, transaction object is not necessarily processed or transmitted on the bus.
   */
  `SVT_XVM(event) EVENT_XACT_CONSUMED;
  
  /**
   * Event triggers when the driver has started a transaction.
   */
  `SVT_XVM(event) EVENT_XACT_STARTED;

  /**
   * Event triggers when the driver has completed a transaction.
   */
  `SVT_XVM(event) EVENT_XACT_ENDED;

/** @cond PRIVATE */
  /** Analysis port to report completed tranasction in the absence of a monitor */
  `SVT_XVM(analysis_port)#(svt_gpio_transaction) item_executed_port;
/** @endcond */
  
  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

//svt_vcs_lic_vip_protect
`protected
Kc-DJ(.VX++,XMJ#(2d)5\7ZKfeCPBXK][N9]T@aJYCQ=?#=<8^e2(e.?8/)F9a9
J71HB;RMbLEPbS7C[f/H-c.Q)K.;O7d@dQGGe][-DEM;6(S64JQQ/GfRM^[210==
?8W:TaV<.3J2da-DdB/L@&;C9=Hfg?V71FZ?[HTLQdYSQ_J2#aPLF.VOg=4])N4W
Y3CLR<I[W_OW=D0Y4(,S)40YZ7L/NIbVD_BbQ26dNEV22+SadIg#30LPRFC9BW[K
1B/-b\XL=_])DEe?U<Y_A[@NeP/K?4K@cfa9QY.,YK=ffFdeIW@Ie)M_?4LWZ#H6
Na0N)4KPAea+<KNGP9WAH=XMT<?.W[beg\P(A\&]821.0?Ia8H7H[E35;gNOc]f(
->gaP@1.SX#\4e:&>MSec4RV1aAc2/T2>C7=/M[3e/QHP93cN&+(\6YdED@-2T)3
Y1(-H_2,a+.LGg,dU6+;88,+RLRXJbWb;$
`endprotected


  // ****************************************************************************
  // Field Macros
  // ****************************************************************************
  `svt_xvm_component_utils(svt_gpio_driver)


  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new driver instance
   * 
   * @param name The name of this instance.  Used to construct the hierarchy.
   * 
   * @param parent The component that contains this intance.  Used to construct
   * the hierarchy.
   */
  extern function new (string name, `SVT_XVM(component) parent);

  // ---------------------------------------------------------------------------
  /** Called when a new configuration is applied to the VIP */
  extern virtual function void reconfigure(svt_configuration cfg);

  // ---------------------------------------------------------------------------
  /**
   * Build Phase
   */
`ifdef SVT_UVM_TECHNOLOGY
  extern virtual function void build_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern virtual function void build();
`endif

  // ---------------------------------------------------------------------------
  /**
   * Run phase
   */
`ifdef SVT_UVM_TECHNOLOGY
  extern virtual task run_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  extern virtual task run();
`endif
  
/** @cond PRIVATE */
  //----------------------------------------------------------------------------
  /** PRIVATE METHODS */
  // ---------------------------------------------------------------------------
//svt_vcs_lic_vip_protect
`protected
LO>B0;eN144K29YcN2K6YRTJTb)c5HB_JMRf^Nb_e^ASeVR5QW>B((S]BG]?aUH+
\3A_E<-bO^d6P+W2]]?<KO_S[TA(JO14?FP@0b@SRTHe#A)]N0\+]60_d<F1=PVS
M@V3KP]]c3@59P+dK;9Q5M1R,ga]<-HZQB6>c;J4P>SVd_<1=HW@&DBB.0M5;H_[
2HS)A,Y(/_8+<1Z4IQLG9LLK[A_=]_9=3M.GODadL=Z22H-S6@aRJT9YNZEB23]M
4GcAPR0[[SH+,$
`endprotected

  //----------------------------------------------------------------------------

  /** Method which manages seq_item_port */
  extern protected task consume_from_seq_item_port();

/** @endcond */

  //----------------------------------------------------------------------------
  /** OOP CALLBACK METHODS provided by this driver. */
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Called before a transaction begins.
   * 
   * @param xact A reference to the descriptor for the transaction that is about to start.
   *             Modifying the transaction descriptor will modify the transaction that will be executed.
   * 
   * @param drop If set, the transaction will not be executed.
   */
  virtual task post_input_in_get(svt_gpio_transaction xact,
                                 ref bit drop);
  endtask

  /** 
   * Callback method called after a transaction has completed or an interrupt has been detected
   * 
   * @param xact A reference to the descriptor for the observed transaction or interrupt
   *             The transaction must not be modified.
   */
  virtual function void pre_observed_out_put(svt_gpio_transaction xact);
  endfunction

  /** 
   * Coverage callback method called after a transaction has completed or an interrupt has been detected
   * 
   * @param xact A reference to the descriptor for the observed transaction or interrupt
   *             The transaction must not be modified.
   */
  virtual function void observed_out_cov(svt_gpio_transaction xact);
  endfunction

endclass

//svt_vcs_lic_vip_protect
`protected
7Wb5Ub1\d,O02e,&F\aeXIf@LHgZIKKEb@):fWUY6[</21,e#Dd4(()LTD[F=B<D
A.a3+>US.DdGGW;;=B^A@Nc7JJAYgTeda9CPQ9R,)@LdIcFE.B8]UcV@)0Bf-3<S
1VeC.6YAfa<:ST\0Gf87d5(X;6LOU4OT&=,:=dEN_VD-LATDQ(.MNaN<SUHMLccS
O=Z1@)G1QDd+fAfVfLQeD1VgA/T.Y,;WZC&.=YFCTe[:)897d.EDGaY;bLRQ_MG-
\b\EN<\D)+9XGO6,L6W/>=^7cOaMS3c2K&I.A:Z=b8C_6Pa:#+beGTTK;XU]a,K5
YD3Y/BM;6ZH@]\_H:G04V,[d:T0&DIEMEBdSIb\4C&)Z-W72.)-.9JD22@Bb?QB+
c72&dA=Lb8HB,_U:^XCWD>M,I0M6)9\Y<;020Fg7AR(MXUb5a>bNL.>4cfISb8G)
<+:>G&]RIf34Y,JCaPBG<6&KcDP/[ed+b;AC;c;B^84VI:^(g.H/4L[[a@Zbbg.^
6\N?<Z8--UVW4^Z@Z-9^TbX8ZLfNe;QGV^Y+5\7_J=L<C?2X2.[RU/d]HN-YbX?J
FP766NPZc^-YNMG2Q5/ZTLDMZ]f@82:Z1N?TTX=cS;bc.cE3=>109M@\=#b&U/;L
T\I)a&ZeETO<3HII=Md)O-ABBJ>-4-#YHDQTM[:7a\6ddSQeTS.LFZ9WSKR2[D)0
BZM1\=D9<BF2IOY,>K<P9<)feRE.Y7[M5.CJ7LT8I^7,/7[]g3N]6BeGPdI4,E9D
->T.V4U.-]BD@5eIf1?g^cZ8)-Y/[#X>I)ZR_b603)-=T0F/(#Wdg07Kc.Ne6B:3
_fb7S860-0928dO_32Ud):AHW8Z>?eI>f=U2#^).#6OB2+1A0X[Eba+cXB9YWHIQ
Tfd@GC9-fW#C,GI<gNg8R)a0S.?ZEVO,3D@bg0D?;3=d@/T]D2a&O/HH[)IJB=CH
(2<:J]=g1X.8X96O?V\UPT[f\Uc:a)JgRe<[D>X5JH3VMQPLGA[f[GV]VZC?bCVJ
8N@?G8/&[IAfB>VSd@OII),Kd^DU/UH>C3T,4[IY-a4:])J#NGUT0eSa2LSd??.@
H],\LO@a8)ZYQI^]8f0I]#4SfW&cSQTT)BLDQ?]P+E>:EL19TYa8&R3YO1VV><]G
dV6QXOHag^9C1He1:]@WF6&+5T7X/+f0CXS)<<@^5R>PMU\KR28C?T2MZ3F70CGV
(eG6D3_SGK0eQ7dJQF/Y:C((1AN)S0Y=_W:)^]/cI:]SBCPH&g?bYE\bQ2Q3HfU;
YT?fMEC>Qf?cC]LBNe@<@&UV]3gf1IcKIdR0WEFF(L#a9-M</=UgBR)L-gP9TTV,
2b[4&ef^@aM#/O?aXJ;5>T_,U>#TV?]MNMF[JP?G#G2-02E/[ZU<(R,^R#,3BMb]
Y)@U80:6L+CJg.KCUK?bG>PU38.c-eW8Z[C,@=92K_@EH1H+EdBg:cGQ>4Zgeg[V
e6YQUf-OSELP_O,YG=c2[g0Q4:VI1Y0P>C90fZDeaZ]0.9X=QZECQTY>TaN68KUW
[>V4?fOg>W/e]4YcD6.6gT(0CQ/UZY5C,Yb,MD,De5\b@]\G-5fGQ2T[fJZ-#7OV
NfF01-F\^>-E25D5-J-89d.(QT,C5#Q;N_H\-=df19],P_9V[5+V[cEC;=X[b1[-
>e^J/&^@Id#/VbQQ.-<e].f\+]3AGJ2^JfS=;><&C[V[FH7T]H#[G[FB)#/eaXNH
>OZf38S>=4XYO^X1Z?3I9-?43&Y2>^QgL9R=)C;+V=-V&=^@1^RL:;^(9.E83T?c
+ZZe\D^8;3R&7fO=LQZ>9dMQGW4<e6#D:^6B6(\bCC)LSDL;J3N6\D/1Jd+0Vc#5
>/4?T]4+MH4aLAKd>P(I-Nc:+1VCD2Rd:QK&[/;5WFgRG048aCg=A1C12=3e,eRM
<+.I9QQQBIbHRJ1PIXN0^1<@C4K2RUE2ZY88VaCD)&<3)S(K+U8YN/U0?2I.X-08
CVAOde(0M&G3D:C6U[?AX^9R8=?0^ICSeFO14Cf#=V2;G,96RdfW3Ae23/WA/=>P
:c5?B^EO9+)\C0];@]gcN&]T8fMM\_W>\:86YVRAeANPWfTZYXB6QV)-I:DH38A\
d:fAL9GY>:VGKgFJ;5/VM5<P.KDY+U6MQWHEU#N\e8U5EbP;XICD,;DB@-0.F9M:
(Ig&MSe[S81\A-2NPG&AP_-6DU><GXB&WKHggHLHYQgD@Y2&D=(U-OVB.1>XY</G
QLUEH&NB@Z:P^R+bdT,E>_1A6#<N/<ZC^@6\dd-Y:6M@aMML1];&6aK.#VT-7O=0
LCN+,?K\+@+A<,P5>F#<(=ET2Ff6ZFV5ANg\1GP1@GZHJI-BUHU;MU.;cFXcS4Y2
P<^B/;fF<#c8DM53f^,YeI[OO^Bd]gGZ2UMM@+TFB5fAL3YK>\T=KU^U2PJ<_d[0
>,W<9PeT+#ZCGc+8P-bOYJ/8:DM3AHCP#JZ_>M.a7IW4@&I0BD6B\KG55T+./TW;
Z[^9SZPV@;EBRR1EW1?Z+fTXRfcBK.Q<UHO&\,ae.MHO;P)1PFZ_/V/19^;4T/7W
?;?fb4.T?LZK.ec(-H\b,T4>PAGG781.,\J6Y3-)&6^7eEBQJdBFT4eaWD2WLK?<
PY4-3^L09AOf\^WL8JPMF7_SNegCa3+a^#CLXB+PVI,V2+N/NU+X[ZPA:CSWR.F)
D/F4bN88[JcRcE(\8?Y)cJaZgD[2@Waf]N^,U=e7\EQ>bO_TY+]2&8?e<^RWN+QQ
P).&>)JDI>(ZE79OQ-?R6LKOQ3P[TdV]9?BH(=6BN=,fcCXH=GO/JQT:4Ud)Y:^:
_2C#C)1_V@\SDYS2Z,N5+.I:6d_X\-3V1MBMa@:WgTC@5,V1bc_J_T.6PJM:c92=
1KE_#Bcb_YIO7@:P?/2a/_&/9eJI6#eC6g/A(L>5OC\.NcfHZF,J#MQ;4W9XfLM;
b/VUJcY_PXb,,/I5LY]Y@Zd73;3)X:@H?&-a9Bcb)XH&X)XU5\4C[bR5.N]2[)UM
+2FEFVZGP)E,[<WB\24,7,C.WNd6)\248J&Z;4BFFP_aZ/0,WCe86[a8+F9TWX+Y
b+K-M1Ie.eE2Wb#;fG(EWIXM-aAd300,4\aQ84\VLM2Jb;N1M&.[PAa36]YLc\/d
OI=>-65EZe>X;2@_<6HWIc;dN+:609TODbUO7g-#.PAdH7e1XECNCE;6],.X8EC-
OgE)__UDcU:CXf98U#U?<=XY#D\R=W4.gGMV(78S&+K8]JUQUN,IQ1eY9KE_&>=5
SQ-<SCE(LMfV@0[K.aHa,T-XC)LKHbcM<A)_#59H-f-QCV>N/,&;)4(YdDWOCKHP
K7,7PS^/>B9_5[2-3e;X)NRF-XVG?P(]:$
`endprotected


`endif // GUARD_SVT_GPIO_DRIVER_SV
