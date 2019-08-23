program final12122017;

uses
	crt;
	
type
	puntAr = ^tPuntAr;
	tPuntAr = record
		patente, anio:integer;
		men, may:puntAr;
	end;
	
	puntListAr = ^tPuntListAr;
	tPuntListAr = record
		puntero:puntAr;
		sig:puntListAr;
	end;
	
	puntList = ^tPuntList;
	tPuntList = record
		anio, cantidad:integer;
		otraLista:puntListAr;
		sig:puntList;
	end;
	
	datos = record
		patente, anio:integer;
	end;
	
	tArch = file of datos;

////////////////////////////////////////////////////////////////////////

procedure verificarExisteArchivo(var arch:tArch; var error:boolean);
{PROCEDIMIENTO PARA VERIFICAR SI EXISTE EL ARCHIVO}
begin
	{$i-}
	reset(arch);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure cargarArchivo(var arch:tArch);
{PROCEDIMIENTO PARA LA CARGA DEL ARCHIVO}
var
	cantidad, contador:integer;
	aux:datos;
begin
	contador:=0;
	writeln('INGRESAR LA CANTIDAD DE ELEMENTOS:');
	readln(cantidad);
	while (contador < cantidad) do
		begin
			writeln('INGRESE PATENTE: ');
			readln(aux.patente);
			writeln('INGRESE ANIO:');
			readln(aux.anio);
			write(arch, aux);
			contador:=contador+1;
		end;
end;

procedure crearNodoLista(var nodoLista:puntList; nodoListaArbol:puntListAr);
{PROCEDIMIENTO PARA CREAR UN NODO DE LA LISTA ANIOS}
begin
	new(nodoLista);
	nodoLista^.anio:=nodoListaArbol^.puntero^.anio;
	nodoLista^.cantidad:=1;
	nodoLista^.otraLista:=nodoListaArbol;
	nodoLista^.sig:=nil;
end;

procedure insertarOrdenadoListaArbol(var lista:puntListAr; nodo:puntListAr);
{PROCEDIMIENTO PARA INSERTAR ORDENADO EN LA LISTA DE PUNTEROS AL ARBOL}
begin
	if (lista = nil) then
		lista:=nodo
	else
		if (lista^.puntero^.patente <= nodo^.puntero^.patente) then
			insertarOrdenadoListaArbol(lista^.sig, nodo)
		else
			begin
				nodo^.sig := lista;
				Lista:= nodo;
			end
end;

procedure insertarOrdenadoLista(var lista:puntList; nodo:puntList);
{PROCEDIMIENTO PARA INSERTAR ORDENADO EN LA LISTA ANIOS}
begin
	if (lista = nil) then
		lista:=nodo
	else
		if (lista^.anio < nodo^.anio) then
			insertarOrdenadoLista(lista^.sig, nodo)
		else
			if (lista^.anio = nodo^.anio) then
				begin
					lista^.cantidad:=lista^.cantidad+1;
					insertarOrdenadoListaArbol(lista^.otraLista, nodo^.otraLista);
				end
			else
				begin
					nodo^.sig := lista;
					Lista:= nodo;
				end
end;

procedure crearNodoListaArbol(var nodoListaAr:puntListAr; nodoArbol:puntAr);
{PROCEDIMIENTO PARA CREAR UN NODO DE LOS PUNTEROS AL ARBOL}
begin
	new(nodoListaAr);
	nodoListaAr^.puntero:=nodoArbol;
	nodoListaAr^.sig:=nil;
end;

function buscaAnio(lista:puntList; anio:integer):puntList;
{FUNCION QUE BUSCA EL NODO CON EL ANIO INGRESADO}
var
	cursor:puntList;
begin
	cursor:=lista;
	while (cursor <> nil) and (cursor^.anio <> anio) do
		cursor:=cursor^.sig;
	buscaAnio:=cursor;
end;

procedure borrarNodo(var lista:puntListAr; patente:integer);
{PROCEDIMIENTO QUE BORRA UN NODO EN LA LISTA DE PUNTEROS AL ARBOL}
var
	aux:puntListAr;
begin
	if (lista <> nil) then
		if (lista^.puntero^.patente = patente) then
			begin
				aux:=lista;
				lista:=lista^.sig;
				dispose(aux);
			end
		else
			borrarNodo(lista^.sig, patente);
end;

procedure borrarNodoLista(var lista:puntList);
{PROCEDIMIENTO QUE BORRA UN NODO EN LA LISTA ANIOS}
var
	aux:puntList;
begin
	if (lista <> nil) then
		if (lista^.cantidad = 0) then
			begin
				aux:=lista;
				lista:=lista^.sig;
				dispose(aux);
			end
		else
			borrarNodoLista(lista^.sig);
end;

procedure actualizarLista(var lista:puntList; nodoArbol:puntAr; anioAnterior:integer);
{PROCEDIMIENTO PARA ACTUALIZAR LA LISTA CUANDO EL NODO DEL ARBOL YA EXISTE}
var
	cursor:puntList;
	nodoLista:puntList;
	nodoListaAr:puntListAr;
begin
	nodoListaAr:=nil;
	nodoLista:=nil;
	
end;

procedure insertarOrdenadoArbol(var arbol:puntAr; nodoArbol:puntAr; var lista:puntList; nodoLista:puntList; nodoListaAr:puntListAr);
{PROCEDIMIENTO PARA INSERTAR UN NODO ORDENADO EN EL ARBOL}
var
	anioAnterior:integer;
begin
	if (arbol = nil) then
		begin
			arbol:=nodoArbol;
			crearNodoListaArbol(nodoListaAr, nodoArbol);
			crearNodoLista(nodoLista, nodoListaAr);
			insertarOrdenadoLista(lista, nodoLista);
		end
	else
		if (arbol^.patente > nodoArbol^.patente) then
			insertarOrdenadoArbol(arbol^.men, nodoArbol, lista, nodoLista, nodoListaAr)
		else
			if (arbol^.patente < nodoArbol^.patente) then
				insertarOrdenadoArbol(arbol^.may, nodoArbol, lista, nodoLista, nodoListaAr)
			else
				if (arbol^.patente = nodoArbol^.patente) then	
					begin
						anioAnterior:=arbol^.anio;
						arbol^.anio:=nodoArbol^.anio;
						actualizarLista(lista, arbol, anioAnterior);
					end;
end;

procedure crearNodoArbol(var nodo:puntAr; aux:datos);
{PROCEDIMIENTO PARA CARGAR EL NODO PARA EL ARBOL}
begin
	new(nodo);
	nodo^.patente:=aux.patente;
	nodo^.anio:=aux.anio;
	nodo^.men:=nil;
	nodo^.may:=nil;
end;

procedure cargarArbol(var arch:tArch; var arbol:puntAr; var lista:puntList);
{PROCEDIMIENTO PARA CARGAR EL ARCHIVO}
var
	aux:datos;
	nodoArbol:puntAr;
	nodoLista:puntList;
	nodoListaArbol:puntListAr;
begin
	reset(arch);
	nodoArbol:=nil;
	nodoLista:=nil;
	nodoListaArbol:=nil;
	while not eof(arch) do
		begin
			read(arch, aux);
			crearNodoArbol(nodoArbol, aux);
			insertarOrdenadoArbol(arbol, nodoArbol, lista, nodoLista, nodoListaArbol);
		end;
end;

procedure imprimirArbol(arbol:puntAr);
{PROCEDIMIENTO PARA IMPRIMIR EL ARBOL}
begin
	if (arbol <> nil) then
		begin
			writeln('PATENTE: ',arbol^.patente,', ANIO: ',arbol^.anio);
			imprimirArbol(arbol^.men);
			imprimirArbol(arbol^.may);
		end;
end;

procedure imprimirListaArbol(lista:puntListAr);
{PROCEDIMIENTO PARA IMPRIMIR LA LISTA DE PUNTERO AL ARBOL}
begin
	if (lista <> nil) then
		begin
			writeln('PATENTE: ',lista^.puntero^.patente,', ANIO: ',lista^.puntero^.anio);
			imprimirListaArbol(lista^.sig);
		end;
end;

procedure imprimirLista(lista:puntList);
{PROCEDIMIENTO QUE IMPRIME LA LISTA}
begin
	if (lista <> nil) then
		begin
			writeln('ANIO: ',lista^.anio,', CANTIDAD: ',lista^.cantidad);
			imprimirListaArbol(lista^.otraLista);
			imprimirLista(lista^.sig);
		end;
end;

////////////////////////////////////////////////////////////////////////

var
	MODIFICACIONES:tArch;
	error:boolean;
	AUTOS:puntAr;
	ANIOS:puntList;
	
begin
	error:=false;
	AUTOS:=nil;
	ANIOS:=nil;
	assign(MODIFICACIONES,'final-12-12-17.dat');
	verificarExisteArchivo(MODIFICACIONES, error);
	if (error) then
		begin
			rewrite(MODIFICACIONES);
			cargarArchivo(MODIFICACIONES);
		end;
	cargarArbol(MODIFICACIONES, AUTOS, ANIOS);
	close(MODIFICACIONES);
	//imprimirArbol(AUTOS);
	writeln;
	imprimirLista(ANIOS);
end.
