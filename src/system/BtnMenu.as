package src.system 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import src.Main;
	import src.OptionScreen;
	
	/**
	 * ...
	 * @author 
	 */
	public class BtnMenu extends SimpleButton 
	{
		
		public function BtnMenu() 
		{
			super(upState, overState, downState, hitTestState);
			
			addEventListener(MouseEvent.CLICK, click);
		}
		
		protected function click(ev:MouseEvent):void {
			Main.optionScreen = new OptionScreen(Main.topLayer);
		}
		
	}

}