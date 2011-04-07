package org.maths.FB.models.VO
{
	public class RevealVO
	{
		public var row:int;
		public var col:int;
		public var product:int;

		public function RevealVO(row:int, col:int, product:int)
		{
			this.row = row;
			this.col = col;
			this.product = product;
		}
	}
}