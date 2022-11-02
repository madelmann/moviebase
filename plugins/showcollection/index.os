#!/usr/local/bin/webscript

// Library imports
import System.Collections.Range;
import System.Exception;

// Project imports
import libs.Consts.General;
import libs.Plugins.Common.ShowVideo;
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;


public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Constructor() throws {
		base.Constructor();

		if ( !isSet( "collectionID" ) ) {
			return;
		}

		mCollectionID = mysql_real_escape_string( Database.Handle, get( "collectionID" ) );
	}

	public void Render() {
		if ( !mCollectionID ) {
			return;
		}

		int page = 1;
		if ( isSet( "page" ) ) {
			page = cast<int>( mysql_real_escape_string( Database.Handle, get( "page" ) ) );
		}

		if ( isAdmin() ) {
			print( "<button id='cancel' class='cancel' hidden='true' onclick='mPlugin.HideAll();'>X</button>" );
			EditableLabelWithStore( "name", "", 20 );
		}
		else {
			StaticLabel( "name", "", 20 );
		}

		ShowTags();
		//ShowVote();
		ShowVideos( page );
		ShowPages( page );
	}

	private int getNumPages() throws {
		var query = "SELECT count(*) AS num_items FROM collection_items WHERE collection_id = " + mCollectionID;
		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		var result = mysql_store_result( Database.Handle );
		if ( mysql_fetch_row( result ) ) {
			var numItems = cast<int>( mysql_get_field_value( result, "num_items" ) );

			return (numItems / NUM_VIDEOS_PER_PAGE) + 1;
		}

		return 1;
	}

	private void ShowPages( int currentPage ) {
		print( "<div class='pagination3'>" );
		print( "<ul class='firstPage'>" );
		
		int numPages = getNumPages();
		foreach ( int pageNum : 1..numPages ) {	
			if (
				pageNum != 1 && pageNum != numPages								// first and last page will always be visible
				&& (pageNum < currentPage - 2 || pageNum > currentPage + 2)		// 2 pages left and right of current page will always be visible
				&& pageNum % 20 != 0											// every 20th page will always be visible
			) {
				continue;
			}

			if ( pageNum == currentPage ) {
				print( "<li class='page_current'><a class='orangeButton' onclick='mPlugin.ShowPage(" + pageNum + ");'>" + pageNum + "</a></li>" );
			}
			else {
				print( "<li class='page_number'><a class='greyButton' onclick='mPlugin.ShowPage(" + pageNum + ");'>" + pageNum + "</a></li>" );
			}
		}

		print( "</ul>" );
		print( "</div>" );
	}

	private void ShowTags() {
		print( "<h4 class='align-left'>Tags" );
		if ( isAdmin() ) {
			StaticElement("+", "tag-tag", "mPlugin.ShowAddTag();");
		}
		print( "</h4>" );

		print( "
		<div id='tag-plugin' class='sub-plugin' hidden='true'></div>

		<ul id='tags'></ul>
		" );
	}

	private void ShowVideos( int page ) throws {
		print( "
		<h4>Videos</h4>

		<span>
			<div id='videos' class='gallery'>
		" );

		{ // initialize "rownum" variable
			var query = "SET @rownum := 0";

			var error = mysql_query( Database.Handle, query );
			if ( error ) {
				throw mysql_error( Database.Handle );
			}
		}

		var query = "SELECT @rownum := (@rownum + 1) AS num, i.actors, i.filename, i.id, i.md5sum, i.rating_count, i.rating_value, i.title, i.views, ci.collection_id, ci.item_id "
				  + "FROM collection_items ci "
				  + "JOIN items i ON (ci.item_id = i.id) "
				  + "WHERE ci.collection_id = " + mCollectionID + " AND i.deleted = false ORDER BY ci.id ASC";

		if ( page > 0 ) {
			// only display a specific page
			query = "SELECT * FROM (" + query + ") AS data WHERE num > " + (page - 1) * NUM_VIDEOS_PER_PAGE + " AND num <= " + page * NUM_VIDEOS_PER_PAGE;
		}

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		var result = mysql_store_result( Database.Handle );
		while ( mysql_fetch_row( result ) ) {
			var collectionID = mysql_get_field_value( result, "collection_id" );
			var collectionItemID = cast<int>( mysql_get_field_value( result, "num" ) ) - 1;
			var id = mysql_get_field_value( result, "id" );
			var md5sum = mysql_get_field_value( result, "md5sum" );
			var num = cast<int>( mysql_get_field_value( result, "num" ) );
			var rating_count = cast<int>( mysql_get_field_value( result, "rating_count" ) );
			var rating_value = cast<int>( mysql_get_field_value( result, "rating_value" ) );
			var title = substr( mysql_get_field_value( result, "title" ), 0, 42 );
			var views = mysql_get_field_value( result, "views" );

			ShowCollectionItem( collectionID, collectionItemID, id, md5sum, Utils.prepareRating( rating_value, rating_count ), title, views, Utils.mIsLoggedIn );
		}

		print( "
			</div>
		</span>
		" );
	}

	private void ShowVote() {
		print( "
		<h4>Vote</h4>

		<button id='vote_down' onclick='mPlugin.Vote(0);'>Thumbs down</button>
		<button id='vote_up' onclick='mPlugin.Vote(1);'>Thumbs up</button>
		" );
	}

	private string mCollectionID;
}

