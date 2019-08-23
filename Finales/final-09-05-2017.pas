program final090517;

uses
	crt;
	
type
	puntAr = ^tPuntAr;
	tPuntAr = record
		num:integer;
		men:puntAr;
		may:puntAr;
	end;
	
	tArch = file of integer;
	
////////////////////////////////////////////////////////////////////////

procedure verificarExisteArchivo(var arch:tArch; var error:boolean);
{PROCEDIMIENTO QUE VERIFICA SI HAY ERRORES CUANDO SE LEE EL ARCHIVO}
begin
	{$i-}
	reset(arch);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

procedure imprimirArbol(arbol:puntAr);
{PROCEDIMIENTO PARA IMPRIMIR EL ARBOL}
begin
	if (arbol <> nil) then
		begin
			writeln(arbol^.num);
			imprimirArbol(arbol^.men);
			imprimirArbol(arbol^.may);
		end;
end;

procedure insertarNodoArbol(var arbol:puntAr; nodo:puntAr);
{PROCEDIMIENTO PARA INSERTAR ORDENADO EL NODO EN EL ARBOL}
begin
	if (arbol = nil) then
		arbol:=nodo
	else
		if (arbol^.num > nodo^.num) then
			insertarNodoArbol(arbol^.men, nodo)
		else
			insertarNodoArbol(arbol^.may, nodo);
end;

procedure crearNodo(var nodo:puntAr; numero:integer);
{PROCEDIMIENTO QUE CREA UN NODO DEL ARBOL}
begin
	new(nodo);
	nodo^.num:=numero;
	nodo^.men:=nil;
	nodo^.may:=nil;
end;

function sumaDerecha(arbol:puntAr; sumaAcumulada:integer; var contador:integer):integer;
{FUNCION QUE SE ENCARGA DE SUMAR EL SUB ARBOL PASADO POR PARAMETRO}
begin
	if (arbol = nil) then
		sumaDerecha:=0
	else
		begin
			contador:=contador+arbol^.num;
			if (contador < sumaAcumulada) then
				sumaDerecha:=contador+sumaDerecha(arbol^.men, sumaAcumulada, contador);
			if (contador < sumaAcumulada) then
				sumaDerecha:=contador+sumaDerecha(arbol^.may, sumaAcumulada, contador);
			sumaDerecha:=contador;
		end;
end;

procedure recorrerArbol(arbol:puntAr; var sumaAcumulada:integer; var contador:integer; hijoDerecho:integer);
{PROCEDIMIENTO QUE SE ENCARGA DE LLAMAR AL RESTO, ESTE RECORRE EL ARBOL EN IN ORDER, VA CALCULANDO LA SUMAACUMULADA Y LA SUMA DE LO QUE TIENE EL HIJO
DERECHO, SI ES IGUAL ENTONCES IMPRIME}
begin
	if (arbol <> nil) then
		begin
			contador:=0;
			recorrerArbol(arbol^.men, sumaAcumulada, contador, hijoDerecho);
			sumaAcumulada:=sumaAcumulada + arbol^.num;
			hijoDerecho:=sumaDerecha(arbol^.may, sumaAcumulada, contador);
			if (sumaAcumulada = hijoDerecho) then
				writeln(arbol^.num);
			recorrerArbol(arbol^.may, sumaAcumulada, contador, hijoDerecho);
		end;
end;

procedure cargarArbol(var arch:tArch; var arbol:puntAr);
{PROCEDIMIENTO PARA CARGAR EL ARBOL CON LOS DATOS DEL ARCHIVO}
var
	numero:integer;
	nodo:puntAr;
begin
	nodo:=nil;
	reset(arch);
	while not eof(arch) do
		begin
			read(arch, numero);
			crearNodo(nodo, numero);
			insertarNodoArbol(arbol, nodo);
		end;
end;

procedure cargarArchivo(var arch:tArch);
{PROCEDIMIENTO PARA CARGAR EL ARCHIVO CON LOS DATOS DESEADOS}
var
	cantidadElementos, contador, numero:integer;
begin
	contador:=0;
	reset(arch);
	writeln('INGRESE LA CANTIDAD DE ELEMENTOS QUE DESEA CARGAR:');
	readln(cantidadElementos);
	writeln('INGRESAR NUMEROS AL ARCHIVO: ');
	while (contador < cantidadElementos) do
		begin
			readln(numero);
			write(arch, numero);
			contador:=contador+1;
		end;
end;

////////////////////////////////////////////////////////////////////////

var
	arbol:puntAr;
	arch:tArch;
	error:boolean;
	sumaAcumulada, hijoDerecho, contador:integer;
	
begin
	sumaAcumulada:=0;
	contador:=0;
	hijoDerecho:=0;
	arbol:=nil;
	error:=false;
	assign(arch,'final09052017.dat');
	verificarExisteArchivo(arch, error);
	if (error) then
		begin
			rewrite(arch);
			cargarArchivo(arch);
		end;
	cargarArbol(arch, arbol);
	close(arch);
	recorrerArbol(arbol, sumaAcumulada, contador, hijoDerecho);
	//imprimirArbol(arbol);
end.
