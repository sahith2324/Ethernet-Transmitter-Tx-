`include "defines.v"

module tx_dequeue(
  // Outputs
  txdfifo_ren, txhfifo_ren, txhfifo_wdata, txhfifo_wstatus,
  txhfifo_wen, xgmii_txd, xgmii_txc, status_txdfifo_udflow_tog,
  // Inputs
  clk_xgmii_tx, reset_xgmii_tx_n, ctrl_tx_enable_ctx,
  status_local_fault_ctx, status_remote_fault_ctx, txdfifo_rdata,
  txdfifo_rstatus, txdfifo_rempty, txdfifo_ralmost_empty,
  txhfifo_rdata, txhfifo_rstatus, txhfifo_rempty,
  txhfifo_ralmost_empty, txhfifo_wfull, txhfifo_walmost_full
);

`include "CRC32_D64.v"
`include "CRC32_D8.v"
`include "utils.v"

// ... (Keep all your existing input/output declarations) ...

/*AUTOREG*/
// ... (Keep your existing AUTOREG declarations) ...

/*AUTOWIRE*/

// ... (Keep all your existing register declarations) ...

parameter [2:0]
           SM_IDLE      = 3'd0,
           SM_PREAMBLE  = 3'd1,
           SM_TX        = 3'd2,
           SM_EOP       = 3'd3,
           SM_TERM      = 3'd4,
           SM_TERM_FAIL = 3'd5,
           SM_IFG       = 3'd6;

parameter [0:0]
           SM_PAD_EQ    = 1'd0,
           SM_PAD_PAD   = 1'd1;

// =============================================
// FIX 1: PROPER CONTROL CHARACTER DEFINITIONS
// =============================================
// Ensure these match your defines.v
parameter [7:0]
           IDLE      = 8'h07,
           START     = 8'hFB,
           TERMINATE = 8'hFD,
           PREAMBLE  = 8'h55,
           SFD       = 8'hD5;

// =============================================
// FIX 2: ADDED IFG COUNTER
// =============================================
reg [3:0] ifg_cnt;  // Counts IFG bytes (minimum 12)

// =============================================
// RC LAYER WITH FIXED CONTROL CHARACTERS
// =============================================
always @(posedge clk_xgmii_tx or negedge reset_xgmii_tx_n) begin
    if (!reset_xgmii_tx_n) begin
        xgmii_txd <= {8{IDLE}};
        xgmii_txc <= 8'hff;
    end
    else begin
        if (status_local_fault_ctx) begin
            xgmii_txd <= {TERMINATE, 56'h0}; // Local fault pattern
            xgmii_txc <= 8'h01;
        end
        else if (status_remote_fault_ctx) begin
            xgmii_txd <= {8{IDLE}};
            xgmii_txc <= 8'hff;
        end
        else begin
            xgmii_txd <= xgxs_txd;
            xgmii_txc <= xgxs_txc;
        end
    end
end

// =============================================
// MAIN STATE MACHINE WITH CRITICAL FIXES
// =============================================
always @(posedge clk_xgmii_tx or negedge reset_xgmii_tx_n) begin
    if (!reset_xgmii_tx_n) begin
        // ... (Keep your existing resets) ...
        ifg_cnt <= 4'd0;
    end
    else begin
        curr_state_enc <= next_state_enc;
        // ... (Keep your existing sequential logic) ...

        // FIX: PROPER IFG COUNTING
        if (curr_state_enc == SM_IFG) begin
            ifg_cnt <= ifg_cnt + 4'd1;
        end else begin
            ifg_cnt <= 4'd0;
        end

        // FIX: BARREL SHIFTER WITH LANE ALIGNMENT
        if (next_start_on_lane0) begin
            xgxs_txd <= next_xgxs_txd;
            xgxs_txc <= next_xgxs_txc;
        end
        else begin
            xgxs_txd <= {next_xgxs_txd[31:0], xgxs_txd_barrel};
            xgxs_txc <= {next_xgxs_txc[3:0], xgxs_txc_barrel};
        end
    end
end

// =============================================
// COMBINATIONAL STATE MACHINE WITH FIXES
// =============================================
always @(*) begin
    // Defaults
    next_state_enc = curr_state_enc;
    next_xgxs_txd = {8{IDLE}};
    next_xgxs_txc = 8'hff;
    txhfifo_ren = 1'b0;
    
    // FIX: PROPER FRAME AVAILABLE LOGIC
    next_frame_available = !txhfifo_ralmost_empty;

    case (curr_state_enc)
        SM_IDLE: begin
            if (ctrl_tx_enable_ctx && frame_available &&
                !status_local_fault_ctx) begin
                txhfifo_ren = 1'b1;
                next_state_enc = SM_PREAMBLE;
            end
        end

        SM_PREAMBLE: begin
            // FIX: PROPER PREAMBLE AND START SEQUENCE
            if (txhfifo_rstatus[`TXSTATUS_SOP]) begin
                next_xgxs_txd = {START, {6{PREAMBLE}}, SFD}; // 0xFB555555555555D5
                next_xgxs_txc = 8'h01; // Only lane 0 is control
                txhfifo_ren = 1'b1;
                next_state_enc = SM_TX;
            end
        end

        SM_TX: begin
            // FIX: PROPER DATA TRANSFER
            next_xgxs_txd = txhfifo_rdata_d1;
            next_xgxs_txc = 8'h00; // All data bytes
            txhfifo_ren = 1'b1;

            if (txhfifo_rstatus[`TXSTATUS_EOP]) begin
                // FIX: PROPER EOP HANDLING
                case (txhfifo_rstatus[2:0])
                    3'd1: begin // 1 valid byte
                        next_xgxs_txd = {56'h07070707070707, txhfifo_rdata_d1[7:0], TERMINATE};
                        next_xgxs_txc = 8'b11100001;
                    end
                    // ... (Add all other EOP cases) ...
                    3'd0: begin // 8 valid bytes
                        next_xgxs_txd = {txhfifo_rdata_d1[63:0], TERMINATE};
                        next_xgxs_txc = 8'b00000001;
                    end
                endcase
                next_state_enc = SM_IFG;
            end
        end

        SM_IFG: begin
            // FIX: PROPER INTER-FRAME GAP
            next_xgxs_txd = {8{IDLE}};
            next_xgxs_txc = 8'hff;
            if (ifg_cnt >= 4'd12) begin // Minimum 12-byte IFG
                next_state_enc = SM_IDLE;
            end
        end

        // ... (Keep your other states) ...
    endcase
end

// =============================================
// CRC CALCULATION WITH TIMING FIXES
// =============================================
always @(posedge clk_xgmii_tx) begin
    if (txhfifo_wen) begin
        if (txhfifo_wstatus[`TXSTATUS_SOP]) begin
            crc32_d64 <= 32'hFFFFFFFF;
        end
        else begin
            crc32_d64 <= nextCRC32_D64(reverse_64b(txhfifo_wdata), crc32_d64);
        end
    end
    
    // FIX: EARLY CRC FINALIZATION
    if (txhfifo_wstatus[`TXSTATUS_EOP]) begin
        case (txhfifo_wstatus[2:0])
            3'd1: crc32_d8 <= nextCRC32_D8(reverse_8b(txhfifo_wdata[7:0]), crc32_d64);
            // ... (other cases) ...
        endcase
        crc32_tx <= ~reverse_32b(crc32_d8); // Final inversion
    end
end

// =============================================
// PADDING STATE MACHINE (UNCHANGED)
// =============================================
// ... (Keep your existing padding logic) ...

endmodule
