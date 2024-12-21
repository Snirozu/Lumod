package lumod;

import haxe.macro.Expr;

@:publicFields
class Util {
	static function setMap(parent:Dynamic, key:String, val:Dynamic) {
        if (key == "this")
            return;

		#if FLX_SOUND_SYSTEM
		if (key == "music")
			return;
		#end

		parent.lmObjects.set(key, val);
    }

	static function getID(parent:Dynamic, key:Null<String>):Dynamic {
        if (key == null)
            return null;

		if (key == "this")
			return parent;

		#if FLX_SOUND_SYSTEM
		if (key == "music")
			return flixel.FlxG.sound.music;
		#end

		if (parent.lmObjects.exists(key))
			return parent.lmObjects.get(key);

		return Reflected.getProperty(parent, key);
	}

	static function listSuperClasses(classType:haxe.macro.Type.ClassType, ?arr:Null<Array<String>>) {
		if (arr == null)
			arr = [];

		arr.push(classType.pack.join('.') + '.' + classType.name);

		if (classType.superClass != null) {
			listSuperClasses(classType.superClass.t.get(), arr);
		}

		return arr;
	}

	static function extendsType(classType:haxe.macro.Type.ClassType, classPath:String):Bool {
		if (classType.pack.join('.') + '.' + classType.name == classPath)
			return true;

		if (classType.superClass != null)
			return extendsType(classType.superClass.t.get(), classPath);

		return false;
	}

	static inline function caseFirst(v:Null<String>) {
		if (v == null)
			return null;

		return v.charAt(0).toUpperCase() + v.substr(1);
	}

	static macro function addGetSetCallback(instance:Dynamic, fieldName:String, ?valueAsObject:Bool = false, ?isReadOnly:Bool = false) {
		// upper case first letter
		var fieldUpper:String = lumod.Util.caseFirst(fieldName);

		return macro {
			${!isReadOnly ? macro {
            ${instance}.lmAddCallback($v{"set" + fieldUpper}, function(id:String, v:Dynamic) {
                return lumod.Util.getID(${instance}, id).$fieldName = ${
                    valueAsObject ? macro lumod.Util.getID(${instance}, v) : macro v
                };
            });
            } : macro {}}
			${instance}.lmAddCallback($v{"get" + fieldUpper}, function(id:String) {
				return lumod.Util.getID(${instance}, id).$fieldName;
			});
		}
	}

	static macro function addArrayCallback(instance:Dynamic, fieldName:String, valueAsObject:Bool = false, ?fieldTitle:Null<String>):Expr {
		// upper case first letter
		final fieldUpper:String = lumod.Util.caseFirst(fieldName);
		final titleUpper:String = lumod.Util.caseFirst(fieldTitle) ?? fieldUpper;

		var valExpr:Expr = valueAsObject ? macro lumod.Util.getID(${instance}, v) : macro v;

		return macro {
			${instance}.lmAddCallback($v{"add" + titleUpper}, function(id:String, v:Dynamic) {
				return lumod.Util.getID(${instance}, id).$fieldName.push($e{valExpr});
			});
			${instance}.lmAddCallback($v{"remove" + titleUpper}, function(id:String, v:Dynamic) {
				return lumod.Util.getID(${instance}, id).$fieldName.remove($e{valExpr});
			});
			${instance}.lmAddCallback($v{"insert" + titleUpper}, function(id:String, v:Dynamic, pos:Int) {
				return lumod.Util.getID(${instance}, id).$fieldName.insert(pos, $e{valExpr});
			});
			${instance}.lmAddCallback($v{"has" + titleUpper}, function(id:String, v:Dynamic) {
				return lumod.Util.getID(${instance}, id).$fieldName.contains($e{valExpr});
			});
			${instance}.lmAddCallback($v{"clear" + fieldUpper}, function(id:String) {
				return lumod.Util.getID(${instance}, id).$fieldName.clear();
			});
		}
	}

	static macro function addFlxPointCallback(instance:Dynamic, fieldName:String):haxe.macro.Expr {
		// upper case first letter
		var fieldUpper:String = lumod.Util.caseFirst(fieldName);

		return macro {
			${instance}.lmAddCallback($v{"set" + fieldUpper}, function(id:String, x:Dynamic, y:Dynamic) {
				return lumod.Util.getID(${instance}, id).$fieldName.set(x, y);
			});
			${instance}.lmAddCallback($v{"set" + fieldUpper + "X"}, function(id:String, v:Dynamic) {
				return lumod.Util.getID(${instance}, id).$fieldName.x = v;
			});
			${instance}.lmAddCallback($v{"set" + fieldUpper + "Y"}, function(id:String, v:Dynamic) {
				return lumod.Util.getID(${instance}, id).$fieldName.y = v;
			});
		}
	}
}