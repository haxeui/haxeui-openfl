package haxe.ui.backend;

import haxe.ui.core.Component;
import openfl.text.TextFormatAlign;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class TextDisplayBase {

    public var textField:TextField;
    public var parentComponent:Component;

    private var PADDING_X:Int = 0;
    private var PADDING_Y:Int = 4;// -4;

    public function new() {
        textField = createTextField();

        _text = "";
        _fontSize = 12;
        _textAlign = TextFormatAlign.LEFT;
        _multiline = false;
        _wordWrap = false;
    }

    private function createTextField() {
        var tf:TextField = new TextField();
        tf.type = TextFieldType.DYNAMIC;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.autoSize = TextFieldAutoSize.LEFT;

        return tf;
    }

    private var _text:String;
    private var _left:Float = 0;
    private var _top:Float = 0;
    private var _width:Float = 0;
    private var _height:Float = 0;
    private var _textWidth:Float = 0;
    private var _textHeight:Float = 0;
    private var _color:Int;
    private var _fontName:String;
    private var _fontSize:Float;
    private var _textAlign:String;
    private var _multiline:Bool = true;
    private var _wordWrap:Bool = false;

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private function validateData() {
        textField.text = _text;
    }

    private function validateStyle():Bool {
        var measureTextRequired:Bool = false;

        var format:TextFormat = textField.getTextFormat();

        if (format.align != _textAlign) {
            format.align = _textAlign;
        }

        var fontSizeValue = Std.int(_fontSize);
        if (format.size != fontSizeValue) {
            format.size = fontSizeValue;

            measureTextRequired = true;
        }

        if (format.font != _fontName) {
            if (isEmbeddedFont(_fontName) == true) {
                format.font = Assets.getFont(_fontName).fontName;
            } else {
                format.font = _fontName;
            }

            measureTextRequired = true;
        }

        if (format.color != _color) {
            format.color = _color;
        }

        textField.defaultTextFormat = format;
        textField.setTextFormat(format);

        if (textField.wordWrap != _wordWrap) {
            textField.wordWrap = _wordWrap;

            measureTextRequired = true;
        }

        if (textField.multiline != _multiline) {
            textField.multiline = _multiline;

            measureTextRequired = true;
        }

        return measureTextRequired;
    }

    private function validatePosition() {
        textField.x = _left - 2 + (PADDING_X / 2);
        textField.y = _top - 2 + (PADDING_Y / 2);
    }

    private function validateDisplay() {
        if (textField.width != _width) {
            textField.width = _width;
        }

        if (textField.height != _height) {
            textField.height = _height;
        }
    }

    private function measureText() {
        _textWidth = textField.textWidth + PADDING_X;
        _textHeight = textField.textHeight + PADDING_Y;
    }

    //***********************************************************************************************************
    // Util functions
    //***********************************************************************************************************

    private static inline function isEmbeddedFont(name:String) {
        return (name != "_sans" && name != "_serif" && name != "_typewriter");
    }
}