import ddf.minim.*;
 
Minim minim;
AudioInput in;
AudioRecorder recorder;
 
void setup()
{
  size(512, 200);
 
  minim = new Minim(this);
 
  // get a stereo line-in: sample buffer length of 512
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);
  // create a recorder that  will record from the input
  // to the filename specified, using buffered recording
  // buffered recording means that all captured audio
  // will be written into a sample buffer
  // then when save() is called, the contents of the buffer
  // will actually be written to a file
  // the file will be located in the sketch's root folder.
  recorder = minim.createRecorder(in, "myrecording.wav", true);
 
  textFont(createFont("Arial", 12));
}
 
void draw()
{
  background(0);
  stroke(255);
  for(int i = 0; i < in.left.size()-1; i++)
  {
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }
 
  if ( recorder.isRecording() )
  {
    text("Currently recording...", 5, 15);
  }
  else
  {
    text("Not recording.", 5, 15);
  }
}
 
void keyReleased()
{
  if ( key == 'r' )
  {
    // to indicate that you want to start or stop capturing audio data,
    // you must call beginRecord() and endRecord() on the AudioRecorder object.
    // You can start and stop as many times as you like, the audio data
    // will be appended to the end of the buffer
    // (in the case of buffered recording)
    // or to the end of the file (in the case of streamed recording).
    if ( recorder.isRecording() )
    {
      recorder.endRecord();
    }
    else
    {
      recorder.beginRecord();
    }
  }
  if ( key == 's' )
  {
    // we've filled the file out buffer,
    // now write it to the file we specified in createRecorder
    // in the case of buffered recording, if the buffer is large,
    // this will appear to freeze the sketch for sometime
    // in the case of streamed recording,
    // it will not freeze as the data is already
    // in the file and all that is being done
    // is closing the file.
    // the method returns the recorded audio as an AudioRecording,
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    println("Done saving.");
  }
}
 
void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  // always stop Minim before exiting
  minim.stop();
 
  super.stop();
}
