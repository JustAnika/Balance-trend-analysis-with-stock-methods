% 4_4_2023
% [r] = PW_MACD5(time, signal_AP, signal_ML, nazwa, sImage, pathOUT, filtrActivated)

% time,sig_AP,sig_ML - wektory w formie 1 kolumny
% wartość sygnałów jest w mm, czas w s

% name - nazwa plików zapisywanych
% sImage - czy zapisywać pliki jpg 0 lub 1
% pathOUT - ścieżka wynikowa dla jpg
% filtrActivated - aktywcacja filtra FDP 0 lub 1

% Prawidłowe obliczenia tylko jeżeli sygnał jest przefiltrowany

% 4_4_2023 funkcja MACD5 jest dwuwymiarowa oraz zwraca wyniki dla AP, ML i
% wypadkowe i przefiltrowane filtfilt

function [r] = PW_MACD5(time, signal_AP, signal_ML, nazwa, sImage, pathOUT, filtrActivated)


    if ~exist('nazwa','var')
        nazwa="TCIdefault";
        sImage=0;
        pathOUT="";
    end
    if ~exist('sImage','var')
        nazwa="TCIdefault";
        sImage=0;
        pathOUT="";
    end
    
    if ~exist('pathOUT','var')
        nazwa="TCIdefault";
        sImage=0;
        pathOUT="";
    end


    if ~exist('filtrActivated','var')
        signal_AP2 = signal_AP;
        signal_ML2 = signal_ML;
    else    
        if (filtrActivated==0)
            signal_AP2 = signal_AP;
            signal_ML2 = signal_ML;
        else
            Den = [1,-8.20906648508553,30.4612189067764,-67.2643986810533,97.8623702629130,-97.9983714460202,68.3919189978716,-32.8399970741002,10.3817540622745,-1.95088348292937,0.165456236392282];
            Num = [1.26663980995405e-09,1.26663980995405e-08,5.69987914479322e-08,1.51996777194486e-07,2.65994360090350e-07,3.19193232108420e-07,2.65994360090350e-07,1.51996777194486e-07,5.69987914479322e-08,1.26663980995405e-08,1.26663980995405e-09];
            signal_AP2 = filtfilt(Num,Den,signal_AP);
            signal_ML2 = filtfilt(Num,Den,signal_ML);
        end        
    end

    r.AP = PW_MACD3hidden(time, signal_AP2, nazwa, [sImage '_AP'], pathOUT);
    r.ML = PW_MACD3hidden(time, signal_ML2, nazwa, [sImage '_ML'], pathOUT);
       
    r.resultant.TCI_dV_mm_s = sqrt((r.AP.TCI_dV_mm_s^2) + (r.ML.TCI_dV_mm_s^2));
    r.resultant.TCI_dS_mm = sqrt((r.AP.TCI_dS_mm^2) + (r.ML.TCI_dS_mm^2));
    r.resultant.TCI_dT_s = sqrt((r.AP.TCI_dT_s^2) + (r.ML.TCI_dT_s^2));    
    r.resultant.std_TCI_dV_mm_s = sqrt((r.AP.std_TCI_dV_mm_s^2) + (r.ML.std_TCI_dV_mm_s^2));
    r.resultant.std_TCI_dS_mm = sqrt((r.AP.std_TCI_dS_mm^2) + (r.ML.std_TCI_dS_mm^2));
    r.resultant.std_TCI_dT_s = sqrt((r.AP.std_TCI_dT_s^2) + (r.ML.std_TCI_dT_s^2));

    r.resultant.TCI_j = r.AP.TCI_j + r.ML.TCI_j;
    r.resultant.histogram = r.AP.histogram + r.ML.histogram;
    r.resultant.t_hist = r.AP.t_hist;

    r.info.author = "Piotr Wodarski and Jacek Jurkojć";
    r.info.version = "5.1";
    r.info.generation = "4 generation for AP, ML and resultant values, filtfilt added";
    r.info.date = "20_12_2022";
    r.info.matlab = "R2022a";
    r.info.license = "Copyright reserved. Reproduction without the consent of the author is strictly prohibited";
    
end

function [wyn] = PW_MACD3hidden(time, signal, nazwa, sImage, pathOUT)
    
    EMA12 = movavg(signal,'exponential',12);
    EMA26= movavg(signal,'exponential',26);
    MACD = EMA12 - EMA26;
    SIGNAL_LINE = movavg(MACD,'exponential',9);
     
    h1 = figure(701);  
    plot(time,signal,'b',time,MACD+signal(1),'r', time,SIGNAL_LINE+signal(1),'g');
    hold on     
   
    temp=SIGNAL_LINE>=MACD;
    MACD_CROSS = abs(diff(temp)); 
    w=find(MACD_CROSS==1);    
    
    plot(time(w),signal(w),'o');
    hold off
    nazwaS = nazwa(1:end);
    if sImage==1
        saveas(h1,fullfile(pathOUT, ['sig_' nazwaS '.jpg']));
    end 
    
    ww=w;
%     w=w./100;
    Roznica = diff(time(w));
    RoznicaD = diff(signal(w)); %%%%%%%%%%%%%%%%%%%%%
    RoznicaV = RoznicaD./Roznica;
    
    RoznicaV = abs(RoznicaV);
    RoznicaD = abs(RoznicaD);
    
    WYNmean = mean(Roznica);
    WYNstd = std(Roznica); 
    WYNmeanV = mean(RoznicaV);
    WYNstdV = std(RoznicaV); 
    WYNmeanD = mean(RoznicaD);
    WYNstdD = std(RoznicaD);     
   
    wyn.TCI_dV_mm_s = WYNmeanV;
    wyn.TCI_dS_mm = WYNmeanD;
    wyn.TCI_dT_s = WYNmean;
    wyn.std_TCI_dV_mm_s = WYNstdV;
    wyn.std_TCI_dS_mm = WYNstdD;
    wyn.std_TCI_dT_s = WYNstd;   
       
    h2 = figure(702);  
    plot(Roznica);
    if sImage==1 
        saveas(h2,fullfile(pathOUT, ['diff_' nazwaS '.jpg']));
    end
    tHist = [0:0.1:2];
    h=histogram(Roznica, tHist);
    if sImage==1 
        saveas(h,fullfile(pathOUT, ['his_' nazwaS '.jpg']));
    end
    histogramN = h.Values;
    WYN_S  = sum(h.Values);
    
    wyn.TCI_j = WYN_S;
    wyn.histogram = histogramN;
    wyn.t_hist = tHist;
    
end



