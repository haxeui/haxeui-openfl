package haxe.ui.core;

import haxe.ui.core.Component;
import haxe.ui.core.IComponentBase;
import haxe.ui.core.ImageDisplay;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.TextDisplay;
import haxe.ui.core.TextInput;
import haxe.ui.core.UIEvent;
import haxe.ui.openfl.EventMapper;
import haxe.ui.openfl.FilterConverter;
import haxe.ui.openfl.OpenFLStyleHelper;
import haxe.ui.styles.Style;
import haxe.ui.util.Rectangle;
import haxe.ui.util.filters.FilterParser;
import openfl.display.Sprite;
import openfl.events.Event;

class ComponentBase extends Sprite implements IComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;

    public function new() {
        super();
        tabChildren = false;
        #if flash
        focusRect = new Rectangle();
        #end
        _eventMap = new Map<String, UIEvent->Void>();

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event) {
        recursiveReady();
    }

    private function recursiveReady() {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        var component:Component = cast(this, Component);
        component.ready();
        for (child in component.childComponents) {
            child.recursiveReady();
        }
    }

    private function handleCreate(native:Bool):Void {

    }

    private function handlePosition(left:Null<Float>, top:Null<Float>, style:Style):Void {
        if (left != null) {
            //this.x = Std.int(left);
            this.x = Math.fceil(left);
        }
        if (top != null) {
            //this.y = Std.int(top);
            this.y = Math.fceil(top);
        }
    }

    private function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        if (width == null || height == null || width <= 0 || height <= 0) {
            return;
        }

        OpenFLStyleHelper.paintStyleSection(graphics, style, width, height);
        if (style.clip == true) {
            this.scrollRect = new openfl.geom.Rectangle(0, 0, width, height);
        }
    }

    private function handleClipRect(value:Rectangle):Void {
        if (value == null) {
            this.scrollRect = null;
        } else {
            this.scrollRect = new openfl.geom.Rectangle(value.left, value.top, value.width, value.height);
        }
    }

    private function handleReady() {

    }

    private function handlePreReposition() {

    }

    private function handlePostReposition() {

    }

    //***********************************************************************************************************
    // Text related
    //***********************************************************************************************************
    private var _textDisplay:TextDisplay;
    public function createTextDisplay(text:String = null):TextDisplay {
        if (_textDisplay == null) {
            _textDisplay = new TextDisplay();
            addChild(_textDisplay);
        }
        if (text != null) {
            _textDisplay.text = text;
        }
        return _textDisplay;
    }

    public function getTextDisplay():TextDisplay {
        return createTextDisplay();
    }

    public function hasTextDisplay():Bool {
        return (_textDisplay != null);
    }

    private var _textInput:TextInput;
    public function createTextInput(text:String = null):TextInput {
        if (_textInput == null) {
            _textInput = new TextInput();
            addChild(_textInput);
        }
        if (text != null) {
            _textInput.text = text;
        }
        return _textInput;
    }

    public function getTextInput():TextInput {
        return createTextInput();
    }

    public function hasTextInput():Bool {
        return (_textInput != null);
    }

    //***********************************************************************************************************
    // Image related
    //***********************************************************************************************************
    private var _imageDisplay:ImageDisplay;
    public function createImageDisplay():ImageDisplay {
        if (_imageDisplay == null) {
            _imageDisplay = new ImageDisplay();
            addChild(_imageDisplay);
        }
        return _imageDisplay;
    }

    public function getImageDisplay():ImageDisplay {
        return createImageDisplay();
    }

    public function hasImageDisplay():Bool {
        return (_imageDisplay != null);
    }

    public function removeImageDisplay():Void {
        if (_imageDisplay != null) {
            if (contains(_imageDisplay) == true) {
                removeChild(_imageDisplay);
            }
            _imageDisplay.dispose();
            _imageDisplay = null;
        }
    }

    //***********************************************************************************************************
    // Display tree
    //***********************************************************************************************************
    private function handleAddComponent(child:Component):Component {
        addChild(child);
        return child;
    }

    private function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        if (contains(child)) {
            removeChild(child);
        }
        return child;
    }

    private function applyStyle(style:Style) {
        var useHandCursor = false;
        if (style.cursor != null && style.cursor == "pointer") {
            useHandCursor = true;
        }

        this.buttonMode = useHandCursor;
        this.useHandCursor = useHandCursor;
        for (n in 0...this.numChildren) {
            var c = this.getChildAt(n);
            if (Std.is(c, Sprite)) {
                cast(c, Sprite).buttonMode = useHandCursor;
                cast(c, Sprite).useHandCursor = useHandCursor;
            }
        }

        if (style.filter != null) {
            var f = FilterConverter.convertFilter(FilterParser.parseFilter(style.filter));
            if (f != null) {
                this.filters = [f];
            }
        } else {
            this.filters = null;
        }

        if (style.hidden != null) {
            this.visible = !style.hidden;
        }

        if (style.opacity != null) {
            this.alpha = style.opacity;
        }
    }

    private function handleVisibility(show:Bool):Void {
        this.visible = show;
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.MOUSE_WHEEL
                | MouseEvent.CLICK:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onMouseEvent);
                }

            case UIEvent.CHANGE:
                if (_eventMap.exists(UIEvent.CHANGE) == false) {
                    if (hasTextInput() == true) {
                        _eventMap.set(UIEvent.CHANGE, listener);
                        getTextInput().addEventListener(Event.CHANGE, __onTextInputChange);
                    }
                }
        }
    }

    private function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.MOUSE_WHEEL
                | MouseEvent.CLICK:
                _eventMap.remove(type);
                removeEventListener(EventMapper.HAXEUI_TO_OPENFL.get(type), __onMouseEvent);

            case UIEvent.CHANGE:
                _eventMap.remove(type);
                if (hasTextInput() == true) {
                    getTextInput().removeEventListener(Event.CHANGE, __onTextInputChange);
                }
        }

    }

    //***********************************************************************************************************
    // Event handlers
    //***********************************************************************************************************
    private function __onMouseEvent(event:openfl.events.MouseEvent) {
        var type:String = EventMapper.OPENFL_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _eventMap.get(type);
            if (fn != null) {
                var mouseEvent = new MouseEvent(type);
                mouseEvent.screenX = event.stageX;
                mouseEvent.screenY = event.stageY;
                mouseEvent.buttonDown = event.buttonDown;
                mouseEvent.delta = event.delta;
                fn(mouseEvent);
            }
        }
    }

    private function __onTextInputChange(event:Event) {
        var fn:UIEvent->Void = _eventMap.get(UIEvent.CHANGE);
        if (fn != null) {
            fn(new UIEvent(UIEvent.CHANGE));
        }
    }
}