//=======================================================================
// COPYRIGHT (C) 2010-2012 SYNOPSYS INC.
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

`ifndef GUARD_SVT_LOGGER_SV
`define GUARD_SVT_LOGGER_SV

`ifndef SVT_MCD_FORMAT_VERSION
`define SVT_MCD_FORMAT_VERSION 3
`endif

/**
 * Used in the command model class body for each callback to make it 
 * available at the command layer.  Implements the inherited OO callback method.
 * The base transactor should have defined a virtual method with the basic
 * prototype "callback_method_name( callback_datatype data )".
 * callback_name is of the form EVENT_CB_...
 */
`define SVTI_CHECKXZ(portObj, portStrValue) \
if `SVT_DATA_UTIL_X_OR_Z(portObj) begin \
  $swrite(portStrValue, "%0b", portObj ); \
end \
else begin \
  $swrite(portStrValue, "%0h", portObj ); \
end

/**
 * Logging support:
 * Used to log input port changes
 */
`define SVT_DEFINE_NSAMPLE 0
`define SVT_DEFINE_PSAMPLE 1
`define SVT_DEFINE_NDRIVE 0
`define SVT_DEFINE_PDRIVE 1

`define SVT_DEFINE_LOG_IN_PORT(port_number,name,width,in_signal_type,in_skew,ifName,clkName) \
begin \
  integer sig_depth = 0; \
  $fwrite(mcd_log_file, "# P %0d I %0d name %0d %0d %0d %s %s\n", \
          port_number, width, in_signal_type, in_skew, sig_depth, ifName, clkName); \
end

`define SVT_DEFINE_LOG_OUT_PORT(port_number,name,width,out_signal_type,out_skew,ifName,clkName) \
begin \
  integer sig_depth = 0; \
  $fwrite(mcd_log_file, "# P %0d O %0d name %0d %0d %0d %s %s\n",  \
          port_number, width, out_signal_type, out_skew, sig_depth, ifName, clkName); \
end

`define SVT_DEFINE_LOG_INOUT_PORT(port_number,name,width,in_signal_type,in_skew,out_signal_type,out_skew,ifName,clkName) \
begin \
  integer sig_depth = 0; \
  integer xTime   = 0; \
  $fwrite(mcd_log_file, "# P %0d X %0d name %0d %0d %0d %0d %0d %0d %s %s\n",  \
          port_number, width, in_signal_type, out_signal_type, in_skew, out_skew, xTime, sig_depth, ifName, clkName); \
end

// =============================================================================
/**
 * Utility class used to provide logging assistance independent of UVM/VMM
 * testbench technology.
 */
class svt_logger;

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  // ****************************************************************************
  // Protected Data
  // ****************************************************************************

  protected string in_port_numbers = "";
  protected string in_port_values = "";
  protected string out_port_numbers = "";
  protected string out_port_values = "";

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  local bit  logging_on = 1'b0;
  local int  log_file;

  local bit[63:0] last_time64 = -1;     // Saved 64 bit time.
  
  // ****************************************************************************
  // Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_logger class.
   */
  extern function new();

  // ****************************************************************************
  // Logging Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   */
  extern function void open_log(string inst);

  // ---------------------------------------------------------------------------
  /**
   */
  extern function void start_logging(string inst, string name, string suite, bit is_called_from_hdl);

  // ---------------------------------------------------------------------------
  /**
   */
  extern function void log_time();

  // ---------------------------------------------------------------------------
  /**
   * Buffer the changes to an input port, this task will only be called if logging 
   * is on, so there is no need to check if logging is on.
   *
   * @param port_number Port Number
   * @param port_value  What is the new value of the port
   */
  extern function void buffer_in_change ( string port_number, string port_value );

  // ---------------------------------------------------------------------------
  /**
   * Buffer the changes to an output port, this task will only be called if logging 
   * is on, so there is no need to check if logging is on.
   *
   * @param port_number Port Number
   * @param port_value  What is the new value of the port
   */
  extern function void buffer_out_change ( string port_number, string port_value );

  // ---------------------------------------------------------------------------
  /**
   */
  extern function bit get_logging_on();

  // ---------------------------------------------------------------------------
  /**
   */
  extern function int get_log_file();

  // ---------------------------------------------------------------------------
  /**
   * Replace "/" with . if exists
   * Replace ":" with . if exists
   * @return new string, string which is passed in is not modified.
   */
  extern local function string clean_string( string in_str );

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
OGeNA?=f[AaW&U+a[QOd)[FV=&R@^Z\]Z3KMX[_KL5<EKBIYKCKc7)>(=7(OF4Y-
Mf???6+[CC^IHN/[)gF/UK5YKfES\7eY:VNQca(OIgH+?eG=ME6E7KFE:cHCBDHJ
]0>^T9,SX^=-bVeRRb7TB-UFgD3:)cYb6TIK\J]+b3&+QMB\6bDd9SIV/4@MQ#Og
NH]1[ZH7Y7Q,1\,.KaHLV(0P(3.S=(&NH/Z;[fB8KNKYN1Z/P1S_1\]<6V=F-+\9
70_Sc<K<McGQ-fIC=g9e)@BH0M95Q:?YA1@9>XfaT@B&R@00]_/F/1\3?WV7&+-4
OeK[YNW?LO.76+6RbC>e?3XN2/&[;P6SRSC=bbI3U_M1ELQMI+,,2U[E.f/L?c,)
<?AH/HR#48:B=J47?1)1gC[D@T:fH;)T_J=B2Yf]JG[=4\](J02)[X2X-#&0R4)3
,P]15B-cRMVSB3bGg8J/:f1C?-]LNd/,Q:TD#W:6TCgJa?6J4b]8PKeKcbY7Q+?E
=Y-9XT89G@<f71GZ/H=aG9Q]b?dc=R/QC_W>@0M)>=cJB@FB:S0f2V57M2#W_VV8
#Pg5fbJCSH@R0Wf;K5gcS;9a4_S5N7]R:;^[7N.HR:<&X=4Q\.d3c)-6WaA47E4c
U;.()_+O?(HA=:Z6L-)cG,agc&-?#ZD)6+fSCRSfaU]55b?<AA+^8_\2>8J.\B-)
06Z5FWQUC6_:QW#:;@XP-;X<dce6/)cGV66aIe,/]N76Zg\6cZT/V_/ecaaa(&4\
bY?&)DcMW)6JR=]=2<4D++OX)]\U/Na1_]&7M-5UN_0SE.bTX7PT&5D<a[P.EN#9
#ZL/HAWQVaZdL[A<4;^M[E_]Hc_5#A2b04+&./:/H+.Y-H1(^B(ccM208F7@0#YE
e@Y/IUQ+9dB13JM1MUGD4<?2bS?L,g)P<Qa3052R._1,f-:4P)697#Te0UH3Cg-R
(96Q3BYY3^dKYVd/HJYW,KY2K.QGG+/WC4GG:NJV@44gB+Cc^I,9WTOP4g>BcMc/
,)KbYaZYEI.a7M=B)D&Q33e.aR1U2L&_4/R?#^,^a[F&9e/;)MX#:CKDP5/fD-fY
g?6E1Y(RM>2J,e50gP?E1,Og]:aF-3EKSfV?HR9_I+J7,\NY/WZ;Q<Ge7YU?S?HM
L/0A0Q/[V:4F7Ab>G\VV[D+A.MG>0>M72dCdPg4+:b+1R1d7T/P;)0#(SgZVM75S
#]D,AfI^YQgUCUN[[QE\;/M2a53#,gfE\=\NQFOcdGY^cWM4B___PO7#>T#?)T@N
/&8_7&P\^I<,NZX#A\:,_);L(WEGG4N.VZ?OLgICX&QLB2X^4GDF[[,ac@OHG)VJ
gD-TeMeCM[VDa,KWDTEG@OW-ZJdC_A6;=M5?;4=I:SCfAO];LLAW^/\&ecKK_6;4
:D?e(d7WZ8eKR&:=.ULQ8T1XWDG[2Gc4fdH4GJ]Ba#F<JVEBKReJ8d8]0^#K2&=H
\D>1KPGL7VSKW(77Y@6\USC.J/f^2?<,_R#0fH)0/Y1_X;Z5QVL5eDfS1P:a[\YI
:^<M5gIAYLD)#c-U#.2>/?5e&/2gD<X/TMVUA10D()e,)eG7IdAO;,R;Q6c3E&9W
SW<B&,7b4FR-\ZK/#_SR:I?a+f5WC05D2SEU9IQaLa_TGb5BXM3N(f410RUd)DG8
PAA#X?B>W:BK_N[X[?FRVP;:eMIMXV48,b-,M-cRU_fNPD<Hcb(,I]7>F0][XY4L
?/BFQ[-?;bBd>a]@^8M^;-2O5XfG\,<:aZ6PGFO11SU_;?SdY]RP-CY5Se;>LNC]
@CS#Ca-Q\M26H?-<MM5I=19+F(4H^H[+e3\3K6a=P@0Y(eU63,V-1(872gf6bAe7
A<BT,cf>T3MJ&)^T&5:VB&REVfP9/He\KUG[J7bPJHGR1+bO#5C]UU(a@)N8UaMO
0Ra)<A.aTX>feZR-&I,-8C#B]X=b9,E0+_a366U0:#@FOUD&c.XR@3>g=01X(53N
#DDT^2;7SMI/9EV/cd]R>\^9cK\S4^CG&Z:]Z#STC0gPOHQD8:.0E/A/f6MTfXNT
dSd37;@R7FK3\<d?-N;4MF;;^9^&-=ZC34.D8#\G@O^SM&-_Z:RdOKAP:^Q<ea?X
PCa=E#X,;>Ob_18AgHLR@TdMIM1;7<ZV\e9ZOaK+-0&b=c5K4)I)FTa4ZG_#cH,C
KJOO>d<Y,,C>7eb;McBA.e^e[<&>GPc6_I:I5.X)#U^:XE>3Y15PIb1.V)L\-/])
5[NZHcFJ-ac9]VEX-^&(\+9^^F7KXT]JZWI4SgV=^S:J3=\;>.3J<7HRG048QgL8
0=:9&3(L=Wa_S_ZdacOSPUM[CM4?1?ZS15b[b@],0)RUaBSSY>SJf.1JGQ>,XA(3
)=/A2.B#AE8N]9O;^>9DX1/@Fa0aE2\UY3\)7F[0aWVWcIE880LMVcE[e\f+((:B
G-;(@H6JQBgNF<WQGQV#U1P+?#7e8>Q\:F0VYNUO#0#J.1=Y&TE3cb58VY^(4gLd
<O4@#4SQZ_]e^JaKQXMU(_fFL]]:266_BbTSUF=T/bIR7JS,P-132ALN4ZJB3+-O
QD3g]^VA_XU8@Pb.(41;ZS^N&)#><_F-OJBC2YF7g5XCS;BS+FR\J+V)Z,H59A,M
<-IeJ(--P?-1A^L5d)a_H:_#c4W&;=I.,bR?4G6IAcFK&)X5\2USV>MW/A4MCU8[
PIO8@+Le?X#GL3WQG.TQN;D-PDF[@#-:PA3M;UbL#0N,e[HGAP.TK]_\5RMGE7H0
We7?Z2aH1VGHIaaaBU;+1cH6YX&0X80R#d?G1)Z31[N1<A^>bK@WQKg@V)RBZ5e@
=[==;3OfPN5DHKUOPDV)2FPIJA/-0OdTH,O\>.QN2I8.c4W4a]Gb)>AaO8(_J2CK
W;:Rc\eOL#.8&G@NAMSQ@WG.)WQ<aRB<Gd_KAdR#)[#-0cR[)\4Ra0()@2=@_K?Y
g,FU?8.]^@P).>/E;-PUP_Z#^JcKbC+gIeTIDA-1]##A7BNLg]bJY((2T87FQK8f
g3IJEF:?#0M@LOT5ae:X1;R.2:HGS\IE6UQ_;1&IS+8;ZQ@F81W18a@I6>c54L1Y
X3\;]a6N9=H21Y.WA&=6W=2RbDH(XQ+>dC9?^>[XV/aW,a^Q#TQ^PNgCTge&MT]H
:5JJ.3f[g,RI.-L^J22J)eO.OT]a^b4c#)B:F4MAFee61/\<5JGX)=O37PU)]?89
f-MGAK6Cb&@Sg@@<4?\(:M]0JfeH@7P1e>-GW6>a?RBdK-LGCH0:#&K9>=cDga\T
C)<0,_?@ZUP[IXRb?L?gH9Q,2Y&UQS;U:Wf<)N;>=Rf[1<RZ+UZF6g3d)K5UN\V^
f&:+-P&aU4GVb/.?dDA1TG.GdR1g++_7D=];d;2c.af.K&V;E=\&9f/Y&8;4;b85
_O4F:))29f8]DY&+76O0W;CDI8Y1OI3\=A:gQ[a7[eFG22)]PU#[8QIGO3]O#GE8
:/R>aW&SBYg6@;PE0IS:W[<[P8F_Z\IS[\B]?OYN<0gJ-]F),I=aQTC7)06_Zd/;
1F;?L&+G+b-Z;QbPWb?gFU2<;A(X#:>V,F4?-RN1f9D&3#-+,0U?9Xd9Q5LZ[D/H
eg=Z\(^9Ldb>.Y4].,f,PeB?c)=)[Pe>)I;,]R-0-XIN/_E[BZ-]WXB=1DfY5JD@
ZML=F^-^D1]FGF;K+.6X-TS-JL3324FCVaQFZ6GA[?B>J\6M>H@M#=SP^BW^&eSe
e7b0)e1\B[c#U=D/5H>IJfS@Y4c,494OV>@VD^AE[Q0eW>;Xg//gf0ObB+1f>52\
LYP=>dbBT6@_K\;);5QD:WIME[WV+OC8\DY&DF=^ODKDRGg,3B3\\N=<,?,2f^N5
37,6#J<O&E#)5e,FPgM7&ddJcZA\[Za0>CCD997bJ)[O_I]P.N=aH-PB\=aSF]1U
RIZLB__9\1RW_4[D(XLc3NeV\9=MDS3-cV1dYGR]UNN:b7B^[UY0ULVHA6dc=YWO
3K@)_<g]TLG4CEQK1_3RSU:.UGX(Cd?)1S(7H\ec,DDBHJ6WX(XVNRJbAb(85ICW
e#T4,EaU.6dZ(;/G]XGX^Yg,.2I\ZXZZ6S^X3B9B/E_Faf7[Mf(]g]9fJH+?2@C:
WRH<^#gb4?E<LBH=1J38NI\a/>3_^.bA3bYdMd.H[86H-UAaJaVQBG+<(ICPJD<>
X>1N?OPe+Z[?@f<V3/,2^cRF4=e-R0@e4Z.98,:4DaH6+E[XW@fCKM>XZ^=GQJD&
/L9XG\NNG#>1;FM[a7WbdBJ)+cS<VE^@&KMg8dQ+=>:IGG]C(9J/<-IA^H9fZ=O6
Q2;89/[&gAfD1<DIW@JP.6X=;:FJDZIJWA[&VOddOU7b/CB\_]ZZ\Uf7eZbG7,.8
D<Q>C5XO\G9EDQ)0E&;/2_<,-\D0#9[(EKeX_SZCc6FXB8O,J#;@,KX[5XX=[]>L
X8.SSBK;4J44CX6C+Y5,GgW:.;:a95OODU8WN1QL_b)]0]-(/f,-FeA#ZR[EDWAY
[M^#TT-9367I8?(IZaP=WT??OIY83X(;=87>&E_Q1dW7M_XT5HDD5@HIaWC900W4
K@^PP@D+<VO^FRNCcLP-##9BH[f#gX9ZFBU:5ETYaH1BNE-E1P5L3MLEON81J9:^
M=/=/Q)NKRdH?K.,SNR7TN./2DZJ4E=U@c)03e,4L=WI?K:6_D+L^/N.aEA2S<(2
)KYT=P&EFU.e+bHEOf#1=dO0M>X=VgaXWNNgEb+DANdF(Q)e[8I4U22\0\<]47b+
dCV[[IHcdLEZ;:T7>2^-:1]Y]\D][3^C#/1=NE_RAXf;<aE)>TF+_g^S8RH.OB//
RO/<:S2FOE;KG9Y2?]Y5NE<<9J,?613=L(F1CU5U.7,WWP?A_)fI[4TJb8;83A[e
CYK[4^Ve<I>K/1(aYEEMM.(4@EX[E,c/=<S7B_@Y>;&,bOB)=H0;:6?(<A0LX]>5
BKJCM&08eEAITNec,eCPf93a+b]170g>WF(<KQdWe2SA)JCJX8C^2e?OK1(O?R=R
AQN&@M;&f29^?]AbQO92=:9ANa=F=J&&H0_X:[7YR-72RT^.(H1(^81Y/E@_DJXa
\e881YBc73a\_TB.0\2?EAO_UWRc7NCKC?Y)G1;KI=O<W8](23TZ9G2O\K;S^;H/
DPd#AGMI0\-,Y[2^P?f9-_4Fba1Q=5#,eM4HA-Y2\=ed.Q9gY\g-]?TYa]X<[T<^
9A1e<N-eT#[F)((+<?^TUSQ:c?/2Pe<>?LK5L4)N22,B:[HUL/bYO2Y_#4[DRC:H
E>]0DK@>Z<NO?aI2CN@P;N.Q\NZT@b9+)g/8])EbbDN1A>J6U_<M]K_XTBHWH\.c
1PPF206-4IP]^RZ;Vb-UQ;<&Rb]T;&^WB[cJeBLg6/-\&8K7&<Kf#RB)RB@S7(20
Lf]@(83]RNXebSEg9_)L;N7_0E41gc?R+3+S<S\(X&0#B<\FFS<.3.CCTJKCa(<U
CX=,779gO>A[d0dc\?>WT7&QV)<(U+M&KI\g.VP#2SFE3?CN?FaHOXf-)EadX,9C
C0EY9FWB7F=@+XVW<MS_98<DXP498JT(A_B&8QVP5ZW]0/7,25(C8^SgH:53)>HF
4.Ze.SJd.+g1:a[N2&[6CgX_A/O1S>C&8d38UH8QJO[]^)//JOEP[^OOB[98@gcS
c3M4MZ7g^E+D->&8HLU0@(0U;4?IK>7:0P->D6\)_#5E#?^<WWW;P9Pc8QKJE-TO
DV?GCWB,]7H3aG^c6,DLE;XJ(B+Z?NA\5O#d;e2Je:ULY&OVRa)g0HBbe_5B_XN\
1B1ST=.(b&2Z.#I51#2CYPL7<+PY)=25DSW>P.]6B3Xe_,d?BY0..d?8;B1T0O6M
8/#<IG-A7E5ce#BPE5[c>/f_ARUa,67HKd#f=@4b^#O:AV<+\9/[EQ6720JL.MDP
5efaf)WT[9^gIEL2EJ5JBb-MF:>TGKe-+.:(bDXWZ&-&1eOFNA^I+F];WHfZTadM
-CE7dE.D26M0_Ma_RNAB?+1fbPC:D#O.7T8bHg0\+:F\5YeU-+F4,V9#RRfF)#2b
NTCNA)6SHI=53W&/3W^F.S\X_@7\APF&(<4g0;CSX3_I/Qg_/LB6YGS7Ef40.UeS
1AS\7NcbH2D<OX(@XTTA7Z(7E-88VF;6J0gJBXTC6W\R;XH8[CP_7<2>.>RY4O48
,>TQ3##V3-Z#C=)GY\3>LIU)YTOW8ZQaX_C[fd&2gJ?b^5&gL64+XcATU]Z8Q)eP
1;&U<U=<MU3A=C@aN\+ZJ5.=LYbVIS5@=CT2FNeQKcS:g8/J2A\&218TPP5WS1V3
2,;4<8aI006L>CJf_<KQX8310-9?[f6-TJ0ESBOE\+R_)KTOeD#Z,Q@\.&,c;K^Y
0&_]4\SS4]Ce-d,]L#T7c6BZ(LQOSMIZf,=aCX,M[TgMJ&PL/<]2.,V(ED1gJYN.
bdP=<Kd.dEIdWEZ-<5X(MT-)gH,NLfEJA=#39#K1YQ882@6E,;<<QE46U6g-gF-3
J@38RE:c0JH1dQZUV_Q(AE_(L+..Qc<1+8E9RSH=:(8#O)8I5I0ZF^dd3YY4eJKS
(#.=/U\9XY..ba@R17S4B3QVE#ePMROV(V60;?^a/IAV_eDD.Q/O_TYIC56Pg([&
)eWEX&\X+Y98ZO;&JZAR;\BD^D/J4W^\K(^.)ZW@/6AA^K3-D2[23,4QA3:KQFP[
?C\I28[g:VW.GJ\+Y.9fK4;QXZ6>@+J#L5I5G/000AKXQe([>G;&Z5;TL;O11OJZ
3]83</N;:(D&bD52K62CP6:^YWTa^4+b7c+g[>e-Q5#-R9.WQ@5>-?4B@,=3>U;U
3E4MDCDLK_NIL@CPXbJ8BS(AXL9MK6@<H+0S(7V3Z;/A\I(V/0ZJ>=[abbE_B?c3
e_X6MA/3@caH@Mf7U>_B(KO;^gP5b02EASc-W4A7bcZ9(<4.Jg->gB(MQ#C.=?0:
d5+gVFcQRJ9ba5Gb\&C17A&34L&)@:0&?.FEfFZ.LZ7=,eCG\9)W+SOT?,<U32c&
C3U-P\>)@?F,@+[>^YM,UA4.R72M0/03S<+dMB)6<+?Pa4:a1bCeIaCg>9?4JR^D
SW</.c+XVMH=-<QO@H[2[C#.dO&B7GD5VMPRNFY>c=cLbLCOa\N,TG7-P0]BNI^]
=9WaF-/f]_N1WG#KC=2\OcG4[XNM+V_\GG9W@Xf=AO-0;-e;&RO[UFc(STA:KGGW
N+1)d@RH^-,@W;cZCUHT3TC#CcKX?N#c8.U-O[H0O8BMF\HV(+)WTCLQO0#M8NDL
+V,,+F>)4PGG=4AgO>GdIYb<_g)>U-I6#;1L6<SGG19,=RdS_3B8H6:Q+AGg:ZQW
E#648VLH,VAQ4CH3/<R_R<(P8C0dHD05g8-(O8;c/:<<ZC-Sb0I0(9]W2Xe?(K:T
FY59X]]4S.?@:fV+H,(1SC_79)UC:^FQ6O)9e\S?F:J]6JG5,1bJ?Rd//)eHQ:=9
8B3:=:?If,W<O&L]^O6c3He^G40H8R(;#D2@f70RAeW5AMV[^O)QVU=@&+>[XSHg
[#,/^@N@=GLg<4<T3JRH^7IQ+1HTgPPgXD&a^1T>V-BHHLeV0BA2V^d64Hd^K.Hc
DW[,^/.P8IL<PHg95HJ+]Kb\T,&ELP\K<]:cTQQ69^[^BcK33[Z?f3&^Se/2a1#Z
MIN_b9+g[F8d6:[Qb9SJUJE-WeXbd:HTBb/[a.3eZDBJ)6aF@JB_4A#64.MCN,a5
@LWM/aFQK>L]RR\7I\e4GG^\LcJEK=f;1D,B31AL#<WW6[=(Rc0VB7DY[K>+G46c
CR_68LCY:L,DAB>HET4Tcg4WHP@aA)UC.\^b8<^=gTDXD4<9J<aZYIW89PF?0=]R
ICU)^S[&8</WJ#HK0N(5b[SGH&Df+2QEJ9[-O/#b.RW7)1]d[1gFQR[10;8Y<8g:
)c3RWefU[27;SKW3;WPg.c-4R<;R[CP9+Xb@cKHRB5M-6b+19N\4Of##EY&P(.-b
7>68;RDX6GFbaUE7\3IbNGQHV):E8bVCP:I(AcW^G7E3I[.2EQVZHC_0H98YY2Y[
]fRK5F<3MK2F#GOdd[=Jb6+/P<Cb1:B_Q3#\cTC,EAU>GBDJ0F^N0662,a)Id-+#
+AKZZ42R^eT6G3L?WU9:C?Q-H]2XcHE/U_UKa)9>0_GC.79ZSH>.WeE+eNEdJ8PY
S70gg0[+OZ(&NS:bX)cM2@6VFRI/\aaZ2&d69?U33:_K<X2CL?_LA>5R74#CG9L8
aN^XN7]5XfZ;#I\b3aHS23M9M>D2^d?M>F2b]#&NR7gb.eBa,=D\I+Y<[GQOBU@d
0\0\J5=-+gAV^T]eEZ#b;V=,9F4)D1A,.TeH:^6#GI?@WF[/;7M8[0:I[e&RS4fW
,+(f/UfID;=UZTEUJP#+c8g)E-LV[-?,[X^BP63&K)D3YB1ER;3;Q+GWO=_0==d2
A?E8-\I]Y;@CVLgESNc8KH8AB).bNBAJ45[[(PKfdXV[KR++T-a@BSOPXZgZ:[_U
40>+C:GZ60T4[+f&MJ4#/RMdW7BF3=17O]\+Y[8L<aOK)g;c^dI3Yb-0ZRJG\Xf)
[9U0fDGU&Y@M_CIKH),SPe]QR2E<+\)V+0Qc^@4I.4G1^20Q_5S_=,d7fgV)=gG2
HYUEb/cfbPRd-8eJe/0D?d7W:+?J6g+3(5]KHLF)E1>;;XdK](7ESB/?#G](IR4D
T[.4)5:?FS27N&MER:_,[AOcAVV6B0/g8,O=]0WQMMB=[S:g:GN/J3QfBP+J7\28
0/+4eY/NO+eYE-B@JZ)SCB#:0H)TK5#/YaN)(E]6:+;TE7&UZ,3;)EOP;a:H.S^T
M2TN?L>Z3SID=(AMB;-JO#I?BC4UeA/&f2:g9#WUC6:SQ,I>7+N@@9#-9?W3fCAg
L+@7gG4]F1D.,T^]^aE4UOBH+cOINH.0.@M\=VWZf\=6I9B>.;X[>EfK^DB9S6?g
\,[P/Ac24S<YJFM:TfP)U]EYE6A(@fMQ-[=YT]9&;<H3S_9D7]#.dUZXbU7#P3CR
H=cA3VYa0E,Z#gNSBWEg94;6,a\/3=_\)#b+FbJ:)5->?J)K3Ag.R_FH&gECda,@
H(G/[41HB4Z&X9M5U]JBPbf\-;[C8V94UF8,JU)W-6YNY#?MKYTIIDFB8DP1PdNA
7@7eL)0^&9H#Rf1LDK[_RI+@^DU(E7Ve-gM#Rd^c<&(A,E1=Y7DZ64C:)PHDf;_T
6PA^JC2Q[a555T1>)+F>(5\=MI0dTL187U.,/bVce=]-]55-_?aa5>E./=c&\.bC
Q/>FKHFF=U5[CMZ35dP[8;UWP<516^9=)/P@-fDL=V5bP-T42X[V;6_-#WP:A\ME
T6?;=1UUc#bRPdd,SSKgGb<Z:8Y=Be;^+;_AdMY\>\(65Z8U5EHN.7a1ENR<87Qg
K@W:(fP]3SfdTSNaPUX4VLPJVJL&?KdfPWNQZNA=]JdbO6NPRB(]ZId0\D];@=Jc
Y3##[9,CFef7,M\?P/>+f(8cI_-8O54Q[T_J1@:b4S&PZ.AN.7DZe;-PT)WAdDW4
8W4XJG?5E9[5VK&W[H6@CID/9XEN?52(:GLgU:ZOeOEg)K\+6&@cUePNe5dObEb_
eDE8Zf3KH88f#UX\2B]<AEWWfXVR1L)2?:J>JL6JJ0Z,;>>J9H1AOW:#_Ld/[(2?
Q,CD(R<Y7d-D.2Tb^:TT@:A?bYbV7/,/M/6g6ZI2e,VD32\&de@dd&+eQR]D2KTA
CDMf8X?B\S(-RNI8-c8Md=79GPNW^-CJ+0cE(6+#C[T^((/f2f8O?e0W1?)b>/Y:
A:USeI647RU]J+.UCEbaA-5D(&DN>ESO&e;aSYcYHE64X+BGc7)3Ae,SU=Q9X02W
?6N-W(<DE.RU\/@=cGUg.BV&JKId_L:/0YE3c_,?J0AY1@53b&Y3EPV/QEJ#ZXRc
61@62/<[_.gcLQ3fZ8LP.Ne+?2\RO&90b-Y\^9[^N9,HcEg4XJ5<EDKeV[:RLV1N
=6eSa4N&MF5c9YJ@W0+e+0&W-+XUI+>YW:26e1ZOR)<AfR#QN_2B[c:H/>/NPRf8
>d#4F<5X#I-B33U53#I4D,#@a.<,]_Rb2dM@X^c<EA];dA<UP^&D=VL(24]6L\NB
LacZbS_gIHAB+Y7EOCaHAA#-#OXYCUC\S:BENULTLJ\/TbRd)RG1DF)c1H#_ZdV@
S?)ccbc:A7P:ff5R2>DgTAW;S6=(&TVG:$
`endprotected


`endif // GUARD_SVT_LOGGER_SV
