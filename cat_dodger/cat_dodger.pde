ArrayList<Obstacle> obstacles;
ArrayList<PowerUp> powerUps;
Player player;
int score = 0;
int highScore = 0;
boolean isGameOver = false;
boolean showStartMenu = true; // Variable to manage the start menu state
float difficultyMultiplier = 1.0;
PImage playerImage, cat1, cat2, cat3, bombImage, forcefieldImage;
int bombSize;
int bombTimer = 0;
boolean forcefieldActive = false;
int forcefieldTimer = 0;

//setup
void setup() {
  size(400, 400);

  // Load images
  playerImage = loadImage("player.png");
  cat1 = loadImage("Cat1.png");
  cat2 = loadImage("Cat2.png");
  cat3 = loadImage("Cat3.png");
  bombImage = loadImage("bomb.png");
  forcefieldImage = loadImage("forcefield.png"); // Placeholder for forcefield effect

  loadHighScore();
  resetGame();
}

void draw() {
  background(200);

  if (showStartMenu) {
    displayStartMenu();
  } else if (!isGameOver) {
    // Game logic
    player.update();
    player.display();

    // Handle bomb effect
    if (bombTimer > 0) {
      bombTimer--;

      // Calculate the size of the bomb as it shrinks
      float bombSize = map(bombTimer, 0, 30, 0, width);

      // Display the bomb image at the calculated size, centered at the screen
      image(bombImage, (width - bombSize) / 2, (height - bombSize) / 2, bombSize, bombSize);
    }

    // Manage obstacles and power-ups
    for (int i = obstacles.size() - 1; i >= 0; i--) {
      Obstacle obs = obstacles.get(i);
      obs.update(difficultyMultiplier);
      obs.display();

      // Check for collision (if not in forcefield mode)
      if (!forcefieldActive && obs.collidesWith(player)) {
        isGameOver = true;
        updateHighScore();
      }

      // Remove off-screen obstacles
      if (obs.isOffScreen()) {
        obstacles.remove(i);
      }
    }

    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp pu = powerUps.get(i);
      pu.update(difficultyMultiplier);
      pu.display();

      // Check for collision with player
      if (pu.collidesWith(player)) {
        handlePowerUp(pu);
        powerUps.remove(i);
      }

      // Remove off-screen power-ups
      if (pu.isOffScreen()) {
        powerUps.remove(i);
      }
    }

    // Add new obstacles at an increasing rate
    if (frameCount % int(30 / difficultyMultiplier) == 0 && bombTimer == 0) {
      obstacles.add(new Obstacle());
    }

    // Add power-ups at an increasing rate
    if (frameCount % int(200 / difficultyMultiplier) == 0 && bombTimer == 0) {
      powerUps.add(new PowerUp());
    }

    // Increment score and adjust difficulty
    score++;
    difficultyMultiplier = 1 + score * 0.001;

    // Display score
    fill(0);
    textSize(12);
    text("Score: " + score, 30, 20);

    // Handle forcefield effect
    if (forcefieldActive) {
      forcefieldTimer--;
      if (forcefieldTimer <= 0) forcefieldActive = false;

      // Draw translucent blue overlay
      noStroke();
      fill(0, 0, 255, 100);
      rect(player.position.x, player.position.y, player.size, player.size);
    }
  } else {
    // Game over screen
    textAlign(CENTER);
    fill(0);
    text("Game Over!", width / 2, height / 2);
    text("Score: " + score, width / 2, height / 2 + 20);
    text("High Score: " + highScore, width / 2, height / 2 + 40);
    text("Press R to Restart", width / 2, height / 2 + 60);
  }
}

void keyPressed() {
  if (isGameOver && key == 'r') {
    resetGame();
  } else if (showStartMenu && (key == ' ' || key == ENTER)) {
    // Start the game when the space bar or Enter is pressed
    showStartMenu = false;
  } else {
    player.keyPressed(keyCode);
  }
}

void keyReleased() {
  player.keyReleased(keyCode);
}

void resetGame() {
  obstacles = new ArrayList<Obstacle>();
  powerUps = new ArrayList<PowerUp>();
  player = new Player(width / 2, height - 30, playerImage);
  score = 0;
  difficultyMultiplier = 1.0;
  isGameOver = false;
  bombTimer = 0;
  forcefieldActive = false;
  showStartMenu = true; // Reset the start menu for a new game
}

void loadHighScore() {
  String[] data = loadStrings("highscore.txt");
  if (data != null && data.length > 0) {
    highScore = int(data[0]);
  }
}

void saveHighScore() {
  saveStrings("highscore.txt", new String[] { str(highScore) });
}

void updateHighScore() {
  if (score > highScore) {
    highScore = score;
    saveHighScore();
  }
}

void handlePowerUp(PowerUp pu) {
  if (pu.type == "forcefield") {
    forcefieldActive = true;
    forcefieldTimer = 180; // 3 seconds
  } else if (pu.type == "bomb") {
    bombTimer = 30;
    obstacles.clear();
  }
}

void displayStartMenu() {
  textAlign(CENTER);
  fill(0);
  textSize(24);
  text("Welcome to Cat Dodger!", width / 2, height / 2 - 40);
  textSize(16);
  text("Use arrow keys to move the player.", width / 2, height / 2 - 10);
  text("Use the shift key to speed up.", width / 2, height / 2+10);
  text("Collect powerups to help you stay alive.", width / 2, height / 2+30);
  textSize(18);
  text("Press 'Space' or 'Enter' to start.", width / 2, height / 2 + 100);
}
