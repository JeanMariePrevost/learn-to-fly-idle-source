package src 
{
	import lbg.datatypes.BigUint;
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class Cash 
	{
		public const MAX_DIGITS:uint = 16;
		public const TRIM_STEP:uint = 4;//Number of ,000s to remove at each trim step (e.g. 1,000,000,000 becomes 1G and not 1,000,000k)
		
		public var value:BigUint = new BigUint();
		
		public function Cash() 
		{
			value.setValue("0");
		}
		
		public function add(amount:String):void {
			value.add(amount);
		}
		
		public function substract(amount:String):void {
			value.substract(amount);
		}
		
		public function toString():String {
			return value.toString();
		}
		
		public function toFormattedString():String {
			return value.toFormattedString(MAX_DIGITS, TRIM_STEP);
		}
		
		public function valueOf():Number {
			return Number(value);
		}
		
		public function isEqualTo(num:String):Boolean {
			return value.isEqualTo(num);
		}
		
		public function isGreaterThan(num:String):Boolean {
			return value.isGreaterThan(num);
		}
		
		public function isGreaterThanEqualTo(num:String):Boolean {
			return value.isGreaterThanEqualTo(num);
		}
		
		public function isLessThan(num:String):Boolean {
			return value.isLessThan(num);
		}
		
		public function isLessThanEqualTo(num:String):Boolean {
			return value.isLessThanEqualTo(num);
		}
		
		public function setValue(value:String):void {
			this.value.setValue(value);
		}
		
	}

}