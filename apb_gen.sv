
class apb_gen;

   mailbox gen2drv;
   apb_trans tr;
   int cnt;
   function new(mailbox _gen2drv);
      this.gen2drv  = _gen2drv;
   endfunction 
  
  task run(int num,apb_trans cust_tr=null);
     $display (" Inside GEN run task");
        if(cust_tr==null)  begin 
          $display(" No custom tr set num trans %0d",num);
          repeat(num) begin
            tr=new();
            cnt++;
            void'(tr.randomize());
            gen2drv.put(tr);
            void'(tr.display("GEN"));
            $display("GEN Mbox size %0d cnt %0d",gen2drv.num,cnt);
          end
        end
        else begin
          $display (" custom transaction present");
          repeat(num) begin
            gen2drv.put(cust_tr);
            void'(cust_tr.display("GEN"));
          end
        end
   endtask
endclass 


