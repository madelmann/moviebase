
// library imports

// project imports
import libs.Consts.General;
import libs.Database;
import CreateCollection;


public bool RegisterUser(string username, string password) {
    try {
        Database.begin();   // start transaction

        if ( !InsertUser( username, password ) ) {
            throw "inserting new user '" + username + "' failed";
        }

        var id = Database.getLastInsertId();
        if ( !CreateFavoritesCollection( id ) ) {
            throw "creating favorites collection failed";
        }

        Database.commit();  // commit transaction

        return true;
    }
    catch {
        Database.rollback();    // rollback transaction
        throw;  // REMOVE ME!!!
    }

    return false;
}

public bool CreateFavoritesCollection( int id ) {
    return Database.Execute( "INSERT INTO collections ( identifier, name ) VALUES ( " + Utils.getIdentifierFromID( id ) + ", '" + FAVORITES_COLLECTION + "' )" );
}

public bool InsertUser(string username, string password) {
    return Database.Execute( "INSERT INTO users (username, password) VALUES ('" + username + "', " + Utils.prepareEncrypt(password) + ")" );
}

