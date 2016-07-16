package haxe.ui;

import haxe.ui.assets.FontInfo;
import haxe.ui.assets.ImageInfo;
import haxe.ui.util.ByteConverter;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.utils.ByteArray;

class AssetsBase {
    public function new() {

    }

    private function getTextDelegate(resourceId:String):String {
        if (Assets.exists(resourceId) == true) {
            return Assets.getText(resourceId);
        }
        return null;
    }

    private function getImageInternal(resourceId:String, callback:ImageInfo->Void):Void {
        if (Assets.exists(resourceId) == true) {
            var bmpData:BitmapData = Assets.getBitmapData(resourceId);
            var imageInfo:ImageInfo = {
                data: bmpData,
                width: bmpData.width,
                height: bmpData.height
            }
            callback(imageInfo);
        } else {
            callback(null);
        }
    }

    private function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        var ba:ByteArray = ByteConverter.fromHaxeBytes(bytes);
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e) {
            if (loader.content != null) {
                var bmpData = cast(loader.content, Bitmap).bitmapData;
                var imageInfo:ImageInfo = {
                    data: bmpData,
                    width: bmpData.width,
                    height: bmpData.height
                }
                callback(resourceId, imageInfo);
            }
        });
        loader.loadBytes(ba);

    }

    private function getFontInternal(resourceId:String, callback:FontInfo->Void):Void {
        callback(null);
    }

    private function getFontFromHaxeResource(resourceId:String, callback:String->FontInfo->Void) {
        callback(resourceId, null);
    }
}
