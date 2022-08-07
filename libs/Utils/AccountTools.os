
// library imports
import libJsonBuilder.StructuredBuilder;

// project imports
import libs.Database;
import libs.Session;


public namespace Utils {

	public bool Login( string username, string password, bool infinity = false ) throws {
		string query = "SELECT identifier, is_admin, username "
				 + "FROM users "
				 + "WHERE username = '" + username + "' AND password = SHA2('" + password + "', 256)";

		var result = Database.Utils.Query( query );

		if ( mysql_fetch_row( result ) ) {
			string identifier = mysql_get_field_value( result, "identifier" );
			string isAdmin = mysql_get_field_value( result, "is_admin" );
			string username = mysql_get_field_value( result, "username" );

			var session = new Session( identifier );
			session.setIsAdmin( isAdmin == "1" );
			session.setIsInfinite( infinity );
			session.store();

			Json.BeginObject( "data" );
			Json.AddElement( "identifier", identifier );
			Json.AddElement( "isAdmin", isAdmin == "1" );
			Json.AddElement( "isLoggedIn", session.isValid() );
			Json.AddElement( "sessionId", session.getId() );
			Json.AddElement( "username", username );
			Json.EndObject();
	
			return true;
		}
	
		Json.AddElement( "message", "invalid user or password" );
		return false;
	}

    public bool Register( string username, string password ) throws {
		return Database.Execute(
			"INSERT INTO users (username, password) VALUES ('" + username + "', " + Utils.prepareEncrypt( password ) + ")"
		);
    }

}

