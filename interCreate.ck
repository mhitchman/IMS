CA caObject1;
CA caObject2;
Scale scaleObj;
BPM bpmObj;
MIDIHelp mhelp;

// MIDI Stuff //

MidiOut mout;
mhelp.port => int midiPort;

if (!mout.open(midiPort))
{
	<<< "(interCreate.ck) Error: MIDI port did not open on port: ", midiPort >>>;
	me.exit();
}

MidiMsg msg;

// Markhov Model stuff //

int currentNote;
[
[2,2,4,4,5,5,3,6,7,1],
[3,3,4,4,5,5,1,2,6,0],
[0,0,4,4,6,6,1,2,3,5],
[0,0,1,1,5,5,2,3,4,6],
[0,0,1,1,2,2,3,4,5,6],
[1,1,2,2,3,3,4,5,6,7],
[2,2,4,4,5,5,1,3,6,0],
[3,3,4,4,5,5,0,1,2,6]
] @=> int rootNoteProbs[][]; // the number of each row element corresponds to the note number in scaleObj's scaleInterval's array
// currentNote is used to choose a row
// The contents of each cell are destination notes
// A random number is generated between 0 and 9 which then is used to choose a column thus giving the next note
// the more times a number appears in the row the higher percentage that it will be the next state

fun int returnNextNote()
{
	return rootNoteProbs[currentNote][Math.random2(0, 9)];
}

// Note pattern stuff //
[
[0, 1, 1, 2],
[0, 1, 2, 2],
[0, 1, 2, 1],
[0, 0, 1, 2],
[2, 1, 2, 0],
[0, 2, 1, 2]
] @=> int notePattern[][]; // a series of different patterns to break the notes into
5 => int numberOfNotePatterns; // number of largest first element of note pattern array. Used for randoming picking pattern to choose
0 => int notePatternChoice; // to select the pattern to use from the above array

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
	if (interfaceEnable.intervalsEnabled == true) // if the voice is disabled then there's no point doing all the calculations
	{
		scaleObj.regenScale(); // if the key got changed we need to regenerate the scale here before it starts all the interval calculations and before the next bar
		
		caObject1.convertToBase10() => int interval1;
		caObject2.convertToBase10() => int interval2;

		wrapLargeIntervals(interval1) => interval1;
		wrapLargeIntervals(interval2) => interval2;

		// get the intervals in relation to whatever the current first note is
		// this will likely go above the range of scaleIntervals so it is wrapped again
		wrapLargeIntervals(interval1 + currentNote) => interval1;
		wrapLargeIntervals(interval2 + currentNote) => interval2;

		scaleObj.scaleIntervals[currentNote] => intervalNotes[0];
		scaleObj.scaleIntervals[interval1] => intervalNotes[1];
		scaleObj.scaleIntervals[interval2] => intervalNotes[2];

		returnNextNote() => currentNote; // setup the next note once it's been used

		Math.random2(0, numberOfNotePatterns) => notePatternChoice; // randomly pick a pattern from the possible number
		
		for (0 => int x; x < 2; x++)
		{
 			for (0 => int i; i < 4; i++) // 4 is the number of notes in the pattern
 			{
 				// playNote(notePattern[i], durPattern[i]);
				playNote(intervalNotes[notePattern[notePatternChoice][i]], durPattern[i]);
			}
		}

		caObject1.calculateNextGen();
		caObject2.calculateNextGen();
	}
	else
	{
		bpmObj.quarterNote => now; // even if it is disabled we still want it to be in time
	}
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
