{**
 * plugins/generic/videoJsViewer/templates/issueGalley.tpl
 *
 * Embedded viewing of a video galley.
 *}
{capture assign="videoUrl"}{url op="download" path=$issue->getBestIssueId($currentJournal)|to_array:$galley->getBestGalleyId($currentJournal) escape=false}{/capture}
{capture assign="parentUrl"}{url page="issue" op="view" path=$issue->getBestIssueId($currentJournal)}{/capture}
{capture assign="galleyTitle"}{translate key="submission.representationOfTitle" representation=$galley->getLabel() title=$issue->getIssueIdentification()|escape}{/capture}
{capture assign="datePublished"}{translate key="submission.outdatedVersion" datePublished=$issue->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$parentUrl}{/capture}
{include file=$displayTemplateResource title=$issue->getIssueIdentification() parentUrl=$parentUrl videoUrl=$videoUrl galleyTitle=$galleyTitle datePublished=$datePublished}
