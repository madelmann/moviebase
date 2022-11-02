#!/usr/local/bin/webscript

// Library imports
import System.Collections.Range;

// Project imports
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;
import libs.Utils;


public object RenderPlugin extends ASessionPlugin implements IRenderPlugin {
	public void Constructor() {
		base.Constructor();
	}

	public void Render() {
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
	}

	private void ShowCollections() throws {
		print("<h5 class='align-left'>Collections");
		//if ( isAdmin() ) {
			StaticElement("+", "collection-tag", "mPlugin.ShowAddCollection();");
		//}
		print("</h5>");

		print( "
		<div id='collection-plugin' class='sub-plugin' hidden='true'></div>

		<ul id='collections'></ul>
		" );
	}

	private void ShowTags() {
		print( "<h5 class='align-left'>Tags" );
		if ( isAdmin() ) {
			StaticElement( "+", "tag-tag", "mPlugin.ShowAddTag();" );
		}
		print( "</h5>" );

		print( "
		<div id='tag-plugin' class='sub-plugin' hidden='true'></div>

		<ul id='tags'></ul>
		" );
	}

	private void ShowVideos( int page ) {
		print( "
		<h4>Videos</h4>

		<span>
			<div id='videos' class='gallery'></div>
		</span>
		" );
	}

	private void ShowVote() {
		print( "
		<h5>Vote</h5>

		<button id='vote_down' onclick='mPlugin.Vote(0);'>Thumbs down</button>
		<button id='vote_up' onclick='mPlugin.Vote(1);'>Thumbs up</button>
		" );
	}
}

