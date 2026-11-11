package src 
{
	import lbg.datatypes.BigUint;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class Research 
	{
		public static const MAX_LEVEL:uint = 100;
		public static const RP_BASE_GAIN:Number = 0.01;//0.017
		
		public static var researchPoints:BigUint = new BigUint("0");
		public static var researchPointCounter:Number = 0;
		
		public static var damageLevel:uint = 0;
		public static var speedDamageLevel:uint = 0;
		public static var dragReductionLevel:uint = 0;
		public static var cheaperUpgradesLevel:uint = 0;
		public static var moreRPLevel:uint = 0;
		
		public static var rpUpdateSignal:Signal = new Signal(String);
		
		public static function getDamage(offset:int = 0):Number {
			var lvl:int = damageLevel + offset;
			if (lvl <= 10) {
				return (lvl + 1) * 0.1 + 0.9;
			}else {
				return Easing.easeOutQuad(lvl - 10, 1, 2, 90) + 1;
			}
		}
		
		public static function getSpeedDamage(offset:int = 0):Number {
			var lvl:int = speedDamageLevel + offset;
			if (lvl <= 10) {
				return NumberUtils.interpolate2(1, 4, 0, 10, lvl, 1, true);
			}else {
				return Easing.easeOutQuad(lvl - 10, 4, 4, 90);
			}
		}
		
		public static function getDragReduction(offset:int = 0):Number {
			var lvl:int = dragReductionLevel + offset;
			if (lvl <= 10) {
				return 1 - NumberUtils.interpolate2(0, 0.25, 0, 10, lvl, 1, true);
			}else {
				return 1 -Easing.easeOutQuad(lvl - 10, 0.25, 0.25, 90);
			}
		}
		
		public static function getCheaperUpgrades(offset:int = 0):Number {
			var lvl:int = cheaperUpgradesLevel + offset;
			if (lvl <= 10) {
				return 1 - NumberUtils.interpolate2(0, 0.25, 0, 10, lvl, 1, true);
			}else {
				return 1 -Easing.easeOutQuad(lvl - 10, 0.25, 0.50, 90);
			}
		}
		
		public static function getMoreRP(offset:int = 0):Number {
			var lvl:int = moreRPLevel + offset;
			if (lvl <= 10) {
				return NumberUtils.interpolate2(1, 5, 0, 10, lvl, 1, true);
			}else {
				return Easing.easeOutQuad(lvl - 10, 5, 15, 90);
			}
		}
		
		
		public static function getDamageCost(offset:int = 0):uint {
			var level:uint = NumberUtils.constrain(damageLevel + offset, 0, MAX_LEVEL);
			return getResearchCost(level);
		}
		
		public static function getSpeedDamageCost(offset:int = 0):Number {
			var level:uint = NumberUtils.constrain(speedDamageLevel + offset, 0, MAX_LEVEL);
			return getResearchCost(level);
		}
		
		public static function getDragReductionCost(offset:int = 0):Number {
			var level:uint = NumberUtils.constrain(dragReductionLevel + offset, 0, MAX_LEVEL);
			return getResearchCost(level);
		}
		
		public static function getCheaperUpgradesCost(offset:int = 0):Number {
			var level:uint = NumberUtils.constrain(cheaperUpgradesLevel + offset, 0, MAX_LEVEL);
			return getResearchCost(level);
		}
		
		public static function getMoreRPCost(offset:int = 0):Number {
			var level:uint = NumberUtils.constrain(moreRPLevel + offset, 0, MAX_LEVEL);
			return getResearchCost(level);
		}
		
		protected static function getResearchCost(level:uint):uint {
			switch(level) {
				case 0:
					return 0;
				case 1:
					return 100;
				case 2:
					return 200;
				case 3:
					return 400;
				case 4:
					return 600;
				case 5:
					return 800;
				case 6:
					return 1000;
				case 7:
					return 1250;
				case 8:
					return 1500;
				case 9:
					return 2000;
				case 10:
					return 2500;
				default:
					return 2500;
			}
		}
		
		public static function tick(delta:Number):void {
			researchPointCounter += RP_BASE_GAIN * delta * getMoreRP();
			GameEngine.menu.txtStat3.text = String(NumberUtils.setPrecison((RP_BASE_GAIN * getMoreRP()) * 30, 2));
			
			
			if (researchPointCounter >= 1) {
				var over:uint = Math.floor(researchPointCounter);
				researchPointCounter -= over;
				researchPoints.add(over.toFixed());
				rpUpdateSignal.dispatch(researchPoints.toFormattedString(6,1));
			}
			
		}
		
		public static function get maxResearchLevel():Number {
			return 10;
		}
		
		public static function buyDamage():void {
			if (damageLevel >= maxResearchLevel) return;
			var cost:Number = getDamageCost(1);
			if (researchPoints.isGreaterThanEqualTo(cost.toFixed())) {
				researchPoints.substract(cost.toFixed());
				damageLevel = NumberUtils.constrain(damageLevel + 1, 0, 100);
				GameEngine.menu.updateStats();
			}
		}
		
		public static function buySpeedDamage():void {
			if (speedDamageLevel >= maxResearchLevel) return;
			var cost:Number = getSpeedDamageCost(1);
			if (researchPoints.isGreaterThanEqualTo(cost.toFixed())) {
				researchPoints.substract(cost.toFixed());
				speedDamageLevel = NumberUtils.constrain(speedDamageLevel + 1, 0, 100);
			}
		}
		
		public static function buyDragReduction():void {
			if (dragReductionLevel >= maxResearchLevel) return;
			var cost:Number = getDragReductionCost(1);
			if (researchPoints.isGreaterThanEqualTo(cost.toFixed())) {
				researchPoints.substract(cost.toFixed());
				dragReductionLevel = NumberUtils.constrain(dragReductionLevel + 1, 0, 100);
				GameEngine.setObstacle(GameEngine.currentObstacleLevel);
			}
		}
		
		public static function buyCheaperUpgrades():void {
			if (cheaperUpgradesLevel >= maxResearchLevel) return;
			var cost:Number = getCheaperUpgradesCost(1);
			if (researchPoints.isGreaterThanEqualTo(cost.toFixed())) {
				researchPoints.substract(cost.toFixed());
				cheaperUpgradesLevel = NumberUtils.constrain(cheaperUpgradesLevel + 1, 0, 100);
			}
		}
		
		public static function buyMoreRP():void {
			if (moreRPLevel >= maxResearchLevel) return;
			var cost:Number = getMoreRPCost(1);
			if (researchPoints.isGreaterThanEqualTo(cost.toFixed())) {
				researchPoints.substract(cost.toFixed());
				moreRPLevel = NumberUtils.constrain(moreRPLevel + 1, 0, 100);
			}
		}
		
		public static function isAnythingBuyable():Boolean {
			if (Research.researchPoints.isGreaterThanEqualTo(Research.getDamageCost(1).toFixed()) ||
			(Research.researchPoints.isGreaterThanEqualTo(Research.getSpeedDamageCost(1).toFixed())) ||
			(Research.researchPoints.isGreaterThanEqualTo(Research.getDragReductionCost(1).toFixed())) ||
			(Research.researchPoints.isGreaterThanEqualTo(Research.getCheaperUpgradesCost(1).toFixed())) ||
			(Research.researchPoints.isGreaterThanEqualTo(Research.getMoreRPCost(1).toFixed()))) {
				return true;
			}else {
				return false;
				return false;
			}
		}
		
		
		//These 2 are used for stats only
		public static function getHighestLevel():uint {
			var highestLevel:uint = Math.max(damageLevel, speedDamageLevel, dragReductionLevel, cheaperUpgradesLevel, moreRPLevel);
			return highestLevel;
		}
		
		public static function getTotalLevels():uint {
			var totalLevels:uint = damageLevel + speedDamageLevel + dragReductionLevel + cheaperUpgradesLevel + moreRPLevel;
			return totalLevels;
		}
		
		
	}

}