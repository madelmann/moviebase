
mPlugin = {

OnAbort: function(event) {
	// request execution failed
	alert("OnAbort: " + event.currentTarget.responseText);
},

OnError: function(event) {
	// request execution failed
	alert("OnError: " + event.currentTarget.responseText);
},

OnLoad: function() {
	this.mPluginName = "showvideos";

	this.OnLoadReady();
},

OnLoadReady: function() {
},

OnSuccess: function(event) {
	// request execution was successful
	//alert("OnSuccess: " + event.currentTarget.responseText);

	var response = {};

	if ( ParseJSON(event.currentTarget.responseText, response) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			History.Refresh();
		}
		else {
			alert("Could not delete video, please try again.");
		}
	}
	else {
		// error while parsing json string
		alert(response.message);
	}
},

HideVideo: function(id) {
	if ( !id ) {
		return;
	}

	Parameters.clear();
	Parameters.add("itemID", id);

	execute("showvideos/hideVideo.os", this.OnSuccess, OnError, OnAbort);
},

SearchTag: function(tag) {
	SearchTag(tag);
},

ShowVideo: function(id) {
	if ( !id ) {
		return;
	}

	Parameters.clear();
	Parameters.add("itemID", id);

	LoadPluginWithHistory("showvideo");
},

SortByRating: function() {
	Parameters.addOrSet("sortBy", "rating_value");

	Reload();
},

SortByTitle: function() {
	Parameters.addOrSet("sortBy", "title");

	Reload();
},

SortByViews: function() {
	Parameters.addOrSet("sortBy", "views");

	Reload();
}

};

mCurrentPlugin = mPlugin;

