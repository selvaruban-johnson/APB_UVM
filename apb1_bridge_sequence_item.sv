class apb_bridge_dataitem extends uvm_sequence_item;
   
   	
   //master_side.......
   randc bit [`ADDR_WIDTH-1:0] PADDR;
   randc bit [`DATA_WIDTH-1:0] PWDATA;
   rand  bit [`SEL-1:0]          PSEL;
   rand  bit                   PWRITE;
   rand  bit                   PENABLE;
   rand  bit [`STR-1:0]        PSTROBE;

   //slave_side.....
         bit        PREADY;
         bit [`DATA_WIDTH:0] PRDATA; 
   
  constraint p_enable {PENABLE==1'b0;}
   
  constraint p_select{PSEL==4'b0001;} //selects peripheral one (slave one) 

  constraint P_strobe {PSTROBE==4'b1111;}  

  //PWRITE==1 then write operation else if zero read operation.	     	       
  constraint  write_or_read{PWRITE==1'b1;} 
  //to perform read do inline constraint.... 
 
  constraint data_range{PWDATA inside {[0:300]};}  

  constraint addr_range1{PADDR inside {[0:100]};}	                       
     `uvm_object_utils_begin(apb_bridge_dataitem)  //register to factory......
        `uvm_field_int(PADDR,UVM_ALL_ON)
        `uvm_field_int(PWDATA,UVM_ALL_ON) 	
        `uvm_field_int(PSEL,UVM_ALL_ON)
        `uvm_field_int(PWRITE,UVM_ALL_ON)
        `uvm_field_int(PREADY,UVM_ALL_ON)
        `uvm_field_int(PENABLE,UVM_ALL_ON)
	`uvm_field_int(PRDATA,UVM_ALL_ON)
        `uvm_field_int(PSTROBE,UVM_ALL_ON)
     `uvm_object_utils_end
 
  
  function new (string name = "apb_bridge_dataitem");
    super.new(name);
       `uvm_info(get_type_name(),"data_item_object created",UVM_HIGH)
  endfunction



endclass

//................end of packet......................................
