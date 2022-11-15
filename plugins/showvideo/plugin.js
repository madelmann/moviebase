
mPlugin = {

OnAbort: function(event) {
	// request execution failed
	alert( "OnAbort: " + event.currentTarget.responseText );
},

OnError: function(event) {
	// request execution failed
	alert( "OnError: " + event.currentTarget.responseText );
},

OnLoad: function( callback ) {
	this.pluginName = "showvideo";

	mElActorPlugin = document.getElementById("actor-plugin");
	mElActors = document.getElementById("actors");
	mElCollectionPlugin = document.getElementById("collection-plugin");
	mElCollections = document.getElementById("collections");
	mElFilename = document.getElementById("filename_label");
	mElIsPrivate = document.getElementById("is_private");
	mElTitle = document.getElementById("title_label");
	mElTagPlugin = document.getElementById("tag-plugin");
	mElTags = document.getElementById("tags");
	mElText = document.getElementById("text_label");
	mElVideoPlayer = document.getElementById("videoplayer");

	mActorPlugin = null;
	mCollectionPlugin = null;
	mImageBrowser = null;
	mTagPlugin = null;
	mVideoId = Parameters.get("itemID");
	mVideoReadyCallback = callback;

	this.OnLoadReady();
},

OnLoadReady: function() {
	this.RequestItemData( Parameters.get( "itemID" ) );
},

OnLoadSuccess: function(event) {
	var response = {};

	if ( ParseJSON(event.currentTarget.responseText, response) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			mPlugin.FillItemData(response.message);
		}
	}
	else {
		// error while parsing json string
		alert(response.message);
	}
},

OnSuccess: function(event) {
	var response = {};

	if ( ParseJSON(event.currentTarget.responseText, response) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			History.Refresh();
		}
	}
	else {
		// error while parsing json string
		alert(response.message);
	}
},

OnActorPluginReady: function() {
	mElActorPlugin.hidden = false;
},

OnActorSelected: function(actor) {
	if ( mVideoId == -1 ) {
		// invalid video id set
		return;
	}

	mElActorPlugin.hidden = true;

	Parameters.clear();
	Parameters.add("id", mVideoId);
	Parameters.add("actor", actor);

	execute("showvideo/addActor.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort);
},

OnCollectionPluginReady: function() {
	mElCollectionPlugin.hidden = false;
},

OnCollectionSelected: function(collectionID) {
	if ( mVideoId == -1 ) {
		// invalid video id set
		return;
	}

	mElCollectionPlugin.hidden = true;

	Parameters.clear();
	Parameters.add("collectionID", collectionID);
	Parameters.add("itemID", mVideoId);

	execute("showvideo/insertCollectionItem.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort);
},

OnTagPluginReady: function() {
	mElTagPlugin.hidden = false;
},

OnTagSelected: function(tag) {
	if ( mVideoId == -1 ) {
		// invalid video id set
		return;
	}

	mElTagPlugin.hidden = true;

	Parameters.clear();
	Parameters.add("id", mVideoId);
	Parameters.add("tag", tag);

	execute("showvideo/addTag.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort);
},

OnUpdateSuccess: function(event) {
	// request execution was successful

	var response = {};
	if ( ParseJSON(event.currentTarget.responseText, response) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			// this needs to be activated as soon as all data is loaded via JavaScript
			mPlugin.RequestItemData(mVideoId);
		}
		else {
			//alert("An error occured while updating the current video!");
			alert( "Error: " + response.message.message );
		}
	}
	else {
		// error while parsing json string
		alert( response.message );
	}
},

FillItemData: function(data) {
	if ( !data ) {
		// invalid data received!
		return;
	}

	if ( data.actors ) {
		// display actors
		mElActors.innerHTML = "";

		for ( var idx = 0; idx < data.actors.length; idx++ ) {
			mElActors.innerHTML += RenderActor( mVideoId, data.actors[idx] );
		}
	}
	if ( data.collections ) {
		// display collections
		mElCollections.innerHTML = "";

		for ( var idx = 0; idx < data.collections.length; idx++ ) {
			mElCollections.innerHTML += RenderCollectionItem( null, data.collections[idx] );
		}
	}
	if ( data.filename ) {
		if ( mElFilename ) {
			mElFilename.textContent = "Filename: " + data.filename;
		}

		if ( !mElVideoPlayer.src ) {
			mElVideoPlayer.src = data.filename;

			if ( Cache.Stats && Cache.Stats.remote_storage ) {
				mElVideoPlayer.src = Cache.Stats.remote_storage + data.filename;
			}
		}
	}
	if ( data.is_private ) {
		mElIsPrivate.checked = data.is_private;
	}
	if ( data.tags ) {
		// display tags
		mElTags.innerHTML = "";

		for ( var idx = 0; idx < data.tags.length; idx++ ) {
			mElTags.innerHTML += RenderTag( mVideoId, data.tags[idx] );
		}
	}
	if ( data.text ) {
		mElText.textContent = data.text;
	}
	if ( data.title ) {
		mElTitle.textContent = data.title;
	}
	if ( data.thumbnail && !mElVideoPlayer.poster.includes( data.thumbnail ) ) {
		mElVideoPlayer.poster = data.thumbnail;
	}

	if ( mVideoReadyCallback ) {
		mVideoReadyCallback();
	}
},

Hide: function( element ) {
	this.SetVisibility( element, false );
},

HideAll: function() {
	this.Hide( "title" );

	// nothing else to hide
},

HideVideo: function() {
	Parameters.clear();
	Parameters.add("itemID", mVideoId);

	execute("showvideo/hideVideo.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort);

	LoadPlugin("home");
},

IncrementViewCount: function() {
	Parameters.clear();
	Parameters.add("itemID", mVideoId);

	execute("showvideo/incrementViewCount.os");
},

RemoveActor: function(id, actor) {
	if ( !id ) {
		return false;
	}

	Parameters.clear();
	Parameters.add("actor", actor);
	Parameters.add("id", id);

	execute("showvideo/removeActor.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort);
},

RemoveCollection: function(id) {
	if ( !id ) {
		return false;
	}

	Parameters.clear();
	Parameters.add("id", id);

	execute("showvideo/removeCollectionItem.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort);
},

RemoveTag: function(id, tag) {
	if ( !id ) {
		return false;
	}

	Parameters.clear();
	Parameters.add("id", id);
	Parameters.add("tag", tag);

	execute("showvideo/removeTag.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort);
},

RequestItemData: function(itemID) {
	Parameters.clear();
	Parameters.add("itemID", itemID);

	execute("showvideo/loadItem.os", mPlugin.OnLoadSuccess, mPlugin.OnError, mPlugin.OnAbort);
},

ResetVideoVoting: function() {
	Parameters.clear();
	Parameters.add("itemID", mVideoId);

	execute("showvideo/resetVideoVoting.os", mPlugin.OnUpdateSuccess, mPlugin.OnError, mPlugin.OnAbort);
},

SearchActor: function(actor) {
	// search for the given actor
	Search(actor);
},

SearchTag: function( tag ) {
	// search for the given tag
	SearchTag( tag );
},

SetPrivate: function() {
	Parameters.clear();
	Parameters.add("itemID", mVideoId);
	Parameters.add("is_private", mElIsPrivate.checked ? 1 : 0);

	execute("showvideo/updateVideo.os", null, OnError, OnAbort);
},

SetVisibility: function( name, state ) {
	if ( !name ) {
		return;         // invalid name provided
	}

	//var elCancel = document.getElementById("cancel");
	var elLabel = document.getElementById(name + "_label");
	var elInput = document.getElementById(name + "_input");
	var elSave = document.getElementById(name + "_save");

	if ( elSave.hidden ) {
		//elCancel.hidden = false;
		elInput.value = elLabel.textContent;
	}
	else {
		elLabel.textContent = elInput.value;
	}

	//elCancel.hidden = !state;
	elLabel.hidden = state;
	elInput.hidden = !state;
	elSave.hidden = !state;
},

Show: function( element ) {
	this.SetVisibility( element, true );
},

ShowActor: function( actor ) {
	Parameters.clear();
	Parameters.add( "actor", actor );

	LoadPluginWithHistory( "showactor" );
},

ShowAddActor: function() {
	if ( !mElActorPlugin.hidden ) {
		mElActorPlugin.hidden = true;
		return;
	}

	Parameters.clear();
	Parameters.add("allowDelete", false);
	Parameters.add("allowSearch", false);
	Parameters.add("showAll", true);

	LoadPluginInto("actors", mElActorPlugin, this.OnActorPluginReady, this.OnActorSelected);
},

ShowAddCollection: function() {
	if ( !mElCollectionPlugin.hidden ) {
		mElCollectionPlugin.hidden = true;
		return;
	}

	Parameters.clear();
	Parameters.add("allowDelete", false);
	Parameters.add("allowSearch", false);

	LoadPluginInto("collections", mElCollectionPlugin, this.OnCollectionPluginReady, this.OnCollectionSelected);
},

ShowAddTag: function() {
	if ( !mElTagPlugin.hidden ) {
		mElTagPlugin.hidden = true;
		return;
	}

	Parameters.clear();
	Parameters.add("allowDelete", false);
	Parameters.add("allowSearch", false);

	LoadPluginInto("tags", mElTagPlugin, this.OnTagPluginReady, this.OnTagSelected);
},

ShowCollection: function(id) {
	if ( !id ) {
		return;
	}

	Parameters.clear();
	Parameters.add("collectionID", id);

	LoadPluginWithHistory("showcollection");
},

Store: function(name) {
	if ( !name ) {
		return;         // invalid name provided
	}

	var elInput = document.getElementById(name + "_input");

	Parameters.clear();
	Parameters.add("itemID", mVideoId);
	Parameters.add(name, elInput.value);

	execute("showvideo/updateVideo.os", this.OnUpdateSuccess, OnError, OnAbort);

	this.Swap(name);
},

Swap: function(name) {
	if ( !name ) {
		return;         // invalid name provided
	}

	//var elCancel = document.getElementById("cancel");
	var elLabel = document.getElementById(name + "_label");
	var elInput = document.getElementById(name + "_input");
	var elSave = document.getElementById(name + "_save");

	if ( elSave.hidden ) {
		//elCancel.hidden = false;
		elInput.value = elLabel.textContent;
	}
	else {
		elLabel.textContent = elInput.value;
	}

	//elCancel.hidden = !elCancel.hidden;
	elLabel.hidden = !elLabel.hidden;
	elInput.hidden = !elInput.hidden;
	elSave.hidden = !elSave.hidden;
},

Vote: function(value) {
	Parameters.clear();
	Parameters.add("itemID", mVideoId);
	Parameters.add("rating", value);

	execute("showvideo/updateVideo.os", null, OnError, OnAbort);
}

}

mCurrentPlugin = mPlugin;

