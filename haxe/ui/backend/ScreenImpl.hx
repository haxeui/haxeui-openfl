package haxe.ui.backend;

import haxe.ui.backend.openfl.EventMapper;
import haxe.ui.core.Component;
import haxe.ui.events.KeyboardEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import lime.system.System;
import openfl.Lib;
import openfl.display.DisplayObjectContainer;
import openfl.display.StageAlign;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;

class ScreenImpl extends ScreenBase {
    private var _mapping:Map<String, UIEvent->Void>;

    public function new() {
        _mapping = new Map<String, UIEvent->Void>();
    }

    private override function get_width():Float {
        if (container == Lib.current.stage) {
            return Lib.current.stage.stageWidth;
        }
        return container.width;
    }

    private override function get_height():Float {
        if (container == Lib.current.stage) {
            return Lib.current.stage.stageHeight;
        }
        return container.height;
    }

    private override function get_dpi():Float {
        return System.getDisplay(0).dpi;
    }

    private override function get_focus():Component {
        return cast Lib.current.stage.focus;
    }
    
    private override function set_focus(value:Component):Component {
        if (value != null && value.hasTextInput()) {
            Lib.current.stage.focus = value.getTextInput().textField;
        } else {
            Lib.current.stage.focus = value;
        }
        return value;
    }

    private override function set_title(s:String):String {
        #if (flash || android || ios )
        trace("WARNING: this platform doesnt support dynamic titles");
        #end
        Lib.current.stage.window.title = s;
        return s;
    }
    private override function get_title():String {
        #if (flash || android || ios )
        trace("WARNING: this platform doesnt support dynamic titles");
        #end
        return Lib.current.stage.window.title;
    }

    public override function addComponent(component:Component):Component {
        component.scaleX = Toolkit.scaleX;
        component.scaleY = Toolkit.scaleY;
        if (_topLevelComponents.indexOf(component) == -1) {
            _topLevelComponents.push(component);
            container.addChild(component);
            onContainerResize(null);
        }
		return component;
    }

    public override function removeComponent(component:Component):Component {
        _topLevelComponents.remove(component);
        container.removeChild(component);
		return component;
    }

    private override function handleSetComponentIndex(child:Component, index:Int) {
        _topLevelComponents.remove(child);
        _topLevelComponents.insert(index, child);
        
        var offset = 0;
        for (i in 0...container.numChildren) {
            var c = container.getChildAt(i);
            if ((c is Component)) {
                offset = i;
                break;
            }
        }
        
        container.setChildIndex(child, index + offset);
    }

    private function onContainerResize(event:openfl.events.Event) {
        for (c in _topLevelComponents) {
            if (c.percentWidth > 0) {
                c.width = ((this.width) * c.percentWidth) / 100;
            }
            if (c.percentHeight > 0) {
                c.height = ((this.height) * c.percentHeight) / 100;
            }
        }
        __onStageResize();
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
    // Events
    //***********************************************************************************************************
    private override function supportsEvent(type:String):Bool {
        if (type == UIEvent.RESIZE) {
            return true;
        }
        return EventMapper.HAXEUI_TO_OPENFL.get(type) != null;
    }

    private override function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK | MouseEvent.DBL_CLICK
                | MouseEvent.RIGHT_MOUSE_DOWN | MouseEvent.RIGHT_MOUSE_UP | MouseEvent.RIGHT_CLICK:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    Lib.current.stage.addEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onMouseEvent);
                }

            case KeyboardEvent.KEY_DOWN | KeyboardEvent.KEY_UP:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    Lib.current.stage.addEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onKeyEvent);
                }
                
            case UIEvent.RESIZE:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                }
        }
    }

    private override function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK | MouseEvent.DBL_CLICK
                | MouseEvent.RIGHT_MOUSE_DOWN | MouseEvent.RIGHT_MOUSE_UP | MouseEvent.RIGHT_CLICK:
                _mapping.remove(type);
                Lib.current.stage.removeEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onMouseEvent);

            case KeyboardEvent.KEY_DOWN | KeyboardEvent.KEY_UP:
                _mapping.remove(type);
                Lib.current.stage.removeEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onKeyEvent);
                
            case UIEvent.RESIZE:
                _mapping.remove(type);
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
                mouseEvent.ctrlKey = event.ctrlKey;
                mouseEvent.shiftKey = event.shiftKey;
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
                keyboardEvent.ctrlKey = event.ctrlKey;
                keyboardEvent.shiftKey = event.shiftKey;
                fn(keyboardEvent);
            }
        }
    }
    
    private function __onStageResize() {
        var type:String = UIEvent.RESIZE;
        if (type != null) {
            var fn = _mapping.get(type);
            if (fn != null) {
                var uiEvent = new UIEvent(type);
                fn(uiEvent);
            }
        }
    }
}
