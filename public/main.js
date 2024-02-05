$(document).ready(function () {
    $("#urlForm").submit(function (event) {
        event.preventDefault();
        var url = $("#url").val();

        axios.post('http://127.0.0.1:3000/save_info?url=' + url)
            .then((response) => {
                alert("Operação iniciada com sucesso. ID: " + response.data.id);
            })
            .catch((error) => {
                alert("Erro: " + error.response.data.message);
            });
    });

    $("#idForm").submit(function (event) {
        event.preventDefault();
        var searchId = $("#searchId").val();

        axios.get('http://127.0.0.1:3000/get_info/' + searchId)
            .then((response) => {
                alert("Informações: " + JSON.stringify(response.data.message, null, 2));
            })
            .catch((error) => {
                alert("Erro: " + error.response.data.message);
            });
    });
});
