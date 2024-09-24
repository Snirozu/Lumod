# Lumod
Framework for modding compiled classes with Lua using Haxe macros and linc_luajit.

## How to use this??
### Setup
Firstly, install linc_luajit using:
```
haxelib git linc_luajit https://github.com/AndreiRudenko/linc_luajit
```
Then, install Lumod using:
```
haxelib install lumod
```
Then basically you can use `lumod.LuaScriptClass.build("script.lua")` build macro in your project in any class. <br>
Optionally if you want to change the Lua scripts directory, use `Lumod.scriptsRootPath = "newdirectory"` in the initial function of your project.

### How Lumod works
Every non-static function calls it's Lua script counterpart before it's code (lua function: `function`), and after it's code (lua function: `function_post`). <br>
The first Lua function's value is stored in a local function variable called `luaValue`, this can be used optionally for aborting functions etc.

## Pre-defined Functions
### Lua Script
* `close()` - Closes current Lua script.
* `getProperty(name)` - Gets a property from some class, by default it's the current haxe instance of current script. For example you can get the window of HaxeFlixel's game's width with `getProperty("flixel.FlxG.width")`.
* `setProperty(name, value)` - Basically works the same as the `getProperty` function but sets a value instead of getting it.
* `callFunction(function, arguments)` - Retrieves the function with the same technique as the `getProperty` function but instead of getting the property, it calls it like a method. Example usage: `callFunction("flixel.math.FlxMath.roundDecimal", [1.2485, 2])`.
* `hasField(name)` - Checks if a property exists.
* `isPropertyFunction(name)` - Checks if a property is a function.
* `isPropertyObject(name)` - Checks if a property is a object.
### Haxe class
* `luaCall(function, arguments)` - Calls a Lua function from the loaded script and returns it's value.
* `luaGet(variable)` - Gets a global Lua variable from the loaded script and returns it's value.
* `luaSet(variable, value)` - Creates or sets a global Lua variable in the loaded script to `value`.
* `luaAddCallback(name, callback)` - Declares a new function in the Lua script with a callback to `callback`.
* `luaLoad()` - Loads or reloads the Lua script instance.

## Pre-defined Functions (HScript)
To enable HScript use `LUMOD_HSCRIPT` Haxe Define in the project configuration. <br>
### Lua Script
* `haxeRun(code)` - Runs Haxe code via HScript interpreter.
* `haxeSet(variable, value)` - Sets a property in a HScript interpreter to a value.
* `haxeImport(class, ?as)` - Imports a class to the HScript interpreter, if `as` is specified, the class will be defined as the specified name.
### Haxe class
* `hscriptSet(variable, value)` - Sets a property in a HScript interpreter to a value.

## Print Example

`Game.hx`
``` haxe
@:build(lumod.LuaScriptClass.build()) // if `scriptPath` argument is not specified then it will set to "(Class name).lua"
class Game {
    function create() {
        Sys.println("create function");
    }
}
```

`Game.lua`
``` lua
function create()
    print("before create function")
end

function create_post()
    print("after create function")
end
```

`Output`
```
> before create function
> create function
> after create function
```
