package src 
{
	import flash.utils.getTimer;
	import lbg.datatypes.BigUint;
	import lbg.utils.ArrayUtils;
	/**
	 * ...
	 * @author 
	 */
	public class CashPerSecond 
	{
		protected static const MAX_TIME_FOR_KILL:uint = 30000;//Max milliseconds for a kill, past which last timer = getTimer() - this
		protected static const MAX_ENTRIES:uint = 80;
		protected static const ENTRY_LIFETIME:uint = 10000;//Milliseconds after which entries don't matter anymore
		protected static const WEIGHED_ENTRIES:uint = 2;//Entries which influence average more than others
		protected static const WEIGHED_ENTRIES_STRENGTH:uint = 3;//How much more the weighed entries count for
		
		protected static var _lastTimer:Number = 0;
		protected static var _entries:Array = new Array();
		
		//public static function addEntry(worth:Number):void {
			//var time:Number = getTimer();
			//if (time-_lastTimer > MAX_TIME_FOR_KILL) _lastTimer = time-MAX_TIME_FOR_KILL;
			//
			//var cps:Number = worth / (Math.max(1,(time - _lastTimer)) / 1000);
			//
			//_lastTimer = time;
			//
			//_entries.push([cps, time]);
			//
			//while (_entries.length > MAX_ENTRIES) {
				//_entries.shift();
			//}
		//}
		
		public static function getCashPerSecond():Number {
			var dps:Number = DamagePerSecond.getDPS();
			_entries.push(dps);
			while (_entries.length > MAX_ENTRIES) {
				_entries.shift();
				if (_entries.length <= 0) return 0;
			}
			var total:Number = 0;
			for (var i:int = 0; i < _entries.length; i++) {
				total += _entries[i];
			}
			var average:Number = total / _entries.length;
			
			var bu:BigUint = new BigUint();
			//bu.setValueFromNumber(dps);
			bu.setValueFromNumber(average);
			GameEngine.menu.txtStat5.text = bu.toFormattedString(5);
			//return dps / Number(GameEngine.world.currentObstacle.maxHp) * Number(GameEngine.world.currentObstacle.reward)
			return average / Number(GameEngine.world.currentObstacle.maxHp) * Number(GameEngine.world.currentObstacle.reward)
		}
		
		public static function clearEntries():void {
			_entries = [];
		}
		
		//public static function getCashPerSecondOld():Number {
			//if (_entries.length == 0) return 0;
			//var total:Number = 0;
			//var count:Number = 0;
			//var time:Number = getTimer();
			//
			//while (time - _entries[0][1] > ENTRY_LIFETIME) {
				//_entries.shift();
				//if (_entries.length == 0) return 0;
			//}
			//
			//
			//for (var i:int = 0; i < _entries.length; i++) {
				//if (i >= _entries.length - WEIGHED_ENTRIES) {
					//Add entries multiple times if within weighed entries
					//for (var weigh:int = 0; weigh < WEIGHED_ENTRIES_STRENGTH; weigh++) {
						//total += _entries[i][0];
						//count++;
					//}
				//}
				//total += _entries[i][0];
				//count++;
			//}
			//
			//if (total < 1) return 0;
			//if (count < 1) return 0;
			//
			//var cps:Number = total / count;
			//return cps;
		//}
		
	}

}