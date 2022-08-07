#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.Common.Utils.CreateCollection;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("identifier") ) {
			return false;
		}
		if ( !isSet("name") ) {
			return false;
		}
	
		string identifier = mysql_real_escape_string(Database.Handle, get("identifier"));
		string name = mysql_real_escape_string(Database.Handle, get("name"));
	
		return CreateCollection(identifier, name);
	}
}

