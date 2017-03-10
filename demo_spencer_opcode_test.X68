*****************************
*
* demo_spencer_opcode_test.X68
*
* Created 03/09/2017
*
* Test program for Spencer's commands
*
*****************************

start	EQU	$00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

        ORG	    start
        
        BCC.B   label1
        BCC.B   label2
        BGT.B   label1
        BGT.B   label2
        BLE.B   label1
        BLE.B   label2
        BCC.W   label1
        BCC.W   label2
        BCC.W   label3
label1
        BGT.W   label1
label2
        BGT.W   label2
        BGT.W   label3
        BLE.W   label1
        BLE.W   label2
        BLE.W   label3
        BCC.B   label4
        BGT.B   label4
        BLE.B   label4
label3
        BCC.W   label1
        BCC.W   label2
        BCC.W   label3
        BGT.W   label1
        BGT.W   label2
label4
        BGT.W   label3
        BLE.W   label1
        BLE.W   label2
        BLE.W   label3

        
        SIMHALT
    
        
	    END	start



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
