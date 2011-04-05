package org.maths.FB.views
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import org.maths.FB.components.Picker;
	import org.maths.FB.components.TouchFlare;
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
				picker.highlight("b9", true);
				var flare:TouchFlare = new TouchFlare();
				flare.addEventListener(Event.COMPLETE, function(event:Event):void {
					picker.removeElement(flare);
				});
				flare.x = (picker.pos("b9").x + picker.b9.width/2) ;
				flare.y = (picker.pos("b9").y + picker.b9.height/2) ;
				picker.addElement(flare);
				setTimeout(function():void {
					picker.highlight("b9", false);
					picker.visible=false;
				}, delay);
			}, delay);
		}
	}
}