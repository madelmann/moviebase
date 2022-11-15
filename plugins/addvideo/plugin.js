
function FormClick(event) {
}


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
	this.pluginName = "addvideo";

	mElTags = document.getElementById("tags_input");
	mElTitle = document.getElementById("title_input");

	this.mResultLabel = document.getElementById("add-video-result-label");

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
			Parameters.clear();
			Parameters.add("itemID", response.message.id);

			LoadPlugin("showvideo");

			alert("Successfully added a new video. Thank you!");
		}
		else {
			alert("Error: " + response.message.message);
			//alert("Could not add video, please try again.");
		}
	}
	else {
		// error while parsing json string
		alert(response.message);
	}
},

AddVideo: function() {
	Parameters.clear();
	Parameters.add("tags", mElTags.value);
	mParameters.add("title", mElTitle.value);

	execute("addvideo/insertVideo.os", mPlugin.OnSuccess, mPlugin.OnError, mPlugin.OnAbort);
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

Swap: function(name) {
	if ( !name ) {
		return;         // invalid name provided
	}

	var elCancel = document.getElementById("cancel");
	var elLabel = document.getElementById(name + "_label");
	var elInput = document.getElementById(name + "_input");
	var elSave = document.getElementById("save");

	if ( elSave.hidden ) {
		elCancel.hidden = false;
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

mCurrentPlugin = mPlugin;

