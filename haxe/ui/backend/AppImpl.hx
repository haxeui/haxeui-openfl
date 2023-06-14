package haxe.ui.backend;

import haxe.ui.events.AppEvent;

class AppImpl extends AppBase {
    public function new() {
    }

    private override function init(onReady:Void->Void, onEnd:Void->Void = null) {
        openfl.Lib.current.stage.application.onExit.add(function(_) {
            dispatch(new AppEvent(AppEvent.APP_EXITED));
        });
        onReady();
    }
}
