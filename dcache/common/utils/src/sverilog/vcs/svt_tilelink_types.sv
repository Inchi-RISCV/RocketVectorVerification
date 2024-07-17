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

`ifndef GUARD_SVT_TILELINK_TYPES_SVI
`define GUARD_SVT_TILELINK_TYPES_SVI 

`include "svt_tilelink_defines.svi"

`protected
C0XOU=TK;4J/RQ.I?geHGRK:5]I2/OVR).VP6X7L?5eU?5IBS\(J()^KBI\GX(G+
7ada(Y8>Q5=e28B(c3.+HE(C(9O.>T(=CY=+#F\G31g^3B\0H;=HEPM8ZV?48V#X
.FTQ;5D1THSL&T;J/&Ub@+;^[RE<fB8:=?Ka)A3>fP>d)E,+/T57FARe#e(A@8Ua
5;&NZ205U=W5.?/&CQ2S\Y&V(=M5dXRc+]a0dKabM^6f#dZF]e]+M30AJI5UASAF
,2BQ;J58[N@T#S]G>G8/UD@A-YCAI_2>V+XRNOL?YB-JYV15/_bN&d?)HUBS^&PR
;[>D;H6^P]QD9E=;&>WI;3bA1O-GgV>V][RE.4JS6&&H]EX\gVAHC8Q90M<64AbD
K@^6Jdd(H9/5RL[6@^a])28d#7,Jd]SM&GLeFO\7f4J@DD):gc>_eFF68WPB0_d]
gB:Dc6)+2/Y-X#]NN>.+0N:J4COPX5#XbN.^)XL/UG<+XM[_b1Z?./Z.;_00EE@D
,1C6bB/Q3=cO1OI#.[]2N]/-Y5<9+c8V\@FRUF5797J;_a[XKS_EL+:FZaVe=3V\
<9F7>_a4))4f\9ed=/cL)aA=d;P,XJGO72Q[12SFFCX&9.-e<0_8:a6M<))>a=^K
BR;;.^9e4b/RX>KX6aEYfaO6]AcM&+^RE<U3A:J#:Q;(=@()U1SCNJgBT8gAV]O/
\a(J@0Y=C68KUD1\g.V\2&UZ3U,c;QN(]RbP^?]ZPW2=7SBR6ED\OBM+QcZBV7F;
>&#?ed4@G7eb^,<4ON:,7W7-NKf.(81A#IF]:CBHW:YQCUH1PZ+<>?W(0F9=XKU5
ANQYCg;4.ge)NL:BF(;-@[e<Y:Y\J?b8b(]LW.EECX(L:21?.TE+T1])P#LX]GPQ
eg[f;N-N2-X8[WH<b^F2IR?(U&F5/_LD&2#[^Dg9G)RIW#QRHKU?0ZKCdD)JX^TG
b9_OK_a)F]I5K0=9]T&WX8b->?,G^Ac9<$
`endprotected



// =============================================================================
/**
  * This class contains pre-defined enumerated types for svt_tilelink_types
  */
class svt_tilelink_types;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------

  /** Tilelink VIP supported specification revision number. */
  typedef enum bit[1:0] {
    SVT_TILELINK_VER_1_8_0  = `SVT_TILELINK_VER_1_8_0   /**< REV No : SVT_TILELINK_VER_1_8_0 >**/
  } tl_rev_num;

  /** Enum corresponding to the Tilelink Transaction type on Channel-A. */
  typedef enum bit[`SVT_TILELINK_A_OPCODE_WIDTH-1:0] {
    CH_A_PUT_FULL_DATA      = `SVT_TILELINK_CMD_PUT_FULL_DATA_TYPE,    /**< Enum Value 0 - CH_A_PUT_FULL_DATA     - Opcode 0 >**/
    CH_A_PUT_PARTIAL_DATA   = `SVT_TILELINK_CMD_PUT_PARTIAL_DATA_TYPE, /**< Enum Value 1 - CH_A_PUT_PARTIAL_DATA  - Opcode 1 >**/
    CH_A_ARITHMETIC_DATA    = `SVT_TILELINK_CMD_ARITHMETIC_DATA_TYPE,  /**< Enum Value 2 - CH_A_ARITHMETIC_DATA   - Opcode 2 >**/
    CH_A_LOGICAL_DATA       = `SVT_TILELINK_CMD_LOGICAL_DATA_TYPE,     /**< Enum Value 3 - CH_A_LOGICAL_DATA      - Opcode 3 >**/
    CH_A_GET                = `SVT_TILELINK_CMD_GET_TYPE,              /**< Enum Value 4 - CH_A_GET               - Opcode 4 >**/
    CH_A_INTENT             = `SVT_TILELINK_CMD_INTENT_TYPE,           /**< Enum Value 5 - CH_A_INTENT            - Opcode 5 >**/
    CH_A_ACQUIRE_BLOCK      = `SVT_TILELINK_CMD_AQUIRE_BLOCK_TYPE,     /**< Enum Value 6 - CH_A_ACQUIRE_BLOCK     - Opcode 6 >**/
    CH_A_ACQUIRE_PERM       = `SVT_TILELINK_CMD_AQUIRE_PERM_TYPE       /**< Enum Value 7 - CH_A_ACQUIRE_PERM      - Opcode 7 >**/
  } tl_ch_a_msg_type_enum;

  /** Enum corresponding to the Tilelink Transaction type on Channel-B. */
  typedef enum bit[`SVT_TILELINK_B_OPCODE_WIDTH-1:0] {
    CH_B_PUT_FULL_DATA      = `SVT_TILELINK_CMD_PUT_FULL_DATA_TYPE,    /**< Enum Value 0 - CH_B_PUT_FULL_DATA     - Opcode 0 >**/
    CH_B_PUT_PARTIAL_DATA   = `SVT_TILELINK_CMD_PUT_PARTIAL_DATA_TYPE, /**< Enum Value 1 - CH_B_PUT_PARTIAL_DATA  - Opcode 1 >**/
    CH_B_ARITHMETIC_DATA    = `SVT_TILELINK_CMD_ARITHMETIC_DATA_TYPE,  /**< Enum Value 2 - CH_B_ARITHMETIC_DATA   - Opcode 2 >**/
    CH_B_LOGICAL_DATA       = `SVT_TILELINK_CMD_LOGICAL_DATA_TYPE,     /**< Enum Value 3 - CH_B_LOGICAL_DATA      - Opcode 3 >**/
    CH_B_GET                = `SVT_TILELINK_CMD_GET_TYPE,              /**< Enum Value 4 - CH_B_GET               - Opcode 4 >**/
    CH_B_INTENT             = `SVT_TILELINK_CMD_INTENT_TYPE,           /**< Enum Value 5 - CH_B_INTENT            - Opcode 5 >**/
    CH_B_PROBE_BLOCK        = `SVT_TILELINK_CMD_PROBE_BLOCK_TYPE,      /**< Enum Value 6 - CH_B_PROBE_BLOCK       - Opcode 6 >**/
    CH_B_PROBE_PERM         = `SVT_TILELINK_CMD_PROBE_PERM_TYPE        /**< Enum Value 7 - CH_B_PROBE_PERM        - Opcode 7 >**/
  } tl_ch_b_msg_type_enum;

  /** Enum corresponding to the Tilelink Transaction type on Channel-C. */
  typedef enum bit[`SVT_TILELINK_C_OPCODE_WIDTH-1:0] {
    CH_C_ACCESS_ACK         = `SVT_TILELINK_CMD_ACCESS_ACK_TYPE,       /**< Enum Value 0 - CH_C_ACCESS_ACK        - Opcode 0 >**/
    CH_C_ACCESS_ACK_DATA    = `SVT_TILELINK_CMD_ACCESS_ACK_DATA_TYPE,  /**< Enum Value 1 - CH_C_ACCESS_ACK_DATA   - Opcode 1 >**/
    CH_C_HINT_ACK           = `SVT_TILELINK_CMD_HINT_ACK_TYPE,         /**< Enum Value 2 - CH_C_HINT_ACK          - Opcode 2 >**/
    CH_C_PROBE_ACK          = `SVT_TILELINK_CMD_PROBE_ACK_TYPE,        /**< Enum Value 3 - CH_C_PROBE_ACK         - Opcode 3 >**/
    CH_C_PROBE_ACK_DATA     = `SVT_TILELINK_CMD_PROBE_ACK_DATA_TYPE,   /**< Enum Value 4 - CH_C_PROBE_ACK_DATA    - Opcode 4 >**/
    CH_C_RELEASE            = `SVT_TILELINK_CMD_RELEASE_TYPE,          /**< Enum Value 5 - CH_C_RELEASE           - Opcode 5 >**/
    CH_C_RELEASE_DATA       = `SVT_TILELINK_CMD_RELEASE_DATA_TYPE      /**< Enum Value 6 - CH_C_RELEASE_DATA      - Opcode 7 >**/
  } tl_ch_c_msg_type_enum;

  /** Enum corresponding to the Tilelink Transaction type on Channel-D. */
  typedef enum bit[2:0] {
    CH_D_ACCESS_ACK         = `SVT_TILELINK_CMD_ACCESS_ACK_TYPE,       /**< Enum Value 0 - CH_D_ACCESS_ACK        - Opcode 0 >**/
    CH_D_ACCESS_ACK_DATA    = `SVT_TILELINK_CMD_ACCESS_ACK_DATA_TYPE,  /**< Enum Value 1 - CH_D_ACCESS_ACK_DATA   - Opcode 1 >**/
    CH_D_HINT_ACK           = `SVT_TILELINK_CMD_HINT_ACK_TYPE,         /**< Enum Value 2 - CH_D_HINT_ACK          - Opcode 2 >**/
    CH_D_GRANT              = `SVT_TILELINK_CMD_GET_TYPE,              /**< Enum Value 3 - CH_D_GET               - Opcode 4 >**/
    CH_D_GRANT_DATA         = `SVT_TILELINK_CMD_INTENT_TYPE,           /**< Enum Value 4 - CH_D_INTENT            - Opcode 5 >**/
    CH_D_RELEASE_ACK        = `SVT_TILELINK_CMD_AQUIRE_PERM_TYPE       /**< Enum Value 5 - CH_D_ACQUIRE_PERM      - Opcode 7 >**/
  } tl_ch_d_msg_type_enum;

  /** Enum corresponding to the Tilelink Transaction type on Channel-D. */
  typedef enum bit {
    CH_E_GRANT_ACK          = `SVT_TILELINK_CMD_GRANT_ACK_TYPE,         /**< Enum Value 0 - CH_E_GRANT_ACK        - Opcode NA >**/
    CH_E_NO_OPCODE         = `SVT_TILELINK_CMD_NO_OPCODE             /**< Enum Value 1 - CH_E_NO_OPCODE        - Opcode NA >**/
  } tl_ch_e_msg_type_enum;

  /** enum corresponding to the total amount of data (number of bytes) to be transmit. */
  typedef enum bit[4:0] {
    TXN_SIZE_1BYTE     = `SVT_TILELINK_TXN_SIZE_1_BYTE,           /**< Enum Value 0  - TXN_size=2**0=1byte      >**/
    TXN_SIZE_2BYTE     = `SVT_TILELINK_TXN_SIZE_2_BYTE,           /**< Enum Value 1  - TXN_size=2**1=2bytes     >**/
    TXN_SIZE_4BYTE     = `SVT_TILELINK_TXN_SIZE_4_BYTE,           /**< Enum Value 2  - TXN_size=2**2=4bytes     >**/
    TXN_SIZE_8BYTE     = `SVT_TILELINK_TXN_SIZE_8_BYTE,           /**< Enum Value 3  - TXN_size=2**3=8bytes     >**/
    TXN_SIZE_16BYTE    = `SVT_TILELINK_TXN_SIZE_16_BYTE,          /**< Enum Value 4  - TXN_size=2**4=16bytes    >**/
    TXN_SIZE_32BYTE    = `SVT_TILELINK_TXN_SIZE_32_BYTE,          /**< Enum Value 5  - TXN_size=2**5=32bytes    >**/
    TXN_SIZE_64BYTE    = `SVT_TILELINK_TXN_SIZE_64_BYTE,          /**< Enum Value 6  - TXN_size=2**6=64bytes    >**/
    TXN_SIZE_128BYTE   = `SVT_TILELINK_TXN_SIZE_128_BYTE,         /**< Enum Value 7  - TXN_size=2**7=128bytes   >**/
    TXN_SIZE_256BYTE   = `SVT_TILELINK_TXN_SIZE_256_BYTE,         /**< Enum Value 8  - TXN_size=2**8=256bytes   >**/
    TXN_SIZE_512BYTE   = `SVT_TILELINK_TXN_SIZE_512_BYTE,         /**< Enum Value 9  - TXN_size=2**9=512bytes   >**/
    TXN_SIZE_1KBYTE    = `SVT_TILELINK_TXN_SIZE_1K_BYTE,          /**< Enum Value 10 - TXN_size=2**10=1Kbytes   >**/
    TXN_SIZE_2KBYTE    = `SVT_TILELINK_TXN_SIZE_2K_BYTE,          /**< Enum Value 11 - TXN_size=2**11=2Kbytes   >**/
    TXN_SIZE_4KBYTE    = `SVT_TILELINK_TXN_SIZE_4K_BYTE,          /**< Enum Value 12 - TXN_size=2**12=4Kbytes   >**/
    TXN_SIZE_8KBYTE    = `SVT_TILELINK_TXN_SIZE_8K_BYTE,          /**< Enum Value 13 - TXN_size=2**13=8Kbytes   >**/
    TXN_SIZE_16KBYTE   = `SVT_TILELINK_TXN_SIZE_16K_BYTE,         /**< Enum Value 14 - TXN_size=2**14=16Kbytes  >**/
    TXN_SIZE_32KBYTE   = `SVT_TILELINK_TXN_SIZE_32K_BYTE,         /**< Enum Value 15 - TXN_size=2**15=32Kbytes  >**/
    TXN_SIZE_64KBYTE   = `SVT_TILELINK_TXN_SIZE_64K_BYTE          /**< Enum Value 16 - TXN_size=2**16=64Kbytes  >**/
  } tl_burst_size_enum;

  // ---------------------------------------------------------------------------
endclass

`endif // GUARD_SVT_TILELINK_TYPES_SVI

