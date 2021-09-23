var array = [
    ['cpf'], 
    ['data', 'dataUtil'],
    ['valor'],
    ['op1','selectOp','op2']
];

// function insere() {
//     var table = document.getElementById("tableAddRomanos");
//     console.log(table.children.length);
//     if (table.children.length < 100) {
//         // row.innerHTML +=  "<td> <input id=\"romanoOp"+row.length+"\" type=\"int\" name=\"romanoOp" + row.length + "\" required></td>";         
//         table.insertRow(-1).innerHTML =  `<td> <p>Bah ${table.children.length}</p> </td>`;         
//     }
// }

function valid(value) {
    var errors = 0;
    console.log('Valores de '+array[value-1]);
    for(let i=0; i < array[value-1].length ;i++){
        let input = document.getElementById(array[value-1][i]);
        let regExp = new RegExp(input.pattern);
        if(regExp.test(input.value)){
            if(i == (array[value-1].length-1) && errors == 0){
                console.log('RegExp ok!');
                if(value == 1){
                    var ok = validateCpf();
                    if(ok){
                        console.log('Sucesso!');
                        document.getElementById('form'+value).submit();
                    } else {
                        console.log('Erro em '+input.id+': '+input.value);
                        input.value = '';
                        input.classList.add('erro');
                        errors++;
                    }
                }
            }
        } else {
            console.log('Erro em '+input.id+': '+input.value);
            input.value = '';
            input.classList.add('erro');
            errors++;
        }
    }
}

function validateCpf(){
    var invalidCPF = ['11111111111','22222222222','33333333333','44444444444','55555555555','66666666666','77777777777','88888888888','99999999999','00000000000','12345678912'];
    var cpf = document.getElementById('cpf').value;
    console.log('Validando CPF: '+cpf);
    if(invalidCPF.includes(cpf)){
        console.log('CPF inválido!')
        return null;
    } else{
        cpf = cpf.split('');
        var calculo = 0;
        let i = 10;
        cpf.forEach(element => {
            if(i>=2){
                calculo += element*i;
                i--;
            }
        });
        var calculo2 = 0;
        if((calculo*10)%11 == cpf[cpf.length-2]){
            let i = 11;
            cpf.forEach(element => {
                if(i>=2){
                    calculo2 += element*i;
                    i--;
                }
            });
        } else {
            console.log('CPF inválido!');
            return null
        }
        if((calculo2*10)%11 ==  cpf[cpf.length-1]){
            console.log('CPF válido!');
            return true;
        } else {
            console.log('CPF iválido!');
            return null;
        }
    }    
}

function unSetError(value){
    let input = document.getElementById(value);
    input.classList.remove('erro');
}