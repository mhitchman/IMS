public class Scale{
	static int keyScale; // default key is C major
	int scaleIntervals[8];

	[0, 2, 4, 5, 7, 9, 11, 12] @=> int majorScale[];
	
		fun void regenScale()
	{
		for (0 => int i; i < majorScale.size(); i++)
		{
			majorScale[i] + keyScale => scaleIntervals[i];
		}
	}

	// to initialise scaleIntervals using whatever keyScale has been set to when an object is crated
	// this ensures that the array is the same across all objects since it can't be made static (Chuck limitation)
	regenScale(); 
}