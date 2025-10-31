unit controller_currencies;

{$mode DELPHI}{$H+}

interface

uses
  SysUtils, Horse, Horse.Jhonson, fpjson;

procedure ControllerCurrencies(Req: THorseRequest; Res: THorseResponse);

implementation

procedure ControllerCurrencies(Req: THorseRequest; Res: THorseResponse);
var
  JSONArray : TJSONArray;
begin
  JSONArray := TJSONArray.Create;
  try
    JSONArray.Add('USD');
    JSONArray.Add('BRL');
    JSONArray.Add('GBP');
    JSONArray.Add('EUR');

    Res.ContentType('application/json; charset=UTF-8').Send(JSONArray.AsJSON);
  except
    Res.Status(500).Send('Erro ao gerar a lista de moedas. Reinicie o aplicativo e tente novamente.');
  end;
end;

end.
