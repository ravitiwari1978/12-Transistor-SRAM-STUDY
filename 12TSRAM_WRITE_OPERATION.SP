* 12T SRAM Cell - Write Operation and WSNM Analysis

.include "45nm_PMOS_bulk5535.pm"
.include "45nm_NMOS_bulk29417.pm"

******************************************************
* Supply & Inputs
******************************************************
VDD  Vdd  0   DC 1.0
Vblb BLB  0   DC 1.0         * Hold BLB = 1
Vbl  BL   0   DC 0           * Will be swept or used in transient
Vwl  WL   0   PULSE(0 1 0.2n 10p 10p 1n 4n)

.ic V(Q)=1 V(QB)=0          * Start with Q=1, QB=0

******************************************************
* 12T SRAM Cell with Balanced Sizing
******************************************************

* Cross-coupled Inverters
M1  Q   QB  Vdd Vdd pmos L=45n W=90n     * Pull-up (weakened)
M2  Q   QB  0   0   nmos L=45n W=90n
M3  QB  Q   Vdd Vdd pmos L=45n W=90n     * Pull-up (weakened)
M4  QB  Q   0   0   nmos L=45n W=90n

* Access Transistors - WRITE path
M5  Q   WL  BL   0   nmos L=45n W=270n   * Strong access to flip Q
M6  QB  WL  BLB  0   nmos L=45n W=270n

* Read Path (not used in write, kept for completeness)
M7  ReadNode Q Vdd Vdd pmos L=45n W=180n
M8  ReadNode Q 0   0   nmos L=45n W=90n
M9  ReadNode 0 Q   pmos L=45n W=180n
M10 ReadNode 0 Q   nmos L=45n W=90n

* Keeper Transistors
M11 Q  Q  0  0 nmos L=45n W=90n
M12 QB QB 0  0 nmos L=45n W=90n

******************************************************
* ANALYSIS
******************************************************

* Transient Write — observe Q flip
.tran 1p 10n

* DC Sweep on BL — for WSNM
.dc Vbl 0 1.0 0.01

******************************************************
* Probes
******************************************************
.probe V(Q) V(QB) V(BL) V(BLB) V(WL)

.options post=2 nomod accurate
.temp 25

.end
