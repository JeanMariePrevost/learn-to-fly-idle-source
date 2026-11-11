package src 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import lbg.utils.Easing;
	
	/**
	 * ...
	 * @author 
	 */
	public class AchievementPopup extends MovieClip 
	{
		protected const HIDDEN_Y:Number = 65;
		protected const SHOWN_Y:Number = 0;
		protected const ANIM_FRAMES:uint = 20;
		protected const WAIT_FRAMES:uint = 60;
		
		public var icon:MovieClip;
		
		public var txtTitle:TextField;
		public var txtBody:TextField;
		
		protected var _count:int = 0;
		
		public function AchievementPopup(id:uint) 
		{
			super();
			y = HIDDEN_Y;
			icon.gotoAndStop(id + 51);
			addEventListener(Event.ENTER_FRAME, tickUp);
			
			txtTitle.text = AchievementsTooltips.getTooltipTitle(id);
			txtBody.text = AchievementsTooltips.getTooltipReward(id) + " Research Points!";
		}
		
		protected function tickUp(e:Event):void {
			y = Easing.easeOutQuad(_count, HIDDEN_Y, SHOWN_Y - HIDDEN_Y, ANIM_FRAMES);
			//trace(y);
			if (_count >= ANIM_FRAMES) {
				removeEventListener(Event.ENTER_FRAME, tickUp);
				addEventListener(Event.ENTER_FRAME, tickWait);
				_count = 0;
			}
			_count++;
		}
		
		protected function tickWait(e:Event):void {
			if (_count >= WAIT_FRAMES) {
				removeEventListener(Event.ENTER_FRAME, tickWait);
				addEventListener(Event.ENTER_FRAME, tickDown);
				_count = 0;
			}
			_count++;
		}
		
		protected function tickDown(e:Event):void {
			y = Easing.easeInQuad(_count, SHOWN_Y, HIDDEN_Y-SHOWN_Y, ANIM_FRAMES);
			if (_count >= ANIM_FRAMES) {
				stop();
				while (numChildren > 0) {
					removeChildAt(0);
				}
				icon = null
				parent.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, tickDown);
			}
			_count++;
		}
	}

}