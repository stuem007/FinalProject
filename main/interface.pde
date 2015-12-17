 
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
    camera.ctrZ -= 50;
    camera.camZ -= 50;
    for (Arrow a : Arrows)
    {
      if (a.nocked)
      {
        a.rect.translate(0, 0, -50);
        a.pos.z -= 50; 
      }
    }
  }
  else if (key == 'a')
  {
    camera.ctrX -= 50;
    camera.camX -= 50;
    for (Arrow a : Arrows)
    {
      if (a.nocked)
      {
        a.rect.translate(-50, 0, 0);
        a.pos.x -= 50; 
      }
    }
  }
  else if (key == 's')
  {
    camera.ctrZ += 50;
    camera.camZ += 50;
    for (Arrow a : Arrows)
    {
      if (a.nocked)
      {
        a.rect.translate(0, 0, 50);
        a.pos.z += 50; 
      }
    }
  }
  else if (key == 'd')
  {
    camera.ctrX += 50;
    camera.camX += 50;
    for (Arrow a : Arrows)
    {
      if (a.nocked)
      {
        a.rect.translate(50, 0, 0);
        a.pos.x += 50; 
      }
    }
  }
  else if (key == 'r')
  {
    Arrow last = Arrows.get(Arrows.size() - 1);
    if (!last.nocked)
    {
      Arrows.add(new Arrow(new PVector(0, PI / 2), new PVector(camera.camX + 50, camera.camY + 50, camera.camZ - 200)));     
    }
  }
  else if (key == 'f')
  {
    Arrow last = Arrows.get(Arrows.size() - 1);
    if (last.nocked)
    {
      Sounds.add(new Sound(0.15, "arrow"));
      last.vel = new PVector(0, 0, -1 * arrowSpeed);
      //last.vel = new PVector(160 * cos(last.orient.y), 0, -160 * sin(last.orient.y));
      last.nocked = false;
      last.moving = true;
    }
  }
  else if (key == 't')
  {
    //Sounds.add(new Sound(0.1));
  }
  else if (key == '.')
  {
    arrowSpeed += 50;
  }
  else if (key == ',')
  {
    if (arrowSpeed > 50)
    {
      arrowSpeed -= 50;
    }
  }
}