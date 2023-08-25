module Panel_Display_lab (
input logic clk,
input logic rst,
output logic hsync,
output logic vsync,
output logic [3:0] red,
output logic [3:0] green,
output logic [3:0] blue,
input logic [3:0] address,
output logic [31:0] data
);

logic[9:0] column;
logic[9:0] row;
logic clk2;
 
 always_comb
 begin
   case(address)
     4'b0000 : data = 32'b01010101010101010101010101010101;
     4'b0001 : data = 32'b11010101010101010101010101010101;
     4'b0011 : data = 32'b01010101010101010101010101010101;
     4'b0100 : data = 32'b01010101010100010101010101010101;
     4'b0101 : data = 32'b01010000000000010101000101010101;
     4'b0110 : data = 32'b00000000000100010101000101010101;
     4'b0111 : data = 32'b10010101010100010101010101010101;
     4'b1000 : data = 32'b01010101010100010101000101010101;
     4'b1001 : data = 32'b01010101010100010000000101010101;
     4'b1010 : data = 32'b01010101010100010101000101010110;
     4'b1011 : data = 32'b01010101010100010101000000000000;
     default : data = 32'b01010101010100010101010101010101;
   endcase
 end
 
 
 


always_ff @ (posedge clk, negedge rst )
begin
  if(!rst) clk2 <= 0;
  else     clk2 <= !clk2;
end



always_ff @ (posedge clk2 or negedge rst)
begin
	if (!rst)
	  begin 
	    red <= 0;
	    blue <= 0; 
	    green <= 0;
	end
       else begin
            vsync <= 1;
            hsync <= 1;








            if (( column >= 0 && column <= 39) && (row >=  0 && row <= 39))
            begin
              red <= 15;
              green <= 15; //white (1)
              blue <= 15;
            end
            else
            if (( column >= 0 && column <= 119) && (row  >= 39 && row <= 639))
            begin
              red <= 15;
              green <= 15; //white (2)
              blue <= 15;
            end
            else
            if (( column >= 79 && column <= 119) && (row  >= 0 && row <= 39))
            begin
              red <= 15;
              green <= 15; //white (3)
              blue <= 15;
            end
            else
            if (( column >= 119 && column <= 199) && (row  >= 0 && row <= 79))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; //white (4)
            end
            else
            if (( column  >= 119 && column <= 159) && (row  >= 79 && row <= 239))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; // white (5)
            end
            else
            if (( column  >= 119 && column <= 319) && (row  >= 279 && row <= 399))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; //white (6)
            end
            else
            if (( column  >= 119 && column <= 399) && (row  >= 439 && row <= 599))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; //white (7)
            end
            else
            if (( column  >= 119 && column <= 359) && (row  >= 599 && row <= 639))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; //white (8)
            end
            else
            if (( column  >= 119 && column <= 159) && (row  >= 399 && row <= 439))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; //white (9)
            end
            else
            if (( column  >= 199 && column <= 239) && (row  >= 199 && row <= 239))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; //white (10)
            end
            else
            if (( column  >= 239 && column <= 479) && (row  >= 39 && row <= 239))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; // white(11)
            end
            else
            if (( column  >= 279 && column <= 479) && (row  >= 0 && row <= 39))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; //white(12)
            end
            else
            if (( column  >= 359 && column <= 479) && (row  >= 279 && row <= 399))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; // white (13)
            end
            else
            if (( column  >= 319 && column <= 359) && (row  >= 279 && row <= 319))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; // white(14)
            end
            else
            if (( column  >= 439 && column <= 479) && (row  >= 399 && row <= 639))
            begin 
               red <= 15;
               green <= 15;
	             blue <= 15; // white(15)
            end
            else
            if (( column  >= 39 && column <= 79) && (row  >= 0 && row <= 39))
            begin 
               red <= 15;
               green <= 0;
	             blue <= 0; // paikths kokkino xrwma
            end
            else
            if (( column  >= 239 && column <= 279) && (row  >= 0 && row <= 39))
            begin 
               red <= 0;
               green <= 15;
	             blue <= 0;  // eisodos prasino xrwma
            end
            else
            if (( column  >= 359 && column <= 399) && (row  >= 599 && row <= 639))
            begin 
               red <=  0;
               green <= 15;
	             blue <= 0; // exodos prasino xrwma
            end
            //ftiaxnw to laburintho ble xrwma
            else
            if (( column  >= 199 && column <= 239) && (row  >= 0 && row <= 39))
            begin 
               red <= 0;
               green <= 0;
	             blue <= 15; //(1)
            end
            else
            if (( column  >= 79 && column <= 239) && (row  >= 159 && row <= 199))
            begin 
               red <= 0;
               green <= 0;
	             blue <= 15; //(2)
            end
            else
            if (( column  >= 119 && column <= 479) && (row  >= 239 && row <= 279))
            begin 
               red <= 0;
               green <= 0;
	             blue <= 15; //(3)
            end
            else
            if (( column  >= 319 && column <= 399) && (row  >= 319 && row <= 359))
            begin 
               red <= 0;
               green <= 0;
	             blue <= 15;
            end //(4)
            else
            if (( column  >= 159 && column <= 439) && (row  >= 399 && row <= 439))
            begin 
               red <= 0;
               green <= 0;
	             blue <= 15; //(5)
            end
            else
            if (( column  >= 399 && column <= 439) && (row  >= 439 && row <= 639))
            begin 
               red <= 0;
               green <= 0;
	             blue <= 15; //(6)
            end
            





  
            
           if (row >= 639)
           begin
             red <= 0;
             green <= 0;
             blue <= 0;
              if (row >= 656 && row <= 751)
              begin
                hsync <= 0;
              end
           end
           
           
           if (column >= 479)
           begin  
             red <= 0;
             green <= 0;
             blue <= 0;
             if (column >= 491 && column <= 492)
             begin
               vsync <= 0;
             end
           end   
           
          
           row <= row + 1;
           
           if (row == 799)
           begin
             row <= 0;
             column <= column + 1;
           end
           if(column == 523)
           begin
             column <= 0;
           end
         end
         
         
end

endmodule

