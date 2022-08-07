
// library imports
import libJsonBuilder.StructuredBuilder;

// project imports
import libs.Session;


public namespace Accounts {

	public bool ChangeLanguage( string identifier, string language ) throws {
		Database.Execute(
			"UPDATE user_data SET language = '" + language + "' WHERE identifier = '" + identifier + "'"
		);

		return true;
	}

	public bool Delete( string identifier ) throws {
		Database.begin();

		// set user to deleted to that he cannot log in anymore
		Database.Execute(
			"UPDATE users SET deactivated = Now(), deleted = TRUE, username = CONCAT( username, '~', Now() ) WHERE identifier = '" + identifier + "'"
		);

		Database.commit();

		return true;
	}

	public bool Login( string username, string password, bool stayLoggedIn = false ) throws {
		var query = "SELECT * "
				  + "FROM users u "
				  + "WHERE username = '" + username + "' AND password = SHA2( '" + password + "', 256 )";

		var result = Database.Query( query );

		if ( mysql_fetch_row( result ) ) {
			var identifier	= mysql_get_field_value( result, "identifier" );
			var language	= "EN"; //mysql_get_field_value( result, "language" );
			var username	= mysql_get_field_value( result, "username" );

			Database.begin();

			var session = new Session( identifier );
			session.setIsInfinite( stayLoggedIn );
			session.store();

			Json.BeginObject( "data" );
			Json.AddElement( "identifier", identifier );
			Json.AddElement( "language", language );
			Json.AddElement( "sessionID", session.getId() );
			Json.AddElement( "username", username );
			Json.EndObject();

			Database.commit();

			return true;
		}
	
		Json.AddElement( "message", "invalid user or password" );
		return false;
	}

	public bool Logout() throws {
		Database.begin();

		var session = GetSession();
		if ( !session ) {
			Json.AddElement( "message", "no session found" );
			return false;
		}

		// delete session
		session.delete();

		Database.commit();

		return true;
	}

	public bool Register( string username ) throws {
		// create random password
		srand( time() );
		var password = cast<string>( rand() );

		var passwordhash = Database.prepareEncrypt( password );
		var userhash     = Database.prepareEncrypt( username, strftime( "%Y-%m-%dT%H:%M:%S" ) );

		Database.begin();

		Database.Execute(
			"INSERT INTO users ( identifier, username, password ) VALUES ( " + userhash + ", '" + username + "', " + passwordhash + " )"
		);

		Database.commit();

		return true;
	}

}

