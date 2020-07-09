class apb_top_environ extends uvm_env;
  
     `uvm_component_utils(apb_top_environ)
      apb_bridge_agentact   active_agent;
      apb_bridge_scoreboard score_board;
      apb_bridge_agentpass pasiv_agent;
      apb_subscriber subscribe;
   

   function new(string name="apb_top_environ",uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
        active_agent =apb_bridge_agentact     ::type_id::create("active_agent",this); //agent is D/SEQR/M for write 
        pasiv_agent  =apb_bridge_agentpass    ::type_id::create("pasiv_agent",    this);  //agent is MONITOR for read 
        score_board  =apb_bridge_scoreboard   ::type_id::create("score_board",this);

        subscribe    =apb_subscriber        ::type_id::create("subscribe", this);	
   endfunction	

   function void connect_phase(uvm_phase phase);
	   active_agent.apb_moni_mst.item_collect_port.connect(score_board.apb_write_export);

	   pasiv_agent.apb_read.item_collect_readport.connect(score_board.apb_read_export);
           active_agent.apb_moni_mst.item_collect_port.connect(subscribe.analysis_export);
   endfunction 
	 
endclass
