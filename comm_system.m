clear
clc
close all 
load Hd1.mat

%%
%record the first audio and save it(a)
% we make it as comment to becuase we need no change in the recording
% voices

% aud1= audiorecorder(44100,16,1) ;
% disp("Begin speaking.");
% recordblocking(aud1,10);
% disp("End of recording.")
% aud1=getaudiodata(aud1);
% audiowrite('input1.wav', aud1, 44100);
% 
% 
% %record the second audio and save it
% aud2= audiorecorder(44100,16,1) ;
% disp("Begin speaking.");
% recordblocking(aud2,10);
% disp("End of recording.")
% aud2=getaudiodata(aud2);
% audiowrite('input2.wav', aud2,44100);

%%
%read the two audios
[audio_1, fs1] = audioread('input1.wav');
n1 = length(audio_1);
ts1 = 1 / fs1;

[audio_2, fs2] = audioread('input2.wav');
n2 = length(audio_2);
ts2 = 1 / fs2;
%(c)
% Plot the first audio signal , shifting zero at the center of the spectrum
f1 = (-n1/2 : n1/2 - 1) * fs1 / n1;
audio_1_ft = fft(audio_1, n1);

figure;
plot(f1, abs(fftshift(audio_1_ft)));
title('First audio signal before filtering frequency spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%plot the second audio sigal shifting zero at the center of spectrum
f2=(-n2/2:n2/2-1)*fs2/n2;
audio_2_ft=fft(audio_2,n2);
figure
plot(f2,abs(fftshift(audio_2_ft)));
title('second audio sigal before filtering feq spectrum');
xlabel('freq(HZ)');
ylabel('magnitude');

%apply low pass filter with fpass 4500 and fstop 5000 to each audio signal
first_audio_filtered= filter(Hd1,audio_1);
second_audio_filtered = filter(Hd1,audio_2);

%play the filtered audios
sound(first_audio_filtered,fs1,16)
pause(10)
sound(second_audio_filtered,fs2,16)
pause(10)

%plot the first audio filtered sigal shifting zero at the center of spectrum
first_audio_filtered_ft=fft(first_audio_filtered,n1);
figure
plot(f1,abs(fftshift(first_audio_filtered_ft)));
title('first audio filtered sigal feq spectrum');
xlabel('freq(HZ)');
ylabel('magnitude');

%plot the second audio filtered sigal shifting zero at the center of spectrum
second_audio_filtered_ft=fft(second_audio_filtered,n2);
figure
plot(f2,abs(fftshift(second_audio_filtered_ft)));
title('second audio filtered sigal feq spectrum');
xlabel('freq(HZ)');
ylabel('magnitude');
%%
%(d)
%define the time t
t=(0:ts1:ts1*(n1-1));
t= transpose(t);


%modulation
%shifted the the first audio filtered and plot it
first_audio_filtered_shifted = first_audio_filtered .*cos(2*pi*5500*t);
figure
plot(f1,abs(fftshift(fft(first_audio_filtered_shifted))));
title('the first audio after filtered and shifted');
xlabel('freq(HZ)');
ylabel('magnitude');

%shifted the the second audio filtered and plot it
second_audio_filtered_shifted = second_audio_filtered .*cos(2*pi*17000*t);
figure
plot(f2,abs(fftshift(fft(second_audio_filtered_shifted))));
title('the second audio after filtered and shifted');
xlabel('freq(HZ)');
ylabel('magnitude');

%make the transimited signal and plot it
zft=fft(first_audio_filtered_shifted,n1);
wft=fft(second_audio_filtered_shifted,n2);
sum=zft+wft;
figure
plot(f1,abs(fftshift(sum)));
title('the transimited signal');
xlabel('freq(HZ)');
ylabel('magnitude');

%%
%(e)
%demodulation
%recieve the first signal and save it
sum_td = ifft(sum);
out1 = sum_td.*(cos(2*pi*5500*t));
out1_final = 2*filter(Hd1,out1);
audiowrite('output1.wav',out1_final,44100);


%recieve the first signal and save it
out2 = sum_td.*(cos(2*pi*17000*t));
out2_final = 2*filter(Hd1,out2);
audiowrite('output2.wav',out2_final,44100);

%play yhe recived signals
sound(out1_final,44100)
pause(10)
sound(out2_final,44100)

%plot the recieved signals
out1_fd = (fft(out1_final));
out2_fd = (fft(out2_final));
figure 
plot(f1,abs(fftshift(out1_fd)))
title('the first signal after demodulation');
xlabel('freq(HZ)');
ylabel('magnitude');

figure 
plot(f2,abs(fftshift(out2_fd)))
title('the second signal after demodulation');
xlabel('freq(HZ)');
ylabel('magnitude');
