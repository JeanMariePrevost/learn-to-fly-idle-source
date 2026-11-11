package src.obstacles 
{
	import lbg.datatypes.BigUint;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.Scaling;
	/**
	 * ...
	 * @author 
	 */
	public class ObstaclesList 
	{
		protected static var _levels:Vector.<ObstacleListEntry>;
		
		protected static function buildList():void {
			_levels = new Vector.<ObstacleListEntry>();
			addEntry("Snowman", 			Snowman, 		300,	0);
			addEntry("Snow Bank", 			SnowPile, 		500,	40);
			addEntry("Ice Boulder", 		IceBoulder, 	600,	50);
			addEntry("El Sombrero", 		ElSombrero, 	750,	-80);
			addEntry("Frozen Dodo", 		IceDodo, 		800,	0);
			addEntry("Ice Block", 			IceBlock, 		1050,	0);
			addEntry("Mysterious Snow", 	MysteriousSnow, 1300,	20);
			addEntry("Fedora Snowman", 		FedoraSnowman, 	1450,	-70);
			addEntry("Ice Cream Stand", 	IceCreamStand, 	1750,	-80);
			addEntry("Baby Snow Bank", 		BabySnowPile, 	1900,	0);
			addEntry("Bigger Boulder", 		IceBoulder2, 	2150,	0);
			addEntry("Slushman", 			Slushman, 		2350,	-100);
			addEntry("Mr. Snowpile", 		MrSnowPile, 	2900,	100);
			addEntry("Lies", 				Word, 			3250,	60);
			addEntry("Dodo Hero", 			IceDodoHero, 	3400,	0);
			addEntry("Supersized Snowman", 	FatSnowman, 	3600,	0);
			addEntry("Monolith", 			Monolith, 		3750,	0);
			addEntry("Ice Factory", 		IceFactory, 	4200,	0);
			addEntry("Snow Monster", 		SnowMonster, 	4850,	50);
			addEntry("Iceberg", 			Iceberg, 		5000,	0);
			addEntry("Mountain", 			Mountain, 		5375,	0);
			addEntry("Dodo Colossus",	 	DodoColossus, 	5850,	0);
			addEntry("Ice Corp", 			IceFactoryBoss, 6300,	0);
			addEntry("Big Berg", 			BigBerg, 		6600,	0);
			addEntry("Ice-BORG", 			IceBorg, 		7150,	0);
			addEntry("Bigger Berg", 		BiggerBerg,	 	7800,	0);
			addEntry("The Wall", 			TheWall, 		8600,	400);
			
			//Space begins here
			addEntry("The Moon", 			Moon, 			1650,	0);
			addEntry("Dodolith", 			Dodolith, 		1800,	0);
			addEntry("Frozen Planet", 		FrozenPlanet, 	2050,	0);
			addEntry("Frozen Moon", 		FrozenMoon, 	2200,	0);
			addEntry("Hoth", 				Hoth, 			2500,	0);
			addEntry("Dodo Homeworld", 		DodoHomeWorld, 	2850,	0);
			addEntry("Dodo Homeworld 2", 	DodoHomeWorld2, 3300,	0);
			addEntry("Dodo Homeworld 3", 	DodoHomeWorld3, 4400,	0);
			addEntry("Dodo Homeworld 4", 	DodoHomeWorld4, 5200,	0);
			addEntry("Dodo Homeworld 5", 	DodoHomeWorld5, 6400,	0);
			
			addEntry("Dodo Homeworld 666", 	DodoHomeWorld6, 8500,	500);
			
			
			////////////////
			//Health
			////////////////
			for (var i:int = 0; i <= 37; i++) {
				var hp:Number = Scaling.hpScale(i, 37);
				_levels[i].hp.setValueFromNumber(hp);
				_levels[i].maxHp.setValueFromNumber(hp);
			}
			//tweaks
			_levels[0].hp.setValue("4");
			_levels[0].maxHp.setValue("4");
			_levels[1].hp.setValue("10");
			_levels[1].maxHp.setValue("10");
			_levels[2].hp.setValue("25");
			_levels[2].maxHp.setValue("25");
			
			_levels[37].hp.setValue("66666666666666666660000000");
			_levels[37].maxHp.setValue("66666666666666666660000000");
			
			////////////////
			//Rewards
			////////////////
			for (var i:int = 0; i <= 37; i++) {
				_levels[i].reward = Scaling.rewardScale(i,37).toFixed();
			}
			//tweaks
			_levels[0].reward = "1";
			_levels[1].reward = "10";
			_levels[2].reward = "30";
			_levels[37].reward = "66666666666666666660000000";
		}
			
		
		protected static function addEntry(name:String, className:Class, distance:Number, scaleMargin:Number = 0):void {
			_levels.push(new ObstacleListEntry(name, className, distance, "1", "0", "0", scaleMargin));
		}
		
		public static function getObstacle(level:uint):ObstacleListEntry {
			if (_levels == null) buildList();
			return _levels[level];
		}
		
		public static function get obstacleCount():uint {
			return _levels.length;
		}
		
	}

}