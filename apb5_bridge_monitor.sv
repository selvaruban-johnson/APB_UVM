class apb_bridge_moni_mst extends uvm_monitor;
	
  `uvm_component_utils(apb_bridge_moni_mst) 
  uvm_analysis_port #(apb_bridge_dataitem) item_collect_port;
  
  virtual apb_interface vf;
  apb_bridge_dataitem  monitor_tr;
  apb_config con;
 

  function new(string name="apb_bridge_moni_mst",uvm_component parent);
     super.new(name,parent);     
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
     uvm_config_db #(apb_config)::get(this,"*","confi",con); //getting config object from config_database.   
     item_collect_port=new("item_collect_port",this);
  endfunction

  function void connect_phase(uvm_phase phase);
     vf=con.vif;
  endfunction
 

  virtual task run_phase(uvm_phase phase);
      forever 
        begin
	  monitor_tr=apb_bridge_dataitem::type_id::create("monitor_tr",this);		
	  apb_moni_logic();
	  item_collect_port.write(monitor_tr);
	  monitor_tr.print();
        end  
    endtask
 

   extern task apb_moni_logic();
   extern task get_stimulus();

endclass

     task apb_bridge_moni_mst::apb_moni_logic(); 
       begin
          @(posedge vf.clk);	       
	      if(vf.PSEL==4'b0 && vf.PENABLE==1'b0)
                 begin
	           get_stimulus();
                 end		   

              else if(vf.PSEL!=4'b0 && vf.PENABLE==1'b0 && vf.PWRITE==1'b1)
	           begin 
		      @(posedge vf.clk);
		      
		       if(vf.PENABLE !=1'b1)
				 `uvm_error(get_type_name(), " the protocol voilation enable is not asserting") 	 	 
                       
		       wait(vf.PREADY==1'b1);
		       get_stimulus();   
		   end 
       end	       
    endtask	  

        
	 
     task apb_bridge_moni_mst::get_stimulus();
	      begin	 
	           monitor_tr.PENABLE=vf.PENABLE;
  	           monitor_tr.PADDR  =vf.PADDR;
                   monitor_tr.PSEL   =vf.PSEL;
                   monitor_tr.PWRITE =vf.PWRITE;
                   monitor_tr.PWDATA =vf.PWDATA;
                   monitor_tr.PSTROBE=vf.PSTROBE;		   
	       end
     endtask

     //....................end of monitor......................
