(

// SYNTHDEFS // UNIFIED SYNTAX
// 1.   SAMPLE-BASED
// 1.1. READ SOUND FILE        (rate, amp, pan, pos, rel)
// 1.2.
// 1.3.
// 1.4.
// 1.5.
// 2.   CLASSIC-INSTRUMENTS
// 2.1  ACCOUSTIC GUITAR
// 2.2  TAP GUITAR
// 2.3  ELECTRIC GUITAR
// 2.4  ORGAN
// 2.5  BASS                    (midinote = 42, amp=0.5, clic=0.5)
// 2.6. BELL                    (freq = 261, tone = 4, art = 1, amp = 0.8, pan = 0)
// 3.   OTHER
// 3.1. SAW                     (freq, amp, gate, )
// 4.   DRUMKIT
// 4.1  CLAP
// 4.2  KICK
// 4.3  HH

// -------------- 1.  SAMPLE  BASED -------------//
// 1.1 READ SOUND FILE

SynthDef(\readsf,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15;
		var sig,env ;
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;


SynthDef(\readsfsin,
	{arg out = 0, buf = 0, amp = 0.5, pan = 0, pos = 0, rel=15, heartrate=5;
		var sig,env ;
		var rate = SinOscFB.ar(heartrate, 0.5, 1);
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;


//
// SynthDef(\backwards,
// 	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15;
// 		var sig,env ;
// 		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
// 		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
// 		sig = sig * env;
// 		sig = sig * amp;
// 		Out.ar(out,sig);
// }).add;
//

//  {var rate= [1, -1].choose.postln; PlayBuf.ar(~buffer.numChannels, ~buffer.bufnum, rate, startPos: ~buffer.numFrames-2*(rate<0).binaryValue, doneAction:2)}.play;




// -------------- 1.  CLASSIC INSTRUMENTS -------------//
// 2.1. ACCOUSTIC GUITAR

(
SynthDef(\acc, {arg out=0, freq=440, pan=0, sustain=0.5, amp=0.3;
	var pluck, period, string;
	pluck =  PinkNoise.ar(Decay.kr(Impulse.kr(0.005), 0.05));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, sustain*6);
	string = LeakDC.ar(LPF.ar(Pan2.ar(string, pan), 12000)) * amp;
	DetectSilence.ar(string, doneAction:2);
	Out.ar(out, string)
}).add;
)


// 2.5. BASS

(
SynthDef(\bass,
	{

		 | out=0, midinote = 42, amp=0.5, clic=0.5|
  var freq = midinote.midicps;
  var subfreq = freq / 2;

  // Envelopes
  var subenv = EnvGen.kr(Env.perc(0, 1), doneAction:2);
  var env = EnvGen.kr(Env.perc(0, 0.5));

  // Component synthesis
  var pluck = Pluck.ar(PinkNoise.ar,1, 0.4, subfreq.reciprocal) * subenv * clic;
  var tri = VarSaw.ar(freq) * env;
  var sin = SinOsc.ar(freq) * env;
  var sub = (SinOsc.ar([subfreq, subfreq - 2, subfreq + 2]).sum * subenv).tanh;
  var click = RLPF.ar(Impulse.ar(0), [2000, 8000], 1).sum * 2;

  // Initial signal
  var sig = pluck + tri + sub + click;

  // Resonant LPFs
  sig = RLPF.ar(sig, XLine.ar(freq * 100, freq * 10, 0.15));
  sig = sig + (MoogFF.ar(sig, freq * 20, 2.5) * 0.1);

  // EQ resulting signal
  sig = BPeakEQ.ar(sig, 400, 0.5, -9);
  sig = BPeakEQ.ar(sig, 2000, 0.5, 6);
  sig = BHiShelf.ar(sig, 8000, 1, 3);
  sig = BPeakEQ.ar(sig, 200, 1, 3);

  // Apply another envelope to dampen a bit more
  sig = sig * XLine.kr(1, 0.6, 0.1);

  // Tanh distortion / limiting
  sig = (sig * 1).tanh;

  // Another round of signal coloring, using another RLPF
  // and sine components
  sig = sig + RLPF.ar(sig, XLine.ar(freq * 100, freq * 10, 0.15)) + sin + sub;

  // Another round of tanh distortion / limiting
  sig = (sig / 1).tanh;

  // Another resonant LPF
  sig = MoogFF.ar(sig, XLine.ar(freq*150, freq*30, 0.1), 0.1);
  sig = sig * amp;
  Out.ar(out, Splay.ar(sig));


	}
).add;
)

// 2.6. Phase Modulated Bell

SynthDef(\pbell, {
arg out = 0, freq = 261, tone = 4, art = 1, amp = 0.8, pan = 0;
var env, mod, sig;
env = Env.perc(0, art);
mod = 5 + (1/IRand(2, 6));
sig = PMOsc.ar(freq, mod*freq,
	pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
	mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));
sig = Pan2.ar(sig, pan);
sig = sig * EnvGen.kr(env, timeScale: 1.3*art,
	levelScale: Rand(0.1, 0.5), doneAction:2);
Out.ar(out, sig*amp);
}).add;



// -------------- 3. OTHER  -------------//
// 3.1 SAW

(
SynthDef(\saw, {| out=0, freq, gate=1, amp=3|
	var adsr = EnvGen.ar(Env.adsr(1e-8,1e-6,0.75,0.125), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 12, detune2 = 8;

	var osc1 = {
	var m = 2**(detune1/1200).rand2;
	var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices1);

	var osc2 = {
	var m = 2**(detune2/1200).rand2;
	var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices2);

	var snd = BLowPass4.ar(osc1, 800, 0.5) + osc2 / 4 * amp ;
	Out.ar(out, Splay.ar(snd*adsr)); // spread on stereo field
}).add;
)

// 3.1 DRONE
(
SynthDef(\drone, { arg out = 0, speed = 1, amp = 0.5;
	var base = LFNoise1;
	var sig = HPF.ar(FreeVerb2.ar(*XFade2.ar(SinOscFB.ar([120,81],base.ar(speed*2)+1/4),
		SinOscFB.ar([80,85],base.ar(speed)+1/2),base.ar(2))),220);
	sig = sig * amp;
	Out.ar(out, sig * amp);
}).add
)

// -------------- 4.  DRUM KIT -------------//

// 4.1 HH

SynthDef(\hihat, {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

// 4.1 SNARE

SynthDef(\snare, {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

// 4.1 KICK

SynthDef(\kick, {arg out = 0, amp = 0.3, sinfreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0;
	var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
	var snd = SinOsc.ar(gliss);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	snd = snd * env * amp;
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

// 4.2 KICKHE

SynthDef(\kickhe, {arg out = 0, punch = 1, amp = 0.4;
    var freq = EnvGen.kr(Env([400, 66], [0.08], -3)),
	sig = Normalizer.ar(SinOsc.ar(freq, 0.5pi, punch).distort, 1) * amp
            * EnvGen.kr(Env([0, 1, 0.8, 0], [0.01, 0.1, 0.2]), doneAction: 2);
    Out.ar(Out, sig ! 2);
}).add;











)
