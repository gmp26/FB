package org.maths.FB.views
{
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import org.maths.FB.components.Picker;
	import org.maths.FB.models.AppState;
	import org.robotlegs.mvcs.Mediator;
	
	public class IntroductionMediator extends Mediator
	{
		[Inject]
		public var introduction:Introduction;
		
		[Inject]
		public var appState:AppState;
		
		public function IntroductionMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			introduction.skipButton.addEventListener(MouseEvent.CLICK, startGame);
			introduction.showMeButton.addEventListener(MouseEvent.CLICK, showMe);
		}
		
		override public function onRemove():void
		{
			introduction.skipButton.removeEventListener(MouseEvent.CLICK, startGame);
			introduction.showMeButton.addEventListener(MouseEvent.CLICK, showMe);
		}
		
		
		private function startGame(event:MouseEvent):void
		{
			introduction.navigator.pushView(Home);
		}
		
		private function showMe(event:MouseEvent):void
		{
			var delay:int = 1000;
			var picker:Picker = introduction.picker;
			
			picker.visible = true;
			setTimeout(function():void {
				picker.highlight("b12", true);
				setTimeout(function():void {
					picker.highlight("b12", false);
					picker.visible=false;
				}, delay);
			}, delay);
		}
	}
}