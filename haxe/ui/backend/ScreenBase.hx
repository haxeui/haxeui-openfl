package haxe.ui.backend;

import flash.display.DisplayObjectContainer;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.DialogButton;
import haxe.ui.core.Component;
import haxe.ui.core.KeyboardEvent;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.UIEvent;
import haxe.ui.backend.openfl.EventMapper;
import lime.system.System;
import openfl.display.StageAlign;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;
import openfl.Lib;

class ScreenBase {
    private var _mapping:Map<String, UIEvent->Void>;

    public function new() {
        _mapping = new Map<String, UIEvent->Void>();
    }

    public var options(default, default):ToolkitOptions;

    public var width(get, null):Float;
    private function get_width():Float {
        if (container == Lib.current.stage) {
            return Lib.current.stage.stageWidth / Toolkit.scaleX;
        }
        return container.width / Toolkit.scaleX;
    }

    public var height(get, null):Float;
    private function get_height():Float {
        if (container == Lib.current.stage) {
            return Lib.current.stage.stageHeight / Toolkit.scaleY;
        }
        return container.height / Toolkit.scaleY;
    }

    public var dpi(get, null):Float;
    private function get_dpi():Float {
        return System.getDisplay(0).dpi;
    }

    public var focus(get, set):Component;
    private function get_focus():Component {
        return cast Lib.current.stage.focus;
    }
    private function set_focus(value:Component):Component {
        if (value != null && value.hasTextInput()) {
            Lib.current.stage.focus = value.getTextInput().textField;
        } else {
            Lib.current.stage.focus = value;
        }
        return value;
    }

    public var title(get,set):String;
    private inline function set_title(s:String):String {
        #if (flash || android || ios )
        trace("WARNING: this platform doesnt support dynamic titles");
        #end
        Lib.current.stage.window.title = s;
        return s;
    }
    private inline function get_title():String {
        #if (flash || android || ios )
        trace("WARNING: this platform doesnt support dynamic titles");
        #end
        return Lib.current.stage.window.title;
    }

    private var _topLevelComponents:Array<Component> = new Array<Component>();
    public function addComponent(component:Component) {
        component.scaleX =  Toolkit.scaleX;
        component.scaleY =  Toolkit.scaleY;
        _topLevelComponents.push(component);
        container.addChild(component);
        onContainerResize(null);
    }

    public function removeComponent(component:Component) {
        _topLevelComponents.remove(component);
        container.removeChild(component);
    }

    private function handleSetComponentIndex(child:Component, index:Int) {
        container.setChildIndex(child, index);
    }

    private function onContainerResize(event:openfl.events.Event) {
        for (c in _topLevelComponents) {
            if (c.percentWidth > 0) {
                c.width = (this.width * c.percentWidth) / 100;
            }
            if (c.percentHeight > 0) {
                c.height = (this.height * c.percentHeight) / 100;
            }
        }
    }

    private var _containerReady:Bool = false;
    private var container(get, null):DisplayObjectContainer;
    private function get_container():DisplayObjectContainer {
        var c = null;
        if (options == null || options.container == null) {
            c = Lib.current.stage;
        } else {
            c = options.container;
        }

        if (_containerReady == false) {
            c.stage.quality = StageQuality.BEST;
            c.scaleMode = StageScaleMode.NO_SCALE;
            c.align = StageAlign.TOP_LEFT;
            c.addEventListener(openfl.events.Event.RESIZE, onContainerResize);
            _containerReady = true;
        }

        return c;
    }

    //***********************************************************************************************************
    // Dialogs
    //***********************************************************************************************************
    public function messageDialog(message:String, title:String = null, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        return null;
    }

    public function showDialog(content:Component, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        return null;
    }

    public function hideDialog(dialog:Dialog):Bool {
        return false;
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private function supportsEvent(type:String):Bool {
        return EventMapper.HAXEUI_TO_OPENFL.get(type) != null;
    }

    private function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    Lib.current.stage.addEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onMouseEvent);
                }

            case KeyboardEvent.KEY_DOWN | KeyboardEvent.KEY_UP:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    Lib.current.stage.addEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onKeyEvent);
                }
        }
    }

    private function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK:
                _mapping.remove(type);
                Lib.current.stage.removeEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onMouseEvent);

            case KeyboardEvent.KEY_DOWN | KeyboardEvent.KEY_UP:
                _mapping.remove(type);
                Lib.current.stage.removeEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onKeyEvent);
        }
    }

    private function __onMouseEvent(event:openfl.events.MouseEvent) {
        var type:String = EventMapper.OPENFL_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _mapping.get(type);
            if (fn != null) {
                var mouseEvent = new MouseEvent(type);
                mouseEvent._originalEvent = event;
                mouseEvent.screenX = event.stageX / Toolkit.scaleX;
                mouseEvent.screenY = event.stageY / Toolkit.scaleY;
                mouseEvent.buttonDown = event.buttonDown;
                fn(mouseEvent);
            }
        }
    }

    private function __onKeyEvent(event:openfl.events.KeyboardEvent) {
        var type:String = EventMapper.OPENFL_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _mapping.get(type);
            if (fn != null) {
                var keyboardEvent = new KeyboardEvent(type);
                keyboardEvent._originalEvent = event;
                keyboardEvent.keyCode = event.keyCode;
                keyboardEvent.shiftKey = event.shiftKey;
                fn(keyboardEvent);
            }
        }
    }
}
