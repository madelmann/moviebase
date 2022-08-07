
// convenience API access
function api( pluginFunc, callback_success, callback_error, callback_abort )
{
    return API.call( pluginFunc, callback_success, callback_error, callback_abort );
}
function api2( pluginFunc, callback_success, callback_error, callback_abort )
{
    return API.call2( pluginFunc, callback_success, callback_error, callback_abort );
}

function execute( pluginFunc, callback_success, callback_error, callback_abort )
{
    return API.execute( pluginFunc, callback_success, callback_error, callback_abort );
}

function executeExternal( pluginURL, callback_success, callback_error, callback_abort )
{
	return API.executeExternal( pluginURL, callback_success, callback_error, callback_abort );
}


API = {

    version: "v1",

    Constructor: function() {
        this.__init__();
    },

    call: function( pluginFunc, callback_success, callback_error, callback_abort ) {
        if ( pluginFunc.length === 0 ) {
            return false;
        }

        var pluginURL = this.__buildApiUrl__( pluginFunc, true );

        var xmlhttp = new XMLHttpRequest();
        xmlhttp.addEventListener( "load", callback_success, false );
        xmlhttp.addEventListener( "error", callback_error, false );
        xmlhttp.addEventListener( "abort", callback_abort, false );
        xmlhttp.open( "POST", pluginURL, true );
        xmlhttp.send();

        return true;
    },

    call2: function( pluginFunc, callback_success, callback_error, callback_abort ) {
        if ( pluginFunc.length === 0 ) {
            return false;
        }

        var pluginURL = this.__buildApiUrl__( pluginFunc, true );

        var xmlhttp = new XMLHttpRequest();
        xmlhttp.addEventListener( "load", ( event ) => {
            var json = {};

            if ( ParseJSON( event.currentTarget.responseText, json ) ) {
                callback_success( json.message );
            }
            else {
                callback_error( event );
            }
        }, false );
        xmlhttp.addEventListener( "error", callback_error, false );
        xmlhttp.addEventListener( "abort", callback_abort, false );
        xmlhttp.open( "POST", pluginURL, true );
        xmlhttp.send();

        return true;
    },

    execute: function( pluginFunc, callback_success, callback_error, callback_abort ) {
        if ( pluginFunc.length === 0 ) {
            return false;
        }
    
        var pluginURL = API.__buildPluginUrl__( pluginFunc, true );
    
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.addEventListener( "load", callback_success, false );
        xmlhttp.addEventListener( "error", callback_error, false );
        xmlhttp.addEventListener( "abort", callback_abort, false );
        xmlhttp.open( "POST", pluginURL, true );
        xmlhttp.send();
    
        return true;
    },

    executeExternal: function( pluginURL, callback_success, callback_error, callback_abort ) {
        pluginURL = API.__buildExternalUrl__( pluginURL, true );

        var xmlhttp = new XMLHttpRequest();
        xmlhttp.addEventListener( "load", callback_success, false );
        xmlhttp.addEventListener( "error", callback_error, false );
        xmlhttp.addEventListener( "abort", callback_abort, false );
        xmlhttp.open( "POST", pluginURL, true );
        xmlhttp.send();

        return true;
    },

    fetch: function( pluginFunc, callback_success, callback_error, callback_abort ) {
        if ( pluginFunc.length === 0 ) {
            return false;
        }

        var pluginURL = this.__buildApiUrl__( pluginFunc, true );

        fetch( pluginURL )
            .then( response => {
                if ( !response.ok ) {
                    throw new Error( "HTTP error " + response.status );
                }

                return response.json();
            } )
            .then( json => {
                this.currentLanguage = json.language;
                this.data = json.tokens;

                this.translate( document.getElementById( "container" ) );
            } )
            .catch( function () {
                // implement exception block
            } );
    },

    __buildApiUrl__: function( pluginFunc, addParameters, version ) {
        if ( !version ) {
            version = this.version;		// use most recent API version
        }

        return this.__buildUrl__( "api/" + version + "/" + pluginFunc, addParameters );
    },

    __buildExternalUrl__: function( pluginFunc, addParameters ) {
        return this.__buildUrl__( pluginFunc, addParameters );
    },

    __buildPluginUrl__: function( pluginFunc, addParameters ) {
        return this.__buildUrl__( "plugins/" + pluginFunc, addParameters );
    },

    __buildUrl__: function( funcName, addParameters ) {
        // based on currently selected theme replace trading-URL with basic or pro

        var paramStr = "";
        var result = funcName;

        if ( addParameters !== false ) {
            for ( var i = 0; i < Parameters.size(); i++ ) {
                paramStr += "&";

                var name = Parameters.at(i).name;
                var value = Parameters.at(i).value;

                paramStr += name + "=" + value;
            }

            if ( paramStr !== "" ) {
                result += "?" + paramStr;
            }
        }

        return result;
    },

    __init__: function() {
        // nothing to do here atm
    }

};

