// S E T U P //
//           //
// S E T U P //


// MISC - CHECK EXTENSIONS PATH
Platform.userExtensionDir

// SIN SOUND TEST
{ SinOsc.ar(XLine.kr(2000, 200), 0, 0.5) }.play;

// PROXYSPACE, BOOT, SYNTHDEFS 
(
Server.local.options.memSize * 128;
s.options.numBuffers=4000;
s.boot;
p=ProxySpace.push(s);
p.makeTempoClock;
p.clock.tempo = 130/60;
)
// MISC QUIT

s.quit
s.killAll
