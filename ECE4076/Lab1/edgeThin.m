function thinned = edgeThin(xedges, yedges)

% Find Direction of Gradient?
mygradsdir = atan2((yedges-256/2), (xedges-256/2));
magsq = (xedges-256/2).^2 + (yedges-256/2).^2;
mygradsabs = uint8(floor(sqrt(magsq)));
% Quantise Direction from 0 --> 7 giving 0 --> 2 Pi:
dirRnd = mod(floor((mygradsdir*180/pi())/45 + 0.5),4); % +0.5 for rounding

%Based on direction, compare edge with edge infront and behind.
%If edge is smaller than either other edge, remove edge.

imsize = size(xedges);
thinned = mygradsabs;
for i=2:imsize(1)-1
    for j=2:imsize(2)-1
        switch dirRnd(i,j)
        %Remember that for an image, first coordinate is Y, second is X.
%             case 0 % E&W Direction
%                 if (thinned(i,j) < thinned(i,j+1)) || (thinned(i,j) < thinned(i,j-1))
%                     thinned(i,j)=0;
%                 end
%             case 1 % NE & SW Direction
%                 if (thinned(i,j+1) < thinned(i+1,j+1)) || (thinned(i,j) < thinned(i-1,j-1))
%                     thinned(i,j)=0;
%                 end
%             case 2 % N & S
%                 if (thinned(i,j) < thinned(i+1,j)) || (thinned(i,j) < thinned(i-1,j))
%                     thinned(i,j)=0;
%                 end
%             case 3 % NW & SE
%                 if (thinned(i,j) < thinned(i-1,j+1)) || (thinned(i,j) < thinned(i+1,j-1))
%                     thinned(i,j)=0;
%                 end
            case 0 % E&W Direction
                if (thinned(i,j) < mygradsabs(i,j+1)) || (thinned(i,j) < mygradsabs(i,j-1))
                    thinned(i,j)=0;
                end
            case 1 % NE & SW Direction
                if (thinned(i,j+1) < mygradsabs(i+1,j+1)) || (thinned(i,j) < mygradsabs(i-1,j-1))
                    thinned(i,j)=0;
                end
            case 2 % N & S
                if (thinned(i,j) < mygradsabs(i+1,j)) || (thinned(i,j) < mygradsabs(i-1,j))
                    thinned(i,j)=0;
                end
            case 3 % NW & SE
                if (thinned(i,j) < mygradsabs(i-1,j+1)) || (thinned(i,j) < mygradsabs(i+1,j-1))
                    thinned(i,j)=0;
                end
                
%              case 0 % E&W Direction
%                 if ~(thinned(i,j) > mygradsabs(i,j+1)) && (thinned(i,j) > mygradsabs(i,j-1))
%                     thinned(i,j)=0;
%                 end
%             case 1 % NE & SW Direction
%                 if ~(thinned(i,j+1) > mygradsabs(i+1,j+1)) && (thinned(i,j) > mygradsabs(i-1,j-1))
%                     thinned(i,j)=0;
%                 end
%             case 2 % N & S
%                 if ~(thinned(i,j) > mygradsabs(i+1,j)) && (thinned(i,j) > mygradsabs(i-1,j))
%                     thinned(i,j)=0;
%                 end
%             case 3 % NW & SE
%                 if ~(thinned(i,j) > mygradsabs(i-1,j+1)) && (thinned(i,j) > mygradsabs(i+1,j-1))
%                     thinned(i,j)=0;
%                 end
        end
    end
end

absmax = max(max(thinned));
absmin = min(min(thinned));
factor =  255 ./ double(absmax-absmin);
thinned = (thinned - absmin) * factor; %Normalize 
thinned = uint8(floor(thinned));