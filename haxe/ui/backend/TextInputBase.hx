package haxe.ui.backend;

import haxe.ui.backend.TextDisplayBase;
import haxe.ui.components.TextArea;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.TextFieldType;
import openfl.text.TextFieldAutoSize;

class TextInputBase extends TextDisplayBase {
    public var password:Bool;
    
    @:access(haxe.ui.components.TextArea)
    public function new() {
        super();
        type = TextFieldType.INPUT;
        selectable = true;
        mouseEnabled = true;
        autoSize = TextFieldAutoSize.NONE;
        //PADDING_Y = 2;
        addEventListener(KeyboardEvent.KEY_UP, function(e) {
            if (type == TextFieldType.INPUT && multiline == true && Std.is(parentComponent, TextArea)) {
                cast(parentComponent, TextArea).checkScrolls();
            }
        });
        addEventListener(KeyboardEvent.KEY_DOWN, function(e) {
            if (type == TextFieldType.INPUT && multiline == true && Std.is(parentComponent, TextArea)) {
                cast(parentComponent, TextArea).checkScrolls();
            }
        });
    }

    public var vscrollPos(get, set):Float;
    private function get_vscrollPos():Float {
        return this.scrollV - 1;
    }
    private function set_vscrollPos(value:Float):Float {
        this.scrollV = Std.int(value + 1);
        return value;
    }

    @:getter(textHeight)
    private override function get_textHeight():Float {
        if (multiline == false) {
            var v = super.textHeight;
            return v;
        }

        return this.maxScrollV + height - 1;
    }

    #if !flash

    @:getter(height)
    private override function get_height():Float {
        if (type == TextFieldType.INPUT && multiline == true && Std.is(parentComponent, TextArea)) {
            var visibleLines:Int = (bottomScrollV - scrollV);
            return visibleLines;
        }
        return super.height;
    }

    #else

    @:getter(height)
    private function get_height():Float {
        if (type == TextFieldType.INPUT && multiline == true && Std.is(parentComponent, TextArea)) {
            var visibleLines:Int = (bottomScrollV - scrollV) + 1;
            return visibleLines;
        }
        return super.height;
    }

    #end
}
