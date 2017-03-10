*-----------------------------------------------------------
* Title      : Main Driver Program
* Written by : Arsany Azmy, Connor McGwire
* Date       :
* Description:
*-----------------------------------------------------------
CR      EQU     $0D
LF      EQU     $0A   
        INCLUDE 'ASCII_HEX_Conversions.x68'
        INCLUDE 'opcodes.x68'
        
MESSAGE     DC.B    'Enter the address of compiled code: ',0
ERROR_MSG   DC.B    'Invalid input, please rerun',0
SPACER      DC.B    ' ',0


        ORG     $1000
program_start        


*------Code for input-------
        
        LEA     MESSAGE,A1      *Code block for first message
        MOVE.B  #14,D0
        TRAP    #15
       
        MOVEA.L #$4000, A1
        MOVE.B  #2,D0           *Code block for reading input
        TRAP    #15   
        MOVE.W  D1,D0
        
        MOVEA.L A1,A0           *Move the contents of A1 to A0 for the conversion
        JSR     A2H             *Branch to Connor's conversion code      
        
        MOVEA.L D0,A0
        
        CMPI.W  #$FFFF,(A0)
        BEQ     input_error
    
loop_start
        
        MOVE.L  A0,D1           *Print out the address we're working on
        MOVE.L  #16,D2          
        MOVE.L  #15,D0          
        TRAP    #15

        MOVE.L  #14,D0
        LEA     SPACER,A1
        TRAP    #15
        
        MOVE.W  (A0)+,D2
        CMPI.W  #$FFFF,D2
        BEQ     Done
        
        JSR     OpDecoder
        
        MOVE.L  #13,D0
        TRAP    #15
        
        BRA     loop_start
        
input_error        
        MOVE.L  #13,D0
        LEA     ERROR_MSG,A1
        TRAP    #15
Done        

        END    $1000







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
