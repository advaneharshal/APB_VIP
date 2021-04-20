//`include "tb_define.sv"
interface apb_if(input pclk);   
    logic                   presetn;    // active low reset
    logic                   psel;       // select signal
    logic                   penable;    // enable signal
    logic                   pwrite;     // write strobe
  logic [`ADDR_WIDTH-1:0] paddr;      // addr 
  logic [`DATA_WIDTH-1:0] pwdata;     // write data
  logic [`DATA_WIDTH-1:0] prdata;     // read data
    logic                   pready;     // slave ready signal
    logic                   pslverr;    // slave error response
    
    // clocking block declarations
    clocking cb @(posedge pclk);
        default input #1ns output #1ns;  // default delay skew
        output  psel;
        output  penable;
        output  pwrite;
        output  paddr;
        output  pwdata;
        input   pready;
        input   prdata;
        input   pslverr;
    endclocking: cb
    
    // modport declarations
    modport dut(output presetn, clocking cb);
    
    ///////////////////////////////////// property check assertions ////////////////////////////////////
    // apb_read transfer seq check
    property apb_read_seq_prop;
        @(posedge pclk) disable iff(!presetn)
        psel && !pwrite && paddr!='bx |=> penable ##[1:$] pready ##1 !penable |-> !psel;
    endproperty    
    
    // apb_write transfer seq check
    property apb_write_seq_prop;
        @(posedge pclk) disable iff(!presetn)
        psel && pwrite && paddr!='bx |=> penable ##[1:$] pready ##1 !penable |-> !psel;
    endproperty
    
    // property check assertions
    assert property(apb_read_seq_prop); 
    assert property(apb_write_seq_prop);
    
    ///////////////////////////////////// interface tasks /////////////////////////////////////////////
    // interface reset task
    task reset_intf();
        presetn = 0;  // trigger reset
        psel = 0;
        penable = 0;
        pwrite = 0;
        repeat(2) 
            @(posedge pclk);
        presetn = 1;  // back to normal operation
        @(posedge pclk);
    endtask
endinterface : apb_if
