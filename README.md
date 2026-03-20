# Traffic Light Controller FSM (with delay)

**Project Overview**

This repository contains a SystemVerilog implementation of a 4-state Finite State Machine (FSM) representing a traffic light controller. This version steps up from the basic immediate-transition model by incorporating a 5-second delay for all yellow light transitions.

**Hardware Specifications**

The FSM manages traffic between Street A and Street B based on a single sensor input:

**Inputs:** 
- clk, reset, and TAORB.

**TAORB Logic:**  
- TAORB = 1: Traffic at Street A is present; Street B is empty.

- TAORB = 0: Traffic at Street B is present; Street A is empty.

**Outputs:** 
- 2-bit signals for LA (Street A) and LB (Street B) representing Green, Yellow, and Red states.

**FSM State Behavior**

The design follows a 4-state transition logic with an internal timer:
1. S0 (Green A / Red B): Transitions to S1 when traffic is detected at Street B (~TAORB).
2. S1 (Yellow A / Red B): Holds for 5 time units using an internal counter. Transitions to S2 once TIMER = 5.
3. S2 (Red A / Green B): Transitions to S3 when traffic is detected at Street A (TAORB).
4. S3 (Red A / Yellow B): Holds for 5 time units. Transitions back to S0 once TIMER = 5.
