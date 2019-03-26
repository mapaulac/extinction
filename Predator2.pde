//PREDATOR = USER
class Predator {
  float predatorStrength = width/3.6;
  float desiredseparation = width/14.4;
  float mode2separation = width/7.2;
  float mode2separation2 = width/9.6;
  float mode3separation = width/2.88;
  float mode3separation2 = width/36;
  float mode4separation = width/2.4;
  float mode4separation2 = width/36;
  float x1; 
  float y1;
  PVector position; 
  PVector velocity; 
  PVector acceleration; 

  Predator(float x, float y) {
    velocity = new PVector(0, 0);
    position = new PVector(x, y);
    acceleration = new PVector(0, 0);
  }

  void run() {
    update();
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(1);
    position.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void render() {
    fill(255, 0, 0);
    noStroke();
    ellipse(position.x, position.y, 50, 50);
    fill(255, 255, 0);
  }

  void predate(ArrayList<Boid> boids) {
    run();

    for (int i = boids.size() - 1; i >= 0; i --) {
      float d = PVector.dist(position, boids.get(i).position);

      //MODE 2: ATTRACTING TO USER 
      if (mode2) {
        if (d > mode2separation) {
          PVector diff = PVector.sub(position, boids.get(i).position);
          diff.normalize();
          diff.div(d);        
          diff.mult(predatorStrength);
          diff.sub(velocity);
          boids.get(i).applyForce(diff);
        }
        if (d < mode2separation2) {
          PVector diff = PVector.sub(boids.get(i).position, position);
          diff.normalize();
          diff.div(d);        
          diff.mult(predatorStrength);
          diff.sub(velocity);
          boids.get(i).applyForce(diff);
        }
      }

      //MODE 3: ESCAPING FROM USER 
      else if (mode3) {
        if (d < mode3separation) {
          PVector diff = PVector.sub(boids.get(i).position, position);
          diff.normalize();
          diff.div(d);        
          diff.mult(predatorStrength);
          diff.sub(velocity);
          boids.get(i).applyForce(diff);
        }
      }
      
      //MODE 4: DYING AT HANDS OF USER 
      else if (mode4) {
        if (d < mode4separation) {
          PVector diff = PVector.sub(boids.get(i).position, position);
          diff.normalize();
          diff.div(d);        
          diff.mult(predatorStrength);
          diff.sub(velocity);
          boids.get(i).applyForce(diff);
        }
        if (d < mode4separation2) {
          boids.remove(boids.get(i));
          boidCount--;
        }
      }
    }
  }
}