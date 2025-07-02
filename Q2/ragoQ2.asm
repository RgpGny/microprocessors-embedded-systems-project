;Rag�p G�nay 200316007
;Duygu Kamalak 200316046

LIST P=PIC16F877A
#include <P16F877A.INC>
__CONFIG H'3F31'  ; Konfig�rasyon ayarlar�

; LED Pinlerini Tan�mla
GREEN_LED  EQU  RD0  ; Ye�il LED pini
YELLOW_LED EQU  RD1  ; Sar� LED pini
RED_LED    EQU  RD2  ; K�rm�z� LED pini

; De�i�kenler
S1         EQU  0x20  ; Gecikme sayac� 1
S2         EQU  0x21  ; Gecikme sayac� 2
S3         EQU  0x22  ; Gecikme sayac� 3

ORG 0x00
GOTO START

START
CALL INIT_PORTS  ; Portlar� ba�lat

MAIN_LOOP
CALL GREEN_ON     ; Ye�il LED'i yak
CALL DELAY_3S     ; 3 saniye bekle
CALL GREEN_OFF    ; Ye�il LED'i s�nd�r
CALL YELLOW_ON    ; Sar� LED'i yak
CALL DELAY_3S     ; 3 saniye bekle
CALL YELLOW_OFF   ; Sar� LED'i s�nd�r
CALL RED_ON       ; K�rm�z� LED'i yak
CALL DELAY_2S     ; 2 saniye bekle
CALL YELLOW_ON    ; Sar� LED'i yak
CALL DELAY_1S     ; 1 saniye bekle
CALL RED_OFF      ; K�rm�z� LED'i s�nd�r
CALL YELLOW_OFF   ; Sar� LED'i s�nd�r
GOTO MAIN_LOOP    ; Ana d�ng�ye geri d�n

; Portlar� ba�lat
INIT_PORTS
BANKSEL TRISD
CLRF TRISD        ; T�m RD pinlerini ��k�� olarak ayarla
BANKSEL PORTD
CLRF PORTD        ; T�m RD pinlerini kapat
RETURN

; Ye�il LED'i yak
GREEN_ON
BSF PORTD, GREEN_LED
RETURN

; Ye�il LED'i s�nd�r
GREEN_OFF
BCF PORTD, GREEN_LED
RETURN

; Sar� LED'i yak
YELLOW_ON
BSF PORTD, YELLOW_LED
RETURN

; Sar� LED'i s�nd�r
YELLOW_OFF
BCF PORTD, YELLOW_LED
RETURN

; K�rm�z� LED'i yak
RED_ON
BSF PORTD, RED_LED
RETURN

; K�rm�z� LED'i s�nd�r
RED_OFF
BCF PORTD, RED_LED
RETURN

; 3 saniye gecikme
DELAY_3S
MOVLW D'10'        ; 3 saniye gecikme i�in 10 �a�r�
CALL DELAY_SECONDS
RETURN

; 2 saniye gecikme
DELAY_2S
MOVLW D'7'         ; 2 saniye gecikme i�in 7 �a�r�
CALL DELAY_SECONDS
RETURN

; Belirtilen saniye kadar gecikme
DELAY_SECONDS
MOVWF S1           ; S1 sayac�n� y�kle
DELAY_LOOP
CALL DELAY_1S      ; 1 saniye gecikme �a�r�s�
DECFSZ S1, F       ; S1 sayac�n� azalt
GOTO DELAY_LOOP    ; S�f�r de�ilse d�ng�ye devam et
RETURN

; 1 saniye gecikme
DELAY_1S
MOVLW D'250'       ; 250 y�kle
MOVWF S2           ; S2 sayac�na
MOVLW D'255'       ; 255 y�kle
MOVWF S3           ; S3 sayac�na
DELAY_1S_INNER
DECFSZ S3, F       ; S3 sayac�n� azalt
GOTO $+2           ; S�f�r de�ilse devam et
DECFSZ S2, F       ; S2 sayac�n� azalt
GOTO DELAY_1S_INNER; S�f�r de�ilse i� d�ng�ye d�n
RETURN

END  ; Program sonu
