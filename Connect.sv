module Connect(

  input  logic rst,
  input  logic clk,

	input logic kClock, 
	input logic kData, 
	
	 output logic hsync,         
    output logic vsync,         
    output logic[3:0] red,      
    output logic[3:0] green,     
    output logic[3:0] blue    

    ) ;
	
     logic[7:0] scancode; 
	  logic valid; 	
	
	
	Keyboard
	kbrd_name
		(.clk (clk),
		.rst (rst),
		.kClock (kClock),
		.kData (kData),
		.scancode (scancode),
		.valid (valid));
		
	PanelDisplay
	panel_name
		(.clk (clk),
		.rst (rst),
		.scancode (scancode),
		.valid (valid),
		.hsync (hsync),
		.vsync (vsync),
		.red (red),
		.green (green),
		.blue (blue)
		);

endmodule		
			
	
	
	