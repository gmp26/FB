package org.maths.FB.views
{
	import com.tweenman.TweenMan;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.components.Picker;
	import org.maths.FB.components.Tick;
	import org.maths.FB.components.TouchFlare;
	import org.maths.FB.models.AppState;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	
	public class IntroductionMediator extends AbstractLevelMediator
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
			// inject common components into AbstractMediator
			level = introduction;
			content = introduction._content;
			skipButton = introduction._skipButton;
			checkButton = introduction._checkButton;
			nextButton = introduction._nextButton;
			tryAgainButton = introduction._tryAgainButton;
			
			
			introduction.h1.addEventListener(MouseEvent.CLICK, headerClicked);
			introduction.h2.addEventListener(MouseEvent.CLICK, headerClicked);
			introduction.product.addEventListener(MouseEvent.CLICK, endGame);

			super.onRegister();
		}
		
		override public function onRemove():void
		{
			introduction.h1.removeEventListener(MouseEvent.CLICK, headerClicked);
			introduction.h2.removeEventListener(MouseEvent.CLICK, headerClicked);
			introduction.product.removeEventListener(MouseEvent.CLICK, endGame);

			super.onRemove();
		}
		
		override protected function enableAll():void
		{
			introduction.h1.enabled = true;
			introduction.h2.enabled = true;
			introduction.product.enabled = true;

			super.enableAll();
		}
		
		override protected function disableAll():void
		{
			introduction.h1.enabled = true;
			introduction.h2.enabled = true;
			introduction.product.enabled = true;

			super.disableAll();
		}
		
		private function headerClicked(event:MouseEvent):void
		{
			var header:HeaderButton = event.currentTarget as HeaderButton;
			var picker:Picker = new Picker();
			for(var i:int = 1; i <= 12; i++) {
				var button:HeaderButton = new HeaderButton();
				if(i == 1) 
					button.label = "?"
				else
					button.label = i.toString();
				picker.choices.addElement(button);
				var f:Function;
				button.addEventListener(MouseEvent.CLICK, f = function(event:MouseEvent):void {
					button.removeEventListener(MouseEvent.CLICK, f);
					var b:HeaderButton = event.currentTarget as HeaderButton;
					var number:int = parseInt(b.label);
					header.label = isNaN(number) ? "?" : number.toString();
					TweenMan.addTween(picker, {time:0.3, percentWidth:0, percentHeight:0, onComplete:function():void {
						introduction.removeElement(picker);
						content.filters = [];
						endGame();
					}});					
				});
			}
			picker.percentWidth=0;
			picker.percentHeight=0;
			TweenMan.addTween(picker, {time:0.3, percentWidth:80, percentHeight:80});

			picker.horizontalCenter=0;
			picker.verticalCenter=0;
			introduction.addElement(picker);
			content.filters = [blur];
		}
		
		private function endGame(event:MouseEvent = null):void
		{
			if(introduction.h1.label != "?" && introduction.h2.label != "?" && introduction.product.selected)
				TweenMan.addTween(checkButton, {time:0.3, bottom:0});
			else
				TweenMan.addTween(checkButton, {time:0.3, bottom:-90});
		}
		
		override protected function get isCorrect():Boolean
		{
			return (introduction.h1.label == "7" && introduction.h2.label == "7");
		}
	}
}