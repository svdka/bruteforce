//////////////////////////////////////////
/////////// DRUMKIT //////////////////////
//////////////////////////////////////////
/////////// HAT     //////////////////////

// HH 1 : noise hat with HPF
~noisehihat = Pbind(
	\instrument, \hh1,
	\dur, 2,
	\amp, 0.1,
	\hpf, 6000,
	\atk, 0.4,
	\rel, 0.01,
	\pan, 0,
)
~noisehihat.play
// Closed Hat
~closedhat= Pbind(
	\instrument, \ch1,
	\dur, 2,
	\amp, 0.1,
	\decay, 0.2,
)
~closedhat.play

/////////// MISC //////////////////////
// CowBell
~cowbell= Pbind(
	\instrument, \cb1,
	\dur, 2,
	\amp, 0.1,
	\midinote, 72
)
~cowbell.play
/////////// KICK //////////////////////
// KICK
~kick= Pbind(
	\instrument, \bd1,
	\dur, 2,
	\amp, 0.5,
	\lpf, 100,

)
~kick.play
// KICK2
~kick2= Pbind(
	\instrument, \bd2,
	\dur, 2,
	\amp, 0.5,
	\freq, 70,
	\rel, 1,
)
~kick2.play
// KICK3 (time kick)
~kick3= Pbind(
	\instrument, \bd3,
	\dur, 4,
	\amp, 0.5,
	\time, 4,
	\pan, 1,
	\fratio, 2

)
~kick3.play
// KICK5 (hardkick)
~kick4= Pbind(
	\instrument, \bd4,
	\dur, 1,
	\amp, 0.5,
	\lpf, 200,
	\bd, 0.9,
)
~kick4.play

///////////  SNARES   //////////////////////
// Snare 1
~snare1= Pbind(
	\instrument, \sd1,
	\dur, 1,
	\amp, 0.5,
	\mul, 40,
)
~snare1.play
// Snare 2 (voice snare, heavy cpu)
~snare2= Pbind(
	\instrument, \sd2,
	\dur, 1,
	\amp, 0.7,
	\fb, 20,
	\disperse, 0.001,
	\lpf, 3200,
)

~snare2.play
~snare2.free(5);


//////////////////////////////////////////
/////////// BASS    //////////////////////
//////////////////////////////////////////
// DAF_bass
~daf_bass= Pbind(
	\instrument, \daf_bass,
	\dur, 4,
	\amp, 0.5,
	\room, 0.1,
	\sustain, Pkey(\dur),
	\octave, 3,
)
~daf_bass.play
// filtered_bass
~filtered_bass= Pbind(
	\instrument, \filtered_bass,
	\dur, 4,
	\amp, 0.5,
	\sustain, Pkey(\dur),
	\octave, 2,
)
~filtered_bass.play
// ~saw_bass
~saw_bass= Pbind(
	\instrument, \saw_bass,
	\dur, 4,
	\amp, 0.5,
	\octave, 2,
	\sustain, 4,
)
~saw_bass.play
// ~deep_bass
~deep_bass= Pbind(
	\instrument, \deep_bass,
	\dur, 4,
	\amp, 0.5,
	\octave, 3,
	\sustain, 5,
	\b, 2,
)

~deep_bass.play
// ~fb_bass
~fb_bass= Pbind(
	\instrument, \fb_bass,
	\dur, 4,
	\amp, 0.5,
	\rel, 0.5,
	\hpf, 1000,
	\freq, 50,
	\fb, 12, // SinOscFb
)
~fb_bass.free(10);
// ~c_bass
~c_bass= Pbind(
	\instrument, \c_bass,
	\dur, 0.25,
	\amp, 0.5,
	\octave, 3,
	\mul,4, // pluck multiplier
	\degree, Pseq([5, 5, 7	], inf),

)
~c_bass.play
~c_bass.fadeTime=5;
// Raybass
~ray_bass= Pbind(
	\instrument, \ray_bass,
	\dur, 0.5,
	\amp, 0.5,
	\mul, 2,
	\rel, 2,
)
~ray_bass.play
//techno_bass
~technobass= Pbind(
	\instrument, \techno_bass,
	\dur, 1,
	\amp, 0.5,
	\rel, 2,
	\detune, 1.5,
	\width, 2,
	\preamp, 16,
	\octave, 3,
	\slide_time, 1,

)
~technobass.play
// fm_bass
~fm_bass= Pbind(
	\instrument, \fm_bass,
	\dur, 1,
	\octave, 3,
	\amp, 0.5,
	\spread, 24,
	\rel, 4

)
~fm_bass.play
// synth_bass
~synth_bass= Pbind(
	\instrument, \synth_bass,
	\scale, Scale.yu,
	\dur, 0.25,
	\octave, [2,5],
	\time, 0.5,
	\degree, Pwhite(0, 5, inf),

)
~synth_bass.play
// drumbass
~drum_bass= Pbind(
	\instrument, \drum_bass,
	\dur, 1,
	\pulse, 1,
	\freq, 42,
	\attackFreq, 75,
	\decay, 0.075,

)
~drum_bass.play


//////////////////////////////////////////
/////////// PIANO //////////////    //////
//////////////////////////////////////////
// pianovel
~piano = Pbind(
	\instrument, \pianovel,
	\degree, Pseq([0, 1, 2, 3, 4, 5], inf),
	\dur, 0.25,
	\octave, Pstutter(32, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf)),
	\velocity, 90,
	\velhard, Pwhite(0.1, 0.9, inf),
	\hard, Pwhite(0.1, 2, inf),
)

~piano.play
// pianovel2
~piano = Pbind(
	\instrument, \pianovelverb,
	\degree, Pseq([0, 1, 2, 3, 4, 5], inf),
	\dur, 0.25,
	\octave, 3,
	\octave, Pstutter(32, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf)),
	\velocity, 90,
	\velhard, Pwhite(0.1, 0.9, inf),
	\hard, Pwhite(0.1, 2, inf),
)
~piano.play
// pianovel2
~piano = Pbind(
	\instrument, \piano,
	\degree, Pseq([0, 1, 2, 3, 4, 5], inf),
	\dur, 0.25,
	\octave, 3,
	\octave, Pstutter(32, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf)),
	\velocity, 90,
	\velhard, Pwhite(0.1, 0.9, inf),
	\hard, Pwhite(0.1, 2, inf),
)
~piano.play
//////////////////////////////////////////
/////////// ABSTRACT INSTRUMENTS    //////
//////////////////////////////////////////
// ~voices
~voices= Pbind(
	\instrument, \voices,
	\dur, 4,
	\amp, 0.8,
	\freq, 200,
    \freq2,900,
	\intensity, 10
)
~voices.play


// gendy
(
~powernoise = Pbind(
	\instrument, \gendy,
	\dur, 10,
	\rel, Pkey(\dur),
	\amp, 0.0,
	\freq,1200,
	\speed, 1,
).play)

// gendy
(
~echo = Pbind(
	\instrument, \sonar,
	\dur, 4,
	\amp, 0.5,
	\freq, 1200,
).play)

~echo.free(5);











