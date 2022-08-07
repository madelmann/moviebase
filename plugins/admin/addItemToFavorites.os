#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Consts.General;
import libs.Plugins.ExecutePlugin;
import libs.Utils.SessionTools;


public object ExecutePlugin implements IExecutePlugin {
    public bool Execute() throws {
        if ( !isSet( "identifier" ) ) {
            throw "identifier is missing";
        }
        if ( !isSet( "itemID" ) ) {
            throw "itemID is missing";
        }

        var identifier = mysql_real_escape_string( Database.Handle, get( "identifier" ) );
        if ( !identifier ) {
            throw "invalid identifier provided";
        }

        var itemID = mysql_real_escape_string( Database.Handle, get( "itemID" ) );
        if ( !itemID ) {
            throw "invalid itemID provided";
        }

        return AddItemToFavorites( identifier, itemID );
    }

    private bool AddItemToFavorites( string identifier, string itemID ) throws {
        return Database.Execute(
            "INSERT INTO collection_items (collection_id, item_id) SELECT id, " + itemID + " FROM collections WHERE identifier = '" + identifier + "' and name = '" + FAVORITES_COLLECTION + "'"
        );
    }
}
