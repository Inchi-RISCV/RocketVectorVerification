//=======================================================================
// COPYRIGHT (C) 2010-2015 SYNOPSYS INC.
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

`ifndef GUARD_SVT_AGENT_BFM_SV
`define GUARD_SVT_AGENT_BFM_SV

virtual class svt_agent_bfm extends `SVT_XVM(agent);

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data Properties
  // ****************************************************************************

  /** SVT message macros route messages through this reference */
  `SVT_XVM(report_object) reporter = this;

`ifdef SVT_OVM_TECHNOLOGY
   ovm_active_passive_enum is_active = OVM_ACTIVE;
`endif
   
  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************

  /** 
   * Flag that indicates the driver has entered the run() phase.
   */
  protected bit is_running;


`protected
c1^HUQ3=LJ/P1a[7MYTU]cYg>g?8eN;@/V.US[E\[#2d];GE+8_7+)OOWL@;U9<-
g[B=D3CZXC2Dd[-F#2K<E)fV-Efa#.+\GH8L/1JLNT&5N-g3SD<S,,UPIFfTC7T0
/JW:@7;E=0cP72.SN:S.9KJJ-:8=6-=9Ic[<3Y13Y2ND=\g[[fV=YV9&>>K[^1;L
O0>H]53:f2HP3NSLebBXXK]_?VJB)agd&]?;EWQ,LSIJY@/cOG;K).9&J$
`endprotected


  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new agent instance, passing the appropriate argument
   * values to the agent parent class.
   *
   * @param name Instance name
   * 
   * @param parent Handle to the hierarchical parent
   * 
   * @param suite_name Identifies the product suite to which the agent object belongs.
   */
  extern function new(string name, `SVT_XVM(component) parent, string suite_name);

  //----------------------------------------------------------------------------
`ifdef SVT_UVM_TECHNOLOGY
  /** UVM run phase */
  extern virtual task run_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  /** OVM run phase */
  extern virtual task run();
`endif

  // ---------------------------------------------------------------------------
  /** Displays the license features that were used to authorize this suite */
  extern function void display_checked_out_features();

`protected
4=WVJe4TN57[[LB88@:8,dI<#=7+T1LQZX1)a+B>N0_<108O\-L41)MJ7<d[1L#<
\7#57cJ7PL;#<>F_OKUT@6Gg^W=49=D&c6.;Rc,@f=8_RWM91W62QKTZ=@-(AE>T
+_E_:X<X+3X\;dBc[IfWCd/L]GX3_>fZR;gdaMXS>W._D$
`endprotected


  // ---------------------------------------------------------------------------
  /** Returns the model suite name associated with an object. */
  extern virtual function string get_suite_name();

`protected
fd@C1M2#MMR8]J2QN#:;=I\Eb&-EM30&\TDggGf_K[KN/Va&^K^.3)YQ4=Qc6P1V
[RT<D&783MEATU46VL21KRNXLfS[/d_&RGBJg#gP:XbWP@PQ:-08Q6D\LJL9[3Lb
dD[3f0W.;VRA/$
`endprotected

  
  //----------------------------------------------------------------------------
  /**
   * Updates the agent's configuration with data from the supplied object.
   * This method always results in a call to change_dynamic_cfg(). If the agent
   * has not been started calling this method also results in a call to
   * change_static_cfg().
   */
  extern virtual task set_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns a copy of the agent's configuration object, including the
   * current configuration settings. If cfg is null, creates configuration object
   * of appropriate type.
   */
  extern virtual task get_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the argument
   * into the configuration object stored in the agent. Used internally
   * by set_cfg; not to be called directly.
   */
  extern virtual protected task change_static_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the argument
   * into the configuration object stored in the agent. Used internally
   * by set_cfg; not to be called directly.
   */
  extern virtual protected task change_dynamic_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the configuration
   * object stored in the agent into the argument. If cfg is null,
   * creates config object of appropriate type. Used internally by get_cfg;
   * not to be called directly.
   */
  virtual protected task get_static_cfg(ref svt_configuration cfg);
`ifdef SVT_MULTI_SIM_EMPTY_METHOD_FLAGGED_AS_UNIMP
    int dummy = 0;
`endif
  endtask

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the configuration
   * object stored in the agent into the argument. If cfg is null,
   * creates configuration object of appropriate type. Used internally by get_cfg;
   * not to be called directly.
   */
  virtual protected task get_dynamic_cfg(ref svt_configuration cfg);
`ifdef SVT_MULTI_SIM_EMPTY_METHOD_FLAGGED_AS_UNIMP
    int dummy = 0;
`endif
  endtask

  //----------------------------------------------------------------------------
  /**
   * Expected to return a 1 if the supplied configuration object is of the correct
   * type for the agent. Extended classes implementing specific agents
   * will provide an extended version of this method and call it directly.
   */
  extern virtual protected function bit is_valid_cfg_type(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Returns the current setting of #is_running, indicating whether the agent has
   * been entered the run() phase.
   *
   * @return 1 indicates that the agent has been started, 0 indicates it has not.
   */
  extern virtual function bit get_is_running();
endclass

// For backwards compatibility
`ifdef SVT_UVM_TECHNOLOGY
class svt_uvm_agent_bfm extends svt_agent_bfm;
  `uvm_component_utils(svt_uvm_agent_bfm)

  function new(string name = "", uvm_component parent = null, string suite_name = "");
    super.new(name, parent, suite_name);
  endfunction
endclass
`endif

// =============================================================================

`protected
_-9?MTg_GcK=WII;0@=1+DR]1\.,;<Y]Od.F\^UO.MLHcF0EY?(&()<V9aS&O).S
_^Mf^@=US,LdFOf8X@#a3>:E,B=(40&dA4_@MVX^PWO\HL56D-:WAFOT<WZ-O;NG
-8,)X9d/8-DKI3NaIg8V=<EJ?0KKVVB?N=4_TGaUGCO.]Jg]LBNXe.L;SKee9.+L
FJ.:c9)=VRA_)NQU-Jc8(^&YF<#K^S)(\0<C6+22f,MfJV#-;I2U.=DgP.QOV=..
)Rcb?5&e(STZIFGX;;@1&@U-QWFA#+\)Ng2L>>5=&e1bGGIVVF0)a&KRe0F;36d=
APcfVNaE,?GB->+EM<EKKbggGA,)fMGVJCFT/0,B59c9J<ZN9\K-b\6\84&);@S:
KfF9>f[TH>X+eQ5704ccJLCJYI&L6PX:^TeeUT>=FH(f64S,^X_9F[OcLQ&g[4GR
4EDBX&.&D)8aNfN9+XK42]^3NO)#X6/ABLFGB17_2a^_-?YFC?,,eT\R50J<X-JD
)9()9d-f2ZUEIXEbH\O<AI9E_2GA2ba&:O,:\8BO1^T,33CX)J@2157^2<K3e=T8
56E4Z9P7Z.&;d4a4O@I4DF-PMgOccBHE7#NV.8b/6ULd[NH5?IFU:Q5V@#O9PN,2
Y2,@AD]3@,.K1(<\B:00X3.S)b9SLb,,32+eTbO:-WJBRLOVUg&M.dW=[-9&bJ,-
QP2@+PXQI.V10[@+C:HO5NV267)0@F,[PO#U4[:KfLKG(24_bD^[XJ9QYYIU\/(1
/C=Y;:TMV2ETTc\[,:IP&TVD&45XD2@[_RZaT.#8<6dBYMHJ7WQ^L.W84#SL5G;?
;S8D[TTCecE-Z+:]:g0^A0U/=S>),<1ZKJ<+_IE]=^e4HH_IKTC+9_F(I/cHYCJ4
?#PV)fIPI_V<ARXRgJI&.,&@E-4Q0R4GUL;+a&H=@DX&B-OY2a+6D,\_5DYSE;Uf
7A)7P,[D?^e:KM3]GPac,,LS[gH+[7Q>D=B4d@6?8SY&&N5=cTVUaS[;Q&],5/^V
2M@9]X4^a8f#MNJ4:NFA2e[TD9;Dad<a)fQUEQUKZcZK#(XMEVY_.G?]5Vg2UN+A
:;//&>B)J;W0J_,S\<5,3UXT0;:CDZRd,^R(;N;A[FcJH-5H4f+RKH,a]g/NAcdb
3J\XG.KeKWg/f]d[NMNa?a0R(R]73Q?7U-OZ[NJ+3WT+XZOK=,=]1+UWQXS?^+;]
RI_5M9)M&&Rf/4&&6M?EID5@d)>UY^4WN;E?GM?EQ\5A,Je^T@,NdT,8N:;eJ>JN
/I5=?W-FG2^E&\LG#.C1^[SKZbTR]S6BPH)9OVK8/B\e^:U51_.V/;DNIWB?X@fR
?I-O3gBf8JAf];V-fKd&73:&=NUKDfO1N,SRQO59V[-JT^e=Gd?gLMSfBg=\6A26
\#6e(+]2,\OJAJb@N\@5W7Q?:LcB^Y06-XE+]>BT9P+SPYG7d:bG]6=g?dIHZ;:e
;cW8UWIe5T10Ya5MB>-4EZ)eQf4&5&>([cSa<:Og.Lb<BCT9P#VS+9KH7V(I)f-\
CWRLIL&9BO5(;DgNFFaT)Z+<K5P@-:?F\&#IgW<a8WCA-Gc/H@)77a^d]=f=CE@]
D222[eP;&7P_W6cXR#@Qd>K4_PPFL^+O[3a@8Y-VgWIXLG)\2UBL4=<gggb?.M;M
9LcA;3g+4##<:EG/V6#<CU@6gTRWNNVP,)IXe9bFU6L8fa257VA>c+ddXP4DTF+]
[A?U9XUW:H3N#gb>Z#f[&PY@YZB1W:&CLaCHSR76@:>2dQ^VZDMWcU.AOH7(3N\<
<g8[O<7376>\A(4PX>;=J]QgAD&U3e9Rc\-N:;gX#MM]=KKWf-ZGeC[S[bRQ;NH1
.,6,D7OQ.f[>(ZVU[<NR&e@?K#8NcB)GE.eETH&D,bHJQeBg_RK:Be&(7U6RLVF_
,HSQ?Jg+_-\e)[J0#Mc4UX6.EPOLR)(Ka=-E[CH6;IYY]J7.<ef3.N)/9K4Q&&/-
T-debCXeU4QBgN2>+=f0cFU50NZ^?9BK_>;PaeRHL<8BS.J8VTL8WM:;03-@adF+
2)1Ge2)W)DMN7T\E+Q24CEfe:@.W2(R7VbL&&;?4K4Fd@3^I/.P)+347AZ+6;)41
.a585/QWSV&/O_CcEU5g#(b6HE)/68VS@Tf7[3Vb&.CA^[g7+7SaTGDCJ.->417P
\U<b&L5JV5Ye=_Z.@++H3GD>d9eGUUBI5R.FAJ]58ZH_J:Z2Hf7,AL>TV749/#c\
+)bH49cH@I]-Q^ESa?ag.S#@.+#f5^RA9/TdVQ],#PQR&,I9]&3S,RM1^U-)dcBc
I@68#Z^/C#S0?IS:=;gGPUFWF1ZT8B4C2GQ.9F+M-)N6V76,:_-VfN((=#B9.->G
60>&P&1GEW44.B4=_HLGHS7^4d)Pa7;:X17g4)98=Re@RD9A@SYY2J.g.LF5d7#)
A&Qd/1=1&4)7SNcB:@NaTR(1,[eDH>MXT)_]?;36NUXB1@L(LV+.&(?W&_b@YP:Z
T=F=>Ed^\7AY007>.GIfTc[VEVJYWE@0BK)I/^-6+deb+gPAJ/&B^X\2bS_SV>HJ
#1TAI8KJ^?NBN-8[L59H_Z=<G@T@Y)6,AVD@72dUd3,>@Y_</E#EAGeSWF_F9.>[
.9?AMcYf;IFWgeL+H5>:L7D,00&^dJ9F;])D#DZ&b/@[QC@LX8\Udc-5\RK:&YXC
[^AOL9<86g>XN(N0Da+INY/(E(.#<JL,:T(@#0S.?bMLV(<?dR#CeH+>4@;Lc9CH
G.RVPKF:gcTQB8@(V#LJ5.FBENb+?Z.9_GCBaeT0gHg_5,RUc_Pd]b/67F@\8b[#
(CNCI[QO5+IDd+7\c9\>/;6NFFAa)F;)H,LW-M@d>?0V[UVcSW>Q\ACRZTa^<GeR
KaVW36F416O52V]CA@]SVYedcaZX;L>+.)ZgKRCB1T1@5,&LJ+_&2(..a\XQGW/K
cU?4@5CFQU]Rg@T;gf[OAN6/[GV8AI4/Ab?)F&VRMVHMc>7=W=G&a:U5=-::RcXD
.3W:_E]D<&FPd9KgYAePKF+G415,TD6&I:6=0TbOG,Z]4T&;+(IZ_7=.P8[\S-,#
^(<[-8Z@e6b8ceK^cI<c1GU^JHZ>FB)@M:(Y)E?(BN]E]RYKPV4fb5EUN;A9LL+c
9=.,WA)0377MF2?F#=;K]C[J9/-0?^AHRGgdB.cEL2UHHf4A#J,a^d0]N(Yd>I+2
DL3-ceJEJ@ZM7+5^]dX[JQ:;[I2T@\Vb;OZ6IMePEZg@D4R1_)Z683NG4)_TYL;L
VP@abCWAHD1],A)0[/>TLAKaN91aZbbRIPU>1/S3<Q<\AXF=6)5[9E]IJ8XfGPTQ
Y#T]X0BT>[Y@;NS&C)CB2B[08=:T)YJQWT<IV4:@Q[O9aQK^(c[R3)0-Y3_8?e&V
MH0eJ;J2HX?#V)_ZY9W&2,4MKE]SR^WGTVc()L?<aG.f0_#)-L7JdLQ&eW;#GZ=[
-:QRd\FEZ?(.O9MP6gE?:0]4X9-<48CG9C[O+93G+X=\NQ4#Ig96FQgW;EaPS=E7
8-JTPZ4c@&cHIfc[+a?8FWP8f[2FINEJ_QNONVJ;OA)6#[5Z/X)7d8S##H2(62(Z
UM)Z0?-P(JEJP]R6^A)G@B#:GXMUOTZN+K:(eQ.VM/HgdUXa+9?#92K1Q,?c-a<Z
WaY/OVG@L2/QYB34=6I&#N6P#Ob/=Ic66KO\2>QH>([DBa<RRH/>,0RF[(S,Y(H,
DAJa4[=\Z9-XWAYY-D2/^#1\1X5MLX>;TcC1[dd^d4BMT+9NUPF=&597.&<GL1@B
F;/S_=W&JE[6B==-E-)YUJ#33WFgYWU\1IC;WdX@1\^UN[ba@0QCFFbA]MVR4WT>
E4WRY?)N8B=C,8=5K.:9PZ\cg8XGE4cd=Q.g@)SW@(,99_WINgV\>a,#d,93XWb0
Sf+C/(\]O3-Q@=]92[(R>5fN[.acC&?fB=;3]TEeP491E6V51SE0(?8ZF#<SE6)<
#DF\).8MA:PgXJN=\0DO4HKRTg2.U6P<?E5aNAU5ZgeaI,bGR#F7H\HRdb9:DVYb
OV54&_;fM;:(NQXUPfPFB,FIGBR0_H?I<Y&_BT0_&W>Me9ST&e9\E?+gA&/7Z88\
]\;7Bf/XEfMBBC1Sbc)Xg@9Ud0bfLR/OAMXX(gGV^2=:f364012MTRT[3P>[g)bN
c7]aH^,c^E^GG18CX:??#b6-.c,7T6DD<3<53Y-&SBWMY29SVgQ715K>F7df/JdE
I3,B?N&_OE;RYB2CdcNT=D_<_PF9F1JAS:EDI^PVcMR<GRP<g7)OY^>U[@PSf,6(
d@_>+-Da.7/Q)D@HIZ&;PZ;:9>-2gV^R>M<Q?VY20\\<a2&C3C.:<?K6K+1W7L<U
dMO&4K1@f#:9-Z;BcZbIAd2H#U-gX3<W7-A77IXf9.S?b]X@7ME_ge)3CFf<PD4:
P;K8J50?#ZB?;+^:-9_M\&TSH3R;G@OW24MDKDb6Na85e_\@c7?>X.;W?MDLSLYA
D(JE1cE;QATOVB@P#2]/X(C>VHL&W4[7C.e_9NY=AIIE+,,^74f(3Zc1EEEc8P=g
U#HD)0#)K9dLKPF@K>14-K3M#CabLY;C<aC/T=&6)eH=/+SYZfTL9[NUeH[2f83D
:19-#Y)FD>#]Tg5MGXdCZ6O74]OReM;;7I::G6,O&K=3Ua2dTPQ>DOMPDAg.\8RP
9,>=D?2#C-)S-J_X^G^31KVY\-,T<.cZL4C#49KK4+EYaZ+C=)TQ.6W.(WC7T&.I
MUEU82d3K9SYN7CC_OTREbg#,)WRX:(7d\J4O3[N8E+=,SOGDMQT:Tf__#\:#GY8
;^?(-F:/+9f6(^H;^2D<62Qf,7PBf9=@F\MXBX?\A@@ICDM8S9,?IM&T9f]O2/0a
(Q]>ZQ\Kb0BMY3;6P)ee(D#8Q;T+eAUEbb]c8#@;P2.fGID8P3/7@Z;;8X_CJYK_
G[@BD[/Y:L[17-QeNUX+/7]P+:DH.5YTU]3G>9&e;=Ye)ZZC1FPTVB6S/<DWbGKU
&aF4N+bPSccC-(+G9WTT9;0+E)Q)7^aPU\J5-5D?/O&2MK@>Oa?@(8I<PB+;9V[)
PZPcfR)@c=.2YN@(._U4[RO_YdN9+c8ANO(Z9ObNQ.-I\_=\<c5&5M#Q(6^J5WOd
c.7U8I5F(dM(c?&\g^?9<SeMf\)7L[TFJf2Rb9ULU)?@IXCZPAHdY81\#g8X+T3Q
XG3_c[M2D(2DQ-dI8[b1eDX0/NRB.,L]6>Vf0<(</b<.DKD=W83\b]/.@4T&P=Y,
8TX/7QFKB/,1?PIf2B6L#,Uc>\Z>U<b2;cYR(VSb,\R_+;Y1bYQ.)NO9b\S,Q+9g
K[DFEaee.d9&>.IR\X9/Mg8EA?VN@0d90/f=Of)fMSZ6;4b3-PabS?H+P-=LN0T\
6-GBW\PE4d:+KG/C62fKR;U^I[LLR.]FF-Od20O2(IgfS^2#gd]>fLG2BTC1I&:4
OZM9.CPI_<^L5TY=bfceLH<R7S9T=71F+#FMEaXJeA;CQMGAA)Z(=RNW,-\??6TA
ab7AUPKgeE,&;0I0?4VN.&eb8a=dOM:7CELJKW7>-F4?7[DGa[6VI;@WA508G5Hc
^^]OPG>3N(S@<5F#M=D654&#CdRHP.A0V\:N)a(/>/IW+cWf#YZHZGLH\T[?9U:D
W7>Bf6:,#GD;)(_CC7&&eWZ,S0#)e1+XC[8g4UQW8\RNPT5>D<,DDQXB1/CKR1EQ
cM.U>_;P;FJ^PDMP1TW5[ZA#X^Lb[3Y4+TfZ=cX^U[PBT^C2e3DV_0J:JD955:DH
0D)7QgS8/.O#74@FWY0J,FdB+Z9U,Q1Z7GRLZ&)\4fd#bf[L_Z(<#eO)K(IG(<IV
SUD=?OBH6(20;Ng;NJH,3,58&T=8+3/;E[7b1a,]N>T?J/D?IQ_;F-[39Z[Na6N9
9,M:5[&+YH@+:3YU_Q09S9588$
`endprotected


`endif // GUARD_SVT_AGENT_BFM_SV
