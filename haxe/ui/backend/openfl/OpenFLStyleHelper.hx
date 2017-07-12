package haxe.ui.backend.openfl;
import haxe.ui.assets.ImageInfo;
import haxe.ui.components.Button.ButtonDefaultIconBehaviour;

import haxe.ui.styles.Style;
import haxe.ui.util.Slice9;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.InterpolationMethod;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class OpenFLStyleHelper {
    public function new() {
    }

    public static function paintStyleSection(graphics:Graphics, style:Style, width:Float, height:Float, left:Float = 0, top:Float = 0, clear:Bool = true) {
        if (clear == true) {
            graphics.clear();
        }

        if (width <= 0 || height <= 0) {
            return;
        }

        /*
        left = Math.fround(left);
        top = Math.fround(top);
        width = Math.fround(width);
        height = Math.fround(height);
        */

        left = Std.int(left);
        top = Std.int(top);
        width = Std.int(width);
        height = Std.int(height);
        
        var rc:Rectangle = new Rectangle(top, left, width, height);
        var borderRadius:Float = 0;
        if (style.borderRadius != null) {
            borderRadius = style.borderRadius;
        }

        if (style.borderLeftSize != null && style.borderLeftSize != 0
            && style.borderLeftSize == style.borderRightSize
            && style.borderLeftSize == style.borderBottomSize
            && style.borderLeftSize == style.borderTopSize

            && style.borderLeftColor != null
            && style.borderLeftColor == style.borderRightColor
            && style.borderLeftColor == style.borderBottomColor
            && style.borderLeftColor == style.borderTopColor) {
            graphics.lineStyle(style.borderLeftSize, style.borderLeftColor);
            rc.left += style.borderLeftSize / 2;
            rc.top += style.borderLeftSize / 2;
            rc.bottom -= style.borderLeftSize / 2;
            rc.right -= style.borderLeftSize / 2;
            //rc.inflate( -(style.borderLeftSize / 2), -(style.borderLeftSize / 2));
        } else {
            if ((style.borderTopSize != null && style.borderTopSize > 0)
                || (style.borderBottomSize != null && style.borderBottomSize > 0)
                || (style.borderLeftSize != null && style.borderLeftSize > 0)
                || (style.borderRightSize != null && style.borderRightSize > 0)) {

                    var org = rc.clone();
                    
                    if (style.borderTopSize != null && style.borderTopSize > 0) {
                        graphics.beginFill(style.borderTopColor);
                        graphics.drawRect(0, 0, org.width, style.borderTopSize);
                        graphics.endFill();

                        rc.top += style.borderTopSize;
                    }

                    if (style.borderBottomSize != null && style.borderBottomSize > 0) {
                        graphics.beginFill(style.borderBottomColor);
                        graphics.drawRect(0, org.height - style.borderBottomSize, org.width, style.borderBottomSize);
                        graphics.endFill();

                        rc.bottom -= style.borderBottomSize;
                    }

                    if (style.borderLeftSize != null && style.borderLeftSize > 0) {
                        graphics.beginFill(style.borderLeftColor);
                        graphics.drawRect(0, rc.top, style.borderLeftSize, org.height - rc.top);
                        graphics.endFill();

                        rc.left += style.borderLeftSize;
                    }

                    if (style.borderRightSize != null && style.borderRightSize > 0) {
                        graphics.beginFill(style.borderRightColor);
                        graphics.drawRect(org.width - style.borderRightSize, rc.top, style.borderRightSize, org.height - rc.top);
                        graphics.endFill();

                        rc.right -= style.borderRightSize;
                    }
            }
        }

        var backgroundColor:Null<Int> = style.backgroundColor;
        var backgroundColorEnd:Null<Int> = style.backgroundColorEnd;
        var backgroundOpacity:Null<Float> = style.backgroundOpacity;
        #if html5 // TODO: fix for html5 not working with non-gradient fills
        if (backgroundColor != null && backgroundColorEnd == null) {
            backgroundColorEnd = backgroundColor;
        }
        #end

        if(backgroundOpacity == null) {
            backgroundOpacity = 1;
        }

        if (backgroundColor != null) {
            if (backgroundColorEnd != null) {
                var w:Int = Std.int(rc.width);
                var h:Int = Std.int(rc.height);
                var colors:Array<UInt> = [backgroundColor, backgroundColorEnd];
                var alphas:Array<Float> = [backgroundOpacity, backgroundOpacity];
                var ratios:Array<Int> = [0, 255];
                var matrix:Matrix = new Matrix();

                var gradientType:String = "vertical";
                if (style.backgroundGradientStyle != null) {
                    gradientType = style.backgroundGradientStyle;
                }

                if (gradientType == "vertical") {
                    matrix.createGradientBox(w - 2, h - 2, Math.PI / 2, 0, 0);
                } else if (gradientType == "horizontal") {
                    matrix.createGradientBox(w - 2, h - 2, 0, 0, 0);
                }

                graphics.beginGradientFill(GradientType.LINEAR,
                                            colors,
                                            alphas,
                                            ratios,
                                            matrix,
                                            SpreadMethod.PAD,
                                            InterpolationMethod.LINEAR_RGB,
                                            0);
            } else {
                graphics.beginFill(backgroundColor, backgroundOpacity);
            }
        }

        if (borderRadius == 0) {
            graphics.drawRect(rc.left, rc.top, rc.width, rc.height);
        } else {
            graphics.drawRoundRect(rc.left, rc.top, rc.width, rc.height, borderRadius + 2, borderRadius + 2);
        }

        graphics.endFill();

        if (style.backgroundImage != null) {
            Toolkit.assets.getImage(style.backgroundImage, function(imageInfo:ImageInfo) {
                if (imageInfo != null && imageInfo.data != null) {
                    paintBitmapBackground(graphics, imageInfo.data, style, rc);
                }
            });
        }
    }

    private static function paintBitmapBackground(graphics:Graphics, data:ImageData, style:Style, rc:Rectangle) {
        var fillBmp:BitmapData = null;
        var fillRect:Rectangle = rc;

        if(Std.is(data, BitmapData)) {
            fillBmp = cast data;
        }
        #if svg
        else if(Std.is(data, format.SVG)) {
            var svg:format.SVG = cast data;
            var renderer = new format.svg.SVGRenderer (svg.data);
            fillBmp = renderer.renderBitmap(rc);
        }
        #end
        else {
            return;
        }

        var cacheId:String = style.backgroundImage;
        if (style.backgroundImageClipTop != null
            && style.backgroundImageClipLeft != null
            && style.backgroundImageClipBottom != null
            && style.backgroundImageClipRight != null) {

            var clip:Rectangle = new Rectangle(style.backgroundImageClipLeft,
                                                style.backgroundImageClipTop,
                                                style.backgroundImageClipRight - style.backgroundImageClipLeft,
                                                style.backgroundImageClipBottom - style.backgroundImageClipTop);
            cacheId += "_" + BitmapCache.rectId(clip);
            var clipBmp:BitmapData = BitmapCache.instance.get(cacheId);
            if (clipBmp == null) {
                clipBmp = new BitmapData(cast clip.width, cast clip.height, true, 0x00000000);
                clipBmp.copyPixels(fillBmp, clip, new Point(0, 0));
                BitmapCache.instance.set(cacheId, clipBmp);
            }
            fillBmp = clipBmp;
        }

        var borderSize:Float = 0;
        if (style.borderSize != null && style.borderSize > 0) {
            borderSize = style.borderSize;
            fillRect.inflate( -(style.borderSize / 2), -(style.borderSize / 2));
        }

        var slice:Rectangle = null;
        if (style.backgroundImageSliceTop != null
            && style.backgroundImageSliceLeft != null
            && style.backgroundImageSliceBottom != null
            && style.backgroundImageSliceRight != null) {
            slice = new Rectangle(style.backgroundImageSliceLeft,
                                  style.backgroundImageSliceTop,
                                  style.backgroundImageSliceRight - style.backgroundImageSliceLeft,
                                  style.backgroundImageSliceBottom - style.backgroundImageSliceTop);
            //trace(slice);
        }

        if (slice == null) {
            if (style.backgroundImageRepeat == null) {
                fillRect.width = fillBmp.width;
                fillRect.height = fillBmp.height;
                var matrix:Matrix = new Matrix();
                graphics.beginBitmapFill(fillBmp, matrix, false, false);
            } else if (style.backgroundImageRepeat == "repeat") {
                graphics.beginBitmapFill(fillBmp, null, true, false);
            } else if (style.backgroundImageRepeat == "stretch") {
                #if !flash
                //fillRect.width += borderSize;
                //fillRect.height += borderSize;
                #end
                var scaleX = fillRect.width / fillBmp.width;
                var scaleY = fillRect.height / fillBmp.height;
                var matrix:Matrix = new Matrix();
                matrix.scale(scaleX, scaleY);
                graphics.beginBitmapFill(fillBmp, matrix, false, false);
            }

            var borderRadius:Float = 0;
            if (style.borderRadius != null) {
                borderRadius = style.borderRadius;
            }

            graphics.lineStyle(0, 0, 0);
            fillRect.left = Std.int(fillRect.left);
            fillRect.top = Std.int(fillRect.top);
            fillRect.bottom = Std.int(fillRect.bottom);
            fillRect.right = Std.int(fillRect.right);

            if (borderRadius == 0) {
                graphics.drawRect(fillRect.left, fillRect.top, fillRect.width, fillRect.height);
            } else {
                graphics.drawRect(fillRect.left, fillRect.top, fillRect.width, fillRect.height);
                /*
                if (style.backgroundImageRepeat == "stretch") {
                    graphics.drawRect(fillRect.left, fillRect.top, fillRect.width, fillRect.height);
                } else {
                    graphics.drawRoundRect(fillRect.left, fillRect.top, fillRect.width, fillRect.height, borderRadius, borderRadius);
                }
                */
            }

            graphics.endFill();
        } else {
            graphics.clear();

            var w:Float = rc.width + borderSize;
            var h:Float = rc.height + borderSize;
            var rects:Slice9Rects = Slice9.buildRects(w, h, fillBmp.width, fillBmp.height, convertToHaxeUIRect(slice));
            var srcRects:Array<Rectangle> = convertToOpenFLRectArr(rects.src);
            var dstRects:Array<Rectangle> = convertToOpenFLRectArr(rects.dst);
            for (i in 0...srcRects.length) {
                var srcRect = srcRects[i];
                var dstRect = dstRects[i];
                paintBitmap(graphics, fillBmp, cacheId, srcRect, dstRect);
            }
        }
    }

    private static function paintBitmap(graphics:Graphics, bmp:BitmapData, cacheId:String, srcRect:Rectangle, dstRect:Rectangle) {
        srcRect.left = Std.int(srcRect.left);
        srcRect.top = Std.int(srcRect.top);
        srcRect.bottom = Std.int(srcRect.bottom);
        srcRect.right = Std.int(srcRect.right);
        dstRect.left = Std.int(dstRect.left);
        dstRect.top = Std.int(dstRect.top);
        dstRect.bottom = Std.int(dstRect.bottom);
        dstRect.right = Std.int(dstRect.right);

        cacheId += "__" + BitmapCache.rectId(srcRect);
        var srcBmp:BitmapData = BitmapCache.instance.get(cacheId);
        if (srcBmp == null) {
            srcBmp = new BitmapData(cast srcRect.width, cast srcRect.height, true, 0x00000000);
            srcBmp.copyPixels(bmp, srcRect, new Point(0, 0));
            BitmapCache.instance.set(cacheId, srcBmp);
        } else {
            //trace("section in cache!");
        }

        var mat:Matrix = new Matrix();
        mat.scale(dstRect.width / srcBmp.width, dstRect.height / srcBmp.height);
        mat.translate(dstRect.left, dstRect.top);

        graphics.lineStyle(0, 0, 0);
        graphics.beginBitmapFill(srcBmp, mat, false, false);
        graphics.drawRect(dstRect.x, dstRect.y, dstRect.width, dstRect.height);
        graphics.endFill();

    }

    private static function convertToOpenFLRectArr(arr:Array<haxe.ui.util.Rectangle>):Array<Rectangle> {
        var r:Array<Rectangle> = new Array<Rectangle>();
        for (a in arr) {
            r.push(convertToOpenFLRect(a));
        }
        return r;
    }

    private static function convertToOpenFLRect(rc:haxe.ui.util.Rectangle):Rectangle {
        return new Rectangle(rc.left, rc.top, rc.width, rc.height);
    }

    private static function convertToHaxeUIRect(rc:Rectangle):haxe.ui.util.Rectangle {
        return new haxe.ui.util.Rectangle(rc.x, rc.y, rc.width, rc.height);
    }

}