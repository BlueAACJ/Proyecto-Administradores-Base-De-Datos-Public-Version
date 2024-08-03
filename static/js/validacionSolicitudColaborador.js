const formulario = document.getElementById('SolicitudPrestamo');
const inputs = document.querySelectorAll('#SolicitudPrestamo input, #SolicitudPrestamo textarea');
const liquidacionInput = document.querySelector('input[name="liquidacion"]');
const liquidacion = parseFloat(liquidacionInput.value.replace(/[^\d.-]/g, '')); // Obtiene el valor de liquidacion y lo convierte a número

const expresiones = {
    monto: /^[0-9]+([.,][0-9]+)?$/, // acepta decimales . y , para el decimal 
    plazo: /^[0-9]+$/, // solo numeros enteros
    motivo: /^\s*(?:\S+\s+){0,29}\S+\s*$/ // acepta hasta 30 palabras.
};

const campos = {
    MontoSolicitado: false,
    PlazoDePago: false,
    MotivoDePrestamo: false
};

const limitarLongitudMonto = (event) => {
    if (event.target.value.length > 8) {
        event.target.value = event.target.value.slice(0, 8);
    }
};

const validarFormulario = (e) => {
    switch (e.target.name) {
        case "MontoSolicitado":
            validarCampo(expresiones.monto, e.target, 'MontoSolicitado', 'MontoSolicitadoOutput');
            break;
        case "PlazoDePago":
            validarCampo(expresiones.plazo, e.target, 'PlazoDePago', 'PlazoDePagoOutput');
            break;
        case "MotivoDePrestamo":
            validarCampo(expresiones.motivo, e.target, 'MotivoDePrestamo', 'MotivoDePrestamoOutput');
            break;
    }
};

const validarCampo = (expresion, input, campo, campoOutput) => {
    if (expresion.test(input.value)) {
        if (campo === 'MontoSolicitado' && parseFloat(input.value) > liquidacion) {
            document.getElementById(`grupo_${campo}`).classList.add('mb-3-incorrecto');
            document.getElementById(`grupo_${campo}`).classList.remove('mb-3-correcto');
            document.querySelector(`#grupo_${campo} .formulario__input-error`).classList.add('formulario__input-error-activo');
            campos[campo] = false;
        } else {
            document.getElementById(`grupo_${campo}`).classList.remove('mb-3-incorrecto');
            document.getElementById(`grupo_${campo}`).classList.add('mb-3-correcto');
            document.querySelector(`#grupo_${campo} .formulario__input-error`).classList.remove('formulario__input-error-activo');
            campos[campo] = true;
            var campoPost = document.getElementById(campoOutput);
            campoPost.value = input.value;
        }
    } else {
        document.getElementById(`grupo_${campo}`).classList.add('mb-3-incorrecto');
        document.getElementById(`grupo_${campo}`).classList.remove('mb-3-correcto');
        document.querySelector(`#grupo_${campo} .formulario__input-error`).classList.add('formulario__input-error-activo');
        campos[campo] = false;
    }
};

// Solo permitir números en MontoSolicitado y PlazoDePago
const permitirSoloNumeros = (event) => {
    const charCode = event.which ? event.which : event.keyCode;
    if ((charCode < 48 || charCode > 57) && charCode !== 8 && charCode !== 9 && charCode !== 37 && charCode !== 39) {
        event.preventDefault();
    }
};

document.getElementById('MontoSolicitado').addEventListener('keydown', permitirSoloNumeros);
document.getElementById('PlazoDePago').addEventListener('keydown', permitirSoloNumeros);

inputs.forEach((input) => {
    input.addEventListener('keyup', validarFormulario);
    input.addEventListener('blur', validarFormulario);
});

formulario.addEventListener('submit', (e) => {
    e.preventDefault();

    if (campos.MontoSolicitado && campos.PlazoDePago && campos.MotivoDePrestamo) {
        document.getElementById('formulario__mensaje').classList.remove('formulario__mensaje-activo');
        formulario.submit();
    } else {
        document.getElementById('formulario__mensaje').classList.add('formulario__mensaje-activo');
    }
});
