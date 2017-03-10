*-----------------------------------------------------------
* Title      : Connor's OpCodes
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

*************************************
**          NOP COMMAND            **
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


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
