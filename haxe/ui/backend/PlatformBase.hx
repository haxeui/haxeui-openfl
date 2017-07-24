package haxe.ui.backend;

import flash.system.Capabilities;
class PlatformBase {
    private var _systemLocale:String = Capabilities.language;

    public function getMetric(id:String):Float {
        return 0;
    }
}