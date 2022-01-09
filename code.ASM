ORG 000H
	LJMP MAIN

ORG 50H
MAIN:
	MOV P2,#00H  ;Clears the port 2 values 
	SETB P2.3  ; Connected to the lamp, switches the lamp on 
	MOV 3AH,#00   ; Used to store the flag of the ID 
	MOV 3BH,#00    ;Stores different prices of the candy 
	MOV 3CH,#00    ;Used to store the number corresponding to the candy 
	MOV 40H,#00    ;Used to store the balance


;-----Initilizing the LCD and displaying the welcome messages 

	ACALL INLCD   ;Subroutine to initialize the LCD 
	MOV A,#80H    ;Forces the LCD to start at the first row 
	ACALL CMD     ;Command subroutine of the LCD 
	MOV DPTR,#WEL_MSG1  ;WEL_MSG1 - "WELCOME TO" 
	ACALL WSTR    ;Subroutine to print the string onto the LCD 
	MOV A,#0C0H   ;Forces the LCD to go to row 2 line 1 of the LCD Display 
	ACALL CMD     ;Command subroutine of the LCD
	MOV DPTR,#WEL_MSG2  ;WEL_MSG2 - "CHOCOLATE"
	ACALL WSTR ;Subroutine to print the string onto the LCD  
	ACALL DELAY2; Delay subroutine 
	

	ACALL LCD_CLEAR ;Subroutine to clear the LCD screen 
	MOV A,#80H ;Forces cursor to begin on the first line and first row 
	ACALL CMD ;Command subroutine of the LCD
	MOV DPTR,#WEL_MSG3 ;WEL_MSG3 - " VENDING MACHINE" 
	ACALL WSTR ;Subroutine to print the string onto the LCD  
	ACALL DELAY2 ;Delay subroutine 



BACKREAD:

	ACALL LCD_CLEAR ;Clears the LCD 
	MOV A,#80H ;Forces LCD to row 1 line 1 
	ACALL CMD ;Command subroutine of the LCD 
	MOV DPTR,#READID ;READID - "ENTER YOUR ID:" 
	ACALL WSTR ;Subroutine to print the string onto the LCD  

	ACALL READ_ID   ;TO READ THE ID FROM VIRTUAL TERMINAL
	ACALL PRINT_ID  ;  PRINT ID OF 10 DIGITS
	ACALL COMPARE_ID     ;IF EQUAL 3A=1  ELSE 0



;------To Display if the ID is correct or not 

	MOV A,3AH ;Moving the value of 3A to A
	CJNE A,#1,NOTEQUAL ;Compares if the value is 1, if not, jumps to NOTEQUAL 
EQUAL:  ACALL LCD_CLEAR ;Clears the LCD 
	MOV A,#80H ;Forces the cursor to the first line and first row 
	ACALL CMD ;Command subroutine for the LCD 
	MOV DPTR,#IDMATCHED1 ;IDMATCHED1 - "  ID CORRECT"
	ACALL WSTR ;Subroutine to print the string onto the LCD  
	MOV A,#0C0H ;Force cursor to beginning of second line
	ACALL CMD ;Command subroutine for the LCD 
	MOV DPTR,#IDMATCHED2 ;IDMATCHED2 - "WELCOME" 
	ACALL WSTR   ;Subroutine to print the string onto the LCD
	SETB P2.1   ;GREEN LED ON
	CLR P2.0    ;OFF RED LED
	ACALL DELAY2 ;Delay subroutine 
	SJMP MAIN_MENU ;Short jump to the Menu 
NOTEQUAL:
	ACALL LCD_CLEAR ;Clears the LCD 
	MOV A,#80H ;Forces the cursor to the first line and first row 
	ACALL CMD  ;Command subroutine for the LCD 
	MOV DPTR,#IDNOTM ;IDNOTM - "INCORRECT ID" 
	ACALL WSTR ;Subroutine to print the string onto the LCD
	SETB P2.0    ;RED LED ON
	ACALL DELAY2	 ;DELAY SUBROUTINE
	LJMP BACKREAD ;Starts over again 
 
; --------------------MAIN MENU
MAIN_MENU:
	ACALL LCD_CLEAR ;Clears LCD 
	MOV A,#80H ;Forces the cursor to the first line and first row 
	ACALL CMD ;Command subroutine for the LCD 
	MOV DPTR,#MENU ;Displays MENU 
	ACALL WSTR ;Subroutine to print the string onto the LCD
	MOV A,#0C0H ;Force cursor to beginning of second line
	ACALL CMD ;Command subroutine for the LCD 
	MOV DPTR,#CH1 ;"1.5- STAR :10"
	ACALL WSTR ;Subroutine to print the string onto the LCD
	ACALL DELAY2  ;DELAY SUBROUTINE

	ACALL LCD_CLEAR ;Clears LCD
	MOV A,#80H ;Forces the cursor to the first line and first row 
	ACALL CMD ;Command subroutine for the LCD 
	MOV DPTR,#CH2 ;"2.MILKEY BAR: 20"
	ACALL WSTR ;Subroutine to print the string onto the LCD
	MOV A,#0C0H ;Force cursor to beginning of second line
	ACALL CMD ;Command subroutine for the LCD
	MOV DPTR,#CH3 ;"3.DIARY MILK: 25"
	ACALL WSTR ;Subroutine to print the string onto the LCD
	ACALL DELAY2 ;DELAY SUBROUTINE

	ACALL LCD_CLEAR ;Clears LCD
	MOV A,#80H ;Forces the cursor to the first line and first row
	ACALL CMD ;Command subroutine for the LCD 
	MOV DPTR,#CH4 ;"4.M & M :20"
	ACALL WSTR ;Subroutine to print the string onto the LCD
	MOV A,#0C0H ;Force cursor to beginning of second line
	ACALL CMD ;Command subroutine for the LCD
	MOV DPTR,#CHOOSE ;"CHOOSE YOURS: "
	ACALL WSTR	;Subroutine to print the string onto the LCD
	
;-------READING THE CHOCOLATE NUMBER AND STORING IT 
	ACALL READ     ;Read the Chocolate number and stores it in A
	CLR C ;Clear carry flag 
	SUBB A,#30H ;Converts the HEX to ASCII 
	MOV 3CH,A    ;3CH IS USED TO STORE THE CHOCOLATE NUM
	ADD A,#30H ;Convert it back to ASCII 
	ACALL WCHR ;Subroutine to write character in A to the  LCD
	ACALL DELAY2 ;Delay 

;----------STORING THE VALUE OF THE PRICE OF THE CHOCOLATE SELECTED 

	MOV A,3CH ;Moves the value of address of 3C into A
	CJNE A,#1,CHECK2 ;Checks if A contains the 1, if not jumps to CHECK2
	MOV 3BH,#10 ;Stores the value of 10 into 3B (Price of 5 star is 10) 
	SJMP MONEY_READ ;Short jump to MONEY_READ
CHECK2:
	CJNE A,#2,CHECK3 ;Checks if A contains the 2, if not jumps to CHECK3
	MOV 3BH,#20 ;Stores the value of 20 into 3B (Price of Milkey bar is 20)
	SJMP MONEY_READ ;Short jump to MONEY_READ
CHECK3:
	CJNE A,#3,CHECK4 ;Checks if A contains the 3, if not jumps to CHECK4
	MOV 3BH,#25  ;Stores the value of 25 into 3B (Price of Dairy Milk is 25)
	SJMP MONEY_READ ;Short jump to MONEY_READ
CHECK4:
	CJNE A,#4,CHECK5 ;Checks if A contains the 3, if not jumps to CHECK5
	MOV 3BH,#20 ;Stores the value of 20 into 3B (Price of M&M is 20)
	SJMP MONEY_READ ;Short jump to MONEY_READ
CHECK5:
	SETB P2.2   ;YELLOW LED ON
	CLR P2.1    ;GREEN LED OFF
	LJMP MAIN_MENU ;Long jump to MAIN MENU
	

;---------READS THE AMOUNT GIVEN BY THE USER 

MONEY_READ:       ;READ MONEY IN MULTIPLES OF 10    
	ACALL LCD_CLEAR ;Clears the LCD 
	MOV A,#80H ;Forces the cursor to the first line and first row
	ACALL CMD ;Command subroutine for the LCD
	MOV DPTR,#MONEY1 ;ENTER THE NOTE 
	ACALL WSTR ;Subroutine to print the string onto the LCD
	ACALL READ  ;MSD OF MONEY (100s place) 
	SUBB A,#30H ;Converts the ASCII to HEX
	MOV 3DH,A ;Stores the 100s place in 3D
	ADD A,#30H   ;Converts it back 
	ACALL WCHR ;Subroutine to write character in A to the  LCD
	ACALL READ   ;10s PLACE DIGIT 
	SUBB A,#30H ;Converts the ASCII to HEX
	MOV 3EH,A ;Stores the 10s place in address of 3E
	ADD A,#30H ;;Converts it back 
	ACALL WCHR ;Subroutine to write character in A to the  LCD
	ACALL READ   ;1 S PLACE DIGIT
	SUBB A,#30H ;Converts the ASCII to HEX
	MOV 3FH,A ;Stores the 10s place in address of 3F
	ADD A,#30H ;Converts it back 
	ACALL WCHR ;Subroutine to write character in A to the  LCD
	SETB P2.6  ;Switches the buzzer on 
	ACALL DELAY2 ;Delay function 
	CLR P2.6 ;Switches the buzzer off 
	
	
;-------CALCULATE THE CHANGE 
	MOV A,3DH ;Moves the value 100s place value of the amount 
	MOV B,#100 ;Moves value of 100 to B 
	MUL AB ;Multiply both A and B 
	MOV 3DH,A ;Moves the value to the address location of 3D
	MOV A,3EH ;Moves the 10s place value of the amount 
	MOV B,#10 ;Moves value of 10 to B
	MUL AB   ;Multiply A and B 
	ADD A,3DH   ;100s PLACE +10s PLACE DISGITS
	ADD A,3FH    ;100s+10s+1s
	CLR C
	SUBB A,3BH   ;TOTAL - PRICE
	JC MONEY_READ  ; LESS AMOUNT ENTERED
	MOV 40H,A     ;CHANGE IS IN ADDRESS OF 40H

;-------TO DISPATCH THE CHOCOLATE
	
	ACALL LCD_CLEAR ;Clears LCD 
	MOV A,#80H ;Forces LCD to 1st row 1st Line 
	ACALL CMD ;Command subroutine is called 
	MOV DPTR,#CH_C1 ;"Collect your" 
	ACALL WSTR  ;Command for write subroutine
	MOV A,#0C0H ;Forces LCD to 2nd row and 1st line 
	ACALL CMD  ;Command subroutine is called
	MOV DPTR,#CH_C2 ;"CHOCOLATE" 
	ACALL WSTR ;;Subroutine to print the string onto the LCD
	SETB P2.4  ;MOTOR IN CLOCKWISE
	CLR P2.5 
	ACALL DELAY2 ;Delay subroutine 
	CLR P2.4   ;MOTOR IN ANTI CLOCKWISE
	SETB P2.5  
	ACALL DELAY2 ;Delay subroutine 
	CLR P2.5 ;Stopping the motor 
	MOV A,40H 
	CJNE A,#00,GIVE_CHANGE ;Checks if Change is 00 or not, if not jump to GIVE_CHANGE 
	SJMP THANKS ;Short Jump to THANKS, if Change is 00
	
GIVE_CHANGE:
	ACALL LCD_CLEAR  ;Clears the LCD 
	MOV A,#80H ;Forces the cursor to the first line and first row 
	ACALL CMD  ;Command subroutine for the LCD 
	MOV DPTR,#CH_C1 ;"COLLECT YOUR"
	ACALL WSTR ;Subroutine to print the string onto the LCD
	MOV A,#0C0H ;Force cursor to beginning of second line
	ACALL CMD ;Command subroutine for the LCD 
	MOV DPTR,#CH_C3 ;"CHANGE" 
	ACALL WSTR ;Subroutine to print the string onto the LCD
	MOV A,40H ;Moves the balance into A 
	MOV B,#100 ; 100S
	DIV AB ;
	ADD A,#30H 
	ACALL WCHR ;Subroutine to write character in A to the  LCD
	MOV A,B 
	MOV B,#10  
	DIV AB
	ADD A,#30H   ;10S
	ACALL WCHR
	MOV A,B
	ADD A,#30H   ;1S
	ACALL WCHR
	SETB P2.4  ;Clockwise movement of the motor 
	CLR P2.5
	ACALL DELAY2 ;Delay
	CLR P2.4 ;Anticlockwise movement of the motor 
	SETB P2.5 
	ACALL DELAY2 ;Delay 
	CLR P2.5 ;Stop the movement 
THANKS:	
	CLR P2.2 ;YELLOW LED OFF
	ACALL LCD_CLEAR ;Clears the LCD
	MOV A,#80H ;Forces the cursor to the first line and first row 
	ACALL CMD ;Command subroutine 
	MOV DPTR,#THANK
	ACALL WSTR ;Subroutine to print the string onto the LCD
	ACALL DELAY2 ;Delay function 
	LJMP BACKREAD	;Longjump to BACKREAD 

	


READ_ID:

	MOV R6,#10  ; NUMBER OF DIGITS IN ID= 10
	MOV R0,#30H ;Storing the value of 30 in R0
BACKR:	ACALL READ ;Starts the serial communication 
	CLR C ;Clears the carry flag 
	SUBB A,#30H    ;CONVERT ASCII TO DECIMAL  
	MOV @R0,A ;Stores the decimal value of the user's Id in the address of R0
	INC R0 ;Increments R0
	DJNZ R6,BACKR ;Loops until all the number of digits in ID have been converted  
	RET


READ:	MOV SCON,#50H   ;10 BIT SERIAL ENABLE WITH 1 SART AND 1 STOP BIT
	MOV TMOD,#20H   ;TIMER ONE IN MODE 2
	MOV TH1,#-3   ;9600 BAUDRATE  OR #0FDH
	
	SETB TR1   ;START TIMER
	

JJ: 	JNB RI,JJ 
	MOV A,SBUF   ;MOVE FROM SERIAL BUFFER TO ACC
	CLR RI       ;RESET THE RI FLAG
	RET
 		
PRINT_ID:	
	MOV A,#0C0H   ;2ND ROW 1 COL
	ACALL CMD  
	MOV R0,#30H   ;Starting address of the User's ID 
	MOV R6,#10    ;Count of the digits in the ID
BACKP:	MOV A,@R0 ;Moves individual values of the ID to A
	ADD A,#30H    ;DECIMAL TO ASCII
	ACALL WCHR    ;Subroutine to write character in A to the  LCD
	INC R0        ;Increments R0
	DJNZ R6,BACKP ;Loops until all the digits of the ID is printed 
	ACALL DELAY2  ;Calls the delay subroutine 
	RET	


COMPARE_ID:
	
	MOV DPTR,#ID ;SAVED ID - "1,2,3,4,5,6,7,8,9,0" 
	CLR C ;Clears the carry flag 
	CLR A	;Clears A value 
	MOVC A,@A+DPTR 
	CJNE A,30H,NOT_EQUAL ;Compares the 1st Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal 
	
	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,31H,NOT_EQUAL ;Compares the 2nd Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal
	
	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,32H,NOT_EQUAL ;Compares the 3rd Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal

	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,33H,NOT_EQUAL ;Compares the 4th Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal

	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,34H,NOT_EQUAL ;Compares the 5th Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal
	
	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,35H,NOT_EQUAL ;Compares the 6th Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal

	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,36H,NOT_EQUAL ;Compares the 7th Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal

	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,37H,NOT_EQUAL ;Compares the 8th Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal

	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,38H,NOT_EQUAL ;Compares the 9th Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal
	
	INC DPTR
	MOV A,#00	
	MOVC A,@A+DPTR
	CJNE A,39H,NOT_EQUAL ;Compares the 10th Digit of the User's ID and the ID stored in the memory of 8051, jumps if not equal
	
	MOV 3AH,#01  ;Moves in a value of 01 to 3A, if equal 
	
NOT_EQUAL:
	RET 

	

HERE: SJMP HERE




;-- LCD Initialization Procedure starts here -----
LCD_CLEAR:
	MOV A,#01H  ;Clears the LCD
	ACALL CMD
	MOV R2,#10 
HHH:
	ACALL LDELAY
	DJNZ R2,HHH
	RET
 
INLCD:
;------Clearing all the data pins of the LCD 
	CLR P1.3	;RS = 0
	CLR P1.7	
	CLR P1.6	
	SETB P1.5		
	CLR P1.4		 	
	SETB P1.2	;Latching info by sending an active low pluse 	 
	CLR P1.2    ;to the E pin of the LCD 	
	ACALL LDELAY ;Calling a Delay 
 
	SETB P1.2	;Latching info by sending an active low pluse 
	CLR P1.2	


	SETB P1.7	  	
	CLR P1.6	
	CLR P1.5		 
	CLR P1.4			
	SETB P1.2		;Latching info by sending an active low pluse  
	CLR P1.2	
	ACALL LDELAY    ;Delay being called 

	CLR P1.7		
	CLR P1.6		
	CLR P1.5		 
	CLR P1.4		 	

	SETB P1.2	;Latching info by sending an active low pluse 	 
	CLR P1.2		

	SETB P1.7		
	SETB P1.6	
	SETB P1.5	
	SETB P1.4		 

	SETB P1.2		;Latching info by sending an active low pluse  
	CLR P1.2		
	ACALL LDELAY

	CLR P1.7		
	CLR P1.6		
	CLR P1.5		 
	CLR P1.4		 	
	SETB P1.2		;Latching info by sending an active low pluse  
	CLR P1.2		

	SETB P1.6		

	SETB P1.5		
	SETB P1.2		;Latching info by sending an active low pluse 
	CLR P1.2		
	ACALL LDELAY
	RET
;--- End  of  LCD initialization  ----- 

;- Subroutine to write character in A to the  LCD----- 
WCHR: 
	PUSH ACC
	PUSH B
   	SETB P1.3
   	MOV B,A
   	ACALL COMMON
	ACALL LDELAY
   	MOV A,B
   	SWAP A
   	ACALL COMMON
	ACALL LDELAY
	POP B
	POP ACC
   	RET

;--Subroutine to write COMMAND in A to the  LCD---- 
CMD:
   	CLR P1.3 ;RS = 0
   	MOV B,A  ;Move contents of A to B 
   	ACALL COMMON ;
	ACALL LDELAY
   	MOV A,B
   	SWAP A
   	ACALL COMMON
   	ACALL LDELAY
   	RET

;---Common operation for CHAR write and COMMAND write  
COMMON: 
   	ANL A,#11110000B
   	ANL P1, #00001111B
   	ORL P1,A
   	SETB P1.2
   	CLR P1.2
   	RET

;--Subroutine to write A STRING character by character-
WSTR: 
        PUSH    ACC     
CONT1:   
       CLR     A               
       MOVC    A,@A+DPTR      ; move character to A 
       JZ EXIT1  
PRINT:
        ACALL    WCHR                ; call procedure to write a CHAR 
        INC DPTR                       ; get next character        
       AJMP    CONT1      ; go to CONT1  
EXIT1: POP     ACC                        ; restore A 
        RET 
  
; -------  procedure delay -------
LDELAY:	
	MOV R7, #50	
	HERE2: DJNZ R7, HERE2	
	RET


DELAY2:
    	MOV	R4,#50
X3:     MOV	R3,#200
X2:     MOV	R2,#250
X1:     DJNZ	R2,X1	
		DJNZ	R3,X2	
		DJNZ	R4,X3	
		RET

DELAY_SEG:
	MOV R7, #200
	HERE3:	DJNZ R7, HERE3
	RET

ORG 500H
ID: DB 1,2,3,4,5,6,7,8,9,0
WEL_MSG1: DB "   WELCOME TO "
		DB 0
WEL_MSG2: DB "   CHOCOLATE"
		DB 0
WEL_MSG3: DB " VENDING MACHINE" 
			DB 0

READID: DB "ENTER YOUR ID:",0
IDMATCHED1: DB "  ID CORRECT",0
IDMATCHED2: DB "   WELCOME",0
IDNOTM: DB " INCORRECT ID",0
MENU: DB "   MAIN MENU",0
CH1: DB "1.5- STAR :10",0
CH2: DB "2.MILKEY BAR: 20",0
CH3: DB "3.DIARY MILK: 25",0
CH4: DB "4.M & M :20",0
CHOOSE: DB "CHOOSE YOURS: ",0
MONEY1: DB "INSERT NOTE:",0
CH_C1: DB "COLLECT YOUR",0
CH_C2: DB "   CHOCOLATE ",0
CH_C3: DB "YOUR CHANGE: ",0
THANK: DB "   THANK YOU! ",0

END
