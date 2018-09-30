;-------------------------------------------------------------------------------
; title: function generator (square, triangle and sine)
;-------------------------------------------------------------------------------

#include "PIC16F887.INC"
    
    __CONFIG _CONFIG_1, _INTOSCIO & _WDTE_OFF & _PWRTE_ON & _CP_OFF & _LVP_OFF
    
    
		    
;---- RESET VECTOR -------------------------------------------------------------
		    ORG			H'0000'
		    GOTO		setup
		    
		    
		    
;---- SETUP --------------------------------------------------------------------
setup:
		    BSF			STATUS, RP0
		    MOVLW		H'70'
		    MOVWF		OSCCON
		    
		    CALL		setup_PWM
		    
		    
loop:
    
		    goto		$

;---- SUBROTINE ----------------------------------------------------------------
setup_PWM:  
		    BSF			STATUS, RP0
		    BCF			STATUS, RP1
		    
		    MOVLW		H'7C'
		    MOVWF		PR2
		    MOVLW		H'FB'
		    MOVWF		TRISC
		    
		    BCF			STATUS, RP0
		    
		    MOVLW		H'2C'
		    MOVWF		CCP1CON
		    MOVLW		H'3E'
		    MOVWF		CCPR1L
		    
		    MOVLW		H'07'
		    MOVWF		T2CON
		    
		    RETURN
		    
		    
		    END