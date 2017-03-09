*-----------------------------------------------------------
* Title      : Connor's OpCodes
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
pr_ADD          DC.B    'ADD',0
pr_ADDI         DC.B    'ADDI',0
pr_ADDQ         DC.B    'ADDQ',0

MATCH_NOP
    LEA         pr_NOP,A1
    MOVE.B      #14,D0
    TRAP        #15
    BRA         opdec_return
    
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
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Print Immediate data
    MOVE.W      D2,D3 * Temporarily move op data
    MOVE.W      D2,D1
    ANDI.W      #%0000111000000000,D1
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
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Print Immediate data
    MOVE.W      D2,D3 * Temporarily move op data
    MOVE.W      D2,D1
    ANDI.W      #%0000111000000000,D1
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
    ** Print space
    LEA         pr_space,A1
    TRAP        #15
    ** Print Immediate data
    MOVE.W      D2,D3 * Temporarily move op data
    MOVE.W      D2,D1
    ANDI.W      #%0000111000000000,D1
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


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
