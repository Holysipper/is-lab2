clear all;
clc;

% Įėjimo masyvas
x = 0.1:1/22:1;

% Simuliuojama funkcija
y = (1 + 0.6 * sin (2 * pi * x / 0.7)) + 0.3 * sin (2 * pi * x) / 2;

% Pasirenku - pirmo, antro, trecio, ketvirto neurono aktyvavimo funkcijos - sigmoidė
% Penkto - hiperbolinis tangentas

%Svorių koeficientai
%w(i kuri neurona)(is kurio neurono)_(kelintas sluoksnis)

% Pirmo svoriai
wx1_1 = [randn(1); randn(1); randn(1); randn(1); randn(1);];
% Antri svoriai
w1x_2 = [randn(1); randn(1); randn(1); randn(1); randn(1);];
% neuronų sluoksniu bazės
b1 = [randn(1); randn(1); randn(1); randn(1); randn(1);];

% Išėjimo neurono bazė
b_output = randn(1);

zingsnis = 0.15;

sum1 = zeros(5);
sum2 = 0;

neuronu_iseitys = zeros(5);

pasleptojo_sluoksnio_paklaida = zeros(5);

for i = 1:100000

    for n = 1:length(x)
    
        % Sveriame suma pirmame sluoksnyje
        for j = 1:5
            sum1(j) = x(n) * wx1_1(j) + b1(j);
        end
        
        % Aktyvavimo funkcijos, kur pirmos 4 funkcijos yra sigmoidines,
        % ir 1 hiperbolinio tangento

        %sigmoides aktyvavimo funkcija yra 1 / (1 + e^(-x))
        %hiperbolinio tangento aktyvavimo funkcija yra 2/(1+e^(-2x)) - 1
        for j = 1:4
            neuronu_iseitys(j) = 1/(1+exp(-sum1(j)));
        end
        neuronu_iseitys(5) = 2/(1+exp(-2 * sum1(5))) - 1;

        % Pasverta suma antrame sluoksnyje
        sum2 = 0;
        for j = 1:5
            sum2 = sum2 + neuronu_iseitys(j) * w1x_2(j);
        end
        sum2 = sum2 + b_output;
        
        
        % Skaičiuojama klaida
        
        e = y(n) - sum2;
        
        % Pirmo sluoksnio (paslėpto) deltos, apskaicuojamos is isvestiniu
        % sigmoidziu ir hiperboliniu tangentoidziu, kur 
        % e * w1x_2(x), yra error ir slaptojo neurono sandauga,
        % o pirmoji funkcijos dalis yra atitinkamai sigmoidines funkcijos
        % ir hiperbolinio tangento išvestinės
        
        % ciklas apskaiciuoti sigmoidem
        for j = 1:4
            pasleptojo_sluoksnio_paklaida(j) = neuronu_iseitys(j) * (1-neuronu_iseitys(j)) * (e * w1x_2(j));
        end
        %tangentoide apskaiciuoju atskirai
        pasleptojo_sluoksnio_paklaida(5) = (1 - neuronu_iseitys(5)^2) * (e * w1x_2(5)); 
        
        % Svorniu atnaujinimas
        for j=1:5
            w1x_2(j) = w1x_2(j) + zingsnis * e * neuronu_iseitys(j);
            wx1_1(j) = wx1_1(j) + zingsnis * pasleptojo_sluoksnio_paklaida(j) * x(n);
            b1(j) = b1(j) + zingsnis * pasleptojo_sluoksnio_paklaida(j);
        end
        b_output = b_output + zingsnis * e;
    end
end

fprintf('Mokymas baigtas, braizome grafika su apmokytais svoriais\r\n')

for n = 1:length(x)
    
    % Pasverta suma pirmame sluoksnyje
    for j=1:5
        sum1(j) = x(n) * wx1_1(j) + b1(j);
    end
    
    % Aktyvavimo funkcijos

    for j = 1:4
        neuronu_iseitys(j) = 1/(1+exp(-sum1(j)));
    end
        neuronu_iseitys(5) = 2/(1+exp(-2 * sum1(5))) - 1;
    
    % Pasverta suma antrame sluoksnyje
    
    sum2 = 0;
    for j = 1:5
        sum2 = sum2 + neuronu_iseitys(j) * w1x_2(j);
    end
    sum2 = sum2 + b_output;
        
    hold on;

    plot(x(n), sum2, '*b',x(n), y(n),'*r');
end

legend('Apskaiciuotas rezultatas','Tiketasis rezultatas');


fprintf('Kodas sekmingai ivykdytas\r\n')





