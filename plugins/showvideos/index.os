#!/usr/local/bin/webscript

// Library includes
import System.Exception;

// Project includes
import libs.Plugins.RenderPlugin;
import libs.Utils;


public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Constructor() {
		base.Constructor();
	}

	public void Render() {
		string sortBy = "title";
		if ( isSet( "sortBy" ) ) {
			sortBy = mysql_real_escape_string( Database.Handle, get( "sortBy" ) );
		}

		ShowVideos( sortBy );
	}

	public void ShowVideo( int result ) {
		var id = mysql_get_field_value( result, "id" );
		var rating_count = cast<int>( mysql_get_field_value( result, "rating_count" ) );
		var rating_value = cast<int>( mysql_get_field_value( result, "rating_value" ) );
		var tags = mysql_get_field_value( result, "tags" );
		var title = mysql_get_field_value( result, "title" );
		var views = mysql_get_field_value( result, "views" );

		print( "<tr>" );
		print( "<td onclick='mPlugin.ShowVideo( " + id + " );'>" + title + "</td>" );
		print( "<td>" + views + "</td>" );
		print( "<td>" + Utils.prepareRating( rating_value, rating_count ) + "</td>" );
		//print( "<td>" + tags + "</td>" );
		if ( isAdmin() ) {
		print( "<td><button onclick='mPlugin.HideVideo( " + id + " );'>X</button>" );
		}
		print( "</tr>" );
	}

	public void ShowVideos( string sortBy ) throws {
		var query = "SELECT id, rating_count, rating_value, tags, title, views FROM items WHERE deleted = false";
		if ( Utils.mIsLoggedIn ) {
			query += " AND ( is_private = FALSE OR owner = '" + Utils.mUserIdentifier + "' )";
		}
		else {
			query += " is_private = FALSE";
		}
		query += " ORDER BY " + sortBy + " ASC";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		var result = mysql_store_result( Database.Handle );
		if ( !result ) {
			throw mysql_error( Database.Handle );
		}

		var numResults = mysql_row_count( result );

		print( "<table>" );
		print( "<tr>" );
		print( "<th onlick='mPlugin.SortByTitle();'>Title</th>" );
		print( "<th onlick='mPlugin.SortByViews();'>Views</th>" );
		print( "<th onlick='mPlugin.SortByRating();'>Rating</th>" );
		//print( "<th>Tags</th>" );
		if ( isAdmin() ) {
		print( "<th></th>" );
		}
		print( "</tr>" );

		while ( mysql_fetch_row( result ) ) {
			ShowVideo( result );
		}

		print( "</table>" );
		print( "</br>" );
		print( "<label>Results: " + numResults + "<label>" );
	}
}

