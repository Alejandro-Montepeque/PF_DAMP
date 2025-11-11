// Esta función SÍ es JavaScript puro.
// Recibe un parámetro "mensaje" y lo muestra.
function mostrarAlertaExito(mensaje) {
    Swal.fire({
        icon: 'success',
        title: '¡Éxito!',
        text: mensaje,
        timer: 2000,
        timerProgressBar: true
    });
}

function mostrarAlertaError(mensaje) {
    Swal.fire({
        icon: 'error',
        title: 'Oops... Algo salió mal',
        text: mensaje
    });
}