window.addEventListener('DOMContentLoaded', event => {
    const datatablesSimple = document.getElementById('datatablesSimple');
    if (datatablesSimple) {
        new simpleDatatables.DataTable(datatablesSimple, {
            labels: {
                placeholder: "Buscar...", // Placeholder text for search input.
                perPage: "Registros por página", // per-page dropdown label.
                noRows: "No se encontraron registros", // Message shown when there are no matching records.
                info: "Mostrando {start} a {end} de {rows} registros", // Info string for showing records.
                noResults: "No se encontraron resultados", // Message shown when no results match the search.
                first: "Primero", // Label for the first page button.
                last: "Último", // Label for the last page button.
                previous: "Anterior", // Label for the previous page button.
                next: "Siguiente", // Label for the next page button.
            },
            searchable: true,
            fixedHeight: true,
            perPage: 15, // Número de registros por página
            perPageSelect: [5, 10, 15, 20], // Opciones para seleccionar registros por página
            columns: [
                { select: 0, sort: "desc" } // Asegúrate de que 0 sea el índice de la columna de fecha
            ]
        });
    }
});
