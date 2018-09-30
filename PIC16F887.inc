;---- BANK 0 -------------------------------------------------------------------

TMR0		    EQU			H'01'
STATUS		    EQU			H'03'
PORTD		    EQU			H'08'
INTCON		    EQU			H'0B'
T2CON		    EQU			H'12'		    
CCPR1L		    EQU			H'15'
CCP1CON		    EQU			H'17'		    
		  
;---- BANK 1 -------------------------------------------------------------------
		  
OPTION_REG	    EQU			H'81'
TRISC		    EQU			H'87'	    
TRISD		    EQU			H'88'	    
OSCCON		    EQU			H'8F'	    
PR2		    EQU			H'92'
		    
;---- STATUS BITS --------------------------------------------------------------

C		    EQU			H'00'
DC		    EQU			H'01'
Z		    EQU			H'02'
PD		    EQU			H'03'
TO		    EQU			H'04'		    
RP0		    EQU			H'05'
RP1		    EQU			H'06'
IRP		    EQU			H'07'
		    
;------------------------------------------------------------------------------;
;									       ;
;			    CONFIGURATION BITS				       ;
;									       ;
;------------------------------------------------------------------------------;
			
_CONFIG_1	    EQU			H'2007'

_CP_OFF		    EQU			H'3FBF'
_PWRTE_ON	    EQU			H'3FEF'
_WDTE_OFF	    EQU			H'3FF7'
_INTOSCIO	    EQU			H'3FFC'	
_LVP_OFF	    EQU			H'2FFF'		

		    
		    
