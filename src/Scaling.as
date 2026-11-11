package src 
{
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class Scaling 
	{
		public static const HP_EXP:Number = 4;//The BASE scaling for everything
		public static const HP_REWARD_RATIO:Number = 2.5;//Multiplier to separate damge/health from cost/rewards scaling
		
		
		public static function hpScale(level:Number, levelAt37:Number):Number {
			level = progressiveLevelScaling(level);
			return yForXRounded(level / levelAt37 * 37, 2, 0, 2, 0, 0, HP_EXP);
		}
		
		public static function rewardScale(level:Number, levelAt37:Number):Number {
			level = progressiveLevelScaling(level);
			return yForXRounded(level / levelAt37 * 37, 2, 0, 2, 0, 0, HP_EXP) * HP_REWARD_RATIO;
		}
		
		public static function launchScale(level:Number, levelAt37:Number):Number {
			//return yForX(level / levelAt37 * 37,5,0.6,1.24,0.5,1.127,true);
			return yForX(level / levelAt37 * 37, 59, 10, 1.2, 5, 1.2, true);
		}
		
		public static function damageScale(level:Number, levelAt37:Number):Number {
			//Objects taking more and more time to kill happens HERE
			//return Scaling.hpScaleDiv(level, levelAt37, 4, 1, 1.1, 1, 0);//Too fast around the middle
			//return Scaling.hpScaleDiv(level, levelAt37, 4, 1.1, 0.77, 5, 0);//Too fast late
			return Scaling.hpScaleDiv(level, levelAt37, 4, 1.1, 0.7, 4, 1.20);
		}
		
		public static function costScale(level:Number, levelAt37:Number):Number {
			//Upgrades costing more and more vs reward happens HERE
			//return Scaling.rewardScaleMult(level, levelAt37, 2, 0, 1.1, 0.028, 0);//2-3
			//return Scaling.rewardScaleMult(level, levelAt37, 2, 0, 1.1, 0.051, 0);//2-4
			//return Scaling.rewardScaleMult(level, levelAt37, 3, 0, 0.95, 0.1, 0);//3-6
			//return Scaling.rewardScaleMult(level, levelAt37, 3, 0, 1.45, 0.051, 0);//3-6 (Fast around middle?
			return Scaling.rewardScaleMult(level, levelAt37, 2.5, 0, 1.42, 0.06, 0);//2.5 - 5.6 for faster early and steadier slowing pace
		}
		
		/**
		 * Used to scale the pacing of the game and make the exponential slightly higher as time goes, always on 37
		 */
		protected static function progressiveLevelScaling(level:Number):Number {
			//return level;
			//return yForX(level, 0, 1, 5, 0.033, 0, false);//Late
			return yForX(level, 0, 1, 1.3, 0.06, 0, false);//Mid
		}
		
		
		
		
		public static function hpScaleDiv(level:Number, levelAt37:Number, b:Number, l:Number, p:Number, pM:Number, e:Number):Number {
			var val:Number = hpScale(level, levelAt37);
			var adjustedLevel:Number = level / levelAt37 * 37;
			var divideBy:Number = yForX(adjustedLevel, b, l, p, pM, e);
			return val / divideBy;
		}
		
		public static function rewardScaleMult(level:Number, levelAt37:Number, b:Number, l:Number, p:Number, pM:Number, e:Number):Number {
			var val:Number = rewardScale(level, levelAt37);
			var adjustedLevel:Number = level / levelAt37 * 37;
			var mult:Number = yForX(adjustedLevel, b, l, p, pM, e, false);
			return val * mult;
		}
		
		
		
		/**
		 * Returns a scaled value for a given X
		 * @param	X The reference value, e.g. skill 'level'
		 * @param	base Flat amount to add to every value
		 * @param	linear Simple linear mult of lever (e.g. 2 for (X=5) -> 10, 3 for (X=5) -> 15)
		 * @param	power Power to apply on X
		 * @param	powerMult Mult to apply on X before applying power
		 * @param	expBase Base to apply power X to
		 */
		public static function yForX(X:Number, base:Number = 0, linear:Number = 1, power:Number = 0, powerMult:Number = 0, expBase:Number = 0, floor:Boolean = true):Number {
				var val:Number = X * linear;
				if (power != 0 && powerMult != 0) {
					val += Math.pow(X * powerMult, power);
				}
				if (expBase != 0) {
					val += Math.pow(expBase, X);
				}
				val += base;
				if (floor) {
					return Math.floor(val);
				}else {
					return val;
				}
		}
		
		/**
		 * Returns a scaled value for a given X, rounded to keep 'digitsToKeep' amount of digits before zeros
		 * @param	X The reference value, e.g. skill 'level'
		 * @param	digitsToKeep Digits to keep unrounded (e.g. 2 turns 1234->1200, 1 turns 1234->1000))
		 * @param	base Flat amount to add to every value
		 * @param	linear Simple linear mult of lever (e.g. 2 for (X=5) -> 10, 3 for (X=5) -> 15)
		 * @param	power Power to apply on X
		 * @param	powerMult Mult to apply on X before applying power
		 * @param	expBase Base to apply power X to
		 */
		public static function yForXRounded(X:Number, digitsToKeep:uint = 2, base:Number = 0, linear:Number = 1, power:Number = 0, powerMult:Number = 0, expBase:Number = 0):Number {
			var val:Number = yForX(X,base,linear,power,powerMult,expBase);
			var str:String = val.toFixed();
			var len:uint = str.length;
			var pow:uint = (len <= digitsToKeep) ? 0:len - digitsToKeep;
			var rounded:Number = NumberUtils.roundToNearest(Math.pow(10, pow), val);
			return rounded;
		}
		
		
	}

}