package haxe.ui.backend;

import haxe.io.Path;
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
        var imageInfo:ImageInfo = null;
        if (Assets.exists(resourceId) == true) {
            if(Path.extension(resourceId).toLowerCase() == "svg") {
                #if svg
                var content:String = Assets.getText(resourceId);
                var svg = new format.SVG(content);
                imageInfo = {
                    data: svg,
                    width: Std.int(svg.data.width),
                    height: Std.int(svg.data.height)
                };
                #else
                trace("WARNING: SVG not supported");
                #end
            }
            else {
                var bmpData:BitmapData = Assets.getBitmapData(resourceId);
                imageInfo = {
                    data: bmpData,
                    width: bmpData.width,
                    height: bmpData.height
                }
            }
        }

        callback(imageInfo);
    }

    private function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        var ba:ByteArray = ByteConverter.fromHaxeBytes(bytes);
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e) {
            if (loader.content != null) {
                var imageInfo:ImageInfo = null;
                if(Path.extension(resourceId).toLowerCase() == "svg") {
                    #if svg
                    var bytes = Resource.getBytes(resourceId);
                    var content:String = bytes.getString(0, bytes.length);
                    var svg = new format.SVG(content);
                    imageInfo = {
                        data: svg,
                        width: Std.int(svg.data.width),
                        height: Std.int(svg.data.height)
                    }
                    #else
                    trace("WARNING: SVG not supported");
                    #end
                }
                else {
                    var bmpData = cast(loader.content, Bitmap).bitmapData;
                    imageInfo = {
                        data: bmpData,
                        width: bmpData.width,
                        height: bmpData.height
                    }
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
