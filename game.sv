module game(
    input logic clk,
    input logic rst,
    output logic hsync,
    output logic vsync,
    output logic[3:0] red,
    output logic[3:0] green,
    output logic[3:0] blue,
	input logic kData,
	input logic kClock,
	output logic [7:0] led
);
	logic [4:0] keybord_counter;
//rom
	logic [2:0] flag;
	logic [3:0] address;
	logic [31:0] data;
	logic [11:0][31:0] start_lab;
	logic [3:0] player_row;
	logic [4:0] player_colunms;   
	//logic [2:0] simea;
	logic miso_clock;

	logic clockA,clockB,clockC;
	logic dataA,dataB,dataC;
	//logic [4:0] key_valid;

	logic [9:0] x;
	logic [9:0] y;

	logic [4:0] bit_counter;
	logic [10:0] key_buf;

	logic key_up,key_down,key_left,key_right;
	logic move_down,move_left,move_right,move_up;
	logic [1:0] cell_bot, cell_left, cell_right, cell_top;
//assign led[7:0] = key_buf[9:2];  
	assign led[0]= flag[0];  
	assign led[1]= flag[1];
	assign led[2]= flag[2]; 
	assign led[3]= move_down;
	assign led[4]= move_left;
	assign led[5]= move_right;
	assign led[6]= move_up;
	assign led[7]= key_buf[8];

	assign cell_top   =  (player_row == 4'b0000) ? 2'b00:start_lab[player_row-1][player_colunms  -:2];//an to player_row einai 0000 tote cell_top=00 allios start_lab[player_row-1][player_colunms  -:2]
	assign cell_bot   =  (player_row == 4'b1011) ? 2'b00:start_lab[player_row+1][player_colunms  -:2];
	assign cell_right =  (player_colunms ==1)    ? 2'b00:start_lab[player_row]  [player_colunms-2-:2];
	assign cell_left  =  (player_colunms ==31)   ? 2'b00:start_lab[player_row]  [player_colunms+2-:2];

	assign key_up    = (key_buf[8:1] ==8'h1d);// w button
	assign key_down  = (key_buf[8:1] ==8'h1b);//s button
	assign key_right = (key_buf[8:1] ==8'h23);//d button
	assign key_left  = (key_buf[8:1] ==8'h1c);//a button

	assign move_up    = key_up    & (cell_top!=2'b00);// 00=wall
	assign move_down  = key_down  & (cell_bot!=2'b00); 
	assign move_right = key_right & (cell_right!=2'b00); 
	assign move_left  = key_left  & (cell_left!=2'b00);   
		
	logic [1:0] valid_counter;
	logic key_valid;
	assign key_valid = (keybord_counter==5'b01010) & (rising_edge==1);
	
	always_ff @ (posedge clk or negedge rst)
		begin
			if (rst==0)
			begin
				valid_counter <= 0;
			end
			else if (key_valid && valid_counter <2) begin
			valid_counter <= valid_counter+1;
			end
			else if(valid_counter== 2'b10 && key_valid) valid_counter <=0;
		end
		
		
	always_ff @(posedge clk or negedge rst) 
		begin
			if (rst==0) begin
				player_colunms <= 31; 
				player_row     <= 0;
				flag <= 3'b101;
				end
			else begin
				if (valid_counter == 2'b00 & key_valid == 1)
					begin
						if  (move_up==1) begin 
							player_row <= player_row - 4'b0001;
							flag <= 3'b000;
							end
						else if (move_down==1)  begin
							player_row <= player_row + 4'b0001;
							flag <= 3'b001; 
							end
						else if (move_right==1)  begin
							player_colunms <= player_colunms-2;
							flag <= 3'b010;
							end
						else if (move_left==1) begin
							player_colunms <= player_colunms+2;
							flag <= 3'b011;
							end
						else if ((~move_up) && (~move_down) && (~move_right) && (~move_left)) begin
							flag <= 3'b111;
						end	
					end	
			end
		end
	
//ARXIKOPΙISI LABIRINTHOU KAI ELENXOS FLAG
  always_ff @(posedge clk or negedge rst) begin
    if (rst==0)
      begin
        start_lab [0][31:0] <=32'b11_00_01_01_01_01_00_01_01_01_01_01_01_00_00_01;
        start_lab [1][31:0] <=32'b01_00_01_01_00_00_00_01_01_01_00_00_00_00_00_00; 
        start_lab [2][31:0] <=32'b01_00_01_01_01_01_00_01_01_01_00_01_01_01_01_10;
        start_lab [3][31:0] <=32'b01_00_01_01_01_01_00_01_00_00_00_01_01_00_01_01;
        start_lab [4][31:0] <=32'b01_01_01_01_01_01_00_01_01_01_00_01_01_00_01_01;
        start_lab [5][31:0] <=32'b01_01_01_01_01_01_00_01_01_01_00_01_01_00_01_01;
        start_lab [6][31:0] <=32'b00_00_00_00_01_01_00_01_01_01_00_01_01_00_00_00;
        start_lab [7][31:0] <=32'b01_01_01_01_01_01_00_01_01_01_00_01_01_00_01_01;
        start_lab [8][31:0] <=32'b01_01_01_01_01_01_00_01_01_01_01_01_01_00_01_01;
        start_lab [9][31:0] <=32'b01_01_00_00_00_00_00_01_01_01_01_01_01_00_01_01;
        start_lab [10][31:0] <=32'b01_01_01_01_01_01_00_01_00_00_00_00_00_00_00_01;
        start_lab [11][31:0] <=32'b01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01;
		end
    else
      case (flag)
        3'b000 : begin        
             start_lab [player_row+1][player_colunms-:2] <= 2'b01 ;//proigoumeni thesi   pano
             start_lab [player_row][player_colunms -:2] <= 2'b11;//epomeni thesi pekti
            end
        3'b001 :  begin
             start_lab [player_row-1][player_colunms-:2] <= 2'b01 ;//proigoummeni thhesi kato
             start_lab [player_row][player_colunms -:2]<= 2'b11;//epomeni thesi pekti
            end 
        3'b010 : begin 
              start_lab [player_row][player_colunms+2-:2] <= 2'b01 ;//proigoumeni thesi  deksia
             start_lab [player_row][player_colunms -:2] <= 2'b11;//epomeni thesi pekti
            end 
        3'b011 : begin 
              start_lab [player_row][player_colunms-2-:2] <= 2'b01 ;//proigoumeni thesi  aristera
              start_lab [player_row][player_colunms -:2] <= 2'b11;//epomeni thesi pekti
            end 
      endcase
  end
  
  assign data = start_lab[address];

//vga clock
    
    always_ff @(posedge clk or negedge rst) begin
        if (rst==0) begin
            miso_clock <= 0 ; 
        end
        else begin
            miso_clock <= ~miso_clock;
        end
    end 

//KEYBOΑRD

//sinxronismos
  always_ff @(posedge clk)  
    begin
      clockA<=kClock;
      clockB<=clockA;
      clockC<=clockB;
    end

  assign falling_edge=(~clockB && clockC);
  assign rising_edge=(clockB && ~clockC);

  always_ff @(posedge clk)  
    begin
      dataA<=kData;
      dataB<=dataA;
      dataC<=dataA;
    end
//ekxorisi timmis
//logic[8:0] bit_vec;

  always_ff @(posedge clk)
    begin 
      if (rst==0) 
        begin 
			key_buf [10:0]  <= 11'b00000000000;
			keybord_counter <= 0;
        end 
      else begin
			if	(rising_edge)
				begin
					if	(keybord_counter<10) 
						begin
							  if((keybord_counter ==0 && (~dataC)) || (keybord_counter>0))
							  begin
						 
								 key_buf[keybord_counter]<=dataC;
								 keybord_counter<=keybord_counter+1;
							 end
						end	 
					else
					begin
						keybord_counter <= 0;
						key_buf[keybord_counter]<=dataC;
					end
					
				end
			end
    end
	
	// XROMATA LABIRINTHOU
    always_comb
    begin
        if (x < 640 && y < 480) begin
            if (data[bit_counter-1+:2] == 2'b00) begin//perni tin timi(data) tou bit_counter -1 + 2 pros ta mprosta --> sta msb
                red = 4'b0000;
                green = 4'b0000;
                blue = 4'b0000;
            end else if (data[bit_counter-1+:2] == 2'b01) begin
                red = 4'b1111;
                green = 4'b1111;
                blue = 4'b1111;
            end else if (data[bit_counter-1+:2] == 2'b10) begin
                red = 4'b1111;
                green = 4'b0000;
                blue = 4'b0000;
            end else begin
                red = 4'b0000;
                green = 4'b0000;
                blue = 4'b1111;
            end
        end else begin
            red = 4'b0000;
            green = 4'b0000;
            blue = 4'b0000;
        end
    end
 
	 // metrisi ton pixel
    always_ff @(posedge clk or negedge rst) begin
        if (rst==0) begin
            x <= 0;
            y <= 0;
        end else begin
            if (miso_clock) begin
                if (x == 799) begin
                    y <= y + 1;
                    x <= 0;
                end else begin
                    x <= x + 1;
                end
                if ((y == 523) && (x == 799)) begin
                    x <= 0;
                    y <= 0;
                end
            end
        end
    end

  assign hsync = (x>=656 && x<752) ? 0:1;
  assign vsync = (y>=491 && y<493) ? 0:1;

  assign address = y / 40;//kathe fora pou kateveni 40 pixel katheta allazi address
 
   
    always_ff @(posedge clk or negedge rst) begin
        if (rst==0) begin
            bit_counter <= 31;
        end else begin
            if (miso_clock) begin
                if (x == 0 || x == 799) begin
                    bit_counter <= 31;
                end else if (x % 40 == 0) begin
                    bit_counter <= bit_counter - 2;
                end
            end
        end
    end
 
 	
endmodule