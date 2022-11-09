#!/usr/local/bin/webscript

// library imports
import libs.API;
import System.Collections.Set;
import System.StringIterator;

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		var actorID = API.retrieve( "actorID" );
		if ( !actorID ) {
			throw "invalid actorID provided!";
		}

		var tag = API.retrieve( "tag" );
		if ( !tag ) {
			throw "invalid tag provided!";
		}

		Json.AddElement( "actorID", actorID );

		var tags = new String( Database.retrieveField( TABLE, "tags", actorID ) );

		string newTags;
		foreach ( string currentTag : tags.SplitBy( "|" ) ) {
			if ( currentTag != tag ) {
				if ( newTags ) {
					newTags += "|";
				}

				newTags += currentTag;
			}
		}

		return Database.updateField( TABLE, "tags", actorID, newTags );
	}

	private string TABLE const = "actors";
}

