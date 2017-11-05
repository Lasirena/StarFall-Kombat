float heading2D(PVector pvect){
  return (float)(Math.atan2(pvect.y, pvect.x));  
}
  
void rotate2D(PVector v, float theta) {
  float xTemp = v.x;
  v.x = v.x*cos(theta) - v.y*sin(theta);
  v.y = xTemp*sin(theta) + v.y*cos(theta);
}