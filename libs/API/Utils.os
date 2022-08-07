
// Library imports

// Project imports
import libs.Database.Tables.Users;
import libs.Database.Utils;


public namespace API {

    public void require( string key ) throws {
        if ( !isSet( key ) ) {
            throw "missing " + key;
        }
    }

    public string retrieve( string key ) throws {
        if ( isSet( key ) ) {
            return mysql_real_escape_string( Database.Handle, get( key ) );
        }

        throw "missing " + key;
    }

    public bool retrieve( string key, bool defaultValue ) {
        if ( isSet( key ) ) {
            return cast<bool>( mysql_real_escape_string( Database.Handle, get( key ) ) );
        }

        return defaultValue;
    }

    public double retrieve( string key, double defaultValue ) {
        if ( isSet( key ) ) {
            return cast<double>( mysql_real_escape_string( Database.Handle, get( key ) ) );
        }

        return defaultValue;
    }

    public float retrieve( string key, float defaultValue ) {
        if ( isSet( key ) ) {
            return cast<float>( mysql_real_escape_string( Database.Handle, get( key ) ) );
        }

        return defaultValue;
    }

    public int retrieve( string key, int defaultValue ) {
        if ( isSet( key ) ) {
            return cast<int>( mysql_real_escape_string( Database.Handle, get( key ) ) );
        }

        return defaultValue;
    }

    public string retrieve( string key, string defaultValue ) {
        if ( isSet( key ) ) {
            return mysql_real_escape_string( Database.Handle, get( key ) );
        }

        return defaultValue;
    }

    public TUsersRecord GetUserProfile( string identifier ) throws {
        if ( mProfile ) {
            return mProfile;
        }

        var profile = new TUsersRecord( Database.Handle );
        profile.loadByQuery( "SELECT * FROM users WHERE identifier = '" + identifier + "'" );

        mProfile = profile;

        return profile;
    }

    public bool IsAdmin( string identifier ) throws {
        var profile = GetUserProfile( identifier );

        return profile.IsAdmin == 1;
    }

    public void RequireAdminRights() throws {
        var identifier = retrieve( "identifier" );

        if ( !IsAdmin( identifier ) ) {
            throw "permission denied";
        }
    }

    private TUsersRecord mProfile = null;
}

