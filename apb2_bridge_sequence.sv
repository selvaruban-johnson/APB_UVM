


// sanitory test case one write and one read ..next 256 write and read

class apb_bridge_seq extends uvm_sequence#(apb_bridge_dataitem);
 
   `uvm_object_utils(apb_bridge_seq)

    static bit[7:0] i; //control signal to control the write and reads
    static bit[7:0] q; //store address for read operation at same address
 
 function new(string name= "apb_bridge_seq");
     super.new(name);
      `uvm_info(get_type_name(),"sequence_object created",UVM_HIGH)
 endfunction

  virtual task body();
     repeat(`PACKET)
        begin
	   if(i[0]==1'b0) 
	      begin	   
	         `uvm_info(get_type_name(),"sanitory test case one write and one read",UVM_MEDIUM) 
                 `uvm_do(req)
	          q=req.PADDR;
                  i=i+1;
	      end	
           else if(i[0]==1'b1)
	      begin	   
                `uvm_info(get_type_name(),"$sequence_read ",UVM_MEDIUM)
                 req=apb_bridge_dataitem::type_id::create("req");
		 start_item(req);
		 req.write_or_read.constraint_mode(0);
		 req.data_range.constraint_mode(0);
		 assert(req.randomize() with {req.PWRITE==1'b0;req.PADDR==q;});
		 finish_item(req);
	         i=i+1;
	      end	      
       end 
 endtask
endclass






 //write values to all the locations and find the coverage that it covered all the location.  
 

class apb_bridge_seq1 extends apb_bridge_seq;
 
   `uvm_object_utils(apb_bridge_seq1)

 function new(string name= "apb_bridge_seq11111");
     super.new(name);
      `uvm_info(get_type_name(),"write values to all the locations",UVM_MEDIUM)
 endfunction

 
   virtual task body();
     req=apb_bridge_dataitem::type_id::create("req");
    
     repeat(`PACKET)
       begin 
           start_item(req);	
           assert(req.randomize());
	   finish_item(req);      
       end
   endtask

endclass





//..................the end ................only two sequence........
