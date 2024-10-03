clear all;
clc;

% Įėjimo masyvas
x = 0.1:1/22:1;

% Simuliuojama funkcija
y = (1 + 0.6 * sin (2 * pi * x / 0.7)) + 0.3 * sin (2 * pi * x) / 2;

% Išėjimo neurone - tiesinė aktyvavimo funkcija
% Pasirenku - pirmo, antro, trecio neurono aktyvavimo funkcijos - sigmoidė
% Ketvirto - hiperbolinis tangentas

% Pirmo svoriai
w1 = [randn(1); randn(1); randn(1); randn(1);];
% Antri svoriai
w2 = [randn(1); randn(1); randn(1); randn(1);];
% neuronų sluoksniu bazės
b1 = [randn(1); randn(1); randn(1); randn(1);];

% Išėjimo neurono bazė
b_output = randn(1);

zingsnis = 0.15;

sum1 = [0; 0; 0; 0;];
sum2 = 0;

neuronu_iseitys = [0; 0; 0; 0;];

uzslepto_sluoksnio_paklaida = [0; 0; 0; 0;];

for i = 1:100000

    for n = 1:length(x)
    
        % Sveriame suma pirmame sluoksnyje
        for j = 1:4
            sum1(j) = x(n) * w1(j) + b1(j);
        end
        
        % Aktyvavimo funkcijos, kur pirmos trys funkcijos yra sigmoidines,
        % ir viena hiperbolinio tangento

        %sigmoides aktyvavimo funkcija yra 1 / (1 + e^(-x))
        %hiperbolinio tangento aktyvavimo funkcija yra 2/(1+e^(-2x)) - 1
        neuronu_iseitys(1) = 1/(1+exp(-sum1(1))); 
        neuronu_iseitys(2) = 1/(1+exp(-sum1(2)));
        neuronu_iseitys(3) = 1/(1+exp(-sum1(3)));
        neuronu_iseitys(4) = 2/(1+exp(-2*sum1(4))) - 1;
        
        % Pasverta suma antrame sluoksnyje
        sum2 = 0;
        for j = 1:4
            sum2 = sum2 + neuronu_iseitys(j) * w2(j);
        end
        sum2 = sum2 + b_output;
        
        
        % Skaičiuojama klaida
        
        e = y(n) - sum2;
        
        % Pirmo sluoksnio (paslėpto) deltos, apskaicuojamos is isvestiniu
        % sigmoidziu ir hiperboliniu tangentoidziu, kur 
        % e * w2(x), yra error ir slaptojo neurono sandauga,
        % o pirmoji funkcijos dalis yra atitinkamai sigmoidines funkcijos
        % ir hiperbolinio tangento išvestinės
    
        uzslepto_sluoksnio_paklaida(1) = neuronu_iseitys(1)*(1-neuronu_iseitys(1))*(e * w2(1));
        uzslepto_sluoksnio_paklaida(2) = neuronu_iseitys(2)*(1-neuronu_iseitys(2))*(e * w2(2));
        uzslepto_sluoksnio_paklaida(3) = neuronu_iseitys(3)*(1-neuronu_iseitys(3))*(e * w2(3));
        uzslepto_sluoksnio_paklaida(4) = (1 - neuronu_iseitys(4)^2) *(e * w2(4));
        
        % Svorniu atnaujinimas
        for j=1:4
            w2(j) = w2(j) + zingsnis*e*neuronu_iseitys(j);
            w1(j) = w1(j) + zingsnis*uzslepto_sluoksnio_paklaida(j)*x(n);
            b1(j) = b1(j) + zingsnis*uzslepto_sluoksnio_paklaida(j);
        end
        b_output = b_output + zingsnis*e;
    end
end

fprintf('Mokymas baigtas, braizome grafika su apmokytais svoriais\r\n')

for n = 1:length(x)
    
    % Pasverta suma pirmame sluoksnyje
    for j=1:4
        sum1(j) = x(n) * w1(j) + b1(j);
    end
    
    % Aktyvavimo funkcijos 
    neuronu_iseitys(1) = 1/(1+exp(-sum1(1))); % sigmoidės
    neuronu_iseitys(2) = 1/(1+exp(-sum1(2)));
    neuronu_iseitys(3) = 1/(1+exp(-sum1(3)));
    neuronu_iseitys(4) = 2/(1+exp(-2*sum1(4))) - 1;
    
    % Pasverta suma antrame sluoksnyje
    
    sum2 = 0;
    for j = 1:4
        sum2 = sum2 + neuronu_iseitys(j) * w2(j);
    end
    sum2 = sum2 + b_output;
        
    hold on;

    plot(x(n), sum2, '*b',x(n), y(n),'*r');
end

legend('Apskaiciuotas rezultatas','Tiketasis rezultatas');


fprintf('Kodas sekmingai ivykdytas\r\n')





