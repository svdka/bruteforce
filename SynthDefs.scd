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
// 2.5  BASS
// 3.   OTHER
// 3.1. SAW                     (freq, amp, gate, )

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

// -------------- 1.  CLASSIC INSTRUMENTS -------------//
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


















)
