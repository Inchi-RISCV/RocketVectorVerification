//=======================================================================
// COPYRIGHT (C) 2014-2022 SYNOPSYS INC.
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

`ifndef GUARD_SVT_VIP_WRITER_SV
`define GUARD_SVT_VIP_WRITER_SV

`ifndef SVT_VMM_TECHNOLOGY
typedef class svt_non_abstract_report_object;
`endif

// ****************************************************************************
// Defines
// ****************************************************************************

/** @cond PRIVATE */

// =============================================================================
/**
 * The svt_vip_writer_object class is a utility class whose primary purpose is to 
 * provide assistance for storing information about VIP "objects".  Each instance
 * of the class stores data for an object that is being captured by the VIP for
 * later display within Protocol Analyzer or Verdi.
 *
 * IMPORTANT: This class is intended for internal use.  VIP clients should never
 *            invoke any of the methods in the class nor modify the class data
 *            members in any manner.
 */
class svt_vip_writer_object;

  // ****************************************************************************
  // Data Members
  // ****************************************************************************

  /** 
   * The begin time for the object.
   */
  realtime begin_time = -1;

  /** 
   * The end time for the object.
   */
  realtime end_time = -1;

  /** 
   * The name of the object type.
   */
  string object_type = "";

  /** 
   * The uid of the object.
   */
  string object_uid = "";

  /** 
   * The uid of the parent object.  An empty string indicates that the object 
   * has no parent.
   */
  string parent_object_uid = "";

  /** 
   * The uid of the predecessor object.  An empty string indicates that the object 
   * has no predecessor.
   */
  string predecessor_object_uid = "";

  /**
   * Writer object which is required to retrive "svt_vip_writer_object" of predecessor.
   */
  svt_vip_writer predecessor_writer = null;

  /**
   * Writer object which is required to retrive "svt_vip_writer_object" of successor.
   */
  svt_vip_writer successor_writer = null;

  /** 
   * The name of the channel with which the object is associated. An empty string
   * indicates that the object is not associated with any specific channel, which 
   * is the default condition for an object.
   */
  string channel = "";

  /** 
   * The status of the object during the transaction. An empty string
   * indicates that the object is not having any status.
   */
  string status = "";

  /** 
   * The uids of the child objects.  An empty queue indicates that the object 
   * has no child objects.
   */
  string child_object_uids[ $ ];

  /** 
   * The uids of the successor objects.  An empty queue indicates that the object 
   * has no successor objects.
   */
  string successor_object_uids[ $ ];

  /**
   * An associative array used to store the specified field values for the object.
   * The values are stored in as strings that have been formatted appropriately
   * for PA, based on the specified type.
   */
  string field_values[ string ];

  /**
   * An associative array used to store the expected specified field values for
   * the object.  The values are stored in as strings that have been formatted
   * appropriately for PA, based on the specified type.
   */
  string field_expected_values[ string ];
  
  /** 
   * String holds the PA header XML structure to be written out to XML.
   * This is added to support backward compatibility.
   */
   string object_block_desc;   
  
  /** 
   * Bit indicates the object beging block already written to XML.
   * This is added to support backward compatibility.
   */
   bit begin_block_save;   
     
`ifdef SVT_VERDI_FSDB_LIBS_PRESENT
  /**
   * Transaction ID for FSDB dumping.
   */
  longint unsigned transaction_id;

`endif

endclass
// =============================================================================

/**
 * The svt_vip_pa_relation_object class is a utility class whose primary purpose is to 
 * store the relationship between the objects. This class is required because in verdi 
 * will not allow forward processing. This class will capture the relationship and helps 
 * in updating the relationship the relationship data will be displayed within
 * Protocol Analyzer or Verdi.
 *
 * IMPORTANT: This class is intended for internal use.  VIP clients should never
 *            invoke any of the methods in the class nor modify the class data
 *            members in any manner.
 */

class svt_vip_pa_relation_object;

 // ****************************************************************************
 // Data Members
 // ****************************************************************************

 /**
  * Queue to hold the all the related objects.
  */
  string relation_object_uids [ $ ];

endclass

/** @endcond */

// =============================================================================
/**
 * Utility class used to provide assistance writing information about objects
 * to be displayed with the Protocol Analyzer.
 */
class svt_vip_writer;

`ifdef SVT_VMM_TECHNOLOGY
  /** Built-in shared log instance that will be used by the XML writer instance. */
  vmm_log log;
`else
  /** Built-in shared reporter instance that will be used by the XML writer instance. */
  `SVT_XVM(report_object) reporter;
`endif

  // ****************************************************************************
  // Local Data Members
  // ****************************************************************************
  
  /** 
   * The name of the instance with which the data being written is associated. 
   */
  local string instance_name = "";
    
  /** 
   * The name of the protocol with which the data being written is associated.
   */
  local string protocol_name = "";
  
  /** 
   * The version of the protocol with which the data being written is associated.
   */
  local string protocol_version = "";
  
  /** 
   * The name of the suite with which the data being written is associated. 
   * Note that this attribute is only specified for suites that support PA-style
   * extension definitions with multiple sub-protocols. */
  local string suite_name = "";
                                
  /** 
   * The name of the file that is being written to.  Note that the name of the file
   * is constructed from the arguments specified when the writer is constructed.
   */
  local string file_name;

  /** 
   * The handle to the file that is being written to.  A value of 0 indicates that
   * the file has not yet been opened.  A value of -1 indicates that the file has
   * been previously opened and susequently closed.
   */
  local int file_handle = 0;

  /**
   * An associative array used to create unique object identifiers (uids) on a
   * "type-by-type" basis.  For example, the first object of type "x" will have
   * a uid of "x_1"; the second object of type "x" will have a uid of "x_2"; the
   * first object of type "y" will have a uid of "y_1", and so on.
   */
  local int current_object_type_uid[ string ];
 
  /**
   * An associative array used to keep track of unended objects.  Objects are 
   * added to this array when they are created and are removed when the objects 
   * are ended.  This enables the writer to be aware of which objects have not
   * been ended at the time the writer is closed and can write out those objects 
   * with an appropriate end times (-1) and an appropriate status value (NOT_ENDED).
   *
   * This array also acts as a "lookup table" to get a handle to a svt_vip_writer_object
   * based on a specified object uid.
   */
  local svt_vip_writer_object unended_objects[ string ];

  /** 
   * The uids of the child objects.  An empty queue indicates that the object 
   * has no child objects. This is added to support backward compatibility.
   */
  string pa_object_refs[ $ ];

`ifdef SVT_VERDI_FSDB_LIBS_PRESENT
  // ****************************************************************************
  // Local Data Members for FSDB dump
  // ****************************************************************************

  /**
   * An associative array used to keep track of ended objects.  Objects are 
   * added to this array when they are ended and are removed from unended_objects.
   * This enables the writer to find objects when build up relations after objects 
   * are ended.  
   *
   * This array also acts as a "lookup table" to get a handle to a svt_vip_writer_object
   * based on a specified object uid.
   */
  local svt_vip_writer_object ended_objects[ string ];

  /**
   * Relationship object instance, holds all the UIDs which posses the same relationship
   */
  local svt_vip_pa_relation_object pa_relation_object = null; 

  /** 
   * The type of the file to be dumped. 
   * fsdb and fsdb_perf_analysis mean dumping FSDB file only. xml means dumping XML file
   * only. 
   * both means dumping both XML and FSDB files.
   */
  local enum {
    fsdb = `SVT_WRITER_FORMAT_FSDB,
    fsdb_perf_analysis = `SVT_WRITER_FORMAT_FSDB_PERF_ANALYSIS,
    xml = `SVT_WRITER_FORMAT_XML,
    both = `SVT_WRITER_FORMAT_XML_N_FSDB
  } file_format;

  /**
   * The name of FSDB file that is being written to. This is specified by user.
   */
  local string fsdb_file = "";

  /**
   * Array to store the all the relationship object with uid
   */
  local svt_vip_pa_relation_object relation_uids [ string ]; 

  /**
   * The path of parent of streams. It is constructed by protocol_name, 
   * instance_name, protocol_version, and it is used to construct stream name.
   */
  local string fsdb_stream_parent = "";

  /**
   * The path of scope It is constructed using suite name and protocol name.
   */
  local string scope_full_path = "";

  /**
   * An associative array used to keep track of stream ids based on object type.
   * Objects with the same object type will be added as transactions into one 
   * stream in FSDB.
   */
  static longint unsigned stream_id_array[ string ];
 
  /**
   * An associative array to store the full protocol name.
   */
  int protocol_name_array[ string ];

  /**
   * Queue to hold the attribute names which need to be added for
   * the current written out stream.
   */
  string stream_attribute_names[$];
  
  /**
   * Queue to hold the attribute values which need to be added for
   * the current written out stream.
   */
  string stream_attribute_values[$];

  /**
   * The FSDB utility handle to make the FSDB calls
   */
  local svt_vip_writer_fsdb_util fsdb_util;
  
`endif

  /** Saved top level scope for this VIP instance */
  local string top_level_scope;

  // ****************************************************************************
  // Constructor
  // ****************************************************************************

  // ----------------------------------------------------------------------------
  /**
   * Constructs a new instance of the svt_vip_writer class.
   *
   * @param instance_name 
   *          The name of the instance with which the writer is associated.
   * @param protocol_name 
   *          The name of the protocol with which the objects being written
   *          are associated.
   * @param protocol_version 
   *          The version of the protocol.
   * @param suite_name 
   *          The name of the suite with which the protocol is associated.
   *          This is only required for suites that support PA-style extension
   *          definitions with multiple sub-protocols.
   * @param file_name 
   *          The name of the xml file, if the name is empty then the name will be
              constructed using 'instance_name' and 'protocol_name'.
   * @param format_type 
   *          The file format type in which the data to be written out. 
   */
  extern function new( string instance_name, 
                       string protocol_name, 
                       string protocol_version, 
                       string suite_name = "", 
                       string file_name = "",
                       int format_type = `SVT_WRITER_FORMAT_FSDB);

  // -------------------------------------------------------------------------------
  /**
   * Utility method to set up the VIP writer class to be used with the debug
   * opts infrastructure.  This is used to modify the top-level scope that transactions
   * are recorded in.
   * 
   * @param vip_path Hierarchical path to the VIP instance
   */
  extern function void enable_debug_opts(string vip_path);

  // -------------------------------------------------------------------------------
  /**
   * This method set the file format type enum to the format the data needs to be dumpped.
   * The format types: `SVT_WRITER_FORMAT_FSDB FSDB, `SVT_WRITER_FORMAT_XML XML, and
   * `SVT_WRITER_FORMAT_XML_N_FSDB for both FSDB and XML. 
   * @param format_type file format type in which the data to be written out.
   */
  extern function bit set_file_dump_format(int format_type); 

  // -------------------------------------------------------------------------------
  /**
   * Method to get the format type which has been established. 
   * The format types: `SVT_WRITER_FORMAT_FSDB FSDB, `SVT_WRITER_FORMAT_XML XML, and
   * `SVT_WRITER_FORMAT_XML_N_FSDB for both FSDB and XML.
   *
   * @return The format type associated with the writer.
   */
  extern function int get_format_type(); 

  // ****************************************************************************
  // Open / Close Writer Methods
  // ****************************************************************************

  // ----------------------------------------------------------------------------
  /**
   * Opens the file handle for a file in write mode.  This method must be called prior 
   * to creating any objects that are associated with the writer.
   *
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit open_writer();

  // ----------------------------------------------------------------------------
  /**
   * Closes the file handle for the currently opened file.  Once the writer is closed,
   * no additional objects can be associated with the writer.
   *
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit close_writer();

  // ----------------------------------------------------------------------------
  /**
   * Gets the opened / closed status of the writer.
   *
   * @return The current open / closed status.
   */
  extern function bit is_writer_open();

  // ****************************************************************************
  // Create, Begin and End Object Methods
  // ****************************************************************************

  // ----------------------------------------------------------------------------
  /**
   * Creates a new object and returns the uid for the newly-created object.  The 
   * start time for the object is set to the current simulation time.
   *
   * @param object_type 
   *          The type of object to be created.
   * @param object_uid 
   *          The uid for the object to be created.  If not specified, a uid is
   *          automatically created, based on the specified object type.
   * @param parent_object_uid
   *          The uid of the parent object, if applicable and known at the time
   *          the object is being created.  This value can be set up until the
   *          point at which the object is ended.
   * @param object_channel 
   *          The channel with which the object is associated, if applicable and
   *          known at the time the object is being created.  This value can be
   *          set up until the point at which the object is ended.
   * @param begin_time
   *          The start time of the object. If the start time is not passed, 
   *          the current time is set as start time. The start time will be used
   *          for XML to support backward compatibility and also in cases where the 
   *          start time of the object can't be determined during the start of the 
   *          object. If the object time is know during the start of the object don't
   *          pass strat time, leave it to the writer to add the current time.
   * @param end_time The end time of the object. The will be used only for XML to support
   *          backward compatibility. FSDB will not accept end time and expect the object
   *          end si called exactly when the object ends.  
   * @param status The status of the object.
   * @param time_unit Time unit used during the simulation.
   * @param label If specified, sets the label of the object; otherwise the name
   *          of the object type is used.
   * @param attr_name Queue of stream attribute names to add
   * @param attr_val Queue of stream attribute values to add
   *
   * @return The uid of the new object.  If the object uid was specified, the
   *         same string is returned.  An empty string indicates that an error
   *         occurred while attempting to create the new object.
   */
  extern virtual function string object_create( string object_type, 
                                                string object_uid = "", 
                                                string parent_object_uid = "", 
                                                string object_channel = "",
                                                realtime begin_time = -1,
                                                realtime end_time = -1,
                                                string status = "", 
                                                string time_unit = "",
                                                string label = "",
                                                string attr_name[$] = '{},
                                                string attr_val[$] = '{});

  // ----------------------------------------------------------------------------
  /**
   * Creates a new object XML data and save it to temp data structure.
   * This method is added for backward compatibility.
   * This method receives the complete begin block to be written.
   *
   * @param object_uid 
   *          The uid for the object to be created.  If not specified, a uid is
   *          automatically created, based on the specified object type.
   * @param object_block_desc 
   *          The object_desc which contains the XML block for PA object header.
   */
  extern virtual function bit save_object_begin_block( string object_uid , 
                                                       string object_block_desc = ""); 

  // ----------------------------------------------------------------------------
  /**
   * Begins an object.  When this method is called, the begin time of the object
   * is set to the current simulation time, if not already set.  If the begin time
   * of the object has already been set, the object has already been started and
   * this method will have no effect on the object; however, an error will be
   * reported and the method will return a failure status.
   *
   * @param object_uid
   *          The uid of the object to be ended.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit object_begin( string object_uid );

  // ----------------------------------------------------------------------------
  /**
   * Ends an object.  When this method is called, the end time of the object is
   * set to the current simulation time.  At this point, all information about
   * the object is considered to have been specified; thus, no further changes
   * can be made to the attributes associated with the object.
   *
   * It is important that all objects be ended at the appropriate time during
   * the simulation.  Objects that have not been ended at the conclusion of the 
   * simulation will have a status of NOT_ENDED, which is considered to be an
   * error condition.
   *
   * @param object_uid
   *          The uid of the object to be ended.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit object_end( string object_uid );

  // ****************************************************************************
  // General Object Methods
  // ****************************************************************************

  // ----------------------------------------------------------------------------
  /**
   * Specifies the channel with which the object with the specified uid is 
   * associated.  This method can be called up until the point at which the 
   * object is ended.
   *
   * @param channel
   *          The name of the channel with which the object is to be associated.
   *          If an empty string is specified, the object is not associated with
   *          any channel (which is the default condition for an object).
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_channel( string object_uid,
                                                  string channel );

  // ----------------------------------------------------------------------------
  /**
   * Specifies the uid of the parent object for the object with the specified uid.
   * This method can be called up until the point at which the object is ended.
   *
   * At the time this method is called, no checks are performed to validate the 
   * uid that is specified for the parent object.  This allows a parent object to
   * be specified as (a) an object that has not yet been created (assuming that
   * object uids are being managed / constructed by the VIP and are not being 
   * automatically generated by the VIP writer); or (b) the parent object has been 
   * created (so that the uid of the object has been constructed), but that the
   * object has not yet begun.
   *
   * If at the time the simulation ends, no object with the uid specified for the
   * parent object has been created, PA will report this situation when the data
   * created by the VIP is being read into a protocol view in a project.
   *
   * @param object_uid
   *          The uid of the object whose parent object is to be specified.
   * @param parent_object_uid
   *          The uid of the parent object.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_parent( string object_uid,
                                                 string parent_object_uid );

  // ----------------------------------------------------------------------------
  /**
   * Adds a child object to the object with the specified uid.  An object can have
   * multiple child objects, as appropriate for the protocol.  This method can be 
   * called up until the point at which the object is ended.
   *
   * At the time this method is called, no checks are performed to validate the 
   * uid that is specified for the child object.  This allows a child object to
   * be specified as (a) an object that has not yet been created (assuming that
   * object uids are being managed / constructed by the VIP and are not being 
   * automatically generated by the VIP writer); or (b) the child object has been 
   * created (so that the uid of the object has been constructed), but that the
   * object has not yet begun.
   *
   * If at the time the simulation ends, no object with the uid specified for the
   * child object has been created, PA will report this situation when the data
   * created by the VIP is being read into a protocol view in a project.
   *
   * @param object_uid
   *          The uid of the object to which a child object is to be added.
   * @param child_object_uid
   *          The uid of the child object.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit add_object_child( string object_uid,
                                                string child_object_uid );

  // ----------------------------------------------------------------------------
  /**
   * Adds an array of child objects to the object with the specified uid.  This
   * method can be called up until the point at which the object is ended.
   *
   * At the time this method is called, no checks are performed to validate the 
   * uids that are specified for the child objects.  This allows any or all of
   * the child objects to be specified as (a) objects that have not yet been
   * created (assuming that object uids are being managed / constructed by the
   * VIP and are not being automatically generated by the VIP writer); or (b) the
   * child objects have been created (so that the uids of the objects have been
   * constructed), but that the object has not yet begun.
   *
   * If at the time the simulation ends, no object with the uid specified for any
   * of the child objects has been created, PA will report this situation when the
   * data created by the VIP is being read into a protocol view in a project.
   *
   * @param object_uid
   *          The uid of the object to which a child objects are to be added.
   * @param child_object_uids
   *          The uids of the child objects.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit add_object_children( string object_uid,
                                                   string child_object_uids[] );
  // ----------------------------------------------------------------------------
  /**
   * Adds an array of interface path into the FSDB scope with a predefined attribute name. 
   * The interface path is added to predefined attribute name "verdi_link_interface"
   * by which we can take advantage of verdi APIs to read the data from FSDB.
   * If the interface paths are multiple the attribute name will be incremented with numeric 
   * Eg:"verdi_link_interface_1","verdi_link_interface_2" etc.
   *
   * @param if_paths
   *          The interface paths for all the interfaces.
   */
  extern virtual function void add_if_paths( string if_paths[] );

  // ----------------------------------------------------------------------------
  /**
   * Adds an single object ref to XML file.  This method is added to support
   * backward compatibility.
   *
   * @param ref_object_uid
   *          The string formatted in XML contains the child object uid for the object.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit add_pa_reference( string ref_object_uid);
  
  // ----------------------------------------------------------------------------
  /**
   * Specifies the uid of the predecessor object for the object with the specified
   * uid.  This method can be called up until the point at which the object is 
   * ended.
   *
   * At the time this method is called, no checks are performed to validate the 
   * uid that is specified for the predecessor object.  This allows a predecessor
   * object to be specified as (a) an object that has not yet been created (assuming
   * that object uids are being managed / constructed by the VIP and are not being 
   * automatically generated by the VIP writer); or (b) the predecessor object has 
   * been created (so that the uid of the object has been constructed), but that
   * the object has not yet begun.
   *
   * If at the time the simulation ends, no object with the uid specified for the
   * predecessor object has been created, PA will report this situation when the
   * data created by the VIP is being read into a protocol view in a project.
   *
   * @param object_uid
   *          The uid of the object whose predecessor object is to be specified.
   * @param predecessor_object_uid
   *          The uid of the predecessor object.
   * @param predecessor_writer
   *          The "svt_vip_writer" instance with which the predecessor object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_predecessor( string object_uid,
                                                      string predecessor_object_uid, 
                                                      svt_vip_writer predecessor_writer = null);

  // ----------------------------------------------------------------------------
  /**
   * Adds a successor object to the object with the specified uid.  An object can
   * have multiple successor objects, as appropriate for the protocol.  This method
   * can be called up until the point at which the object is ended.
   *
   * At the time this method is called, no checks are performed to validate the 
   * uid that is specified for the successor object.  This allows a successor object
   * to be specified as (a) an object that has not yet been created (assuming that
   * object uids are being managed / constructed by the VIP and are not being 
   * automatically generated by the VIP writer); or (b) the successor object has 
   * been created (so that the uid of the object has been constructed), but that the
   * object has not yet begun.
   *
   * If at the time the simulation ends, no object with the uid specified for the
   * successor object has been created, PA will report this situation when the data
   * created by the VIP is being read into a protocol view in a project.
   *
   * @param object_uid
   *          The uid of the object to which a successor object is to be added.
   * @param successor_object_uid
   *          The uid of the successor object.
   * @param successor_writer
   *          The "svt_vip_writer" writer with which the successor object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit add_object_successor( string object_uid,
                                                    string successor_object_uid, 
                                                    svt_vip_writer successor_writer = null );

  // ----------------------------------------------------------------------------
  /**
   * Adds an array of successor objects to the object with the specified uid.
   * This method can be called up until the point at which the object is ended.
   *
   * At the time this method is called, no checks are performed to validate the 
   * uids that are specified for the successor objects.  This allows any or all
   * of the successor objects to be specified as (a) objects that have not yet
   * been created (assuming that object uids are being managed / constructed by
   * the VIP and are not being automatically generated by the VIP writer); or 
   * (b) the successor objects have been created (so that the uids of the objects
   * have been constructed), but that the object has not yet begun.
   *
   * If at the time the simulation ends, no object with the uid specified for any
   * of the successor objects has been created, PA will report this situation when
   * the data created by the VIP is being read into a protocol view in a project.
   *
   * @param object_uid
   *          The uid of the object to which a successor objects are to be added.
   * @param successor_object_uids
   *          The uids of the successor objects.
   * @param successor_writer
   *          The "svt_vip_writer" writer with which the successor object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit add_object_successors( string object_uid,
                                                     string successor_object_uids[],
                                                     svt_vip_writer successor_writer = null);

  /** Get a handle to the file that is being written to. */
  extern function int get_file_handle();

  /**
   * Records various aspects of the VIP in the FSDB as scope attributes
   * 
   * NOTE: This method has been deprecated and should no longer be used.
   * 
   * @param vip_name Hierarchical name to the VIP instance
   * @param if_path Path to the interface instance
   */
  extern function void record_vip_info(string vip_name, string if_path);

  // ****************************************************************************
  // Object Field Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  // Bit Field Methods
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Specifies the value of a bit field for an object.  This method can be 
   * called up until the point at which the object is ended; however, only
   * the last value specified is associated with the field.
   *
   * @param object_uid 
   *          The uid of the object to be modified.
   * @param field_name 
   *          The name to be field whose value is being specified.
   * @param field_value 
   *          The field value.
   * @param expected_field_value 
   *          The expected field value.  If this value differs from the field_value,
   *          the object will be marked as having an error condition.
   * @param has_expected
   *          The flag to indicate if expected_field_value differs from the
   *          field_value.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_field_value_bit( string object_uid,
                                                          string field_name,
                                                          bit    field_value,
                                                          bit    expected_field_value = 0,
                                                          bit    has_expected = 0 );

  //----------------------------------------------------------------------------
  // Bit-vector Field Methods
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Specifies the value of a bit-vector field for an object.  This method can 
   * be called up until the point at which the object is ended; however, only
   * the last value specified is associated with the field.
   *
   * @param object_uid 
   *          The uid of the object to be modified.
   * @param field_name 
   *          The name to be field whose value is being specified.
   * @param field_value 
   *          The field value.
   * @param numbits
   *          The bits size of the value required for FSDB.
   * @param expected_field_value 
   *          The expected field value.  If this value differs from the field_value,
   *          the object will be marked as having an error condition.
   * @param has_expected
   *          The flag to indicate if expected_field_value differs from the
   *          field_value.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_field_value_bit_vector( string       object_uid,
                                                                 string       field_name,
                                                                 bit [1023:0] field_value,
                                                                 int          numbits = 4096,
                                                                 bit [1023:0] expected_field_value = 0,
                                                                 bit          has_expected = 0 );

  //----------------------------------------------------------------------------
  // Logic-vector Field Methods
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Specifies the value of a logic-vector field for an object.  This method can 
   * be called up until the point at which the object is ended; however, only
   * the last value specified is associated with the field.
   *
   * @param object_uid 
   *          The uid of the object to be modified.
   * @param field_name 
   *          The name to be field whose value is being specified.
   * @param field_value 
   *          The field value.
   * @param numbits
   *          The bits size of the value required for FSDB.
   * @param expected_field_value 
   *          The expected field value.  If this value differs from the field_value,
   *          the object will be marked as having an error condition.
   * @param has_expected
   *          The flag to indicate if expected_field_value differs from the
   *          field_value.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_field_value_logic_vector( string         object_uid,
                                                                   string         field_name,
                                                                   logic [1023:0] field_value,
                                                                   int            numbits = 4096,
                                                                   logic [1023:0] expected_field_value = 0,
                                                                   bit            has_expected = 0 );

  //----------------------------------------------------------------------------
  // Integer Field Methods
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Specifies the value of a integer field for an object.  This method  can
   * be called up until the point at which the object is ended; however, only
   * the last value specified is associated with the field.
   *
   * @param object_uid 
   *          The uid of the object to be modified.
   * @param field_name 
   *          The name to be field whose value is being specified.
   * @param field_value 
   *          The field value.
   * @param numbits
   *          The bits size of the value required for FSDB.
   * @param expected_field_value 
   *          The expected field value.  If this value differs from the field_value,
   *          the object will be marked as having an error condition.
   * @param has_expected
   *          The flag to indicate if expected_field_value differs from the
   *          field_value.
   *
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_field_value_int( string  object_uid,
                                                          string  field_name,
                                                          longint field_value,
                                                          int     numbits = 32,
                                                          longint expected_field_value = 0,
                                                          bit     has_expected = 0 );

  //----------------------------------------------------------------------------
  // Real Field Methods
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Specifies the value of a real field for an object.  This method can be 
   * called up until the point at which the object is ended; however, only
   * the last value specified is associated with the field.
   *
   * @param object_uid 
   *          The uid of the object to be modified.
   * @param field_name 
   *          The name to be field whose value is being specified.
   * @param field_value 
   *          The field value.
   * @param expected_field_value 
   *          The expected field value.  If this value differs from the field_value,
   *          the object will be marked as having an error condition.
   * @param has_expected
   *          The flag to indicate if expected_field_value differs from the
   *          field_value.
   *
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_field_value_real( string object_uid,
                                                           string field_name,
                                                           real   field_value,
                                                           real   expected_field_value = 0,
                                                           bit    has_expected = 0 );

  //----------------------------------------------------------------------------
  // Time Field Methods
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Specifies the value of a time field for an object.  This method can be 
   * called up until the point at which the object is ended; however, only
   * the last value specified is associated with the field.
   *
   * @param object_uid 
   *          The uid of the object to be modified.
   * @param field_name 
   *          The name to be field whose value is being specified.
   * @param field_value 
   *          The field value.
   * @param expected_field_value 
   *          The expected field value.  If this value differs from the field_value,
   *          the object will be marked as having an error condition.
   * @param has_expected
   *          The flag to indicate if expected_field_value differs from the
   *          field_value.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_field_value_time( string object_uid,
                                                           string field_name,
                                                           realtime   field_value,
                                                           realtime   expected_field_value = 0,
                                                           bit    has_expected = 0, 
                                                           string time_unit_val = "" );

  //----------------------------------------------------------------------------
  // String Field Methods
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Specifies the value of a string field for an object.  This method can be
   * called up until the point at which the object is ended; however, only the
   * last value specified is associated with the field.
   *
   * @param object_uid 
   *          The uid of the object to be modified.
   * @param field_name 
   *          The name to be field whose value is being specified.
   * @param field_value 
   *          The field value.
   * @param expected_field_value 
   *          The expected field value.  If this value differs from the field_value,
   *          the object will be marked as having an error condition.
   * @param has_expected
   *          The flag to indicate if expected_field_value differs from the
   *          field_value.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_object_field_value_string( string object_uid,
                                                             string field_name,
                                                             string field_value,
                                                             string expected_field_value = "",
                                                             bit    has_expected = 0 );

  //----------------------------------------------------------------------------
  // Tag Methods
  //----------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  /**
   * Adds a tag to an object.  This method can be called up until the point at
   * which the object is ended; however, only the last value specified is
   * associated with the object.
   *
   * @param object_uid 
   *          The uid of the object to be tagged.
   * @param tag_name 
   *          The name of the tag to be added.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit add_object_tag( string object_uid,
                                              string tag_name );

  // ****************************************************************************
  // Local Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * Retrieves the instance of the svt_vip_writer_object class that is associated
   * with the specified object uid.  If no object can be located within the array 
   * of unended objects, the method will report and error and return null.
   *
   * @param object_uid 
   *          The uid of the object to be found.
   * @param check_begin_time 
   *          Indicates whether or not the object begin time should be checked.
   *          If this attribute is set to 1, and the object begin time is -1, 
   *          the method will report and error and return null.  Note that by
   *          default, the object begin time is checked.
   * @param find_all
   *          Indicates whether or not to only look for unended objects.  If this
   *          attribute is set to 1, the method will only look for unended objects.
   *          If this attribute is set to 0, the method will look for both ended
   *          and unended objects.
   * @return The instance of the svt_vip_writer_object class that is associated
   *         with the specified object uid, or null, if no such object was found.
   */
  extern function svt_vip_writer_object get_object_from_uid( string object_uid, 
                                                             bit    check_begin_time = 1,
                                                             bit    find_all = 0 );

  // ---------------------------------------------------------------------------
  /**
   * Creates a string that can be specified as an attribute value in an XML file
   * by replacing any characters that would otherwise lead to processing errors.
   *
   * @param original_string 
   *          The string to be processed.
   * @return The "XML-friendly" string (which may be the same as the original string).
   */
  extern local function string create_xml_attribute_string( string original_string );

  // ----------------------------------------------------------------------------
  /**
   * Ends an object.  When this method is called, the end time of the object is
   * set to the current simulation time or left unchanged (meaning the end time
   * is -1 and this method is being called to write out unended objects).  At this
   * point (under either scenario), all information about the object is considered
   * to have been specified; thus, no further changes can be made to the attributes
   * associated with the object.
   *
   * @param pa_object
   *          The object to be ended, if available; otherwise, this value should 
   *          be set to null and the value of object_uid will be utilized to find
   *          the object of interest.
   * @param object_uid
   *          The uid of the object to be ended.  This value is ignored if a
   *          non-null handle to a svt_vip_writer_object is provided.
   * @param set_end_time
   *          Indicates whether or not the end time of the object should be set
   *          to the current simulation time or left unchanged.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern local function bit local_object_end( svt_vip_writer_object pa_object,
                                              string object_uid,
                                              bit    set_end_time = 1 );

  // ----------------------------------------------------------------------------
  /**
   * Writes the data associated with an object.
   *
   * @param pa_object 
   *          The object to be written.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern local function bit write_object( svt_vip_writer_object pa_object );

  /**
   * Transform a string into legal name for FSDB dumping. FSDB treats "." as
   * delimiter for hierarchy.
   * 
   * @param name
   *        The string to be transformed.
   * @return
   *        The transformed string, which is a legal name for FSDB.
   */
  extern local function string get_legal_fsdb_name( string name );

  /**
   * Find stream id with given object type.
   * 
   * @param object_type
   *             The object type to look for
   * @param object_channel
   *             The channel for which object belongs
   * @param attr_name 
   *             Queue of stream attribute names to add
   * @param attr_val
   *             Queue of stream attribute values to add
   * @return
   *             The stream id if found, 0 if not found.
   */
  extern local function longint unsigned get_stream_id_by_type( string object_type, 
                                                                string object_channel, 
                                                                string attr_name[$] = '{}, 
                                                                string attr_val[$] = '{});

  // ----------------------------------------------------------------------------
  /**
   * Utility function used to add a scope attribute, incorporating 'fsdb_file' if present.
   * 
   * @param attr_name The name of the attribute to be added.
   * @param attr_value The value associated with the attribute
   * @param scope_name The name of the scope for which the attribute needs to be added.
   *                    If the scope name is empty then the scope attribute will be added to the 
   *                    'parent' scope. The default scope name will be empty.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern function bit add_scope_attribute(string attr_name, string attr_value, string scope_name = "");

  // ----------------------------------------------------------------------------
  /**
   * Utility function used to add a stream attribute.
   * 
   * @param attr_name The name of the attribute to be added.
   * @param attr_value The value associated with the attribute
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern function bit add_stream_attribute( string attr_name, string attr_value );
  
  // ----------------------------------------------------------------------------
  /**
   * This function sets the custom transaction relation for the 'target_object_uid' to the  
   * 'source_object_uid' inside FSDB.
   *
   * @param source_object_uid
   *          The uid of the object whose custom relation object is to be specified.
   * @param target_object_uid
   *          The uid of the custom relation object.
   * @param relation_type
   *          The custom relation type which needs to associated, eg: if the two transactions
   *          are identical then the relation type value should 'identical'.
   * @param target_writer
   *          The "svt_vip_writer" instance with which the custom object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_custom_relation( string source_object_uid,
                                                   string target_object_uid,
                                                   string relation_type,
                                                   svt_vip_writer target_writer = null );

 // ----------------------------------------------------------------------------
  /**
   * This function sets the custom transaction relation for all 'target_object_uids' to 
   * the 'source_object_uid' inside FSDB.
   *
   * This method calls the 'svt_vip_writer' method to write out the custom relation 
   * into indicated XML/FSDB. 
   *
   * @param source_object_uid
   *          The uid of the object whose custom object is to be specified.
   * @param target_object_uids
   *          Set of uids of the custom relation objects.
   * @param relation_type
   *          The custom relation type which needs to associated, eg: if the two transactions
   *          are identical then the relation type value should 'identical'.
   * @param target_writer
   *          The "svt_vip_writer" instance with which the custom relation object is
   *          associated or null for the current writer.
   * @return The status of the operation; 1 = success, 0 = failure.
   */
  extern virtual function bit set_custom_relations( string source_object_uid,
                                                    string target_object_uids[],
                                                    string relation_type, 
                                                    svt_vip_writer target_writer = null );

endclass

// =============================================================================

`protected
\&_Y12W^30?VN817SI7M=:_7Q&CEDf2F8eL4/F(17RH4T2J3gf7I4)/[-3Q&ZXb#
PN<.O6VWQg:TN8Z9C1;E,QE2N)L-E;1:e1PALOJRR0410GQSPU]/0QR<U()#W>C8
bJVeU[SM@47D+Xa&??cIG4#C=GYg.XR7d51dKe-ZV<6e\&Q5ROH#6;a>;.RU9ReD
X,gd;VWS9-J:+Q1Z3\^_S-(b7??)UW+B=00Q+8R:3(7Gd5)0F/_6B.PF:-e?L<4F
J\d?EC;Q&O;JPa5+RT@OLA/@;GGQAVE?>@<Z(c,N3RGJaAR1=VbAAO9g]R0[@J[L
T0aH1#EV+>aJd<OQFEaPeHPA4-+S)ea^_78^.cX(RS-@,[]046d&bTLW:+3X\a\N
ZEI?&,d\W&C=JUDYf]XGb55]:^#g5^--DKaDNK?RAIU4/F;]FU#3VJ_?F7<_c>AI
URI72S17/9Z[M@S\G9P5ZNH-FA_KC4OFMcFT;^-dCQV-#1:,B4E:JNT.AO@Z[(,]
6K(<JG@^XL.f7Og)c<O6WX6?2b.AVa>Q0:^+R>]L<,_2&>2FD)3GM&^[;VG1WgG[
BK+9XBgQW^U-VL44gTdUAeBf4eKCZ_E;[KH/fK^;SEV@Z@AEYTQS9a)NK)4<>TG>
,?2XOHCO(g+OYfD)M#MKJ7DSa<OKXK.^ggU3B]2I4bLcG]]S^Q\eYc3f?RA-5IK)
?<:O6T_]>@J0-E0bGc0W>)(K)a/-c[FTVeTJgGP1&?:)_M9=FUb@F;\G6,A_YS<X
d;CHT_g>)<&3)c/#IVX=U7(&[6[^PWB@0T]1<)G7BB>>\4Gd#:,<=J5GAR428Y&U
M3R<.B=1._/JK>a+E+Q#ZFY5#-d1)Tb6M&39@,Mg9^R?<(T<H#1N5cCJIV@F4/QZ
Rc<(Q/TTJ0P]VE-baBV,PZ(CE@;E/D0(9e_/\(W9W6535:FKC[6\_]e1+M#&/NgR
B]UHIRIX&R/+CR1E/Y,d=86GKEd=X3ICW@9ET#<TN]7b5^]bIcEe?C;-@Od>FTU4
dD#8(+[[1HQYPSSVO7f6HGA,[HSRX67R2&J\>eXa)).XRW;+[[<]G3bc0aH_\&XU
8QU#7X]L,,)Ob.D]<DQc7E+fdAL1R21.PJ(Yd&DK2I+EWKK2DUKV<W\(9&cg)XEJ
cG1X(S^f/15Dg.f#8_e20be+;1Q0:8dLaV4CRXR-JcU<];FLG2MU[0:OdF6\Uc6D
d>S?&Q?;N?/-=6U23.4/fgU+8V[UM&Q\/f.8B=M5,]#8NB3?g+2Y9-e<,bf2/CJ@
[/#KL<d2\5b4^F>3/KECOH//5b5A0IKCZLc3RH]HgZ\JC_47Y_]U,=)8:dT3VH<K
?[9cGLNVY^\>).^+(Oa.a_Q(&/@84X5Na&QI[/+3;:[H:LT[fb<D+Qc:TZ..RcQA
6NX<Fg70G9.]^Yg@b\ZITI?c1:bAHP[Y\6Ue42g&=-IQ]]9YUe\4>D;b#N2fcgZ+
>5(/NS(Ng\8Ba(]Kd3Q&MI3XX<+>(?YGg5SI@WHN1<(.O@f9K8X(T8975#YS=eL1
^08T)YDI1XE?/8P,([<7)LY_1I5;YI1dLSD[X&f^dP2;@7)N\Y?2b2\<WGFPM+^^
&dD,H;D.OId851-P#@+6(]d7Wc)cO7WS>1YDOcaZ.R7H^H3U]4G9cHNd47fEKB_f
/WN-.J=bWRAV1?\eMCd..C3R?8\Z_\59[CXEIHZ3.H_&R/)=.gD,L&>_#K5Z9g2W
TIMAfg+-5]aQFFEELUOKQ[a.fHN>AU5#YU]J.>H88_..3P_L>>R]dWf&-5.FN\93
\N0UT9Z(,(P1ZfY+4M>3XD<Z+^G_S.f59#X?Q10>K<YD.8AW0EH[96IaSc][2=>L
F1;>9Z_KC(YV);61UKV5S]KO^/(WbJN+b0S11<VWCb#/#F?U)Z4AP=5fA1KBEdVW
H6_:]J99cU=F-/PQUgN<eO/A]XZaZ]3?.KATL]>E4Cg#.#NX2O.RM9:8ZO9>,^RH
5[>dJUGCE5AJ9=MNU)K1d\()e(]9ANPb49R:RU[9cD+DT1\PG4<KV#IS><OAN97W
fCSG+5/e49=U?[K8@9P/H_^.gSMWZSH0FW<#JGH9TWO=WTYeBHKNSE:)?1Q>f>9:
66>X.E)TgY7N2L>e6>[4+4&3_#O@(1/OegbS5:MBb>B8gV);O?B=U8ERg\a7M=bP
QPeD@C>UE3RMe(:E-2C1f-?_aZaY.27.,I#=G2V-IV@P\@fHa(3K(L>41W;6Xe](
D_9dJG?\PZ1XB7^0:8\X.++Kf62(g8Xf+K_:;b@+ZUbG7?XMC?6Xc64M(7N<M9I#
.fFMPFG6/B\8&LX19#GKe12C):--C2&FWMBTg/\B9Z>Ba@9,0TE.&N9K#0ge(#C2
;T;deJUY=WZ?ME^^#D\X2]c2:FPYLX8N:cB5G0de):[#aR9DM+72<E,[5R[#7H=(
TWa9(C&.fIRO5d8N:SfaSELP,U.]TS:J0#dbeDUD[J6&LZ3RVE+XQTD:([bG)LcZ
Je=1?K:_RO@^-_3S[,A,5bDW@M/D,GKL3gcb8H1NG1dg5<,MH>2CY3+&,7+5Ig82
QE+95Xfg_O/@QI@1?GFS0KX+A]d&?bb_cJ01UB?F_:d,NK(NSBY=(dga-I,5Z<,S
<6P1YdLc@b3ITcPX9SDZ<E6)(c6R3]YV5(0E/>V\8A&;M2,b+/)GaJ&-KDfI?;9E
g/Tb1J+@<XAS)CY@ZOe/I^)GHb)e\d\1<P+[LB3<1X&Zf_1[&/<A83<P9/B=>#X5
M314L,_>DXOXLB1f2a,_J9(9CM=Q-@/ZQX<T9#\MNN6=:M]EL]38(-[9.8K[YFX#
-Fd:2IDY#_DM=#<(00;[74O1F35?7WTDZOKcSNc:06>4>PB7@,5NV./+ZUcdMb9&
?]aNG:X3gNX^\2,g,-2faX=(F4Y^eJA^\<S4SU#:VO5<0Y4#L0Ha#N-1(=Y6-[Y\
)De9G?/NV+dS#KP<8??0KHS+5UK,gXW.+0,fT@bT7c_H@7P]CARg[XZ6Z@0/SGV>
O:]M-36bJQG#C-U?7AcOQ7IeSACI2EfGD9ALC\B]:;[^SRJ[U@4XbBNBVOCR=XI3
UdMQZbe(/D5?b3bV6AV\J60cZRc?^Q<AU6=ee(311FNU:S0[?fL+/Q66S_KS5;S:
KX^1]a,9Q@#25T_UeJKM7S]ad\03/T)/I36H#]1SJ,,\4b4agcQO\PYG):@Pb::J
?DOb=30d[[cKW+]MPf[-9#[G-(3D)cOg0a5+ANZO4D^H>Bd&b-M]N85=b6?8GD1W
9+77^-SW(M;]/3:#[R(+&-103V5CNB#_BdcF+ZQb@UN<2+:D_6>e6R;aQ[YVH(?e
/FAN#1#@IX6<.A18H9^XXTL>GBP.?E;CK=(cJaK4)GbDTa\B]H&(J8FU,NID9S9T
Ia9FX_[ZQ8#ACP<5@MBAa/9g>FE_c5D-LQ5GHA;BHdcUI(\Zg::)&5OCDVg&-_&g
Zd&^.[?)<O327J9(YW+f-bN^K(0B39@?_FF0C40d59B.B^D5,(+9RP(b3@c)X]dA
QEM5V160S<KaZF^Z0Z1:f\^Oa-SU;^L#CNK?G73Kg5J]gQ:_c((3c=]?Y[,&@7N\
0Qf,?V:DR:SQT#dP2fY9T:YF@2063_7+OC0d(-[I9TP5WQf&6(H;C6;?C9dYPG:>
AO1L<,/0AYb1S[-/?9P+Ua=/;V5ZKVJTQH_KCV:>UdeZUQbMO4.G<^<U@Z?W+99E
H/==MU3)3;_GRD-_c:.aGH-?6\ePY)AUVg-Cc-SFETF3@GEV8Wg7KSN8fBDY&dG&
FdebA^K=WdDXY\=ZLBE)V:7.P;6AUX&^f)J9V1dYd73gGK:A>e7ND][@]:S4-4QV
g\/L8(.>JX0=PZT@BVc[G7BHfO5>L_\;(+W90E+a,IEU6IT(bFf94.dEd2,4DAYJ
;3f/cD[B85W#Vd.ebWY1OfO6_D_(a/./C9=8FY68PN<6Q3a^eYCT\[Z4+^D9\I7W
cE\0La8#,/ZFV2T6gX^X[X((bAD^d-QeX1TU2<:8&-[MK?VY1G(8;/cWH)10QY@Z
GF;Pg]@MQ5,:A0AO(+:aCLWFZ1MY:Gb18XB+gf2g,9^+]0cPeYPS0#fQ&gPTY6[+
-^4BWR;GVQ<86K4U@bRE5#XGG+I&MR&[bT-A0IJe/2::94P&68BB&;G^]X#>6/7,
T[1Q)-FRe4/Y3SA:>_#Hf_TUS]cX1@0LE7//0HCZDc1C>]\3cZbeRf,@O(Q-DG7J
Q6ZJ,ICd,-&XNadSK7VcYOe,\G,Z+UWGH\,a^VJ48TKF;3A-MbT:JP+e.M5Q6F#g
I>&e4<:f,H_5N7@G-&(Qa.KG>P(W=N2]R>V\<e]#6V8J18FM>-:-\4LaD=@\HKgJ
8>\V?;5dN1c-B2G05LSWO21:ga@X?Pf<I[Q\Q.6PKYHTIJY5fbL@bgbAJ6UARTOT
LL1MD9BDNd<bFIMF@dM\;W+3HPH>RO+-(7AC4,7&6R:->986f3)CXcHI=;J=cfg<
F1fA+[(aKS;\d@:IGCJ0JJ;d:]V2UUQ]dZf)#WV+fM3dTFEFRQN.]=/#AU:Bd7W>
VG;6aJ.6\#0N/7)[&OVNaH#.:c[5D#0M6S:DY[c&[8/?_e=Y,cBJ\)WN[=eDWCCO
@L]\A9WG57c@BCbgI-G2]acUOCR.KOMaBG[2R)UD.&O.\Ue9-&TQCX8A-Pd[A^<\
90:>X>MN7AS>Q]:&#MRP>adF+XgU5K/WYe7=C.>)CU[PW4;<&gB_1O6BN-gF-7aI
>:),4\6X.?9gTP\OI292[>d1214XF-]PW\,@)^+K>04NW+MbR@]EF+T9QLS=4N?:
;9,d:S8FK2g<C^6O^<I)0SXeCT?TC^Qb4XI&>cb_RHeB,C<4K=1MTRAC7g_(CH&D
T0U&IO_[-eeX)]V6QCJbPMg5>LgMKbT-T9H/Pb63GU44We,W8e17f/&dHc--,9[=
f<HM88#E.T8\\:D/@G^F8QGBdf[2K,;.5;Wf#1QAGe6I.CZgcD__Gg)9.(FJ./]N
;aEVAM#_WNQ\f[5P41H?Pd\A4f@V>MA02IHA3#5TX/KO93LU0679NfTLR69B8fY@
;,&5V)g;7U=.31d<+O-ZX-WOECdF]HYLHX;O5)08dAEE-=\40/1G=O=,8C^=e)Y\
^2FROH?6.SKT<+]a9W7@DS,STPX0-b^WG]E:R@<<d1+3gINXPLJK^1(RQC=W(I6/
FW<aJ,QL&/JWaed@D[aTB2&5@)G5d31KL<F7IEfT>F&#dI&F6G2BMIgS5^3@.^5)
Z/?ZO2#A\PJ+WcG898SAYRgge<9THUO68HD,()#FOd3f;/b+[(+U39XR@A^V7?[K
2]R&dO3?7^cdMZQe6?J@Gd,@^OL-)L)\;9DD1PXA:BOPG)aG,X=^Yc#,Xe1,)Ha=
cd8CbFE2U#\X,Q<6L+HU)ce#:,?XdDaK7./#VJA,L7M[K??.1/\6K8T5_,?IB:Wd
.BA<(Xe?TAYCdFUaDfa#Pe#@21]SV#DdRFX+?<^)#//KHY&e>C5C0QE)aCU8WRg.
6L4A[9(cMN>,Pb2ZP]-aUUB>X5+3FO9J-N&JYAe@eR+SJ58&,]AB/[M^P6QCTQ6T
dgffXR\P\JH3P9@:J&0?B/FL\;3Kd-bB]@?_TI[6NHC3gIfJbBRAI3)GI0#NFLT9
d-?]UI7X@Mb)A,4&0@1&(aXA+]5g_2K^?#UdbCJDCN>[c.W3>B\5;H^2fgH6#K^\
X55;=.7\Y>0F1.V/R,O9SUGC/G>b]>ee)O=X_e3M4fH=+g=)TA0-XBHL&II@.5SU
N7E<89aDb#,>_^eZaaEZ=DPS<Xe@9N@M:ZUZHW?M/ZF+bb]eF9=D5O-0c,Fd2:Y)
:QAB<^W#OUM=O:;/SV(gK>)02IYG2g-_.48FIZ-b87+4EgReB,.\LNS)Z[aL3QY7
OW^C09WaL.F,U?F>9O6^^H\.VGEf27c]GJd[N;Gd&)V09&)T^I-b#[;>DUAc48_N
2^L.E4b\UT-N2&R9M3)d@.=E;^D5.&BbF8.9<:a1K/=\=3X=LBF)GJfD_EVI;IXT
UH^]5CA-HG,e(3R2?U1#3=eXIMRcUNY&,-:PDE\1]eLF03=]eT+O(ac9UGJ)F4XZ
H>/c&HQ4Od,_BWXTJ50I8P=3ZX7GHK38=AAaJ#X+TY\97>b1L0#\RZ]Dd;.VLNSQ
QD]&IR2[_^T06NP7c6X(<3@W09.&AI12.I[,_;^)]J0;7?OR.Y1f@LW:T:,1bTGL
@D8JJ_\KF5_5(decO>b[UW38]8KSQNR/BZ6B^UN-A2&Z@V8D1-56/O3OW-AdKIRP
JU:1&<Td7XJXAeR0F=_&aN)#^\L>;JBC62>?]SSfa#SAXRL]#_Jd/&3R3O81,beR
b[4))?&T6/BCc\Q1KfPJRIcg7FX>eV-[G1GJ_e21R(#e4/Ja>DA-KQYD^\=.,W1N
b:B\/D=2LB?\#IV-;@PC4K(7#39&F=gfa1^a,?XL80,gA9(bU6cV<Nb8@SMKAf.B
bR(LX<MH8WF55CFGYDP=6#E(<f+2b,D6gAWSaB_@]DS:2]5NL_:-9J12<&YTSf+B
b\49F#XX:?U(8,4HHg08GW\ZB?&TW?2eYfWB;cQ\;>K9KNb9g0T[F?8L1XV4C<H8
J^>RC:HDdK0f64#OTdI&Nd@XLa1WbIKb73:8b5[PL>GH#c5#2QZ2Ge@22E?<[@5F
c+e?4FKJ)6b;I@U6,<W<E9/GK);V\YSIU>1ZE#3UWI@8@B06aK;=,APaHAG_GO,g
\+RTf\efL=8_1M_8SS2^@C^<BG?7Kd=5SI]EeVgZLLVO\53TXf]QX^YHbS,5,:<,
G?H-LK&/&FQcCI=S3a@_T13Z8M55XdM2fa^\+O2VTX[bT(X@+\MQDg][@=:S^P\d
4Y8NA9+F2YaTBMOX;9H;f9AS\N0d20)[V90:&ZA2N5QX@5Ya36e7\;H3NEKY-fK8
b&[_01.f3^Z)43e-,PZ^&6N+\<Y)V(D@K;VLUMQWGC7<gagN(P(4-9XIcY10U37H
[NAV)cCd0WHOMGFBf<YY7f,K8GII\fSGOPaL:b4>Z>XDXWX^7[5B3WI]K)6<S3YG
(ZAT3=3f)-GOC51O(_SEBXLXd>?/_dgT2L36G_U=A&Y:LFSE[^J&CSY?<S9X1=5:
fT=C5P\>7X/I9KRS2F#3^AeDYF:TVED;((ZdKg.[];?JS06:g#0<\OQ8,Te8I^Y[
&XL;8NfPa#aHG>-M2WF<@J_MFZQUPA1^.5/UXbE6JcPX)(GP?;UF?-b-fV3FWbD^
+TbVc4+C4?c^eOeIe]c3>1Q96YU4\\92gM@<-ZDGZE[PMPEI>GeR]3&E3LeCY\da
I:gE39>b-SDT9A=63;<FTN<E+RbHF0,TL-B8EPX[b_Y\JM(A32cJ@-/c.(SBYX7@
&XZV5TFb]fL]](E74;[-CR+Q2ccFGUA,;6ECGf7@FSc/)b@NE<LWeBBSe)?>(>][
0+e0D^Oa20XO?M&I]bK5>W,/:)PSEF&TgBW@6g&#U,-.BEe<1DcHPTbB94O&2>#P
>@FS6B#e3[ZHLcLXS(>58^E0H7fUYdF18Cg^C@NCW2LdNZB6-HE7)KS<JUdANIQ&
4e)H]PEG)\+fUC;[2/L(^E,NXcE=JeBf,#aVG3cagJ9;#WMB&Y/UB@&2V]KbRV.f
0TH0aU/X:(1+E9TMO=\JWR3_a,Ye5)5=L,eR\FHUZe1T\ZZUCI?V[/U-f>e/;X&3
H1=6AQS@b4XbEffaaPJH.:XZ\G9),@JE9gbCABZ4[8(@Z-#[:=2JOFH&G8eZ;dFe
\HMJ5F3Qb?Kf@e3.NDb/@Vc1AZF7gOAG_YcR]6>X[Y<-HE(A6cR?1.LUJG/18<=R
a)&+A:S-R1V/M9K)\gQg=;AF_R[W0<\.0JI(5<_3dcBa(;6]EOKZ[aUVT/F+fR0V
J/bRegY-SSJ@YGF&LWOOA88HN2,5b<4X9,HBE<\bJa&6OOI_(HRXC^Qd<:4Ta99R
]?#0NgX?FV8#2ZAHB8S8G:6ONO51W3V#RWK)b4f6[@UR<3:ZDf2\W9KL1#X90fOa
(^5#42M(XV&^c?I?6L?JD8:R,b3@>eQ;b-Wae88=&QZ:gUG_(2-+JH[>N4^O5;;T
XAT)8B:?Q;8H28bARAE_.UddcC-M&0]>&BY0Z]NNH?RbUFWa_RGG>;://KTT-aEQ
D,gNO-;Y.f,.Q^)LFI?#X5fF,8T2@#C,WBbSdO+N>+B.Q&4G6=R0W8ZF.(5QE9af
ea=X&TQ5Lac)G;D1KSEY<43-cP9I4C5e154])g-59>e<17V[GY^A.=>4Y@X8WM8^
e1076\gO^]8+S1D5_B8]IFKLUXSC^7LaB,7(U5f1YCG0_A#ZEeBY_f_KTLdN]^:O
T80](\;E4RE4&V?^]J85&?CAaB5L=f,Q?8CTA>L_O4[#PN\;0D[T;bD2(@VGB@31
Y)H_>Q,>G5-2TJR,EB7RE.fR8fT6PXAIdB+JGANc[VgLCUK/;Oa2CX2N;?:AG;a,
:R-7;:2CcUPW:b;+A[b[48DYL+?DM/B16gBM+/bD)KJYN=/,[1gL]XR00/UADYA:
?]e.D0[NCfH[e.b_:_ZHeV=K(a;QH.T9)HcJT?=Q];[Z_9e,dKTZQ&YV&:YXgD_Y
IC.XX2W;CO+8;N.E8@g>:0O_-f;8ICU_(>JJ2\X,#f4bGTHL23>);3?F-5ETP/Dd
TIf2>K,Q7:?&QF>bR6@dL).7g0J.2KOO)AQ39fYN:GM;=^KZCg)IS1.TZ3gJU?A4
T[^0=bLG)e</L4\,/@D=F7YJa.G&I[FIAR#Y?^O/0aFZ^/@WJBKLN0\VXc7f9gQZ
1//+XF8<4JIF,ePd3g0:,=4+DA&95YQ#c.QVM8>:1Z?RC>K19SO_\[6-1L=1UdMN
2=B83[.W+>V+V^L28_edK^];967]HT33P.1Y?4?e&0P)+ULAW,Hf^1g;[:MI><<X
5fU]2-fd1c/A]X]W1P3d7\DC2Q6SHJ<LJ8YSU4KHTUc?6N9Se,aCJ5O#gO3HGV3S
721N<dK-2?O(INb]6O>>T#]6VT=@)Z\bVQ;1TeB7;<6DCg2PW8a-3<(eL_N6/Y6N
,2,/=aRfeOL\3#gG[S4VaT-=(>9Ya:J)_HOLfMZH^=b7]V,dKIDX_AU7D?b>K^O?
^gTVZ>Eg8]7C3&Za9&)?#)U;9=YJ+OY(LM6BaBG:@<]K[5fMdIWXfI#K(O37QX3+
^Ac+X(3,[OLV7e;[6\-EJcf[30/=M_MNc@EGIbA&.QM6#^O4FS,A)cVP&IZJIUSD
:RXXAAWQ8[8KdM#-XV]d9P\b@<^R?7]J,Q_-Ka2IO5]<R&BR_fI4&Baf3.dYN@^1
K84a(Zac7U894-W<?YU=/3D:MY-SK#J6J=(_QfV>1N8/-abK&ea;]Y>>EUC)T5DO
]LeGJ@Db,B@(-f0@864O&V:^A2ZB(QEC@D_JW+d.gST)P8],+&3@10=78L5G.E/A
)e,K9V]VK8Obf^H4&2+)3,WP9Sd\XIISCc.DgM3B40Ug.SVU5]cA41J1(\,6@;30
cL@^Z;Xc2M=4dGge.G?;-#)5?Q8W-II#LE?ebM8gg?O2GO4b/?+;:fI(fLPDR<2:
?ONN)aYeP6CX?1KG2>O<3XfT+661f5O?W_#2g=GD6S,PV<)eB:6<\I#H+ecUK79\
YJGO.RJ9BP=T9_#VTY&EeDR2]9SJ_?b:V\AcWNb/=P96\T@_QFfV0R<K[VB(,E;2
>L-?<8UY?.@E3R((:b=VE+M]@dIb/FM6J7gPGV<M(]P/,K/GO\P/,B<UG#>+f,.Q
b\K??c^?=V#R]5(.FSPASSQK?EREG>C7<-cd/FZ\SbCY?d#D@104JU)HN\f;]WU]
UD[GB[Z_JAV#(f7S9c&IS^@dDTM+3(T-&/(0+RZ(L&P3dG&\dC(:Bb>4^L4K\6X9
6[+:;FcA=Q:5PE^>@&(TMCc&AcGI];BeCKRZ)=/ISTRaELfR0K&@,UdQMfB+7b;A
ec\HBEA,(RKR7AMIT^;I\Z>/\Q>\fG[<a0gHG=34L5MJ,Q0P93fcc?I)fM51S/K@
6^03F?e^PLZKLXM=W5bG(G2a:M@4B8YMP+EF<]>;<:JNV^S84]>(BI_-;&d)4dCB
I6WJ@CUVWQ0)[5T-N<SK1f7g(D]9\0-]e]O8J66VFW5X7,X)ZMWb#+,#DT:O^-0A
Yc7<a^A5FR3[b?3Ag[WLIe/@GA:V-H_Q1We-1W:Eag-E?HHJd<EWKOMFd[:GcTYY
YI;aeR63_R:GWVf+[Mf.WLD0M9^DZ6^Oe;R3T2+G=WY[B>YW02F2ZX9JbTb-09f8
Te.C2VR6MCOR#a>#2\^F0;gMdf)MM#8Q<8]fVg-VfE],FD,;HcT.,A=&JJe?@1b9
,LJ#Z]c#0],<M,0#+X7_/b>X[[\d&_^?X5ND(J<D>YU6c5=RP?X/V2:(@LZ88P9Z
PM230a[7-8NFHS9Z=T+MAdWd7MR(IX,)GSVW5U_7OL5DWObT#a^T?ZcRNW8PO>)<
-<BeH4bP2#WfP1BACNN4Z/?G^a9)SPA.bKKWaMY^+M&3[+d1aSd3]AHM_MP&<DN9
]XZ12G>K(GQ\/8\Q6\;O;V=(TAcJ\VL(Wa6UV@-.:Wa,#;^UPLJKNE[0C5WG+OG4
VNRHb[_e7Y/T:;<=dDRBc>E)<U9W1HO5\?=6@=Y_T]0[2.C4e)31Y;\LV7K_OS<]
-.Ca1OY;1P)a((JTaOLH?G.OHVL96A1-JA^GLNI^)E+25&\/=@4TBd0#0-f(5<N[
bf9R8#1>?,IfA4:@aRXbdaGd7RQI[(-9g)::N+]ZRZ>9O(+7WbVL1Ta6[ZR,ZEWg
X9G]AV@5):W>)PdK=.RbdPOE34<;de#<ZAK7;+[E<A0R[SA5>X)8NE6YcgG#,H2C
6V\_fSP+&PDcZ^J\516X=aA39^E8^?[-#9E#Z7-C):/N/D8JKL1X_HY]]Oe2?.f(
8P,^+(938[P0UCgKDW@UJ9@ZY:M(cH-CF+CcAa8-P5Q0TWB62GTFf64F;X=fP[J^
LH]^a-@PO7W6R.>f1a/Y#0/+a,&SbQ+B,W#19Y?^],ULGN2F7F6PZF/33=I6IQ6U
F9aMF87:)Rc+H61ZH:FO_7g5d_=c@2a_eGGU<4#;X_1]PAHQ5>BOF:N+gR[3c(G_
MbM3&Y/1D/DDLJL-4R>/6UJ+8VM:IUCbLdI]Y41S+D-B82,I9FFZCB5,,Mb>&].8
,__ZG;f-?fUJ+4Y0P.5[#&+GF69Q[3dM)#YQDeS0f9]3PWH_F_+TRE3)<8<7P/XB
39_4.&7_fV<)Q^6S<&G;3@;XCe04>_HTW-SeL)],L6\T>G>5<d31MO]5Jd-D8XgY
T1QMbCX8F4<bM)Wa&DQc/X>aJ[5d,\F]=ATdg:Z@4[</I>XGHDcZ+MM-HFcW2AZa
g7c?DeEZF@46F@HNH7f/J&VMb.5,;9[b8WMT&3OF6]+GcR034U>]2WbfFCJ/S;;&
[ECX.(J-5/AAPgNVYQ7K/bLOZf4869@Q7LZ8EOZ^IF:_]@f;=B/5fR<:]bYA>NU6
W9D8;e\T.=^_B>]83-TWd4[Z44XM?4]G8-F0M2dQM8(L?EDbGf1U12-A4I3P>IA>
0WO4MF7Zc+,.\UL2=;1e^SgQ,@(L.PO^GFQ05?IR^Q36(9Oe7#BV@C?XL4>FO_f8
LH7d1JI@#?7Rc1(7/JK:]DCD&)ZZd^YA>/#cGEEJJ-RMQI-R0A)CA/>,\TW>K7E5
27)MJL:4?]+;aXUHD#YSRX010#bA9._VYPQf&7RW,b,\1/&2L^K3QTSIE7\XF/gC
1::FQD:&ZV?UFHXSa,+Y32K[gOSJF\?ObN(0FX8,AgO^G.UOaQ3I]&a=R2c6E0G0
GD=U66AAZFJRX\/706cMK8K-9DS#SVcW9E6B_)Ge:fM1N]/M&P5A^IR#A8bcg[fS
b]RR.JIJ3&:@L,(JTT)6/,?d#E1V<<R5//:B+L(V?F1Q9ZS2KT8=N^YKUZ8Z>?)I
Y,-?>9Ab>IE8Oa:]5<P>2HF]75[^gOQK&A?Qc>P_7^>:OGUC.)LbU4IE&gTHP2NQ
EG55U_Wc#O7+9?Q,KJ>D=2>4-^5KfH\7^bQc,g@JGN5,R37Eb51&><&V83[MQVO>
+_[?/daR3/+NC5F.f_;T,(aY&^K5gO(S]_TdN4&1[-HXQ)Zd4JCV>]XEfTN0JQG5
QL0X#fI:_M/(K^,4YfF^-3M-=2S(/HKWNJ.#KTK9]2;I),-QST:UVd3f8T_7VERA
B/0=c<=AUFN^MO+fNU(UGNB)NZe\X@3J]#>Z5?c=BTS[cJd=9-\XMB@93c@:EHW&
S7a[^B5S72H+9PPgMcLX+P1ID)V<LdI)CI&W:Q](?c+_8.]cOa<g[P(&(M>c.BE\
?e=bc16K<]KIUJ+::@08LKEJI[B/QSIE-3?.VK(5Ve7VD7&DRbSf3AHY(O9U47Q>
+AGAP_3[I,>[JP)JB,7V^.04>_bedcZ\:^?4:Q;@U6O5]C5/dZ#0T:[NO?HANgBT
_fFICEI#K86N>DQIOY.a,(#g-QKCLF1^L5_/(7\53JM+>5@2GO<(13Ab\T>MP5eQ
Od?VDc_]01WQHg&+,::I>YRXL5aN./N8dGWR@/@gQ^bRcVa=^YIH@O1WJ2#=aaSd
d2=WMcG-<>7aU,)]8QXWJJ2K@c\7K&/XI_,XB]3K7UX:-e+fC>b\/7^-_94KaH<F
1@C+NNgA,QX3AVJN:6A1(Fb@+Z7261HgK\7?J?,ZBR\/b#7HS4M<O[JR-:7YDRIQ
3-]5Z.e^CKgA<N1Sb+4AKf)C&XC==7gAcO32cF&,b1RJI-TJ^+^>&7Z&SKCEG^O]
Gc3L,,#_5R&R0_5[<A9#K^_,1JVJHZ<ZNKK9NV<0F-R;[OcEHBT\:eaA?Hcc1450
:0cW]J-BA8c4;P3AB&=L^eb;IS.(d?Ne\.eU7;X+Cb?UKM06TCBS;J1\8<d=YBYL
@Nb5XV#O,-=Y1UE&97&.-D>2NHBV<WL@R/71RL70[_?E3^IM2[93ZCJ#(8cE\[8/
RE3SUaf@/,^H3a,-1C##]_E=8IV31K9ae0>bORecAQ7N@#fS4dLfU<TB/d3WQE=M
_(R5)?/g/g?1Y,K:_;(\U)6T[=Le)9/C4&9(<0&VbOX0KC(QOQN).Ee5cY\V,I-[
I:M&P,O)YGI-+/@Jb2^/.e:#<HUIbXLU7Z6Y;2F]\3:_L2D9B[b#]OZg#]NA3_)<
B;e7H:XBIS7@:/;BF18^K)+VE[2?]2.=_Q#P97cSN11eTJ;A55Z,O1e#UfcEMb+Y
SG..O&QNeWA+Z.@4[EgF[[EF3XAJPIGb^b&f1N]S(0Vgg)/59_&;fIb0E52_J7Ie
H)CA#35GXddS0gE(XKV(6,K<>_@IDSHNN5aPCGQ5?#[)G@8gb]dBRgYMA/K<42UK
W4A_PYUI\MYIJSLY:7ORbf:^LOD-\OCY7RTHe)&56&Q/H7dYcC0f(A)0A&V<4&EH
XU-B7EG3]N_93._I(N\5<GRY)O:Yc0C2EM1QEZ:L,OVLZf]#?H5dc9]ZG)6VEW:U
6:)[GL_gcXKU=W1@Y+8DQOA?J\D#@A6Ee<PBe?\/BPD3LQ4/9ePB+\^9&g\4C0f:
]IWL&;E+.D=C23P:BFV(M2:4;&4_#g:>E.CIKT#LT)0FRB06^Fc1]SGWM#\M/6[I
YZ@6V;\L5RE(Wd4^b;gZD2DO<9#F5VIY:J(AV8I(ASS4E=>(O26_;;3X3N?(VK=P
@>UP,Z5L\:(0/4#e#E2)N3W:_9T4EME@Zc8_@MO.4#9@+Q2VRZ;H7Z\YL,QY=F][
B[3:H82aL;:[82eOc=KJ:1H2g1-_5R2Y@5L(0[V9+OK_D;UNAE6I7a+6b7VBZ_cO
U8-bCK4W4J-7A=M3Z8\V&8#7[H^6]NdV)T]RV+F;(P4CQ_>CSbVR5)RCU9cZ9,g4
:SY3<.]\((e[\,I]ZCI.LgB#Hg3-UW.Xa]c]\Kd_E)J0UTYa#)e25YeK?0KK,)(K
,R8+/W6a9,.FNB\gc7gT2\HP9R,H3,</]3^@3&=+g[T3)).:Uc;<14E+:^fEN=N)
_Uc;;;2#cKO<#OZS7GYKH8SUTeAT/BTJJPN&3?1b<@BW>+6fE,N^HALDX:dFRSgf
:G4Md)-C;L7&KG616c1L4d3[^aOS?&<2VWb#X0aVPQ,+]YBJ/7gT;4V^)30g/T\+
A6\bA#.N6?V74K.5.9X6Q-3@]&JbUd=T79Zga,H7NJS3L&d0SdJU7+O0JD<VK:EN
TPDX69,8<M^YOfMcN=:de6S-OWDE<X=KBEe),M[K=aN;62K0K^7+fAFR(EdI,BRW
_QQXB)YM:Ig5?919>#KaX):T62+;J:fH431J?dHC]80_IKP@L^,MF,HVS-O1>10g
YVL(W-I^aM.)V8Z]J\PF&@,:NFY&=(2FT1D#.NC0U,468A_7U8RQcF/<f\8E6JT[
IPELbX@-_Lc0<T89c/:T8L\JX2+@SHfFRb>MI0\5D#,HOYYDD/PH09Y#d^=_08@0
0f]-4-;9Y4IGBaU6NbM>-gOGM6QUYg_6fa8_SMEV/LaS#X)Y5(&39aBdB6WD#d\K
69H/]N&e-B69FcJK,KCAR@\KK7S-&+^bXg)ZP9E0EgRE/3f]I<fASM:=PQZ^FfLG
U>Q2#];1SV<ZV+aRG)db\[ecQ+=\Z()8Tf0)e,;BC?6NOH-GT(-@<1XZE<KH7)D<
9VXI:SF[cH1Q+EA9EE_RVY)G;<4fd-1784;8UdSQ98:E<+G9E4g(@VO<6YZ.:M7f
80>dZf_7B@\,[LFRW;aA@Bb@eIOF6[VHdF1g0RI1S#EE:?>CAD>=1YE7N)HB@N0<
NUH3;_E[fg-g+a@0GK1(Q@:A6gEU8.[+gA-W>\fP3FKR:-Z\cMV__<RB2TF[RR5(
K@2]7J=FLBGb)[>(=B=#,AIB?3K(-ONVPO7A4<cNB?]?ZCXP0bZZH8JZS5NK25?d
SD3JCF62ADS49GY-.&_;X1&dK19\:-[/:V8)V4K&YMLdME1>a]GaI@XH8V;I;>I4
^\.LaCK>#C3UKWQ;R:/09cJRa>,LGXF,AP76NAGL5GHPJUD,WJd@6U?d-.R<>?_O
C34cF<7TFA<0KcAKX8,5T0]W7@/Dd:bI]FYWIJed67g4/=TQ&&[G;/&][.\)+fd[
O909I(92]K8+DH7KC]a^GPU,d,]1AQf7[\5FZ8[[HR=<bP=YU97O;IaTH?DFK-?O
2_PQY-\WA;GJfIUE3]?\7K^1?I=Se/&^8+MO)Q.[4O&=\[:+b@W=7YQ99/TRG#Ve
c8g_,fA34(b;4Vg4&[CdEaL,(edHPEIUE3\-C[;fLOa/MXOS;I1]YSM0<)\H9A2F
(AMb-GCfWMGMN?P@eUbgeSBW(UaHW)Z1:9K\K;1@Z&3e?ET8AW>)X0(;=-C9MVN(
FD8a/<S_EH@7FZX/&)Rba,/(Ca1.cW_O@Md;:HR.@C+gS)PD)VYR@W=[3OBX1H<1
N<7>SW;WLS[^+LPPc[-QS6Z[f(9\5BYGe]=,1,;fK.+bHMPCeC))\J(9fME1FIYS
NLCd/UeCWG0+^WO[\dUI^49/7Ia=5^FE?+HA12@#_a\gIQNSM6Y?(LCT6c4WM8Rb
H6?2gIe:CgVV?@e@YA>f@(U,JCYO87TKAP^B-,:W98Z38@CWB<>>;3I\IG>-\:5[
6].S[2MW-JfcY^0RQYN.cW/CLg-@7<4Q(ICgY(;N?17QgdK\Te;<-,4/?X/K/LNU
A<[ISB&HcXgc#MZI&W;f:H(66?(0]F:)?\d#EGKSbNBZd8<TgcM@H]3ATK05Z=J3
K^C3SZ61,_a54K3a\3SMGeI]M;@HSRabE05TA^1A&\Z2DVIWH[;^4#T1e;b#1+I;
XC(De+5(-Vd=/4_]TPK&O@baAFSO2\CR1I)^8B\B0].F=d<P(9=\+^DePfS(,S)?
FG3LXBM)#&8^C^X#]WU)6]X7C-WMG5-#PPP9[N>4UC<^a?ff_+[,4.Q&e-RV?6gD
P0;6dE3)QF&bYO+<R&</7E=8>5b#I8,deWZ)R3&NTBU7dA:d^P2C1W8NG89/36<6
](.I4@?VEf@CU#+RWUP#B\A1&CgfOLHHM.eAd0&d)M)WCYFWdT2S2&\gS[U4SZ(1
BA2/>=]?N?HS-2;cV1V,QQ.#B56P7>>590KZZ9G(KVbR-<f8;aLMOHALEARQDe>O
]WHD?XI-&@?:cb;<CIdEM=8D<9,]^dW;D142gX+.,P#2I;M7JCN_52O)B?OT;DAR
O3,QG./993+<:656PTTV952/eE6M784-K0GYYWXPYGaYDWXLUM_)&BUW8]1&C94M
=:<a6]GR,/-)8_,NVKO@g.,E/gc?Y\Q#54(c/9gO&^&2H8QEN1,B2/8Md5)U\6OP
@>15dYaE/?62J>LC8_ITf)R8b_DB+=d<(0d8I<B4d:-::ZB23?3,fU1EYdCG1a0@
\M(R2UAF#^aZ6SBEZP1N@V?],T8(Q7)F.-<7C(5G>MXIaR?(dXZF55,Y3Z6XQX3H
D=._2>+0^6;;&ZT1\d>.WBAbJIFF@.71086KKa7FcNE#-]A\0CPTXfIa>cCaZZH8
?-39#fZ\E8PPVd1aNcP7NCM&Z,f->M&O>d84+H_2W(3Tg\H?NE82WGA>1W6TG@Ne
c.?[<.#E2DUAD<-_;_2OBKQBb((\GIK46#WF0a+NR/M\fZ,ECfVAc;5&&Q,R:R85
:)TY=50cU5-g>DfKZGCSA5A[K2<8877-Q(ARdB?J<\LL^/2?Q:[IP#L&Z)aK=P(F
FgL8=ZCJW]K[)]>D.7NOGH789Uda>gY)H,?15S^Aae9TC,agBT98Ic\2W2cK.L;A
POGZ(Tc9E@0W98^2g=]K<-,Nc>/2[Q@#,<T[DKg[5G\3PfKGBA\?0Nf&Oe8K=P.?
:7(R>)L,=/.>]6V@GT&WI8-,SW\9=TbA_VPA#cGC]GW9\Q9.CV<7WI?VX[HbG1,?
LWfTTXRL+WKB0(c^)d.K@d_,78:eNaU&Oa&2g>JFeVe74B.U@JOP-AZf,V1-5.KY
YE?/W4]/dg,]C7P5O(@E#-?<0,Z4eC>44[(#P+Z?[d/KU>cRGg\XUA\E&?TcRKLU
#Ff:a-C];eO-<Ga/TNCYI<?e)Vc:#U&@<a5N?9:#+_1E-J31)La<6JSA6NV(.aJT
YL-gAcUSGL\C?^1c##c^YEaaA2HK+J3-P:)9-<EV[4/)X?SAPGLQ8K5U?+V,;B8:
?IW<R?4J.@6@<>,QKE@LK#+N(R.2(=5X30=M#G1>cAdS&:A6cYTQ.;dZS>5+fO(3
&=Z@V2dOZ5)Y4NaAQ<S<0gF;UKN&VA66<8V>C=/DJUD8;dFX:.CH6Z-NNT.e,(1U
W9>LUcU2U.3#.0c=RX#3,@PBeMcO?#O0U,eP9?N936XAg4cKa4D6WQ2I<bP-9DU=
A^aT&ZA;DNYCTDY1I\):/GMRJ46()-[A[SU)Pc]IHV9[_aEZ>GbY81:X<60-V63I
(+IbdBaJPP]0>54=_80&K:@M6-#^1_N]@>C:-,OPKT^#,LZ9I?KSH+L:S((,_[\K
Y0EY#LH\SWW[QI4bCMP0Y-U:.BPM^[8a+38OK/Rg24Z/-&6]cP:Z)^P?H_/a^W:_
)ZFO3O516A>]fSY8F00,8(T=^/Jda&.(/b;G,W]Y(-@[5:G7P)KJ2(3)W@JScg1N
<<+8\c,,bN.]D/I5F=Z-b5dSGU\OZW1[Z_Y)e&M4[YKeQ\EM8;<E\,HF.4)Z81aY
S7M2;1^RW3c,BSQELM\g[_]N01M6_Y^?+3cdPE#KJ1S@M5Bdb_#T[?@/WDf0JK_I
90]Sf:,+8,>IQJ=/^>MODG8&#7&.)PBI/Y1#ZVd>&6N@AZ&J[G>G.UJJAZPRV0(3
Y)BcZ,4:#H[9OR:0f:b((LR^Ve6YWRUb0c0&VO4B60)8[.MaC;Gd(cX40N-VW6OT
NWMf^E[5)>_)[OBK5SD^(4>X/O</#&4-LD506S]1cZ]HE+f#Tc?a25K)?2YSSZG+
:ff2C(U4UYD1N:0J3UcUCIDBT50_FJTUWSZ7H_YMZb2.PD=XV]&,#KZ4A?M?QAG?
F0P]]?_Q;U==@G&5;3VZEW5ZXHSN6B0+M8d?Z_B[<c;3^gc;N83Ob+IKCIAfa[9:
2W^E3R+fHLWfSR:JEV1(HFaK4a]cWZd43bSBFZ8-[[HDRC:N(^QSR;A(f1b3bU7Q
C+-\C,MOXILZ.TYNI7b@J@ZBI<Ufb>]7Z^f@D56V5@3CES\3e3&N\>1Q.NeY(GFB
PPE5NHU#WTO=c;/a[dTM@\(.E99aCM8P)cVF>P&U8;O,U-0e3H+\H9<]#/RF#fUW
PRf4aU(5VQ_IW/5&V6V#PW4e6@BX)E@YHdA.R:(-8G22N2T_9U1(bA@8#@23H-G-
Cc^+;/VMF[<,QP4_UVNR#[/<#:3@O1d9X9A3cMELf:7FN\5H.Q#?;X:,4SgbX(0[
OS^QBdGSYQf/=D/deDYN,a^_2dA(F@5)3NffC\f19RB#bBeGZYE3>L\.4MT<K\Q_
D1]CAVI<7[0D<e<G6T\_&J4cCF^Df9&Q^;SC(=^c,UXK-VAW:+ff&@5#.,VgdN^(
J1eELW5C_MaS86ZX3af_C?VT>D#[+D.=Kbc3.7B3.TcZG(+VGQN695\A+JE/d/dG
6\:d.gPZ2.]N#c>e\N<&TR=5JeN;G>;Kc<+69&RXGM(AX:[M7Zd7EYg2F#H&O/D,
V>0dC[ES,[b)FM02N]F;@[/)R/P6(CR8<QN8[:W4HA-4X/@T=Q)=DL:6]0O\COMd
^a4\QB#TBNZ2HJ41Q^7FUGFc,#U31>U]T+X2Y87X^1X8LZNIZ5;Pb[#BUH-D9P=U
4;\G1<K;(:Ud1-DECLWN./95AGTP&,D-#.D.Z[1Q:[]>Y7[0X#VK.H_5&a^&F=<<
F]CNV50Z#ES8A>_3W&5\D=Yb1P#Q#e_UYD+B?/HNJ2I)&I4c]/NPU5Pb@^72@bL/
D=J9D_6FgPU)/SU7]W.7MU+d+fAc^>>XZI\0I\<bN2b/;#4Z&<>AL6)6/d=L.DgM
]KCWI]:\3^WO9<_1dB(EDL\^4aVfd]Z\#c?BX3FI7a,Gb,]LH,4?K[,K(K9e1FEM
ZH?C@aQ\8<XO82A[bTOb+PGdgMJP/?@>@]IG^e[f82L-IUO.cac.L;T8:MCC4DV4
YG__PXceD+:<fQg7)E1c0LSRA4_)G/7BNL\DEGfA6UPc>fIIbE\RA_+H6P(AS/)/
@EH>5;3DINPQ/[5AS)3M>DT-RG,4(?dN=5]bMKO?V6&).WZ-;LPCN[Q]1[>@(5EZ
KN/6[)If;KF&CIR@II5HQOK[Q&CKNMJM>;K(6T/NGWNH41>>L1WM[826cY/4#ZO^
8H)6Cd9SbOL,=W>CR5C5bc<E(EVE@W,L/+GDa8&>[E(E<cH+W,TVJ_;AK/H6^<I+
T?MR95,?XO._.YS4ef^6Q=QW&^:^)cMZIY>@>-)PJY=Y-SRaK0N3PDKEBbAaX4>G
^9Ng3Pe\.d3.>&TLTcTY+^F#QNMF&/E,R>)6J,]-H<J?)b4f-EQECWZQXDTY.2-;
RFAL;HM3;EcMU@^JIXR(dZ>P&bJ&:MVTH^@#65:M9/&d<M:)RI\cE\+G\CIT:@8.
@fU621A?d?PXD=.>OTB.-?ZO_A2,1DH+@8,gXYAK#a^e5]S.I_LSddPE&TC<[)=M
<HS.G9f(4EW_E.cTU?:V.<=U5QC</AaAW1<Ae[]OL9WCfO&+6<=,;R)^+:f^Z-#W
@.H>D4DB;64S?I:O[?2=@;(=19+Z&SOK]XE>6dG[eXAWecU1R-eK7Ug#@f1W=N[A
@3NUHa_bA+IX(FIKW.eT(R(KEAfM;-?<+fX6NA2:MFcM>N_+X0L\d^<6UGKaLfJg
gffXd0_d/GQ61EBbdT)38>X3FQB#U4OB):8ef-Y=e-bfY^Q4P.,MUY->QWK+=)2L
-UK?6:-ZB5IB>V?2H_&C18:9KIA18@/0X\K<X2_.SCDI;Gf5ZGc=]3DE,ZS2WR<V
V#2.T3fY0^Qf@C=&DAd?#-:G[Ya?S)BIOa=K.QO>J6&=I.JW197Y/1L3&\eL<]8M
)YHdC1Y2-<@,6X<PaD8>V,&C&ID7#3;?aTJafOZJQ3H_gFc^M3TFaP^P;P,gcY9V
;GV>R7/C@MdGN5A>B>VEO]G#VU8^C-I@,/,a.+:.+,3F5fI?PfI&L+&gZ7WEFBK8
;S-];#9=])XB,\#,^a,4(4Q#SB@WX72QFLa3c&[Q91E>&0)@XeJX&G8cd>^#8VQ-
bGcI9LbAG0@:.d)eH\]YL&\:R>Y56K1I=A=E/(.;=1eceAOdOD?:#eZ[FHeC1@NK
g](L>4R[A.<NQ#<NTY@DKFJPN-1M@^0_Zg:);fM)+F.797:MF7=fFO;8LNc.(F_#
)8>+?@/Q+Mb:S6?-PW]=U.aM.]ELVf@96IeTE^>/d974?2(BaNAI=V\+8H^^b<,Q
gMTY<VX9RAeL#6f\eS/[6>U?(gIMNfB,LYTgI4df^Y5Zb+88B6MUE]O/6-e/>3_/
bO3LH9Z-B=N=VR8/G+AY.B7dNIKAS^Fc(:MICA&]C>fDeTa_R=bX0Z@3:_eOJ;Nc
CU5D1>C&:B65IUQEbJQ8V[O.O^3DK[N2LL#[d.0eEKd0BbY+\GadY@=DE\8#A\eV
3GfN=5<5:>gK.?b?1V:d#b5WDJ#aFYSD5bFA#P?J1T\F=DW5A_/f/;E.PRO+#655
WHO9&J7SEJZ)>(N<0W1VS2_KB/ICg(:@8f+MWAG];\V7[4B9EMEA>=S0\HKJX\K#
UC;YUg34)Z59<bfeT\.YR#E9OSa+HNeKMIEcNA8b9G]EL#1]D53Zeab#U64:,[>:
EWa[IVSK6/2^M_\Q3=CL<8U^9HUAAWb[8WT^8#KOe6/cD&E:Qc2^&df^;>@@>R9O
JET46HNSb:SYR<4<NbL9MHA?FTRXBT)POFcReJL-bN2HA_\(#d<3@&>=)OB58J>/
86e:f3F4)]e/^^1T8NdYZ[<A(+[0a;eg659;]@0Nf=U<DDUeYcI4P,,8b<N(;fKC
HKOC19d3D(g)GQM>R8@WHdO;aB;H\(#JeX7X0ADS[;X.T&?RR7D@cFNY&<XS>OLK
dUYf=]McJSNO4X(#:EbA<VS,A)Z5XG#c7g3Y]aK2]437fPX_]Q/TR=RLX>d+>fcF
S&MMW5S>OS[e(=H&KT=1-2cPR:c.R)b?],5VM@4C+GY-Mec-HS^./.Y45cF4R=F4
bf#^R8P4ccMa:FIDF.X8+a&bZfgHH5.:&(B-1^C>D,F/Ifc;@TI1)?2WL9YSZX?]
dA@f[7QNd)f<\_ZbU6/U.ea41a&,c)eXQ#_bD=)K-B,>56+LZ5X2K_)9bcO5V<9c
Q[7]fb-X&,/Y&3MBY:<XWO9;FR+=INT4,<b-a&8D<Fe>E,I))]/d3dHH9Xa-C?bA
PLS92)7\dBaON#E^-9\db+D]0A0=0Eb71O]A2<D7/0+<;3FO&b;(/5@./K4V\f+1
SS=QXW3Q9]U,>(K3e\c&Q=BRB#A3GHFf?O<<2f2D[?O_ZFK[^8fG@I>ML@\\U=W/
0AWbb><]ZNTaIP;C3Za4A,V[8K3O.9IH(Rf/.?=FF7[8d/LU0UV?/(Y?7Rb+L5dJ
V4BNDZNO])Vf4OE\XC#H,XEDLNd&;/VF,eAL/(R+c#FcPIb]7+3GI<>QTb.\(>D+
Agfb8Y2(O6F?#HY+5JIZ7^cQ9/?D)>SB)fM]KHRGA0>TF,K?0#,cR;]71f>5;LDR
\4KgTG#W/OP^FV9\;5JP5=)PAO[^_XbS[2L4\E+bNM&g_2#_Jaa\g7-4e+g;A:YG
/M?Y2f8MB&Ge^/N9RA)]^MPN-/JQY=<.BEO;PQdG9Ubd_.^>KD&(Pc(bB,LeS^T6
VVS?14d1QJGGeA)7[[6TW[WbB0ef2eA&\)bbfCMN?>2-,V[-OTE_J//9-9fFM#S]
K45J/?&QW[]g9?_[[U7JGZYK@gc-8O3;G@Ge1aEG[0PW68)g6_S\CI-[J6XX&HZd
H7WH<\Da)\8+E&(VcPW?Qb\1Q=d)IVPFfE>@Z,](>RD6O[7AeGS8I3Zd]DNB@49W
G_1bP^ZZd1S5/MXbc.JfbI@V,@O7.>LJUDEK3-S;NN(?Ge)KF)V:cdWgB0[9O#0T
,MV3LQbYM(1X:dDb[He9gM,[a/CO6EeO)aO\>dbBXTNGe6L-Q05+ASZ0,:P8GbAg
:#=/OJWbZJ(2cOgaaLPR2=SgR3b[@,HeG737\,XDJ4-RJTXca>W(8\W=-fL,6@_&
8<D8SSUL9b_,CgBE22>QE/RL+g0b5T,Uc\UXCVF;0+dB8b,J/,IEP;[c;?^3A1H]
F1#WES]Z<D^Q^Y8UL>X(a>@ZR;gP^RZJdQf3,eXR.]<>e4#e>;AKJ0:_AEW.Q+W-
?:Q.c=a&:276Ne-#(;41NF1c_@(-g5L[dB9+5&SV;<B.QJ@[O9@<8.(/Z./;O5Le
(J?JJ5Y3>7H=LN6:U#=W[L.7<X96PVK_]7-NX9&#G21?BK/]>[S?BG=HMFTVIcN3
)A^)85,DfD4/299X3HP7\fQJ?6N2X](\5aN4P;E9H,3>?P;5f6&9cdD#4KCV--d[
/^DA6W_6eXV0Q/;R@gaGg0d#ga^bXCKM43H<U,#?.Xb8S1RaBS5?RFB1W0LU>gZ<
R=_WSNU.<,UEP@&ZEe?LSfODfS>[.4?M&642Z3CZ&F0f#U@(B(X+)L#[\5_]ZCHe
IYT-P\dGe?<Q;1(R8(3&IU\42CD(41e(CQ#L:gd@cE6gRXf[L+Rb1<;bfRO-.\)K
>/+R,EC1(=S?KLY,GE9(>HIXU.=;<LUR;?/+QLa;Fe@PWe?5,R)E<GLKCA-NcRZ3
dD[3IT@CXUX(Y/E5e;b^/29S9.ZC#.]Z,D7[gFc)[;LK5+,g?MeAW(BaE]Pd@aG[
YEZUL.=?;;.4.-F^NIHAe0VV0QNWYBDJA_/C^Ad2,3_8QYfZ&N#2DC1#]?7(A]>+
>>/HFMRZ/3K9RASU07g5/R,^6,6Y[.d8M3?;W;\g\QHM]Gd>b8_[:J&a)(L>OMGg
D5Y<E&fU&@c@+[N#XZG\I\I<7IG0]BU.HAI@E^9I<H?bJTfQFD:gX9HV;P#4_DQ<
cNN841@b,cRcU^7e9?#[W-+J,EC+F,Y1b)g\Ac6\-,OUX0KSGF>af.PJHQ;0ESW(
]X)B5@R7g0]M2#1WDOQRL?AY;Y#[14_<5W_MZ]KU]+V&:UDX5_42Tb@gBDd5>L3F
B>W.I8DYX:IN/Uf)g.,P;.V1fZEd51UMbd>)<EcQ7GPJQFePTFd]L=0U/CCI3I\A
ZWP\K8+?BLYHG7[^F=HVN[I,(.-S&UfF8\WXc&c>_9)#T2O?@d6):<HLTd-2W,a_
6=A;PON=QSJUN^g<7RFK>^;/(#_TE8;NI(7\aJgWgGF><4^O-e6460:IZVHQg&[.
:Y:VZ0Q[f\V,e_W3c@5?@SW3](5d)RJ5L0)C>#MKWF)Xdg6)HJ8\f_;e3YcI/6aA
NRcd-c<Sf1?7b_OMOYP0[-g<Hg>IY7W\)1]\(R2;9J0V)b4T+6..a4H7.IXH-b=,
g4A:QK-Y7]^eS38J9Pa<5ddK;@;C8?eR_G+8:W]/9H=/1Ke6A;ZZ:PK41[8P1NAN
eMZI8;(TAN]8TM33c?+JFDNKZ)6<Gfaa6OS&PKd-BM:65,=AK8+UFSeN0V/0dRY_
QE\I.,?:/+]UP4D[f-gZg[L+A[3<4\/5XB=Hf1gf5Z@J::;O@)U4^fCRK<cf:dM;
J:N^=H:<AVV,O_WU2I.?I)C;Y_.NeVC47FVL)S([FB4+>G9/0e<;WZG9b)5=:5b\
b0DL,7EO6>6U,(/&Q/:9[KBK<P>CIG>_/5Y[.8c;>,@g9Y5[IW>g91V21+/eU?N>
8_\D[&3N5;X96&&I:W2H[FYKA_,K5&c1e;df;5AcW)=^EYZf6;e5b<BTN3)=QESd
VKB,+NCQ0UASB9I>03B:3W(YKAbN8RWL=4D&SAYgUHZ_V)=]AV7[eX5Z(/+X2;LS
N9fa#A9,g=4N/KI[^Zf/OT=>Z]V:fP:ZVZ#)c;9N12JT78E2M,5>8b,Iae?3/Me[
>U_PT8=[.+F797aSA>YPaZ>,+T)DRHR(KM@C&4MM\S&LB07,K3bI;+U^W.S#?]=Q
eaM&&G)@-cM2VN49R=4,2SN464Y(^a2[Z39gJYf>NKTO@3:7&NW/YQG]&;7LR(V4
22^VaXJ[#e^)P&T)[dBNBS,SW,JDAC,Jb.ZA[N8<<?=fR_c:QW&XIF2aOQ.NL@;?
V[:2YeEHd:+1I9X_feQI,:0UaS>3=[:[]a.BF.Kb>/>abMb^OUc>6H>_d,]@WJ[>
];D^,0\],QO>a:[FFWVcG8F:Ca(-@f2HC+Y<4&.#3aE1_b7UMPNL/@@W6YV9JZD:
661BU#fRSUMOUS.E=5N=];QAQ=.Jf2Ef??a>f)bf^>6^QZPQ&/_C++NR_E?-6FbY
,R))RdGYUS49J[??XWEA_U(cOg4=ICNO3RV#&dg6QB^MMGPfC:#M,2#2;W.SQEEd
cFDaM-+QO\[=\,Y(+WW=->gCX1MEB]ZZ[)K>DB,dE/-9KgQb,1b:-R8<^)@EcJ&3
S.NdPEX?4\ESAP<TDM:,S:f5[?<]4)fR-/SeG#T3P?BaXQL5K.WD/GYS))4?LKMS
5LFH;9]KDK#_F4]-QR,Hg^&X+)P-7C6A9UIKHNC5@H=39QWK4gX]SNB^I+A[?>;&
BCNU7U0g:?&>R1YNYZUS_4a]S^,CK@QW3B?S&#@J=<X<H<8JdC;#Y2[;EHU#I=?Q
DPM]UD1VQ3S/]C]6CB[#IWB723Y:QHJMUDEa>?PMD8b3<?@/.?<AZ^Gg)01#7gHX
]c\W[&W+-RG=_N35C9Ba3f.3KW6054>SBe6AMM[@U&4/)6JYcXS><IV<2FBQPL5N
[?HGCDG)g@UDPdOMB[1J?7bdB;@gHBDTI27L[JBWe3X[C0;S<=9WCKfZ4:+@B1._
@OLEDPOKHd_T\Z=D\9ffeH5Y#E11LZV(g\ca[c+8IH4\M9/_1>)7eL==5\OV);OJ
4fR.Q3PV_TWF^bN5Zd4;)P48g#WCf4RP:YYP^(CDcJ66CNF2g)@W0JULT#(_THf4
RQ>XJ)Ce0g28bS&fgM\DfYF5C2e74@OKgV<)_f79RaMd5U(-NAEG#H2Y,CW6)f^X
c/7_MQ&/P27W>O361ZGRfb+4>J3/Ng^0&F01K#?2T2;]-9:QE,?Qdb<O/)8DA6U?
73aTI65gU\C,6=ZTPD;=SKX83:5YX:5M98847CeB7GB<87Z_a0;0&G<BD53c+?T_
&ZGIb.XOZ566H^;?4\+B2YKQ@;gWc;@5/;Yc0K?ZDY)[EUCf-Z1ae1BbJ;Ve=J;6
#\\QAP2eB@G&-=GCBMc2PE(Z?6QGV@VBdbOD.@S:fU0^[GFgGc\_^M<^<AYG37/Z
93@DbeXTEVF.>eSYS6);G<_H^-O=W.df?KY2(CD8NF+9;NMEKA9MU4Q)M9#WQW9W
4+.G8^T6:WNf6gKU1B5e?W5[3#LK3F(g.P8TUGTG0AI6EWUQXb4KJ^5Z6c0A]C8R
F7A>Z/9F0U?=+f-AObGRCT3-F:+X2JEJ1)VJ8<+_@E\XA5Wb0N?0FU,R)g[XRK12
,/dBKTg^Pe9_b@Y:b]L2d4@4T7;M9)[VcbPe:AdbTR>DD;8+5:^DP\0L8C_^3f^P
)OL-N)f#L47&cfZdTG?)^4.ag?[KB]J:?N(YDQf75B]6#\<@N&V\^NA&;:6Y358.
1448]Q3X9XaF<-PU\/g9;>&bI&4LXIIVKS<^:]4=gO)KTK&d9VI=F,B+ac-Y0:][
M0ZSV[_THK>ba5+=5S@M>7]gO>1gO<Q_E,NPS>Qa6,1fIDY0C98cc.9&D)X^S++4
@dZ0@E2W8:,TK1W-]^a@2+4=#(O6?C8N2(?=5:fG<X8.EDZce=G8d>OX&J]9HY?8
L2;+<W[KPJeaXTG0M+T0YM=I<+>4.J?;4@ON[.(-_[<.?GCBVPRaD9K,C/<FJ0F\
H2DFJD0.PYRS687FP1-fO7)AgOH@8gMI-Y+=>MAZZTC.LTT:BR93;\Y<&/Cc\;HF
VVUBWT5DFP#0S:<AaI1VaXD:Y3:RaMe4WdSVI02dJDN>XV-bYR.MA+SO^UFBIDF(
-=aH2a+#dHe;<=-E0WY\ZB2DWS&N6<CD>T5N^+#.G\=E_VTg7.DTe;\6M8TBB/(^
g\Y@C52L\?U<R/S@YcXV0OHUUP4H==>_9&XcJ/e+,YKdf-Q?+2J,IF9K23N=g^U#
;=S_WeKPNI&5Mee3Cc>DL2RH+F8/QWLNB4YI1M1L9+?S=\a<@1Td21GC=7(aINNB
0K9S\6gRc6)D@:UR#F]:86@=P[aXL,6WV<&LR^+80J?c>JZEG,8B:;0I8HZ9_+&L
g(9C,d\RIS1OTQ61-JFT#=Y]-HWK8M-e>W3.882_@+d(QNa))I8],Zd.F5^5f_cE
@5&gU5.O@T;VUbG^^GL[(-=&\T[TEO_SM)/d52<C<X]W84<K&LILBWFIB:Z@A1+^
\RP9?,XB\]>bSC&.g7:#P93:X3;39)aT9@XO:(VJA-aZ6)8AG+TG4?U2E^:S/NO.
gMJE1cQS0e[cg-WBd?QL(?#MTRF966fD,/?3>Fc=c9B&ZY]I93cfTM(,ZdLJKLFY
^WaX,-BCS<T06geYTcG_-b_)MYb_)H4#([@MZ/N3CA)]aTQ10X0_=&b3D9D+MRQO
<D/@TbW^B(@FZ5aDea-JIc/M;O[WSfLUD6/C&XP(YT6cWO8H3MN2]Ca&IV;+RLH-
AcU.\JBF4TB0]8#Ag79EP<(IB1(FEA8GA\.Y_3Q_RcD9a6HP0NN2@]:f/XeSSgJ,
,cK8H>B.A8AR-WZ>Nb1,feQb8F:D=B<>5L=N9K=/HBJP@,[?V8\#SDDgZ3YPU@e)
VO;\eTU2G;H,c&XTbYLGY)1TaZ1CDYBW>=(:CAD\30,8/0B\X4^A[^3YI&Z.3eEV
=C][:OZ#?N))66f#NODSJN)S=]W.fff3SGD<A6HQK)OITC5P_&VW>KW.f(Y56LV/
a;W6]OP/<SRM(.5S+[S;?Q(Za(:Q^@88/,#GH2\BbM+eZ.dCeYI)Df^]?dIf:L.L
gcL//NHB9L[g3+T,EdHX93a+].1.5L:ZZa5TL#VPO<H2egWH[@/C]TO:TVTGQacV
&>S;W_-HA93cGZ/3RO/fd1^LX.c,TJBFCPC(Z_B^0T15gDQC2X)JRI[J4.V2DY6D
#.?FI6NSHe(55/X2#FZ.CZOG>g,DdeX:#E8F+&?&J)V?.2QYLIJ&G9H6YDG+FeY^
T2QY/>S9EX;@WL^95DV)a=:a]DgGWCGK6D+<&BE,Y&UZD=g3T(&^US:^+9WLfOCB
52VW61KdH_#81^SVN+3Vc43)F(7\W2HK,YAbZIX==8E<f+HHf-<^7Jg0&^/[SPO^
de0VB#0bHa_AL.3dL3b^G93WAW<RLg+#86g_dMF(.Te7\:UIXfbLCC>=A+DT5_V=
[]L.>;JDLI05V^g;NGe(4/>:,b.XNRP:ZXYQ6M\930.(Eb/C):M4dV&MO55F?;(L
b&R5=,ebY.X2d.X/I9/E+MM?AL\#QAG,WUU#E&BP65:H(?]9;@?^6UEO8Y4:MB5=
J5B\JG,(N(d1[R;6@QMC,I[:,0/2>@eS<.cB0N4>)YJ[S:]>..W?OQ[(2804Ff<8
)3Y)K<9JMX/M&4gPTac)d,XFD@HI5^eB=A0#;]M1Beb?8TWX7/V?f:)F<WM.Ad/U
,J1@Za#-6?@YZ9=OJ,f4\^8f=^4@?0=GNc(?5b#Nc@GDB55JU@:\]4\\K9UAO(/C
dd/1?S=&W]a8a7L=)(#dcPD@gBWFUI8e\7CMD@XdKX(+S@e1.AI(3F:fU&.9BD3B
5RZ-<W&.K;)PQc-/S<4\+S;[RB,SBY6OLe@_/DfN(/NP,W)T<B_860DU&D+N9-R&
/)P^PDLf^ZR;;:,Bb_YIFeU^Z[TJ7aL,aK3c>S1+.EeK\LeLPHX]g5R<WD++_:;d
OL,+JYS04\C+O<+C][>/01eN-L.Rc76IL=6V4F(AY]^C#+#d/PNUc]WEfT^?J/_f
XZQA?G/X;g?.NJa9<g:1IA?R.H58#6:^P1RJ:=[B[[E</,(\:SN)4fUYEeG#6=>R
#PV<]35J&2NG\#GE-,TX#\RK/e&[B5LF[.RUUIc3cL?_.I7[75AMBe5XUS+AAT+_
B?>X7-R+:ZCOJ<YI)Ja\.).3\,):VFVGGfXJMZ35>83[Z+8O;#(Sb\TM?EM4MKH\
PDB8Ac7SERCC;88bS>f7^eEO#JA&V2d+;:GV\+OM<66+a@_=,:BTNG4.LN[D2&Yc
f@7O@VOUVD-geQ@XG2H+Q8,Xd^I0LT=+?22[=-?JY#d1fSQEQM]4Vb)86IN/e1dI
G(.^I?.BRQ=WP>GD5Z0;1YMOH^RE@5d-:ebB_D_Te@9<MO4eU56T8gIB._EG@UH+
[;G,b,5\_Q+KBc,<52._C6]R1Ub@=gDE#,\&a2TCW@I(bG:gX:A#U4HMg;=5F/M4
L^F[F5H].)Xbe->N+[->LVZ3b]QU\L.-@3f(N&760:)7^P\3,E2(g()^JCg,D#C:
CU.dW>5Q\Z+U?)>/@b:_BOf8f0W<c=X<0F.b-WFRS\VBSc=2[b-0^Gg-QTW8SWIL
.YL1U_IdcfFD]b148X;_BJDNMcRU&I_5KVAB>g_QBd&_5&>QW]g,\9cd63;=d-YY
Dg,KFR?\W-AV2S)/RCS3aCd^7V\H9/(aAd)P66b;LCA8/)?VJWOB@e-17A(UC6ED
QL[W7-3XVG^S#4Ke5)(9;<RO@,UY;5cB4Da;3Z]FO5VTR.@;\Z>6Ng9WU0R@>>4Q
4YWDfYWW,-MfOLafFIY63(=1Hb@CXXG,d/6>JAg)c1)70.a0,dA-e/c3U>#?>f<\
G1g>X+:-dd7PU9@SK??KDb-.eScA+ALdG2V\<HJT^P^./6\Gfg2#25]U<.80DNWD
7+d0=1B-SFdc4:7Q0TW#HJ)fcITLLAAb<&YbKce0:[U.7/8W.,d[IPU=6]80.c6I
#5#[JNN:MXR@(K>B)[6#D)>F920361,aSMMXZUMJ-R;HXe[d)/fZHWMb&C1T:PB-
3fGeQ;^^Of.21IYG2SfN8g[B/N?AeDOTc^H,FcGZOICH(G<A+Ue^aI^9AE)3a(<a
KK3=\C(b@=(N_:&Z=MVT/YMSB^^e8I(T0I,S0@5#V)LF1Ad=g5eeFKFGH_1D^//a
V,c0Z;d)B##E5@XS1U0Ra-,&AO]GJ1[KIDgSVgE9^L@XR1O+F5e=A^6,4OZG;L27
U8CKVH<(OHE-VR\(39-DaSU4+^.1NBPH?ACKC9B5W9e)T1U)E70QN,UBgM_?b_@]
64NH>#@8>c4UG3Z]g#e0]/7>\/BQdLaMDTI/A9YMbK#=QA9.=0;YSRH)?>08da;S
GW-)ccbd+W[[E_+,/D^63Ad3)eW^7Q[1]SR7@e&\]1J&:3BD(;D@e:6ER>+C9&PM
4.Z9@69(L;d2BAUeaRXSKEF=e<CJ51[L<aELT?5TEWVUgM6-V6JTR2aT.E5K&6]f
QXQ5KgeO>([>^&;#M&P:BgB?>V:/G\YJN03caF3CdDEA1HS:^I-X[D.;0;IfJZC7
VO-0fU6#Z:ST3C(-YG;LU&,PF/;B>]EY:2c]WL0+_H1KIV2+DEF3.^M1+FNH_+5_
7E0__1,Ub3607[;I\OU;<>ZZR4(4N0A9NN3,5eU[H]H74?UXX1c).V_K@AVY4TXZ
;E](]c6MCd\gMJAc5aPLKZD>NbG<7@SSd>;J+#abV/aNA4QKOF4[<]CEJE[a#/RD
DcZ[a]5H)O,E9[A(Z=_a7?NS.66Ac4@Cf1C+;(5,?TG:0M^VU?8aEFB4LX)b=SMg
,_fPf9,X[_V3@4g=4XYgV_B8Z[8baD-a&C;>?cPV(2S..2T:P#;,[XJb\#_8.-+2
5D?g3)c>f3<PZ1_NW^G9Z0O:-=O,(GBPM((cO0:H4]_1IZ=,Q+JST<[,1S0-7Y.7
ZQ?R^aH7PS^;UCHF@>\A<Tf,P5-d?\,;&1JZ0&D5--S?,Q[7>]<d@][8.4CSf/I;
&1&WV0N+OXJegg#N4DO5^f].,?Y87;P\ITV_I<LWI<B\g(BLH9DN5>,18ZfQ1QG#
EW<OYP3H]Y78db3F3.\3b=afEaBc?:]2301Nd<3_GeT-ZQB9AW;8WIKLcZf^GE>,
3dUgC:@_\He)6E9bWF+#L.T76MQB&K28AW8N_KNX8b9RAXK_AM5HLJ;VMfP]c]gS
^]2V4Od(8d>S<)HSf0FQ=S:AEb4-gXXf6[YF1J[F@d.)4Y;G^EKH_O4b#<M^^@L4
]8RHMY//]I=g8JB3MZDfG^+0\4@,P(-a=12.^QQUU^^SDbDg=J<^[Z#=&2SQf71#
K4JCYP+KQPWV\U2-MS0#HM86Y8?AG9(cA&+/PX]I.3NHd+LM/:1]4QCV4?cQ-K+A
O7XA-c:-@YgHTD8a/CR_5?^LS5[]Y-4GE&UUF<[)IHdM1>8R7/8LM-5<A+T\GR?F
b9ELO8#>f\I/QIa[JH9^E,54;9\R?I/g(3(G14VLKYg,?AF?3SF9Yg-dD3:Mbd.W
[B>gJ/d=__L81cQ5HafY0^T(U[8]6@e0VUAP]R16BAZZcN)\5F,K6U1Ya8=5eO>7
_3+3ZV;XBGNI;NcKP>78aB^TK2?QLD7Q,UJ/E6_>PXX2IX^aeFb075LY;]fDD+[6
3\ReLJ@95gKgIMN<3dgROc,bPee)T>dcfc?agDRH<)O?;?S^7I)7S>aQd/]PQ&-0
B>>^9D]c=\1^SV0UgGB-eEF#MDQC)HK_2K7\KN@:+gY-[4^XJGY,g2>F@8@ccL<S
.JKL;Z^K(Q6508XBdVWA]7Q=W894=8QNT44UXD:#E2G6\UE<+gB.E/#ED@1-fO-V
9PPVb:]@CU0U_5aQ7)VEaN:<1[g9PQ3<V2D#(fW5Y?3YbLN4W1P#d/H7T@JDP12[
f2H&b;+W_G.KVO1T6;Z?7U1FeUU#VRa5XN\>M5+,[SCD@R.F;DUf?13?HcOSV(LK
P28.&:J:KI:+A_P[X_M;:EL:3Za=>dR1UPI_(PUXZ#fTHLO;//CQa1ALS7?),GBJ
DNIZLH0@G.@YXET7-=1V+aE5,bB.OHadMH[D>g[#D[QE1^C1-@<W?<]]c(?G+#Vf
A&)Y[31Y^-&ZXHXJ57]X,G&7CJI.3R@AALO,;XaDbSb#)6..-@VI\CLTP+^?N],T
-G;06=,0E=,KQ89V7MJb7C[N[)YAN\RS6?[[YS,-MJ7c^9Y5<U1F(__8+:,=(PH(
^[1JPAIbQVgL0Pc3(bfL9ZQ\([I1@[#\E1@TWWQW]H?K>AB6@B<2fK@]#C&/_)WD
TN=0T+E6I3>A0G#&SX?b]:b9HF;cWR)J,=,;YdGI#D<F8OLP(H0S?[e;=?,E+N5D
+Pf#/,c7U)(-^3FKAOe,8fIX8&8@E^X:+-)ec9)[X&+7(7Y.QN#CWa:ZBKO2<T0G
@6(eD>a1g#=<M[ZNaK3=T55^YC8d8@4;=F3?AO=9P=Dc,V\5&P4W8-ON/L[-e<XI
eW0G.c]d4]<KgLSdf-R0.fI(HQAFTOW5+UCJYXNV]0&L3,gfCI1MNCXc<09^QH];
H9C:3f;<E:I]N:4X#_/W90>3.F]c?QE;&f@X0e4PEVfP:T(PfTBA<I-#QXRX+#3T
1OUYGg8<1GH-R:=]>MPTZ-F,F:UJ\,EI&BHD2:B>1XS2ZTUcE+2<552TaDW3d#G2
PO\@QNMQb0(aPNgXCI=MIc_[U)KNeIH0KJ-2FW;g923W#79F2W&=3AWb[4)OAQVA
1G@+XBN#@D9V.d3QI.JLJ@<PSb7:=ceT=2\9g0e6VfJI_Bc\9GTCW,[_3-?C#T#/
4@?Q>WH7Wad#5&UdK^;M)S#ed#fB)^dJ/L]&,,B_=cDV>UAFKZ-_YS;eA>3A)]B>
.;5V&OLg3-).T?4VMDF.)-M49#ZdZ-Y_3W0^@L,S_;<#fT?]J,<@11g+R)=C5)=R
ZWY^JL=R7L)KC4Z&779GJU8^dHPVH4C@E[?+S5(Zf=3bK&3e8^?;>g39UX?MNL,\
N2<4:VPF:dHbbH-ObbR@;26]3b3PN4NHKJ7^_ZM//V(@+:8AB#Bd<+V4U=HMcf20
c/5T;B/c-D&g223WU1FNTYB<A7H\\D)6AM3RPg/O6_e_.\,,U<MNaGL@g[T[2(AR
1eD2-;->J_b)HB&Xf6@@;XQ[W]>9SXD(97.7?I]2J\6APe8=a\9f;W/3K[3CRP+X
c>]cP/IZ@I3\K,-TUIAPBM2PX;P>-B02O8=<T.A=/QSE0fP?gO-(.IN:PQ7<Yb.D
Ab;ZXK@RA99A:cc^KJT>@2eXLS[JDQcFVMPL)370#2\N2F50;]ffKZ>N2Aa_>-=U
9@ULP)5?bFXJ<S\g\QJ.QTSaXaUbSfEb#W?=9g4e@QRbCPgcfBGRAF2g2PU<U#I<
2e=S.K,794VZ_HYYEWcOZ)=K+g14dfVc^BAU(cc67+=A+LC2g^QI<J]M?A]HceCA
Ib03_e[M#1#Z+#B54U6+.Yb.R9\1c0JcWRZ)d5Tb:VYLJf_-P(9/>H0ZISIKFRD4
-=7BcD2,L(bV6[^H_5[-EYD=Z2dTUb--[:=F[2S^?N97(+eGXE0V_F\\-M21&DJR
OB_L[gS>2D[XB0Aa_4?.5-P.>(_A<)CL.\RG\NcPB=Gb_2;IQJ<b@]6E_>BS1/YO
g]B\_6I,V6?d2b:ZgJ9P1-I3eZV8^DK5E,c7=52ZaRDW83H/Za:4U_?\+@J>TcaO
)L?#<7+M/Lg:dF8Jc5DF8c6C,+4HfRPf#b+8X3M]Q/S.1a?0a<E7776#U<V8N,T3
OWE,:DOR^PVE,EQHg?\=,:A@d#XM@32/BDH3OEW]83M&Lc8bZN1>f8Q5dTKU/G4+
Q,Y3EV9EF4A>WfVMQS_<+SRfH1Y[G:/2aH7OIaeEMCa#dG#00H2T[T8^-aRd-Ve(
P95H8N\DA@0#<0?c<QR4WP\ZKe-Vf,X&\AR8a1SX-&c+g#CF\75]?5g#ZXMfZ8(\
4()]Hef2fH_e_T=APPgY;E8MS58;,bNSRYRJ=?QCP@cgQFGR@N.\K1+)&K2J<<GA
K<:JB@S>@OZGP)fGPI;T5da5GVFS:E<1g9.X=cA.eWTM40EJ+Z?YDY[[NKR^TGJ&
FV6cA]DMP@=4;RUdZ]/Ua6_GSc;0X<(GK/fZOK;)X\U2K6PKOP]c5/Y)GfOH]3g4
CCIGa]M7:g=\0fQ,8IO?X@C-Z9IF,bGJ47KO]eJgJ-B7>W2/+2;,TO<\GFAT=-U#
TE#01bT)Wb6aI7(R@UCP1/KFFO=Y6\cSMQVS+KB5H3#8H5=&JMJT7P2NSJ;#RKR/
1AZ21XaU0Z6BW)0O0PFbQVP:OF#OR0L,6B\F37:#BV-2S\+--SBWG(;@6V552T=0
OU^[.fKJH>=.fCZF?2TSB>H;L4[N6aVP<:ES=_9Cc92W46HPIUTOJ#GUZg;&fUM(
0)78)>4=#dd:.f9CU1V<P88,^fVfLBRNM_[4bZ9L0QL>CD6,)??G;6=4(_&S,D@3
ePbO5^[+;NGc:cL0A12H67,V(2,V:7M)G9e/>\E=>XLCA0BUO&GGI=JV@P4A22D9
XNdS<A[MA#Z>@PeTLXLd>8#,Y5FN^L\N7\NM+F#W-D9Y\9f@G:C;9cD]DWT]WfDF
56]GWWbTaB>28PI7.^a;=KOHOMOEZ>Jd:A3][O0\3ZgbF0-c5=BDR52BD7ISTc#A
Jc;&@@3SH#,b/PO6^X.MK?H7N[#BO2,QV7/.\>X[QYDG++IIf3SLR@)YL_.3+?6K
4Z9?6/U(39N+BI+Z#T6W(W@]WCL2]3(b674VK?aO+>-7g:.5-Q8:D:=G[[,5cMb&
c==5Ra(@)W]P?2_=1SPeTQQf<S65YQE?[^+7:[@B,@Y<AcF2b;e:MC^>VY5S]0_+
]5Q_-<fFJEI87W76ZJ326VXPC\5B(WKA9^:YR3dK,NL25[bdb>&?\LY(W[<JZM@J
MZ^IK4IC-MeRK7=SNCF5-X5#TZP@c+Y&@7ZJV4NR3Q(O5PS5V.>.=V7>T99)cO5V
7X(d\ED,T<-H(IFG76S.?+7C(</<>GR1;^=ZgPJIWce>6KC@/:3SC0?N.5LF6.IE
NA00+N\JM=4#g3E2^A6:7T1FFX(TEZ@d)&2[F3cZU>IeG8;#g^B[][,:@O()4&=^
DO4?A#N&?8N.X59+(VII<9FFXM:827Wa#KAF?A8<dO<D@_</T=-XFTI+7\>X;f1I
[Y?TWO]#d]8#&=6DG;7/K]9NBfg@@62c9_ce-:f]CBE#+@6#OW/_P66Me=eG(-[<
@J2]MZ]TCf>g_J-Yc2e+Ba;;7VfcfWaYe\gJ,X4+COIJ4)EOQF8U-_d?D@4[Le\:
4\E]CU:4<T2Y93SE:+_OES,)_.LI?DR)4L]DR/M)HBFUP1S+[-1P]f8DL8F?J[E,
C2/-A[6]2T8M80VJASbbEFee9D6K_Q&8T78SPaH?6F6\S,B:15A@0e#?ZBgJ-8OZ
(X>BW3=6(7\8&Q:4ZR:2&FcDG6WKPL.gC89NNK\U603a>[7][=J@aC1G#RQ4GeI]
R\WP=.@F#UK5&P-9UCU(g+M>#a).LDdd&dZ2T;9L&NLR@BTHb+07471;c:cD;+L[
<&DYAM#S^B5I2\KFX<OeZ(:BNBVQL:/2VSQ^g_H_ZL#RW2\Z(>0>,6><He^Ofc:f
-2c]82&E__&>Og^87I:P\8]8I#LF7@FUW?BS6],(N3IPGd9&bT7^:,.?4=JcZLH@
XF_Ea#?=0OL5ZR\E?-D.1<237OO3FYL=^,N[KE_VfE9R?e0^<D7DB-Pc963Y&Vc&
a6f.J&GU#9+YJ/A<6YD]]af;9&0U.@^[1IJ[YT&AQV8_bHSJ(9fFC-0^EU\Y?O&S
HKcKZ<:AJ5VI8Z0<4(JE];6JT.[f\=JZgdJOcX@A_=?=W-X8J<Q[E,Ef9]7N1YQ6
8?&)RXTBRfH-Zg#_D)Y^:)Na=..\eNQ>J]O)8W#CGJ<WU]\.A]W[>#F-\Ag-^O0M
Q?K5ID^[5<F;PD(V.<AGJ\(+H6Z,_(F7g[F5e+<R^>3b?8EN/CK,gfDdKOAQ^VdL
9E+=J+U02-F5BE/#Z;Q,JaNY7DfbgNU>_8<<1(G@9-[4ZBe,O5<cYP^8(/We#Aa7
6.W16_WF>4&-34+TV8a)fbgT);9dcf@,AANd_c;AY45TSE(W,b_JRDZB)V@CZ-dg
5b/Jbg(R+c:HS)CW[g^E#-H9JP^A@]4Z0EF.W-RM)P:b4G99YWDBQ<,FZ([Z#IF8
;8XF6):(.X3&0<aIJ\A,E7Z[Z[f/TUD)_<63b4Uc1[a1\\eZ\;7)U7K0,X\75=W^
f[/DSO/cF<8eOUb&K7Q=@,>#>4WdK_32N,;8_aed8dKG-8;^(U9),0@JB67DJTHI
N,RLYM;O[QIWBW]D_DVe>A&M9A@[TW2&LYH)IQS5(-(D)V\_?&]52NfJR/e4ZW3K
=#1[KI#d9EA&4Y@0HY81B)?2GB>XSc3EJIUA(d=.XI.0,-P&;OHUdWX;b7509MEN
?I,#^EX;9Nd]).TF-WI).3G8VC8VgZ2Fa=WGeF(Y0S#5ZD-c:gS_\U,GTbI?Cd@4
3/LgG^5LdFXH]1[T,&Nba_GEL0@Hb:=_#6?Q\5XaQ8]8?R6.cc]\9EZ(X_c>)&;C
f2K]],d@6W(>^(J:.BPQ?A8@gFaZeX5;5R2=QX<dC=G+>K1O@L@5BP8;,VL+P\g6
T6g&5+X43@da(K0>[0]CN;?HV<_N#I]4[XGRgA+ODLMY/YfN/^YA[[,63;@..Ud:
^5b8.+?Ce9C.P6_7b19<EAb?OLA4,ZZJI[O_6fKd<eA;B@gBTRUCTW,Y&<c?A]?c
d#cN3Jf;.<B03F+K(RH4f,94JF=bK?Wa.\5W7WCg71-HfZB(LWF2\45)VE).3-[Y
)BLd1WO.D;N9J\L7C:SLNfbgJUeU/#NI1SRALA-P2<7AS]aD;V,g1Y=Qg0\HGBZM
GW]1/aIfJ\>8.WS)V0^b)TU>B4/.<^bU^L-;OOR:1^AE3<7S/R&f/W(AC#3++?6:
T3D<@@4bEYg=Q:Q3[QW>+f[bT1DUa(P?Tg4GK>[,9T=6W^+G=?+_OS2/4E0L94&>
DS]S\/)POWde=FeOHL69&K:,WeQ#;:^/<-)V(@VTEgLEB1@<Q-:?NEV717HYcA)9
)Y)+A0][N9FEC&/ZLVOK7CD6GYg7gX9?T0X87^_L?C<Y_H/,QDS#KK:6X=Vf8f]M
,(UO@_-ZbXMSSSFa>b[:H^d_Vb08\XT9L)><01B0Y/Ud@+e#1P3A.TDLg_Nb4K<0
[\_Z4DdW.f\(?A]F\K)Y<LDK/?@<BGad66;)^J6.D,4g.-MA4BNO+0C)MM&DbSGC
a2G#5bTCb1P.D+(7G3BKW(4466TOU?REb>>T;Za^@=2)P3-(g/a0ZPLJ>eR<</<@
]_dQZ.^9M\/Qb([[2,=50,>FeH6bH+;6f/gV2+c-c,X^Q7G5:3./6HV0(X9=+>,<
7K1NT8\Hc^<e.&1UVC5M]:fNSfc<Fd_aA:dSFEV-\Z.>5.aCfC0+_5c^Y52+U:=d
3\a_6[^HWgKA0Wf<@9;7G(?^+4D8c>ZTEVf:+6#&=6U>N-<Oa,^PXcP_?3gLI6AX
d]g[Z#Q[5PY[K=ZaPag.E]?KM_^VXf6S[O,+f)gOT1C]\DXO.\,0C#g,BFX-N\U,
=S#SeX569WUX)L<OS9_\S?&F@;95/[SZ80N<DO97@cc53CCHO]NV_4I6>X;/c/KF
(^Y[F<ZKaDIHAY^6PcJ.=-5-O6E\7W^_[O-a<SYEF-8[BD<H<,^D7;PN0eKGP5_1
:SafFa-:DIPF+>,>0CE1HB4cd:K[DUI]&_O-/YMFe2562eFCE7[b7)LOd+dg>N^&
U;]TI-TB;X?-dUX]\<?/I^H>C4U?TL/\/>--<M+RD+;e?_@?X_3d&\RccBBJ(R1b
U8+S9d70Xa?5d@:=e1IRIC)(?)L#6)6Dd52eUeV>gN\MJ\-\ZL:IOO>JL88>eS?:
RW0#4XSD[X-Da<B.0fH4(b7@7\&PYf/TQ9-[<7>)6STSV@4P10=4\9G,CB/-G,;T
:dSUbIQEJUJ_)G/GQ#f8OA:5d;.,eCG/GaS(E9a5D5f&e(=[B22JL9a+8.VddK@L
R:P2@LP925&+FgRce9()+99eD9Sb#HcWF>R]Yc<5E&)^KEQRU^^(GFe..da5KWO9
_K#DcHe.-]<_a>[20\IZ.\_:A[CaV65/49WX\1UMG6F,[f)>T,,\YfB>^>FO@QO/
G<0ISgc0fLEN9cC094B^6<EAJAED:Z+L/bHd6+c2[T[HC_RR(IR6gD^V#gOd2CNc
H1.cW;cCY2R\1R)535O^:\Q)d3T:IF&eO)DaEAQ4I:QLE(T+We8P2ffR&dFJPIRG
ecBL::@A:<+I8eV2D-fO-9)W##:1^MfTS?CRgR10<\OTf[ACba3-F0?:#N3/Z9O;
f+A]@1\NaMT)#[?:c&?S3EUH28/<RD?^VOG+OBW^Q#Yb0gY.VFKf/C@<Ce9_/[_f
[1?:)7V6YdI,eHET6W+Be33+0#C8b0WX:f;<c&RU/C>\_@<+LOa>1O9.@1Z#11I2
_ON+U1D4+FJ=/\?-A9b)+#@a3[)e/;^D]K4F/ga_KTBN7,&^A4@<.f,HW0#<)9NR
S86H>VOebJ5#TOdAeKD^7^@W.7g6W4&Y)C&?ONB>9^&.FS78VBR_L#Z-32&D7792
JGEI__WU+O1Q=QXeeLgEVVJ(A&C;DQ/^B3#0bEN^4VJMRYK&-J,&C@++)3d^9Q?I
22\Ya)L04_D2&,2>+Q]aIQ#b381dOVO+G>M,=F&a:0(_,1N2,VHFV&4#5YSN1GO>
Q[BcEU<&K#LfPb@[<#f&0;2F[fKF@TF[/fOTK3D=0B\gP=KF\17#R>D)MG5:CRXK
4)JV0.J:]a^];F8IcNe?0HS?+>R^QPS[d#.Ob&I1Y^ABD#BM)XBU8JM>0D\P(0b[
>T-VA5)KL#?\fO)QVW5:KN]BM;Gc_JRRa7f21dcK>UP^R1fI4[6?a66,WO6Nb_)[
OMcWYD[Y4H#3eYTHa[;7OC#g_a>Tf.7O>Y+23RRdYS:DS#\(9TOT&.3aJbbYcd&9
M-:Z6\C9#U,#Rg#<a]7:&084dOb^6N9FMD71VZ<5ZEc_Dc\7@]TETQ)K)gR)Z,1e
)M0e/K6+J^PL@4BU-feHFNL:S&,=+5.=1AFE@IUS:>F0;+\XK0+FYXEORQ^Q4.CD
FO04LO-1FB]4a.bMR###M#1H/;(LcLF8R@/VIPRY8e<A90]=Ia)YFaW#\@#D&J/W
a\8H7Q<\FcLU&J>#cM2DT)IPHU=;/._911W<6NLWgg5.R<Hb6a@0:YW>3.P#Q,ag
0TMC>T&:,:;FM&^JfJY^H;D77UKP1H\+[QJOa0R&&SGWQ/TBXTb#)b(V0JPM1&ML
OVGV&bG)VR&>EdX:<BI3bX&),@8-=O,JKbf7JOc(\&J73Lc/3I#d5^D?U,V[OKY4
1@P4aJ-WZeVa=17g#LeK;;+M_\HN&gOB,dQ62>.=>^<KA&6b4/IU.DI_X/A7bd#&
_)IM>2&_SJG;_AWIWdM8+Y05YSIaTE+19M3[MQMG_KMW_\E&H-cO]c:>B<NK:cIN
,/71dD40IE?J[bc,8bFK^4]Y8;5S/6Gc)PH>ZRc@1>fGND;FUb)/XW4C9S/g_=[1
#g>;=b7XYV4f<REK4(T.7c(EP5L2VT@b[TL4H8MSRG@=(AN,eU[^f5+6&\Na,?YJ
Z3T@:K/U+dMO.QT6b0dc[eb_RAc?WL5.c43L/e;BPTHHPAZ&O+cZK&9EA>W2AH7^
fB(K?T^_Z]ReJg35g[Ag/SO#)49&>NRMKf6e;^JPL)aZQbAD)C0=&9,5KQcg:]IR
0\K#WYKXXCOYW_+Z_KO@:9E=SH]NW85F29HFLKg^P:d7ORDZ,Ec@dYW2]:cS^+PB
,J1\H#be00?Pe[UL0Y_cfCeaO91D0DPIB3=HUBQB@]\d3Xc.C+E/aYH_[7>[KTH6
C2P2Md<EAQ_P>2X.9(3+MGZ6H,M4+ZK5U=(T+,:gb7B6/,T;>SK/O-6#RBZDI0LW
PB:<)-FC6(,+FggE\__-@:YQ,2(bD<E,e#QU19FVPS:WMVI5L#]@KW)bJ4dAb<=<
J_,e?XUHbAKQAHbEeIG>7FLL/R(a\2RMX;4O7VU?UQ6[FJYY>e--JeI(0CO0B_?[
2\0QN2#;A#N#[fC9.\>eD)P(fA/V,aMLB/G2MLbP27CA;:1Zc9LKU8V\(]CW/c4V
9<66c;#AWabC_f39FC4P)A]dFS:^U]bAUgWSC9dC1F&QD>Da4_;4GQ54;NJ;?@YA
feLM[_V)GQ]:O6YU3BH^^Wg9RXP?EZ7W+a>7XZd\^2Q=a967MYVAI22dZc=gTIKU
PW_gH:.LTCGeW4M9WM=4@D^PH]FJXc5&^CHTJ;NH8-8f4?33>?:C_@LcETEU_4db
E9[Z&F/HVVA/;U?\3Y3H76>P^)(NdaFL8>U21\Zg4EXYBe(D/TRe(6>\@??<\H&-
O^dd-DN-QWe-?R<,=:@((fMJfJ>d1CF/)f^<KX-.#)A7Y7aH=99+Q2bWSN]O7>;D
+dMJO_J:e#P(N5_d4PLKV7Q)R#:3(W9MP0<I?5F:#Bc=gd5L?da9e(aQEBDUBDKY
YJ)e@5F86JMJ1cB==RS@LIbJY6EcOC3T;02)gO65<cHg_OF8/N/\CL45V-PR7b8Q
2-B/0CedQ)X8?C4A59]]UE-0.<R=XRPMe;/(^OG03X3WCbM,]FD[+].KH0@UH6S3
US<+(_DD:(=(+Bg#+MA^BTcDL:Dg?^7U[MYIV^2LO?D#-A7;A8BTLeY>@&@DN3U,
T;_ZYf>-F4BM4-=cVRNCE;Rc_X6c29^dYVY\\W[Eg2W,OIA-@IWfSF68D/23D6b8
5PM+BA@/./N+eJBJ6BSW]N<IbKMVPE<C=)>)Y[L&]g?13C-2>d&I8D;c;Y=?cNAK
QL:2N(N/_]R)GWK]8<-(1/&/3/+AV+ce&c&TC2]fKaaV[,B>0G2N]d-E#QafYWL3
V,T4a3,D.6A)>_BA#MD91[E+2_S?>\=SNYA@H,Oc1>=0L(8Fad8>AKB+fRX37@b;
;?(d2E84-2@-+.A9(1&SSG;b<I+b[83O[QB732ag-ZT?F<4)[<6)62)4J4,cEA_M
\#O.;38#37S/Be<KX;V,BdWNN&[2PaR:>@,JEKOV/2+P^EWJY&.LV0:Oe4Pb)R[g
-@f,<C(GYCU?fPW[&DJeJ[E?dT894dSQUF:P/OT[)B7M;GHY:Q;d@AX]+[;G+=;?
\Re;<;Pb]d.H&5)XJcMFb4/0QU(85Z3-0RI_BdX4O?_T4.R^&Qa#1W,=BdH_[EJA
@UV^:Kf_2O@4PH&?TPWD7GKSONT-<@FRbI+X5?&cVKg[A@/YF[c@2TQBeZ.>Xg0]
MK_gdMWP]:1_(@D<OQ.?3(T+S_G\MECYO?-WUeHD\R81(e>X2a6.]LQ9HPGd7+>A
9N20#a8[HX&dcG#T(L)#H&ff/Ab;ff/F/f9fF)##W\D2.E4;,_DV3T&KG3FK];<b
KG])81;^72MI^#71D.#N1Db/:GCf32WAa4EOZR&>.\MZ^(VaRY,98/EMCCgC.GRB
,16cRF:_L3Y)UP>Md]bLEJK<:WK#PU1_fR6JZ5fd.@Cb,U8;3Q4>UL8]OP#J7SNN
59@Vf]#GDS4>>K98FT93F[<f_=\[)?U;:(:,5-BZf#E^O(_+<ee9aZbOLY]fINgM
FY[@cJ=Y(cI3O1/;QN,D)Y@85VF5PJEcDA8RRGEJ6QZXPHEDNBN358JMVADDa=Td
)H?D<3P/BE1CG0VR#R@#G3CH20?85<,SS_+0,Q\\aKH5FF3cV0X<2#9B1dU(Q&;Z
EJ6(:S3#,3a[OdXFF1>-3b[eCfbWM9gQ12JJ(b=;dZRC#S)6c2MS@QJ36X@<VT..
;/&;WWUMKWWO>b)R]VCQ-4/SY,2+#KBO:<^ZL^Q144KA>(;HGT=)dIc=;SU(V2JW
YC8H0JQW\L<bbFG(R]#PA(g&@6,P[LTD?2aD>N,#W?_g&PC5NWQgB)7>BZO=C?X:
aKJDF5[Ec+7_J(7b@RSGW0AE7gdFG0fdO6@Cb8&/5ePTN6Gg8+GJ0#Ag/Q_,Me;)
/HWbI_b_?K/a-=f:cGO<UE@KXV=F<1?FDN&=c9161J.(L-F;25M?VX7O?+4&/Q\>
Ob=B@P8K?B]VMd/;LFNE34b\YWD.5_WF3T=B2g/+WDQ=&,H+\<VdHDMNK,?B(VUG
B?2(Z<gUV5(a=d<C5L6[g&0OD;T7ZA&dZ,f1Z0A6]+NQ:05,5G9HF^V)9>,^da];
3,/F-E)]d0@0/).2J&^TL8^EE_LEa=a&bJ[I&1\gWE)Le/?\a.^SO+F:;<._B?O#
\6Xc\#f<HL&8=0bW8b@&2LLb.X#>Q/&G0;U:@TVU2/SO<;5\WV_]<E_0-P@)@S^V
Y^5Q=YHY1Cg845&>XT=)>1#6,VZ,:I;b;[G;/X,-0;F(c+BHCYV65.=X2^A?f^/8
L(QN=T^.g,UJ291e\9b1WK;^YV8db9gf?D;0J4)R=,68.ZK:MHOg_48C,caeJ78^
,-WN=A7<2>ZHKHf2AO:eZaR,[@1+bV@e-cO>#R)<X->e4QDbAO4D?dBIgH1M-gYY
V/Y2_c;eI06W>YQA,e1OJBYBX,)KK(GN7QcKP7Q7G#_=B,KVaP&TdV7fLa;X/e:/
?]K^=+840?5DCHPc_UMA7O-=(F4>=-Xa^BPE@]agVS82G/V@7GH^641]UAMc>+7c
4KJ_7?#1R5E0+>FDK=)\/T5fHAg]-/.3VF,\YKBf-QA4M8N,2M#S@&8(#DHTLTTI
e;4JRRDV]0a3,dJ10#RTYR>+AC<0:ZCUOOS3W,JeP6GFNc:a@31ETPARUGWZY6O#
_XZG:0C4W=#3ef\G4;a&:c[2_5\I9?b4eT+3c+SLM=b2=+OCELE]R/+D\[.HHJg]
+-9fFbM]9/XVA>_O<DD#X[1Ge(U1PaEW?]ZV;=)bg.Q[YJBO&4.\SBT0FB(C]2^G
N3d-WNL+/+3_cC^Fg>PT^QDZTW/8\e080IJ+WRCfREWNAW1dO30>JQ=c/J/6Mf:H
B6P?^.T3O9Ug+Q-]H.E15O\a(->8b.S[;OG[.Vd-3Z_Z<.4RWK&bWBR2?b1@Q^SR
815<(>M::-DHbW?S--^g(@J1OUKG7g2U1HLM<KR@@YVYeYZF9CDF;d8V_I#.FC:-
1[Q7#&NaI6N\6:gNP39U/<]L+g\VE5Q):95QE65-BCK1eIWPRKRJ_=/eFY[02;TF
35SQD/E3+f\[O#AUc)/Ya#?J::]DP,cZ8?E.7YNM:PH)OHDf58(MLG2d+8L35[@X
a#b]b#.;)0.g-f-LMTfN2C9&=-O_aNT)7+V,Bd+aWd;N8(dP0HR),^+7#?B=0XS8
3<24]0SSbbP4&7F_WcdWWI.,853]BODG,eC)T1M4e#56_-7@6E]f5CAL(/X)^(FU
R6F-NRGH?f&c;47[a?4cLOHS4ZL_eY5/(2>B11F)KFR3IG<=e,dGB;>0g_O+IL?L
/aPKCN39Y5MEO&P0D/EG1f^N.VPUX\X]SIIJ2T?&._(RW,a-G^YMSS/K&HGYDA(;
;XB7KXgP3>ZFXWf\9M/F:<WH:;[UVR[cdZGeE\_3-fWV1J_949+ME#)ReAM8MU:9
(/M=^H[.QWOCd4P1QD)ZRa?5E^&]UMfO,RES0/\BPf@^B;3J:TYK@&.bUR+-T=A4
6W&:(^=[Z#=EKJBT0b8JBG2C=fb<LWSb_#U50(/e_KbE(Fa3+T4YFe_+Q]],#P@F
S]2PGd8D@LC@dVNbX:W^UTYJYI[SZ#]K-9X@<A)M,9J8/L76+DM?\HZ>WGYZ@ISd
ICG-g+7R)0#[.>RHK7.&R)I8RF5R#e[OfYfO4PA#UD=dWBd@QQc7(6]<.\EB4#a>
#9S</_caK93g-+8=DD++5NSY6gXOc3VW:W^=e0&ZB309A0<;=JcC?B:a[[9F.[#B
94C<?W/B-?W93];O=?ZE?bYC9(C7]K<6AS3)@/\<GSKe-3@8:0Z08?^f=G)U5g<T
QIC9_CeF^c24K_;=LGR[?/<EcaE+f-OKU4>UV^B2CT()X,8>L4DJ(;ff+K?X7R.>
a1B8(<S.1D2U>Z)d#A>D)Ag=8<[GLAM0E[CPf<+X:EY)V.R/VWY9[-P(]S7K\XJL
L)WfgMEK_?)-dYFU2W.ET-8[JgLfH,dF3:0dM(_\?L4O4[4W:[.;9<+<A+T<feJf
f+?A@,]>11ad\P_4S;2aE_>\PMPDTaA^81WY8EFMP0,PXU;4fTbJZ<E2a636C;Aa
Ya__(LQ=UJZ>F3(Y9e81S&cPfcScS(8-#?@M2#G]4S-U\XUA@[7UHYg=@X^[(:fQ
_0SA(66,FV/:[g8[W0@CIfI@P^<Ka?3O<#b)QZRMNd.R^Ue[[@&LY::57.PC8KR-
G+bN/]XJ/S7[cf]8I,X)BV^,N9(DD7DPZ)PXXJMO73PEY52T4/1MLLM)d[FfU30\
1=Ff90S_XbMUHJ2c2GA6,,0bLMe<M?DHQVZa]8.?C<&&.SPNKQWBaJ]Qf,=>K?Ve
[O5]I.Sc[W?JY[>FcdGg4dGZUCX]6\GGUU0X5EP?Lf_RVKcGZ_PV:Dde48K;@L&A
deH=63SL=WEO(K00P];)VLY\O?2PRHRRLA?8eN/H:&RM@T-J<)eP0gdf>X96,KQ&
9DD5@EPQ&O+F>](cIAN?.M:39[ER>bVFK\&Q-+#I[<8Y2H[<?a@]\IHF9+/#f;_c
+GS#+#P_.H?-Q&cSR4&efD]J;ZJQLd-g6NU@/C=V83<_&b&+0TDa\EZWWV5-AI9+
V+=(ANGSHX]#g(eT(TH<1634,7/H#_5?1CS-D?L<]UP/=Ydfb__f[?0-7#cg7<#D
,g(S^>4T##=aRAB=L)]\^P;J54U@Z<)M+Cf0a-SYSC.bc@8d.-&Z#3JY[(2]a_U(
X1+L)GaXT+EH1DO?YA?]N>K9Sa0eU#BgR.+a8NH+WbCUG<a.NB]J@g/a,9Xe7<e-
TZ,GK:SO]]fXE7V3?^&PcY.eC8^R(:].VO@Z&a9<\K-.gN\ILaMU1Z:7)MbYVcWK
&14UP0\Q;0Gd5M?;DNe@JCE:@C@3Bf\H5\,XI0@KT_<aV.?Q8P^8A(ULE/4F2SW5
.Q=A;>\(,7(7.P7;[K3XGY5S3R\CZdI3YbQP)[C>@_15/5X6@30a^<,,R2e&c6d]
_8\>L)03c(>Q1X[++U?[#3N2B6AU??ggb:f]f;L9:Q2Q3G<M>87JD(PB]aUYL.8G
CH,>5HH9XC8)8.b>6P&L1WV8dOGSDN(\?H/UF3Ad-Y-MagI@TQe>LB)f>7ggV.XV
0UNHc&D))Yf74J9K?ELO5#+2P+N>4g&>gN:(LF0=R9Tf(&+GQa\?Q_QUSUS5]da@
V4?bU)aa0+Sc?^0A9-@ET<EO9CdO(Cc;^=NIAS#dJR60.YT&B6LK/Z&49]O-dX]7
R28^3-[B7TRXAMbDf.=^GV^KNe91MCGX?aOGL?,?O^]/R+G^J6,(>(8<YgeV</1f
NX0&-OU0#F9C;;I#_aN:#NBO0F[J.YIX27@CK^.\V=RBZc7[ATSKf@O81-AF4WU7
eM(Z)1.+8WbE1,YSRbL/S5<PGW/)?7HA&=Z)^)^K\f6=R]7]Hf@eaR4S11fY4UX4
GO;^\UGRW))NSODWBT0c+1Vg7UG+3SJ18J3Ca<fNg]bUe:521L>R=I7/f1:_KT92
:4/9:KG2Y](BDgee#IY)#HMLEB]H.OX7<F0TQZ_:)\8]d)4<L>9V.[>BP-0Z-PPT
3Od7T5O\f#+.@IgE.ZZ=/aN3O_&Q&YC1aaff>NM97/T53ge25K@V1>U9YTL]@_GH
_20MgJa/E]H]fD64/E]JK-J+2M#EIDMEgWb[#CaC0#<9AeO0@)+5N#&F<7XYFYR@
P+b^+AO<0d97GZSV<0RPGH=IG\JD\5L4JL#6ICZR^6GaX1O4X./JE]>eKUKQYf:+
Dfc5-<O&387&gC2CNS9Y.?.OFWDV(SOV1ONXC_fQH3b6:@c=AASa[.c5N&GFTG^b
c&U@N\H&FA:0SL2_.?9RJcRFX,^3Z7\TAa[Z8231?b4R].S3R4VJ>=d0:R/ZLKB<
)g1-,,;\_,1DB]S5F<7G66F8a&R(:Kfc3eDeDU3Vf52(7@-X>J1FA<25L4&=cX]R
BTV)eBA;<<S#9:,)I#E?+12#GCP8b;DJ8E^]E^;8=54YY[aU#-c030W\0C)&SA+b
<GYUaPW609@/4W&d;HG/#EfR.)d_bUH8cO<efdM/9ZB;7R0D.XNKKJSSe=M,(N#X
NC0eAf,QR)(M7g8X2(FGGY9A(-Bbd9R^\&MV/E/=/)HP24PI,1ad?J[McY:K=0,\
1@,\gH_1_T/[_(c1?(bM:)FA/?aVKL/R=ScL=6DIB(EQO13fcPd1B]>V4e-NSKW:
G(S83HR;F0b24C8M[QA1E4,3:B[X8@SGA3Y8LH5Q+.FLH].1g4RJ,O6AeXKLabQ=
=_#GQaf+LH(DAL4L=dVXZ:Y8U\#QM_7M>EVY;?/P>>HC4C:1a7b:33>T^C2gK,LH
[=+>QW6U8NOIWg=Be-eK94[\R(^8V]??Q)84aWc1Db:;OGaK\B-6@^LeA][E#,^\
LN.d_ZQ]/QHD:1N<)6M=Y-cLcX)0B_=+=DHP3)[F4N@?,.f))4VaEc;,,U0+.]2G
Yc;/^/5Gd2T&4./ANHC.P<89?Y\?g9VTH390F^G]-@=9/(JR<KNFO5(1ETMW-(U;
.M?5Q>BD65@2:aNL@gNRZB821#:eI8@RP/RgIUR<RQ=,Z1L789gI#Sd=P-=8/BgI
4(fC^g[g5F<CZ038E_KF(Q=@W)OTM#BA<21PNJQJ(+g0J3(_).ER._V6#.Y1ANac
+C36Odb]GDU.=c9]G(FQO96@1&c:gEQ1X2IYBN#+_.#&,AVE._>.Z6X:?_:ea[Na
(@bB31:E=NXY>:^YA(4FEMIZ6,;#b>[D5QA+&bZF0J<+[X8/)#/V1)dXG,0&[.\9
BQXc\@:G^W31JBVJE&eU(QbBHG,KVGTe[X?871d;TDd3f]<]H7Y\=RQW;3AJZE+9
&\/D<>(JMIBe_W:PBBU.,=Le_@EQWd\<WF^d/R9TgBS4J7&S@+(G>TG+ET\Q)#_D
Q?XAeAaKe4HT0(fc,_7RJ=2deN;g<WW57KGd:^5JZUS;/3;ACe&@?/S#g@+KZ##(
&6<07F0b@dd44d]<X;EcR.X1IDHT@K63]&^/f?B>)PeP13-U,Q2@Ne0f]I,Sb-<@
@PSI#1PL/W4<Y(PJ6E[1]=?[XC+XbJ0J]+c#(Q4B69X[8@J1]S668186aQW^D_c#
.7DF#:T+W><Y(M21H)V<V\:NT=?Qa;;E9J&Z1<QbV;_YF+[#JQ?(>7PALG83R0(Q
AERc_\g84GdVV/VEM]I>L/V\Ya:_Tdb_MFJ^_7#OU>ASN0;KUC:R0XTW5S++64b0
;YEPd[[CMUC8T#Wd-g9MEAEfLe;@#;3X6T#OOLdA0RDg#g?AXd?D84Zc?)9NJK\M
:,\6-)Z>3O#WW;YUUV&.D7A&39+J/FYOQEbbF_+b4/O6<=fQfE&ASSe(:f9dDZD1
P9K3GTgg0>:<YcQXg6UfE#Y.ac65_+075^Y3:)18F-a5>ef3_X/]X7@CaU8:9G)?
Sd=1\<RTb.V62#+UYUR:2<W-:a14aBGYK>M13YL[PBD[,0)CLLC)BMdZ?@U9ZA@J
<;3eQROCX?X@K\MX3N;,/]Hd9A2=HPN@,\);)+;:Gf?&H,46IbZ>2#d#1Dg#MV+W
8bU\ZI3f+)ff#V@F4f-(=70F?a)UX_D;\]H1gZ>Nceb#W9JVVEbS(O.VT+XWF=LV
@K;,X[KITNc/;07eCPRYBdWI46V.K4a?RKHLZ(PJS7<#Y+2aS>d&#/bWT.(4=\f?
fV-S2b+[c<<8cG3<?/AHK:b#43^.<;>6-V5GPd/SFR3+UH_=WC7V4\TPZ0F,+(&M
[(N?&XcP?;Q<aQI_OGQ&HY[CcDAGeR-17R8gSbI40=@Q\)-#:7b-NZCJa<+0,WVZ
X^D_]AHAPL&A5Q2&f#S]]/ZE<ZX2@3]3CJ[_#10C<LT_.^dDb51e2F&5,A#FLL3@
,ST3BeXW@4#JT(2AeZ5;[S3G#H#XOZQ0fRR5?>#I.##^(?O8+F<[d#cK^GPe&[f-
QK(9gZg/G(d7@6N08=77.3SS.R;O>L0J1Y/)7I8C:5#QLd@/]@aPO8[]QQ/,TRC0
MGF8>@&+CCO7NE8XLNeW2c,3NLP>.9d6YPH4cZ_:B3e]T]a+Ug@E96_3P208/@bO
#;=\+.#5N.[8U/9&S5Mc,0BK:?M?+@Reg5fU=XUCP/&g5^gfbAEN]a>TTD=6LYDS
bY:,SHgKP40YT&/RN?M(C:.6#+2Q/bG,eQ,KF1DO-2^V_E]5?MCK)_C;P5T28)[3
FN(#S,HL=7g=^/812,=4]K?T;<.Qf6KXJ8Z&/cfV?[/59>gH<TJK]\NfC)[_6J4Z
_E4EQ[IOY7_+6#]7#;:>V^a[)7C7M>5a1M7b/5-N;+AOO@]6MHGaG-51gdK1<=)-
AAHS,Y(QTf5?H0^bbWHYe+4f2GA#E55L8-+(M5XB[Be[SCaG&I2[J^2@4]:ME3)4
IDFd]P@K0>-.6>&:aL2g1U.>BFUWAQ/VX-8R#-^5c(#5>Vg[;:^]E/BANR[d?YdH
9(=H<?BDPYIY(.MY2([,KZTVM([^g0H9_/&9,-BMJUO2+6_26<K_0f=fa3)4F+9?
Z=\6L^gI]9&375H.\Me._E[:;ggT.H^WQ0O@8==.F=NI0+M\gQ1;SR,,,+#BLH7P
&CTP#U]2ALgce1B<67J(J0E5Dc5U,0>RNe_YQ=YG7S8aJ=;X/O;d)6C7:a-:H&=F
K7)N>68=ZC?(9)SY?gX4.N#/bH0GIDCf)]IW/?g&28)PUY,8AV1.DfO4/3X&g^Q5
#+839dNfTNOB9[Z<Q7+L1:eaXV5g9F?cD(18E>BJ&#dS/fR4MGa+bW0I8)Ae&6ab
6(>LK4C.4Y]4cKL.T=Q(CFT3OA^\Z2/dT6(RL-^Z?T#A9+H+NMNL5:P@1/W/)56;
E)_/LZgC,9<9dA:3,?#IQA3F/\BANNE0g,=Kd4b?1<=?,7)bX4KQC/;;#beOJ4>4
CD:K>\:eIeQ.5gLU@5N/@;XR9>@UJPHNa0:6XgU9SFEe:@V_+=(&21a;9F,0[Hd9
^a@51DI5/UB\3C>639(Zf6eOQ60&>d2V:O8#D><BeLQFT9WVZc<]Y-ga1\CV:\X&
e+W[OK;<K(KC7:;&Y-A1(PUW(0(BG0AKH6-A(-D59X?e-V:HZVY=eO#4C,#)b\R>
E^4P;DP.c]GU5gH7&00?:.bPU>c5AQTUW3S8AWPO+0.LX.&fOCDcbZ=#F@8O@3Y#
0YHY5d5;E)5#eYPQTB?5+,LUaK4J;MS7TI<B(?Q,B(,V9Y?2Gf#AS\^=)#2Y]_cP
d:/^@QEK]cB=;6EdNRT]ESD_HW,.HSf=Mf:gTDDL9-V5KN=#?:IJNLM2VgLTbG]d
0e3X_OIKgbN;MKD<C?6c?:/W]U955f(^PMbP8g^D>QG0]MBbBNCf0/TE.&-d^6F4
[5+M<eO4E:Lb;2;#/D=4<XPBfU62g0]61Nc\Y95C=b.K.+(:^KEI]ULY2McM)=/@
(ZPX,-87E22JSac<O>U^5YGLd\L;5CQ:B+](&8N^e1b/D41cUCQ];?<5e:SSe0<a
L5_LMRIS#CY]S>\GN3^OLBM5:XcU\D]0a^;,E8J;:d3H-[>MS5F9.ATSC_R.b.#?
4_4IH.O:39d1[<.A)@-Y(UTXQOLT(GT.>2/\X+DS\QT&Z=83DYS7U0(KKdL<2AJd
H)_O5B=Q]5_3&?KI(RK]W&TEFT\K<47.MY1/_TI.8\K+,9geeW=_J+@7+/U,cPD(
EI<8RXP27XAc)GL57F0<1B5A5__f;d3MYLU;1;>A^89.+dYff,e55.Q1P]a\>(_H
[2=+/]f]3I+ZO>7?Y?1Pbg09Gd(X-Z@[IE[(f@<;-U[\(S]_YL(U</55][g:Nd#f
E7NB\@_5[2,)+LOD3g9SG7RaPU&(:Gg::?&@4=D8;-JGLJ6&;A2C2__6B&AgX,7-
[c/WW&Q2.J40Qd2,DOW7,[gBdEWA\==ZTAfI5HTQ@BR,VX&b)M-gK3DSKf1WXK.)
:7b:1[5/C;5:OM:1_I3d=d.<&CX\Vd]DKdP9UgX&.,V;BgF]#[D+[7KECc<JL0WG
<<;OdP1TE-P,UMJf5>64-KU7CdB=fN6EG;@(S29B684J)_Kd]DF_-1(_6/gC-E-P
5UH5FaMLY>CUPB?R-a3O#N2<QI@A7,K3Q+2R1f.;_UcTY@JQPGK+YG3&1=?L=\(<
Z@^ND,YLX,D40cL\QJc<^4?(&L(+IdEg(dd99APa0(L=-Wc)IBb+f&>7EN7Kc:_f
^MEO#gcM^FEgG,/7df6+]b_,N;/](a-Y=6&_IOP\WW/<cR+F_),-#.K69a6=f4a_
a7]C1=&RGcW-KafObaOF8(<TEHM:e9&FcSbNf2_+MIeggM]6WHd14?^MT[(/7,X(
6YJ9VXcG^,;J4_(N-;<1c(NVA8_[:XLeF0N.6I-DJe=_B@B(;SKJN()._?(1?R;J
VcWYQ08F^(NZBb=A3DYUX&:.7M;LB#UWL,aF;=><F=^=8XYgWFKT0KTXfO,L,aDH
]f.e:P7;L,->QEIO>/C7J^50d3^RQ5Q4fF;-.c)PeNW&O5;3O@HD->+TPW?dB+D7
.G,\@(>&#4FK[[1G?GH\R]O98fVB.T>),>,O=BTWO\](S;A76fZ-M=&cJK8+#f<>
I[QX(C#??(KY@QO7eNN\+AA7.A-]e8)^<UR.Zg5\?P.\KORK/0//9M&f/cWTB+bU
=bR_Q+L_PAPdFfLZ#8<NB\RXa]d__X2O8>OK7TX)43N3:DFM5J2Pg73<L^L.CTIQ
JM:OF><V)\R1DRA.S]?=eY;+[H8:Ma4-6]a;>-gB\+QDSMZ>,4IV2Wea]MTL<VA1
>Z[>P5H5@Z4>#6OMF&5&=/g(gYD4d;.2/S?8YDeN/T0B9PC\ULf[/g[Fe<aELH>&
,7,M[:/<]8gEZ&f;B(a5Ude-,QE10J/bc66gTD<H5/LaI(]c#&f4=]aLLd9cKbb4
CG7IDeY_X]<VPL_ZaZ\dKa3LKf6Q,7[8dbBIcf\2BXO8g#e,P:^42(/-fdT-YSDR
R<4W<Q5gLH:A.E4f?S4]a(#E9G99#16&08a/f;7cD12ef@RMeV2HLeC^Da3Q)MDV
>geHTFXPdZAVPOLdSaQaW9?f/>dH(#X@X5+\aZ1J<>dTFGM4eg1/AXTR5R[7&,[f
c]DX=I^0@JWed24(H&-1_OEPb[:aYSH-+^F@Y[.HV&O9dW,&K,J\B;SM>5MUH]SO
Q>BRIHdD<P^^,60I._)E;5c/^5H)Gc9W(^W<TbNM[\8>G21RD)@GUa9\1a>4YHYL
ec,QW2VJaOdc_=bRcE\G;NUGcb-V2eJO+KM@aY-H+cFa-XDd263^QWP6;+)ONT88
K#@SP\8&FNP4@?F_-dOCSaF9EV45&T0-2R])D@]9CNd8_IE1H+=fRY&ZM4.^7<U<
Z+We(?[5],_XXCIO?WU#=bCcDIZ+GYYag,@d^^W0b:IL83]AN9dWLLN/dK1E/fD6
=Q;3XR^=&X?9Ha@74\_IC@B+-50DBc.DgbCNH=Y_a9;4LC2D6H7LGc+:d/Qd0R_A
GW\S-I_EdVQ<7\](LNMWD/<W[8OK3d,[LQDe.O/U]6C9\6H@_04P&[9=-NA3>PYL
,9gE_6B7T)e?8L)Bd>0U=O21@cT#CEc@0MZ<)OTeXaHF(=RHA#9#8gOM=T?TQ-[V
?S=1^9^2\QQX0BdL.>eD_IIJG+2B,;\-<b8J6DPGVed9)..?=D.a;QBAY>M\3B)Y
J^eINXIX361/dE5&TDKN=[,[P;QLA/fM8J_6+0)O\28.-DZHad=^T0aD?R1^NXR?
+e>@&9QV]A:K.9018\?HGHAYPA,UeI_=\EOB;JIV#a-R/-_LNeN&4T0f>=HY_-B1
VL9V5f7)AOFE:#6>\8fI5.)E^BXSMEX&Uc)Uc(J5M2.5;9]6Z@\2Dfe>90<O6ZbF
J;[>((0^c8a8Ja^f2[Y]Gg/M-cXMJ)PA>e,<Y,I-;>WLT4+\GO]NMZ97[[WG@)e-
-@7#2eN3W1[gaL-0Me@RI-RZ_@K+R7@.-g+@O4gWC4]2:@\Xb8&DM?;Q9NP5>Wf5
XD5BN9^7fFUd-C\b3Ff2QJ3#6CCD+P#&NGff=:C5=5V2P4;^1VS4MR.PB^.EW_R7
@HY0,S.]/X&+M3>#\f3d\g:ZLIO<cL^V8^23;cJ/C]E1QYTRH>.C&KXA6/MWNV6Y
+YA,TgQFSgMNQRP2U<fgM(2(VGU_(V15]JONKUA+JWSH<]d.FFg7DA6;::<9]9X9
CM-@<E-RDeGYW(&O,=P_a[HL=E&IA&C0bX<8K/P4Y9VbGeZg^_>]L22Y-)8dH:)=
R&30e>UNdeQ7Af29F(+L_VYZb/K^>\OMCecbV1+_@2PU.EIHE_^SR9.PdO;OL^dZ
8A;O4>(1/1::>).8Z2>R>3N6aQOAK?NTZ9WIWd>,7+9DJWIUWPY;@&=XMM3M9C:J
JHNGfP6#D[\6Q_TVKFMKc)>NI+<NbT<@769?KJDC^/GJ8E]bO>8:GL/8T#8<?)]C
GMf7:6#-PXb^M62U28?4dd&@bI+MYG,@K=<S/J>7fU:3#:3\If=(P/44a)0T/<O&
g@5=]?N/f4.SPY4aZ4V8U98Zc#C8:c?W[c>ZTaa^b)]SD&=P=,e7A:P:,92I9W?:
8@3g.P2.V5BP.\a)+[/SPKT9g]Mb^c<cKG(\D)?I1V=C9J#<+e/\-c(&)=,5a>=&
>eaDPZH]MR1ed5V[GEg,_1P=[c&E<Xdg>a=UA?>1I3dCa9U@7CEWV5UND6T(<D:A
Vg+U\<QP]TA2OTV:82Ec]2-dU7OW4[.AVcA\KC<CS=6(A7_0]Y<NR(XC=@B51]:Q
IOV7SQ>22XbYMFOHd?N2-IM(Rd2)AMT./:S/W.bKb<IJYVSeR7B6g-P#g;O,/PV^
HXK8ADNGe6+D\=#R6CeQSF(EdB]1\2HBLVN^S5>2]HM<Z@-Z.PFdHBICOec6C5VW
N2(#S,f9f5@4_S/KH:DY&W1VGNa>C:C<Z\&55S)M,<ZY6#OY5<:K;/.W3g9KZ2+S
O]9_,-&7cBNQBA5/2\[fPU7OZV9OCEX<=K.XVX104A8V_Z+L52G5D7D9ATRbb0.^
&Zge?:;Z?K4NA&^GOedF32]b)&SNZ8JG,I0W_#29G=GX8DQ=:a\P:DVSIX0F278d
^P^6eX[(cFJ]8966)F&De03HWf<WINL0E(bN-Gb(VRNOJYMgJAP?=/-ZQGdPSEN^
JK=.BCg97e8::Wf<a4HX6J]-].8efN3QMV\Eb_@,)J/;Gd.X>Z[J_(+;4AJg:eX[
EK;14_?QP&6aIG^9R5@[?cVIW[8bMU4aEf-5/EZQA2L3ADP#dAZ]@OF=[@0)@U?b
a16JZ:ULB)G79P:G=\b7\2RDZZTTI^+dF@Z,/dRdV]\^#YY5:.9+2+2ESX?2QV\R
HQgV@O2=9fZRO(C:,d,K_9/S5H2KdS&#Bc#R60Fe,8[=ZAE<-EGUcK3gAQW@0ITN
eM,I](_G50Z@2eeQC0HR+9-YWFS9?g^7U>)@e.9\b<+[eNM4M#8HeFQVP;bMQIf+
^AVX@F?M&<Q04^7.@?8V987W,ef-aBRJ_@AL8&JcT@M9Q@Z)S=M-,8HAU@NTD90+
./B4K68aXd-B5HFRX0Ag_6aV\Z@D>eHFJ/I[TTA8LQI5:UG.S^W0SMbTUQa9<D)6
+&@<4.FQL.Y;WLAV:O0/4\+62VRId7DaBN/-09=IPZS_bN@<9\Fc#],LPHXAGf&3
A-Z7YEbV@(-<8+<6X&P9c&2Pc,Y=IMd?^(>/3.H.AD?80/EG4T.=/,Sa+_3c-MVC
^BH.>34J1PfL+MTVH&G+.P49N9UTNRdGC,07#TCb_S(NFM6FK(:IGd(]R<dM<W<D
gI1.98^W]PeD;QA6PQ.M5N]L6]Zf7A#MV?>(>>>_&GG_(?]ZDZC_+c0Z7^/0QdVK
JI0+A_H)?1V:U2T+>_9>aeMe^K1EZFHI]9FE=bL#ONaRB?5Wf6I>RD)[18,@2a_(
?9#T5>G7AYd.L=>P;UL:F^&9bT>Y1Ya-3^d>/Lag?)0)5\>\@@9#dK7H&[57N/Y2
4=:W0VD.9&>,7a]JR\9=-,GS1<@eML;L0.RBe_>Vg\CK^GaZJ8bADd9Z;;CI;<Z:
I,6aWKcfG9U+KZ>D/&+B;\L(A1gWeSI\DE-)d5.e(4FWG1SE8:(?9GYKAcX]1LBM
H#7b?)ZaQ90HY@#Ae@D0DBLSZ3c>&+N+AU,KE-3WN[fBT))N0HHF32H6fK9cL&T[
OS&<f7VPb3CSQ7N;AbfTHXWR#3AO;IQJReX?GPV@G6?52?K1CdR\#:deH):.WbVD
WD9<Ofc=QMEf9agU7TE@;,=FXYZ/N/b(>+f4B\+3,b3NfWH=-W<_3A49Sgc-UcLY
f:-]FfI<\3,7#:d[-g+J9ceH5e4;_[;3Xa>18L+]@U2QEI@80.T^&E)5>&6>PeN5
&X_W=U81^^N2/d7R5MXEPb#ZYU1M,c+G>)2?Z+;SKO9NDKH)YW5/-@f5ZOQH=1S@
N?5gfB8X0e^&d9KRV05./RS_7,fN=L[QE8#Dc0H:VQ_T,_E=/-Tf[?8KY[+=HZ[+
GS52K=)8b.1(M?B\_caNOTg86HD];/A/:56>ZeT=\&DT2gM4-=eSE+SWfFS8@=FL
Ye@.e)27-).IQ-7d@70,\B=+GW&@S(U6&fW6Gea+VcfH[>XTLdbQc;2<5=>Kg]]g
M@]F&X\(^5(G?O7FMd5;P(1eZ7]0&@_2ZJ78=E<4KCd&_##3f>.1..0Z(VEF1cBQ
2M^KG<&VE#Ie9G^E4N[4?GW@5C(MB)Hd6SLU;2@=g7>@(TN.54L3OSR;f)GH>HJ1
2)E((IEO/^FF2_GN^>NE?E=F9H]_We6]SfH6,HAB,g,7JZF4F_QNN)XPA.).-0YA
A.]\6G&YSeT2JARH?2=>QY&QO]<RE2g^<C&MHL^3aBFRg=2Q>)XGSHS4PD@C:N?&
He4MKT[6./)5UacX^+MI.<8QL46(UTeH2:JNVZ/6Qd:Od:3W_V38?K?-L_QX6+,5
J^]U>80GF\dZ</9@e[[\#\PE/Q^beDTd04\?A8fHCKE.==f3S)L5#X/Q-\b&(IaA
:BJ155aE\GL:DB92ea1Od[P=;,PZfca]HV@?=MT#:SHLPeBOSLC:Ca/d)FF[\N@#
Z87BSU^@L8J_e&[ER;_YagM589XSRF0-gHb^(K/](Xa5<L<<):-N4b25/06E[@Ed
-eEdB6ZH6BLP\#aS6cTOSTS&b,98<;@7)@f^MWU]3EHZ/_U1.Dea8WC08&]VTf97
\7+O/P+SgKY9;#3Dc\UQF/g&)[,Cf^6dO_4]W324LIYMJQG+YeMI/2^O3:@:PM<7
P<:RTMfK4P/@=5+2AZfF,VLP2JGFG:D=Jb)[1:&[7X8#f;?eDJXH;D)/d;+[gJ((
24687IZ4:[7L#2QCg8@>HMbBca#3]cVC(bOa^),>U2/VGcIX[-PdDfMUNNP^:(b8
P@?[&MFBN)PK4ZBa[YCcP4[g,Af<.C\L)#=(:UD5/MK^=21>/eREO/4b9<L6U2-1
</Ta.V)LLAaKc[DLYU?U03>.]^T/&(&/V/Q_\2W=HZ_IA+S1[_X8KLVG(2+2JAUL
TT6Hd,FNW;U-)I@ec9afU06(/.PXaZH@V-@ag;;aH)G^V)a5gJ>I7/@b?7[G4_6,
e&b:g?];U((O>?TD>&=SIK_MgDPW^F[eA(6LZ_2C.d1)RbB]4DKAKgUfK,=?WBXO
(Z?a#/NPBX1U.+)e_:?dZK/gH;(1(/?d/>[TVIaG_=YMWfRKAcF9\]e/69-D[3L7
TRF]NE&O:)9GZ-D+P/SdQ_+E:XD_OL<E2ICHIVAdDL>G/AM;D7.(XVQXLb[O\W1?
ETUgdP>&,.=?HK6(9Z^JdO9P@^ZS^YJIO^gEHM+2WE(DMNfHUSCX+#a3XC\-DDZ?
KMG;CJAIEBY#AZfC^e5,3V,89YX-e)L5>)1X-44Ac]BVEHgIad58S8-gM=(cFJMD
=OZ:+NHJ[Y4d:U6HV[COLe:2X2SMODIXeXO4L,:a&HV)-7YVI^e79]YJ7&4O>VD^
MISW_E8>_aD\]Xb;Rd^JU-8d?<K-+>_#/S.Bc5+Z^WR6N=cX/D^5-cXPNJ:E88S&
/N8C6;F@FUR#QTUSCR8:gO2L_,f7e[&)D?U)):,D7FD7/GEH\H5.?EF:Q7=&P5E.
R8[AA>8&#g-=JE67[&^A:b\g->GYQ\_F-A<@<&1W3TZ3cbHHb2Y0#eEZe+M:[4\X
LZSD&a#:=@I]c[JP@J&5@YG,E.ZTVE^)VE=A/<]C?0gX]3M&89#1H.-<TDQ7&RN8
O0PbVPfK,\IPeB+0>YN>GbUGUI6DRH@J>XeJS[)]4f;C5He@>.TdEH>C]/B@4>Se
,/I6ZESA=UGNS=><QQfTMA+e[U5c[=OeOYdY(&;5_2YJ:3J,9e7IBdV,JaY4IJTf
Gb#?][C(b76V:#2VV(cG40>)NXWHX(D3d-G.,N2+0Z.d77M\M6)\VB+:;5RP@^,+
&JI5DWFB\)Uf;&.>?8RJ2MFP\WJL8B<N(53W5IgZdV?L7)7BB@;=(:Z[[Pb&:16a
D<ND_<9&WWD(KP[T\<,[TO3=66-NHMSV9FcSY<T1#1W#31QZa?CBXg],]E0DK_(5
b[^GXJ&PT[]c(PdP&<)YP>B4WP))g\,_[5a>[P:0H()P6J;f1]O7@)dY(I59CeM0
3[<DI0cgWL7;&dGR9)VX8ZT-=C,R[XA]_6F@)8]S4[[-b<eR/L19ZYP)R7YaVMCS
;GXaG>,3c/M7QQ(-(AE2BZW4=7K/#R&I1+8B#gEESD/\5G&ZdQ-WWQ6N^U&]23A6
UO_c+TBf6UI<324A..BHW@4EL]caUEf4L0XI5A&cWPJPF;;\V?@e?:B<>QF&5g;^
a^5&b-J://_H0XbJM4a+O5S.VZGc:KBN6,<D:;;.@Fb_?KV#M=(4SBAW=R.&_[<9
,AB)+[CZ#L8EW7P4A[F\;;0)XS0+^>7T.A8OW00XV@GCaX-.BU;Zf7eX/FWO)T?.
aacdD/,)^ELLE#VGAIfM,MY#7C[L1O?)Yc2-UDSg&1eQ=e?<)_\_QHBa;e[KZF+c
4g5Nca(]G)#YFQH.@a87EJT4-0GUZEgXC_@/c4/D:F\MQ-9+0.NbIO)=/?NZFF[7
?QBYG_M+\(^8TN8/aY-RO3R\_.EWX<,dT6OSdM3)3eBW^.Oe5e=>_4?-^RTCVDY]
>B7KA#3.VV<A<,>.fZ&)10K\g2/CE^A<K1+)aH.=/6-S/4AeaH+fD\eN^+TCG#Y>
]2\23<H_F1?D]L]G4P3@LcVY9gW>f?QJ;Cd#]Z2\HIf7?@EQ[bIYUZ:F;L:V_Aa2
78,aQEJLCHf)-@X0MH]bc+a4&O?0GRFEWRN4?S\,Aa>,Jf-:YXYU).Pd:_5M)-DN
M)S#PE96@/Xb\@5-2g/\<4YIVd]0aM.+-?eA@0\@RJ?Jd-DJR:]egaFY4abObE_K
g;:1>dM#46-b#:CM/6B6cG]Pa58XMD9<P^.N^J;,ObOQ#)aA?GL#+=d&6fJDKVFN
^[JLJ\>,f,[C<:Gc1fGUO#[L\-_&[.@OgY[,4a;.-RPeZNCD3d]G4\db(HdGEFC5
SBM+,\Mg<C-]YT@(;D&^I585O)O;L)YLTV<H#U2NG<8MYb?O6=3Y&A4cR9.5g<CZ
3;6PZgMH4&3--W^A7<[=T)B^5Ud^DZ@Y-V,B-deVT;c4614XK2F9W<R,AROKdZJG
/f+f\[Q.-+XdL)#.L#3S/:F[RX=d-=G8)&68:ZS4O>;./YSe[H[^)Wd,2/2dD?^Q
cDM><#Y]X<PGcTV0gL2eTV_g4A-a1Y//ZL+@Z.c4P/()ABP&g\PC7II7gNV:>FC[
d^_b#5@,(d8Ob\K.4;BD@W^E6WBEA/^\b9#/E67+QdABIB\J_/efNPOV<_^:(b&K
&F6T@>L+:E/d-(deCM&K^9d8KIZC7/,&8_I=4B::VF/W-@W_4dC4U;J=UEORC0X:
@ccR&daJRa[\<aA))6#);#^ET]LPe4+0K8aBe,7@U)Vc_[OGEN@X;BON-8S:WHQB
:752:f5+J[+(KI:5f,S+ENc1[>Tc_<VIVT<E1NXMB:Z]6fY<V,H_N?JNQMfIN\=O
]O48NdL+NLU]^CV&#&Y9J4S>dK\NP(KT9YH>.XC?CS8;2O/RB=^Pf6;Ndf^6&LRP
>MB\JCBP<aOc6(BHW)8L4/.&]6KWa6.JH#-,@0<E?4/4aV[ceT>c-f#Z0&9@?2Ne
Qg1W1db9bQA_<PG80WVa^7X]&<.6?XC7a8<6C=3<.0_ME8D;6EQ]O=ISaJ&L2Y1T
Wf>LS][&??PDc/PJ]<C(d_DE9>,7WG9TIZHEXT\cVUeI^NV:VG;B5E@B6Z7C4+CS
OJ:X4^gWZd]5S,>(ANPO0Cd9FgU0_<3eD-/PJ7^AT57?FS7b(\c)f49R,3=:Kg+>
26X(6-fY^Zb>99a2dGIV9[81NW_5]K/?aPBFYJJ&<&TTg=8H;J3.>\M,)B7:aTQa
4G8=FIa@W?:GYE)PBCGG(^KYMTfCMWXCQO6,MJQXB&6]79TGWE[(?H<=0Tg[[:,Q
H3)ZX+HBKb4I[a=-MYPZMaXe<T.50YUKH01++YS:DC.TTbQK=LI5?7]OJ&/SY[&a
8-&P;L^;@0e2D1I_OB^b\Z4&+-dP7M:&aEQceV&UJT\M@E#4UdG5DA8)H(RcZ:ff
JB>+-,[ZGc//f0EL?8YOO#(.TKBT=3@\cc(3(_<_-eM##IbL,:W<UR8C&SA9\NK+
)S5_X^f;Db+6WZ[ZK;(Hc/JGY#1&2\:Ia73g307cadZfGT,PE2PUg6YKO>6FW@6O
Ub.W1#U/cBK2d78XCfOG:T?K:J5_VAagP<_0./@Jce+<FR8A8UY^B6(\7P,9:FRU
)BJE]0P(J7Lc,<R4I1=G8S>Me>R0GZG7G2V+a\c6GG:2&66S5]/2WR#dE3/JS,+^
#:4e8Ra+ZXV4I5W?9W.Fe?[_6WT(M8J>fbEO2>GO&R[Y2=#He1#2,?^,5G?2EgDa
+66=7U#^>\:DOY5gO[CJ?A?;.2OdJ&EfVL-cI,SC[P?^K9N)c8RUMN21RHIZ\L]^
A69]RX;8/H09AD/39dP>X_=BfWNHSMLG;MLXVa5:[IWF,MLV7@YB8GN?C^<)1O/_
?c5WVK[9HT@VGF.Gd:E9LAaePV(OEE7FP&L)/^OfP)@1eRV+77(I3+&6>)2KXY=R
]6995B_#YKB^R&7:OH4FeO[ABPKTUFV,BLC)Za:Xb15-<S.;L>]dW,RHS+RZ.LgH
f2@840]HGFK,LD1Ag1[P5f^-RM,bE-c=0B(1)>[VZ>=[<4^VeNCb68IG5E;)\>62
?]9fNa5-AYILWGO\?>=\S@^_@_cN]HXV<=@8&)VW;=#_1L@(A;V3NCP<bO73D9RW
b&cFD;A+L8EPbK[H<5?::S[/1.)EXVbP@^Y<TN)Id311O77SST/QQ3VZWUP3<G@1
EZI710(N2_?@:#&3]PXfU<GQ=A40YP[eR6[_JTF7#Y#VT;4UK[ged_)-(8.(BIVK
K^B&JQQNCAdG#.[K(_80b;.H4@@KW[\Z4ARc@HC7TA=1bb,=b/&?LG?M:f1BI@TO
FHWf]LJ=+KD7F^2e7g:24A=bAEWTRLQQ+<@+^@)DRagU-gf0<\EXGOR,\/I@LgEE
3bU&f+D4a[fRF:K[N\?V<:ba]eY^I<F?KHb?R@59M+>caLdT=DE:f;XcC)7Z7c1R
^I6=]0[4@?G<Ld2M_>33:FUB;eaC8ZgW8VBK=Eb)DFL_G1fT1?dR)/?S#7O.6(-_
LJJa)/8;4]ECeeI,_FLY.-\,BLce+,G>0G83IS60FLARJ#=ACUC2[T+agF&>XJOR
V>8]>&c.(VH4S0/1:>?3.8F.6BTVFBgE.M4?]=P)T\)&I\5?KBBA?PL(2e6W>KBA
fDQIL_0-^+,)ONSU7\9&,.6VUBPB/0,<K.]-Ag^VP-.Q1Eaa;Q;0J-W^Ka[UBZ)0
PHQ/HLaT>H3BG)a??c&aPHID^e?;Ac2S<LU-K#JP54P3_TM\1HJ&@2_(),KZHCF9
De:C7)TOOYVad=\G)a,1g::g/M14++cVL[D2MYC,c5g_@_@;QJAT-=e8e&FM/:&@
5A8W(R774RCHDI/(D-d]X3Q)@1R((GQM\2\<Z=3CO^HN:bTLH(,SeeO7LR.c+&:P
5-/B3D0)Z>L-CR&Yf0P7B>=&c(gG^CL@7NRg7ND8-3S11cE3#9=e5eG\g4ZUJd0N
4Y3A,@dA/^T07H6.H?,?R=UeKb;;2V&(EY1S@E&HfL.dDUYOFA.3/b=XZeZW5gaF
X=S4A1aVB[/V,259XV4];:W6ZXT&FT@BLIPC)3I#/NMMcb([PG(b?-#&02S)TJNH
NLPZAHT[F@D9;K\&2e5[(5+Q]<=Q9Qc<(@4-.S3QeV1AX2[1E3FWb?40X/K#2fT]
46PC^Y8/B2F_).RXPg]K\#7@Rb445]4L>,3HOUdX=@Le)D=VeN:Q=gLHREJ7HYG.
Q1U@J#GA3LY5CcC[1Kf&6:I55QfM,=0?=?/&]5@-b&7S78N6-5JJPBY7QML0-?Y8
O1FD,9KVT-(6MGd+O-&G7)gTd3Nc[@:aUZ-&??OTd-:fS-L1F661e?\C.;>Y85KK
IV)KI:_11b45_S=UMMR#cU=.P2^E#_522c@2)?gfPZdC:UKg)a;LXP+dB=QGH#8X
1X^O,RR8=DgA(Gf(R.S.;C6V+X=_^4f#fS&E0:>.Xe?=JXV<=S-Xb-CX1^B18Ra1
8BOXOH#(WfLQ_M;(KW=Cb&ES476YDbCa<A)>^G?++J^1R>6G<R2E@(&:@)9KOM@Z
d29=MIKcA,aR[S@Ab?RLX\[<gDQ2U9.5>RRQ]:38LIFEGHXK?Q<:EHf0[:/YR;TV
<.NBV)#N&Z3VT38(&O[EL_(9,&VC8@d.+#WG>@Wg0]3?G#]&V]Ba)QFA=N4aBGBH
5K?f^1NTCOg19NH:VT>:1A8g0TAcJaYGX,^@KJ2<NKAE?^=-&^>)6[)@RDL4=,:c
((DE31QE]E(X]+3WWFFd<8SKW&1_1:JY[?)X;JNgO_4g8YY0-A?KKdd_,)5-B#fX
F5c(IEH5]CQ<<82:8Y_X7IFJ=ZCE=9HDQX\LU<SPX+X\_5g6aY+Xfc4_\>;?)JSF
;EK/B@fQgPM1g@a7QZ@gF.Kg>>_S]:GB)FS2WJ^VLKZRLGe0B\^MZM[VKAAQ&S>B
&.<^B[g(0,.>;LHOg-g75I^MSBFH)[dK@KE/L+7Q)E.T,:dKTZ?Ada@G\I?-2:]@
X4B8:FNSbM9@fO]dFJ9c87?0;R:afO22F.D9/Pe2EP3\^((.O105YWAFNSf.H]a^
d<93HD+SP9ZLDI+FB5_&8KR+FF[YQCL.<DRO(3:ESZD3Z/#9MH9/;3JH([A5TW=g
Gg4XZ,GbM:X2L1MM#gacN5:K];.#U08OO>OX#Z8/\PX3:]g5QDbLeY@0]8Y()(0X
AMDfN80I=]-XV;CKLP_PPMTY>?4M&-fYcHb.:/,_5BJU4PYNK:QSZ6\O67CE/;WX
Bg.G&HRCWMbM>f3T.99cL2?BM20R\6@].,FXPTaS7-eK;5WS\M(FN>IHB@f4e?7.
D)8LeaYDWJ2.G?>cQBHT+(.[.PbW\5?2C_8V&dT:IT-a\Nf5&I3c^e]DdX=BS5#.
-(S/FM1EWZWRGGIdccVD&e_;[Ua)H^ec;JI=(_e6I[4I+A.BIGXY-U]<fSUR@ABF
63^/DBc0RV8]/7CAKXgNDM,^1DE0NQEP50V.,Ma3RSF<225+Y\&R42HSaK[?GPGV
QDAe=0\3gbI_BPJJ><Ab>a^N60Q8aMX0#MW#Y&Q7[\[Z,;4PG\I;W-LO+&#DJaed
N1)GcdVXQD=LRJeKQ74e8\f^Z9JP3Y-##+SVd+(?::/I@SKU8ZY-Qb;\+_CW@\CG
L^32NZeHE)?(gb(.:H/=L=J)E<B28\,W>TT79:DP1(V)LEQ:ADU9BT@=1R#A>&:Y
8XY&NM=T1N>_W0UXca?<U1QIU(FS=9/M,<<]Z/A0gB<85^=UM-:).BKXX<C1U0C:
QK]Vd55;;3L-UXKeEKD54<MH^9ZQ/&D1U[e@@H]BEHc+M->U)VX[?(VDPQIUe(0c
.NHc<A,KcO><A&<Y6c.2E@9W@NK&K+\JK;4Q5_[&ZaC[>NK:XD1b^OLPLC&1GCL\
W@NDC(@fK,4L\RCX&4(GI79--&-OB9V#,:]dEFCJ,K:,aW\<a2.GZ3/Scf-4\gTF
9<ULEc7eD[J]_R\;<KVCXbORHVg:/@)6deU4)[SLV3-<&>\d>ee#@WM7)34A3@;T
,KD4X9U]dBNB]OGB2SNV+P.f^MDF_RYCY:+Y=AE5GL5+YRA9f;5_EWf&GNQ6-&(,
IB.6\#:P>MDPc\B3W29PDEYbML-a-Hc2-7Z;6H(PL=WVTR6O9LfAPMSBgN2Q,@JX
S9c09dI/^=5@_S3&QL>0d/D)EQCgDH;eA^.HgZ,bW0MI?AT5I:9a?VQaBSS8^Y;U
CFG<Y0.IbF]ETB_4B(WcbA,G(0[T;X.ORb]K40YFX;GNVfaM>A,#@V@5T)eeB=b:
.@&>1(?:<A97KgVF>^]&CG?UJFKM-B+Y:Jbf=^LJ@?/^DD#YeO=V#gRUN]]36UR-
@>]RJ)62^=M:,M<^5T.ID[d,(_KZ]K<XdgB6/PU[C</8PA+??3X4RE@,]&H#5bgg
]NIc\E3:\FcfdD//,43/L&U1/3K5[/CO]eH-/Na?VB&I;@=.0@Y6IAT+/],.WM+V
(7U@)=5M4/39OR0&#8AX0R;=C@g1]IEZN\70&,JP/C1bT@+e0/7G6A)d>M=@_1#\
9AdMc/;1EWKEa#CM92K2b0J7d7FL3LFN(B1)I>^0cS^_>bE186E+;AO69K\eX[9T
E0K_&(1(QNT-(R7[^R>VC+Hb+A\LYKO5OWH7e/RG6&/W11)OJKIL;b9<[33R^9IB
&\#TS06PKIVV/Yeg0W3;/4[gK&Z/ES)?P_\L)[+F]::YCI9aQ+BcBWZGJc#ZX6#/
J=U&7&D9/C1N2R#fYA\B6DT7=ROAF5C_0HT(&b\d11Q/V1b2cf].#DO654ae76)\
F&MSOVI2YEb[,8IQ;HUC&HLc;3FdZI)(5AKdO]O-?TV@e7fEIZGYQL<;Y17JS(J5
6Ye^PAaVTb&:PB<(P4.,^XMU-,SB[R=<:&@VE\-J5N[g8-A+=U_DWGaYDbEFgB@A
9.\67?8gcYGfPe>H#]_PQLX)F(P?@7/W23]D@IJSFOb;Ydd=]@A,<f3RffEQ2<ZU
[@64\A,R??:5Y]>W+L9-)ZM-PTS?U_8J/J:_g=QO.A];S4JM_\fI88X)A#SJ9RR#
YC48/R\,].(OZfI4)ceEEL6b+eC+[//b<#>Wd,)U4dQCQ5P.P@N?H3/<gVY[:+?Y
8I#VNS4(Y2MBW0=a:E#bgZO,\bDVWXKZg?b\a9+]+>&S0:_g1A>A8O/I?A@9^<GF
d8FNa,(;\HZ3#1/OJ8.<<2b#5YY7.J/g.[eY<>VYXB]^0@AZ/1558Y6QfSNJ\N+B
fa3e.]O&A1BSH-15D^N&+5UY=2^\11P;D>a(\/eOQ&S>.&9Q9#9LZ9G]ZfZ8ZFR>
^8EDCX3)+SQ&SE.=LIbI]XK(D.MFa1;C7cC2cVaBY6M]O42ET/]dg?1.[_F#EW^J
-ac<^6ODg1-GP[>::K7QE4&F376M,9K_#EXE8f,OFU95S1[FY]c@FFC@3(df1&L-
AL^Y\f&PP]GR7TIO<_H-0\>YM\XL=G6C^/3M.OSB\2YRg\[(eCH(=d=5E;^-3OZ9
NW[<P;T4X=64O-3#PgO_O4\ZL@;&L?Mg28)A3D7>:M#E#+;2&NT;/U_)YY\OAYA0
VL3]1F?UK:77;3]^F9)WJRSNQ.AZ-K<XL+@_TB\PdVTdIbIOJf:R.WUA>#J]\G;H
D5U:]?XNd5P)[<Yg+ZCXQ97,8?fbB8bgE:F6>C<7\cc0cE:4)gAF&QJE2.ES97>:
X.V44GT2S1Md:[&3?f+@+4Z_FUY&_5XCdOgVH1SBVc/I&.1;:-S/](J,XYBdK.4e
&PeZ(_E@T@BMDMIZ+^2UPcN,LCIUV<c36d&fR7eN\T0g(6J]HaH5Df1IYHV-cSf-
LddaW4\8\];>^dE]^9#c(dM9eKIdTRH\(NX9A4c;T+e.>2ae5LWA3/PQ?QS-3ISb
6+C2f=6CRZbR(-;:KXU6L]BCg5V#WbfWF24KIg&[#c8[cE84NYGH7=X>)U_W@b>3
T7CeZXV-ARPID&>)VIQ&gPAbdOfWH<RY+T+.#a@PEEO78aCJDDg9H8gX@R34C_5V
eb0Nc()L?eZWZ8XCJ3\1d53EJKMa+ELM,eZOCSfgPLZ[S4_X8^615g9LYZ,cA&QU
6G7KDR?Y.QeLO\@.=.M3?,eeL;89^g0991)_Ad2ZddC69B&9S.JG1BWU]CF8X1<e
<^R0Iba@?K61AQgO=9NE8;:IYeQ./E))Eb>g<.M<)8O3Z:bOY)SZ]gV-#(1/Gd?[
JNeL(M,Sdd0V.bC)&c_/fgHB8bSD:cDS8.JU,L8K&N]HRZ4.e?_=8e#Hd1<,gSZQ
./_7X=.K,R&_+@T>@FHIRQeJJ->V.=5cJ9D_;g98N5UV;\#COM&?_=7c#ACLX91@
2aZL<^e#f9V0/Z84BJ/Y0\2/M.2XA=N_GM+Dfd0L?RI+D&-0f&X3&H=\YOC@<@4P
>ZNY:?>eNI1,5RQgacY;?4V2^6cG-7+3J6+C;bT@OG9D^/=D3@/A-ZECgG6gCSLC
e46MS8^I&R.UbL#,+TD.G[:>a+VWM@.Mg35c,L?43.H1TaVPDPY;UI3^:FPDJ=M4
]QNe8d&NeGHV)>)Q8eYS/6IZP3cY3eRBfaU3J<PNZ20]60NQ>::O=B=VfW0+GBUO
_g,HA&a6)Z:gHV/Z<_12,=^C)L2/V3-(C3eWT:?R8.;&bC;d26M@_KPZCS/##d:(
8WE#3KD_6\K]4d]V&:ZHM#2:G--8/MQ8+@/9<E]ML0d;af:eF>,N=;@XUOS+^BY0
)^Y4UJG?I\YCK?SWYS(1-H)/A8A1)[c_DMGZQMPB?cad_7)Q41@K0C5Bb#+S7\@(
K,KAI013&^&B_-2V8,HRT^O53NIK[_I6R(AQJ3,V+aJb&L#M6E2UR/Vf,4b>aN1F
+Z^^D^J1>3O2e.4(DBW>(TP?_RX:&)WOJQf56N1KW(-Q:f^AaKI]Lf2BHN_QP^E?
X]-V16PQ6]?BMBRa>2=T1]X,eG3fB]+P2e:HG\e&(?>T_HL1+2OaN+6\SH;R;.ef
N;Q<G3TI?Qcf?.f4JT5>FZ.H[Dec?YGg&+Tde=R9R]ISO>2WWad+T^cK6E^7BJ\b
=1(+_Y4?:54;SGGXg9]19fIH,b/:7OOK#g^(1<_VO/e-fS59F#g^RaA^N1IN(.b[
@ERLS;2a,cC0INFH;QZ[cJ1RE.0643/ZRX/I5U=1J736BN?E#^,a>O-L<TI;<#TT
8ed+B6\)02]HC)gHSV9YeM]S-3Ff1@BA&0LXdF/Vb.ER5A&0\(dNbb@.6Vef_=aA
-=5Ld.beOMgN?fAb.4/D>D)NP^C:R5CH?4P)@a/S1Db\C.5:S8_XZ&.Q\[CEQ7Ge
/9:#UW#Qc>&KKfB<F7X5;+:ZCVV\)9LRL6<\=6PI>#cOb?Z75OJS)0A]41R>:#WZ
2W<Mb:d:BU^&D-]g;fP&gTPZF2]cS=+[)b@G(g67b#Mc-4APSZ_d93FGg#S:YJ:\
e=HTgG)PG,<c:,M>:@_VSC#V2f&6YG<1G75J.FDUD:cONdZ5#^dfOR_5E05TUTLf
([7,Vb/]&8[58;D4G&T#NYA/F2#OA0/#U@A/K.-gCR:4ZVJ-ODX?,XG3cMW9ga>R
PUF&WCID_SU_7#.#<BF4=#YJFMMA_SUf_SD>,ETg]9W?,0,JGe3UW->)C?9@Z(.c
OSB^^Ka_10RLKa\UcVJ)-,/P_9fG1Cg:6AAfIK@MWW7Cgb^]e-[f+HaP0eY),D(K
.93:Sd05;Za6UVM&+7;4?+:UKa(X0J)JH-C;De@@=>PFP.IKG,BXc_E6M],[&>MT
K<Z<[e.E^<94Z_d>2I9QJAS,5]06ED9^^dfEQ,C7C[IEL45PW9/4\#@N5)E0UD^Z
&Ief:bFI;8=+=FLWLDgL+^.K-(K(5YSHK<O17X+I)eE01VeUA]ZI@\ec8eCCKefQ
5Q]G@@)M+@S9K>16=6O[I)#2EIM>d;M]VO\Xb8QZ-,73TC#OA20N#(LeG#\2a+SZ
OI&#e)_&Nc8VEWE2f37KQeDP-7eeT=I]W1PY#05D2+_LX]M/<P7F]0DB^<KB6A^]
<G91ea0?)U4CU8fLOL3ZK.(bQd?Ge#OBYd)PGXQW8DG[Y\@d;X,X2T,2aE_&[G@X
aJfd?NC&F:@faB7CC7g^K&_(E-B\61+#f-FR87.daDV[G+VRY0DEa>bJYC+(<=H8
]65#]cWb]Ob3E<E=.;G;AOA_93J<8&-IGK[Q2;-TCBG>?D&2\[(ZKC#cGD>PeBWe
A2aCKP8S:UVMK8DG=#)G0cN:6@G5=ILJb&D&5BRcGR05M@2>@L-NIS3R+ggK6_bL
]>QB+#VJU;TCggWaR9MT-2-S)gFMJfWfQ#[2D-HMcBS@PMLN5N,RTY=KWXJ5JKd&
.F]Q[2UZ\VY9C?)D>35cR]:dGX_K]TPOgIM9@V>BGK(?JF,PC>?8_aRdPBfEQb5L
#>]HF>)\F-X7:dBgG[-O<2]_8ddW\FFE?O:C:4NV2:)gU-532FS(TD^?NT,)073O
Q1YSY-/,4J>LA=78#3Z?fd:9UDRUPQ:?P]:cddE]L-dS-fSHcf32?X7@\S4a7AID
BTI+eUBT0M=1\_+&WB\6G>9MZ2T+DNOf?2O[K<AJ.PJfbI_[<6Mb&JV&0c_J1N_:
dB3HJSK509^6B_RPQH11BD&.WN>+.:+aab]S;0M9>3_,0W<IC81,5fVVFRZZ)Y@.
<Kee._171T)GGZ\C]F#4gHHeV@NOX_ZCN;.5D?WB.bb0Ea2GUC8a9J2&E.D]1S7.
]@>3S0LeJQZ;,FPM59.08SK\/Mf1g4Lb,YKE>FgF/V=>U:Z4[R<\T)@GNH-1T71\
dBYd#.Q408:4@g/](DT;aLW6XV#0]EBB[Zd67WXaYe+MUQKaDfXYa\=G78+:IGMf
))_eU59X-JPO2(;P5@SST?;GBUH67bT2.+F<CK9g5R-?OT2O-O33ZZO19H5=0-c>
EC5_0N\,bfA+.<PC9:,:a1H/-)HUQV6?)Q@1^>2N7_FY5#)CA[WM/4deMPULZJNc
PKHY56dV9eQb-I.N<[,UJNbcgObNVIU.a,7ZN4X#@[Y]DFg3],Ac=a]T8\&+_f[B
(P1I#+;;g3KXeN=R7]#cd<OEg9F\BAK2,XVK85=A=F;H1c69BC&J@a42PB;I71S=
Pb5Yf;?<d]JeYZ;WXMO;BWE/WQSZEO)3,X60779N<7-#-)ZWA<.Ccb6[.^(3K,=]
D.UHX\+,;=g?>4U#3Ne9M?<5a_CM[[-(dE2NJD1/<Y#J[]);g2.DO@d9[26&:A=F
eO_aWa)0074QPU4YW-gMWX4T.T0G(EQg>e0YQ=+V;EC07RUZ[D3SWc;Y-_bVQ<LZ
OG4S]AcO4O>()?11GZ4(OfXa7_6/N7+DZ]7W2)T@[X_2MPVB2ILRdSTY]b6H-Ig#
GTYcAE)dgVX5D,V^)9\TO^_R@_b,N_2S3Igb7Sfb/>>+^2,5#<F^3IPF:0#\+YYE
cPg9Q.Z3d<gS/P]_AaESK9<&,/)abG-Zb=D<0A:#/RL(Ab>1g.4YLWfC4I,0RdQ4
RgPCV1,IH44Oc0R\3C2>Y+b+;3,cVI]Y(WgGa0;TD)_?MCD@(<V:D=[g.UIV=.P3
^K5CBOOfPMQ^e#&O0.JZX)/AVP[7XbN^YM;71PLV3-DDfRQ\13I0=O2#5>2,[QJK
J7^gB<fa\\>GIUM^P;(,2]&[@D&>2;-2@@_L@Uf9VMMEagS32M@7#?g=P#9=76g(
YG+S^YTY6]WHaQ.,=^<0-LC;?AP2.@OOURM4<J2-6:?Sa&OF>C[:@=JHT.=(fE:\
?3CI(.<fb@7VL@P7A0V[cf,Ya7V/@b(D9(:(UQ,+]CA8gKY//D]ef#fSZ^dXJ[,E
E@J=5\Y2<;Ne-&WIa+S_64(E-ZHU;Sc8<K1D7dZ,aW/DIG+>7BcX.UAO5g>N:9SH
TLIGUJ/[,F0E8U)-H\9/bM5#/],4;]f>6\+<:g@g8;=^>Ie0a^2Se:4#O(>?<[D5
AbU4F^O;C1T62O2)L(dVYNaFVB)\0W&T/018d_0?J#FS27UB;ZcCCZR9<=ZZ0Ld;
->BFbUA>GLR)EcbbeCS2MX)U\1TUGW6;bSa([QgB/TNbbSE7<fbQ1)HE1>1><E/B
gX9Q&GA=9M)_OOZ0;N?IR]^TF_T3dXdKD\20-.:6^-AM)[-b+F?:^/SRUFdbD&Ob
OP)>c;YQJ;ALU(fGcR#17L+9&0<@USdJT\NE:AMCf)=+;Q3YA2NIb^(J[GTA<[?K
fRB0WeL/:KD-VXF]_Ag=AZ_eBV&9PB<S8-96S:X-J.H&[;d-FRJPSL6&00cHVQfV
W\g3@W1R12PaZSDC^dS9RUc<]6R\a9Q(CXY5W^.54:P=_9HffK]2@)Df6?.M9:Zg
4bZC1bZ,bJY3->7-2;J5eAT\Rf-1+SO7PO[J>#I+eD&c[-=8f.871JMZaX^<@=Fc
E_BMee85?Q>E#^dJD_EfTAC@<UEIPA)(A;PG+fZSYKA)&ZEAT&e9=]ZVO2Y?Q_L,
U0dJPPIMaBLJ]f?,.8>3JZO/c.dQYH5J\6]adD:IX@OJ4+(eL>WIC-G_:YT+5HR2
(WPO0J5?@3,TLOZV8.?+_/^F3<R6&[5SU?ST6W96e5?XVScgLX#&N#RT9:M@T3\B
0A8J6W3@GY)E.c8J6+]0@<d<ca3b&/UdINV#VLd&P:-2VWA.CUd:L/TGcKda/@aX
2]/[8W():9WT0HAQR+^g_X?4(Z0B6LE5+PF+S2f58dZa-X3M:<d:LAL&T(Q\3[>D
,Hbb&-3C>:IY?J=OZeEbU=gg2\LWD8=_OHebZ1AK)@57#;D(R430X[T:V;+?6g^F
1Lc/=4;IIVK7\M9dWT&79G>S+]V@WDH;Y-Y8FGgIgX+\fY+=M0(G7TB@@b?0=RNe
fZTS89acJD7=@8UR:1IR90(UF5LXb16AWd.YCYK@\J[RFYGR?>H>#TMC5Z>=0FR,
)3BG.X[_d(F,C&bdWEHHVAIBJCD>^?efbM-eSV1EM,39RaTcW1ZL-?P12e[4GXAc
/Z7BGO7H+:R6#YGdc\6\acHfP2ZfKDG(^R<bf6Q9AWPf<N:]1M\PE56D5KR)VTHJ
CL/cY2R>RKgPF4)C:N<MJfK9M(Z,7_Jbc.,>B])TW/T,JCI_8=a(V+,[]#7N,\aI
6R-ZfR3_M(ScP3T6dMXS:_bGY;VX2?7Rb=SMI>>Z]1=g+<E8_&1-/,ONTG+[E;VH
(-G5(/OFU.d08@M6JfI_Yg3=d.@4-UOJdU(,4)M&W5E.K.#]9,>=67M[RU@-A(X@
Q@\d[P4M+4&?1D.d+MUI-K0NcPeJV1cLe#@^N464>1S@-2QUeRY2.8N<Y[X)9>GQ
4]gD:+[?I0W;^)P&7b5R/VW&T#T=,<-3\\@(E4eD8-Wa4A-6]+4e\\ec<3O=945\
>.;?X0.TeJLIP4V^F5Z:N<=8S9\FV\6]VWYQOcR0ZbLa3VfA6/>^802-e@_,V.PO
_C>)K.XUaK@EFdGXYf,MRUP^dUC-E/=[GZT1D7@:ee?-4Q2&GHcSFbbP4LRA-gWC
O08U9b[gAWC.@V_fY]-_WM3/JMbT_XAf8e&G4WX[IReAcD1TC@.3.gX6E5W_bU<P
daKeRQY=b9+?]#;^a:<ZBD8b3U5@YS6F9??D)#[.&GOX2CbT6Q8[QQ\V8J\<a2<]
<MBV](N\B)3a:&-\IYSF]UeVGTB9FPJCO]G;QK<VS\bMST[Q[&O[[_?^6DaL&2T(
-TB&EA/[cV-(bJK8(3Gc=efHcW4=ge_Zd\UW/;3FcX0G78VI3)@=08&EfD22;OP)
=g_Ga=+@WX5UG3?;JA<#d]PR=(?(-fDXUH?cGM4JLefNJ\7Oe42EQO\E1<6EC;(8
Kg+<W/^cKLSR@6.gDE&PK4^[72=?_FKL)=DeM/eW@Ae68eNcdC4X3-ZUNa01PJLe
ZJS=Ff_g7L2(MHVeQ5Ad\4\Fc;6VJAK,BeUZ5]=(89_gWb[M27a.64_RV#=9=e&+
4V/[6J2C2c^:Dg+7[@2>Z5Q;O#f(<J:bE2?C(+Ac#@^4<1.\1;d\bMX.?MFZS#G9
.F964b3LP3CCNVD6YH0=IU896B7Kf52X_d,^HS-Qa37:8g-YJ[PMcN1.?fSC+SZ+
0AW6]I+1EAcG58ETUE1]C00Y?/TXO^4LA4589Ic]=3Lfb:55NIC0S1[>;_dZ7Y+^
_\AEPbOP-VC/RaOK1V(J.f<eB[2N[\>V1;)URF#O.7DAS\b&cHRI=G2gS9CVHYDR
Hef8I.A=\]bHH00Q=81(?IA:b[Q\(VYP:Q_P2Xa&]H#K?a\c,&<g0>b6M]&e59CY
2a@f&Q,FL0c4&@A=?PRd1PQ,[;1^1HaU)9EVP]81E:a\](d-BOC+RX?Tg2OL1fLF
;&^He0<96AQZ+/>Eeb<gd375U>PK7H4a0cVA4LTOWX^#;2H2/T19<E0[c#CR4S:c
65e1.#@d;(#c>M1b;M+g#0OG+U6:aK,5Kb@S>CDX^S<:S36YKG;[H9;\E+LNUFS2
EE@XHX46?-@A4^HAN6d-:MUP[g&_\(e-g8.]EeO@R<1^TF&;#?TNF+WP3]1P<dLF
Qag9Rc<26605P.]CN?^&2X^4I#c>^HZ[(Mg:9PfC<QW)2GZe=:<8#RbS/+.-(V9K
/]\+)Z/>)Jffa0dC[4FA8IMS)LRda6BeTA/8d#KH0Q:5^BJg0RQCNY52J>3B54&2
RU=KP.0a@],6JGODQK>USMb\S#SE/fc&8.ALAJ72HY\.4UF9Gf#EG1D6gTB)YT,2
ff83Ed[^bQ,^??)bcB)YL>PZF[[-[a3L;@@V;;,:ELCe:,1Ade.ZgWM[6bJV&>1A
LcOTU.DWgKBbC=#OTB^8ZE7=2d(8gFH_@/C-80:+efUX+CPW-5gg0(YP;42BOBL/
U5Xd#_I,79VF8KW9>:XD#J?<N.e@4?;EXD#0Z:=LMeR1&+3O.5SDR4BT5=bAdVFE
(6Z-fc0cg#[N(N>.c@2D8HLZf1;g]\H)S:2[KPd3:#g?M@C[CS=O^ge>V8c(=:Se
JYHQ6PLa3Y<ROfHXVYLI^56LQOU_H;g0@^XD/NaJRFD_XbLFIJH0#a1LL/C<Oe>I
Vbd=.g1VW\OULI-fL2O_P&C.IaVdTOD03C+^SXOR=..-DE,+<1#aBMF:MZ?I-R0Y
T+CUgS(ZY0?XJXQ;F81cXA17[24b_EK4/X37PDHPBE_-;cD(+AaZ#KE(AMQ-VX,U
<O]fQFUHCcD^83c5^@Y/>MLU);G@PLI(ULE/CQQcB4dR7b6NL-9^IAGMSR;YT,NV
)@_JAT.<X:M7&]V6STMMgD9Y+OG,M=HRc]:,>>8g13=PFI5@S;)5J0L0A/KZK,ca
6>3BT\MI06HC)/:Q\b7QHcCPaZbST<L1D18,OeZ?TcA8eUCWZ??KEG?E/(-a>dF>
C:;T351&Ub)I)NI;Lf5.(R036FJMP#XR#GWP5^6NQ,7#D:LBT;:c+Of+HJ2eQ?)I
fQ:3A8bN<I-V#K#G3R.+dV6,bSHcfX4Q<]+Pg\9V+IT,,_Z>-9EB3JgURY3/IA_8
&GSMYNYL_GS;O3CLe<+AC&LL9R4&-E&7\0#8HN+,T0K3E>?0d\8E-]2<RGeDR40L
SaV2IcFb^:>#)O.cGL@V[E6bU3D^W5@&GN?9L4JJ:d-4.F+>5@P;S&Lg#PaOG<FX
O(E^\;W(NWbg0Q)9-PM2b4CGQ(6GB]dXLX8<KAV)ITR<bB?#VI(bUZ@/f:H^Hf@,
Fa5@W;J[UBJOYA)1Z&(&0NcY,4<)UZdB9EQB&_-@D5[>Y1;6/0?2AH6Y6D)ES?B^
OJ)9Cb=)4@2O51+RH_LZ=59K@S#\26K:5.=5/:a5/&PU[A](CN02-b)4#E?e\BWV
d,<IV-Z#R.Y:V/;<6SGKNN[aM8X@=.RW\X\a@@D_Y/_Gd:SQEJMAg?<Y#95:;)]c
AW.N5)JNd0K]B>M+W)dJ;Nc>8Teg?7[0J4a/868I&IOgWS_-VLV?8@<Ua&1T-6\G
]@B^I?#[::^#aDN0JV?GA894ae4OW2YFUY<X\^?#FJ,N:4HJ-)Va#]#e.SF8/(B9
/OE-V3XQcMINGVd,4b;Z4&2Da8Q>2A05I2&L1I64gegA2VCX?8G;0B]Be<_R]a,;
[MG_Bb<6c+X0b):Wc,X18Q\)VS_Sg&\R(Bc9/NIe.,QeTcT86-7feaXW4SeF,K(a
=_@3^DSbddR\E=POZLMdLa)</b2WFfa]K>(dIf2Y5f_Q/2D@)@(#/NfL1a5C1_TS
/\GRQ19]Fg,Z&8[K[II4V]\4Ca2QIU2<W1]7[_f),C@-SbHFMAbVJSZ.9J^DU@\E
R:X[W2=3\Jg(PMd8BP[c,<.Kd\0_F;c5-\R=)UGXQ98M_]0O/DW[\R.=D-Z5U30-
[IGZ7f#@5U<d^UQb-Sd@#)YULZC-g=,3ga)cDN)AGJBR9+f<U]IHJD?G&[6\-3):
HSV8@\.DP:2(^JMI79=bUSZ=@U4,\)XB79@;<PM\1.SUfAS.-3[F:VKL&N\\O<\0
IL.bdY7XPd,>:Mf]5d0bOgQf7RH/S19:4PDN7(L5McY@7C=DXEbGK/a_T6YXQd2P
U=W80:gZNYQ/OcES1CBCZ]6ST4/a:S-HED&@XA2F@^LD55(Q[Q0JCH,_A&DYA@R.
_e9dEX;))UJ=3.A.-]Z?,4_M#JZSEJDH<-(HX.dIV],Y,BOW2C=9_<IQV.<+;&:F
<@M0gFI1>-&7bC#JFYSVDd)dgMe5G7)==&@_Q.[BU;98OOL9/e:[93-Y7.VF&]2-
V1Td^ENccC<HJ755^2VFK3./=#@8HF+8F[Z7W^3KeA?UEUL:B+_03H&1K_<TX3W6
b+I3Z?cL6I:d;CCW,IWS(Hd\_Sa66NV)0@]\1=A82ZZ1VcLJI++@6HV-:)FI=_C,
3(404<K=T\KgM,<Z/5a])+427(MSRP_gD.D>F+JLZ&3ObBSG,/HD3eY1#AZ;FRJ(
-Mg7:0;fN[1S=Q5g]QEIVUYFP,+;2<&54?aO>9?&RRJD><>1QL],N1@a4,.2>T7b
A:ILA@WR4XKU4-)?FUg^bT<=U\J4f<^D->UNQ8?7EVGIdL(dR\-?GKA<-f92U238
YE43gEI:eP=(RH)TXK7O5U53U8@/XFZ7NJc/BB[62.&dO)I]K(dH)VH<gQdVeeYH
@bc-c,f:00a5MGD@3Z9R;[5IHUXP=D]-=g9^M,e4K^(QE/B/?765d1?6TTFYJ84&
^eT8C8Kg;G+U5S1I+aRAN:3dUE?WJ])2E2:_GY#GVZKGI5F[+\d=:)DZ(+P0IM0:
,-?8-B+=N821,SeIP/[O.FIFP6ba(8Mg+\ILf5SPOR2DK.;.?,SYXWW0WJF<+(\^
4]>J^Xb8;#Kd2A-a@QE/0b5LAfK#&Qf,L1G-EE)KF:f+32ZW1@M)^OA=@_:Cg.;:
H1a7F3(gZ96c;X[<^/=+=.LQCEc\T2Z?cR3DYU8b.5;-=d<I0?7_c5^7=T?D=2bb
(K(dP&gf/KfWPcL2(PTIQT9Na4Bd4^I2TI8-M20(deZeF\M=7\MT?A8.4>2[_\@8
9V]bMd-;f5J38-\?=V5G^e:&<ZDN8g^SI>UUW(P,?.Eb3Dd#@a@X93X]MMQ)0D)Z
\dS<?)-J]OgQcUP_#IJWgX:.5<R=?[4@;9Q#F_52.0ZL97)PT)S+-9-g_@:Y]LR6
AbN0c9F&.aJ)X@_a8bAOe0]6,<MGH8:JF-QQ&/^BM]T,Z^_=OQU_-&:,7K5KgV>T
3,;/Kb(.?dF3[1f[=E(E0AXg&1EV=+V.#]d8O.BgV-<GB--,KJUQRXSeP/INgQ#g
IdTJ7FXB6P,TK(TeIO@=fb)T:[BX#?Y4G2/;f8<+gO3DP[]bad:QFG)WUeFK.(aP
2Z=<RL0],HgHOP0PDX9<KWHWNPPP=D5d#XP-/NUTTd1DfJP^95@g(<.]#KNM_K[-
6bJg3aLA5_Q_L5<TTE/Na7ZRK^5UDS<5SBE2S&a.8+MT<P?M]fbVg7XJ2.K[:A77
BBfH<Z?69PR-,FB62ZMU_0,]8cR:4[becC3;\\R]2G]X+a7FID:a)X0@+RTf6;BI
V[L-,cX)I-8-8:L7&Q2)9?_cE.2#TX?@a2\aVF)eWC=Y:;#<[Y/V(4AO]ME@99?Y
X2&F9F\,9XO[YE\)/Xcbgf+UXdEdO<]ER)eBX:/G#N.cW-=F\@W<e>&J8,U>f9B=
C=)LK3.c@0KZfJS;RT5&cG,)M[eQ-5]/W=gbDJ(NY3fT@JcBFRc2@G#\\Y@,fSdV
:bd7WQ9EP,eYRF:bF@C(0gXS.9(cEd.>([b@0G,4QJ7__KDV;:aM)?_g9_<>bb[,
--?9Y05>,@?[E7C?LSe4eR;\DM-49LJDU81^A9ZQ/_,:K5.?g9,GK5Y_c;a5VBWA
G1)Ia5F7@V^_7\:?^@#OA-=a3J5G)eMA0_;3HLWWZ.)@dMH9;)gcBJ3//2LKYT\A
5>ZOYfZ4@\GWUaM=F18)aAPJ_R203G^Oe&g;GL[;/72eIAc^N[08bT5F=d(P.RW(
=A:N\_ICM4\1QQ&cF>LH0&JOE=I#Z4Gc:VR\>[2>PM_cCf)7@K7=QN?^4Y_XHf+T
gXKL1I]@X]@1+^Y;97Z[TGR?QTbV43]<dL+8QJ?OW9BPW=4<;K7F?T[&+JQKP\WD
)fRVPC1W8IcCO4AL3RQG-GBfV(f+bVJT6AH/K<F(\A^BBMCg=Nac557C.&gJ[O92
;<V=6\Df[<X.+2#,Z35T0e/0H>9Hb(e6#I7-J4dJY4H:;KJYR-cSUL?(HY?O6+LJ
fAe)K&5Zf/aF_Z\c4[^EQQ)Z0;TRBR?<12Q9SM(IAT)7YW;(bU]Ab5NRbf2)_aWM
0&UVfbK^O6,M[CDLQMeJ:f@ba3N^MXV9Z/[@-Q&=^<g^(SB1#5/#)+C&>c[KC3:/
_W7YI5:;R4L5@;OX[)8]&MZZcWBFf.;gC_19P&L;KXLB8#/4SX64&K7B<a7WVT>Y
Q]I2<JATB(K4gU+@.O\H9KbSR8-cc45@PV(1190&B7[d9/)(>O8;N&Z9=>^CF@eF
A_Y[b@K-R,PO=8(J@)OH]gQV=KG6WTc\:$
`endprotected


`endif // GUARD_SVT_VIP_WRITER_SV

