;Realizar la programación en ensamblador del PIC16F84A de un circuito que tenga 8 leds conectados a
;la salida (puerto B). Realizar un programa que permita rotar el dato 03h en el puerto B a la izquierda y
;cuando llegue al bit 7 se realice la rotación a la derecha, de la posición de bit 7 a la posición de bit 0 de
;forma infinita. 
;El circuito tendrá un botón de RESET conectado al puerto A, de manera que al pulsarse
;se lanzará una interrupción que hará que todos los leds se apaguen durante 1 segundo y a continuación
;volverán a encenderse y a iniciar de nuevo la secuencia de iluminación. 
;Incluya también  un	WatchDog	que	cada	2	segundos	reinicialice	la	secuencia	de	iluminación
;====================================================================
;	CONFIGURACIÓN
;====================================================================
    
__CONFIG	_CP_OFF&_PWRTE_ON&_XT_OSC
LIST 		P=16F84A 
INCLUDE		<P16F84A.INC> 
ctr EQU 0x0C
ORG	 0x00 
goto inicio
ORG  0x04       ;Vector de interrupción
goto rut_tmr    ;Salto incondicional a la subrutina de 
                ;atención del temporizador
                ;Temp=4*Tosc*(256-TMR0)*Factor de división

;====================================================================
;	CONFIGURACIÓN	
;====================================================================
inicio    
bsf     STATUS,RP0  ;bit 5 (RP0) a 1, para entrar al banco 1
clrf	TRISB       ;Puerto B como salidas
movlw   b'11000111' ;configuración del modulo TMR0
movwf   OPTION_REG  ;Preescaler =256
movlw	b'00000001' ;bit 0 a 1, para el boton de reset
movwf	TRISA
bcf     STATUS,RP0  ;bit 5 (RP0) a 0, volvemos al banco 0
movlw   0x03    ;carga la constante 0x03 en el registro W
movwf   PORTB   ; PORTB=W
movlw d'16' ;Necesitamos 32 temporizaciones
movwf ctr
movlw d'12' ;temporizacion de TMR0=12 para 62.26 ms
movwf TMR0
movlw b'10100000'
movwf INTCON
;====================================================================
;	CÓDIGO
;====================================================================
Bucle
    btfsc  PORTA,RA0
    goto rut_tmr
    goto   izquierda
         
;====================================================================
izquierda
    rlf PORTB,1
    btfss STATUS,C
    goto Bucle
    goto derecha
derecha
    rrf PORTB,1
    btfss STATUS,C
    goto derecha
    goto izquierda
rut_tmr
    decfsz ctr,F
    goto no_cero
    clrf PORTB
    movlw d'32'
    movwf ctr
no_cero
    movlw d'12'
    movwf TMR0
    bcf INTCON,T0IF
    retfie
    
    
    
;==============================================

END   