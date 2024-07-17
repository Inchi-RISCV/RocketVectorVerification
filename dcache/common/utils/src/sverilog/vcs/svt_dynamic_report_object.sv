//=======================================================================
// COPYRIGHT (C) 2007-2016 SYNOPSYS INC.
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

`ifndef GUARD_SVT_DYNAMIC_REPORT_OBJECT_SV
`define GUARD_SVT_DYNAMIC_REPORT_OBJECT_SV

/** @cond PRIVATE */

`ifndef SVT_VMM_TECHNOLOGY

// =============================================================================
/**
 * Utility `SVT_XVM(report_object) class, not extended from `SVT_XVM(component), that
 * provides some of the features normally only available to `SVT_XVM(report_object)
 * instances which are extended from SVT_XVM(component). These features include:
 *  - Access to a full path for the instance
 *  - Updates to verbosity/severity/actions within the hierarchy
 *  .
 *
 * The main benefit of these instances as opposed to component instances is that these
 * instances can be created dynamically over the course of the simulation, outside
 * of the build phase.
 *
 * The svt_dynamic_report_object instance relies on a `SVT_XVM(report_object) extended
 * parent instance, which is used to access the parent's hierarchy and `SVT_XVM(report_handler).
 * Parents extended from `SVT_XVM(component) or svt_dynamic_report_object have the potential
 * to provide access to a fully rooted hierarchy. A parent simply based on `SVT_XVM(report_object),
 * however, will only provide a connection to a local hierarchy.
 */
class svt_dynamic_report_object extends `SVT_XVM(report_object);

`protected
A+?3/[e@SbGb):cg6=0J-&<2V[V+/Y:J8(S-G9S+ZEPMdB-39&;7+)670:J?Q[KS
ENL[?8/9Ka#D=#&A3?Ea>>YYKA&)eK<7.-bL<b&9ED)?1f<M+YK4b=gScb8PB7F.
:H35SO80Ke.9YbKE?TDd\bOPEZ>B7.LeDN>P,E)9g;1a,U&LRCHX/E(a9-1\-</5
,2M^M,VO3c)?YR_14A1G4W9X+[_T-5I@7GIa_BJ=-R)C<=RMAU.[g76<V9/]47;I
Q/4d?E#2MJfS+7a[:TD>3?I_KJZ2<JM8D-C+4?[3:1;73\B\X<WJEdG?D[KBeSF=
>>FIf.e)f6KU:LA0#VWG0TANI11A3>03N+;A5NX<b4_b(14[]7=96=O0ST/JVdZO
JP5VCL]=_acfgD<8dW_0HUHKf8H9S.ffV;@S:>\GM\5=,X;TD(610@MZS,&6#/?;
5NI1^VVffMg.PU8>GTI^6@8H@\,R&_M6;$
`endprotected

endclass
`protected
1fLe39,-5II?;O?&OQ[(UZdAY-==cANJ&P_,.fROVQKAIb0^OI/T+)WE_,@7+,34
GHM&KLWSMYA(=#@A\.Meb[N9=G,cZS.C5A&DG]-T)d=6K?U<XYDFC3X9f(J.7_7U
;M:1I^(NJbE^4017F&c,L=T#F7e6->HM3+MEQ2;;e0fdLEQRN7\MOM^#d_YM9,II
?b=E^#CC.P8[3B-BSe+=\&d(LMY5.T1M]>4g/]M5?/0-/90-FQGP_#>-&e&&ENQ\
]e0Ed9-WDX0<#W9DHSfV;X6ZET#Y1b2OMVOA-:VK/bgPHZU1:>?3dYTI31/>\M@G
71e><M?O9c#56d[BPY,JP5_QZ]MG#fAF_W\dCbc7HdG-RA;)LGVWPAYV1cNafAB+
150]E<;B7B)7fZJ5O\:Q#4M5+6G-d@[fYc#PQ4Dc4-+G-EGb^P-O8SO,9K@>b#eZ
_AeE@^<,]ED:4#<?L):WF5:BMCR=\VUC4cZ^GQXLU<&]Gg#HF.7R8/+00>+8C[>c
)H#CJNgM_eNU0U=;?\HQcCK;F<QP@[INF)FI41_E3<PLM^eR,@2]/@BR\gL+QIG.
I;Tg@4@94M(N;0T+.DBW&<#J5/_;W0@SdeF1&[5bcLgV;X/ZBK4ZRD2O_\0-=]M-
2dP9=>61[NU;7>T-,\]PA&[97X)6;XUd/7bND3eQV@<@ROa[8>@(Q^eG@eBHeZ&7
>3MIbKA6\>_?-UCD(-?/:@]Yed@DI+^O+c[I^D8ZF_1S>T68XJ;-@]GA0dKPaX90
1^1,JC+G:0cDGMPY6^<#U#&Q,,XKJQ^B<0.9/TZ7L@ET2H;Z=-P(.c),Y_,S1V/(
UNL7)0AT5A/^->X<O.1]Pdg768\1JPe_)_>-d1]W[SW_YH,C\@?_GX6#\+a5U&Wd
&^;R([I)]M&D&KA+C-.=K:FZPS-92,)(-RO1[3YBg9[3:]eS=J&PFWQ9C1P-79TE
_NaW6?7\IP:T>Hc.fJ-V)&J9C?(\;L,CV#_2W3f\X[.>X>Z>(>7QQ]-5aFB.g86Y
01//YZ#[a:C(R2<;6TOL/fEU(I4fG5N#;:L[G:D^cPcQ[Ca.T5WUb)=<e^/+17?6
]fYN.UBO&UE)#E/AcV@GR?2G^X1:C?9]&2U#TD:@cNfULZQ;1BT=c#Dfe,#9MIg#
^H?KD19LY3299Hd5bKA[:7TZ_??G08bB6I=WV;HA;MYK\T8eX=,7]Q&A-YU]MNA>
WKL^;>8<9,\Q=^NZHZcJ9c=[eNTNd;0Nb>UAJ[cN/E:YNFD)eI:5a?B,;8G]^<cW
I_cQeSZFJ->PRW\;I&@<d^[dB?c(A>M2T(UH?:7_TEeJXXMQMWe9)PHTZR1-OCQ^
MI/E@/+R#PZ_Re>?T/^Q8ef&-&daabWQg\R)(XPI-&:G4))2HKSB@:Wc6E;,ZQ:Y
L][c;866X<@H;dO\]6UM[B-3[7efdNF<M(7^>?[G6SZT,_7CSEBC]_R-.R^801?)
ROBG\OO_B2b]f_664D,,+JFVRP?S\.ScMLD#8g7>U,&MWMK-3XU;=BC;=6f4O2BX
aURX=/=2:_SO)BUe;DcX8K5]6X6?eP?9C70TK:SE+5VPPXa]T6K9)_>6dM@W[K@B
I9cYZg0MMYG8Q;BeZ)#6aXOT[]+-JY,@9=GDP4(9G)9PF$
`endprotected

// =============================================================================

`endif
/** @endcond */

`endif // GUARD_SVT_DYNAMIC_REPORT_OBJECT_SV
