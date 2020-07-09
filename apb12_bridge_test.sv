/* ::::::::::::::::description of test_class::::::::::
 
create the object for the configure_class and "GET" the interface
handle to configure_class interface.
And "SET" the config_class to config_database.  
:::::::::::::::::::::::::::::::::::::::::::::::::::::::*/


class base_test extends uvm_test;
   
   `uvm_component_utils(base_test)
   apb_top_environ env;
   apb_config con_t;

   apb_bridge_seq seq; //default seq
    function new(string name="base_test",uvm_component parent);
       super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
        con_t=apb_config::type_id::create("con_t",this);
	uvm_config_db #(virtual apb_interface)::get(this,"","vif",con_t.vif);
	uvm_config_db #(apb_config)::set(this,"*","confi",con_t);
        env=apb_top_environ::type_id::create("env",this);
        seq=apb_bridge_seq::type_id::create("seq",this);
    endfunction 

         
	   
    task run_phase(uvm_phase phase);
       phase.raise_objection(this);
       seq.start(env.active_agent.apb_seq);
       #19;
       phase.drop_objection(this);
    endtask

endclass 
