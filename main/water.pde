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
    for (Arrow a : Arrows)
    {
      if (a.moving)
      {
        if (a.pos.x > (pos.x - wallL / 2) && a.pos.x < pos.x + wallL / 2 && a.pos.z > pos.z && a.pos.z < pos.z + wallL)
        {
          if (a.pos.y + a.vel.y + a.acc.y > (yHeight - (wallH - 5)))
          {
            Sounds.add(new Sound(0.3)); 
            iCollide = (int)((a.pos.x - (pos.x - wallL / 2)) / cellSize);
            jCollide = (int)((a.pos.z - pos.z) / cellSize);
            vels[iCollide][jCollide] = 10;
            /*if (iCollide > 0)
            {
              vels[iCollide - 1][jCollide] = a.pos.y - yHeight; 
            }
            else if (iCollide < numCells - 1)
            {
              vels[iCollide + 1][jCollide] = a.pos.y - yHeight; 
            }
            else if (jCollide > 0)
            {
              vels[iCollide][jCollide - 1] = a.pos.y - yHeight; 
            }
            else if (jCollide < numCells - 1)
            {
              vels[iCollide][jCollide + 1] = a.pos.y - yHeight; 
            }*/
          }
        }        
      }
    }
      
    
    
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