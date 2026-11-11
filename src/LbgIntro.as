package src 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class LbgIntro extends MovieClip 
	{
		public var btnSkip:SimpleButton;
		
		public function LbgIntro() 
		{
			super();
			
			btnSkip.addEventListener(MouseEvent.CLICK, skipIntro);
			Audio.playLbgTheme();
		}
		
		private function skipIntro(e:Event):void 
		{
			gotoAndPlay("end");
			Audio.stopAll();
		}
		
		
	}

}