package haxe.ui.backend;

import haxe.ui.backend.TextDisplayBase;
import haxe.ui.core.TextInput.TextInputData;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;

class TextInputBase extends TextDisplayBase {
    private var _inputData:TextInputData = new TextInputData();
    
    public function new() {
        super();

        textField.addEventListener(Event.CHANGE, onChange);
    }

    private override function createTextField() {
        var tf:TextField = new TextField();
        tf.type = TextFieldType.INPUT;
        tf.selectable = true;
        tf.mouseEnabled = true;
        tf.autoSize = TextFieldAutoSize.NONE;
        tf.multiline = true;
        tf.wordWrap = true;

        return tf;
    }

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************
    private override function validateData() {
        super.validateData();
        
        var hscrollValue:Int = Std.int(_inputData.hscrollPos + 1);
        if (textField.scrollH != hscrollValue) {
            textField.scrollH = hscrollValue;
        }

        var vscrollValue:Int = Std.int(_inputData.vscrollPos + 1);
        if (textField.scrollV != vscrollValue) {
            textField.scrollV = vscrollValue;
        }
    }
    
    private override function validateStyle():Bool {
        var measureTextRequired:Bool = super.validateStyle();

        if (textField.displayAsPassword != _inputData.password) {
            textField.displayAsPassword = _inputData.password;
        }

        return measureTextRequired;
    }

    private override function measureText() {
        super.measureText();
        
        _inputData.hscrollMax = _textWidth - _width;
        _inputData.hscrollPageSize = (_width * _inputData.hscrollMax) / _textWidth;
        
        _inputData.vscrollMax = _textHeight - _height;
        _inputData.vscrollPageSize = (_height * _inputData.vscrollMax) / _textHeight;
    }
    
    private function onChange(e) {
        _text = textField.text;
    }
}
