package lumod;

import sys.FileSystem;
import haxe.io.Path;

class Lumod {
    /**
     * The root path of all scripts.
     * 
     * ex. `LuaScriptClass.build("script.lua")` will find a script "script.lua" in the `scriptsRootPath` directory
     */
    public static var scriptsRootPath(default, set):String = "";
	static function set_scriptsRootPath(value:String):String {
		scriptsRootPath = Path.addTrailingSlash(Path.normalize(value));

		if (!FileSystem.exists(scriptsRootPath)) {
			FileSystem.createDirectory(scriptsRootPath);
        }

		return scriptsRootPath;
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
}