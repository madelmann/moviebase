
// library imports
import libJsonBuilder.StructuredBuilder;

// project imports
//import libs.Database;
import libs.Session;


public namespace Accounts {

	public void ExtendSession() {
		var session = GetSession();
		if ( !session ) {
			// silently return
			return;
		}

		session.extendValidity();
	}

	public string GetIdentifier() throws {
		return GetSession().getUserIdentifier();
	}

	public Session GetSession() throws {
		if ( !isSet( "sessionID" ) ) {
			return Session null;
		}

		var sessionID = mysql_real_escape_string( Database.Handle, get( "sessionID" ) );
		if ( !sessionID ) {
			return Session null;
		}

		return Session.load( sessionID );
	}

	public bool ReincarnateSession( string sessionID ) throws {
		var session = Session.load( sessionID );
		if ( !session || !session.isValid() ) {
			return false;
		}

		Json.BeginObject( "data" );
		Json.AddElement( "identifier", session.getUserIdentifier() );
		Json.AddElement( "language", session.language() );
		Json.AddElement( "sessionID", sessionID );
		Json.AddElement( "username", session.username() );
		Json.EndObject();

		return true;
	}

}

