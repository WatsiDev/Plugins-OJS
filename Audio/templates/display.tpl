<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
<head>
    <!-- Metadatos y configuración inicial -->
    <!-- Define el tipo de contenido y el conjunto de caracteres -->
    <meta http-equiv="Content-Type" content="text/html; charset={$defaultCharset|escape}" />
    <!-- Configura el viewport para dispositivos móviles -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Define el título de la página, traducido dinámicamente -->
    <title>{translate key="article.pageTitle" title=$title|escape}</title>

    <!-- Cargar encabezados específicos del contexto -->
    {load_header context="frontend" headers=$headers}
    <!-- Cargar hojas de estilo específicas del contexto -->
    {load_stylesheet context="frontend" stylesheets=$stylesheets}
    <!-- Cargar scripts específicos del contexto -->
    {load_script context="frontend" scripts=$scripts}

    <!-- Estilos CSS en línea para la página -->
    <style>
        /* Estilo para el cuerpo de la página */
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
        }

        /* Estilo para la vista del contenido */
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

        /* Estilo para el aviso de contenido */
        .galley_view_notice {
            margin-top: 10px;
            padding: 10px;
            background-color: #ffeeba;
            border: 1px solid #ffc107;
            border-radius: 4px;
        }

        /* Estilo para el mensaje del aviso */
        .galley_view_notice_message {
            font-weight: bold;
            color: #ffc107;
        }

        /* Estilo para el elemento de audio */
        audio {
            width: 100%;
            margin-top: 20px;
        }

        /* Estilo para la sección de metadatos */
        .metadata {
            margin-top: 20px;
        }

        /* Estilo para los párrafos dentro de los metadatos */
        .metadata p {
            margin-bottom: 8px;
        }

        /* Estilo para los textos en negrita dentro de los metadatos */
        .metadata strong {
            margin-right: 5px;
        }

        /* Estilo para el pie de página */
        .footer {
            text-align: center;
            margin-top: 20px;
            color: #777;
        }
    </style>
</head>
<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">

    <!-- Encabezado de la página -->
    <header class="header_view">
        <!-- Enlace para volver a la página anterior -->
        <a href="{$parentUrl}" class="return">
            <span class="pkp_screen_reader">
                {if $parent instanceOf Issue}
                    <!-- Texto alternativo para volver a la edición de la revista -->
                    {translate key="issue.return"}
                {else}
                    <!-- Texto alternativo para volver al artículo -->
                    {translate key="article.return"}
                {/if}
            </span>
        </a>

        <!-- Título del artículo con enlace -->
        <a href="{$parentUrl}" class="title">
            {$title|escape}
        </a>

        <!-- Enlace para descargar el archivo de audio -->
        <a href="{$audioUrl}" class="download" download>
            <span class="label">
                {translate key="common.download"}
            </span>
            <span class="pkp_screen_reader">
                {translate key="common.download"}
            </span>
        </a>
    </header>

    <!-- Contenido principal: reproducción de audio -->
    {if $galleyFile->getData('mimetype') == 'audio/mpeg'}
        <div id="audioPlayerContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
            <!-- Aviso si no es la última publicación -->
            {if !$isLatestPublication}
                <div class="galley_view_notice">
                    <div class="galley_view_notice_message" role="alert">
                        <!-- Fecha de publicación -->
                        {$datePublished|escape}
                    </div>
                </div>
            {/if}

            <!-- Identificación del número de la revista y título del artículo -->
            <h2>{$issueIdentification|escape}</h2>
            <h3>{$title|escape}</h3>

            <!-- Reproductor de audio -->
            <audio controls>
                <source src="{$audioUrl|escape}" type="audio/mpeg">
                Your browser does not support the audio element.
            </audio>

            <!-- Metadatos del artículo -->
            <div class="metadata">
                <!-- Información de los autores -->
                {foreach from=$authors item=author}
                    <p><strong>{translate key="article.author"}</strong>: {$author->getFullName()|escape}</p>
                    <p><strong>{translate key="article.affiliation"}</strong>: {$author->getLocalizedAffiliation()|escape}</p>
                {/foreach}
                <!-- Palabras clave -->
                <p><strong>Asunto</strong>: {$keywords|escape}</p>

                <!-- Resumen del artículo sin etiquetas HTML -->
                <p><strong>{translate key="article.abstract"}:</strong> {strip_tags($abstract)}</p>
            </div>
        </div>
    {/if}
    
    <!-- Pie de página -->
    <div class="footer">
        {call_hook name="Templates::Common::Footer::PageFooter"}
    </div>
</body>
</html>
