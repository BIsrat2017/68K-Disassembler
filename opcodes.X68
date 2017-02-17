*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
MEM    EQU	$00007000  
stack  EQU  $0000E000 

MOVE_B  EQU %0001
MOVE_W  EQU %0011
MOVE_L  EQU %0010
MOVEA_WL   EQU %001 

    ORG    $1000

START:   LEA  stack, SP               ; first instruction of program

* Put program code here
   
    MOVEA.L #MEM,A2
    MOVE.B  (A2)+,D2    * D2 will store current byte
    JSR     ReadFirstFourBits
    
    SIMHALT             ; halt simulator

* Put variables and constants here
ReadFirstFourBits

    MOVE.B      #4,D7    
    ROR.W       D7,D2 
    JMP         CHECK_MOVE
    RTS

CHECK_MOVE
    MOVE.B      #MOVE_B,D6
    CMP.B       D2,D6
    BEQ         MATCH_MOVE_B
    MOVE.B      #MOVE_W,D6
    CMP.B       D2,D6
    BEQ         CHECK_MOVEA_W
    MOVE.B      #MOVE_L,D6
    CMP.B       D2,D6
    BEQ         CHECK_MOVEA_L
    
CHECK_MOVEA_W
    ROL.W       D7,D2           * reset first 8 bits
    MOVE.B      #8,D7 
    LSL.W       D7,D2           * Move first 8 bits to left to clear room for next 8
    MOVE.B      (A2)+,D2        * Add next 8 to D2 (16 bits in order now)
    
    JSR         ISOLATE_MOVEA_CODE
       
    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_W 
    JMP         MATCH_MOVE_W 

ISOLATE_MOVEA_CODE 
    MOVEM.W     D2, -(SP)       * save d2 in current state   
    MOVE.B      #7,D7
    LSL.W       D7,D2
    MOVE.B      #13,D7
    LSR.W       D7,D2
    MOVE.B      D2,D3           * isolated movea code saved in d3
    MOVEM.W     (SP)+,D2 
    RTS

CHECK_MOVEA_L
    ROL.W       D7,D2           * reset first 8 bits
    MOVE.B      #8,D7 
    LSL.W       D7,D2           * Move first 8 bits to left to clear room for next 8
    MOVE.B      (A2)+,D2        * Add next 8 to D2 (16 bits in order now)
    
    JSR         ISOLATE_MOVEA_CODE
       
    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_L
    JMP         MATCH_MOVE_L   
    
MATCH_MOVE_B
    MOVE.B      D2,D5       *REMOVE
MATCH_MOVE_W
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVE_L
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEA_W
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEA_L
    MOVE.W      D2,D5       *REMOVE



    
    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
