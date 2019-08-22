import gab.opencv.*;
import java.awt.Rectangle;

class Enmascarador { 
  float contrast = 1;
  int thresholdBlockSize = 150;
  int thresholdConstant = 3;
  int blobSizeThreshold = 60;
  int blurSize = 1;
  ArrayList<Contour> contours;
  Enmascarador(String nombre) {
    PImage i = loadImage(nombre);
    filtrar(i);
  }

  void draw() {
  }

  void filtrar(PImage img) {
    opencv.loadImage(img);
    opencv.gray();
    opencv.contrast(contrast);
    if (thresholdBlockSize%2 == 0) thresholdBlockSize++;
    if (thresholdBlockSize < 3) thresholdBlockSize = 3;
    opencv.adaptiveThreshold(thresholdBlockSize, thresholdConstant);
    opencv.invert();
    opencv.dilate();
    opencv.erode();
    opencv.blur(blurSize);
    contours = opencv.findContours(true, true);
  }

  void displayContours() {
    int cant = min(contours.size(), 3);
    for (int i=0; i<contours.size(); i++) {
      Contour contour = contours.get(i);
      fill(random(255), random(255), random(255));
      noStroke();
      beginShape();
      for (PVector point : contour.getPoints()) {
        vertex(point.x, point.y);
      }
      endShape();
      /*noFill();
       stroke(0, 255, 0);
       strokeWeight(3);
       contour.draw();*/
    }
  }

  PImage[] getMascaras() {
    PImage[] mascaras = new PImage[3];
    PGraphics g;
    for (int i=0; i<3; i++) {
      Contour contour = contours.get(i%contours.size());
      g = createGraphics(opencv.width, opencv.height);
      g.beginDraw();
      g.background(0);
      g.fill(255);
      g.noStroke();
      g.beginShape();
      for (PVector point : contour.getPoints()) {
        g.vertex(point.x, point.y);
      }
      g.endShape();
      for (int j=(i+1); j<3; j++) {
        g.fill(0);
        Contour contourDiff = contours.get(j%contours.size());
        g.beginShape();
        for (PVector point : contourDiff.getPoints()) {
          g.vertex(point.x, point.y);
        }
        g.endShape();
      }
      g.endDraw();
      mascaras[i] = g;
    }
    return mascaras;
  }
}