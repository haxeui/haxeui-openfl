package haxe.ui.backend;
import haxe.ui.Preloader.PreloadItem;

class AppBase {
    public function new() {

    }

    private function build() {

    }

    private function init(onReady:Void->Void, onEnd:Void->Void = null) {
        onReady();
    }

    private function getToolkitInit():Dynamic {
        return {
        };
    }

    public function start() {

    }
    
    private function buildPreloadList():Array<PreloadItem> {
        return [];
    }
}
