**********************************************  
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
    MOVE.B      #$16,D2 * print base 16
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
