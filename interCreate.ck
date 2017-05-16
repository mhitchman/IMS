CA caObject1;
CA caObject2;
Scale scaleObj; // see Scale.ck
BPM bpmObj; // see BPM.ck 
MIDIHelp mhelp; // see MIDIHelper.ck

// MIDI Stuff //
MidiOut mout; // built-in Midi class for outputting midi messages
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
// The contents of each cell are destination notes
// the currentNote integer is used to choose a row
// A random number is generated between 0 and 9 which then is used to choose a column thus giving the next note number
// the more times a number appears in the row the higher percentage that it will be the next "state"

fun int returnNextNote()
{
	return rootNoteProbs[currentNote][Math.random2(0, 9)]; // does the process described above
}

// Note pattern stuff //
[
[0, 1, 1, 2],
[0, 1, 2, 2],
[0, 1, 2, 1],
[0, 0, 1, 2],
[2, 1, 2, 0],
[0, 2, 1, 2]
] @=> int notePattern[][]; // a series of different patterns to play the notes in
                           // 0 - root note got through the markhov model above
                           // 1 - first interval 
                           // 2 - second interval 

5 => int numberOfNotePatterns; // number of largest first element of note pattern array. Used for randoming picking a pattern 
0 => int notePatternChoice; // to select the pattern to use from the above array

[bpmObj.quarterNote, bpmObj.quarterNote, bpmObj.quarterNote, bpmObj.quarterNote] @=> dur durPattern[]; // duration for each not in the above pattern. keeping in an array makes changing per note/pattern easy

int intervalNotes[3]; // array for storing the actual MIDI numbers of the notes

// setup the CA cells 
[0,0,1,1] @=> int initialCells[]; // for 1st interval
[0,2,0,1] @=> int initialCells1[]; // for 2nd interval

caObject1.getCellArrSize() => int cellSize;

// assign the starting cells from above to the actual CA arrays
for (0 => int i; i < cellSize; i++)
{
	caObject1.setCellState(i, initialCells[i]);
	caObject2.setCellState(i, initialCells1[i]);
}

// main loop for processing and MIDI creation
while (true)
{
	if (interfaceEnable.intervalsEnabled == true) // if the voice is disabled then there's no point doing all the calculations
	{
		scaleObj.regenScale(); // if the key got changed we need to regenerate the scale here before it starts all the interval calculations and before the next bar

		// take all the cells of the CA, treat them as a binary number, convert it to base 10 to get the note intervals
		caObject1.convertToBase10() => int interval1;
		caObject2.convertToBase10() => int interval2;

		wrapLargeIntervals(interval1) => interval1; // see function definition below for description
		wrapLargeIntervals(interval2) => interval2;

		// get the intervals in relation to whatever the current first note is
		// this will likely go above the range of scaleIntervals so it is wrapped again
		wrapLargeIntervals(interval1 + currentNote) => interval1;
		wrapLargeIntervals(interval2 + currentNote) => interval2;

		// convert those intervals into actual MIDI note numbers by referencing the array created in scale.ck
		scaleObj.scaleIntervals[currentNote] => intervalNotes[0]; 
		scaleObj.scaleIntervals[interval1] => intervalNotes[1];
		scaleObj.scaleIntervals[interval2] => intervalNotes[2];

		returnNextNote() => currentNote; // find the next root note once it's been used

		Math.random2(0, numberOfNotePatterns) => notePatternChoice; // randomly pick a note pattern from the possible number
		
		for (0 => int x; x < 2; x++) // repeat the pattern and intervals twice before changing (=2 bars)
		{
 			for (0 => int i; i < 4; i++) // 4 is the number of notes in the pattern
 			{
				playNote(intervalNotes[notePattern[notePatternChoice][i]], durPattern[i]);
			}
		}

		caObject1.calculateNextGen();
		caObject2.calculateNextGen();
	}
	else
	{
		bpmObj.quarterNote => now; // even if the voice is disabled we still want it to be in time
	}
}

fun int wrapLargeIntervals(int interval)
{

	// the CA produces more values than there are intervals
	// solution is to wrap around so numbers above 7 (the highest element in the array) start again at the beginning of the array
	// so each interval can be called by two values
	// except 0, which technically can be called twice but the CA has died if it actually outputs a 0 so we all pray to the CA gods that it doesn't
	
	if (interval > (scaleObj.scaleIntervals.size() - 1))
	{
		interval - 7 => interval; 
	}

	return interval;
}

fun void playNote(int notePitch, dur noteLength) // same function as in CARythm.ck
{
	mhelp.midiNoteOn(notePitch, 126, 0, msg, mout);
	noteLength => now;
	mhelp.midiNoteOff(notePitch, 126, 0, msg, mout);
}
