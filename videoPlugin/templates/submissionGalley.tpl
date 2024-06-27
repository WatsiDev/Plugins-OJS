{capture assign=pageTitle}{translate key="plugins.generic.videoJsViewer.watchVideo"}{/capture}
{include file="frontend/components/header.tpl"}

<div class="container" style="text-align: center; margin-top: 30px;">
    <h2>{$galleyFile->getLabel()}</h2>
    <div style="display: inline-block; max-width: 100%; width: 80%;">
        <video id="video-js" class="video-js vjs-default-skin vjs-big-play-centered" controls preload="auto" width="100%" height="auto" data-setup="{}">
            <source src="{url page="article" op="download" path=$galleyFile->getBestGalleyId()}" type="video/mp4">
            <p class="vjs-no-js">
                {translate key="plugins.generic.videoJsViewer.noJsMessage"}
            </p>
        </video>
    </div>
</div>

<link href="https://vjs.zencdn.net/7.10.2/video-js.css" rel="stylesheet" />
<script src="https://vjs.zencdn.net/7.10.2/video.js"></script>

<style>
    .vjs-big-play-centered .vjs-big-play-button {
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
    }
</style>

{include file="frontend/components/footer.tpl"}

