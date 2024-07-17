//--------------------------------------------------------------------------
// COPYRIGHT (C) 2012-2022 SYNOPSYS INC.
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

`ifndef GUARD_SVT_MEM_BACKDOOR_SV
 `define GUARD_SVT_MEM_BACKDOOR_SV


`ifndef SVT_MEM_DPI_EXCLUDE
  // Needed to select 2state or 4 state server instances
  `define SVT_MEM_BD_SVR_DO_E(R)  mem_core.get_is_4state()?mem_core.svr_4state.R:mem_core.svr_2state.R
  `define SVT_MEM_BD_SVR_DO_S(R)  if (mem_core.get_is_4state()) mem_core.svr_4state.R; else mem_core.svr_2state.R
  `define SVT_MEM_BD_SVR_DO_LR(L,R) if (mem_core.get_is_4state()) L=mem_core.svr_4state.R; else L=mem_core.svr_2state.R
 `endif


// =============================================================================
/**
 * This class provides a backdoor and iterator interface to a memory core. Multiple
 * instances of this interface may exist on the same memory core.
 */
class svt_mem_backdoor extends svt_mem_backdoor_base;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  // Store name of this class
  string name;

  /**
   * Pre-defined attribute indicating an address has been written or initialized.
   * Provided for backwards compatibility, but clients should actually use the
   * SVT specified attribute constants.
   *
   * Note that this uses the SVT_MEM_ATTRIBUTE_INIT constant, although the backdoor
   * code actually assumes that it represents all occupied locations, whether they
   * have been initialized or written to.
   */
  static const svt_mem_attr_t WRITTEN = `SVT_MEM_ATTRIBUTE_INIT;

  /**
   * Predefined attribute indicating an address was last accessed by a READ operation.
   */
  static const svt_mem_attr_t LAST_RD = `SVT_MEM_ATTRIBUTE_LAST_RD;

  /**
   * Predefined attribute indicating an address was last accessed by a WRITE operation.
   * Provided for backwards compatibility, but clients should actually use the
   * SVT specified attribute constants.
   */
  static const svt_mem_attr_t LAST_WR = `SVT_MEM_ATTRIBUTE_LAST_WR;   

  // ****************************************************************************
  // Protected Data Properties
  // ****************************************************************************
  
/** @cond PRIVATE */

  //----------------------------------------------------------------------------  
  /** Memory core reference to svt_mem_core instance */
  protected svt_mem_core mem_core;
   
  //----------------------------------------------------------------------------  
  /** A memory address */
  protected svt_mem_addr_t iterator;

`ifdef SVT_MEM_DPI_EXCLUDE
  //----------------------------------------------------------------------------  
  /** Current attribute that the iterator is associated with */
  protected svt_mem_attr_t attr;
`endif
   
/** @endcond */

  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************

  // ****************************************************************************
  // Methods
  // ****************************************************************************
   
`ifndef SVT_MEM_BACKDOOR_DISABLE_FACTORY

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new svt_mem_backdoor instance
   * 
   * @param name (optional) Used to identify the backdoor in any reported messages.
   * @param mem_core (required) The specific mem_core that this backdoor points to.
   * @param log||reporter (optional but recommended) Used to report messages.
   */
`ifndef SVT_VMM_TECHNOLOGY
  extern function new(string name = "", svt_mem_core mem_core = null, `SVT_XVM(report_object) reporter = null);
`else
  extern function new(string name = "", svt_mem_core mem_core = null, vmm_log log = null);
`endif

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
`ifndef SVT_VMM_TECHNOLOGY
  `svt_data_member_begin(svt_mem_backdoor)
  `svt_data_member_end(svt_mem_backdoor)
`endif

`else

`ifndef SVT_VMM_TECHNOLOGY
  /**
   * CONSTRUCTOR: Create a new svt_mem_backdoor instance
   * 
   * @param mem_core The specific mem_core that this backdoor points to.
   * 
   * @param reporter Message reporter instance
   */
  extern function new(svt_mem_core mem_core, `SVT_XVM(report_object) reporter);
`else
  /**
   * CONSTRUCTOR: Create a new svt_mem_backdoor instance
   * 
   * @param mem_core The specific mem_core that this backdoor points to.
   * 
   * @param log Message reporter instance
   */
  extern function new(svt_mem_core mem_core, vmm_log log);
`endif

`endif
  //---------------------------------------------------------------------------
  /** Returns the configured data width of the memcore */ 
  extern virtual function int get_data_width();

  //---------------------------------------------------------------------------
  /** Returns the configured address width of the memcore */
  extern virtual function int get_addr_width();

  //---------------------------------------------------------------------------
  /**
   * Creates a new user-defined attribute that can be attanched to any address.
   * Different user-defined attributes can be bitwise-OR's to operate on
   * multiple attributes at the same time.
   * 
   * The return value is the attribute mask for the new attribute.
   **/
  extern function svt_mem_attr_t new_attribute();

  //---------------------------------------------------------------------------
  /**
   * Release a presviously-created user-defined attribute. The released
   * attibute may be reused by a new subsequently created user-defined
   * attibute.
   * 
   * @param free_attr_mask attributes to be freed.
   */
  extern function bit free_attribute(svt_mem_attr_t free_attr_mask);

  // ---------------------------------------------------------------------------
  /** Create a write protect to a memory range
   * 
   *  @param addr_lo low addr address
   *  @param addr_hi high addr address
   */
  extern function void protect(svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi);

  // ---------------------------------------------------------------------------
  /** Release write protect to a memory range
   * 
   *  @param addr_lo low addr address
   *  @param addr_hi high addr address
   */
  extern function void unprotect(svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi);

  //---------------------------------------------------------------------------
  /** 
   * Set the output argument to the value found a the specified address
   * Returns TRUE if a value was found. Returns FALSE otherwise. By default. the
   * attributes are not modified but if specified, attributes may be set or cleared.
   * 
   * @param addr address on which data to be read
   * @param data ouput data on specified address.
   * @param modes Optional access modes, represented by individual constants.  No
   *   predefined values supported.
   *
   * @return '1' if the value was written, otherwise '0'.
   */
  extern virtual function bit peek_base(svt_mem_addr_t addr, output svt_mem_data_t data, input int modes = 0);  

  //---------------------------------------------------------------------------
  /**
   * Write the specified value at the specified address. By default, the
   * attributes are not modified but if specified, attributes may be set or 
   * cleared.
   * 
   * @param addr address on which data to be written
   * @param data data to be written to the specific address.
   * @param modes Optional access modes, represented by individual constants.  No
   *   predefined values supported.
   *
   * @return '1' if the value was written, otherwise '0'.
   */
  extern virtual function bit poke_base(svt_mem_addr_t addr, svt_mem_data_t data, int modes = 0);  

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
  extern virtual function svt_mem_attr_t peek_attributes(svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi, int modes = 0);

  //---------------------------------------------------------------------------
  /**
   * Set the attributes for the addresses in the indicated address range. Does an
   * 'AND' or an 'OR' of the attributes within the range, based on the 'modes'
   * setting. The default setting results in an 'AND' of the attributes.
   *
   * Special care must be taken when setting the 'access' attributes for a
   * memory location as these attributes govern how the memory package interacts
   * with the location.
   * An access value of SVT_MEM_ATTRIBUTE_UNINIT, for example, indicates the location
   * is not occupied. This will result in the failure of subsequent peek,
   * peek_attribute, and poke_attribute operations of that location.
   *
   * Changing the access value between the different 'occupied' settings will not
   * not result in failures with subsequent peek or poke operations. But it could
   * impact the outcome of subsequent access checks which rely on these settings
   * to discern the current state of the memory locations. The 'occupied' settings
   * are defined by:
   *   - SVT_MEM_ATTRIBUTE_LAST_WR - Last access was a 'write' operation.
   *   - SVT_MEM_ATTRIBUTE_INIT - Last access was a 'poke' or 'initialize' operation.
   *   - SVT_MEM_ATTRIBUTE_LAST_RD - Last access was a 'read' operation.
   *   .
   *
   * @param attr attribute to be set
   * @param addr_lo Starting address.
   * @param addr_hi Ending address.
   * @param modes Optional attribute modes, represented by individual constants. Supported values:
   *   - SVT_MEM_ATTRIBUTE_OR - Specify to do an 'OR' of the attributes within the range. 
   *   .
   */
  extern virtual function void poke_attributes(svt_mem_attr_t attr, svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi, int modes = 0);

  //---------------------------------------------------------------------------
  /**
   * Set the specified attributes for the specified address
   * 
   * @param attr attribute to be set
   * @param addr address at which the attribute is updated
   */
  extern virtual function void set_attributes(svt_mem_attr_t attr, svt_mem_addr_t addr);

  //---------------------------------------------------------------------------
  /**
   * Return TRUE if the specified address exists and all of the specified
   * attributes are set for the specified address.
   * 
   * @param attr attribute to test for
   * @param addr address to test at
   */
  extern virtual function bit are_set(svt_mem_attr_t attr, svt_mem_addr_t addr);

  //---------------------------------------------------------------------------
  /**
   * Clear the specified attributes for the specified address
   *
   *  @param attr attribute mask which determines which attributes to clear
   *  @param addr address to modify the attribute for
   */
  extern virtual function bit clear_attributes(svt_mem_attr_t attr, svt_mem_addr_t addr);

  //---------------------------------------------------------------------------
  /**
   * Free the data associated with the specified address range, as if it had never
   * been written. If addr_lo == 0 and addr_hi == -1 then this frees all of the
   * data in the memory.
   * 
   * @param addr_lo Low address
   * @param addr_hi High address
   * @param modes Optional access modes, represented by individual constants.  No
   *   predefined values supported.
   *
   * @return Bit indicating the success (1) or failure (0) of the free operation.
   */
  extern virtual function bit free_base(svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi, int modes = 0);

  //---------------------------------------------------------------------------
  /** Free all data in the memory. */
  extern virtual function void free_all();   
   
  //---------------------------------------------------------------------------
  /**
   * Reset the iterator to the first address with all the specified(bitwise-OR'd)
   * attributes set. Default is SVT_MEM_ATTRIBUTE_INIT, which is interpreted to
   * represent all occupied locations, whether they have been initialized or
   * written to.
   */
  extern virtual function bit reset(svt_mem_attr_t attr = `SVT_MEM_ATTRIBUTE_INIT);

  //---------------------------------------------------------------------------
  /** Make a copy of this class, including the state of the iterator */
`ifdef SVT_VMM_TECHNOLOGY
  extern virtual function svt_mem_backdoor clone();
`else
  extern virtual function `SVT_DATA_BASE_OBJECT_TYPE clone();
`endif

  //---------------------------------------------------------------------------
  /**
   * Copy the state of the specified iterator to this iterator. The specified
   * iterator must refer to the same memory core.
   * 
   * @param rhs svt_mem_backdoor object to be copied.
   */
  extern virtual function void copy(svt_mem_backdoor rhs);  

  //---------------------------------------------------------------------------
  /**
   * Return the value in the memory location corresponding to the current
   * location of the iterator.
   */
  extern virtual function svt_mem_data_t get_data();  

  //---------------------------------------------------------------------------
  /**
   * Return the address of the memory location corresponding to the current
   * location of the iterator.
   */
  extern virtual function svt_mem_addr_t get_addr();  

  //---------------------------------------------------------------------------
  /**
   * Return the bitwise-OR of all attributes set for the memory location
   * corresponding to the current location of the iterator
   */
  extern virtual function svt_mem_attr_t get_attributes();  

  //---------------------------------------------------------------------------
  /**
   * Move the iterator to the next memory location. The order in which
   * memory location are visited is not specified.
   */
  extern virtual function bit next();  

`ifndef SVT_MEM_DPI_EXCLUDE
  //---------------------------------------------------------------------------
  /** Retrieve the attribute mask for the lock attribute */
  extern virtual function int get_access_lock_attr();

  //---------------------------------------------------------------------------
  /** Retrieve the attribute mask for the write protect attribute */
  extern virtual function int get_write_protect_attr();
`endif

  //---------------------------------------------------------------------------
  /**
   * Sets the error checking enables which determine whether particular types of
   * errors or warnings will be checked by the C-based memserver application. The
   * check_enables mask uses the same bits as the status values.
   * 
   * The following macros can be supplied as a bitwise-OR:
   * <ul>
   *  <li>`SVT_MEM_SA_CHECK_RD_RD_NO_WR</li>
   *  <li>`SVT_MEM_SA_CHECK_WR_LOSS</li>
   *  <li>`SVT_MEM_SA_CHECK_WR_SAME</li>
   *  <li>`SVT_MEM_SA_CHECK_WR_WR</li>
   *  <li>`SVT_MEM_SA_CHECK_RD_B4_WR</li>
   *  <li>`SVT_MEM_SA_CHECK_WR_PROT</li>
   *  <li>`SVT_MEM_SA_CHECK_ADR_ERR</li>
   *  <li>`SVT_MEM_SA_CHECK_DATA_ERR</li>
   *  <li>`SVT_MEM_SA_CHECK_ACCESS_LOCKED</li>
   *  <li>`SVT_MEM_SA_CHECK_ACCESS_ERROR</li>
   *  <li>`SVT_MEM_SA_CHECK_PARTIAL_RD</li>
   * </ul>
   * 
   * Note however that not all status values represent error checks that can be
   * disabled. Two pre-defined check enable defines exist:
   * <ul>
   *  <li>`SVT_MEM_SA_CHECK_STD</li>
   *  <ul>
   *   <li>includes RD_B4_WR, PARTIAL_RD, ADR_ERR, DATA_ERR</li>
   *  </ul>
   *  <li>`SVT_MEM_SA_CHECK_ALL</li>
   *  <ul>
   *   <li>includes all checks listed above</li>
   *  </ul>
   * </ul>
   *
   * @param enables Error check enable mask
   */
  extern virtual function void set_checks(int unsigned enables);

  //---------------------------------------------------------------------------
  /** Retrieves the check mask which determines which checks the memserver performs 
   *
   * Retrieves the check mask which determines which checks the C-based memserver
   * application performs.  The return value is a bitwise-OR that determines which
   * checks are enabled.
   * 
   * The following macros can be used to test whether specific checks are enabled:
   * <ul>
   *  <li>`SVT_MEM_SA_CHECK_RD_RD_NO_WR</li>
   *  <li>`SVT_MEM_SA_CHECK_WR_LOSS</li>
   *  <li>`SVT_MEM_SA_CHECK_WR_SAME</li>
   *  <li>`SVT_MEM_SA_CHECK_WR_WR</li>
   *  <li>`SVT_MEM_SA_CHECK_RD_B4_WR</li>
   *  <li>`SVT_MEM_SA_CHECK_WR_PROT</li>
   *  <li>`SVT_MEM_SA_CHECK_ADR_ERR</li>
   *  <li>`SVT_MEM_SA_CHECK_DATA_ERR</li>
   *  <li>`SVT_MEM_SA_CHECK_ACCESS_LOCKED</li>
   *  <li>`SVT_MEM_SA_CHECK_ACCESS_ERROR</li>
   *  <li>`SVT_MEM_SA_CHECK_PARTIAL_RD</li>
   * </ul>
   */
  extern virtual function int unsigned get_checks();

  //---------------------------------------------------------------------------
  /**
  * Initialize the specified address range in the memory with the specified
   * pattern. Supported patterns are: constant value, incrementing values,
   * decrementing values, walk left, walk right. For user-defined patterns, the
   * backdoor should be used.
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
   extern virtual function void initialize_base(init_pattern_type_enum pattern=INIT_CONST, svt_mem_data_t base_data = 0, svt_mem_addr_t start_addr=0, svt_mem_addr_t end_addr=-1, int modes = 0, svt_mem_data_t optional_data = 0);
  
  // ---------------------------------------------------------------------------
  /**
   * Method to provide a bit vector identifying which of the common memory
   * operations (i.e., currently peek, poke, load, and dump) are supported.
   *
   * This class supports all of the common memory operations, so this method
   * returns a value which is an 'OR' of the following:
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
  extern virtual function int get_supported_features();
  
  //---------------------------------------------------------------------------
  /**
   * Internal method for loading memory locations with the contents of the specified
   * file.
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
  extern virtual function void load_base(string filename, svt_mem_address_mapper mapper = null, int modes = 0);

  //---------------------------------------------------------------------------
  /**
   * Internal method for saving memory contents within the indicated 'addr_lo' to
   * 'addr_hi' address range into the specified 'file' using the format identified
   * by 'filetype', where the only supported values are "MIF" and "MEMH".
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
  extern virtual function void dump_base(
                    string filename, string filetype, svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi,
                    svt_mem_address_mapper mapper = null, int modes = 0);

  //---------------------------------------------------------------------------
  /**
   * Internal method for comparing the content of the memory in the specifed
   * address range (entire memory by default) with the data found in the specifed file,
   * using the relevant policy based on the filename.
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
  extern virtual function int compare_base(
                    string filename, compare_type_enum compare_type, int max_errors,
                    svt_mem_addr_t addr_lo, svt_mem_addr_t addr_hi, svt_mem_address_mapper mapper = null); 

endclass: svt_mem_backdoor

//svt_vcs_lic_vip_protect
`protected
W(5EN<ZIZe9,?,b(b.b&?MV.CU\7SCdORbB,1E/599eJ14DGMfNM((VUgJ\OGLA<
\C@7Q(Y\WN@A9\0HGST.7e6X9-0=,<W71;J1W+C,UNgcT;B>BEPNC]RGI]f3^FI&
,N/=cQ@0DDJMd5.[6bLT;8gN0d@UMCe>J9\\;<9@S;1T7>2/FUd^H8V.=4gO)#:P
;C;gQgQBdaF0f4c,>_?&gC9R#@W\_PVZdL2L)3>VG((92DS=YXZ)[&Q09@-7YV]\
1Z7Ee-g_JNDeb#C]I7RBOHR?_6BHHQ(,Y&XA0f6A5@C3O+;eG2aKU#@9C[K3RW[4
,8#([@K93+@MHJdb[KBYE;J=Yg.Y6UREA7YK6aI0OENC/,A0[6&BC4?c.VY5SWGD
J&;9a#.9@CW<B..L\@VB<=2,:G(+3dZYRJdBBag_CY)_gE/b\Ic6P4ZU@F4YLZMT
D:5b:#_b+07eQ=SXI:8QT&c-D:KCMPP))LERQWC@T&^,/_N?_-H3B&1ZY/#eUcGU
5J>1>d><_UG&e0_3(J)0LG63g9XO-8>2C(JLOc#C.c=a.V/Q5/c90]&a0)WP_6[g
AA\QWY5_c2&X1Tb<WGJ#MgF>MCdOJ0UIDEB/JFWT,RQ./OD2d^d7Ug8]>&S_<,5N
Z1(U;SREf[eg6&a)7(E)b>),>LYTcFX8CNXB([:4/:@+CU<QTAA1f=7aNEI=^J:6
.c3aB=64B=QF0^GY(Z1I6<24NFP1JB2X,YO#TCGEBMP;/+\J[G2]\F2WaM;G#Vca
)U<\b5&7>-@_]41M_GV)bcD\GSC<?L1KV1GU2KP2e:c?UGf.94H5U4^\/J_1e>L-
RFS@9ML7>e6=LggW+eG1&05(E94fAc\a5_OX<:fAU:/UU\E[(DL3[6/Jf7JK2[02
[Q7B@]6&?(D/77RF?1aT^9<dC?Y=9381-c=SC:W-d1fN#F4JY/_,<0DSC11J\g&Y
:d(KE\7X1I5AWU\COL<HW6Q\TO[&]eaE>VEQ>LQ_d:+g6/+X&SVYe2D/3HWPN,HV
MGV3g>4e3f-I\)]]c>Cg+4?(R\/97>V4#L?R<UXW0bga7@2.,P&NQ/F74?^6(C:9
[Bd@2@D.gI6]EUU(LSF]5GWDQ6A\#G)X]]f#Z@.e(K2D-,#0?@E^3LO4>I,\M6YF
)^^IQ)1e<+7K_@ED#G<:<UAcf=e-<80/SM]TB;+#6e#TNM/?G0R,f^?,d#=F^(;5
,F6[UMHFXC/-V^2bX3]b<bDS#<]:R3L8+eOV/d]@c4I@2_8bH/71[92\QNKV8Be=
7K_;0_INQ=V&N:[c.QR3CSJTBNBWHc7BY1JVCAI50I&0PfPaYZb4=NZ>G,BaCe#5
),UaGV&@Y5NI=.1>J&;6f\:1B@@9#&A.,=S+U2\b]9?T-CIb.>?IW=LeV:?((Cd/
4Y^[-R08IeW;;MT#?-O8d2Ia3=WRRdA:R+1)0_7P<87^Pd)1EPE-.BM]/A)O@eTT
SGJeN_e3=]FO83c\cL^V?Pb2JM/R5A63fLKN#f];R7PK5[Qg+Ff=K,\Z>Cfbg9d1
?:67KJ,J7@50:NY.C/FNAW_?a^BTegYDCKHGC,V_K?8626ag,H:THIND(1:?:<I)
I.#7dPA.5#Y:@7E-T5FGcde;>]/0LQX(,e]Lb05eZAT7Mc@^XF35:TQMbKd=&F0)
gODc6Q\X?&gCNGd_BVWZIbDRU@fV?&OfP5KOfW-GPe[c)).D;,Ja?<ST?YP?1Y8d
3.F\W\7#.1:K+J[5Xc84GG>UA(=cKB\TB9]@;)B7HfdAY50M/b5E4@RP<@J#=S_(
B.0YYfbC1>7/#O]6I1Tae7J.MW7J&#TSee9.B4AN[[:#+S#RN-NePA0e(#DBSc40
eQJ]+U9Lf>5KN4/d0\UcHAEM^ZY/&;P0^[RPFOJdWER:@61OH:V)?b0R,C&X@1;:
@+/C(N]+8>Z9f\ZYV=O,\[=XVBO_N0.)JM<7^A:B_fMB4N_<H:,TVS4<Y,++BN4Q
GZS-<@YQQYc2L0;P5]-#Q)U2VaEB5TML#9\HeB]]&bJ@SI;bN_A/d/\\<OBI[,X1
ND-MC0aFb<J1\)O:>CX2=P.<W;a4]3b2QWE04\Z6W??JA0>CM1QaX=W\&234E&=;
35cdLOZ22bgf<f_Q5VF3^K0TWf/fa.C1Ngc?R9XJP+Y9OYb#BaQ;<bfE(8[RRa\9
a+NQMg16b+-XU\;#8)a5>Q<dYTDHB@f3g3\HLFY)-d\,8V0TGHa0_DTQdP]2DP>?
_Ea/WdJ?7]8:+=][c\<EcGQQX0=BGW/(9LPgcaJVDe<g+BG_XJOJSG<c-H\a;C80
.]9P?;1\7gR[&G1c>=6CAV/66N_SWYZ2P9-Bd,EEYL0ID4b=1Y(8=\R,J4:Y3dgI
MIc?NWgWe_.:Eb/+Z^=A_VTYTdbR7eANP\fGTWgd8KX6S[BQ7<a:AG>0WMV0/I]C
3F;e1><UI1RSV\L1:Ng;RN?_VVOBSA_II-=ZaBDKJ6#L2W_&4I>YPg3UR/a6:AW,
HE5fECCKd)c\Bd2L=RRea2Y+NbKM)Ta;C;Bba))HdDV^F;@W+@[U&7\0,ZC>2S\W
YUMD.7?aKXJM\S+VZ#):AHIA>d\SW[P<MGREP[XBQ_K-V,,TNf:#Tf/\>9G-:5I^
G?0&S[4dg)aA65e=B01aO2:43J@[37HMVW87SNS&cSTFO@/?5c;FE^GUO+.N+6M@
<I+:>JO_;^B0_W)e3g_gH:L&c3HB?f58E:<?Y#d0;/R33N-.1?b,9EZ9f=B]-I6@
PDWO[eWH2IW[_2:ZK=N@.(]ABKE,3S\8[G[EP99COAL&28@JU,]dEU;=+Zc7DJG=
D0JD?0X8T-SF2_7/2_48#.N69]I0J36AJDUQB]XD@1;Dd2:#WAb\X0;5-#D-F55R
^TM9:&.2?0R<d]?\T1cKK0KSD;1d0B9MSa<S@V/]MKca2e2SA545UAL]7VTb.5M(
5JML^L&3ZH,,527)VJ9N7b0K_aZ+Xf59Z)XU)X6\VWJ#Z.EK_B@@b7cV,:1a7;S#
8WUgMW8Q:4EEUgD54[?:DdF>WGV,X>=2>PE_481N/X#F#-_XeH&KI^[MfMd?BQg9
JU;+E/UUBb?+WSR^c[bb5TR/Q(dXM-_OfMa3Wd+2C9d0KQA#(_[+)7BRT5\bU[2=
7767)9P)(F>F]M/&.I+IXR??RR;;#.,4=+L;@Q0@+CLM.bS535/]=MRK;a][.QUD
2).Ia/-OPba6IL3_RJL6afQ@Ue4]JPA225bN?];QB4g>S+770:_>HNDSUW+dJ8]+
>C(P<3eZ#>0QQ)]+fD]fb#Jf8:M^B32OC=4YQI.:<cN\TB8GG0#J3B_JQe.OCdf]
5MMQRg2(726;;>FP@d/.&^G)1b+c<da==5;9eHKN)1a_UOE?NK.A]Q>f;4.RWO#K
+B_IP2+HK.+:/43LVQ_::LU/0a2+<HW@OW(,L?@W/#XXbD(/dS(gZYf?3_A+ZcG@
<3XfTeI-(67J[,5QAf7^0NVQBIfE?#e#eBI_=+WFNV9PdCTgY4O76##HPYe36+&/
d43AGV:UM_d@YKWU^gV1-ea(O<E5.[-L32X50=+&AfU<E.:^=A1Q_bPS?&Sg,D-g
FH.7/+/245D8_>P>F6ZHO;:)\b#fO5-].a@C;aW,]XeG[5C?I[SZG;WE&d3OaKL:
/+[QC=@NSV-8fOE,;@U6N>9Z&Q2AaK7DM_7@VgeQO3^H#4\;5_#2N:/.P0P:bAHJ
F[6/WMOUS,66J._NK[Ud)(P=5Ia,F1#bHdfdBM85bFQ?+KVDXGH=9M^,>W/]Vd>0
O8G3e[1.3e)2BR7RSC3I\F4eaT6?#GJ0>I;QUGB85/;A2A<^+Q1F8Q.GR[?gN4A;
^_5c3YA0GFM_\BW4K;2<Y[UOHC3,C(6OB5->PQZOMYE>+bS@V.Rg)G=^,GERLfOf
#OLg)HMZ7NG^J2@e:EE]=9AKRG)#,A#HB:5a]LR:QU;NLIRb7R1@SFcQfFaK.DB0
?eABZbI4.a>R^511)2#JB^-U3KQT=O0(HZO1HWI6V8ER@&T-I3Q+UaB2E:A,Jcg<
>]gSd<8dH:7]T2?Raeb4>N]]eSF-f0ND=+B]fM)-0;D6]DP@J#9(JR95+QBP<^?/
B6MIB:fG\+?Ba[+[U:#;3_aZcAN<H\P-3>)dWO+B:@\aZQ9T:1L\Q-;Xe]03d8/V
(@A4aYFB^aX)C,?M91,><a:]@ZI)b.agSA9K<6Q19Ug-EQEId2=HZZ3?>I[ELINV
V,D2T(I.dg]9+Nc^^H<N]@NT&@X:O@-gHS+=;]YRM1a&:fN9@JcR_7F1ZgcfB1.:
@bZGBSM_I;1K,52[<R-HW#eXQ.?Y/.(M_/M:([+_XV6YJQ84RT\Z^]M,b/caXF1Z
-//6UY]QNB7IPCKX-=FE&fY[E=E[38UI/H[OE66g3FXV;15UX_?TPe0FJe\OKbDC
\Qe?d2WZBEQ,QLXSW?<]O[D,QV6RgJ&LeYJ7bMaH34;@<Q[@Oc6bFQLL&(VaW(6F
=7ZBL:<SbLeN66EHd(Y0VW)FEMY#)WE2@((<@GVP\=K6LEIYL(;d_RCJ@_P1d6W-
^NT:L=T&gB:VA#_.dIR;D\,+U7>Xd7M[VS/Fc\^bGF@;?G[,f)S=RWbWE4Dd.MC9
HV>VRU8+D7L=gDMS/Te?//Sb#+H7g8VC_[fc>b^/GJNAb=>.c]c@6WP[a,EK=fN>
6>3QTMZGE;&2B].<VN^VE/@[6)_^U5O@?1;,S;Z1]POM@9b09]YggHZD4/0(G51P
>9@5E^GKQ\3^2L0_0,gYbD=(bNR.&-d=\7NS0XI5Q[MLLRb9C/@YH_V\39BKX9)g
LCG7R3dQ_5O#U0.XDP0]_#f&39^#Je-F<M[#9E#LO?W)?gCDc-=?68b,^+(=+GTO
J,gNJd9>^ZUca:#R34_SX,N3IPDP8Y<G=I<C^/M@43OCCNN2gXW>EZ7I6;.;P.;9
DK/S)O.,RBXC1c(K]VB-?a1B8HGSWLHaZb9[-+H,>eJ[6GDZBDFVC)_\1O7W&V_0
GZ#@Md7,DY79:X-.:\P>=Ng\YJ<\^ZCRRXGCQPBX>KVLBBf:_B86Ce6/=R9\TMFL
^OFG+Ne,5:E,7?ZMVWHFJ16\.f,-]HU?7TdQ30ZX8:^+IP/fBKR#@JaT+Xe)0GZ=
<_fc@X[(C36HCaR^>III/AUZ<)(#]SfEB;7@]V9E;9]CM),LY^EJB]DU2Q=T0>SK
XJ6aR>gK\86=N.3/@J,73\\8<UT^FL[YI\a:I]HOST&P6gCQb1\,MZNWEQ29\51Z
[9bdU;fF[J.<O&U77OF7-J-14Na@7W+X(_0fb?0\[VS=.5KeR5OHH[,C9c51[N=)
QY0f>V]/@5>U(P[VIUafT^=V@B5_:V<ASL8KI[P5&XA]V8&:a+M.AIZ3SF.+U[&7
fJ&-[@CgFS9QLCC4SK6;FE&\EcY3IRCb1T;0^/Pg91QK0dOC5OX3HGC?+?T,0bS@
DLZQgBV8^F1[H[OC1T&+WGF+-+^@>M2=[V]GeHAY.IE9V2_-2?X=G71?5IGa;\Q]
6gbK#CVYD;U\bQS.G<T569/Q05X86)#:E/30cZ/CWD0Jdg;OCGIEJ,4)BFY&],b[
-<HWBIXc-^P=/;Y8_Z7:.FT#TB8cI\TgBP#XEQgQ649dY.QHJd>_Bb@?BeTeF+He
LbGgP><W_Y(I&&V<;FBg.(-H3T]dQ@>2e]>]VJCDN2G1R2#5AT99.9I/Yf_fIN4P
NJ&@_,(55a22VLA0NYgPg[C:H/JC#V9,C>D74)O+)?WX\;bX^N(=65D?GEP<^(L\
/8Y4Ag-85C+C2NU9V-b7/Fa^:)#O^\cYOf5^[e(Fea;)F_?52_T.QS4.HLTSD9R_
/>OF]=bN]H#(3+H<5&#G0#c.86N#<(94,AeTJK/b-_)OX1B_)O6UD<1HUE9>gE&c
I]XSLDQG4TMAb[c+<ZSKAXKIe2Ya<U_>D.7J4X;X_JS1</YUD;(IDGI_W07(+(4b
<-Y4DACK(>A0\Fb8XK2MQAS4b)949fPBEC5_ZO#DLO=(-8DE=?70@E:XV@JTd3gO
_Q8C:1S(/KSX<XP#^G6>[g-RdeR=eK?d^<Tb.^bXTX[()Gf@1)2=Z0O^E#W3OfQ,
#&S?TLD@@)I-@BQZJZ<]M>QG_WgI/EXI?FA:1(./WRXe\,fBOU)/VQK1.P.C+(B]
[U:_7dSJ]9SWFOQfPI-)[;:T[1?#1d.fgBd2<@cQXT]#WY4aaU6_W\U\B^faE]Oe
KCeGcK]^\5;MT/K&H#;g#=5O1I#+]N\_N2Z1=AS@a+]<baMC2+9/8<6U3D8AZNNY
.H,//B4\dId]]A/,;1cX[_MHGG&XfAeE58/[#;IHL1<Ic&_/A=bNd=#F3>WT4c)c
;[3LQ;<89aOGHX5JOCW6?9<]ID]#.+/)57&4U(6&d81@M3MO6ePYP6INK?-c&_9A
3C>[Wb\2W_-+aYbeZ:SG#XYbCgVGD,U59.F3HZ8C3O)U:&:ZLA7-5I[e#2?)+?7Z
Dd_=PKRE)@.55HVgXU1]+G,M7J0</ff&afQDKPJEFM@V()N\5(H.<SBDI2?7-?L>
F33Q]_g>U?UFX6e)>C/#a[1/BH-A+RJ4W&W[c2E^+J]a_3M@4OXVbU@Ma1a)UF3F
[,B0_C[UE^VX/R(ba)bXT7UEF6^f6/4[)#eZ8O?NYNUJNfC2SS\V65e?H_dM#F5F
VLGC)I^NXZcUCg=BPH(_4..)X-L5,[\dJ(?F90A,C6B8&^6<F<dP\/P8Q9VP6I4T
]LQgVOR/DB/&6\RPSe4fGYB38F(B8K,Q[(4C\c@V)?QR0BaJ[P9FWZA(98\23fO[
\f_>Ma;G[;1;P=2#\0)3E@7MBC:N4b;^RW6>[7D\eQ54XHT0g(_2?AI,XP[HS:7e
faC0JXQ>F\?&#GON-Ta/,#HY48MX&^:JO&V[F(X.WRC(Z7=A9WEEf>>NAf#F>2K<
8KT>P4U.U@9#+.J=DJEV^^bN>bHUVW7b7IfHONaC25Q5R-MX2R,W=6+eRf;=WB?T
?eH@99F>0<M]I(+:WB.))Z@2N>98XT0#_@F+U#<2bRF43Pb[Y4]aTdeWMYdb6cBE
#HEQf5c7AC[Z7e:(G(&Z.EV.9<YeEUDVb@2X73<d=?Sf7<V8a#(W1@1)ZfX3Q@1@
=8KebSeY<@8B[AIU(JKF;A(T45/<K?R&Ca/:EX#?BFgHC;ZfbTe-F7D-8299CHTE
&5LY7Va@JD-X)-BEA71>69=NWMAb)-#9Xe3VES1<e98GGEgJ)CfF41RcHWbSR893
aZTD#]\@&a8Zc(+0BeTX/,:Y[Z+XY2,\,5^4.>CNOAC+V]dP&XCV_#>+ae\+D?59
\E<fQEfTRQA0CQHCVb):1eS[>CWP(H8:G<GEX#1g-U<7M2RJ#1U5gM=g?(>W32@F
DP7FXTE=T28=T##\#GKeGS]aF+d7^KEFXdCYJGF,Y_7g7Y0BaF5.[27+88e_BM>c
0HaN74S_@Rdag8F:OKd>F)[)bHQE>,@SQV4/Y[7L=@QdCX:_P+L<b6L3c?V,]b6P
.U\Ic12-WI:(0+e]>O4#8\H7<Wf_=FC;M4=H=5=M>\_b>+8[+OQX&^06BLY#L12&
:_ZU.5dNGCR_&PY<[KH7VcX(O=F5c&&@BG^M8PB_>a8D1cg8^Q#ZSEaKPE09cG83
&g]T7JVW44a@6bf5d]CW(OaLN?85D65\&a[P;WUVX:/<C(C+]E:VNX?=;<6d(A[C
DfL#PD>O1)fDg7gQVA)4JU6C4T3(.S-KKLXHPLQL,W+HZ=<9ZP9ME>[K30#2#X&:
b8MY(S))7#aP,TOIGcBK1P2X:56;]8&];4Jb9T+(b@4G-P?L>gU#Z=bS)LTKMGI0
?EaIZ^S05dE&:K^M=<&;UDPFMQZQRR[&fXSQ4KA;cEASWaTQZZCI@L_V8XdaICH<
BCWg[N@R&L<A:\?:S@44^GgZY5K2T=T@2&Red)>HPcM0=Aa[cKV^TT6#VHB-+,N/
NKNdK1f>1HGG^?4P&B.C8C26M(883<7K;<.e>?\F<7\D@Xfg.D-db5a.<TSQV5)V
GF<>A49RdcB2&dWNM:f&gBM),Ag#FN[4]QcT9+E??DaSD0IR]F6gN)O;;#d69aGP
#1cX8ac(G4BF#\Q@\F@?.0,QNQ8.#^D\^AJF.M\IR3L5BM05,E+GPD-#CgD79G,S
7DGF6>V9LW-&fF5KedYWK<Y[?6]#V,G(=\f=b>7]G@IbA)P)AU-\C4OL55G]QSBK
]1&^@<MbO(EV;g73fS8Z(/7U&YG4U]TQG@c&T)91\+F6E6>KQP2#(=S^X]-+gD&V
-R#]S/.N3d5#7g,I)_Wd8N.C)?aeKR2P9cTa8(K@6f]4<4\9(;ZE>JJ^YFQc#:5Q
J5(JWR>Q([PTA[@#5IE])?,VS?/=00g?5Q9R&gGFEIfY>YWg):7gP)+_d4be8-G<
aU@+H560S7:2\C5g2PR2-9/)N3GO4K@<Z54[OJ3^JQV=R=[.=WIAFI[ZBfV0Ad&0
ed]+>NGAbQP\ZCC.5DT[UW3_d5,]4^9M/K@Ra12)/>+g:4Le?_BB]\)Zd.&bfdg@
Q+3)f8f:ADDL4H>VWH(D2:,eIME-=<X9;MYM2K^d[IBeCZS.AW.V:c#9?JA&[(1>
>bUG/b<NS&f2A:C0-,[S@9Y011Q;g(LF5Q4)0Z-9/8P4T,M2HX&U8.\#/P-^dCT-
SF>HUBG(W_cS/Z24aL6>9Z1K+Z=DTX]E_Q=O^J+-SCX=CQV>93IWI_=&Y7TI?N[(
?8c<PC^fIgW(K29)gbf&?T-<N\d6?FaHV.A@#KQ6CQEQEMV=CZA[T,ML:.1KegAe
>\,NgbY(JLgI_V=ZKQ7,;]]?5.2?181[2g2M7#^g5^I+D_cW#3DUYa4?0QI:[06e
g[O5+&5:Z/(S6WVg>MRT^,\=TE:TX]Z?0S#)(.?]QZP73+&9.,SG>++APOec?Jcc
,A?N_&HecX-8.H/L4GQJ8ZOH755PS#XJ-=&:AEP4C<#PE^A3V<Nd;dc1ZMMY,6RN
X+68g]E[K??>U5C=?^6BWIcd)GO96F5WbDJBSM42.\A4f5W)Q6K(GJdB(QYd\T5]
-VG)a_:#7&bPV>N+=1[?RKc^ddZ>5Z#APG6V_<PO_J&XPSJ_J:DHcX?&M5CSaLDA
<MSeCZ,[&)\Vf(<8a]CPaHE6>(.+XRR,d5)U<<48&=db>D)GTG)QGYK+\KK7]aO=
^=Z#MZa,HbOLI=EWL;YROMDDG-K0D(7U.PeF_O]]V/IB3.1O47\fBUW,;SGH#0/<
3;H)b@5^)Ke#OX]=aWbf\L+f_IWME8PNO;EE6=)<P=_0).5)T=((+U/XF^aGgA68
;bO.[AAf,:E=9\b(cdU[X)[,_NH?7NHFA=2-A?[>OYF@YD^K4b#\.2K8BZTe9E95
+KR]K0;N>;d.(.O_dRdSGNLV0#FB4U^E;QTE@Da.g;+](@_RC(;SVN\?S5S4)K6Z
&TF:+K6S,ReS2P-g(g7)BF)KacCZ+d1<I&2]TfR309Q;dY;2C[TgSLeXcH9A4].A
(?NfFI5/+9OeI?6T;>:&B6/@/,?RV&KK0T5Pa?^N6,&#Fg+,+S,2NGE0SA?O1YN=
\(5_R-@b@F&6Wd0bV.b2X+\g@f[3&5cFEg[SR<O#-=_VgE7,QBV]4XQDUX]?J8IQ
SOca1-DL]5=aFGDgNXA5b.=D7FCZDGZ0Y3GN1KRRML&(g4WZ1dG27S.:+,DfRCX+
S]T=+30WE(;d;c./D?\HDTd[WU3HR=:M);T[b:2[O]O7S@\U)?AP,\RS?@?8d#L>
Q]6BW?)=@L82O+@P)fNQ+9Y:VO@;(_cgU69?)Y[,_LJ_9)J:L8RAaR5dM_79)#][
PK)dgW3[X;.B&R@931JBHJ3A5PAcJ<:\S?Z6/-PMJNALB8(\KJLI^0gR;0A<HSUT
T:5;PDP[H>7PaV#/J#0_fQDg9AAHdOI]=&]AL@&:W=OP#XXb:XIR)8BW05L?R2?Z
J4^D1eg^.Pb@JPSM@C.21EMS<5NeAQ?NQgXcMdFJed[<.K:GCIK7_(&bfO9a(C(]
RZW:U,R>X6QS]Y_FFb;dCM&f+#/-P;I,[Q4d5P0)SL7=D;AVKSRVg^8eMg]@238@
Q#^:G\/]?VRFZMXW50X_1F..8L55KOKN3V/;RZJ?48;\:G+#g31[GOS>#a;EWVfB
[C24/QF#,P@H&=RG,V_-8I[P@eH;2>^<:41QaM)RGI862TPT5\IQ#&=L_L>@2LbD
5Ye9/)5.+Q--U3.Bc4a@,#9cbCa1KA.W4c772g<H?Ba2M;\GAAZJ&L5DMB<.JeMO
G3E\_?D(GVNZL4(KDT@[>&TcAZJ,3b,P_YWa+G@R+-6(HRUON>aL4HIe_#YYKeT6
7aFY@W[\:^S<O3X,>C+_P)BN_(8TQb<a/&D:+\I(E[624Z.S4A1Fg(2VO4M=fg9X
cB1X(8dQ<Nd/QcUW2QRH<<5Fc9<W=0K?DD>ZGYV3ZB3=;bd-E.WT77LFCT-+CC.c
gQ:\@QNSHT,#PAQ<GP@7.5]4C(WP,a-.:4Tcg7^:W-5?.CfEdYC)0=2Qc6V?,F80
L5,LU/Ac\>JNdO4&S,90E#f7Y<K+ca;e4g0d>V1O+3F]G9,16[2^89BBeC6E^Ra4
U6ZDd\cO#TO1^U#4A2eF6IG-OSAYAP2S1_R@NV^DKZ#P8N>N/AG0?cYA##(WNeU@
HXHBPBI3&A>cZ+DG+\E8FN9K3/@WI=Iaa+C=XM7#^0A(66FYdc#7B,.GF/9>#:59
[:Be&:#VZ2>.76^IP/G,D-3HGC1QC5.G3P0R-4T@]6^48;,+#EXRRF[/Z-aE^2Zb
VZO+IIRE7Mc>HKQT27+5L=3SSK)QdB[EL[JTLCA1]Z?;-dL;Lf&\5H)@C47XVI)5
_dCHHEa\4CMP(HeUIa6;:G)[:L]W)ZK6g.b2fK&ODHPbEf549?4X@Id;SD9e--6K
IOF96CDHA[H29U-BE4F8YJIeKKc+[aP.a;?\0CYd3gP&..U8F[<;Eg(]+>NeED@C
?PA)b&2>J,29./#K/HRUPJ,=T\,@J;C(d1d)gOLa=C+#>a]Hc^FU:Q#X?CQ/WW.L
&#TS:4^;M(CV@5f]Ug7ESe;&E?TWU=2@N6>R+O\(GCU4>J4+B8;B:M\QWb@4@SDf
;G=6)ZPT5Y:\ZcQfJ;BCNeLRf+C?-JDBUY9O2(/f2A+]L#HUGJ?U4@&NgC35ZA59
FB];\^E>[2aJW?SPNX97MRSQa\=.K32\EcWBaF2d;.GW]@+4/:c0D8S2+^OO>5SN
b1(FV(+BfC-4F/f.WX6;c:+UR&5c)O8D&S[H,Zc/D7TeK/0,^O_WD?RF,\6-_VD#
UfC.&#.#KV:5XV\05@[ZQ6Q?gYD.@eY?LR&?Yd==8dR](M&78EYZ:=(8-,NY&-\H
OA-/VNg?f^/:V=[@JK2;_2bB1?),XBGP&Q0ZZg8>c_P<DTY/gOEcJ+0M?Z&96Mc.
YJ^^T\?Y3cdFQ84UF&CWOG@.#&S_5YNJVJ&&(=DQ@H6Of##@DdRC3X3<CV)2I781
OKY(E+&V0.YN<a^)CRc2aGaY1XWXK0<AW[L^)J<X=KC;6J^1X7XVNFP&]YN+\[5I
Wb_5Q_;B/=faTM[d5=OQ2]C<1A-DT4]@LGMdMX9b[a;]H@4?_&9a6M))NB_AV:?<
?ZU5.#&#C[I?4fBN+01PfcTe4X\,H\><Z#9T2<dL6T)EZgQG1#AV]+aS[XBMa1+B
UTXD&V_U3@gFXf(SIU0(TK)>0-U+IS:JP1GKWA20\8/UbMNU<ODW2O5PV;XOKORZ
b5CdPOK=aBMQ5GH^:FE?K/Dg1f-U>+2:Y>P=a(I8O&#,^T)Z[2.+.ff6&SHUENF0
<Wd;2A.<:QKPYPW)OV0D6.UEE);=RM4CF4,4@^?U=<;TWG[PY:XN[T)6>?8EbFIT
_e>+5=FTRR:3=)Y:+IdC@\0eU]&Lc^68N&6#H1;[4fBLe:4+?R2Ge43SMP:PeBcJ
W.#V/9U0_QKH-XT0?VB6064JH,:[BDH_\;>3eV([SY?K;XTNdHCWdd4SC=cbFK#&
:?ECfca]K(EW31<HaUIa=+eY]B,Y0[F>MQ:Ye;ID^6I(>(CLN/)d:8EfO=X@C-AC
#9FPY+R-Y#^_A?AT92-<9LSF.O?JaUOT,G^1&-Jbe<)\0Gc+;SWGG_1O&e_H>eJI
OQGK+a6PX7H0Q7K&<X9(JY?4>3J#V-AaCI+I_TT-E(=Vc1:E063X70WG6g][-Q]4
/O\^O]L_d=^SKe<Z]O+bL3N5bP3.d,>:>EIdW=6LE<V9fOR^/,cSYIH#Z?POb3>8
A)DcDU]4ZPEHf][c9@/SJ_..3fUG.C=XC/\/P=L:Z0:?,Kf3(W;\7C8RM)P)\+RE
Z6^5EbTD=TE3?2=C&XePG2)DGMFUfZbKeB:JR:2]L1Y_UO=CY@:Z8NXa<>8HSJPW
PHc6MJbeN]3Z3;;4XY0\.F[WVGRL(WZKA=FN-5>FO>4^KRYAAYa&g2I3[\O3E9TV
6_K6L<6V_(/R(E)&B2_1]b=>DM_dVA=5C,K^H:->E=dEgA<]4936GB/bNIVH^dDF
/MXeI_.>C>FIRN4<015+Va&4SdeSO1AKMOQGNIGT(T49YKL^3;WK:-C,,MPeXYFO
T62IS;B+)&[4+QU/G;Lg)-J:Q(aV49g@YYO)_+Rf81-79:A4C2DG-LMZN9+G#H+/
XK+9+LZc/F-d5E3Ua,..DR\ACDS=]8XA2J;I^>b3f0EQOCR8EUT^\.5?M:NT0V1H
FgOE-d-/\\:6:UD56CcFZ:Dd95W[94Yd1NN_55H>=]H5Z<M)>UH^I,];3AD20(11
:TD_I9TQ[S/d&^.FA4&TAKEN55W\-[Y+VUZ97+/Qa&[dFZ8c2(1)AR:Z8#gB.-#Z
V#I/0-N9@:0\A5((M@fg=5?_)^?=&Q;QP:?W=2W]E1^F8REJ44Tc]Y:\KIL:dec1
AgG=9?V(1;X:)>^LX[NgS[d/XIR&(3OR3C\]C0(LTVR7/4ET2g1&;OJ,KbRQ-8,C
_fX7[^BHXS&B[M17=FfNVH[c5;6_@5P,Q?0+eUD@V(#BR(GO4K?.3PVEYEENT?B7
WJZH4EX22L+g&JGe50A_NXEc;7f+>X7S^CV5,c3[UA8S3\_d_]FL@UQD-]^MFW#d
.HPB^8>A[,WXZVMS&0GSE.U=\V5e8Q((<f:BadSKXZ;B&GeL&d3TBAYS@#WHR6S=
/W99T:NDWRfTeR(^cQaZ>b#-^KJB^1gVP^3bKDYU^<934/=,ZO4IMWKH;T[7#DCF
BRIYK-b:Q;P-P\O(9)/].WF/V0^RCAc]#(JU5\8X,T_+baM+J4PEfKRa,+(0aSKE
HU@=X\/0@Ned1-B+]LDf&6<#cT@T]/Z21c2]>GKYV2,e/I8KKQ6@gLDc6,&EXA&D
,W#,V=UN_?T-6?37X7ZZWg@T(b\8e5Q+_C5Q-g[PKcB,Tc9+9S6@\ZX1_^g/L)^Y
3)M\9K<<:WCC)EMOGJB;2&ddA8C).bWIbQ=d\\1>_D19WWY0BZ=>R?\9T5AFEOf-
M:.5Z>^R+0cQ?LCd9(eSeP7c60VCTbf#KYA_:83&K_K6NOf:7_DJbJA/e<<)R>FW
E_E]?fLA3DKeJ):9@G<5e9,1J9PEZ7Sa8HS/LTKJc,)0/(@EG+?+#)N?gJ@0<dDL
.3ZI5PTCc0^CS&YSNR\^_RFX.P4T^\KYc/[LB.JAQ3Yb&6603C=Z(8/f1T/H2Af[
TC^1T=Z>d7-Ad)5Y2,#\dbO07X--Qa=bXS9LH.GJM-)bHUUb^K>f1S^eUJE^W>E4
\480E::3Y4g:fJWeE>CTC-45S]H:6SC]JWTLF7c\Q6W,+CA\QTZX-41@4Ia1=9S8
0@JLS5=1(R0Td<JO82XKZC5BQ\HMEX0d52LNKA/M_gFZ,SD]MC=_ODF]b#B@XDNb
6G(UCV276>Ua6eSN8-1IX]0VFC]#];fD+D-#&b0:4b9E2]IK-&([HcL+C=MdDA3P
L,geO#F05^N+>-ACeQ4G\A4T<9W31/MRZc-9D.=9LB=44V/BQ)D5.F\8X@_Z4d#_
d;57A@&I,(9&E:V=-5aS]7+Ib5>6e76(IFLMBPMIUE&\d<T^2g+4-+Vc&6dN9]5a
Qb1]@bM^;[B?_a>.,JQ:/dc8YP-c6U)6.JPB<M^&Y]JL/TTDebS])=V;<5dA9TPK
68_W?94T7.1L2_JF?V23\-<8)]9:La&H8gP/JMS6gA(eVB+^_&CISJHS2V)fI362
FPe[7;=^W#<77QYQPOX9Z1Ga?+UU4f>F9V(a9S-\2.CdZKg-F#FOg)R_/>1;8S@8
SRI<U@DM?]G^Q\,5IgXK;L>6@DTRWE]bLEO2,+(K2^_:+SBKDc4AcKS7.SV++2.@
0-GHWW9-IUV=_F.#QEYQ)C:]Q5KGN>R0M,=W(,R/(>I59cgRcQMc;c5M@-4/)IX,
@;dP<T\ac,^_0ZEAQ=_(<N3PV8+.)0Z5VeZECIe^G;I6e@GFUBd6P3MH<3Y=A)^a
PZ)]1(,aB+e<EI)DSYgE104e3dM#3YTYMcIf;5LIZ,FL\dN0[HFT[dV&KN<CdL>8
57XVEN22Pg)V&</__aHLKL;Xd>O>aa?Z+L/6a[@41ES.N+HX_N6@W2E54,17+J2Y
[KG&B4S[bTO#d9Y,)SO93/[&9B^X9O9RVEg1Y:]W.;=0:db>^3:OR5_K^G7]?[VA
XYQE[]X^.a\Ifb[SP\<Z>NNG29Pd;&VZ_CBJ:V;6\KHS>9[UfcP=&.^GYK897b8)
=32V&531Ccc&)2:^>W[,<@5Fc+be+T:E,cA(&)-ecX+bKSgKMF+H1g7RR7?P(5?4
>7#:=C_OEI3<C+1WNBTY7bSKX?:GWb7[dW(^]V6:@5_:7MZ0UeN1F6F=+W@R5g67
HTG594?[0=>2H9T96^SI_<DY6L[W,G0ODc1JDP>d^dffI7@(\;]-9,EgY;I?]c<F
>&aMGRTb.EFEDM)M+XefTNg+-27[,.ZL0.0);.BBJYNcWOB&[dF.<c,>d?;QVLeA
5a#8UN2f(2e:#=f3FbZS)TM^&PAIO;cK0^P#]CBL0/1]eQHJ?Qg7<=T^N-YK?+X;
DH=U\f@;D,Z0f8,L[M>2C0/D^Ad0ZTYSO[MN3;#8BJCXEZb,QJ;<<:)E^_C3^5DH
M1A/)HR?Tb+>dPJZ[W:DBN:B5>OGP.DeXQJ=fGKY>g03dGgLV,O;M3RN2dd14SJ9
8](;.1F0a=6ZALS_.^3KG<C0B?)G,Bc=ZBL=E/3]-Mg_SBC[]\^.M>EZ&POG1TGB
>3,B^GI6;b@_LGCZ@NZ@/.Dc&9(G<OG]MF&M7W<H_<S70UT(R\E3EYE5SCGVNE9E
2:&BOMRde+97:=\g_ZJS82C+))GAE0T,^TBe=(>?F4K>B-6S.U1W9deU8H2M5QI.
2QDK&CU/UA]@@UR9bTDg-]M<G3L6.&3b(Lg5@>[Q&gNFWF7bJ=ELP0X\E\OC5)\f
=S&ZN)^V]:ffT)PJ[)@=OADO#:BDUE_af(YNVG_E/LLY@e^G^][2I>cbdIUBF#fZ
L#K9b.,D)+Pe0S6-Q&@e/+Q3Ya;>73,IFHLgH>]cVQWaZJ0Z6.6^GHO?\<2Bd+5U
g)U.^9agZ9,UWI<T@.<_OfgR8K.0(ASd+eDa-ZP1HdL3GRDdLGJ,\88#MbSb0.?g
:KF_GXa&P@?Q7#K)<<-NHR,\Q^,KQ2N^Q@cSYYUI+1SF.B.K39]eY4.L8f>F<Y<A
..OSL]]#\C.Y+REHV==^_?H-deQG5IL6TfG.)Y2eSO?FXg\)M,KW>fFRX?>-;4JO
=#Qe]SY@QQ:dPJI/JcRNb>7B7]fO7](23HO/H0F#]+@&M7)_;>S)C?/L@#F&/?0c
dXfX[0APZ@,^5R&(=]#=bBH:&::O2+E?X1(S9==:U#-C@/IHS@TIgA#c9+:X6c+M
g4>70PTH):,654a:J_6>8@QLJBXN9bH/0I:)Eg\I_JNT\U>K25W6]5)JbD7]@-ZR
=B1YKVW32d_WI8?,ME^6c@[eF#TJE_OB>a-Ze49=>)NG=cRDYTRO700B_T)gJ<H3
]T:2POef?ANb0a>8Z:0[WB7FG4W@e5E\[4:<OIM]g4(RAE4K>ZFD^KAdg-34-cRY
Pe=9K(ZRg3Q0H@W2EG0CX;,=F0:M3\F7_45eJcXR.Z>YV@g<_GBW9\&Z8VU74R^?
&cB/3AQX)#1)X5T2)f5IN.LC>ON_=JH<V;\[,f+PZ9cGWgVT^0\^9WG^O+((@)5c
-I7N3[Z&.:W6WEg[gXP957[STK0V55KBA^J;fb]C8IDOW,+XfXc58V40ZYP?5&D^
3d_3RC@5)EORg<bSV(@g-cZF@L.UHVKK2;UcM)C#SULQA>bZ>WfJ#HgUVGg(g0C:
,?LN[UdU\MIT=G:a5c[;f@\0FYIfKP)g,4IIK:,:SXY/50PO99<K,)A6>22g,aa?
f_#0C4&#1XE^Ie;AbHG],<BX9GJ3P.S^Q#Z792S_>3H9.T.eBMV,DXK\Ig9506ZU
S3-&EYJVA5#8989GD-7I(W)6edFgDA8Hg-LNWa#=+?&,?5Nbc<[E=<f5AXE:,S];
Ja4.T34&71a+Q11O+SIU##J6Zd2N)+0F#634I09+?;+R./\VD,YSYgH2eaE>OJ-f
T7#[GP-Q?DD=EA;@X/ZLA<)8YY#_KR#^_?)6a5CF)@D,M;gSX)M@0F:QNdbS#,Lg
/8LZ?aA)EO\6G0P##:b(LS3FP(#_>fIVS0W6G:f.[1<?bR+)+DI73YeW2UD&-BE:
f-0b;bNM7Df&FP@?>0&S_YKc++-#<)8BV.Tf_F9L/6LHB90WZ_a/S?9->OI,GJdE
Me(g/3VbNc&I0P#UM\6_b5G(I0/AALZV>7/#DN7.V&(YY2.F2@>db)Z?R^<Z3cQ\
NNDgR)3]GWe728QN/>O6I9H?gc9J2VRR2N;)CYGM^4de7+>+a3<E>AaI6?gV#agB
TBf&aZJM;D26,K]]YAgHdWYge8HT>+AH5=#5WJLCPc+[>eXLaCR4EIeSU0J]@Ra_
f]J5,7BXeW,NLY666abQRW4EZM,Ba4+:]WaS<[H_ML-6PXDR\<#7g^9W?_XQQ:Va
gY?]bLNgVTT-BA,bW8dO-LNQKZ2TG+R5-d,cDV42MARH93H\.bHe8eN=+]eZQ4+=
Aa-(>9V:WZFW-M50XGET.=K=2ZMS:&JC7@RT-7I22WU]N3N<.RfDJMV)JBOg]cS6
e@+M46LT/&;ZDE9?2e:.Z8H;_@6])I3/6RV?[BNOZ/=CBZP?Z_=)>:-,?^f8Jg?G
Z1(MM[:6B9FP#<[VR9#eU.V5YFCP[Z5Z(b?THX_U7OfTFAcT/5e+-EQbP0ALZ,2&
1US/DN92C3WKBOQaV3-:KDd89P?\<LcE5dd;E7P<89O\R-E&&CHC>5g/+)HfVX3Q
XC#&/)=Nc,M94ddGWJfBRL6V^5D+WA>,W17/2WW=b2[.T\-IQ)9?CB8K-.)6>6Rd
[ZbM.?Y4;;(2S]5[2^:P_Z:P,(6K7<J<FYFaP79=Ac;G6+)SR?PBS,8YDJSM-,CJ
eX)cRIIDC_N-<)//)FcO8Q-cSJ6+.d]]@&O@SW.QVE6?cf.T>eMW,L@@9DH<ER?8
AVddK./4Q_76C0H.FS@-=R[Qe>-<^.?T[fgM4NGE87O[)eESd3FMG7Q)SYK;=G(?
]UYV@bcLc<B+HfT,M.H>cX.[EFb\>M^((PX36]WSAO<8,HMFSaFN[.EaZc.a9=MK
I7TXcPd#^,SQASAN9[R5fR:][Q];gRJ(KJ@Z^J>U8UaKa?f5YK[A8\e\\-@)#DN/
T.8)]J-=df6VdWOYU[1J;,XW2R+BO=,G\HC5R^Y3H([AO<(JD4MacTL7cX-adW:^
TM#cPH^2Sb3Xa/I.b_@=1Q:C/3YP<3b>ZH9KI;NQeNe&-9B5B3>2g/aW#W[]7.Y]
<3&e:cD?JdBG5G-8c&#=Leg5Z@5c\d29\He3-WVWJV^VV4UJ?^K?C<TL?aCC\84.
3(Oa@&g5QOAO;\C;X.6G9D1F^ZW#C+ZD7=6FSZ^g?YZ<f+>bL3LV7FK#TCCLGXY.
S>#^dI+e8a0EY9dPMeF\.ZDZH-WJQ5ZQ,8Md?Z?TE[9G66.B6-F(8X/H/?(VOK-#
V[/e<+CR)JV8&<fg:HP^;O:gU&C77U,^WR^7P4?BB_RL5MV0MK?ab1G1?1^]7K8K
U,eWaD)5N#<HaZQR.6GZ&MMg7L[6_^3[c):G7JO0WS]BTaC-X55^L524HG(7^-Wf
NQ7PER?b4+H+cYgG#))XW^@GcXCN/P=7=?M9&<0F_=MfH1K[AS^[0R>Nf@?P_)bL
1g[R]edaQ=ccB+Wc[;)D8X1V6?;/f[SBZ?:C3L5_QV&KIP6@.5=OQT)TJc4I0[7B
OWI/U.6LaSf<e)PbYeTDH1-a:U9RJ.LYSLE44-(F@YaL]SG-^/8cHAd65J-7JdM.
g4:T8[>Za,^#f-NSU3[Cd_d\<:BW?QRCf:DK^e&Z;+7303:+E+_7DfbF1X)eT>ca
ee_WP74GcDL&@:[WcW<0LQdF,>/+G.6HJ?8dKgJ]AU=<<e6^]T^Q_-4)8[IbHL7N
],I9faIXeG;dLW_Pf[C)X0+Sg9]0?/a^.2VJef-I1S+Ba,(G(XaTR9G[5BD9J<=d
(OPSaVOJ_^0FBO>..^RO,bL_X?2?7WLTBNdER(D[^A006RU&G/L50R,e9X>@O-MN
(b1K_8CZd0I5?[,U<f0[V_U^0<IF:bAN9<)=@B?_GJ[VT[)7_a./,S>^Y<SdT+T/
MN,d9IEBff[<Z/N2U#,XfF-#eMS&>cdac0?);bU\)bIE4:67C2QY,d=fKgID:3aM
;LVDe5#&J5&OgCO@7UA47^fEL/KV=]Gd8TT^9PK7S472(U+eY15=MW[SU39aTW@@
S;@5S&c]1.gRI09:,M;8;;DY+9A8.RSQQ-,AIJ)(Ce>T]X-I(O+:<gVV@.EY0#[P
#-^AL:E:aVN/WX;6?GU#M#T<2<KCaHFY]_\<Jd63[eA?ZN2YTT,<C6?ccLUTPO@(
ee(J.7NeXXR/QHKTgSPU3UO@K_W)BL&fa=_V_IFd\KH9GB^B2)^V.Y9IN:b2Fee9
;/LCT7W\IE(JWX]7EJ=?&7V/K23B5:&e)+>+e1)[K(a(+TS7R)T5dc\:=LDYb>PK
W]_;4,eG(](#VgNCfQ(D/NW5AO<4R^5AKT[M.Sc_NL:bNf=.?5XO;#]]K=?Og[,P
BCKBJSUQc845?7ZAA_GEgLKf<3)#^?)(NJR]HTHYF)55c/C\<=fWNVIMO\Y2AQ#d
D82@^FHRHIN.B4G/Qb.12KC29@\b\_IL+6<Z+Q]UNY.a&3/F;]+RcgdDTcc19+@&
<HBH:-2Q@8WN\XFaGRc);b/.,8)63a,]5@=ELfgbdd^\dJ:gM]7FY/Og;FeI&AA@
:1_dSEO0a><I:XTY7S(ZR7/Jc?O>0[EBc<J.=\T2\4SGf>,e+>+Yb5([57Id_7gf
IdLXDefeG?V[R>]S8R_@(ZZ7gRT?K/IORW\V6&2U;ggAW-QMB?)7?IQUaD=@Od7=
X.K]SV5Y]-a=[(d@-fPbNZd>QdaTP@9caaX2dU8PgBQfR#1_QYW(DdG\N3XOb<FI
M-2fBU)Q-5=I-->+4GD(3\@-T&SSG\25?4Q3If<@4VD+PPVK\9_KYOcPPIK0PFXM
[JN,AT_CW<CBK@8A+DI51&FX(ebCHaSc+;d<;9H+ZKJ-07cF2E91KUd#Y?18:LbK
)f_=(K1LG]egG])ZA/WQ5:XGJ2bX)c1MfGf.ag1+SHJJ<7F30ITB0)L5@3?7QQ)g
+b-=XW,7GOU(HN[DBM^GN&Gc8Ve?:39N(,_E6TUY<a85J[9_,A6eMBA8:O1S@KQZ
20a@4.Lf.1NWZM+>MMGQT1V<g@M,GKYYRa+89RNb7R]R6Z+ZOK[aY^[?(U>@HRcF
#;W5F=&,UE^eG:K;0,0WIVeA.Q,aK+ALc0VcB[N[DK,CV,J<f[CcPWd^(1&ecZ7(
8+MV;SI]Z/R/(XM.YT3gZ&gB&^FSAG(ePE3]D=&.3W??R/GYW/\G.M#M2E;a,KQE
Y/NC+01DJ5AW-ScNMcUE.Z&_1[;<29&AHKP=BVWIVF[\)MYE:N@Nc5;3HD6MD]9=
6=)dd?T]Q<UZ81#TJUB9E#;O^6#eLMZ1Xg^DMP)[I6.)XUM6MMJ0Y6caeNbZ8e,3
[;UYWAVQMK_:2PJ1U7[JIJOQ0b:)TCcPKeW_QL]ZD)3>PW[_/ZXM9b:>fVIU@-Hg
I_1K0c@5Bd7OQOTfC/a+;]6KL\5/EDc_-.SH3BBY9>B<D3NG6X6AN8-,DK@_XC81
5#5F^RP>Wf_Z<AK@O+4K6d(+QfHfN:DD_CUHRU&b>8Q_X:Z..^OYN1BIM]f\LZ?;
O3eb]=>[]K+J@=5cWL^N5IVG,=[W,-/<gM)S9ILfRe=BI^;8(TeEe)KI9cATGf?f
K5Pg;)DLP#+8S\B(PTZD[gKSYcc.2LT9FC1^E&&9M+d>6TJVa+0_@0QNNZFS&6&f
GJ<CY+<NZ(?+0].LCO;g#bK<3)=0/C<JEb,1ePAU0>.HD;Ef;F)^&&/]9cT)77a,
J.]8da[4aY2eX_4Hd/90fOEJdeW6D/,&^-.3Ec1=dCSFfb[b6Z:WH-:/B8K:NAUF
7<EFY2SV/7(/](MSKQbRR&cA1826W<+O@ZO>1V.3?[4Y5d^83NI,\Gf1(2:WKHc^
.>7dQ&9]ddfF2<D,(DE.#\;#52W?_+geQD_S;gW1=>;5E6Pd&4PWX:CCC/;WQ^T?
WPJY/g3XFQ&4H2V<dNb1OYMe5255(]e;.(5\DSMFf3YGdTT&UH@CbE\/4AACR5e@
-_A?Z]UW(#d8[a:cWe,:73.56=0I/4&REV,SR+WB;V5Ig@9QaN=7H=.A(QWSd0aO
g[=#EfU;L,fFMOA[,PC6I]Y)6I096QE[J5HJ1LA;B1KU,b39,9TG_eE.SddF/E&S
.,M#ISbKB8[;NBA9FYL\05<AS]5eLf&1(a[KE[^JQ]F(L1fKg?d&4<X\edO3d7gW
f3Yb/>\[\6]NR\?YCZG,L,2Q?RaVB<(<&]F3\NKP5)30T4cefL\HbdL6XWGcB805
A9DE1aDH?[A@XZUF-G824N[1HWK&VSWaLN).VDZVXNWR-dZ)@^9GLD7^S;F;OFU0
)S\c(\Y-\NVFBZ2,=8\9G25+T<T@[H/AI_=a&>SXO8eWF361SD34]37e8QJ-0N=:
V0T?9/[M5cB1^_I)XAf#N0,ES2SBb4d5K;DYDJ\8b)(08^He2_e;O3OZ@F;93&cX
;,G&]_cE5f:RXb=I.]Z_^@:/RD@<5K<G7,HR<_f,<2<A+I0+H&&7)YC-FLTCT-Z]
bR<PA(FENZ>e5;Z85FCN?&B.R:].>K12A#-Sf+8S2KN0PY<Qe&P_GK#bBQdKAA.;
B9<a4]OaN[H?IOX&/O-Oe0eX#_TWCJV2U)/#:&16D=F=D12[+=+X:,T7NY(TV6A[
JENE&?]HJN0P,PMG&K#64\(MJWf4=\--Ee(e7KXa(]@I5?.,9>aD)<G&CNc>:;Ue
:3-6d?8C?gYAW8,IGKZFRRa]F+^-Je_2NF-V>?5U\cC0PAJUDSVA1+].=K&03)&_
35FWC<[K4A;:\:S[7=^dR<e<W7V0W/9)>_gXeO^&OcBEKRG1R(E<#OTN#gRC(d25
1EB_GO&5eA,]\UOYX4Qg(AK4e(X^ATE5DI:=:R&S?S//U)>,QP9^R[@(XQHGeQNV
,3c,DB?0LL3<Kf(beaRJHf[R6ZQCbgGO(Na^9L&[[c^/@1DVB(cZ_L(agTV9gVC2
LgeX@CPXH,UC-+(F2C;\OSfDPUYY-eFE_2NB,_._5;_5=>,6Y^U@+ILIUNFJZ).7
8GS&d?3BM8=[T?TaV7-5PBZdL>X?VaD3e\#KB<d^]=P?Y)c0^(Z0f-)<Z1Ab&TG@
R02Oa]#9H]W<VKd\e;]KGH:6#]ZX-1WB_D\,)A-&6?IPE@c7S82=-LY9Z?HII;La
L\#\L\QJQcO,+H+f,#SVMg(8X]g?5+H(5d@>,U0#)McGU9CbASb_ag=ZK0+YK6LW
@UZD4fT6PXAQ5D&2+e7a3DV0Fb[F0:@bcOD-A@&=K4c)A-O&a&S3+C-W1#NUgC5)
NdR[e40e1):1:)[TYPD@bR]TB[#0EAfJG_CN<EKfRFM&4FKa0FG4F8e?J5;G3N,^
&7D#)&>1U_B&HFTKV3II8f]7R,F=MLO;4\>8GZBUPC\KB-0#7eC[.>THVG>3OWF;
,6#E-VU@93A9g#9;:K5(+O.5W5?DIObS\C-H&..CI.WJeS&5FL_)BBC3)(5NRDb[
=;PdM;g:LOa97;C\TC&^ef_1Y_(,c,QJfDe2,B42DCZT>1T5eaNKYOEJS;BVI=VN
UN]_Y(6O5McFU7D[CS.3K4N)ccI[ZAGOO8a]<c?([Lfa=AH(Y5gSf1N7Wf#39b4L
V(U-4@:WJ^@7TcO,V3X+[@gFPREO4X^8g4H@c4@UC4FKV+J7OOFD>cR<P\e:dUQ]
6\LE,+P_#YP&VW@Y;^01YfKK(dYPLaUWaP#N.O4G.MVZ-NZ7TI;3QcaX=M71R^FQ
7TT1I-DdDI&E?g&M7-19X))6+_^[=/Q)Q4.;.\.7fc\>VUfT3=^DgR]^RaTU0LBe
+1DIAN7DM#PAe^dDHbNFF6#:J8-]6\AIV)=6]4QS>_NgY,9d97_.RV?Cg__T&eSV
8^@T-(.I]UB#Ra_L8J&fObUUDBB/3H?ND<E-O?[d6::/EJ(f[VTT1(F^+ZKWOSKK
\K(153,?)\^8eMXIR^FY7&(([L;B@[bbL],I[M\3dX0bD3a#UI/TOcNOY#Z\W>:H
^b^UdgUXS>@d7CNI8>.HgV^&=NPO;?8VAZ?W9-b1>&TcZ2a9,T,CgRY>50DFX1[9
ED]c8I?Kf6HHIME8?X99(1O@KaFYRWM2AR4:\)Z8fGRO3WdU3d2^_TLIfPZGf.G+
5)/-JKUc?.A0<bG@@6@+RRBN^+>f9:&&V9Y/D&B\Q?)CX_Y0(eKM;/AJa]7T^?e:
M\R<VfCVR5JWSQ<#aH77R[6JdU47C\:M&aD5CUT_7AQNJ5eBb[DeN.GVGXd8ee\F
_C:Ve63&LM4F.f)ZO+U;S+gUF(L-.-U@&S69Tc<M,59]XD/bP)\N0F23b&7XPFV+
<O&GEHe2We[-3CFR=^N,2CbXbOVRVU9:G#4JDXJ9Q49[T&WQ68O-?8.I&45J73,a
T0\cC@SJ2FS5V9SHW4R,f7WR5M[:f]3G0TRF+V1#++RFY3COQCGWe<.>E,@7L<L[
66?RaGIJ)FXJ4KLIR8f]07CNGY_2<cJZ.Q/TIR+T9C>5V0&^;/V/Sb:Xf:19]7;d
aTM@3@KVbDRXId0],=898U8(&Mafcd4KAM9:S1cW33LXDS:>?>MEGAXOOaN9,J9)
:59e78E.G#6^Y7#eFg]/8\]<dae:RQ[>O<^T/\1M,#+5U]0CfRAb^+3N;RATZHe8
K(QbJ_aW00F2\\:N]ERI_(bM=E>K;a9,\FJEPEQg<.g5?J[G8AQ[1BXRbe:@#<31
,@M<VSa^CXED.S^S>Na1?EQB\;c>3M\NQVeF?X]c8(H^NYCH^DD4YI;TCEOPS6D2
?#8F#b?cLfZM@=Re].NP/[/[A&T.O>NHLGH4[..,=b^Y]\F>89;]7_]VT0Sa#Seg
2A6#<4[=\ZE_cFc(:FgcLdA<<cEX56379-d&EbD1T5dOG3_1fdZ3b&?M1#,@J/E(
Q;6FX2ZZ:;/F@W\5fOYB^;UFLGR,eQS?;37QBX.#f-]8FYOT:L.F0d6Bc4]KKf9>
6c]I:[H?dBDeS-]K3C)Z\^gXaT?FP:Of(;,B//_KTY#(g0cMZ_)-:##_;)\\^>B<
K#2J>9U-=CPRQLBY]&-,1WM35YC5Ya#Yggd^GNH;?e5=WfP[EV)0<4BLbK^R7CG[
V.f)@_c]-?LRHFXRR>LHET89/_F=dL(6+XM[S)K9@FF&)XE@ULZ+AI19)\/3E@>&
[+b+5OARYf1_J>I=:e?PTc9ZFHQ+^=A=+E\:Q9c?VOC8LHWX9AHBb=ZC6C;Q1T@:
,_5FB^+6S/P8+,&X#fdb_)+BW.+;8#bCR7P)gTHQCVO=XF07ea6bN^9Gec4E3KWJ
.Kg/CAMcAZ(AAQ,#4]Y^B@Zg&Q]cR;<[Sc_).R\_2g-g#=HA3ALGNc;4(CN6c[B\
==K<&+Pb1IYWF-#d0Q0C.N^+5PCW:UIc2;fe>.b7,7g4=HN@C)HN8H5#>bM<Q9,G
#8REV9S+<FL769Gb^UbUdTa6U01V];OE[G1ZaIHc\HL#\f4G6FYc1bI5-BSDGFUg
,e]g)@ZI8)Xd2OSYd6J+a&,)\QcY_c2,8EAf=XL]?95ITS(51Me4E(dYY]9<^<+-
_dd?c4dK/#F8PY>Q]<bV,4/,U?T0;ED4LPV(FfDXf7114M&bSK.E.VbR_[+>8OPL
/7cFJC(Y@0GZ>K;.Ue;F),-HDT7L.b,[RZ6a,[&_#E>GM,dSe7WF)B\,LBG<Pc#7
>,?gVVc)V+V8_2?>e;R8FJZJZW.^15SHg-2[RG)@e#0W\0I\b3-SJX8\.(d&;]97
8/[bP>X0G0A5bGfON.(265SW0G1L@6QMB;-1VR.\YOT)J-72#:5[BOBH408&8R66
A9XU6bHCV^9CS()3b26/-.7,V8XEW?HXN4BbGYC_Jb7],X4M&^eW^KL9F->C-64Q
e?H,_K@U8.^9ORY?QeHLC#3#cZ>f58S=A>FCMUCPL-f-JK5E^T/E=6]6d&Sb^]QR
UC[_:#DI,C8cR_[.XZI7]d<@e+AL4^5_0:<QN95f.^08M]=FAW_XeS<bNBSGObVB
GF19:?W]d[GM@<5d-^\J/CHR,I[Y5OabH8+GQL-DLR0gY>KTJ[P/4_Ia57dcKTFB
+V7XQT3>-SA0C1U955P?0(N_.+VV]6@=0Z\(IZ:OHDg0V?=;\6HM3853I4eI9KI@
DUAHG2#Zf_c/;g_3>_H)0?N_7$
`endprotected


`endif // GUARD_SVT_MEM_BACKDOOR_SV

