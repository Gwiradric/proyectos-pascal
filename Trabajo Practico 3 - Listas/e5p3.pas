program e5p3;

uses
	crt;
	
type
	puntNodo = ^tNodo;
	tNodo = record
		letra:char;
		sig:puntNodo;
	end;
	
////////////////////////////////////////////////////////////////////////

procedure eliminarLista(lista:puntNodo);
begin
	if (lista <> nil) then
		eliminarLista(lista^.sig);
	dispose(lista);
end;

procedure imprimirLista(lista:puntNodo);
begin
	if (lista <> nil) then
		begin
			write(lista^.letra,' ');
			imprimirLista(lista^.sig);
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

procedure cargarLista(var lista:puntNodo);
var
	letra:char;
	nodo:puntNodo;
	salir:boolean;
begin
	writeln('INGRESE LOS ELEMENTOS QUE DESEE CARGAR A LA LISTA.');
	writeln('TERMINE LA CARGA CON UN *.');
	salir:=false;
	nodo:=nil;
	while not (salir) do
		begin
			readln(letra);
			if (letra = '*') then
				begin
					writeln('FIN DE LA CARGA.');
					salir:=true;
				end
			else
				begin
					crearNodo(nodo, letra);
					insertarNodo(lista, nodo);
				end;
		end;
end;

////////////////////////////////////////////////////////////////////////

var
	lista:puntNodo;
	
begin
	lista:=nil;
	cargarLista(lista);
	imprimirLista(lista);
	eliminarLista(lista);
end.
