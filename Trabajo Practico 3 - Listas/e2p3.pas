program e2p3;

uses
	crt;

const
	MAX_ELEMENTOS = 10;
	
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

function sumaNumeros(lista:puntNodo):real;
var
	cursor:puntNodo;
	suma:real;
begin
	suma:=0;
	cursor:=lista;
	while (cursor <> nil) do
		begin
			suma:=suma+cursor^.numero;
			cursor:=cursor^.sig;
		end;
	sumaNumeros:=suma;
end;

procedure insertarNodo(var lista:puntNodo; nodo:puntNodo);
begin
	if (lista = nil) then
		lista:=nodo
	else
		insertarNodo(lista^.sig, nodo);
end;

procedure crearNodo(var nodo:puntNodo; numero:real);
begin
	new(nodo);
	nodo^.numero:=numero;
	nodo^.sig:=nil;
end;

procedure cargarLista(var lista:puntNodo);
var
	nodo:puntNodo;
	contador:integer;
	numero:real;
begin
	contador:=0;
	nodo:=nil;
	writeln('INGRESE LOS ELEMENTOS QUE DESEA INSERTAR EN LA LISTA: ');
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
	writeln('LA SUMA DE LOS ELEMENTOS REALES DE LA LISTA ES: ', sumaNumeros(lista));
	eliminarLista(lista);
end.
