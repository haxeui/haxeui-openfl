package haxe.ui.backend.openfl.filters;

import openfl.filters.ColorMatrixFilter;

class HueRotateFilter {
    private static inline var LUMA_R:Float = 0.213;
    private static inline var LUMA_G:Float = 0.715;
    private static inline var LUMA_B:Float = 0.072;

    public var filter:ColorMatrixFilter;
    
    public function new(degreeAngle:Float = 90) {

        var value =  degreeAngle /180 * Math.PI;
        if (value == 0) filter = new ColorMatrixFilter();

        var cosVal = Math.cos(value);
        var sinVal = Math.sin(value);

        filter = new ColorMatrixFilter([
                LUMA_R + cosVal * (1 - LUMA_R) + sinVal * (-LUMA_R),     LUMA_G + cosVal * (-LUMA_G) + sinVal * (-LUMA_G),    LUMA_B + cosVal * (-LUMA_B) + sinVal * (1 - LUMA_B),   0, 0,
                LUMA_R + cosVal * (-LUMA_R) + sinVal * (0.143)   ,     LUMA_G + cosVal * (1 - LUMA_G) + sinVal * (0.14),  LUMA_B + cosVal * (-LUMA_B) + sinVal * (-0.283) ,    0, 0,
                LUMA_R + cosVal * (-LUMA_R) + sinVal * (-(1 - LUMA_R)),  LUMA_G + cosVal * (-LUMA_G) + sinVal * (LUMA_G),     LUMA_B + cosVal * (1 - LUMA_B) + sinVal * (LUMA_B),    0, 0,
                0                                               ,  0                                        ,     0                                           ,    1, 0,
                0                                               ,  0                                        ,     0                                           ,    0, 1]);
    }
}