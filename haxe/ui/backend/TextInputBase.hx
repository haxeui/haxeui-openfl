package haxe.ui.backend;

import haxe.ui.backend.TextDisplayBase;
import haxe.ui.components.TextArea;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;

class TextInputBase extends TextDisplayBase {
    @:access(haxe.ui.components.TextArea)
    public function new() {
        super();

        //PADDING_Y = 2;
    }

    private override function createTextField() {
        var tf:TextField = new TextField();
        tf.type = TextFieldType.INPUT;
        tf.selectable = true;
        tf.mouseEnabled = true;
        tf.autoSize = TextFieldAutoSize.NONE;

        return tf;
    }

    private var _password:Bool = false;
    private var _hscrollPos:Float = 0;
    private var _vscrollPos:Float = 0;

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private override function validateStyle():Bool {
        var measureTextRequired:Bool = false;

        if (textField.displayAsPassword != _password) {
            textField.displayAsPassword = _password;
        }

        var hscrollValue:Int = Std.int(_hscrollPos + 1);
        if (textField.scrollH != hscrollValue) {
            textField.scrollH = hscrollValue;
        }

        var vscrollValue:Int = Std.int(_vscrollPos + 1);
        if (textField.scrollV != vscrollValue) {
            textField.scrollV = vscrollValue;
        }

        return super.validateStyle() || measureTextRequired;
    }

    private override function measureText() {
        super.measureText();

        if (_multiline == true) {
            _textHeight = textField.maxScrollV + textField.height - 1;

            if (Std.is(parentComponent, TextArea)) {
                _height = (textField.bottomScrollV - textField.scrollV);

                #if flash
                _height += 1;
                #end
            }
        }
    }
}
