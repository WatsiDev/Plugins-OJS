<!-- Captura y asigna la URL del audio -->
{capture assign="audioUrl"}{strip}
	{if $isLatestPublication}
		{url op="download" path=$bestId|to_array:$galley->getBestGalleyId($currentJournal):$galleyFile->getId() escape=false}
	{else}
		{url op="download" path=$bestId|to_array:'version':$galleyPublication->getId():$galley->getBestGalleyId($currentJournal):$galleyFile->getId() escape=false}
	{/if}
{/strip}{/capture}

<!-- Captura y asigna la URL del número de la revista -->
{capture assign="parentUrl"}{url page=$submissionNoun op="view" path=$bestId}{/capture}

<!-- Captura y asigna el título del audio traducido dinámicamente -->
{capture assign="galleyTitle"}{translate key="submission.representationOfTitle" representation=$galley->getLabel() title=$publication->getLocalizedFullTitle()|escape}{/capture}

<!-- Captura y asigna la fecha de publicación formateada -->
{capture assign="datePublished"}{translate key="submission.outdatedVersion" datePublished=$galleyPublication->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$parentUrl|escape}{/capture}

<!-- Incluye un archivo de plantilla y le pasa variables -->
{include file=$displayTemplateResource title=$submission->getLocalizedTitle()|escape parentUrl=$parentUrl|escape audioUrl=$audioUrl|escape galleyTitle=$galleyTitle|escape datePublished=$datePublished|escape}
