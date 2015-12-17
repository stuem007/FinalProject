class Camera
{
  float speed = 100;
  int xDir = 0;
  int yDir = 0;
  float camX, camY, camZ;
  float ctrX, ctrY, ctrZ;
  float upX, upY, upZ;

  Camera(float camXIn, float camYIn, float camZIn, float ctrXIn, float ctrYIn, float ctrZIn, float upXIn, float upYIn, float upZIn)
  {
    camX = camXIn;
    camY = camYIn;
    camZ = camZIn;
  
    ctrX = ctrXIn;
    ctrY = ctrYIn;
    ctrZ = ctrZIn;
    
    upX = upXIn;
    upY = upYIn;
    upZ = upZIn;
  }
  
  
  
  void update(float dT)
  {
    
    xDir = 0;
    yDir = 0;
    
    camera(camX, camY, camZ, 200*sin((float)mouseX/(float)width*TWO_PI)+ctrX, ctrY, 200*cos((float)mouseX/(float)width*TWO_PI)+ctrZ, upX, upY, upZ);
  }
  
  
 
}