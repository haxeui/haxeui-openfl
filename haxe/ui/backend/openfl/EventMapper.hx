package haxe.ui.backend.openfl;

class EventMapper {
    public static var HAXEUI_TO_OPENFL:Map<String, String> = [
        haxe.ui.events.MouseEvent.MOUSE_MOVE => openfl.events.MouseEvent.MOUSE_MOVE,
        haxe.ui.events.MouseEvent.MOUSE_OVER => openfl.events.MouseEvent.MOUSE_OVER,
        haxe.ui.events.MouseEvent.MOUSE_OUT => openfl.events.MouseEvent.MOUSE_OUT,
        haxe.ui.events.MouseEvent.MOUSE_DOWN => openfl.events.MouseEvent.MOUSE_DOWN,
        haxe.ui.events.MouseEvent.MOUSE_UP => openfl.events.MouseEvent.MOUSE_UP,
        haxe.ui.events.MouseEvent.MOUSE_WHEEL => openfl.events.MouseEvent.MOUSE_WHEEL,
        haxe.ui.events.MouseEvent.CLICK => openfl.events.MouseEvent.CLICK,
        haxe.ui.events.MouseEvent.DBL_CLICK => openfl.events.MouseEvent.DOUBLE_CLICK,
        haxe.ui.events.MouseEvent.RIGHT_CLICK => openfl.events.MouseEvent.RIGHT_CLICK,
        haxe.ui.events.MouseEvent.RIGHT_MOUSE_DOWN => openfl.events.MouseEvent.RIGHT_MOUSE_DOWN,
        haxe.ui.events.MouseEvent.RIGHT_MOUSE_UP => openfl.events.MouseEvent.RIGHT_MOUSE_UP,

        haxe.ui.events.KeyboardEvent.KEY_DOWN => openfl.events.KeyboardEvent.KEY_DOWN,
        haxe.ui.events.KeyboardEvent.KEY_UP => openfl.events.KeyboardEvent.KEY_UP
    ];

    public static var OPENFL_TO_HAXEUI:Map<String, String> = [
        openfl.events.MouseEvent.MOUSE_MOVE => haxe.ui.events.MouseEvent.MOUSE_MOVE,
        openfl.events.MouseEvent.MOUSE_OVER => haxe.ui.events.MouseEvent.MOUSE_OVER,
        openfl.events.MouseEvent.MOUSE_OUT => haxe.ui.events.MouseEvent.MOUSE_OUT,
        openfl.events.MouseEvent.MOUSE_DOWN => haxe.ui.events.MouseEvent.MOUSE_DOWN,
        openfl.events.MouseEvent.MOUSE_UP => haxe.ui.events.MouseEvent.MOUSE_UP,
        openfl.events.MouseEvent.MOUSE_WHEEL => haxe.ui.events.MouseEvent.MOUSE_WHEEL,
        openfl.events.MouseEvent.CLICK => haxe.ui.events.MouseEvent.CLICK,
        openfl.events.MouseEvent.DOUBLE_CLICK => haxe.ui.events.MouseEvent.DBL_CLICK,
        openfl.events.MouseEvent.RIGHT_CLICK => haxe.ui.events.MouseEvent.RIGHT_CLICK,
        openfl.events.MouseEvent.RIGHT_MOUSE_DOWN => haxe.ui.events.MouseEvent.RIGHT_MOUSE_DOWN,
        openfl.events.MouseEvent.RIGHT_MOUSE_UP => haxe.ui.events.MouseEvent.RIGHT_MOUSE_UP,

        openfl.events.KeyboardEvent.KEY_DOWN => haxe.ui.events.KeyboardEvent.KEY_DOWN,
        openfl.events.KeyboardEvent.KEY_UP => haxe.ui.events.KeyboardEvent.KEY_UP
    ];
}