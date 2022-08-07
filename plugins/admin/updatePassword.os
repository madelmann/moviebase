#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "identifier" ) ) {
			throw "identifier missing!";
		}

		if ( !isSet( "password" ) ) {
			throw "password missing!";
		}

		string identifier = mysql_real_escape_string( Database.Handle, get( "identifier" ) );
		if ( !identifier ) {
			throw "invalid identifier provided!";
		}

		string password = mysql_real_escape_string(Database.Handle, get("password"));
		if ( !password ) {
			throw "invalid password provided!";
		}

		return UpdatePassword(identifier, password);
	}

	private bool UpdatePassword(string identifier, string password) throws {
		string query = "UPDATE users SET password = " + Utils.prepareEncrypt(password) + " WHERE identifier = '" + identifier + "'";

		int error = mysql_query(Database.Handle, query);
		if ( error ) {
			throw mysql_error(Database.Handle);
		}

		return true;
	}
}

