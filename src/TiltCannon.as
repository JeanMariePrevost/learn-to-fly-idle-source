package src 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Tools;
	import lbg.utils.Trig;
	/**
	 * ...
	 * @author 
	 */
	public class TiltCannon extends MovieClip 
	{
		
		public var holderMc:MovieClip;
		
		public var cannon:Cannon;
		
		public var target:MovieClip;
		public var lastClickIndicator:MovieClip;
		
		protected var _keyRaised:Boolean = true;
		
		public function TiltCannon() 
		{
			gotoAndStop(1);
			cannon = new Cannon();
			holderMc.addChild(cannon);
			target = cannon.target;
			target.visible = false;
			cannon.gotoAndStop(1);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		protected function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			GameEngine.instanceOf.addEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, function(){_keyRaised = true});
			
			gotoAndStop(1);
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			if (!_keyRaised) return;
			GameEngine.manualFireCounter += 1;
			GameEngine.manualFireCounter = Math.min(GameEngine.MAX_SHOT_QUEUED, GameEngine.manualFireCounter);
			_keyRaised = false;
		}
		
		public function disableMouse():void {
			GameEngine.instanceOf.removeEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		public function enableMouse():void {
			GameEngine.instanceOf.addEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		
		
		public function mouseMove(e:MouseEvent):void {
			var pos:Point = new Point(x, y);
			pos = parent.localToGlobal(pos);
			holderMc.rotation = Trig.angleTo(pos.x, pos.y, e.stageX, e.stageY);
			if (GameEngine.currentlyInSpace) {
				holderMc.rotation = NumberUtils.constrain(holderMc.rotation, -110, 45);
			}else {
				holderMc.rotation = NumberUtils.constrain(holderMc.rotation, -100, 0);
			}
		}
		
		public function mouseClick(e:MouseEvent):void {
			if (e.stageY < 200) return;
			if (lastClickIndicator != null) {
				lastClickIndicator.parent.removeChild(lastClickIndicator);
			}
			lastClickIndicator = new LastClick();
			lastClickIndicator.x = e.stageX;
			lastClickIndicator.y = e.stageY;
			GameEngine.instanceOf.addChild(lastClickIndicator);
			mouseMove(e);
			
			GameEngine.manualFireCounter += 1;
			GameEngine.manualFireCounter = Math.min(GameEngine.MAX_SHOT_QUEUED, GameEngine.manualFireCounter);
		}
		
		public function shoot():void {
			var pos:Point = DisplayObjectUtil.localToLocal2(cannon.target, cannon, parent);
			if (GameEngine.shootBullet(pos.x, pos.y, holderMc.rotation)) {
				fireAnim();
			}
		}
		
		public function fireAnim():void {
			cannon.gotoAndPlay(2);
			gotoAndPlay(2);
		}
		
	}

}