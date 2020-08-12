package haxe.ui.backend;

import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class TextDisplayImpl extends TextBase {
    private var PADDING_X:Int = 4;
    private var PADDING_Y:Int = 0;

    public var textField:TextField;

    public function new() {
        super();

        textField = createTextField();

        _text = "";
    }

    private function createTextField() {
        var tf:TextField = new TextField();
        tf.type = TextFieldType.DYNAMIC;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.autoSize = TextFieldAutoSize.LEFT;
        
        return tf;
    }

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private override function validateData() {
        if (_text != null) {
            if (_dataSource == null) {
                textField.text = normalizeText(_text);
            }
        } else if (_htmlText != null) {
            textField.htmlText = _htmlText;
        }
    }

    private override function validateStyle():Bool {
        var measureTextRequired:Bool = false;

        var format:TextFormat = textField.getTextFormat();

        if (_textStyle != null) {
            if (format.align != _textStyle.textAlign) {
                format.align = _textStyle.textAlign;
            }

            var fontSizeValue = Std.int(_textStyle.fontSize);
            if (_textStyle.fontSize == null) {
                fontSizeValue = 13;
            }
            if (format.size != fontSizeValue) {
                format.size = fontSizeValue;

                measureTextRequired = true;
            }

            if (_fontInfo != null && format.font != _fontInfo.data) {
                format.font = _fontInfo.data;
                measureTextRequired = true;
            }

            if (format.color != _textStyle.color) {
                format.color = _textStyle.color;
            }
            
            if (format.bold != _textStyle.fontBold) {
                format.bold = _textStyle.fontBold;
                measureTextRequired = true;
            }
            
            if (format.italic != _textStyle.fontItalic) {
                format.italic = _textStyle.fontItalic;
                measureTextRequired = true;
            }
            
            if (format.underline != _textStyle.fontUnderline) {
                format.underline = _textStyle.fontUnderline;
                measureTextRequired = true;
            }
        }

        textField.defaultTextFormat = format;
        textField.setTextFormat(format);
        if (_htmlText != null) {
            textField.htmlText = normalizeText(_htmlText);
        }

        if (textField.wordWrap != _displayData.wordWrap) {
            textField.wordWrap = _displayData.wordWrap;
            measureTextRequired = true;
        }

        if (textField.multiline != _displayData.multiline) {
            textField.multiline = _displayData.multiline;
            measureTextRequired = true;
        }

        return measureTextRequired;
    }

    private override function validatePosition() {
        _left = Math.round(_left);
        _top = Math.round(_top);
        
        #if html5
        textField.x = _left;
        textField.y = _top - 2;
        #elseif flash
        textField.x = _left - 3;
        textField.y = _top - 3;
        #else
        textField.x = _left - 1;
        textField.y = _top - 3;
        #end
    }

    private override function validateDisplay() {
        if (textField.width != _width) {
            textField.width = _width;
        }

        if (textField.height != _height) {
            #if flash
            textField.height = _height;
            //textField.height = _height + 4;
            #else
            textField.height = _height;
            #end
        }
    }

    private override function measureText() {
        textField.width = _width;
        
        #if !flash
        _textWidth = textField.textWidth + PADDING_X;
        //_textWidth = textField.textWidth + PADDING_X;
        #else
        //_textWidth = textField.textWidth - 2;
        #end
        _textHeight = textField.textHeight;
        if (_textHeight == 0) {
            var tmpText:String = textField.text;
            textField.text = "|";
            _textHeight = textField.textHeight;
            textField.text = tmpText;
        }
        #if !flash
        //_textHeight += PADDING_Y;
        #else
        //_textHeight -= 2;
        #end
        
        _textWidth = Math.round(_textWidth);
        _textHeight = Math.round(_textHeight);
    }
    
    private function normalizeText(text:String):String {
        text = StringTools.replace(text, "\\n", "\n");
        return text;
    }
}