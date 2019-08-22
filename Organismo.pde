class Organismo {
  Cromosoma[] cromosomas = new Cromosoma[4];
  Enmascarador m;
  PImage[] mascaras;

  boolean[][] herencia = new boolean[4][6];
  Organismo(String nombre) {
    crearMascaras(nombre);
    for (int i=0; i<cromosomas.length; i++) {
      cromosomas[i] = new Cromosoma(mascaras[i]);
    }
  }

  Organismo(Organismo p1, Organismo p2) {
    for (int i=0; i<cromosomas.length; i++) {
      cromosomas[i] = new Cromosoma(p1.cromosomas[i].genes, p2.cromosomas[i].genes);
      herencia[i] = cromosomas[i].herencia;
    }
  }

  Organismo(Organismo p1, Organismo p2, int[][]forzado) {
    for (int i=0; i<cromosomas.length; i++) {
      cromosomas[i] = new Cromosoma(p1.cromosomas[i].genes, p2.cromosomas[i].genes, forzado[i]);
      herencia[i] = cromosomas[i].herencia;
    }
  }

  void dibujar(float x, float y, float w, float h) {
    for (int i=0; i<cromosomas.length; i++) {
      image(cromosomas[i].getEnte(), x, y, w, h);
    }
  }

  void crearMascaras(String nombre) {
    m = new Enmascarador(nombre);
    mascaras = new PImage[4]; 
    PImage[] ms = m.getMascaras();
    PImage i = loadImage(nombre);
    mascaras[0] = loadImage(nombre);
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