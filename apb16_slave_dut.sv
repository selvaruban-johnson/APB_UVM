//slave 1.............. select line 1............................

module apb_slave
       ( input                           clk,
         input                           rst_n,
         input        [`ADDR_WIDTH-1:0]  paddr,
         input                           pwrite,
         input                           penable,
         input        [`DATA_WIDTH-1:0]  pwdata,
         input        [`SEL-1:0]         psel, 
         input        [`STR-1:0]         pstrobe,
	 
         output logic [`DATA_WIDTH-1:0]  prdata,
	 output logic                    pready
       );

logic [31:0] mem [256];
logic [1:0] apb_st;

logic [31:0] pwdata_temp;

const logic [1:0] SETUP = 0;
const logic [1:0] W_ENABLE = 1;
const logic [1:0] R_ENABLE = 2;
 


// SETUP -> ENABLE
always @(negedge rst_n or posedge clk)
  begin
    if (rst_n == 0)
      begin
        apb_st <= 0;
        prdata <= 0;
	pready <= 1;
      end

  else 
    begin
       case (apb_st)
       SETUP : begin
                 prdata <= 0;// clear the prdata 
                     if (psel[0] && !penable)
		        begin
                          if (pwrite) 
			    begin
			       pwdata_temp<=pwdata;

                                if(pstrobe[0]==0)
                                pwdata_temp[7:0]<=8'b0;

                                if(pstrobe[1]==0)
                                pwdata_temp[15:8]<=8'b0;

                                if(pstrobe[2]==0)
                                pwdata_temp[23:16]<=8'b0;

                                if(pstrobe[3]==0)
                                pwdata_temp[31:24]<=8'b0;

                              apb_st <= W_ENABLE;
                            end
			 else 
			    begin
                              apb_st <= R_ENABLE;
                            end
                        end
               end

      W_ENABLE : begin
                    if (psel[0] && penable && pwrite)  // write pwdata to memory 
	               begin	       
                          mem[paddr] <= {pwdata_temp[31:24],pwdata_temp[23:16],pwdata_temp[15:8],pwdata_temp[7:0]};
                      end
                          apb_st <= SETUP;
                 end

      R_ENABLE : begin
                    if (psel[0] && penable && !pwrite) 
		       begin
                          prdata <= mem[paddr];
                       end 
                          apb_st <= SETUP; // return to SETUP
                   end                      
      endcase
   end
end 

endmodule

