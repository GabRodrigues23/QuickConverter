unit controller_conversion;

{$mode DELPHI}{$H+}

interface

uses
  SysUtils, Horse, ServiceAPI, utils, fpjson, jsonparser;

procedure ControllerConversion(Req: THorseRequest; Res: THorseResponse);

implementation

procedure ControllerConversion(Req: THorseRequest; Res: THorseResponse);
var
  FromCurrency, ToCurrency: string;
  Amount: double;
  ResultValue: double;
  JSONObject: TJSONObject;
begin
  try
    FromCurrency := Req.Query['from'];
    ToCurrency := Req.Query['to'];
    Amount := StrToFloat(Req.Query['amount']);

    ResultValue := ConvertCurrency(FromCurrency, ToCurrency, amount);

    JSONObject := TJSONObject.Create;
    try
      JSONObject.Add('originalAmount', FormatCurrencyJSON(Amount));
      JSONObject.Add('fromCurrency', FromCurrency);
      JSONObject.Add('toCurrency', ToCurrency);
      JSONObject.Add('convertedValue', FormatCurrencyJSON(ResultValue));

      Res.ContentType('application/json; charset=UTF-8').Send(JSONObject.AsJSON);

    finally
      // Jhonson é responsável por liberar a memória
      // JSONObject.Free;
    end;
  except
    on E: Exception do
      Res.Status(400).Send(E.Message);
  end;
end;

end.
