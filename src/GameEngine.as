package src 
{
	import com.hurlant.math.BigInteger;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import lbg.datatypes.BigUint;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.bullet.AbstractBullet;
	import src.bullet.Sandbag;
	import src.obstacles.ObstacleListEntry;
	import src.obstacles.ObstaclesList;
	import src.upgrades.Upgrades;
	/**
	 * ...
	 * @author 
	 */
	public class GameEngine extends Sprite
	{
		public static const FIRST_SPACE_LEVEL:uint = 27;
		public static const SPACE_POWER_MULT:Number = 0.27;
		public static const SPACE_SPEED_MULT:Number = 0.6;
		public static const AUTOFIRE_ADJUST:Number = 0.005;
		public static const CASH_PER_SECOND_TIME:uint = 20;//Seconds to average cps across
		
		public static var cash:Cash = new Cash();
		
		public static var gravity:Number = 0.08;
		protected static var _drag:Number = 0.01;
		public static var launchPower:BigUint = new BigUint(Upgrades.getLaunchPower(0).stat);
		public static var damage:BigUint = new BigUint(Upgrades.getBaseDamage(0).stat);
		public static var maxShots:BigUint = new BigUint(Upgrades.getMaxShots(0).stat);
		public static var autoFireRate:BigUint = new BigUint(Upgrades.getAutoFire(0).stat);
		
		public static var launchPowerLevel:uint = 0;
		public static var damageLevel:uint = 0;
		public static var maxShotsLevel:uint = 0;
		public static var autoFireLevel:uint = 0;
		
		public static var sky:MovieClip;
		public static var ground:MovieClip;
		public static var world:World;
		//public static var launcher:AbstractLauncher = new Spring();
		public static var launcher:TiltCannon = new TiltCannon();
		public static var menu:Menu = new Menu();
		
		public static var autoFireEnabled:Boolean = true;
		protected var _autoFireCounter:Number = 0;
		public static const MAX_AUTO_SHOT_QUEUED:uint = 3;
		
		public static var manualFireCounter:Number = 0;
		public static const MAX_SHOT_QUEUED:uint = 1;
		
		public static var currentObstacleLevel:uint = 0;
		
		public static var cashGainArray:Array = new Array();
		
		public static var instanceOf:GameEngine;
		
		
		public function GameEngine(conatiner:DisplayObjectContainer) 
		{
			instanceOf = this;
			conatiner.addChild(this);
			
			switchToLandWorld(0);
			//setupWorldOnLand();
			//setupWorldInSpace();
			//commonSetup();
			
			Main.phase1.add(tick);
			
			//Debug
			//addCash("1000000000000000");
			//addCash("9999999999999999");
			//addCash("100000000000000000000000000000000");
			//Achievements.setBestObstacleKilled(37);
			//setObstacle(0);
		}
		
		public function switchToSpaceWorld(obstacleLevel:uint):void 
		{
			if(world !=null){
				world.disposeWorld();
				world = null;
				removeChild(sky);
				sky = null;
			}
			setupWorldInSpace();
			commonSetup(obstacleLevel);
			
			Achievements.setReachedSpace();
		}
		
		public function switchToLandWorld(obstacleLevel:uint):void 
		{
			if(world !=null){
				world.disposeWorld();
				world = null;
				removeChild(sky);
				sky = null;
			}
			setupWorldOnLand();
			commonSetup(obstacleLevel);
		}
		
		public function setupWorldOnLand():void {
			sky = new Sky();
			addChild(sky);
			
			sky.addChild(new Cloud());
			
			world = new World(this);
			
			ground = new Ground();
			ground.y = 310;
			world.addChild(ground);
			
			world.addChild(launcher);
			launcher.x = 50;
			launcher.y = 250;
			launcher.scaleX = launcher.scaleY = 1;
		}
		
		public function setupWorldInSpace():void {
			sky = new World_SpaceSky();
			addChild(sky);
			
			world = new World(this);
			
			ground = new World_Earth();
			ground.y = 210;
			ground.x = 110;
			world.addChild(ground);
			
			world.addChild(launcher);
			launcher.x = 290;
			launcher.y = 100;
			launcher.scaleX = launcher.scaleY = 0.3;
		}
		
		public function commonSetup(obstacleLevel:uint):void {
			setObstacle(obstacleLevel);
			
			addChild(menu);
			
			menu.updateCash(cash.toFormattedString());
			menu.updateCost("");
			
			menu.updateStats();
		}
		
		public var time:Number = 0;
		protected function tick(delta:Number):void {
			if (autoFireEnabled) {
				_autoFireCounter += autoFireRate.toNumber() * AUTOFIRE_ADJUST * delta;
				_autoFireCounter = Math.min(_autoFireCounter, MAX_AUTO_SHOT_QUEUED);
				while (_autoFireCounter >= 1) {
					time = getTimer();
					launcher.shoot();
					_autoFireCounter -= 1;
				}
			}
			while (manualFireCounter >= 1) {
				manualFireCounter -= 1;
				launcher.shoot();
			}
			
			
			var cps:BigUint = new BigUint("0");
			cps.setValueFromNumber(Math.round(CashPerSecond.getCashPerSecond()));
			menu.txtCashPerSecond.text = "$ " + cps.toFormattedString(12,3) + " /sec"
			
			Research.tick(delta);
		}
		
		public static function shootBullet(X, Y, angle):Boolean {
			if (world.bullets.length >= maxShots.toNumber()) return false;
			var bullet:AbstractBullet = new Sandbag(X, Y);
			bullet.damage = damage.toString();
			world.addBullet(bullet);
			
			angle += Math.random() * 3 - 1.5;
			if (currentlyInSpace) {
				bullet.vx = Trig.vectorX(launchPower.toNumber() * SPACE_POWER_MULT, angle) / 10;
				bullet.vy = Trig.vectorY(launchPower.toNumber() * SPACE_POWER_MULT, angle) / 10;
			}else {
				bullet.vx = Trig.vectorX(launchPower.toNumber(), angle) / 10;
				bullet.vy = Trig.vectorY(launchPower.toNumber(), angle) / 10;
			}
			
			Achievements.addShotFired();
			return true;
		}
		
		public static function addCash(value:String):void {
			cash.add(value);
			Achievements.setCashAmount(cash.toString());
			menu.updateCash(cash.toFormattedString());
			
			//Add added value to CPS array
			cashGainArray.push([value, getTimer()]);
			//CashPerSecond.addEntry(Number(value));
		}
		
		public static function substractCash(value:String):void {
			cash.substract(value);
			menu.updateCash(cash.toFormattedString());
		}
		
		public static function setObstacle(level:uint):void {
			Log.log("Loading obstacle level:", level)
			if (currentObstacleLevel < FIRST_SPACE_LEVEL && level >= FIRST_SPACE_LEVEL) {
				currentObstacleLevel = level;
				instanceOf.switchToSpaceWorld(level);
			}else if (currentObstacleLevel >= FIRST_SPACE_LEVEL && level < FIRST_SPACE_LEVEL) {
				currentObstacleLevel = level;
				instanceOf.switchToLandWorld(level);
			}
			var entry:ObstacleListEntry = ObstaclesList.getObstacle(level);
			//HERE - this needed?
			//if (level == currentObstacleLevel) {
				//if (world != null) {
					//if (world.currentObstacle != null) {
						//entry.hp = world.currentObstacle.hp;
					//}
				//}
			//}
			if (currentObstacleLevel != level) {
				DamagePerSecond.resetDPS();
				CashPerSecond.clearEntries();
			}
			currentObstacleLevel = level;
			world.setObstacle(entry, currentObstacleLevel);
			menu.updateObstacle(entry);
		}
		
		static public function get drag():Number 
		{
			return _drag;
		}
		
		public static function get currentlyInSpace():Boolean {
			return (currentObstacleLevel >= FIRST_SPACE_LEVEL);
		}
		
	}

}