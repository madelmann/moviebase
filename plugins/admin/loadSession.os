#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Accounts.SessionTools;
import libs.API.Utils;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin {
	public bool Execute() modify throws {
		var sessionID = API.retrieve( "sessionID" );
		if ( !sessionID ) {
			Json.AddElement( "message", "invalid sessionID set" );
			return false;
		}

		return Accounts.ReincarnateSession( sessionID );
	}
}

