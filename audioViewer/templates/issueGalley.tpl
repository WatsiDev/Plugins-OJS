{capture assign="audioViewerUrl"}{url op="download" path=$issue->getBestIssueId($currentJournal)|to_array:$galley->getBestGalleyId($currentJournal) escape=false}{/capture}
{capture assign="parentUrl"}{url page="issue" op="view" path=$issue->getBestIssueId($currentJournal)}{/capture}
{capture assign="galleyTitle"}{translate key="submission.representationOfTitle" representation=$galley->getLabel() title=$issue->getIssueIdentification()|escape}{/capture}
{capture assign="datePublished"}{translate key="submission.outdatedVersion" datePublished=$issue->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$parentUrl|escape}{/capture}
{include file=$displayTemplateResource title=$issue->getIssueIdentification()|escape parentUrl=$parentUrl|escape audioViewerUrl=$audioViewerUrl|escape galleyTitle=$galleyTitle|escape datePublished=$datePublished|escape}
