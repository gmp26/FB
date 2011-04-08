package org.maths.FB.models
{
	import org.maths.FB.models.VO.RevealVO;

	public class Analyser
	{
		public function Analyser()
		{
			reveals = new Vector.<RevealVO>();
		}
		
		// initial possibilities		
		public var rowPossibles:Vector.<Vector.<int>>;
		public var colPossibles:Vector.<Vector.<int>>;
		
		public function setRowRange(rows:int, from:int, to:int):void
		{
			rowPossibles = new Vector.<Vector.<int>>;
			for(var row:int = 0; row < rows; row++) {
				rowPossibles[row] = new Vector.<int>
				for(var value:int = from; value <= to; value++) {
					rowPossibles[row].push(value);
				}
			}
		}
		
		public function setColRange(cols:int, from:int, to:int):void
		{
			colPossibles = new Vector.<Vector.<int>>;
			for(var col:int = 0; col < cols; col++) {
				colPossibles[col] = new Vector.<int>
				for(var value:int = from; value <= to; value++) {
					colPossibles[col].push(value);
				}
			}
		}
		

		private var reveals:Vector.<RevealVO>;
		
		public function addReveal(row:int, col:int, product:int):void
		{
			reveals.push(new RevealVO(row, col, product));
		}
		
		/**
		 * Solve the puzzle so far as is possible, returning the total number of unknowns
		 * @return 
		 * 
		 */
		public function solve():int
		{
			for(var i:int = 0; i < reveals.length; i++) {
				var reveal:RevealVO = reveals[i];
				var row:int = reveal.row;
				var col:int = reveal.col;
				var product:int = reveal.product;
				
				// reduce row header possibilities
				var possibles:Vector.<int> = rowPossibles[row].concat();
				if(possibles.length > 1) {
					for(var p:int = 0; p < possibles.length; p++) {
						var value:int = possibles[p];
						if(product % value != 0 || (colPossibles[col].indexOf(product / value) < 0)) {
							// remove this possibility
							rowPossibles[row].splice(rowPossibles[row].indexOf(value), 1);
							if(rowPossibles[row].length == 1) {
								// only one possibility...
								fixRowHeader(row, rowPossibles[row][0]);
							}
						}
					}
				}
				
				// reduce col header possibilities
				possibles = colPossibles[col].concat();
				if(possibles.length > 1) {
					for(p = 0; p < possibles.length; p++) {
						value = possibles[p];
						if(product % possibles[p] != 0 || (rowPossibles[row].indexOf(product / value) < 0)) {
							// remove this possibility
							colPossibles[col].splice(colPossibles[col].indexOf(value), 1);
							if(colPossibles[col].length == 1) {
								// only one possibility...
								fixColHeader(col, colPossibles[col][0]);
							}
						}
					}
				}
			}
			
			var unknowns:int = 0;
			for(var r:int = 0; r < rowPossibles.length; r++) {
				unknowns += rowPossibles[r].length;
			} 
			for(var c:int = 0; c < colPossibles.length; c++) {
				unknowns += colPossibles[c].length;
			} 
			
			return unknowns;
		}
		
		private function fixHeader(row:int, rowValue:int, col:int, colValue:int):void
		{
			// remove value as a possibility for all other rows
			for(var r:int = 0; r < rowPossibles.length; r++) {
				if(r == row) continue;
				var possibles:Vector.<int> = rowPossibles[r];
				if(possibles.length <= 1)
					continue;
				var p:int = possibles.indexOf(rowValue);
				if(p >= 0) {
					possibles.splice(p, 1);
					if(possibles.length == 1) {
						fixRowHeader(r, possibles[0]);
					}
				}
			}
			
			// remove value as a possibility for all other cols
			for(var c:int = 0; c < colPossibles.length; c++) {
				if(c == col) continue;
				possibles = colPossibles[c];
				if(possibles.length <= 1)
					continue;
				p = possibles.indexOf(colValue);
				if(p >= 0) {
					possibles.splice(p, 1);
					if(possibles.length == 1) {
						fixColHeader(c, possibles[0]);
					}
				}
			}
		}
		
		public function fixRowHeader(row:int, value:int):void
		{
			// remove value as a possibility for all other rows
			for(var r:int = 0; r < rowPossibles.length; r++) {
				if(r == row) continue;
				var possibles:Vector.<int> = rowPossibles[r];
				if(possibles.length <= 1)
					continue;
				var p:int = possibles.indexOf(value);
				if(p >= 0) {
					possibles.splice(p, 1);
					if(possibles.length == 1) {
						fixRowHeader(r, possibles[0]);
					}
				}
			}
		}
		
		public function fixColHeader(col:int, value:int):void
		{
			
			// remove value as a possibility for all other cols
			for(var c:int = 0; c < colPossibles.length; c++) {
				if(c == col) continue;
				var possibles:Vector.<int> = colPossibles[c];
				if(possibles.length <= 1)
					continue;
				var p:int = possibles.indexOf(value);
				if(p >= 0) {
					possibles.splice(p, 1);
					if(possibles.length == 1) {
						fixColHeader(c, possibles[0]);
					}
				}
			}
		}
	}
}