import processing.serial.*;

  Serial myPort;        // The serial port
  int xPos = 1, yPos = 1, zPos = 1;         // horizontal position of the graph
  int lastxPos=1, lastyPos=1, lastzPos=1;
  int lastxheight=0, lastyheight=0, lastzheight=0;
  float inBytex = 0, inBytey = 0, inBytez = 0;
  

  void setup () {
    // set the window size:
    size(1200, 300);

    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // I know that the first port in the serial list on my Mac is always my
    // Arduino, so I open Serial.list()[0].
    // Open whatever port is the one you're using.
    myPort = new Serial(this, Serial.list()[1], 9600);

    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');

    // set initial background:
    background(255);
  }

  void draw () {
    // draw the line:
    
    strokeWeight(2);
    line(lastxPos, lastxheight, xPos, height-inBytex);
    lastxPos = xPos;
    lastxheight = int(height-inBytex);
    stroke(255, 0, 0);
    
    
    line(lastyPos, lastyheight, yPos, height-inBytey);
    lastyPos = yPos;
    lastyheight = int(height-inBytey);
    stroke(0, 255, 0);
    
    line(lastzPos, lastzheight, zPos, height-inBytez);
    lastzPos = zPos;
    lastzheight = int(height-inBytez);
    stroke(0, 0, 255);
    
   // line(xPos, height, xPos, height - inByte);

    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
      yPos = 0;
      zPos = 0;
      lastxPos = 0;
      lastyPos = 0;
      lastzPos = 0;
      background(255);
    } else {
      // increment the horizontal position:
      xPos++;
      yPos++;
      zPos++;
    }
  }

  void serialEvent (Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');
    String[] inString_dim = new String[3];
    inString_dim[0] = "";
    inString_dim[1] = "";
    inString_dim[2] = "";
    
    //String inString_dim[3];
    int k=0;
    char temp_char;
    
    // String will come in a format: nnxnnxnn where the number can be either 1 n or 2 n. 
    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      
      // probably a better way of doing this but create a char array of the string
      for(int i = 0; i < inString.length(); i++)
      {
        temp_char = inString.charAt(i);
        if(temp_char == 'x')
        {
          k++;
        }
        else
        {
          inString_dim[k] += temp_char;
        }
      }
      //print(inString_dim[0]);
      //print(" ");
      //print(inString_dim[1]);
      //print(" ");
      //println(inString_dim[2]);
      
      inBytex = float(inString_dim[0]); // convert to an int and map to the screen height
      inBytey = float(inString_dim[1]);
      inBytez = float(inString_dim[2]);
      //print(inString);
      //print(" ");
      //print(inBytex);
      //print(" ");
      //print(inBytey);
      //print(" ");
      //println(inBytez);
      inBytex = map(inBytex, -100, 100, 0, height);
      inBytey = map(inBytey, -100, 100, 0, height);
      inBytez = map(inBytez, -100, 100, 0, height);
    }
  }
  
