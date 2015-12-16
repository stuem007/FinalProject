class Water extends Obstacle
{
  PShape shape;
  PVector pos;
  float side;
 
  Water()
  {
    this(new PVector(0, yHeight - 20, 0), 20);
  }
  
  Water(PVector posIn, float sideIn)
  {
    pos = posIn;
    side = sideIn;
    shape = createShape();
  }
 
  
  
  void update(float dT)
  {

  }
   
}