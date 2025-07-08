// Code your design here
/*`include "tx_data_fifo.v"
`include "tx_hold_fifo.v"
`include "tx_enqueue.v"
`include "tx_dequeue.v"

module xgmii(clk_xgmii_tx, clk_156m25, reset_xgmii_tx_n, reset_156m25_n,
               pkt_tx_data,pkt_tx_val,pkt_tx_sop,pkt_tx_eop, pkt_tx_mod,
         //outputs
  pkt_tx_full, 
 xgmii_txd, xgmii_txc               
          
  );
   
  input clk_156m25;
  input clk_xgmii_tx;
  input reset_156m25_n;
  input  reset_xgmii_tx_n;
  //enqueue inputs
  input [63:0] pkt_tx_data;
  input pkt_tx_val;
  input pkt_tx_sop;
  input pkt_tx_eop;
  input [2:0] pkt_tx_mod;
  
 
  
  // outputs
  output pkt_tx_full;
   output [63:0] xgmii_txd;
  output [7:0] xgmii_txc;
 
  
  
  
  

 wire                    txdfifo_ralmost_empty;  
 wire [63:0]             txdfifo_rdata;          
 wire                    txdfifo_rempty;      
wire                    txdfifo_ren;          
wire [7:0]              txdfifo_rstatus;      
wire                    txdfifo_walmost_full; 
wire [63:0]             txdfifo_wdata;        
wire                    txdfifo_wen;          
wire                    txdfifo_wfull;        
wire [7:0]              txdfifo_wstatus;      
wire                    txhfifo_ralmost_empty;
wire [63:0]             txhfifo_rdata;        
wire                    txhfifo_rempty;       
wire                    txhfifo_ren;          
wire [7:0]              txhfifo_rstatus;      
wire                    txhfifo_walmost_full; 
wire [63:0]             txhfifo_wdata;        
wire                    txhfifo_wen;          
wire                    txhfifo_wfull;        
wire [7:0]              txhfifo_wstatus;        



  
  
  
  
  
  
 
  

tx_dequeue tx_dq0(                  // Outputs
                  .txdfifo_ren          (txdfifo_ren),
                  .txhfifo_ren          (txhfifo_ren),
                  .txhfifo_wdata        (txhfifo_wdata[63:0]),
                  .txhfifo_wstatus      (txhfifo_wstatus[7:0]),
                  .txhfifo_wen          (txhfifo_wen),
                  .xgmii_txd            (xgmii_txd[63:0]),
                  .xgmii_txc            (xgmii_txc[7:0]),
                  .status_txdfifo_udflow_tog(status_txdfifo_udflow_tog),
                  // Inputs
                  .clk_xgmii_tx         (clk_xgmii_tx),
                  .reset_xgmii_tx_n     (reset_xgmii_tx_n),
                  .ctrl_tx_enable_ctx   (ctrl_tx_enable_ctx),
                  .status_local_fault_ctx(status_local_fault_ctx),
                  .status_remote_fault_ctx(status_remote_fault_ctx),
                  .txdfifo_rdata        (txdfifo_rdata[63:0]),
                  .txdfifo_rstatus      (txdfifo_rstatus[7:0]),
                  .txdfifo_rempty       (txdfifo_rempty),
                  .txdfifo_ralmost_empty(txdfifo_ralmost_empty),
                  .txhfifo_rdata        (txhfifo_rdata[63:0]),
                  .txhfifo_rstatus      (txhfifo_rstatus[7:0]),
                  .txhfifo_rempty       (txhfifo_rempty),
                  .txhfifo_ralmost_empty(txhfifo_ralmost_empty),
                  .txhfifo_wfull        (txhfifo_wfull),
                  .txhfifo_walmost_full (txhfifo_walmost_full));

tx_data_fifo tx_data_fifo0(                           // Outputs
                           .txdfifo_wfull       (txdfifo_wfull),
                           .txdfifo_walmost_full(txdfifo_walmost_full),
                           .txdfifo_rdata       (txdfifo_rdata[63:0]),
                           .txdfifo_rstatus     (txdfifo_rstatus[7:0]),
                           .txdfifo_rempty      (txdfifo_rempty),
                           .txdfifo_ralmost_empty(txdfifo_ralmost_empty),
                           // Inputs
                           .clk_xgmii_tx        (clk_xgmii_tx),
                           .clk_156m25          (clk_156m25),
                           .reset_xgmii_tx_n    (reset_xgmii_tx_n),
                           .reset_156m25_n      (reset_156m25_n),
                           .txdfifo_wdata       (txdfifo_wdata[63:0]),
                           .txdfifo_wstatus     (txdfifo_wstatus[7:0]),
                           .txdfifo_wen         (txdfifo_wen),
                           .txdfifo_ren         (txdfifo_ren));

tx_hold_fifo tx_hold_fifo0(                           // Outputs
                           .txhfifo_wfull       (txhfifo_wfull),
                           .txhfifo_walmost_full(txhfifo_walmost_full),
                           .txhfifo_rdata       (txhfifo_rdata[63:0]),
                           .txhfifo_rstatus     (txhfifo_rstatus[7:0]),
                           .txhfifo_rempty      (txhfifo_rempty),
                           .txhfifo_ralmost_empty(txhfifo_ralmost_empty),
                           // Inputs
                           .clk_xgmii_tx        (clk_xgmii_tx),
                           .reset_xgmii_tx_n    (reset_xgmii_tx_n),
                           .txhfifo_wdata       (txhfifo_wdata[63:0]),
                           .txhfifo_wstatus     (txhfifo_wstatus[7:0]),
                           .txhfifo_wen         (txhfifo_wen),
                           .txhfifo_ren         (txhfifo_ren));


endmodule*/
/*
`include "tx_data_fifo.v"
`include "tx_hold_fifo.v"
`include "tx_enqueue.v"
`include "tx_dequeue.v"

module xgmii(
  input  clk_156m25,
  input  clk_xgmii_tx,
  input  reset_156m25_n,
  input  reset_xgmii_tx_n,

  input  [63:0] pkt_tx_data,
  input        pkt_tx_val,
  input        pkt_tx_sop,
  input        pkt_tx_eop,
  input  [2:0] pkt_tx_mod,

  output       pkt_tx_full,
  output [63:0] xgmii_txd,
  output [7:0]  xgmii_txc
);

  wire                    txdfifo_ralmost_empty;  
  wire [63:0]             txdfifo_rdata;          
  wire                    txdfifo_rempty;      
  wire                    txdfifo_ren;          
  wire [7:0]              txdfifo_rstatus;      
  wire                    txdfifo_walmost_full; 
  wire [63:0]             txdfifo_wdata;        
  wire                    txdfifo_wen;          
  wire                    txdfifo_wfull;        
  wire [7:0]              txdfifo_wstatus;      

  wire                    txhfifo_ralmost_empty;
  wire [63:0]             txhfifo_rdata;        
  wire                    txhfifo_rempty;       
  wire                    txhfifo_ren;          
  wire [7:0]              txhfifo_rstatus;      
  wire                    txhfifo_walmost_full; 
  wire [63:0]             txhfifo_wdata;        
  wire                    txhfifo_wen;          
  wire                    txhfifo_wfull;        
  wire [7:0]              txhfifo_wstatus;      

  // Optional: assign packet full signal based on write-side FIFO status
  assign pkt_tx_full = txdfifo_wfull;

  tx_dequeue tx_dq0(
    .txdfifo_ren           (txdfifo_ren),
    .txhfifo_ren           (txhfifo_ren),
    .txhfifo_wdata         (txhfifo_wdata),
    .txhfifo_wstatus       (txhfifo_wstatus),
    .txhfifo_wen           (txhfifo_wen),
    .xgmii_txd             (xgmii_txd),
    .xgmii_txc             (xgmii_txc),
    .status_txdfifo_udflow_tog (), // Unconnected optional
    .clk_xgmii_tx          (clk_xgmii_tx),
    .reset_xgmii_tx_n      (reset_xgmii_tx_n),
    .ctrl_tx_enable_ctx    (1'b1), // Assuming always enabled
    .status_local_fault_ctx(1'b0), // Assuming no fault
    .status_remote_fault_ctx(1'b0), // Assuming no fault
    .txdfifo_rdata         (txdfifo_rdata),
    .txdfifo_rstatus       (txdfifo_rstatus),
    .txdfifo_rempty        (txdfifo_rempty),
    .txdfifo_ralmost_empty (txdfifo_ralmost_empty),
    .txhfifo_rdata         (txhfifo_rdata),
    .txhfifo_rstatus       (txhfifo_rstatus),
    .txhfifo_rempty        (txhfifo_rempty),
    .txhfifo_ralmost_empty (txhfifo_ralmost_empty),
    .txhfifo_wfull         (txhfifo_wfull),
    .txhfifo_walmost_full  (txhfifo_walmost_full)
  );

  tx_data_fifo tx_data_fifo0(
    .txdfifo_wfull         (txdfifo_wfull),
    .txdfifo_walmost_full  (txdfifo_walmost_full),
    .txdfifo_rdata         (txdfifo_rdata),
    .txdfifo_rstatus       (txdfifo_rstatus),
    .txdfifo_rempty        (txdfifo_rempty),
    .txdfifo_ralmost_empty (txdfifo_ralmost_empty),
    .clk_xgmii_tx          (clk_xgmii_tx),
    .clk_156m25            (clk_156m25),
    .reset_xgmii_tx_n      (reset_xgmii_tx_n),
    .reset_156m25_n        (reset_156m25_n),
    .txdfifo_wdata         (txdfifo_wdata),
    .txdfifo_wstatus       (txdfifo_wstatus),
    .txdfifo_wen           (txdfifo_wen),
    .txdfifo_ren           (txdfifo_ren)
  );

  tx_hold_fifo tx_hold_fifo0(
    .txhfifo_wfull         (txhfifo_wfull),
    .txhfifo_walmost_full  (txhfifo_walmost_full),
    .txhfifo_rdata         (txhfifo_rdata),
    .txhfifo_rstatus       (txhfifo_rstatus),
    .txhfifo_rempty        (txhfifo_rempty),
    .txhfifo_ralmost_empty (txhfifo_ralmost_empty),
    .clk_xgmii_tx          (clk_xgmii_tx),
    .reset_xgmii_tx_n      (reset_xgmii_tx_n),
    .txhfifo_wdata         (txhfifo_wdata),
    .txhfifo_wstatus       (txhfifo_wstatus),
    .txhfifo_wen           (txhfifo_wen),
    .txhfifo_ren           (txhfifo_ren)
  );

endmodule

*/


`include "tx_data_fifo.v"
`include "tx_hold_fifo.v"
`include "tx_enqueue.v"
`include "tx_dequeue.v"

module xgmii(
  input  clk_xgmii_tx,
  input  clk_156m25,
  input  reset_xgmii_tx_n,
  input  reset_156m25_n,
  input  [63:0] pkt_tx_data,
  input  pkt_tx_val,
  input  pkt_tx_sop,
  input  pkt_tx_eop,
  input  [2:0] pkt_tx_mod,

  output pkt_tx_full, 
  output [63:0] xgmii_txd,
  output [7:0] xgmii_txc
);

  // FIFO interconnect wires
  wire                    txdfifo_ralmost_empty;  
  wire [63:0]             txdfifo_rdata;          
  wire                    txdfifo_rempty;      
  wire                    txdfifo_ren;          
  wire [7:0]              txdfifo_rstatus;      
  wire                    txdfifo_walmost_full; 
  wire [63:0]             txdfifo_wdata;        
  wire                    txdfifo_wen;          
  wire                    txdfifo_wfull;        
  wire [7:0]              txdfifo_wstatus;      
  wire                    txhfifo_ralmost_empty;
  wire [63:0]             txhfifo_rdata;        
  wire                    txhfifo_rempty;       
  wire                    txhfifo_ren;          
  wire [7:0]              txhfifo_rstatus;      
  wire                    txhfifo_walmost_full; 
  wire [63:0]             txhfifo_wdata;        
  wire                    txhfifo_wen;          
  wire                    txhfifo_wfull;        
  wire [7:0]              txhfifo_wstatus;        

  // Static control signals (can be hooked to inputs if needed)
  wire ctrl_tx_enable_ctx       = 1'b1;
  wire status_local_fault_ctx   = 1'b0;
  wire status_remote_fault_ctx  = 1'b0;
  wire status_txdfifo_udflow_tog;

  // Instantiation of tx_enqueue
  tx_enqueue tx_eq0 (
    .pkt_tx_full          (pkt_tx_full),
    .txdfifo_wdata        (txdfifo_wdata),
    .txdfifo_wstatus      (txdfifo_wstatus),
    .txdfifo_wen          (txdfifo_wen),

    .clk_156m25           (clk_156m25),
    .reset_156m25_n       (reset_156m25_n),
    .pkt_tx_data          (pkt_tx_data),
    .pkt_tx_val           (pkt_tx_val),
    .pkt_tx_sop           (pkt_tx_sop),
    .pkt_tx_eop           (pkt_tx_eop),
    .pkt_tx_mod           (pkt_tx_mod),
    .txdfifo_wfull        (txdfifo_wfull),
    .txdfifo_walmost_full (txdfifo_walmost_full)
  );

  // Data FIFO
  tx_data_fifo tx_data_fifo0 (
    .txdfifo_wfull        (txdfifo_wfull),
    .txdfifo_walmost_full (txdfifo_walmost_full),
    .txdfifo_rdata        (txdfifo_rdata),
    .txdfifo_rstatus      (txdfifo_rstatus),
    .txdfifo_rempty       (txdfifo_rempty),
    .txdfifo_ralmost_empty(txdfifo_ralmost_empty),
    .clk_xgmii_tx         (clk_xgmii_tx),
    .clk_156m25           (clk_156m25),
    .reset_xgmii_tx_n     (reset_xgmii_tx_n),
    .reset_156m25_n       (reset_156m25_n),
    .txdfifo_wdata        (txdfifo_wdata),
    .txdfifo_wstatus      (txdfifo_wstatus),
    .txdfifo_wen          (txdfifo_wen),
    .txdfifo_ren          (txdfifo_ren)
  );

  // Hold FIFO
  tx_hold_fifo tx_hold_fifo0 (
    .txhfifo_wfull        (txhfifo_wfull),
    .txhfifo_walmost_full (txhfifo_walmost_full),
    .txhfifo_rdata        (txhfifo_rdata),
    .txhfifo_rstatus      (txhfifo_rstatus),
    .txhfifo_rempty       (txhfifo_rempty),
    .txhfifo_ralmost_empty(txhfifo_ralmost_empty),
    .clk_xgmii_tx         (clk_xgmii_tx),
    .reset_xgmii_tx_n     (reset_xgmii_tx_n),
    .txhfifo_wdata        (txhfifo_wdata),
    .txhfifo_wstatus      (txhfifo_wstatus),
    .txhfifo_wen          (txhfifo_wen),
    .txhfifo_ren          (txhfifo_ren)
  );

  // Dequeue module
  tx_dequeue tx_dq0 (
    .txdfifo_ren             (txdfifo_ren),
    .txhfifo_ren             (txhfifo_ren),
    .txhfifo_wdata           (txhfifo_wdata),
    .txhfifo_wstatus         (txhfifo_wstatus),
    .txhfifo_wen             (txhfifo_wen),
    .xgmii_txd               (xgmii_txd),
    .xgmii_txc               (xgmii_txc),
    .status_txdfifo_udflow_tog(status_txdfifo_udflow_tog),

    .clk_xgmii_tx            (clk_xgmii_tx),
    .reset_xgmii_tx_n        (reset_xgmii_tx_n),
    .ctrl_tx_enable_ctx      (ctrl_tx_enable_ctx),
    .status_local_fault_ctx  (status_local_fault_ctx),
    .status_remote_fault_ctx (status_remote_fault_ctx),
    .txdfifo_rdata           (txdfifo_rdata),
    .txdfifo_rstatus         (txdfifo_rstatus),
    .txdfifo_rempty          (txdfifo_rempty),
    .txdfifo_ralmost_empty   (txdfifo_ralmost_empty),
    .txhfifo_rdata           (txhfifo_rdata),
    .txhfifo_rstatus         (txhfifo_rstatus),
    .txhfifo_rempty          (txhfifo_rempty),
    .txhfifo_ralmost_empty   (txhfifo_ralmost_empty),
    .txhfifo_wfull           (txhfifo_wfull),
    .txhfifo_walmost_full    (txhfifo_walmost_full)
  );

endmodule

    
