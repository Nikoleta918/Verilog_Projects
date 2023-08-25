module Keyboard (
                input logic kClock,
				input logic kData,
                input logic rst,
                input logic clk,
				output logic[7:0] scancode,
				output logic valid
                );

    // additional FFs for synchronization of keyboard and fpga clocks
    logic sync_k_clk_1;
    logic sync_k_clk_2;
    logic k_old_clk;

    // synchronization of clocks
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            sync_k_clk_1 <= 1'b0;
            sync_k_clk_2 <= 1'b0;
            k_old_clk <= 1'b0;
        end else begin
            sync_k_clk_1 <= kClock;
            sync_k_clk_2 <= sync_k_clk_1;
            k_old_clk <= sync_k_clk_2;
			
			
        end
    end
	
	
	// signals of rising and falling edge of k_clk
    logic kClock_falling_edge;
    logic kClock_rising_edge;

    always_comb begin
        kClock_falling_edge = (~sync_k_clk_2) & k_old_clk;
        kClock_rising_edge = sync_k_clk_2 & (~k_old_clk);
    end
	
	
	logic sync_k_data_1;
    logic sync_k_data_2;
	
	always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            sync_k_data_1 <= 1'b0;
            sync_k_data_2 <= 1'b0;
        end else begin
            sync_k_data_1 <= kData;
            sync_k_data_2 <= sync_k_data_1;
            		
        end
    end
	
	
	
	logic[3:0] counter; // counts the 11 bits of kData and starts counting when starting bit appears
	
	
	always_ff @(posedge clk or negedge rst) begin 
		if (!rst) begin	
			counter <= 0;
			valid <= 0;
		end else begin 
			if (kClock_rising_edge) begin
				if ( counter == 0 && sync_k_data_2 == 0 ) begin
					counter <= 1 ; 
				end else if ( counter >= 1 && counter < 11) begin 
					counter <= counter + 1 ; 
			    end else if ( counter == 11 ) begin
					counter <= 0; 
					valid <=1;
				end	
				
				
				if ( valid == 1 ) valid <=0; 
			end 
		end	
	end	
	

	
	always_ff @(posedge clk or negedge rst) begin 
		if (!rst) begin 
			scancode <= 8'b00000000;
		end else begin
			if (kClock_rising_edge) begin
				if (counter >= 1 && counter < 9 ) begin	
					scancode [7:1] <= scancode [6:0];
					scancode[0] <= sync_k_data_2;
				end	
			end 	
		end
	end
	
endmodule