  import java.util.ArrayList; //<>//
  import pallav.Matrix.*;
  import java.lang.Math.*;
    float kN=0.0001;
  
  public class RobotNew {
    int N=6;
    PShape rover, r1, r2, r3, r4, r5, r6;
    float Q1=0.0, Q2=0.0, Q3=0.0, Q4=0.0, Q5=0.0, Q6=0.0;
    float[][] J = new float[12][6];
    ArrayList<PShape> link = new ArrayList<PShape>();
    String path = "models/robot_rover/";
    ArrayList<String> linkList = new ArrayList<String>();
    Float[] q = new Float[6] ;
    Float scaleFactorRover = 0.2;
    Float scaleFactorArms = 1.2;
    //misure in mm
    float roverH = 50;  // altezza rover
    float roverW = 20;  // altezza ruote rover
    float roverD = 220; // diametro rover
    float link1=40;
    float link2=62;
    float link3=0;
    float link4=60;
    float link5=0;
    float link6=12;
    float posX = 0.1;
    float posY = 0.1;
    float posZ = 0.1;
    ArrayList<Float> pos = new ArrayList<>(3);
    boolean b = true;
  
    float roll=PI/2;
    float pitch=PI/2;
    float yaw =PI/2;
    float[][] R =assignOrient(roll, pitch, yaw);
    private RobotNew() {
      // Carico tutte istanze dei link
      for (int i = 0; i <= 6; i++) {
        if (i==0)
          link.add(loadLink(path + "Link" + i + ".obj", scaleFactorRover));
        else
          link.add(loadLink(path + "Link" + i + ".obj", scaleFactorArms));
  
        if (i < 6) q[i] = 0.0;
      }
      pos.add(posX);
      pos.add(posY);
      posZ = -floorHeight/2+scale(roverH/2+roverW);
      pos.add(posZ);
    }
  
    public void drawLink(float x, float y) {
      //translate(-x, -y, posZ);
      //show_axes(b);
      pushMatrix();
      /* R0 */
      rotateZ(PI / 2);
      link.get(0).setFill(color(144, 155, 10));
  
      shape(link.get(0));
      popMatrix();
  
          pushMatrix();

      rotateZ(q1);
      translate(0, 0, link1);
      rotateX(-PI/2);
      //show_axes(b);  //Q01
  
      pushMatrix();
      translate(0, 29, 0);
      rotateZ(PI);
      rotateY(-PI/2);
      link.get(1).setFill(color(125, 0, 0));
      shape(link.get(1));
      popMatrix();
        pushMatrix();

      rotateZ(q2-PI/2);
      translate(link2, 0, 0);
      //show_axes(b); //Q12
      pushMatrix();
      link.get(2).setFill(color(255, 10, 0));
      translate(-62, 0, 0);
      rotateY(PI/2);
      ////show_axes(b);
      shape(link.get(2));
      popMatrix();
  
        pushMatrix();

      rotateZ(q3-PI/2);
      rotateX(-PI/2);
      //show_axes(b); //Q23
      pushMatrix();
      rotateX(PI);
      rotateZ(-PI/2);
      link.get(3).setFill(color(0, 255, 0));
      shape(link.get(3));
      popMatrix();
  
        pushMatrix();

      rotateZ(q4);
      translate(0, 0, link4);
      rotateX(PI/2);
      ////show_axes(b); //Q34
      pushMatrix();
      translate(0, -60, 0);
      rotateZ(PI/2);
      rotateY(-PI/2);
      link.get(4).setFill(color(255, 0, 0));
      shape(link.get(4));
      popMatrix();
        pushMatrix();

  
      rotateZ(q5);
      rotateX(-PI/2);
      //show_axes(b);
      pushMatrix();
      rotateZ(PI/2);
      link.get(4).setFill(color(0, 255, 210));
      shape(link.get(5));
      popMatrix();
  
        pushMatrix();

      rotateZ(q6);
      translate(0, 0, 12);
      show_axes(b); //Q56
      pushMatrix();
      translate(0, 0, -12);
      link.get(6).setFill(color(0, 255, 210));
      shape(link.get(6));
      popMatrix();
      
            popMatrix();
      popMatrix();
      popMatrix();
      popMatrix();
      popMatrix();
            popMatrix();


    }
  
    public void DH(float theta, float d, float alpha, float a, boolean b) {
      // Rotazione attorno all'asse Z di 'theta'
      rotateZ(radians(theta));
      ////show_axes(b);
      // Traslazione lungo l'asse Z di 'd'
      translate(0, 0, scale(d));
      // Rotazione attorno all'asse X di 'alpha'
      rotateX(radians(alpha));
      // Traslazione lungo l'asse X di 'a'
      translate(scale(a), 0, 0);
    }
  
    private float scale(float z) {
      // z : 100 =zz : 20
      return z * scaleFactorRover;
    }
  
    private PShape loadLink(String objectName, float scaling) {
      PShape shape = loadShape(objectName);
      shape.scale(scaling);
      return shape;
    }
  
    public ArrayList<Float> getPos() {
      return this.pos;
    }
  
    public void setPos(Float newPosX, Float newPosY) {
      this.pos.set(1, newPosX);
      this.pos.set(2, newPosY);
    }
    public float[] dr(float q1,float q2,float q3,float q4,float q5,float q6)
    { q3=q3-PI/2;
      float[] ret = new float[3];
      float xe=62*cos(q1)*sin(q2) + 60*cos(q1)*cos(q2 + q3) - 12*sin(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q4)*sin(q2 + q3)) + 12*cos(q1)*cos(q5)*cos(q2 + q3);
      float ye=62*sin(q1)*sin(q2) + 60*sin(q1)*cos(q2 + q3) + 12*sin(q5)*(cos(q1)*sin(q4) - cos(q4)*sin(q1)*sin(q2 + q3)) + 12*cos(q5)*sin(q1)*cos(q2 + q3);
      float ze=62*cos(q2) - 60*sin(q2 + q3) - 12*cos(q5)*sin(q2 + q3) - 12*cos(q4)*sin(q5)*cos(q2 + q3) + 40;
      ret[0]=xe;
      ret[1]=ye;
      ret[2]=ze;
    return ret;
  }
    public float[] newton(float xDes,float yDes, float zDes) {
      J[0][0]=- 62*sin(q1)*sin(q2) - 12*sin(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - 60*sin(q2 + q3)*sin(q1) - 12*sin(q2 + q3)*cos(q5)*sin(q1);
      J[0][1]=62*cos(q1)*cos(q2) + 60*cos(q2 + q3)*cos(q1) + 12*cos(q2 + q3)*cos(q1)*cos(q5) - 12*sin(q2 + q3)*cos(q1)*cos(q4)*sin(q5);
      J[0][2]=60*cos(q2 + q3)*cos(q1) + 12*cos(q2 + q3)*cos(q1)*cos(q5) - 12*sin(q2 + q3)*cos(q1)*cos(q4)*sin(q5);
      J[0][3]=-12*sin(q5)*(cos(q4)*sin(q1) + cos(q2 + q3)*cos(q1)*sin(q4));
      J[0][4]=- 12*cos(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) - 12*sin(q2 + q3)*cos(q1)*sin(q5);
      J[0][5]=0;
      J[1][0]=62*cos(q1)*sin(q2) - 12*sin(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) + 60*sin(q2 + q3)*cos(q1) + 12*sin(q2 + q3)*cos(q1)*cos(q5);
      J[1][1]=62*cos(q2)*sin(q1) + 60*cos(q2 + q3)*sin(q1) + 12*cos(q2 + q3)*cos(q5)*sin(q1) - 12*sin(q2 + q3)*cos(q4)*sin(q1)*sin(q5);
      J[1][2]=60*cos(q2 + q3)*sin(q1) + 12*cos(q2 + q3)*cos(q5)*sin(q1) - 12*sin(q2 + q3)*cos(q4)*sin(q1)*sin(q5);
      J[1][3]=12*sin(q5)*(cos(q1)*cos(q4) - cos(q2 + q3)*sin(q1)*sin(q4));
      J[1][4]=12*cos(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - 12*sin(q2 + q3)*sin(q1)*sin(q5);
      J[1][5]=0.0;
      J[2][0]=0.0;
      J[2][1]=- 60*sin(q2 + q3) - 62*sin(q2) - 12*sin(q2 + q3)*cos(q5) - 12*cos(q2 + q3)*cos(q4)*sin(q5);
      J[2][2]=- 60*sin(q2 + q3) - 12*sin(q2 + q3)*cos(q5) - 12*cos(q2 + q3)*cos(q4)*sin(q5);
      J[2][3]=12*sin(q2 + q3)*sin(q4)*sin(q5);
      J[2][4]=- 12*cos(q2 + q3)*sin(q5) - 12*sin(q2 + q3)*cos(q4)*cos(q5);
      J[2][5]=0.0;
      J[3][0]=sin(q6)*(cos(q1)*cos(q4) - cos(q2 + q3)*sin(q1)*sin(q4)) + cos(q6)*(cos(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - sin(q2 + q3)*sin(q1)*sin(q5));
      J[3][1]=cos(q6)*(cos(q2 + q3)*cos(q1)*sin(q5) + sin(q2 + q3)*cos(q1)*cos(q4)*cos(q5)) - sin(q2 + q3)*cos(q1)*sin(q4)*sin(q6);
      J[3][2]=cos(q6)*(cos(q2 + q3)*cos(q1)*sin(q5) + sin(q2 + q3)*cos(q1)*cos(q4)*cos(q5)) - sin(q2 + q3)*cos(q1)*sin(q4)*sin(q6);
      J[3][3]=cos(q5)*cos(q6)*(cos(q4)*sin(q1) + cos(q2 + q3)*cos(q1)*sin(q4)) - sin(q6)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4));
      J[3][4]=-cos(q6)*(sin(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) - sin(q2 + q3)*cos(q1)*cos(q5));
      J[3][5]=cos(q6)*(cos(q4)*sin(q1) + cos(q2 + q3)*cos(q1)*sin(q4)) - sin(q6)*(cos(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) + sin(q2 + q3)*cos(q1)*sin(q5));
      J[4][0]=sin(q6)*(cos(q4)*sin(q1) + cos(q2 + q3)*cos(q1)*sin(q4)) + cos(q6)*(cos(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) + sin(q2 + q3)*cos(q1)*sin(q5));
      J[4][1]=cos(q6)*(cos(q2 + q3)*sin(q1)*sin(q5) + sin(q2 + q3)*cos(q4)*cos(q5)*sin(q1)) - sin(q2 + q3)*sin(q1)*sin(q4)*sin(q6);
      J[4][2]=cos(q6)*(cos(q2 + q3)*sin(q1)*sin(q5) + sin(q2 + q3)*cos(q4)*cos(q5)*sin(q1)) - sin(q2 + q3)*sin(q1)*sin(q4)*sin(q6);
      J[4][3]=sin(q6)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - cos(q5)*cos(q6)*(cos(q1)*cos(q4) - cos(q2 + q3)*sin(q1)*sin(q4));
      J[4][4]=cos(q6)*(sin(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) + sin(q2 + q3)*cos(q5)*sin(q1));
      J[4][5]=sin(q6)*(cos(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - sin(q2 + q3)*sin(q1)*sin(q5)) - cos(q6)*(cos(q1)*cos(q4) - cos(q2 + q3)*sin(q1)*sin(q4));
      J[5][0]=0.0;
      J[5][1]=- cos(q6)*(sin(q2 + q3)*sin(q5) - cos(q2 + q3)*cos(q4)*cos(q5)) - cos(q2 + q3)*sin(q4)*sin(q6);
      J[5][2]=- cos(q6)*(sin(q2 + q3)*sin(q5) - cos(q2 + q3)*cos(q4)*cos(q5)) - cos(q2 + q3)*sin(q4)*sin(q6);
      J[5][3]=- sin(q2 + q3)*cos(q4)*sin(q6) - sin(q2 + q3)*cos(q5)*cos(q6)*sin(q4);
      J[5][4]=cos(q6)*(cos(q2 + q3)*cos(q5) - sin(q2 + q3)*cos(q4)*sin(q5));
      J[5][5]=- sin(q6)*(cos(q2 + q3)*sin(q5) + sin(q2 + q3)*cos(q4)*cos(q5)) - sin(q2 + q3)*cos(q6)*sin(q4);
      J[6][0]=cos(q6)*(cos(q1)*cos(q4) - cos(q2 + q3)*sin(q1)*sin(q4)) - sin(q6)*(cos(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - sin(q2 + q3)*sin(q1)*sin(q5));
      J[6][1]=- sin(q6)*(cos(q2 + q3)*cos(q1)*sin(q5) + sin(q2 + q3)*cos(q1)*cos(q4)*cos(q5)) - sin(q2 + q3)*cos(q1)*cos(q6)*sin(q4);
      J[6][2]=- sin(q6)*(cos(q2 + q3)*cos(q1)*sin(q5) + sin(q2 + q3)*cos(q1)*cos(q4)*cos(q5)) - sin(q2 + q3)*cos(q1)*cos(q6)*sin(q4);
      J[6][3]=- cos(q6)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) - cos(q5)*sin(q6)*(cos(q4)*sin(q1) + cos(q2 + q3)*cos(q1)*sin(q4));
      J[6][4]=sin(q6)*(sin(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) - sin(q2 + q3)*cos(q1)*cos(q5));
      J[6][5]=- sin(q6)*(cos(q4)*sin(q1) + cos(q2 + q3)*cos(q1)*sin(q4)) - cos(q6)*(cos(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) + sin(q2 + q3)*cos(q1)*sin(q5));
      J[7][0]=cos(q6)*(cos(q4)*sin(q1) + cos(q2 + q3)*cos(q1)*sin(q4)) - sin(q6)*(cos(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) + sin(q2 + q3)*cos(q1)*sin(q5));
      J[7][1]=- sin(q6)*(cos(q2 + q3)*sin(q1)*sin(q5) + sin(q2 + q3)*cos(q4)*cos(q5)*sin(q1)) - sin(q2 + q3)*cos(q6)*sin(q1)*sin(q4);
      J[7][2]=- sin(q6)*(cos(q2 + q3)*sin(q1)*sin(q5) + sin(q2 + q3)*cos(q4)*cos(q5)*sin(q1)) - sin(q2 + q3)*cos(q6)*sin(q1)*sin(q4);
      J[7][3]=cos(q6)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) + cos(q5)*sin(q6)*(cos(q1)*cos(q4) - cos(q2 + q3)*sin(q1)*sin(q4));
      J[7][4]=-sin(q6)*(sin(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) + sin(q2 + q3)*cos(q5)*sin(q1));
      J[7][5]=sin(q6)*(cos(q1)*cos(q4) - cos(q2 + q3)*sin(q1)*sin(q4)) + cos(q6)*(cos(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - sin(q2 + q3)*sin(q1)*sin(q5));
      J[8][0]=0.0;
      J[8][1]=sin(q6)*(sin(q2 + q3)*sin(q5) - cos(q2 + q3)*cos(q4)*cos(q5)) - cos(q2 + q3)*cos(q6)*sin(q4);
      J[8][2]=sin(q6)*(sin(q2 + q3)*sin(q5) - cos(q2 + q3)*cos(q4)*cos(q5)) - cos(q2 + q3)*cos(q6)*sin(q4);
      J[8][3]=sin(q2 + q3)*cos(q5)*sin(q4)*sin(q6) - sin(q2 + q3)*cos(q4)*cos(q6);
      J[8][4]=-sin(q6)*(cos(q2 + q3)*cos(q5) - sin(q2 + q3)*cos(q4)*sin(q5));
      J[8][5]=sin(q2 + q3)*sin(q4)*sin(q6) - cos(q6)*(cos(q2 + q3)*sin(q5) + sin(q2 + q3)*cos(q4)*cos(q5));
      J[9][0]=- sin(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - sin(q2 + q3)*cos(q5)*sin(q1);
      J[9][1]=cos(q2 + q3)*cos(q1)*cos(q5) - sin(q2 + q3)*cos(q1)*cos(q4)*sin(q5);
      J[9][2]=cos(q2 + q3)*cos(q1)*cos(q5) - sin(q2 + q3)*cos(q1)*cos(q4)*sin(q5);
      J[9][3]=-sin(q5)*(cos(q4)*sin(q1) + cos(q2 + q3)*cos(q1)*sin(q4));
      J[9][4]=- cos(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4)) - sin(q2 + q3)*cos(q1)*sin(q5);
      J[9][5]=0.0;
      J[10][0]=sin(q2 + q3)*cos(q1)*cos(q5) - sin(q5)*(sin(q1)*sin(q4) - cos(q2 + q3)*cos(q1)*cos(q4));
      J[10][1]=cos(q2 + q3)*cos(q5)*sin(q1) - sin(q2 + q3)*cos(q4)*sin(q1)*sin(q5);
      J[10][2]=cos(q2 + q3)*cos(q5)*sin(q1) - sin(q2 + q3)*cos(q4)*sin(q1)*sin(q5);
      J[10][3]=sin(q5)*(cos(q1)*cos(q4) - cos(q2 + q3)*sin(q1)*sin(q4));
      J[10][4]=cos(q5)*(cos(q1)*sin(q4) + cos(q2 + q3)*cos(q4)*sin(q1)) - sin(q2 + q3)*sin(q1)*sin(q5);
      J[10][5]=0.0;
      J[11][0]=0.0;
      J[11][1]=- sin(q2 + q3)*cos(q5) - cos(q2 + q3)*cos(q4)*sin(q5);
      J[11][2]=- sin(q2 + q3)*cos(q5) - cos(q2 + q3)*cos(q4)*sin(q5);
      J[11][3]=sin(q2 + q3)*sin(q4)*sin(q5);
      J[11][4]=- cos(q2 + q3)*sin(q5) - sin(q2 + q3)*cos(q4)*cos(q5);
      J[11][5]=0.0;
      Matrix Jm = Matrix.array(J);
      float[][] Jt = transpose(J);
      Matrix Jtm = Matrix.array(Jt);
      Matrix JJt=Matrix.Multiply(Jtm, Jm);
      float[][] JJtar = new float[6][6];
      JJtar=inverse(JJt.array,JJtar);
      //Matrix.print(Matrix.array(JJtar));
      //float[][] invJ = Matrix.inverse(JJtar);
      float detJ = Matrix.determinant(Matrix.array(JJtar));
      //println(detJ);
      float[][] Phq=new float[12][1];
      Phq[0][0]=xDes -(link2*cos(q1)*sin(q2) - link6*(sin(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q4)*sin(q2 + q3)) - cos(q1)*cos(q5)*cos(q2 + q3)) + link4*cos(q1)*cos(q2 + q3));
      Phq[1][0]=yDes - (link6*(sin(q5)*(cos(q1)*sin(q4) - cos(q4)*sin(q1)*sin(q2 + q3)) + cos(q5)*sin(q1)*cos(q2 + q3)) + link2*sin(q1)*sin(q2) + link4*sin(q1)*cos(q2 + q3));
      Phq[2][0]=zDes - (link1 - link4*sin(q2 + q3) - link6*(cos(q5)*sin(q2 + q3) + cos(q4)*sin(q5)*cos(q2 + q3)) + link2*cos(q2));
      Phq[3][0]=R[0][0] -(cos(q6)*(cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q4)*sin(q2 + q3)) + cos(q1)*sin(q5)*cos(q2 + q3)) + sin(q6)*(cos(q4)*sin(q1) - cos(q1)*sin(q4)*sin(q2 + q3)));
      Phq[4][0]=R[1][0] -(- cos(q6)*(cos(q5)*(cos(q1)*sin(q4) - cos(q4)*sin(q1)*sin(q2 + q3)) - sin(q1)*sin(q5)*cos(q2 + q3)) - sin(q6)*(cos(q1)*cos(q4) + sin(q1)*sin(q4)*sin(q2 + q3)));
      Phq[5][0]=R[2][0] -(- cos(q6)*(sin(q5)*sin(q2 + q3) - cos(q4)*cos(q5)*cos(q2 + q3)) - sin(q4)*sin(q6)*cos(q2 + q3));
      Phq[6][0]=R[0][1] -(cos(q6)*(cos(q4)*sin(q1) - cos(q1)*sin(q4)*sin(q2 + q3)) - sin(q6)*(cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q4)*sin(q2 + q3)) + cos(q1)*sin(q5)*cos(q2 + q3)));
      Phq[7][0]=R[1][1] -(sin(q6)*(cos(q5)*(cos(q1)*sin(q4) - cos(q4)*sin(q1)*sin(q2 + q3)) - sin(q1)*sin(q5)*cos(q2 + q3)) - cos(q6)*(cos(q1)*cos(q4) + sin(q1)*sin(q4)*sin(q2 + q3)));
      Phq[8][0]=R[2][1] -(sin(q6)*(sin(q5)*sin(q2 + q3) - cos(q4)*cos(q5)*cos(q2 + q3)) - cos(q6)*sin(q4)*cos(q2 + q3));
      Phq[9][0]=R[0][2] -(cos(q1)*cos(q5)*cos(q2 + q3) - sin(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q4)*sin(q2 + q3)));
      Phq[10][0]=R[1][2] - (sin(q5)*(cos(q1)*sin(q4) - cos(q4)*sin(q1)*sin(q2 + q3)) + cos(q5)*sin(q1)*cos(q2 + q3));
      Phq[11][0]=R[2][2] -(- cos(q5)*sin(q2 + q3) - cos(q4)*sin(q5)*cos(q2 + q3));
      Matrix Phqm = Matrix.array(Phq);
      Matrix.print(Phqm);
      Matrix invJJt=Matrix.Multiply(Matrix.array(JJtar), Jtm);
      Matrix Qdotm = Matrix.Multiply(invJJt, Phqm);
      Qdotm = Matrix.Multiply(Qdotm,-1); //<>//
      float[][] Qdot = Qdotm.array;
      q1=q1+kN*Qdot[0][0];
  
      q2=q2+kN*Qdot[1][0];
  
      q3=q3+kN*Qdot[2][0];
  
      q4=q4+kN*Qdot[3][0];
  
      q5=q5+kN*Qdot[4][0];
  
      q6=q6+kN*Qdot[5][0];
      float[] qqq=new float[6];
      qqq[0]=q1;
      qqq[1]=q2;
      qqq[2]=q3;
      qqq[3]=q4;
      qqq[4]=q5;
      qqq[5]=q6;
      return qqq; 
    }
    public float[][] assignOrient(float alpha, float beta, float gamma) {
      float[][] R = new float[3][3];
      R[0][0]=cos(beta)*cos(gamma);
      R[0][1]=cos(gamma)*sin(alpha)*sin(beta) - cos(alpha)*sin(gamma);
      R[0][2]=sin(alpha)*sin(gamma) + cos(alpha)*cos(gamma)*sin(beta);
      R[1][0]=cos(beta)*sin(gamma);
      R[1][1]=cos(alpha)*cos(gamma) + sin(alpha)*sin(beta)*sin(gamma);
      R[1][2]=cos(alpha)*sin(beta)*sin(gamma) - cos(gamma)*sin(alpha);
      R[2][0]=-sin(beta);
      R[2][1]=cos(beta)*sin(alpha);
      R[2][2]=cos(alpha)*cos(beta);
      return R;
    }
    public float[][] transpose(float [][] matrix) {
      float[][] temp = new float[matrix[0].length][matrix.length];
      for (int i = 0; i < matrix.length; i++) {
        for (int j = 0; j < matrix[i].length; j++) {
          temp[j][i] = matrix[i][j];
        }
      }
      return temp;
    }
    void getCofactor(float A[][], float temp[][], int p, int q, int n)
    {
      int i = 0, j = 0;
  
      // Looping for each element of the matrix
      for (int row = 0; row < n; row++)
      {
        for (int col = 0; col < n; col++)
        {
          // Copying into temporary matrix only those element
          // which are not in given row and column
          if (row != p && col != q)
          {
            temp[i][j++] = A[row][col];
  
            // Row is filled, so increase row index and
            // reset col index
            if (j == n - 1)
            {
              j = 0;
              i++;
            }
          }
        }
      }
    }
    public float determinant(float A[][], int n)
    {
      int D = 0; // Initialize result
  
      // Base case : if matrix contains single element
      if (n == 1)
        return A[0][0];
  
      float [][]temp = new float[N][N]; // To store cofactors
  
      int sign = 1; // To store sign multiplier
  
      // Iterate for each element of first row
      for (int f = 0; f < n; f++)
      {
        // Getting Cofactor of A[0][f]
        getCofactor(A, temp, 0, f, n);
        D += sign * A[0][f] * determinant(temp, n - 1);
  
        // terms are to be added with alternate sign
        sign = -sign;
      }
  
      return D;
    }
    void adjoint(float A[][], float [][]adj)
    {
      if (N == 1)
      {
        adj[0][0] = 1;
        return;
      }
  
      // temp is used to store cofactors of A[][]
      int sign = 1;
      float [][]temp = new float[N][N];
  
      for (int i = 0; i < N; i++)
      {
        for (int j = 0; j < N; j++)
        {
          // Get cofactor of A[i][j]
          getCofactor(A, temp, i, j, N);
  
          // sign of adj[j][i] positive if sum of row
          // and column indexes is even.
          sign = ((i + j) % 2 == 0)? 1: -1;
  
          // Interchanging rows and columns to get the
          // transpose of the cofactor matrix
          adj[j][i] = (sign)*(determinant(temp, N-1));
        }
      }
    }
    public float[][] inverse(float A[][], float [][]inverse)
    {
      // Find determinant of A[][]
      float det = determinant(A, N);
      if (det == 0)
      {
        System.out.print("Singular matrix, can't find its inverse");
        float[][] nullf = new float[6][6];
        return nullf;
      }
      else{
      // Find adjoint
      float [][]adj = new float[N][N];
      adjoint(A, adj);
  
      // Find Inverse using formula "inverse(A) = adj(A)/det(A)"
      for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
          inverse[i][j] = adj[i][j]/(float)det;
  
      return inverse;
      }
    }
  }
