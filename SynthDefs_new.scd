(
//////////////////////////////////////////
/////////// DRUMKIT //////////////////////
//////////////////////////////////////////
// Noise Hat
SynthDef(\hh1, {arg out = 0, amp = 0.5, atk = 0.01, rel = 0.2, hpf = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(atk, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, hpf + SinOsc.ar(2, 0, 0.5, 6000));
	snd = Decay.ar(snd, 0.6);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

// Closed hat
SynthDef(\ch1, {arg out=0, amp=0.5, decay=0.05;
 	var env, pch, osc, noise, sig;
 	env = EnvGen.kr(Env.perc(0, decay, 1, -6), doneAction:2);
 	pch = (9000+SinOsc.ar(320, 0, 2000));

	osc = SinOsc.ar(pch, 0, 0.5);
	noise = WhiteNoise.ar;
 	sig = osc + noise;
 	sig = BPF.ar(sig, 12000, 0.3, env);
 	Out.ar(out, sig * amp);
 }).add;
// CowBell // p.dupuis
SynthDef(\cb1, {
	| out=0, amp=0.3, gate=1, freq=540, pan=0.0 |
    var sig, env;

    sig = Pulse.ar( freq * [ 1, 1.5085 ], [ 0.565, 0.445 ], [ 0.4, 0.6 ] ).distort.tanh;
    env = EnvGen.ar(
            Env(
                [ 0, 0.05, 1, 0.1, 0 ], [ 0.003, 0.002, 0.05, 0.5 ], [2, -4, -4, -4]
            ),
        gate: gate,
        timeScale: [ 1.0, 1.5 ],
        doneAction: 2
        );
    sig = Mix( sig * env );
    sig = BPF.ar( sig, freq * 2, 1.808 );

    Out.ar( out, Pan2.ar( sig, pan, amp ) );
}).add;
// KICK
SynthDef(\bd1, {
	arg out=0, amp=0.9, lpf=100;
	var env0, env1, env1m, sig;

	env0 =  EnvGen.ar(
		Env.new([0.5, 1, 0.5, 0],
		[0.004, 0.04, 0.26],
		[-4, -2, -4]),
		doneAction:2);
	env1 = EnvGen.ar(
		Env.new([110, 59, 29],
		[0.003, 0.29], [-4, -5]));
	env1m = env1.midicps;

	sig = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, lpf, env0);
	sig = sig + SinOsc.ar(env1m*0.9, 0, env0);

	sig = sig * 1.9 * amp;
	sig = sig.clip2(1);
	sig = Pan2.ar(sig);

	Out.ar(out, sig);
}).add;
// KICK 2
SynthDef(\bd2, {
	|out=0, amp=1, rel=0.2, freq=65|
	var subosc, subenv, suboutput, clickosc, clickenv, clickoutput, sig;

	subosc = {SinOsc.ar(freq)};
	subenv = {Line.ar(1, 0, rel, doneAction: 2)};

	clickosc = {LPF.ar(WhiteNoise.ar(1),1200)};
	clickenv = {Line.ar(0.4, 0.03, 0.01)};

	suboutput = (subosc * subenv);
	clickoutput = (clickosc * clickenv);
	sig = suboutput + clickoutput;
	Out.ar(out, Pan2.ar(sig*amp))
}).add;
// KICKIV
SynthDef(\bd3, { |out=0, amp=0.1, pan=0, rel=0.26, fratio=1.5, freqpan=0.01, spread=0.8, time=1|
	var env0, env1, env1m, son;
	freqpan = [1,0,-1] * freqpan;
	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([60, 29, 59], [0.105, 0.29], [-4, -5]));

	env0 =  EnvGen.ar(env0,  doneAction:2, timeScale:time);
	env1 = EnvGen.ar(env1, timeScale:time);
	env1m = env1.midicps;

	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);

	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);

	OffsetOut.ar(out, son);
}).add;
// KICK FAT kick_f
SynthDef(\bd4, {
	arg out=0, amp=0.9, bd=0.9, lpf=100;
	var env0, env1, env1m, sig;
	env0 =  EnvGen.ar(
		Env.new([12, 6, 1.1, 0],
		[0.002, 0.20, 0.26],
		[-3, -2, -4]),
		doneAction:2);
	env1 = EnvGen.ar(
		Env.new([60, 59, 29],
		[0.003, 0.29], [-3, -5]));
	env1m = env1.midicps;

	sig = LFPulse.ar(env1m, 0, 0.3, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, lpf, env0);
	sig = sig + SinOsc.ar(env1m*bd, 0, env0);
    sig = sig.tanh;
	sig = sig * 1.9 * amp;
	sig = sig.clip2(1);
	sig = GVerb.ar(Pan2.ar(sig),12, 3, 0.8);

	Out.ar(out, sig);
}).add;
// SNARE
SynthDef(\sd1, {arg out = 0, amp = 1, mul=1.4;
	var snd1 = SinOsc.ar(180,0,mul);
	var snd2 = SinOsc.ar(300,0,mul);
	var noise = LPF.ar(WhiteNoise.ar(1), 500);
	var env = EnvGen.kr(Env.perc(0.005, 0.25), doneAction: 2);
	var env2= EnvGen.kr(Env.perc(0.001, 0.1));
    var sumenv = env + env2;
	var sum = (snd1 + snd2) * sumenv + (noise * sumenv);
	sum = BPF.ar(sum, 1500, 2);
	sum = sum.tanh;
	Out.ar(out, sum);
}).add;
// snare 2 based on Wouter Snoei's snare
SynthDef(\sd2, { |amp = 0.1, fb = 1.75, disperse = 0.001, lpf = 3000, brassage = 0, out=0|
	var sig, tofbsig, fbsig;
	sig = (
		GrayNoise.ar(1.dup(4)) + WhiteNoise.ar(0.5.dup(4)) +
		(SinOsc.ar(XLine.ar(1000,250,0.1)).distort).dup(4)
		).distort * amp * Env.perc(0.0001,0.2).ar;
	sig = BLowPass.ar( sig, (lpf * ExpRand(0.5,1/0.5)).clip(20,20000), 0.4 );
	fbsig = LocalIn.ar( 4 );
	tofbsig = sig + Limiter.ar( LeakDC.ar( fb * fbsig ), 0.99, 0.01);
	tofbsig = PitchShift.ar(tofbsig, [0.1,0.09], 1, disperse, 0.1 );
	tofbsig = BBandPass.ar( tofbsig, 1500, 15 );
	LocalOut.ar( tofbsig.rotate(1) );
	tofbsig = tofbsig * TRand.kr( 0.dup(4), 1, In.kr(1) ).linlin(0,1,1-brassage,1);
	sig = RemoveBadValues.ar( (sig + (Line.kr(0,1,0.2) * tofbsig))[[0,1]] );
	Out.ar( out, sig * 0.5 * Env([1,0], [3], -2).kr(2) );
}).add;

//////////////////////////////////////////
/////////// BASS /////////////////////////
//////////////////////////////////////////

//  DAF_bass «Verschwende deine Jugend (bassline cover)» by rukano
SynthDef(\daf_bass,{ |out, freq=440, sustain=1, gate=1, amp=0.5, room=1|
	var snd, env, fenv, harm;

	harm = [1,1.01,2,2.02,3.5,4.01,5.501];
	harm = harm ++ (harm*2);

	snd = SinOsc.ar(freq*harm).sum.distort.squared * 6;
	snd = snd + SinOsc.ar(freq / [1, 2]).sum!2;

	fenv = EnvGen.kr(Env.adsr(0.075,0.05,0.1,0.25));

	snd = RLPF.ar(snd, fenv.range(freq*2, freq*8), 0.75, 2) + (snd * 0.25);
	env = EnvGen.kr(Env.adsr(0.001,0.2,0.9,0.25), gate, amp, doneAction:2);
	snd = FreeVerb.ar(snd, 0.33, room);
	snd = LeakDC.ar(Limiter.ar(snd * env), 0.995);
	OffsetOut.ar(out, (snd!2 * amp));
}).add;
// FILTERED BASS
SynthDef(\filtered_bass,{ |out, freq=440, sustain=1, gate=1, amp=0.1, room=0.1|
	var snd, env, fenv, harm;
	harm = [1, 2.0, 2.01];
	snd = FreeVerb.ar(Saw.ar(freq*harm,mul:room).sum);
	snd = snd + SinOsc.ar(freq, mul:0.5);
	env = EnvGen.kr(Env.adsr(0.001,0.8,0.7,0.25), gate, 2, doneAction:2);
	fenv = EnvGen.kr(Env.adsr(1.0,0.8,0.75,0.8),gate,freq*35,freq/2);
	snd = RLPF.ar(snd, fenv, 0.2).softclip * env * amp * 5;

	OffsetOut.ar(out, (snd!2 * amp ));
}).add;
// SAW_BASS
SynthDef(\saw_bass, { arg out=0, freq = 440, amp = 0.5, gate = 1, sustain= 4;
	var snd, env, oscfreq, output;
	oscfreq = {freq * LFNoise2.kr(0.5).range(0.98, 1.02)}!3;
	snd = Splay.ar(LFSaw.ar(oscfreq, mul: amp));
	env = Env.adsr(0.7, 4, 0, 0.1).kr(doneAction:2, gate: gate);

	snd = snd;
	output = LPF.ar(snd, (env*freq) + 2*freq);
	Out.ar(out, output);
	}).add;
// deep_bass
SynthDef(\deep_bass,
	{arg out=0, amp=0.5, b=2, rel=15, freq=440;
	var bass, s1, f,lag, d;
	var env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
	d=Duty.kr(b*4,0,Dseq([b,b*2,b*4,b/2],inf));
	lag=Duty.kr(b*4,0,Dseq([0.2,0.1,0.08,0.02,0.052,0.12],inf)).lag(0.2);
	s1=SinOsc.ar(Lag.kr([freq,freq]),mul:0.2)*Decay2.kr(Impulse.kr([b/16,b/8]),0.4,decayTime:b*4);
    s1=s1.tanh;
	s1=FreeVerb.ar(s1,room:2,mul:0.5,add:s1);
	Out.ar(out,(s1 * amp) * env);
}).add;
//BASS_FB
SynthDef(\fb_bass, {
	|out = 0, amp = 0.9, fb=2.3, pan = 0.0, hpf = 2000, freq = 50, rel = 0.2|
	var sig, env;
	env = Env.perc(0.01, rel);
	sig = Pulse.ar([freq, freq-10], mul:amp)
		+ Saw.ar([freq, freq-10], amp)
		+ SinOscFB.ar([freq, freq+13]*2, fb, amp/1.1);
	sig = Pan2.ar(sig, Rand(0-pan, pan));
	sig = LPF.ar(sig, hpf);
	sig = sig * EnvGen.kr(env, doneAction:2);
	Out.ar(out, sig);
}).add;
// c_bass // by wondersluyter «No Quarter pluck synth bass sound»
SynthDef(\c_bass,
	{
		|out=0, midinote = 42, amp=0.5, mul=2|
  var freq = midinote.midicps;
  var subfreq = freq / 2;

  // Envelopes
  var subenv = EnvGen.kr(Env.perc(0, 1), doneAction:2);
  var env = EnvGen.kr(Env.perc(0, 0.5));

  // Component synthesis
  var pluck = Pluck.ar(PinkNoise.ar, 1, 0.2, subfreq.reciprocal) * subenv * mul;
  var tri = VarSaw.ar(freq) * env;
  var sin = SinOsc.ar(freq) * env;
  var sub = (SinOsc.ar([subfreq, subfreq - 2, subfreq + 2]).sum * subenv).tanh;
  var click = RLPF.ar(Impulse.ar(0), [2000, 8000], 1).sum * 1000;

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
  sig = (sig / 2.3).tanh;

  // Another resonant LPF
  sig = MoogFF.ar(sig, XLine.ar(freq*150, freq*30, 0.1), 0.1);

		Out.ar(out, (sig!2) * amp);

	}
).add;

// RAY BASS
SynthDef(\ray_bass, {arg amp = 0.5, out=0, freq = 400, mul = 0.01, atk = 0.01, rel = 0.9, lpf=1200;
    var gliss = XLine.kr(freq, freq*mul, rel);
    var sig = SinOsc.ar(gliss);
    var env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
	sig = LPF.ar(tanh(sig), lpf);
	sig = (sig * env)* amp;
    Out.ar(out, sig);
}).add;
// technobass based on geoffroymontel's bass
SynthDef(\techno_bass, { |freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
    Out.ar(0, sig ! 2)
}).add;
// fm_bass
SynthDef(\fm_bass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
var sig, sig1, sig2, sig3;
freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
sig = sig + sig1;
sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\igate.kr(1),doneAction:0);
sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
// synth_bass
SynthDef(\synth_bass, { |freq, amp=1, time=1, out=0|
	var m1 = SinOsc.ar(8, mul:freq*(1-(2**(0.2/12))), add:freq);
	var m2 = SinOsc.ar(2, mul:0.5, add:0.75);
	var e = EnvGen.ar(Env([0, 1, 0.05, 0], [0.1, 1, 1], [1,-2,-4]), timeScale:time, doneAction:2);
	var o = e * Blip.ar(m1, 6, mul:m2);
	o = Mix.ar([e * LFPulse.ar(m1, 0.25, mul:m2),RLPF.ar(o, 24*freq, 1.0.rand)]);
	Out.ar(out, Pan2.ar(amp * o));
}).add;
// drum_bass // based upon woutersnoei's synth
SynthDef(\drum_bass, { |amp = 0.25, freq = 42, pulse = 0.1, attackFreq = 100, decay = 0.075, out=0,
		sustain = 3, pan = 0|
	var sig;
	sig = BLowPass.ar( Impulse.ar(0,0,pulse), 8000 );
	sig = sig + LFPar.ar(
		Env.perc(0,decay).ar.linexp(0,1,freq, attackFreq) *
			LFDNoise3.kr(0.1).exprange(-0.1.midiratio, 0.1.midiratio),
		-1);
	sig = sig * Env([1,0], [sustain], -4).kr(2);
	sig = RoundPan.ar( 4, sig, pan + Rand(-0.1,0.1)) * amp;
	sig = RemoveBadValues.ar( sig );
	OffsetOut.ar(out, sig )
}).add;

//////////////////////////////////////////
/////////// PIANO               //////////
//////////////////////////////////////////
// PIANOVEL
SynthDef(\pianovel, { |out=0, freq=440, gate=1, amp=0.5, velocity=127, hard=0.8, velhard=0.8|
    var son = MdaPiano.ar(freq, gate, release: 0.9, stereo: 0.3, sustain: 0, vel: velocity, hard: hard, velhard: velhard);
    DetectSilence.ar(son, 0.01, doneAction:2);
    Out.ar(out, son * amp);
}).add;
// PIANOVEL
SynthDef(\pianovelverb, { |out=0, freq=440, gate=1, amp=0.5, velocity=127, hard=0.8, velhard=0.0, room=40|
    var son = MdaPiano.ar(freq, gate, release: 0.9, stereo: 0.3, sustain: 0, vel: velocity, hard: hard, velhard: velhard);
	son = GVerb.ar(son, room);
    DetectSilence.ar(son, 0.01, doneAction:2);
    Out.ar(out, son * amp);
}).add;
// PIANO 3
SynthDef(\piano, { |out=0, freq=440, gate=1, amp=0.5, velocity=127, hard=0.8, velhard=0.8, rho=1|
    var sig1 = MdaPiano.ar(freq, gate, release: 0.9, stereo: 0.3, sustain: 0, vel: velocity, hard: hard, velhard: velhard);
	var sig2 = OteyPiano.ar(freq, amp, rho:rho)*EnvGen.ar(Env.asr(0.01,1,0.1),gate,doneAction:2);
	sig1 = CombN.ar(sig1, 0.01);
	DetectSilence.ar(sig1, 0.01, doneAction:2);
	Out.ar(out,	amp * Mix.ar(
			[Splay.ar(sig2 * 0.2, LinLin.kr(freq,36.midicps,90.midicps,-0.75,0.75)), sig1 * [0.08, 0.7]]
		)).tanh;
}).add;


//////////////////////////////////////////
/////////// ABSTRACT INSTRUMENT //////////
//////////////////////////////////////////


// LOST VOICE
SynthDef(\voices, { | out=0, freq=800, gate=1, amp=0.5, freq2=1600, pan=0, intensity=40, rel=3, room=0.5|
	var env = EnvGen.ar(Env.asr(0,1,rel),gate,doneAction:2);
	var sig = Pan2.ar(CombN.ar(Resonz.ar(Gendy5.ar(1,intensity,minfreq:0.2,maxfreq:freq,durscale:0.1,initCPs:10),freq2,0.1),0.1,5,0.6));
	sig = FreeVerb.ar(sig, 0.1, room);
	Limiter.ar(Out.ar(out, Pan2.ar((sig * env)*amp),0.5),pan);
}).add;


// GENDY CYCLIC SOUND
SynthDef(\gendy, {
	arg out=0, amp=0.5, freq=220, gate=1, rel=1,speed=1;
	var sig, env, chaos;
	env = EnvGen.ar(Env.asr(0,1,rel),gate,doneAction:2);
	chaos = Gendy5.ar([120,10].rand, [10,40].rand, 124.0.rand, 50.0.rand, freq, freq * 2, 400.0.rand, 400.0.rand, [(0..15)].sqrt, 20, 5);
	sig = SinOsc.ar(chaos, SinOsc.ar([112, 60], SinOsc.ar(0.3)), freq / 10);
	sig = BLowPass.ar( sig, (400 * ExpRand(0.5,1/0.5)).clip(20,20000), 0.8 );
	sig = sig.tanh;
	sig = Mix.ar([sig, HPF.ar(sig, 200, SinOsc.ar(speed, 0, 1))]);
	sig = Mix.ar([sig, LPF.ar(sig, 130)]); // 100 - 150
	sig = FreeVerb.ar(sig, 0.5, 10, 0.2);
	sig = sig.tanh;
	Out.ar(out, (sig * env)*amp);

}).add;

// sonar
SynthDef(\sonar, { | freq = 1200, amp=0.5, out=0 |
	var sound;
	var env;
	var envpitch;
	sound =    RLPF.ar(BrownNoise.ar(1), freq , 0.015,1) * 1;
	2.do{|i|
		sound = DelayN.ar(sound, 0.5, 0.1*i, 0, sound * amp);
	};
	env = EnvGen.ar( Env.perc(0.01, 3, 1, -4), 	doneAction: 2);
	sound = FreeVerb.ar(sound, 0.1, 0.4, 2);
	Out.ar(out, sound * env);
}).add;



)










































// DETUNED
SynthDef.new(\detuned, {
	arg freq = 440, freqf = 3000, atk = 0.1, rel = 0.1, pan=0, amp=0.5;
    var env, synth1, synth2;
    env = EnvGen.ar(Env.new([0, 1, 0], [atk, rel]), doneAction:2);
	synth1 = LPF.ar(Pulse.ar(freq, [0.4,0.6], mul:0.1), freqf)*env;
    synth2 = LPF.ar(Pulse.ar(freq, 0.6, mul:0.1), freqf)*env;
	Out.ar(0, amp * Splay.ar([synth1,synth2]));
}).play;
// MOOG
SynthDef(\moog, { | out=0, freq=440, gate=1, amp=0.5, para1=1 |
	var env = EnvGen.ar(Env.asr(0,1,0.1),gate,doneAction:2);
	var sig = BMoog.ar(LFSaw.ar([freq * 0.99, freq * 1.01], 0, 0.1) ! 2,
		SinOsc.kr(SinOsc.kr(4),1.5pi, 1550,1800),para1, 0);
	// sig = (CombN.ar(sig, 0.4, [0.4, 0.35],2) * 0.4)+ (sig * 0.5);
	Out.ar(out, (sig * env)* amp);
}).play;
// ELECTRIC GUITAR
SynthDef(\electric, { arg out=0, amp=0.1, pan=0,gate=1, rel= 1, saw=12, dur=1;
	var sig =  Saw.ar(12)*266666+CuspN.ar(100, 0.1)*0.00001;
	var sig2 = Gendy5.ar(1/2).lag+2/[2.02,3]/99++9;
	var sig4 = LFNoise0.ar(1/2).lag+2/[2.02,3]/99++9;
	var sig3 = BPF.ar(sig, 440, 4);
	var env =  EnvGen.ar(Env.linen(0.0,dur,0),doneAction:2);
	sig3 =     FreeVerb.ar(CombN.ar(sig3, 1, (sig2/4) + sig4,9),0.25);
	sig3 =     sig3.sum.tanh!2;
	Out.ar(out, (sig3 * amp) * env);}).play;
// tube
SynthDef(\tube, {
	|out=0, freq=150, rel=0.9, amp= 0.9, pan=0, vib=3.2, ff=6800, fg=1|
	var sig, env, noise;
	env = EnvGen.kr(Env.perc(0.001, rel), doneAction:2);
	//sig = SinOsc.ar(400, 0, 0.9);
	sig = Mix.ar([
		SinOsc.ar(freq + 20),
		SinOsc.ar(freq + 40),
		SinOsc.ar(freq + 60),
	]) *0.4;
	sig = Mix.ar(Array.fill(20, {
		|count|
		var harm;
		harm = count + 1 *freq;
		SinOscFB.ar(harm,
			feedback: 0,
			mul: max([0, 0], SinOsc.kr(count+1/vib))
		) * 1/(count+1) + BrownNoise.ar(count+1/3000);
	}));
	noise = WhiteNoise.ar(Rand(0.01, 0.04)) * EnvGen.kr(Env.perc(0.001, Rand(0.01, 0.2)));
	sig = sig + noise;
	sig = MoogFF.ar(sig, ff, fg);
	sig = sig * 0.9;
	sig = sig.distort * amp;
	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan));
}).play;
// SYNTH
SynthDef(\synth, {
	arg out=0, amp=1, freq=200, ffreq=220, bfreq=900, rel=1, wn=0.03, pos=0, ds=1, filterFreq=5200;
	var sig = Formant.ar([freq, freq], ffreq, bfreq)
	+ SinOscFB.ar([freq, freq]*2, ds, amp*2.9)
	+ WhiteNoise.ar(wn);
	var env = EnvGen.kr(Env.perc(0.01, releaseTime:rel), doneAction:2);
	sig = RLPF.ar(sig, filterFreq);
	Out.ar(out, Pan2.ar(Mix.ar(sig), pos) * env * amp)
}).play;
// SPACE_SYNTH
SynthDef(\space_synth, {
	arg out=0, amp=0.5, freq=440, gate=1, rel=1;
	var sig = RLPF.ar( LFSaw.ar( freq, mul: EnvGen.kr( Env.perc(0.01,rel), levelScale: 0.3, doneAction: 2 ) ), LFNoise1.kr(2, 36, 110).midicps, 0.2 );
	6.do({ sig = AllpassN.ar(sig, [0.05, 0.05, 0.03], [0.05.rand, 0.05.rand], 4) });
	Out.ar(out, sig * amp);
}).add;
// ACCOUSTIC GUITAR
SynthDef(\accoustic, {arg out=0, freq=440, pan=0, sustain=0.5, amp=0.3, reverb=0.3;
	var pluck, period, string;
	pluck =  PinkNoise.ar(Decay.kr(Impulse.kr(0.005), 0.05));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, sustain*6);
	string = LeakDC.ar(LPF.ar(Pan2.ar(string, pan), 12000)) * amp;
	string = FreeVerb.ar(string,reverb, 0.75,0.5, 2);
	DetectSilence.ar(string, doneAction:2);
	Out.ar(out, string)
}).add;
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
// SOS BELL
SynthDef(\sos_bell, { |freq=440, out=0, amp=0.1, pan=0|
var son, strike, hum;
// Stretched harmonic series
son = SinOsc.ar(#[2, 3, 4.1, 5.43, 6.8, 8.21] * freq, 0,
	     	 #[1, 0.9, 0.8, 0.7, 0.6, 0.5] * 0.1);
            son = son * EnvGen.ar(Env.new([0,1,0.3, 0.2, 0], [0, 0.3, 0.3, 0.3]));
// A bit of FM adds 'warble'
            son = son * LFTri.ar({Rand(1.0, 1.8)}.dup(6), 1, 0.3, 0.7);
// Mix down the partials in the main sound
            son = son.mean;
            strike = SinOsc.ar(LFNoise1.ar(freq * 36, 100, freq*8), 1, 0.1) *
			EnvGen.ar(Env.new([0,1,0.2, 0.1, 0], [0, 0.01, 0, 0.04]));
	        hum = SinOsc.ar([freq*[1.01,0.5], freq*0.47], 0, //added sin value 0.5
		    EnvGen.ar(Env.new([0,0.05,0.05,0], [0.5,0.5,1]), doneAction:2)).mean;
Out.ar(out, Pan2.ar((son + strike + hum) * 4 * amp, pan));
}).add;
// SAW2
SynthDef(\saw2, {
	arg atk=2, sus=0, rel=3, ts=1, c1=1, c2=(-1), freq=500, detune=0.2, pan=0, cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),timeScale:ts,doneAction:2);
	sig = Saw.ar(freq*{LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,lsf,0.5,ldb);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig*env*amp;
	Out.ar(out,sig);
}).add;
// PROPHET
SynthDef(\prophet,{|out= 0 freq = 440 amp = 1.0 gate=1 lforate = 10 lfowidth= 0.5 cutoff= 12000 rq=0.5 pan = 0.0|
	var lfo, pulse, filter, env;
	lfo = LFTri.kr(lforate*[1,1.01],Rand(0,2.0)!2);
	pulse = Pulse.ar(freq*[1,1.01],lfo*lfowidth+0.5);
	filter = RLPF.ar(pulse,cutoff,rq);
	env = EnvGen.ar(Env.adsr(0.01,0.0,1.0,0.5),gate,doneAction:2);
	Out.ar(out,amp* (Pan2.ar(Mix(filter)*env*amp*0.5,pan)));
}).add;
// prophet2
SynthDef(\prophet2, {
	arg out = 0, pan = 0.0, freq = 440, amp = 1.0, gate = 1, att = 0.01, rel = 0, sus = 1, dec = 0.5, lforate = 20, lfowidth = 0.5, cutoff = 12000, rq = 0.5;

	var lfo, pulse, filter, env;
	lfo = LFTri.kr(lforate * [1, 1.01], Rand(0, 2.0) ! 2);
	pulse = Pulse.ar(freq * [1, 1.01], lfo * lfowidth + 0.5);
	filter = RLPF.ar(pulse, cutoff, rq);
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);
	Out.ar(out, Pan2.ar(
		in: Mix(filter) * env * 0.5,
		pos: pan)
	);
}).play;
SynthDef(\wobble, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=100, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig1 = LFSaw.ar(freq * 1 + (0.04 * [1,-1]));
	sig2 = LFSaw.ar(freq * 0.99 );
	sig3 = LFSaw.ar(freq * 1 );
	sig = sig1 + sig2 + sig3;
	sig = (sig*50).tanh;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).play;
// ORGAN
SynthDef(\organ,{|out= 0 freq = 320 amp = 1 gate=1 lforate = 120 lfowidth= 1.0 cutoff= 100 rq=2 pan=0.0|
	var vibrato, pulse, filter, env;
	vibrato = SinOsc.ar(lforate,Rand(0,2.0));
	pulse = Mix(VarSaw.ar(([1,1.9953843530485,3.0139733629359]*freq)*(1.0+(lfowidth*vibrato)),Rand(0.0,1.0)!3,Rand(0.3,0.5)!3,[1.0,0.7,0.3]))*0.5;
	filter = RLPF.ar(pulse,cutoff,rq);
	env = EnvGen.ar(Env.adsr(0.01,0.5,1.0,0.5),gate,doneAction:2);
	Out.ar(out,Pan2.ar(filter*env*amp,pan));
}).play;
//organ2
SynthDef(\organ2,{
	arg out = 0, pan = 0.0, freq = 440, amp = 0.1, gate = 1, att = 0.01, dec = 0.5, sus = 1, rel = 0.5, lforate = 10, lfowidth = 0.01, cutoff = 100, rq = 0.5;

	var vibrato, pulse, filter, env;
	vibrato = SinOsc.ar(lforate, Rand(0, 2.0));
	// up octave, detune by 4 cents
	// 11.96.midiratio = 1.9953843530485
	// up octave and a half, detune up by 10 cents
	// 19.10.midiratio = 3.0139733629359
	freq = freq * [1, 1.9953843530485, 3.0139733629359];
	freq = freq * (1.0 + (lfowidth * vibrato));
	pulse = VarSaw.ar(
		freq: freq,
		iphase: Rand(0.0, 1.0) ! 3,
		width: Rand(0.3, 0.5) ! 3,
		mul: [1.0,0.7,0.3]);
	pulse = Mix(pulse);
	filter = RLPF.ar(pulse, cutoff, rq);
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);
	Out.ar(out, Pan2.ar(filter * env, pan));
}).add;
// Kalimba
SynthDef(\kalimba, {
    |out = 0, freq = 440, amp = 0.1, mix = 0.1|
    var snd, click;
    // Basic tone is a SinOsc
    snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.03, Rand(3.0, 4.0), 1, -7), doneAction: 2);
	snd = HPF.ar( LPF.ar(snd, 380), 120);
    // The "clicking" sounds are modeled with a bank of resonators excited by enveloped white noise
	click = DynKlank.ar(`[
        // the resonant frequencies are randomized a little to add variation
        // there are two high resonant freqs and one quiet "bass" freq to give it some depth
        [240*ExpRand(0.97, 1.02), 2020*ExpRand(0.97, 1.02), 3151*ExpRand(0.97, 1.02)],
        [-9, 0, -5].dbamp,
        [0.8, 0.07, 0.08]
	], BPF.ar(PinkNoise.ar, 6500, 0.1) * EnvGen.ar(Env.perc(0.001, 0.01))) * 0.1;
	snd = (snd*mix) + (click*(1-mix));
	snd = Mix( snd );
    Out.ar(out, Pan2.ar(snd, 0, amp));
}).add;
// broken_violin
SynthDef(\broken_violin, { |out=0, freq=440, amp=0.5,force=2, gate=1,pos=0.07,c1=1.25,c3=31,pan=0|
    var vib = Gendy5.kr(4,4,1,1,0.4, 4,mul:0.013,add:1);
    var son = DWGBowedTor.ar(freq*vib, amp,force, gate,pos,0.11,c1,c3);
    son = DWGSoundBoard.ar(son);
    son = BPF.ar(son,100,1)+son;
    son = BPF.ar(son,430,1)+son;
    son = BPF.ar(son,490,1)+son;
    son = LPF.ar(son,8000);
    Out.ar(out, Pan2.ar(son * 0.1, pan));
}).add;
// /////////////////////////////// PADS
SynthDef(\dpad, {
	|out=0, amp=1, freq=200, gate=1, n=3|
	var sig, env;
	sig = LFSaw.ar([freq, freq+1]) + LFNoise1.ar([freq, freq]*n);
	sig = sig *amp;

	env = EnvGen.kr(Env.adsr(), gate, doneAction:2);

	sig = sig * env;
	Out.ar(out * amp, sig);
}).add;
// dpads is not a pad
SynthDef(\dpads, {
	|out=0, amp=1, freq=200, n=3, atk= 0.01, rel=0.5|
	var sig, env;
	sig = LFSaw.ar([freq, freq+12]) + LFNoise1.ar([freq, freq]*n);
	sig = sig *amp;

	env = EnvGen.kr(Env.perc(atk, releaseTime:rel), doneAction:2);

	sig = sig * env;
	Out.ar(out, sig);
}).add;
// drone
SynthDef(\drone, { arg out = 0, speed = 1, amp = 0.5, rel = 0.5, dur = 1, freq=200;
	var base = LFNoise1;
    var adsr = EnvGen.ar(Env.linen(dur*4,rel,0, 1),doneAction:2);
	var sig =  HPF.ar(FreeVerb2.ar(*XFade2.ar(SinOscFB.ar([20,freq],base.ar(speed*2)+1/8),
	SinOscFB.ar([120,25],base.ar(speed)+1/2),base.ar(20))),220);
	sig = (sig * adsr) * amp;
	Out.ar(out, sig);
}).add;

// chicago_pad
SynthDef(\chicago_pad, { |out = 0, freq = 440, freq2=660, freq3=528, cutoff = 1000, amp = 0.2, gate=1, rel=2|
    var snd;
    var delay = 0.045+0.05;
    freq = freq + SinOsc.kr(freq*1/2, 0, freq/2, 0);
    snd = Saw.ar([freq, freq+1, freq-1, freq2, freq3] * [0.99,1])*0.1;
    snd = snd + VarSaw.ar(0.99*[freq, freq+1, freq-1, freq2, freq3, freq2+1, freq3+1],0, LFTri.kr(7.13).range(0.00,0.1))*0.1;
    snd = Mix(snd);
    snd = FreeVerb.ar(snd, 0.51,10,0.1)*2;
    snd = snd *8;
    snd = RLPF.ar(snd, SinOsc.kr([0.1,2.2], 0, [1700,480], [4000,200,5000])/[20.51,20], SinOsc.ar(0.1,1.5*pi)+1.05)/3;
    snd = Mix(snd);
    snd = MoogFF.ar(snd, SinOsc.kr(0.08, 0.5, cutoff/10, cutoff), 3, 0);
    snd = snd * EnvGen.ar(Env.dadsr(delay,0.4, 0.01,0.8,rel), gate, doneAction:2);
    //snd = snd * EnvGen.ar(Env.adsr(0.4, 0.01,0.8,0.4), gate, doneAction:2);
    snd = [snd , AllpassC.ar(snd, delay, 0.05+SinOsc.ar(0.11).range(0,0.045), 0.3)];
    snd = snd * amp;
    Out.ar(out, snd);
}).add;



// SAMPLE READERS
// SAMPLE READER SIMPLE
SynthDef(\readsf,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15, freq=440;
		var sig,env,glide ;
		sig = Pan2.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
// SAMPLE READER WITH REVERB & LPFilter
SynthDef(\readsfrb,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15, freq=440, roomsize=0.6, lpf=8000;
		var sig,env,glide ;
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = FreeVerb.ar(sig * env, roomsize);
		sig = LPF.ar(sig, lpf);
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
SynthDef(\readsfrb2,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15, freq=440, roomsize=12, lpf=12000, revtime=1;
		var sig,env,glide ;
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = LPF.ar(sig, lpf);
		sig = GVerb.ar(sig, roomsize, revtime, mul:0.5);
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
// SAMPLE READER WITH GVERB
SynthDef(\readsfGV, {arg roomsize = 80, revtime, damping, inputbw, spread = 15, drylevel, earlylevel,rel=15, pan=0, pos=0,rate=1,
        taillevel, buf = 0, out=0;
	var sig = Pan2.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
	var env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
	var a = sig;
    Out.ar(out, env * GVerb.ar(
        a,roomsize,revtime,damping,inputbw,spread,drylevel.dbamp,earlylevel.dbamp,taillevel.dbamp,roomsize, 0.3) + a)}).add;
// SAMPLE READER WITH GVERB & DELAY
SynthDef(\readsfGVD, {arg roomsize = 80, revtime, damping, inputbw, spread = 15, drylevel, earlylevel,rel=15, pan=0, pos=0,rate=1,
        taillevel, buf = 0, out=0, maxdtime=2, dtime=1, decay=4, gate=1;
	var sig = Pan2.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
	var env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
	var a = sig * env;
	a = CombL.ar(a * env, maxdtime, dtime, decay, 1, a);
    Out.ar(out, GVerb.ar(
    a,roomsize,revtime,damping,inputbw,spread,drylevel.dbamp,earlylevel.dbamp,taillevel.dbamp,roomsize, 0.3) + a)}).add;

// SAMPLE READER WITH SCRATCHING
SynthDef(\scratch,{
    arg out=0, buf=0, rate=1, glide=0, gate=1, roomsize=0.1, loopRel=0, startPos=0, startLoop, endLoop, ipol=2, amp=0.5;
    var env, signal;
    rate = Lag.kr(rate, glide);
    env = EnvGen.ar(Env.adsr(0.1,0.2,1,2), gate, doneAction: 2);
    signal = LoopBuf.ar(1,buf, BufRateScale.kr(buf) * rate, gate+loopRel, startPos, startLoop, endLoop, ipol);
	signal = FreeVerb.ar(signal, roomsize);
	Out.ar(out, ((signal * env).dup)*amp);
}).add;
// SAMPLE READER WITH GRAINing
SynthDef(\grain, {
	|out = 0, buf = 0, rate=1, startPos = 0, room=11
	rel= 1, amp=1, rev = 1, freq =9000|
	var sig, env, silence, env2;

	env = EnvGen.kr(Env.perc(0.1, rel));
	sig = BufRd.ar(1, buf,
		Phasor.ar(0,
			BufRateScale.kr(buf)*rate,
			startPos,
			BufFrames.kr(buf)),
			0);
	sig = GVerb.ar(sig, room, rev, drylevel:1);
	sig = LPF.ar(sig, freq);
	env2 = EnvGen.kr(
		Env.new([0, 1, 0], [0.01, rel ], \sin), doneAction:2);
	sig = sig * env2 * amp;
	Out.ar(out, sig);
}).add;
// grain2
SynthDef(\grain2, {
	|out = 0, bufnum = 0, rate=1, startPos = 0, room=21
	rel= 1, amp=1, rev = 1, freq =12000|
	var sig, env, silence, env2;

	env = EnvGen.kr(Env.perc(0.1, rel));
	sig = BufRd.ar(2, bufnum,
		Phasor.ar(0,
			BufRateScale.kr(bufnum)*rate,
			startPos,
			BufFrames.kr(bufnum)),
			0);
	sig = LPF.ar(sig, freq);
	env2 = EnvGen.kr(
		Env.new([0, 1, 0], [0.01, rel ], \sin), doneAction:2);
	sig = sig * env2 * amp;
	Out.ar(out, sig*amp);
}).add;
// SAMPLE READER WITH SIN
SynthDef(\readsfsin,
	{arg out = 0, buf = 0, amp = 0.5, pan = 0, pos = 0, rel=15, rate=5;
		var sig,env ;
		var vrate = SinOsc.ar(rate, 0.1, 1);
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * vrate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;
// SAMPLE READER WITH ACCELERATE FUNCTION
SynthDef(\accelerate, {
    |out = 0, buf, megabardur = 3.0, bufdur = 3.0, level = 0, bandwidth = 1, centerrate = 1, dir = 1, amp = 0.5|
    var t, rate, snd, power;
    t = Sweep.kr * dir;
    rate = bufdur * 2.log / megabardur * pow(2, t / megabardur + level);
    power = (pi * bandwidth * 0.5 * log2(rate / centerrate)).clip2(pi).cos + 1 / 2;
    snd = PlayBuf.ar(1,buf, BufRateScale.kr(buf) * rate, loop: 1) * power;
    EnvGen.kr(Env([0, 0], [megabardur]), doneAction: 2);
	snd = snd * amp;
    Out.ar(out,amp * snd.tanh);
}).add;
// SAMPLE READER WITH MODULAR RATE & POS
SynthDef(\granular, {|out=0, buf, rate=1.0, sPos=0.1, attack=0.01, release=0.2, filterFreq=220, bwr=0.5, delPan=0.02|
	var trigger, sig, pan, env;
	env = EnvGen.kr(Env.perc(attack, release, 1, -4), doneAction:2);
	sig = LPF.ar(RHPF.ar(
		PlayBuf.ar(numChannels:buf.numChannels,
			bufnum:buf,
			rate:rate,
			trigger:0,
			startPos:sPos * BufFrames.kr(buf),
			loop:0, doneAction:2),
		filterFreq, bwr), 3000, 1);
	OffsetOut.ar(out,[DelayC.ar(sig,0.01,0.01), DelayC.ar(sig,0.02, delPan)]);
}).add;
// BREAKCORE GENERATOR
SynthDef(\break, {| out = 0, buf = 0, gate = 1, pos = 0, rate = 1, freq = 0, endfreq = 0.001, sustain, wobble = 3, boost = 1, pan=0|
	var player,env,amp;
	freq = XLine.ar(freq,endfreq,sustain/4);
	freq = freq.cpsmidi + (LFNoise2.ar(3).range(-1,1) * (1/12));
	freq = freq.midicps;
	env = Env.adsr(0.0001,0.01, 1, sustain/8, 1);
	amp = EnvGen.kr(env, gate, doneAction:2);
	player = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, Impulse.ar(freq), startPos: (pos*BufFrames.kr(buf)) + Rand(0,20), doneAction:2, loop: 1) * boost;
	player = RLPF.ar(player, SinOsc.ar(wobble/sustain).range(20000,80), XLine.ar(0.2,0.9,sustain)) * boost;
    player = player * amp;
	Out.ar(out,Pan2.ar(FreeVerb.ar(player, 0.3),pan));
}).add;
// looper
SynthDef(\looper, {
	arg buf=0
	,out=0
	,freq=220
	,sampleStart=0
	,loopStart=0
	,loopLen=1 // between 0 (min) and 1 (max)
	,fadeTime=0.1
	,gate=1
	,attack=0.01
	,sustain=1
	,release=1
	,f0=220;

	var rate = freq / f0;
	var sr = rate*BufSampleRate.kr(buf);
	var fadeFrames = fadeTime*sr;
	var loopEnd = loopLen*(BufFrames.kr(buf) - loopStart) + loopStart;
	var loopFrames = loopEnd - loopStart + 1;
	var loopTime = (loopFrames - fadeFrames)/sr;
	var startUpTime = (loopStart - sampleStart)/sr;

	var trigLoop = TDuty.ar(Dseq([startUpTime + loopTime, Dseq([loopTime], inf)]), gapFirst:1);

	var phaseA = Phasor.ar(trigLoop, rate, sampleStart, inf, loopStart);
	var phaseB = Phasor.ar(trigLoop, rate, loopEnd - fadeFrames, inf, loopEnd - fadeFrames);

	var srcA = BufRd.ar(buf.numChannels, buf, phaseA);
	var srcB = BufRd.ar(buf.numChannels, buf, phaseB);

	var startLoop = SetResetFF.ar(trigLoop);
	var loopPan = Phasor.ar(trigLoop, 2/fadeFrames * rate, -1, inf, -1).clip(-1,1);

	var sig = Select.ar(startLoop, [srcA, LinXFade2.ar(srcB, srcA, pan:loopPan)]);
	var env = EnvGen.ar(Env.asr(attack, sustain, release, 1), gate, doneAction:2);

	Out.ar(out, Splay.ar(sig) * env);
}).add;

SynthDef(\looper2, {
	arg buf=0
	,out=0
	,amp=0.5
	,freq=220
	,sampleStart=0
	,loopStart=0
	,loopLen=1 // between 0 (min) and 1 (max)
	,fadeTime=0.1
	,gate=1
	,attack=0.01
	,sustain=1
	,release=1
	,f0=220
	,rate=1
	,hpf=500;


	var sr = rate*BufSampleRate.kr(buf);
	var fadeFrames = fadeTime*sr;
	var loopEnd = loopLen*(BufFrames.kr(buf) - loopStart) + loopStart;
	var loopFrames = loopEnd - loopStart + 1;
	var loopTime = (loopFrames - fadeFrames)/sr;
	var startUpTime = (loopStart - sampleStart)/sr;

	var trigLoop = TDuty.ar(Dseq([startUpTime + loopTime, Dseq([loopTime], inf)]), gapFirst:1);

	var phaseA = Phasor.ar(trigLoop, rate, sampleStart, inf, loopStart);
	var phaseB = Phasor.ar(trigLoop, rate, loopEnd - fadeFrames, inf, loopEnd - fadeFrames);

	var srcA = BufRd.ar(2, buf, phaseA);
	var srcB = BufRd.ar(2, buf, phaseB);

	var startLoop = SetResetFF.ar(trigLoop);
	var loopPan = Phasor.ar(trigLoop, 2/fadeFrames * rate, -1, inf, -1).clip(-1,1);

	var sig = Select.ar(startLoop, [srcA, LinXFade2.ar(srcB, srcA, pan:loopPan)]);
	var env = EnvGen.ar(Env.asr(attack, sustain, release, 1), gate, doneAction:2);
	sig = HPF.ar(sig, 500);
	sig = FreeVerb.ar(sig, 0.1, 1);
	Out.ar(out, Splay.ar(sig*amp) * env);

}).add;
// readDelay
SynthDef(\readsfdelay,
	{

	arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15, freq=440;
	var input, output, delrd, sig, deltimes;

	input = Pan2.ar(PlayBuf.ar(1, buf, loop: 0), -0.5); // buffer playback, panned halfway left
	delrd = LocalIn.ar(4);
	output = input + delrd[[0,1]];
	sig = [output[0]+output[1], output[0]-output[1], delrd[2]+delrd[3], delrd[2]-delrd[3]];
	sig = [sig[0]+sig[2], sig[1]+sig[3], sig[0]-sig[2], sig[1]-sig[3]];
	sig = sig * [0.4, 0.37, 0.333, 0.3];
	deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
	LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
	Out.ar(out, output);

}).add;






















// TIME NOISE
SynthDef(\time_noise, {
	|out=0, amp=1, time=1, lpf = 1000, level=0.5, hpf=30, freq=100|
	var sig, env, env2;
	sig = BrownNoise.ar(level) + WhiteNoise.ar(level) + SinOscFB.ar(Rand(freq, freq+10)/1.99, 1.1).dup;
	env = EnvGen.kr(Env([0,1, 0], [time, 0.05], 7), doneAction:2);
	sig = sig * env * amp;
	sig = HPF.ar(sig, hpf);
	sig = LPF.ar(sig, lpf);
	Out.ar(out, sig*env);
}).add;
// noiseRhythm
SynthDef(\r_noise, {
	|out = 0, amp = 0.5, rel=1, pan=0, freq=10000|
	var sig, env;
	env = Env.perc(0.01, rel);
	sig = BrownNoise.ar(amp);
	sig = Pan2.ar(sig, pan);
	sig = MoogLadder.ar(sig, freq);
	sig = sig * EnvGen.kr(env, doneAction:2);
	Out.ar(out, sig);
}).play;
// VINYL
SynthDef(\vinyl_noise, { | out=0, amp= 0.5, rel=0, dur=1, power=1, fade = 0, cracks=8, bpfvalue=600|
	    var sig;
	    var adsr = EnvGen.ar(Env.linen(dur,rel,0),doneAction:2);
		sig = BPF.ar(Dust2.ar(cracks,0.8)+Dust2.ar(cracks,0.4)+VarSaw.ar(17,0.4,0.5, power)+Dust2.ar(cracks/4,0.1)+Dust2.ar(10,0.05),        bpfvalue)!2;
	    sig = FreeVerb.ar(sig * amp, 0.2, 0.8, 0.5, 2);
	    Out.ar(out, XFade2.ar(sig * adsr, LPF.ar(sig * adsr, bpfvalue), fade, 1));
	    sig = sig.tanh;
}).play;
// gravitynoise

SynthDef(\gravity_noise, { |out=0, freq=440,gate=1, amp=0.5, dur=1|
	var env = EnvGen.ar(Env.asr(0,1,0.1),gate,doneAction:2);
	var gravity = 0.4*GravityGrid.ar(Impulse.kr(LFNoise1.kr([1.25,25.231],10,100)),[10.2,10.5],LFNoise0.kr(05.08,SinOsc.kr(1/dur,0.8)));
	gravity = BPF.ar(FreeVerb.ar(gravity, SinOsc.ar(1/dur)),125,2);
	Out.ar(out, (gravity * env)*amp);
}).play;

// sinnoise
SynthDef(\radiostatic, { |out=0, freq=70, gate=1, amp=0.5, dur=0.25|
	var son = LFSaw.ar(freq, 0, Gendy3.ar(dur)) + LFNoise2.ar(freq) + Gendy5.ar(40,2,10,1,freq,Gendy5.ar(15500, 0, 100),0.8 ); 	son = CombN.ar(LPF.ar(FreeVerb.ar(son, 0.5, 0.5), 800), 0.5);
    Out.ar(out, son * amp);
}).play;




// blow
SynthDef(\blow, { | amp=0.5, out=0 |
	var sound;
	var env;

	sound = OnePole.ar(
		BPF.ar(WhiteNoise.ar(1), 100),
		FSinOsc.kr(Line.kr(0.1, 5, 10))
	);

	sound = sound + Splay.ar(FreqShift.ar(sound, 10/(4..7)));
	// sound = Pluck.ar(sound, Impulse.ar(1), 0.5);
	sound = Pan2.ar(
		sound,
		FSinOsc.kr(1),
		0.1
	);

	env = EnvGen.ar(
		Env.linen(0.5, 0, 1, 1, \welch),
		doneAction: 2
	);
	sound = sound * amp;
	Out.ar(out, sound * env);
}).play;


// endless2
SynthDef(\storm‬, { | out = 0, freq = 99, chaos = 2.0, sustain = 9, lpf=100 |
var snd = { Klank.ar(`[freq.rand*(1..9)], Crackle.ar(chaos,0.01)) * Gendy5.ar(sustain,1/4,0,0,2)} ! 2;
	snd = LPF.ar(snd, lpf);
Out.ar(out, Splay.ar(snd));
}).play;
)
