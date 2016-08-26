;====================================================================
; DEFINITIONS
;====================================================================

	  ClkRevX1	equ P1.2
	  ClkRevX8	equ P3.1
	  ClkRevX32	equ P3.3
	  ClkFwdX1	equ P1.3
	  ClkFwdX8	equ P3.0
	  ClkFwdX32	equ P3.2
	  RedLed	equ P3.4
	  Preset	equ 3ah
	  Step1		equ 40h
	  Step2		equ 41h
	  Step3		equ 42h
	  Step4		equ 43h
	  HStep1 	equ 44h
	  HStep2 	equ 45h
	  HStep3 	equ 46h
	  HStep4 	equ 47h
;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
      org   0000h
      jmp   Start

;====================================================================
; CODE SEGMENT
;====================================================================

      org   0100h
Start:
      ; Write your code here
	  mov	TMOD, #10H			;Set up timer 1 as 16-bit interval timer
	  mov 	Step1, #11101111b 		;Set wave step for north pole
	  mov 	Step2, #10111111b
	  mov 	Step3, #01111111b
	  mov 	Step4, #11011111b
	  mov 	HStep1, #01011111b		;Set full step for south pole
	  mov 	HStep2, #11001111b
	  mov 	HStep3, #10101111b
	  mov 	HStep4, #00111111b
	  jb	P3.7, Loop			;If we go beyond here we are at the South Pole!
	  mov 	Step1, #11011111b 		;Set wave step for south pole
	  mov 	Step2, #01111111b
	  mov 	Step3, #10111111b
	  mov 	Step4, #11101111b
	  mov 	HStep1, #00111111b		;Set full step for north pole
	  mov 	HStep2, #10101111b
	  mov 	HStep3, #11001111b
	  mov 	HStep4, #01011111b
 Loop: 						;Start sidereal rate and loop it (we are following the stars at this rate)
	  jnb	ClkRevX1, RevX1			;First of all, check if any button is pressed
	  jnb	ClkRevX8, RevX8tmp
	  jnb	ClkRevX32, RevX32tmp
	  jnb	ClkFwdX1, FwdX1
	  jnb	ClkFwdX8, FwdX8tmp
	  jnb	ClkFwdX32, FwdX32tmp
	  setb 	RedLed				;Enable the LED, as no button is pressed
	  mov	P1, Step1			;Insert first step...
	  acall Delay				;... and wait for the delay to gon on
	  jnb	ClkRevX1, RevX1			;Same process for second step
	  jnb	ClkRevX8, RevX8tmp
	  jnb	ClkRevX32, RevX32tmp
	  jnb	ClkFwdX1, FwdX1
	  jnb	ClkFwdX8, FwdX8tmp
	  jnb	ClkFwdX32, FwdX32tmp
	  mov	P1, Step2
	  acall Delay
	  jnb	ClkRevX1, RevX1			;Same process for third step
	  jnb	ClkRevX8, RevX8tmp
	  jnb	ClkRevX32, RevX32tmp
	  jnb	ClkFwdX1, FwdX1
	  jnb	ClkFwdX8, FwdX8tmp
	  jnb	ClkFwdX32, FwdX32tmp
	  mov	P1, Step3
	  acall Delay				;Same process for fourth step
	  jnb	ClkRevX1, RevX1
	  jnb	ClkRevX8, RevX8tmp
	  jnb	ClkRevX32, RevX32tmp
	  jnb	ClkFwdX1, FwdX1
	  jnb	ClkFwdX8, FwdX8tmp
	  jnb	ClkFwdX32, FwdX32tmp
	  mov	P1, Step4
 	  acall Delay
	  jmp 	Loop

RevX8tmp:	jmp RevX8 			;As jnb is a short jump, we add a intermediate step
RevX32tmp:	jmp RevX32
FwdX8tmp:	jmp FwdX8
FwdX32tmp: 	jmp FwdX32

RevX1:
	  acall	Delayx32			;Insert a few delay to avoid button bounce
	  clr	RedLed 				;Clear LED and...
	  mov	P1, #11111111b	  		;Stop motor (reversal at x1 speed plus forward at sidereal, earth, speed)
	  jmp 	Loop
FwdX1:
	  clr	RedLed				;First clear LED, then start the movement sequence
	  acall Delayx2				;For every step, ensure that we keep pressing button and wait for the delay
	  jb	ClkFwdX1, Skip
	  mov	P1, HStep1
	  acall Delayx2				;Same for second step
	  jb	ClkFwdX1, Skip
	  mov	P1, HStep2
	  acall Delayx2				;Same for third step
	  jb	ClkFwdX1, Skip
	  mov	P1, HStep3
	  acall Delayx2				;Same for fourth step
	  jb	ClkFwdX1, Skip
	  mov	P1, HStep4
Skip:
	  jmp	Start
RevX8:
	  clr	RedLed				;First clear LED, then start the movement sequence
	  acall Delayx8
	  mov	P1, HStep4
	  acall Delayx8
	  mov	P1, HStep3
	  acall Delayx8
	  mov	P1, HStep2
	  acall Delayx8
	  mov	P1, HStep1
	  jmp	Start
FwdX8:
	  clr	RedLed				;First clear LED, then start the movement sequence
	  acall Delayx8
	  mov	P1, HStep1
	  acall Delayx8
	  mov	P1, HStep2
	  acall Delayx8
	  mov	P1, HStep3
	  acall Delayx8
	  mov	P1, HStep4
	  jmp	Start
RevX32:
	  clr	RedLed				;First clear LED, then start the movement sequence
	  acall Delayx32
	  mov	P1, HStep4
	  acall Delayx32
	  mov	P1, HStep3
	  acall Delayx32
	  mov	P1, HStep2
	  acall Delayx32
	  mov	P1, HStep1
	  jmp	Start
FwdX32:
	  clr	RedLed				;First clear LED, then start the movement sequence
	  acall Delayx32
	  mov	P1, HStep1
	  acall Delayx32
	  mov	P1, HStep2
	  acall Delayx32
	  mov	P1, HStep3
	  acall Delayx32
	  mov	P1, HStep4
	  jmp	Start

;Delay section, for each speed
Delay:
	  clr	TR1 				;Stop timer 1 (in case it was started in some other subroutine)
	  mov	TH1, #86H
	  mov	TL1, #0F5H 			;Load 34.518 (86D6h) into timer 1, to reach 103.98ms at 3.579545Mhz (finally 86F5h is closer)
	  setb	TR1 				;Start timer 1
	  jnb 	TF1, $				;Repeat this line while timer 1 overflow flag is not set
	  clr 	TF1				;Timer 1 overflow flag is set by hardware on transition from FFFFH - the flag must be reset by software
	  clr 	TR1 				;Stop timer 1
	  ret

Delayx2:
	  clr	TR1 				;Stop timer 1 (in case it was started in some other subroutine)
	  mov	TH1, #0C3H
	  mov	TL1, #098H 			;Load 50.027 (C398h) into timer 1, to reach about 51ms at 3.579545Mhz
	  setb	TR1 				;Start timer 1
	  jnb 	TF1, $				;Repeat this line while timer 1 overflow flag is not set
	  clr 	TF1				;Timer 1 overflow flag is set by hardware on transition from FFFFH - the flag must be reset by software
	  clr 	TR1 	  			;Stop timer 1
	  ret

Delayx8:
	  clr	TR1 				;Stop timer 1 (in case it was started in some other subroutine)
	  mov	TH1, #0F0H
	  mov	TL1, #0DAH 			;Set Delay for x8 speed
	  setb	TR1 				;Start timer 1
	  jnb 	TF1, $				;Repeat this line while timer 1 overflow flag is not set
	  clr 	TF1				;Timer 1 overflow flag is set by hardware on transition from FFFFH - the flag must be reset by software
	  clr 	TR1 	  			;Stop timer 1
	  ret

Delayx32:
	  clr	TR1 				;Stop timer 1 (in case it was started in some other subroutine)
	  mov	TH1, #0FCH
	  mov	TL1, #036H 			;Set Delay for x32
	  setb	TR1 				;Start timer 1
	  jnb 	TF1, $				;Repeat this line while timer 1 overflow flag is not set
	  clr 	TF1				;Timer 1 overflow flag is set by hardware on transition from FFFFH - the flag must be reset by software
	  clr 	TR1 	  			;Stop timer 1
	  ret

;====================================================================
      END
