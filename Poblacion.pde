class Poblacion {
  int poblacionMaxima;
  Organismo[] poblacion;
  int generaciones;  
  boolean terminado;
  int puntajePerfecto;

  int indiceDelMejor;
  float aptitudDelMejor;
  float aptitudTotal;

  Poblacion() {
  }

  int cual = 0;
  boolean inicializado = false;
  void inicializar(int pm) {
    pushStyle();
    textAlign(CENTER, CENTER);
    background(0);
    text(nf(float(cual)/fuentes.length*100.0, 3, 2)+"%", width/2, height/2);
    popStyle();
    if (cual<fuentes.length) {
      if (poblacion == null && poblacionMaxima == 0) {
        poblacionMaxima = pm;
        poblacion = new Organismo[pm];
      }
      poblacion[cual] = new Organismo(fuentes[cual]);
      indiceDelMejor = 0;
      aptitudDelMejor = 0;
      terminado=false;
      generaciones=0;
      puntajePerfecto = 1;
      cual++;
    } else if (!inicializado) {
      inicializado = true;
    }
  }

  void mostrar() {
    for (int i=0; i<poblacion.length; i++) {
      int y = i%5;
      int x = i/5;
      poblacion[i].dibujar(x*width/6.0, y*height/5.0, int(width/6.0));
      if (poblacion[i].aptitud>aptitudDelMejor) {
        aptitudDelMejor = poblacion[i].aptitud;
      }
    }
  } 

  Organismo getEltern() {
    int hack = 0;
    Organismo eltern = null;
    while (true && hack<10000) {
      int indice = floor(random(poblacion.length));
      eltern = poblacion[indice];
      float r = random(aptitudDelMejor);
      if (r<eltern.aptitud) {
        return eltern;
      }
      hack++;
    }
    return eltern;
  }

  void crearGeneracion() {
    Organismo[] poblacionTemp = new Organismo[poblacion.length];
    for (int i=0; i<poblacion.length; i++) {
      Organismo A = getEltern();
      Organismo B = getEltern();
      Organismo criatura = new Organismo(A, B);
      poblacionTemp[i] = criatura;
    }
    poblacion = poblacionTemp;
    generaciones++;
  }
}