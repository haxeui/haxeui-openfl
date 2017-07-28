package haxe.ui.backend;

import haxe.ui.util.Timer;

class CallLaterBase {
    private var _timer:Timer = null;
    public function new(fn:Void->Void) {
        _timer = new Timer(0, function() {
            if (_timer != null) {
                _timer.stop();
                _timer = null;
                fn();
            }
        });
    }
}
