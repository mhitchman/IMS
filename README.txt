					━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
					 INTERACTIVE MUSIC SYSTEMS UG3

							Matthew Hitchman
					━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
					

1 Introduction
══════════════

  The project procedurally generates audio. The main system is
  implemented in Chuck and relies on TouchOSC and OSC messages for user
  control. MIDI messages are then output to the IAC Driver bus. An
  accompanying Ableton Live project has been setup with the appropriate
  MIDI channels and inputs. All the Chuck files are written in plain
  text and so can be opened in a standard text editor.


2 Installation
══════════════

  To run the project requires:
  • [Chuck]
  • A smartphone running [TouchOsc]
  • Ableton Live


[Chuck] http://chuck.cs.princeton.edu/release/

[TouchOsc] https://hexler.net/software/touchosc


3 Running
═════════

  1) Load the accompanying TouchOSC layout (IMSInterface.touchosc) on to
     the smart phone device using [Wi-Fi] or [iTunes] method.
     1) Use the app settings to set the correct host IP address (make
        sure the smartphone and computer are on the same network)
  2) Open the Ableton Project (hub.als)
  3) The easiest way to run the Chuck component is to open the
     miniAudicle app
     ‣ Go to Window > Device Browser and select MIDI from the dropdown
       menu
     ‣ Set the value of port to the IAC Bus Driver port in MIDIHelper.ck
     ‣ With miniAudicle open initialise.ck
     ‣ In the Virtual Machine window click "Start Virtual Machine"
     ‣ In the main window click the "Add Shred" button in the toolbar
  4) Chuck should start picking up the OSC messages from TouchOSC and
     sending MIDI messages to Ableton Live


[Wi-Fi]
https://hexler.net/docs/touchosc-configuration-layout-transfer-wifi

[iTunes]
https://hexler.net/docs/touchosc-configuration-layout-manage-itunes


4 File Structure
════════════════

  The function of the main files of the Chuck project are described
  below. The files themselves are heavily commented so provide greater
  details.
  ⁃ initialise.ck loads all Chuck files necessary for the project to run
  ⁃ setCommon.ck sets values to some static variables that need a value
    • setting these values in the class would have resulted in them
      being reset every time an object was created
  ⁃ interface.ck contains all the OSC processing and interface logic. It
    triggers actions in other parts of the code depending on the OSC
    message's address and/or values
  ⁃ CA.ck includes the class that contains the functions and variables
    for calculating 1D Cellular Automata
  ⁃ CARhythm.ck contains the code for the rhythmic voices
  ⁃ interCreate.ck contains the code for the melodic (regularly referred
    to as the interval) voice


5 Interface
═══════════

  The TouchOSC interface includes a number of different controls.
  ⁃ Tempo fader: sets the tempo across the whole system between 60 bpm
    and 120 bpm
  ⁃ Rhythm Toggle butons: left button enables/disables the first
    rhythmic voice while the right button does the same for the second
    voice.
  ⁃ Interval Toggle button: enables/disables the melodic (interval)
    voice
  ⁃ Rhythm CA multi-toggle: can be used to set the cellular automata
    used by the rhythmic voices. The CA will then "evolve" from that
    configuration. The CA array is not written to until either the '1'
    or '2' button to the right is pressed. They will cause the
    multi-toggle affect either the first or second voice's CA
    respectively.
  ⁃ Rythm Mask buttons: these are used to set the rules being used by
    the rhythmic voice CAs. Since a three neighbourhood rule can be
    expressed as a integer between 0-7 there are 8 numbered
    buttons. Highlighted buttons will be used as rules for creation of
    "child" cells. The values will not be used until either the '1' or
    '2' button is pressed again meaning the rules will be used for the
    first or second rhythm voices respectively.
  ⁃ Key button: are used to set the key of the scale that the melodic
    voice's notes are locked to. The pressed button is written
    immediately but doesn't take effect until the end of the two bar
    cycle the melodic instrument is on.
