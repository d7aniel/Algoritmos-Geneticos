class Organismo {
  Cromosoma[] cromosomas = new Cromosoma[4];
  Enmascarador m;
  PImage[] mascaras;
  boolean[][] herencia = new boolean[4][6];
  float aptitud = 0;
  PGraphics graf;
  Organismo(PImage img) {
    graf = createGraphics(640, 480, P2D);
    crearMascaras(img);
    for (int i=0; i<cromosomas.length; i++) {
      cromosomas[i] = new Cromosoma(mascaras[i]);
    }
    dibujar();
  }

  Organismo(String nombre) {
    graf = createGraphics(640, 480, P2D);
    PImage img = loadImage(nombre);
    crearMascaras(img);
    for (int i=0; i<cromosomas.length; i++) {
      cromosomas[i] = new Cromosoma(mascaras[i]);
    }
    dibujar();
  }

  Organismo(Organismo p1, Organismo p2) {
    graf = createGraphics(640, 480, P2D);
    for (int i=0; i<cromosomas.length; i++) {
      cromosomas[i] = new Cromosoma(p1.cromosomas[i].genes, p2.cromosomas[i].genes);
      herencia[i] = cromosomas[i].herencia;
    }
    dibujar();
  }

  void dibujar(float x, float y, int w) {
    pushStyle();
    imageMode(CORNER);
    image(graf, x, y, w, alto(graf, w));
    setearAmptitud(x, y, w, alto(graf, w));
    popStyle();
  }
  void dibujar() {
    graf.beginDraw();
    graf.pushStyle();
    for (int i=0; i<cromosomas.length; i++) {
      graf.image(cromosomas[i].getEnte(), 0, 0);
    }  
    graf.popStyle();
    graf.endDraw();
  }

  void dibujar(PGraphics g) {
    PImage img = null;
    for (int i=0; i<cromosomas.length; i++) {
      img = cromosomas[i].getEnte();
      g.image(img, 0, 0);
    }
  }

  void setearAmptitud(float x, float y, float w, float h) {
    pushStyle();
    strokeWeight(1);
    fill(255);
    stroke(255);

    if (mouseX>x && mouseX<x+w && mouseY>y+h-40 && mouseY<y+h) {
      stroke(0, 255, 255);
      if (mousePressed) {
        aptitud = map(mouseX, x+10, x+w-10, 0, 1);
      }
    } else  if (dist(mouseX, mouseY, x+w-20, y+20)<10) {
      fill(0, 255, 255);
      if (mousePressed) {
        guardar();
      }
    }

    float t = 5;
    line(x+w-20, y+20-t, x+w-20, y+20);
    triangle(x+w-20+t, y+20, x+w-20-t, y+20, x+w-20, y+20+t);
    line(x+10, y+h-20, x+w-10, y+h-20);
    float xApt = map(aptitud, 0, 1, x+10, x+w-10);
    fill(255);
    ellipse(xApt, y+h-20, 5, 5);
    popStyle();
  }

  void guardar() {
    PImage i1 = cromosomas[0].getEnte();
    PGraphics g = createGraphics(i1.width, i1.height);
    g.beginDraw();
    dibujar(g);
    g.endDraw();
    g.save("capturas/"+nf(frameCount, 5)+".png");
  }

  void crearMascaras(PImage img) {
    m = new Enmascarador(img);
    mascaras = new PImage[4]; 
    PImage[] ms = m.getMascaras();
    PImage i = img;
    mascaras[0] = img.copy();
    i.mask(ms[0]);
    mascaras[1] = i.copy();
    i.mask(ms[1]);
    mascaras[2] = i.copy();
    i.mask(ms[2]);
    mascaras[3] = i.copy();
  }

  String[] caracteristicas = {"Mapa Tonalidad", "Mapa Saturacion", "Mapa Clave Tonal", "Lista Tonalidad", "Lista Saturacion", "Puntos Clave Tonal"};
  void herencia(float x, float y, boolean v) {
    pushStyle();
    for (int i=0; i<cromosomas.length; i++) { 
      fill(255);
      text("Cromosoma "+i, x, 75*i+y);
      for (int j=0; j<caracteristicas.length; j++) { 
        colorMode(RGB);
        color c = v==herencia[i][j]?color(0):color(0, 255, 0) ;
        fill(c);        
        text("  "+caracteristicas[j], x, 75*i+(j+1)*10+y);
      }
    }
    popStyle();
  }
}