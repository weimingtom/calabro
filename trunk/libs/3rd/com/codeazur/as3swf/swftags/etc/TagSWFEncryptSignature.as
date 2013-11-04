package com.codeazur.as3swf.swftags.etc
{
	import com.codeazur.as3swf.swftags.ITag;
	import com.codeazur.as3swf.swftags.TagUnknown;
	
	public class TagSWFEncryptSignature extends TagUnknown implements ITag
	{
		public static const TYPE:uint = 255;
		
		public function TagSWFEncryptSignature(type:uint = 0) {}
		
		override public function get type():uint { return TYPE; }
		override public function get name():String { return "SWFEncryptSignature"; }
	}
}