program backend;

{$mode DELPHI}{$H+}

uses
  Horse,
  ServerMain,
  ServiceAPI,
  utils,
  opensslsockets;

begin
  WriteLn('QuickConverter API Server Iniciado...');
  THorse.Listen(9000);
end.
