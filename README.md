# EQ500RAControl
Right Ascension axis control for an Omegon Dual Axis Drive control, installed in EQ5 like mounts. The solution is developed with MCU 8051 IDE. 

- It is loaded in an Atmel AT89C2051 microcontroller, inside the handset control delivered with the motor kit.
- It is tested on a Vixen GP2 Mount.
- It solves a problem that comes with the motor drive; reversing at 1x speed the RA motor should be stopped (so you only see the natural movement of the stars, in their apparent movement during the night), instead of doing nothing.

It is calculated to move a mount and motors with following specifications;
- Step motor: 48 steps per revolution
- Reduction ratio: 1/120
- Number of teeths of the mount: 144

Taking into account that the sidereal time is of 86164.1 seconds, it means that we have to send a step to the motors every 103.88ms
