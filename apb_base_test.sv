`include "apb_env.sv"
class my_trans extends apb_trans;
  constraint addr_c {addr <255;};
endclass
class apb_base_test;

  apb_env env;
  my_trans my;
  bit [`ADDR_WIDTH-1:0] test_addr;
   virtual apb_if vif;
  function new(   virtual apb_if _vif);
    this.vif = _vif;
    env =new(_vif);
  endfunction 

  task run();
    vif.presetn=1'b1;
    vif.pready = 1'b1;
    vif.reset_intf();
    repeat(2) begin
    my=new();

    my.randomize() with {op==WR;};
      test_addr=my.addr;
      env.run(1,my);
      my.randomize() with {op==RD;addr==test_addr;};
    env.run(1,my);   
      #100;
    end
  endtask



endclass
