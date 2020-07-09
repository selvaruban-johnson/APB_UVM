class apb_bridge_sequencer extends uvm_sequencer #(apb_bridge_dataitem);
   
   `uvm_component_utils(apb_bridge_sequencer)

   function new(string name="apb_bridge_sequencer",uvm_component parent);
	  super.new(name,parent);
	      `uvm_info(get_type_name(),"sequencer created",UVM_HIGH)
   endfunction 

endclass

//...............end of sequencer.....................
