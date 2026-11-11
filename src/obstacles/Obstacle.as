package src.obstacles 
{
	import flash.display.MovieClip;
	import lbg.datatypes.BigUint;
	import lbg.utils.DisplayObjectUtil;
	import src.Achievements;
	import src.bullet.AbstractBullet;
	import src.CashPerSecond;
	import src.DamagePerSecond;
	import src.GameEngine;
	import src.Main;
	import src.Menu;
	import src.obstacles.ObstacleListEntry;
	
	/**
	 * ...
	 * @author 
	 */
	public class Obstacle extends MovieClip 
	{
		protected var _tintMult:Number = 0;
		
		public var maxHp:String;
		public var hp:BigUint;
		public var reward:String;
		public var defense:String;
		protected var _entry:ObstacleListEntry;
		
		public function Obstacle(entry:ObstacleListEntry) 
		{
			Main.phase1.add(tick);
			hp = new BigUint(entry.hp.toString());
			maxHp = entry.maxHp.toString();
			reward = entry.reward;
			defense = entry.defense;
			_entry = entry;
			
			var visual:MovieClip = new entry.className();
			addChild(visual);
			
			if (visual.totalFrames == 2) {
				visual.gotoAndStop(1);
			}
		}
		
		public function hit(bullet:AbstractBullet):void {
			_tintMult = 0.3;
			
			hp.substract(bullet.getTotalDamage());
			_entry.hp.setValue(hp.toString());
			
			var damageDealt:Number = Math.min(Number(bullet.getTotalDamage()), Number(_entry.maxHp));
			DamagePerSecond.addEntry(damageDealt);
			CashPerSecond.addHit(Number(reward),damageDealt,Number(maxHp))
			
			if (hp.isLessThanEqualTo("0")) {
				die();
			}
			
			Menu.instance.updateObstacleHp(hp.toFormattedString());
		}
		
		public function die():void {
			GameEngine.addCash(reward);
			_entry.addKill();
			GameEngine.menu.updateObstacle(_entry);
			hp.setValue(maxHp);
			_entry.hp.setValue(hp.toString());
			Achievements.setBestObstacleKilled(GameEngine.currentObstacleLevel + 1);
			Achievements.addObstacleKill();
			GameEngine.menu.updateObstacleButtons(GameEngine.currentObstacleLevel);
		}
		
		protected function tick(delta:Number):void {
			if (_tintMult == 0) {
				return;
			}else if (_tintMult <= 0.01) {
				_tintMult = 0;
			}else {
				_tintMult *= 1 - (0.15 * delta);
			}
			DisplayObjectUtil.setObjectTint(this, 0xFF0000, _tintMult);
		}
		
	}

}