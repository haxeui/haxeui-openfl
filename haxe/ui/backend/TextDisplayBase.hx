package haxe.ui.backend;

import openfl.Assets;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class TextDisplayBase extends TextField {
    private var PADDING_X:Int = 0;
    private var PADDING_Y:Int = 0;// -4;

    public function new() {
        super();
        type = TextFieldType.DYNAMIC;
        selectable = false;
        mouseEnabled = false;
        multiline = false;
        wordWrap = false;
        autoSize = TextFieldAutoSize.LEFT;
        text = "";
        fontSize = 12;
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

    public var color(get, set):Int;
    private function get_color():Int {
        var format:TextFormat = getTextFormat();
        return format.color;
    }
    private function set_color(value:Int):Int {
        var format:TextFormat = getTextFormat();
        format.color = value;
        defaultTextFormat = format;
        setTextFormat(format);
        return value;
    }

    public var fontName(get, set):String;
    private function get_fontName():String {
        var format:TextFormat = getTextFormat();
        return format.font;
    }
    private function set_fontName(value:String):String {
        embedFonts = isEmbeddedFont(value);
        var format:TextFormat = getTextFormat();
        if (isEmbeddedFont(value) == true) {
            format.font = Assets.getFont(value).fontName;
        } else {
            format.font = value;
        }
        defaultTextFormat = format;
        setTextFormat(format);
        return value;
    }

    public var fontSize(get, set):Null<Float>;
    private function get_fontSize():Null<Float> {
        var format:TextFormat = getTextFormat();
        return cast format.size;
    }
    private function set_fontSize(value:Null<Float>):Null<Float> {
        var format:TextFormat = getTextFormat();
        format.size = cast value;
        defaultTextFormat = format;
        setTextFormat(format);
        return value;
    }

    private static inline function isEmbeddedFont(name:String) {
        return (name != "_sans" && name != "_serif" && name != "_typewriter");
    }
}