package lumod;

import sys.FileSystem;
import sys.io.File;

class Cache {
	public var scripts:Map<String, String>;

	public function new() {
		scripts = new Map();
	}

	public function existsScript(path:String) {
		if (scripts.exists(path)) return true;
		return FileSystem.exists(path);
	}

	public function getScript(path:String) {
		if (scripts.exists(path)) // avoid unnecessary filesystem calls
			return scripts.get(path);

		if (!FileSystem.exists(path))
			return null;

		scripts.set(path, File.getContent(path));
		return scripts.get(path);
	}
}
