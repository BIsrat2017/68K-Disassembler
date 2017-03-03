*-----------------------------------------------------------
* Title      :  EA Decoders
* Written by :  Team Dankware - Connor Davis McGwire
* Date       :  3/2/2017
* Description:  Subroutines for decoding EA bits
*-----------------------------------------------------------

** EA decoder assumes properly formatted bits are stored in D0 and D1 **
** D0 contains the EA stored in the left hand EA bits while D1 is the right **

IMMEDIATE   EQU #%00111100
ABS_WORD    EQU #%00111001
ABS_LONG    EQU #%00111000
Dn          EQU #%00000000
An          EQU #%00001000
INDIRECT    EQU #%00010000
POST_INC    EQU #%00011000
PRE_DEC     EQU #%00100000

EADecoder
        MOVEM.L     D1-D7/A0-A6, -(SP) *Store registers on stack, except D0
        
        *First, decoder will check for the 3 types with hard coded register values
        CMP     IMMEDIATE,D0
        BEQ     dec_immediate
        
        CMP     ABS_WORD,D0
        BEQ     dec_abs_word
        
        CMP     ABS_LONG,D0
        BEQ     dec_abs_long
        
        *If it was none of the above, store the register and mode seperately
        MOVE.B  D0,D1
        ANDI.B  #%00111000,D0           *Get mode value
        ANDI.B  #%00000111,D1           *Get register value
              
        CMP     Dn,D0
        BEQ     dec_Dn 
        
        CMP     An,D0
        BEQ     dec_An
                
        CMP     INDIRECT,D0
        BEQ     dec_indirect
                
        CMP     POST_INC,D0
        BEQ     dec_post_inc
                
        CMP     PRE_DEC,D0
        BEQ     dec_pre_dec
        
        *Common return for all types
dec_return

        MOVEM.L     (SP)+, D1-D7/A0-A6 *Return register data from stack, except D0
        RTS
        
**********************************************************************************
        * Individual EA decoders *
**********************************************************************************

dec_immediate   *DECODE IMMEDIATE VALUE*
        BRA     dec_return

dec_abs_word    *DECODE ABSOLUTE WORD*
        BRA     dec_return

dec_abs_long    *DECODE ABSOLUTE LONG*
        BRA     dec_return

dec_Dn          *DECODE DIRECT DATA*
        BRA     dec_return
        
dec_An          *DECODE DIRECT ADDRESS*
        BRA     dec_return
        
dec_indirect    *DECODE INDIRECT ACCESS*
        BRA     dec_return
        
dec_post_inc    *DECODE INDIRECT POST INCREMENT*
        BRA     dec_return
        
dec_pre_dec    *DECODE INDIRECT PRE DECREMENT*
        BRA     dec_return


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
