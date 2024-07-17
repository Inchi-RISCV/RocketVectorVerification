//=======================================================================
// COPYRIGHT (C) 2017 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------

`ifndef GUARD_SVT_VCAP_SV
`define GUARD_SVT_VCAP_SV

`ifndef SVT_EXCLUDE_VCAP

// ****************************************************************************
// Imported DPI function declarations
// ****************************************************************************

import "DPI-C" function int svt_vcap__analyze_test( input string test_profile_path );

import "DPI-C" function int svt_vcap__get_group_count();

import "DPI-C" function int svt_vcap__get_group();

import "DPI-C" function string svt_vcap__get_group_name();

import "DPI-C" function int svt_vcap__get_sequencer_count();

import "DPI-C" function int svt_vcap__get_sequencer();

import "DPI-C" function string svt_vcap__get_sequencer_inst_path();

import "DPI-C" function string svt_vcap__get_sequencer_sequencer_name();

import "DPI-C" function int svt_vcap__get_sequencer_resource_profile_count();

import "DPI-C" function int svt_vcap__get_sequencer_resource_profile();

import "DPI-C" function string svt_vcap__get_sequencer_resource_profile_path();

import "DPI-C" function int svt_vcap__get_sequencer_resource_profile_attr_count();

import "DPI-C" function int svt_vcap__get_sequencer_resource_profile_attr();

import "DPI-C" function string svt_vcap__get_sequencer_resource_profile_attr_name();

import "DPI-C" function string svt_vcap__get_sequencer_resource_profile_attr_value();

import "DPI-C" function int svt_vcap__get_traffic_profile_count();

import "DPI-C" function int svt_vcap__get_traffic_profile();

import "DPI-C" function string svt_vcap__get_traffic_profile_path();

import "DPI-C" function string svt_vcap__get_traffic_profile_profile_name();

import "DPI-C" function string svt_vcap__get_traffic_profile_component();

import "DPI-C" function string svt_vcap__get_traffic_profile_protocol();
                                  
import "DPI-C" function int svt_vcap__get_traffic_profile_attr_count();

import "DPI-C" function int svt_vcap__get_traffic_profile_attr();

import "DPI-C" function string svt_vcap__get_traffic_profile_attr_name();

import "DPI-C" function string svt_vcap__get_traffic_profile_attr_value();

import "DPI-C" function int svt_vcap__get_traffic_resource_profile_count();

import "DPI-C" function int svt_vcap__get_traffic_resource_profile();

import "DPI-C" function string svt_vcap__get_traffic_resource_profile_path();

import "DPI-C" function int svt_vcap__get_traffic_resource_profile_attr_count();

import "DPI-C" function int svt_vcap__get_traffic_resource_profile_attr();

import "DPI-C" function string svt_vcap__get_traffic_resource_profile_attr_name();

import "DPI-C" function string svt_vcap__get_traffic_resource_profile_attr_value();

import "DPI-C" function int svt_vcap__get_synchronization_spec();

import "DPI-C" function int svt_vcap__get_synchronization_spec_input_event_count();

import "DPI-C" function int svt_vcap__get_synchronization_spec_input_event();
                                                   
import "DPI-C" function string svt_vcap__get_synchronization_spec_input_event_event_name();

import "DPI-C" function string svt_vcap__get_synchronization_spec_input_event_sequencer_name();

import "DPI-C" function string svt_vcap__get_synchronization_spec_input_event_traffic_profile_name();
                                                   
import "DPI-C" function int svt_vcap__get_synchronization_spec_output_event_count();

import "DPI-C" function int svt_vcap__get_synchronization_spec_output_event();
                                                   
import "DPI-C" function string svt_vcap__get_synchronization_spec_output_event_event_name();

import "DPI-C" function string svt_vcap__get_synchronization_spec_output_event_sequencer_name();

import "DPI-C" function string svt_vcap__get_synchronization_spec_output_event_traffic_profile_name();

import "DPI-C" function string svt_vcap__get_synchronization_spec_output_event_output_event_type();

import "DPI-C" function string svt_vcap__get_synchronization_spec_output_event_frame_size();

import "DPI-C" function string svt_vcap__get_synchronization_spec_output_event_frame_time();

// -----------------------------------------------------------------------------
/** @cond PRIVATE */

// =============================================================================
/**
 * Class for interfacing with the DPI code that reads an external VC VCAP 
 * test profile and incrementally returns the data specified by the test profile.
 */
class svt_vcap;

  // ****************************************************************************
  // Public Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Attempts to check out a VC VCAP license and read an XML file that 
   * defines a test profile.
   *
   * @param test_profile_path
   *   The path to the test profile XML file.  
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int analyze_test( input string test_profile_path );

  // ---------------------------------------------------------------------------
  /**
   * Returns the number of groups defined in the test profile.
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_group_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next group definition and returns the 
   * name of that group.  If there are no more groups, the method returns 0.
   *
   * @param group_name
   *   The name of the group.
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_group( output string group_name );

  // ---------------------------------------------------------------------------
  /**
   * Returns the number of sequencers specified for the current group.
   *
   * @return The number of sequencers.
   */
  extern static function int get_sequencer_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next sequencer definition for the current
   * group and returns the instance path specified for that sequencer.  If there
   * are no more sequencers, the method returns 0.
   *
   * @param inst_path
   *   The instance path of the sequencer.
   *
   * @param sequencer_name
   *   The name of the sequencer.
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_sequencer( output string inst_path,
                                            output string sequencer_name );

  // ---------------------------------------------------------------------------
  /**
   * Returns the number of resource profiles specified for the current sequencer.
   * Note that one or more resource profiles can be associated with a sequencer
   * OR resource profiles can be associated with each of the traffic profiles 
   * for a sequencer.
   *
   * @return The number of resource profiles.
   */
  extern static function int get_sequencer_resource_profile_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next resource profile for the current
   * sequencer and returns the path specified for that resource profile.  If 
   * there are no more resource profiles (or the resource profiles are defined
   * for each traffic profile), the method returns 0.
   *
   * @param path
   *   The path to the resource profile XML file.  
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_sequencer_resource_profile( output string path );
  
  // ---------------------------------------------------------------------------
  /**
   * Returns the number of attributes specified for the current resource profile
   * (for the current sequencer).
   *
   * @return The number of attributes.
   */
  extern static function int get_sequencer_resource_profile_attr_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next attribute for the current resource
   * profile (for the current sequencer) and returns the name and value of for
   * that attribute.  If there are no more attributes, the method returns 0.
   *
   * @param name
   *   The attribute name.
   *
   * @param value
   *   The attribute value.
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_sequencer_resource_profile_attr( output string name,
                                                                  output string value );

  // ---------------------------------------------------------------------------
  /**
   * Returns the number of traffic profiles specified for the current group.
   *
   * @return The number of traffic profiles.
   */
  extern static function int get_traffic_profile_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next traffic profile for the current
   * sequencer and returns general information about that traffic profile.  If 
   * there are no more traffic profiles, the method returns 0.
   *
   * @param path
   *   The path to the traffic profile XML file.  
   *
   * @param profile_name
   *   The name of the traffic profile.
   *
   * @param component
   *   The component type of the traffic profile (e.g. master or slave).
   *
   * @param protocol
   *   The protocol for the traffic profile (e.g. axi, ahb, apb or ocp).
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_traffic_profile( output string path,
                                                  output string profile_name,
                                                  output string component,
                                                  output string protocol );
                                  
  // ---------------------------------------------------------------------------
  /**
   * Returns the number of attributes specified for the current traffic profile
   * (for the current sequencer).
   *
   * @return The number of attributes.
   */
  extern static function int get_traffic_profile_attr_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next attribute for the current traffic
   * profile (for the current sequencer) and returns the name and value for
   * that attribute.  If there are no more attributes, the method returns 0.
   *
   * @param name
   *   The attribute name.
   *
   * @param value
   *   The attribute value.
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_traffic_profile_attr( output string name,
                                                       output string value );

  // ---------------------------------------------------------------------------
  /**
   * Returns the number of resource profiles specified for the current traffic
   * profile.  Note that one or more resource profiles can be associated with a
   * sequencer OR resource profiles can be associated with each of the traffic 
   * profiles for a sequencer.
   *
   * @return The number of resource profiles.
   */
  extern static function int get_traffic_resource_profile_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next resource profile for the current
   * traffic profile and returns the path specified for that resource profile.
   * If there are no more resource profiles, the method returns 0.
   *
   * @param path
   *   The path to the resource profile XML file.  
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_traffic_resource_profile( output string path );
  
  // ---------------------------------------------------------------------------
  /**
   * Returns the number of attributes specified for the current resource profile
   * (for the current traffic profile).
   *
   * @return The number of attributes.
   */
  extern static function int get_traffic_resource_profile_attr_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next attribute for the current resource
   * profile (for the current traffic profile) and returns the name and value 
   * for that attribute.  If there are no more attributes, the method returns 0.
   *
   * @param name
   *   The attribute name.
   *
   * @param value
   *   The attribute value.
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_traffic_resource_profile_attr( output string name, 
                                                                output string value );

  // ---------------------------------------------------------------------------
  /**
   * Moves the internal point to the synchronization specification for the 
   * current group and indicates whether or not a synchronization specification
   * is defined for that group.  If a synchronization specification is defined
   * for the current group, the function returns 1; if no synchronization 
   * specification is defined, the function returns 0.
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_synchronization_spec();
  
  // ---------------------------------------------------------------------------
  /**
   * Returns the number of input events specified for the current synchronization
   * specification (for the current group).
   *
   * @return The number of input events.
   */
  extern static function int get_synchronization_spec_input_event_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next input event for the current 
   * synchronization specification (for the current group) and returns info
   * for that input event.  If there are no more input events, the method 
   * returns 0.
   *
   * @param event_name
   *   The event name.
   *
   * @param sequencer_name
   *   The name of the sequencer with which the event is associated.
   *
   * @param traffic_profile_name
   *   The name of the traffic profile with which the event is associated.
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_synchronization_spec_input_event( output string event_name,
                                                                   output string sequencer_name,
                                                                   output string traffic_profile_name );
                                                   
  // ---------------------------------------------------------------------------
  /**
   * Returns the number of output events specified for the current synchronization
   * specification (for the current group).
   *
   * @return The number of output events.
   */
  extern static function int get_synchronization_spec_output_event_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Moves the internal pointer to the next output event for the current 
   * synchronization specification (for the current group) and returns info
   * for that output event.  If there are no more output events, the method 
   * returns 0.
   *
   * @param event_name
   *   The event name.
   *
   * @param sequencer_name
   *   The name of the sequencer with which the event is associated.
   *
   * @param traffic_profile_name
   *   The name of the traffic profile with which the event is associated.
   *
   * @param output_event_type
   *   The output event type (e.g. end_of_frame).
   *
   * @return The staus of the operation (1=success, 0=failure).
   */
  extern static function int get_synchronization_spec_output_event( output string event_name,
                                                                    output string sequencer_name,
                                                                    output string traffic_profile_name,
                                                                    output string output_event_type,
                                                                    output string frame_size,
                                                                    output string frame_time );

endclass

/** @endcond */

// -----------------------------------------------------------------------------
`protected
>0@MPU^A#^&N?KZcDVBNG2227<g2g)^HQAfPN?Nb2TZI7,0>EB9.7)@@<S/[399d
^]3a5g:Xa&/[?WB9cg4CR1N#33+[Z:\P^UI0+=6S3Tf_DOFYR_1S6(,QKO2-/V3-
?SRgBIBdD04NaG&<8@[(L<4TLI05>)Ze1G90Nb70YcP+74RR,IUOC5K022H,2?(N
CBDMB.g&/;.X7;MEG]QY(6AYDM?\,f@bAWVR:JYK-FN,NKfJfL1XX6QT^=L@QQ+5
g35].IA&<@E(;K3VU=EPML\BZAYCfK7afF4;;T\>FNO]C7KLgR_=&UY\@f@;A;gT
OU:6KCANQ+#aZ1TbW5_@L:[1>SIdU/KK-P?[@B&W7];3?@W7UeZCFA1TSB<d^)2O
9a:,+d<RM:^:JU+FJa[FJ709O4-YB7N,<Q]O3U<aMXMHT+2IEb7E+PJe#FLF_H7+
cY3_LNWX:aaA#d5ULY[04V9NA68aC1WRKY4^(dH#V^W;<0E>I4=g@8]:5e@GQTe/
A?6AMO(-2b#W]7f(Z1702X:XcI\5fS:RfQVb=/T-(J^6+<OZFEC5S2G6Eg3+bd0c
d_F(W.FED)eP6?gfS]3CbZg&[^V[NDT;&=2E-K-:ZbPZbN[X6YWJ&ddeFa)P>.H,
e4+@6O<9(-Ag:=&0@Z>)R\3Je2QSZDa#=0aOJ,\4=SL8E\R\b96c0?5^\9PK:K[D
K,);_6Y^TYU,1J[0,T;WZR_O[&2Re8;AIW,bKa(FSga6\Y;(AeXTMT7<a\Wa?+WW
4_a=dC@>,-AfaeI:SQ3NIY9M3<f8cD>/ZFQF5MWQg6.2I2-7K;+X8WJM=HNF>8:c
d.443@QP_O;X[G>99a5X.,Dg&5-1KS2TA0I]M16\B_BCZ?PUAX/^GWg),)NWf+-:
,b;c<gT\\CTM)=2AFe_[CC5?4D53BW2L)S.B9#BY;D6QII\TaMZ=:b8?eUS>98Rd
<1g7PbZC/IVa4N5aT,U.HOSVYAegTN/]#UFIgg7KF0Z?KNae5Da2K_b:4&][b<HZ
^.6Q(@X1N81aE0F9G,I^?6ZK3XFS,Qc\W#YcL_A<#-S>8KTgEL7.X6P/[190S2[b
DM/WHEOA-_7W3E:F4Ta3efG-c#PES&UO(7Q?3ZD:4J#Ia.^K+9RG,A=Oce32Z5_N
QJ#@R+/e0JM6YW0Q^#=d(C5eITaMP2/:>K>:@^CMBa=,GJ/&#LVD?5P@/\f[+U]6
)>59X+/)JK9Xff;XVcN#K,7;_,Fb4]SK-(KZGYY(VYBN@XYV/[3Q=@N2c51?3P.g
2bHR#5gR&U=LANK]fg)UF2PQZT#d#bDb-.aU<P08+B+K>3]D\UD[C+D>Wc9HHAMe
O0?69<4)R4CM8&69[RH-:E0+/T)Y4S8e.68X/DWBRG<+:.U+e7bC_V_,7I]/@D3;
C1[<A=+QefP]2Ob^LC9[gBW#bY@R@;P@G#/Dd^W&AB+eYUTcc5e8GRSV6#(#8a#D
GE&0d^8<A4C23U_d)T/\K2AS:WT,=cUKT3EBV/IGe0W4D[1ZATN0A;JL)7W::V;T
(NaE/dLeL,Iab7BQMRE+gQ(&L.R@(:5e+5a=14EXLL<25A/U4ITCE1BKK(UY&?3@
^ILcWP9\afCKE_K^EA@PP3I:5R;^VB4#HQ.T?WLJVWKCQe-eJXT^3b<c,#NK8_eT
O_T.WW-<a\aI#SD#P<,L&6cC:OaFN1@#.UN2V^=QFb^&TUbC+AQg?X0>I+\(3)-Q
9dfDQfGa17F<6D)^&XSg&[J0N<,/2(I8Zc/XU:;[#TUM\fGg+F&<^J192P-6(9[;
QS6I5?VH?]Bf0bZ],LY-#]EfVcS=-0?C.EQL2?9O58_bEcW<>fQbVD72fOgYd:M+
^=C.,T\bP^0S>ZYVReK)e@CI5>.J(4]Q-fd7R5>7CBc0,F=7J<f281)[+0DA-bWC
JO4PV?BR+:+1RKd1Eb2)AK7c)?]b4F(,MR&fXLeNPQ5-_Q:8E5S20[bL.d=I/]7G
96]3(?:c)S4&+21f:IRO7&G_&Eg[(Q\6^OKVGN:e;BXWJ+TeDK/>LM;2V,6W5S\J
Q0\.\7@.Z]<E28C43Q++\:SeZ3T^P<b6Q80=<KCC/]c0g97ATE[;E4,61d#:T(ZF
&KKQ)]-\+YOC8:BWVZW;ZE+<T1F,D)#+\S8g:O12JIRBg>T6O_XFc<1b8H&\ZO#2
EbP)U([[d8I0]3cEX89e5^a4Xcc<5&-1S,-OH0(507+C+E)9,c3(2S,5ZQQNZccb
e=,RWAA3+8]G<MA_b3O8IAc\UAfe@<Q39ZE:06Bc(0?gPL-4=(1<AP(6&9KG7X[3
L;NRZ(=&M^=5ICC<BXg,UF18(J..;.1OL6SI5++^M#I&2W)R>6@EG0S:[9,WB[^E
?JP-=BgTNG9[3+6&bSN/EVZQ2<HJ&V(:IOL.Zc0]?D[+a99##D\V_9bHFQX<V/P)
QC=X:Zf7MHUZHT#gSRf9MRVF-DGJ/IB<TTSGXI^?+d<f9_a<Z>^+<,=gbX8PTORb
J?VN[)c3/\.CNBNWcB?KcU,Yf__7QR=-<O;&ED4G9-60<[UgIKe<ed.ZN&]QV97[
g8CgUKWCg+_=a(VV;]KZ8<2fN-8XG?=THDQ>b]5G:e1U<W;fe6NIHg=J9UO:TRc]
E\M7/DMc\8D?<4IFe7P,79X\&gA:T1]5&BZ^F7DO.);-DC440_<c;_c<MFZ0-c4g
aYK7D+d2K;;c85>#FVfU^ZZY/F52^V8ETbH+:;V#fR(>#R=MR4aM;VOO3M>T-;(C
EYHe-L@\Q=^:a-_B4[M8K9I:VDH/2#fTX#c:G7Xc8gR+^d8#B<.H8(,=a.MZS#f<
FDKL74FcB/bS^e-Z3.:7#VP8g.Q/6&=\FG,A^AOI6TX7(3(&c6_YM2>]db^H8ZJR
HgXf7&K?G<SbR+JPY6Y3:d0<<A/@cTNO=4LT[NAY+XZc]fc[fGW#DSRg#A-_R:(M
H_bG7I7cR/Q?d+Bd((PXDUV@LC,7>=_@/_eKc)0/P,FddGc;g8,1]b\-2<_1,TBE
_>8.]8V;:W87&/WE4&O@f\,6-B72/.<HN;:KYe.>(KMO.NJg/#6.OH_/Y+WHEB#4
8ae8R=;?WAU+51?ZEDUeH:dDO@4@<+NQXeP_6C.ETGVf2YED[URBI22:]R#UUCGN
H6TVR8EV>1FG]:Ma,D]aSa9UB=.H?CUU/K-PF.E?R\H;2X131T[D:&9PaDRZc,L+
=Hg<eDUYbGG0+EB\>&@O)ZY[@b6&4O>^P(^4aHT##CO^b^&/X<fP:JN@=YPG.&[M
=aPI:4KQf^(I:g#Y?d#1@Y.VWE2df^<+64H7J2Ve(F2RV;aVJ&2aH854?dSaA97N
CC6E+PKUG>)X]O\gHZ5S3<\5G>b[0Te0^_=ZOCQ9IE_fN^1NIAD]Q<>I;Sc1=Jg5
UD:-#>EEX95Yf_f-6AB@JHMggYT(<50_]V:/5DI;+,288&?C;013H)Zg923,&7WT
bXX]NEL\\bWa-42aPaK:,A/LFNM2^D(,0#LeM(HIIg7)TI/U-ICa3HXV\R+FeW&H
d0L?SbgJN/AO6)LCE>/eSMd._L8:OECQf#Z\QC(-YK;?+:E&OMbI0f^P][8L9<bV
KeYE)e1&?a:e;<bJ\Z?-9/IQ4Y.HBU2fVRS=GWcE^6JbRUdB+62WDQ89I?)Jf]XR
D&cBa>R2c?7X37KLE13c6eaHOH1C>;f5Pcgbc,V,+;RM[I]Q_\fM7Qe&OMW]f/\]
6UI5(S6RNU]DF;dJGRRKS[JW8Z,I]A.d.c#[.C?AVBL[^6;1;d<_SUHF\3@SL9T6
3(Xf4/AAYIKB>DBB\23QYg?/L2@I::#U@@8CA0W^8?DSIc#>]H+?P3Q]71WHY(L(
CEH:(M):\=BM&87\QO8-_H9BMNOfc<3/+JQE.@CPL&?:CYG0.D[C[EP0aF)@?7a#
1JV1UPBeCH.,bf1=TZWX,ZcCA<-QDNOg/1XC8D]+=<cA2[2>&4F/?-bFeCCb.a^<
Y.SaOJ#g24J:/3?@b?K0A1W[FCZX:+WWO@6EFcSY#7R+d+_6BZd=EE]=)d?;+Ce[
_QB&WG@fOa]S3;&G&_8X1O#/TAVUA?&\4+#WXI8@;O;:4gG2J\4.4fQ(FOg7,BWK
?:+E;LOBf=WN/f<&P\7g;Y4fR[3VDH4-@1L/M.MO.6>6NDCTa2=VVXf[8-8^0U#a
->;;1WE@+0>NJ;T[]bJD]I;NJ[<9V590d7+5Z0FC]6.]?CJ?VMLeT5g[I96Af<]I
#/RR>NQ<RIH#]#FM7E:da:I40I_LSV7eQXZ4WVW30^2ZQV(BF#-BHbW/.\2@24BO
/JC5)H;8]579dL^7X14G:7X?Y+D]/bDb#J]H>fgLXH)_DfLG@,1FH&cO:8U<b[gE
H+J80Ube-(6_<5IQHL?W9)\_0+LC#^S;75RTO+c0/(<XJc\L,=[YHP_?USf#RC3A
g]U.eBM5+,?7D8D:WSNF#4K/G/[=>5U_O)^<Bb.>B.^Qdd]S<@,DcJ)cW]^dT>5X
,K^:X_,6C^ZGPUI65cIc_cKR\3ZJI4)4S8FDN-WUIXTd&M8G9>A-AX,4.(If81Xg
POR\IG\NKD2X=[\.\S><U<CQcH:?(&,22)21bEb4>IHT?XX?EPC1G0>A/^LE(DDJ
TS]H,7M/#L:M@JX;.=^3f0\OffcUGXFT:cV7b/068I<)9JAF]cf/I81LgBK5:+Tf
8(J9a<AcBID@J2,-RF2R62b>(FWe.J&>,f-YY1<^<Mb7\WTQ7(AV37]R,+UEJP//
[]FMR^3;f])SC-^O@@cNdB0ae5@f.E:#:VATgR8OBIE6RPIG=Q:@cA38Ba=.1.fX
MJdZI392A?gHeS1Z-cc=&I\_0.^VWKEI.a:,QNY517COBJ=((U0d\1&:+ZLK^0?0
aMQQH+?KM3M6/,<+0(@H8LN1(=]ED7W(^0TCJMBNIL4f)#?cQ9IVR\>J+[eMZ//a
YA92Yab:AIK0)SJD0;6?;HRY+Q+a,OXdUV7.6e6WE/\_LIaY,XdAM6g]?CJ32Q/0
WEG;0a\7U):MQ:-2a761;([=(I1;L@V9b-=C\IG?[+;-Y/G24AQWKDH#[LNO)fg0
4V&<?_D#@7C(]da_7-T4,A[c<6NF;7D&6X\D]W4A7Mb21X+K&MM4K6aMXfZ[65?g
/S--)@7Y..Yg^EFEX.FK(:dWG=QRZe2ggY9B<EHa?.AKO:KVW<C4OTg8gHdF@K@8
K_0IEA&.[GE@:e9YNfcd8J+D#F+4M7C)e&GBaO0VV3RD@M=F2>:Z:HN>;NK7=@H4
e\SS_Y(&<#;SP5_EM7g=PG\S(Y.XM&g6(7<NQ=>ENJeJ0Z3^T(4B#@Hd#M&e4JU9
OQYO;gDaXCV)4;^#/2#2V8OIbHc]L[]<MJ7[dUM<N:9cK>Q;Z2V:\Z>edga)N-HH
&:-..\,1E<b(9Z2J&Y=7=7TU\,fTOL#&QJ5Y1&GFE//S^^X=RYQM;cK-#&8E/>\Z
O7e0-FZOU:LQ#-[g:TRA^8W(Fd3>]/-+:MbCa4FK#cAQ\bX/fPM4MdaK?4@DRgJB
4739Gf,_2f.Xbg?R3ITQ@.-7gFFU)JEg72PL56GV:0YeJH(>^@;VA-D\7([P:FC=
SfWaB>KG3KeZPIf28QQHcGQ?E#.9V=McgBVVFTC[facd1[fMM;1:K>2GRQS=2^Ff
=269O-Q7bYb;.C=e?#<[4bZ0T0G<8.7NPWKY>f-1e9J=L\I4P4Z9^\TRR3X-W@Pc
d+?:2XZdA(>XZJ\..(D1==G97Wecf+K??,22,2V>?.]ORcWU,QNXB:dbSPDA[\JI
\JG;c2WC9U>4\3Ld+/_UG?WU<P\ZZ:\,cE4JQ>P\I.#VQ?-,Nc:gfb.3-7U/H9<6
aA>B,=GbUIAb-FE)PA4fO?b&>Ddc3,dfH^PDBB6PE[259dFHf?//a4MZZ9CA\f:)
FH(7UHQa[Te[e_#K[#@K5O]7Z]U3<CY5YW3F,+D^.4KA,WPN3/2E5;ZLX1LDHW=E
PN<<X?/700D:F@+P_A/d=V6^=25ZH7VD@F/YB5BZ__DR]&J&>X>&E;MdR(c[35-]
C,IaBZPW@3P(XYA1KU,+DG6JDK567-UfQaIcE2a.&2.FO1TIaL5aZ+bO26ecc<)a
F(:g]3F7Q:-OI\1SC@2/K__T-IX(F>Sb:]82-IbVMg)W6Me/8.R2@D^LbV[W-B=9
V?AMF,51>H=J.8UZ,A9W8OW1M2?a&)d\34D/U>@ed1c1c&CG9Z1SFSMUg-CV)G\&
O^FMDC3GCJf5_Q5\IfHLJV]:5G^WOR2\LQQ.f^@:U5N[GTH,G9:W\=(E9Ab:\D0D
#3S[Qe18U.3dR^-Bf:_50Eg^Rg_DMOK(/UfY;-W+fW;R<\P+D67DcT:H(C7.c8,C
DYBF8[H>QdNYCDG=FI2^5(=PY.WeJ.\#M1g@U>eZ3#]aK1LgHfMKEeaJQa=4(=O@
<ZIBM@OZg5NSO>C+I10.L4FH6([CPT.bfadWf@_+UEATUTXXFcS(.::_\Y.,d)3^
)(6;Yf;g>Q>)KH:ISZ9a2P0XN\^/7,;PJB<KK\B6C^DEW>>@V,0OAKB5HHIW@R6=
&4?b/+,4F\W+]FU<?TdZ^eF0UL]O/R?7Lb\WF@VI4fWW_QSY]AF=PfM5/.:])<aM
32Zb-b2XRU^(V.&D>(]XA==gZ5:V)+)eSYA]I^1@d:TF7AUFD0Ya7;FC>[RF^O\6
7JR??K:AA(d-d-eXHSP;2M(V1fAN0PH4gG<Z6-3+e\3U=a@?fSbZ\\8a,M6_I6DP
&#9E@PZJH7S5,LXYT>+ZXeZ.;6UgUdd&K.++><aWBD4AF)S1^RN:38I.d_@;WY\6
XM_fg@Q#)FbM-[)X^);:SRCV]VUAa=[7A])6+L0L+:gD8I(<\#WEERS5-c18Q:42
KMU>]7D\;<#W386];)Xe0<BaN#M=Z(+bEdR0>bZ.YMf+J).A9aDX.;G-BBT#ZE?N
2L[KGT4FQEg@dAbT6E0[F/&Q@@;FbJ].:T><9Xe#A39&G_b^MT.[#-O3270gMe<6
9e7:cPe7(W4agK8/B4O7dV8EdabCdU\D/>cJ755U@?e.gL0CDG;7WXNc\PE>FgVb
1E^WL6]UAG3LC@-OBH>3PggV9#.CdUZGGBZLe?R281V4&)OHa((\#UaEgV0(A^^L
^O+-f3SQ^Q^U&&WQ+UWE8d;e.65^gLNLSY;G-#(>\KQ^;\[\UXT)S0V:;J+]daE=
5,M/JDWO.#Y]#Y(-\OPG]X;\g1Z.75Ef\+II8]#25],#YEN)ES=GKBUIN6M9E8@?
9f63A2GSgA\AIT8EG+f]^[U7U]Y@,9AKOUY6c2)PM8MK2MQ1gag1)+/f=#IMbdA#
a35Ma)O\4[&3IIO4L8JP3E0X6RdfAU]+HFPH>8dI8=RHYCK5.C8KaZL/RWGVHaBJ
SVA+UK[EYeLG]#LH>FdL7A5._YH15+T@^WM9\5>X;A;4Z_(LE2#MNe:AF>F2H5c;
@[aZ\^V+.GaOS;B+\cAK[Ng@MLLgI:U1LeZKV7N>TGO^7^[W0)]777&)WQ/_D+a<
24;F;2^_d.<IWe0OQU0(X1TDI.B#^9\NF54;#OP(B-b5I<)U-Y8fa@;KZ^7U0)[8
c7,\.eMVW&7)aU&-@JeS+)D+^UH,Ua=JXS+(T@<Y;S[[dY>:<^LJ3JVVeHDWe:L(
,)\#HbdJg7CNX-/ZM0Y:S2B+0@(P-67P&@_(50Lg:);,:Fa+4dO1CL=@X2<>UF1W
CFb2FW-O(b9C^2:TGYa7W73M9<U1;:8,\g1+&@E4]KIJ]C_TZ7GgZ=X,ML?_,+?B
eDKX;@,FQEG7/PFU8UL@7O:V[W)F17KZEa++P&7995?YK>c#:@1B]VE2^F(+^A#)
^#GSHcdWQD>?e#C^1]-T/^e=QXOB:S/L(a1.dWX]6(?]QGcTJ9Ha><_)ZAg9f[a4
LP_\41HL0SE)FKA1GKD_b4?RbGCTYK&Ef4WdBT2GHX8?G91#5Sg4dRXf9^]3[A:1
be>\WFC2b4<+EZC>MB9a,Z^gQ,8a4K@1[,=<bAdM<cVA:PW>3F+A?ID#OV+DWa@:
G]GW/]4]T:_@J#;[GC3YaO8@&EB]bX3TU1,UYd_P.?X)_&7NM/,F\B)L>3)@\,X;
A]R?;3I]-0&3V_DeX>dQJ1A>baJO?&7DMZBK:WbS<,IRG&SfXID_;-fS8I^>O1QQ
7V4,:SO@74N]S<-.L5eQJG?)J114WVbeI#/^,<e7d:Q5Ecg#W7PG->4]R/cCASG<
/W.M2=f#_+I(c/e?P4L;b[(D).=,Y4R>A;=G5N^T+HH5aPW\VJ7&a6\>X,/B,K_;
1g9(M--O\eLU+=1e=Pc:8-^cOYg-A5[81B&4R4Q?4bcdN=27AI,TC#H;W6JdU<-A
QE2_5Lec7.:HW=EFW#dH>W)YdN7dS:a-5,WO(LWNOR-(Vc?W^/[WaZ.5+\[)adSP
P8Oe=)9/gfe0Xe(_[EYfX/Ra@OT[a_2UEN[C@<S9:(+#0b)E/85W,cbcQASD.?UT
X/JJR,RO-OWQIJFL[PFeIFTQ->c.=76[.PL_T)[=VNQ-&\&-A11SW:&WGa:g)1Ke
)W?552261)STb(fLe2\345EC1LGD9[^2@4LM]V]1Z:GAdH5BI<FF,HC+-),;MHH)
9B;g#3[A8-1G@PBKdMe66&5BSLfKHBBG=>f4L.&N>#AZUF/;MYM]1-4c)+(;5VJ\
3I=CXJZ\UAM]2^^H7L]^L#F(6YU2d0)D#[BOAdWI3Q^+BI4a]ZNd0V&&HRB(;@Hc
+SQ<cD5)T8&>9D=]6SPb397:Rf:Cc,>@GM3c(&KN-,B2J#7JZb<SV2e7#ZG\K[6#
:3QJ@\Sf?]>+PO8I(O9NSC,9W1TF-_,@Y,G1CS>&^bP(Xd<TMI.1QKHOX5N,C_Aa
c<FQ\\6UWb21\55Ne9@>ST3QZ=AX3;-dc=/OLE;E,>-S\NaHI[R@85,=:aabCZP2
W[?aW8K,X,3J[Ff3LRLTRVR^SNb5AZ:<R\VeKg.QRUYXC&\MaX:2<OD:/LM>,UK_
G-JSUR5C8AZ/5QG?/fD(c\W+aBW]&XRLR?KXI/UR/ALV#c<=Jg2\G\:-<&;eTR/:
8/eVN[)4c#g(;b6g5@S\23_Je9S9)T@9g,>&(CG-@R19KK-I8BcIATFCDUEgIPI-
:\>Cg_B,\IO54])ZK2M]K8D?6<YMOA/#G/OLM/L[bT[F7XeKfD[W_>XK?066/Me_
:^_[_<F#-HJY+287.J_#X/N3WA>XUP57G4V/Q8H@Q]-G)#C.KL@F@25FO5137H+H
71H<IeB4<<E+04K7,=X6.g-)]V;5D+:HBYJ&;_?)Og8:V)ec]V1Mg\S.B96cMUN+
0D\cQMdX[/W1</XL?4;<)C@eO;Y2[#)@GPf.gg(U3GZZ1#8.gBIg,E(M9bXVXG-Q
W#K:46S3&Z&(,Y>b-5-K;bD@Z>TDO^]NYJEZ\4B1TC(.)J_O97[&bS[,9<.#,GA=
G)GS;;QLEH8579Z]PW??-VSa8&-6B;=#:(].VMF1SLaX+=X@8T/<N_e_8b]9J;cF
e>)9F.GKIZ7+^NF=9<MC5>_\_K)WKf\\CU;/dV1JVX^T47)BW++>OLZ653I(WW-<
a1MSQ^ASMXLRK(AgLd2N[C:V<IW<a[GbMP^]#8RC&[5#G\8AI]_9N/P.>>)/JH=4
-a?]=[:BNHH^G&HL6E6A8:(MX.9Z5F.27d,0_X\dKg-C-7\]X@:<=V[(Q1^A\4B5
NG7A&/\9.H:_G1<c?Y_N?[^b9))5#7Z+8F9OJ(298dDCN\XCQdfEJ,H6X.3Qg5bS
9W1GDVMcW7.c[QE@9T9#51SPB3;FMCdOPa?cJVIG5Qa>Ue:U44710d9[JJYO--bb
PQ<5FE[dL3PO,5FXGeJFAHDVM@^LKf8eX0/0Fd+EX@I6<O=KZ9#D)T#VYNcSXXeM
dd76C#2^:;(BZ>F3B,&E>(-\MHD4.aR]>H_e(_1RTS:af7V<TNUGTU<dc-AR/\FO
0=L2X3fG_8>5#V(&NVTTdXT]1^>>]JM7I[\#8CbAJ12R3K46I^[VA[)b_&bFBbAT
&D&W/Z<Y_:=&_[X:;FGTAca/99[)GWfM9DB?,K)cX].aB<@a>9]#bRb#5UYJ#710
EM4XIb#fFD5#)@V6]FKF#2\1:W6.&?_?HQC@,JU.H126H7S@YM>dGM)H-[_4[5]#
-?Q:>_Ec_KD1Q/,@.\TZBT8RD-N#N^O1:E(&03)87c/^NEV8A.e;OI&=#:F>8S1J
2XVW9E+Y3G<8Ng<YH)=+b>W&NeK=2UV[WGUfN3/e--L,6_H1>T_YPGeSK<:+^IWc
J)RfM&[O)F\\+Y:./;6/0]Z8XTQV5NO@DBe,[G&;Tf_H2-P@J\7R52,<HcETQ\#b
Z3@/DHYU2bB,^K(I8ED.SCN8&W_C8&+K7R9U];be4_O=+,U-EVW#7=H)458;I/RG
3KX)8?YNF]2E=f65V?/6;[SeAb+YYPERe3>N\U93GI]X6(OZ9ETf922/EW_dC0Y1
EE9&/ce8@,#ed]S5>)T&d92-f6R;D^:+4R3O.CJbW+MU=ALeGK5JWIcU\b/Ue1I/
.AG5)HOc#AaEH?a0G8=/<&3@;AaINg8>?$
`endprotected

// -----------------------------------------------------------------------------

`endif // SVT_EXCLUDE_VCAP

`endif // GUARD_SVT_VCAP_SV
