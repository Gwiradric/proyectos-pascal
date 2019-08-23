program e9p3;

uses
	crt;
	
const
	MAX_ELEMENTOS = 5;
	
type
	puntNodo = ^tNodo;
	tNodo = record
		numero:integer;
		sig:puntNodo;
	end;
	
////////////////////////////////////////////////////////////////////////

procedure eliminarLista(var lista:puntNodo);
begin
	if (lista <> nil) then
		eliminarLista(lista^.sig);
	dispose(lista);
end;

procedure invertirLista(var lista:puntNodo; nodoInicio:puntNodo; nodoFinal:puntNodo);
var
	cursorSig, cursorAnt:puntNodo;
begin
	cursorSig:=nodoFinal;
	cursorAnt:=lista;
	while (cursorAnt <> cursorSig) do
		begin
			while (cursorAnt^.sig <> cursorSig) do
				cursorAnt:=cursorAnt^.sig;
			cursorSig^.sig:=cursorAnt;
			cursorAnt^.sig:=nil;
			cursorSig:=cursorSig^.sig;
			cursorAnt:=lista;
		end;
	lista:=nodoFinal;
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
	writeln('LA LISTA ES:');
	imprimirLista(lista);
end;

function buscaFinal(lista:puntNodo):puntNodo;
var
	cursor:puntNodo;
begin
	cursor:=lista;
	while (cursor^.sig <> nil) do
		cursor:=cursor^.sig;
	buscaFinal:=cursor;
end;

function buscaInicio(lista:puntNodo):puntNodo;
begin
	buscaInicio:=lista;
end;

procedure insertarNodo(var lista:puntNodo; nodo:puntNodo);
begin
	if (lista = nil) then
		lista:=nodo
	else
		insertarNodo(lista^.sig, nodo);
end;

procedure crearNodo(var nodo:puntNodo; numero:integer);
begin
	new(nodo);
	nodo^.numero:=numero;
	nodo^.sig:=nil;
end;

procedure cargarLista(var lista:puntNodo);
var
	nodo:puntNodo;
	contador, numero:integer;
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
end;

////////////////////////////////////////////////////////////////////////

var
	lista, nodoInicio, nodoFinal:puntNodo;
	
begin
	lista:=nil;
	cargarLista(lista);
	nodoInicio:=buscaInicio(lista);
	nodoFinal:=buscaFinal(lista);
	invertirLista(lista, nodoInicio, nodoFinal);
	mostrarLista(lista);
	eliminarLista(lista);
end.
