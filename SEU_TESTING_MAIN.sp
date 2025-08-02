* 12T Radiation-Hardened SRAM Cell for the single event upset Test
* Technology: 45nm PTM Models
******RAVISHANKAR@2204205

************************************************
.include "45nm_NMOS_bulk29417.pm"
.include "45nm_PMOS_bulk5535.pm"
************************************************

.param vdd = 1.0
.global VDD GND

*****************************
* Voltage Sources
*****************************
VDD VDD 0 vdd
Vgnd GND 0 0

* Access path control (keep access off)
VWL WL 0 0
VBL BL 0 0
VBLB BLB 0 1.0

*****************************
* 12T SRAM Cell Transistors
*****************************

* Cross-coupled inverters
M1 Q  QB VDD VDD pmos L=45n W=180n
M2 QB Q  VDD VDD pmos L=45n W=180n
M3 Q  QB GND GND nmos L=45n W=90n
M4 QB Q  GND GND nmos L=45n W=90n

* Access transistors (disabled via WL = 0)
M5 Q  WL BL   GND nmos L=45n W=90n
M6 QB WL BLB  GND nmos L=45n W=90n

* Feedback hardening transistors
M7  Q  QB VDD VDD pmos L=45n W=180n
M8  QB Q  VDD VDD pmos L=45n W=180n
M9  Q  QB GND GND nmos L=45n W=90n
M10 QB Q  GND GND nmos L=45n W=90n

* Extra 2 NMOS transistor
M11 Q  Q  GND GND nmos L=45n W=90n
M12 QB QB GND GND nmos L=45n W=90n

*****************************
* SEU Current Pulse Injection
*****************************
I_SEU Q 0 PULSE(0 50u 1.5n 10p 10p 200p 5n)

*****************************

.param Ipeak=50u
*I_SEU Q 0 PULSE(0 {Ipeak} 1.5n 10p 10p 200p 5n)
.step param Ipeak list 50u 100u 150u 200u 250u


**********************************************
* Initial Condition (Stable Q = 1)
*****************************
.ic V(Q)=1 V(QB)=0
.nodeset V(Q)=1 V(QB)=0

*****************************
* Simulation Control
*****************************
.tran 1ps 6ns
.option post=2 nomod

*****************************
* Output Signals
*****************************
.probe V(Q) V(QB)

.end









