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
// 2.1. ACCOUSTIC GUITAR (accoustic)
// 2.2. DAF_BASS (daf_bass)
// 2.3. FILTER BASS (bass_filtered)
// 2.4  SAW BASS (bass_saw)
// 2.3. BELL                              (freq = 261, tone = 4, art = 1, amp = 0.8, pan = 0)
// 2.4. S.O.S BELL (Based on D.Stowell)
// 2.5.
// 2.6. PIANO
// 2.7  SOUND AND SOUND PIANO (piano_ss)
// 2.8  ELECTRIC
// 2.9  SOUND SOUND PIANO
// 2.10

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
// 3.9. CLEANSIN


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
//      // 6. FX         //
//      ///////////////////
//
// 6.1 REVERB (fx_reverb)
// 6.2 CHORUS/COMPRESSION (fx_chorus)
// 6.3 BITCRUSHER (fx_bit)
// 6.4 DELAY

// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //




//      ///////////////////
//      //1. SAMPLE BASED//
//      ///////////////////
//
// 1.1 READ SOUND FILE


// TO DO : add frequency shift
SynthDef(\readsf,
	{arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15, freq=440;
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


// 1.4. READ SOUND FILE GRANULATOR

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


SynthDef(\readsfsinfx,
	{arg out = 0, buf = 0, amp = 0.5, pan = 0, pos = 0, rel=15, heartrate=5;
		var sig,env ;
	//	var rate = SinOscFB.ar(heartrate, 0.5, 1);
		var rate = SinOsc.ar(heartrate, 0.1, 1);
		sig = Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = FreeVerb.ar(sig * env, 0.33, 0.5,0.5);
		sig = sig * amp;
		Out.ar(out,sig);
}).add;




//      //////////////////////////
//      //2. CLASSIC INSTRUMENTS//
//      //////////////////////////
//
// 2.1. ACCOUSTIC GUITAR


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


// 2.2. DAF_BASS

SynthDef(\daf_bass,{ |out, freq=440, sustain=1, gate=1, amp=0.5|
	var snd, env, fenv, harm;

	harm = [1,1.01,2,2.02,3.5,4.01,5.501];
	harm = harm ++ (harm*2);

	snd = SinOsc.ar(freq*harm).sum.distort.squared * 6;
	snd = snd + SinOsc.ar(freq / [1, 2]).sum!2;

	fenv = EnvGen.kr(Env.adsr(0.075,0.05,0.1,0.25));

	snd = RLPF.ar(snd, fenv.range(freq*2, freq*8), 0.75, 2) + (snd * 0.25);
	env = EnvGen.kr(Env.adsr(0.001,0.2,0.9,0.25), gate, amp, doneAction:2);
	snd = FreeVerb.ar(snd, 0.33, 1);
	snd = LeakDC.ar(Limiter.ar(snd * env), 0.995);
	OffsetOut.ar(out, (snd!2 * amp));
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

	OffsetOut.ar(out, (snd!2 * amp ));
}).add;

// 2.4. Saw Bass


SynthDef(\saw_bass, { arg out=0, freq = 440, amp = 0.5, gate = 1;
	var snd, env, oscfreq, output;
	oscfreq = {freq * LFNoise2.kr(0.5).range(0.98, 1.02)}!3;
	snd = Splay.ar(LFSaw.ar(oscfreq, mul: amp));
	env = Env.adsr(0.7, 4, 0, 0.1).kr(doneAction:2, gate: gate);
	snd = snd;
	output = LPF.ar(snd, (env*freq) + 2*freq);
	Out.ar(out, output);
	}).add;

//  warning high level glitch

SynthDef(\bass2, { arg freq = 440, amp = 0.5, gate = 1;
	var snd, env, oscfreq, output;
	var lfo;
	oscfreq = {freq * LFNoise2.kr(Rand(0.0001,0.5)).range(0.98, 1.02)}!13;
	lfo = { SinOsc.kr({ 1/Rand(2,52) }!13) };
	env = Env.adsr(0.07, 1, 0.9, 0.1).kr(doneAction:2, gate: gate);
	output = LFSaw.ar(oscfreq, mul: lfo.value.range(0,1));
	output = RLPF.ar(output, (env*freq) + 1*freq * lfo.value.range(1/4,2), lfo.value.range(0.1,1));
	output = FreeVerb.ar(Splay.ar(output, lfo.value.range(0,1)), 0.5);
	output = output * env * amp;
	Out.ar(0, output);
	}).add;



// 2.5. Phase Modulated Bell


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


// 2.6. SOS Bell (Based on Dan Stowell Version)

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

// 2.7 PIANO


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
}).add;


// 2.8 SOUND ON SOUND PIANO

SynthDef(\piano_ss,{ | out=0, amp=1, trigger=1,punch=0.5,freq=440|
// HIGHER PART

var osc1 = SinOsc.ar(freq,0, 4).midicps;
var osc2 = SinOsc.ar(freq*0.99, 0, 4).midicps;
var osc3 = SinOsc.ar(freq*1.01, 0, 4).midicps;
var mixer = osc1 + osc2 + osc3;
var adsr = 	EnvGen.ar(Env.adsr( punch , 1 , 0 , 1));
var sig = mixer * adsr;

// LOWER PART
var osc4 = SinOsc.ar(freq, 0, 4);
var osc5 = SinOsc.ar(freq, 0, 4);
var mixer2 = osc4 + osc5;
var adsr2 = EnvGen.ar(Env.perc(punch, 1),doneAction:2);
var sig2  = mixer2 * adsr2;

// ADD STUFF UP
var	cutoff = EnvGen.ar(Env.perc(punch, freq));
var snd = sig + sig2;
var volamp = EnvGen.ar(Env.perc(0.01, 1000/freq, 1/freq));
    snd = LPF.ar(snd, cutoff + freq);
	snd = snd * volamp;
	snd = snd * amp;
	Out.ar(out, snd) ;
}
).add;


// 2.9 ELECTRIC

SynthDef(\electric, { arg out=0, amp=0.1, pan=0,gate=1, rel= 0.3, saw=12;
	var sig =  Saw.ar(12)*266666+CuspN.ar(100, 0.1)*0.00001;
	var sig2 = LFNoise0.ar(1/2).lag+2/[2.02,3]/99++9;
	var sig3 = BPF.ar(sig, 440, 4);
	var env =  EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
	sig3 =     FreeVerb.ar(CombN.ar(sig3, 1, sig2,9),0.25);
	sig3 =     sig3.sum.tanh!2;
	Out.ar(out, (sig3 * amp) * env);}).add;

// 2.10 RAYBASS

SynthDef(\raybass, {arg amp = 0.5, sinfreq = 200, glissf = 0.001, att = 0.01, rel = 0.9;
    var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
    var snd = SinOsc.ar(gliss);
    var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
    snd = snd * env * amp;
    Out.ar(0, snd);
}).add;

//      /////////////////////////////
//      //3. ELECTRONIC INSTRUMENTS//
//      /////////////////////////////
//
// 3.1. SAW


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


// 3.2. PROPHET


SynthDef(\prophet,{|out= 0 freq = 440 amp = 1.0 gate=1 lforate = 10 lfowidth= 0.5 cutoff= 12000 rq=0.5 pan = 0.0|
	var lfo, pulse, filter, env;
	lfo = LFTri.kr(lforate*[1,1.01],Rand(0,2.0)!2);
	pulse = Pulse.ar(freq*[1,1.01],lfo*lfowidth+0.5);
	filter = RLPF.ar(pulse,cutoff,rq);
	env = EnvGen.ar(Env.adsr(0.01,0.0,1.0,0.5),gate,doneAction:2);
	Out.ar(out,amp* (Pan2.ar(Mix(filter)*env*amp*0.5,pan)));

}).add;


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


SynthDef(\drone, { arg out = 0, speed = 1, amp = 0.5, rel = 0.5, dur = 1, freq=200;
	var base = LFNoise1;
    var adsr = EnvGen.ar(Env.linen(dur*4,rel,0, 1),doneAction:2);
	var sig =  HPF.ar(FreeVerb2.ar(*XFade2.ar(SinOscFB.ar([20,freq],base.ar(speed*2)+1/8),
	SinOscFB.ar([120,25],base.ar(speed)+1/2),base.ar(20))),220);
	sig = (sig * adsr) * amp;
	Out.ar(out, sig);
}).add;


// 3.5. DETUNED


SynthDef.new(\detuned, {
	arg freq = 440, freqf = 3000, atk = 0.1, rel = 0.1, pan=0, amp=0.5;
    var env, synth1, synth2;
    env = EnvGen.ar(Env.new([0, 1, 0], [atk, rel]), doneAction:2);
	synth1 = LPF.ar(Pulse.ar(freq, [0.4,0.6], mul:0.1), freqf)*env;
    synth2 = LPF.ar(Pulse.ar(freq, 0.6, mul:0.1), freqf)*env;
	Out.ar(0, amp * Splay.ar([synth1,synth2]));
}).add;



// 3.6. ORGAN


SynthDef(\organ,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 10 lfowidth= 0.0 cutoff= 100 rq=0.5 pan=0.0|

	var vibrato, pulse, filter, env;

	vibrato = SinOsc.ar(lforate,Rand(0,2.0));

	pulse = Mix(VarSaw.ar(([1,1.9953843530485,3.0139733629359]*freq)*(1.0+(lfowidth*vibrato)),Rand(0.0,1.0)!3,Rand(0.3,0.5)!3,[1.0,0.7,0.3]))*0.5;

	filter = RLPF.ar(pulse,cutoff,rq);

	env = EnvGen.ar(Env.adsr(0.01,0.5,1.0,0.5),gate,doneAction:2);

	Out.ar(out,Pan2.ar(filter*env*amp,pan));

}).add;




// 3.7. ACID FROM OTOPHILIA

	SynthDef(\acid, {
		arg out=0, gate=1, pitch=50, amp=0.1 ;
		var env1, env2, snd;
		pitch = Lag.kr(pitch, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
		env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp);
		env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 0, 0.8, 70, -4), gate);
		snd = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);

		snd = RLPF.ar(snd, (pitch + env2).midicps, 0.3);
		snd = snd * env1;

		Out.ar(out,snd);
	}).add(s);

	SynthDef("fx", {
		arg outBus=0, gate=0;
		var out;

		out = In.ar(outBus, 2);
		out = FreeVerb2.ar( BPF.ar(out[0], 3500, 1.5), BPF.ar(out[1], 3500, 1.5), 1.0, 0.95, 0.15) * EnvGen.kr(Env.new([0.02, 0.3, 0.02], [0.4, 0.01], [3, -4], 1), 1-Trig.kr(gate, 0.01)) + out;
		out = HPF.ar(out * 1.2, 40);
		out = Limiter.ar(out, 1.0, 0.02);

		ReplaceOut.ar(outBus, out);
	}).add;


// 3.8 SIMPLE PAD


SynthDef(\pad, { |out, freqScale=1, sustain=1, amp=0.1, saw=1|
	var snd = Klang.ar(`[ Array.exprand(4, 100, 1000), 0.05, nil ], freqScale)!2;
	snd = snd * EnvGen.ar(Env.sine(sustain), doneAction:2);
	OffsetOut.ar(out, snd * amp)
}).add;

// 3.9 Chicago pad by Headchant modified by grirgz



SynthDef(\chicagopad2, { |out = 0, freq = 440, freq2=660, freq3=528, cutoff = 500, amp = 0.2, gate=1|

    var snd;
    var delay = 0.045+0.05;

    freq = freq + SinOsc.kr(freq*1/2, 0, freq/2, 0);

    snd = Saw.ar([freq, freq+1, freq-1, freq2, freq3] * [0.99,1])*0.1;

    snd = snd + VarSaw.ar(0.99*[freq, freq+1, freq-1, freq2, freq3, freq2+1, freq3+1],0, LFTri.kr(7.13).range(0.00,0.1))*0.1;


    snd = Mix(snd);
    snd = FreeVerb.ar(snd, 0.51,10,0.1)*2;
    snd = snd *8;
    snd = RLPF.ar(snd, SinOsc.kr([0.1,4.2], 0, [1700,480], [4000,700,5000])/[20.51,20], SinOsc.ar(0.1,1.5*pi)+1.05)/3;
    snd = Mix(snd);

    snd = MoogFF.ar(snd, SinOsc.kr(0.08, 0.5, cutoff/10, cutoff), 3, 0);

    snd = snd * EnvGen.ar(Env.dadsr(delay,0.4, 0.01,0.8,0.4), gate, doneAction:2);
    //snd = snd * EnvGen.ar(Env.adsr(0.4, 0.01,0.8,0.4), gate, doneAction:2);

    snd = [snd , AllpassC.ar(snd, delay, 0.05+SinOsc.ar(0.11).range(0,0.045), 0.3)];
    snd = snd * amp;
    Out.ar(out, snd);

}).add;


// 3.8 Sin w/t Mod (cleansin)

SynthDef(\cleansin, { arg freq = 440, modfreq = 1, amp = 0.5, attack = 0.01, release = 0.1, pos = 0, gate = 1;
	var carrier, modulator, env;
	modulator = SinOsc.kr(modfreq).range(0, 1); // provides amplitude modulation for wobble
	carrier = LFTri.ar(freq: freq, mul: modulator); // provides triangle wave for an interesting harmonic
	env = Env.asr(
		attackTime: attack,
		sustainLevel: amp,
		releaseTime: release).kr(doneAction: 2, gate: gate);
	carrier = carrier * env;
	Out.ar(0, Pan2.ar(carrier, pos))
}).add;




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


SynthDef(\vinyl, { | out=0, amp= 0.5, rel=0, dur=1, power=1, fade = 0, cracks=8, bpfvalue=600|
	    var sig;
	    var adsr = EnvGen.ar(Env.linen(dur,rel,0),doneAction:2);
		sig = BPF.ar(Dust2.ar(cracks,0.8)+Dust2.ar(cracks,0.4)+VarSaw.ar(17,0.4,0.5, power)+Dust2.ar(cracks/4,0.1)+Dust2.ar(10,0.05),        bpfvalue)!2;
	    sig = FreeVerb.ar(sig * amp, 0.2, 0.8, 0.5, 2);
	    Out.ar(out, XFade2.ar(sig * adsr, LPF.ar(sig * adsr, bpfvalue), fade, 1));
	    sig = sig.tanh;
}).add;

SynthDef(\vinyl2, { | out=0, amp= 0.5, rel=0, dur=1, power=1, fade = 0, cracks=8, bpfvalue=600, power2=60, multiply=0|
	    var sig;
	    var adsr = EnvGen.ar(Env.linen(dur,rel,0),doneAction:2);
	sig = BPF.ar(Dust2.ar(cracks,0.8)+Dust2.ar(cracks,0.4)+VarSaw.ar(17,SinOscFB.ar(20),0.2, power)+Dust2.ar(cracks/4,0.1)!2 + (multiply *LPF.ar(FreeVerb.ar(VarSaw.ar(power2,LFPulse.ar(10, 0, 0.5, 5),0.823),SinOsc.ar(3, 0.5)),)),bpfvalue)!2;
	    sig = FreeVerb.ar(sig * amp, 0.2, 0.8, 0.5, 4);
	    Out.ar(out, XFade2.ar(sig * adsr, LPF.ar(sig * adsr, bpfvalue), fade, 1));
	    sig = sig.tanh;
}).add;





// STEP 3




SynthDef(\densedrops, { | out=0, amp=0.5 |
	var freq, vib, r;
	var sound;
	var env;

	freq = LFCub.kr(LFCub.kr(0.2, 0, 8, 10));

	vib = BPF.kr(PinkNoise.kr, freq, 0.3) * 10;

	r = TRand.kr(
		100, 100,
		LFSaw.kr(vib, 0, 2, 30)
	);

	sound = BPF.ar( WhiteNoise.ar(1), r/3 );

	sound = Decay.ar(
		Impulse.ar(XLine.kr(10, 20, 4)),
		0.2,
		sound
	);

	sound = OnePole.ar(
		sound,
		FSinOsc.kr(Line.kr(0.1, 5, 10))
	);

	sound = Pan2.ar(
		sound,
		FSinOsc.kr(3),
		1.0
	);

	env = EnvGen.ar(
		Env.linen(0.8, 0.5, 4.0, 1, \welch),
		doneAction: 2
	);

	sound = sound * amp;
	Out.ar(out, sound * env);
}).add;


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
}).add;


// NOISE CYMBAL

SynthDef(\sinbal, {	| out=0, amp = 1, octave=8.0 |
	var noise, tempo;
	var sound;
	var env;

	noise = HPF.ar(WhiteNoise.ar(0.2), 1000);

	tempo = SinOsc.kr(0, 1, 0, 3800);

	sound = RHPF.ar(noise, tempo, 1000) * 0.1;

	env = EnvGen.ar(
		Env.perc(0.01, 2),
		doneAction: 2
	);

	Out.ar(out, amp * (sound * env));
}).add;

SynthDef(\echo, { | freq = 1200, amp=0.5, out=0 |
	var sound;
	var env;
	var envpitch;
	// envpitch = EnvGen.ar(Env.adsr(0.1, 0.0001));
	//
	// sound = RLPF.ar(BrownNoise.ar(1), freq * envpitch, 0.001) * 1;
	sound =    RLPF.ar(BrownNoise.ar(1), freq , 0.015,1) * 1;

	2.do{|i|
		sound = DelayN.ar(sound, 0.5, 0.1*i, 0, sound * amp);
	};

	env = EnvGen.ar(
		Env.perc(0.01, 3, 1, -4),
		doneAction: 2
	);
	sound = FreeVerb.ar(sound, 0.1, 0.4, 2);
	Out.ar(out, sound * env);
}).add;





// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //
// 6. EFFECTS
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //


// 6.1. REVERB



SynthDef(\reverb, {|out=0, gate=1|
	var source = In.ar;
	var reverb = FreeVerb.ar(source, 0.5, 0.5, 0.5, 2);
	Out.ar(0, reverb);
}).add;









)
//
//
// {l=LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j**[2,2.1],k),[0.05,0.03],j);LocalOut.ar(s);s}.play;
//
//
// {l = LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j**l.abs,k),[0.05,0.03],j);5.do{s=s.tanh+(s*0.1)};LocalOut.ar(s);s}.play;
//
//
//
// SynthDef(\localin, {|out=0, gate=1|
// 	var feedback = LocalIn.ar(2);
// 	var signal =   LFSaw.ar(feedback, 0, feedback, 1);
// 	var signal2 =  signal.range(0.25, 4.0);
// 	var signal3 =  PitchShift.ar(SinOscFB.ar(signal2**feedback.abs,signal2),[0.05,0.03],signal2);
// 	var signal4 =  signal3.tanh+(signal3*0.1);
// 	Out.ar(0, signal4);
// }).play;
//
//
//
