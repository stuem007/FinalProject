class Water extends Obstacle
{
  PShape shape;
  PVector pos;
  float wallL;
  float wallW = 2;
  float wallH = 50;
  float cellSize;
  int numCells = 20;
  // PVector x is velocity, y is height
  float heights[][] = new float[numCells][numCells];
  float vels[][] = new float[numCells][numCells];
  ArrayList<Particle> particles = new ArrayList<Particle>();
  ArrayList<Particle> expired = new ArrayList<Particle>();
 
  Water()
  {
    this(new PVector(0, yHeight - 20, 0), 20);
  }
  
  Water(PVector posIn, float wallLIn)
  {
    pos = posIn;
    wallL = wallLIn;
    shape = createShape();
    
    PImage im = loadImage("pool_floor.jpg");
     
    Wall wall = new Wall(new PVector(wallL, wallH, wallW), new PVector(pos.x, pos.y - wallH / 2, pos.z), im);
    Obstacles.add(wall);
    
    wall = new Wall(new PVector(wallL, wallH, wallW), new PVector(pos.x, pos.y - wallH / 2, pos.z + wallL), im);
    Obstacles.add(wall);
    
    wall = new Wall(new PVector(wallW, wallH, wallL), new PVector(pos.x - wallL / 2, pos.y - wallH / 2, pos.z + wallL / 2), im);
    Obstacles.add(wall);
    
    wall = new Wall(new PVector(wallW, wallH, wallL), new PVector(pos.x + wallL / 2, pos.y - wallH / 2, pos.z + wallL / 2), im);
    Obstacles.add(wall);
    
    wall = new Wall(new PVector(wallL, 0, wallL), new PVector(pos.x, yHeight - 0.1, pos.z + wallL / 2), im);
    Obstacles.add(wall);
    
    
    cellSize = wallL / numCells;
    
    for (int i = 0; i < numCells; i ++)
    {
      for (int j = 0; j < numCells; j ++)
      {
        heights[i][j] = wallH - 10;
        vels[i][j] = 0;
      }
    }
  }
 
  
  
  void update(float dT)
  {
     
    int iCollide, jCollide;
    float nextX, nextY, nextZ;
    for (Arrow a : Arrows)
    {
      if (a.moving)
      {
        nextX = a.pos.x + a.vel.x + a.acc.x;
        nextY = a.pos.y + a.vel.y + a.acc.y;
        nextZ = a.pos.z + a.vel.z + a.acc.z;
        if (nextX > (pos.x - wallL / 2) && nextX < pos.x + wallL / 2 && nextZ > pos.z && nextZ < pos.z + wallL)
        {
          if (nextY > (yHeight - (wallH - 5)))
          {
            Sounds.add(new Sound(0.05)); 
            iCollide = (int)((nextX - (pos.x - wallL / 2)) / cellSize);
            jCollide = (int)((nextZ - pos.z) / cellSize);
            vels[iCollide][jCollide] = 10;
                 
            for (int i = 0; i < 100; i ++)
            {
              particles.add(new Particle(new PVector(nextX - (pos.x - wallL / 2), -1 * (wallH - 5), nextZ - pos.z), new PVector(random(-20, 20), -1 * random(arrowSpeed / 4, arrowSpeed / 2), random(-20, 20)), new PVector(0, 50, 0), 5)) ;
            }
          }
        }        
      }
    }
    
    PShape drop = createShape(SPHERE, 5);
    drop.translate(pos.x - wallL / 2, yHeight, pos.z);
    drop.setFill(color(0, 0, 255));
    drop.setStroke(255);
    for (Particle p : particles)
    {
      p.vel = new PVector(p.vel.x + p.acc.x, p.vel.y + p.acc.y, p.vel.z + p.acc.z);
      p.pos = new PVector(p.pos.x + p.vel.x, p.pos.y + p.vel.y, p.pos.z + p.vel.z);
      
      drop.translate(p.pos.x, p.pos.y, p.pos.z);
      shape(drop);
      drop.translate(-1 * p.pos.x, -1 * p.pos.y, -1 * p.pos.z);
      
      if (p.pos.y > -1 * (wallH - 6))
      {
        expired.add(p) ;
      }
    }
    particles.removeAll(expired);
    
    float nSum;
    int nCt;
    for (int i = 0; i < numCells; i ++)
    {
      for (int j = 0; j < numCells; j ++)
      {
        nSum = 0;
        nCt = 0;
        if (i > 0)
        {
          nSum += heights[i - 1][j]; 
          nCt ++;
        }
        if (i < numCells - 1)
        {
          nSum += heights[i + 1][j];  
          nCt ++;
        }
        if (j > 0)
        {
          nSum += heights[i][j - 1];  
          nCt ++;
        }
        if (j < numCells - 1)
        {
          nSum += heights[i][j + 1];  
          nCt ++;
        }
        vels[i][j] += (nSum / nCt) - heights[i][j];
        vels[i][j] *= 0.95;
      }
    }
    
    for (int i = 0; i < numCells; i ++)
    {
      for (int j = 0; j < numCells; j ++)
      {
        if (heights[i][j] > wallH - 10)
        {
          heights[i][j] -= 5; 
        }
      }
    }
    
    PShape cell;
    cell = createShape(BOX, cellSize, 10, cellSize);
    cell.translate(pos.x - wallL / 2 + cellSize / 2, yHeight, pos.z + cellSize / 2);
    cell.setFill(color(0, 0, 200));
    cell.setStroke(192);
    for (int i = 0; i < numCells; i ++)
    {
      //cell.translate(cellSize, 0, -1 * (wallL - cellSize));
      for (int j = 0; j < numCells; j ++)
      {
        heights[i][j] += vels[i][j];
        
        cell.translate(0, -1 * heights[i][j], 0);
        
        //cell = createShape(BOX, cellSize, heights[i][j], cellSize);
        //cell.translate(pos.x - wallL / 2 + cellSize / 2 + i * cellSize, pos.y - heights[i][j] / 2, pos.z + cellSize / 2 + j * cellSize);
    
        shape(cell);
        cell.translate(0, heights[i][j], cellSize);
      }
      cell.translate(cellSize, 0, -1 * wallL);
    }    
  }  
  
}

public class Particle
{
  PVector pos;
  PVector vel;
  PVector acc;
  float rad;
  int floorCount = 0;
  boolean markedForDelete = false;
  
  public Particle(PVector posIn, PVector velIn, PVector accIn, float radIn)
  {
    pos = posIn;
    vel = velIn;
    acc = accIn;
    rad = radIn;
  }  
}