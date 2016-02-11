# BO background

Sketch utilisé pour exporter des octogones, sur une double page.

## installation

Installer la librairie GifAnimation (pour exporter en GIF) :

- [github.com/01010101/GifAnimation](https://github.com/01010101/GifAnimation) pour Processing 3.x
- [github.com/extrapixel/gif-animation](https://github.com/extrapixel/gif-animation) pour Processing 2.x

## paramètres

Les paramètres sont en début de sketch

```
// paramètres
boolean SHOW_DEBUG = false;
boolean RECORD_GIF = true;
boolean RECORD_PDF = true;
boolean EXIT_WHEN_FINISH = false;
boolean CLEAN_EACH_FRAME = true;

float SEED = 10; // utilisé pour le random seed
// mettre 
// float SEED = random(10); // pour ignorer le random seed

int OCTOGONE_COUNT = 3; // nombre d’octogone
int PAGE_COUNT = 112; // nombre de doubles pages

int PAPER_SCALE = 3; // échelle de la page
int PAPER_WIDTH = 330*PAPER_SCALE; // largeur de la double page, en pixel
int PAPER_HEIGHT = 230*PAPER_SCALE; // hauteur de la double page, en pixel


```

## fonction `Next()`

C’est la fonction qui est executée à chaque nouvelle itération.

```
void Next(){ 
    // 
    // c’est ici qu’il faut faire varier …
    float aMag = acceleration.mag();
    acceleration.rotate(random(-PI,PI)/3);
    translation.add(acceleration);
    translation.div(sqrt(translation.mag()/random(2,3)));
    position.add(translation);
    position.x = (position.x+PAPER_WIDTH)%PAPER_WIDTH;
    position.y = (position.y+PAPER_HEIGHT)%PAPER_HEIGHT;
    //
    iteration++;
  }
```  
## export

L’export est fait dans le dossier `./exports/` avec un dossier à chaque nouvel export.

## démo gif

Avec les trajectoires. 
![with trails](demo-with-trails.gif)
Sans les trajectoires.
![without trails](demo-without-trails.gif)