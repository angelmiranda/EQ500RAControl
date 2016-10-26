# EQ500RAControl
Right Ascension axis control for an Omegon Dual Axis Drive control, installed in EQ5 like mounts. The solution is developed with MCU 8051 IDE. 
#Comments
- It is loaded in an Atmel AT89C2051 microcontroller, inside the handset control delivered with the motor kit.
- It is tested on a Vixen GP2 Mount.
- It solves a problem that comes with the motor drive; reversing at 1x speed the RA motor should be stopped (so you only see the natural movement of the stars, in their apparent movement during the night), instead of doing nothing.