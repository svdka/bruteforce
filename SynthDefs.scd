(

// SYNTHDEFS // UNIFIED SYNTAX


//      ///////////////////
//      //1. SAMPLE BASED//
//      ///////////////////
//
// 1.1. READ SOUND FILE                   (rate, amp, pan, pos, rel)
// 1.2. READ SOUND FILE SINCTRL           (heartrate)
// 1.3. READ SOUND FILE ACCELERATE        (centerrate, level)
// 1.4. READ SOUND FILE GRANULATOR DIRECTIONAL (rate)

//      //////////////////////////
//      //2. CLASSIC INSTRUMENTS//
//      //////////////////////////
//
// 2.1. ACCOUSTIC GUITAR
// 2.2. DAF_BASS
// 2.3. FILTER BASS
// 2.3. BELL                              (freq = 261, tone = 4, art = 1, amp = 0.8, pan = 0)
// 2.4. S.O.S BELL (Based on D.Stowell)
// 2.5. PIANO
// 2.6. (NOT YET) - GRAND PIANO

//      /////////////////////////////
//      //3. ELECTRONIC INSTRUMENTS//
//      /////////////////////////////
//
// 3.1. SAW                               (freq, amp, gate)
// 3.2. PROPHET
// 3.3. TECHNOBASS
// 3.4. DRONE
// 3.5. DETUNED
// 3.6. ORGAN (BTR)
// 3.7. ACID (FROM OTOPHILIA)
// 3.8. SIMPLE PAD


//      ///////////////////
//      // 4. DRUM SYNTHS//
//      ///////////////////
//
// 4.1   KICK
// 4.2   SNARES
// 4.3   HIHAT


//      ////////////
//      // 5. MISC//
//      ////////////
//
// 5.1. VINYL                     (fade : crossfade between cracks & "beat", power : beat level)




//      ///////////////////
//      //1. SAMPLE BASED//
//      ///////////////////
//
// 1.1 READ SOUND FILE

// TO DO : add frequency shift
SynthDef(\readsf,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15;
		var sig,env ;
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;

// 1.2 READ SOUND FILE WITH SIN DETERMINED SPEED

SynthDef(\readsfsin,
	{arg out = 0, buf = 0, amp = 0.5, pan = 0, pos = 0, rel=15, heartrate=5;
		var sig,env ;
	//	var rate = SinOscFB.ar(heartrate, 0.5, 1);
		var rate = SinOsc.ar(heartrate, 0.1, 1);
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,sig);
}).add;

// 1.3 READ SOUND FILE WITH ACCELERATED READING
// (based on code "Risset rhythm by snappizz")
// to do : simplify args
(
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
)

// 1.4. READ SOUND FILE GRANULATOR
(
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
)

//      //////////////////////////
//      //2. CLASSIC INSTRUMENTS//
//      //////////////////////////
//
// 2.1. ACCOUSTIC GUITAR

(
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
)

// 2.2. DAF_BASS

SynthDef(\daf_bass,{ |out, freq=440, sustain=1, gate=1, amp=0.1|
	var snd, env, fenv, harm;

	harm = [1,1.01,2,2.02,3.5,4.01,5.501];
	harm = harm ++ (harm*2);

	snd = SinOsc.ar(freq*harm).sum.distort.squared * 6;
	snd = snd + SinOsc.ar(freq / [1, 2]).sum!2;

	fenv = EnvGen.kr(Env.adsr(0.075,0.05,0.1,0.25));

	snd = RLPF.ar(snd, fenv.range(freq*2, freq*8), 0.75, 2) + (snd * 0.25);
	env = EnvGen.kr(Env.adsr(0.001,0.2,0.9,0.25), gate, amp, doneAction:2);

	snd = LeakDC.ar(Limiter.ar(snd * env));
	OffsetOut.ar(out, (snd!2));
}).add;

// 2.3. FITLERED BASS
SynthDef(\bass_filtered,{ |out, freq=440, sustain=1, gate=1, amp=0.1|
	var snd, env, fenv, harm;
	harm = [1, 2.0, 2.01];
	snd = FreeVerb.ar(Saw.ar(freq*harm,mul:0.1).sum);
	snd = snd + SinOsc.ar(freq, mul:0.5);
	env = EnvGen.kr(Env.adsr(0.001,0.8,0.7,0.25), gate, 2, doneAction:2);
	fenv = EnvGen.kr(Env.adsr(1.0,0.8,0.75,0.8),gate,freq*35,freq/2);
	snd = RLPF.ar(snd, fenv, 0.2).softclip * env * amp * 5;

	OffsetOut.ar(out, (snd!2));
}).add;


// 2.3. Phase Modulated Bell

(
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
)

// 2.4. SOS Bell (Based on Dan Stowell Version)

(
(
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
})).add)

// 2.5 PIANO

(
SynthDef(\piano, { arg out=0, amp=0.1, pan=0, freq=200, gate=1;
	var strike, env, noise, pitch, delayTime, detune;
	var ou, ampEnv;

	strike = Impulse.ar(0.01);
	env = Decay2.ar(strike, 0.008, 0.04);
	pitch = freq.cpsmidi;

	ou = Mix.ar(Array.fill(3, { arg i;

		detune = #[-0.02, 0, 0.05, 0.01].at(i);
		delayTime = 1 / (pitch + detune).midicps;

		noise = LFNoise2.ar(3000, env);
		CombL.ar(noise, delayTime, delayTime, 999)
	}));
	ampEnv= EnvGen.kr(Env.asr(0, 1, 0.2), gate, doneAction:2);
	ou = Pan2.ar(ou*ampEnv,pan,amp);
	Out.ar(out, ou);
}).add;)

// 2.6 GRAND PIANO
// (
// SynthDef(\wip_piano, { | i |
// 	var strike, env, noise, pitch, delayTime, detune;
//
// 	strike = Impulse.ar(0.01);
// 	env = Decay2.ar(strike, 0.008, 0.04);
//
// 	detune = #[-0.05, 0, 0.04].at(1);
// 	delayTime = 1 / (pitch + detune).midicps;
// 	noise = LFNoise2.ar(3000, env);
// 	pitch = (36 + 54.rand);
//
// 	var sig = Pan2.ar(Mix.ar(Array.fill(3,CombL.ar(noise,delayTime,delayTime,6))));
// 	sig = Out.ar(out, sig); // spread on stereo field
// }).play)


(
SynthDef(\electric, { arg out=0, amp=0.1, pan=0,gate=1, rel= 0.3, saw=12;
	var sig =  Saw.ar(12)*266666+CuspN.ar(100, 0.1)*0.00001;
	var sig2 = LFNoise0.ar(1/2).lag+2/[2.02,3]/99++9;
	var sig3 = BPF.ar(sig, 440, 4);
	var env =  EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
	sig3 =     FreeVerb.ar(CombN.ar(sig3, 1, sig2,9),0.25);
	sig3 =     sig3.sum.tanh!2;
	Out.ar(out, (sig3 * amp) * env);}).add;)


//      /////////////////////////////
//      //3. ELECTRONIC INSTRUMENTS//
//      /////////////////////////////
//
// 3.1. SAW

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

// 3.2. PROPHET

(
SynthDef(\prophet,{|out= 0 freq = 440 amp = 1.0 gate=1 lforate = 10 lfowidth= 0.5 cutoff= 12000 rq=0.5 pan = 0.0|
	var lfo, pulse, filter, env;
	lfo = LFTri.kr(lforate*[1,1.01],Rand(0,2.0)!2);
	pulse = Pulse.ar(freq*[1,1.01],lfo*lfowidth+0.5);
	filter = RLPF.ar(pulse,cutoff,rq);
	env = EnvGen.ar(Env.adsr(0.01,0.0,1.0,0.5),gate,doneAction:2);
	Out.ar(out,amp* (Pan2.ar(Mix(filter)*env*amp*0.5,pan)));

}).add
)

// 3.3. TECHNOBASS

SynthDef(\technobass, { |freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
    Out.ar(0, sig ! 2)
}).add;

// 3.4. DRONE

(
SynthDef(\drone, { arg out = 0, speed = 1, amp = 0.5, rel = 0.5, dur = 1, freq=200;
	var base = LFNoise1;
    var adsr = EnvGen.ar(Env.linen(dur*4,rel,0, 1),doneAction:2);
	var sig =  HPF.ar(FreeVerb2.ar(*XFade2.ar(SinOscFB.ar([20,freq],base.ar(speed*2)+1/8),
	SinOscFB.ar([120,25],base.ar(speed)+1/2),base.ar(20))),220);
	sig = (sig * adsr) * amp;
	Out.ar(out, sig);
}).add
)

// 3.5. DETUNED

(
SynthDef.new(\detuned, {
	arg freq = 440, freqf = 3000, atk = 0.1, rel = 0.1, pan=0, amp=0.5;
    var env, synth1, synth2;
    env = EnvGen.ar(Env.new([0, 1, 0], [atk, rel]), doneAction:2);
	synth1 = LPF.ar(Pulse.ar(freq, [0.4,0.6], mul:0.1), freqf)*env;
    synth2 = LPF.ar(Pulse.ar(freq, 0.6, mul:0.1), freqf)*env;
	Out.ar(0, amp * Splay.ar([synth1,synth2]));
}).add;
)


// 3.6. ORGAN

(
SynthDef(\organ,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 10 lfowidth= 0.0 cutoff= 100 rq=0.5 pan=0.0|

	var vibrato, pulse, filter, env;

	vibrato = SinOsc.ar(lforate,Rand(0,2.0));

	pulse = Mix(VarSaw.ar(([1,1.9953843530485,3.0139733629359]*freq)*(1.0+(lfowidth*vibrato)),Rand(0.0,1.0)!3,Rand(0.3,0.5)!3,[1.0,0.7,0.3]))*0.5;

	filter = RLPF.ar(pulse,cutoff,rq);

	env = EnvGen.ar(Env.adsr(0.01,0.5,1.0,0.5),gate,doneAction:2);

	Out.ar(out,Pan2.ar(filter*env*amp,pan));

}).add;
)



// 3.7. ACID FROM OTOPHILIA
(
	SynthDef("acid", {
		arg outBus=0, gate=1, pitch=50, amp=0.1;
		var env1, env2, out;
		pitch = Lag.kr(pitch, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
		env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp);
		env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 0, 0.8, 70, -4), gate);
		out = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);

		out = RLPF.ar(out, (pitch + env2).midicps, 0.3);
		out = out * env1;

		Out.ar(outBus, out.dup);
	}).add(s);

	SynthDef("fx", {
		arg outBus=0, gate=0;
		var out;

		out = In.ar(outBus, 2);
		out = FreeVerb2.ar( BPF.ar(out[0], 3500, 1.5), BPF.ar(out[1], 3500, 1.5), 1.0, 0.95, 0.15) * EnvGen.kr(Env.new([0.02, 0.3, 0.02], [0.4, 0.01], [3, -4], 1), 1-Trig.kr(gate, 0.01)) + out;
		out = HPF.ar(out * 1.2, 40);
		out = Limiter.ar(out, 1.0, 0.02);

		ReplaceOut.ar(outBus, out);
	}).play;
)

// 3.8 SIMPLE PAD

(
SynthDef(\pad, { |out, freqScale=1, sustain=1, amp=0.1, saw=1|
	var snd = Klang.ar(`[ Array.exprand(24, 100, 1000), 0.05, nil ], freqScale)!2;
	snd = snd * EnvGen.ar(Env.sine(sustain), doneAction:2);
	OffsetOut.ar(out, snd * amp)
}).play;
);




//      ///////////////////
//      // 4. DRUM SYNTHS//
//      ///////////////////
//
// 4.1. KICK

SynthDef(\kick_ss, {arg out = 0, amp = 1, att = 0.01, rel = 0.2, freq = 180, pan = 0, sinAmp=1.4, sinValue=180;


	var env  = EnvGen.kr(Env.perc(0.001, 0.1, 4, -4));
	var env2 = EnvGen.kr(Env.perc(0.001, 1,   1, -4), doneAction: 2);
	var sumenv = env + env2;

	var snd1 = SinOsc.ar((sumenv*74),0,1);
	var snd2 = SinOsc.ar((sumenv*53),0,1);
	var snd = (snd1 + snd2) * sumenv;

	var noise = LPF.ar(WhiteNoise.ar(env), 1000);
	var sig =   LPF.ar(snd + noise, 50);

	sig = sig.tanh;

	Out.ar(out, sig * amp);

}).add;

// 4.2.  SNARES

SynthDef(\snare, {arg out = 0, amp = 1, att = 0.01, rel = 0.2, freq = 180, pan = 0, sinAmp=1.4, sinValue=180;

	var snd1 = SinOsc.ar(180,0,sinAmp);
	var snd2 = SinOsc.ar(300,0,sinAmp);

	var noise = LPF.ar(WhiteNoise.ar(1), 500);

	var env = EnvGen.kr(Env.perc(0.005, 0.25), doneAction: 2);
	var env2= EnvGen.kr(Env.perc(0.001, 0.1));
    var sumenv = env + env2;

	var sum = (snd1 + snd2) * sumenv + (noise * sumenv);
	sum = BPF.ar(sum, 1500, 2);
	sum = sum.tanh;

	Out.ar(out, sum);

}).add;


// 4.3. HH

SynthDef(\hihat, {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq + VarSaw.ar(2, 0, 0.5, 6000));
	snd = Decay.ar(snd, 0.6);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;




//      ////////////
//      // 5. MISC//
//      ////////////
//

// 5.1. VINYL

(
SynthDef(\vinyl, { | out=0, amp= 0.5, rel=0, dur=1, power=1, fade = 0, cracks=8, bpfvalue=600|
	    var sig;
	    var adsr = EnvGen.ar(Env.linen(dur,rel,0),doneAction:2);
		sig = BPF.ar(Dust2.ar(cracks,0.8)+Dust2.ar(cracks,0.4)+VarSaw.ar(17,0.4,0.5, power)+Dust2.ar(cracks/4,0.1)+Dust2.ar(10,0.05),        bpfvalue)!2;
	    sig = FreeVerb.ar(sig * amp, 0.2, 0.8, 0.5, 2);
	    Out.ar(out, XFade2.ar(sig * adsr, LPF.ar(sig * adsr, bpfvalue), fade, 1));
	    sig = sig.tanh;
}).add
)




