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
				{translate key="common.download"}
			</span>
		</a>

	</header>

	<div class="metadata">
		<h2>{$issueIdentification|escape}</h2>
		<h3>{$title|escape}</h3>
		{foreach from=$authors item=author}
			<p><strong>{translate key="article.author"}</strong>: {$author->getFullName()|escape}</p>
			<p><strong>{translate key="article.authorAffiliation"}</strong>: {$author->getLocalizedAffiliation()|escape}</p>
		{/foreach}
		<p><strong>{translate key="article.subject"}</strong>: {$keywords|escape}</p>
	</div>

	<div id="audioPlayerContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
		{if !$isLatestPublication}
			<div class="galley_view_notice">
				<div class="galley_view_notice_message" role="alert">
					{$datePublished|escape}
				</div>
			</div>
		{/if}
		<audio controls>
			<source src="{$audioViewerUrl|escape}" type="audio/mpeg">
			{translate key="common.noAudioSupport"}
		</audio>
	</div>

	{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
