program final1909;

uses
	crt;
	
type
	puntAr = ^tPuntAr;
	tPuntAr = record
		num:integer;
		men:puntAr;
		may:puntAr;
	end;
	
	puntList = ^tPuntList;
	tPuntList = record
		nodo:puntAr;
		cantidad:integer;
		sig:puntList;
	end;
	
	tArch = file of integer;
	
///////////////////////////////////////////////////////////////////////////////

procedure imprimirLista(lista:puntList);
{PROCEDIMIENTO PARA IMPRIMIR LA LISTA}
begin
	while (lista <> nil) do
		begin
			writeln(lista^.cantidad);
			lista:=lista^.sig;
		end;
end;

procedure verificarExisteArchivo(var arch:tArch; var error:boolean);
{PROCEDIMIENTO QUE CARGA EN ERROR SI HAY PROBLEMAS PARA ABRIR EL ARCHIVO O NO}
begin
	{$i-}
	reset(arch);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure cargarArchivo(var archivo:tArch);
{PROCEDIMIENTO PARA CARGAR EL ARCHIVO, LA IDEA DE HACER TODO UNA SOLA VEZ}
var
	cantidad, contador, numero:integer;
begin
	writeln('INGRESE LA CANTIDAD DE ELEMENTOS QUE DESEA INGRESAR: ');
	readln(cantidad);
	contador:=0;
	reset(archivo);
	writeln('INGRESE LOS ELEMENTOS AL ARCHIVO:');
	while (contador < cantidad) do
		begin
			readln(numero);
			write(archivo, numero);
			contador:=contador+1;
		end;
end;

procedure insertarNodoArbol(var arbol:puntAr; nodo:puntAr);
{PROCEDIMIENTO PARA INSERTAR ORDENADO UN NODO EN UN ARBOL}
begin
	if (arbol = nil) then
		arbol:=nodo
	else
		if (arbol^.num > nodo^.num) then
			insertarNodoArbol(arbol^.men, nodo)
		else
			if (arbol^.num < nodo^.num) then
				insertarNodoArbol(arbol^.may, nodo);
end;

procedure crearNodoArbol(var nodo:puntAr; numero:integer);
{PROCEDIMIENTO PARA CREAR UN NUEVO NODO DE ARBOL}
begin
	new(nodo);
	nodo^.num:=numero;
	nodo^.men:=nil;
	nodo^.may:=nil;
end;

procedure cargarArbol(var arch:tArch; var arbol:puntAr);
{PROCEDIMIENTO PARA CREAR UN NODO, CARGARLO CON LOS DATOS DEL REGISTRO DEL ARCHIVO E INSERTARLO ORDENADO EN EL ARBOL}
var
	numero:integer;
	nodo:puntAr;
begin
	nodo:=nil;
	reset(arch);
	while not eof(arch) do
		begin
			read(arch, numero);
			crearNodoArbol(nodo, numero);
			insertarNodoArbol(arbol, nodo);
		end;
end;

procedure imprimirArbol(arbol:puntAr);
{PROCEDIMIENTO PARA IMPRIMIR UN ARBOL}
begin
	if (arbol <> nil) then
		begin
			writeln(arbol^.num);
			imprimirArbol(arbol^.men);
			imprimirArbol(arbol^.may);
		end;
end;

function sumaArbol(arbol:puntAr):integer;
{FUNCION QUE SUMA LOS NODOS DE UN ARBOL}
begin
	if (arbol = nil) then
		sumaArbol:=0
	else
		sumaArbol:=sumaArbol(arbol^.men) + arbol^.num + sumaArbol(arbol^.may);
end;

procedure crearNodoLista(var nodo:puntList; nodoArbol:puntAr; cantidad:integer);
{PROCEDIMIENTO PARA CREAR UN NODO EN LA LISTA, QUE TIENE UN PUNTERO AL NODO DEL ARBOL Y A LA CANTIDAD}
begin
	new(nodo);
	nodo^.nodo:=nodoArbol;
	nodo^.cantidad:=cantidad;
	nodo^.sig:=nil;
end;

procedure insertarNodoLista(var lista:puntList; nodo:puntList);
{PROCEDIMIENTO PARA INSERTAR EL NODO EN LA LISTA}
var
	cursor:puntList;
begin
	if (lista = nil) then
		lista:=nodo
	else
		begin
			cursor:=lista;
			while (cursor^.sig <> nil) do
				cursor:=cursor^.sig;
			cursor^.sig:=nodo;
		end;
end;

procedure contarCantidadFrontera(arbol:puntAr; contador:integer; profundidad:integer; var cantidad:integer);
{PROCEDIMIENTO PARA CONTAR LA CANTIDAD DE DESCENDIENTES DE LOS NODOS FRONTERA}
begin
	if (arbol <> nil) then
		begin
			if (contador = profundidad) and ((arbol^.men <> nil) or (arbol^.may <> nil)) then
				cantidad:=cantidad+1;
			contarCantidadFrontera(arbol^.men, contador+1, profundidad, cantidad);
			contarCantidadFrontera(arbol^.may, contador+1, profundidad, cantidad);
		end;
end;

procedure obtenerNodoFrontera(arbol:puntAr; profundidad:integer; contador:integer; var nodoArbol:puntAr);
{PROCEDIMIENTO DETERMINAR SI UN NODO ES FRONTERA O NO. YO LE LLAMO FRONTERA A LOS NODOS DEL NIVEL DE PROFUNDIDAD DESEADO QUE TIENEN HIJOS}
begin
	if (arbol <> nil) then
		if (contador = profundidad) and ((arbol^.men <> nil) or (arbol^.may <> nil)) then
			nodoArbol:=arbol
		else
			begin
				obtenerNodoFrontera(arbol^.men, profundidad, contador+1, nodoArbol);
				obtenerNodoFrontera(arbol^.may, profundidad, contador+1, nodoArbol);
			end;
end;

procedure recorrerArbol(var arbol:puntAr; var lista:puntList);
{PROCEDIMIENTO QUE RECORRE EL ARBOL Y SE ENCARGA DE HACER TODO EL TRABAJO LLAMANDO A LOS DEMAS PROCEDIMIENTOS}
var
	contador, contador1, cantidad:integer;
	nodoLista, nodoLista1:puntList;
	nodoArbol:puntAr;
begin
	contador:=0;
	contador1:=0;
	nodoArbol:=nil;
	nodoLista:=nil;
	nodoLista1:=nil;
	cantidad:=0;
	contarCantidadFrontera(arbol, contador1, 3, cantidad);
	//CALCULO CANTIDAD PARA SABER CUANTAS VECES TENGO QUE BUSCAR NODOS FRONTERA QUE TIENEN HIJOS
	while (contador1 < cantidad) do
		begin
			obtenerNodoFrontera(arbol, 3, contador, nodoArbol);
			if (nodoArbol^.men <> nil) then
				begin
					crearNodoLista(nodoLista, nodoArbol^.men, sumaArbol(nodoArbol^.men));
					insertarNodoLista(lista, nodoLista);
				end;
			
			if (nodoArbol^.may <> nil) then
				begin
					crearNodoLista(nodoLista1, nodoArbol^.may, sumaArbol(nodoArbol^.may));
					insertarNodoLista(lista, nodoLista1);
				end;
			nodoArbol^.men:=nil;
			nodoArbol^.may:=nil;
			contador1:=contador1+1;
		end;
end;

///////////////////////////////////////////////////////////////////////////////

var
	arbol:puntAr;
	lista:puntList;
	archivo:tArch;
	error:boolean;
	
begin
	arbol:=nil;
	lista:=nil;
	error:=false;
	assign(archivo,'final-19-09-2017.dat');
	verificarExisteArchivo(archivo, error);
	if (error) then
		begin
			rewrite(archivo);
			cargarArchivo(archivo);
		end;
	cargarArbol(archivo, arbol);
	close(archivo);
	recorrerArbol(arbol, lista);
	imprimirArbol(arbol);
	writeln;
	writeln('LISTA DE SUBARBOLES CON SU SUMA:');
	imprimirLista(lista);
end.

