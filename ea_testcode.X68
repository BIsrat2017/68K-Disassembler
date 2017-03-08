*-----------------------------------------------------------
* Title      : EA Decoder Test
* Written by : Connor McGwire
* Date       : 3/7/2017
* Description: Tests effective addressing subroutine
*-----------------------------------------------------------

        INCLUDE 'EADecoder.x68'

blank   DC.B    '',0

        ORG     $3000
        
start   
        ** Test non-immediate ea modes
        
        *Test direct register
        MOVE.B  #%00000101,D0
        JSR     EADecoder
        
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test direct register left
        MOVE.B  #%00101000,D0
        JSR     EADecoder_left
        
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test address register
        MOVE.B  #%00001000,D0
        JSR     EADecoder
        
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test indirect addressing
        MOVE.B  #%00010010,D0
        JSR     EADecoder
        
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test Post Increment
        MOVE.B  #%00011110,D0
        JSR     EADecoder
        
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test Pre Decrement
        MOVE.B  #%00100011,D0
        JSR     EADecoder
        
*************************************************
        
        ** Test immediate ea modes **
        
        *Load test data into memory
        MOVEA.L #$00005000,A0
        MOVE.W  #$782A,(A0)+
        MOVE.L  #$1111AAAA,(A0)+
        MOVEA.L #$00005000,A0
        
        *Print new line
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test immediate addressing with size BYTE or WORD
        MOVE.B  #%00111100,D0
        MOVE.B  #2,D1
        JSR     EADecoder
        
        *Print new line
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test immediate addressing with size LONG
        MOVE.B  #%00111100,D0
        MOVE.B  #4,D1
        JSR     EADecoder
        
        *Reset test data pointer
        MOVEA.L #$00005000,A0
        
        *Print new line
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test absolute addressing of size WORD
        MOVE.B  #%00111001,D0
        JSR     EADecoder
        
        *Print new line
        MOVE.B  #13,D0
        LEA     blank,A1
        TRAP    #15
        
        *Test absolute addressing of size LONG
        MOVE.B  #%00111001,D0
        JSR     EADecoder
        
        END     $3000

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
