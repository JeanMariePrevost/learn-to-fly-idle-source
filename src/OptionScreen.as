package src 
{
	import com.hybrid.ui.ToolTip;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class OptionScreen extends MovieClip 
	{
		
		public var btnBack:SimpleButton;
		
		public var mouseBlock:MovieClip;
		
		public var btnNew:SimpleButton;
		public var btnSave:SimpleButton;
		public var btnLoad:SimpleButton;
		public var btnTransfer:SimpleButton;
		
		
		public var btnAutoSavePrevious:SimpleButton;
		public var btnAutoSaveNext:SimpleButton;
		public var autoSaveMc:MovieClip;
		
		public var btnBgm1:SimpleButton;
		public var btnBgm2:SimpleButton;
		public var btnBgm3:SimpleButton;
		public var btnBgm4:SimpleButton;
		public var btnBgm5:SimpleButton;
		public var btnBgm6:SimpleButton;
		public var btnBgm7:SimpleButton;
		public var btnBgm8:SimpleButton;
		public var btnBgm9:SimpleButton;
		public var btnBgm10:SimpleButton;
		
		public var volumeSlider:MovieClip;
		protected var volumeSliderClick:Boolean = false;
		
		
		protected const HIDDEN_Y:Number = 800;
		protected const SHOWN_Y:Number = 0;
		protected const FRAME_IN_ANIM:uint = 20;
		
		protected var _counter:int = 0;
		protected var _container:DisplayObjectContainer;
		
		public function OptionScreen(container:DisplayObjectContainer) 
		{
			super();
			_container = container;
			y = HIDDEN_Y;
			_counter = 0;
			show();
			
			btnNew.addEventListener(MouseEvent.CLICK, newGame);
			btnSave.addEventListener(MouseEvent.CLICK, function ():void{ SaveGame.saveToFile()});
			btnLoad.addEventListener(MouseEvent.CLICK, function ():void{ SaveGame.loadFromFile()});
			
			stage.addEventListener(MouseEvent.MOUSE_UP, volumeMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, volumeMove);
			volumeSlider.addEventListener(MouseEvent.MOUSE_DOWN, volumeMouseDown);
			volumeSlider.gotoAndStop(Math.floor(Audio.volume * 400));
			
			btnAutoSavePrevious.addEventListener(MouseEvent.CLICK, autoSavePrevious);
			btnAutoSaveNext.addEventListener(MouseEvent.CLICK, autoSaveNext);
			
			btnBgm1.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm1() } );
			btnBgm2.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm2() } );
			btnBgm3.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm3() } );
			btnBgm4.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm4() } );
			btnBgm5.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm5() } );
			btnBgm6.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm6() } );
			btnBgm7.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm7() } );
			btnBgm8.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm8() } );
			btnBgm9.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm9() } );
			btnBgm10.addEventListener(MouseEvent.CLICK, function() { Audio.playBgm0() } );
			
		}
		
		private function autoSavePrevious(e:MouseEvent):void 
		{
			if (Main.autoSaveInterval <= 30) {
				//Min
			}else if (Main.autoSaveInterval <= 60) {
				setAutoSave(30);
			}else if (Main.autoSaveInterval <= 300) {
				setAutoSave(60);
			}else if (Main.autoSaveInterval <= 600) {
				setAutoSave(300);
			}else if (Main.autoSaveInterval <= 1800) {
				setAutoSave(600);
			}else if (Main.autoSaveInterval <= 3600) {
				setAutoSave(1800);
			}else {
				setAutoSave(3600);
			}
		}
		
		private function autoSaveNext(e:MouseEvent):void 
		{
			if (Main.autoSaveInterval <= 30) {
				setAutoSave(60);
			}else if (Main.autoSaveInterval <= 60) {
				setAutoSave(300);
			}else if (Main.autoSaveInterval <= 300) {
				setAutoSave(600);
			}else if (Main.autoSaveInterval <= 600) {
				setAutoSave(1800);
			}else if (Main.autoSaveInterval <= 1800) {
				setAutoSave(3600);
			}else if (Main.autoSaveInterval <= 3600) {
				setAutoSave(uint.MAX_VALUE);
			}else {
				//Maxed
			}
		}
		
		public function setAutoSave(seconds:uint):void {
			Main.autoSaveInterval = seconds;
			updateAutoSave();
		}
		
		public function updateAutoSave():void {
			if (Main.autoSaveInterval <= 30) {
				Main.autoSaveInterval = 30;
				autoSaveMc.gotoAndStop(1);
			}else if (Main.autoSaveInterval <= 60) {
				Main.autoSaveInterval = 60;
				autoSaveMc.gotoAndStop(2);
			}else if (Main.autoSaveInterval <= 300) {
				Main.autoSaveInterval = 300;
				autoSaveMc.gotoAndStop(3);
			}else if (Main.autoSaveInterval <= 600) {
				Main.autoSaveInterval = 600;
				autoSaveMc.gotoAndStop(4);
			}else if (Main.autoSaveInterval <= 1800) {
				Main.autoSaveInterval = 1800;
				autoSaveMc.gotoAndStop(5);
			}else if (Main.autoSaveInterval <= 3600) {
				Main.autoSaveInterval = 3600;
				autoSaveMc.gotoAndStop(6);
			}else if (Main.autoSaveInterval == uint.MAX_VALUE) {
				Main.autoSaveInterval = uint.MAX_VALUE;
				autoSaveMc.gotoAndStop(7);
			}else {
				//Error? Default to 60 sec
				Main.autoSaveInterval = 60;
				autoSaveMc.gotoAndStop(2);
			}
			Log.log("Auto-save Interval:", Main.autoSaveInterval);
		}
		
		private function newGame(e:MouseEvent):void 
		{
			//SaveGame.loadGameFromObject(SaveGame.createEmptySaveObject());
			new OverwriteScreen(Main.topLayer, 3, SaveGame.createEmptySaveObject());
			hide();
		}
		
		private function volumeMouseUp(e:MouseEvent):void 
		{
			volumeSliderClick = false;
		}
		
		private function volumeMouseDown(e:MouseEvent):void 
		{
			volumeSliderClick = true;
			volumeMove(e);
		}
		
		private function volumeMove(e:MouseEvent):void 
		{
			if (volumeSliderClick) {
				var X:Number = (e.stageX - volumeSlider.x);
				var frame:Number = Math.floor(X / 368 * 400);
				frame = NumberUtils.constrain(frame, 1, 400);
				trace(X, frame);
				volumeSlider.gotoAndStop(frame);
				Audio.setVolume(X / 368);
			}
		}
		
		protected function setup():void {
			y = HIDDEN_Y;
			
			btnSave.visible = true;
			btnTransfer.visible = false;
			btnLoad.visible = true;
			
			btnBack.addEventListener(MouseEvent.CLICK, click);
			updateAutoSave();
		}
		
		protected function cleanup():void {
			if(btnBack !=null) btnBack.removeEventListener(MouseEvent.CLICK, click);
		}
		
		private function click(e:MouseEvent):void 
		{
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
				btnBack = null;
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
			
			
			if (!Achievements._spaceReached) {
				DisplayObjectUtil.setObjectSaturation(btnBgm10, 0, 0.5);
				btnBgm10.enabled = false;
				btnBgm10.mouseEnabled = false;
			}else {
				DisplayObjectUtil.setObjectSaturation(btnBgm10, 1, 1);
				btnBgm10.enabled = true;
				btnBgm10.mouseEnabled = true;
			}
		}
		
		public function hide():void {
			if (_container == null && btnBack == null) return;
			Main.phase1.remove(tickShow);
			GameEngine.launcher.enableMouse();
			cleanup();
			mouseBlock.visible = false;
			_counter = 0;
			Main.phase1.add(tickHide);
		}
		
	}

}