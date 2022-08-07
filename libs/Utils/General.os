
// library imports

// project imports


public namespace Utils {

	public bool mDebug = false;
	public bool mIsAdmin = false;
	public bool mIsLoggedIn = false;
	public string mUserIdentifier;

	public int calcPercent( int value, int count ) const {
		if ( count <= 0 ) {
			return 0;
		}
	
		return cast<int>( 100.f * cast<float>( value ) / cast<float>( count ) );
	}

	public string getIdentifierFromID( int id, int strength = 256 ) const {
		return "SHA2(" + id + ", " + strength + ")";
	}

	public void parseParameters() modify {
		if ( isSet( "admin" ) ) {
			mIsAdmin = ( get( "admin" ) == "1" );
			mIsLoggedIn = mIsAdmin;
		}
		if ( isSet( "debug" ) ) {
			mDebug = ( get( "debug" ) == "1" );
		}
		if ( isSet( "identifier" ) ) {
			mUserIdentifier = get( "identifier" );
			mIsLoggedIn = cast<bool>( mUserIdentifier );
		}
	}

	public string prepareRating( int value, int count ) const {
		return cast<string>( calcPercent( value, count ) ) + "%";
	}

	public string prepareEncrypt( string text, int strength = 256 ) const {
		return "SHA2('" + text + "', " + strength + ")";
	}

}

