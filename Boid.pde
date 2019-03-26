//BASIS OF FLOCKING CODE DERIVED FROM DANIEL SHIFFMAN'S NATURE OF CODE BOOK 

class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;   
  float maxspeed;    
  float xOff; 
  float yOff=1; 
  boolean predate; 
  float angle = TWO_PI;
  float colorr; 
  float alignValue; 
  float red;
  float green;
  float blue; 
  float opacity = 60; 

  Boid(float x, float y, boolean kill, float color_, float r1, float _alignValue) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = new PVector(x, y);
    r = r1;
    maxspeed = 2;
    maxforce = 0.05;
    predate = kill;
    colorr = color_;
    alignValue = _alignValue;
  }

  void run(ArrayList<Boid> boids, float counterTime, boolean finalDeath) {
    flock(boids, counterTime, finalDeath);
    update();
    borders();
    angle+=.007;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void flock(ArrayList<Boid> boids, float counterTime, boolean finalDeath) {
    PVector sep = separate(boids);   
    PVector sepPred = separatePredator(boids); 
    PVector ali = align(boids);      
    PVector coh = cohesion(boids, counterTime, finalDeath);  

    //CHANGING FLOCKING PATTERN BASED ON MODES 
    if (mode1 == true) {
      sep.mult(2);
      ali.mult(sin(angle)*2.5);
      coh.mult(sin(cos(angle))*2);
    } else if (mode2 == true) {
      sep.mult(2);
      ali.mult(2);
      coh.mult(sin(cos(angle))+2);
    } else if (mode3 == true) {
      sep.mult(2);
      ali.mult(2);
      coh.mult(sin(cos(angle))+2);
    } else if (mode4 == true) {
      sep.mult(2);
      ali.mult(2);
      coh.mult(sin(cos(angle))+2);
    }
    applyForce(sep);
    applyForce(sepPred);
    applyForce(ali);
    applyForce(coh);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  // STEER
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position); 
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  
    return steer;
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  PVector separatePredator (ArrayList<Boid> boids) {
    float desiredseparation = 100;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;

    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        if (predate == false && other.predate == true) {
          PVector diff = PVector.sub(position, other.position);
          diff.normalize();
          diff.div(d);       
          steer.add(diff);
          count++;          
          maxspeed = 5;
        }
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
    }
    return steer;
  }

  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  //COHESION + RENDER (COMBINED FOR CODE OPTIMIZATION) 
  PVector cohesion (ArrayList<Boid> boids, float counterTime, boolean finalDeath) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   
    int count = 0;

    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);

      //CHANGING APPEARANCE OF BOIDS ACCORDING TO MODE 
      if (mode1) {     
        maxspeed = 3; 
        //COLORS 
        red = map(counterTime, 0, 400, 70, 200); 
        green = map(counterTime, 0, 400, 40, 100); 
        blue = map(counterTime, 0, 400, 200, 255);
        //PULSATIONS
        float tempOpacity = 50 + 30 * sin( frameCount * 0.05f );
        opacity = map(tempOpacity, 20, 70, 20, 100);
      } else if (mode2) {
        maxspeed = 4; 
        red = map(counterTime, 0, 400, 140, 255); 
        green = map(counterTime, 0, 400, 180, 200); 
        blue = map(counterTime, 0, 400, 55, 120);
        float tempOpacity = 50 + 30 * sin(frameCount * 0.09f );
        opacity = map(tempOpacity, 20, 80, 20, 100);
      } else if (mode3) {    
        maxspeed = 6; 
        red = map(counterTime, 0, 800, 0, 100); 
        green = map(counterTime, 0, 800, 150, 200); 
        blue = map(counterTime, 0, 800, 0, 50);
        float tempOpacity = 40 + 40 * sin( frameCount * 0.25f );
        opacity = map(tempOpacity, 0, 80, 30, 100);
      } else if (mode4) {
        maxspeed = 7;
        red = 255; 
        green = 255; 
        blue = 255; 
        float tempOpacity = 40 + 40 * sin( frameCount * 0.29f );
        opacity = map(tempOpacity, 0, 80, 20, 100);
      } else if (mode5) {
        maxspeed = 6;
        red = 0; 
        green = 0; 
        blue = 0; 
        opacity = 0;
      }

      //CREATING LINES BETWEEN BOIDS 
      if (finalDeath == false) {
        if (d < neighbordist) {
          stroke(green, red, blue, opacity);
          line(position.x, position.y, other.position.x, other.position.y);
        }
      } else if (finalDeath == true) {
        //MAKING BOIDS FRANTICALLY CHANGE COLOR AT THE END
        if (mode4) {
          if (frameCount %2 == 0) {
            if (d < neighbordist) {
              stroke(255, 255, 255);
              line(position.x, position.y, other.position.x, other.position.y);
            }
          } else {
            if (d < neighbordist) {
              stroke(0, 0, 0); 
              line(position.x, position.y, other.position.x, other.position.y);
            }
          }
        }
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);
    } else {
      return new PVector(0, 0);
    }
  }
}