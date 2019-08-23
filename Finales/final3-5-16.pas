program final35;

uses
	crt;
	
const
	MAX_ELEMENTOS = 7;
	
type
	puntAr = ^tPuntAr;
	tPuntAr = record
		cliente, importe:integer;
		men, may:puntAr;
	end;
	
	puntList = ^tPuntList;
	tPuntList = record
		cliente, importeTotal:integer;
		ant, sig:puntList;
	end;
	
	tClientes = record
		cliente, importe:integer;
	end;
	
	archClientes = file of tClientes;
	
////////////////////////////////////////////////////////////////////////

procedure verificarExisteArchivo(var archivo:archClientes; var error:boolean);
begin
	{$i-}
	reset(archivo);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure cargarArchivo(var archivo:archClientes);
var
	dato:tClientes;
	cliente, importe, contador:integer;
begin
	contador:=0;
	writeln('INGRESE LOS DATOS AL ARCHIVO:');
	while (contador < MAX_ELEMENTOS) do
		begin
			writeln('CLIENTE: ');
			readln(cliente);
			writeln('IMPORTE: ');
			readln(importe);
			dato.cliente:=cliente;
			dato.importe:=importe;
			write(archivo, dato);
			contador:=contador+1;
		end;
end;

procedure crearNodoArbol(dato:tClientes; var nodo:puntAr);
begin
	new(nodo);
	nodo^.cliente:=dato.cliente;
	nodo^.importe:=dato.importe;
	nodo^.men:=nil;
	nodo^.may:=nil;
end;

procedure insertarNodo(var arbol:puntAr; nodo:puntAr);
begin
	if (arbol = nil) then
		arbol:=nodo
	else
		if (arbol^.cliente >= nodo^.cliente) then
			insertarNodo(arbol^.men, nodo)
		else
			if (arbol^.cliente < nodo^.cliente) then
				insertarNodo(arbol^.may, nodo);
end;

procedure cargarArbol(var archivo:archClientes; var arbol:puntAr);
var
	dato:tClientes;
	nodo:puntAr;
begin
	reset(archivo);
	nodo:=nil;
	while not eof(archivo) do
		begin
			read(archivo, dato);
			crearNodoArbol(dato, nodo);
			insertarNodo(arbol, nodo);
		end;
end;

procedure imprimirArbol(arbol:puntAr);
begin
	if (arbol <> nil) then
		begin
			writeln('CLIENTE: ',arbol^.cliente,', IMPORTE: ',arbol^.importe);
			imprimirArbol(arbol^.men);
			imprimirArbol(arbol^.may);
		end;
end;

procedure crearNodoLista(arbol:puntAr; var nodo:puntList);
begin
	new(nodo);
	nodo^.cliente:=arbol^.cliente;
	nodo^.importeTotal:=arbol^.importe;
	nodo^.ant:=nil;
	nodo^.sig:=nil;
end;

function buscaCliente(lista:puntList; cliente:integer):puntList;
var
	cursor:puntList;
begin
	cursor:=lista;
	while (cursor <> nil) and (cursor^.cliente <> cliente) do
		cursor:=cursor^.sig;
	buscaCliente:=cursor;
end;

procedure insertarOrdenadoLista(var lista:puntList; nodo:puntList);
var
	cursorAnt, cursorSig:puntList;
begin
	//SI HAY QUE INSERTAR EN EL INICIO
	if (lista^.cliente > nodo^.cliente) then
		begin
			nodo^.sig:=lista;
			lista^.ant:=nodo;
			lista:=nodo;
		end
	else
		begin
			cursorSig:=lista;
			cursorAnt:=nil;
			while (cursorSig <> nil) and (cursorSig^.cliente < nodo^.cliente) do
				begin
					cursorAnt:=cursorSig;
					cursorSig:=cursorSig^.sig;
				end;
			nodo^.sig:=cursorSig;
			nodo^.ant:=cursorAnt;
			//SI ES AL FINAL
			if (cursorSig <> nil) then
				cursorSig^.ant:=nodo;
			cursorAnt^.sig:=nodo;
		end;
end;

procedure insertarNodoLista(var lista:puntList; nodo:puntList);
var
	cursor:puntList;
begin
	if (lista = nil) then
		lista:=nodo
	else
		begin
			cursor:=buscaCliente(lista, nodo^.cliente);
			if (cursor <> nil) then
				cursor^.importeTotal:=cursor^.importeTotal+nodo^.importeTotal
			else
				insertarOrdenadoLista(lista, nodo);
		end;
end;

procedure recorrerArbol(arbol:puntAr; clienteInicial:integer; clienteFinal:integer; var lista:puntList);
var
	nodo:puntList;
begin
	if (arbol <> nil) then
		begin
			if (arbol^.cliente >= clienteInicial) and (arbol^.cliente <= clienteFinal) then
				begin
					crearNodoLista(arbol, nodo);
					insertarNodoLista(lista, nodo);
				end;
			if (arbol^.cliente > clienteInicial) then
				recorrerArbol(arbol^.men, clienteInicial, clienteFinal, lista);
			if (arbol^.cliente < clienteFinal) then
				recorrerArbol(arbol^.may, clienteInicial, clienteFinal, lista);
		end;
end;

procedure cargarLista(arbol:puntAr; var lista:puntList);
var
	clienteInicial, clienteFinal:integer;
begin
	writeln;
	writeln('INGRESE EL CLIENTE INICIAL: ');
	readln(clienteInicial);
	writeln('INGRESE EL CLIENTE FINAL: ');
	readln(clienteFinal);
	recorrerArbol(arbol, clienteInicial, clienteFinal, lista);
end;

procedure imprimirLista(lista:puntList);
var
	cursor:puntList;
begin
	cursor:=lista;
	writeln;
	writeln('LISTA:');
	while (cursor <> nil) do
		begin
			writeln('CLIENTE: ',cursor^.cliente,', IMPORTE TOTAl: ',cursor^.importeTotal);
			cursor:=cursor^.sig;
		end;
	cursor:=lista;
	writeln;
	writeln('LISTA INVERSA:');
	if (cursor <> nil) then
		begin
			while (cursor^.sig <> nil) do
				cursor:=cursor^.sig;
			while (cursor <> nil) do
				begin
					writeln('CLIENTE: ',cursor^.cliente,', IMPORTE TOTAl: ',cursor^.importeTotal);
					cursor:=cursor^.ant;
				end;
		end;
end;

procedure eliminarArbol(var arbol:puntAr);
begin
	if (arbol <> nil) then
		begin
			eliminarArbol(arbol^.men);
			dispose(arbol);
			eliminarArbol(arbol^.may);
		end;
end;


////////////////////////////////////////////////////////////////////////

var
	error:boolean;
	arbol:puntAr;
	lista:puntList;
	archivo:archClientes;
	
begin
	error:=false;
	arbol:=nil;
	lista:=nil;
	assign(archivo,'clientes.dat');
	verificarExisteArchivo(archivo, error);
	if (error) then
		begin
			rewrite(archivo);
			cargarArchivo(archivo);
		end;
	cargarArbol(archivo, arbol);
	close(archivo);
	imprimirArbol(arbol);
	cargarLista(arbol, lista);
	imprimirLista(lista);
	eliminarArbol(arbol);
end.
