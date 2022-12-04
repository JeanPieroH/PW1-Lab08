#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q=CGI->new();
my $expresion=$q->param("expresion");
my $resultado=evaluarExpresion($expresion);

print $q->header("text/html");
print <<BLOCK;
<!DOCTYPE html>
<html lang="es">
  <head> 
    <title>Caluladora</title>
    <meta charset="UTF-8">
    <link rel="shortcurt icon" href="https://cdn-icons-png.flaticon.com/512/2374/2374370.png">
    <link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet'>
    <link rel="stylesheet" href="../css/style.css"> 
 </head>

  <body>
    <div class="card">
      <h1 class="header">Calculadora</h1>
      <form action="../index.html">
        <p class="texto">Calcular:</p>
        <p class="texto resultado">$expresion</p>
        <p class="texto">Resultado:</p>
        <p class="texto resultado">$resultado</p>
        <div class="botonContenedor">
          <p><input class="boton" type="submit" value="Regresar"></p>
        </div>
      </form>
    </div>
    <footer>
      <p>Grupo 2</p>
      <p>UNSA-2022</p>
    </footer>
  </body>
</html>
BLOCK

sub evaluarExpresion{
  my $expresion=$_[0];

  while (not $expresion=~/^\-?[0-9]+(\.[0-9]+)?$/){
    if($expresion=~/No ingreso una expresion valida/){
      $expresion="No ingreso una expresion valida";
      last;
    }
    if($expresion=~/No se puede dividir por 0/){
      $expresion="No se puede dividir por 0";
      last;
    }
    $expresion=evaluarOperacion($expresion);
  }

  return $expresion;
}

sub evaluarOperacion{
  my $expresion=$_[0];
  my $resultado;
  
  if($expresion=~/\((.+)\)/){
    $resultado=evaluarExpresion($1);
    if ($resultado=~/^\-?[0-9]+(\.[0-9]+)?$/){
      if ($expresion=~/([0-9]+(\.[0-9]+)?)\(.+\)/){
        $resultado=operacion($1,"*",$resultado);
        $expresion=~s/([0-9]+(\.[0-9]+)?)\(.+\)/($resultado)/;
      }
      elsif($expresion=~/\(.+\)([0-9]+(\.[0-9]+)?)/){
        $resultado=operacion($resultado,"*",$1);
        $expresion=~s/\(.+\)([0-9]+(\.[0-9]+)?)/($resultado)/;
      }
      else{
        $expresion=~s/\((.+)\)/$resultado/;
      }
    }
    else{
     $expresion=~s/\((.+)\)/$resultado/;
    }
  }
  elsif ($expresion=~/([0-9]+(\.[0-9]+)?)([\*\/])([0-9]+(\.[0-9]+)?)/){
    $resultado=operacion($1,$3,$4);
    $expresion=~s/([0-9]+(\.[0-9]+)?)([\*\/])([0-9]+(\.[0-9]+)?)/$resultado/;    
  } 
  elsif ($expresion=~/(\-?[0-9]+(\.[0-9]+)?)([\+\-])([0-9]+(\.[0-9]+)?)/){
    $resultado=operacion($1,$3,$4);
    $expresion=~s/(\-?[0-9]+(\.[0-9]+)?)([\+\-])([0-9]+(\.[0-9]+)?)/$resultado/;    
  }
  else{
    $expresion="No ingreso una expresion valida";
  }

  return $expresion;
}


sub operacion{
  my $numero1=$_[0];
  my $operador=$_[1];
  my $numero2=$_[2];
  my $resultado;

  if ($operador eq "+"){
    $resultado=$numero1+$numero2;
  }elsif($operador eq "-"){
    $resultado=$numero1-$numero2;
  }elsif($operador eq "*"){
    $resultado=$numero1*$numero2;
  }elsif ($operador eq "/"){
    if ($numero2==0){
      $resultado="No se puede dividir por 0";
    }
    else{
      $resultado=$numero1/$numero2;
    }
  }
  return $resultado;
}
