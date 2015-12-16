ArrayList<Arrow> Arrows = new ArrayList<Arrow>();
ArrayList<Obstacle> Obstacles = new ArrayList<Obstacle>();
ArrayList<PShape> Room = new ArrayList<PShape>();
PShape arrow;
float lastTime;
float currentTime;
float dT;
public static Camera camera;
float timeCount = 0;
float vAir = 0;
PVector wind = new PVector(0, -0.1, 0);
PShape wall;
PVector gravity = new PVector(0, 30, 0);
float xWidth = 1500;
float zDepth = 1500;
float yHeight = 500;



void setup()
{  
  size(500, 500, P3D);
  
  createStartingObjects();
  
  camera = new Camera(width / 2.0, height / 2.0, (height / 2.0) / tan(PI * 30.0 / 180.0), width / 2.0, height / 2.0, 0, 0, 1, 0);
  
  lastTime = millis();
  
}



void draw()
{
  lights();
  background(38, 170, 250); 
  //background(255, 255, 255);
  
  //createRuntimeObjects();
  
  currentTime = millis();
  dT = (currentTime - lastTime) / 1000;
  surface.setTitle((1 / dT) + " FPS");
  lastTime = currentTime;
  camera.update(dT);
  updateObjects(dT);
  
  
  for (PShape w : Room)
  {
    shape(w);
  }
  
  for (Arrow a : Arrows)
  {
    a.update(dT); 
  }
  
  for (Obstacle o : Obstacles)
  {
    o.update(dT);  
  }
  
  

}


public void createStartingObjects()
{
  
  wall = createShape(BOX, xWidth, 0, zDepth);
  wall.translate(xWidth / 2, height, zDepth / 2);
  wall.setFill(color(85, 47, 39));
  wall.setStroke(192);
  Room.add(wall);
  
  wall = createShape(BOX, xWidth, yHeight, 0);
  wall.translate(xWidth / 2, height - yHeight / 2, 0);
  wall.setFill(color(85, 47, 39));
  wall.setStroke(192);
  Room.add(wall);
  
  wall = createShape(BOX, xWidth, yHeight, 0);
  wall.translate(xWidth / 2, height - yHeight / 2, zDepth);
  wall.setFill(color(85, 47, 39));
  wall.setStroke(192);
  Room.add(wall);
  
  wall = createShape(BOX, 0, yHeight, zDepth);
  wall.translate(0, height - yHeight / 2, zDepth / 2);
  wall.setFill(color(85, 47, 39));
  wall.setStroke(192);
  Room.add(wall);
  
  wall = createShape(BOX, 0, yHeight, zDepth);
  wall.translate(xWidth, height - yHeight / 2, zDepth / 2);
  wall.setFill(color(85, 47, 39));
  wall.setStroke(192);
  Room.add(wall);
  
  Arrows.add(new Arrow());
  
  //Obstacles.add(new Cloth(20, 0, 0));
  
  Obstacles.add(new Cloth(50, 0, 0));
  
  Obstacles.add(new Water(new PVector(600, yHeight, 100), 400));
  
}


/*public void createRuntimeObjects()
{
  if (dT > 1 / 60)
  {
    timeCount = 0;
    PShape sphere = createShape(SPHERE, 5);
    float varyX = 250;
    float varyZ = 0;
    sphere.translate(varyX, 490, varyZ);
    sphere.setFill(color(0, 0, random(100, 255)));
    sphere.setStroke(255);
      
    particles.add(new Particle(new PVector(varyX, 490, varyZ), new PVector(random(-20, 20), -200, random(-20, 20)), new PVector(0, 50, 0), 5, sphere));
  }
  else
  {
    timeCount += dT; 
  }
}*/


public void updateObjects(float deltaT)
{

}


public void boundsCheck(Vertex v)
{
    if (v.pos.x <= 0)
    {
       v.point.translate(1 - v.pos.x, 0, 0);
       v.velTemp.x *= -0.7;
       v.pos.x += 1 - v.pos.x;
    }
    if (v.pos.x >= 500)
    {
      v.point.translate(499 - v.pos.x, 0, 0);
      v.velTemp.x *= -0.7;
      v.pos.x += 499 - v.pos.x;
    }
    
    if (v.pos.y <= 0)
    {
      v.point.translate(0, 1 - v.pos.y, 0);
      v.velTemp.y *= -0.7;
      v.pos.y += 1 - v.pos.y;
    }
    if (v.pos.y >= 500)
    {
      v.point.translate(0, 499 - v.pos.y, 0);
      v.velTemp.x = 0;
      v.velTemp.y = 0;
      v.velTemp.z = 0;
      v.pos.y += 499 - v.pos.y;
    }
    
    if (v.pos.z <= -250)
    {
      v.point.translate(0, 0, -249 - v.pos.z);
      v.velTemp.z *= -0.7;
      v.pos.z += -249 - v.pos.z;
    }
    if (v.pos.z >= 250)
    {
      v.point.translate(0, 0, 249 - v.pos.z);
      v.velTemp.z *= -0.7;
      v.pos.z += 249 - v.pos.z;
    }
}