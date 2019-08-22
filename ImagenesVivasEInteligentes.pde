OpenCV opencv;
PImage[] fuentes;
AlgoritmoGenetico aG;
void setup() {
   size(1280, 720, P2D);
  //fullScreen(P2D);
  opencv = new OpenCV(this, 640, 480);
  aG =  new AlgoritmoGenetico(30);
  fuentes = new PImage[30];
  for (int i=0; i<=29; i++) {
    fuentes[i] = loadImage("imagenesBase/"+nf(i, 5)+".png");
    fuentes[i].resize(640, 480);
  }
}

void draw() {
  if (!aG.actualizarPrimeraVez) {
    aG.inicializar();
  } else {
    background(0);
    aG.mostrar();
   /* saveFrame("seleccion.png");
    exit();*/
  }
  println(frameRate);
}

void keyPressed() {
  aG.actualizar();
}