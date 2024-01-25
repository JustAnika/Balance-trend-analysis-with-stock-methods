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

[nazwa_pliku, sciezka_do_pliku]=uigetfile("*");
dane = load(append(sciezka_do_pliku,nazwa_pliku));
dlugosc = [];
zakres = [];
predkosc = [];
if extractAfter(nazwa_pliku,'.') == "mat"
    nazwa_struktury = append("record_",replace(replace(replace(erase(nazwa_pliku,'.mat'),' ','_'),'ś','_'),'-','_')); 
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
        for j=1:numer
            temp = 0;
            for k=1:size(data.("badanie"+number).x,2)-1
                temp = temp + sqrt((data.("badanie"+number).x(k)-data.("badanie"+number).x(k+1))^2+(data.("badanie"+number).y(k)-data.("badanie"+number).y(k+1))^2);
            end
            dlugosc = [dlugosc; temp]; 
            %predkosc
            predkosc=[predkosc; temp/data.("badanie"+number).t(end)];
            %zakres
            zakres=[zakres; max(data.("badanie"+number).x) - min(data.("badanie"+number).x), max(data.("badanie"+number).y) - min(data.("badanie"+number).y)];
        end
        disp("Długość w mm:")
        disp(dlugosc);
        disp("Średnia prędkość w mm/s :")
        disp(predkosc);
        disp("Zakres ruchu w X i w Y w mm:")
        disp(zakres);
    else
        for j=1:size(dane.(nazwa_struktury).movements,2)
            temp=0;
            x = dane.(nazwa_struktury).movements(j).sources.signals.signal_18.data(1).data';
            y = dane.(nazwa_struktury).movements(j).sources.signals.signal_18.data(2).data';
            fp = dane.(nazwa_struktury).movements(j).sources.signals.signal_18.frequency;
            t = 0:(1/fp):double(dane.(nazwa_struktury).movements(j).sources.signals.signal_18.count-1)*(1/fp);
            for k=1:size(x,2)-1
                temp = temp + sqrt((x(k)-x(k+1))^2+(y(k)-y(k+1))^2);
            end
            dlugosc = [dlugosc; temp]; 
            %predkosc
            predkosc=[predkosc; temp/t(end)];
            %zakres
            zakres=[zakres; max(x) - min(x), max(y) - min(y)];
        end
        disp("Długość w mm:")
        disp(dlugosc);
        disp("Średnia prędkość w mm/s :")
        disp(predkosc);
        disp("Zakres ruchu w X i w Y w mm:")
        disp(zakres);
    end 
% wczytanie plików txt
elseif extractAfter(nazwa_pliku,'.') == "txt"
    x=dane(:,1)';
    y=dane(:,2)';
    fp=100;
    t=0:1/fp:(size(x,2)-1)*1/fp;
    dlugosc=0;
    for k=1:size(x,2)-1
        dlugosc = dlugosc + sqrt((x(k)-x(k+1))^2+(y(k)-y(k+1))^2);
    end 
    %predkosc
    predkosc=dlugosc/t(end);
    %zakres
    zakres=[max(x) - min(x), max(y) - min(y)];
    disp("Długość w mm:")
    disp(dlugosc);
    disp("Średnia prędkość w mm/s :")
    disp(predkosc);
    disp("Zakres ruchu w X i w Y w mm:")
    disp(zakres);
end