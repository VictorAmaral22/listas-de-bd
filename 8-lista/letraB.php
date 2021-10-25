<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>B</title>
</head>
<body>
<?php
    var_dump($_POST);
    $db = new SQLite3("pizzaria.db");
    $db->exec("PRAGMA foreign_keys = ON");
    $nome;
    $tipo;
    $ingredientes = [];
    if(isset($_POST['confirma'])){
        if(isset($_POST['nome']) && isset($_POST['tipo'])){
            $nome = $_POST['nome'];
            $tipo = $_POST['tipo'];
            $qtd = $db->query("select count(*) as qtd from ingrediente");
            $result;
            while ($row = $qtd->fetchArray()) { $result = $row; } 
            $qtd = $result['qtd'];
            for($c = 1; $c <= $qtd; $c++){
                if(isset($_POST["ingr$c"])){
                    $ingredientes[] = $_POST["ingr$c"];
                }
            }
		    $db->exec("insert into sabor (nome, tipo) values ('".$_POST["nome"]."', '".$_POST["tipo"]."')");
		    $saborId = $db->lastInsertRowID();
		    foreach ($ingredientes as $ingred) {
                $db->exec("insert into saboringrediente (sabor, ingrediente) values ('".$saborId."', '".$ingred."')");
            }
        } else {
            echo "Erro!";
        }
    }
?>
<h1>Inclusão de Sabores</h1>
<form name="insert" action="letraB.php" method="post">
    <table>
        <tr>
            <td>Nome</td>
            <td><input type="text" name="nome" value="" size="50"></td>
        </tr>
        <tr>
            <td>Tipo</td>
            <td>
                <select id="tipo" name="tipo">
                    <?php 
                        $tipos = $db->query("select * from tipo");
                        while ($row = $tipos->fetchArray()) { echo "<option value=\"".$row['codigo']."\">".$row['nome']."</option>\n"; }
                    ?>
                </select>
            </td>
        </tr>
        <tr>
            <td>Ingrediente</td>
            <td>
                <select id="ingrediente">
                <?php 
                    $ingredientes = $db->query("select * from ingrediente");
                    while ($row = $ingredientes->fetchArray()) { echo "<option id='option".$row['codigo']."' value='{ \"id\": \"".$row['codigo']."\", \"name\": \"".$row['nome']."\" }'\">".$row['nome']."</option>\n"; }
                ?>
                </select>
                <input type="button" id='addIngrediente' onclick='addIngr()' value="+"/>
            </td>
        </tr>
        <tr>
            <td>Ingredientes</td>
            <td><table id="tableIngr" border="1" name='tableIngr'>
            </table></td>
        </tr>
    </table>
    <input type="submit" name="confirma" value="Confirma">
</form>

<script>

var num = 1;
function addIngr(){
    var ingr = document.getElementById('ingrediente').value;
    ingr = JSON.parse(ingr);
    var table = document.getElementById('tableIngr');
    var option = document.getElementById('option'+ingr.id);
    option.remove();
    table.innerHTML += `<tr id="row${ingr.id}"><td>${ingr.name}<input type="hidden" value="${ingr.id}" name="ingr${ingr.id}" /></td><td><button onclick="removeIngr('${ingr.id}', '${ingr.name}')">❌</button></td></tr>`;
    num++;
}
function removeIngr(id, name){
    var table = document.getElementById('tableIngr');
    var row = document.getElementById('row'+id);
    var select = document.getElementById('ingrediente');
    select.innerHTML += `<option id='option${id}' value='{ "id": "${id}", "name": "${name}" }'>${name}</option>\n`
    row.remove();
}

</script>

</body>
</html>