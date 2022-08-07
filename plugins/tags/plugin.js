
function FormClick(event) {
}


mTagsPlugin = {

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
	this.mPluginName = "tags";

	Parameters.add("allowDelete", Account.IsLoggedIn());
	Parameters.add("allowSearch", Account.IsLoggedIn());

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

DeleteTag: function(id) {
	if ( !id ) {
		return;
	}

	Parameters.clear();
	Parameters.add("id", id);

	execute("tags/deleteTag.os", this.OnSuccess, OnError, OnAbort);
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

InsertTag: function() {
	var elTag = document.getElementById("tag_input");

	Parameters.clear();
	Parameters.add("name", elTag.value);

	execute("tags/insertTag.os", this.OnSuccess, OnError, OnAbort);
},

ReturnTag: function(tag) {
	if ( this.mCallback ) {
		this.mCallback(tag);
	}
},

SearchTag: function(tag) {
	SearchTag(tag);
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

mCurrentPlugin = mTagsPlugin;
