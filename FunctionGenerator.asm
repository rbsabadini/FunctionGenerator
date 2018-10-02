;-------------------------------------------------------------------------------
; title: function generator (square, triangle and sine)
;-------------------------------------------------------------------------------

#include "PIC16F887.INC"
    
    __CONFIG _CONFIG_1, _INTOSCIO & _WDTE_OFF & _PWRTE_ON & _CP_OFF & _LVP_OFF
    
    
		    CBLOCK		H'20'
		    W_TEMP
		    STATUS_TEMP
		    COUNTER
		    ENDC

;---- INPUT --------------------------------------------------------------------		    
		    
#define		    BUTTON_INC		PORTD, RD0
#define		    BUTTON_DEC		PORTD, RD1
#define		    BUTTON_F_RANGE	PORTD, RD2
		    
;---- OUTPUT --------------------------------------------------------------------		    
		    
#define		    LED_PSC16_GREEN	PORTD, RD3
#define		    LED_PSC4_YELLOW	PORTD, RD4
#define		    LED_PSC1_RED	PORTD, RD5		    
		    		    
;---- RESET VECTOR -------------------------------------------------------------
		    ORG			H'0000'
		    GOTO		setup
		    
;----- INTERRUPT VECTOR --------------------------------------------------------
		    ORG		        H'0004'
			
			
;----- SAVING CONTEXT ----------------------------------------------------------
			
		    MOVWF		W_TEMP					; Copy W to TEMP register
		    SWAPF		STATUS,W				; Swap status to be saved into W										; Swaps are used because they do not affect the status bits
		    MOVWF	        STATUS_TEMP			        ; Save status to bank zero STATUS_TEMP register
						
;----- INTERRUPT SERVICE ROUTINE -----------------------------------------------
			
		    BTFSS		INTCON,2
		    GOTO		exit_ISR
		    BCF			INTCON,2				
		    
		    BTFSS		BUTTON_INC
		    CALL		inc_PWM					;When the button 1 is pressed the signal will increase the frequency of the signal
		    
		    BTFSS		BUTTON_DEC
		    CALL		dec_PWM					;When the button 2 is pressed the signal will decrease the frequency
		    			
		    BTFSS		BUTTON_F_RANGE
		    CALL		range_selecting
		    
;----- EXITING INTERRUPT SERVICE ROUTINE ---------------------------------------
exit_ISR:			
	
		    SWAPF		STATUS_TEMP,W				; Swap STATUS_TEMP register into W
										; (sets bank to original state)
		    MOVWF		STATUS					; Move W into STATUS register
		    SWAPF		W_TEMP,f				; Swap W_TEMP
		    SWAPF	        W_TEMP,w				; Swap W_TEMP into W
    
		    RETFIE	    
		    
;---- SETUP --------------------------------------------------------------------
setup:
		    BSF			STATUS, RP0
		    MOVLW		H'70'
		    MOVWF		OSCCON
		    
		    CALL		setup_buttons
		    CALL		setup_PWM
		    CALL		setup_TMR0
		    CALL		setup_output
		    
		    
		    MOVLW		H'00'
		    MOVWF		COUNTER
		    
loop:
    
		    GOTO		$

;---- SUBROTINE ----------------------------------------------------------------

;------------------------------------------------------------------------------;
;		    BEGINNING OF THE CODE FOR SQUARE SIGNAL		       ;
;------------------------------------------------------------------------------;
range_selecting:
		
		    BCF			STATUS, RP0
		    BCF			STATUS, RP1
    
		    INCF		COUNTER
    
		    MOVLW		H'04'
		    XORWF		COUNTER, W
		    BTFSS		STATUS, Z
		    GOTO		exit_ISR
		    
		    MOVLW		H'00'
		    MOVWF		COUNTER
		    
		    
		    
		    MOVLW		H'07'
		    XORWF		T2CON, W
		    BTFSC		STATUS, Z
		    GOTO		PSC_1
		    
		    MOVLW		H'04'
		    XORWF		T2CON, W
		    BTFSC		STATUS, Z
		    GOTO		PSC_4
		    
		    MOVLW		H'05'
		    XORWF		T2CON, W
		    BTFSC		STATUS, Z
		    GOTO		PSC_16
		   
		    RETURN
		    
PSC_1:	
		    MOVLW		H'04'
		    MOVWF		T2CON
		    
		    BCF			LED_PSC16_GREEN
		    BSF			LED_PSC1_RED
		    		    
		    GOTO		exit_ISR
		    
PSC_4:	
		    MOVLW		H'05'
		    MOVWF		T2CON
		    
		    BCF			LED_PSC1_RED
		    BSF			LED_PSC4_YELLOW
		    
		    GOTO		exit_ISR
		    
PSC_16:	
		    MOVLW		H'07'
		    MOVWF		T2CON
		    
		    BCF			LED_PSC4_YELLOW
		    BSF			LED_PSC16_GREEN
		    
		    GOTO		exit_ISR		    
		    
		    
inc_PWM:
		    BSF			STATUS, RP0
		    BCF			STATUS, RP1
    
		    MOVLW		H'FF'
		    XORWF		PR2, W
		    BTFSS		STATUS, Z
		    CALL		inc_PR2
    
		    BCF			STATUS, RP0
		    
		    RETURN
		    
inc_PR2:
		    INCF		PR2
		    
		    BCF			STATUS, RP0
		    
		    MOVLW		H'2C'
		    XORWF		CCP1CON, W
		    
		    BTFSC		STATUS, Z
		    GOTO		inc_CCP1CON_CCPR1L
		    
		    MOVLW		H'2C'
		    MOVWF		CCP1CON
		    
		    RETURN
		    
inc_CCP1CON_CCPR1L:
    
		    INCF		CCPR1L
		    MOVLW		H'0C'
		    MOVWF		CCP1CON
		    
		    GOTO		exit_ISR
dec_PWM:
    
		    BSF			STATUS, RP0
		    BCF			STATUS, RP1
    
		    MOVLW		H'00'
		    XORWF		PR2, W
		    BTFSS		STATUS, Z
		    CALL		dec_PR2
    
		    BCF			STATUS, RP0
		    
		    RETURN
		    
dec_PR2:		
		    DECF		PR2
		    
		    BCF			STATUS, RP0
		    
		    MOVLW		H'2C'
		    XORWF		CCP1CON, W
		    
		    BTFSS		STATUS, Z
		    GOTO		dec_CCP1CON_CCPR1L
		    
		    MOVLW		H'0C'
		    MOVWF		CCP1CON
		    
		    RETURN
		    
dec_CCP1CON_CCPR1L:
		    DECF		CCPR1L
		    MOVLW		H'2C'
		    MOVWF		CCP1CON
    
		    GOTO		exit_ISR
;------------------------------------------------------------------------------;
;		    END OF THE CODE FOR SQUARE SIGNAL			       ;
;------------------------------------------------------------------------------;		    
		    
setup_buttons:
		    BSF			STATUS, RP0
		    BCF			STATUS, RP1
		    
		    MOVLW		H'FF'
		    MOVWF		TRISD
		    
		    BCF			STATUS, RP0
		    
		    RETURN
		    
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
	
		    RETURN
		    
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
		    
		    MOVLW		H'07'					; Using prescaler of 16 and turn on the timer2
		    MOVWF		T2CON
		    
		    BSF			LED_PSC16_GREEN
		    
		    RETURN
		    
setup_output:
		    BSF			STATUS, RP0
		    BCF			STATUS, RP1
		    
		    MOVLW		H'C7'
		    MOVWF		TRISD
			
		    BCF			STATUS, RP0
		    
		    RETURN
		    
		    END