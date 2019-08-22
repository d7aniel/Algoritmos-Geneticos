class Cromosoma {
  PGraphics g;
  float[] bri = new float[3];
  int[] hue = new int[256];
  int[] sat = new int[256];
  int ancho = 0;
  int alto = 0;
  float[] mapaTonalidad;
  float[] mapaSaturacion;
  float[] mapaClaveTonal;
  float[] mapaAlphaMascara;

  ArrayList genes;
  Cromosoma(String nombre) {
    PImage img =  loadImage(nombre);
    ancho = img.width;
    alto = img.height;
    g = createGraphics(ancho, alto);
    mapaTonalidad =new float[ancho*alto];
    mapaSaturacion =new float[ancho*alto];
    mapaClaveTonal =new float[ancho*alto];
    mapaAlphaMascara = new float[ancho*alto];
    genes =  new ArrayList();
    genes.add(ancho);
    genes.add(alto);
    calcularHistogramas(img);
    genes.add(hue);
    genes.add(sat);
    genes.add(bri);
    genes.add(mapaTonalidad);
    genes.add(mapaSaturacion);
    genes.add(mapaClaveTonal);
    genes.add(mapaAlphaMascara);
  }

  Cromosoma(PImage img_) {
    PImage img =  img_;
    ancho = img.width;
    alto = img.height;
    g = createGraphics(ancho, alto);
    mapaTonalidad =new float[ancho*alto];
    mapaSaturacion =new float[ancho*alto];
    mapaClaveTonal =new float[ancho*alto];
    mapaAlphaMascara = new float[ancho*alto];
    genes =  new ArrayList();
    genes.add(ancho);
    genes.add(alto);
    calcularHistogramas(img);
    genes.add(hue);
    genes.add(sat);
    genes.add(bri);
    genes.add(mapaTonalidad);
    genes.add(mapaSaturacion);
    genes.add(mapaClaveTonal);
    genes.add(mapaAlphaMascara);
  }
  boolean[] herencia = new boolean[6];
  Cromosoma(ArrayList genesA, ArrayList genesB) {
    genes = mezclar(genesA, genesB);
    crearDesdeGenes();
  }


  Cromosoma(ArrayList genesA, ArrayList genesB, int[] forzado) {
    genes = mezclar(genesA, genesB, forzado);
    crearDesdeGenes();
  }

  void crearDesdeGenes() {
    ancho = (int)genes.get(0);
    alto = (int)genes.get(1);
    hue = (int[])genes.get(2);
    sat = (int[])genes.get(3);
    bri = (float[])genes.get(4);
    mapaTonalidad = (float[])genes.get(5);
    mapaSaturacion = (float[])genes.get(6);
    mapaClaveTonal = (float[])genes.get(7);
    mapaAlphaMascara = (float[])genes.get(8);
    g = createGraphics(ancho, alto);
  }

  ArrayList mezclar(ArrayList g1, ArrayList g2, int[] forzado) {
    ArrayList ng = new ArrayList();
    for (int i=0; i<g1.size(); i++) {
      if (forzado[i] == 0) {
        ng.add(g1.get(i));
        herencia[constrain(i-2, 0, 5)] = true;
      } else {
        ng.add(g2.get(i));
        herencia[constrain(i-2, 0, 5)] = false;
      }
    }
    return ng;
  }

  ArrayList mezclar(ArrayList g1, ArrayList g2) {
    int[] forzado = new int[g1.size()];
    for (int i=0; i<forzado.length; i++) {
      forzado[i] = random(100)<50?1:0;
    }
    return mezclar(g1, g2, forzado);
  }

  void calcularHistogramas(PImage img) {
    float brilloMax = -1;
    float brilloMin = 100000;
    float brilloPromedio = 0;
    float[] histHue = new float[256];
    float[] histSat = new float[256];    
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        float brillo = brightness(img.get(i, j));
        brilloPromedio+=brillo/255.0; 
        brilloMax = brilloMax<brillo?brillo:brilloMax;
        brilloMin = brilloMin>brillo?brillo:brilloMin;
        int hue = int(hue(img.get(i, j)));
        histHue[hue]++;
        int saturation = int(saturation(img.get(i, j)));
        histSat[saturation]++;
      }
    }
    brilloPromedio/=(img.width*img.height);
    brilloPromedio*=255.0;

    bri[0] = brilloMin;
    bri[1] = brilloPromedio;
    bri[2] = brilloMax;

    histHue = sinRepeticiones(histHue);
    histSat = sinRepeticiones(histSat);

    float[] hueOrdenados = sort(histHue);
    float[] satOrdenados = sort(histSat);

    hueOrdenados = sinCeros(hueOrdenados);
    satOrdenados = sinCeros(satOrdenados);

    hue = getArregloDeColoresOrdenado(histHue, hueOrdenados);
    sat = getArregloDeColoresOrdenado(histSat, satOrdenados);

    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        int indice = j*g.width+i;
        int brillo = int(brightness(img.get(i, j)));       
        int tono = int(hue(img.get(i, j)));      
        int saturacion = int(saturation(img.get(i, j)));   
        float alpha = alpha(img.get(i, j));   
        mapaTonalidad[indice] = masCercado(hue, tono);
        mapaSaturacion[indice] = masCercado(sat, saturacion);
        mapaClaveTonal[indice] = brilloSegunPuntos(brillo);
        mapaAlphaMascara[indice] = alpha;
      }
    }
  }

  float brilloSegunPuntos(float brillo) {
    float b = brillo==bri[1]?0:brillo>bri[1]?map(brillo, bri[1], bri[2], 0, 1):map(brillo, bri[1], bri[0], 0, -1);
    return b;
  }

  float masCercado(int[] arreglo, int v) {
    float posicion = -1;
    float masCercano = 10000000; 
    for (int c = 0; c < arreglo.length; c++) {
      if (abs(arreglo[c]-v)<masCercano) {
        posicion = c;
        masCercano = abs(arreglo[c]-v);
        if (arreglo[c] == v) {
          break;
        }
      }
    }
    return posicion/(arreglo.length-1);
  }

  PImage getEnte() {
    colorMode(HSB);
    g.beginDraw();
    g.loadPixels();
    for (int i = 0; i < g.width; i++) {
      for (int j = 0; j < g.height; j++) {
        int indice = j*g.width+i;
        float h = getValorMapeado(hue, mapaTonalidad[indice]);
        float s = getValorMapeado(sat, mapaSaturacion[indice]);
        float b = getBrillo(mapaClaveTonal[indice]);
        float a = mapaAlphaMascara[indice];
        g.pixels[indice] = color(h, s, b, a);
      }
    }
    g.updatePixels();
    g.endDraw();
    return g;
  }

  PImage getMapaSat(boolean normalizado) {
    colorMode(HSB);
    g.beginDraw();
    g.loadPixels();
    // println(hue.length);
    for (int i = 0; i < g.width; i++) {
      for (int j = 0; j < g.height; j++) {
        int indice = j*g.width+i;
        if (normalizado)
          g.pixels[indice] = color(mapaSaturacion[indice]*255);
        else
          g.pixels[indice] = color(getValorMapeado(hue, mapaSaturacion[indice]));
      }
    }
    g.updatePixels();
    g.endDraw();   
    return g;
  }

  PImage getMapaHue(boolean normalizado) {
    colorMode(HSB);
    g.beginDraw();
    g.loadPixels();
    // println(hue.length);
    for (int i = 0; i < g.width; i++) {
      for (int j = 0; j < g.height; j++) {
        int indice = j*g.width+i;
        if (normalizado)
          g.pixels[indice] = color(mapaTonalidad[indice]*255);
        else
          g.pixels[indice] = color(getValorMapeado(hue, mapaTonalidad[indice]));
      }
    }
    g.updatePixels();
    g.endDraw();   
    return g;
  }

  PImage getMapaBri(boolean normalizado) {
    colorMode(HSB);
    g.beginDraw();
    g.loadPixels();
    //(hue.length);
    for (int i = 0; i < g.width; i++) {
      for (int j = 0; j < g.height; j++) {
        int indice = j*g.width+i;

        float br = mapaClaveTonal[indice];
        float c = 0;
        if (normalizado) 
          c = br==0?127:br>0?map(br, 0, 1, 127, 255):map(br, 0, -1, 127, 0);
        else
          c = getBrillo(br);
        g.pixels[indice] = color(c);
      }
    }
    g.updatePixels();
    g.endDraw();   
    return g;
  }

  int[] getArregloDeColoresOrdenado(float[] desordenado, float[]ordenado) {
    int[] arreglo = new int[ordenado.length];
    for (int c = 0; c < ordenado.length; c++) {
      for (int i = 0; i < 256; i++) {
        if (desordenado[i] == ordenado[c]) {
          arreglo[c] = i;
          break;
        }
      }
    }
    return arreglo;
  }

  float[] sinRepeticiones(float[] l) {
    ArrayList<Integer> rev = new ArrayList<Integer>();
    for (int i=0; i<l.length; i++) {
      if (l[i] == max(l)) {
        rev.add(i);
        break;
      }
    }
    int hack = 10000000;
    while (rev.size()>0 && hack >0) { 
      for (int j=0; j<l.length; j++) {
        if (l[j] == l[rev.get(0)] && j != rev.get(0)) {
          l[j]--;
          rev.add(j);
        }
      }
      if (l[rev.get(0)]>0 && l[rev.get(0)]!=min(l) && rev.size()==1) {
        float masCercano = 1000000000;
        int indiceMasCercano = -1;
        for (int j=0; j<l.length; j++) {      
          if (l[rev.get(0)]-l[j]<masCercano && l[rev.get(0)]>l[j]) {
            masCercano = l[rev.get(0)]-l[j];
            indiceMasCercano = j;
          }
        }
        rev.add(indiceMasCercano);
      }
      rev.remove(0);
      if (l[rev.get(0)]==0) {
        rev.clear();
      }
      hack--;
    }
    return l;
  }

  float getValorMapeado(int[]serie, float cual) {
    float valor =  serie[round(cual*(serie.length-1))];
    return valor;
  }

  float getBrillo(float cual) {
    return cual==0?bri[1]:cual>0?map(cual, 0, 1, bri[1], bri[2]):map(cual, 0, -1, bri[1], bri[0]);
  }

  float[] sinCeros(float[] arreglo) {
    int largo = 0;
    for (int i=0; i<arreglo.length; i++) {
      if (arreglo[i] != 0)
        largo++;
    }
    float [] arregloNuevo = new float[largo];
    for (int i=0, j=0; i<arreglo.length; i++) {
      if (arreglo[i] != 0) {
        arregloNuevo[j] = arreglo[i];
        j++;
      }
    }
    return arregloNuevo;
  }
}