package haxe.ui.backend.openfl.util;

import js.Browser;
import js.html.CSSStyleSheet;

class StyleSheetHelper {
    private static var _sheet:CSSStyleSheet = null;
    public function new() {
    }
    
    public static function getValidStyleSheet():CSSStyleSheet {
        if (_sheet != null) {
            return _sheet;
        }
        
        var sheet:CSSStyleSheet = null;
        for (test in Browser.document.styleSheets) {
            var css = cast(test, CSSStyleSheet);
            if (css.ownerNode.nodeName == "STYLE" && css.href == null) {
                sheet = css;
                break;
            }
        }
        
        if (sheet == null) {
            var styleElement = Browser.document.createStyleElement();
            styleElement.appendChild(Browser.document.createTextNode(""));
            Browser.document.head.appendChild(styleElement);
            sheet = cast(styleElement.sheet, CSSStyleSheet);
        }
        
        _sheet = sheet;
        return sheet;
    }
}