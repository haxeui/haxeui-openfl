package haxe.ui.backend.openfl;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class BitmapCache {
    private static var _instance:BitmapCache;
    public static var instance(get, null):BitmapCache;
    private static function get_instance():BitmapCache {
        if (_instance == null) {
            _instance = new BitmapCache();
        }
        return _instance;
    }

    public static function rectId(rc:Rectangle):String {
        return rc.left + "_" + rc.top + "_" + rc.width + "_" + rc.height;
    }

    private var _cache:Map<String, BitmapData>;
    public function new() {
        _cache = new Map<String, BitmapData>();
    }


    public function get(id:String):BitmapData {
        var bmpData:BitmapData = _cache.get(id);
        return bmpData;
    }

    public function set(id:String, bmpData:BitmapData) {
        _cache.set(id, bmpData);
    }
}