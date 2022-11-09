#!/usr/local/bin/webscript

// Library imports
import libs.API;
import System.Collections.Set;
import System.StringIterator;

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		var collectionID = API.retrieve( "collectionID" );
		if ( !collectionID ) {
			throw "invalid collectionID provided!";
		}

		var tag = API.retrieve( "tag" );
		if ( !tag ) {
			throw "invalid tag provided!";
		}

		Json.AddElement( "collectionID", collectionID );

		var tags = new String( Database.retrieveField( TABLE, "tags", collectionID ) );

		string newTags;
		foreach ( string currentTag : tags.SplitBy( "|" ) ) {
			if ( currentTag != tag ) {
				if ( newTags ) {
					newTags += "|";
				}

				newTags += currentTag;
			}
		}

		return Database.updateField( TABLE, "tags", collectionID, newTags );
	}

	private string TABLE const = "collections";
}

