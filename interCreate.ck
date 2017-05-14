CA caObject1;
CA caObject2;
Scale scaleObj;
BPM bpmObj;
MIDIHelp mhelp;

// MIDI Stuff //

MidiOut mout;
0 => int midiPort;

if (!mout.open(midiPort))
{
	<<< "(interCreate.ck) Error: MIDI port did not open on port: ", midiPort >>>;
	me.exit();
}

MidiMsg msg;

// Note stuff //

[0, 1, 1, 2] @=> int notePattern[];
[bpmObj.quarterNote, bpmObj.quarterNote, bpmObj.quarterNote, bpmObj.quarterNote] @=> dur durPattern[];

int intervalNotes[3];

[0,0,1,1] @=> int initialCells[];
[0,2,0,1] @=> int initialCells1[];

caObject1.getCellArrSize() => int cellSize;

for (0 => int i; i < cellSize; i++)
{
	caObject1.setCellState(i, initialCells[i]);
	caObject2.setCellState(i, initialCells1[i]);
}

while (true)
{

	caObject1.convertToBase10() => int interval1;
	<<< "interval 1: ", interval1 >>>;
	caObject2.convertToBase10() => int interval2;
	<<< "interval 2: ", interval2 >>>;

	wrapLargeIntervals(interval1) => interval1;
	wrapLargeIntervals(interval2) => interval2;

	scaleObj.keyScale => intervalNotes[0];
	scaleObj.scaleIntervals[interval1] => intervalNotes[1];
	scaleObj.scaleIntervals[interval2] => intervalNotes[2];


	//durPattern.size(bpmObj.quarterNote);
	for (0 => int x; x < 4; x++)
	{
 		for (0 => int i; i < notePattern.size(); i++)
 		{
 			// playNote(notePattern[i], durPattern[i]);
			playNote(intervalNotes[notePattern[i]], durPattern[i]);
		}
	}

	caObject1.calculateNextGen();
	caObject2.calculateNextGen();

}

fun int wrapLargeIntervals(int interval)
{

	// the CA produces more values than there are intervals
	// solution is to wrap around so each interval can be called by two values
	// except 0, which technically can be called twice but the CA has died if it actually outputs a 0 so we all pray that it doesn't
	
	if (interval > (scaleObj.scaleIntervals.size() - 1))
	{
		interval - 7 => interval; 
	}

	return interval;
}

fun void playNote(int notePitch, dur noteLength)
{
	mhelp.midiNoteOn(notePitch, 126, 0, msg, mout);
	noteLength => now;
	mhelp.midiNoteOff(notePitch, 126, 0, msg, mout);
}


