//=======================================================================
// COPYRIGHT (C) 2015-2022 SYNOPSYS INC.
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

`ifndef GUARD_SVT_MEM_BACKDOOR_BASE_SV
`define GUARD_SVT_MEM_BACKDOOR_BASE_SV

`include `SVT_SOURCE_MAP_LIB_INCLUDE_SVI(V-2023.12,svt_defines)

/** @cond SV_ONLY */
// =============================================================================
/**
 * This base class defines the common backdoor method signatures.
 */
`ifdef SVT_VMM_TECHNOLOGY
class svt_mem_backdoor_base;
`else
class svt_mem_backdoor_base extends `SVT_DATA_BASE_TYPE;
`endif

  // ****************************************************************************
  // Enumerated Types
  // ****************************************************************************

  /** Pattern type to define the default value for uninitialized memory locations. */
  typedef enum {
    INIT_CONST = `SVT_MEM_INITIALIZE_CONST, /**< Initialize to a constant value */
    INIT_INCR = `SVT_MEM_INITIALIZE_INCR, /**< Initialize to an incrementing pattern */
    INIT_DECR = `SVT_MEM_INITIALIZE_DECR, /**< Initialize to a decrementing pattern */
    INIT_WALK_LEFT = `SVT_MEM_INITIALIZE_WALK_LEFT, /**< Initialize to a walking left pattern */
    INIT_WALK_RIGHT = `SVT_MEM_INITIALIZE_WALK_RIGHT, /**< Initialize to a walking right pattern */
    INIT_RAND = `SVT_MEM_INITIALIZE_RAND, /**< Initialize to a random pattern */
    INIT_ODD_EVEN_CONST = `SVT_MEM_INITIALIZE_ODD_EVEN_CONST /**< Initialize to different constant value for odd and even locations  */
  } init_pattern_type_enum;

  /** Compare type which controls how compare operations are performed */
  typedef enum {
    SUBSET=`SVT_MEM_COMPARE_SUBSET, /** The content of the file is present in the memory core and any additional values in the memory are ignored */
    STRICT = `SVT_MEM_COMPARE_STRICT, /** The content of the file is strictly equal to the content of the memory core */
    SUPERSET = `SVT_MEM_COMPARE_SUPERSET, /** The content of the memory core is present in the file and additional values in the file are ignored */
    INTERSECT = `SVT_MEM_COMPARE_INTERSECT /** The same addresses present in the memory core and in the file contain the same data and addresses present only in the file or the memory core are ignored */
  } compare_type_enum;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Log instance used to report messages. */
  vmm_log log;
`else
  /**
   * SVT message macros route messages through this reference. This overrides the shared
   * svt_sequence_item_base reporter.
   */
  `SVT_XVM(report_object) reporter;
`endif

  // ****************************************************************************
  // Protected Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /** Name given to the backdoor. Used to identify the backdoor in any reported messages. */
  protected string name = "";
`endif

  // ****************************************************************************
  // Local Data
  // ****************************************************************************

  // ****************************************************************************
  // Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the svt_mem_backdoor_base class.
   *
   * @param name (optional) Used to identify the backdoor in any reported messages.
   * @param log||reporter (optional but recommended) Used to report messages.
   */
`ifdef SVT_VMM_TECHNOLOGY
  extern function new(string name = "", vmm_log log = null);
`else
  extern function new(string name = "", `SVT_XVM(report_object) reporter = null);
`endif

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
`ifndef SVT_VMM_TECHNOLOGY
  `svt_data_member_begin(svt_mem_backdoor_base)
  `svt_data_member_end(svt_mem_backdoor_base)
`endif

  //---------------------------------------------------------------------------
  /** 
   * Set the output argument to the value found at the specified address
   * 
   * @param addr Address of data to be read.
   * @param data Data read from the specified address.
   *
   * @return '1' if a value was found, otherwise '0'.
   */
  extern virtual function bit peek(svt_mem_addr_t addr, output svt_mem_data_t data);  

  //---------------------------------------------------------------------------
  /**
   * Write the specified value at the specified address.
   * 
   * @param addr Address of data to be written.
   * @param data Data to be written at the specified address.
   *
   * @return '1' if the value was written, otherwise '0'.
   */
  extern virtual function bit poke(svt_mem_addr_t addr, svt_mem_data_t data);

  //---------------------------------------------------------------------------
  /**
   * Return the attribute settings for the indicated address range. Does an 'AND'
   * or an 'OR' of the attributes within the range, based on the 'modes' setting.
   * The default setting results in an 'AND' of the attributes.
   * 
   * @param addr_lo Starting address.
   * @param addr_hi Ending address.
   * @param modes Optional attribute modes, represented by individual constants. Supported values:
   *   - SVT_MEM_ATTRIBUTE_OR - Specify to do an 'OR' of the attributes within the range. 
   *   .
   */
  virtual function svt_mem_attr_t peek_attributes(svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi, int modes = 0);
    peek_attributes = 0;
  endfunction

  //---------------------------------------------------------------------------
  /**
   * Set the attributes for the addresses in the indicated address range. Does an
   * 'AND' or an 'OR' of the attributes within the range, based on the 'modes'
   * setting. The default setting results in an 'AND' of the attributes.
   * 
   * @param attr attribute to be set
   * @param addr_lo Starting address.
   * @param addr_hi Ending address.
   * @param modes Optional attribute modes, represented by individual constants. Supported values:
   *   - SVT_MEM_ATTRIBUTE_OR - Specify to do an 'OR' of the attributes within the range. 
   *   .
   */
  virtual function void poke_attributes(svt_mem_attr_t attr, svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi, int modes = 0);
  endfunction

  //---------------------------------------------------------------------------
  /**
   * Loads memory locations with the contents of the specified file. This is the method
   * that the user should use when doing 'load' operations.
   *
   * The svt_mem_backdoor_base class provided implementation simply calls the internal
   * method, load_base, which is the method that classes extended from svt_mem_backdoor_base
   * must implement.
   *
   * The 'write_protected' field enables write protect checking for all of the loaded
   * memory locations.
   *
   * @param filename Name of the file to load. The file extension determines
   *        which format to expect.
   * @param write_protected If supported by the backdoor, marks the addresses
   *        initialized by the file as write protected.
   */
  extern virtual function void load(string filename, bit write_protected = 0);

  //---------------------------------------------------------------------------
  /**
   * Saves memory contents within the indicated 'addr_lo' to 'addr_hi' address range
   * into the specified 'file' using the format identified by 'filetype', where the
   * only supported values are "MIF" and "MEMH". The 'append' bit indicates whether
   * the content should be appended to the file if it already exists. This is the
   * method that the user should use when doing 'dump' operations.
   *
   * The svt_mem_backdoor_base class provided implementation simply calls the internal
   * method, dump_base, which is the method that classes extended from svt_mem_backdoor_base
   * must implement.
   *
   * @param filename Name of the file to write to.
   * @param filetype The string name of  the format to be used when writing a
   *        memory dump file, either "MIF" or "MEMH".
   * @param append Start a new file, or add onto an existing file.
   * @param addr_lo Starting address.
   * @param addr_hi Ending address.
   * @param modes Optional dump modes, represented by individual constants. Supported values:
   *   - SVT_MEM_DUMP_ALL - Specify in order to include 'all' addresses in the output. 
   *   - SVT_MEM_DUMP_NO_HEADER - To exclude the header at the front of the file.
   *   - SVT_MEM_DUMP_NO_BEGIN - To exclude the BEGIN at the start of the data block (MIF).
   *   - SVT_MEM_DUMP_NO_END - To exclude the END at the end of the data block (MIF).
   *   .
   */
  extern virtual function void dump(string filename, string filetype, bit append, svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi, int modes = 0);

  //---------------------------------------------------------------------------
  /**
   * Free the data associated with the specified address range, as if it had never
   * been written. If addr_lo == 0 and addr_hi == -1 then this frees all of the
   * data in the memory.
   *
   * @param addr_lo Low address
   * @param addr_hi High address
   *
   * @return Bit indicating the success (1) or failure (0) of the free operation.
   */
  extern virtual function bit free(svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi);

  //---------------------------------------------------------------------------
  /**
   * Initialize the specified address range in the memory with the specified pattern.
   *
   * Supported patterns are:
   *   - constant value
   *   - incrementing values,
   *   - decrementing values
   *   - walk left
   *   - walk right
   *   - rand
   *   - different constant value on odd and even addresses
   *   .
   *
   * @param pattern initialization pattern.
   * @param base_data Starting data value used with each pattern.
   *   For pattern INIT_ODD_EVEN_CONST pattern denotes data value for even addresses
   * @param start_addr start address of the region to be initialized.
   * @param end_addr end address of the region to be initilized.
   * @param optional_data Starting data value used for odd addresses with INIT_ODD_EVEN_CONST pattern
   */
  extern virtual function void initialize(
    init_pattern_type_enum pattern = INIT_CONST,
    svt_mem_data_t base_data = 0, svt_mem_addr_t start_addr = 0, svt_mem_addr_t end_addr = -1, svt_mem_data_t optional_data = 0);

  //---------------------------------------------------------------------------
  /**
   * Compare the content of the memory in the specifed address range
   * (entire memory by default) with the data found in the specifed file,
   * using the relevant policy based on the filename. This is the
   * method that the user should use when doing 'compare' operations.
   *
   * The svt_mem_backdoor_base class provided implementation simply calls
   * the internal method, compare_base, which is the method that classes
   * extended from svt_mem_backdoor_base must implement.
   *
   * The following comparison mode are available:
   *
   * - Subset: The content of the file is present in the memory core. The
   *   memory core may contain additional values that are ignored.
   * - Strict: The content of the file is strictly equal to the content of the
   *   memory core.
   * - Superset: The content of the memory core is present in the file. The
   *   file may contain additional values that are ignored.
   * - Intersect: The same addresses present in the memory core and in the
   *   file contain the same data. Addresses present only in the file or the
   *   memory core are ignored.
   * .
   *
   * @param filename Name of the file to compare to.  The file extension
   *        determines which format the file is created in.
   * @param compare_type Determines which kind of compare is executed
   * @param max_errors Data comparison terminates after reaching max_errors. If
   *        max_errors is 0 assume a maximum error count of 10.
   * @param addr_lo Starting address
   * @param addr_hi Ending address
   *
   * @return The number of miscompares.
   */
  extern virtual function int compare(string filename, compare_type_enum compare_type, int max_errors, svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi); 

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Generates short description of the backdoor instance.
   *
   * @return The generated description.
   */
  extern virtual function string psdisplay(string prefix = "");
  
  // ---------------------------------------------------------------------------
  /**
   * Method to provide a bit vector identifying which operations are supported.
   *
   * The backdoor class may represent multiple backdoor instances in which case
   * the method should indicate which operations are supported by at least one
   * contained backdoor. Clients wishing to know which operations are supported
   * by all contained backdoors should refer to the 'get_fully_supported_features()'
   * method.
   *
   * Each operation included in the svt_mem_system_backdoor definition will have its
   * own bit value. A value of '1' in the bit position associated with a specific
   * operation indicates the operation is supported, a value of '0' indicates the
   * operation is not supported. Note that this insures that as new operations are
   * by default not supported.
   *
   * The following masks have been defined for the currently defined operations and
   * can be used to indicate or check specific operation support.
   *   - SVT_MEM_PEEK_OP_MASK
   *   - SVT_MEM_POKE_OP_MASK
   *   - SVT_MEM_LOAD_OP_MASK
   *   - SVT_MEM_DUMP_OP_MASK
   *   - SVT_MEM_FREE_OP_MASK
   *   - SVT_MEM_INITIALIZE_OP_MASK
   *   - SVT_MEM_COMPARE_OP_MASK
   *   - SVT_MEM_ATTRIBUTE_OP_MASK
   *   .
   *
   * @return Bit vector indicating which features are supported by this backdoor.
   */
  virtual function int get_supported_features();
    get_supported_features = 0; 
  endfunction
  
  // ---------------------------------------------------------------------------
  /**
   * Method to provide a bit vector identifying which operations are fully
   * supported.
   *
   * The backdoor class may represent multiple backdoor instances in which case
   * this method indicates which operations are supported by all contained backdoors.
   * Clients wishing to know which operations are supported by at least one contained
   * backdoor should refer to the 'get_supported_features()' method.
   *
   * The default implementation, which should be sufficient for simple backdoor
   * classes, simply calls 'get_supported_features()' to determine which operations
   * are supported.
   *
   * Each operation included in the svt_mem_system_backdoor definition will have its
   * own bit value. A value of '1' in the bit position associated with a specific
   * operation indicates the operation is supported, a value of '0' indicates the
   * operation is not supported. Note that this insures that as new operations are
   * by default not supported.
   *
   * The following masks have been defined for the currently defined operations and
   * can be used to indicate or check specific operation support.
   *   - SVT_MEM_PEEK_OP_MASK
   *   - SVT_MEM_POKE_OP_MASK
   *   - SVT_MEM_LOAD_OP_MASK
   *   - SVT_MEM_DUMP_OP_MASK
   *   - SVT_MEM_FREE_OP_MASK
   *   - SVT_MEM_INITIALIZE_OP_MASK
   *   - SVT_MEM_COMPARE_OP_MASK
   *   - SVT_MEM_ATTRIBUTE_OP_MASK
   *   .
   *
   * @return Bit vector indicating which features are supported by this backdoor.
   */
  extern virtual function int get_fully_supported_features();
  
  //---------------------------------------------------------------------------
  /** 
   * Internal method for reading individual address locations from the memory. This
   * is the peek method which classes extended from svt_mem_backdoor_base must implement.
   * 
   * The modes argument is optional and is not used by the base class implementation.
   * 
   * @param addr Address of data to be read.
   * @param data Data read from the specified address.
   * @param modes Optional access modes, represented by individual constants.  No
   *   predefined values supported.
   *
   * @return '1' if a value was found, otherwise '0'.
   */
  virtual function bit peek_base(svt_mem_addr_t addr, output svt_mem_data_t data, input int modes = 0);  
    peek_base = 0;
  endfunction

  //---------------------------------------------------------------------------
  /**
   * Internal method for writing individual address locations to the memory. This
   * is the poke method which classes extended from svt_mem_backdoor_base must implement.
   * 
   * The modes argument is optional and is not used by the base class implementation.
   * 
   * @param addr Address of data to be written.
   * @param data Data to be written at the specified address.
   * @param modes Optional access modes, represented by individual constants.  No
   *   predefined values supported.
   *
   * @return '1' if the value was written, otherwise '0'.
   */
  virtual function bit poke_base(svt_mem_addr_t addr, svt_mem_data_t data, int modes = 0);
    poke_base = 0;
  endfunction

  //---------------------------------------------------------------------------
  /**
   * Internal method for loading memory locations with the contents of the specified
   * file. This is the file load method which classes extended from svt_mem_backdoor_base
   * must implement.
   *
   * The 'mapper' can be used to convert between the source address domain used in the
   * file and the destination address domain used by the backdoor. If the 'mapper' is
   * not provided it implies the source and destination address domains are the same.
   *
   * @param filename Name of the file to load. The file extension determines
   *        which format to expect.
   * @param mapper Used to convert between address domains.
   * @param modes Optional load modes, represented by individual constants. Supported values:
   *   - SVT_MEM_LOAD_WRITE_PROTECT - Marks the addresses initialized by the file as write protected
   *   .
   */
  virtual function void load_base(string filename, svt_mem_address_mapper mapper = null, int modes = 0);
  endfunction

  //---------------------------------------------------------------------------
  /**
   * Internal method for saving memory contents within the indicated 'addr_lo' to
   * 'addr_hi' address range into the specified 'file' using the format identified
   * by 'filetype', where the only supported values are "MIF" and "MEMH". This is
   * the file dump method which classes extended from svt_mem_backdoor_base must
   * implement.
   *
   * The 'mapper' can be used to convert between the source address domain used in
   * the file and the destination address domain used by the backdoor. If the 'mapper'
   * is not provided it implies the source and destination address domains are the
   * same.
   *
   * The 'modes' field is a loophole for conveying basic well defined instructions
   * to the backdoor implementations.
   *
   * @param filename Name of the file to write to.  The file extension
   *        determines which format the file is created in.
   * @param filetype The string name of  the format to be used when writing a
   *        memory dump file, either "MIF" or "MEMH".
   * @param addr_lo Starting address
   * @param addr_hi Ending address
   * @param mapper Used to convert between address domains.
   * @param modes Optional dump modes, represented by individual constants. Supported values:
   *   - SVT_MEM_DUMP_ALL - Specify in order to include 'all' addresses in the output. 
   *   - SVT_MEM_DUMP_NO_HEADER - To exclude the header at the front of the file.
   *   - SVT_MEM_DUMP_NO_BEGIN - To exclude the BEGIN at the start of the data block (MIF).
   *   - SVT_MEM_DUMP_NO_END - To exclude the END at the end of the data block (MIF).
   *   - SVT_MEM_DUMP_APPEND - Append the contents to the existing file if found.
   *   .
   */
  virtual function void dump_base(
                    string filename, string filetype, svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi,
                    svt_mem_address_mapper mapper = null, int modes = 0);
  endfunction

  //---------------------------------------------------------------------------
  /**
   * Internal method to free the data associated with the specified address range,
   * as if it had never been written. If addr_lo == 0 and addr_hi == -1 then this
   * frees all of the data in the memory.
   *
   * @param addr_lo Low address
   * @param addr_hi High address
   * @param modes Optional access modes, represented by individual constants.  No
   *   predefined values supported.
   *
   * @return Bit indicating the success (1) or failure (0) of the free operation.
   */
  virtual function bit free_base(svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi, int modes = 0);
    free_base = 0;
  endfunction

  //---------------------------------------------------------------------------
  /**
   * Internal method to initialize the specified address range in the memory with
   * the specified pattern.
   *
   * Supported patterns are:
   *   - constant value
   *   - incrementing values,
   *   - decrementing values
   *   - walk left
   *   - walk right
   *   - rand
   *   .
   *
   * @param pattern initialization pattern.
   * @param base_data Starting data value used with each pattern
   *   For pattern INIT_ODD_EVEN_CONST pattern denotes data value for even addresses
   * @param start_addr start address of the region to be initialized.
   * @param end_addr end address of the region to be initilized.
   * @param modes Optional access modes, represented by individual constants.  No
   *   predefined values supported.
   * @param optional_data Starting data value used for odd addresses with INIT_ODD_EVEN_CONST pattern
   */
  virtual function void initialize_base(
    init_pattern_type_enum pattern = INIT_CONST,
  svt_mem_data_t base_data = 0, svt_mem_addr_t start_addr = 0, svt_mem_addr_t end_addr = -1, int modes = 0, svt_mem_data_t optional_data = 0);
  endfunction

  //---------------------------------------------------------------------------
  /**
   * Internal method for comparing the content of the memory in the specifed
   * address range (entire memory by default) with the data found in the specifed
   * file, using the relevant policy based on the filename. This is the file compare
   * method which classes extended from svt_mem_backdoor_base must implement.
   *
   * The 'mapper' can be used to convert between the source address domain used in
   * the file and the destination address domain used by the backdoor. If the 'mapper'
   * is not provided it implies the source and destination address domains are the
   * same.
   *
   * The following comparison mode are available:
   *
   * - Subset: The content of the file is present in the memory core. The
   *   memory core may contain additional values that are ignored.
   * - Strict: The content of the file is strictly equal to the content of the
   *   memory core.
   * - Superset: The content of the memory core is present in the file. The
   *   file may contain additional values that are ignored.
   * - Intersect: The same addresses present in the memory core and in the
   *   file contain the same data. Addresses present only in the file or the
   *   memory core are ignored.
   * .
   *
   * @param filename Name of the file to compare to.  The file extension
   *        determines which format the file is created in.
   * @param compare_type Determines which kind of compare is executed
   * @param max_errors Data comparison terminates after reaching max_errors. If
   *        max_errors is 0 assume a maximum error count of 10.
   * @param addr_lo Starting address
   * @param addr_hi Ending address
   *
   * @return The number of miscompares.
   */
  virtual function int compare_base(
                    string filename, compare_type_enum compare_type, int max_errors, svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi,
                    svt_mem_address_mapper mapper = null);
    compare_base = 0;
  endfunction

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Used to get the backdoor name.
   *
   * @return Name assigned to this backdoor.
   */
  extern virtual function string get_name();

  // ---------------------------------------------------------------------------
  /**
   * Used to set the backdoor name.
   *
   * @param name New name to be assigned to this backdoor.
   */
  extern virtual function void set_name(string name);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Used to get the backdoor name in a form that can easily be added to a message.
   *
   * @return Name assigned to this backdoor formatted for inclusion in a message.
   */
  extern virtual function string get_formatted_name();
  
  // ---------------------------------------------------------------------------
endclass
/** @endcond */

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
JT7WFX;\+g3,,IAMSE:8e7;]9I2aZ\\\X8J#>Ub)1Y)0gcOIeDFQ)(Vdf:35QKBH
B1JcK/&<RE-I(445;?QIRcdBL8fMYE-Ga:a.K-);VL^UHKId:3C7\6bUO?C]gBLe
f+cGH\fc9N&M>geQS,RI/FfHBFZS>-PFC/O#67SWXBg(c&<7Y(HT1#2(-^LND#CL
3f.YcLcS;2VA/#)<@\.O0eb7T),I5]&Of1ET/E;46&OP<C;(8>NG8<.GT:aHB5H;
U5YOM.5;;^EgI2]]Ob@7a5<CLd;#F4b,EWE1<Ve9N[fXa#K_f&RdM.O\KQG>cEG@
([:-Mg1=W9N=JKYBL^X;=>/U2/1T0N-WA5fXaM3(,KYP2(@aC6EN+&,JQDfP:[0-
Q.>ZFRP99O3ROcGNL?c>R&7=IO?NaDU:(<Gg[?\W][Hg+LgNX/^,+bQK\4A.b,+8
:X?C.RIC>.M]AA&?[A<([A0/e8Xgc]&UUCD3CO@[<&@&@O]b0U\U.2.#QJ&NNgc)
K->gBHR&A2Z0EC\/NM@JTRIJ@=H4E^7Y)A6H[Y-DE=]Eb,.8&Ba=KQf-U#S/?^ZE
A&^6@baH^W(C1>fQEQcTY6INb->V/T+/[+c:EDS=#3\IZ;C.578L//N^YRQf5CC+
58.SI#[+[(ALITVVd:A<DTWFMeBcUbXe2WATD322J-PE<17/0Z++,+CLY1bC@16#
>[BI;-<?4TW-d[9@D0^aCMA5gQVaHH;;E>eKR1dYd/?P;d<?W>;fZ/M?&LM/IQ^+
JE,V:d3#(gYYX+[U+]QS+XGe084&Zb(85)V24Q2&WeSQU,L7cId<#H3A^:;UVd2H
Fa==LPY1G_D8]:B/Q]6e+FDT;>[Y#<K9US<6KV_Y]W5>aFRB2D@@HG?CD,+=b?P9
Y?Xf@0aDT]UWZ1gV+[5b+Ua6_gH7HZVZ4437TW^[]LQ<0a;N7(@<.\D-[Eg1SUa/
TU9G[b3E9BT+(g:fAUR+gUD/a;C2)e=-7-8V3I;AANV2YLbX.KCaOAC[;e<e7SB)
3KYfL4V3UgUfGdRg9B@^F&cb=F=+]+0L3;:AX190/2B^XT_12Zb:1,<:Ld7&Q3O[
7V:8SUUN4?EYPG:EbLK7:VYg:eMe&):f7X78K3>&?_a7YHf.]XH;4b-HW\[9D4DI
<)54UBD0,@>96:CQSD1_Z^-Y@/GQ&R#_;2QUC8O.<b/:IR8C+a<GQO:-JRYC30Be
M1Odb8^ST_\55ceYbRI[P/LEY)aZC[CN2L2Ye4^V7(QW3Oc+,(CYE5L1ZK[N@ATM
9c0MVg]XV0XF\/[5V2&XVR)W@\Y[Md<W(Q1.6d1-M.RIJLK9VgS_;:N?&J)H3XI=
T_F_+4P=8I5UM<fS6TObAGQ\6==N)FE.d?Ac(CaHbW8),@J2\Z,)b)SB7-J(cH#8
1PK71G/V-2g[4DZODKHBg@U9&V.2FZ;@GfGOFUe8cTYDEg[K?UI1T_<b[SM8.8FC
?NV,-]BDdQ4eWb-S5]0H)K;J5C,H?E,F#VFfPIM@([:R/gb7[K;^HSDU:=5><[JE
Lg3LRA85#LUEaF<7_d>:;_(-X8;2/X:cd7M#IV&L/Lf)S+]U;&KUgH/2\Z;0[IGc
]LTFPT\KJ(@D&V+UML07IGG#IEW2@a1OH<ST\2Bb163\APT<U&W#J1g\S(7fJUHJ
=@,/LHRRe:J#Z_3F+MUa2FAHW^7,>d\+f,:E&>Q1ad^Bc+L33EEGOeL_QMf\,YV7
b<9NC(1T(6&ZX1\4?:B,=2@+BQG.VCHRZ5\1GTHBGFcb)2:/+=_d(+/+#1DJ9a/>
YQgG69\2RS.SX&-[83Y3)aA48XIe5_K>F2d&)E.H,fGCAHb^JA_0RabIV(ZC0,R0
;W9?04F?X=FI.U6DPRK>H?OV:NNa]WL=>N6NF]4+\g@K;#C.1P3@O)EX>.e#^gfZ
>BG=EPQ^>+fFSM&HPNb/<TaE6YAH#EW#FcFR+#4]L1MKQOXg/OAPZC=GDR#=bc<_
.^?cg\BFPW9a94AcS8)Uc;e>BT:A[BL[4#O6)@9,3GTQ03:cRC2N<(Z;Ac:;T.EM
6[T)<Z]I0S/::X+eMW&@<@APM^&MHMEbK]4/EfL>_&J7SG@f,C&1aO9^HQK7@g3,
NA,V\]MEOB&X1_\X.G#[UY=2^:@.a_bX4E>-_Ha7dB/(8XJ=L.;Xf.D21;./2,;G
c8CdeF-E7PaF1dEGVg7\,&S:c)6]5M4gW,]^YMY):f@^Q=6(9EVT1fQ:2,:W;\V<
F:cKf5;+:G6C#-EX5#We?ECXC\7YZ=&H.LKggE>d6ZPM+bL<RbF^H,]Z,3H[eUE?
22@((0?4J,41eaSV11M@H0(@Ja,O4:4P4fC7E2VD.37(cM.2T/,X]09F?1]2NU:Q
V]@2_b^a>:e13O.PX>35;ROGH@Z?AB@P2\/AN5ZTJ^</YP#R(,G=d.?F9@@/60fH
B)5cFHT63Qa&<VB0W6O(K]KTH.D+8+UR3(>Xg(P=PcJ-I?;1SG#_X+21(0NC-c9A
?];=X@OAf)&:7_RbgVN>XLTaCDM9TGa8J\T;NNQ5KCNONW]NTO7H[]-1g34/[4Q+
b-bb7CCbJ2fG)K)d6aVVbWYe[1VdC,-P9Kcc]-^Kd]@H1c3GFB,:@:;NQL#O.4c#
1_Ba5-_,/AB#=\KeBLG[8D)4^<VQe2W,aaWe</4a(f0_gI3:\TTR&]&.:[d//c]Z
)87.K^)J=<MLGC0ON].<X>-+Ud-.:<HA?3C1<7g(UE7K_HBC@aRc)?3D-6=Cc(JO
C2Q;14X@5]H[#FIYC>e52GdW^O-).#J[P-Ye#+T+@CMdJ2M_.G#.6[Hf.>7I=D[7
22HX_K)C[a.J-.;5a<7?3@/^_&+9Q04H=UCNQ,=V8A/a5;G,)]a=)343W<9?73HW
-cgWZO=U]1<5[TCZ\DWcG#/Q^GI/8@-8/UXUWcHgH2THE,&B/bV/A)6&B?]UEe\Q
gSZ2X_,G)gIE]A:ZGf(<IMb-DDB.GB+S91XYM)X6^U=/XOELURP0JJ\RBAMMbA)3
D9\K87bUL5ZG?7R1E(3?BaM0S_U:X(\=MCNXTX\?,=Y)DdLUbJ/Z[D#0[CMX4<8f
;E,J\fS^=]]aULJf6:PJFE^Ad6MFR0,PABe09,CQS=7/a74.TZ-L0VgF8W#L\(A#
X5[@B:=1N_aMT,A5#C>DK1#G8]9W:Q)(IE@5aVO:&B4I;d<SS-EA7TYBS8\6HBPe
Mg:0P3/Z]FLAG6758Y):>dY3;R--SLNXIb?K#D]>.@@3^_1MUDg7PbOPA]B(Jb.A
</\&X;Bg=<A\C,f1&#5@>X129bKY(3#:O<ZE80:Z(I.&(,4Q5F8\G-F^)^35aBf4
.7@S0JI_?;T&CMIgR2_)aVDM:L=M,<RC3S7g[J^YL506LASe6<88K#E7P>M8GLI>
6^8NO,<<[[Q/(Dg9&04/\dYO.6Z#3@)-QV=QCV4MRS)@D4^^.W)5_4RJ4PE^fc13
Vf]BH)GB5/Y<_\fKV5Mf>0IFUb[J2&0RHb)T34=f9UO0W^&ROD_J?4DUTf(X7d,]
D+?RC9[.+U]MR-1&IV,69La^c-HWT,AT&(7F/(A3-;@).QeUMKKP66I].TOA1.M5
-O5P1Q>d_,+OM8T@D##aG^1#cXbSECO8FGWbBF-e&KGV[][^K[80H)?6b,LOT,DT
5#F3JSBFO8f,ePX+Q6-/FTYJD]S2D[CY28XSG;O)bf,F-^59P]_fKZ+W+XPX>C&I
#bCa@J].e(<?P@QV/d+P4T^RN+#@4S(^#&-9@&.g#7Xe5g@EG3a3_T?QKeX7ed/O
AO3I(VPbeA>;MFbdbc_Va\8A^^&H-c<YO/f]4Y_5IMKO(6BP0-W3eO>)UC+@.#MD
#GGWd:b;H2S9<ZX+L<_fY+R@Pa6f3(<gS6S@CZf[RIK5^b+P=\\\M&I.G_RY#:e:
A\]/LZ9NGQ/0\J&I[C^5RcG8IA9R]_e]1^X2HcU16CFD6Q42BOK<3fP:<+bUe.MG
NE#E)_8cZ+N:K_f,5A5(Z;&aVN;cZddcYH=LPC=O:QRN]d&Y7Q[G0HfI??S>_S1D
aQ9@S[ZJ;1.GfR)GUH_<2Kb;B>>TVfH^J<9^Xd_^6N11YK5_(J^+&DSOD7SO361b
O7PCV)bC1-SZ9A2TEYdIP;3#d+VObB?\g]O(S^fO+:TBD<64(U+3O:#RS7KN-Uf:
?#@g::+VS]&82e6C3J_)3V65VAPNI>NMZ.b^96)dH7<OGLO&>E0d7/bQ_aH+QT)[
Q6-W,dN@0[f@8f;e\TOA7NA]ZV+,-K03,#89fR;2FJRLdS9=QR1)#.dI#a-MY#Z+
3NCO-ZF5PgI2d:,N&RB8d]1S6dgd\>4OP<KM<Z59DHbceP9+Z=M.0&YfIaM-(#^U
CJf:;@3,(,dgU#Kb9Kg<-:MbD)U0_&L^??QZEd>^TdTXa6WgDB3gR;J&/E_KAgLH
Q:TY3]58ZVKg#9K\;Qf[Y_7?KJLZ\eXV[FJ4WFH52CV2Y9^31ea>;/4+4L&Y7?(M
(I=UJOF?fH=BOAY[)44?IPT]F[[.MKLTCae_9OUIYcO=8C^,eJEeQPB)YMNfY0D\
2H1BdN0b&CACF3E6UfCNUI0>KAbC?J:JcQ7NQOGBSEGRJD>d5Yg@O>LUS04S^TN8
S?QLPg3GZ8&Kccg#;]]>_@O3=Z_PP0.Bc/X7I;ad>7.#ebc;12)^DK.QHUQ)f[@;
]]\?P(d;-FAFHf4L7SD89XV(S2D4SS4#9(B06/N?]&911CJb_,=+H-E)?T)#HgQZ
=/@SF)>.<X6LIA@<?&+;X]]cJcYb,-b=0/;Eg4UPRM/@]85(NW5TM:)MT;;?ee]C
JRL6QI_NSRX,c:7.,-LBZdd3@)/51cL4M\eNF8P.R?b7?3Te5IO/@+0IB05\=S7J
C#^_06HMDIIDae-:g9Jb?A=aWK6L?Dd@X58/g@bNO;_O)dbS5FC87I.DDDB\Q&&Q
dc.AM@aL@eV21N7HY1O-:IW=,bO?5IeOU3UL.?8U4V@d0R_V[e:^//=0KS)Rb9&-
AXHaa>]UOFYPb^A93ZC-18,I4_^5PUdMd7\@IU9^I2G;&JH;E^Q7<93;eSWNTC6;
dg/T77)X4b2(>M,OD:H.NE?&c,Ac_^MCUO#28=@GG[WHKc<C78bL<A=Fc>C463[>
#7_VBe#FJ9W-KH_9<F7e^7>Y4=aW6C<=EQ>CdB?b_?Q^&1GF82_<X7TU7D4@=9XJ
@[-Q@O;7HXH0&8,C&Q(/H:6/4C56F]Dg2@>P82Z8KWf,fYC/A/eF88Le9EWHB#B(
P,T7@e.9eK\TC0KLJ>=U&6_+EOM-845W4S8[.#cG6O.C;0SWY\M3D<)@W5&1FOFH
-SH>QKYR3P#ABEa4NW08F:A4f.[Q;\VfPJRWNBV)FA,PJeGJ:9O&[F^R]MN.O:]d
H1>Jf#;,eU,2S@I)1_?T6a,7D4AgQ]D_E:]03^V282CKI5@SB_f)fORDY9KTAFWA
&QL24DFAR[NFSgAE)g#:3R)7T3O5IeP=,]<:d^U[,:Y;4F699\?gOMb7(U6Z?+S+
d7SUU(SS8>T72^VSS@dE&WC)?<DF-TVU;<AQ.bD@QIDdY)YAa-)K[>QbN#a8_9(>
3@_PA=3N[Af2QO>De[.H:d6)ZT)<FH>c8K^8IJcUAFOJTPRF?eG45C&5AC\g,O0L
B-4W5EI:IEX/MK+J]3cc&\2@>_J[#B<9383[PE[4J+_:<)f.JZ>(0g8&QD@5,c&R
-A@PIU(]dHO>\=30LeJ[@A2\(),W&,BMRSU]R1ggX/He.3)CR8cJ\<2#.20;>g#-
c&O5DRN8])J-AS#NZ@H(Rg8))M)^gPH&:b#V?&V./YGA91&T#MdKHZ^Q5(?NQXWP
UHXZ=Xda)YdV4ALW1I#TXIPM)NBf^?A6(0M\_7<XaY1gfXHN^RMUgW_+2A#L\U&X
[e(\9CZ.H.++:P)VGZ>Eb3Xc8;I[/@@57M<^]Pgd4aXC<YEF#5@DL_/#P&e\V0<.
=aIKNQ]f\SW^Da959@380T)Ze?S)@3H1^=B\EGEeg+HBNZ2cc?P[TF85d^VBLI1W
]YYHX8^EQ6&/_MX@NdSA6_E&)aH(+RVKKB>0@&EX5aIgYAG>74F[C6U>,M4)QNCQ
_(e-@@0J&K^VA8b[VB4&-JAC9A:WfeVC4EbUf7RQL_B&1DQ9\)K#Cg1,1JQQQ6c(
S^;[LX:TD)^g306eTX&(Nc>SQ.OE,JC;=VQeU+@NXG)KMID<5bV/[^GE[HEJN?[/
bN:M+J232d9UXdO8/bNBLU0c_g.Rd)?VdV/38d6:,L\/?&<5?^L[e?=f2aT1=^YT
e2GGK7(SJNBAS\.BX#MLJfPfY>_KXC?5/][4(<8a]RfQV\N7ZSZ)f>);.2IeZdFJ
a6bD-Z4-:^^gDGJ#Q2d)@^3\C?9L4[E^LOHJYP#JI)g(5<1aD44d]&K?-T+/^[0d
M^e3]WG?9JY>73;)R@LE#)KO#=.UAYa+>4/<0_2+3(\?VZ_B0<,:/gYV7><Q]f8]
8Bd.g=2YOX6JR,F;0)QCKGXZgJKJURS?ae-GR]:dWN?)3W8GO#E16,PD;2^7)8&H
.889f6.AP,.F,c#[ad&bSK@AUfRGB^b0,I17LJ#<KRBQB1SF]GT&CQ79dBYLVf:Q
SfP5N>J:NYU^YD+c#7b:b_R:R0SLRVcS\+R)7.f(RJ;=LW/GTV(-JKIQ#4UCJTCH
1?e5aC0;B#44XG&;6L;B\XU&6A\QVEdYJ>V8D3RKH/+3CFOH3?79,2eb+AC5\7\D
cgSWGCL_d;aWF>_0+4gGc;&7cJTaGUa/MNa&9G)MWRO,Y3HSM)>.;L:M:9E2<Qe7
W#_R5SKb0.M&DO[N(+aK9R#(+,f.NK2@ICTUQ2TV<__F1_\\X&SeGe<&C<@>EIe;
@^=c>&SBd6\JbaYaf0#U&V:@QH4eLcS_@,-S)=.H-A_^RZH,TK\@A5KGc.\L4=M6
LSFSPJe3NfIST1O^YG698aH:S&K/8740_ATK/X]MQBH>;fS7C+;+D?;7&S6-adf^
bFfAfGB(Z:8VWCE[CS\1d7[.YU&?cO@Z[VCMNE0G2&=CE7_Y+H-LCKbXDY]9O8XA
KI8=67,AH,=KS(9BSQAB)Ke4_6,0@6]f)ML3c=D=1K>#_dHBQ:ag.&.X1+16e+.R
5ZX\X9e,LT<BE.gg1.L^D\_NYZ+5^M?c@BbPS;TAB=_\^EKc3REE<X-cfPa_/Hb@
c?(F3KW[N:9:3MP#[V>(C?YR^C.S[&U>P5N.5M+OO5+E3(=]SZXO12961W^Dab+U
]cMEV;=B2_1b.d3VJY0IY^GJ\4fg&)F20C+D/[^Qa9TSOU_b4ZW/[7c;Zd0AcEc<
14MH?-^KP(69Z&LW:<NT)WbIJN&_H]K6g7\VOMG=KOW(;Q@R7a^&F)=fF,7HIIF_
N=dYLY:f,dIFWVG1FI)6=/^AU>^?/:N?.c&SFX/YT@dQ7\]&+4-UZ#<g4d>:NJA(
\IZc:EIOaZ?80F/E:Ja#\[6T/,V3MGUG&.8MU+cHbbZ&+<;VQCGZ#T4bPaXd7f0M
>LbZDJ/CM@3E#46=2f?&TBU=5?Z_D80.HL^-@0Qe1U#&f?86#-7c#D0FZe^(S8BX
,?U+8cRJ[UP+Q:?JRA&ABXZbO@ZUSZF[#]&_,_B-R1,2c7WBa7E1_(VRSDX42CPL
9-]UaH8&Qg3(BOBYVNAUJc2a]+9cTT/\R=Qa9ML#@bPg[ZV4dJ^8WHAIT)2a^OXe
gM^<g\WU+:@UF>^]Q/86;P3g\@M2[Z;N4]\<)B=+C+=Z27da4?E.#)#,HeTOL1Pe
6e8/E4Mb4>5B6I]/V-bK3c,bXNJ9JLfR3X9-;(7ION5b)e-L5TU?IZTG>;_TZ@0=
6c/>[a:,N]KIHRbI]8NaYS\cbV5T^^HP6QW2_]G2=_[5U;KJ&IOf=CIZ#CP3&YL=
B3^b<CXOY^S+6JC=fH#([=OX;R>7W5EQ]C39EX_#gAFAD,?eFV4;f@18AIXF\40&
Ya3NCM)Ub@3c;(Z)V]WQ<J_FF0Ge.611HOGf(D&9HAQJVG^:>f<bDbbUI&:#8?Ga
-JdJdV=+ZYA)V^Z0F.4-77-KC8UPR+?:(4T=LP)78^_=ND/FB8I\0:E/,SIV4cJG
MU@/d^aX-\OG=BXWAKIN(PSE.TD>D,WCK[4]WF[M^[\AECbT3DD8^4fZ4IXXUEX<
ea?Y0J\UGdFedU-?/_EdFgBa]d=_#I&)85?58EgW&7PXeW&DK/b\.>cgDg9bPJf1
IN1HH9Xd9^[D)XH:MFaYX>4G(GJ]+:O:>IEPg-g^Q0(VNNdaQH566UH+dN^L6=eN
g4g<9?T-?V^?2(();?KUfW?0TB)Rb6M6X\86?S#V<I5KSdFYGGG2YDO94]5)e2>H
9;P.796342Sf2b-<(HDV),NXGW1UYYX@0WJPY&WLPM_Hg3YfQg\bfK6bISMBG3WJ
[2B2];AGA?EbdePe;;J8VWR6]5Y2=B,LcYVQDQ.6-_?2gLF_X[DE-:Sc[(dS:KU8
NQX9:S+XV&DC#ZbSSN5DHHWTbLcZ3LC;JYb#:^G&9R;/#2\V?Z/?+[8S-7P#G.\^
c6\2Lde-KC\N]3GK9O/Y9(,LFPbb<&@RTg(]_J.?-b#0(Ta=.?55IRb:aMZUYZ]G
SWN5e3U^,bZ\CdQNY+:X8EXSQ^feHE6gZc,+aO=dVWWH<gTB&;HOA?N8#<HT)eK;
Y@F<<=-E6UW4^#\^[5Db0fJ9a0?85.]S[XK+@e9C19E2<?.5L\>EJM[#^+S)O+4)
G[,^HHK.VPc4-$
`endprotected


`endif // GUARD_SVT_MEM_BACKDOOR_BASE_SV
