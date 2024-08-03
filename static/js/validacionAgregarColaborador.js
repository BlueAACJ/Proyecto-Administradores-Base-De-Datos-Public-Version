const formulario = document.getElementById('formAgregar');
const inputs = document.querySelectorAll('#formAgregar input');

//expresiones regualres para validar campos
const expresiones = {
    cedula: /^[0-9A-Za-z\-]{15}[A-Z]$/, // letras, números y guion
    nombre: /^[a-zA-ZÀ-ÿ\s]{1,40}$/, // Letras y espacios, pueden llevar acentos.
    apellidos: /^[a-zA-ZÀ-ÿ\s]{1,40}$/, // Letras y espacios, pueden llevar acentos.
    salario: /^\d{1,3}(,\d{3})*(\.\d{1,2})?$/, // Solo números y puede tener decimales
    telefono: /^\d{8}$/, // 8 números solo números
    correo: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/ //solo correos validos
};
//los campos estaran en false antes de ser modificados
const campos = {
    CedulaColaborador: false,
    NombresColaborador: false,
    ApellidosColaborador: false,
    SalarioColaborador: false,
    NumeroTelefonoColaborador: false,
    CorreoColaborador: false,
    FechaContratacion: false
};
function updateTipoContrato() {
    const fechaContratacion = document.getElementById('FechaContratacion').value;
    const tipoContrato = document.getElementById('TipoDeContrato');
    const determinadoOption = document.querySelector('#TipoDeContrato option[value="D"]');
    const indeterminadoOption = document.querySelector('#TipoDeContrato option[value="I"]');

    if (fechaContratacion) {
        const fechaContratacionDate = new Date(fechaContratacion);
        const currentDate = new Date();
        const diffYears = currentDate.getFullYear() - fechaContratacionDate.getFullYear();
        const diffMonths = currentDate.getMonth() - fechaContratacionDate.getMonth();

        if (diffYears > 3 || (diffYears === 3 && diffMonths >= 0)) {
            tipoContrato.value = 'I';
            indeterminadoOption.disabled = false;
            determinadoOption.disabled = true;
        } else {
            tipoContrato.value = 'D';
            determinadoOption.disabled = false;
            indeterminadoOption.disabled = true;
        }
    }
}
// Llamada inicial para establecer el tipo de contrato basado en la fecha de contratación al cargar la página
updateTipoContrato();
// Evento para actualizar el tipo de contrato cuando cambia la fecha de contratación
document.getElementById('FechaContratacion').addEventListener('change', updateTipoContrato);

const formatearCedula = (input) => {
    let value = input.value.replace(/-/g, ''); // Eliminar cualquier guion existente
    if (value.length > 3 && value.length <= 9) {
        value = value.slice(0, 3) + '-' + value.slice(3);
    } else if (value.length > 9) {
        value = value.slice(0, 3) + '-' + value.slice(3, 9) + '-' + value.slice(9);
    }
    input.value = value;
};
const limitarLongitudCedula = (event) => {
    if (event.target.value.length > 16) {
        event.target.value = event.target.value.slice(0, 16);
    }
};
const limitarLongitudTel = (event) => {
    if (event.target.value.length > 8) {
        event.target.value = event.target.value.slice(0, 8);
    }
};
function moneda(e){
    e.value = e.value.replace(/[^0-9.]/g, "").replace(/\B(?=(\d{3})+(?!\d)\.?)/g, ",");
}

function decimal(event, cadena) {
    var anterior = event.key;
    var cadena = cadena.value + anterior;
    cadena = cadena.replace(/,/g, ""); // Eliminar comas si las hubiera
    var codigo = event.which;

    if ((codigo === 8 || codigo === 46 || codigo === 37 || codigo === 39)) {
        return true;
    } else if ((codigo >= 48 && codigo <= 57) || codigo === 190) {
        // Verificar que no haya más de un punto decimal y máximo dos decimales después del punto
        var expresion = /^([0-9]+\.?[0-9]{0,2})$/;
        return expresion.test(cadena);
    } else {
        return false;
    }
}

const validarFormulario = (e) => {
    switch (e.target.name) {
    case "FechaContratacion":
            validarFecha(e.target, 'FechaContratacion', 'FechaContratacionOutput');
        break;
    case "CedulaColaborador":
            formatearCedula(e.target);
            document.getElementById('CedulaColaborador').addEventListener('input', limitarLongitudCedula);
            validarCampo(expresiones.cedula, e.target, 'CedulaColaborador', 'CedulaColaboradorOutput');
        break;
    case "NombresColaborador":
            validarCampo(expresiones.nombre, e.target, 'NombresColaborador', 'NombresColaboradorOutput');
        break;
    case "ApellidosColaborador":
            validarCampo(expresiones.apellidos, e.target, 'ApellidosColaborador', 'ApellidosColaboradorOutput');
        break;
    case "SalarioColaborador":
            validarCampo(expresiones.salario, e.target, 'SalarioColaborador', 'SalarioColaboradorOutput');
        break;
    case "NumeroTelefonoColaborador":
            validarCampo(expresiones.telefono, e.target, 'NumeroTelefonoColaborador', 'NumeroTelefonoColaboradorOutput');
            document.getElementById('NumeroTelefonoColaborador').addEventListener('input', limitarLongitudTel);
        break;
    case "CorreoColaborador":
            validarCampo(expresiones.correo, e.target, 'CorreoColaborador', 'CorreoColaboradorOutput');
        break;
    }
};
//validaciones de campos
const validarCampo = (expresion, input, campo, campoOutput) => {
    if (expresion.test(input.value)) {
        document.getElementById(`grupo_${campo}`).classList.remove('mb-3-incorrecto');
        document.getElementById(`grupo_${campo}`).classList.add('mb-3-correcto');
        document.querySelector(`#grupo_${campo} .formulario__input-error`).classList.remove('formulario__input-error-activo');
            campos[campo] = true;
            var campoPost = document.getElementById(campoOutput);
            campoPost.value = input.value; // Asigna el valor del campo CedulaColaborador al campo CedulaColaboradorOutput
    } else {
        document.getElementById(`grupo_${campo}`).classList.add('mb-3-incorrecto');
        document.getElementById(`grupo_${campo}`).classList.remove('mb-3-correcto');
        document.querySelector(`#grupo_${campo} .formulario__input-error`).classList.add('formulario__input-error-activo');
            campos[campo] = false;
    }
};
//validacion de fecha
const validarFecha = (input, campo, campoOutput) => {
    const fechaIngresada = new Date(input.value);
    const fechaActual = new Date();
    if (fechaIngresada && fechaIngresada < fechaActual && fechaIngresada.getFullYear() > 1980) {
        document.getElementById(`grupo_${campo}`).classList.remove('mb-3-incorrecto');
        document.getElementById(`grupo_${campo}`).classList.add('mb-3-correcto');
        document.querySelector(`#grupo_${campo} .formulario__input-error`).classList.remove('formulario__input-error-activo');
        campos[campo] = true;
        var campoPost = document.getElementById(campoOutput);
        campoPost.value = input.value; // Asigna el valor del campo al campo de salida
    } else {
        document.getElementById(`grupo_${campo}`).classList.add('mb-3-incorrecto');
        document.getElementById(`grupo_${campo}`).classList.remove('mb-3-correcto');
        document.querySelector(`#grupo_${campo} .formulario__input-error`).classList.add('formulario__input-error-activo');
        campos[campo] = false;
    }
};

inputs.forEach((input) => {
    input.addEventListener('keyup', validarFormulario);
    input.addEventListener('blur', validarFormulario);
});

document.querySelector('.validate-before-submit').addEventListener('click', (e) => {
    e.preventDefault();
    if (campos.CedulaColaborador && campos.NombresColaborador && campos.ApellidosColaborador && campos.SalarioColaborador && campos.NumeroTelefonoColaborador && campos.CorreoColaborador && campos.FechaContratacion) {
        document.getElementById('modalAgregarForm').classList.add('show');
        document.getElementById('modalAgregarForm').style.display = 'block';
    } else {
        document.getElementById('formulario__mensaje').classList.add('formulario__mensaje-activo');
    }
});
        
formulario.addEventListener('submit', (e) => {
    e.preventDefault();
    if (campos.CedulaColaborador && campos.NombresColaborador && campos.ApellidosColaborador && campos.SalarioColaborador && campos.NumeroTelefonoColaborador && campos.CorreoColaborador && campos.FechaContratacion) {
        formulario.submit();
    } else {
        document.getElementById('formulario__mensaje').classList.add('formulario__mensaje-activo');
    }
});
//evita errores en el modal para cerrar el modal
document.querySelector('.modal-footer .btn-secondary').addEventListener('click', () => {
    const modal = document.getElementById('modalAgregarForm');
    modal.classList.remove('show');
    modal.style.display = 'none';
});
document.querySelector('.modal-header .btn-close').addEventListener('click', () => {
    const modal = document.getElementById('modalAgregarForm');
    modal.classList.remove('show');
    modal.style.display = 'none';
});
