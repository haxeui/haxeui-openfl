package haxe.ui.backend.openfl.filters;

import openfl.filters.ColorMatrixFilter;

class ContrastFilter { 
    public var filter:ColorMatrixFilter;
    
    public function new(multiplier:Float = 1) {
        
        var s = multiplier;
        var o:Float = 128 * (1 - s);
        
        filter = new ColorMatrixFilter([
            s, 0, 0, 0, o,
            0, s, 0, 0, o,
            0, 0, s, 0, o,
            0, 0, 0, 1, 0]);
    }
}