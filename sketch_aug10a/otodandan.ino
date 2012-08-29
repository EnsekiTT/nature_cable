// Arduino + Sound WS
// 2011.11.26-27
//
// 01-1:Arduinoで音を出そう
// "音がだんだn変わるサンプル（１）"


//スピーカーのピンを９ピンにする
int speakerPin = 9;

//スピーカーを振るわせる時間
int i=1;
//変数iの増加量
int d=1;

void setup(){

  //スピーカーのピンを出力モードに  
  pinMode(speakerPin, OUTPUT);

}


void loop(){

  i+=d;
  if(i>1000 || i<=1)d=-d;
  
  digitalWrite(speakerPin, HIGH);
  delayMicroseconds(i);

  digitalWrite(speakerPin, LOW);
  delayMicroseconds(i);

}
