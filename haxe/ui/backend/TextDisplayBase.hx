package haxe.ui.backend;

import haxe.ui.core.Component;
import haxe.ui.styles.Style;
import openfl.text.TextFormatAlign;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class TextDisplayBase extends TextField {
    public var parentComponent:Component;

    private var PADDING_X:Int = 0;
    private var PADDING_Y:Int = 4;// -4;

    public function new() {
        super();
        type = TextFieldType.DYNAMIC;
        selectable = false;
        mouseEnabled = false;
        multiline = false;
        wordWrap = false;
        autoSize = TextFieldAutoSize.LEFT;
        text = "";
    }

    #if !flash

    @:getter(textWidth)
    private override function get_textWidth():Float {
        var v = super.textWidth;
        v += PADDING_X;
        return v;
    }

    @:getter(textHeight)
    private override function get_textHeight():Float {
        var v = super.textHeight;
        if (v == 0) {
            var tmpText:String = text;
            text = "|";
            v = super.textHeight;
            text = tmpText;
        }
        v += PADDING_Y;
        return v;
    }

    #else

    @:getter(textWidth)
    private function get_textWidth():Float {
        var v = super.textWidth;
        v += PADDING_X;
        return v;
    }

    @:getter(textHeight)
    private function get_textHeight():Float {
        var v = super.textHeight;
        v += PADDING_Y;
        return v;
    }

    #end

    public var left(get, set):Float;
    private function get_left():Float {
        return this.x + 2 - (PADDING_X / 2);
    }
    private function set_left(value:Float):Float {
        value = Std.int(value);
        this.x = value - 2 + (PADDING_X / 2);
        return value;
    }

    public var top(get, set):Float;
    private function get_top():Float {
        return this.y + 2 - (PADDING_Y / 2);
    }
    private function set_top(value:Float):Float {
        value = Std.int(value);
        this.y = value - 2 + (PADDING_Y / 2);
        return value;
    }

    public function applyStyle(style:Style) {
        var format:TextFormat = getTextFormat();
        if (style.color != null) {
            format.color = style.color;
        }
        if (style.fontName != null) {
            embedFonts = isEmbeddedFont(style.fontName);
            if (isEmbeddedFont(style.fontName) == true) {
                format.font = Assets.getFont(style.fontName).fontName;
            } else {
                format.font = style.fontName;
            }
        }
        if (style.fontSize != null) {
            format.size = style.fontSize;
        }
        if (style.textAlign != null) {
            format.align = cast style.textAlign;
        }
        defaultTextFormat = format;
        setTextFormat(format);
    }
    
    private static inline function isEmbeddedFont(name:String) {
        return (name != "_sans" && name != "_serif" && name != "_typewriter");
    }
}