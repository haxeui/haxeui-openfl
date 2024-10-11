package haxe.ui.backend;

import haxe.ui.geom.Rectangle;
import haxe.ui.styles.Style;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class ImageDisplayImpl extends ImageBase {
    public var sprite:Sprite;

    private var _bmp:Bitmap;

    public function new() {
        super();
        sprite = new Sprite();
        sprite.mouseEnabled = true;
    }

    public override function dispose():Void {
        if (_bmp != null) {
            //_bmp.bitmapData.dispose();
            sprite.removeChild(_bmp);
            _bmp = null;
        }
        super.dispose();
    }

    private inline function containsBitmapDataInfo():Bool {
        return _imageInfo != null && _imageInfo.data != null && (_imageInfo.data is BitmapData);
    }

    #if svg

    private inline function containsSVGInfo():Bool {
        return _imageInfo != null && _imageInfo.svg != null && (_imageInfo.svg is format.SVG);
    }

    private function renderSVG():Void {
        sprite.graphics.clear();
        if(_imageInfo != null && _imageWidth > 0 && _imageHeight > 0) {
            var svg:format.SVG = cast _imageInfo.svg;
            svg.render(sprite.graphics, 0, 0, Std.int(_imageWidth), Std.int(_imageHeight));
        }
    }

    #end

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private override function validateData() {
        if (_imageInfo != null) {
            if(containsBitmapDataInfo()) {
                if (_bmp == null) {
                    _bmp = new Bitmap(_imageInfo.data);
                    sprite.addChild(_bmp);
                } else {
                    _bmp.bitmapData = _imageInfo.data;
                }
                _imageWidth = _bmp.width;
                _imageHeight = _bmp.height;
                _bmp.smoothing = true;
            }
            #if svg
            else if(containsSVGInfo()) {
                var svg:format.SVG = cast _imageInfo.svg;
                _imageWidth = svg.data.width;
                _imageHeight = svg.data.height;
                renderSVG();
            }
            #end
        } else {
            if (_bmp != null && sprite.contains(_bmp) == true) {
                sprite.removeChild(_bmp);
                //_bmp.bitmapData.dispose();
                _bmp = null;
            } else {
                sprite.graphics.clear();
            }

            _imageWidth = 0;
            _imageHeight = 0;
        }
    }

    private override function validatePosition() {
        if (sprite.x != _left) {
            sprite.x = _left;
        }

        if (sprite.y != _top) {
            sprite.y = _top;
        }
    }

    private override function validateDisplay() {
        if(containsBitmapDataInfo()) {
            var scaleX:Float = _imageWidth / _bmp.bitmapData.width;
            if (_bmp.scaleX != scaleX) {
                _bmp.scaleX = scaleX;
            }

            var scaleY:Float = _imageHeight / _bmp.bitmapData.height;
            if (_bmp.scaleY != scaleY) {
                _bmp.scaleY = scaleY;
            }
        }
        #if svg
        else if(containsSVGInfo()) {
            renderSVG();
        }
        #end

        if(_imageClipRect == null) {
            sprite.scrollRect = null;
        } else {
            sprite.scrollRect = new openfl.geom.Rectangle(-_left, -_top, Math.fround(_imageClipRect.width), Math.fround(_imageClipRect.height));
            sprite.x = _imageClipRect.left;
            sprite.y = _imageClipRect.top;
        }
    }

    public function applyStyle(style:Style) {
        if (style != null && _bmp != null) {
            if (style.imageRendering == "pixelated") {
                _bmp.smoothing = false;
            } else {
                _bmp.smoothing = true;
            }
        }
    }    
}