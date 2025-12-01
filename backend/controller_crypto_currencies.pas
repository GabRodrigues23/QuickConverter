unit controller_crypto_currencies;

{$mode DELPHI}{$H+}

interface

uses
  SysUtils, Horse, Horse.Jhonson, fpjson;

procedure ControllerCryptoCurrencies(Req: THorseRequest; Res: THorseResponse);

implementation

procedure ControllerCryptoCurrencies(Req: THorseRequest; Res: THorseResponse);
var
  JSONArray : TJSONArray;
begin
  JSONArray := TJSONArray.Create;
  try
    JSONArray.Add('BTC');   // Bitcoin
    JSONArray.Add('ETH');   // Ethereum
    JSONArray.Add('XRP');   // XRP
    JSONArray.Add('DOGE');  // Dogecoin

    Res.ContentType('application/json; charset=UTF-8').Send(JSONArray.AsJson);
  except
    Res.Status(500).Send('Erro ao gerar a lista de cryptomoedas.');
  end;
 end;

end.
