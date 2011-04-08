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
			rowHeader = screen.rowHeader;
			colHeader = screen.colHeader;
			table = screen.table;
			
			homeButton = screen._homeButton;
			backButton = screen._backButton;
			skipButton = screen._skipButton;
			checkButton = screen._checkButton;
			nextButton = screen._nextButton;
			tryAgainButton = screen._tryAgainButton;
			
			super.onRegister();
			
			newProblem();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		override protected function enableAll():void
		{
			super.enableAll();
		}
		
		override protected function disableAll():void
		{
			super.disableAll();
		}
		
		override protected function get isComplete():Boolean
		{			
			for(var i:int = 0; i < screen.rowHeader.numElements; i++) {
				if((screen.rowHeader.getElementAt(i) as HeaderButton).label == "?")
					return false;
			}
			for(i = 0; i < screen.colHeader.numElements; i++) {
				if((screen.colHeader.getElementAt(i) as HeaderButton).label == "?")
					return false;
			}

			return true;
		}
		
		override protected function endGame(event:MouseEvent=null):void
		{
			if(event != null) {
				var b:ToggleButton = event.currentTarget as ToggleButton;
				var x:int = screen.table.getElementIndex(b);
				var col:int = x % cols;
				var row:int = x / rows;
				analyser.addReveal(row, col, parseInt(b.label));
				analyser.solve();
				analyser.solve();
				var unknowns:int = analyser.solve() - rows - cols;
				if(unknowns == 0) {
					screen.enough.visible = true;
					screen.instruction.visible = false;
					for(var i:int = 0; i < screen.table.numElements; i++) {
						var t:ToggleButton = screen.table.getElementAt(i) as ToggleButton;
						if(!t.selected) {
							t.label = "";
							t.enabled = false;
							t.selected = true;
						}
					}
				}
			}
			
			super.endGame(event);
		}
		
		override protected function get isCorrect():Boolean
		{
			for(var i:int = 0; i < screen.rowHeader.numElements; i++) {
				var h:HeaderButton = screen.rowHeader.getElementAt(i) as HeaderButton;
				if(parseInt(h.label) != h.value)
					return false;
			}
			for(i = 0; i < screen.colHeader.numElements; i++) {
				h = screen.colHeader.getElementAt(i) as HeaderButton;
				if(parseInt(h.label) != h.value)
					return false;
			}
			
			appState.completedLevels["intro"] = true;
			
			return true;
		}
		
		override protected function nextScreen(event:Event):void
		{
			enableAll();
			screen.navigator.pushView(StartScreen);			
		}
		
		private function newProblem():void
		{
			screen.colHeader.addElement(newHeader(4));		
			screen.colHeader.addElement(newHeader(3));		
			
			screen.rowHeader.addElement(newHeader(7));		
			screen.rowHeader.addElement(newHeader(6));		

			screen.table.addElement(newProduct(0,0));
			screen.table.addElement(newProduct(0,1));
			
			screen.table.addElement(newProduct(1,0));
			screen.table.addElement(newProduct(1,1));
			
			screen.validateNow();
			
			// set up the solution analyser
			analyser = new Analyser();
			analyser.setRowRange(rows, 2, 12);
			analyser.setColRange(cols, 2, 12);
			//screen.unknowns.text = "Unknowns " + (analyser.solve() - appState.rows - appState.cols);
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
		

	}
}