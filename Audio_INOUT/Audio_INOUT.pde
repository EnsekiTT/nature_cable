import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioInput in;
AudioOutput out;
SineWave sine1;
SineWave sine2;
SineWave sine3;

PImage old_img;
PImage new_img;
int top, left;
int count_row, count_col;

float max1;
float max2;
float max3;
int maxf1;
int maxf2;
int maxf3;

AudioRecorder recorder;
FFT fft;

void setup()
{
  //frame Rate
  frameRate(5);
  
  //Both
  minim = new Minim(this);
  size(640, 480);
  
  //LoadImage
  old_img = loadImage("03448x.jpg");
  noStroke();
  smooth();
  background(255);
  // center the image on the screen
  left = (width - old_img.width) / 2;
  top = (height - old_img.height) / 2;

  //Output
  out = minim.getLineOut(Minim.STEREO);
  sine1 = new SineWave(0, 1.0, out.sampleRate());
  sine2 = new SineWave(0, 0.98, out.sampleRate());
  sine3 = new SineWave(0, 0.96, out.sampleRate());
  out.addSignal(sine1);
  out.addSignal(sine2);
  out.addSignal(sine3);
  
  //Input
  in = minim.getLineIn(Minim.STEREO, 2048);
  
  //Record
  recorder = minim.createRecorder(in, "myrecording.wav", true);
  
  //Other
  textFont(createFont("Arial", 12));
  
  //FFT
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  //Conter
  count_row = 0;
  count_col = 0;
  
  //Image Output
  image(old_img, left, top);
}

void draw()
{
  //Image Output
  //int x = int(random(old_img.width));
  //int y = int(random(old_img.height));
  int x = count_row;
  int y = count_col;
  if(count_row >= old_img.width-1){
    count_row = 0;
    if(count_col >= old_img.height-1){
      count_col = 0;
    }else{
      count_col++;
    }
  }else{
    count_row++; 
  }
  color pix = old_img.get(x,y);
  println("get:" + red(pix) + "," + green(pix) + "," + blue(pix));
  sine1.setFreq(map(red(pix) , 0, 255, 440, 5930));
  sine2.setFreq(map(green(pix) , 0, 255, 440, 5930));
  sine3.setFreq(map(blue(pix), 0, 255, 440, 5930));
  //sine1.setFreq(440);
  //sine2.setFreq(5930);
  
  max1 = 0;
  max2 = 0;
  max3 = 0;
  maxf1 = 0;
  maxf2 = 0;
  maxf3 = 0;
  fft.forward(in.mix);
  //stroke(256,0,0);
  for(int i = 0; i < fft.specSize(); i++){
    //line(i, height, i, height - fft.getBand(i));
    if(max1 < fft.getBand(i)){
      max3 = max2;
      max2 = max1;
      max1 = fft.getBand(i);
      maxf3 = maxf2;
      maxf2 = maxf1;
      maxf1 = i;
    }
  }
  println("set: " + (maxf1-20) + "," + (maxf2 - 20) + "," + (maxf3 - 20));
  
  color newpix = color(maxf1-20, maxf2-20, maxf3-20);
  
  stroke(newpix);
  point(left + x, top + y);
  fill(pix);
  rect(0, 0, 30, 30);
  fill(newpix);
  rect(30, 0, 30, 30);
  /*
  if( recorder.isRecording() ){
    text("Currently recording...", 5, 15);
  }else{
    text("Not recording.", 5, 15); 
  }
  */
}

void keyReleased(){
  if( key == 'w' ){
    fft.window(FFT.HAMMING);
  }
  if( key == 'e' ){
    fft.window(FFT.NONE);
  }
  
  if( key == 'r' ){
    if( recorder.isRecording() ){
      recorder.endRecord();
    }else{
      recorder.beginRecord();
    }
  }
  if( key == 's' ){
    recorder.save();
    println("Done saving.");
  }
  if( key == ' ' ){
    int s = second();  // 0 から 59の値 
    int m = minute();  // 0 から 59の値
    int h = hour();    //  0 から 23の値 
    int D = day();
    int M = month();
    int Y = year();
    save("nature_cable" + Y + M + D + h + m + s + ".jpg");
  }
}

void stop(){
  in.close();
  minim.stop();
  super.stop();
}
