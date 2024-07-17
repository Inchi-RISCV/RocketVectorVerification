//=======================================================================
// COPYRIGHT (C) 2015 SYNOPSYS INC.
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

`ifndef GUARD_SVT_DATA_FSDB_WRITER_SV
`define GUARD_SVT_DATA_FSDB_WRITER_SV

/** @cond PRIVATE */

/**
 * Utility class to write data values out to FSDB.  This base class writes
 * values to an FSDB file.  All values are stored as strings to simplify
 * the read back operation.
 */
class svt_data_fsdb_writer extends svt_data_writer;

  /** VIP writer instance to use to record the data */
  svt_vip_writer writer;

  /** Unique object identifier to associate the data with */
  string uid;

  /** Singleton handle */
  static local svt_data_fsdb_writer m_inst = new();

  // ---------------------------------------------------------------------------
  /** Constructor */
  extern function new();

  // ---------------------------------------------------------------------------
  /**
   * Obtain a handle to the singleton instance.
   * 
   * @return handle to the svt_data_fsdb_writer singleton instance
   */
  extern static function svt_data_fsdb_writer get();

  // ---------------------------------------------------------------------------
  /**
   * Write the supplied bit value to the FSDB file.
   * 
   * @param prefix String prepended to the prop_name value
   * @param prop_name String written as the property name
   * @param prop_val Bit value that is written
   * @return Status of the data write operation
   */
  extern virtual function bit write_value_pair_bit(string prefix, string prop_name, bit prop_val);

  // ---------------------------------------------------------------------------
  /**
   * Write the supplied bit value to the FSDB file.
   * 
   * @param prefix String prepended to the prop_name value
   * @param prop_name String written as the property name
   * @param prop_val INT value that is written
   * @return Status of the data write operation
   */
  extern virtual function bit write_value_pair_int(string prefix, string prop_name, int prop_val);

  // ---------------------------------------------------------------------------
  /**
   * Write the supplied bit value to the FSDB file.
   * 
   * @param prefix String prepended to the prop_name value
   * @param prop_name String written as the property name
   * @param prop_val String value that is written
   * @return Status of the data write operation
   */
  extern virtual function bit write_value_pair_string(string prefix, string prop_name, string prop_val);

endclass: svt_data_fsdb_writer

/** @endcond */

`protected
g,OJaP?,beQ6&OQ=OQ44HO1G(HJR?daNVE)(AE&O]T&8MT/T#&G?0)5O[4_Y/@Ea
S7H(3;bcD4B)d(2/HX;<P46OX_?<de\bC@WE^(J7;Bf2dK7N\f?XX+O>HLd/CQbR
d\@=((:_J1-RKU?:Qd53F3]=2(P\ReF#^\BR?9f>AaA-YWE0C-Z^JTV(-bAf]&(X
5?Ic)&QSYWV-cM2IGWfg<:&JWUYI.Z+REMbg0##EfV(DR/E>6ZfZS^.O=Ag4(#8\
;f83gEaX^\=[&ag>=ERE3MFNB0[gNIZB.Ba3#^g[[K6#FO2K_P?:cH>7d8B=(M=U
Z>OLgG@N1fE(TM\d3:86JC+SMEfZ<d;+Dc.>5J+8TcZ4XFW1/PC;&08=KCE8VVU-
_g?f@9L.?;1WE+VX<g\/LX))46#B#9f?O<5b/0E89(9d2^YR77F758ef26SG&gZ8
9gf/52IeP^KI-GHf7Y5K0N1DV)aX1_G+@DQe?<\JY2<U#&QH?eJDZ@UO/1.Zb7C8
+<#6T;A87g8JAFGUMS\#TU?MBK^ZG@>@KU:0L-.CcD<^0cO-:-R2YD@4@\,Q>D>T
bH=]FRY8PC([H(=:SL+6(4],gV_C@H92#2Bc+9;N?_8=.?E<8(X;^-=<?QT[7eUg
1+MIdUEAdE-D(dBf/YEU\\BV1A@a69QMR<W27b#Gb(Ia6FY+dXg;eV2eH:eBKSc4
IPd8W_J-G9H-.<(Ub)[;]aJTUI@8f.8,Zc06UDe:Dd5&U:_:ObD[^0dX9bMUb;MS
A,NN]<@A;FE#H6+V^J16&?4f]:33VKZ(F>H(EA[X)UaQ&)g=^87>]#LSb>3XD75Z
FLac-=47QT?V@,IBcM0b01=Q;LK^)K1Nb&5#)13f^<9&YE]fE96g9(V\)U+4;gVU
E0Z\g>\@aGHY?f?8I)XR-EV&[G95-Q=-F3;N=:TR/;<[>UJ[&C17+=Sd]N]6g4da
@FRI4eW+<&0C9HM_;S)]WYHc1OR:KE,^1NA@(C?,P,;F1/geeLY/gN:TeITZPES]
Q7G0W,B[3?O8:>Tg,,,Kg)BU5A?HD1KT:J:(3F1:<W]JZa.DP[3+0D&@c<Z2IPS.
.KRdO24)V(PNSU.ZeBYb-b<LB8bMA-76;S6Qe#5P5:,O)QG-G/D)PPTJY#M3\6H2
[8ASSZNb^HY(g2H-[VC:b??c5^><eV8XH<Y5=9=He5dE_2S1b+W<[V2H4L?f&LSR
>^;E19-<29;_ZGZCQ25LY8Qd?DbV]X?.;J73c.BN8\?Mb/eZ>/[M==Q;W;]F3UDU
FH>PTK,aD;QK<ZG);_BGd#(KL3-\&L\YMZ#F&fZO-(>dI47d89#;)AMV=Na>_gC]
e6.O1[DVD_dD7(37B#3#OgP&R)O\?TBJ@D#a@-YD]7Y=D(S]6JBAIS5KB1UCCMEJ
eVTIc1YQ[?^TZc=I[O]GH]U//[])O=U.Z+aaWV&7ZMaO6-0C]cVgDK<:,Yc]5aH<
e(K0\:W&J&PS[/+4/9HTaE<Z(6/[.eT[?CW9\N1g_PY55-&,(e3O+L6d9;)#UbNO
D:1f]M(FWF/(a-^_J3WH2&4G-NCD.7-(SO:Nc#UR0e]eHC^34VQ)]3bL>K0]5\M?
W<FS=+LZaC#G@OfOLXUD[1\d.Y6;H_63=$
`endprotected


`endif // GUARD_SVT_DATA_FSDB_WRITER_SV