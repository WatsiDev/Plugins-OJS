<?php

// Importa la clase GenericPlugin de la librería PKP
import('lib.pkp.classes.plugins.GenericPlugin');

class ViewerAudio extends GenericPlugin {
    
    // Método de registro del plugin
    function register($category, $path, $mainContextId = null) {
        // Llama al método de registro del padre y verifica si el plugin está habilitado
        if (parent::register($category, $path, $mainContextId)) {
            // Verifica si el plugin está habilitado para el contexto principal
            if ($this->getEnabled($mainContextId)) {
                // Registra los callbacks para visualizar las galeras de preprints, artículos y números
                HookRegistry::register('PreprintHandler::view::galley', array($this, 'submissionCallback'), HOOK_SEQUENCE_LAST);
                HookRegistry::register('ArticleHandler::view::galley', array($this, 'submissionCallback'), HOOK_SEQUENCE_LAST);
                HookRegistry::register('IssueHandler::view::galley', array($this, 'issueCallback'), HOOK_SEQUENCE_LAST);
                // Carga los componentes de localización comunes necesarios para la aplicación
                AppLocale::requireComponents(LOCALE_COMPONENT_APP_COMMON);
            }
            return true; // Retorna true si el registro fue exitoso
        }
        return false; // Retorna false si no se pudo registrar el plugin
    }

    // Devuelve el archivo de configuración específico del plugin
    function getContextSpecificPluginSettingsFile() {
        return $this->getPluginPath() . '/settings.xml'; // Retorna la ruta al archivo de configuración del plugin
    }

    // Devuelve el nombre para mostrar del plugin
    function getDisplayName() {
        return __('plugins.generic.ViewerAudio.name'); // Retorna el nombre del plugin usando traducción
    }

    // Devuelve la descripción del plugin
    function getDescription() {
        return __('plugins.generic.ViewerAudio.description'); // Retorna la descripción del plugin usando traducción
    }

    // Callback para visualizar galeras de preprints y artículos
    function submissionCallback($hookName, $args) {
        $request =& $args[0]; // Obtiene la solicitud HTTP del primer argumento
        $application = Application::get(); // Obtiene la instancia de la aplicación actual
        
        // Determina el tipo de aplicación y asigna variables correspondientes
        switch ($application->getName()) {
            case 'ojs2':
                $issue =& $args[1]; // Obtiene el número (issue) del artículo o preprint
                $galley =& $args[2]; // Obtiene la galera (galley) del artículo o preprint
                $submission =& $args[3]; // Obtiene el artículo o preprint
                $submissionNoun = 'article'; // Define el sustantivo para referirse al tipo de publicación
                break;
            case 'ops':
                $galley =& $args[1]; // Obtiene la galera (galley) del preprint
                $submission =& $args[2]; // Obtiene el preprint
                $submissionNoun = 'preprint'; // Define el sustantivo para referirse al tipo de publicación
                $issue = null; // No hay número asociado en OPS
                break;
            default: 
                throw new Exception('Unknown application!'); // Lanza una excepción si la aplicación es desconocida
        }

        // Verifica si la galera existe
        if (!$galley) {
            return false; // Retorna false si no hay galera disponible
        }

        $submissionFile = $galley->getFile(); // Obtiene el archivo de la galera
        $mimeType = $submissionFile->getData('mimetype'); // Obtiene el tipo MIME del archivo

        // Verifica si el archivo es de tipo audio/mpeg
        if ($mimeType === 'audio/mpeg') {
            $galleyPublication = null; // Inicializa la variable para la publicación asociada a la galera
            // Itera sobre las publicaciones asociadas al artículo o preprint
            foreach ($submission->getData('publications') as $publication) {
                if ($publication->getId() === $galley->getData('publicationId')) {
                    $galleyPublication = $publication; // Asigna la publicación si coincide con la galera
                    break;
                }
            }

            // Obtiene metadatos adicionales del artículo o preprint
            $authors = $submission->getAuthors(); // Obtiene los autores del artículo o preprint
            $keywords = implode(', ', $galleyPublication->getLocalizedData('keywords')); // Obtiene las palabras clave del artículo o preprint
            $issueIdentification = $issue ? $issue->getIssueIdentification() : ''; // Obtiene la identificación del número (issue) si está disponible
            $abstract = $galleyPublication->getLocalizedData('abstract'); // Obtiene el resumen del artículo o preprint

            // Asigna datos al gestor de plantillas para la visualización
            $templateMgr = TemplateManager::getManager($request);
            $templateMgr->assign(array(
                'displayTemplateResource' => $this->getTemplateResource('display.tpl'), // Recurso de plantilla para mostrar la visualización
                'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(), // URL base del plugin
                'galleyFile' => $submissionFile, // Archivo de la galera
                'issue' => $issue, // Número (issue) asociado
                'submission' => $submission, // Artículo o preprint
                'submissionNoun' => $submissionNoun, // Sustantivo para el tipo de publicación
                'bestId' => $submission->getBestId(), // Mejor identificador del artículo o preprint
                'galley' => $galley, // Galera actual
                'currentVersionString' => $application->getCurrentVersion()->getVersionString(false), // Versión actual de la aplicación
                'isLatestPublication' => $submission->getData('currentPublicationId') === $galley->getData('publicationId'), // Si es la última publicación
                'galleyPublication' => $galleyPublication, // Publicación asociada a la galera
                // Metadatos adicionales
                'issueIdentification' => $issueIdentification, // Identificación del número (issue)
                'authors' => $authors, // Autores del artículo o preprint
                'keywords' => $keywords, // Palabras clave del artículo o preprint
                'abstract' => $abstract, // Resumen del artículo o preprint
            ));
            $templateMgr->display($this->getTemplateResource('submissionGalley.tpl')); // Muestra la plantilla de la galera del artículo o preprint
            return true; // Retorna true para indicar que se manejó la visualización
        }

        return false; // Retorna false si el archivo no es de tipo audio/mpeg
    }

    // Callback para visualizar galeras de números
    function issueCallback($hookName, $args) {
        $request =& $args[0]; // Obtiene la solicitud HTTP del primer argumento
        $issue =& $args[1]; // Obtiene el número (issue) asociado
        $galley =& $args[2]; // Obtiene la galera (galley) del número

        // Verifica si la galera es de tipo audio/mpeg
        if ($galley && $galley->getFileType() == 'audio/mpeg') {
            $application = Application::get(); // Obtiene la instancia de la aplicación actual
            $galleyFile = $galley->getFile(); // Obtiene el archivo de la galera

            // Obtiene la publicación asociada a la galera si está disponible
            $galleyPublication = $galley->getPublication();
            // Obtiene el resumen del artículo o preprint si está disponible
            $abstract = $galleyPublication ? $galleyPublication->getLocalizedData('abstract') : '';

            // Asigna datos al gestor de plantillas para la visualización
            $templateMgr = TemplateManager::getManager($request);
            $templateMgr->assign(array(
                'displayTemplateResource' => $this->getTemplateResource('display.tpl'), // Recurso de plantilla para mostrar la visualización
                'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(), // URL base del plugin
                'galleyFile' => $galleyFile, // Archivo de la galera
                'issue' => $issue, // Número (issue) asociado
                'galley' => $galley, // Galera actual
                'currentVersionString' => $application->getCurrentVersion()->getVersionString(false), // Versión actual de la aplicación
                'isLatestPublication' => true, // Indica que es la última publicación
                'abstract' => $abstract, // Resumen del artículo o preprint si está disponible
            ));
            $templateMgr->display($this->getTemplateResource('issueGalley.tpl')); // Muestra la plantilla de la galera del número
            return true; // Retorna true para indicar que se manejó la visualización
        }

        return false; // Retorna false si la galera no es de tipo audio/mpeg
    }
}
