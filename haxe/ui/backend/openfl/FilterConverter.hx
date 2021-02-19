package haxe.ui.backend.openfl;

import haxe.ui.backend.openfl.filters.GrayscaleFilter;
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
        
        if ((input is haxe.ui.filters.DropShadow)) {
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
        } else if ((input is haxe.ui.filters.Blur)) {
            var inputBlur:haxe.ui.filters.Blur = cast(input, haxe.ui.filters.Blur);
            output = new BlurFilter(inputBlur.amount, inputBlur.amount);
        } else if ((input is haxe.ui.filters.Grayscale)) {
            var inputGrayscale:haxe.ui.filters.Grayscale = cast(input, haxe.ui.filters.Grayscale);
            output = new GrayscaleFilter(inputGrayscale.amount / 100).filter;
        }
        
        #end
        
        return output;
    }
}