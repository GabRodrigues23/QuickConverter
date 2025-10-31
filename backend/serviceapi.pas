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

function GetRate(FromCur, ToCur: string): double;
var
  Client: TFPHTTPClient;
  JsonData: TJSONData;
  JsonObj: TJSONObject;
  Url, ApiPair_ForURL, RateStr, CacheKey_ForJSON: string;
  Rate: double;
  fs: TFormatSettings;
  CachedEntry: TCachedRate;
  IsInverse: boolean;
begin
  Result := 0;
  IsInverse := False;

  FromCur := UpperCase(FromCur);
  ToCur := UpperCase(ToCur);

  ApiPair_ForURL := FromCur + '-' + ToCur;
  CacheKey_ForJSON := FromCur + ToCur;

  if (FromCur = 'BRL') and (ToCur <> 'BRL') then
  begin
    IsInverse := True;
    ApiPair_ForURL := ToCur + '-' + 'BRL';
    CacheKey_ForJSON := toCur + 'BRL';
  end;

  CacheLock.Acquire;
  try
    if RateCache.TryGetValue(CacheKey_ForJSON, CachedEntry) then
    begin
      if SecondsBetween(Now, CachedEntry.Timestamp) < CACHE_EXPIRATION_SECONDS then
      begin
        WriteLn('[CACHE HIT] Usando valor em cache para: ', CacheKey_ForJSON);
        Rate := CachedEntry.Rate;


        if IsInverse and (Rate <> 0) then
          Result := 1 / Rate
        else
          Result := Rate;

        CacheLock.Release;
        Exit;
      end
      else
        WriteLn('[CACHE EXPIRED] Valor expirado para: ', CacheKey_ForJSON);
    end
    else
      WriteLn('[CACHE MISS] Valor nao encontrado para: ', CacheKey_ForJSON);
  finally
    CacheLock.Release;
  end;

  WriteLn('[API CALL] Buscando valor para: ', ApiPair_ForURL);
  Client := TFPHTTPClient.Create(nil);

  try
    Url := 'https://economia.awesomeapi.com.br/json/last/' + ApiPair_ForURL;
    JsonData := GetJSON(Client.Get(Url));
    JsonObj := TJSONObject(JsonData).Objects[CacheKey_ForJSON];

    fs := DefaultFormatSettings;
    fs.DecimalSeparator := '.';

    RateStr := TJSONObject(JsonObj).Strings['bid'];
    Rate := StrToFloat(RateStr, fs);

    CacheLock.Acquire;
    try
      CachedEntry.Rate := Rate;
      CachedEntry.Timestamp := now;
      RateCache.AddOrSetValue(CacheKey_ForJSON, CachedEntry);
      WriteLn('[CACHE WRITE] Valor atualizado para: ', CacheKey_ForJSON,
        ' / CachedEntry Rate: ', CachedEntry.Rate: 0: 4,
        ' / CachedEntry Timestamp: ', DateTimeToStr(CachedEntry.Timestamp));
    finally
      CacheLock.Release;
    end;

    if IsInverse and (Rate <> 0) then
      Result := 1 / Rate
    else
      Result := Rate;

  except
    on E: Exception do
    begin
      WriteLn('[API ERROR] Falha ao buscar cotacao para ', ApiPair_ForURL,
        ': ', E.Message);
      raise;
    end;
  end;

  if Assigned(Client) then
    Client.Free;
end;

function ConvertCurrency(FromCur, ToCur: string; Amount: double): double;
var
  FinalRate: double;
  Rate_From_To_BRL: double;
  Rate_To_To_BRL: double;
begin
  Result := 0;
  FinalRate := 0;
  try
    if FromCur = ToCur then
    begin
      WriteLn('[LOGIC] Caso 0: Moedas iguais.');
      FinalRate := 1.0;
    end
    else if ToCur = 'BRL' then
    begin
      WriteLn('[LOGIC] Caso 1: Conversao para BRL (', FromCur, ' -> BRL)');
      FinalRate := GetRate(FromCur, 'BRL');
    end
    else if FromCur = 'BRL' then
    begin
      WriteLn('[LOGIC] Caso 2: Conversao de BRL (BRL -> ', ToCur, ')');
      FinalRate := GetRate('BRL', ToCur);
    end
    else
    begin
      WriteLn('[LOGIC] Caso 3: Conversao cruzada (', FromCur, ' -> ', ToCur, ')');
      Rate_From_To_BRL := GetRate(FromCur, 'BRL');
      Rate_To_To_BRL := GetRate('BRL', ToCur);

      if Rate_To_To_BRL = 0 then
      begin
        WriteLn('[LOGIC ERROR] Divisao por zero em conversao cruzada. Cotacao de ',
          ToCur, ' para BRL e zero.');
        FinalRate := 0;
      end
      else
        FinalRate := Rate_From_To_BRL / Rate_To_To_BRL;
    end;
    Result := Amount * FinalRate;
  except
    on E: Exception do
    begin
      WriteLn('[CONVERT ERROR] Falha ao calcular conversao de ',
        FromCur, ' para ', ToCur, ': ', E.Message);
      Result := 0;
    end;
  end;
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
