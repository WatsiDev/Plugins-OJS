<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset={$defaultCharset|escape}" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{translate key="article.pageTitle" title=$title|escape}</title>

    {load_header context="frontend" headers=$headers}
    {load_stylesheet context="frontend" stylesheets=$stylesheets}
    {load_script context="frontend" scripts=$scripts}

<style>
    body {
        font-family: Arial, sans-serif;
        line-height: 1.6;
        margin: 0;
        padding: 0;
        background-color: #f2f2f2;
    }

    .galley_view {
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin: 20px auto;
        padding: 20px;
        max-width: 600px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        overflow: auto; /* Agrega barras de desplazamiento si el contenido es demasiado grande */
    }

    .galley_view_notice {
        margin-top: 10px;
        padding: 10px;
        background-color: #ffeeba;
        border: 1px solid #ffc107;
        border-radius: 4px;
    }

    .galley_view_notice_message {
        font-weight: bold;
        color: #ffc107;
    }

    audio {
        width: 100%;
        margin-top: 20px;
    }

    .metadata {
        margin-top: 20px;
    }

    .metadata p {
        margin-bottom: 8px;
    }

    .metadata strong {
        margin-right: 5px;
    }

    .footer {
        text-align: center;
        margin-top: 20px;
        color: #777;
    }
</style>

</head>
<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">

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

        <a href="{$audioUrl}" class="download" download>
            <span class="label">
                {translate key="common.download"}
            </span>
            <span class="pkp_screen_reader">
                {translate key="common.downloadaudio"}
            </span>
        </a>
    </header>

    {if $galleyFile->getData('mimetype') == 'audio/mpeg'}
        <div id="audioPlayerContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
            {if !$isLatestPublication}
                <div class="galley_view_notice">
                    <div class="galley_view_notice_message" role="alert">
                        {$datePublished|escape}
                    </div>
                </div>
            {/if}

            <h2>{$issueIdentification|escape}</h2>
            <h3>{$title|escape}</h3>

            <audio controls>
                <source src="{$audioUrl|escape}" type="audio/mpeg">
                Your browser does not support the audio element.
            </audio>

            <div class="metadata">
                {foreach from=$authors item=author}
                    <p><strong>Autor</strong>: {$author->getFullName()|escape}</p>
                    <p><strong>Afiliación</strong>: {$author->getLocalizedAffiliation()|escape}</p>
                {/foreach}
                <p><strong>Asunto</strong>: {$keywords|escape}</p>

                <!-- Aquí se realizó la modificación para eliminar etiquetas HTML -->
                <p><strong>{translate key="article.abstract"}:</strong> {strip_tags($abstract)}</p>
            </div>
        </div>
    {/if}
    
    <div class="footer">
        {call_hook name="Templates::Common::Footer::PageFooter"}
    </div>
</body>
</html>
