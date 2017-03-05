*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
MEM             EQU	$00007000  
stack           EQU  $0000E000 

MOVE_B          EQU %0001
MOVE_W          EQU %0011
MOVE_L          EQU %0010
MOVEA_WL        EQU %001 
MOVEQ_          EQU %0111
MOVEM_TO_MEM_W  EQU %0100100010
MOVEM_TO_MEM_L  EQU %0100100011
MOVEM_TO_REG_W  EQU %0100110010
MOVEM_TO_REG_L  EQU %0100110011

ADDI_B          EQU %0000011000
ADDI_W          EQU %0000011001
ADDI_L          EQU %0000011010

    ORG    $1000

START:   LEA  stack, SP               ; first instruction of program

* Put program code here
   
    MOVEA.L #MEM,A2
    MOVE.B  (A2)+,D2    * D2 will store current byte
    JSR     CHECK_MOVE_AND_MOVEA_AND_MOVEQ
    JSR     ReadSecondByte
    JSR     Check_MOVEM
    JSR     Check_ADDI
    
    SIMHALT             ; halt simulator

* Put variables and constants here
*****************************
ReadFirstFourBits

    MOVE.B      #4,D7    
    ROR.W       D7,D2 
    RTS
    
*************************
ResetFirstFourBits
    
    MOVE.B      #4,D7
    ROL.W       D7,D2
    RTS

*************************
ReadSecondByte

    MOVE.B      #8,D7
    LSL.W       D7,D2               * 00000012 -> 00001200
    MOVE.B      (A2)+,D2            * 00001200 -> 00001234
    RTS
    
*************************

CHECK_MOVE_AND_MOVEA_AND_MOVEQ

    JSR     ReadFirstFourBits
    
    MOVE.B      #MOVE_B,D6
    CMP.B       D2,D6
    BEQ         MATCH_MOVE_B
    
    MOVE.B      #MOVE_W,D6
    CMP.B       D2,D6
    BEQ         CHECK_MOVEA_W
    
    MOVE.B      #MOVE_L,D6
    CMP.B       D2,D6
    BEQ         CHECK_MOVEA_L
 
    MOVE.B      #MOVEQ_,D6
    CMP.B       D2,D6
    BEQ         MATCH_MOVEQ
    
    JSR         ResetFirstFourBits
    RTS
***********************************    
CHECK_MOVEM
    
    MOVEM.W     D2, -(SP)
    LSR.W       #6,D2                       * ISOLATE OPCODE
    
    MOVE.W      #MOVEM_TO_MEM_W,D6
    CMP.W       D2,D6
    BEQ         MATCH_MOVEM_TO_MEM_W
    
    MOVE.W      #MOVEM_TO_MEM_L,D6
    CMP.W       D2,D6
    BEQ         MATCH_MOVEM_TO_MEM_L
    
    MOVE.W      #MOVEM_TO_REG_W,D6
    CMP.W       D2,D6
    BEQ         MATCH_MOVEM_TO_REG_W
    
    MOVE.W      #MOVEM_TO_REG_L,D6
    CMP.W       D2,D6
    BEQ         MATCH_MOVEM_TO_REG_L
    
    MOVEM.W     (SP)+,D2 
    RTS
****************************************   
CHECK_ADDI

    MOVEM.W     D2, -(SP)
    LSR.W       #6,D2                       * ISOLATE OPCODE
    
    MOVE.W      #ADDI_B,D6
    CMP.W       D2,D6
    BEQ         MATCH_ADDI_B
    
    MOVE.W      #ADDI_W,D6
    CMP.W       D2,D6
    BEQ         MATCH_ADDI_W
    
    MOVE.W      #ADDI_L,D6
    CMP.W       D2,D6
    BEQ         MATCH_ADDI_L
    
    MOVEM.W     (SP)+,D2 
    RTS
*****************************************
    
CHECK_MOVEA_W

    JSR         ResetFirstFourBits
    JSR         ReadSecondByte
    
    JSR         ISOLATE_MOVEA_CODE
       
    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_W 
    JMP         MATCH_MOVE_W 
************************************************
ISOLATE_MOVEA_CODE 
    MOVEM.W     D2, -(SP)       * save d2 in current state   
    MOVE.B      #7,D7
    LSL.W       D7,D2
    MOVE.B      #13,D7
    LSR.W       D7,D2
    MOVE.B      D2,D3           * isolated movea code saved in d3
    MOVEM.W     (SP)+,D2 
    RTS
**********************************************
CHECK_MOVEA_L

    JSR          ResetFirstFourBits
    JSR          ReadSecondByte
    
    JSR         ISOLATE_MOVEA_CODE
       
    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_L
    JMP         MATCH_MOVE_L   
**********************************************   
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
MATCH_MOVEQ
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEM_TO_MEM_W
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEM_TO_MEM_L
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEM_TO_REG_W
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEM_TO_REG_L
    MOVE.W      D2,D5       *REMOVE
MATCH_ADDI_B
    MOVE.W      D2,D5       *REMOVE
MATCH_ADDI_W
    MOVE.W      D2,D5       *REMOVE
MATCH_ADDI_L
    MOVE.W      D2,D5       *REMOVE
    
    END    START        ; last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
