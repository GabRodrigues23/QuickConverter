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
    JSONArray.Add('USD');   // Dólar
    JSONArray.Add('BRL');   // Real
    JSONArray.Add('GBP');   // Libra Esterlina
    JSONArray.Add('EUR');   // Euro
    JSONArray.Add('ARS');   // Peso Argentino
    JSONArray.Add('JPY');   // Iene
    JSONArray.Add('CHF');   // Franco Suiço

    Res.ContentType('application/json; charset=UTF-8').Send(JSONArray.AsJSON);
  except
    Res.Status(500).Send('Erro ao gerar a lista de moedas.');
  end;
end;

end.
