package src 
{
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 
	 */
	public class DamagePerSecond 
	{
		protected static const MAX_ENTRIES:uint = 100;
		protected static const ENTRY_LIFETIME:uint = 3000;//Milliseconds after which entries don't matter anymore
		
		protected static var _entries:Array = new Array();
		
		public static function addEntry(damage:Number):void {
			var time:Number = getTimer();
			
			_entries.push([damage, time]);
			
			while (_entries.length > MAX_ENTRIES) {
				_entries.shift();
			}
		}
		
		public static function resetDPS():void {
			_entries = [];
		}
		
		public static function getDPS():Number {
			if (_entries.length == 0) return 0;
			var total:Number = 0;
			var count:Number = 0;
			var time:Number = getTimer();
			
			while (time - _entries[0][1] > ENTRY_LIFETIME) {
				_entries.shift();
				if (_entries.length == 0) return 0;
			}
			
			for (var i:int = 0; i < _entries.length; i++) {
				total += _entries[i][0];
				count++;
			}
			
			if (total < 1) return 0;
			if (count < 1) return 0;
			
			//var startTime:Number = time - ENTRY_LIFETIME;
			var startTime:Number = _entries[0][1];
			//var timeElapsed:Number = (time - startTime) / 1000;
			var timeElapsed:Number = Math.max(1, (time - startTime) / 1000);
			
			var dps:Number = total / timeElapsed;
			return dps;
		}
		
	}

}