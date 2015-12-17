
  
void keyPressed()
{
  if (key == 'i')
  {
    camera.ctrY -= 50;
    
    //camera.ctrZ -= 50;
    //camera.camZ -= 50;
  }
  else if (key == 'j')
  {
    camera.ctrX -= 50;
    
    //camera.ctrX -= 50;
    //camera.camX -= 50;
  }
  else if (key == 'k')
  {
    camera.ctrY += 50;
    
    //camera.ctrZ += 50;
    //camera.camZ += 50;
  }
  else if (key == 'l')
  {
    camera.ctrX += 50;
    
    //camera.ctrX += 50;
    //camera.camX += 50;
  }
  else if (key == 'w')
  {
    camera.yDir = 1;
    camera.ctrZ -= 50;
    camera.camZ -= 50;
  }
  else if (key == 'a')
  {
    camera.xDir = -1;
    camera.ctrX -= 50;
    camera.camX -= 50;
  }
  else if (key == 's')
  {
    camera.yDir -= 1;
    camera.ctrZ += 50;
    camera.camZ += 50;
  }
  else if (key == 'd')
  {
    camera.xDir += 1;
    camera.ctrX += 50;
    camera.camX += 50;
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
  else if (key == 't')
  {
    sound.test(); 
    
  }
}

/*void keyReleased()
{
  if (key == 'w')
  {
    camera.yDir = 1;
  }
  if (key == 'a')
  {
    camera.xDir = -1;
  }
  if (key == 's')
  {
    camera.yDir -= 1;
  }
  if (key == 'd')
  {
    camera.xDir += 1;
  } 
}*/