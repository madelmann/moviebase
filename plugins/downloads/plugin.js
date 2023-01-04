
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

	mElSource = document.getElementById( "source" );
	mElTarget = document.getElementById( "target" );

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

DeleteDownload: function( id ) {
	Parameters.clear();
	Parameters.add( "id", id );

	execute( "downloads/delete.os", mPlugin.OnSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

DownloadVideo: function() {
	var source = btoa( encodeURI( mElSource.value ) );
	var target = btoa( mElTarget.value );

	Parameters.clear();
	Parameters.add( "source", source );
	Parameters.add( "target", target );

	execute( "downloads/download.os", mPlugin.OnSuccess, mPlugin.OnError, mPlugin.OnAbort );
},

RetryDownload: function( id ) {
	Parameters.clear();
	Parameters.add( "id", id );

	execute( "downloads/retry.os", mPlugin.OnSuccess, mPlugin.OnError, mPlugin.OnAbort );
}

};

mCurrentPlugin = mPlugin;

