package haxe.ui.backend.openfl;

import haxe.ui.backend.openfl.filters.GrayscaleFilter;
import haxe.ui.filters.Filter;
import openfl.filters.BitmapFilter;
import openfl.filters.BitmapFilterQuality;
import openfl.filters.BlurFilter;
import openfl.filters.DropShadowFilter;
import haxe.ui.backend.openfl.filters.HueRotateFilter;
import haxe.ui.backend.openfl.filters.ContrastFilter;
import haxe.ui.backend.openfl.filters.SaturateFilter;
import haxe.ui.backend.openfl.filters.TintFilter;
import haxe.ui.backend.openfl.filters.InvertFilter;
import haxe.ui.backend.openfl.filters.BrightnessFilter;

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
                                          .9,
                                          inputDropShadow.blurX,
                                          inputDropShadow.blurY,
                                          1,
                                          BitmapFilterQuality.HIGH,
                                          inputDropShadow.inner);
        } else if ((input is haxe.ui.filters.Blur)) {
            var inputBlur:haxe.ui.filters.Blur = cast(input, haxe.ui.filters.Blur);
            output = new BlurFilter(inputBlur.amount, inputBlur.amount);
        } else if ((input is haxe.ui.filters.Grayscale)) {
            var inputGrayscale:haxe.ui.filters.Grayscale = cast(input, haxe.ui.filters.Grayscale);
            output = new GrayscaleFilter(inputGrayscale.amount / 100).filter;
        } else if ((input is haxe.ui.filters.Tint)) {
            var tint:haxe.ui.filters.Tint = cast(input, haxe.ui.filters.Tint);
            output = new TintFilter(tint.color, tint.amount).filter;
        } else if ((input is haxe.ui.filters.HueRotate)) {
            var inputHue:haxe.ui.filters.HueRotate = cast(input, haxe.ui.filters.HueRotate);
            output = new HueRotateFilter(inputHue.angleDegree).filter;
        } else if ((input is haxe.ui.filters.Contrast)) {
            var contrast:haxe.ui.filters.Contrast = cast(input, haxe.ui.filters.Contrast);
            output = new ContrastFilter(contrast.multiplier).filter;
        } else if ((input is haxe.ui.filters.Saturate)) {
            var saturate:haxe.ui.filters.Saturate = cast(input, haxe.ui.filters.Saturate);
            output = new SaturateFilter(saturate.multiplier).filter;
        } else if (input is haxe.ui.filters.Invert) {
            var invert:haxe.ui.filters.Invert = cast(input, haxe.ui.filters.Invert);
            output = new InvertFilter(invert.multiplier).filter;
        } else if (input is haxe.ui.filters.Brightness) {
            var brightness:haxe.ui.filters.Brightness = cast(input, haxe.ui.filters.Brightness);
            output = new BrightnessFilter(brightness.multiplier).filter;
        }
        
        #end
        
        return output;
    }
}
