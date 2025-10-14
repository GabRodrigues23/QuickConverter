program backend;

{$mode DELPHI}{$H+}

uses
  Horse,
  ServerMain,
  ServiceAPI,
  utils,
  opensslsockets;

begin
  WriteLn('QuickConverter API iniciando...');
  THorse.Listen(9000);
end.
