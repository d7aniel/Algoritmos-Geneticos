
int creacion;
OpenCV opencv;
int[] forzada = {0, 0, 0, 0, 0, 1, 1, 1, 1};
int[][] forzadoOrganismo = {
  {0, 0, 0, 0, 0, 1, 1, 1, 1}, 
  {0, 0, 0, 0, 0, 1, 1, 1, 1}, 
  {0, 0, 0, 0, 0, 1, 1, 1, 1}, 
  {0, 0, 0, 0, 0, 1, 1, 1, 1}};
void setup() {  
  size(852, 638);
  opencv = new OpenCV(this, 640, 480);


  /* image(oH.cromosomaD.getEnte(), 426, 319, 426, 319);*/


  /*String aStr = nf(int(random(1, 29)), 5)+".png";
   String bStr = nf(int(random(1, 29)), 5)+".png";
   
   Cromosoma p1 = new Cromosoma(aStr);
   Cromosoma p2 = new Cromosoma(bStr);
   Cromosoma h = new Cromosoma(p1.genes, p2.genes);*/
}
void draw() {
}
void keyPressed() {
  background(0);
  crearOrganismoForzado("00026","00010");
}

void crearOrganismo() {
  Organismo op2;
  Organismo op1;
  Organismo oH;
  String aStr = nf(int(random(1, 29)), 5)+".png";
  String bStr = nf(int(random(1, 29)), 5)+".png";
  op1 = new Organismo(aStr);
  op2 = new Organismo(bStr);
  oH = new Organismo(op1, op2);

  op1.dibujar( 0, 0, 426, 319);
  op2.dibujar( 426, 0, 426, 319);
  oH.dibujar( 213, 319, 426, 319);
  oH.herencia(20, 330, true);
  oH.herencia(659, 330, false);

  saveFrame("captura"+frameCount+".png");
}

void crearOrganismoForzado(String a1, String a2) {
  Organismo op2;
  Organismo op1;
  Organismo oH;
  String aStr = a1==null?nf(int(random(1, 29)), 5)+".png":a1+".png";
  String bStr = a2==null?nf(int(random(1, 29)), 5)+".png":a2+".png";
  op1 = new Organismo(aStr);
  op2 = new Organismo(bStr);
  oH = new Organismo(op1, op2, forzadoOrganismo);

  op1.dibujar( 0, 0, 426, 319);
  op2.dibujar( 426, 0, 426, 319);
  oH.dibujar( 213, 319, 426, 319);
  oH.herencia(20, 330, true);
  oH.herencia(659, 330, false);

   saveFrame("captura"+frameCount+".png");
}


void verMascaras() {
  String aStr = nf(int(random(1, 29)), 5)+".png";
  Organismo o = new Organismo("00009.png");
  image(o.cromosomas[0].getEnte(), 0, 0, 426, 319);
  image(o.cromosomas[1].getEnte(), 426, 0, 426, 319);
  image(o.cromosomas[2].getEnte(), 0, 319, 426, 319);
  image(o.cromosomas[3].getEnte(), 426, 319, 426, 319);

  fill(0);
  rect(20, 20, 100, 31);
  rect(446, 20, 70, 31);
  rect(20, 339, 70, 31);
  rect(446, 339, 70, 31);
  fill(255);
  text("Imagen Total", 30, 30, 426, 319);
  text("Forma 1", 456, 30, 426, 319);
  text("Forma 2", 30, 349, 426, 319);
  text("Forma 3", 456, 349, 426, 319);
  saveFrame("formas.png");
}

void organismos() {
  String aStr = nf(int(random(1, 29)), 5)+".png";
  Organismo o = new Organismo(aStr);
  image(o.mascaras[0], 0, 0, 426, 319);
  image(o.mascaras[1], 426, 0, 426, 319);
  image(o.mascaras[2], 0, 319, 426, 319);
  image(o.mascaras[3], 426, 319, 426, 319);
}