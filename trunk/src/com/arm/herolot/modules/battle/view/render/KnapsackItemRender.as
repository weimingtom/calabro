package com.arm.herolot.modules.battle.view.render
{
	import com.arm.herolot.modules.battle.battle.item.Item;
	import com.snsapp.starling.display.Button;
	import com.snsapp.starling.texture.implement.SingleTexture;

	import starling.display.Image;
	import starling.text.TextField;

	public class KnapsackItemRender extends Button
	{
		private var _itemIcon:Image;
		private var _itemAmount:TextField;

		public function KnapsackItemRender(upState:SingleTexture)
		{
			super(upState, text, downState);
		}

		public function setItem(item:Item):void
		{
		}
	}
}
