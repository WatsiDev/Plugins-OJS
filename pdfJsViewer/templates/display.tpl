{**
 * plugins/generic/pdfJsViewer/templates/display.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Embedded viewing of a PDF galley or MP3 player.
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

		<a href="{$pdfUrl|escape}" class="download" download>
			<span class="label">
				{translate key="common.download"}
			</span>
			<span class="pkp_screen_reader">
				{translate key="common.downloadPdf"}
			</span>
		</a>

	</header>

	{if $galleyFile->getData('mimetype') == 'application/pdf'}
		<script type="text/javascript">
			// Creating iframe's src in JS instead of Smarty so that EZProxy-using sites can find our domain in $pdfUrl and do their rewrites on it.
			$(document).ready(function() {
				var urlBase = "{$pluginUrl|escape}/pdf.js/web/viewer.html?file=";
				var pdfUrl = {$pdfUrl|json_encode:JSON_UNESCAPED_SLASHES};
				$("#pdfCanvasContainer > iframe").attr("src", urlBase + encodeURIComponent(pdfUrl));
			});
		</script>

		<div id="pdfCanvasContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
			{if !$isLatestPublication}
				<div class="galley_view_notice">
					<div class="galley_view_notice_message" role="alert">
						{$datePublished|escape}
					</div>
				</div>
			{/if}
			<iframe src="" width="100%" height="100%" style="min-height: 500px;" title="{$galleyTitle|escape}" allowfullscreen webkitallowfullscreen></iframe>
		</div>
	{elseif $galleyFile->getData('mimetype') == 'audio/mpeg'}
		<div id="audioPlayerContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
			{if !$isLatestPublication}
				<div class="galley_view_notice">
					<div class="galley_view_notice_message" role="alert">
						{$datePublished|escape}
					</div>
				</div>
			{/if}
			<audio controls>
				<source src="{$pdfUrl|escape}" type="audio/mpeg">
				Your browser does not support the audio element.
			</audio>
		</div>
	{/if}
	{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
