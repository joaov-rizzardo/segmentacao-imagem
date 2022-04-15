void setup() {
  size(800, 800);
  background(255);
  noLoop();
}

void draw() {
  PImage img = loadImage("img.png");
  PImage aux = createImage(img.width, img.height, RGB);

  // GERA O HISTOGRAMA DA IMAGEM
  genHist(img);

  aux = grayScale(img, aux);
  aux = averageFilter(img, aux);
  aux = bright(img, aux);
  aux = thresholdingFilter(img, aux);
  getDataInfo(aux);
  aux = clippImage(img, aux);
}

void getDataInfo(PImage aux) {
  PImage groundTruth = loadImage("groundtruth.jpg");

  int positive = 0;
  int falseNegative = 0;
  int falsePositive = 0;
  int total = 0;
  for (int y = 0; y < aux.height; y++) {
    for (int x = 0; x < aux.width; x++) {
      int pos = y * aux.width + x;
      total++;

      if (red(groundTruth.pixels[pos]) > 200) {
        groundTruth.pixels[pos] = color(255);
      } else {
        groundTruth.pixels[pos] = color(0);
      }

      if (red(aux.pixels[pos]) == red(groundTruth.pixels[pos])) {
        positive++;
      }

      if (red(aux.pixels[pos]) == 255 && red(groundTruth.pixels[pos]) == 0) {
        falsePositive++;
      }

      if (red(aux.pixels[pos]) == 0 && red(groundTruth.pixels[pos]) == 255) {
        falseNegative++;
      }
    }
  }

  println("Total");
  println(total);

  println("Positivo");
  println(positive);

  println("Falso Positivo");
  println(falsePositive);

  println("Falso Negativo");
  println(falseNegative);
}
// APLICANDO A COR NATURAL DA IMAGEM
PImage clippImage(PImage img, PImage aux) {
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {

      int pos = y * img.width + x;
      if (red(aux.pixels[pos]) == 255) {
        aux.pixels[pos] = color(img.pixels[pos]);
      } else {
        aux.pixels[pos] = color(0);
      }
    }
  }

  aux.save("image.jpg");

  return aux;
}
// BRILHO
PImage bright(PImage img, PImage aux) {
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y * img.width + x;
      float valor = red(aux.pixels[pos])*1.5;
      if (valor > 255) valor = 255;
      else if (valor < 0) valor = 0;
      aux.pixels[pos] = color(valor);
    }
  }

  aux.save("bright.jpg");

  return aux;
}
// ESCALA DE CINZA
PImage grayScale(PImage img, PImage aux) {
  for (int y = 0; y < img.height; y++) {
    for (int x =0; x < img.width; x++) {
      int pos = y*img.width + x;

      //float media = (red(img.pixels[pos]) + green(img.pixels[pos]) + blue(img.pixels[pos]))/3;
      //aux.pixels[pos] = color(media);

      aux.pixels[pos] = color(blue(img.pixels[pos]));
    }
  }

  aux.save("grayScale.jpg");

  return aux;
}

// FILTRO DE LIMIARIZAÇÃO
PImage thresholdingFilter(PImage img, PImage aux) {
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      if (blue(aux.pixels[pos]) > 10 ) {
        aux.pixels[pos] = color(255);
      } else {
        aux.pixels[pos] = color(0);
      }
      
      if(x > aux.width - 200 && y < 200){
          aux.pixels[pos] = color(0);
      }

    }
  }

  aux.save("thresholdingFilter.jpg");

  return aux;
}

// FILTRO DE MÉDIA
PImage averageFilter(PImage img, PImage aux) {
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      int jan = 2;
      int qtde = 0;
      float media = 0;

      for (int i = jan*(-1); i <= jan; i++) {
        for (int j = jan*(-1); j<=jan; j++) {
          int nx = x + j;
          int ny = y + i;

          if (ny >= 0 && ny < aux.height && nx >= 0 && nx < aux.width) {
            int posAux = ny*aux.width+ nx;
            media += red(aux.pixels[posAux]);
            qtde++;
          }
        }
      }

      media = media / qtde;
      aux.pixels[pos] = color(media);
    }
  }

  aux.save("averageFilter.jpg");

  return aux;
}

void genHist(PImage img) {

  // DECLARANDO OS VETORES QUE IRÃO RECEBER AS CORES
  int[] histRed = new int[256];
  int[] histGreen = new int[256];
  int[] histBlue = new int[256];

  // ZERA TODOS OS INDICES DOS VETORES
  for (int i = 0; i < 256; i++) {
    histRed[i] = histGreen[i] = histBlue[i] = 0;
  }

  // PERCORRE TODOS OS INDICES DA IMAGEM
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y * img.width + x;

      int valueRed = int(red(img.pixels[pos]));
      histRed[valueRed]++;

      int valueGreen = int(green(img.pixels[pos]));
      histGreen[valueGreen]++;

      int valueBlue = int(blue(img.pixels[pos]));
      histBlue[valueBlue]++;
    }
  }

  // PEGA OS VALORES MÁXIMOS DE CADA VETOR
  int histMaxRed = max(histRed);
  int histMaxGreen = max(histGreen);
  int histMaxBlue = max(histBlue);

  int[] histMaxRGB = {histMaxRed, histMaxGreen, histMaxBlue};
  int histMax = max(histMaxRGB);

  for (int i = 0; i < 256; i++) {
    int y = int(map(histRed[i], 0, histMax, 0, 600));

    stroke(255, 0, 0);
    line(i, 600, i, 600-y);

    y = int(map(histGreen[i], 0, histMax, 0, 600));

    stroke(0, 255, 0);
    line(i+260, 600, i+260, 600-y);

    y = int(map(histBlue[i], 0, histMax, 0, 600));

    stroke(0, 0, 255);
    line(i+520, 600, i+520, 600-y);
  }
}
