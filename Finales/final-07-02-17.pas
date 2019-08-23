program final0702;

uses
	crt;
	
type
	puntAr = ^tPuntAr;
	tPuntAr = record
		num:integer;
		ant:puntAr;
		sig:puntAr;
		may:puntAr;
		men:puntAr;
	end;
	
	tArch = file of integer;

////////////////////////////////////////////////////////////////////////

procedure imprimirLista(lista:puntAr);
{PROCEDIMIENTO PARA IMPRIMIR LA LISTA DOBLEMENTE VINCULADA, LO HICE ASÍ PARA MOSTRAR QUE TIENE IDA Y VUELTA}
var
	cursor:puntAr;
begin
	cursor:=lista;
	writeln;
	writeln('LISTA ASCENDENTEMENTE:');
	while (cursor <> nil) do
		begin
			writeln(cursor^.num);
			cursor:=cursor^.sig;
		end;
	cursor:=lista;
	while (cursor^.sig <> nil) do
		cursor:=cursor^.sig;
	writeln;
	writeln('LISTA DESCENDENTEMENTE:');
	while (cursor <> nil) do
		begin
			writeln(cursor^.num);
			cursor:=cursor^.ant;
		end;
end;

procedure imprimirArbol(arbol:puntAr);
{PROCEDIMIENTO QUE SE ENCARGA DE IMPRIMIR EL ARBOL}
begin
	if (arbol <> nil) then
		begin
			writeln(arbol^.num);
			imprimirArbol(arbol^.men);
			imprimirArbol(arbol^.may);
		end;
end;

procedure insertarNodoArbol(var arbol:puntAr; nodo:puntAr);
{PROCEDIMINETO PARA INSERTAR EL NODO DEL ARBOL ORDENADAMENTE}
begin
	if (arbol = nil) then
		arbol:=nodo
	else
		if (arbol^.num > nodo^.num) then
			insertarNodoArbol(arbol^.men, nodo)
		else
			insertarNodoArbol(arbol^.may, nodo);
end;

procedure crearNodoArbol(var nodo:puntAr; numero:integer);
{PROCEDIMIENTO QUE CREA UN NUEVO NODO, CON TODOS SUS ATRIBUTOS EN NIL}
begin
	new(nodo);
	nodo^.num:=numero;
	nodo^.ant:=nil;
	nodo^.sig:=nil;
	nodo^.may:=nil;
	nodo^.men:=nil;
end;

procedure cargarArbol(var arch:tArch; var arbol:puntAr);
{PROCEDIMIENTO QUE SE ENCARGA DE CARGAR EL ARBOL CON LOS DATOS DEL ARCHIVO}
var
	numero:integer;
	nodo:puntAr;
begin
	reset(arch);
	nodo:=nil;
	while not eof(arch) do
		begin
			read(arch, numero);
			crearNodoArbol(nodo, numero);
			insertarNodoArbol(arbol, nodo);
		end;
end;

procedure verificarExisteArchivo(var arch:tArch; var error:boolean);
{PROCEDIMIENTO QUE SE ENCARGA DE LA VERIFICACION DE ERRORES}
begin
	{$i-}
	reset(arch);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure cargarArchivo(var arch:tArch);
{PROCEDIMIENTO PARA CARGAR EL ARCHIVO CON LOS DATOS DESEADOS}
var
	contador, maximo, numero:integer;
begin
	reset(arch);
	contador:=0;
	writeln('CUANTOS ELEMENTOS QUIERE INGRESAR?');
	readln(maximo);
	writeln('INGRESE LOS ELEMENTOS AL ARCHIVO: ');
	while (contador < maximo) do
		begin
			readln(numero);
			write(arch, numero);
			contador:=contador+1;
		end;
end;

function sumaHijos(arbol:puntAr; min, max:integer; var contador:integer):integer;
{FUNCION QUE SUMA LOS HIJOS SIEMPRE TENIENDO EN CUENTA EL MAXIMO, EL MINIMO NO HACE FALTA, ESTÁ PARA BORRAR DE ACÁ PORQUE NO SE USA}
begin
	if (arbol = nil) then
		sumaHijos:=0
	else
		begin
			if (contador < max) then
			sumaHijos:=contador + sumaHijos(arbol^.men, min, max, contador);
			contador:=contador+arbol^.num;
			if (contador < max) then
				sumaHijos:=contador + sumaHijos(arbol^.may, min, max, contador);
			sumaHijos:=contador;
		end;
end;

function sumaDescendientes(arbol:puntAr; min, max:integer):integer;
{FUNCION QUE SUMA LOS RESULTADOS DE LAS FUNCIONES QUE LLAMAN LOS HIJOS DEL ARBOL PASADO POR PARAMETRO}
var
	contador1, contador2, sumaIzquierda, sumaDerecha, sumaTotal:integer;
begin
	contador1:=0;
	contador2:=0;
	sumaIzquierda:=sumaHijos(arbol^.men, min, max, contador1);
	sumaDerecha:=sumaHijos(arbol^.may, min, max, contador2);
	sumaTotal:=sumaIzquierda + sumaDerecha;
	sumaDescendientes:=sumaTotal;
end;

procedure insertarOrdenado(var lista:puntAr; nodo:puntAr);
{PROCEDIMIENTO PARA INSERTAR ORDENADO UN NODO EN LA LISTA}
begin
	if (lista = nil) then
		lista:=nodo
	else
		if (nodo^.num <= lista^.num) then
			begin
				nodo^.sig:=lista;
				lista:=nodo;
				nodo^.sig^.ant:=nodo;
			end
		else
			if (lista^.sig <> nil) and (nodo^.num > lista^.sig^.num) then
				insertarOrdenado(lista^.sig, nodo)
			else
				begin
					nodo^.sig:=lista^.sig;
					nodo^.ant:=lista;
					if (lista^.sig <> nil) then
						lista^.sig^.ant:=nodo;
					lista^.sig:=nodo;
				end;

end;

function buscaNumeroMenorNum(arbol:puntAr; num:integer):boolean;
{FUNCION QUE DICE SI HAY ALGUN NUMERO MENOR QUE EL PASADO POR PARAMETRO}
begin
	if (arbol = nil) then
		buscaNumeroMenorNum:=false
	else
		if (arbol^.num < num) then
			buscaNumeroMenorNum:=true
		else
			buscaNumeroMenorNum:= buscaNumeroMenorNum(arbol^.men, num);
end;

function sumaCantidadHijosMenores(arbol:puntAr; num:integer; var contador:integer):integer;
{FUNCION QUE SUMA LA CANTIDAD DE HIJOS MENORES}
begin
	if (arbol = nil) then
		sumaCantidadHijosMenores:=0
	else
		begin
			sumaCantidadHijosMenores:=contador + sumaCantidadHijosMenores(arbol^.men, num, contador);
			if (arbol^.num < num) then
				contador:=contador+1;
			sumaCantidadHijosMenores:=contador+ sumaCantidadHijosMenores(arbol^.may, num, contador);
			sumaCantidadHijosMenores:=contador;
		end;
end;

function calculaCantidadMenores(arbol:puntAr; num:integer):integer;
{FUNCION QUE SUMA LOS RESULTADOS DE LAS FUNCIONES QUE SE USAN PARA MENORES Y MAYORES}
var
	cantidadTotal, contador1, contador2, sumaIzquierda, sumaDerecha:integer;
begin
	contador1:=0;
	contador2:=0;
	sumaDerecha:=sumaCantidadHijosMenores(arbol^.may, num, contador1);
	sumaIzquierda:=sumaCantidadHijosMenores(arbol^.men, num, contador2);
	cantidadTotal:=sumaDerecha + sumaIzquierda;
	calculaCantidadMenores:=cantidadTotal;
end;

procedure recorrerArbol(var arbol:puntAr; var lista:puntAr; min, max, num, cant:integer);
{PROCEDIMIENTO PRINCIPAL QUE RECORRE EL ARBOL IN ORDER, PREGUNTA SI AMBOS NODOS SON DISTINTOS DE NIL Y LUEGO HACE LAS COMPROBACIONES}
var
	cantDescendientes, sumDescendientes:integer;
begin
	if (arbol <> nil) then
		begin
			recorrerArbol(arbol^.men, lista, min, max, num, cant);
			if (arbol^.men <> nil) and (arbol^.may <> nil) then
				begin
					sumDescendientes:=sumaDescendientes(arbol, min, max);
					if (buscaNumeroMenorNum(arbol^.men, num) = true) then
						begin
							cantDescendientes:=calculaCantidadMenores(arbol, num);
							if (cantDescendientes = cant) then
								begin
									if ((sumDescendientes >= min) and (sumDescendientes <= max)) then
										insertarOrdenado(lista, arbol);
								end;
						end
					else
						if ((sumDescendientes >= min) and (sumDescendientes <= max)) then
							insertarOrdenado(lista, arbol);
				end;
			recorrerArbol(arbol^.may, lista, min, max, num, cant);
		end;
end;

procedure procesarArbol(var arbol:puntAr; var PUNT_LIST:puntAr);
{PROCEDIMIENTO PARA CARGAR LAS VARIABLES NECESARIAS DEL PROBLEMA}
var
	MIN, MAX, NUM, CANT:integer;
begin
	writeln('INGRESE EL VALOR PARA MIN: ');
	readln(MIN);
	writeln('INGRESE EL VALOR PARA MAX: ');
	readln(MAX);
	writeln('INGRESE EL VALOR PARA NUM: ');
	readln(NUM);
	writeln('INGRESE EL VALOR PARA CANT: ');
	readln(CANT);
	recorrerArbol(arbol, PUNT_LIST, MIN, MAX, NUM, CANT);
end;

////////////////////////////////////////////////////////////////////////

var
	arch:tArch;
	error:boolean;
	NUMEROS:puntAr;
	PUNT_LIST:puntAr;

begin
	error:=false;
	NUMEROS:=nil;
	PUNT_LIST:=nil;
	assign(arch,'final070217.dat');
	verificarExisteArchivo(arch, error);
	if (error) then
		begin
			rewrite(arch);
			cargarArchivo(arch);
		end;
	cargarArbol(arch, NUMEROS);
	close(arch);
	imprimirArbol(NUMEROS);
	procesarArbol(NUMEROS, PUNT_LIST);
	imprimirLista(PUNT_LIST);
end.
