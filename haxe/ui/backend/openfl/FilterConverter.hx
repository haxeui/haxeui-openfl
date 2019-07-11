package haxe.ui.backend.openfl;

import haxe.ui.filters.Filter;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.DropShadowFilter;

class FilterConverter {
    public static function convertFilter(input:Filter):BitmapFilter {
        if (input == null) {
            return null;
        }
        var output:BitmapFilter = null;
        
        #if haxe4
        
        if (Std.is(input, haxe.ui.filters.DropShadow)) {
            var inputDropShadow:haxe.ui.filters.DropShadow = cast(input, haxe.ui.filters.DropShadow);
            output = new DropShadowFilter(inputDropShadow.distance + 1,
                                          inputDropShadow.angle,
                                          inputDropShadow.color,
                                          inputDropShadow.alpha * 2,
                                          inputDropShadow.blurX,
                                          inputDropShadow.blurY,
                                          inputDropShadow.strength,
                                          inputDropShadow.quality,
                                          inputDropShadow.inner);
                                            
            cast(output, DropShadowFilter).alpha = 1;
        } else if (Std.is(input, haxe.ui.filters.Blur)) {
            var inputBlur:haxe.ui.filters.Blur = cast(input, haxe.ui.filters.Blur);
            output = new BlurFilter(inputBlur.amount, inputBlur.amount);
        }
        
        #end
        
        return output;
    }
}