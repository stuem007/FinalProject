import ddf.minim.*;
import ddf.minim.ugens.*;

ArrayList<Arrow> Arrows = new ArrayList<Arrow>();
ArrayList<Obstacle> Obstacles = new ArrayList<Obstacle>();
ArrayList<PShape> Room = new ArrayList<PShape>();
ArrayList<Sound> Sounds = new ArrayList<Sound>();
ArrayList<Sound> expiredSounds = new ArrayList<Sound>();
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

Minim minim;
AudioOutput aOut;
ArrayList<Oscil> waves;

void setup()
{  
  size(500, 500, P3D);
  
  createStartingObjects();
  
  camera = new Camera(width / 2.0, height / 2.0, 450, width / 2.0, height / 2.0, 0, 0, 1, 0);
  
  
  minim = new Minim(this);
  aOut = minim.getLineOut();
  
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
  
  for (Arrow a : Arrows)
  {
    a.update(dT); 
  }
  
  for (Obstacle o : Obstacles)
  {
    o.update(dT);  
  }
  
  for (Sound s : Sounds)
  {
    s.time -= dT;
    if (s.time <= 0)
    {
      s.end();
      expiredSounds.add(s);
    }
  }
  Sounds.removeAll(expiredSounds); 

}


public void createStartingObjects()
{
  PImage im = loadImage("floor2.jpg");  
  Obstacles.add(new Wall(new PVector(xWidth, 0, zDepth), new PVector(xWidth / 2, yHeight, zDepth / 2), im));
  Obstacles.add(new Wall(new PVector(xWidth, 0, zDepth), new PVector(xWidth / 2, 0, zDepth / 2), im));
  im = loadImage("wall2.jpg");
  Obstacles.add(new Wall(new PVector(xWidth, yHeight, 0), new PVector(xWidth / 2, yHeight - height / 2, 0), im));
  Obstacles.add(new Wall(new PVector(xWidth, yHeight, 0), new PVector(xWidth / 2, yHeight - height / 2, zDepth), im));
  Obstacles.add(new Wall(new PVector(0, yHeight, zDepth), new PVector(0, yHeight - height / 2, zDepth / 2), im));
  Obstacles.add(new Wall(new PVector(0, yHeight, zDepth), new PVector(xWidth, yHeight - height / 2, zDepth / 2), im));
  
  Arrows.add(new Arrow());
  
  //Obstacles.add(new Cloth(20, 0, 0));
  
  Obstacles.add(new Cloth(50, 50, 50));
  
  Obstacles.add(new Water(new PVector(1200, yHeight, 100), 400));
  
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
    if (v.pos.y >= yHeight)
    {
      v.point.translate(0, yHeight - 1 - v.pos.y, 0);
      v.velTemp.x = 0;
      v.velTemp.y = 0;
      v.velTemp.z = 0;
      v.pos.y += yHeight - 1 - v.pos.y;
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