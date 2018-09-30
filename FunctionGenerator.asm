;-------------------------------------------------------------------------------
; title: function generator (square, triangle and sine)
;-------------------------------------------------------------------------------

#include "PIC16F887.INC"
    
    __CONFIG _CONFIG_1, _INTOSCIO & _WDTE_OFF & _PWRTE_ON & _CP_OFF & _LVP_OFF
    
    
		    CBLOCK		H'20'
		    W_TEMP
		    STATUS_TEMP
		    ENDC
    
		    
;---- RESET VECTOR -------------------------------------------------------------
		    ORG			H'0000'
		    GOTO		setup
		    
;----- INTERRUPT VECTOR --------------------------------------------------------
		    ORG		        H'0004'
			
			
;----- SAVING CONTEXT ----------------------------------------------------------
			
		    MOVWF		W_TEMP				; Copy W to TEMP register
		    SWAPF		STATUS,W				; Swap status to be saved into W										; Swaps are used because they do not affect the status bits
		    MOVWF	        STATUS_TEMP			        ; Save status to bank zero STATUS_TEMP register
						
;----- INTERRUPT SERVICE ROUTINE -----------------------------------------------
			
		    BTFSS		INTCON,2
		    GOTO		exit_ISR
		    BCF			INTCON,2
				
;----- EXITING INTERRUPT SERVICE ROUTINE ---------------------------------------
exit_ISR:			
	
		    SWAPF		STATUS_TEMP,W			; Swap STATUS_TEMP register into W
										; (sets bank to original state)
		    MOVWF		STATUS				; Move W into STATUS register
		    SWAPF		W_TEMP,f				; Swap W_TEMP
		    SWAPF	        W_TEMP,w				; Swap W_TEMP into W
    
		    RETFIE	    
		    
;---- SETUP --------------------------------------------------------------------
setup:
		    BSF			STATUS, RP0
		    MOVLW		H'70'
		    MOVWF		OSCCON
		    
		    CALL		setup_PWM
		    CALL		setup_TMR0
		    
loop:
    
		    GOTO		$

;---- SUBROTINE ----------------------------------------------------------------
setup_TMR0:
		    BSF			STATUS, RP0
		    BCF			STATUS, RP1
		    
		    MOVLW		H'D7'
		    MOVWF		OPTION_REG
		    
		    BCF			STATUS, RP0
		    
		    MOVLW		H'A0'
		    MOVWF		INTCON
		    
		    MOVLW		H'00'
		    MOVWF		TMR0
		    return
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