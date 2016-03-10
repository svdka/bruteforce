(

// SYNTHDEFS // UNIFIED SYNTAX


//      ///////////////////
//      //1. SAMPLE BASED//
//      ///////////////////
//
// 1.1. READ SOUND FILE                   (rate, amp, pan, pos, rel)
// 1.2. READ SOUND FILE SINCTRL           (heartrate)
// 1.3. READ SOUND FILE ACCELERATE        (centerrate, level)
// 1.4.
// 1.5.


//      //////////////////////////
//      //2. CLASSIC INSTRUMENTS//
//      //////////////////////////
//
// 2.1. ACCOUSTIC GUITAR
// 2.2. BASS                              (midinote = 42, amp=0.5, clic=0.5)
// 2.3. BELL                              (freq = 261, tone = 4, art = 1, amp = 0.8, pan = 0)
// 2.4. S.O.S BELL (Based on D.Stowell)


//      /////////////////////////////
//      //3. ELECTRONIC INSTRUMENTS//
//      /////////////////////////////
//
// 3.1. SAW                               (freq, amp, gate)
// 3.2. PROPHET
// 3.3. TECHNOBASS
// 3.4. DRONE
// 3.5. DETUNED


//      ///////////////////
//      // 4. DRUM SYNTHS//
//      ///////////////////
//
// 4.1  KICK
// 4.2  CLAP
// 4.3  HH


//      ////////////
//      // 5. MISC//
//      ////////////
//
// 5.1. HARSH
// 5.2. VINYL                             (fade : crossfade between cracks & "beat", power : beat level)




//      ///////////////////
//      //1. SAMPLE BASED//
//      ///////////////////
//
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

// SynthDef(\backwards,
// 	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15;
// 		var sig,env ;
// 		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
// 		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
// 		sig = sig * env;
// 		sig = sig * amp;
// 		Out.ar(out,sig);
// }).add;

//  {var rate= [1, -1].choose.postln; PlayBuf.ar(~buffer.numChannels, ~buffer.bufnum, rate, startPos: ~buffer.numFrames-2*(rate<0).binaryValue, doneAction:2)}.play;




//      //////////////////////////
//      //2. CLASSIC INSTRUMENTS//
//      //////////////////////////
//
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

// 2.2. BASS

(
SynthDef(\bas,
	{
		arg amp=0,sus=1,pan=0,freq=0;
		var osc, env;
		freq = freq / 4;
		amp = amp / 3;
		osc = LFTri.ar(freq, mul:amp) + SinOscFB.ar(freq,mul: amp) + LFSaw.ar(freq, mul: amp);
		env = EnvGen.ar(Env.perc(0.01, sus),doneAction:2);
		Out.ar(0,Pan2.ar( osc * env , pan));
		}
).add;
)

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

	Out.ar(out,Pan2.ar(Mix(filter)*env*amp*0.5,pan));

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




//      ///////////////////
//      // 4. DRUM SYNTHS//
//      ///////////////////
//
// 4.1. KICK

(
SynthDef(\kick, {
	arg out=0, amp=0.1, pan=0;
	var env0, env1, env1m, son;

	env0 =  EnvGen.ar(Env.new([0.5, 0.5, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]), doneAction:2);
	env1 =  EnvGen.ar(Env.new([110, 59, 29], [0.005, 0.29], [-4, -5]));
	env1m = env1.midicps;

	son = LFPulse.ar(env1m, 0, 0.5, 2, -0.5);
	son = son + WhiteNoise.ar(2);
	son = LPF.ar(son, env1m*1.5, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);

	son = FreeVerb.ar(son * 1.2, 0.2, 0.5);
	son = son.clip2(1);

	Out.ar(out, Pan2.ar(son * amp));
},
).add
)

// 4.1. KICK (2) (based on grirgz)

(
SynthDef(\kick2, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));

	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;

	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));

	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = son * env0;
	son = Pan2.ar(son, pan, amp);

	Out.ar(out, son);
}).add)

// 4.2. SNARE

SynthDef(\snare, {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

// 4.3. HH

SynthDef(\hihat, {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;




//      ////////////
//      // 5. MISC//
//      ////////////
//
// 5.1. HARSH

(
SynthDef(\harsh, { | out=0, amp=0.1|
	var sig, c, d, n, e, f;

	c = SinOsc.ar(20) * Env.perc(0.01,0.2).ar(0, TDuty.ar(Dseq([1/4,1/2,1/8,1/8],inf)));
	5.do{ c = (c.distort + c)*0.75};
	c = c * 4;
	d = LPF.ar(Saw.ar([20,47]).sum , XLine.ar(1000,200,0.5)) * Env.perc.ar(0, Impulse.ar(1/16)) * 0.5;
	d = (GVerb.ar( d , roomsize:10, revtime:6) * 200).clip(-1.0,1.0) * 0.3;
	n = 12;
	e = ( Saw.ar( 40*(1..n) * ({ LFNoise1.ar(0.1).range(1,1.01) } ! n) ) *
		({ LFNoise1.ar(0.1).range(0.0,1.0) }!n)).sum * 60;
	e = CombC.ar(e, 0.1, 0.1, 4) + e;
	e = e.tanh * 0.3 * SinOsc.ar(0.05).range(0.5,1.0);
	e = e.dup;
	e = e * SinOsc.ar(0.01).range(0.2,1.0) * 0.5;
	f = Blip.ar(100) * Blip.ar(100) * Env([0.0,0.0,1.0],[8,8],[\step,\linear,\step])
	.ar(0, Impulse.ar(1/32)) * 2 ;
	sig = (( c + f) ! 2) + d + e;
	sig = sig.tanh * 0.5;
	sig = sig * amp;
	Out.ar(out, sig);

}).add
)

// 5.2. VINYL

(
SynthDef(\vinyl, { | out=0, amp= 0.5, rel=0, dur=1, power=1, fade = 0|
	    var sig;
	    var adsr = EnvGen.ar(Env.linen(dur,rel,0),doneAction:2);
		sig = BPF.ar(Dust2.ar(2,0.8)+Dust2.ar(7,0.4)+VarSaw.ar(17,0.2,0.5, power)+Dust2.ar(33,0.1)+Dust2.ar(10,0.05),        600)!2;
	    sig = FreeVerb.ar(sig * amp, 0.3);
	    Out.ar(out, XFade2.ar(sig * adsr, LPF.ar(sig * adsr, 600), fade, 1));
	    sig = sig.tanh;
}).add
)


.play;
Ndef(\x,{a=SinOsc.ar(65,Ndef(\x).ar*LFNoise1.ar(0.1,3),LFNoise1.ar(3,6)).tanh;9.do{a=AllpassL.ar(a,0.3,{0.2.rand+0.1}!2,5)};a.tanh}).play




