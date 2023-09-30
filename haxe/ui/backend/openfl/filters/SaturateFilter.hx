package haxe.ui.backend.openfl.filters;

import openfl.filters.ColorMatrixFilter;

class SaturateFilter {

    private static inline var LUMA_R:Float = 0.299;
    private static inline var LUMA_G:Float = 0.587;
    private static inline var LUMA_B:Float = 0.114;
    
    public var filter:ColorMatrixFilter;
    
    public function new(multiplier:Float = 1) {

        var sat = multiplier;
        var invSat:Float  = 1 - multiplier;
        var invLumR:Float = invSat * LUMA_R;
        var invLumG:Float = invSat * LUMA_G;
        var invLumB:Float = invSat * LUMA_B;

        filter = new ColorMatrixFilter([
            (invLumR + sat), invLumG,  invLumB, 0, 0,
            invLumR, (invLumG + sat), invLumB, 0, 0,
            invLumR, invLumG, (invLumB + sat), 0, 0,
            0, 0, 0, 1, 0]);
    }
}