;Ragýp Günay 200316007
;Duygu Kamalak 200316046

LIST P = PIC16F877A
#include <P16F877A.INC>
__CONFIG H'3F31'  ; Konfigürasyon ayarlarý

; TANIMLAMALAR
DEG     EQU     0X20  ; ADC'den okunan deðer
COUNT   EQU     0X21  ; Sayýcý
ONES    EQU     0X22  ; Birler basamaðý
TENS    EQU     0X23  ; Onlar basamaðý

ORG     0X00
GOTO    START  ; Baþlangýç adresi

START
        ; Portlarý baþlatma
        BANKSEL TRISA
        CLRF    TRISA  ; PORTA pinlerini çýkýþ olarak ayarla
        CLRF    TRISB  ; PORTB pinlerini çýkýþ olarak ayarla
        CLRF    TRISC  ; PORTC pinlerini çýkýþ olarak ayarla
        CLRF    TRISD  ; PORTD pinlerini çýkýþ olarak ayarla
        BANKSEL PORTA
        CLRF    PORTB  ; PORTB pinlerini temizle
        CLRF    PORTC  ; PORTC pinlerini temizle
        MOVLW   B'01001001'  
        MOVWF   ADCON0  ; ADC'yi baþlat ve kanal seçimi
        BANKSEL ADCON1
        MOVLW   B'10000000'  
        MOVWF   ADCON1  ; ADC ayarlarý

LOOP
        CALL    ReadADC     ; ADC'den analog sinyal oku
        BANKSEL PORTD
        MOVWF   PORTD       ; ADC sonucunu PORTD'ye yaz
        CALL    SEGMENT     ; Sayýyý segmentlere ayýr ve göster
        GOTO    LOOP        ; Sonsuz döngü

; Analog sinyali oku
ReadADC
        BANKSEL ADCON0
        BSF     ADCON0, GO  ; ADC dönüþümünü baþlat
READ
        BTFSC   ADCON0, GO  ; Dönüþüm tamamlanana kadar bekle
        GOTO    READ
        BANKSEL ADRESH
        RRF     ADRESH, F   ; ADRESH'den sonucu oku
        BANKSEL ADRESL
        RRF     ADRESL, W   ; ADRESL'den sonucu oku
RETURN

; Sayýyý segmentlere ayýr ve göster
SEGMENT
        CLRF    COUNT       ; Sayýcýyý sýfýrla
        MOVFW   PORTD
        MOVWF   DEG         ; ADC sonucunu DEG deðiþkenine ata
BACK
        MOVLW   0x0A
        SUBWF   DEG, W      ; DEG'den 10 çýkar
        BTFSC   STATUS, Z   ; Sonuç sýfýr mý?
        GOTO    EQUAL
        BTFSS   STATUS, C   ; Sonuç pozitif mi?
        GOTO    LESS
GREATER:
        INCF    COUNT, F    ; Sayýcýyý artýr
        MOVLW   0x0A
        SUBWF   DEG, F      ; DEG'den 10 çýkar
        GOTO    BACK

EQUAL:
        INCF    COUNT, F    ; Sayýcýyý artýr
        MOVF    COUNT, W
        MOVWF   TENS        ; Onlar basamaðýna ata
        MOVLW   0x00
        MOVWF   ONES        ; Birler basamaðýný sýfýrla
        GOTO    UPDATE_DISP

LESS:
        MOVF    COUNT, W
        MOVWF   TENS        ; Onlar basamaðýna ata
        MOVF    DEG, W
        MOVWF   ONES        ; Birler basamaðýna ata

UPDATE_DISP:
        MOVF    TENS, W
        CALL    GET_SEGMENT_CODE  ; Segment kodunu al
        MOVWF   PORTB       ; Onlar basamaðýný PORTB'ye yaz
        MOVF    ONES, W
        CALL    GET_SEGMENT_CODE  ; Segment kodunu al
        MOVWF   PORTC       ; Birler basamaðýný PORTC'ye yaz
        GOTO    LOOP        ; Ana döngüye geri dön

; Segment kodunu al
GET_SEGMENT_CODE
        ADDWF PCL, F        ; Program counter'a ekle
        RETLW 0x3F  ; 0    ; 0 için segment kodu
        RETLW 0x06  ; 1    ; 1 için segment kodu
        RETLW 0x5B  ; 2    ; 2 için segment kodu
        RETLW 0x4F  ; 3    ; 3 için segment kodu
        RETLW 0x66  ; 4    ; 4 için segment kodu
        RETLW 0x6D  ; 5    ; 5 için segment kodu
        RETLW 0x7D  ; 6    ; 6 için segment kodu
        RETLW 0x07  ; 7    ; 7 için segment kodu
        RETLW 0x7F  ; 8    ; 8 için segment kodu
        RETLW 0x6F  ; 9    ; 9 için segment kodu

END  ; Program sonu
