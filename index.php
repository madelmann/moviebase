<!DOCTYPE html>

<?php
include( "includes/head.php" );

/* // maintenance page
include("includes/maintenance.php");
return;
*/

// live page
if ( isset( $_GET[ "plugin" ] ) ) {
    // only a single plugin is requested
    include( "includes/plugin.php" );
}
else {
    // load the full page
    include( "includes/body.php" );
}

?>

</html>
