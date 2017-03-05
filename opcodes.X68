*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
MEM             EQU	$00007000  
stack           EQU  $0000E000 

NOP             EQU $4E71
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

ADD             EQU %1101
ADD_TO_REG_B    EQU %000
ADD_TO_REG_W    EQU %001
ADD_TO_REG_L    EQU %010
ADD_TO_EA_B     EQU %100
ADD_TO_EA_W     EQU %101
ADD_TO_EA_L     EQU %110

    ORG    $1000

START:   LEA  stack, SP               ; first instruction of program

* Put program code here
   
    MOVEA.L #MEM,A2
    MOVE.W  (A2)+,D2    * D2 will store current byte
    JSR     CHECK_NOP
    JSR     CHECK_MOVE_AND_MOVEA_AND_MOVEQ
    JSR     Check_MOVEM
    JSR     Check_ADDI
    
    SIMHALT             ; halt simulator

* Put variables and constants here
*****************************
ReadFirstFourBits

    MOVEM.W     D2, -(SP)

    MOVE.B      #12,D7 
    LSR.W       D7,D2 
    MOVE.B      D2,D3
    
    MOVEM.W     (SP)+,D2
    RTS
    
*************************
ReadFirstTenBits
    
    MOVEM.W     D2, -(SP)
 
    LSR.W       #6,D2 
    MOVE.W      D2,D3
    
    MOVEM.W     (SP)+,D2
    RTS
*************************
CHECK_NOP
    
    MOVE.W      #NOP,D6
    CMP.W       D2,D6
    BEQ         MATCH_NOP
    RTS
*************************
CHECK_MOVE_AND_MOVEA_AND_MOVEQ

    JSR     ReadFirstFourBits
    
    MOVE.B      #MOVE_B,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVE_B
    
    MOVE.B      #MOVE_W,D6
    CMP.B       D3,D6
    BEQ         CHECK_MOVEA_W_AND_MOVE_W
    
    MOVE.B      #MOVE_L,D6
    CMP.B       D3,D6
    BEQ         CHECK_MOVEA_L_AND_MOVE_L
 
    MOVE.B      #MOVEQ_,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEQ
    
    MOVE.B      #ADD,D6
    CMP.B       D3,D6
    BEQ         CHECK_ADD
    
    RTS
***********************************    
CHECK_MOVEM
    
    JSR         ReadFirstTenBits
    
    MOVE.W      #MOVEM_TO_MEM_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_MOVEM_TO_MEM_W
    
    MOVE.W      #MOVEM_TO_MEM_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_MOVEM_TO_MEM_L
    
    MOVE.W      #MOVEM_TO_REG_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_MOVEM_TO_REG_W
    
    MOVE.W      #MOVEM_TO_REG_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_MOVEM_TO_REG_L
    
    RTS
**************************************** 
CHECK_ADD
    
    JSR         IOSLATE_OP_CODE
    
    MOVE.W      #ADD_TO_REG_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_REG_B
    
    MOVE.W      #ADD_TO_REG_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_REG_W
    
    MOVE.W      #ADD_TO_REG_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_REG_L
    
    MOVE.W      #ADD_TO_EA_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_EA_B
    
    MOVE.W      #ADD_TO_EA_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_EA_W
    
    MOVE.W      #ADD_TO_EA_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_EA_L
    
    RTS
****************************************  
CHECK_ADDI

    JSR         ReadFirstTenBits
    
    MOVE.W      #ADDI_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDI_B
    
    MOVE.W      #ADDI_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDI_W
    
    MOVE.W      #ADDI_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDI_L
    
    RTS
*****************************************
    
CHECK_MOVEA_W_AND_MOVE_W
    
    JSR         ISOLATE_OP_CODE
       
    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_W
    
    JMP         MATCH_MOVE_W 
************************************************
ISOLATE_OP_CODE 
    MOVEM.W     D2, -(SP)       
    MOVE.B      #7,D7          
    LSL.W       D7,D2
    MOVE.B      #13,D7
    LSR.W       D7,D2
    MOVE.B      D2,D3           
    MOVEM.W     (SP)+,D2 
    RTS
**********************************************
CHECK_MOVEA_L_AND_MOVE_L
    
    JSR         ISOLATE_OP_CODE
       
    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_L 
    
    JMP         MATCH_MOVE_L   
**********************************************  
MATCH_NOP
    MOVE.B      D2,D5       *REMOVE
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
MATCH_ADD_TO_REG_B
    MOVE.W      D2,D5       *REMOVE
MATCH_ADD_TO_REG_W
    MOVE.W      D2,D5       *REMOVE
MATCH_ADD_TO_REG_L
    MOVE.W      D2,D5       *REMOVE
MATCH_ADD_TO_EA_B
    MOVE.W      D2,D5       *REMOVE
MATCH_ADD_TO_EA_W
    MOVE.W      D2,D5       *REMOVE
MATCH_ADD_TO_EA_L 
    MOVE.W      D2,D5       *REMOVE
    
    END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
