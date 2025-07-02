;Ragýp Günay 200316007
;Duygu Kamalak 200316046

LIST P = PIC16F877A
#include <P16F877A.INC>
__CONFIG H'3F31'  ; Konfigürasyon ayarlarý

; TANIMLAMALAR
#define RS PORTC,0  ; LCD Register Select pini
#define RW PORTC,1  ; LCD Read/Write pini
#define EN PORTC,2  ; LCD Enable pini

; DEÐÝÞKENLER
S1          EQU 0X20  ; Gecikme sayacý 1
S2          EQU 0X21  ; Gecikme sayacý 2
TEMP        EQU 0X22  ; Geçici deðiþken
COUNTER     EQU 0X23  ; Sayýcý (Kullanýlmýyor)
UNITS       EQU 0X24  ; Birler basamaðý
TENS        EQU 0X25  ; Onlar basamaðý

; BAÞLANGIÇ
ORG 0X00
GOTO START

; KESME VEKTÖRÜ
ORG 0x04  
GOTO ISR  ; Kesme Servis Rutini

START
CALL REG_INIT  ; Portlarý baþlat
CALL LCD_INIT  ; LCD'yi baþlat

MOVLW    0x80  ; LCD'nin ilk satýrýna yazmaya baþla
CALL    LCD_COMMAND
CALL 	PRINTC  ; LCD'ye "COUNTER:" yaz

; KESMELERÝ ETKÝNLEÞTÝRME
BSF INTCON, GIE   ; Genel kesmeleri etkinleþtir
BSF INTCON, PEIE  ; Çevresel kesmeleri etkinleþtir
BSF INTCON, INTE  ; Harici kesmeleri etkinleþtir
BCF INTCON, INTF  ; Harici kesme bayraðýný temizle

MAIN_LOOP
GOTO MAIN_LOOP  ; Sonsuz döngü

; Kesme Servis Rutini
ISR
BCF INTCON, INTF  ; Harici kesme bayraðýný temizle
CALL INCREMENT_UNITS  ; Birler basamaðýný artýr
CALL DISPLAY_NUMBER  ; Sayýyý LCD'de göster
RETFIE  ; Kesmeden çýk

; Port Baþlatma
REG_INIT
BANKSEL TRISC
MOVLW   B'00000001'  ; RB0 giriþ, diðer tüm pinler çýkýþ
MOVWF   TRISB  ; TRISB registerini ayarla
CLRF    TRISC  ; Tüm TRISC pinlerini çýkýþ olarak ayarla
CLRF    TRISD  ; Tüm TRISD pinlerini çýkýþ olarak ayarla
BANKSEL PORTD
CLRF    PORTD  ; Tüm PORTD pinlerini temizle
CLRF    PORTB  ; Tüm PORTB pinlerini temizle
CLRF    UNITS  ; Birler basamaðýný sýfýrla
CLRF    TENS   ; Onlar basamaðýný sýfýrla
RETURN

; LCD'ye "COUNTER:" yaz
PRINTC
MOVLW	"C"
CALL	LCD_DATA
MOVLW	"O"
CALL	LCD_DATA
MOVLW	"U"
CALL	LCD_DATA
MOVLW	"N"
CALL	LCD_DATA
MOVLW	"T"
CALL	LCD_DATA
MOVLW	"E"
CALL	LCD_DATA
MOVLW	"R"
CALL	LCD_DATA
MOVLW	":"
CALL	LCD_DATA
RETURN

; Birler Basamaðýný Artýr
INCREMENT_UNITS
INCF    UNITS, F  ; Birler basamaðýný 1 artýr
MOVLW   0x0A  ; Eðer 10 olduysa
SUBWF   UNITS, W
BTFSS   STATUS, Z
RETURN
CLRF    UNITS  ; Birler basamaðýný sýfýrla
CALL    INCREMENT_TENS  ; Onlar basamaðýný artýr
RETURN

; Onlar Basamaðýný Artýr
INCREMENT_TENS
INCF    TENS, F  ; Onlar basamaðýný 1 artýr
MOVLW   0x0A  ; Eðer 10 olduysa
SUBWF   TENS, W
BTFSS   STATUS, Z
RETURN
CLRF    TENS  ; Onlar basamaðýný sýfýrla
RETURN

; Sayýyý LCD'de Göster
DISPLAY_NUMBER
MOVLW    0xC0  ; Ýmleci ikinci satýra taþý
CALL    LCD_COMMAND
BANKSEL TENS
MOVF    TENS, W
ADDLW   '0'  ; Onlar basamaðýný karaktere çevir
CALL    LCD_DATA
BANKSEL UNITS
MOVF    UNITS, W
ADDLW   '0'  ; Birler basamaðýný karaktere çevir
CALL    LCD_DATA
RETURN

; LCD Baþlatma
LCD_INIT
MOVLW    0X38  ; 8-bit mode, 2-line display, 5x8 font
CALL     LCD_COMMAND
MOVLW    0X06  ; Entry mode set
CALL     LCD_COMMAND
MOVLW    0X0E  ; Display on, cursor on
CALL     LCD_COMMAND
MOVLW    0X01  ; Display clear
CALL     LCD_COMMAND
RETURN

; LCD Komutu
LCD_COMMAND
BCF     RS  ; RS = 0 (Komut modu)
BCF     RW  ; RW = 0 (Yazma modu)
BSF     EN  ; Enable = 1
MOVWF   TEMP  ; Geçici deðiþkene komutu yaz
CALL    DELAY  ; Kýsa bir gecikme
MOVFW   TEMP  ; Geçici deðiþkenden veriyi oku
BANKSEL PORTD
MOVWF   PORTD  ; Veriyi PORTD'ye yaz
BCF     EN  ; Enable = 0
RETURN

; LCD Verisi
LCD_DATA
BSF     RS  ; RS = 1 (Veri modu)
BCF     RW  ; RW = 0 (Yazma modu)
BSF     EN  ; Enable = 1
MOVWF   TEMP  ; Geçici deðiþkene veriyi yaz
CALL    DELAY  ; Kýsa bir gecikme
MOVFW   TEMP  ; Geçici deðiþkenden veriyi oku
BANKSEL PORTD
MOVWF   PORTD  ; Veriyi PORTD'ye yaz
BCF     EN  ; Enable = 0
RETURN

; Gecikme Rutini
DELAY
MOVLW 0XFF
MOVWF S1  ; Gecikme sayacý 1
L1
    MOVLW 0XFF
    MOVWF S2  ; Gecikme sayacý 2
L2
    DECFSZ S2  ; S2'yi azalt
    GOTO   L2
    DECFSZ S1  ; S1'i azalt
    GOTO   L1
RETURN

END  ; Program sonu
;Ragýp Günay 200316007
;Duygu Kamalak 200316046
LIST P = PIC16F877A
#include <P16F877A.INC>
__CONFIG H'3F31'  ; Konfigürasyon ayarlarý

; TANIMLAMALAR
#define RS PORTC,0  ; LCD Register Select pini
#define RW PORTC,1  ; LCD Read/Write pini
#define EN PORTC,2  ; LCD Enable pini

; DEÐÝÞKENLER
S1          EQU 0X20  ; Gecikme sayacý 1
S2          EQU 0X21  ; Gecikme sayacý 2
TEMP        EQU 0X22  ; Geçici deðiþken
COUNTER     EQU 0X23  ; Sayýcý (Kullanýlmýyor)
UNITS       EQU 0X24  ; Birler basamaðý
TENS        EQU 0X25  ; Onlar basamaðý

; BAÞLANGIÇ
ORG 0X00
GOTO START

; KESME VEKTÖRÜ
ORG 0x04  
GOTO ISR  ; Kesme Servis Rutini

START
CALL REG_INIT  ; Portlarý baþlat
CALL LCD_INIT  ; LCD'yi baþlat

MOVLW    0x80  ; LCD'nin ilk satýrýna yazmaya baþla
CALL    LCD_COMMAND
CALL 	PRINTC  ; LCD'ye "COUNTER:" yaz

; KESMELERÝ ETKÝNLEÞTÝRME
BSF INTCON, GIE   ; Genel kesmeleri etkinleþtir
BSF INTCON, PEIE  ; Çevresel kesmeleri etkinleþtir
BSF INTCON, INTE  ; Harici kesmeleri etkinleþtir
BCF INTCON, INTF  ; Harici kesme bayraðýný temizle

MAIN_LOOP
GOTO MAIN_LOOP  ; Sonsuz döngü

; Kesme Servis Rutini
ISR
BCF INTCON, INTF  ; Harici kesme bayraðýný temizle
CALL INCREMENT_UNITS  ; Birler basamaðýný artýr
CALL DISPLAY_NUMBER  ; Sayýyý LCD'de göster
RETFIE  ; Kesmeden çýk

; Port Baþlatma
REG_INIT
BANKSEL TRISC
MOVLW   B'00000001'  ; RB0 giriþ, diðer tüm pinler çýkýþ
MOVWF   TRISB  ; TRISB registerini ayarla
CLRF    TRISC  ; Tüm TRISC pinlerini çýkýþ olarak ayarla
CLRF    TRISD  ; Tüm TRISD pinlerini çýkýþ olarak ayarla
BANKSEL PORTD
CLRF    PORTD  ; Tüm PORTD pinlerini temizle
CLRF    PORTB  ; Tüm PORTB pinlerini temizle
CLRF    UNITS  ; Birler basamaðýný sýfýrla
CLRF    TENS   ; Onlar basamaðýný sýfýrla
RETURN

; LCD'ye "COUNTER:" yaz
PRINTC
MOVLW	"C"
CALL	LCD_DATA
MOVLW	"O"
CALL	LCD_DATA
MOVLW	"U"
CALL	LCD_DATA
MOVLW	"N"
CALL	LCD_DATA
MOVLW	"T"
CALL	LCD_DATA
MOVLW	"E"
CALL	LCD_DATA
MOVLW	"R"
CALL	LCD_DATA
MOVLW	":"
CALL	LCD_DATA
RETURN

; Birler Basamaðýný Artýr
INCREMENT_UNITS
INCF    UNITS, F  ; Birler basamaðýný 1 artýr
MOVLW   0x0A  ; Eðer 10 olduysa
SUBWF   UNITS, W
BTFSS   STATUS, Z
RETURN
CLRF    UNITS  ; Birler basamaðýný sýfýrla
CALL    INCREMENT_TENS  ; Onlar basamaðýný artýr
RETURN

; Onlar Basamaðýný Artýr
INCREMENT_TENS
INCF    TENS, F  ; Onlar basamaðýný 1 artýr
MOVLW   0x0A  ; Eðer 10 olduysa
SUBWF   TENS, W
BTFSS   STATUS, Z
RETURN
CLRF    TENS  ; Onlar basamaðýný sýfýrla
RETURN

; Sayýyý LCD'de Göster
DISPLAY_NUMBER
MOVLW    0xC0  ; Ýmleci ikinci satýra taþý
CALL    LCD_COMMAND
BANKSEL TENS
MOVF    TENS, W
ADDLW   '0'  ; Onlar basamaðýný karaktere çevir
CALL    LCD_DATA
BANKSEL UNITS
MOVF    UNITS, W
ADDLW   '0'  ; Birler basamaðýný karaktere çevir
CALL    LCD_DATA
RETURN

; LCD Baþlatma
LCD_INIT
MOVLW    0X38  ; 8-bit mode, 2-line display, 5x8 font
CALL     LCD_COMMAND
MOVLW    0X06  ; Entry mode set
CALL     LCD_COMMAND
MOVLW    0X0E  ; Display on, cursor on
CALL     LCD_COMMAND
MOVLW    0X01  ; Display clear
CALL     LCD_COMMAND
RETURN

; LCD Komutu
LCD_COMMAND
BCF     RS  ; RS = 0 (Komut modu)
BCF     RW  ; RW = 0 (Yazma modu)
BSF     EN  ; Enable = 1
MOVWF   TEMP  ; Geçici deðiþkene komutu yaz
CALL    DELAY  ; Kýsa bir gecikme
MOVFW   TEMP  ; Geçici deðiþkenden veriyi oku
BANKSEL PORTD
MOVWF   PORTD  ; Veriyi PORTD'ye yaz
BCF     EN  ; Enable = 0
RETURN

; LCD Verisi
LCD_DATA
BSF     RS  ; RS = 1 (Veri modu)
BCF     RW  ; RW = 0 (Yazma modu)
BSF     EN  ; Enable = 1
MOVWF   TEMP  ; Geçici deðiþkene veriyi yaz
CALL    DELAY  ; Kýsa bir gecikme
MOVFW   TEMP  ; Geçici deðiþkenden veriyi oku
BANKSEL PORTD
MOVWF   PORTD  ; Veriyi PORTD'ye yaz
BCF     EN  ; Enable = 0
RETURN

; Gecikme Rutini
DELAY
MOVLW 0XFF
MOVWF S1  ; Gecikme sayacý 1
L1
    MOVLW 0XFF
    MOVWF S2  ; Gecikme sayacý 2
L2
    DECFSZ S2  ; S2'yi azalt
    GOTO   L2
    DECFSZ S1  ; S1'i azalt
    GOTO   L1
RETURN

END  ; Program sonu
