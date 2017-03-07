*-----------------------------------------------------------
* Title      :  EA Decoders
* Written by :  Team Dankware - Connor Davis McGwire
* Date       :  3/2/2017
* Description:  Subroutines for decoding EA bits
*-----------------------------------------------------------

** EA decoder assumes properly formatted bits are stored in D0 **
** Decoder also requires potential address of immediate data in the A0 register **
** and an address to return a string stored in A1. **
** Decoder will return the number read from immediate data in D0, as well as **
** a null terminated string stored in the given A1 address. **
** A1 will be incremented to the end of the immediate data field. **
** Code pattern is 00<mode><register> **

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
        
        MOVEA.L A1,A2 ** Copy return address
        
        *First, decoder will check for the 3 types with hard coded register values
        CMP     IMMEDIATE,D0
        BEQ     dec_immediate
        
        CMP     ABS_WORD,D0
        BEQ     dec_abs_word
        
        CMP     ABS_LONG,D0
        BEQ     dec_abs_long
        
        *If it was none of the above, store the register and mode seperately
        MOVE.B  D0,D2
        ANDI.B  #%00111000,D2           *Get mode value
        ANDI.B  #%00000111,D0           *Get register value
              
        CMP     Dn,D2
        BEQ     dec_Dn 
        
        CMP     An,D2
        BEQ     dec_An
                
        CMP     INDIRECT,D2
        BEQ     dec_indirect
                
        CMP     POST_INC,D2
        BEQ     dec_post_inc
                
        CMP     PRE_DEC,D2
        BEQ     dec_pre_dec
        
        CLR     D0
        
        *Common return for all types
dec_return

        MOVEM.L     (SP)+, D1-D7/A0-A6 *Return register data from stack, except D0
        RTS
        
**********************************************************************************
        * Individual EA decoders *
**********************************************************************************

dec_immediate   *DECODE IMMEDIATE VALUE*
        MOVE.B  #'#',(A1)+  * Move '#' char into string
        MOVE.B  #'$',(A1)+  * Move '$' char into string
        MOVE.B  #$0,(A1)+   * Null terminate string
        CMP     #2,(A0)     * Check if data is word length
        BEQ     imm_word    
        
        MOVE.L  (A0)+,D0    * Length was long
        BRA     dec_return
        
imm_word
        MOVE.W  (A0)+,D0    * Length was word
        BRA     dec_return

************************************************************

dec_abs_word    *DECODE ABSOLUTE WORD*
        MOVE.B  #'$',(A1)+  * Move '$' char into string
        MOVE.B  #$0,(A1)+   * Null terminate string
        MOVE.W  (A0)+,D0
        BRA     dec_return
        
************************************************************

dec_abs_long    *DECODE ABSOLUTE LONG*
        MOVE.B  #'$',(A1)+  * Move '$' char into string
        MOVE.B  #$0,(A1)+   * Null terminate string
        MOVE.L  (A0)+,D0
        BRA     dec_return
        
************************************************************

dec_Dn          *DECODE DIRECT DATA*
        MOVE.B  #'D',(A1)+
        MOVE.B  D0,(A1)+
        MOVE.B  #$0,(A1)+
        BRA     dec_return

************************************************************
        
dec_An          *DECODE DIRECT ADDRESS*
        MOVE.B  #'A',(A1)+
        MOVE.B  D0,(A1)+
        MOVE.B  #$0,(A1)+
        BRA     dec_return

************************************************************

dec_indirect    *DECODE INDIRECT ACCESS*
        MOVE.B  #'(',(A1)+
        MOVE.B  #'A',(A1)+
        MOVE.B  D0,(A1)+
        MOVE.B  #')',(A1)+
        MOVE.B  #$0,(A1)+
        BRA     dec_return
        
************************************************************

dec_post_inc    *DECODE INDIRECT POST INCREMENT*
        MOVE.B  #'(',(A1)+
        MOVE.B  #'A',(A1)+
        MOVE.B  D0,(A1)+
        MOVE.B  #')',(A1)+
        MOVE.B  #'+',(A1)+
        MOVE.B  #$0,(A1)+
        BRA     dec_return
        
************************************************************
        
dec_pre_dec    *DECODE INDIRECT PRE DECREMENT*
        MOVE.B  #'-',(A1)+
        MOVE.B  #'(',(A1)+
        MOVE.B  #'A',(A1)+
        MOVE.B  D0,(A1)+
        MOVE.B  #')',(A1)+
        MOVE.B  #$0,(A1)+
        BRA     dec_return



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
