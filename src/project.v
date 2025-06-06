/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_NES_Emulator (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  reg [7:0] tmp;
  wire [7:0] mem_data_in;
  wire [7:0] mem_data_out;
  wire [7:0] mem_addr;

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  tt_um_6502_module CPU(8'd5, 8'd5,mem_addr, mem_data_in, mem_data_out, clk);
  tt_um_memory_module Memory(1'b0, mem_addr, mem_data_in, mem_data_out, clk);
  tt_um_audio_module Audio(8'd5, 8'd5 ,mem_addr, mem_data_in, mem_data_out, clk);
  tt_um_vga_driver_module VGA_driver(8'd5, 8'd5 ,mem_addr, mem_data_in, mem_data_out, clk);
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
