*-----------------------------------------------------------
* Title      :  ASCII/HEX Converters
* Written by :  Team Dankware - Connor Davis McGwire
* Date       :  2/17/2017
* Description:  Series of subroutines for converting between 
*               ASCII bytes and hex numbers stored as individual bytes.
*-----------------------------------------------------------

** All subroutines assume that the data is pointed to by A0 **

******* ASCII to HEX operations

A2H_W   *Converts and ASCII Byte string into HEX; Size WORD
        MOVEM.L     D0-D7/A1-A6, -(SP)  
        
        MOVE.W  #2,D1                   *Store length of string into D1 for looping
        MOVEA.L A0,A1                   *Copy starting point of string

        BSR.W   numSub
        
        MOVEA.L A1,A0                   *Restore address position
        MOVE.W  #2,D1                   *Reset loop counter
        
        BSR.W   upSub

        MOVEA.L A1,A0
        
        MOVEM.L     (SP)+, D1-D7/A1-A6
        RTS
        
A2H_L   *Converts and ASCII Byte string into HEX; Size LONG
        MOVEM.L     D1-D7/A1-A6, -(SP)  
        
        MOVE.W  #4,D1                   *Store length of string into D1 for looping
        MOVEA.L A0,A1                   *Copy starting point of string

        BSR.W   numSub
        
        MOVEA.L A1,A0                   *Restore address position
        MOVE.W  #4,D1                   *Reset loop counter
        
        BSR.W   upSub

        MOVEA.L A1,A0
        
        MOVEM.L     (SP)+, D1-D7/A1-A6
        RTS

        
        
numSub  *Convert ASCII 'number' to true number byte; Should not be called outside of the A2H subroutines
        SUB.B   #$30,(A0)+              *Subtract difference between null ASCII and '0' ASCII
        SUB.W   #1,D1                   *Decrement loop counter
        BNE     numSub                  *If loop has not ended restart


upSub   *Loops through string to remove any upper case characters 
        *that may remain in the string
        CMPI    #9,(A0)+                *Check if the value is greater than 0-9
        BLE     upSEnd                  *If it's not, continue loop
        SUB.B   #7,-(A0)                *Otherwise, subtract difference between ASCII 'number' code and 'A' code
        ADDA.L  #1,A0                   *Return A0 to next position in string
upSEnd
        SUB.W   #1,D1                   
        BNE     upSub  
        RTS


******* HEX to ASCII Operations


H2A_W   *Converts and ASCII Byte string into HEX; Size WORD
        MOVEM.L     D0-D7/A1-A6, -(SP)  
        
        MOVE.W  #2,D1                   *Store length of string into D1 for looping
        MOVEA.L A0,A1                   *Copy starting point of string

        BSR.W   numAdd
        
        MOVEA.L A1,A0                   *Restore address position
        MOVE.W  #2,D1                   *Reset loop counter
        
        BSR.W   upAdd

        MOVEA.L A1,A0
        
        MOVEM.L     (SP)+, D1-D7/A1-A6
        RTS
        
H2A_L   *Converts and ASCII Byte string into HEX; Size LONG
        MOVEM.L     D1-D7/A1-A6, -(SP)  
        
        MOVE.W  #4,D1                   *Store length of string into D1 for looping
        MOVEA.L A0,A1                   *Copy starting point of string

        BSR.W   numAdd
        
        MOVEA.L A1,A0                   *Restore address position
        MOVE.W  #4,D1                   *Reset loop counter
        
        BSR.W   upAdd

        MOVEA.L A1,A0
        
        MOVEM.L     (SP)+, D1-D7/A1-A6
        RTS

        
        
numAdd  *Convert ASCII 'number' to true number byte; Should not be called outside of the A2H subroutines
        ADD.B   #$30,(A0)+              *Subtract difference between null ASCII and '0' ASCII
        SUB.W   #1,D1                   *Decrement loop counter
        BNE     numSub                  *If loop has not ended restart


upAdd   *Loops through string to remove any upper case characters 
        *that may remain in the string
        CMPI    #9,(A0)+                *Check if the value is greater than 0-9
        BLE     upAEnd                  *If it's not, continue loop
        ADD.B   #7,-(A0)                *Otherwise, subtract difference between ASCII 'number' code and 'A' code
        ADDA.L  #1,A0                   *Return A0 to next position in string
upAEnd
        SUB.W   #1,D1                   
        BNE     upAdd  
        RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
