//-----------------------------------------------------------------------------
// COPYRIGHT (C) 2020 SYNOPSYS INC.
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

`ifndef GUARD_SVT_TILELINK_SLAVE_TRANSACTION_SV
`define GUARD_SVT_TILELINK_SLAVE_TRANSACTION_SV 

`include "svt_tilelink_defines.svi"

// =============================================================================
/**
 * Tilelink Slave Transaction class.
 */
class svt_tilelink_slave_transaction extends `SVT_TRANSACTION_TYPE;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------

  /** 
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * Enum corresponding to the Tilelink Transaction type on Channel-B. 
   */
  typedef enum bit[`SVT_TILELINK_B_OPCODE_WIDTH-1:0] {
    CH_B_PUT_FULL_DATA      = `SVT_TILELINK_CMD_PUT_FULL_DATA_TYPE,    /**< Enum Value 0 - CH_B_PUT_FULL_DATA     - Opcode 0 >**/
    CH_B_PUT_PARTIAL_DATA   = `SVT_TILELINK_CMD_PUT_PARTIAL_DATA_TYPE, /**< Enum Value 1 - CH_B_PUT_PARTIAL_DATA  - Opcode 1 >**/
    CH_B_ARITHMETIC_DATA    = `SVT_TILELINK_CMD_ARITHMETIC_DATA_TYPE,  /**< Enum Value 2 - CH_B_ARITHMETIC_DATA   - Opcode 2 >**/
    CH_B_LOGICAL_DATA       = `SVT_TILELINK_CMD_LOGICAL_DATA_TYPE,     /**< Enum Value 3 - CH_B_LOGICAL_DATA      - Opcode 3 >**/
    CH_B_GET                = `SVT_TILELINK_CMD_GET_TYPE,              /**< Enum Value 4 - CH_B_GET               - Opcode 4 >**/
    CH_B_INTENT             = `SVT_TILELINK_CMD_INTENT_TYPE,           /**< Enum Value 5 - CH_B_INTENT            - Opcode 5 >**/
    CH_B_PROBE_BLOCK        = `SVT_TILELINK_CMD_PROBE_BLOCK_TYPE,      /**< Enum Value 6 - CH_B_PROBE_BLOCK       - Opcode 6 >**/
    CH_B_PROBE_PERM         = `SVT_TILELINK_CMD_PROBE_PERM_TYPE        /**< Enum Value 7 - CH_B_PROBE_PERM        - Opcode 7 >**/
  } tl_slave_ch_b_msg_type_enum;

  /**
   * Enum corresponding to the Tilelink Transaction type on Channel-D. */
  typedef enum bit[`SVT_TILELINK_D_OPCODE_WIDTH-1:0] {
    CH_D_ACCESS_ACK         = `SVT_TILELINK_CMD_ACCESS_ACK_TYPE,       /**< Enum Value 0 - CH_D_ACCESS_ACK        - Opcode 0 >**/
    CH_D_ACCESS_ACK_DATA    = `SVT_TILELINK_CMD_ACCESS_ACK_DATA_TYPE,  /**< Enum Value 1 - CH_D_ACCESS_ACK_DATA   - Opcode 1 >**/
    CH_D_HINT_ACK           = `SVT_TILELINK_CMD_HINT_ACK_TYPE,         /**< Enum Value 2 - CH_D_HINT_ACK          - Opcode 2 >**/
    CH_D_GRANT              = `SVT_TILELINK_CMD_GRANT_TYPE,            /**< Enum Value 4 - CH_D_GRANT             - Opcode 4 >**/
    CH_D_GRANT_DATA         = `SVT_TILELINK_CMD_GRANT_DATA_TYPE,       /**< Enum Value 5 - CH_D_GRANT_DATA        - Opcode 5 >**/
    CH_D_RELEASE_ACK        = `SVT_TILELINK_CMD_RELEASE_ACK_TYPE       /**< Enum Value 6 - CH_D_RELEASE_ACK       - Opcode 6 >**/
  } tl_slave_ch_d_msg_type_enum;

  //----------------------------------------------------------------------------
  // Public Data Properties
  //----------------------------------------------------------------------------

  /**
   * Object used to hold exceptions for a Tilelink Transaction. */
  svt_tilelink_slave_transaction_exception_list exception_list = null;

  /**
   * Handle to configuration, available for use by constraints. */ 
  svt_tilelink_slave_agent_configuration cfg = null;

  //----------------------------------------------------------------------------
  // Random Data Properties
  //----------------------------------------------------------------------------

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * Defines the type of command which is received in a Tilelink Transaction on channel-B.
   */
  rand tl_slave_ch_b_msg_type_enum ch_b_msg_type = CH_B_PUT_FULL_DATA;

  /**
   * Defines the type of command which is received in a Tilelink Transaction on channel-D. */
  rand tl_slave_ch_d_msg_type_enum ch_d_msg_type = CH_D_ACCESS_ACK;

  /**
   * This field specifies which channel to be driven by Slave.<br>
   *  1 : Drive channel B*/
  rand bit drive_chnl_B;

  /** 
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the Logarithm of the operation size: 2**n bytes. */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] b_size;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the per-link master source identifier which is unique. */
  rand bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] b_source;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the target byte address of the operation. Must be aligned to b_size. */
  rand bit [`SVT_TILELINK_ADDR_WIDTH-1:0] b_address;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the byte lane select for messages with data. */
  rand bit [`SVT_TILELINK_DATA_WIDTH/8-1:0] b_mask[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field contains the data payload for messages with data. */
  rand bit [7:0] b_data[];

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This field specifies the data in this beat is corrupt. */
  rand bit b_corrupt[];

  /** 
   * This attribute is meant for collection of b_param for monitoring purpose. */
  rand bit [`SVT_TILELINK_B_PARAM_WIDTH-1:0] b_param;

  /** 
   * This attribute is meant for collection of d_size for monitoring purpose only.
   * This field contains the Logarithm of the operation size: 2**n bytes. */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] d_size;

  /** 
   * This attribute is meant for collection of d_source for monitoring purpose only.
   * This field contains the slave source identifier which is unique for an in-flight transfer. */
  rand bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] d_source;

  /** 
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
   * This attribute is meant for collection of d_sink for monitoring purpose only.
   * This field contains the slave sink identifier which is unique for an in-flight transfer. */
  rand bit [`SVT_TILELINK_SINK_WIDTH-1:0] d_sink;

  /** 
   * This field specifies that the slave was unable to service the request, user can choose to set this property to enforce denied response.
   * This attribute is meant for collection of d_denied for monitoring purpose.
   */
  rand bit d_denied;

  /** 
   * This attribute is meant for collection of d_data[] for monitoring purpose only.
   * This field contains the data payload for messages with response data. */
  rand bit [7:0] d_data[];

  /** 
   * This attribute is meant for collection of d_corrupt for monitoring purpose only.
   * This field specifies the data in this beat is corrupt. */
  rand bit d_corrupt[];

  /** 
   * This attribute is meant for collection of d_param for monitoring purpose. */
  rand bit [`SVT_TILELINK_D_PARAM_WIDTH-1:0] d_param;

  /** 
   * This attribute configures delay between immediate previous a_valid assertion to a_ready assertion to enable handshake.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=1.
   */
  rand int a_vld_a_rdy_assert_delay;

  /** 
   * This attribute configures delay between immediate previous a_ready assertion to next a_ready de-assertion.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=0.
   */
  rand int a_rdy_deassert_delay;

  /** 
   * This attribute configures delay between immediate previous b_valid de-assertion to next b_valid assertion.
   * It works ONLY if configuration class properties slv_delay_en=1.
   */
  rand int b_vld_2_b_vld_assert_delay[];

  /** 
   * This attribute configures delay between immediate previous d_valid de-assertion to next d_valid assertion.
   * It works ONLY if configuration class properties slv_delay_en=1.
   */
  rand int d_vld_2_d_vld_assert_delay[];

  ///** This variable Configures previous d_ready assertion to current d_ready de-assertion delay. */
  //rand int d_vld_deassert_delay[];

  /** 
   * This attribute configures delay between immediate previous a_ready e-assertion to next a_ready assertion.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=0.
   */
  rand int a_rdy_2_a_rdy_assert_delay;

  /** 
   * This attribute configures delay between a Tilelink Transaction's a_valid-a_ready handshake to corresponding response assertion.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_cross_chnl_delay_en=1.
   */
  rand int a_vld_d_vld_cross_channel_delay;

  /** 
   * This attribute configures delay between immediate previous e_ready de-assertion to next e_ready assertion.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=0.
   */
  rand int e_rdy_2_e_rdy_assert_delay;

  /** 
   * This attribute configures delay between immediate previous e_valid assertion to e_ready assertion to enable handshake.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=1.
   */
  rand int e_vld_e_rdy_assert_delay;

  /** 
   * This attribute configures delay between immediate previous e_ready assertion to next e_ready de-assertion.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=0.
   */
  rand int e_rdy_deassert_delay;

  /** 
   * This attribute configures delay between immediate previous c_ready de-assertion to next c_ready assertion.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=0.
   */
  rand int c_rdy_2_c_rdy_assert_delay;

  /** 
   * This attribute configures delay between immediate previous c_valid assertion to c_ready assertion to enable handshake.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=1.
   */
  rand int c_vld_c_rdy_assert_delay;

  /** 
   * This attribute configures delay between immediate previous c_ready assertion to next c_ready de-assertion.
   * It works ONLY if configuration class properties slv_delay_en=1 and slv_vld_rdy_delay_en=0.
   */
  rand int c_rdy_deassert_delay;

  //----------------------------------------------------------------------------
  // Protected Data Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Local Data Properties
  //----------------------------------------------------------------------------

  /**
   * Enum corresponding to the Tilelink Transaction type on Channel-A. */
  typedef enum bit[`SVT_TILELINK_A_OPCODE_WIDTH-1:0] {
    CH_A_PUT_FULL_DATA      = `SVT_TILELINK_CMD_PUT_FULL_DATA_TYPE,    /**< Enum Value 0 - CH_A_PUT_FULL_DATA     - Opcode 0 >**/
    CH_A_PUT_PARTIAL_DATA   = `SVT_TILELINK_CMD_PUT_PARTIAL_DATA_TYPE, /**< Enum Value 1 - CH_A_PUT_PARTIAL_DATA  - Opcode 1 >**/
    CH_A_ARITHMETIC_DATA    = `SVT_TILELINK_CMD_ARITHMETIC_DATA_TYPE,  /**< Enum Value 2 - CH_A_ARITHMETIC_DATA   - Opcode 2 >**/
    CH_A_LOGICAL_DATA       = `SVT_TILELINK_CMD_LOGICAL_DATA_TYPE,     /**< Enum Value 3 - CH_A_LOGICAL_DATA      - Opcode 3 >**/
    CH_A_GET                = `SVT_TILELINK_CMD_GET_TYPE,              /**< Enum Value 4 - CH_A_GET               - Opcode 4 >**/
    CH_A_INTENT             = `SVT_TILELINK_CMD_INTENT_TYPE,           /**< Enum Value 5 - CH_A_INTENT            - Opcode 5 >**/
    CH_A_ACQUIRE_BLOCK      = `SVT_TILELINK_CMD_AQUIRE_BLOCK_TYPE,     /**< Enum Value 6 - CH_A_ACQUIRE_BLOCK     - Opcode 6 >**/
    CH_A_ACQUIRE_PERM       = `SVT_TILELINK_CMD_AQUIRE_PERM_TYPE       /**< Enum Value 7 - CH_A_ACQUIRE_PERM      - Opcode 7 >**/
  } tl_slave_ch_a_msg_type_enum;

  /**
   * Enum corresponding to the Tilelink transaction type on Channel-E. */
  typedef enum bit {
    CH_E_GRANT_ACK         = `SVT_TILELINK_CMD_GRANT_ACK_TYPE,       /**< Enum Value 0 - CH_E_GRANT_ACK        - Opcode NA >**/
    CH_E_NO_OPCODE         = `SVT_TILELINK_CMD_NO_OPCODE             /**< Enum Value 1 - CH_E_NO_OPCODE        - Opcode NA >**/
  } tl_slave_ch_e_msg_type_enum;
//  /**
//   * Enum corresponding to the Tilelink transaction type on Channel-C. */
  typedef enum bit[`SVT_TILELINK_C_OPCODE_WIDTH-1:0] {
    CH_C_ACCESS_ACK         = `SVT_TILELINK_CMD_ACCESS_ACK_TYPE,       /**< Enum Value 0 - CH_C_ACCESS_ACK        - Opcode 0 >**/
    CH_C_ACCESS_ACK_DATA    = `SVT_TILELINK_CMD_ACCESS_ACK_DATA_TYPE,  /**< Enum Value 1 - CH_C_ACCESS_ACK_DATA   - Opcode 1 >**/
    CH_C_HINT_ACK           = `SVT_TILELINK_CMD_HINT_ACK_TYPE,         /**< Enum Value 2 - CH_C_HINT_ACK          - Opcode 2 >**/
    CH_C_PROBE_ACK          = `SVT_TILELINK_CMD_PROBE_ACK_TYPE,        /**< Enum Value 4 - CH_C_PROBE_ACK         - Opcode 4 >**/
    CH_C_PROBE_ACK_DATA     = `SVT_TILELINK_CMD_PROBE_ACK_DATA_TYPE,   /**< Enum Value 5 - CH_C_PROBE_ACK_DATA    - Opcode 5 >**/
    CH_C_RELEASE            = `SVT_TILELINK_CMD_RELEASE_TYPE,          /**< Enum Value 6 - CH_C_RELEASE           - Opcode 6 >**/
    CH_C_RELEASE_DATA       = `SVT_TILELINK_CMD_RELEASE_DATA_TYPE      /**< Enum Value 7 - CH_C_RELEASE_DATA      - Opcode 7 >**/
  } tl_slave_ch_c_msg_type_enum;



  /**
   * Defines the type of command which is received in a Tilelink Transaction on channel-A. */
  rand tl_slave_ch_a_msg_type_enum ch_a_msg_type = CH_A_PUT_FULL_DATA;

  /**
   * Defines the type of command which is received in a Tilelink Transaction on channel-E. */
  rand tl_slave_ch_e_msg_type_enum ch_e_msg_type = CH_E_GRANT_ACK; 

  /**
   * Defines the type of command which is received in a Tilelink Transaction on channel-C. */
  rand tl_slave_ch_c_msg_type_enum ch_c_msg_type= CH_C_PROBE_ACK;

  /**
   * This field contains the Logarithm of the operation size: 2**n bytes, used for monitoring of received a_size on bus. */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] a_size;

  /**
   * This field contains the per-link master source identifier which is unique for an in-flight transfer, used for monitoring of received a_source on bus. */
  rand bit [`SVT_TILELINK_SOURCE_WIDTH-1:0] a_source;

  /**
   * This field contains the target byte address of the operation. Must be aligned to a_size, used for monitoring of received a_address on bus. */
  rand bit [`SVT_TILELINK_ADDR_WIDTH-1:0] a_address;

  /**
   * This field contains the byte lane select for messages with data, used for monitoring of received a_mask[] on bus. */
  rand bit [`SVT_TILELINK_DATA_WIDTH/8-1:0] a_mask[];

  /**
   * This field contains the data payload for messages with data, used for monitoring of received a_data[] on bus. */
  rand bit [`SVT_TILELINK_DATA_WIDTH-1:0] a_data[];

  /**
   * This field specifies the data in this beat is corrupt, used for monitoring of received a_corrupt[] on bus. */
  rand bit a_corrupt[];

  ///** This will discard the request if not accepted by slave*/
  //rand bit en_msg_discard;

  /**
   * <b> NOTE: THIS FEATURE IS NOT SUPPORTED FOR THIS RELEASE. </b> <br>
     This attribute specifies the parameter associated with opcode received on a_channel, used for monitoring of received a_param on bus */
  rand bit [`SVT_TILELINK_A_PARAM_WIDTH-1:0] a_param;
  /**
   * Local reference of status class for trace log creation.
   */

  /**
   * This field contains the Logarithm of the operation size: 2**n bytes, used for monitoring of received c_size on bus. */
  rand bit [`SVT_TILELINK_SIZE_WIDTH-1:0] c_size;

  /**
   * This field contains the data payload for messages with data, used for monitoring of received c_data[] on bus. */
  rand bit [`SVT_TILELINK_DATA_WIDTH-1:0] c_data[];

  /**
   * This field specifies the data in this beat is corrupt, used for monitoring of received c_corrupt[] on bus. */
  rand bit c_corrupt[];


  svt_tilelink_slave_status status;

  //----------------------------------------------------------------------------
  // Constraints
  //----------------------------------------------------------------------------

  /**
   * Valid ranges constraints insure that the Tilelink Transaction settings are supported
   * by the Tilelink components.
   */
  constraint valid_ranges {
  // vb_preserve TMPL_TAG1
  // Add user constraints here
  // vb_preserve end
  // vb_preserve TMPL_TAG1
  // Add user constraints here
  // vb_preserve end
  }
  /**
   * Valid distrution constraint over valid_drive_chnl_B to have valid_drive_chnl_B=0 by default for channel D transactions 
   * by Tilelink Slave components.
   */
  constraint valid_drive_chnl_B {
    soft drive_chnl_B == 0;
  }

  /**
   * Valid distrution constraint over b_corrupt to generate non-corrupt beats
   * by Tilelink Slave components.
   */
  constraint valid_b_corrupt {
    if(this.ch_b_msg_type != CH_B_GET && this.ch_b_msg_type != CH_B_INTENT && this.ch_b_msg_type != CH_B_PROBE_BLOCK && this.ch_b_msg_type != CH_B_PROBE_PERM) {
      foreach(b_corrupt[i]) {
        b_corrupt[i] dist{0:=1000, 1:=1};
      }
    } else {
      foreach(b_corrupt[i]) {
        b_corrupt[i] == 0;
      }
    } 
  }

  /**
   * Valid constraint over ch_b_msg_type to generate valid message-types/opcodes
   * by Tilelink Slave components.
   */
  constraint valid_ch_b_msg_type {
   this.ch_b_msg_type inside {
       CH_B_PUT_FULL_DATA   ,
       CH_B_PUT_PARTIAL_DATA,
       CH_B_GET             ,
       CH_B_ARITHMETIC_DATA ,
       CH_B_LOGICAL_DATA    ,
       CH_B_INTENT          ,         
       CH_B_PROBE_BLOCK   ,
       CH_B_PROBE_PERM    
     };
   }

  /**
   * Valid constraint over b_param to generate valid b_param as per 
   * ch_b_msg_type values generated by Tilelink Slave components.
   */
  constraint valid_b_param {
    if(this.ch_b_msg_type == CH_B_PUT_FULL_DATA || this.ch_b_msg_type == CH_B_PUT_PARTIAL_DATA || this.ch_b_msg_type == CH_B_GET) {
      this.b_param == 0;
    } else if (this.ch_b_msg_type == CH_B_ARITHMETIC_DATA) {
      this.b_param inside {0,1,2,3,4};
    } else if (this.ch_b_msg_type == CH_B_LOGICAL_DATA) {
      this.b_param inside {0,1,2,3};
    } else if (this.ch_b_msg_type == CH_B_INTENT) {
      this.b_param inside {0,1};
    } else if (this.ch_b_msg_type == CH_B_PROBE_BLOCK || this.ch_b_msg_type == CH_B_PROBE_PERM) {
      this.b_param inside {0,1,2};
    }
  }

  /**
   * Valid constraint over b_size to generate valid b_size so as to transfer a max of 4k bytes
   * messages by Tilelink Slave components.
   */
  constraint valid_b_size
    { 
       this.b_size inside {[0:'hC]};
     }

  /**
   * Valid constraint over b_address to generate addresses aligned to b_size for any
   * messages by Tilelink Slave components.
   */
  constraint aligned_b_address
  {
    if(this.b_size==1){
      this.b_address[0] == 0;
    } else if(this.b_size==2){
        this.b_address[1:0] == 0;
    } else if(this.b_size==3){
        this.b_address[2:0] == 0;
    } else if(this.b_size==4){
        this.b_address[3:0] == 0;
    } else if(this.b_size==5){
        this.b_address[4:0] == 0;
    } else if(this.b_size==6){
        this.b_address[5:0] == 0;
    } else if(this.b_size==7){
        this.b_address[6:0] == 0;
    } else if(this.b_size==8){
        this.b_address[7:0] == 0;
    } else if(this.b_size==9){
        this.b_address[8:0] == 0;
    } else if(this.b_size==10){
        this.b_address[9:0] == 0;
    } else if(this.b_size==11){
        this.b_address[10:0] == 0;
    } else if(this.b_size==12){
        this.b_address[11:0] == 0;
    } 
  }

  /**
   * Valid constraint to create array of b_data of size 2**b_size for Tilelink Slave components.
   */
  constraint b_data_len { 
    if(this.ch_b_msg_type == CH_B_GET || this.ch_b_msg_type == CH_B_INTENT || this.ch_b_msg_type == CH_B_PROBE_BLOCK || this.ch_b_msg_type == CH_B_PROBE_PERM) {
       b_data.size() == 0;
     } else {
       b_data.size() == 2**b_size;
     }
  }

  /**
   * Valid constraint to create array of b_mask of size as large as number of beats to be transferred
   * in a Tilelink transaction by Tilelink Slave components.
   */
  constraint b_mask_len {
    if(this.ch_b_msg_type == CH_B_GET || this.ch_b_msg_type == CH_B_INTENT || this.ch_b_msg_type == CH_B_PROBE_BLOCK || this.ch_b_msg_type == CH_B_PROBE_PERM || 2**b_size <= cfg.data_width/8) {
      b_mask.size() == 1;
    } else if(2**b_size > cfg.data_width/8) {
      b_mask.size() == (2**b_size)/(cfg.data_width/8);
    } 
  }

  /**
   * Valid constraint to create array of b_corrupt of size as large as number of beats to be transferred
   * in a Tilelink transaction by Tilelink Slave components.
   */
  constraint b_corrupt_len {
    if(2**b_size <= cfg.data_width/8  || this.ch_b_msg_type == CH_B_GET || this.ch_b_msg_type == CH_B_INTENT || this.ch_b_msg_type == CH_B_PROBE_BLOCK || this.ch_b_msg_type == CH_B_PROBE_PERM) {
      b_corrupt.size() == 1;
    } else if(2**b_size > cfg.data_width/8) {
      b_corrupt.size() == (2**b_size)/(cfg.data_width/8);
    }
  }

  /**
   * Valid constraint to valid b_mask values for data-width 8 bits. 
   */
  constraint valid_b_mask_8_bit_data_width {
    if(cfg.data_width==8) {
      this.b_mask[0][127:1]==127'h0;
      if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
        this.b_mask[0][0]==1;
      } 
    }
  }

  /**
   * Valid constraint to valid b_mask values for data-width 8 bits. 
   */
  constraint valid_b_mask_16_bit_data_width {
    if(cfg.data_width==16) {
      if(b_size <= 1) {
        if(b_size[3:0]=='h0) {
          if(b_address[0]==0) {
            this.b_mask[0][127:1]==127'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][0]==1;
            } 
          } else if(b_address[0]==1) {
            this.b_mask[0][127:2]==126'h0;
            this.b_mask[0][0]==1'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1]==1;
            }
          }
        } else if(b_size[3:0]=='h1) {
          if(b_address[0]==0){
            this.b_mask[0][127:2]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1:0]==2'b11;
            }
          }
        }
      } else if(b_size>1) {
        foreach(b_mask[i]) {
          this.b_mask[i][127:2]==0;
           if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
            this.b_mask[i][1:0]==4'h3;
          }
        }
      }
    }
  }

  /**
   * Valid constraint to valid b_mask values for data-width 32 bits. 
   */
  constraint valid_b_mask_32_bit_data_width {
    if(cfg.data_width==32) {
      if(b_size <= 2) {
        if(b_size[3:0]=='h0) {
          if(b_address[1:0]==0) {
            this.b_mask[0][127:1]==127'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][0]==1;
            } 
          } else if(b_address[1:0]==1) {
            this.b_mask[0][127:2]==126'h0;
            this.b_mask[0][0]==1'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1]==1;
            }
          } else if(b_address[1:0]==2) {
            this.b_mask[0][127:3]==125'h0;
            this.b_mask[0][1:0]==2'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][2]==1;
            }
          } else if(b_address[1:0]==3) {
            this.b_mask[0][127:4]==124'h0;
            this.b_mask[0][2:0]==3'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3]==1;
            }
          }
        } else if(b_size[3:0]=='h1) {
          if(b_address[1:0]==0){
            this.b_mask[0][127:2]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1:0]==2'b11;
            }
          } else if(b_address[1:0]==2) {
            this.b_mask[0][127:4]==0;
            this.b_mask[0][1:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:2]==2'b11;
            }
          }
        } else if(b_size[3:0]=='h2) {
          if(b_address[1:0]=='h0) {
            this.b_mask[0][127:4]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:0]==4'hF;
            }
          }
        }
      } else if(b_size > 2) {
        foreach(b_mask[i]) {
          this.b_mask[i][127:4]==0;
          if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
            this.b_mask[i][3:0]==4'hF;
          }
        }
      }
    }
  }

  /**
   * Valid constraint to valid b_mask values for data-width 64 bits. 
   */
  constraint valid_b_mask_64_bit_data_width {
    if(cfg.data_width==64) {
      if(b_size <= 3 ) {
        if(b_size[3:0]=='h0) {
          if(b_address[2:0]==0) {
            this.b_mask[0][127:1]==127'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][0]==1;
            } 
          } else if(b_address[2:0]==1) {
            this.b_mask[0][127:2]==126'h0;
            this.b_mask[0][0]==1'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1]==1;
            }
          } else if(b_address[2:0]==2) {
            this.b_mask[0][127:3]==125'h0;
            this.b_mask[0][1:0]==2'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][2]==1;
            }
          } else if(b_address[2:0]==3) {
            this.b_mask[0][127:4]==124'h0;
            this.b_mask[0][2:0]==3'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3]==1;
            }
          } else if(b_address[2:0]==4) {
            this.b_mask[0][127:5]==123'h0;
            this.b_mask[0][3:0]==4'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][4]==1;
            }
          } else if(b_address[2:0]==5) {
            this.b_mask[0][127:6]==122'h0;
            this.b_mask[0][4:0]==5'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5]==1;
            }
          } else if(b_address[2:0]==6) {
            this.b_mask[0][127:7]==121'h0;
            this.b_mask[0][5:0]==6'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][6]==1;
            }
          } else if(b_address[2:0]==7) {
            this.b_mask[0][127:8]==120'h0;
            this.b_mask[0][6:0]==7'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7]==1;
            }
          }
        } else if(b_size[3:0]=='h1) {
          if(b_address[2:0]==0){
            this.b_mask[0][127:2]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1:0]==2'b11;
            }
          } else if(b_address[2:0]==2) {
            this.b_mask[0][127:4]==0;
            this.b_mask[0][1:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:2]==2'b11;
            }
          } else if(b_address[2:0]==4) {
            this.b_mask[0][127:6]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5:4]==2'b11;
            }
          } else if(b_address[2:0]==6) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][5:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:6]==2'b11;
            }
          }
        } else if(b_size[3:0]==2) {
          if(b_address[2:0]==0){
            this.b_mask[0][127:4]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:0]==4'b1111;
            }
          } else if(b_address[2:0]==4) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:4]==4'b1111;
            }
          }
        } else if(b_size[3:0]==4'h3) {
          if(b_address[2:0]==0){
            this.b_mask[0][127:8]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:0]==8'hFF;
            }
          }
        }
      } else if(b_size > 3) {
        foreach(b_mask[i]) {
          this.b_mask[i][127:8]=='h0;
          if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
            this.b_mask[i][7:0]==8'hFF;
          }
        }
      }
    }
  }

  /**
   * Valid constraint to valid b_mask values for data-width 128 bits. 
   */
  constraint valid_b_mask_128_bit_data_width {
    if(cfg.data_width==128) {
      if(b_size <=4){
        if(b_size[3:0]==4'h0) {
          if(b_address[3:0]==4'h0) {
            this.b_mask[0][127:1]==127'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][0]==1;
            } 
          } else if(b_address[3:0]==4'h1) {
            this.b_mask[0][127:2]==126'h0;
            this.b_mask[0][0]==1'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1]==1;
            }
          } else if(b_address[3:0]==2) {
            this.b_mask[0][127:3]==125'h0;
            this.b_mask[0][1:0]==2'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][2]==1;
            }
          } else if(b_address[3:0]==4'h3) {
            this.b_mask[0][127:4]==124'h0;
            this.b_mask[0][2:0]==3'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3]==1;
            }
          } else if(b_address[3:0]==4'h4) {
            this.b_mask[0][127:5]==123'h0;
            this.b_mask[0][3:0]==4'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][4]==1;
            }
          } else if(b_address[3:0]==4'h5) {
            this.b_mask[0][127:6]==122'h0;
            this.b_mask[0][4:0]==5'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5]==1;
            }
          } else if(b_address[3:0]==4'h6) {
            this.b_mask[0][127:7]==121'h0;
            this.b_mask[0][5:0]==6'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][6]==1;
            }
          } else if(b_address[3:0]==4'h7) {
            this.b_mask[0][127:8]==120'h0;
            this.b_mask[0][6:0]==7'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7]==1;
            }
          } else if(b_address[3:0]==4'h8) {
            this.b_mask[0][127:9]==119'h0;
            this.b_mask[0][7:0]==8'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][8]==1;
            }
          } else if(b_address[3:0]==4'h9) {
            this.b_mask[0][127:10]==118'h0;
            this.b_mask[0][8:0]==9'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][9]==1;
            }
          } else if(b_address[3:0]==4'hA) {
            this.b_mask[0][127:11]==117'h0;
            this.b_mask[0][9:0]==10'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][10]==1;
            }
          } else if(b_address[3:0]==4'hB) {
            this.b_mask[0][127:12]==116'h0;
            this.b_mask[0][10:0]==11'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11]==1;
            }
          } else if(b_address[3:0]==4'hC) {
            this.b_mask[0][127:13]==115'h0;
            this.b_mask[0][11:0]==12'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][12]==1;
            }
          } else if(b_address[3:0]==4'hD) {
            this.b_mask[0][127:14]==114'h0;
            this.b_mask[0][12:0]==13'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][13]==1;
            }
          } else if(b_address[3:0]==4'hE) {
            this.b_mask[0][127:15]==113'h0;
            this.b_mask[0][13:0]==14'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][14]==1;
            }
          } else if(b_address[3:0]=='hF) {
            this.b_mask[0][127:16]==112'b0;
            this.b_mask[0][14:0]==15'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15]==1'b1;
            }
          }
        } else if(b_size[3:0]==4'h1) {
          if(b_address[3:0]=='h0){
            this.b_mask[0][127:2]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1:0]==2'b11;
            }
          } else if(b_address[3:0]=='h2) {
            this.b_mask[0][127:4]==0;
            this.b_mask[0][1:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:2]==2'b11;
            }
          } else if(b_address[3:0]=='h4) {
            this.b_mask[0][127:6]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5:4]==2'b11;
            }
          } else if(b_address[3:0]=='h6) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][5:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:6]==2'b11;
            }
          } else if(b_address[3:0]=='h8) {
            this.b_mask[0][127:10]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][9:8]==2'b11;
            }
          } else if(b_address[3:0]=='hA) {
            this.b_mask[0][127:12]==0;
            this.b_mask[0][9:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11:10]==2'b11;
            }
          } else if(b_address[3:0]=='hC) {
            this.b_mask[0][127:14]==0;
            this.b_mask[0][11:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][13:12]==2'b11;
            }
          } else if(b_address[3:0]=='hE) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][13:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:14]==2'b11;
            }
          }
        } else if(b_size[3:0]==4'h2) {
          if(b_address[3:0]=='h0){
            this.b_mask[0][127:4]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:0]==4'b1111;
            }
          } else if(b_address[3:0]=='h4) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:4]==4'b1111;
            }
          } else if(b_address[3:0]=='h8) {
            this.b_mask[0][127:12]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11:8]==4'b1111;
            }
          } else if(b_address[3:0]=='hC) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][11:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:12]==4'b1111;
            }
          }
        } else if(b_size[3:0]==4'h3) {
          if(b_address[3:0]=='h0){
            this.b_mask[0][127:8]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:0]==8'hFF;
            }
          } else if(b_address[3:0]=='h8) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:8]==8'hFF;
            }
          }
        } else if(b_size[3:0]=='h4) {
          if(b_address[3:0]=='h0) {
            this.b_mask[0][127:16]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:0]==16'hFFFF;
            }
          }
        }
      } else if (b_size>4) {
        foreach(b_mask[i]) {
          b_mask[i][127:16]=='h0;
          if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
            this.b_mask[i][15:0]==16'hFFFF;
          }
        }
      }
    }
  }

  /**
   * Valid constraint to valid b_mask values for data-width 256 bits. 
   */
  constraint valid_b_mask_256_bit_data_width {
    if(cfg.data_width==256) {
      if(b_size <=5){
        if(b_size[3:0]==4'h0) {
          if(b_address[4:0]=='h0) {
            this.b_mask[0][127:1]==127'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][0]==1;
            } 
          } else if(b_address[4:0]=='h1) {
            this.b_mask[0][127:2]==126'h0;
            this.b_mask[0][0]==1'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1]==1;
            }
          } else if(b_address[4:0]=='h2) {
            this.b_mask[0][127:3]==125'h0;
            this.b_mask[0][1:0]==2'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][2]==1;
            }
          } else if(b_address[4:0]=='h3) {
            this.b_mask[0][127:4]==124'h0;
            this.b_mask[0][2:0]==3'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3]==1;
            }
          } else if(b_address[4:0]=='h4) {
            this.b_mask[0][127:5]==123'h0;
            this.b_mask[0][3:0]==4'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][4]==1;
            }
          } else if(b_address[4:0]=='h5) {
            this.b_mask[0][127:6]==122'h0;
            this.b_mask[0][4:0]==5'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5]==1;
            }
          } else if(b_address[4:0]=='h6) {
            this.b_mask[0][127:7]==121'h0;
            this.b_mask[0][5:0]==6'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][6]==1;
            }
          } else if(b_address[4:0]=='h7) {
            this.b_mask[0][127:8]==120'h0;
            this.b_mask[0][6:0]==7'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7]==1;
            }
          } else if(b_address[4:0]=='h8) {
            this.b_mask[0][127:9]==119'h0;
            this.b_mask[0][7:0]==8'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][8]==1;
            }
          } else if(b_address[4:0]=='h9) {
            this.b_mask[0][127:10]==118'h0;
            this.b_mask[0][8:0]==9'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][9]==1;
            }
          } else if(b_address[4:0]=='hA) {
            this.b_mask[0][127:11]==117'h0;
            this.b_mask[0][9:0]==10'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][10]==1;
            }
          } else if(b_address[4:0]=='hB) {
            this.b_mask[0][127:12]==116'h0;
            this.b_mask[0][10:0]==11'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11]==1;
            }
          } else if(b_address[4:0]=='hC) {
            this.b_mask[0][127:13]==115'h0;
            this.b_mask[0][11:0]==12'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][12]==1;
            }
          } else if(b_address[4:0]=='hD) {
            this.b_mask[0][127:14]==114'h0;
            this.b_mask[0][12:0]==13'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][13]==1;
            }
          } else if(b_address[4:0]=='hE) {
            this.b_mask[0][127:15]==113'h0;
            this.b_mask[0][13:0]==14'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][14]==1;
            }
          } else if(b_address[4:0]=='hF) {
            this.b_mask[0][127:16]==112'b0;
            this.b_mask[0][14:0]==15'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15]==1'b1;
            }
          } else if(b_address[4:0]=='h10) {
            this.b_mask[0][127:17]=='h0;
            this.b_mask[0][15:0]==16'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][16]==1;
            } 
          } else if(b_address[4:0]=='h11) {
            this.b_mask[0][127:18]=='h0;
            this.b_mask[0][16:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][17]==1;
            }
          } else if(b_address[4:0]=='h12) {
            this.b_mask[0][127:19]=='h0;
            this.b_mask[0][17:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][18]==1;
            }
          } else if(b_address[4:0]=='h13) {
            this.b_mask[0][127:20]=='h0;
            this.b_mask[0][18:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19]==1;
            }
          } else if(b_address[4:0]=='h14) {
            this.b_mask[0][127:21]=='h0;
            this.b_mask[0][19:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][20]==1;
            }
          } else if(b_address[4:0]=='h15) {
            this.b_mask[0][127:22]=='h0;
            this.b_mask[0][20:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][21]==1;
            }
          } else if(b_address[4:0]=='h16) {
            this.b_mask[0][127:23]=='h0;
            this.b_mask[0][21:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][22]==1;
            }
          } else if(b_address[4:0]=='h17) {
            this.b_mask[0][127:24]=='h0;
            this.b_mask[0][22:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23]==1;
            }
          } else if(b_address[4:0]=='h18) {
            this.b_mask[0][127:25]=='h0;
            this.b_mask[0][23:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][24]==1;
            }
          } else if(b_address[4:0]=='h19) {
            this.b_mask[0][127:26]=='h0;
            this.b_mask[0][24:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][25]==1;
            }
          } else if(b_address[4:0]=='h1A) {
            this.b_mask[0][127:27]=='h0;
            this.b_mask[0][25:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][26]==1;
            }
          } else if(b_address[4:0]=='h1B) {
            this.b_mask[0][127:28]=='h0;
            this.b_mask[0][26:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27]==1;
            }
          } else if(b_address[4:0]=='h1C) {
            this.b_mask[0][127:29]=='h0;
            this.b_mask[0][27:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][28]==1;
            }
          } else if(b_address[4:0]=='h1D) {
            this.b_mask[0][127:30]=='h0;
            this.b_mask[0][28:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][29]==1;
            }
          } else if(b_address[4:0]=='h1E) {
            this.b_mask[0][127:31]=='h0;
            this.b_mask[0][29:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][30]==1;
            }
          } else if(b_address[4:0]=='h1F) {
            this.b_mask[0][127:32]=='h0;
            this.b_mask[0][30:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31]==1'b1;
            }
          }
        } else if(b_size[3:0]==4'h1) {
          if(b_address[4:0]=='h0){
            this.b_mask[0][127:2]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1:0]==2'b11;
            }
          } else if(b_address[4:0]=='h2) {
            this.b_mask[0][127:4]==0;
            this.b_mask[0][1:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:2]==2'b11;
            }
          } else if(b_address[4:0]=='h4) {
            this.b_mask[0][127:6]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5:4]==2'b11;
            }
          } else if(b_address[4:0]=='h6) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][5:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:6]==2'b11;
            }
          } else if(b_address[4:0]=='h8) {
            this.b_mask[0][127:10]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][9:8]==2'b11;
            }
          } else if(b_address[4:0]=='hA) {
            this.b_mask[0][127:12]==0;
            this.b_mask[0][9:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11:10]==2'b11;
            }
          } else if(b_address[4:0]=='hC) {
            this.b_mask[0][127:14]==0;
            this.b_mask[0][11:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][13:12]==2'b11;
            }
          } else if(b_address[4:0]=='hE) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][13:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:14]==2'b11;
            }
          } else if(b_address[4:0]=='h10){
            this.b_mask[0][127:18]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][17:16]==2'b11;
            }
          } else if(b_address[4:0]=='h12) {
            this.b_mask[0][127:20]==0;
            this.b_mask[0][17:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19:18]==2'b11;
            }
          } else if(b_address[4:0]=='h14) {
            this.b_mask[0][127:22]==0;
            this.b_mask[0][19:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][21:20]==2'b11;
            }
          } else if(b_address[4:0]=='h16) {
            this.b_mask[0][127:24]==0;
            this.b_mask[0][21:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:22]==2'b11;
            }
          } else if(b_address[4:0]=='h18) {
            this.b_mask[0][127:26]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][25:24]==2'b11;
            }
          } else if(b_address[4:0]=='h1A) {
            this.b_mask[0][127:28]==0;
            this.b_mask[0][25:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27:26]==2'b11;
            }
          } else if(b_address[4:0]=='h1C) {
            this.b_mask[0][127:30]==0;
            this.b_mask[0][27:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][29:28]==2'b11;
            }
          } else if(b_address[4:0]=='h1E) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][29:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:30]==2'b11;
            }
          }
        } else if(b_size[3:0]==4'h2) {
          if(b_address[4:0]=='h0){
            this.b_mask[0][127:4]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:0]==4'b1111;
            }
          } else if(b_address[4:0]=='h4) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:4]==4'b1111;
            }
          } else if(b_address[4:0]=='h8) {
            this.b_mask[0][127:12]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11:8]==4'b1111;
            }
          } else if(b_address[4:0]=='hC) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][11:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:12]==4'b1111;
            }
          } else if(b_address[4:0]=='h10){
            this.b_mask[0][127:20]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19:16]==4'b1111;
            }
          } else if(b_address[4:0]=='h14) {
            this.b_mask[0][127:24]==0;
            this.b_mask[0][19:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:20]==4'b1111;
            }
          } else if(b_address[4:0]=='h18) {
            this.b_mask[0][127:28]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27:24]==4'b1111;
            }
          } else if(b_address[4:0]=='h1C) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][27:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:28]==4'b1111;
            }
          }
        } else if(b_size[3:0]==4'h3) {
          if(b_address[4:0]=='h0){
            this.b_mask[0][127:8]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:0]==8'hFF;
            }
          } else if(b_address[4:0]=='h8) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:8]==8'hFF;
            }
          } if(b_address[4:0]=='h10){
            this.b_mask[0][127:24]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:16]==8'hFF;
            }
          } else if(b_address[4:0]=='h18) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:24]==8'hFF;
            }
          }
        } else if(b_size[3:0]=='h4) {
          if(b_address[4:0]=='h0) {
            this.b_mask[0][127:16]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:0]==16'hFFFF;
            }
          } if(b_address[4:0]=='h10) {
            this.b_mask[0][127:32]=='h0;
            this.b_mask[0][15:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:16]==16'hFFFF;
            }
          }
        } else if(b_size[3:0]=='h5) {
          if(b_address[4:0]=='h0) {
            this.b_mask[0][127:32]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:0]==32'hFFFFFFFF;
            }
          }
        }
      } else if (b_size>5) {
        foreach(b_mask[i]) {
          b_mask[i][127:32]=='h0;
          if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
            this.b_mask[i][31:0]==32'hFFFFFFFF;
          }
        }
      }
    }
  }

  /**
   * Valid constraint to valid b_mask values for data-width 512 bits. 
   */
  constraint valid_b_mask_512_bit_data_width {
    if(cfg.data_width==512) {
      if(b_size<=6){
        if(b_size[3:0]==4'h0) {
          if(b_address[5:0]=='h0) {
            this.b_mask[0][127:1]==127'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][0]==1;
            } 
          } else if(b_address[5:0]=='h1) {
            this.b_mask[0][127:2]==126'h0;
            this.b_mask[0][0]==1'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1]==1;
            }
          } else if(b_address[5:0]=='h2) {
            this.b_mask[0][127:3]==125'h0;
            this.b_mask[0][1:0]==2'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][2]==1;
            }
          } else if(b_address[5:0]=='h3) {
            this.b_mask[0][127:4]==124'h0;
            this.b_mask[0][2:0]==3'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3]==1;
            }
          } else if(b_address[5:0]=='h4) {
            this.b_mask[0][127:5]==123'h0;
            this.b_mask[0][3:0]==4'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][4]==1;
            }
          } else if(b_address[5:0]=='h5) {
            this.b_mask[0][127:6]==122'h0;
            this.b_mask[0][4:0]==5'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5]==1;
            }
          } else if(b_address[5:0]=='h6) {
            this.b_mask[0][127:7]==121'h0;
            this.b_mask[0][5:0]==6'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][6]==1;
            }
          } else if(b_address[5:0]=='h7) {
            this.b_mask[0][127:8]==120'h0;
            this.b_mask[0][6:0]==7'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7]==1;
            }
          } else if(b_address[5:0]=='h8) {
            this.b_mask[0][127:9]==119'h0;
            this.b_mask[0][7:0]==8'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][8]==1;
            }
          } else if(b_address[5:0]=='h9) {
            this.b_mask[0][127:10]==118'h0;
            this.b_mask[0][8:0]==9'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][9]==1;
            }
          } else if(b_address[5:0]=='hA) {
            this.b_mask[0][127:11]==117'h0;
            this.b_mask[0][9:0]==10'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][10]==1;
            }
          } else if(b_address[5:0]=='hB) {
            this.b_mask[0][127:12]==116'h0;
            this.b_mask[0][10:0]==11'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11]==1;
            }
          } else if(b_address[5:0]=='hC) {
            this.b_mask[0][127:13]==115'h0;
            this.b_mask[0][11:0]==12'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][12]==1;
            }
          } else if(b_address[5:0]=='hD) {
            this.b_mask[0][127:14]==114'h0;
            this.b_mask[0][12:0]==13'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][13]==1;
            }
          } else if(b_address[5:0]=='hE) {
            this.b_mask[0][127:15]==113'h0;
            this.b_mask[0][13:0]==14'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][14]==1;
            }
          } else if(b_address[5:0]=='hF) {
            this.b_mask[0][127:16]==112'b0;
            this.b_mask[0][14:0]==15'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15]==1'b1;
            }
          } else if(b_address[5:0]=='h10) {
            this.b_mask[0][127:17]=='h0;
            this.b_mask[0][15:0]==16'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][16]==1;
            } 
          } else if(b_address[5:0]=='h11) {
            this.b_mask[0][127:18]=='h0;
            this.b_mask[0][16:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][17]==1;
            }
          } else if(b_address[5:0]=='h12) {
            this.b_mask[0][127:19]=='h0;
            this.b_mask[0][17:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][18]==1;
            }
          } else if(b_address[5:0]=='h13) {
            this.b_mask[0][127:20]=='h0;
            this.b_mask[0][18:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19]==1;
            }
          } else if(b_address[5:0]=='h14) {
            this.b_mask[0][127:21]=='h0;
            this.b_mask[0][19:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][20]==1;
            }
          } else if(b_address[5:0]=='h15) {
            this.b_mask[0][127:22]=='h0;
            this.b_mask[0][20:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][21]==1;
            }
          } else if(b_address[5:0]=='h16) {
            this.b_mask[0][127:23]=='h0;
            this.b_mask[0][21:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][22]==1;
            }
          } else if(b_address[5:0]=='h17) {
            this.b_mask[0][127:24]=='h0;
            this.b_mask[0][22:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23]==1;
            }
          } else if(b_address[5:0]=='h18) {
            this.b_mask[0][127:25]=='h0;
            this.b_mask[0][23:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][24]==1;
            }
          } else if(b_address[5:0]=='h19) {
            this.b_mask[0][127:26]=='h0;
            this.b_mask[0][24:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][25]==1;
            }
          } else if(b_address[5:0]=='h1A) {
            this.b_mask[0][127:27]=='h0;
            this.b_mask[0][25:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][26]==1;
            }
          } else if(b_address[5:0]=='h1B) {
            this.b_mask[0][127:28]=='h0;
            this.b_mask[0][26:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27]==1;
            }
          } else if(b_address[5:0]=='h1C) {
            this.b_mask[0][127:29]=='h0;
            this.b_mask[0][27:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][28]==1;
            }
          } else if(b_address[5:0]=='h1D) {
            this.b_mask[0][127:30]=='h0;
            this.b_mask[0][28:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][29]==1;
            }
          } else if(b_address[5:0]=='h1E) {
            this.b_mask[0][127:31]=='h0;
            this.b_mask[0][29:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][30]==1;
            }
          } else if(b_address[5:0]=='h1F) {
            this.b_mask[0][127:32]=='h0;
            this.b_mask[0][30:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31]==1'b1;
            }
          } else if(b_address[5:0]=='h20) {
            this.b_mask[0][127:33]=='h0;
            this.b_mask[0][31:0]==16'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][32]==1;
            } 
          } else if(b_address[5:0]=='h21) {
            this.b_mask[0][127:34]=='h0;
            this.b_mask[0][32:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][33]==1;
            }
          } else if(b_address[5:0]=='h22) {
            this.b_mask[0][127:35]=='h0;
            this.b_mask[0][33:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][34]==1;
            }
          } else if(b_address[5:0]=='h23) {
            this.b_mask[0][127:36]=='h0;
            this.b_mask[0][34:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][35]==1;
            }
          } else if(b_address[5:0]=='h24) {
            this.b_mask[0][127:37]=='h0;
            this.b_mask[0][35:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][36]==1;
            }
          } else if(b_address[5:0]=='h25) {
            this.b_mask[0][127:38]=='h0;
            this.b_mask[0][36:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][37]==1;
            }
          } else if(b_address[5:0]=='h26) {
            this.b_mask[0][127:39]=='h0;
            this.b_mask[0][37:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][38]==1;
            }
          } else if(b_address[5:0]=='h27) {
            this.b_mask[0][127:40]=='h0;
            this.b_mask[0][38:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][39]==1;
            }
          } else if(b_address[5:0]=='h28) {
            this.b_mask[0][127:41]=='h0;
            this.b_mask[0][39:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][40]==1;
            }
          } else if(b_address[5:0]=='h29) {
            this.b_mask[0][127:42]=='h0;
            this.b_mask[0][40:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][41]==1;
            }
          } else if(b_address[5:0]=='h2A) {
            this.b_mask[0][127:43]=='h0;
            this.b_mask[0][41:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][42]==1;
            }
          } else if(b_address[5:0]=='h2B) {
            this.b_mask[0][127:44]=='h0;
            this.b_mask[0][42:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][43]==1;
            }
          } else if(b_address[5:0]=='h2C) {
            this.b_mask[0][127:45]=='h0;
            this.b_mask[0][43:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][44]==1;
            }
          } else if(b_address[5:0]=='h2D) {
            this.b_mask[0][127:46]=='h0;
            this.b_mask[0][44:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][45]==1;
            }
          } else if(b_address[5:0]=='h2E) {
            this.b_mask[0][127:47]=='h0;
            this.b_mask[0][45:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][46]==1;
            }
          } else if(b_address[5:0]=='h2F) {
            this.b_mask[0][127:48]=='h0;
            this.b_mask[0][46:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47]==1'b1;
            }
          } else if(b_address[5:0]=='h30) {
            this.b_mask[0][127:49]=='h0;
            this.b_mask[0][47:0]==16'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][48]==1;
            } 
          } else if(b_address[5:0]=='h31) {
            this.b_mask[0][127:50]=='h0;
            this.b_mask[0][48:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][49]==1;
            }
          } else if(b_address[5:0]=='h32) {
            this.b_mask[0][127:51]=='h0;
            this.b_mask[0][49:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][50]==1;
            }
          } else if(b_address[5:0]=='h33) {
            this.b_mask[0][127:52]=='h0;
            this.b_mask[0][50:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][51]==1;
            }
          } else if(b_address[5:0]=='h34) {
            this.b_mask[0][127:53]=='h0;
            this.b_mask[0][51:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][52]==1;
            }
          } else if(b_address[5:0]=='h35) {
            this.b_mask[0][127:54]=='h0;
            this.b_mask[0][52:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][53]==1;
            }
          } else if(b_address[5:0]=='h36) {
            this.b_mask[0][127:55]=='h0;
            this.b_mask[0][53:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][54]==1;
            }
          } else if(b_address[5:0]=='h37) {
            this.b_mask[0][127:56]=='h0;
            this.b_mask[0][54:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][55]==1;
            }
          } else if(b_address[5:0]=='h38) {
            this.b_mask[0][127:57]=='h0;
            this.b_mask[0][55:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][56]==1;
            }
          } else if(b_address[5:0]=='h39) {
            this.b_mask[0][127:58]=='h0;
            this.b_mask[0][56:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][57]==1;
            }
          } else if(b_address[5:0]=='h3A) {
            this.b_mask[0][127:59]=='h0;
            this.b_mask[0][57:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][58]==1;
            }
          } else if(b_address[5:0]=='h3B) {
            this.b_mask[0][127:60]=='h0;
            this.b_mask[0][58:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][59]==1;
            }
          } else if(b_address[5:0]=='h3C) {
            this.b_mask[0][127:61]=='h0;
            this.b_mask[0][59:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][60]==1;
            }
          } else if(b_address[5:0]=='h3D) {
            this.b_mask[0][127:62]=='h0;
            this.b_mask[0][60:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][61]==1;
            }
          } else if(b_address[5:0]=='h3E) {
            this.b_mask[0][127:63]=='h0;
            this.b_mask[0][61:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][62]==1;
            }
          } else if(b_address[5:0]=='h3F) {
            this.b_mask[0][127:64]=='h0;
            this.b_mask[0][62:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63]==1'b1;
            }
          }
        } else if(b_size[3:0]==4'h1) {
          if(b_address[5:0]=='h0){
            this.b_mask[0][127:2]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1:0]==2'b11;
            }
          } else if(b_address[5:0]=='h2) {
            this.b_mask[0][127:4]==0;
            this.b_mask[0][1:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:2]==2'b11;
            }
          } else if(b_address[5:0]=='h4) {
            this.b_mask[0][127:6]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5:4]==2'b11;
            }
          } else if(b_address[5:0]=='h6) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][5:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:6]==2'b11;
            }
          } else if(b_address[5:0]=='h8) {
            this.b_mask[0][127:10]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][9:8]==2'b11;
            }
          } else if(b_address[5:0]=='hA) {
            this.b_mask[0][127:12]==0;
            this.b_mask[0][9:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11:10]==2'b11;
            }
          } else if(b_address[5:0]=='hC) {
            this.b_mask[0][127:14]==0;
            this.b_mask[0][11:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][13:12]==2'b11;
            }
          } else if(b_address[5:0]=='hE) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][13:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:14]==2'b11;
            }
          } else if(b_address[5:0]=='h10){
            this.b_mask[0][127:18]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][17:16]==2'b11;
            }
          } else if(b_address[5:0]=='h12) {
            this.b_mask[0][127:20]==0;
            this.b_mask[0][17:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19:18]==2'b11;
            }
          } else if(b_address[5:0]=='h14) {
            this.b_mask[0][127:22]==0;
            this.b_mask[0][19:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][21:20]==2'b11;
            }
          } else if(b_address[5:0]=='h16) {
            this.b_mask[0][127:24]==0;
            this.b_mask[0][21:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:22]==2'b11;
            }
          } else if(b_address[5:0]=='h18) {
            this.b_mask[0][127:26]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][25:24]==2'b11;
            }
          } else if(b_address[5:0]=='h1A) {
            this.b_mask[0][127:28]==0;
            this.b_mask[0][25:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27:26]==2'b11;
            }
          } else if(b_address[5:0]=='h1C) {
            this.b_mask[0][127:30]==0;
            this.b_mask[0][27:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][29:28]==2'b11;
            }
          } else if(b_address[5:0]=='h1E) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][29:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:30]==2'b11;
            }
          } else if(b_address[5:0]=='h20){
            this.b_mask[0][127:34]==0;
            this.b_mask[0][31:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
            this.b_mask[0][33:32]==2'b11;
            }
          } else if(b_address[5:0]=='h22) {
            this.b_mask[0][127:36]==0;
            this.b_mask[0][33:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][35:34]==2'b11;
            }
          } else if(b_address[5:0]=='h24) {
            this.b_mask[0][127:38]==0;
            this.b_mask[0][35:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][37:36]==2'b11;
            }
          } else if(b_address[5:0]=='h26) {
            this.b_mask[0][127:40]==0;
            this.b_mask[0][37:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][39:38]==2'b11;
            }
          } else if(b_address[5:0]=='h28) {
            this.b_mask[0][127:42]==0;
            this.b_mask[0][39:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][41:40]==2'b11;
            }
          } else if(b_address[5:0]=='h2A) {
            this.b_mask[0][127:44]==0;
            this.b_mask[0][41:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][43:42]==2'b11;
            }
          } else if(b_address[5:0]=='h2C) {
            this.b_mask[0][127:46]==0;
            this.b_mask[0][43:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][45:44]==2'b11;
            }
          } else if(b_address[5:0]=='h2E) {
            this.b_mask[0][127:48]==0;
            this.b_mask[0][45:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47:46]==2'b11;
            }
          } else if(b_address[5:0]=='h30){
            this.b_mask[0][127:50]==0;
            this.b_mask[0][47:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][49:48]==2'b11;
            }
          } else if(b_address[5:0]=='h32) {
            this.b_mask[0][127:52]==0;
            this.b_mask[0][49:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][51:50]==2'b11;
            }
          } else if(b_address[5:0]=='h34) {
            this.b_mask[0][127:54]==0;
            this.b_mask[0][51:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][53:52]==2'b11;
            }
          } else if(b_address[5:0]=='h36) {
            this.b_mask[0][127:56]==0;
            this.b_mask[0][53:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][55:54]==2'b11;
            }
          } else if(b_address[5:0]=='h38) {
            this.b_mask[0][127:58]==0;
            this.b_mask[0][55:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][57:56]==2'b11;
            }
          } else if(b_address[5:0]=='h3A) {
            this.b_mask[0][127:60]==0;
            this.b_mask[0][57:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][59:58]==2'b11;
            }
          } else if(b_address[5:0]=='h3C) {
            this.b_mask[0][127:62]==0;
            this.b_mask[0][59:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][61:60]==2'b11;
            }
          } else if(b_address[5:0]=='h3E) {
            this.b_mask[0][127:64]==0;
            this.b_mask[0][61:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:62]==2'b11;
            }
          }
        } else if(b_size[3:0]==4'h2) {
          if(b_address[5:0]=='h0){
            this.b_mask[0][127:4]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:0]==4'b1111;
            }
          } else if(b_address[5:0]=='h4) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:4]==4'b1111;
            }
          } else if(b_address[5:0]=='h8) {
            this.b_mask[0][127:12]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11:8]==4'b1111;
            }
          } else if(b_address[5:0]=='hC) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][11:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:12]==4'b1111;
            }
          } else if(b_address[5:0]=='h10){
            this.b_mask[0][127:20]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19:16]==4'b1111;
            }
          } else if(b_address[5:0]=='h14) {
            this.b_mask[0][127:24]==0;
            this.b_mask[0][19:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:20]==4'b1111;
            }
          } else if(b_address[5:0]=='h18) {
            this.b_mask[0][127:28]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27:24]==4'b1111;
            }
          } else if(b_address[5:0]=='h1C) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][27:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:28]==4'b1111;
            }
          } else if(b_address[5:0]=='h20){
            this.b_mask[0][127:36]==0;
            this.b_mask[0][31:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][35:32]==4'b1111;
            }
          } else if(b_address[5:0]=='h24) {
            this.b_mask[0][127:40]==0;
            this.b_mask[0][35:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][39:36]==4'b1111;
            }
          } else if(b_address[5:0]=='h28) {
            this.b_mask[0][127:44]==0;
            this.b_mask[0][39:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][43:40]==4'b1111;
            }
          } else if(b_address[5:0]=='h2C) {
            this.b_mask[0][127:48]==0;
            this.b_mask[0][43:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47:44]==4'b1111;
            }
          } else if(b_address[5:0]=='h30){
            this.b_mask[0][127:52]==0;
            this.b_mask[0][47:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][51:48]==4'b1111;
            }
          } else if(b_address[5:0]=='h34) {
            this.b_mask[0][127:56]==0;
            this.b_mask[0][51:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][55:52]==4'b1111;
            }
          } else if(b_address[5:0]=='h38) {
            this.b_mask[0][127:60]==0;
            this.b_mask[0][55:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][59:56]==4'b1111;
            }
          } else if(b_address[5:0]=='h3C) {
            this.b_mask[0][127:64]==0;
            this.b_mask[0][59:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:60]==4'b1111;
            }
          }
        } else if(b_size[3:0]==4'h3) {
          if(b_address[5:0]=='h0){
            this.b_mask[0][127:8]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:0]==8'hFF;
            }
          } else if(b_address[5:0]=='h8) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:8]==8'hFF;
            }
          } if(b_address[5:0]=='h10){
            this.b_mask[0][127:24]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:16]==8'hFF;
            }
          } else if(b_address[5:0]=='h18) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:24]==8'hFF;
            }
          } else if(b_address[5:0]=='h20){
            this.b_mask[0][127:40]==0;
            this.b_mask[0][31:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][39:32]==8'hFF;
            }
          } else if(b_address[5:0]=='h28) {
            this.b_mask[0][127:48]==0;
            this.b_mask[0][39:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47:40]==8'hFF;
            }
          } else if(b_address[5:0]=='h30){
            this.b_mask[0][127:56]==0;
            this.b_mask[0][47:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][55:48]==8'hFF;
            }
          } else if(b_address[5:0]=='h38) {
            this.b_mask[0][127:64]==0;
            this.b_mask[0][55:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:56]==8'hFF;
            }
          }
        } else if(b_size[3:0]=='h4) {
          if(b_address[5:0]=='h0) {
            this.b_mask[0][127:16]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:0]==16'hFFFF;
            }
          } if(b_address[5:0]=='h10) {
            this.b_mask[0][127:32]=='h0;
            this.b_mask[0][15:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:16]==16'hFFFF;
            }
          } if(b_address[5:0]=='h20) {
            this.b_mask[0][127:48]=='h0;
            this.b_mask[0][31:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47:32]==16'hFFFF;
            }
          } else if(b_address[5:0]=='h30) {
            this.b_mask[0][127:64]=='h0;
            this.b_mask[0][47:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:48]==16'hFFFF;
            }
          }
        } else if(b_size[3:0]=='h5) {
          if(b_address[5:0]=='h0) {
            this.b_mask[0][127:32]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:0]==32'hFFFFFFFF;
            }
          } else if(b_address[5:0]=='h20) {
            this.b_mask[0][127:64]=='h0;
            this.b_mask[0][31:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:32]==32'hFFFFFFFF;
            }
          }
        } else if(b_size[3:0]=='h6) {
          if(b_address[5:0]=='h0) {
            this.b_mask[0][127:64]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:0]=='1;
            }
          }
        }
      } else if (b_size>6) {
        foreach(b_mask[i]) {
          b_mask[i][127:64]=='h0;
          if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
            this.b_mask[i][63:0]==64'hFFFFFFFFFFFFFFFF;
          }
        }
      }
    }
  }

  /**
   * Valid constraint to valid b_mask values for data-width 1024 bits. 
   */
  constraint valid_b_mask_1024_bit_data_width {
    if(cfg.data_width==1024) {
      if(b_size<=7){
        if(b_size[3:0]==4'h0) {
          if(b_address[6:0]=='h0) {
            this.b_mask[0][127:1]==127'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][0]==1;
            } 
          } else if(b_address[6:0]=='h1) {
            this.b_mask[0][127:2]==126'h0;
            this.b_mask[0][0]==1'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1]==1;
            }
          } else if(b_address[6:0]=='h2) {
            this.b_mask[0][127:3]==125'h0;
            this.b_mask[0][1:0]==2'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][2]==1;
            }
          } else if(b_address[6:0]=='h3) {
            this.b_mask[0][127:4]==124'h0;
            this.b_mask[0][2:0]==3'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3]==1;
            }
          } else if(b_address[6:0]=='h4) {
            this.b_mask[0][127:5]==123'h0;
            this.b_mask[0][3:0]==4'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][4]==1;
            }
          } else if(b_address[6:0]=='h5) {
            this.b_mask[0][127:6]==122'h0;
            this.b_mask[0][4:0]==5'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5]==1;
            }
          } else if(b_address[6:0]=='h6) {
            this.b_mask[0][127:7]==121'h0;
            this.b_mask[0][5:0]==6'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][6]==1;
            }
          } else if(b_address[6:0]=='h7) {
            this.b_mask[0][127:8]==120'h0;
            this.b_mask[0][6:0]==7'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7]==1;
            }
          } else if(b_address[6:0]=='h8) {
            this.b_mask[0][127:9]==119'h0;
            this.b_mask[0][7:0]==8'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][8]==1;
            }
          } else if(b_address[6:0]=='h9) {
            this.b_mask[0][127:10]==118'h0;
            this.b_mask[0][8:0]==9'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][9]==1;
            }
          } else if(b_address[6:0]=='hA) {
            this.b_mask[0][127:11]==117'h0;
            this.b_mask[0][9:0]==10'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][10]==1;
            }
          } else if(b_address[6:0]=='hB) {
            this.b_mask[0][127:12]==116'h0;
            this.b_mask[0][10:0]==11'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11]==1;
            }
          } else if(b_address[6:0]=='hC) {
            this.b_mask[0][127:13]==115'h0;
            this.b_mask[0][11:0]==12'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][12]==1;
            }
          } else if(b_address[6:0]=='hD) {
            this.b_mask[0][127:14]==114'h0;
            this.b_mask[0][12:0]==13'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][13]==1;
            }
          } else if(b_address[6:0]=='hE) {
            this.b_mask[0][127:15]==113'h0;
            this.b_mask[0][13:0]==14'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][14]==1;
            }
          } else if(b_address[6:0]=='hF) {
            this.b_mask[0][127:16]==112'b0;
            this.b_mask[0][14:0]==15'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15]==1'b1;
            }
          } else if(b_address[6:0]=='h10) {
            this.b_mask[0][127:17]=='h0;
            this.b_mask[0][15:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][16]==1;
            } 
          } else if(b_address[6:0]=='h11) {
            this.b_mask[0][127:18]=='h0;
            this.b_mask[0][16:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][17]==1;
            }
          } else if(b_address[6:0]=='h12) {
            this.b_mask[0][127:19]=='h0;
            this.b_mask[0][17:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][18]==1;
            }
          } else if(b_address[6:0]=='h13) {
            this.b_mask[0][127:20]=='h0;
            this.b_mask[0][18:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19]==1;
            }
          } else if(b_address[6:0]=='h14) {
            this.b_mask[0][127:21]=='h0;
            this.b_mask[0][19:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][20]==1;
            }
          } else if(b_address[6:0]=='h15) {
            this.b_mask[0][127:22]=='h0;
            this.b_mask[0][20:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][21]==1;
            }
          } else if(b_address[6:0]=='h16) {
            this.b_mask[0][127:23]=='h0;
            this.b_mask[0][21:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][22]==1;
            }
          } else if(b_address[6:0]=='h17) {
            this.b_mask[0][127:24]=='h0;
            this.b_mask[0][22:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23]==1;
            }
          } else if(b_address[6:0]=='h18) {
            this.b_mask[0][127:25]=='h0;
            this.b_mask[0][23:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][24]==1;
            }
          } else if(b_address[6:0]=='h19) {
            this.b_mask[0][127:26]=='h0;
            this.b_mask[0][24:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][25]==1;
            }
          } else if(b_address[6:0]=='h1A) {
            this.b_mask[0][127:27]=='h0;
            this.b_mask[0][25:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][26]==1;
            }
          } else if(b_address[6:0]=='h1B) {
            this.b_mask[0][127:28]=='h0;
            this.b_mask[0][26:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27]==1;
            }
          } else if(b_address[6:0]=='h1C) {
            this.b_mask[0][127:29]=='h0;
            this.b_mask[0][27:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][28]==1;
            }
          } else if(b_address[6:0]=='h1D) {
            this.b_mask[0][127:30]=='h0;
            this.b_mask[0][28:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][29]==1;
            }
          } else if(b_address[6:0]=='h1E) {
            this.b_mask[0][127:31]=='h0;
            this.b_mask[0][29:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][30]==1;
            }
          } else if(b_address[6:0]=='h1F) {
            this.b_mask[0][127:32]=='h0;
            this.b_mask[0][30:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31]==1'b1;
            }
          } else if(b_address[6:0]=='h20) {
            this.b_mask[0][127:33]=='h0;
            this.b_mask[0][31:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][32]==1;
            } 
          } else if(b_address[6:0]=='h21) {
            this.b_mask[0][127:34]=='h0;
            this.b_mask[0][32:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][33]==1;
            }
          } else if(b_address[6:0]=='h22) {
            this.b_mask[0][127:35]=='h0;
            this.b_mask[0][33:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][34]==1;
            }
          } else if(b_address[6:0]=='h23) {
            this.b_mask[0][127:36]=='h0;
            this.b_mask[0][34:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][35]==1;
            }
          } else if(b_address[6:0]=='h24) {
            this.b_mask[0][127:37]=='h0;
            this.b_mask[0][35:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][36]==1;
            }
          } else if(b_address[6:0]=='h25) {
            this.b_mask[0][127:38]=='h0;
            this.b_mask[0][36:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][37]==1;
            }
          } else if(b_address[6:0]=='h26) {
            this.b_mask[0][127:39]=='h0;
            this.b_mask[0][37:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][38]==1;
            }
          } else if(b_address[6:0]=='h27) {
            this.b_mask[0][127:40]=='h0;
            this.b_mask[0][38:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][39]==1;
            }
          } else if(b_address[6:0]=='h28) {
            this.b_mask[0][127:41]=='h0;
            this.b_mask[0][39:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][40]==1;
            }
          } else if(b_address[6:0]=='h29) {
            this.b_mask[0][127:42]=='h0;
            this.b_mask[0][40:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][41]==1;
            }
          } else if(b_address[6:0]=='h2A) {
            this.b_mask[0][127:43]=='h0;
            this.b_mask[0][41:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][42]==1;
            }
          } else if(b_address[6:0]=='h2B) {
            this.b_mask[0][127:44]=='h0;
            this.b_mask[0][42:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][43]==1;
            }
          } else if(b_address[6:0]=='h2C) {
            this.b_mask[0][127:45]=='h0;
            this.b_mask[0][43:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][44]==1;
            }
          } else if(b_address[6:0]=='h2D) {
            this.b_mask[0][127:46]=='h0;
            this.b_mask[0][44:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][45]==1;
            }
          } else if(b_address[6:0]=='h2E) {
            this.b_mask[0][127:47]=='h0;
            this.b_mask[0][45:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][46]==1;
            }
          } else if(b_address[6:0]=='h2F) {
            this.b_mask[0][127:48]=='h0;
            this.b_mask[0][46:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47]==1'b1;
            }
          } else if(b_address[6:0]=='h30) {
            this.b_mask[0][127:49]=='h0;
            this.b_mask[0][47:0]==16'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][48]==1;
            } 
          } else if(b_address[6:0]=='h31) {
            this.b_mask[0][127:50]=='h0;
            this.b_mask[0][48:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][49]==1;
            }
          } else if(b_address[6:0]=='h32) {
            this.b_mask[0][127:51]=='h0;
            this.b_mask[0][49:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][50]==1;
            }
          } else if(b_address[6:0]=='h33) {
            this.b_mask[0][127:52]=='h0;
            this.b_mask[0][50:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][51]==1;
            }
          } else if(b_address[6:0]=='h34) {
            this.b_mask[0][127:53]=='h0;
            this.b_mask[0][51:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][52]==1;
            }
          } else if(b_address[6:0]=='h35) {
            this.b_mask[0][127:54]=='h0;
            this.b_mask[0][52:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][53]==1;
            }
          } else if(b_address[6:0]=='h36) {
            this.b_mask[0][127:55]=='h0;
            this.b_mask[0][53:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][54]==1;
            }
          } else if(b_address[6:0]=='h37) {
            this.b_mask[0][127:56]=='h0;
            this.b_mask[0][54:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][55]==1;
            }
          } else if(b_address[6:0]=='h38) {
            this.b_mask[0][127:57]=='h0;
            this.b_mask[0][55:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][56]==1;
            }
          } else if(b_address[6:0]=='h39) {
            this.b_mask[0][127:58]=='h0;
            this.b_mask[0][56:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][57]==1;
            }
          } else if(b_address[6:0]=='h3A) {
            this.b_mask[0][127:59]=='h0;
            this.b_mask[0][57:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][58]==1;
            }
          } else if(b_address[6:0]=='h3B) {
            this.b_mask[0][127:60]=='h0;
            this.b_mask[0][58:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][59]==1;
            }
          } else if(b_address[6:0]=='h3C) {
            this.b_mask[0][127:61]=='h0;
            this.b_mask[0][59:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][60]==1;
            }
          } else if(b_address[6:0]=='h3D) {
            this.b_mask[0][127:62]=='h0;
            this.b_mask[0][60:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][61]==1;
            }
          } else if(b_address[6:0]=='h3E) {
            this.b_mask[0][127:63]=='h0;
            this.b_mask[0][61:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][62]==1;
            }
          } else if(b_address[6:0]=='h3F) {
            this.b_mask[0][127:64]=='h0;
            this.b_mask[0][62:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63]==1'b1;
            }
          } else if(b_address[6:0]=='h40) {
            this.b_mask[0][127:65]==127'h0;
            this.b_mask[0][63:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][64]==1;
            } 
          } else if(b_address[6:0]=='h41) {
            this.b_mask[0][127:66]=='h0;
            this.b_mask[0][64:0]==1'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][65]==1;
            }
          } else if(b_address[6:0]=='h42) {
            this.b_mask[0][127:67]=='h0;
            this.b_mask[0][65:0]==2'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][66]==1;
            }
          } else if(b_address[6:0]=='h43) {
            this.b_mask[0][127:68]=='h0;
            this.b_mask[0][66:0]==3'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][67]==1;
            }
          } else if(b_address[6:0]=='h44) {
            this.b_mask[0][127:69]=='h0;
            this.b_mask[0][67:0]==4'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][68]==1;
            }
          } else if(b_address[6:0]=='h45) {
            this.b_mask[0][127:70]=='h0;
            this.b_mask[0][68:0]==5'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][69]==1;
            }
          } else if(b_address[6:0]=='h46) {
            this.b_mask[0][127:71]=='h0;
            this.b_mask[0][69:0]==6'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][70]==1;
            }
          } else if(b_address[6:0]=='h47) {
            this.b_mask[0][127:72]=='h0;
            this.b_mask[0][70:0]==7'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][71]==1;
            }
          } else if(b_address[6:0]=='h48) {
            this.b_mask[0][127:73]=='h0;
            this.b_mask[0][71:0]==8'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][72]==1;
            }
          } else if(b_address[6:0]=='h49) {
            this.b_mask[0][127:74]=='h0;
            this.b_mask[0][72:0]==9'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][73]==1;
            }
          } else if(b_address[6:0]=='h4A) {
            this.b_mask[0][127:75]=='h0;
            this.b_mask[0][73:0]==10'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][74]==1;
            }
          } else if(b_address[6:0]=='h4B) {
            this.b_mask[0][127:76]=='h0;
            this.b_mask[0][74:0]==11'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][75]==1;
            }
          } else if(b_address[6:0]=='h4C) {
            this.b_mask[0][127:77]=='h0;
            this.b_mask[0][75:0]==12'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][76]==1;
            }
          } else if(b_address[6:0]=='h4D) {
            this.b_mask[0][127:78]=='h0;
            this.b_mask[0][76:0]==13'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][77]==1;
            }
          } else if(b_address[6:0]=='h4E) {
            this.b_mask[0][127:79]=='h0;
            this.b_mask[0][77:0]==14'h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][78]==1;
            }
          } else if(b_address[6:0]=='h4F) {
            this.b_mask[0][127:80]=='b0;
            this.b_mask[0][78:0]==15'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][79]==1'b1;
            }
          } else if(b_address[6:0]=='h50) {
            this.b_mask[0][127:81]=='h0;
            this.b_mask[0][79:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][80]==1;
            } 
          } else if(b_address[6:0]=='h51) {
            this.b_mask[0][127:82]=='h0;
            this.b_mask[0][80:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][81]==1;
            }
          } else if(b_address[6:0]=='h52) {
            this.b_mask[0][127:83]=='h0;
            this.b_mask[0][81:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][82]==1;
            }
          } else if(b_address[6:0]=='h53) {
            this.b_mask[0][127:84]=='h0;
            this.b_mask[0][82:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][83]==1;
            }
          } else if(b_address[6:0]=='h54) {
            this.b_mask[0][127:85]=='h0;
            this.b_mask[0][83:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][84]==1;
            }
          } else if(b_address[6:0]=='h55) {
            this.b_mask[0][127:86]=='h0;
            this.b_mask[0][84:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][85]==1;
            }
          } else if(b_address[6:0]=='h56) {
            this.b_mask[0][127:87]=='h0;
            this.b_mask[0][85:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][86]==1;
            }
          } else if(b_address[6:0]=='h57) {
            this.b_mask[0][127:88]=='h0;
            this.b_mask[0][86:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][87]==1;
            }
          } else if(b_address[6:0]=='h58) {
            this.b_mask[0][127:89]=='h0;
            this.b_mask[0][87:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][88]==1;
            }
          } else if(b_address[6:0]=='h59) {
            this.b_mask[0][127:90]=='h0;
            this.b_mask[0][88:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][89]==1;
            }
          } else if(b_address[6:0]=='h5A) {
            this.b_mask[0][127:91]=='h0;
            this.b_mask[0][89:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][90]==1;
            }
          } else if(b_address[6:0]=='h5B) {
            this.b_mask[0][127:92]=='h0;
            this.b_mask[0][90:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][91]==1;
            }
          } else if(b_address[6:0]=='h5C) {
            this.b_mask[0][127:93]=='h0;
            this.b_mask[0][91:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][92]==1;
            }
          } else if(b_address[6:0]=='h5D) {
            this.b_mask[0][127:94]=='h0;
            this.b_mask[0][92:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][93]==1;
            }
          } else if(b_address[6:0]=='h5E) {
            this.b_mask[0][127:95]=='h0;
            this.b_mask[0][93:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][94]==1;
            }
          } else if(b_address[6:0]=='h5F) {
            this.b_mask[0][127:96]=='h0;
            this.b_mask[0][94:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][95]==1'b1;
            }
          } else if(b_address[6:0]=='h60) {
            this.b_mask[0][127:97]=='h0;
            this.b_mask[0][95:0]==16'b0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][96]==1;
            } 
          } else if(b_address[6:0]=='h61) {
            this.b_mask[0][127:98]=='h0;
            this.b_mask[0][96:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][97]==1;
            }
          } else if(b_address[6:0]=='h62) {
            this.b_mask[0][127:99]=='h0;
            this.b_mask[0][97:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][98]==1;
            }
          } else if(b_address[6:0]=='h63) {
            this.b_mask[0][127:100]=='h0;
            this.b_mask[0][98:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][99]==1;
            }
          } else if(b_address[6:0]=='h64) {
            this.b_mask[0][127:101]=='h0;
            this.b_mask[0][99:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][100]==1;
            }
          } else if(b_address[6:0]=='h65) {
            this.b_mask[0][127:102]=='h0;
            this.b_mask[0][100:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][101]==1;
            }
          } else if(b_address[6:0]=='h66) {
            this.b_mask[0][127:103]=='h0;
            this.b_mask[0][101:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][102]==1;
            }
          } else if(b_address[6:0]=='h67) {
            this.b_mask[0][127:104]=='h0;
            this.b_mask[0][102:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][103]==1;
            }
          } else if(b_address[6:0]=='h68) {
            this.b_mask[0][127:105]=='h0;
            this.b_mask[0][103:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][104]==1;
            }
          } else if(b_address[6:0]=='h69) {
            this.b_mask[0][127:106]=='h0;
            this.b_mask[0][104:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][105]==1;
            }
          } else if(b_address[6:0]=='h6A) {
            this.b_mask[0][127:107]=='h0;
            this.b_mask[0][105:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][106]==1;
            }
          } else if(b_address[6:0]=='h6B) {
            this.b_mask[0][127:108]=='h0;
            this.b_mask[0][106:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][107]==1;
            }
          } else if(b_address[6:0]=='h6C) {
            this.b_mask[0][127:109]=='h0;
            this.b_mask[0][107:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][108]==1;
            }
          } else if(b_address[6:0]=='h6D) {
            this.b_mask[0][127:110]=='h0;
            this.b_mask[0][108:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][109]==1;
            }
          } else if(b_address[6:0]=='h6E) {
            this.b_mask[0][127:111]=='h0;
            this.b_mask[0][109:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][110]==1;
            }
          } else if(b_address[6:0]=='h6F) {
            this.b_mask[0][127:112]=='h0;
            this.b_mask[0][110:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][111]==1'b1;
            }
          } else if(b_address[6:0]=='h70) {
            this.b_mask[0][127:113]=='h0;
            this.b_mask[0][111:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][112]==1;
            } 
          } else if(b_address[6:0]=='h71) {
            this.b_mask[0][127:114]=='h0;
            this.b_mask[0][112:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][113]==1;
            }
          } else if(b_address[6:0]=='h72) {
            this.b_mask[0][127:115]=='h0;
            this.b_mask[0][113:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][114]==1;
            }
          } else if(b_address[6:0]=='h73) {
            this.b_mask[0][127:116]=='h0;
            this.b_mask[0][114:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][115]==1;
            }
          } else if(b_address[6:0]=='h74) {
            this.b_mask[0][127:117]=='h0;
            this.b_mask[0][115:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][116]==1;
            }
          } else if(b_address[6:0]=='h75) {
            this.b_mask[0][127:118]=='h0;
            this.b_mask[0][116:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][117]==1;
            }
          } else if(b_address[6:0]=='h76) {
            this.b_mask[0][127:119]=='h0;
            this.b_mask[0][117:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][118]==1;
            }
          } else if(b_address[6:0]=='h77) {
            this.b_mask[0][127:120]=='h0;
            this.b_mask[0][118:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][119]==1;
            }
          } else if(b_address[6:0]=='h78) {
            this.b_mask[0][127:121]=='h0;
            this.b_mask[0][119:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][120]==1;
            }
          } else if(b_address[6:0]=='h79) {
            this.b_mask[0][127:122]=='h0;
            this.b_mask[0][120:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][121]==1;
            }
          } else if(b_address[6:0]=='h7A) {
            this.b_mask[0][127:123]=='h0;
            this.b_mask[0][121:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][122]==1;
            }
          } else if(b_address[6:0]=='h7B) {
            this.b_mask[0][127:124]=='h0;
            this.b_mask[0][122:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][123]==1;
            }
          } else if(b_address[6:0]=='h7C) {
            this.b_mask[0][127:125]=='h0;
            this.b_mask[0][123:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][124]==1;
            }
          } else if(b_address[6:0]=='h7D) {
            this.b_mask[0][127:126]=='h0;
            this.b_mask[0][124:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][125]==1;
            }
          } else if(b_address[6:0]=='h7E) {
            this.b_mask[0][127]=='h0;
            this.b_mask[0][125:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][126]==1;
            }
          } else if(b_address[6:0]=='h7F) {
            this.b_mask[0][126:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][127]==1'b1;
            }
          }
        } else if(b_size[3:0]==4'h1) {
          if(b_address[6:0]=='h0){
            this.b_mask[0][127:2]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][1:0]==2'b11;
            }
          } else if(b_address[6:0]=='h2) {
            this.b_mask[0][127:4]==0;
            this.b_mask[0][1:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:2]==2'b11;
            }
          } else if(b_address[6:0]=='h4) {
            this.b_mask[0][127:6]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][5:4]==2'b11;
            }
          } else if(b_address[6:0]=='h6) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][5:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:6]==2'b11;
            }
          } else if(b_address[6:0]=='h8) {
            this.b_mask[0][127:10]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][9:8]==2'b11;
            }
          } else if(b_address[6:0]=='hA) {
            this.b_mask[0][127:12]==0;
            this.b_mask[0][9:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11:10]==2'b11;
            }
          } else if(b_address[6:0]=='hC) {
            this.b_mask[0][127:14]==0;
            this.b_mask[0][11:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][13:12]==2'b11;
            }
          } else if(b_address[6:0]=='hE) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][13:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:14]==2'b11;
            }
          } else if(b_address[6:0]=='h10){
            this.b_mask[0][127:18]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][17:16]==2'b11;
            }
          } else if(b_address[6:0]=='h12) {
            this.b_mask[0][127:20]==0;
            this.b_mask[0][17:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19:18]==2'b11;
            }
          } else if(b_address[6:0]=='h14) {
            this.b_mask[0][127:22]==0;
            this.b_mask[0][19:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][21:20]==2'b11;
            }
          } else if(b_address[6:0]=='h16) {
            this.b_mask[0][127:24]==0;
            this.b_mask[0][21:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:22]==2'b11;
            }
          } else if(b_address[6:0]=='h18) {
            this.b_mask[0][127:26]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][25:24]==2'b11;
            }
          } else if(b_address[6:0]=='h1A) {
            this.b_mask[0][127:28]==0;
            this.b_mask[0][25:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27:26]==2'b11;
            }
          } else if(b_address[6:0]=='h1C) {
            this.b_mask[0][127:30]==0;
            this.b_mask[0][27:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][29:28]==2'b11;
            }
          } else if(b_address[6:0]=='h1E) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][29:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:30]==2'b11;
            }
          } else if(b_address[6:0]=='h20){
            this.b_mask[0][127:34]==0;
            this.b_mask[0][31:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][33:32]==2'b11;
            }
          } else if(b_address[6:0]=='h22) {
            this.b_mask[0][127:36]==0;
            this.b_mask[0][33:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][35:34]==2'b11;
            }
          } else if(b_address[6:0]=='h24) {
            this.b_mask[0][127:38]==0;
            this.b_mask[0][35:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][37:36]==2'b11;
            }
          } else if(b_address[6:0]=='h26) {
            this.b_mask[0][127:40]==0;
            this.b_mask[0][37:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][39:38]==2'b11;
            }
          } else if(b_address[6:0]=='h28) {
            this.b_mask[0][127:42]==0;
            this.b_mask[0][39:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][41:40]==2'b11;
            }
          } else if(b_address[6:0]=='h2A) {
            this.b_mask[0][127:44]==0;
            this.b_mask[0][41:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][43:42]==2'b11;
            }
          } else if(b_address[6:0]=='h2C) {
            this.b_mask[0][127:46]==0;
            this.b_mask[0][43:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][45:44]==2'b11;
            }
          } else if(b_address[6:0]=='h2E) {
            this.b_mask[0][127:48]==0;
            this.b_mask[0][45:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47:46]==2'b11;
            }
          } else if(b_address[6:0]=='h30){
            this.b_mask[0][127:50]==0;
            this.b_mask[0][47:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][49:48]==2'b11;
            }
          } else if(b_address[6:0]=='h32) {
            this.b_mask[0][127:52]==0;
            this.b_mask[0][49:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][51:50]==2'b11;
            }
          } else if(b_address[6:0]=='h34) {
            this.b_mask[0][127:54]==0;
            this.b_mask[0][51:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][53:52]==2'b11;
            }
          } else if(b_address[6:0]=='h36) {
            this.b_mask[0][127:56]==0;
            this.b_mask[0][53:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][55:54]==2'b11;
            }
          } else if(b_address[6:0]=='h38) {
            this.b_mask[0][127:58]==0;
            this.b_mask[0][55:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][57:56]==2'b11;
            }
          } else if(b_address[6:0]=='h3A) {
            this.b_mask[0][127:60]==0;
            this.b_mask[0][57:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][59:58]==2'b11;
            }
          } else if(b_address[6:0]=='h3C) {
            this.b_mask[0][127:62]==0;
            this.b_mask[0][59:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][61:60]==2'b11;
            }
          } else if(b_address[6:0]=='h3E) {
            this.b_mask[0][127:64]==0;
            this.b_mask[0][61:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:62]==2'b11;
            }
          } else if(b_address[6:0]=='h40){
            this.b_mask[0][127:66]==0;
            this.b_mask[0][63:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][65:64]==2'b11;
            }
          } else if(b_address[6:0]=='h42) {
            this.b_mask[0][127:68]==0;
            this.b_mask[0][65:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][67:66]==2'b11;
            }
          } else if(b_address[6:0]=='h44) {
            this.b_mask[0][127:70]==0;
            this.b_mask[0][67:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][69:68]==2'b11;
            }
          } else if(b_address[6:0]=='h46) {
            this.b_mask[0][127:72]==0;
            this.b_mask[0][69:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][71:70]==2'b11;
            }
          } else if(b_address[6:0]=='h48) {
            this.b_mask[0][127:74]==0;
            this.b_mask[0][71:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][73:72]==2'b11;
            }
          } else if(b_address[6:0]=='h4A) {
            this.b_mask[0][127:76]==0;
            this.b_mask[0][73:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][75:74]==2'b11;
            }
          } else if(b_address[6:0]=='h4C) {
            this.b_mask[0][127:78]==0;
            this.b_mask[0][75:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][77:76]==2'b11;
            }
          } else if(b_address[6:0]=='h4E) {
            this.b_mask[0][127:80]==0;
            this.b_mask[0][77:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][79:78]==2'b11;
            }
          } else if(b_address[6:0]=='h50){
            this.b_mask[0][127:82]==0;
            this.b_mask[0][79:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][81:80]==2'b11;
            }
          } else if(b_address[6:0]=='h52) {
            this.b_mask[0][127:84]==0;
            this.b_mask[0][81:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][83:82]==2'b11;
            }
          } else if(b_address[6:0]=='h54) {
            this.b_mask[0][127:86]==0;
            this.b_mask[0][83:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][85:84]==2'b11;
            }
          } else if(b_address[6:0]=='h56) {
            this.b_mask[0][127:88]==0;
            this.b_mask[0][85:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][87:86]==2'b11;
            }
          } else if(b_address[6:0]=='h58) {
            this.b_mask[0][127:90]==0;
            this.b_mask[0][87:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][89:88]==2'b11;
            }
          } else if(b_address[6:0]=='h5A) {
            this.b_mask[0][127:92]==0;
            this.b_mask[0][89:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][91:90]==2'b11;
            }
          } else if(b_address[6:0]=='h5C) {
            this.b_mask[0][127:94]==0;
            this.b_mask[0][91:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][93:92]==2'b11;
            }
          } else if(b_address[6:0]=='h5E) {
            this.b_mask[0][127:96]==0;
            this.b_mask[0][93:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][95:94]==2'b11;
            }
          } else if(b_address[6:0]=='h60){
            this.b_mask[0][127:98]==0;
            this.b_mask[0][95:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][97:96]==2'b11;
            }
          } else if(b_address[6:0]=='h62) {
            this.b_mask[0][127:100]==0;
            this.b_mask[0][97:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][99:98]==2'b11;
            }
          } else if(b_address[6:0]=='h64) {
            this.b_mask[0][127:102]==0;
            this.b_mask[0][99:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][101:100]==2'b11;
            }
          } else if(b_address[6:0]=='h66) {
            this.b_mask[0][127:104]==0;
            this.b_mask[0][101:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][103:102]==2'b11;
            }
          } else if(b_address[6:0]=='h68) {
            this.b_mask[0][127:106]==0;
            this.b_mask[0][103:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][105:104]==2'b11;
            }
          } else if(b_address[6:0]=='h6A) {
            this.b_mask[0][127:108]==0;
            this.b_mask[0][105:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][107:106]==2'b11;
            }
          } else if(b_address[6:0]=='h6C) {
            this.b_mask[0][127:110]==0;
            this.b_mask[0][107:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][109:108]==2'b11;
            }
          } else if(b_address[6:0]=='h6E) {
            this.b_mask[0][127:112]==0;
            this.b_mask[0][109:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][111:110]==2'b11;
            }
          } else if(b_address[6:0]=='h70){
            this.b_mask[0][127:114]==0;
            this.b_mask[0][111:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][113:112]==2'b11;
            }
          } else if(b_address[6:0]=='h72) {
            this.b_mask[0][127:116]==0;
            this.b_mask[0][113:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][115:114]==2'b11;
            }
          } else if(b_address[6:0]=='h74) {
            this.b_mask[0][127:118]==0;
            this.b_mask[0][115:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][117:116]==2'b11;
            }
          } else if(b_address[6:0]=='h76) {
            this.b_mask[0][127:120]==0;
            this.b_mask[0][117:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][119:118]==2'b11;
            }
          } else if(b_address[6:0]=='h78) {
            this.b_mask[0][127:122]==0;
            this.b_mask[0][119:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][121:120]==2'b11;
            }
          } else if(b_address[6:0]=='h7A) {
            this.b_mask[0][127:124]==0;
            this.b_mask[0][121:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][123:122]==2'b11;
            }
          } else if(b_address[6:0]=='h7C) {
            this.b_mask[0][127:126]==0;
            this.b_mask[0][123:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][125:124]==2'b11;
            }
          } else if(b_address[6:0]=='h7E) {
            this.b_mask[0][125:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][127:126]==2'b11;
            }
          }
        } else if(b_size[3:0]==4'h2) {
          if(b_address[6:0]=='h0){
            this.b_mask[0][127:4]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][3:0]==4'b1111;
            }
          } else if(b_address[6:0]=='h4) {
            this.b_mask[0][127:8]==0;
            this.b_mask[0][3:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:4]==4'b1111;
            }
          } else if(b_address[6:0]=='h8) {
            this.b_mask[0][127:12]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][11:8]==4'b1111;
            }
          } else if(b_address[6:0]=='hC) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][11:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:12]==4'b1111;
            }
          } else if(b_address[6:0]=='h10){
            this.b_mask[0][127:20]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][19:16]==4'b1111;
            }
          } else if(b_address[6:0]=='h14) {
            this.b_mask[0][127:24]==0;
            this.b_mask[0][19:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:20]==4'b1111;
            }
          } else if(b_address[6:0]=='h18) {
            this.b_mask[0][127:28]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][27:24]==4'b1111;
            }
          } else if(b_address[6:0]=='h1C) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][27:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:28]==4'b1111;
            }
          } else if(b_address[6:0]=='h20){
            this.b_mask[0][127:36]==0;
            this.b_mask[0][31:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][35:32]==4'b1111;
            }
          } else if(b_address[6:0]=='h24) {
            this.b_mask[0][127:40]==0;
            this.b_mask[0][35:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][39:36]==4'b1111;
            }
          } else if(b_address[6:0]=='h28) {
            this.b_mask[0][127:44]==0;
            this.b_mask[0][39:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][43:40]==4'b1111;
            }
          } else if(b_address[6:0]=='h2C) {
            this.b_mask[0][127:48]==0;
            this.b_mask[0][43:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47:44]==4'b1111;
            }
          } else if(b_address[6:0]=='h30){
            this.b_mask[0][127:52]==0;
            this.b_mask[0][47:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][51:48]==4'b1111;
            }
          } else if(b_address[6:0]=='h34) {
            this.b_mask[0][127:56]==0;
            this.b_mask[0][51:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][55:52]==4'b1111;
            }
          } else if(b_address[6:0]=='h38) {
            this.b_mask[0][127:60]==0;
            this.b_mask[0][55:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][59:56]==4'b1111;
            }
          } else if(b_address[6:0]=='h3C) {
            this.b_mask[0][127:64]==0;
            this.b_mask[0][59:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:60]==4'b1111;
            }
          } else if(b_address[6:0]=='h40){
            this.b_mask[0][127:68]==0;
            this.b_mask[0][63:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][67:64]==4'b1111;
            }
          } else if(b_address[6:0]=='h44) {
            this.b_mask[0][127:72]==0;
            this.b_mask[0][67:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][71:68]==4'b1111;
            }
          } else if(b_address[6:0]=='h48) {
            this.b_mask[0][127:76]==0;
            this.b_mask[0][71:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][75:72]==4'b1111;
            }
          } else if(b_address[6:0]=='h4C) {
            this.b_mask[0][127:80]==0;
            this.b_mask[0][75:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][79:76]==4'b1111;
            }
          } else if(b_address[6:0]=='h50){
            this.b_mask[0][127:84]==0;
            this.b_mask[0][79:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][83:80]==4'b1111;
            }
          } else if(b_address[6:0]=='h54) {
            this.b_mask[0][127:88]==0;
            this.b_mask[0][83:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][87:84]==4'b1111;
            }
          } else if(b_address[6:0]=='h58) {
            this.b_mask[0][127:92]==0;
            this.b_mask[0][87:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][91:88]==4'b1111;
            }
          } else if(b_address[6:0]=='h5C) {
            this.b_mask[0][127:96]==0;
            this.b_mask[0][91:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][95:92]==4'b1111;
            }
          } else if(b_address[6:0]=='h60){
            this.b_mask[0][127:100]==0;
            this.b_mask[0][95:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][99:96]==4'b1111;
            }
          } else if(b_address[6:0]=='h64) {
            this.b_mask[0][127:104]==0;
            this.b_mask[0][99:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][103:100]==4'b1111;
            }
          } else if(b_address[6:0]=='h68) {
            this.b_mask[0][127:108]==0;
            this.b_mask[0][103:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][107:104]==4'b1111;
            }
          } else if(b_address[6:0]=='h6C) {
            this.b_mask[0][127:112]==0;
            this.b_mask[0][107:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][111:108]==4'b1111;
            }
          } else if(b_address[6:0]=='h70){
            this.b_mask[0][127:116]==0;
            this.b_mask[0][111:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][115:112]==4'b1111;
            }
          } else if(b_address[6:0]=='h74) {
            this.b_mask[0][127:120]==0;
            this.b_mask[0][115:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][119:116]==4'b1111;
            }
          } else if(b_address[6:0]=='h78) {
            this.b_mask[0][127:124]==0;
            this.b_mask[0][119:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][123:120]==4'b1111;
            }
          } else if(b_address[6:0]=='h7C) {
            this.b_mask[0][123:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][127:124]==4'b1111;
            }
          }
        } else if(b_size[3:0]==4'h3) {
          if(b_address[6:0]=='h0){
            this.b_mask[0][127:8]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][7:0]==8'hFF;
            }
          } else if(b_address[6:0]=='h8) {
            this.b_mask[0][127:16]==0;
            this.b_mask[0][7:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:8]==8'hFF;
            }
          } if(b_address[6:0]=='h10){
            this.b_mask[0][127:24]==0;
            this.b_mask[0][15:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][23:16]==8'hFF;
            }
          } else if(b_address[6:0]=='h18) {
            this.b_mask[0][127:32]==0;
            this.b_mask[0][23:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:24]==8'hFF;
            }
          } else if(b_address[6:0]=='h20){
            this.b_mask[0][127:40]==0;
            this.b_mask[0][31:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][39:32]==8'hFF;
            }
          } else if(b_address[6:0]=='h28) {
            this.b_mask[0][127:48]==0;
            this.b_mask[0][39:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47:40]==8'hFF;
            }
          } else if(b_address[6:0]=='h30){
            this.b_mask[0][127:56]==0;
            this.b_mask[0][47:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][55:48]==8'hFF;
            }
          } else if(b_address[6:0]=='h38) {
            this.b_mask[0][127:64]==0;
            this.b_mask[0][55:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:56]==8'hFF;
            }
          } else if(b_address[6:0]=='h40){
            this.b_mask[0][127:72]==0;
            this.b_mask[0][63:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][71:64]==8'hFF;
            }
          } else if(b_address[6:0]=='h48) {
            this.b_mask[0][127:80]==0;
            this.b_mask[0][71:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][79:72]==8'hFF;
            }
          } else if(b_address[6:0]=='h50){
            this.b_mask[0][127:88]==0;
            this.b_mask[0][79:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][87:80]==8'hFF;
            }
          } else if(b_address[6:0]=='h58) {
            this.b_mask[0][127:96]==0;
            this.b_mask[0][87:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][95:88]==8'hFF;
            }
          } else if(b_address[6:0]=='h60){
            this.b_mask[0][127:104]==0;
            this.b_mask[0][95:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][103:96]==8'hFF;
            }
          } else if(b_address[6:0]=='h68) {
            this.b_mask[0][127:112]==0;
            this.b_mask[0][103:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][111:104]==8'hFF;
            }
          } else if(b_address[6:0]=='h70){
            this.b_mask[0][127:120]==0;
            this.b_mask[0][111:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][119:112]==8'hFF;
            }
          } else if(b_address[6:0]=='h78) {
            this.b_mask[0][119:0]==0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][127:120]==8'hFF;
            }
          }
        } else if(b_size[3:0]=='h4) {
          if(b_address[6:0]=='h0) {
            this.b_mask[0][127:16]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][15:0]==16'hFFFF;
            }
          } else if(b_address[6:0]=='h10) {
            this.b_mask[0][127:32]=='h0;
            this.b_mask[0][15:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:16]==16'hFFFF;
            }
          } else if(b_address[6:0]=='h20) {
            this.b_mask[0][127:48]=='h0;
            this.b_mask[0][31:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][47:32]==16'hFFFF;
            }
          } else if(b_address[6:0]=='h30) {
            this.b_mask[0][127:64]=='h0;
            this.b_mask[0][47:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:48]==16'hFFFF;
            }
          } else if(b_address[6:0]=='h40) {
            this.b_mask[0][127:80]=='h0;
            this.b_mask[0][63:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][79:64]==16'hFFFF;
            }
          } else if(b_address[6:0]=='h50) {
            this.b_mask[0][127:96]=='h0;
            this.b_mask[0][79:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][95:80]==16'hFFFF;
            }
          } else if(b_address[6:0]=='h60) {
            this.b_mask[0][127:112]=='h0;
            this.b_mask[0][95:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][111:96]==16'hFFFF;
            }
          } else if(b_address[6:0]=='h70) {
            this.b_mask[0][111:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][127:112]==16'hFFFF;
            }
          }
        } else if(b_size[3:0]=='h5) {
          if(b_address[6:0]=='h0) {
            this.b_mask[0][127:32]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][31:0]==32'hFFFFFFFF;
            }
          } else if(b_address[6:0]=='h20) {
            this.b_mask[0][127:64]=='h0;
            this.b_mask[0][31:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:32]==32'hFFFFFFFF;
            }
          } else if(b_address[6:0]=='h40) {
            this.b_mask[0][127:96]=='h0;
            this.b_mask[0][63:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][95:64]==32'hFFFFFFFF;
            }
          } else if(b_address[6:0]=='h60) {
            this.b_mask[0][95:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][127:96]==32'hFFFFFFFF;
            }
          }
        } else if(b_size[3:0]=='h6) {
          if(b_address[6:0]=='h0) {
            this.b_mask[0][127:64]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][63:0]==64'hFFFFFFFFFFFFFFFF;
            }
          } else if(b_address[6:0]=='h40) {
            this.b_mask[0][63:0]=='h0;
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][127:64]==64'hFFFFFFFFFFFFFFFF;
            }
          }
        } else if(b_size[3:0]=='h7) {
          if(b_address[6:0]=='h0) {
            if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
              this.b_mask[0][127:0]==128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            }
          } 
        }
      } else if (b_size>7) {
        foreach(b_mask[i]) {
          if(ch_b_msg_type != CH_B_PUT_PARTIAL_DATA ) {
            this.b_mask[i][127:0]==128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
          }
        }
      }
    }
  }

  /**Constraint to solve ch_b_msg_type before b_size. **/
  constraint solve_valid_ch_b_msg_type_before_b_size {solve ch_b_msg_type before b_size;}

  /**Constraint to solve ch_b_msg_type before b_param. **/
  constraint solve_valid_ch_b_msg_type_before_b_param {solve ch_b_msg_type before b_param;}

  /**Constraint to solve ch_b_msg_type before b_mask. **/
  constraint solve_valid_ch_b_msg_type_before_b_mask {solve ch_b_msg_type before b_mask;}

  /**Constraint to solve b_size before b_address. **/
  constraint solve_b_size_before_aligned_address {solve b_size before  b_address ;}

  /**Constraint to solve b_size before b_mask. **/
  constraint solve_b_size_before_b_mask {solve b_size before b_mask ;}

  /**Constraint to solve b_address before b_mask. **/
  constraint solve_b_address_before_b_mask {solve b_address before  b_mask ;}

  /**Constraint to solve b_mask before b_corrupt. **/
  constraint solve_b_mask_before_b_corrupt {solve b_mask before  b_corrupt ;}

// delay related constraints

  /**
   * Valid constraint to create array b_vld_2_b_vld_assert_delay of size 
   * as large as number of beats to be transferred in a Tilelink transaction by Tilelink Slave components.
   */
//  constraint delay_b_len {
//    if(2**b_size <= cfg.data_width/8  || this.ch_b_msg_type == CH_B_PROBE_BLOCK || this.ch_b_msg_type == CH_B_PROBE_PERM || this.ch_b_msg_type == CH_B_GET || this.ch_b_msg_type == CH_B_INTENT) {
//      b_vld_2_b_vld_assert_delay.size() == 1; 
//    } else if(2**b_size > cfg.data_width/8) {
//      b_vld_2_b_vld_assert_delay.size() dist {((2**b_size)/(cfg.data_width/8)) := 10000, [0:1024] := 1 }; 
//    }
//  }
  constraint delay_b_len { soft b_vld_2_b_vld_assert_delay.size() == 0;  }
  
  /**
   * Valid constraint to create array d_vld_2_d_vld_assert_delay of size 
   * as large as number of beats to be transferred in a Tilelink transaction by Tilelink Master components.
   */
//  constraint delay_d_len {
//    if(2**d_size <= cfg.data_width/8  || this.ch_d_msg_type == CH_D_ACCESS_ACK || this.ch_d_msg_type == CH_D_RELEASE_ACK || this.ch_d_msg_type == CH_D_GRANT || this.ch_d_msg_type == CH_D_HINT_ACK) {
//      d_vld_2_d_vld_assert_delay.size() == 1; 
//    } else if(2**d_size > cfg.data_width/8) {
//      //d_vld_2_d_vld_assert_delay.size() dist{ 1 := 10000,((2**d_size)/(cfg.data_width/8)) := 10, [2:1024] := 1 };
//      d_vld_2_d_vld_assert_delay.size() dist{ 1 := 100000,0:= 10, [2:1024] := 1 };
//    }
//  }
  constraint delay_d_len { soft d_vld_2_d_vld_assert_delay.size() == 0;  }

  /**
   * Constraint to drive d_denied=0 when drive_chnl_b is high.
   */
  constraint d_denied_control { if (drive_chnl_B)  d_denied == 0; }

//  constraint delay_vals {
//    foreach(b_vld_2_b_vld_assert_delay[i])
//      b_vld_2_b_vld_assert_delay[i] dist {0 :=1000, [1:2] := 80, [3:16] := 20, [17:32]:=1}; 
//    foreach(d_vld_2_d_vld_assert_delay[i])
//      d_vld_2_d_vld_assert_delay[i] dist {0 :=1000, [1:2] := 80, [3:16] := 20, [17:32]:=1}; 
//    a_vld_a_rdy_assert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    a_rdy_deassert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    a_rdy_2_a_rdy_assert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    a_vld_d_vld_cross_channel_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    e_rdy_2_e_rdy_assert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    e_vld_e_rdy_assert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    e_rdy_deassert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    c_rdy_2_c_rdy_assert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    c_vld_c_rdy_assert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//    c_rdy_deassert_delay dist {0 :=1000, [1:10] := 80, [11:32]:=20};
//  }

  constraint delay_vals {
    foreach(b_vld_2_b_vld_assert_delay[i])
      soft b_vld_2_b_vld_assert_delay[i] == 0 ; 
    foreach(d_vld_2_d_vld_assert_delay[i])
      soft d_vld_2_d_vld_assert_delay[i] == 0 ; 
    soft a_vld_a_rdy_assert_delay ==0;
    soft a_rdy_deassert_delay ==0 ;
    soft a_rdy_2_a_rdy_assert_delay == 0 ;
    soft a_vld_d_vld_cross_channel_delay == 0 ;
    soft e_rdy_2_e_rdy_assert_delay == 0 ;
    soft e_vld_e_rdy_assert_delay ==0;
    soft e_rdy_deassert_delay ==0 ;
    soft c_rdy_2_c_rdy_assert_delay ==0;
    soft c_vld_c_rdy_assert_delay ==0 ;
    soft c_rdy_deassert_delay ==0 ;
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
  `svt_vmm_data_new(svt_tilelink_slave_transaction)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new Tilelink Transaction instance, passing the appropriate 
   * argument values to the parent class.
   *
   * @param log VMM log instance used for reporting.
   */
  extern function new(vmm_log log = null);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new Tilelink Transaction instance, passing the appropriate
   * argument values to the parent class.
   *
   * @param name Instance name of the Tilelink Transaction.
   */
  extern function new(string name = "svt_tilelink_slave_transaction");
`endif

  //----------------------------------------------------------------------------
  //   SVT shorthand macros 
  //----------------------------------------------------------------------------

  `svt_data_member_begin(svt_tilelink_slave_transaction)
    `svt_field_int(drive_chnl_B, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_object(cfg, `SVT_ALL_ON|`SVT_NOPACK|`SVT_NOCOMPARE|`SVT_REFERENCE, `SVT_HOW_REF)
    `svt_field_enum(tl_slave_ch_b_msg_type_enum, ch_b_msg_type, `SVT_ALL_ON)
    `svt_field_enum(tl_slave_ch_d_msg_type_enum, ch_d_msg_type, `SVT_ALL_ON)
    `svt_field_object(exception_list, `SVT_ALL_ON|`SVT_NOPACK|`SVT_DEEP, `SVT_HOW_DEEP)
    `svt_field_int(b_size, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_int(b_source, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(b_address, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_array_int(b_mask, `SVT_ALL_ON|`SVT_BIN|`SVT_NOCOMPARE)
    `svt_field_int(b_param, `SVT_ALL_ON|`SVT_BIN)
    //`svt_field_array_int(b_data, `SVT_ALL_ON|`SVT_BIN|`SVT_NOCOMPARE)
    `svt_field_array_int(b_corrupt, `SVT_ALL_ON|`SVT_BIN|`SVT_NOCOMPARE)
    `svt_field_int(d_size, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_int(d_source, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(d_sink, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(d_denied, `SVT_ALL_ON|`SVT_BIN)
    //`svt_field_array_int(d_data, `SVT_ALL_ON|`SVT_HEX|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_corrupt, `SVT_ALL_ON|`SVT_BIN|`SVT_NOCOMPARE)
    `svt_field_int(a_vld_a_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(d_param, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(a_rdy_deassert_delay, `SVT_ALL_ON|`SVT_DEC)
    //`svt_field_array_int(b_vld_2_b_vld_assert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_vld_2_d_vld_assert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOCOMPARE)
    //`svt_field_array_int(d_vld_deassert_delay, `SVT_ALL_ON|`SVT_DEC|`SVT_NOCOMPARE)
    `svt_field_int(a_rdy_2_a_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(a_vld_d_vld_cross_channel_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(c_rdy_2_c_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(c_vld_c_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(c_rdy_deassert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(e_rdy_2_e_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(e_vld_e_rdy_assert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_int(e_rdy_deassert_delay, `SVT_ALL_ON|`SVT_DEC)
    `svt_field_object(status, `SVT_ALL_ON|`SVT_NOPACK|`SVT_DEEP|`SVT_NOCOPY, `SVT_HOW_DEEP)
    `svt_field_enum(tl_slave_ch_a_msg_type_enum, ch_a_msg_type, `SVT_ALL_ON)
    `svt_field_enum(tl_slave_ch_c_msg_type_enum, ch_c_msg_type, `SVT_ALL_ON)
    `svt_field_enum(tl_slave_ch_e_msg_type_enum, ch_e_msg_type, `SVT_ALL_ON)
    `svt_field_int(a_size, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_int(c_size, `SVT_ALL_ON|`SVT_HEX)
    `svt_field_int(a_source, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(a_param, `SVT_ALL_ON|`SVT_BIN)
    `svt_field_int(a_address, `SVT_ALL_ON|`SVT_BIN)
    //`svt_field_array_int(a_mask, `SVT_ALL_ON|`SVT_HEX|`SVT_NOCOMPARE)
    `svt_field_array_int(a_data, `SVT_ALL_ON|`SVT_HEX|`SVT_NOCOMPARE)
    `svt_field_array_int(c_data, `SVT_ALL_ON|`SVT_HEX|`SVT_NOCOMPARE)
   //`svt_field_array_int(a_corrupt, `SVT_ALL_ON|`SVT_HEX|`SVT_NOCOMPARE)
  `svt_data_member_end(svt_tilelink_slave_transaction)

  //----------------------------------------------------------------------------
  /**
   * Performs setup actions required before randomization of the class.
   */
  extern function void pre_randomize();

  //----------------------------------------------------------------------------
  /**
   * Method to turn reasonable constraints on/off as a block.
   *
   * @param on_off Indicates whether constraint_mode for reasonable constraints
   * should be enabled (1) or disabled (0).
   */
  extern virtual function int reasonable_constraint_mode(bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Returns the name of this class, or a class derived from this class.
   */
  extern virtual function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Allocates a new object of type svt_tilelink_slave_transaction.
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

  //----------------------------------------------------------------------------
  /**
   * Does a basic validation of this Tilelink Transaction object.
   *
   * @param silent bit indicating whether failures should result in warning messages.
   * @param kind This int indicates the type of is_avalid check to attempt. 
   */ 
  extern virtual function bit do_is_valid(bit silent = 1, int kind = RELEVANT);

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation.
   *
   * @param kind This int indicates the type of byte_size being requested. Only supported
   * kind value is svt_data::COMPLETE, which results in a size calculation based on the
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
   * kind value is svt_data::COMPLETE, which results in all of the
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
   * kind value is svt_data::COMPLETE, which results in all of the
   * non-static fields being unpacked and the return of an integer indicating the number of
   * unpacked bytes. All other kind values result in no change to the exception contents,
   * and a return value of 0.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);

`else
  // ----------------------------------------------------------------------------
  /**
   * Packs object into the bytes buffer, based on the `SVT_XVM(packer) class policy.
   *
   * @param packer `SVT_XVM(packer)
   */ 
  extern virtual function void do_pack (`SVT_XVM(packer) packer);

  // ----------------------------------------------------------------------------
  /**
   * Unpacks object into the bytes buffer, based on the `SVT_XVM(packer) class policy.
   *
   * @param packer `SVT_XVM(packer)
   */ 
  extern virtual function void do_unpack (`SVT_XVM(packer) packer);

`endif

  //----------------------------------------------------------------------------
  /**
   * Returns a string (with no line feeds) that reports the essential contents
   * of the Tilelink Transaction generally necessary to uniquely identify that Tilelink Transaction.
   *
   * @param prefix (Optional: default = "") The string given in this argument
   * becomes the first item listed in the value returned. It is intended to be
   * used to identify the component (or other source) that requested this string.
   * This argument should be limited to 32 characters or less (to accommodate the
   * fixed column widths in the returned string). If more than 32 characters are
   * supplied, only the first 32 characters are used.
   * @param hdr_only (Optional: default = 0) If this argument is supplied, and
   * is '1', the function returns a 3-line table header string, which indicates
   * which Tilelink Transaction data appears in the subsequent columns. If this argument is
   * '1', the <b>prefix</b> argument becomes the column label for the first header
   * column (still subject to the 32 character limit).
   */
  extern virtual function string psdisplay_short(string prefix = "", bit hdr_only = 0);

  //----------------------------------------------------------------------------
  /**
   * Returns a concise string (32 characters or less) that gives a concise
   * description of the data Tilelink Transaction. Can be used to represent the currently
   * processed data Tilelink Transaction via a signal.
   */
  extern virtual function string psdisplay_concise();

  //----------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command
   * code to retrieve the value of a single named property of a data class derived from this
   * class. If the <b>prop_name</b> argument does not match a property of the class, or if the
   * <b>array_ix</b> argument is not zero and does not point to a valid array element,
   * this function returns '0'. Otherwise it returns '1', with the value of the <b>prop_val</b>
   * argument assigned to the value of the specified property. However, If the property is a
   * sub-object, a reference to it is assigned to the <b>data_obj</b> (ref) argument.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * @param prop_val A <i>ref</i> argument used to return the current value of the property,
   * expressed as a 1024 bit quantity. When returning a string value each character
   * requires 8 bits so returned strings must be 128 characters or less.
   * @param array_ix If the property is an array, this argument specifies the index being
   * accessed. If the property is not an array, it should be set to 0.
   * @param data_obj If the property is not a sub-object, this argument is assigned to
   * <i>null</i>. If the property is a sub-object, a reference to it is assigned to
   * this (ref) argument. In that case, the <b>prop_val</b> argument is meaningless.
   * The component will then store the data object reference in its temporary data object array,
   * and return a handle to its location as the <b>prop_val</b> argument of the <b>get_data_prop</b>
   * task of the component. The command testbench code must then use <i>that</i>
   * handle to access the properties of the sub-object.
   * @return A single bit representing whether or not a valid property was retrieved.
   */
  extern virtual function bit get_prop_val(string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);

  //----------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow
   * command code to set the value of a single named property of a data class derived from
   * this class. This method cannot be used to set the value of a sub-object, since sub-object
   * construction is taken care of automatically by the command interface. If the <b>prop_name</b>
   * argument does not match a property of the class, or it matches a sub-object of the class,
   * or if the <b>array_ix</b> argument is not zero and does not point to a valid array element,
   * this function returns '0'. Otherwise it returns '1'.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * @param prop_val The value to assign to the property, expressed as a 1024 bit quantity.
   * When assigning a string value each character requires 8 bits so assigned strings must
   * be 128 characters or less.
   * @param array_ix If the property is an array, this argument specifies the index being
   * accessed. If the property is not an array, it should be set to 0.
   * @return A single bit representing whether or not a valid property was set.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);
 
  //----------------------------------------------------------------------------
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

  //----------------------------------------------------------------------------
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

  //----------------------------------------------------------------------------
  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the primitive data fields in the object. The svt_pattern_data::name
   * is set to the corresponding field name, the svt_pattern_data::value is set
   * to 0.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern do_allocate_pattern();

  /**
   * This method returns PA object which contains the PA header information for XML or FSDB.
   *
   * @param uid Optional string indicating the unique identification value for object. If not 
   * provided uses the 'get_uid()' method  to retrieve the value. 
   * @param typ Optional string indicating the 'type' of the object. If not provided
   * uses the type name for the class.
   * @param parent_uid Optional string indicating the UID of the object's parent. If not provided
   * the method assumes there is no parent.
   * @param channel Optional string indicating an object channel. If not provided
   * the method assumes there is no channel.
   *
   * @return The requested object block description.
   */
    extern virtual function svt_pa_object_data get_pa_obj_data(string uid="", string typ="", string parent_uid="", string channel="");

   //----------------------------------------------------------------------------
   /**
    * Displays the meta information to a string. Each line of the generated output
    * is preceded by <i>prefix</i>.  Extends class flexibility in choosing what
    * meta information should be displayed.
    */
  extern virtual function string get_uid();

  /**
   * This method allocates a pattern containing svt_pattern_data instances for
   * all of the primitive data fields in the object. The svt_pattern_data::name
   * is normally set to the corresponding field name, the svt_pattern_data::value
   * is normally set to 0. For fields which are displayed but not owned, the
   * method puts the current value in for svt_pattern_data::value.
   *
   * @return An svt_pattern instance containing entries for all of the fields
   * required for XML output of the data object.
   */
  extern virtual function svt_pattern allocate_xml_pattern();

  // ---------------------------------------------------------------------------

`ifdef SVT_VMM_TECHNOLOGY
  `vmm_typename(svt_tilelink_slave_transaction)
  `vmm_class_factory(svt_tilelink_slave_transaction)
`endif

  // ---------------------------------------------------------------------------
endclass

//------------------------------------------------------------------------------
`ifdef SVT_VMM_TECHNOLOGY
`vmm_channel(svt_tilelink_slave_transaction)
`vmm_atomic_gen(svt_tilelink_slave_transaction, "VMM (Atomic) Generator for svt_tilelink_slave_transaction data objects")
`vmm_scenario_gen(svt_tilelink_slave_transaction, "VMM (Scenario) Generator for svt_tilelink_slave_transaction data objects")
`SVT_TRANSACTION_MS_SCENARIO(svt_tilelink_slave_transaction)   
`else

// Declare a sequencer for this Tilelink Transaction
`SVT_SEQUENCER_DECL(svt_tilelink_slave_transaction, svt_tilelink_slave_agent_configuration)

`endif

// =============================================================================

`protected
f:Y7eQTU12#O&6<JMe@B/KZbPC^->dHR-4>DRde@H.bb.>#O7OMG5)\5RUZL,0<?
1N6bB4E>4<-&8,^@YW6XHC1f\]VSFYX<KP<]=2I:Ye01(&0]\=ZbOB\1FAa4-YLd
IJR;BGbeHWY:10\X./<SX4&8aL3f8BYf#M2cIYYf15RF&PVI.V/B_&9>&E)YY2ge
IGb2ARB(]L+\Ic#0ROT7QfDOD[;;^b+)2)?&9TGSdPLTacPVP/_=TL;A=1(ZMb3c
6@V.f[3.V(c+QR0M9XLC<,E@2X2PE7dU./F<MP]_/^])IADfeOEaU7bgHO9ZK_<:
@FT[85SgfY&(e9@6R#V#GbdJDUC=e]7eCKNbLD?M[2X<@VDM(EIEV_-19V^+77?O
9FWJ:M_gg]MIc-/@(VAb8Zd0:1A>W6Uc;,WKO5#4EV7aaG5[MN^G2>MFO#_34@N[
(\[;59#cVT+461e,Vg2(-[KX?=2@G:=[_5U[D>PXITe];A1-BR0bG2->If^\c/CG
GF>H<2G33cZYC9\LgDab6[6L:BVfY_(R0&X:66&32MDcJ@^S1=29+K3+YPf36V-I
@G=[Z.Wbb0F3:Q3B4A[NB>[^UMUK\WVcfG/W85QLXd8d46]L3fGDD46SY-6J\/VK
YQ_)#@E^d3dTF:fe4X[4MY,>(:FK&&^<B:AS,/0#aN:R+)C3;<W>/O7B7D#PZ5aO
NREC^[.;2VZP4NH@d^^L_b]S7[?&4P]KAPSaPIH(5S1T^+9[eH+ggd+&W[AaZ=U6
JDgSBMWSI^17\H-FNLQCNB)&^U&(b6[FBCZLTg:#7Q]0Vd;]IY7)0)OT:)dd<U^.
b#3>0gQ76A+.=(AOKNL>CSY0#-LGg4[T/Q@99Q.Mf>TF^I,--P(=IJYV;R(N:F(WS$
`endprotected


//vcs_vip_protect
`protected
<B\aAeOT<_:+H3\gRJaA(g.:SfR#c_]U<,KG?PRZcfI5@YZ3K;Uf)(R#6_3YB72^
>Kd.7/B5=\OK3(Q=:@PgK:,fHL4GP\]D[#HPf->([LJA\=9N9R9D0XgcQG)@ffJB
,/6(G,9FQ9X-U2F_&+R-Y.FW078dH^P9JD3U=K7e8d1#Z9+(.;(2KD3-MPa>ZVJI
.NNT-^PX+;,T>b2Q_-V<V=TEG^-^:08[@<9NQJ1X0\PW]Q8>U-:Fd^3CNFSIWc3&
)e@#U1&LKcED5@e1Ja=IGfdEQ]8MO)R2XZP^c-JT+23T.LI1K;C\H0LOD99I?844
a9QV3EHJ>b/U_18])g<KM2._Y#+JX45)aPIYE?8Q\Z)5ef\WeU>6UEU9:W9N;75X
J>_+47Q]V>=)7HU_O35=gX0,bRELUJ:+SF-&BJO;)_cS(L0]59:aD>NWUYE,Hgf@
>1D56H.6[Q#<62GMS>bE/RKOK]F&NdDHV8HHOEI8dRCb0(0)(,/a[4F^HRD:FW0J
P[NY8F)-Yc3g3NL550>BSVC=.O6[Z9=c4b03(VFI;>.Y<2\aQf(M?8;7e_)#b1P\
bGPDBD+fY@1P\:eCYM:X:TWL>#(SeU/)M^@WgeHFFB7c/Q+.;A1LB-87REBP+EE_
PX+3?#GgM>F-8gQ@A3]Q4T(QCKURMB5KVZEEO],]8IDX8J]=_cdVQWcM.^\d\9A\
b9.HL>B,OcXPU1:)RR>@?c,/K1cG66Y<2g.]cLId:P.TC.9A^NZSd.-eA&ZgS:I(
dWGcEH.E@JC\BL<+7\g/HGOfM[J4CGfBD?/X=?-LBK#I(J/Ca,8MG&FKP-XIE<ZA
b645<>>V<##/.=67@ZK?HR)LT+Q/AIRf4b\N)ORa1UIIZFgY>R+325T:#dS6ZHb5
aC6Y[,+c,=#;]UXO^a.6E?0MM^-3F6bZ1XDL?dP)Z3\-:(T;-[RQO#cJ^fL8YLF0
:O6V)5QaEd#c33>E2Y4B8&f1gG\1WKN2BJM,RgfDFF9_1#1HIIS^#Ua#[91C-a3D
A4g_e\dW4<b;Z9fTB(@YG0;/ET+5Jf2^DS.1]<Z^/DPg;+5WM?3FggQ)R89Z)8e.
A?eP4ZGe\1;M:#G7+bGGWN(MV8DD<.U[7:7d\CO&L=N&CEEG=I<MZgX7E6UW.g\b
9VMQba<VK&1UIfd]COc.a(F5):3:f,:]ZQTbM<J9YWGMc2HTJL0+>[>G2F2FZ1[\
:8La9<dNe6f]AN3U(.J>_=Ga:Wa8[=8<V,FK<dP2f7XC3d<=K30T_SaVaT)T&W-b
AO:c2,J^273FWgS_ER2^JYUdKRUTQSU9A+@B6L=CZ2LL@VF5>R.UO[IGUW#VSBKS
,M+Y5(._0?,6-QVg\\.^DI0EcNXSGGSf4>SGU\9I<^FL/_d)>..dF=(XX:J)dLS^
P<OK;F]be0HYaCaZd]IEfD]LZgY+)8QY-Z[O(?8Gf.+RPSDW+&W1N]OZ2B#9:C;:
2854S=@a\M<gLXM(g;7]IPX]3BA-)^4b\]A.77CfR;SDa8C6gO?O9^VQ>5e\K+cX
EB,Xc-K:ZGNK#OS+ZZC4E9ICe8EO;WCSdLNJ0]#NS+1@3Ae],K#TI@B(QEb#WIM:
^3EA-\H@@YA>@AM7K\#V>N.Z=T)Y??84fA\94W[&C&KgY.AHBOH\I;H,HNS(gQLA
]12f(]LV8b@6N9]GY2]]^<C06V50eAAg+9OU6UE;K1(b3YKe=X?O\Ke^8dQC2J1N
4aI7.c(JP]ObKXF1#8OIHT5^AU4SH91b?LJ:2&\K,22U7GEC43N492JGf)fT<B;8
P54E;Gc5.b,;)9bF7GBP(T5&&QDdL5FD4Qegc34dU4G]dC=<:3DI5D.Gae@^R,Ig
#-V@Pb8&@@FLGKg3:=Sa40S0QU.,0O76^YS\6:-f2IE(DOeX=C3cQW6?Z;W)C&HP
<WFa7FUV)_UKBR_L5aT2abE&;+P,P<\J(RNH>[M0-ONS=W4A]5a[,VX@770=&57O
L@,?Q1=V]+#bDHaH]b?RAZUG07;CBcQBRC#R4(T+gC\Y57GV>3TWHL:YGQ9BF.0J
1:fGG#egeO:?^3eKOYC/Q2UN/6705LQ3Iege5JJNWVH6[L(@N2;d\;6I]c0)]QN[
DZgUO1G][A)TVGS6EJ(a1TSE]SU7Z/gBG5^&3^2f8a@1THGGbIDZQ/fQ_^QS0ZTQ
F#F@e)58NE-YN>eT;PU.0)R:IfS]^H<H0Sb5=DV0DgGQOJFV)Fd&]ALSGQO07e,V
K>Rf95?5BeH/bU7>[/DCYdP:aYU1MG/./<62WV-))-\WSddAK-+5d3R4B@.c:WdU
E98O@N(5#LVXWGcI5Hd<S\#HU_-8?eQ=N=(f2H8?eST:H&GD<9N29L:FYYD3ZGM>
Y],-=\^2-5/cf/Q^)#(YcRJVXQIOA+e&N0,QAaC2.T8I<8Tb&O(UW9SL8I[DF63;
YQ3RT#@G9E?eSSgR@\-dE2#-aO#LcL(E3WaI6T>H@XH(>X_EWN7FC\</CXgR6:>J
=]AFeB],\:Ef-b0#(X_+eW3QL=M?#JTS#5>U9/XHEFQ3IdG6LQ\MWfX&MO.:8PEF
SR1d5dcKSAIL(MCHZIOC-W1,,gW0GRGRgMWO<MdQTPJ^(A\_-&(LQYIC==^@DX&M
D/YFU=,>HL#U,-.5ER(:VI.cNZ<.SXQP]C=RZGI/GU_YNEdJS99A[J?+QN^dLcWA
G94S#-EdDHS7VYfEJ69b/ea=@Cg;\F4?M3-<U)6Ae.3&&W17M1c-&^N.e>6c#^6I
Y9[HM-D3ZOfQE1UKC&=U1SZ\@>?P-Y&76MZ1P\80HJa89UZE0g>aZ1_HLa?&WA)2
N6.d=7\XBC?;J_Y@HP0M=]aK(\FaBJ4SKMA-S?AHGJG5158M,f0=GIH@K744RcD_
d#LVa)HR+GLdU;/bag?EU)9D88IIC.eI18RcS8:Rfa@65N;VO;O.EK]daaEMJTX1
N?f(-\GeG2Hb23&56(bdLBC_0K.Q#P\bY@Nd>?);cgSMB4/ZT/<NALY=H#EUPIfa
Mf3f1a@d8QfK0TYGXb)[LI0.VTL/4]11/9Q8#/00W6@&^W.(A7(IHfJeMf800]b]
?VeVT=L44BQF,fc6&N#Q9d&TCH+@S\A#ELRZ_BMKOHF?PgMDJ#UL@.+JVV18A<eC
;G--HIDSNKIX6L>382b=a,@Gb:W9-=(:<W7gCKP<TT\&TEceVN2)HBX)X0(4UAG(
>@CXR@59E-:@6>Q,K4J(D9fYK>V35AUHH+-D-=QF&AaRFIK,\&ECEEG8[;VAD8XS
N66+=(WEc5WW]LDIN]Ja]F6V8GL--=F?aIQ6&dN3^33ZGO5N[0JAP)SXg+6g^)()
AW\@M;]7BI4cQ8TZ=W5UHe^D#@N0WBA7O26[-d2-)gfY:CIgSbV(1X[G,<J8N&^9
.KIWM_L(P1XdR3g_(:;@WY3RDMa9^:3>BSD>aY5H0VV^ceH+B/B>AJ&Q6I0>0GB#
3];K9_^_aF<L:J?CWdgdL&?Y(25YD857cfIXV:gee4.7AFd]>TZ:21RFDK<?8@(/
Y-O10ffD]Pe\VRTMM=9VUY/#7\08O:f)Zd&MT?8Q:2069cb?/)>_&QU#NK.bc?FV
gDS@2CKP-MM77e=IV+9IC9SCY4R5P\9B(9Dg^Eb^>,KT,8-^gQ]@5b2<CG6):CS3
DKJI1e18(QLPJOQJIA#Be3Z#g?#D/V>R?MDFdW9W<TR/B[U32>D3CXc/WMedE.I4
5Y3YC9UMZQCZN(,ZO-c7GX1_89+^DNfKf5&HVX?CV#TE>ET0\NZJWMP8ZA.>J@Gb
g8TN>[e;.g_I8S(4TH/fSg_+20H\^0,8?2_)0&.EKWKf5gT(DeP_#XD;IL/d?&6,
Ag/;6)^O:BX2]&(2RAV:6H4AQDg7(8,?_3F[0C/VW<O?)JE07J6>1X:C?)_ZRO\e
cYWK#SFB24XWeS+#IN14-@MRI.R-DP4XGPZ0[E40NJ7RL<WKGe;5[;X0/X)HGf[^
B0#dY@8=FL7[VI9L0[JO=^3+61#<OOD2cc3BJM9^CUE\)3>KMG[g81:QT_ZGQ^?-
d9c0ABf[6#82bM;A3P&0+.RHLO;K[>;3cI[KbdIR9==+Rfc7dHVT_7dLdC6g50OG
bOU/8d>_)@NZ?/AFB,O/>YbV@OICYNgBXR2QMA.Y<@FK&bJF(UK3;?WM(cFdbW(O
\<fQe=Hc^LeAVYWN\6T4AH01IQTNOaGY)9IdC;<Q83D<@cR&&N3A:;P2:7SUNR@A
e^B^1<1:YbT@](G)L=OQe4?#7B46>OL4;V\A.@3CRNccX]Q_X2=B)/?ML&PfD/=/
IV]L\K[49:04VN6cJL31,WUTe8Ca_d]/OB99+X<UOT;1PXNg=R.II?FFf2UM?XQ6
+SaLO4LQ59?BP(OX?b(H]fIM/b07Wd@P&(X]AdP_E9D[?cO#MQZ:R663\#5^Q0^g
>=^g8/2EJ\(dX\/DaYXd2</.Ba;7[S-BMQ8Ve:M\/-LOcf^BUe<MN6F4T.9:FW/C
T;DGI13042>(;,R>:RVWZU3.b,:aVXCL-:\bQKAOI@B:7&-&7)DN(d<T1f0=+S58
4?2f\.fOEcNV(#:\\.</45c7N9V<_.@2gV<KB3\aNNCgHFg(A3\g?,TSV=_B&fE5
XdB;)agX6a&7&1F5Dcb^3HRRbN9OOYL37,]@A=MN7G-E[;gF2?fDe+Q]D<;Z29S<
)]@27]\]C<Q5/H;Dc3,aOO734Z/[&]M2Rd5+;2K#3-889^]9O/#?b_:@H/gE0T0^
>.+@K06&FE02bc@X9N:_Q8K4R.^.&cX]<H8d0JE531J[>9?fUNZ(L&V9E#[<A#\#
5_2LL1M04aS;^dUAI)J_XF.O;Z41QBTJ]Pb-BYORFFM?>U3UPC[58<_D6=F.]2W<
b8EUM=b;W66F\Ld3)0/FHeI-VdJdeN/a^Z[,bHS&/+^GEUQR4?#41C.9K]=SWR>U
KJ=8-^;_0Z_T,V?eKdMT7)1PT;c_A,U1fLCY<-/2Zg,_\+_EJU__[XH7YPb3I8e&
cdOae^=)GR5I^&[8049_//;7eIM[R9c=R_VS<V=dZJ/S?3;^3VM(/>b,SKINY;[G
#YVgU5bDfCI@N=G5]f^A\SX7NYgY2)eV<M:M4]V_DDHOIE^PMLYERTLd-g[F&UaM
b-EFPL/^e\,U1=_<7:c;>VgF6IS?YY\^F1CCBGa9:.HdA#73QLPMGK7H4cg&[RBL
3Q9-H7Rf9GWV)eG(M@Z536P]=aFBIF73c85dY&A?<DF\5D/+TBUNK/_M-;672dcg
SIRDcC1P7>;4QR(K2MY.N]f56eZV&0<V:5RS40<H.DabKG88?>+(L0X#Q7IVMO(J
&CXBA?00TfX\7.<HU<V73=Obc/2;_+D8J4<WEaM8YR-)C42Y1)CZABR]&8/2RcAe
69E&FL[I>e_gbGSe#(Y?:CM)78/&3/HA#<62+2R-OM^H#T07,J[^\M4T5@FLK1D/
)J]-:>5W/@^Z)T-&(8S)<4Z[/Je]8Y9::)V+_+MF-U/3RJFA\_+S_]Y+ZR1&bKW0
Vg5->IBF8+.CL:[N>X(O<O#9D@/J\/JK#NZ[NT+2I2f?P;HI1N,T[_+MTb;BRfS8
\#\SOdI3EaS@.(XHa-);)&XNP].6EHA]_[2CO3[BcB;PJJQ&,1V>=ab(G6S^N?2A
9TLU>R=.@?C3V0+Bf6gZ;9?P0dU@3a3fWgVUdV<1KKA@=C)f(@dD2_?W92T>a;MO
1L#TVETeTO,JDH0CVdQB2=dVG<3NG;:UPK8cX5;gZVbPQJ\V.KSAPR^aE305K;AI
E9BB0S-6;&];3N,]]6O0FJ1U/9X(a?dD=KR.+GA--#WPV@AeG_T^K+);\:1TPEG#
7<_]c3/QSdVWY9+4dU@,[G./99(R<J-RZ6,U7,OKHN027=g=4Ng/>@6)28@^8fAa
^Y3BK9fe@XKcdAH30F@aD4N+46&[b+Q?ZeAG6AJ-:8#Od[M[-EC/)T;W3J9DD<-4
9UKCHCW_XaYCUS9A/QAI0Jfe?J>>]L7b3VX_^UD9/F_b_WJ67BN:N&_1ATISL.]C
V#BRZ&Q>NKZ4d:_cea9^:.Q.ZW&S?8KGdN]8cTXG=GYP:L6fD7DR?ZR_G[IJ@6H_
2,fV8T,^X:E6N>6B]g31CId]a,Cf0J.3gV4D]02eDY0)(L8MccGNAIP0ZNcAg-eV
7P.:fY)?#DU&=XZY+6-<99MS6[@;EN+U.?2PJa+^]aI=aNXL5R]dOLQIMcHO8I@J
,0PcI@?J:C&BTO>U^8ZHL3&=Z<8A^Q9X-A._,1GgfL4+cW(SV8N=&Le3f;8E2e/:
+2PS5H=Z3<f]<K^2]P[EaVbT\dZ1#6S.4SW6,g;IK6<S?^KR#NK;>7_6AJNC9eCS
Y8:=BUVEUY3:Z.F,(5RXe:M^#XfOCR>=QG^(#9]OY6c+OF)fU)+O^BAOI33&\D9)
ZXWc+T/V+Y911E3+]QSBV87GWI.&]H9c7F;]GIZ=:baIIM67[eU&S_@FHa<9;,E\
(JLEQ\6aLA\bg]4S0fYW&1?ZWI:dIMbb8_T5LU/EUaA\MOL>Y_O@IVIEZeLg/7MO
+H&LQ&87#Df+?(XY,/aMBa8Q;Aa3K&f,Je6b/SH<3aJ)641-86:BZafKOQ;I>;S]
I#Z^DQbG(4=7Jb3DfC[@H=WBXDeIZ2MCJgD<HccA;YN&(LAS?^\\-AU:DF.FOH&R
Da0NJgA3df-9N/<R:&VP.JM_Z,D/6FG?6VHb23EfMG2687:dT/H&eW:;W@JH0/0R
8M<UYa:C[B(=C/^L=.===&USQ[X\Y^a#N<#E+Y>Y/TBZOaP3?ZLZ>ga+U4PO\0WX
#f9VGL]41S\4;/JGE#e3MTLOQW-7SY/Jb9=[K?/5;5.&B=@FY5J4=MG&(;g8]DaE
Q/cBSM8aICG=F3bCPJQ63:^LBZ&HgKL(F_FP@-KQ<Z1V,1dM+5MKC(1V-Z9\(<EW
XXS:MX^;9:;CERRUe-])HZF]BCLCI4XV1^#T:aS^,]_FL&89J^7_.#BHT71S6I#]
00E]NPZC@a,HdXe3ZMEc=4(Re/^HNG.>K8[]RY.a;@(?[#b7;CaQ>),PB\7/TQe>
1eUU@/4-NTVBUD^PF55^g@K]-IfWIM^^#b9+]g-fY#+f75<2GZ8ZfRc52Q87Z08K
\.E5OU8VfEecMM@EbXH#N;-8XYLG5f\.P3D3JK=3:K[MbQ#7_b]<<DMRc0]IR(P-
8\A9c)F#A+IH#@U?_]DN7;BAda](?2.Z0SI[@8#^#?N^C&>UB0.A65Wf3HPB7O3A
2#.a^SR4P,9Da0V^/-d.4[MZb]F1MQCf5@a0^DRL+M>YF&6Y7U8_gL#]WKPA&HeC
Y4R;Rf@ZRY6-16+H0F:2QR@bRKLGJ8Q/\ZXY)GE4:SaKHaY^:7g^b0Va/:.K6b.P
TbN80HVBT?GfX1_g&/0\b/[^f8#7^6bL/F)a2+XY[E5@[\NLGO;WM41bdHce@K0G
]\5HC\.=T_@2-ZL.PPUJN&MLN8HcM^Af#?BK)HBLT2=8RL32K&3Y,W69f(.S-.0V
ga/6cFTJXKNC<3gQUPW@)R:<1dW56(/N,Sb7A0>>,d<DMY/bM4NE8>V\33))/PWe
[a511=3:HO2f3E&:HWQFRNM@\4\Fa[?SMHN]JG3Cg/(.9L#Cd(gNG?63V^4>Yae;
K\bLLPPLd(I:W(6(I33O7(+EK]3;D#Xc:##RP^RaG0D28#Y.beI:@3==G7<UQ65B
??TJLKI5b_NL@GO^1<P?\,).Vc9S9.A:MO1X/0gR=ZZ2e#ATSKEbJW??3(NDI32c
DLOB(V/SM&1;<fB/WE_b=(7,/Y\MJZOTg?K?;BF+ff[CPEX<U&)YGH8RQg7.b:d1
8dNecXIL/\fMYV/=D/1A&W_EB[ZDMA8<>5U7:RH<KIA.N(\SK>^N_^]ZNV,\X>UU
-=SR]_8ZB3TSCC3P.2aQFH.6QR975(A^I3R//3P7R[H]M?eg9&GK>QK.CR@,eV4N
begRR+B)R@:7V^eY9]GMCXG#8Y<@@TY(F_e;^>Eb2\&<[e3=DV7P;HOJ7E].ATBW
O.S/7V</_9We[W]<VG&218T5;K-LfUe?7e^=[bY1dfN&Uf>Q4N.6/=2_/L[:L=7+
3@?:07c>([83J)8(c+Z=F@A)&_>;7K;aEfA9\&Q;#T=4+;JP5YR/\_gW(_B&HIPd
VMb1fYH=72^>19H9>B?S,[\?@ULTD](/&(7OE,bZX-EGM32@<H3DDa=OL+36?PQP
+b8\f)(c6(IZ1?AQ(+1/&917/925&gaQ:.[2fDKb:H5<XY=&&9P8TKG=WJ0@.@E<
W//9@@U_.[VW-M7gPTGHJf,W_:C,33C?TSIeZb&=F>OGc0J:bXXMe\Xd^PV)a.NY
^LI+<S8DZYQU;]6OIgc(FdTX+6bRP&A0)#O?^F171;7]e,&/BV,d([8/Q7D;a^(W
6E1+F\#VC#9\<HNQYYH#OKJHFE6;)>E:5G+Cgd6K3LbSZcGTHf#[OF^L=[gX)fJ@
+0(R_5VDRBX5#3BF5:\^IYDV.BWbe::6=g(eSc2PM[/IO+eCYZ-OE7:d:g?eU?g4
1ff48-c27HAd&SWeR=<?DMU[B=NT\BR=d@(,/Q2DbP0&9>..NKd^HeTUdLM.0YHE
OOT==5ZEfX,SNB&4VD_ZBeT6e]G5RNefCI@=OAEegSd.4<VISKH7,(#&,4M81S_+
7_c/8Ib:0=0T-gbRA34bP,JZaNS58:JRM7_NSY#=1]V24)UcUX?.,/S<(J#<2A,d
g(&F0Wbc947MY@,5_L5A8@=^eI+KN<GaE[VC^&IN9+9H7bY2+(UYTVM8YL/cTaHO
Y[eSUHLRGF[,Ba.4V24R:A[6E8LM6dI6AC4_5CcYEQ)Z?ERLOYbDG[9OeYI>9bH)
L/9SeAaX)N(ce6)g<Lb1,2M>USc@^QBTPRNB1H+701]4XgVKQ6=W]X0^2/AM)\C\
>CC#BZ1,+<I^6+0@X5A5YS4?WP.d\4b4M?8J3/6Y8;E1fY3]C=.EPMg5O3>XY:85
SX(WU:N([).DG-VTN9e.Y/,G9ZO3]_f<@L5)3U:dWA6433/EEF.fQIFLY@?O9@C0
:Y[5&,I&G[9Pa&H-N#J+L(M:fV3X[MAYDD@X6fLX)W6K?[a@)0&6g@GNL&#AUO_X
_#G)KeQ6O@8J9=WXSA&4a2L^1H#82=FJD_)EA=K3dd(a?Z652STFB<KGUR[#JV]g
CK^5L-<()2C102E@)Ia#PLTW-N-3O:5O8KL)=A+&<?+2-)A22@HFGQ.F?a_#&]a[
Y;ZHQ>LB15EH2:MbFQ]efW@<PB[8.gZ5Rc0U;F2(3Wa4I1#?D&BPPX;WJ/[9-YTN
VK9#105>FZ0B)WTc9E4J>)e]e+J9U/;+7KTGO7Q.WUgCZCO;MP31baKZ4CP^UXX;
2TCR\N5;EN?@gGDO@(GZY2JT.?B]dd-fW29/]1X)3FeYQ834b:0=E]B/cAB5_AW-
\=WS7^#X/@X7aK-\XLT2gHMaFJ=POJ/JHY><A=00\QNR;<\Ce#g:,Lc<LIdM2=WI
#D3D#g/66PEVNTZTN2QbD#9S5+VUa??9;SAfUY1+P.-(Y#Gf49@=;KA.NRLc++00
MITVRRd^]_;2A/>)FdMge)I0SYRO=DU46I?;41@cL+07d[[Te^_BV,GOJ_-<DcJY
#,T-4#7<NO#9gdUQ-8[Cb2aT-&eSJeM@Y>?f@&70290S-WTg7,_D)c#6)^]-Ce.a
]gBc>+&Ba_^[AR;D,O2&]&9(6/1DJ+I])=7aD,4Q:_)=E:_]409(?RW^L:)I+Q@3
777bAX#>[3X+IAAgc?\GK:U6L]@)9OWcBad4_6M],Eb1Vc);8Qg9:]_MceP9:XW\
[AHd.Q\@39Z]<^cDV^[_8TW\]KQ1fW5(-9DOPEI?7gS03J7Q13\Q(K>(I&.&eZ9:
7d#\13[W(6U_#+1];&g=EDG=#aPecG\Y:P#17I,=<ZGPD4Z-,.81c1^dHE+2L3dP
KC5HSF(LM5b##@NOg@B?:Ub3M(:S23=,WCaA67&:_2/LX(<=QB(R8HfJZ[AH3b=I
,Ib&[]Z>P+L6KB:b75@Se;gE6df+g4C6H#^Fef8Ta/VNGcO6YP813HM9_#4g=I9M
cg?Z_P2?_3H3Z9\,R43^gQ:?Y5.SA=YZ3#bU3QCWcdV;aaTQ_/PKG)HJF<:#(>CS
NaKM\@:_&VDgZa:8bdbJV.2Z--+8c4c=bS_GAgPX\>?69g2Y(fU^:4BKa@T4+caZ
Vd]7V?/dFHV24UMaK3A<b,ae.4E:HUP6Z-bO(+]<^&_OV2>gDeNU=>TGQ)S:.Qdb
8J(JY[.P;P)M@K=P51O-CY?FEHZ-e](T=:eC:DLP#9c.(;Rg31bY_<?+29WbC>@K
0ZIKcF=b6JL673X_T<(OCP4gC6V::S-P&8P[T=#H3C30)[-98B>?Ic@T+P6,IZOZ
SYFGJ;XY]43K;JEed]4]a5bJWB#I/X^]:?Y969dRX@@Q_:(>/ATIWT9\RBSWba1>
H+7SUYU4](P#<Na.B>+^V51b,+CASY=C3U7G8?V[6^A32@NP7,0.GR1I^9/.WJ+(
GIRS:C(b=7TaJ0BJ&;b264/LQ5#D)&O-d:OJ&PL:U-V-?aIN^E.+GYFTVgYVP/QE
P]X)c:?S;)?RB#Q9UN;I-2W5RX#ea>>3Q9>PB9a(.I960:@\6_@@@R/fCLH=NVPG
O8BOG5B<TC-<FZK15]HU,+d1)&X8,UZ_&d7NPDc4faU7=\L(+5g(ZQIE;>6Jf_L[
J33H:THe_?P9:eZ[7JZJI^?AGLSQBJ^?@99^QV6FS+=ILQ0&f3RaC_X?/a+@SW9]
A4B.+8gVURF0O7[MZVU@d8_5b0DR/JR&?#R2++C/<80-:UR3ScL@Aeb1F+WB@3-M
WZ3EW+R]26(LLJ:^^/^gHOM_@]G@0aDO#U(5YK+2;NHaX<cT93E#K5@B(=XfUgW[
]f8O;V5JMWR/IbYF<@/b8:\#BC;BVfTD&bZAM13CR_e;ATgQ>2AP.<D[Ze==S-2d
XS^c12[HaVT?HCKO+=#_7]L_+TWTHCfP[]b.QC;fFEPO/,YbETO?BceQKND36C1e
6QD7+5+8P7-gHM=1ED2/d;0VQBUN:NC^bVC-=>:9N8BZWSg;]_U03Q8\-Y5HWfe6
\4M2.5#:cKNBB@PV8g@ad&H#(>/JMV-;0:8e+Ob2B][6\L.)g28.K>&]P0CeH&f5
HOC??[R9_5A14TDWWZ?e0RPF/?eBYD_K:)F/[#1I]bfDBU-9H1SD^1K531+EEYYH
SB,EKZGM>-g7Y@H;5gA._gZ9VI2[eKKBB3=NTOe18d9^1JY;KSF6_I?J\f)E;OT+
/MD^N:\G0b&[6IN1E2RR>;]PS[9J<HgKW@CTONLE&-@Fbb&VeOS(M+[a=-736U0>
OCb1/Q(U2fCVbBAZaEQHa+CU1Q+3_QIQ9R-D#U9[XP.8WaGg[)SQP:WK6C^eK0b,
_C4bbZB?@dG4\X>^XLgLFS;@8?1]]b-Q?^P5MA.f#e+3e&J:_RAZ8@+1U\d6H[ZZ
5PSYRQRSLE[+FU(0A#(DY//<M2>6VUM#Z<2aeKA.&/EJ5M5^>7Bfd@^+DR68I1<.
C]GWS;.baP@8CGUYa3=61<M/DB775fPf(XgAHTdYUQfH0Q\[R4)?2?XKBBCWL(ON
ca[SA&E^+CeA&/Bc?XS&&)8;7_JdTY/\E_IV<:96-SG,ZHE3_]]O&EP+f6-<3Y:A
Z?Ad-AVf7#VMH+NKV.ZYSG6[dA.-;VgUAL1]0TW]=A9Gb?N2^4g(:AS3^8&WGe_?
(?cbN8J0>Z1WF1N_X0X2,O]beA@Q3#18?ML;(WeMQNbGcBX054PKT;=MJ_]@7:GU
9Z]G)<+/;=Z[06U<Yb?Od;49?(Sb1Qf<bOgZV=cR(3LRF:,N/3JBUBEODW7?Be<I
Q3^X5]I,X4264)b-e0/aP^]KM)4#>a34_L<MD[#[8<g1I=PT/Y5[J\G??WX\>)DA
V3+><.eOdPV.&Z(N:fO<.LP#>@_2:?MeW,fcTFTSWbeOH0LF^=J4deOdCA8<\J6=
A&g_P_Q0g&Kb0]Oc><)2WEK4,TbD?SeM:M=>6MYg^CgfDYAJ[LMP<#9W\=(WaWR0
T?)d/_#)WB2V_54A8?ge-1R8B@AH@MM_JC8YE7SMLU1a,O>d5-6ZU@)6+2.CS/S?
[FO5J\]4WS39V^G.-#1_RS3GG3:PKJZAZ:QSZ=F(fXdQ&;e?NAe2c.JL/UT=.51:
#Q?&IU-R,J\C\GG2(WgI4RKZ+eI;Vf-e9M?fL?U;/7J?HA-gMcN6\N:eSYYGQc;F
88)VB3N>OS,G&Q0_-)]Ea:VCC7,H<=&XO9gg^Z,]8a[MebSg/1:/@:4O/X@V]P4T
;\4TU?3/N<d9E6e:#P8L(O:]U&.DZ\@3+,N20a;<>.=,KeL=._Jc6Z:-W\fSK6>G
:Ld9UE\7+eKP[^-=2__>M<d?7W\U7[dNHR</&7;2#V</^gg&;]DdO9>]2A&2GGON
OfYGf/]Pegf\S;?JWMVMXeFHbC+I:D5:B_2+:4VF7NLX[_?gGABMdR,UNIE84ELL
@R6B,YDY1NJ+S]3&AfDYDVY9SAP_<\1dQ;4XIB)I^U5RUd-63)S4S55C<KQ[HN_>
(cY_H.)M9I7gFQQ6KW:A,-@:S.>f.PM^YD0QK,cW:^KJB)c8I1W1@NSJ4Z<E^RVd
d>;_B1]U41SQ@UB,A]fJCAP.88dfPNW7J#[\(E0Z.Z?gcfO[e(ICV_2.IA5AS3,K
K_E<[83DE<GB]YD(IZe=;D4S.GYF?>SN)L53;80->K=.AU@]bc+bJcA9V.c+L;Kc
-@EE&OM6#TCARHOc+MDZOG?2&[2c2INB.I059UG;PP\F?RTZ/=G_^:DI,#(6T8>?
23J;B1TLPQ04cW:ObLV7LbcdE/97CZNI+BVM#R>UD^KUF3Z?)IY;1S5[=b6535@V
5g(2W#YcOg350,8QD]bWH3X43L.V:f1/)6X&TbfYgREY,8,EY7#AW_VR(5<\?Q&-
>)E5OdWF+<UX<:W3_4;a1+G&O8+JM8G_WU/1PEU=QR\LQdSbL;:X11F>6V8LZ&8I
-AbCAZgPZdOEIBGYGZ(;=a]ZfT10@5+BXUD)KROQP]G;/-AbZK]OIc3WO@<dfD1Q
@@BCQ1:4+912-X-J@,MG)KgNJ6MTVCH&b&_g3MRe09W3[P5;eL9(RSN_3C9JEQcT
cK0GLc9I^T3?6XSI)^Xc13KJ_#MOdK([.N@QI.d=>^C?7PA]XGUe9\+C6X;9@U1M
=;dGdB\+/7AN0b2DW\@e_S(XS3dCOFM2RIN2L=cXacd@JfTE=ZPc&.@]H-eJ^89+
WLNd4U-C0/:ENX#+:52C/:Ee8=4(<:79/_3KDJP(8O?DZ[7/G[Q+M&[D8PXW24gN
A#:5G+.AA#_JH8\ZVe5?WA:95R0@bfPYb]EC>LEG@\N[_0dKZN)4_ZJY[Rb[3FfS
UCD?Z(XPdVP5dWAe.:^V(5M=Va>)T\<)N;X?fFC0Y.7U8-LSCgBI&Zbg+VTQC?0D
<V5/(.\NK2[?aY,J1NfAGc)M>2CaCK8eFZ@Zd<BfBPL+1.KE82MOALZU3:;;2R(P
c0g1K]Q9aKH;geICG=f/V#9[9\IQR_VE(MH;[O:\a1,77FA1Qg/.S=VU-c_NJRGP
]X:0YNKC7RA6IUU-fA?ULJ3e1-0\&^,/AW&(b#)05YXVG,d[W&d;d)(?D6AgBe//
YVfA0,dLgD?:BEVG3V]\JdUGEJ/#af>[#:AY)8LbE;W\1a0;;@N9]#+:I+.Z9MPN
+V&>dBEH(U_-XB/f#;;_XV=XDgH-L-1W[\c2P<EL36PS2+SLPVKe@H&31Q^)a?)@
AQ2bJ8g-E[K@J4,S26\<gIgQIa&BIM0SH=eP@9=LT1CcEG)-#fR#_dMBdV8G?Kc1
eHS+8YbP6LW+gJKG@VUdI-NZ.YG]W)&]EU,e1;[6><dQ<.dY4?Z>V+JY>=2Wb59+
c)e#_.Q>2[11/&G1@]WO<OK?N3[\D&VM8;LI6VS2)7<>[a+3RdS_4aOd^82dDSZ@
#[gD&/5O+03AcG-#afN55)4d0LG+ecD,AB5Je-\_I\a(WVL+4W+(I(FQ/?RcGEaV
9GK(O=OXLc4;YY?G:G9(94fU#6bWU9)ROKKR:9LXW&8[12[H-,R&eeI<Q7Q>C4R9
KR-D-397LON\N?[f==JOZE/f+CD14Gg>.+3-FHEe.SBZLO;/+W;G<D.ca9^V91f_
R3,SZTZL\gDK_&].BS56.&(8G/X:QGM(K=NbBb6>\fc7RY3TT0U)K5BTMOFbQ+8M
2:aJ]@/_XY#:(T4Dg][NJM\8[:1H6V]aZZeb?29?C2?:].LM1\7DZbKO]9FUV>S+
<4J(eV_GcQU@=cPOR5-[LB/]9FC:BT2bIbLV[QFI4,3(:c/YB>-fg6e(0<ML[d@>
NdQ1FGc&.ff\><#E836Ig8+D.d7aX0g,C[T#I7U50aMQ>YaTPPVcBE;dC_-V;5fD
0J6b93d1f/]J1<WO&_L9bP40)a5Z(65;gKF+L=V63D[<&EZ^&+@:=Ig/K5<KebJ=
aK7X\:I?Ib+M9_@O@-\#X6.B<b.GX66A@:dKgF>F=-P^VA79e#DfaVKDA]DZTG=X
g)Cd6G:N2=64O?C?DPZ4.fb/R_G]2F>ecYJ=[bSJ:PbC/N4]0)6:]::7>c_&[#U(
S)XL@Z-4)>E4@#0Cf+IJ5J:-_U/0T4L\CM_Cf5]+[[O5]Q8RCW\efHV=c6>8L9ZX
KQ,Z1Sd1[;)(<@N^Q1T#b3gg).[A<a[&8fM55?Gb2/Hd-,K(4:VX+;48.GGd>:@L
0dHER\N<>=E^HgY0g<ac5O)+R)^KGD1H9L\I.LR.YO6J(JA2NLcD9F(D2)_JO:BM
\Oe(#DYGN@ZW/B1WOE)Z#D&B3W<XIECUE1G#.E,ce?M\K.gZIaGb<K2S>3ZN-C#U
RKeJE7-ecE=@9=GF+A+Z-S>PCNH9>)Q2XPB6:<[BK^FPP]V,9)eB<30-,3Z\:>8#
IG\.0fDQ\^e#V4-ZBV_LBO,;fTXC8+R/)ET;UTb9UgGS\>H&Z?H=dfR.XbZMP4B2
d,WK6cTg5S#aFZ)d>gM^e,.#RfGS02<20^37LIM3<JRf;b&C6VP&O5C[H>f#cK_7
XIC-eX4W-[KD;F5[,d:Z-S]+W#228DU(=\=#TNL/c_QFU)<9#J=L?;EaPOG,N0/:
_-8]Zf+K\AB.BVO9SC<T=1^[+J5?0MSOSJ(@9L6;OLZ;A^0:^&=M69P:1dLZ/./-
^64257640TA[S;X^[>S9#AQT<]RAd.Y<Z97J>?N/QXScME^3;-b4dW\cd=NC(G^2
Ldf?OQINdFVgONJ/R7g-gedEcb4AC_0\SAP-g&&&aa#.FF2/&0&TN3d4H,KFO&4b
6)X[6dWY6bK/2)/deQ#g])J58<Q_E;XI_TUHN35cC[#1V4P-H[2O3R6MZ/5)NS_M
VH+E<:@bOM=8PcTWYKY5KPHN1XQAI2L96A52>3F5,4-?b?;&<N?8?7_\c(B(M3XH
ce1_XU@Pfea;DD1IE(d,&8:cA^3\PP<H1C]TEH9LLY4B7X0NJYO52J@I&J.5S<\<
ZO.I+))[-HBbXdJ&8]5gR8>87gKX&12cX<Y:>fZ7VIP@CK\U/?aZZ2M/?A^G5=eV
:--YB9]B>MBGV0ZH&_V^KE;0,bIG(KLfPc:5MNHZ:6B,]Jc8bd0U<_4c^VGH.\VL
/,V6NDT+5;J?=GEMCL_I?APFBKY,;Vg;(.;d^<fSZRR5JS6;A5MV2c7J]KMJ&e-W
LNV.GE=+@FGS:Y)[@20,Sc,g5IV3H5W\Sf8QP]400=X#XWcI@0H_G&SLT;aT-,]7
#>S-a73fZ_L_NO?eE@ZO9H^0?#&fgAX3-;SL5[H&cJZ[SQCbeQI@@,GJOL((81Sg
NABe(F><H0gf5,O83fgXR2-,\I+84@I5(fDK+@II/KPK5DLPA.LWg\IC-&UEUTS3
U_G;,_UQc?M(0C>P5;1OOPeCg#G)M25EGgH<54B5)3@\Z(?&X.295Q8311(TQYHH
<6FcPA]A,G8T=Z(S/8RQ-/5COS2gR5FaW6a8&^?(#-#_M=O>?NC_1]fDg3BLX-Y7
V(JK^\(B>#6eZ9\Ta>7ab0RX2gRg3,D3aG5c;T3fR((B5X2/[BPSSgLOR<gQ/-8F
WYQX92)ZRN<>U7d=/S(7;>FeZB7PM;gC@\K?U[,HR@B1#W-6f=eU8L](+3ZgB6DO
OX\2QHe)@YVgB\WH_eVP<9BS9NXf(?a#U.+,Z.S^DRWV_OH67U<?DF_ge3;V(@U)
N<2.8MBfG&QU<?NWa6eV20_d6OcdO]T,1OH:WIF_=fadEK]b?1dgb]<\>b5J<EAe
MQ@f]d_7)063VH=HR#O]7P,PDGLd@KOM4A=RKXT/(@3P:gI\4I(#?O(I.^S&3>/]
a2\eN3c\,OVM(]#YY@;/]Y:[^<<K(YXW7f\]=aVI__a_/=U/_4XEP0D^AQRK\]YS
(,/L0C)MJ4F;HMG2+)TEME2EWJX:8Q=RA5DKSH<NgRX,P_N,YfH6&K1VX;/=H-b,
a;=CKO4[7-9&V+GS5Y8]gUOBA_J3T]6VRT@#P8G-M5T]b+\&acT3bgG9;IgTS;O=
2NCE5R6HVCA\EM+?V)P:?d;15-JA::AfP.A,dQ>?\?W=#Y[?48;KCG^6CA0[TO<W
7ggDR#dH&_.=dcR=0WUfH^;G?XPUdY>)\6.eR/gE7OSGG^?RF[baCOPMH=:53dWO
4cF@)3-g30Q]9TAXAe9YZ_1AS&a,2(Xc;7=C(Y_2b;;?-M=[E/OXE:cdM=8F6a/_
<#_3]9]Qg9JHb8,+d/\EfXK]#XYQ2f7_Dd&MPCD^NG^#3?])#<d9V6(,^K2=XKYV
PLgLYfJ<O\3X&aQF_YeQHIf8Z(1\g++B-E[ECDBM8@3@2P&J-\J8<ZK:)Sb\]5NX
(aBL7\V,(_LYaJND;0]a+:H1VPO(2J6Q0?;56/B>T7GVC6&N&\+D[a>YS0O0-d@:
g49fAK,D/)_6bY3?DU@V#,&<-,9g-UIeOZ;P_]\(]CSP8#5+H,]@@25(Q,#UNFe?
J-+TJY+.=\+M([F68G>UOXBc=<#((J7+NSgLc-VfR-5=)]f3dbYU/T(LUOBg1gE-
cBOQX)MUOD@dG\OU)@34NC<F.&MS4L&K\S+@RIE7]>E/H]=+Z(A4QP7O>:E=5F7\
,A=-@-g0e.-1+L^aY]ZB=U9BVFL6,3M9C[]U0S4=+<0c[a19_)<cBf.Q>U?:c<N2
=,bY<ZZ3CDUQ5Tg>X)g_e(7ZT2caea?(L;0SE2L^,gf9.0;)+R,AdA^_LZ,#9,B[
EE/U>GO&SSY?c__L#CdD?=_9g7U0b3JBU+=(4f4/a[;W<gN2/.D>NBXV(D.RS0+a
QX27X2WSeOBJVR-D+,@7(e4f;EQ<8+3<.4EI\Je;VQHDbKWc_7S&G#5R&eb#?4I8
813fW):T^:F86f],F@OXA=(.\OK,eg6eLD\QGZd2IULd9,Y@C#>g7V-8748\ALEH
gfM1S]45Ta<5^QWPeQF@S6Z[gYMISGPeMa71(f0,4M6f2c5#F28e/\ZS7;#<Md)Q
ga=Db8L.eLCE=LR(?]72,,PC+NU4^e_=GI_(=b19DW\,WNA9aW-SCIQQ4J(+Z<D0
?&NZ@K7U+SV.>RCHZ?YXT7SJaB#_L((5:..Z[LgHE9Q9R<)A_,DcT:W#F\ND_C2\
H)KJ.TO;LTJ7SL_K0>QfT/9FG+&MMb,SMSC,IF.C\J/5/LbcLU@#E>\fQR0gMK9e
T4I?LF6<NU>b;51ETB&&a2Ne[9Q]feA\1?9B0F0c;6A-1Fe7\/#B=2f+PB;TDBSM
6L>?9Q@BEQbT_>/DTUMMN7[,@MLD7U@:=@g)WBZ=Q+?aQV?XP0+,Vb=AG)/9U]@[
W_J3);AVB0#O>IMUb#9WY00DE6KYR@gKb6^#6V&+MWT.b\S_S53EcLf_+C9/fE9\
6A-2&g8;Y@]LOA3^)S/\O;2Z(PdQ=4E@(JdEULS5[;&)H,FGbM1A^OSM<AZ&U-9@
4X62f4I<-H01cd4<TK3_MOe@2X<(cUT#YJ]4H]Jc4\1GINP8I3OPK4:=d_UK=cK;
]N@@LB2S80WI/;?:T(\QR]&26#b:E/UN3,LAG/JVUOcfLOf&UGK5(#MDGDcN&DK;
:Y]KM,5(Q88K,3:d81VB9IM^P[ace]<<Qf=N^1&][Pc[S)J6QdIK<D8g=SS0TU4@
.]6Y:.:/(Q2PK[>(gN-6==A0SIOSZ?I0eI3:Z8>>7(>.TE0e#ODT8Ye:@Y1FS<-;
(W&g95H)<GG&;_VQR-+)QgJN>\2\cE4dTIEOdF_A.KH76D6gO^/YX8>6IUL1WA5I
6VNGWA5MJ_\9O<f6O<0IQDZgdK&:-RT0QC\X>8fUS[g-G:58<CgV6d0@TM<[H&#I
P)e[;<Q)IT1W?:1B5aW)4GLDHDG:NRO[HVK5SYI5e[JcJcbV3RI46H8C:A<S5E?E
dZf.90Z^=bO7J-J/@1gL37@EXHSPP@I@^^R+#6&495;P1gI2FQUQ(I)Qg/f=<5&K
0DJbV[/3LbfZ9;7e86C(13d:T\;Z9K#\>X>[QQ>VeEJP4fCSPMC5=L>G70V]IF96
\>JJAN+7dN-C16APRH.=(F:C9\+1c,d+UQM2gJ<SOM\IN7XNCeK_7B(Qc/]T_eN;
;gYVL?<H3]5Cf^^aKIQQ-54?+5&M_]YX<+3S@CJLGGR;OGA8f1>a]&L+eU<7eK<8
4P;YAQ@2.g#B.Gb1^+(ed/<B5G;H2T(@P;+[W]E<R&-W#R,Z)=Z=:@NE(Xfaa2M>
#bS,7@@^,\@bJ:?0?(O,\:W>GL;;Y/+18O>A+e9WeT5eB9FIQ&?\CMCd[MBCPQ:g
#(@d&:[^3\4#?W+UOEHUB&PR9fXaJXB9W?>JfeI(#LfG+Vd]b.[21GD[^7?4(+FV
4R:3gUEI^D^WY>35#^WbX4D>&KXWF_-Z+H,PeNea&0I&#(Q\HABU-212]74B40>N
<Q(cPJB^H=-fPc<d=;B;&+BM+QL^0AG9fX4]/SJbcT&aQMN-gQQFMP+IYe&S\;3&
QD(_H>XLEHK.[2FR\?2N?Y57O6]S44I8SJ#Nf\_Wb0OfU>L06.Q51NBB7-JK:DH(
>NE\+SU.V5YQ_L#eb<E6D+Y3;XeZUK5;fM[I85-/PS(E7b5_TA2X3;=KNI+IQXI#
c)1R_5570g^D[OeO.cX0LU?C9Z504CQBg3^eO3bZFLC&J/b?8N#\/_TQYY:RfE=f
GZfF0N^M2&dT:ROSRVdNIL0,(9VEEJKNKO?5a2(SE?^7K7Bg]^3>RLSd>)9HW+R[
fJH8g</7bU?Ma#3Ef14D?<_C?,<gQ.C+<R#)9_QBVU&bOXYC)RF,RJ7TAg.W-I(L
.J?1H?E([(MD]<T>X.[NZZbcM<3HJWHTGaaYC/FFN@)0NfQFaT\Qba]EBLSCPJ6^
RTcf\-#ZB&\RO<V\QC[e#1E^8D43fJ>=R]6UZP(F+I^J@2_e>3@AgVZ-JCX6G7gM
9AF^Cf_QNPVH6C;FO].^O?T@M[0LK1K0V2BT(&KBfUH^08\X3))D\B?ADR3\b8-L
I]7IgB3Y@B_5K&#U5V<<D+6D1K)\,A;<LP8V5.<b-._OMZ]@<>TSd09YPYWUD3a&
5G5=5U;,aNa3_4--d@I14FJ^I1.Le@S,dRV>SK5T4O#>fgCQ#K,^cTA4-Oa]SF)_
fW5_?;g8Q\BS?<G9fEB9bDA;53/Bf&e;D_QV55U;R(:><\b&S3I?6gMZ5A6<]D_G
,RDV:05(Kc_ZTAQf7G3/UE6LVA60CB<<TPEIH836\7cL45EN/4VQaHa&T98Wda9-
BB8bC9&[(Vb0a)-P@;d9R-f_>,>;&E)dSd>_SZ+]Dbf0[C_N;gbBTd,4(RL6BT6J
]_,9=E[N^<)BET&ZdfQg+?TdWSO1JS[TRB#IWQBPc0gI_0I10W.He,O(5(64B>^&
,Q(2ga0)8D[)4A?TBEF6[-#:F,&4BBV<#>8P<C2eIV.Y5A8/G56^M?PK]]N__ZMM
g9&#Y@9F3;^Q>U)>;JDe+dY69<H4f-5:(YP+>Q&8])DL2b:X)eUU._J<X08>G^Rg
U2Se4K#_R9(OA08N?3Oa>923#:0GK\V<ea9A9E1G(\6c@2P74#=@g,/f7SJ=WD.]
V/aL_8S4?6SC>@7MF)&:3K>gX;gEX-OX?U?13Lg^-;8.\3LP>0DX^,LG5ZJX^bDg
K@S1OP_]G9W2b3(3H0.#36I6QI>;+4VcXe4(J\JG1+_f8@FfD:AX>N8fMPG[WGe#
\RGK>(;4g0T5gRZ,5f,Ra\^/KgV&g9E5_JWZZ,-5R;3aYF8P#3_ODBW9>.WY:WM+
&HGWg.gR9QODYIUWL(?]1S_&T?=;SdYSQ&WMb4?[Y1/R+O>^,.H[^(\A?SQ)QT;7
X)0=Fa56&f2;W[7QG4Hc-eOeVZ&0J3H/8/^:/,2g_OUE<3TJ>,)>J&U?YM8Y(K7G
aX4c&K([\0E7FY(gaCR5B()g-<8TP0dS&W0FQ4;bVMgZNA0gKa+/_N2SHH/G@-?]
(N+(-ASb+d1>dL,a/X&d,[324B_G6HPOF;/L;BD2WggN3#A8aXcCJTQYG9(?](f:
9TAg)#&dRS5HY:R]CDeRWHgb\H,<=M(B<@=@;fP/5cQae;&F0VY(8L-0fOO^.)D#
90fK:X_aHb3>N9F_II?@;GZUF^?(E(<>.OT,_62:F5<1&\T97J8dgaP9eKYW=DBU
TM,PT_R2AgMSMTfb<0?^7g74O(MWYc8EP_H,9<M5<XN]_U&MHQXY^MFV2cEF,+dT
4_V94283)3GaN/=Q]>0?S6M(>8:QCTJQ8F(-bF;2OE/#Q+B-JfWZDVc,9O_@+/-O
<,Xg]a_=E;G4^UaA<]a<aS_ccS7-ZOSONU6[ggeFQ1X82DYb.d&(<)^D]1]&B6cR
&_ag?(-J>3g.NA)\Qg(GQ,74Ue:31DY5R_;<N5A/-<MR>#-_)Za/10ABK_J8=e-V
?0-1?/dCILDQ2-8aWg5Da_#C2TSE[aW-0IU5)KHfFT@#[92aN]_gU<cZD4NF+2^/
+,0KY-QeFOV(:PAB:?]0g4&/Vc[-,H[\N_,d5M-M:K(HI(=U8f;XB62cL^UZP:E?
K;3Mc.&;e@d;CTggET1;@+O[S9D/+[58?)GBOU;3Q9#]I=1fN#142KMB6MSJd>fC
(a6,19&97B5T,2Wa6VD,aAfL-HRFPRKS:cAI\C&[E2]<^f0N)KAKX9f9252:L@)Z
f6dIC-_bC^L+&09e74b#Q[(M>e1/CA7T8X7>V]dYM[0c>UFdBVYD&M46+K2MU;=D
4dBd=+53THgeJ_NWCAXKAWUMM1JF^Jb_Z4GBTWHD8FZ91f_;OP5&bUCb0C:NLTA]
D(&LG/e;I\g)^V<6/]GEcd40V&3^<XJU3^?K.7IU5eeAZ3/+:]+_<3[TT(9VaJ/X
X#RZ^XEJB(-4>550YXcUWG6V[4JUEY7Kce4g.g6E-)85T00E=TH169GIQE)MeV20
eb;IW>7GXVCT_b_^V[CH+R=fKG?176<8+)Vf9O(],]:KY;.1cU&>.V-V2&,A.G5H
#>KP8Z9\8K66OLC0QTXA],(DUZ,ZcG4:59WGZ<R<R;2T_ggN-O?WL93@Y#4=]=LS
25BBe\:V-64YW\64)4Af>?@X:9P_L=.5W&+<P3@PCY1?)#^24<P7.B+19/2JfaNZ
]=YW<5,M&I4MH]\fNJ=>-R5gaUb[U3E<f5JB4CS14d0cFLA-HcR].S^)7&16:1KP
cUeI[fgdFN/.XZ>SKX68f=@;M:bg>4NAfLE)aZe6M#@M5P^KXdK]^_)URXCD[6D+
1FH.4CO4+C,bW&.^=e/]-Q;BVH?NK_28.S=H&KcX7Kb[G\LI&?IacZfMC1NFgJSF
92N]/,9M[\7Z-Q-[J(,O/1TY;BCEY2Ad7\&X_UabE+:8Rg2@N0.ac^;f+_gHcGHE
]4S;c6+d:[E-B5IH\K<aI[beA<NKF#aV,U4AEX,BTW9O43W\.(L3_P&(=eBFOA)V
#=e7cA_)>L[e]Q5I@G>Df3)NUMJ:4MCF@OagC;C5D[GS<\3EV_,[4W/U^H,5a5=7
=U(+HR0A8f1E48&14;O>A<INbgY&8#MJD=_-XYP@VcV>\,g3K#0QPUgf9/gEK4d/
4&J-MG97R@K^9dF,Yc8Af#8,SEBLXLc[-NEIV7:8CM^>6O29GLb/9)+Fg39:#HbO
H#4ID_0Aee-[&=fYGYYXN9E1Rc8Z,&F<9=:,c7/E4S(b#I7d13?B?O0);b8EZ[]R
7QYa<>H:CNYK#g6U^gQg@TT&[<]3:cZ96RS8#MQ/ee:GN4,0<]QfO@Z,^X:IVK.M
ffIWZ&GJQE@;TO\7Y5WaL\fb\N,Y?6J.(aE@dDCc4b;TS2_)LW]5>4PADQ)<^Acd
W@+0Q8OI<^N9ZIgI7g]RCZUa#@+>cbN/:]fJ.B79I7I,-1(HD&HI[-VX6G&2SdT1
F63E)YM.3SR?A;W+1+Ha4d5c(?#4#LM=?BY>DEBS,g07_?,.,IfPgWRMH<[;3;1-
DS89AgZ.H42;I#KcZUQDd,b@F[][-H#10Q^\/bZH.P2G_?L_/XX?Z135[XPS,-X3
M(VTf4FUVE@RCQdcKeEeCX54[cHg^KC.U7EcdD9b92_./36/4\ff8K4CFRP;b5<B
397&0RY833S7L?BJD.L;ZeRC_AL-CC[QZ(f6HCdeR&HR+RdSJ/5[b3fAR@d.;RJM
ef(QSU[6ebgfKb6;,^8D,DKY\>_Mg=P=YP_PR+&A>R_a-I-JfOA^J^&,PfWXZ3BJ
EA4a4.)?YBO[F3^;-:>6R+NQH9P6.V[Q>8W40+(2e+E(NF<BLKVeIUH<PL#,TbA1
@@7EP^Tf3-=G.D-6g=8BMRR8G^2_[UE2R?6.QB4>EHJ,+M73\(;GH/Ic8DVF\CQF
c3ECeCQAZNACCXYDW/)K(bSG=\FAg&COXE4X2BW2HB?VQ;Cd]ZCW2F1)EA(Zb,S4
g:M2Hc49RJ^2?Z34)L^,Nf3XHG5+3/5<]6=^,E,,&,d+HC2#WMIbZ:<[AfNJ0QSe
>B)M=B(Z_JfZ:XRdALYW5)1B])^Xe_0,I:A.MI@3UJ@a+f1c>&#/NCe<(Td0/-J\
>N><>ACI:>Z(LB6g/g9C[g=U?2d_9MZD^aK^O_Q_=XS9W<RYF-2>T,&7Ef.]#MR^
=QfYDXF,^VM^U/W_)I/J)&8T79XEB)^#gQ<59[NaZ<G-^W?49B42L_;#A))\8[7?
,R<+R&b?[3[6EU?e<MUJ<43CE2GSN^(;]e#(=M:JMS0&F)1Y:/LW3D9D\ISTMJ-H
1RV;gY19([E-(//ff5C0Ua8^+@fK4=UBUF]CKJdW.5:VHEZ[@J,J6f:\)eZMA,LA
+G19:Id0=2LLZ30Pe)[]U8Z17/8R=62)gSb,P]Ie;,+A149SE_a(>A[5cO=:c2XW
F@9A2Ng2V]I),>cSY)6C(TO<Y.HAg_FeV-L>[#>Ac9H[@3]\D#Z]OTN9(:)c2c51
c]&4A>+2P;P(;1),(1TF9G4&6H<]ec;3?1fAe)@eLYGc@:8#]&6MO?C7/NUCT.-b
f1-YM/(/ZZCRPHKEP,)e3(aT1#U?-GG>g,:D&K&C++]AQG8+4T^V2?;1RU;Y[;F]
5&H_7-NH0L=If.C=\;5\:MA9J@N^bb(P3)#D^>ZU2YQNTHBY#;WIIYL0UW1C_Q9T
<TEM[c4&2,6(5H[fJ7WKDcH-[;P7(+]BM7\4P_ULb[6:SXJEAF(gP5402M7_@8gR
N.0_dbAF\ICJ?DZd&S4gbGc3=EL6H.g;a5(fX1+[\J=T-JN-ac)W<e+M=L;O1?LB
GFL_Y6NS<E0#AS\>A-3O6^_,+9835W:d[g#0:3)1cUVX,a2W>T(OE6Z76BAd/UOJ
(7@WPY.#Q]SH1]D)Q;UW,()e8X(<2?MeGZfU+(/6,/L+0\S=P1[700K1E.;bITeW
=/KN0KcBg-V@.fOC8;(6Rb8<O?ANZ@^F#-^BR&F2F)3ML26e-gL^LbO6Q1MgVe8e
H(50?D0]TEZ.]A)UA;c[gUQ=:_L]L;.OTRUf2;>NSDH)@LNfd9=e<_H0>d2Sgbb4
_.?5SC-)5CESRS-IBDT5?J./XB8MTJT<])HQU7>eGbX:BG.4e\)KY#XIB>BI_<@T
,GY18^&[W<aS5A]DI./]b]\DC]V#_a=XR#c04)1(ICbg3Rg-6MA#0,<g<?0[3R)Z
Xg<+2O?=Y+.7aXQS9ETJ;Y\XgbYMdb,eOf=.]P-MSP1eBg#<ebR6EDcUH2=ND.Ac
B&,AY=,^Q5P86H.;Rd@]Wc^fF1855/XB,9(;XBC1E&35Xg)@O7fJ9SK:)NXL-Q;N
][Z+K?,KVGV+#K\fJ[(G==?NHC@U.&)[40LVJC,McOJT)2(-MQLLQ915)TDSR^U:
Xb0R3AYQR&NLLY;>_SfQIUUc<:-I:7M._a7?,ZE1e?\;^eacU>&PRDLf-TCDKXg:
N\dXYI)FJbcH&TVR7E8f^RRXK#MRXW,R9+IPWT6C5^S8b93\[61=@<g88#X@8-WU
/D\dESCQ4LT#731Uf#?d;:;EW4-9A79OPHB=YQ/G0A9VQ/],:R]-CL;1R#ZMO@9Z
9K[D&2SQVXADC/N1;K>X1KZQC7.ME+^RCd)4f9_/95eP>(@2ZbTb_A,U;QMe>cf3
5&7AO1/5J#<gUEC#A5X1\TO9)E8-C@g>7XSKO61E1@[3bb<IKERHD[[eFIYG3R6f
Q0Ug(3Jc#<(?-:#&F-D+MD/KfO\T(Q(EN_)[?_;O,/8:C:/#YXL-#@<H)Y1S/IT/
=:Q1a_FLB)bH.>eCMI[7[O5S?gPe5,QXF):)W&T.C<]\M^=RM3><dA=W7V,/61&a
6[[,;B5e-BQ6UQ),EN7MeDf@f[BBcc)=:4_ET^M1O^1f;,ZAJSF-QaCA9QKBSS8N
cQGE6VfP,NYG1F03<T1+SN7Qb?]E@PfcOU7=VgOaeC(TOFHYRdV+QcT[LdBYd&<R
SE;[.fLL5]=RD7V4/^/WA<.)AK4cY0KELOb,_5-L--I-TZf:1<.]&G./\#-BB\#A
Pb1&GaZ/6_EG1XGXfH64>90@RW2+U:31Cf?0+H&>YFW,d#Rfg@BX#G2Q86KBUc26
d+cY\9,bKS&13Xag]:0#7>e-\UC2d2KXWaL^X3#a#Y+Q?IMHR\KY.X-)_dF_,M)]
-,1d+]P_GPCK7=M#R0,OfAd7aDBbdE27-Ud3D=G2XScU;0/90[@22,Qc(KYX5B9=
7HZ4D)OH1@8]U+MUb9E=^7/_6^-3GQ30+TIC#)CVRP)-#C0JTa6])Y.XF+I.X>Eb
I[>68H8(SF-aTG6:g(]6gA3G]6E&19PA)YC\@-D)d5#WbMQ_:\G)\)?LcaMG:^0C
@g[BVb>J6A#\-7&JPA^eSGIdUNA[[^gO8(3:F<B1aEZ??RLE<LG#IT8HV\2VUbS,
5->g-MD=<TQ\30O]5NT\Q9+Z2dW0=dJe&-:ORQ/_4M2JHWb[>[\D<TQd<B<Dd8VD
H\3JK42c\)O;:\ZZ2PU1E7JFAS33/\Q41c@+cWDa8<0Rf:-/>W?Ra@,NKSL,bUET
>E-\;T+2)B9Q#7IPE2;80WM+;3;_Z+M=)NPQUd)5>F03gG6=^<fcg9>;RX,5a71d
&3M#G3_)D(H0GY@[4[5Y<?62M2&,RU0:1gga]XKKQB-;^UG7TRGf?gX4DN5\Q01F
<Q;VC^,[_BRUb7@#@765.0<M5+UeM.BbaPY3UM+D26;a3ZLA33V]J[.4/2@Kd;cS
;=Z=,;@+/Qg?7PEI6[Id\TXJb&GZ^V9LR>LWHLRF87L0K_d#eEPQ2Q47X>N=NG:M
AVEcgQIS1:0O;Af(fdQd&(F9)71]6#=?K43:]#fQWNWT\AW4VU4@LNU?(fD?Me63
M4?dX[N>@P54[g[C+XGYQ3JVRN-c][)CKN@;G++LC88QbK[^9HAcA3#5R(J]eLfN
,L5,O5I=eTXf:ZQL6;30/SR1#W1G<LD@Y<>Z9^)VF@3IZ:\-6[;Nba;J?4.UWGT>
]a(b+;F;PI6NND4><fB>07fgg9C]RR743U/Pd/T3N.LJ2>W+875B6WSZVK?3<J=b
U:5HD]VA65O_?O(50Y>aR<1M?QTC?@AM#@R0d+EQ]\Fg2C./7^[?04=@IAWdR@T^
X1N6,8O#XZ2A<2AZ?9:W#ac@e5f>OD=gfI[5./aPGRKNMHW.\e[A?e@^1MI[=cCU
BG+LCA8+@6YZc<CF3@0>00:X=/>D()=@^.282]Y^d2<==CgE3YO38/:E)NM\LeWX
/cd?E/PTK:#b,>fSf.AR56A77)P+@9/@;T/dMEXISaWdY;I.5A];aLZ-F(Q#@O@#
223.4-Ee/CP#NJfO=^_1e/B5R86EL9OX\XI(DUJcF<QZSFO],f9B4\BQDY=^P(ee
1^+=@L0L0/9cRJc:],:VMdeJRZ:V)K7(^AEAA0,QTX8#BfQQ+I#7R_ZbM[gEOM.V
:[#</L;5S]3geC^B.#:<e=cMQacIYB<;00;g3-3FI:)>-d#<f[GGHbFZ2;CTM?,/
OUgKB_c#a(P2gD:MOg-cb2X\,<#P]AT=[ZW651=@&7KZN)g=ZbEf.&@9:XZ/Y[WX
b_A4@Af<6aI=e85YZMT0<R@T+e)J5HU11E)/&O]1/=g-BF9.>[RMW,ScAQ[?1^\B
,WXZgEL+;(-644/,M>R29c+YQ6?eR:TZ[RO+JEP.a0L]-22bM:#WDNX4QP;.EPP_
HLXG)7#c3UM,dFQ:CDA&dV3CcYBA_GgbN;d/4?b[ZB([_Re8#f[S1=#;N\U.-/=^
WSZOTF5C\W9,ZT:9eCWaVKd6IFbZC(CTL4-Qf<Ncd)B?,^[RPM0)6TDOAR/1>(Hf
a3RZ&UBM;&eD;->/1R9AHU3GXF30E#>JEBR+.A:B=8dD]Fa2dgBeU16Ib8,.B-\b
C:1-J71BC_FU:-V.IcbI0^R.Y]C_AZ&CGA/Z:db4M(GQC_6->::@TV\M3^1)_OJH
4[d:dL3F6a\KXG5g7V2>)S4f&adJB7=-gBgIbc#LCXc@&/,,F_KFN/43&LP12+WL
&Y+b5R@6V2IMU7,bWf<^U?&Fd;Hd+W50RFK,[[3N8fDVa)67JM26)S_DQM-Z>/U@
\DGgga7f;GfWe&11Fe+CX8)Q.Q93,F)7e\)+cG1&cH>4F1Va]gVeLV@^::0;>69]
RAQGe<2QeCKS.IM^P@Zb94U+>CK3.&8,RQYN3-5/;>[2OO3@N^SF=\6@YDU,f?GT
=USfBeA?e2JCU8(4:JBLQ60U@:L@,N=-dBK3(2TT4I;B48J.Q)Q)9=5S:3IQ:]OI
JZc9^8O2-Cd@T<Ta>,?D1K[VRZV3GH7Z]dX]NP?X\-+97+YU@W6:=Iac:;5e1;=^
K1:PA;RG:QQN]e@=8&YU?H+;5^;c.SV)=>4R?e0N_XEgKV1Ce;^O4P3=8&KN^CH;
K;M=e@UE2/T&)/].XRM:#ZCe5AcHGEKL.fA2#9_VNT__fJa5^UGH?@,^fM,[?>7a
f19;XbP>R@ALT,&<2Wf_?8#TU<Ag:(<fTM43dIE.1U@C7D].b.S]fL<NPPLN..9,
dD548W16SdZ^ARC(74=2A4,eID:Y@-6BRBfMQ?4g7CUNR\fW3X=fbPIU=19)NPV?
9JS(&GY=XW_gH@^XR)<Q<T?-RYEGgS&QT&HJ/Q@&SXGT]2^F,RC5fc8#8XcDf5_?
g/;4:M;/;X:BR-[3OHG=I5(W6QZ1cbD<W7ZCb?-L@GKg,\ORbW\RaV/:;L(2A=I1
D@Dd\KZDDBfN5TS>OH3aS-ggeCT])]^8QKQbEK2WYB=8Y@KIWB9QUed.L5R,<-QS
_H;fVN5.M&4CH(&GE;]CJIW[ETNe\TdQFY[7]LF3T@Z5O((Q[T^LWQ4^2@(K&\2B
S1<5JKDGI(&/[5PXIZE6E=K\e\.26(<4gWASJV0Jc+@\eD5F](@TJSBS\cNGL=J^
K6KAA,P7/XK=(#3MV;KOYW42MOPab[A@9,-EPg_7TPFN^6EWN(05GH(PF)9d<QN@
<9WD0#?Jd2,;HIReM(BD=Of6(fL&;>bFKF4,##GY6&W]U>Y381UB2.0+0b5[]=R]
#_1F,4DUL:eF&XdH#bK>e27P.#4462MKX[^K58G+4F7V@R)<;Y_TTAQV#?Ra_a6Q
B?:d_Rd(Y4MSQ71DG3WJaMXC4QVPJH6-:<@4EJ1PM46N6+(2O\D0FL(dG:aC7O<^
9g[fN]D1M>g/8;+:b(M&AJ4bZ[7U<K:+=[)438Qa^:^Y/4;_Q[DeYZWAT\MEXK8T
L9M+Ecf)a4_gNGK6_?E5,K.CKIZ9E_J)Ug?/-P<,,5V@)O18cX#g9\7H^\K,K4CI
MY:UY9X3(S_g5c\M&NAGU]+34A:M@IVddTT&37gFf>;XH5Y&5Z&;IUA?[3#/DYfS
fV@S73W:^3:UGS[]_-3V>09N.)b3g_QISd4]X8:N97?<:Eg4(ZcQc9T9_X-@1a1B
A;#dR6QNeA30RBS]&27P@T#+6H#J@#PSf&RO/1)(+Y7:eQ^0ecUG.C;(U=)B1#^a
OU3-T?CKSa<E9IGW2Jafe9NBA0N7\?/&Ob8N5ff(3geC&cYc>]K+gWd@YYQ43[Q3
]L96\WV#Q&2&:1NX9ADXXU+OF<:>0^E]RBK1SULYSX[bIY51MK(:=bg<@LS(MOf9
VTIdgA\6S6[T/6IDMSfAc?C@9E<YK_^,DfcIAFCOc?bYd\McE58,_JF>edY-\O#8
<))Cf[d;Zc?K+-A=LTV(]D680)1.K/=/^A<P=;(QSRX]+c)5?gB&6W)#Zc?WT+BL
Q??HdYR&OE.=Z_,c2[]Ug4)OIKKEa4cJc_fWOU^MO?+\gH@:2+LYb^9EQ-K7[?40
SG5)N?2YMgD&5,Ja[015<g7T/^-HOKY\ORGgf;0\JCZT2VV[C9HF9M&+Kac&61Q^
.e)G3CI2e5?_&Z;6HS^e34<dGIMXCVeQMd;T:P?RC&Yb&ZTQDQX.G1REWX7Bc^A-
_17?3<=KUJ7H,YT93<MYFdO93RM)26FcUD9#HN,QM]5WQY@;:&/-8D>1.8b9.9\]
a)YF7d_(Xd(W7NAFc(106<VE&\S1@]>KW.gJK/MdQEQ2NJ7M\T:B_NYD@X4U>EYX
Q3\T8a_,IK.(YQ_0WA/VBAc=?9T]U:XC]_0.QbgG]^DMcedTR+cTH9YK@gQXY\-F
<TJJCF@=K2,bObaB(X8JP/40ZA)PWA^A>S]ETXLc3TO?4;Ce68dB_2@QW[4-4^4N
IYL/_;=a.6WR6^P6@5<78-Lb9UdGO/bFeB:-?LOfQ&4Q>?M-+/gKgNWbCJSbO<4<
VFL8)K+b-EZT&,g/I?8T&7cC@+AV<)?F\O3=@O6=?R1D;+I?O,HH\0?F_RT-<d_5
QFL6g?ESQS=L3??)?;TNTfJAB#Wa3L#^)/H5Y)<O;T<+[EcQ;P6+g=,:#1NY.6YM
E\DVIc2TR>;3^2).d#)W4fGZfM[1/;bKABcM-/T,W#;#bbM#W;TeZSb8ebYfNR/6
CUD.Pa>L(3X\B2Ze#E.CgD^?/S;<,(B=;@QO=/=UcW-A6LOO./a]&<4RS-^eL0X1
(NGD7e4L[O;+dPVZ,7-N,a6;KHF8#WJH.#Jg<Wg):Y8)7b9JD9G1gKZ?W)/C\3;f
1@dH;UcM,]D,)E>JGXUUZ2K7LJM9IP-VL6GPW6eJJ2R[EN[6G[#ed0LT4H0IR@B4
3Z8(Cd<[HeLKH<2I&e^R5O9;AIeUK8._O,eDOf47T\\We2?64GdgJ767)6X0);-D
P=/>gQ9Gb/TDYYU1N\-Ub6Od&@@B2C:<I;#1:\<-7cS:H0BORG(G]7U)]>;8D\?+
NF1LV=JDeNV(1O663X(VC-DgDTU=b6O(S4A;\M9\J/HUR/>?&[a&\XOD.&H2XCBC
M>0=CG^Q]2?XE9]<,C\U^@@gF@D9,eUfDKEU)=Z_\3DV8_NTBWdS63S#/U&+WYC9
:58WgG:.6_W8HPA.TV^H-,EV\@4LKd86\,7GDS2V,^_gd\V7#b]VY?;M)X<ANKdD
TDe8:#Q3BOU_4YWb_.dCf7/F<e>a^])MJSE\PN]eFE2Z@YT@F-bf(W]^,MM\?a3U
A^c;Of:g+=2XBcY09Eee1MOg3:F]L.]R/56-YR#O6P;?55[02MgFLg<IUFV[FQ@M
)L2d1AO^fa?/bgBR8.BfRQEI\4QACb3+81Xa2HQdV?JaWNe./?8(LQ1<LE8_#NT-
Y]GA8V].1-RO3-f_(b,<e.d0R#T0dQa#cb8#Y+?[KP\U#+eC+NYaJS;[820QKG53
1GUS_D].T67\<T2LH>2;WG7Q>+##1D4Y4HR&cA/(FW#0I^=[WM_5M1,>+;b[5K5T
.U[1BY<^:WM#+7XZb5DR0@Y\/3<6T4QAfS=A?):a7.S\fL/MfgEL@IW8<HEL86f@
[LLHI([YW)WZd_,_L5cCc8R1Mg;OBN.f#(dL9V>7RV(GJ>2.>TZZO[eNgWU.4)=_
>=MfG4NXJUJaf,d)Y_@.gIY)>^G_eG@NcXKQXT<M.;FH8B646?Y.QC.V[g<#FPb(
(BcQWY?I<27a\DN5?I+:CRcTf+J#>\5>CFNAQ>(WLU)BD=WXU&d5).-Gg;LIXYgB
Y(;EVf4AP5?)I]YgEXc4?Q@/M>bAb(9>6#_N#1W-\2__U8EE?1U(D_[DR+.ZcggJ
[(9IP76N5AdN+XIS\KZ6.\VH9Y)5gN/X8@R\g\ULW+=fP13S.MLMSK:07&M[#Lb[
/Y97KL@[I-_]-R@KV,f382O8@G4YO--\80d[2GgHZ5Y;7?QO;faDOdI7Y]AXbGPa
>2GS&S/ab\=1OKNVEa/f^2^2a[101SVHY@>b(MU/3G(@5]Vf/E7=CC\J,f4d?C;6
@2_0<Q4JV<TOTZaf6F^LTa._c-g5MV6a-^f.G-TGb:2fJP:XgF::LCR)A3.EBgE)
F[@)PY\8Y@XO3&HW301ILPggAM,\R]=A--+&>a2/[]KGP9J@SKHcIRSMKQ9SPe1]
^.69\P82+/C,DH>f?#J6\\35eK#X/BK2ZE/;\b#6A>Ae,73X.e:BG\d(_gIMRg,=
KefI,E)>^f\e(KI6Y)6=BEHVe:9;\AUVL]Z?QMSPH?/We+;3FYgXgF&c5C_?5++<
J&@5J]UGAR[C8PNU;3()@<^@d9E,ZccS3<7>I(QWI#@#QPRC6.LQ6R4;HZP3(g:4
fHRN\.cB-A_/>@J,\RQ6#FO4-C7NU89#Z<?(.?.\_K04D4[6@1JgD.Z.\L.XS^)b
<&fDTOB^>08;@6Oda7=DaQ[@(=8?H)EG\Rc6\DLM&_1@>@?E&cJ^CYC(8-WNfYgd
QT7cC]X7MSAGY9/B57>9\MCJeES\EeS:3FHD^D/QZM:eb,NB>:9I]37C(TUDF#Bc
A0,\_LXBQ]3:U(cHa/;JWP)F64Dgbb8KIU?=494fCX\4ZI,U-)P[.(1+R2.>-a+5
aF,TI@/WFAE0.APC/JRCO#(=ABcQQ1T2Z1SS]UK&aD18W.C(7[\b4:T;W;,b\BE6
Y21-dI41G21/#54c\F_D?gJg<O[gf34FGSW4e05+6TL6=(CWE<X>cIH6LT3NZP(d
.OYP:FE3R9Z7UWEf5ZVXC.H]#EG@WUL3bdMgOXGGU6H]^061G)CcQ-5c?8K0]5ZL
5[C=Z^_d5QMc9V?RNAENO94Y[^YZ)?7S^[VRGe@eQCT^\^W,O=;SM7/-J5H&gY-b
dd)E(5OFCXcK-O^,[L8(]G95DUC/6P+L#b?+TSEKH(FU[GB1CKc#DXHV7-Q[2[8E
?<d7F6N6;c\WG#d3=1YHX2C=8/U#T4)#Ye)7L8>(M)gbNO@#/5+&I860LUc=+F8V
Y,T8_J[QJfRaE]S/4]V>6KHOD#(UUO[0(Y3\U/d_<ZVPKP(M^aW&dAS#^bcebZc8
[+F>&9SEKbS;&KX8VJA0DT])7a,5SE6@6WX<AGMEQ)eM[,@K:NC-IbL;,Sd<?2&>
DKGLb3YY\)JX_JT^@M+dTO=.J,(I.-Bf#,Cd2E11(X]J-O==.F2ORYPQVDFP5LX,
>X#:B1VO./4+&)R[6e+6_d.T4LF4^0XS<[=)74PeG?]+SG=&[]ANH+g3I^a;+P19
fOMRF?,.aCOf0fXZ>R#7+HOYc+=<,3CV=KHG]?=P;E=<W81C55AZ4=]4@N2+H@Aa
)]ZCeI;b\0]A3..?V=F?Se.495SCH,WX;YV?RBP>3-K;RdQeTg.-U+RMQ7>/Gga=
2Z1]E,)[9KZ/,5OYWQY\,e3K>GfLUL,XAK0_E&3,6G8QKb7dO.R2dOIFHI6+UE)Y
gXF9-83(5?7TPE:;D,K4DeW_YGI^1=\V+_&ID[@]/6/0.Da98>gI4C80=>1]d(P>
-FaJNFHATNVLQCH76<6Ze?f_:\JC+2O\&H\W4#b_CP\e96/66&cRb77bfN8UQ,0T
UN((dc/+5_/g/;]LV^C9b59,=FD:_VR>Q1<E&/+F:ZEQLW5a9e#X0\da9T4HAS.?
Oab,^Z5Rd.2&NZ2Id3D)LY7a:I1.E-=IR61L33TP@&dH,<X.ceb_RU(:b5g\JX@G
dbNgc^-0eJ/)T//-</93RT0B[0&AK9OW85W=XH@eI15)47.<cR[X];8S9RAa0)b0
ScIJgTOL.W4OWS6W6JWV1JAe:+2Gef6I7<3,@_0>f/\8@b;b<CPDcRM)@1X8G4=[
N1R)0OQ8a&7X)I61G6;YfbcBPV0e4fA(g3AROBE_UAIY(Jda2gD]HSU555&ZILW1
N9V<SaD[d&Y_-7O9gSOG#KH;?V\C>(W5L_68[GOT<VVD(I#-X90f=I@cI^1S8.@A
-eB1^37;H47#DZ]1WE\1RQg,8d,-4gE2=TB4\9E+1UQ9[Wbe+VK@aLG[e<D/A+(L
2MG_gf(2QYJ8;eY[HA37U\9O=Oa<\f_E#N8(SFR;T>/:K]TM\O\5S_FY7<@L&fU8
.=)2eP^#Nd7E=9F0KaA9ZeXOXcA[==([;<9>V,gTb8N_ccXa+SM-fW25OOK2dYV)
]:d@1AGDeZ(&]2_X85-+^9>dW;UFYTUc@ZZFdDXA_&4Pb9<SddIA8bU9-XL1BKS^
D1_C[XZEb<O=-GF)0MPBC^AE)=;:a_VN2DFYeO_&BX_?5eE43LR.T.V(-Qd<O=]a
?G0#Z[\@&[O8KBX\_;,R)=0;CB?5NCHd(8B1e(Wc9S;_)TBc<)dP7LD^Q,]Q_G6^
I^OA5GB-37FT_^63IY5H:<WN0^A]0J-,@-;.RaF?VTcVg3aXV4QJL+#(@/B5U+(M
.Z5,[#O5g5T,RdOCR.I9>3B\N8SWK,WO//5P&dVa=G@TWV0fV.S,C@+C5<A7D4eJ
bZ6]M#2-cQ]TCEY6HQ1URXe1bJ@da2@YQ9^,>-#^3dL^LF,-\:\NB(V(fAGO/ZN;
Fa-/f)B931P&2aEQ7UUcL8BHG]2W4S+C<-747?MNP>N<)D5T-?I(&AJY.>T;DH:Q
45([1]9=3:C5NIbQ^0VDH;WX^EN&,50Z9+LHc)HPIML&,?D;2JWG.)#5H6DBP0GZ
1[FLf=7Z2@6Yc)[63+Y?IO];gBcd4)ePf.\G<e4^O(dGE&S9^FO>\E[dMNT=&b>?
+-NKGK92N<6E9eR;5U7b;[bRX]Y&A>=GB/2+LU:b&&U&;GWYYIf&3P:Z7U5f0K1c
DbI5]-SgL2Q8T,;AF/9<M7&/:.VgeaZF7=CC?+2<OYa1K#=9@9D6If)41Y7L]@Qa
FJ)#8V=N9\Z0f<DNO(;PD-([Ee\g@X#O-&_6f<8/;2[gUTGg&&MAF46@X,=Z32:]
:PIX?&L/L_L<LZM9;1F,K^AEF^FW\M-C:fWHJ]RT&cGR#W#B,UY2#.RV)]/UWH+K
c.4L3M.Df&A7QE0?aJ(CG;4]0&LbS@T@(>d]V;:d=D\P;:EPXT^,TEdGB9(7(==P
H4W+/K@SP.UYCCegT;0[F)(f^g=^ZXVA<g0_8B/Dg.E.6\V1^-_7bEP9&^KUD?ZU
g,DgUWLNZB3([.I<RK\^K)J,N+/T=#3dFPNO2MK7Z>-9ZBCCT_S1be,\GH5\Y6WW
e(0&;#;<SXBCcL_:X^=-SW_MIN(&/c[DW(]1HfF2=/YRXC/bG\QcGC;CY[:E=T#M
]2g&EfBS_gBVJT1LCO:JECd5Hg9g>QZbd-e,7=&74[_DVTY#-VZbCNH>LU/CLUHa
IQN/YU2YgIJ@,IdSK07C60K6+YE6]6-a7\T:e5L9dY2PGVRGN=7IF>1S5JFc]LO\
T-&d)+?(I[Q48\a>dT&4aQBOLb09E8/:+2Z3D9+GHV]aLBOaJ=4=Z=(PA8f_J>[W
<1^b(][fc]0?KY^&8Mc.&HO^C1O>,:HBS>MM_d3ZaL4<YZV=.T0^1d5MQgLA>8aM
ZOQC:K7FD?(&VI4M>9e.2I:b.[<Z0;@-GZ)E[@GC^^S\_WH9S6b=H+B:e8-+P2NN
g@Zee-RV20N0dXXB1\U.ZC.=;CeL6GVD4K5_cMQ(/]fT=>:^SM]3eLOR/F[VI>UD
?V0<@O]Acg)7I/Mg\Q,<P(MCMdEO)A-\_ZY#d:D-:I-(HZGVSgV0JBc..T#GWQ;R
.AD6,\g/>U]-I7gU)d]SA4?dR4(+CW0^]abIW9+I43SaP>V79=eN@-#R]DTe[P]e
V-a[O^E\&&cQA;67d032Jgc.AP@0JGHB&)<Ca\SP7GL2Q4TC&1&;>Z=OKO<O&7A]
a0f8TIe?@DDU.bgNB9dF#(/SQB0_/DeeT:OV1[O[AVe_H@OLaC_\e5f]NV<@f78L
:K1&0E@E^,U.Z(;bAe&e]W,EJ_FT4QMI6c>V73OM>[&3(23T3(N_VYVaX#L,V^\c
636RQMS&-I[_b<=eUQ-<2:T6g^ASX;66K,Q4:-./YaS8A2dSgb6Fe9:=-F=E70<e
P@)e(<>[9/0gZOaR8MC-RY8_bS:0/(H,[HFF2R?<GM7YR2::3,SF;EAf+bGXN[#6
&KF4YN:/KgZQ0W#G]9?cI&C2]^]_F#1LKD2)aL-g,2dF.BIV^VM2Cc+7]SX>_,P=
31Q_NR7&f+75eSQadTK.N3BKPN<GU1Q[CR/58:NXK[9FK1^3F5Rd/8].VZ?P2_eW
2Df+fR\3cL(VXfg0<_Z;aR3GZ>Z-B8XZY<BO3Y5\d[-)[g5ge@D2J?QV@+,1I=W(
WM_/32,ZQb7cN65a=]O6ZJ<CE^a1?83(Z@NSY))aUS4XLN=FRU3(_ED=)>MFe:QA
K25G]^7W1HgRESBbXLXLK[&;LgDSAMDd4OTGO16.M;JI:e46_&S=0(2ASNaZZ/24
1X3[=>N@a^5@?^Eb,fd,<RBH\\bBBCRGX3][.VK#Yd[@GU(JUBC\D4).2gH@BQ;)
(52PMN#dE#-gL6eCDNQTA6-(DV(\9#g[>A_Z;\]]]DG<\+FXBW_C,]^GEY1VX8-0
)=J+I;OC@L7?HGaYX?eHX3e:bDR_C;d4fN-X0J3;34d/P#?=&2A0(d8PQ):ZQ^RE
]=X2AbISb]L(<AIS7d2IR4Z25dP2Q\FF:BLIgU@SDG[&M3R79CD1.^@_NgY7<X=#
_KK,A.4XJ&IaK/5..g/f><\7KbZOUEXCJ+Y_1M3XM@F_0HHd]:5]V>g#0S(RF[+I
_S)_Xe2dCGe5fab&RX&?)1RP]J1#.9-@-;/GeSc=6U99H1B85P2][bg>7E29M44^
LJEEbAG6K&I-b/Z[SX&Zf>;9G[E>[fKX[c,&7?FO]Y_^3_[FHA,U<1]UL1:75E_^
,Jee,^93>&TNZC6-@M;)AAS)&(Oa27=<R#1_:+QDQI2G3/ZE[)]S5Z9(BWT<0g#-
\N@c7UW)g\LD]Yagc_UD&NceL6\YTME9L(<ZX+<]/d(Nc@JE57&:I_1+KZI38/\1
d\21KS-[8RG\g4O9Z\KMGdZEL:G3Af1e<4#(W70:4/bH::0R-ZRLY&ZB=]>B;f(\
RACg:ETHB.>Zg6Y>7>U6,X[4fHJe9ORZ-\EX#OfLefGHgN#DK[C6NWGTGOVL9)&X
.\OC34P3P^=[G)R6f+C#(eO/e1:E3@Ve\),8;LMdeJgX:]>:f+973gR:OI&P58V_
f<ga.)E=+@9B->P+Sb=0VZ4Ha?fYV)C39J/1Z13),?6URYL&eGMe8G)f[e\]7Z:G
?P-a@\f&02<T&]Tf#Xd,EFS)WJEB1gc_fZ0?3K1fR]g,-Yg]TRU-NG52b,U+1Og3
:0&D[T)F?(PZT&_bV\0PQBF28>5B/CZ.Ha@4+)Ud^ONJV\R[&9>]CBef,4B?>JJ>
3_WW@ffM:#1Xb1-7.#SgX7>MIC;g3IIS=Z(/-I.5<F?9;-V[S4[e04A7,Hb?7SNJ
bHRK(&IX=-?[,0GE+PE,E,J@e3W(\Tg;fQ^@f_C7OH)fF&F^F-SD4a-aO&@.,I?f
FERc&U[F@gO[gRUP,d/cHNSN5,B3gHE):Z-9(8bd_^M0<U.D#@HcPY5\LX3R_9X<
@HZ>O..N;1;P&M^7O(0FI63gB)Z:AJ6=8/H1bJQ8.=W@a#4R1UbF;G<D3,@L60_e
SW4WXed4REa(#SH]46BGe,R=88F]4[ce.MAAg:1L\cU(N:cOBPGXL&Daa19E=[Q>
6H_7O\Ng)6,gA>aB;6(?MLK1@PWEU[8f_[6YV7M8a:f&AZ)XF3J13K2bA;OT&:UV
]+:O<D84_J[R]]Q,?#\X(C&[Xb,cG)#,BX7^_#)c:^5#KDD5dgcC2V>b&M:9ZJdQ
JU]AO]WbD@QL2(7;[()8\PZ6#<ZL.dO@7Xe&D(0.L92#/c],BcX:Xa@&>X#:DB]>
UJJ,2g#[N00H,DH.C4VBRT0-:g=OXH^RS[W[F8-=WM6C4QP>dXWY3Z2IaE:TD11O
J#58;7Ie>RW/,<<>6bf,@RDc_S[&K7]8.]P;<S7S+3DRP@7geFP]E[J]EWENc?FS
Mc?(OF;#R3,A4:D#S9VIM:#2+&C;=\5)JXEd;E+Q3M#JYJa3(30O#K:SK\#-,@8#
g<03?KP24D)LXE._7aVL/-S0F/]dcB-LDNWeQ#86IQ9UY)S>dMR=g=;VSA-c6?-8
(WN5=WLdNPe//aaA&DbW\#K?FOS=N;I_X6FaIeW))A2L=^gK=05Q8=9R1J_-67]L
U?3ZV@+7_:&Vfg@2X&(\Ae<SL\QA8FPWZ-H<fBGOFG=+Y\3B>A1/9cFM]/[cQ042
S_8c]+7ADT-]67RVI./5Q^..4GT+6Z4RY_>\@]De?KM;BIe=^J?J0ONWN7dG-NI;
7\B1^^X6?B/QW8\-1[9>c/)/VA)U2L]fO(=GFUc:F)?S.I4B_UE-f.9T65(R&3g3
c]4b@XaU0\c(WDaB?LU+5GD3X5_e3L0+ddH0&bE:Aa;,A0SI7fgGJ;Q^K\]E/:a<
eYC6R,D>R@Z]W7Z2<#ZaP/a3,R<XCe\8bGO89+CPWYPe+J]C,f>Y?:K+P_#0bECg
b_(HG3Q<4gc>_Z5:@E)ZbSJ2Q^ELLR5<N(c.OC2-9&:F6Sd:=b5#JZb;\aR)c8HH
M6S<C-Q&)HF=QT[[)e=22gccU&6WTf]&QD&[T1-bYCJ:&>SM^P1-De>/cO2X5-6f
#9H^]FgO.65Zb:6P220Q9W_3AMANb/aTYHCC,DXJ\/F9,EO#dfK+8M(&DZBX([KM
]P(?PC:&Db/[4(K)c7FT+T/6QdFVV2>;[ee>ZEQIOFb]M9I]7B/3X5SMFgNV[PGC
gL:?gROd0NW5?O99)VVX=_c7QC.(ZPATBL,E[7<[[fKTWCeO3_F,@I,,WOANM;X)
USR8P5U1:bGeWNcCGZ+:9NU5:;d6GB40MX4;[6+>VUE_KOON/SYWJ52GbQ#K\FZE
O9IgHOHS1(C@f[3;MM908;^_F9VO6T_;5]6II^HG.7OL;H8<<;FeA(4#22:E^KVG
DP^V;dgRF?7D5QG@B7(NbO3>)-7N]FF/63U&A(4(?D6LH,)#1A(BX-V##V:c.O=Z
.EUI^=O:Fd;:V?&YWA6:/#1B0La]a>54bZYD4:>#UZ(-668Be^47D\<D41BGe1Y1
-C6G7H,ab3U+(4EKF1@SY;4()0YE2&UE&d#0<T7Gb+Nf?F#JG@S>E/BgG<SM)FDO
HO=+TGBX0YVEH&(KSGPB?H)TG;[V=6eM,f#a2;0cee7<f,9##P=FWCTY.#8F6Y&&
Z?KDbL0daKFC,P3EQ8P@Qa8>SafVPd88R..?(?K4.Y&?D7/T]+L#4b^NB2VcD34^
>R3YaFc?[;)3(H:C(QY=8&E4aHR54K&fUJc[:I7=4FC=(f;]_cf2/O4I1G6Tc>Ia
<WQ&V<>GVX-A(0670[I(@>81PCDc-<.[dOdM3+-2LKR1f>#Q/eBfS=b:F(44bM&Q
P[B@S)&,7SW^=-0@&DYS=IJ33;-X&a72\N0d^_HAUS5^(]9+[9MO,?g(ODgQTNAZ
S,:D6FXJ;##?dMSR@8M5N#I.b663)T\RRB@b_S0_5CN3-N_.-Xc7?4YWZLLB^b5T
N2>MH/D6(3G8D_DJCF,794D1.5e4aG)f3#E,>Rc3Nd.E\<QU\&A<LPPC_[G@7KLc
_7M<.E_5W@]B9_Y\4@JN&L\GU2<-5>=YDQ/U8^9WJ=DB0\WJ56Rd3VW<&0[H#Q8f
e)c;fHBN>ZaTDMR[+g(]ScF:_>C(YEK?6eCR[_-Qa9]Z/ZdB._&g0Q:=]7@b-+1V
0<=R<8(RgC5:EZ&??JWZ[f63.U1a13SL-R9)=g-_[HdG/FDg?(EWC-_e6T7(3C>]
E#TU]:PVa2O^A6LH=ERL/^OWg2<2)LL#(+7+6,1.F#WS3CH(1#a;73;1T+C/9.b(
J?L#bB=1Gf,\PWUU98a,W,G_]g[6?Y_]@V?C/ET,?6N2TF;J[Se<\1d:RJ(g2S)1
;A-#F<0U<b_;JcE:<X4FLe7LRc1(@TF[cI8:ef4R26+J1@Hg2ZNW0YR1O_e3-Q?C
RdHZC>0D#7/TTf>gV_>4]/V8(CHScX&(g/_0-I;NeTb@IK#F68M_#@46AbV>^6;9
?IX7RGgXQ8GS=);?>2KfTFE:f@T;G>8)J:g[.2NH47,01?R=d:-_#W-3O;^Z3PG<
?Q,Hfa1U,f,H(QTfBf2&a)#b9HfYSDcU/eN\E[9/)>a<^GUF;Te@4&a(eeBaMSH:
4@>HQ/aQ^.9?_ef#61.G<;aKcWLX(D?Ta#?7DKPZM7-,RH0U_^PW_0-dg?QK&AaW
d694Hg7NO16SBR4dA/>RL#F.Ie20&>E_e[0RN[+<6SN4GNeP8X)gGd:TLI&M-C,F
\KLb]JV^B4#\L\9\)I(R?25B?7JH-]H-&GU,YL^;HN^].0/&9<Dg]E)e^LVf)3>Y
?#.7,M-?c34IMKcH9H0[NTAA4M8V-OQdVL8N1QI&_RK@XQM20D^W88=#2VIf6SU2
f,,?[K](TZPePVEC&e3R<11VHd(a,O]@.YR,;b#\V\gadKaQ104+bc?)&2E9JdIM
fH:@0E9L6(b:>X8D:0&567WA-/^O8^A,OgVedV0G35=F\A=USH9L&VL\;C54(Kc#
6<J54NAMTF=Kb;RL39VXG0DFJ]_HJ]=,9TD>f9]SFTd/=R-A0a8:+N=^f2KI.UTS
&8WdFg?Q9Ee?KOb<33+^E:0LY<E+1b696F^-A@DCd<fg<S[9ef@fXPf=TfK#_Q8S
C)WeH+Hg^EAS#Z5^96HQI9=<M)GFJ;d>]c+_,Q7dH5+77aOD(916[[X)Q@-2[FBN
fE&E@#[@@8DIRXa0Rf07_:NFe,0X16,[-SX4HGNNH7@(HMCIS#;MfbVL[/95@C@\
&^R.WPgTP.ba@e<[[K=POBYa3\YGAK.B#ER1P3dY0PfEQ,_>ADMJT#?]UD=;)RFI
^L@:I[.YI\(),RNOJ&<V\0e#DNbXRSb>PH_dD@ETafg;UD>d0?_eW_->))XTJ1JY
4O=6G)gPUe(IZ;<.-H)A5b:B5^O&+:6g\>LfN<1X:VM@46XMAbdE,IV)EX]2N5H(
&,7&d_N,K)bTQ+.\b@ORa/DK0E\ZbO&QWM8DMJ\M,=1Q5XV4Mg?.Z4PCR&S0C)g@
.[U<7I<5Y(cV:R@T_+>fC+,FJ,\F6#/])EDb;?<1[cHa+M@+g2&G[-4VfQ^,ZDM?
.W=:1QNWeFRR_RB6,<6.YKdUH)Lf>cU0HIaWM74Ae;e7_X7gfTIVb7?cJJ/eQ>gA
IdJLF<]ED(/MF4&,CdPO#0O83JFLa.B>3LZO+S-[M75=&FPBDJ[-aPMBX7gQ7\,,
[F-.)Fc\ORN5cH)DBA?\cR/0N<+>:MHVcKAC<@;HSeJC=7bLQ:g46STcO[g&75bN
W@JKf8TC_[2^/N]<-\.5^e&^c#(KaQBZV<ZXJbW-Rf)92?=?ZNB98S-N_^e#7@P\
bZZ->,AW1Z&JCSIZG>QWIg2NRH^BKN-QbW>c+BSUMdX+@P-U9;ITaAPaE,C4-./E
A<#IW^S9f[<TcfY3Yc+^/0DfRa9-#V\LKFP8#.CQ.6)Id.R1&ZHe5da)BF\67dG:
DaJKENJ8RQ<M8LCKb3EWYTa3DMAW,36V\ZTgCda1A?-5gXbaZLe>W_.d18d:9Y/N
>?F8aa<=XLX3);a5=O/>.=N+6cEb1B4d&K5=1dZU@85[fU/?>LJA1,1?0fDDX?+B
Sd(K,0_L:g+3H;IOUCB-(5g=6g;RBNH_#G+R8XI#_8G0Rb@.O0-=IcZ/dEF1eO>K
cYcY;YW=-bH-3X4DO5@,LefZNKVO6KeO(d-U3ZHKa2B,<+>Y9g7_):cE>J8Adbd/
_+f,YK3HP[;)0,Z=N26:cOVMLH3ZOEG1WIY>MS9gND=1Q(b>B26Z?E=bC/S9TTeA
[cc490;^eQ_:AgE_,A81V0a3FX@Y0f2cVS77=.^\)5@bc=]^XJ_^fggXW4^[B]<[
aN5[D?F4B968:B,022.6049=_67)95&+0:bG=)D<7^&3OEJMHB31I7dLFX7+-+@<
Cd?(]Y#:52BAF60RT_,(Qae#CCOU;5QNUD,5Q/MI6-M(_3TeH?gKU\G&@02(H#>X
0O.D9XO_cUY/^=Y\g)fXFJ7;-&bN?GQ2^<>^??#W130:;0Z2Rc#/.bR(;22W=RE#
E@\Lf))G5Z(M#d=d(WTM4479QA28W?MRIb_M1NS2\##CdO<&61:-X&0D6VNZV,=E
:B<&I;^,BO^GT_MI]5SGS4GLaE?#AT71[aSU>2.U+;fc#7V[@N[Q#]2GFV;WZc65
:e6cb,JcGIK,([[,2PJE0@T5R++.&K1<R]b:.5>]:&]eX+V=?AKUSYFE446fM8UT
f_RT<-28IScS9aNA<9dU>H[>;)?aCPQgKOVB([IO(J+/bdMQ5eb9O\H#I[bZ63b+
5CQJZ4.+d1g]#e-C>CPYJ\MPMUQ6G(=/-^S,g63.)d#=ff6)5RBXeTcVY+E9W4F]
-)ZA]DbeL?]?W=(IN\)L47@BLKe<L7XgJ(8-f#DE=dSgV1K;b8._TFNGQG#\^)3_
.EUE.K(ZDI0]NCGR()8[,4F2HWKV75gP5^a@5N\YfDUd#c??Y>97C.Eg4f=LR6X#
7ZQ+)Q#Nb5?+,Df,7H[HgFQYJGQdF0J6XgfJY\=^9,)[7Y/=9H8Ie)HT2fK6LAd^
A+C7ZR:7(;Q\#HdDCF-TR.ZPZ1WK]c+g+_dJ03QY6c(gO4RDT9-TU_F:=IQ.cA\P
V5@N6\II]Rc=Gd=98fCFNfEKK7(1+8.4-GFUdOEC=LbA+WUKG<TY=LSR)LUHFP02
3gb7_8,BPgGW]f)TdS2360fSGT24\C^U=?AAF7e[&?4V#C,V>]&YH2[Z1E8(@K-X
e6ES[S[cSZ,?X\A\?4))Q#4_5#Sc92KQM+N^EP75>UXDYHf+N1aX-W&__<W5610J
GTQ/AJgO<TULW@5b7MCZKW\<_ULZMEe@4YTEH7LU=:Pg#/Y3b#5F+#3CG[?Me]J,
^HRP;AdJg)4(X::AX4d,M[5(/Z+f7dVX<C2EHU<DAe&cBNK,O0]Y[YabI4/\IGP3
H#BM;-VFM)7ITMcV/BC+MK.T953NC2(1GW\2b&RNdFg]9\/EHe6c=?_7SdT5AHKN
;aS0&5YY.HObAA/=8Ve&ZDZZU;=Q[2N6Q-NI8EZ(2GT(6bR.F=f@(.TU<RH9)c<N
5\cBS@?eAa2DbaX(MPG>feEMQA[JQ84AM:1R^4?MV;I(e6Fd>Ed/])]T/3W]3Wf3
[U/VYDfK+N1=R#OE/XL[)PeLJZAf>Z1I[O-.dP@D,GR#E>dCW)^\+8ZF6WZNPdMV
Se_B[N4a\30NLZb6UTKf#\&S)\3b2^1MM&,GBNW9;Q05=-bbUTPX#BD(K7M\/[Cf
AL+(VH/B8=Ld7O7O7b._e=6/&Wb627&-d?b4Pe+XO[J_,,R3KHC7YUg6C1-?[GV#
=;I^=bR:BZ2bR.8+P)0Y0b-MS2//>T@7D6/E3))[8>0I&d]<3I:a+Md:&J:&.c00
(L+c4GNDM+0PAba\;1X]\6cNG_JGYZJ1_RAN,0Ue)@LBKH>8eC97U19+_Q6N7c1R
A\Dd4Bbff49+e./HQN27TK1241R[0;#fH-\Yg=_A816bTRH&0,W.DC8/PM)0d#+S
_LYI]/)3dROIZGE,D1LOSSS/6\PMK:eQF]K3Kg2]I+N^G6@2Z\8Z2-6]43]JRON&
;?#YTgT)=geW&MA4]Y6)UNGDIFeQ;2E5P4e\K\fLbY4-]+\Z;\+AV;TdUIZI<1e;
\0AF4+WfT(W=#G=NeBLOR?eYE_?>/@.8_(bbgSI:3CBI+L_(;b.]U](..),+XS2a
Tb))c-M4\9P>\MU+?6Zdg,?FE(?@WK8W:Q1g-[8T-NedNdN;O,Fa#U;=ZWQ.&_A@
.W?\VQG/\FEPU=aO=SQ-]40a_<(c;/XKT<cXJdY#S+25AaDBVVfQ;P#ZOR&-2bST
),Wa\bDC3ObaGC@;6g5)_NXc_\fQ6PZBcF9WJ\:W7WLfGT\O+H>-HAVgb+3dd.I=
<1c(<FRNRL2K;#Ig7M>KN+,7IdB13CLR/LA]\HZfaANcJM]aT3BJ:V8ATHI?M/gG
#VX<K#<H37#<>&aDKe[:_,IA4gG/)<04>bG^?^g;BZ?ac)_VB&fa)g]69IFEN/]f
@@JcfG>PbMEZZ#=2;B^LKOY#;,Vbe6YRTI==(HHKIFY8<QSK#4JD[27(bO^:?#0<
?CIMPUP5fLW26494+/Y7MK(FCR#7=dA_QO5MB)0U69>b4PVZ;<II]3.^Ea7OAXf>
UfR3V4aH^Y??-GP-9UM54f5.eHSbeG.<K58UdK;#HL[,TM&50eL,0>IZJg0&,;VI
985#6dC,dK8TTPO(KU)L38Xa^8N;->Y+N020g3Sd:_fQ2daY4;69cb4;GbO?H+(Y
CJ2,-TAL7I]e[g<&K[_07gd^e9TP-&-c^>BT52ENbMc8C1:7.R<7eWC9&C5O0S?:
RgV>]dc^]SRK<d_cSE04+XZ)JY]S>>B7>9IL.V#?2Q0XS-LQ=<1J3]63ZBKRCeb+
_Jb6fRGNc)+2cU3N;D/Q@-\8b]BJ)44+=2dQOBQP9QUae9,766dWH:TBc?]R>Td:
&OP]f-DW/Gc:LOc?E1#>[1.R<U2;:_FYJ=ETK<<b:T\a+#bR(.\/2;U(Gf)J++Gf
0X>PDYEWe5+QTLFaS9X+0WQ9Z-#\4Z?-L@Je^5/:0(f2\GBX<TRUG;#Weac44f#R
:CHKX//)a3G._W3KDVSTgS>[P^egS[A5=D_/BH?_>?HG]FCTHM2([2c7812(./c5
ERM:cMaT&YWQ3;BRTX,NL(f-CF+^FBf,B&<F<#_MS,bLc?O<E781&7f_MNX7JB0g
&ZM)75UVL^W_)R]b.1YK.R</J8PIU>W)O52]YIY/,G8K^X(F9E.I+.I,<VgRG2+I
I<fB5dffKVW430\[9F3;HOTFYI4^&Qd1P_;6a:IR>B+1_=JR;MP]6PMd#/9S:3cH
X24OWe+Q8WL6aM<\2:#AEa;HWUEA1+E]#^2)#3eG0RNMaDg=@O?2:6GbcVD^eXK&
?.Eg/(J4&J=FACg&RQNeQe,Q;LR,&C>I#YZI:0@dW@<cU0Pd^g@2WLWN?Q;D&._C
Z9CMBd3X1U09Iee22.-^dc^K1.&eM>J<GA#>/3J-Ae<UG;ZP.KL9IeHZNRPO=1#7
[-U]L?Tb7T4T.Sb:&.@G4?_Bf1R3]3FGI0:]5.9AS3MAA?B[#cgTVga.14^7W^NR
W96])<-&<C=KYF5cfW>&Gc)JBW]SB3\?H:c,aG)I-c]4A@@V\CI4MEAK>-9]Qe+F
9^Lc(ePE-UB6,_bH0Fe#91B3[(\+7S;H)3S+-ED0O);DTFI[XNMBbb5&^SG[7J-\
^=KfUMbT)KZS4Y[T+>d+a]CGSL,7+NDRL88WBbc);N\5abKLA:a?c)/cN_Tf5Lf0
1A;]EGRK@+ZX(bK1L]6?IC@#F]ID098<;0EB=]efb?&_?0R_M?TJ]:TBbDd=@3;R
GKXA)TP3.d;S;=D4aEcECY);_C[&#:G\X1>T5H)V:#d\ddAR:XfI1Z]P2KOOMc^G
:dQHQ;#JSK7gAa.7D5=-[:#U];CeV=JR>_Z_f.7gM+:D5gN_8W&/K/?)GTcBb[(D
ZQE7#a/94JR_/M+WJO<IO5VO&9\6YCXTd9<H8(f8=A67Y=4,ZOWT?O\+\4[eeBX_
8dDDD9BKNW5eb-(N)9@R(F>SdCeeHb[_bYLfBUA@cg(6NSFWb7;[MXf<;3;[9QT>
0JOg4MK=-:>>GL=O,4;2_C:?,I6KP)WKRY-J1JOBL3(D8g.O<J&_W\2\N0\15Nb.
B3VdVAGK_:[FW4XbSb+AcEG7N)c=^6UG5)5bT2AOG=J4H&Nca\:d9@9&6EOP]Q[E
)X<P8G^=4]PgQ>(b6B^I<?B6UNULS=-R,P?g)>:U/DR+fdYfaUGO:+g15(71f_N]
4P4CN,?\?=6Cg?J\J@/MP#.CXIZC+4._9W@-ZD_WIIJ;@gRD/HRJPQd)7M:3\&<#
Q8=4<G<XL6Q[]WN1=+ZC4V50N3V#dL<E:AgIV(OJQV#[CCLCb9Ob>]@cZLeQHUSV
-N(62P^@.>L&:MZJ.YIXK]:b\M,)&#dTDbXCG9F2GM9V\:0a6PY>PNDJ)H;ASea;
L);0K>7O>F0IIO:]8H7-^_T@.N(&CUM-f4Yd+e[1P65)9CBQbQb\K6.W9LD7&_gO
.B94-7CAe#/-_70.PMf#3b+]-^c\VGe6X+VP6ZM.3KP\TA>?(0\-U_If8K],4DKB
PU/XSVQ^YBV?._V5cHYP#G8/:7&6b^c:Q>BfY.\f0^0)N6+bODHJY1IO?;^)_)]G
g&B4/Gf;g-80-5B4gfH>QXZge/ZOR+Y_PT50bHKE@8KD+c^bb_[CWe3C2K<85aH\
b/=e\QRGF4aC#R.ODC_^eS2TPV?K5RWc;UD9IA1@fHU8.5^8E1e,g)X8gA5YbH^7
3AHF-eBNPFW&b8Y2,+XO)NW4g4V>0+7S?aCKWFK4GP3f-B8>UGR8?CCQTD[d=8PL
cMSACS1)&=]^58_BYIFQ&aP3L>2a;;)D#/P@Q@,GY8H4)dZY.33+I4&8TER>.&PF
b2cgAR+A7f<XNg94CWH/bd6#FA@NEVgW,3J7KbI\I@:?&KL\@N=OQ/@-LaK>4900
7EGdbYMRBO2X+L<Nc;2B3SGYG?O_Z?_0G@U02W>#46JTgJLZ+VaH<@<Td+\VEE18
0CHbbLbeF];d1]A1gB(+N-3S8-X^30@#,H#Ib+REV@b:<V;f\I=LN:YO^5X1BVSB
2A8&+d&Bc8c>gLO[.;U82Bg+UaLUO]NeWF-B,aXQVYR^BQJ^COSWV3].98_T](gN
5AX7c#O5H:\0E:)X4M8):2JeL6<3_?EU7A+dZT(d.>M6)3cD53-=W-4D^LGXLb5,
9C6Ha/cVJC(fdC\QC/HM<29997J2LVRINc#K3[<.AY2PCVL19RJK0)[^MEY^Be^2
(/SN32NG<<D)M/.a4YW&>_HP\M;d6_>^g9LdM4(3gW@L;,B4cVA^?54Z,74Z[\G.
g]8[B>L7D2R:c.AC=C_7(<R3Y[XaI03g)64>W;C[/HgOB\g=L>22bcefDFdJMK\Y
0[]B=.6XY>E;aQ/W3-?L:bdXJ_aaffBSALO>3_L2S]@>fT#@2.85<fJ#J<EL1C:A
\9ZQ;2>CIQVSCTAb)^RV#gW8.aH6^T2;-W@9e)\6O,(SH&RV]WY=Y_HH_FK:?H_V
^U[KGQc[4V(J2[U#Z?B+@)9fKA:H2HR84_[,AFI-g/Yg6#ad+&g4#B-^:0Y(McGC
D1=4)bIWT#J;T><UePOLG>+<_3gN]X3JXSP;e0eGgWD,#X;.(YdTf7N#d<,^M]>Q
>Cc<FLWX5.2G-\^VSaMFWNMWSVV.[6:YH4AaM:Y6a_C/ZZYZ[0HJH?3-Xe.OH(][
#K_E)W.J<1,I&Fd;D,<UOPB1:RQKI\T>)-T.1S/JQ?4[U]2AK@dD&<17a/)Ve=FE
J1K)W0KNOaN?^B4dQ@g8_(e&\[S2fV9e:O\C^9D._]0MW[O/a:g+R>M,L<PS_J#Z
U:0bRUG_S?(fV/-BgT)CEe;^-B0^E17[EI002__0Z+QQUXJI&b;<a+#@fN[bDIAc
BJM<Bg.G;KOdE:Z3,2D;3e(79fX0K,7LMDXY>=QQ^?Ag#E79d+NfB=\.R+YQf9:W
H41<.-#=YdN+]O+163G9H[?NDVO)BJ#&)PEAW&2K-07VbaIHDd8eLDZBBXD5(U_\
SggZPK2bRJL:D6?8cIXNeIYL^FECQK@.QfZ13X/89H[QC).:DXE_Ya[P[@CTGN?8
fQHYX-WDa3#R(]d]U_d6R=OC[(J;0;d&<SQ3Q.7E4Hd)AZ9)Z/KK&g#bK0R>PKUb
B9bA9eA.0]SD6IO]D2VLA6f#T6e:NX-HMA^aM(JBeE/1.SBO/gLOd?T)-5=@LM+e
=>_V]X9+4J)BN<f+8OEVe(Jec-dg51Od)>AXc5[6RDM=]Q5REI+AZA1(5U9QJ/4C
3G5(DQVU/N&Wg4QTD2Y#5YFY5AMBR<F&2ABSDD=1ACOA4NgeC0]7X-G)?Z@>8KZ@
OGRQ20b79]7KfL>7QT+4c8EFC]C0Va-C9>Y?;[WfN#PUfb0+TP-@7A(7ECAdD:-C
,A4O,?P=@JWBH#V@5;L,e]?K,dU#.&X]A0[XKEf=SbZ^(?.RU085=0S1aM:/>^W8
DH=H&AZV-,8dN5,H[4cJ5N-bB_;+R/X++PU<ONHBOR:WO>LRO_D/64=4_L<A(^I+
IWR;MW+B=e84^J/aD,BPV+DNd?e\#+UN&43;g@IeG);&?b4A9C-S;ZZQXdJITCN0
D@b0dMJM6b+#W6OPIa1.4dgPHPS?8M_AL26g3<eN51WVT;afJ:]MN0SE,PZE/O(/
#b2^6RQDWZ4_6R)CXH((9ZKS\dCT-P25aeS(/C.U?R>L_#6S_@;ZZEXH[4/-#1+\
aG4Z8fR.8f:U7^F[=Md-N:8I5eYRCF654GV#N[9ZJ.9OHAX3eI&K9&S#6BGX-UYK
WSG(abCIP.G\gTP@_T##BI@dTWfZE2@6XKB.Vd4(4g_07,^9P8T=5S,7[@FF+f]0
HSH>>)H^d/2S/G?-AGLfg+#R]?HY;1DTKUGWW5fHAU14]Y@5c1a\:H?H(273>>IZ
VO\TAgfTHc1/2W@:UJ(b>#4_?5PW6W-63#W&UM1TJ2WKO2:@[?7R.3]K4?C5\8\Y
LL7dHBX[\FYb<,8QW]/+4G6?gW@gY+I=PccT35X>f5N3OBXC[a^b3#NRD3>KEK/7
SYcJE:2:8VWX:U9OG&@?]D#3LTTe<?&=NNeOP[e6/eWGH@cO<&?@D7G..X,FR0<T
OP[cK4,TZ426dWg1f5X(69>4(dDQV=g?g]g,NOR?3PYT2fI;J4IBFdH]aD(_fZW,
,G6+<G5G+[&GB,N5GT8Fbc8JS<RBNPID.:4135D@B&.DHL5(<gc_V\Sb2ZK4]W+R
@BBQ#S^I,+T=WL\aU6f4a^2eG^.U9bZY2DH)Vb^Y<L;d3g[2&:95Y5#bGP26f>;b
bG6DGPL_Q^;-[?VCWD/[A813bP&Pd5FVHFV7I&_EX6b=D6C8&PIHJ7NAKC^R/=\f
[XAX>6ea-E6T14J2EV:#A4E,CCBK;E-D[N:dfaIS_Q/L)(89&01DId3a9]65M?ID
E2ca9;bW;N2]aK^K(U2DV]4I-c@2?<)g>V_KLJ-N:_FO^;Lff-CWcKf3e,65<EbZ
aa5;G-OH)>e,S6?=F#V-,F6/b1fMgS7M86_0P3BA-+DbUdbgf;1V6@WfZ_@H:Y2.
@Hbf[3W+PHbCHAVA[:P0@<D9cPEP@[H=B83X/?/QMVZC@,Q^@DdXc@fG,ZQ;(I\D
VMA2AfNK(ZQ7N-b7Q&]BOG]0U)Y[;[><@PHVB+b26d-H&I0_ZH&B,3>IA;1R=bSd
K3OHQ0[[<K<T63^AcK5IKcIB@7I\@1:XOMHH(M0LB:9C&=<ZHe^^_)a](>3M_?b/
.]J\0PGS/G]ZOUIGJEEe.]UL;&U+f=FC(KYW-@Y]ba-=KNY=6J=b=S,aaK,Bd5(=
A;+R/a^2EP=/]6Z(4450B-US>,aHXbQ^D</;<J-LcI-+447GC8<0#=7JI-fe>/G6
T@cf,.GSDL;O[2=/5>-<;MZ@O91:]B01/H]8A:Q/;F:L5411<Ge<a>OS))=S1@VJ
-MH7_<2-C[Q1JaHb<JIc-2@MO@TQ0#6\&AZ/;#]T?\ABU:Y](dKNT[Kd?D\N?ZB4
I;2XgFP+DGcQXO)WG?X4_OO_?6>Sb(]OIJ(g_bX[T+5KU:<WJ2>S>94\1QNL3INP
D:g7S/^\AN^/O<W3Bee.Y50_^RZ2(eU9dgc1)\2LFMV5<AD/_-\J@-X9#C9ZTdXg
BEEQ7E/^M7L(30]3\>Lc?H)\2\cFLKXIc\_-KX+&F&a_ZU80SX17E@?<>BdWfOIX
M#SI:,5HV/XQUVVQ/DHKA<JETK+1?XPO39L#\DUM>0#JPMF;SEcA#R<)-\E?297A
#I4.:XYVCD<WD>VOI(T]:baMPP5E+\\<J2R5012F]=,0-.3@T76TSaJG3D.#A:<O
BP;FbPZ6g7\Q3_b.Fg>V-.[XX)E)Zcd,D1.R@;K^TKZT?&O6^TM0J0C<RY.KJS2/
MK@VR1GYWacH,Jc/CW_Y?BZIQ^Rf8#BYBF,dQa&CUgI7F81S6=dDd-@.0JY9^^8T
7fb9S0#e5>CU2IT=,\e]d9+0d1.@MOFW0AU-_;efWQ=cf4KHMFVaQ]bQfM,]B@SM
&\_QV2=+Md9[;@;1H)2OMd)Y4;5.KGNdfeITN;X[dFJSE_RGgDH@L),YCUcG_OG>
PeQ,<.(fcWZ7W;X)EE+<#d81_eT@2L<GC+BHR;C\4_9fN1^]7B0MJc5C\.Z/d3+:
1T_ZK@Y(KFeRcM?)N[-GW.3cQW-:_N1a(CC+6-S_10GfO;4,;@TK+/^5&VS:g#2M
IOR&AV05#,C3T(f>PU^R?@GO.ALa@>BUJV#P?02I;:\0Y_@/XAg+2g]L12PeLa5S
IYW]3-UGc-IX,#U=)^8U1(8X??54fIRY]aS[8V[7:@A:UX<2eN]H.N2<GfEAWUJ7
8]33CgPOM,9^27AgROB-F\.RDP2ccaO.Q)(B\-5])07G8g4H;SOMUTZX<.O(:D:-
CT=>R(e^e/:8];ZA7-]8D8WFTeQ8P_W]QT0Y.#VAH@EN9GbW.67W5G[43>-e00;#
:;ccaA,V+TE8fBPdZX4N:73M-C7DQ6H@a);=D5eGFV,a-(ebLK6CR,>^+-+5eUdG
f<N<S_/S3RUNU7eH//V&UVbIdKg]A\g]MM_)VKMWe_L_d/HV5CK&gLdNW>X6C+B3
=b:UgQMZ4^,f?GdH/WQe-_WUgTWTWK&]1//:g,CAT_Q5XA+5PF/VbKbTJY+]G?2>
03Q>)@4<MGGU#(:.IFW&VYJ#R\:M9c7WX0aWW2\eUF14MB(+D^cQ0&+F249g],&?
Ud.#dWP5ce&db[SQH#:H>S(MZ/,9^?L)1Y1b/)E@>4A1@8-ebEe=.-8a_\5S);I^
(AQ3.AH7]1QA0<=#_M<4\gJ@bTW&-P<6+=6AeAY:)_Ie:6U2bcc.#V\MW&RQAC>[
;JOZY+b@9AD_V@@:1M_6S3fS\g/ae_<C1]a((ZA51UFXW8g#=4cQ->c?D/d:-.;#
48M(]e)5NXBXJ>VFC:<D-+1J#FB>\#_J\A9-7(WK6Cb9&.B)[T/RB2E<WC)P3)O[
MG.6J@?+]G&7+#<bgPLG,6C@6L6>>g9,Ud5R5LXRCI_^))=d1TW<RTTZUPMEU6Y1
Q@02K?;I2APDIA;A:1:6^B,B<#2?3V@ZT8N(@#XeaL20SD>AE)37d)5U]NggTC<=
@3NMP.5Qb/Q)HN1EWO^#Ld_?M7-JJIC(0FOP\c6dX-DOPe20cTdM@e2)[F;ZD<0B
5^5NAT7QU/?>IFQU=ef:=G\g(NA2DdV:KVf,9\:N^a2<]bFeb1GS4XWGf==@AU.O
JPRA:1_3N]]9@P,FZ_#TG.?ccW^@FUUF[<GKa<5KY3\E3;F\T&_5I1R&(TW3NSC>
I<<YF.C)>8Q?5GSI7WJH@Id.BL=>eRRO/+>Q3MM>Ud^@Ga:QQcF:O\e.?gMG#AW6
Va6L:3B2Mbg[;TSac^Ob[6\W;^fK@J0KK4B023?B;M+=Qc.Pc-bL[1^E<&HVRF;A
9^5&bCIU[)G5N[_J26#?ZS&/XKKCdXK\NBQV@1cUfRaD/Y9c0GAT#<ESTHb(eTX-
9OI_#;c4@,]]RAF3QL\fES^2948Z/f4#XRe+Sd@LFQ+6).bO81PELM2>8>X(Fge4
(+(b;8gF<_ED&5JdQ.=)?PZQ_8]@0;aZQIdP_8^O.P)7#LUX,+5@\e+TI@:\d92I
KS\:SaWJ2EZE>#/8BK@/+10,E&#Kfa;VOM\[,NHQf+0DC/9K\fL_2_)b)?^]Va4<
#[e[--?[ab8c&,C\YA2?;18Q2)D2M36L[/L>HF^NfX/+Q;L8?D-DRB(cQYB&5G3(
9JbXc<f;#30QZ>H8739ZVe1BUOM<QJ)C@BYKF:=b5(1>L;X^.2>0Df53DO>@C+H=
4c2:^ObG\Bb:,9_8P/=AS3PCgAe,0=+cM9R,_W0SdL#4PVW+46,_^<a+0OYT]N?5
A075\X)H-+A08dC(2ODZfY1+cZ?&B0G1^?AW#^gGdQKQLH)J,8Y@&RaUgX/P+0BD
R(ZLCU_U:,T&C)^#1&:4G94g9ALF)3S5^,U@70^VG;#+)/Ka3T&[VZ28GL=>R+fa
0RS]Db#;ZOR>[WT^=YEb\IRG\<Mb&Q+.RN]9Qf,Fa<UdMWIZ7C[fE]&/b4Ve/PNg
EFML,@PY,_YUZ?^4Z>:;1A+;Q;[^8ZZ(Z82JA>AO5Pe)(2,g9\D^VQ4VC<C3SW-M
E=1(CQLSJ>+\BeXWK]GScX@F>D?LW7VDGcR?\+:^gH9@ebDdW&,\CfCPUW-bM((N
g<BFY-Ia])K61TBP52Fd)13CX:6d3(4YN7I+UP49f8K]:KUBP^)#<6G^.T1K?X1M
ZVG@(R^HVb-.KK^X5VgcS5.9?Ec7EJL9/FgD[0;Xg:/bN?R^I:22YBZ3>MZ/+)[K
6=F:KQ.#ag01<W3A5JW:H;V_IS/_]BdeNe#.T/b?5#4.PRE\/dNWN^N1S@,3PFS5
/_K+[\I7T\Fg5RBRORGZ0G9.42>ONCZO[?4\N?ZB561aAX-D.C3G/_BC0UDb-F:O
/R26cXL]B8eH<P?PCe>NHCaQ>D]BSOSA2R8NRY7NJLEa(/0ZYC=WGXQNZB0GVTMB
_/[C2U:CaW;[aCN65[8^Zc&fMgB/H1)X)FEa5&#52)2=b2XGPZd_98=D^P<c[;g6
?NS+:1^-2?^>Y8\+Q^UI^O(.N#QHMLJD6#K@R43fcfWRf@R792W?PVc_97F(J+9M
+-?CUgO407N,N_&1Y.NG2f\<?A\#gMKRg=QW@(cR1R^[G<\LCT1.@[Q4Z#[3Y]VP
OT5KFT/M9&GVF-3&LZa[927\IF]ZLCY7>8&Q1cXSVH9)085^DT.C.OATE7HTgB>>
f/D>4bDN8T^fK+>da).OXT7<N_>Z=fcgJM\aG:KWU5<EXO/T&UG[Dd2(I?A?P0X<
A])./D6H?#DN+4[S13J<=@V+Ae0EREA(?X@#AI>9J(SC#=O_#>_fSF4C^_U0Y8O=
9-L^RQ+,Nd]aBARE;FTD.EN&4g/XM]daWHFM6=H];E+@c@&,7a7Yc>;(<X6d;_cb
+f(R@\ZM,?@,6.=7N,dWGQ6Q<bd\EI2,7R(K(@>=@IC,>\EaA+>05<:;A8=95G2E
5NXNTU(g37__AVR9/:cQYecPRd0RJ#=a1K7E0U2>+E56PXH/^=>S<VHUBU;2f=>d
?#3H-?Ia,<?=K[Bd^fDQb\/fTa6I=e-R]F87E2_f8(;Q:ePZ>4,.OW8BW:]8@&R#
>Z2>E5O4Xac[>@Z\-;&dH2K(B#9O;OFe3T.FTOWg0aeQV75a/-9L[1-:R0d6De,B
,DQP-fF4[86.aSZ3:==V6.X6Q8NR02-V/[++[32#?f7K2)]&+@^;+Vfc[_41:SQ<
4[fUZ]RR(<:5\3[JH0>1-]Q0.K/TVX0Le9SOL\L@QH+R;@VZ7[Gg2\=BAf,#AA[]
_\L)2:MgA#FZ0SI=H\O+G(a(Ja]a9YECX7TgQWE;^Dd7(?^N2+-3gM71SKXf#CO-
L#S(]I;?+4,e;L54(V4F,((__e2<7^SSK4Q_ZaLO.Y,a>OFQ8;e<M2b7JNg)O))e
RgARdg=W70HaJC5Q].d4<dZbG7_FQBe=,^E@P6,BQD6&5]f_Y<^U.O>#3_5E+<,N
Ff21)]YYF3D[^8S)_ffVdBXceV6[Jb842XY000EP.g?<X0TPCY[8?<b;BI<Y97?H
,BbL51TE67\4gI&@6U8M-ce;3KA>W/S#)XSW<ZcMWN7F,A@D\#FO+,Kf9b+V.-39
@f.J]&1MCF_G[6VMXROH.g?/Ad94Kb2SI5g#]TB1I0e7AW1A9,,,M]J[8g]I#2M.
FH29V,E3:abB_HGR3+@T2;TKVaLJ=A(+R6N1>Z:W=9L);2ZMRVY-f[JfE+e.SPF]
@SdUDI7G93\\ZD,^HM>)9Nbg_B_QS;J)IcI0XRd@+,0c\bfMfbNOZI?^NYXed6>;
&BZ#M#(GVDQcLf&fS-:>gXCgU1eaK^cQ^^?c5bDM;#&)[)cU)[)3RF)bH/BF#;RW
36/,:g;+;5dIZbNT\&;QB8CIY17MERFKad\:SY1;-U2\d2/e>A0[RO+#(dB]c(S)
Igc4OP\W]\\VVW@P=)#II#JeG+e7K\SAXLJ1-<g&d,eV,PeTSH_(>MUWU^#)/JB5
+336HL<[75S,G]U5c5U=C@cLg8&C-3,=ZXJI/;_NI4:(2O2XYRZMBZ0edd7Z_f]c
0+>JA<Q4H.7@LBa)Z-WDg>g^M0^e2DFDYga1fe9WEGWFZLBU8H,gMZFCOBU5200D
1fB=_^f5TJJ8ZS:N=MV-<]J_65gLDDD4([D6==.f7&E8Id?URXMD?6D^[::ISg/N
YV/TFS;;L<2^M;5C=NdUXRZ(7^,19[&[Xe?K#gUA+C?V<dM4F3VgN2S9Uee395Tb
E+,TbI/aW50=HQIV1)DN3WB.#UeYIVG/^Rc4AXc/FS_83KN_&8EDJ1;WFNG>/?HQ
0V23/,H=4FHZYBJf&JcG8C[=B,],dZbTd+8Y=5?GUM=aNLcQ:F@8<M@FD;0VJ-If
HA,V6dNb3(56S,YNc1PFI8VAD(DSFATgf4d<0.ZD=4V12Y:BbDRJZYb\N^783IdR
^ZY42EF>J>=4\Od[(J+^JQL([WF9RFCB:_7H\>T;O]_87Y=8F02&L.Y08E:U(NFb
gP[3<6gLCg0Y[E#T[MY^c,D7)+.(LO6ae.>RVE0BS[Z:_K;R_D3cABJ=d5P#_AQW
-[,cA[Z;,MQ_=dM2WYERWEO#b;8WF7>]#:DCOdX-L.D+gV_7#/SfU;:[T9afJ++1
U?E7RD_QMY;bET)/6:4aQ&-\EFeTeFNU5;2KK4,H2CH<DYU:N]U<[F&2XC9>&=I1
bBTM,^_9Yf^DRD4J7_#;0XN3PGX>J/=2U.)JQ2R1<>/^;cYR]Ted]&ME#A9VFXW4
78W9a[]:BcX1P2K7-#LG5K830P7CHDS^ZHP2I;+P<dK,&&<ZAXN-cW(F3>:_BFQf
=dK#C0OCDOGXd:cO[,bBa_YD<1^d(bJEC[Gd&g4XHd@8KbF??c1=EeAID+7-6WKQ
?-ce2d^\)9AA_;Fb_fZHJU@CfV>.M1297>6M=g/BQVMQOJb[>+?cUR,7cQ[:(Z51
L7Me,[)L9H6Z#9\41Q]7=V6>cHX(J.+ef?a+3R1VC54NAVZ,A[.ZN;0Z7<Q\I]Z)
Oe&Ic<H4^D,JLZ[R];A?E^)R3ZfHQ63R:EW?ILTJBB0Oee.GcX<7+OBG^4ZfB&eQ
eeV-\_1EFM::c:#R^>U)\=,ZQ56&S\F=KROQ=g<ae3M9D80bR7KD)5],4\R>D=(/
\6a)UY^A0(0dD[<9b1T4:4@HB,->)(QdK\POQ]60G5L&VOZDWN.A2)5T3,ZS7PDF
K&(;]>6GF[3d4DU7KMd6T9f@B5DbSfI\S2ag6;YQT^2fJ/^A;GGI0F2C-YUK1a&U
Bd0##/=]46&@(Og]>A?K]QF;&.](K+<H1SB(SKH,CK3B32YU()WFbL:g3YKCKU2H
Y48;XTD.V,NdB6fCX[@435K1\?,E>;W^e=-g1\6+a8c/(PB5eY;5IW[S:Rf&/7GT
7PA#SMTcaK,B5\3MD]#)[P[W9cX7EKf;1d&4?;3DBPLRBYZ-RaN>\+B;g]9^@Xa0
#G>4,V9@-S>G7Y,4;I/6J1gZUM=9fX@<IeY-=a>E=&I7GP:-J0E@CV?FAG<N5V+3
D<OBId?FAZf+[ZdgQKM.,G&QP^edC/3d+<0ASZ78ec?SV=E@<b-P1YMc5aCXOTM0
c/\N\_YCH+3QMC95(dYfKb;(0]\N4[X(P^1G[5+0].E.?L/_1.GPL1D?2QI4J:N<
>>;V/#O9]ZJ/MQK1VG7P;eHYF?f-=G=1RKG-7c41VgN125?PXY,K@0;(ZL&Xge]=
0aONM+4KFP^#I(162d#/:6[AN^S1&=N9>5VW5BHS<@)F]I(SVS5-T>4@cO1#DPXA
)g3H@@bP>J^c8/?]Q-KI/-4UX6a##9G;e84H?8#@(VQ7-^CGbK9e?D14YMT/OG:+
\0R1B[L]&>;g6bU>bF6_PADL;CWSc^6>egc12<(<WPA<S_H/g?A+)F4AT/DI[5:H
<V(U&^ZXBD;A1-aL3Z]06)FH+.Ud?3??..V-a@[I<cIc>[BGc_Wb#=9a]7LWX^;8
J1G+I=2Sa;5?#UIWD.KI>e1:V.X-gB]^C]LCbBCYSCc79/W2&W&VK>,,EMZ#,TNC
&e9A-e;#[R:-eHc4a2]0C8<Zge5@&HPXZU#gV,58\U-3HD&0JU;@TMFGd7=F]>@.
D/#8UDd,X(9P,d[@R.75MH)HL4-fEd&dF0CD[=HJI9b7=f7-]ge:a.cc9E;]6D18
e]R4N[-[I6SW?6d+28+,gG[T41#/B.,[GKAZBY9.YQCZ@B+_fV58BIZN+KDK&eBX
^9SWCg<HA[6e+PGf_#bP[PRgb6;#^f_cNA)=c-LfR]QTb)XG>GD\V\JZIS(18CG?
LeS5ggIY,^<Nf&GF(9<5+[KKW[0@HOH)-S<F5R/)^e_TGa1.bBFOfX67B7>FF\IQ
Q38OT^5HNP<b+KJFPY/12a-PbCe5(QI.7,3\^>J<gN4)_J0CQD+@(,\>9Q>T[S5L
QXY,RT7KeK#1bfZ@,G.IQaD7\e^V28,H;dEQEEX\LQQYbcH<5THM-:&V66.=PY2#
)ae.19[LOBbS2DFd2L\L(fEX18?D=,=L=^Hbc.BVfZJV-P[?[]+)UeB=1SE/Q?bT
CVI@eO/bS(G+N8dX\J:J4>a?S+Z>G1YS]NERZ7YXI:-2VKUW#B+N,G&f?d:ZT#ST
Ra^SP<K7R-\eOT;=396_+):BPT,;Y,>:M]eO3J26Y.d(K&;=QR[4YJ6016d_B[#f
9S)_^&GXR7E-T4.NOJU/[:aS[)_G=81J_XX&9Z_&EbQF>]5==5bJOYV5R_\;UISV
;fKC:F\;UD8#L1=SZ+Ne(8eH2=(Q85c5TD(6KE:+Zf1cZI#-6bUYe(\ZF0aY<fS[
Bf?)\[T)CcD.ZRbM44(,J@R/_A0VWHL\XL10NNFb;=dVES<=W3+Z-b2K&(b@UJ@L
XH2N38dgHb@J67:X8E2JHbO#H=5a9gKKG5)S.O-/(DF[>?G8:3(KF+J6]dIe_MF@
+=YLU4>S/WgEO61]@Y=:&IeW]e4MH7^8Df:8;Z^g.,W&/#]#V+)=MZA#?[0@G_@3
c0?bT,g<_M[NS/cbdF9MV#-(AW-N\+LL6PG::?D-O\?=I4?@/0>S)<Ceb_:a<[>,
ga)KW9,+We;ER&cUPW&>Le?bcN=53V3VR-I73V0X:^S?T;f=2)Mdb3CHX;//^&9-
69F&EB/:1JD-L>Ea-,.P;4]J.Of;TM<WG=;ZEM1^@&#b14OFNXN-cfCN:+;S_9V[
15_XS2)^0C.d9e&PV4&EG]P@JPI;ZSV&EHR,b=e#TM;&GA>AKM-RHRB4^ULcA9D#
]S3_CTX[E93#O+W2;T:.MZ;]GY6T-&P)]+,\TD&bd08L,V,=-Vc6g>0QBd<IM1?)
1]F3ZF_CTSIQ0AK@7\a=OKIYI,7fR,CM<&C<>-IHdK@,f\OfW2da]1^K,D;c4S?d
]I-5c2C=G-IUe;^+9f:\Uc.4MbII9;JNG@[aIe7/Q#BO_X3F&1SaJJO15\Zc\2)Q
X#DOfdC^2@2Y1eE^=>&,-I<e-5adRL0T02.-WRPb<d5?1M\@(Z?eX,N_B/dR1DY&
X&3VLX6a&#GP4B^[Y.I-Y@CDR)_NRTO#;O?WQ8T3^Y:3P/[OgCHB/UJ#5@ae5WN)
#3\+?^5M0/,NV.U0c..[P_Wf(P_(V+B5Z/3ASFdN/>V=?\Y[-Z.WFaUP4N)@O&S.
<MMSQ0bbgK1+1:JdIe<8V;\;-YL]>)T>@?=DVdZ?ed5N7dX8WBDRI59I5K27N@@0
UZ<EE#:5-N;5#]E\4cC1YUbO81?XW:gBXNgRHWa,3WF(<-]@E3<NVZJ+P.ND)?-W
EK5^DCK6Q&#Oc8<_L[Na2^Z(fa3YZ6;XeaPgbL2KBFPDUf1LR(])51M1TB;6ca.>
5A\)TH?6d9C_9MCL>Y@UNFG,/Y5(=NU7.Gd:cJDYPM[HNP^YDCQe#VA2,#0FaPe;
@bGBI..H6OR_Y=YL]S&7+bFQT>cC0aRf45S4U6M6KAVY<)#JW<&Q&Z9R??/Id=),
LG::.WdB7;>G@9H:LTdK[Ig+JZBP.NO/9KJ)\Ca=<[C\,+@B:H-AKS6.?YC\/)?#
K.V=fR)O\ag=K)P,MOeX4Z^3P9;FW/T0->OFY,\L,F5d5AZ9^,(SVOgC_e;CUP_N
K\G8#1JdO1G)IT@Ee]<Y5X41fT#C6gKa=RQdRe9eQY5bR/D3FN6WfWW?eI9Q^C=]
(Ff,/>BV.)Wa\04ULa86VE-.:FE.UN1?3+Y>fT@+Y2+D?RF&W3V-]8,f,G=Kb-<G
64(X_&]c,36T7@]QLA,1RTY6<^N+-UfQYC0+88N]LW2_&7MgU@B9N+9TKf,[?;[A
DS14TeJVbN2Ce.<R0N+Z.>K+JP.E/eb_3&EF]M-B0#+dI,=FM#Y8698SSWNdU7C(
U0a0c(XfM5F22@9XE?:S5,3,]M3Z-QgUMT?P,]0fOK07Cc,@<]+^HOXM0&75DeOS
a#TJD8Z9T\FgG0.T<T]7L6gHe\(gfOM+[E^dU?0\YW17UBE.aW#T,/\:4ebR#M,P
>(I38NIH2g>S/YGIUQU20#0&FL_U??,:[dN7DW92cDBQP3CYf?@3ReK@L2S]6L\2
R=#.O;EA[U[Wc[,YX9V>CP_gg_Z=L#PMY]2CWS&[D(=Q)N#&)21cC0EB-W]W4WE<
\[^T)11K_/OCPdff+]PN>R<6#+g188[f9+S;dHH?FE2O=gbAQ8S&d\c1f;DX1BVM
9.)8T</AgK@:J[TQ4cG=1E@9Z)1W.N5]ZSI,R5&aPN1R9Pe/c.9;#QJ)I9M5fcaf
a@<E1.:D.K)+2&-VNL4bT#]BBGfc[G<5=D_J_;NE##Rg)UaR.[9(\VF=6X6<D54F
6Z&KQ=cG\NX:(99-[abZ1?)c9Z7<VX-A_Z4STZ\FQ]PI>6+cKMd9JR\Od#:eefdQ
1gR=bf1SIO:0WH@3Pf=dgCDa./5VA0F5I1CgLO364g=3D</?e+RSIbN8SRMe,d_(
5+\V\cXVJ:@/8IV2[#0[#/70g^SI,HZ/Fe;c80T.BPOb@_<#IQ>8KXfe/Se&Kb6U
,PW[0MF9Cc2F#H=cV?Q-3\I2e4gf..IK)I@0]J5=Zbc+J7D&ACe51Q3)V3IQY0g<
6BX9010Z[)PaE41PIE+][0/P1V,WNBK@#J?#-_RDNZ9F4TcOH31CG>E&a<B]8?SG
e:5FCYBJYQfS<P&O>FF5_ed\KUP772b9&c_\&XVC>R:?9cF+C:POFE^+/BdGOdK&
F)KM<fb^+&gR0MSVB07=P37be5O/+P#Ja-fAfO5c^G)@W?=@eH4Eg.8cH)0H74dH
)cY)c4UKAeM^;N,@K<d/E+IeN-<cKd@?[1g84BM.f@(E@gYXORUI=&S0U=O4f?\#
_eL[])8&eMAO\R<+BFHBe3gJ1U,Fb^(>B#;IY8>b,0GOGWaXP9Z=WF.T_L9(K:=1
A^\>/K,.>)WfE.Q.88Ja_I6]V(LCTQJ?6L/^XVDb)>?eR2/21T)TL9FY,>,:>R2P
_?JH__dCb61JI.-J-7-+NS&_]XNdOU&@A=\P^0gKe_T9((:+]&LK44M5S#/N0E/9
e4OHN@_6T.W/-WJI5GgG5A-YDJ2./PVR@K5OCMSL;MN_b&M?L]<YQWeU=b@5[VI=
-,,Q+:&@=5:GfEDQaQ8OS]]#523KX_X)UM;7\DcfU[F=F_=I>STKdXUY7FQL:bcN
&DTG?9[U.>X?(M/5K#(,Zd(IYMWPTTg9B>a9Jdc3fc?:(\d9RMFHJ2L#Lb<4&)7g
D7@:^#0F@e97&.Q/<A]W=J>(+F1e4N9e(-DQEP@@c<Q<#XSbL0_L?B.b?Y[^7,76
Z^LEa9)c3Y.95//+DJ[71KHXT9FQ-Df85XfQ?W[eX36B<aA+fKeM[d&8[VGgCH/\
0IH82J@M<b2>_QRF?WXAW_4db0W+?DP0MIJ>/SS=F&-^gT0[?^:MDHW[VL:g1E[8
L4a9E,W85a74+TKJ=7BX3LC?N1SZ2K;;\e9DM^,3O/.2V7JO[&9+[HM#4BC\IHcU
\Eb4-gd9#&a@2D4O]\<@\,B.J(#_<IX64FZ2@>aQRB1c^2J,UXBWTO[[IbT<9Z;5
e&VEAV327aEUAXN&&K.GgT&IPT7-&_I@5(g6,LFR[35C]a:e-,+,dKgQI^&<M(W=
b&^c30>:GTL5P7VOMAIcM[?YAV8QWc<)&2e;;bI.dLEN&)P0-8PY4&)]6QB;8Of_
&2dT2:&8_#CEG#ZPf-HF\BK^(BQ[b5XH4@PKe#HYO?K3MPFf+/5OA4IM[I>?\XK&
dZb463L1a7TJ2=G.Ob2=8F3ed]2>c^<+[\EF2&/)Hb-U?-5dW2,Q4;+Z9:Qe66BV
20&g;6(;3N\YE<OPf]1QUSP+^1G.TQ?/5-+@GIg5HS(SBaObSKLIX4)SU1UN29f8
W,Zd2Q3,A,aJ,-_B>O1)H+_5+W]cV8(PE1V+M1.&I-Y)MPLQ@\,;3N[7Xa?8.XK9
;e-A?T/\,QfDg](3K]X_?R=1adH5#\@R8gOJdQY5JL8.QX\J9U=R1.I:19F3R5?.
+&:H-74>RG]#,TM(6;8d386(;+-/Ff34:__bC]bUfPM>G#XSQTX@V_B^-)L[1G8(
<G8DEcB/WNU,_>F[X:6>_#7?FDa_bCK3VPf5XR&e,,3;aCM)PT&#5gNcY#HBeBQe
4F_L_JK6-b5Q,:H<G.9ZIF?P,5[8;aTEf\>QdJfJ.^>UX]1c-X5AOG->A,RgH.FQ
e]GgFPO<0YS3ZGYZJ=/eJWe9KaKD^;(8?DQ(3:Y)1RIGQU/0QfO0QeO#gf>9811)
L3RJ_I-N33=]_W8Ma3QS.N7&#b1]]HAK7E\.^H]A+#FePD(IOc]HDU#MVV.DW+dL
0aES8<Wg(^Z<-10-=T.3=fIH6YBFIG/-DaXLN_6<=DX5>@1GN&:W#)W)7?UER=WQ
G:40QFAS;Q?@,Ca.=aIO40a1Q\YbQ3ERAG>D6#\8PC&NA(4=31R5WE]6>RH01>/Z
&#G?UF.;[>L=0C/>T:Z\+&CdODV\@Q[,4agH@O.-/BEYO?5OMI]/d-H?W&CMdKFZ
BNf4[33g7-8(PXI[T7GU6J+5+Ed=b>L4KcD9:5=3WM5Pf,G<DF=0=A:@LUT<6eM;
f=._A_b]FU?g(M1K6g67Z/@bM[35B6ZgC=^;\aG&3J-((.O1-Dd5&L@PcOJ/E6,b
aXeLAged6<,#>(dTZ_FC7+0\=aI]&JROE_^YYJQ8<7IZPP<c[8cJ&XJL[4MO9QAW
L&5dHe<)@AS+#8/\a(E,?V;^f9#U&6D0-0SMZc/J[FMF;GJQUP69Z+aJQ?KNBMFE
9fd,MQa)VU1^4J&HP:9_U/EI96=:+W_Q^1I5^=]-ULPH.[V95e_;9e3^IGe)acFL
a;O^/aLd+YeI@T.Ec.5QOA#0F@91.?Q[0NbYBA=K4^gPg/\f[^M^34=V0N@CGWX&
LXG/=R)MWPb/R1#[6+.dZ=gM(F@B]Lc+TC#a]4BfRNWe2Z975.UZ7LgM?^L;0JI3
O;eDVX@^#,J.3_T+e:=+<I[]QX799RYaN2g,FJf_=S:.eM03Ja9bJJR^FWM+KRfJ
Fa3D.=6AW2fQ)<_YU,eD2]K._CeD;JH^CL>+_c]9<NUg+b(UVJD#KgfW9=7>Z99+
Z&E+QZNRfDf9>2V#S<9fARg)J_f0-&>5I_ad1ZaJFNI3cAMVUYJTdE_@-D=e/PDS
(dKT@dOAL_a(U9K<QE6,)N)7BHbSFM(YO;QBDQLDLH3KW>?I/bVLM<IB_M)e7\V]
_NY^Sa\DQS4AAM(#CdMT1NYLFJH(gMVG8&8(SZ<F5)(0/NC\B[UOfD-C(@bOYP#F
eZCcZDL.)0:Q:VF#5PPC(8)Q&7Ee1#@F9g(5DaVYWdOAF+R>S6R)WbZ.U>Q8=GG4
3f-AVDaD9=&@M9V?49\@70c<[8=5;0WfLV?<[Y1]&e,U)bHVTS>\)9(:0S[cC4H]
7?<.A-ZdTJNPOT^JT/FKI>\W5H9dI>Id4[DHN91RM[;TQ):>MVecBcVF+EL7XBCX
TC5^A2g+?AIB+::gL;dSZ3&IbJ]U,RWL>G1dX<5+d72&8?LTMf(4\UF(UU-:#g)^
#b#;<2@6+#b<?5LbQN<6Gb[Q/AB>[@5()M^7:a_.Z=a>T8(d2Jd?g/;g=AbbCU4:
YaGF5dCfDbEc3+EZLW#:K=B2HDOgMg@=7>4LF-TNIC:&C/Pec;^#\^P.a3KR\b(7
BXBa4aBQH7g)bPSCI,\+Y^<fNC;f=E,5/-1#QgT2E6ZO]DD<da^U78W0BCFS717)
CXfVa^K&7NQWd#Q(aR)&)PdI=Y5AdX^6+TOP4/2GW9;6Kd,acZc#6cMRO:/+NWf^
XI1(e,;O?)d42,SS^BE<_a0^(:62)DP68<]G]MBK4YZD83Q]JG3SQSFF69\K:=f:
T?5MVH)YgTg+bABV[fCG>EUG;[KA;F7d4L2Q@#P2._.<GPBY(b:IbYT3/TQY;MXb
R\>eccB93:cKRF_ed#37+/^D]9ecMUE9/(FV#;GSI\#df<=)U+W@WO3\;D+fA8GB
9NIIAL=J8c(0>&;4YV.(HJ<PCPOT/T56++5&IaK^F-Z6PT4B5]bc[57/^?FR+(Pb
Jg\^aC\6XI5:]dDSHA_Y8f<IWUJgfead0c(b[E,:-W7CfV\AQZZ\45aCGLC<TNE&
]JQdFP@&2JB3OF;[-(\4&cB2?T1P8GXCTA6WGYLH#4O-0eUeL^(Z-;c3DVYYLE;W
e^/?R_0DM9NN^KH^e_I1A-@B8+SK]E_,_EO[STRBYBBM3OB[&LC1I<MEH8&?)?]+
U858MSA_U2XG-#6U^T_].M;]9,FX,@/U)#afWCT>8^g4WD\32<<2U(1I3_.B87bE
e-H)/Q;B771Z@^-]>c_\WCB5KKOB/:89F9&.(gQKY2I[e#?D/;2-^G\<Td^4J,YF
4UJVHDa6D/;Hg-4fJa7-KDcT=fS3&+YQ<=]<<.G>Y)6N(c^Ag7XeWS6U60B8fG_A
H/5?MF=d3@OBW\MRWaQW4Y)1;f<?YJd>&6FM2B8C6)N(\gMeP1g<A23SdG8O^>H[
D/P#(L,#4L]#3,<f0P5#@-Q)8bZ&W<HFLCGA^Rb[]Q18Y^L4S-_>&IZ69V?CJKR2
7EP)=H&>BK4d\912,A=C&8F\(6gUG?(V+?N><&@QZ[D^L2[F8UP3TFc0?PC5/_N4
:K;f;K9.dWDRf,R7;/].80BVITV_Q<f@Rdc[B;_71TdU<C2SgFT#HZ9,L?;.-e>1
=D9\gfabfOZDK(#-0(4]c/Z5=PY9IC:\#9MV?Oc-Da3\f3E/Z_&XF5QC2<)_c(\@
?V@5AG?=[GLF8EU/;R5M6_D+7YW@)[82G=/H)7^;D4/;][]N+@c+bE^,FT)W]DEN
,XK=6PcGT943RBE6#LJNHc.Te2.gdGA9<LD2Ke2DHM5_b4JRQW2WU++G6g\Pc9H@
W7VN4gd)IEW31+]dU(I#U3^aOcK9,Lfb2<IJ4&7,F#R=O_bLDZH(\0bI=5Y=e\^S
@C]>+(X1<5AT)+1c/B6[1eJ0ZTK3=:#I)UJM9=J0W^I52X2,aIMb3\3E5(OaFF&J
Mb.Y9,:g:NWC14a<(Ed.W)Z8[_dcNS_A@>4(P6_70QW-Ade@\WBL/>K0\,C-9T<b
1?V[KFLP<]/_.:5RP>Q,Nc\_,23B\TNe-XT\93KL82+F.a^P)/a38-Fa5\bM[U&@
2@gU9.[:7fZQ_c3>F(]TOUPG\(;D8CC:X0:E/g4Z^fd\GKP6b.+aZ-1>f=\Z>Y+I
LZ:LY7Q?X=YA))P8c:[J;3116(U9@-eS/g:E>DU>-c5S7)?4\=.3^X9J4cI6I]^?
\?EP4BfaK?>Jg^I?0I,[6X(/43A;9?^Rc01T>VNO8VR1E3)6OQ>M1PO_0J-.\c__
A_5])7O@&I_->O.9-U/MB0+1&UgfFS&]/U5EUf#7]/d5KDDA=/@=FSLD(K+7Y-6+
>?gU?B(KN/)]DM)K7f^]gH#@/3.:RYBc0cCFI]86_+e,#WH;#2GUg>=)IB9Q[AIP
J0I2IG(1K;RFN6[Q)I<PA]FHA-UBDCb^?@5ADJ6&V&[3EcI?1)&TdWG<XY;)g&W3
].#.+=<N9-[e30;7bTV@dW.[E2[[IAG4E8;8=KfXf0<SIK<=_A&RV\ZJeE0R@He]
J5SHY3N^].fHVC[ZT?;X+d8b;-/CK3Q.(61U[BC](?LL;HK,YU&0=LDJH82?)0FA
L,2#M.+-3V,?=V7VbPZ;PCX5U1S:&<4[UXdCVK-&QHAF>:FM.@C>cVFQ8L,AZPQY
ABY&NQ0SMC]1Z(&&EGVGF+S\9Rf:Z=IXf3TQ>;&AS@Y^X@:N4+LfP(Y;CYJ(=OS@
0)TU3MQ?#6J813#I=7:2TW6W5WO8<F56\^3X5EeR(1Gg>;DP]+EcCL0M6>bgYG&7
]C<@_?E30&D1)V0E-/D7A-H#_6Ld+RMPIVEc5A55+b5;^-[ac901F8#8]HQG)^32
;;(+9R1H)@eb[>3?VR?BQgDEGe?g66_]aH_^[KTLQc,8>UVcX\GdB+S]/>FCS&Tb
Nd[TT9.8e&:g[5HB8.L;?#Q?EH:B&W4YG0020XP3@Z<4Id(,?6F55d^>7MC565RA
_8&-5WcHaE)SOd/1.>)(3I\NC<7AEeB:>K>VH2]J]_Zb59URKO[8LE./V]3A?4AH
Yg.#COG[Z]EbKUC#LC4ZZOFG0U(-6VG,\-7^^[2>):R>4=W[PLaFfTU<bEa9OYS_
Rg.M>CF+b5)#<X?#LHMWH&f?:45Vf;=cWP;W0eL,G89CZH+=.e7],eKY(;K:W,8I
d)]T4=CI)<1aY<<1?]\eUG@S<Qe_5-Y\<8IP0Y6+,S)S^LM(5TXX(/>6+,D+K:K8
I>V8WRS4TaWaIT>AbS03(P>Dcc&c8]g;f7Q&JP5QYH:,C#]g.I@OBGaeF_1a^L_L
=6E7^gAb)cFXD].33^FN,,^FaIAFd1IXgR6[:0#-R?ga?HVg8C#?Wf]]bDb>HaPf
O_KbbSJ:YC,\I#F2@=Be55a&<MS@(IH\AbIJ=L.be]LE1UF:5)Q,2\_0K_C+TKU<
T=VE_I>/^ME3,)?/K&HbFABFDd3E=TX=THg2+7M,7MU^U/4GE[B?D])+3c?g8Q(C
NC?G94aaZ+@O<P1[:(b24/4FXMd)G^bQV]=a@1NSM3,D;A96I=:RPBe=;-@AUK3b
\b/UCIbJS-ZAaCEG<T)3Y<[M@Id:X7aH;-653N6[_WGRbSNJLVIO_Q\2ROU@[5X;
?g4@gV)LKg#Q)P6Ta2,:DR/),FS7(<a:IggDDJ\S0G[RaM4dMaIQ@8NN:7d-b8Q(
(a,gQ8Q:XZX)IW7NZfR3(<R48=eV:LMYP;#25Ge#Tg<.ge.@:XG_+e+FO-/2>e<5
,F&U[PbKYU4JW.O6G&02JgKPc1<)[;b^>BBc.M6233/V;G/Z6PSO@d4f.<X^YC6,
>;@?LF:(SD3?adS=P^acd@=Q=e1YK9gHHHP?CDU(c0:PdFMZOKB@@C[aEG#=E0A(
PXe2>B#+07L._;?<a),b_C(,^gaS0LZUYU?&>TT.gY\?e<6ZcMa,GV/Sa/fSB[R#
G8K3^,IW+ZJb2D+_=+K-^)NN)P#&0G,LQSW5DVP[3Z/QVN9<-0g2,AL\VUSB505W
g.0=M:4Y:5^OTW\LcY?)G0_,,SLa<\^-f&-UOQ+GT^4^#?NS2PUD+]LbF+ggP+76
0I</fX>b&\OfWJ-cB?g0)GZL-LNHO:[\g[1N10faL0VYJ:aTYI^@RNa-21AQ3Q8H
HbcYQ#4VXaVGF(+c=;VA79;7@E.FJ+_gI^\_VcNKed:-(5#^NP2[>7gS>;+g]UG6
<BZH^(Y^C6(:-RHU06AH<8[9DI:(7I_&I,(^]>._-)Y.7R:Pd:MJ/FPY/0WM?R43
CVe/:<+1>8/@:\aSV))ZAGEZ5L6;Gc];dbb5a01W?J?>_75Le^0^..FIS8X]K,(5
1dF0T3X_KV<-KBgAMFGKI4O949B3#G955bN^5aH7W1e5(>a)D3N2#e>c9E_E;D;\
CW;FTed<aO\Yc>Ta.]5U+_d-N<UB)]D4/MLL>d[MPQLLc,SR-VGS2J5?,QD,X->9
KeSa]+H\YePO..C]?QQbAQf#BU4G5R4.O6KR8V8?&&4fDSWAb=STTgg>=MJ#A4V&
d6F&cN@Z-=R11D>NB);e.g@E4]N&Q4fX+\>Q2cD2#d8Me?T5H]cbGK9A]gBK@7::
MEM+,FJY(=0B#NB)E9_3TN_ae24McDV++>IO2aA.Y7^N]<aG_U07BUP/\,^QGI:f
IIV\=Pf,R?DC5f<U62=)c)P1,V9a9;P<.,1]X86d,L^?-SB-#)ZY61?4RQ5^549O
ULPc+c/LEH(1gJUL,OC#6?0JG)e&-dC(bF?G;RFMP:J#/SLWdf@.HV.\c@b2f_IW
X^&(#LNE#&gBAH&,85[0b]1?K]#V=>6>/C[;:dU9^YeZTM78=/#&ecg9S.U0B)Q5
X9b.E>c,]Q5bJWaP\e-dA-J>J;?6=D=P?]M+9d_1(OcUG(QXC3]B.VN=f,^EMS<R
#/T)TC\;.L@Y4b=cB71fb.0X03Z=V=5RZ:<2C3Ef3dDR^_PF3W:MG)DB6ME61@dB
gG]/Qf3=-<gKeP/.P[P1C8fMLALL[e^U&EBCTgR\UL=>D=INF_dCU5I,:C&=AYI6
,.4+6cL3]CDL9_dMJOK?L/5UD<\_>=>YO@KCd;?^A@K4_18E2@TCX1bP_2A/KOZ;
;\^d0G-7QCAA6D3K>]CLT46APfV)RB(+6)18@^F3H1_3CZ&B_E((.Q6SN(G0f35\
9[UfMPObD;IJ52BYDB\e,d_O;gBQ/)>N+(1T^=c[4CY/F3;504_>@LX3.+5J<(O^
UA=/OeRWJ6Ub+)A@JUb=ZMbWAg1;)+eYF<e2.):LB_4VFWeRCdXKeK0@aSAJ3Y6D
47.LK=H[Hc1)L3C0N-_?AMXUF1NPdg9,X#.&7T<4RKdRMF?Z,O@e0.AXG50/X3@/
\V439.cPd,9OX\g)9gDU8>=Y.a04cU_#ERC;43^BP>KFB<d-Ha(Q<R)c&3LMDfCM
f0[I620N&J3D1QO5K/;LMDR9PSS6-XY>&6beY#F9Q?Pg(Z23(DM-P.8&bF58gcc>
MV,MSD?RG5@2J+>Sd/M@3TZZ0(&]GZBRUKgFCE]L3<NJRU9HDX?7(,E#73.[(+M;
YDU(_WPOOALNK<OTfHO(YS;CJ#g)XXW3F:\2?WU#:\^&^dDY76[M10N:H]eL>,\E
F6FF@(^LR7@?)TC7XQ(c(V..1M[0N-TK(RFRM5:>E9O_f_RO?d::UG,Zf7gA5^d0
?eJWR<>I68(6._MQMFD.^THf.WJWDcA4RS3F-f9f.eaM5U@E?b]/&@P2&)]JA^5d
VLT)X23U\>IHZ-/(d,bR49:-PHKF>b.]1&f\EWc/(865U5<D;F85?5g]G#>WaP\Z
V#.LEOO.YT:Ae7F@36a8&;6>4F]:VM&:[EF/O][)4_C.=:(2#:@^74/(Y5+Q,D(6
Ze>ZA76.O+F+PgR>1=N(4=R+8d/7)L;5Z&c:OF/P[U;8[1HB&bLMDE<8.0F(0.X\
:=VS,83B-I#?#4f@0/e8CZ(HE7C3Qdd6PW;.K<4JF9I^2PW1;J5^8&IgEab-D-S4
H78?_8TT]8,)/5GW<)0f^>FBK>e?<2XF_DW=#HSW#^A_O?[aXD1K3_,DWU3R5RMS
V?XY(C.eO-#)V]CdbU5H-K(]\eEPSG9.fA-@^geZTdf=T]2J4g9OHT.HGdf07Df=
A(Kb4PXKKB).4X)+&fDF1X1+I:Z:NQ7]+E=T765OD5ffYe#&,b0Q:J<326DIZDHX
+DXGH80Bf@D;.f&:^0Hc4_13>4cYT&D46&23:f9/O;E+XfN0#Z?W<cUK=Y]I1B#Z
+?0;WNPf?8EE-_8GG=SfIJ6gQQK1)CJZe>e@R>C[XYS<)9g5\V(/8+P,+aDg[8-]
c2a5<#EJH0]T<f+CE;D@32,,H5a#YET:IaTDQ<?aXbH2C#IJHAcSMS;26)e6T@8-
G]eZV#dPgCB93@AS+W[ECO\O+\]Ca0KcW\d,BMS.^CL:(/c7AFDH6b.VKS\0XA:@
K;HLKHA.G@_]Y0/QP6LY7Nb0L;X@:-\GaVVQ.^5-D[VW18NB;^WRcD_UR,V?816Z
E]7V?]0T+<@9NN7DTU3TNRO2)OJ&?S8B;Z#025^B5<3COE2S/MVb-:OP18LN<c(e
@CEH@;ANCa/+8/;=.U#&8P2:ISb2[09BOSV@0K:,Vg19=>/Uf:P:Jca_T.V)+(3g
BG\UgFbQRAH3e)+,3ET;Q-CUQ:46bYAA47.)4_Q3fEQ1;QW2g80QcEg5?+XL/JD7
H8fSS?1S)^(bAXed<bdP88OU;D?_9(S+I+]<fe;VYC5Q>KIg=ES^WdO5583aR@K9
Rc(6U8d/N1QeIVT)_(>/=;QPK-&9]=)L-.,13OK]GY[gAcKUHA#JBZ=XaEUV>LaR
D_Ud[=9-8F&3YeF4/#@HPJ^D]1A7V(VGM:@\4TM\/=GYR2KXN@?VY60-\H<G&L\g
Z1>TH^ESV^_#T@]NdBc^;bIIT&.dU]67&<)6]P7#2De4T=,CWG,>;]4,YDf=63HG
RVE>_S4W7.S@T^2)UJff=a1I-FEUU_Y+dP3AMZe#QNba^&gFT#2/JYfH.V.EGXK[
RDgId_eA&.K7L_\(dg.D9#^5?P9>J3)5,[1>\GJ6e)38612PeLOeW;P[2a44W0fY
8B(.(:&\a->90Y8N:RgX_Je[6C&[eI7^]OaSdIPR41+_<0cNCS#0a-HF,SMf;__Z
^XG6M&9c890+)L&#_5>STc.C]_TB<Dc4>Xcd;H23R#[cC\BJ]U6HE9AS,--^,84-
\+-\K-J)TG:8^J^d3f&bC3K?PcY\/UR_M3(c6e/:RIO1O:>Z0;V[.._5fQ)1WBP;
g)d4OC;0OS9dZ/3^RT?)KF:e^geJJe9X?BQN\MT+ZJb^Q&SIV/E\WK0R0MD5]8&-
-B1-@CdgE8?g0@W)(P:VeS<<)U#Q:9)<TD).M)&7e&=c&&VX+R6&/W<6\N?0,J?,
EK)Gf+B)fe#<^A8YcQ/gV@.4/aF3Z2H3Cgb<8L5N/a:8K6UXG7)O=Z2?A59d[TB#
e2<1X>M)5cJ6V;#VaQOW11RgKJRfT-OHY_-OR>:eVX&:Dd-f&3([^_>:QM];.K#c
OE,478J9T8JD&bB)L-1SY0C:aW-](2<Ve?I)8#PSdFGZ+OA84(9H2/ZgaA:e#IK/
TR\:)CdHX6+-&TGe8RW4A:P/^dYK,b)fML&&)41[KI-#J.Ad5LE;3Q0_aeH:2\;4
HE/cL-F]4I5WcX(7NJ5Z@cDKaddAJNP9KeS,-D8CB:4/B5G@=FBOSIXU<H8BPA^d
U.P.4.JQ0]]L5Xg>?/<X6R&N-RG93VMSe8ALCMTdK)L:YSd(g08/]/d&KPPX2d.,
LWgD2?_f_NNO.Y?)AA2,_</eC.7G=T@f2I@WBbdO&60]/UH/dgF/E(/+.>d7_J1Y
dgWALMIY/K>L-e@C:2/2Je_e>>L_\>GB3@4@-VdW011W;<ADBN6T+:D9Z1QFBQSY
M/.J4^/L[2WO)d^]gc=E[4]1B33(_M_U=:Ra2f1CAadTA19PV:N8XE._VOS#cXM8
IBC.)AdfQgOI44Mf2MeMFg/VZ;/UB)&6JH,KS+82J(CaO2[I.2K-1X^eHG)Ta\(,
Z[fZVAaKL=JdZ@8Ud?952>+=D#AFN81+C(YcHXGSF2[HG6>TO]D1_,5N\@9UQM@c
Yf6-;M\LLKKQUCcbCe,T+a9NK1UE8e);<@0Vg@=TC.C>_+#=Z@X+]X]SRc>G+>><
J&AN5[C,FPJGWIB]GKgK+DgX/#5KMa,K3W6P&A&1VFP6EB>3;c.dNKRK^,X##c8+
GHTGe??XJbPC1216A=<S:\MC+9=_3=d7,,F4,YCLP?H34Db(J8MMNU:HdIGBA.4,
gG67S-bS]R5LCe97Yab.^P8]YA[[XT7QD&?41bT?+GVEJ.WaL\_7+4=d7;U\ODI?
C#DQ[/MKL\1.1gV9]ae_EZ-.bI,&53[B:>Y).3KS<6=CA+^176aIQeC7P\4cPK=.
6-TEPATNZc6ZT./<S-e.>dMAe[<d>cb]8UBX@A-c7=UgU>RKBgS5&N4OWZ=WDf6?
ZY6[;>?)R1(+gSW;8,f_<KTaL4;H@U>3C6:8DYF>gAAY.304fY+3Ne8HVT/K](8,
2&OU-UV],ac^9M/9;,:&AK&#+UID+.^_T1_Tg9SIGDa0#-6)@3W55?)YHc8.<4&V
.g:9F;\S=X^]G>Z0f/527\+6R=8Y-QG>7#1fZBVc^HYUYK&^#;TM&+^_b+X83gS]
:;f56Y=(D.1gG=a,f4@#e^QN,\XdDHNB)<HE&&/@BG39G_X:65,D<,)5&fO5FgMA
21=&[HFb9.J^8R4Q-N/&LL8b]DKOID3U.Y&33HAOU;W(0A1^eg-YOONA0&gD@OZ#
819H[TB^ccWB;]MBC,SCGZUNI04_L@RgN;V&#H8DQPB?HKVadHG)L_PIA:CZJ7RX
+>MbcaHA7B:]MPP+@/3KOTG0T;N5I<c9F4J9H:R7UZ3R@FH]:.T]3-#gdAMaIVc8
J0[-PaFc5?T>PDAO?>Ob+=0Q/e[=a0N<F,DU;1.UO&ND6EJ4>TA)SJK,A=K0eTLV
.c09@G<_I3&@Ig[gD-56SKY>H0TV<:R-(\KRN^(&A?baEN_(Z<&FM,01_>VC<,f/
@W7LZQ@0B>3O;AA:-XG(MK:>bV9TCS:MO7=YQ2X<5YCT:+H:T[E.D\fRCW9)[I@b
bA0cZ:FXcJ2;S1)W;ERD?Z,3VL?HH@6KX-__GJU>3>.MLYFbOY+Z0;4=_H<:^A63
8a#DM-g#6Zg9&(1cAY?bP>5[ZA8^LVYa6H<eV4N[;7<7SDCHK+0/CbWT))(-\T(]
H(L17UEBK\K;LfAK/EW6-[_B(5=);>PA,.3S9P>RYGV\48g@G?EfYDYM=<gJ17(f
a=LG<KNVBG:Cb.26eHdEcA3(Cg6Qd?BPc_,Ea/I_^RHH&beUA:]WRLgQ+63SQ_Wb
-P>60]32^7^CE[>DOF@G,NJZN]\cGSC2TNYU7aCX-@c(JKe[.8:.HJc:^VaOL96Z
<[Q)7Be.KdSJeOHO6+S5Z(^V7&gYI6aVXKaPRPG\M^U]WC+.?ROJD=Z/Z_/1e??3
B_\<C=.CSRaF@S?AY((S8]+:XWaK7UIBZcdS_Q<a;\C1CcCE]15PYg.GdYRfGB1\
U,;@:\:fX[6g=O[V?eQ]X[F<ZN2@\/#(6f=5YMUP.V(UPH1UP^CH;#RCBO=PV3<+
_PG8/:E7N,=\0=Mg?AQcJEY75M7I>#,g)J>VWS5a[8_-TIT2Oc/c88\B[E?NT+GC
-O-[c79&M1daN6FD<3Z1W(MWbWaaBN@LEfU89ce<0:CG_OCK(a[J<8dXfL:\_^Jd
-:15BEJL(;2T\.bfLb:GV\IIT&Hg&aYLTMK_<&dO(59.?^3ad77-FQ][d2\/KZ0W
8OO@M](6dG<5If3c</G?130UT:J9TO-.fNFFY[)]C8N\K]BAJ3ABe22F(5NCL0K<
ag.(WeAcLgX&)?,V/U5>&I4Hb>aB^)8Q++_G6HYFIZSe>=b18,;;:TbK[AgY\>]a
@P_Mda2aQPMBE#QeO-)Z,5MF<QK+/R,YT]RXY=VBGO_a_71bAb0\E6=1@Pe<U\B.
WNHcXJ2bK7)6?#QTF;fD68fF;;9N?_Oe=J+_KE&>1WOT+;3#6RM\&_XWUC:1ce(Z
I51JVR>a)^G,-N-Z,=R_YMV-MHG[7U,5BUZM552/Wc6bKEQ/92=?&\I0UUKeUOJ=
dVG5a+YCB@)3F0R1+BK]=2b9/M#:R3Qe?76UTR<76UZ8^VM(3<Q3ceUe-.H.-&d+
UF(_S[He-YN>)-V#():ZH8@ZG9EB=1IK6Q7\?0-3>2TJ;[\T23/BERcfYQ37:Q7&
]J?cA8#/-)12DKI/+[Q;4/7@W_S#RS.HKc^7N+I8e6AT,)bB5KVVE4Re-(Q^R&bE
HcX>ae(G^9\1BP2BR28<EdZIU#dI5Jd0ZH_)W^FD[c,T=gFAKH?f7R-4fPW_/[O?
A+@[gM4D/X,81Fd6UfPd/E-FT,@@g7RPPGHC-,1A5P^WM36FQRE5RW:X7RVW9F?5
[a?XYI<;[/5W=NQ=GMX(GXYO;=GgeC3;VT+,;IFga9NdZT[X_D@bZ9S8Z:?b&+-F
N8a4(f66U2/gWV.IU1dVW_)W?<K5eATJ0e^+4E[;aFC1U8M^]+)B^[M<(BF=A68.
Z4bU0[9ff2Kd;9BR:UACa3NLK/T\AW_EG6U8;.c2GK5\L9d0b_QXOY#1N9Q#baEW
Ig38NTD1?#(I.U_@2/:L&4Z?[eJ&CF]SS9&eSY;R,bV&2\M9RT8;;SP,/<D9P<NZ
RL\DV=+7NXT?CO_G(3_K5M8PLE#LF@eU08+P@#90_DDaKU9<,\a84IgNDEJZ(U-R
3W]aS[9ae040&eJ#;SHH<QF4?dI/GA9&Zg26Y&=(6^;0W\G.7?T8J?^cO39P:^3E
/G+;Ua9@,:G2DDdBX=d;A[/5DGS^]<4<FSfcVc+Z>?9O:>c0GZI83=;DA;ZNcAP#
1DLT4Q,L2&S361;g>PY_b3cQU(4dQUQXT:dMe_5N(a2AKK](?-CX:DU82[6G,fJ<
=6aF(gg_-M,:#eM@>2#e(@6S<11.@RAR2D=C=<g(<H5GUd_K36@QQ]>_6X9a,YO-
4Y0.&\9bB6UJRPL6AEB-B1,;:LZa+EDP>c]\++T@9,AJ)g<LdJ=b24J4KN=I&9cb
CU[V=?I3^b6<FbL8)H55)GCY)GC(2VH,H9AKS0bC+OaHgEC@d<7T9V8EVC1Y_W1g
XT5FdH2#?gL33,gNM@cH0E?<<7OO2Q_D=J-aW_7f.I;M0&1F-]Q=gfc93T6T+]T1
f,O:059NR2O_8UK3/QgbeFFT\5LG?cGJbP?2))QZYR_UgC4P<G^+^>ZZf7]@42:[
-4>O+aaG;B^Q0Z]^M#/9G+VOEU.CQdd8/c@P;#_g/3N(DC())]:a).g?P@/2UZ2C
[@KYXfg[c07JJAV0BDTJ.]W_gCKSYO@>^OLN]AHTEeX#070\0[dIgd<3<BGB9?E)
_Rbgd2_J7Y=I0)&X=B&9b9;-cDW#SMb5XHBLDb_Z,Q/Xa\NfM2XPCfCRI@UIW(HV
<R1&^W;X_.9F+>DI-gD,]A@Z5VJ,_M\XcW3<e>JW[FOC.=2W>F\S1B8Jeg7=EI^B
Q<9cOU&F1<+c/6XCFf]G)LL#4VRX40b^fP175KP--4WPL(&^ZdO]C#D-4^K6T/,N
dH8-#a?)[AETS:K0[Sc&4aJ?.K@]Y5,cQ+6XC,b>X#N#1A8De&=X23B^O]U7CFDP
]2>I&\ZK#2:]/ZF:\H/eP3Na(-5(R_eFA);8NW,XH+4,3P^>W0D4)>);33<9@=@a
KE\A(0<UOA\_QMEHT4e2KF<LUPFNVWP5Z9/B8KJ5I?.gI7;=^]MKLZ#AgF#f(ZS<
bFSLa/2O4YKM;)2&(GN@0d?ZQ_HQeG4I/6Bg-Z&eGG7Pb@\d^2ODI@JXY1P/GH[,
W[Sd/dCb+.0X-.eIgWDe_R5_bg>4DE]FX9EA?S(4S#PMP6201)dH[HdVaf77?_G-
)B7+Y1<5]W/J@)Z4g>OA\I2V<D[G2IID?_cL,M#PLEL=_6&9D9c<6g.cUOcG1VaN
/fY25[c.?E?3fR&4ZJ,,W1@I0[#TXPA(MACQBBSC:@7UUf5HCIM+8,D;geLfMYFH
]8E37#MIB-PR39<K@TgL1bA)IRPXF0BPOVDf5-\:-1)<>3VB>eZ&8O]@(.fWWCBI
3H9ZMM\I#<fT(da8b,1MO\MX8_QQf=-27-T3T>-4GRUaCS7Y++^A_Z#=WMCDP#U,
>=cM:9TP=G;9?RV@eEXdGc9_EOJ>#;\&T.5[NB]1.C^f>Tc\b2;NDPR=FGa2&-D-
WMRZZ_7LPW9Ue&G2b1G@:I;Q)3,I?]?E/59VeZP)&RN4@II/4geKb4#1gaX)TJQ(
9>5PVY@Vf5GUN<8:Z-DN=>+()U:bS793<W\26XCc+X_/F7\=&/N0VaCLI\6)S9+c
0T/;<adgc_Ca_B0e8?g\H/NS/b^(e12I=CYTO<]]=A<>cEDYF,)4JLN-J:I6@LO=
2>VSe1fFFF@2#Mae2OF4DfB1+D+KK,T?WCf6QNMHP+g4SaB531N(K51(8Gg1QG.f
:\5D4_GFP[_B1E2#O3fW:)[H9X,_J1R4G-K?A-D;+]5UGa]dfLJGa1,P9LHO9\DV
Wa9<<e833#aADH()09P-BMOY3C(0J1aJ\a.<F5FF#,,SA=>CeJ3:Z2PVMSM/[J<R
G+_?K6Q.^^^&V(U+F&M1>.-FSJ>fDFJ_RE37X_(7I:WRWaQJXR2,HMJ8P(-:/6(K
XgIPZ9F8fE2>)\++\WfWU)+>5V(SW\YZ09BbfNIUaF,PDN-L\3>\\XYL@^FaABOY
-[G,3@^b1I@I:G2P6GG)<=PE;GOR:8HMBUCV(Gd<8O+DTY;650C:LN0;dccTE@+c
HEG/Z#-D25g2VUZf?:9M?>.+]Y^IOfUd#&2+@@2HV?QJd5)>,g/+L3J,cAJ343+3
N2_9\)1:DI?J54gDOVX6K(2f,(+d)D/O@V]76:2,60gVY]#1IZ[95TA@U9e;K-fH
M1ee:Q2B_/a=e:54\ca_N0bL4e>)D5)4#-D.g^K2&e25b:,YLXeSGedY/SXSd_]A
>[04.XTa8R[T1HOZ\8UW)-/+-^Y\BBEf((RUU3>#dN?JQ22(-3M24H]9/B0OcTI+
9,B.B#?:AQVYSZFAS7WQY\IPE_1e8L>.b=6\&AI/Z__]Ee,LE>\c@JbZ\N5fV^EP
H55W:+aR<WR[EIc5UB[agAfW6J]R0C[^8R22F?TQYUa:g:c#C)T7@SP:=c2?RgBJ
=bCc&>R6GP9GD4f1/&KZ?V(H4Yeg;04:S]\\8G5I-+ZJZ/;7[9ZVQ3<Kg/J1gJIX
@#BDKDS8Y5K82+dAc?,4U)1N#ag=8T-9(<KSTC=XGTE+AP=7[8;L/dCH2E<&WYCZ
5^TWY44f_AUY-Y]V@42JOQ_EXY@XaB09)5?aGRcS.2T#I0H@Y#9?5@fRJ,fgEPd9
=a+72>:HOg2GVUX,QJZ>b=M8BFPRG3?&J/-fae^5IeD+f[Ea)e[PR,M71I3J2\8F
YT/3a[bZ5PcL&SVBVG;P7GT#Z2_O;I8L+\J]()U,R?(-dOV3U-SS^bAe=GOe0HHU
U1bE3_cPXKCA6&+SSIB^(64X4+a.7A(&?c2DC_J;II=R5P-5^L:ZH6_A,V=80aFA
3734R_GBK#@gdX7I>PL+(:4a<U2E-44Ca8#YNY#691-._IZUT&/>2Yf9IfZ0fO-f
5/28BKC+T>[NZ9KM2cd&gJH\dfX]4I()d@-6WYHXUTg,IYfUfQJ@ZSJE##=If@?a
=b#LI.cMNH#Ddf_7Ka3AP_[\Z0=PdG-V(Pa:V2@8#](--cIH-3]TEZG\T&)S0P-T
#,W&NW6e?HF,DY\-=E2M<F_XZDT^c[abgJ)VIYX-B/A<;f+)O]FJPF&@51I[2Wfb
YAJ?8B?+b++fK)KNa[2Wf@@#d1=A7]MTSY2:c208FJWCGAWZ/P967C>gYR]K<^dI
\SB?3WIS=aU(.KWe?c.Ua,UC2N;OY/X).&1I>,:^0<:=GPaP1T-[(=2#N^gNN&(5
b&?8<-c^[8DUGR_W4UHVQ+\R(Mc_YXNOG=,>2@]7KH-1CYd6?0^L_,@gagZ:6T?R
c0e?5W2)0ROMNW-X?#S9]2.f/B7XRf&7>T1_]cP,DXEIZLT#fTdfY5/WIc-JS>cL
d7)9U2-8ATIM<.^X[?A#P1F]WGCBKR[@9:OC^L&C)BcG<IN[JAHXdFK-EO+0GCRb
&EC7,P93^71ff;^Ud[b09QF-VUFU^2>)J]NM_K7(23Ba-Rb-(0D5TDDKP,S83(ER
W1U>U>5Y;-LUS^BIX(=MQA<_c2gBM<465D0]\cX8&,4GM>e.IU(a(801\f7FA\7C
=Z3L=HTVIe#2PJfLXfd(24d8G-+P]9c=P/B2(AS(76/-07H4A_1[<)=-=fV8.3.;
M&Y1+-&2fE8;ZH7P4)&@+>18<bXR^<D#S;I?L95cg3bZSa.C+Wc1JY8;X31T(]S/
L@bBI5C7AN=52#7K.Z/;_O/7Ya5Fdbc2)@3Za+G.>8W3F;&7H-QMHKE6?)a=YN);
R_WRQ0<N^f;F@bO--fRO=0]7?/_J(R\=eYf(0OW=fd>LUN,#(:\0;fJSLO\[23RT
NRZ?ga/K1,>&0)Va-IRT?4BN(eA3Tb:9);A??6(a;Qg;EF+[YK)@1;:eBQWNDCUF
&.d=0=V@fFHWb]FGHA[UI8@f)@30;MZCJG4?e26)e2X?:gP>cNEQPad?/#XDS<[_
F-WOE]E(7gD5OTPBXH4,+<7?]GHg8N5<1<);2H_5_;IbJdb=R>)=ZGT2=S8O_KRg
+&+[3FM@_+F,ac^aMU)aa.Q:L]FVO-IWWFgbM@TD)VO3Y3\D3Jd;E@NF0TUQ04?a
>RZ?YD+,/3/=X5S?0b2\M.=UKG(Q(-QJV\92941aOX^Oe4/8bQ^X&7JI__RET,0C
=J+R8XQ(<HDPB8/NV7LK-Z;+3^8g/J)PX8#7]J(E0=8]OD3.O9VW7?G-0MGf./[7S$
`endprotected


`endif // GUARD_SVT_TILELINK_SLAVE_TRANSACTION_SV


