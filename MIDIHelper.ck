public class MIDIHelp{

	0 => int port; // Chuck keeps track of MIDI devices and assigns them port numbers
	               // the IAC Bus is normally on port 0 but
	               // assigning that here makes it easy to change globally since everything uses this variable to open the MIDI port 

	144 => int midiChannel1NoteOn; // status byte for note on message to channel 1
	                               // other channels can be calculated by adding 1 - 15
	
	128 => int midiChannel1NoteOff; // status byte for note off messagte to channel 1
                                 	// other channels can be calculated by adding 1 - 15

	// simple function to create a noteOn message, used throughout system
	fun void midiNoteOn(int note, int velocity, int channel,
MidiMsg msg, MidiOut mout)
{
	// channel should equal MIDI channel number - 1 (channel 1 is already stored so have to add 0 to get it set as the status byte)
	midiChannel1NoteOn + channel => msg.data1;

	note => msg.data2;
	velocity => msg.data3;
	mout.send(msg);
}

fun void midiNoteOff(int note, int velocity, int channel, MidiMsg msg, MidiOut mout)
{
	// channel should equal MIDI channel number - 1 (channel 1 is already stored)
	
	midiChannel1NoteOff + channel => msg.data1;
	note => msg.data2;
	velocity => msg.data3;
	mout.send(msg);
}
}