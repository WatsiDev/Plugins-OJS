{**
 * plugins/generic/videoJsViewer/templates/display.tpl
 *
 * Embedded viewing of a video galley.
 *}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset={$defaultCharset|escape}" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{translate key="article.pageTitle" title=$title|escape}</title>

	{load_header context="frontend" headers=$headers}
	{load_stylesheet context="frontend" stylesheets=$stylesheets}
	{load_script context="frontend" scripts=$scripts}

	<link href="https://vjs.zencdn.net/7.10.2/video-js.css" rel="stylesheet" />
	<script src="https://vjs.zencdn.net/7.10.2/video.js"></script>

	<style>
		.video-container {
			display: flex;
			justify-content: center;
			align-items: center;
			padding: 20px;
		}
		.video-js {
			width: 80%;
			max-width: 800px;
		}
		.vjs-big-play-button{
			margin-left: 42%;
            margin-top: 18%;
		}
	</style>
</head>
<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">

	{* Header wrapper *}
	<header class="header_view">

		<a href="{$parentUrl}" class="return">
			<span class="pkp_screen_reader">
				{if $parent instanceOf Issue}
					{translate key="issue.return"}
				{else}
					{translate key="article.return"}
				{/if}
			</span>
		</a>

		<a href="{$parentUrl}" class="title">
			{$title|escape}
		</a>

		<a href="{$videoUrl}" class="download" download>
			<span class="label">
				{translate key="common.download"}
			</span>
			<span class="pkp_screen_reader">
				{translate key="common.downloadVideo"}
			</span>
		</a>

	</header>

	<div id="videoCanvasContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
	<br/>
	<br/>
		<div class="video-container">
			<video id="video-js" class="video-js vjs-default-skin" controls preload="auto" title="{$galleyTitle}" data-setup="{}">
				<source src="{$videoUrl}" type="video/mp4">
				<p class="vjs-no-js">
					{translate key="plugins.generic.videoJsViewer.noJsMessage"}
				</p>
			</video>
		</div>
	</div>
	{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
