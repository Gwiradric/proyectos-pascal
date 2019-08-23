program e8p3;

uses
	crt;
	
const
	MAX_ELEMENTOS = 5;
	
type
	puntNodo = ^tNodo;
	tNodo = record
		numero:real;
		posicion:integer;
		ant:puntNodo;
		sig:puntNodo;
	end;
	
////////////////////////////////////////////////////////////////////////

procedure actualizarPosiciones(var lista:puntNodo);
var
	cursor:puntNodo;
	posicion:integer;
begin
	posicion:=1;
	cursor:=lista;
	while (cursor <> nil) do
		begin
			cursor^.posicion:=posicion;
			cursor:=cursor^.sig;
			posicion:=posicion+1;
		end;
end;

procedure borrarNodo(var lista:puntNodo; posicion:integer);
var
	cursor:puntNodo;
begin
	cursor:=lista;
	if (posicion = 1) then
		begin
			lista:=lista^.sig;
			lista^.ant:=nil;
			cursor^.sig:=nil;
			dispose(cursor);
		end
	else
		if (posicion = MAX_ELEMENTOS) then
			begin
				while (cursor^.posicion <> posicion) do
					cursor:=cursor^.sig;
				cursor^.ant^.sig:=nil;
				cursor^.ant:=nil;
				dispose(cursor);
			end
		else
			begin
				while (cursor^.posicion <> posicion) do
					cursor:=cursor^.sig;
				cursor^.ant^.sig:=cursor^.sig;
				cursor^.sig^.ant:=cursor^.ant;
				cursor^.ant:=nil;
				cursor^.sig:=nil;
				dispose(cursor);
			end;
end;

procedure eliminarElemento(var lista:puntNodo);
var
	posicion:integer;
begin
	writeln;
	writeln('INGRESE LA POSICION DEL ELEMENTO QUE DESEA BORRAR:');
	readln(posicion);
	if (posicion > 0) and (posicion <= MAX_ELEMENTOS) then
		begin
			borrarNodo(lista, posicion);
			actualizarPosiciones(lista);
		end;
end;

procedure imprimirListaInversa(lista:puntNodo);
var
	cursor:puntNodo;
begin
	cursor:=lista;
	while (cursor^.sig <> nil) do
		cursor:=cursor^.sig;
	while (cursor <> nil) do
		begin
			writeln(cursor^.numero);
			cursor:=cursor^.ant;
		end;
end;

procedure mostrarListaInversa(lista:puntNodo);
begin
	writeln;
	writeln('LA LISTA ES:');
	imprimirListaInversa(lista);
end;

procedure imprimirLista(lista:puntNodo);
begin
	if (lista <> nil) then
		begin
			writeln(lista^.numero,' ');
			imprimirLista(lista^.sig);
		end;
end;

procedure mostrarLista(lista:puntNodo);
begin
	writeln;
	writeln('LA LISTA ES:');
	imprimirLista(lista);
end;

procedure insertarLugarCorrecto(var lista:puntNodo; nodo:puntNodo);
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
	nodo^.sig:=cursor1;
	nodo^.ant:=cursor2;
	if (cursor1 <> nil) then
		cursor1^.ant:=nodo;
	cursor2^.sig:=nodo;
end;

procedure insertarOrdenado(var lista:puntNodo; nodo:puntNodo);
begin
	if (lista^.numero > nodo^.numero) then
		begin
			nodo^.sig:=lista;
			lista^.ant:=nodo;
			lista:=nodo;
		end
	else
		insertarLugarCorrecto(lista, nodo);
end;

procedure insertarNodo(var lista:puntNodo; nodo:puntNodo);
begin
	if (lista = nil) then
		lista:=nodo
	else
		insertarOrdenado(lista, nodo);
end;

procedure crearNodo(var nodo:puntNodo; numero:real);
begin
	new(nodo);
	nodo^.numero:=numero;
	nodo^.posicion:=0;
	nodo^.ant:=nil;
	nodo^.sig:=nil;
end;

procedure cargarLista(var lista:puntNodo);
var
	nodo:puntNodo;
	contador:integer;
	numero:real;
begin
	nodo:=nil;
	contador:=0;
	writeln('INGRESE LOS ELEMENTOS A LA LISTA:');
	while (contador < MAX_ELEMENTOS) do
		begin
			readln(numero);
			crearNodo(nodo, numero);
			insertarNodo(lista, nodo);
			contador:=contador+1;
		end;
	actualizarPosiciones(lista);
end;

////////////////////////////////////////////////////////////////////////

var
	lista:puntNodo;
	
begin
	lista:=nil;
	cargarLista(lista);
	mostrarLista(lista);
	mostrarListaInversa(lista);
	eliminarElemento(lista);
	mostrarLista(lista);
	mostrarListaInversa(lista);
end.
