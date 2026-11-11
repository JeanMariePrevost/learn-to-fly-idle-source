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
	public class BtnUnmute extends SimpleButton 
	{
		
		public function BtnUnmute() 
		{
			super(upState, overState, downState, hitTestState);
			
			addEventListener(MouseEvent.CLICK, click);
		}
		
		protected function click(ev:MouseEvent):void {
			Main.topLayer.removeChild(this);
			this.removeEventListener(MouseEvent.CLICK, click);
			Main.muteButton = new BtnMute();
			Main.topLayer.addChild(Main.muteButton);
			Audio.mute = false;
		}
	}

}