package com.codeazur.as3swf.swftags
{
	public interface IDefinitionTag extends ITag
	{
		function get characterId():uint;
		function set characterId(value:uint):void;
		
		function clone():IDefinitionTag;
	}
}