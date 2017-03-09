*****************************
*
* demo_arsany_opcode_test.X68
*
* Created 03/09/2017
*
* Test program for Arsany's commands
*
*****************************

start	EQU	$00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

        ORG	start
        
        MOVEA.W #$7777,A1
        MOVEA.L #$89898989,A2
        ADDA.W  D0,A1
        ADDA.L  D0,A2
        MULS.W  D1,D2
        CMP.B   D1,D2
        CMP.W   D1,D2
        CMP.L   D1,D2
        CLR.B   D0
        CLR.W   D1
        CLR.L   D2
        
        AND.B   D0,D1
        AND.W   D0,D2
        AND.L   D0,D3
        AND.B   D1,$4567
        AND.W   D1,(A1)
        AND.L   D1,(A2)+
        
        SIMHALT

next
        RTS      
        
	END	start

































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
