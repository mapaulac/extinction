class Flock {
  ArrayList<Boid> boids; 

  Flock() {
    boids = new ArrayList<Boid>(); 
  }

  void run(float counterTime, boolean finalDeath) {
    for (Boid b : boids) {
      b.run(boids, counterTime, finalDeath);  
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}