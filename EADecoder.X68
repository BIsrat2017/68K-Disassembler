*-----------------------------------------------------------
* Title      :  EA Decoders
* Written by :  Team Dankware - Connor Davis McGwire
* Date       :  3/2/2017
* Description:  Subroutines for decoding EA bits
*-----------------------------------------------------------

** EA decoder assumes properly formatted bits are stored in D0 **
** D1 will contain the opcode size in bytes (either word or long) **
** Decoder also requires potential address of immediate data in the A0 register **
** A0 will be incremented to the end of the immediate data field. **
** Code pattern is 00<mode><register> **

output      EQU $00010000

IMMEDIATE   EQU %00111100
ABS_WORD    EQU %00111000
ABS_LONG    EQU %00111001
Dn          EQU %00000000
An          EQU %00001000
INDIRECT    EQU %00010000
POST_INC    EQU %00011000
PRE_DEC     EQU %00100000

** REGISTER MAP
* A0 = OUTPUT   Decoder pointer
* A1 =          Display string start
* A2 =          Incremented output string builder

* D0 = INPUT    Mode and register bits
*               / Immediate data read
* D1 = INPUT    Opcode size
*               / Register value
* D2 =          Temp storage
* D3 =          Should output immediate data?

EADecoder_left
        MOVEM.L     D0-D7/A1-A6, -(SP)
        
        ** Swap the mode and register bits
        MOVE.B  D0,D4
        ANDI.B  #%00000111,D0       * Mask mode
        ANDI.B  #%00111000,D4       * Mask register
        LSL.B   #3,D0               * Move mode bits over
        LSR.B   #3,D4               * Move register bits over
        OR.B    D4,D0               * Recombine
        
        BRA     left_skip

EADecoder
        MOVEM.L     D0-D7/A1-A6, -(SP) *Store registers on stack, except D0
left_skip   
        CLR     D2    
        CLR     D3 
        MOVE.B  D1,D2 ** Store opcode size in bytes into D2
        
        LEA     output,A1
        LEA     output,A2
        
        *First, decoder will check for the 3 types with hard coded register values
        MOVE.B  #1,D3
        CMP     #IMMEDIATE,D0
        BEQ     dec_immediate
        
        CMP     #ABS_WORD,D0
        BEQ     dec_abs_word
        
        CMP     #ABS_LONG,D0
        BEQ     dec_abs_long
        
        *If it was none of the above, store the register and mode seperately
        CLR     D3
        MOVE.B  D0,D1
        ANDI.B  #%00111000,D1           *Get mode value
        ANDI.B  #%00000111,D0           *Get register value
        ADDI.B  #$30,D0
              
        CMP     #Dn,D1
        BEQ     dec_Dn 
        
        CMP     #An,D1
        BEQ     dec_An
                
        CMP     #INDIRECT,D1
        BEQ     dec_indirect
                
        CMP     #POST_INC,D1
        BEQ     dec_post_inc
                
        CMP     #PRE_DEC,D1
        BEQ     dec_pre_dec

dec_return ** Common return for all types
        
        ** Print display string
        MOVE.B  #14,D0
        TRAP    #15
        
        ** If there is immediate data to print, print it
        CMP     #1,D3
        BNE     imm_skip
        
        MOVE.B  #15,D0
        MOVE.B  #16,D2
        TRAP    #15

imm_skip
        MOVEM.L     (SP)+, D0-D7/A1-A6 *Return register data from stack, except D0
        RTS
        
**********************************************************************************
        * Individual EA decoders *
**********************************************************************************

dec_immediate   *DECODE IMMEDIATE VALUE*
        MOVE.B  #'#',(A2)+  * Move '#' char into string
        MOVE.B  #'$',(A2)+  * Move '$' char into string
        MOVE.B  #$0,(A2)+   * Null terminate string
        CMP     #2,D2       * Check if data is word length
        BEQ     imm_word    
        
        MOVE.L  (A0)+,D1    * Length was long
        BRA     dec_return
        
imm_word
        MOVE.W  (A0)+,D1    * Length was word
        BRA     dec_return

************************************************************

dec_abs_word    *DECODE ABSOLUTE WORD*
        MOVE.B  #'$',(A2)+  * Move '$' char into string
        MOVE.B  #$0,(A2)+   * Null terminate string
        MOVE.W  (A0)+,D1
        BRA     dec_return
        
************************************************************

dec_abs_long    *DECODE ABSOLUTE LONG*
        MOVE.B  #'$',(A2)+  * Move '$' char into string
        MOVE.B  #$0,(A2)+   * Null terminate string
        MOVE.L  (A0)+,D1
        BRA     dec_return
        
************************************************************

dec_Dn          *DECODE DIRECT DATA*
        MOVE.B  #'D',(A2)+
        MOVE.B  D0,(A2)+
        MOVE.B  #$0,(A2)+
        BRA     dec_return

************************************************************
        
dec_An          *DECODE DIRECT ADDRESS*
        MOVE.B  #'A',(A2)+
        MOVE.B  D0,(A2)+
        MOVE.B  #$0,(A2)+
        BRA     dec_return

************************************************************

dec_indirect    *DECODE INDIRECT ACCESS*
        MOVE.B  #'(',(A2)+
        MOVE.B  #'A',(A2)+
        MOVE.B  D0,(A2)+
        MOVE.B  #')',(A2)+
        MOVE.B  #$0,(A2)+
        BRA     dec_return
        
************************************************************

dec_post_inc    *DECODE INDIRECT POST INCREMENT*
        MOVE.B  #'(',(A2)+
        MOVE.B  #'A',(A2)+
        MOVE.B  D0,(A2)+
        MOVE.B  #')',(A2)+
        MOVE.B  #'+',(A2)+
        MOVE.B  #$0,(A2)+
        BRA     dec_return
        
************************************************************
        
dec_pre_dec    *DECODE INDIRECT PRE DECREMENT*
        MOVE.B  #'-',(A2)+
        MOVE.B  #'(',(A2)+
        MOVE.B  #'A',(A2)+
        MOVE.B  D0,(A2)+
        MOVE.B  #')',(A2)+
        MOVE.B  #$0,(A2)+
        BRA     dec_return









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
