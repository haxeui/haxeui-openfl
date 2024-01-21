package haxe.ui.backend;

import haxe.io.Bytes;
import haxe.io.Path;
import haxe.ui.assets.FontInfo;
import haxe.ui.assets.ImageInfo;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.utils.ByteArray;

class AssetsImpl extends AssetsBase {
    private override function getTextDelegate(resourceId:String):String {
        if (Assets.exists(resourceId) == true) {
            return Assets.getText(resourceId);
        } else if (Resource.listNames().indexOf(resourceId) != -1) {
            return Resource.getString(resourceId);
        }
        return null;
    }

    private override function getImageInternal(resourceId:String, callback:ImageInfo->Void):Void {
        if (Assets.exists(resourceId) == true) {
            if(Path.extension(resourceId).toLowerCase() == "svg") {
                #if svg
                var content:String = Assets.getText(resourceId);
                var svg = new format.SVG(content);
                var imageInfo:ImageInfo = {
                    svg: svg,
                    width: Std.int(svg.data.width),
                    height: Std.int(svg.data.height)
                };
                callback(imageInfo);
                #else
                trace("WARNING: SVG not supported");
                #end
            } else {
                Assets.loadBitmapData(resourceId).onComplete(function(bmpData:BitmapData) {
                    var imageInfo:ImageInfo = {
                        data: bmpData,
                        width: bmpData.width,
                        height: bmpData.height
                    }
                    callback(imageInfo);
                });
            }
        } else {
            callback(null);
        }
    }

    private override function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        var imageInfo:ImageInfo = null;
        if (Path.extension(resourceId).toLowerCase() == "svg") {
            #if svg
            var svgContent = Resource.getString(resourceId);
            var svg = new format.SVG(svgContent);
            imageInfo = {
                svg: svg,
                width: Std.int(svg.data.width),
                height: Std.int(svg.data.height)
            }
            #else
            trace("WARNING: SVG not supported");
            #end

            callback(resourceId, imageInfo);
            return;
        }

        var bytes = Resource.getBytes(resourceId);
        imageFromBytes(bytes, function(imageInfo) {
            callback(resourceId, imageInfo);
        });
    }

    public override function imageFromBytes(bytes:Bytes, callback:ImageInfo->Void):Void {
        var ba:ByteArray = ByteArray.fromBytes(bytes);
        var loader:Loader = new Loader();
        var onCompleteEvent = null;
        onCompleteEvent = function(e) {
            if (loader.content != null) {
                var bmpData = cast(loader.content, Bitmap).bitmapData;
                var imageInfo:ImageInfo = {
                    data: bmpData,
                    width: bmpData.width,
                    height: bmpData.height
                }

                callback(imageInfo);
            }
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteEvent);
        };
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteEvent, false, 0, false);
        loader.contentLoaderInfo.addEventListener("ioError", function(e) {
            trace(e);
            callback(null);
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteEvent);
        }, false, 0, true);
        loader.loadBytes(ba);
    }
    
    private override function getFontInternal(resourceId:String, callback:FontInfo->Void):Void {
        var fontInfo = null;
        if (isEmbeddedFont(resourceId) == true) {
            if (Assets.exists(resourceId)) {
                fontInfo = {
                    data: Assets.getFont(resourceId).fontName
                }
            } else if (Resource.listNames().indexOf(resourceId) != -1) {
                getFontFromHaxeResource(resourceId, function(r, info) {
                    callback(info);
                });
            } else {
                fontInfo = {
                    data: resourceId
                }
            }
        } else {
            fontInfo = {
                data: resourceId
            }
        }
        callback(fontInfo);
    }

    private override function getFontFromHaxeResource(resourceId:String, callback:String->FontInfo->Void) {
        var bytes = Resource.getBytes(resourceId);
        if (bytes == null) {
            callback(resourceId, null);
            return;
        }
        
        #if (js && html5)
        
        loadWebFontFontResourceDynamically(resourceId, bytes, callback);
        
        #else
        
        var font = openfl.text.Font.fromBytes(bytes);
        openfl.text.Font.registerFont(font);
        var fontInfo = {
            data: font.fontName
        }
        callback(resourceId, fontInfo);
        
        #end
    }
    
    #if (js && html5)
    private function loadWebFontFontResourceDynamically(resourceId:String, bytes:Bytes, callback:String->FontInfo->Void) {
        var fontFamilyParts = resourceId.split("/");
        var fontFamily = fontFamilyParts[fontFamilyParts.length - 1];
        if (fontFamily.indexOf(".") != -1) {
            fontFamily = fontFamily.substr(0, fontFamily.indexOf("."));
        }
        
        var fontFace = new js.html.FontFace(fontFamily, bytes.getData());
        fontFace.load().then(function(loadedFace) {
            js.Browser.document.fonts.add(loadedFace);
            haxe.ui.backend.openfl.util.FontDetect.onFontLoaded(fontFamily, function(f) {
                var fontInfo = {
                    data: fontFamily
                }
                callback(resourceId, fontInfo);
            }, function(f) {
                callback(resourceId, null);
            });
        }).catchError(function(error) {
            #if debug
            trace("WARNING: problem loading font '" + resourceId + "' (" + error + ")");
            #end
            // error occurred
            callback(resourceId, null);
        });
    }
    #end
    
    
    public override function imageInfoFromImageData(imageData:ImageData):ImageInfo {
        return {
            data: imageData,
            width: imageData.width,
            height: imageData.height
        }
    }
    
    //***********************************************************************************************************
    // Util functions
    //***********************************************************************************************************

    private static inline function isEmbeddedFont(name:String) {
        return (name != "_sans" && name != "_serif" && name != "_typewriter");
    }
}
