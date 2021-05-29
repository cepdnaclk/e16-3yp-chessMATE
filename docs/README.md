# chessMATE 
## Smart Chess Platform

### [Back to our Repository](https://github.com/cepdnaclk/e16-3yp-chessMATE)

### Group Members:
  - Isurika Adikari   : E/16/012 : e16012@eng.pdn.ac.lk
  - Damsy De Silva    : E/16/069 : e16069@eng.pdn.ac.lk
  - Chaminie De Silva : E/16/070 : e16070@eng.pdn.ac.lk
  
## Table of Contents

  - [Problem](#problem)
  - [Solution](#solution)
  - [About Product](#about-product)
    - [Vision of the Product](#vision-of-the-product)
    - [Product Overview](#product-overview)
    - [High-Level Architecture](#high-level-architecture)
  - [3D Model of our Product](#3d-model-of-our-product)
  - [User Interfaces for Mobile Application](#user-interfaces-for-mobile-application)
  - [Cloud Architecture](#cloud-architecture)
  - [Mobile App Demonstrations](#mobile-app-demonstrations)
  - [PCB Designs](#pcb-designs)
  - [Test Summary](#test-summary)
  - [Test Results](#test-results)
    - [Mobile App Testing](#mobile-app-testing)
    - [Server & Database Testing](#server-and-database-testing)
  - [Embedded System Testing](#embedded-system-testing)
  - [System Test](#system-testing)
  - [Demonstration](#demonstration)
  - [Budget of the Product](#budget-of-the-product)
  - [Advising Lecturers](#advising-lecturers)
  - [Links](#links)

## Problem
  Chess is one of the most popular and oldest board games played by millions of people worldwide. But still there are some difficulties chess players face which limits them to enjoy this game to its fullest. 
  
  When chess players have trouble finding competent opponents in their locality, they try online chess on a mobile or desktop application. We found out that most of the professional as well as casual chess players are more likely to play chess game on a physical chess board rather than on a mobile or desktop screen. 

![problem picture](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/problem.png)
  
   Many chess players have stated that they have trouble in focusing and attacking aggressively during games played through mobile or desktop applications. And also, they have confessed that when playing using the physical chess board, they get to touch the pieces as they make a move, and this really draws them into the game.  
   
## Solution
 
 Our solution is an IOT platform which will provide the grand usual chess board experience to whom that need online chess. 
 
 ![solution picture](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/solution.png)
 
## About Product

### Vision of the Product:

   The vision of the chessMATE is to add a cool online chess game experience on everyday lives of people. Our endeavour is to give people more human experience with the new next generation technology. 

 
### Product Overview:

   Our product consists of two main sections; an electrically powered chess board (Smart chess board) and a mobile app. 

   In order to start a game, first you need to connect the board with the mobile app. Next you have to connect to an opponent who is registered on our platform via the mobile app. Then you can start the game.  

   When you make a move on your chess board, that move is sent to the chess board and mobile app of the opponent and the path of the move is displayed along with the start and end squares on the chess board owned by the opponent using the LEDs on the board. Then the opponent is required to manually place the specific chess piece moved by you on the correct end square in order to continue the game. 

   The main game mode we offer to our clients is the Board Vs Board game mode. Further the Board Vs App and App Vs App game modes can be experienced by the chessMATE clients. 

 
### High-Level Architecture

Given below diagram shows the high-level architecture of our solution. 

![solution_architecture](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/Solution_Architecture.png)

## 3D Model of our Product

- Given below is the 3D overview of our chess board.

![3D model](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/chessboard_3D_model.png)

- Following shows the 3D overview of the inner section of our chessboard. There are 64 compartments where each compartment being used by a square.

![3D model_compartments](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/compartments_3D_model.png)

## User Interfaces for Mobile Application

These are our currently implemented user interface designs.

![UI_Design 1](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/UI_design_1.jpg)

![UI_Design 2](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/UI_design_2.jpg)

![UI_Design 3](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/UI_design_3.jpg) 

## Cloud Architecture
![cloud architecture image](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/cloud_architecture.png) 


## Mobile App Demonstrations

- Here we have demonstrated how the Sign-In and Login functionalities work for multiple clients.

![SignIn_Login_Demo](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/SignIn_Login_demo.gif) 

- The following demonstration shows how a new game is started between two players and how the movements are being sent and received by the players successfully.

![Game_Demo](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/app-vs-app-test.gif)

## PCB Designs

- PCB design for Main Unit

![PCB Main unit](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Hardware/PCB%20Designs/PCB_main_unit.png) 

- PCB design for a compartment unit. 

![PCB Compartment unit](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Hardware/PCB%20Designs/PCB_compartment_unit.png) 

## Test Summary

![Test_Summary](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/testSummary.png)

## Test Results

### Mobile App Testing
  
  ![Mobile_App_Test_Results](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/login_test.png)
  
### Server and Database Testing

**Client Connection Establishments**

![Client connection establishment testing](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/test_client_connections.jpg)

**Get all available online users**

![Get all online users testing](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/test_request_players_list.jpg)

**Check multiple games between multiple pairs of players**

* Client 1 initiates a new game with Client 2

![New game client1 client2 testing](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/test_new_game_client1_client2.jpg)

* Client 3 initiates a new game with Client 4 

![New game client3 client4 testing](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/test_new_game_client3_client4.jpg)

* Moves are sent and received by the respective clients in the parallely conducted games without resulting any conflicts.

*Client 1 and Client 2*

![Moves client1 client2 testing](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/test_send_receive_moves_client1_client2.jpg)

*Client 3 and Client 4*

![Moves client3 client4 testing](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/test_send_receive_moves_client3_client4.jpg)



**Check database access and queries**

When a new player sign-in into the platform a new record will be created in the database

![Database access and queries sign in testing](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/test_sign_in.jpg)

When a player log into the platform his login information will be checked in the database

![Database access and queries login testing](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/test_login.jpg)

## Embedded System Testing

- **LED Panel Test**

  - *What is the test?*
    - Whether the opponent's move is correctly shown on the led panel
    
  - *Why is it important?*
    - Ensures the correctness in indication of opponent's move
    - Establishment of connection (Bluetooth) between Mobile app and ESP32 
    
  - *How was the test done?*
  
    ![LED panel test](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/LED_Panel_Test.gif)
    
- **Algorithm Test**
  
  - *Test 01*
    ![Algorithm_Test_1](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/Algorithm-Testing1.gif)
    
  - *Test 02*
    ![Algorithm_Test_2](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/Algorithm-Testing2.gif)
    
## **System Testing** 
![Embedded_System_Test](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/EmbeddedSystem_Testing.gif)
   

##  Demonstration

  - App vs App Game Demonstration
     
    ![AppVsApp](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/App-vs-App.gif)
    
  - Game Streaming Demostraion
 
    ![GameStream](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/Game-View.gif)   
  
  - System Demonstration
  
    - *Part 01*
    ![GameStream](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/System-Demonstration-part1.gif)
    
    - *Part 02* 
    ![GameStream](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Files/System-Demonstration-part2.gif)
  
 
   

## Budget of the Product

![Budget of the Product](https://raw.githubusercontent.com/cepdnaclk/e16-3yp-chessMATE/main/Images/budget.png)

### Advising Lecturers
 - Dr. Isuru Nawinne
 - Dr. Ziyan Maraikar
 
### Links

- [Department of Computer Engineering](http://www.ce.pdn.ac.lk/)
- [Faculty of Engineering](http://eng.pdn.ac.lk/)
- [University of Peradeniya](https://www.pdn.ac.lk/)
