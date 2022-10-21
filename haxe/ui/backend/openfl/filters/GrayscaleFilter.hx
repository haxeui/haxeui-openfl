package haxe.ui.backend.openfl.filters;

import openfl.filters.ColorMatrixFilter;

// adapted from: https://github.com/player-03/haxeutils/blob/master/com/player03/display/Greyscale.hx
class GrayscaleFilter {
    /**
     * Color multipliers recommended by the ITU to make the result appear to the
     * human eye to have the correct brightness. See page 3 of the article at
     * http://www.itu.int/rec/R-REC-BT.601-7-201103-I/en for more information.
     */
    private static inline var RED:Float = 0.299;
    private static inline var GREEN:Float = 0.587;
    private static inline var BLUE:Float = 0.114;
    
    public var filter:ColorMatrixFilter;
    
    public function new(amount:Float = 1) {
        filter = new ColorMatrixFilter([
                1 + (RED - 1) * amount, GREEN * amount,           BLUE * amount,           0, 0,
                RED * amount,           1 + (GREEN - 1) * amount, BLUE * amount,           0, 0,
                RED * amount,           GREEN * amount,           1 + (BLUE - 1) * amount, 0, 0,
                0,                      0,                        0,                       1, 0]);
    }
}