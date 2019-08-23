program e3p3;

uses
	crt;
	
const
	MAX_ELEMENTOS = 10;
	
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

function retornaMaximo(lista:puntNodo):integer;
var
	maximo:integer;
	cursor:puntNodo;
begin
	cursor:=lista;
	maximo:=lista^.numero;
	while (cursor <> nil) do
		begin
			if (cursor^.numero >= maximo) then
				maximo:=cursor^.numero;	
			cursor:=cursor^.sig;
		end;
	retornaMaximo:=maximo;
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
	contador:=0;
	nodo:=nil;
	writeln('INGRESE LOS ELEMENTOS A LA LISTA: ');
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
	writeln('EL MAXIMO DE LA LISTA ES: ', retornaMaximo(lista));
	eliminarLista(lista);
end.
