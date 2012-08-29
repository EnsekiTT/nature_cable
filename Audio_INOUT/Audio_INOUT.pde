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
  sine1 = new SineWave(440, 0.7, out.sampleRate());
  sine2 = new SineWave(880, 0.5, out.sampleRate());
  sine3 = new SineWave(1760, 0.3, out.sampleRate());
  out.addSignal(sine1);
  out.addSignal(sine2);
  out.addSignal(sine3);
  
  //Input
  in = minim.getLineIn(Minim.STEREO, 512);
  
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
  
  //Wave Output
  /*
  background(0);
  stroke(255);
  for(int i = 0; i < in.left.size()-1; i++){
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }
  */
  
  fft.forward(in.mix);
  //stroke(256,0,0);
  for(int i = 0; i < fft.specSize(); i++){
    line(i*2, height, i*2, height - fft.getBand(i)*2);
    if(max3 < fft.getBand(i)){
      if(max2 < fft.getBand(i)){
        if(max1 < fft.getBand(i)){
          max1 = fft.getBand(i);
        }else{
          max2 = fft.getBand(i); 
        }
      }else{
        max3 = fft.getBand(i); 
      }
    }
  }
  //println("R" + max1*4 + ",G" + max2*4 + ",B" + max3*4);
  color newpix = color(max1*4, max2*4, max3*4);
  
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
