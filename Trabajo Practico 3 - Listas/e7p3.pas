program e7p3;

uses
	crt;
	
const
	MAX_ELEMENTOS = 5;
	
type
	puntNodo = ^tNodo;
	tNodo = record
		numero:real;
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
begin
	if (lista <> nil) then
		begin
			write(lista^.numero,' ');
			imprimirLista(lista^.sig);
		end;
end;

procedure mostrarLista(lista:puntNodo);
begin
	writeln;
	writeln('LA LISTA QUEDARIA:');
	writeln;
	imprimirLista(lista);
end;

procedure eliminarNodo(var lista:puntNodo; nodo:puntNodo);
var
	cursor:puntNodo;
begin
	if (lista = nodo) then
		lista:=lista^.sig
	else
		begin
			cursor:=lista;
			while (cursor^.sig <> nodo) do
				cursor:=cursor^.sig;
			cursor^.sig:=nodo^.sig;
		end;
	dispose(nodo);
end;

function buscaElemento(lista:puntNodo; numero:real):puntNodo;
var
	cursor1:puntNodo;
begin
	cursor1:=lista;
	while ((cursor1 <> nil) and (cursor1^.numero <> numero)) do
		cursor1:=cursor1^.sig;
	buscaElemento:=cursor1;
end;

procedure eliminarElemento(var lista:puntNodo);
var
	numero:real;
	nodo:puntNodo;
begin
	nodo:=nil;
	writeln('INGRESE EL ELEMENTO QUE DESEA ELIMINAR:');
	readln(numero);
	nodo:=buscaElemento(lista, numero);
	if (nodo <> nil) then
		eliminarNodo(lista, nodo);
end;

procedure crearNodo(var nodo:puntNodo; numero:real);
begin
	new(nodo);
	nodo^.numero:=numero;
	nodo^.sig:=nil;
end;

procedure insertarPosicionCorrecta(var lista:puntNodo; nodo:puntNodo);
var
	cursor1, cursor2:puntNodo;
begin
	cursor1:=lista;
	cursor2:=nil;
	while (cursor1 <> nil) and (cursor1^.numero < nodo^.numero) do
		begin
			cursor2:=cursor1;
			cursor1:=cursor1^.sig;
		end;
	cursor2^.sig:=nodo;
	nodo^.sig:=cursor1;
end;

procedure insertarOrdenado(var lista:puntNodo; nodo:puntNodo);
begin
	if (lista^.numero > nodo^.numero) then
		begin
			nodo^.sig:=lista;
			lista:=nodo;
		end
	else
		insertarPosicionCorrecta(lista, nodo);
end;

procedure insertarNodo(var lista:puntNodo; nodo:puntNodo);
begin
	if (lista = nil) then
		lista:=nodo
	else
		insertarOrdenado(lista, nodo);
end;

procedure cargarLista(var lista:puntNodo);
var
	contador:integer;
	numero:real;
	nodo:puntNodo;
begin
	contador:=0;
	nodo:=nil;
	writeln('INGRESE LOS ELEMENTOS A LA LISTA:');
	while (contador < MAX_ELEMENTOS) do
		begin
			readln(numero);
			crearNodo(nodo, numero);
			insertarNodo(lista, nodo);
			contador:=contador+1;
		end;
end;

////////////////////////////////////////////////////////////////////////

var
	lista:puntNodo;
	
begin
	lista:=nil;
	cargarLista(lista);
	eliminarElemento(lista);
	mostrarLista(lista);
	eliminarLista(lista);
end.
