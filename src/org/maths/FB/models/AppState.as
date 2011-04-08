package org.maths.FB.models
{
	import org.osflash.signals.Signal;

	public class AppState
	{
		/**
		 * list of completed levels. by levelName. This should be persistent
		 */
		public var completedLevels:Object = {};

		/**
		 * pixels per inch 
		 */
		public var ppi:Number;
		
		/**
		 * true if phone is in horizontal plane 
		 */
		public var flat:Boolean = false;
		
		/**
		 * stage height 
		 */
		public var stageHeight:int;
		
		/**
		 * stage width 
		 */
		public var stageWidth:int;
		
		/**
		 * minimum header allowed 
		 */
		public var min:int = 2;
		
		/**
		 * maximum header allowed
		 */		
		public var max:int = 12;
		
		
		/**
		 * number of headers accessors 
		 */
		private var _size:int = 4;
		public function get size():int
		{
			return _size;
		}
		public function set size(sz:int):void
		{
			_size=sz;
			
			if(initialReveals[3] == 0) {
				initialReveals[3] = sz + Math.floor(sz/2);
			}
			if(initialReveals[2] == 0) {
				initialReveals[2] = initialReveals[3] + 2;
			}
			if(initialReveals[1] == 0) {
				initialReveals[1] = initialReveals[2] + 2;
			}
			if(initialReveals[0] == 0) {
				initialReveals[0] = sz*sz;
			}
		}
		
		/**
		 * in teacher, we count up the reveals. In student mode we assign maximum number and count down  
		 */
		public var teacher:Boolean = false;
		
		/**
		 * game level (used in student mode only)
		 */		
		public var gameLevel:int = 1;
		
		/**
		 * initial reveals allowed indexed by gameLevel-1 
		 */
		public var initialReveals:Vector.<int> = Vector.<int>([0, 10, 8, 6]);
		
		/**
		 * hidden headers used to calculate multiplication table 
		 */		
		public var rowHeadings:Array = [];
		public var colHeadings:Array = [];
		
		/**
		 * visible, guessed headers 
		 */		
		public var rowGuesses:Array = [];
		public var colGuesses:Array = [];
		
		public function get rows():int
		{
			return _size; //rowHeadings.length;
		}
		
		public function get cols():int
		{
			return _size; //colHeadings.length;
		}
		
		public function productAt(row:int, col:int):int
		{
			return (rowHeadings[row] as int) * (colHeadings[col] as int);
		}
		
		public function tableData(signal:Signal):Array
		{
			var td:Array = [];
			for(var i:int = 0; i < rows; i++) {
				for(var j:int = 0; j < cols; j++) {
					td.push({row:i, col:j, value:productAt(j, i), sel:false, signal:signal, enable:true });
				}
			}
			return td;
		}
		

	}
}