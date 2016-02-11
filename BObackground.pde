// librairies
import processing.pdf.*;
import gifAnimation.*;

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


int exportCount; // identifiant de la sauvegarde
int iterationCount = 0;

PShape octogoneSvg; // svg de l’octogone

// couleurs
color blue = color(0,0,255);
color red = color(255,0,0);

GifMaker gifExport;

// classe
class Octogone{
  
  int iteration = 0; // iteration du polygone
  PVector position; // position de la forme
  PVector translation; // vecteur de déplacement de la forme
  PVector acceleration; // vecteur d’accéleration de la forme
  
  Octogone(){ // constructeur de la class Octogone
    // initie la position de l’octogone au hasard sur la feuille
    position = new PVector(random(PAPER_WIDTH),random(PAPER_HEIGHT));
    translation = new PVector(1,0);
    translation.rotate(random(TWO_PI)); // tourne le vecteur dans n’importe quelle direction
    acceleration = new PVector(random(.3,.6),0);
    translation.rotate(random(TWO_PI)); // tourne le vecteur dans n’importe quelle direction
    println(position);
  }
  
  float getX(){
    return position.x;
  }
  float getY(){
    return position.y;
  }
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
}

// instancie la liste des octogones
ArrayList<Octogone> octogones = new ArrayList<Octogone>();

void setup(){ // démarrage 
  randomSeed((long)SEED);
  // charge le SVG
  octogoneSvg = loadShape("octogone.svg");
  // ouvre une fenetre
  size(330,230);
  // et la redimentionne
  surface.setSize(PAPER_WIDTH,PAPER_HEIGHT);
  //
  for(int i=0; i<OCTOGONE_COUNT; i++){
    octogones.add(new Octogone());
  }
  //
  if(RECORD_GIF || RECORD_PDF){
    // incrémente un nouvel enregistrement
    JSONObject exportCountJSON;
    try{
      exportCountJSON = loadJSONObject("exports/count.json");
      exportCount = exportCountJSON.getInt("export");
    }catch(NullPointerException err){
      exportCountJSON = new JSONObject();
      exportCount = 0;
    }
    exportCountJSON.setInt("export",exportCount+1);
    saveJSONObject(exportCountJSON,"exports/count.json");
    print(exportCount);
  }
  //
  background(255);
  if(RECORD_GIF){ // si on enregistre un GIF
    gifExport = new GifMaker(this, "exports/"+exportCount+"/demo.gif"); // créé un fichier GIF
    gifExport.setRepeat(0); // fait une boucle sans fin
  }
}

void draw(){ // dessin
println("draw");
  if(CLEAN_EACH_FRAME){
  // on efface l’arrière plan
  background(255);
  }
  //
  fill(255,3);
  noStroke();
  rect(0,0,width,height);
  if(RECORD_PDF){
    beginRecord(PDF,"exports/"+exportCount+"/"+iterationCount+".pdf");
  }
  //
  ellipseMode(CENTER);
  // boucle pour tous les octogones
  for(Octogone o : octogones){
    pushMatrix();
    //
    o.Next(); // on bouge l’octogone
    ///
    // on se déplace en fonction de la position
    translate(o.getX(),o.getY());
    // on dessine l'octogone
    shape(octogoneSvg,-octogoneSvg.width/2,-octogoneSvg.height/2);
    //
    if(SHOW_DEBUG){
      stroke(red);
      int DEBUG_SCALE = 10;
      line(0,0,o.translation.x*DEBUG_SCALE,o.translation.y*DEBUG_SCALE);
      stroke(blue);
      DEBUG_SCALE = 30;
      line(0,0,o.acceleration.x*DEBUG_SCALE,o.acceleration.y*DEBUG_SCALE);
    }
    popMatrix();
  }
  //
  if(RECORD_PDF){
    endRecord();
  }
  //
  if(RECORD_GIF){
    gifExport.setDelay(1);
    gifExport.addFrame();
  }
  //
  iterationCount++;
  //
  if(iterationCount>PAGE_COUNT){
    if(RECORD_GIF){
      gifExport.finish();
    }
    if(EXIT_WHEN_FINISH){
      exit();
    }else{
      noLoop();
    }
  }
}