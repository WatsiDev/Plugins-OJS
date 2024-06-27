<?php

import('lib.pkp.classes.plugins.GenericPlugin');

class VideoJsViewerPlugin extends GenericPlugin {
    function register($category, $path, $mainContextId = null) {
        if (parent::register($category, $path, $mainContextId)) {
            if ($this->getEnabled($mainContextId)) {
                // Para OPS
                HookRegistry::register('PreprintHandler::view::galley', [$this, 'submissionCallback'], HOOK_SEQUENCE_LAST);
                // Para OJS
                HookRegistry::register('ArticleHandler::view::galley', [$this, 'submissionCallback'], HOOK_SEQUENCE_LAST);
                HookRegistry::register('IssueHandler::view::galley', [$this, 'issueCallback'], HOOK_SEQUENCE_LAST);
                AppLocale::requireComponents(LOCALE_COMPONENT_APP_COMMON);
            }
            return true;
        }
        return false;
    }

    function getDisplayName() {
        return __('plugins.generic.videoJsViewer.name');
    }

    function getDescription() {
        return __('plugins.generic.videoJsViewer.description');
    }

    function submissionCallback($hookName, $args) {
        $request = $args[0];
        $issue = $args[1];
        $galley = $args[2];
        $submission = $args[3];
        $submissionFile = $galley->getFile();

        if ($submissionFile->getData('mimetype') === 'video/mp4') {
            $templateMgr = TemplateManager::getManager($request);
            $templateMgr->assign(array(
                'displayTemplateResource' => $this->getTemplateResource('display.tpl'),
                'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(),
                'galleyFile' => $submissionFile,
                'issue' => $issue,
                'submission' => $submission,
                'galleyTitle' => $galley->getLabel(),
                'videoUrl' => $request->url(null, 'article', 'download', [$submission->getBestId(), $galley->getBestGalleyId()]),
                'datePublished' => $issue->getData('datePublished'),
            ));
            $templateMgr->display($this->getTemplateResource('issueGalley.tpl'));
            return true;
        }

        return false;
    }

    function issueCallback($hookName, $params) {
        $request = $params[0];
        $issue = $params[1];
        $galley = $params[2];

        if ($galley->getFileType() == 'video/mp4') {
            $templateMgr = TemplateManager::getManager($request);
            $templateMgr->assign(array(
                'displayTemplateResource' => $this->getTemplateResource('display.tpl'),
                'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(),
                'galleyFile' => $galley->getFile(),
                'issue' => $issue,
                'galley' => $galley,
                'videoUrl' => $request->url(null, 'issue', 'download', [$issue->getBestIssueId(), $galley->getBestGalleyId()]),
                'datePublished' => $issue->getData('datePublished'),
            ));
            $templateMgr->display($this->getTemplateResource('issueGalley.tpl'));
            return true;
        }

        return false;
    }
}
?>
