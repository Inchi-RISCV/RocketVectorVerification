class
	
  typedef struct { bit [63:0] v[2]; } vector128_t;
  typedef struct { bit[63:0]  v[2]; } float128_t;
  typedef struct {
    bit [63:0]    csr_mstatus;
    bit [63:0]    csr_mepc;
    bit [63:0]    csr_mtval;
    bit [63:0]    csr_mtvec;
    bit [63:0]    csr_mcause;
    bit [63:0]    csr_mip;
    bit [63:0]    csr_mie;
    bit [63:0]    csr_mscratch;
    bit [63:0]    csr_mideleg;
    bit [63:0]    csr_medeleg;
    bit [63:0]    csr_minstret;
    bit [63:0]    csr_sstatus;
    bit [63:0]    csr_sepc;
    bit [63:0]    csr_stval;
    bit [63:0]    csr_stvec;
    bit [63:0]    csr_scause;
    bit [63:0]    csr_satp;
    bit [63:0]    csr_sscratch;
    bit [63:0]    csr_vtype;
    bit [63:0]    csr_vcsr;
    bit [63:0]    csr_vl;
    bit [63:0]    csr_vstart;
  } csr_regs_t;

  typedef struct {
    bit [63:0]    prv_pc;
    bit [63:0]    pc;
    bit [63:0]    instruction;
    bit [63:0]    xpr[32];
    float128_t    fpr[32];
    vector128_t   vpr[32];
    csr_regs_t    csr_regs;
  }rocket_regs_t;

    bit [63:0]    prv_pc;
    bit [63:0]    pc;
    bit [63:0]    instruction;
    bit [63:0]    xpr[32];


endclass
