#!/usr/local/bin/webscript

// Library imports
import System.Collections.List;
import System.String;
import System.StringIterator;

// Project imports
import libs.Plugins.Common.ShowVideo;
import libs.Plugins.RenderPlugin;
import libs.UI.Controls;
import libs.Utils;


public object RenderPlugin implements IRenderPlugin {
	public void Render() {
		print( "<div class='video-wrapper'>" );

		if ( Utils.mIsAdmin ) {
			ShowVideo();

			EditableLabelWithStore("title", "", 12);
			print("<button id='cancel' class='cancel' hidden='true' onclick='mPlugin.HideAll();'>X</button>");

			ShowText();
			ShowActors();
			ShowCollections();
			ShowTags();
			ShowPrivate();
			ShowVote();

			print("<h4>Admin</h4>");
			print("<button id='delete' class='' onclick='mPlugin.HideVideo();'>Delete Video</button>");
			print("<button id='reset' class=''  onclick='mPlugin.ResetVideoVoting();'>Reset Voting</button>");
			print("</br></br>");
			StaticLabel("filename", "", 9);
		}
		else {
			ShowVideo();

			StaticLabel("title", "", 12);

			ShowText();
			ShowActors();
			ShowCollections();
			ShowTags();
			ShowPrivate();
			ShowVote();
		}

		print( "</div>" );
	}

	private void ShowActors() {
		print("<h5 class='align-left'>Actors");
		if ( Utils.mIsLoggedIn ) {
			StaticElement("+", "actor-tag", "mPlugin.ShowAddActor();");
		}
		print("</h5>");

		print( "
		<div id='actor-plugin' class='sub-plugin' hidden='true'></div>

		<ul id='actors'></ul>
		" );
	}

	private void ShowCollections() throws {
		print("<h5 class='align-left'>Collections");
		if ( Utils.mIsLoggedIn ) {
			StaticElement("+", "collection-tag", "mPlugin.ShowAddCollection();");
		}
		print("</h5>");

		print( "
		<div id='collection-plugin' class='sub-plugin' hidden='true'></div>

		<ul id='collections'></ul>
		" );
	}

	private void ShowPrivate() {
		print( "
			<h5 class='align-left'>Private
			<input id='is_private' type='checkbox' class='form-check-input' onclick='mPlugin.SetPrivate();' " + ( Utils.mIsAdmin ? "enabled" : "disabled" ) + ">
			</h5>
		" );
	}

	private void ShowTags() {
		print("<h5 class='align-left'>Tags");
		if ( Utils.mIsLoggedIn ) {
			StaticElement("+", "tag-tag", "mPlugin.ShowAddTag();");
		}
		print("</h5>");

		print( "
		<div id='tag-plugin' class='sub-plugin' hidden='true'></div>

		<ul id='tags'></ul>
		" );
	}

	private void ShowText() {
		if ( Utils.mIsLoggedIn ) {
			EditableTextAreaWithStore( "text", "text", "", 10);
		}
		else {
			StaticTextArea( "text", "", 10 );
		}
	}

	private void ShowVote() {
		print( "
		<div id='vote'>
			<img class='button icon' src='resources/images/thumbs_up.png' onclick='mPlugin.Vote(1);'>
			<img class='button icon' src='resources/images/thumbs_down.png' onclick='mPlugin.Vote(0);'>
		</div>
		" );
	}
}

