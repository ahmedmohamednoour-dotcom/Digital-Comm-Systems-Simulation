function z = hilbm(x, fs)
    X = fft(x);  
    f = (0:length(X)-1) * (fs / length(X));
    
    H = zeros(size(f));
    H(f > 0) = -1i;
    H(f < 0) = 1i;
    
    X_Hilbert = X .* H;
    x_hilbert = ifft(X_Hilbert);
    
    z = x + 1i * x_hilbert;
end
