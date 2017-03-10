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

pr_reg          DC.B    'D',0

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
**********************************
ERROR
    LEA         pr_ERROR,A1
    BSR         PrintString
    BRA         opdec_return




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
