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
    $db = new SQLite3("pizzaria.db");
    $db->exec("PRAGMA foreign_keys = ON");
?>
<h1>Inclusão de Sabores</h1>
<form name="insert" action="insert.php" method="post">
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
                <select id="ingrediente" name="ingrediente">
                <?php 
                    $ingredientes = $db->query("select * from ingrediente");
                    while ($row = $ingredientes->fetchArray()) { echo "<option value='{ \"id\": \"".$row['codigo']."\", \"name\": \"".$row['nome']."\" }'\">".$row['nome']."</option>\n"; }
                ?>
                </select>
                <input type="button" id='addIngrediente' onclick='addIngr()' value="+"/>
            </td>
        </tr>
        <tr>
            <td>Ingredientes</td>
            <td><table id="tableIngr" border="1"></table></td>
        </tr>
    </table>
    <input type="submit" name="confirma" value="Confirma">
</form>

<script>

var ingredientes = [];

function addIngr(){
    let erro = 0;

    let table = document.getElementById('tableIngr');
    let ingrediente = document.getElementById('ingrediente').value;
    let newI = JSON.parse(ingrediente);
    ingredientes.forEach(elem => {
        if(elem.id == newI.id){
            console.log('tá ai: '+elem.id+' '+newI.id);
            erro++;
        }
    });
    if(erro != 0){
        alert('Você já adicionou esse ingrediente!');
    } else {
        table.innerHTML = '';
        ingredientes.push(newI);
        ingredientes.forEach(ingr => {
            let tr = document.createElement('tr');
            let td = document.createElement('td');
            let tdDel = document.createElement('td');
            let tdDelBtn = document.createElement('input');
            td.innerHTML = ingr.name;
            tr.id = ingr.id;
            tdDelBtn.type = 'button';
            tdDelBtn.value = 'x';
            tdDelBtn.onclick = function () {
                let index = ingredientes.indexOf(this.parentElement.parentElement.id);
                ingredientes.splice((index-1), 1);
                console.log(ingredientes);
                tr.parentNode.removeChild(tr);
            }
            tdDel.append(tdDelBtn);
            tr.append(td);
            tr.append(tdDel);
            table.append(tr);
        });
    }
}

</script>

<?php
// if (isset($_POST["confirma"])) {
// 	$error = "";
// 	if ($error == "") {
// 		$db->exec("insert into sabor (nome, tipo) values ('".$_POST["nome"]."', '".$_POST["tipo"]."')");
// 		// $db->exec("insert into saboringrediente (sabor, ingrediente) values ('".$_POST["sabor"]."', '".$_POST["ingrediente"]."')");
// 		echo $db->changes()." sabor(es) incluído(s)<br>\n";
// 		echo $db->lastInsertRowID()." é o código do último sabor incluído.\n";
// 		$db->close();
// 	} else {
// 		echo "<font color=\"red\">".$error."</font>";
// 	}
// } else {
//     echo "<h1>Inclusão de Sabores</h1>\n";
// 	echo "<form name=\"insert\" action=\"insert.php\" method=\"post\">\n";
// 	echo "<table>\n";
// 	echo "<tr>\n";
// 	echo "<td>Nome</td>\n";
// 	echo "<td><input type=\"text\" name=\"nome\" value=\"\" size=\"50\"></td>\n";
// 	echo "</tr>\n";
// 	echo "<tr>\n";
// 	echo "<td>Tipo</td>\n";
//     echo "<td><select id=\"tipo\" name=\"tipo\">\n";
//     $tipos = $db->query("select * from tipo");
//     while ($row = $tipos->fetchArray()) { echo "<option value=\"".$row['codigo']."\">".$row['nome']."</option>\n"; }
//     echo "</select></td>\n";
// 	echo "</tr>\n";
//     echo "<td>Ingrediente</td>\n";
//     echo "<td><select id=\"ingrediente\" name=\"ingrediente\">\n";
//     $ingredientes = $db->query("select * from ingrediente");
//     while ($row = $ingredientes->fetchArray()) { echo "<option value=\"".[$row['codigo'], $row['nome']]."\">".$row['nome']."</option>\n"; }
//     echo "</select>\n";
//     echo "<input type=\"button\" id='addIngrediente' value=\"+\"/></td>\n";
// 	echo "</tr>\n";
//     echo "<tr>";
//     echo "<td>Ingredientes</td>\n";
//     echo "<td>";
//     echo "<table id=\"tableIngr\"></table>";
//     echo "</td>\n";
//     echo "</tr>";
// 	echo "</table>\n";
// 	echo "<input type=\"submit\" name=\"confirma\" value=\"Confirma\">\n";
// 	echo "</form>\n";
// }
// if (isset($_POST["confirma"])) {
// 	echo "<script>setTimeout(function () { window.open(\"letraA.php\",\"_self\"); }, 3000);</script>";
// }
?>
</body>
</html>