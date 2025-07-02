;Ragýp Günay 200316007
;Duygu Kamalak 200316046

LIST P=PIC16F877A
#include <P16F877A.INC>
__CONFIG H'3F31'  ; Konfigürasyon ayarlarý

; LED Pinlerini Tanýmla
GREEN_LED  EQU  RD0  ; Yeþil LED pini
YELLOW_LED EQU  RD1  ; Sarý LED pini
RED_LED    EQU  RD2  ; Kýrmýzý LED pini

; Deðiþkenler
S1         EQU  0x20  ; Gecikme sayacý 1
S2         EQU  0x21  ; Gecikme sayacý 2
S3         EQU  0x22  ; Gecikme sayacý 3

ORG 0x00
GOTO START

START
CALL INIT_PORTS  ; Portlarý baþlat

MAIN_LOOP
CALL GREEN_ON     ; Yeþil LED'i yak
CALL DELAY_3S     ; 3 saniye bekle
CALL GREEN_OFF    ; Yeþil LED'i söndür
CALL YELLOW_ON    ; Sarý LED'i yak
CALL DELAY_3S     ; 3 saniye bekle
CALL YELLOW_OFF   ; Sarý LED'i söndür
CALL RED_ON       ; Kýrmýzý LED'i yak
CALL DELAY_2S     ; 2 saniye bekle
CALL YELLOW_ON    ; Sarý LED'i yak
CALL DELAY_1S     ; 1 saniye bekle
CALL RED_OFF      ; Kýrmýzý LED'i söndür
CALL YELLOW_OFF   ; Sarý LED'i söndür
GOTO MAIN_LOOP    ; Ana döngüye geri dön

; Portlarý baþlat
INIT_PORTS
BANKSEL TRISD
CLRF TRISD        ; Tüm RD pinlerini çýkýþ olarak ayarla
BANKSEL PORTD
CLRF PORTD        ; Tüm RD pinlerini kapat
RETURN

; Yeþil LED'i yak
GREEN_ON
BSF PORTD, GREEN_LED
RETURN

; Yeþil LED'i söndür
GREEN_OFF
BCF PORTD, GREEN_LED
RETURN

; Sarý LED'i yak
YELLOW_ON
BSF PORTD, YELLOW_LED
RETURN

; Sarý LED'i söndür
YELLOW_OFF
BCF PORTD, YELLOW_LED
RETURN

; Kýrmýzý LED'i yak
RED_ON
BSF PORTD, RED_LED
RETURN

; Kýrmýzý LED'i söndür
RED_OFF
BCF PORTD, RED_LED
RETURN

; 3 saniye gecikme
DELAY_3S
MOVLW D'10'        ; 3 saniye gecikme için 10 çaðrý
CALL DELAY_SECONDS
RETURN

; 2 saniye gecikme
DELAY_2S
MOVLW D'7'         ; 2 saniye gecikme için 7 çaðrý
CALL DELAY_SECONDS
RETURN

; Belirtilen saniye kadar gecikme
DELAY_SECONDS
MOVWF S1           ; S1 sayacýný yükle
DELAY_LOOP
CALL DELAY_1S      ; 1 saniye gecikme çaðrýsý
DECFSZ S1, F       ; S1 sayacýný azalt
GOTO DELAY_LOOP    ; Sýfýr deðilse döngüye devam et
RETURN

; 1 saniye gecikme
DELAY_1S
MOVLW D'250'       ; 250 yükle
MOVWF S2           ; S2 sayacýna
MOVLW D'255'       ; 255 yükle
MOVWF S3           ; S3 sayacýna
DELAY_1S_INNER
DECFSZ S3, F       ; S3 sayacýný azalt
GOTO $+2           ; Sýfýr deðilse devam et
DECFSZ S2, F       ; S2 sayacýný azalt
GOTO DELAY_1S_INNER; Sýfýr deðilse iç döngüye dön
RETURN

END  ; Program sonu
