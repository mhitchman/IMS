BPM bpmObj;
MIDIHelp mhelp;

// Creating the midi handling class and setup port
MidiOut mout;
mhelp.port => int midiPort;

if ( !mout.open(midiPort))
{
	<<< "(interCreate.ck) Error: MIDI port did not open on port: ", midiPort >>>;
	me.exit();
}
MidiMsg msg;

// function to make it easy to play a midi note and stop it after noteLength using the functions created in MIDIHelper.ck
fun void playNote(int notePitch, dur noteLength, int channel)
{
	mhelp.midiNoteOn(notePitch, 126, channel, msg, mout);
	noteLength => now;
	mhelp.midiNoteOff(notePitch, 126, channel, msg, mout);
}


// converts to binary and then assigns it to the CA cell array see interface.ck for reason
fun int base10toBinary(int base10, CA cellObject)
{

	int binarySolution[4];

	if (base10 <= 15) // if the base 10 number is greater than 15 there's an issue somewhere
	{
		for (3 => int i; i >= 0; i--) // assuming it's a 4 bit cell. Counts down because calculation results in binary number backwards
		{
			base10 % 2 => binarySolution[i];
			base10 / 2 => base10;
		}
	}

	for (0 => int i; i < 4; i++) // assign the calculated binary to the actual cell array
	{
		cellObject.setCellState(i, binarySolution[i]);
	}
	
}

fun void useInterfaceMaskCells(CA cellObject) // assign the values collected from the interface to the mask array to change the rules being used by the CA
{
	
	cellObject.setMaskValues(0, interfaceEnable.maskCell0);
	cellObject.setMaskValues(1, interfaceEnable.maskCell1);
	cellObject.setMaskValues(2, interfaceEnable.maskCell2);
	cellObject.setMaskValues(3, interfaceEnable.maskCell3);
	cellObject.setMaskValues(4, interfaceEnable.maskCell4);
	cellObject.setMaskValues(5, interfaceEnable.maskCell5);
	cellObject.setMaskValues(6, interfaceEnable.maskCell6);	
	cellObject.setMaskValues(7, interfaceEnable.maskCell7);
}

fun void rhy1() // function for the first rhythm instrument
{

	// Sets up the starting cell array and the CA rules to use
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

	// main loop where noise is made
	while(true)
	{
	
		if (interfaceEnable.rhythm1Enabled == true) // checks that the voice is actually enabled before bothering with any of the caculations
		{
			if (interfaceEnable.useRhythmCATotal1 == true) // if the interface has signalled that this voice should use the interface CA cells then it should access them and do that 
			{
				base10toBinary(interfaceEnable.RhythmCAInterfaceTotal, caObject); // calls the conversion function with the caObject that this voice uses so it can access the cells being used by this voice
				false => interfaceEnable.useRhythmCATotal1; // flag needs to be changed back to false so the voice doesn't repeatedly set the CA cells
				bpmObj.quarterNote => now; // keep it in time since voice does this instead of play a note
			}
			else if (interfaceEnable.useMaskCells1 == true) // similar as previous but for the mask array 
			{
				useInterfaceMaskCells(caObject);
				false => interfaceEnable.useMaskCells1;
				bpmObj.quarterNote => now;
			}
			else 
			{
				for(0 => int i; i < cellSize; i++)
				{
					if (caObject.getCellState(i) == 1) // go through each cell in the array and if it's a 1 play a note
					{
						playNote(62, bpmObj.sixteenthNote, 1);
					}
					bpmObj.sixteenthNote => now;
				}
				caObject.calculateNextGen(); // calculate the CA's next generation in preparation for the next loop
			}

		}
		else 
		{
			bpmObj.quarterNote => now; // if the voice isn't enabled the loop still needs to take time in order to stay in time with the other voices.
			                           // also stops the loop from looping super fast and causing Chuck to hang
		}
	}


}

fun void rhy2() // second rhythm voice with the same structure as the first
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
			if (interfaceEnable.useRhythmCATotal2)
			{
				base10toBinary(interfaceEnable.RhythmCAInterfaceTotal, caObject2);
				false => interfaceEnable.useRhythmCATotal2;
				bpmObj.quarterNote => now;
			}
			else if (interfaceEnable.useMaskCells2 == true)
			{
				useInterfaceMaskCells(caObject2);
				false => interfaceEnable.useMaskCells2;
				bpmObj.quarterNote => now;
			}
			else
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

		}
		else
		{
			bpmObj.quarterNote => now; // still want it to stay in time even when disabled
		}
	}

}

// start the two voices on different "shreds" so they can run at different times
spork ~ rhy1(); 
spork ~ rhy2();

while(true)
{
	10::second => now; // this just keeps this shred alive so the children above don't get killed
}