package src.system 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import src.Audio;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class BtnMute extends SimpleButton 
	{
		
		public function BtnMute() 
		{
			super(upState, overState, downState, hitTestState);
			
			addEventListener(MouseEvent.CLICK, click);
		}
		
		protected function click(ev:MouseEvent):void {
			Main.topLayer.removeChild(this);
			this.removeEventListener(MouseEvent.CLICK, click);
			Main.muteButton = new BtnUnmute();
			Main.topLayer.addChild(Main.muteButton);
			Audio.mute = true;
		}
		
	}

}