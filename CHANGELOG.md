# 2.0.0
* Changed the prefix of Lumod functions from `lua` to `lm`
* Added post constructor callback: `new`
* Added addons feature
    * Added callbacks for HaxeFlixel
* Overhauled `Lumod.scriptPathHandler` function to return absoulute script path instead of directory
* In favor of above change `scriptsRootPath` has been removed