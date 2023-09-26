package haxe.ui.backend.openfl.filters;

import openfl.filters.ColorMatrixFilter;
import haxe.ui.util.Color;

class TintFilter {
    
    public var filter:ColorMatrixFilter;

    // These numbers come from the CIE XYZ Color Model
    public static inline var LUMA_R = 0.212671;
    public static inline var LUMA_G = 0.71516;
    public static inline var LUMA_B = 0.072169;
    
    public function new(color:Int = 0, amount:Float = 1) {

        var color:Color = cast color;

        var r:Float = color.r / 255;
        var g:Float = color.g / 255;
        var b:Float = color.b / 255;
        var q:Float = 1 - amount;

        var rA:Float = amount * r;
        var gA:Float = amount * g;
        var bA:Float = amount * b;

        filter = new ColorMatrixFilter([
            q + rA * LUMA_R, rA * LUMA_G, rA * LUMA_B, 0, 0,
            gA * LUMA_R, q + gA * LUMA_G, gA * LUMA_B, 0, 0,
            bA * LUMA_R, bA * LUMA_G, q + bA * LUMA_B, 0, 0,
            0, 0, 0, 1, 0]);
    }        
}