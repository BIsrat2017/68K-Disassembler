*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
CR      EQU     $0D
LF      EQU     $0A   
        INCLUDE 'ASCII_HEX_Conversions.x68'
START:  ORG     $1000                

* Put program code here
*------Code for output-------
        
        LEA     MESSAGE,A1      *Code block for first message
        MOVE.B  #14,D0
        TRAP    #15
       
INV_INPUT  
     
        MOVEA.L #$4000, A1
        MOVE.B  #2,D0           *Code block for reading input
        TRAP    #15   
        MOVE.W  D1,D0
        
        MOVEA.L A1,A0           *Move the contents of A1 to A0 for the conversion
        JSR     A2H             *Branch to Connor's code
        
MESSAGE DC.B    'Enter a number: ',0

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
