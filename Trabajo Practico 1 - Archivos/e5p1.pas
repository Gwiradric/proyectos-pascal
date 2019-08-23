program e5p1;

uses
	crt;
	
type
	aEnteros = file of integer;
	
////////////////////////////////////////////////////////////////////////

procedure cargarArchivo(var archEnteros:aEnteros);
//PROCEDIMIENTO PARA CARGAR UN ARCHIVO CON ENTEROS POSITIVOS
var
	enteroPositivo:integer;
	salir:boolean;
begin
	salir:=false;
	
	writeln('Ingrese elementos positivos y para terminar ingrese un negativo:');
	while not (salir) do
		begin
			readln(enteroPositivo);
			if (enteroPositivo > 0) then
				write(archEnteros, enteroPositivo)
			else
				salir:=true;
		end;

end;

procedure imprimirArchivo(var archEnteros:aEnteros);
//PROCEDIMIENTO PARA IMPRIMIR EL ARCHIVO PASADO POR PARAMETRO
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

procedure copiarDatos(var archEnteros:aEnteros; var copiaArchEnteros:aEnteros);
//PROCEDIMIENTO PARA COPIAR LOS DATOS DE UN ARCHIVO A OTRO
var
	numero:integer;
begin
	reset(archEnteros);
	reset(copiaArchEnteros);
	
	while not eof(archEnteros) do
		begin
			read(archEnteros, numero);
			write(copiaArchEnteros, numero);
		end;
end;

////////////////////////////////////////////////////////////////////////

var
	archEnteros, copiaArchEnteros:aEnteros;
	
begin
	assign(archEnteros,'EnterosPositivos.dat');
	
	//NO DICE QUE EXISTE ASI QUE NO COMPRUEBO Y USO REWRITE
	rewrite(archEnteros);
	
	//PRIMER INCISO DE CARGAR POSITIVOS
	cargarArchivo(archEnteros);
	
	//SEGUNDO INCISO DE MOSTRAR ELEMENTOS POR PANTALLA
	imprimirArchivo(archEnteros);
	
	assign(copiaArchEnteros,'copiaEnterosPositivos.dat');
	rewrite(copiaArchEnteros);
	
	//TERCER INCISO DE COPIAR LOS ELEMENTOS DEL ARCHIVO EN OTRO
	copiarDatos(archEnteros, copiaArchEnteros);
	
	close(archEnteros);
	close(copiaArchEnteros);
end.
	
