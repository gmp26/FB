package org.maths.FB.views
{
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class CompletedLevelsMediator extends Mediator
	{
		[Inject]
		public var levels:CompletedLevels;
		
		public function CompletedLevelsMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			levels.homeButton.addEventListener(MouseEvent.CLICK, home);
			levels.introButton.addEventListener(MouseEvent.CLICK, intro);
			levels.level1Button.addEventListener(MouseEvent.CLICK, level1);
		}
		
		override public function onRemove():void
		{
			levels.homeButton.removeEventListener(MouseEvent.CLICK, home);
			levels.introButton.removeEventListener(MouseEvent.CLICK, intro);
			levels.level1Button.removeEventListener(MouseEvent.CLICK, level1);
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