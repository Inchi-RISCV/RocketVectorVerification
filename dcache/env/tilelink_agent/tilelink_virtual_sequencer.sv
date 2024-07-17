
`ifndef GUARD_TILELINK_VIRTUAL_SEQUENCER_SV
`define GUARD_TILELINK_VIRTUAL_SEQUENCER_SV

//-----------------------------------------------------------------------------
/**
 * Abstract:
 * This class is Virtual Sequencer class, which encapsulates the 
 * agent's sequencers and allows a fine grain control over the user's
 * stimulus application to the selective sequencer.
 */
class tilelink_virtual_sequencer extends uvm_sequencer;
  
   /** Typedef of the reset modport to simplify access */
   //typedef virtual tilelink_reset_if.tilelink_reset_modport TILELINK_RESET_MP;

   /** Reset modport provides access to the reset signal */
   //TILELINK_RESET_MP reset_mp;

   /** UVM component utility macro */
   `uvm_component_utils(tilelink_virtual_sequencer)

   /** Instance of master sequencer */
   svt_tilelink_master_transaction_sequencer master_sequencer[];

   /** Instance of slave sequencer */
   svt_tilelink_slave_transaction_sequencer slave_sequencer[];

  //---------------------------------------------------------------------------
   /** Class constructor */
   function new(string name="tilelink_virtual_sequencer",uvm_component parent = null);
     super.new(name,parent);
     //master_sequencer = new[2];
     slave_sequencer = new[1];
   endfunction
   
  //---------------------------------------------------------------------------
  /** build() - Method to build various component */
  virtual function void build_phase(uvm_phase phase);
    `uvm_info("build_phase", "Entering...", UVM_DEBUG)

    super.build_phase(phase);

   // if (!uvm_config_db#(TILELINK_RESET_MP)::get(this, "", "reset_mp", reset_mp)) begin
   //   `uvm_fatal("build_phase", "A tilelink_reset_modport must be set using the config db.");
   // end

    `uvm_info("build_phase", "Exiting...", UVM_DEBUG)
  endfunction
   
endclass : tilelink_virtual_sequencer

`endif //  `ifndef GUARD_TILELINK_VIRTUAL_SEQUENCER_SV

