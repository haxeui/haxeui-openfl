package haxe.ui.backend.openfl;

import haxe.ui.util.filters.Filter;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.DropShadowFilter;

class FilterConverter {
    public static function convertFilter(input:Filter):BitmapFilter {
        if (input == null) {
            return null;
        }
        var output:BitmapFilter = null;
        if (Std.is(input, haxe.ui.util.filters.DropShadow)) {
            var inputDropShadow:haxe.ui.util.filters.DropShadow = cast(input, haxe.ui.util.filters.DropShadow);
            output = new DropShadowFilter(inputDropShadow.distance,
                                          inputDropShadow.angle,
                                          inputDropShadow.color,
                                          inputDropShadow.alpha,
                                          inputDropShadow.blurX,
                                          inputDropShadow.blurY,
                                          inputDropShadow.strength,
                                          inputDropShadow.quality,
                                          inputDropShadow.inner);
        } else if (Std.is(input, haxe.ui.util.filters.Blur)) {
            var inputBlur:haxe.ui.util.filters.Blur = cast(input, haxe.ui.util.filters.Blur);
            output = new BlurFilter(inputBlur.amount, inputBlur.amount);
        }
        return output;
    }
}