unit ServerMain;

{$mode DELPHI}{$H+}

interface

uses
  SysUtils, Horse, Horse.Jhonson,
  controller_conversion, controller_currencies;

implementation

procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Pong');
end;

begin
  THorse.Get('/ping', GetPing);
  THorse.Get('/convert', THorseCallback(@ControllerConversion));
  THorse.Get('/currencies', THorseCallback(@ControllerCurrencies));
end.
