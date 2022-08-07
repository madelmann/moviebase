///////////////////////////////////////////////////////////////////////////////
// Globals

var mCurrentPlugin = {};
var mInitialized = false;
var mPlugin;
var mPluginCSS;
var mPluginHTML;
var mPluginScript;
var mRefreshRate = 60; // in seconds
var mRefreshSubscribers = [];

// Globals
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Event handling

function OnAbort( event )
{
	// request execution aborted

	if ( mPlugin && mPlugin.OnAbort ) {
		mPlugin.OnAbort( event );
		return;
	}

	var message = "";

	if ( event.currentTarget && event.currentTarget.responseText ) {
		message = event.currentTarget.responseText;
	}
	else {
		message = event.message;
	}

	Notifications.notifyWarning( message );
}

function OnAbortIgnored( event )
{
	// we ignore this error
}

function OnError( event )
{
	// request execution failed

	if ( mPlugin && mPlugin.OnError ) {
		mPlugin.OnError( event );
		return;
	}

	var message = "";

	if ( event.currentTarget && event.currentTarget.responseText ) {
		message = event.currentTarget.responseText;
	}
	else {
		message = event.message;
	}

	Notifications.notifyError( message );
}

function OnErrorIgnored( event )
{
	// we ignore this error
}

function OnLoad( event )
{
	// Initializing components
	// {
	// Plugins
	mPluginCSS = document.getElementById( "plugin_css" );
	mPluginHTML = document.getElementById( "plugin_html" );
	mPluginLoading = document.getElementById( "plugin_loading" );
	mPluginName = document.getElementById( "plugin_name" );
	mPluginScript = document.getElementById( "plugin_script" );
	// }

	var deviceStr = Parameters.get( "device" );
	if ( deviceStr && deviceStr !== "" ) {
		document.getElementById( "clientarea" ).classList.add( "clientarea_" + deviceStr );
		document.getElementById( "header" ).classList.add( "header_" + deviceStr );
		document.getElementById( "Statusbar" ).classList.add( "Statusbar_" + deviceStr );
	}

	window.onpopstate = function( event ) {
		if ( event.state && event.state.id !== null ) {
			History.Go( event.state.id );
		}
	}

	mElMain = document.getElementById( "plugin_html" );

	mElFooter = document.getElementById( "footer" );
	if ( mElFooter ) {
		LoadPluginInto( "footer", mElFooter );
	}

	mElHeader = document.getElementById( "header" );
	if ( mElHeader ) {
		LoadPluginInto( "header", mElHeader );
	}

	LoadHomePlugin();
}

function OnLoadReady( event )
{
	// loading is done
	if ( mPlugin && mPlugin.OnLoadReady ) {
		mPlugin.OnLoadReady( event );
		return;
	}

	// nothing to do here
}

function OnSuccess( event )
{
	// everything is okay
	if ( mPlugin && mPlugin.OnSuccess ) {
		mPlugin.OnSuccess( event );
		return;
	}

	// nothing to do here
}

// Event handling
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Account handling

function OnLoginFailed( event )
{
	notifyError( "LOGIN_FAILED" );
}

function OnLoginSuccess( event )
{
	History.Clear();

	Header.Reload();

	LoadHomePlugin();
}

function OnLogoutSuccess( event )
{
	History.Clear();
	Parameters.clear();

	Header.Reload();

	LoadPlugin( "start" );
}

function ExtendSession() {
	if ( Account.IsSessionPersistent() ) {
		// extending session lifetime is not necessary for persistent sessions
		return;
	}

	// automatically extend user session

	setTimeout( () => {
		ExtendSession();
	}, 1000 * 60 * 10 );

	api( "admin/users/session/", OnSuccess, OnError, OnAbort );
}

function Login()
{
	elPassword = document.getElementById( "password" );
	elStayLoggedIn = document.getElementById( "stay_logged_in" );
	elUsername = document.getElementById( "username" );

	Account.Login( elUsername.value, elPassword.value, elStayLoggedIn.checked, OnLoginSuccess, OnLoginFailed );
}

function Logout()
{
	Account.Logout( OnLogoutSuccess );
}

function Register()
{
	Parameters.clear();

	LoadPluginWithHistory( "registerView" );
}

function ResetPassword()
{
	Parameters.clear();

	LoadPluginWithHistory( "resetPasswordView" );
}

// Account handling
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Plugin: Home

function LoadHomePlugin()
{
	mInitialized = true;

	var plugin = Parameters.get( "plugin" );
	Parameters.clear();

	RefreshLoop();

	LoadPluginWithHistory( plugin ? plugin : "start" );
}

function LoadingFinished()
{
	if ( mPluginLoading ) mPluginLoading.classList.add( "hidden" );
	mPluginHTML.classList.remove( "hidden" );
}

function LoadingStarted()
{
	if ( mPluginLoading ) mPluginLoading.classList.remove( "hidden" );
	mPluginHTML.classList.add( "hidden" );
}

function RefreshLoop()
{
	// auto refresh
	setTimeout( () => {
		RefreshLoop();
	}, 1000 * mRefreshRate );

	for ( var idx = 0; idx < mRefreshSubscribers.length; ++idx ) {
		var callee = mRefreshSubscribers[ idx ];

		if ( callee ) {
			callee();
		}
	}
}

function RefreshLoopSubscribe( method )
{
	for ( var idx = 0; idx < mRefreshSubscribers.length; ++idx ) {
		if ( mRefreshSubscribers[ idx ] == method ) {
			return;	// method has already been added
		}
	}

	mRefreshSubscribers.push( method );
}

function RefreshLoopUnsubscribe( method )
{
	for ( var idx = 0; idx < mRefreshSubscribers.length; ++idx ) {
		if ( mRefreshSubscribers[ idx ] == method ) {
			// remove method from refresh subscribers
			mRefreshSubscribers.splice( idx, 1 );
		}
	}
}

function ScrollToBottom()
{
	if ( mElFooter ) {
		mElFooter.scrollIntoView();
	}
}

function ScrollToTop()
{
	if ( mElHeader ) {
		mElHeader.scrollIntoView();
	}
	if ( mElTopView ) {
		mElTopView.scrollIntoView();
	}
}

// Plugin: Home
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Generic plugin loading

function __loadPluginCSS( pluginName, target, forceCacheRefresh )
{
	if ( pluginName.length === 0 ) {
		return false;
	}

	var root = target ? target : document.body;

	var pluginURL = API.__buildPluginUrl__( pluginName + "/style.css?v=" + APP_VERSION, false );

	var pluginCSS = document.createElement( "link" );
	pluginCSS.setAttribute( "rel", "stylesheet" );
	pluginCSS.setAttribute( "type", "text/css" );
	pluginCSS.setAttribute( "href", pluginURL );
	root.appendChild( pluginCSS );

	return true;
}

function __loadPluginHTML( pluginName, target, forceCacheRefresh )
{
	if ( pluginName.length === 0 ) { 
		document.getElementById( "plugin_html" ).innerHTML = "";
		document.getElementById( "plugin_html" ).style.border = "0px";
		return false;
	}

	var xmlhttp = null;

	if ( window.XMLHttpRequest ) {
		// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp = new XMLHttpRequest();
	}
	else {  // code for IE6, IE5
		xmlhttp = new ActiveXObject( "Microsoft.XMLHTTP" );
	}

	xmlhttp.onreadystatechange = function() {
		if ( xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			if ( !target ) {
				return;
			}

			target.innerHTML = xmlhttp.responseText;

			Translations.translate( target );
		}
	};

	// optionally use index.os, index.php or index.html
	var pluginURL = API.__buildPluginUrl__( pluginName + "/?v=" + APP_VERSION, true );

	xmlhttp.onerror = OnError;
	xmlhttp.onabort = OnAbort;
	xmlhttp.open( "POST", pluginURL, false );
	xmlhttp.send();

	return true;
}

function __loadPluginJS( pluginName, target, callback, forceCacheRefresh )
{
	if ( pluginName.length === 0 ) {
		return false;
	}

	var root = target ? target : document.body;

	var pluginURL = API.__buildPluginUrl__( pluginName + "/plugin.js?v=" + APP_VERSION, false );

	var pluginJS = document.createElement( "script" );
	pluginJS.onload = pluginJS.onreadystatechange = function() {
		if ( mCurrentPlugin && mCurrentPlugin.OnLoad ) {
			mCurrentPlugin.OnLoad( callback );
			mCurrentPlugin = {};

			Translations.translate( target );
		}
		//pluginJS.onload = pluginJS.onreadystatechange = null;
	};

	pluginJS.setAttribute( "type", "text/javascript" );
	pluginJS.setAttribute( "src", pluginURL );
	root.appendChild( pluginJS );

	return true;
}

function LoadPlugin( pluginName, callback, forceCacheRefresh )
{
	// show loading spinner
	LoadingStarted();

	// and automatically deactivate it after some time has passed,
	// in case the plugin hadn't deactivated is already
	setTimeout( () => { LoadingFinished(); }, 1000 * 3 );

	//Parameters.add( "v", APP_VERSION );

	if ( mGlobals.Debug ) {
		var notification = document.createElement( "div" );
		notification.innerHTML += "<p>" + Parameters.toString() + "</p>";
		mPluginHTML.appendChild( notification );
	}

	mPlugin = null;

	forceCacheRefresh = false;

	__loadPluginHTML( pluginName, mPluginHTML, forceCacheRefresh );
	__loadPluginCSS( pluginName, mPluginHTML, forceCacheRefresh );
	__loadPluginJS( pluginName, mPluginHTML, null, forceCacheRefresh );

	if ( callback ) {
		callback();
	}
}

function LoadPluginInto( pluginName, target, immediateCallback, asyncCallback )
{
	__loadPluginHTML( pluginName, target );
	__loadPluginCSS( pluginName, target );
	__loadPluginJS( pluginName, target, asyncCallback );

	if ( immediateCallback ) {
		immediateCallback();
	}
}

function LoadPluginWindow( pluginName, callback )
{
	Notifications.ClearNotifications();
	Parameters.add( "v", APP_VERSION );

	if ( mGlobals.Debug ) {
		var notification = document.createElement( "div" );
		notification.innerHTML += "<p>" + Parameters.toString() + "</p>";
		mPluginHTML.appendChild( notification );
	}

	mPlugin = null;

	var pluginURL = API.__buildPluginUrl__( pluginName, true );
	window.open( pluginURL, pluginName, 'width=600,height=400' );

	if ( callback ) {
		callback();
	}
}

function LoadPluginWithHistory( pluginName, callback )
{
	History.PushState( pluginName );

	LoadPlugin( pluginName, callback );
}

// Generic plugin loading
///////////////////////////////////////////////////////////////////////////////



function RenderActor( itemID, actor ) {
	var control = "<li class=\"actor-tag\"><span class='X-span'>";
	//if ( Account.IsAdmin() ) {
	if ( Account.IsLoggedIn() ) {
		control += "<a class=\"X\" onclick=\"mPlugin.RemoveActor(" + itemID + ", '" + actor.name + "');\"> X </a>";
	}
	control += "<a onclick=\"mPlugin.ShowActor('" + actor.name + "');\"> " + actor.name + " </a></span></li>";

	return control;
}

function RenderCollectionItem( collectionID, item ) {
	var control = "<li class=\"collection-tag\">";
	//if ( Account.IsAdmin() ) {
	if ( Account.IsLoggedIn() ) {
		control += "<a class=\"X\" onclick=\"mPlugin.RemoveCollection(" + item.itemID + ");\"> X </a>";
	}
	control += "<span><a onclick=\"mPlugin.ShowCollection(" + item.collectionID + ");\"> " + item.name + " </a></span></li>";

	return control;
}

function RenderTag( actorID, tag ) {
	var control = "<li class=\"tag-tag\"><span>";
	//if ( Account.IsAdmin() ) {
	if ( Account.IsLoggedIn() ) {
		control += "<a class=\"X\" onclick=\"mPlugin.RemoveTag(" + actorID + ", '" + tag.name + "');\"> X </a>";
	}
	control += "<a onclick=\"mPlugin.SearchTag('" + tag.name + "');\"> " + tag.name + " </a></span></li>";

	return control;
}

function Search( value ) {
	Parameters.add( "page", 1 );
	Parameters.add( "query", value );

	LoadPluginWithHistory( "search" );
}

function SearchTag( tag ) {
	Parameters.add( "page", 1 );
	Parameters.add( "searchTags", tag );

	LoadPluginWithHistory( "advancedsearch" );
}

function SearchVideos()
{
	elQuery = document.getElementById( "query" );

	Parameters.clear();
	Parameters.add( "query", elQuery.value );

	LoadPluginWithHistory( "search" );
}
