fmc = 99.1e6;
fp = 19e3;
kf = 4000; 
Ac = 1; 
%%
%analysis audio 
[lt, fs1] = audioread('l-t-func.wav');
[rt, fs2] = audioread('r-t-func.wav');

minLength = min(length(lt), length(rt));

lt = lt(1:minLength);
rt = rt(1:minLength);


%%
% calculate time vector
fs = min(fs1, fs2);
duration = minLength / fs;

t = linspace(0, duration, minLength);
%%
%Xb 
af = lt + rt;

carrbf = cos(4 * pi * fp * t);
bf = lt - rt;
bf2 = bf .* carrbf;

pilot = 0.1 * cos(2 * pi * fp * t);

xb = af + bf2 + pilot;
%sound(xb, fs);
%%
%frequency modualtion 

dt = 1/fs1;
int_xb = cumsum(xb) * dt;

xc = Ac * cos(2 * pi * fmc * t + 2 * pi * kf * int_xb);
fs = 2 * fmc;
xcm = -1 * fmdemod(xc, fmc, fs, (kf / (2 * pi))) / 10000 - 2.8;
%%
%plotting
figure 
subplot(6,1,1); plot(t, af); title('l(t) + r(t)');
subplot(6,1,2); plot(t, bf2); title('(l(t) - r(t)) * carrier');
subplot(6,1,3); plot(t(1:1e4), pilot(1:1e4)); title('pilot');
subplot(6,1,4); plot(t, xb); title('Xb(input Fm)');
subplot(6,1,5); plot(t(1:5e3), xc(1:5e3)); title('Xc(output Fm)');
subplot(6,1,6);plot(t, xcm);

N = length(t);
f = (-N/2:N/2-1)*(fs/N);

AF = fftshift(abs(fft(af, N)));
BF2 = fftshift(abs(fft(bf2, N)));
PILOT = fftshift(abs(fft(pilot, N)));
XB = fftshift(abs(fft(xb, N)));
XC = fftshift(abs(fft(xc, N)));
XCM = fftshift(abs(fft(xcm, N)));

figure;
subplot(6,1,1); plot(f, AF); 
subplot(6,1,2); plot(f, BF2); 
subplot(6,1,3); plot(f, PILOT); 
subplot(6,1,4); plot(f, XB);
subplot(6,1,5); plot(f, XC);
subplot(6,1,6); plot(f, XCM); 


audiowrite('input.wav', xb, min(fs1, fs2));
audiowrite('output.wav', xcm, min(fs1, fs2));

