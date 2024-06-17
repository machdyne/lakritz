// LAKRITZ BLINKY

module blinky
#(
)
(

	input CLK_48,

	output LED,

);

	reg [25:0] counter = 0;

   assign LED = ~counter[25];

   always @(posedge CLK_48) begin
      counter <= counter + 1;
   end

endmodule
