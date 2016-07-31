function varargout = contour( f, varargin )
%CONTOUR  contour plot of a DISKFUN.
%   CONTOUR(F) is a contour plot of F treating the values of F as heights above
%   a plane. A contour plot are the level curves of F for some values V. The
%   values V are chosen automatically.
%
%   CONTOUR(F, N) draw N contour lines, overriding the automatic number. The
%   values V are still chosen automatically.
%   
%   CONTOUR(F, V) draw LENGTH(V) contour lines at the values specified in vector
%   V. Use contour(F, [v, v]) to compute a single contour at the level v.
%
%  
%   [C, H] = contour(...) returns contour matrix C as described in CONTOURC and
%   a handle H to a contourgroup object.  This handle can be used as input to
%   CLABEL.
%
%   CONTOUR(F, 'NUMPTS', N) plots the contour lines on a N by N uniform grid. If
%   NUMPTS is not given then we plot on an 200 by 200 grid.
%
%   CONTOUR(F, 'PIVOTS', STR) plots the contour lines with the pivot locations
%   used during constructor.
%
% See also CONTOURF.

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

if ( isempty( f ) )  % Empty check.
    contour( [] );
    return
end

% Minimum number of plotting points:
minplotnum = 200;
doPivotPlot = 0; 

% Extract from the inputs the user defined options: 
j = 1; 
argin = {};
while ( ~isempty( varargin ) )
    if ( strcmpi( varargin{1}, 'numpts') ) % If given numpts then use them.
        minplotnum = varargin{2};
        varargin(1:2) = [];
    elseif ( strcmpi(varargin{1}, 'pivots') ) % If given numpts then use them.
        doPivotPlot = 1;
        if ( length( varargin ) < 2 ) 
            error('CHEBFUN:DISKFUN:contour:pivotStyle', ...
                'Pivot style undefined.')
        end
        argin{j} = varargin{2};
        varargin(1:2) = [];
    else
        argin{j} = varargin{1};
        varargin(1) = [];
        j = j+1;
    end
end

% Did the user want a plot of the pivot locations?
if ( doPivotPlot )    % Do pivot plot. 
    if ( ( ~isempty(argin) ) && ( length(argin{1}) < 5 ) )
        % Column, row, pivot plot
        plot( f, argin{:} ), hold on
        argin(1) = [];
        contour( f, argin{:} ), hold off
        return
    end
end

if ( isa(f, 'double') )                
    % CONTOUR(xx, yy, F,...)
    
    if ( (nargin >= 3) && isa(argin{1}, 'double') && isa(argin{2}, 'diskfun') )
        % Extract inputs:
        xx = f; 
        yy = argin{1}; 
        f = argin{2};
        argin(1:2) = [];
        % Evaluate separableApprox: 
        vals = feval(f, xx, yy, 'polar');
        
    else
        error('CHEBFUN:DISKFUN:contour:badInputs', ...
            'Unrecognised input arguments.');
    end
    
elseif ( isa(f, 'diskfun') ) 
    
    dom = f.domain;
    if ( (nargin == 3) || (nargin > 3) && ~isa(argin{1},'diskfun') ) 
        % CONTOUR(xx, yy, f)
        
        % Evaluate f at equally spaced points.
        x = linspace( dom(1), dom(2), minplotnum );
        y = linspace( dom(3), dom(4), minplotnum );
        [xx, yy] = meshgrid(x, y);
        vals = feval( f, xx, yy, 'polar' );

    elseif ( (nargin >= 3) && isa(argin{1},'diskfun') && isa(argin{2},'diskfun') )
        % CONTOUR plot on a surface.
        
        % Extract inputs:
        xx = f; 
        yy = argin{1}; 
        f = argin{2};
        argin(1:2) = [];
        
        % Check CONTOUR objects are on the same domain.
        if ( ~domainCheck(xx, yy) || ~domainCheck(yy, f) )
            error('CHEBFUN:DISKFUN:contour:domains', ...
                'Domains of DISKFUN objects are not consistent.');
        end
        
        % Evaluate f on equally spaced grid:
        x = linspace( dom(1), dom(2), minplotnum );
        y = linspace( dom(3), dom(4), minplotnum );
        [mxx, myy] = meshgrid(x, y);
        xx = feval(xx, mxx, myy); 
        yy = feval(yy, mxx, myy);
        vals = feval(f, mxx, myy, 'polar');

    elseif ( ( nargin == 1) || ( ( nargin > 1 ) && ( isa(argin{1},'double') ) ) )    
        % CONTOUR(f) 
        
        % Evaluate at equally spaced grid: 
        x = linspace( dom(1), dom(2), minplotnum );
        y = linspace( dom(3), dom(4), minplotnum );
        [xx, yy] = meshgrid(x, y);
        
       
        vals = feval(f, xx, yy, 'polar' );
        
       
        
    else
        error('CHEBFUN:DISKFUN:contour:inputs1', ...
            'Unrecognised input arguments.');
    end
    
else
    
    error('CHEBFUN:DISKFUN:contour:inputs2', ...
        'Unrecognised input arguments.');
    
end

 [X, Y] = pol2cart(xx, yy); 
% Contour plot:
[c, h] = contour( X, Y, vals, argin{:} );
axis square

%add unit circle
holdState = ishold; 
c = trigpts(100); 
hold on 
plot(cos(c*pi), sin(c*pi), 'k-', 'Linewidth', .3)
hold off

if holdState
     hold on;
else
    hold off;
end


% return plot handle if appropriate.
if ( nargout == 1 )
    varargout = {h};
elseif ( nargout == 2 )
    varargout = {c, h};
end

end
