
mPlugin = {

    // consts
    HOME_VIEW: "home",

    // instance members
    pluginName: "home",

OnAbort: function(event) {
	// request execution failed
	alert("OnAbort: " + event.currentTarget.responseText);
},

OnError: function(event) {
	// request execution failed
	alert("OnError: " + event.currentTarget.responseText);
},

OnLoad: function() {
	mPlugin.OnLoadReady();
},

OnLoadReady: function() {
	this.QueryStats();
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

Home: function() {
	Parameters.clear();

	LoadPluginWithHistory("home");
},

QueryStats: function() {
	Parameters.clear();

	api2( "public/stats/", ( json ) => {

		Cache.Stats = json;

	}, OnError, OnAbort );
},

SearchTag: function(tag) {
	// search for the given tag
	SearchTag(tag);
},

ShowPage: function(page) {
	// show a specific page

	Parameters.clear();
	Parameters.add("page", page);

	LoadPluginWithHistory("home");
},

ShowVideo: function(id) {
	// open video

	Parameters.clear();
	Parameters.add("itemID", id);

	LoadPluginWithHistory("showvideo");
},

Swap: function(name) {
	// editing is disabled on home page
	return;


	if ( !name ) {
		return;		// invalid name provided
	}

	var elLabel = document.getElementById(name + "_label");
	var elInput = document.getElementById(name + "_input");
	var elSave = document.getElementById(name + "_save");

	if ( elSave.hidden ) {
		elInput.value = elLabel.textContent;
	}
	else {
		elLabel.textContent = elInput.value;
	}

	elLabel.hidden = !elLabel.hidden;
	elInput.hidden = !elInput.hidden;
	elSave.hidden = !elSave.hidden;
}

};

mCurrentPlugin = mPlugin;

