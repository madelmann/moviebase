#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.Plugins.RenderPlugin;


public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Render() {
		RenderLogin();
	}
}

