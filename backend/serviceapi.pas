unit ServiceAPI;

{$mode DELPHI}{$H+}

interface

uses
  SysUtils, fphttpclient, fpjson, jsonparser;

function ConvertCurrency(FromCur, ToCur: string; Amount: double): double;

implementation

function ConvertCurrency(FromCur, ToCur: string; Amount: double): double;
var
  Client: TFPHTTPClient;
  JsonData: TJSONData;
  JsonObj: TJSONObject;
  Url, Pair, RateStr: string;
  Rate: double;
  fs: TFormatSettings;
begin
  Result := 0;
  Client := TFPHTTPClient.Create(nil);
  try
    Pair := UpperCase(FromCur) + UpperCase(toCur);
    Url := 'https://economia.awesomeapi.com.br/json/last/' +
      UpperCase(FromCur) + '-' + UpperCase(toCur);
    JsonData := GetJSON(Client.Get(url));
    JsonObj := TJSONObject(JsonData).Objects[Pair];

    fs := DefaultFormatSettings;
    fs.DecimalSeparator := '.';

    RateStr := TJSONObject(JsonObj).Strings['bid'];
    Rate := StrToFloat(RateStr, fs);

    Result := Amount * Rate;
  finally
    Client.Free;
  end;
end;

end.
