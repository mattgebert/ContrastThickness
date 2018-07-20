function [f, params, res] = lorentzFitN(xdata,ydata,N,guess,yOffsetFlag)
% Fits the data to N many Gaussian functions. Includes a fit for 3N+1 params
% with N*[x_0, width, amplitude] + yOffset


% Setup Anonymous Function
lorentz = @(param,xdata) param(3) ./ (1 + ((param(1) - xdata)./ param(2)).^2);
if yOffsetFlag == true
    if N == 1
        fit = @(param,xdata) lorentz(param(1,1:3),xdata) + param(2,1);
    elseif N == 2
       fit = @(param,xdata) lorentz(param(1,1:3),xdata) + lorentz(param(2,1:3),xdata) + param(3,1);
    elseif N == 3
       fit = @(param,xdata) lorentz(param(1,1:3),xdata) + lorentz(param(2,1:3),xdata) + lorentz(param(3,1:3),xdata) + param(4,1);
    elseif N == 4
       fit = @(param,xdata) lorentz(param(1,1:3),xdata) + lorentz(param(2,1:3),xdata) + lorentz(param(3,1:3),xdata) + lorentz(param(4,1:3),xdata) + param(5,1);
    else
        error('N outside bounds, not made to fit more than 4 Lorentzians (1<N<4).')
    end
else
     if N == 1
        fit = @(param,xdata) lorentz(param(1,1:3),xdata); %+ param(2,1);
    elseif N == 2
       fit = @(param,xdata) lorentz(param(1,1:3),xdata) + lorentz(param(2,1:3),xdata); %+ param(3,1);
    elseif N == 3
       fit = @(param,xdata) lorentz(param(1,1:3),xdata) + lorentz(param(2,1:3),xdata) + lorentz(param(3,1:3),xdata);% + param(4,1);
    elseif N == 4
       fit = @(param,xdata) lorentz(param(1,1:3),xdata) + lorentz(param(2,1:3),xdata) + lorentz(param(3,1:3),xdata) + lorentz(param(4,1:3),xdata);% + param(5,1);
    else
        error('N outside bounds, not made to fit more than 4 Lorentzians (1<N<4).')
    end
end
    
% Setup initial lorentzian peaks
s = size(guess);
if s(1) ~= N + 1
    error('Need to specify 3N + 1 initial values')
end
options = optimset('lsqcurvefit');
options.MaxIter = 1e7;
options.MaxFunEvals = 1e7; 
options.DiffMinChange = 0.01; % options.FinDiffRelStep = 
% options.Algorithm = 'levenberg-marquardt';
options.Algorithm = 'trust-region-reflective';
[x, resnorm, ~, ~, ~] = lsqcurvefit(fit, guess, xdata, ydata, [], [], options);

% Return Anon func and params
f = fit;
params = x;
res = resnorm;