#include <stdio.h>

/*
 * Função: contaEspacosIniciais
 * ----------------------------
 *   Retorna o número de espaços que existe num determinado texto até encontrar o primeiro caracter
 *
 *   texto: Texto ao qual vai ser aplicado o cálculo
 *
 *   returns: O número de espaços iniciais existente em texto
 */
int contaEspacosIniciais(char *texto)
{

    int numEspacos = 0;

    for (int i = 0; texto[i] != '\0'; i++)
    {
        if (texto[i] == ' ')
            numEspacos++;
        else
            return numEspacos;
    }
}