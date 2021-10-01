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
    function invalid(input, errors){
        console.log('Erro em '+input.id+': '+input.value);
        input.value = '';
        input.classList.add('erro');
        errors++;
    }
    for(let i = 0; i <= array[value-1].length-1 ; i++){
        let input = document.getElementById(array[value-1][i]);
        let regExp = new RegExp(input.pattern);
        if(regExp.test(input.value.toLowerCase())){
            if(errors == 0){
                console.log(`RegExp ${i} ok!`);
                // VALIDANDO EXERCICIO 1
                if(value == 1){
                    console.log('Exercício 1');
                    var ok = validateCpf();
                    if(ok){
                        console.log('Sucesso!');
                        if(i == array[value-1].length-1){
                            document.getElementById('form'+value).submit();
                        }
                    } else {
                        invalid(input, errors);
                    }
                }
                
                // VALIDANDO EXERCICIO 2
                if(value == 2){   
                    var ok = dataValida(i);
                    if(ok){
                        console.log('Sucesso!');
                        if(i == array[value-1].length-1){
                            document.getElementById('form'+value).submit();
                        }
                    } else {
                        invalid(input, errors);
                    }
                }

                // VALIDANDO EXERCICIO 3
                if(value == 3){
                    var ok = validateMoney();
                    if(ok){
                        if(i == array[value-1].length-1){
                            document.getElementById('form'+value).submit();
                        }
                    } else {
                        invalid(input, errors);
                    }
                }

                // VALIDANDO EXERCICIO 4
                if(value == 4){
                    var ok = numExtValid(i);
                    if(ok){
                        console.log('Sucesso!');
                        if(i == array[value-1].length-1){
                            // document.getElementById('form'+value).submit();
                        }
                    } else {
                        invalid(input, errors);
                    }
                }
            }
        } else {
            invalid(input, errors);
        }
    }
}

function unSetError(value){
    let input = document.getElementById(value);
    input.classList.remove('erro');
}

// EXRC 1
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
            console.log('CPF inválido!');
            return null;
        }
    }    
}

// EXRC 2
function dataValida(value){
    if(value == 0){
        // DATA
        var data = document.getElementById('data').value.split('/');
        parseInt(data[0]);
        parseInt(data[1]);
        parseInt(data[2]);
        console.log('Data: '+data);

        function leapYear(year){
            return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
        }
        var meses = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        var mesesBi = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        // console.log(data[2]);
        // console.log(data[1]);
        // console.log(data[0]);
        if(data[2] != 0 && data[1] != 0 && data[0] != 0){
            if(data[1] >= 1 && data[1] <= 12){
                var bi = leapYear(data[2]);
                if(bi){
                    // é bissexto
                    console.log('Bissexto');
                    if((data[0] >= 1) && (data[0] <= mesesBi[data[1]-1])){
                        console.log('Ok!');
                        return true;
                    } else {
                        console.log('Erro!');
                        return null;
                    }
                } else {
                    // não é bissexto
                    console.log('Não bissexto');
                    if((data[0] >= 1) && (data[0] <= meses[data[1]-1])){
                        console.log('Ok!');
                        return true;                
                    } else {
                        console.log('Erro!');
                        return null;
                    }
                }                
            }
        } else {
            console.log('Erro!');
            return null;
        }
    } 
    if(value == 1) {
        // DIA UTIL
        var dataUtil = document.getElementById('dataUtil').value;
        dataUtil = parseInt(dataUtil);
        if(Number.isInteger(dataUtil) && (Math.sign(dataUtil) != -1)){
            if(dataUtil !== 0){
                console.log('Sucesso!');
                return true;
            } else {
                console.log('Erro: É zero');
                return null;
            }
        } else {
            console.log('Erro: n inteiro ou negativo');
            return null;
        }
    }
    
}

// EXRC 3
function validateMoney(){
    var valor = document.getElementById('valor').value;
    console.log(valor);
    valor = valor.split(',');
    if(valor[0].charAt(0) == '0' && valor[0].length > 1){
        console.log('Erro!');
        return null;
    } else {
        if(valor[1] == '00' && parseInt(valor[0]) == 0){
            console.log('Erro!');
            return null;
        } else {
            console.log('Sucesso!');
            return true;
        }
    }   
}

// EXRC 4
function numExtValid(index){
    function checkNumber(value){
        var numExt1 = ['um','dois','três','quatro','cinco','seis','sete','oito','nove','dez','onze','doze','treze','quatorze','quinze','dezesseis','dezessete','dezoito','dezenove'];
        var numExt2 = ['vinte','trinta','quarenta','cinquenta','sessenta','setenta','oitenta','noventa'];
        var numExt3 = ['cem','cento','duzentos','trezentos','quatrocentos','quinhentos','seiscentos','setecentos','oitocentos','novecentos'];

        var regExp = new RegExp('(ce(nto|m)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( e ){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( e ){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}( milh(ão|ões) | milh(ão|ões) e | milh(ão|ões)$){0,1}(ce(m|nto)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( e ){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( e ){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}(mil |mil e |mil$| mil | mil e | mil$){0,1}(ce(m|nto)|duzentos|trezentos|quatrocentos|quinhentos|seiscentos|setecentos|oitocentos|novecentos){0,1}( | e |$){0,1}(vinte|trinta|quarenta|cinquenta|sessenta|setenta|oitenta|noventa){0,1}( | e |$){0,1}(um|dois|três|quatro|cinco|seis|sete|oito|nove|dez|onze|doze|treze|quatorze|catorze|quinze|dezesseis|dezessete|dezoito|dezenove){0,1}$');

        if(regExp.test(value)){
            console.log('Número válido');
            var num = value.split(' ');
            if(num.indexOf('') != -1){
                console.log('Erro');
                return false;              
            } else {
                // Continua a validação
                // console.log('Array '+num);
                // for (let i = 0; i < num.length; i++) {
                //     if(num[i] != 'mil' && num[i] != 'milhão' && num[i] != 'milhões'){
                //         if(numExt1.includes(num[i])){

                //         }
                //     }                    
                // }
                return true;
            }
        } else {
            console.log('Erro');
            return false;
        }
    }
    // OPERDADOR 1
    if(index == 0){
        var op1 = document.getElementById('op1').value;
        op1 = op1.toLowerCase();
        if(checkNumber(op1)){
            console.log('Sucesso!');
            return true;
        } else {
            console.log('Erro: operador 1 inválido!');
            return null;
        }
    }
    // OPERAÇÃO
    if(index == 1){
        var selectOp = document.getElementById('selectOp').value;
        const operations = ['mais', 'menos', 'mult', 'divd'];
        if(operations.includes(selectOp)){
            console.log('Operação válida!');
            return true;
        } else {
            console.log('Operação inválida!');
            return null;
        }
    }
    // OPERDADOR 2
    if(index == 2){
        var op2 = document.getElementById('op2').value;
        op2 = op2.toLowerCase();
        if(checkNumber(op2)){
            console.log('Sucesso!');
            return true;
        } else {
            console.log('Erro: operador 2 inválido!');
            return null;
        }
    }
    return true;
}

function insere(){

}