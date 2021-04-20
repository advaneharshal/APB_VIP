class apb_drv;
   mailbox drv2gen;
   apb_trans tr;
  event drive_done;
   int cnt;
   virtual  apb_if drv_vif;
   
   function new(mailbox _drv2gen, virtual apb_if _drv_vif);
      this.drv2gen = _drv2gen;
      this.drv_vif = _drv_vif;
   endfunction

  task run(int num_trans);
    $display (" Inside DRV run task ");
     //wait(drv_vif.presetn == 1);
     $display (" Done waiting for presetn");

    /* forever begin
       fork 
         drive_apb();
       join_any
       $display("Done join_any");
       disable fork;
       $display("Done with disable");
       @(drv_vif.cb);
       ->drive_done;
     end*/
   // drv2gen.get(tr);
    $display(" num trans %d",num_trans);
    repeat(num_trans) begin
      cnt++;
      $display (" Curr trans cnt %0d",cnt);
            drive_apb();
    end
 
   endtask
 
   task drive_apb();
      @(drv_vif.cb);
     $display(" Inside drive_apb");
               
     $display("DRV Mbox size %0d",drv2gen.num);

      drv2gen.get(tr);
     void'(tr.display("DRV"));
     if (tr.op==WR) begin
         apb_wr(tr);
      end
      else begin
         apb_rd(tr);
      end
             //drv2gen.get(tr);

     $display($time,"Done with the drive apb ");
   endtask

  task apb_wr(apb_trans _wr);
        drv_vif.cb.psel <= 1;
        drv_vif.cb.pwrite <= 1;
        drv_vif.cb.paddr <= _wr.addr;
        drv_vif.cb.pwdata <= _wr.data;
        drv_vif.cb.penable <= 0;
        @(drv_vif.cb);
        drv_vif.cb.penable <= 1;
        @(drv_vif.cb);
        wait(drv_vif.cb.pready == 1);
        drv_vif.cb.penable <= 0;
        drv_vif.cb.psel <= 0;
        @(drv_vif.cb);
   endtask

  task apb_rd(apb_trans _rd);
    $display("Inside apb_rd");
        drv_vif.cb.psel <= 1;
        drv_vif.cb.pwrite <= 0;
        drv_vif.cb.paddr <= _rd.addr;
        drv_vif.cb.penable <= 0;
        @(drv_vif.cb);
        drv_vif.cb.penable <= 1;
        wait(drv_vif.cb.pready == 1);
        drv_vif.cb.penable <= 0;
        drv_vif.cb.psel <= 0;
   endtask
endclass
