package haxe.ui.backend;

import openfl.Lib;
import openfl.events.Event;

class CallLaterBase {
    private var _fn:Void->Void;
    
    public function new(fn:Void->Void) {
        _fn = fn;
        Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function onEnterFrame(e) {
        Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        _fn();
    }
}
