#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;
import libs.Utils.VisitorCounter;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() {
		VisitorCounter vc = new VisitorCounter(Database.Handle);
		vc.increment();

		return true;
	}
}

