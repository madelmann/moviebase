
function AddItemToFavorites( itemID ) {
	Parameters.clear();
	Parameters.add( "itemID", itemID );

	execute( "admin/addItemToFavorites.os", History.Refresh, OnError, OnAbort );
}


mPlugin = {

OnAbort: function(event) {
	// request execution failed
	alert( "OnAbort: " + event.currentTarget.responseText );
},

OnError: function(event) {
	// request execution failed
	alert( "OnError: " + event.currentTarget.responseText );
},

OnLoad: function() {
	this.pluginName = "showcollection";

	mElCollectionPlugin = document.getElementById( "collection-plugin" );
	mElCollections = document.getElementById( "collections" );
	mElName = document.getElementById( "name_label" );
	mElVideos = document.getElementById( "videos" );
	mElTagPlugin = document.getElementById( "tag-plugin" );
	mElTags = document.getElementById( "tags" );

	mCollectionID = Parameters.get( "collectionID" );
	mCollectionName = null;
	mImageBrowser = null;
	mTagPlugin = null;

	this.OnLoadReady();
},

OnLoadReady: function() {
	// load collection data
	this.RequestCollectionData( mCollectionID );
},

OnLoadSuccess: function( event ) {
	var response = {};

	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			mPlugin.FillCollectionData( response.message );
		}
	}
	else {
		// error while parsing json string
		//alert( response.message );
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

OnTagPluginReady: function() {
	mElTagPlugin.hidden = false;
},

OnTagSelected: function( tag ) {
	if ( !mCollectionID ) {
		return;
	}

	mElTagPlugin.hidden = true;

	Parameters.clear();
	Parameters.add( "collectionID", mCollectionID );
	Parameters.add( "tag", tag );

	execute( "admin/addCollectionTag.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

OnUpdateSuccess: function(event) {
	// request execution was successful

	var response = {};

	if ( ParseJSON(event.currentTarget.responseText, response) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			History.Refresh();
		}
		else {
			alert("An error occured while updating the current video!");
		}
	}
	else {
		// error while parsing json string
		alert(response.message);
	}
},

FillCollectionData: function( data ) {
	if ( !data ) {
		// invalid data received!
		return;
	}

	mCollectionID = data.collectionID;
	mCollectionName = data.name;

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
},

Hide: function( element ) {
	mPlugin.SetVisibility( element, false );
},

HideAll: function() {
	var hide = document.getElementsByClassName("hidden");
	for ( var i = 0; i < hide.length; i++ ) {
		hide[i].hidden = true;
	}

	var show = document.getElementsByClassName("shown");
	for ( var i = 0; i < show.length; i++ ) {
		show[i].hidden = false;
	}
},

RemoveTag: function( collectionID, tag ) {
	if ( !tag ) {
		return false;
	}

	Parameters.clear();
	Parameters.add( "collectionID", collectionID );
	Parameters.add( "tag", tag );

	execute( "admin/removeCollectionTag.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

RequestCollectionData: function( collectionID ) {
	Parameters.clear();
	Parameters.add( "collectionID", collectionID );

	execute( "admin/loadCollection.os", this.OnLoadSuccess, OnError, OnAbort );
},

ResetVideoVoting: function() {
	Parameters.clear();
	Parameters.add( "collectionID", mCollectionID );

	execute( "admin/resetCollectionVoting.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

SearchTag: function( tag ) {
	// search for the given tag
	SearchTag( tag );
},

SetVisibility: function( name, state ) {
	if ( !name ) {
		return;         // invalid name provided
	}

	var elCancel = document.getElementById( "cancel" );
	var elLabel = document.getElementById( name + "_label" );
	var elInput = document.getElementById( name + "_input" );
	var elSave = document.getElementById( name + "_save" );

	if ( elSave.hidden ) {
		elCancel.hidden = false;
		elInput.value = elLabel.textContent;
	}
	else {
		elLabel.textContent = elInput.value;
	}

	elLabel.hidden = state;
	elInput.hidden = !state;
	elSave.hidden = !state;
},

Show: function( element ) {
	mPlugin.SetVisibility( element, true );
},

ShowAddTag: function() {
	if ( !mElTagPlugin.hidden ) {
		mElTagPlugin.hidden = true;
		return;
	}

	Parameters.clear();
	Parameters.add( "allowDelete", false );
	Parameters.add( "allowSearch", false );

	LoadPluginInto( "tags", mElTagPlugin, mPlugin.OnTagPluginReady, mPlugin.OnTagSelected );
},

ShowCollectionItem: function( collectionID, collectionItemID ) {
	// open video

	Parameters.clear();
	Parameters.add( "collectionID", collectionID );
	Parameters.add( "collectionItemID", collectionItemID );

	LoadPluginWithHistory( "playlist" );
},

ShowPage: function( page ) {
	// show a specific page

	var collectionID = Parameters.get( "collectionID" );

	Parameters.clear();
	Parameters.add( "collectionID", collectionID );
	Parameters.add( "page", page );

	LoadPluginWithHistory( "showcollection" );
},

ShowVideo: function( videoID ) {
	// open video

	Parameters.clear();
	Parameters.add( "itemID", videoID );

	LoadPluginWithHistory( "showvideo" );
},

Store: function( name ) {
	if ( !name ) {
		return;
	}

	var elInput = document.getElementById( name + "_input" );

	Parameters.clear();
	Parameters.add( "collectionID", mCollectionID );
	Parameters.add( name, elInput.value );

	execute( "admin/updateCollection.os", this.OnUpdateSuccess, OnError, OnAbort );

	mPlugin.Swap( name );
},

Swap: function( name ) {
	if ( !name ) {
		return;		// invalid name provided
	}

	var elLabel = document.getElementById( name + "_label" );
	var elInput = document.getElementById( name + "_input" );
	var elSave = document.getElementById( name + "_save" );

	if ( elSave.hidden ) {
		elInput.value = elLabel.textContent;
	}
	else {
		elLabel.textContent = elInput.value;
	}

	elLabel.hidden = !elLabel.hidden;
	elInput.hidden = !elInput.hidden;
	elSave.hidden = !elSave.hidden;
},

Vote: function( value ) {
	Parameters.clear();
	Parameters.add( "collectionID", mCollectionID );
	Parameters.add( "rating", value );

	execute( "admin/updateCollection.os", this.OnUpdateSuccess, OnError, OnAbort );
}

};

mCurrentPlugin = mPlugin;

