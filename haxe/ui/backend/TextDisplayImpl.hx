package haxe.ui.backend;

import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

#if cache_text_metrics
typedef TextMetricsCache = {
    var text:String;
    var width:Float;
    var textWidth:Float;
    var textHeight:Float;
}
#end

class TextDisplayImpl extends TextBase {
    private var PADDING_X:Int = 4;
    private var PADDING_Y:Int = 0;

    public var textField:TextField;

    private var _resetHtmlText:Bool = true;
    
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

        #if flash
        var format:TextFormat = tf.getTextFormat();
        format.font = "_sans";
        format.size = 13;
        tf.defaultTextFormat = format;
        #end

        #if cache_text_metrics
        var format:TextFormat = tf.getTextFormat();
        format.font = "_sans";
        format.size = 13;
        tf.defaultTextFormat = format;
        tf.wordWrap = true;
        tf.multiline = true;
        #end
        
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
            textField.htmlText = normalizeText(_htmlText);
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
            
            if (_textStyle.fontBold != null && format.bold != _textStyle.fontBold) {
                format.bold = _textStyle.fontBold;
                measureTextRequired = true;
            }
            
            if (_textStyle.fontItalic != null && format.italic != _textStyle.fontItalic) {
                format.italic = _textStyle.fontItalic;
                measureTextRequired = true;
            }
            
            if (_textStyle.fontUnderline != null && format.underline != _textStyle.fontUnderline) {
                format.underline = _textStyle.fontUnderline;
                measureTextRequired = true;
            }
        }

        textField.defaultTextFormat = format;
        #if flash
        textField.setTextFormat(format);
        #end
        if (textField.wordWrap != _displayData.wordWrap) {
            textField.wordWrap = _displayData.wordWrap;
            measureTextRequired = true;
        }
        if (_resetHtmlText == true && _htmlText != null) {
            textField.htmlText = normalizeText(_htmlText);
        }

        if (textField.multiline != _displayData.multiline) {
            textField.multiline = _displayData.multiline;
            measureTextRequired = true;
        }

        #if cache_text_metrics
        if (measureTextRequired) {
            _cachedMetrics = null;
        }
        #end

        return measureTextRequired;
    }

    private override function validatePosition() {
        _left = Math.round(_left);
        _top = Math.round(_top);
        
        #if html5
        textField.x = _left;
        textField.y = _top - 2;
        #elseif flash
        textField.x = _left - 2;
        textField.y = _top - 2;
        #else
        textField.x = _left - 1;
        textField.y = _top - 2;
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
            textField.height = _height + 1;
            #end
        }
    }

    #if cache_text_metrics
    private var _cachedMetrics:TextMetricsCache = null;
    #end
    private override function measureText() {
        #if cache_text_metrics
        if (_cachedMetrics != null) {
            if (_cachedMetrics.width == _width && _cachedMetrics.text == _text) {
                _textWidth = _cachedMetrics.textWidth;
                _textHeight = _cachedMetrics.textHeight;
                return;
            }
        }
        #end

        if (_width > 0) {
            textField.width = _width;
        }
        
        #if !flash
        _textWidth = textField.textWidth + PADDING_X;
        //_textWidth = textField.textWidth + PADDING_X;
        #else
        _textWidth = textField.textWidth - 2;
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
        //_textHeight += 2;
        #end
        
        _textWidth = Math.round(_textWidth);
        if (_textWidth % 2 != 0) {
            _textWidth += 1;
        }
        _textHeight = Math.round(_textHeight);
        if (_textHeight % 2 == 0) {
            _textHeight += 1;
        }

        #if cache_text_metrics
        _cachedMetrics = {
            text: _text,
            width: _width,
            textWidth: _textWidth,
            textHeight: _textHeight
        }
        #end
    }
    
    private override function get_supportsHtml():Bool {
        return true;
    }
    
    private function normalizeText(text:String):String {
        text = StringTools.replace(text, "\\n", "\n");
        text = StringTools.replace(text, "<br>", "\n");
        return text;
    }
    
    private var _tempField:TextField = null;
    public override function measureTextWidth():Float {
        if (_tempField == null) {
            _tempField = new TextField();
            _tempField.type = TextFieldType.DYNAMIC;
            _tempField.selectable = false;
            _tempField.mouseEnabled = false;
            _tempField.autoSize = TextFieldAutoSize.LEFT;
        }
        
        _tempField.defaultTextFormat = textField.defaultTextFormat;
        _tempField.text = textField.text;
        return _tempField.textWidth + PADDING_X;
    }
}