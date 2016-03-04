// LIVE TEST FILE // 
// 1. OPEN SETUP, BOOT 
// 2. MAKE SURE SAMPLES ARE IN CORRECT PATH
// 3. TRY THIS PIECE OF CODE

(
~snare = Pbind(
	\instrument, \readsf,
	\buf,d[\cy_8][0],
	\amp, 0.1,
	\dur, 1,
))

~snare.play
~snare.free

