class apb_bridge_agentact extends uvm_agent;

`uvm_component_utils(apb_bridge_agentact)

apb_bridge_sequencer apb_seq;
apb_bridge_dri apb_dri;
apb_bridge_moni_mst apb_moni_mst; 

function new(string name="apb_bridge_agentact",uvm_component parent);
   super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   apb_moni_mst=apb_bridge_moni_mst::type_id::create("apb_mon_mst",this);
   apb_dri=apb_bridge_dri::type_id::create("apb_dri",this);
   apb_seq=apb_bridge_sequencer::type_id::create("apb_seq",this);
endfunction

function void connect_phase(uvm_phase phase);
  apb_dri.seq_item_port.connect(apb_seq.seq_item_export);     
endfunction 

endclass
