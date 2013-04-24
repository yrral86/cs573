function play_sequence(a,b,c,d,e,f,g,h,i,j) {
    var sounds = []
    sounds[0] = new buzz.sound("/audio/" + a);
    sounds[1] = new buzz.sound("/audio/" + b);
    sounds[2] = new buzz.sound("/audio/" + c);
    sounds[3] = new buzz.sound("/audio/" + d);
    sounds[4] = new buzz.sound("/audio/" + e);
    sounds[5] = new buzz.sound("/audio/" + f);
    sounds[6] = new buzz.sound("/audio/" + g);
    sounds[7] = new buzz.sound("/audio/" + h);
    sounds[8] = new buzz.sound("/audio/" + i);
    sounds[9] = new buzz.sound("/audio/" + j);
    for (var i = 0; i < 10; i++) {
	setTimeout(function(sound) {
	    sound.play();
	},i*1500, sounds[i]);
    }
}
