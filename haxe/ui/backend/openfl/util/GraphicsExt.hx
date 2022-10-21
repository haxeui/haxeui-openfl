package haxe.ui.backend.openfl.util;

#if haxeui_extended_borders

#if !flash

import openfl.geom.Point;
import openfl.display._internal.DrawCommandReader;
import openfl.display._internal.DrawCommandType;
import openfl.display.Graphics;

/**
 * Static extention for openfl.display.Graphics
 */
@:access(openfl.display.Graphics)
@:access(openfl.display._internal.DrawCommandBuffer)
@:access(openfl.display._internal.DrawCommandReader)
class GraphicsExt
{
    //----------------------------------------------------------------------
    //
    //  Properties
    //
    //----------------------------------------------------------------------
    
    private static var _posChangeTypes:Array<DrawCommandType> = [DrawCommandType.CUBIC_CURVE_TO, DrawCommandType.CURVE_TO, DrawCommandType.DRAW_CIRCLE, DrawCommandType.DRAW_ELLIPSE, DrawCommandType.DRAW_RECT, DrawCommandType.DRAW_ROUND_RECT, DrawCommandType.LINE_TO, DrawCommandType.MOVE_TO];

    //----------------------------------------------------------------------
    //
    //  Methods
    //
    //----------------------------------------------------------------------

    /**
     * Draws a dotted line.
     * @param gfx 
     * @param x 
     * @param y 
     */
    static public inline function dottedLineTo(gfx:Graphics, x:Float, y:Float):Void {
        _periodicLineTo(gfx, x, y, StyledLineType.DOTTED);
    }

    /**
     * Draws a dashed line.
     * @param gfx 
     * @param x 
     * @param y 
     */
    static public inline function dashedLineTo(gfx:Graphics, x:Float, y:Float):Void {
        _periodicLineTo(gfx, x, y, StyledLineType.DASHED);
    }

    /**
     * Draws 2 parallel lines whose combined thickness and the space between them adds up to the current lineStyle thickness
     * @param gfx 
     * @param x 
     * @param y 
     */
    static public inline function doubleLineTo(gfx:Graphics, x:Float, y:Float):Void {
        _doubleLineTo(gfx, x, y);
    }

    /**
     * Draws a rectangle using dotted lines.
     * @param gfx 
     * @param x 
     * @param y 
     * @param width 
     * @param height 
     */
    static public inline function drawDottedRect(gfx:Graphics, x:Float, y:Float, width:Float, height:Float):Void {
        _drawPeriodicRect(gfx, x, y, width, height, StyledLineType.DOTTED);
    }

    /**
     * Draws a rectangle using dashed lines.
     * @param gfx 
     * @param x 
     * @param y 
     * @param width 
     * @param height 
     */
    static public inline function drawDashedRect(gfx:Graphics, x:Float, y:Float, width:Float, height:Float):Void {
        _drawPeriodicRect(gfx, x, y, width, height, StyledLineType.DASHED);
    }

    /**
     * Draws a rectangle using double lines.
     * @param gfx 
     * @param x 
     * @param y 
     * @param width 
     * @param height 
     */
     static public inline function drawDoubleRect(gfx:Graphics, x:Float, y:Float, width:Float, height:Float):Void {
        _drawDoubleRect(gfx, x, y, width, height);
    }
    
    /**
     * Draws a regular polygon with specified number of sides.
     * @param gfx 
     * @param x 
     * @param y 
     * @param sides 
     * @param radius 
     */
    static public function drawRegularPolygon(gfx:Graphics, x:Float, y:Float, sides:Int, radius:Float):Void {
        _drawRegularPolygon(gfx, x, y, sides, radius, StyledLineType.SOLID);
    }

    /**
     * Draws a regular polygon with specified number of sides using dotted lines.
     * @param gfx 
     * @param x 
     * @param y 
     * @param sides 
     * @param radius 
     */
    static public function drawDottedRegularPolygon(gfx:Graphics, x:Float, y:Float, sides:Int, radius:Float):Void {
        _drawRegularPolygon(gfx, x, y, sides, radius, StyledLineType.DOTTED);
    }

    /**
     * Draws a regular polygon with specified number of sides using dashed lines.
     * @param gfx 
     * @param x 
     * @param y 
     * @param sides 
     * @param radius 
     */
    static public function drawDashedRegularPolygon(gfx:Graphics, x:Float, y:Float, sides:Int, radius:Float):Void {
        _drawRegularPolygon(gfx, x, y, sides, radius, StyledLineType.DASHED);
    }

    /**
     * Draws a regular polygon with specified number of sides using double lines.
     * @param gfx 
     * @param x 
     * @param y 
     * @param sides 
     * @param radius 
     */
     static public function drawDoubleRegularPolygon(gfx:Graphics, x:Float, y:Float, sides:Int, radius:Float):Void {
        _drawRegularPolygon(gfx, x, y, sides, radius, StyledLineType.DOUBLE);
    }
    
    /**
     * Gets the current line style.
     * @param gfx 
     * @return LineStyleView
     */
    static public function getLineStyle(gfx:Graphics):LineStyleView {
        // get DrawCommandReader for current DrawCommandBuffer
        var data:DrawCommandReader = new DrawCommandReader(gfx.__commands);

        // Find last possible index of DrawCommandType.LINE_STYLE
        var lastLineStyleIndex:Int = data.buffer.types.lastIndexOf(DrawCommandType.LINE_STYLE);

        // skip through commands until we get to one just before the last lineStyle
        for (i in 0...lastLineStyleIndex) {
            data.skip(data.buffer.types[i]);
        }

        return data.readLineStyle();
    }

    /**
     * Gets the current draw head position.
     * @param gfx 
     * @return Point
     */
    static public function getDrawHeadPos(gfx:Graphics):Point {
        var point:Point = new Point();

        // get DrawCommandReader for current DrawCommandBuffer
        var data:DrawCommandReader = new DrawCommandReader(gfx.__commands);

        // Find last possible index and type of DrawCommandType that changed draw head position //
        var lastPosChangeIndex:Int = 0;
        var lastPosChangeType:DrawCommandType = DrawCommandType.UNKNOWN;
        for (i in 0..._posChangeTypes.length) {
            var curIndex:Int = data.buffer.types.lastIndexOf(_posChangeTypes[i]);
            if (curIndex > lastPosChangeIndex) {
                lastPosChangeIndex = curIndex;
                lastPosChangeType = _posChangeTypes[i];
            }
        }
        // We actually want to step into the appropriate index
        lastPosChangeIndex++;

        // skip through commands until we get to current position changing command
        for (i in 0...lastPosChangeIndex) {
            data.skip(data.buffer.types[i]);
        }

        if (lastPosChangeType == DrawCommandType.CUBIC_CURVE_TO || lastPosChangeType == DrawCommandType.CURVE_TO) {
            data.advance(); // advance to 1 after current drawCommand array buffers
            // draw head moved to anchorX/anchorY, which are the previous 2 buffer float indexes
            point.setTo(data.buffer.f[data.fPos - 2], data.buffer.f[data.fPos - 1]);
        } else {
            // draw head moved to x/y, which are the next 2 buffer float indexes
            point.setTo(data.buffer.f[data.fPos], data.buffer.f[data.fPos + 1]);
        }
        
        return point;
    }

    static private function _periodicLineTo(gfx:Graphics, x:Float, y:Float, lineType:StyledLineType):Void {
        if (lineType == StyledLineType.SOLID) {
            gfx.lineTo(x, y);
        } else {
            var lineData:LineStyleView = getLineStyle(gfx);
            var drawHeadPos:Point = getDrawHeadPos(gfx);

            var dX:Float = x - drawHeadPos.x;
            var dY:Float = y - drawHeadPos.y;
            var dist:Float = Math.sqrt(dX * dX + dY * dY);
            
            var lineThickness:Float = Math.max(lineData.thickness, 1);
            var lineLength:Float = (lineType == StyledLineType.DASHED) ? Math.max(lineThickness * 2, 3) : 0.5;
            var numLines:Int = Math.ceil(dist / Math.max(lineLength, lineThickness * 2) * .5);
            var gapLength:Float = (dist - lineLength * numLines) / (numLines - 1);
            // adjust the gapLength to acurately fit any distance diff
            gapLength *= dist / (lineLength * numLines + gapLength * (numLines - 1));

            // radian angle of the line
            var rads:Float = Math.atan2(y - drawHeadPos.y, x - drawHeadPos.x);

            var toX:Float = drawHeadPos.x;
            var toY:Float = drawHeadPos.y;

            var i:Int = 0;
            while (++i < numLines) {
                // draw visible line
                toX += Math.cos(rads) * lineLength;
                toY += Math.sin(rads) * lineLength;
                gfx.lineTo(toX, toY);

                // set lineStyle to hairline and invisible
                gfx.lineStyle(0, 0, 0);
                // draw invisible gap line
                toX += Math.cos(rads) * gapLength;
                toY += Math.sin(rads) * gapLength;
                gfx.lineTo(toX, toY);

                // reset lineStyle
                gfx.lineStyle(lineData.thickness, lineData.color, lineData.alpha, lineData.pixelHinting, lineData.scaleMode, lineData.caps, lineData.joints, lineData.miterLimit);
            }

            // draw final visible line
            gfx.lineTo(x, y);
        }
    }

    static private function _doubleLineTo(gfx:Graphics, x:Float, y:Float):Void {
        var lineData:LineStyleView = getLineStyle(gfx);
        
        if (lineData.thickness < 1.5) {
            gfx.lineTo(x, y);
        } else {
            var drawHeadPos:Point = getDrawHeadPos(gfx);

            // radian angle of the line
            var rads:Float = Math.atan2(y - drawHeadPos.y, x - drawHeadPos.x);
            var quarterPI:Float = Math.PI * .25; // 45 degrees

            var lineThickness:Float = lineData.thickness * .5;
            var lineOffset:Float = Math.sqrt(2 * lineThickness * lineThickness);

            // set lineStyle to just under a 3rd thickness
            lineThickness = lineData.thickness * .3;
            gfx.lineStyle(lineThickness, lineData.color, lineData.alpha, lineData.pixelHinting, lineData.scaleMode, lineData.caps, lineData.joints, lineData.miterLimit);

            gfx.moveTo(drawHeadPos.x + Math.cos(rads - quarterPI * 3) * lineOffset, drawHeadPos.y + Math.sin(rads - quarterPI * 3) * lineOffset);
            gfx.lineTo(x + Math.cos(rads - quarterPI) * lineOffset, y + Math.sin(rads - quarterPI) * lineOffset);
            gfx.moveTo(drawHeadPos.x + Math.cos(rads + quarterPI) * lineOffset, drawHeadPos.y + Math.sin(rads + quarterPI) * lineOffset);
            gfx.lineTo(x + Math.cos(rads + quarterPI * 3) * lineOffset, y + Math.sin(rads + quarterPI * 3) * lineOffset);

            // move draw head to end position
            gfx.moveTo(x, y);
            // reset lineStyle
            gfx.lineStyle(lineData.thickness, lineData.color, lineData.alpha, lineData.pixelHinting, lineData.scaleMode, lineData.caps, lineData.joints, lineData.miterLimit);
        }
    }

    static private inline function _drawPeriodicRect(gfx:Graphics, x:Float, y:Float, width:Float, height:Float, lineType:StyledLineType):Void {
        gfx.moveTo(x, y);
        _periodicLineTo(gfx, x + width, y, lineType);
        _periodicLineTo(gfx, x + width, y + height, lineType);
        _periodicLineTo(gfx, x, y + height, lineType);
        _periodicLineTo(gfx, x, y, lineType);
    }

    static private inline function _drawDoubleRect(gfx:Graphics, x:Float, y:Float, width:Float, height:Float):Void {
        var lineData:LineStyleView = getLineStyle(gfx);

        gfx.moveTo(x, y);
        if (lineData.thickness < 1.5) {
            gfx.drawRect(x, y, width, height);
        } else {
            _doubleLineTo(gfx, x + width, y);
            _doubleLineTo(gfx, x + width, y + height);
            _doubleLineTo(gfx, x, y + height);
            _doubleLineTo(gfx, x, y);

            // in case of fills, we have to draw an invisible rect 1st bc of the nature of double lines and fills
            gfx.lineStyle(0, 0, 0);
            gfx.drawRect(x, y, width, height);
            // reset lineStyle
            // sadly, openfl issue is causing an erroneous dot to be drawn here (https://github.com/openfl/openfl/issues/2336)
            gfx.lineStyle(lineData.thickness, lineData.color, lineData.alpha, lineData.pixelHinting, lineData.scaleMode, lineData.caps, lineData.joints, lineData.miterLimit);
        }
    }

    static private inline function _drawRegularPolygon(gfx:Graphics, x:Float, y:Float, sides:Int, radius:Float, lineType:StyledLineType):Void {
        var step = Math.PI / sides * 2;
        var rad = Math.PI * .5;
        
        gfx.moveTo(x + Math.cos(rad) * radius, y - Math.sin(rad) * radius);
        if (lineType == StyledLineType.DOUBLE) {
            var lineData:LineStyleView = getLineStyle(gfx);

            // in case of fills, we have to draw an invisible poly 1st bc of the nature of double lines and fills
            gfx.lineStyle(0, 0, 0);
            _drawRegularPolygon(gfx, x, y, sides, radius, StyledLineType.SOLID);
            // reset lineStyle
            gfx.lineStyle(lineData.thickness, lineData.color, lineData.alpha, lineData.pixelHinting, lineData.scaleMode, lineData.caps, lineData.joints, lineData.miterLimit);
        }
        while (sides-- > 0) {
            if (lineType == StyledLineType.SOLID) {
                gfx.lineTo(x + Math.cos(rad + (step * sides)) * radius, y - Math.sin(rad + (step * sides)) * radius);
            } else if (lineType == StyledLineType.DOUBLE) {
                _doubleLineTo(gfx, x + Math.cos(rad + (step * sides)) * radius, y - Math.sin(rad + (step * sides)) * radius);
            } else {
                _periodicLineTo(gfx, x + Math.cos(rad + (step * sides)) * radius, y - Math.sin(rad + (step * sides)) * radius, lineType);
            }
        }
    }

}
#end

enum StyledLineType
{
    SOLID;
    DOTTED;
    DASHED;
    DOUBLE;
}

#end

