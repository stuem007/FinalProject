// This class will house the archery target, pending the definition of the actual PShape.
class Target extends Obstacle
{
  PShape wall;
  PVector pos;
  float rad;
 
  Target()
  {
    this(new PVector(0, yHeight - 20, 0), 20);
  }
  
  Target(PVector posIn, float radIn)
  {
    pos = posIn;
    rad = radIn;
  }
 
  
  
  void update(float dT)
  {

  }
   
}