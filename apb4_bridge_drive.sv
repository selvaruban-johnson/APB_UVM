class apb_bridge_dri extends uvm_driver#(apb_bridge_dataitem);
  
    `uvm_component_utils(apb_bridge_dri)
     apb_config con; 
     virtual apb_interface vf;
     
     int count=`PACKET;


    function new(string name="apb_bridge_dri",uvm_component parent);
       super.new(name,parent);
    endfunction 

    function void build_phase(uvm_phase phase);
       super.build_phase(phase);
      uvm_config_db #(apb_config)::get(this,"*","confi",con); //getting config object from config_database.  
    endfunction	  
  
    function void connect_phase(uvm_phase phase);
	vf=con.vif;
    endfunction

    virtual task run_phase(uvm_phase phase);
     
      forever 
        begin
	  	
          seq_item_port.get_next_item(req);
	  apb_drive_logic();
	  seq_item_port.item_done();
	  req.print();	


//.....this logic to make enable low after last packet...................
	  count=count-1;
          begin
	     if(count==0)
	      begin     
	       	@(posedge vf.clk);
                vf.PENABLE<=1'b0;
	        vf.PSEL<=4'b0;	
	      end
           end	
        end  
    endtask
 

   extern task apb_drive_logic();
   extern task no_transfer();
   extern task stimulus();
   
 endclass

   task apb_bridge_dri::apb_drive_logic(); 
       begin
          @(posedge vf.clk);	       
// IF THE SELECT AND ENABLE ARE LOW THEN, THERE WILL BE NO TRANSFER
	      if(req.PSEL==4'b0 && req.PENABLE==1'b0)
                 begin
	           no_transfer();
                 end		   


//WRITE MODE		 
              else if(req.PSEL!=4'b0 && req.PENABLE==1'b0 && req.PWRITE==1'b1)
	           begin
		     //req.print();  
	             stimulus();
		     vf.PRDATA <=32'b0; 
		     vf.PWDATA <=req.PWDATA;
		     vf.PSTROBE<=req.PSTROBE;
		     #1 @(posedge vf.clk);
		     vf.PENABLE <=1'b1;
                     wait(vf.PREADY==1'b1);   
		   end

//READ MODE
	        else if(req.PSEL==1'b1 && req.PENABLE==1'b0 && req.PWRITE==1'b0)	
	           begin
		     // req.print();
                      stimulus();
		      vf.PWDATA <=32'b0;
		      #1 @(posedge vf.clk);
		      vf.PENABLE <=1'b1;
	              wait(vf.PREADY==1'b1);
	              wait(vf.PRDATA);	    
	           end    
       end	       
  endtask	  

       task apb_bridge_dri::no_transfer();
             begin		 
	          vf.PADDR  <=0;
                  vf.PWDATA <=0; 
                  vf.PSEL   <=0;
                  vf.PWRITE <=0;
                  vf.PENABLE<=0;
		  vf.PSTROBE<=0;
             end
         endtask
        
	 task apb_bridge_dri::stimulus();
	      begin	 
	           vf.PENABLE<=req.PENABLE;
  	           vf.PADDR  <=req.PADDR;
                   vf.PSEL   <=req.PSEL;
                   vf.PWRITE <=req.PWRITE;		           
	       end
         endtask



	 //............end of driver................................
	 
