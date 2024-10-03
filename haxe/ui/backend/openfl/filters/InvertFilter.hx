package haxe.ui.backend.openfl.filters;

import openfl.filters.ColorMatrixFilter;

class InvertFilter { 
    public var filter:ColorMatrixFilter;

    /*<filter id="invert">
  <feComponentTransfer>
      <feFuncR type="table" tableValues="[amount] (1 - [amount])"/>
      <feFuncG type="table" tableValues="[amount] (1 - [amount])"/>
      <feFuncB type="table" tableValues="[amount] (1 - [amount])"/>
  </feComponentTransfer>
</filter>*/
    
    public function new(multiplier:Float = 1) {
        filter = new ColorMatrixFilter([
            -1*multiplier,  0,  0,  0, 255,
            0,  -1*multiplier,  0,  0, 255,
            0,   0, -1*multiplier,  0, 255,
            0,   0,  0,  1,   0]);
    }
}