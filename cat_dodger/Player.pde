class Player {
  PVector position;
  float size = 30; // Adjusted size for the player image
  float speed = 3;
  PImage playerImage;

  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean upPressed = false;
  boolean downPressed = false;
  boolean sprinting = false;

  Player(float x, float y, PImage img) {
    position = new PVector(x, y);
    playerImage = img;
  }

  void update() {
    //Sprinting
    if (sprinting) {
      speed=5;
    }
    // Horizontal movement
    if (leftPressed) {
      position.x -= speed;
    }
    if (rightPressed) {
      position.x += speed;
    }

    // Vertical movement
    if (upPressed) {
      position.y -= speed;
    }
    if (downPressed) {
      position.y += speed;
    }
    speed=3;

    // Constrain to canvas boundaries
    position.x = constrain(position.x, 0, width - size);
    position.y = constrain(position.y, 0, height - size);
  }

  void display() {
    image(playerImage, position.x, position.y, size, size);
  }

  // Handle key press
  void keyPressed(int keyCode) {
    if (keyCode == LEFT) leftPressed = true;
    if (keyCode == RIGHT) rightPressed = true;
    if (keyCode == UP) upPressed = true;
    if (keyCode == DOWN) downPressed = true;
    if (keyCode == SHIFT) sprinting = true;
  }

  // Handle key release
  void keyReleased(int keyCode) {
    if (keyCode == LEFT) leftPressed = false;
    if (keyCode == RIGHT) rightPressed = false;
    if (keyCode == UP) upPressed = false;
    if (keyCode == DOWN) downPressed = false;
    if (keyCode == SHIFT) sprinting = false;
  }
}
