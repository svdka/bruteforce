(

// SYNTHDEFS // UNIFIED SYNTAX
// 1. SAMPLE-BASED
// 1.1. READ SOUND FILE
// 1.2. 
// 1.3.
// 1.4.
// 1.5.
// 2.  CLASSIC-INSTRUMENTS
// 2.1 ACCOUSTIC GUITAR
// 2.2 TAP GUITAR
// 2.3 ELECTRIC GUITAR
// 2.4 ORGAN

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


)
