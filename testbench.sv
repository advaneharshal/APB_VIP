`timescale 1ns/1ns
`include "tb_define.sv"
`include "apb_intf.sv"
`include "apb_base_test.sv"

module tb_top();
    
   
    // clock declaration
    bit clk_100MHz;

    // interface declaration
    apb_if   apb_intf(clk_100MHz);
    
    // 100MHz clock generation block
    initial begin
        forever begin
            //#((0.5/`APB_CLK_FREQ_MHZ) * 1s) clk_100MHz = ~clk_100MHz;
             #5 clk_100MHz = ~clk_100MHz;
        end
    end
      
    apb_base_test test;
    // instantiation of DUT
    apb_v3_sram #(  // parameters
                        .ADDR_BUS_WIDTH(`ADDR_WIDTH),               // ADDR BUS Width
                        .DATA_BUS_WIDTH(`DATA_WIDTH),               // Data Bus Width
                        .MEMSIZE(`APB_SRAM_SIZE),                   // RAM Size
                        .MEM_BLOCK_SIZE(`APB_SRAM_MEM_BLOCK_SIZE),  // Each memory block size in RAM
                        .RESET_VAL(0),                              // Reset value of RAM
                        .EN_WAIT_DELAY_FUNC(`APB_SLV_WAIT_FUNC_EN), // Enable Slv wait state
                        .MIN_RAND_WAIT_CYC(`APB_SLV_MIN_WAIT_CYC),  // Min Slv wait delay in clock cycles
                        .MAX_RAND_WAIT_CYC(`APB_SLV_MAX_WAIT_CYC)   // Max Slv wait delay in clock cycles
                ) DUT (       
                        // IO ports
                        .PRESETn(apb_intf.presetn),             // Active low Reset
                        .PCLK(clk_100MHz),                          // 100MHz clock
                        .PSEL(apb_intf.psel),                   // Select Signal
                        .PENABLE(apb_intf.penable),             // Enable Signal
                        .PWRITE(apb_intf.pwrite),               // Write Strobe
                        .PADDR(apb_intf.paddr),                 // Addr
                        .PWDATA(apb_intf.pwdata),               // Write data
                        .PRDATA(apb_intf.prdata),               // Read data
                        .PREADY(apb_intf.pready),               // Slave Ready
                        .PSLVERR(apb_intf.pslverr)              // Slave Error Response
                    );
                    
    initial
      begin
      //  force DUT.PREADY= 1'b1;
        test=new(apb_intf);
        test.run();
        #100;
        $finish();
      end
  initial begin $dumpfile("dump.vcd"); $dumpvars; end
endmodule: tb_top
