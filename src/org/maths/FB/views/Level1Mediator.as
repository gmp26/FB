package org.maths.FB.views
{
	import com.tweenman.TweenMan;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.components.Picker;
	import org.maths.FB.components.TableButton;
	import org.maths.FB.components.Tick;
	import org.maths.FB.models.Analyser;
	import org.maths.FB.models.AppState;
	import org.maths.FB.skins.ToggleCellSkin;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	import spark.components.Label;
	
	public class Level1Mediator extends AbstractLevelMediator
	{
		[Inject]
		public var screen:Level1;
		
		private var analyser:Analyser;
					
		public function Level1Mediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			
			// inject common components into AbstractMediator
			level = screen;
			levelName = "level1";
			content = screen._content;
			rowHeader = screen.rowHeader;
			colHeader = screen.colHeader;
			table = screen.table;
			instruction = screen.instruction;
			endNavigation = screen.endNavigation;
			homeButton = screen._homeButton;
			backButton = screen._backButton;
			skipButton = screen._skipButton;
			checkButton = screen._checkButton;
			nextButton = screen._nextButton;
			tryAgainButton = screen._tryAgainButton;
			min=2;
			max=5;
			
			super.onRegister();
			
			newProblem();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
							
		override protected function endGame(event:MouseEvent=null):void
		{
			if(event != null) {
				var b:TableButton = event.currentTarget as TableButton;
				var x:int = screen.table.getElementIndex(b);
				var col:int = x % cols;
				var row:int = x / rows;
				analyser.addReveal(row, col, parseInt(b.label));
				analyser.solve();
				analyser.solve();
				var unknowns:int = analyser.solve() - rows - cols;
				
				for(var i:int = 0; i < table.numElements; i++) {
					var tb:TableButton = table.getElementAt(i) as TableButton;
					//if(tb == null) continue;
					var rh:HeaderButton = rowHeader.getElementAt(tb.row) as HeaderButton;
					if(analyser.rowPossibles[tb.row].length > 1) continue;
					rh.showGremlin(true);
					var ch:HeaderButton = colHeader.getElementAt(tb.col) as HeaderButton;
					if(analyser.colPossibles[tb.col].length > 1) continue;
					ch.showGremlin(true);
				}
				
				/*
				// trace what can be deduced 
				for(i=0; i < rows; i++) {
					var possibles:Vector.<int> = analyser.rowPossibles[i];
					var s:String = "row["+i+"]=";
					for(var j:int=0; j < possibles.length; j++) {
						s += possibles[j]+" ";
					}
					trace(s);
				}
				
				for(i=0; i < cols; i++) {
					possibles = analyser.colPossibles[i];
					s = "col["+i+"]=";
					for(j=0; j < possibles.length; j++) {
						s += possibles[j]+" ";
					}
					trace(s);
				}
				*/
				
				
				if(unknowns == 0) {
					screen.endNavigation.visible = true;
					screen.instruction.visible = false;
					for(i = 0; i < screen.table.numElements; i++) {
						var t:TableButton = screen.table.getElementAt(i) as TableButton;
						if(t.label != "") {
							t.label = "";
							t.enabled = false;
						}
					}
				}
			}
			
			super.endGame(event);
		}
		
		override protected function get isCorrect():Boolean
		{
			if(super.isCorrect) {
				scores.completeLevel("level1");
				screen.endNavigation.visible = false;
				return true;
			}
			else
				return false;
		}
		
		override protected function nextScreen(event:Event):void
		{
			level.navigator.pushView(CompletedLevels);			
		}
		
		private function newProblem():void
		{
			var val:int;
			var rowHeadings:Array = [];
			var colHeadings:Array = [];
			
			for(var i:int = 0; i < 4; i++) {
				while(rowHeadings.indexOf(val = min + Math.floor((max-min + 1)*Math.random())) >= 0) {};
				rowHeadings[i] = val;
				rowHeader.addElement(newHeader(val));
			}

			for(var j:int = 0; j < 4; j++) {
				while(colHeadings.indexOf(val = min + Math.floor((max-min + 1)*Math.random())) >= 0) {};
				colHeadings[j] = val;
				colHeader.addElement(newHeader(val));
			}	

			for(i=0; i < 4; i++) {
				for(j=0; j < 4; j++) {
					table.addElement(newProduct(i,j));
				}
			} 
			
			// set up the solution analyser
			analyser = new Analyser();
			analyser.setRowRange(4, min, max);
			analyser.setColRange(4, min, max);
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
		
		private function newProduct(row:int, col:int):TableButton
		{
			var t:TableButton = new TableButton();
			t.row = row;
			t.col = col;
			t.label = "";
			
			t.addEventListener(MouseEvent.CLICK, productClicked);
			return t;
		}
		

	}
}