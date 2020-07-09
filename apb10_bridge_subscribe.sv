class apb_subscriber extends uvm_subscriber#(apb_bridge_dataitem);

     `uvm_component_utils(apb_subscriber)

     apb_bridge_dataitem trc;  

   
     covergroup apb_coverage;
       
        coverpoint trc.PWRITE { bins read={0};
	                        bins write={1};
		              }
        coverpoint trc.PADDR  {bins min[10]={[0:30]};}


     endgroup
   
   
   
   
   
   
   
     function new(string name = "apb_subscriber",uvm_component parent = null);
       super.new(name,parent);
       apb_coverage=new();
     endfunction

     function void write(apb_bridge_dataitem t);
          this.trc=t;
	  apb_coverage.sample();
     endfunction

   

 endclass

 //..........simple coverage checking ...........................
