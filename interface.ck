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
	}
}

