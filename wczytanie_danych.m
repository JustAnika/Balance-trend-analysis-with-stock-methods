function [x, y, t, fp] = wczytanie_danych(sciezka_do_pliku,nazwa_pliku)
%wczytanie_danych() funkcja służaca do przetworzenia danych przed wczytaniem
%ich do aplikacji wyliczajacej zmiany trendu w stabilografi za pomoca MACD

% apliakcja przyjmuje dowolne długości wektorów x (wektor y musi miec ta sama dlugosc co wektor x !!!)
% oraz dowolna pojedyncza wartosc czestotliwosci probkowania. 
% wektor t musi miec czas pobrania probki w sekundach aby poprawnie sie wyswietlal oraz musi miec
% taka sama dlugosc co wektory x i y


% wczytanie pliku
dane=load(append(sciezka_do_pliku,nazwa_pliku)); 

% nazwa struktury specyficzna do badan z listopada 2023
nazwa_struktury=append("record_",replace(replace(replace(erase(nazwa_pliku,'.mat'),' ','_'),'ś','_'),'-','_')); 

%podpowiedź do numerkow zaraz po dane.(nazwa_struktury).movements - wybor które badanie jest
%wczytywane:
% Badania w środowisku rzeczywistym:
% 1. Oczy otwarte   60 sekund
% 2. Oczy zamkniete 60 sekund
% 3. Oczy otwarte   120 sekund
% 4. Oczy zamkniete 120 sekund
% 
% Badania w VR:
% 1. 60  sekund 0.2 Hz zaklocen
% 2. 120 sekund 0.2 Hz zaklocen
% 3. 60  sekund 0.5 Hz zaklocen
% 4. 120 sekund 0.5 Hz zaklocen
% 5. 60  sekund 0.7 Hz zaklocen
% 6. 120 sekund 0.7 Hz zaklocen
% 7. 60  sekund 1.4 Hz zaklocen
% 8. 120 sekund 1.4 Hz zaklocen
numer_badania=6;

x=dane.(nazwa_struktury).movements(numer_badania).sources.signals.signal_18.data(1).data';
y=dane.(nazwa_struktury).movements(numer_badania).sources.signals.signal_18.data(2).data';
fp=dane.(nazwa_struktury).movements(numer_badania).sources.signals.signal_18.frequency;
t=0:(1/fp):double(dane.(nazwa_struktury).movements(numer_badania).sources.signals.signal_18.count-1)*(1/fp);

end