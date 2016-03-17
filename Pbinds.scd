//      ///////////////////
//      //PBIND EXAMPLES //
//      ///////////////////

// FX
~reverb = { FreeVerb.ar(~cracks.ar[0], 2.12, 1, 1,1)}
~reverb = { FreeVerb.ar(~oldvinylplayer.ar[0], 2.12, 1, 1,1)}

~mixer = { ~cracks.ar + ~oldvinylplayer.ar}
~mixer = { Mix.ar([~cracks.ar, ~oldvinylplayer.ar])}

~mixer.play
~
~reverb.play
~reverb.free

~fatReverb = { FreeVerb.ar([~cracks.ar, ~oldvinylplayer.ar], 0.1)}
~fatReverb.fadeTime=5
~fatReverb.play


//      /////////////////// CRACKS --> SAW WAVE

(
~cracks = Pbind(
	\instrument, \vinyl,
	\amp, 1.0,             // amplification level
	\power, 2.8,           // amplitude of Varsaw OSC ( < 3)
	\fade, Pseq([0, 1], inf),            // = 1, reduces cracks spectrum
	\cracks, 512,           // crack density (0..64)
	\bpfvalue, 600,        // range 600/1200
	\dur, 1,
))


~cracks.play
~cracks.fadeTime=5
~cracks.free

//      /////////////////// BROKEN RECORD


(
~oldvinylplayer = Pbind(
	\instrument, \readsfsin,
	\buf,d[\full][0],       // full old vinyl track
	\amp, 0.7,              // amplification level
	\heartrate, 0.05,       // sin read speed (0.01 - dur)
	\dur, 16,               // sample loop time
	\pos, 0.0,               // sample pos [ 0 / 1 ]
))

~oldvinylplayer.play
~oldvinylplayer.fadeTime=5

//      /////////////////// PIANO

~piano = Pbind(
	\instrument, \piano_ss,
	\scale, Scale.minor,
	\octave, [4, 5],
	\degree, Prand([0, 1, 2, 3, 6, 8], inf),
	\dur,0.5,
	\amp, 1,
	\punch, 0.2,

)

~piano.play

//      /////////////////// SOME BASS

(
~bass = Pbind(
	\instrument, \daf_bass,
	\scale,Scale.minor,
	\octave, [3,4],         // some octave
	\amp, 0.5,              // amplification level
	\sus,1,                 // sustain level (if > dur : overlap)
	\degree, Pswitch1([Pseq([[0,1],3,1,4], inf),Pseq([[1,3],3,1,3],inf)],Prand([0,1],inf)),
	// \dur, Pseq([0.5,1,0.25,0.75,0.5,0.25, 0.5,1],inf),   // some dur sequence
	\legato, 1.1,
))

~bass.play
~bass.fadeTime=0

//      ///////////////////

(
~tom = Pbind(
	\instrument, \readsf,
	\buf,d[\lt_9][0],
	\dur, Pseq([0.25, 0.5, 0.75],inf),
	\amp, 0.4,
)
)

~tom.play

//      ///////////////////

(
~organ = Pbind(
	\instrument, \saw,
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

//      ///////////////////

(
~guitar = Pbind(
	\instrument, \accoustic,
	// \midinote, Pseq([49,57,49,44,49,59,49,54,61,54,47,54,62,54,42,49,57,49,46,49,59,49,45,54],inf),
	\midinote, Pxrand([42,44,45,47,49,54,57,59,61],inf),  // based on Passe-pied de Debussy
	// \amp, Pwhite(0.15, 0.12),
	\amp, 0.5,
	\dur, Pwhite(0.47, 0.52),
	\sustain, Pwhite(0.25, 0.5),
	\reverb, Pwhite(0.25, 0.5),
	\lag, (0..0.02),
)
)

~guitar.play


//      ///////////////////

(
~bass = Pbind(
	\instrument, \saw,
	\octave,3,
	\amp, 0.01,
	\midinote, Pxrand([42,44,45,42],inf),
	\amp, 0.5,
	\dur, Pwhite(4),
	\rel, 4,
	\gate, 4,
)
)

~bass.play

//      ///////////////////


(
~rcymbal = Pbind(
	\instrument, \granular,
	\buf,Pseq([d[\space][2,3,4],[d[\cy_8][0]]],inf),
	\dur, Pwhite(0.9,1.1, inf),
	\release, Pkey(\dur),
	\rate,-1,
	\atk, 1,
	\filterFreq,Pwhite(0, 2000, inf),
	\sPos,0.2,

)
)

~rcymbal.play


//      ///////////////////

(
~lead = Pbind(
	\instrument, \accoustic,
	\amp, 0.1,
	\midinote, Pseq([[55, 62, 67, 71],[55, 62, 67, 71],[50, 62, 66, 69],[52, 60, 67, 72],[55, 62, 67, 71],],inf),
	// \midinote, Pseq([67, 66, 70, 69, 73 ,74, 79, 78, 82, 81, 82, 79, 73, 70, 67],inf),
	\rel, 0.5,
	\dur, Pseq([0.5,1], inf),
))

~lead.play
~lead.fadeTime=20


//      ///////////////////

(~melody = Pbind(
	\instrument, \sos_bell,
	\dur,0.5,
	\sustain,1.5,
	\i,Pstutter(16,Pfunc{rrand(4,10)*10}),
	\freq,Pfunc{|e|exprand(50,500).round(e.i)},
	\amp,Pgbrown(0.01,0.1),
))


~melody.play


//      ///////////////////

// PATTERN NEW THINGS

(
~snare = Pbind(
	\instrument, \readsf,
	\buf,d[\sd_9].choose,
    \dur, 1,
	)
)

~snares.play

(
~snare = Pbind(
	\instrument, \readsf,
	\buf, Prand(d[\cy_8]++d[\bd_9],inf),
    \dur, 2,

))
~snare.quant(1)
~snare.play

//      ///////////////////

Pbind(
	\dur,0.3,
	\sustain,1.5,
	\k,Pstutter(16,Pfunc{rrand(4,10)*10}),
	\freq,Pfunc{|e|exprand(50,500).round(e.k)},
	\amp,Pgbrown(0.01,0.1)).play



Pbind(
	\scale,	[0,2,4,7,9],
	\degree, Pseq( 32.fib.fold( 0, 10 ), 4 ) + ( 2 * 1 + 1 ) - 10,
	\dur,	1 + 2 ** 1 % 2 / 6
	).play


Pbind(
	\scale, Scale.minor,
	\octave, [3],
	\root, 2,
	\ctranspose,Pseq([
		Pn(0,  8 * 4),
		Pn(-5, 8 * 4)
		], inf),
	\degree, Pseq([7,7s,1,8,1,1,7,1]-1,inf),
	\dur, 0.18,
	\detune, Pseq([(0..2)],inf),
).play

~kick = Pbind(
		\instrument, \kick_ss,
		\dur, Pseq([1.5,2.5],inf),
	\amp, 1.6,
)

~kick.play

~snare = Pbind(
		\instrument, \snare,
		\amp, Pseq([0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,1] *0.1,inf),
		\dur, 0.5
	)
~snare.play

~hh = Pbind(
		\instrument, \readsf,
	\buf,d[\hh_9][0],
		\amp, Pseq([1] * 0.1,inf),
		\sustain, Pseq([1,1,10,1]*0.1, inf),
		\dur, 0.5
	)
~hh.play


~guitar = Pbind (
	\instrument, \bass_filtered,
		\scale, Scale.diminished2,
		\octave, 2,
		\degree, Pseq(
			[0,7,0,7] ++
			Pseq([
				Prand([0,7]),
				Prand([0,5,8,7])
			], 5 + 8) ++
			[7,0],
			inf
		),
		\legato, Pwhite(0.9,1.1,inf),
		\amp, 0.15,
		\dur, 0.2
	)

~guitar.play


// DRUMKIT

    // kick
~kick = Pbind(
		\instrument, \kick_ss,
		\freq,
			Pseq([
				Pseq([1,\,\,\,1,\,1,\]),
				Pseq([1,\,\,\,1,\,\,\]),
			],inf),
		\amp, 0.25,
		\dur, 0.5,
)
~kick.play


~snare =Pbind(
		\instrument, \snare,
		\freq,
			Pseq([
				Pseq([\,\,\,\,1,\,\,\]),
				Pseq([1,1,1,1,\,\,\,\]),
			],inf),
		\amp, 1,
	\dur, 0.25)
~snare.play

(
~kick.play;
~snare.play;
)