// PCS Core for 8b/10b ecoding decoding
module pcs_8b_10b (
        input  logic       clk,
        input  logic       reset,
        input  logic       tx_rd_in,
        input  logic       tx_char_val,
        input  logic [7:0] tx_data_in,
        output logic [9:0] tx_data_out,
        input  logic       rx_rd_in,
        output logic       rx_char_val,
        input  logic [9:0] rx_data_in,
        output logic [7:0] rx_data_out
);

enc_8b10b enc_8b10b_inst (
        .clk      ( clk         ) ,
        .reset    ( reset       ) ,
        .rd_in    ( tx_rd_in    ) ,
        .char_val ( tx_char_val ) ,
        .data_in  ( tx_data_in  ) ,
        .data_out ( tx_data_out ) 
);

dec_8b10b dec_8b10b_inst (
        .clk      ( clk         ) ,
        .reset    ( reset       ) ,
        .rd_in    ( rx_rd_in    ) ,
        .char_val ( rx_char_val ) ,
        .data_in  ( rx_data_in  ) ,
        .data_out ( rx_data_out ) 
);

endmodule

// 8b/10b Decoder Module
module dec_8b10b (
        input  logic clk,
        input  logic reset,
        input  logic rd_in,
        input  logic [9:0] data_in,
        output logic char_val,
        output logic [7:0] data_out
);

typedef struct {
        logic [4:0] enc_5b_6b;
        logic [2:0] enc_3b_4b;
        logic [7:0] data;
        logic       char;
} struct_8b_10b;

struct_8b_10b data_8b_10b;
struct_8b_10b comb_8b_10b;

logic [9:0] data_int_p;
logic [9:0] data_int_n;
logic [9:0] data_int_r;

assign data_int_p = rd_in ? ~data_in :  data_in;
assign data_int_n = rd_in ?  data_in : ~data_in;

always_ff @( posedge clk ) begin
        if (comb_8b_10b.char) begin
                data_int_r <= data_int_n;
        end else begin
                data_int_r <= data_int_p;
        end
end

always_ff @( posedge clk ) begin
        data_8b_10b <= comb_8b_10b;
end

always_ff @( posedge clk ) begin
        if (data_8b_10b.char) begin
                data_out <= data_8b_10b.data;
        end else begin
                data_out <= {data_8b_10b.enc_3b_4b,data_8b_10b.enc_5b_6b};
        end
        char_val <= data_8b_10b.char;
end

//assign data_out = {data_8b_10b.enc_3b_4b,data_8b_10b.enc_5b_6b};
//assign char_val = data_8b_10b.char;

// 5b/6b code
always_comb begin
        case(data_int_r[9:4])
                6'b100111,6'b011000 : begin comb_8b_10b.enc_5b_6b = 5'd00; end
                6'b011101,6'b100010 : begin comb_8b_10b.enc_5b_6b = 5'd01; end
                6'b101101,6'b010010 : begin comb_8b_10b.enc_5b_6b = 5'd02; end
                6'b110001           : begin comb_8b_10b.enc_5b_6b = 5'd03; end
                6'b110101,6'b001010 : begin comb_8b_10b.enc_5b_6b = 5'd04; end
                6'b101001           : begin comb_8b_10b.enc_5b_6b = 5'd05; end
                6'b011001           : begin comb_8b_10b.enc_5b_6b = 5'd06; end
                6'b111000,6'b000111 : begin comb_8b_10b.enc_5b_6b = 5'd07; end
                6'b111001,6'b000110 : begin comb_8b_10b.enc_5b_6b = 5'd08; end
                6'b100101           : begin comb_8b_10b.enc_5b_6b = 5'd09; end
                6'b010101           : begin comb_8b_10b.enc_5b_6b = 5'd10; end
                6'b110100           : begin comb_8b_10b.enc_5b_6b = 5'd11; end
                6'b001101           : begin comb_8b_10b.enc_5b_6b = 5'd12; end
                6'b101100           : begin comb_8b_10b.enc_5b_6b = 5'd13; end
                6'b011100           : begin comb_8b_10b.enc_5b_6b = 5'd14; end
                6'b010111,6'b101000 : begin comb_8b_10b.enc_5b_6b = 5'd15; end
                6'b011011,6'b100100 : begin comb_8b_10b.enc_5b_6b = 5'd16; end
                6'b100011           : begin comb_8b_10b.enc_5b_6b = 5'd17; end
                6'b010011           : begin comb_8b_10b.enc_5b_6b = 5'd18; end
                6'b110010           : begin comb_8b_10b.enc_5b_6b = 5'd19; end
                6'b001011           : begin comb_8b_10b.enc_5b_6b = 5'd20; end
                6'b101010           : begin comb_8b_10b.enc_5b_6b = 5'd21; end
                6'b011010           : begin comb_8b_10b.enc_5b_6b = 5'd22; end
                6'b111010,6'b000101 : begin comb_8b_10b.enc_5b_6b = 5'd23; end
                6'b110011,6'b001100 : begin comb_8b_10b.enc_5b_6b = 5'd24; end
                6'b100110           : begin comb_8b_10b.enc_5b_6b = 5'd25; end
                6'b010110           : begin comb_8b_10b.enc_5b_6b = 5'd26; end
                6'b110110,6'b001001 : begin comb_8b_10b.enc_5b_6b = 5'd27; end
                6'b001110           : begin comb_8b_10b.enc_5b_6b = 5'd28; end
                6'b101110,6'b010001 : begin comb_8b_10b.enc_5b_6b = 5'd29; end
                6'b011110,6'b100001 : begin comb_8b_10b.enc_5b_6b = 5'd30; end
                6'b101011,6'b010100 : begin comb_8b_10b.enc_5b_6b = 5'd31; end
                default             : begin comb_8b_10b.enc_5b_6b = 5'hxx; end
        endcase
end

// 3b/4b code
always_comb begin
        case(data_int_r[3:0])
                4'b1011,4'b0100 : begin comb_8b_10b.enc_3b_4b = 3'd0; end
                4'b1001         : begin comb_8b_10b.enc_3b_4b = 3'd1; end
                4'b0101         : begin comb_8b_10b.enc_3b_4b = 3'd2; end
                4'b1100,4'b0011 : begin comb_8b_10b.enc_3b_4b = 3'd3; end
                4'b1101,4'b0010 : begin comb_8b_10b.enc_3b_4b = 3'd4; end
                4'b1010         : begin comb_8b_10b.enc_3b_4b = 3'd5; end
                4'b0110         : begin comb_8b_10b.enc_3b_4b = 3'd6; end
                4'b1110,4'b0001 : begin comb_8b_10b.enc_3b_4b = 3'd7; end
                default         : begin comb_8b_10b.enc_3b_4b = 3'hx; end
        endcase
end

// control charecter
always_comb begin
        case(data_int_p)
                10'b001111_0100 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'h1C; end// 1C K.28.0 	
                10'b001111_1001 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'h3C; end// 3C K.28.1 \u2020 
                10'b001111_0101 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'h5C; end// 5C K.28.2   
                10'b001111_0011 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'h7C; end// 7C K.28.3  	
                10'b001111_0010 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'h9C; end// 9C K.28.4  	
                10'b001111_1010 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'hBC; end// BC K.28.5 \u2020 
                10'b001111_0110 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'hDC; end// DC K.28.6  	
                10'b001111_1000 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'hFC; end// FC K.28.7 \u2021 
                10'b111010_1000 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'hF7; end// F7 K.23.7  	
                10'b110110_1000 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'hFB; end// FB K.27.7  	
                10'b101110_1000 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'hFD; end// FD K.29.7  	
                10'b011110_1000 : begin comb_8b_10b.char = 1; comb_8b_10b.data = 8'hFE; end// FE K.30.7  	
                default         : begin comb_8b_10b.char = 0; comb_8b_10b.data = 8'hxx; end
        endcase
end

endmodule

// 8b/10b Encoder module
module enc_8b10b (
        input  logic clk,
        input  logic reset,
        input  logic rd_in,
        input  logic char_val,
        input  logic [7:0] data_in,
        output logic [9:0] data_out
);

typedef struct {
        logic [5:0] enc_5b_6b;
        logic [3:0] enc_3b_4b;
        logic       mux_5b_6b;
        logic       mux_3b_4b;
} struct_8b_10b;

struct_8b_10b data_8b_10b_0,data_8b_10b_1;
struct_8b_10b comb_8b_10b_0,comb_8b_10b_1;

logic [9:0] control_char;
logic [9:0] control_char_r;

always_ff @( posedge clk ) begin
        data_8b_10b_0.enc_5b_6b <= rd_in && comb_8b_10b_0.mux_5b_6b ?  ~comb_8b_10b_0.enc_5b_6b : comb_8b_10b_0.enc_5b_6b;
        data_8b_10b_1.enc_5b_6b <= rd_in && comb_8b_10b_1.mux_5b_6b ?  ~comb_8b_10b_1.enc_5b_6b : comb_8b_10b_1.enc_5b_6b;
        data_8b_10b_0.enc_3b_4b <= rd_in && comb_8b_10b_0.mux_3b_4b ?  ~comb_8b_10b_0.enc_3b_4b : comb_8b_10b_0.enc_3b_4b;
        data_8b_10b_1.enc_3b_4b <= rd_in && comb_8b_10b_1.mux_3b_4b ?  ~comb_8b_10b_1.enc_3b_4b : comb_8b_10b_1.enc_3b_4b;
        data_8b_10b_0.mux_5b_6b <= comb_8b_10b_0.mux_5b_6b;
        data_8b_10b_1.mux_5b_6b <= comb_8b_10b_1.mux_5b_6b;
        data_8b_10b_0.mux_3b_4b <= comb_8b_10b_0.mux_3b_4b;
        data_8b_10b_1.mux_3b_4b <= comb_8b_10b_1.mux_3b_4b;
end

// mux select for 10b encoded data
always_ff @( posedge clk ) begin
        if (char_val) begin
                data_out <= control_char_r;
        end else begin
                case ({data_in[7],data_in[4]})
                        2'd0 : data_out <= {data_8b_10b_0.enc_5b_6b,data_8b_10b_0.enc_3b_4b};
                        2'd1 : data_out <= {data_8b_10b_1.enc_5b_6b,data_8b_10b_0.enc_3b_4b};
                        2'd2 : data_out <= {data_8b_10b_0.enc_5b_6b,data_8b_10b_1.enc_3b_4b};
                        2'd3 : data_out <= {data_8b_10b_1.enc_5b_6b,data_8b_10b_1.enc_3b_4b};
                endcase
        end
end

always_ff @( posedge clk ) begin
        control_char_r <= rd_in ? ~control_char : control_char;
end

// control charecter
always_comb begin
        case(data_in)
                8'h1C   : begin control_char = 10'b001111_0100; end //  K.28.0 	
                8'h3C   : begin control_char = 10'b001111_1001; end //  K.28.1 \u2020 
                8'h5C   : begin control_char = 10'b001111_0101; end //  K.28.2   
                8'h7C   : begin control_char = 10'b001111_0011; end //  K.28.3  	
                8'h9C   : begin control_char = 10'b001111_0010; end //  K.28.4  	
                8'hBC   : begin control_char = 10'b001111_1010; end //  K.28.5 \u2020 
                8'hDC   : begin control_char = 10'b001111_0110; end //  K.28.6  	
                8'hFC   : begin control_char = 10'b001111_1000; end //  K.28.7 \u2021 
                8'hF7   : begin control_char = 10'b111010_1000; end //  K.23.7  	
                8'hFB   : begin control_char = 10'b110110_1000; end //  K.27.7  	
                8'hFD   : begin control_char = 10'b101110_1000; end //  K.29.7  	
                8'hFE   : begin control_char = 10'b011110_1000; end //  K.30.7  	
                default : begin control_char = 10'bxxxxxx_xxxx; /*$display ("Unsupported charecter K.%h",data_in);*/ end
        endcase
end

// 5b/6b code
always_comb begin
        case(data_in[3:0])
                4'd00   : begin comb_8b_10b_0.enc_5b_6b = 6'b100111; comb_8b_10b_0.mux_5b_6b = 1'b1; end
                4'd01   : begin comb_8b_10b_0.enc_5b_6b = 6'b011101; comb_8b_10b_0.mux_5b_6b = 1'b1; end
                4'd02   : begin comb_8b_10b_0.enc_5b_6b = 6'b101101; comb_8b_10b_0.mux_5b_6b = 1'b1; end
                4'd03   : begin comb_8b_10b_0.enc_5b_6b = 6'b110001; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd04   : begin comb_8b_10b_0.enc_5b_6b = 6'b110101; comb_8b_10b_0.mux_5b_6b = 1'b1; end
                4'd05   : begin comb_8b_10b_0.enc_5b_6b = 6'b101001; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd06   : begin comb_8b_10b_0.enc_5b_6b = 6'b011001; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd07   : begin comb_8b_10b_0.enc_5b_6b = 6'b111000; comb_8b_10b_0.mux_5b_6b = 1'b1; end
                4'd08   : begin comb_8b_10b_0.enc_5b_6b = 6'b111001; comb_8b_10b_0.mux_5b_6b = 1'b1; end
                4'd09   : begin comb_8b_10b_0.enc_5b_6b = 6'b100101; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd10   : begin comb_8b_10b_0.enc_5b_6b = 6'b010101; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd11   : begin comb_8b_10b_0.enc_5b_6b = 6'b110100; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd12   : begin comb_8b_10b_0.enc_5b_6b = 6'b001101; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd13   : begin comb_8b_10b_0.enc_5b_6b = 6'b101100; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd14   : begin comb_8b_10b_0.enc_5b_6b = 6'b011100; comb_8b_10b_0.mux_5b_6b = 1'b0; end
                4'd15   : begin comb_8b_10b_0.enc_5b_6b = 6'b010111; comb_8b_10b_0.mux_5b_6b = 1'b1; end
                default : begin comb_8b_10b_0.enc_5b_6b = 6'b100111; comb_8b_10b_0.mux_5b_6b = 1'b1; end
        endcase
end

// 5b/6b code
always_comb begin
        case(data_in[3:0])
                4'd00   : begin comb_8b_10b_1.enc_5b_6b = 6'b011011; comb_8b_10b_1.mux_5b_6b = 1'b1; end
                4'd01   : begin comb_8b_10b_1.enc_5b_6b = 6'b100011; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd02   : begin comb_8b_10b_1.enc_5b_6b = 6'b010011; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd03   : begin comb_8b_10b_1.enc_5b_6b = 6'b110010; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd04   : begin comb_8b_10b_1.enc_5b_6b = 6'b001011; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd05   : begin comb_8b_10b_1.enc_5b_6b = 6'b101010; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd06   : begin comb_8b_10b_1.enc_5b_6b = 6'b011010; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd07   : begin comb_8b_10b_1.enc_5b_6b = 6'b111010; comb_8b_10b_1.mux_5b_6b = 1'b1; end
                4'd08   : begin comb_8b_10b_1.enc_5b_6b = 6'b110011; comb_8b_10b_1.mux_5b_6b = 1'b1; end
                4'd09   : begin comb_8b_10b_1.enc_5b_6b = 6'b100110; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd10   : begin comb_8b_10b_1.enc_5b_6b = 6'b010110; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd11   : begin comb_8b_10b_1.enc_5b_6b = 6'b110110; comb_8b_10b_1.mux_5b_6b = 1'b1; end
                4'd12   : begin comb_8b_10b_1.enc_5b_6b = 6'b001110; comb_8b_10b_1.mux_5b_6b = 1'b0; end
                4'd13   : begin comb_8b_10b_1.enc_5b_6b = 6'b101110; comb_8b_10b_1.mux_5b_6b = 1'b1; end
                4'd14   : begin comb_8b_10b_1.enc_5b_6b = 6'b011110; comb_8b_10b_1.mux_5b_6b = 1'b1; end
                4'd15   : begin comb_8b_10b_1.enc_5b_6b = 6'b101011; comb_8b_10b_1.mux_5b_6b = 1'b1; end
                default : begin comb_8b_10b_1.enc_5b_6b = 6'b011011; comb_8b_10b_1.mux_5b_6b = 1'b1; end
        endcase
end

// 3b/4b code
always_comb begin
        case(data_in[6:5])
                2'd00   : begin comb_8b_10b_0.enc_3b_4b = 4'b1011; comb_8b_10b_0.mux_3b_4b = 1'b1; end
                2'd01   : begin comb_8b_10b_0.enc_3b_4b = 4'b1001; comb_8b_10b_0.mux_3b_4b = 1'b0; end
                2'd02   : begin comb_8b_10b_0.enc_3b_4b = 4'b0101; comb_8b_10b_0.mux_3b_4b = 1'b0; end
                2'd03   : begin comb_8b_10b_0.enc_3b_4b = 4'b1100; comb_8b_10b_0.mux_3b_4b = 1'b1; end
                default : begin comb_8b_10b_0.enc_3b_4b = 4'b1011; comb_8b_10b_0.mux_3b_4b = 1'b1; end
        endcase
end

// 3b/4b code
always_comb begin
        case(data_in[6:5])
                2'd00   : begin comb_8b_10b_1.enc_3b_4b = 4'b1101; comb_8b_10b_1.mux_3b_4b = 1'b1; end
                2'd01   : begin comb_8b_10b_1.enc_3b_4b = 4'b1010; comb_8b_10b_1.mux_3b_4b = 1'b0; end
                2'd02   : begin comb_8b_10b_1.enc_3b_4b = 4'b0110; comb_8b_10b_1.mux_3b_4b = 1'b0; end
                2'd03   : begin comb_8b_10b_1.enc_3b_4b = 4'b1110; comb_8b_10b_1.mux_3b_4b = 1'b1; end
                default : begin comb_8b_10b_1.enc_3b_4b = 4'b1101; comb_8b_10b_1.mux_3b_4b = 1'b1; end
        endcase
end

endmodule
