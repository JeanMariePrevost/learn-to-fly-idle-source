package src 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class OverwriteScreen extends MovieClip 
	{
		
		public var btnYes:SimpleButton;
		public var btnNo:SimpleButton;
		public var btnOk:SimpleButton;
		
		public var mouseBlock:MovieClip;
		
		
		
		protected const HIDDEN_Y:Number = 800;
		protected const SHOWN_Y:Number = 0;
		protected const FRAME_IN_ANIM:uint = 20;
		
		protected var _counter:int = 0;
		protected var _container:DisplayObjectContainer;
		
		protected var _saveData:Object;
		
		public function OverwriteScreen(container:DisplayObjectContainer, frame:uint = 1, saveData:Object = null) 
		{
			super();
			Log.log("Is savedata null? ", (saveData == null));
			_container = container;
			y = HIDDEN_Y;
			_counter = 0;
			show();
			gotoAndStop(frame);
			if (frame == 4) {
				btnNo.visible = false;
				btnYes.visible = false;
				btnOk.visible = true;
			}else {
				btnNo.visible = true;
				btnYes.visible = true;
				btnOk.visible = false;
			}
			_saveData = saveData;
		}
		
		protected function setup():void {
			y = HIDDEN_Y;
			
			btnYes.addEventListener(MouseEvent.CLICK, yes);
			btnNo.addEventListener(MouseEvent.CLICK, no);
			btnOk.addEventListener(MouseEvent.CLICK, no);
		}
		
		protected function cleanup():void {
			if (btnYes == null) return;
			btnYes.removeEventListener(MouseEvent.CLICK, yes);
			btnNo.removeEventListener(MouseEvent.CLICK, no);
			btnOk.removeEventListener(MouseEvent.CLICK, no);
		}
		
		private function yes(e:MouseEvent):void 
		{
			Log.log("Yes button clicked");
			if (_saveData != null) SaveGame.loadGameFromObject(_saveData);
			hide();
		}
		
		private function no(e:MouseEvent):void 
		{
			_saveData = null;
			hide();
		}
		
		protected function tickShow(delta:Number):void 
		{
			y = Easing.easeOutQuint(_counter, HIDDEN_Y, (SHOWN_Y - HIDDEN_Y), FRAME_IN_ANIM)
			_counter ++;
			
			if (_counter > FRAME_IN_ANIM) {
				Main.phase1.remove(tickShow);
			}
		}
		
		protected function tickHide(delta:Number):void 
		{
			y = Easing.easeOutQuint(_counter, SHOWN_Y, (HIDDEN_Y - SHOWN_Y), FRAME_IN_ANIM)
			_counter ++;
			
			if (_counter > FRAME_IN_ANIM) {
				Main.phase1.remove(tickHide);
				_container.removeChild(this);
				while (numChildren < 0) {
					removeChildAt(0);
				}
				_container = null;
				btnYes = null;
				btnNo = null;
				mouseBlock = null;
			}
		}
		
		public function show():void {
			Main.phase1.remove(tickHide);
			setup();
			_container.addChild(this);
			mouseBlock.visible = true;
			_counter = 0;
			Main.phase1.add(tickShow);
			
		}
		
		public function hide():void {
			if (_container == null && btnYes == null) return;
			Main.phase1.remove(tickShow);
			GameEngine.launcher.enableMouse();
			cleanup();
			mouseBlock.visible = false;
			_counter = 0;
			Main.phase1.add(tickHide);
		}
		
	}

}
