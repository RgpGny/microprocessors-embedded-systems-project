;Rag�p G�nay 200316007
;Duygu Kamalak 200316046

LIST P = PIC16F877A
#include <P16F877A.INC>
__CONFIG H'3F31'  ; Konfig�rasyon ayarlar�

; TANIMLAMALAR
DEG     EQU     0X20  ; ADC'den okunan de�er
COUNT   EQU     0X21  ; Say�c�
ONES    EQU     0X22  ; Birler basama��
TENS    EQU     0X23  ; Onlar basama��

ORG     0X00
GOTO    START  ; Ba�lang�� adresi

START
        ; Portlar� ba�latma
        BANKSEL TRISA
        CLRF    TRISA  ; PORTA pinlerini ��k�� olarak ayarla
        CLRF    TRISB  ; PORTB pinlerini ��k�� olarak ayarla
        CLRF    TRISC  ; PORTC pinlerini ��k�� olarak ayarla
        CLRF    TRISD  ; PORTD pinlerini ��k�� olarak ayarla
        BANKSEL PORTA
        CLRF    PORTB  ; PORTB pinlerini temizle
        CLRF    PORTC  ; PORTC pinlerini temizle
        MOVLW   B'01001001'  
        MOVWF   ADCON0  ; ADC'yi ba�lat ve kanal se�imi
        BANKSEL ADCON1
        MOVLW   B'10000000'  
        MOVWF   ADCON1  ; ADC ayarlar�

LOOP
        CALL    ReadADC     ; ADC'den analog sinyal oku
        BANKSEL PORTD
        MOVWF   PORTD       ; ADC sonucunu PORTD'ye yaz
        CALL    SEGMENT     ; Say�y� segmentlere ay�r ve g�ster
        GOTO    LOOP        ; Sonsuz d�ng�

; Analog sinyali oku
ReadADC
        BANKSEL ADCON0
        BSF     ADCON0, GO  ; ADC d�n���m�n� ba�lat
READ
        BTFSC   ADCON0, GO  ; D�n���m tamamlanana kadar bekle
        GOTO    READ
        BANKSEL ADRESH
        RRF     ADRESH, F   ; ADRESH'den sonucu oku
        BANKSEL ADRESL
        RRF     ADRESL, W   ; ADRESL'den sonucu oku
RETURN

; Say�y� segmentlere ay�r ve g�ster
SEGMENT
        CLRF    COUNT       ; Say�c�y� s�f�rla
        MOVFW   PORTD
        MOVWF   DEG         ; ADC sonucunu DEG de�i�kenine ata
BACK
        MOVLW   0x0A
        SUBWF   DEG, W      ; DEG'den 10 ��kar
        BTFSC   STATUS, Z   ; Sonu� s�f�r m�?
        GOTO    EQUAL
        BTFSS   STATUS, C   ; Sonu� pozitif mi?
        GOTO    LESS
GREATER:
        INCF    COUNT, F    ; Say�c�y� art�r
        MOVLW   0x0A
        SUBWF   DEG, F      ; DEG'den 10 ��kar
        GOTO    BACK

EQUAL:
        INCF    COUNT, F    ; Say�c�y� art�r
        MOVF    COUNT, W
        MOVWF   TENS        ; Onlar basama��na ata
        MOVLW   0x00
        MOVWF   ONES        ; Birler basama��n� s�f�rla
        GOTO    UPDATE_DISP

LESS:
        MOVF    COUNT, W
        MOVWF   TENS        ; Onlar basama��na ata
        MOVF    DEG, W
        MOVWF   ONES        ; Birler basama��na ata

UPDATE_DISP:
        MOVF    TENS, W
        CALL    GET_SEGMENT_CODE  ; Segment kodunu al
        MOVWF   PORTB       ; Onlar basama��n� PORTB'ye yaz
        MOVF    ONES, W
        CALL    GET_SEGMENT_CODE  ; Segment kodunu al
        MOVWF   PORTC       ; Birler basama��n� PORTC'ye yaz
        GOTO    LOOP        ; Ana d�ng�ye geri d�n

; Segment kodunu al
GET_SEGMENT_CODE
        ADDWF PCL, F        ; Program counter'a ekle
        RETLW 0x3F  ; 0    ; 0 i�in segment kodu
        RETLW 0x06  ; 1    ; 1 i�in segment kodu
        RETLW 0x5B  ; 2    ; 2 i�in segment kodu
        RETLW 0x4F  ; 3    ; 3 i�in segment kodu
        RETLW 0x66  ; 4    ; 4 i�in segment kodu
        RETLW 0x6D  ; 5    ; 5 i�in segment kodu
        RETLW 0x7D  ; 6    ; 6 i�in segment kodu
        RETLW 0x07  ; 7    ; 7 i�in segment kodu
        RETLW 0x7F  ; 8    ; 8 i�in segment kodu
        RETLW 0x6F  ; 9    ; 9 i�in segment kodu

END  ; Program sonu
