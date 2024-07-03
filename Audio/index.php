<?php

// Importa el archivo 'ViewerAudio.inc.php' que probablemente contiene la definición de la clase ViewerAudio.
require_once('PlayerAudio.inc.php');
// Crea y devuelve una nueva instancia de la clase ViewerAudio.
// Esto permite que la instancia se use inmediatamente después de que se incluya el archivo.
return new PlayerAudio();
