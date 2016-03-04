// S E T U P //
//           //
// S E T U P //


// MISC
Platform.userExtensionDir

// test
{ SinOsc.ar(XLine.kr(2000, 200), 0, 0.5) }.play;


// BOOT
JITLib extensions.include;
s.meter
s.makeWindow

// PROXYSPACE BOOT
(
Server.local.options.memSize * 128;
s.options.numBuffers=4000;
s.boot;
p=ProxySpace.push(s);
p.makeTempoClock;
p.clock.tempo = 130/60;
)


s.quit
s.killAll
ProxyMixer.new
