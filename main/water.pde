class Water extends Obstacle
{
  PShape shape;
  PVector pos;
  float sideL;
  float sideH = 50;
  float cellSize;
  Container con;
  int numCells = 20;
  // PVector x is velocity, y is height
  float heights[][] = new float[numCells][numCells];
  float vels[][] = new float[numCells][numCells];
 
  Water()
  {
    this(new PVector(0, yHeight - 20, 0), 20);
  }
  
  Water(PVector posIn, float sideLIn)
  {
    pos = posIn;
    sideL = sideLIn;
    shape = createShape();
    con = new Container(pos, sideL, sideH);
    cellSize = sideL / numCells;
    
    for (int i = 0; i < numCells; i ++)
    {
      for (int j = 0; j < numCells; j ++)
      {
        heights[i][j] = random(sideH - 25, sideH - 5);
        vels[i][j] = 0;
      }
    }
  }
 
  
  
  void update(float dT)
  {
    con.update();
    
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
    
    PShape cell;
    cell = createShape(BOX, cellSize, 10, cellSize);
    cell.translate(pos.x - sideL / 2 + cellSize / 2, yHeight, pos.z + cellSize / 2);
    cell.setFill(color(0, 0, 200));
    cell.setStroke(192);
    for (int i = 0; i < numCells; i ++)
    {
      //cell.translate(cellSize, 0, -1 * (sideL - cellSize));
      for (int j = 0; j < numCells; j ++)
      {
        heights[i][j] += vels[i][j];
        
        cell.translate(0, -1 * heights[i][j], 0);
        
        //cell = createShape(BOX, cellSize, heights[i][j], cellSize);
        //cell.translate(pos.x - sideL / 2 + cellSize / 2 + i * cellSize, pos.y - heights[i][j] / 2, pos.z + cellSize / 2 + j * cellSize);
    
        shape(cell);
        cell.translate(0, heights[i][j], cellSize);
      }
      cell.translate(cellSize, 0, -1 * sideL);
    }
    
  }
   
}


class Container
{
  ArrayList<PShape> Sides = new ArrayList<PShape>();
  PVector corner;
  float sideL;
  float sideW = 2;
  float sideH;
  color wColor = color(100, 100, 255);
  
  Container(PVector cornerIn, float sideLIn, float sideHIn)
  {
     corner = cornerIn;
     sideL = sideLIn;
     sideH = sideHIn;
     
     PImage im = loadImage("pool_floor.jpg");
     
     PShape side = createShape(BOX, sideL, sideH, sideW);
     side.translate(corner.x, corner.y - sideH / 2, corner.z);
     //side.setTexture(im);
     side.setFill(wColor);
     side.setStroke(192);
     Sides.add(side);
     
     side = createShape(BOX, sideL, sideH, sideW);
     side.translate(corner.x, corner.y - sideH / 2, corner.z + sideL);
     side.setTexture(im);
     //side.setFill(wColor);
     //side.setStroke(192);
     Sides.add(side);
     
     side = createShape(BOX, sideW, sideH, sideL);
     side.translate(corner.x - sideL / 2, corner.y - sideH / 2, corner.z + sideL / 2);
     side.setTexture(im);
     //side.setFill(wColor);
     //side.setStroke(192);
     Sides.add(side);
     
     side = createShape(BOX, sideW, sideH, sideL);
     side.translate(corner.x + sideL / 2, corner.y - sideH / 2, corner.z + sideL / 2);
     side.setTexture(im);
     //side.setFill(wColor);
     //side.setStroke(192);
     Sides.add(side); 
     
     side = createShape(BOX, sideL, 0, sideL);
     side.translate(corner.x, yHeight - 0.1, corner.z + sideL / 2);
     side.setTexture(im);
     //side.setFill(color(0, 0, 200));
     //side.setStroke(192);
     Sides.add(side);
  }
  
  void update()
  {
    for (PShape s : Sides)
    {
      shape(s); 
    }
  }
  
  
}