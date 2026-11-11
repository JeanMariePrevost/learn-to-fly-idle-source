package src 
{
	import com.hurlant.math.BigInteger;
	import com.hybrid.ui.ToolTip;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import lbg.datatypes.BigUint;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.obstacles.ObstacleListEntry;
	import src.obstacles.ObstaclesList;
	import src.upgrades.UpgradeEntry;
	import src.upgrades.Upgrades;
	
	/**
	 * ...
	 * @author 
	 */
	public class Menu extends MovieClip 
	{
		public const ICON_HEIGHT:Number = 75 - 30;
		public const ICON_WIDTH:Number = 84 - 30;
		
		public static var instance:Menu;
		
		public var btnLaunchingPower:SimpleButton;
		public var btnBaseDamage:SimpleButton;
		public var btnMaxShots:SimpleButton;
		public var btnAutoFire:SimpleButton;
		
		public var txtLaunchingPower:TextField;
		public var txtBaseDamage:TextField;
		public var txtMaxShots:TextField;
		public var txtAutoFire:TextField;
		
		public var txtCash:TextField;
		public var txtCost:TextField;
		public var txtRP:TextField;
		public var txtCashPerSecond:TextField;
		
		public var txtObstacle:TextField;
		public var txtCurrentHp:TextField;
		public var txtDistance:TextField;
		public var txtWorth:TextField;
		public var txtKills:TextField;
		
		public var txtStat1:TextField;
		public var txtStat2:TextField;
		public var txtStat3:TextField;
		public var txtStat4:TextField;
		public var txtStat5:TextField;
		public var txtStat6:TextField;
		
		public var btnPrevious:SimpleButton;
		public var btnNext:SimpleButton;
		public var icon:MovieClip;
		public var iconChild:MovieClip;
		
		public var btnShop:SimpleButton;
		public var btnShopGrey:SimpleButton;
		public var btnAchievements:SimpleButton;
		public var researchStar:MovieClip;
		
		public var btnStats:SimpleButton;
		public var btnFireToggle:SimpleButton;
		
		public var currentEntry:ObstacleListEntry;
		
		protected var _researchScreen:ResearchScreen;
		protected var _achievementScreen:AchievementScreen;
		
		public function Menu() 
		{
			instance = this;
			
			gotoAndStop(1);
			DisplayObjectUtil.setObjectSaturation(btnStats, 0, 0.5);
			
			btnLaunchingPower.addEventListener(MouseEvent.ROLL_OVER, launchingPowerOver);
			btnLaunchingPower.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnLaunchingPower.addEventListener(MouseEvent.CLICK, launchingPowerClick);
			
			btnBaseDamage.addEventListener(MouseEvent.ROLL_OVER, damageOver);
			btnBaseDamage.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnBaseDamage.addEventListener(MouseEvent.CLICK, damageClick);
			
			btnMaxShots.addEventListener(MouseEvent.ROLL_OVER, maxShotsOver);
			btnMaxShots.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnMaxShots.addEventListener(MouseEvent.CLICK, maxShotsClick);
			
			btnAutoFire.addEventListener(MouseEvent.ROLL_OVER, autoFireOver);
			btnAutoFire.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			btnAutoFire.addEventListener(MouseEvent.CLICK, autoFireClick);
			
			btnPrevious.addEventListener(MouseEvent.CLICK, previousClick);
			btnNext.addEventListener(MouseEvent.CLICK, nextClick);
			
			btnShop.addEventListener(MouseEvent.ROLL_OVER, btnShopOver);
			btnShop.addEventListener(MouseEvent.CLICK, btnShopClick);
			btnShopGrey.addEventListener(MouseEvent.ROLL_OVER, btnShopOver);
			btnShopGrey.addEventListener(MouseEvent.CLICK, btnShopClick);
			
			btnAchievements.addEventListener(MouseEvent.ROLL_OVER, btnAchievementsOver);
			btnAchievements.addEventListener(MouseEvent.CLICK, btnAchievementsClick);
			
			btnStats.addEventListener(MouseEvent.CLICK, btnStatsClick);
			btnFireToggle.addEventListener(MouseEvent.CLICK, btnFireToggleClick);
			
			Research.rpUpdateSignal.add(rpUpdate);
			
			rpUpdate();
		}
		
		private function btnFireToggleClick(e:MouseEvent):void 
		{
			GameEngine.autoFireEnabled = !GameEngine.autoFireEnabled;
			if (GameEngine.autoFireEnabled) {
				DisplayObjectUtil.setObjectSaturation(btnFireToggle, 1, 1);
			}else {
				DisplayObjectUtil.setObjectSaturation(btnFireToggle, 0, 0.5);
			}
		}
		
		private function btnStatsClick(e:MouseEvent):void 
		{
			if (currentFrame != 1) {
				DisplayObjectUtil.setObjectSaturation(btnStats, 0, 0.5);
				gotoAndStop(1);
			}else {
				DisplayObjectUtil.setObjectSaturation(btnStats, 1, 1);
				gotoAndStop(2);
			}
		}
		
		public function rpUpdate(rpString:String = null):void 
		{
			if (rpString == null) {
				rpString = Research.researchPoints.toFormattedString(6, 1);
			}
			txtRP.text = rpString + " Research Points";
			if (Research.isAnythingBuyable()) {
				btnShop.visible = true;
				btnShopGrey.visible = false;
			}else {
				btnShop.visible = false;
				btnShopGrey.visible = true;
			}
		}
		
		protected function btnAchievementsClick(e:MouseEvent):void 
		{
			GameEngine.launcher.disableMouse();
			if (_achievementScreen == null) {
				_achievementScreen = new AchievementScreen(stage);
			}
			_achievementScreen.show();
		}
		
		protected function btnAchievementsOver(e:MouseEvent):void 
		{
			var tt:ToolTip = new ToolTip();
			tt.autoSize = true;
			tt.align = "center";
			tt.offsetPosition(0, 95);
			tt.show(this, "Achievements", "Complete challenges and earn special rewards");
		}
		
		protected function btnShopClick(e:MouseEvent):void 
		{
			GameEngine.launcher.disableMouse();
			if (_researchScreen == null) {
				_researchScreen = new ResearchScreen(Main.topLayer);
			}
			_researchScreen.show();
		}
		
		protected function btnShopOver(e:MouseEvent):void 
		{
			var tt:ToolTip = new ToolTip();
			tt.autoSize = true;
			tt.align = "center";
			tt.offsetPosition(0, 95);
			tt.show(this, "Research", "Spend research points on special perks and upgrades");
		}
		
		public function updateCash(cash:String):void {
			txtCash.text = "$ " + cash;
			
			if (GameEngine.cash.isGreaterThanEqualTo(Upgrades.getLaunchPower(GameEngine.launchPowerLevel +1).cost)) {
				DisplayObjectUtil.setObjectSaturation(btnLaunchingPower, 1);
				btnLaunchingPower.enabled = true;
			}else {
				DisplayObjectUtil.setObjectSaturation(btnLaunchingPower, 0);
				btnLaunchingPower.enabled = false;
			}
			if (GameEngine.cash.isGreaterThanEqualTo(Upgrades.getBaseDamage(GameEngine.damageLevel +1).cost)) {
				DisplayObjectUtil.setObjectSaturation(btnBaseDamage, 1);
				btnBaseDamage.enabled = true;
			}else {
				DisplayObjectUtil.setObjectSaturation(btnBaseDamage, 0);
				btnBaseDamage.enabled = false;
			}
			if (GameEngine.cash.isGreaterThanEqualTo(Upgrades.getMaxShots(GameEngine.maxShotsLevel +1).cost)) {
				DisplayObjectUtil.setObjectSaturation(btnMaxShots, 1);
				btnMaxShots.enabled = true;
			}else {
				DisplayObjectUtil.setObjectSaturation(btnMaxShots, 0);
				btnMaxShots.enabled = false;
			}
			if (GameEngine.cash.isGreaterThanEqualTo(Upgrades.getAutoFire(GameEngine.autoFireLevel +1).cost)) {
				DisplayObjectUtil.setObjectSaturation(btnAutoFire, 1);
				btnAutoFire.enabled = true;
			}else {
				DisplayObjectUtil.setObjectSaturation(btnAutoFire, 0);
				btnAutoFire.enabled = false;
			}
		}
		
		public function updateCost(cost:String):void {
			if (cost == "") {
				txtCost.text = "";
			}else if (Number(cost) <= 0 || isNaN(Number(cost))) {
				txtCost.text = "$ " + "0";
			}else {
				var bu:BigUint = new BigUint(cost);
				var trim:uint = GameEngine.cash.value.getFormattedStringTrimLevel(GameEngine.cash.MAX_DIGITS, GameEngine.cash.TRIM_STEP);
				txtCost.text = "$ " + bu.toFormattedString(GameEngine.cash.MAX_DIGITS,GameEngine.cash.TRIM_STEP,trim);
			}
		}
		
		public function updateObstacle(entry:ObstacleListEntry):void {
			currentEntry = entry;
			txtObstacle.text = entry.name;
			txtCurrentHp.text = entry.hp.toFormattedString();
			if (GameEngine.currentlyInSpace) {
				txtDistance.text = (entry.distance * 10).toFixed();
			}else {
				txtDistance.text = entry.distance.toFixed();
			}
			txtWorth.text = new BigUint(entry.reward).toFormattedString(12,3);
			txtKills.text = entry.getKills();
			
			if(iconChild !=null){
				icon.removeChild(iconChild);
			}
			iconChild = new entry.className();
			iconChild.gotoAndStop(1);
			icon.addChild(iconChild);
			var ratio:Number = 1;
			if (iconChild.width >= iconChild.height) {
				ratio = iconChild.height / iconChild.width;
				iconChild.width = ICON_WIDTH;
				iconChild.height = iconChild.width * ratio;
			}else {
				ratio = iconChild.width / iconChild.height;
				iconChild.height = ICON_WIDTH;
				iconChild.width = iconChild.height * ratio;
			}
			
			var rec:Rectangle = iconChild.getBounds(icon);
			iconChild.x -= (rec.left + rec.right) / 2;
			iconChild.y -= (rec.top + rec.bottom) / 2;
			
			updateCashStats();
		}
		
		public function updateCashStats():void {
			var shotsToKill:Number = Math.ceil(currentEntry.maxHp.toNumber() / GameEngine.damage.toNumber());
		}
		
		public function updateObstacleHp(value:String):void {
			txtCurrentHp.text = value;
		}
		
		public function updateStats():void {
			trace("Launch ", GameEngine.launchPowerLevel, " Damage", GameEngine.damageLevel);
			txtLaunchingPower.text = String(GameEngine.launchPower);
			txtBaseDamage.text = new BigUint((GameEngine.damage.toNumber() * Research.getDamage()).toFixed()).toFormattedString(8,1);
			txtMaxShots.text = String(GameEngine.maxShots);
			txtAutoFire.text = (GameEngine.autoFireRate.toNumber() / 3.3).toFixed(1) + "/sec";
			
			txtLaunchingPower.textColor = 0x000000;
			txtBaseDamage.textColor = 0x000000;
			txtMaxShots.textColor = 0x000000;
			txtAutoFire.textColor = 0x000000;
			
			Achievements.setDamageLevel(GameEngine.damageLevel);
			Achievements.setLaunchLevel(GameEngine.launchPowerLevel);
			Achievements.setShotLevel(GameEngine.maxShotsLevel);
			Achievements.setAutoLevel(GameEngine.autoFireLevel);
			
			updateCashStats();
		}
		
		protected function launchingPowerOver(e:MouseEvent):void 
		{
			if(e!=null){
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 95);
				tt.show(this, "Launching Power", "Throw stuff farther");
			}
			
			updateCost(Upgrades.getLaunchPower(GameEngine.launchPowerLevel +1).cost);
			txtLaunchingPower.textColor = 0x009900;
			txtLaunchingPower.text = String(Upgrades.getLaunchPower(GameEngine.launchPowerLevel + 1).stat);
		}
		
		protected function launchingPowerClick(e:MouseEvent):void 
		{
			if ((e.target as SimpleButton).enabled == false) return;
			var entry:UpgradeEntry = Upgrades.getLaunchPower(GameEngine.launchPowerLevel + 1);
			if (GameEngine.cash.isGreaterThanEqualTo(entry.cost)) {
				GameEngine.launchPowerLevel ++;
				GameEngine.launchPower.setValue(entry.stat);
				updateStats();
				
				GameEngine.substractCash(entry.cost);
			}
			launchingPowerOver(null);
		}
		
		protected function damageOver(e:MouseEvent):void 
		{
			if(e!=null){
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 95);
				//tt.bgAlpha = 0.9;
				tt.show(this, "Damage", "Destroy stuff faster");
			}
			
			updateCost(Upgrades.getBaseDamage(GameEngine.damageLevel +1).cost);
			txtBaseDamage.textColor = 0x009900;
			txtBaseDamage.text = new BigUint((Number(Upgrades.getBaseDamage(GameEngine.damageLevel + 1).stat) * Research.getDamage()).toFixed()).toFormattedString(8,1);
		}
		
		protected function damageClick(e:MouseEvent):void 
		{
			var entry:UpgradeEntry = Upgrades.getBaseDamage(GameEngine.damageLevel + 1);
			if (GameEngine.cash.isGreaterThanEqualTo(entry.cost)) {
				GameEngine.damageLevel ++;
				GameEngine.damage.setValue(entry.stat);
				updateStats();
				
				GameEngine.substractCash(entry.cost);
			}
			damageOver(null);
		}
		
		protected function maxShotsOver(e:MouseEvent):void 
		{
			if(e!=null){
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 95);
				tt.show(this, "Max Shots", "Fire more shots at the same time");
			}
			
			updateCost(Upgrades.getMaxShots(GameEngine.maxShotsLevel +1).cost);
			txtMaxShots.textColor = 0x009900;
			txtMaxShots.text = String(Upgrades.getMaxShots(GameEngine.maxShotsLevel + 1).stat);
		}
		
		protected function maxShotsClick(e:MouseEvent):void 
		{
			var entry:UpgradeEntry = Upgrades.getMaxShots(GameEngine.maxShotsLevel + 1);
			if (GameEngine.cash.isGreaterThanEqualTo(entry.cost)) {
				GameEngine.maxShotsLevel ++;
				GameEngine.maxShots.setValue(entry.stat);
				updateStats();
				
				GameEngine.substractCash(entry.cost);
			}
			maxShotsOver(null);
		}
		
		protected function autoFireOver(e:MouseEvent):void 
		{
			if(e!=null){
				var tt:ToolTip = new ToolTip();
				tt.autoSize = true;
				tt.align = "center";
				tt.offsetPosition(0, 95);
				tt.show(this, "Auto-Fire", "Fire without clicking!");
			}
			
			updateCost(Upgrades.getAutoFire(GameEngine.autoFireLevel +1).cost);
			txtAutoFire.textColor = 0x009900;
			txtAutoFire.text = String(Upgrades.getAutoFire(GameEngine.autoFireLevel + 1).stat);
			txtAutoFire.text = (Number(Upgrades.getAutoFire(GameEngine.autoFireLevel + 1).stat) / 3.3).toFixed(1) + "/sec";
		}
		
		protected function autoFireClick(e:MouseEvent):void 
		{
			var entry:UpgradeEntry = Upgrades.getAutoFire(GameEngine.autoFireLevel + 1);
			if (GameEngine.cash.isGreaterThanEqualTo(entry.cost)) {
				GameEngine.autoFireLevel ++;
				GameEngine.autoFireRate.setValue(entry.stat);
				updateStats();
				
				GameEngine.substractCash(entry.cost);
			}
			autoFireOver(null);
		}
		
		protected function rollOut(e:MouseEvent):void {
			updateCost("");
			updateStats();
		}
		
		protected function previousClick(e:MouseEvent):void {
			GameEngine.setObstacle(GameEngine.currentObstacleLevel - 1);
		}
		
		protected function nextClick(e:MouseEvent):void {
			GameEngine.setObstacle(GameEngine.currentObstacleLevel + 1);
		}
		
		public function updateObstacleButtons(obstacleLevel:uint):void {
			if (obstacleLevel <= 0) {
				btnPrevious.visible = false;
			}else {
				btnPrevious.visible = true;
			}
			if (obstacleLevel >= ObstaclesList.obstacleCount - 1 || obstacleLevel >= Achievements._bestObstacle) {
				btnNext.visible = false;
			}else {
				btnNext.visible = true;
			}
		}
		
	}

}