function play_sequence(a,b,c,d,e,f,g,h,i,j) {
    alert([a,b,c,d,e,f,g,h,i,j].join());
    var audio = new buzz.group(
        new buzz.sound("/audio/" + a),
        new buzz.sound("/audio/" + b),
        new buzz.sound("/audio/" + c),
        new buzz.sound("/audio/" + d),
        new buzz.sound("/audio/" + e),
        new buzz.sound("/audio/" + f),
        new buzz.sound("/audio/" + g),
        new buzz.sound("/audio/" + h),
        new buzz.sound("/audio/" + i),
        new buzz.sound("/audio/" + j));
    audio.play();
}
