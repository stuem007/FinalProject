class Sound
{
  float time;
  ArrayList<Oscil> osc = new ArrayList<Oscil>();
  
  Sound(float timeIn)
  {
    time = timeIn;
    osc.add(new Oscil(55, 0.5f, Waves.QUARTERPULSE));
    
    
    for (Oscil o : osc)
    {
      o.patch(aOut); 
    }
  }
    
  void end()
  {
    for (Oscil o : osc)
    {
      o.unpatch(aOut); 
    }
  }

}