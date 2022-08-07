"use strict";

// Initial member declarations
var Account;
var API;
var mGlobals = {};
var Header;
var History;
var Notifications;
var Parameters;
var Templates;
var Translations;


function Initialize()
{
    mGlobals.Admin = false;
    mGlobals.Debug = false;

    API.Constructor();
    Translations.Constructor();
    History.Constructor();
    Notifications.Constructor();

    // determine storage capabilities
    if ( typeof(Storage) !== "undefined" ) {
        // Code for localStorage/sessionStorage.
        mGlobals.StorageAvailable = true;

        Account.Constructor();
    }
    else {
        // Sorry! No Web Storage support..
        mGlobals.StorageAvailable = false;
    }
}

function Shutdown()
{
    Account.Destructor();
    History.Destructor();
    Notifications.Destructor();
    Translations.Destructor();
}

