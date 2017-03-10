** This file contains standalone subroutines and constant data for the opcodes file


*** Common strings for printing
pr_space    DC.B    ' ',0
pr_comma    DC.B    ',',0
pr_BYTE     DC.B    '.B',0
pr_WORD     DC.B    '.W',0
pr_LONG     DC.B    '.L',0
pr_hash     DC.B    '#',0

** Command strings constants
pr_NOP      DC.B    'NOP',0
pr_MOVE     DC.B    'MOVE',0
pr_MOVEA    DC.B    'MOVEA',0
pr_MOVEM    DC.B    'MOVEM',0
pr_MOVEQ    DC.B    'MOVEQ',0
pr_ADDA     DC.B    'ADDA',0
pr_ADD      DC.B    'ADD',0
pr_ADDI     DC.B    'ADDI',0
pr_ADDQ     DC.B    'ADDQ',0
pr_SUB      DC.B    'SUB',0
pr_MULS     DC.B    'MULS',0
pr_DIVU     DC.B    'DIVU',0
pr_CLR      DC.B    'CLR',0
pr_RTS      DC.B    'RTS',0
pr_CMP      DC.B    'CMP',0
pr_JSR      DC.B    'JSR',0
pr_AND      DC.B    'AND',0

pr_BCC_CC   DC.B    'BCC',0
pr_BCC_CS   DC.B    'BCS',0
pr_BCC_EQ   DC.B    'BEQ',0
pr_BCC_GE   DC.B    'BGE',0
pr_BCC_GT   DC.B    'BGT',0
pr_BCC_HI   DC.B    'BHI',0
pr_BCC_LE   DC.B    'BLE',0
pr_BCC_LS   DC.B    'BLS',0
pr_BCC_LT   DC.B    'BLT',0
pr_BCC_MI   DC.B    'BMI',0
pr_BCC_NE   DC.B    'BNE',0
pr_BCC_PL   DC.B    'BPL',0
pr_BCC_VC   DC.B    'BVC',0
pr_BCC_VS   DC.B    'BVS',0

pr_SHIFT_RO   DC.B    'RO',0
pr_SHIFT_AS   DC.B    'AS',0
pr_SHIFT_LS   DC.B    'LS',0
pr_SHIFT_L    DC.B    'L',0
pr_SHIFT_R    DC.B    'R',0

pr_ERROR    DC.B    'ERROR',0

MESSAGE     DC.B    'Enter the address of compiled code: ',0
ERROR_MSG   DC.B    'Invalid input, please rerun',0
SPACER      DC.B    ' ',0
