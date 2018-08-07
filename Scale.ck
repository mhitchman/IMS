// class to keep track of scale information globally
// makes it possible for the key to be changed anywhere
public class Scale{
	static int keyScale; 
	int scaleIntervals[8];

	[0, 2, 4, 5, 7, 9, 11, 12] @=> int majorScale[]; // MIDI intervals (semitones) that make up a major scale
	
		fun void regenScale()
	{
		for (0 => int i; i < majorScale.size(); i++)
		{
			majorScale[i] + keyScale => scaleIntervals[i];
		}
	}

	// to initialise scaleIntervals using whatever keyScale has been set to when an object is created
	// this ensures that the array is the same across all objects since it can't be made static
	regenScale(); 
}