package org.maths.FB.views
{
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class StartScreenMediator extends Mediator
	{
		[Inject]
		public var startScreen:StartScreen;
		
		public function StartScreenMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			startScreen.introButton.addEventListener(MouseEvent.CLICK, intro);
			startScreen.playButton.addEventListener(MouseEvent.CLICK, play);
		}
		
		override public function onRemove():void
		{
			startScreen.introButton.removeEventListener(MouseEvent.CLICK, intro);
			startScreen.playButton.removeEventListener(MouseEvent.CLICK, play);
		}

		private function intro(event:MouseEvent):void
		{
			startScreen.navigator.pushView(Intro1);
		}
	
		private function play(event:MouseEvent):void
		{
			startScreen.navigator.pushView(CompletedLevels);
		}
	}
}