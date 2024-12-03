class PowerUp {
  PVector position;
  PVector velocity;
  float size = 20;
  String type;
  PImage powerUpImage;

  PowerUp() {
    position = new PVector(random(width), -size); // Start at the top
    velocity = new PVector(0, 1.5); // Slow movement
    type = (random(1) > 0.5) ? "forcefield" : "bomb"; // Randomly choose type

    // Load power-up images based on type (assume "forcefield.png" and "bomb.png" exist)
    if (type == "forcefield") {
      powerUpImage = loadImage("forcefield.png");
    } else if (type == "bomb") {
      powerUpImage = loadImage("bomb.png");
    }
  }

  void update(float multiplier) {
    position.add(PVector.mult(velocity, multiplier));
  }

  void display() {
    image(powerUpImage, position.x, position.y, size, size);
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
