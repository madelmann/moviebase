#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Database.Tables.Download;
import libs.API.Utils;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		var id = cast<int>( API.retrieve( "id" ) );
		if ( !id ) {
			throw "invalid id provided";
		}

		Database.Execute( "DELETE FROM download WHERE id = " + id );

		return true;
	}
}

