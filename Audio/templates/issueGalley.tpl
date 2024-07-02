<!-- Captura y asigna la URL del audio -->
{capture assign="audioUrl"}
    {url op="download" path=$issue->getBestIssueId($currentJournal)|to_array:$galley->getBestGalleyId($currentJournal) escape=false}
{/capture}

<!-- Captura y asigna la URL del número de la revista -->
{capture assign="parentUrl"}
    {url page="issue" op="view" path=$issue->getBestIssueId($currentJournal)}
{/capture}

<!-- Captura y asigna el título del audio traducido dinámicamente -->
{capture assign="audioTitle"}
    {translate key="submission.representationOfTitle" representation=$galley->getLabel() title=$issue->getIssueIdentification()|escape}
{/capture}

<!-- Captura y asigna la fecha de publicación formateada -->
{capture assign="datePublished"}
    {translate key="submission.outdatedVersion" datePublished=$issue->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$parentUrl|escape}
{/capture}

<!-- Incluye un archivo de plantilla y le pasa variables -->
{include file=$displayTemplateResource title=$issue->getIssueIdentification()|escape parentUrl=$parentUrl|escape audioUrl=$audioUrl|escape audioTitle=$audioTitle|escape datePublished=$datePublished|escape}
