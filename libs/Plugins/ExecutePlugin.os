
// library imports

// project imports
import libs.Plugins.IPlugin;
import libs.MainExecuteDB;


public bool Execute( int argc, string args ) modify {
	var plugin = new ExecutePlugin();

	return plugin.Execute();
}

