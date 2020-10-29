clc
clear all
k=4
x = 0:0.1:1 % generating few values as x
E = 1/2*k*x.^2; % using energy formula to clauclated KE in spring
figure(1)
%plot(t,y,'bo-',t,v,'r+-',t,E,'g');
plot(x,E) %plotting origina signals
title('Energy signal');
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");
figure(2)
stem(x,E); % plot of sampled signal
title('SAMPLED SIGNAL');
xlabel('Displacement');
ylabel('Energy');

n1=4;%number of bits per sample
L=2^n1;%no of levels of quantization
xmax=2;
xmin=-2;
del=(xmax-xmin)/L; %defining del
partition=xmin:del:2 % definition of decision lines
codebook=xmin-(del/2):del:xmax+del/2; % definition of representation levels
[index,quants]=quantiz(E,partition,codebook);%quantiz is inbuilt function which is used to quantize the signal
% gives rounded off values of the samples
figure(3)
set(gca,'Fontsize',12,'Fontweight','bold')
stem(quants,"color",'r');%plotting of quantized signal
title('QUANTIZED SIGNAL(18BEC1317)');
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");


% NORMALIZATION
l1=length(index); % to convert 1 to n as 0 to n-1 indicies
for i=1:l1
    if (index(i)~=0)
        index(i)=index(i)-1;
    end
end
l2=length(quants);
for i=1:l2 % to convert the end representation levels within the range.
    if(quants(i)==xmin-(del/2))
        quants(i)=xmin+(del/2);
    end
    if(quants(i)==xmax+(del/2))
        quants(i)=xmax-(del/2);
    end
end
% ENCODING
code=de2bi(index,'left-msb'); % DECIMAL TO BINANRY CONV OF INDICIES
k=1;
for i=1:l1 % to convert column vector to row vector
    for j=1:n1
        coded(k)=code(i,j);
        j=j+1;
        k=k+1;
    end
    i=i+1;
end
figure(4);
stairs(coded);
axis([0 190 -2 2])
%plot of digital signal
title('DIGITAL SIGNAL(18BEC1317)');
set(gca,'Fontsize',12,'Fontweight','bold')
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");
%Demodulation
code1=reshape(coded,n1,(length(coded)/n1));
index1=bi2de(code1,'left-msb'); %converting from decimal to binary
resignal=del*index+xmin+(del/2);
figure(5);%plot of demodulated signal compared to original signl
subplot(2,1,1)%plot of demodulated signal
plot(resignal,"color",'k'); 
title('DEMODULATAED SIGNAL(18BEC1317)');
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");
subplot(2,1,2)
plot(x,E,"color",'m');%plot of original signal
title('ORIGINALSIGNAL(18BEC1317)');
xlabel('Displacement','FontSize',12,'FontWeight',"bold");
ylabel('Energy','FontSize',12,'FontWeight',"bold");
