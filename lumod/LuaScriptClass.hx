package lumod;

import haxe.macro.Context;
import haxe.macro.Expr;

class LuaScriptClass {
	/**
	 * Builds some class and injects Lua script into it.
	 * 
	 * Use it with: `@:build(lumod.LuaScriptClass.build())`
	 * 
	 * @param scriptPath specifies the file name of the script. ex. `"script.lua"`. This path will be modified by `Lumod.scriptPathHandler`.
	 */
	public static macro function build(?scriptPath:String = null):Array<Field> {
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		
		var daFields = []; //fields to be returned

		var className = Context.getLocalClass().get().name;

		for (field in fields) {
			if (field.kind.getName() == "FFun" && !field.access.contains(AStatic)) { // check if the field is a function, also check if the field is not static
				if (field.name == "new") {
					var func:Function = field.kind.getParameters()[0];

					var callArgs:Array<Expr> = [for (arg in func.args) macro $i{arg.name}];

					// add lua calls to the function
					func.expr = macro {
						luaLoad();

						${func.expr}
					};

					field.kind = FFun(func);
				}
				else {
					var func:Function = field.kind.getParameters()[0];

					// grabbed from polymod
					var callArgs:Array<Expr> = [for (arg in func.args) macro $i{arg.name}];

					// add lua calls to the function
					func.expr = macro {
						var luaValue:Dynamic = luaCall($v{field.name}, $a{callArgs});

						${func.expr}

						luaCall($v{field.name} + "_post", $a{callArgs});
					};

					field.kind = FFun(func);
				}
			}
			daFields.push(field);
		}

		//backend functions or idk
		var luaCall:Field = {
			name: "luaCall",
			doc: "Calls a function declared in the Lua script.",
			access: [Access.APublic],
			kind: FieldType.FFun({
				ret: macro :Dynamic,
				args: [
					{
						name: "func",
						type: macro :String
					},
					{
						name: "args",
						type: macro :Array<Dynamic>,
						opt: true
					}
				],
				expr: macro {
					if (__lua == null) {
						return null;
					}

					// select lua field
					llua.Lua.getglobal(__lua, func);

					// catch errors (from psych engine)
					var fieldType:Int = llua.Lua.type(__lua, -1);
					if (fieldType != llua.Lua.LUA_TFUNCTION) {
						if (fieldType > llua.Lua.LUA_TNIL) {
							var valueType = "unknown";
							switch (fieldType) {
								case llua.Lua.LUA_TBOOLEAN: valueType = "boolean";
								case llua.Lua.LUA_TNUMBER: valueType = "number";
								case llua.Lua.LUA_TSTRING: valueType = "string";
								case llua.Lua.LUA_TTABLE: valueType = "table";
								case llua.Lua.LUA_TFUNCTION: valueType = "function";
								default:
									if (fieldType <= llua.Lua.LUA_TNIL)
										valueType = "nil";
							}
							Sys.println(__scriptPath + " (" + func + "): Attempt to call a " + valueType + " value");
						}

						llua.Lua.pop(__lua, 1);
						return null;
					}

					if (args == null) {
						args = [];
					}
					// append arguments (up to 5)
					for (arg in args) {
						llua.Convert.toLua(__lua, arg);
					}

					// try to call this function and return it's status
					var status:Int = llua.Lua.pcall(__lua, args.length, 1, 0);

					// catch some errors (also from psych engine)
					if (status != llua.Lua.LUA_OK) {
						var v = StringTools.trim(llua.Lua.tostring(__lua, -1) ?? "");
						if (v != "") {
							switch (status) {
								case llua.Lua.LUA_ERRRUN: Sys.println(__scriptPath + ": Runtime Error");
								case llua.Lua.LUA_ERRMEM: Sys.println(__scriptPath + ": Memory Allocation Error");
								case llua.Lua.LUA_ERRERR: Sys.println(__scriptPath + ": Critical Error");
								default: Sys.println(__scriptPath + ": Unknown Error");
							}
						}
						else {
							Sys.println(__scriptPath + ": Unknown Error");
						}
						llua.Lua.pop(__lua, 1);
						return null;
					}

					// finally get the returned value from the called function
					var result:Dynamic = cast llua.Convert.fromLua(__lua, -1);
					llua.Lua.pop(__lua, 1);
					return result;
				}
			}),
			pos: pos,
		};
		daFields.push(luaCall);

		var luaSet:Field = {
			name: "luaSet",
			doc: "Sets `variable` in the Lua" + #if LUMOD_HSCRIPT " and HScript Interpreter" + #end " script to `value`, and creates it if it doesn't exists.",
			access: [Access.APublic],
			kind: FieldType.FFun({
				ret: macro :Void,
				args: [
					{
						name: "variable",
						type: macro :String
					},
					{
						name: "value",
						type: macro :Dynamic
					}
				],
				expr: macro {
					if (__lua == null) {
						return;
					}

					llua.Convert.toLua(__lua, value);
					llua.Lua.setglobal(__lua, variable);

					#if LUMOD_HSCRIPT
					if (__hscriptInterp == null)
						__hscriptInterp.variables.set(variable, value);
					#end
				}
			}),
			pos: pos,
		};
		daFields.push(luaSet);

		#if LUMOD_HSCRIPT
		var hscriptSet:Field = {
			name: "hscriptSet",
			doc: "Sets `variable` in the HScript Interpreter to `value`, and creates it if it doesn't exists.",
			access: [Access.APublic],
			kind: FieldType.FFun({
				ret: macro :Void,
				args: [
					{
						name: "variable",
						type: macro :String
					},
					{
						name: "value",
						type: macro :Dynamic
					}
				],
				expr: macro {
					if (__hscriptInterp == null) {
						return;
					}

					__hscriptInterp.variables.set(variable, value);
				}
			}),
			pos: pos,
		};
		daFields.push(hscriptSet);
		#end

		var luaGet:Field = {
			name: "luaGet",
			doc: "Gets a global variable from the Lua script. `local` variables will return `null`.",
			access: [Access.APublic],
			kind: FieldType.FFun({
				ret: macro :Dynamic,
				args: [
					{
						name: "global",
						type: macro :String
					}
				],
				expr: macro {
					if (__lua == null) {
						return null;
					}

					llua.Lua.getglobal(__lua, global);

					var fieldType:Int = llua.Lua.type(__lua, -1);
					if (fieldType == llua.Lua.LUA_TFUNCTION || fieldType <= llua.Lua.LUA_TNIL) {
						Sys.println(__scriptPath + ': Property "' + global + '" is either null, local or a function');
						llua.Lua.pop(__lua, 1);
						return null;
					}

					var result:Dynamic = cast llua.Convert.fromLua(__lua, -1);
					llua.Lua.pop(__lua, 1);
					return result;
				}
			}),
			pos: pos,
		};
		daFields.push(luaGet);

		var luaAddCallback:Field = {
			name: "luaAddCallback",
			access: [Access.APublic],
			doc: "Declares a new function in the Lua script.",
			kind: FieldType.FFun({
				ret: macro :Void,
				args: [
					{
						name: "name",
						type: macro :String
					},
					{
						name: "func",
						type: macro :haxe.Constraints.Function
					}
				],
				expr: macro {
					if (__lua == null) {
						return;
					}

					llua.Lua.Lua_helper.add_callback(__lua, name, func);
				}
			}),
			pos: pos,
		};
		daFields.push(luaAddCallback);

		var luaLoad:Field = {
			name: "luaLoad",
			access: [Access.APublic],
			doc: "Loads or reloads the Lua script instance.",
			kind: FieldType.FFun({
				ret: macro :Void,
				args: [],
				expr: macro {
					if (__lua != null) {
						llua.Lua.close(__lua);
						__lua = null;
					}

					__scriptPath = lumod.Lumod.scriptPathHandler($v{className}, $v{scriptPath});
					
					if (lumod.Lumod.cache.existsScript(__scriptPath)) {
						// initialize lua
						var lua = llua.LuaL.newstate();

						// initialize some stuff like basic lua libraries
						llua.LuaL.openlibs(lua);
						llua.Lua.init_callbacks(lua);

						this.__lua = lua;

						//add callbacks so the script has some purpose
						luaAddCallback("close", function() {
							llua.Lua.close(__lua);
							__lua = null;
						});

						luaAddCallback("getProperty", function(name:String) {
							return lumod.Reflected.getProperty(this, name);
						});

						luaAddCallback("setProperty", function(name:String, value:Dynamic) {
							lumod.Reflected.setProperty(this, name, value);
						});

						luaAddCallback("callFunction", function(name:String, ?args:Array<Dynamic>) {
							if (args == null) args = [];
							return Reflect.callMethod(this, lumod.Reflected.getProperty(this, name), args);
						});

						luaAddCallback("hasField", function(name:String) {
							return lumod.Reflected.hasField(this, name);
						});

						luaAddCallback("isPropertyFunction", function(name:String) {
							return Reflect.isFunction(lumod.Reflected.getProperty(this, name));
						});

						luaAddCallback("isPropertyObject", function(name:String) {
							return Reflect.isObject(lumod.Reflected.getProperty(this, name));
						});

						#if LUMOD_HSCRIPT
						__hscriptParser = new hscript.Parser();
						__hscriptInterp = new hscript.Interp();

						__hscriptInterp.variables.set("this", this);
						__hscriptInterp.variables.set("Reflected", lumod.Reflected);

						luaAddCallback("haxeRun", function(expr:String) {
							try {
								var ast = __hscriptParser.parseString(expr);
								return __hscriptInterp.execute(ast);
							}
							catch (exc : hscript.Expr.Error) {
								Sys.println(exc);
							}
							return null;
						});

						luaAddCallback("haxeSetProperty", function(name:String, value:String) {
							if (__hscriptInterp != null)
								__hscriptInterp.variables.set(name, value);
						});

						luaAddCallback("haxeImport", function(cl:String, ?as:String) {
							var clSplit = cl.split(".");
							if (__hscriptInterp != null)
								__hscriptInterp.variables.set(as ?? clSplit[clSplit.length - 1], Type.resolveClass(cl));
						});
						#end

						// load the file and execute it
						llua.LuaL.dostring(lua, lumod.Lumod.cache.getScript(__scriptPath));
					}
					else {
						Sys.println(__scriptPath + ": Couldn't initialize LUA script for class \"" + $v{className} + "\" please create a new script in '" + lumod.Lumod.scriptsRootPath + __scriptPath + "'.");
					}
				}
			}),
			pos: pos,
		};
		daFields.push(luaLoad);

		var luaField:Field = {
			name: "__lua",
			access: [Access.APrivate],
			kind: FieldType.FVar(macro : llua.State),
			pos: pos,
		};
		daFields.push(luaField);

		var scriptPathField:Field = {
			name: "__scriptPath",
			access: [Access.APrivate],
			kind: FieldType.FVar(macro : String),
			pos: pos,
		};
		daFields.push(scriptPathField);

		#if LUMOD_HSCRIPT
		var luaField:Field = {
			name: "__hscriptParser",
			access: [Access.APrivate],
			kind: FieldType.FVar(macro : hscript.Parser),
			pos: pos,
		};
		daFields.push(luaField);

		var luaField:Field = {
			name: "__hscriptInterp",
			access: [Access.APrivate],
			kind: FieldType.FVar(macro : hscript.Interp),
			pos: pos,
		};
		daFields.push(luaField);
		#end

		return daFields;
	}
}