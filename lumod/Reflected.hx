package lumod;

import haxe.Constraints.IMap;

class Reflected {
	public static function getProperty(instance:Dynamic, path:String) {
		var fieldPath = path.split(".");

		var object:Dynamic = instance;
		if (!objectHasField(object, fieldPath[0])) {
			var paths = splitClassAndPackage(fieldPath);
			object = Lumod.classResolver(paths[0]);
			fieldPath = paths[1].split(".");
        }

		for (f in fieldPath) {
			if (f.charAt(f.length - 1) == "]") { // detect a map
				var fieldAndKey = f.substr(0, f.length - 1).split('[');
				object = Reflect.getProperty(object, fieldAndKey[0]);
				if (!Std.isOfType(object, IMap))
					return null;
				object = cast (object, Map<Dynamic, Dynamic>).get(fieldAndKey[1]);
				continue;
			}
			object = Reflect.getProperty(object, f);
		}

		return object;
	}

    public static function setProperty(instance:Dynamic, path:String, value:Dynamic) {
		var fieldPath = path.split(".");

		var object:Dynamic = instance;
		if (!objectHasField(object, fieldPath[0])) {
			var paths = splitClassAndPackage(fieldPath);
			object = Lumod.classResolver(paths[0]);
			fieldPath = paths[1].split(".");
		}

		for (i => f in fieldPath) {
			if (i == fieldPath.length - 1) {
				if (f.charAt(f.length - 1) == "]") { // detect a map
					var fieldAndKey = f.substr(0, f.length - 1).split('[');
					object = Reflect.getProperty(object, fieldAndKey[0]);
					if (!Std.isOfType(object, IMap))
						return;
					cast(object, Map<Dynamic, Dynamic>).set(fieldAndKey[1], value);
					break;
				}
				Reflect.setProperty(object, f, value);
            }
            else {
				if (f.charAt(f.length - 1) == "]") { // detect a map
					var fieldAndKey = f.substr(0, f.length - 1).split('[');
					object = Reflect.getProperty(object, fieldAndKey[0]);
					if (!Std.isOfType(object, IMap))
						return;
					object = cast(object, Map<Dynamic, Dynamic>).get(fieldAndKey[1]);
					continue;
				}
				object = Reflect.getProperty(object, f);
            }
		}
	}

	public static function hasField(instance:Dynamic, path:String) {
		var fieldPath = path.split(".");

		var object:Dynamic = instance;
		if (!objectHasField(object, fieldPath[0])) {
			var paths = splitClassAndPackage(fieldPath);
			object = Lumod.classResolver(paths[0]);
			fieldPath = paths[1].split(".");
		}

		for (i => f in fieldPath) {
			if (i == fieldPath.length - 1) {
				if (f.charAt(f.length - 1) == "]") { // detect a map
					var fieldAndKey = f.substr(0, f.length - 1).split('[');
					object = Reflect.getProperty(object, fieldAndKey[0]);
					if (!Std.isOfType(object, IMap))
						return false;
					return cast(object, Map<Dynamic, Dynamic>).exists(fieldAndKey[1]);
				}
				return objectHasField(object, f);
            }
            else {
				if (f.charAt(f.length - 1) == "]") { // detect a map
					var fieldAndKey = f.substr(0, f.length - 1).split('[');
					object = Reflect.getProperty(object, fieldAndKey[0]);
					if (!Std.isOfType(object, IMap))
						return false;
					object = cast(object, Map<Dynamic, Dynamic>).get(fieldAndKey[1]);
					continue;
				}
				object = Reflect.getProperty(object, f);
            }
		}

		return false;
	}

	// returns [className, packagePath]
    private static function splitClassAndPackage(fieldPath:Array<String>) {
        var paths = ["", ""];
        var curIndex = 0;

		for (i => f in fieldPath) {
			if (curIndex == 0 && f.charAt(0).toUpperCase() == f.charAt(0)) { //wacky way to check if the character is uppercase
				paths[curIndex] += f;
				curIndex = 1;
            }
            else {
				paths[curIndex] += f + (i == fieldPath.length - 1 ? "" : ".");
            }
        }

		return paths;
    }

	private static function objectHasField(obj:Dynamic, field:String) {
        if (Reflect.hasField(obj, field)) return true;
		if (Type.getInstanceFields(Type.getClass(obj)).contains(field)) return true;
        return false;
    }
}