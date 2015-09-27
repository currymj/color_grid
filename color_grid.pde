import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.BitSet;

MessageDigest digest = null;
byte[][] hash = new byte[3][];
String[] instrings = new String[3];
BitSet[] bits = new BitSet[3];
String myText = "";

void setup() {
  try{
    digest = MessageDigest.getInstance("SHA-256");
  } catch (NoSuchAlgorithmException e) {
    System.err.println("oops");
  }
  
  
  size(160,160);
}

int currentFrame = 0;

void draw() {
  if (currentFrame < 3) {
    textSize(20);
    background(255);
    fill(0);
    text(myText,10,100);
    instrings[currentFrame] = myText;
  } else if (currentFrame == 3) {
    for (int i = 0; i < 3; ++i) {
      hash[i] = digest.digest(instrings[i].getBytes());
    }
    for (int i = 0; i < 3; i++) {
      bits[i] = BitSet.valueOf(hash[i]);
    }

    int width = 10;
    
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        int curLoc = (i*16)+j;
        int r = bits[0].get(curLoc) ? 255 : 0;
        int g = bits[1].get(curLoc) ? 255 : 0;
        int b = bits[2].get(curLoc) ? 255 : 0;
        fill(r,g,b);
        rect(i*width,j*width,width,width);
      }
    }
  } else if (currentFrame > 3) {
    save(instrings[0] + instrings[1] + instrings[2] + ".png");
    currentFrame = 0;
    clear();
    myText = "";
  }

}

/* Thanks to https://amnonp5.wordpress.com/2012/01/28/25-life-saving-tips-for-processing/
for the basis for this method. */
void keyPressed() {
  if (keyCode == BACKSPACE) {
    if (myText.length() > 0) {
      myText = myText.substring(0, myText.length()-1);
    }
  } else if (keyCode == ENTER) {
    // reset the text, increment the "frame" by one
    myText = "";
    currentFrame++;
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    myText = myText + key;
  }
}