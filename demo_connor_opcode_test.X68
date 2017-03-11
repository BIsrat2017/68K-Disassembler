*****************************
*
* demo_connor_opcode_test.X68
*
* Created 03/09/2017
*
* Test program for Connor's commands
*
*****************************

start	EQU	$00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

        ORG	start
        
        MOVEM.W D0-D3/D5-D7/A0-A6,-(SP)
        MOVEM.L D0-D3/D5-D7/A0-A6,-(SP)
        MOVEM.W (SP)+,D0-D3/D5-D7/A0-A6
        MOVEM.L (SP)+,D0-D3/D5-D7/A0-A6
        NOP
        MOVE.B  D0,D1
        MOVE.W  D0,$56AA
        MOVE.L  #$44444444,(A0)
        MOVEQ   #$45,D1
        ADDI.B  #$45,D2
        ADDI.W  #$8777,D3
        ADDI.L  #$00999988,D4
        ADD.B   D0,(A0)+
        ADD.W   D1,-(A0)
        ADD.L   D3,$45666666
        ADD.B   D3,D0
        ADD.W   D3,D1
        ADD.L   D3,D2
        SUB.B   D0,(A0)+
        SUB.W   D1,-(A0)
        SUB.L   D3,$45666666
        SUB.B   D3,D0
        SUB.W   D3,D1
        SUB.L   D3,D2
        ADDQ.B  #5,D1
        ADDQ.W  #4,(A0)
        ADDQ.L  #6,$4567
        DIVU.W  (A0),D2
        
        SIMHALT
    
        
	    END	start





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
