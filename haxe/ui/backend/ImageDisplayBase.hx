package haxe.ui.backend;

import openfl.display.BitmapData;
import haxe.ui.assets.ImageInfo;
import haxe.ui.core.Component;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class ImageDisplayBase extends Sprite {
    public var parentComponent:Component;
    public var aspectRatio:Float = 1; // width x height
    private var _bmp:Bitmap;

    public function new() {
        super();
    }

    public var left(get, set):Float;
    private function get_left():Float {
        return this.x;
    }
    private function set_left(value:Float):Float {
        this.x = value;
        return value;
    }

    public var top(get, set):Float;
    private function get_top():Float {
        return this.y;
    }
    private function set_top(value:Float):Float {
        this.y = value;
        return value;
    }

    public var imageWidth(get, set):Float;

    private var _imageWidth:Float = 0;
    public function get_imageWidth():Float {
        return _imageWidth;
    }
    private function set_imageWidth(value:Float):Float {
        if(Math.abs(_imageWidth - value) > 0.00001) // float comparison
        {
            _imageWidth = value;

            if(containsBitmapDataInfo()) {
                _bmp.width = value;
            }
            #if svg
            else if(containsSVGInfo()) {
                invalidateSVG();
            }
            #end
        }

        return value;
    }

    public var imageHeight(get, set):Float;

    private var _imageHeight:Float = 0;
    public function get_imageHeight():Float {
        return _imageHeight;
    }
    private function set_imageHeight(value:Float):Float {
        if(Math.abs(_imageHeight - value) > 0.00001) // float comparison
        {
            _imageHeight = value;

            if(containsBitmapDataInfo()) {
                _bmp.height = value;
            }
            #if svg
            else if(containsSVGInfo()) {
                invalidateSVG();
            }
            #end
        }

        return value;
    }

    private var _imageInfo:ImageInfo;
    public var imageInfo(get, set):ImageInfo;
    private function get_imageInfo():ImageInfo {
        return _imageInfo;
    }
    private function set_imageInfo(value:ImageInfo):ImageInfo {
        if(_imageInfo != value)
        {
            if(_imageInfo != null)
            {
                if (_bmp != null && contains(_bmp) == true) {
                    removeChild(_bmp);
                    //_bmp.bitmapData.dispose();
                    _bmp = null;
                }
                else
                {
                    graphics.clear();
                }
            }

            _imageInfo = value;

            if(value != null)
            {
                aspectRatio = value.width / value.height;
                if(containsBitmapDataInfo())
                {
                    _bmp = new Bitmap(_imageInfo.data);
                    _imageWidth = _bmp.width;
                    _imageHeight = _bmp.height;
                    addChild(_bmp);
                }
                #if svg
                else if(containsSVGInfo())
                {
                    var svg:format.SVG = cast _imageInfo.data;
                    _imageWidth = svg.data.width;
                    _imageHeight = svg.data.height;
                    renderSVG();
                }
                #end
            }
            else
            {
                _imageWidth = 0;
                _imageHeight = 0;
            }
        }

        return value;
    }

    public function dispose():Void {
        if (_bmp != null) {
            //_bmp.bitmapData.dispose();
        }
    }

    private inline function containsBitmapDataInfo():Bool {
        return _imageInfo != null && Std.is(_imageInfo.data, BitmapData);
    }

    #if svg

    private var _svgInvalid:Bool = false;   //avoid multiple calls at the same frame

    private inline function containsSVGInfo():Bool {
        return _imageInfo != null && Std.is(_imageInfo.data, format.SVG);
    }

    private function invalidateSVG():Void {
        if(_svgInvalid == false) {
            _svgInvalid = true;

            haxe.Timer.delay(renderSVG, 0);
        }
    }

    private function renderSVG():Void {
        graphics.clear();
        if(_imageInfo != null && imageWidth > 0 && imageHeight > 0)
        {
            var svg:format.SVG = cast _imageInfo.data;
            svg.render(graphics, 0, 0, Std.int(imageWidth), Std.int(imageHeight));
        }

        _svgInvalid = false;
    }

    #end
}