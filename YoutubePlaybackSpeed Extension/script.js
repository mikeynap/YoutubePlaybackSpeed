var videoSpeeds = {}

function getPlaybackSpeedFor(owner){
    if (owner in videoSpeeds){
        return videoSpeeds[owner];
    }
    if ("*" in videoSpeeds){
        return videoSpeeds["*"];
    }
    return 1.0;
}

function updateVideoSpeed(){
    var el = document.getElementById("owner-container");
    if (!el){
        return;
    }
    var video = document.getElementsByTagName("video");
    if (video.length < 1){
        return;
    }
    
    video = video[0];
    
    var owner = el.getElementsByTagName("a");
    if (owner.length == 0 || owner[0].innerText.length < 2){
        return;
    }
    owner = owner[0].innerText.toLowerCase();
    var playback = getPlaybackSpeedFor(owner);
    if (playback != 1.0){
        video.playbackRate = playback;
    }
}

safari.self.addEventListener("message", function(event){
                             videoSpeeds = event.message;
});

safari.extension.dispatchMessage("gimmeUpdate");
document.addEventListener("DOMContentLoaded", updateVideoSpeed); // one-time early processing

(document.body || document.documentElement).addEventListener('transitionend',
  function(/*TransitionEvent*/ event) {
    if (event.propertyName === 'transform' && event.target.className === 'ytp-load-progress') {
        updateVideoSpeed();
    }
}, true);
