`uvm_analysis_imp_decl(_WRT)
`uvm_analysis_imp_decl(_RED)

class apb_bridge_scoreboard extends uvm_scoreboard;
	
  `uvm_component_utils(apb_bridge_scoreboard) 

   uvm_analysis_imp_WRT #(apb_bridge_dataitem,apb_bridge_scoreboard) apb_write_export;
   uvm_analysis_imp_RED #(apb_bridge_dataitem,apb_bridge_scoreboard) apb_read_export;
   
   bit [7:0] addr_write[$]; bit [31:0] data_write[$];
 
   bit [7:0] addr_read[$];  bit [31:0] data_read[$];
  
   function new(string name="apb_bridge_scoreboard",uvm_component parent);
      super.new(name,parent);
   endfunction 

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       apb_write_export=new("apb_write_export",this);
       apb_read_export =new("apb_read_export", this); 
   endfunction
   
   virtual function void write_WRT(apb_bridge_dataitem pkt);
      begin  
          if(pkt.PWRITE==1'b1)
            begin		
              addr_write.push_back(pkt.PADDR);
              data_write.push_back(pkt.PWDATA);
	    end 
      end	 
   endfunction 

   virtual function void write_RED(apb_bridge_dataitem pk);
      begin  
            if(pk.PWRITE==1'b0)
            begin		
              addr_read.push_back(pk.PADDR);
              data_read.push_back(pk.PRDATA);
	    end
     end	 
   endfunction 


   virtual function void extract_phase(uvm_phase phase);
     repeat(addr_write.size)
        begin
           int aw,dw,ar,dr;
	   aw=addr_write.pop_front();
           dw=data_write.pop_front();
	   ar=addr_read.pop_front();
	   dr=data_read.pop_front();
	      begin
		   if({aw,dw}=={ar,dr})
		       `uvm_info(get_type_name(),$sformatf("the data matches [writeaddress=%0d writedata=%0d]=[readaddress=%0d readdata=%0d]",aw,dw,ar,dr),UVM_MEDIUM)
                   else
	              `uvm_info(get_type_name(),$sformatf("the data is not  matching !!!!!! [writeaddress=%0d writedata=%0d]=[readaddress=%0d readdata=%0d]",aw,dw,ar,dr),UVM_MEDIUM)	
              end	       
           
        end     
   endfunction

endclass
