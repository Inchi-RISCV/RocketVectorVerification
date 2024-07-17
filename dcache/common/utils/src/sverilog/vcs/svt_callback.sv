//=======================================================================
// COPYRIGHT (C) 2011-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_CALLBACK_SOURCE_SV
`define GUARD_SVT_CALLBACK_SOURCE_SV

`ifndef SVT_VMM_TECHNOLOGY
class svt_callback extends `SVT_XVM(callback);

  // ****************************************************************************
  // Private Data Properties
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new callback instance, passing the appropriate argument
   * values to the `SVT_XVM(callback) parent class.
   *
   * @param name Instance name
   */
  extern function new(string suite_name="", string name = "svt_callback");

  //----------------------------------------------------------------------------
  /** Returns this class name as a string. */
  virtual function string get_type_name();
    return "svt_callback";
  endfunction  

  //----------------------------------------------------------------------------
  /**
   * Callback issued by component to allow callbacks to initiate activities.
   * This callback is issued during the start_of_simulation phase.
   *
   * @param component A reference to the component object issuing this callback.
   */
  extern virtual function void startup(`SVT_XVM(component) component);

  //----------------------------------------------------------------------------
  /**
   * Callback issued by component to allow callbacks to finalize activities.
   * This callback is issued during the extract phase.
   *
   * @param component A reference to the component object issuing this callback.
   */
  extern virtual function void extract(`SVT_XVM(component) component);

endclass
`endif

`ifdef SVT_UVM_TECHNOLOGY
typedef svt_callback svt_uvm_callback;
`elsif SVT_OVM_TECHNOLOGY
typedef svt_callback svt_ovm_callback;
`endif

typedef enum {SVT_APPEND, SVT_PREPEND} svt_apprepend;

`ifdef SVT_UVM_TECHNOLOGY
class svt_callbacks#(type T=int, CB=int) extends uvm_callbacks#(T,CB);
endclass
`else
class svt_callbacks#(type T=int, CB=int);

`ifdef SVT_VMM_TECHNOLOGY
  static vmm_log log;
`endif

  static function void add(T obj, CB cb, svt_apprepend ordering=SVT_APPEND);
     
     if (obj == null) begin
`ifdef SVT_OVM_TECHNOLOGY
       `ovm_error("CB/ADD/NULL",
                  "Despite documentation to the contrary, you cannot add a type-wide callback in OVM")
`else
       if (log == null) log = new("svt_callbacks", "global");
       `svt_error("CB/ADD/NULL",
                  "You cannot add a type-wide callback in VMM");
`endif
        return;
     end

`ifdef SVT_OVM_TECHNOLOGY
    begin
      ovm_callbacks#(T,CB) cbs;
      cbs = ovm_callbacks#(T,CB)::`SVT_GET_GLOBAL_CBS();
`ifdef SVT_OVM_2_1_1_3
      cbs.`SVT_ADD_CB(obj, cb, (ordering == SVT_APPEND) ? OVM_APPEND : OVM_PREPEND);
`else
      cbs.`SVT_ADD_CB(obj, cb, ordering == SVT_APPEND);
`endif
    end
`else
    if (ordering == SVT_APPEND) obj.append_callback(cb);
    else obj.prepend_callback(cb);
`endif
  endfunction

  static function void delete(T obj, CB cb);
     
     if (obj == null) begin
`ifdef SVT_OVM_TECHNOLOGY
       `ovm_error("CB/ADD/NULL",
                  "Despite documentation to the contrary, you cannot delete a type-wide callback in OVM")
`else
       if (log == null) log = new("svt_callbacks", "global");
       `svt_error("CB/ADD/NULL",
                  "You cannot delete a type-wide callback in VMM");
`endif
        return;
     end

`ifdef SVT_OVM_TECHNOLOGY
    begin
      ovm_callbacks#(T,CB) cbs;
      cbs = ovm_callbacks#(T,CB)::`SVT_GET_GLOBAL_CBS();
      cbs.`SVT_DELETE_CB(obj, cb);
    end
`else
    obj.unregister_callback(cb);
`endif
  endfunction
endclass
`endif

   
// =============================================================================

//svt_vcs_lic_vip_protect
`protected
A(J/)0=J&cgPb6LWQ4dAE34)UCXY]VD=6ga.Y)\G_;-00S9[5]D:0(+2)_8.,7B:
8QTG=R/b&b0PgH&<W3QR]8K34TH;?L=CcbODODO6I@aEZ456VUa;3JDI5.&(b+4R
@AY,.C7Ec1:<#]2A<M^)+OEL8Z3NW3A0<]f+(12OJVZLU3U;:dQ_6fCHOdcJNW#=
\>L;3R0]62aV&4X>aQPg^.)P0DC_+9J7;6]S#^5L-Nc7cA7HGN/A\fc(#3QSHRdW
Pc)Ka3(Kb0M??[@6FWbP#83GUHYB/=&@GLf)?:VVE2bB7-)7KZe@e=;UD7c[]^>)
SEE.N_S@9)-a?S[e4#-?;F;.<dd[UR^H_)b24+E)/;=CB9XSfL+R2-G?eBP?Cca@
DQ9BFXRF(84GT5Hb#J??QSb?CKU90fCE5]Z98_(1<E4=[/WaI716^/bb[K29RI[7
d^]D7[2>\V0]<,0#O#^KKZfUMA:EYS[S+dEc5GHGX,71<#\D3A]HU8DPQ&dW_\_S
e(d7gALb8:;]>#=.X\UMbLdI\CS#PRY6_<SbZ/Y?)3JM&(#,_/a51)0b+Vb>36]+
?,NS\/GWda0TR47-5@?=@E28@4b43gbO&de^JTL5H2D+FJC&-8M,cE>(7=2]4SbQ
e#5eYP\JTXcY(^?(KC0/SU9U-,M1AS@7&55PV7-8@XSAUf8:G)#b+,_7dQ0,F#PG
0CUTPM>f]RNOZ8TAEH)-Ae0TgNIF<[K)?b?:b:EfUIP6E/D8E\ID-WFP0cN88(OZ
Cc)]7YNIOUVRMfaQ2)W?>/4]L9^0+<?<Zfb80V-G9NN]IHMS=C=g1_AMUH;UPN((
5U](R)g>P]f?b)Bb4N#E91=OXT,@X5UMSSROaL6L+XJASX;IX+U,3>d+&0(]dUZE
\]c-F+WaFHRZJ><3:MPCOZLL96\20Af@9$
`endprotected


`endif // GUARD_SVT_CALLBACK_SOURCE_SV
