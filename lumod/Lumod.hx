package lumod;

import lumod.addons.LumodAddon;

class Lumod {
	/**
	 * The cache of scripts. Can be changed to your own class but it must extend `lumod.Cache`.
	 */
	public static var cache:Cache = new Cache();

	/**
	 * Dynamic function that handles the destination path of the script file.
	 * This can be useful if you want to handle more than one scripts.
	 * @param scriptPath The provided path in the `LuaScriptClass.build` macro.
	 * @return Path to the script.
	 */
	public static dynamic function scriptPathHandler(scriptPath:String):String {
		return 'lumod/' + scriptPath;
	}

	/**
	 * This function by default invokes the `Type.resolveClass` method.
	 * You can use this function to reject certain classes or resolve them in your own way.
	 * @param clsPath The path to the class
	 */
	public static dynamic function classResolver(clsPath:String):Class<Dynamic> {
		return Type.resolveClass(clsPath);
	}

	/**
	 * The list of addons that will be implemented everytime a class gets initialized.
	 * **TIP:** It is recommended to use `#if macro ... #end` on a operation that adds your addon to this list.
	 */
	public static var addons(default, never):Array<Class<LumodAddon>> = [
		#if (flixel && !macro)
		lumod.addons.FlixelAddon,
		#end
	];
}