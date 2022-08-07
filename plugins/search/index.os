#!/usr/local/bin/webscript

// Library imports

// project imports
import libs.Plugins.RenderPlugin;


public object RenderPlugin implements IRenderPlugin {
	public void Render() {
		print( "
<span>
	<div id='result'><img class='loading_spinner' src='resources/images/loading.gif' alt='Loading...'/></div>
</span>
		" );
	}
}

