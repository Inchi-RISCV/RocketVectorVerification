
`ifndef GUARD_TILELINK_NULL_VIRTUAL_SEQUENCE_SV
`define GUARD_TILELINK_NULL_VIRTUAL_SEQUENCE_SV

/**
 * Abstract:
 * Class svt_tilelink_null_virtual_sequence defines a no-op sequence whose body()
 * method is empty.
 *
 * Sequencer: Can be used with any sequencer in which default sequence needs to be
 * overridden with a null sequence.
 */
class svt_tilelink_null_virtual_sequence extends uvm_sequence;

  /** UVM Object Utility macro */
  `uvm_object_utils(svt_tilelink_null_virtual_sequence)

  /**
   * CONSTRUCTOR: 
   * Creates a new instance of the svt_tilelink_null_virtual_sequence class. 
   */
  function new (string name = "svt_tilelink_null_virtual_sequence");
    super.new(name);
  endfunction: new

  /** Need an empty body function to override the warning from the UVM base class */
  virtual task body();
  endtask

endclass: svt_tilelink_null_virtual_sequence 

`endif
