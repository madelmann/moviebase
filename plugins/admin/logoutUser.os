#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Accounts.AccountTools;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin {
	public bool Execute( int argc, string args ) modify throws {
		return Accounts.Logout();
	}
}
