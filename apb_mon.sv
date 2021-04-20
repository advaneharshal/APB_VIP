class apb_mon;
   mailbox mon2sb;
   apb_trans tr;

   virtual  apb_if mon_vif;

   function new(mailbox _mon2sb,virtual  apb_if _mon_vif);
      this.mon2sb = _mon2sb;
      this.mon_vif=_mon_vif; 
   endfunction 

   task run();
     $display (" Inside MON run task");

   endtask


endclass
