program backend;

{$mode DELPHI}{$H+}

uses
  Horse,
  ServerMain,
  ServiceAPI,
  utils,
  opensslsockets;

begin
  WriteLn(' ------------------------------------- ');
  WriteLn('| QuickConverter API Server Iniciado! |');
  WriteLn(' ------------------------------------- ');
  THorse.Listen(9000);
end.
