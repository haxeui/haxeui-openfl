package haxe.ui.backend;

class AppImpl extends AppBase {
    public function new() {
    }

    private override function init(onReady:Void->Void, onEnd:Void->Void = null) {
        onReady();
    }
}
