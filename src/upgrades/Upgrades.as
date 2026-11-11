package src.upgrades 
{
	import lbg.curveandsplines.Quad;
	import lbg.curveandsplines.QuadAnchor;
	import lbg.datatypes.BigUint;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Scaling;
	/**
	 * ...
	 * @author 
	 */
	public class Upgrades 
	{
		protected static var _launchPower:Vector.<UpgradeEntry>;
		protected static var _baseDamage:Vector.<UpgradeEntry>;
		protected static var _maxShots:Vector.<UpgradeEntry>;
		protected static var _autoFire:Vector.<UpgradeEntry>;
		
		
		public static function getLaunchPower(level:uint):UpgradeEntry {
			generateLists();
			if (level >= _launchPower.length) {
				//Beyond levels
				return new UpgradeEntry("0", "0");
			}
			return _launchPower[level];
		}
		
		public static function getBaseDamage(level:uint):UpgradeEntry {
			if (level >= _baseDamage.length) {
				//Beyond levels
				return new UpgradeEntry("0", "0");
			}
			generateLists();
			return _baseDamage[level];
		}
		
		public static function getMaxShots(level:uint):UpgradeEntry {
			if (level >= _maxShots.length) {
				//Beyond levels
				return new UpgradeEntry("0", "0");
			}
			generateLists();
			return _maxShots[level];
		}
		
		public static function getAutoFire(level:uint):UpgradeEntry {
			if (level >= _autoFire.length) {
				//Beyond levels
				return new UpgradeEntry("0", "0");
			}
			generateLists();
			return _autoFire[level];
		}
		
		protected static function generateLists():void {
			if (_launchPower != null) return;
			
			
			////////////////
			//Launch Power
			////////////////
			_launchPower = new Vector.<UpgradeEntry>();
			for (var i:Number = 0; i <= 1000; i++) {
				_launchPower.push(new UpgradeEntry(Scaling.launchScale(i,37).toFixed(), Scaling.costScale(i,37).toFixed()));
			}
			//tweaks
			
			
			
			////////////////
			//Base Damage
			////////////////
			_baseDamage = new Vector.<UpgradeEntry>();
			var damageLevelAtLastObstacle:Number = 270;
			for (i = 1; i <= 1000; i++) {
				_baseDamage.push(new UpgradeEntry(Scaling.damageScale(i, 270).toFixed(), (Scaling.costScale(i-1, 267) - 4).toFixed()));
			}
			//Tweaks
			_baseDamage[1].cost = "1";
			_baseDamage[2].cost = "2";
			_baseDamage[3].cost = "4";
			_baseDamage[4].cost = "7";
			_baseDamage[5].cost = "12";
			var tempDmg:Number = 0;
			for (i = 0; i <= 34; i++) {
				if (i <= 10) {
					tempDmg += 1;
				}else if (i <= 20) {
					tempDmg += 2;
				}else if (i <= 30) {
					tempDmg += 3;
				}else {
					tempDmg += 4;
				}
				_baseDamage[i].stat = (tempDmg).toFixed();
			}
			
			
			////////////////
			//Max Shots
			////////////////
			_maxShots = new Vector.<UpgradeEntry>();
			var maxShotLevelAtLastObstacle:Number = 40;
			for (i = 1; i <= 1000; i++) {
				_maxShots.push(new UpgradeEntry((i).toFixed(), Scaling.costScale(i - 1, 30).toFixed()));
			}
			//tweaks
			_maxShots[1].cost = "4";
			_maxShots[2].cost = "50";
			_maxShots[3].cost = "450";
			_maxShots[4].cost = "4000";
			
			
			////////////////
			//Auto Fire
			////////////////
			_autoFire = new Vector.<UpgradeEntry>();
			var autoFireLevelAtLastObstacle:Number = 25;
			_autoFire.push(new UpgradeEntry("0", "0"));
			for (i = 1; i <= 1000; i++) {
				_autoFire.push(new UpgradeEntry((i).toFixed(), Scaling.yForX((i / autoFireLevelAtLastObstacle) * 37, -2, 1, 2, 4, 2.88).toFixed()));
			}
			//tweaks
			_autoFire[1].cost = "20";
			_autoFire[2].cost = "80";
			_autoFire[3].cost = "250";
		}
	}

}