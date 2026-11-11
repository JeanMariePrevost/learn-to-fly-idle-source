package src 
{
	import flash.utils.getTimer;
	import lbg.anticheatengine.SafeNumber;
	import lbg.datatypes.BigUint;
	import lbg.debug.Log;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class Achievements 
	{
		private static const MINIMUM_GAME_TIME:uint = 7000;

		public static var _achievements:Array;
		
		public static var _bestObstacle:uint = 0;
		protected static var _killsSafe:SafeNumber = new SafeNumber();
		public static var _shotsFired:uint = 0;
		public static var _maxCash:BigUint = new BigUint("0");
		protected static var _playSecondsSafe:SafeNumber = new SafeNumber();
		public static var _damageLevel:uint = 0;
		public static var _launchLevel:uint = 0;
		public static var _shotLevel:uint = 0;
		public static var _autoLevel:uint = 0;
		public static var _spaceReached:Boolean = false;
		public static var _researchFull:Boolean = false;
		public static var _researchOver:Boolean = false;
		public static var _visitLink:Boolean = false;
		private static var _timeForGameCompleteSafe:SafeNumber = new SafeNumber();
		
		public static var achievementSignal:Signal = new Signal(uint);
		
		public static function checkAchievement(id:uint):Boolean {
			buildList();
			
			if (id > _achievements.length) {
				throw new Error("checkAchievement - id out of bounds");
				return false;
			}
			return _achievements[id];
		}
		
		protected static function buildList():void {
			if (_achievements == null) {
				_achievements = new Array();
				for (var i:int = 0; i < 40; i++) {
					_achievements.push(false);
				}
			}
		}
		
		
		//Achievements functions
		public static function setBestObstacleKilled(level:uint):void {
			if (level > _bestObstacle) {
				_bestObstacle = level;
			}
			if (_bestObstacle >= 38 && GameEngine.currentObstacleLevel >= 37) {
					if (_playSeconds <= _timeForGameComplete || _timeForGameComplete < MINIMUM_GAME_TIME) {
						_timeForGameComplete = _playSeconds;
						Log.log("Dodo Homeworld 666 destroyed.");
						Log.log("Clear Time", _timeForGameComplete);
						Log.log("Clear Time Safe", _timeForGameCompleteSafe.value);
					}
			}
			checkForNewAchievements();
		}
		
		public static function addObstacleKill():void {
			_kills += 1;
			var bu:BigUint = new BigUint();
			bu.setValueFromNumber(_kills);
			GameEngine.menu.txtStat4.text = bu.toFormattedString(5);
			checkForNewAchievements();
		}
		
		public static function addShotFired():void {
			_shotsFired += 1;
			checkForNewAchievements();
		}
		
		public static function setCashAmount(cash:String):void {
			if (_maxCash.isLessThan(cash))_maxCash.setValue(cash);
			checkForNewAchievements();
		}
		
		public static function addTimePlayed(seconds:uint):void {
			_playSeconds += seconds;
			var bu:BigUint = new BigUint();
			bu.setValueFromNumber(_playSeconds);
			GameEngine.menu.txtStat1.text = bu.toFormattedString(5);
			var lastSaveTime:Number = Math.floor((getTimer() - Main.autoSaveTime) / 1000);
			bu.setValueFromNumber(lastSaveTime);
			GameEngine.menu.txtStat2.text = bu.toFormattedString(5);
			checkForNewAchievements();
		}
		
		public static function setDamageLevel(level:uint):void {
			_damageLevel = level;
			checkForNewAchievements();
		}
		
		public static function setLaunchLevel(level:uint):void {
			_launchLevel = level;
			checkForNewAchievements();
		}
		
		public static function setShotLevel(level:uint):void {
			_shotLevel = level;
			checkForNewAchievements();
		}
		
		public static function setAutoLevel(level:uint):void {
			_autoLevel = level;
			checkForNewAchievements();
		}
		
		public static function setReachedSpace():void {
			_spaceReached = true;
			checkForNewAchievements();
		}
		
		public static function setEveryResearchAt10():void {
			_researchFull = true;
			checkForNewAchievements();
		}
		
		//public static function setHighestResearchLevel(level:uint):void {
			//_researchOver = true;
			//checkForNewAchievements();
		//}
		
		public static function setOverResearch():void {
			_researchOver = true;
			checkForNewAchievements();
		}
		
		public static function setSpecialLink():void {
			_visitLink = true;
			checkForNewAchievements();
		}
		
		//Actual achievement check mechanics here
		protected static function checkForNewAchievements():void {
			if (_bestObstacle > 1)	getAchievement(0);
			if (_bestObstacle > 6)	getAchievement(1);
			if (_bestObstacle > 11)	getAchievement(2);
			if (_bestObstacle > 14)	getAchievement(3);
			if (_bestObstacle > 19)	getAchievement(4);
			if (_bestObstacle > 26)	getAchievement(5);
			if (_bestObstacle > 32)	getAchievement(6);
			if (_bestObstacle > 37)	getAchievement(7);
			
			if (_kills >= 25) getAchievement(8);
			if (_kills >= 100) getAchievement(9);
			if (_kills >= 500) getAchievement(10);
			if (_kills >= 1000) getAchievement(11);
			if (_kills >= 2000) getAchievement(12);
			if (_kills >= 5000) getAchievement(13);
			if (_kills >= 10000) getAchievement(14);
			if (_kills >= 25000) getAchievement(15);
			
			if (_damageLevel >= 20) getAchievement(16);
			if (_damageLevel >= 200) getAchievement(17);
			if (_launchLevel >= 5) getAchievement(18);
			if (_launchLevel >= 30) getAchievement(19);
			if (_shotLevel >= 5) getAchievement(20);
			if (_shotLevel >= 20) getAchievement(21);
			if (_autoLevel >= 1) getAchievement(22);
			if (_autoLevel >= 20) getAchievement(23);
			
			if (_shotsFired >= 100) getAchievement(24);
			if (_shotsFired >= 2500) getAchievement(25);
			if (_shotsFired >= 25000) getAchievement(26);
			if (_shotsFired >= 100000) getAchievement(27);
			
			if (_maxCash.isGreaterThanEqualTo("1000")) getAchievement(28);
			if (_maxCash.isGreaterThanEqualTo("1000000")) getAchievement(29);
			if (_maxCash.isGreaterThanEqualTo("1000000000000")) getAchievement(30);
			if (_maxCash.isGreaterThanEqualTo("1000000000000000000")) getAchievement(31);
			
			if (_playSeconds >= 300) getAchievement(32);
			if (_playSeconds >= 1800) getAchievement(33);
			if (_playSeconds >= 7200) getAchievement(34);
			if (_playSeconds >= 28800) getAchievement(35);
			
			if (_spaceReached) getAchievement(36);
			if (_researchFull) getAchievement(37);
			if (_researchOver) getAchievement(38);
			if (_visitLink) getAchievement(39);
		}
		
		protected static function getAchievement(id:uint):void {
			buildList();
			if (_achievements[id]) return; //Already completed, do nothing
			
			_achievements[id] = true;
			
			if (id == 36) {
				//Space song!
				Audio.playBgm0();
			}
			
			Research.researchPoints.add(AchievementsTooltips.getTooltipReward(id));
			GameEngine.menu.rpUpdate();
			
			achievementSignal.dispatch(id);
			
			GameEngine.instanceOf.stage.addChild(new AchievementPopup(id));
			
		}
		
		static public function get _playSeconds():Number 
		{
			return _playSecondsSafe.value;
		}
		
		static public function set _playSeconds(value:Number):void 
		{
			_playSecondsSafe.value = value;
		}
		
		static public function get _kills():Number 
		{
			return _killsSafe.value;
		}
		
		static public function set _kills(value:Number):void 
		{
			_killsSafe.value = value;
		}
		
		static public function get _timeForGameComplete():Number 
		{
			return _timeForGameCompleteSafe.value;
		}
		
		static public function set _timeForGameComplete(value:Number):void 
		{
			_timeForGameCompleteSafe.value = value;
		}
		
		
		
		
	}

}