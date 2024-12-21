package lumod.addons;

#if flixel
class FlixelAddon extends LumodAddon {
	override function init() {
		// this gonna apply to all flixel objects
		if (instance is flixel.FlxBasic) {
			addBasicCallbacks();
		}

		// a FlxTypedGroup can be either FlxGroup or FlxState
		if (instance is flixel.group.FlxGroup.FlxTypedGroup) {
			addGroupCallbacks();
		}
    }

	function addBasicCallbacks() {
		// object creation
		addCallback("createSprite", function(id:String, ?x:Float = 0, ?y:Float = 0, ?asset:String) {
			lumod.Util.setMap(instance, id, new flixel.FlxSprite(x, y, asset));
		});
		
		addCallback("createCamera", function(id:String, ?x:Float = 0, ?y:Float = 0, width:Int = 0, height:Int = 0, zoom:Float = 0) {
			lumod.Util.setMap(instance, id, new flixel.FlxCamera(x, y, width, height, zoom));
		});

		addCallback("createText", function(id:String, ?x:Float = 0, ?y:Float = 0, ?fieldWidth:Float = 0, ?text:String, ?size:Int = 0) {
			lumod.Util.setMap(instance, id, new flixel.text.FlxText(x, y, fieldWidth, text, size));
		});

		addCallback("deleteObject", function(id:String, ?destroy:Bool = true) {
			if (destroy)
				lumod.Util.getID(instance, id).destroy();
			instance.lmObjects.remove(id);
		});

		addCallback("listObjects", function() {
			var arr:Array<String> = [];
			for (key in cast(instance.lmObjects, Map<String, Dynamic>).keys()) {
				arr.push(key);
			}
			return arr;
		});

        // property access

        //FlxBasic (nearly all)
		addGetSetCallback(instance, 'ID');
        addGetSetCallback(instance, 'active');
        addGetSetCallback(instance, 'alive');
        addGetSetCallback(instance, 'camera', true);
        addArrayCallback(instance, 'cameras', true, 'camera');
        addGetSetCallback(instance, 'exists');
        addGetSetCallback(instance, 'visible');
		addCallback("destroyObject", function(id:String) {
			lumod.Util.getID(instance, id).destroy();
		});
		addCallback("killObject", function(id:String) {
			lumod.Util.getID(instance, id).kill();
		});
		addCallback("reviveObject", function(id:String) {
			lumod.Util.getID(instance, id).revive();
		});

        //FlxObject (essential ones (excluding physics stuff))
        addGetSetCallback(instance, 'x');
        addGetSetCallback(instance, 'y');
        addGetSetCallback(instance, 'width');
        addGetSetCallback(instance, 'height');
        addGetSetCallback(instance, 'angle');
		addFlxPointCallback(instance, 'scrollFactor');
		addCallback("setPosition", function(id:String, x:Dynamic, y:Dynamic) {
			lumod.Util.getID(instance, id).setPosition(x, y);
		});
		addCallback("setSize", function(id:String, width:Dynamic, height:Dynamic) {
			lumod.Util.getID(instance, id).setSize(width, height);
		});
		addCallback("getMidpointX", function(id:String) {
			return lumod.Util.getID(instance, id).getMidpoint().x;
		});
		addCallback("getMidpointY", function(id:String) {
			return lumod.Util.getID(instance, id).getMidpoint().y;
		});
		addCallback("isOnScreen", function(id:String, ?cam:Null<String>) {
			return lumod.Util.getID(instance, id).isOnScreen(lumod.Util.getID(instance, cam));
		});
		addCallback("overlapsObject", function(id:String, withId:String, ?inScreenSpace:Bool = false, ?cam:Null<String>) {
			return lumod.Util.getID(instance, id).overlaps(lumod.Util.getID(instance, withId), inScreenSpace, lumod.Util.getID(instance, cam));
		});
		addCallback("resetObject", function(id:String, x:Dynamic, y:Dynamic) {
			return lumod.Util.getID(instance, id).reset(x, y);
		});
		addCallback("screenCenter", function(id:String, ?axes:String) {
			return lumod.Util.getID(instance, id).screenCenter(flixel.util.FlxAxes.fromString(axes));
		});

        //FlxSprite (also essential ones)
        addGetSetCallback(instance, 'alpha');
        addGetSetCallback(instance, 'antialiasing');
        addGetSetCallback(instance, 'blend');
        addGetSetCallback(instance, 'flipX');
        addGetSetCallback(instance, 'flipY');
        addGetSetCallback(instance, 'frameHeight', false, true);
        addGetSetCallback(instance, 'frameWidth', false, true);
        addFlxPointCallback(instance, 'offset');
        addFlxPointCallback(instance, 'scale');
		addCallback("loadGraphic", function(id:String, asset:String, animated:Bool = false, frameWidth:Int = 0, frameHeight:Int = 0) {
			lumod.Util.getID(instance, id).loadGraphic(asset, animated, frameWidth, frameHeight);
		});
		addCallback("loadGraphicFromSprite", function(id:String, fromId:String) {
			lumod.Util.getID(instance, id).loadGraphicFromSprite(lumod.Util.getID(instance, fromId));
		});
		addCallback("makeGraphic", function(id:String, width:Int, height:Int, color:String) {
			lumod.Util.getID(instance, id).makeGraphic(width, height, flixel.util.FlxColor.fromString(color));
		});
		addCallback("setGraphicSize", function(id:String, width:Int, height:Int) {
			lumod.Util.getID(instance, id).setGraphicSize(width, height);
		});
		addCallback("updateHitbox", function(id:String) {
			lumod.Util.getID(instance, id).updateHitbox();
		});
		addCallback("getColor", function(id:String) {
			return lumod.Util.getID(instance, id).color;
		});
		addCallback("setColor", function(id:String, v:Dynamic) {
			return lumod.Util.getID(instance, id).color = flixel.util.FlxColor.fromString(v);
		});
		addCallback("setFramesFromSparrow", function(id:String, asset:Dynamic, xml:Dynamic) {
			return lumod.Util.getID(instance, id).frames = flixel.graphics.frames.FlxAtlasFrames.fromSparrow(asset, xml);
		});
		addCallback("setFramesFromPacker", function(id:String, asset:Dynamic, packer:Dynamic) {
			return lumod.Util.getID(instance, id).frames = flixel.graphics.frames.FlxAtlasFrames.fromSpriteSheetPacker(asset, packer);
		});
		addCallback("addAnimation", function(id:String, name:Dynamic, indices:Array<Int>, fps:Float = 24, looped:Bool = true) {
			return lumod.Util.getID(instance, id).animation.add(name, indices, fps, looped);
		});
		addCallback("playAnimation", function(id:String, name:Dynamic, force:Bool = false, reverse:Bool = false, frame:Int = 0) {
			return lumod.Util.getID(instance, id).animation.play(name, force, reverse, frame);
		});
		addCallback("existsAnimation", function(id:String, name:String) {
			return lumod.Util.getID(instance, id).animation.exists(name);
		});
		addCallback("finishAnimation", function(id:String) {
			return lumod.Util.getID(instance, id).animation.finish();
		});
		addCallback("pauseAnimation", function(id:String) {
			return lumod.Util.getID(instance, id).animation.pause();
		});
		addCallback("resetAnimation", function(id:String) {
			return lumod.Util.getID(instance, id).animation.reset();
		});
		addCallback("resumeAnimation", function(id:String) {
			return lumod.Util.getID(instance, id).animation.resume();
		});
		addCallback("reverseAnimation", function(id:String) {
			return lumod.Util.getID(instance, id).animation.reverse();
		});
		addCallback("stopAnimation", function(id:String) {
			return lumod.Util.getID(instance, id).animation.stop();
		});
		addCallback("updateClipRect", function(id:String) {
			final obj = lumod.Util.getID(instance, id);
			return obj.clipRect = obj.clipRect;
		});
		addCallback("setClipRectX", function(id:String, v:Dynamic) {
			return lumod.Util.getID(instance, id).clipRect.x = v;
		});
		addCallback("setClipRectY", function(id:String, v:Dynamic) {
			return lumod.Util.getID(instance, id).clipRect.y = v;
		});
		addCallback("setClipRectWidth", function(id:String, v:Dynamic) {
			return lumod.Util.getID(instance, id).clipRect.width = v;
		});
		addCallback("setClipRectHeight", function(id:String, v:Dynamic) {
			return lumod.Util.getID(instance, id).clipRect.height = v;
		});
		addCallback("setClipRect", function(id:String, x:Dynamic = 0, y:Dynamic = 0, width:Dynamic = 0, height:Dynamic = 0) {
			return lumod.Util.getID(instance, id).clipRect.set(x, y, width, height);
		});

        //FlxCamera
        addFlxPointCallback(instance, 'followLead');
        addGetSetCallback(instance,'followLerp');
        addFlxPointCallback(instance, 'scroll');
        addGetSetCallback(instance,'target', true);
        addGetSetCallback(instance,'zoom');
		addCallback("getCameraBGColor", function(id:String) {
			return lumod.Util.getID(instance, id).bgColor;
		});
		addCallback("setCameraBGColor", function(id:String, v:Dynamic) {
			return lumod.Util.getID(instance, id).bgColor = flixel.util.FlxColor.fromString(v);
		});
		addCallback("setCameraStyle", function(id:String, v:Dynamic) {
			switch ((v + '').toLowerCase()) {
				case '0', 'lockon':
					return lumod.Util.getID(instance, id).style = 0;
				case '1', 'platformer':
					return lumod.Util.getID(instance, id).style = 1;
				case '2', 'topdown':
					return lumod.Util.getID(instance, id).style = 2;
				case '3', 'topdown_tight':
					return lumod.Util.getID(instance, id).style = 3;
				case '4', 'screen_by_screen':
					return lumod.Util.getID(instance, id).style = 4;
				case '5', 'no_dead_zone':
					return lumod.Util.getID(instance, id).style = 5;
			}
			return null;
		});
		addCallback("cameraFollow", function(id:String, targetId:String, style:Dynamic, ?lerp:Float) {
			switch ((style + '').toLowerCase()) {
				case '0', 'lockon':
					lumod.Util.getID(instance, id).follow(lumod.Util.getID(instance, targetId), 0, lerp);
				case '1', 'platformer':
					lumod.Util.getID(instance, id).follow(lumod.Util.getID(instance, targetId), 1, lerp);
				case '2', 'topdown':
					lumod.Util.getID(instance, id).follow(lumod.Util.getID(instance, targetId), 2, lerp);
				case '3', 'topdown_tight':
					lumod.Util.getID(instance, id).follow(lumod.Util.getID(instance, targetId), 3, lerp);
				case '4', 'screen_by_screen':
					lumod.Util.getID(instance, id).follow(lumod.Util.getID(instance, targetId), 4, lerp);
				case '5', 'no_dead_zone':
					lumod.Util.getID(instance, id).follow(lumod.Util.getID(instance, targetId), 5, lerp);
			}
			return null;
		});
		addCallback("snapCameraToTarget", function(id:String) {
			lumod.Util.getID(instance, id).snapToTarget();
		});
		addCallback("setScrollBounds", function(id:String, minX:Float, maxX:Float, minY:Float, maxY:Float) {
			lumod.Util.getID(instance, id).setScrollBounds(minX, maxX, minY, maxY);
		});
		addCallback("shakeCamera", function(id:String, intensity:Float = 0.05, duration:Float = 0.5, force:Bool = true, ?axes:Dynamic) {
			lumod.Util.getID(instance, id).shake(intensity, duration, null, force, flixel.util.FlxAxes.fromString(axes));
		});
		addCallback("stopShakeCamera", function(id:String) {
			lumod.Util.getID(instance, id).stopShake();
		});
		addCallback("fadeCamera", function(id:String, color:Dynamic = 0xFF000000, duration:Dynamic = 1, fadeIn:Dynamic = false, force:Bool = false) {
			lumod.Util.getID(instance, id).fade(flixel.util.FlxColor.fromString(color + ''), duration, fadeIn, null, force);
		});
		addCallback("stopFadeCamera", function(id:String) {
			lumod.Util.getID(instance, id).stopFade();
		});

        //FlxText
        addGetSetCallback(instance, 'alignment');
        addGetSetCallback(instance, 'autoSize');
        addGetSetCallback(instance, 'bold');
        addGetSetCallback(instance, 'borderColor', false, true);
        addGetSetCallback(instance, 'borderQuality');
        addGetSetCallback(instance, 'borderSize');
        addGetSetCallback(instance, 'borderStyle', false, true);
        addGetSetCallback(instance, 'text');
        addGetSetCallback(instance, 'fieldHeight');
        addGetSetCallback(instance, 'fieldWidth');
        addGetSetCallback(instance, 'font');
        addGetSetCallback(instance, 'italic');
        addGetSetCallback(instance, 'letterSpacing');
        addFlxPointCallback(instance, 'shadowOffset');
        addGetSetCallback(instance, 'underline');
        addGetSetCallback(instance, 'wordWrap');
		addCallback("setFormat", function(id:String, font:Dynamic, size:Dynamic = 8, ?color:Dynamic = 0xFFFFFFFF, ?alignment:Dynamic) {
			lumod.Util.getID(instance, id).setFormat(font, size, color, alignment);
		});
		addCallback("setBorderStyle", function(id:String, style:Dynamic, ?color:Dynamic = 0xFFFFFFFF, ?size:Dynamic = 1, ?quality:Dynamic = 1) {
			switch ((style + '').toLowerCase()) {
				case '0', 'none':
					lumod.Util.getID(instance, id).setBorderStyle(0, color, size, quality);
				case '1', 'shadow':
					lumod.Util.getID(instance, id).setBorderStyle(1, color, size, quality);
				case '2', 'outline':
					lumod.Util.getID(instance, id).setBorderStyle(2, color, size, quality);
				case '3', 'outline_fast':
					lumod.Util.getID(instance, id).setBorderStyle(3, color, size, quality);
			}
		});
		addCallback("setBorderColor", function(id:String, ?color:Dynamic = 0x00000000) {
			lumod.Util.getID(instance, id).borderColor = color;
		});

        //FlxG
		addCallback("getAnimationTimeScale", function() {
			return flixel.FlxG.animationTimeScale;
		});
		addCallback("setAnimationTimeScale", function(v:Dynamic) {
			return flixel.FlxG.animationTimeScale = v;
		});
		addCallback("getDrawFramerate", function() {
			return flixel.FlxG.drawFramerate;
		});
		addCallback("setDrawFramerate", function(v:Dynamic) {
			return flixel.FlxG.drawFramerate = v;
		});
		addCallback("getGameWidth", function() {
			return flixel.FlxG.width;
		});
		addCallback("getGameHeight", function() {
			return flixel.FlxG.height;
		});
		addCallback("isMobile", function() {
			return flixel.FlxG.onMobile;
		});
		addCallback("consoleLog", function(v:Dynamic) {
			return flixel.FlxG.log.add(v);
		});
		addCallback("consoleWarn", function(v:Dynamic) {
			return flixel.FlxG.log.warn(v);
		});
		addCallback("consoleError", function(v:Dynamic) {
			return flixel.FlxG.log.error(v);
		});
		addCallback("consoleNotice", function(v:Dynamic) {
			return flixel.FlxG.log.notice(v);
		});
		addCallback("isKeyJustReleased", function(key:String) {
			return flixel.FlxG.keys.checkStatus(flixel.input.keyboard.FlxKey.fromString(key), -1);
		});
		addCallback("isKeyReleased", function(key:String) {
			return flixel.FlxG.keys.checkStatus(flixel.input.keyboard.FlxKey.fromString(key), 0);
		});
		addCallback("isKeyPressed", function(key:String) {
			return flixel.FlxG.keys.checkStatus(flixel.input.keyboard.FlxKey.fromString(key), 1);
		});
		addCallback("isKeyJustPressed", function(key:String) {
			return flixel.FlxG.keys.checkStatus(flixel.input.keyboard.FlxKey.fromString(key), 2);
		});
		addCallback("getMouseWheel", function() {
			return flixel.FlxG.mouse.wheel;
		});
		addCallback("getMouseWheel", function() {
			return flixel.FlxG.mouse.wheel;
		});
		addCallback("getMouseX", function() {
			return flixel.FlxG.mouse.x;
		});
		addCallback("getMouseY", function() {
			return flixel.FlxG.mouse.y;
		});
		addCallback("getMouseScreenX", function() {
			return flixel.FlxG.mouse.x;
		});
		addCallback("getMouseScreenY", function() {
			return flixel.FlxG.mouse.y;
		});
		addCallback("getMouseDeltaX", function() {
			return flixel.FlxG.mouse.deltaX;
		});
		addCallback("getMouseDeltaY", function() {
			return flixel.FlxG.mouse.deltaY;
		});
		addCallback("getMouseDeltaScreenX", function() {
			return flixel.FlxG.mouse.deltaScreenX;
		});
		addCallback("getMouseDeltaScreenY", function() {
			return flixel.FlxG.mouse.deltaScreenY;
		});
		addCallback("getMouseJustPressed", function() {
			return flixel.FlxG.mouse.y;
		});
		addCallback("isMouseVisible", function() {
			return flixel.FlxG.mouse.visible;
		});
		addCallback("setMouseVisibility", function(v:Bool) {
			return flixel.FlxG.mouse.visible = v;
		});
		addCallback("hasMouseJustMoved", function() {
			return flixel.FlxG.mouse.justMoved;
		});
		addCallback("isMousePressed", function() {
			return flixel.FlxG.mouse.pressed;
		});
		addCallback("isMouseJustPressed", function() {
			return flixel.FlxG.mouse.justPressed;
		});
		addCallback("isMouseReleased", function() {
			return flixel.FlxG.mouse.released;
		});
		addCallback("isMouseJustReleased", function() {
			return flixel.FlxG.mouse.justReleased;
		});
		#if FLX_MOUSE_ADVANCED
		addCallback("isMousePressedRight", function() {
			return flixel.FlxG.mouse.pressedRight;
		});
		addCallback("isMouseJustPressedRight", function() {
			return flixel.FlxG.mouse.justPressedRight;
		});
		addCallback("isMouseReleasedRight", function() {
			return flixel.FlxG.mouse.releasedRight;
		});
		addCallback("isMouseJustReleasedRight", function() {
			return flixel.FlxG.mouse.justReleasedRight;
		});
		addCallback("isMousePressedMiddle", function() {
			return flixel.FlxG.mouse.pressedMiddle;
		});
		addCallback("isMouseJustPressedMiddle", function() {
			return flixel.FlxG.mouse.justPressedMiddle;
		});
		addCallback("isMouseReleasedMiddle", function() {
			return flixel.FlxG.mouse.releasedMiddle;
		});
		addCallback("isMouseJustReleasedMiddle", function() {
			return flixel.FlxG.mouse.justReleasedMiddle;
		});
		#end
		#if FLX_GAMEPAD
		addCallback("getActiveGamepadIDs", function() {
			return flixel.FlxG.gamepads.getActiveGamepadIDs();
		});
		addCallback("getGamepadModel", function(?id:Int = 0) {
			switch (flixel.FlxG.gamepads.getByID(id).detectedModel) {
				case LOGITECH:
					return 'LOGITECH';
				case OUYA:
					return 'OUYA';
				case PS4:
					return 'PS4';
				case PSVITA:
					return 'PSVITA';
				case XINPUT:
					return 'XINPUT';
				case MAYFLASH_WII_REMOTE:
					return 'MAYFLASH_WII_REMOTE';
				case WII_REMOTE:
					return 'WII_REMOTE';
				case MFI:
					return 'MFI';
				case SWITCH_PRO:
					return 'SWITCH_PRO';
				case SWITCH_JOYCON_LEFT:
					return 'SWITCH_JOYCON_LEFT';
				case SWITCH_JOYCON_RIGHT:
					return 'SWITCH_JOYCON_RIGHT';
				case UNKNOWN:
					return 'UNKNOWN';
			}
			return null;
		});
		addCallback("isGamepadConnected", function(?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).connected;
		});
		addCallback("getGamepadAttachment", function(?id:Int = 0) {
			switch (flixel.FlxG.gamepads.getByID(id).attachment) {
				case WII_NUNCHUCK:
					return 'WII_NUNCHUCK';
				case WII_CLASSIC_CONTROLLER:
					return 'WII_CLASSIC_CONTROLLER';
				case NONE:
					return 'NONE';
			}
			return null;
		});
		addCallback("getGamepadDeadZone", function(?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).deadZone;
		});
		addCallback("setGamepadDeadZone", function(v:Float, ?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).deadZone = v;
		});
		addCallback("getGamepadDeadZoneMode", function(?id:Int = 0) {
			switch (flixel.FlxG.gamepads.getByID(id).deadZoneMode) {
				case INDEPENDENT_AXES:
					return 'INDEPENDENT_AXES';
				case CIRCULAR:
					return 'CIRCULAR';
			}
			return null;
		});
		addCallback("setGamepadDeadZoneMode", function(v:Dynamic, ?id:Int = 0) {
			switch (v) {
				case 'INDEPENDENT_AXES':
					return flixel.FlxG.gamepads.getByID(id).deadZoneMode = INDEPENDENT_AXES;
				case 'CIRCULAR':
					return flixel.FlxG.gamepads.getByID(id).deadZoneMode = CIRCULAR;
			}
			return null;
		});
		addCallback("isGamepadJustReleased", function(key:String, ?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).checkStatus(flixel.input.gamepad.FlxGamepadInputID.fromString(key), -1);
		});
		addCallback("isGamepadReleased", function(key:String, ?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).checkStatus(flixel.input.gamepad.FlxGamepadInputID.fromString(key), 0);
		});
		addCallback("isGamepadPressed", function(key:String, ?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).checkStatus(flixel.input.gamepad.FlxGamepadInputID.fromString(key), 1);
		});
		addCallback("isGamepadJustPressed", function(key:String, ?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).checkStatus(flixel.input.gamepad.FlxGamepadInputID.fromString(key), 2);
		});
		addCallback("getGamepadKeyAxis", function(key:String, ?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).getAxis(flixel.input.gamepad.FlxGamepadInputID.fromString(key));
		});
		addCallback("getGamepadKeyXAxis", function(key:String, ?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).getXAxis(flixel.input.gamepad.FlxGamepadInputID.fromString(key));
		});
		addCallback("getGamepadKeyYAxis", function(key:String, ?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).getYAxis(flixel.input.gamepad.FlxGamepadInputID.fromString(key));
		});
		addCallback("isGamepadMotionSupported", function(?id:Int = 0) {
			return flixel.FlxG.gamepads.getByID(id).motion.isSupported;
		});
		#end
		// todo add touches later

		#if FLX_SOUND_SYSTEM
		addCallback("isGlobalSoundMuted", function() {
			return flixel.FlxG.sound.muted;
		});
		addCallback("getGlobalSoundVolume", function() {
			return flixel.FlxG.sound.volume;
		});
		addCallback("cacheSound", function(asset:String) {
			flixel.FlxG.sound.cache(asset);
		});
		addCallback("playMusic", function(asset:String, ?volume:Float = 1, ?looped:Bool = true) {
			flixel.FlxG.sound.playMusic(asset, volume);
		});
		addCallback("createSound", function(id:String, asset:String, ?volume:Float = 1, ?looped:Bool = false, ?autoPlay:Bool = false) {
			lumod.Util.setMap(instance, id, flixel.FlxG.sound.load(asset, volume, looped, null, false, autoPlay));
		});
		addCallback("playSound", function(id:String, ?restart:Bool = false, ?startTime:Float = 0.0, ?endTime:Float) {
			lumod.Util.getID(instance, id).play(restart, startTime, endTime);
		});
		addCallback("isSoundPlaying", function(id:String) {
			return lumod.Util.getID(instance, id).playing;
		});
		addCallback("getSoundTime", function(id:String, ) {
			return lumod.Util.getID(instance, id).time;
		});
		addCallback("setSoundTime", function(id:String, v:Float) {
			return lumod.Util.getID(instance, id).time = v;
		});
		addCallback("getSoundVolume", function(id:String) {
			return lumod.Util.getID(instance, id).volume;
		});
		addCallback("setSoundVolume", function(id:String, v:Float) {
			return lumod.Util.getID(instance, id).volume = v;
		});
		addCallback("pauseSound", function(id:String) {
			return lumod.Util.getID(instance, id).pause();
		});
		addCallback("resumeSound", function(id:String) {
			return lumod.Util.getID(instance, id).resume();
		});
		addCallback("stopSound", function(id:String) {
			return lumod.Util.getID(instance, id).stop();
		});
		addCallback("setSoundProximity", function(id:String, x:Float, y:Float, targetObject:String, radius:Float) {
			return lumod.Util.getID(instance, id).proximity(x, y, lumod.Util.getID(instance, targetObject), radius);
		});
		addCallback("setSoundPosition", function(id:String, x:Float, y:Float) {
			return lumod.Util.getID(instance, id).setPosition(x, y);
		});
		addCallback("fadeInSound", function(id:String, ?duration:Float = 1, ?from:Float = 0, ?to:Float = 1) {
			return lumod.Util.getID(instance, id).fadeIn(duration, from, to);
		});
		addCallback("fadeOutSound", function(id:String, ?duration:Float = 1, ?to:Float = 0) {
			return lumod.Util.getID(instance, id).fadeOut(duration, to);
		});
		#end
    }

	function addGroupCallbacks() {
		addCallback("addObject", function(id:String) {
			instance.add(lumod.Util.getID(instance, id));
		});

		addCallback("insertObject", function(id:String, pos:Int) {
			instance.insert(pos, lumod.Util.getID(instance, id));
		});

		addCallback("removeObject", function(id:String, ?splice:Bool = false, ?delete:Bool = false) {
			instance.remove(lumod.Util.getID(instance, id), splice);
			if (delete)
				instance.lmObjects.remove(id);
		});
    }
}
#end