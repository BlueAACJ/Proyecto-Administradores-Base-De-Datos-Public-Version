//ultimos cambios 12 de abril

//el parametro role puede ser colaborador o administrador, esto depende del link que esté clickeado
//en la navbar

function setRole(role) 
{
    var colaboradorLink = document.getElementById('colaboradorLink');
    var administradorLink = document.getElementById('administradorLink');
    //necesitamos esta variable para hacer el manejo de roles
    var rolInput = document.getElementById('rolInput');
    // Quita la clase 'active' de todas las opciones para despues mantenerlas activadas dependiendo del 
    // rol seleccionado
    colaboradorLink.classList.remove('active');
    administradorLink.classList.remove('active');

    //dependiendo del parametro enviado ocultamos los campos de colaborador o administrador
    // con block mostramos y con none ocultamos, en casp de que los campos de colaborador se muestren
    // debemos mantener activo el link de la navbar

    if (role === 'colaborador') 
    {
        document.getElementById('camposColaborador').style.display = 'block';
        document.getElementById('camposAdministrador').style.display = 'none';
        colaboradorLink.classList.add('active');
    } 
    else if (role === 'administrador') 
    {
        document.getElementById('camposColaborador').style.display = 'none';
        document.getElementById('camposAdministrador').style.display = 'block';
        administradorLink.classList.add('active');
    }

    //al finalizar actualizamos el valor del roleInput para que dependa el parametro role y asi que este
    // dependa de la seleccion
    rolInput.value = role;
}
