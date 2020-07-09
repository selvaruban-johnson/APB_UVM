interface apb_interface(input clk,reset);
   
   //master_side.......
   logic [`ADDR_WIDTH-1:0] PADDR;
   logic [`DATA_WIDTH-1:0] PWDATA;
   logic [`SEL-1:0]        PSEL;
   logic                   PWRITE;
   logic                   PENABLE;
   logic [`STR-1:0]        PSTROBE;

   //slave_side.....
   logic [`DATA_WIDTH-1:0] PRDATA;
   logic                   PREADY;
    	 

endinterface

// declare all the protocol signals
