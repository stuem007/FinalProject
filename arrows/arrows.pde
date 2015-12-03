ArrayList<Arrow> Arrows = new ArrayList<Arrow>();
PShape arrow;
float lastTime;
float currentTime;
float dT;
float camX;
float camY;
float camZ;
float ctrX;
float ctrY;
float ctrZ;
float timeCount = 0;
float vAir = 0;
PVector wind = new PVector(0, -0.1, 0);
PShape floor;
PVector gravity = new PVector(0, 10, 0);

Vertex vertices[][] = new Vertex[15][15];
float ks = 20;
float kd = 0.8;

void setup()
{  
  size(500, 500, P3D);
  
  createStartingObjects();
  
  camX = width / 2.0;
  camY = height / 2.0;
  camZ = (height / 2.0) / tan(PI * 30.0 / 180.0);
  
  ctrX = width / 2.0;
  ctrY = height / 2.0;
  ctrZ = 0;
  
  lastTime = millis();
  
}



void draw()
{
  camera(camX, camY, camZ, ctrX, ctrY, ctrZ, 0, 1, 0);
  
  background(38, 170, 250); 
  //background(255, 255, 255);
  
  //createRuntimeObjects();
  
  currentTime = millis();
  dT = (currentTime - lastTime) / 1000;
  surface.setTitle((1 / dT) + " FPS");
  lastTime = currentTime;
  updateObjects(dT);
  
  if (mousePressed)
  {
    if (mouseX > 30 & mouseX < 480 & mouseY > 60 & mouseY < 450)
    {
      vertices[mouseX / 30 - 1][mouseY / 30 - 1].connectedTop = false;
    }
  }
  
  shape(floor);
  
  for (Arrow a : Arrows)
  {
    a.update(dT); 
  }
  
  for (int x = 0; x < 15; x ++)
  {
    for (int y = 0; y < 15; y ++)
    {
      Vertex v = vertices[x][y];
      shape(v.point); 
      for (PVector p : v.neighbors)
      {
        if ((vertices[(int)p.x][(int)p.y].connectedTop | (int)p.y <= y) & (vertices[(int)p.x][(int)p.y].connectedRight | (int)p.x <= x))
        {
          PVector vec = vertices[(int)p.x][(int)p.y].pos;
          line(v.pos.x, v.pos.y, v.pos.z, vec.x, vec.y, vec.z);
        }
      }
    }
  }

}


public void createStartingObjects()
{
  
  floor = createShape(BOX, 500, 0, 500);
  floor.translate(250, height, -250);
  floor.setFill(color(85, 47, 39));
  floor.setStroke(192);
  
  Arrows.add(new Arrow());
  
  
  
  
  for (int x = 0; x < 15; x ++)
  {
    for (int y = 0; y < 15; y ++)
    {
      Vertex v = new Vertex(new PVector(30 * (x + 1), 30 * (y + 1), 0), new PVector(0, 0, 0), createShape(POINT, 30 * (x + 1), 30 * (y + 1), 0));
      if (y == 0)
      {
        v.moves = false;
      }
      if (x < 14)
      {
        v.neighbors.add(new PVector(x + 1, y)); 
      }
      if (y < 14)
      {
        v.neighbors.add(new PVector(x, y + 1));
        if (x < 14)
        {
          v.neighbors.add(new PVector(x + 1, y + 1)); 
        }
        if (x > 0)
        {
          v.neighbors.add(new PVector(x - 1, y + 1));
        }
      }
      vertices[x][y] = v;
    }
  }
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
  float vect1, vect2, force;
  PVector diff;
  // Vertical spring forces
  for (int x = 0; x < 15; x ++)
  {
    for (int y = 0; y < 14; y ++)
    {
      Vertex v1 = vertices[x][y];
      Vertex v2 = vertices[x][y + 1];
      
      if (v2.connectedTop)
      {
      
        diff = new PVector(v2.pos.x - v1.pos.x, v2.pos.y - v1.pos.y, v2.pos.z - v1.pos.z);
        float len = sqrt(diff.dot(diff));
        if (len > 70)
        {
          v2.connectedTop = false; 
        }
        diff.div(len);
        
        vect1 = diff.dot(v1.vel);
        vect2 = diff.dot(v2.vel);
        force = ks * (30 - len) + kd * (vect1 - vect2);
        diff.mult(force);
        
        v1.velTemp.sub(diff);
        v2.velTemp.add(diff);
        
      }
          
    }
  }
  // Horizontal spring forces
  for (int x = 0; x < 14; x ++)
  {
    for (int y = 0; y < 15; y ++)
    {
      Vertex v1 = vertices[x][y];
      Vertex v2 = vertices[x + 1][y];
      
      diff = new PVector(v2.pos.x - v1.pos.x, v2.pos.y - v1.pos.y, v2.pos.z - v1.pos.z);
      float len = sqrt(diff.dot(diff));
      if (len > 70)
      {
        v2.connectedRight = false; 
      }
      diff.div(len);
      
      vect1 = diff.dot(v1.vel);
      vect2 = diff.dot(v2.vel);
      force = ks * (30 - len) + kd * (vect1 - vect2);
      diff.mult(force);
      
      v1.velTemp.sub(diff);
      v2.velTemp.add(diff);
         
    }
  }
  // Air Drag force
  for (int x = 0; x < 14; x += 2)
  {
    for (int y = 0; y < 14; y += 2)
    {
      Vertex v1 = vertices[x][y];
      Vertex v2 = vertices[x][y + 1];
      Vertex v3 = vertices[x + 1][y];
      
      if (v2.connectedTop & v2.pos.y < 500)
      {     
        PVector vAvg = new PVector(0, 0, 0);
        vAvg.add(v1.vel);
        vAvg.add(v2.vel);
        vAvg.add(v3.vel);
        vAvg.div(3);
        
        print("pos1: " + v1.pos + " pos2: " + v2.pos + " pos3: " + v3.pos + "\n");
        
        PVector nTerm1 = new PVector(v2.pos.x - v1.pos.x, v2.pos.y - v1.pos.y, v2.pos.z - v1.pos.z);
        PVector nTerm2 = new PVector(v3.pos.x - v1.pos.x, v3.pos.y - v1.pos.y, v3.pos.z - v1.pos.z);
        
        print("nTerm1: " + nTerm1 + " nTerm2: " + nTerm2 + "\n");
  
        PVector nStar = new PVector(0, 0, 0);
        PVector.cross(nTerm1, nTerm2, nStar);
        
        print("nStar: " + nStar + "\n");
        
        PVector fTotal = nStar.mult((10 * PVector.dot(vAvg, vAvg) * PVector.dot(vAvg, nStar) / (PVector.dot(nStar, nStar))));
        
        print("fTotal: " + fTotal + "\n");
        
        if (!Float.isNaN(fTotal.x) & !Float.isNaN(fTotal.y) & !Float.isNaN(fTotal.z))
        {
          PVector fEach = fTotal.div(3);
          v1.velTemp.add(fEach);
          v2.velTemp.add(fEach);
          v3.velTemp.add(fEach); 
        }
      }
    }  
  }
  
  for (int x = 1; x < 15; x += 2)
  {
    for (int y = 1; y < 15; y += 2)
    {
      Vertex v1 = vertices[x][y];
      Vertex v2 = vertices[x][y - 1];
      Vertex v3 = vertices[x - 1][y];
      
      if (v1.connectedTop & v1.pos.y < 500 & v2.pos.y < 500)
      {
        PVector vAvg = new PVector(0, 0, 0);
        vAvg.add(v1.vel);
        vAvg.add(v2.vel);
        vAvg.add(v3.vel);
        vAvg.div(3);
        
        PVector nTerm1 = new PVector(v2.pos.x - v1.pos.x, v2.pos.y - v1.pos.y, v2.pos.z - v1.pos.z);
        PVector nTerm2 = new PVector(v3.pos.x - v1.pos.x, v3.pos.y - v1.pos.y, v3.pos.z - v1.pos.z);
        
        print("nTerm1: " + nTerm1 + " nTerm2: " + nTerm2 + "\n");
  
        PVector nStar = new PVector(0, 0, 0);
        PVector.cross(nTerm1, nTerm2, nStar);
        
        print("nStar: " + nStar + "\n");
        
        PVector fTotal = nStar.mult((PVector.dot(vAvg, vAvg) * PVector.dot(vAvg, nStar) / (20000000 * PVector.dot(nStar, nStar))));
        
        print("fTotal: " + fTotal + "\n");
        
        if (!Float.isNaN(fTotal.x) & !Float.isNaN(fTotal.y) & !Float.isNaN(fTotal.z))
        {
          PVector fEach = fTotal.div(3);
          v1.velTemp.add(fEach);
          v2.velTemp.add(fEach);
          v3.velTemp.add(fEach); 
        }
      }
    }  
  }
  

  
  for (int x = 0; x < 15; x ++)
  {
    vertices[x][0].velTemp = new PVector(0, 0, 0); 
    for (int y = 1; y < 15; y ++)
    {
      Vertex v = vertices[x][y];
      v.velTemp.add(new PVector(0, 10, 0));
      
      v.pos.add(new PVector(v.velTemp.x * deltaT, v.velTemp.y * deltaT, v.velTemp.z * deltaT));
      v.point.translate(v.velTemp.x * deltaT, v.velTemp.y * deltaT, v.velTemp.z * deltaT);
      boundsCheck(v);
      v.vel = v.velTemp;
      
    }
  }
}

class Arrow
{
  PVector orient;
  PVector pos;
  PVector vel;
  PVector acc;
  PShape rect;
  boolean nocked;
 
  Arrow()
  {
    this(new PVector(0, PI / 2), new PVector(300, 300, 0));
  }
  
  Arrow(PVector orientIn, PVector posIn)
  {
    orient = orientIn;
    pos = posIn;
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
    nocked = true;
 
    rect = createShape(BOX, 10, 10, 100);
    rect.translate(pos.x, pos.y, pos.z);
    rect.setFill(color(125, 125, 125));
    rect.setStroke(192);
  }
  
  void update(float dT)
  {
    if (!nocked)
    {
      vel.add(PVector.mult(gravity, dT));
      vel.add(PVector.mult(acc, dT));
      pos.add(PVector.mult(vel, dT));
      rect.translate(vel.x * dT, vel.y * dT, vel.z * dT);
      
      pushMatrix();
      translate(pos.x, pos.y, pos.z);
      
      popMatrix();
      
    }
    shape(rect); 
  }
  
  
}



void keyPressed()
{
  if (key == 'i')
  {
    ctrZ -= 50;
    camZ -= 50;
  }
  else if (key == 'j')
  {
    ctrX -= 50;
    camX -= 50;
  }
  else if (key == 'k')
  {
    ctrZ += 50;
    camZ += 50;
  }
  else if (key == 'l')
  {
    ctrX += 50;
    camX += 50;
  }
  else if (key == 'w')
  {
    ctrY -= 50;
  }
  else if (key == 'a')
  {
    ctrX -= 50;
  }
  else if (key == 's')
  {
    ctrY += 50;
  }
  else if (key == 'd')
  {
    ctrX += 50;
  }
  else if (key == 'r')
  {
    Arrow last = Arrows.get(Arrows.size() - 1);
    if (!last.nocked)
    {
      Arrows.add(new Arrow());     
    }
  }
  else if (key == 'f')
  {
    Arrow last = Arrows.get(Arrows.size() - 1);
    if (last.nocked)
    {
      last.vel = new PVector(160 * cos(last.orient.y), 0, -160 * sin(last.orient.y));
      last.nocked = false;      
    }
  }
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

public class Vertex
{
  PVector pos;
  PVector vel;
  PVector velTemp;
  PShape point;
  ArrayList<PVector> neighbors = new ArrayList<PVector>();
  boolean moves = true;
  boolean maxLen = false;
  boolean connectedTop = true;
  boolean connectedRight = true;
  
  public Vertex(PVector posIn, PVector velIn, PShape pointIn)
  {
    pos = posIn;
    vel = velIn;
    velTemp = vel;
    point = pointIn;
  }
}