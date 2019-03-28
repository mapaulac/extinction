//MINIM LIBRARY
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Minim minim; 
AudioPlayer soundOne;
AudioPlayer soundTwo;
AudioPlayer soundThree;
AudioPlayer boom; 
AudioPlayer boom2; 
AudioPlayer endSound; 
AudioPlayer soundFour; 

PFont font; 

Flock flock;
Predator predator;

PVector mouse;
float boidCount; 
float modeCount;

//MODE STATES 
boolean mode1 = true; //menu-pristine state
boolean mode2 = false; //flocking state
boolean mode3 = false; //fleeing state
boolean mode4 = false; //killing state
boolean mode5 = false; //final text scene 

//GLOBAL TIME COUNTER (RESTARTS IN EVERY MODE) 
float counterTime;

//BOOLEANS TO FACILITATE RESTARTING OF COUNTER 
boolean restartCounter1 = true; 
boolean restartCounter2 = true;
boolean restartCounter3 = true;
boolean restartCounter4 = true;

//VARIABLES THAT DEFINE THE END OF A MODE 
float mode2Cap = 130; 
float mode3Cap = 300; 
float mode4Cap = 20; 
float mode5Cap = 750; 

//DEATH SEQUENCE 
boolean finalDeath = false; 

//VARIABLES TO TRIGGER FLASHY DEATH OF BOIDS
float initBoidCount; 
float subtractValue = 130; 
float subtractValue2 = 133;

//COUNTER FOR CHANGING TEXT IN FINAL TEXT SCENE 
float mousePressCount = 0; 

void setup() {

  //LOADING SOUND 
  minim = new Minim(this); 
  soundOne = minim.loadFile("vibraphone2.wav");
  soundTwo = minim.loadFile("soundtwo.mp3");
  soundThree = minim.loadFile("soundtwo.mp3"); 
  soundFour = minim.loadFile("lastsound.mp3"); 
  boom = minim.loadFile("boom.wav"); 
  boom2 = minim.loadFile("boom2.wav"); 
  endSound = minim.loadFile("endsound.mp3"); 

  modeCount = 1; 
  counterTime = 0; 
  mousePressCount = 0; 

  font = createFont("Gotham-Medium.TTF", 50);
  textFont(font); 

  fullScreen(); 
  //size(1440, 980);

  flock = new Flock();
  mouse = new PVector(mouseX, mouseY);
  predator = new Predator(mouse.x, mouse.y);

  for (int i = 0; i < 250; i++) {
    Boid b = new Boid(random(width), random(height), false, 0, 3, 1.5);
    flock.addBoid(b);
    boidCount ++;
  }

  finalDeath = false;
}

void draw() {
  
  //CHANGING CURSOR COLOR
  noCursor(); 
  strokeWeight(2); 
  if (modeCount < 3) {
    stroke(73, 248, 172);
    //stroke(255,0,0);
  } else if ((modeCount >= 3) && (modeCount < 5)) {
    stroke(255, 0, 0);
  } else if (modeCount > 6) {
    stroke(0);
  }
  ellipse(mouseX, mouseY, width/72, width/72);

  //CHANGING MODE COUNT 
  if (mode2) {
    initBoidCount = boidCount; 
    if (counterTime > mode2Cap) {
      modeCount = 3;
    }
  } else if (mode3) {
    if (counterTime > 50) {
      modeCount = 4;
    }
  } else if (mode5) {
    if (mousePressCount == 6) {
      setup();
    }
  }
  if (boidCount < initBoidCount - subtractValue) {
    finalDeath = true;
  }
  if (boidCount < initBoidCount - subtractValue2) {
    modeCount = 5;
  }

  //CHANGING THE MODES ACCORDING TO MODE COUNT 
  if (modeCount == 1) {
    mode1 = true; 
    mode2 = false; 
    mode3 = false; 
    mode4 = false;
    mode5 = false;
  } else if (modeCount == 2) {
    if (restartCounter1) {
      counterTime = 0;
      restartCounter1 = false;
    }
    mode1 = false; 
    mode2 = true; 
    mode3 = false; 
    mode4 = false;
    mode5 = false;
  } else if (modeCount == 3) {
    if (restartCounter2) {
      counterTime = 0; 
      restartCounter2 = false;
    }
    restartCounter1 = true; 
    mode1 = false; 
    mode2 = false; 
    mode3 = true; 
    mode4 = false;
    mode5 = false;
  } else if (modeCount == 4) { 
    if (restartCounter3) {
      counterTime = 0;
      restartCounter3 = false;
    }
    restartCounter2 = true; 
    mode1 = false; 
    mode2 = false; 
    mode3 = false; 
    mode4 = true;
    mode5 = false;
  }
  //RESTART 
  else if (modeCount == 5) {
    if (restartCounter4) {
      counterTime = 0;
      restartCounter4 = false;
    }
    restartCounter3 = true;
    mode1 = false; 
    mode2 = false; 
    mode3 = false; 
    mode4 = false;
    mode5 = true;
  } else if (modeCount == 6) {
    setup();
  }

  //ADDING TEXT + SOUND 
  if (mode1) {
    if (soundOne.isPlaying()) {
    } else {
      soundOne.loop();
    }
    if (counterTime > 50) {
      fill(255); 
      textSize(width/36);
      textAlign(CENTER); 
      text("LOOK AT THESE CREATURES, \n AREN'T THEY PRETTY?",width/2,height/2-(width/24));
  }
    if (counterTime > 117) {
      textSize(width/48); 
      textAlign(CENTER,CENTER); 
      text("Touch to play with them", width/2, height/2+(height/35));
    }
  } else if (mode2) {
    if (counterTime < mode2Cap) {
      if (soundTwo.isPlaying() ) {
      } else {
        soundTwo.loop();
      }
    }
    if (30 < mode2Cap) {
      textSize(width/55); 
      fill(255);
      textAlign(CENTER); 
      //text("Hmm, they seem to like you. \n But why don't they get closer?" , width/2, height/9.8);
      text("HMM, THEY SEEM TO LIKE YOU. \n BUT WHY WON'T THEY GET CLOSER?", width/2, height/9.8);
    }
  } else if (mode3) {
    if (soundThree.isPlaying() ) {
    } else {
      soundThree.loop();
    }
    if (counterTime < 30) {
      textAlign(CENTER); 
      textSize(width/55); 
      fill(255);
      text("THEY'RE SCARED OF YOU!", width/2, height/9.8);
    }
  } else if (mode4) {
    boom2.play(); 
    if (soundFour.isPlaying() ) {
    } else {
      soundFour.loop();
    }
    if (counterTime < 100) {
      textAlign(CENTER); 
      noStroke(); 
      fill(0);
      rect(width/9.6, height/16.3, width/1.23, height/16.3); 
      textSize(width/55); 
      fill(255);
      text("WHAT'S HAPPENING TO THEM? IS YOUR TOUCH WHAT'S MAKING THEM DECAY?", width/2, height/9.8);
      //text("What's happening to them? Is your touch what's making them decay?", width/2, height/2+420);
    }

    if ((150 < counterTime) && (counterTime < 300 )) {
      noStroke(); 
      fill(0);
      rect(width/9.6, height/16.3, width/1.23, height/16.3);   
      textSize(width/55); 
      fill(255);
      text("IS THERE ANYTHING YOU CAN DO? THEY KEEP DISAPPEARING", width/2, height/9.8);
    }
    if ((350 < counterTime)) {
      noStroke(); 
      fill(0);
      rect(width/9.6, height/16.3, width/1.23, height/16.3);
      textSize(width/55); 
      fill(255);
      text("THERE'S NO WAY BACK... YOU MIGHT HAVE TO KILL THEM ALL...", width/2, height/9.8);
      //text("I guess there is only one way out.. kill them all...", width/2, height/2+420);
    }
  } else if (mode5) { 
    boom.play(); 
    if (soundOne.isPlaying()) {
      soundOne.pause();
    }
    if (soundTwo.isPlaying()) {
      soundTwo.pause();
    }
    if (soundThree.isPlaying()) {
      soundThree.pause();
    }
    if (soundFour.isPlaying()) {
      soundFour.pause();
    }
    textSize(width/57.6); 
    fill(255);

    //TEXT: QUOTE FROM ELIZABETH KOLBERT'S "THE SIXTH EXTINCTION"
    textAlign(CENTER); 
    if (mousePressCount == 0) {
      text("Having freed ourselves from the constraints of evolution, humans nevertheless remain dependent \n on the earth’s biological and geochemical systems.", width/2, height/2-50);      
      fill(255,70); 
      text("touch to continue", width/2, height/2+(height/9.8)); 
    } else if (mousePressCount == 1) {
      fill(255);
      text("By disrupting these systems: cutting down tropical rainforests, \n altering the composition of the atmosphere, and acidifying the oceans, \n we’re putting our own survival in danger.", width/2, height/2-70);
    } else if (mousePressCount == 2) {
      text("Extinction rates soar, and the texture of life changes.", width/2, height/2-25);
    }
    else if (mousePressCount == 3) {
      text("It doesn’t much matter whether people care or don’t care. ", width/2, height/2-25);
    }
    else if (mousePressCount == 4) {
      text("What matters is that people change the world.", width/2, height/2-25);
      fill(255, 60); 
      text("Elizabeth Kolbert - 'The Sixth Extinction' ", width/2 + (width/7.2), height/2+(height/19.6));
    }
    else if (mousePressCount == 5) {
      fill(255,70);  
      text("María Paula Calderón \n New York University Abu Dhabi", width/2, height/2-25);
    }
  }

  //BACKGROUND WITH TRANSPARENCY 
  fill(0, 40); 
  noStroke(); 
  rect(0, 0, width, height);

  //UPDATING PREDATOR POSITION TO MOUSE POSITION 
  predator.position.x = mouseX;
  predator.position.y = mouseY; 
  PVector predatorMovement2 = new PVector(mouseX, mouseY);
  predator.applyForce(predatorMovement2);
  predator.predate(flock.boids);
  flock.run(counterTime, finalDeath);
  
  counterTime++; 
  }

void mousePressed() {
  //ENSURING THAT CLICKING WORKS FIRST ON TITLE SCREEN 
  if (mode1) { 
    if (counterTime > 120) {
      modeCount =2;
    }
  }
  //SWITCHING TEXT IN FINAL SEQUENCE 
  if (mode5) {
    mousePressCount++;
  }
  endSound.pause();
}