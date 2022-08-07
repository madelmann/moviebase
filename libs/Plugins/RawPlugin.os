
// library imports

// project imports
import libs.Plugins.IPlugin;
import libs.MainProcessDB;


public void Process( int argc, string args ) {
	var plugin = new RawPlugin();

	plugin.Process( argc, args );
}

