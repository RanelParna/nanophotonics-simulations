input_file='TM_E_layers.dat';
output_transmission='TM_E_trans.txt';
%output_peaks='C:\nanofotoonika\MATLAB\TM_E_peaks.txt';  %!!!
output_peaks='TM_E_peaks.txt';
output_waves='TM_E_waves.txt';

% generalised input from file for arbitrary numbner of layers
load (input_file);

% !!! ############################ Beginning the changes ###########################
% !!! ############################# Beginning the cycle ############################
% "rca" means "Relative Concentration of Aluminium in Aluminium Gallium Arsenide"
DesiredWavelengthWasFound=0;
for rca=0:0.05:1

%   "pot" means "Potential which is considered to be equal to the bandgap energy 
%                of the material containing Aluminium at the
%                relative concentration "rca".
%   The bandgap of Al(rca)Ga(rca-1)As at the room temperature (300 K)
%                in electronvolts (eV) is given by the following formula:
if rca<0.45
    pot=1.424+1.247*rca;
else
    pot=1.9+0.125*rca+0.143*rca*rca;
end

ElectronEffectiveMass=0.067+0.083*rca;

TM_E_layers(2,3)=pot;
TM_E_layers(2,4)=ElectronEffectiveMass;

TM_E_layers(4,3)=pot;
TM_E_layers(4,4)=ElectronEffectiveMass;
% !!! ############################ End of changes ###########################

layer = TM_E_layers(:,1)
L = TM_E_layers(:,2)*1e-9  %distance array (nm)
V = TM_E_layers(:,3)       %potential array
meff  = TM_E_layers(:,4)   %effective mass array
meff_max=max(meff);
Vmax=max(V);
N=max(layer);			%number of layers

% !!! ===================== Beginning the changes ======================
% !!! Emin=0.0;               %minimum particle energy (eV)
% !!! Emax=0.3;               %maximum particle energy (eV)		
% !!! npoints=100000;         %number of points in energy plot

Emin=1.4;
Emax=1.5;
npoints=100000;
% !!! ====================== End of changes =======================

% constants and parameters
dE=(Emax-Emin)/npoints;	%energy increment (eV)
hbar=1.0545715e-34;		%Planck's constant (Js)
eye=complex(0.,1.);		%square root of -1
m0=9.109382e-31;		%bare electron mass (kg)
m=meff*m0;				%effective electron mass (kg)
echarge=1.6021764e-19;	%electron charge (C)
    
%write input data to figure as a table
f = figure(1);
set (f,'Position',[200 200 400 300]);
cnames = {'Layer','L(nm)','V(ev)','m*'};
t = uitable('Parent',f,'Data',TM_E_layers,'ColumnName',cnames,'Position',[20 20 360 250]);

%main calculation of transmission parameters against energy
   for j=1:npoints
      E(j)=dE*j+Emin+pi*1e-5;   %add (pi*1.0e-5) to energy to avoid divide by zero
      bigP=[1,0;0,1];         %default value of matrix bigP 
      for i=1:N
         k(i)=sqrt(2*echarge*m(i)*(E(j)-V(i)))/hbar;	%wave number at each position in potential V(j)
      end
      for n=1:(N-1)
         fac = meff(n)*k(n+1)/(k(n)*meff(n+1));     %inclusion of varying effective mass
         p(1,1)=0.5*(1+fac)*exp(-eye*k(n)*L(n));
         p(1,2)=0.5*(1-fac)*exp(-eye*k(n)*L(n));
         p(2,1)=0.5*(1-fac)*exp(eye*k(n)*L(n));
         p(2,2)=0.5*(1+fac)*exp(eye*k(n)*L(n));
         bigP=bigP*p;
      end
      Trans(j)=(abs(1/bigP(1,1)))^2;                    %transmission probability
      TransPhase(j)=angle(1/bigP(1,1))*180/pi;          %transmitted phase
      Ref(j)=(abs(bigP(2,1)/bigP(1,1)))^2;              %reflection pro ability
      RefPhase(j)=angle(bigP(2,1)/bigP(1,1))*180/pi;    %reflected phase
   end
Tmin=min(Trans);    % min transmission for graph plotting
Tmax=max(Trans);    % !!! max transmission for graph plotting

% !!! ####################### Begin of changes ########################
% !!! This is the new location of "find peaks":
npeak=0;
for j=2:npoints-1
    % !!! Trans(j),E(j)
    if Trans(j)>Trans(j-1)
        if Trans(j)>Trans(j+1)
            npeak=npeak+1;
            Epeak(npeak)=E(j);
            Tpeak(npeak)=Trans(j);
        end
    end
end

for j=1:npeak
    wavelength=1240/Epeak(j);
    
    formatSpec = 'RCA=%f,V=%f,EEM=%f,WL=%f,E=%f';        
    str = sprintf(formatSpec,rca,pot,...
                  ElectronEffectiveMass,wavelength,Epeak(j));    
    disp(str);
    
    if wavelength>845 && wavelength<855  % !!!!
        DesiredWavelengthWasFound=1;
        rca_desired=rca;
        pot_desired=pot;
        ElectronEffectiveMass_desired=ElectronEffectiveMass;
        wavelength_desired=wavelength;
        break;
    end
end

if DesiredWavelengthWasFound>0
    break;
end

end  %End of "for rca=0:0.05:1"
% !!! ############################# End of cycle #########################
% !!! ############################ End of changes ########################
   
%plot potential, transmission and reflection coefficients
figure(2); 				
% generalised generation of potential-distance for 
% arbitrary number of input layers
Vp=[V';V'];Vp=Vp(:);
mp=[meff';meff'];mp=mp(:);
dx=1e-12;				%small distance increment used in potential plot
Lx(1)=L(1);
x1=L;
x2=L;
x1(1)=0;
x2(1)=Lx(1)-dx;
for i=2:N
   for j=2:i
      Lx(i)=L(j)+Lx(j-1);				%distance, x
   end
   x1(j)= Lx(j-1)
   x2(j) = Lx(j)- dx
end
x3=[x1';x2'];
xp=x3(:)*1e9;
maxL=Lx(N)*1e9;

subplot(3,3,1),plot(xp,Vp),axis([0,Lx(N)*1e9,0,1.2*Vmax]);
xlabel('Position, x (nm)'),ylabel('Potential energy, V(x) (eV)');

subplot(3,3,2),plot(xp,mp),axis([0,Lx(N)*1e9,0,meff_max*1.2]);
xlabel('Position, x (nm)'),ylabel('Effective mass m*');

subplot(3,3,4),plot(Trans,E),axis([0,1,Emin,Emax]);
xlabel('Transmission coefficient'),ylabel('Energy, E (eV)');

subplot(3,3,5),plot(log10(Trans),E),axis([log10(Tmin),0,Emin,Emax]);
% !!! ====================== Begin of changes ======================
if DesiredWavelengthWasFound>0
    formatSpec = 'RCA=%0.3f,V=%0.3f,EEM=%0.3f,WL=%0.3f';        
    str = sprintf(formatSpec,rca_desired,pot_desired,...
                  ElectronEffectiveMass_desired,wavelength_desired);
    xlabel(str),ylabel('Energy, E (eV)');
else
    xlabel('GaAs: log10(trans.coeff.)'),ylabel('Energy, E (eV)');
end
% !!! original: xlabel('log10(trans. coeff.)'),ylabel('Energy, E (eV)');
% !!! ====================== End of changes =======================

subplot(3,3,6),plot(TransPhase,E),axis([-180,180,Emin,Emax]);
xlabel('TransPhase'),ylabel('Energy, E (eV)');

subplot(3,3,7),plot(Ref,E),axis([0,1,Emin,Emax]);
xlabel('ref. coeff.'),ylabel('Energy, E (eV)');

subplot(3,3,9),plot(RefPhase,E),axis([-180,180,Emin,Emax]);
xlabel('RefPhase'),ylabel('Energy, E (eV)');

%output trans to file 
fileid=fopen(output_transmission,'w');
fprintf(fileid, '%s\t %s\t %s\t %s\t %s\n', 'E','log10(Trans)','TransPhase','Ref','RefPhase');
fprintf(fileid, '%f %f %f %f %f \r\n', [E; log10(Trans); TransPhase; Ref; RefPhase]);
fclose(fileid);

% !!! Here was the original location of "find peaks"

%output peaks to file 
fileid=fopen(output_peaks,'w');
fprintf(fileid, '%s\t %s\n', 'Epeak','Tpeak');
fprintf(fileid, '%f %f \r\n', [Epeak; Tpeak]);
fclose(fileid);

%find wavefunctions at peak energies VVV
%prepared for subplots depending on number of peaks detected;
figure(3);
peakplotrows=1;
if npeak>4
        peakplotrows=2;
end
if npeak>6
        peakplotrows=3;
end
if npeak>9
        peakplotrows=4;
end
peakplotcols=round(npeak/peakplotrows+0.5);

%first find complex transmission at peaks for initial waveform on RHS

%output waves to file 
fileid=fopen(output_waves,'w');
fprintf(fileid, '%s\t %s\n', 'position (nm)','wave');

for j=1:npeak
    E(j)=Epeak(j);
     	bigP=[1,0;0,1];	%default value of matrix bigP
       for i=1:N
        k(i)=sqrt(2*echarge*m(i)*(E(j)-V(i)))/hbar;	%wave number at each position in potential V(j)
       end
      for n=1:(N-1)
         fac = meff(n)*k(n+1)/(k(n)*meff(n+1));
         p(1,1)=0.5*(1+fac)*exp(-eye*k(n)*L(n));
         p(1,2)=0.5*(1-fac)*exp(-eye*k(n)*L(n));
         p(2,1)=0.5*(1-fac)*exp(eye*k(n)*L(n));
         p(2,2)=0.5*(1+fac)*exp(eye*k(n)*L(n));
         bigP=bigP*p;
      end

   % initial waveform on RHS layer N;
        A(N)=bigP(1,1); 
        B(N)=0;
        % subsequent waveforms from sucessive matrices;
       for nn=1:(N-1)
           n=N-nn;
           fac = meff(n)*k(n+1)/(k(n)*meff(n+1));
           p(1,1)=0.5*(1+fac)*exp(-eye*k(n)*L(n));
           p(1,2)=0.5*(1-fac)*exp(-eye*k(n)*L(n));
           p(2,1)=0.5*(1-fac)*exp(eye*k(n)*L(n));
           p(2,2)=0.5*(1+fac)*exp(eye*k(n)*L(n));
           A(n)= p(1,1)*A(n+1)+p(1,2)*B(n+1);
           B(n)= p(2,1)*A(n+1)+p(2,2)*B(n+1);
       end
      
layer=1;
xw(1)=0;
wf(1)=0;
xx=0;
for i = 2:1000
    xw(i) = xw(i-1)+maxL/1000;
    xx=xx+maxL/1000;
    wf(i) = real(A(layer)*exp(eye*k(layer)*xx*1e-9)+B(layer)*exp(-eye*k(layer)*xx*1e-9));
    if xx > L(layer)*1e9;
        layer=layer+1;
        xx=0;
    end
end

%output successive waves to same file
fprintf(fileid, '%f %f \r\n', [xw; wf]);

%plot each wave as subplot
wfmin=min(wf);
wfmax=max(wf);
subplot(peakplotrows,peakplotcols,j),plot(xw,wf),axis([0,Lx(N)*1e9,wfmin,wfmax]);
xlabel('position (nm)'),ylabel('wavefunction');
ttl = sprintf('peak %3.0f of %3.0f, E=%3.3f eV, Trans=%3.3f',j,npeak,Epeak(j),Tpeak(j));
title (ttl);
end  

fclose(fileid);
  
