package lumod.addons;

import haxe.Constraints.Function;

class LumodAddon {
	/**
	 * The instance of the class
	 */
	var instance:Dynamic;

	private function new(instance:Dynamic) {
		this.instance = instance;

		init();
	}

	function init() {}

	/**
	 * Declares a new function in the Lua script.
	 */
	public function addCallback(name:String, func:Function) {
		instance.lmAddCallback(name, func);
	}
}
