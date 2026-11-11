package src 
{
	import com.hybrid.ui.ToolTip;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class AchievementScreen extends MovieClip 
	{
		
		public var btnBack:SimpleButton;
		
		public var mouseBlock:MovieClip;
		
		public var txtProgress:TextField;
		
		public var btnFB:SimpleButton;
		public var btnKS:SimpleButton;
		
		protected const HIDDEN_Y:Number = 800;
		protected const SHOWN_Y:Number = 0;
		protected const FRAME_IN_ANIM:uint = 20;
		
		protected var _counter:int = 0;
		protected var _container:DisplayObjectContainer;
		
		protected var icons:Vector.<AchievementIcon> = new Vector.<AchievementIcon>();
		
		
		public function AchievementScreen(container:DisplayObjectContainer) 
		{
			super();
			btnKS.visible = false;
			
			btnFB.visible = true;
			btnFB.addEventListener(MouseEvent.CLICK, supportClicked);
			
			_container = container;
			y = HIDDEN_Y;
			_counter = 0;
			
			buildList();
			
			Achievements.achievementSignal.add(newAchievement);
			
		}
		
		private function supportClicked(e:MouseEvent):void {
			Achievements.setSpecialLink();
		}

		protected function newAchievement(id:uint):void {
			updateAchievements();
		}
		
		protected function buildList():void {
			var baseX:Number = 140;
			//var baseY:Number = 225;
			var baseY:Number = 175;
			var distX:Number = 60;
			var distY:Number = 60;
			
			var count:int = 0;
			for (var j:int = 0; j < 5; j++) {
				for (var i:int = 0; i < 8; i++) {
					count++;
					var icon:AchievementIcon = new AchievementIcon(count);
					icon.x = baseX + (i * distX);
					icon.y = baseY + (j * distY);
					icon.addEventListener(MouseEvent.ROLL_OVER, rollOver);
					addChild(icon);
					icons.push(icon);
				}
			}
			
		}
		
		protected function rollOver(e:MouseEvent):void {
			var id:int = icons.indexOf(e.target);
			if (id < 0) return;
			var tt:ToolTip = new ToolTip();
			tt.autoSize = true;
			tt.align = "center";
			tt.offsetPosition(3, 95);
			tt.show(this, AchievementsTooltips.getTooltipTitle(id), AchievementsTooltips.getTooltipBody(id));
		}
		
		public function updateAchievements():void {
			var count:int = 0;
			var total:int = 0;
			for (var i:int = 0; i < icons.length; i++) {
				if (Achievements.checkAchievement(i)) {
					icons[i].gotoAndStop(i + 51);
					count++;
				}else {
					icons[i].gotoAndStop(i + 1);
				}
				total ++;
			}
			
			txtProgress.text = count.toFixed() + "/" + total.toFixed();
		}
		
		protected function setup():void {
			y = HIDDEN_Y;
			
			btnBack.addEventListener(MouseEvent.CLICK, click);
		}
		
		protected function cleanup():void {
			btnBack.removeEventListener(MouseEvent.CLICK, click);
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
			}
		}
		
		public function show():void {
			Main.phase1.remove(tickHide);
			setup();
			_container.addChild(this);
			mouseBlock.visible = true;
			_counter = 0;
			Main.phase1.add(tickShow);
			updateAchievements();
		}
		
		public function hide():void {
			Main.phase1.remove(tickShow);
			GameEngine.launcher.enableMouse();
			cleanup();
			mouseBlock.visible = false;
			_counter = 0;
			Main.phase1.add(tickHide);
		}
		
	}

}