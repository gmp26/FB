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
	import org.maths.FB.models.Analyser;
	import org.maths.FB.models.AppState;
	import org.maths.FB.skins.ToggleCellSkin;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.ToggleButton;
	
	public class Intro2Mediator extends AbstractLevelMediator
	{
		[Inject]
		public var screen:Intro2;
		
		private var analyser:Analyser;
					
		public function Intro2Mediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			
			// inject common components into AbstractMediator
			level = screen;
			content = screen._content;
			backButton = screen._backButton;
			skipButton = screen._skipButton;
			checkButton = screen._checkButton;
			nextButton = screen._nextButton;
			tryAgainButton = screen._tryAgainButton;
			
			/*
			screen.h1.addEventListener(MouseEvent.CLICK, headerClicked);
			screen.h2.addEventListener(MouseEvent.CLICK, headerClicked);
			screen.product.addEventListener(MouseEvent.CLICK, productClicked);
			*/
			super.onRegister();
			
			newProblem();
		}
		
		override public function onRemove():void
		{
			/*
			screen.h1.removeEventListener(MouseEvent.CLICK, headerClicked);
			screen.h2.removeEventListener(MouseEvent.CLICK, headerClicked);
			screen.product.removeEventListener(MouseEvent.CLICK, productClicked);
			*/
			super.onRemove();
		}
		
		override protected function enableAll():void
		{
			/*
			screen.h1.enabled = true;
			screen.h2.enabled = true;
			screen.product.enabled = true;
			*/
			super.enableAll();
		}
		
		override protected function disableAll():void
		{
			/*
			screen.h1.enabled = false;
			screen.h2.enabled = false;
			screen.product.enabled = false;
			*/
			super.disableAll();
		}
		
		override protected function get isComplete():Boolean
		{
			return false;
		}
		
		override protected function endGame(event:MouseEvent=null):void
		{
			if(event != null) {
				var b:ToggleButton = event.currentTarget as ToggleButton;
				var x:int = screen.table.getElementIndex(b);
				var col:int = x % appState.cols;
				var row:int = x / appState.rows;
				analyser.addReveal(row, col, parseInt(b.label));
				analyser.solve();
				analyser.solve();
				screen.unknowns.text = "Unknowns " + (analyser.solve() - appState.rows - appState.cols);
			}
			super.endGame(event);
		}
		
		override protected function get isCorrect():Boolean
		{
			return true;
		}
		
		override protected function nextScreen(event:Event):void
		{
			level.navigator.pushView(Home);			
		}
		
		private function newProblem():void
		{
			screen.colHeader.addElement(newHeader(4));		
			screen.colHeader.addElement(newHeader(3));		
			screen.colHeader.addElement(newHeader(2));		
			screen.colHeader.addElement(newHeader(8));
			
			screen.rowHeader.addElement(newHeader(7));		
			screen.rowHeader.addElement(newHeader(6));		
			screen.rowHeader.addElement(newHeader(5));		
			screen.rowHeader.addElement(newHeader(4));
			
			screen.table.addElement(newProduct(0,0));
			screen.table.addElement(newProduct(0,1));
			screen.table.addElement(newProduct(0,2));
			screen.table.addElement(newProduct(0,3));
			
			screen.table.addElement(newProduct(1,0));
			screen.table.addElement(newProduct(1,1));
			screen.table.addElement(newProduct(1,2));
			screen.table.addElement(newProduct(1,3));
			
			screen.table.addElement(newProduct(2,0));
			screen.table.addElement(newProduct(2,1));
			screen.table.addElement(newProduct(2,2));
			screen.table.addElement(newProduct(2,3));
			
			screen.table.addElement(newProduct(3,0));
			screen.table.addElement(newProduct(3,1));
			screen.table.addElement(newProduct(3,2));
			screen.table.addElement(newProduct(3,3));
			
			// set up the solution analyser
			analyser = new Analyser();
			analyser.setRowRange(4, 2, 12);
			analyser.setColRange(4, 2, 12);
			screen.unknowns.text = "Unknowns " + (analyser.solve() - appState.rows - appState.cols);
		}
		
		private function newHeader(value:int):HeaderButton
		{
			var h:HeaderButton = new HeaderButton();
			h.label = "?";
			h.value = value;
			
			h.addEventListener(MouseEvent.CLICK, headerClicked);
			
			return h;
		}
		
		private function newProduct(row:int, col:int):ToggleButton
		{
			var t:ToggleButton = new ToggleButton();
			t.setStyle("skinClass", ToggleCellSkin);
			//t.width = 96;
			//t.height = 96;
			var r:int = rowMultiplier(row);
			var c:int = colMultiplier(col);
			
			if(isNaN(r)) t.label = "";
			else if(isNaN(c)) t.label = "";
			else t.label = (r*c).toString();
			
			t.addEventListener(MouseEvent.CLICK, productClicked);
			
			return t;
		}
		
		private function rowMultiplier(i:int):int
		{
			var h:HeaderButton = screen.rowHeader.getElementAt(i) as HeaderButton;
			var n:int = h.value;
			return n;
		}
		
		private function colMultiplier(i:int):int
		{
			var h:HeaderButton = screen.colHeader.getElementAt(i) as HeaderButton;
			var n:int = h.value;
			return n;
		}
		
		
	}
}