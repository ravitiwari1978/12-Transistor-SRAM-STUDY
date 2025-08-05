* 12T SRAM Cell netlist for the Read Delay Measurements
* Technology: 45nm Technology Nodes
* author::RAVI SHANKAR TIWARI

*******1ST ADD THE TECHNOLOGY NODES FILE WITH .PM OPERATOR
.include "45nm_NMOS_bulk29417.pm"
.include "45nm_PMOS_bulk5535.pm"

**************************************
* Power Supply
VDD Vdd 0 DC 1.0

********making the initial condition 
.ic V(Q)=1,V(QB)=0;

* Read Word Line Pulse (starts late to ensure BL is stable)
VReadWL ReadWL 0 PULSE(0 1 0.1n 10p 10p 1n 3n)
***always need to remember that the read word line sholud be triggered high before the nodes pulse bl abd blb .
****AND IN THE WRITE DEALY CALCULATION PEHLE BL AND BLB SET HONA CHAHIYE
******AND THE BL AND BLB IN THE READ OPERATION IS TAKEN TO BE SET 
**************************************

* BL = 1, BLB = 0
VBL  BL  0 PULSE(0 1 0.4n 10p 10p 1n 2n)
VBLB BLB 0 PULSE(1 0 0.4n 10p 10p 1n 2n)

**************************************
* 12T SRAM Cell
* Cross-coupled inverter pair 1
M1 Q  QB Vdd Vdd pmos L=45n W=180n
M2 Q  QB 0   0   nmos L=45n W=90n

* Cross-coupled inverter pair 2
M3 QB Q  Vdd Vdd pmos L=45n W=180n
M4 QB Q  0   0   nmos L=45n W=90n

* Access transistors
M5 Q  WL BL  Vdd nmos L=45n W=90n
M6 QB WL BLB Vdd nmos L=45n W=90n

* Read Buffer
M7  ReadNode Q Vdd Vdd pmos L=45n W=180n
M8  ReadNode Q 0   0   nmos L=45n W=90n
M9  ReadNode ReadWL Q pmos L=45n W=180n
M10 ReadNode ReadWL Q nmos L=45n W=90n

* Additional hardening
M11 Q  Q  0 0 nmos L=45n W=90n
M12 QB QB 0 0 nmos L=45n W=90n


********making the initial condition 
.ic V(Q)=1,V(QB)=0;


**************************************
* Bitline Load
RBL  BL  0 10k
RBLB BLB 0 10k

**************************************
* Simulation Setup
.option post=2 nomod
.temp 25
.tran 1p 8n

**************************************
* Measurement Setup HERE READWL IS THE READ WORD LINE AND READ DELAY IS THE TIME DIFFERENCE BETWEEN THE RISE OF THE WORD LINE FOR READ AND THE TIME WHEN READ ACHIEVED AT THE SENSE AMPLIFIER 
****from theory as we know that the during read operation the sense apmplifier senses the voltage difference between the bl and blb node and the difference between node*** ***voltages is indication towards the read of voltages at the bl and blb if blb is holding logic 0 then during read operation is rises else falls and then read delay is 
*********calculated from  difference between the read word line and fall/rise of voltage at the blb


* Ensure BL starts at 1 and then drops after ReadWL rises.
.meas tran read_delay TRIG V(ReadWL) VAL=0.5 RISE=1 TARG V(BL) VAL=0.9 FALL=1
******negative read delay arises when the target is achieved earlier than the trigger that is when the triggering is slowly achieved
**************************************
* Probes
.probe V(Q) V(QB) V(BL) V(BLB) V(WL) V(ReadWL)
.print tran V(Q) V(QB) V(BLB) V(WL)

.end
