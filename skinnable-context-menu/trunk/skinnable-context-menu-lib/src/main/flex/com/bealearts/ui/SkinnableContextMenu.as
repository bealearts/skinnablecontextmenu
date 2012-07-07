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
import com.bealearts.util.ExternalClipboard;
import com.bealearts.util.JavascriptInjector;

/**
	 * Turns the Flex Context Menu from a Native implementation into a standard skinnable Flex menu
	 */
	public final class SkinnableContextMenu extends EventDispatcher
	{
		/* PUBLIC */
		
		/**
		 * Display default flash items
		 * 
		 * <p>Display the Settings, Global Settings and About Flash menu items</p>
		 */
		public var showDefaultItems:Boolean = true;
		
		
		/**
		 * Constructor
		 */
		public function SkinnableContextMenu()
		{
			if (instansiated)
				throw new Error('Class can only be instansiated once');
			
			instansiated = true;
			
			// Default items
			this.defaultItems = [
				this.settingsMenuItem,
				this.globalSettingsMenuItem,
				this.aboutMenuItem
			];
			
			// Setup javascriot to listen for right click
			if (JavascriptInjector.inject(javascriptCode))
			{
				// Create class
				ExternalInterface.call('eval', 'window.skinnableContextMenu = new SkinnableContextMenu("' + ExternalInterface.objectID + '");');
				
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
		 * Reference to current UIComponent
		 */
		private var component:UIComponent = null;
		
		
		/**
		 * The Focus state of the component
		 */
		private var componentHadFocus:Boolean = false;
		
		
		/**
		 * Default menu items
		 */
		private var aboutMenuItem:ContextMenuItem = new ContextMenuItem('About Adobe Flash Player ' + Capabilities.version.substr(4) + '...', false);
		private var settingsMenuItem:ContextMenuItem = new ContextMenuItem('Settings...', true);
		private var globalSettingsMenuItem:ContextMenuItem = new ContextMenuItem('Global Settings...', false);
		
		private var defaultItems:Array = null;
		
		
		/**
		 * Clipboard menu items
		 */
		private var cutMenuItem:ContextMenuItem = new ContextMenuItem('Cut');
		private var copyMenuItem:ContextMenuItem = new ContextMenuItem('Copy');
		private var pasteMenuItem:ContextMenuItem = new ContextMenuItem('Paste');
		private var deleteMenuItem:ContextMenuItem = new ContextMenuItem('Delete');
		private var selectAllMenuItem:ContextMenuItem = new ContextMenuItem('Select All', true);
		

		
		
		/**
		 * Handle right click from Javascript
		 */
		private function onRightClick():void
		{
			// Hide current menu if shown
			if (this.menu)
				this.menu.hide();
			
			
			const x:Number = this.app.stage.mouseX;
			const y:Number = this.app.stage.mouseY;
			
			const components:Array = this.app.stage.getObjectsUnderPoint( new Point(x,y) );
			var item:Object = null;
			
			// Default to the application
			var contextMenu:ContextMenu = this.app.contextMenu;
			
			// Find first UI Component with a ContextMenu
			while ( item = components.pop() )
			{
				if ( item as UIComponent )
				{
					this.component = item as UIComponent;
					if (this.component.contextMenu)
					{
						contextMenu = this.component.contextMenu;
						break;
					}
				}
			}			
			
			
			
			// Save components focus state
			if ( (this.component as IFocusManagerComponent) && this.component == this.component.focusManager.getFocus() )
				this.componentHadFocus = true;
			else
				this.componentHadFocus = false;
			
			
			// Build items
			
			var menuItems:Array = (new Array).concat( contextMenu.customItems );
			
			
			const textComponent:IEditableText = this.component as IEditableText; 
			
			// Clipboard text edit items
			if (contextMenu.clipboardMenu && textComponent)
			{
				if ( contextMenu.clipboardItems.cut )
				{
					this.cutMenuItem.enabled = (textComponent.selectionActivePosition != textComponent.selectionAnchorPosition);
					menuItems.push( this.cutMenuItem );
				}
				
				if ( contextMenu.clipboardItems.copy )
				{
					this.copyMenuItem.enabled = (textComponent.selectionActivePosition != textComponent.selectionAnchorPosition);
					menuItems.push( this.copyMenuItem );
				}
				
				if ( contextMenu.clipboardItems.paste )
				{
					this.pasteMenuItem.enabled = ExternalClipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT);
					menuItems.push( this.pasteMenuItem );
				}	
					
				if ( contextMenu.clipboardItems.clear )
				{
					this.deleteMenuItem.enabled = (textComponent.selectionActivePosition != textComponent.selectionAnchorPosition);
					menuItems.push( this.deleteMenuItem );
				}
				
				if ( contextMenu.clipboardItems.selectAll )
				{
					this.selectAllMenuItem.enabled = (textComponent.text != "");
					menuItems.push( this.selectAllMenuItem );
				}
			}
			
			
			// Default Flash Player items
			if ( this.showDefaultItems )
				menuItems = menuItems.concat(defaultItems);
			
			
			
			
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
			this.menu.addEventListener(MenuEvent.MENU_SHOW, this.onMenuShown, false ,0 , true);
	
			// Position
			this.menu.show(x, y);
		}
		
	
		
		
		/**
		 * Handle the display of the menu
		 */
		private function onMenuShown(Event:MenuEvent):void
		{
			// Restore focus to component
			if ( this.componentHadFocus )
				IFocusManagerComponent(this.component).setFocus();
		}
		
		
		
		/**
		 * Handle menu item selection
		 */
		private function onMenuSelection(event:MenuEvent):void
		{
			const textComponent:IEditableText = this.component as IEditableText;
			
			switch ( ContextMenuItem(event.item) )
			{
				// Default Items
				
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
				
				
				// Clipboard text edit items
				
				case this.selectAllMenuItem:
					if (textComponent)
						textComponent.selectAll();
				break;
				
				case this.copyMenuItem:
					if (textComponent)
						ExternalClipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, selecteText(textComponent));
				break;
				
				case this.pasteMenuItem:
					if (textComponent)
						insertText(textComponent, String(ExternalClipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT)) );
				break;
				
				case this.cutMenuItem:
					if (textComponent)
					{
						ExternalClipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, selecteText(textComponent));
						insertText(textComponent, '');
					}
				break;
			}
		}
		
		
		/**
		 * Open a URL
		 */
		private function openURL(url:String):void
		{
			navigateToURL( new URLRequest(url) );
		}
		
		
		
		/**
		 * Return the selected text
		 */
		private function selecteText(textComponent:IEditableText):String
		{
			return textComponent.text.substring(textComponent.selectionAnchorPosition, textComponent.selectionActivePosition);
		}
		
		
		/**
		 * Insert text into selected text
		 */
		private function insertText(textComponent:IEditableText, text:String):void
		{
			// TODO: clear current selection and insert text
		}
		
		

	}
}