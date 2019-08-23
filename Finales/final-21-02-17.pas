program final2102;

uses
	crt;
	
type
	puntAr = ^tPuntAr;
	tPuntAr = record
		num:integer;
		men:puntAr;
		may:puntAr;
	end;


	tArch = file of integer;
	
////////////////////////////////////////////////////////////////////////

procedure imprimirArbol(arbol:puntAr);
{PROCEDIMIENTO PARA IMPRIMIR EL ARBOL}
begin
	if (arbol <> nil) then
		begin
			writeln(arbol^.num);
			imprimirArbol(arbol^.men);
			imprimirArbol(arbol^.may);
		end;
end;

procedure imprimirArchivo(var arch:tArch);
{PROCEDIMIENTO PARA IMPRIMIR EL ARCHIVO}
var
	numero:integer;
begin
	reset(arch);
	while not eof(arch) do
		begin
			read(arch, numero);
			writeln(numero);
		end;
end;

procedure insertarNodoArbol(var arbol:puntAr; nodo:puntAr);
{PROCEDIMIENTO PARA INSERAR ORDENADO EL NODO}
begin
	if (arbol = nil) then
		arbol:=nodo
	else
		if (arbol^.num > nodo^.num) then
			insertarNodoArbol(arbol^.men, nodo)
		else
			insertarNodoArbol(arbol^.may, nodo);
end;

procedure crearNodo(var nodo:puntAr; numero:integer);
{PROCEDIMIENTO PARA CREAR UN NODO}
begin
	new(nodo);
	nodo^.num:=numero;
	nodo^.men:=nil;
	nodo^.may:=nil;
end;

procedure sumarDescendientes(arbol:puntAr; var suma:integer; sumaMinima:integer);
{PROCEDIMIENTO QUE CARGAR EN LA VARIABLE SUMA EL ARBOL (SERIA EL SUB-ARBOL MENORES O MAYORES QUE SE LE PASA POR PARAMETRO A LA FUNCION QUE LLAMA A ESTE
PROCEDIMIENTO)}
begin
	if (arbol <> nil) then
		begin
			if ((suma + arbol^.num) < sumaMinima) then
				suma:=suma + arbol^.num;
			if (arbol^.men <> nil) then
				if ((suma + arbol^.men^.num) < sumaMinima) then
					sumarDescendientes(arbol^.men, suma, sumaMinima);
			if (arbol^.may <> nil) then
				if ((suma + arbol^.may^.num) < sumaMinima) then
					sumarDescendientes(arbol^.may, suma, sumaMinima);
		end;
end;

function sumaDescendientes(arbol:puntAr; sumaMinima:integer):boolean;
{FUNCION PARA SUMAR DESCENDIENTES DE MENORES Y MAYORES}
var
	sumaIzquierda, sumaDerecha:integer;
	valido:boolean;
begin
	valido:=false;
	sumaDerecha:=0;
	sumaIzquierda:=0;
	sumarDescendientes(arbol^.men, sumaIzquierda, sumaMinima);
	sumarDescendientes(arbol^.may, sumaDerecha, sumaMinima);
	if ((sumaDerecha + sumaIzquierda) < sumaMinima) then
		valido:=true;
	sumaDescendientes:=valido;
end;

procedure recorrerArbol(arbol:puntAr; var arbol2:puntAr; min:integer; max:integer; sumaMinima:integer);
{PROCEDIMIENTO PARA RECORRER EL ARBOL}
var
	nodo:puntAr;
begin
	if (arbol <> nil) then
		begin
			if (arbol^.num >= min) and (arbol^.num <= max) then
				begin
					if (sumaDescendientes(arbol, sumaMinima)) then
						begin
							crearNodo(nodo, arbol^.num);
							insertarNodoArbol(arbol2, nodo);
						end;
				end;
			if (arbol^.num > min) then
				recorrerArbol(arbol^.men, arbol2, min, max, sumaMinima);
			if (arbol^.num < max) then
				recorrerArbol(arbol^.may, arbol2, min, max, sumaMinima);
		end;
end;

procedure procesarArbol(arbol:puntAr; var arbol2:puntAr);
{PROCEDIMIENTO PARA CARGAR LAS VARIABLES NECESARIAS}
var
	min, max, sumaMinima:integer;
begin
	writeln('Ingrese MIN:');
	readln(min);
	writeln('Ingresa MAX:');
	readln(max);
	writeln('Ingresa SumaMinima:');
	readln(sumaMinima);
	recorrerArbol(arbol, arbol2, min, max, sumaMinima);
end;

procedure cargarArbol(var arch:tArch; var arbol:puntAr);
{PROCEDIMIENTO PARA CARGAR EL ARBOL}
var
	nodo:puntAr;
	numero:integer;
begin
	nodo:=nil;
	reset(arch);
	while not eof(arch) do
		begin
			read(arch, numero);
			crearNodo(nodo, numero);
			insertarNodoArbol(arbol, nodo);
		end;
end;

procedure cargarArchivo(var arch:tArch);
{PROCEDIMIENTO PARA CARGAR EL ARCHIVO}
var
	cantidadElementos, contador, numero:integer;
begin
	contador:=0;
	reset(arch);
	writeln('INGRESE LA CANTIDAD DE ELEMENTOS QUE DESEA INGRESAR AL ARCHIVO:');
	readln(cantidadElementos);
	while (contador < MAX_ELEMENTOS) do
		begin
			readln(numero);
			write(arch, numero);
			contador:=contador+1;
		end;
end;

procedure verificarExisteArchivo(var arch:tArch; var error:boolean);
{PROCEDIMIENTO PARA VERIFICAR SI EXISTE EL ARCHIVO}
begin
	{$I-}
	reset(arch);
	{$I+}
	if (ioresult <> 0) then
		error:=true;
end;

////////////////////////////////////////////////////////////////////////

{DEFINO EL ARCHIVO DONDE VOY A GUARDAR TODO PARA NO ANDAR TODO EL DIA CARGANDO COSAS, EL ARBOL ORIGINAL, EL NUEVO ARBOL Y EL BOOLEANO PARA VERIFICAR
ERRORES DEL ARCHIVO}
var
	arch:tArch;
	arbol:puntAr;
	arbol2:puntAr;
	error:boolean;
	
begin
	error:=false;
	arbol:=nil;
	arbol2:=nil;
	assign(arch,'archFinal2102.dat');
	verificarExisteArchivo(arch, error);
	if (error) then
		begin
			rewrite(arch);
			cargarArchivo(arch);
		end;
	cargarArbol(arch, arbol);
	close(arch);
	procesarArbol(arbol, arbol2);
	//imprimirArchivo(arch);
	writeln;
	imprimirArbol(arbol2);
end.
