void dibujarSaturacionYTonalidad(String srcimagen, String nombre) {
  Cromosoma p2 = new Cromosoma(srcimagen);
  background(0);
  image(p2.getEnte(), 0, 0);
  image(p2.getMapaSat(true), 640, 0);
  image(p2.getMapaHue(true), 0, 480);
  textSize(25);
  fill(0);
  rect(645, 20, 210, 40);
  rect(5, 500, 210, 40);

  fill(255);
  text("Mapa Saturacion", 650, 50);
  text("Mapa Tonalidad", 10, 530);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);


  text("Tonalidades", 640+320, 480+120);

  float ancho = 630.0/p2.hue.length;
  float alto = 30;
  noStroke();
  for (int i=0; i<p2.hue.length; i++) {
    float x = (640+5)+map(i, 0, p2.hue.length, ancho/2, 630.0-ancho/2);
    fill(p2.hue[i], 255, 255);
    rect(x, 480+180, ancho, alto);
  }
  fill(255);
  text("Saturaciones", 640+320, 480+240);
  ancho = 320.0/p2.sat.length;
  for (int i=0; i<p2.sat.length; i++) {
    float x = (640+5)+map(i, 0, p2.sat.length, ancho/2, 630.0-ancho/2);
    fill(p2.sat[i]);
    rect(x, 480+300, ancho, alto);
  }
  //image(h.getEnte(), 640, height-175);
  saveFrame(nombre);
}

void dibujarClaveTonal(String imagen, String nombre) {
  Cromosoma p1 = new Cromosoma(imagen);
  background(200, 50, 10);
  image(p1.getEnte(), 0, 0);
  image(p1.getMapaBri(false), 640, 0);
  image(p1.getMapaBri(true), 0, 480);
  textSize(25);
  fill(0);
  rect(645, 20, 230, 40);
  rect(5, 500, 390, 40);

  fill(255);
  text("Mapa Clave Tonal", 650, 50);
  text("Mapa Calve Tonal Normalizado", 10, 530);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  text("Clave normalizada", 640+320, 600);
  text("Clave de esta imagen", 640+320, 720);
  float t = 640;
  float d = abs(p1.bri[1]-p1.bri[0])+abs(p1.bri[1]-p1.bri[2]);
  float t1 = map(abs(p1.bri[1]-p1.bri[0]), 0, d, 0, 640);
  loadPixels();
  for (int i=645; i<width-5; i++) {
    for (int j=635; j<665; j++) {
      boolean antes = i - (645)<t1;
      float c = antes?map(i - (645), 0, t1, p1.bri[0], p1.bri[1]):map(i - (645), t1, 640, p1.bri[1], p1.bri[2]);
      float c2 = antes?map(i - (645), 0, t1, 0, 127):map(i - (645), t1, 640, 127, 255);
      int indice2 = i+(j+120)*width;
      pixels[indice2] = color(c);
      int indice = i+j*width;
      pixels[indice] = color(c2);
    }
  }

  updatePixels();
  saveFrame(nombre);
}


void crearMezcla() {
  String aStr = nf(int(random(1, 29)), 5)+".png";
  String bStr = nf(int(random(1, 29)), 5)+".png";

  Cromosoma p1 = new Cromosoma(aStr);
  Cromosoma p2 = new Cromosoma(bStr);
  Cromosoma h = new Cromosoma(p1.genes, p2.genes, forzada);

  background(0);
  fill(255);
  float x = 0;
  String tl = h.genes.get(2)==p1.genes.get(2)?"p1":"p2";
  x = h.genes.get(2)==p1.genes.get(2)?50:213+426+50;
  text("Tonalidad Rango:"+tl, x, 360);
  String sl = h.genes.get(3)==p1.genes.get(3)?"p1":"p2";
  x = h.genes.get(3)==p1.genes.get(3)?50:213+426+50;
  text("Saturacion Rango:"+sl, x, 380);
  String bl = h.genes.get(4)==p1.genes.get(4)?"p1":"p2";
  x = h.genes.get(4)==p1.genes.get(4)?50:213+426+50;
  text("Brillo Rango:"+bl, x, 400);
  String tm = h.genes.get(5)==p1.genes.get(5)?"p1":"p2";
  x = h.genes.get(5)==p1.genes.get(5)?50:213+426+50;
  text("Tonalidad Mapa:"+tm, x, 420);
  String sm = h.genes.get(6)==p1.genes.get(6)?"p1":"p2";
  x = h.genes.get(6)==p1.genes.get(6)?50:213+426+50;
  text("Saturacion Mapa:"+sm, x, 440);
  String bm = h.genes.get(7)==p1.genes.get(7)?"p1":"p2";
  x = h.genes.get(7)==p1.genes.get(7)?50:213+426+50;
  text("Clave Tonal Mapa:"+bm, x, 460);

  image(p1.getEnte(), 0, 0, 426, 319);
  image(p2.getEnte(), 426, 0, 426, 319);
  image(h.getEnte(), 213, 319, 426, 319);
}