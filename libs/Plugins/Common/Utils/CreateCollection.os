
// library imports

// project imports
import libs.Database;


private bool CreateCollection(string identifier, string name) throws {
    if ( !name ) {
        return true;
    }

    string query = "INSERT INTO collections (identifier, name) VALUES ('" + identifier + "', '" + name + "')";

    int error = mysql_query(Database.Handle, query);
    if ( error ) {
        throw mysql_error(Database.Handle);
    }

    return true;
}

