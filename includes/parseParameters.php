<?php

if ( isset($_GET["admin"]) ) {
	$admin = $_GET["admin"];
	echo "mGlobals.Admin = $admin;\n";
	echo "mParameters.addPermanent('admin', $admin);\n";
}
if ( isset($_GET["debug"]) ) {
	$debug = $_GET["debug"];
	echo "mGlobals.Debug = $debug;\n";
	echo "mParameters.addPermanent('debug', $debug);\n";
}
if ( isset($_GET["device"]) ) {
	$device = $_GET["device"];
	echo "mGlobals.Device = '$device';\n";
	echo "mParameters.addPermanent('device', '$device');\n";
}
if ( isset($_GET["ip"]) ) {
	$ip = $_GET["ip"];
	echo "mGlobals.IP = '$ip'\n";
	echo "mParameters.addPermanent('ip', '$ip');\n";
}
if ( isset($_GET["key"]) ) {
	$key = $_GET["key"];
	echo "mGlobals.Key = '$key';\n";
	echo "mParameters.addPermanent('key', '$key');\n";
}

?>
