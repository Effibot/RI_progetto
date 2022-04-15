import java.util.ArrayList;
public class Obstacle{
    private float xc;
    private float yc;
    private float zc;
    private float r;
    private float h;
    private int sides = 30;

    public Obstacle(float xc, float yc, float zc, float r, float h){
        this.xc = xc;
        this.yc = yc;
        this.zc = zc;
        this.r = r;
        this.h = h;
    }

@Override
public String toString(){
  return(
    "Obstacle BC: ["+this.xc+","+this.yc+","+this.zc+"]\n"+
    "Obstacle [r, h]: ["+this.r+","+this.h+"]"
  );
}
}
