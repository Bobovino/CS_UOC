section .note.GNU-stack noalloc noexec nowrite progbits
section .data               
;Cambiar Nombre y Apellido por vuestros datos.
developer db "_Luis_ _Rodrigo_ _Martinez_ _Tabernero_",0

;Constante que también está definida en C.
DIMMATRIX    equ 4      
SIZEMATRIX   equ DIMMATRIX*DIMMATRIX ;=16

section .text        
;Variables definidas en ensamblador.
global developer     
                         
;Subrutinas de ensamblador que se llaman desde C.
global showNumberP1, updateBoardP1, copyMatrixP1, 
global rotateMatrixLRP1, shiftNumbersLP1, addPairsLP1
global playP1

;Variables globales definidas en C.
extern rowScreen, colScreen, charac, state
extern m, mRotated, number, score, dir

;Funciones de C que se llaman desde ensamblador.
extern clearScreen_C, gotoxyP1_C, getchP1_C, printchP1_C
extern printBoardP1_C, insertTileP1_C, printMessageP1_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: Recordad que en ensamblador las variables y los parámetros 
;;   de tipo 'char' deben asignarse a registros de tipo  
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   los de tipo 'short' deben asignarse a registros de tipo 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   los de tipo 'int' deben asignarse a registros de tipo 
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   los de tipo 'long' deben asignarse a registros de tipo 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Las subrutinas en ensamblador que debéis implementar son:
;;   showNumberP1, updateBoardP1, copyMatrixP1,  
;;   rotateMatrixLRP1, shiftNumbersLP1, addPairsLP1.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se proporciona ya hecha. NO LA PODÉIS MODIFICAR.
; Posicionar el cursor en la fila indicada por la variable (rowScreen) y 
; en la columna indicada por la variable (colScreen) de la pantalla,
; llamando a la función gotoxyP1_C.
; 
; Variables globales utilizadas:   
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se proporciona ya hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter guardado en la variable (charac) en la pantalla, 
; en la posición donde está el cursor, llamando a la función printchP1_C.
; 
; Variables globales utilizadas:   
; (charac): Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se proporciona ya hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla y guardar el carácter asociado en la variable (charac)
; sin mostrarlo en pantalla, llamando a la función getchP1_C. 
; 
; Variables globales utilizadas:   
; (charac): Carácter que leemos de teclado.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call getchP1_C
 
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 


;;;;;
; Convierte el número de la variable (number) de tipo long de 6 dígitos
; (0 <= nuberm <= 999999) a caracteres ASCII que representan su valor.
; Si (num) es menor que 0 cambiamos el valor a 0,
; si es mayor que 999999, cambiaremos el valor a 999999.
; Se debe dividir(/) el valor entre 10, de forma iterativa,
; hasta obtener el 6 dígitos.
; En cada iteración, el residuo de la división (%) que es un valor
; entre (0-9) indica el valor del dígito a convertir
; a ASCII ('0' - '9') sumando '0' (48 decimal) para poder mostrarlo.
; Cuando el cociente sea 0 mostraremos espacios en la parte no significativa.
; Por ejemplo, si (number)=103 mostraremos "   103" y no "000103".
; Se deben mostrar los dígitos (carácter ASCII) desde la posición
; indicada por las variables (rowScreen) y (colScreen)
; posición de las unidades, hacia la izquierda.
; El primer dígito que obtenemos son las unidades, después las decenas,
; ..., para mostrar el valor se debe desplazar el cursor una posición
; a la izquierda en cada iteración.
; Para posicionar el cursor se llama a la subrutina gotoxyP1 y para
; mostrar los caracteres en la subrutina printchP1.
;
; Variables globales utilizadas:
; (number)   : Número que queremos mostrar.
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
; (charac)   : Carácter a escribir en pantalla.
;;;;;
;

;-------------------------------------------------------------------------
; COMO YA TENEMOS LAS FUNCIONES EN C, 
; SOLO TENEMOS QUE TRADUCIR EL CÓDIGO A ENSAMBLADOR
; PERO EL ALGORITMO YA LO TENEMOS, SOLO FALTA LA PARTE TEDIOSA
;-------------------------------------------------------------------------
;void showNumberP1_C() {
;   
;   long num = number;
;   int i;
;
;   if (num < 0) num = 0;
;   if (num > 999999) num = 999999;
;   for (i=0;i<6;i++){
;     charac = ' ';
;     if (num > 0) {
;	   charac = (char)(num%10);    //residuo
;	   num = num/10;               //cociente
;	   charac = charac + '0';
;	 }
;    gotoxyP1_C();
;     printchP1_C();
;     colScreen--;
;   }
;
;}

showNumberP1:
	push rbp			;Guardamos los registros por si luego al hacer call
	mov  rbp, rsp	;de las funciones de C u otras subrutinas no se contaminen
   
   ;guardar el estado de los registros que se modifican en esta 
   ;subrutina y que no se utilizan para devolver valores.
   
	push rax
	push rbx
	push rcx
	push rdx
	push rsi



	mov rax, QWORD [number]    ; long num = number;
								;Para cargar el valor de la casilla
				
	cmp rax, 0
	jge .check_max
	mov rax, 0                  ; if (num < 0) num = 0;
								;Necesitamos comprobar que el número no es negativo
.check_max:
	cmp rax, 999999
	jle .start_loop
	mov rax, 999999            ; if (num > 999999) num = 999999;
								;Comprobamos si excedemos 6 dígitos 

;Bucle de extracción de dígitos
.start_loop:
	mov rsi, 0                 ; int i = 0; Este es el contador del bucle
.loop_sn:
	mov BYTE [charac], ' '     ; charac = ' '; Espacio en blanco
	cmp rax, 0
	jle .print_char            ; if (num > 0) ;Si terminamos de extraer dígitos, pasamos a imprimir

   ;Extraemos las unidades dividiendo entre 10
	mov rdx, 0				  ;Limpiamos el dividendo antes de dividir por 10
	mov rbx, 10
	div rbx                    ; num = num/10; charac = (char)(num%10);
	add dl, '0'                ; Convertir el residuo de número a ASCII
	mov BYTE [charac], dl	  ;	Guardar el carácter listo para imprimir


.print_char:
	call gotoxyP1              ; gotoxyP1_C(); ;Colocar el cursor en el lugar a imprimir
	call printchP1             ; printchP1_C(); ;Imprimir el número
   
   
   ;Pasamos a la siguiente posición del cursor para el siguiente dígito
	mov ebx, DWORD [colScreen]
	dec ebx                    ; colScreen--;
	mov DWORD [colScreen], ebx

	inc rsi
	cmp rsi, 6                 ; i < 6 ;Comprobamos si hemos procesado los 6 espacios
	jl .loop_sn
   
   

	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax
sn_end: 
   ;restaurar el estado de los registros que se han guardado en la pila.
   
	mov rsp, rbp
	pop rbp
	ret
;--------------------------------------------------------------------------


;;;;;
; Actualizar el contenido del Tablero de Juego con los datos de la
; matriz (m) de 4x4 de tipo int y los puntos del marcador
; (score) que se han hecho.
; Se debe recorrer toda la matriz (m), y para cada elemento de la matriz
; posicionar el cursor en la pantalla y mostrar el número de aquella
; posición de la matriz.
; Recorrer toda la matriz por filas de izquierda a derecha y de arriba a abajo.
; Para recorrer la matriz en ensamblador el índice va de 0 (posición [0][0])
; a 60 (posición [3][3]) con incrementos de 4 porque los datos son de
; tipo int(DWORD) 4 bytes.
; Luego, mostrar el marcador (score) en la parte inferior del tablero,
; fila 18, columna 35 llamando la subrutina showNumberP1.
; Por último posicionar el cursor en la fila 18, columna 36 llamando la
; subrutina gotoxyP1.
;
; Variables globales utilizadas:
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
; (m)        : Matriz donde guardamos los números del juego.
; (Score)    : Puntos acumulados en el marcador.
; (number)   : Número que queremos mostrar.
;;;;;  

;-------------------------------------------------------------------------
;void updateBoardP1_C(){
;
;   int i,j;
;   int rowScreenAux;
;   int colScreenAux;
;   
;   rowScreenAux = 10;
;   for (i=0;i<DIMMATRIX;i++){
;     colScreenAux = 17;
;      for (j=0;j<DIMMATRIX;j++){
;         number = (long)m[i][j];
;         rowScreen = rowScreenAux;
;         colScreen = colScreenAux;
;         showNumberP1_C();
;         colScreenAux = colScreenAux + 9;
;      }
;      rowScreenAux = rowScreenAux + 2;
;   }
;   
;   number = score;
;   rowScreen = 18;
;   colScreen = 35;
;   showNumberP1_C();   
;   rowScreen = 18;
;   colScreen = 36;
;   gotoxyP1_C();
;   
;}


updateBoardP1:
	push rbp
	mov  rbp, rsp
   ;guardar el estado de los registros que se modifican en esta 
   ;subrutina y que no se utilizan para devolver valores.
	push r8
	push r9
	push r10
	push r11
	push rax

	mov r10d, 10               ; int rowScreenAux = 10; Esta es la fila inicial de la pantalla
	mov r8d, 0                 ; i = 0; Contador de filas de m
	
	;Dos bucles anidados
.loop_i_ub:
	mov r11d, 17               ; colScreenAux = 17; Coordenada x inicial para cada iteración
	mov r9d, 0                 ; j = 0; Contador del siguiente bucle (columnas)
.loop_j_ub:
	;Calculamos la posición de la casilla
	mov eax, r8d
	shl eax, 2
	add eax, r9d               ; eax = i*4 + j
	
	;Convertimos de 32 bits a 64 bits
	movsxd rax, DWORD [m + rax*4] ; number = (long)m[i][j]; 
	mov QWORD [number], rax
   
	;Preparamos las coordenadas de la pantalla y llamamos a la función que imprime el número
	mov DWORD [rowScreen], r10d   ; rowScreen = rowScreenAux;
	mov DWORD [colScreen], r11d   ; colScreen = colScreenAux;
	call showNumberP1

	;Saltamos a la siguiente casilla
	add r11d, 9                ; colScreenAux = colScreenAux + 9; El 9 es por los 9 espacios físicos a la derecha
	inc r9d
	cmp r9d, DIMMATRIX			;Si terminamos con las columnas de esta fila, saltamos a la siguiente
	jl .loop_j_ub

	;Saltamos a la siguiente fila
	add r10d, 2                ; rowScreenAux = rowScreenAux + 2; Para saltar a la fila, 
	inc r8d
	cmp r8d, DIMMATRIX			;Comprobamos si dibujamos todo el tablero
	jl .loop_i_ub
   
   
   ;Actualizar el score de la partida
	mov rax, QWORD [score]     ; number = score;
	mov QWORD [number], rax
	
	;Esta es la posición del cursor debajo del tablero para dibujar el marcador
	mov DWORD [rowScreen], 18
	mov DWORD [colScreen], 35
	call showNumberP1

	;Quitar el cursor para que no estorbe
	mov DWORD [rowScreen], 18
	mov DWORD [colScreen], 36
	call gotoxyP1

	pop rax
	pop r11
	pop r10
	pop r9
	pop r8
ub_end:
   ;restaurar el estado de los registros que se han guardado en la pila.
   
	mov rsp, rbp
	pop rbp
	ret
;-----------------------------------------------------------------------


;;;;;  
; Copiar los valores de la matriz (mRotated) en la matriz (m).
; La matriz (mRotated) no debe modificarse,
; los cambios deben realizarse en la matriz (m).
; Recorrer toda la matriz por filas de izquierda a derecha y de arriba a abajo.
; Para recorrer la matriz en ensamblador el índice va de 0 (posición [0][0])
; a 60 (posición [3][3]) con incrementos de 4 porque los datos son de
; tipo int(DWORD) 4 bytes.
; No se mostrará la matriz.
;
; Variables globales utilizadas:
; (m)       : Matriz donde guardamos los números del juego.
; (mRotated): Matriz con los números rotados.
;;;;;  


;-------------------------------------------------------------------------
;void copyMatrixP1_C() {
;
;   int i,j;
;   
;   for (i=0; i<DIMMATRIX; i++) {
;      for (j=0; j<DIMMATRIX; j++) {   
;         m[i][j] = mRotated[i][j];
;      }
;   }
;   
;}


copyMatrixP1:
   push rbp
   mov  rbp, rsp
   ;guardar el estado de los registros que se modifican en esta 
   ;subrutina y que no se utilizan para devolver valores.
   
   push rsi
   push rax

   mov rsi, 0                 ; i = 0 ; Vamos a recorrer la matriz de manera lineal con 16 posiciones
   
   ;Recorremos con un bucle y copiamos de matriz origen ->registro -> matriz destino
.loop_cm:
   mov eax, DWORD [mRotated + rsi*4] 
   mov DWORD [m + rsi*4], eax
   
   ;Controles del bucle
   inc rsi
   cmp rsi, SIZEMATRIX
   jl .loop_cm

   pop rax
   pop rsi
cm_end:
   ;restaurar el estado de los registros que se han guardado en la pila.
   
   mov rsp, rbp
   pop rbp
   ret

;-----------------------------------------------------------------------


;;;;;      
; Rotar a la derecha o a la izquierda la matriz (m) en la dirección
; indicada por la variable (dir: 'L' izquierda, 'R' derecha) sobre la
; matriz (mRotated).
; Si se rota a la izquierda (dir='L')
; la primera fila pasa a ser la cuarta columna,
; la segunda fila pasa a ser la tercera columna,
; la tercera fila pasa a ser la segunda columna y
; la cuarta fila pasa a ser la primera columna.
; Si se rota a la derecha (dir='R')
; la primera columna pasa a ser la cuarta fila,
; la segunda columna pasa a ser la tercera fila,
; la tercera columna pasa a ser la segunda fila y
; la cuarta columna pasa a ser la primera fila.
; En el enunciado se explica en mayor detalle cómo hacer la rotación.
; NOTA: NO es lo mismo que realizar la matriz transpuesta.
; La matriz (m) no debe modificarse,
; los cambios deben realizarse en la matriz (mRotated).
; Para recorrer la matriz en ensamblador el índice va de 0 (posición [0][0])
; a 60 (posición [3][3]) con incrementos de 4 porque los datos son de
; tipo int(DWORD) 4 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador
; hay que tener en cuenta que el índice es:(index=(fila*DIMMATRIX+columna)*4),
; multiplicamos por 4 porque los datos son de tipo int(DWORD) 4 bytes.
; Una vez realizada la rotación, copiar la matriz (mRotated) en la matriz
; (m) llamando a la subrutina copyMatrixP1.
; No se debe mostrar la matriz.
;
; Variables globales utilizadas:
; (m)       : Matriz donde guardamos los números del juego.
; (mRotated): Matriz con los números rotados.
; (dir)     : Dirección de la rotación: 'L' izquierda, 'R' derecha.
;;;;;  


;-------------------------------------------------------------------------
;void rotateMatrixLRP1_C() {
;   
;   int i,j;
;   
;   for (i=0; i<DIMMATRIX; i++) {
;      for (j=0; j<DIMMATRIX; j++) {
;         if(dir=='L') mRotated[DIMMATRIX-1-j][i] = m[i][j];
;         if(dir=='R') mRotated[j][DIMMATRIX-1-i] = m[i][j];
;      }
;   }
;   
;   copyMatrixP1_C();
;   
;}

rotateMatrixLRP1:
	   push rbp
	   mov  rbp, rsp
	   ;guardar el estado de los registros que se modifican en esta 
	   ;subrutina y que no se utilizan para devolver valores.
	   push r8
	   push r9
	   push rax
	   push rbx
	   push rcx

	;Recorremos la matriz a girar con un bucle doble
	   mov r8d, 0                 ; i = 0
	.loop_i_rm:
	   mov r9d, 0                 ; j = 0
	.loop_j_rm:
	;Calcular la posición lineal de la ficha actual en el tablero original
	   mov eax, r8d
	   shl eax, 2
	   add eax, r9d               ; eax = i*4 + j
	   
	   ;Extraemos para girarla
	   mov ebx, DWORD [m + rax*4] ; ebx = m[i][j]


		;Dependiendo de la variable, giramos hacia un lado u otro el tablero
	   cmp BYTE [dir], 'L'
	   je .left_rm
	   
	   ;Giro de 90º a la derecha
	   ; Lo conseguimos con la fórumula (j * 4) + (3 - i)
	.right_rm:
	   mov eax, r9d
	   shl eax, 2                 ; j*4 (Usamos shift left en binario en vez de multiplicar)
	   mov ecx, 3
	   sub ecx, r8d               ; 3-i
	   add eax, ecx               ; index = j*4 + (3-i)
	   jmp .store_rm
	   
	   ;Giro de 90º a la izquierda
	   ; Fórmula ((3 - j) * 4) + i
	.left_rm:
	   mov eax, 3
	   sub eax, r9d               ; 3-j
	   shl eax, 2                 ; (3-j)*4
	   add eax, r8d               ; index = (3-j)*4 + i
	   
	   ;Guardamos y continuamos
	   ;Colocamos la ficha extraída en el tablero auxiliar
	.store_rm:
	   mov DWORD [mRotated + rax*4], ebx

	   ;Siguiente columna
	   inc r9d
	   cmp r9d, DIMMATRIX
	   jl .loop_j_rm
	   
	   ;Siguiente fila
	   inc r8d
	   cmp r8d, DIMMATRIX
	   jl .loop_i_rm
	   
	   
	   ;Recopiamos a la matriz principal
	   call copyMatrixP1          ; copyMatrixP1_C();

	   pop rcx
	   pop rbx
	   pop rax
	   pop r9
	   pop r8
	rm_end:
	   ;restaurar el estado de los registros que se han guardado en la pila.
	   mov rsp, rbp
	   pop rbp
	   ret
   
;------------------------------------------------------------------------

;;;;;  
; Desplaza los números de cada fila de la matriz (m) a la izquierda
; manteniendo el orden de los números y
; poniendo los ceros a la derecha si se desplaza.
; Recorrer la matriz por filas de izquierda a derecha y de arriba a abajo.
; Para recorrer la matriz en ensamblador, el índice va de la
; posición 0 (posición [0][0]) a la 60 (posición [3][3]) con incrementos
; de 4 porque los datos son de tipo int(DWORD) 4 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador
; hay que tener en cuenta que el índice es:(index=(fila*DIMATRIX+columna)*4),
; multiplicamos por 4 porque los datos son de tipo int(DWORD) 4 bytes.
; Si se desplaza un número (NO LOS CEROS), se deben contar los
; desplazamiento incrementando la variable (shifts).
; En cada fila, si encuentra un 0, mira si hay un número distinto de cero,
; en la misma fila para ponerlo en esa posición.
; Si una fila de la matriz es: [0,2,0,4], quedará
; [2,4,0,0] y (state = 2).
; Los cambios deben realizarse sobre la misma matriz.
; No se debe mostrar la matriz.
;
; Variables globales utilizadas:
; (m)    : Matriz donde guardamos los números del juego.
; (state): Estado del juego. (2: Se han hecho movimientos).
;;;;;  

;-------------------------------------------------------------------------
;void shiftNumbersLP1_C() {
;   
;   int i,j,k;
;   
;   for (i=0; i<DIMMATRIX; i++) {
;	 for (j=0; j<DIMMATRIX-1; j++) {
;        if (m[i][j] == 0) {
;          k = j+1;           
;          while (k<DIMMATRIX && m[i][k]==0) k++;
;          if (k<DIMMATRIX) {
;            m[i][j]= m[i][k];
;            m[i][k]= 0;
;            state = 2;      
;          }
;        }
;      }
;    }
;    
;}


shiftNumbersLP1:
	push rbp
	mov  rbp, rsp
	;guardar el estado de los registros que se modifican en esta 
	;subrutina y que no se utilizan para devolver valores.
	push r8
	push r9
	push r10
	push rax
	push rbx
	push rcx


	;Recorremos con un bucle doble la matriz
	mov r8d, 0                 ; i = 0
.loop_i_sh:
	mov r9d, 0                 ; j = 0
.loop_j_sh:
	;Calcular la posición de la casilla actual
	mov eax, r8d
	shl eax, 2
	add eax, r9d               ; eax = i*4 + j
   
   ;Comprobamos si está vacía
	cmp DWORD [m + rax*4], 0
	jne .next_j_sh             ; if (m[i][j] == 0); Si tiene un cero, no hace falta deslizar, pasamos a la siguiente

	;Si llegamos a este punto del programa, es que hay un hueco. Buscamos a su derecha por si hay fichas que traer.
	mov r10d, r9d
	inc r10d                   ; k = j+1; ;Una casilla a la derecha
	
.while_k_sh:					;Comprobamos si k no se ha salido del tablero a la derecha
	cmp r10d, DIMMATRIX        ; while (k<DIMMATRIX...
	jge .next_j_sh
   
	;Posición lineal de la casilla que está mirando k
	mov ecx, r8d
	shl ecx, 2
	add ecx, r10d              ; ecx = i*4 + k
	
	;Comprobamos si k encontró ficha
	cmp DWORD [m + ecx*4], 0   ; ... && m[i][k]==0) ;Significa encontrada
	jne .found_k_sh
	inc r10d		;Si sigue habiendo hueco, nos movemos una casilla más a la derecha
	jmp .while_k_sh

.found_k_sh:
	;K encontró una ficha, la movemos al hueco que encontró j
	mov ebx, DWORD [m + ecx*4] 
	mov DWORD [m + rax*4], ebx ; m[i][j]= m[i][k];
	
	;Dejamos un espacio vacío en el lugar de la ficha
	mov DWORD [m + ecx*4], 0   ; m[i][k]= 0;
	
	;Cambiamos el estado a modificado para que aparezca un nuevo 2
	mov WORD [state], 2        ; state = 2;

.next_j_sh:
	inc r9d
	cmp r9d, 3                 ; j < DIMMATRIX-1 ;Buscamos huecos hasta la penúltima columna
	jl .loop_j_sh				;No tiene sentido buscar a la derecha de la última columna
	
	;Siguiente fila del tablero
	inc r8d
	cmp r8d, DIMMATRIX
	jl .loop_i_sh

	pop rcx
	pop rbx
	pop rax
	pop r10
	pop r9
	pop r8
shn_end:
	;restaurar el estado de los registros que se han guardado en la pila.
	mov rsp, rbp
	pop rbp
	ret

;----------------------------------------------------------------------------
      

;;;;;  
; Emparejar números de la matriz (m) hacia la izquierda y acumular los
; puntos (p) en el marcador sumando los puntos de las parejas que se hayan hecho.
; Recorrer la matriz por filas de izquierda a derecha y de arriba a abajo.
; Cuando se encuentre una pareja, dos casillas consecutivas de la misma
; fila con el mismo número, juntamos la pareja poniendo la suma de la
; pareja en la casilla de la derecha, un 0 en la casilla de la izquierda y
; acumularemos esta suma en la variable (p) (puntos ganados).
; Si una fila de la matriz es: : [4,4,2,2] quedará [8,0,4,0] y
; p = p + (8+4).
; Si al final se ha juntado alguna pareja (p>0), pondremos la variable
; (state) a 2 para indicar que se ha movido algún número y actualizaremos
; la variable (score) con los puntos obtenidos de realizar las parejas.
; Para recorrer la matriz en ensamblador, en este caso, el índice va de la
; posición 0 (posición [0][0]) a la 60 (posición [3][3]) con incrementos de
; 4 porque los datos son de tipo int(DWORD) 4 bytes.
; Para acceder a una posición concreta de la matriz desde ensamblador
; hay que tener en cuenta que el índice es:(index=(fila*DimMatrix+columna)*4),
; multiplicamos por 4 porque los datos son de tipo int(DWORD) 4 bytes.
; Los cambios deben realizarse sobre la misma matriz.
; No se debe mostrar la matriz.
;
; Variables globales utilizadas:
; (m)    : Matriz donde guardamos los números del juego.
; (score): Puntos acumulados en el marcador.
; (state): Estado del juego. (2: Se han hecho movimientos).
;;;;;  

;-------------------------------------------------------------------------
;void addPairsLP1_C() {
;   
;   int i,j;
;   int p = 0;
;   
;  for (i=0; i<DIMMATRIX; i++) {
;     for (j=0; j<DIMMATRIX-1; j++) {
;       if ((m[i][j]!=0) && (m[i][j]==m[i][j+1])) {
;         m[i][j]  = m[i][j]*2;
;         m[i][j+1]= 0;
;         p = p + m[i][j];
;         j++;
;       }		
;     }
;   }
;   
;   if (p > 0) {
;      score = score + (long)p;
;      state = 2;
;   }
;   
;}

addPairsLP1:
	push rbp
	mov  rbp, rsp
	;guardar el estado de los registros que se modifican en esta 
	;subrutina y que no se utilizan para devolver valores.
	push r8
	push r9
	push r10
	push rax
	push rbx


	mov r10d, 0                ; int p = 0; Este es el contador de puntos
	mov r8d, 0                 ; i = 0; Primera fila

.loop_i_ap:
	mov r9d, 0                 ; j = 0; Primera columna de la izquierda
.loop_j_ap:
	;Calculamos la posición de la ficha
	mov eax, r8d
	shl eax, 2
	add eax, r9d               ; eax = i*4 + j

	;Para comparar la ficha, la extraemos
	mov ebx, DWORD [m + rax*4]
	cmp ebx, 0
	je .next_j_ap              ; if ((m[i][j]!=0)... ;Si es un 0 (vacía), pasamos a la siguiente

	;Comprobamos si es igual a su vecina de la derecha
	cmp ebx, DWORD [m + rax*4 + 4] 
	jne .next_j_ap             ; ... && (m[i][j]==m[i][j+1])) ; Si son distintas, pasamos a la siguiente

	;Fusionamos las fichas
	shl ebx, 1                 ; m[i][j] = m[i][j]*2; Multiplicamos x2 la ficha actual
	mov DWORD [m + rax*4], ebx	
	mov DWORD [m + rax*4 + 4], 0 ; m[i][j+1]= 0; ;Vaciamos la casilla vecina
	add r10d, ebx              ; p = p + m[i][j]; ;Sumamos los puntos
	inc r9d                    ; j++; (salto doble para no evaluar la casilla vaciada)

.next_j_ap:
	;Avanza el bucle
	inc r9d
	cmp r9d, 3                 ; j < DIMMATRIX-1 ; Lo mismo que antes, solo comprobamos hasta la penúltima columna
	jl .loop_j_ap
	
	
	inc r8d
	cmp r8d, DIMMATRIX 			;Siguiente fila
	jl .loop_i_ap

	;Actualización global al acabar el movimiento
	cmp r10d, 0
	jle .ap_end_skip           ; if (p > 0) ; Si no ganamos nada, no actualizamos
   
   ;Actualizar los puntos
	movsxd rax, r10d           ; Cast de 32 bits a 64 bits
	add QWORD [score], rax     ; score = score + (long)p; ;Sumar los puntos al marcador
	mov WORD [state], 2        ; state = 2; ;Cambiar el estado a modificado

.ap_end_skip:
	pop rbx
	pop rax
	pop r10
	pop r9
	pop r8
ap_end:      
	;restaurar el estado de los registros que se han guardado en la pila.
	mov rsp, rbp
	pop rbp
	ret
   
;------------------------------------------------------------------------
   
;;;;;
; Juego del 2048
; Subrutina principal del juego
; Permite jugar al juego del 2048 llamando a todas las funcionalidades.
; Esta subrutina se da hecha. NO SE PUEDE MODIFICAR.
;
; Pseudo código:
; Inicializar estado del juego, (state=1)
; Mostrar el tablero de juego (llamar la función printBoardP1).
; Actualiza el contenido del Tablero de Juego y los puntos realizados
; (llamar la subrutina updateBoardP1).
; Mientras (state==1) hacer
;   Leer una tecla (charac) llamando a la subrutina getchP1.
;   Según la tecla leída llamaremos a las subrutinas correspondientes.
;     ['i' (arriba),'j'(izquierda),'k' (abajo) o 'l'(derecha)]
;     Rotar la matriz (m) llamando la subrutina rotateMatrixLRP1, para
;     poder realizar los desplazamientos de los números a la izquierda llamando la
;     subrutina shiftNumbersLP1 y hacer las parejas llamando a la subrutina
;     addPairsLP1 que también actualiza los puntos que se han sumado al
;     marcador (score), volver a desplazar los números a la izquierda
;     llamando a la subrutina shiftNumbersLP1 con las parejas hechas.
;     Si se ha realizado algún desplazamiento o alguna pareja (state=2).
;     Luego, volver a rotar gritando la subrutina rotateMatrixLRP1
;     para dejar la matriz en la posición inicial.
;     Para la tecla 'j' (izquierda) no es necesario realizar rotaciones,
;     para el resto se realizarán rotaciones.
;     '<ESC>' (ASCII 27) poner (state = 0) para salir del juego.
;   Si no es ninguna de estas teclas no hacer nada.
;   Si se ha realizado algún desplazamiento o alguna pareja (state==2), generar
;   una nueva ficha llamando a la subrutina insertTileP1_C y poner
;   la variable state a 1 (state=1).
;   Actualiza el contenido del Tablero de Juego y los puntos realizados
;   llamar a la subrutina updateBoardP1.
; Fin mientras.
; Mostrar un mensaje debajo del tablero según el valor de la variable
; (state) llamando a la función printMessageP1_C.
; Salir:
; Se acaba el juego.
;
; Variables globales utilizadas:
; (charac): Carácter que leemos de teclado.
; (state) : Estado del juego.
;           0 : Salir, hemos pulsado la tecla 'ESC').
;           1 : Continuamos jugando.
;           2 : Continuamos jugando pero se han hecho cambios en la matriz.
; (dir)   : Dirección de la rotación: 'L' izquierda, 'R' derecha.
;;;;;  
playP1:
   push rbp
   mov  rbp, rsp
   ;guardar el estado de los registros que se modifican en esta 
   ;subrutina y que no se utilizan para devolver valores.
   push rax
   push rbx ; Sé que no hay que modificar pero un compañero ha preguntado en el foro y tiene razón, 
			; sin este cambio la opción 8 no funciona.
			; Cuando he depurado con Kdbg, me he dado cuenta también de que:
			; Había que quitar un pop rbx de p_k que no sé si metí yo sin querer pero el juego crasheaba al presionar (k)Down
   
   mov BYTE[state], 1         ;state = 1;    
   
   call printBoardP1_C        ;printBoardP1_C();
   call updateBoardP1         ;updateBoardP1_C(); 

   playP1_Loop:               ;while    
   cmp  BYTE[state], 1        ;(state == '1') {
   jne  playP1_End
      
     call getchP1             ;getchP1_C();
     mov al, BYTE[charac] 
     p_i:
     cmp al, 'i'              ;i:(105) up
     jne  p_j
       mov  BYTE[dir], 'L'    ;dir = 'L';
       call rotateMatrixLRP1  ;rotateMatrixLRP1_C();
      
       call shiftNumbersLP1   ;shiftNumbersLP1_C();
       call addPairsLP1       ;addPairsLP1_C();
       call shiftNumbersLP1   ;shiftNumbersLP1_C();
       
       mov  BYTE[dir], 'R'    ;dir = 'R';
       call rotateMatrixLRP1  ;rotateMatrixLRP1_C();
       jmp  p_moved           ;break;
      
     p_j:
     cmp al, 'j'              ;j:(106) left
     jne  p_k
       call shiftNumbersLP1   ;shiftNumbersLP1_C();
       call addPairsLP1       ;addPairsLP1_C();
       call shiftNumbersLP1   ;shiftNumbersLP1_C();
       jmp  p_moved           ;break;
   
     p_k:
     cmp al, 'k'              ;k:(107) down
     jne  p_l
       mov  BYTE[dir], 'R'    ;dir = 'R';
       call rotateMatrixLRP1  ;rotateMatrixLRP1_C();
      
       call shiftNumbersLP1   ;shiftNumbersLP1_C();
       call addPairsLP1       ;addPairsLP1_C();
       call shiftNumbersLP1   ;shiftNumbersLP1_C();
       mov  BYTE[dir], 'L'    ;dir = 'L';
       call rotateMatrixLRP1  ;rotateMatrixLRP1_C();
       jmp  p_moved           ;break;
      
     p_l:
     cmp al, 'l'              ;l:(108) right
     jne  p_ESC
       mov  BYTE[dir], 'R'    ;dir = 'R';
       call rotateMatrixLRP1  ;rotateMatrixLRP1_C();
       call rotateMatrixLRP1  ;rotateMatrixLRP1_C();
      
       call shiftNumbersLP1   ;shiftNumbersLP1_C();
       call addPairsLP1       ;addPairsLP1_C();
       call shiftNumbersLP1   ;shiftNumbersLP1_C();
       
       mov  BYTE[dir], 'L'    ;dir = 'L';
       call rotateMatrixLRP1  ;rotateMatrixLRP1_C();
       call rotateMatrixLRP1  ;rotateMatrixLRP1_C();
       jmp  p_moved           ;break;
      
     p_ESC:
     cmp al, 27               ;ESC:(27) exit
     jne p_moved
       mov BYTE[state], 0     ;state=0; 

     p_moved:

     cmp BYTE[state], 2       ;if(state == 2);
     jne playP1_Next 
       call insertTileP1_C    ;insertTileP1_C(); 
       mov BYTE[state], 1     ;state = '1';
      playP1_Next
      call updateBoardP1      ;updateBoardP1_C();
      
   jmp playP1_Loop
   
   call printMessageP1_C      ;printMessageP1_C();
   
   playP1_End:
   ;restaurar el estado de los registros que se han guardado en la pila.
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret
