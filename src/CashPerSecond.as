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
		protected static const MAX_ENTRIES:uint = 80;
		protected static const ENTRY_LIFETIME:uint = 3000;//Milliseconds after which entries don't matter anymore
		
		protected static var _lastTimer:Number = 0;
		protected static var _entries:Array = new Array();
		
		protected static var _buffer:Array = new Array();
		protected static const BUFFER_SIZE:uint = 40;
		
		public static function addHit(reward:Number, damage:Number, maxHp:Number):void {
			
			var worth:Number = (damage >= maxHp) ? reward:reward / Math.ceil(maxHp / damage);
			var time:Number = getTimer();
			
			_entries.push([worth, time]);
			
			while (time - (_entries[0][1]) > ENTRY_LIFETIME || _entries.length > MAX_ENTRIES) {
				_entries.shift();
			}
		}
		
		public static function getCashPerSecond():Number {
			if (_entries.length <= 0) return 0;
			var time:Number = getTimer();
			while (time - (_entries[0][1]) > ENTRY_LIFETIME || _entries.length > MAX_ENTRIES) {
				_entries.shift();
				if (_entries.length <= 0) return 0;
			}
			var total:Number = 0;
			for (var i:int = 0; i < _entries.length; i++) {
				total += _entries[i][0];
			}
			var span:Number = time - _entries[0][1];
			//var span:Number = ENTRY_LIFETIME;
			var cps:Number = total / Math.max(1, (span / 1000));
			
			_buffer.push(cps);
			while (_buffer.length > BUFFER_SIZE) {
				_buffer.shift();
			}
			
			//Smoothing return
			var bufferTotal:Number = 0;
			for (i = 0; i < _buffer.length; i++) {
				bufferTotal += _buffer[i];
			}
			var buffered:Number = bufferTotal / _buffer.length;
			
			//Update DPS from here
			var bu:BigUint = new BigUint();
			bu.setValueFromNumber(DamagePerSecond.getDPS());
			GameEngine.menu.txtStat5.text = bu.toFormattedString(5);
			
			return buffered;
		}
		
		public static function clearEntries():void {
			_entries = [];
			_buffer = [];
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