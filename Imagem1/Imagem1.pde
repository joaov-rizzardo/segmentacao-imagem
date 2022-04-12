void setup() {
  size(1914, 903);
  background(255);
  noLoop();
}

void draw() {
  PImage img = loadImage("mozis.png");
  PImage aux = createImage(img.width, img.height, RGB);

  // GERA O HISTOGRAMA DA IMAGEM
  //genHist(img);

  //aux = averageFilter(img, aux);
  thresholdingFilter(img, aux);
}

// FILTRO DE LIMIARIZAÇÃO
void thresholdingFilter(PImage img, PImage aux) {
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = y*img.width + x;
      if (blue(aux.pixels[pos]) > 120 && y < 550) {
        aux.pixels[pos] = color(255);
      } else {
        aux.pixels[pos] = color(0);
      }
    }
  }

  aux.save("thresholdingFilter.jpg");
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
            media += red(img.pixels[posAux]);
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
