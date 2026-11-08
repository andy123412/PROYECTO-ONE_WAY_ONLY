import ddf.minim.*;

class GestorAudio {
  Minim minim;
  
  AudioPlayer bgmNormal;
  AudioPlayer bgmCastillo;
  AudioPlayer ambienteRio; 
  
  AudioSample sfxEspada;
  AudioSample sfxEscudo;
  AudioSample sfxSalto;
  AudioSample sfxItem;
  AudioSample sfxPasoJefe; 
  AudioSample sfxTortuga;  
  AudioSample sfxClick;
  AudioSample sfxRisaJefe;

  GestorAudio(PApplet app) {
    minim = new Minim(app);

    bgmNormal = minim.loadFile("musica_bosque.wav");
    bgmCastillo = minim.loadFile("musica_jefe.wav");
    ambienteRio = minim.loadFile("ambiente_rio.wav"); 
    ambienteRio.setGain(-5.0); 

    sfxEspada = minim.loadSample("espada.wav", 512); 
    sfxEscudo = minim.loadSample("escudo.wav", 512);
    sfxSalto = minim.loadSample("salto.wav", 512);
    sfxItem = minim.loadSample("item.wav", 512);
    sfxPasoJefe = minim.loadSample("paso_jefe.wav", 512);
    sfxTortuga = minim.loadSample("tortuga.wav", 512);
    sfxClick = minim.loadSample("click.wav", 512);
    sfxRisaJefe = minim.loadSample("risa_jefe.wav", 512);
  }
  
  void iniciarMusicaBosque() {
    detenerTodo();
    if (bgmNormal != null) bgmNormal.loop();
    if (ambienteRio != null) ambienteRio.loop();
  }

  void iniciarMusicaJefe() {
    detenerTodo();
    
    if (bgmCastillo != null) bgmCastillo.loop();
  }
 void detenerTodo() {
    if (bgmNormal != null) {
      bgmNormal.pause();
      bgmNormal.rewind();
    }
    if (ambienteRio != null) {
      ambienteRio.pause();
      ambienteRio.rewind();
    }
    if (bgmCastillo != null) {
      bgmCastillo.pause();
      bgmCastillo.rewind();
    }
  }

  void sonarSalto() {  if (sfxSalto != null) sfxSalto.trigger();  }
  void sonarEspada() {  if (sfxEspada != null) sfxEspada.trigger();  }
  void sonarEscudo() {  if (sfxEscudo != null) sfxEscudo.trigger(); }
  void sonarItem() {  if (sfxItem != null) sfxItem.trigger();  }
  void sonarPasoJefe() { /* if (sfxPasoJefe != null) sfxPasoJefe.trigger(); */ }
  void sonarTortuga() {  if (sfxTortuga != null) sfxTortuga.trigger(); }
  void sonarClick() {  if (sfxClick != null) sfxClick.trigger();  }
  void sonarRisaJefe() {  if (sfxRisaJefe != null) sfxRisaJefe.trigger();  }
 
  void actualizarVolumen(float vol) {
    float db = (vol <= 0.01) ? -80.0 : map(vol, 0.0, 1.0, -35.0, 0.0);
    
    if (bgmNormal != null) bgmNormal.setGain(db);
    if (bgmCastillo != null) bgmCastillo.setGain(db);
    
    if (ambienteRio != null) ambienteRio.setGain(db - 5.0); 
    
    if (sfxEspada != null) sfxEspada.setGain(db);
    if (sfxEscudo != null) sfxEscudo.setGain(db);
    if (sfxSalto != null) sfxSalto.setGain(db);
    if (sfxItem != null) sfxItem.setGain(db);
    if (sfxPasoJefe != null) sfxPasoJefe.setGain(db);
    if (sfxTortuga != null) sfxTortuga.setGain(db);
    if (sfxClick != null) sfxClick.setGain(db);
    if (sfxRisaJefe != null) sfxRisaJefe.setGain(db);
  }
}
