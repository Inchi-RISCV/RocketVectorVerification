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

`ifndef GUARD_SVT_MEM_GENERATOR_SV
`define GUARD_SVT_MEM_GENERATOR_SV

typedef class svt_mem_generator;
typedef class svt_mem_backdoor;

/**
 * Callback methods for the generic memory generator.
 * Cannot be used directly. Use the protocol-specific extension.
 */
virtual class svt_mem_generator_callback extends svt_xactor_callback;

  extern function new(string suite_name, string name);

  /**
   * Called before the memory request is fulfilled using the default behavior.
   * 
   * @param xactor Reference to the generator instance calling this callback method.
   * 
   * @param req Memory transaction request that needs to be fulfilled.
   * 
   * @param rsp If not null, response that fulfills the request. If this reference
   * is not null once all of the registred callbacks have been called,
   * it is used as the actual response instead of the response that would have been
   * produced should it has remained null.
   * 
   * In most protocol, the response is the same object instance as the request.
   */
  virtual function void post_request_get(svt_mem_generator       xactor,
                                         svt_mem_transaction     req,
                                         ref svt_mem_transaction rsp);
  endfunction

  /**
   * Called before forwarding the response to the driver transactor.
   * 
   * @param xactor Reference to the generator instance calling this callback method.
   * 
   * @param req Memory transaction request that was fulfilled.
   * 
   * @param rsp Response that fulfills the request. If the response is modified,
   * the modified response will be sent to the driver.
   * 
   * In most protocol, the response is the same object instance as the request.
   */
  virtual function void pre_response_put(svt_mem_generator xactor,
                                         svt_mem_transaction req,
                                         ref svt_mem_transaction rsp);
  endfunction
endclass


/**
 * Generic reactive memory generator.
 * By default, behaves like a RAM
 */
class svt_mem_generator extends svt_reactive_sequencer#(svt_mem_transaction);

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

/** @cond PRIVATE */
  //Memory core
  local svt_mem_core mem_core;

  //Default Memory backdoor 
  local svt_mem_backdoor backdoor;

  // ****************************************************************************
  // Local Data Properties
  // ****************************************************************************

  //Generator Configuration 
  svt_mem_configuration cfg = null;

/** @endcond */

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new generator instance
   * 
   * @param name The name of the class.
   * 
   * @param inst The name of this instance.  Used to construct the hierarchy.
   * 
   * @param cfg A reference to the configuration descriptor for this instance
   */
  extern function new(string name,
                      string inst,
                      svt_mem_configuration cfg,
                      vmm_object parent,
                      string suite_name);

  // ---------------------------------------------------------------------------
  /** INHERITED METHODS Implemented in this class. */
  // ---------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  /**
   * Return a reference to a backdoor API for the memory core in this generator.
   */
  extern virtual function svt_mem_backdoor get_backdoor();

  //----------------------------------------------------------------------------
  /**
   * Return a reference point to svt_mem_core.
   */
  extern virtual function svt_mem_core m_get_core();


  //----------------------------------------------------------------------------
  /**
   * Returns a reference of the generator's configuration object.
   * NOTE:
   * This operation is different than the get_cfg() methods for svt_driver and
   * svt_uvm_monitor classes.  This method returns a reference to the configuration
   * rather than a copy.
   */
  extern virtual function void get_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * perform svt_mem_core configuration.
   */
  extern virtual function void reconfigure(svt_configuration cfg);

/** @cond PRIVATE */
  //----------------------------------------------------------------------------
  /**
   * Fulfill the memory transaction request by executing it on the memory core.
   * The response is annotated in the original request descriptor and the
   * request descriptor is returned as the response descriptor.
   */
   extern virtual local task fulfill_request(input  svt_mem_transaction req,
                                             output svt_mem_transaction rsp);
/** @endcond */

  // ---------------------------------------------------------------------------
  /**
   * Cleanup Phase
   * Close out the XML file if it is enabled
   */
   extern task cleanup_ph();

endclass

//svt_vcs_lic_vip_protect
`protected
ENS&&2B@LHA-2>DLMKag[:DJY3_TK.EFNB?=5/4;@)1-N-?2-PdY1(&D30M<M._X
<IH(eIJSZ+bW+X5@X9J+ER;6<0ea\PSW(L/9_R3gZM:3]HOEYcHZ?OB,dMTAAVSc
/DXOTFNBDEL2HW.&b:6)A<[J=S^__N5]d)>55g>9BCc<c:VD]:T\#@7&\0##V-bV
V8Xgg;D\9QCDH^/8V+gQG7+=YS:CBZD2;>L42)A[5Fc?9)9QLTI#SB(3?b\#(>H-
01,LLO&g_bN.<c]0G\7\=V1GZ8&DYN:?]92.c_JS7bVD?1&T3dQ>7/Sda7;)N325
e:\&F\]gXIE^3a<0BM02,#aeZ-,=:)OBMeI?E=XP>#R]cD-:,+93CV0bIc[8U>a#
SDN_8eH3(,)Xf64Bd&a4_QJUMV3M)d4@D1_J8]d7QAI2YOTKQ[ag@_LbfdFW^X:4
_BJ@G-:>CRg,E@^0\:fdPQBJZK^=F4D#gfM9aMg5>QSIA?MH8Eb)fgQWMT?HT4[3
QYV54cT][ARY#RdVDP#(ZTJBYWFf@O5@P^OVW.[N;\YNCB3@,R,cUQ+KdZ+b-O:O
T(_MWXU/:16GTEb[^4>\#,23?L)ZQ5<)CI_9:4d+TYFVZP@BI:E>7Qd)I2NEfR[W
2VAN(,,Ba&K/,ES8^@>P6S#L(OK,=.>b=;.Z(T[:,11KUX7:4Zf00\DA-6C;73<I
bP,eUR-1O2KeZW<a>/G42@;CQLUJa-@1W.>M6C\b?/4-Vb)0OIF.2I6FdL7;<P&1
01Se/+\O[,<SPeN2V(?\WZRJbI679JMfX^H+#L3Dc;[b(<?e<OgM+BD[8b0^U;S<
)VXGK,7&#&MgPMcJTgQU)VBfYB?NZDMWGCY==YP0]8g9S@(Ye^&4=E-Fd2HMPZ<\
Y_JZX@&LTB80HHMLS[:43=cVfR4?<EDE1-/8,8e,^b/+O\>QXUWILZDRXY?RfRJL
ICZgRH1B=gIO5D=;1(c7:Q;fXKRT9JJSMF#+7HXT0V#8.6Yd=.E7GBb@GDV?/;DK
2=+48gL#0K7HRRaV3E?d[SR2L;-60G=T+0db9/RD(^6A=?EY?L&E>L#/^3(>GXH7
3X=EU3QVDDg>@MQd.?K5TD3Qb(?;<R)NM:VZ,U,=S)&=?b4;[+CRGE@Q:+.bdFdZ
YO&fF:^6M<E:CANdfSHeIU[@7cK[a,=0cX&:-bH9aL(\A)7d6[Wb4f.:F)0KVPUP
_<<1eY>V@HA4&7V\2>4L#Q3AbO3V?3+4LP&(fCM/a&CJ/V(;SO7YA>B\,E5UfQZ=
2E,RN<R1-90_Ra,JXS;^3A]W:URB_&)aG;4,N)JJO^4\g68GfK=+6:e?9?45M35&
QKdU@@1QK>W>SB_FSQg2)4)#N8O8\B0)AF(A>@Z=@,)7BI>EJ.2Qa[^2(F]TaGF.
I,SQN81PYEP9V1>8efYAZ0e<QY2,^;\f?XLVWRY<W6HM2R+/2:\=)5T.J3?321VT
VOKG]3^\CD3=Jb#Xa(&XIR+7T,;,&^82bO+X2a#&3e<7C57M-.MTU8;g.gPg=4:?
J?7VKI=/5[^L[/90GfKOS/&SKb(HE@>AZcd7F2cK.W?L044EGdP#AP]5CHJ^7<gB
JE5PWP6+N]f;P9a0#VdJ#Q])W;bR=YW/C(-9KW;SV,MNZ,)B5&VPb55ZUg8,.]99
/6=fO=A;])1X&^O5Z5IT6J?&RS=V?fa3F-?2;/#O_AING+IH;@_<]OHf1O45gUgM
@_6;VW)_AP8V\WEAY;FcCWFK,Z1?]S4IP=ZH7F,\+B-7T8Y^eX4S[6NI.a=N5-6O
1f/AfK8N/R9BXDJ[;c?Tc,f_AP]G=I_<dQ@f0MPBd8:CEE/La^C;aR4MF\)<.J?V
BPT.N925ZYffZFc\#Ec^H&57_B_#J0;JA:<RB^).&b2W?_\-C-7[eY_eIf:^EPf,
>-^J__Uf4@K(\)RJRUf+4d_K;EHK#Q#[]Y+XDM^^0He4b\[U<OCL]\>f4.D(6WL[
-AXUMOJg22>1I2Pfa5J,V2N_GB.RMO?S0Y(\^b<L\6]PN>0IXO5<X-94(2:HdQ@V
U^J[[IZFN\B=K1@U/#]^M\OGT=H7<X/J_eH758\S=4If^&E5LA_&RES=#KLfP7YW
MQ2)RKJc]&RXHE:W8QGW^)CU==#H=&KSDJF2:4>,^BHU&Ybc4eFS3HLa1TUKNX@e
V^EQJ-Z:0V0:TfK^F7VLF4]1KHM[K&ZA6_9&QJEF1f(,8[GW#O?ATE6AK#TKN=X#
d_ZQdQ<4TegD7/#;aI@bQX3T44PL8Ma=?6:5Lbg8LPKLUPA0/4I>J3D9VLMTN)d7
?=JgL0ILI;78^4(/;6=.@[A9\8.T1-TR5dP<@P189_/UG[UKPKe]4B#>I2CCR,\L
cGI5HFMcV=T,)g>)90PLPeK\OOSGK4g[G.c1K^+)DfEV3[N?I/?AT(X(YQdUALF9
(b\+a4.<:&3>P2?>IPSe5MIbe4d[XS9g^Tf00Q_F6KWVKTaL#X7KTHQ0V[H2-L9g
f7E5gA.@F3Jg^E2Y>HO64,8TfK1,TYB,DBWdA=f95@6V0,?OOF3d9[e\Z@25AV,2
=.,[7e&I&GF)Q6(K-C^DU4g7K5D)d/7K@C7UF;;IJ,N\ZZ>4[LO@3b.a@\87&)#H
VGRG\(=H0G6I]C?e.Y9)MA)HSYRON:U5L.GeQaN[DX+M7g+1SK+L_X\KXA3N_8[5
6UREIJ\T8Y^C:MP^?D,aQ9IfX/<E-C-0<BE_(gUCX#5_E,2,F?_aO@3]RU>dbc?3
:fc#MLD)dV&W5O3L3.6<5+cC89Ja:c=)Y20Wb.@7E1-3J<VgCU^c848-L.C+HTPP
-#<<T?-/5AF96?\I3O_f5?0J/69JcWCE^]_-#SN06KK\U78.4?Z^S2/]:c@c@B.\
=4?8bLVfX?cbFL[5-#4@\T4SaA\#C>JGC:dM5#S.AZG8-L^f:V^;AXSV)YI&4b>^
/:1M,V8+4])a(Va&C;R,Ya#6/OM^cSS-(IQ)#LBb#)#C\LdR82<MMQ9g?=WNT3_]
:3.Y\PK[E:]c:23K08C3ANdI,;c&(9cH#11NQSWECS9>99U,YCHB@7e-<:(0I+fW
[0>,)/PE1\DC7YOZc9IR-ONY.+(5&VOI)\4/gBQe=+C)[RK@,2A=SW>@=Q[UHA.f
SBGE3.8),#6&HB@c]adS,B5=F(K@)5GOBP3B[>_/aSTff/bcOALTB.]&&=ITGd6/
N&5GL=^<VL<1ZRMZ[<USa4X?5C(-IX7-](@^4SJ)@\0VG/bWc&g,;V47MPfc3]K]
eD9GXaf@#\5\H=F9?Oe\U_KKTW(UKE;FeOd-:deUNVQbSH9>)F:0CeJe+EbZ.TLX
T^\PQ-XQ:ObHW+-:>]gR1O7A2)G&,PP<YK5125@(W.\)@(UKCKA2b71SXa_c1(:e
>a?/J(E<5JScBK(V=\&?a/;<SCAETbe.6TGD-HJDeW4_gRS/5#M3CO3&TJb/\c8X
E#FA][eYLC<]b&FFC@Z+MP@b(\:[V3I9a;geOJLdSHKJ\9MMTdR#SJ21/EHc84&(
?9ea8W+4gfc[U(UfB+O/:]Z3bCW104SWYQ=<3K5B&GQ.G&IP0??aQ5a1EN]^4<5a
[WED^BKPYRX]/cBLSdOdDU<UgbXK^W)0aS(K5V,a_=IU2B5H460YA1\dUA?f>032
a?aeJ/b1TU&[1b96H6FD<=\\//=#ZTKDM?+XAP\aSBC_(,(A\X9]FaNM^e:7]Rf5
(^NF:dN\cS]EEe]>f-<9VO&5-J2SY=QNIUJ1G38@<-Wc6I];IL#>/>+g_Qf3d0I>
>N:/T,0]H]Z,=3g&cP.cXA3=S[N5)Y59ABRfR(^G^,IW:MG37]Y7b;YRL]&)?L&(
KPaLATa6f,&]U;1LX&UgIKONg/1O[X>F>VIa13F0FR.b57^FRN^YL[?d6I@C]J/_
c,INMSR8]S1;Dg6CQgEK0@)^=U4E26Y+HX>8M\]:6PF3R]NJV433D0(_-I77O7H&
(1H7:.I6-G^Y+N8fW-:bW726[R(DNWe<N#1=51+T>C7aC-PY_\fM>@>(1M&5C)5Q
/gHL,6RV4>R2PAD9Ce9N2>G#<;+V30W^R7K2=Xe?GF#V/^HN6D)]4Xf<fb9/N,RG
&M&O&LAYZ>QcN=8[GBT=VJRZBaB3,?Nf2P)]=AO?PRcR\U<,AO(;-R-cc0>717^;
.cFda<G5]S33)\VEJ/50b;;R;baCMM65US6=c-F5H:(-9?6g#8>UM]-cM$
`endprotected


`endif // GUARD_SVT_MEM_GENERATOR_SV

