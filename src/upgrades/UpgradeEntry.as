package src.upgrades 
{
	import lbg.datatypes.BigUint;
	import src.Research;
	/**
	 * ...
	 * @author 
	 */
	public class UpgradeEntry 
	{
		protected var _cost:String;
		public var stat:String;
		
		public function UpgradeEntry(stat:String, cost:String) 
		{
			this.stat = stat;
			_cost = cost;
		}
		
		public function get cost():String {
			var bu:BigUint = new BigUint(_cost);
			bu.multiply(Research.getCheaperUpgrades(), 3);
			return bu.toString();
		}
		
		public function set cost(value:String):void 
		{
			_cost = value;
		}
		
		
	}

}