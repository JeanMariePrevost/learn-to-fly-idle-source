package src.obstacles 
{
	import lbg.datatypes.BigUint;
	import src.Research;
	/**
	 * ...
	 * @author 
	 */
	public class ObstacleListEntry 
	{
		public var name:String;
		public var className:Class;
		protected var _distance:Number;
		public var maxHp:BigUint;
		public var hp:BigUint;
		public var reward:String;
		public var defense:String;
		public var scaleMargin:Number;
		protected var _kills:BigUint = new BigUint("0");
		
		
		public function ObstacleListEntry(name:String, className:Class, distance:Number, hp:String, reward:String, defense:String = "0", scaleMargin:Number = 0) 
		{
			this.name = name;
			this.className = className;
			_distance = distance;
			this.maxHp = new BigUint(hp);
			this.hp = new BigUint(hp);
			this.reward = reward;
			this.defense = defense;
			this.scaleMargin = scaleMargin;
		}
		
		public function addKill(count:uint = 1):void {
			_kills.add(count.toFixed());
		}
		
		public function getKills():String {
			return _kills.toFormattedString(6);
		}
		
		public function setKills(count:String):void {
			_kills.setValue(count);
		}
		
		public function get distance():Number 
		{
			return _distance * Research.getDragReduction();
		}
		
	}

}