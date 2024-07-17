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

`ifndef GUARD_SVT_EXCEPTION_SV
`define GUARD_SVT_EXCEPTION_SV

`include `SVT_SOURCE_MAP_LIB_SRC_SVI(V-2023.12,svt_data_util)

// =============================================================================
/**
 * Base class for all SVT model exception objects. As functionality commonly needed
 * for exceptions for SVT models is defined, it will be implemented (or at least
 * prototyped) in this class.
 */
class svt_exception extends `SVT_DATA_TYPE;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  /**
   * If set to something other than -1, indicates the (first) time at which the error
   * was driven on the physical interface. At the time at which the error is driven,
   * the STARTED notification (an ON/OFF notification) is indicated (i.e. turned ON).
   */
`else
  /**
   * If set to something other than -1, indicates the (first) time at which the error
   * was driven on the physical interface. At the time at which the error is driven,
   * the "begin" event is triggered.
   */
`endif
  real start_time                               = -1;

  /**
   * Indicates if the exception is an exception to be injected, or an exception
   * which has been recognized by the VIP. This is used for deciding if protocol
   * errors should be flagged for this exception. recognized == 0 indicates
   * the exception is to be injected, recognized = 1 indicates the exception
   * has been recognized.
   *
   * The default for this should be setup in the exception constructor. The
   * setting should be based on whether or not the exception CAN be recognized.
   * If it can, then recognized should default to 1 in order to make it
   * less likely that protocol errors could be disabled accidentally. If the
   * exception cannot be recognized, then recognized should default to 0.
   *
   * Since not all suites support exception recognition, the base class assumes
   * that exception recognition is NOT supported and leaves this value initialized
   * to 0.
   */
  bit recognized = 0;

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  `svt_vmm_data_new(svt_exception)
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new instance of the svt_exception class, passing the
   * appropriate argument values to the <b>svt_data</b> parent class.
   *
   * @param log An vmm_log object reference used to replace the default internal
   * logger. The class extension that calls super.new() should pass a reference
   * to its own <i>static</i> log instance.
   * @param suite_name A String that identifies the product suite to which the
   * exception object belongs.
   */
  extern function new( vmm_log log = null, string suite_name = "");
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new instance of the svt_exception class, passing the
   * appropriate argument values to the <b>svt_sequence_item_base</b> parent class.
   *
   * @param name Intance name for this object
   * 
   * @param suite_name A String that identifies the product suite to which the
   * exception object belongs.
   */
  extern function new(string name = "svt_exception_inst", string suite_name = "");
`endif

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
  `svt_data_member_begin(svt_exception)
  `svt_data_member_end(svt_exception)

  // ****************************************************************************
  // Base Class Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Extend the copy method to copy the exception base class fields.
   * 
   * @param to Destination class for the copy operation
   */
  extern virtual function `SVT_DATA_BASE_TYPE do_copy(`SVT_DATA_BASE_TYPE to = null);
  //----------------------------------------------------------------------------
  /**
   * Compares the object with to. Differences are placed in diff.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted.
   * Supports both RELEVANT and COMPLETE compares.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation.
   *
   * @param kind This int indicates the type of byte_size being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in a size calculation based on the
   * non-static fields. All other kind values result in a return value of 0.
   */
  extern virtual function int unsigned byte_size (int kind = -1);

  //----------------------------------------------------------------------------
  /**
   * Packs the object into the bytes buffer, beginning at offset, based on the
   * requested byte_pack kind.
   *
   * @param bytes Buffer that will contain the packed bytes at the end of the operation.
   * @param offset Offset into bytes where the packing is to begin.
   * @param kind This int indicates the type of byte_pack being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * non-static fields being packed and the return of an integer indicating the number of
   * packed bytes. All other kind values result in no change to the buffer contents, and a
   * return value of 0.
   */
  extern virtual function int unsigned do_byte_pack(ref logic [7:0] bytes[], input int unsigned offset = 0, input int kind = -1 );

  //----------------------------------------------------------------------------
  /**
   * Unpacks the object from the bytes buffer, beginning at offset, based on
   * the requested byte_unpack kind.
   *
   * @param bytes Buffer containing the bytes to be unpacked.
   * @param offset Offset into bytes where the unpacking is to begin.
   * @param len Number of bytes to be unpacked.
   * @param kind This int indicates the type of byte_unpack being requested. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in all of the
   * non-static fields being unpacked and the return of an integer indicating the number of
   * unpacked bytes. All other kind values result in no change to the exception contents,
   * and a return value of 0.
   */
  extern virtual function int unsigned do_byte_unpack(const ref logic [7:0] bytes[], input int unsigned offset = 0, input int len = -1, input int kind = -1 );

`else
  // ---------------------------------------------------------------------------
  /**
   * Extend the copy method to copy the exception base class fields.
   *
   * @param rhs Source object to be copied.
   */
  extern virtual function void do_copy(`SVT_XVM(object) rhs);
  // ---------------------------------------------------------------------------
  /** Override the 'do_compare' method to compare fields directly. */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);
  //----------------------------------------------------------------------------
  /**
   * Pack the fields in the exception base class.
   */
  extern virtual function void do_pack(`SVT_XVM(packer) packer);
  //----------------------------------------------------------------------------
  /**
   * Unpack the fields in the exception base class.
   */
  extern virtual function void do_unpack(`SVT_XVM(packer) packer);
`endif

  // ---------------------------------------------------------------------------
  /**
   * Checks to see that the data field values are valid.
   *
   * @param silent bit indicating whether failures should result in warning messages.
   * @param kind This int indicates the type of is_avalid check to attempt. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in verification that the data
   * members are all valid. All other kind values result in a return value of 1.
   */
  extern virtual function bit do_is_valid(bit silent = 1, int kind = -1);

  // ****************************************************************************
  // Utility Methods
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /**
   * Method to change the exception weights as a block.
   */
  extern virtual function void set_constraint_weights(int new_weight);

  //----------------------------------------------------------------------------
  /**
   * Method used to identify whether an exception is a no-op. In situations where
   * its may be impossible to satisfy the exception constraints (e.g., if the weights
   * for the exception types conflict with the current transaction) the extended
   * exception class should provide a no-op exception type and implement this method
   * to return 1 if and only if the type of the chosen exception corresponds to the
   * no-op exception.
   *
   * @return Indicates whether the exception is a valid (0) or no-op (1) exception.
   */
  virtual function bit no_op();
    no_op = 0;
  endfunction

  //----------------------------------------------------------------------------
  /**
   * Injects the error into the transaction associated with the exception.
   * This method is <b>not implemented</b>.
   */
  virtual function void inject_error_into_xact();
  endfunction

  //----------------------------------------------------------------------------
  /**
   * Checks whether this exception collides with another exception, test_exception.
   * This method must be implemented by extended classes.
   *
   * @param test_exception Exception to be checked as a possible collision.
   */
  virtual function int collision(svt_exception test_exception);
    collision = 0;
  endfunction

  //----------------------------------------------------------------------------
  /** Returns a the start_time for the exception. */
  extern virtual function real get_start_time();

  //----------------------------------------------------------------------------
  /**
   * Sets the start_time for the exception.
   *
   * @param start_time Time to be registered as the start_time for the exception.
   */
  extern virtual function void set_start_time(real start_time);

  // ---------------------------------------------------------------------------
  /**
   * Updates the start time to indicate the exception has been driven and generates
   * the STARTED notification.
   */
  extern virtual function void error_driven();

  // ---------------------------------------------------------------------------
  /** Returns a string which provides a description of the exception. */
  virtual function string get_description();
    get_description = "";
  endfunction

  // ****************************************************************************
  // Command Support Methods
  // ****************************************************************************

  // ---------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command
   * code to retrieve the value of a single named property of a data class derived
   * from this class. If the <b>prop_name</b> argument does not match a property of
   * the class, or if the <b>array_ix</b> argument is not zero and does not point to
   * a valid array element, this function returns '0'. Otherwise it returns '1', with
   * the value of the <b>prop_val</b> argument assigned to the value of the specified
   * property. However, If the property is a sub-object, a reference to it is
   * assigned to the <b>data_obj</b> (ref) argument. In that case, the <b>prop_val</b>
   * argument is meaningless. The component will then store the data object reference
   * in its temporary data object array, and return a handle to its location as the
   * <b>prop_val</b> argument of the <b>get_data_prop</b> task of its component.
   * The command testbench code must then use <i>that</i> handle to access the
   * properties of the sub-object.
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
   * @param data_obj If the property is not a sub-object, this argument is assigned to
   * <i>null</i>. If the property is a sub-object, a reference to it is assigned to
   * this (ref) argument. In that case, the <b>prop_val</b> argument is meaningless.
   * The component will then store the data object reference in its temporary data
   * object array, and return a handle to its location as the <b>prop_val</b> argument
   * of the <b>get_data_prop</b> task of its component. The command testbench code
   * must then use <i>that</i> handle to access the properties of the sub-object.
   * 
   * @return A single bit representing whether or not a valid property was retrieved.
   */
  extern virtual function bit get_prop_val(string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);

  // ---------------------------------------------------------------------------
  /**
   * This method is used by a component's command interface, to allow command code
   * to set the value of a single named property of a data class derived from this
   * class. This method cannot be used to set the value of a sub-object, since
   * sub-object consruction is taken care of automatically by the command interface.
   * If the <b>prop_name</b> argument does not match a property of the class, or it
   * matches a sub-object of the class, or if the <b>array_ix</b> argument is not
   * zero and does not point to a valid array element, this function returns '0'.
   * Otherwise it returns '1'.
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
endclass

// =============================================================================

//svt_vcs_lic_vip_protect
`protected
dJ/F0OY&BKM=b.<1SeGD(dR6IBb1(EJ?[?M3cgN(PJATc3EP:a5G0(?A,N=_K)8H
Q<LJgH_PO29FeHLN:fI=1c)3]?TP&cWeTg3U?eP:PD+.</33&.-D5(b^cF?bPVSZ
@M[7JI&fc<N:=B^/<6GTQN(e[?a+QFMQ>IG?YR?VAM0IDFF5g;:,;G/V]4E.-+K_
_9),&Nb[U_CNYW3;7d?6E->-;R4Q(\@2POdMG6McIM<KWeC/DLZV+OSZ:H72XNQG
&)&E;7-G4JH36ISP:-/UK\DYT33-(;6C.YPf0XWMaTbKR7X\dEDAAg)[efLX:M_/
Z,Hg^1/[FJ#I^+,(1?Jf,bfSOa?LcfSO?BXY&0FgN>;A=)5beY5,CL;Sf.]>S0;+
\(WR9#DW\UM/9FH/WI>A?+2CN(;4RQ6/TCV7B>D9O?VP^B+L\WP-1;\LA7/D+0RJ
Q3=.ERKDaNYOJ@83X?)B;1)._5>)OLb8N-H_Y-3UBPOL:01c^9(^111fC_\(CDWD
fL[Z>\+Od7=e-/IfP]cQe7PS;R3EE:60/L\^1bbQL3WF.bEZd1JJWZKZ@P==>6>=
R\,.6-LVgO@f1Y7Z#=Y&LD;/36DF-?61WA6^VP6M=3GISH,76)f</FGJ6W)Ib5>A
J1](;V_C9N]WK,bEdH87DB[P0gPMD5WWeT.<MQ;2X=S_d&\->g@G+;?4WVf[G#eP
=NE]S@b(eWE3]\U/\f8W+Xc<;^>=dHRA9Bf_HK9K6F&Ig&4[WCW@ZAg2:(=H4#3)
YQ71#Ig9?@DdBbb9:@3B?KG7NAa]23MY8;CD4aIF:<AeNB@E.(V]V26]=\P.XJJd
BLA;a\S,Ac40OA5WY3HcA0B\<c8EU[11Yg\ea)d_4c,PZ9eUNG.Y.G#RO7-\>I,P
\=-B9,4[L/,2[LT:9@RN[;/cRDA-7G3L3GU<F;A6[[BUD@PYc:BgYT./=_C\S)4?
Q4b0POFfXW=AIE?HF8L-+LWY_bgLSe/M9dd=OKg[)])?_>e,CT-++N1IC(N=N\>S
)F6N;W_)V:,H+L/Y-IK@+#cP8f(J&)[TNS)V:+,Lg?Df]Tf,9Z>?Eb?4IT/O:RE:
7CL0?&AXN+O0KI.G?,2YSFX873+4G])BgV&c>83GT,=C[5.\^NTTdH\L.,3]2M7e
-6YFMY=JaVP-;2YHNIFR.2TH=L@+?^XOCI3F2[(YBLf,6Y_HJ&H7^MLTTXO8,AJB
QRR/]+cRLK=&2YDbC(\#>Q:G_&J=8,/IReaZOK=V]5,ba5.,+T-(a9JgAW5(>N4B
f-d,Ha7\-:N4[N47>d\^O/BUK337G\29/cd?J<+?DcJEbeADUTE3IGcNF&KXR<@A
DYQ99ZLC+R7]>c<N(,_/L-:G<Ja<N)83#QDLE^UD[BLPf:L9/5f1GE:VVDbVeB([
>TS))W=gP+e,=KB@?7[];[(09R?f\TdWTg4eBO=#c>K]g4Nd@g8C;QR1:7eV_GHc
+KdB=G>8(I.1g-GIROZ-<?S=d#4I:V,L;Z5FG,ZD<)VEfeIR5YT4/I=/M:9H:_+A
[>^<IKO975eE0(]?R1g(L@cZ[5-V=T_G\NG5Ig#ZgZ4J2Y(IW/A;1\L-JJQ<,:XO
2W,8\\Z-EQ9bZ,UfVG,7OK9Mb(CY=2Ca9Y)f41ba):+8_-UEK^b#+R>0P.,-0EFF
g4+=fEb<1E/]g?D^[,PXJ9V_c&JVOcXO=^5+A.V(V##+4cK&+dFMb@A]J9ZBbHM=
^a4SOb/=R:57LL_06&W5+N,R>J#d45)L7V<-4K8;8;62,R?+=[dU:c^7fG@5EQ@]
ePZAg1d_D&)I-FDW@@V6CZgBV/O#T>cF>8\HRGTY]CeW;UcYd-D=:=BB_>3UQB=g
1;Jc^RPXA;.?NP6JYKY(6U[_][P#+J0fa-BaNFY\)-_9?YE5SU#7SQ8D;.G4_g3]
,#7F)<<B<4g)bDVM@-_OZc7R,UBC6cHKD5N-B&PS,(@U8GKJ@Ed=PQgDKVT:JR0J
B[(S]F;Z^(CLU8g(9(eTf1#M+WB<1WI-UP#+d/S1#Z^e3E),L3WJRGYH/WYAP9BI
:]/DC7_;0:#9T4Zfe=J50\VcD>>._(_LXOH]IKZO(/WYFW84H3&aYXN(DZU_6fJb
Ya/9a^7^#)8[#K0N[#4MB&;7V0NO1Q0,7I/4>QS9=>^5.8eV-7PK#Q;eDVJAFZBe
4]+IZ#C:Q@SOD+&T@]3),;#gR/YI#XO),=6(RO[;-e^E_WK^c^A:N;D8[4-Q&bH&
dP4#--;K.A&Y<1WU=UL(J;ecHMKY#YfLJ<F^<1ZMC&T61HZ5T\&TY3#M-P+;^TVg
D/7JUVb1A-EV1QL74B9V@GF>-F_1&.C([P-;6T]\W,Ba2\A6A39HK@WKE)5[,88X
#@SJcDK)M_P_)T@,=?HCf?1E,+_@A4@7b82[Bg0fPZNQ2[LUFJ[<=NNKSC[D4H))
AMSTLRA,W.Z=\87d0,5RVH),Jd2RW\J41.G\B&RH7<694)BTTE\D+9FE4?UA7cdc
YgLeWb0D+E=]5HBSH,P^4&Y/]9_U_86)Q1BBIJIGaeI3G[4:G#I5P20?+d:RK#_,
UbKM)Ge^==R#cD>HMST8]F1?GDFQQEGUZ1^>_5\YRa?-9a>VA6BK7PXA6+d9O0BA
/P5G<b@8Wg7XD;MBMDU5)GC=4H:]fX=G]CH0Q.c5N^2Z]EWF.DH?LBbgX#O+V>&.
2Y&(N5/1c\=gJe3KNd7TJBG2^@58V5,XLDK:eV0gS-eJeK0+RK/1DcHV:IP;,/_J
KL+fOD&8\]/QU<7C))PYH7&LEKcCFV>Y:HJF3Kg]f/Ca8YOCIS9(Q+^ZYa64cX3R
\/R4HAJc8+MfW4(8AUUNUBNBGe7DJ?O#<-UT9[R7TUZ2;g98^.+(FWGX\3P+7#T4
JV##X-ZdF@c:@?2WTFd)eB(-6]B_<R-L[PdKP\/&O=FEJeZDd]O+R17bYfP[#gXa
RF4dLK^Tc8J5\XJGLTW6HCN=7]+THQ]Z3KEJc:V2_\E0U^24B+J-?<T_<&9CI1I;
0;J2]G_N5XY=,B=I<;3eU#@#ce0UEU/OHMBV0X^?C-Z]8b?3E<PJ(J^dXGG5&FAa
6KT-aF;TL)b,b8fWI6L2M\FKFgQZ0\1g5U,-E1Y,:R0EI@c,(R[;O_DE_T9:?TP]
\5SR>ICDXO6I[9+L??dVDc788fHM/W\]KYN;0UR>Q(=2P>]K#L8D/4-S5dXHE>N,
SVJSVa]5PU48_e#9)8]Oc\c@WV(NHN/J0)JEYS>dAG[Q;07E<gf2PBR;?BBg;aFd
O?#(N5GN798C<Xb3]9@b9OE4BR5=1#Y5><2;bVG?Zc03;6TC(E:::)-B@>\K#fI?
aPLbJ(4Rg=.4V9Y@VEaQfMZM2E9VU&Ea6B^)#.9fG:#YR<Q2>(Wb:>P2&660SA#]
DI?SVX1/>c,0a_X,@Q,V7_NF-@><P1C]<#:3RC6X-H/)CZT+\4aeb\50gP8I1YT?
QB/Fc&fAKU^5R\8\T:^BX>Pd=L]FYWcY3G3ACC:7=POTf:MP)7L+cMbEDW:5[f<#
W_Eg.CU<S_P?e#9A:0bIg[0IeHBf_2/-/R/GaFW-8\bJ1(>T/@]O+[AA#7:g;FZ9
.W_aAO+.ES7d?ZP;I^dTU&1&X4VAg>@d09F_-fea<TX0)A0<5QfEg]V91SLVB@8,
^8;_L7X\>>0eU#&NFb[X5Xe;f>/2^NT/]>.H11&9N&D<4#F9?5J1GY\##CRR&ZY,
9b<Ee&Z[_Z0#_^M]8L#a=O@>Y>UVL+G-,JBG&0(#80C4-/S0_YTEgG+S:8?Fe9BF
/b1M:?.C[?Bb?P85E+768]4.6(1?ATYd=<Nc?G^>XJS,6#Q+7WC1)dYgM=]1=(0J
#CK2(WDA[QJK5&R&\cJP)?<3dENQTQ#G[W2;OBEMVc;)Gg&aFfPS>ME?24Y3MQTK
TG4JF^QIEcN=:c6>Z#2^SXGIO(,)U]e;<S(?/P(F+SP)KPJa4VO)O]S)XOWGK8JJ
)#6P&CTD:b/,eZe2dO@RAK/:H;2D,B44-8@[DE)TDZ77P[<C2\PV>S[WR=6eYbLf
ZN=3H08LUTZ5aC6acWL41^e;.WR6.BHNOFRCT8;2Y8SCN)Q3(c/HR#/8AX/6fH)Z
G@NfF2#S#RY=GXR8g]7@0:gJADX2JFJWeMbN6]Q,EgecAg.<@010Y/M]@FAO-;Ad
X0<2+YGY;^?:PG-KO#>gW/VDIfR0JU0^YA:g.0C_P0)[;,[D<&d3+VA<b4M;VR_F
?2c&3>WcB2I1f5A+:I5TYXNX7J2>_N4d4?AU,]&S1[WEB#A8<<(d2eU=M&OQ(M#O
0V]f5HRDI.a@UI>Q@1S#,[L74Jg#BO/3@[>;9Cb,XI?Q\TNU1DJ8\I_:CAW#>bY4
c=IGDJ9Y<:])#.a(eD2CAQ1.[XYe#-D&;8G-9c4@\+I(BfL8V,H41G@\ANM0C/^I
_-O0A(-3R\)NTcC21f\/eV72=19M(,7afU2MZ6)70I-BV+#WE5LOS8c;>ST6?cL#
Ee8?YRcR(U:F@\0EfM0>:[=JT:Xe2?C:d0#/Rc5F>e(&(6TUZ,D4UO0f,+A5C<>K
RJ:NbAIEN(AH?LMX[I8&VM^;I9WD)^UISPRb?I[Y8dZKYW5NdU37Q0IV&34cIC]3
T12;,)f=AY0bg]^E>f(QWQf76FcD#;-F<OP<ee(C_GVP-@L1JdfX)cI[>\7cA0ZX
,LS<&RN<O^H#QK?0Uf:NPQ1\I6GSVb)I977)f:P8:\:A]<DWUP&eST0T?Ua:@IW_
>?]FJ26;APTMN9cRO7/c^1\d.?PSCLC,1:HR=bV5<FF=aeg1d1&(/W)N+KB2WE/W
K7fcK?5YLeF@B?/09HPBP1JK?H3a99[#[K+]#DWFOD/#\2Z+,8-addU4V_gA._/&
Zb?6AaRdFcCGf-]R?U/O=N=]ZDMB41<CP)0PQ&M-WT3</D3<63?S[N86H8I&3_fV
YFPOA99IYY\d?=T4aO]UJ_:NE?_#e@+7KTVZ)FOa?^_OLFD791/B[2S_Fg,CbJ<C
1DBGT<T]LX3e(Wa;8?DWO?7=NV8ELbE3<QTR<1,>EbO<F@WJ1MZ4JXU7.=&&V(CJ
CFMTg54,.R?.P^\(b&KCYP1?1NW=4c+_W97DR/&Y-;K4@?]&<K8F8bdHZ1BN[K7c
M)05.db&&KJR^BB283(U#a)^f&);2+@DEWf>)#4L0J)gR>I-_A2VV83Q82H6JbgG
#33)F5+OGFDbS8c5@@<>Gf4;RIbYNHg6:C<Vb&FdKYEW4:g1A5RRV\Fdd\+BALP^
He9,K;a(E>3,(V\FNJ:I=[g1X&ZIKVC/CEE,N,B@N6^B7a\/<Ke-H:8_K>174\;,
b;0QV@\<H+71fa44YT;+,H[(P0GOU=:5DFKM@29CRR.cG(0<\I4UQReX.XS2;B1#
eR[Z_Xadd;P@T,N0UKMQZ<7JR9G6(;[J1DJ1BgIN3N6CY/?TA7BR/ZT((-#Q&(<c
dcE]f0XBN+XKB@KPFgdB\7=KMJ?R38=QQ@,7<X>B_0,4P-N\UbcS&03/edJK6R<f
]PF6/f_c@2\VX4;&+b-05fC1LY?>U2[Qc;GO]M10O<67FTCca.5:MV[&8Bd</#:L
F+6c.D3D^/+_d5+F^<K5ga,7+\#,LLN=N79eVf_6\2_>^[,,5<bW\3_L0<Q8?2bN
0Y&dc4S1QA9##AgL1<42L9Lb/eSY@5F.2JP:5K5ZW4HZN4E[g3LBL@;Q1CF_.H3e
1MQPG9240cIB>A@9<?N=dR(?:3HaI29+T0,0T1Q[6LG<5Q;g1=>):b[2ASPOE2gG
Y@2JcDEMD-O64>_ff9H9d&T1I:5F/48-<(V1S)@FUO4@B2]TUEe]Wd^G;<BTS5?B
FVBYf27+bR,)gUKVc=bX91R?J;g/(9g9&CK@+;L/6\/[#U8B3KEHca@8R9PZ-3>W
@<TGe>(PU</6=^;91?BUF(UQPTGU,7B)^LX7VG<?(/\8<c)?B[:D87b3?YeWf8>7
YM,VaJd.\aC:6@/DIQWgBd_gNKWY<=#U>_/7/0.WO,g(D).(cRJ7CAS#1;(A:9W(
c)=dXH45;Z>/(Ag56GD^\&5+ccV[2=T5T#O-e113>R?=QDgaLb(EL4a&dc(^GBW-
L22D2O7TC8)_?08_&=_[bX2eD=[0W&K?5^V2316J;-6J0+D2;4+K>]=L19\A5BW3
ZVAgYVWU3AgUI<5Q]9UF&ca(d(@)Y3,V:;+/0RbR#(c>0&gP[DAJ]VYeCRGbe>^+
VOSZM7,IOYOPWd?,-Y,\3g[fJ\[5/RN=/+,6LP8FL&EE9e@dB;DT2ZOR3eA1KG.6
Z86E8b7]@Y[9.0ZG;P=80:1/6>0EZef)a67D_7B+b^^a\F45]=QIG&G:a0Y^aL;G
UX/KQO+7U^_3SgYI8eGXSW[7>Z4A8_b_9=9B&40@HC7Z>[^HG9>R(NU)Cc<cO2]L
^\P6W9M;IZF.gOabAA_GY7]DQ1L><4:QLfEFC\?JP.(+,G[H8(TMUdB?Wcc5a9Q/
S.9][W9HBO&;:;Oe,+F0>#1VH6_X:4+4g(OdBdbK?.Pd[)W>0P@Y:[.11U.E,)2g
,4/&H365DVS@+UIDgF9H9KP/ROAOQB.b+#<[7JOBD<_4IG7+c(dSb]PRTPPg^IE@
4b,1:a@RXY[;11QC3^6KJH8SBd\fF=e9GY;J&G0<MT)RKG5-XL>eX]>X>[,^MCa=
O-UE2GJSDM;T9R<?YaH6SQ&]DIS619QM8cC6DMf:_+/?:fc)6e8,9H7I=7L2N0GX
MF?K<bPMaZB/EQ#3bSU9_daK^PEOCY-#:K5IK#CcYYVO3f0,(K9>d]EE/VD\#[_W
_;D:_<R)R?cJ>T:AGA&(6^Cc65C4>/4U:5.dCdJ1Y=28V=RDEdLb][#g1/X&&Y4_
3B/+(X@VeXV;V>D[@MY@+4I?@5WVTN@MN;0XXNPP4,aWX[0#B=9JL^D?PV;b6G@c
P.X9=>P8V/>dBUbDM0@G.Q,cLC1F[a.Y:/V>73g6I-GF3XI6eUZ-TCS\)YEE<>MQ
JJ=C(O53RTRELUA6Ue4-:&H>OG-YJ\X&E1P=&E[[XBE[6d&1::I;OVUSaIOf[C1e
(:49dY]:Od8aZ2]3U:IbV,bHYV,-JL5CYJ8NPF@Q]K:U7O:W]8A2gWab,ZDe8a)=
f@^BLg9JGO@6[C=RMAabJB?@Z(&A:ZT<8G2@BO&T.c7SA#Z4;f](fWCDa&XCY0XQ
eJK,\\b4=J(4gA5R#6cKEbaG9SH-//>EZeG/:(aGG,6Rg__OQ7;-g7-fgU8_=8W3
2H+Hc9(T+b66ARf2,U(Ta+e-9BgV6J46OSFPS=(.IJE).T=F_;];dK_P?])[^4+(
YKX6FY->13,V023X_Z-:b\c##Cg0<[FcXBK4f0E-QJ\g)0FW?I@F#KU)UU.9.G?(
U>b(AaeQO=b/<a@RfEVNLg;[FQZg@bONY8/[EK[_QIFYB4:EaC[K#WF+]bbg>[VS
CHZ@0H>H:.2Z<RKNGJSSfB1GV<FAIERZ(a.OQbC,b30e</e_Ng;GNg=>HWDKTQ3F
6F@\:1.c:5g7K1M<PGCX:d#M;VSRD?..T,S5[3gLM@NeMB198VN+FBa@><IcOgM?
1T;RYJP=?3^XJZ-bY72&:6^5e2ORCI[>88L/95Y/5U_@#&_9G#AO&WWAbNTP/+3V
#)-+JDK2GWL4.e>3=[E;T_.[1fG3g-WC.?S3C\\1]79&1Y(^_EJ]WX[gAR&b5eZG
G7a3D]cO&6Yf2f7NTL&F:,_bPUa6CbS^3+b6>3_F1[&6#&[\cU?EX:5(8(1GY7N5
CbYZ13PD&a]G\d<36Z/EUEg@a)O[cE4^MKIgMDL<E@IG4<[:2K^QL=(FQJI1bc0D
^/3TT-=92^<c3+24P+ZIH[FZ0Dd(B-KbR]X13HdGEOBO)F@K:aZXB.dc\)+;JB@d
\RJ:OBJdb2@J7;agSSJF\2ABSA;F_]+7JeSWN\La^aVb7_PJ3.J4^:5^-O=KF]C5
Z9ASBd=0/:6&##([XbO<>)NA>R?2RAEUNP(fSBVD)[5d<^3+4O;ZbPUTENRR@J&1
USK.d.+@_9:D&MH2g\c\?ASIC(9<PJ:c\7KZOSWCXUY,FIA?O:7&_Wf)A+W300S=
5O5Y<dTCgH7=R0\@.,fU=e](#c,1d3>\cVQ,U1A3\#Vc::@,?6U.IXf.HXKYG26F
K=/N^1-bD)N(gJO+OW]:d(b]>5fKFeDIVD/f+cb=.\^4X=_:Ia9-&.#R\aZ3E=M4
S41f;B@]\QB=+>C9I^3I&6c(,GNQd[::X+>V>/V/U_ZfKU;>OWRH\#/&6aZSM^]L
VQF0_7e;2LG=EVID:5#@T2E2;[Z:b4@&O<(e/[&]/DA+O&G.NSF,HQ\<-4#G]I^1
\BFDZYSSM]G1eA01e<(cdU)BF8_FVaYaL-0X;);Ze[JJ24>Bb(ON435R&71G5[.:
#>BTJ4,2AH-Y.HP.f17Vc>g4+b0F=ITE<CNd#R:H;AFUGA.41#Q@@P-R=KW1a:<4
b8#W=C[<G=U,,)#9;bY^A&W@^Z\7\B[ZRg8#<B0&e^A)8U_H<WK7MN79b)@^^RXf
bA7e;U&]6CgeVYMd9\HZ^-T#KTFf(]A-&dE?=>5.3CFg,5KOURaH6S0Fa8]HA?BB
DeaA3^NEVMEIK,;9SOCeeB,MaHa-dfa7P<ab[&FIR1f::LR#BK]>Q7/D2OD^/[^O
R.>AeKGSf^(C@)1HT@V>DGe&F[ZSOY9eFg>80d1GN6D,6>fRG@bfeH#f]OX_H?10
>IfgA#XZ?b;HD?b_F(f,9e_9QRH7Ff@I)g_MQ,_<f9gDEV)KL;:6Q+aFOF5VE+&9
^N@Y#7F<B3W4VS>V:RV?]@MG)/OHLTe-A^6PSU>b75VM<D#d&^U(T,b3IUV,aTH9
=PU(ED^f<^?=RdI07#=gZaI]6]3YO&KO5L#F]@2,AE?a1N_VFP3e6AC&W.BH[cXH
U9-HUW-aV;FAU.F5Ja5Z6?3TB1^CG;.?NJaI=(XL^7cY@c?G5[WMD\_GV&QIO-I&
=Va@cNM5L3YZT4J9LC?f2g)U\2aH5O&M33cZ[.T)D?RU\+0J1V_.;S@0<3(1+BJ]
@0CFAE#<3?gb<5/P>#6N^EDZLgLCNd)Q#4Mc_JC6-?T[Q:26d81(LfNUZDf3&G[3
OVA(,NULO]4dEK\:#P1OQ?[R^]>b&2e3?FB)QRg?8P_8V,e)EeSJX_6R&I\GAf^[
c?S[8Z.e6,:T9QSJ.\D;^&d^.LO?2/H=ed-BEL6Q#\+G/@CQf4Gf2dKH,WVe;90G
X;6gG,_BX1X?-DK/#MIR0BM5.aFU#\_d0#[2M7:eM;.+WT\[/_BbYOP^G95R-_]3
\ScdZd<_BH?cM/D@:_g?]O=Gc+C@69A/f<H1>&DW[e>U95_d2+;9+-UQAcQ::74@
F/4YW=a[,;9+PNE0\6;SH7<&;M@5M:=Zb@D]b>5=cWT<a\38\^-;O?B/Y<6ZT[>R
.GZFeDVJ7AQWKcWa\ZA0Ob#+&OZP[/10QL;GZO_1?<9+5c/L=gPcO8TT&ZZd7>TB
2Ve6JS1P1NZSZN@7?a.#QI>R&RJ(?6V\O_J5[:&CDA;LT]b6@X[9JV<)^FF]e:CE
aT]b3,b2e:#C?_)Vf3SVW@0/NTWH_F2E01+aLL:U/YT_a]\R<NX)84UfNO.Nd).1
bMc,Wc?Y0GT+.\4/aQe6P\:^NCYJ)OFM70S_S8TaAZ:T0-0DL9L\F<:@:Q,HCRd;
XGD;5XfKcW1)-Nb2F/Y^.HNKBMHa=;>ebPRE4O/2B1d\8XHVG:SF1A=3fHO2W/>-
30\J=[H8;De-Kf^4KBV3AB_R4,g>Q:G,/>g5g:F61#;.&+V]B/H1dJ(LDO87XdZX
B=9C9K/^D(O7E@VO@CO7CC<J>&BS4044TAfFcMV>(]^H(665g89d,YcU7&NRKEEY
Q5EUFZ-EK[afMZ]:\1#d)c#-_6#G[P-MgRGJ5FFR>dJD@F\S3>/PJ_Q6,#I]gMF4
-5aYfJ9Pb.XPHH@SW#@]Kd@R6DG6C1&R774DCdZ.d?ZF4=J-[I]1&P_8_]dP+F+c
,A:[#eKU9XY5&Lbf1M224EC7AK9Q^#D1)+^P_Xf\E_Jf3-DQ82cRPdfP6_0FXK,B
TL<G6:.>e&?1W/f/(Jc4#7XY(NP/TMMR46(0D_]S7gB:6Zgg.M^9c2J:NTD+_6A#
HCP7=N^4Ed@1,&&eAZf<?U9cGS3HCI9/1BYX\A;I=?M7V#ZRZHa[._QO&WW.7HD3
<G50D9=Vg[.RU2\/fG?3I4BbB)]P&)^LcVC/Bcg8K#6.:,DGDF-A0-UB1,-a3@fV
+,=\PR]WK345+6IA.R&5e=OE[Y.3<,gQePM>SAb?9A[KdM+0Z02-&-09QITI,65b
[.LA=P+a-Ab=6F=&N21./g6V+;9Y?eQ[60<3EC=AW>(;)TTfTSU\0#.4[<J;_NCb
3[Y4/O1Y,F4TfE.e:J_M:)\bA,WOHMT]daLW7;1>7Tbd.?0Of22[=(,c^4>J6Pfc
#Ib6+I=LV7-O_/d?#1beG6#](JAKAb4YePNM#fV#^JF?I]>g?RN>Teg:PX?5b&a-
8V,E:E7EEE=;E7>=95EC)D&M]0N7Sg\C7\C]J(DGF@YI_/Pb@JP6&S#-9R<#)5#9
RV5AWd3_HRNe(-N7P9,\B@Q-/9J/JW4bWaf-.?2.CaEA4^57/-B;#>ZS@;PLOEXF
C[O4]\A57,Y>4J5f.Z-RY0O2:VEB7M=dVEH_.O./OY1e.P1=BRE:M]SVH]V(G,Ua
\;d@dGPN:-DSZ:#XV_g&:AMLe).:JL;Z0Q0I4\^87_Mb.9:d]/5OQQ09S3Z;.;gI
TDagNa,S_@5#\LKE=6dII9KaN?3G-;]I0G=40UM_-Gg_L+_bV0#_7PN<\NZ]4,[T
TX/=eWW,+M>\#RbFA2I++b8O3MUNU@&\WTPWT8c^7W;/=XHZ8?&]:KLNCc3@FBKK
@>/(4P0:?S6_LHM(Y;O42E-;>X=Va+bB?R8-&D9C4Q89VJ@JQ<S\(W>.U&]7_6+8
1)(]AeH&C1+I8I.)dQN]4GEBD)f\._E;KNU._K/ZJgf14]034.2])8&eMa++]TQ^
O(&a/?3X^[J)H?]&CH5/C1O&U>TUd0+]/aI_,(>3+49E>26KE3f=H^6b:+Q[#>Y2
\.XC4ROG]ZdO?1EO83LSA0Q4+.WM]c\J,(W7Z)RSb=+<;&_R#JfMga[dNXR1V.WQ
2a.2g:If,@gMWTZCe(Q+eC;&3WQQ4\MOCa=IaU1YC_W<&7#4QY-bb\bC.,0(:[P5
++NfPbK7HcU6X96[Rgf#2E<)9,MLR@gX#]XZ:1.-&0<OgF#(X,cD.?JHX/FFbSUG
BPf#cd:4+@X;C;8:X65<TDTaNO700(dA5A=gfJd=<)9Vf9^beLa/CGRe<Q=G/05E
6cd,8IS3cON/91^+S;@SSUOU[CLR2HPc[b1A<MP+VC=HfOU1K6V.3[4\b#PK&Y2:
]L(A/;U?ZS?]?b42P>\?;+a\+(QSI^b_.[35+YEbaMYfNRTP7)WZG_H&?ESIC;Y<
25:CD\OGGE)R,4AD>J+a9YW[AW#YJ)=XJgU)G-,Z5E4K#Z3X<7\Vd^@=M\\L,(+[
//ZFV]Y(],O=(++9\]5\MZ&;/JJ;&=MUA-D]>R-:,9@cQTYPP-1a@=9\_&&c1b+N
EX&]6MaA2DOY&A&-3/5K6;6E,]BQd&SNd.,43L9L&Ma/L-LfDXQB(3DJ1>5X44K(
R5NW9ZWRT\;Pg0.a>eZ3-B9HgE6c<M&DIH9+NWD5Z=^SBgRd>A<>[_Y1eQ+gc(T6
]-b2]Za-AT>aZ>W/141a\4C\f^N+bga]0E,H</B#GeG=I>.1Q8<-\/)2_,9JC<+L
^4D^fFAYFZ::]@VX[^WP#Ae]CSN92J,5VGc-RN=[.RHbfL.4K\7#b.M[M.1/G7.;
F4JSY,cWP0U^Hc.e<&EX\_gN(XdfgELO8,/DKQV\HE0\2O)P)05^TZBB-&TL8^aQ
GNc.O4Ub[CgS8NS0Y96)4:M(E-HP-Hd37Of-,c(LP=I_02;^Tb36L+X-.H/9X;2G
(S8=5W/@X.FbZC.I&Q7KEV>e\#>&d;LOaEgAYH6D^O<>AL72H:\K)XM93;Wf>SB,
>1ODgW/#6@NSa]AWK)#-TfRJTZ@6F3B1Q=G41TWR#YcA;SN3Z))>A9YB,H[L,V)[
)(DDd;^]=[+,1e&D9Qd&Wa1cc988LN?I@IAcC:3H2DeS=N7-#&RSdOIY#aGQJ?_@
OS:@+4RFc1T3=;9_5ZYBIN?Oc+dCc/#8#d829J?F6_?(TKC:7TQR<->>II3dcGI9
PK)H6aOSA^,8BKQRY=@@V<,S-B^?2^(V0S;XT09#?-RYWOag/2W85R..d=0aFDIP
SAP@9f9VQ\Uf8b>(UG31NcSPd1Pe&D.YR1?JX+b3]2;Q2fACBC9IcHJ1V<A1W4]M
U#95(4VBENQ\M1XY(?3<#F._DB\fQ_.BEa/?Q?BbZ&ERRa-^(Y5B>d(A(_LREeRU
?5D&0GE[T)RXd61OY[72<)>B__4+=1ZZDC<>1fNB98-e>6X21IO+)Uc]P:<G=]U.
@T1:>>=Icd?,5&Bf5.F/dc;J/+]2W0FM6dKDS>/,<PAg]7W^_V[Q?]2]&FWS\-Bg
VLebAUAZgdW4b4V-BH6B=BF;G:/0>=bE0;H6/<W(cc21##Z@/8^0cb>J@7=U:ZOB
R;68.Lf+XfJ##^2&c.f<:)cR(^NA:PUeQe+Cg_e?-aH-MYC^VUA,]2K2>OC.+:HV
MY,Q(EAF+YD.<YM^?]K4=b>[?(HaP-Ya,X[74OXCN>RV0[BR,,LTc;gFb9_=DD[?
R>5WUCK1#;]17B)L\W+ZeCH/E2?4AREYLZ=Q8^5aLOWYd5LTXKZ#/J9a&2-:K#B5
IDBUe<9T_DO8M\I.Vc47O0NFN[V=HD=/PHbGb&-9[eIE,=aESd79LRN\.V?KgQg)
[=[--D42OT@(.P2F/>-ff)7HcV_-EFAZSSS)_[,--a4;gF1X.OJ&N,g>-(32BNS=
C>1eV29f^.M2EU:;1c3R5f.L>-P2)Z1CY&Y@e3(.dU@b3;+SB5S8^?^..[:a?2^3
\JJg3DbeZK:5O&AOEXLeGb6\4>C[@YeFBI^=#V/=.f\c?,:B9>Qf@2cec2F[.Q3N
9Vf[E#GX7S[E1a4QB)WF:09b3W<_PG>V=?K+BGgVF-PeHTRJOZ4XAK&?g\7OWF:[
PZ>8g?X+2Y5KZE0#7N\bT:>eGPWcH1_WN>P9:-V9XeA:9SWOBI:+(UB:2(A-B^/M
BO[)DJ)[e:TS<=NI\YV4&6(4),00]@8Of[(Y+:(<LV2J->J#7[Ad\[&7ZdF-I][-
FB81=BDLFf@1]T_W^+LXebEL_GK#\C#T9.Ad6+,.R/ENS[(M[O0_a_N\6ee:eQ)<
cN_QIS/Kca\7Z^4eOF5[XQ2D-@5AI@9@?1[=6257@OJTFEQJ;0,^-31K5D&&L-L2
<8-2RC?P_6/T1-]Z^&g68FJ=M3,9#YdR#@>^)CF.WC\e)UT]94[IB^S&\Y)I1F9,
#M+XETUU\TXF./ZU\>/#6d@#&W;.dG0QC_@/9LL^<=FN7+F]VLd;Ab6:)@?C\D:,
W/H/B?:TEYeQ1TSK67ZT[2HNTQR7a@XJe_E?Y-P8MCS2B[KW4gI.dMeI8+Z1e56S
;N.d-NDMVHCKF39EgL?+OCC@.XHY)RYUd1Y=&/:G_AR2Y)AUFXBbOLb0CY(EMeAL
YgUW-=H](+b9Y>e6f2&7M)^;c[g(8MFd8>dOI&3Y5ee@U?@QN(T,)5)K@Gb6#bd(
Q0\B;Uda^O>/_dX.cW05VD#.BR5>+\QXD4c?W=Z\5a^,K.;gW(L8ZJF#?93UQg(N
K7Ve./6UY]\K9BI/7TVM2;@dEF+J+:M)GS0+37a6abPYf=T1MdT_<eFd^\M,&9\)
KPBWL;7e9OQYKD4MWfH?J6\0K?Z(D\X2IWQ:#b2>;SXO_<64G<7.5(,R?#c@BNQ>
b&8ZO_.dHOTMEK]J;D/7DIQab0M6A9B/W2(P,3UgMNAe]8XG#BF054G4UZF&.I]B
RcJ<H?[^VcA]1#YT[@/::EB1Q5+-C0JJ5MUSKRL#:UV\XYHGVgYbRN2R46L?:,K[
HHRF-:=YT+F)0U3Z;c6&&^^>_)c+N9]WA_SQMCHb&3XT5L(Z)PY2<C]E@3;6,D_:
;C/V531_0&3+3aQ_K2#M.(=62W)I&dPF?H_Dg+..0S)[:G3gB@^Z;WKfDE,OE0<O
fKC7YM;BTc@cFQd.D<<EeV5SPa[=J1V>=N(O]F-1f\aX01SEB6;64Se2E0?H[[FF
YdCc8cb,]3KJ2<GaH@^R:DY1=1.-UOADO9O\c#bFJ##=/MRQd@0UZ9;K+^62b>\Y
GX_M5B7(6a=#MW--T268a0VS8T-W)cEacZ/bD-VQ.^XIQJ/K<-Q2>?]CO(CF2Z4J
5VCM_PLeB->-e0F)B?e[=9<B??>G6@94K]\>_F<S>6dJB-=YS;;MZ@eP0K6OG=4+
-VbO0N1FQ9Y(<6JA#_V)5UU@fMU,G_<XKfNdK+fb3cUQ);P9Q<fBZH??E=.>>JHN
f49V>\aVE(8bUANNK.Y>?a\EG4F?O)IZO;/_V/?_8F+U-E:3LgfeE/(_O]>I=LW;
g>MObNH,#bU&@][)X_Y9_)?FP2/<<5OROE_DP[aXG5EE4-#+NRQB.K;.PC+++I]<
UN^5(8QVP?b&-$
`endprotected


`endif // GUARD_SVT_EXCEPTION_SV
