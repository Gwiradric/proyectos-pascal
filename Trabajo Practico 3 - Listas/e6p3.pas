program e6p3;

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

procedure imprimirLista(lista:puntNodo);
begin
	if (lista <> nil) then
		begin
			write(lista^.numero,' ');
			imprimirLista(lista^.sig);
		end;
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

procedure crearNodo(var nodo:puntNodo; numero:integer);
begin
	new(nodo);
	nodo^.numero:=numero;
	nodo^.sig:=nil;
end;

procedure insertarElemento(var lista:puntNodo);
var
	nodo:puntNodo;
	numero:integer;
begin
	nodo:=nil;
	writeln('INGRESE EL ELEMENTO QUE DESEA INSERTAR: ');
	read(numero);
	crearNodo(nodo, numero);
	insertarOrdenado(lista, nodo);
end;

procedure insertarNodo(var lista:puntNodo; nodo:puntNodo);
begin
	if (lista = nil) then
		lista:=nodo
	else
		insertarNodo(lista^.sig, nodo);
end;

procedure cargarLista(var lista:puntNodo);
var
	contador, numero:integer;
	nodo:puntNodo;
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
	lista:puntNodo;
	
begin
	lista:=nil;
	cargarLista(lista);
	insertarElemento(lista);
	imprimirLista(lista);
end.
