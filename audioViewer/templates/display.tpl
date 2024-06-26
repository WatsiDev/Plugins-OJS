<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset={$defaultCharset|escape}" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{translate key="article.pageTitle" title=$title|escape}</title>

	{load_header context="frontend" headers=$headers}
	{load_stylesheet context="frontend" stylesheets=$stylesheets}
	{load_script context="frontend" scripts=$scripts}
</head>
<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">

	{* Header wrapper *}
	<header class="header_view">

		<a href="{$parentUrl|escape}" class="return">
			<span class="pkp_screen_reader">
				{if $parent instanceOf Issue}
					{translate key="issue.return"}
				{else}
					{translate key="article.return"}
				{/if}
			</span>
		</a>

		<a href="{$parentUrl|escape}" class="title">
			{$title|escape}
		</a>

		<a href="{$audioViewerUrl|escape}" class="download" download>
			<span class="label">
 				{translate key="common.download"}
			</span>
			<span class="pkp_screen_reader">
				{translate key="common.downloadAudio"}
			</span>
		</a>

	</header>

	<div id="audioPlayerContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
		{if !$isLatestPublication}
			<div class="galley_view_notice">
				<div class="galley_view_notice_message" role="alert">
					{$datePublished|escape}
				</div>
			</div>
		{/if}
		<p style="padding:20px">
		Audio player
		</p>

		<audio controls style="padding: 0px 20px">
			<source src="{$audioViewerUrl|escape}" type="audio/mpeg">
			Your browser does not support the audio element.
		</audio>
	</div>
	{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
