package lumod;

class Reflected {
	public static function getProperty(instance:Dynamic, path:String) {
		var fieldPath = path.split(".");

		var object:Dynamic = instance;
		if (!_hasField(object, fieldPath[0])) {
			var paths = _getClassFromFieldPath(fieldPath);
			object = Type.resolveClass(paths[0]);
			fieldPath = paths[1].split(".");
        }

		for (f in fieldPath) {
			object = Reflect.getProperty(object, f);
		}

		return object;
	}

    public static function setProperty(instance:Dynamic, path:String, value:Dynamic) {
		var fieldPath = path.split(".");

		var object:Dynamic = instance;
		if (!_hasField(object, fieldPath[0])) {
			var paths = _getClassFromFieldPath(fieldPath);
			object = Type.resolveClass(paths[0]);
			fieldPath = paths[1].split(".");
		}

		var i = fieldPath.length;
		for (f in fieldPath) {
			if (--i == 0) {
				Reflect.setProperty(object, f, value);
				return;
            }
            else {
				object = Reflect.getProperty(object, f);
            }
		}
	}

	public static function hasField(instance:Dynamic, path:String) {
		var fieldPath = path.split(".");

		var object:Dynamic = instance;
		if (!_hasField(object, fieldPath[0])) {
			var paths = _getClassFromFieldPath(fieldPath);
			object = Type.resolveClass(paths[0]);
			fieldPath = paths[1].split(".");
		}

		var i = fieldPath.length;
		for (f in fieldPath) {
			if (--i == 0) {
				return _hasField(object, f);
            }
            else {
				object = Reflect.getProperty(object, f);
            }
		}

		return false;
	}

    private static function _getClassFromFieldPath(fieldPath:Array<String>) {
        var paths = ["", ""];
        var curIndex = 0;

        var i = fieldPath.length;
		for (f in fieldPath) {
			i--;

			if (curIndex == 0 && f.charAt(0).toUpperCase() == f.charAt(0)) { //wacky way to check if the character is uppercase
				paths[curIndex] += f;
				curIndex = 1;
            }
            else {
				paths[curIndex] += f + (i == 0 ? "" : ".");
            }
        }

		return paths;
    }

	private static function _hasField(obj:Dynamic, field:String) {
        if (Reflect.hasField(obj, field)) return true;
		if (Type.getInstanceFields(Type.getClass(obj)).contains(field)) return true;
        return false;
    }
}