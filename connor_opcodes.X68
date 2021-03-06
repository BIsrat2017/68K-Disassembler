*-----------------------------------------------------------
* Title      : Connor's OpCodes
* Written by : Connor McGwire
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
    ** Print hex tag
    LEA         pr_hextag,A1
    TRAP        #15
    ** Print data
    MOVE.B      D2,D1
    MOVE.B      #15,D0
    MOVE.L      D2,D3
    MOVE.L      #16,D2
    TRAP        #15
    MOVE.L      D3,D2
    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15
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

MATCH_DIVU
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
    ANDI.W      #%0000111000000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left

    BRA         opdec_return


*************************************
**          MOVEM PRINTS           **
*************************************

MATCH_MOVEM_TO_MEM_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVEM,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_movem_to_mem
MATCH_MOVEM_TO_MEM_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVEM,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
print_movem_to_mem
    ** Print space
    LEA         pr_space,A1
    TRAP        #15

    ** Print registers
    BSR         print_movem_mask_to_mem

    ** Add comma
    MOVE.B      #14,D0
    LEA         pr_comma,A1
    TRAP        #15

    ** Decode right side ea
    MOVE.B      D2,D0
    ANDI.B      #%00111111,D0
    JSR         EADecoder

    BRA         opdec_return

********

MATCH_MOVEM_TO_REG_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVEM,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15

    BRA         print_movem_to_reg
MATCH_MOVEM_TO_REG_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_MOVEM,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
print_movem_to_reg
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

    ** Print registers
    BSR         print_movem_mask_to_reg

    BRA         opdec_return


*************************************
**          MOVEM HELPER FUNCTIONS **
*************************************

print_movem_mask_to_mem
    MOVEM       D0-D7/A1-A6,-(SP)

    CLR         D3          ** Temp register
    MOVE.W      (A0),D5     ** Holds address registers
    MOVE.W      (A0)+,D4    ** Holds direct registers
    ANDI.W      #%0000000011111111,D5
    ANDI.W      #%1111111100000000,D4
    LSR.W       #8,D4

    BSR         print_movem_dn

    ** Print ADDRESS REG slash
    MOVE.B      #14,D0
    LEA         pr_slash,A1
    TRAP        #15

    MOVE.B      D5,D4
    BSR         print_movem_an

    MOVEM       (SP)+,D0-D7/A1-A6
    RTS

****

print_movem_mask_to_reg
    MOVEM       D0-D7/A1-A6,-(SP)

    CLR         D3          ** Temp register
    MOVE.W      (A0),D4     ** Holds direct registers
    MOVE.W      (A0)+,D5    ** Holds address registers
    ANDI.W      #%0000000011111111,D4
    ANDI.W      #%1111111100000000,D5
    LSR.W       #8,D5

    BSR         bit_reversal
    BSR         print_movem_dn

    ** Print ADDRESS REG slash
    MOVE.B      #14,D0
    LEA         pr_slash,A1
    TRAP        #15

    MOVE.B      D5,D4
    BSR         bit_reversal
    BSR         print_movem_an

    MOVEM       (SP)+,D0-D7/A1-A6
    RTS



************************************************* REGISTER PRINTERS

** D4 should contain direct registers

********************************************* Dn
print_movem_dn
to_mem_d0 *************************** D0
    ** Test bit
    BTST        #7,D4
    BEQ         to_mem_d1
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_d0,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #6,D4
    BEQ         to_mem_d2
    ** Else, check cascade
    BRA         cascade_d1

to_mem_d1 *************************** D1
    ** Test bit
    BTST        #6,D4
    BEQ         to_mem_d2
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_d1,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #5,D4
    BEQ         to_mem_d3
    ** Else, check cascade
    BRA         cascade_d2

to_mem_d2 *************************** D2
    ** Test bit
    BTST        #5,D4
    BEQ         to_mem_d3
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_d2,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #4,D4
    BEQ         to_mem_d4
    ** Else, check cascade
    BRA         cascade_d3

to_mem_d3 *************************** D3
    ** Test bit
    BTST        #4,D4
    BEQ         to_mem_d4
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_d3,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #3,D4
    BEQ         to_mem_d5
    ** Else, check cascade
    BRA         cascade_d4

to_mem_d4 *************************** D4
    ** Test bit
    BTST        #3,D4
    BEQ         to_mem_d5
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_d4,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #2,D4
    BEQ         to_mem_d6
    ** Else, check cascade
    BRA         cascade_d5

to_mem_d5 *************************** D5
    ** Test bit
    BTST        #2,D4
    BEQ         to_mem_d6
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_d5,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #1,D4
    BEQ         to_mem_d7
    ** Else, check cascade
    BRA         cascade_d6

to_mem_d6 *************************** D6
    ** Test bit
    BTST        #1,D4
    BEQ         to_mem_d7
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_d6,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #0,D4
    BEQ         print_movem_dn_end
    ** Else, check cascade
    BRA         cascade_d7

to_mem_d7 *************************** D7
    ** Test bit
    BTST        #0,D4
    BEQ         print_movem_dn_end
    ** Print slash if D3 set
    BSR         slash_check
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_d6,A1
    TRAP        #15

print_movem_dn_end
    CLR         D3
    RTS

****

cascade_d1 *************************** -D1
    ** If the next bit is set, check next
    BTST        #5,D4
    BNE         cascade_d2
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_D1,A1
    TRAP        #15

    BRA         to_mem_d3

cascade_d2 *************************** -D2
    ** If the next bit is set, check next
    BTST        #4,D4
    BNE         cascade_d3
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_D2,A1
    TRAP        #15

    BRA         to_mem_d4

cascade_d3 *************************** -D3
    ** If the next bit is set, check next
    BTST        #3,D4
    BNE         cascade_d4
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_D3,A1
    TRAP        #15

    BRA         to_mem_d5

cascade_d4 *************************** -D4
    ** If the next bit is set, check next
    BTST        #2,D4
    BNE         cascade_d5
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_D4,A1
    TRAP        #15

    BRA         to_mem_d6

cascade_d5 *************************** -D5
    ** If the next bit is set, check next
    BTST        #1,D4
    BNE         cascade_d6
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_D5,A1
    TRAP        #15

    BRA         to_mem_d7

cascade_d6 *************************** -D6
    ** If the next bit is set, check next
    BTST        #0,D4
    BNE         cascade_d7
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_D6,A1
    TRAP        #15

    BRA         print_movem_dn_end

cascade_d7 *************************** -D7
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_D7,A1
    TRAP        #15

    BRA         print_movem_dn_end

********************************************* An
print_movem_an
to_mem_a0 *************************** A0
    ** Test bit
    BTST        #7,D4
    BEQ         to_mem_a1
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_a0,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #6,D4
    BEQ         to_mem_a2
    ** Else, check cascade
    BRA         cascade_a1

to_mem_a1 *************************** A1
    ** Test bit
    BTST        #6,D4
    BEQ         to_mem_a2
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_a1,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #5,D4
    BEQ         to_mem_a3
    ** Else, check cascade
    BRA         cascade_a2

to_mem_a2 *************************** A2
    ** Test bit
    BTST        #5,D4
    BEQ         to_mem_a3
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_a2,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #4,D4
    BEQ         to_mem_a4
    ** Else, check cascade
    BRA         cascade_a3

to_mem_a3 *************************** A3
    ** Test bit
    BTST        #4,D4
    BEQ         to_mem_a4
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_a3,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #3,D4
    BEQ         to_mem_a5
    ** Else, check cascade
    BRA         cascade_a4

to_mem_a4 *************************** A4
    ** Test bit
    BTST        #3,D4
    BEQ         to_mem_a5
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_a4,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #2,D4
    BEQ         to_mem_a6
    ** Else, check cascade
    BRA         cascade_a5

to_mem_a5 *************************** A5
    ** Test bit
    BTST        #2,D4
    BEQ         to_mem_a6
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_a5,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #1,D4
    BEQ         to_mem_a7
    ** Else, check cascade
    BRA         cascade_a6

to_mem_a6 *************************** A6
    ** Test bit
    BTST        #1,D4
    BEQ         to_mem_a7
    ** Print slash if D3 set
    BSR         slash_check
    ** Set D3
    MOVE.B      #1,D3
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_a6,A1
    TRAP        #15

    ** Check if next bit is clear
    ** If true, skip next
    BTST        #0,D4
    BEQ         print_movem_an_end
    ** Else, check cascade
    BRA         cascade_a7

to_mem_a7 *************************** A7
    ** Test bit
    BTST        #0,D4
    BEQ         print_movem_an_end
    ** Print slash if D3 set
    BSR         slash_check
    ** Print register
    MOVE.B      #14,D0
    LEA         pr_a6,A1
    TRAP        #15

print_movem_an_end
    CLR         D3
    RTS

****

cascade_a1 *************************** -A1
    ** If the next bit is set, check next
    BTST        #5,D4
    BNE         cascade_a2
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_a1,A1
    TRAP        #15

    BRA         to_mem_a3

cascade_a2 *************************** -A2
    ** If the next bit is set, check next
    BTST        #4,D4
    BNE         cascade_a3
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_a2,A1
    TRAP        #15

    BRA         to_mem_a4

cascade_a3 *************************** -A3
    ** If the next bit is set, check next
    BTST        #3,D4
    BNE         cascade_a4
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_a3,A1
    TRAP        #15

    BRA         to_mem_a5

cascade_a4 *************************** -A4
    ** If the next bit is set, check next
    BTST        #2,D4
    BNE         cascade_a5
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_a4,A1
    TRAP        #15

    BRA         to_mem_a6

cascade_a5 *************************** -A5
    ** If the next bit is set, check next
    BTST        #1,D4
    BNE         cascade_a6
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_a5,A1
    TRAP        #15

    BRA         to_mem_a7

cascade_a6 *************************** -A6
    ** If the next bit is set, check next
    BTST        #0,D4
    BNE         cascade_a7
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_a6,A1
    TRAP        #15

    BRA         print_movem_an_end

cascade_a7 *************************** -A7
    ** Else, finish the list
    LEA         pr_hyphen,A1
    TRAP        #15
    LEA         pr_a7,A1
    TRAP        #15

    BRA         print_movem_an_end



*************************************
**          MOVEM TO REG PRINTS    **
*************************************






************************************************
*******************************************
************************************** Slash check
slash_check
    CMPI.B      #1,D3
    BNE         no_slash
    ** Clear D3 and print slash
    CLR         D3
    MOVE.B      #14,D0
    LEA         pr_slash,A1
    TRAP        #15

no_slash
    RTS

************************************************
*******************************************
************************************** Bit reversal
** Reverses D4
bit_reversal
    MOVEM       D0-D3/D5-D7,-(SP)
    ** Reverse D4
    CLR         D2
    CLR         D3

    MOVE.B      D4,D3
    ANDI.B      #%10000000,D3
    LSR.B       #7,D3
    OR.B        D3,D2

    MOVE.B      D4,D3
    ANDI.B      #%01000000,D3
    LSR.B       #5,D3
    OR.B        D3,D2

    MOVE.B      D4,D3
    ANDI.B      #%00100000,D3
    LSR.B       #3,D3
    OR.B        D3,D2

    MOVE.B      D4,D3
    ANDI.B      #%00010000,D3
    LSR.B       #1,D3
    OR.B        D3,D2

    MOVE.B      D4,D3
    ANDI.B      #%00001000,D3
    LSL.B       #1,D3
    OR.B        D3,D2

    MOVE.B      D4,D3
    ANDI.B      #%00000100,D3
    LSL.B       #3,D3
    OR.B        D3,D2

    MOVE.B      D4,D3
    ANDI.B      #%00000010,D3
    LSL.B       #5,D3
    OR.B        D3,D2

    MOVE.B      D4,D3
    ANDI.B      #%00000001,D3
    LSL.B       #7,D3
    OR.B        D3,D2

    MOVE.B      D2,D4

    MOVEM       (SP)+,D0-D3/D5-D7
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
