// Arduino + Sound WS
// 2011.11.26-27
//
// 03:音の長さ
// "440ヘルツの音を出す"


//スピーカーのピンを９ピンにする
int speakerPin = 9;


void setup(){

  //スピーカーのピンを出力モードに  
  pinMode(speakerPin, OUTPUT);
  Serial.begin(9600);
}


void loop(){

  //スピーカーを振るわせる時間を計算しておく変数
  int delayTime;

  int incomingByte;

  if (Serial.available() > 0) { // 受信したデータが存在する
    incomingByte = Serial.read(); // 受信データを読み込む

    Serial.print("I received: "); // 受信データを送りかえす
    Serial.println(incomingByte, DEC);
  }


  //440ヘルツで、スピーカーを振るわせる時間を計算
  delayTime = incomingByte*50;


  digitalWrite(speakerPin, HIGH);
  delayMicroseconds(delayTime);


  digitalWrite(speakerPin, LOW);
  delayMicroseconds(delayTime);

}

