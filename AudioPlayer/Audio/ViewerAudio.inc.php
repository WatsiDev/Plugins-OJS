<?php

import('lib.pkp.classes.plugins.GenericPlugin');

class ViewerAudio extends GenericPlugin {
    function register($category, $path, $mainContextId = null) {
        if (parent::register($category, $path, $mainContextId)) {
            if ($this->getEnabled($mainContextId)) {
                HookRegistry::register('PreprintHandler::view::galley', array($this, 'submissionCallback'), HOOK_SEQUENCE_LAST);
                HookRegistry::register('ArticleHandler::view::galley', array($this, 'submissionCallback'), HOOK_SEQUENCE_LAST);
                HookRegistry::register('IssueHandler::view::galley', array($this, 'issueCallback'), HOOK_SEQUENCE_LAST);
                AppLocale::requireComponents(LOCALE_COMPONENT_APP_COMMON);
            }
            return true;
        }
        return false;
    }

    function getContextSpecificPluginSettingsFile() {
        return $this->getPluginPath() . '/settings.xml';
    }

    function getDisplayName() {
        return __('plugins.generic.ViewerAudio.name');
    }

    function getDescription() {
        return __('plugins.generic.ViewerAudio.description');
    }

    function submissionCallback($hookName, $args) {
        $request =& $args[0];
        $application = Application::get();
        switch ($application->getName()) {
            case 'ojs2':
                $issue =& $args[1];
                $galley =& $args[2];
                $submission =& $args[3];
                $submissionNoun = 'article';
                break;
            case 'ops':
                $galley =& $args[1];
                $submission =& $args[2];
                $submissionNoun = 'preprint';
                $issue = null;
                break;
            default: throw new Exception('Unknown application!');
        }

        if (!$galley) {
            return false;
        }

        $submissionFile = $galley->getFile();
        $mimeType = $submissionFile->getData('mimetype');

        if ($mimeType === 'audio/mpeg') {
            $galleyPublication = null;
            foreach ($submission->getData('publications') as $publication) {
                if ($publication->getId() === $galley->getData('publicationId')) {
                    $galleyPublication = $publication;
                    break;
                }
            }
            $templateMgr = TemplateManager::getManager($request);
            $templateMgr->assign(array(
                'displayTemplateResource' => $this->getTemplateResource('display.tpl'),
                'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(),
                'galleyFile' => $submissionFile,
                'issue' => $issue,
                'submission' => $submission,
                'submissionNoun' => $submissionNoun,
                'bestId' => $submission->getBestId(),
                'galley' => $galley,
                'currentVersionString' => $application->getCurrentVersion()->getVersionString(false),
                'isLatestPublication' => $submission->getData('currentPublicationId') === $galley->getData('publicationId'),
                'galleyPublication' => $galleyPublication,
            ));
            $templateMgr->display($this->getTemplateResource('submissionGalley.tpl'));
            return true;
        }

        return false;
    }

    function issueCallback($hookName, $args) {
        $request =& $args[0];
        $issue =& $args[1];
        $galley =& $args[2];

        $templateMgr = TemplateManager::getManager($request);
        if ($galley && $galley->getFileType() == 'audio/mpeg') {
            $application = Application::get();
            $templateMgr->assign(array(
                'displayTemplateResource' => $this->getTemplateResource('display.tpl'),
                'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(),
                'galleyFile' => $galley->getFile(),
                'issue' => $issue,
                'galley' => $galley,
                'currentVersionString' => $application->getCurrentVersion()->getVersionString(false),
                'isLatestPublication' => true,
            ));
            $templateMgr->display($this->getTemplateResource('issueGalley.tpl'));
            return true;
        }

        return false;
    }
}
