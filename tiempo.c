#include <stdio.h>
#include <stdlib.h>

void imprimir_valor();
void leer_valor();
#define CHAR_BITS 8

void interrupcion(void){
	for(int i=0;i<=32767;i++){

	}
}

void print_binint(int num){

    int sup = CHAR_BITS*1;
    while(sup >= 0){
        if(num & (((int)1) << sup))
            printf("1");
        else
            printf("0");
        sup--;
        }
    printf("\n");
}

int rotleft(int num){
    int i=0;
    for (i;i<8;i++){
    	num<<=1;
    	print_binint(num);
    return num;
    }
}
int rotright(int num){
    int i=0;
    for (i;i<8;i++){
    	num>>=1;
    	print_binint(num);
    return num;
    }
}

#define valor 0x03

int main()
{
    int num,g;//boton de reset para que espere 1seg
    printf("introduzca un numero entero:");
    scanf("%d", &num);

    printf("Número binario\n");
    print_binint(num);
    printf("\n");
    printf("%lu\n",((long int)1));

    printf("Presiona 1:para rotar \n\t  0 para reset: ");
    scanf("%d", &g);

    if(g==1){
    	num=rotleft(num);
    	interrupcion();
    	num=rotright(num);

    	}
    else{
    	interrupcion();
    }

    return 0;
}
