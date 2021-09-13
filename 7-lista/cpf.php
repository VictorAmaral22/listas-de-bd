<html>
<body>

<?php 

echo "<h3>Validação de CPF...</h3><br>";

if(!isset($_POST["cpf"])){
    echo "CPF NÃO INFORMADO";
} else {
    if(!preg_match("#[0-9]{11}#", $_POST["cpf"])){
        echo "CPF INVÁLIDO";
    } else {
        $cpf = $_POST["cpf"];
        echo substr($cpf, 0, 3).".".substr($cpf, 3, 3).".".substr($cpf, 6, 3)."-".substr($cpf, 9, 2);
    }
}

?>

</body>
</html>