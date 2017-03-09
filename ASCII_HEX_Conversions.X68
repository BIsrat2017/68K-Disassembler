*-----------------------------------------------------------
* Title      :  ASCII/HEX Converters
* Written by :  Team Dankware - Connor Davis McGwire
* Date       :  2/17/2017
* Description:  Series of subroutines for converting between 
*               ASCII bytes and hex numbers stored as individual bytes.
*-----------------------------------------------------------

** All subroutines assume that the data is pointed to by A0 **
** Length of data to convert, in bytes, stored in D0. Size limit, word.
** Number value returned in D0, number bytes left in A0 location

******* ASCII to HEX operations

A2H     *Converts and ASCII Byte string into HEX; Size WORD
        MOVEM.L     D1-D7/A0-A6, -(SP)  
        
        MOVE.W  D0,D2
        MOVE.W  D2,D1                   *Store length of string into D1 for looping
        MOVEA.L A0,A1                   *Copy starting point of string

        BRA     numSub
numSubRTN
        MOVEA.L A1,A0                   *Restore address position
        MOVE.W  D2,D1                   *Reset loop counter
        
        BRA     upSub
upSubRTN        
        MOVEA.L A1,A0                   *Restore address position
        MOVE.W  D2,D1                   *Reset loop counter
        CLR     D0                      *Clear D0
addBytes
        ADD.B   (A0)+,D0
        SUBI.B  #1,D1
        BEQ     conv_end
addByteLoop
        ASL.L   #4,D0
        ADD.B   (A0)+,D0
        SUBI.B  #1,D1
        BNE     addByteLoop
conv_end
        MOVEM.L     (SP)+, D1-D7/A0-A6
        RTS
        
numSub  *Convert ASCII 'number' to true number byte; Should not be called outside of the A2H subroutines
        SUBI.B  #$30,(A0)+              *Subtract difference between null ASCII and '0' ASCII
        SUB.W   #1,D1                   *Decrement loop counter
        BNE     numSub                  *If loop has not ended restart
        BRA     numSubRTN

upSub   *Loops through string to remove any upper case characters 
        *that may remain in the string
        CMPI.B  #9,(A0)                 *Check if the value is greater than 0-9
        BLE     upSEnd                  *If it's not, continue loop
        SUBI.B  #1,(A0)                 *Otherwise, subtract difference between ASCII 'number' code and 'A' code
upSEnd
        ADDA.W  #1,A0                   *Increment to next position to check for uppercase
        SUB.W   #1,D1                   *Decrement loop counter
        BNE     upSub                   
        BRA     upSubRTN


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
