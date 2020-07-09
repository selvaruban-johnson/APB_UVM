class apb_bridge_agentpass extends uvm_agent;

`uvm_component_utils(apb_bridge_agentpass)

apb_bridge_moni_read apb_read; 

function new(string name="apb_bridge_agentpass",uvm_component parent);
   super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   apb_read=apb_bridge_moni_read::type_id::create("apb_read",this);
endfunction

endclass
