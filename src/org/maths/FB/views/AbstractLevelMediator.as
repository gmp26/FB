package org.maths.FB.views
{
	import com.tweenman.TweenMan;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.setTimeout;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.components.Picker;
	import org.maths.FB.components.Tick;
	import org.maths.FB.components.TouchFlare;
	import org.maths.FB.models.AppState;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	import spark.components.supportClasses.GroupBase;
	
	public class AbstractLevelMediator extends Mediator
	{

		public var level:AbstractLevel;
		
		// genereic names for components found in individual screens
		public var blur:BlurFilter = new BlurFilter(4,4,2);
		
		public var content:GroupBase;
		public var skipButton:Button
		public var checkButton:Button;
		public var tryAgainButton:Button;
		public var nextButton:Button;
		
		public function AbstractLevelMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			skipButton.addEventListener(MouseEvent.CLICK, startGame);
			checkButton.addEventListener(MouseEvent.CLICK, check);
			tryAgainButton.addEventListener(MouseEvent.CLICK, tryAgain);
			nextButton.addEventListener(MouseEvent.CLICK, nextScreen);
			
			enableAll();
		}
		
		override public function onRemove():void
		{
			skipButton.removeEventListener(MouseEvent.CLICK, startGame);
			checkButton.removeEventListener(MouseEvent.CLICK, check);
			tryAgainButton.removeEventListener(MouseEvent.CLICK, tryAgain);
			nextButton.removeEventListener(MouseEvent.CLICK, nextScreen);
			
			disableAll();
		}
		
		protected function enableAll():void
		{
			content.filters = [];
			tryAgainButton.visible = false;
			nextButton.visible = false;
		}
		
		protected function disableAll():void
		{
			content.filters = [blur];
		}
		
		protected function startGame(event:MouseEvent):void
		{
			level.navigator.pushView(Home);
		}
		
		/*
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
						level.removeElement(picker);
						level.content.filters = [];
						endGame();
					}});					
				});
			}
			picker.percentWidth=0;
			picker.percentHeight=0;
			TweenMan.addTween(picker, {time:0.3, percentWidth:80, percentHeight:80});

			picker.horizontalCenter=0;
			picker.verticalCenter=0;
			level.addElement(picker);
			level.content.filters = [level.blur];
		}
		
		private function endGame(event:MouseEvent = null):void
		{
			if(level.h1.label != "?" && level.h2.label != "?" && level.product.selected)
				TweenMan.addTween(level.checkButton, {time:0.3, bottom:0});
			else
				TweenMan.addTween(level.checkButton, {time:0.3, bottom:-90});
		}
		*/
		
		protected function get isCorrect():Boolean
		{
			return true;
		}
		
		protected function check(event:MouseEvent):void
		{
			disableAll();
			TweenMan.addTween(checkButton, {time:0.3, bottom:-90});
			if(isCorrect) {
				nextButton.visible = true;
				tryAgainButton.visible = false;
			}
			else {
				nextButton.visible = false;
				tryAgainButton.visible = true;
			}
		}
		
		protected function nextScreen(event:Event):void
		{
			enableAll();
			level.navigator.pushView(Home);			
		}
		
		private function tryAgain(event:MouseEvent):void
		{
			enableAll();
		}
		
		protected function get isPortrait():Boolean
		{
			return (stageHeight > stageWidth) ? true : false;
		}
		
		protected function get stageHeight():int
		{
			return level.stage.stageHeight;
		}
		
		protected function get stageWidth():int
		{
			return level.stage.stageWidth;
		}

	}
}