// keeps track of the tempo and value of note lengths globally
// based off example code in 'Programming For Musicians and Digital Artists
public class BPM
{
	// global variables
	static dur quarterNote, eighthNote, sixteenthNote, thirtysecondNote;

	fun void tempo(float beat)
	{
		// beat argument is BPM
		60.0/(beat) => float SPB; // seconds per beat
		SPB :: second => quarterNote;
		quarterNote*0.5 => eighthNote;
		eighthNote*0.5 => sixteenthNote;
		sixteenthNote*0.5 => thirtysecondNote;
	}
}