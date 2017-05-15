OscHelper oscObj;
Scale scaleObj;

BPM bpmObj;

OscIn oin; // OSC message receiver
OscMsg msg; // where the OSC message will be stored
oscObj.oscPort => oin.port; // port to listen for OSC messages
oin.listenAll(); // listen to all OSC messages

public class interfaceEnable
{
	static int rhythm1Enabled;
	static int rhythm2Enabled;

	static int intervalsEnabled;


	// need to get the status of the interface Rhythm CA multibutton to the CA cells being used in CARhythm.ck but want to keep all the interface stuff together 
	// chuck doesn't support static arrays so an array couldn't be shared between objects
	// the workaround is to treat the interface object as displaying a binary number and store the base 10 equivalent in the below int
	// another int is set to tell the functions in CARhythm.ck whether or not to use that total
	// when it should use it, the base 10 number is converted back to binary and stored in the relevant CA array
	
	static int RhythmCAInterfaceTotal; // stores the base 10 equivalent of the Rhythm CA array
	static int useRhythmCATotal1; // flag for whether CARhythm rhy1 function should actually use the above total to assign to the CA cells
	static int useRhythmCATotal2; // flag for whether CARhythm rhy2 function should actually use the above total to assign to the CA cells
}


while (true)
{
	oin => now; // wait for OSC message

	while(oin.recv(msg))
	{
		if (msg.address == "/1/tempo")
		{
			bpmObj.tempo(Std.ftoi(msg.getFloat(0))); // change the tempo to whatever is being sent by the tempo slider
		}
		else if (msg.address == "/1/key1")
		{
			60 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key2")
		{
			61 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key3")
		{
			62 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key4")
		{
			63 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key5")
		{
			64 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key6")
		{
			65 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key7")
		{
			66 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key8")
		{
			67 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key9")
		{
			68 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key10")
		{
			69 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key11")
		{
			70 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/key12")
		{
			71 => scaleObj.keyScale;
		}
		else if (msg.address == "/1/toggleRhythm1")
		{
			if (Std.ftoi(msg.getFloat(0)) == 1) // button sends a 1 when "pressed down". Sends it as a float but convert it to int since comparing floats can get messy
			{
				true => interfaceEnable.rhythm1Enabled; // in that case we enable rhythm 1 
			}
			else
			{
				false => interfaceEnable.rhythm1Enabled; // if it wasn't a 1 then rhythm1 shouldn't be enabled
			}
		}
		else if (msg.address == "/1/toggleRhythm2")
		{
			if (Std.ftoi(msg.getFloat(0)) == 1)
			{
				true => interfaceEnable.rhythm2Enabled;
			}
			else
			{
				false => interfaceEnable.rhythm2Enabled;
			}
		}

		else if (msg.address == "/1/toggleInterval")
		{
			if (Std.ftoi(msg.getFloat(0)) == 1)
			{
				true => interfaceEnable.intervalsEnabled;
			}
			else
			{
				false => interfaceEnable.intervalsEnabled;
			}
		}

		else if (msg.address == "/1/RhythmCA/1/1")
		{
			if (Std.ftoi(msg.getFloat(0)) == 1)
			{
				interfaceEnable.RhythmCAInterfaceTotal + 8 => interfaceEnable.RhythmCAInterfaceTotal;
			}
			else
			{
				interfaceEnable.RhythmCAInterfaceTotal - 8 => interfaceEnable.RhythmCAInterfaceTotal;				
			}
		}
		
		else if (msg.address == "/1/RhythmCA/2/1")
		{
			<<< "Hello? " >>>;
			if (Std.ftoi(msg.getFloat(0)) == 1)
			{
				interfaceEnable.RhythmCAInterfaceTotal + 4 => interfaceEnable.RhythmCAInterfaceTotal;
			}
			else
			{
				interfaceEnable.RhythmCAInterfaceTotal - 4 => interfaceEnable.RhythmCAInterfaceTotal;				
			}
		}
		else if (msg.address == "/1/RhythmCA/3/1")
		{
			if (Std.ftoi(msg.getFloat(0)) == 1)
			{
				interfaceEnable.RhythmCAInterfaceTotal + 2 => interfaceEnable.RhythmCAInterfaceTotal;
			}
			else
			{
				interfaceEnable.RhythmCAInterfaceTotal - 2 => interfaceEnable.RhythmCAInterfaceTotal;				
			}
		}
		else if (msg.address == "/1/RhythmCA/4/1")
		{
			if (Std.ftoi(msg.getFloat(0)) == 1)
			{
				interfaceEnable.RhythmCAInterfaceTotal + 1 => interfaceEnable.RhythmCAInterfaceTotal;
			}
			else
			{
				interfaceEnable.RhythmCAInterfaceTotal - 1 => interfaceEnable.RhythmCAInterfaceTotal;				
			}
		}
		else if (msg.address == "/1/RhythmSend1")
		{
 			true => interfaceEnable.useRhythmCATotal1;
		}
		else if (msg.address == "/1/RhythmSend2")
		{
			true => interfaceEnable.useRhythmCATotal2;
		}
	}
}

