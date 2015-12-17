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
    this(new PVector(0, PI / 2), new PVector(300, 300, 300));
  }
  
  Arrow(PVector orientIn, PVector posIn)
  {
    orient = orientIn;
    pos = posIn;
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
    nocked = true;
 
    //rect = loadShape("arrow.obj");
    //rect.rotateY(PI / 2);
    //rect.translate(10, 0, 0);
    rect = createShape(BOX, 10, 10, 100);
    rect.translate(pos.x, pos.y, pos.z);
    rect.setFill(color(125, 125, 125));
    rect.setStroke(192);
  }
  
  void update(float dT)
  {
    if (!nocked)
    {
      /*pushMatrix();
      translate(pos.x, pos.y, pos.z);
      rect.rotate(PI / 300);
      popMatrix();*/
      vel.add(PVector.mult(gravity, dT));
      vel.add(PVector.mult(acc, dT));
      pos.add(PVector.mult(vel, dT));
      rect.translate(vel.x * dT, vel.y * dT, vel.z * dT);
    }
    //shape(rect, pos.x, pos.y, 20, 100); 
  }
  
}

//-------------------------------------------------------------------------------------------

class Arrow3d
{
  PVector orient;
  PVector pos;
  PVector vel;
  PVector acc;
  boolean nocked;
 
  Arrow3d()
  {
    this(new PVector(0, PI / 2), new PVector(300, 300, 0));
  }
  
  Arrow3d(PVector orientIn, PVector posIn)
  {
    orient = orientIn;
    pos = posIn;
    vel = new PVector(0, 0, 0);
    acc = new PVector(0, 0, 0);
    nocked = true;
  }
  
  void update(float dT)
  {
    if (!nocked)
    {
      vel.add(PVector.mult(gravity, dT));
      vel.add(PVector.mult(acc, dT));
      pos.add(PVector.mult(vel, dT));
      
      scale(10);
      translate(pos.x, pos.y, pos.z);
      
      pushMatrix();
      //ArrowHead
      beginShape(TRIANGLES);
      fill(.7, .7, .7); vertex(-.25,  0,  .25);
      fill(.7, .7, .7); vertex(-.25,  0,  -.25);
      fill(.7, .7, .7); vertex(0, .75,  0);
    
      fill(.7, .7, .7); vertex(.25,  0,  .25);
      fill(.7, .7, .7); vertex(.25,  0,  -.25);
      fill(.7, .7, .7); vertex(0, .75,  0);
    
      fill(.7, .7, .7); vertex(.25,  0,  -.25);
      fill(.7, .7, .7); vertex( -.25,  0,  -.25);
      fill(.7, .7, .7); vertex( 0, .75,  0);
    
      fill(.7, .7, .7); vertex(-.25,  0,  .25);
      fill(.7, .7, .7); vertex(.25,  0, .25);
      fill(.7, .7, .7); vertex( 0, .75,  0);
      
      fill(.7, .7, .7); vertex(-.25,  0,  .25);
      fill(.7, .7, .7); vertex( -.25,  0,  -.25);
      fill(.7, .7, .7); vertex(.25, 0, .25);
    
      fill(.7, .7, .7); vertex(.25,  0,  -.25);
      fill(.7, .7, .7); vertex( -.25,  0,  -.25);
      fill(.7, .7, .7); vertex(.25, 0, .25);
      endShape();
      
      //ArrowShaft
      beginShape(QUADS);
      fill(.7, .7, 0); vertex(.1, 0, .1);
      fill(.7, .7, 0); vertex(.1, -3, .1);
      fill(.7, .7, 0); vertex(-.1, -3, .1);
      fill(.7, .7, 0); vertex(-.1, 0, .1);
    
      fill(.7, .7, 0); vertex(.1, 0, -.1);
      fill(.7, .7, 0); vertex(.1, -3, -.1);
      fill(.7, .7, 0); vertex(-.1, -3, -.1);
      fill(.7, .7, 0); vertex(-.1, 0, -.1);
      
      fill(.7, .7, 0); vertex(.1, 0, .1);
      fill(.7, .7, 0); vertex(.1, -3, .1);
      fill(.7, .7, 0); vertex(.1, -3, -.1);
      fill(.7, .7, 0); vertex(.1, 0, -.1);
    
      fill(.7, .7, 0); vertex(-.1, 0, .1);
      fill(.7, .7, 0); vertex(-.1, -3, .1);
      fill(.7, .7, 0); vertex(-.1, -3, -.1);
      fill(.7, .7, 0); vertex(-.1, 0, -.1);
    
      fill(.7, .7, 0); vertex(-.1, -3, -.1);
      fill(.7, .7, 0); vertex(-.1, -3, .1);
      fill(.7, .7, 0); vertex(.1, -3, .1);
      fill(.7, .7, 0); vertex(.1, -3, -.1);
      endShape();
      
      beginShape(TRIANGLES);
      //ArrowFletchings
      fill(1, 0, 0); vertex(-.1, -3, -.1);
      fill(1, 0, 0); vertex(-.1, -2.4, -.1);
      fill(1, 0, 0); vertex(-.3, -3.1, -.3);
    
      fill(1, 0, 0); vertex(-.1, -3, .1);
      fill(1, 0, 0); vertex(-.1, -2.4, .1);
      fill(1, 0, 0); vertex(-.3, -3.1, .3);
    
      fill(1, 0, 0); vertex(.1, -3, .1);
      fill(1, 0, 0); vertex(.1, -2.4, .1);
      fill(1, 0, 0); vertex(.3, -3.1, .3);
      
      fill(1, 0, 0); vertex(.1, -3, -.1);
      fill(1, 0, 0); vertex(.1, -2.4, -.1);
      fill(1, 0, 0); vertex(.3, -3.1, -.3);
      endShape();
      
      popMatrix();
    }
  }
}