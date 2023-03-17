import processing.serial.*;
import java.util.Random;
Serial myPort;

int x_coord;
int y_coord;

//GAME
int playersScore = 0;
int computersScore = 0;
int PlayerPossibleMoves = 5;
int ComputerPossibleMoves = 5;
int playerBoats = 6;
int computerBoats = 6;

Boolean finishedGame = false;
Boolean playerWon = false;

//initializare mapa
Boolean introducedCoordonates = false;
int boatsInitialized = 0;
String boat1 = ""; String boat2 = ""; String boat3 = ""; String boat4 = ""; String boat5 = ""; String boat6 = "";



String alwaysDisplay = "";
String computerCoordinates = "";
Boolean displayErrorMessage = false;
Boolean displayError2 = false;
Boolean displayError3 = false;

int[][] playersGrid = { {0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0} };
                        
int[][] computersGrid = { {2, 2, 2, 2, 2},
                          {2, 0, 0, 0, 0},
                          {0, 0, 0, 0, 0},
                          {0, 0, 0, 0, 0},
                          {0, 0, 0, 0, 0} };
  

void setup() {   //setam conexiunea cu placa
  size(1000,800);

  String portName = Serial.list()[0]; 
  myPort = new Serial(this, portName, 9600);
}

void initializareInterfata(){
  fill(255,255,255);
  textSize(50);
  text("Welcome to battleships!", 180, 140);
  text("Enter your coordinates in range [0,4]", 150, 220);
  textSize(30);
  text("Boat1:", 200, 300);
  text(boat1, 300, 300);
  text("Boat2:", 200, 350);
  text(boat2, 300, 350);
  text("Boat3:", 200, 400);
  text(boat3, 300, 400);
  text("Boat4:", 200, 450);
  text(boat4, 300, 450);
  text("Boat5:", 200, 500);
  text(boat5, 300, 500);
  text("Boat6:", 200, 550);
  text(boat6, 300, 550);
  
}

void readBoatCoordonates() {
  String msg = myPort.readString();
  if(msg!=null) {
    if (msg.charAt(0) == 'X') {
      println("ERROR NU S-AU INTRODUS TOATE DATELE"); 
      displayErrorMessage = true;
    } 
    else {
      if(msg.charAt(0)== 'C') {
        displayError2=true;
      }
      else {
        if(msg.charAt(0)=='B'){
          displayError3= true;
        }
        else {
            displayError3=false;
            displayError2=false;
            displayErrorMessage = false;
            print(msg);
            String[] coordinates = msg.split(",");
            x_coord = Integer.parseInt(coordinates[0]);
            y_coord = Character.getNumericValue(coordinates[1].charAt(0));
            println("The x is " + x_coord + " and the y is " + y_coord);
            playersGrid[x_coord][y_coord]=2;
            if(boatsInitialized==0) {
              boat1=msg;
            }
            else {
              if(boatsInitialized==1) {
                boat2=msg;
              }
              else {
                if(boatsInitialized==2) {
                  boat3=msg;
                }
                else {
                  if(boatsInitialized==3) {
                    boat4=msg;
                  }
                  else{
                    if(boatsInitialized==4){
                      boat5=msg;
                    }
                    else{
                      if(boatsInitialized==5){
                        boat6=msg;
                      }
                    }
                  }
                }
              }
            }
            
           
            boatsInitialized++;
            print(boatsInitialized);
            if(boatsInitialized==6) {
             introducedCoordonates = true;
            }
      }
        }
        
      
      }
    }
  }


//player's turn
void readFromArduino() {
  String msg = myPort.readString();
  
  
  //pentru player
  if(msg!=null) {
    if (msg.charAt(0) == 'X') {
      println("ERROR NU S-AU INTRODUS TOATE DATELE"); 
      displayErrorMessage = true;
      //displayErrorMsg();
    } 
    else {
      if(msg.charAt(0) == 'R') {
        x_coord=-1;
        y_coord=-1;
        alwaysDisplay = x_coord + "," + y_coord;
      }
      else {
        if(msg.charAt(0) == 'E') {
          if(playersScore >= computersScore) {
            playerWon = true;
          }
          finishedGame = true;
        }
        else {
          if(msg.charAt(0)== 'C') {
            displayError2=true;
          }
          else {
            if(msg.charAt(0)=='B'){
              //ai introdus un numar prea mare
              displayError3=true;
            }
            else{
              displayErrorMessage = false;
              displayError3=false;
              displayError2=false;
              print(msg);
              String[] coordinates = msg.split(",");
              x_coord = Integer.parseInt(coordinates[0]);
              y_coord = Character.getNumericValue(coordinates[1].charAt(0));
              println("The x is " + x_coord + " and the y is " + y_coord);
              PlayerScoreEvaluation(x_coord, y_coord);
              computersGrid[x_coord][y_coord]++;
              print(computersGrid[0][0]);
              
              alwaysDisplay = msg;
              //playersTurn = false;
              computersTurn();
            }
          }  
        }   
      }
    }
  }
}

void PlayerScoreEvaluation(int x, int y) {
  if(computersGrid[x][y]==0){
    playersScore-=2;
    PlayerPossibleMoves--;
    if(PlayerPossibleMoves==0) {
      finishedGame=true;
      playerWon=false;
     }
  }
  if(computersGrid[x][y] == 2) {  //e barca acolo
     playersScore+=5;
     computerBoats--;
     if(computerBoats==0) {
       finishedGame=true;
       playerWon=true;
     }
  }
}

void ComputerScoreEvaluation(int x, int y) {
  if(playersGrid[x][y]==0){
    computersScore-=2;
    ComputerPossibleMoves--;
    if(ComputerPossibleMoves==0) {
          finishedGame=true;
          playerWon=true;
       }
  }
  else {
    if (playersGrid[x][y]==3) {
      computersScore-=2;
      ComputerPossibleMoves--;
      if(ComputerPossibleMoves==0) {
            finishedGame=true;
            playerWon=true;
      }
    }
    else {
      if (playersGrid[x][y] == 2) {
        computersScore+=5;
        playerBoats--;
        if(playerBoats==0) {
          finishedGame=true;
          playerWon=false;
        }
      }
    }
  }
  
}

void computersTurn() {
  
  Random rand = new Random(); 
  int randomX = (int) ((Math.random() * (4 - 0)) + 0);
  int randomY = (int) ((Math.random() * (4 - 0)) + 0);
  ComputerScoreEvaluation(randomX,randomY);
  if(playersGrid[randomX][randomY]!=1){   
    playersGrid[randomX][randomY]++;
  }
  computerCoordinates = randomX + "," + randomY;
  
  readFromArduino();
  //playersTurn =true;
}

void displayCoord(String msg) {
   
  if (msg!=null) {
    String toDisplay = msg;
    fill(255, 255, 255);
    textSize(50);
    text(toDisplay, 880, 740);
    
  }
  text(computerCoordinates, 350, 740);
}

void displayError() {
  fill(255,0,0);
  textSize(20);
  text("NU S-AU INTRODUS TOATE COORDONATELE", 200,150);
}

void displayError2() {
  fill(255,0,0);
  textSize(20);
  text("AI INTRODUS CARACTER IN LOC DE NUMAR", 200,700);
}

void displayError3() {
  fill(255,0,0);
  textSize(20);
  text("AI INTRODUS UN NUMAR PREA MARE", 200,660);
}

void displayScores() {
  fill(255,255,100);
  textSize(30);
  text("Player's score: ",100, 180);
  text(playersScore, 310, 180);
  text("Computer's score: " , 600, 180);
  text(computersScore, 850, 180);
  
  fill(153,0,0);
  text("Possible wrong moves:", 100, 210);
  text(PlayerPossibleMoves, 400, 210);
  text("Possible wrong moves:", 600, 210);
  text(ComputerPossibleMoves, 900, 210);
  
}


void displayMessage() {
  fill(255,255,255);
  textSize(87);
  text("Welcome to battleships!", 100,100);
  fill(255,255,255);
  textSize(50);
  text("Coordinates: ", 80, 740);
  text("Coordinates: ", 600, 740);
}

void drawPlayersGrid() {
  fill(255,255,255);
  textSize(50);
  text("Player:", 140,280);
      
  for ( int r = 0; r<=4; r++) {
    for (int c = 0; c<=4; c++) {
      
      if (playersGrid[c][r] == 0 ) {
        fill(255,255,255);
      }
      else if (playersGrid[c][r] == 1) {   //computerul nu a nimerit o barca, e bine pentru noi
        fill(0,0,255);
         
      }
      else if (playersGrid[c][r] == 2) {
        fill(0);
      }
      else if(playersGrid[c][r] == 3) {
        fill(255,0,0); 
      }
      else if(playersGrid[c][r] == 4) {
        fill(128,0,0);
        
      }
      rect(100+r*60, 300+c*60, 60,60);
          
    }
  }
  
}

void drawComputersGrid() {
  fill(255,255,255);
  textSize(50);
  text("Computer:", 640,280);
  
  for ( int r = 0; r<=4; r++) {
    for (int c = 0; c<=4; c++) {
      
      if (computersGrid[c][r] == 0 ) {
        fill(255,255,255);
      }
      else if (computersGrid[c][r] == 1) {
        fill(0,0,255);
      }
      else if (computersGrid[c][r] == 2) {
        fill(255,255,255);
      }
      else if (computersGrid[c][r] == 3) {
        fill(255,0,0);  //e barca acolo, e o miscare buna
      }
      else if (computersGrid[c][r] == 4) {
        fill(128,0,0);  //am nimerit deja barca, nu are sens sa mai dam aici, mimscare proasta
      }
      //fill(255,255,255);
      rect(600+r*60, 300+c*60, 60,60);
      
    }
  }
}


void draw() {
  //PImage img;
  //img = loadImage("battleships.jpg");
  //background(img);
  
  background(102, 153,204);
  
  if(introducedCoordonates==true) {
      
    if(finishedGame == false) {
      
      displayMessage();
      drawPlayersGrid();
      drawComputersGrid();
      readFromArduino();
      displayCoord(alwaysDisplay);
      if(displayErrorMessage == true) {
        displayError();
      }
      if(displayError2 == true){
        displayError2();
      }
      if(displayError3==true){
        displayError3();
      }
      displayScores();
    }
    else {
      if(playerWon == true) {
        fill(255,255,255);
        textSize(70);
        text("Congratulations!", 200,300);
        text("You are the winner! :)", 200,380);
        textSize(50);
        text("Your score : ", 200, 550);
        text(playersScore, 460, 550);
        text("Computer's score:", 200, 600);
        text(computersScore, 590, 600);
      }
      else {
        fill(255,255,255);
        textSize(70);
        text("You lost! :(", 200,300);
        textSize(50);
        text("Your score : ", 200, 550);
        text(playersScore, 460, 550);
        text("Computer's score:", 200, 600);
        text(computersScore, 590, 600);
      }
    }
  }
  else {
    
    readBoatCoordonates();
    initializareInterfata();
    
    if(displayErrorMessage == true) {
        displayError();
      }
      if(displayError2 == true){
        displayError2();
      }
      if(displayError3==true){
        displayError3();
      }
    
  }
    
}
