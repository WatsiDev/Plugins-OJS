{capture assign="audioViewerUrl"}{strip}
	{if $isLatestPublication}
		{url op="download" path=$bestId|to_array:$galley->getBestGalleyId($currentJournal):$galleyFile->getId() escape=false}
	{else}
		{url op="download" path=$bestId|to_array:'version':$galleyPublication->getId():$galley->getBestGalleyId($currentJournal):$galleyFile->getId() escape=false}
	{/if}
{/strip}{/capture}
{capture assign="parentUrl"}{url page=$submissionNoun op="view" path=$bestId}{/capture}
{capture assign="galleyTitle"}{translate key="submission.representationOfTitle" representation=$galley->getLabel() title=$publication->getLocalizedFullTitle()|escape}{/capture}
{capture assign="datePublished"}{translate key="submission.outdatedVersion" datePublished=$galleyPublication->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$parentUrl|escape}{/capture}
{include file=$displayTemplateResource title=$submission->getLocalizedTitle()|escape parentUrl=$parentUrl|escape 
audioViewerUrl=$audioViewerUrl|escape galleyTitle=$galleyTitle|escape datePublished=$datePublished|escape}
