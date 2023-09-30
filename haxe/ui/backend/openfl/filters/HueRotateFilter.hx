package haxe.ui.backend.openfl.filters;

import openfl.filters.ColorMatrixFilter;

class HueRotateFilter {
    /**
     * https://stackoverflow.com/questions/4354939/understanding-the-use-of-colormatrix-and-colormatrixcolorfilter-to-modify-a-draw
     */
    
    public var filter:ColorMatrixFilter;
    
    public function new(degreeAngle:Float = 90) {

        var value =  degreeAngle /180 * Math.PI;
        if (value == 0) filter = new ColorMatrixFilter();

        var cosVal = Math.cos(value);
        var sinVal = Math.sin(value);
        var lumR   = 0.213;
        var lumG   = 0.715;
        var lumB   = 0.072;

        filter = new ColorMatrixFilter([
                lumR + cosVal * (1 - lumR) + sinVal * (-lumR),     lumG + cosVal * (-lumG) + sinVal * (-lumG),    lumB + cosVal * (-lumB) + sinVal * (1 - lumB),   0, 0,
                lumR + cosVal * (-lumR) + sinVal * (0.143)   ,     lumG + cosVal * (1 - lumG) + sinVal * (0.14),  lumB + cosVal * (-lumB) + sinVal * (-0.283) ,    0, 0,
                lumR + cosVal * (-lumR) + sinVal * (-(1 - lumR)),  lumG + cosVal * (-lumG) + sinVal * (lumG),     lumB + cosVal * (1 - lumB) + sinVal * (lumB),    0, 0,
                0                                               ,  0                                        ,     0                                           ,    1, 0,
                0                                               ,  0                                        ,     0                                           ,    0, 1]);
    }
}