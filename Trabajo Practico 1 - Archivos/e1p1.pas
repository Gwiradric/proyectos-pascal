program e1p1;

uses
	crt;
	
type
	aEnteros = file of integer;
	
////////////////////////////////////////////////////////////////////////

procedure imprimirArchivo(var archEnteros:aEnteros);
var
	entero:integer;
begin
	reset(archEnteros);
	while not eof(archEnteros) do
		begin
			read(archEnteros, entero);
			writeln(entero);
		end;
end;

procedure cargarArchivo(var archEnteros:aEnteros);
begin
	reset(archEnteros);
	write(archEnteros, 18);
	write(archEnteros, 31);
	write(archEnteros, 7);
end;

procedure verificarExisteArchivo(var archEnteros:aEnteros; var error:boolean);
begin
	{$i-}
	reset(archEnteros);
	{$i+}
	if (ioresult <> 0) then
		error:=true;
end;

////////////////////////////////////////////////////////////////////////

var
	archEnteros:aEnteros;
	error:boolean;
	
begin
	error:=false;
	assign(archEnteros,'Enteros.dat');
	verificarExisteArchivo(archEnteros, error);
	if (error) then
		begin
			//SI NO EXISTE SE CREA EL ARCHIVO EN EL DIRECTORIO
			rewrite(archEnteros);
			cargarArchivo(archEnteros);
		end
	else
		imprimirArchivo(archEnteros);
	close(archEnteros);
end.
