package haxe.ui.backend;

import openfl.display.GraphicsPathCommand;
import haxe.io.Bytes;
import haxe.ui.core.Component;
import haxe.ui.loaders.image.ImageLoader;
import haxe.ui.util.Color;
import haxe.ui.util.Variant;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.GraphicsPath;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

class ComponentGraphicsImpl extends ComponentGraphicsBase {
    private var _currentFillColor:Null<Color> = null;
    private var _currentFillAlpha:Null<Float> = null;
    private var _globalFillColor:Null<Color> = null;
    private var _globalFillAlpha:Null<Float> = null;
    private var _hasSize:Bool = false;

    private var _globalLineThickness :Null<Float> = null;
    private var _globalLineColor:Null<Color> = null;
    private var _globalLineAlpha:Null<Float> = null;

    private var currentPath:GraphicsPath;
    
    public function new(component:Component) {
        super(component);
        component.styleable = false;
    }
    
    public override function clear() {
        if (_hasSize == false) {
            return super.clear();
        }
        _component.graphics.clear();
    }
    
    public override function moveTo(x:Float, y:Float) {
        if (_hasSize == false) {
            return super.moveTo(x, y);
        }
        if (currentPath != null) {
            currentPath.moveTo(x,y);
        } else {
            _component.graphics.moveTo(x, y);
        }
        
    }
    
    public override function lineTo(x:Float, y:Float) {
        if (_hasSize == false) {
            return super.lineTo(x, y);
        }
        if (currentPath != null) {
            currentPath.lineTo(x,y);
        } else {
            _component.graphics.lineTo(x, y);
        }
    }
    
    public override function strokeStyle(color:Null<Color>, thickness:Null<Float> = 1, alpha:Null<Float> = 1) {
        if (_hasSize == false) {
            return super.strokeStyle(color, thickness, alpha);
        }
        if (currentPath == null) { 
            _globalLineThickness  = thickness;
            _globalLineColor = color;
            _globalLineAlpha = alpha;
        }
        
        _component.graphics.lineStyle(thickness, color, alpha);
    }    

    public override function fillStyle(color:Null<Color>, alpha:Null<Float> = 1) {
        if (_hasSize == false) {
            return super.fillStyle(color, alpha);
        }
        if (currentPath == null) {
            _globalFillColor = color;
            _globalFillAlpha = alpha;
        }
        _currentFillColor = color;
        _currentFillAlpha = alpha;
    }
    
    public override function circle(x:Float, y:Float, radius:Float) {
        if (_hasSize == false) {
            return super.circle(x, y, radius);
        }
        if (_currentFillColor != null) {
            _component.graphics.beginFill(_currentFillColor, _currentFillAlpha);
        }
        _component.graphics.drawCircle(x, y, radius);
        if (_currentFillColor != null) {
            _component.graphics.endFill();
        }
    }    
    
    public override  function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float) {
        if (_hasSize == false) {
            return super.curveTo(controlX, controlY, anchorX, anchorY);
        }
        
        if (currentPath != null) {
            currentPath.curveTo(controlX, controlY, anchorX, anchorY);
        } else {
            _component.graphics.curveTo(controlX, controlY, anchorX, anchorY);
        }
    }
    
    public override function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float) {
        if (_hasSize == false) {
            return super.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
        }
        if (currentPath != null) {
            currentPath.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
        } else {
            _component.graphics.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
        }
        
    }

    public override function beginPath() {
        if (_hasSize == false) {
            return super.beginPath();
        }
        currentPath = new GraphicsPath();
    }

    public override function closePath() {
        if (_hasSize == false) {
            return super.closePath();
        }
        if (currentPath!=null && currentPath.commands != null && currentPath.commands.length>0 ) {
            if (_currentFillColor != null) {
                _component.graphics.beginFill(_currentFillColor, _currentFillAlpha);
            }
            if (currentPath.commands[0] != GraphicsPathCommand.MOVE_TO) {
                currentPath.commands.insertAt(0, GraphicsPathCommand.MOVE_TO);
                @:privateAccess currentPath.data.insertAt(0, _component.graphics.__positionX);
                @:privateAccess currentPath.data.insertAt(0, _component.graphics.__positionY);
            }
            _component.graphics.drawPath(currentPath.commands, currentPath.data);
            if (_currentFillColor != null) {
                _component.graphics.endFill();
            }
        }
        currentPath = null; 
        _currentFillColor = _globalFillColor;
        _currentFillAlpha = _globalFillAlpha;

        // it seems openfl forgets about lineStyle after drawing a shape;
        _component.graphics.lineStyle(_globalLineThickness , _globalLineColor, _globalLineAlpha);
    }

    public override function rectangle(x:Float, y:Float, width:Float, height:Float) {
        if (_hasSize == false) {
            return super.rectangle(x, y, width, height);
        }
        if (_currentFillColor != null) {
            _component.graphics.beginFill(_currentFillColor, _currentFillAlpha);
        }
        _component.graphics.drawRect(x, y, width, height);
        if (_currentFillColor != null) {
            _component.graphics.endFill();
        }
    }
    
    public override function image(resource:Variant, x:Null<Float> = null, y:Null<Float> = null, width:Null<Float> = null, height:Null<Float> = null) {
        if (_hasSize == false) {
            return super.image(resource, x, y, width, height);
        }
        ImageLoader.instance.load(resource, function(imageInfo) {
            if (imageInfo != null) {
                if (x == null) x = 0;
                if (y == null) y = 0;
                if (width == null) width = imageInfo.width;
                if (height == null) height = imageInfo.height;
                
                var mat:Matrix = new Matrix();
                mat.scale(width / imageInfo.width, height / imageInfo.width);
                mat.translate(x, y);
                
                _component.graphics.beginBitmapFill(imageInfo.data, mat);
                _component.graphics.drawRect(x, y, width, height);
                _component.graphics.endFill();
            } else {
                trace("could not load: " + resource);
            }
        });
    }
    
    public override function setPixel(x:Float, y:Float, color:Color) {
        if (_hasSize == false) {
            return super.setPixel(x, y, color);
        }
        _component.graphics.beginFill(color);
        _component.graphics.drawRect(x, y, 1, 1);
        _component.graphics.endFill();
    }
    
    private var _bitmap:Bitmap = null;
    private var _bitmapData:BitmapData = null;
    public override function setPixels(pixels:Bytes) {
        if (_hasSize == false) {
            return super.setPixels(pixels);
        }
        
        if (_bitmap == null) {
            _bitmapData = new BitmapData(Std.int(_component.width), Std.int(_component.height), true, 0x00000000);
            _bitmap = new Bitmap(_bitmapData);
            _component.addChild(_bitmap);
        }
        
        // convert RGBA -> ARGB (well, actually BGRA for some reason)
        var bytesData = pixels.getData();
        var length:Int = pixels.length;
        var newPixels = Bytes.alloc(length);
        var i:Int = 0;
        while (i < length) {
            var r = Bytes.fastGet(bytesData, i + 0);
            var g = Bytes.fastGet(bytesData, i + 1);
            var b = Bytes.fastGet(bytesData, i + 2);
            var a = Bytes.fastGet(bytesData, i + 3);
            newPixels.set(i + 0, b);
            newPixels.set(i + 1, g);
            newPixels.set(i + 2, r);
            newPixels.set(i + 3, a);
            i += 4;
        }
        
        var byteArray = ByteArray.fromBytes(newPixels);
        _bitmapData.setPixels(new Rectangle(0, 0, _bitmapData.width, _bitmapData.height), byteArray);
    }
    
    public override function resize(width:Null<Float>, height:Null<Float>) {
        if (width > 0 && height > 0) {
            if (_hasSize == false) {
                _hasSize = true;
                replayDrawCommands();
            }
        }
    }
}