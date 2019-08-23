program e3p1;

uses
	crt;
	
type
	aEnteros = file of integer;

////////////////////////////////////////////////////////////////////////

var
	archEnteros:aEnteros;
	entero:integer;
	
begin
	assign(archEnteros,'Enteros.dat');
	
	//EL EJERCICIO DICE QUE EXISTE EL ARCHIVO, NO NECESITO COMPROBAR
	
	reset(archEnteros);
	while not eof(archEnteros) do
		read(archEnteros, entero);
	writeln('Ingrese el entero a insertar:');
	readln(entero);
	write(archEnteros, entero);
	
	close(archEnteros);
end.
