package src 
{
	import com.hybrid.ui.ToolTip;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.StringUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResearchScreen extends MovieClip 
	{
		public var btnDamageMult:SimpleButton;
		public var btnSpeedDamage:SimpleButton;
		public var btnDrag:SimpleButton;
		public var btnCheaperUpgrades:SimpleButton;
		public var btnMoreRP:SimpleButton;
		
		public var btnDamageMultOver:SimpleButton;
		public var btnSpeedDamageOver:SimpleButton;
		public var btnDragOver:SimpleButton;
		public var btnCheaperUpgradesOver:SimpleButton;
		public var btnMoreRPOver:SimpleButton;
		
		public var disabledDamageMult:MovieClip;
		public var disabledSpeedDamage:MovieClip;
		public var disabledDrag:MovieClip;
		public var disabledCheaperUpgrades:MovieClip;
		public var disabledMoreRP:MovieClip;
		
		public var btnBack:SimpleButton;
		
		public var mouseBlock:MovieClip;
		
		public var txtDamage1:TextField;
		public var txtDamage2:TextField;
		public var txtDamage3:TextField;
		public var txtSpeed1:TextField;
		public var txtSpeed2:TextField;
		public var txtSpeed3:TextField;
		public var txtDrag1:TextField;
		public var txtDrag2:TextField;
		public var txtDrag3:TextField;
		public var txtCheaper1:TextField;
		public var txtCheaper2:TextField;
		public var txtCheaper3:TextField;
		public var txtRP1:TextField;
		public var txtRP2:TextField;
		public var txtRP3:TextField;
		
		public var txtRP:TextField;//Actual RP amount
		
		
		
		protected const HIDDEN_Y:Number = 800;
		protected const SHOWN_Y:Number = 0;
		protected const FRAME_IN_ANIM:uint = 20;
		protected var _counter:int = 0;
		
		protected var _container:DisplayObjectContainer;
		
		
		public function ResearchScreen(container:DisplayObjectContainer) 
		{
			super();
			_container = container;
			y = HIDDEN_Y;
			_counter = 0;
			updateStats();
			updateButtons();
		}
		
		protected function setup():void {
			y = HIDDEN_Y;
			
			btnBack.addEventListener(MouseEvent.CLICK, click);
			
			btnDamageMult.addEventListener(MouseEvent.CLICK, damageMultClick);
			btnSpeedDamage.addEventListener(MouseEvent.CLICK, speedDamageClick);
			btnDrag.addEventListener(MouseEvent.CLICK, dragClick);
			btnCheaperUpgrades.addEventListener(MouseEvent.CLICK, cheaperClick);
			btnMoreRP.addEventListener(MouseEvent.CLICK, moreRpClick);
			
			btnDamageMult.addEventListener(MouseEvent.ROLL_OVER, damageMultOver);
			btnSpeedDamage.addEventListener(MouseEvent.ROLL_OVER, speedDamageOver);
			btnDrag.addEventListener(MouseEvent.ROLL_OVER, dragOver);
			btnCheaperUpgrades.addEventListener(MouseEvent.ROLL_OVER, cheaperOver);
			btnMoreRP.addEventListener(MouseEvent.ROLL_OVER, moreRpOver);
			
			btnDamageMult.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnSpeedDamage.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnDrag.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnCheaperUpgrades.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnMoreRP.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			btnDamageMultOver.addEventListener(MouseEvent.CLICK, damageMultClick);
			btnSpeedDamageOver.addEventListener(MouseEvent.CLICK, speedDamageClick);
			btnDragOver.addEventListener(MouseEvent.CLICK, dragClick);
			btnCheaperUpgradesOver.addEventListener(MouseEvent.CLICK, cheaperClick);
			btnMoreRPOver.addEventListener(MouseEvent.CLICK, moreRpClick);
			
			btnDamageMultOver.addEventListener(MouseEvent.ROLL_OVER, damageMultOver);
			btnSpeedDamageOver.addEventListener(MouseEvent.ROLL_OVER, speedDamageOver);
			btnDragOver.addEventListener(MouseEvent.ROLL_OVER, dragOver);
			btnCheaperUpgradesOver.addEventListener(MouseEvent.ROLL_OVER, cheaperOver);
			btnMoreRPOver.addEventListener(MouseEvent.ROLL_OVER, moreRpOver);
			
			btnDamageMultOver.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnSpeedDamageOver.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnDragOver.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnCheaperUpgradesOver.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnMoreRPOver.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			
			Research.rpUpdateSignal.add(updateRp);
			
		}
		
		private function rollOut(e:MouseEvent):void 
		{
			updateStats();
		}
		
		private function damageMultOver(e:MouseEvent):void 
		{
			if (e != null) {
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 0);
				tt.show(this, "Damage Multiplier", "Increase your base damage");
			}
			
			txtDamage2.textColor = 0x009900;
			txtDamage2.text = "+" + getDamageString(1) + " damage";
		}
		
		private function speedDamageOver(e:MouseEvent):void 
		{
			if (e != null) {
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 0);
				tt.show(this, "Bullet Travel Speed", "Increase how fast bullets move (does not affect range)");
			}
			
			txtSpeed2.textColor = 0x009900;
			txtSpeed2.text = "+" + getSpeedDamageString(1) + " projectile travel speed";
		}
		
		private function dragOver(e:MouseEvent):void 
		{
			if (e != null) {
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 0);
				tt.show(this, "Space Folding", "Reduce the distance between you and your target");
			}
			
			txtDrag2.textColor = 0x009900;
			txtDrag2.text = getDragString(1) + " closer objects";
		}
		
		private function cheaperOver(e:MouseEvent):void 
		{
			if (e != null) {
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 0);
				tt.show(this, "Upgrade Cost Reduction", "Reduce the cost of basic upgrades (does not affect research)");
			}
			
			txtCheaper2.textColor = 0x009900;
			txtCheaper2.text = getCheaperUpgradesString(1) + " reduced upgrades money cost";
		}
		
		private function moreRpOver(e:MouseEvent):void 
		{
			if (e != null) {
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 0);
				tt.show(this, "Faster Research Points", "Increase the rate at which you get Research Points");
			}
			
			txtRP2.textColor = 0x009900;
			txtRP2.text = "+" + getMoreRpString(1) + " research points gain";
		}
		
		protected function cleanup():void {
			btnBack.removeEventListener(MouseEvent.CLICK, click);
			
			btnDamageMult.removeEventListener(MouseEvent.CLICK, damageMultClick);
			btnSpeedDamage.removeEventListener(MouseEvent.CLICK, speedDamageClick);
			btnDrag.removeEventListener(MouseEvent.CLICK, dragClick);
			btnCheaperUpgrades.removeEventListener(MouseEvent.CLICK, cheaperClick);
			btnMoreRP.removeEventListener(MouseEvent.CLICK, moreRpClick);
			
			btnDamageMult.removeEventListener(MouseEvent.ROLL_OVER, damageMultOver);
			btnSpeedDamage.removeEventListener(MouseEvent.ROLL_OVER, speedDamageOver);
			btnDrag.removeEventListener(MouseEvent.ROLL_OVER, dragOver);
			btnCheaperUpgrades.removeEventListener(MouseEvent.ROLL_OVER, cheaperOver);
			btnMoreRP.removeEventListener(MouseEvent.ROLL_OVER, moreRpOver);
			
			btnDamageMult.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnSpeedDamage.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnDrag.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnCheaperUpgrades.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnMoreRP.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			btnDamageMultOver.removeEventListener(MouseEvent.CLICK, damageMultClick);
			btnSpeedDamageOver.removeEventListener(MouseEvent.CLICK, speedDamageClick);
			btnDragOver.removeEventListener(MouseEvent.CLICK, dragClick);
			btnCheaperUpgradesOver.removeEventListener(MouseEvent.CLICK, cheaperClick);
			btnMoreRPOver.removeEventListener(MouseEvent.CLICK, moreRpClick);
			
			btnDamageMultOver.removeEventListener(MouseEvent.ROLL_OVER, damageMultOver);
			btnSpeedDamageOver.removeEventListener(MouseEvent.ROLL_OVER, speedDamageOver);
			btnDragOver.removeEventListener(MouseEvent.ROLL_OVER, dragOver);
			btnCheaperUpgradesOver.removeEventListener(MouseEvent.ROLL_OVER, cheaperOver);
			btnMoreRPOver.removeEventListener(MouseEvent.ROLL_OVER, moreRpOver);
			
			btnDamageMultOver.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnSpeedDamageOver.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnDragOver.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnCheaperUpgradesOver.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnMoreRPOver.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			
			
			Research.rpUpdateSignal.remove(updateRp);
		}
		
		private function damageMultClick(e:MouseEvent):void 
		{
			Research.buyDamage();
			updateStats();
			damageMultOver(null);
		}
		
		private function speedDamageClick(e:MouseEvent):void 
		{
			Research.buySpeedDamage();
			updateStats();
			speedDamageOver(null);
		}
		
		private function dragClick(e:MouseEvent):void 
		{
			Research.buyDragReduction();
			updateStats();
			dragOver(null);
		}
		
		private function cheaperClick(e:MouseEvent):void 
		{
			Research.buyCheaperUpgrades();
			updateStats();
			cheaperOver(null);
		}
		
		private function moreRpClick(e:MouseEvent):void 
		{
			Research.buyMoreRP();
			updateStats();
			moreRpOver(null);
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
			updateStats();
			updateButtons();
			_counter = 0;
			Main.phase1.add(tickShow);
		}
		
		public function hide():void {
			Main.phase1.remove(tickShow);
			GameEngine.launcher.enableMouse();
			cleanup();
			mouseBlock.visible = false;
			_counter = 0;
			Main.phase1.add(tickHide);
		}
		
		public function updateStats():void {
			txtDamage1.text = "Damage Multiplier lvl " + Research.damageLevel;
			txtDamage2.text = "+" + getDamageString() + " damage";
			txtDamage3.text = Research.getDamageCost(1) + " RP to next level";
			txtSpeed1.text = "Bullet Travel Speed lvl " + Research.speedDamageLevel;
			txtSpeed2.text = "+" + getSpeedDamageString() + " projectile travel speed";
			txtSpeed3.text = Research.getSpeedDamageCost(1) + " RP to next level";
			txtDrag1.text = "Space Folding lvl " + Research.dragReductionLevel;
			txtDrag2.text = getDragString() + " closer objects";
			txtDrag3.text = Research.getDragReductionCost(1) + " RP to next level";
			txtCheaper1.text = "Upgrade Cost Reduction lvl " + Research.cheaperUpgradesLevel;
			txtCheaper2.text = getCheaperUpgradesString() + " reduced upgrades money cost";
			txtCheaper3.text = Research.getCheaperUpgradesCost(1) + " RP to next level";
			txtRP1.text = "Faster Research Points lvl " + Research.moreRPLevel;
			txtRP2.text = "+" + getMoreRpString() + " research points gain";
			txtRP3.text = Research.getMoreRPCost(1) + " RP to next level";
			
			txtDamage2.textColor = 0x000000;
			txtSpeed2.textColor = 0x000000;
			txtDrag2.textColor = 0x000000;
			txtCheaper2.textColor = 0x000000;
			txtRP2.textColor = 0x000000;
			
			btnDamageMultOver.visible = false;
			btnSpeedDamageOver.visible = false;
			btnDragOver.visible = false;
			btnCheaperUpgradesOver.visible = false;
			btnMoreRPOver.visible = false;
			
			txtRP.text = Research.researchPoints.toFormattedString(6, 1);
			
			if (Research.damageLevel >= 10 &&
			Research.speedDamageLevel >= 10 &&
			Research.dragReductionLevel >= 10 &&
			Research.cheaperUpgradesLevel >= 10 &&
			Research.moreRPLevel >= 10) {
				Achievements.setEveryResearchAt10();
			}
			if (Research.damageLevel >= 11 ||
			Research.speedDamageLevel >= 11 ||
			Research.dragReductionLevel >= 11 ||
			Research.cheaperUpgradesLevel >= 11 ||
			Research.moreRPLevel >= 11) {
				Achievements.setOverResearch();
			}
		}
		
		protected function getDamageString(offset:int = 0):String {
			return String(NumberUtils.setPrecison((Research.getDamage(offset) * 100 - 100),2) + "%")
		}
		
		protected function getSpeedDamageString(offset:int = 0):String {
			return String(NumberUtils.setPrecison((Research.getSpeedDamage(offset) * 100 - 100),2) + "%")
		}
		
		protected function getDragString(offset:int = 0):String {
			return String(NumberUtils.setPrecison(((1 - Research.getDragReduction(offset)) * 100), 2) + "%");
		}
		
		protected function getCheaperUpgradesString(offset:int = 0):String {
			return String(NumberUtils.setPrecison(((1 - Research.getCheaperUpgrades(offset)) * 100), 2) + "%");
		}
		
		protected function getMoreRpString(offset:int = 0):String {
			return String(NumberUtils.setPrecison((Research.getMoreRP(offset) * 100 - 100), 2) + "%");
		}
		
		protected function updateRp(str:String):void {
			txtRP.text = str;
			updateButtons();
		}
		
		protected function updateButtons():void {
			if (Research.researchPoints.isGreaterThanEqualTo(Research.getDamageCost(1).toFixed())) {
				if (Research.damageLevel >= 100) {
					btnDamageMult.visible = false;
					btnDamageMultOver.visible = false;
				}else if (Research.damageLevel >= 10) {
					btnDamageMult.visible = false;
					btnDamageMultOver.visible = true;
				}else {
					btnDamageMult.visible = true;
					btnDamageMultOver.visible = false;
				}
			}else {
					btnDamageMult.visible = false;
					btnDamageMultOver.visible = false;
			}
			
			if (Research.researchPoints.isGreaterThanEqualTo(Research.getSpeedDamageCost(1).toFixed())) {
				if (Research.speedDamageLevel >= 100) {
					btnSpeedDamage.visible = false;
					btnSpeedDamageOver.visible = false;
				}else if (Research.speedDamageLevel >= 10) {
					btnSpeedDamage.visible = false;
					btnSpeedDamageOver.visible = true;
				}else {
					btnSpeedDamage.visible = true;
					btnSpeedDamageOver.visible = false;
				}
			}else {
					btnSpeedDamage.visible = false;
					btnSpeedDamageOver.visible = false;
			}
			
			if (Research.researchPoints.isGreaterThanEqualTo(Research.getDragReductionCost(1).toFixed())) {
				if (Research.dragReductionLevel >= 100) {
					btnDrag.visible = false;
					btnDragOver.visible = false;
				}else if (Research.dragReductionLevel >= 10) {
					btnDrag.visible = false;
					btnDragOver.visible = true;
				}else {
					btnDrag.visible = true;
					btnDragOver.visible = false;
				}
			}else {
					btnDrag.visible = false;
					btnDragOver.visible = false;
			}
			
			if (Research.researchPoints.isGreaterThanEqualTo(Research.getCheaperUpgradesCost(1).toFixed())) {
				if (Research.cheaperUpgradesLevel >= 100) {
					btnCheaperUpgrades.visible = false;
					btnCheaperUpgradesOver.visible = false;
				}else if (Research.cheaperUpgradesLevel >= 10) {
					btnCheaperUpgrades.visible = false;
					btnCheaperUpgradesOver.visible = true;
				}else {
					btnCheaperUpgrades.visible = true;
					btnCheaperUpgradesOver.visible = false;
				}
			}else {
					btnCheaperUpgrades.visible = false;
					btnCheaperUpgradesOver.visible = false;
			}
			
			if (Research.researchPoints.isGreaterThanEqualTo(Research.getMoreRPCost(1).toFixed())) {
				if (Research.moreRPLevel >= 100) {
					btnMoreRP.visible = false;
					btnMoreRPOver.visible = false;
				}else if (Research.moreRPLevel >= 10) {
					btnMoreRP.visible = false;
					btnMoreRPOver.visible = true;
				}else {
					btnMoreRP.visible = true;
					btnMoreRPOver.visible = false;
				}
			}else {
					btnMoreRP.visible = false;
					btnMoreRPOver.visible = false;
			}
			
			
			btnDamageMultOver.visible = false;
			btnSpeedDamageOver.visible = false;
			btnDragOver.visible = false;
			btnCheaperUpgradesOver.visible = false;
			btnMoreRPOver.visible = false;
		}
		
	}

}