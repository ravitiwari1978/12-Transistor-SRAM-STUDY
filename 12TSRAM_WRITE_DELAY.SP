* 12T SRAM Cell netlist for the WRITE Delay Measurements
* Technology: 45nm Technology Nodes
* author::RAVI SHANKAR TIWARI


*******1ST ADD THE TECHNOLOGY NODES FILE WITH .PM OPERATOR
.include "45nm_NMOS_bulk29417.pm"
.include "45nm_PMOS_bulk5535.pm"

* Power Supply For word line
VDD Vdd 0 DC 1.0

* Initial condition of storage nodes (Q=1, QB=0)
.ic V(Q)=1 V(QB)=0

* Write Word Line pulse (WL) - triggers write operation at 0.5ns
VWL WL 0 PULSE(0 1 0.5n 10p 10p 1n 2n)

* Write Bit Line signals - writing logic '0' (BL=1 → 0, BLB=0 → 1)
* Bitlines start at 0n so BL and BLB settle before WL rises
VBL BL 0 PULSE(1 0 0 10p 10p 1n 2n)
VBLB BLB 0 PULSE(0 1 0 10p 10p 1n 2n)

* 12T SRAM Cell 

* Cross-coupled inverter pair 1
M1 Q  QB  Vdd Vdd pmos L=45n W=180n
M2 Q  QB   0   0  nmos L=45n W=90n

* Cross-coupled inverter pair 2
M3 QB Q   Vdd Vdd pmos L=45n W=180n
M4 QB Q    0   0  nmos L=45n W=90n

* Access transistors for write operation
M5 Q   WL BL  0 nmos L=45n W=90n
M6 QB  WL BLB 0 nmos L=45n W=90n

* Read Buffer transistors (disabled by making ReadWL=0)
M7  ReadNode Q  Vdd Vdd pmos L=45n W=180n
M8  ReadNode Q   0   0  nmos L=45n W=90n

* Disable read buffer by turning off M9 and M10 gates (gate tied to 0)
M9  ReadNode 0  Q   pmos L=45n W=180n
M10 ReadNode 0  Q   nmos L=45n W=90n

* Additional hardening transistors
M11 Q  Q  0  0 nmos L=45n W=90n
M12 QB QB 0  0 nmos L=45n W=90n

* Bitline load resistors to model bitline capacitance/load
RBL  BL  0 10k
RBLB BLB 0 10k

* Simulation options
.option post=2 nomod
.temp 25
.tran 1p 20n

* Measurement: Write Delay:it is defined as the time difference between the applied pulse rise at the write word line and the fall of vq when 0 is to be written there
****************************and the rise of vq if 1 is to be written there and the bl and blb pulses should be set as required for writting at the nodes of the 
****************q and qb and the pulse achieved at bl and blb should be more earlier than that of the wrold line pulse and it is the time difference between the word line 
*****pulse and the written place pulse
* Measure delay from WL rising edge crossing 0.5V (rising)
* to Q node voltage falling past 0.5V (falling)
.meas tran write_delay TRIG V(WL) VAL=0.5 RISE=1 TARG V(Q) VAL=0.5 FALL=1


* Output voltage waveforms for inspection
.print tran V(Q) V(QB) V(BL) V(BLB) V(WL)

.end
