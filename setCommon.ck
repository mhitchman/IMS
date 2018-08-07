// initialise some of the static variables to sensible values

Scale scaleObj;
60 => scaleObj.keyScale;
scaleObj.regenScale();

// start with bpm of 60 for the time being
BPM bpmObj;
bpmObj.tempo(60);

// OSC //
OscHelper oscHelp;
8000 => oscHelp.oscPort;
