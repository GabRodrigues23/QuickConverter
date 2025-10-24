unit ServiceAPI;

{$mode DELPHI}{$H+}

interface

uses
  SysUtils, fphttpclient, fpjson, jsonparser, DateUtils;

function ConvertCurrency(FromCur, ToCur: string; Amount: double): double;

implementation

uses
  Classes, Generics.Collections, syncobjs;

type
  TCachedRate = record
    Rate: double;
    Timestamp: TDateTime;
  end;

var
  RateCache: TDictionary<string, TCachedRate>;
  CacheLock: TCriticalSection;

const
  CACHE_EXPIRATION_SECONDS = 60;

function ConvertCurrency(FromCur, ToCur: string; Amount: double): double;
var
  Client: TFPHTTPClient;
  JsonData: TJSONData;
  JsonObj: TJSONObject;
  Url, ApiPair, RateStr, CacheKey: string;
  Rate: double;
  fs: TFormatSettings;
  CachedEntry: TCachedRate;
begin
  Result := 0;
  ApiPair := UpperCase(FromCur) + '-' + UpperCase(toCur);
  CacheKey := UpperCase(FromCur) + UpperCase(ToCur);

  CacheLock.Acquire;

  try
    if RateCache.TryGetValue(CacheKey, CachedEntry) then
    begin
      if SecondsBetween(Now, CachedEntry.Timestamp) < CACHE_EXPIRATION_SECONDS then
      begin
        WriteLn('[CACHE HIT] Usando valor em cache para: ', CacheKey);
        Result := Amount * CachedEntry.Rate;
        CacheLock.Release;
        Exit;
      end
      else
      begin
        WriteLn('[CACHE EXPIRED] Valor expirado para: ', CacheKey);
      end;
    end
    else
    begin
      WriteLn('[CACHE MISS] Valor nao encontrado para: ', CacheKey);
    end;
  finally
    CacheLock.Release;
  end;

  WriteLn('[API CALL] Buscando valor para: ', ApiPair);
  Client := TFPHTTPClient.Create(nil);
  try
    Url := 'https://economia.awesomeapi.com.br/json/last/' + ApiPair;
    JsonData := GetJSON(Client.Get(Url));
    JsonObj := TJSONObject(JsonData).Objects[CacheKey];

    fs := DefaultFormatSettings;
    fs.DecimalSeparator := '.';

    RateStr := TJSONObject(JsonObj).Strings['bid'];
    Rate := StrToFloat(RateStr, fs);

    Result := Amount * Rate;

    CacheLock.Acquire;
    try
      CachedEntry.Rate := Rate;
      CachedEntry.Timestamp := now;
      RateCache.AddOrSetValue(CacheKey, CachedEntry);
      WriteLn('[CACHE WRITE] Valor atualizado para: ', CacheKey,
        ' CachedEntry Rate: ', CachedEntry.Rate:0:4,
        ' CachedEntry Timestamp: ', DateTimeToStr(CachedEntry.Timestamp));
    finally
      CacheLock.Release;
    end;
  except
    on E: Exception do
    begin
      WriteLn('[API ERROR] Falha ao buscar cotacao para ', ApiPair, ': ', E.Message);
      raise;
    end;
  end;

  if Assigned(Client) then
    Client.Free;
end;

initialization
  RateCache := TDictionary<string, TCachedRate>.Create;
  CacheLock := TCriticalSection.Create;
  WriteLn('Cache de cotacoes inicializado.');

finalization
  if Assigned(RateCache) then RateCache.Free;
  if Assigned(CacheLock) then CacheLock.Free;
  WriteLn('Cache de cotacoes finalizado.');

end.
