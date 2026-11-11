package src 
{
	import com.hurlant.util.Base64;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.registerClassAlias;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import lbg.datatypes.BigUint;
	import lbg.debug.Log;
	import lbg.savetofile.FileData;
	import lbg.savetofile.SaveToFile;
	import src.obstacles.ObstaclesList;
	import src.upgrades.Upgrades;
	/**
	 * ...
	 * @author 
	 */
	public class SaveGame extends Object 
	{
		protected static const SAVE_NAME_STRING:String = "save_game";
		protected static const SAVE_PATH:String = null;
		protected static var popup:MovieClip;
		
		
		public static function save():void {
			var so:SharedObject = SharedObject.getLocal(SAVE_NAME_STRING, SAVE_PATH);
			
			Main.autoSaveCounter = 0;
			Main.autoSaveTime = getTimer();
			
			_saveGame(so);
			if (popup != null) {
				popup.stop();
				if (popup.parent != null) {
					popup.parent.removeChild(popup);
				}
				popup = null;
			}
			popup = new GameSavedPopup();
			Main.topLayer.addChild(popup);
		}
		
		public static function saveToFile():void {
			SaveToFile.saveToFile(createSaveObject(), "LearnToFlyIdle.sav");
		}
		
		protected static function _saveGame(so:SharedObject):void {
			so.data.savegame = createSaveObject();
			
			so.flush();
		}
		
		public static function createSaveObject():Object {
			Log.log("createSaveObject()");
			var saveData:Object = new Object();
			//GameEngine
			saveData.cash = GameEngine.cash.toString();
			saveData.launch = GameEngine.launchPower.toString();
			saveData.launchLevel = GameEngine.launchPowerLevel;
			saveData.damage = GameEngine.damage.toString();
			saveData.damageLevel = GameEngine.damageLevel;
			saveData.maxShot = GameEngine.maxShots.toString();
			saveData.maxShotLevel = GameEngine.maxShotsLevel;
			saveData.autoFire = GameEngine.autoFireRate.toString();
			saveData.autoFireLevel = GameEngine.autoFireLevel;
			saveData.currentObstacleLevel = GameEngine.currentObstacleLevel;
			
			saveData.autoSaveInterval = Main.autoSaveInterval;
			
			//Achievements
			saveData.achievements = Achievements._achievements;
			saveData.achievements_bestObstacle = Achievements._bestObstacle;
			saveData.achievements_kills = Achievements._kills;
			saveData.achievements_shotsFired = Achievements._shotsFired;
			saveData.achievements_maxCash = Achievements._maxCash.toString();
			saveData.achievements_playSeconds = Achievements._playSeconds;
			saveData.achievements_damageLevel = Achievements._damageLevel;
			saveData.achievements_launchLevel = Achievements._launchLevel;
			saveData.achievements_shotLevel = Achievements._shotLevel;
			saveData.achievements_autoLevel = Achievements._autoLevel;
			saveData.achievements_spaceReached = Achievements._spaceReached;
			saveData.achievements_researchFull = Achievements._researchFull;
			saveData.achievements_researchOver = Achievements._researchOver;
			saveData.achievements_visitLink = Achievements._visitLink;
			saveData.achievements_timeForGameComplete = Achievements._timeForGameComplete;
			
			//Research
			saveData.researchPoints = Research.researchPoints.toString();
			saveData.research_damageLevel = Research.damageLevel;
			saveData.research_speedDamageLevel = Research.speedDamageLevel;
			saveData.research_dragReductionLevel = Research.dragReductionLevel;
			saveData.research_cheaperUpgradesLevel = Research.cheaperUpgradesLevel;
			saveData.research_moreRPLevel = Research.moreRPLevel;
			
			//Obstacles kills
			for (var i:int = 0; i <= 37; i++) {
				saveData["obstacle_kills_" + i] = ObstaclesList.getObstacle(i).getKills();
			}

			
			//Audio pref
			saveData.audio_volume = Audio.volume;
			saveData.audio_track = Audio.track;
			
			return saveData;
		}
		
		/**
		 * Used to reset game and start over without quitting game
		 */
		public static function createEmptySaveObject():Object {
			Log.log("createEmptySaveObject()");
			var saveData:Object = new Object();
			
			//GameEngine
			saveData.cash = "0";
			saveData.launch = Upgrades.getLaunchPower(0).stat;
			saveData.launchLevel = "0";
			saveData.damage = Upgrades.getBaseDamage(0).stat;
			saveData.damageLevel = "0";
			saveData.maxShot = Upgrades.getMaxShots(0).stat;
			saveData.maxShotLevel = "0";
			saveData.autoFire = Upgrades.getAutoFire(0).stat;
			saveData.autoFireLevel = "0";
			saveData.currentObstacleLevel = "0";
			
			saveData.autoSaveInterval = 60;
			
			//Achievements
			saveData.achievements = null;;
			saveData.achievements_bestObstacle = 0;
			saveData.achievements_kills = 0;
			saveData.achievements_shotsFired = 0;
			saveData.achievements_maxCash = "0";
			saveData.achievements_playSeconds = 0;
			saveData.achievements_damageLevel = 0;
			saveData.achievements_launchLevel = 0;
			saveData.achievements_shotLevel = 0;
			saveData.achievements_autoLevel = 0;
			saveData.achievements_spaceReached = false;
			saveData.achievements_researchFull = false;
			saveData.achievements_researchOver = false;
			saveData.achievements_visitLink = false;
			saveData.achievements_timeForGameComplete = uint.MAX_VALUE;
			
			//Research
			saveData.researchPoints = "0";
			saveData.research_damageLevel = 0;
			saveData.research_speedDamageLevel = 0;
			saveData.research_dragReductionLevel = 0;
			saveData.research_cheaperUpgradesLevel = 0;
			saveData.research_moreRPLevel = 0;
			
			//Obstacles kills
			for (var i:int = 0; i <= 37; i++) {
				saveData["obstacle_kills_" + i] = "0";
			}
			
			//Audio pref
			saveData.audio_volume = 1;
			saveData.audio_track = 1;
			
			return saveData;
		}
		
		public static function load():void {
			var so:SharedObject;
			so = SharedObject.getLocal(SAVE_NAME_STRING, SAVE_PATH);
			trace(so.data);
			
			loadGameFromObject(so.data.savegame);
		}
		
		public static function get saveFileExists():Boolean {
			var so:SharedObject;
			so = SharedObject.getLocal(SAVE_NAME_STRING, SAVE_PATH);
			
			return (so.data.savegame != null);
		}
		
		public static function loadFromFile():void {
			SaveToFile.loadFromFile("").addOnce(fileLoaded);
		}
		
		protected static function fileLoaded(data:FileData):void {
			Log.log("Hash:", data.hash1, data.hash2);
			
			if (data.hash1 && data.hash2) {
				//Hash passed
				Log.log("File loaded and hash passed.");
				new OverwriteScreen(Main.topLayer, 1, data.data);
			}else {
				//Hash failed
				Log.log("File loaded but hash failed: ", data.hash1, data.hash2);
				new OverwriteScreen(Main.topLayer, 4, null);
			}
		}
		
		public static function loadGameFromObject(saveData:Object):void {
			Log.log("loadGameFromObject()");
			//trace(saveData.hasOwnProperty("launch"));
			//trace(saveData.hasOwnProperty("damageLevel"));
			//trace(saveData.hasOwnProperty("achievements"));
			//trace(saveData.hasOwnProperty("achievements_kills"));
			//trace(saveData.hasOwnProperty("researchPoints"));
			//trace(saveData.hasOwnProperty("research_speedDamageLevel"));
			//trace(saveData.hasOwnProperty("audio_volume"));
			//trace(saveData.hasOwnProperty("currentObstacleLevel"));
			//trace(saveData.hasOwnProperty("launch"));
			//trace(saveData.hasOwnProperty("launch"));
			//trace(saveData.hasOwnProperty("launch"));
			if (saveData == null || !(saveData.hasOwnProperty("launch") ||
			saveData.hasOwnProperty("damageLevel") ||
			saveData.hasOwnProperty("achievements") ||
			saveData.hasOwnProperty("achievements_kills") ||
			saveData.hasOwnProperty("researchPoints") ||
			saveData.hasOwnProperty("research_speedDamageLevel") ||
			saveData.hasOwnProperty("audio_volume") ||
			saveData.hasOwnProperty("currentObstacleLevel"))) {
					//throw new Error("loadGameFromObject - Object is of invalid format");
					Log.log("ERROR: loadGameFromObject - Object is of invalid format");
					return;
			}
			
			Log.log("Loading game engine...");
			//GameEngine
			GameEngine.cash.setValue("0");//Cash is added at the end
			GameEngine.launchPower.setValue(saveData.launch);
			GameEngine.launchPowerLevel = saveData.launchLevel;
			GameEngine.damage.setValue(saveData.damage);
			GameEngine.damageLevel = saveData.damageLevel;
			GameEngine.maxShots.setValue(saveData.maxShot);
			GameEngine.maxShotsLevel = saveData.maxShotLevel;
			GameEngine.autoFireRate.setValue(saveData.autoFire);
			GameEngine.autoFireLevel = saveData.autoFireLevel;
			//GameEngine.setObstacle(saveData.currentObstacleLevel);
			
			Log.log("Loading preferences...");
			Main.autoSaveInterval = saveData.autoSaveInterval;
			if (Main.autoSaveInterval <= 29 || isNaN(Main.autoSaveInterval)) Main.autoSaveInterval = 60;
			
			Log.log("Loading achievements...");
			//Achievements
			Achievements._achievements = saveData.achievements;
			Achievements._bestObstacle = saveData.achievements_bestObstacle;
			Achievements._kills = saveData.achievements_kills;
			Achievements._shotsFired = saveData.achievements_shotsFired;
			Achievements._maxCash.setValue(saveData.achievements_maxCash);
			Achievements._playSeconds = saveData.achievements_playSeconds;
			Achievements._damageLevel = saveData.achievements_damageLevel;
			Achievements._launchLevel = saveData.achievements_launchLevel;
			Achievements._shotLevel = saveData.achievements_shotLevel;
			Achievements._autoLevel = saveData.achievements_autoLevel;
			Achievements._spaceReached = saveData.achievements_spaceReached;
			Achievements._researchFull = saveData.achievements_researchFull;
			Achievements._researchOver = saveData.achievements_researchOver;
			Achievements._visitLink = saveData.achievements_visitLink;
			Achievements._timeForGameComplete = saveData.achievements_timeForGameComplete;
			
			Log.log("Loading research...");
			//Research
			Research.researchPoints.setValue(saveData.researchPoints);
			Research.damageLevel = saveData.research_damageLevel;
			Research.speedDamageLevel = saveData.research_speedDamageLevel;
			Research.dragReductionLevel = saveData.research_dragReductionLevel;
			Research.cheaperUpgradesLevel = saveData.research_cheaperUpgradesLevel;
			Research.moreRPLevel = saveData.research_moreRPLevel;
			
			Log.log("Loading stats...");
			//Obstacles kills
			try{
				for (var i:int = 0; i <= 37; i++) {
					//Log.log("Loading obstacle", i, ">>", saveData["obstacle_kills_" + i]);
					if (saveData["obstacle_kills_" + i] == null || saveData["obstacle_kills_" + i] == "") {
						Log.log("Could not load obstacle", i);
						saveData["obstacle_kills_" + i] = 0;
					}
					ObstaclesList.getObstacle(i).setKills(saveData["obstacle_kills_" + i]);
				}
			}catch (err:Error) {
				Log.log("Error loading Obstacles stats on index :", i)
				Log.log(err.errorID);
				Log.log(err.name);
				Log.log(err.message);
			}
			
			Log.log("Loading audio...");
			//Audio
			Audio.setVolume(saveData.audio_volume);
			Audio.playTrackFromNumer(saveData.audio_track);
			
			Log.log("Setting up game...");
			GameEngine.setObstacle(saveData.currentObstacleLevel);
			GameEngine.menu.updateStats();
			GameEngine.menu.updateCashStats();
			GameEngine.addCash(saveData.cash);
			
			Log.log("Save debug - Cash =", saveData.cash);
			Log.log("Save debug - Damage =", saveData.damage);
			Log.log("Save debug - Damage lvl =", saveData.damageLevel + 1);
			Log.log("Save debug - Launch =", saveData.launch);
			Log.log("Save debug - Launch lvl =", saveData.launchLevel + 1);
			Log.log("Save debug - Current Obstacle =", saveData.currentObstacleLevel + 1);
			Log.log("Save debug - Kills =", saveData.achievements_kills);

			
			if (Main.optionScreen != null) Main.optionScreen.hide();
			
			Log.log("Load complete.");
		}
		
	}

}
