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
  
  Sound(float timeIn, String type)
  {
    time = timeIn; 
    
    if (type == "water")
    {
      osc.add(new Oscil(110, 0.01f, Waves.SINE));
      osc.add(new Oscil(110, 0.01f, Waves.SINE));
    }
    else if (type == "cloth")
    {
      osc.add(new Oscil(55, 0.2f, Waves.SINE));
    }
    else if (type == "wall")
    {
      osc.add(new Oscil(55, 0.5f, Waves.SINE));
    }
    else if (type == "arrow")
    {
      osc.add(new Oscil(8, 0.5f, Waves.QUARTERPULSE));
      osc.add(new Oscil(8, 0.5f, Waves.QUARTERPULSE));
      osc.add(new Oscil(16, 0.5f, Waves.QUARTERPULSE));
    }    
    else
    {
      osc.add(new Oscil(55, 0.5f, Waves.QUARTERPULSE));  
    }
   
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