class AlgoritmoGenetico {
  int poblacionMaxima;
  float indiceDeMutacion;
  Poblacion poblacion;
  boolean inicializado =  false;
  boolean actualizarPrimeraVez = false;
  AlgoritmoGenetico(int pobl) {
    poblacionMaxima = pobl;
    poblacion = new Poblacion();
  }

  void inicializar() {
    if (!inicializado) {
      poblacion.inicializar(poblacionMaxima);
      inicializado = poblacion.inicializado;
    }
    if (!actualizarPrimeraVez && inicializado) {
      actualizarPrimeraVez = true;
     
    }
  }

  void actualizar() {
    poblacion.crearGeneracion();
  }

  void mostrar() {
    poblacion.mostrar();
  }
}