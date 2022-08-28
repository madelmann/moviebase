#!/usr/local/bin/webscript

// library imports

// project imports
import libs.API;
import libs.Accounts.AccountTools;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin {
	public bool Execute() modify throws {
		if ( !isSet( "username" ) || !isSet( "password" ) ) {
			Json.AddElement( "message", "no user or password provided" );
			return false;
		}

		var username = API.retrieve( "username" );
		if ( !username ) {
			Json.AddElement( "message", "invalid username set" );
			return false;
		}

		var password = API.retrieve( "password" );
		if ( !password ) {
			Json.AddElement( "message", "invalid password set" );
			return false;
		}

		var stayLoggedIn = API.retrieve( "stayLoggedIn", false );

		return Accounts.Login( username, password, stayLoggedIn );
	}
}

