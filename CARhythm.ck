BPM bpmObj;
MIDIHelp mhelp;

// 0.5::second => dur quarter;
// 0.25 * quarter => dur eighth;

// SinOsc imp => dac;
// Noise imp2 => dac;

// 650 => imp.freq;				
// 0 => imp.gain;

// 0 => imp2.gain;

// fun void stopNote(SinOsc osc, dur length)
// {
// 	length => now;
// 	0.0 => osc.gain;
// }

// fun void stopNoise(Noise osc, dur length)
// {
// 	length => now;
// 	0.0 => osc.gain;
// }

MidiOut mout;
mhelp.port => int midiPort;

if ( !mout.open(midiPort))
{
	<<< "(interCreate.ck) Error: MIDI port did not open on port: ", midiPort >>>;
	me.exit();
}

MidiMsg msg;

fun void playNote(int notePitch, dur noteLength, int channel)
{
	mhelp.midiNoteOn(notePitch, 126, channel, msg, mout);
	noteLength => now;
	mhelp.midiNoteOff(notePitch, 126, channel, msg, mout);
}

fun int base10toBinary(int base10, CA cellObject)
{
	// converts to binary and then assigns it to the CA cell array
	int binarySolution[4];

	if (base10 <= 15) // if the base 10 number is greater than 15 there's an issue somewhere
	{
		for (3 => int i; i >= 0; i--) // assuming it's a 4 bit cell. Counts down because calculation results in binary number backwards
		{
			base10 % 2 => binarySolution[i];
			base10 / 2 => base10;
		}
	}

	for (0 => int i; i < 4; i++)
	{
		cellObject.setCellState(i, binarySolution[i]);
	}
	
}

fun void rhy1()
{

	CA caObject;
	[0,0,0,1] @=> int initialCells[];
	[5, 4, 2, 1, 6, -1, -1, -1] @=> int initialMasks[]; 
	
	caObject.getCellArrSize() => int cellSize;
	for (0 => int i; i < cellSize; i++)
	{
		caObject.setCellState(i, initialCells[i]);
	}

	for (0 => int i; i < 8; i++)
	{
		caObject.setMaskValues(i, initialMasks[i]);
	}

	while(true)
	{
		if (interfaceEnable.rhythm1Enabled == true)
		{
			if (interfaceEnable.useRhythmCATotal1 == false)
			{
				// DEBUG
				// for(0 => int i; i< cellSize; i++)
				// {
				// 	<<< caObject.getCellState(i) >>> ;
				// }
				// DEBUG
				for(0 => int i; i < cellSize; i++)
				{
					if (caObject.getCellState(i) == 1)
					{
						// 0.02 => imp.gain;
						// spork ~ stopNote(imp, 0.08 * quarter);
						playNote(62, bpmObj.sixteenthNote, 1);
					}
					bpmObj.sixteenthNote => now;
				}
				caObject.calculateNextGen();
			}
			else
			{
				base10toBinary(interfaceEnable.RhythmCAInterfaceTotal, caObject);
				false => interfaceEnable.useRhythmCATotal1;
				bpmObj.quarterNote => now;
			}
		}
		else
		{
			bpmObj.quarterNote => now;
		}
	}


}

fun void rhy2()
{

	CA caObject2;
	[1,1,1,0] @=> int initialCells[];
	[5, 4, 2, 1, -1, -1, -1, -1] @=> int initialMasks[]; 
	caObject2.getCellArrSize() => int cellSize;
	for (0 => int i; i < cellSize; i++)
	{
		caObject2.setCellState(i, initialCells[i]);
	}

	for (0 => int i; i < 8; i++)
	{
		caObject2.setMaskValues(i, initialMasks[i]);
	}

	while(true)
	{
		if (interfaceEnable.rhythm2Enabled == true) // check the controls have enabled it
		{
			if (interfaceEnable.useRhythmCATotal2 == false)
			{
				for(0 => int i; i < cellSize; i++)
				{
					if (caObject2.getCellState(i) == 1)
					{
						// 0.02 => imp2.gain;
						// spork ~ stopNoise(imp2, 0.05 * quarter);
						playNote(67, bpmObj.sixteenthNote, 1);
					}
					bpmObj.sixteenthNote => now; // so waits if the cell is 0
				}
				caObject2.calculateNextGen();
			}
			else
			{
				base10toBinary(interfaceEnable.RhythmCAInterfaceTotal, caObject2);
				false => interfaceEnable.useRhythmCATotal2;
				bpmObj.quarterNote => now;
			}
		}
		else
		{
			bpmObj.quarterNote => now; // still want it to stay in time even when disabled
		}
	}

}

spork ~ rhy1();
spork ~ rhy2();

while(true)
{
	10::second => now; // this just keeps the shred alive so the children above stay alive
}