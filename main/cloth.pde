class Cloth extends Obstacle
{
  float xStart;
  float yStart;
  float zStart;
  Vertex vertices[][] = new Vertex[15][15];
  float ks = 20;
  float kd = 0.8;
  int spread = 20;
 
  Cloth()
  {
    this(0, 0, 0);
  }
  
  Cloth(float xIn, float yIn, float zIn)
  {
    xStart = xIn;
    yStart = yIn;
    zStart = zIn;
    
    for (int x = 0; x < 15; x ++)
    {
      for (int y = 0; y < 15; y ++)
      {
        Vertex v = new Vertex(new PVector(xStart + spread * (x + 1), yStart + spread * (y + 1), zStart), new PVector(0, 0, 0), createShape(POINT, xStart + spread * (x + 1), yStart + spread * (y + 1), zStart));
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
 
  
  
  void update(float dT)
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
          if (len > spread * 7 / 3)
          {
            v2.connectedTop = false; 
          }
          diff.div(len);
          
          vect1 = diff.dot(v1.vel);
          vect2 = diff.dot(v2.vel);
          force = ks * (spread - len) + kd * (vect1 - vect2);
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
        if (len > spread * 7 / 3)
        {
          v2.connectedRight = false; 
        }
        diff.div(len);
        
        vect1 = diff.dot(v1.vel);
        vect2 = diff.dot(v2.vel);
        force = ks * (spread - len) + kd * (vect1 - vect2);
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
          
          //print("pos1: " + v1.pos + " pos2: " + v2.pos + " pos3: " + v3.pos + "\n");
          
          PVector nTerm1 = new PVector(v2.pos.x - v1.pos.x, v2.pos.y - v1.pos.y, v2.pos.z - v1.pos.z);
          PVector nTerm2 = new PVector(v3.pos.x - v1.pos.x, v3.pos.y - v1.pos.y, v3.pos.z - v1.pos.z);
          
          //print("nTerm1: " + nTerm1 + " nTerm2: " + nTerm2 + "\n");
    
          PVector nStar = new PVector(0, 0, 0);
          PVector.cross(nTerm1, nTerm2, nStar);
          
          //print("nStar: " + nStar + "\n");
          
          PVector fTotal = nStar.mult((10 * PVector.dot(vAvg, vAvg) * PVector.dot(vAvg, nStar) / (PVector.dot(nStar, nStar))));
          
          //print("fTotal: " + fTotal + "\n");
          
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
          
          //print("nTerm1: " + nTerm1 + " nTerm2: " + nTerm2 + "\n");
    
          PVector nStar = new PVector(0, 0, 0);
          PVector.cross(nTerm1, nTerm2, nStar);
          
          //print("nStar: " + nStar + "\n");
          
          PVector fTotal = nStar.mult((PVector.dot(vAvg, vAvg) * PVector.dot(vAvg, nStar) / (20000000 * PVector.dot(nStar, nStar))));
          
          //print("fTotal: " + fTotal + "\n");
          
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
    
    // Arrow Collisions
    int iCollide, jCollide;
    for (Arrow a : Arrows)
    {
      if (a.moving)
      {
        if (a.pos.x > xStart && a.pos.x < xStart + spread * 15 && a.pos.y > yStart && a.pos.y < yStart + spread * 15)
        {
          if ((a.pos.z < zStart && a.pos.z + a.vel.z + a.acc.z > zStart) || (a.pos.z > zStart && a.pos.z + a.vel.z + a.acc.z < zStart))
          {
            if (a.pos.y > yStart && a.pos.y < yStart + spread * 14)
            {
              Sounds.add(new Sound(0.15, "cloth")); 
              iCollide = (int)((a.pos.x - xStart) / spread);
              jCollide = (int)((a.pos.y - yStart) / spread);
              vertices[iCollide][jCollide].connectedTop = false;
              vertices[iCollide][jCollide].connectedRight = false;
              vertices[iCollide][jCollide].velTemp.add(new PVector(0.5 * arrowSpeed, 0, 0));
              if (iCollide > 0)
              {
                vertices[iCollide - 1][jCollide].velTemp.add(new PVector(-0.5 * arrowSpeed, 0, 0));  
              }
            }
          }
        }        
      }
    }
    
    // Update positions
    for (int x = 0; x < 15; x ++)
    {
      vertices[x][0].velTemp = new PVector(0, 0, 0); 
      for (int y = 1; y < 15; y ++)
      {
        Vertex v = vertices[x][y];
        v.velTemp.add(new PVector(0, 10, 0));
        
        v.pos.add(new PVector(v.velTemp.x * dT, v.velTemp.y * dT, v.velTemp.z * dT));
        v.point.translate(v.velTemp.x * dT, v.velTemp.y * dT, v.velTemp.z * dT);
        boundsCheck(v);
        v.vel = v.velTemp;
        
      }
    }
    
    if (mousePressed)
    {
      if (mouseX > spread & mouseX < spread * 16 & mouseY > spread * 2 & mouseY < spread * 15)
      {
        vertices[mouseX / spread - 1][mouseY / spread - 1].connectedTop = false;
      }
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