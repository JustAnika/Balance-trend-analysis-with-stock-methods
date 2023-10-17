close all

%% punkty do zmiany %% TU MODYFIKUJ
%% tak jak linia powyżej oznaczono punkty do modyfikacji
load('OO.mat')
% Uzyskaj wartość wpisaną przez użytkownika w polu tekstowym editField
Fp = app.fpEditField.Value;


% Sprawdź, czy wartość jest liczbą zmiennoprzecinkową
if isnan(Fp)
    % Wyświetl komunikat o błędzie
    uialert(app.UIFigure, 'Wprowadzono nieprawidłową wartość.', 'Błąd');
else
    % Przypisz wartość do zmiennej typu double
    Fp = value;
    
 
end


t=t/fp;

Den = [1,-8.20906648508553,30.4612189067764,-67.2643986810533,97.8623702629130,-97.9983714460202,68.3919189978716,-32.8399970741002,10.3817540622745,-1.95088348292937,0.165456236392282];
Num = [1.26663980995405e-09,1.26663980995405e-08,5.69987914479322e-08,1.51996777194486e-07,2.65994360090350e-07,3.19193232108420e-07,2.65994360090350e-07,1.51996777194486e-07,5.69987914479322e-08,1.26663980995405e-08,1.26663980995405e-09];
x = filter(Num,Den,x');
y = filter(Num,Den,y');

t=t(1000:3000)-t(1000);
y=y(1000:3000);
x=x(1000:3000);

wyn=PW_MACD4_lite(t', y, x, "wynik", 0, "", 0);