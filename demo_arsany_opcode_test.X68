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
        
        MOVEA.W D0,A0
        MOVEA.L #$67678989,A1
        
        ADDA.W  #$45,A0
        ADDA.L  D0,A1
ayylmao
        MULS.W  (A0),D3
        
        RTS
        
        CMP.B   (A0)+,D1
        CMP.W   #$4545,D2
        CMP.L   #$87878787,D3
        
        JSR     ayylmao
        
        CLR.B   D0
        CLR.W   D1
        CLR.L   D3
        
        AND.B   $00005676,D0
        AND.W   (A0),D0
        AND.L   #$78787878,D0
        
        AND.B   D0,$00004545
        AND.W   D0,(A0)
        AND.L   D0,(A1)+
        
        OR.B    $00005676,D0
        OR.W    (A0),D0
        OR.L    #$78787878,D0
        
        OR.B    D0,$00004545
        OR.W    D0,(A0)
        OR.L    D0,(A1)+
        
        LEA     start,A0
        SIMHALT
    
        
	    END	start






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
