<body onload="OnLoad();">

<div id="container">
	<div id="header">
		<?php include( "plugins/header/index.html" ); ?>
	</div>
	<div id="clientarea">
		<div id="plugin_html" style="display: block;" onclick="FormClick();">
			<?php include( "plugins/loading/index.html" ); ?>
		</div>
	</div>
	<div id="footer" style="display: block;">
		<?php include( "plugins/footer/index.html" ); ?>
	</div>
	<div id="notification-area">
	</div>
</div>

<script>
  Initialize();

  mGlobals.Admin = false;
  mGlobals.Debug = false;

  <?php include( "includes/parseParameters.php" ); ?>
</script>

</body>

