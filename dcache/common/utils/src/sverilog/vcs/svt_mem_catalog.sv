//=======================================================================
// COPYRIGHT (C) 2012-2023 SYNOPSYS INC.
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

`ifndef GUARD_SVT_MEM_CATALOG_SV
`define GUARD_SVT_MEM_CATALOG_SV

/**
 * Default values for specifying memory part depths
 */
typedef enum {
              SVT_MEM_2Kb    = `SVT_MEM_DEPTH_2KB,
              SVT_MEM_4Kb    = `SVT_MEM_DEPTH_4KB,
              SVT_MEM_8Kb    = `SVT_MEM_DEPTH_8KB,
              SVT_MEM_16Kb   = `SVT_MEM_DEPTH_16KB,
              SVT_MEM_32Kb   = `SVT_MEM_DEPTH_32KB,
              SVT_MEM_64Kb   = `SVT_MEM_DEPTH_64KB,
              SVT_MEM_128Kb  = `SVT_MEM_DEPTH_128KB,
              SVT_MEM_256Kb  = `SVT_MEM_DEPTH_256KB,
              SVT_MEM_512Kb  = `SVT_MEM_DEPTH_512KB,
              SVT_MEM_1Mb    = `SVT_MEM_DEPTH_1MB,
              SVT_MEM_2Mb    = `SVT_MEM_DEPTH_2MB,
              SVT_MEM_4Mb    = `SVT_MEM_DEPTH_4MB,
              SVT_MEM_8Mb    = `SVT_MEM_DEPTH_8MB,
              SVT_MEM_16Mb   = `SVT_MEM_DEPTH_16MB,
              SVT_MEM_24Mb   = `SVT_MEM_DEPTH_24MB,
              SVT_MEM_32Mb   = `SVT_MEM_DEPTH_32MB,
              SVT_MEM_48Mb   = `SVT_MEM_DEPTH_48MB,
              SVT_MEM_64Mb   = `SVT_MEM_DEPTH_64MB,
              SVT_MEM_128Mb  = `SVT_MEM_DEPTH_128MB,
              SVT_MEM_192Mb  = `SVT_MEM_DEPTH_192MB,
              SVT_MEM_256Mb  = `SVT_MEM_DEPTH_256MB,
              SVT_MEM_384Mb  = `SVT_MEM_DEPTH_384MB,
              SVT_MEM_512Mb  = `SVT_MEM_DEPTH_512MB,
              SVT_MEM_768Mb  = `SVT_MEM_DEPTH_768MB,
              SVT_MEM_1536Mb = `SVT_MEM_DEPTH_1536MB,
              SVT_MEM_1Gb    = `SVT_MEM_DEPTH_1GB,
              SVT_MEM_1_5Gb  = `SVT_MEM_DEPTH_1_5GB,
              SVT_MEM_2Gb    = `SVT_MEM_DEPTH_2GB,
              SVT_MEM_3Gb    = `SVT_MEM_DEPTH_3GB,
              SVT_MEM_4Gb    = `SVT_MEM_DEPTH_4GB,
              SVT_MEM_6Gb    = `SVT_MEM_DEPTH_6GB,
              SVT_MEM_8Gb    = `SVT_MEM_DEPTH_8GB,
              SVT_MEM_9Gb    = `SVT_MEM_DEPTH_9GB,
              SVT_MEM_12Gb   = `SVT_MEM_DEPTH_12GB,
              SVT_MEM_16Gb   = `SVT_MEM_DEPTH_16GB,
              SVT_MEM_24Gb   = `SVT_MEM_DEPTH_24GB,
              SVT_MEM_32Gb   = `SVT_MEM_DEPTH_32GB,
              SVT_MEM_48Gb   = `SVT_MEM_DEPTH_48GB,
              SVT_MEM_64Gb   = `SVT_MEM_DEPTH_64GB,
              SVT_MEM_96Gb   = `SVT_MEM_DEPTH_96GB,
              SVT_MEM_128Gb  = `SVT_MEM_DEPTH_128GB,
              SVT_MEM_192Gb  = `SVT_MEM_DEPTH_192GB,
              SVT_MEM_256Gb  = `SVT_MEM_DEPTH_256GB } svt_mem_depth_t;

/**
 * Default values for specifying memory part widths
 */
typedef enum {SVT_MEM_x1   = 1,
              SVT_MEM_x2   = 2,
              SVT_MEM_x4   = 4,
              SVT_MEM_x8   = 8,
              SVT_MEM_x16  = 16,
              SVT_MEM_x32  = 32,
              SVT_MEM_x64  = 64,
              SVT_MEM_x128 = 128,
              SVT_MEM_x256 = 256,
              SVT_MEM_x512 = 512,
              SVT_MEM_x1k  = 1024} svt_mem_width_t;

/**
 * Default values for specifying a part clock rate
 */
typedef enum {
              SVT_MEM_20MHz   = 20,
              SVT_MEM_25MHz   = 25,
              SVT_MEM_30MHz   = 30,
              SVT_MEM_33MHz   = 33,
              SVT_MEM_40MHz   = 40,
              SVT_MEM_50MHz   = 50,
              SVT_MEM_66MHz   = 66,
              SVT_MEM_67MHz   = 67,
              SVT_MEM_75MHz   = 75,
              SVT_MEM_80MHz   = 80,
              SVT_MEM_84MHz   = 84,
              SVT_MEM_85MHz   = 85,
              SVT_MEM_86MHz   = 86,
              SVT_MEM_100MHz  = 100,
              SVT_MEM_104MHz  = 104,
              SVT_MEM_108MHz  = 108,
              SVT_MEM_133MHz  = 133,
              SVT_MEM_144MHz  = 144,
              SVT_MEM_150MHz  = 150,
              SVT_MEM_166MHz  = 166,
              SVT_MEM_200MHz  = 200,
              SVT_MEM_266MHz  = 266,
              SVT_MEM_267MHz  = 267,
              SVT_MEM_300MHz  = 300,
              SVT_MEM_350MHz  = 350,
              SVT_MEM_333MHz  = 333,
              SVT_MEM_344MHz  = 344,
              SVT_MEM_400MHz  = 400,
              SVT_MEM_466MHz  = 466,
              SVT_MEM_467MHz  = 467,
              SVT_MEM_500MHz  = 500,
              SVT_MEM_533MHz  = 533,
              SVT_MEM_600MHz  = 600,
              SVT_MEM_667MHz  = 667,
              SVT_MEM_688MHz  = 688,
              SVT_MEM_700MHz  = 700,
              SVT_MEM_733MHz  = 733,
              SVT_MEM_750MHz  = 750,
              SVT_MEM_800MHz  = 800,
              SVT_MEM_900MHz  = 900,
              SVT_MEM_933MHz  = 933,
              SVT_MEM_938MHz  = 938,
              SVT_MEM_1000MHz = 1000,
              SVT_MEM_1066MHz = 1066,
              SVT_MEM_1100MHz = 1100,
              SVT_MEM_1200MHz = 1200,
              SVT_MEM_1250MHz = 1250,
              SVT_MEM_1300MHz = 1300,
              SVT_MEM_1333MHz = 1333,
              SVT_MEM_1350MHz = 1350,
              SVT_MEM_1375MHz = 1375,
              SVT_MEM_1400MHz = 1400,
              SVT_MEM_1450MHz = 1450,
              SVT_MEM_1466MHz = 1466,
              SVT_MEM_1500MHz = 1500,
              SVT_MEM_1550MHz = 1550,
              SVT_MEM_1600MHz = 1600,
              SVT_MEM_1650MHz = 1650,
              SVT_MEM_1700MHz = 1700,
              SVT_MEM_1750MHz = 1750,
              SVT_MEM_1800MHz = 1800,
              SVT_MEM_1850MHz = 1850,
              SVT_MEM_1866MHz = 1866,
              SVT_MEM_1900MHz = 1900,
              SVT_MEM_1950MHz = 1950,
              SVT_MEM_2000MHz = 2000,
              SVT_MEM_2133MHz = 2133,
              SVT_MEM_2200MHz = 2200,
              SVT_MEM_2250MHz = 2250,
              SVT_MEM_2350MHz = 2350,
              SVT_MEM_2300MHz = 2300,
              SVT_MEM_2400MHz = 2400,
              SVT_MEM_2500MHz = 2500,
              SVT_MEM_2600MHz = 2600,
              SVT_MEM_2667MHz = 2667,
              SVT_MEM_2800MHz = 2800,
              SVT_MEM_2900MHz = 2900,
              SVT_MEM_3000MHz = 3000,
              SVT_MEM_3200MHz = 3200 } svt_mem_clkrate_t;

typedef class svt_mem_vendor_catalog_base;

           
/**
 * Base class for the default part catalog entry.
 */
virtual class svt_mem_vendor_part_base;

  local string            m_number;
  local string            m_descr;
  local svt_mem_depth_t   m_depth;
  local svt_mem_width_t   m_width;
  local svt_mem_clkrate_t m_clkrate;
  local string            m_cfgfile;

  local svt_mem_vendor_catalog_base m_catalog;

`ifdef SVT_VMM_TECHNOLOGY
  /** Shared log used if no log is provided to class constructor. */
  protected static vmm_log log = new("svt_mem_vendor_part_base", "class");
`else
  /** Shared reporter used if no reporter is provided to class constructor. */
  protected static `SVT_XVM(report_object) reporter = svt_non_abstract_report_object::create_non_abstract_report_object("svt_mem_vendor_part_base:class");
`endif

  function new(svt_mem_vendor_catalog_base catalog,
               string                      number,
               string                      descr,
               svt_mem_depth_t             depth,
               svt_mem_width_t             width,
               svt_mem_clkrate_t           clkrate,
               string                      cfgfile);
    m_number  = number;
    m_descr   = descr;
    m_depth   = depth;
    m_width   = width;
    m_clkrate = clkrate;
    m_cfgfile = cfgfile;
  endfunction

  
  pure virtual function string get_dwhome();

  virtual function void write();
    $write("%s %s (%s) : %sx%0d, %0dMHz (%s)", get_vendor_name(), m_number,
           m_descr, get_depth_desc(), m_width, m_clkrate, m_cfgfile);
  endfunction

  /** Set the vendor catalog this part is in */
  function void set_catalog(svt_mem_vendor_catalog_base catalog);
    if (m_catalog != null) m_catalog.remove_part(this);
    m_catalog = catalog;
    if (catalog != null) void'(catalog.add_part(this));
  endfunction

  /** Return the vendor catalog this part is in */
  function svt_mem_vendor_catalog_base get_catalog();
    return m_catalog;
  endfunction

  /** Return the name of the vendor for the part */
  virtual function string get_vendor_name();
    if (m_catalog == null) return "<Unknown>";
    return m_catalog.get_vendor_name();
  endfunction


  /** Return the name/number for the part */
  function string get_part_number();
    return m_number;
  endfunction

  /** Return the description of the part */
  function string get_descr();
    return m_descr;
  endfunction

  /** Return the depth of the part */
  function svt_mem_depth_t get_depth();
    return m_depth;
  endfunction

  /** Return the depth in string format */
  function string get_depth_desc();
    string depth;
    depth = m_depth.name;
    get_depth_desc = depth.substr(8, depth.len()-1);
  endfunction

  /** Return the width of the part */
  function svt_mem_width_t get_width();
    return m_width;
  endfunction

  /** Return the clock rate of the part */
  function svt_mem_clkrate_t get_clkrate();
    return m_clkrate;
  endfunction

  /** Return the cfgfile value provided for this part at construction */
  function string get_cfgfile_path();
    return m_cfgfile;
  endfunction

  /** Return '1' if substring found in cfgfile_path, else 0 */
  function bit match_cfgfile_path(string regex);
     
`ifdef SVT_UVM_TECHNOLOGY
    match_cfgfile_path = !uvm_re_match(regex, m_cfgfile);
`elsif SVT_OVM_TECHNOLOGY
    match_cfgfile_path = ovm_is_match(regex, m_cfgfile);
`else
    match_cfgfile_path = `vmm_str_match(m_cfgfile, regex);
`endif

  endfunction

  /** Find the CFG file for this part
   *  First look into VIP installation directory
   *  then in the colon-separated search path list specified
   *  using the +SVT_MEM_USER_CFG_PATH= command-line argument.
   */
  function string get_cfgfile();
    string paths;
    string cfgfile_full_name = "";

    `svt_debug("get_cfgfile", $sformatf("Entered, m_cfgfile = '%0s'.", m_cfgfile));

    if (m_catalog == null) return "";
    
    // Look in the VIP installation first
    paths = {get_dwhome(), "/catalog"};
    begin
      string arg;
      if ($value$plusargs("SVT_MEM_USER_CFG_PATH=%s", arg)) begin
        // The user catalog should take precedence
        paths = {arg, ":", paths};
      end
    end

    `svt_debug("get_cfgfile", $sformatf("Searching for cfgfile using m_cfgfile = '%0s', paths = '%0s'.", m_cfgfile, paths));
    cfgfile_full_name = svt_mem_find_file(m_cfgfile, paths);

    if (cfgfile_full_name.len() == 0) begin
      `svt_fatal("get_cfgfile", $sformatf("Failed attempting to find 'cfgfile_full_name' in catalog based on m_cfgfile = '%0s', paths = '%s'.", m_cfgfile, paths));
    end

    return cfgfile_full_name;
  endfunction
endclass


/**
 * Default part catalog entry.
 * If additional or different part selection criteria are required
 * for a specific suite, they should be added in a derived class.
 * It must be specialized with a policy class the contains
 * a static "\#get()" method returning the
 * full path to the installation directory of the suite.
 */
class svt_mem_vendor_part#(type DWHOME=int) extends svt_mem_vendor_part_base;

  typedef svt_mem_vendor_part#(DWHOME) this_type;
  
  function new(svt_mem_vendor_catalog_base catalog,
               string                      number,
               string                      descr,
               svt_mem_depth_t             depth,
               svt_mem_width_t             width,
               svt_mem_clkrate_t           clkrate,
               string                      cfgfile);
    super.new(catalog, number, descr, depth, width, clkrate, cfgfile);
    set_catalog(catalog);
  endfunction

  virtual function string get_dwhome();
    return DWHOME::get();
  endfunction

  /**
   * Parse a line to see if it is a metadata line
   *  and, if so, return the contained tag and value.
   */
  static local function bit is_metadata_line(input  string line,
                                             output string tag,
                                             output string value);
    int i, j, k;

    // Skip leading blanks
    i = 0;
    while (i < line.len() && (line[i] == " " || line[i] == "\t")) i++;
    if (i >= line.len()) return 0;
    
    // Must be a "//" or "#" comment line
    if (line[i] == "/" && line[i+1] == "/") i = i + 2;
    else if (line[i] == "#" ) i = i + 1;
    else return 0;

    // Skip blanks again
    while (i < line.len() && (line[i] == " " || line[i] == "\t")) i++;
    if (i >= line.len()) return 0;

    // Tag ends with a ':'
    j = i+1;
    while (j < line.len() && line[j] != ":") j++;
    if (j >= line.len()) return 0;
    k = j+1;

    // Strip trailing blanks from tag
    j--;
    while (j >= i && (line[j] == " " || line[j] == "\t")) j--;
    if (j < i) return 0;

    tag = line.substr(i, j);
    
    // Skip blanks again
    while (k < line.len() && (line[k] == " " || line[k] == "\t")) k++;
    if (k >= line.len()) return 0;

    // Strip trailing blanks from value
    j = line.len() - 1;
    while (j >= k && (line[j] == " " || line[j] == "\t" || line[j] == "\n")) j--;
    if (j < k) return 0;

    value = line.substr(k, j);

    return 1;
  endfunction

  /** Parse the specified file and add the part it describes in the
   *  specified catalog.
   *  Returns TRUE if the operation was succesful.
   *  Returns FALSE if the format was invalid or incomplete.
   */
  static function this_type create_from_file(string                      fname,
                                             string                      partnum,
                                             svt_mem_vendor_catalog_base catalog);
    this_type part;
    int fp;
    string line, tag, value, descr;
    svt_mem_depth_t depth;
    svt_mem_width_t width;
    svt_mem_clkrate_t speed;
    bit has_descr, has_density, has_speed;

    fp = $fopen(fname, "r");
    if (fp == 0) begin
      void'($ferror(fp, line));
      `svt_error("create_from_file", $sformatf("Cannot open \"%s\" for reading: %s\n", fname, line));
      return null;
    end

    while ($fgets(line, fp)) begin
      if (!is_metadata_line(line, tag, value)) continue;

      case (tag)
       "Description":
         begin
           if (has_descr) begin
             `svt_error("create_from_file", $sformatf("Multiple \"Description\" metadata value \"%s\" in \"%s\".", value, fname));
             return null;
           end
           has_descr = 1;

           descr = value;
         end

       "Speed":
         begin
           // Speed is encoded as nnnMHz
           int i;
           
           if (has_speed) begin
             `svt_error("create_from_file", $sformatf("Multiple \"Speed\" metadata value \"%s\" in \"%s\".", value, fname));
             return null;
           end
           has_speed = 1;

           i = value.len()-1;
           if (i < 3 || value.substr(i-2, i) != "MHz") begin
             `svt_error("create_from_file", $sformatf("Invalid speed metadata value \"%s\" in \"%s\".", value, fname));
             return null;
           end
           value = value.substr(0, i-3);
           if (!$cast(speed, value.atoi())) begin
             `svt_error("create_from_file", $sformatf("Invalid speed metadata value \"%s\" in \"%s\".", value, fname));
             return null;
           end
         end

       "Density": // Density is encoded as nnnMbxWWW or nnnGbxWWW
         begin
           int i, x = 0;
           string w;
           
           if (has_density) begin
             `svt_error("create_from_file", $sformatf("Multiple \"Density\" metadata value \"%s\" in \"%s\".", value, fname));
             return null;
           end
           has_density = 1;

           while (x < value.len() && value[x] != "x") x++;
           if (value[x] != "x") begin
             `svt_error("create_from_file", $sformatf("Invalid density metadata value \"%s\" in \"%s\".", value, fname));
             return null;
           end

           w = value.substr(x+1, value.len()-1);
           i = w.atoi();
           if (w.substr(w.len()-1, w.len()-1) == "k") i = i*1024;
           if (!$cast(width, i)) begin
             `svt_error("create_from_file", $sformatf("Invalid width (%0d) in density metadata value \"%s\" in \"%s\".",
                                                      i, value, fname));
             return null;
           end

           w = value.substr(0, x-1);
           w = {"SVT_MEM_", w};
           depth = set_depth_via_string(w);
         end
      endcase
    end

    if (!has_density) begin
      `svt_error("create_from_file", $sformatf("No \"Density\" metadata value in \"%s\".", fname));
      return null;
    end
    if (!has_speed) begin
      `svt_error("create_from_file", $sformatf("No \"Speed\" metadata value in \"%s\".", fname));
      return null;
    end
    if (!has_descr) begin
      `svt_error("create_from_file", $sformatf("No \"Description\" metadata value in \"%s\".", fname));
      return null;
    end
    
    part = new(catalog, partnum, descr, depth, width, speed, fname);

    $fclose(fp);
    
    return part;
  endfunction
  
  static function svt_mem_depth_t set_depth_via_string( string depth_str );
//svt_vcs_lic_vip_protect
`protected
#I[FG\SOAg(RcbXbGNZ;HdUWTGB3ObM+:_B)WIcM[G[,W^>/99472(&;NbP.06LZ
/7YH^.8H/&1c]VC^A-./=X_=bfUUL[&AGEE+^CMXR+PI@3>G/6+f^=63H>QUB##U
<3Xdg_SN&N6U^J=9KCb<BCM4N>1F5HXD((;cbeNTK>3D/CCG&Z@1c5ZG:WKV#.+]
MT/KFL;_:5P5UUYO#Q-LSZ]CIW[F7:]ZI&NM+\D>>>SK2BE@g9-RF-/+;D-@D@V1
<?afUCIN8W9C.a8)7MZ_^MS-[\IS)4#2F@]I,Ng7W?a&72OS0;45dWP,?Ig]^S-Y
MH3[S_OPRe3cR&HSPeAMTXXZ@6^]QB,>^=0KT;M:\J,HcY^LO7]>NJ]2GI?DffC7
<F/1/f,fJR;08B#Nf8I]5F>fIN=86;\N>$
`endprotected

  endfunction

endclass

/**
 * Part-independent base class for the vendor part catalog.
 */
virtual class svt_mem_vendor_catalog_base;

/** @cond PRIVATE */
  local string m_name;
/** @endcond */

  function new(string name);
    m_name = name;
  endfunction

  /** Return the name of the vendor for this catalog */
  virtual function string get_vendor_name();
    return m_name;
  endfunction

/** @cond PRIVATE */

  /** Add a vendor part to this catalog.
   *  If a part with the same number already exists in the catalog,
   *  it is repaced with the new one.
   *  Returns TRUE if the part is compatible with the catalog.
   */
  virtual function bit add_part(svt_mem_vendor_part_base part);
    return 0;
  endfunction

  /** Remove the specified part from the catalog */
  virtual function void remove_part(svt_mem_vendor_part_base part);
  endfunction

  /** Get the base class for the ith vendor catalog in the suite-specific shelf
   *  and increment i. The first catalog is at index 0.
   *  returns NULL if there is not such catalog.
   */
  virtual function svt_mem_vendor_catalog_base get_ith_base_vendor(inout int unsigned i);
    return null;
  endfunction

  /** Return the base class for the ith part in this catalog and increment i.
   *  The first part is at index 0.
   *  Returns NULL if there is no such part.
   * */
  virtual function svt_mem_vendor_part_base get_ith_base_part(inout int unsigned i);
    return null;
  endfunction

/** @endcond */

endclass

/**
 * Base class for the vendor part catalog.
 * Must first be specialized with the suite-specific vendor part catalog entry type
 * (itself extended/specialized from svt_mem_vendor_part class).
 */
class svt_mem_vendor_catalog#(type PART=int) extends svt_mem_vendor_catalog_base;

/** @cond PRIVATE */

  typedef svt_mem_vendor_catalog#(PART) this_type;
  
  local static this_type m_vendors[string];
  local static string    m_names[$];
  local        PART      m_parts[string];
  local        string    m_numbers[$];

`ifndef SVT_VMM_TECHNOLOGY
  /** Shared reporter used if no reporter is provided to class constructor. */
  local static `SVT_XVM(report_object) reporter = svt_non_abstract_report_object::create_non_abstract_report_object("svt_mem_vendor_catalog:class");
`else
  /** Shared log used if no log is provided to class constructor. */
  local static vmm_log log = new("svt_mem_vendor_catalog", "class");
`endif

/** @endcond */

  function new(string name);
    super.new(name);
  endfunction

  /** Write all vendor catalogs for the corresponding suite */
  static function void write_shelf();
    foreach (m_vendors[i]) begin
      m_vendors[i].write();
    end
  endfunction

  /** Write the content of the vendor catalog */
  function void write();
    $write("%s Catalog:\n", get_vendor_name());
    foreach (m_parts[i]) begin
      $write("   ");
      m_parts[i].write();
      $write("\n");
    end
  endfunction

  /** Get a catalog from the shelf for the corresponding suite for the named vendor.
   *  If it does not exists, it is created.
   */
  static function this_type get_vendor(string name);
    if (!m_vendors.exists(name)) begin
      m_vendors[name] = new(name);
      m_names.push_back(name);
    end
    return m_vendors[name];
  endfunction

/** @cond PRIVATE */
//svt_vcs_lic_vip_protect
`protected
eQfS_B=1\]E3&3<-?XZd\Yc[V^9bPA9e4T3MUZ@0fK7Nd)]SLeHX.(W5_VGg_R9b
9F^3G.WC]<<dUHc:M9E@\FG<]U+7FFM_HG8B>6LB\AT(+dV:9D;9E>,gWQ4W?dXb
U]S/Vd,MfKP>K3R^</@E,P.PX7OC@Y[<;)IT]B1afK3<VIfJ3_;.V#+gSRCOR8fT
QG8G/PMEQd>QAe,0:^dAKO^B5Y2L:\g0P7-LPgMW#\c0gVH(_+,7[C#6A\>S,PcV
]GNaZ&3RT>_\VR;:\VLBbRJ-eK&dc5]E,eQ32(D9[&AA898GS4#6)1aCG)7M#I_.
<S.>.5TZg,c78^DO]HISLT#R=JdL[<8a&.cOg^I_VMa7?PN>8<=6]=Y#8TVJ+TeR
\V1()A4=c-;0PO,AM5RX-JOD9A-6\M\Tb18>;S^HRF@3Rfd-.@_d/SI>[2T_^IAL
T]QKLN6X7.RQ:a=bE7N#=HY&F\+\YE;>QceXed:TOMHaIYc4g3O>CZ_.]fB(_/2?
KE5HP?[P1<bf59ZO7)_@?A/c4#[8^H8_=.[&#N-7J<O)4\A4gHGX=U64-/aFZ#/V
;^>(K87&DIO:)[4f3EEK9_[0HE.#?#O98686.8+CYQY)N1HTEJ3]+86ZY@d989^A
#Z5BYNY)3D_SNE;=HUW@NcK-bg)OKf)\L=6-KD\8W\/SH;-g^bJ^0GNS=2RFOX7\
\bf)5TcDaWXP-@1K2KcE\+\J+L18_NA)5L+RDQ\.93LHP7a_=aLM:.GP3>g[a(Lf
HH]P?#<KHa^62c6)+I&DLT0IGL&,;UUV^6H\Q46RHS&>GCcVI^,8EJM]W&b^gE\[
8=:U-@H9(bX-A_[8Y.6JR+Q>=,XSWa4WRF6;]+>d2c<^+gQ=Y>0bVZVdO:@S4Gf2
IX7PHO,^TO^;;@LF8_D3LQU(8_#WU,,&R01,[A-6(1(Cb#cJf8=FAP;,CA>A5LeJ
DKL?g_,eS#6_D:F40D/BC>L+KbGeI\#c2gIJd&D.9d#@ZHMU]^13eCQ)Te&R9.1=
C/adQ?>K;cD/Mg;>60ZR^TO(:/T@6#b;F-ZW=A]P74,.Pb3+Z#T\6:><7D/&2a>H
[eG[U(0/T=H.XHYJJ=WH,g\Og^=4;MWYN>#FH@B8d&bWc7FEcbY0/EZH;M05<B4S
ZM4^/D9(G:51?US_EcYHcbE,_<fFQW2A\_9e(/Qa,/dSB[c-O(IH76]eS(=CGAe+
6a/14\&S3#a?c+QTMeZ^c30>?.9\aJf@-:J#=1_H0^I3#E4C\H]3)Ia/G)ZIc3X?
,07H?6U.I[a&SHE<5E-OCE9BKIX4+_)?fZ#5\.>K+VECVIN<_cVXB[>^.9J978U)
-?b#dA81FPGA)AJL78DfR=1;a;_H&ZT[.DMP3^P,PXN8P]:-BPc1Sf2PEaA<83#>
4@O9](LCI>EET)<Ff0#1==I&J&>6Y@XT1WJZ[O_WE)91_.Tg:\+L-LW>;2NcMZc/
@XYK;De-+,63Jd8(7<:6eBBZ(/@RXU9,/[Z9,MS35#UU<?^VLA9HJQeMg4MB>fH9
0ZC4<EIUWXQX)U>4a-8T7Q+:MU:,=_4HC2g,WATEQ&9^c_GFS0-9e;=-JW1A@WAX
P98b100<>(5R@b@@,VS\B5e7D;L(A5TDBK/Wb-8X)+2(bAJ<QHO:W4@R[Q\;GB)N
XQN57\L7a8UQK<&G-f7:]-:((Y@_\/Sd/gP>(KE<23(+DKTfIY0K@Y85U#F(e+)V
b^DMB8[U(Y\c;K:?@NT5\2&g0I(^TWPg.E3D?[T0T:TMe]^=@;<4WC)DZeWU^<gF
Mb-HIUBG]BH4KFKcD\GI0&RF<RaDd,8?JeVWYe-(T@bd8I;dZDM15671\X6D8TD[
)SGg1NI<+X56NbWfO3/:X]WE,74-YNa2^B9cCUA3R:6C/H\<D;gS#F4bf?[W4EDe
Kc6[^a#d3GSe8P9B=CFfb?B;4.F=.8/M:[7FdS=)3(^UI2.:KgQ-YCA=8/_7G\=@
7F2DDMN6:LNRS<Ned1C<HF)WL/gI4PPPAgFaT7[>/,,1bNN0#^@AAcT8(0HVcEY,
7QLS5N4#_.dWKX2^Od2IEP+/97Q0g^;XgA0(]F4G))VSc8e-;d.]H2UAMfBHaJ>)
BG&]Q->/7KUJ/530.&-Z15D/dT[=W5YH&@LF=SRfLJKB]7HMRB)ACIV683TMLL+C
4KBMHP8=P]/+30>2.X),Y8dY9:XTZ)GKV&+&Fc01QO]VTMXTFQ+_J5b88L+V/OO+
,#VeTDRbgb[G:57G+\MTS(ba/E3+C)7BgNA\QPJ0=R&L;fgSc24B#<(#bNdS+X#B
K:HXJ\0>R8W7_HP6SL3^daFX[+QTI&;0P+?UH^AddWb-[]VW+M:XB-G5)0?D4@IU
&23,HTM8KR#CS;WM]UNNK\[HX(.e2Q0_ed(>HI_/K-O./27D0.MTaFHHb><8_=b4
Pdbf2(D2f7LDP8YO+83OfB84=)PKC&f&1b95[1W>_cW6JF4G0GCE)a4XZ(,Z/.D7
g]c\-8[P+gZfLSJI:K?A?&7?\dEF7QL@f.3.]Sfa@HMX]KBZBMJ>V043VdL#.M.N
GT?PfO2OBIC\.MWNXUQ@37L536<HWf=LU:6Ee0E)1))?D@]83>d3>YHWRQ1Sg)3.
LHY/+DTF\D@=c903g(2>/&(8_OK?BG4RGa,VELY6P;@N,2=P]A#SI<6,^E@PJZ\5
A(:Mc[:<Y:9A3b)#O0,(0A8=GSZ_7LfEUfVbeMfHVHM<TGQW=RRO_3P(^O.DeBB^
R=b/=1NdY=?<V##RSQV[YbYCX5M,,2A]50cZ,a]5(>:cUdg_3fBL<0ZU.+?58YD=
dUM&5+gR(X@FPS7I_N[Je=Bg+7))12bC1IARZM4I4NaM\?J>DMMZgST.cT0JNeb@
Y(S-]HRZ6c)E,<UgSB3[A7L7L^A5DKI_b:bE:3C6#3-I3=NF,Gg#6,9?NfQ#)KV;
&ZgK1^QNZQeXV9@J/N8+8JgD/[Uc,1I5fX3RN;CZ#5g.)196OL0BI6If40#J7U79
9JKf7ee][e==0QfHFH>R40/S74Y:./fF9#Y1SfOA@OCR;D:FJCFDG1TE[S>ZH:?D
15U=SfIEN/82E]R4<CIC)Bb]]?27CUJUaBF53b5XW_bD_)dg6T_I1FZ^YZFR^^Mf
-\NLS)<.^)g>bbaK+SZX11=0:.:Z;/X3MIMW+VS2Wdd.+W:L/TQ+OIN2+dGM0Y;@
3,A\XH#gAI(_.0J0)A=b12fVQU@>B[U:b^_TVI@2#YNUcO_W:OM,.WcCAX?E-5b=
1ac@PP_#FcX=FLReSfa,25gENeXPe6YGaZJT#K[-a.eQbQLY9X\fF&ANa4H_.d1P
4aSE(CK2.T3:POVS0);\9O:T/af71QIXP(]RN9+)R4VKO5H#<70,AY.XA+&&9C4O
\0(WO[g\,FVF7EEVgPfORd>CBUUHaTVUH_^Y;AbfYe\9:#;gZ=7fX)3A76&RBRWX
Mb55X^Z9Y#e?UUI(+.:/AV6T._DKCT.d0&;)BaMNHAJQ3T@&2MT:5:TAV,1DNR]A
Cc3>1\,c^6GVWD&J@_H)DL<EUb.X&daQM&?f_HJg:E]A):[f=+N4M-fa0,Q-FD#c
MPX_=.1efIO>1,#;+_:IFL;gBSfBP&T]d,MWO)NAe:[A@cT.U8AJN6eBB5R-AF<6
2-R2cMJabAV]gd3DD-bgOU^]P<UDVeD\+OdJ&.^Q5PAQM@\P1.V(<[Q=YM\\da\B
LaB[B,E?JH;ceZ^.7Y)L=XAWebf(8JT,OO6=M.PP:QT\]URI:]0]A:I9d;f?65YX
9(5\_GaN_fS1eLWAAKHQ48L>+/#_73N2A50ZR7?18FW8-U?UF0c@B-N2b_;/^53f
KM83gN8)#a^LGEZJ1HU.7BV;]1A.]JUXe=@GOXS\Q(d<?c133MfSc;8a7TY?c?Ab
_Ic&DcbBLKW,5gZIG+N,9,TE?d<ZF/&9c;+R33H^,M:?De+]<4#D3aM7[LYKU:__
Q2-M?6g)QEA>]JWNF2C5U)Q&X0Z]Q+Db&&PeRH9?5ZONf7;bVI\VWI2OL3N3V\S+
fDR,/(T@YFEX>Y[1H1f3>A064I<EZadMc_68S@)+J4D(@D/:>T2c]AGH+73JBJ>O
E&[KU@e2,V,;01J_8D_.[Id>G#UNaEGW32^(<b^0/1_U)L6^ALFUR_(\PPWZ<>(F
XgQ353TQ+eZcGf=-L8C8)^&\B,aDC2@6D+A9?G5T?+.LM<GX)NBIZ_G95,cI,B3+
+IeY7e>bYDMeZC\#)\E48)OcQXcg5K5bd9cZ#@SMYDELK4SOXae;[41AKU/H6a[H
(4R\DT8/I-#;-X91IgI0]J<C-U>/VR#^G-M8c?L/bWX0=H3e74<B0#437PK9Ue0C
Ng?()NY@)G4-YG70W_Af9^DQFMZ0VE,d65[SQ6HB^+21RN<Q(1G-eF_);SI;E&fW
K13+aXc6b#Q5JG06SIW^&4S:<9ee6GbLWMXN;/e4;PIDEf7&M-@KP;V+,-34dW=S
N9J4VaU;3a,H[BbH<J)Y4bU-/@[RN]V1agT??e0AA>D90Ue(]]f:H)M:;7/4O5a\
2CEO5NaT@@7;\IY9G\:1E=G@SBHHLfZO4_W\GK:+DL@=-SGFA,-5JUP?[fGM5(bKR$
`endprotected

/** @endcond */

endclass

/**
 * Default policy class to select all parts in all catalogs on a shelf
 * with an equal distribution value of 1.
 */
class svt_mem_all_parts#(type PART=int);
  /** Simply returns 1 */
  static function int weight(PART part);
    return 1;
  endfunction
endclass


/**
 * Class to pick a suitable vendor part at random amongst all
 * vendor parts in all catalogs on a shelf.
 * 
 * The PART parameter defines the suite-specific shelf.
 * 
 * Suitability is determined by the static POLICY:: weight(PART) function.
 * This method is called by this class
 * for each part in each catalg on the shelf.
 * If it returns a zero or negative value, the specified part is not suitable.
 * If it returns a positive value, the part is suitable and the value
 * is the random-distribution weight assigned to that part.
 * 
 * By default, all parts are suitable and have an equal distribution weight value of 1.
 * 
 * User may specify different part selection policies by implementing
 * different static weight(PART) functions. For example:
 * <pre>
 * class only_x16_parts#(type PART=int);
 *   static function int weight(PART part);
 *     if (part.\#get_width() != SVT_MEM_x16) return 0;
 *     return 1;
 *   endfunction
 * endclass
 * </pre>
 */
class svt_mem_part_mgr#(type PART=int, type POLICY=svt_mem_all_parts#(PART));

`ifndef SVT_VMM_TECHNOLOGY
  /** Shared reporter used if no reporter is provided to class constructor. */
  local static `SVT_XVM(report_object) reporter = svt_non_abstract_report_object::create_non_abstract_report_object("svt_mem_part_mgr:class");
`else
  /** Shared log used if no log is provided to class constructor. */
  local static vmm_log log = new("svt_mem_part_mgr", "class");
`endif

  /** Pick and return a suitable part from the catalogs on a shelf */
  static function PART pick();
//svt_vcs_lic_vip_protect
`protected
B.)M[g5+dd>P.ae(L(I<O38VI:X;Q4@&RA.H5AXX);].&X73NMQD+(YH;KY(X^d9
]1gfJg:7REH46QUE?JWc@dYM(g3+EbK6.Bee3IC(?S&]D9;+bdYCJc<2<#Gge8D(
=QSYC?b4\Yc,98.0,2S^?+LUL3>P;SZ,<aI9PUe>V+](RLUET6@c,@YHbA)J#0NY
bg=^DeKTd?9TfW);a=N0+208X:O)IUZ?3fCa3]E;cCK,gL#;KN,3S:dg<JCP,]TQ
L&+#ceDCg8#=VFgVb4I&S#S&gKVM6PDH,^S#<RIV&/>W;MT\/\7R(RP<^EHLdCYL
8(HMWXW<\4gfW>>YXHWgQEY?a(1Y#b^\ga1?<NY+#T6)4.(7ZQ<9fG@,Ae]J8=:f
g5-2g+48.(@NP?U_K+/M#K/d@cdW7fEc>@1NZ;0c=-a<\Eg9OeTOIR#<>5KAMKI[
)]_=-4&B_VRCMV8#^R:\2XWX<.6G:2J(/UXfbIII_CLB/b9Z5H?:c,\a>eI6F(,W
a=XDgLba5fJF/2?gJ+9@=\KQO=Z/gbDC:Jcdc/E)YWa+B9;-c>>]A_/8))FRKC#f
,(=2U0gd(e^#bA\JM/+.+M:1B(&_.0H:X25a27QKFWG3O,7\_>56cD.JV_.PW1@5
\be^5.^B6J6Z@^8LTR]N@H1TTf7I5-TTV1XN5Z1U27I<A;1<&+QU_M>C;\U+)H,^
g#4-Lgcc1PFXHR-1H[0@FeORY/VXQ(Ub<T\J\K4VBX0[4_],.bE0)2XAYOa?L7V#
9L601P0EaVTaS,6-RH7dT\)JV^,)\R4>SffbEU@M^3^V]4LHb6904\TMgSTB_4M?
_=FR[G[>8MRTW80X.BbQed67@UIN+8LWNKPLY[Y&WHK,B)Ed[F^MMe\:L.L>\\[5
>fL>:e@,4>_0U>[e=+ZDa4)QUR/^Y2\eD5A@G:LcY]O-/9<2.S?>bIM2.^eeAU+9
D2\OW]bH_O&:^5RCR<2BM+XS0?ZF6e<EGdK64bM&>RcJ(efb3F[D+bD>])7AVe;Q
]Yg21W77>^,XN[NW]+\e<&eHYMK&-7[V/D@N^M?ZW+E979PFUT0ZKCD>I$
`endprotected

  endfunction

endclass

`endif
