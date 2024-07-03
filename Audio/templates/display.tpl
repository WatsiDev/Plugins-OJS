<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
<head>
    <!-- Metadatos y configuración inicial -->
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
            transition: background-color 0.3s, color 0.3s;
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

        /* Estilos modo oscuro */
        body.dark-mode {
            background-color: #121212;
            color: #e0e0e0;
        }

        .dark-mode .galley_view {
            background-color: #1e1e1e;
            border-color: #333;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
        }

        .dark-mode .galley_view_notice {
            background-color: #444;
            border-color: #666;
        }

        .dark-mode .footer {
            color: #aaa;
        }

        .dark-mode .galley_view h2,
        .dark-mode .galley_view h3,
        .dark-mode .galley_view .dark-mode-toggle span,
        .dark-mode .galley_view audio,
        .dark-mode .galley_view .metadata,
        .dark-mode .galley_view .metadata p,
        .dark-mode .galley_view .metadata strong {
            color: #ffffff;
        }

        .dark-mode .galley_view .dark-mode-toggle button {
            background-color: #444;
        }

        .dark-mode .galley_view .dark-mode-toggle button:hover {
            background-color: #666;
        }

        /* Estilos del botón de alternar */
        .dark-mode-toggle {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .dark-mode-toggle button {
            background-color: #007bff;
            border: none;
            color: white;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            margin-left: 10px;
        }

        .dark-mode-toggle button:hover {
            background-color: #0056b3;
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

            <!-- Botón de alternar modo oscuro dentro del cuadro de información -->
            <div class="dark-mode-toggle">
                <span>Modo oscuro:</span>
                <button id="darkModeToggle">Activar</button>
            </div>

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

    <!-- JavaScript para alternar el modo oscuro -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
        const toggleButton = document.getElementById('darkModeToggle');
        const body = document.body;

        if (body) {
            // Check if dark mode is already enabled in localStorage
            if (localStorage.getItem('darkMode') === 'enabled') {
            body.classList.add('dark-mode');
            toggleButton.textContent = 'Desactivar';
            }

            toggleButton.addEventListener('click', function() {
            if (body.classList.contains('dark-mode')) {
                body.classList.remove('dark-mode');
                localStorage.setItem('darkMode', 'disabled');
                toggleButton.textContent = 'Activar';
            } else {
                body.classList.add('dark-mode');
                localStorage.setItem('darkMode', 'enabled');
                toggleButton.textContent = 'Desactivar';
            }
            });
        } else {
            console.error('document.body is null or undefined');
        }
        });
    </script>
</body>
</html>
