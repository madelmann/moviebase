#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.RenderPlugin;
import libs.Utils.VisitorCounter;
import showDeletedItems;
import showDuplicateItems;


public object RenderPlugin implements IRenderPlugin {
	public void Render() {
		if ( Utils.mIsAdmin ) {
			print("<h4>Welcome, admin</h4>");
		}

		// load num visitors from database
		VisitorCounter counter = new VisitorCounter(Database.Handle);

		writeln("<p>");
		writeln("Visitor count: " + counter.getNumVisitors());
		writeln("</p>");

		if ( Utils.mIsAdmin ) {
			showDuplicateItems();

			showDeletedFiles();
		}
	}
}

