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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.controls.Menu;
	import mx.core.ByteArrayAsset;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.MenuEvent;
	
	import spark.components.Application;

	
	/**
	 * Turns the Flex Context Menu from a Native implementation into a standard skinnable Flex menu
	 */
	public final class SkinnableContextMenu
	{
		/* PUBLIC */
		
		/**
		 * Constructor
		 */
		public function SkinnableContextMenu()
		{
			if (instansiated)
				throw new Error('Class can only be instansiated once');
			
			instansiated = true;
			
			// Can't do anything if there is not a browser!
			if ( ExternalInterface.available )
			{
				// Inject javascript
				this.injectJavascript();
			
				// Listen for right click
				ExternalInterface.addCallback('rightMouseClick', this.onRightClick);
			}
		}
		
		
		/* PRIVATE */
		
		/**
		 * Indicates if Class has been instansiated
		 */
		private static var instansiated:Boolean = false;
		
		
		/**
		 * Reference to the application
		 */
		private var app:Application = Application(FlexGlobals.topLevelApplication);
		
		
		/**
		 * Include javascript to inject into the browser
		 */
		[Embed(source="SkinnableContextMenu.js", mimeType="application/octet-stream")]
		private var javascriptCode:Class;
	
		
		/**
		 * Reference to the Menu
		 */
		private var menu:Menu = null;
		
		
		
		/**
		 * Default menu items
		 */
		private var aboutMenuItem:ContextMenuItem = new ContextMenuItem('About Adobe Flash Player ' + Capabilities.version.substr(4) + '...', false);
		private var settingsMenuItem:ContextMenuItem = new ContextMenuItem('Settings...', true);
		private var globalSettingsMenuItem:ContextMenuItem = new ContextMenuItem('Global Settings...', false);
		
		
		/**
		 * Handle right click from Javascript
		 */
		private function onRightClick():void
		{
			// Hide current menu if shown
			if (this.menu)
				this.menu.hide();
			
			
			var x:Number = this.app.stage.mouseX;
			var y:Number = this.app.stage.mouseY;
			
			var components:Array = this.app.stage.getObjectsUnderPoint( new Point(x,y) );
			var component:UIComponent = null;
			var item:Object = null;
			
			// Default to the application
			var contextMenu:ContextMenu = this.app.contextMenu;
			
			// Find first UI Component with a ContextMenu
			while ( item = components.pop() )
			{
				if ( item as UIComponent )
				{
					component = item as UIComponent;
					if (component.contextMenu)
					{
						contextMenu = component.contextMenu;
						break;
					}
				}
			}

			
			// Default items
			var defaultItems:Array = [
				new ContextMenuItem('Custom', false),
				this.settingsMenuItem,
				this.globalSettingsMenuItem,
				this.aboutMenuItem
			];
			
			
			// Build items
			var menuItems:Array = contextMenu.customItems.concat(defaultItems);
			
			// Process seperators
			var collection:ArrayCollection = new ArrayCollection(menuItems);
			var cursor:IViewCursor = collection.createCursor();
			while ( cursor.moveNext() )
			{
				if ( ContextMenuItem(cursor.current).separatorBefore )
					cursor.insert('separator');
			}
			
			
			// Create the menu
			this.menu = Menu.createMenu(this.app, menuItems, false);
			this.menu.dataDescriptor = new ContextMenuDataDescriptor();
			this.menu.labelField = 'caption';
			this.menu.addEventListener(MenuEvent.ITEM_CLICK, this.onMenuSelection, false, 0, true);
	
			// Position
			this.menu.show(x, y);
		}
		
		
		
		/**
		 * Inject the js code
		 */
		private function injectJavascript():void
		{
			var asset:ByteArrayAsset = new this.javascriptCode();
			
			// Read the javascript
			var jsCode:String = asset.readUTFBytes(asset.bytesAvailable);
			
			// Inject
			ExternalInterface.call('eval', jsCode);
			
			// Create class
			ExternalInterface.call('eval', 'window.skinnableContextMenu = new SkinnableContextMenu("' + ExternalInterface.objectID + '");');
		}
		
		
		
		/**
		 * Handle menu item selection
		 */
		private function onMenuSelection(event:MenuEvent):void
		{
			switch ( ContextMenuItem(event.item) )
			{
				case this.settingsMenuItem:
					Security.showSettings();
					event.preventDefault();
				break;
				
				case this.globalSettingsMenuItem:
					this.openURL('http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager.html');
					event.preventDefault();
				break;
				
				case this.aboutMenuItem:
					this.openURL('http://www.adobe.com/software/flash/about/');
					event.preventDefault();
				break;
			}
		}
		
		
		/**
		 * OPen a URL
		 */
		private function openURL(url:String):void
		{
			
		}
		
	}
}