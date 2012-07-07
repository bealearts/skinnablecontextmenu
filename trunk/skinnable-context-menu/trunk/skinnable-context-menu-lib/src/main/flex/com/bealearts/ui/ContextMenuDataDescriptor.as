/**
 *
 * Copywrite (c) 2011, David Beale
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package com.bealearts.ui
{
/**
	 * Menu descriptor based on the ContextMenuItem
	 */ 
	public class ContextMenuDataDescriptor implements IMenuDataDescriptor
	{
		public function ContextMenuDataDescriptor()
		{

		}
		
		public function getChildren(node:Object, model:Object=null):ICollectionView
		{
			return null;
		}
		
		public function hasChildren(node:Object, model:Object=null):Boolean
		{
			
			return false;
		}
		
		public function getData(node:Object, model:Object=null):Object
		{			
			return node;
		}
		
		public function isBranch(node:Object, model:Object=null):Boolean
		{			
			return false;
		}
		
		public function getType(node:Object):String
		{
			if (node is ContextMenuItem)
				return '';
			else
				return 'separator';
		}
		
		public function addChildAt(parent:Object, newChild:Object, index:int, model:Object=null):Boolean
		{
			return false;
		}
		
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean
		{
			return false;
		}
		
		public function isEnabled(node:Object):Boolean
		{
			if (node is ContextMenuItem)
				return ContextMenuItem(node).enabled;
			else
				return true;
		}
		
		public function setEnabled(node:Object, value:Boolean):void
		{
			
		}
		
		public function isToggled(node:Object):Boolean
		{
			return false;
		}
		
		public function setToggled(node:Object, value:Boolean):void
		{
	
		}
		
		public function getGroupName(node:Object):String
		{
			return null;
		}
	}
}