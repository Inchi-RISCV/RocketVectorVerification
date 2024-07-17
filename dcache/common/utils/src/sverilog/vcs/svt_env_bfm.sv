//=======================================================================
// COPYRIGHT (C) 2011-2015 SYNOPSYS INC.
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

`ifndef GUARD_SVT_ENV_BFM_SV
`define GUARD_SVT_ENV_BFM_SV

// =============================================================================
/**
 * Class that provides the basic infrastructure common to all SVT ENV components.
 */
class svt_env_bfm extends `SVT_XVM(env);

  /** SVT message macros route messages through this reference */
  `SVT_XVM(report_object) reporter = this;

  /** Flag to track when the model is running */
  local bit is_running = 0;

  /** Flag to detect when the model is configured */
  local bit is_configured = 0;

/** @cond PRIVATE */
  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************

  /** Identifies the product suite with which a derivative class is associated. */
  local string  suite_name;

  /** Identifies the product suite with which a derivative class is associated, including licensing. */
  local string  suite_spec;

  /** Special data instance used solely for licensing. */
  local svt_license_data license = null;

/** @endcond */

  // ****************************************************************************
  // Field Macros
  // ****************************************************************************
`ifdef SVT_UVM_TECHNOLOGY
  `uvm_component_utils(svt_env_bfm)
`else
  `ovm_component_utils(svt_env_bfm)
`endif

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new component instance, passing the appropriate argument
   * values to the component parent class.
   * 
   * @param name Name assigned to this agent.
   * 
   * @param parent Component which contains this agent
   *
   * @param suite_name Identifies the product suite to which the agent object belongs.
   */
  extern function new(string name = "", `SVT_XVM(component) parent = null, string suite_name = "");

`protected
F4KNUQgM.0/\&BPgZ7;/9.D>0bS/dQ6fX@&QQIOHVbR3)N6BEI6e/)+,YE;?eL?Z
;]2VOG?eASPgZ.D?^OH8D[/@[DSJ][(A^QM+^3[c\+_:J54BX&:GX586.:2-J?c.
\UB/@Z^QX1df]>P-4U0WEg,9eTUJV5egO;1JT1JXP>::D$
`endprotected


  /* --------------------------------------------------------------------------- */
  /** Returns the model suite name associated with an object. */
  extern virtual function string get_suite_name();

`protected
S3A40.@4AO1U.N\;H-VV,]1=Hd\g<A;)PEX<a[<REN>1NA:dFf>N()XdYU\Q,CQZ
?HcTLfIg8BP,M?6^Z@d)bcJ+2Q3]X>bV.e0a;_@4J09^#Fbac>/FRDKR_,G6O2=>
>WJ7=DY804=,/$
`endprotected

  
  /* --------------------------------------------------------------------------- */
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

  /* --------------------------------------------------------------------------- */
  /**
   * Returns the current setting of #is_running, indicating whether the component is
   * running.
   *
   * @return 1 indicates that the component is running, 0 indicates it is not.
   */
  extern virtual function bit get_is_running();

  // ****************************************************************************
  // User Interface for Configuration Management
  // ****************************************************************************

  /**
   * Updates the components configuration with data from the supplied object.
   * This method always results in a call to change_dynamic_cfg(). If the component
   * has not been started calling this method also results in a call to
   * change_static_cfg().
   *
   * @param cfg Configuration to be applied
   */
  extern virtual task set_cfg(svt_configuration cfg);

  /**
   * Returns a copy of the component's configuration object, including the
   * current configuration settings. If cfg is null, creates configuration object
   * of appropriate type.
   *
   * @param cfg Configuration returned
   */
  extern virtual task get_cfg(ref svt_configuration cfg);


  // ****************************************************************************
  // Utility methods which must be implemented by extended classes
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>static</i> configuration properties from the argument
   * into the configuration object stored in the component. Used internally
   * by set_cfg; not to be called directly.
   *
   * @param cfg Configuration to be applied
   */
  extern virtual protected task change_static_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the argument
   * into the configuration object stored in the component. Used internally
   * by reconfigure; not to be called directly.
   *
   * @param cfg Configuration to be applied
   */
  extern virtual protected task change_dynamic_cfg(svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**\
   * Copies (deep) the <i>static</i> configuration properties from the configuration
   * object stored in the component into the argument. If cfg is null, creates
   * config object of appropriate type. Used internally by get_cfg; not to be called
   * directly.
   *
   * @param cfg Configuration returned
   */
  extern virtual protected task get_static_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Copies (deep) the <i>dynamic</i> configuration properties from the configuration
   * object stored in the component into the argument. If cfg is null, creates
   * config object of appropriate type. Used internally by get_cfg; not to be called
   * directly.
   *
   * @param cfg Configuration returned
   */
  extern virtual protected task get_dynamic_cfg(ref svt_configuration cfg);

  //----------------------------------------------------------------------------
  /**
   * Expected to return a 1 if the supplied configuration object is of the correct
   * type for the component. Extended classes implementing specific components
   * will provide an extended version of this method and call it directly.
   * 
   * @param cfg Configuration class to test
   */
  extern virtual protected function bit is_valid_cfg_type(svt_configuration cfg);

endclass

// For backwards compatibility
`ifdef SVT_UVM_TECHNOLOGY
class svt_uvm_env_bfm extends svt_env_bfm;
  `uvm_component_utils(svt_uvm_env_bfm)

  function new(string name = "", uvm_component parent = null, string suite_name = "");
    super.new(name, parent, suite_name);
  endfunction
endclass
`endif

// =============================================================================

`protected
UT:;:U1^[B;Ocg7c=R\2GN^??CMJHLg:[GT-f0.UEaaY#=.]U/f+7)5aca_T[&EK
]P-]/cE>LDC),cAD],X01G7#bZXT^(60LG4(e7U6KbYVfd7RagdH@MHIH,dV.R5L
eV22M1&e11Fc_6MQQSN>ScfaQS&VL/NeXd3.5R_207/H2a8T<Eb/CE@eEO4#3##9
9\Tc#O6DaBT8Y@#0UDN\+6e#;cVfdKfO7OYD6_Q1Z)HRXcZ[]:_>Q^9&<;DD(aJ[
bf&:8[H1TTeJ>N6?[B7SB^=BC\?^#IEVN2Z@-/<&=))Z;<;YNg-_9#8H_BW+C<)<
>GTNe4VO3ae)(&;O)-Cg=K^#g71Y8:0:6@FbGSN9ZZ5<<dBL68FcWKFNCdQ1WZ,U
<]?2fPE?E&39;CO>E4<I^U^T;W/=0Z,:K.b7]739V/_8FQ);Y\_.:fZS:BD_DBa3
\ANg.4.H+bNc<J=G^)=\UZ,J3T\./gXAO7+IN^Og(#.LVJ4^ZHX+:,W@JB:/,P@;
I,a3\+4<>;>I,7ZM4D[_eUW4-?>(.5fK=\]EdC,KD^F_1FdL?gAAQ?N5UX&FJfV(
)YCaX8^.-[5M?CGN4C,TffBH]Rbd@#=N5\\C3RRef?01+64&0RI>DN-<,_XNb/7A
O^Bd-NB36(5T,ZPBMS#SV26)0NHUJ[QSf93DWc47NV7:c8Yg-Q24_TX?[MBeDV5;
\<B.]8)SL9-Bb3T0R(WM+Y&^K93eJ9^@]S5KU^IT0c>LJ5(9L9SQg2XDU2RFM_Q;
4Z->V:D;JI>2LS+Q;)OQadc6X4F8IdQ?_ND_IRc5N4KNDb<+[V525.(MO]>R#_dg
d)Da3#PMC6,.:LCg8Qe9&.6-+_2D<73U?PXS?.e^P>4@7]OC8OK#WO@HCF;ZFY&X
B^?]>b[=N^L@6)&/b]577CYaLbU8K/c7bL3V+<2e5:RV;AUe,,E6O)#@@_AHVXg]
O_Yb<#]BB_;dHKX8,N_eZVH\AS,>T;f]A7TXT[a1.dFF=B,HG0PIZFW94B;IR65f
B0Tc4(2M#dRdUbN#39FdE-I_:<):bGH82]OBMcG-cVPTUJI3N@_gZ^K?(3\J-]7\
+9FJ]ZUK1HV<VX-MeMd9BMWDX?CQeFggISI6M+6K\J3eS.(U?MDZRMMZ3XW)+QB2
V)SJg;7(/23b_RDba35ZbO/K<g.TRPA=<+F\NgV?S@GXG3DY:/Z((SP5T-8\7Q,G
ORHZNCE2U0/W>(;&:GE+W38&\8cU.N^SaUaC_Pa)KR=[;;K/cBf)JWZ2^CZ=,M(V
@.95D+WB3H[D\FP&5V4;bVgdZOgWQKGV?HHQD^+-YEB[V2\\JN-1gaO\E_8f]ZUK
)<U.=DfO;c07;W&b=8e1VbOKIM0g.JO])KgVJVA:3[X7SS-GP057T4J\7fDS>1aN
-C@J22IU74^N/>.:1#M^ABTg1(-/.f(b^9UaQI6;;2=KTG#=O>;<K_eN49>3\IGO
>gP85[OWE>AYND_&MG6bUP^(HeSB3E58[_I.;BDcRC/.X?^BXBaf;5WKQ5Db8&RB
SbVe+WTXM9WD&[g8RHMAea#Q0D:&>O/]-0/;O\BO9TDfC2\74cRN\gE@ZSR8E\X+
9L:[M/QfH\eA&[I[/<)DSJI@.IH.]CG4[P7)D8@;]SFBAc,#d^U:,S?\)G+2agF)
E+a(O2R<Xd=U8Y;G4f5S&3@ba7JHIe183J8P7c0BCYKTC?J&a]SG1^?F-GRYe8),
?R,g55^8f.(KUe#7QI\faBUP\(GcO.J4V-bHB(<CZW#W3&TLR<@:\2J;eOcZ&E<S
/]_DJe>29Ce?6K^9DV[\27Z,Ae^2eJL/4a#Sf;JI<K6[YFd+,N14J4I\E)XWK]KD
;c?DA=PP9[.[QQ;7>AWE<QE3/K6Gg65gEbT/bLD+5:M:1MC0^8;8NGRW7>HCLPM(
QQ9Tb#^M9YgRa[8QH8:CaB(@Ke..V7,2(FJB.aeT]+\-Ue1ME#)f8VZ9)LE:V++g
@I3(,f+70&V;d-@g0\R4WFYfHDW;/)??W][b.\,[1LRU5)=)>ca0CP>-B[c/dMe_
&P7PcCOeQ0C@L8:?f2+,_57[6)@>1+CL4@f_XQR]:R75.G6fG2d0-4)T7KVBRIf=
H<EaF9K]+()5ZWN#@3U=>X==&=(3QX/E;8;1BJ#CU97KK@dO-,Ld5C=UHYKcfGbT
Z+GO;&(#-BVQ=Vd71(bT4DJQe^EK?VJ[[d@JV11/?W?X<IKHdXJ7abFe#C.?E[N[
-[B0:0Z5d2cMY(@bWSg=YAJUBfd,LTB+@(&0RDJCOEA>ZX&cE-MQS5JgR+8:6XVK
YM/<=DZ2:Jg)e+Rg62]IV=)1H_B^E.S1VgL;I@NJTe.TK,,,)/NbJ#b<<[PURAC#
a&7OR_YeG931C1FU3&8EYEce>P,DbU?1K@NIE^cdD5YO3gT3QVA,,9e>eeQZ#XFH
7T8K(_HMT34OIJTDSH/3JQNCVUMB\d<#Q^Db]C#[Y.>4]#W=&A@b,;T-Q24O2DFX
_a:(YJUaF\VZ(JA;]V,E64+FE(9+@^5F#P(a)Z<##>C38d>M<:]0R&E4T9KA-DP8
aH<W\:26?6Z<GP#c2TQ^8PY#@bXA2VQJ>V8&3U1fDT:CA\VH0=QW:U=b8^Ed;ad]
TI9)VLOGWNM?0D_PcgH-QXR?2C@+VBVIF-I.),(=<<OG2RKg5,J?K8dF/C/DAML]
?b0LH<C3BQ558KeIA7#e\9.gJ9=WS?VN\?g4MSXWW2>@PG7N_\TAd):+ZE^BQS:9
][gTL?J?E-5e?OPIO&SG3aJ(f\MO8AaH4a3KYI3&EK3A^^FSee3)5PYcI+T;g8FT
5Q_c)#0fYP#)JV+03[C1Vg_OQdZGT6A@<HdSeR4NXZcMS@H98c3ICVbT2FeU/Ed4
_0=;gR>c1/@PO?R6/=]<09[HGN^=U1-IeJeVF9[b4[,SNfb-b6^+(C.3?G&C^J^4
T5_e,LP7H?18L:GAKZa?LFUU5[O\9=KS/=\B]C6/)WG.(88.fU0.9(TM2[3Hd2a/
B5K;McaId/UUfCAOM)^)^T([JLR19.@#OTa.BA[.4F_00M_5IQ&(K9fSa8A0fU&Y
?]C)^DT[JSHVI+3LfK_-=]#6C8Gf.4a9^\X7OC@8STLZ_6>MT\ERHL-d<VRS-7U3
N7JAT_BKgQfa^bR9Ie[fJ&#3#&dRd0N.dU2(_G-/V@H>gc<DFc@EbOgA-+:;YAN0
O;MNPc0a(1&Q+E#?B:Q<FEfL;4U77Q+VfK_Q^R;_==eK/gS^U;g4bT:Y?LdI(9AV
)[/;_D5fXF6XW2Ag(U_e](N&,IIfL4SP.)I7[82A4@M/7--_P;E6aPC?RLXAG8bd
(-LW##Zb6UVdEB6_#.&,F4(GSc7[GI^L<(7\^X^6(c=Y\(3_\-+=H9#dI8AH/b6\
H(L28[Z\:AJf=6/;/V33[_b?7NOF)_T2]FAI/&71a_1eCT5JP7NVKQ=.KVUfU_OD
NT_d(IV]VV\8>]5@1GRBIQQ-cGbe2=^?JKOC5F8G&@C5\JVWL?[N/4)F9^B+ae[4
fB8CeB;KCVCN2HM5U1^Q?UE>X&RaKJQS]19.TPSKFI,YU?KD\1/@R@a>&3Ca)@TS
FV=HE]J@-gbb]\/DWc@O6ZQW<aMCdgeeFZH\,ag<8;fX^JH90307K[@4L4++40@+
PF/:>@>AHP2ACb<_Xee?K>=<8IeYY=U[eBdVSFWPVS&eLIQf/[Qe>O\HdN.-C52d
dgFTG#=Bf6^9e?.T^M/+]G=+^@>WQ.C#N9a_0J><D1R=aXZa)-KPcS4Y_-f.f@<]
U5/cCVD]39A)B?-4&G./+YJZFeb<9AA[<,@J/)KY>9F@FTLc=0cS2@8V0OaY<OXS
+EC;f][^cFTYM7aY<^-N-c+UMQ0ac;QD7XMPSCD\_3>Z:@(1>?VA^5,JX8):-C-e
X-\L9JP-cGA#e^0.MCd1]>MOR#:eBV>8I8f>U72R99eVgSO7UNKCLZJ)J9:@Y-Bb
8dW[08J0N<f^:eL.9R8L\_:#@9G6>3:TEYUWJ9AZaW6CZ_+-5_V_L25[JU@G3HM\
G;7)M5(WUcLTJ]V9Y\I]gHF4fPD57+/<)6dLJYQJX3:+4g-\ICW9f\8)D^F:XZN&
ZSGFCVWa_3+eHUDIT,F_?c(],J(1M&eb7H.Me&(,,b:a;XHH+:)=E5W^Z?J3Z=O<
RB6D0BQ[V:KXI,A1W2f8<VIZ0L[fH)OMI;c4X/G-Z\-0[;F-35?AM33,YKcS5/aJ
YNWP8eU@cJ(;]CIZ=\[=M;(4KLg5AJF3HFAgUCV=UQ6?\,.@=/YBO;eO#g?FG/KE
=&]_S8&UW-Z6UDMUYUR4a[\YNa:W8=Y/IOA&AgN^\>&26Xe5KOSE#8E3=P3B6fPH
+7/2d=?>4NYJG4Z-T-PTXUP;6,[BHN,A3<MI\;3#\b;:D#J/-GaeKa(,A8;H2D3S
;]OE+eE+Y2B,CJ@?N0N)_J?dV(:-a-&NGC,8aUVK[^6OCSd[57]N9H/>;8827068
HcbG6-\@PY,aTBbD27[Kd8TI]Td(8)@0b-&R+.=2?f>5S:?M;Z]0Ac,gC]d,9DK=
1&T?#LK>G=)B3QQ&b[7P/>-aG;_<WSUb919,<O)6?=-3DZ937<:U>d;;GHBX[3LB
NM)_LT8<E/.64D1&B<BJ,b\B7]11>UF2U8MGf/HD0HbTc6+f\eE>C+L6:[MK(Y^K
52f/eWMJ2UX/ZV2J2FaMef[:#V<CF;IB#&XF?Z;S-9>ZUG?NF_0)G&e>GNAZH#/-
VM<LYb,YQ@Uc?LP;JEUVZ;eP-bBZ9W_18FQ>,UM9;dc49)I/RH.Y;-DK^?^@V[\c
_E;[6P\M2^?B7M_<7P,1DVY>@W.(<eI4L3H+D1GgbRD]/D]362:U6E;Q&8H@VJTf
H&\X/a2/:00TGWA^6Y=M&E\_9QQ:cW0c(XUXI9gUI<KLXdW.dN?8EZ7S:aDPfEQe
,\^VZL:&&XMB.?^/Z#d-E?d5bO&/MW2XF\A8[IQbDDf@0HFbg&0:_>:Z+A@C1-<D
M8^9YC[2E-EU^H=U4JO[W-dFP_6=?TY2+HM)cH#2MBB&;C-.?WG\bZ\O<+53+-2S
[2Gaa1g4;7RW<-J6;1\@PFL;=+YM#U]6A(b&3GA9G,UVJQC8)&B,S;E)]@5SOL/c
4^05NVcdM.M#S:J@DB=/VT&3>Ba;L8cSg1?32cM@?8b/YgcC>Y9gSc,:OD5ITQC-
@^+\S/S^H.V1FaMLOZH?6&5QdETJZ@D#T6XaH6]K8c5CG49>)UOYQM8N^-g-+/H?
=&,_>NSH@3Z[;6FFRYf^I<=DCV+fCN(C_CZgP)X+_EBZG1>:3]2W7X_ACbaO(449
G\TfLT0M@F.K.d/55^G2<1Obb75<DX0=+bFW&X/#/cVY9F=OQCV=QF-[^P9ON&S;
a=;gG_SD/E9@XBUdc6TF)52I1Hc:&.POL,=ERb)HX4URg9E\d7Xa3Z>:@17Z=G;U
FMYN&L-\U9-[/#HN4dbI9dZPFe\d[6S5]0e5@KOD:]-HTc]WV[ELR>,^Z@V??O^Z
YTGT-YIN<-;BVWOD=A<a[9W=?D-K;6^>DK?@La9^]We-#4]Q)KRI+8-.@)[,P8)8
GPH+<JR@\>:@DI(BOCM+.N?0M0\>7W3d#(>))-fgT<>\03Ke)DF^D>0eR#C-\)3S
HeTC;dXNLSJ<EW.Z93fY-VR6HMYHb1A>@_R>;?J2K\I;Z@6FMe)I#f_.b66ZCE=<
CH]R_3DPCd3&937>fI,6gZ_;LTL#^SLDQKYOFP;>5@b.X8b3E?P&X/bK-H(WSfOf
CGCgFfBTZc+\N]<&2e/b0YdRPaPa=FE^fYC?O:7XVa5cBF/E.be.(cZ83@/5CI[_
=?I6b(SCf8#F72G^M?(8Pg9]3>Q_L5&<-C@GF[\#RAF4YTXA(,B/+X1QEc1+;F35
]f&+LW(6EAFAU2.-Db.,JO@6gYUL:11EX7X1HK9L5S2,4g/=C+:-8e3[[b@8Lg8+
,LdO&Q9/E?ZC3+.,ZQ^AP9ZYUEWK7c,f_IW-=<c-B#G&XY=VF@[5cX6E5BY;\:Ag
GdH+5I.f_.=QF39I9Sd0;@(]^/R&C6+QW=Eg&f24:7caD+9HgTC9a;.I]?26Ve\G
a#AeCZI@=5:-QVgOKDE(EP0KT=K/MNY,WbMf>[1C^O5dbSK#^/6S_+MCQ&.A+@O_
7WDKL@5S1P^-*$
`endprotected


`endif // GUARD_SVT_ENV_BFM_SV
