
// library imports
import libJsonBuilder.StructuredBuilder;

// project imports
import libs.Database;
import libs.Session;


public namespace Utils {

	public string GetIdentifier() throws {
		return GetSession().getUserIdentifier();
	}

	public Session GetSession() throws {
		if ( !isSet( "sessionId" ) ) {
			throw "sessionId is missing";
		}

		string sessionId = mysql_real_escape_string( Database.Handle, get( "sessionId" ) );
		if ( !sessionId ) {
			throw "invalid sessionId set!";
		}

		var session = Session.load( sessionId );
		if ( session ) {
			return session;
		}

		throw "no valid session!";
	}

	public bool ReincarnateSession( string sessionId, string username ) throws {
		var session = Session.load( sessionId );
	
		if ( !session.isValid() ) {
			return false;
		}
	
		Json.BeginObject( "data" );
		Json.AddElement( "identifier", session.getUserIdentifier() );
		Json.AddElement( "isAdmin", session.isAdmin() );
		Json.AddElement( "isLoggedIn", session.isValid() );
		Json.AddElement( "sessionId", sessionId );
		Json.AddElement( "username", username );
		Json.EndObject();

		return true;
	}
}

