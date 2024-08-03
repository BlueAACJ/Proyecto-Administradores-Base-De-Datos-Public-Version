const formulario = document.getElementById('formAgregarAdmin');
const inputs = document.querySelectorAll('#formAgregarAdmin input');

const expresiones = {
    cedula: /^[0-9A-Za-z\-]{15}[A-Z]$/, //letras, números y guion   
    nombre: /^[a-zA-ZÀ-ÿ\s]{1,40}$/, // Letras y espacios, pueden llevar acentos.
    apellidos: /^[a-zA-ZÀ-ÿ\s]{1,40}$/, // Letras y espacios, pueden llevar acentos.
    telefono: /^\d{8}$/, // 8 números solo números
    correo: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
};

const campos = {
    CedulaAdministrador: false,
    NombresAdministrador: false,
    ApellidosAdministrador: false,
    NumeroTelefonoAdministrador: false,
    CorreoAdministrador: false,
};

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

const validarFormulario = (e) => {
    switch (e.target.name) {
        case "CedulaAdministrador":
                formatearCedula(e.target);
                document.getElementById('CedulaAdministrador').addEventListener('input', limitarLongitudCedula);
                validarCampo(expresiones.cedula, e.target, 'CedulaAdministrador', 'CedulaAdministradorOutput');
            break;
        case "NombresAdministrador":
                validarCampo(expresiones.nombre, e.target, 'NombresAdministrador', 'NombresAdministradorOutput');
            break;
        case "ApellidosAdministrador":
                validarCampo(expresiones.apellidos, e.target, 'ApellidosAdministrador', 'ApellidosAdministradorOutput');
            break;
        case "NumeroTelefonoAdministrador":
                validarCampo(expresiones.telefono, e.target, 'NumeroTelefonoAdministrador', 'NumeroTelefonoAdministradorOutput');
                document.getElementById('NumeroTelefonoAdministrador').addEventListener('input', limitarLongitudTel);
            break;
        case "CorreoAdministrador":
                validarCampo(expresiones.correo, e.target, 'CorreoAdministrador', 'CorreoAdministradorOutput');
            break;
    }
};

const validarCampo = (expresion, input, campo, campoOutput) => {
    if (expresion.test(input.value)) {
        document.getElementById(`grupo_${campo}`).classList.remove('mb-3-incorrecto');
        document.getElementById(`grupo_${campo}`).classList.add('mb-3-correcto');
        document.querySelector(`#grupo_${campo} .formulario__input-error`).classList.remove('formulario__input-error-activo');
        campos[campo] = true;
        var campoPost = document.getElementById(campoOutput);
        campoPost.value = input.value; 
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

    if (campos.CedulaAdministrador && campos.NombresAdministrador && campos.ApellidosAdministrador && campos.NumeroTelefonoAdministrador && campos.CorreoAdministrador) {
        document.getElementById('modalAgregarForm').classList.add('show');
        document.getElementById('modalAgregarForm').style.display = 'block';
    } else {
        document.getElementById('formulario__mensaje').classList.add('formulario__mensaje-activo');
    }
});

formulario.addEventListener('submit', (e) => {
    e.preventDefault();
    if (campos.CedulaAdministrador && campos.NombresAdministrador && campos.ApellidosAdministrador && campos.NumeroTelefonoAdministrador && campos.CorreoAdministrador) {
        formulario.submit();
    } else {
        document.getElementById('formulario__mensaje').classList.add('formulario__mensaje-activo');
    }
});