// LIVE TEST FILE //
// 1. OPEN SETUP, BOOT
// 2. MAKE SURE SAMPLES ARE IN CORRECT PATH
// 3. TRY THIS PIECE OF CODE

// SAMPLE READER TEST (READFS)

(
~cymbal = Pbind(
	\instrument, \readsfsin,
	\buf,d[\bd_8][2],
	\amp, 0.4,
	\dur, 1,
	\rate, 1,
	\heartrate, 4,
))

~cymbal.play
~cymbal.free


(
~cymbal = Pbind(
	\instrument, \readsfsin,
	\buf,d[\fb][2],
	\amp, 0.1,
	\dur, 1,
	\rate, 1,
	\heartrate, 0.02,

))

~cymbal.play
~cymbal.fadeTime=1
~cymbal.free

(
~cymbal2 = Pbind(
	\instrument, \readsfsin,
	\buf,d[\full][0],
	\amp, 0.5,
	\dur, 12,
	\rate, 1,
	\heartrate, 0.125,

))

~cymbal2.play
~cymbal2.fadeTime=5
~cymbal2.free


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
	\amp, Prand([0.4, 2.075],inf),
	\dur, 0.75,
	\freq, Prand([60, 62, 63, 65, 67, 68, 70], inf).midicps,
	\gate, 0.1,
	\sustain, 1.1,
	\lag, Pwhite(0.05, 0.1),
))

~saw.play
~saw.fadeTime=10
~saw.free


// DRUM KIT TEST



(
~hihat = Pbind(
		\instrument, \hihat,
		\dur, Pseq([Rest(1/8), 1/8], inf),
		\ffreq, 9000,
		\rel, 0.2,
		\amp, 0.5
))

~hihat.play

(
~kick = Pbind(
		\instrument, \kickhe,
		\dur, 1/4,
		\amp, 0.2,
		\rel, 0.5,
))

~kick.play


(
~kick2 = Pbind(
		\instrument, \kick,
		\dur, 1,
		\amp, 0.9,
		\rel, 0.5,
		\glissf, 0.99
))

~kick2.play



(
~snare = Pbind(
		\instrument, \snare,
		\dur, Pseq([Rest(1/4), 1/4], inf),
		\amp, 0.25,
		\rel, 0.1,
))

~snare.play

// CREEPY INTRO TEST


(
~snare = Pbind(
		\instrument, \Pbell,
		\dur, Pseq([Rest(1/8), 1/8], inf),
	\freq, Pstutter([2, 3], ([220, 230, 240])),
		\amp, 0.5,
		\rel, 0.1,
	\lag, 0.3,
))

~snare.play


(
~snare = Pbind(
		\instrument, \saw,
	    \dur,  0.5,
	    \freq, Pseq([[70,71,75], [71,72,75], [77,74,76], [75,71,75]], inf).midicps,
		\amp, 0.5,
		\rel, 1,
	    \sustain, 1,
))
(
~snare = Pbind(
	\instrument, \saw,
	\freq, Pwhite(220, 440, inf),
	\dur, 1*Pseq([1, 0.375, 0.625, 1, 1], inf),
	\sustain, 1*Pseq([1, 1, 0.625, 1, 1], inf)
)
)



(
~drone = Pbind(
	\instrument, \drone,
    \dur, 20,
	\speed, 2,
	\amp, 1,
)
)

~drone.play
~drone.free

