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

`ifndef GUARD_SVT_TILELINK_SLAVE_TRANSACTION_EXCEPTION_SV
`define GUARD_SVT_TILELINK_SLAVE_TRANSACTION_EXCEPTION_SV

typedef class svt_tilelink_slave_transaction;

// =============================================================================
/**
 * svt_tilelink_slave_transaction Exception
 */
class svt_tilelink_slave_transaction_exception extends svt_exception;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------

  /**
   * A transaction exception identifies the kind of error to be injected
   */
  typedef enum
  {
     RESP_WITHOUT_REQ_ERR, /**< Error injected by Slave to send unknown d_source which was not sampled during a_source. */
     RESPONSE_OPCODE_ERR,  /**< Error injected by Slave to send wrong d_opcode value in response with any Request message. Use variable d_opcode to force d_opcode value. */
     OOO_FIFO_RESP_ERR,    /**< Error injected by Slave to send wrong response  txn, a FIFO mode (supposed to be in-order) in out-of-order. */
     RESP_D_PARAM_ERR,     /**< Error injected by Slave to send wrong d_param value in response for a non-TL-C txn. */
     RESP_D_SIZE_ERR,      /**< Error injected by Slave to send wrong d_size value in response txn, intended value of d_size specified by user. */
     RESP_D_CORRUPT_ERR,   /**< Error injected by Slave to send wrong d_corrupt value in response txn. */
     RESP_D_CNTRL_SIG_ERR, /**< Error injected by Slave to send wrong control signal value in d_channel during burst response, such that the control signal is not identical to rest of the beats. */
     RESP_D_DENIED_SIG_ERR, /**< Error injected by Slave to send wrong d_denied signal value in d_channel during burst response. */
     REQ_B_CNTRL_SIG_ERR, /**< Error injected by Slave to send wrong control signal value in b_channel during burst response, such that the control signal is not identical to rest of the beats. */
     CONCURRENT_CMD_ON_BLK_ERR /**< Error injected by Slave to send Probe or Grant while the response of the other cmd, sent for same Block, is not received. */
  } error_kind_enum;

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  /** Handle to configuration, available for use by constraints. */ 
  svt_tilelink_slave_agent_configuration cfg = null;

  /** Handle to the transaction to which this exception applies, available for use by constraints. */ 
  svt_tilelink_slave_transaction xact = null;

  //----------------------------------------------------------------------------
  // Random Data Properties
  //----------------------------------------------------------------------------

  /** Selects the type of error that will be injected. */
  rand error_kind_enum error_kind = RESP_WITHOUT_REQ_ERR;

  //----------------------------------------------------------------------------
  // Protected Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Local Data Properties
  //----------------------------------------------------------------------------

  /**
   * Variable is used alongside EI name RESP_WITHOUT_REQ_ERR & RESP_D_CNTRL_SIG_ERR to insert user-defined d_source on response channel.
   */
   rand bit[`SVT_TILELINK_SOURCE_WIDTH-1:0] d_source;

  /**
   * Variable is used alongside EIs RESPONSE_OPCODE_ERR & RESP_D_CNTRL_SIG_ERR to insert user-defined d_opcode on response channel.
   */
   rand bit[(`SVT_TILELINK_D_OPCODE_WIDTH-1):0] d_opcode;

  /**
   * Variable is used alongside EI name RESP_D_PARAM_ERR & RESP_D_CNTRL_SIG_ERR to insert user-defined d_param on response channel.
   */
   rand bit[(`SVT_TILELINK_D_PARAM_WIDTH-1):0] d_param;

  /**
   * Variable is used alongside EI name RESP_D_SIZE_ERR & RESP_D_CNTRL_SIG_ERR to insert user-defined d_size on response channel.<br>
   * <b>NOTE :: When d_size is intended to be driven for a higher value than DW while working in TL-UL mode, it is strongly recommended to be used in blocking mode from master-side.<b>
   */
   rand bit[`SVT_TILELINK_SIZE_WIDTH-1:0] d_size;

  /**
   * Variable is used alongside EI RESP_D_CNTRL_SIG_ERR to insert user-defined control signal error on response channel for an ongoing burst response. Control signal selection done based on below values:<br>
   * 'b000: d_opcode control signal error
   * 'b001: d_param control signal error
   * 'b010: d_source control signal error
   * 'b011: d_size control signal error
   * 'b100: d_sink control signal error
   * 'b101: d_denied control signal error
   */
   rand bit[2:0] d_control_sig;

  /**
   * Variable is used alongside EI name RESP_D_CNTRL_SIG_ERR to insert error in user-defined response beat (starting from beat-0) on response channel.
   */
   rand int d_control_sig_beat;

   /**
   * If this variable is set to any integer value greater than cfg.data_width/8, while configuration tl_ul_only_mst is set to 1, <br>
   */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] b_size  = 0;

  /**
   * This variable is used to corrupt b_opcode values. 
   */
  rand bit [`SVT_TILELINK_A_OPCODE_WIDTH-1:0] b_opcode  = 0;

  /**
   * This variable is used to corrupt b_source values. 
   */
  rand bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] b_source  = 0;

  /**
   * This variable is used to corrupt b_address values. 
   */
  rand bit[`SVT_TILELINK_ADDR_WIDTH-1:0] b_addr  = 0;

  /**
   * This variable is used to corrupt b_param values. 
   */
  rand bit [`SVT_TILELINK_B_PARAM_WIDTH-1:0]b_param  = 0;

  /**
   * Variable is used alongside EI REQ_B_CNTRL_SIG_ERR to insert user-defined control signal error on channel-B for an ongoing burst response. Control signal selection done based on below values:<br>
   * 'b000: b_opcode control signal error
   * 'b001: b_param control signal error
   * 'b010: b_source control signal error
   * 'b011: b_size control signal error
   * 'b100: b_addr control signal error
   * 'b101: b_corrupt control signal error
   */
   rand bit[2:0] b_control_sig;

  /**
   * Variable is used alongside EI name REQ_B_CNTRL_SIG_ERR to insert error in user-defined req beat (starting from beat-0) on channel-B.
   */
   rand int b_control_sig_beat;

  //----------------------------------------------------------------------------
  // Constraints
  //----------------------------------------------------------------------------

  /**
   * Valid ranges constraints insure that the exception settings are supported
   * by the Tilelink components.
   */
  constraint valid_ranges {
  // vb_preserve TMPL_TAG1
  // Add user constraints here
  // vb_preserve end
  }

  // vb_preserve TMPL_TAG2
  // Please add all the reasonable block in this preserve section.
  //  - Reasonable constraints should be per field.
  //  - Reasonable constraints nomenclature should be 'reasonable_<fieldname>'.
  // vb_preserve end

  //----------------------------------------------------------------------------
  // Methods
  //----------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_tilelink_slave_transaction_exception)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception instance, passing the appropriate argument
   * values to the <b>svt_exception</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   */
  extern function new(vmm_log log = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception instance, passing the appropriate argument
   * values to the <b>svt_exception</b> parent class.
   *
   * @param name Instance name of the exception.
   */
  extern function new(string name = "svt_tilelink_slave_transaction_exception");
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_slave_transaction_exception)
    `svt_field_object(cfg, `SVT_ALL_ON|`SVT_NOPACK|`SVT_NOCOMPARE|`SVT_REFERENCE, `SVT_HOW_REF)
    `svt_field_object(xact, `SVT_ALL_ON|`SVT_NOPACK|`SVT_NOCOMPARE|`SVT_REFERENCE, `SVT_HOW_REF)
    `svt_field_enum  (error_kind_enum, error_kind, `SVT_ALL_ON)
    `svt_field_int   (d_source,         `SVT_ALL_ON | `SVT_BIN)
    `svt_field_int   (d_opcode,         `SVT_ALL_ON | `SVT_BIN)
    `svt_field_int   (d_param,         `SVT_ALL_ON | `SVT_BIN)
    `svt_field_int   (d_size,         `SVT_ALL_ON | `SVT_HEX)
    `svt_field_int   (d_control_sig,         `SVT_ALL_ON | `SVT_BIN)
    `svt_field_int   (d_control_sig_beat,         `SVT_ALL_ON | `SVT_DEC)
    `svt_field_int   (b_control_sig,         `SVT_ALL_ON | `SVT_BIN)
    `svt_field_int   (b_control_sig_beat,         `SVT_ALL_ON | `SVT_DEC)
    `svt_field_int   (b_source,         `SVT_ALL_ON | `SVT_BIN)
    `svt_field_int   (b_opcode,         `SVT_ALL_ON | `SVT_BIN)
    `svt_field_int   (b_param,         `SVT_ALL_ON | `SVT_BIN)
    `svt_field_int   (b_size,         `SVT_ALL_ON | `SVT_HEX)
    `svt_field_int   (b_addr, `SVT_ALL_ON | `SVT_BIN)
  `svt_data_member_end(svt_tilelink_slave_transaction_exception)

  //----------------------------------------------------------------------------
  /**
   * Method to turn reasonable constraints on/off as a block.
   */
  extern virtual function int reasonable_constraint_mode(bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object used for logging.
   */
  extern function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_slave_transaction_exception.
   */
  extern virtual function vmm_data do_allocate();
`endif

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Compares the object with to, based on the requested compare kind.
   * Differences are placed in diff.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted. Only supported
   * kind value is svt_data::COMPLETE, which results in comparisons of the non-static
   * data members. All other kind values result in a return value of 1.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);
`else
  // ---------------------------------------------------------------------------
  /**
   * Compares the object with rhs.
   *
   * @param rhs Object to be compared against.
   * @param comparer `SVT_XVM(comparer) instance used to accomplish the compare.
   */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Does basic validation of the object contents. Only supported kind values are -1 and
   * `SVT_DATA_TYPE::COMPLETE. Both values result in a COMPLETE compare.
   */
  extern virtual function bit do_is_valid(bit silent = 1, int kind = -1);

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation.
   *
   * @param kind This int indicates the type of byte_size being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in a size calculation based on the
   * non-static fields. All other kind values result in a return value of 0.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset, based on the
   * requested byte_pack kind.
   *
   * @param bytes Buffer that will contain the packed bytes at the end of the operation.
   * @param offset Offset into bytes where the packing is to begin.
   * @param kind This int indicates the type of byte_pack being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * non-static fields being packed and the return of an integer indicating the number of
   * packed bytes. All other kind values result in no change to the buffer contents, and a
   * return value of 0.
   */
  extern virtual function int unsigned do_byte_pack(ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Unpacks the object from the bytes buffer, beginning at offset, based on
   * the requested byte_unpack kind.
   *
   * @param bytes Buffer containing the bytes to be unpacked.
   * @param offset Offset into bytes where the unpacking is to begin.
   * @param len Number of bytes to be unpacked.
   * @param kind This int indicates the type of byte_unpack being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * non-static fields being unpacked and the return of an integer indicating the number of
   * unpacked bytes. All other kind values result in no change to the exception contents,
   * and a return value of 0.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);
`endif

  //----------------------------------------------------------------------------
  /**
   * Checks whether this exception collides with another exception, test_exception.
   */
  extern virtual function int collision(svt_exception test_exception);

  // ---------------------------------------------------------------------------
  /** Returns a string which provides a description of the exception. */
  extern virtual function string get_description();

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>read</i> access to public data members of this class.
   */
  extern virtual function bit get_prop_val(string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>write</i> access to public data members of this class.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);

  // ---------------------------------------------------------------------------
  /**
   * Simple utility used to convert string property value representation into its
   * equivalent 'bit [1023:0]' property value representation. Extended to support
   * encoding of enum values.
   *
   * @param prop_name The name of the property being encoded.
   * @param prop_val_string The string describing the value to be encoded.
   * @param prop_val The bit vector encoding of prop_val_string.
   * @param typ Optional field type used to help in the encode effort.
   *
   * @return The enum value corresponding to the desc.
   */
  extern virtual function bit encode_prop_val(string prop_name, string prop_val_string, ref bit [1023:0] prop_val,
                                              input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * Simple utility used to convert 'bit [1023:0]' property value representation
   * into its equivalent string property value representation. Extended to support
   * decoding of enum values.
   *
   * @param prop_name The name of the property being encoded.
   * @param prop_val_string The string describing the value to be encoded.
   * @param prop_val The bit vector encoding of prop_val_string.
   * @param typ Optional field type used to help in the encode effort.
   *
   * @return The enum value corresponding to the desc.
   */
  extern virtual function bit decode_prop_val(string prop_name, bit [1023:0] prop_val, ref string prop_val_string,
                                              input svt_pattern_data::type_enum typ = svt_pattern_data::UNDEF);

  // ---------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the primitive data fields in the object. The svt_pattern_data::name
   * is set to the corresponding field name, the svt_pattern_data::value is set
   * to 0.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern do_allocate_pattern();

  // ---------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_slave_transaction_exception)
  `vmm_class_factory(svt_tilelink_slave_transaction_exception)
`endif

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

`protected
/QN9^Bg-ICYE=1,2.TUTQ6MOAJMgQEa9#[Y9FKcHb]PV6]5RUe+F4)f]b[QIKG_.
(AeQB6#IDb#3f6?dHed;[&O<-WLga+CQLf_eA6M/4Tba8>5dC\;DRTB<.RF)8N>9
2\_F?7[gd3PcIg2R/Ye]9&P8b)b,/7=()BEHAd?6Xb^:)QE:&)-b0G+7&IdMC7[<
Q/JA8>f?B2IaX9&7Ee?G@(1IVNPN;ND\[2\J@05<3,7)>_,^O#V3.<6)+;dE6[1H
&/0\XS&Y)F:#a0)1cAZ[4K2#Z(.7<7^4<6C>A]#26b:AeE?1,G?\W#E@+;D&,M>H
0f#_5;R\:&XN]RP-&cf)^2F,^1g.CDBX4ccI(VKU?M98LHB<41,RB)M?M<JW;BaD
V:YE1g&5X\dF]^YL&44AO(E[U]g^U)JG@?(T2=26FU>?OU.2G\>?2^OCC6F1U;Of
^DGYe;:Z7Ee+Ae2,:9f.WQLJ<\a+.IN1R0FY^Obcg,N7WJ]0Q4b8TZJ-Y+1Z205<
4KB5\^CHQfL1&LNIMB[P0IdWCU6EgCJW3]X)_3BUO)fNJA=>H8b=X\VIEdCaeW;8
/S9/T9W\3_+UId(eIS(7_+]GgH(3)8ZYS9)ec@47TTa#VNTX9a,YPg<N2gL48=T-
]UIDXMQX)/GLZ^/>>9,/PMVL63/@Q;GZIJ7Q0f/R0G:;>>[8YW[OD+5fE1Z597VCR$
`endprotected


//vcs_vip_protect
`protected
c;]Y36ZReKY>cM281.(U(+5KOGB@I7,>G,^g8M>_(SAZ0_W88MQO6(B]^HG\?5I)
7+(^R7A))d>8c=B:\N.\P9)B6f^(:egVaA(2g?HHg:[C-eBXTY]EUJ/XN4ND#M(#
^3gDP42D+?&^J;OK-9cKc]9(G4R3Bg5NVG#./6bE85@1^+f2?\X?,gP]R&WA@8[#
15OE^[GR?70TM>R?JSV1e9V>??eVMC_6\[ZPH+dVbP?c===bS[f#=?JgUKIb&,C8
Qg/b;)53X&KH8WGEC/\XO9(c./CUbf,.QJXMaf=:WHK>?<2#_&Ue]33[J_?+D[00
LJb4gBU_QE-gY4R2##Bf3U4;KJ[f;L>N05Z(AR(F7Ng(C^;56BD,Ug?T#5=&bPe<
a.:cO_M:]-9E(QLV5BH\cMDX#V&af.&4;UZR_+P,EZR3(MEE0gJb+]_MH)D/A1ca
aA0c^LJ0Z2WF7I=Y<MWF=53ZPKZ#_@^5?I3.H:@CFM/O59XGgcX;MgA?=V?3\)(U
7P\J7S_A+IY.-#9.-QUc/B?&fgL2JVP30FVH//:_I2YU\[JBN+&DN7.&EZXASOOK
&OV96ULN9\PWeDE&TKZTU1Gg#IG#f3_\dcZ_?C#OL1K9?N5Z_WaCg[CYWP/CcT)S
_OT_a?f_+Z:d,J1fVKY/E_+bM0\C@1IEfS5R[.BWMGd2a?.W6PbKZ&8-BT(B2+06
DPZ21(1\LD-KI;eIRcd=1&Q2FcP>65&Rb&)0L_-CTaXQZ>11E>VHb3[P1dF]A7B+
J9/JBGZ=X,]PIg3TVg9;/Q:JG\(_=fYC5GRWLFPC(OH9#5>&&<HX6dPSDe.I^XEe
?@OX&53af5agZDF?c7Z1QGQQ]HO:<R9:-CaNG&B>X4bHHNdG[;LG&N[/NG@[6fPZ
204aFN<M57<H[]/,_J-13g2bDC.4YT6Fe@J:4D(:PHI)(L67-0ZKHP)g/cPe\-JP
G:b9e/X-.gARa8@_.86f5X?TKd,#JCFcGR(<>^afZ#>;(.;KCPbaZIf8HDY+/D]E
\MEU7E6;T@@0TcFM=??B/31c:0E#QB7@73bDN_bLF_3E&)/3<4FYWVdK5X[ID9W1
A_0/UE4PJa]-;-KY;;F2g)d/Y#W1M#PK=9=AM;@(=(-RBGI04f>)dLSPV^>#<^D_
SN?0Q4(T,[DfD+0[O(=f_0?Lc<F-:^UP37G&LeedHS[Y;.H\4CQD-eMYN6I77Y@=
;CWSHWR\OW5dD,X[=4dJ-\43&L+VT5@@e^1Q:b-7cQ1dGgTe59M:Y7&NKdQ?S^CP
E,^;8Wb^?AG\baP_SA#CW&:SLV((<9X^.4c\f_D76<AN3Q)Z?F&.+W[bE\Kd&B=b
#^(11D_6C1XAE0ZR[2Ca;?FNWE(?5YWfeVDU_WbOUaN;<.bD^RY0L56SL>b]JI?=
3a3<QaFa+>2E)8\E4[#CFI8#^Vebg\8BB,P+2U[4^AIA/;E;NO#a=;[&A_d]0]?T
f9KOTR4?MOg,a_-AS8WDa(8N&G#L,_Ra#W^C)X@@CHA=/B7>+b:=B;M3Q0)Zb+L4
M#:9ETHXT0G7DR#&b>#<JGVD3ZA3DTI:ZD]R2;1cPc\I=>_##KR;aF7T<5\E-7K=
YZYJ4dO>#0J,L22#U)F\&+M&@46Y5<DLPLb2R[7874FX[H/9V1#\2NA?MG.<0T_c
(#0We1&.RfcRYUe[&gYK7TP7E)bO8#S^39ZXE^VH3TH;^dg?[E0#U64;1gH\6a)2
EC(6T,46@:\[L8>\M5W.-Q3Q^ZVNLQ:^e.\L#gS>bK8RH,985MBG[KS-X8@3HK<]
)fZFE4Xe5)XJVJW@_6D3\0ND&4OZ966da+D@NPaJ:8?BOPDDI6QOCL(OE-,]D4MP
;]IJe4gO0ZU)1BBPB\XF_aFYeMbTb9WgR57Q[U.FHEdPTH8<c4e\0E3X@@2EHb=6
J.Q7Q>/\4?BD,ZUd:9AcY5]Xd+MR33@Hc_<5GI3UB3I]+[gW72S&g;eUF[<F)?5)
I[<5^fVPMcW>4]W2GJL[H6>b=KNZN=A;a@6R<P=Je<#S/G?J,BgN/[g0WA25Y7/5
ga6+7:GTLO1R1B4X@BaGfU_#F\PZeDT&23<MFUK<2_6.M=VEX2^2[VWgbFP+8I?Y
:]P\9J<HG<gR9eB6Oe;a3g?L@CNZWNWd,H<Tg>9&<ZYZM]>Z&F;D7d6-P.BT@ORJ
LaL&CQaQ/c.d#7==(NTG,]7N_C;_5NA9-4_a@PH/^ZKa/A).d()DSGa/NILJ4037
ZQ.=78HgVDRVH+ZabLU0;6M\g)FTH[cQgSACGXBdI-X5b/-:f3&);C>g9M68bUNb
2PE<EfMOD>M^A:2#eC9OE]\Z+:W9VeA00:W&.1fL6777C>P2FB2VVY#,?VEJY(f2
c8RBgeDVB:2CS=HU]LB_^N734g/?A>B42/Q?#USJ68S)M2-F&@Q)UKOdV>9eNc_U
^MgQBV:c6H\X&715QE<29RM2>9R8c79N=_\VUTB=c:2(GXOJTA-&MA0H4YU_gSCD
(_Y8<\9_EIRBVOUJZK43E[0V\];6EJRb\#K6C?O4\8/I7.L<,+3=c@.MWL#RB9_Y
eU.RNcU4bdY?cE1/#eHQ7>UY;<T41,\IJCZ^,9E77Q-?eBOc_NS,^QYCSX1>#\ZN
#cM5>Q^EcIcI6?,MP)WUX#>&:/H]b\D-OV6Q5@g-PcPI.1f..7eWPA7UTb&T;K0@
&]Te836[U-69V#ebS-egI^(G_329-U0?bRGU,R0JD):TG>/E<#+)5)?YR\SL[UO7
E;(SV[RYfCVM-98=.P2>Sb+E?/3;W1^#C&LgZZeG0>dQ/^[,J=BBNIbO)A<TU-+I
><C9.W[26TLSC_c.I\+Zg)Z1\)IJ?(d13KHLAB\?-U]^>\S?]?:bWa9]d;Y,cJXL
31D=eVJ+W2?5:4dUg=IVE6H^BbYJ3L8KbdV=7eef7(?WU?Mc6&0d6)7JLf6caSF&
FF5b/E_+N2V_Y/V]WCF,INd[MfO,TRc_#ES>YYRaW)FXK6&>8FQ6)-Sgb+d3J3X&
55O1>^2-=-Pb3W8X=Q3=gE]H+2,@P[H&gZC;RXI?gW#6I[FFZ7ce(M#Q++2?=&cF
B>P61J2,bOL;QDX5M;_0PCP&(_Nfg@6RWTV?Z(HS3IQ4(.3(G=D^a?9PP_e^)Y^R
cg8UW(=5X0FL[?[VV?e271MQ1^c:)gFbD3,JV;[,KJXe-S:H/KDdaL7T^4X;2+AO
:JAZZ2U3ge+B5aaSQDGQYeI#&,2;/S^9X\.d?,IT0Kb3O:CO<O,QO?1VM>C[>d+&
0D<E>c=7MIMM;/=>>1f5U_4bYXCgA\bQ>6^\A9XaWWP=KM:.98U263J3.H\HONEO
X071PUaL?eg6C038>/I][FQDIaA(ZWA?(X_aGNC+QaOZ8,cMNJ820;2Z=]@A6&cN
?W&<&97aX(Y0QW^R^^U9GC2Je.^@(@9,aE?d1>-.^ON_OH>JWJ3VW.P87&@2]1A<
[ES[B23e17)WY-JB0TUW=ZL\]C:1C]NH0I>1g4_e<=4JKWdZ70.897@8QD88Ec>V
2W1HI<Pg7^(7(^=[OR3JOSXXCab5V89(8M_:B#TI]_V5Z-_N1I9EVcS50Q\7bV./
2Ta8N7>TOV0d&GTHg3Rb/LGKdCLe7]97FL+&QSQG_[F+MfOgSGPDdTOc]8F+5R[T
baXJ0?\&CSMU)VKb?WfT?VbW^>IU_H;?Wg6FI.aLXaEE,2OQ[HBC4-)-F:076ZCE
:2XE(>_46Z]JKcBcXPA0?:DFTQI5eG,U?GBU1bg450>b&VB=g[6?E>fE<ZH5Cf?E
g.M=S6FXT>3LVG/84,WccJVeQ\&(Yd#(B<XR,ZLG@OWL9b#HS9T9:^gSAfOC571G
4X6CMJESa7[<N9,@+MgD/a6RH805JRPR^EV@g2Y5ZgUA:X18)LAI>b=W1PEZDef.
H#d;f)\&\UZ&05\G.^+PdA6E=U[ZC2R6@U<B068IdZ7(EUE0-[7QL85L/DGVd;56
S.WbUD,+bWf;.?&cf6aC,R#W^8,>?-&g9RVGe&XPOU_.R0EH^>G\:UK5]7?BK4&C
,Ya;e)H.<0TAf5F^LLR#@X?&I1<U3.Ic+]9VaF&^M.Q?T(Y&MYRb3L_2#_9&PLg,
-<Qa4J\29&,[<W5P24AF^B=;#P2ASZ.Z;Rg[<.?2]aFX4QU]<Ab^3c_\+?.ND)g@
G<)RRF/3eQSfMV;\TNVSNFGbG8(JR5.b67&BDb+,;ISM+64:HdBKZK9c^d?@<1^7
<ZXd>]b]LPX7+eJ6gS5YbY).(Q=95[e68ZXL\:7^]A2X0[Zb;K/W;I4Dd1:JaRNS
,[BdV5gQ#7V:=,OgG-\=[H8=[RV)0VPA\QQ0V0)>Y^&:VDca-O+I4d9XS,.facNT
9R7.4.[HG2.=G<cZDa+\;WaG=I\=VH-7F+J,c==<9.CWI@+H5Z:aR_W]X_V2Ac[C
+Q=UH/I-[)7R>a5AWDN>fZga+DFH>L6&58=b\)?ZXYON.L?O7RWWP]I<]PD@EUIc
52RcTT/+ZO#&O6/EAc.ETTS&^dQQ(GUE^_b(A\/U-3bCd_N#)=3eO[aK.U6.Zf^>
fW9c(2C)>9N6X3_S@aQ)UQEGKNeENRB40Ya)]&^c4XJ2ZZI9,(F,0eA&MM5[_>0W
YREBB;IE3/9NMX_;?b)^I_POP.))5(LdEO8L+FO)O/BV8<^-DM->eGcM=\Z=?04H
Cc;?,0H#N1KABK-0AQD^0L#23[^_N2#W\5&#.F^J3(S8[R2_7(c@J?a#[>Y-RBN6
a+A1#>LM8T:V-4&.JY;YZ6N->_;QWa[FDB^<I)83>gfTY]DTQ&8?Ie8dD?e-+3QE
6c.IY.&9/QYB3K3aA53N.RN.S\]775fTKaQYWe7dXU.?]O9G:ESJG3#1@(540cMH
7+N/^&^9b,;eE++VL/Bc+QgVN<QIUTacXC31.(6B0K#8G(3NU09MNRCD2\6d2^bK
eU6T4bQQX>>N@Ne+,\#Y-CO@E7fcQ0=57IX4[eRQ&CVUeR8DS2Je:1]\3UAM<[9X
#aW&OO(5;::R7c4R).gRV(a7cF,SdW/If;V=,.d(1T@CMc6NFR;Fa-_CT\8Za,f7
)bY85@+W:\LXGTNMcE>?I7e8aC5FJ4(cEaQ.75GK2P[gg&JKZ,WX)A./9KW3=U>L
_801L_@DQPXe@L[17-gBL)8M:;-b9Z@^;7+R[IW\--F7dBX;A,TUJ&g(#NVRFKJ2
_W5@,F+??Z(LPN2ULRAIfAecV<CSL(B?K+)+FW+,RObYO?CD7[(GK;]M4+Q8<BeY
>>E&ed/Mc(M&RI-1,S81_(bPX@;Fg0T5AF+D:BD+GfGUcSD)4K1:cJfS[@?]CbGS
5/FVD\Q=6X=L>2U?b72VWH^J-,Ie74S_f65HXD3@0^N1):_c^:,3Ce4g.SMIEW>&
Q9NeJ_NK^=NZIQ?#1;I^[AN7@aP]6]DC)d+eV65U3P\b/LU#:CEVUc(U9V2_OD+K
3(&e\<@YT@d8QVf[8U^:G794gg^agEH>=E0<BCR7\[9+c1F(OI2A@Z>+:1>A#e#\
2b]B<NaY^WCg@>922QZ,I?85T_HY3U#AA<W,P1_0Q<K-(PE8FS2,K.0:^)[B)[TZ
??&_IgK\^1#]5TA7NI@]4\O)fT7e/;1BY;cCVe(S?;c5aALU+D?/X\BXG.C99DdQ
WG/cWP[-?-.QAC,7;<N0/R&D2DHXBeeIX1b8f(#2.e](7N<7b;9)4ES#OUA;J<R<
OY8Y]+<+,N:d_SPMIKY.I^G\OEV10#fVN8?DB2OG:^YLI9fH9.Zg2J>X?>U\d8PA
B614cWfTGW74RL<T43YTWLg7@If-:EX1BHb;Gd8V)56CO:Kd(K&GDM:cRAI_,,4-
P?D(UO.KWIA?89:KZd38QOL&B)?5d\c5,F2?XWaC1gER7c06;AZ\\#CH6.3fV8dW
<]R\CGLO2-OdcI>#9Oea)-R^f-E]PZdV+5RBgTL^T\K5+#GN(GI>.@fOD>>KgSFS
ON+C)I1JNLeb:?/IA:P9+8,^L3E6E2C37,1HP&0Jda,b2AGUQ,Z2+#<9<gfK-^L/
K5]6b\R17>B7NDZUX#2-(U28GcBb;8ELd-N)a1]6gfL^9=AQNaMBB1FK]OHX26J)
.&N2A@CCIT8J[O@9W@O_0N[E.EKYL<77L)IeATEGN/_;Mc<MS0#O:M7#DZ-A8K:c
+G:P7C/Yc(\2:=<#<2Qc525P/(d-6;8L;C[\LOgM0R?=#9YP<VZH)F]?;AU(YXHF
@13-5;J4<4[:[VNN7FH7.B#PGANCETaS1?U1+bNJf3c.gSf+?g#0Uf@+W7^W:8[H
;QEe13,0gY:OgcVfB&:RA_^GeO-D^/&=8g#(>3MCf)R_RVEeF^(Y\N]@ZZ[cSf=4
DIeWH8&CBX//;5IYcR6LeU.P1P@BdJ?4<[7:G3Pd8cQA&(<EH4g);.#ZKd.BgT<H
[C@ECY_=J4AB_#-GDGE;2@AR,>C@d>G13RG,a6[cP/f.eO.L]5GUb-R<7;OM_0bN
ZAg&KcP,DD-OA<+X980c[N=@/SNZP.bSPa3T9Z,YV7G8L1[72VLdU-/PO8;:28/8
E5fM@@^^1-N;3AE/\JG3D\#5BR<SA>_5Nb#WE(\7YcgD]6TYB\JE.0L+XP?+PO1e
XBO_DABIEIc_]A:C/8@<7,K1EceP;XCJB:0&7:MQSH+>U(9ZcHN7J1KM;XfX#5(#
H&WZH>DIO0BcW-S([Y?(/\bcH8G]7e#R]NGW_L5<3-JL,K33<K-/NWY4P/GSV3Fb
N27M1FGQJ8>,7//_#33^fb\M>LY:A^PK(L0N9[RG13f]LF\@=TY?/HT5:LZ-^B4V
d_FdTc1f@@;EIc0BUF,GaXPFcJ)/7:Ae:W4AFRWL7/RB(fVKc<^YBbT+&K8Kc9g?
,Z2\Q-I4([?7S&&Ye)0V9.aDP3W1:1\Sf8d_^@;J8L-[W;e#CC+U1R?^)g<XcIe;
g4+6O:dbZ:Y?(AI<]3AGT)8?67?6HX<21a0V<&UX@H+VcB8X;]AHd,S]-W^T+92;
?-.5/^;3XYX,PBO^I+,>e0E#M9E_()7X:&X1SH@EbCb;5<KC_BI,Q=Y;77+_S2Z2
(J&HfD:A]E=4+Yc5KOO_f)5fFAWU5POL\/cQKLL-U.I8Q/SS@(^BI--TJ?^VdR#f
D30J5D5YUN1baS0B[E14c@)&;]>&S@Z3ZW-KLD\Q9Ad23K2G3?UT93\=#\P8QE&;
[K<;>Q@HAa0/f]]YfOBNIIBXf78]0IUQ\cW\@UCCYNN;:KScH>>5^-W,Q9^-R-&&
E8<[X(#=T3ZgW4;WUN-^f0e>:KCH8NL[NRT^6d\0NL5:N,I[6LA8Z<CdLX.?aAcU
/<8VdO<DMGdJQD\:6f_GL87Y3,CD&U8=T1E.YH0C]W3TZHBggHMFA^E;X[g/0=@T
:JS<OYU>I-PXe\ABUaW4dI)],>4<AM?KP,R[=D<R&>#CA?WK2GI7VQJS#DS<?X6H
R;2+B/19d\TVeE&dNZ.gJSGYMAJ3Q/Y+=5KEIXB3R0XSb.8>]M0+_dRI39:6)/AX
c_R)<MSBY\A20DU:QQMN(MKL?Pc&HeDJ;R2[;4NZ1BEO-B/.B(>Q;aK149W,/YW(
c4ZTYS2#6<EC?+a[4-7S8+gd:eM5.5/X=J1T1C^6>(aG;S[L@Qb-X)L3EH,9MW>1
0(D5=+K,.(:5X,+X2M#QTI<(Yge?RG7SNCCf@3KC>9EZe:5J@aTC,.>9cR>Je6YP
,9PPKbaUR]#8<JVB\CE0N+;ZDBg;SMf^1[J>WX)_EMb-:D9F_CM5C/MUYWF&K6\G
&));>WPX:[RSCR4f>AJK^)VXb4g23)DT&L>cLfN:Kd6Fc#.>e<USd/29(dWHS?@Y
MK@^FLKIRVL^U\^1MQZ6P4KNGTdWdaV[B>TUXU2>H/2.^[[FBJ+W0f,ecCcW_L;6
;_/g;:OD]8FSK=,S9YEf7Nc:Wc14WX)X+3^M>Y,80XS/O=a[YdZBb)KK?TeA][OI
2R@eE2gB627C.0e[3\Y(A^\:07/OHQ?<UBJfOBgV0,+F#-g+(0A>e(MD,>#Q,>eV
;]RX78OBDVBL0+a.c1E^FCB-gU2#N)&QR[,AG?(_V>1)E8C^L28JSK.?KaJ)M;dW
J\4d;Qga2e6P&+YHU\T-1MKG;1g+;?B_cYbE?ADJEe.W]J^CY[+)@-Hc,J:EJJfL
O^CODMZ(+T>.Q#2?e/6?A6:=[EEfI2EF]c(_cDb?^E+LTVJW=OdN:RU6W;FAGC_-
GCc(GNQd>2OTBCH?#:5QMR&TK[b6D@G:7>5NJLR@W_R3RgM20VNVSN5<0I0/^_Vg
.JZ0/fNeF]H5KR[>]:J>ZI]BLID:e;0b8]P3:/02JQ:IP@H6f1FJ8#@33V0K.+NY
Ug-5Ud:V.Gc]<JI6DfO^7/&S07?WR)T^(;#-,8ZfRX\6;_W<PVR;TU>&9;1[5b4/
gO?TZ<HHWL\^E4EGPWN;OEL+WHGZfc76NC_09N=4&(aVL7#+(XN1TW;a[OI=7/AN
H/P0MeEg\^+:BF]4SNT<(G?.-VKQOQ+=8eY,Z,K\L#d7BTdQ(fFS#F_S)#cKE(Wf
9.(V=GX704;J[D@)bL-U/HO),G&E-_V#D.W);Qbg,AVCKg,d4B7X[?FUIb21g-21
4,b<9-V<H.#1Y-bB?=QXaaSYFZg.2c-&4T:H_.SW6JP_A7>JLOZY3<bLFaOI98WD
OgU98<TUTX>Q#]0cE0K2e+:99I-EgMEP/@^V,P^8R4#XQSSIW2[cUcOJ:>Pc\1gA
WWZgJFc^6Q#5=B,_PMe]WSNZ&<S-+f32a^1DR]NHa#5+2M=@0[aUDOT4+K+_D=[b
47<dS[M\-,#g3Y-^?&ODb]f/Q3#]A@^.(K4]E5SW>T.1O6I4bCJgJ^+MNB)8g^]Z
0WEM.a4?6J1Q9#J\LW45f-\QBF/+O)-bf;&B/OV3NA6\&3We.AF=D-4=YbbAG]g?
S;(+8+)M3YPG5(IHDg29RFb2DUMV#dT;(GZYUd.cSS3]c(^8B#4JBJfcaFeQG1:H
4EZ-(fH1)<@fd,db50:6V\HFLaYU);/C7_K:.B2U8BM(V)\.N3.27L>L:\SI?TP@
38\<7OTN;69]=e+N[_JN4ZW5Q6HF;eE<dOD#g&d&ZBY=JO+LB/01?Og=)QOT,=fH
&aaX28F.@YC(/R/bbHN\<\HaEX2L3TB8OKXeeY9E&(MM+#c3,^MO[4UVH&A_6f^@
Z<4fSM.daK3aDG3dU<2c@YFV]\EAW+?+DG-7cN5.GNZB;IX=4c?g\OVAERAS_4WM
#V@#N:DfUfB0\2bB[b\_ZMPNfHV8Q[Y.f4aSZN:^6ea>/0^BGe^FL.B,MK?7#gDL
,]C5C]R=SHfZDK13=KK:6fOT@BOe:3LRU&G\aHO><d^JdT#VM+F/_>6&cA=30=B[
)IAfCDUB[5>.N8dJ?a=gY,;+1,[G40FG<Y.UJ3=W,/4.aV_]3.[bGCA,REVKKZ@:
U,I)QX\Ub#Zg?D<NUgVXEA5/HR)<#,=g<X5M4Z>,<<(fdU#dDC0@(KF:S;1(6Q75
ScOF8:2=CSA&]5YI9E2I\B7/MA&a710QHMI2Jd26+D3CAYNB63U6;EL9V-4g:1L7
NFQ?X5ddSIV-g?3]&,3g82#,>)^a=XJD]0\g#\R_;Jb8MS,.X:8)cf\CD3Q[1+10
dFYP[\E660\g86=.:.\TX_>GRg+J3N\Gb\Pe0\Q.GZP>50H\R.bV<T739Sg=[XTW
9BfaUM9b2+RXIg[14,Y.ZCc)@/-+HM<=?gL4EU(ca#Y/@g-7TX^afRTMZZ76)<M4
R/#X7J&OfWOeH,\@<e[_B8->?2I,Ua;dGF<VAd/@U/&#/RY#bV]AHWg1^Ag.Gc8:
)__/Z+gQ5NEK=CSg+HPL=TfdYL5&JABY>3PWd8L1M<N4NY(R94bV_>&[BS>:?]FJ
.2OS-]bQ9QSdU@VC[WV++AIB9XPb#=eD&QX@<NBNOdUd^#RI6g_bPK@E<3RTcBXN
g2Z=e]GG[EV2cf@=d18&RWC7)>aa/bf][IG\8TYIM2eHLM1OaAMJ)eNSH;2/,L\M
[ZM=V@T&61<J/_SWa((4K_agVMIGDY3PQ#EX9=NGO0e]KN-F;.R1V1eUb25YK<f@
L8U(#:/>0(B)61)?Y7ac()GQa[Z\?b]:&V;_SM8@E5DE-KFB\,VAC.,b)XY]?dM1
>?=,D^.EgW6QdG[5QTXJ?-WXALX)Jd9D=^E:D&M+L]8Q-?b8a@NaJ1XS5I?/=bE<
SNbUe,)S&S)c3T3B]bNN@SGdIKU>\_RW1/.d[A&@N\;<,+B[7=H3V#d5[Q4S8S1M
8)<R:T@E8eBU15YeX^AH#)RJZZ?5RF03b@Z7<bUDK>b#A&Pe^Bf0Z]J^MFT48EBE
GDIJ)K>L-gg[G9_OLH+-H=1S5b(.ZATX+F-J_>3SLY)\ZVEfE:SX5BPZSB\?P([[
f_@d>3?eWQZb<I:+d=B)PN>EZM;R@JPbP)8,>BQI@ARN;Sb5(WUQUZ[;@WSMPc77
V;+(75N\UgVf[FO4gAQa<[#CQB+PU/,gH=G:f7G;LHe(ZJQW^B1<(<WEf,eY0e77
J3dO28WU85Z628#<U[_G(M5gQYg_J^.(C@ffffK;M2:+DLe=?\ERZ/1[T(P-gNcL
/2HP4F@bN3DP5Z-1d[.6g@XT)G=5(/H8/P_ed\89N1AB>Z2aIbWU272U?18PFU#)
+EW&c7^NQ+ZQXPARVE+-Gc.Gg-VC8-BbAZa-T>[S(CO<ZR<<@VcRG0:J4f5LUB\b
fIVY26;O22SJ5Ga[,ZCXDaeDYW>.g0@]#0.=5W\eMa56;5G5eVOU#@f&+b-M4Z8/
=LO?B9b)ff@?H(Y[KA_42FXL[E3Fa2N92;[=fE7(&2YNR/dQARaP1&O.Lb7dYd6[
ZEUQfSZ&T&KbAD7a1R?[#_8YEU6&F],)1W)?7c.5J:CXEJc5G96GGM8URFQa:-=(
?[SOgJC=\dN-2(4>U,VeZ09V4,aH+6_&S&X7_:?#&_YE)Q:@D,7[CEWP<NBf9-=P
E(O+T34&J8IX(AMR31((_@N1YF>B?EQ^DZ;9^UV;[Pg)N=Y?9C7C+_@U]IR5c57c
Z[Z(Y:DM2\]=NRP3[5[TOOWF[Bc.PS\S@Ca[V.DED9W?8WM/&F[>?OIVe002J676
A-@I91^e(ARKY/ea]7&]Pd1H-+TK.IK[XOBX]1\A?O)R=^Me\OQB96EU-2+(8^eI
<W/6][)A>dZg4f7_RQfCM-3]9(4fY=g.>.fCGZ@JY6A21LFY54=eGJD&C6Y@L[eQ
P9\A5)5\74S(eC(,?#O.Ab&ZgB12@)#TBTgXQcOD>G#6&eaAe=R9NQN_-0#Q9T;A
R5,-.8G&NS-E&ZXFL/WX0)IS5/N&\a^/51)5aV])<DM&QAG7Xf=XIFc-_@cLYe/N
_@0TM-d/5R]cOBc^FH0>>JEHfaf)bY>U\.X&7@#MONeWeWSb[=+84b.JOb0)3da.
]G=_7,:D1[WS6W9KLK>N.1/E4?V;1OC&ebIfe9H#b4C#+MOdXB[GF#LW\C.2LEQ)
91OBTEfJ\2.2?dSFLL6(11&[T.7=[>C/]H0;<7Q,Z:B6_C2^N0H>S_?e;2f+_GH(
SdQA#<IQg#PdM70V(DbId._EHV13;2EPB98KXgbKQT,)41WKT?LGJ5#=R+B,;6T\
C3;P)b1EKOb8MZ+ISXaf5e=VC@\OZV4/&7XCY/)YDe]0#f\_aD+EdLLf=)3G9e=_
L?\TBHUJW2):A]cSGXDA;&Q[088bC>Hg/ag#OC&Z8VGB_S>0WNE3_SATb;L8-I6=
Z5^^^:CJSBUN<]E4IIJM7V1J<<]+_<B6QEYC=Q]/VW)9a6[1fD1e0WL,26H)T2A^
4g[?7+O]PafOcM/@bdQH\K(\I#=M>YV>5eAJ0/P/62T6gJ/-G=E+>49Z(W;R^;5)
PA8bW?CE-]L#IdJTF6=P+5@ARG#U&@aWXE<aW]7=<OOc;5@\]BF)5A+6;RHDcOf-
,XcF@^8><QCd4Idg;cOEB-9Z1VO9JR]HFHS(,@dWW##6_UA,N-)VFfVBZQDb9>\(
H;(9NK[@CP:LJ,B51A,16L;bb+57>TTE\FHXHdg+WDGO#S\ZE9=_43.W(Hd-U?=#
3D(P>8<:bWUPO;L1S2V/NUE7WORE5daZ_VZR#R^P\[=SCfM9[AGX_A^]-:R.[+-[
dgZDPgUc-53:c)SL(NXC:N4/JZFH,a/ATR?TC2.VXa7[#V7G>-@SfF:gdSO&1C]<
7RJHTMg7^<Ac@Cb4eU:53HTD)5L-(<bMBET&9Wd2B_F^2GYHZ@QG/aAdW]6(9^Y7
Q1#4TO4)TM4A,bAOKIT8@J2/O3S]QgHfbA;>)FT1,KBe<K\\5BGaN;Z5T<19XK6J
Cb>U4,N<GEDXC9>W@WY/(>+F8-V)ORTe&aDfS<0@cMef](\M.;?1d<2<Q[MVDIaR
DbF9(M6ES@_TR/R-1:EK^7/WMX^-O&Ve9@ND=<bIP;dZYdVNBEA3e<SFN;#->MV2
##W;d\33APCgd)?FaYZ->Bc8O#.D@eZf^=fg6/Y@#&C,\7S^M5edCZHUE&a8@Na2
Q>.^@W>^Eg\ZE0YXf&YXd+=4MHf;d]#2S?<L<eK/BC+>TETNU8]Cd_5^d9KZ-H<S
aV3a6&R>eNFH>0/2K;UHE5g+U][WU5g.bE<_L/)10<[5LX8fL9\S^#BNFAWX;[W;
=491UdB.)aB&^DAORNV=U+>XA@5&M]@ZYQ_X-0;6_CRO>BHC@:[#>T,/Z5LCd\EH
e(L,R4<Z[<.g)<=7S8I)4aK&#;IGK)C7UeC-[7)e3/[DP@HWVJ)MJZE<f_=AKc[@
HZAK#Y3/@].1aEYR_UaP@#3\:MHcYeP(9?KYU<&)6<,E&b#4^I[\ODRX&D&ABEV5
&2?aZ#=15dddg(@d)(ZbeW1#,Z&=(J8a(UQMQ\]\RDf7)JR4S)ZaRK_/X_[H>>S;
Gg/_JC43efHdU?2aB+,8)^ST+M6AR71B4XV13-ZLE0:VAL;gZRMCBL7Jga^H];Z.
]8LFeS[D5SGNZe).B-V;.BP/RQ])6/P-O?8R-5]GbK<c_25AL^2U=aP5JgTUV;-R
/YOADY@c0V,_IDYX\V4HWIN>+FFg;^ZE\DA<ZQLJfe-PX0Z#ES<GFPW?0FgSXG:.
ZHCTC#>2)/_dWSd.c\;^E7)9TbeBD\a3:R)(D;N=@geb@<OO9])J(VOPR\EVZJLC
/XWbWT6#Lf4CeK[U-DYW;eGP<(b>2SfNd\)YC1@g[W+OYB^SDSIM;I\KH(.e3^2-
EZbXOU3S/f]R[]cBZTY>/_.GW:6KSD5H-5;5\e.E2MBa^(<_#aZ4X:M8HXT?2RML
?)F;3F:HLFE8X5A2cL/JV[8_G?9)DOHO[^MBd?W4#d7&W52=V/SDG:Ie.bV3d.6f
;LeS?cT-E?CaH@O?,TF]=M?[8cHEM>M&T5>#L8fdP=e;@@9^aAKH,M0Jfc(e0(_b
N0-R4),9ZMQ-UU4ZcPO=<DZN).8H02U^_2KG^Y9#>ZLBQ>OZ,?f0-S;+?R[8KW@Y
^JGS:JR11\&1f<Y\L+4D@1e@-5;==e_E)V3G0UK(He)N\F-B89NJOO>Fe9e&K^SH
G+Hcd3;Y5KE#SA\c<^Z[dLWAU;SHCf6#5G=WfW\UVeD+@^9YY7EUO;@(OE>0OfPG
S>U--]-&dEfB:[SD,.(23D,78J_EV>-YU&W[(G8HK;00NQHR9Zd5BPYfP@I_;fQ,
1K_ZHKF^eg8d4]7L^VV#L0:g)Le2WbTfg;7gD[[,RE+cV=+T7&2>ZC[KI1ee:/HH
cUR;)RbV^/.?6a?:KX.?+?.ZX:E)Z+XOUC#.)@AbS]?]e>HH.FS/=+.IHSf4g<K4
GH3=58RQ,M\g90)#=TQc-HWT53gU&Gc\8N-2CQZegH?74ccD[0?MZRg9+(:DD/=]
)TEf40A0e&[[DH7MXWQU>)WWDOVQ)(Nfc/=M4TUbBI6e.I2(&a&f)8OH@cRWOM=1
I<d#,0:4P?N^fcUf]Z:5TD_+55B-I4>e&)a28M4ENAF,2DT7SCf#554K304[/eVU
7.7,XZGXE<?fD04H)V3)OF_/?ggbg1X(((-P-4]WU=K9e/9NHf8]]d7,&KPH>7ZY
]DT(>SM0448H@5UD?[Z^\5b6_:f;)(()?GE>>CU1CD.Q0/GOQ?bM^PHdY_9b4M@X
(LROP;8HT/R4a3U:J(0=)-:KG\J]ZN+<KW>VLSHU0D8c1:N._#YQK1:?#F;:BO5(
>@eT8gFX8,TLH^Y:Z4?UX#fBHQJYA]/X5b/1YTdeKRLHX]TaVV2d;a0RRN1.1A4?
5BU\:50U_;5GE=,BP8<Pg6@7S5aJ8PX@dGIQea8:<3Mb3?A-;EQJ55#fSH;<T\?A
B:R)Z7>ZB0bO4b(c/KIfCQD,BXUg-ALdRH(NZIM6\VRU\5KF)2,,Zc&)@3\bK8P9
[[DS/4.]3:CWZ<]]RV2f8:YHD/)Y6fL2I@([K6]-B3Z=?VTY>+Wg?X-85V_P6V6-
.8N.JW?Z3_U^(=FJ_ERLL@50Kg;:2TN4:\_4]=_CbS5T+,/R6G@O<MT;#;XORa3C
&edP]C(WVUP(&;#Z;XYND_BZ21A4dAU8??e@XF/e-2NO,YNDXc>L7H/8VVC^1_\1
>C<\/2ZJG\WCf?4B]fb0D43PA/>Q?QT(T_?#^>aW5#\.B)R[?ZCC.A3bVXYTeIXV
Z/#M2/F=[Nb1dZ8A;Zde9/Y8N6OBJfV?=NH-#\\Egc+:YKI>&X:1]6CE@bT&LQ=4
a7:O2HLgg16TWI[c(.1JC#(FL)F4-gc_PNWA_(1;9+ZJTDT7YF(gY\\J_U3@DLTc
/NQKMa,WTLW.1XZ(UM::B:7KV<<9D[M59c6B?7/.@T/.Z_a(.WM)JOG;#:G)eWe.
b/aOEN-_4:W;:>9/NQ]5_\cWGZ?a6\NaRB7J.@EWe+R.\,JLg4+b^eKW]UMLR4>M
edd=56T3d.N1d;PR-61gc[M8-WEZD@aHG96?O(KN\Q0,S-/(gXV_E.E-@LHVaAf_
Xg[C?()7;4D>4Ieg#?Nf?feGe(VL1ST4=],gbO,>]9I>T/ZV6<+GCZPDK&+-9M[_
eDgW7Q;CWQC@g?.SO=EZcC5L[.cDS[\DXbH.5d&28?=E6>.8=\aQ)5Qc5c7#EXNS
+G?7X)-,R_?IT<-]83_L^7R3U6Fe+8-/9RM,bNT9[Q..BT,IBU0:WV#G.&944>5&
W9?fHC48TH_eS(4TRGgaeA0K&=gb&S[^S47X1eZSX?;acedS<IL6@,Qf271#SFK;
&fYY_QVUb2F\OEQ;R@&7\IDT&FX1IH5Id2?#)00U^bU)VU^B)^G=gX5/f+C)29P+
]UH+#W&dCLDJ9dgY-W6H[Xf?0()E/&GZc?U;V-37W[Ff<0:^?ZQS3g<4/=8WV@E]
4&X]P99Qg#V.B;LR@/5U6f=/<Y\ITDUdB-.b]GAc\MU)->U49L]1W@aB6(7P+;=&
Y-aJ+Y:1g8c0(YF=^DNb-MNBF2U&PX+6>D7W.f.dK9/;@8FRMaY;Q=Ra&dCO8f5_
f+B)]bZgB_.W&_g<U@L?C8^:B?3UCFDe2L>d+5Qe0B?+Sa^-.OQ=+AeTCZN\d3NI
UPadcJ)DXI#05d<A+T=WEJPY]AZ<M3_^ST4OF87-bBaNE7a7=dce>QV/R+),MLWO
SB9KE92&X6COU7IdU(>O[WK9;1MD1KJ_D?:d2d@9B+Nf\L7Peb:QM;6#@U84?,@?
E:WZAUM\\ZAS4Id8H+6+MLNVX1]6dd,A2;]b8E)84X,9J,\T@P,KVcaGB)bLR?,5
,?UedNRYCSYM/6YF]<(LIc3PR65S1M@S6=bS\B/TLQ9&LbOVUDZTN6\3LNVf/;O@
_5,bJOAY9E5V,HB=CKXE:eQ<W/b1He^@3171E91Q(gb-J6+NG>B12R<W>IDF7\g]
YbPHI&PFAOYYA<21M\gJ@>U0));P-Z2ID\<T,<SVb0QHB7:A_EN?9Y@VM4dbHY_e
g?O.bD>T?X-&\K<+YIb[+\>Y]EU0SI^U]->9PA81@3DWA^M3MX@NdF=DR8NMC,Eb
Y2O_E-BZ#H:S@6M:IZNX<UZ8@RR1WM>42g@<_VJ(J]Q=&ZcJ#gAbfW+H8^.dFbWB
5L3;/F1@D/8,HV>A?Jb-]IWY\:FfJZ-8d>5&QKYX6Lb>9dHbbJ\VR<4/@N3@0<QD
6V=.269Y^8I57D6;.J/W9c-8S2QCR2]#TELYFd#4g0fS7dJ,ORa\AAH1K)VdcD(6
LE,YX9JSQdWLI-LU;QL7D]GU8b@G#S7ad/+JA<-7.J9?LQ8VK@0bX?KdP+e#?JK@
9-?K@?^6W#gRMLFMNDEfP2b@IcJNMWHTLU?4U.7X08UUc(Sg0aJ35TQ(c(PX)?PB
_DBF+L44QU)FCTL?OYPGK)U+4=+&@=:^<\IDM8.&)<[?&[@TL)YS=WZSRV;[WL)\
0C^2Qe>:.V[&P;+3W)6Y(7?)9T6\X&4aV8S(<E&[E6C3W\<4-2f(4aPM[5bbWZ;3
O2b4e1F4[DB6Q]T\bX^UFXQ4[_Y^.YL]Wc@c_-Xgf0Xg\b)dC@AT@:BfHK<>>#-I
X?C9M^JeK9f)e1:J4HW?[J_+gIN]cUMB9,/BO&0MA,12.6<[\(M)#20\Bb#-@TGe
]UgZ0)cD\=77K7c+EfY;A>/&;:8JI/cU,I1\8R5LERCV2Xe21.cRe0M;\]V_9,aJ
&c/;CP#BIF,3A8L<YCAL18aQRC@\>;U^1I>1.]J7B0&=B4RgPb]X?EO^PR@TPVE7
0AE_B<@E[JK\^e[M[(QL_dM7b9(^<^#7C^S>GgI](3H44[>LPST-:V75fFIgS]W4
#TP=VC<0(70dRYd]KPJAe4;R@((0>ZV[LW=U2dH5K,;f16971+^]W]TTYQ&a0-0Q
U(fe2f;4PRY6R]&39H.\\d==3UK,#4g[BVVGaf54[70)b)gE3W2;ECXT[\_P\-9.
.-82<54KCH;)I44RO-H^CQT8E7YYU(MY9OgKH.41C6@>EH#3HFY+PeP]5,>f>fK\
K6;GO41eMQFCN;^3IC6H0@]a(A+1N#JKAACEeTNZ9KN6-Q<2_#S2&;1F<[>&H@>Y
<IOH&)5?P0NZLQ+U5PW&bIA_(V0L6O&e&;J(U\:VNP+<QMN.Ag^_M:ga^aCOVF&&
6MVP:>+.IT6VHPRTM+Q478NS[/MP.\fEVP,)N)2FKO[PYP#FI[K_5K)V#SG3.g8Y
b;8<6TFYA\,,03]AU0EEGIBaUd81Q<[Y?&f,1+_T=^UYR6&fI9:CRHa?c-SNLH;e
@9d[\MgO20ZWRT[HEfQQW@2X>[aNfE&0M<.75&LAW0>CBPbd;[[:c=W)G9]YHDLP
GQBa9X5/XH^_J<M1WCe16eKZ=Cd>I:Dc\f<Tb]5K]1X+T0e?3R\1-R/NVMWCUP)W
MIe,26WbeX(,37C:HM(OHJN9JdKgccQ(a(=+KDNOIAF>NKH=)#]_8CDO9L.Bfd8S
dGJ&G^6TS(Ug_&UN(H#,3C47CD]S9Q>c7bTR6(WZP2NM&c.RUSbTCC7Q7f^41F3a
VHB/,23?<YXgS)\H#5A/(08VV-7SU9PQ+7b?M0cQ<OW091T-.eC/D7F>U\MJ.NE3
XEe;V;]Gf<5TB5B&N-XC3^WM]0;C=0Yb(LdR.4=<\GN=-B,P)WMG8f:]D.K<g3bV
2EM8;_ZBW9fD7PDU=<EC>c09_4N[T_eA:>ZCd0Ie5Y735_3W-T.TI&9HcMV8gP8:
&e+gA^SR^JDD9F^+9GVb;4X+<W]T/OBNPYb\AcDYO]&:,RfX2;QF&,I2OA2)5(Qd
<e)D8E<1Z/)1VZ:R-5SW90c4BH1+A,F_;S)^7364V?>)P8),e=(_._bAYONgER#]
+bgH#4f#U(NR.9M<-5J;)IT^XUNQLVL8L4^<7f:HR:A7_^VJ7/7;Na0G1.g2(&CI
;^/c(.#8-=8&,];/0\;Q;.U&?9L+^^E1g#H191LC+:W(YN[4^4DBQYLQ<8dDgI:T
THbJFNZ@a\9#Ja;L[P>B)B,9<5Y0LT2,&?0)a76+KX1b@IR08#M0T_<)@V0)_ID;
5AZIF9[08_=ZeJ]3D)K5,B(]82ZaBTa6Q^=GJ?gfgU(ed8Q+2BW67b?Od12MAAbN
/AaX2P-M.F0T?:HDD(9ZJ)\WVaW>6KS/e_&;Ag_BA9;Y+QH\X2eKRf_VeBe4:?LF
8O071?EER8=8ZH&6?<;dZKNBK[0QW]GBR]@]Z2()T;RW-+fG.=bGMYR]@VK[1:4/
B2>S@,[@\^e10LfCJJ_15&Y3YS/28=XA5+DEbFc@J7V+,^KEHN:Wac,A[>W)d]dI
R39N-SX3M6M24QP>e=0PK5H?J#OB=5\7:RB(;b[\<4^\?W,Y0ZFePW^0K@V;)Pc\
7/E-H059g\^+9H^d8U/g@SQ)X)b8R@EHI)[K7SBQ,51OIc#?HgCa((5OB1.:62:E
D4J<A3#A[#);?FKX/^\,5@41c]=[XP9CF51?Jad:/0U#_Da2/L)cN7[SL,SbLS@&
;7b)TC-S]>Qd3V)PV5[\&.19bU?f-3&eb?g#1P+74ZA^K=>ffYMFb3\1&\AfTL<A
;d6.?V@[OUHREY(P@J=,0O#c05;MW,O)4e^BFSd\0:<QK.8359[>W2+6d/E)F4L8
:4T=^P:4Hdf]Z^;QQVc&>(SKc>d\)K)R<g:;^7[ZH1.-8N;R]\K;DHe[:90L8@#0
Z.7UUL22cKe5aN+:1d]BD07HNHG,OP1QP]RZ)(,\1R@B=bB?TW^/,fI:3K;X]a&/
-cJQ8W[2Y_PJT,)YDKC#6\AOO_YEDRJ6<H9^Q6(U:)RT>>#NQ<17_gfLXND:^O1d
A1VbY,Vb<XP5W0f\\PKI@TZ[PS0V6VZT^fdAB9\:9=YW/Y-RgQI.V(+LaP&S#HM2
T1+Z\4YL0S.J>?65BDS#K=LJN#:c<92QeT#IG]VEM\0B9F#b&3H-#E[6WY/-4b<Y
K7\+1-g8E)#dJ^8/cIHIM6#4B(J_[87Q\MHN4XHB32eM(bCJdRZ6KQ2E[fQg.HV/
2^7;>8QAV#K72G:?/F7BJLDY\2FIeDR..g.=6<EE+?:>74gX^\LePd@H;+AfUGg]
(B1.Z:W2]RL\P/\e=WEW/F<NI0AX<,@\])@JbSf:)&MA>Na7SF5/0C]0eW0CdG-c
fA<L&&X[^J:[9ICLf)KW/GXd[C:S1<:S;/8cUXg_NaSS5X811bX;@F=9W5M@e9HX
4f,DKgGcaf8T6#UI?HGX7^P4D04&2ZdE&76.fOM(69c.SJE-.?W)(2&e:[f-4^^_
4C@YOfXY,aT[f2a_N9ga#X/P@XTM:&V\>f@(U>@d#D\#C_A1;ZQ1&(Y(Q545b=A7
VX946#/B8WS8gAWYI7R9311@AcB^E8?Jd-[e9-L?:40\eW)2O>aSTC=4dXUT2(^W
.NC@H>N4SJ_H_XEOKA8_]_9;SG;INI?Q?-C[92Xae4F)66a#2J4WIIX:eGWX:F1J
O/:TUg@dgGAP[YJI&]ZLdA0ZOG:5F8&5eL._GFadV^#H8Aa,ESPg5T4PCU=MA4V)
/@_c,NV5A2egNN7((N(a.V(D\]M.E_=TA3d[ZEQ2Ac15@]FA;-L^^3V?>.0T5g(,
:7&Tbd_]_P<J8LXYKTe;431NAQ01C@>&KBDWTf8/H41O>J.T<ca9M;S_(8E5TV]B
[<UZ-+W-d<8:W]D^@(PG@W=A5_M[[M(?.X]g5-;B+,SW^?c>C7fbUXBfY\<2P?T:
>.[3VA:GED[#b8_1;O?#Y#5]a02Q;7W5_aH(Q)C,WQOA.[=@3#ZYN)<X,fF&ISVE
P)U5#aYU:DX4E-[,ID4E^\BWG0XA0^1IfbN5Ke#XZ-b&,E<?P7=WL&_)eC(WTTK&
]MUAH_@f7EdS).OX=1#2VSC65I4&W7b_AQeIWR0IMWT(PBcN((U66XAg85\G)XcX
^T=H+6c;LN;SZI[Z9^W)-307(3OHR&XXK6/Y7bI0e73Z&74IB[Db.)SR[55#<VD@
GD7aW]E\=a/eKPaUN75Qf/XCbLZ53c<VI<PP0F-[.@_WFK-^^,3NcAfT>/-7,.8U
R.dPTM26ZXC&)b:K;8;1GDXF4Y16YYe<LF+R&AJP^0)#(X5+e8O7BR_OHU#ON3(I
5.WOf=gC<(WZ\J<gD?FHaOLfUF;8@B?S5@Af<MQX@IV?V8/=WP(HV3))JbIH9fT;
\;??YR1&V>I_]QPgWH.).[#;GVLa:2OFUD1S7\XEQQ8(./B6#W9aSQ,GLg&GSe(7
DV(#8;]&VYBLTO,>_e([Y1OX)e2/+@Z?\D&A?(aZ&aP_^V5K1C\L,b_Z63.-0IcA
H?;bDJe\LWQT=;L8F.1Z4egg65:224+cKMCG;G<d[7G_.O7AB17Y<Y\;\KSI8Q6B
fLD0Ue.a4NcFD1fO6@Sa-9c#6MKP@\L5b;HWP<@]FPIb04/]G1PeX(N2RBcBM<W2
/LH+(NLC[FP@L<:TU]9gZ8>c\LH07e@H3fc#KGU4=H4_#\>4\ZI#Q)U;?EKQ&Ae]
-FPR:QNf8201Xd94];>#d-1-178a79PKC5RCf7P6:\EFBD]/7;V@_I=#)CJX\HDZ
S9;L1@+OXFH^K824\H>\S;F-.971beEO)^,4<4[VYY/bgVEcC(f=HPA;^Z_+OdV)
M@=Kb3.::_UOF&fYe1G:Jg82;-Y?4;Y8-Q/>g.N](382V@a-?B6Y>9?DbKBXEY&-
/.aZCdO:CGIX&EFeUR-ae+T]5Y;e<EUCADP2A([N1;4>8ec@R\]B,<Z#HL:L+N8C
Y1[7D2R09JMcOB&D[/:7O5eW7Ig:&B6[@QT4FID74[_UI,g6OXW(5b<0W-//@#=Y
X9gbT/@a)DCPN]S+V5LLNaMP6BV1FU-.G:,0=Le7Q&\E@^gP6gQNV^+?]f<GZ=^N
G:ODFgdWG4Pc6I]_cM^+e8L5CZQc#f=d2S(3eZ2?^S?=6(<3b59:OKgc1?W49(/[
T7BL;>ZT?OfNMA7C@NZ(5\SI9d>=ARJGPV=[>[@<,eH&S^/N<O:T1I2B/X>M=,5@
;eJL4B?^Y#Q;@DND:N8Ec3)7)EM?KC[a#H\S0-#DJ=.GM?51-^4PXa0H+,A<>[T&
[^1&&#NI5TNA,e(fGfI=-J&d,&NQMW-T-BT#^]cY3a]^UKM+b=LE:)G=OS0[;\91
@aOb><Z(RAE\&b#2RIEa?7B,H8[aS2WY@N9WK^C^E?HQ;:2-f=--7+P_<Eg(D&b;
E6&=<>4:QVA0+6;cY-04@D.c5QQbNWg2QG3+H_b(KFc3GK-IU_WdA6+^LRFDX7O-
(,GU3DY9VB]dcZW99#L/?c,e:Ed2&LJc]&Sa-L1U)dUc\H_9Z-],R-gYP9cfc6)B
Z]I)7C>g@3Y)M?.2C/,URK?DCM9VBR^[_Xd^gHE5;dZQY/E1[W\4K8R_D;Pc4U[\
+@6-\LV\c)@.+fREc]EQV^GL<cE-SAH/,4eD<GS7ZW;0SPGO))U,I>[4RGa]KRVe
V/34??-^QaK^Z=1+N1)#KbMdFBQHR]6<PP;],cJa^:02X0K[;?KAM&BZUCIOa<E<
D;Y4^6JU7&&=X=MB&?ZYg<KGbX1HVI+HT>8I0?7KL2M^QF1c_WgNG0Oc6cFXA2f]
c?fR_gG7M&N3:=S1IR3fJ^9ff_?:FMEO5Cf8P4?XK:[EG/G+c84>Y;EY1X?\:8RB
,:/.F<Wf-XYRHS8c\I/.T):7H5)?.62B\4A),D8e(&9?/J=-,;8aA1\(Ja[F0_C=
g_VbJe\816\;DdHAgZ#J4Be-#R]Hb<aT4[Z:SE/_?C70=0JHdGV(F(3b0)2VR]9#
7180K]1)U3H8QT[[2A[/^WSSf^IXF<J</cVZF=a@F:R3C@XY_;5FFe&<Jcb9Z0aF
cXbFT.W)_c-,D-G0JK[f>3U1<6#C\J\V?.[g&H52cY(\Dda?a3M1N<&XAa(ON3c\
7SBV^P[2dM:UHX7T:H\CPY;#\-9U>M=?[?g#H\dJ)@H\.g0@)dUU/[V1UVHRBL(6
BeK[FTdc[,S&[,>Nf182?<fgQU)<dV(Off-N2&ZV4Qaa4Db):-/LF2(a.0>E2@Z]
SB2\B+KKM[<;CCc2,4F=VeJ(F=1P0Jb]c2N-6UNE\Eb[Ba&44E02UV;8TZWcW#[^
A02NRKeMA-&69;?+bCG#EG1,e1/-[AE@VE\&B?E;\J8[N\Q_.-AYF112OADeDg[:
aCf?\YfSC1[=M^^ccAE95QfN^S2G#Zb_P(+C?4#^R7=[X=3GD-5T.3UY.O0WLD\<
<O,XUdVATY54UZ_1UOeEd\U;=8]+e&fE3&4#06NEf/OMRAfg@dCK9#.=QH59V:f6
>E>+dV/V+J<9EQS@A7D>2-Sa&V8\1BR0<$
`endprotected


`endif // GUARD_SVT_TILELINK_SLAVE_TRANSACTION_EXCEPTION_SV
