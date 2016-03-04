// LIVE TEST FILE //
// 1. OPEN SETUP, BOOT
// 2. MAKE SURE SAMPLES ARE IN CORRECT PATH
// 3. TRY THIS PIECE OF CODE

// SAMPLE READER TEST (READFS)

(
~cymbal = Pbind(
	\instrument, \readsf,
	\buf,d[\cy_8][0],
	\amp, 0.1,
	\dur, 1,
))

~cymbal.play
~cymbal.free


// BASS TEST (BASS)

(
~bass = Pbind(
	\instrument, \bass,
	\amp, 0.5,
	\dur, Pwhite(0.5,0.75, inf),
	\midinote, Prand([46, 47, 48, 52, 53], inf),
	\sustain, Pwhite(0.3,0.7, inf),
))

~bass.play
~bass.fadeTime=1

// or different, using lag

(
~walkingbass = Pbind(
	\instrument, \bass,
	\legato, 0.7,
	\dur, Pwhite(0.25,0.75, inf),
	\midinote, Prand([46, 47, 48, 52, 53], inf),
	\lag, Pwhite(0!3, 0.04),
	\clic, [2],
))

~walkingbass.play

// SYNTH TEST (SAW)

(
~saw = Pbind(
	\instrument, \saw,
	\amp, Prand([0.1, 0.075],inf),
	\dur, 0.75,
	\freq, Prand([60, 62, 63, 65, 67, 68, 70], inf).midicps,
	\gate, 0.1,
	\sustain, 1.1,
	\lag, Pwhite(0.05, 0.1),
))

~saw.play
~saw.fadeTime=10
~saw.free
