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
  frameRate(120);
  
  //Both
  minim = new Minim(this);
  size(640, 480);
  
  //LoadImage
  old_img = loadImage("20111123200001.jpg");
  noStroke();
  smooth();
  background(255);
  // center the image on the screen
  left = (width - old_img.width) / 2;
  top = (height - old_img.height) / 2;

  //Output
  out = minim.getLineOut(Minim.STEREO);
  sine1 = new SineWave(24000, 0.7, out.sampleRate());
  sine2 = new SineWave(28000, 0.5, out.sampleRate());
  sine3 = new SineWave(32000, 0.3, out.sampleRate());
  out.addSignal(sine1);
  out.addSignal(sine2);
  out.addSignal(sine3);
  
  //Input
  in = minim.getLineIn(Minim.STEREO, 511);
  
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
  if(count_row > int(left + old_img.width)){
    count_row = 0;
    if(count_col > int(top + old_img.height)){
      count_col = 0;
    }else{
      count_col++;
    }
  }else{
    count_row++; 
  }
  color pix = old_img.get(x,y);
  //println(red(pix) + "," + green(pix) + "," + blue(pix));
  max1 = 0;
  max2 = 0;
  max3 = 0;
  maxf1 = 0;
  maxf2 = 0;
  maxf3 = 0;
  
  fft.forward(in.mix);
  //stroke(256,0,0);
  println(fft.specSize());
  for(int i = 0; i < fft.specSize(); i++){
    line(i*2, height, i*2, height - fft.getBand(i)*2);
    if(max3 < fft.getBand(i)){
      if(max2 < fft.getBand(i)){
        if(max1 < fft.getBand(i)){
          max1 = fft.getBand(i);
          maxf1 = i;
        }else{
          max2 = fft.getBand(i); 
          maxf2 = i;
        }
      }else{
        max3 = fft.getBand(i); 
        maxf3 = i;
      }
    }
  }
  //println("R" + maxf1 + ",G" + maxf2 + ",B" + maxf3);
  color newpix = color(maxf1, maxf2, maxf3);
  
  stroke(newpix);
  point(left + x, top + y);
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
  out.close();
  minim.stop();
  super.stop();
}
