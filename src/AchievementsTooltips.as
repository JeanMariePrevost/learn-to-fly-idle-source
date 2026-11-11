package src 
{
	/**
	 * ...
	 * @author 
	 */
	public class AchievementsTooltips 
	{
		
		protected static var _list:Array;
		
		public static function getTooltipTitle(id:uint):String {
			buildList();
			return _list[id][0];
		}
		
		public static function getTooltipBody(id:uint):String {
			buildList();
			
			var tt:String = _list[id][1];
			
			tt = tt + "\n" + "Reward: " +  getTooltipReward(id) + " RP";
			
			//Kills
			if (id == 8) tt = tt + "\n" + "( " + Math.min(Achievements._kills, 25) + " / 25 )";
			if (id == 9) tt = tt + "\n" + "( " + Math.min(Achievements._kills, 100) + " / 100 )";
			if (id == 10) tt = tt + "\n" + "( " + Math.min(Achievements._kills, 500) + " / 500 )";
			if (id == 11) tt = tt + "\n" + "( " + Math.min(Achievements._kills, 1000) + " / 1000 )";
			if (id == 12) tt = tt + "\n" + "( " + Math.min(Achievements._kills, 2000) + " / 2000 )";
			if (id == 13) tt = tt + "\n" + "( " + Math.min(Achievements._kills, 5000) + " / 5000 )";
			if (id == 14) tt = tt + "\n" + "( " + Math.min(Achievements._kills, 10000) + " / 10000 )";
			if (id == 15) tt = tt + "\n" + "( " + Math.min(Achievements._kills, 25000) + " / 25000 )";
			
			//Upgrades
			if (id == 16) tt = tt + "\n" + "( " + Math.min(GameEngine.damageLevel, 20) + " / 20 )";
			if (id == 17) tt = tt + "\n" + "( " + Math.min(GameEngine.damageLevel, 200) + " / 200 )";
			if (id == 18) tt = tt + "\n" + "( " + Math.min(GameEngine.launchPowerLevel, 5) + " / 5 )";
			if (id == 19) tt = tt + "\n" + "( " + Math.min(GameEngine.launchPowerLevel, 30) + " / 30 )";
			if (id == 20) tt = tt + "\n" + "( " + Math.min(GameEngine.maxShotsLevel, 5) + " / 5 )";
			if (id == 21) tt = tt + "\n" + "( " + Math.min(GameEngine.maxShotsLevel, 20) + " / 20 )";
			if (id == 22) tt = tt + "\n" + "( " + Math.min(GameEngine.autoFireLevel, 1) + " / 1 )";
			if (id == 23) tt = tt + "\n" + "( " + Math.min(GameEngine.autoFireLevel, 20) + " / 20 )";
			
			//Shots fired
			if (id == 24) tt = tt + "\n" + "( " + Math.min(Achievements._shotsFired, 100) + " / 100 )";
			if (id == 25) tt = tt + "\n" + "( " + Math.min(Achievements._shotsFired, 2500)+ " / 2500 )";
			if (id == 26) tt = tt + "\n" + "( " + Math.min(Achievements._shotsFired, 25000)+ " / 25000 )";
			if (id == 27) tt = tt + "\n" + "( " + Math.min(Achievements._shotsFired, 100000) + " / 100000 )";
			
			//Cash
			if (id == 28) tt = tt + "\n" + "( " + Math.min(Achievements._maxCash.toNumber(), 1000) + " / 1000 )";
			if (id == 29) tt = tt + "\n" + "( " + Math.min(Achievements._maxCash.toNumber(), 1000000) + " / 1000000 )";
			if (id == 30) tt = tt + "\n" + "( " + Math.min(Achievements._maxCash.toNumber(), 1000000000000) + " / 1000000000000 )";
			if (id == 31) tt = tt + "\n" + "( " + Math.min(Achievements._maxCash.toNumber(), 1000000000000000000) + " / 1000000000000000000 )";
			
			//Play time
			if (id == 32) tt = tt + "\n" + "( " + Math.min(Achievements._playSeconds, 300) + " / 300 )";
			if (id == 33) tt = tt + "\n" + "( " + Math.min(Achievements._playSeconds, 1800)+ " / 1800 )";
			if (id == 34) tt = tt + "\n" + "( " + Math.min(Achievements._playSeconds, 7200)+ " / 7200 )";
			if (id == 35) tt = tt + "\n" + "( " + Math.min(Achievements._playSeconds, 28800) + " / 28800 )";
			
			return tt;
		}
		
		public static function getTooltipReward(id:uint):String {
			buildList();
			return _list[id][2];
		}
		
		protected static function buildList():void {
			if (_list == null) {
				_list = new Array();
				
				addEntry("Conqueror 1", "Destroy the Snow Bank", 50);
				addEntry("Conqueror 2", "Destroy the Mysterious Snow", 100);
				addEntry("Conqueror 3", "Destroy the Slushman", 200);
				addEntry("Conqueror 4", "Destroy the Dodo Hero", 300);
				addEntry("Conqueror 5", "Destroy the Iceberg", 400);
				addEntry("Conqueror 6", "Destroy the Wall", 500);
				addEntry("Conqueror 7", "Destroy the Dodo Homeworld", 600);
				addEntry("Conqueror 8", "Destroy the DEVIL", 750);
				
				addEntry("Destroyer 1", "Destroy 25 objects", 50);
				addEntry("Destroyer 2", "Destroy 100 objects", 100);
				addEntry("Destroyer 3", "Destroy 500 objects", 200);
				addEntry("Destroyer 4", "Destroy 1000 objects", 300);
				addEntry("Destroyer 5", "Destroy 2000 objects", 400);
				addEntry("Destroyer 6", "Destroy 5000 objects", 500);
				addEntry("Destroyer 7", "Destroy 10000 objects", 600);
				addEntry("Destroyer 8", "Destroy 25000 objects", 750);
				
				addEntry("That Hurts 1", "Upgrade your damage 20 times", 50);
				addEntry("That Hurts 2", "Upgrade your damage 200 times", 250);
				addEntry("Fly! 1", "Upgrade your launch power 5 times", 50);
				addEntry("Fly! 2", "Upgrade your launch power 30 times", 250);
				addEntry("Volley 1", "Upgrade your max shots 5 times", 50);
				addEntry("Volley 2", "Upgrade your max shots 20 times", 250);
				addEntry("Full Auto 1", "Upgrade your auto-fire once", 50);
				addEntry("Full Auto 2", "Upgrade your auto-fire 20 times", 250);
				
				addEntry("Trigger Happy 1", "Fire a total of 100 shots", 50);
				addEntry("Trigger Happy 2", "Fire a total of 2,500 shots", 100);
				addEntry("Trigger Happy 3", "Fire a total of 25,000 shots", 250);
				addEntry("Trigger Happy 4", "Fire a total of 100,000 shots", 500);
				addEntry("Means to an ends 1", "Save a total of $1,000", 50);
				addEntry("Means to an ends 2", "Save a total of $1,000,000", 100);
				addEntry("Means to an ends 3", "Save a total of $1,000,000,000,000", 250);
				addEntry("Means to an ends 4", "Save a total of $1,000,000,000,000,000,000", 500);
				
				addEntry("Just a quick look", "Play for 5 minutes", 100);
				addEntry("A bit more maybe", "Play for 30 minutes", 500);
				addEntry("Just one last shot...", "Play for 2 hours", 1000);
				addEntry("WHAT YEAR IS IT!?!", "Play for 8 hours", 5000);
				
				addEntry("Space Program", "Reach outer space", 500);
				addEntry("Research And Development", "Research everything to level 10", 500);
				addEntry("This thing can go to 11", "Research one upgrade above 10", 500);
				addEntry("Support the dev", "Check us out on Facebook!", 1000);
				
			}
		}
		
		protected static function addEntry(title:String, body:String, reward:uint):void {
			_list.push([title, body, reward.toFixed()]);
		}
		
	}

}