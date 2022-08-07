
// library imports

// project imports
import Database;
import Database.Views.VUserSession;


public object Session {
// Public

	public int DEFAULT_SESSION_LENGTH const = 30 /*minutes*/;

	public static Session load( string sessionID ) modify throws {
		var query = "SELECT * FROM v_user_session WHERE id = '" + sessionID + "' AND (expires = 0 OR expires > NOW())";

		try {
			var s = new VUserSessionRecord( Database.Handle, query );

			var session = new Session();
			session.mId = s.Id;
			session.mIsAdmin = s.IsAdmin;
			session.mIsInfinite = !s.Expires;
			session.mIsValid = true;
			//session.mLanguage = s.Language;
			session.mUserIdentifier = s.Identifier;
			session.mUsername = s.Username;

			return session;
		}
		catch ( string e ) {
			//print( "Exception: " + e );
		}

		return Session null;
	}

	/*
	 * Default constructor
	 */
	public void Constructor() {
		// nothing to do here
	}

	/*
	 * Explicit constructor
	 */
	public void Constructor( string userIdentifier ) {
		mIsInfinite = false;
		mUserIdentifier = userIdentifier;
	}

	public void delete() modify throws {
		if ( !mId ) {
			// cannot delete an unset session id
			return;
		}

		var query = "DELETE FROM sessions WHERE id = '" + mId + "'";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}
	}

	public void extendValidity( int minutes = 15 ) modify throws {
		if ( !minutes ) {
			minutes = DEFAULT_SESSION_LENGTH;
		}

		var query = "UPDATE sessions SET expires = (NOW() + INTERVAL " + minutes + " MINUTE) WHERE id = '" + mId + "'";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}
	}

	public string getId() const {
		return mId;
	}

	public string getUserIdentifier() const {
		return mUserIdentifier;
	}

	public bool isAdmin() const {
		return mIsAdmin;
	}

	public bool isValid() const {
		return mIsValid;
	}

	public string language() const {
		return mLanguage;
	}

	public void setIsInfinite( bool state ) modify {
		mIsInfinite = state;
	}

	public bool store() modify throws {
		mId = fetchId();

		var query = "INSERT INTO sessions( id, identifier, expires ) " 
				  + "VALUES ( '" + mId + "', '" + mUserIdentifier + "', " + ( mIsInfinite ? "0" : "( NOW() + INTERVAL " + DEFAULT_SESSION_LENGTH + " MINUTE )" ) + " )";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}

	public string toString() const {
		return "Session { "
				+ "mIsAdmin: " + mIsAdmin
				+ ", mIsInfinite: " + mIsInfinite
				+ ", mIsValid: " + mIsValid
				+ ", mLanguage: " + mLanguage
				+ ", mSessionId: " + mId
				+ ", mUserIdentifier: " + mUserIdentifier
				+ ", mUsername: " + mUsername
				+ " }";
    }

	public string username() const {
		return mUsername;
	}

// Private

	private string fetchId() const throws {
		var query = "SELECT CreateSessionId( '" + mUserIdentifier + "' ) AS id";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		var result = mysql_store_result( Database.Handle );
		if ( !mysql_fetch_row( result ) ) {
			throw "no mysql result found!";
		}
		
		return mysql_get_field_value( result, "id" );
	}

	private string mId;
	private bool mIsAdmin;
	private bool mIsInfinite;
	private bool mIsValid;
	private string mLanguage;
	private string mUserIdentifier;
	private string mUsername;
}
