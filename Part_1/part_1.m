% important config. data 
fm1 = 1000;
fm2 = 2000;
fs = 100e4; 
fc = 100e3; 

t = linspace(0, 0.01, fs);   
[b,a] = butter(5, 2*1000/fs); % LPF design

phase_error = pi/6;   
freq_error = 100;     

mt1 = cos(2*pi*fm1*t); % Message 1
mt2 = sin(2*pi*fm2*t); % Message 2

cos_e = cos(2*pi*(fc + freq_error)*t + phase_error);
sin_e = sin(2*pi*(fc + freq_error)*t + phase_error);

%% ========== SSB MODULATION ==========
% Generate Hilbert transforms for SSB modulation
m1_hilb = hilbm(mt1, fs);
m2_hilb = hilbm(mt2, fs);

% mt1 → USB, mt2 → LSB
usb = mt1 .* cos(2*pi*fc*t) - m1_hilb .* sin(2*pi*fc*t); % Upper Sideband
lsb = mt2 .* cos(2*pi*fc*t) + m2_hilb .* sin(2*pi*fc*t); % Lower Sideband


%% ========== SSB DEMODULATION ==========
usb_demod_raw = usb .* cos(2*pi*fc*t);
lsb_demod_raw = lsb .* cos(2*pi*fc*t);

rec1_ssb = filter(b, a, usb_demod_raw)*2;
rec2_ssb = filter(b, a, lsb_demod_raw)*2;



%% ========== QAM MODULATION ==========
% mt1 → I, mt2 → Q
I = mt1 .* cos(2*pi*fc*t);
Q = mt2 .* sin(2*pi*fc*t);
qam_signal = I + Q;

%% ========== QAM DEMODULATION ==========
I_demod_raw = qam_signal .* cos(2*pi*fc*t);
Q_demod_raw = qam_signal .* sin(2*pi*fc*t);

rec1_qam = filter(b, a, I_demod_raw)*2;
rec2_qam = filter(b, a, Q_demod_raw)*2;

%% 3. Effects of Carrier Phase and Frequency Offset QAM
I_err = sqrt(2) * qam_signal .* cos_e;
Q_err = sqrt(2) * qam_signal .* sin_e;

m1_errI = filter(b, a, I_err);
m2_errQ = filter(b, a, Q_err);

%% 3. Effects of Carrier Phase and Frequency Offset SSB
u_err = usb .* cos_e;
l_err = lsb .* cos_e;

m1_erru = filter(b, a, u_err);
m2_errl = filter(b, a, l_err);
%% ========== PLOTS ==========
figure;
subplot(5,1,1); plot(t, mt1); title('Original Signal 1');
subplot(5,1,2); plot(t, usb); title('(USB)');
subplot(5,1,3); plot(t, I); title('(I-channel)');
subplot(5,1,4); plot(t, rec1_ssb); title('Recovered SSB m1 (USB)');
subplot(5,1,5); plot(t, rec1_qam); title('Recovered QAM m1 (I-channel)');

figure;
subplot(5,1,1); plot(t, mt2); title('Original Signal 2');
subplot(5,1,2); plot(t, lsb); title('(LSB)');
subplot(5,1,3); plot(t, Q); title('(Q-channel)');
subplot(5,1,4); plot(t, rec2_ssb); title('Recovered SSB m2 (LSB)');
subplot(5,1,5); plot(t, rec2_qam); title('Recovered QAM m2 (Q-channel)');

figure;
subplot(4,1,1); plot(t, m1_errI); title('m1 with Carrier Error QAM');
subplot(4,1,2); plot(t, m2_errQ); title('m2 with Carrier Error QAM');
subplot(4,1,3); plot(t, m1_erru); title('m1 with Carrier Error SSB');
subplot(4,1,4); plot(t, m2_errl); title('m2 with Carrier Error SSB');


N = length(t);
f = linspace(-fs/2, fs/2, N);

figure;
subplot(5,1,1);plot(f, abs(fftshift(fft(mt1)))/N);
subplot(5,1,2);plot(f, abs(fftshift(fft(usb)))/N);
subplot(5,1,3);plot(f, abs(fftshift(fft(I)))/N);
subplot(5,1,4);plot(f, abs(fftshift(fft(rec1_ssb)))/N);
subplot(5,1,5);plot(f, abs(fftshift(fft(rec1_qam)))/N);


figure;
subplot(5,1,1); plot(f, abs(fftshift(fft(mt2)))/N);
subplot(5,1,2); plot(f, abs(fftshift(fft(lsb)))/N);
subplot(5,1,3); plot(f, abs(fftshift(fft(Q)))/N);
subplot(5,1,4);plot(f, abs(fftshift(fft(rec2_ssb)))/N);
subplot(5,1,5);plot(f, abs(fftshift(fft(rec2_qam)))/N);


figure;
subplot(4,1,1); plot(f, abs(fftshift(fft(m1_errI)))/N);
subplot(4,1,2); plot(f, abs(fftshift(fft(m2_errQ)))/N);
subplot(4,1,3);plot(f, abs(fftshift(fft(m1_erru)))/N);
subplot(4,1,4);plot(f, abs(fftshift(fft(m2_errl)))/N);

