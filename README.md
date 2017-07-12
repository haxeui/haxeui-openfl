<p align="center">
  <img src="http://haxeui.org/db/haxeui2-warning.png"/>
</p>

[![Build Status](https://travis-ci.org/haxeui/haxeui-openfl.svg?branch=master)](https://travis-ci.org/haxeui/haxeui-openfl)
[![Support this project on Patreon](http://haxeui.org/db/patreon_button.png)](https://www.patreon.com/haxeui)

# haxeui-openfl
`haxeui-openfl` is the `OpenFL` backend for HaxeUI.

<p align="center">
	<img src="https://github.com/haxeui/haxeui-openfl/raw/master/screen.png" />
</p>


## Installation
 * `haxeui-openfl` has a dependency to <a href="https://github.com/haxeui/haxeui-core">`haxeui-core`</a>, and so that too must be installed.
 * `haxeui-openfl` also has a dependency to <a href="http://www.openfl.org/">OpenFL</a>, please refer to the installation instructions on their <a href="http://www.openfl.org/">site</a>.
 
Eventually all these libs will become haxelibs, however, currently in their alpha form they do not even contain a `haxelib.json` file (for dependencies, etc) and therefore can only be used by downloading the source and using the `haxelib dev` command or by directly using the git versions using the `haxelib git` command (recommended). Eg:

```
haxelib git haxeui-core https://github.com/haxeui/haxeui-core
haxelib dev haxeui-openfl path/to/expanded/source/archive
```

## Usage
The simplest method to create a new `OpenFL` application that is HaxeUI ready is to use one of the <a href="https://github.com/haxeui/haxeui-templates">haxeui-templates</a>. These templates will allow you to start a new project rapidly with HaxeUI support baked in. 

If however you already have an existing application, then incorporating HaxeUI into that application is straight forward:

### project/application.xml
Assuming `haxeui-core` and `haxeui-openfl` have been installed, then adding HaxeUI to your existing application is as simple as adding these two lines to your `project.xml` or your `application.xml`:

```xml
<haxelib name="haxeui-core" />
<haxelib name="haxeui-openfl" />
```

_Note: Currently you must also include `haxeui-core` explicitly during the alpha, eventually `haxelib.json` files will exist to take care of this dependency automatically._ 

### Toolkit initialisation and usage
Initialising the toolkit requires you to add this single line somewhere _before_ you start to actually use HaxeUI in your application:

```
Toolkit.init();
```
Once the toolkit is initialised you can add components using the methods specified <a href="https://github.com/haxeui/haxeui-core#adding-components-using-haxe-code">here</a>.

## OpenFL specifics

As well as using the generic `Screen.instance.addComponent`, it is also possible to add components directly to any other `OpenFL` sprite (eg: `Lib.current.stage.addChild`)

## Addtional resources
* <a href="http://haxeui.github.io/haxeui-api/">haxeui-api</a> - The HaxeUI api docs.
* <a href="https://github.com/haxeui/haxeui-guides">haxeui-guides</a> - Set of guides to working with HaxeUI and backends.
* <a href="https://github.com/haxeui/haxeui-demo">haxeui-demo</a> - Demo application written using HaxeUI.
* <a href="https://github.com/haxeui/haxeui-templates">haxeui-templates</a> - Set of templates for IDE's to allow quick project creation.
* <a href="https://github.com/haxeui/haxeui-bdd">haxeui-bdd</a> - A behaviour driven development engine written specifically for HaxeUI (uses <a href="https://github.com/haxeui/haxe-bdd">haxe-bdd</a> which is a gherkin/cucumber inspired project).
* <a href="https://www.youtube.com/watch?v=L8J8qrR2VSg&feature=youtu.be">WWX2016 presentation</a> - A presentation given at WWX2016 regarding HaxeUI.

