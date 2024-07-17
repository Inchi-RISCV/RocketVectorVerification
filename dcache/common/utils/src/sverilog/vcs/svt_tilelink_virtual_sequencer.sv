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

`ifndef GUARD_SVT_TILELINK_VIRTUAL_SEQUENCER_SV
`define GUARD_SVT_TILELINK_VIRTUAL_SEQUENCER_SV

`ifndef SVT_VMM_TECHNOLOGY

// =============================================================================
/**
 * This class defines a virtual sequencer that can be connected easily to the svt_tilelink_agent.
 */
class svt_tilelink_virtual_sequencer extends `SVT_XVM(sequencer);

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  /** Sequencer which can supply master_transaction requests. */
  svt_tilelink_master_transaction_sequencer master_transaction_seqr;
  /** Sequencer which can supply slave_transaction requests. */
  svt_tilelink_slave_transaction_sequencer  slave_transaction_seqr;


  //----------------------------------------------------------------------------
  // Local Data Properties
  //----------------------------------------------------------------------------

  /** SVT message macros route messages through this reference */
  local `SVT_XVM(report_object) reporter = this;

  /** Configuration object for this master & slave sequencers. */
  local svt_tilelink_master_agent_configuration master_cfg;
  local svt_tilelink_slave_agent_configuration  slave_cfg;

  //----------------------------------------------------------------------------
  // Component Macros
  //----------------------------------------------------------------------------

  `svt_xvm_component_utils_begin(svt_tilelink_virtual_sequencer)

    `svt_xvm_field_object(master_transaction_seqr,   `SVT_XVM_ALL_ON|`SVT_XVM_REFERENCE)
    `svt_xvm_field_object(slave_transaction_seqr,    `SVT_XVM_ALL_ON|`SVT_XVM_REFERENCE)

  `svt_xvm_component_utils_end

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new virtual sequencer instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name.
   * @param parent Establishes the parent-child relationship.
   */
   extern function new(string name = "svt_tilelink_virtual_sequencer", `SVT_XVM(component) parent = null);

  //----------------------------------------------------------------------------
  /**
   * Finds the first sequencer that has a `SVT_XVM(agent) for its parent.
   * If p_sequencer parent is a `SVT_XVM(agent), returns that `SVT_XVM(agent). Otherwise
   * continues looking up the sequence's parent sequence chain looking for a
   * p_sequencer which has a `SVT_XVM(agent) as its parent.
   *
   * @param seq The sequence that needs to find its agent.
   * @return The first agent found by looking through the parent sequence chain.
   */
  extern virtual function `SVT_XVM(agent) find_first_agent(`SVT_XVM(sequence_item) seq);

  //----------------------------------------------------------------------------
  /**
   * Gets the shared_status associated with the agent associated with the virtual sequencer.
   *
   * @param seq The sequence that needs to find its shared_status.
   * @return The shared_status for the associated agent.
   */
  extern virtual function svt_tilelink_master_status get_shared_status(`SVT_XVM(sequence_item) seq);

  //----------------------------------------------------------------------------
  /**
   * Updates the sequencer's configuration with the supplied object. Also updates
   * the configurations for the contained sequencers.
   */
  extern virtual function void reconfigure_master(svt_configuration master_cfg);
  extern virtual function void reconfigure_slave(svt_configuration slave_cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns a reference of the sequencer's configuration object.
   */
  extern virtual function void get_master_cfg(ref svt_configuration master_cfg);
  extern virtual function void get_slave_cfg(ref svt_configuration slave_cfg);

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//vcs_vip_protect
`protected
#S>\9Z2K289AVDTJ.1OZeN77]:TU\:S>:>Ub]:0^1<<eVf2g=I5c&(^V#3e>AeLM
.AX3#?U3UXe]7SO1,GZU\9Kg1.WG[7C1Q6DIZQ2(F+6X,#--2[9gRW]e0EcEB#@W
SfLTMdEc8d_fOYQeH@(BQMZ\BKgLV4:UC?>E)a:7CPeMF\Q(25X;S-FRN#;g22]L
ZXUd6JMg5N1-0>QRUNZf44bU5EgKGUK?=8<6M4GU8,A]3OX6^f)I]8:G71Y0()-U
_b76:?H7H<g8PB2Gda1=;XP=8LAR&R-0(H@ZU6^SadHTB;,WNQ5T7KDA(gUCaORT
:K/XB6BV=@aG(9R,D,J]3A\2)Bb[;aB[X9S=(;Vc\R_d4e>D:4WF=]Q>HIeU(,?a
c#AWD(67,VW5T<X2VEMb65;BCf?@-X7R27cHT3/7Y?ZQAC-LE\fT,:Q:G#,K55BW
MUHWIN)PS:_Uf:4F\gQ8Ka)^:^)@L;TM<=ESdDFQX)g&2)SfMZ&Uba\-f_3FZ1U;
27RQB\aWSJ_QY@GL//MG?f[M9-.D3H\(>g>P&:E(83aZH41\XK;KGZUK^SGA_?Mf
^aCK2XGTaB>eU5JFVN[1UVQ=;<TU,=AU+3_88K0b0T&Z85MJ20RDCDWAIUNIXH+b
?=:L^GKa@=B\8?e>6&3@A0>Z)5T\+;5&F(JO@<?=F,@7#fFQJ+Q^8UPO8_MQdUHQ
gTR9?KDBH@26T4N/C.@PR5V-8;b#O@R/-=+AbJUR91fA>1</1BRD5f5g3Fdf:Y^2
SRJ=/RJRH#0C1I]GeWHI_;eC+f==B1f[BadD9.?GgeX_CFP))F+)P,\dEaGLgA13
J7ES#-]WMXdP>&A.9BRg]VG[34/3F9<=YFNCU+PAZFM(Affa]E3W-^#(4SEabS;0
)PF&BfdG;,Y7.YZ-[F]\FJN;/b@7IaNVD2.IJ;A9eMX/=>]BJWUdE>aSR-5_D>BS
)<93A\+F@EH2GXZ04:RW:MN-)N#L/J6QUOT9.3>-.8AT4NbY9K8(D[PQ#RfQG_BH
J4_TA:Z@R4dALN)01I+TA#/>L;VXgKITfHd8@7\(9D]7&I6Q0Yb=,V>DR?=fD?GE
K7P]4CZ_@E1DV4@5.c2ST2\8-A7bTTKL?AX/dVJ=JP2NV]WgTQ8ecD0M2LCVP2CP
+WS.@B7FAL8?d0SOZ069XZd/XO]?Q7]DdK^VQNdZY=:\T:+N22?)G3fEKf/B>N/E
:ZO)Q&Rc54M.M>B)IB8NWEfg#W3+cCK3_W-0cE)0gdLO>([GWdP/c35P&JBAUM,=
G4)6(5V6^3&/g@5-\W\B:LNK<4-2[D#,CgN6eKV,F,RMg/P[G21#S.P](B^J:,<a
-^d1CS7A\XF#K1I]>]IdCSbbNg,Zd@C?3g(C7:1Q^.HA3ED4bYQgZcLNZ:D]W_:O
\I/0W@I5c2+cOKa;(QCc?EYI[B^3GHcNH+1//62AKN&(Z316UN8\HeV7[bBPWgJ^
S>P_S+UB0K04G4P^F:F(d6ZdN=c&TV3MePX9dPGBMQY6K5YIT[8HD-AIeKQS?+H\
FN0SeXM_26aX8:M)FHg(.(O]2\^G?-bMMKV[.<[+ZWf,?5VX-0E-&=^@cYDM0]TW
Q+DTVI#F#[I=T=DKP\M(C6:HH6WE@O7-#HE-&a=4[\=]>FX&5N-IF68395FNCD#M
dF[MR-DSFfa]]OUV,Gefd,][/7BK;J+C=8&6,L,0NPGP<=2IYc[#4e\Y-AUMWAQX
^AgbY:M.U[3U-4-._Rc?0a[fH/cA:V]1/1[W>TV8</W]d1_]K:?3EK9^<BA/A@]Z
?4^\P@W>_IT)O^T03XWc^94B(LJWG5cK4US>L22Fd]TU(3+QR9+ZPf:^T<:0((NL
2ZPba/?P5EI058ZFW(7g;]CbJ:SJ,Z<4ZYV[dB6g^IEHeb;290EgLO^\F\C;A>VQ
?=,KC.>>e29MXc^.]Ee/2U56G0<AE8S.f8&+:7KQSUXF#7Ye^HeH_P+2eN,-@=.I
R(DJ.:B6)AI&G>b>?ZK:?AGcDL@YfX6+5QE=4./Ee8eU1@g1>3\O,CD#fFW()>2^
\P^5]O8\>&Z99c4Y>DBCMIKf(Zf]bAddg/1@1NN)5-SR-;S[b+3DB^&?NPd&^UU4
V+.=\>^\\>ReI[&;F)1PZ-J>E)a=S\MKDK)U\Wfc0?D3Kb;Pc2LK)b.YJ9/)E>+@
HW>7RGfC#</I2YK,<abeJ)X2.GgMW=6g-F^0=0GB,G=R-MVD[HQ@c+)#BT@4WTbS
HST)1Sd7O#>;;CP(D,A=R/28X=V,a,G;6N@Ia,a&R/L(A,C4X7:[>S3.]#fXZV#/
c&a4\4WUOUAgUD+#:dW9^a8)DgTfY\Ia[&^Z1.1d.f_U760N9N4e>e-C(1&bHS,O
XcHA4B4TMPV8HV]Y.fM0]<<6>(N2)L)\L&#K93H+X^VA>AN5&cB:I>9f=BO:^HQP
;b/E<)6YEQL/BJZNRH[?)X3dDdbI[gf/A<BLC\V(.W?(-9Dc)EIDKPC)?WK.06H;
g-RDe30@<WVb,\&fV[Rb&COJ=.&GIM#eBdG(ZS73VWM<1C;4XaCW=?FSZ=,O&X3)
79=36EdF8PYOCKN?UU=L7We-FKA950?GJ7Y5IE2OKLC?,&@/S.gKC>462Q485/]M
P,+bMBCZ9@.;+/.Y-O9)#01[D+e5e#,@BX_Z::b?IAI5IcP<_45WUTOL03]/>g8A
0^OW[HX5ZM#IK)XF>Fb:Xeg+XRdC4,CR]9<3F-/_.\3\K2[83@XZKPU<3da:aQ43
+1.)[H)]/_\KS^B;P)92FE.55&4-b_^?5N(<,\TUYXF9_OXU^TafAPGYX4XY4g#d
B9_8/<0\,?dY@YMAM6g9ZIC;;>Y_J(36#Afa3(V+D=LW+J4[]0FfZ?<b:Fg\,LS9
\)IUB;_L)39BO#<=Tf(bHJ=b?/Q#JF-.b12FOQ\>?H5^0\#4<H6+Id[b;/JW0g#V
f+EL<6RZ@J\<^J/&>SV8d55\0b/L87]))UWWMZba7E5]_19JRS.XeP80GHZ#gKfL
g-7&.IQ>Z6F-]7V7d4NO&/Nbg<OTM-FAg,=WZ70EO7./=8;+TR8Q:)XRQ;1>D6cZ
BfW,N7W/7#E:<fd-214V[GP\e<#VZ_Ia;_>E(+1D&[b,F./T[-d.8&H<N^/;_0U2
T=&H6TKSVZ1Vc+B_)1CgLa\[d(5-QRe.<9JQb5#P^,10Q>H47=aIF]P[VaaQVT,E
bAaMX9;Y2/NFV2/&K9\6;VE:OR.8e;Ie-J:gQ8O9GUA.bd@^9>0444cU>H\Ag-(4
[F:49V1@RO1<-\[2SISg:?<C@RYCHN+<K1S-0A1f/D<&gYV)49;<QM7K;\B.@;:7
XdOL+H\X2W1fOQ3EZG9ab18JP^>F<X4d\^A9_E4JgQ)dLeW[aA@-UV2EgV(8V2Va
[Za.G[VO675C4\-/X7<Y02DZJHP0&fFW#@8^J[C;X^70_\?)UP2HPF/a>.R3DB<I
H4^R2dIH&]=+-1HVCJK0:\<M#&\<0bRR^d4E_V>2=OfXc7EIH@1?)a]7aecOHP#O
aeb,gUO;)UK^;KYNQW-a@[NPI#;^K1JQ.4a_9PV-TXN8:5IVYCTd<Z(4c+-T^_I9
b@_\7dP5gcM><Feb8?R6K)^>R7.S6S:=OSBG=..8EEbMTVgSX8AAI[ab9[cWVE3Q
LaD[a3b@.R0&dVO[8?HDT<HFPUN^E:@]f?PcdeW5]^V&VVJ4Q:Z:a1#FWH9H_T53
DDg5a6Aee84EL4HaWF3WV,I1Wd45ZgP6)_b#Uae[3C:[N3N\E&;4E2EY(SD:K5H9
H71,WR/Ca\3gN?K<D=?PJ;VBI[P95b6;ZQD\6XI>U,,K?6Y2-6K6]B0O3dASS@e>
W4NT-\;50X9N^cb033E8#^7Y\e)XZ,^;_DBB94\?e.U3e1&4cdW2)E6e@42/Y9RA
@FC3:6DBD=cUH^L9V,PPXNdfO)Y42)WP=H[cQ&=gJH<+gFFgeJJ,Db0WF4^IK[d+
)[d>;\b8_C91UaXE-+DJ_S-6FH4EV.;be+/O3&acLZ9)&QAG\E(GBIW0:/Ff#6X@
c85:K#B,aCM=]Xf/X<GcMV8LSW#1.#PCM9\C/D4C#GXb\cC8#DF#3dbaM8,fdUG\
W<?RD_a5+\eOPIK4B0bSIBNEFG)d;-;Gf;b2.b(#HJLfO?B[-Z\I6Vd#LH,/X)Xd
.A.NZ-dJUNd#?dI?I]OBV=f(.(NC-@_IGg0?b#EeX@]&OFF5IP_G@9RJcPaR(7LS
-J\McTQJNM;_2P1.+HPYfT@(SAZeQY&YSf-dHV]FXY9Nc6YaAICJ\7/RBb_YA9HY
U21KB?L3D#6&c+Rg,+1Daf/_&HJC&g\e),V<?R:O#3B-UGVFO62dVF)BUK8LDRIC
VF-](FE<QX,=1\&>#-E?#Z)4-JO/E&Cc&\.EHKEP6#[bKaK<PRff;F:N9DOPbL>,
>K3CaII.&UX\DCeDIPMIL3Y8.GTQ4,=SD]??[/Z_J))bH$
`endprotected


`endif // `ifndef SVT_VMM_TECHNOLOGY

`endif // GUARD_SVT_TILELINK_VIRTUAL_SEQUENCER_SV
