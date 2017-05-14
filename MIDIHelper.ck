public class MIDIHelp{

	0 => int port;

	144 => int midiChannel1NoteOn; // status byte for note on message to channel 1
	// other channels can be calculated by adding 1 - 15
	
	128 => int midiChannel1NoteOff; // status byte for note off messagte to channel 1
	// other channels can be calculated by adding 1 - 15

	fun void midiNoteOn(int note, int velocity, int channel,
MidiMsg msg, MidiOut mout)
{
	// channel should equal MIDI channel number - 1 (channel 1 is already stored)
	
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