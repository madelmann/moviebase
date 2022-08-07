#!/usr/local/bin/webscript

// Library imports
import System.Collections.Range;
import System.Exception;

// Project imports
import libs.Consts.General;
import libs.Plugins.Common.ShowVideo;
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;


public object RenderPlugin implements IRenderPlugin {
	public void Constructor() throws {
		if ( !isSet( "collectionID" ) ) {
			return;
		}

		mCollectionID = mysql_real_escape_string( Database.Handle, get( "collectionID" ) );

		if ( isSet( "collectionItem" ) ) {
			mCollectionItem = cast<int>( mysql_real_escape_string( Database.Handle, get( "collectionItem" ) ) );
		}
	}

	public void Render() {
		if ( !mCollectionID ) {
			return;
		}

		StaticLabel( "name", "", 20 );

		ShowVideos();
		ShowItem();
	}

	private void ShowItem() {
		print( "
		<span>
			<div id='result'></div>
		</span>
		" );
	}

	private void ShowVideos() throws {
		print( "
		<h4>Videos</h4>

		<span>
			<div id='videos' class='playlist'>
		" );

		{ // initialize "rownum" variable
			string query = "SET @rownum := 0";

			int error = mysql_query( Database.Handle, query );
			if ( error ) {
				throw mysql_error( Database.Handle );
			}
		}

		string query = "SELECT @rownum := (@rownum + 1) AS num, i.actors, i.filename, i.id, @rownum - 1 AS item_id, i.md5sum, i.rating_count, i.rating_value, i.title, i.views "
						+ "FROM collection_items ci "
						+ "JOIN items i ON (ci.item_id = i.id) "
						+ "WHERE ci.collection_id = " + mCollectionID + " AND i.deleted = false ORDER BY ci.id ASC";

		int error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		int result = mysql_store_result( Database.Handle );
		while ( mysql_fetch_row( result ) ) {
			string id = mysql_get_field_value( result, "id" );
			string itemID = mysql_get_field_value( result, "item_id" );
			string md5sum = mysql_get_field_value( result, "md5sum" );
			string title = substr( mysql_get_field_value( result, "title" ), 0, 42 );

			ShowPlaylistItem( itemID, md5sum, title, /*Utils.mIsLoggedIn*/ false );
		}

		print( "
			</div>
		</span>
		" );
	}

	private string mCollectionID;
	private int mCollectionItem;
}

