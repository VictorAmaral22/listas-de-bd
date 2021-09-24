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
    console.log('Recebendo de: '+array[value-1]);
    for(let i=0; i < array[value-1].length ;i++){
        let input = document.getElementById(array[value-1][i]);
        let regExp = new RegExp(input.pattern);
        if(regExp.test(input.value)){
            if(i == (array[value-1].length-1) && errors == 0){
                console.log('RegExp ok!');
                // VALIDANDO EXERCICIO 1
                if(value == 1){
                    console.log('Exercício 1');
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

                // VALIDANDO EXERCICIO 2
                // ...

                // VALIDANDO EXERCICIO 3
                if(value == 3){
                    console.log('Exercício 3');
                    var ok = validateMoney();
                    if(ok){
                        console.log('Sucesso!');
                        // document.getElementById('form'+value).submit();
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

function unSetError(value){
    let input = document.getElementById(value);
    input.classList.remove('erro');
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

function validateMoney(){
    var numExt = [
        ['zero', 'um', 'dois', 'três', 'quatro', 'cinco', 'seis', 'sete', 'oito', 'nove', 'dez', 
        'onze', 'doze', 'treze', 'quatorze', 'quinze', 'dezesseis', 'dezessete', 'dezoito', 'dezenove'],
        ['vinte', 'trinta', 'quarenta', 'cinquenta', 'sessenta', 'setenta', 'oitenta', 'noventa'],
        ['cem', 'duzentos', 'trezentos', 'quatrocentos', 'quinhentos', 'seiscentos', 'setecentos', 'oitocentos', 'novecentos']
    ];
    var valor = document.getElementById('valor').value;
    valor.toString();
    valor = valor.split(',');
    // console.log(valor);
    var reais = valor[0];
    var cents = valor[1];
    var texto = '';

    if(reais[0] == '0' && reais.length > 1){
        return null;
    } else{
        var casas = reais.length;
        console.log(casas);
        if(casas == 9){
            if(reais[1] == '0'){
                if(reais[2] == '0'){
                    texto += numExt[2][parseInt(reais[0])-1]+' milhões';
                } else {
                    texto += numExt[2][parseInt(reais[0])-1]+' e '+numExt[0][parseInt(reais[2])]+' milhões';
                }    
            } else {
                if(parseInt(reais[1]) == 1){
                    texto += numExt[2][parseInt(reais[0])-1]+' e '+numExt[0][parseInt(reais[1]+reais[2])]+' milhões';
                } else {
                    if(parseInt(reais[2]) == 0){
                        texto += numExt[2][parseInt(reais[0])-1]+' e '+numExt[1][parseInt(reais[1])-2]+' milhões';
                    } else {
                        texto += numExt[2][parseInt(reais[0])-1]+' e '+numExt[1][parseInt(reais[1])-2]+' e '+numExt[0][parseInt(reais[2])] +' milhões';                        
                    }
                }
            }
        }        

        // console.log(texto);
        return true;
        // continua
    }
}