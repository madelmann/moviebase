#!/usr/local/bin/webscript

// Library imports
import System.Collections.Set;
import System.StringIterator;

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("id") ) {
			throw "id is missing!";
		}

		string id = mysql_real_escape_string(Database.Handle, get("id"));
		if ( !id ) {
			throw "invalid id provided!";
		}

		Json.AddElement("id", id);

		if ( isSet("actor") ) {
			string originalActors = GetActors(id);
			var originalActorIt = new StringIterator(originalActors, "|");

			var actors = new Set<string>();
			while ( originalActorIt.hasNext() ) {
				if ( originalActorIt.next() ) {
					actors.insert( originalActorIt.current() );
				}
			}

			string actor = get("actor");
			if ( actor && actors.contains(actor) ) {
				try { actors.erase( actors.indexOf(actor) ); }
			}

			string newActors;
			var newActorIt = actors.getIterator();
			while ( newActorIt.hasNext() ) {
				newActors += newActorIt.next();

				if ( newActorIt.hasNext() ) {
					newActors += "|";
				}
			}

			return SetActors(id, mysql_real_escape_string(Database.Handle, newActors));
		}

		throw "actor is missing!";
	}

	private string GetActors(string id) {
		return Database.retrieveField(TABLE, "actors", id);
	}

	private bool SetActors(string id, string value) {
		return Database.updateField(TABLE, "actors", id, value);
	}

	private string TABLE const = "items";
}

