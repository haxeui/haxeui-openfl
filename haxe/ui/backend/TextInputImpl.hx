package haxe.ui.backend;

import haxe.ui.data.DataSource;
import haxe.ui.validation.InvalidationFlags;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class TextInputImpl extends TextDisplayImpl {
    public function new() {
        super();

        _resetHtmlText = false;
        
        textField.addEventListener(Event.CHANGE, onChange, false, 0, true);
        textField.addEventListener(Event.SCROLL, onScroll, false, 0, true);
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

        #if flash
        var format:TextFormat = tf.getTextFormat();
        format.font = "_sans";
        format.size = 13;
        tf.defaultTextFormat = format;
        #end

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
    
    public override function dispose() {
        if (textField != null) {
            if (parentComponent != null) {
                parentComponent.removeChild(textField);
            }
            textField.removeEventListener(Event.CHANGE, onChange);
            textField.removeEventListener(Event.SCROLL, onScroll);
            textField = null;
        }    
        super.dispose();
    }
    
    private override function set_dataSource(value:DataSource<String>):DataSource<String> {
        if (_dataSource != null) {
            _dataSource.onAdd = null;
            _dataSource.onChange = null;
        }
        _dataSource = value;
        if (_dataSource != null) {
            _dataSource.onAdd = onDataSourceAdd;
            _dataSource.onClear = onDataSourceClear;
        }
        return value;
    }
    
    private function onDataSourceAdd(s:String) {
        textField.appendText(s);
        parentComponent.text = textField.text;
        measureText();
        parentComponent.syncComponentValidation();
    }
    
    private function onDataSourceClear() {
        textField.text = "";
        parentComponent.text = "";
        measureText();
        parentComponent.syncComponentValidation();
    }
    
    private override function get_caretIndex():Int {
        return textField.caretIndex;
    }
    private override function set_caretIndex(value:Int):Int {
        textField.setSelection(value, value);
        return value;
    }
    
    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************
    private override function validateData() {
        textField.removeEventListener(Event.SCROLL, onScroll);
        
        super.validateData();
        
        var changed = false;
        var hscrollValue:Int = Math.round(_inputData.hscrollPos);
        if (textField.scrollH != hscrollValue) {
            textField.scrollH = hscrollValue;
            changed = true;
        }

        var vscrollValue:Int = Math.round(_inputData.vscrollPos);
        if (textField.scrollV != vscrollValue) {
            textField.scrollV = vscrollValue;
            changed = true;
        }
        
        textField.addEventListener(Event.SCROLL, onScroll, false, 0, true);
        
        if (changed == true) {
            onScroll(null);
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
        #if openfl_textfield_workarounds // not required for alot of apps, or later versions of openfl
        if (_width <= 0) {
            return;
        }
        #end
        super.measureText();

        #if flash
        _textHeight += 2;
        #end

        #if openfl_textfield_workarounds // not required for alot of apps, or later versions of openfl
        if (StringTools.endsWith(_text, "\n")) {
            _textHeight += textField.getLineMetrics(textField.numLines - 2).height;
        }
        #end

        _inputData.hscrollMax = textField.maxScrollH;
        // see below
        _inputData.hscrollPageSize = (_width * _inputData.hscrollMax) / _textWidth;

        var msv = textField.maxScrollV;
        #if openfl_textfield_workarounds // not required for alot of apps, or later versions of openfl
        if (msv > 1) {
            msv--;
        }
        #end
        _inputData.vscrollMax = msv;
        // cant have page size yet as there seems to be an openfl issue with bottomScrollV
        // https://github.com/openfl/openfl/issues/2220
        _inputData.vscrollPageSize = (_height * _inputData.vscrollMax) / _textHeight;
    }
    
    private function onChange(e) {
        _text = textField.text;
        _htmlText = textField.htmlText;

        measureText();
        
        if (_inputData.onChangedCallback != null) {
            _inputData.onChangedCallback();
        }
    }
    
    private function onScroll(e) {
        if (_inputData.vscrollPos - textField.scrollV > 2) { // weird openfl bug - randomly throws out scroll event and scrollV = 1
            return;
        }
        _inputData.hscrollPos = textField.scrollH;
        _inputData.vscrollPos = textField.scrollV;
        
        if (_inputData.onScrollCallback != null) {
            _inputData.onScrollCallback();
        }
    }
}
