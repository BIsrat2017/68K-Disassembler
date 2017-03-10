*-----------------------------------------------------------
* Title      : OpDecoder
* Written by : Spencer Milner, Connor McGwire
* Date       :
* Description:
*-----------------------------------------------------------

NOP             EQU $4E71
MOVE_B          EQU %0001
MOVE_W          EQU %0011
MOVE_L          EQU %0010
MOVEA_WL        EQU %001
MOVEQ_          EQU %0111

ADDI_B          EQU %0000011000
ADDI_W          EQU %0000011001
ADDI_L          EQU %0000011010

ADD_ADDA        EQU %1101
ADD_TO_REG_B    EQU %000
ADD_TO_REG_W    EQU %001
ADD_TO_REG_L    EQU %010
ADD_TO_EA_B     EQU %100
ADD_TO_EA_W     EQU %101
ADD_TO_EA_L     EQU %110
ADDA_W          EQU %011
ADDA_L          EQU %111

ADDQ            EQU %0101
ADDQ_B          EQU %000
ADDQ_W          EQU %001
ADDQ_L          EQU %010

MULS_W_AND      EQU %1100
MULS_OP_W       EQU %111

SUB             EQU %1001
SUB_TO_DN_B     EQU %000
SUB_TO_DN_W     EQU %001
SUB_TO_DN_L     EQU %010
SUB_TO_EA_B     EQU %100
SUB_TO_EA_W     EQU %101
SUB_TO_EA_L     EQU %110

DIVU_OR         EQU %1000
DIVU            EQU %011

DN_B            EQU %000
DN_W            EQU %001
DN_L            EQU %010
EA_B            EQU %100
EA_W            EQU %101
EA_L            EQU %110

MULS_LEA_CLR_JSR_RTS_MOVEM    EQU %0100
RTS             EQU $4E75
LEA             EQU %111
JSR             EQU %0100111010
CLR_B           EQU %0100001000
CLR_W           EQU %0100001001
CLR_L           EQU %0100001010
MULS_L          EQU %0100110000

MOVEM_TO_MEM_W  EQU %0100100010
MOVEM_TO_MEM_L  EQU %0100100011
MOVEM_TO_REG_W  EQU %0100110010
MOVEM_TO_REG_L  EQU %0100110011

LSL             EQU %1110001111
LSR             EQU %1110001011
ASR             EQU %1110000111
ASL             EQU %1110000011
ROL             EQU %1110011111
ROR             EQU %1110011011

CMP             EQU %1011
CMP_B           EQU %000
CMP_W           EQU %001
CMP_L           EQU %010

BCC             EQU %0110
BCC_16          EQU %00000000
BCC_32          EQU $FF
CC_T	        EQU %0000
CC_F	        EQU %0001
CC_HI	        EQU %0010
CC_LS	        EQU %0011
CC_CC	        EQU %0100
CC_CS	        EQU %0101
CC_NE	        EQU %0110
CC_EQ	        EQU %0111
CC_VC	        EQU %1000
CC_VS	        EQU %1001
CC_PL	        EQU %1010
CC_MI	        EQU %1011
CC_GE	        EQU %1100
CC_LT	        EQU %1101
CC_GT	        EQU %1110
CC_LE	        EQU %1111




********************************
** BEGIN OpDecoder SUBROUTINE **
********************************

* A0 = INPUT    Decoder pointer; Persistant
* D2 = INPUT    Read opcode word

OpDecoder
    MOVEM.L     D0-D7/A1-A6, -(SP)
    CLR         D1
    BRA         CHECK_NOP
NOP_RETURN
    BRA         CHECK_FOUR_BIT_SIG
FOUR_BIT_RETURN
    BRA         CHECK_ADDI
ADDI_RETURN
    BRA         CHECK_SHIFT_AND_ROTATE

opdec_return
    MOVEM.L     (SP)+, D0-D7/A1-A6
    RTS

*****************************
*   HELPER FUNCTIONS        *
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
CHECK_SHIFT_AND_ROTATE

    BSR         ReadFirstTenBits

    MOVE.W      #LSL,D6
    CMP.W       D3,D6
    BEQ         MATCH_LSL

    MOVE.W      #LSR,D6
    CMP.W       D3,D6
    BEQ         MATCH_LSR

    MOVE.W      #ASR,D6
    CMP.W       D3,D6
    BEQ         MATCH_ASR

    MOVE.W      #ASL,D6
    CMP.W       D3,D6
    BEQ         MATCH_ASL

    MOVE.W      #ROL,D6
    CMP.W       D3,D6
    BEQ         MATCH_ROL

    MOVE.W      #ROR,D6
    CMP.W       D3,D6
    BEQ         MATCH_ROR

    BRA         opdec_return

*************************
CHECK_NOP

    MOVE.W      #NOP,D6
    CMP.W       D2,D6
    BEQ         MATCH_NOP

    BRA         NOP_RETURN

*************************
CHECK_FOUR_BIT_SIG

    BSR         ReadFirstFourBits

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

    MOVE.B      #ADD_ADDA,D6
    CMP.B       D3,D6
    BEQ         CHECK_ADD_ADDA

    MOVE.B      #ADDQ,D6
    CMP.B       D3,D6
    BEQ         CHECK_ADDQ

    MOVE.B      #SUB,D6
    CMP.B       D3,D6
    BEQ         CHECK_SUB

    MOVE.B      #DIVU_OR,D6
    CMP.B       D3,D6
    BEQ         CHECK_DIVU_OR

    MOVE.B      #MULS_W_AND,D6
    CMP.B       D3,D6
    BEQ         CHECK_MULS_W_AND

    MOVE.B      #MULS_LEA_CLR_JSR_RTS_MOVEM,D6
    CMP.B       D3,D6
    BEQ         CHECK_MULS_LEA_CLR_JSR_RTS

    MOVE.B      #CMP,D6
    CMP.B       D3,D6
    BEQ         CHECK_CMP

    MOVE.B      #BCC,D6
    CMP.B       D3,D6
    BEQ         CHECK_BCC

    MOVE.B      #SHIFT,D6
    CMP.B       D3,D6
    BEQ         CHECK_SHIFT

    BRA         FOUR_BIT_RETURN
***********************************
CHECK_BCC

    MOVE.B      #BCC_16,D6
    CMP.B       D2,D6
    BEQ         CHECK_BCC_16

    MOVE.B      #BCC_32,D6
    CMP.B       D2,D6
    BEQ         CHECK_BCC_32

    BRA         CHECK_BCC_8

***********************************
CHECK_BCC_8

    BSR         ISOLATE_CC_CODE_FOR_BCC

    MOVE.B      #CC_T,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_T_8

    MOVE.B      #CC_F,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_F_8

    MOVE.B      #CC_HI,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_HI_8

    MOVE.B      #CC_LS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LS_8

    MOVE.B      #CC_CC,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_CC_8

    MOVE.B      #CC_CS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_CS_8

    MOVE.B      #CC_NE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_NE_8

    MOVE.B      #CC_EQ,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_EQ_8

    MOVE.B      #CC_VC,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_VC_8

    MOVE.B      #CC_VS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_VS_8

    MOVE.B      #CC_PL,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_PL_8

    MOVE.B      #CC_MI,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_MI_8

    MOVE.B      #CC_GE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_GE_8

    MOVE.B      #CC_LT,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LT_8

    MOVE.B      #CC_GT,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_GT_8

    MOVE.B      #CC_LE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LE_8

    BRA         ERROR

***********************************
CHECK_BCC_16

    BSR         ISOLATE_CC_CODE_FOR_BCC

    MOVE.B      #CC_T,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_T_16

    MOVE.B      #CC_F,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_F_16

    MOVE.B      #CC_HI,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_HI_16

    MOVE.B      #CC_LS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LS_16

    MOVE.B      #CC_CC,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_CC_16

    MOVE.B      #CC_CS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_CS_16

    MOVE.B      #CC_NE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_NE_16

    MOVE.B      #CC_EQ,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_EQ_16

    MOVE.B      #CC_VC,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_VC_16

    MOVE.B      #CC_VS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_VS_16

    MOVE.B      #CC_PL,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_PL_16

    MOVE.B      #CC_MI,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_MI_16

    MOVE.B      #CC_GE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_GE_16

    MOVE.B      #CC_LT,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LT_16

    MOVE.B      #CC_GT,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_GT_16

    MOVE.B      #CC_LE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LE_16

    BRA         ERROR


***********************************
CHECK_BCC_32

    BSR         ISOLATE_CC_CODE_FOR_BCC

    MOVE.B      #CC_T,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_T_32

    MOVE.B      #CC_F,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_F_32

    MOVE.B      #CC_HI,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_HI_32

    MOVE.B      #CC_LS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LS_32

    MOVE.B      #CC_CC,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_CC_32

    MOVE.B      #CC_CS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_CS_32

    MOVE.B      #CC_NE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_NE_32

    MOVE.B      #CC_EQ,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_EQ_32

    MOVE.B      #CC_VC,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_VC_32

    MOVE.B      #CC_VS,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_VS_32

    MOVE.B      #CC_PL,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_PL_32

    MOVE.B      #CC_MI,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_MI_32

    MOVE.B      #CC_GE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_GE_32

    MOVE.B      #CC_LT,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LT_32

    MOVE.B      #CC_GT,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_GT_32

    MOVE.B      #CC_LE,D6
    CMP.B       D3,D6
    BEQ         MATCH_CC_LE_32

    BRA         ERROR

***********************************
ISOLATE_CC_CODE_FOR_BCC

    MOVEM.W     D2, -(SP)

    LSL.W       #4,D2
    MOVE.B      #12,D7
    LSR.W       D7,D2

    MOVE.B      D2,D3

    MOVEM.W     (SP)+,D2
    RTS
***********************************
CHECK_CMP

    BSR         ISOLATE_OP_CODE

    MOVE.B      #CMP_B,D6
    CMP.B       D3,D6
    BEQ         MATCH_CMP_B

    MOVE.B      #CMP_W,D6
    CMP.B       D3,D6
    BEQ         MATCH_CMP_W

    MOVE.B      #CMP_L,D6
    CMP.B       D3,D6
    BEQ         MATCH_CMP_L

    BRA         ERROR
***********************************
CHECK_MULS_LEA_CLR_JSR_RTS

    MOVE.W      #RTS,D6
    CMP.W       D2,D6
    BEQ         MATCH_RTS

    BSR         ISOLATE_OP_CODE

    MOVE.B      #LEA,D6
    CMP.B       D3,D6
    BEQ         MATCH_LEA

    BSR         ReadFirstTenBits

    MOVE.W      #JSR,D6
    CMP.W       D3,D6
    BEQ         MATCH_JSR

    MOVE.W      #CLR_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_CLR_B

    MOVE.W      #CLR_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_CLR_W

    MOVE.W      #CLR_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_CLR_L

    MOVE.W      #MULS_L,D6  * Shouldn't need to check for the rest of the opcode..?
    CMP.W       D3,D6
    BEQ         MATCH_MULS_L
    
    BRA         CHECK_MOVEM

***********************************
CHECK_MULS_W_AND

    BSR         ISOLATE_OP_CODE

    MOVE.B      #MULS_OP_W,D6
    CMP.B       D3,D6
    BEQ         MATCH_MULS_W

    MOVE.B      #DN_B,D6
    CMP.B       D3,D6
    BEQ         MATCH_AND_DN_B

    MOVE.B      #DN_W,D6
    CMP.B       D3,D6
    BEQ         MATCH_AND_DN_W

    MOVE.B      #DN_L,D6
    CMP.B       D3,D6
    BEQ         MATCH_AND_DN_L

    MOVE.B      #EA_B,D6
    CMP.B       D3,D6
    BEQ         MATCH_AND_EA_B

    MOVE.B      #EA_W,D6
    CMP.B       D3,D6
    BEQ         MATCH_AND_EA_W

    MOVE.B      #EA_L,D6
    CMP.B       D3,D6
    BEQ         MATCH_AND_EA_L

    BRA         ERROR

***********************************
CHECK_DIVU_OR

    BSR         ISOLATE_OP_CODE

    MOVE.B      #DIVU,D6
    CMP.B       D3,D6
    BEQ         MATCH_DIVU

    MOVE.B      #DN_B,D6
    CMP.B       D3,D6
    BEQ         MATCH_OR_DN_B

    MOVE.B      #DN_W,D6
    CMP.B       D3,D6
    BEQ         MATCH_OR_DN_W

    MOVE.B      #DN_L,D6
    CMP.B       D3,D6
    BEQ         MATCH_OR_DN_L

    MOVE.B      #EA_B,D6
    CMP.B       D3,D6
    BEQ         MATCH_OR_EA_B

    MOVE.B      #EA_W,D6
    CMP.B       D3,D6
    BEQ         MATCH_OR_EA_W

    MOVE.B      #EA_L,D6
    CMP.B       D3,D6
    BEQ         MATCH_OR_EA_L

    BRA         ERROR

***********************************
CHECK_MOVEM

    BSR         ReadFirstTenBits

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

    BRA         ERROR
****************************************
CHECK_ADD_ADDA

    BSR         ISOLATE_OP_CODE

    MOVE.W      #DN_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_REG_B

    MOVE.W      #DN_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_REG_W

    MOVE.W      #DN_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_REG_L

    MOVE.W      #EA_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_EA_B

    MOVE.W      #EA_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_EA_W

    MOVE.W      #EA_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADD_TO_EA_L

    MOVE.W      #ADDA_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDA_W

    MOVE.W      #ADDA_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDA_L

    RTS ** Change later?
****************************************
CHECK_ADDQ

    BSR         ISOLATE_OP_CODE

    MOVE.W      #ADDQ_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDQ_B

    MOVE.W      #ADDQ_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDQ_W

    MOVE.W      #ADDQ_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDQ_L

****************************************
CHECK_ADDI

    BSR         ReadFirstTenBits

    MOVE.W      #ADDI_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDI_B

    MOVE.W      #ADDI_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDI_W

    MOVE.W      #ADDI_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_ADDI_L

    BRA         ADDI_RETURN
*****************************************
CHECK_SUB

    BSR         ISOLATE_OP_CODE

    MOVE.W      #DN_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_SUB_TO_DN_B

    MOVE.W      #DN_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_SUB_TO_DN_W

    MOVE.W      #DN_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_SUB_TO_DN_L

    MOVE.W      #EA_B,D6
    CMP.W       D3,D6
    BEQ         MATCH_SUB_TO_EA_B

    MOVE.W      #EA_W,D6
    CMP.W       D3,D6
    BEQ         MATCH_SUB_TO_EA_W

    MOVE.W      #EA_L,D6
    CMP.W       D3,D6
    BEQ         MATCH_SUB_TO_EA_L
*****************************************
CHECK_MOVEA_W_AND_MOVE_W

    BSR         ISOLATE_OP_CODE

    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_W

    BRA         MATCH_MOVE_W
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

    BSR         ISOLATE_OP_CODE

    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_L

    BRA         MATCH_MOVE_L
**********************************************
** D2 is holding the op command bits        **

***********************************

***********************************

MATCH_OR_DN_B
    MOVE.W      D2,D5       *REMOVE
MATCH_OR_DN_W
    MOVE.W      D2,D5       *REMOVE
MATCH_OR_DN_L
    MOVE.W      D2,D5       *REMOVE
MATCH_OR_EA_B
    MOVE.W      D2,D5       *REMOVE
MATCH_OR_EA_W
    MOVE.W      D2,D5       *REMOVE
MATCH_OR_EA_L
    MOVE.W      D2,D5       *REMOVE

MATCH_LEA
    MOVE.W      D2,D5       *REMOVE

MATCH_MULS_L
    MOVE.W      D2,D5       *REMOVE


                INCLUDE 'EADecoder.x68'
                INCLUDE 'connor_opcodes.x68'
                INCLUDE 'spencer_opcodes.x68'
                INCLUDE 'arsany_opcodes.x68'





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
