#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("name") ) {
			return false;
		}
	
		var name = mysql_real_escape_string(Database.Handle, get("name"));
		if ( !name ) {
			return false;
		}
	
		return AddActor(name) && AddActorFolder(name);
	}

	private bool AddActor(string name) throws {
		if ( !name ) {
			return false;
		}

		var query = "INSERT INTO actors (name) VALUES ('" + name + "')";

		var error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		return true;
	}

	private bool AddActorFolder(string name) {
		if ( !name ) {
			return false;
		}

		system("mkdir \"actors/" + name + "\"");

		return true;
	}
}

