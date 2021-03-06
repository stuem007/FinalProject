class Wall extends Obstacle
{
  PShape wall;
  PVector dim;
  PVector pos;
  float rad;
  
  Wall(PVector dimIn, PVector posIn, PImage im)
  {
    dim = dimIn;
    pos = posIn;
    
    wall = createShape(BOX, dim.x, dim.y, dim.z);
    wall.translate(pos.x, pos.y, pos.z);
    wall.setTexture(im);
  }
 
  
  
  void update(float dT)
  {
    for (Arrow a : Arrows)
    {
      if (a.moving)
      {
        if (a.len > dim.x)
        {
          if ((a.pos.x < pos.x && a.pos.x + (a.vel.x + a.acc.x) * dT > pos.x) || (a.pos.x > pos.x && a.pos.x + (a.vel.x + a.acc.x) * dT < pos.x))
          {
            Sounds.add(new Sound(0.15, "wall"));
            a.update(dT);
            a.moving = false;
          }
        }
        else if (a.len > dim.y)
        {
          if ((a.pos.y < pos.y && a.pos.y + (a.vel.y + a.acc.y) * dT > pos.y) || (a.pos.y > pos.y && a.pos.y + (a.vel.y + a.acc.y) * dT < pos.y))
          {
            Sounds.add(new Sound(0.15, "wall"));  
            a.update(dT);
            a.moving = false;
          }
        }
        else if (a.len > dim.z)
        {
          if (((a.pos.z < pos.z && a.pos.z + (a.vel.z + a.acc.z) * dT > pos.z) || (a.pos.z > pos.z && a.pos.z + (a.vel.z + a.acc.z) * dT < pos.z)) && a.pos.x >= pos.x - dim.x / 2 && a.pos.x <= pos.x + dim.x / 2)
          {
            Sounds.add(new Sound(0.05, "wall"));  
            a.update(dT);
            a.moving = false;
          }
        }
      }
    }
    
    shape(wall);
  }
   
}