#!/usr/local/bin/webscript

// library imports
import System.Collections.List;
import System.StringIterator;

// project imports
import libs.Database.Tables.Actors;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "actor" ) ) {
			throw "missing actor";
		}

		string actorName = mysql_real_escape_string( Database.Handle, get( "actor" ) );

		var actor = new TActorsRecord( Database.Handle, "SELECT * FROM actors WHERE name = '" + actorName + "'" );

		Json.AddElement( "description", actor.Description );
		Json.AddElement( "id", actor.Id );
		Json.AddElement( "name", actor.Name );

		AddTags( actor.Tags );

		return true;
	}

	private void AddTags( string tags ) {
		Json.BeginArray( "tags" );

		if ( strlen( tags ) > 1 ) {
			StringIterator it = new StringIterator( tags, "|" );

			while ( it.hasNext() ) {
				if ( !it.next() ) {
					continue;
				}

				Json.BeginObject();
				Json.AddElement( "name", it.current() );
				Json.EndObject();
			}
		}

		Json.EndArray();
	}
}

