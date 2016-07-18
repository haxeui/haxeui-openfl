package haxe.ui.backend;

import haxe.Timer;

class TimerBase {
    private var _timer:Timer;

    public function new(delay:Int, callback:Void->Void) {
        _timer = new Timer(delay);
        _timer.run = function() {
            callback();
        }
    }

    public function stop() {
        _timer.stop();
    }
}