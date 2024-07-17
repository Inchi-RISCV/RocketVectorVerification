//=======================================================================
// COPYRIGHT (C) 2012-2017 SYNOPSYS INC.
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

`ifndef GUARD_SVT_CONFIG_DB_SV
`define GUARD_SVT_CONFIG_DB_SV

/**
 * Methodology independent configuration database that can be used to share
 * integer values.
 */
class svt_config_int_db#(type T = int);

   static function void set(`SVT_XVM(component) contxt,
                            string scope = "",
                            string variable,
                            T value);
`ifdef SVT_UVM_TECHNOLOGY
      uvm_config_db#(T)::set(contxt, scope, variable, value);
`elsif SVT_OVM_TECHNOLOGY
      if (contxt == null) contxt = ovm_root::get();
      contxt.set_config_int(scope, variable, value);
`endif
   endfunction


   static function bit get(`SVT_XVM(component) contxt,
                           string scope = "",
                           string variable,
                           inout T value);
`ifdef SVT_UVM_TECHNOLOGY
      return uvm_config_db#(T)::get(contxt, scope, variable, value);
`elsif SVT_OVM_TECHNOLOGY
      int val;
      if (contxt == null) contxt = ovm_root::get();
      if (scope != "") variable = {scope, ".", variable};
      get = contxt.get_config_int(variable, val);
      if (get) value = T'(val);
`endif
   endfunction
endclass


/**
 * Methodology independent configuration database that can be used to share
 * string values.
 */
class svt_config_string_db;

   static function void set(`SVT_XVM(component) contxt,
                            string scope = "",
                            string variable,
                            string value);
`ifdef SVT_UVM_TECHNOLOGY
      uvm_config_db#(string)::set(contxt, scope, variable, value);
`elsif SVT_OVM_TECHNOLOGY
      if (contxt == null) contxt = ovm_root::get();
      contxt.set_config_string(scope, variable, value);
`endif
   endfunction


   static function bit get(`SVT_XVM(component) contxt,
                           string scope = "",
                           string variable,
                           inout string value);
`ifdef SVT_UVM_TECHNOLOGY
      return uvm_config_db#(string)::get(contxt, scope, variable, value);
`elsif SVT_OVM_TECHNOLOGY
      if (contxt == null) contxt = ovm_root::get();
      if (scope != "") variable = {scope, ".", variable};
      return contxt.get_config_string(variable, value);
`endif
   endfunction
endclass


/**
 * Methodology independent configuration database that can be used to share
 * object values.
 */
class svt_config_object_db#(type T = int);

   /** Matches the uvm_config_db 'set' signature, but provides support of OVM as well. */
   static function void set(`SVT_XVM(component) contxt,
                            string scope = "",
                            string variable,
                            T value);
`ifdef SVT_UVM_TECHNOLOGY
      uvm_config_db#(T)::set(contxt, scope, variable, value);
`elsif SVT_OVM_TECHNOLOGY
      if (contxt == null) contxt = ovm_root::get();
      contxt.set_config_object(scope, variable, value, 0);
`endif
   endfunction

   /**
    * Alternative to 'set' which can be used to pass an object directly
    * from parent to child and avoid the competition with other similarly
    * named objects stored in other scopes. Used in concert with the
    * 'get_from_parent' method.
    */
   extern static function void set_for_child(`SVT_XVM(component) contxt,
                                             string scope = "",
                                             string variable,
                                             T value);

   /** Matches the uvm_config_db 'get' signature, but provides support of OVM as well. */
   static function bit get(`SVT_XVM(component) contxt,
                           string scope = "",
                           string variable,
                           inout T value);
`ifdef SVT_OVM_TECHNOLOGY
      ovm_object obj;
`endif
      if (contxt == null) contxt = `SVT_XVM(root)::get();
`ifdef SVT_UVM_TECHNOLOGY
      return uvm_config_db#(T)::get(contxt, scope, variable, value);
`elsif SVT_OVM_TECHNOLOGY
      if (scope != "") variable = {scope, ".", variable};
      if (!contxt.get_config_object(variable, obj, 0)) return 0;
      if (obj == null) return 0;
      if (!$cast(value, obj)) begin
         ovm_object_wrapper wobj = T::get_type();
         // Watch out for objects (e.g., svt_ovm_object_wrapper) that don't support get_type very well...
         if (wobj != null) begin
           contxt.ovm_report_fatal("CFG/OBJ/TYP/BAD",
                                   $sformatf("Object configured for \"%s.%s\" is of type \"%s\" instead of type \"%s\".",
                                             contxt.get_full_name(), variable,
                                             obj.get_type_name(), wobj.get_type_name()));
         end else begin
           // Just go to the object directly to get the type.
           contxt.ovm_report_fatal("CFG/OBJ/TYP/BAD",
                                   $sformatf("Object configured for \"%s.%s\" is of type \"%s\" instead of type \"%s\".",
                                             contxt.get_full_name(), variable,
                                             obj.get_type_name(), $typename(T)));
         end
         return 0;
      end
      return 1;
`endif
   endfunction

   /**
    * Alternative to 'get' which can be used to pass an object directly
    * from parent to child and avoid the competition with other similarly
    * named objects stored in other scopes. Used in concert with the
    * 'set_to_child' method.
    *
    * The 'use_fallback' argument can be used to establish the generic
    * 'get' method as a fallback, in the case where the 'get_from_parent'
    * processing doesn't find the object as expected.
    */
   extern static function bit get_from_parent(`SVT_XVM(component) contxt,
                                              string scope = "",
                                              string variable,
                                              inout T value,
                                              input bit use_fallback = 0);

endclass

//svt_vcs_lic_vip_protect
`protected
W8U);1;UB8Ge^M0U&\aII^f@Af+.>I\\Mc:Cc=-NWV)+;A3[M8H)6(d;SPW4F1L1
>E3N7UGB=Z.OZJJH5Fe&-NEe(@PHV)Z\H?+E^06S7,GI^)V=2I6P8bDKHYKg<(IZ
-XJL,QEMNBI:QW)WKDC#gc[3-]?B,M_b_Y.?1W?XO>gf\-bIA>]X_X.[]\&gI>-[
U;:7S2dWFCA_e.(NE/;ZB:0A@P]XN4&8M>OY48YR)8].Y?&GJLdM2OZOC,IRCC.9
C5^Gc]UdMERH20(1LAM-(&P)I<DSa<c7A@;4_g,Aba3,LM]VS8QD9cRe9CD_N]P;
HJB<3B^W/L\D^75/,+a/RX+;I&1)?Lb85f?OW5N>4,HO-/ARXV^)5c0\7B7XEb=_
)?8::4C/R=5QO?_7eOM4NKR&@MG[ZSaAaQ?TO?1GOZ@J+RcN=9[J\ZOZ&[.JM/(O
c,JBTS=We-f=&7ZF6O/FSTY30+2cQ#)5eQ1TgR;1e&^FC?Q,V1[Kd=fQ7D/EW^V6
4?K,S;:#22REB,]B=EZ-Z-9M4?6RUE(cD]e3MFWU_6&O26]0L95BKb=TS]-SaKWU
gU<?P#SL_dW@NZ0K_3HJBfM]H\N_)8SB+45GDNIL^+D<4NWD^7W2IOJ<&0CcU^Cb
5EcB?6HUc[4W)U+[HNbM(9B4@3:BZ2f+GLY98ag\Q/7\g+DTIaJYP=/ST\-SZPNM
V<[[3\>D9;<)d65UG3<_K2I_3D0PPg6g_c\JE1T@538/@DT72:(^P1eSXYE-fXN0
[@aG.d96U;RNQ:DZS_WHN(@fR;A,LTcQHR5<;#DTK(2T/1V/AJ:T4IX=4+c1>FLB
_6<&QAaUA5Sa>=>T\#2\D-FXLE4aG6.Q<^B\g:c0N89JPR]T+DGG/^e[^ZXT=AQL
3U6]RQFT+b]\<NUefI>Z3HS(X/ED\;YY0a_(/:2J6dJ3[V//C>b9?B6>^a3B;YTP
G#TW,PFU5SU[M)\HaMfGGJ)PRa\C-A-BTd6S#IWD#;:Wd^HO383_B0&Tf:/K?)D\
[655K4E02^@?M-D&^U43#8U^>-CQ4G/d607O5+Wb9-@[Qd_-7U)J.GIO&++(8dV3
8=,=.Ve&d.)+HJN,\FBBI,7FROM./?.CK^U28L.;&Z\W49DK]c.PCHf5SQ0Gg[C,
dZ7PgP[##J34KIO<a_NFH=+#?O-dW68YTJ/.d6NRU&0^WN^XcZQ1^\N-/GGY6:)D
5^5HA3=?LVI^>1P7&J<1Y4<_BY?[:F3LHOLC8W2J(<H;)3>McGV]JD17)3K:+-Tf
OD-V#USFD)#)g:HBE[,,#P?G-YZfOWJb47])[M[IG>+VfPTNH5R\)=M1&d6d@c.J
NJ3>,eRR1fLTfNU#&aG:V;Le):L2W[aa>C;IWZ>1gSfO.;T(b.@?E+71NKc6@/W9
RN==1GO2,ED@Vdg:PLG(2g:;E&]NBY<B&dE9K_J=OBD<F1?@WGR83N(BXY+WZ[Rf
4@),b(P6SXI.;M=7FMQZ;W>H4R0@LUDC#<+ba6SN:\63bYg,9\..eObZE>44WOTS
&YL/)666BA23G9Y+DZV8V#]V@-TAC(;<_J&BQ.-Ye>^\e1DHgb=CNA@O8_N2B_WT
]K5GBSG(]48@8:/QE2OEXOBa7/P.]EPVM\;3W@0D>=^]e;QU^2&/?@+[<M;AQJYV
EK/2bRGF\c617.;#QIH,0IA.,JPcZ#DBA^<CMV[YIYOTI._^Q@gIE9N&KM_OP\b1
G]?9>]X/^_,Lb6=)SP.S)8H=)d+@TGUS]>,>NIIb@LC1Od(0\ceJI)[XU(eMYB0\
W<C]6?=IX@I0+@SN2Q,9\85g6F>6-5<\[c#fS-DZQ\4-.@WVBRA[Z>HZW63:HD-a
VR?f&XNfK2\B.Q]6[#19B>N.5Q@ec3J>22N;4SSf=fE@(1fa>ANA:I2V71K)>g>N
8U8-cM>V5TQf\?/&VDGQ6)VB?;R2^)@+C,Kc5GEdQSB4e(O<^RU]&,Y>J#8.AA)N
M0[?JAY>4.G@3Ze&#Cf>D3QQG_PD&=?JGB8O;WC=1L64E$
`endprotected


/**
 * Methodology independent configuration database that can be used to share
 * virtual interface values.
 */
class svt_config_vif_db#(type T = int);

   static function void set(`SVT_XVM(component) contxt,
                            string scope = "",
                            string variable,
                            T value);
`ifdef SVT_UVM_TECHNOLOGY
      uvm_config_db#(T)::set(contxt, scope, variable, value);
`elsif SVT_OVM_TECHNOLOGY
      svt_ovm_object_wrapper#(T) wobj;
      if (contxt == null) contxt = ovm_root::get();
      wobj = new({contxt.get_full_name(), ".", scope, ".", variable});
      wobj.val = value;
      contxt.set_config_object(scope, variable, wobj, 0);
`endif
   endfunction


   static function bit get(`SVT_XVM(component) contxt,
                           string scope = "",
                           string variable,
                           inout T value);
`ifdef SVT_UVM_TECHNOLOGY
      return uvm_config_db#(T)::get(contxt, scope, variable, value);
`elsif SVT_OVM_TECHNOLOGY
      svt_ovm_object_wrapper#(T) wobj;
      value = null;
      if (!svt_config_object_db#(svt_ovm_object_wrapper#(T))::get(contxt,
                                                                  scope,
                                                                  variable,
                                                                  wobj))
         return 0;
      if (wobj == null) return 0;
      if (wobj.val == null) return 0;
      value = wobj.val;
      return 1;
`endif
   endfunction
endclass


`endif // GUARD_SVT_CONFIG_DB_SV
