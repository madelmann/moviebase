
mPlugin = {

OnAbort: function(event) {
	// request execution aborted
	alert("OnAbort: " + event.currentTarget.responseText);
},

OnError: function(event) {
	// request execution failed
	alert("OnError: " + event.currentTarget.responseText);
},

OnLoad: function(event) {
	this.pluginName = "admin";

	mPlugin.mElSource = document.getElementById("source");
	mPlugin.mElTarget = document.getElementById("target");

	mPlugin.OnLoadReady();
},

OnLoadReady: function() {
},

OnSuccess: function(event) {
	// request execution was successful
	//alert("OnSuccess: " + event.currentTarget.responseText);

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

DownloadVideo: function() {
	Parameters.clear();
	Parameters.add("source", mPlugin.mElSource.value);
	Parameters.add("target", mPlugin.mElTarget.value);

	execute( "downloads/downloadVideo.os", mPlugin.OnSuccess, mPlugin.OnError, mPlugin.OnAbort );
}

};

mCurrentPlugin = mPlugin;

