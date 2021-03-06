OscHelper oscObj;
Scale scaleObj;

interfaceEnable ie; // make sure all member variables initalise properly.

BPM bpmObj;

OscIn oin;
OscMsg msg; // where the OSC message will be stored
oscObj.oscPort => oin.port; // port to listen for OSC messages
oin.listenAll(); // listen for all OSC messages rather than ones with specific address's

public class interfaceEnable
{
    // used as bool (no boolean type)
	static int rhythm1Enabled;
	static int rhythm2Enabled;
	static int intervalsEnabled;

	// need to get the status of the interface Rhythm CA multibutton to the CA cells being used in CARhythm.ck but want to keep all the interface stuff here
	// Chuck doesn't support static arrays so an array couldn't be shared between objects.
	// Workaround is to treat the interface object as displaying a binary number and store the base 10 equivalent in RhythmCAInterfaceTotal
	// rhythm[1/2]Enabled and useRhythmCATotal[1/2] set whether or not to actually use that representation
	// when it uses it, the base 10 number is converted back to binary and stored in the relevant CA array
	
	static int RhythmCAInterfaceTotal;
	static int useRhythmCATotal1;
	static int useRhythmCATotal2;


	// same problem with static arrays for Rhythm Mask but since need base 10 numbers from the interface can't store it as a single number
	// instead have to have 8 separate ints initialised as -1 as means that rule won't be used for the CA mask
	-1 => static int maskCell0;
	-1 => static int maskCell1;
	-1 => static int maskCell2;
	-1 => static int maskCell3;
	-1 => static int maskCell4;
	-1 => static int maskCell5;
	-1 => static int maskCell6;
	-1 => static int maskCell7;

	static int useMaskCells1;
	static int useMaskCells2;
}

// loops infinitely receiving OSC messages checking it's address and acting accordingly
while (true)
{
	oin => now; // wait for OSC message

	while(oin.recv(msg))
	{
		if (msg.address == "/1/tempo")
		{
			bpmObj.tempo(Std.ftoi(msg.getFloat(0))); // change the tempo to whatever is being sent by the tempo slider
		}
		else if (msg.address == "/1/key1") // key messages are used to change the key of the interval voice using the scale object
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
			if (Std.ftoi(msg.getFloat(0)) == 1) // button sends a 1 when "pressed down"
			{
				true => interfaceEnable.rhythm1Enabled;
			}
			else
			{
				false => interfaceEnable.rhythm1Enabled;
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

		// the rhythm mask buttons output the actual values we want so the outputs can just be fed straight into the relevant variable
		else if (msg.address == "/1/RhythmMask0")
		{
			Std.ftoi(msg.getFloat(0)) => interfaceEnable.maskCell0;
		}
		else if (msg.address == "/1/RhythmMask1")
		{
			Std.ftoi(msg.getFloat(0)) => interfaceEnable.maskCell1;
		}
		else if (msg.address == "/1/RhythmMask2")
		{
			Std.ftoi(msg.getFloat(0)) => interfaceEnable.maskCell2;
		}
		else if (msg.address == "/1/RhythmMask3")
		{
			Std.ftoi(msg.getFloat(0)) => interfaceEnable.maskCell3;
		}
		else if (msg.address == "/1/RhythmMask4")
		{
			Std.ftoi(msg.getFloat(0)) => interfaceEnable.maskCell4;
		}
		else if (msg.address == "/1/RhythmMask5")
		{
			Std.ftoi(msg.getFloat(0)) => interfaceEnable.maskCell5;
		}
		else if (msg.address == "/1/RhythmMask6")
		{
			Std.ftoi(msg.getFloat(0)) => interfaceEnable.maskCell6;
		}
		else if (msg.address == "/1/RhythmMask7")
		{
			Std.ftoi(msg.getFloat(0)) => interfaceEnable.maskCell7;
		}
		else if (msg.address == "/1/RhythmMaskSend1")
		{
			true => interfaceEnable.useMaskCells1;
		}
		else if (msg.address == "/1/RhythmMaskSend2")
		{
			true => interfaceEnable.useMaskCells2;
		}
	}
}

