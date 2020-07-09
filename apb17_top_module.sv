
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "0define_all.sv"
`include "apb15_interface.sv"
`include "apb16_slave_dut.sv"
`include "apb13_config.sv"
`include "apb1_bridge_sequence_item.sv"
`include "apb3_bridge_sequencer.sv"
`include "apb4_bridge_drive.sv"
`include "apb5_bridge_monitor.sv"
`include "apb7_bridge_monitor_read.sv"
`include "apb6_bridge_agent_active.sv"
`include "apb8_bridge_agent_passive.sv"
`include "apb9_bridge_scoreboard.sv"
`include "apb10_bridge_subscribe.sv"
`include "apb11_bridge_env.sv"
`include "apb2_bridge_sequence.sv"
`include "apb12_bridge_test.sv"

module top;

bit clock,reset;


apb_interface intf(.clk(clock),.reset(reset));

apb_slave dt(.clk(clock),.rst_n(reset),.paddr(intf.PADDR),.pwrite(intf.PWRITE),.psel(intf.PSEL),.penable(intf.PENABLE),.pwdata(intf.PWDATA),.prdata(intf.PRDATA),.pready(intf.PREADY));


initial forever #5 clock=!clock;

initial 
   begin
      #5 reset=1'b1;
   end

initial 
   begin	   
     uvm_config_db #(virtual apb_interface)::set(null,"*","vif",intf);
     run_test("base_test");
   end
endmodule



