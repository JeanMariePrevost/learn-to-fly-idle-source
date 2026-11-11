package src.system 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import src.SaveGame;
	
	/**
	 * ...
	 * @author 
	 */
	public class BtnSave extends SimpleButton 
	{
		
		public function BtnSave() 
		{
			super(upState, overState, downState, hitTestState);
			
			addEventListener(MouseEvent.CLICK, click);
		}
		
		protected function click(ev:MouseEvent):void {
			SaveGame.save();
		}
		
	}

}