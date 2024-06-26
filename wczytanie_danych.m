function [x, y, t, fp] = wczytanie_danych(sciezka_do_pliku, nazwa_pliku)
%wczytanie_danych() funkcja służaca do przetworzenia danych przed wczytaniem
%ich do aplikacji wyliczajacej zmiany trendu w stabilografi za pomoca MACD

% Wejścia funkcji:
% sciezka_do_pliku - ścieżka do wybranego w aplikacji pliku BEZ nazwy pliku
% nazwa_pliku - nazwa pliku wybranego w aplikacji

% Wyjścia funkcji:
% x - wektor przesunięć COP w osi X
% y - wektor przesunięć COP w osi Y
% t - wektor czasu w sekundach
% fp - czętotlwiość próbkowania

% aplikacja przyjmuje dowolne długości wektorów x (wektor y musi miec ta sama dlugosc co wektor x !!!), 
% wektor t musi miec taka sama dlugosc co wektory x i y,
% oraz dowolna pojedyncza wartosc czestotliwosci probkowania.

% wczytanie pliku
dane = load(append(sciezka_do_pliku,nazwa_pliku));

% nazwa struktury specyficzna do badan z listopada 2023
nazwa_struktury = append("record_",replace(replace(replace(erase(nazwa_pliku,'.mat'),' ','_'),'ś','_'),'-','_')); 

%podpowiedź do zmiennej numer_badania - wybor które badanie jest wczytywane:
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

numer_badania = 6;

% odczytanie plików z danymi  w formacie ".mat"
if extractAfter(nazwa_pliku,'.') == "mat"
    % odczytanie struktur z badań, które zlały się w jedno nagranie
    if size(dane.(nazwa_struktury).movements,2) == 1
        x_all = dane.(nazwa_struktury).movements(1).sources.signals.signal_18.data(1).data';
        y_all = dane.(nazwa_struktury).movements(1).sources.signals.signal_18.data(2).data';
        fp = dane.(nazwa_struktury).movements(1).sources.signals.signal_18.frequency;
        t_all = 0:(1/fp):double(dane.(nazwa_struktury).movements(1).sources.signals.signal_18.count-1)*(1/fp);
        number=1;
        for i=1:2:size(dane.(nazwa_struktury).movements(1).markers,2)
            if i==15
                data.("badanie"+number).x=x_all((dane.(nazwa_struktury).movements(1).markers(i).time +1)*fp:end);
                data.("badanie"+number).y=y_all((dane.(nazwa_struktury).movements(1).markers(i).time +1)*fp:end);
                data.("badanie"+number).t=t_all((dane.(nazwa_struktury).movements(1).markers(i).time +1)*fp:end)-dane.(nazwa_struktury).movements(1).markers(i).time +1;
            else
                data.("badanie"+number).x=x_all((dane.(nazwa_struktury).movements(1).markers(i).time +1)*fp:(dane.(nazwa_struktury).movements(1).markers(i+1).time)*fp);
                data.("badanie"+number).y=y_all((dane.(nazwa_struktury).movements(1).markers(i).time +1)*fp:(dane.(nazwa_struktury).movements(1).markers(i+1).time)*fp );
                data.("badanie"+number).t=t_all((dane.(nazwa_struktury).movements(1).markers(i).time +1)*fp:(dane.(nazwa_struktury).movements(1).markers(i+1).time)*fp )-dane.(nazwa_struktury).movements(1).markers(i).time +1;
                number = number+1;
            end
        end
        x=data.("badanie"+numer_badania).x;
        y=data.("badanie"+numer_badania).y;
        t=data.("badanie"+numer_badania).t;
    else
        % odczytanie danych ze struktur 
        x = dane.(nazwa_struktury).movements(numer_badania).sources.signals.signal_18.data(1).data';
        y = dane.(nazwa_struktury).movements(numer_badania).sources.signals.signal_18.data(2).data';
        fp = dane.(nazwa_struktury).movements(numer_badania).sources.signals.signal_18.frequency;
        t = 0:(1/fp):double(dane.(nazwa_struktury).movements(numer_badania).sources.signals.signal_18.count-1)*(1/fp);
    end 
% wczytanie plików txt
elseif extractAfter(nazwa_pliku,'.') == "txt"
    x=dane(:,1)';
    y=dane(:,2)';
    fp=100;
    t=0:1/fp:(size(x,2)-1)*1/fp;
end

end