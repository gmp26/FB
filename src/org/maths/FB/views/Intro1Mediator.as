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
	
	public class Intro1Mediator extends AbstractLevelMediator
	{
		[Inject]
		public var intro1:Intro1;
					
		public function Intro1Mediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			// inject common components into AbstractMediator
			level = intro1;
			content = intro1._content;
			backButton = intro1._backButton;
			skipButton = intro1._skipButton;
			checkButton = intro1._checkButton;
			nextButton = intro1._nextButton;
			tryAgainButton = intro1._tryAgainButton;
			
			intro1.h1.addEventListener(MouseEvent.CLICK, headerClicked);
			intro1.h2.addEventListener(MouseEvent.CLICK, headerClicked);
			intro1.product.addEventListener(MouseEvent.CLICK, productClicked);

			super.onRegister();
		}
		
		override public function onRemove():void
		{
			intro1.h1.removeEventListener(MouseEvent.CLICK, headerClicked);
			intro1.h2.removeEventListener(MouseEvent.CLICK, headerClicked);
			intro1.product.removeEventListener(MouseEvent.CLICK, productClicked);

			super.onRemove();
		}
		
		override protected function enableAll():void
		{
			intro1.h1.enabled = true;
			intro1.h2.enabled = true;
			intro1.product.enabled = true;

			super.enableAll();
		}
		
		override protected function disableAll():void
		{
			intro1.h1.enabled = false;
			intro1.h2.enabled = false;
			intro1.product.enabled = false;

			super.disableAll();
		}
	
		override protected function get isComplete():Boolean
		{
			return (intro1.h1.label != "?" && intro1.h2.label != "?" && intro1.product.selected);
		}
		
		override protected function get isCorrect():Boolean
		{
			return (intro1.h1.label == "7" && intro1.h2.label == "7");
		}
		
		override protected function nextScreen(event:Event):void
		{
			level.navigator.pushView(Intro2);			
		}
	}
}