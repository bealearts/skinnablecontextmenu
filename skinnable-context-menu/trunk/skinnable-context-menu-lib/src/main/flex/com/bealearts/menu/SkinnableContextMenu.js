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

/**
 * Capture, override and pass Mouse right click to Flex
 */
function SkinnableContextMenu(flexApplicationID)
{
	/**
	 * Constructor
	 */
	this.init = function()
	{
        // Reference to use in event handler anonymous functions
        var self = this;

		if (window.addEventListener)
			window.addEventListener('mousedown', function(event){ self.onWindowMouse(event) }, true);
	}


    /**
     * Skinnable menu enabled
     */
    this.enabled = true;

	/**
	 * Handle window mouse click
	 */
	this.onWindowMouse = function(event)
	{
		// Right click on Flex application
		if ( event.button != 0 && event.target.id == window.skinnableContextMenu.flexApplicationID && this.enabled )
		{
			// Prevent normal event chain
			if (event.stopPropagation)
				event.stopPropagation();
			if (event.preventDefault)
				event.preventDefault();
			if (event.preventCapture)
				event.preventCapture();
			if (event.preventBubble)
				event.preventBubble();
	
			// Call Flex
			document.getElementById(window.skinnableContextMenu.flexApplicationID).rightMouseClick();
		}
	}
	
	this.flexApplicationID = flexApplicationID;
	this.init();
}
