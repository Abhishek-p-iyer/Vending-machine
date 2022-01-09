# vending-machine
A Candy dispenser or a chocolate vending machine using 8051 ALP code with a proteus simulation. 

Using the proteus simulation - 
As soon as you start the simulation, a welcome message is displayed "WELCOME TO CHOCOLATE VENDING MACHINE". 
As soon as the welcome message is displayed, the 8051 will ask the user to enter his/her ID, the ID that needs to be entered in the virtual terminal is "1234567890". 
If the ID entered is incorrect, a RED LED would glow and the 8051 will ask you to enter the ID again. 
If the ID entered is correct, the GREEN LED would glow and "ID CORRECT" would be displayed and the 8051 would proceed to display the main menu .i.e the different kinds of candies present along with its cost. 
Then using the virtual terminal choose the serial number of the chocolate you want to buy. 
The 8051 then asks the user to enter the note (must be in three digits eg- 010, 040, 090, 100, 200, etc). 
If the amount is sufficient, then the buzzer rings and the motor switches on. (simulating a conveyer belt).  
After which the 8051 displays "COLLECT YOUR CHOCOLATE" and "COLLECT YOUR CHANGE: ___ " (with the balance amount) 


