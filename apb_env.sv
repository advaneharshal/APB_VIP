
`include "apb_trans.sv"
`include "apb_gen.sv"
`include "apb_drv.sv"
`include "apb_mon.sv"
class apb_env;

   apb_gen gen;
   apb_drv drv;
   apb_mon mon;

   mailbox gen2drv;
   mailbox mon2sb;

   virtual apb_if vif;
   function new(virtual apb_if _vif);
      this.vif =_vif;
     gen2drv = new(1);
      mon2sb =  new();
      gen=new(gen2drv);
      drv=new(gen2drv,vif);
      mon=new(mon2sb,vif);
   endfunction  


  task run(int trans_num,apb_trans _trans=null);
      fork
        gen.run(trans_num,_trans);
        drv.run(trans_num);
         mon.run(); 
      join
     $display($time," Done with env join");
      //#100 $finish();
   endtask


endclass
