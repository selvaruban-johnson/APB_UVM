class apb_bridge_moni_read extends uvm_monitor;
	
  `uvm_component_utils(apb_bridge_moni_read) 
  uvm_analysis_port #(apb_bridge_dataitem) item_collect_readport;
  
  virtual apb_interface vf;
  apb_bridge_dataitem  monitor_tr;
  apb_config con;
 

  function new(string name="apb_bridge_moni_read",uvm_component parent);
     super.new(name,parent);     
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
     uvm_config_db #(apb_config)::get(this,"*","confi",con); //getting config object from config_database.   
     item_collect_readport=new("item_collect_readport",this);
  endfunction

  function void connect_phase(uvm_phase phase);
     vf=con.vif;
  endfunction
 
   
  
  
virtual task run_phase(uvm_phase phase);
     forever
        begin
	    monitor_tr=apb_bridge_dataitem::type_id::create("monitor_tr",this);	
	        @(vf.PWRITE);
		     if(vf.PWRITE==1'b0)
		 	 begin
		            wait(vf.PRDATA); 
                            monitor_tr.PADDR=vf.PADDR;
		            monitor_tr.PRDATA=vf.PRDATA;
		            monitor_tr.PSEL=vf.PSEL;
		            monitor_tr.PWRITE=vf.PWRITE;
		            monitor_tr.PENABLE=vf.PENABLE;
			    monitor_tr.print();
			    item_collect_readport.write(monitor_tr);
		         end   
       end    
  endtask     
  
  endclass
  
 