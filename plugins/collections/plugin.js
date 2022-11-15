
mCollectionsPlugin = {

OnAbort: function(event) {
	// request execution aborted
	alert("OnAbort: " + event.currentTarget.responseText);
},

OnError: function(event) {
	// request execution failed
	alert("OnError: " + event.currentTarget.responseText);
},

OnLoad: function(callback) {
	this.mCallback = callback;
	this.pluginName = "collections";

	Parameters.add("allowDelete", Account.IsLoggedIn());
	Parameters.add("allowSearch", true);

	OnLoadReady();
},

OnLoadReady: function() {
},

OnSuccess: function(event) {
	// request execution was successful

	var response = {};
	if ( ParseJSON(event.currentTarget.responseText, response) ) {
		// json string has been parsed successfully
		History.Refresh();
	}
	else {
		// error while parsing json string
		alert(response.message);
	}
},

DeleteCollection: function(id) {
	if ( !id ) {
		return;
	}

	Parameters.clear();
	Parameters.add("id", id);

	execute("collections/deleteCollection.os", this.OnSuccess, OnError, OnAbort);
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

InsertCollection: function() {
	var elCollection = document.getElementById("collection_input");

	Parameters.clear();
	Parameters.add("identifier", Account.GetIdentifier());
	Parameters.add("name", elCollection.value);

	execute("collections/insertCollection.os", this.OnSuccess, OnError, OnAbort);
},

ReturnCollection: function(collection) {
	if ( this.mCallback ) {
		this.mCallback(collection);
	}
},

SearchCollection: function(collection) {
	// search for the given collection
	Search(collection);
},

ShowCollection: function(id) {
	if ( !id ) {
		return;
	}

	Parameters.clear();
	Parameters.add("collectionID", id);

	LoadPluginWithHistory("showcollection");
},

Swap: function(name) {
	if ( !name ) {
		return;         // invalid name provided
	}

	var elLabel = document.getElementById(name + "_label");
	var elInput = document.getElementById(name + "_input");
	var elSave = document.getElementById("save");

	if ( elSave.hidden ) {
		elSave.hidden = false;
		elInput.value = elLabel.textContent;
	}
	else {
		elLabel.textContent = elInput.value;
	}

	elLabel.hidden = !elLabel.hidden;
	elInput.hidden = !elInput.hidden;
}

};

mCurrentPlugin = mCollectionsPlugin;

