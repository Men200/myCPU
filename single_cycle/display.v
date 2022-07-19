`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/05 22:19:59
// Design Name: 
// Module Name: display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module display(
    input  wire [3:0] num,
    output reg        led_ca,
	output reg        led_cb,
    output reg        led_cc,
	output reg        led_cd,
	output reg        led_ce,
	output reg        led_cf,
	output reg        led_cg,
	output wire       led_dp 
    );
    
reg[6:0] led;
always @(*) begin
    case(num)
        'd0: led = 7'b000000_1;
        'd1: led = 7'b100111_1;
        'd2: led = 7'b001001_0;
        'd3: led = 7'b000011_0;
        'd4: led = 7'b100110_0;
        'd5: led = 7'b010010_0;
        'd6: led = 7'b010000_0;
        'd7: led = 7'b000111_1;
        'd8: led = 7'b000000_0;
        'd9: led = 7'b000110_0;
        'd10:led = 7'b000100_0;
        'd11:led = 7'b110000_0;
        'd12:led = 7'b111001_0;
        'd13:led = 7'b100001_0;
        'd14:led = 7'b011000_0;
        'd15:led = 7'b011100_0;
    endcase
end

always @(*) begin
    led_ca = led[6];
    led_cb = led[5];
    led_cc = led[4];
    led_cd = led[3];
    led_ce = led[2];
    led_cf = led[1];
    led_cg = led[0];
end
assign led_dp  = 1;

endmodule
