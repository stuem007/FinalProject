class Arrow
{
  PVector orient;
  PVector pos;
  PVector vel;
  PVector acc;
  PShape rect;
  boolean nocked;
  boolean moving = false;
  float len = 100;
 
  Arrow()
  {
    this(new PVector(0, PI / 2), new PVector(300, 300, 250));
  }
  
  Arrow(PVector orientIn, PVector posIn)
  {
    orient = orientIn;
    pos = posIn;
    vel = new PVector(0, 0, 0);
    acc = gravity;
    nocked = true;
 
    //rect = loadShape("arrow.obj");
    //rect.rotateY(PI / 2);
    //rect.translate(10, 0, 0);
    rect = createShape(BOX, 10, 10, 100);
    rect.translate(pos.x, pos.y, pos.z + 50);
    rect.setFill(color(125, 125, 125));
    rect.setStroke(192);
  }
  
  void update(float dT)
  {
    if (moving)
    {
      /*pushMatrix();
      translate(pos.x, pos.y, pos.z);
      rect.rotate(PI / 300);
      popMatrix();*/
      //vel.add(PVector.mult(gravity, dT));
      vel.add(PVector.mult(acc, dT));
      pos.add(PVector.mult(vel, dT));
      rect.translate(vel.x * dT, vel.y * dT, vel.z * dT);
    }
    shape(rect); 
  }
  
}