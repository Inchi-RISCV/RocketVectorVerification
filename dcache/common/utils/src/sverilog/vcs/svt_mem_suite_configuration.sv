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

`ifndef GUARD_SVT_MEM_SUITE_CONFIGURATION_SV
`define GUARD_SVT_MEM_SUITE_CONFIGURATION_SV

// =============================================================================
/**
 * This memory configuration class encapsulates the configuration information for
 * a single memory core instance.
 */
class svt_mem_suite_configuration#(type TC=svt_configuration,
                                   type MRC=svt_configuration) extends svt_base_mem_suite_configuration;

  // ****************************************************************************
  // Public Data
  // ****************************************************************************

  //----------------------------------------------------------------------------
  /** Randomizable variables - Static. */
  // ---------------------------------------------------------------------------

  /** Timing configuration class */
  rand TC timing_cfg;

  /** Mode Register configuration class */
  rand MRC mode_register_cfg;

  /** Width of the bank select portion of the logical address */
  rand int unsigned bank_addr_width;

  /** Width of the row select portion of the logical address */
  rand int unsigned row_addr_width;

  /** Width of the column select portion of the logical address */
  rand int unsigned column_addr_width;

  /** Width of the chip select portion of the logical address */
  rand int unsigned chip_select_addr_width;

  /** Width of the data mask */
  rand int unsigned data_mask_width;

  /** Width of the data strobe */
  rand int unsigned data_strobe_width;

  /** Width of the command address */
  rand int unsigned cmd_addr_width;

  /** Prefetch length */
  rand int unsigned prefetch_length;

  /** Number of data bursts supported */
  rand int unsigned num_data_bursts;

  // ****************************************************************************
  // Constraints
  // ****************************************************************************

  /** Valid ranges constraints keep the values with usable values. */
  constraint mem_suite_configuration_valid_ranges {
    bank_addr_width        <= `SVT_MEM_MAX_ADDR_WIDTH;
    row_addr_width         <= `SVT_MEM_MAX_ADDR_WIDTH;
    column_addr_width      <= `SVT_MEM_MAX_ADDR_WIDTH;
    chip_select_addr_width <= `SVT_MEM_MAX_ADDR_WIDTH;

    bank_addr_width + row_addr_width + column_addr_width + chip_select_addr_width <= addr_width;

    data_mask_width <= `SVT_MEM_MAX_DATA_WIDTH;
    data_strobe_width <= `SVT_MEM_MAX_DATA_WIDTH;
  }

  /** Makes sure that the data_mask_width is greater than 0. */
  constraint reasonable_data_mask_width {
    data_mask_width > 0;
  }

  // ****************************************************************************
  // Methods
  // ****************************************************************************

`ifdef SVT_VMM_TECHNOLOGY
`ifndef __SVDOC__
  `svt_vmm_data_new(svt_mem_suite_configuration#(TC, MRC))
`endif
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate argument
   * values to the <b>vmm_data</b> parent class.
   *
   * @param log Sets the log file that is used for status output.
   *
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(vmm_log log = null, string suite_name="");
`else
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate argument
   * values to the parent class.
   *
   * @param name Instance name of the configuration
   *
   * @param suite_name A String that identifies the product suite to which the
   * configuration object belongs.
   */
  extern function new(string name = "svt_mem_suite_configuration", string suite_name="");
`endif // !`ifdef SVT_VMM_TECHNOLOGY
   

  // ****************************************************************************
  //   SVT shorthand macros 
  // ****************************************************************************
`ifndef __SVDOC__
  `svt_data_param_member_begin(svt_mem_suite_configuration#(TC, MRC))
    `svt_field_object(timing_cfg,          `SVT_ALL_ON|`SVT_DEEP|`SVT_NOCOPY|`SVT_NOCOMPARE|`SVT_UVM_NOPACK, `SVT_HOW_DEEP)
    `svt_field_object(mode_register_cfg,   `SVT_ALL_ON|`SVT_DEEP|`SVT_NOCOPY|`SVT_NOCOMPARE|`SVT_UVM_NOPACK, `SVT_HOW_DEEP)

  `svt_data_member_end(svt_mem_suite_configuration#(TC, MRC))
`endif

  //----------------------------------------------------------------------------
  /**
   * Method to turn static config param randomization on/off as a block.
   */
  extern virtual function int static_rand_mode(bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Method to turn reasonable constraints on/off as a block.
   */
  extern virtual function int reasonable_constraint_mode(bit on_off);

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object used for logging.
   */
  extern function string get_mcd_class_name();

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Utility method used to populate sub cfgs and status.
   * 
   * @param to Destination class to be populated based on this operation
   */
  extern virtual function `SVT_DATA_BASE_TYPE do_sub_obj_copy_create(`SVT_DATA_BASE_TYPE to = null);
`else
  // ---------------------------------------------------------------------------
  /**
   * Utility method used to populate sub cfgs and status.
   *
   * @param rhs Source object to use as the basis for populating the master and slave cfgs.
   */
  extern virtual function void do_sub_obj_copy_create(`SVT_XVM(object) rhs);
`endif

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_static_data(`SVT_DATA_BASE_TYPE to);

  //----------------------------------------------------------------------------
  /**
   * Used to limit a copy to the dynamic data members of the object.
   */
  extern virtual function void copy_dynamic_data(`SVT_DATA_BASE_TYPE to);

`ifndef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Pack the dynamic objects and object queues as the default uvm_packer/ovm_packer
   * cannot create objects dynamically on the unpack.
   */
  extern virtual function void do_pack(`SVT_XVM(packer) packer);

  //----------------------------------------------------------------------------
  /**
   * Unpack the dynamic objects and object queues as the default uvm_packer/ovm_packer
   * cannot create objects dynamically on the unpack.
   */
  extern virtual function void do_unpack(`SVT_XVM(packer) packer);
`endif

`ifdef SVT_VMM_TECHNOLOGY
  // ---------------------------------------------------------------------------
  /**
   * Compares the object with to. Differences are placed in diff. Only
   * supported kind values are -1 and `SVT_DATA_TYPE::COMPLETE. Both values result
   * in a COMPLETE compare.
   *
   * @param to vmm_data object to be compared against.
   * @param diff String indicating the differences between this and to.
   * @param kind This int indicates the type of compare to be attempted. Only supported
   * kind value is `SVT_DATA_TYPE::COMPLETE, which results in comparisons of the non-static
   * data members. All other kind values result in a return value of 1.
   */
  extern virtual function bit do_compare(vmm_data to, output string diff, input int kind = -1);
`else // !`ifdef SVT_VMM_TECHNOLOGY
   // ---------------------------------------------------------------------------
   /**
   * Compares the object with rhs..
   *
   * @param rhs Object to be compared against.
   * @param comparer TBD
   */
  extern virtual function bit do_compare(`SVT_XVM(object) rhs, `SVT_XVM(comparer) comparer);

`endif //  `ifdef SVT_VMM_TECHNOLOGY

`ifdef SVT_VMM_TECHNOLOGY
  //----------------------------------------------------------------------------
  /**
   * Returns the size (in bytes) required by the byte_pack operation. Only supports
   * COMPLETE pack so kind must be `SVT_DATA_TYPE::COMPLETE.
   */
  extern virtual function int unsigned byte_size(int kind = -1);

`endif //  `ifdef SVT_VMM_TECHNOLOGY
   
  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>read</i> access to public data members of this class.
   */
  extern virtual function bit get_prop_val(string prop_name, ref bit [1023:0] prop_val, input int array_ix, ref `SVT_DATA_TYPE data_obj);

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: For <i>write</i> access to public data members of this class.
   */
  extern virtual function bit set_prop_val(string prop_name, bit [1023:0] prop_val, int array_ix);

  // ---------------------------------------------------------------------------
  /**
   * HDL Support: This method allocates a pattern containing svt_pattern_data
   * instances for all of the primitive data fields in the object. The
   * svt_pattern_data::name is set to the corresponding field name, the
   * svt_pattern_data::value is set to 0.
   *
   * @return An svt_pattern instance containing entries for all of the data fields.
   */
  extern virtual function svt_pattern do_allocate_pattern();

  /** Constructs the timing_cfg and mode_register_cfg sub-configuration classes. */
  extern virtual function void create_sub_configurations();

  // ---------------------------------------------------------------------------
  /** Constructs the timing and mode register sub-configuration classes */
  extern function void pre_randomize();

  // ---------------------------------------------------------------------------
endclass:svt_mem_suite_configuration


//svt_vcs_lic_vip_protect
`protected
7^2?L&Z41+_19,NX#HL^,g;QYR2XSN::.F6cT;)NOWaY_@GV>A0d((cgA?BJ64A]
ZM@RP#3#F>;[WbFZ&&TU,.,)3O0@Nbb?NGC2PC\3E.BG(.F,&-6K;PIYf3IM7H30
MAT#6F<)A#3MHM:JWQ9?X?<,GM4&5d@L0Y83K6&c;;+JE/@QT12_ZPR<e?d:;TdB
Y:Fe>XZgAD<FQ-fV&^I>FcfDZI,^^.5.CU:T)NN4ZcW=E_3^aJTF/.V:2R_5YcCE
b2/:&FY(7dQ..N+O4U)b?F_=./JOMMbTXJ<1-<R(_g0-VO7]4^[:C7<2#-ba;b[X
#d/[P^62Mab>UKd\WNX)QP0@)]Ic4d7]eA\\_,];AOPI)e?Qc8)f8F65+R&d@Lc+
4P,2ECK2@JPF@8>E?1[gdU;DZ=2@S4IcgO)>f=#L=G4cK:S63eBXBeL#R&Q7.c=<
f2SMaYA:=0]6:_94-aXM_9K._E0BZa4(,e8,2H8C:aV=)GOK6YQ5DYaR5=RbOK?4
/(_G@=5VKI/;<E<6ETN25:HA^AZ(W.[XF7EZ8,#A)KS>1&4]aA-.Q[e>#;f-cb\2
FV/0+V(KSK4b-AfI0SBJ_)0:ZgACPKI8Q8YSRQV<?W)Q,BOO,^K/JS0FBBTegP16
SK,Ced@\,&BObI(#72_T0d>3F5/B#GFINQV::c>ZQ#=?e(H9CKO@>@0?=YX&D<H3
,dNA)c/;eHaL&6O]UVgV:TVVQDP>DITHC(f3)[fJ@7C6?a3?>871e[A+aXU/_)gc
G.K]>2QYAbH>O]>efOYfUV@)Z<1[O#\.-D<-[W]\ONKNSAaFgXZ/)QZT\#?c26Ba
7N;&H=7WMaSB,aTFf7SD-_^53];:)=eVbZULNL54G<?RO/;WHL=aSbZKa4#+J&8Q
Y_eO(g=df/85gLG7O-A(;,3:>@E-#451KDf.,Q1]aA[Rf2)M.F,D1)?V5#2g5P]E
.F52LPe_44.(b27+OO_N:R+Y+/U.S#UY<3a1CfBb-2W?-67UY(A&5EJJeEbK^:#L
EeUYL1=@G\HM2(]=F/D/+/[4>,<KO0MFfS_&JI5NRH[,(2YSE/A&gbK8?Q?X3^7(
_fF4E64A<=Y,dC^B7ceXb9CgcGZaA>ZeJf72,&+]b,c2VZ->@(0I9(&9_Y.]IOE3
4^Z1NOgHe#I&IGCPO0FJ2?:C-C/C/B2JfK-d<>0.;A_VagS_Ja4Q6bPd=dIXM:-1
O,\\@DB.4YXSb^a7=?:=GN76HDJ/QIU>>\BW?.e1/8GZA4MN\IWOHSe\K=(>Z)4<
C#@?-g@.L8MWHBV7L+._18>d#MK5Q+06LD3=Q?dgWYZ/9OEgJIH.F,e1f4B#^Z8]
/U(R)[X]RWVbQ\O.cM2VUEJG#J&@cL]?<,&cO2;N_V^@9,J6\\X,2Sf6CT)@@8#F
2+0O1/-<XS7FOW+K#09&Td#OB_BX67J+1U3BN8)^eQ2\bL4dBJ+KL36Ue\PfQ6=X
Uf1ROSC-L4X:8V9,;]fN<^DEf@:(,M?_W-4>8gUH&#W8?3?(beALJOFbc6(V42]J
<WP][E[6R_]b-13&bdd+&YC2(-MW,GNX#aFWdQH)@7I/&TNXGL<7P]dB)#0J]B>#
7&:fd80:bF6+;XT.CcfM#-S)g5Bdd50KR9/\W0@OP0X^/(/UEa&[,0<>BSHaY@6G
+B:18(<f3-)>+9WQ6@.+7^_,:EU3SI:T]Pf@M)BR:YC=(U=L)Q#]LTR4+82.f6f+
-Q]LZ\6a8d)E9P=53P3)=g?a]606=bBAS#0W.1S#3WD[AU[1IAf?ZYZ.R#W,RZ=^
9:6e0[I6(Z]fVE8];ZSdFg](6:;S(Q/IYNf?CU;,;Ja3bU4:BXI0TJY^>5#.VUWN
H-BdF>YB=34P&cHYJDLR[,K.=d@CU:IC6b\^N?4<NK@:>4LZc8I93=Wb0Q1MN,UJ
C+Zg0M[TTgf1S,2;.?XB.=(Fd6659Y?S@5A8C:N6IO,;[LJ78,@93ZU.aUNWGWeU
,R_Q4JU5f6KbI(1.f&^[SVKN<4Xg/LX84FbD\Y(Bfg4=OSa[)KYIIC#4Mf<5&+A8
U^WBFeH(S;G)bZ5D_F4PF)eXH\;<;93/[,W^a>.Ng4HcN7->EG3L5HU[U0N>c;FZ
9?RY]3#S3g,RRPbdSDF.<FX4WZOcA/AO=bS2YbY)@&&Z<9?3#V<3CR;:2;1&+<PN
AJTLa2678E-N/>KdT#C27Y0SS,@Gg9[05T42B<dX9218dRQJ_,L@Eb=C-5,eI)5>
S:;5H\DECbMFQCT)ASJfRZ=]dPF_Z7#]R7WKP;4?&Mb,P0(cGI[(^JS)/YAE17@G
cB[OO8:XMEgNNaPIZPMGNT))E@(=X:QK;6GEW;Nde^\a8Y-;<cZ6]3O.GZ,VCBVK
f]VB4I^EY0f<3eAE84aUD5aQ^-IRcS6TOJDW+\,#-;I_g_^_@;O<O+9SSb>Me=+=
\\6R7cSG._CZ\7]>4a5<..YS(TF&K#ZaDP]M,2THd-DSA_2(AM=Sb9Y]NAeP>A)E
[NSAH3PgB)\FV8Qfd.IW7DAdH;SEb70g2A=K;ODX>U#[32(J;1+;-Uc07/^_X>Rb
E,K.#Z,(AbA6)QP]HfM/@2@]\ZNW4:N9P(H)fc=QSHCWN&.7K)9N1@DL</9^GUM@
7^K)TA4B_/+;N)T):052P)J)B4KYX>K<UHF@b7=KH4WSA>#9,1@IJ/?6VR5.VQ9_
?(b@;CZ)[b[K@5aD8g[10G_()GTcbHE/W2F8gV-GSN4MMbFAC95J=1_;S0KA>-RS
X#.<2F7(\2a=)]IHJ@UHd9G+PXQ;fU^dZ9EM]0Q2.KN>V^N,fb29b4&X;JJ+SL),
\b_bRb]V9=E+^SWMd;#X/[7X,=3XcPE+SQc5F#@7;&7<O:@8AI4KWf?dK7,D<2;V
?PCae[/;gd1f[.+_+fg\9c.&g)b3@+5eB#B@,b.\).?M;c+25H>9Cb]HF7;ZAN>H
.X>+:W@=CKfeb4D^R:1#@XKL7V]X5(+EeN[_6gTX2H/G.fPH-A04#,K3ONWX;KH/
,67g-?MA]783^I@AXB;e/\M58c@M=I9^&K84CBI@QJ@/XLW6MT88&dQ,M&CRZGN^
7)9A5K34T;6O6J,g^_&=]7]dAO@,S-@S;^X;[NR=;K+D<IP+eL8PIORMIYbCHAd6
a8X9Mge2J=SQQ9YOF(L1K0/e:Za7IF(KHN1^>O)PJY26=7)C5KNUS8P<>KbUc\8W
d)&XJ79@_6e&\99cOcdM:6/UV3DfVg;f@U/U].MEeU5LH<8E5L4_(Q_<[LZB3>J3
&Ed8gF;=F1GM^0SNL(<cN],GgdT^fM4A8C&01JbKBI.];S;=gA:(PPg?Ld](P@cB
N7c75RW.-.Q]6B(3(Zg#ISIHW(W2+GZR1<\gDGb)J2]>9T6ZG6^GC@3A@WJ.CXBc
1UYH3C8)7X=D8>U,?272HWAW-PgF@P[J&f)RU5HaK,644_@[)<5[UXNdaC8e)K:a
+:00LTaNeI4[R_QV#:dH;CP&6bbHC3^J2E;CWAUdfK=8)0G=<+[=WB-S4@[9<LZ)
(NO>B<4a-eKaS;(_-([<Y2LYOJ_W?JR_5]:&]HB)B&e\(K(_@aC(EFWXe.A5>VV@
Q6GKC\Y\G1Z..1-gV42^MYdZR2-ZAIfU>X(0C2KfR=VUUS&ZXQP_<]+.gRQ6E/X(
VN=;(H7LD;4X/7cEE&/(\-YIP;If.A,C8B@Y54fZG\B3N4\[GZS1TPY.[;2](@MQ
4,\)ZRLb<a>HEUc_2.6F^J/&BcF]V&-?#7684MUXFA;R)JI34YO_\D?#^E+0b&fQ
#&ZV,+9P\Ac35@VfBK;?7-YUC^a_A;f5V6&g:C7F/@5C56,F)_(56@<LH@5MWV?A
e1<)dG(2)/T4?P:^+<[cFIbc=(=7S9C,6g-J(ACQ8VX_BZZJeSeI]]f9@P1A)R8b
c4B99W-IFd[9,/<(-82/H\gT?>TEM@Z:5-UW?A.+6-AEMK1IId[6/OC?HU4ANH/f
WZ]1,(E4QBL+Z5G?^;0WNDGL;--4R\?cE77Nd]=]c/8[7I_eHSVPU\+G(eIMZcY)
XR@;:+L,NL^NVCP6Ld1;LW30+X/PHTNFKeQfaZ<7VEKgTC5ZH>[N2=/N4\_F,__-
@BO-J:7#/8,f6)bE91Y&7;c,BWA<FJ(NE9dEY/eSGNG37>[,X[K\03f;E=_>F;g:
#X<#+>?\9K40\/7-HfDbdKeX/#]G_4\OW\^SD>aM]+.E]XCZ#(?J6gWL9ggH8S1K
=5b[?cU#c,SZgg3&-I3T[+G(c(WI3Vbc]RFPV:2E?T=X,N5QT@#5[>QB(3_?@fJ?
-1TL63@6[8PSNfdY:W^TFO=\YCX#/T]&S7JaCNN[8]JDe(\CB>]_PHLGJ/[2C(fM
5:9>e7:9Y-TQ@;7RJ#./?7,Pe]ZY=G]_AU_a5L>-,9eYeF.2,=9CfMVR(GC:P^Kf
?,08U=SVP@KJLLP,.FSFBM.J)H4_LF5/D)Wc42GE&1UIa_c2M^NL#:R25VfC9.77
#FG6\>2^-UU.X,dJM-cP9_[U2)^VE-<(YTR5fEA.A:5.XgQOCAE3IIY28:6RU)LH
c01T?O+.b08bG+CG.2UUA2J^<F7+IW6M\;GUd-gY,-gZHZ&Bdc)DgfaGW\?OcPZS
O9)Q)=208L^)7&JT=+6Gd[9N7^T;R&VS0@X/8CgKcdB&NB&^_9YGS0-(A\(9WP-7
(1S\TD7//)fP<YYNW2H:QI7/Og^U-AI+.^3_&L_9g/3-F2W.TNPR72;?7^_T[+.=
OGeGBVRa@@PE8]-Z-2-^)_OIGS8B?N_4)M<<_0_R?]VC37LY@fS2[[.1XPPXK)0;
XZM(+0bV_88)NK?RaSOU-#(0(;Pb6K&f^eUK#e]BQ3/Y;VKO6XIb03MJJ0Qc-)<G
?L)NN1C@CefXCZdB=W3eG/I(;VD^=9D,\@dB9:WB4-RI/5+QSBFDc3HQSW)0\Hd4
EQFa381T.<I:#SL^(ZTd7DKS(O(AJJ#J)B6^c&-YJ7D,7e1.b;,[B_B7^[7FNBFG
F&N@1UCWba(U>2.E-WV+KU#LS\^(&/g,#-<<Y,8\d?5@UY,Ef+Ab/_1USRc-3.AF
P/W&QY+W>UbLaSOb>+8a4)9SRC;KU+BJP6J@23Y?9^J7^5f/OET-10F9HXP4]HgP
/0c#;2?MC-feA4<<CGbZGIaTdecbVcS^CD3)Wf(JDI/2U&[Leg[2J;.fV1:Ida8Z
aB.2=F^U.3W>KCX2,,3QNFec7\[A;-ZX5K6PQCRZCRVSg?Q5(_#\9Pb]:\-L9#V&
eSe6V2f.NBZY,X8C\2X8YTC3\gb\e5=/\,D;NTe.FW<Z2G><1.&.--8#U0BTIOU+
94:2-gegZAH;A[&GaQ<E0(X[:E#<B^0MYBCJ7&=V;HR7S+/d).[d=PV7-eQ^>PR#
E)MRe(LbgNd[2@-N3.DEAWI764G(Yb<1J;g(?]+J3WX\.S;N0eY]gY&X,M=^F;V&
MTVd:WDNTIA63?Y(fC#7H(Ke^FSV,LbBIAMJE^GVF8bTCD-6V.<Qd\D7D5KgACg2
]cF)-23C1[0TL;YM^-]<=0^HWN:6=7c5CfLQ).XO97eKc7aT]=#J1B6#V8.\US@;
@fM[N_ZE@NY.1-KFNQ4Rg.G6/g>&-HQZ&gU)\9E=3Nb:cY80fb7(R/e.Og)B-,_c
GD0=Qe))eG=a-b7MdSVcW#K^ZdE0QA\HJ0/AX?A)TD@6g\F3\VaK@,>b.WFO>RCD
12T\N0\F?5+0&I2<K3bX4fN6=8+5GT?0Z/@_J#TR0LB4gaS&[cKAGOG.]&E#5gRR
>OT1VH&(J#W9)BXfNY8QYZ?Z7;-,7dM_T+73)6JMfg(e^8S?Q1L,R,g.6b(D7?-9
ZA8#0[/A&R.<L41AX.HI_R56OBd(,,b-3[]C7^UdV@P4Z8eQ=LUD,?/T2NM7\NX[
S?SP9T^L,KA6=W6<bX9D>J3>TPVQQ@SeT\C2EE/;F#aHOFDM;684DPS,\cTFN<&M
.CFc#MZ?_cAGIG(7SP&X&]GN=M6\^_Y)EHD:\K0UW0XRM<d_&6P,e3>^DRO4G##B
OAYKAQ_EFIS)WF]b)1Oe5P.J.SaG2O@_0T_@_?;KP+g,4:TYRM0A_2UCPS^[^E)8
G40-DJ4Cg#I3La(b.@<DDOI&G3;XUDKe[dS]CILZU4=WU:MY6a&7^HZ^]52]e(>9
,=cD9c;Uf&^JSGc]0)MH79+.b2EAF-XWXQgW.,:R,5+ScE,Db&(FH.8DVX]#<JCU
HYN0?d8]V\B\=+[VcX.Y1_:@P1DRDO^8H>J2<[Eg2VZTW<90@<;]a-[CcYFV>>H;
AHIQb+If]aYBcWL5@:41B0K-d@ZS\He]g5N?7I,fUCK=T#U/AAe\OMG0#1;&fKP@
3YBd79B0B5(7:INg6GZ#.ePAD1.dTf^Z7N7d#3+]31KY,<^ILeIY)/BG??QRGd@6
84g<0+)+GbQVBJF#aSMSN/QaQVR,SU\T.cg/bMY;NVIG<]eG],PIVW/C(Kg-TCXB
_M@5VM=VcU_?gLZB7UaG:7d6MZ7[;7C3?WGU=C\DAW0OXT/NQWL9c@(UP@6cA6b=
^7-(\CUfK31WbM<5R=+IQ]E=0@=(,c?]]MMJJdZ5@8-bPRgH@UZ;Yc3EY46e/F@G
[S8?9J9&L4>b/.K,G(XbPdG?^a.8]H[)c\G[T.=V1f1L46[OH8@-(KI>R[O7FZbH
](d87BRHXI35DGgXYE7C^;cD5O1dfX./5@2#GN;51FdZ]a(TM3APNa<1]M7EA6Sc
41FX7GFa+4,AY=\9C<.Mf\8UISEM6?_73C&PEG&gYX)C^MG+^Zdg>G>>bV4>ED3.
#:VQdF&cS2JBb<1LAS3.WM/IGXf.\@Ud[BHEag&bTfE1)5+N\U^BD7WbO7<H9Abd
f^DQ2_NFS1R2;[YKY6K0.WTA-]XT\VGg+I5Ae()+^)0F&,@Y7&N>\2T2WeMA(.:.
CS<\<dEEV;BXWG,2<cDf7Tb)D4.;O@-14.?P7S<[ESK+(73BC-O?B@9R^9M96-<@
,6Q8F>Y+;O=1ZL.:G=RD/0W_)[9\KX^W>+gK2[<7]H#92QB5TQ4O?]40fZfO<W9K
[gS@OQa=@_^F>Af.(1OBVfOPA2YS>fY.9M^;V+FV,4HZ:T.B+@DcdLQE\3<BV?&f
U@\MC.U0)23X1_C=Q0aS71XU>(:4)bb)VRHD-a[59?HacANMRNf>=AJg:&NQ=YPM
WB5ZgUGL]=PW?K6)4;d=,=VY[@)?g8g]E4b8A6<5^g2fT^d>#,aNJPgPJ,&@9W><
Y[AB>9<;BJB@Z#K1^S[_./YSOLcBX3\Ld^K-]F:g&H2;3^TATCPLa3&N&VTf0gDE
N1TXB>Oa;]I6X[4Me;8TE+;L5S7g6.P\92.SPZ7b2?VN[GWLT]E4]?0fScHA(,I/
AdOS[+1Z)A\2,@2,?49KPa5d@K\7bg#]:)2#fWT9Z8A4RB(_\eSJ;M&+-\V2CS[Y
_8<<A.Za[6HINIF?-7+-2(]L^IKd@:MZBB@6C5(I/Q[agP]UMM:VGY;.M@Ec:f?_
)CD6Jb\.,C6-V4Z5B-U^@IU)Te:K1AN48a5+[SdZV6P)9)TBZ>e8?fc7<QD^[JYD
&M3_,\gB=gD4abK28_<7L(g+IdKMaV<<\D(&1)04,e3&;/(Y2QQ.3Ya\Z--b)b<g
.;[4[2L[=DG^bQeg3gWGDI9+/?_ca_JRIb^aeY6f,_=_H^Y<UY.bCC>EP3+AaCQ]
<A3I&+a-G2DV,]0>d&O5R8@d[>=\0H0?PMf@/M.EF&J4]7fQ,NVbgX5UYN[^gZ3V
S^[.HYKIe:K1D6E=?9Q2TOUPJ@<I[PbF.)>IIIH+.J_.P7M_UG4O.)W1Lb?972HS
-TW4^D;/?S/6:bU#GDYD:/7ZWTJG>0(I50CRDEXg,H>-b.2D3<C\1OES5&[Vda@[
E)=&W@@W\H9Bg++#^fQ1;gaIdJ5D2(B2bWUW>QE>H4bYD7Z)00O[U756P;e>4aY)
CB)(dUROWVY<b^];e@ZA#V;TNF/9<:MER[=5e7OI)#SK<6>IT_4@BS__>)/eN8IA
]0F:[<WYg)=VT(H@0OfIb5T).0]9YFC.Q@S3B/=V<2\;PU6#Q/Y7F(<#?e,b;GeE
8)7F=f(/?ZH(NV](CMF&+_KA7\1C75E12>M/Z:Q8F#X;MCO)>d7gQ7J1]-PB;0^2
I\bHg6cCD=c6:GFZ8N:XNW)Y\Y(2-A)YIXL4[2Qa\;I:72,PIC#@T;?dWXF>&7U\
P\a97&+.D\E#WKIOM4c=cMFa^CW?@F]+<Y\[XH\H7<DNZMeUP]VF/(@QWWe/2?)(
(=Wd_7/+E/Sf@,-Jc/X8g^4FB,d;V/_+YWZ.bW?YSIfSg=@(^EFA4YdQSXd:Z(eY
(P7.IRNW98AILOcXBP?=),[02f\(b5#9D9K+g:,1M91:AWI-AP3-WS:4X.@Ce(:7
2H[+fX[V>d3f\SC8.+GAV<6eT/#-^:.+;0,eGPGd>303OdZ8ILP-@B=KZ1T_6GFD
ebE;5d8Z,X(:F\Y=9/B[M@4OY(EW=-\6/E=e2gfOG=Z&dONMgL.LX=T9cRMR288:
]AY/Y<T55.1)K)]]3U&HP)D_Ze/,P/KMd:>]dSKI:.2e0R+_gO3eTS(.fY23KZCN
WIQ=OKP<HA:V,91XA7R^;dUAWUHM23bRe6[TXC7;J.D1fDM):?AO7H?g#-XFMC-W
?_:7gcF;)KY<T_I0@)=:1_<460F;&5?^aXY\ca2-YfI=9X+05F\M9XI8=#7dc](;
a9BUAJO-)DW^_.?+R)^@B^F@[X<4K_ed0^Cdf?(;M#H@NM@+O,7K76g\[,B0dH8_
.;]5Y21:TQa(HT&Z>ZLR:59J:B)WF0L/gL,CaG7f90MNH>IbI)e6/:dFTaZ(e2U4
/,cag-0Od-\F02+][APYO<(.B)E:VT?P@6a;J<_)d0-07[S8S1[#P0/<?F;&F9]D
B3/J,1[R&W3ecP6-7d9.QFU:NDHR88500@G<KBX_1A_d1<?Aa3#Y3F48^8W+\)#0
\ADPFW;.W3?]g/)_9&Bf9>UM1.#U[^;b8H>0)]>5/SWdYA8IGANa@3c3EJC1_<5U
8F/V:g@+/D=>GPbb-e1bRKJ&2]K&YBAa,A)&&LW-CJfAGPe8f5>-PS.AHP;B+,_L
#ed02(G)AOFKPcB5BPK>3;IA#3_b^;Mb6&X8IO&5\.-1c=Q\C@7H)Nc.#RHWOD/F
D8\-Q;4/SaRDX1PO=dI?]4f\f6T6<X][U7_695-UC\.2f+?N@8YcK+^L(XIO:#J3
R<:c/U#C?DXDJK:[&6YUIfSR:)\&Q@=VZ[(=PWKWXbeI7J#Lc;BU>3)#c1>(WC4g
HW>=X65f2)6A73<Qe=Pf44UAOB9b:4c6eC)#,G[g&OXI9:4XUP&Y\]SG[g#5N[69
\a/D&7G:a:3-e.GO^AA=gOUZH6902J.R:#6Y?JWSR97B;G@Ia;#LOgJ#7QMDV5G6
;Y2=C,Zga^B,Q&LRR:X_XC)ed6SVK)Q,+5_P#KH2Z1Z\Y^T>-gaR(g]B,f5(E3S.
(A_5R#NaSOJHKABCWCBM:R/L8C/Fb[EO=^B>Y]ZF=PJ9>WYL/[+K.a]H-Y84AI25
baJ;H24R6?BBUN@#YaI6C1QY^]HJe#ZaNb^9;>^bOPTL020PP^]1_-1X=3^KDUaO
eMHFd-2>>O#>PM)U]\(+M+d9U\;32]VUgIP@b]Te<SJMc?:W7H3[8H9Q2#C.PT^(
D<dBWJ).MR3aATKVb,8FVZ-1KW.<T[Z.?#f)[+=DUUf0R_-[aTbf:F5,<a6_I+)X
;1+K_<P;<NdJ5&KYM8c;c0]4?D);#4,RMDWBX7RT\=.;8X1H&&J5KEC<:V6M+gC[
=U,/>6W1IYHH>7KDFQ>/^(59<(N6fXd7d?U>;b#8P(HRJ5G]f(J.HZT]H8(^WIAb
afG@/dgT78[,2?/BP5aX1)\RTC+\eON,ff=F@?RF090PJ;OSZ(WPXRC5GG#Z#C?9
bTIAc1NYgNH=H2WDcY3(bTXZ51LJcT5F?F5HG#]I\DDCWP[\PK93H^:Ic?NTPg1:
b#g[>b;WO<d0fFAeeBF1dF=P<NPKH01);NGMGQWeOR^W-P9;QC7A<AU^NZ/?R3_B
6IOQPV\QZMH[]VG;?=dF[D5^U<O1LCTT1M4C@WAA][==@GX<U;N5fM?b9C[g:M+L
;YQ#,_a_G)f2.feJ2=C&d+2#OKD76Xf:GeYLF@[@R:]6&8H8VB??f:_4CW0LCT)f
;ELKY,&PWbZWM@9RQbK\g?44^^J>E>7:,_<8cEF?L0N2EWbQ9_HH\QA[/P:3,#7J
2J>\_9a1ZeLa3Y=_-d/W2dD?RBON&BJX;><A@(f\eL:F-0=>eZMLZ0/RWU=,23K9
SAH,;#+IA2I]@gPR4A8<SX]bXMT&FM#N>M>^?O7SNXWRM.N-H:.b-DS;:D2LJ3TZ
5eJ6O9M-28A6]JM[-:P/TG9_6_G_/Q;KR:<DeM#<XY5IW,Z_Pag8<5Y7I[^dfa#C
98JAK4-/FaJ66&O;QM4.OB3.)W0?DRPG(\b,4Q1>>WGV4aH.C81N).&BS)fT&.<.
/(+/gcbG0MYAB>[OAG+eb:HPd?E:.WbR.TF)94L7K6TLbaCV56=M/GI)W8g?T-64
J01bWNR1V>BPVVOU?9KBXYe&[]1SZ@6\a([I\6C.=+K_bHb?R^eaK#VZQ85]IE2<
a/d[\I+NaP2?J(gDD)9<Z7WeGR\2HOBU#BBRD7JZ8<4@>VL0I].4,?L<FI1BR.)H
gcKXI,g;J#T5Oa>_/&8W&MJJ7EB;R^[fX<8\MVcf1g\/K.?KYVA:V#S:\=6UTa^#
DD3AEOb(Q_9#(XcQISSgC>(7bXV:-&J<ZHJbW-ddGfQaB:TTG2?FF]C;-E#=284)
2AK37?UBeQRZgK3GGKgHJT.+R>&c59a;gW+^M@K59OLE)S]0-a1HD;Saf=CKGA/8
bW=Hff&dOM\K1X,3;4V],=+F)-b-?7cAFUWPMSRC72V1P,J5<af<70VSA([=28E8
IK&Q5(YeK..+Ha/FKFRJ[ZN7Q?&g/U.F<ceFHE2NWa+Ld1<([J)E&McF]ETNDK.4
g_P?FU+RBKCY<K29B:0^U?DZ5c)bUHN?.C3+A6K=[#Ze9)-K6^ONCgbd;+40<N<I
:,-TU3aPIa.R0U,@8]EfYAS49Z<P6bXc>e9#UIN&?)G?@YO^#SOIEaYdIgIPVJ6R
=DFZN4FJEVRZdD\PD-XD^C>a,-ANEQ4WT[;9CF(82:5Q<&U>9UV<#AdUL#TEg92V
RLNBfT--^)LNaTf3ER^C[:R>4b]O#K_P6P95VfaZU,If3I2M+3@?7b<7WH4K7a6T
982,,?G7?M8J.=,cPYG;WHC=4RKS)gD^I^GH3De5/-ZL<6RIB(@7V1+WS7,\55:)
,AF-7.G.\Me/13=>@1[V86L(&(<9A3+M2I?X<.e[QTTT5/?B+1afJM3RJ^\L<.\>
0cODa:8MKZbd8]d/+=E5&Je9?C&IKW4Q<@_X/VUGe[Me>;4AWWdCF9&,(NKB@&]D
];/5.(4>>S4F^R^36L/<_6AS[#9Z?;eO.X;Ra.\Q2+[FI05P&\(G#F7>)N(,;a+G
D&-E5/c5[^cUR^X:D4]=OZSY0IIU>>)8=API>1AM6gP<WY+JEHQE01/.]Q,<&>_Y
gBX9+(BPWLESXc/6</@D:IgQ^N@NPWJA(&\5K\D,8-+A]<XP-X&+&8@FSSZ7I//Q
;70;cP2d56KDJGYF[UQOXfF^,74a\b)J8;Hg=^_B1A:Qc/Ia\G#<(?C@-)/=?T8#
P)E@cYd-^8<I0:\(0FGY&5e[N[7V72,>2QeEB0SI2@.)0VSB]GE<AVG^FMLP37:J
21c_SCLcB-5QQPWVOLTg27eI=3BJf+2UVO:;;E-dE8XVNDL_8Vb.\@,HVd6d?g3b
48:4Q/A0FgB,BI6IKNOG\9[U:]95/7V4_HfN5\2:A/KB+#;G1269^#K05X@cW>JT
#/cJW3[OcfSW0O;Q)Wd3R0NIf0,TE#NfX>L)[I9_\a?GAFI]TK>Teg3>,J;AJ6[<
V1?OXA(>(/=>1Y+g8d?/9)LV@[0[f^<6]&W:W=0WPO>AGO+,bU024J1eNO/UbPBb
0>-YdgYSEe3YO>;K;EG@IHKJTEQfM-H-/0=92H3X9VV14+O,Z/)UggIH-F2+LZMW
^9-QZ32](W3_1:[D(?&#c/J&(H+W-F15&4N3M[VaaPBc69,g]\M7N<)aNJ#QXMaU
1dR#-OM,-S>N.f6V-L)WT;QQ9f1,9WI2;c(]<H6CCaIGA5L]4#(g>78C6VYE-+YL
>/=;A[HI,\84D=T[(;8#8Y6V(UgJBg;dFU8<,gQNWHI<Z)]IT5&IU+a1=B@cH(B_
Q^NW,TCa1P5^gc4?[,_+LB;2XO;ZY>1QX>G:1188S1&Bd,SA?S:\N+N74ML@3^J4
SU)APR4_OKR5357M<&[R0f)XXMF)MTG7(I=,/7V^e^IH1=AD[61Q5UNWGNZe@AP/
.:#)5Y-Q5SRbYaH1YPF;M90.UMf4(U^DH9G47IX2Rg:16C>LMd#;AIL/(H?C\b/G
EG7]F+L.EGTd</aS<>M]@bRV+25U+d=JY>YGY68#A_/e[>;9=JXWRR&bZdW7b23b
Xc,7c,8d1O^3Ob@e0ZH;JOU901IT9d;M(\YS1MXE#)?OS+F23+ZK@Z4O\8RFUL44
/BCc)H7DZH/3>aMJdZU?4Z=P/&9.ECQZ<\Ub-FCF(F3(&VSL[+edb-c5]LX@,KOL
B?BE+0)-5MM\W_N7:)M:f:.X7CYZKA3M:M?2>F,8KCSF0:D>6cJKU@>3,1g4^H#[
?<a2fN]N9^Ld.E\[N^H](NK@AVfL(J?d/#W9,7)QA]>EN+gY&A#S:g6@1284(;I>
f[=\)&,D0^]N#fAfIS4+0ad:Qc(G9&#RbFU\CL>9\Z?9T\-Q[cO2ETRSWDMJZaL7
D@3:e6<DLEGcKG;1B6JHdG8S>_F@.+T3ORf#gSE71X(+0^:QW)]8R\&#)]cDMLJJ
5DGHgG<,9e4^+OMgY<]GUDL=)O05MMd-a=H-8a5Q]#25]VVaI_&1ANQLPJQ6ZM#=
^UO:CI:=0F:LMEcEOG36faHGa9:gY)9B)5W)>9eT&PbHNE[3S5&e+H:?dQ8U],\R
cC^1W5/ce=bEdT<IIc7bP.P8NCJE3H(^O700If?[K=D^9VJ9TC<8-5TQg4VMOdUL
912#N,<HLGM&,KC\edUP472aE23XK62Yc+]S?JcZ-DZ,=e1V;>CfF/K+@ef;LMXI
1XeTBAT^Y]^T7XJ[(YYBU):RL<1=Z1#bc7AS]Nf=TZN,8N#A4[K92beIg4D3?;,;
A87?a7&e/+fPU1>;YD.I8+]M6NEUBg3OS,EW&S#Wd-^7Y?Ac(L.aZ/UcYa=H;^KX
^HTZ.b;KC)Mg<Za>A,daE8[Fg2?HI9CSNZ,_,>D#TN97J8UgDJG>/<1A3Ua@8U7[
[4OGVLeB?DQb=/_ceX#dgP?)Z&E.[E_\/aBN=/X(0)C?abC5W8F)-4X(OY245P@3
@@DJPPCc^@?YN6M0D1NZ?O;W:M[S?9L:CP5HJY_K#f=c[L84UWE?Me15fL]1=J?;
)YKaCU)O4R2e1(Q2f#e4f[Y=eFNI;,:@DCDOV&#C>cV;_#:;AG#,_e=M,PX0ecC6
B:ZA82,Ue&I@Q]8;ca5bTg850eO1N8)[ecL<TdV2&NC^X-@VKX=>aAaS3D8S-]IV
d]Y]YRQS@:T.5Z4+acb?QbB247\UU6L@0.IBC5_ecUf_DT,d1F9d67V^M70ZWf#X
_5cM]IVW2&eW1KCUX</BS(@=#=A.[>+6/)@_JIP&WA7?d]G6[/=)b7:W8,IdGE:V
-_K:TV&(@DB9<g30,VGGW/;YKFS7J/dCU?45_GNbD;830JYL99QJ5)AW?K?&5F-c
V[2cKJ1[Y7[\[SZfe05C39#ZESc[Cb7:B+)D?435DMH0e(DTIHPL#cZ?(Bf@JF)C
[]?G^AMG[.X+0M<CEL6Z594N](\&BV]<A9=-)bI#&.^d39RN:),O0^?#G&W_2df^
C+2-B&IeQ,C]97KC78M9HJK1\41(?M7/;0f5ZRZWbM:94[J:P5SQP_FU<DI9D;Y4
c2RL9-7O1VU\WagKSDXbNQc&Y2WTH[e)Mb>bb;XCSg/PSCgP3PBOMRQYfF]TJ?1,
6#4V1]gUM4CcV=480.ZLbL]6g,ZFeD>>655)>?adc&TC6VAC3^^A2Q[S<S<6GC<&
1#41MISX5K+Pa:\,?&DgZ;\1+XXNL]]Cd9B-,TJU?M/M71>K2\Q2I70@[\ZNE;[Z
4eB/]B9Y831g7Kg[LcaH:C1+]QLg08^6I>bW8;1^9(MT1MIQHCJPIGW_K,B:QXZX
@7f<JLRY/I8N0>#[eLSBL6gK^@DV1C;)S8dX:e@1LJBda92dO^U<P#A-9_,c.@(+
_AEGN:2M_<dJU8-+KL)78;FGTZ/]^R\\)LHPg?&]BF<\@SG6(Y]Q#KA^HQ-9G.a-
V,T+=fEY2_-1fEQ1,1FbUU4e7WBgPPB^,FcEJ0E52[7-5?F_eCHN[T,fNEOG_KJ9
^0_2HaC;>,&K1(KT+dc8&00+L\CFPXO<c6+KTXV:NdHG52H)YOb)Ng2ggXNUNdEG
\07?Y_Hd1K<gSY/PF0cY3;[a@X>M(&A(_bC:]QO-_f?<DXI4DH&^T-]f/.cDTPUU
aDC9?_8Ec2_Y-SCc5L<d_@AXd(/QT\06RgU6B3fD^\VD(<P3f1A(VDc=J[+A1:UG
ZO]_?K@-=WbD,-bGQ(Y5ME@ITgf6e##X]f;.C(IK/fU95fCBJ>gJ\FZ:Kb/2-^CY
&(3[GH]L7NUf8E:A@GO\g.8dI_b)KGA,A>VKY0;c?9_F7W\Y3dW,E-f1UYJ:Z@7K
N,D.LCc66DC9Ec<00cD[5IL4N^d-XB[:_MK#2<Z5(f#>>)N:=I.+6@JbN#,=-;.V
^fK;^)dNSTa@?GI:GKYBZN?dMd@D#(\9-gMZNY>C/-4TbN==0=,U@5=f()[6A(UG
-FCd:]egcH^ULY75RaAJ:,0,(2&DWVaQK8REW)^,K-:)TQD0dbV[8ZdM-Fab8SBg
E/O3J_Fb0_SaY7UCUH7-?f3](,=DdaaY1b>Ad(4BH<f.LLX0))?G/MB/?ZOW5?>H
&W&>JI4\feg)SBU0&)82@P?6SY)L)MAbHC/&@9OaY=.6F_6O2fUQZ4)1L8R9(cRH
R4UG^5.VO/dH3;daaK.Z]8GUWI<^ScUZ9?XbX\dBd]TEG4Q9PK1@COe0+C\RI^#M
_aM+9FUa5,8g<cS(dLFgKgMATN>gHD+4DOXB(7KF>^+>G56T1W]-E?]F>4M9C^PD
1RK4N63f,^KBPMUZTbEF/BZ3(Fc&RU=O0:XTeGbFL0.,D1[3FH43OOST?bY-42>4
dRS.818+I1,&dYSMdZ\)^:#59D<,T18ePaZTdCDNDIa+;Q?W<@8;;JE06Ced@9B]
^&BSQ,Q&N_W.Q&S16G]#DYY09Z27_6O_&+8)UId.V)EOL>QG2_QI/WbZaIPXgE/>
/?b\&ETg>>Q_fUYZ^6Q3Z.BS/Ve^aR8<X\d#>AVZ#bC7TQWaEQV=T):WcUObHfA4
KP.QRJK:\<H\c@/N=QOf+U@2H1gd).]TE<[C:Q-0Q@OGR4BMeQ#?Y>E^T\TYeI?A
:PQGSXg<@Q1.4_Eg63XSR5F9,b,d8K-5:D?_a@5&(N;<R2;.][XYM5F[V8FR](\<
T96]QgS#0=LA;DaO^Te_.^4g]:M^L@fCIJeI(NH,5f)]NVU<dZ5]QfGf.a/U)D[R
fBZ<,?-W.Lc^5,PfVPMW3HE19W1fRR<2WKE[cNgI76AYaYPA@=:6[0>/[E=;CG5;
dN,9&6#FQ;MRC-)>31#+Nf>;f3)QD#J4L;,dY6:)?D:a/L4/4<-:[Ae5D4JQ?aUJ
F8Sf8AOS;>g;?VQd.EA)cb@.26&0c8KSRM8GaFb-X;B]a[W(PS,]A3\MSW;_<Fd^
dFa=8_0:ELXLG^P1,C==<Ad\ASJ1AU6.U(@=B>-L9\6A8a1e)Q);&V7;VB5:F268
=^A7X/)QY=W31&7\S2)Pe&325IHJI3)0A_U(+a)FbURfLL6I(\U&EW8XDK1@J9Jc
MF\A=288fVPU_38?</>FE9P<3=^a)gcMT5MNB_0XI,=+?4-d?:N:EXVC6JZO4aTY
/H#2:NZ5@#B3RL+3&[,DB72/6V9cTF<g7Wg\X75Ee0[E1@,gL6/Ld]3&L:b3)D_+
U6g<f^Z_QFN:>9-,BKHNB6>OK&X[AY(WNeA0fUADbQ.A2/1^.4SZ01,#X>aU0=ab
YHF@5MZWD8[B<+],C&R(gK=>?SMJX=)FO/,e\LPNY4db<a)5TZP:Y_9=X8N9/?B\
/5UW]A;HYW8UgIP+c+E7Z#WI/T.Q)[0[;LK8^LNBN0Z6PZ>;2-4)CKE0gD>5H-Nd
2@e\[>#GGSFg:,2ZcLXO<1=5aLU=3Z_<Z<a627A?J)4L/d>bU#d#XcW:N@-WD5R@
7ON,8L\^&88[D:JeGS[\<0T3e\PE32GER8H:Z;R@YJBC,TZD0GU;e0;-/a#aZ4J3
)>((bH)#c-dT/JcGcI_9[JO<FE0W0\O7[I]&Of.3cB_/T21)\M+Ma^_Qf+dLD&Hb
M^(W3bdYgGcI-=;a1@dK?=Sc^cUgaJ3\T<a;?G@<GIeO_ABT<&Q?F<MAJTVD]_g9
\1U>QAG^.JT?Y(V>V@?8VAX[52FX+&KJTSG-905gg2:&c_@^SWJ3Ke+fB^I]0bCF
1X><W+M18^_.a&-=B9fUb0gO3.XbJ<P#12,=8,e3^a[LJ=H3PSK?[4;A#R#VCQdc
]G/,ST:3J.9RO363Xa(a884.,-G,EHX;92<\4]I0ZCA/^YQe]R3[-3IZAP7X?)^@
<-&)2EW0B+U:=5C?&E3>b@M=Raa_af]_\17<FC4TX.9J3YeMLdR39P?@EaO#],f<
b\]2J]6P?L?(9:bK+@M63Aa>2+U61UT@+;:G3:,+D#e1+[O_^NY6+&7<Zg,.IV#^
&3=U(V?ODD&6JdWZ6U?/V.6GVOb(XS3&@HbQ5H[<)B2SeN[IL6Nbeg7#JX&]6F5T
R8#?KSLH&V6[&_7D=3W(c2H8<G\E?HMd@.;1abHDT3F#^VF1+E:cYZC98DSXSRfB
X_L+8@c^6LRX2<WT@L9WYfYdRa0I&U]4\3T(QMK&SHYZJ3T\U6fcEPRW/N\0Z@GW
+08C31^E;I(XFf@I,.+@gSQMPSE/WfZM^_7R3\:_-Y2[NEBR]FS/(+2L.:09T0<[
d1S+g;07Y.NDI)SfbD8ETH?OK6Q&R,W\94\eZ@]>+aW8U]<QU(WYX/RBLbdR?&^[
F^b),4?SBaS&gBDK1)?CK&g=6E<aR&4gO;XFfF>QQDL[3=9C,8V7c(9S2B76D)Ta
,cbWX:@V6.MU>M&N\18LebIO=TNWB)POLG.L<H=?\)&22g=I4&_g8Z=;-ZYGL=#=
W.?CB,Dc:#gFIbcKA-X8RTKc]>d>WCbLDRT3C)C/,f0E3fOgJMS/a(-\Y6(N)^Q)
R7^7,1@NC9Dc27<M7ZEJ0J-T5=L<?A.BUD(W,5CPG+T-<A0;DYZId5,9Zd&84b6M
3-B(16^<FRSYEW]IIN_cD9FQ]<@&).GO+Se_1SQB_#[XU[Y#0Z\\/)#U<gS.I01[
F7YPQGbGDH(3.BbV#^b?6LF:W;P^\fYYB;RO?(SM+W^N6H0YY>Y.-E:/AY68>4P8
T>^6fI;3F[(JQ+51PAGTJA:&=)74#^g)G_eYeE&dQ/OeI62.H,Je;^=bC5RYVT0Z
_C2Z6-e)M6U#EM)I4#.,>ad).1J27+ASW_.T7ZU/2dcSS&KbQR4aH?21Hc0>@GB4
]S\e?354/QW06BH(MHR_R[S>DB)>02bPKaIPG)^2O-QT;U?5#+/B^C_c:;dKaDNQ
K_2JYg^1TQH_Z+WXA-2b[,a8<(Q_JYIU3\)O#ZC)VeC40g4e?W;G^;@FcDK7\J+e
1e0/E3EO<D5&be?[;B-&64O9MRg_YGTFc-SdU]-f/?dgaZ]A]Y9ON8QUA8^I.VV;
)F3f9)-TNgTRO;H>BQ>V_0./:=Te(=1VZM.5W,K_b><PK7V(;,(:eZA=2,Fdc(Qf
]IVBE91)V]L0>F_f8INcK;FI#B0Q(XW.ffBICE]JDb[RW=^K[g0VDKK3-JIUE2.:
^@EOWNS9bR8)a3P6ES(<L?V^E@]4.K.&A(T0aAD54R;G6O8],QXCQUQZ)JM7HT0V
U;PNK/[>N;J2KG@DVV-4C9]+#6.<3I@-#0_W<fP?ED&L73bJI0/(<Z3US0P]F:HA
IT8a&X,<\,e8L\R6(26][dGdbHOa8U2SUN)Sc=,S7#7^4AG.,ecM6bSY9IO<1O0L
3MFbc#>GD20#?)TW&S:&b5=X;I-SYBJZ>_8,DIXVa#]I4?Be@Q-<:NXN7E6TT(UU
[+,P5+Q>A^=47LW=_<9-.N]J3Y+.;cR7)K^#1#e9&OTI1,_QPJe._fTgfIE2,0U6
W7UHQ)7B0S^@/5f9#A5W[CNfN28]WS-KI9R)1JHX;HMCY>PFLeA9&D0NQ6^4ET[Z
f0?7eRFWYK?^B8^E\XWTZE6_HZEFQT?YfIP09:F&fABC>Z,3@d.B7R\\&>HF4#S1
U>#f\,-CG;<YP6OR7L77bAX^(Y]6X<Y3PYPXU4>-J2eITQ7WWF\X+??a_,_?.>)Q
_.1>KAP?bK>cGAf,D61ST_7cG)+Bd40,JGDP(A-7T@T8U/QFTI2?:N8LJEW6FL];
2_4KSJL;K2Y7#-XMW4?K;&NdJKEe2=A]^N^&ECM6WP[:YRZ0AP_a8Cb+[Ub8&&g>
X7(a:bZNaD7c#ODdG88B]7RH?&.VPH1VDcS)X=P8S,f=Va@GFY5[WaHS/^RE:W+R
=@>LZ8QK=aLJGb?[53XKH??1fb<I632DbHE\fMD(NUd\DH(>G1TKbE;:4L.KDW[T
<&:\/40BD^?_Z^.eX&-/)\1L)/dS=W)&9^#WI7D_O7^gW,9_c/8J9;M2Zc[UOM):
E?S,^Z,d5^Q>W588P\PdbP.(Y/1f9\/GNIPYf+>PZR1fGR2O7be??5-IJO6P#)Lb
4K5./6.#S,GUR2=P]ca\W>GVJ)bU[=V@E,)])J;.2D<9EY>9GU=O-NE>QR8W84V^
HBecaL#Z@Z<b@SF[YGX2?7a\/adC#LfH4fI7bK)7E6a[<)MEGWU@cNT:2KQY47O[
O-+aI[cBR]/QU\1bT]fPI5cSG;D7N(R8cDX^,1(3@E49f9#@NRVgeDcb,UaW@GG-
9cHOB^cV=O>MQ<J.e24H_d;)dF[;+V.+MOEEC)QKP_ZT0.2)RAfQS^JR)RTJYY+Q
-Xg=<Q;M2fIL9Y-\Ag(4,:AX6TGU#d9c-QXACBOXY(N8?5X)gM\#[33SNZYHFI#H
X#THb:Y^a,KEe]PI=:EC_8LW3+/O1_7+DR&;F:4d\X/cDNH=(7a^#9Lf3eSd^F65
(W(3<KYY3\2Mc(<]:^2>C&:\N7g5RU?KT7eQf[Z.NY21#-YHW_V8@?B(F&BM,_LF
X=NgG6>^<c^cUR0^O(J46-Z(;c(ZZe#8-W//^SWYBB&XL#a<F5U+#_JFL/];2B87
R(.8E?J0dH<<\T5XP1aC^Qb)E;0\:Q3NV30H@FYXL^7^02>W)[4M[;XBTI]e_FBg
8157K]F2+a<QOe5H37>g4-1G3&FZ\A?,;SEPB><Ob7(0Ke3f]=;A;6MK(NF5Jc8A
M5:2XU>1SU\g-^E-,#SSEA7;].GLd<8_A50fcF)eg-@S24C5NUKe-30]cO;9^-d]
W,>UHE,&a1/0S/3<6U89.e1JQ6?NW^UZE;VK\45_O^D5NL=_/+>^<dH):<aE/+(P
cGB)d.?2OP.64:+QI-MGQSEMEEgBaMBbDeK6FZ54IY,SM6^K0,Q\:15)QfC;<^P(
Z2Ka3X]JW>DN(f\6A,LG+N[QH57FBfA6.6BdA;\#f^L]&_c6Uf>ESa;YV^4XUOX2
.,)F/\>U-K2F#-WL+gFF7,_=_b>fH:f=>NI@(//3GB6^29D>^M7;X+;;J<;4b,O\
Vb\WU[PF<6.)Pg)TN^OI,,#fX)\^,D#:ISaB=P(4I@49ag2(]8aP--Jb.E5Wdb+[
c>@AaUS3gBTTH@8[-OSdDg4PSRQD0FH\e2J)T21<e5UA/NaQ1[(B[V]ZL&4\ZSa3
.7,[WS-@\T&1TI7)+856,_56\9JcGCMBTGWf)F5\B]af-fX0beH>O#NL46]_;Xb+
c.,<WALN1^\;8166V0;9aeDIQ.WD?YBDdF0Ob_DWZ.FVB4?YbG3,GAe0&[\fP&Td
VI0C]^P_G)gg19E;43O_8Vg63_;6N/8<5FH.]bSADHb^8P?1g4<G/RV=B?</6a]0
8+(?S8POPQNYPLE</_fALBSD2T8#cD)]2\77775@<Z[AB4)PG>(/aX0MaS>Tg0bV
+_A^9ab-:C^a6<dA?(]&.C#D(MEDMB&gX\W04R2LKZTf__K5X1\)^8B_)YUG\M>F
7@W,CgJMdLMbR7d6d;eZ(F=VOZE;+\Ma_^.;BZEFVX>M@3aVO#(?9EVC#G3g=NX@
Z4-eGZ-+8c.U:.egfA3W=3HMVMEA>^LE)5V=X9P\0]g\GEYA>::FR^ZD(7(Rg2c8
IQLef0].4VRXFF@,ae&9C4>\W;GS5,6@I0\JfA&X=0>-^c,OE4I(]gAeZf+3PR8G
YRK5O3>.IG)7d5aDTdYI6X.6::G]7fT-7>-RD.G\^KbN/g8C;_K\,GXE@T.:Q6M9
Y?+IB^0;bF&3C>-#S;(#I_9cO8AU8&O&NSc__&0&15LT]#bL&?R8&(;2<MMA6D^]
7I#7N:KEe^TTd+fS]bOT7-CMB6IgB&OCYc4Dc6D\3H5f2#ZDRK7NC.,U+(V:\B<T
[a?AaVS9aR.\^<,aS)F2_5eQ@8fQXBaR:]4YHZ:=YN/0NK>?Q[WJ,5(8VR0E#Y-@
Wge/LGB[;N7<H>\/B(aK5KRLG+24gDNB;];DI0-Z4f<aQF1f=7@KN#e&3a.be5]/
/Ye9A/JG3+M)-X]aXST#T<1@A/O;C?UH0DQ21.VZe5S6&#bT7<-C\SZ\\[2ZH#Y9
H;0#W1Y/?ee@4_cO&/TO=S76UEKDZLC/Dfa_@b5QS.]:(D4:XSUZBeAZ/LZ)OeY)
5LKOFTB=>VFaP?F/Q#dGf9<WB7a.&cYUAYJDS1KGTKCI1/VG7)bT^G&/R9S\a750
V5PA=0[;KdR5NUNHIX?=EdCP+]?9WSf4VU<#5B?Ne<+FR2bX.,T8H?2?gDVGG3^G
=[/TFe^7_K0[67B<\^[O>aU]X2&8ZX,(ZV?ZO]>eE6^H+@3:59c7dOa63[XAYg.M
ZU6f2QZ@-7EDJMW?7?KD)\5O(3GCT1Kd0H95NB+NC\Q0OF6O4c6+98E,:GD.f,fO
N8/16C-g.[g:/MA^^P(+RcJ)bQ3c4,M,<J9MX_O+eH@QR>#8]6M5XC=?^R3>._=O
=YGNXR1--[/Sg^b[b>Y^0P]ENe@[@3)DW53g(4-]<_G1@_\eDBQJ(JOU1=0Y:88A
1-9P4-@,6P-,@::gB>W\ACb2c6c=3a7D:0T>>gNEQ6ALLP7H1@HP#/>dD2=g#aC@
Q5/b+D7=&Db5C/9(c[288aJ:E7_S:YUQbKKSJU3<YRZf4\Q-UH9-=L/B34;5]=d+
3JfV[,C0YDJ6ECS6bNQD)Z7.cR)W2U<NFITgTCO4-P>5eD?TVJ+c[D+Q<94L9I;c
;]dL@fREB)a21N<MZ#CeA\<bQ>+YLO,&O1cWBLLZAZ>&b=gZSU<^O;0,:,PgR@#F
@SYbNONG/7YO#J6Tfg?IAHK8D@7KGFRfG8K:ZE<A)<d]P)-E_dVSbA5\&S[c8@<Q
/+:\FEBB7#Fgd(B(T4Y>D#M^ZDJY)3(#7.SZ7Vabd/===.@\N#M?g?7=.gBbV\<(
DFDLA<:I1#V>I57R?G,1N4G7A9;2eaTb4+0X.H&]a,?Jg2\c+f[:A=&[,E_,NJ5K
5V^c&4Vf/[G^8<0L@5.4L>1f^I8/eBJT9;F=>#VAI6)J62N?:Z.5K8B)=]LZP3WS
-8O;>GIcRE0C/Wb3dHX\/K1dG#/AKY<bR6&ZIdXWdTB^,IfS_-A^(dE8?99?bVWE
\8([CQf1^aJHR/0E1<>GP&8(6;32F4=ZH\)Tb9LM^WD>BQ#=d0K:;[Yb1M@a0TU(
ATCJAaYIKKL>e-7Ld/d-)L>/\\1X?T3\G3aUOC0[TZWf4fD6](:BL]4^R@G./fXG
:^,C0=gdK^P2OEKcSN]9/M]J9(Ta#K+,PDGNRR),>5NW[&L:#e3#9W<=NdAE(RP/
g(IgC[:&/@C9a&e]JVW)5YU>Z4293(5Cga+]67WTL2/,VS4E(0NDJFRU\G3@7LBF
-.Y,D^HJ/LSUUEH&.3VWA^RU\(PC_.V_27J.54Pb@GR\f9T<[f#c82DQd3IK@g0]
W+O]HfYFa5cMaH5(?;ggG=E:PII^Tef3-\8]KE+B2+Sg=?35?d-O=H_&N<URB:-7
A^#+>;+4g8(_Y\g;#,M;+;M:QCB&B;\:)=@WT,bgG^0.@B(H#UKJ@B#@QJ/>MeO0
VM()YTI7cJ2+/)4&[fIBCKL3-Fb(;O&_\Q>J&M>_aW)>M#4(8E]B@8:Z^W&13F:g
/&Z0]Q5Z1c9.5TC-Q5LL.3-(g@W@IF3>f6>0CMSCV;&R9=U.(,8\F8/E<78XN6?1
P#9SRK5RNg<.dF.R4[dBLc?NFQDQG>FCB4WVV6I?+?MA6B-TOa.<1f;_N9dK+\-&
;Z[9+F+DL8RDOOTFG(C_CgV5]5Z7?IP;^5=OT;\<=B?8@9ZW/K(1BG;^LD(BfA54
adNFW7QTC<N]00(+46X;=5N<BPZ)1FMa29@LH9C,Ja@XKU>L4H:M4V.3d.80c&<?
K:7b.1:gYW46SV[a[&NXRY[K_NN3?f&[Q^SCfUDW#6VE^KRSV8=d.K^N=[<QFDLW
0.Z:&IY&TfVc=9^)#fNVZSAD83Id-[:2e4LI>aOgCe>e&Q(I:.d9/E<#J@-4Ff_4
bM]g])^^Y7f.X1B[3MUCLOUX^UD\fJV/T,9(ZU-)d)ZSG.6J1^QdF_JFL(Z40KF5
.&=2a)<cHMC1M2NK15E5GP/814CC?1P1SOF9<R^QY(bOOD(+CC[c,36&FVE,fBQ2
O0X1TYKb6g45e<\&FR-TZ[SIF\I#cZQP2fO_E:Y>c@NJ+QVW4gfP.e.L83e&#;?K
J.=\2+c)?;VO5,[Pd639KIPJS0F)3/<44cC<:DY[(BA<#DI\.:VK]8fI38YET:ZH
NH16Xf9RJ(6B:_J,7&QF]JI9U()E3Z)G\cEd8BT>+&(1L;=]WWaB,?)5eFB^1<OV
WMU<=(>S9cJCe2C3QM7-9&.U+7E.2+#@ZK0.NJ7EID0<gD3NM7a#WA=E?U^6[7[/
]+\G8d#PXAMa&&[Q94S6[X^VSAG@E#U^6ME?TN0EQ@O9]#D/@29SM.)d>^V<HGW\
)cCU9/Af/Qe3aD;L^^JO^FJ.M&bMP/55+8^g+6HQC;#cVR2?:ENgCCdO.&_1gFA[
M=(HN#P,T[=L73@QN6\Wb_9Q13V9&E,NSZO]R>4DROW]MRC^VSPL>>C<XA;;0GZ<
e=D(>?>]18GK-5Q(,1T^1)f[7,0;Q5[c:UbP:B3/GHMRT8HBd;g]T]Z6-N2.39U^
5.Vef5.1C:ZB2Gf/BP0Oe#QEe.ZF5ST0AVRR7NR3d=(2FgR#;0/KV2+<.:/Vg&-A
MFH9db4F1<230NYgC_[c-b&53T+#/FYE#D+32;46+_-FaC);\>S7KKdFJ<=E<]GR
UJ(gMRP:R?dV#f-f0/92)1L&)[\NZ&0L[[ZW/N(#KQD1LHF-bZ?:JZ.:CU35D?NI
(H@]ZFJ:TcNTO1+H,IO6NaO?c>51Y8fLPQ)94F3J8N=9=HA.Q3X]5P/BU&+[8W<?
2Z:&[A3Y-g8SB/YK^NP5DJb,PbINZW?,6=0.E.5/de\/(1Q#c2F&P/KcC2QU6RWL
#UE+&RF+]Z-7GGA8S?NY0/03aNU>BU8#Qg.38;H<Mc9-cP:7bJdM0D>6/L_T/^EH
IRB:A-CLB?(J8)PWY.X[:0g.H;2J08W4-;2PUYDJ90+HCXK54Z@3O@[A2CVH9J91
)e\GRXQM#;L#a+F@#bJ,KKC^J8f&(0ID3ZI;#\/eU;SN8XH<<CPe)2NVIVF;=ZX+
I>]KFJd?bQ6DWKON)a@C^V1Y^f8ICG),gD2>X/9PQ);^.CfeGT[Y;4N;679Gc8T8
\I3<-#YeagW9WT(Y(3ON+UP)2V.^b:/F<);?bU2DCMfCQ&B8OYaS0(3a0KTI3g7D
N\=WbdPM5JIfYWffa(QcQF=4V7@0\&W85)?I=-MD5)^8KQc)4ac>7#3F&GQ7[\0-
e(/Of6K)3[VG5X(CLa;8[05^;&15<?MC/40I^]>c9f/=e^S0d>F,IZ9I;K@M#K1)
I#:<VG+A9+5g_C?QK>S0_MY3F4#6.PKc0&7<R>.GWcGb0^?;NIU.VMR<=W;7QS>?
8eVNLU][DBM]D,>FR\:OfSXZT9YEg)S#O=4.A1e[K&bWK-M&eO\DJTC.27>bUK(P
#NC6e1NJ:KT@C^WaC&JT4/PJ1#U^<FYL#17H<2Cf<(f,0TaK7DU(\&2@]]SB?:e:
:,\/D-H0)gP8,FgJK=;3Ycfa4/BXK;EC:1EUc+7MPHf)b>IO,N>D\>;baIVS4>e/
EAJIX<>546.\^^3eD=GL]D1[9QMdP2=AIEaLS6M/M;F0_JGdYUDK:UUMcK,>@6DP
[PR<2HVF+D5I#D.dR3LB;.EZGVZP]&3=9eIW#YE.YeNM#;A?ZA=RCJP\00+08e2,
&/][J8+d@Y&9D,J]01=TU6B71O0HBYXXQHdBce/N@Pg8&/1=b(-]T;OZY;U9;([[
?c,-0T#@aJYR1W+(_c52:7I<\.6OC61FZKK7O]&BB@E8=YAUU9A2MY3ANX5cWf-5
b]f+4K\3(RWD9e0eO;/g9FVOWNY-,/X2N\/_T6FJfA70X<-ae05IZc1XO8dfQZ/H
NLYO.E/@/7YAA7IC3eW,=W/LXfODX(J<>KGK\,Ud@B4X219#@X:C-cJ9OZ;0N@SE
9g[<6Kc./@d=I:eDCQ2Md(&63LTC<d-g(U7OHK<I,d2JR^E2K8WUJC79V-M_VVKN
2UYK,+R;59<E\L;]M\IY1,JJ9XG97QE[-[<;G3<-O\)/_,D[8#RgRd:7<.dSX-Uf
#gE_#0<_]:YWLJ^^b_D\^4@+-S9LEcGIQGb(&ZR39/0S-V,TC[1/5N#O)_X0O>g5
Z.?/,b=V(O_La.^fZ:IE,,:bRd<=O]XB#):eJDYL9-R6JOZ,8Nd0OIB@R+MUK<I>
_gFA@A8.VC=U1;8ZHNV_#(\-#+]?@FJD=S8@G(N;YSX]c^.:0\N10A,MV5Pe7Kf&
2RM(@:QJc)\fF+#9X0]R4,5Z2.B\B(#^KaNIT>,8BEW]H:5_@?M+E6\PCOC6=4P?
.=S39#NVdac610Z#LU?OI0N0@OY0RPFcTd>O#1>P@bcB+E_H]c\P(N<H9HV))&<U
E:B]c(b:JIHD6+8LK6GT]KaRO).KW89NfSL@KMB8@Jde4?e.11)Q37QTSd1[d?>H
Z=13B[)YE(ZTH^^O&TC,Cd^DV)\A-@K+eZTN++KJWJ^3<E23UBS27/3cNL>66\^@
>Af,Eg]E-^;T*$
`endprotected

   

`endif //  `ifndef GUARD_SVT_MEM_SUITE_CONFIGURATION_SV
