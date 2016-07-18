package haxe.ui.backend.openfl;

class EventMapper {
    public static var HAXEUI_TO_OPENFL:Map<String, String> = [
        haxe.ui.core.MouseEvent.MOUSE_MOVE => openfl.events.MouseEvent.MOUSE_MOVE,
        haxe.ui.core.MouseEvent.MOUSE_OVER => openfl.events.MouseEvent.MOUSE_OVER,
        haxe.ui.core.MouseEvent.MOUSE_OUT => openfl.events.MouseEvent.MOUSE_OUT,
        haxe.ui.core.MouseEvent.MOUSE_DOWN => openfl.events.MouseEvent.MOUSE_DOWN,
        haxe.ui.core.MouseEvent.MOUSE_UP => openfl.events.MouseEvent.MOUSE_UP,
        haxe.ui.core.MouseEvent.MOUSE_WHEEL => openfl.events.MouseEvent.MOUSE_WHEEL,
        haxe.ui.core.MouseEvent.CLICK => openfl.events.MouseEvent.CLICK,

        haxe.ui.core.KeyboardEvent.KEY_DOWN => openfl.events.KeyboardEvent.KEY_DOWN,
        haxe.ui.core.KeyboardEvent.KEY_UP => openfl.events.KeyboardEvent.KEY_UP
    ];

    public static var OPENFL_TO_HAXEUI:Map<String, String> = [
        openfl.events.MouseEvent.MOUSE_MOVE => haxe.ui.core.MouseEvent.MOUSE_MOVE,
        openfl.events.MouseEvent.MOUSE_OVER => haxe.ui.core.MouseEvent.MOUSE_OVER,
        openfl.events.MouseEvent.MOUSE_OUT => haxe.ui.core.MouseEvent.MOUSE_OUT,
        openfl.events.MouseEvent.MOUSE_DOWN => haxe.ui.core.MouseEvent.MOUSE_DOWN,
        openfl.events.MouseEvent.MOUSE_UP => haxe.ui.core.MouseEvent.MOUSE_UP,
        openfl.events.MouseEvent.MOUSE_WHEEL => haxe.ui.core.MouseEvent.MOUSE_WHEEL,
        openfl.events.MouseEvent.CLICK => haxe.ui.core.MouseEvent.CLICK,

        openfl.events.KeyboardEvent.KEY_DOWN => haxe.ui.core.KeyboardEvent.KEY_DOWN,
        openfl.events.KeyboardEvent.KEY_UP => haxe.ui.core.KeyboardEvent.KEY_UP
    ];
}