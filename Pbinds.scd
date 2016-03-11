// PBIND TEMPLATES W/T ARGS //

// VINYL CRACKS + VARSAW
(
~cracks = Pbind(
	\instrument, \vinyl,
	\amp, 0.5,             // amplification level
	\power, 0.5,           // amplitude of Varsaw OSC ( < 3)
	\fade, 0.0,            // = 1, reduces cracks spectrum
	\cracks, 32,           // crack density (0..64)
	\bpfvalue, 800,        // range 600/1200
))

~cracks.play
~cracks.fadeTime=5

// SAMPLE PLAYER WITH SIN AS CONTROL RATE
(
~oldvinylplayer = Pbind(
	\instrument, \readsfsin,
	\buf,d[\full][0],       // full old vinyl track
	\amp, 0.1,              // amplification level
	\heartrate, 0.05,       // sin read speed (0.01 - dur)
	\dur, 16,               // sample loop time
	\pos, 1,               // sample pos [ 0 / 1 ]
))

~oldvinylplayer.play
~oldvinylplayer.fadeTime=5

// SOME BASIC BASS
(
(
~bass = Pbind(
	\instrument, \bass,
	\scale,Scale.minor,
	\octave, [5,6],         // some octave
	\amp, 0.15,              // amplification level
	\sus,1,                 // sustain level (if > dur : overlap)
	\degree, Pswitch1([Pseq([[0,1],3,1,4], inf),Pseq([[1,3],3,1,3],inf)],Prand([0,1],inf)), // some sequence
	\dur, Pseq([0.5,1,0.25,0.75,0.5,0.25, 0.5,1],inf),   // some dur sequence
	\legato, 2.1,
))

~bass.play
~bass.fadeTime=0

// SAMPLE READER, SIMPLE
(
~kick909 = Pbind(
	\instrument, \readsf,
	\buf,d[\bd_9][2],
	\dur, Pseq([1],inf),
	\amp, 0.03,
)
)

~kick909.play

// SAMPLE READER, SIMPLE
(
~tom = Pbind(
	\instrument, \readsf,
	\buf,d[\lt_9][0],
	\dur, Pseq([0.25, 0.5, 0.75],inf),
	\amp, 0.01,
)
)

~tom.play


// ORGAN SYNTH
(
~organ = Pbind(
	\instrument, \organdonor,
	\sustain,2,
	\amp, 0.2,
	\midinote,Pn(Pshuf([[0,4,7],[-1,2,7],[-3,0,5],[-1,2,7],[2,5,9],[-5,-1,4]]+60),inf),
	\dur,2,
	\lfowidth,Pn(Pseries(0.0,0.001,16),inf),
	\lforate,Pn(Pseries(1,0.25,16),inf),
	\rq,Pn(Pseries(0.3,-0.01,8),inf),
	\cutoff,Pn(Pseries(6000,200,9),inf),
))

~organ.play




