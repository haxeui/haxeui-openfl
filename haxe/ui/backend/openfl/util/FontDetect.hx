package haxe.ui.backend.openfl.util;

// port of js lib "FontDetect"
class FontDetect {
    private static var _initialized = false;
    private static var span = null;
    private static var _aFallbackFonts = ['serif', 'sans-serif', 'monospace', 'cursive', 'fantasy'];
    
    private function new() {       
    }
    
    public static function init() {
        #if js

        if (_initialized == true) {
            return;
        }
        
        _initialized = true;
        
        var body = js.Browser.document.body;
        var firstChild = js.Browser.document.body.firstChild;
        
        var div = js.Browser.document.createElement('div');
        div.id = 'fontdetectHelper';
        span = js.Browser.document.createElement('span');
        span.innerText = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        div.appendChild(span);

        body.insertBefore(div, firstChild);

        div.style.position   = 'absolute';
        div.style.visibility = 'hidden';
        div.style.top        = '-200px';
        div.style.left       = '-100000px';
        div.style.width      = '100000px';
        div.style.height     = '200px';
        div.style.fontSize   = '100px';

        #end
    }
    
    public static function onFontLoaded(cssFontName:String, onLoad:String->Void, onFail:String->Void = null, options:Dynamic = null) {
        #if js

        if (cssFontName == null) {
            return;
        }
        
        var msInterval = 10;
        if (options != null && options.msInterval != null) {
            msInterval = options.msInterval;
        }
        
        var msTimeout = 2000;
        if (options != null && options.msTimeout != null) {
            msTimeout = options.msTimeout;
        }
        
        if (onLoad == null && onFail == null) {
            return;
        }
        
        if (_initialized == false) {
            init();
        }
        
        if (isFontLoaded(cssFontName)) { // It's already here, so no need to poll.
            if (onLoad != null) {
                onLoad(cssFontName);
            }
            return;
        }
        
        // At this point we know the font hasn't loaded yet. Add it to the list of fonts to monitor.
        
        // Set up an interval using msInterval. The callback calls isFontLoaded(), & if true
        // it closes the interval & calls p_onLoad, else if the current time has timed out
        // it closes the interval & calls onFail if there is one.
        
        var utStart = Date.now().getTime();
        var idInterval = 0;
        idInterval = js.Browser.window.setInterval(function() {
            if (isFontLoaded(cssFontName)) {
                js.Browser.window.clearInterval(idInterval);
                if (onLoad != null) {
                    onLoad(cssFontName);
                }
                return;
            } else {
                var utNow = Date.now().getTime();
                if ((utNow - utStart) > msTimeout) {
                    js.Browser.window.clearInterval(idInterval);
                    if (onFail != null) {
                        onFail(cssFontName);
                    }
                }
            }
        }, msInterval);

        #end
    }
    
    public static function isFontLoaded(cssFontName:String):Bool {
        #if js

        var wThisFont = 0;
        var wPrevFont = 0;
        
        if (_initialized == false) {
            init();
        }
        
        for (ix in 0..._aFallbackFonts.length) {
            span.style.fontFamily = cssFontName + ',' + _aFallbackFonts[ix];
            wThisFont = span.offsetWidth;
            if (ix > 0 && wThisFont != wPrevFont) {
                // This iteration's font was different than the previous iteration's font, so it must
                // have fallen back on a generic font. So our font must not exist.
                return false;
            }
            
            wPrevFont = wThisFont;
        }
        
        // The widths were all the same, therefore the browser must have rendered the text in the same
        // font every time. So unless all the generic fonts are identical widths (highly unlikely), it 
        // couldn't have fallen back to a generic font. It's our font.

        #end

        return true;
    }
}