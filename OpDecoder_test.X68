*-----------------------------------------------------------
* Title      : OpDecoder driver test
* Written by : Connor McGwire
* Date       : 3/8/2017
* Description: Tests using OpDecoder as external file
*-----------------------------------------------------------
        INCLUDE 'opcodes.x68'

START   ORG     $2000
        
        MOVEA.W #$7000,A0
        JSR     OpDecoder

        END     $2000

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
