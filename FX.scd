
// EXEMPLE DE

~verb = {Out.ar(0, FreeVerb.ar(InFeedback.ar(40, 2), 0.5, 0.5, mul:1))}


// FX

// 1.1 REVERB
// 1.2 DELAY
// 1.3 STUTTER
// 1.4 SCRAMBLER
// 1.5 CHORUS & COMPRESSION
//
//
//
//
//
//
//


// 1.3 STUTTER

(
{ |holdlength = 0.5, fragmentlength = 0.2, rate = 1.5|
    var reset, phase, fragment, del, snd;
    snd = Pulse.ar(XLine.kr(100, 1000, 5));
    reset = Impulse.ar(holdlength.reciprocal);
    phase = Sweep.ar(reset);
    fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentlength % 1);
    del = Latch.ar(phase, fragment) + ((fragmentlength - Sweep.ar(fragment)) * (rate - 1));
    snd = DelayC.ar(snd, 10, del);
    snd * 0.1!2;
}.play;
)

// 1.4 SCRAMBLER

(
{
    var snd;
    snd = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
    snd = DelayC.ar(snd, 1.0, LFNoise0.ar(13).range(0.0, 1.0));
    snd!2 * 0.3;
}.play;
)

// 1.5 CHORUS & COMPRESSION
(
SynthDef(\choruscompresseffect, {|out =0 gate= 1|
	var source = In.ar(0,2);
	var chorus;
	var env = Linen.kr(gate, 0.1, 1, 0.1, 2);

	chorus= Splay.ar(Array.fill(4,{
		var maxdelaytime= rrand(0.005,0.02);

		DelayC.ar(source[0], maxdelaytime,LFNoise1.kr(Rand(0.1,0.6),0.25*maxdelaytime,0.75*maxdelaytime) )
	}));

	chorus = Compander.ar(4*(source + chorus),source,0.4,1,4);

	XOut.ar(out,env,chorus);

}).add;


)


(
SynthDef(\reverb, {|out=0, gate=1|
	var source = In.ar(0, 2);
	var reverb = FreeVerb.ar(source, 0.5, 0.5, 0.5, 2);
	Out.ar(0, reverb);
}).add;
)

	