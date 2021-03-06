*-----------------------------------------------------------
* Title      :  Arsany Azmy
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
    
    BRA         print_movea
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
print_movea
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
    
    BRA         print_adda
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
print_adda
    ** Print space
    LEA         pr_space2,A1
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
    ORI.W       #%0000000001000000,D0
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
    LEA         pr_space2,A1
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
    
    BRA         print_cmp
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
    
    BRA         print_cmp
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
print_cmp
    ** Print space
    LEA         pr_space3,A1
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
    LEA         pr_space5,A1
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
    
    BRA         print_clr
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
    
    BRA         print_clr
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
print_clr
    ** Print space
    LEA         pr_space3,A1
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
    
    BRA         print_and_dn
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
    
    BRA         print_and_dn
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
print_and_dn
    ** Print space
    LEA         pr_space3,A1
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
    
    BRA         print_and_ea
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
    
    BRA         print_and_ea
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
print_and_ea
    ** Print space
    LEA         pr_space3,A1
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
    
    
MATCH_LEA
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_LEA,A1
    TRAP        #15
    ** Print space
    LEA         pr_space5,A1
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
    ANDI.W      #%0000111001000000,D0
    LSR.L       #6,D0
    JSR         EADecoder_left
    
    BRA         opdec_return
    
MATCH_OR_DN_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_OR,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15
    
    BRA         print_or_dn
MATCH_OR_DN_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_OR,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    
    BRA         print_or_dn
MATCH_OR_DN_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_OR,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
print_or_dn
    ** Print space
    LEA         pr_space4,A1
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
MATCH_OR_EA_B
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_OR,A1
    TRAP        #15
    ** Print size
    LEA         pr_BYTE,A1
    TRAP        #15
    
    BRA         print_or_ea
MATCH_OR_EA_W
    ** Move command size into D1
    MOVE.B      #2,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_OR,A1
    TRAP        #15
    ** Print size
    LEA         pr_WORD,A1
    TRAP        #15
    
    BRA         print_or_ea
MATCH_OR_EA_L
    ** Move command size into D1
    MOVE.B      #4,D1
    ** Print command
    MOVE.B      #14,D0
    LEA         pr_OR,A1
    TRAP        #15
    ** Print size
    LEA         pr_LONG,A1
    TRAP        #15
print_or_ea
    ** Print space
    LEA         pr_space4,A1
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


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
