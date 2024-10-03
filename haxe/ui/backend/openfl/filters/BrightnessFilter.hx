package haxe.ui.backend.openfl.filters;

import openfl.filters.ColorMatrixFilter;

class BrightnessFilter { 
    public var filter:ColorMatrixFilter;
    
    public function new(multiplier:Float = 1) {
        // In html, 0 is a black image, 1 has no effect, over it's a multiplier
        // So we adapt
        if (multiplier <= 1) multiplier = (multiplier -1) * 255;
        if (multiplier > 1) multiplier = (multiplier -1) * 110;
        
        filter = new ColorMatrixFilter([
            1,0,0,0,multiplier,
            0,1,0,0,multiplier,
            0,0,1,0,multiplier,
            0,0,0,1,0,
            0,0,0,0,1]);
    }
}