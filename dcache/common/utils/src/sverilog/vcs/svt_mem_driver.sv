//--------------------------------------------------------------------------
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
//--------------------------------------------------------------------------

`ifndef GUARD_SVT_MEM_DRIVER_SV
`define GUARD_SVT_MEM_DRIVER_SV

typedef class svt_mem_driver_callback;

// =============================================================================
/**
 * This class is a memory driver class.  It extends the svt_reactive_driver base
 * class and adds the seq_item_port necessary to connect with an #svt_mem_sequencer.
 */
class svt_mem_driver extends svt_reactive_driver#(svt_mem_transaction);

`ifndef SVT_VMM_TECHNOLOGY
  `svt_xvm_register_cb(svt_mem_driver, svt_mem_driver_callback)
  `svt_xvm_component_utils(svt_mem_driver)
`endif

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************


  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
  
/** @cond PRIVATE */

  // ****************************************************************************
  // Local Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new driver instance
   * 
   * @param name The name of this class.
   * 
   * @param cfg The configuration descriptor for this instance
   * 
   * @param suite_name The name of the VIP suite
   */
  extern function new (string name, svt_configuration cfg, string suite_name="");

`else

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new driver instance
   * 
   * @param name The name of this instance.  Used to construct the hierarchy.
   * 
   * @param parent The component that contains this intance.  Used to construct
   * the hierarchy.
   */
  extern function new (string name, `SVT_XVM(component) parent, string suite_name="");

`endif

  // ---------------------------------------------------------------------------
  /** Called when a new configuration is applied to the VIP */
  extern virtual function void reconfigure(svt_configuration cfg);

  // ---------------------------------------------------------------------------
/** @endcond */

  //----------------------------------------------------------------------------
  /** OOP CALLBACK METHODS available in this class. */
  //----------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  /** 
   * Called before sending a request to memory reactive sequencer.
   * Modifying the request descriptor will modify the request itself.
   * 
   * @param req A reference to the memory request descriptor
   * 
   */
  extern virtual protected function void pre_request_put(svt_mem_transaction req);

  // ---------------------------------------------------------------------------
  /** 
   * Called after getting a response from the memory reactive sequencer,
   * but before the post_responsed_get_cov callbacks are executed.
   * Modifying the response descriptor will modify the response itself.
   * 
   * @param rsp A reference to the memory response descriptor
   * 
   */
  extern virtual protected function void post_response_get(svt_mem_transaction rsp);

  // ---------------------------------------------------------------------------
  /** 
   * Called after the post_response_get callbacks have been executed,
   * but before the response is physically executed by the driver.
   * The request and response descriptors must not be modified.
   * In most cases, both the request and response descriptors are the same objects.
   * 
   * @param req A reference to the memory request descriptor
   * 
   * @param rsp A reference to the memory response descriptor
   * 
   */
  extern virtual protected function void post_response_get_cov(svt_mem_transaction req, svt_mem_transaction rsp);

  //----------------------------------------------------------------------------
  /**
   * Called when the driver starts executing the memory transaction response.
   * The memory request and response descriptors should not be modified.
   *
   * @param req A reference to the memory request descriptor
   * 
   * @param rsp A reference to the memory response descriptor
   */
   extern virtual protected function void transaction_started(svt_mem_transaction req, svt_mem_transaction rsp);

  //----------------------------------------------------------------------------
  /**
   * Called after the memory transaction has been completely executed.
   * The memory request and response descriptors must not be modified.
   * In most cases, both the request and response descriptors are the same objects.
   *
   * @param req A reference to the memory request descriptor
   * 
   * @param rslt A reference to the completed memory transaction descriptor.
   */
  extern virtual protected function void transaction_ended(svt_mem_transaction req, svt_mem_transaction rslt);


/** @cond PRIVATE */
  // ---------------------------------------------------------------------------
  /** INHERITED METHODS Implemented in this class. */
  // ---------------------------------------------------------------------------
  extern virtual protected function void change_static_cfg(svt_configuration cfg);
  // ---------------------------------------------------------------------------
  extern virtual protected function void change_dynamic_cfg(svt_configuration cfg);
  // ---------------------------------------------------------------------------
  extern virtual protected function void  get_static_cfg(ref svt_configuration cfg);
  // ---------------------------------------------------------------------------
  extern virtual protected function void  get_dynamic_cfg(ref svt_configuration cfg);

  // ---------------------------------------------------------------------------
  extern virtual protected function svt_mem_configuration  get_mem_configuration();
  // ---------------------------------------------------------------------------
  extern virtual protected function svt_mem_configuration  get_mem_configuration_snapshot();

  //----------------------------------------------------------------------------
  /** PRIVATE METHODS */
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Invoke the pre_request_put() method followed by all registered
   * svt_mem_driver_callback::pre_request_put() methods.
   * This method must be called immediately before calling svt_mem_driver::item_req().
   * 
   * When overriding this method in an extended classes, care must be taken to ensure
   * that the callbacks get executed correctly.
   *
   * @param req A reference to the memory request descriptor.
   * 
   * Note that, unlike the other *#_cb_exec() method, this one is a function.
   * This is because it is typically called from FSM callback functions.
   */
  extern virtual function void pre_request_put_cb_exec(svt_mem_transaction req);

  // ---------------------------------------------------------------------------
  /**
   * Invoke the post_response_get() method followed by all registered
   * svt_mem_driver_callback::post_response_get() methods.
   * This method must be called immediately after seq_item_port.#get_next_item() (UVM/OVM)
   * or rsp.#peek() (VMM) return.
   * 
   * When overriding this method in an extended classes, care must be taken to ensure
   * that the callbacks get executed correctly.
   *
   * @param rsp A reference to the memory response descriptor.
   */
  extern virtual task post_response_get_cb_exec(svt_mem_transaction rsp);

  // ---------------------------------------------------------------------------
  /**
   * Then invoke the post_response_get_cov() method followed by all registered
   * svt_mem_driver_callback::post_response_get_cov() methods.
   * This method must be called immediately after calling post_response_get_cb_exec().
   * 
   * When overriding this method in an extended classes, care must be taken to ensure
   * that the callbacks get executed correctly.
   *
   * @param req A reference to the memory request descriptor.
   * 
   * @param rsp A reference to the memory response descriptor.
   */
  extern virtual task post_response_get_cov_cb_exec(svt_mem_transaction req, svt_mem_transaction rsp);

  // ---------------------------------------------------------------------------
  /**
   * Then invoke the transaction_started() method followed by all registered
   * svt_mem_driver_callback::transaction_started() methods.
   * This method must be called immediately after calling post_response_get_cov_cb_exec().
   * 
   * When overriding this method in an extended classes, care must be taken to ensure
   * that the callbacks get executed correctly.
   *
   * @param req A reference to the memory request descriptor.
   * 
   * @param rsp A reference to the memory response descriptor.
   */
  extern virtual task transaction_started_cb_exec(svt_mem_transaction req, svt_mem_transaction rsp);

  // ---------------------------------------------------------------------------
  /**
   * Invoke the transaction_ended() method followed by all registered
   * svt_mem_driver_callback::transaction_ended() methods.
   * This method must be called immediately before calling seq_item_port.#finish_item() (UVM/OVM)
   * or rsp.#get() (VMM).
   * 
   * When overriding this method in an extended classes, care must be taken to ensure
   * that the callbacks get executed correctly.
   *
   * @param req A reference to the memory request descriptor.
   *
   * @param rslt A reference to the memory response descriptor.
   */
  extern virtual task transaction_ended_cb_exec(svt_mem_transaction req, svt_mem_transaction rslt);

/** @endcond */

endclass

`protected
8#>)(MS8g<)DTY#3M.[:=M@5d++U>J2L.fG=_[]+50)O(9OX5_3S,)#VdVfIg(K_
47XY]T^Ve_FJgO@S7TO?(L:ER3KF/@K>RBN>5SL9\0&L.91a#bKB.VENL)9VB_S6
MPFe@JFJW:Y1M-H\-E:N6,W@:XBH8EZRY(c6U<51MVRKSY@;N0#OgC\])R5V9HW-
?#-]#.1(a9;g\PE4O3=gB;IAYI,CU[@B:,6I?YK_NR@@6UP^98US[111_\M_/@:A
7(E+^=Vb&0SQ3-H,Q448)?B@OAYfg07-ETE[B9aMF35Y6X#AEDfJV>4>K[e;gcZU
+3GNCQORNL2d6e15-UaKXgSX\U/QXL1>O]<E0L3D9=J6UT4.PPCKN</O[.M,a>G\
:AJRD]ZVLM/6[\+[XBDK6<6g8bcc0TU+JRO96_,bIGXK=8c.N>VdWc?MS/-PHVEI
_.RYF;gag)bD1_bEb^&/N.L.:ed.,CNW,FaHS.V,-]YFcf1V3e)L)QP.W9R0ZH)N
g:a20P6+_.?X&HVML&T^Pa4L<=9]&/Z48MQLJ8>D1_JFE$
`endprotected


// -----------------------------------------------------------------------------
//svt_vcs_lic_vip_protect
`protected
^d?7B/1?YR\IaY#>O\(dPOB#a.Jgcb.^UP[]A0[@3g4XJO;IX:ba4(/&7Zc))WKC
3XWcNaF]JI)]H.Z>C>U+N/R&A0A/d=Q:T9N1gL?^b/QZC\B6N-5e^>@Q51D]\HBc
#G5IS:dXZGfME(J(bJG@9bLJ25)f/1Z634<^G]Te:IB(:-TJ6\[&)Od_Q6PJXXC.
/9LeQ&fU1GTH@8VcUc#?GL4Ac(O<]VZHM^S<,eSVa/IX54<eL>Z64/g>H-U=I/2Z
(c@,0+==Z-@&fQ60YVDRM5(84+6;N@J7eH(2]MM2Q,UMDD^.]TXa<aKcUJIgOWb#
#8J;(cW=[D(8;WE8N/>2Z,.D)f)&c2BPU3a^A6GgaMEVc<_3fO&8dDFX\g]J6PC\
FC_GC9g2C>b:EKPW\:;_;B]Q=L2703S@6McSIQc\:AFTX.>E?CVfSb;9#fM94\=6
=-(&BZE53cLHM07Ed?,0:3Q54+QP?/X94#D?HM0Xc>8.G@-e:Z8C@SA?L]+//]DM
U.=eF;cO,P1P+(XaNA(bcdD-U\BV\Tg^A]Q)5dg;^E[c).?.Hg6EUB9^]Z0)HaFK
T>R-,Q3,Y1H8ae@IL.)2>+(Q:F@/,=&2YU2?36V]gcC9:#:JC9A#0G-QMIEdI@O2
H7-W9:351/IDd=Q<<GS<#62cQ7)@d0gDJY)P8R0S=@O/+?]1X?5+3C6fD^@9[(G/
YKe[?M3FXIC)g05<E>3aa60A6=<Fc_VaX5=bfJe=&dVR_[(H?.KcRRd@3:UE(DF_
>0c:/MKJcQ6JF7_b=fWLU)_;L(9ICe@aLG#6,>U[g2]D@QR@_:#&c:\Y:=:LI:DY
4bQeXP80d69a1C8Xf908)df-@#dR9ADKf2:9_&(3M3V_++9BU(JCV=gK]+.1/^)O
6a==,R+^K()U?=:X<DLHJQKJX@R@GOC@Kbe?I[2U]\R3.8Z?T<R.BPa#cR4<\V)F
?1)5=O5Ya7&+:RSA77>AK26>b[LU?HC37E=X,RJ+]7dTD+9<=^0OWE5c/99]U<V1
a4FV)4Bg6^aJb/ZM^]28#,/+aJY1g(K#N]MZ9-d0cBT^0V8T+7D4Xc#0D8V(@W\f
Aa[LK+bFM8bIZ8>c[f>1JbJW>Q:VJ&A6UBBc>ZS1F:QHa,L<RV,JX:^)f^<BAE,Q
X6>:=2,PEJGc[Y_D]Hc-578#E8UW_EUMBT>Ifd2;63H344L6KPD<BBBXcJ6N)W(5
Q,;S00TdI\/11&S+OZ.DLK2HWTY,0L?G=N>7UWF?L&7-8CQ1FX9:Wg8Y(BUWDbNS
+<08TaPIUS0d8]#TDUC;<_g[:eR.^@gcW-24CF@7_H-G0+;[1_<fIK(d1b=:)ZR#
M=HC7T?WJK+ZQPfVJOS3IDEW</46713LA)+N2+KM=JFSA=QT&X<,VR32eC>0FMB[
Y)VTUQg<,e?_XJQZMTdTW.[^Q,S8P<6N^T)Ka?Ec2H17JV_,BJ2O]XT1L(4(0&>[
AL03Z<T;XQF\IaK5#G^KGeb9[]7_-[=O9#3P,RYWK<CH4PW^?<B]DNZc)FW?70gI
ePeb80aQ)d:c,9.@4=;>^5=D0??\:1.,<.,\LceHI86U)H:F+cUXQ<Le1#DTRU8a
AT7BMb4F^MZ?RE^7<#2PX.10)TDW(8C2Y4>4_e2U[51F&.D0UV&@MC_BHS.Y9#a,
:L.,)ZZC>N\&bS0HF21Y+Af>0aTZ(L2Eg?E5@X\=0+gC;VDOQGfa2IG1BJED@J56
Ba=e8P>fD21=7Z5MPdYIOdCQ<2._97?@<<C4c6I)O/;cQR(3JTSe\0;]5aE:V:f^
).Be?@bO1:6\,\>Ed8+D@2]d<+6+:.W?0IANR.^b,6HP,1d-ZCAa43(8[gTc];]Q
P5TGW[Vf+X47THDW7fNM+<a89;0f;KTa#/@/f0J#=B+<IbNRE/W>ABO5/)gb15DH
U[.g@K6/.S#K93T7/^:KO[c96QQf33-e(X.J-VSEXXc1DI01R#:395=4XNQM5+9E
?A2?0:b@<f#5Z^Ffca;5a<I58@e;=I,\)-FQ3CE9+AeeOaG7BUO[6H\KQP8[WR-V
#Fa545a-Z6-^=[K5f1)4g<L/X]eV(dNHF0Q2K\LKc.I?dAU6WTG>JVV,3S9VC>=e
IF#V4]VU#FDfM6JS#f:):Y?[#,7F.6NIB-gBY,+^OIUN+]YGQUS11ZMS<USYRUcF
?@.BNP&IABZR8_6MHY\L4aNbeLe)1&O0dBg<bd5BLV,[AW?;[K;NA2a>EGKN_D[I
MgH+AVU#?8B_7+0T2#R\d]d)AI>._YXE;\.-Q50@FVEX3?Q1/F88<+FK1/NL.UcB
]7NJ/AO@OY+1BNFfQ03<1IYZ6496J/.85ZG4SVF]5G533[LBbI]CW[ALRb6.BI[H
](_+@UO4_+TMHQU4:Ig8GH<L3X8Be-+(RH>We([MbR894UPV:S@J_IRHK/5O77ZH
_SW7=OSEY4V<gJ;<U)<CLgZO;SA_JBR:,:ALb-4@<VI6HegbYaC619W;ILSJQ87<
RbOJb:4cC/cJ-V;M@=B:_53e5:\&4]A[&[\d]J8;4WIOA]dY_]cL8G>Q893I>95V
1^#6P2DSc?;gK&>VKA880Re67BO2+d,M?TJ//YI?Y[K5V-E1/9<A2YB#^0@FbRDF
R&<@N+DTZ9NFR;#LHe_:F8f@CIW[5SgG8BZM4/=<&S],4FU[<BC,R@,NgJ4+A/>/
1@JJE8dOVT^c=6.AMP.QO7Qd]Y&;[0[fN@W=:8#?=1ZX_V\eLfd,03,A9I>(d1_6
ea+2\PR(#)_RLMMFE1\aEd:,98NW(1])@10Wb;]&4;dLN=6,Ygb5eR0ET2TBDR[S
H(WX(fB8L#1K^PV<YAWF_[;0TX37H,_E)C9AbfD661QCMW<,V:FA-/52E&HM6M;-
@]dgH4dQ4+fNY_&CD@4ccO#.8d67>S0:0&?:X&8TQ@@,HRYVe&^dW(51RfO2]dNJ
6.07]^UQZ(8+S>O:RG/0+@6YVC,RV;M9+##&=UYQd26N&NT1,a?g=,A-UTSF8>I3
-7U0RKD;^W_RJ4>7J;E:SCL#6GQ(Eb:XE3#GD@4QX\_.S7/K5[d[><-EaU;Y_8M/
2EAA,6I3?0H(2Z,Sg[@ePV1RYODeD.):(6^(?GHV3>6IOL[QY7RLLg[-GW5PH\e-
f7a&1W?bVf&B7EE)F,W-RFFg7a0LUH#aN5V/K5g^?RZB(&#0XO57[M]Ta0WZGbW=
3-d-(EFS#Q7)H)?2]=OT8[1ZTKTBad#Z+^G#<5Xd_&WG174L^5]Ne=GB7?g\HQPb
+3D(a,FSASLKOW.V>\SM.E[_^]a0,@@KFZ-LAK;^/HNG+S7:I[XIQ89HA&OUc06&
3\Ae3WCde0a4MP5>IFCYOW5W31K6]Pa.YOUJ=^Q6(2gS6394Fd)[@7QL#39VSG;@
/IGd:MF[_d;<)R@]/8.RI6,LX64G.&E/-^Z?M5M=IbW4?:V58R#f5/0VP5Z]0a4-
(UDKYC_LI[9bA1R)<0=TUG)\,^R2#U9ZfdFb/RPE)A,XD>_ODT:#L7+b\gDV<@MF
@Q4FTFH)+cKeV(8/[dJ08BI3M,,@0-#c6Q-PQYF,c:8<Ha+EHQgQKE(7dRITYNOd
-fP1QR^#H0J4I0Z&TF?A@Iec(e=ZW?C0P^79G>>\\1T<0-fHKHJR:;FR(+9<WW5G
N)deaCT4C[9__dG?gcCE-4SJ0TW;]Y=YeO2JS[_NbQNM6]<16AJ9JU99Cb,YJ,(3
1)U&=Q[;IZT]WO&PU\Y[JaODF&[M2+A[^QRbI6Bd1B8?PdVXdQ89A2;?H,W[F1Q7
HR8975#HLAUe,T2OPP75GB3/#YL>M?Ee_WQ.N19U+)d@C&gUHd)+(N<NCdN6[e3Y
0^TN=R]ZS^+(U-HG-+??8?G[].88PdgO)CLYb4ge468W+d3I)7de)\,@AC;0/UA]
#?XDEa0:aU@a?a]/AEJ4ZJNE><_[Qf4=HG/[7[e56efebYI7[c3SYbVQP)/eI5OI
_QE7BdNb<Y_&b)U/9OU,@cc<G_][Q<3ON=;(KPS0BeO#MQd<1[fg=^OBC5G918/c
_/McMe+VQQO-P_F>>f(J\U)5(8QM#/WGN]G=46(&Qg&;4N/S.?U^0TF9P]IgP+R0
,6C?-Q#8,cOFV.Q\AVB:5^FLf2EL@+UQbPGH<2DDTRAdU1YCBE;[/,0JD25_7MS>
b75DQ>MY&F_J7e-PO.f7Bd]GV4+D+FT-:SU6O_KaG1(XF3cZ9dI_SG;EADVN:5D/
a9cD]FE6]M-4A>J38\YN>RDCcSE6BPM&D=>O.7b_T.D@D,,?BZK9_a+R8cALS=:Z
J=N:b_M(Y<W=J1>dHX3G\]KWaa;9R9MPX9,=9S+LT;F=ZaEa&HFUXZ@3F09&B-Pe
M?d:^70#AC+J)<c=gR.T&P=,b+3QPFP;+19S^XHe[^OH]&3HT76]:EDB4.[S6<9)
^K>86)>YYXATaa@dSJJZYE_?6f+1fY/[V2cJ4g3;^>,gSR,H+D(]P#)a3&]U>9-J
cOBO?/b_?<?;46#P-.NOS5.F,6]4Ef3/cI39]IYga33LA80UPT22SL/ZLVK5RJYA
:bRPJO30OG=HYLXZ@#\aBVF\U[V5H_XZ,Mc&2>H14)0G?Z]\#UW(^2QC+4[1EVba
AZS26fX>BOE(b^D^bdD0<Wcc<:NBF(W]P#)\]H)).)2/=]0E\INeZ;^\\JK3-66W
T/=F_e<YXLM>f_SGU(G8FOd+GM^Nc(VRDG=c^A+;JUd9<Q.B/):-^@;UHcbV;0[P
^FWe3;OIZ+P;UGTPE@c6ef[5abP;R@2>gF9a0]5GHgYD&0,Q7ZV:\#KXd0D_g7UJ
:Jd)[E:Hf;L51=/@3WO[#9L>aMd71YH0Bf1;3FY].>^Ne-cc(X_CTbM#WF@[,O+F
NUK5W>0U-CGI+6a(F;LD?C^@&b^V9DeQL6OT-1O)^APCG21<R8L#;9c>c;KbYKQ9
&47RM,);S)d/@MgdT;Wb/ZBAJTC&3R_I#d#EG=_A9bL>bBd,0E?0V;Gg<?U,=eOS
f53ZHN=0e<WD?-@519ZBK/Q.XUKTNYJ06_-Q,6@B&10DY#b2e^cTc><+M9BHBB+e
A22&-2G#_G]]L-M;Ub/3G>2;\+HJWd\FFY?]VLa-+YE;-)40K<)W/2ZIc0O-=7E9
L0L/NQH16@FB52SbV2[8T66Ef1_?E(+1_N+9\29JZKP3CW_4bS=g)2^:B2XV[;Jg
-YS2\P;B>_bU@H(eSFMa81#AIa&M[5=HG@^7+O1Ze[8D>[9BVNcDKcU>]YM;.4=U
=,GRK5R+_c>#TPBPQ?.1,;K0F?f5QOfXDV@2g=7\ZW,A=AV+0EU+Z=(@&G;bd^D@
RM5FL_C]T(RGEEBDF=IQO@[6PHD8I?GHO?e;KgYDZN)@eUVD<dOC]MD?19F5M3H[
+Me4fAD]bN)Cb@=?3-7Ca?2H6DY/T&fPW/BcY?&.Z>A7&.+_IDOa6)FOf,\Q7#I#
I.JOR[ZG\I;La#\N1QNSYE1=-^OEYU3g?B-.-QAH)bPX1FHd2?>\HYWH:0O6W;f9
K+abd/><5T0-U^9U#<]KRO[e2HN...f_<4SNHB,-;NK2CCM<cEY3g&dCB]QX@B_<
I>ec=NJ4KOfMRO90YeX,-V?dFacHU]T7?c49d1g#b4e(G^=T#:LS\X)b33gc[D3)
BIJOH)709Zb&;>L[a><&+\bISN[YU3Y1.87d).F-fbJVKJg,:c4&Y^IB1;4)Ifbe
5fS1b9F&KH\W;fabS2VY?BLC]<=T<RF:I(L/XDM;M@?\ZUU<0+RY2-1+0YMI\<2:
_)16C4_e/2:C6I+e7517d>Z6b-5)[#@T/f^_+Vgg6Y&F4&WVTYa6^Fa3QQT5W@Z?
aRZ<?BZ.df^O9b7;&10X8&1FA#MA#7KR#IH4ba?.Y\SGSV&gcBA/T2d5:d;)PRDM
X:PV3=XA0\T:0/<BgS0Y.:0ZOUdKDQ2WYgY0&VC&<;Aa+?^c;RE?WP96<6)LKQO8
EI-8F1XLYD#TB>,=)Ag1<fM<A#@]faU?GTW^&Icf&XCBQ;gJXY.[L_WX(AccOX7)
0_DdP0XT67.(3\Z43#Q=?a91T])FRB^LRI@/E71J?R^HS3)8^#_JHL;^X+[Ha^13
7G]Og?:[a[#NN7BO,[P24#[#]-XD<8IfKW^Bf@1F^\7H@dK32eFOOB@7cAZRO@A=
J?Gg^J(0\bFEU&Z\W>:+]/2eS\9db+:QRTC6XG412)S<UYWEY^PWQ[K[HJ)_3HgL
[.?ZU>?_S&_60:B&aMecJ;-)dJ/D<&c01eG+e?YBBCU)A77.1MdfW7=8fc:bFHN;
N3fU,RA1N1G)^H+0..T9],SBP(NHJG7<8QXX+,#9aDF_JMOG-=J,LJ3&PS66a(aF
eYG_XCH(\V0H1a21^?R]<GOcfaA<-W?Ib0+W3E6gaTXX[V..63EbQEZ27JVQ(6U-
@fZ=dZAOA#gT<UZE91PVOUOG&cX-CTS6aA>-YUgfC:@5U=B51GZ:^b(-^&b7LF>0
De\1>=cUBbJA&7E\d,O0&C_G8dLCe<VBFZ<2KAUD9K<,CRc#O)YI7](L@FW5+\;\
Wd)>/Qa:P-]WWg6f@b?9[(2DU]Q<ICfV-1<DAf30]N47A53]gcZBX#SMX8C54UT7
/cAO@gO3<JNS.O.AKUe>UZ_T,Te#BaI]Hd\I3Lb.F6L?&&g[,Kc#/B8FfX:OaD8]
BYHb0>=U?UDWfM\FEOXTX5_<\?&Z_9.3HR_[DcBfVCV(aMK,U+d#?E8FN$
`endprotected


`endif // GUARD_SVT_MEM_DRIVER_SV
