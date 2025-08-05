* 12T SRAM Cell netlist for READ Operation Waveform (BL and BLB)
* Technology: 45nm PTM

.include "45nm_NMOS_bulk29417.pm"
.include "45nm_PMOS_bulk5535.pm"

* Power Supply
VDD Vdd 0 DC 1.0

* Initial condition of storage nodes (Q=1, QB=0)
.ic V(Q)=1 V(QB)=0

* BITLINES are precharged HIGH
VBL  BL  0 DC 1.0
VBLB BLB 0 DC 1.0

* WL is 0 (disabled), only ReadWL active
VWL WL 0 DC 0

* Read Word Line pulse to trigger read operation (tied to M9/M10 gates or extra read pass gate)
VReadWL ReadWL 0 PULSE(0 1 0.5n 10p 10p 2n 4n)

* 12T SRAM Cell

* Cross-coupled inverter pair 1
M1 Q  QB  Vdd Vdd pmos L=45n W=180n
M2 Q  QB   0   0  nmos L=45n W=90n

* Cross-coupled inverter pair 2
M3 QB Q   Vdd Vdd pmos L=45n W=180n
M4 QB Q    0   0  nmos L=45n W=90n

* Write access transistors — disabled
M5 Q   WL BL  0 nmos L=45n W=90n
M6 QB  WL BLB 0 nmos L=45n W=90n

* Read Buffer transistors
M7  ReadNode Q   Vdd Vdd pmos L=45n W=180n
M8  ReadNode Q    0   0  nmos L=45n W=90n

* Active read path transistors — gate controlled by ReadWL
M9  BL  ReadWL  ReadNode pmos L=45n W=180n
M10 BLB ReadWL  ReadNode nmos L=45n W=90n

* Optional radiation-hardening transistors
M11 Q  Q   0 0 nmos L=45n W=90n
M12 QB QB  0 0 nmos L=45n W=90n

* Bitline resistive loads (simulate bitline capacitance)
RBL  BL  0 10k
RBLB BLB 0 10k

* Simulation options
.option post=2 nomod
.temp 25
.tran 1p 20n

* Probes and waveform outputs
.probe V(Q) V(QB) V(BL) V(BLB) V(ReadWL) V(ReadNode)

* Optional: .print
.print tran V(Q) V(QB) V(BL) V(BLB) V(ReadWL)

.end
