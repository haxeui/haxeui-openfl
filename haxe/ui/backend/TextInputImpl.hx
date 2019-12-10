package haxe.ui.backend;

import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;

class TextInputImpl extends TextDisplayImpl {
    public function new() {
        super();

        textField.addEventListener(Event.CHANGE, onChange);
        textField.addEventListener(Event.SCROLL, onScroll);
        _inputData.vscrollPageStep = 1;
        _inputData.vscrollNativeWheel = true;
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

    public override function focus() {
        if (textField.stage != null) {
			textField.stage.focus = textField;
		}
    }
    
    public override function blur() {
        if (textField.stage != null) {
			textField.stage.focus = null;
		}
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

        if (parentComponent.disabled) {
            textField.selectable = false;
        } else {
            textField.selectable = true;
        }
        
        return measureTextRequired;
    }

    private override function validatePosition() {
        _left = Math.round(_left);
        _top = Math.round(_top);
        
        #if html5
        textField.x = _left - 3;
        textField.y = _top - 2;
        #elseif flash
        textField.x = _left;
        textField.y = _top;
        #else
        textField.x = _left - 3;
        textField.y = _top - 3;
        #end
    }
    
    private override function measureText() {
        super.measureText();
        
        _inputData.hscrollMax = textField.maxScrollH;
        // see below
        //_inputData.hscrollPageSize = (_width * _inputData.hscrollMax) / _textWidth;

        _inputData.vscrollMax = textField.maxScrollV;
        // cant have page size yet as there seems to be an openfl issue with bottomScrollV
        // https://github.com/openfl/openfl/issues/2220
        //_inputData.vscrollPageSize = (_height * _inputData.vscrollMax) / _textHeight;
    }
    
    private function onChange(e) {
        _text = textField.text;
        
        measureText();
        
        if (_inputData.onChangedCallback != null) {
            _inputData.onChangedCallback();
        }
    }
    
    private function onScroll(e) {
        _inputData.hscrollPos = textField.scrollH - 1;
        _inputData.vscrollPos = textField.scrollV - 1;
        
        if (_inputData.onScrollCallback != null) {
            _inputData.onScrollCallback();
        }
    }
}
