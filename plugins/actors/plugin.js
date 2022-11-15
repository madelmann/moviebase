
mActorsPlugin = {

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
	this.pluginName = "actors";

	Parameters.add("allowDelete", Account.IsLoggedIn());
	Parameters.add("allowSearch", true);
	Parameters.add("showAll", false);

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

DeleteActor: function(id) {
	if ( !id ) {
		return;
	}

	Parameters.clear();
	Parameters.add("id", id);

	execute("actors/deleteActor.os", this.OnSuccess, OnError, OnAbort);
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

InsertActor: function() {
	var elActor = document.getElementById("actor_input");

	Parameters.clear();
	Parameters.add("name", elActor.value);

	execute("actors/insertActor.os", this.OnSuccess, OnError, OnAbort);
},

ReturnActor: function(actor) {
	if ( this.mCallback ) {
		this.mCallback(actor);
	}
},

SearchActor: function(actor) {
	// search for the given actor
	Search(actor);
},

ShowActor( actor ) {
	Parameters.clear();
	Parameters.add( "actor", actor );

	LoadPluginWithHistory( "showactor" );
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

mCurrentPlugin = mActorsPlugin;

