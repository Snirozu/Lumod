package lumod;

import sys.FileSystem;
import haxe.io.Path;

class Lumod {
    /**
     * The root path of all scripts.
	 * Value of this variable can be overwritten by `get_scriptsRootPath`
     * 
     * ex. `LuaScriptClass.build("script.lua")` will find a script "script.lua" in the `scriptsRootPath` directory
     */
    public static var scriptsRootPath(get, set):String;
	private static var _scriptsRootPath:String = "";

	/**
	 * Getter for the root path of all scripts.
	 */
	public static dynamic function get_scriptsRootPath() {
		return _scriptsRootPath;
	}
	
	static function set_scriptsRootPath(value:String):String {
		_scriptsRootPath = Path.addTrailingSlash(Path.normalize(value));

		if (!FileSystem.exists(_scriptsRootPath)) {
			FileSystem.createDirectory(_scriptsRootPath);
        }

		return _scriptsRootPath;
	}
	/**
	 * The cache of scripts. Can be changed to your own class but it must extend `lumod.Cache`.
	 */
	public static var cache:Cache = new Cache();

	/**
	 * Dynamic function that handles the destination path of the script file.
	 * This can be useful if you want to use more than one mod.
	 * @param cls The class name
	 * @param scriptPath The provided path in the `LuaScriptClass.build` macro.
	 * @return Path that will begin from `scriptsRootPath`.
	 */
	public static dynamic function scriptPathHandler(cls:String, scriptPath:String):String {
		if (scriptPath == null)
			return scriptPath = cls + ".lua";
		return scriptPath;
	}

	/**
	 * This function by default invokes the `Type.resolveClass` method.
	 * You can use this function to reject certain classes or resolve them in your own way.
	 * @param clsPath The path to the class
	 */
	@:unreflective
	public static dynamic function classResolver(clsPath:String):Class<Dynamic> {
		return Type.resolveClass(clsPath);
	}
}