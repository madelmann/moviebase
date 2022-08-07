
function AddItemToFavorites( itemID ) {
	Parameters.clear();
	Parameters.add( "itemID", itemID );

	execute( "admin/addItemToFavorites.os", History.Refresh, OnError, OnAbort );
}


mPlaylistPlugin = {

OnAbort: function( event ) {
	// request execution failed
	alert( "OnAbort: " + event.currentTarget.responseText );
},

OnError: function( event ) {
	// request execution failed
	alert( "OnError: " + event.currentTarget.responseText );
},

OnLoad: function() {
	this.mPluginName = "showcollection";

	mElVideoPlugin = document.getElementById( "result" );
	mElVideoPlayer = null;

	mCollectionID = Parameters.get( "collectionID" );
	mCollectionItemID = Parameters.get( "collectionItemID" );
	mCollectionItems = null;

	if ( !mCollectionItemID ) {
		mCollectionItemID = 0;
	}

	this.OnLoadReady();
},

OnLoadReady: function() {
	this.RequestCollectionData( mCollectionID );
},

OnLoadSuccess: function( event ) {
	var response = {};

	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			mPlaylistPlugin.FillCollectionData( response.message );
		}
	}
	else {
		// error while parsing json string
		alert( response.message );
	}
},

OnSuccess: function( event ) {
	var response = {};

	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			History.Refresh();
		}
	}
	else {
		// error while parsing json string
		alert( response.message );
	}
},

OnUpdateSuccess: function( event ) {
	// request execution was successful
	//alert("OnSuccess: " + event.currentTarget.responseText);

	var response = {};

	if ( ParseJSON(event.currentTarget.responseText, response) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			History.Refresh();
		}
	}
	else {
		// error while parsing json string
		alert( response.message );
	}
},

OnVideoEnded: function( event ) {
	//alert( "OnVideoEnded" );
},

OnVideoLoaded: function( event ) {
	//alert( "OnVideoLoaded" );
},

OnVideoReady: function( event ) {
	//alert( "OnVideoReady" );

	mElVideoPlayer = document.getElementById( "videoplayer" );
	mElVideoPlayer.addEventListener( "ended", mPlaylistPlugin.PlayNextItem, false );
	mElVideoPlayer.play();
},

FillCollectionData: function( data ) {
	if ( !data ) {
		// invalid data received!
		return;
	}

	mCollectionID = data.collectionID;

	if ( data.items ) {
		mCollectionItems = data.items;
	}
	if ( data.name ) {
		// display name
		mElName.textContent = data.name;
	}
	if ( data.tags ) {
		// display tags
		mElTags.innerHTML = "";

		for ( var idx = 0; idx < data.tags.length; idx++ ) {
			mElTags.innerHTML += RenderTag( mCollectionID, data.tags[idx] );
		}
	}

	if ( mCollectionItems && mCollectionItemID !== null ) {
		mPlaylistPlugin.ShowCollectionItem( mCollectionItemID );
	}
},

PlayNextItem: function( event ) {
	if ( mCollectionItemID >= mCollectionItems.length - 1 ) {
		return;
	}

	Parameters.clear();
	Parameters.add( "collectionID", mCollectionID );
	Parameters.add( "collectionItemID", mCollectionItemID + 1 );

	LoadPlugin( "playlist" );
},

RequestCollectionData: function( collectionID ) {
	Parameters.clear();
	Parameters.add( "collectionID", collectionID );

	execute( "admin/loadCollection.os", this.OnLoadSuccess, OnError, OnAbort );
},

ShowCollectionItem: function( collectionItemID ) {
	// update currently played item index
	mCollectionItemID = collectionItemID;

	// set style sheets for playlist items based on currently selected item
	var items = document.getElementsByClassName( "playlist-item" );
	var idx = 0;
	Array.from(items).forEach( element => {
		if ( idx < mCollectionItemID ) {
			element.classList.add( "playlist-item-played" );
			element.classList.remove( "playlist-item-playing" );
			element.classList.remove( "playlist-item-unplayed" );
		}
		else if ( idx == mCollectionItemID ) {
			element.classList.remove( "playlist-item-played" );
			element.classList.add( "playlist-item-playing" );
			element.classList.remove( "playlist-item-unplayed" );
		}
		else {
			element.classList.remove( "playlist-item-played" );
			element.classList.remove( "playlist-item-playing" );
			element.classList.add( "playlist-item-unplayed" );
		}

		idx++;
	});

	// open video

	Parameters.clear();
	Parameters.add( "collectionID", mCollectionID );
	Parameters.add( "collectionItemID", mCollectionItemID );
	Parameters.add( "itemID", mCollectionItems[mCollectionItemID] );

	LoadPluginInto( "showvideo", mElVideoPlugin, null, mPlaylistPlugin.OnVideoReady );
}

};

mCurrentPlugin = mPlaylistPlugin;

