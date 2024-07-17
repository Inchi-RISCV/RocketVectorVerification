//=======================================================================
// COPYRIGHT (C) 2007-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_EXCEPTION_LIST_SV
`define GUARD_SVT_EXCEPTION_LIST_SV

`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_data_util)

/** 
 Does the appropriate logical compares to determine if 2 exception lists are
 NOT allowed to be merged/combined.  Expected 'general' usage is shown below.
 
 - excep_list1 is <obj>.exception_list
 - excep_list2 is the randomized_*_exception_list factory
 .
<br> if (excep2_list == null)
<br>   `svt_verbose("randomize_*_exception_list", "is null, no exceptions will be generated.");
<br> else if `SVT_EXCEPTION_LIST_COMBINE_NOT_OK(excep_list1,except_list2) begin
<br>   `svt_verbose("randomize_*_exception_list", "cannot be combined with <obj>.exception_list.");
<br> end else begin
<br>  // Logic to do the randomization of the exceptions to be added 
<br>  // and then combine the two lists.
<br>  // 
<br>  // If one list has (enable_combine == 1) then the final exception_list
<br>  // is to have (enable_combine == 1) also.
<br> end
 */
`define SVT_EXCEPTION_LIST_COMBINE_NOT_OK(excep_list1,except_list2) \
  ((excep_list1 != null) && \
   (excep_list1.num_exceptions != 0) && \
   (!excep_list1.enable_combine) && \
   (except_list2 != null) && \
   (!except_list2.enable_combine))
  
/**
 * The EA and 1.0 version of UVM include an array 'copy' issue that we need
 * to workaround. Set a flag to indicate whether this workaround is needed
 */
`ifdef SVT_UVM_TECHNOLOGY
`ifdef UVM_MAJOR_VERSION_1_0
`ifndef SVT_EXCEPTION_LIST_UNSAFE_ARRAY_DO_COPY
`define SVT_EXCEPTION_LIST_UNSAFE_ARRAY_DO_COPY
`endif
`endif
`elsif SVT_OVM_TECHNOLOGY
`ifndef SVT_EXCEPTION_LIST_UNSAFE_ARRAY_DO_COPY
`define SVT_EXCEPTION_LIST_UNSAFE_ARRAY_DO_COPY
`endif
`endif

                   
// =============================================================================
/**
 * Base class for all SVT model exception list objects. As functionality commonly
 * needed for exception lists for SVT models is defined, it will be implemented
 * (or at least prototyped) in this class.
 */
class svt_exception_list#(type T = svt_exception) extends `SVT_DATA_TYPE;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  /** Used to create (i.e., via allocate) new exceptions during exception list randomization. */
  T randomized_exception = null;

  /** Variable to control the maximum number of exceptions which can be generated for a single transaction. */
  int max_num_exceptions = 1;

  /** Flag indicating whether the exceptions have been injected into the transaction */
  bit data_injected = 0;

  /**
   * Flag which indicates whether these exceptions should be used "as is", or if
   * the component is allowed to combine them with other exceptions that are being
   * introduced from another source. For example this flag can be used to indicate
   * that exceptions coming in with a transaction via the input channel can be
   * combined with randomly generated exceptions produced by an exception factory
   * residing with the component.
   *
   * Components supporting the use of this field should recognize the ability to
   * combine whether the flag is set on the exception coming in with the transaction
   * or with the exception factory. The combining of exceptions should only be
   * disallowed if BOTH flags are set to 0.
   *
   * These flags should be reflected in the resulting exception list based on
   * the outcome of AND'ing the values from the combining transactions. As such
   * enable_combine should be set to 1 in the combined exception list if and only
   * if it is set to 1 in both of the exception lists being combined.
   *
   * When the exception list at one level of the component stack is used to
   * produce exceptions at a lower level of the component stack, this value
   * should be passed down to the lower level exceptions. 
   */
  bit enable_combine = 0;

  /**
   * Flag which is used by num_exceptions_first_randomize() to control whether the
   * exceptions are being randomized in the current phase.
   */
  protected bit enable_exception_randomize = 1;

  // ****************************************************************************
  // Random Data
  // ****************************************************************************

  /** Random variable defining actual number of exceptions. */
  rand int num_exceptions = 0;

  /** Dynamic array of exceptions. */
  rand T exceptions[];

  // ****************************************************************************
  // Weights used by the constraints
  // ****************************************************************************

  /** Relative (distribution) weight for generating <i>empty</i> exception list. */
  int EXCEPTION_LIST_EMPTY_wt  = 10;
  /** Relative (distribution) weight for generating <i>singleton</i> exception list. */
  int EXCEPTION_LIST_SINGLE_wt = 1;
  /** Relative (distribution) weight for generating <i>short</i> (i.e., less than or equal to num_exceptions/2) exception list. */
  int EXCEPTION_LIST_SHORT_wt  = 0;
  /** Relative (distribution) weight for generating <i>long</i> (i.e. greater than num_exceptions/2) exception list. */
  int EXCEPTION_LIST_LONG_wt   = 0;

  // ****************************************************************************
  // Constraints
  // ****************************************************************************

  /** Keeps the randomized number of exceptions from exceeding the limit defined by max_num_exceptions. */
  constraint valid_ranges
  {
    num_exceptions inside { [0:max_num_exceptions] };

    if (enable_exception_randomize) {
      // Keep the size at the max -- post_randomize will insure consistency with num_exceptions
      exceptions.size() == max_num_exceptions;
    } else {
`ifdef SVT_MULTI_SIM_ARRAY_OR_QUEUE_EMPTY_CONSTRAINT
      exceptions.size() == 1;
`else
      exceptions.size() == 0;
`endif
    }
  }

  /** Defines a distribution for randomly generated exception list lengths. */
  constraint reasonable_num_exceptions
  {
    if (max_num_exceptions > 3) {
      num_exceptions dist 
      {
        0 := EXCEPTION_LIST_EMPTY_wt,
        1 := EXCEPTION_LIST_SINGLE_wt,                                      
        [2:(max_num_exceptions/2)] := EXCEPTION_LIST_SHORT_wt,                                      
        [((max_num_exceptions/2)+1):max_num_exceptions] := EXCEPTION_LIST_LONG_wt                                      
      };
    } else if (max_num_exceptions > 1) {
      num_exceptions dist 
      {
        0 := EXCEPTION_LIST_EMPTY_wt,
        1 := EXCEPTION_LIST_SINGLE_wt,                                      
        [2:max_num_exceptions] := EXCEPTION_LIST_SHORT_wt+EXCEPTION_LIST_LONG_wt                                      
      };
    } else {
      num_exceptions dist 
      {
        0 := EXCEPTION_LIST_EMPTY_wt,
        1 := EXCEPTION_LIST_SINGLE_wt                                      
      };
    }
  }

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_exception_list)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception list instance, passing the appropriate
   * argument values to the <b>svt_data</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   * 
   * @param suite_name Identifies the product suite to which the data object
   * belongs.
   * 
   * @param randomized_exception Sets the exception factory used to generate
   * exceptions during randomization.
   * 
   * @param max_num_exceptions Sets the maximum number of exceptions generated
   * during randomization.
   */
  extern function new(vmm_log log = null, string suite_name = "", T randomized_exception = null, int max_num_exceptions = 1);
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new exception list instance, passing the appropriate
   * argument values to the <b>svt_sequence_item_base</b> parent class.
   *
   * @param name Intance name for this object
   * 
   * @param suite_name Identifies the product suite to which the data object
   * belongs.
   * 
   * @param randomized_exception Sets the exception factory used to generate
   * exceptions during randomization.
   * 
   * @param max_num_exceptions Sets the maximum number of exceptions generated
   * during randomization.
   */
  extern function new(string name = "svt_exception_list_inst", string suite_name = "", T randomized_exception = null, int max_num_exceptions = 1);
`endif

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_param_member_begin(svt_exception_list#(T))
    `svt_field_object       (randomized_exception, `SVT_ALL_ON|`SVT_NOCOMPARE|`SVT_NOPACK|`SVT_DEEP, `SVT_HOW_DEEP)
    `svt_field_array_object (exceptions,           `SVT_ALL_ON|`SVT_NOCOMPARE|`SVT_NOPACK|`SVT_DEEP, `SVT_HOW_DEEP)
  `svt_data_member_end(svt_exception_list#(T))

  //----------------------------------------------------------------------------
  /**
   * Method which randomizes num_exceptions first, before randomizing exceptions.
   * This is done by doing the randomization once to isolate num_exceptions,
   * then again to isolate exceptions.
   *
   * @return Indicates success of the individual randomization phases.
   */
  extern virtual function bit num_exceptions_first_randomize();
  //----------------------------------------------------------------------------
  /**
   * Populate the exceptions array to allow for the randomization.
   */
  extern function void pre_randomize();
  //----------------------------------------------------------------------------
  /**
   * Cleanup #exceptions by getting rid of no-op exceptions and sizing to match num_exceptions.
   */
  extern function void post_randomize();
  //----------------------------------------------------------------------------
  /**
   * Method to turn reasonable constraints on/off as a block.
   */
  extern virtual function int reasonable_constraint_mode ( bit on_off );
  //----------------------------------------------------------------------------
  /**
   * Method to change the exception weights as a block.
   */
  extern virtual function void set_constraint_weights ( int new_weight );
  //----------------------------------------------------------------------------
  /**
   * Method used to remove any empty exception slots from the exception list.
   */
  extern virtual function void remove_empty_exceptions();
  //----------------------------------------------------------------------------
  /**
   * Method to remove any collisions (i.e., exception vs. exception) present in
   * the list.
   */
  extern virtual function void remove_collisions();
  //----------------------------------------------------------------------------
  /**
   * Method to inject the exceptions into the transaction. Note that if
   * 'data_injected == 1' then the exceptions are NOT injected.
   */
  extern virtual function void inject_exceptions();
  //----------------------------------------------------------------------------
  /**
   * Method to get the specified exception from our exception list.
   * returns 'null' if the specified index is out of range.
   * @param idx The index of the exception to get
   */
  function T get_exception(int unsigned idx);
    if (idx >= exceptions.size()) return null;
    return exceptions[idx];
  endfunction
  //----------------------------------------------------------------------------
  /**
   * Get the transaction exception factory object.
   */
  function T get_randomized_exception();
    return randomized_exception;
  endfunction
  //----------------------------------------------------------------------------
  /**
   * Method to add a single exception into our exception list. Insures that
   * 'num_exceptions' is updated properly.
   * @param exception The exception to be added.
   */
  extern virtual function void add_exception(T exception);
  //----------------------------------------------------------------------------
  /**
   * Method to add the exceptions in the provided exception list into our exception
   * list.
   * 
   * @param list_to_add Uses list_to_add.num_exceptions to see how many exceptions
   * are to be added and uses list_to_add.exceptions to get the actual exceptions.
   */
  extern virtual function void add_exceptions(svt_exception_list#(T) list_to_add);

  // ****************************************************************************
  // Base Class Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Extend the copy method to copy the exception_list base class fields.
   * 
   * @param to Destination class for the copy operation
   */
  extern virtual function `SVT_DATA_BASE_TYPE do_copy(`SVT_DATA_BASE_TYPE to = null);
`else
  // ---------------------------------------------------------------------------
  /**
   * Extend the copy method to copy the exception_list base class fields.
   */
  extern virtual function void do_copy(`SVT_XVM(object) rhs);
`endif

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Compares the object with to. Differences are placed in <i>diff</i>.
   *
   * @param to vmm_data object to be compared against.
   * 
   * @param diff String indicating the differences between this and to.
   * 
   * @param kind This int indicates the type of compare to be attempted.
   * Supports both RELEVANT and COMPLETE compares.
   */
  extern virtual function bit do_compare (vmm_data to, output string diff, input int kind = -1);
`else
  // ---------------------------------------------------------------------------
  /** Override the 'do_compare' method to compare fields directly. */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);
`endif

`ifndef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Pack the dynamic objects and object queues as the default `SVT_XVM(packer)
   * cannot create objects dynamically on the unpack.
   */
  extern virtual function void do_pack(`SVT_XVM(packer) packer);

  //----------------------------------------------------------------------------
  /**
   * Unpack the dynamic objects and object queues as the default `SVT_XVM(packer)
   * cannot create objects dynamically on the unpack.
   */
  extern virtual function void do_unpack(`SVT_XVM(packer) packer);
`endif

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation.
   *
   * @param kind This int indicates the type of byte_size being requested. Only
   * supported kind value is `SVT_DATA_TYPE::COMPLETE, which results in a size calculation
   * based on the non-static fields. All other kind values result in a return value
   * of 0.
   * 
   * @return Indicates how many bytes are required to pack this object.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset, based on the
   * requested byte_pack kind.
   *
   * @param bytes Buffer that will contain the packed bytes at the end of the
   * operation.
   * 
   * @param offset Offset into bytes where the packing is to begin.
   * 
   * @param kind This int indicates the type of byte_pack being requested. Only
   * supported kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * non-static fields being packed and the return of an integer indicating the
   * number of packed bytes. All other kind values result in no change to the
   * buffer contents, and a return value of 0.
   * 
   * @return Indicates how many bytes were actually packed.
   */
  extern virtual function int unsigned do_byte_pack(ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Unpacks the object from the bytes buffer, beginning at offset, based on
   * the requested byte_unpack kind.
   *
   * @param bytes Buffer containing the bytes to be unpacked.
   * 
   * @param offset Offset into bytes where the unpacking is to begin.
   * 
   * @param len Number of bytes to be unpacked.
   * 
   * @param kind This int indicates the type of byte_unpack being requested. Only
   * supported kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * non-static fields being unpacked and the return of an integer indicating the
   * number of unpacked bytes. All other kind values result in no change to the
   * exception contents, and a return value of 0.
   * 
   * @return Indicates how many bytes were actually unpacked.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Checks to see that the data field values are valid.
   *
   * @param silent bit indicating whether failures should result in warning
   * messages.
   * 
   * @param kind This int indicates the type of is_avalid check to attempt. Only
   * supported kind value is `SVT_DATA_TYPE::COMPLETE, which results in verification that
   * the data members are all valid. All other kind values result in a return value
   * of 1.
   * 
   * @return Indicates function success (1) or failure (0).
   */
  extern virtual function bit do_is_valid(bit silent = 1, int kind = -1);


  // ****************************************************************************
  // Command Support Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command
   * code to retrieve the value of a single named property of a data class derived
   * from this class. If the <b>prop_name</b> argument does not match a property of
   * the class, or if the <b>array_ix</b> argument is not zero and does not point
   * to a valid array element, this function returns '0'. Otherwise it returns '1',
   * with the value of the <b>prop_val</b> argument assigned to the value of the
   * specified property. However, If the property is a sub-object, a reference to
   * it is assigned to the <b>data_obj</b> (ref) argument. In that case, the
   * <b>prop_val</b> argument is meaningless. The component will then store the
   * data object reference in its temporary data object array, and return a handle
   * to its location as the <b>prop_val</b> argument of the <b>get_data_prop</b>
   * task of its component. The command testbench code must then use <i>that</i> handle
   * to access the properties of the sub-object.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * 
   * @param prop_val A <i>ref</i> argument used to return the current value of the
   * property, expressed as a 1024 bit quantity. When returning a string value each
   * character requires 8 bits so returned strings must be 128 characters or less.
   * 
   * @param array_ix If the property is an array, this argument specifies the index
   * being accessed. If the property is not an array, it should be set to 0.
   * 
   * @param data_obj If the property is not a sub-object, this argument is assigned
   * to <i>null</i>. If the property is a sub-object, a reference to it is assigned
   * to this (ref) argument. In that case, the <b>prop_val</b> argument is
   * meaningless. The component will then store the data object reference in its
   * temporary data object array, and return a handle to its location as the
   * <b>prop_val</b> argument of the <b>get_data_prop</b> task of its component.
   * The command testbench code must then use <i>that</i> handle to access the
   * properties of the sub-object.
   * 
   * @return A single bit representing whether or not a valid property was retrieved.
   */
  extern virtual function bit get_prop_val(string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);

  // ---------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command code to
   * set the value of a single named property of a data class derived from this class.
   * This method cannot be used to set the value of a sub-object, since sub-object
   * consruction is taken care of automatically by the command interface. If the
   * <b>prop_name</b> argument does not match a property of the class, or it matches
   * a sub-object of the class, or if the <b>array_ix</b> argument is not zero and
   * does not point to a valid array element, this function returns '0'. Otherwise it
   * returns '1'.
   *
   * @param prop_name The name of a property in this class, or a derived class.
   * 
   * @param prop_val The value to assign to the property, expressed as a 1024 bit
   * quantity. When assigning a string value each character requires 8 bits so
   * assigned strings must be 128 characters or less.
   * 
   * @param array_ix If the property is an array, this argument specifies the index
   * being accessed. If the property is not an array, it should be set to 0.
   * 
   * @return A single bit representing whether or not a valid property was set.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);

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
  /**
   * This method is used to safely get the current number of exceptions. It basically
   * chooses the smaller of 'num_exceptions' and 'exceptions.size'. Note that this does
   * NOT check that the elements in the exceptions array are non-null.
   *
   * @return Number of exceptions
   */
  extern virtual function int safe_num_exceptions();

  //----------------------------------------------------------------------------
  /**
   * Populate the exceptions array to insure it is ready for randomization.
   */
  extern function void populate_exceptions();

  // ---------------------------------------------------------------------------
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
=-R#<A:9(X2H))3+)6g>:(Ff(]X99/QcW)?I8d=E&]+^;CGR,1E=/(e4(233>G3P
dKI>]<)gP9QPaFW1=P[=OMd6]#46ac#N=RKWaBa#\gN6REd.20TgBfF(K#H#eb\;
MU>,bPM=7)Z&Y6S9_0>,E8Y<;#[YW)[>J7EHU--7;#.X4TdH[gFOP:Y^=7VcM3YZ
#>5GG:eC3U.XHM9Z.[b=[AAc)=a)-d?RCP[5_ZI8/8WJ2f5GggB/Y@S\a.PVVDM0
2_Nc8FVa(gT51cK/<F_0IGS6V7ARPWXZ-.1Q0MWb8;&>#^/T]e?8[\?X+LG,BSWa
Cc)LbF18Y29(-P2(5)g]5O)BNJa:XJ,-[^YLH5eMfI:TJ@eaK#;^.HJbH+#HI?B^
@++,K@D]cbFdBIUN,7,GQ_[WJ:..6-67:/,4LSQBdM\?YBY[:[DJOUYH05eOR/_8
0BKM#\0H<^=R&-SN#M+P_+_eV].W^A0VR=Q-B4e/;-cTU,d=?]A1:YG1B_<A4M(c
(LNI@F&H_PJ;1E]Xe2#Lb()EZXSD/S_f<XK?T2F#34JaNT.05N<_J#65gaAF6FD<
ZTCHV-I\L[eQXR)Z/BJSLF#cZ&#)3W=cX(.<e#RJ,aD0(@4AROP.)<.U,NN9](17
V02=JPPB@T[(?D2,O88U3DC[cI+X:DBA&>J\YO,X#[gE+CURLR^D)7=7D1YP7U02
)2RZ^7C:O=53/,?;MM4L<d/c:7Z-aS?Z,dI1cVg?7R7UT83+S(7O74ZQ:T5,LS1;
#1SH[Acg@Z92@?B3Z14GP;g9HD3#)PP^1UF2F:[4LU=5S>4Y8DSLaXGaY;V8C[CW
F,OJe1dG:B@gV#]^Gc;:b7Lf)Fcg97\fL<NE&Q1N,-(_-3.K/e=C7HG+SBObT/(5
YOUZ5.(F+gT,PGRZ>c4XOdRb[U^D;fHce4].f:;b:<2\RSOc-GfDbZO;BT;6=S&Y
^?821I/J+)BAQI.,S5H+?(>DFEdH<c=fK>f[?+?]#5=@c/QO,gW]7;5TZ_G/D#?^
gM0:CLdSJL]S.\5+Z9H66PQD.7U-+_OM1O==7LdJ=Y.3__^A^DP1Dg/Nb7g;CUZE
HN>34RGZ+Q^9EJKP/+T1eNDe(0>-H99gV/TY8fOPO9L:@,?YIRO#)C#<.I\/>+<.
ZMH7Ze1,\[NM@]E6M[(3U44eJ(/??a1[:KBdd^7?)+c>8cQE;&\PFW<9UO7:BKU?
X-La(8-4U#]_f=SggRF]+W+,2:e7fRKO>[V@-(Z0P;_WgVfI9TR:#YX^dFEX:-87
>27APQ]_e^I2+PX)I@K<JLGDbZT[7[&WDF80abd,RYA5/@1;-4(B#2\UVaC)6<-(
I[H\TaWRAIE98154+e<CE2,eY@8-[Z(IY__8c[>;53E=eT_HQ4]/&D9[[PJ-52<8
&6LgFPb;8<)J2Oc:+/YFVQ-<W)55e8TcN+67>2,4aR3T:_Q=&24bAVP^>cK,W;&K
EX[PN)IZ&BQ8M<Q#,,1Af#C5Og,M>S=A7RBE+__JT@1@V6VKH)]_)e+C?5UP\gXP
CI0O>O4C@X,-Yf05b;WOb1:8DTDbQPIW9Y<OeJ.1d.dYCEN[)HX_>bH#fW7U7/J^
[OSJ8H)&V3O[0_2Z7[1RB/]?W9&&PE2YEHcA9RWPO(R2ER9X1>M=+cM+C[;aAP0c
D+9&I//\V=,I<&CJfP1M:Y8<R,AbH\6@HeFTYYER0@5IENMJ2QU^AVPXUKE\X@]F
S@\DTHX,bFf3Rb3#[Ga;-dJa;+J)g)YM,7LYGe9dHc<QVUKJMF1_4QXMK-c1+U^:
:L:E25cA<;eB:8_145]fF+HJc)8=bS&\eKQ#cUT=eJJg#-XM[TWd]3#ZAU#O7[=.
g6))Y=R,6GR4Ca\K=OB_.&1WR.Q&[Fb(?62-cOA^]>?+a9G6a@]R\@EBE]MT34O:
J;NL?(BMd]L]R6R&QC[P63G][UBE2L3Z@RT>3;/<8d:DE]e5:\?]6fYACaF:,PVf
F_,F)GVb@C#&03H?=HV+?.EF@4G=TQg.#=EKT6BFIZZB.D;EEf>d@17@gUbPR,IO
gb-@KfdD0@.0=XA]L>F2:L9?Ie^#cXXGWGB<[dM-F@^&+:/=d.DNc2;X2<Me)RY_
]d83aV3-J9D8H0(Feg:1AX73P/BXX1D.?_+GE3BT\X]RMf_MX]V&b91TOOSE#UZE
5<3R.3W_6P,I+fdK]J+27ZQ&/Z0@0EJcEKOD:GF_RM>3S5)5,K4#)?DF-)aQDH\\
,7FHNYR@cL>O@Z1;Q]d&-XEZZNUF#YH,cSD1.(a)_#^L<c<9][f(R8(3=[,T1B#?
/1/C/G+V5_(1MF,.MW7(G=PS+)AN=S[PDS7KV1f>=ae)Wfd8RUD;-=\?A4<)X=>K
)]B4c_cFd&OIMK1;C-&Zf6=SIee-e_-YD[G?-N.MOQ]U-,S_S.BeYA1L>-cc>M:e
Rc#5.5@[U+]Ge57#-TGT>UE9FMUd9dKY5ANM6@>6LTXLKBgXf9Z16OK+5<QC\VK;
VL7(G<93RZ46/IUW.X\6GHX+N4UD_e@AgE,E=(V#5#X[fJL.=1?Q\5aX@?B-?;&I
)Z)5P/8L:Y2RSfJUU&.(GJ6WMT17?#WBS<>L1OAaN6,)aXSN--La(JCTgLfSI?7X
OWSNY0X7WI,6C#51C3aD1J7#T,T\LQ],S[8GMX<(dH.>,<=?7MGU-C4cY=]b,:3,
Me],^fL_(PF_->#706K[55P5BaEA6M1+3fbI9d?9cLd=2Dd=^Q(>]/FbA1NBV/D7
d#CWVVM<65EU@DKM,8&@Y66B@L0V737^&7[32Hd3F5(H4g8N\>a2SB.&E^]<LZ:f
6-eE]:#F2Zed4SSg>7)=ZQ+98E=[XHY][YR01_@bP/M0&1be9-cAYM\&>YQdCYO@
D4GF2b@ZA8V/=\\N_-U7MY\U20e[[_f1E&7<SHD#KENOGU=e#XAWNXA2^&(9GANf
-cXf/5D0F8U\]>&9PMY7=KJQ-a\-.X+-8eJZ4:XLaC(WK0XX7\P.N8>\;YYBQCTE
)]JeC:c[Z9)ELZ1]-cEa\38/8;IIf]D8L,a0;<.gVfX//C)D3P(1K[9g>P:_;-,c
)2A.AC#1C7RKY_N2af\a^\>>Y6/M&I:T73\.bf#ZI_5H[KLgDcE81cc\RgSE8HML
Q:;4@W4e4F#YR]-/0DT05+.5;V[E@7,1+FMg6daKHJ=_,^7#a?LeMF=RFc7JWXQe
WG8YWUfNZ-E4ZU=-7AM0(9CUXT#S]WM)5Z(MBTMXQ&F2)F<bU3A:dVg<d,]YH1D>
&/&UNJ/D)4<LJ=:TYb9F:@K^RM1O+Z<a6e75[=^<H8TgXNe\QX&Zd@d8T=7c<]G5
+.O7D3WDH_)Qcd:W)[Q:fK,c0aB;8]:^O[&3KAJ^CKaabdSS.Qe56&ZRWMX83K_8
]C917&R+(X?a4)XX@:TK]ZAQ].f<GTA,,J\X,)+H9=@?Wb#YP([gA./R9N99V(ST
f7ZR^XX/=8<CgOV&O.2<HY,]&cAaTgHE9Lc^_]=:77,L]A/YGdJ1<A/Ve-=fDa]+
6bc6\fMLJ:7=>X-[EXV6+H9M/G6a7DP.E0EL;Ya?dDC/O3T\SEP8?/Ba-/-D(CFJ
>KKffJV\I.PAWC>c(;a3eDR^:K?V.T9\SU3>#./I(BW#/e(AMK;d/dg98U4XP6&Z
F_g>2#L=N_U:(1HS\OZcGaYG\e[cc<5H<(a/ZXDL).D>GE?d/fM\1.^N^C\/5Za&
Z\&g,I2_3U78\7?K_d2C>/UUJZ-781RG9a[9W,):K37--XFU^1:;<bOR7YbaUadV
_X_C1R+APY/Y#77G=UH3NP:a10YGAM:_^2.;)N4XMg@PL)<XG(cX[eA=5DO(0f(6
=C/QS4UL.SW8-+X<bS56Rg>AR+;aLbW?A(@#/3R3..//LI@W.g8.^SQ/]/FEc#6Y
?GWgJ4Q8BW@7NMMJ1ENL>)TD)6X0__/G(ZdF=1e1c03M.I6e272^Q]_;\QLd+@F,
dTW8J?FDgACWO>d&[=P1RT^HAX]R2@H.A^E:S&fQBgSQR:/1G+_e<[AgcNOb9&1O
UD^?H,fY99,I_13f6^f\(&D#H,9dLaD9=INRa?<TbW:R]eRMEA:R.^,Ogd/deN+7
Ra>3,f;V=bR>WaG71-)bY&F=f_</EX9F5AG2TdRBW79,W(I/_GZgaf/L>E1@ReR?
?+>1e173A3:-R:e\K>Cg&(:eD2;NEH&&NNIPM=(_K#HA6D;\N#<2W5BUTF_d>ZYX
b_e>/^7ZQ?J>0FIGM\-F/JJP9=6RJ,&eT#S9W[HCO2S?Z[=DN)(c\HXcDN4;V\&f
(&^R]<6J=SKS3?WHV/HFRZSJgBbCd+A08_a)ED)7^0[8RBU)URPHUBFdg>DK#X&G
Q7:Ce@Hb(<[QA2Nb:TZg[.@BSU:NOFTZD5(ZLO1KYZ/4UZ6GD#JfXe1gA@?G-C)L
BSb<ddG?09P:cbLJ[#NUS9>U-GGJ897]&-)efMag&><bU84IU3DZDZYG3-7Kg79;
41_:=b/;;^HB/SVH,.:^JE5^J_O=BB9fQ,YK/bcUa?Z?>@7A>NHeBNUc@6]N.G=3
(VMK/a#=2M6#SPEOW.b(.72=39\YMFf.e(:@HD^]U4K;FD:_/:(5N7]9C_:V1(I4
>A_,YS<A1;UdS&7+7Cg2E=5GE+F.,;?&<gG521(]SX?+e_7RN[B97V]#+g#P.[)D
][Y0(:^3+adCG-ONf+PeL]C<1d8cY-Te9=C)dSUeB2QB_7.S/?A[4HRS?CPg^Q<C
542F&)(_&JbV#1#9gUc\F8)\9Y<[3GMS56>4(.#;O43]T&9@>fNK753(;VFN#SLK
cLCI0CF^R)<fF</BcE^0T.Z(R/:HWSWC#3:5Q4Y8W/+HK>NBWD?2[._>[D4b-Q/8
Bf<@<4g_&4X;H;c\Q3HKgVP=#]5((6gN<fM;KR,U254)/J-KOdf/EX@?Yg:eO=dZ
A\M^L^(1>;?bUMHM38?YA:c(=S&c?M7.VB(EbfV-Z3=)40]KCQcLCX\O+6aTBS3-
GD@Gf_<<J><TU8e&3d[d&C+IC5^MPb>dQd5)=N4US>()HdeUZ:MHbK(J2>,e/f,/
+OI,BdK\6+0RIa7+492R0G>C.4@@MQ:L_>E6MBfU^5/.AB;6(\eXJe\bQPOEPSSH
R=&b968^UGc[SZaFY&9L27<&_AfKLgT^5<F61TUK:5Z<0Wc\K1M5FA,e_S9])2XV
debQPBDAKEBWF9.^WIXVIGH;CI2^JLMFD6a2+FLM6d;3Y<CS@9K)Y?Lc+JPY59U-
67MHI44<-1>WOF+b+#W)dCgGIPeCU<_>DZTEGgA<1&O6<-PPfS(-59],-A?&gdP.
^(cJ&c2+H-Z,+)WaAe8/WSW)]S[gP_JDbZg\,A@2&I8NZ8^/6;:eg3#d-IA:?(1I
4X,;41g_HQBLOCT:ARJ?5;0EH]EO;@?d)H]\3AD46C/O+VZUM\V]G)W<XUa>DP4?
bL;c2#Z)@E_AO;/PZ4;MU)CH]/A5deg8+<KcHY_N2<IV[Y;3Tc1/-=F8\MM-5R4b
8d5YNA5_((;L_gaFC@:)^OD&O;L\eB^EE3BDSG54<Y9a[SgES]0+)=P7;(BGeF:S
^IG=,,_/E#VbNf<\0;d0DHg/2@P/9Y2EL#8CJ0Mc[^F@3(K]KVE-U@Ff2N75+IV1
bO\2VBU6#NIaTDB+S6e+dT^ff9&EB2&@E4]edORb98S\WEb_7TMa,LEQgNZ2_HNb
[>>_9,(:&JMSaAd/]WSA3&_?B^QSH5<B?XgJ22O<ZF:XMf5>=CQf:U8EM&)^YM(g
C18=gB7:aB,)8gV(S]a,GFG9cgAZ=3PMf3.\W\Ye[d<Rf/&#38(0]aI_:d2=1DWW
0P_9b5WbDg4E,HBP,=06>JA;/If/#@\3@HF4a0ESKW=JQYg;1aF<@^FJ&d_W8cX5
]a_(=Ud^U1<=A=#<B+Se+4e,7QH>T3H)V]a=2XRFe2Xb^/.8c^-N5]WOM\0EN-)K
&A/=7HH&<S7[0=8a=?<IF(#),TN>PLZSNdg],bf+McL(<D=++cZ[U4K9EQ:^/;2>
S5^?PD4J9<_V)[e3a_(cefb8a09X\g9R-0M41PC?A[3=,\Z^F-XQTE#d<&g@Ic;1
eD1Me9ebX^UY4P8T,(YdW;R/NQb1:<GSSg@=-B1(Xd78ZS=5b.O9Z-O8,AN&3B/K
g>N?JQ_b0)IHFRH07<8K(I9cCLE5g:S\/HfN4MOZ+^fJJ0UWBcP_7-LVE1P-Jd&B
)EPe(QSQ&>,N8ff1]f4N+;[Y61Y^d#,Zd/_Q/=DSA)a3?XbRY1X2fbE#:FT3+H,g
E=JC.OfWCR+-GId(?aN^MBA017=)O@5ee2&Y09F\3T,Sg#Y&TU0UIC/M-XT4?+DL
4K38D/bcJcM]+O?-H\NBK@M9?[UB;TG.4Ec&CadG5UH-J-L1b:f^[?3=+A/b=K4G
M//M/<I5b;.1NA]ORg2Kc&V-K6eMb:(:SP4BBDN.S7Q3aEd.>>BG4&TIGe=C&EW=
/O2VYH(,6Y)P)?>1XeMN=E0A[-S^9EZ0AGNgKQH7>b3)J):gM>WP1P\.9+/MPc@3
&W.d,)=#A0Z?BO,8Tg^U+__G3dfIJ0OA=E:288Vb<J^dbG79d\dNE9/2b6]:HI.F
2fTPW2b@EC7/IaCPQ[II=;Wb&,]8-TgP6aJAOHBC4^IdMg#KL.RMYB^@g(+CaE[&
Db]<OgW8U#D\=,=A19/7T8cgggb_Z)e@T.),9eC.KPWXQ6N5\7,I?9N#1MM<<=7Y
VKCLcV=\gN_FIdF)-?5QPe72+0NJa->TQYe]_3D]cgMZ@;cG::\V1YN,:G3Tc8:-
7dK81NeJCYJUU#<J3EA)/?SV?-cA?OKR:SU)@HU[X)QHHd+H[_0PQP=Ea?<VJ/KH
GOg[VO1SP>g:+Z]3?)C>H;Vf9LTBBd7HN.R.3J;6eF\9HY&Me.Y(:,\a06/Ff&7.
-6AM@A@g_E05C7DOZ#DYOR9^S@::LHf?S;IVOT;JTWS4FYX-,\#e>&(b[f^^:@91
=F/8OH=S?WV,<T,g.0DCQY949e^QM^4M]D[PWAT@dSC<?NBLeP]>.ae.\766[a9B
cTPU\OMI)OUNK^_d6H5g:/RC92VYb;O\R,<b;-CVgbVP39^g#)Q1)_=(EVK@PUbc
:,R(Ad/NX,T4YKV,9X^@G>S8)>WSbdJBcH)1,a4XH9baUA0L<e5/IA[^(e+X=#c@
8?^RF,TZF[N:C1A6LSEDeBReZB^KG<.Z5=22L=;),cE/#+Cd.@;PK)I.f&B[OSM4
-YLa]7c6LMKP&5VE-1I>&OO6TVaFT#,e@X^MP>4GLcHaA:V5_VWL?,K4f2I.gP)<
VM.+XaSUUdcD:(/FQ:+a?)HGU];-]RXPF#6<31bc#ZWeR3)Ka&&b^+7.R+;P9AIg
0g^HOCZQ2KS;G-3PG&7#B?S1RZgL@>LC/>LF#@D;[#^d+dW\3MHd<.Z-Vf619AL8
:V>J6\^/19QUC;Oc@[Y^?Q_gCVRRaQIg65W@BBBM1^9_45P>B+7V&P(c^e@L4->R
ceNKJ;DJ2-7e?1fDL><1H1&=V,QM.=UXTT[9S\TgSK(,V;-HJVa;DGKT4PM&eGaN
9D2<#06T0#@9T0ZVC[fU95)84&,BSZBH;S6X6WD5;^96RJU2>1E<_5)Y),6a&\ca
)^:N,Sg]^,+3T/-3WPc^c<<2D;V]@g,V9a+#&@O@>V-\?d:4HNU)WF6RB6YVI#;Z
21VGW-E:bba]4WW22-@7[L8?C7\DOVc5DC6U-IXHRWAc>F?KN.R/X;aK8DY(N=X0
QaW6.\A:_/LO4ASEF6DGY+Vba;P(Q3=O\C2?Z9N+GJaPd.eYTQgNVc4Nd^456\=;
OE3)-W1(Q7_RT,We6D71ZU(;0M(>/fD#F4JbgE=Q8=>JS1C)4Z-(P4?#/?3O^O9[
2FFX#\QfWDLg6aZ:dR)&@2eb;T3(eE23JT/\g1^Z7N6Yc^4-_&X=9G,;/MT<OB:K
X9H97>;QPZfg+BP0UASKQ:,5CcE(d\2T01c&f-Ue)._?(a59XHU.aa_,e4O)3P<A
0,2DH@e[)ED_J]7M:UQFb1L<E53Z)3bfdJcFH;S1?#OFK#,5P-0Z^DQ,]K.4A:=1
W],a)K+^Z0@OV>(6,15,,5Z@6<)ST4fG40aB];eW.JP^J&<EaN;+RDQAe\FJ+B1C
Z<]=#F2NP^eH<5<e\9B@?PBC:LP/J+S;_)TdV5_P1?2SUKLe/Ha&?efIJ=M7JZR;
eT(Kc&(:[>c[F&O+CY[AK=T,;6&Rd=a;AM_?0X,TVa]->Y(\5=M+T&KQGT-H>:^H
4&WcaC/^B@NC,Pe?FF^8gcW0\+^gd^8J&b>?TCJ&/44>6&9K[]&P,;6VX_.U95>/
IL,SKKY2Y0CJM\P)M?#-)H)3L,_LK?df+PR^e0^I.GA>7)a45_K^]Y8><#.a.374
?dWgO++M\^(Q@D9OLE9T>g:-9VQ1EHF\IS6:_P+=I-#HI@6N1X0J6(<F18Y(\9G1
WOBeH[?G@2&BUSF<=)\(C&M^=E[IJ2Kg7H&@D+4JgO+/>dHUG;<;EX8;S;UeN6L]
DMYf14\_S-BF8U2(9HFHDZXab[M^H;g2,Q>cIONVCKB@eTZ)A:JPe5)7E=Q&PD:)
\:(gQQT_L\b:C/([]4L6cWR=[S+f3+4L<&I0,W3LFUEaT0_TBO+,Af2=LW[7UcF^
7M^42Lf^IWQTFX3:C.L;@eDIA5=WZ-XbPGSJWB8CO]UbTTc?VF6/VEV8fP/[&Q.@
PgUV-N#?]ZX12X_<D4eecAX(/Ff5-0W7QPH3/I=P+&_(]g9XGTEf.=J0]UP;?gD7
X[^::F(85e26W/fFD]^_KM5OEcbg\E5+OP7YEQ8RB-W>S[9d3PX60DBW27.ZY6&]
/(VV/(F/Sg@)fQZI?0,8PX[^6^OeX@LY5)c=VK]Pe/UMLf/3KN8dGggfK8D^P2UL
f3d<gbaN,VeTe3E=>)E_^>;Yd2L5@?PbNK+C/e#Y7NcZJ:JdDATLR^7&U,M(e9H<
[=&cZf>^b3TJgX[2<3Y,86?G#35=D:CdZEJPB9L5;\[d@R5OBP97+fX6FLcD-gDa
C^S>f#7>T&<;@@M86MKMP]2V8#e^)e8OBP0@a[5-.FV<VEK02-LX:@@[eA8Z)8O>
5.-VAU\_E24efQgXLM=&V]2&2GGTOH936X1a;_9];O4e99^20Z>+c+/Q3YCEL0S=
7KfN;[XFY?N)Z.1RS+Cb^P+MD0>TDb3PM3Ya.7KIeTOfVFBZSRe34D;<-&LL4]GM
UZI0W6W\4-P?bdT?FCT,RCSgX=P=03(+bS&4WEa_U_MSWA]80BH7U/6I[5=0>JPS
Jf98B-aNb:Af<^KSgG?Y[?_&N&>2/@3+McJI4GW/L4W[5DB;]+[:X&K9X4QCcda7
)QLCSHDUTW[>3feRY8@N2C+F1A>L5;+K4D\;YN?]D@Dd-V_c2S9L87(:TbHCF@9^
Ua&HLSEf:JDMVADS3Le1SSbK][I3)a^JM6JcLO)Xd]U(=J8B5fV#Pe&1g/[VJ7+c
)1LR^V/#/&]>9\MCG+G?,b8dUdHERT#aZa5@W2-BC43Ga<QOGSDAIFP>H+\CAW?M
XR-W#?):IBPUb@C/GO67AJNf\NL/__D\=/_0J\=_8-+?\6NEVHO9LP(GI,OeeM[N
V7D?[]PFa0NffN,OFMJ&8(R&IFI\WE1QZA50b?d+K<3\KD2U\T2G2HEX#Xa)@.Me
PgX,0cW(MDPaQA78Y.(Le6E2Cg-a=MTBHAW(9KGZISFFc0[I,CNNG]-PGX[U\<H)
-=Q/473BgQa03Y(egea5;[7X78?Y0)P4K[7NPfNGeQ9g?4[=>)S-<BYAObU^N40U
5Tdb-:#C4_cE0U07G@c^&VC0E?^-a[G,=,S]KA0LJ,QZR)WTOI9A?V+a_5@-[#+b
c=A.F)4<BJ_&:)FT;]C=_]BP43+U>3IC7fM5F:<VHD=YFQ00O[@KDH04WKb5Xe:\
+V1\CbOb<#e@/b<SJEFF_57HX85dag#]YOdXge<EGA&IG=BQWK,bcK)7dD^8AE-9
U\]96A/QSJ(c@IS7R;.Haee?AG8GLW;Fb;8g4C[]KYb?PBLOG@=Z3&bFX[-P<>8^
A)Ob^<GH7-(&E#A0A_H[^Q6+M2@Q5BCFaUYE+ZPXV8S_cc7-.FO=?c?c++)[]f#U
5,4a=/7^8:=LS3ad@3_D-GOV@:)0bf8J4>>IW(9#QU;==@DYK[;)#?a<gLV(,YB3
^W5Jag:.Lf#9M,JD2b)@12F2-a8J<E\=DU6D8EES)gTBf:PP,,R[J]Od9I6#A8.R
ZOU^70MW;HLbW_]7N:0fWRg@2;@;_egec2DQegAKJ)GBHY?dE0;N?+CgBc<K-Y57
TdBJK\W<E+@0MH1LC^X9JXeX[(M#^HIE:?dT2UFfNd\d/D/4)F6JGJ<3\,4C[T<)
aKC3VS+LX5P^&R2,<O;a;5UVE&;P51&T\XJb9Gc,Fg1b1C=ZT1,_OIabdUCaG(7b
JdII93Y/XR?4BD;W6QaXQ5)dNM+<G.0:@XQZ/D&DJRB/0PQM:ML\#8_)e3b>aS[#
E<RDOA#EIc0AB^OU++=6O3RGY>bfY[2>GF.:a5Yb2:?4)=&IW<+#g1,fd)2611K@
;3W\L82^W=X0+#\(N]DYCC.W&C@_-C]A<Z&TT6NFb/3?B.[O[PH^VTSDdB?UM8Sg
:4J,&.W.LM;;dC(/YG:L9dVI#7D:_3MZ8X<aLG(^d&R/g.L2EKQ:4V4b]gY0^J)&
:df+acFHVGEZ-SX)&D0;#6_>9[\),/IM//9WO1.#a0FcYU:aKc\NAb03/e]<9G>Z
5CGB:Y1FNX4OW6e/J/#ZHAZH@aaBT,-Z=-c)J/HcSbY^#>\;7^1XP>a9=dS\^7?Y
@&F8H?=^-JMJH_2Z-cJFF),\F4@O4GLP1H;@404&SeKdY)@cg&R]:)^OP8d>aO[#
+E4ceWU5DC4Xa>)V+X1Zb9V0?>U#WW@g_C__g@GPFKM2D&JOd/Y=:HRd?CYMdXR=
?UbcF)9.GB4L])FGM+N_a2(G.<0fJ=a3>HC>e[C>Ic[<KH=1b_,YdU6=V.BNIQ;C
4FRQW.1W#)FWVcg:gN3_C7])_@V3b,/3WdcL29FR@MY,KON:19+7eNRXPJeGCdGO
>6Nd9GOWXZ@Y#HZ?VaE2PfA7?M;g)D2Q[dNSXWfHf3:9S/Z@7V7#028TYLJMT[2W
C#Z^YCQEM>>b^^_3CXL[Td9/@;Kc0^SB&RMA,USY:eYZ-\FQF-TR#1-NR<H>H2J=
=UeCQ,d:FS^0+4[aXd61dV01CV+_Q5[&=#ER_?fVgMW@SHY3)If+V0BU/KE<0Hfg
(^G:_+YgC.2QGMcA3I>M+8cZ:4P1aDC@^+K5G^EHd\6Mc7&Deg_/#K_04SH.JDRA
VJf8[a+0?8DEOa?aU]5EHTDgD6,eYM4LWN-=V]/H,WL7,NSaSQ68XFa+.7ATR10F
X^3S8W@PJfdZc,+A7=58BI)>c2D.JTL.Z\X>FOP]?\\[0,&c^b)>^8LU99RL/ZQg
Pb=Y<eNeB]2X:UQ)55>.9>_)(@NX+W6I+\]ZGd21dH42]#0JT28B<9LXeY5H..\g
@NBfUID0S8-f3+dEL,[OUT2QX[[(gTN</HG>H/_Y?)R9;778CU]6JD:KP;U5C>UT
]OAC2-HM,[ca:U>835c.9<]3>MWFe3WUR5C]\HBdS_b<8.E]B23VKb4VCS>F:0fe
YK4(CZ?X#dJaIQ@f^5(SeN;;8@F_1EA8W\\UY;D<Hg4ETPQJ;(1N6_,I@e5S#.NN
<IB2d#/8]]CY=0.Q_A-DLRSP<fL\;3V)Z^&IS_0U4YR@(SL]/-gc5MgdSLTXeOdZ
U5SNNJRP2Y-MaFNC8S&<VT7)6PX@C-PVW1;TLM.LO@gGXZPVfRLVY8JE48XW3#CQ
MFYK^Q#&.<Lg0S-KQFD8?,f3-g/MH/U-Dg)^)D0F@2GAc=g5OCO#=@W-HM0=dC(^
[D:e.93R]1bMa/=b9B-V7S4f9>_V82N<a-O10D;T096_ce;OZ>7.\(61S4Uc#<0_
TAL+WeHf[d7[^8B#g,7IWSFO^Q(&e?65+-7PAgT.IdRU4GbN+W0V@BTV-YT/UE8#
>MM#^DKDES,8P1CB(A3K\BMX?CL6fD9](?9bdPbJCV98:4Z/c6DZ^=2XAKHJSCNT
DAR&LPNZXT5aDR[I0O=L/E\,_TW-?XZRZddVK).NHS9QeLad+N\-B-KdG3^2&4gG
MX[OX<YI73DeA#cQJc2@-.aPCaYa8aH8J6&U0P<Gc]\\@ffKcD)8A\=7;CeO6Z+D
)Ye-d13U4=4?24c=ZGYQ#>\b\HEVVbX_0d=(-\3a8fV3/+JM_Bb?(D9e:+0Cd/KK
_ZbdF5XJ6eH3Pg:RK,Da@/PF9)W(MM^,f#K#d:)EE8]1KE?Aa+&&f?6#SfH4@fbb
aVE+(;:1/C1&We7^#fc4Rb-7F@IX9NU<&BDQDCE58B\N_-Jg:=AVbd3PK&ScbKD&
)Z-+8CNgJ(\#\KcU6Y(gbUQIVUHY@gQK2DQbHESQO/K;1RNAE1AY534NER6R=f4W
>EK@#_NVc>H#e0c<#T.E,SVZVKSY)(6?I,Q(?>dF.>SX05INMX(@\S4>RR?>GfbA
EU?37?DdbgGMH)(XA_UU5Ve-O\V?#,7;g5WU&W9.O[K.,;WBF4&:GYO3&+CWV[BB
V>@W87O?>CI6LZMa#E\VA1S1J2?&6M9Nb8Q[)_g7Y-J;K)B16<>#e2gcTCV_H;Jf
7/2,bCT59E4PTC;0E19NgJ6=/)+&5J>#L3#4IfXbG9NJK=aFCVTgP^+04[Q8HV(?
2AZ3aXZD8c6Dc8I\<,F7X]T7EC?JBR_W9Y2d,Z;V]O.BI23YO[RW(8[G&&[?CA_U
(D0.aYIcPg(D6Z>RJLbGbN1a6TL+ZGK?059=6gTGB@SIDZgUPLc6IJ)6Q-HG5(H,
+cOb:&f9c/3&g@0IaeV51OZYQX<R/a<8cOY#V88B&/C/H4NI7E?-@#Sg,8?F^PCg
H2d9@&@8R7:,V9T9TOf_dgZ:=N^6&>/=O)Z,aD4>]6AS,5EJ\g0K0M3_0d,?8&Gc
_NMLN(,A@K==f(:OO,a/4A3YEb>I&X3aMXBC37M7[4_GEHEK8.(>\)b_P=.U9@@8
ZPK4]W<]U1:OC(93>bdM#^1#3_G)7PX]PJ)a62T6W\KW8R3J.COZ-+Vc([NMf^dC
N;e]d=7#7].^W<1R.TZ/HA)4&K+1&1=)54#)-XXP;b-W>0+JV;Fc5OJQFYXX@Ba7
b,J6TZ49KPCIWKG+<S,8T@8,JUH,+E6]g==MZ/fSMefbK9Y;I\bB/=0#@.<_(3ed
EW>G8)O?)AW=WZ/VXH[cE6ZISXPK>2X]J4bWP2J0?gUO\.,^:K?-EgfbHN<#_2YG
6\2C,B^E#dK>]J//d?T>(:W8]Vd5-M(:e2QF,7,K^7C7>DF8b40I><-P:X<ZdE/Z
,)1c+@S^-[GY<+-b//H&(-\Q0HF@[-J6LLdSJM)f[bHV]^/NR[D/gba#YO5HS_[I
g7[B\4-WUS89:5C+IdWP#e55IQTL2YKZT]=A2,DLKR45HQ?e]2N@]^2Y#(+fb?E?
T)])QO205fc3/9WR-2ILZZ]&R>9IOU>Q-c=SHRQeQK^=P;HWBAFTFU(-eFT\d?TU
0EYebLR9L^1cM:Ng<L=IRBBd)[b(B?8UV2YX<9A]=?+QaeV,7cXHOJ.0=Q[4Q=?/
QdG??_Q/51c8+MO>SVNMZPEaUJVF>>EbF/OFH3<R&2M?6?CU\=RY<bIeeCX9F.76
&SRM.9dg2N]7fb:K?YEA@fe>bf:DC(Q:K#=C^>83R?ZX_Z?_&4D\BHC^NF>MOe2Y
K\<H<1feJ?M;I3]R31+1eJ?e-#UM4E],U\ebJ7ML)[CU?M;F(9S9+X/.bR)&S;DS
UR)NKQ8Eb+cT<\OQZNdP0DRC]D0R&<BRJ[b@GOd@\/dRMGI.P@Nfae^2NB\2\Fg,
U&_d=[;H#LRUMQ,K<4KY1#@-gC41Wb:73O)K(^J1LTHX)4Q#)3=P6Z/PH1V>=KTP
ae#WZ(,TQA7C.+;9^7cIIP8S>>#ZYFY4@I?Rd?D&DX:W;2KeN\AZ64\c@CY;HKO;
[YQK#Hb;J?4KVd>0=F.GD&1G8]Z,S<WaLLJ#-ME;<KZ&8<9.-)D<SO_8aRM5XWXO
HV.VI4OA03=YZOPL8EXc((\\,/ec#(7K:dC,R+c7.8bA?&UEU8>P+)+Ud1(,]3.N
:NTYWaV-1\>&V?[3C<T7GVZRMAdVaW_#=LJ^(?T>XC0;5BT.e9][072\WG7W0L,A
Q@&Lbc5#-:Qde6^f+8WBf1C+[FWHGC7IKPL?cgQBT4_7^+21J&d[>?C#J9:?V).e
=#3bS;4JA[\F?6c_X?_=SY=aR4GH@SBVQ>We@dFV0:MbKHKIUMR@d:&A/?;AeI8a
DQYDF5GH486Z7;?X+/,81MH16I[DL;19\]#OBJ\BQ]Pf7F#DI,WgP?dTIO-W72W\
2^,.AE)-<PP[XGE7#9S2SZ#YMdN8)4S#)+2.\g:U,^AOb/EY3MXC9)5MA[=#/AJ-
Hb9;OXT32+UNFN+dY^/YX<eM.T@,6X-d-U,dA+S2:M1dZMYB?BM6e:A8bWK+(KD-
VUd(f#.U>eD#KQcBF:+B,PE5Q#(YX40]CK/D0-PB8.Ic?3=QMWRg0Qc]L_HV^;Xd
>CE25OMC,3_b8HR)O/+U.[T)(fe@H@8Ve;0</I.,/B-4ALbMSU6CR?:b[/4b]<#c
O@66:I0Oa/04F).R^N#6D;:3(CX7Y(1(9@Z^I-7Fa-P55b1K.=RRb6NV@0C>Ye^W
aJO4J_YP8K6>6+dQVJR?Y+IB:)4HCRIN_D:,e^DG&XPAE1\L=W9?_c?:AAS?@23K
94eP06)T8QLf0H>\5Bbg5VDL@3.;#Q5#_(2@CW&eRS3IQFOJIQF0=CLL9PTR3QD^
CgVK93Z7^\W5<XcU0^54SV0>CPQ2E+c8<-K)cGV/69[WX?NU1.)WJfa0@Z]0QG3@
S#bW92(b^]^4f\DZ.TH?<D0XgHOg(La]M#?>_d244CV@I]77XDE\1Te784Sd(AE(
^#ZQeNbJ7eLgA6TQN.SC=>1I(?AL>P:7JJLe.VH--^3N6(U-?&??JKYQaO]10FTa
[3TRY2f/==f9g)]<O.ULPcYe3E)RWg40(#OaZ)Tg^S8A=;=7IHF&0E^>)__]YO,1
9+E<1O_B2Y(U8b:]P@5WK1[>X>K/X/)\X)D?G91KQ-23D3&6-&L,bS>fVLZ&:4eX
eY?9Q/&X._F8A2OK3GFMc<7gbFA)K1W?1JTJD\:2VJ:gM_0?Md2^=9D[,L4&TBRD
7/&+c#(G>SGWQc9>;9a//K]^<->\g.:;(93@P;ALYPDWJeS>8PE,]CW\G=3+Ub<(
WBU)-5WGK1L+<0g886gQXg/Df_Q1PXL_IaFW33#U8W)D31B]DbI7DJZ;fVD1c-8E
F\VC4P2+]J&4T&Sg:)WW[WL>7aYP=69B=;TM,;44X>==Qg,Tg?G8#D,/aF\&cZDX
6I0+(e_.9?WV/?KbZH2387)6a4K:Vf6Ge:Ed?U[+1b/A)d&WgNLf6(1=d@_/6Ag-
)ZZ0[:LWD3cLQ(09_W7CYbaeg9CDKY?R/7P8QUI)XN]/V62JZ#90,PT5G/)EebKe
X=N0EHNdA@&2I;1J;fB6@:ce5X]EJ7D##+VDg-0RQ\Z&XS&6Y&GO@<?QEMC)OLXT
O9QJ2;=a,R1@9ZT\f,,>_CA13c6___5e)MY0K=8Ng_TA/EJ[,b[A9T<M&K^XMZN(
-WC?VI6bZaV@G2.b&B+JdDbCS-/?,,,JS@K5d5EY+L.P]Wb#4ag[&9@)d3,?QQ8D
RWC[Z1eaBaAeHAXbA[QgfF,dKY1N-/,]#gLH4(2U]N@TL#,L2Q+8He2,TBL2<3\@
5HT_(13M=?G:[\>=Q9^W6_8fYH:JJGAUU7X,DOU)5CUXRWVT:2,e)T:C8&-&8-PX
4\&6,C#Y.K,4(J-cE<SQeTAcHWFb?TO#gY1:O_[b)>6-:fJW&6[I9Q+aC-<ATTZb
,?aM638FD<]1SY]NHDY3/5&e\#)c6)D3\(Kf;WXBPa01J@<8+>WDZ35L?6cGM);1
XfG\-&X:_#AeS<7\5gEdO&0dT3LL<S#V.E)B&=BXgJ(XZZV4B4dF,7WW[-I:J?Dc
Z];d5bQ67NC#2BfFc2]T:bb#&C<=d(431+O/>?/-O(.D>f;e;HgZCK-G[fb@8^aE
+IV@)SQR/ea;,]4LYSA)\44D\1ePY<0\.V]D5EFOCTPH9b3\BaA[]a4^c43c2##\
LV&7]Zb>^B_QSSQ#:H^L/0#K3V;4820=L_3GO0f:(ELE_Lgd)&=PQ2C/0U=7ZKUA
:,WGY0U;:Y^8&>JJA9#c=@0?RDg+@T]9Jd+c>ZJ\62UZTc=PL-YSdE,YNXeNB8f&
?bBb\3CX30#^UZZT+M&25N82dXS?FMO4DA3(SH@aFK#I99@7f5LFGTCA;fNP+dgF
KO=ZUX5b9KdG20fFR=aRcaWf4eI1G>P37??0g1/<A]/g0@F>a(5E@&M\AZOSQ08T
,-CC0#eOVB.H8?3e<-PQ3STK21SNa+/&U4>ce_cfHfgDABFN3Vf\WAG<1-HPF;4G
.&=P4If;cEGQF)\A0[I+NNS:.=#>6N]g\>V(SN3^]M8(&cFLcRdWgE@Jf=WA.L\>
CEfJ/\@Ld^KVY?_CBREHP86Y50_77#0+eeOg7b6EAPCWc[I1K02/JdV&1BK/8dS^
Je+.6;W#Y1#469=.BfH[]P)O+1TRH8UF2fR0JTM@bV=Z@S_]XSGH/^QKRAT,-W2a
4fK2.U+_gQG2f^@PGYd-/b)3:MOKMa(ZZ?A.2UA#&_2T;GCU8UC^:Y0b@@?YeO&B
eTAMgb.<53&R;P3d9[]H7Y)e=@&W>7OH8QGG.:.#a-S)-1G3:@FJD#PWCGSR,MX8
>G8e<#,-/^2;EW+;1@fN)N0-Q6?gYZY;H3d>=Ka<+Wb_PJ:0EZfN^(OE__5&;M8P
1O031^Q?ENC,AN1Q2)CZM]T<^e=M&4V;BeDZ_PUT)>W,_WeMQTSWRJ&:=:JRefg&
T9@Cd5abBG<cGW)B?bNcU;NZ.K[,U+T]Fd#a13KDDe2=HTGE]?>2Pc&:9#J;L-D1
WAGT@6HdgV5g=9f(\1=#?FEb\RV#<77EP\3][U_/YgZ=Z[8R4<2O,fLAUeE,R.]9
T.JGdH(XT)XK/1E]P5H&#XE:PUUDB<S:>QX<20<A.M<-W=?=;B84IK>,;;3_AUWg
O&3CL0>>/]N/^g,P<Ab+N)@b;Kgc,#BB1=,.TPd5MVcACW@PJb]:N^BfELJ\ad?=
c9DB.Y/RF;B(^DI1F[?8f?E3L0D,-0TJJ@IJH+8?VIc-_^C7KF<=96Y#edIWfS,H
;UQ=GURUa,..H.\VD.2K)UH;G78H0:#,b)9MI;FP]+bV4e.VT4gX?U)4+HYJ/].#
KGRP[R;G7EA:Mf-c=eA1&BJ6>0?4&e+-&-g6,6d?GcLKc>R4/DO>?f,TNZ,9gJF<
8;VY-NRFXHa5,OEe(@U-)8B=LA4^fO<)EADH\TUW^NYagAUNJ7#/-4LAc4X^,CQ/
9b=ESZOFMLc#^aB1S]&aD<:N7eDG85L_7#ba>P6WFg2?Lf+?.0+>02c#2?8U/0L&
GQ;B9VB(/J2H<M(\HJ4<:d08@Y.(5_X0_\8,WX@1&CI4<OHb(:CS;5<^@9fVSG.H
44Sg>@JEK&Y3/VFP.4BLLc9XYOZX,D60KTD9d-]dA@Yb)E,:R4=E]RXR]YC&)7-(
./g-QD&G,d,DX29R8+0f-?;57GA>]WARR&R0?<CcCdE?@GO,,H-A.MZOV/aBR(PY
8W_e;^;,X,-@]b8.VF5#SA/M/1U>](PYb=bHG;L\LWg053IT@&2H-&GRX\ce02Ug
MN,V1fWcGV0g.;YL>gaZ<HL?QbGHcB,==b]\6QUafAOOF3=&Q\Q]&GfPU-d>&W&(
+81?MO._c.[B1NJa+g34L424==QD,TTN7I\JMDGK7YI_,0@,O5^Y+cdf)E&YEb+@
M\XQ9]\Kg+fA7(V,]LZR&6R/2^1PP10SYc9KVcHG+:2:OESUN#f6[MX=L>R>XfU_
G5/0da4.fK8_\N6/X@>XGZD8).&d.L=fW,C<3:Gf2C38bR9d&<NW<>.dgePU;4CY
MD)Ma6Z,W.RPa#EWAdI0f/f0Rcc,J)YX[JL[)?VUdTX@U,_D.SN<I]XL<Z@.c#3V
_R@^H=EF]AHW)_LUe,]LPGF6/]2(CP;<9<RCRTY:JZEY65HJC,.&c3;D,DMBKKX1
,&>ZR^g-I+Xg68R+JAKb(8(R1H2/F=O<cbT63<N5\+\-.g/:CZNa<(D#0TJ1H<M+
O_^F+XQ[):M_C<YMWD5e+NB.,(7=[BAQ5;g]]:<?AS_.^MWAD.G\:N3c)gR^;EU6
gMUK]:?OcR0(\.-OU38LB=,#JE]WK/QD&WNQU((F@8&S6,8V@e>G1JN<]cOZLgbK
^I./#FdKO66Z170LeM3N^#Jg1C,/W,Kf.O+Ye0>4QM=<C5A]&V?I<M=.\6+@;B2[
SE6]CaG/E,O9ZMPaUQObIgFb3&PNPBAEg0<..3VV)Z-@I@=AO3TNVR<W<](Ab=[X
8B5gU--R.QKg9I7GI_57AfFZc\JA&eJJ<QD6^#?4>SEYg5AMc^/S/PbSO)_\Fa[B
6<e)E=9PTabMFY4e5ZH;0V-;I4EN=.[VQ8IU&-=0NOW3W7^eSO4ARYd?7Wb\T9BW
>H-c1P16Eb(G;8MJ\E6^<;N_@.5Qb;DGUdFC1F6(#.:U[UO#B4\).\J^=0ad2>JY
O.+.6e9aI)F=gMdB;T^62M^U,I7fc;f(#0,SANFNQ03+]?PKIXXN4LaI>D21624_
6IG0&_@YK\^CfWDVTKa3&4W.QKAV57/,.^R-f=055EXB?]:0fHYZ_G^_0SF9Je6;
SLGAE_/_](DW4FSV9_(9OL,U6>^3OdH7,QPe:3dMSeC(:UDUH3c4RS^/?0.c2cH1
>afW.U0&95bP>g&CXCeS\DRbQK)9_J;7J619<<X6Y-Q\9\6[F52.@ASWQB5,K7FM
D01g&Q)BaU9c>2-19L5<\.Q7.#0aa7+1]0BSH;0f#7O:RGXSOYgD@?IKb80d>M6D
Ga=0BO5aHO#]?-P-/WTFN@?Y6T2gMA;R-fH_Reg&CF:L86#,V41Te<YQ<YfKFU8V
S9\B_cc>97X2LY5R;#62(ZJ2CPdU],GT-7#UXA]^)/W#<0gBHA9;/]c1:]-B;50/
PCM0^MN>d5S>(:NbM6EdF]bXgZZPMMH-\6\eU;4A_3AW@L7@aXd3g(+>LN);0B+Q
T\KDY&F21^@f_(]]B1E]#_X082_^>(bZCB\Z;13@6_]JPDZ:FD?GVR8GKTV\@<>F
WcHS-T(C;L=\c,Y_8XH,I45G<0)]Gae[UOaWX()91?.RB(Z^cMGfKYAN9//g2B@C
KaT4g2(9)\Q/@?Q[5_c;A2eM4A7SEH=U-F^.\@Q/T+PJ7AB>Hb&f(QD4W1.>e3VY
E,R;[\L^(37g);5&UW?fYI_=U7VJ\:-J5)XbTIbR^U/&B&5>)Y#-9_T6f&\F^2XS
-#L;b[DR(94Q5ZR;g[58cDOQ.5d.b+[T7c#K)cg(]=J(E?eB5)U6M2B3.NBc6BOV
YMB.5+4811c2X#H_#?#NKY)+H66dR2QU)3EE_B3Na+HCTPaQF.\QE+(AI^)<1#;?
E3X=DAUBZ=2F0YW96-Q.W.U=A[R[@CE3GEM(LPg)B,62KKI/S3SD?]3TWW=^(eIH
3PQ(W&W7).J?[_XS9(9:,Lag3C+aeQM0c]9_YKbK0OYOJKW)-\15X;g?]cK:G3],
:9R;,+3S8bJf^]F27?]#:LUfHMH4+IL54/Z/\Z0/cB:Re#^6ST20gA6-_(]Q4R?#
O=4U5C;#RIMJ/-)Y9I@_7,dQ(Y>2[BJ,Y&++:C28bc#37MYTICL8J.(1@N]#>0CW
+GW\3;-1C,dd6XRI>,V+O?-a),aZe5M3EH(_)2).E)CK6TB9Q#U2-PAXVW>B6(#8
>d4P:0AB:W+1=>A[GVU_;W4J^ce-4\M7F5:).CG.?C@f^UF&V1=&4V9Uc+C[B;0C
d\+e9cV5c+d>g:CYJ7=Z;\_4^T1d?,AS&&]PDeY>8Zg=R#0>;)>@K,3+fY)-YNBV
eA^b>Y6V2O:ZMQNOQ.+BPgOQGJbJG_BL6^(IGZ_=S.&3EUTb.<,)UO#/[YW6JRdG
^8#a1KL&QDI^&d<,=LE:,KO(UcJL]a>P+f(L)@7fMQL_V/dP_7R5Jd_)NB1920)#
N>9X,K<?5NUUZ,/-de1Iab0:EE(cBI,&-,e;4D0)&TX>AT);KA:#?&@dF0fY2-RD
24C\JgB+WAD7=&1Xe@0:7VO,K?DQ.Rb=>_^2/>@L2:)46E:V_KQBc:dMcX678JHG
XUP;Y7CNF+T[FFH/KN[2XMcTM)4E9K,LKJ4N@;O2Kc.4/S9V7cX&2Q)ZONH::YeZ
B-(fJ=EBL:C0T,aS5(f:c>05YKR?b9_.[DO+G#C34,[.Y5cVGg<NAe;S?UJT8@gK
+T^A6KL5@P4D?<^Y6A\9O^Ic0c9aT\W;]d,Fc]+]B#e#M5TB[bZ0&6SAQ9Ae6O,+
3H7FE\Q(5-Q)M^6LCD3MA)cM<KD3I5(QT.[d1YH3V6OV/Te&/4IUP9db:@#\M?S2
I3ZKY.62fYZDDc[e4a7KPcOYU[(0TN_gJAZfH2E8Y[B(gW)(YRA2aHgYO(>SC(3f
.:DTT0F&RfCVa5NLV^;T3E<,^2acJNI7gM//)32.W:1C0>fXVK=C^J)SK6Hf_QfV
MP[?::a,>;4XEW1_SBHf@C\d:?OPZ0)aU>?P(IbA217ZJJ02ed_)89W,ANX#PaR2
5;,L(gL)d:0XE/PJVF;VM&HRb.c.@36JUUB2;0cV2MR4-6CY+_5g@0dV@bS#)+20
P0.g^;<;S,,:MB^ZBV4G;UU9P.]G_J4R8B>QD@0&-B0E>I#4\8]#VdQ1dQ[gaU6?
c\-@OD?FNH[O8-GE9?d]HA3gc5=XcJL&#Y(F3NHbM#b6DF/FB=<K#OAP4I8C\HR)
K@g2MTQD7@:J#V@8D6U@^IfNY>:Y=GJC73V2bD)EB=A>\aOTYQJWX^NCQ51P[.:^
86CTYO+[O.;9N_XS=VNBL4GdFJaeZA1LH8,9f;5H\S@9BX(#25d][\fWf)-AMfM)
/a@3Zb2c<-77+SOH6KAdZ26]M,9;QUff\?DTUA>+QFf1c#?;NKR)@.NIX7#SMU.0
.S5E=IH>bA\Fc^6MRO:TJ[_K.cP64NaB(3Af;OM.X7YXU&d7b:&bUAAOSIO^VOcT
4XI-][Y6^KT1H7#:NQ:EAU1?M3]dg:cN,78&\LUecQXg80,0-.:HJ:J^V=LR_MHG
7[;fT_5Ae,<H#7YC4a?_9gJ+^QCc^N2O1MaDLOY-2R,e9FCKF7-8IT5&W\XI7JG+
)cX9X6b\2J)[,5]/WP6[,RMcDgH@F3+7S39RfA=2,L=-<8?Y5/<M>:+Q)<+b+LdM
O6WgD@55S5c[O;0JD:NWV3U0GUEV?]DUgFIJEK@_;ZEY@0fH9dZJ##BV>V.+=C46
F80H1XW1/6U<O\0_:UY_->.=5A1M1D^H)Q3_VWEKU;R[PUgZCEA-X[/dK5R7BV59
&&UPd,(VNK945)D((F->0N/-;d:3C/0M4(C&9S2LF-4]1^:/abD407AEY&CX74(-
aa5\.&RQfXL\T;=Z9Y/JENPNA.Ye.\0A7SH,Z\RLV3=E4R6cMe5I=?FaL.]Ae2gZ
+K1bCa=e2-Ve^^1,SFe/=>KM<XM_RG0.7C1Z#5M@#8dCOSYE]_9=bFg8)Q<Sg15/
>Va8,0A)M8K?;LBVAQY0b/g>4gb<>Z<KF(_(Og8D8fMS3,MYHMaag60^[@dN31\A
7922XK#<&Fb-<bKU?O;?\)L4+70AZDa-40A&=,U22@9Y9Ff#e,,K7WNa1<NP4U++
0@O/PgHKJ(:=N)8@L+cZNb_>\JcE-?L\R)]2]gGLO[\Y84c9d,9G/<Y5(\_&R,ML
5<-84e<+\//1O8+0^47@5]BV2K1@@?5M8>+6PK56^-\-+EfD7]SNN/;?EIPSBR+W
?A,#Z2L)aXWECZ&IGVK-<a7[0aFTWdCF43[TY1&ITFLXbZS[K6^Af=LAH&;#,RRO
61AcG\?NBKB\)f,2.f[GHaK8JW:2Xb(<=:84XM22,3AB.V9cGGRb#WHDB5S.b=S-
Q5&T_97O@VcYRGG9.:XF-KC<P]P2>):.,(DT_D7.fM\JIGNAC/U9PS1GWHc,Z2-J
19H3+@=S^YOg=SgW+6/N1ERRK_L/<Q_,N]]LIH4(:IZWaOEI2(0ZTWSL,P[V9fLO
+.^K&03E/bYA6Q7,bg&X^@)9(abL4U\,5QM_I:Xe=+\PKC1@Qd9>:Y6[;MX9PCB5
bSOX#0_DM0G+Z24+\:EJQC.NY2W\757RYPVUABK/0G@SGDFR.+fddQ]d?/)SV2T(
4ca:Ce7H<@<]f88NQ?6<VH\.DJIHPdaXK@]4T1JEGGMO+ge)_a^P/d3+[WG5P,,F
@<OO0Y6#AX&]:<FccRRYB@c?Q6>Z7L?6^T,>bS_RUb^Y2/RXT^2S8N)S_NIBcSQ.
^4)acKSZ34L_XN#G()c@IF:<KGVNXQ6O<EAaE8G5<g^Q_\KU[Ldf850gB<1P.QLU
L/,Q6JI?SLV[PDBNE3A_6O:,T[9_Q4QdD5(HbDW8.+I8c6C]L.\-#0]S6=Kd6__.
KWHG=EbE07)bWOB;:6QeEe@P]\Q2-=O=\beP+OKa_NRA=OU(cP5#3]eSSI&GV7,(
<T[I]RK>7SDeJ=D]1O&#/^d95&9RHSSR0bc,V685KXX?gf+S;SHSX-;3GV:82X:8
1,EaTG3b6C>@.7O>GB=P/U@g&LefE=3J&<^1@UGH@Z_SJ=-1Ie.1R53CDa+)B.JO
4cR7^Y1CJM<dFdQW.GQ9J+)W+ZN:DTaDH.f,a8W-D/E@f9T-08C>LK@QSJ4;ZP9J
WJ>caIS(O-Lc.56,#5eESQ2a7TA:#O.dG(d>(_[+EO1K0@?GE&FMQf#)<I\SOXVR
TdeH<cXTb2f>PA5R0S1.K(g]))#@c;QR]/(95==dd2L[fTUJc;.e[6-+KK8dZJ@J
MH8\]@d&W:\69;(C=2T)I_gM\SKf7732ZS&J#If51Y_NdX19Nd6:dZO1=?:MLfO7
E[.].gM;B9XV1S/29UKR9BT,P[\/YGXV8M]D552VW6HPX@-)?S;6<EbRb1PG(aPH
;L5Ha5UFP3RbMHK@Bg>I/+ZRH.b-P,45:_fU_Q6I5F1P,;5,3;&)c6\@UMRGA+>H
D)^4>E.gP6@e0Jc6.=6ION1fRdbH12V4IFbY5[;SUa77=WH;G@1:g\>]\\YC[f2#
U[JAOB^6;F+5]?gH<ZMdG^@8<IZTCE-5(._(F9NW1SS+?3:-g/M32N5:AVRVPNL.
?;G/=0g7;MJbOV3.#YV2a#-@C)2U?NJb@FETRK)L#QCTL;-.3N,CV0ZEEKIDN0V\
cMRI@\A_6Qa8d/(9Z-^NC.84#YAYT,^<\P@7J+FU,AbgeP9]d-JP+;+b_H^<Qf^X
8=4XbU=ZaF&?6b?2OH.R_G-J^^ZZ,?=9O7@)0HK]dUNQ0Y_A+gR4]U_YK;LdB\I-
5?>KM9Cgb_IVQ8H59OOPb,C:UE@ca2SPF_cC\DMHI,3_&\YSJP5E3f-A6[6Ng4IH
cAR:>dCNCU?51O]b(F8GI54/D4?3U-DV5MRS5)X7+Zf[Q]C9>WcDMFfW&3V?^6Qd
BcEMeI[[Z&K\RS?JG-9,N6_+9#&&(d/CVMAc\&f<KTO+Q@L728680a?BfdPAW@J6
]GQ;NDSJ1(TC(0M6c]QT\e>\0_GXLQW(bZD4PFeYT_^,IV@:fW3L((/V<BFD^\YZ
F0aF<?QLWA>].?0LP?Ia\;<O_fU\debG-Qe3YCC#C)&GgZ.>\Q^/H#)ML/[8]f@[
c6L(>YY:K#V],Q]4&&XNN3<A1NIKa,cJg>&FVYHF\Q#-X?6PHJ6UO;BOFAVBDM^+
RXUN\#6ESH]\N+(S\a-U&2:Z/A=cB2cWN[)g3]fG49fGPbX4K\L^5DOESdKEXM-T
(J9(eRM/B<AaHeMA7YY)W?Q](cF+#AAbV@SLaX0gAGP)_]2YcDdT^RFS&+I.43.R
Yga&+dH-TY43F[B,N<H?KaS>NR[6VC^V?4824J[<B)?_Y[+7TK,gUH(W+EJO_E,#
\XD<SJbW\A32[V_N\d/aRP88I#8I3>]BM4?.TAN3RUDTBgc)>49PR39b,GcL1YDa
BgMa6@9#c9VGLJ61_C,W1V1ae4&J(FU_Wb.C2_BY4Td-A38<0(P9\dL]@FZ+e(+e
7W2>@EWeRgJ5@N^.fDPLH8&+FcBMND?<FN61(-\HKRG[P^+=G>);feT[@4aYG(Q>
XM0PfbT\:PR^E#_NW>A/cbgNVeLGF<5(3Z:;#=()<ST;/gJ+\7WHef/X.]>QA;0T
>N2A_GgaM]\]f4XNYcaL@3N9[7FHLO4\-T<@\,CU]N0+>LHE@<\4XM#.9GTEKKf?
DAP<+H5#KI=&1.;GB@_U^ZRAQK:,&OAQN)8:Vb.T.Q^JV.^,?E?>E^)6,Q+R_gG1
Ya:dcAg6=(ZYYgE1;A::E#.5V?BO2.#]bT5&I^/ZR06AU-L3UY2:]adDJ5/4Sc.#
B?e9+c4gQZ;RHIGY89d?>0R_[eZ^>ZW<d[G?Xg[T8(/H]G>.(=K#Z78?LFC^Qf1B
YSY:>Hg/Q9O_Ff5([Xb.])RF/KI2456c6D?2(c9NC#26R\?VgKaYH9PQ?51CcJE/
deO4(Gc3+;fL2SS9Q3,\.W0+?D?bV=I0V/YN4SH[^W8]XMGFZ2(OBfWW_2]2[NEU
dc/gD4XeJ-.dZ^SYWN-]B.SF3g[Na]A:S(-ZBM);#<^(TW@--E),-]TYN4,A8O)M
/c>XSN6+KG]<8R#[d=LVc>\FFHa-IBVU=3].4:XeE=J/9WXaETO7cC+g=8WR@L_a
CZCafHKBC<5&^&\UO]aM4dHS6O/\@\TgW=VDP:D0:Ka.cX3VV5FbLRBYC5<6UJVG
CX_gT+R\Z(DW:faV],)JLAZ/=,.>>N&0Y1COTY6fCc(e#[PV9;Ra(c-Ue)<@40)c
.N3,/K_aFL3g1S\<Z8]a+V2T\+#Q+e=+d;75ND2f[P\/EaOKK;PIP2TQ2PJH\[Q0
f6ZG/GIMQO7P,F3G3+W=.VI-N65#3d_cIAY0/P\X4]FOT&N6H1JV.60MC5Lf,f1>
Gd9KE=7N)N;33Zf4b5AaR4ER?bVb;7,19Ng^4d);>5G>0J5fN@-7QP?bRJESOOUc
Q[XHT66AHaC@[&0RLcG](;3G-1#Y]=91@_Y;eD6+[?.IC/LF;a&b?EeRNBRH<:8V
d^0Fc@cK?2[Q59RdX(bHJ<MbHGI@0D1MFed=85-R7^=\N,AL63Q=--?M#Q)e&HA0
FOWJUR/W1N_IYP@c=ZAZ]dbS3^&LJOY0/4@FXB^(Sf;GCDRNP<V7PYW-BM]-VHJ,
=O@5B[Z-&bNe#OQ7W2C/XGIVZ,EI.X).^?T:(9+ad[3K&#3>^.CDN;c)SCCa@EDA
c,FRI.XW<8D/;V.UY7EYK,PQ8#b4Y#(5/.DdR^f_2NaU=TeGe\7V5?^)10X=M3O4
A/ND)d&8A?(#[aWC(ZM.X_Pad:V6L<<.3,cRf^P<>#>H2=eWc7-Q1PNc_TN.Q0EC
+9CWR7-Kd617O@,f_G?:+XX[Fg74EW.Y^^Kf#B6UOg?\YQ4SMTg3X0H9b63+1O/M
&6)7V17S7/FG/#KYcW(J#PX&YF.g6NXdHAD(_Y@feLSPWKF7&,\J98GIc1TFE7+J
ZZ30Y^NUEMU.;8,L>EVeDXbSZPVFL7bT+9b_.PA^aSOA73eQDY>)I85C0)L,PZ@S
-+0Jb2,LUAfJT<UB@1[UVT/N&HQ)Y2&P9&7eVfB#ABI[F;88FQU/c8+I(?XNZPM.
f;LWPD+,I2A)Q=cc>-,/=T2H^8II#3eVYC[2C_<EF=CB&EI2X<NXe=)[FVI:1g7+
,T9W1Gb)\.)\4e:eNd<f:Yg)M;I=fVS;->:MeZXS5[c)f1,KK#KZ)dI1]Y7LS[<N
:Z@IfBLgZg0AQ=b)NQcU)gSATDZ:ZeY<CNBFZ-/dZ\@VVD=NGNG06b2.;1M_O44X
WGQV)2UcLc=U9#Z+(K&a6e[d7./Pd_M[d^/VaN&Ig+X]/OBQWgN=MAZ;fC;DY6MR
g[WA56[6.Y?:.DH0SVK5WV,Dga;DLRU>a8gcILdb>A2@ec&NI^#?^VE.]Q:\OXcD
W?TKc01Z\a]9:]Hf\\JGY5FL9_^C[CKa.\dQb5ga,]c:GMQ79VdaZM8W.9PD1L)C
J]_&EQIUb^3d?=d>QLLC[HNN5WJ,,-W3cS6O)_#UH2_a6Meac-RA>1^XR39]VG-g
M:a@90>=3S3F5,e607YBM(C/5QJ<1&/IU@D;cUd_;c/ad856]#]X[d2F4C].Ca_X
XQbE&T8?)SBJK1SS-Y05Sf,L.e3\JRC1MTd>UB)L.[E>AESOe,S=L(\P:]L6GO\.
0FR4?9=EG,2g<&UQ?TPMdcdBEY<A[6Z/(-J2JOW2S/#bP8VZNF2b?>MRTJe[H.X[
P^7RPL8S-]>C8:EM9@/3ZT.-&[cR,aO3RM-KZ+g?3)KU6B^O-R,7RSWVZa;K4;?g
A@KWMIU2Q.GA4W@-^8))HS199If6fIJO-A],/Z#&PQ)73<\D8R1,6T\1aS)./21?
2YZe;5ZB)Qa8L(5?McN.[ZdC]T7)=Pd[)>d[>VVT=Q#WgKAHXHOAW<>AgE3Q#Dd.
dI]660(J95(7_MU5[R4BI/7+&c3?K.CY#B&I04^0GHAMg.A)XOcFEcO(?YK6\X-K
=F(W8BO:X>cO-0(0XW#1XR]ERO1e-)]Fc.>)MB0X@39DCK8IcEOYe-Q2QFRS6MU)
H1fILgDK8a6@WW:3]B0SVI?A^M5LZe(gGMfeX28+;;.eOc9#fIAH_IWA#44QQ60)
f&=c50G5VX5Z@LPKT+)30LP?4d\W:54<VW[F0c.?V))LcFG#D8&;Q8HdY^M#H5]C
dgGD>TT<_55:G<Y.&H3/Fg6Y>8P#SLQO5Mb5dT:&#JGH0dS1\QVI:IT=SU\MI(,-
8e6W?cI/Q^<355=JD/fR5X=C1X[H1@2c(b9M?O9Ue,4AR2B6\(X)A5RD57](4[N4
?L5;>Q](>\@,D8.cd0C#GGJ93SGGYZO[+DUeGK(++&E&,3]f@;7\gDJ\d,,dX\?/
R->e).);37_K9C9g8dN9(b-61M/&[?+L2(+6TX8&?G+G#X2[8>TR62B,T+EF(<[.
5D+g]1\&/.=KOWdP/aB.(eL]d4C.2KL85AdH@V:E_L-&RT25#(ME)JCd+e3@I^?A
Vf_,([R]4_(U9+2J:Za1^PO8=JIXeR&E.2Oa6c3?<58#L[;M>,_7b\^459<DGb^K
XYU4QR=.BP+LUKY0OWT]E[=^beNd7M2U5YR_D2\BD5b#MLHOcJJcVBe-cg/><JJG
aVYgVX/;E[91S7+JM+Lcf?JdMQWfDK0-TNA8(8YFI^^FP\+_d9^R>IL;Y8fQPFJ1
S/C0F5O+4T;GVCF^d/&.Z&-G4XGECa(AS(KZNTg62BGWDMXaVfPHVN0]Z2f-[RB&
6J8d-S9DE&B2@Gf0.,ZOa4^8^U20G1e<NU6b</UT,]#)PL<O,0^3G2&U.#9L^AQ#
R2\PY/e#9+KMXEfUcA8WRL--:\c9TZ\DDC_]/<BQL?a(fONV/&1<SKY;8QbZVX=1
[=_X@0M7S_)82,J)b],EK8;Q?[#B\C6dQdW>/beVBJU01RRfS#1FaNMCOA9c&BMD
)GPCHU>9/F5A=Ie5b6g5c./.5M6FC<ELQZ8HKBb1d:EMSC)2bQ#HHERTI&Yf#B4_
PF3I].QRdSf)JK.<E,Z<YY\9O?(YX#7).#^=D?Z\\NZSUC)5)_XZ3Oc\YE:D-N^T
f=QA\g9JW=91d[B7Q^ega_fcE>Q:OabGL-FgKZ[IERZ_2WXYB#H2;/9X^[Jf[e38
5L?\PA2<IN/I?>CP)(8G1M8_[[Z[6Ya&()@;,f<)b@bEAME2OOCK9#D5(]589NO2
a+R(AW:8#NW3)cb>F=dBbZ1:K0,VC/L+fQc._FgL,BZM:82\<@CF]C&Tc[c^B2PP
<MI;E\U1]:\.R<6Z1bW95,ULXCJN)+)W^I-W3>T@)IKe/@K8NN5F\WW;G5Qd+I#P
@0c-BVXD^5^.\M;bRH8IP85;YNR)1Z:[^P3_D5O&<,<bZUfcG5YTTHAgOBeCZRQ,
eH53JRgPR<;:Zf>9Rd-Q6NVI9&&&J0AXX+63KNECAA([2.Efbd]HW_T@5TQM-ZM]
)ZQ4ZF:N2P,PASW)T/0/-63Vb1&;KJN#^)4R_,<1UW=/8a3(bSL)O5N3:6a+:]]3
V-[P#(;O&5=4,Z,I.N4MB3UFTW(&JH/QEDb+f>=A63BQKQW,J(1QZQ>]G>6VNDXO
]LFAfab-I2BS#H/_b20M[ZE,X.L0@AeRI<ea7,3P36=R5Hg/#+AYR(G0HbN3()<2
8aCdS74;]5CCA?UP?DKQE?5,)H404BcONI2H#4F.QTC;Pg;RS=3>>0cZOb2T[B:b
]a#gJF.>b,.]SN04@+QUOUb=JXB4^B=Z^.AObIgM,D5P=g/5<f#TZP\?:FEaTU^-
SeCFFGb),f,HK+.&b,PSE+&@6@3?d(3UTBf#_>^Ke2O#4BBX4g2f\J:UO^4D/2Cc
7=GP^/4SWBHbQFd:G4UHL0&I-:40ZQCD?MU+@e-4=(I1&RGV#a(^7,XM#]VO1HfM
H@B]0NWS6g/e-AQ4?0=6BLe,cCYcXHdK-BZgZfEL1NB<8(/-_=LST>A);IUgNK),
>A(WA;2D_2\H?d=VPLb=D7Z0KYdd4)=.>_UWg/a^K7=E7YQHTM--@a&a22(IZV6#
d.,U4a?,2TY,N@\U1#(V2YdKF&I@J>#.e#@I7I]3G5V\@<E9g#V-Mg.5C=WVbNWC
2<GISeKg\S9#7.AKI2D:X3:VZf+/3,IaVRZ3,fg;;1<WI2ag3[-.fZ4c2]P9]CW>
#@5f#6-6BG;4S7PLdHWb3QL#O<GB7#0]U,/=SfQ;V6G2CT2bE]ac^)H/O+_RKKaO
QSeU[gH9CMQG)\I5]6HJGHE1=8[>>dU>[?2,D:O=e.[>H=;0?Q7f+YG<S_NY[+.J
W0fXEfe&/73FQgY0(3=J++,0KA4MF8K>=<OJGS;SV+.9>:3dJ[,F-SMU=WP>a1dc
68d/?QeFVd+S^\P+gbBD[A5)2>@7Y]<G0b=7KMVE8NgIASVWXP@eTXCK3Q(6RZK?
M<O[0(/ce]VNTfO_g\^?[:,MDG9DC<,A7Xf-0]R,YCMKVa+dd(]Yd,B[+fOgT+a/
ACZFMf>PD#(+C>LD6NZ>Q?QZV;@#H+DV6ES50U^Lg4aVK7D@N?6<ANJP1)a=(O>I
,I75<I<+>9383/#WK>:?W37DUA=97QH<I[&C-=_/_,Gb^QWcI&O2CQ@RXRFCVCEF
&e6J@gJ6:/_3;I@/YAAF-^-18FSd5:.&e86N9HdSB\3A7fCS,e-WL(.?08,5eOM1
L>2TXMZaK-+)X_GJc[-B6^/G(\N,F./D77#+./Xe\8N[2=9;HO3M^_)L6+9=1O#&
B):O;/=64A[6206I-KM:;D>UY)Z/3D)Qf_F5\#)ORCfWDf/f;YRUNaS1?7U/ML[P
.9ATgX+M#e?/2_dJNSIAD;G>ST;R0WGPRcF(3b/^4DGe(-EH=UdTR6cO3=4KVdcY
L5dX5=E/df(P@\Z@68NJD9dd#>2AOD#HJfbg;KSE3=A^>.VS[1KM/I/W>?:I3DUc
YaL.:F,dU?9.e[#&CBZT;[&Y9ZUfOFY:If\b)4-:BO];Z1[4BfUUe@b7e<2BHf3>
M8]@ZTC-SJSgYKAQ^A8IK&7U,V9OE(B@=YD8Kg?f],RF0U+6-C4FV-DYgF1dN)f9
\)b_2^0\[8=eA.G([P(N_;Z,ec_gO.cTFMO,N,X_A?JMLHVFaJG_d\&7ZVU3UG,/
KcQZ,=c9La/^/LUaT11Qdd3@dc)=LHJ>:8(_EXJOC9X9<[_[L&ZS==6dNc0TJG,9
?#56F[.A0gbB8,O\0@#@2PL.RBEV-Ia4d+8#b34Z3Fg(e@:+(bL]Y[Cd^[_OP@X^
@=?H6DYg)=SE6?dWANfYg[<fD@)7Ae7+;+U+bWR[J:4W+.3WM<MZ#2EV1Seg4[X3
2O)Y5G7#Na<CJ=Z[40S)WLQ]^3a0/;M+c\[X)/K69K&;aLU+RWU1gC(4[bAM-UWJ
SAUJVE,ZFg9WSAZ\Q4#@c42PS5K9B4NaQYI<:-N/FM5(cgBRN:]^Yc^W2/Z<9f0U
KFJ/cRHC63A0fgUC7Ia\O?7B?CTe>ACgCL\I;c],LW7(f)bWJ]Y]<[K+D[TQO):(
2.S9C9),9+WecB^MJada\2>#:EITD[H:3)=Q5R5e2M^]7D(beJ4@F+a>?.XMH(7N
X5=>\d1>e;[-#S<Y7/,)J<d(b\f5YSTZ5eebD3dPF?K2EDeeY4Rf[Pa1Y6A+1Df4
7LG4/-S7\14)CX.+F?:=_BF+/<ZQF_TZJ[)^e(6DB#g74Zd1Q@Cb1Y(J>^5P?O71
bI)>8T3#A5]Kd7AS+B)E;EYLHI].Ma0N7#18QTY^#QK<_[K<+78O-T4^fQ4)-VI)
&K^f1B#,Q]9E:F^cJ)PWH@-:=f41f[Y_MRX-Q#^2bG8(V),P\6.eS,[5N>DOcDZ9
IKeCU7-\8P^UCL.(R_Y@A1Tf8)8TRQHRVAY;fJ688<YO6Za3+YPBHE,X7TIL++:Y
d)3FK.g=R171+Q,[4A-&[O[?gAg^>GJF,eR.,#?,Z>dV->[8SVO22WW[a,eVX=W6
4DI6d&#P;W,6=M;=A?4J#WO(NH/WJ-]&1Vc-3E-<W<J=E2a<XK7O,5Q?_f6ZT-+C
KSK>PJL.]SS<C;Q^YS5#egWCNV8,C[Cg,[cLVV;/8dXE1^&EB25KcC@\+Z,RS(QT
S)AgKVJc?UZ(eg<Ed;b.P0(UaaM9aK1?HOHY(FLK_],CMReb0DYVH62^d_)8f/U=
1WXLfH@]L_HV:353;bXLK#;L]0<9TX]=B9U=8CHe<]&E=+OJT3]cRN2MD<YY;-O9
65e;gK[TB=\^FSJXHW,+NA^Be@RVWac0K5H2)X2cM_/NcXb6a&=D56=&@Mg^e7aL
Jb:[N+&2@W>[>>c\eLE:-1d6;5-f7c+6IBVafY;9YR(7.]#O4&/UL[102J;OUL-a
&3_<[9g05W,2EV9K?/F.9KPgLdR.DF5AN9N^.1<Xg]SQ>:H[4J8.1:R+FeKH)Q4P
fZG,VSP69PcA/Oa&[Z]UIFa[JM?MbT43F_6L1<Oc@@9WRY,/c<H_e3XT1CcEMKJ&
JG-^X;\:MA:O9BJb&T_fT>PM:B^VLT+ZTB+O:U3[ZNcYXADQa9fA]<A;0KA>#=A0
H&Yc_Og583)^)ZE<dB5T4U/1^#0cN\KK5Qc?&@,JX7Q?ZZ=)7acEJ]MAX]5O)5\[
9ESIM[_MDK@WP_gT/G,/dWe#/#08=X-I1OT1:C?FY:<RPJfb4EfVK62.KH=EU0&b
OU\F6>#6(?<GED^032,@HHV@+YC^A,U2;1><45<2P48B+/TddZg]O/^9UAPWMD9F
B-JG9_c_#(cB7d=@X](A-VD+f9-X74EHG3Mb3@:V.]KI/X)aB7+^1VTLE_g3J1(-
?7dD#UK144;7R0-A]V?N3cIHASR]C)+YL3<=/c2/BIXcW]QU^G+gN\c6#C0BC1H+
e4J+75PJ72H09d4_#>69(N(N3b58&LJX]Ue7_XNEI61=6YS6Z&M^_3GFMV/b_IZM
AQC=4&aUM-4,LB7JE/Eb39K;^>&RZb2cF>D[)dBQ/OZ5ac+<W#7f5e-ceB;g6E9@
+7W@35K42-NCME1#</BX5gIE8;&H8eQ3=?0.&1IUFcEQQ;X\af^9<7X@N.IFYg>6
_+Sc<X=e^b,5ed83<R7Ob&RV:+fX:D,c+N>?AZ6;Y956f7U/J-L@^Y3?d3=#.QV1
N(9[EESZ-O7:8.ZfQ/+A<GFECeDG+AEB)a?>8#5Gf4VceY_(?:=OZA.HG&S+0I4c
=HUBZ1T>RD@WJDdgSOER<KES5I(=.LeWc#K=A6[:4e\.JFV1J@2GM)2JFL)P<G.-
T7DW-1D&U-RTRaG]UFad35Q]0>]X0_Aad2dJaR5:0DA:Xf8E3?6^L4)(<E5:?gb@
G6Q.K>@Sf:5U^#@<bFR6:=X798gOBWbR6-8+>b]LIO>cZ8:?-:?]7[C(,E1Q61\5
SP..8R95_ZBFNGOQS:,AD;P]KSH:GHb+cO+ObR3SQ:^8?T6VS(<=.J).\W:b7=S5
J9\&E7MYR,;DC^F>L4924@;d68DJV6g>4O+<34-P\1VR56Qag4?KLX?9/bdCU4e_
V29)Nb<S/ZYgPa&Qa7f,?JXJ=CcRUNfDCSXU7UEI5.Af^4,^FYB.Y&<BGY[_<&5@
G]:#.&5(#Z&9^SgDMgH@[;_3J_8Lg3=F_eI4W,;a_)G-9;P2FWbSL2MQLXWHP>_b
fSJX[STG4M]&WE4LC7HMcPH@1\]b((1EbRAP<EJf<G3Q^\IK<PQ4:=@=<4[OdOJS
;S17LW^KfFR,I&MM+,POOGBB3:cU3+BK@]g@P1c=eCFYKM;1SgLX6#HbNU7)Q(_b
Nf@L?Vb5_/,.^b(g3\G-Y0=,:+fT/@R&P]>[M_3/BCX4/Z77(YC00BP;_6_]AIK7
^CV@)9bD\R6)W&9=.b]I3(WS7(V>MdLQBJ8,eNTeH>J.56@7T8M=C=cU-&+D7G#C
a2]F5X],F,E.,/BD+dPGDM,9f/K7/=9]KQ:>-I]a12CO5/5>T;;T2Vf:H3;[:Q4-
0(-[=;=G^W7Df9Y1URAQFLUJ^34W;-39SBS/]ZXV2f=USgYF[eY=JY/</)YaW#+,
,If02b]eH^4=eC0cKZD0],2&g+6_Qbf3PJY3.Y&G52J(a#\Ka1baAdEOAB_<261<
)SLgYY)c-R-8cb,C:XO6OIG:G=-0L@?+GAGgL\EQU;>QdGK3J.)I.4f\Z@6=M</]
3,ag+91<dF<B:25UVPI9WBQUdSWd2RBJVDVLROFR&/f9LHG26e8O#e-[[Q3K6C.D
KQ;FF:[UF/]a\.3/U=VIL5d))7TO<&=8W,7;&=/A/JL/-#FRU0bK=5fH8e;E@NHP
I+^#-0Ha8f+TL\E(B.0YWb3DDDBH94?>NB3V-d2(aN^g[/;8ZF[)f6<cXdOJE<+I
PK_a#;VP]_ZT>G93.@@NYM+VDCe^+#F6)eMQ+96IU7:X1R&baEG#X[\F?Ka1G[G<
T1aX]XgG-Ha+BFL<MY8ZDC0FM@1BJFH#Q&6CEG&M_#W7TX_Y1PMA,eMefe=#,JcL
1CXbY4N\dcVeB0\DWB&GHdX)5MU4>e;&KFNFAMDWaD/O#?Ka:KUC<W:2,#N3c#Ec
=]bg3H#d6-FP.B;#K.CLcVI.XJ)^J?0(S-_e(GaB]N[H#,e(QcaG^86;HaMM;@,e
-V8g^-gW82<QD.Xc._8]+Y=]&IHK5<>\3,L?cXZ>PHCdRG>f=Yb-[@-Z=ZBe&<?K
X8B)4-O)UcQ\;-b-YB[-ZY10>=GZ[K[A?6>C7NI:+RQ66Y#;S6ccHKX>#1U=Y[aL
Z8<A\;O>bHOX7)YdXFIf6F?IW_=T=)Z=3c4C[B+_F\1G2eAMG5F]e./D8>&23-Ae
-)GXb-F>>_OPa>2ac3,J;-UdT#D&42#F+5()NQ_4KM,WeQ#P\Z5[_Y5<I,X3B,aD
X]JKFO?dK,P+0-I//eM@WCMYYZ]OH5:8F?RJd)=6Kd;;-J>=U1;V4gB=a+fZ;Oe7
V-d+)\6N/J^fANE[,>K8daX.a8J+CTc6^.,@)?UUDSEITOO=A7)^c]=Wd0;(SML<
6>^3^66-@SQfZ<fS6bZ_VT?9I_bHA3<PcY\MB#4-4HNTSAT<R37V_&fMPWBLE4?&
NLecN\W52Kb^9/HfUB4)&^_AS-)4MJ?1I]39K&(?3)WZKg10[>ZGZNT#Xf]\V:5V
YCFJQUTNAQW>.T)?/4gZ.#X=Y5#WBK]bfO=SO[a@;U#QZ[-dC#=F/Xg844OJCea9
H3P#89?bYdAL:+CG=+QVQcTCM@.<9bCJ)Z?VMYV4=91OU1>BAXEIgZIBIX-GXCd8
(V+#XYT^N64L86CEbAOR_P[5/_D<Y=4S5>dcU8d8),QaL-+PR3[YW3EdT&O]J_?Y
Idg[J)&Je+#/ORX/[4.X,3Ta4c;c<KO2^?@-PSf?dNV]W\Qaab,;3(61?Ta5F:V2
G4GdO-MB/EW8T_f0[[a,A)/7b93+@I9ML/VX0e8S=SR(@F,CQD^6#L&Jd6JJL9c-
1DB,PP)FVQWSWD1dUIGQY,+,Mc3VCQWK=\CR80YO5:JXO&U&AK6dCKe._-f(TI]@
[;>_\0N@&9dQ?]SB561=6X+E+U;L@=+3=3;AX<^RccYe,;W?^4-I<+4,f71H4\G.
B4?+aCIZ43Q_Y#].B1=)OVC1cXKZ5G\:M0.[fU,H.1G+46A:.<+;VX>d^\W9[6W#
-[YGc6IcX-3BI::b.#(4B0O2NAYFRU,D&gFL3FA)YJc+?cPWZ,(\E7U7LO34Q=:V
/EDLcSBAZ>;Z_R,BMR1#>);[(0H?S2>65XGcN5PdS>_8/dKUY7#=X@@).=b_6_4f
1@a.8AI9?\5FBT\<(OXDNH9D?Z9F58V_J@F9/,d^6H_LRaBNAIX3&AM_65<MSW14
CALFa>M^)d5HO_7J[R1UT6X>f_T5]^-gI6VD?(;FR.[,K-J:B<d8MJgT_73284V7
(CcbFSZ#GP&]RX]CJ#,WL9&<?IO6+dTU]eFN?)9-I&d.F;YIF:-SOS>fMI^WcE24
?6?J9,Ld3a?b+]L9Mc7BfTHY]53/T^FHXFgU(>>Y/G<P>;8eNYT0,DZ?8WS;;I1D
V-6O3([Z9BJc[#&/Cc=EYOaIW=#-A+#N/.;Qd?)fKPKFbeb]XcVOZ57&YR+3(0fT
9G.U?XX#[Xe-TXJ50_]T;?.@HB4:5<\?1WUE=6,4CH;:E./)N()fMRDa[S1F5:C#
(1PY7R[;K11>[;XHWVC888\H?0#0PAKb:WYFS/[SW<daJCdN[_,PHW5eS:a<D;V/
&U0/B:29C#,fSO\U;X(,[A)&S,()>@c:fcL&\dGQGN?XN5:Jb:GM(4a^/^6=\._Z
Uc>WY)5:(>,54T^3/A<NC#@Q(NaFP8XcKJTM##_BeNW[X3SN]E@36bIKgb3N)R\-
8WK:UXAS/+aE@_2LFCO,JW<Q7&/=OCK;GC(ODPN3C@O3VIX(D=f4aN^+_W;JU=-b
fHW4XUCY]9R.?GY(G[WdE.X]<_)2df,L\5DX5VD<F6XUNLZ40G<LJN8J[G&7&H]@
e>R6DZ(D^8dMKP?[eWZGUH8MNbdA<N7,Y.Q7O?7.-JAAYT/;NOPMZHK(6XRZHT@7
XBa@5eQ\VD947GC<C\SIR<,7PL=0T=MZZ?>6S,)RD#g#c[WS#f_//])S&C3]C28-
9M^L^7)N&VaX:KE;17WdX6UNP_QS4JeSQ]^(TUVB?2DP_KP9BMCN^_))R3E:aPfF
BZf7LLX9OSgLJd0MFF\D7J;#(X[a);5ELA9OTG=c^Z67be>K\;_UBQJ<c\EN2-/c
ET<<,WY4-01U7B<?ZbNH3LH8E_V=^RW]Z0=G)MaVPKI3TU,^QX^8Vb;X0HgH[B\d
B<(:^JXR16]-^RWPXCf:f0SSB;]E7?_HER,B6S-EIfS12RWGKa2P)7L[9EJS/3WI
cZMZJZOb^QVFO3cFW?D3>:d53?=e<]^QXX<L5]b_;8@OT@T39]Ua)P9^8]90ET1N
-3M/_KE^4=X\K\S:EJ.6b_#T(J<Mf1NaWY_7L\T-[>ZFa4?_7M-Bdd?GH4V(e.+)
-^K.GXG9Ec(^d4aCZ86)aJZB1V73;NTd.e(-+ZSND,IUA4)F,^2YG8f8d^-V#FR5
?5_LKW7bAR9>BR<C-5Qf7efSg[g10P#IeZMg@8g<RUfK\>OAZI-O72C=\?ITCN3a
IfP7UQ[UN(Md49&+YMQSIe#2-?>X\CQbZV5KdTM\H>,.71c0C8#N?2^e]FW2LNf.
+#2\FgdcQHUB&fUQ9U<1XS2_cPbCM.>3a6CWa^RW0VUBHfX_18I+Q38EaB]8aa<\
2Ae4bFXC2[&Af>Z_OWJ8eRQM-4)<#YYNUQ8f_\-g()c_5N)PGJ:=W0aYI<&?Q#@P
YQ1(:#NJ1c#g.eQGR+[:b&a&RC.OB8.LFE>@00R;g+(?CZ14NE,CZUIaB]\@1:?Y
BQY;@7?_&,E[G+=YPY[2Jb]T[3Lf98YF<gBZG90RZ,0BN)FedgKaX/>2QVC?B/;;
XedP3>SDPUa<YE\aRX-GLG-+WbY/HP.Q\>(B<J71>S)K8e7XP5LG0)^SENJ5ZBLW
]<MIZ=B+.M:JRbLa[LY(L4X>ZN8^eg>KH<2EVG#)9eLeJ&RUK.4gY93#Cg)E4dKH
9AaK;>(R3b?>>9cYC5M)W95\?CWI;;-D_29)72WIWC)=bL\eBg6>)78eO<_U]d5,
[_@EMa:&_^#>V::LEIR^>)T;G(eaCV.VKb(ZFAXKZf@S4a<Q#7VOO_4(H(L&SFJ1
P<6OXCTG)>G=,f\T0d>6Nef>5\c.^JAQ>,90.)T(Q/f/MR^?SE,@_AdDT+G2-A47
^C\FYE,c9N3VF:#Z7@(0[6/IbT<SZ#K<_DX+H+OEG#^ce9E,05Ve-LPD]^([fMU.
#&X1eHTUN4e78bJ[d:R>>aBa<1#a\db1;FL_=;;Ub3M]J.5IZO4,S#ZX9HKU4H,-
451TEaI=M/UBO.^B]&W8RdR&XD)^LC[0_BF[5+#_RB;\g(.)7dF93d@NbWeZ6efI
e.g&UYN&TCMV5L6H=@KFe,HXYdU?@M85K&RgfV_afBKg[f(YaOY;J8XQ,FDG_]TO
OdC2QAL[=V/Pe?3\<+DHCHMF&FI;:&PN[L=eUHZ<WLG/?gS>N5f.&GFBUa(7T7CB
^_3U2#a]^6[I5T:?E,P>:_S7af1\[-QaX_P8#)aS-4c75Q0?8U2e(M,;Qb_)P<NK
FZ6g#&.A]&JXEVAaFRA6.b0Tc3U-TVY\J?J.8G,/2;T&X<T>G(1[Ea^)e=Z?OKeT
Gg+Q6O,)Y3KA<8Q7ZE#8A#IFSNd[,FFM/O6/B6BI7>+RKbAVE4ST;PN#=2b3JBW-
2VM#PPIIHe(=Ic.3I;RRGQ/1c3?\fUL/5gd(1KIS]P)7cP/1E\\fHL@UJ)gQf+aT
4DdKK9dCQ^O?H\c<)1c8c72A\];fC-;<;?EN)K8Hd5gYH/U@85,9W_(?P3SaX))B
6d58RXe)&_:g3DD<\:@_SF_B.=X3IK]+I&^)\B.SF<(bL91:6f8c&<0H-HdJSK<\
dc8<ITEH>R#gdFQW/KUH\#0N(&.V4(Efb3Lg:O[:Rc>V=g;\ZgIB<HY2M:,2RK#B
C76@S^T=9#DZL)N9O@edf4[_W6cVI=I[#VeR@XMJ^Qd9ACSRCf>W_cfFNA]gc56O
@RJ<IL>)RML#b].NUMSYc_PDN<,d)HE+D9=BK5eTF2gV055,0[L:Z-d0+(Fg:;T(
=LD)^@/#c0HGRWQY(4XaUd22^>TcT+^M_8^YOEOZSKCT2=c>7TJ&4R_,K97H>8N;
-NGD-_17-4U-fPW?&E2^IC0>NcbOCcYMVDJVP19H05LC=.D.RKK?A7^3+bb=eVN1
;@=^O=Y=?AcLCZ#<BfKX8b897&<T_XZK\?J#U\#,FH;6UXN5c\A8\QKZDB0/1=#g
&)RYODF39+?UZ4V4I]\@QDKNH#R@QV7EVP1?aT4I2P>R1_.+bW(2Y)GD[:XK=d\D
.)8F?]@WQ)P&/;#L+a[A#=:/PC9/Y-_#/+Fe]d/bf;)gf@;BTUBd[g^H4CbgC6T_
5FV@N.7K^59=XA0<DWcMGH()Qa;N5@/U.B8Q&R?5/ZP4a2I=2CgT5N_DE?)Ec[/C
C5+9Adb1-+LZ7R.Qcd&Jd6J;+^J5N[&,;K5FVUF4b4O:B?FN=QXABFObTK[8]9Qf
f\Z6>?Ib=K6P1H0_7#KRMMXV2BV<&cDL/MT,Q?4KJDCGDC,_T@M8Fc,<)K2cJa@Q
=Y[K10;5U3/QM;SS>G\dG33;HeY-c^D\g5Ag:Wca>JIOG=TI[\VcP)/.._XBGQLE
TEB?^1R[Y=1=MN_CJ@QRd&Tb2d+?,fce?G&\1_Jbg,O(BJ?c(e[MFY=91:OPa,6_
<T0^(T9T@b:4_-TBZ.NQ>][G_1#^VBFC031O)H2?b\f/>N<OX9^6dYLX.1V]eeBG
<GPefJJPJOcK?9AaRPBA)9]a?bf1]N;=LY,/aBcT0T4/#c,+FKPe1X=9^MY40NI3
;HV>6EP9HEKPUIEC?D&^TbR5/0]OWL76YbE6fe#<1EM#:Ef/-KXK[9VZg5\KF^09
Ff=A0bd[.LJ3T4/8E.X31Q523;-N-6eS6RB+8QI1Z.9OW,_TbM#0JX._\K<1;Z2R
.UMU;J<=H5/geJ/0#\G5CPX&eUG\,3ATcKO]_aTg1@QIBO#&Vb.))3a:b[/Mb7;b
/Q9(e:+.=N.R<<21ee2eC;#]7fdG:U10R2NXg0eGDb8K<BF[11Bg@^#F5OYF742W
F6#=L[.:C_V>d(/]K@WOVGbAPS=]DHE8@HJ&DAdK_-<HAV5<dI^50:+aZ]L[>R>(
_B<8g1?E>^P,G;4K,M@NYXZJ;Z:K,]NM/a)U?R]d\Ld:C&(^_MY:09b3+I\PdEA-
I9+XaT^Y,_V5QR6+=aZfY>#BM@J\\RUK6dLcaR@&9Q@0a4]G^<N_@/5CG6\]#M35
FWA;GO+(&@CaD(KRA]>Z\21<GE3_[WR>B&GN1>BEH,N#5\RdB/+2JE_e9V,N1Ld)
V@OHH5?NW@5UKg1ff3)BR&O9AO<2&a-@=+dH3e>OIDN#_ME@8^F(4K<fN.[QB+CZ
aDf4?(K>1eaO\>eH#KN1e30WRP:9f<NA:S\.9_f@&BCae-W=AF1_gVL7Z\ZC?M?#
Q<b8)D9=K(1M<H)2<XBQ9)gQEK_)MbgD[DMSg?7adE)5Je9<I/bHbTGF;CL;:-0)
_N0B>(7SHZaJ/+27KS<;g,I+&c8Oc&H/Hf)^15JW\XQf^_YG9PC0FMJ;QI5#E,,Q
H@6dV(C.3b&J[ac18K(@)J,eTK2f^2<gM:M<J1L,C@aJJXac5Y7\4?YV_Z20\0R@
A259G7;;,]R9;J&-FLAAZa6f),Z2;^PHPLCDQFK^E=g8MVSRbCI9#IY]TK9bCad[
g(MK8YDg\_@G5[^U0^#>((QZ/EC@)AMP.6:(.^SL8F1=QKZME<]]W&S&_)A+/UR=
136136c=?[U@gD&KD=.D5V:VOFJQ9V2Ud@0c\XT1.J5\b7+KLSOVMUN#aGMgd^=-
GJU=EJd/1cB\&\N(7SC9(A4:P7@[^+?2N2g7TR_&Z[JF+S^^E6?f5,93WXD9\URH
.e2;0,9(FSP2&A<\3SC;A>W+]8(,3O54^E?3&GK&43J(@gbXGMYP:J/ZMQ>L?5((
Q=\fO;S:AED=3,X7>#I0VQeObaWU?M,^4ELT2IePVdX#\EG66,CZ3e:AH]c[/Fb9
dTA6V9P\HWFH#<edE0f9C([C=;>dBF)PaX\D6RBEgJgDWM3eNH\VDQZ8B0N>ICa7
0&bTcA;>\e_GXgZ[,g\XXTbeIY&bA5M(ZU@=dZHa16EZ?=5P:8/SQY=O]?A/1H4M
.W)DReY)9Z_935b.S@c&H6QXVB.+MGUSf\7Y-Q3U#XR/\0R=fKc0KABAUZ0<U2Z.
cJ3JI3=Q>8X+B_5>1Aga4FR1+]JM^,F8f;[T4DgA3R(MaV7ZP/AO???,&N4S]AfM
9)&\/fGFaT>-fAZd4M6b(cD,cXG_^\X<Jg2O?]7)de(C7]/AW[<gRe8e:f#<\/f)
OA4?N1EX/_;KSRGa+9Rbg/fP4:a;;1^1;]NQCRY\]5B6Q8[\X&A#G/DWF&9E-).)
#W^;9.].F9\[+B/E4CMKO<.GP;\FK?A7J2OZF/[D)&FGY2g;^>dV5@PdL]TaAB@f
2]5;;Eb4T6LGOb0dd;<:_,.G3$
`endprotected


`endif // GUARD_SVT_EXCEPTION_LIST_SV
