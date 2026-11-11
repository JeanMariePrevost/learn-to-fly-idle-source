package src 
{
	import ca.esdot.stats.FastStats;
	import com.hurlant.math.BigInteger;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import lbg.compositetick.DeltaTimer;
	import lbg.datatypes.BigUint;
	import lbg.debug.Log;
	import lbg.fpsdisplay.FPSDisplay;
	import lbg.utils.NumberUtils;
	import net.hires.debug.Stats;
	import org.osflash.signals.Signal;
	import src.system.BtnMenu;
	import src.system.BtnMute;
	import src.system.BtnSave;
	import src.system.BtnUnmute;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends MovieClip
	{
		public static var autoSaveInterval:uint = 60;//In seconds
		public static var autoSaveTime:Number = 0;//In seconds
		public static var autoSaveCounter:uint = 0;
		
		protected static var _deltaTimer:DeltaTimer = new DeltaTimer(60, 3);
		public static var phase1:Signal = new Signal(Number);
		public static var phase2:Signal = new Signal(Number);
		
		public static var timer:Timer = new Timer(1000);//Used for saves and achivements
		public static var frameTimer:Timer = new Timer(31);//Main game loop
		
		public static var topLayer:Sprite = new Sprite();
		public static var mainLayer:Sprite = new Sprite();
		
		public static var optionScreen:OptionScreen;
		public static var muteButton:SimpleButton;
		
		protected var stats:Stats = new Stats();
		
		//Intros stuff
		protected var openingIntro:OpeningIntro;
		protected var lbgIntro:LbgIntro;
		protected var _introTimeout:Timer = new Timer(7000, 1);
		/////////////
		
		public function Main(mute:Boolean)
		{
			DeltaTimer.DELTA_MAX = 50;
			Audio.mute = mute;
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			Log.initiate(stage);
			
			
			setup();
			
			openingIntro = new OpeningIntro();
			addChild(openingIntro);
			openingIntro.x = stage.stageWidth / 2;
			openingIntro.y = stage.stageHeight / 2;
			openingIntro.addEventListener(Event.ENTER_FRAME, openingEnterFrame);
			_introTimeout.delay = 7000;
			_introTimeout.repeatCount = 1;
			_introTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, openingIntroDone);
			_introTimeout.start();
		}
		
		private function openingEnterFrame(e:Event):void
		{
			if (openingIntro.currentLabel == "end") {
				openingIntroDone(e);
			}
		}
		
		protected function openingIntroDone(e:Event):void {
			openingIntro.removeEventListener(Event.ENTER_FRAME, openingEnterFrame);
			_introTimeout.removeEventListener(TimerEvent.TIMER_COMPLETE, openingIntroDone);
			_introTimeout.stop();
			openingIntro.stop();
			removeChild(openingIntro);
			openingIntro = null;

			lbgIntro = new LbgIntro();
			addChild(lbgIntro);
			lbgIntro.x = stage.stageWidth / 2;
			lbgIntro.y = stage.stageHeight / 2;
			lbgIntro.addEventListener(Event.ENTER_FRAME, lbgEnterFrame);
			_introTimeout.delay = 7000;
			_introTimeout.repeatCount = 1;
			_introTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, lbgIntroDone);
			_introTimeout.start();
		}
		
		private function lbgEnterFrame(e:Event):void 
		{
			if (lbgIntro.currentLabel == "end") {
				lbgIntroDone(e);
			}
		}
		
		private function lbgIntroDone(e:Event):void 
		{
			if (lbgIntro) {
				lbgIntro.removeEventListener(Event.ENTER_FRAME, lbgEnterFrame);
				lbgIntro.stop();
				removeChild(lbgIntro);
			}
			if (_introTimeout) {
				_introTimeout.removeEventListener(TimerEvent.TIMER_COMPLETE, lbgIntroDone);
				_introTimeout.stop();
			}
			lbgIntro = null;
			
			setupGame();
			
		}
		
		private function setupGame():void 
		{
			if (Audio.mute) {
				muteButton = new BtnUnmute();
				topLayer.addChild(muteButton);
			}else {
				muteButton = new BtnMute();
				topLayer.addChild(muteButton);
			}
			Audio.playBgm1();
			
			topLayer.addChild(new BtnSave());
			topLayer.addChild(new BtnMenu());
			
			new GameEngine(mainLayer);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			Log.log("Save file exists?", SaveGame.saveFileExists);
			if (SaveGame.saveFileExists) {
				SaveGame.load();
			}
			
		}
		
		private function setup():void {
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.quality = "medium";
			
			addChild(mainLayer);
			addChild(topLayer);
			
			stats.scaleX = stats.scaleY = 1.5;
			topLayer.addChild(stats);
			stats.visible = false;
			
			frameTimer.addEventListener(TimerEvent.TIMER, enterFrame);
			frameTimer.start();
			
			var stageBorder:MovieClip = new BlackBox();
			stageBorder.x = stage.stageWidth / 2;
			stageBorder.y = stage.stageHeight / 2;
			addChild(stageBorder);
		}
		
		//protected var debugCps:Number = GameEngine.cash.value.toNumber();
		private function onTimer(e:TimerEvent):void 
		{
			//var newCash:Number = GameEngine.cash.value.toNumber();
			//trace("Actual DPS=", newCash - debugCps);
			//debugCps = newCash;
			Achievements.addTimePlayed(1);
			autoSaveCounter ++;
			if (autoSaveInterval < 30) autoSaveInterval = 30;//Debug
			//Log.log(autoSaveCounter, autoSaveInterval);
			if (autoSaveCounter >= autoSaveInterval) {
				SaveGame.save();
				Log.log("Auto-save complete.");
				autoSaveCounter = 0;
			}
		}
		
		public function key(e:KeyboardEvent):void {
			//Log.log(e.keyCode);
			if (e.keyCode == 119) {
				Log.toggleVisibility();
			}else if ( e.keyCode == 118) {
				stats.visible = !stats.visible;
			}
		}
		
		
		//debug
		protected var nextFrameTimer:Number = 0;
		protected const frameTimerBuffer:Number = 50;
		protected var framsSkipCount:uint = 0;
		protected const MaxFrameSkip:uint = 10;
		protected function enterFrame(e:TimerEvent):void {
			//if (getTimer() >= nextFrameTimer && framsSkipCount < MaxFrameSkip) {
			//if (false) {
				//Frameskip
				//trace("FRAMESKIP", framsSkipCount);
				//framsSkipCount += 1;
			//}else {
				var delta:Number = _deltaTimer.tickTimer();
				phase1.dispatch(delta);
				phase2.dispatch(delta);
				e.updateAfterEvent();
				framsSkipCount = 0;
			//}
			nextFrameTimer = getTimer() + frameTimer.delay + frameTimerBuffer;
		}
		
	}

}