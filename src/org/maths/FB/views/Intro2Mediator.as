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
	import spark.components.Label;
	
	public class Intro2Mediator extends AbstractLevelMediator
	{
		[Inject]
		public var intro2:Intro2;
					
		public function Intro2Mediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			// inject common components into AbstractMediator
			level = intro2;
			content = intro2._content;
			backButton = intro2._backButton;
			skipButton = intro2._skipButton;
			checkButton = intro2._checkButton;
			nextButton = intro2._nextButton;
			tryAgainButton = intro2._tryAgainButton;
			
			/*
			intro2.h1.addEventListener(MouseEvent.CLICK, headerClicked);
			intro2.h2.addEventListener(MouseEvent.CLICK, headerClicked);
			intro2.product.addEventListener(MouseEvent.CLICK, productClicked);
			*/
			super.onRegister();
			
			newProblem();
		}
		
		override public function onRemove():void
		{
			/*
			intro2.h1.removeEventListener(MouseEvent.CLICK, headerClicked);
			intro2.h2.removeEventListener(MouseEvent.CLICK, headerClicked);
			intro2.product.removeEventListener(MouseEvent.CLICK, productClicked);
			*/
			super.onRemove();
		}
		
		override protected function enableAll():void
		{
			/*
			intro2.h1.enabled = true;
			intro2.h2.enabled = true;
			intro2.product.enabled = true;
			*/
			super.enableAll();
		}
		
		override protected function disableAll():void
		{
			/*
			intro2.h1.enabled = false;
			intro2.h2.enabled = false;
			intro2.product.enabled = false;
			*/
			super.disableAll();
		}
		
		override protected function get isComplete():Boolean
		{
			return false;
		}
		
		
		override protected function get isCorrect():Boolean
		{
			return true;
		}
		
		override protected function nextScreen(event:Event):void
		{
			level.navigator.pushView(Home);			
		}
		
		private function newHeader(value:int):HeaderButton
		{
			var h:HeaderButton = new HeaderButton();
			h.label = "?";
			h.value = value;
			
			return h;
		}
		
		private function newProblem():void
		{
			intro2.rowHeader.addElement(newHeader(3));		
			intro2.rowHeader.addElement(newHeader(2));		
			intro2.rowHeader.addElement(newHeader(1));		
			intro2.rowHeader.addElement(newHeader(0));		
		}
	}
}