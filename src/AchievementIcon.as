package src 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class AchievementIcon extends MovieClip 
	{
		public var id:int;
		
		public function AchievementIcon(id:int) 
		{
			
			this.id = id;
			super();
			gotoAndStop(id);
			
		}
		
	}

}