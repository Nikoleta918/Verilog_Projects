module PanelDisplay
    (
    input logic clk,             // the system clock
    input logic rst,             // the positive reset
	
	input logic[7:0] scancode,	 //	the 8-bit signal from the keyboard
	input logic valid,

    output logic hsync,          // horizontal sync for the monitor
    output logic vsync,          // vertical sync for the monitor
    output logic[3:0] red,       // shade of red for this quadrant
    output logic[3:0] green,     // shade of green for this quadrant
    output logic[3:0] blue      // shade of blue for this quadrant

   
    );
	
	 logic [10:0] count_h; // test outputs
     logic [9:0] count_v;

    localparam cols = 640;       // # visible pixels per line
    localparam rows = 480;       // # visible lines per frame
    localparam half_cols = 320;  // # visible pixels per line divided by 2
    localparam half_rows = 240;  // # visible lines per frame divided by 2
    localparam top_left = 80;    // # left top corner of the quadrant
    localparam top_right = 559;  // # right top corner of  the quadrant
    localparam hfp = 16;         // # pixels in Horizontal Front Porch
    localparam hsp = 96;         // # pixels in Horizontal Sync Pulse
    localparam hbp = 48;         // # pixels in Horizontal Back Porch
    localparam vfp = 11;         // # lines in Vertical Front Porch
    localparam vsp = 2;          // # lines in Vertical Sync Pulse
    localparam vbp = 31;         // # lines in Vertical Back Porch
    localparam hend = 799;       // # zero based index of last pixel in line (cols + hfp + hsp + hbp - 1)
    localparam vend = 523;       // # zero based index of last line in frame (rows + vfp + vsp + vbp - 1)


    // vga clock with half half the frequency of clock
    logic vga_clk;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            vga_clk <= 0 ; 
        end
        else begin
            vga_clk <= ~vga_clk;
        end
    end


    // horizontal and vertical pixel counters
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            count_h <= 0;
            count_v <= 0;
        end else begin
            if (vga_clk) begin
                if (count_h == hend) begin
                    count_v <= count_v + 1;
                    count_h <= 0;
                end else begin
                    count_h <= count_h + 1;
                end
                if ((count_v == vend) && (count_h == hend)) begin
                    count_v <= 0;
                    count_h <= 0;
                end
            end
        end
    end
	
	logic[7:0] keyPressed;
	
	always_ff @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			keyPressed<=8'b00000000;
		end
		else
		begin
			if( valid == 1 && (scancode == 8'b10000000 )) 
				keyPressed <= scancode;
			
			else if(valid == 1 && (scancode == 8'b10010000) )
				keyPressed<=scancode;
		end
	end
	
	always_ff @(posedge clk or negedge rst) begin 
		if (!rst) begin
			red <= 4'b1111;
			green <= 4'b1111;
			blue <= 4'b1111; 
		end else begin
		    if (vga_clk) begin
				if( (keyPressed== 8'b10000000 )) begin  // if f9 is pressed make the screen red
						if ( count_h <= cols && count_v <= rows ) begin 
							red <= 4'b1111;
							green <= 4'b0000;
							blue <= 4'b0000;
							
						end else begin 
							red <= 4'b0000;
							green <= 4'b0000;
							blue <= 4'b0000; end
				end else if ( (keyPressed== 8'b10010000 )) begin // if f9 is pressed make the screen green
						if ( count_h <= cols && count_v <= rows ) begin 
							red <= 4'b0000;
							green <= 4'b1111;
							blue <= 4'b0000;
						end else begin 
							red <= 4'b0000;
							green <= 4'b0000;
							blue <= 4'b0000; end
				end
	        end
		end				
	end


    // set the sync signals
    always_comb
    begin
        if (count_h > (cols + hfp) && count_h < (cols + hfp + hsp)) begin
            hsync = 0;
        end else begin
            hsync = 1;
        end

        if (count_v > (rows + vfp) && count_v < (rows + vfp + vsp)) begin
            vsync = 0;
        end else begin
            vsync = 1;
        end
    end
endmodule

