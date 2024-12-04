class Obstacle {
  PVector position;
  PVector velocity;
  float size = 20;
  PImage obstacleImage;

  Obstacle() {
    position = new PVector(random(width), -size); // Start above the screen
    velocity = new PVector(0, random(2, 5));

    // Randomly select a cat image
    int choice = int(random(3));
    if (choice == 0) obstacleImage = cat1;
    else if (choice == 1) obstacleImage = cat2;
    else obstacleImage = cat3;
  }

  void update(float multiplier) {
    position.add(PVector.mult(velocity, multiplier));
  }

  void display() {
    image(obstacleImage, position.x, position.y, size, size);
  }

  boolean isOffScreen() {
    return position.y > height;
  }

  boolean collidesWith(Player p) {
    return position.x < p.position.x + p.size &&
      position.x + size > p.position.x &&
      position.y < p.position.y + p.size &&
      position.y + size > p.position.y;
  }
}
