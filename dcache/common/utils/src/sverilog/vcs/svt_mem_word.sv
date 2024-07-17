//=======================================================================
// COPYRIGHT (C) 2010-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_MEM_WORD_SV
`define GUARD_SVT_MEM_WORD_SV

// ======================================================================
/**
 * This class is used to represent a single word of data stored in memory.
 * It is intended to be used to create a sparse array of stored memory data,
 * with each element of the array representing a full data word in memory.
 * The object is initilized with, and stores the information about
 * the location (address space, and byte address) of the location
 * represented. It supports read and write (with byte enables)
 * operations, as well as lock/unlock operations.
 */
class svt_mem_word;

  /** Identifies the address space in which this data word resides. */
  local bit [`SVT_MEM_MAX_ADDR_REGION_WIDTH-1:0] addrspace;

  /** Identifies the byte-level address at which this data word resides. */
  local bit [`SVT_MEM_MAX_ADDR_WIDTH - 1:0] addr;

  /** The data word stored in this memory location. */
  local bit [`SVT_MEM_MAX_DATA_WIDTH - 1:0] data;

  /** When '1', indicates that this word is not writeable. */
  local bit locked = 0;

  // --------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new instance of this class. This does not initialize
   * any data within this class. It simply constructs the data word object,
   * thereby preparing it for read/write operations.
   * 
   * @param addrspace Identifies the address space within which this data word
   * resides.
   * 
   * @param addr Identifies the byte address (within the address space) at which
   * this data word resides.
   * 
   * @param init_data (Optional) Sets the stored data to a default initial value.
   */
  extern function new(bit [`SVT_MEM_MAX_ADDR_REGION_WIDTH-1:0] addrspace,
                      bit [`SVT_MEM_MAX_ADDR_WIDTH-1:0] addr,
                      bit [`SVT_MEM_MAX_DATA_WIDTH-1:0] init_data = 'bx);

  // --------------------------------------------------------------------
  /**
   * Returns the value of the data word stored by this object.
   * 
   * @param set_lock (Optional) If supplied as 1 (or any positive int),
   * locks this memory location (preventing writes).
   * If supplied as 0, unlocks this memory location (to allow writes).
   * If not supplied (or supplied as any negative int) the locked/unlocked
   * state of this memory location is not changed.
   */
  extern virtual function bit [`SVT_MEM_MAX_DATA_WIDTH-1:0] read(int set_lock = -1);

  // --------------------------------------------------------------------
  /**
   * Stores a data word into this object, with optional byte-enables.
   * 
   * @param data The data word to be stored. If the memory location is currently
   * locked, the attempted write will not change the stored data, and the
   * function will return 0.
   * 
   * @param byteen (Optional) The byte-enables to be applied to this write. A 1
   * in a given bit position enables the byte in the data word corresponding to
   * that bit position.
   * 
   * @param set_lock (Optional) If supplied as 1 (or any positive int), locks
   * this memory location (preventing writes).
   * If supplied as 0, unlocks this memory location (to allow writes).
   * If not supplied (or supplied as any negative int) the locked/unlocked state
   * of this memory location is not changed.
   * 
   * @return 1 if the write was successful, or 0 if it was not successful (because
   * the memory location was locked).
   */
  extern virtual function bit write(bit [`SVT_MEM_MAX_DATA_WIDTH-1:0] data,
                                    bit [`SVT_MEM_MAX_DATA_WIDTH/8-1:0] byteen = ~0,
                                    int set_lock = -1);

  // --------------------------------------------------------------------
  /**
   * Returns the locked/unlocked state of this memory location.
   * 
   * @return 1 if this memorly location is currently locked, or 0 if it is not.
   */
  extern virtual function bit is_locked();

  // --------------------------------------------------------------------
  /**
   * Returns the byte-level address of this memory location.
   * 
   * @return The byte-level address of this data word.
   */
  extern virtual function bit [`SVT_MEM_MAX_ADDR_WIDTH-1:0] get_addr();

  // --------------------------------------------------------------------
  /**
   * Returns the address space of this memory location.
   * 
   * @return The address space of this data word.
   */
  extern virtual function bit [`SVT_MEM_MAX_ADDR_REGION_WIDTH-1:0] get_addrspace();

  // --------------------------------------------------------------------
  /**
   * Dumps the contents of this memory word object to a string which reports the
   * Address Space, Address, Locked/Unlocked Status, and Data.
   * 
   * @param prefix A user-defined string that precedes the object content string
   * 
   * @return A string representing the content of this memory word object.
   */
  extern virtual function string get_word_content_str(string prefix = "");

  // --------------------------------------------------------------------
  /**
   * Returns the value of this memory location without the key prefixed (used
   * by the UVM print routine).
   */
  extern function string get_word_value_str(string prefix = "");

// =============================================================================
endclass

//svt_vcs_lic_vip_protect
`protected
CfXM1Y:)=EJO&^M+^-OdY<@.NS]XdWYc&23b-1Ve1.:BY-K4=g(81(,+^@2RQ<F)
)RRZ@cN2gS-HIFJ1LH5I2(XYGaRKIL&TFM_ZIZEF\AT(-G,e)gLP)#b31<DK,DY=
=AX+Hb,#bRD#X+UUT6c)W<2D#_\^b(#BDIXaO146OO]Q4)TW(2K];HGO0ZZP9;fS
+Y-HCZV:c:-c5&3IM_0F(RIZN[7NcFc35TN]HZWTc@d:UbP_14:RfPQY^C8S_S]@
Z^]5J9dU7e3#3FYO\P19/D0^0953WR1;ECV3bdU[,GT,:HS\f?38GFY2d/;\1=D\
Q3,7@L2=^U+-&a2_6GWG1Xd+/^F>44RbH6Sc6&G)ZRX\@HXPLQ2AKA@,?5;(BEWW
B/K^#<\g7Z\g#X9P/KK1V[T;E;5NE4?VJ:7N3OX>TUFU^=MH1X9UYd>KEIJ0D,4:
.#&51ODNH2OaGK=J>=I[c8IebPad8K.0eDCd32^1&(R54ZRASP>aCJ:&@g_SG&_X
e3^4I1f>]g7D<3<0^+?H(GQaH9a1K#KC5cd-YSf&NPQ8^GJR2][//F5WgR0&+@I?
SUXF;Q]W</.TG3XHWB056HH-HIX7P-J/N?P+O=dD+&QcSMP);E1,8Jg8H.K\F5_f
,UJEcP,2=U6VgKU&&dYY=\GSIE6bXF8P2L&:6<cGd(@,W2\YLJb6/_IGGFYI^0K[
e)+./<[I+^(]L6W#ZS@4gO075D,G72WF@2^)\VYR<T[^F.Ug+D-B(<C@G&_c3?C0
Qc]OQZX=>3=d;eD6LNP:0W4Eggg6]D+4UR<O1DA;;9E:PY;bEBd3?D8bM+_OS[:@
d@^U]Va^W:1)>;<4OH3fUL_]>e8BSS3I>,8>Y0\==_@YA[SDDMd-9d[8gC0C1A+X
Z(5f+b(P?&=H7OV3Tf9V@^LVR89aEX3R8b+g;Xd8L3=efg6gY3SAV\7Pgb@2\1)]
B-=c7d[>H43ZFF&e3\G(f,/ZcA#&Kg#Wc5f3:;]XRKP]F+3@@8fFPMLDN_g_HVS;
d>8DVW1)91c?[A)0LYbM#X01+&=38<g\#7[2:_F7J>Qa6RF7-C,\0\&H9bOb]6EG
E?31L&Z9(.<2:WEJ;_4#7EZ_H\f+Rgb.SCPS^C3MDAX.:eZH;(?M8UT&Mb.BC#G_
O_@X+L2X_>==HXXVH2I&dg)F:3LVX.3HcK=Gb_gDNF=UJ7V^[PL)H>BC;.e#_UIc
#)gLf/1)X/SMc>+1TZAb78:/?Xd-QI]/;]MV[GTgD3a57QcUPdP;V-;b3W55/7aY
?RI8B-0N5LVCV\YI7E(gC@dEW)2ACS.b<,<FcgY=?e0<@gM@7CJ+eP1bJ2;L3dOA
F7@6f_UOO=J-E)YP9LV7?98#F<bHX?N6ZLD>J^QJ]--+V2AQeRX04^7G2:WBI#=D
U0,51B7a,a9VP3C6=C,<^@5A#?J69HfIB@,R(<LXa:YR-,/2eL(e/QR[+8ZeM+NG
Uc?@.;/cS2CaeN712-.F+.CK]149;5DQ)K2g.5JV<E6Y@+Aa/_];:=5&Sc02GM>g
EBKZcg?.E:(TZgDF;f,Dga\eA>HRRAK4eRU#.aF.)=[eSH.\g>],_dM9G:V^3#aS
?3^.@2<@ONPEdHORU6L8IZS1I;;+4bY(P4(+T+b0c[8Fb&U&gV7Kb#58]NMd=+/7
KVQB6LO>Y=e;&?/]+?Z--:5+DC4VF4(Yb<9=XbXcQI)e@RCe2a6O.Pdbf]g#F6&8
Y-VLaI/c7H?2925e3Q)eM?<Q(cJ.KRO62&/Fa?CU?f@UF-92?I-4[FI(WbdHVF<@
U/\#C7M6,I[0#A<@C89#)H7DGRaA2P39<V-S<E3\+R8-K=6F+1-DB/bQS&_PYI@S
[#bWM6,HdQDDf^&,f;]9O9-\=e8R+f7SM5;5/(FYgFKEe)N8.?.XL8J/8]bZcPQ^
Db3(&Ac/VQgAF.ADGf]8?;]L2;9RMD=@6<#/?)>R\YR:][F,>5?C@NXJBE-BLe0P
DD9_g5Q275OL]YHP(KXJ-3D)HgV8,Y^+PQ218ISK[^Q[5TB]SGHC063P;8@HDb&L
7_f#c8>TDQRK=Kc]FDXFVK[LL,E?<X[(DAgZSBY0;G+9Y1<_5.c\/;5PKMTVQ3eZ
O:ET9+L1Yg]N=XMRL3R?Aa\;L9/f^K24;gIdWQ(M1UZM8K&(K?:b9eb;&]G69BUb
BGH1#,@-]5<TXTEeSW2ebZ?6N65(ZU)#EWEMXV>D#>\4+HFZT-2.Rb@HGXP[3-:K
B8P.[5JZ=a\QRDY#^_O+ebEO_ggb,WYUF^S-P[@-QQ&d+Wc\^)>D)CU1M=\GZ&YP
ZGA,I(0e?X4/C1WK)M+bUa0d[C?I0;F/RX#3.ST.N_?N5A@I;5N_I];C>9]<U)VM
J]KJ)7UUP-:eb_<LJ\CS+FIQ&3S7-?TU7F]Z,N)^L=HP].8[P5=d8c3CO3ELcOAW
DC,9Tg8&D\AI6+_>\Jg,643[XGeeWg(YJ7?2eL[\+Ve1:<VUB2F5)5OR4+[eD#8(
FY\e;CP<Q3SBM4gff+XF+G\.?AX<&>D;\XL(CQ\e9(adRU_4)VILEgAUWg2eZ\2L
b)BYV2g2PZ5];VNVeU,bAW&IG^daF#fC=L\KNaO1S8M[A_9T&HYWB@)]NPc_[7?b
H6LO>-(-[\e/@02cb_G>(\UXW=)U4J^8a1_DP/K[:.34]@B\?f)R@dL<S#1PB0K8
cG6YJD#&GG/2)I@9EIY1K;,>aV:c@4?JSOXUVM7Z6/Z8WF/-d:B3.PF3JC&>+NQd
CAE<\EX=bN?/6FE1(>Cc1@gRB\TeNN:)bV&C?X1:@(=Eb</T69\X&^W+.W2PAF7C
YRR;DS4@LYE_P@fKNA447]Y3\],5Q5K#dH0#gKRYTUCc.=?G]bGAYf1PJ)XT\;IP
4JHE[HOQV=JOMC,YEa:3JUQ=PDaQJ8W45,Nb+C1cK&Z;,&_WW()@EcC3A8VPU>[-
BfC@P=E-BL_Fb#MVgBJ,C]5,9/cIR7N7-BX1H#W&S-66.Q[7,UBAW<^Z_U[dGQ46
3dF;KT.TL^P]c>8CRR6MN019S[WN@(GEA0BAeH9MCcUY[2HO/Sd;E6V..SLH2;;N
M_25cUF)71F>VR_)9_Sa/dS5I9K(F3b<J:gB/8^Z,<.W>aUf2OTd5Fd(:b#MQ?Y:
JA.F_)OX/F56I10FJ[F,[7gaR1Q#W-:eYXBK(#6NcaO&CBc)A#5\H&G(\7HX1J@S
Ac^2,cUda:HJ5bH]7&f0?g610-^F]8Y]=-]aZOUJLQ=;:+.Cb/OV&<@g(L04(HL]
;fGTTV1LCHg(\e^GB9DZfM+CF?V]GPJZfLCZ=T2,QV0[R>(d@IX544&^YLeO7L08
^1,d=1gY_GJ1PK:[C,SZFK^f8II#3).e69a.IZEO0)(&=+IQ>Yg=YX+FN]Z>O3JV
&2#(J1NI4H_44#ZQ<4@g)(]R^?S&^4g+b+;8+F+.eNd?7+_[+E2QF9-L.CD/PLB^
37Wg)^6]-(>Jg17:-AdgYS^#F8313e,-UQ?+/[:T.0=VdQdcL0N<Ed-.>Y,OZ?[a
4M/1Q&D)AU.-WXDC(;BCfRTNJBGd5f(\BA&](GXc7N)5[4GQ@HB)A<@P+_A6,&(Y
6>VJ#b[Pe,?-)$
`endprotected


`endif // GUARD_SVT_MEM_WORD_SV
