package haxe.ui.backend;

import haxe.ui.events.UIEvent;
import openfl.events.Event;

@:allow(haxe.ui.backend.ScreenImpl)
@:allow(haxe.ui.backend.ComponentImpl)
class EventImpl extends EventBase {
    private var _originalEvent:Event;

    public override function cancel() {
        if (_originalEvent != null) {
            _originalEvent.preventDefault();
            _originalEvent.stopImmediatePropagation();
            _originalEvent.stopPropagation();
        }
    }
    
    private override function postClone(event:UIEvent) {
        event._originalEvent = this._originalEvent;
    }
}