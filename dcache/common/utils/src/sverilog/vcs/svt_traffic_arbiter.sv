//--------------------------------------------------------------------------
// COPYRIGHT (C) 2021 SYNOPSYS INC.
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

`ifndef GUARD_SVT_TRAFFIC_ARBITER_SV
`define GUARD_SVT_TRAFFIC_ARBITER_SV

/**
 * Traffic arbiter class that arbitrates between the traffic transactions 
 * that it retreives from the traffic profiles. This class calls the DPIs
 * that process the traffic profile xml files. The values returned by the DPIs
 * are used to populate svt_traffic_profile_transaction objects. When all
 * traffic profiles are retreived, the arbiter arbitrates between the traffic
 * transactions 
 */
class svt_traffic_arbiter extends svt_component;

  /** Event pool for all the input events across all traffic profiles */
  svt_event_pool input_event_pool;

  /** Event pool for all the output events across all traffic profiles */
  svt_event_pool output_event_pool;

`ifdef SVT_UVM_TECHNOLOGY
  /** Fifo into which traffic profile transactions are put */ 
  uvm_tlm_fifo#(svt_traffic_profile_transaction)  traffic_profile_fifo;
`elsif SVT_OVM_TECHNOLOGY
  tlm_fifo#(svt_traffic_profile_transaction) traffic_profile_fifo;
`else
   // Currently does not support VMM 
`endif

  /** Queue with profiles of current group */
  protected svt_traffic_profile_transaction curr_group_xact_q[$];

  /** Queue of write fifo rate control configs */
  protected svt_fifo_rate_control_configuration write_fifo_rate_control_configs[$];

  /** Queue of read fifo rate control configs */
  protected svt_fifo_rate_control_configuration read_fifo_rate_control_configs[$];

  /** Queue of traffic profile transactions from all components */
  protected svt_traffic_profile_transaction traffic_q[$];

  /** Wrapper for calls to DPI implementation of VCAP methods */
  local static svt_vcap vcap_dpi_wrapper;

  `svt_xvm_component_utils(svt_traffic_arbiter)

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new component instance, passing the appropriate argument
   * values to the uvm_component parent class.
   *
   * @param name Instance name
   * 
   * @param parent Handle to the hierarchical parent
   */
  extern function new(string name = "svt_traffic_arbiter", `SVT_XVM(component) parent = null);

  // ---------------------------------------------------------------------------
`ifdef SVT_UVM_TECHNOLOGY
  /** UVM build phase */
  extern virtual function void build_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  /** OVM build phase */
  extern virtual function void build();
`endif

  // ---------------------------------------------------------------------------
`ifdef SVT_UVM_TECHNOLOGY
  /** UVM run phase */
  extern virtual task run_phase(uvm_phase phase);
`elsif SVT_OVM_TECHNOLOGY
  /** OVM run phase */
  extern virtual task run();
`endif

  // ---------------------------------------------------------------------------
  /** Gets the handle to the VCAP DPI wrapper */
  extern function svt_vcap get_vcap_dpi_wrapper();

  // ---------------------------------------------------------------------------
  /** Gets traffic transactions through DPI 
   * The DPI gets the inputs as a byte stream from the traffic profile file
   * The byte stream is unpacked into traffic profile, synchronization and fifo control information
   */
  extern task get_traffic_transactions();

  // ---------------------------------------------------------------------------
  /** 
   * Adds synchronization data to the traffic profile transaction 
   * @param xact The traffic profile transaction to which synchronization data must be added
   * @param group_name The group to which this traffic profile transaction belongs
   * @param group_seq_number The group sequence number corresponding to the group to which this class belongs 
   */
  extern task add_synchronization_data(svt_traffic_profile_transaction xact,string group_name, int group_seq_number);

  // ---------------------------------------------------------------------------
  /** Starts traffic based on the received traffic profile transactions 
   * Send traffic profile objects to the layering sequence
   * Traffic transactions are sent in groups. One group is sent
   * after all xacts of the previous group is complete.
   * 1. Get traffic objects with the current group sequence number,
   * basically get all the objects within a group
   * 2. Send transactions and wait until all transactions of that group end
   * 3. Repeat the process for the next group
   */
  extern task svt_start_traffic();

  // ---------------------------------------------------------------------------
  /** 
   * Tracks the output event corresponding to ev_str 
   * Wait for an output event to be triggered on a transaction
   * When it triggers, get a list of transactions which has the same
   * event as an input event (ie, these transactions wait on the event before 
   * they get started)
   * @param ev_str The string corresponding to the output event on which this task must wait
   * @param xact The transaction on which tracking of output event must be done
   */
  extern task track_output_event(string ev_str, svt_traffic_profile_transaction xact);

  // ---------------------------------------------------------------------------
  /** 
   * Gets the xacts with the event corresponding to ev_str as an input event 
   * @param ev_str The string corresponding to the input event
   * @param input_xact_for_output_event_q The list of transactions which have ev_str as an input event
   */
  extern function void get_input_xacts_for_output_event(string ev_str, output svt_traffic_profile_transaction input_xact_for_output_event_q[$]);

  // ---------------------------------------------------------------------------
  /** 
   * Sends traffic transaction 
   * @param xact Handle to the transaction that must be sent
   * @param item_done Indicates that the transaction is put into the output FIFO
   */
  extern task send_traffic_transaction(svt_traffic_profile_transaction xact, ref bit item_done);

  // ---------------------------------------------------------------------------
  /** Waits for any of the input events in the transaction to be triggered */
  extern task wait_for_input_event(svt_traffic_profile_transaction xact);

  // ---------------------------------------------------------------------------
  /** 
   * Gets the WRITE FIFO rate control configuration with a given group_seq_number 
   * @param group_seq_number The group sequence number for which the WRITE FIFO rate control configurations must be retreived
   * @param rate_control_configs The list of WRITE FIFO rate control configurations corresponding to the group sequence number
   */
  extern function bit get_write_fifo_rate_control_configs(int group_seq_number, output svt_fifo_rate_control_configuration rate_control_configs[$]);

  // ---------------------------------------------------------------------------
  /** 
   * Gets the READ FIFO rate control configuration with a given group_seq_number 
   * @param group_seq_number The group sequence number for which the READ FIFO rate control configurations must be retreived
   * @param rate_control_configs The list of WRITE FIFO rate control configurations corresponding to the group sequence number
   */
  extern function bit get_read_fifo_rate_control_configs(int group_seq_number, output svt_fifo_rate_control_configuration rate_control_configs[$]);
  // ---------------------------------------------------------------------------

  /**
   * Gets the resource profiles corresponding to a sequencer and adds it to the internal data structure
   * @param group_seq_number The sequence number corresponding to the group of this sequencer
   * @param group_name The name of the group corresponding to the sequencer
   * @param sequencer_full_name The full name of the sequencer 
   * @param sequencer_name The name of the sequencer 
   */
  extern virtual task get_resource_profiles_of_sequencer(int group_seq_number, string group_name, string sequencer_full_name, string sequencer_name);

  // ---------------------------------------------------------------------------
  /**
   * Gets the traffic profiles corresponding to a sequencer and adds it to the interal data structure
   * @param group_seq_number The sequence number corresponding to the group of this sequencer
   * @param group_name The name of the group corresponding to the sequencer
   * @param sequencer_full_name The full name of the sequencer 
   * @param sequencer_name The name of the sequencer 
   */
  extern virtual task get_traffic_profiles_of_sequencer(int group_seq_number, string group_name, string sequencer_full_name, string sequencer_name);

  // ---------------------------------------------------------------------------
  /**
   * Gets the synchronisation profile corresponding to a group
   * @param group_seq_number The sequence number corresponding to the group of this sequencer
   * @param group_name The name of the group corresponding to the sequencer
   */
  extern virtual task get_group_synchronisation_spec(int group_seq_number, string group_name);

  //---------------------------------------------------------------------------------------
  /**
   * Gets the name of the current group
   * @param group_name Name of the current group
   * @output Returns 0 if there are no more groups to retreive, else returns 1
   */
  extern virtual function int get_group(output string group_name);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the name of the current sequencer 
   * @param inst_path Name of the instance to the current sequencer 
   * @param sequencer_name Name of the current sequencer
   * @output Returns 0 if there are no more sequencers to retreive, else returns 1
   */
  extern virtual function int get_sequencer(output string inst_path, output string sequencer_name);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the name of the current sequencer resource profile
   * @param path Name of the path to the current resource profile 
   * @output Returns 0 if there are no more sequencer profiles to retreive, else returns 1
   */
  extern virtual function int get_sequencer_resource_profile(output string path);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the total number of attributes to be retreived from the current
   * sequencer profile. 
   * @output Returns the number of attributes in the current sequencer profile 
   */
  extern virtual function int get_sequencer_resource_profile_attr_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the next name-value pair from the sequencer resource profile 
   * @param rate_cfg Handle to the resource profile configuration
   * @param name Name of the resource profile attribute
   * @param value The value retreived for the resource profile attribute
   * @output Returns 0 if there are no more values to be retreived, else returns 1. 
   */
  extern virtual function int get_sequencer_resource_profile_attr(svt_fifo_rate_control_configuration rate_cfg, output string name, output bit[1023:0] value);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the next traffic profile
   * @param path Path to the traffic profile
   * @param profile_name Name of the traffic profile
   * @param component The sequencer corresponding to the traffic profile
   * @param protocol The protocol corresponding to the profile
   */
  extern virtual function int get_traffic_profile(output string path, output string profile_name, output string component, output string protocol);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the total number of attributes to be retreived from the
   * current traffic profile.
   * @output Returns the number of attributes in the current traffic profile 
   */
  extern virtual function int get_traffic_profile_attr_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the next name-value pair from the traffic profile 
   * @output Returns 0 if there are no more values to be retreived, else returns 1. 
   */
  extern virtual function int get_traffic_profile_attr(svt_traffic_profile_transaction xact, output string name, output bit[1023:0] value);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the next traffic resource profile
   * @param path Path to the traffic resource profile
   * @output Returns 0 if there are no more profiles to be retreived, else returns 1. 
   */
  extern virtual function int get_traffic_resource_profile(output string path);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the total number of attributes to be retreived from the
   * current traffic resource profile.
   * @output Returns the number of attributes in the current traffic resource profile 
   */
  extern virtual function int get_traffic_resource_profile_attr_count();
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the next name-value pair from the traffic resource profile 
   * @output Returns 0 if there are no more values to be retreived, else returns 1. 
   */
  extern virtual function int get_traffic_resource_profile_attr(svt_traffic_profile_transaction xact, output string name, output bit[1023:0] value);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the next synchronization spec 
   * @output Returns 0 if there are no more synchronization specs to be retreived, else returns 1. 
   */
  extern virtual function int get_synchronization_spec();
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the synchronization spec input events
   * @param event_name Name of the event
   * @param sequencer_name Name of the sequencer corresponding to the event
   * @param traffic_profile_name Name of the traffic profile corresponding to the event
   */
  extern virtual function int get_synchronization_spec_input_event(output string event_name,
                                                                   output string sequencer_name,
                                                                   output string traffic_profile_name);
  
  // ---------------------------------------------------------------------------
  /**
   * Gets the synchronization spec output events
   * @param event_name Name of the event
   * @param sequencer_name Name of the sequencer corresponding to the event
   * @param traffic_profile_name Name of the traffic profile corresponding to the event
   * @param output_event_type Indicates type of the output event.
   */
  extern virtual function int get_synchronization_spec_output_event(output string event_name,
                                                                    output string sequencer_name,
                                                                    output string traffic_profile_name,
                                                                    output string output_event_type,
                                                                    output string frame_size,
                                                                    output string frame_time);
  //---------------------------------------------------------------------------------------
  /**
   * Creates the correct type of protocol transaction based on the
   * protocol field argument
   * @param protocol String indicating the protocol
   * @output New transaction handle of type corresponding to protocol
   */
  extern virtual function svt_traffic_profile_transaction create_traffic_profile_transaction(string protocol);

  //---------------------------------------------------------------------------------------
endclass

//==============================================================================

`protected
LVa_PZD\Q(?4=gZ-\dR\YWQV1SF-..K5XY=f]E^U?f#a-(2KSHAe-)JW]YGANM6)
b9+QHK9/f8#^<d;OGd1Q?R,GKY,IJ8OVFZFZ/YD-IEQ(d(-M\7VI)YA&CD6>Kcb>
>5H,6(+SS,1_OT^KZ?).Y8]V+2dYXg?ALW>+V_H,/+GMI1@B2>(&_=gV=XgW4d:.
GEZFHFJ&g#@#C-a.VM.^>PReYX^0a6g6IXQR6CfF4P_,A5R/N2=eM/^X9[>VL@,Z
H<X>^d7eE+U9EO5BgP_0\G^D/XbG)EY(QecV-8K:W9Te:a0DT-8VR@5M@/eZ:b)9
3E[4ICOCP:A1+RKN,dV_J7YE+:OT7PZ#;&RQ9f.9:7/AeKQ,]1:4?6;#=(,C5-=R
Q?MJU:c&8U=#5[6E7+526CN=V>_Ef3T+cSe?M>3#O^g.-<3:1#?YYSL7E/LQ]#3\
21VZ:S)H7UMSf^H[AUggC]E;fX/2_L22EM:DDYW?5fEQV?aI]?<BbcSQY.Fg5GcK
bd8@0Nd;/V.fER(a:BMOd6K_9@&)dECfP-aR-1.Y?4BcXM2,Re3N3d/]2H&@.Z6-
.Uaa-8(J3.dg>BP<_H<B1&L/dW0^?:,__^Q;W(V=&U[Y>6620AJC95:>LBbU5@_b
)KU=>X]JDeH^<QD;9WBCN)eWEa]BZc@>4D=[8)#BPdcJ_2V]TfJ^Yc],HI6#@#U5
_H+Y([:M_KZ>Pc?GUR-cO7_2W1B;E4BC7\&#PC)BFc6<QL]b,:JIb4>(d(;/OP)\
bN=c5\>8BD@9bX?VN,<8cOM1(XaM0\0[7I1RU+\>0Le&A6+UFPRb-L^fFDgD6UNg
2QYE)<+_7[^D-:4N2Wc]5gR.+N[BT7QEJKLL(e\Y=<82(744\<Z#IXN832E3D?5E
;)S@G?+&@fVf@1/G#+F>b38e/f-#,3-&(\D(HMW\@+65LH1BG_86Q@RTG(2MX.SW
bd@X69Cg7aS?8LJO3T[:)g_WR[IAZVI4YC&U&W4BAb0eFS6,YePK5256?QcJX=#4
VdA4CT?XMa,]#G;[C-eNV3#D4FB-5Ef6DIa.IaNMQW-#EUaA>UO93QG_bZ7K#B(N
e>V9e):X_4?FYTWVMSa6]]<eWfA8QH-R>:-6;@B3TI\UUM;U/f4=863T49Ff+W-E
NSe6e7ZXM(c<\(aH5HG5<<AYRH;@<.8gF37QM(T^GO<c<SS8EG?28Z_7FdLO4BBZ
W,P4]>FXDMKG.dIgLcB4FeV<K-6XESgXeX0@JaZe[;gZ&LH6I;VdHeLAUA1_Ec3,
9#R)a/SBS.X.V_D6:>0\?E1XBCSKe.Af,H@,2FHV9&49\/bI1NZYDNH#5Q/7&H)2
<dE+TL\XdC#1EO?e;1#Z9]bC<aZ6)He)DKYH\LRffHD<A[GMWbS:_a=2,O)B5U#W
g\:@:JIT)+ST6A0O@5N25XZ>BNa,K7T^cb#ce=#JL6-5\M8WEIg7T0>O:K60X3TI
@:bW90W?Z@EeT7C7.6^67a8bV(#DY9_9L8,G0BV2[JTU:;VbVK:IH#Q+^Z=#&0H-
=,:T1-,MG8IQ=[EH,6PULR([G0BTS4fVM]a@W0EG3CPA>DFRbb,B3.F)T#6@:8)-
^L46&:_1G8FP2M1UGd6Nbg?+_S]dE(?a_=RSX?-8OVQ=Bg]EW@C+f7O70bd3eWD#
YX+JO@<06aBe]@;6J4Uf4:cU<G(c,^)W(e.b;EDM.+MRZIa[_NO#?2S);/;=bTc&
eW1&&We?cT0E?];TfX_D,VZHI#.g5GLX]KDgP),>1K,<WI-PJAW-]O5<Y_82DDXF
WeYW+:WTd8&/KI:JK#0S8cIa))X[:B)6YAM5+dL-(8Kcd\C8#M)1f>(N;Tc]+2FK
A&P^<)9TUAbK(^[:O9RAD476.7B@,<A=U<]./P6MX_9FCZ0afbA@O8EQ\IZ;(E@E
gWbdX-Z4JUW1/aK4S^;eYdU4]J>)IT0c8Wf9DbZ[NIgQ)@;6)WD:#g:M^>[2PE)&
U@Ke_[4YScZ5?/_:LJKJ(LQWWD5ZBbfPC0YFT4,f)G>2cO0:<[#:DY?)U3XB&UJb
TNX#)J\5[dOd2,(1]Z4+,B&R9JTSd3[MfXNE0<eLDT6a-f??7D03K>RJ856d?L8b
6DL;5CR7<E<Tb;5Y&1\F/K2bU7a\8B+d?P=H9BZ.2SC)PKJ77?,Ub2T.b.c7)\G(
+?,Q61V)eN]RFJUT]>N?I_@,6F0:.WV=_CCb>IP=PZHK7M\3.HUVgAD3_80T^9))
,TBYgW&-G,g^Vf>HN[H&JCI>FCGIDT=[I/G6CU@f.E.T1cQAN<#g?4]PD.C8,\d9
9)6g#+VAdKA,8>a1Z-3FCZG&:-dHUKL>^Z-UV#:LL?MXYCAeYKU5V4Pb<)a]M1gL
0,=WND[3G1\-6=gJ(>)7e(D/YDb3U,58WJ8N+6NJYLS.-4f7Qf-_J3Ze/T:=RaIB
YXNdHEH-)=D=O6#M^B+00JU.6=.5^K\V16gYGb\W>2#+=B.>+])U]:J9aA9F;25D
\7+QC=#6@YAVSGaB<4FcFecgU+SZ],^5KecNSS4U0UORfGS,.(JQ0Z]]J+JG86]E
<#[^\9I3dR9+LRDP;]NL7WJS8G7bP^OC\[M,864\MEKR._UB#OYdEOD^1^)cZL7b
;),/U.<NTD/G[A2,@gLDDTcWF:TOGY;N,L=M52J8OY.QK],7/E8e\?]31UUU)M4D
F]9fXGPf];N5NFTdLWCL+P/3R\3^=TZ[Ie3:,HJeRZ9Dd4=_[;NMP6D8V_&<1ZF0
G=BC5(=7_ON&bN./#e<(GK,X?4A?+XFa=MA)SZgfE>R\#Ed6dN;:1PQ<-W=NJ[+)
dP#N8TaP-F9EId-L^T==_35@O5,M[35#4T:QJ/dJ68X<\@a^G>6&N]U>ecdAR7@5
IUO]74fLL=b9:>A.Q>Z^Q+&0R0W/)]-:NK\O]DICW(UMJD1AH0,bXOcA(_VNR5)4
)<aF>(<Q##H6OQ[W:K7]KRd1QEcX_fI(bC=YOXAE1WP(FQ)dUNgJ858)>#W_<1dQ
:9GU)_+/G>\65O:BDY2#6IKB@;HA-Z^J1S,#FV/3b>)D^00-4c]Z-B)gK7=CPTCD
HZ/?-SKRZR_IgF(C]U\aJ5\K<-==\YI>(H-7/ZfO2QR>Y7=Z0Y+)F2G,3;DR6H1R
1+J11IH^g46Xf#UU=+/aad4=&[d^XB<5BV80caN:\Y:CL#d8IQ0Qc\:\O^2JJ)O]
OZ]>DYRBWVOAe0_C(D^eI/2KfX7:;&;d2_(P?43Eb&>M7Z[^\(CQEGV]3;<.Cf6I
^__)8F_eTNE)7#Za0+N3^E5Z-aSbSN=G/G92D\N.Y,,<dXS0b0JR?6R2\/<TU2&J
5:-U&G+&D2?TfWF)5VU+d,FGa9]\[7O[1L4><NN(a3Y?Q;MMWT@/74E4<+9X8OFM
KH87#[eJe;;(dbY[1>g2e5]A0:H(/M:aAIY=4/C2+2T;5e3cB06=3LB?8IC2S<b/
#c?YF]8HFKXV1X5>IfKKF713S-_>/&P^#C+VX0VScF9]MQQTS;L8ABXdEL:+MbEb
8A_-ZM^bd\Md@?74?K[L[#+9\+6QLd[]4Sa<>B@N3R<C4)c1]QZcF4UNG2Z5#.e,
E#<SI-HF/+ZI[TX5U#I?\S4,WG.DSWIDZ/4TL/4&0LHQc#T7_>G./?+e@3-W#_GQ
(B?Q\\5<cR?&3J;<7Jg8fU@&;V#gbc3_9)L>WPa.V-M_;+c.S:[EI3K7;TAI;ga(
GN.,IZI&O)03]2R9;YS6-IQ&bOMRZc^+Z7,9U)P=]B[8].0U&b/AS+\KOffLQ8b&
B[M)gO+8PQ4><M5gFUa&[Z.<2(,S0#;:BgU59)DC6V7f;#[4><<[BR4@6M=A50DU
3,^0?gT4c100_PXTHGS+faa6B--W1102RONdZ=bT-S&Z6S_;P-QK(QP:e>-JIO;)
Bb^e.V#:/]@IUV?T4/KbM1(WZ)\+5C,:N_J+LdJW;a(#Y&NLLba).#EfDDd/X8=8
D,>HTZXY1KCg&=#83;AMX#dCeSZ0N&Uf&<..Le8d8APE7B,?3LMQ6JG-<;F_7#=F
C^H(08P0g37If6YeV?,E>7XO@31DH1A1e&_+:Y?[#fH]ODSXG_?\gg;,98U2JG/\
.gP7Tc>9D3;8>5Y]UbFDZ(W_>f:J<I1GT]@#UHTg[G&47HS9CCPTBWcd6Z8.OJgV
HaQK>P(3&M2]cgY.F25fbfLF7:=0d??G]S51]P&G3a;3,B9=<2+ZM^TETfG=OO\Q
//^\#A6e5./(;=e.47AdA]B)LPeZK.TKW,H#[b+25^#/OB(0M:V9\[HSTR?DO,P#
;DX8CL[]Hdd8Ge92=7:7])E]>]9,/.IeQE]I[EbI),U?[\#-(APD=40GB8ObPVR5
0W\1._4afM<YgMVR[-H[8EPg8&aNEEF-:X,]OV?]NGAZO[IDPVegXM<F>@;S<^0<
K?J#1V,OER;9,@D^N8LUeK+V][YXgbX.7fHW+J4We:I4FF(WB/EC++P.-&3\5:=H
>1eSUS;GY1e8-Qa<,cD,PdJ^1/HSIHG),NX]X0,0\c[XagYICbQbMW=dRD-=d,V<
K4fBU;IU\+/ZEga\7\:,0]0(O,9XDYFLOK8H8Mb+<:KL_ZW6+ZJ-7#MXdfN(/A7R
&I<_/0H7]2EF>2;gad5?5Ea(TWN1>,3I2-_NZUO[E.)MM2HIM=E[<NA,X&VfgQ[N
IK3J(4,3d=71>^7g1g+ALB/Ye:J-4C<<ZLIT]OC]-#+NN+WbI<I.E-g[CUB#LA<E
UJ\&-a8AOad_OgcY8]?;;.Z(C5+\^2EFG>HE77f]?^O&9=4X>[#ZOSSJ.b2UW2KE
()_dgWLD(99#5I5F>#T6Y(e>2H]0D1T&.FE,,PHLV]I43E@@8U1&H?&HNNgX3XDR
3cB.f]IdO[cgIYLE^SZ>/OR5HUDWV@0+NS]73K^3=E,A/8IB=1;E:1F:DSBFYCEK
^4F1.0(R&,S2+3-,P@O@59Z3PH4+8?MYM\+Sd#>O9bM+&3>T;4[7#4LOcf>;UL(0
74QPDMefLHMKMB-[RcfcZE.\TdG?_C=3c>T/-X?G;]c+Sg[I#/1fVJ]c,_\I575Z
-(4[:1N7>03V(AMA+G7C5^>KbD67I52+BZ#Z:Cb<_?Le1>I&CJA(>(=_IJ5=YZ6&
=b_GCK5,?[f]DSaaL7HCZ.I2TLV@dV99U@<(10FLK#gO-M_YC=>&=]7[?YK?5dZP
O[R@X9&)Z/_B64AacXSa1.1e]4>4)?E<DLKeI#_R7,:>c.IRZ5P4)ZfEF5X59V=N
+^D09g1DQR1QW#=VRYOK0MCR9G0Rbg(^0[<GG^RU[VL94EVW)UDd+We@[9e<3/-8
M#GIGaYX>Ma#=<^AEAR?0)54&X=54V#1==efdXOU>TT-_()&E7)2KF<F>_^\c:Xa
@VZb1V,ACd;eIU55)J[bO>_JNd_SO-f:DWM[R(:E-W2+>__OfWHS:g>4C4<I0TDJ
B(BENWH38CA\-FK<?1/C].-b>7dYUa-dEE6HWEf^1CSF(,,U)Y>DaF@DAOZg6_1g
S/_G[+.A_Jbc/.ZcEcf&J7L[D:(WdRRIM2Xb.ZaRRbg@W:#=J0T\9cAZg#1-R@c?
J5XX\XVJF;5:Wf3<d1JK,FNg:#W/edD-)#2W,5-X5,fdM).eM@deXVFLVVNAR=,P
W#&01]S2S+cc(;1SB,.g2I)L&2bc^dSLS+U]JB@:U+-2@Qb_(MAeK[#/G?\dMe^=
VHR+WX>-g6c,V8D:?M(48<JBQPPO)1A&A@^\g.H#TSAU[\,-ZTQU;7KG^+M_c=;V
]#MFP+,>@UK<Cd;J-)7<Q#IBDUZ03?T<)+@(^(@f8RWXJd\YAZ+3]#WKP5T1:d-Q
>4\_0=<GPMO-&TY:3C?f>_72D^C&]\IcKR0c#8QL&UW)cM7L;_4.g\GHB4aA[CX<
7=CVc1]FAXfUMb-=:XD,K50;bIWd-ISYI=,D>UT\[ScHUUgKf;:fU(^4G2OBRZLV
:LO_X>?,<O.[#V]YW@8HZ/ZAK:(P#gFe63VEJLBJBBd&[\(N-;I=Y]9&)MbS60_B
7b]6T[GRIHT0WCf#FSC-DgTB1V;BN4J>Jb+?MS?@UD6(fW8\K+\a),Q&8LUb9^c+
V6L+@17@5^L/J?O45BT>+#3K\f4PgCa-N9KF,2=VY=cG;7P\_@N&)SV+d+9fV6]b
RA+JKg-7YK)QV)Q-SJ(><TbBP^a9Uf846WQN<Z6NT^1D;de&/I;+d)\&bP0MK/K-
/#./5<UIU##:KIaUI:Z-c(C655]4Xb<XET2I341;#/V_7&Cc5\=E6&(.Y&,P\UMX
CL[[?8D<T(5Pb.9)87SeMH)]1G-d_&<;8;^PFC:9eDGFYZ[NCbYV.75:=1EN8Va^
E^1U[]9+YJUFR6b@D&CG?M9ZYTXPd7O;AHU3\ce4eH)HNUCI6?@a;J?V;[(YLR)]
fH1?0-e#1=SdKV&W1CU9[FB<]K15:NK<4M2E=V4.E71Na7IRW<[.LTe<A[_9bC1T
cN&QBNCO2c?GKX81.7.&?B_-\WUM0.C(@F:X4M+/Kf<;C6B#]X)=4UT/^-cZ0UZ?
a0c9=aNF9-/Ef)QFAFb=I.eSV;-S.\_#<#VLFW&;FNI<17Q<;gBc\)cT8c<AMe>.
EXY<((X4f,aHH-.L6=MNIV(T\O[T(KY+9PDS96==S>dC7.=BPV\>K#6e5ZI_B9T(
aZ5M66BbCX4CVC)947T5H_dgO:X9ga38I),[4D^+Q+#EA20dd)&IA#QP&<?F1\+X
V_#OCKQP-:]#UAZK]>7Q^,B@RZ/TMOeHAWQ]D[f;Xe?HR)H:1P)4a)4HK+7A]dA^
H_Abf]I#/&23:J=RJM3A@Rd+aSTB=N:CBCe?S9Re,7SX@=3ABOB?ACJ(/BZbY+?+
B,_2L)bM4C_NDeYW\KS#Ac:2@Y52G,?OI)>QWKWb.TSSZc8.Dd2.&]ZA1R3)6__;
ZMA#fFbIP:.868R+1]D8?;+-.C+0\5(TW@A?CDX+YFBW.53>BR5J.R=J8W7=@JV-
(B\bHa(NZg]T4E;aX?W/<,UIZ8&/KSW;_cUI3V^a61?H;LUEM_U<D8A\#3,Z3M\e
//#\M,JRN\[@DKX-IC-RCfH#TIO^N.LJcX4ROW]GBU?6+KD#,Z/MS+8N7B#\E&>M
)AE3e_Z&/3gMAR?e=2D01+;dHH9L=I>4Q/e<FBF:^E=75QDEO<Bf)[cU,6H6>7R2
6Y>>\@YQ6gB68F1@M:F662/HSLLC@Z,1SXCC_U2>EaVC&^V@XQX:(G:IH5DMDT=P
NG>AW/Z4BfN039H7V86bf]F.PUCfM6@T/>cX>3aV3V.E?:4_R??eS7P::L&B>O.)
\eT&@#SAJ4g2>#bVTLR?dD(FMN]MY<7\,=,b+I-EK>)TN<TDZ1cPE;PW/FC=3<T3
P#W0I5CLTP]Gb&0JRbF@=.6)][_9bPJB?BAW7WHFAdCFbc;_0D8&Qg\++)QVX32>
;a5B@X)ZD4e/Qg5O6?^V3,6db4MQf9S[Y]Xc9,RA)>&SLGBI4C(U\/dad?@V;R@e
DV4Pg=?K)K-Xf60X273b)W+=8F,;\aa5MZS4H^gN?)3R<]^BVA@CZNN-EA,S-8UO
BB5\/>YcFWb+,.NT;ZY@\,2:MeF/N>QMA.9/df8P?;]VS/?d[=aDBG:2L3#5E+NO
J6^ZG6(XNFHd:.)-O>DP2:VP-4[XHF1EN4[RZ2_0R5IXbV4dacU:)@)J6I0:[=UJ
eK-MC8O5LZ+KVIWVT^,K;U:UDADD,1[R0_Yf=Z-G1=.6[(BXUYaZa\N_M1-FeVT:
)0)E9ef9_-\Z7W?9,c+cK@,V3^:)f&,fdY?:Q/b^cNKW@PA)CSHe9E@<P7DgaG4.
aBfX>0JgB.G/<@0[#&P0(L_e7#RS1BC6Yd:;BJ\EZ@))(A.II\(b)d63Qa9HQ1@M
LT:J:eL#/_K]?AE:0Y;IZR&K.6KR[N/?5]-J=L9.JTD)M)e.0S6^\IYOZ.[_,B+F
Ac_QL[L2,4M>VMN3I)#IG^78FDcNd?2MA9e7JccYGZS#cP=P;5&5++LfO1-IX5]Y
O]HL8SK>ACZ<Y,+e.gO.\e3E3P,87AD6FWN7A5BRYa1-/;(0700\3WKa@:0-_G-?
+.9M#I2>>^g2U:3Z21/<1;f)YNLN&73@>0G)[A8Tb+gHcUEeQ[VF:>F6EB.BFQ7[
/?fSCE<:[V68&CN3K=c=U.D3C^]DZ7;;<;K#6#4Lb]5@ad/>99U-=;.DbF66]?;Z
<.dW,-Y_)RCHPeaG=&1a:3B5LSB^H2IT)\gA@f\<1=#K8H9[F)DYaFO=@TMTPdG4
LD27a[&#W,,>:=J=8F,]G_;)AP78&A#3/7?+XP;4[Vb[\UXB80V&814.2=AdE>M.
<AN(aRA:#PNB.d0V2GQKA;Yf2/GO.ZKO(1g<Z^^e^P=E^O[]-8\?W6L)O3-V/QC1
0c^0aHC-B-6A8?&76dfCB+PPC-;aJ79Eea3XJ=@MNR__0M;WL^J\<#,d2EcZ)e4H
Oe&8646>6WTFf=ZC?T3cDG3PK;5(^cT(R6U0J5Q58&g=:-7]?[;gP?CM47]6X\bN
AX1R#;)g&e27-[5K3E/H?X&aC[GbA:)T9:PL.BS&.dfg;4>7R[?22a=;?1,dU_LV
BJ)CX4\TcKU^<+Ndb[3]1;QO[[\X3/#(;:DbF)g6&BIP9M]G(_]Bd>Y436GW^c?&
Q[YN6cD96@;&#NVE\S7f28bZAFb^Q]1ZGZd\#ZYLTY1JJ_NKI_GI2)A/bK3(I:.N
33Ge?E3QeMHU.3f+gEfD5WQW[)6LY#W\#)9b/<W@I>e+T)?16GR#O=@1/Zc[0Ke,
D&:f@::67+9U9_GF](Ja0J^_(2eST1W<\fg=W>AB/O=0--,_9MBA79>M1:5#K-Q8
B)cA:VYU5GRUP(T[M&PVLOeHA=KSV2.P]C/Sd7cLIb)dW,Jc>H#OeWHb;XNE5?A@
V9/WMd<K^=d5&=BJf<80Q:4>2NC(M3J2Y4b_1ELfFLT1RUO-?K8,D6TAXd(6GB<4
A4PG#]f3R(&2e-DY=->D0?)^,JQ174D576&E3&N8IB,H#;[M-e4Z9bK\f8SN1^)(
DA?LXcd6MELg0bU+[F9/6Y[dB=3TJH?Q6gGU]:B#EfIfa=<ZT1OOecaeF<<-/d.9
2<(OSXM0:c4O2Q>gN&:0^+D4Y2O#)[LK(P==gO<T,4:gdWCU))]KDOIL-T^4]K?U
:OWUK#edba=^)NgK@RFYCBS61gQ.gG)/4G=Z6YNYPcUgBM5.NNe=&:9UU;,HcI\^
?1SQHPT6/)&,,V+,+4TM#Y_Cf;6ORT;LdAaBBQC0QN&AP<R98GA###YPZYN,^/AS
;N.<7+P&dHc/H,c/2C1VE;&Z-5ZX5fTOD>V>XT-<(8U<#L0#&7H:[/M589D/5e\?
]LFg\UHg;#aeBCP)#6N[,2UA847WUO-\2)19&4E0JG#X7?JeS59K85cX5UL:GE2I
?dQ@==f,_Q\86&Y&,0X233d,M-97M0(g66+_Y\F^2/;<(B#:-UFf]5&eCd@HZ?a[
4)9;W>_bC.V<.;b<#/]90^02LP-dC\fJB--bWGFHEV7MUfW#+I0A_;^MB--LS_WV
O-=CQBQ</YQ4,=_5ZKHR_2C^_\R+,J-D#2+(NTRV3ac_RS[\\Zg(=#@0c>T3[VUe
@SI\FO&\22/K<+?G2b;/XcJ-ZHJ>R8YP_1G)Uae?/2bLI?K5^6K+C[Q:YWB,Y2JH
e^MUTaTVHUYfFZCD1)OSN>YC)KWP)[LGR8ec;a8_Q.1,DT=8[RYTR2@\<EV(S]E,
P7+>;16<S&1/RQ&:W]e-9eJT]R8YeXGYS+[ZQ[[U64bG_QBQ(FZ_7?g7,LaTYcB.
^e0W2C&Nb8ETRGJYSfaT<QBCZ_LSUHaJ##EKUHg?-OB;&g?[Wd_E6VFO,d_DN)Ye
R.(D[4:UEBH/O;5g(g<3UfW)@Ka=1C26KMGUa5a?D+>8AU0=dZ@Q76,dJ(]b:_RB
U#EKN@@LE-L&>R(a;]-Y[bbc.+JW.6R>&,PMKO#^6d)3)gNVP6,Wc>B\D8)@]L(H
^a7Z&Xc&[Z;2-?A_2L.E/_(,3d0(]fVWG0VCf07I89M@O^EKfa0IBW54F:W,c8aY
GNKe_97geZ8YcIY#L.D<;^<6[cc40EA=ea;eVZ_6_>,Z0+.UN4;R+-5B(DL1DYE1
?9a0A,AcJ6M7Z^8Z:TIU&YY?f-^-?^G,eH5UHA\]H:&F/S.#eaV+_Q(O+5P(P.6;
R)G\PT#3?3:-/4(HfJ1@DbRZ0Q8Vc([g2R)61=TV<I0SK0\E)aV>>2+-+J]5V#))
,3W/a1G(+I@LGZV&a=3K29R5U9_T?5V#C.I+)^9G\,QFFB02I(gX3&&L+[^3;ZT5
V=GM]GgedK\c)BZOX9a-cA[_d<)K[UOE6V\5QB(\NW(6+7-T)<]??JbAKO)Da@Og
_:^@AA/X)#.0;;Cd6eM6?+<620(.Y)UFbCNYEJOJgYJ0BVd(65c-V\_FKPe2AJeR
/RbR?9A;?5C5e#Q]V^VQ7A2dMC@eZ<ARRZ.L8SJ&Ldd[2U5L_BQ&,#ZIG).P9+Pg
TEZ_7@bBB0Uf<^#,GL^SV>LY)=1AbW\9IIWa/]Z2TROI\:>dB0DaQILM<+E<(&A\
FK@]/1a@(4J+MJ3#<.N_@X,44FMeK7HeFM\-[B(B4aTgIQ\=O]c2DF7NP?<<D\.A
&f_V[T6?Tb]A:a/]^A+(3KJ<&F1c]_86-)&P3H(99&/&G<25.L84ZfF)\f\M.<]L
XD:TeEHQ]8&P;e4RYdcH__]3:J,ID>.>>@>dC0X8/54/eSde]9ZXZY/@MA1--<X3
)A^627\g=g7e1C6Fec<I(?=Y+bT@#?0,Ce@LbWR=^EZBK>5@PN7O(-GFSHaZ#0MT
F.6^dE?[0W1X5V:F]@U,^UQ8#P:]WYW\H^<4U\:2CI1E21J\bE-G&2NHCQ42=adf
;(\6_:H&X176.(R^R66\,O?V^V62]K:T_4;>).B/:I)dP:#]WeQ=SdOP81(1Y[b_
:),aSWM]2H?aAC]V#bLW8HM/WL;3W18:c.f&EH8,(O_@8=gdQ9aQ11./RgR,&dKb
XE32<eK]QY01<_#A[+J41)[QVOS&V^CP,UY(Nd>?N1gOP+.:GILHBLUK4?PE3&dJ
FdA4Y1e3L+B<MJ(AbVM1F2N4MMX>3EL3BdHA2\0NNgM-DaQ0NE:33=?6fg=bJ:g+
]^f\1LML@X](.Aa,4aFJU3Bc0)0Ib]J23>WBCRO=Cc@0->YM(W@I)[069H47_:9?
/5SRcagMgH;I[XDYPZ1)BO.F(AA2@?FaYP@X(g^^H(PT]-8T_E_T5+bGMHJCbM)T
0>NAabJ7TBEccf(Oe;_X]NHF&QH,8TGM4RTR69?&JePZZ&0MFT<UI56gdRB3YfCR
).0>EMB7&UMbKa(=RKTabQO=SZ9HX_T6EO^W5V-UMdCfZKOQB-&7.U8CF__Hg+T3
BT@]_#BU3LXB(6egN85eU+XeE.N3WNGS4bT,&^NX.4LT4]#a_U^W)f<?Jf<CgO+D
1WaY(]P56Y(g,RafafJQ<0C=/#=CKF32+RH2b[_+c0(EZMV;_e4C6O/:6N(;#YW5
T[Cc>;)b?NOQE>,PT24PS^Y5Z=?MO/UWTI;2eWKVcJ360VXQc4<#?XM8?0[X8]OS
2)]U>d23.?B:D.ZD3e(HH48J@fCT5RN49W^1GZH9+ZSXV<7L:8f</G@LF?#387RY
ce(R2#C>9&C92=Ca1<fX7G:8f#;T3c#4.NBb,O@SMe\-R@M6&SdSI>JOY65J[cYJ
N<==;I9PU++]db:(/LB;)\^b#PE50LY]:gb7Bc=D44H.e#d2Y[Le/3M@?55XUV1d
GMM/AaZ99S3>BKS4X]0a#R[Z5JU]L-R<C[L+E?3d_CMFRM/F_K-HC&<C(YXBAAcc
IRVPXdDIN2DBQM-#;5F5T.<(aXH2f(c&@3F:S^2R6W/a^,Z\E?_GAe3_Q?gP__-R
A&1(+SIN(W[WWW:34Ua50DO1K]PS+=^AII@DPDFSdedRX:)Y\E/19T2Pe^1aV8&S
\3,Hc,X9/7DbUWgK5QH\N#CYeT)=4WM:6G[2)DM8DT-ZTH?GKXJAIMRA,bYME15)
;fU>M/TA566eDC0,09I<UT/b&V@_N.60/F<P+a.P&8\N^RE[.,(?[NgTEG\Y#-7P
I0MC0B5+,GOJ_^6ZH_d@M6dMH)C<Rb;U1SW#L^LP[g&@eJPF?P>6/aHSK[1L-7+6
8?9HC-WZP&_f<d@&.+06c/^&9C]>6;4;P9aIJ+IKM&FQO&3g6K-QM>:,L+9/]E&L
Ac+L?,URE6XYH)a5cCP^/.d74#JF&AV2\I=>8NA;[RL54@>W]\V&4B&IRP&[ga--
YYM4<CU>KA3X&1\XTSgS:42X99^R;W&9C5&4]/5B>dNQgaFP08##U7.?WNU@S[\<
F3-D)))Y6]C^4K4Qce],R&&48.7[VSSTP&CQG_bP2[,MF)(G8=/\YDV5F@]^FA^]
Y4[&QfE\KaV-.;C./,F)7,\>^_(CO_d943D<RM5-Z8a\#\^>HK,_+d_1fb)F_>NW
4YL7c:QHL7#,Pg3M,7A4V5,e+a:a;+=3Q\#f=#1f7EcCXH44.Qd=QM]A(+NNAT2[
0M=JLD#c).@gG?=:6b=0Y9\_ZgaJ7fgAfNYWLgX7HD(HC6.:#5\##+e7[=gE)fI\
W/7]J>gdRK#^NR0gZ0<YdZG/a13>)\AVd:T.Tc2I&&P1cA?^SW55CTS\WO(\RS/Y
JB7F0Xf^=)VgcaX(fMf/eaR>=Q_H,S0ZVf<QZ>4Ec.N@D47B)Kd)_bH)3];@0]F(
?_)KO;&->aMI-.3H.#?Kf+KDd.9gDZ03Q/X=EB:<R4[R-H=W<M?aC8G16R]<RW4>
3L2_e&E&cPFC?;bKZ)-C>Cf:fT=LC:\8UH94g8?Q]fa)OG>8E?JCfY9bVZR;BW@&
eOSNVJe+[<^3CeT##cX&E9<,;2c7)baYK<@X=L,[I9L8+&^^6K2BVI/3]1<c2^9)
Y2N7Pa_2;edD?+7K77N_^G/Eaf\86SZVI^CW\bQ2[YR:MHROT:-ND.:U^?QZ=Z0-
VI(SFP@cSE=/L/a6E?K6QeZ@.Dbe0U2(9KUIVXXJI)CFX)Yd[S,=VfYJ99XM_c#S
FP^XHLQF5P:DNIa.@eN4V+[GO#N,R>0YIGP>[0B+V72BWMU1#I/Z#HV0,1b@:;OG
,NCT:PV&/:HU#COPC&[X\>6FV&U9EFR:3IaK:C1a5&J-&MY(+N3\I<0CLeM8B@cb
/>+?P-[W:E#G)UBR<[g?/ZI_5eGf&^J>CZ)G90&G/>].<TbgCZB[UDI+Sfc[bN4a
c3)dYLO+;7]6.a=/fM6NgP_2P\\]>28:ZA<S+(WOVXcO(+8+)B3?J]_FaQN+>Y#(
I[F9D#7\d80K<eeL3E,)Dc#3HD<+B:#;Y7COTZLf=U;U2;F2X</QX(B/&L>5&MY)
\](9-A<V4>eVA801-eHVAg86(C1[WNg3dL;J,2Oe-R(aHfgNS?(A:Pf<#X9;KREf
DTY\GE&Q[I;a&>^KK(]N:03G_T0KL^Fd;PXffL5IF0aD_Yf6D\??-KDc<W(AN3(B
.MI6J_Q/F-Y9a]F?BM0<Y/B;Y-d(5#_F>O2H#8;KACBJK7DP-;5@?J=R(1QUfV(=
GI2KFL,I7^OWI;C:=G[K_9LE+@V4T4BaWe77&Z2:Y8_\;HG4bIC_7:8FfgR\QQJB
+YL.A>1)PW9-,82&e,H#Y>(C]R2)12[L56gBMe7:Tc/>d.N#U;M)RYc5/_JeK/-=
d0?Q#P7+5MOZ&3Y,06/Adb-]UQcU8C0PCDG24OPM\Y(ZXET;1XE&)]K=?/>>;0e>
OVYAaGaK]+3DH@^0]MEUc#XY4UA/RSL;;^2QA&)5bCg3g_@g586-=O_JEd1LcgEU
^DOb&)I(SA>U&GDJD34\0.@J1)B7.[T-N:ecJ:XQG1B#4a,OUAf>YG-(IJLM]a4R
[MX0H/;NQc.dfUEJ7IH4LQ/YMVH0#=6A1ceFee4.74KQ(H+VI--CF/.G;64bNR@c
a?_-;V#>>cWCX?(<eKY7cE5=c]<?#R.YTbgXZ04.LMK4CFKP;O,HT^3W^K6ICY6:
EZ98de;3\M-][ePIa:@^P:71JE?[WWdV>:4X]26g_:TJQU7(+TeDCR1HZZ<b3(e-
(_4Z\a@TSG6d[H<@^)3O5M.gFS,@9)NFV/M1N>A4F94;8g0QJR,Mg,GQ-@-?9-CX
&J]<)9JG=K+ZSMRB><:gU&/^@Z&^OBZ\Y^g4VI8c8[N[[fLJ\WU6e=TX#,3M4f;]
0f@8NYUR+]:&_J8)e)[L&#AW=dF?,\7[3X5,?7V^X;0J(gaT7)--#2?&b.??CK0c
+Bg8<GTS7[^=SH9]g-PaX7^P8]bG0]QJ(R6+3^aV><:fANGUOfJ6Q88U/LLP4[6N
C+]ePE5EQVG06ENK/K(\c#E/1>\XeA2M<,,N=3g\[6--WVH[V[D:?^3XGffFfT3(
;W(ML_g4dPF_<99T31LZ063ef=<NT+0WI2I_JHP];.]2=NTCNRS@8g.OJSbY]EA+
@.Q@IHB5&PdKa#3S)-??BZAJ;a-FRRNMEH#LM9MW,?>0HJNU-PgOIbR,cH+M5[&W
D?a=HWVBUOED[Ra&(A]c+L]R5]\J]Z18:EM=@d<f>:,HL9gOA5Z=K(SO0+e9E/f\
?HC0^#057Ha0UB0T=E_:DWNL:VJG^,DOQJ\fLJ;;@(TNA,&4N9YW)+9?b0R_M37Q
OK;WH4YRL.fX^,BZ6#]_LUNeX7@AFNEMfab1a)e3HG0N0Y24)/b00W.C]Q5X\Aa4
=E<@W,V8,U#.+bbI[>,dE;2<D#^^[_6aVa;(^=FI:XQ0ND.:6<BH<5N3_)#()fCG
^93V-?bS;A2+)_Ab,LFOP/S,S-4Y+P94Q6/(=^/C,=]9P<OKEPJ79,KC,W3SIG+/
@;:#CI,&?K7)QTe=AL@ePZeM[#_bI5g@M\(8W=OX89:YXK.4;8&40U\&Y0DY^9Z1
QRNEcJ#4=P3IPe\DHM@CB]:4VD0VP[88X2_fO0H=1#KD?g>S6+-1S.P,fM>:#12;
_J4[49)MJE0)J./9(e8)MSeC67fI7]7GGO=X-EV4,3GAF;Qg/STLJVII\@\3+7-2
UfU>>gJ1(/JD3GX<C)XIDV,NZR@A>_(W+##5]Q7=0<b;#XSdWL)1dfBA@ARW&0SM
WE1[8\=^NAE-Q+_YB01&WROS@&@V+>U85eMX+13\f.>1:^?^]]GG50+B9NVP7a4-
VU#N7LG#Deb)^a2RI3J\&5.O8_U4B)Og3E7R:A@Q()(UE(E(0?[:SE(AS4GV0.,.
9?5@1SdM>5>\E,_X(#(>5XCWg8XLBF+;RR2g7VB@9U(Nc6g(BIS@adC\bFYGD\,f
Z:)E\0&?J[Y:GWMKgCUc3R+7Wb)WDFcCFWS,7\)^)\afA4ME^f0.g>GVF()9&=A6
B:+_5C_aH/eGB</bANNIPK[7=]6=L[E_-GG1)-Q#FeOO.@U>6Z8P2G1]##U)Udce
dAWNW<O);)UJBDFS_^g1RRQKS+ag[\[:6B<f,6JK-9_[<-K&Ga2=KaaaVO^RR?[F
CSP[,H\#B83ILH()PUX4f>WNNDH&>&#FG);-@W(LRMOU4bR-<7O_cN&aM#M>7#HP
HX(\fN,Y1Q>Z+b9f\6^DHCQ?02GK.[7g@3ZSaaWXUNYbH[50.W;I>1385NT+F8.c
fKR/bKY6aRbRO+TXO/XKV<I@^[@FN_AKa&I2L04dBG+EP458G=Z&\LY]6).RYR,;
1L3DbBVa3LOYc,<OTSWA^>L#eW^F;c3U.H[g=\)H7CW4(TV66F8<J]38=W;M25ZX
FdfN4)@6&[8IH+eR=efS1O:)#(0B1D/043FFD.]:Q<Y;;+GM=R1#0Rc0?cfER/QO
f#I0D.U]QPJ8_?Cd-OfWB[MN7C1@\6KT+BKCAUA+Q9#Y)Xc^5BN#8\V26>+))LO[
I#T.Ab2P^Ob5cVJ&;IcN;?ZVf=;UUTf031AGXVE5T13aC.X]Q;VLcYc0FSGH.ZN#
-3T)AU5OLX1Y.6-D4:MP=#VD<JZERDK]84R:3J7LI9dZ.7d5<YGC49-f,b&?:KP,
]6J^.^8X,WVe9L;KL<UM0@dC8<SGC1[KXX@H-7AJ7@^G8[-Te7BcZSX]Q>CMB27<
-CLLR>0JDZ/AL-b^VB_Q]3-_^U\Y8>/OVeMA6=OdCGfH9BVOYT8?R?gPacCJ9+V/
-+7g\Qb)D8:ZP2A_=383EE?bO[6661Z7AHC\^<g^BVI,f<dRaY-T+)@>DL70C+4@
d+R1OS^2RUT\eRX3,[H993K3NZO5faC.-DA47(&.CdM_aY@/J,]^,F@E[JD.9AbI
O@(5COG.YTOY2)Y+-8OJ\F3^ZO92#4[)Y)_Sa5Lg(#+^TG#eG?bEMZBZ&3LDQ;W4
:b7,.Hgg=G[O._TO-ATS[<Y7(I[7J2#+^2b\Q?K5GL8DF\=5B3XN-_fQf^/3^R06
R0.<1FcSeLX#d6;SA=RL2^bKBM[Z.Vd2:#X/QMRY9/3]OS[^UcM?=ERPHeL2HBZZ
(4CcY1F@79<dPP4EA+[P:HVLUZFLU,58-7&@]SYC)YP-dA[._A\5Z8:_DYC,IIQF
Vd/&)NI5bJRQ<J@OX(\eMWAR09CH@D&9OG][RK(Y067d<:]4\f6g+EA&LG=_(I9g
?;K]NZ4UNX0YF-W+6Y>F1=&[)7?&EUE8[2WgLHTg#D7SUBTHcSZOWZ7T>O6C-YO3
WYW(d6W2D.:X?>,R4HH^a/0cPB4YQ^DYKAL>c0UW-=J<d@=C-];eA&>FDZ=B=e4T
Y4#VB9Q[?[P+Z^-,V)M4;\<T3@)5Kd@,.?T(X\1VWBI,0\bV<81[9P:]gS;BH0IQ
EREPIW088P9VLFOJd8+>Cc1a@,Kb?PZH0=2SfBW3#dZBWYRN2Z9.HPQB@1b-F>Pa
]PFOMKP,bAM3e_D3c1[fFbOX;TA3-]X_BT#FU4SfC@(/gd1c^:91BO-XI<V;(;<=
OHc&[LBJRGSS?<d==?9fA_BZ.\=+ODY4e;V[_NERILOV9CFY#L46(U=5,2;:0\?/
YJa3cLQYg(BVT/L<VM)SDM30Q8F_9[c6J@LR1L[-7)D/gY#ME5g2D(_/L3C4ZWJE
F.GbKOC\P.+J267Y#f9=\GaF8B>AJ3K#:II0:Ffb_EgfcW+_PJO16L&@UdO+\ILJ
?3Q?EUGHdf[-,M+QcB&gV5.?7eVHURC90+Ze>3/#;.5R<IP6/X,:81X.?GRY5\XH
GVOBg?]J+;7Y@KgRJ5;ceU9\WWC63H#&ZF?&DRONAEQXe#9IC>K^5_1:I@@FA5K@
M8U7JV7Hd1EV7M;MBaKUYQ#(BT6dW6a/0@?,gOE;JD8J5?9NVfe;G9,d@KccZ9^f
&7_28#R?[be)Z=bQ7fA-?;I)g>9f]W4N74FB[N,N)PY^BTMO6OYP2>[O>,T16:@O
/Me6a,V<2_E/QUF:8a03@&2e#KD68&:9H2a0[MZ(LVN6bRHA,J1]&.+?4I30a4(_
;L]O7;C7/HZ44##J-gR^.]dgPd-:9>DS=.gVc7(4TH<DM_FF[b++N)K@+AFFZBD@
f53:V.X2H&:f^\Kg8g]fK&+?XXZ9AQ5.Mb0ZSI@RO_:[/E(c>^7b)+/+b@3f(-Ya
>B.dC,ZBb4g>.:B8X>2WaNb+F[A_N5DK].?;5M\&8J?a>J9^W),gWd:b+R4E&f+&
ZU)PgU)#L:b46Q_3<]GH0D\/I^[Wde<9Ic2N9]F1&H?RIg+32a/_]@X#TD:eP87I
(3=S@=JLD+Q,Jg#)Q+cd-DLUd#)QYF\67+3aTNHO9@aYRcK4XfA2T0fYeH(8)MA^
F2Z]7@9Q_g;K\6c+ENTB\:0)<:02X2RJ:b2eXY0-<0MVg9)09;3[:F7AUYM5,92D
D>N_g-YRT_=:a@1=350.8/E;Y4:#VID\9T:<M&OSSD2?LEOM&L-0Jc];^5[S,9P(
4\>U1/2=gK)Yd.(NF>deJFO[KFd=P]K\XS#;fTGL>&I\0=UK=X7;Kc&IN>]-DdJZ
D.&[3A[e;4R7Q^IO-A5\>QCb@f1]5HE2gGFKD=]2B9S\<4)4GTH0&7e>_A4<OND1
OJUH53G,6T/9WRJ;Wc+TaX\?eYVc64,0D]Re&YH_CULc)DCD+gPK-.KU4;&c9K.-
(3BQFS?UL0.O>BDU4Xd:1:\OZZFOg1PMK)AH&)e7fBC?5_UVKR^)ag\1>8HaQfaP
bNVN??/5Q<,>/8\,VB?dM;Lf)_B0D;Ad:g@VEAX=;cQ=@?3WE#]5R[W<KLg\/A06
7WeDCAOeC0XfacI(^:PX<1ZOV:#QHK#UXc\L_^J3]_d0^7+VMcT&d_JKI0>0>)HU
F]D<.R&B#0JA.>0KY=9_H(>54>].VXU>JYOLD?FN8;P:.Xf(&PETRB4]B1BQ&3_<
cR9OB6K,=U)a8RT[MPIC<9b6Hd@FU[LFd9e(S?4:0AdS4;9ebW^VP0LE1I&[-77F
4g^>S]U.?SL(X[,eW]5=A>Z4fbT0HA1P32T6UA/2I[ZD>H7357<6Q^ZB6;8B@>]R
=#[I2N]O1WWF1Pgg\@(02DO#TO1_(I@b.<0^VOB3;eSg?D)1O;-GG>4W.VB5OWI>
G\beRgV;.Dd,3#d3KDDbF>f4ecR_4.><dcdHCE+A=.E3>#ZX.d/]9gfYF=^L4[0X
5[=(:NT?NSgH.XY0CA#2QT,,;gGN2aJ\=(HOL)CUGU\e(&A8W^&:<US,2O0Gec<X
>I-0Y;DLKe8.A-3c,IW<T&+;89=H[FQCS<_4<_=?,,?U>^XU_5L<NVHVbP[=.e#,
[W;+5a>=C7R7BP:7@&fM=6&#f3g[e^:PO#8O3WZd(-1_0c-2,NHc:0Y3fW/aHQ>[
HCRMa>D25WHT?M?Y;e3;AX7XFR.PgB\1M,Gd4bAWFE3=C=eZK?fQIR]=HHCAN31F
4.Gb@?#+dHYf^,BB/\2.=9M;&?4dH4D>+0HP3P]/JO0&M8R>[7L3Z>[31HU3/a7g
^[>P:31_91]K,B=8BWD5+[S/Lg]dGAPfHa1Q/F:J&c2I@LP\c,\XdHJS(fN,)cGd
.7M+d<P:13P1D)FfYHIaJ<?WPV4A85CQ2<)1F&\9[N/=49;R[fR@^72Cd<_NFIR2
-:B0G<W0(^/B?YAR1X([#Be#7#P\<?EaGRO9e9a0Q2FMgIL[bU+;\,23cZJ)^?^I
N2>eUKVe>(@Q3c?b^NC7U1.Y>-.Lb_XHPWH7\^-_HBJ#&\),e5e\B@E(2c4+#?52
eF,BA__7d:gP?OMGM00V8^OE7.D;=@L4.SYZAWTYKOXfGg.JF_MG;WE,c[X7>>G8
d]\H=U=WV9+BQW[L(ZcBM;OYbM.@(Y//e+0d1,OTA>Z#gO5KC#TIHGR6-L>HPAW\
,XPEc]c->APRUU86Cg0CD,;8f&59,dE,MWAH33RN#a]MfS?0N,?3)\+b2gbBA<#>
YEOebPQC\,M:2LJcK;RX)G@Fd40@E&7T?<ZcP(#_W8]?M1],8+ODTY,/.HbdP,P9
CA^@PAYCdC4H<GA4O_G#=2e6JD&7,Ed8.6XJME9K[^Bc<IeRcGU+b,Hc2SJaP>0J
1,Ib8H]VWA7;NE,-1J.#8U::RIfT)-QdM0Z0.+98#XT]=PcXQM#E=DNg)1e\U@]E
BDPIRQ8fZJ225eZ][e+1?6XZ7#=C_0Q64C#V]MY:WDV45BR5C_U1N8IET<T=Zc[,
-cc3(OTB/K-1E-8MdV@dTYKB3@Z[7(YU\)2=(/[cQ8\WOXB<TMN8<;R_.0NI439L
g<+O=8JFQQQV6gQDDBH4-]#N.[SP5/S.<N?Y?P>9Db,U8-WaIN>JVVAGJ64f&a(]
EN3/C<M+)BO^62<)d[+^UL&Fb[W>/PXB7A=CWR,R7O9a>D9Tdd1B;c@R\OVXC^#5
Rd7eRgA5X<#=9aQ0H/O=E2BScUcVQ[baa88206UFV1.GfQac7&LcRXY:ZQ^\G1Z1
_(=F+Y=2[OWb;CdR?9@WTYBf/<[4H6NgD]\;F5MC1Y@VH6E92+F;@Q\I(:K5FX2@
A68TfR&g\b&4-V.1bf:MNMddA3fM^<f)M_IUfFg[+KWNcPLO9,ISQ>=SRV2=YC&Q
L]Hg[c\&P6=^596Ec)a8<+IHed:KU/C9QI[fA>2OAc[]9(,GRcOWLNXM0=aCgd.A
SOKAC4[=O,I2bW4e(JPK41e^-R+QF:+^[XH7.N8\#WdGa)#4(ZP,Oa[O:[:4#9Q0
-,Q6YV.aX?KTPO/<<KL>=<2fGIPdb&6:(d\0-SN(4Cfe0Se02dH:\+=?(LUcW6<<
W1]2bd5Wg485F6S>43D<&7N>0^6(-gX:CB4)3^GG:/:5>d>c.;aBRQVbfI[;_V7S
9Z\A/\e,)#AHa7HPeUT#M<JI2.R/HVX7cLEXPXI9cI]XY-H\;\#cXNcSd43I\#X&
AdX87D5IER25>-aL6>D/EQG9WO_\+3N,#WcZLZ4&@684egeMCCJ&afa^O<2(L,N+
MOT??FQb;9TbfGL32VH9KM5V]gNAdQ?00G;dM6d@D1)X3Y;[[<QgWbNQ/5MS?c5\
2WI9.(_fA_adab\R1F+7SLg+)3,):R?Q1P-;;4?N/6BYZd8?aZU,3Q[IM:?a-@]J
II=+EH.YAC>\L=BR:\aML=E32:UfXaFe1\^dY>[bX\b-1\WVcVFF>-=D[HP+YK:#
1^H_9:DE&)d>Y37;&^[^&C2U\@JE=eJ2:X6B:/[T0@SL0[bI.P.1D\@.)]a4cdA>
S_F8W&EGYR)QO/BfVA5+I-25UK:)-[G&_PB-Zb]^_?bLGMBO/>OAM\S3^bSf@WNU
:P.>T]C_cc#.4IaQTIQHAX[-BC(Ze6JR0<b40c2B@RI>Y3DU#PLR@0#/AR;&>He8
-g-.\JBI?HH(;6WUAb/Y?<B445Ad0CU4.4-^X)Y].6aNNXaf)A65\K)XMBLJ&1IB
M(aI>@_7Z<#fLY.N\#8;X[[;V<H1J6BQ02JC#N^^1QLaC8.UP<bTP/J6:VXgM?[P
NU1WY+@f;ML@G-FV/^&7#,9:,V^57L;cLgdJ3Ug3E//Y[[eTe<4aI85fV1?Oa+2Z
fY+D#JFaT8[Yac83S-J-:JZCLN38g1T[c/?2=Q@Z)A@8eH[PQ&69KQ4/X#B7EG,=
.B:SYV7KUYEF86=Ha?d.VPdCWC:YR]/PQ+-E>_B<+f,IW\+HF-<KGb)YS=VdAG3A
05:31Y92FcC:&//;N(eGS9+,NN\CG:b4&N[(R1G5N)]D\0UHXf8R+eQT3C\]+^R4
6f3YX.8SfM(<>?1c\=?)#,g3]XUEL,U=.B5I.?F^D?d@<LM5AUGKTAHO9[aQ(#Oa
LgX^S8VHI6:@-NB97T9.]T3;>4f6++</&P9U;MMb5d_]87O;JOe+BC7ONc(F/2_N
?)e[N9:;8HLCYRP>)C^8846b28Nbf&2/^5[Pc_OJD>RGQd)RD;67?,7EQaP.)6E(
:LXY^H+S.GQ10Pfa@DAe7L[KN)>)/E&/3Y=1B52cM4MAKb0GPMS9e60\R1F9(X>6
e[>?<@[0.9\C;9&YZ[_?@#T,-ee:&\6WfATT;,/D+B+_7DgfS1,/X=F:9Q.Z^(4N
f2#).c3D)ZRSa\4]7LeBIKEP)D_(e2@&EfEMSJM,V<dRHKZa9e1H)H[8M9D1P;H,
@Q030)WG=C(+^F,SST4NNba[O-0-0;b8?aI79)E]=NZ+]B//c@0+Z9f00FFc@dL-
7>L/6I?B@B#J_I@A8N4SGX0,,e5c@fI5LI^,#PAI96R<U\/6VOe]]0d-b@7_KW5T
@0S1BCcO2R\<e)>[S1W<(^#;PS8.&ZSQ=&?W4VS5T.?/2d=:=7W@cE518)#PfQ&H
:96S>7Rc8Z@+gT-CaQ5OZ135Q0>db-&KceS+D]?R9YPA^<dY)1VXT2,&\I79Zg].
X2YCPaS9@&Gb>20KV>K:b@-Dfgc9D]Y2Ka.STB[@HLT_9.3I9=+I##9#F68>-a?8
9geW+F;f1X0aZ+2W[G5?_9=^:_^cMAM8-AG>deT:YX49&f,ADLe@UI)eC3/aaIC;
-UY=WCYNPH2L=7U:2R,-32OZa7KHM@KJ/7O(5Wc(e2,Hfb=^(Q&[gD@LQ8c]HXC8
@;aUAN.+>BY#84ZJIY8U4==-F:Q3[AD@HM8DW)M,OUS2S@?F3Y>TS<,d;YR^E5QC
B^Mf^WZDJHFF;Leg]GFgV=Zb1DFW.9W9^B_IcB&g81KBN5K(HS<)Z(G]WUITHS+d
@WS^111R8=7)JBL#3_Bg5N9NS-(0@X>Pd>U10;3J<SJ0BONHLWY?T8OWOQ;SM8Cd
@d:bYSH_d8cWYBR&-.ET:bU&\#\X4LK=c;RN696_DR;;T.c9Vc.LVN)C4J-=Z^<P
BY()=:PWMNU+/^I^T<Q;BPRZL,UH\G2B5N^O<D;4M=>_TdA0STf_A1U^4#UP@@S)
&RHKF=JggRf@e;aCgFEAOTP2A&?E9d>0^_-gPH55E(3R@SHXU>?6(QD/865#RXa@
J8SE3X6fQINA,3/ZQTK&(FF)2)B1<WT.4LC,C<<Zb]+GbXEW\\E(N6c,Y:9#9_>E
R9QZZSXgb3AQQ+NgNWPe3C)T(GAX5(Ba/0[M<6W;]5dZN:-ZA&=AE/#)bJ5.TcMT
Y9[-=?aED972A>7ESVQ/I2(N+#KS2OP3;#^OEL.fdN4^JbI0F83_Tgb?509\3c;S
Q-T_ZK3dL_aHY-^Y))c>GL]U#NTN6HC6fe#H(,;9.\(gS<c1(X9K_UG.3TO:-+C<
ODe0HWUfQT^DW_8P2=;B+K9?JS+(d@REV1)EBd_,HY9/JA=U7L)78NS,W(A@(>=+
,_\3Uc_MZD4MdL&M@aXd58W#=ZJT,O8D093dd))^eXYg8E/BTU[).aeW?N=Q3(Gg
UG,D.QTFD\6Y,-3MX/<A12)BB+YaIWe/fM,=?0Y,^Z/CU4.He+7X.bKT5M,33Y+I
5#/N88^RY/Q_Cc.:,<&,Te3N.#b=d8HULMM+]b2IDTa[f\0I06a)^:dZ[099BCJ#
Uf,-?.#Qg4HFC;KJfU5UF<U6X=c:>?R-3A3]2KE1T0N,99#S?K,7AY:AA-JMJcFJ
8QD_)bD\^Ab47QA+dDU6<(Ua2eVJaa0-NLCK.?U__+FbbXBc[XNUY>JX@#@:<345
>U>ZTAS(YaQ&WQE]=8XGR3M9Uf&aH2?C4_+PaA8KW(7eFAC2>6Z)H,E#a-YCeS@I
+2EOYOAadO&N\5XN4.R@-WAB4/Qg,6&C[=<ZeM99:b#_ZI8\QCR;=^VAH9M/ObG-
K@P62(D.XfWS[eJV6)I:Y-QG(J6AW&7NEJR1Q(>bED+6N;<B]8bUYM3A_dKR@F)[
[HdXf9IY,JS06]eWbS^UFU_#G<EcVgFB&==VV+ZRK?^,2ZQAfgeE::L.f2dMA5aG
>R44;9.Ya/ZL2_K#P?G0g\M+(J39.[M(9X)=0,4WH<3Sg1Q>]?61-:T+.L6;[J,L
J;4C)@=/J0(=#-NLS7YK/e1O]WXgJ(^D73BRM8g6/NGM0/RCXdR&_9S/018)[J1=
PG(#]??+cO385]&^NA25Ng7]1+1GP;Ve))[/-Qf;-M=VdOOXJ>@aK#@#N-\._[Z]
XW+N\=g@f_SC=C.VBE_)J3@:2YEFOQ/<+b<9&gW.<gfYY;AB#g0];=:RC-#6+B2&
,A-A9X0#VZXW+H=_<+c-.FJ2T^TXA6TX9&YUGRX7,#VLAM4_>eSd1&S45R/5aeF<
LIJWgGDH[^_:O7GF10OLVM=<?D^LW6:/UXcMfS4Kb.0JG3f#<Z.e<[PW)(SXC]8J
d.MJ\0L]7Ec]KK&S#7E)ZLEdA@CWCMGO#XT\eR_)#1+UW3gLSR3U05C@gK1aOfJS
.dHRI5G^_5QU:+Na7JGd+36=5b;e3+([-T5HVRQbA>CT6;-?5H]K2>@W81UTHIUc
OSQgg.Ka?ZfS;7S6UC&[&6KZ5ND#H1OPAZ+0)b/OK??;)dXH.II99Z?FM:?U\Laf
eF<GV4,)Q:[0OZ&X?B,@Q#MaVX.+IC(W,4;:?Id#eX88L]<O>GYPZZB0VB8ae-/W
?a:H1>,_gd1fBPVX4\MFYF,YXa-)f<@/[[0D724=#MVL]cT0bHM#c;;ZRc--gB2=
6)X-L_J0?9-KENQZNc]GHLHagME]=.2gD:-X-]@HUD(=9ON=AHZCd,cVE9C(T)bd
?<VZ)IOIQ8CT-9P&TK8>D_W8He-&3gXZY6fg].8D1SCW[=XQaN3:Y)==d1?8+aW(
0?H@23Z3,P#2+=^6^EQ;M=G]LUKWNGN,IW@YK[d(;&P#XN\Y5caO3V\a:RfQf:E1
QbMU]Y&=AKL+KL.SR<H<AXbAZY?Y;g)eX[BaAPHI,A&&fUIQDU+;8RgRa:MJH+=9
F18:-aW=Q/4P4_W>1K@d4Z.&R08;]e;E]4D<^PO1H)II\fQ>UPaXgO0]G@38DLX\
b_/&Ha]\,WV+(^DJ0B)/00^/G3R36,ICO;;5gAL]X285,.2,18G-C_7b#CG[A^:Z
7Y2C88-]4b8,SSV^;JLCJFS&OWBJ3OJTL?B(K:J_0DJ=Tb8<3?eF6^][b=FIg)5V
gVd5VWbI#7_@(FJ4Fd,ad?];aM?+eF44+5fMG,Y+G@ZWVX>707&6&Q0GCVOg6<Z#
_gC,I;O+O(WV<5d\#+H(&g6M///+X:Wc=8W8ENWgKSTTNEB0[:9A+N5,:)@cJfBb
f9Z->7I6.0GS?H[4[?LO_X]^W1=&8F7,(R[GG#>I0=0TfgE9J0C0e][<N3eXT8TN
L:)SM]&efRA@5WbVY8F&W6Cg_.3f=5V^HXEEPSVK1M4>SE[ERc62F-8/(39:HE9;
;U8UQ6Na#:cK@1F/J;eS<),&#ZUa(Z=H>?:C]g+4Z=d_@_40WNLS6X:@K2V,9#B;
)8\:Mg2_WD1_5/[OH0H-SgU::Sb6\Me?B9-gf/TV#Y)?VWQ->KgXGWFc^^9_c@,g
a:[7CWM=dT-S,_O,9NCZMVF948JEMG#&<aaKX+D52b=(1Z1,5GS=.bUA-90a]YY+
1:Y4XJ^@OE^#\]&=;@G?+Q]54W4LY96;,eQ<=0G4daR_.2gD_gg;EZ@_6EeXQA6P
_J>+^Occ]1UJ95a8]^VF6;(K9EZc;?G#FO9PP373PYGXg52_1@J,K-.gXW+1SB.e
51)&7SQ3O?W]MaQ(>-4+MNNB1BL\+?,LgURXKPb)H^Y9R3(A/AJ#DaNTc=HT5cgf
2&>=O#6R>)BL(EgN+53A?#2Q>[_c98N40XSZ_FfC[KWc7S7#<OZZBRFeL9R5I_EY
^?:<\YV^1R7<E6;SK<9C7]+@;,.\c)#SGc6FY2#IaPBFYcJ)I,26@;#bTB:\g8c_
J(.QP.O)G9CRE73S^INJ8^Y=]U-;6?2UC8ad0K]\D=>3H[\VZ&P+X<\<FMcD+EG#
\;_L=X:\@L;c3(7a;PZX]IC[,>74+P+[7:2U5#-F9)R+&VV1#H.^a3fV(98--P]G
.@MVI#OI]G)8ODDUP@0.BRa98JcJ3RDF3#.-+fCI..c_cWBH3VZ1;@J8932f5,LG
?;=D7;X8Z-bA.<S?L,:-YHI^1RX+TZ=6;Q?44@1fXVPA?IAeXD:HEJd1;/[T7JPA
IIJV8+(RNN(L18.(Z<7HK#-#G0ANRDU\@:#2ES.NVT+.dVW.;IPB]88T&<b;5XdW
XI.:FPGFa2XdKHAKF><c5>=5e6(WaYA768M_KdM4+1:Oe##\fA)>[b#6=6CLZ@<3
R:_,,R\GbcN,-=WaJb6FTNL=7@0aOC+>X()e#]bG5__GFF])ZRG6PTY;(WG7BOMP
]]a08^TaJ86VQ>2@g-60\OKD0:/BAdZXE]L,\WK;cFL[:-L[M#g.0QMTdb>2+6IN
)2#0c0Pcb&]Y#M^<V\Y#5J56dPB,8-#=?F20VAEXAP-b.<5AgPdQUBTgT[(#C?#P
RU++gTK9d5/:TbdE3V7WI-D_#e9L5S>(gE;9-]\;e.(]dY^Rc^b>JP(EGGFR7AKb
c;H>LW5?2/d(PG@P7\J847aV]A#1_VABAZ9-NF#(QIdcI)0fWC@X,bK/GF?Q::R8
/;O&Sb_/Ve6Q]]gNXFPV?#,4H\@b#c=G+H0AKc[C4Y26>_2@0Zc)/U;5C/JI8\88
]P@8@39e_=/FbK(71e<V?]\7;DX6@F2aJTf08DEE0C_eLEQ>Ce?(CT4\W5/Z[fH&
1eGV_NTN2JT5W10b(557G8:-AHGTQZL+:aA?fbd8c7eeR(4g&27?5EZEf@bTXUUF
2@fB?7Gg^Rc0fRDMR1&dJ\SA0c]Z,N^5F#R&P&LE/c)]d)CQ+F^2#EA6e-7:CE.K
UY[5TKZO\O\94\NKPRE.-eB=Y7THE&R@gT3TXgNBefG3-<T-4CIN7HU9;?,2fU7]
:X<=eVcM9LOX42GIJgV-D2e/D,:+9X>(U[aBB)NU25I0[T&=CA0@gIZI.5>ce8FI
^,b<-2(HJ@K@+J89Z\0[F<R+A;FY=f0A7<S>BB7R+,aPON=HD\;A2fcUZcT/@]EO
O#d(4:(7D3ST1b0\1]F5-?/E6.=:\M7K?.O.AG+GOHNcA9,9:G2,I[9++fND.^B=
6<-_]YfU(:GV.YP:[\I-<0M;5\@=R,g.\A9K-CfeB9FFKQY^<ff+Q6fMC@+^M^\#
fONeOYV#3Eb&-Y@2&fXUgTQXC5bX+Q._bLA&3XS9&.O@LDJO3Zf=c@c@#M2QAYG]
(GYX,PdYSC7A5FWR^VO3dP7O._(5</VUIQM3)3TQ>#Q]3OC?(TC/cT<BW^Y4Y91=
@OReaa53R2WG;KYGd&J/Z#O;K/Rb;7JVdfG,PI#)PXP.f&-6-+;4..BND)CFTO2L
D4+#M\1[e(([:8K/^1/<.GN9+IJd<4Vb/\(003A004-MdPJ2+_WMD,SGWHKTIa.Q
-0cF0?>WG:2M[>b>1fUf/&0>[)UPZ[3X9NEc1f:gC8S8Q]2?\OD<dF<_0/\AL]dY
Vg/W,a[_Y8X\dYZSP1W(MQ+^3O2Y;;BTDB/16K4M#7]1ESTeP0.)OH,_>fc4LZD-
g4.H2.I3L0=]G/QO796\I-QYZa]2CU6=84P1.C3#FUWW0a&,-/?:8+a8.H-&fb-Y
cd=Q[2&S@Ae\_J_9O+dUKSM[;H^3V=<]\\[OEA0WTDe-ZgI)Ocd:#/CO>>TVebc^
aeZKf/X;@1^Y[)[BE2961&d>ILXM]WZdLN^N/#=91C].?:C.E[0L-\&3(W5C]bT)
<gW6c:LUHD5L.B[f::YLM:d:P5]LBR8(.4JA4U?\?S:Y<&2e[5@DV^Y6HcNC@TfX
-3ZAc0/[ERaSPPDTTLWHAR<_S=XLH)(/Q;_K/RAV1,?0UI#KQJOWC]#R#58@-RN_
>DT_K]JHH#)(N2IH)/[FX)X78NgQ:.V=.[dF1MPF0)0UUXA<^F\KH3=/HGgKaGc-
JD#a_5-99M)D+e:MgK^#]D:HY[d)N:,J5V#,IF/WSJ_L:EQbT&g\=R2VeHNYT__g
K267,1g1HYGSFZUNPT6f5bgGTAVIC))Ze0\IFQ&01OV9SM:e(FYLQQ&LNE5UJ>>0
J0D(Y6</JP)Y5/;/^4M\-_VVbHMW0+7eRa:]fgOE=f>B.\f52?\6]>a=J94.IUMF
c[C?TCdX3.R\^-NW,&/CD2/=&6<WPR?+=&.K2L)^4a<1/2Od)2b@>6T##5Ad6fCg
@DE\_^d?0.-LB-@II;&>#M?.O7+e@1TR8Fbe)Z[]F=;@&+dMf71gJNS9DPPO9Q=W
3a,/V]+A?>Y^2O:ZWf2BA:Qgc+;;cJI)MTZYd&.\9K=,X\QV<G+C>SS6.8.>UUW(
3H.2O6Mg][]XY=0]QeU)OS1&L)Y&=[<LRO:F36TSQU-)Rb#>GE];(AI7a]3D&Y.K
Q?.CV<)/c.8?M906XfGEYC7(U2S>fRb_Y/2>?@Na_.?FTU_&U0PF:FJea;G>cE48
bA<@Z0RRJ)Hc^M_;J?/KQd#]7URP37^.6dR1C_8IAcR240K-a.e+#\\=E@8&[g+Z
N&,:5+MWe_RKWF@L8&Ma(;SVf@P4?,(b97IScS:,MKcI18Jg]NV,LUdJcGBXHYJO
V?O-;^SH(I4TIAL8F?=D+;6b#=Z.B;V;E)CXS@>NJ6TB?ECUF2fP\9W8MGE+cUA:
UF/Pg7F_OY/D2I^V\T.=?UR,,0\?CS<bL#NQ<B=eMg18>E]4.G&bPH\QR=CAd@PE
GM@MI#e)I_eBO\[\6cPZ0J=3[;)GM0Fa_^PC+)dG/.=77bWb6]7GN_RcN)]UVdU2
V+R\-876\/62L8U@C&54U6<e5c^cEK@&(ggS[S3COQe5-b(20/@5.83g>&NIV5.Q
7X-V2[0-K5=AeEfIde6V13;>,BVU(R2:-I&AN-\&AYI#_=D3EOX^TR-P9R-_L)R6
^?@>8b-+TTUaMI+>=J=1WaM&PQ/V@9f4g7bAB#fF+5^@,;Ffd9(280OG<bda4V;&
Z@;MEKBB..VQQ.DD+W[BAWHd?IJG3)9\2=Ue4_E@?+4?:&:5UR0_L;R\I38bgRZ,
,0ffd2HDK(<O9K&L]MSbJ&F#YIU&Z>3,7R7E]ZP?D1f]GDR.]e[N8a#Lc3<\bK:I
Ob&C&3OR_RRS\MA4F)/(da(#Q?;CB4OX&_(PYCbf8fAA7]-(L^E4BN@BT+N/JJ44
TdR4U-/VK<U6dJ2OWfHT+[8dN1&?0R/H?4V.3Jae5KC0=K&&+&]/SA#f/VCaA@HV
ae6KXe,APGMc?E1-RK_3c7AQ.+7U,ZI\=NGG,Bd2Q6(/[1:cI?a91-[^c7@0b_G.
<a#bd@1X:1ZO178_^#98@:EGGUeX-JfAQY/>Y5C_?JQR;K?Q):=SOBbg/B(2(aIb
+YE2AO044_#d/YHZ[NT)IEES<(V?.58;[4=3/[VNJ>3\R(KMFJ8,#]]SPWCL(7]U
61>V5LDCb?8V7CO9Re/0_7NF1^M-293520Zb;G:d-#.H)[4YSHe[-+J0&X^WQX,8
Z;<KQ7cOe(TLaW3^[UdT,P&:&^?ZbLX9##M,CRb?Y&:G:[a-)cWQeHH_JJ_SV.[(
I/B,dH-#AH/GL>/#PbACc08e3NCI_>=T)0LE@e4Y(5J,1DE::_J(VAIKeKE.-.Pc
^\YOa8CTa@9?0LP(#755d7VFCCGB2C&(O:8<\7cRO_J4EFU_63KN@dG1T:a6DeDR
1c]X#1:=D<NY06G=ZZMX3N/HJFZKRP4TC?MbEJFHUY<\&QCW(gdR)F<aUe42.J<O
?[]\>5M&&<0=0,D\bIPbHSM\fZ5S#(aFf#>VQWE9fH<VeEdOV3;M&+PUP9TD\gaN
8+W)-2._#&A(.N5.b+Re.CBH_.f:db.g9EQeHXOOF2W/J:DC[)M8TY/9UW==],MS
GW)BbD<E<3=4]7M?\+4b(=E)a;A^fXKF4P>3_>0cEU4WcRa5M.N.+f/JbI33JKd4
8Lb)]&b(KVXY^H_W#ZBgX3&(N^B_O_A;&XO_LF.ESg0gfR@R.8AP:86@:)FM:=QG
T(Na^AL<PBg]M58H/3KPHZ3A@FL7POR+C@6b(2UD5OD9N=M,)D^:VcD&LZUBgbZ4
?cY)01NM;J7ce^-8DHI/:3].DeFeG\T>9gOP2W<F3]#\UfcQQ0EL3+2CLdbMOH<S
S5JY/XS,98cF8<GAgO>75gUT\W8Z=FY.QL^^bf/]Q1>(F)50J@-[L]AT2/X+5JZ?
:P+J\9>\&_bA1-5Me\D.J-d4L?bX6P)]C>@c8\NH<CYA;&D\I;Z7O<,afb.P,9?A
\5>WMX:fg6I+]>1DfK>P7Q<DQ]0UfN?MLJMHPNc0)/)C:6BC[IHYf@BdA)Z+\f\Z
Y.^;&VFV9]:4b:Q.F]b(@[484@J2Ie;#1Y=Ze31ET;-^/2:MJaQCRUg7A/[Q,X?5
<CS8TXU7Yd7F.f@d7<7d^&RQ#^CI?\LE-(9CVV?K/C[gFB4E9M=aY+W6=X_T>=>_
E#]1<+=#0NAB#3bHHLR3\M0YGY,Vg\FLFf=P>[QJH0-.Q6(7-7Q&\#:B3X89P9_I
[H,74XY\KVFc=T3@2CJ[NBJaU:=.QDRRCGF(W;CI8>Sg7BEWd1==Q8e8ZO9/;YR+
IT>SD@ZVDa\bO_FCeed8gLS;L<))U^EUVOVEY\<4)D=6((]b+KT[fJ:fX.6;N3Qc
_C^&e^U#g2FI4W]4;KI>7Z0P9J4\g0&)P49.<7/@UXGXCAD,JOJBDUL^[3gRa5OA
1;B:ANT+]<[O^-Q(:KTZ<dU<^OAU^>0PRE??gb8A@Q[0\C8,RF)-SJCQ)deFUJ@K
;G\5cVab:@G?F]TJ#IDUZ1\I^=KOZIT1#b^<G8V@#b:.acBSUBQg3AYJIW@F4;4)
>_EF]E_20KE^.8358_fg4+&E/YS_&;2_^T>-,RV_/Y\U=GW)X/J/IY2NdZ?)/?JY
C849D]7TT\c1^616:2M0#(;UeeeIcceJ?,E.VZK75#/aXg8e<C,\SONK6-5PGU/Z
947?fe=_:c1bY<RB>@;C.d0:>&SYCA1MG+]a#^a<#<0K^d5Ib#RU^UL],,FAdS=8
gYUY/MaGIXPS];6SO3WIVDU&g+A:VNK70ML_[#5(:>a7HY.TbRBLF;?1(B\=PD9Q
Q\\F8g2,Ca3F/-RD^G^SdH</\Z->/+ERT.X0T3JF(F<J-0@ecDN7fDdO->GFQeF]
Cag&MD1O02RfR/4XEX9#P41M:-3CKSVH][4ZJ\W?Z:_C@6=49HE71V1?e8D-G/-d
f\)X]OG^M;>H^J,XX_b89I\:acEQ:=[?ZfaXfV69JfS1#V(&QFU_S#-.bAeJCbEP
2]f3J>QY@J5P/454UeX909=]Fd-P.Mg),Z>be6]_A#URT-f<X=48b=cP,eM3-fg[
g5?PQ5QV\6VbD@CRLa&032?WW:K^)5FWUL=7+W^M[;9?>Ea:B2<&+TRP#[8-QN@&
.NJe+QY/F)0.7C(&R)>D2+J9JbDaZ]8V/,DVc=K=@BA:Ac/b]:9;ZD2b7,eEDb_7
S_T@1+feMZaKNKG7G#P^I4[;W8&(#7(MXD=NJ9fX-CcP#NBBP?g#]_QO-fcX4?_S
94ae)+,]+agE8/7O=\?P94c2W]db<:BFcf>ZBE_Dcga+Q97K]K6<EG:0AY(\IOH/
#+eU6-74e(DdXBVT_OFQ\,XdW,T#4eFdEA2[=&UDGMCW35NfL#311WK?<7N2SC0H
[C;Ab)G[^AC@7E;)T7DOIU@b]/?Q9dXYMKIf=0Qe>3aTN/eK)D>SSZLJM:c;=EF&
N^,81,]db#-_PLCDX8^65HZX?2U-5^DH+W@D)?)EeO-]E8].UU-5I>Y6@g[/CaRN
RB#YSPN;7)gY;DZTa1JHE4IJVQKH:T_W[RX,]e5?.HgGG/H_GZ^Ig&5d(L>^Z,gC
2MZ+0H>&WCD1A#V#(d=99UfPHd88&8=XQ)V;+V0UJDITRMgI:R.@\-3W5K)TS=\/
.:HINDge5D>@4/CfYH5H8:Y8:.)c[Ie-N@eHP9SF45XcfIJLVeJ07/@9:GUZ0GG_
W1b+Zc,H8a3_DdPg<C[);=HW8cTN-5Oe+c#7U^RW_@DQXD\DK@SR&8H+0I6<Pb?b
<R:,I_]dCQT2?e6#/S7J@#WN=.&Z\^gF(\;O;\S#@GPGdOQ]=@CQI[;b;CNXLI3W
7TP0VCTHb/AaMY:.b-X[LR[/0U.aC,JGV]\84VQ7K=V,Fg5;b<Wg@fML3HOIP07P
SRg&FYdBU8I4CY7#>9VW155KWWM)KPTVVO3=ZUDDDS;)JQJ),^CEEDAJ9]UJAK.S
>?Tg\,;O@#\:.EB/ZAPT/V:0FNeBZcZDaRJN&Fg/UXF7e]2b7P:WY)MP>WD7#af9
5H&FE5,GO3\]SOS2=8O.I;Mf\YF0-Q(AL0J&ALdYBE0d]_@c8MHSTA4@Ec=LW/-O
7.@OTc.==6<Gb3bGKeU>P;7Je@K6=6^D/Q8TCYLU]_S5\KQ_[F56HMJR=ZgR+f-f
5=4c#\Z,5L^G1N+/6\7HS#dff-e@Y@O(3e1,83bHg2(ZF?\AWD@:7AIN+e9XG(^O
0<S/&>DMO(a9;_K?dG5#6^dCIRdUFb=9D77f;O/G//aP?F;?UdL,/=\5HX.Zf<AJ
N[#X.6L9Y.Z)3UO>18dWLW9/U6Z?J6V[-FJTYN4;<T-<V&#B/(dIFNP(\-YZVPJ;
eS2)&:(FZ5KWaR+dc92X6PfaD-;6d4#6&@U^P8TS.Q,R]<:6)RE2[_b_I:F^CH;<
.Be.SbWG^8b2L5>-2,OUH?,+S0a)GT<VHc8VZPR3eR0R0<UWb-._U<_7#J#_0)(+
I+QZFe6,>_.#F5=-:6RAQ/]+L0J^#O1[G<+&[b@<V8\SG8@/X1(/eVE@ed>G=cG2
^;8(HFVF6@:,1c7DgTeE6WOL@Tg:<IEeEWP9W&:0,cJ^Yb84Z9&41?;N,1MZG5c,
Qf<B[67W;L3S0HN\<Fcf9>7fK.&CJ&:J0b9J4U5KGDe6SO>Y[-bZ=4OGR)f?POK+
FbCIPHPc&2L=?A^-E(6:1D/B#OJ?9c9b>Wg)87_6GQSY/4YVaKI6[8g-6g?._Y+(
3^bWH+DOca_NYI>BEdK\Y/;X)-aJ[B:)V\AD.I6[dN7R=<W=QPLC1+S2W,46V65a
H-eLf?_RY;U&YN_R9P)SLZ\9VHFe=YKSbO0T];-g4C@fcI.<Wb)>=-OgPW0=c4\_
XG[6/d04+YJO;:M=+a:e<bf)(>&b>0.Y#@e5Ig@=eg>^DX#-VcJXdPT7LS3:J9)7
T\A[@+f:bP6.L-;K?8.58W-:&]O+](dcR&e]UcbKB<GF1B/YH67<McK2+ZZ3/3#.
3N5X,@+,;WcB3aE]e1<:^RI^_UX7Da,Q[;>AVg93L4EZIJVK7N-_?<,gK/=N(D1.
H2Z,:H);4UVWHU(#9SN:0TWd/N@KL+5XCUT2X)Sa&7ZOAc&)@NP90AI>&6cMc#@[
XI7d[=BW.6Mf-]H_T+E]I0KY?)_05&ceOG0a2^1#_#1VZJD>[]_J]d23I8BGN&VS
eR(O2;R+2#>7Xd\WZQ\5VA+QJ#^/++04N<b&d\=1@M<B9<=(c7?F?[XMS6\Wfb/<
,60N)S2YX>O^5#9Y+9M0[Qb[[NX8?G8CFB)S@/S(X=O?eM+WE?N9]?L(X/PRO,V8
GZ/]#DOMHMDFDG?W60U_NKC)b<.@5Q\@?Z]]Oe&;B-SV=S@OW\Q&Q8g\5-bT@J;K
0&3H).#3_P)67:3Z-[#SAHcDS4c>]2#GJ,BcfN1cUdU>@_KC#?/;G4^=f,H=:SK(
gA\-MG:?ZVR+]VVPJZ4K?2eM2.F>,Y8SSM=-=-^PJO1\QVB;WMeVJfTdSQB,,TCL
cJM2A25?15^HTS1T/_VJ6N5Ve3NH+,,5KJLRc7c^V;;_<c<[UYPIYNI9<(18gacA
U)BBDC13;YJSQ/(O\EQV2)cM\4e3TadfFKfU)5b^PXaWf[.+TA]BZDN2&3=YAdJG
PYVQc,);5>8<f9:#&dA-HU;#d64Uc@,JH+ULbUGgWe(28L0B;CAHaA=a&YG/dc[V
a\gTbaJ+5-]UdgeaKgEXG^\FX.BGQ22-Q1b#;P^OH9G_^5(17Nd&@HQeV?1N(GS1
5RAXDZcFOY=;1FEdME^K;H(OdF-3GE=Hab86b)<BBF4HMPHd9.WX9=C.->e\]a0]
>H#G_ANMY(\6_S6fW>\We3dU3B:9/>TF[RK@6N^@Z+cJaXc_AJFI&A+QPfF^0?Y#
)#Y3Ke.N<WJbgU+c,VC0Da8Gc&)8JWa>)H7+-5VLZ@B(,N;a&[=7N+N5&XFGAg9_
Y<=DQSBDE;?+3B89-g;Db<-b97CN=V<3Z+6Qg,I^T=RN_[[Lb_V=9)F+gE4Z;a6g
/+:M8--W@(6fRcg16:2)d]/f=cIb]V4F00C\e?W:dec9W.VC@bM?2;S:6L[#XHdV
@KF]gR=G4<L7J7[&LL9JEe:ASe)f1F<7\?^ETRH+M>9)UAbg4#?XLNB@5VJ.O5XX
D_LGf6GO2]DT[13[O1K;IO^+5DOGMY:P.d:NHV/#];_/RJ#<ETN-B0XG/\R7-Q0=
/+.[Z2B][M8P8DM5?X:^de[H;(;,1DQ0/#:.G_(@Cd^\LG;\:P(e)WYO&-Cc6TJ8
g72JSMEXSQT0TN3?c3T&?V8ZK26UUYM>(I-3NJH)<O__30RE9=<R>Ac/]^/6JB5>
Lg+K/ED>0&;6K&;\5U:1dYTL<G5E.Kg4:#V8GWLYTeZg_c+e(8(4^\NUG(K#eaH+
EJ)eA^Ib.+=[a+cdV?NVF:0g1:7BL(=#4L<)e?L=Z)3:VHULRBCVFIHc,UL+]/3g
B5_X&cDN;/38^dfNEAF5.SUXF0WHK]-410)]Y&^\X:-IETT_3SP2L1N8T7@g?_VU
@A+>R]Q56E>#>J2ZE^N\7,&O]aY[#X4N#:/TI<58V\EF))@FF5E6Z0N-6T07WH5]
6\).d?17bFec1FI?Q9Xb#Zg\:S0f3OY#D0L\5Y&I2=RYK<^3Fc__=-QDS.60=P&#
dN3.9BG)N?fD[dcg^NXC.+BN-Q-;K=[DUP-gffE^EY[dGO#R;^1?1)&,.b2,.Y++
3<XP3OHed:4+I.=KX<#?-HKBD&U>XE_#E/ff@2_+QU>.O=7f-XS)H)OPII\dfXIA
E;EDL^_bdOg+,$
`endprotected

`endif

