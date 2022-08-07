#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;
import libs.Plugins.Common.Utils.RegisterUser;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("username") || !isSet("password") ) {
			Json.AddElement("message", "username or password is missing");
			return false;
		}

		string password = mysql_real_escape_string(Database.Handle, get("password"));
		string username = mysql_real_escape_string(Database.Handle, get("username"));

		if ( !username ) {
			Json.AddElement("message", "invalid username set");
			return false;
		}
		if ( !password ) {
			Json.AddElement("message", "invalid password set");
			return false;
		}

		return RegisterUser(username, password);
	}
}

