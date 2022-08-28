#!/usr/local/bin/webscript

// library imports

// project imports
import API.Utils;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		var id = API.retrieve( "id" );

		return DeleteActor( id );
	}	

	private bool DeleteActor( string id ) throws {
		if ( !id ) {
			return false;
		}

		var query = "DELETE FROM actors WHERE id = " + id;

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}
}

