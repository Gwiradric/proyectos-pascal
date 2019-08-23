program e4p3;

uses
	crt;
	
const
	MAX_ELEMENTOS = 10;
	
type
	tArr = array [1..MAX_ELEMENTOS] of char;
	
	puntNodo = ^tNodo;
	tNodo = record
		letra:char;
		sig:puntNodo;
	end;
	
////////////////////////////////////////////////////////////////////////

procedure eliminarLista(var lista:puntNodo);
begin
	if (lista <> nil) then
		eliminarLista(lista^.sig);
	dispose(lista);
end;

procedure imprimirLista(lista:puntNodo);
var
	cursor:puntNodo;
begin
	writeln;
	cursor:=lista;
	while (cursor <> nil) do
		begin
			write(cursor^.letra,' ');
			cursor:=cursor^.sig;
		end;
end;

procedure insertarNodo(var lista:puntNodo; nodo:puntNodo);
begin
	if (lista = nil) then
		lista:=nodo
	else
		insertarNodo(lista^.sig, nodo);
end;

procedure crearNodo(var nodo:puntNodo; letra:char);
begin
	new(nodo);
	nodo^.letra:=letra;
	nodo^.sig:=nil;
end;

procedure cargarLista(var lista:puntNodo; arreglo:tArr);
var
	indice:integer;
	nodo:puntNodo;
begin
	nodo:=nil;
	for indice:=1 to MAX_ELEMENTOS do
		begin
			crearNodo(nodo, arreglo[indice]);
			insertarNodo(lista, nodo);
		end;
end;

procedure cargarArreglo(var arreglo:tArr);
var
	indice:integer;
begin
	writeln('INGRESE LOS ELEMENTOS AL ARREGLO: ');
	for indice:=1 to MAX_ELEMENTOS do
		readln(arreglo[indice]);
end;

////////////////////////////////////////////////////////////////////////

var
	lista:puntNodo;
	arreglo:tArr;
	
begin
	lista:=nil;
	cargarArreglo(arreglo);
	cargarLista(lista, arreglo);
	imprimirLista(lista);
	eliminarLista(lista);
end.
