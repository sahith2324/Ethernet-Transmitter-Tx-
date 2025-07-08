


`include "defines.v"

module tx_enqueue(  // Outputs
  pkt_tx_full, txdfifo_wdata, txdfifo_wstatus, txdfifo_wen,
  status_txdfifo_ovflow_tog,
  // Inputs
  clk_156m25, reset_156m25_n, pkt_tx_data, pkt_tx_val, pkt_tx_sop,
  pkt_tx_eop, pkt_tx_mod, txdfifo_wfull, txdfifo_walmost_full
  );

`include "CRC32_D64.v"
`include "CRC32_D8.v"
`include "utils.v"

input         clk_156m25;
input         reset_156m25_n;

input  [63:0] pkt_tx_data;
input         pkt_tx_val;
input         pkt_tx_sop;
input         pkt_tx_eop;
input  [2:0]  pkt_tx_mod;

input         txdfifo_wfull;
input         txdfifo_walmost_full;

output        pkt_tx_full;

output [63:0] txdfifo_wdata;
output [7:0]  txdfifo_wstatus;
output        txdfifo_wen;

output        status_txdfifo_ovflow_tog;

// Beginning of automatic regs (for this module's undeclared outputs)
reg                     status_txdfifo_ovflow_tog;
reg [63:0]              txdfifo_wdata;
reg                     txdfifo_wen;
reg [7:0]               txdfifo_wstatus;
// End of automatics



reg             txd_ovflow;
reg             next_txd_ovflow;



// Full status if data fifo is almost full.
// Current packet can complete transfer since data input rate
// matches output rate. But next packet must wait for more headroom.

assign pkt_tx_full = txdfifo_walmost_full;



always @(posedge clk_156m25 or negedge reset_156m25_n) begin

    if (reset_156m25_n == 1'b0) begin

        txd_ovflow <= 1'b0;

        status_txdfifo_ovflow_tog <= 1'b0;

    end
    else begin

        txd_ovflow <= next_txd_ovflow;

        //---
        // FIFO errors, used to generate interrupts

        if (next_txd_ovflow && !txd_ovflow) begin
            status_txdfifo_ovflow_tog <= ~status_txdfifo_ovflow_tog;
        end

    end

end

always @(pkt_tx_data or pkt_tx_eop or pkt_tx_mod or pkt_tx_sop
         or pkt_tx_val or txd_ovflow or txdfifo_wfull) begin

    txdfifo_wstatus = `TXSTATUS_NONE;
    txdfifo_wen = pkt_tx_val;

    next_txd_ovflow = txd_ovflow;

    `ifdef BIGENDIAN
    txdfifo_wdata = {pkt_tx_data[7:0], pkt_tx_data[15:8], pkt_tx_data[23:16], pkt_tx_data[31:24],
                     pkt_tx_data[39:32], pkt_tx_data[47:40], pkt_tx_data[55:48],
                     pkt_tx_data[63:56]};
    `else
    txdfifo_wdata = pkt_tx_data;
    `endif

    // Write SOP marker to fifo.

    if (pkt_tx_val && pkt_tx_sop) begin

        txdfifo_wstatus[`TXSTATUS_SOP] = 1'b1;

    end


    // Write EOP marker to fifo.

    if (pkt_tx_val) begin

        if (pkt_tx_eop) begin
            txdfifo_wstatus[2:0] = pkt_tx_mod;
            txdfifo_wstatus[`TXSTATUS_EOP] = 1'b1;
        end

    end


    // Overflow indication

    if (pkt_tx_val) begin

        if (txdfifo_wfull) begin

            next_txd_ovflow = 1'b1;

        end
        else if (pkt_tx_sop) begin

            next_txd_ovflow = 1'b0;

        end
    end

end


endmodule



/*
`include "defines.v"

module tx_enqueue
// Outputs
  pkt_tx_full, txdfifo_wdata, txdfifo_wstatus, txdfifo_wen,
  status_txdfifo_ovflow_tog,
  // Inputs
  clk_156m25, reset_156m25_n, pkt_tx_data, pkt_tx_val, pkt_tx_sop,
  pkt_tx_eop, pkt_tx_mod, txdfifo_wfull, txdfifo_walmost_full
  );

`include "CRC32_D64.v"
`include "CRC32_D8.v"
`include "utils.v"

input         clk_156m25;
input         reset_156m25_n;

input  [63:0] pkt_tx_data;
input         pkt_tx_val;
input         pkt_tx_sop;
input         pkt_tx_eop;
input  [2:0]  pkt_tx_mod;

input         txdfifo_wfull;
input         txdfifo_walmost_full;

output        pkt_tx_full;

output [63:0] txdfifo_wdata;
output [7:0]  txdfifo_wstatus;
output        txdfifo_wen;

output        status_txdfifo_ovflow_tog;

reg                     status_txdfifo_ovflow_tog;
reg [63:0]              txdfifo_wdata;
reg                     txdfifo_wen;
reg [7:0]               txdfifo_wstatus;

reg                     txd_ovflow;
reg                     next_txd_ovflow;

assign pkt_tx_full = txdfifo_walmost_full;

always @(posedge clk_156m25 or negedge reset_156m25_n) begin
  if (!reset_156m25_n) begin
    txd_ovflow <= 1'b0;
    status_txdfifo_ovflow_tog <= 1'b0;
  end else begin
    txd_ovflow <= next_txd_ovflow;
    if (next_txd_ovflow && !txd_ovflow)
      status_txdfifo_ovflow_tog <= ~status_txdfifo_ovflow_tog;
  end
end

always @(*) begin
  txdfifo_wstatus = 8'b0;
  txdfifo_wen = pkt_tx_val;
  next_txd_ovflow = txd_ovflow;

`ifdef BIGENDIAN
  txdfifo_wdata = {pkt_tx_data[7:0], pkt_tx_data[15:8], pkt_tx_data[23:16], pkt_tx_data[31:24],
                   pkt_tx_data[39:32], pkt_tx_data[47:40], pkt_tx_data[55:48], pkt_tx_data[63:56]};
`else
  txdfifo_wdata = pkt_tx_data;
`endif

  if (pkt_tx_val && pkt_tx_sop)
    txdfifo_wstatus[0] = 1'b1; // TXSTATUS_SOP

  if (pkt_tx_val && pkt_tx_eop) begin
    txdfifo_wstatus[2:0] = pkt_tx_mod;
    txdfifo_wstatus[1] = 1'b1; // TXSTATUS_EOP
  end

  if (pkt_tx_val) begin
    if (txdfifo_wfull)
      next_txd_ovflow = 1'b1;
    else if (pkt_tx_sop)
      next_txd_ovflow = 1'b0;
  end
end

endmodule
*/

