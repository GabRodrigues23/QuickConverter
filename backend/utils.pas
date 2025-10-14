unit utils;

{$mode DELPHI}{$H+}

interface

function FormatCurrencyJSON(const Value: Double): string;

implementation

uses
  SysUtils;

function FormatCurrencyJSON(const Value: Double): string;
var
  fs: TFormatSettings;
begin
  fs := DefaultFormatSettings;
  fs.DecimalSeparator := '.';

  Result := FormatFloat('0.00', Value, fs);
end;

end.

