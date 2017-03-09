*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
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
    ANDI.W      #%0000111000000000,D0
    LSR.W       #9,D0
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
    ANDI.W      #%0000111000000000,D0
    LSR.W       #9,D0
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
    ANDI.W      #%0000111000000000,D0
    LSR.W       #9,D0
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
    ANDI.W      #%0000111000000000,D0
    LSR.W       #9,D0
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
    ANDI.W      #%0000111000000000,D0
    LSR.W       #9,D0
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
    LSR.W       #9,D0
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
    LSR.W       #9,D0
    JSR         EADecoder_left   
    
    BRA         opdec_return
MATCH_CMP_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_LONG,A1
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
    LSR.W       #9,D0
    JSR         EADecoder_left   
    
    BRA         opdec_return

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
