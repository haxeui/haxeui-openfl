package haxe.ui.backend;

class CallLaterBase {
    public function new(fn:Void->Void) {
        haxe.ui.util.Timer.delay(fn, 0);
    }
}
