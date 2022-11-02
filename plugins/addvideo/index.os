#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;
import Consts;


public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Constructor() {
		base.Constructor();
	}

	public void Render() {
		string source = SOURCE;
		string tags = TAGS;
		string title = TITLE;

		EditableLabel("title", TITLE, 20);
		print("</br>");
		EditableLabel("source", SOURCE, 9);
		print("</br>");
		print("<h4 class='align-left'>Tags</h4>");
		EditableTextArea("tags", TAGS); print("</br>");

		print("</br>");
		print("<button id='cancel' class='cancel hidden' hidden='true' onclick='mPlugin.HideAll();'>X</button>");
		print("<button id='save'   class='hidden'        hidden='true' onclick='mPlugin.AddVideo();'>Speichern</button>");
	}
}

