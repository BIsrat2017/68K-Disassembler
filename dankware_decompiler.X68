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
MOVEM_TO_MEM_W  EQU %0100100010
MOVEM_TO_MEM_L  EQU %0100100011
MOVEM_TO_REG_W  EQU %0100110010
MOVEM_TO_REG_L  EQU %0100110011

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

MULS_LEA_CLR_JSR_RTS    EQU %0100
RTS             EQU $4E75
LEA             EQU %111
JSR             EQU %0100111010
CLR_B           EQU %0100001000
CLR_W           EQU %0100001001
CLR_L           EQU %0100001010
MULS_L          EQU %0100110000

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
CC_T	            EQU %0000
CC_F	            EQU %0001
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

SHIFT           EQU %1110
RO              EQU %11
AS              EQU %00
LS              EQU %01
R               EQU %0
L               EQU %1
SHIFT_register  EQU %1
SHIFT_immed     EQU %0
SHIFT_BYTE      EQU %00
SHIFT_WORD      EQU %01
SHIFT_LONG      EQU %11


***********************************************************************************
***********************************************************************************
***********************************************************************************


********************************
** 		PROGRAM START 	      **
********************************

** Get input and begin main loop

start   ORG     $1000

                INCLUDE 'EADecoder.x68'
                INCLUDE 'decompiler_constants.x68'
        		INCLUDE 'ASCII_HEX_Conversions.x68'
        		
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

        BSR     OpDecoder

        MOVE.L  #13,D0
        TRAP    #15

        JMP     loop_start

input_error
        MOVE.L  #13,D0
        LEA     ERROR_MSG,A1
        TRAP    #15
Done
        SIMHALT

**********************
**** END OF START ****
**********************


***********************************************************************************
***********************************************************************************
***********************************************************************************


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
    BRA         CHECK_MOVEM
MOVEM_RETURN
    BRA         CHECK_ADDI
ADDI_RETURN
    BRA         CHECK_SHIFT_AND_ROTATE

opdec_return
    MOVEM.L     (SP)+, D0-D7/A1-A6
    RTS
***************************
**** END OF SUBROUTINE ****
***************************


***********************************************************************************
***********************************************************************************
***********************************************************************************


***************************************
**          HELPER SUBROUTINES       **
***************************************

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

***********************************
ISOLATE_CC_CODE_FOR_BCC

    MOVEM.W     D2, -(SP)

    LSL.W       #4,D2
    MOVE.B      #12,D7
    LSR.W       D7,D2

    MOVE.B      D2,D3

    MOVEM.W     (SP)+,D2
    RTS

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

***************************************
**          CHECK TABLES             **
***************************************

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

    MOVE.B      #MULS_LEA_CLR_JSR_RTS,D6
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

    BRA         ERROR

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

    BRA         MOVEM_RETURN
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

**********************************************
CHECK_MOVEA_L_AND_MOVE_L

    BSR         ISOLATE_OP_CODE

    MOVE.B      #MOVEA_WL,D6
    CMP.B       D3,D6
    BEQ         MATCH_MOVEA_L

    BRA         MATCH_MOVE_L



***********************************************************************************
***********************************************************************************
***********************************************************************************


**********************************************

**			OPCODE PRINT COMMANDS			**

**********************************************


*************************************
**          NOP  COMMAND          **
*************************************

MATCH_NOP
    LEA         pr_NOP,A1
    MOVE.B      #14,D0
    TRAP        #15
    BRA         opdec_return


*************************************
**          MOVE COMMANDS          **
*************************************

MATCH_MOVE_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVE,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15

    BRA         print_move

MATCH_MOVE_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVE,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_move

MATCH_MOVE_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVE,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15

    BRA         print_move

** Common print code
print_move
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111111000000,D0
    LSR.W       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return

*************************************
**          MOVEQ COMMANDS         **
*************************************

MATCH_MOVEQ
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVEQ,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Print data
    MOVE.B      D2,D1
    MOVE.B      #15,D0
    MOVE.L      D2,D3
    MOVE.L      #16,D2
    TRAP        #15
    MOVE.L      D3,D2
    ** Decode register
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.W       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return

*************************************
**          ADDI COMMANDS          **
*************************************

MATCH_ADDI_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADDI,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15

    BRA         print_addi

MATCH_ADDI_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADDI,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_addi

MATCH_ADDI_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADDI,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15

    BRA         print_addi

print_addi
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Print Immediate data
    MOVE.B      #%00111100,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return

*************************************
**      ADD/SUB COMMANDS           **
*************************************

MATCH_ADD_TO_REG_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADD,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15

    BRA         print_add_to_reg

MATCH_ADD_TO_REG_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADD,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_add_to_reg

MATCH_ADD_TO_REG_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADD,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15

    BRA         print_add_to_reg

MATCH_SUB_TO_DN_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_SUB,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15

    BRA         print_add_to_reg

MATCH_SUB_TO_DN_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_SUB,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_add_to_reg

MATCH_SUB_TO_DN_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_SUB,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15

    BRA         print_add_to_reg

print_add_to_reg
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Print source
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Print destination
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.W       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return

MATCH_ADD_TO_EA_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADD,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15

    BRA         print_add_to_ea

MATCH_ADD_TO_EA_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADD,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_add_to_ea

MATCH_ADD_TO_EA_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADD,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15

    BRA         print_add_to_ea

MATCH_SUB_TO_EA_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_SUB,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15

    BRA         print_add_to_ea

MATCH_SUB_TO_EA_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_SUB,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_add_to_ea

MATCH_SUB_TO_EA_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_SUB,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15

    BRA         print_add_to_ea

print_add_to_ea
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Print Source
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.W       #6,D0
    JSR         EADecoder_left
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Print source
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return

*************************************
**          ADDQ COMMANDS          **
*************************************

MATCH_ADDQ_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADDQ,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15

    BRA         print_addq

MATCH_ADDQ_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADDQ,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_addq

MATCH_ADDQ_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADDQ,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15

    BRA         print_addq

print_addq
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Print hash
    LEA         pr_hash,A1
    TRAP        #15
    ** Print Immediate data
    MOVE.W      D2,D3 * Temporarily move op data
    MOVE.W      D2,D1
    ANDI.W      #%0000111000000000,D1
    LSR.W       #6,D1
    LSR.W       #3,D1
    MOVE.B      #16,D2
    MOVE.W      #15,D0
    TRAP        #15

    MOVE.W      D3,D2 * Move op data back

    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return

*************************************
**          DIVU COMMANDS          **
*************************************

MATCH_DIVU_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_DIVU,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111111000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return



***********************************************************************************
***********************************************************************************
***********************************************************************************

*************************************
**        ARSANY'S COMMANDS        **
*************************************

MATCH_MOVEA_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVEA,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111111000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_MOVEA_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVEA,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111111000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_ADDA_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADDA,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111111000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_ADDA_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_ADDA,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111111000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_MULS_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MULS,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111111000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_RTS
    LEA         pr_RTS,A1
    MOVE.B      #14,D0
    TRAP        #15
    BRA         opdec_return
MATCH_CMP_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_CMP,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_CMP_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_CMP,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    CLR         D0
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_CMP_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_CMP,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    CLR         D0
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_JSR
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_JSR,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return
MATCH_CLR_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_CLR,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return
MATCH_CLR_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_CLR,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return
MATCH_CLR_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_CLR,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return
MATCH_AND_DN_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_AND,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_AND_DN_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_AND,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return
MATCH_AND_DN_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_AND,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return

MATCH_AND_EA_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_AND,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return
MATCH_AND_EA_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_AND,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return
MATCH_AND_EA_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_AND,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Decode left side ea
    MOVE.W      D2,D0
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return




***********************************************************************************
***********************************************************************************
***********************************************************************************



*************************************
**        SPENCER'S COMMANDS      **
*************************************


**********************************************
*****    SHIFT SUBROUTINES    ****************
CHECK_SHIFT
    BSR     Get_Count_Register_Val          * register 3
    BSR     Get_Size                        * register 4
    BSR     Get_Direction                   * register 5
    BSR     Get_Is_Register_Or_Immediate    * register 6
    BSR     Get_Shift_Opcode                * register 7

    BSR     PrintShiftData

    BSR     getShiftDestReg

    MOVE.B  #3,D0
    TRAP    #15

    BRA         opdec_return

**********************************************
getShiftDestReg

    MOVEM.W     D2, -(SP)

    MOVE.B      #13,D1
    LSL.L       D1,D2
    LSR.L       D1,D2
    MOVE.B      D2,D1

    MOVEM.W     (SP)+,D2
    RTS


*********************************************
PrintShiftData

    CMP.B   #RO,D7
    BEQ     printRotate
    CMP.B   #AS,D7
    BEQ     printArithShift
    CMP.B   #LS,D7
    BEQ     printLogicShift

printRotate
    LEA         pr_SHIFT_RO,A1
    JMP         executeShiftOpcodePrint
printArithShift
    LEA         pr_SHIFT_AS,A1
    JMP         executeShiftOpcodePrint
printLogicShift
    LEA         pr_SHIFT_LS,A1
    JMP         executeShiftOpcodePrint
executeShiftOpcodePrint
    BSR         PrintString

    CMP.B   #R,D5
    BEQ     printShiftRight
    CMP.B   #L,D5
    BEQ     printShiftLeft

printShiftRight
    LEA         pr_SHIFT_R,A1
    JMP         executePrintShiftdirection
printShiftLeft
    LEA         pr_SHIFT_L,A1
    JMP         executePrintShiftdirection
executePrintShiftdirection
    BSR         PrintString

    CMP.B   #SHIFT_BYTE,D4
    BEQ     printShiftByte
    CMP.B   #SHIFT_WORD,D4
    BEQ     printShiftWord
    CMP.B   #SHIFT_LONG,D4
    BEQ     printShiftLong

printShiftByte
    LEA     pr_BYTE,A1
    JMP     executePrintShiftSize
printShiftWord
    LEA     pr_WORD,A1
    JMP     executePrintShiftSize
printShiftLong
    LEA     pr_LONG,A1
    JMP     executePrintShiftSize
executePrintShiftSize
    BSR         PrintString
    LEA     pr_space,A1
    BSR     PrintString

    CMP.B   #SHIFT_register,D6
    BEQ     printShiftReg
    CMP.B   #SHIFT_immed,D6
    BEQ     printShift

printShiftReg
    LEA     pr_reg,A1
    BSR     PrintString
printShift
    MOVE.B  D3,D1
    MOVE.B  #3,D0
    TRAP    #15

    LEA     pr_comma,A1
    BSR     PrintString
    LEA     pr_reg,A1
    BSR     PrintString
    RTS


**********************************************
Get_Count_Register_Val

    MOVEM.W     D2, -(SP)

    MOVE.B      #13,D1
    LSL.L       #4,D2
    LSR.L       D1,D2
    MOVE.B      D2,D3

    MOVEM.W     (SP)+,D2
    RTS

**********************************************
Get_Size

    MOVEM.W     D2, -(SP)

    MOVE.B      #14,D1
    LSL.L       #8,D2
    LSR.L       D1,D2
    MOVE.B      D2,D4

    MOVEM.W     (SP)+,D2
    RTS
*********************************************
Get_Direction

    MOVEM.W     D2, -(SP)

    MOVE.B      #15,D1
    LSL.L       #7,D2
    LSR.L       D1,D2
    MOVE.B      D2,D5

    MOVEM.W     (SP)+,D2
    RTS
********************************************
Get_Is_Register_Or_Immediate

    MOVEM.W     D2, -(SP)

    MOVE.B      #10,D1
    LSL.L       D1,D2
    MOVE.B      #15,D1
    LSR.L       D1,D2

    MOVE.B      D2,D6

    MOVEM.W     (SP)+,D2
    RTS

*******************************************
Get_Shift_Opcode

    MOVEM.W     D2, -(SP)

    MOVE.B      #11,D1
    LSL.L       D1,D2
    MOVE.B      #14,D1
    LSR.L       D1,D2

    MOVE.B      D2,D7

    MOVEM.W     (SP)+,D2
    RTS
********************************************


MATCH_LSL
    MOVE.W      D2,D5       *REMOVE
MATCH_LSR
    MOVE.W      D2,D5       *REMOVE
MATCH_ASR
    MOVE.W      D2,D5       *REMOVE
MATCH_ASL
    MOVE.W      D2,D5       *REMOVE
MATCH_ROL
    MOVE.W      D2,D5       *REMOVE
MATCH_ROR
    MOVE.W      D2,D5       *REMOVE

***** BCC Displacement Subroutines************
Get_BCC_Displacement_8bit

    CLR     D6
    MOVE.B  D2,D6
    RTS
**********************************************
Get_BCC_Displacement_16bit

    CLR     D6
    MOVE.W  (A0)+,D6
    RTS
**********************************************
Get_BCC_Displacement_32bit

    CLR     D6
    MOVE.L  (A0)+,D6
    RTS
**********************************************
Get_Current_Address

    CLR     D7
    MOVE.L      A0,D7
    SUBI.L      #2,D7
    RTS
**********************************************
Get_BCC_Destination_Address

    SUB.L   D6,D7
    RTS
**********************************************
**********************************************

********* Utility Subroutines ********************
**********************************************
PrintHex

    MOVEM.W     D2, -(SP)

    MOVE.B      #15,D0
    MOVE.B      #16,D2 * print base 16
    TRAP        #15

    MOVEM.W     (SP)+,D2
    RTS
**********************************************
PrintString
    MOVE.B      #14,D0
    TRAP        #15
    RTS
**********************************************
PrintSizeByte
    MOVE.B      #14,D0
    LEA         pr_BYTE,A1
    TRAP        #15
    RTS
**********************************************
PrintSizeWord
    MOVE.B      #14,D0
    LEA         pr_WORD,A1
    TRAP        #15
    RTS
**********************************************
PrintSizeLong
    MOVE.B      #14,D0
    LEA         pr_LONG,A1
    TRAP        #15
    RTS
**********************************************
**********************************************


**********BCC OPCODE MATCHES*******
MATCH_CC_T_8
    MOVE.W      D2,D5       *REMOVE
MATCH_CC_T_16
    MOVE.W      D2,D5       *REMOVE
MATCH_CC_T_32
    MOVE.W      D2,D5       *REMOVE
*****
MATCH_CC_F_8
    MOVE.W      D2,D5       *REMOVE
MATCH_CC_F_16
    MOVE.W      D2,D5       *REMOVE
MATCH_CC_F_32
    MOVE.W      D2,D5       *REMOVE
*****
MATCH_CC_HI_8
    ** print opcode **
    LEA         pr_BCC_HI,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return

MATCH_CC_HI_16
    ** print opcode **
    LEA         pr_BCC_HI,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_HI_32
    ** print opcode **
    LEA         pr_BCC_HI,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_LS_8
    ** print opcode **
    LEA         pr_BCC_LS,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_LS_16
    ** print opcode **
    LEA         pr_BCC_LS,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return

MATCH_CC_LS_32
    ** print opcode **
    LEA         pr_BCC_LS,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_CC_8

    ** print opcode **
    LEA         pr_BCC_CC,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return

MATCH_CC_CC_16
    ** print opcode **
    LEA         pr_BCC_CC,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_CC_32
    ** print opcode **
    LEA         pr_BCC_CC,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_CS_8
    ** print opcode **
    LEA         pr_BCC_CS,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_CS_16
    ** print opcode **
    LEA         pr_BCC_CS,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_CS_32
    ** print opcode **
    LEA         pr_BCC_CS,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_NE_8
    ** print opcode **
    LEA         pr_BCC_NE,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_NE_16
    ** print opcode **
    LEA         pr_BCC_NE,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_NE_32
    ** print opcode **
    LEA         pr_BCC_NE,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_EQ_8
    ** print opcode **
    LEA         pr_BCC_EQ,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_EQ_16
    ** print opcode **
    LEA         pr_BCC_EQ,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_EQ_32
    ** print opcode **
    LEA         pr_BCC_EQ,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_VC_8
    ** print opcode **
    LEA         pr_BCC_VC,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_VC_16
    ** print opcode **
    LEA         pr_BCC_VC,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_VC_32
    ** print opcode **
    LEA         pr_BCC_VC,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_VS_8
    ** print opcode **
    LEA         pr_BCC_VS,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_VS_16
    ** print opcode **
    LEA         pr_BCC_VS,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_VS_32
    ** print opcode **
    LEA         pr_BCC_VS,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_PL_8
    ** print opcode **
    LEA         pr_BCC_PL,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_PL_16
    ** print opcode **
    LEA         pr_BCC_PL,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_PL_32
    ** print opcode **
    LEA         pr_BCC_PL,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_MI_8
    ** print opcode **
    LEA         pr_BCC_MI,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_MI_16
    ** print opcode **
    LEA         pr_BCC_MI,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_MI_32
    ** print opcode **
    LEA         pr_BCC_MI,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_GE_8
    ** print opcode **
    LEA         pr_BCC_GE,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_GE_16
    ** print opcode **
    LEA         pr_BCC_GE,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_GE_32
    ** print opcode **
    LEA         pr_BCC_GE,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_LT_8
    ** print opcode **
    LEA         pr_BCC_LT,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_LT_16
    ** print opcode **
    LEA         pr_BCC_LT,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_LT_32
    ** print opcode **
    LEA         pr_BCC_LT,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_GT_8
    ** print opcode **
    LEA         pr_BCC_GT,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_GT_16
    ** print opcode **
    LEA         pr_BCC_GT,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_GT_32
    ** print opcode **
    LEA         pr_BCC_GT,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
*****
MATCH_CC_LE_8
    ** print opcode **
    LEA         pr_BCC_LE,A1
    BSR         PrintString

    BSR         PrintSizeBYTE
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_8bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_LE_16
    ** print opcode **
    LEA         pr_BCC_LE,A1
    BSR         PrintString

    BSR         PrintSizeWORD
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_16bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return
MATCH_CC_LE_32
    ** print opcode **
    LEA         pr_BCC_LE,A1
    BSR         PrintString

    BSR         PrintSizeLONG
    LEA         pr_space,A1
    BSR         PrintString

    ** print address **
    BSR         Get_BCC_Displacement_32bit
    BSR         Get_Current_Address
    BSR         Get_BCC_Destination_Address
    MOVE.L      D7,D1
    BSR         PrintHex

    BRA         opdec_return





***********************************************************************************
***********************************************************************************
***********************************************************************************



*************************************
**       	INCOMPLETE             **
*************************************

***********************************
MATCH_MOVEM_TO_MEM_W
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEM_TO_MEM_L
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEM_TO_REG_W
    MOVE.W      D2,D5       *REMOVE
MATCH_MOVEM_TO_REG_L
    MOVE.W      D2,D5       *REMOVE
***********************************


MATCH_DIVU
    MOVE.W      D2,D5       *REMOVE
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




***********************************************************************************
***********************************************************************************
***********************************************************************************




**********************************
ERROR
    LEA         pr_ERROR,A1
    BSR         PrintString
    BRA         opdec_return

		END		start


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
