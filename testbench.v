/*`include "design.v"
module testbench;

  // Clock and reset
  reg clk_156m25 = 0;
  reg clk_xgmii_tx=0;
  reg reset_156m25_n = 0;
 
  reg reset_xgmii_tx_n = 0;




  // TX packet signals
  reg pkt_tx_val;
  reg pkt_tx_sop;
  reg pkt_tx_eop;
  reg [2:0] pkt_tx_mod;
  reg [63:0] pkt_tx_data;
  wire pkt_tx_full;


  wire [63:0] xgmii_txd;
  wire [7:0] xgmii_txc;

  // DUT instantiation
  xgmii dut (
    .clk_156m25(clk_156m25),
   
    .clk_xgmii_tx(clk_xgmii_tx),
    .reset_156m25_n(reset_156m25_n),

    .reset_xgmii_tx_n(reset_xgmii_tx_n),

    .pkt_tx_val(pkt_tx_val),
    .pkt_tx_sop(pkt_tx_sop),
    .pkt_tx_eop(pkt_tx_eop),
    .pkt_tx_mod(pkt_tx_mod),
    .pkt_tx_data(pkt_tx_data),
    .pkt_tx_full(pkt_tx_full),

    .xgmii_txd(xgmii_txd),
    .xgmii_txc(xgmii_txc)
  );

  // Clock generation
  always #3.2 clk_156m25 = ~clk_156m25;   // ~156.25 MHz
 // 125 MHz
  always #4 clk_xgmii_tx = ~clk_xgmii_tx; // 125 MHz
        // Wishbone clock

  // Loopback XGMII TX -> RX
 // assign xgmii_rxd = xgmii_txd;
 // assign xgmii_rxc = xgmii_txc;

  initial begin
    $display("Starting simulation...");

    // Initial values
    pkt_tx_val = 0;
    pkt_tx_sop = 0;
    pkt_tx_eop = 0;
    pkt_tx_mod = 0;
    pkt_tx_data = 0;


    // Apply resets
    #50;
    reset_156m25_n = 1;
     reset_xgmii_tx_n = 1;

    // Wait for a few cycles
    #100;

    // Stimulate TX path
    pkt_tx_sop = 1;
    pkt_tx_val = 1;
    pkt_tx_data = 64'hAABBCCDDEEFF0011;
    pkt_tx_mod = 3'b000;
    $display("TX DATA SENT      : %h", pkt_tx_data);
    $display("TX Start of Packet");
    $display("TX MOD            : %03b", pkt_tx_mod);
    #8;

    pkt_tx_sop = 0;
    pkt_tx_data = 64'h1122334455667788;
    $display("TX DATA SENT      : %h", pkt_tx_data);
    #8;

    pkt_tx_eop = 1;
    pkt_tx_data = 64'hFFEEDDCCBBAA9988;
    $display("TX DATA SENT      : %h", pkt_tx_data);
    $display("TX End of Packet");
    #8;

    pkt_tx_val = 0;
    pkt_tx_eop = 0;

    // Wait longer to receive all RX data
    #3000;


    $finish;
  end



endmodule
*/

//`include "design.v"

`include "design.v"

module testbench;

  // Clock and reset
  reg clk_156m25 = 0;
  reg clk_xgmii_tx = 0;
  reg reset_156m25_n = 0;
  reg reset_xgmii_tx_n = 0;

  // TX packet signals
  reg pkt_tx_val;
  reg pkt_tx_sop;
  reg pkt_tx_eop;
  reg [2:0] pkt_tx_mod;
  reg [63:0] pkt_tx_data;
  wire pkt_tx_full;

  // XGMII output signals
  wire [63:0] xgmii_txd;
  wire [7:0] xgmii_txc;

  // DUT instantiation
  xgmii dut (
    .clk_156m25(clk_156m25),
    .clk_xgmii_tx(clk_xgmii_tx),
    .reset_156m25_n(reset_156m25_n),
    .reset_xgmii_tx_n(reset_xgmii_tx_n),
    .pkt_tx_val(pkt_tx_val),
    .pkt_tx_sop(pkt_tx_sop),
    .pkt_tx_eop(pkt_tx_eop),
    .pkt_tx_mod(pkt_tx_mod),
    .pkt_tx_data(pkt_tx_data),
    .pkt_tx_full(pkt_tx_full),
    .xgmii_txd(xgmii_txd),
    .xgmii_txc(xgmii_txc)
  );

  // Clock generation
  always #3.2 clk_156m25 = ~clk_156m25;
  always #4 clk_xgmii_tx = ~clk_xgmii_tx;

  // Initialization
  initial begin
    // Initialize inputs
    pkt_tx_val = 0;
    pkt_tx_sop = 0;
    pkt_tx_eop = 0;
    pkt_tx_mod = 0;
    pkt_tx_data = 0;

    reset_156m25_n = 0;
    reset_xgmii_tx_n = 0;

    // Hold reset for a few cycles
    repeat (10) @(posedge clk_xgmii_tx);
    reset_156m25_n = 1;
    reset_xgmii_tx_n = 1;

    // Wait after reset deassertion for FSM to be ready
    repeat (10) @(posedge clk_xgmii_tx);

    // START TX packet transmission AFTER FSM ready
    @(posedge clk_xgmii_tx);
    pkt_tx_sop  = 1;
    pkt_tx_val  = 1;
    pkt_tx_eop  = 0;
    pkt_tx_mod  = 3'b000;
    pkt_tx_data = 64'hAABBCCDDEEFF0011;

    @(posedge clk_xgmii_tx);
    pkt_tx_sop  = 0;
    pkt_tx_data = 64'h1122334455667788;

    @(posedge clk_xgmii_tx);
    pkt_tx_eop  = 1;
    pkt_tx_data = 64'hFFEEDDCCBBAA9988;

    @(posedge clk_xgmii_tx);
    pkt_tx_val  = 0;
    pkt_tx_eop  = 0;

    // Wait to observe all output
    repeat (100) @(posedge clk_xgmii_tx);

    $finish;
  end

  // Monitor for debug
  initial begin
    $display("Starting simulation...");
    $monitor("T=%0t | SOP=%b EOP=%b VAL=%b DATA=%h | XGMII_TXD=%h TXC=%h",
             $time, pkt_tx_sop, pkt_tx_eop, pkt_tx_val, pkt_tx_data, xgmii_txd, xgmii_txc);
  end

endmodule

