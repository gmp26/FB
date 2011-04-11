package org.maths.FB.views
{
	import flash.events.MouseEvent;
	
	import mx.events.ResizeEvent;
	
	import org.maths.FB.components.SadTick;
	import org.maths.FB.components.Tick;
	import org.maths.FB.models.AppState;
	import org.maths.FB.models.Scores;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	
	public class CompletedLevelsMediator extends Mediator
	{
		[Inject]
		public var levels:CompletedLevels;
		
		[Inject]
		public var scores:Scores;
		
		public function CompletedLevelsMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			levels.addEventListener(ResizeEvent.RESIZE, relayout);
			
			levels.homeButton.addEventListener(MouseEvent.CLICK, home);
			levels.introButton.addEventListener(MouseEvent.CLICK, intro);
			levels.level1Button.addEventListener(MouseEvent.CLICK, level1);
			
			var completedLevels:Vector.<String> = scores.completedLevels();
			var len:int = completedLevels.length;
			for(var i:int = 0; i < len; i++) {
				var levelName:String = completedLevels[i];
				var score:int = scores.getScore(levelName);
				var b:Button = levels[levelName + "Button"];
				if(score == 0) {
					b.icon = Tick;
					b.label = levelName;
				}
				else {
					b.icon = SadTick;
					b.label = levelName + " " + score + " penalties";
				}
			}
			
			relayout();
		}
		
		override public function onRemove():void
		{
			levels.homeButton.removeEventListener(MouseEvent.CLICK, home);
			levels.introButton.removeEventListener(MouseEvent.CLICK, intro);
			levels.level1Button.removeEventListener(MouseEvent.CLICK, level1);
		}
		
		private function relayout(event:ResizeEvent = null):void
		{
			if(levels.width > levels.height) {
				levels.levels.requestedColumnCount = 2;
			}
			else {
				levels.levels.requestedColumnCount = 1;
			}
		}
		
		private function home(event:MouseEvent):void
		{
			levels.navigator.popToFirstView();
		}
		
		private function intro(event:MouseEvent):void
		{
			levels.navigator.pushView(Intro1);
		}

		private function level1(event:MouseEvent):void
		{
			levels.navigator.pushView(Level1);
		}
	}
}