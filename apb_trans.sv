class apb_trans;
//  typedef enum {WR,RD} op_type;
  rand bit [`ADDR_WIDTH-1:0] addr;
  rand bit [`DATA_WIDTH-1:0] data;

  rand op_type op;
  
  //constraint addr_c {addr < 'hff;};
  function display(string _component);
     $display(" *** Transaction @%s***",_component);
     $display(" Addr    :%h",addr);
     $display(" Data    :%h",data);
     $display(" WR/RD   :%s",op);
  endfunction
endclass
