class apb_config extends uvm_object;

`uvm_object_utils(apb_config)

virtual apb_interface vif;


function new(string name="apb_config");
	super.new(name);
endfunction

endclass


